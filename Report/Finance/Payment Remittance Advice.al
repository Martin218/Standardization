report 50441 "Payment Remittance Advice"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Payment Remittance Advice.rdlc';

    dataset
    {
        dataitem(Integer;Integer)
        {
            MaxIteration = 1;
            column(CompInfo_Name;CompInfo.Name)
            {
            }
            column(CompInfo_Picture;CompInfo.Picture)
            {
            }
            column(REMITTANCE_ADVISECaptionLbl;REMITTANCE_ADVISECaptionLbl)
            {
            }
            column(CompanyInformation;STRSUBSTNO(TXT002,CompInfo.Address,CompInfo."Address 2",CompInfo.City))
            {
            }
            column(ContactInfo;STRSUBSTNO(Text001,CompInfo.Address,CompInfo."Address 2",CompInfo."Phone No.",CompInfo."E-Mail",CompInfo."Home Page",CompInfo."Company P.I.N"))
            {
            }
            column(SupplierName;STRSUBSTNO(Text004,Vendor.Name))
            {
            }
            column(SupplierInformation;STRSUBSTNO(Text003,Vendor.Address,Vendor."Post Code",Vendor.City,Vendor."E-Mail",Vendor."Phone No."))
            {
            }
            column(Bank_Account;STRSUBSTNO(Text005, KBACodes."KBA Code",KBACodes."KBA Name",Vendor."Bank Account",BankName."BAnk Name"))
            {
            }
            column(DateInvoiceCaptionLbl;DateInvoiceCaptionLbl)
            {
            }
            column(Date_Posted;RecPV."Date Posted")
            {
            }
            column(InvoiceCaptionLbl;InvoiceCaptionLbl)
            {
            }
            column(DescriptionCaptionLbl;DescriptionCaptionLbl)
            {
            }
            column(W_VATCaptionLbl;W_VATCaptionLbl)
            {
            }
            column(W_TaxCaptionLbl;W_TaxCaptionLbl)
            {
            }
            column(Gross_AmountCaptionLbl;Gross_AmountCaptionLbl)
            {
            }
            column(Net_AmountCaptionLbl;Net_AmountCaptionLbl)
            {
            }
            column(Bank_AccountCaptionLbl;Bank_AccountCaptionLbl)
            {
            }
            column(LineGross_AmountCaptionLbl;LineGross_AmountCaptionLbl)
            {
            }
            column(LineW_Tax_AmountCaptionLbl;LineW_Tax_AmountCaptionLbl)
            {
            }
            column(LineW_VAT_AmountCaptionLbl;LineW_VAT_AmountCaptionLbl)
            {
            }
            column(LineNet_AmountCaptionLbl;LineNet_AmountCaptionLbl)
            {
            }
            dataitem("Payment/Receipt Lines";"Payment/Receipt Lines")
            {
                column(AppliestoDocNo;"Payment/Receipt Lines"."External Document No")
                {
                }
                column(Description;"Payment/Receipt Lines".Description)
                {
                }
                column(KBACode;"Payment/Receipt Lines"."KBA Code")
                {
                }
                column(WTaxAmount;"Payment/Receipt Lines"."W/Tax Amount")
                {
                }
                column(VATWithheldAmount;"Payment/Receipt Lines"."VAT Withheld Amount")
                {
                }
                column(Amount;"Payment/Receipt Lines".Amount)
                {
                }
                column(Net_Amount;"Payment/Receipt Lines"."Net Amount")
                {
                }
                column(BankAccountNo;"Payment/Receipt Lines"."Bank Account No.")
                {
                }
                column(TotalGross;TotalGross)
                {
                }
                column(TotalNet;TotalNet)
                {
                }
                column(Totalw_Tax;Totalw_Tax)
                {
                }
                column(TotalW_VAT;TotalW_VAT)
                {
                }

                trigger OnPreDataItem();
                begin
                    "Payment/Receipt Lines".SETRANGE("Payment/Receipt Lines".Code,GetPVLine.Code);
                    "Payment/Receipt Lines".SETRANGE("Payment/Receipt Lines"."Account Type",GetPVLine."Account Type");
                    "Payment/Receipt Lines".SETRANGE("Payment/Receipt Lines"."Account No.",GetPVLine."Account No.");
                    TotalGross:=0;
                    TotalNet:=0;
                    Totalw_Tax:=0;
                    TotalW_VAT:=0;
                    SumAmounts();
                end;
            }

            trigger OnPreDataItem();
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
                IF Vendor.GET(GetPVLine."Account No.") THEN BEGIN
                  IF KBACodes.GET(Vendor."KBA Code",Vendor."Bank Code") THEN BEGIN
                  END;
                  IF BankName.GET(Vendor."Bank Code") THEN BEGIN
                  END;
                  END;
                  RecPV.GET(GetPVLine.Code);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Account;AccountNo)
                {
                    Visible = false;

                    trigger OnLookup(var Text : Text) : Boolean;
                    begin
                        AccountNo:=PaymentReceiptProcessing.LookUpPVLines('');
                    end;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text001 : Label '" %1 | %2 | Mobile Phone: %3 | Email: %4 | Website: %5 | PIN No: %6"';
        TXT002 : Label '%1 %2 - %3';
        Text003 : Label 'Address: %1 | Postal Code: %2 | City: %3 |Email: %4 | Phone No: %5';
        Text004 : Label '"To: %1 "';
        REMITTANCE_ADVISECaptionLbl : Label 'PAYMENT REMITTANCE ADVICE';
        DateInvoiceCaptionLbl : Label 'Date:';
        Text005 : Label 'Branch Code: %1 | Branch Name: %2 | Bank Account :%3 : Bank Name: %4';
        InvoiceCaptionLbl : Label 'Invoice';
        DescriptionCaptionLbl : Label 'Description';
        W_VATCaptionLbl : Label '"W/VAT "';
        W_TaxCaptionLbl : Label 'W/Tax';
        Gross_AmountCaptionLbl : Label 'Gross Amount';
        Net_AmountCaptionLbl : Label 'Net Amount';
        GetPVLine : Record "Payment/Receipt Lines";
        AccountNo : Code[20];
        RecPVLine : Record "Payment/Receipt Lines";
        RecPV : Record "Payment/Receipt Voucher";
        TotalGross : Decimal;
        TotalNet : Decimal;
        Totalw_Tax : Decimal;
        TotalW_VAT : Decimal;
        SumPVLine : Record "Payment/Receipt Lines";
        Bank_AccountCaptionLbl : Label 'A/C No.';
        LineGross_AmountCaptionLbl : Label 'Gross Amount';
        LineW_Tax_AmountCaptionLbl : Label 'W/Tax Amount';
        LineW_VAT_AmountCaptionLbl : Label 'W/VAT Amount';
        LineNet_AmountCaptionLbl : Label 'Net Amount Paid:';
        CompInfo : Record "Company Information";
        Vendor : Record Vendor;
        KBACodes : Record "KBA Codes";
        BankName : Record "Bank Name";
        PaymentReceiptProcessing : Codeunit "Cash Management";

    procedure GetPvLines(PVLines : Record "Payment/Receipt Lines");
    begin
        GetPVLine.COPY(PVLines);
    end;

    procedure GetPV(PV : Record "Payment/Receipt Voucher");
    begin
        RecPV.COPY(PV);
    end;

    local procedure SumAmounts();
    begin
        SumPVLine.RESET;
        SumPVLine.SETRANGE(Code,GetPVLine.Code);
        SumPVLine.SETRANGE("Account Type",GetPVLine."Account Type");
        SumPVLine.SETRANGE("Account No.",GetPVLine."Account No.");
        IF SumPVLine.FINDFIRST THEN BEGIN
        REPEAT
        TotalGross:=TotalGross+SumPVLine.Amount;
        TotalNet:=TotalNet+SumPVLine."Net Amount";
        Totalw_Tax:=Totalw_Tax+SumPVLine."W/Tax Amount";
        TotalW_VAT:=TotalW_VAT+SumPVLine."VAT Withheld Amount";
        UNTIL SumPVLine.NEXT=0;
        END;
    end;
}

