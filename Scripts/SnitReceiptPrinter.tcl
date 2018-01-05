#*****************************************************************************
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Thu Jan 4 19:47:45 2018
#  Last Modified : <180104.2059>
#
#  Description	
#
#  Notes
#
#  History
#	
#*****************************************************************************
#
#    Copyright (C) 2018  Robert Heller D/B/A Deepwoods Software
#			51 Locke Hill Road
#			Wendell, MA 01379-9728
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# 
#
#*****************************************************************************


package require snit
package require Tk

snit::type POSReceiptPrinter {
    typevariable printerInitializeCommand {0x1b 0x40}
    typevariable cashDrawerEject_1 {0x1b 0x70 0 0x40 0x50}
    typevariable cashDrawerEject_2 {0x1b 0x70 1 0x40 0x50}
    typevariable rasterModeStartCommand {0x1d 0x76 0x30 0}
        
    component deviceChan
    constructor {deviceName args} {
        if {[catch {open $deviceName w} deviceChan]} {
            set errorMessage "Could not open $deviceName: $deviceChan"
            unset deviceChan
            error $errorMessage
        }
        #$self configurelist $args
        $self outputCommand $printerInitializeCommand
    }
    destructor {
        $self outputCommand $printerInitializeCommand
        close $deviceChan
    }
    method textLine {text} {
        puts $deviceChan $text
    }
    proc onebytepixels {imageArray} {
        set result [list]
        foreach row $imageArray {
            set rowresult [list]
            foreach pixel $row {
                if {[regexp {#[[:xdigit:]]{6}} $pixel] > 0} {
                    scan $pixel {#%2x%2x%2x} red green blue
                    lappend rowresult [expr {($red+$green+$blue)/3}]
                } elseif {[regexp {#[[:xdigit:]]{2}} $pixel] > 0} {
                    scan $pixel {#%2x} gray
                    lappend rowresult $gray
                }
            }
            lappend result $rowresult
        }
        return $result
    }
                
    method imageBlock {image} {
        set data [onebytepixels [$image data -grayscale]]
    }
    method putchar {c} {
        puts -nonewline $deviceChan "[format %c $c]"
    }
    method outputarray {array} {
        foreach byte $array {
            $self putchar $byte
        }
    }
    method outputCommand {command} {
        $self outputarray $command
    }
    proc lo {val} {
        return [expr {$val & 0x0FF}]
    }
    proc hi  {val} {
        return [expr {($val >> 8) & 0x0FF}]
    }
    method rasterheader {xsize ysize} {
        $self outputCommand $rasterModeStartCommand
        $self putchar [lo $xsize]
        $self putchar [hi $xsize]
        $self putchar [lo $ysize]
        $self putchar [hi $ysize]
    }
    method skiplines {size} {
        $self putchar 0x1b
        $self putchar 0x4a
        $self putchar size
    }
    method EndPage {} {
        skiplines 0x18
    }
}

