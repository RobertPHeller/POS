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
#  Last Modified : <180106.1657>
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
    typecomponent cvv2LE
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
                      -modal local -side bottom -default 0 -cancel 1]
        $swipeask add ok -text OK -state disabled -command [mytypemethod _ok_swipeask]
        $swipeask add cancel -text Cancel -command [mytypemethod _cancel_swipeask]
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
        set cardtypeLE [LabelComboBox $frame.cardtypeLE \
                        -label "Card  type:" \
                        -textvariable [mytypevar cardtype] \
                        -values {AMEX Visa MasterCard Discover} -editable no]
        pack $cardtypeLE -expand yes -fill x
        set cvv2LE [LabelEntry $frame.cvv2LE \
                    -label "CVV2:" -textvariable [mytypevar cvv2]]
        pack $cvv2LE -expand yes -fill x
    }
    typemethod _ok_swipeask {} {
        set result [::PayPalObjects::CreditCard create %AUTO% \
                    -number $cardno \
                    -type   $cardtype \
                    -expiremonth $expmonth \
                    -expireyear $expyear \
                    -cvv2 $cvv2 \
                    -firstname $first \
                    -lastname $last]
        $swipeask withdraw
        return [$swipeask enddialog $result]
    }
    typemethod _cancel_swipeask {} {
        fileevent $reader readable {}
        $swipeask withdraw
        return [$swipeask enddialog {}]
    }
    typemethod open {readerdev} {
        if {[catch {SwipeReader $readerdev} reader]} {
            tk_messageBox -icon error -type ok -message "Could not open swiper: $reader"
        }
    }
    typemethod SwipeCard {} {
        fileevent $reader readable [mytypemethod _swipe]
        set cardno {}
        set expmonth {}
        set expyear {}
        set first {}
        set last {}
        set cardtype Visa
        set cvv2 {}
        $swipeask itemconfigure ok -state disabled
        set result [$swipeask draw]
        return $result
    }
    typemethod _swipe {} {
        set card [gets $reader]
        puts stderr "$type _swipe: card = $card"
        if {[regexp $CardPattern $card => cardno name expyearXX expmonthXX] > 0} {
            puts stderr "$type _swipe: cardno is $cardno, name is $name, expyearXX is $expyearXX, expmonthXX is $expmonthXX"
            if {![checkLuhn $cardno]} {
                tk_messageBox -icon warning -type ok -message "Invalid card number: $cardno!"
                return
            }
            set expyear  [format "20%2s" $expyearXX]
            set expmonth [scan $expmonthXX "%02d"]
            puts stderr "$type _swipe: expyear is $expyear, expmonth is $expmonth"
            if {[regexp $NamePattern1 $name => last first] < 1} {
                regexp $NamePattern2 $name => first last
            }
            switch [string range $cardno 0 0] {
                3 {set cardtype AMEX}
                4 {set cardtype Visa}
                5 {set cardtype MasterCard}
                6 {set cardtype Discover}
            }
            puts stderr "$type _swipe: first is $first, last is $last"
            fileevent $reader readable {}
            $swipeask itemconfigure ok -state enabled
        }
    }
    proc checkLuhn {purportedCC} {
        set sum 0
        set nDigits [string length $purportedCC]
        set parity  [expr {$nDigits % 2}]
        for {set i 0} {$i < $nDigits} {incr i} {
            set digit [string index $purportedCC $i]
            if {($ % 2) == $parity} {
                set digit [expr {$digit * 2}]
                if {$digit > 9} {
                    incr digit -9
                }
            }
            incr sum $digit
        }
        return [expr {($sum % 10) == 0}]
    }
}
    
package provide swipeAPI 1.0
