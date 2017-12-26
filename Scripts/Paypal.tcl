#*****************************************************************************
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Sat Dec 23 20:50:14 2017
#  Last Modified : <171226.0908>
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
package require tls
package require http 2.7
http::register https 443 ::tls::socket
package require json
package require ReadConfiguration
package require base64

namespace eval PayPalObjects {
    proc String2JSon {s} {
        set result "\""
        foreach c [split $s {}] {
            if {$c in {\" \\}} {
                    append result "\\" $c
            } elseif {$c eq "\/"} {
                append result "\\/"
            } elseif {$c eq "\b"} {
                append result "\\b"
            } elseif {$c eq "\f"} {
                append result "\\f"
            } elseif {$c eq "\n"} {
                append result "\\n"
            } elseif {$c eq "\r"} {
                append result "\\r"
            } elseif {$c eq "\t"} {
                append result "\\t"
            } elseif {[string compare $c " "] < 0} {
                append result [format "\\u%04x" [scan $c %c]]
            } else {
                append result $c
            }
        }
        append result "\""
        return $result
    }
    snit::macro ::PayPalObjects::validation {} {
        typemethod validate {o} {
            if {[catch {$o info type} otype]} {
                error "Not a $type: $o"
            } elseif {$otype ne $type} {
                error "Not a $type: $o"
            } else {
                return $o
            }
        }
    }
    snit::macro ::PayPalObjects::validationOrNull {} {
        typemethod validate {o} {
            if {$o eq {}} {
                return $o
            } elseif {[catch {$o info type} otype]} {
                error "Not a $type: $o"
            } elseif {$otype ne $type} {
                error "Not a $type: $o"
            } else {
                return $o
            }
        }
    }
    snit::macro ::PayPalObjects::JSonType {} {
        method JSon {} {
            set result [format {%c} 123];# open brace
            set comma ""
            foreach o [$self configure] {
                #puts stderr "*** $self JSon: o = $o"
                lassign $o opt jsonname class default value
                #puts stderr "*** $self JSon: opt = $opt"
                #puts stderr "*** $self JSon: jsonname = $jsonname"
                #puts stderr "*** $self JSon: class = $class"
                #puts stderr "*** $self JSon: default = $default"
                #puts stderr "*** $self JSon: value = $value"
                if {$value ne {}} {
                    if {$comma ne ""} {
                        append result "$comma \n"
                    }
                    set comma ","
                    append result "[::PayPalObjects::String2JSon $jsonname]: "
                    if {[catch {$value JSon} jsopt]} {
                        if {[catch {snit::listtype validate $value}]} {
                            append result [::PayPalObjects::String2JSon $value]
                        } elseif {[catch {[lindex $value 0] JSon}]} {
                            append result [::PayPalObjects::String2JSon $value]
                        } else {
                            append result [format {%c} 91];# open bracket
                            set comma1 ""
                            foreach i $value {
                                if {$comma1 ne ""} {
                                    append result "$comma1 \n"
                                }
                                set comma1 ","
                                append result [$i JSon]
                            }
                            append result [format {%c} 93];# close bracket
                        }
                    } else {
                        append result $jsopt
                    }
                }
            }
            append result [format {%c} 125];# close brace
            return $result
        }
    }
    snit::integer ExpireMonth -min 1 -max 12
    snit::integer ExpireYear -min 1900 -max 2999
    snit::type Address {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option -line1
        option -line2
        option -city
        option {-countrycode countryCode CountryCode}
        option {-postalcode postalCode PostalCode}
        option -state
        option {-normalizationstatus normalizationStatus NormalizationStatus}
        option -status
        option -phone
        option -type
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Links {
        ::PayPalObjects::validation
        ::PayPalObjects::JSonType
        option -href
        option -rel
        option {-targetschema targetSchema TargetSchema} -type ::PayPalObjects::HyperSchema
        option -method
        option -enctype
        option -schema -type ::PayPalObjects::HyperSchema
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::listtype LinksList -type ::PayPalObjects::Links
    snit::type CreditCard {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option -id
        option -number
        option -type
        option {-expiremonth expireMonth ExpireMonth} -type ::PayPalObjects::ExpireMonth -default 1
        option {-expireyear expireYear ExpireYear} -type ::PayPalObjects::ExpireYear -default 1900
        option -cvv2
        option {-firstname firstName FirstName}
        option {-lastname lastName LastName}
        option {-billingaddress billingAddress BillingAddress} -type ::PayPalObjects::Address
        option {-externalcustomerid externalCustomerId ExternalCustomerId}
        option -state
        option {-validuntil validUntil ValidUntil}
        option -links -type ::PayPalObjects::LinksList
        option {-payerid payerId PayerId}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type CreditCardToken {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-creditcardid creditCardId CreditCardId}
        option {-payerid payerId PayerId}
        option -last4
        option -type
        option {-expiremonth expireMonth expireMonth} -type ::PayPalObjects::ExpireMonth -default 1
        option {-expireyear expireYear expireYear} -type ::PayPalObjects::ExpireYear -default 1900
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::stringtype ExpireMonth2Digit -regexp {[[:digit:]][[:digit:]]}
    snit::stringtype ExpireYear4Digit -regexp {[[:digit:]][[:digit:]][[:digit:]][[:digit:]]}
    snit::type CountryCode {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-countrycode countryCode CountryCode}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type PaymentCard {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option -id
        option -number
        option -type
        option {-expiremonth expireMonth ExpireMonth} -type ::PayPalObjects::ExpireMonth2Digit -default "01"
        option {-expireyear expireYear ExpireYear} -type ::PayPalObjects::ExpireYear4Digit -default "1900"
        option {-startmonth startMonth StartMonth}
        option {-startyear startYear StartYear}
        option -cvv2
        option {-firstname firstName FirstName}
        option {-lastname lastName LastName}
        option {-billingcountry billingCountry BillingCountry} -type ::PayPalObjects::CountryCode -default "us"
        option {-billingaddress billingAddress BillingAddress} -type ::PayPalObjects::Address
        option {-externalcustomerid externalCustomerId ExternalCustomerId}
        option -status
        option {-cardproductclass cardProductClass CardProductClass}
        option {-validuntil validUntil ValidUntil}
        option {-issuenumber issueNumber IssueNumber}
        option {-card3dsecureinfo card3dSecureInfo Card3dSecureInfo} -type ::PayPalObjects::Card3dSecureInfo
        option -links -type ::PayPalObjects::LinksList
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type ExtendedBankAccount {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-mandatereferencenumber mandateReferenceNumber MandateReferenceNumber}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type BankToken {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-bankid bankId BankId}
        option {-externalcustomerid externalCustomerId ExternalCustomerId}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Credit {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option -id
        option -type
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Incentive {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option -id
        option -code
        option -name
        option -description
        option {-minimumpurchaseamount minimumPurchaseAmount MinimumPurchaseAmount} -type ::PayPalObjects::Currency
        option {-logoimageurl logoImageUrl LogoImageUrl}
        option {-expirydate expiryDate ExpiryDate}
        option -type
        option -terms
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Details {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-subtotal subtotal Subtotal}
        option {-shipping shipping Shipping}
        option {-tax tax Tax}
        option {-handlingfee handlingFee HandlingFee}
        option {-shippingdiscount shippingDiscount ShippingDiscount}
        option {-insurance insurance Insurance}
        option {-giftwrap giftWrap GiftWrap}
        option {-fee fee Fee}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Amount {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-currency currency Currency}
        option {-total total Total}
        option {-details details Details} -type ::PayPalObjects::Details
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type ExternalFunding {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-referenceid referenceId ReferenceId}
        option {-code code Code}
        option {-fundingaccountid fundingAccountId FundingAccountId}
        option {-displaytext displayText DisplayText}
        option {-amount amount Amount} -type ::PayPalObjects::Amount
        option {-fundinginstruction fundingInstruction FundingInstruction}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type CarrierAccountToken {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-carrieraccountid carrierAccountId CarrierAccountId}
        option {-externalcustomerid externalCustomerId ExternalCustomerId}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type CarrierAccount {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-id id Id}
        option {-phonenumber phoneNumber PhoneNumber}
        option {-externalcustomerid externalCustomerId ExternalCustomerId}
        option {-phonesource phoneSource PhoneSource}
        option {-countrycode countryCode CountryCode} -type ::PayPalObjects::CountryCode
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type PrivateLabelCard {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-id id Id}
        option {-cardnumber cardNumber CardNumber}
        option {-issuerid issuerId IssuerId}
        option {-issuername issuerName IssuerName}
        option {-imagekey imageKey ImageKey}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Currency {                                              
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-currency currency Currency}
        option {-value value Value}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Percentage {                                              
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::integer Term -min 1
    snit::type InstallmentOption {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-term term Term} -type ::PayPalObjects::Term -default 12
        option {-monthlypayment monthlyPayment MonthlyPayment} -type ::PayPalObjects::Currency
        option {-discountamount discountAmount DiscountAmount} -type ::PayPalObjects::Currency
        option {-discountpercentage discountPercentage DiscountPercentage} -type ::PayPalObjects::Percentage
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Billing {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-billingagreementid billingAgreementId BillingAgreementId}
        option {-selectedinstallmentoption selectedInstallmentOption SelectedInstallmentOption} -type ::PayPalObjects::InstallmentOption
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type AlternatePayment {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-alternatepaymentaccountid alternatePaymentAccountId AlternatePaymentAccountId}
        option {-externalcustomerid externalCustomerId ExternalCustomerId}
        option {-alternatepaymentproviderid alternatePaymentProviderId AlternatePaymentProviderId}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type FundingInstrument {
        ::PayPalObjects::validation
        ::PayPalObjects::JSonType
        option {-creditcard creditCard CreditCard} -type ::PayPalObjects::CreditCard
        option {-creditcardtoken creditCardToken CreditCardToken} -type ::PayPalObjects::CreditCardToken
        option {-paymentcard paymentCard PaymentCard} -type ::PayPalObjects::PaymentCard
        option {-bankaccount bankAccount BankAccount} -type ::PayPalObjects::ExtendedBankAccount
        option {-bankaccounttoken bankAccountToken BankAccountToken} -type ::PayPalObjects::BankToken
        option -credit -type ::PayPalObjects::Credit
        option -incentive -type ::PayPalObjects::Incentive
        option {-externalfunding externalFunding ExternalFunding} -type ::PayPalObjects::ExternalFunding
        option {-carrieraccounttoken carrierAccountToken CarrierAccountToken} -type ::PayPalObjects::CarrierAccountToken
        option {-carrieraccount carrierAccount CarrierAccount} -type ::PayPalObjects::CarrierAccount
        option {-privatelabelcard privateLabelCard PrivateLabelCard} -type ::PayPalObjects::PrivateLabelCard
        option -billing -type ::PayPalObjects::Billing
        option {-alternatepayment alternatePayment AlternatePayment} -type ::PayPalObjects::AlternatePayment
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::listtype FundingInstrumentList -type ::PayPalObjects::FundingInstrument
    snit::type FundingOption {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type PayerInfo {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Payer {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-paymentmethod paymentMethod PaymentMethod}
        option -status
        option {-accounttype accountType AccountType}
        option {-accountage accountAge AccountAge}
        option {-fundinginstruments fundingInstruments FundingInstruments} -type ::PayPalObjects::FundingInstrumentList
        option {-fundingoptionid fundingOptionId FundingOptionId}
        option {-externalselectedfundinginstrumenttype externalSelectedFundingInstrumentType ExternalSelectedFundingInstrumentType}
        option {-relatedfundingoption relatedFundingOption RelatedFundingOption} -type ::PayPalObjects::FundingOption
        option {-payerinfo payerInfo PayerInfo} -type ::PayPalObjects::PayerInfo
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type StringList {
        ::PayPalObjects::validationOrNull
        variable elements [list]
        constructor {args} {
            set elements $args
        }
        method JSon {} {
            set result [format {%c} 91];# open bracket
            set comma1 ""
            foreach i $elements {
                if {$comma1 ne ""} {
                    append result "$comma1 \n"
                }
                set comma1 ","
                append result [::PayPalObjects::String2JSon $i]
            }
            append result [format {%c} 93];# close bracket
            return $result
        }
        method push_back {v} {
            lappend elements $v
        }
        method element {i} {
            return [lindex $elements $i]
        }
    }
    snit::type FmfDetails {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-filtertype filterType FilterType}
        option {-filterid filterId FilterId}
        option {-name name Name}
        option {-description description Description}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Sale {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-id id Id}
        option {-purchaseunitreferenceid purchaseUnitReferenceId PurchaseUnitReferenceId}
        option {-amount amount Amount}
        option {-paymentmode paymentMode PaymentMode}
        option {-state state State}
        option {-reasoncode reasonCode ReasonCode}
        option {-protectioneligibility protectionEligibility ProtectionEligibility}
        option {-protectioneligibilitytype protectionEligibilityType ProtectionEligibilityType}
        option {-clearingtime clearingTime ClearingTime}
        option {-paymentholdstatus paymentHoldStatus PaymentHoldStatus}
        option {-paymentholdreasons paymentHoldReasons PaymentHoldReasons} -type ::PayPalObjects::StringList
        option {-transactionfee transactionFee TransactionFee} -type ::PayPalObjects::Currency
        option {-receivableamount receivableAmount ReceivableAmount} -type ::PayPalObjects::Currency
        option {-exchangerate exchangeRate ExchangeRate}
        option {-fmfdetails fmfDetails FmfDetails} -type ::PayPalObjects::FmfDetails
        option {-receiptid receiptId ReceiptId}
        option {-parentpayment parentPayment ParentPayment}
        option {-processorresponse processorResponse ProcessorResponse} -type ::PayPalObjects::ProcessorResponse
        option {-billingagreementid billingAgreementId BillingAgreementId}
        option {-createtime createTime CreateTime}
        option {-links links Links} -type ::PayPalObjects::LinksList
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Authorization {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-id id Id}
        option {-amount amount Amount}  -type ::PayPalObjects::Amount
        option {-paymentmode paymentMode PaymentMode}
        option {-state state State}
        option {-reasoncode reasonCode ReasonCode}
        option {-protectioneligibility protectionEligibility ProtectionEligibility}
        option {-protectioneligibilitytype protectionEligibilityType ProtectionEligibilityType}
        option {-fmfdetails fmfDetails FmfDetails}  -type ::PayPalObjects::FmfDetails
        option {-parentpayment parentPayment ParentPayment}
        option {-validuntil validUntil ValidUntil}
        option {-createtime createTime CreateTime}
        option {-updatetime updateTime UpdateTime}
        option {-referenceid referenceId ReferenceId}
        option {-receiptid receiptId ReceiptId}
        option {-links links Links}  -type ::PayPalObjects::LinksList
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Order {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-id id Id}
        option {-purchaseunitreferenceid purchaseUnitReferenceId PurchaseUnitReferenceId}
        option {-referenceid referenceId ReferenceId}
        option {-amount amount Amount} -type ::PayPalObjects::Amount
        option {-paymentmode paymentMode PaymentMode}
        option {-state state State}
        option {-reasoncode reasonCode ReasonCode}
        option {-pendingreason pendingReason PendingReason}
        option {-protectioneligibility protectionEligibility ProtectionEligibility}
        option {-protectioneligibilitytype protectionEligibilityType ProtectionEligibilityType}
        option {-parentpayment parentPayment ParentPayment}
        option {-fmfdetails fmfDetails FmfDetails} -type ::PayPalObjects::FmfDetails
        option {-createtime createTime CreateTime}
        option {-updatetime updateTime UpdateTime}
        option {-links links Links}  -type ::PayPalObjects::LinksList
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Capture {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-id id Id}
        option {-amount amount Amount} -type ::PayPalObjects::Amount
        option {-isfinalcapture isFinalCapture IsFinalCapture} -type snit::boolean -default false
        option {-state state State}
        option {-reasoncode reasonCode ReasonCode}
        option {-parentpayment parentPayment ParentPayment}
        option {-invoicenumber invoiceNumber InvoiceNumber}
        option {-transactionfee transactionFee TransactionFee} -type ::PayPalObjects::Currency
        option {-createtime createTime CreateTime}
        option {-updatetime updateTime UpdateTime}
        option {-links links Links}  -type ::PayPalObjects::LinksList
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Refund {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-id id Id}
        option {-amount amount Amount} -type ::PayPalObjects::Amount
        option {-state state State}
        option {-reason reason Reason}
        option {-invoicenumber invoiceNumber InvoiceNumber}
        option {-saleid saleId SaleId}
        option {-captureid captureId CaptureId}
        option {-parentpayment parentPayment ParentPayment}
        option {-description description Description}
        option {-createtime createTime CreateTime}
        option {-updatetime updateTime UpdateTime}
        option {-reasoncode reasonCode ReasonCode}
        option {-links links Links}  -type ::PayPalObjects::LinksList
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type RelatedResources {
        ::PayPalObjects::validation
        ::PayPalObjects::JSonType
        option {-sale sale Sale} -type ::PayPalObjects::Sale
        option {-authorization authorization Authorization} -type ::PayPalObjects::Authorization
        option {-order order Order} -type ::PayPalObjects::Order
        option {-capture capture Capture} -type ::PayPalObjects::Capture
        option {-refund refund Refund} -type ::PayPalObjects::Refund
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::listtype RelatedResourcesList -type ::PayPalObjects::RelatedResources
    snit::type ExternalFunding {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-referenceid referenceId ReferenceId}
        option {-code code Code}
        option {-fundingaccountid fundingAccountId FundingAccountId}
        option {-displaytext displayText DisplayText}
        option {-amount amount Amount} -type ::PayPalObjects::Amount
        option {-fundinginstruction fundingInstruction FundingInstruction}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::listtype ExternalFundingList -type ::PayPalObjects::ExternalFunding
    snit::type Phone {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-countrycode countryCode CountryCode}
        option {-nationalnumber nationalNumber NationalNumber}
        option {-extension extension Extension}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Payee {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-email email Email}
        option {-merchantid merchantId MerchantId}
        option {-firstname firstName FirstName}
        option {-lastname lastName LastName}
        option {-accountnumber accountNumber AccountNumber}
        option {-phone phone Phone} -type ::PayPalObjects::Phone
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type PaymentOptions {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-allowedpaymentmethod allowedPaymentMethod AllowedPaymentMethod}
        option {-recurringflag recurringFlag RecurringFlag} -type snit::boolean -default false
        option {-skipfmf skipFmf SkipFmf} -type snit::boolean -default false
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Measurement {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-value value Value}
        option {-unit unit Unit}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type NameValuePair {
        ::PayPalObjects::validation
        ::PayPalObjects::JSonType
        option {-name name Name}
        option {-value value Value}
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::listtype NameValuePairList -type ::PayPalObjects::NameValuePair
    snit::type Item {
        ::PayPalObjects::validation
        ::PayPalObjects::JSonType
        option {-sku sku Sku}
        option {-name name Name}
        option {-description description Description}
        option {-quantity quantity Quantity}
        option {-price price Price}
        option {-currency currency Currency}
        option {-tax tax Tax}
        option {-url url Url}
        option {-category category Category}
        option {-weight weight Weight} -type ::PayPalObjects::Measurement
        option {-length length Length} -type ::PayPalObjects::Measurement
        option {-height height Height} -type ::PayPalObjects::Measurement
        option {-width width Width} -type ::PayPalObjects::Measurement
        option {-supplementarydata supplementaryData SupplementaryData} -type ::PayPalObjects::NameValuePairList
        option {-postbackdata postbackData PostbackData} -type ::PayPalObjects::NameValuePairList
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::listtype Items -type ::PayPalObjects::Item
    snit::type ShippingAddress {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-id id Id}
        option {-recipientname recipientName RecipientName}
        option {-defaultaddress defaultAddress DefaultAddress} -type snit::boolean -default false
        component address
        delegate option * to address
        constructor {args} {
            install address using ::PayPalObjects::Address %AUTO%
            $self configurelist $args
        }
    }
    snit::type ItemList {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        option {-items items Items} -type ::PayPalObjects::Items
        option {-shippingaddress shippingAddress ShippingAddress} -type ::PayPalObjects::ShippingAddress
        option {-shippingmethod shippingMethod ShippingMethod}
        option {-shippingphonenumber shippingPhoneNumber ShippingPhoneNumber}
        constructor {frame indexcount args} {
            $self configurelist $args
            for {set ii 1} {$ii <= $indexcount} {incr ii} {
                if {![winfo exists $frame.qnty$ii]} {continue}
                set q [$frame.qnty$ii get]
                set name [$frame.descr$ii cget -text]
                set f_price [$frame.price$ii cget -text]
                set f_extend [$frame.extend$ii cget -text]
                scan $f_price {$%4f} price
                scan $f_extend {$%6f} extend
                set price1 [expr {floor(($price / 1.0625)*100+.5)/100.0}]
                set tax    [expr {floor(($price1 * .0625)*100+.5)/100.0}]
                set item [::PayPalObjects::Item create %AUTO% \
                          -name $name -description $name \
                          -quantity $q -price $price1 -tax $tax]
                lappend options(-items) $item
            }
        }
    }
    snit::type Transaction {
        ::PayPalObjects::validation
        ::PayPalObjects::JSonType
        option {-relatedresources relatedResources RelatedResources} -type ::PayPalObjects::RelatedResourcesList
        option {-purchaseunitreferenceid purchaseUnitReferenceId PurchaseUnitReferenceId}
        option {-referenceid referenceId ReferenceId}
        option {-amount amount Amount} -type ::PayPalObjects::Amount
        option {-payee payee Payee} -type ::PayPalObjects::Payee
        option {-description description Description}
        option {-notetopayee noteToPayee NoteToPayee}
        option {-custom custom Custom}
        option {-softdescriptor softDescriptor SoftDescriptor}
        option {-softdescriptorcity softDescriptorCity SoftDescriptorCity}
        option {-paymentoptions paymentOptions PaymentOptions} -type ::PayPalObjects::PaymentOptions
        option {-itemlist itemList ItemList} -type ::PayPalObjects::ItemList
        option {-notifyurl notifyUrl NotifyUrl}
        option {-orderurl orderUrl OrderUrl}
        option {-externalfunding externalFunding ExternalFunding} -type ::PayPalObjects::ExternalFundingList
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::listtype TransactionList -type ::PayPalObjects::Transaction
    snit::type PotentialPayerInfo {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Error {
        ::PayPalObjects::validation
        ::PayPalObjects::JSonType
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::listtype ErrorList -type ::PayPalObjects::Error
    snit::type BillingAgreementToken {
        ::PayPalObjects::validation
        ::PayPalObjects::JSonType
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::listtype BillingAgreementTokenList -type ::PayPalObjects::BillingAgreementToken
    snit::type CreditFinancingOffered {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type PaymentInstruction {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type RedirectUrls {
        ::PayPalObjects::validationOrNull
        ::PayPalObjects::JSonType
        constructor {args} {
            $self configurelist $args
        }
    }
    snit::type Payment {
        ::PayPalObjects::validation
        ::PayPalObjects::JSonType
        option {-id id Id}
        option {-intent intent Intent}
        option {-payer payer Payer} -type ::PayPalObjects::Payer
        option {-potentialpayerinfo potentialPayerInfo PotentialPayerInfo} -type ::PayPalObjects::PotentialPayerInfo
        option {-payee payee Payee} -type ::PayPalObjects::Payee
        option {-cart cart Cart}
        option {-transactions transactions Transactions} -type ::PayPalObjects::TransactionList
        option {-failedtransactions failedTransactions FailedTransactions} -type ::PayPalObjects::ErrorList
        option {-billingagreementtokens billingAgreementTokens BillingAgreementTokens} -type ::PayPalObjects::BillingAgreementTokenList
        option {-creditfinancingoffered creditFinancingOffered CreditFinancingOffered} -type ::PayPalObjects::CreditFinancingOffered
        option {-paymentinstruction paymentInstruction PaymentInstruction} -type ::PayPalObjects::PaymentInstruction
        option {-state state State}
        option {-experienceprofileid experienceProfileId ExperienceProfileId}
        option {-notetopayer noteToPayer NoteToPayer}
        option {-redirecturls redirectUrls RedirectUrls} -type ::PayPalObjects::RedirectUrls
        option {-failurereason failureReason FailureReason}
        option {-createtime createTime CreateTime}
        option {-updatetime updateTime UpdateTime}
        option {-links links Links} -type ::PayPalObjects::LinksList
        constructor {args} {
            $self configurelist $args
        }
    }
}
snit::type paypalAPI {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no
    
    typevariable AppName {DWSLinuxTclPOS}
    
    typevariable URL {}
    typevariable ClientID {}
    typevariable Secret {}
    
    typevariable AccessDict -array {}

    typemethod GetAccessToken {} {
        set URL [::Configuration getoption paypalURL]
        set ClientID [::Configuration getoption paypalClientID]
        set Secret [::Configuration getoption paypalSecret]
        set url "$URL/v1/oauth2/token"
        set data "grant_type=client_credentials"
        set userPassword "$ClientID:$Secret"
        set headers [list \
                     Authorization "Basic [::base64::encode $userPassword]" \
                     Accept application/json \
                     Accept-Language en_US]
        set token [::http::geturl $url  \
                   -headers $headers -query $data]
        if {[::http::status $token] eq "ok"} {
            if {[::http::ncode $token] eq 200} {
                set result [::http::data $token]
                ::http::cleanup $token
                array set AccessDict [::json::json2dict $result]
                return true
            } else {
                ::http::cleanup $token
                return false
            }
        } else {
            ::http::cleanup $token
            return false
        }
    }
    
    typemethod MakeSale {payer transactions} {
    }
    
                
}


package provide paypalAPI 1.0
