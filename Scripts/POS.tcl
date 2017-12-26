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
#  Last Modified : <171226.1210>
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
package require IconImage
package require LabelFrames
package require ParseXML
package require ReadConfiguration
package require paypalAPI
package require swipeAPI

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
    typecomponent productDB
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
        set ConfigurationBody [list ReadConfiguration::ConfigurationType \
                               [list "Product File" productFile infile products.xml] \
                               [list "Receipt Printer" receiptPrinter string ReceiptPrinter] \
                               [list "Card Swipe Device" cardSwipe string hiddev1] \
                               [list "PayPal URL" paypalURL string https://api.paypal.com] \
                               [list "PayPal ClientID" paypalClientID string ""] \
                               [list "PayPal Secret" paypalSecret string ""]]
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
        set Main [mainwindow .main -countvariable [mytypevar itemcount] \
                  -grandtotalvariable [mytypevar  grandtotalF]]
        pack $Main -fill both -expand yes
        bind all <Control-q> [mytypemethod CareFulExit]
        bind all <Control-Q> [mytypemethod CareFulExit]
        $Main menu delete file "Close"
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
        
        
        set frame [$Main scrollwindow getframe]
        set SalesCart [ScrollableFrame $frame.salesCart]
        $Main scrollwindow setwidget $SalesCart
        grid columnconfigure $SalesCart 0 -minsize 20 -weight 0
        grid columnconfigure $SalesCart 1 -minsize 50 -weight 0
        grid columnconfigure $SalesCart 2 -minsize 300 -weight 1
        grid columnconfigure $SalesCart 3 -minsize 60 -weight 0
        grid columnconfigure $SalesCart 4 -minsize 70 -weight 0
        grid columnconfigure $SalesCart 5 -minsize 20 -weight 0
        grid columnconfigure $SalesCart 6 -minsize 20 -weight 0
        set cartFrame [$SalesCart getframe]
        set AddFrame [$Main slideout add AddFrame]
        set newProd [LabelComboBox $AddFrame.newProdName \
                     -values [$type AllProductNames] \
                     -editable no -textvariable [mytypevar newProdName]]
        pack $newProd -expand yes -fill x
        set newProdName [lindex [$AddFrame.newProdName cget -value] 0]
        set newProdQ [LabelSpinBox $AddFrame.newProdQnt -range {1 99 1} -editable no -textvariable [mytypevar newProdQnt]]
        pack $newProdQ -expand yes -fill x
        set newProdQnt 1
        set newProdAddButton [ttk::button $AddFrame.newProdAdd -text "Add" -command [mytypemethod _AddProduct]]
        pack $newProdAddButton  -expand yes -fill x
        pack [ttk::separator $AddFrame.s1 -orient horizontal] -expand yes -fill x

        set _saleMode [labelframe $AddFrame.saleMode -text "Sale Mode" -labelanchor nw]
        pack $_saleMode -expand yes -fill x
        foreach rbVal [SaleMode cget -values] {
            set rb [ttk::radiobutton $_saleMode.$rbVal \
                    -text [string totitle $rbVal] -value $rbVal \
                    -variable [mytypevar saleMode]]
            pack $rb -side left
        }
        set checkOutButton [ttk::button $AddFrame.checkOutButton \
                            -text "Checkout" \
                            -command [mytypemethod _Checkout]]
        pack $checkOutButton -expand yes -fill x
        $Main slideout show AddFrame
        ::paypalAPI GetAccessToken
        $Main showit
    }
    typemethod CareFulExit {} {
        ::exit
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
        ttk::label $SalesCart.price$indexcount -text  [format {$%4.2f} $price]  -anchor e
        grid  $SalesCart.price$indexcount -row $row -column 3 -sticky news
        set extend [expr {$price * $newProdQnt}]
        ttk::label $SalesCart.extend$indexcount -text  [format {$%6.2f} $extend] \
              -anchor e
        grid $SalesCart.extend$indexcount -row $row -column 4 -sticky news 
        set grandtotal [expr {$grandtotal + $extend}] 
        set grandtotalF [format {$%5.2f} $grandtotal]
        ttk::button $SalesCart.del$indexcount -text "x" -width 1 -command [mytypemethod _deleteItem $indexcount]
        grid $SalesCart.del$indexcount -row $row -column 5 -sticky news
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
                             -creditcard [::Swipe::SwipeCard]]]
            }
        }
        set payment [::PayPalObjects::Payment create %AUTO% \
                     -intent sale \
                     -payer $payer \
                     -transactions [list $trans] \
                     ]
        puts stderr "*** $type _Checkout: [$payment JSon]"
    }
}

