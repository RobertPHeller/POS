#*****************************************************************************
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Tue Dec 26 13:20:43 2017
#  Last Modified : <171226.2039>
#
#  Description	
#
#  Notes
#
#  History
#	
#*****************************************************************************
#
#    Copyright (C) 2017  Robert Heller D/B/A Deepwoods Software
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
package require pdf4tcl
package require IconImage
package require paypalAPI


snit::type ReceiptPrinter {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no
    typevariable currentReceipt {}
    typevariable pageWidth 0
    typevariable headerId {}
    typevariable imgPrintHeight 0
    typevariable receiptId {}
    typevariable receiptTimeStamp
    typemethod printReceipt {payment {printer {ReceiptPrinter}}} {
        #-file "|lp -d $printer" 
        set currentReceipt [pdf4tcl::new %AUTO% -paper letter \
                            -landscape false \
                            -orient true \
                            -margin [list .1i .1i .1i .1i] \
                            -file "receipt.pdf" \
                            ]
        set pageWidth [lindex [$currentReceipt getDrawableArea] 0]
        set pageWidth [expr {$pageWidth - (2*[::pdf4tcl::getPoints .1i])}]
        set paymentMethod [[$payment cget -payer] cget -paymentmethod]
        set receiptId [$payment cget -id]
        set receiptTimeStamp [clock scan [$payment cget -createtime] \
                              -format {%Y-%m-%dT%H:%M:%SZ} -gmt yes]
        set items [[[lindex [$payment cget -transactions] 0] cget -itemlist] cget -items]
        set img [IconImage image largeHeader]
        set headerId [$currentReceipt addRawImage [$img data]]
        set hwidth [image width $img]
        set hheight [image height $img]
        set scale [expr {double(double($pageWidth) / $hwidth)}]
        set imgPrintHeight [expr {$scale * $hheight}]
        #puts stderr "*** $type printReceipt: hwidth = $hwidth, hheight = $hheight, scale = $scale, imgPrintHeight = $imgPrintHeight"
        if {$paymentMethod eq "creditcard"} {
            set cc [[lindex [[$payment cget -payer] cget -fundinginstruments] 0] cget -creditcard]
            set n [$cc cget -number]
            set nStar "************[string range $n 12 end]"
            $type putBasicPage $items "Credit Card Sale $nStar"
            $type putSignature $cc
            $currentReceipt startPage
            $type putBasicPage $items "Credit Card Sale $nStar"
        } else {
            $type putBasicPage $items "Cash Sale"
        }
        $currentReceipt destroy
        set currentReceipt {}
    }
    typemethod putBasicPage {items footer} {
        $currentReceipt putImage $headerId .1i .1i -width $pageWidth
        set hp [expr {$imgPrintHeight + [::pdf4tcl::getPoints .1i]}]
        set curp [expr {$hp + [::pdf4tcl::getPoints .2i]}]
        #puts stderr "*** $type putBasicPage: hp = $hp, curp = $curp"
        set i 0
        set total 0
        $currentReceipt setFont 12 Courier
        $currentReceipt setTextPosition .1i $curp
        $currentReceipt setLineSpacing 1.2
        $currentReceipt setFillColor 0 0 0
        set line [clock format $receiptTimeStamp -format {%Y-%m-%d                %H:%M:%S}]
        $currentReceipt text $line
        $currentReceipt newLine 3
        set line [format {Receipt Id: %-60s} $receiptId]
        $currentReceipt text $line
        $currentReceipt newLine 2
        set line [format {%2s %2s %-60s  %5s  %6s} No Q Descr Price Extend]
        $currentReceipt text $line
        $currentReceipt newLine
        foreach item $items {
            incr i
            set q [$item cget -quantity]
            set p [expr {[$item cget -price]+[$item cget -tax]}]
            set e [expr {$q * $p}]
            set n [$item cget -name]
            set line [format {%2d %2d %-60s $%5.2f $%6.2f} $i $q $n $p $e]
            $currentReceipt text $line
            $currentReceipt newLine
            set total [expr {$total + $e}]
        }
        set line [string repeat "-" [expr {3+3+61+7+7}]]
        $currentReceipt text $line
        $currentReceipt newLine
        set line [format {%2d   %-60s         $%6.2f} $i Total $total]
        $currentReceipt text $line
        $currentReceipt newLine 2
        $currentReceipt text $footer
        $currentReceipt newLine
    }
    typemethod putSignature {cc} {
        set name "[$cc cget -firstname] [$cc cget -lastname]"
        $currentReceipt newLine 3
        $currentReceipt setFont 24 Courier
        set line [format {Name %30s} $name]
        $currentReceipt text $line
        $currentReceipt newLine 2
        set line "     [string repeat {_} 30]"
        $currentReceipt text $line
    }
}

package provide receiptPrinter 1.0
