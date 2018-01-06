#*****************************************************************************
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Sat Dec 23 12:19:53 2017
#  Last Modified : <180106.1837>
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

set argv0 [file join [file dirname [info nameofexecutable]] [file rootname [file tail [info script]]]]

package require Tk
package require tile
package require snit

package require MainWindow
package require ScrollableFrame
package require ScrollWindow
package require ROText
package require IconImage
package require LabelFrames
package require ParseXML
package require ReadConfiguration
package require paypalAPI
package require swipeAPI
package require receiptPrinter
package require sqlite3
package require Dialog
package require pdf4tcl

snit::enum SaleMode -values {cash card}
snit::type Product {
    typecomponent Main
    typecomponent SalesCart
    typecomponent AddFrame
    typevariable itemcount 0
    typevariable indexcount 0
    typevariable grandtotalF [format {$%5.2f} 0]
    typevariable grandtotal 0
    typevariable newProdName
    typevariable newProdQnt
    typevariable saleMode cash
    typevariable cashOnHand 0
    typevariable todaysTransactions [list]
    typecomponent productDB
    typecomponent AddFrame
    typecomponent checkOutButton
    typevariable AllProducts [list]
    typemethod PriceOfProduct {name} {
        foreach p $AllProducts {
            if {[string match $name [$p cget -name]]} {
                return [$p cget -price]
            }
        }
        return 0
    }
    typemethod AllProductNames {} {
        set result [list]
        foreach p $AllProducts {
            lappend result [$p cget -name]
        }
        return $result
    }
    option -name
    option -price
    constructor {args} {
        $self configurelist $args
        lappend AllProducts $self
    }
    
    typeconstructor {
        wm protocol . WM_DELETE_WINDOW [mytypemethod CareFulExit]
        set askCashDialog {}
        set ConfigurationBody [list ReadConfiguration::ConfigurationType \
                               [list "Product File" productFile infile products.xml] \
                               [list "Receipt Printer" receiptPrinter string /dev/RECEIPTS] \
                               [list "Card Swipe Device" cardSwipe string /dev/SWIPEEVENT] \
                               [list "PayPal URL" paypalURL string https://api.paypal.com] \
                               [list "PayPal ClientID" paypalClientID string ""] \
                               [list "PayPal Secret" paypalSecret string ""] \
                               [list "Sale Database" "saleDB" outfile sales.sqlite] \
                               [list "Cash Drawer" cashDrawer outfile cash.txt]]
        snit::type ::Configuration $ConfigurationBody
        ::Configuration load
        catch {
        set fp [open [::Configuration getoption productFile] r]
        set productDB [ParseXML %AUTO% [read $fp]]
        close $fp
        set POS [$productDB getElementsByTagName POS]
        if {$POS eq {}} {
            error "POS container missing"
        }
        set POS [lindex $POS 0]
        set products [$POS getElementsByTagName product]
        foreach p $products {
            set name [$p getElementsByTagName name]
            if {$name eq {}} {
                error "Name tag missing from product container"
            }
            set name [lindex $name 0]
            set name [$name data]
            set price [$p getElementsByTagName price]
            if {$price eq {}} {
                error "Price tag missing from product container"
            }
            set price [lindex $price 0]
            set price [$price data]
            $type create %AUTO% -name $name -price $price
        }}
        Swipe open [::Configuration getoption cardSwipe]
        sqlite3 SaleDB [::Configuration getoption saleDB]
        $type CreateSalesTables
        set Main [mainwindow .main -countvariable [mytypevar itemcount] \
                  -grandtotalvariable [mytypevar  grandtotalF]]
        pack $Main -fill both -expand yes
        bind all <Control-q> [mytypemethod CareFulExit]
        bind all <Control-Q> [mytypemethod CareFulExit]
        $Main menu entryconfigure file "Exit" -command [mytypemethod CareFulExit]
        $Main menu add options command \
              -label {Edit Configuration} \
              -command "::Configuration edit"
        
        $Main menu add options command \
              -label {Save Configuration} \
              -command "::Configuration save"
        
        $Main menu add options command \
              -label {Load Configuration} \
              -command {::Configuration load}
        $Main menu entryconfigure register "Cash Report" -command [mytypemethod CashReport screen]
        $Main menu entryconfigure register "Cash Out" -command [mytypemethod CashOut]
        $Main menu entryconfigure register "Add Cash" -command [mytypemethod AddCash]
        $Main menu entryconfigure register "Withdraw Cash" -command [mytypemethod WithdrawCash]
        set frame [$Main scrollwindow getframe]
        set SalesCart [ScrollableFrame $frame.salesCart]
        $Main scrollwindow setwidget $SalesCart
        grid columnconfigure $SalesCart 0 -minsize 20 -weight 0
        grid columnconfigure $SalesCart 1 -minsize 50 -weight 0
        grid columnconfigure $SalesCart 2 -weight 1;#-minsize 100
        grid columnconfigure $SalesCart 3 -minsize 60 -weight 0
        grid columnconfigure $SalesCart 4 -minsize 70 -weight 0
        grid columnconfigure $SalesCart 5 -minsize 20 -weight 0
        set cartFrame [$SalesCart getframe]
        set AddFrame [$Main slideout add AddFrame]
        set newProd [LabelComboBox $AddFrame.newProdName \
                     -values [$type AllProductNames] \
                     -editable no -textvariable [mytypevar newProdName]]
        pack $newProd -expand yes -fill x
        set newProdName [lindex [$AddFrame.newProdName cget -value] 0]
        bind all <p> [list focus $newProd]
        bind all <P> [list focus $newProd]
        set newProdQ [LabelSpinBox $AddFrame.newProdQnt -range {1 99 1} -editable no -textvariable [mytypevar newProdQnt]]
        pack $newProdQ -expand yes -fill x
        set newProdQnt 1
        set newProdAddButton [ttk::button $AddFrame.newProdAdd -text "Add" -command [mytypemethod _AddProduct]]
        pack $newProdAddButton  -expand yes -fill x
        bind $newProdAddButton <Return> [list $newProdAddButton invoke]
        $newProd bind <Return> [list $newProdAddButton invoke]
        pack [ttk::separator $AddFrame.s1 -orient horizontal] -expand yes -fill x
        set _saleMode [labelframe $AddFrame.saleMode -text "Sale Mode" -labelanchor nw]
        pack $_saleMode -expand yes -fill x
        foreach rbVal [SaleMode cget -values] {
            set rb [ttk::radiobutton $_saleMode.$rbVal \
                    -text [string totitle $rbVal] -value $rbVal \
                    -variable [mytypevar saleMode]]
            pack $rb -side left -expand yes -fill x
        }
        set checkOutButton [ttk::button $AddFrame.checkOutButton \
                            -text "Checkout" -state disabled \
                            -command [mytypemethod _Checkout]]
        pack $checkOutButton -expand yes -fill x
        bind all <c> [list  $checkOutButton invoke]
        bind all <C> [list  $checkOutButton invoke]
        set voidCartButton [ttk::button $AddFrame.voidCardButton \
                            -text "Void Cart" \
                            -command [mytypemethod _VoidCart]]
        pack $voidCartButton -expand yes -fill x
        bind all <v> [list  $voidCartButton invoke]
        bind all <V> [list  $voidCartButton invoke]
        $Main slideout show AddFrame
        #::paypalAPI GetAccessToken
        $Main showit
        if {[catch {open [::Configuration getoption cashDrawer] r} cashFP]} {
            set cashOnHand [$type askCash]
        } else {
            set cashOnHand [gets $cashFP]
            close $cashFP
        }
    }
    typemethod CashOut {} {
        if {![catch {open [::Configuration getoption cashDrawer] w} cashFP]} {
            puts $cashFP $cashOnHand
            close $cashFP
        }
        $type CashReport
        set todaysTransactions {}
    }
    typevariable _cashDrawer 0
    typemethod buildAskCashDialog {} {
        if {$askCashDialog ne {} && [winfo exists $askCashDialog]} {
            return
        }
        set askCashDialog [Dialog .askCashDialog -title "Initial cash" \
                           -modal local -bitmap questhead \
                           -transient yes -default 0 -cancel 1]
        $askCashDialog add ok -text {Ok} -command [mytypemethod _askCashOK]
        $askCashDialog add cancel -text {Cancel} \
              -command [mytypemethod _askCashCancel]
        set frame [$askCashDialog getframe]
        set cashEntry [LabelEntry $frame.cashEntry -label "Cash on hand:" \
                       -textvariable [mytypevar _cashDrawer]]
        pack $cashEntry  -expand yes -fill x
    }
    typemethod _askCashOK {} {
        $askCashDialog withdraw
        $askCashDialog enddialog ok
    }
    typemethod _askCashCancel {} {
        $askCashDialog withdraw
        $askCashDialog enddialog cancel
    }
    typecomponent askAddCashDialog
    typevariable _addCashAmount 0
    typemethod buildAskAddCashDialog {} {
        if {$askAddCashDialog ne {} && [winfo exists $askAddCashDialog]} {
            return
        }
        set askAddCashDialog [Dialog .askAddCashDialog -title "Add Cash" \
                              -modal local -bitmap questhead \
                              -transient yes -default 0 -cancel 1]
        $askAddCashDialog add ok -text {Ok} -command [mytypemethod _askAddCashOK]
        $askAddCashDialog add cancel -text {Cancel} -command [mytypemethod _askAddCashCancel]
        set frame [$askAddCashDialog getframe]
        set addCashEntry [LabelEntry $frame.addCashEntry -label "Add Cash:" \
                         -textvariable [mytypevar _addCashAmount]]
        pack $addCashEntry -expand yes -fill x
    }
    typemethod _askAddCashOK {} {
        $askAddCashDialog withdraw
        $askAddCashDialog enddialog ok
    }
    typemethod _askAddCashCancel {} {
        $askAddCashDialog withdraw
        $askAddCashDialog enddialog cancel
    }
    typemethod AddCash {} {
        $type buildAskAddCashDialog
        if {[$askAddCashDialog draw] eq "ok"} {
            set cashOnHand [expr {$cashOnHand + $_addCashAmount}]
            set transId [clock format [clock scan now] -format {ADDCASH%Y%m%d%H%M}]
            set createtime [clock format [clock scan now] -format {%Y-%m-%dT%H:%M:%SZ} -gmt yes]
            set total $_addCashAmount
            set subtotal $total
            set tax 0
            set sql "INSERT INTO Sale VALUES ("
            append sql "'$transId',"
            append sql "'$createtime',"
            append sql "'cashadd',"
            append sql "$total,"
            append sql "$subtotal,"
            append sql "$tax)"
            SaleDB eval $sql
            lappend todaysTransactions $transId
        }
    }
    typecomponent askWithdrawCashDialog
    typevariable _withdrawCashAmount 0
    typemethod buildAskWithdrawCashDialog {} {
        if {$askWithdrawCashDialog ne {} && [winfo exists $askWithdrawCashDialog]} {
            return
        }
        set askWithdrawCashDialog [Dialog .askWithdrawCashDialog -title "Add Cash" \
                              -modal local -bitmap questhead \
                              -transient yes -default 0 -cancel 1]
        $askWithdrawCashDialog add ok -text {Ok} -command [mytypemethod _askWithdrawCashOK]
        $askWithdrawCashDialog add cancel -text {Cancel} -command [mytypemethod _askWithdrawCashCancel]
        set frame [$askWithdrawCashDialog getframe]
        set addCashEntry [LabelEntry $frame.addCashEntry -label "Add Cash:" \
                         -textvariable [mytypevar _withdrawCashAmount]]
        pack $addCashEntry -expand yes -fill x
    }
    typemethod _askWithdrawCashOK {} {
        $askWithdrawCashDialog withdraw
        $askWithdrawCashDialog enddialog ok
    }
    typemethod _askWithdrawCashCancel {} {
        $askWithdrawCashDialog withdraw
        $askWithdrawCashDialog enddialog cancel
    }
    typemethod WithdrawCash {} {
        $type buildAskWithdrawCashDialog
        if {[$askWithdrawCashDialog draw] eq "ok"} {
            set cashOnHand [expr {$cashOnHand - $_withdrawCashAmount}]
            set transId [clock format [clock scan now] -format {WTHCASH%Y%m%d%H%M}]
            set createtime [clock format [clock scan now] -format {%Y-%m-%dT%H:%M:%SZ} -gmt yes]
            set total -$_withdrawCashAmount
            set subtotal $total
            set tax 0
            set sql "INSERT INTO Sale VALUES ("
            append sql "'$transId',"
            append sql "'$createtime',"
            append sql "'cashwth',"
            append sql "$total,"
            append sql "$subtotal,"
            append sql "$tax)"
            SaleDB eval $sql
            lappend todaysTransactions $transId
        }
    }
    typemethod CareFulExit {} {
        $type CashOut
        SaleDB close
        ::exit
    }
    typecomponent askCashDialog
    typevariable _cashDrawer 0
    typemethod buildAskCashDialog {} {
        if {$askCashDialog ne {} && [winfo exists $askCashDialog]} {
            return
        }
        set askCashDialog [Dialog .askCashDialog -title "Initial cash" \
                           -modal local -bitmap questhead \
                           -transient yes -default 0 -cancel 1]
        $askCashDialog add ok -text {Ok} -command [mytypemethod _askCashOK]
        $askCashDialog add cancel -text {Cancel} -command [mytypemethod _askCashCancel]
        set frame [$askCashDialog getframe]
        set cashEntry [LabelEntry $frame.cashEntry -label "Cash on hand:" \
                       -textvariable [mytypevar _cashDrawer]]
        pack $cashEntry  -expand yes -fill x
    }
    typemethod _askCashOK {} {
        $askCashDialog withdraw
        $askCashDialog enddialog ok
    }
    typemethod _askCashCancel {} {
        $askCashDialog withdraw
        $askCashDialog enddialog cancel
    }
    typemethod askCash {} {
        $type buildAskCashDialog
        if {[$askCashDialog draw] eq "ok"} {
            return $_cashDrawer
        } else {
            return 0
        }
    }
    typemethod _AddProduct {} {
        set row [lindex [grid size $SalesCart] 1]
        incr row
        incr itemcount
        incr indexcount
        ttk::label $SalesCart.count$indexcount -text $itemcount  -anchor w
        grid $SalesCart.count$indexcount -row $row -column 0 -sticky news
        spinbox $SalesCart.qnty$indexcount -width 2 -from 1 -to 99 \
              -increment 1 -command [mytypemethod _updateItem $indexcount]
        $SalesCart.qnty$indexcount set $newProdQnt
        grid $SalesCart.qnty$indexcount -row $row -column 1 -sticky news
        ttk::label $SalesCart.descr$indexcount -text $newProdName -anchor w
        grid $SalesCart.descr$indexcount -row $row -column 2 -sticky news
        set price [$type PriceOfProduct $newProdName]
        ttk::label $SalesCart.price$indexcount -text  [format {$%5.2f} $price]  -anchor e
        grid  $SalesCart.price$indexcount -row $row -column 3 -sticky news
        set extend [expr {$price * $newProdQnt}]
        ttk::label $SalesCart.extend$indexcount -text  [format {$%6.2f} $extend] \
              -anchor e
        grid $SalesCart.extend$indexcount -row $row -column 4 -sticky news 
        set grandtotal [expr {$grandtotal + $extend}] 
        set grandtotalF [format {$%6.2f} $grandtotal]
        ttk::button $SalesCart.del$indexcount -text "x" -width 1 -command [mytypemethod _deleteItem $indexcount]
        grid $SalesCart.del$indexcount -row $row -column 5 -sticky news
        set newProdQnt 1
        set newProdName [lindex [$AddFrame.newProdName cget -value] 0]
        $checkOutButton configure -state normal
    }
    typemethod _deleteItem {ic} {
        destroy $SalesCart.count$ic  $SalesCart.qnty$ic $SalesCart.descr$ic \
              $SalesCart.price$ic $SalesCart.extend$ic $SalesCart.del$ic
        set grandtotal 0
        for {set ii 1} {$ii <= $indexcount} {incr ii} {
            if {![winfo exists $SalesCart.qnty$ii]} {continue}
            if {$ii > $ic} {
                set idx [$SalesCart.count$ii cget -text]
                incr idx -1
                $SalesCart.count$ii configure -text $idx
            }
            set name [$SalesCart.descr$ii cget -text]
            set price [$type PriceOfProduct $name]
            set grandtotal [expr {$grandtotal + ($price * [$SalesCart.qnty$ii get])}]
        }
        set grandtotalF [format {$%5.2f} $grandtotal]
        incr itemcount -1
        if {$itemcount == 0} {
            $checkOutButton configure -state disabled
        }
        
    }
    typemethod _updateItem {ic} {
        set grandtotal 0
        for {set ii 1} {$ii <= $indexcount} {incr ii} {
            if {![winfo exists $SalesCart.qnty$ii]} {continue} 
            set q [$SalesCart.qnty$ii get]
            set name [$SalesCart.descr$ii cget -text]
            set price [$type PriceOfProduct $name]
            set extend [expr {$price * $q}]
            $SalesCart.extend$ii configure -text  [format {$%6.2f} $extend]
            set grandtotal [expr {$grandtotal + ($price * $q)}]
        }
        set grandtotalF [format {$%5.2f} $grandtotal]
    }
    typemethod _Checkout {} {
        set _il [::PayPalObjects::ItemList create %AUTO% $SalesCart $indexcount]
        #puts stderr "*** $type _Checkout: [$_il JSon]"
        set subtotal [expr {floor(($grandtotal / 1.0625)*100+.5)/100.0}]
        set tax      [expr {floor(($subtotal * .0625)*100+.5)/100.0}]
        set _amount [::PayPalObjects::Amount create %AUTO% -currency "USD" \
                     -total $grandtotal \
                     -details [::PayPalObjects::Details create %AUTO% \
                               -subtotal $subtotal -tax $tax]]
        set trans [::PayPalObjects::Transaction create %AUTO% \
                   -amount $_amount \
                   -itemlist $_il]
        #puts stderr "*** $type _Checkout: [$trans JSon]"
        set payer [::PayPalObjects::Payer create %AUTO%]
        switch $saleMode {
            cash {
                $payer configure -paymentmethod "cash"
            }
            card {
                $payer configure -paymentmethod "creditcard"
                $payer configure -fundinginstruments \
                      [list [::PayPalObjects::FundingInstrument create %AUTO% \
                             -creditcard [Swipe SwipeCard]]]
            }
        }
        set payment [::PayPalObjects::Payment create %AUTO% \
                     -intent sale \
                     -payer $payer \
                     -transactions [list $trans] \
                     ]
        switch $saleMode {
            cash {
                $payment configure -id [clock format [clock scan now] -format {CASH-%Y%m%d%H%M%S}]
                $payment configure -createtime [clock format [clock scan now] -format {%Y-%m-%dT%H:%M:%SZ} -gmt yes]
            }
            card {
                ## Swipe card and process payment
                #
                $payment configure -id [clock format [clock scan now] -format {CARD-%Y%m%d%H%M%S}]
                $payment configure -createtime [clock format [clock scan now] -format {%Y-%m-%dT%H:%M:%SZ} -gmt yes]
            }
        }
        #puts stderr "*** $type _Checkout: [$payment JSon]"
        if {$saleMode ne "cash"} {
            ReceiptPrinter printReceipt $payment yes
            tk_messageBox -icon info -type ok -message "Get Signature"
        }
        if {[tk_messageBox -icon question -type yesno -message "Print receipt?"] eq "yes"} {
            ReceiptPrinter printReceipt $payment
        }
        if {$saleMode eq "cash"} {
            set cashOnHand [expr {$cashOnHand + $grandtotal}]
        }
        tk_messageBox -type ok -message "Checkout complete."
        ## Add transaction to database
        $type AddSaleToDB $payment
        ## Clear out sales cart
        foreach c [winfo children $SalesCart] {
            destroy $c
        }
        set indexcount 0
        set itemcount 0
        set grandtotal 0
        $checkOutButton configure -state disabled
        set grandtotalF [format {$%5.2f} $grandtotal]
    }
    typemethod _VoidCart {} {
        ## Clear out sales cart
        foreach c [winfo children $SalesCart] {
            destroy $c
        }
        set indexcount 0
        $checkOutButton configure -state disabled
        set itemcount 0
        set grandtotal 0
        set grandtotalF [format {$%5.2f} $grandtotal]
    }
    typemethod CreateSalesTables {} {
        SaleDB eval {CREATE TABLE IF NOT EXISTS Sale 
            (transactionid TEXT NOT NULL UNIQUE PRIMARY KEY,
             createtime TEXT NOT NULL,
             paymentmethod TEXT NOT NULL,
             totalsale REAL NOT NULL,
             subtotal REAL NOT NULL,
             tax REAL NOT NULL)}
        SaleDB eval {CREATE TABLE IF NOT EXISTS Item 
            (transactionid TEXT NOT NULL,
             name TEXT NOT NULL,
             quantity INTEGER NOT NULL,
             price REAL NOT NULL,
             tax REAL NOT NULL)}
    }
    typemethod AddSaleToDB {payment} {
        set transId [$payment cget -id]
        set createtime [$payment cget -createtime]
        set paymentmethod [[$payment cget -payer] cget -paymentmethod]
        set trans [lindex [$payment cget -transactions] 0]
        set amount [$trans cget -amount]
        set total  [$amount cget -total]
        set details [$amount cget -details]
        set subtotal [$details cget -subtotal]
        set tax     [$details cget -tax]
        set sql "INSERT INTO Sale VALUES ("
        append sql "'$transId',"
        append sql "'$createtime',"
        append sql "'$paymentmethod',"
        append sql "$total,"
        append sql "$subtotal,"
        append sql "$tax)"
        SaleDB eval $sql
        set itemlist [$trans cget -itemlist]
        foreach item [$itemlist cget -items] {
            set sql "INSERT INTO Item VALUES ("
            append sql "'$transId',"
            append sql "'[quoteQ [$item cget -name]]',"
            append sql "[$item cget -quantity],"
            append sql "[$item cget -price],"
            append sql "[$item cget -tax])"
            SaleDB eval $sql
        }
        lappend todaysTransactions $transId
    }
    proc quoteQ {s} {
        return [regsub -all {'} $s {\'}]
    }
    typecomponent reportWindow
    typecomponent reportText
    typemethod buildReportWindow {} {
        if {[info exists reportWindow] && [winfo exists $reportWindow]} {
            destroy $reportWindow
            set reportWindow {}
        }
        set reportWindow [tk::toplevel .reportWindow]
        wm transient $reportWindow .
        set sw [ScrolledWindow $reportWindow.sw -auto vertical -scrollbar vertical]
        pack $sw -expand yes -fill both
        set reportText [ROText [$sw getframe].reportText]
        $sw setwidget $reportText
        pack [ttk::button $reportWindow.dismis -text "Dismis" \
              -command [list destroy $reportWindow]] -expand yes -fill x
    }
    typemethod CashReport {{format printer}} {
        if {$format in {screen both}} {
            $type buildReportWindow
        }
        if {[catch {ReceiptPrinter printReport $format $todaysTransactions $reportText $cashOnHand} err]} {
            tk_messageBox -icon warning -type ok -message $err
            $type CashReport screen
        }
    }
}

