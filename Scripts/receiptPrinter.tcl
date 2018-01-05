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
#  Last Modified : <180105.1418>
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
package require IconImage
package require paypalAPI
package require ReceiptPrinter
package require DWSLogo

snit::type ReceiptPrinter {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no
    
    typecomponent logo
    typecomponent printer
    
    typevariable receiptTimeStamp
    typevariable receiptId
    
    typeconstructor {
        set logo DWSLogo
    }
    typemethod printReceipt {payment {withSig no}} {
        if {[catch {set printer [POSReceiptPrinter create %AUTO% "/dev/RECEIPTS"]} err]} {
            error "Cannot open receipt printer (/dev/RECEIPTS): $err"
        }
        $printer internationCharSet usa
        $printer setAbsPrintPos 0
        $printer printRasterBitImage [$logo width] [$logo height] [$logo data]
        $printer printAndFeed 1
        $printer selectFontB
        set paymentMethod [[$payment cget -payer] cget -paymentmethod]
        set receiptId [$payment cget -id]
        set receiptTimeStamp [clock scan [$payment cget -createtime] \
                              -format {%Y-%m-%dT%H:%M:%SZ} -gmt yes]
        set items [[[lindex [$payment cget -transactions] 0] cget -itemlist] cget -items]
        #puts stderr "*** $type printReceipt: hwidth = $hwidth, hheight = $hheight, scale = $scale, imgPrintHeight = $imgPrintHeight"
        if {$paymentMethod eq "creditcard"} {
            set cc [[lindex [[$payment cget -payer] cget -fundinginstruments] 0] cget -creditcard]
            set n [$cc cget -number]
            set nStar "************[string range $n 12 end]"
            $type putBasicPage $items "Credit Card Sale $nStar"
        } else {
            $type putBasicPage $items "Cash Sale"
        }
        if {$withSig} {
            $type putSignature $cc
        }
        $printer destory
        set printer {}
    }
    typemethod putBasicPage {items footer} {
        set line [clock format $receiptTimeStamp -format {%Y-%m-%d  %H:%M:%S}]
        $printer textLine $line
        $printer printAndFeed 2
        set line [format {Receipt Id: %-30s} $receiptId]
        $printer textLine $line
        $printer printAndFeed 1
        set line [format {%2s %2s %-20.20s  %5s  %6s} No Q Descr Price Extend]
        $printer textLine $line
        foreach item $items {
            incr i
            set q [$item cget -quantity]
            set p [expr {[$item cget -price]+[$item cget -tax]}]
            set e [expr {$q * $p}]
            set n [$item cget -name]
            set line [format {%2d %2d %-20.20s $%5.2f $%6.2f} $i $q $n $p $e]
            $printer textLine $line
            set total [expr {$total + $e}]
        }
        set line [string repeat "-" [expr {3+3+21+7+7}]]
        $printer textLine $line
        set line [format {%2d   %-20.20s         $%6.2f} $i Total $total]
        $printer textLine $line
        $printer printAndFeed 5
    }
    typemethod putSignature {cc} {
        set name "[$cc cget -firstname] [$cc cget -lastname]"
        $printer printAndFeed 3
        $printer selectFontA
        set line [format {%32.32s} $name]
        $printer textLine $line
        $printer printAndFeed 2
        set line "[string repeat { } 32]"
        $printer underlineOnThick
        $printer textLine $line
        $printer underlineOff
        $printer printAndFeed 2
        $printer selectFontB
    }
    typemethod printReport {format todaysTransactions reportText cashOnHand} {
        set reporttotal      0
        set reportsubtotal   0
        set reporttax        0
        set cashintotal      0
        set creditintotal    0
        if {$format in {printer both}} {
            if {[catch {set printer [POSReceiptPrinter create %AUTO% "/dev/RECEIPTS"]} err]} {
                error "Cannot open receipt printer (/dev/RECEIPTS): $err"
            }
            $printer internationCharSet usa
            $printer setAbsPrintPos 0
            $printer printRasterBitImage [$logo width] [$logo height] [$logo data]
            $printer printAndFeed 1
            $printer selectFontB
        }
        set line [format {%19s %8s %4.4s %8s} "Transaction" "Time" "Mode" "Total"]
        if {$format in {printer both}} {
            $printer textLine $line
        }
        if {$format in {screen both}} {
            $reportText insert end "$line\n"
            $reportText see end
        }
        foreach trans $todaysTransactions {
            lassign [SaleDB eval \
                     "SELECT * FROM Sale where transactionid = '$trans'"] \
                    transId createtime paymentmethod total subtotal tax
            set reporttotal    [expr {$reporttotal + $total}]
            set cretime [clock format [clock scan $createtime -format {%Y-%m-%dT%H:%M:%SZ} -gmt yes] -format {%H:%M:%S}]
            switch $paymentmethod {
                cash {
                    set cashintotal [expr {$cashintotal + $total}]
                }
                creditcard {
                    set creditintotal [expr {$creditintotal + $total}]
                }
            }
            set line [format {%19s %8s %4.4s $%7.2f} $transId $createtime $paymentmethod $total]
            if {$format in {printer both}} {
                $printer textLine $line
            }
            if {$format in {screen both}} {
                $reportText insert end "$line\n"
                $reportText see end
            }
        }
        set line [format {%19s %8s %4.4s $%7.2f} "Total" {} {} $reporttotal]
        if {$format in {printer both}} {
            $printer textLine $line
        }
        if {$format in {screen both}} {
            $reportText insert end "$line\n"
            $reportText see end
        }
        set line [format {%19s %8s %4.4s $%7.2f} "Cash In Total" {} {} $cashintotal]
        if {$format in {printer both}} {
            $printer textLine $line
        }
        if {$format in {screen both}} {
            $reportText insert end "$line\n"
            $reportText see end
        }
        set line [format {%19s %8s %4.4s $%7.2f} "Credit In Total" {} {} $creditintotal]
        if {$format in {printer both}} {
            $printer textLine $line
        }
        if {$format in {screen both}} {
            $reportText insert end "$line\n"
            $reportText see end
        }
        set line [format {%19s %8s %4.4s $%7.2f} "Cash On Hand" {} {} $cashOnHand]
        if {$format in {printer both}} {
            $printer textLine $line
            $printer printAndFeed 5
            $printer destroy
        }
        if {$format in {screen both}} {
            $reportText insert end "$line\n"
            $reportText see end
        }
        
    }
}

package provide receiptPrinter 1.0
