#*****************************************************************************
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Tue Dec 26 12:07:26 2017
#  Last Modified : <180106.1250>
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
package require paypalAPI
package require Tclswipereader
package require Tk
package require tile
package require Dialog
package require LabelFrames

snit::type Swipe {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no
    typecomponent reader
    typecomponent swipeask
    typevariable  cardno
    typevariable  expmonth
    typevariable  expyear
    typevariable  first
    typevariable  last
    typevariable  cardtype
    typevariable  cvv2
    typevariable savedgrab
    typevariable savedgrabopt
    typevariable flag
    typevariable CardPattern {^%B([[:digit:]]+)\^([^^]+)\^([[:digit:]][[:digit:]])([[:digit:]][[:digit:]])[[:digit:]]*\?;[[:digit:]]+=[[:digit:]]+\?$}
    typevariable NamePattern1 {^([^/]+)/(.+)$}
    typevariable NamePattern2 {^(.+) ([^[:space:])$}
    typeconstructor {
        set reader {}
        set swipeask [Dialog .swipe -title "Swipe Card" \
                      -modal none -side bottom]
        $swipeask add dismis -text Dismis -state disabled -command [mytypemethod _dismis_swipeask]
        set frame [$swipeask getframe]
        set cardnoLE [LabelEntry $frame.cardnoLE -label "Card No.:" \
                      -state readonly -textvariable [mytypevar cardno]]
        pack $cardnoLE -expand yes -fill x
        set expireLF [LabelFrame $frame.expireLF -text "Expiration:"]
        pack $expireLF -expand yes -fill x
        pack [ttk::entry [$expireLF getframe].expmonth \
              -textvariable [mytypevar expmonth] \
              -state readonly] -side left
        pack [ttk::label [$expireLF getframe].slash \
              -text "/"] -side left
        pack [ttk::entry [$expireLF getframe].expyear \
              -textvariable [mytypevar expyear] \
              -state readonly] -side left -expand yes -fill x
        set nameLF [LabelFrame $frame.nameLF -text "Name on card:"]
        pack $nameLF -expand yes -fill x
        pack [ttk::entry [$nameLF getframe].f \
              -textvariable [mytypevar first] \
              -state readonly] -side left
        pack [ttk::label [$nameLF getframe].sp \
              -text " "] -side left
        pack [ttk::entry [$nameLF getframe].l \
              -textvariable [mytypevar last] \
              -state readonly] -side left -expand yes -fill x
        set cardtypeLE [LabelEntry $frame.cardtypeLE \
                        -label "Card  type:" \
                        -textvariable [mytypevar cardtype]]
        pack $cardtypeLE -expand yes -fill x
        set cvv2LE [LabelEntry $frame.cvv2LE \
                    -label "CVV2:" -textvariable [mytypevar cvv2]]
        pack $cvv2LE -expand yes -fill x
    }
    typemethod open {readerdev} {
        set reader [SwipeReader $readerdev]
    }
    typemethod SwipeCard {} {
        $swipeask draw
        update idle
        while {1} {
            set card [gets $reader]
            puts stderr "$type SwipeCard: card = $card"
            if {[regexp $CardPattern $card => cardno name expyearXX expmonthXX] > 0} {
                
                set expyear  [format "20%2s" $expyearXX]
                set expmonth [scan $expmonthXX "%02d"]
                if {[regexp $NamePattern1 $name => last first]} {
                    set card [::PayPalObjects::CreditCard create %AUTO% \
                              -expiremonth $expmonth \
                              -expireyear  $expyear \
                              -number      $cardno \
                              -firstname   $first \
                              -lastname    $last]
                } elseif {[regexp $NamePattern2 $name => first last]} {
                    set card [::PayPalObjects::CreditCard create %AUTO% \
                              -expiremonth $expmonth \
                              -expireyear  $expyear \
                              -number      $cardno \
                              -firstname   $first \
                              -lastname    $last]
                }
                ## get type and cvv2
                $swipeask itemconfigure dismis -state normal
                set savedgrab [grab current]
                if {[winfo exists $savedgrab]} {
                    set savedgrabopt [grab status $savedgrab]
                }
                grab $swipeask
                if {[info exists flag]} {unset flag}
                tkwait variable [mytypevar flag]
                $swipeask withdraw                
                $swipeask itemconfigure dismis -state disabled
                $card configure -type $cardtype
                $card configure -cvv2 $cvv2
                return $card
            }
        }
        
    }
}
    
package provide swipeAPI 1.0
