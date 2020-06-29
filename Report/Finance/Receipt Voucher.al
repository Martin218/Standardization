report 50447 "Receipt Voucher"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Receipt Voucher.rdlc';

    dataset
    {
        dataitem(PaymentVoucher;"Payment/Receipt Voucher")
        {
            MaxIteration = 1;
            RequestFilterFields = "Paying Code.","Payment Date";
            column(PAYMENT_VOUCHERCaptionLbl;PAYMENT_VOUCHERCaptionLbl)
            {
            }
            column(Payment_ModeCaptionLbl;Payment_ModeCaptionLbl)
            {
            }
            column(Payment_DateCaptionLbl;Payment_DateCaptionLbl)
            {
            }
            column(Cheque_NoCaptionLbl;Cheque_NoCaptionLbl)
            {
            }
            column(Cheque_DateCaptionLbl;Cheque_DateCaptionLbl)
            {
            }
            column(PV_NoCaptionLbl;PV_NoCaptionLbl)
            {
            }
            column(PAYEECaptionLbl;PAYEECaptionLbl)
            {
            }
            column(DescriptionCaptionLbl;DescriptionCaptionLbl)
            {
            }
            column(Net_AmountCaptionLbl;Net_AmountCaptionLbl)
            {
            }
            column(CompInfo_Name;CompInfo.Name)
            {
            }
            column(CompanyInformation;STRSUBSTNO(TXT002,CompInfo.Address,CompInfo."Address 2",CompInfo.City))
            {
            }
            column(ContactInfo;STRSUBSTNO(Text001,CompInfo.Address,CompInfo."Address 2",CompInfo."Phone No.",CompInfo."E-Mail",CompInfo."Home Page",CompInfo."Company P.I.N"))
            {
            }
            column(CompInfo_Picture;CompInfo.Picture)
            {
            }
            column(Paying_Code;PaymentVoucher."Paying Code.")
            {
            }
            column(Payment_Date;PaymentVoucher."Payment Date")
            {
            }
            column(Payment_Mode;PaymentVoucher."Payment Mode")
            {
            }
            column(Cheque_No;PaymentVoucher."Cheque No.")
            {
            }
            column(Cheque_Date;PaymentVoucher."Cheque Date")
            {
            }
            column(Net_Amount;PaymentVoucher."Net Amount")
            {
            }
            column(Payment_Description;PaymentVoucher.Description)
            {
            }
            column(Payee_Name;PaymentVoucher."Payee Name")
            {
            }
            column(Transaction_DetailsCaptionLbl;Transaction_DetailsCaptionLbl)
            {
            }
            column(NumberText_1_;NumberText[1])
            {
            }
            column(Amount_InWordsCaptionLbl;Amount_InWordsCaptionLbl)
            {
            }
            column(Thank_YouCaptionLbl;Thank_YouCaptionLbl)
            {
            }
            column(PC_TotalCaptionLbl;PC_TotalCaptionLbl)
            {
            }
            column(LineAccount_NameCaptionLbl;LineAccount_NameCaptionLbl)
            {
            }
            column(LIneDescriptionCaptionLbl;LIneDescriptionCaptionLbl)
            {
            }
            column(LineLNet_AmountCaptionLbl;LineLNet_AmountCaptionLbl)
            {
            }
            column(LIneW_taxCaptionLbl;LIneW_taxCaptionLbl)
            {
            }
            column(LineW_VATCaptionLbl;LineW_VATCaptionLbl)
            {
            }
            column(LIneGross_amountCaptionLbl;LIneGross_amountCaptionLbl)
            {
            }
            column(Served_ByCaptionLbl;Served_ByCaptionLbl)
            {
            }
            column(ServedBy;ServedBy)
            {
            }
            dataitem("PV Lines";"Payment/Receipt Lines")
            {
                DataItemLink = Code=FIELD("Paying Code.");
                column(Account_Name;"PV Lines"."Account Name")
                {
                }
                column(Description;"PV Lines".Description)
                {
                }
                column(PV_Net_Amount;"PV Lines"."Net Amount")
                {
                }
                column(W_Tax_Amount;"PV Lines"."W/Tax Amount")
                {
                }
                column(W_VAT_Amount;"PV Lines"."VAT Withheld Amount")
                {
                }
                column(Grooss_Amount;"PV Lines".Amount)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                ServedBy:=PaymentReceiptProcessing.GetUsername(PaymentVoucher."Created By");
                PaymentVoucher.CALCFIELDS("Net Amount");
                PaymentReceiptProcessing.FormatAmountToText(NumberText,PaymentVoucher."Net Amount",'');
            end;

            trigger OnPreDataItem();
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
                TableID:=DATABASE::"Payment/Receipt Voucher";
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompInfo : Record "Company Information";
        Text001 : Label '" %1 | %2 | Mobile Phone: %3 | Email: %4 | Website: %5 | PIN No: %6"';
        TXT002 : Label '%1 %2 - %3';
        PAYMENT_VOUCHERCaptionLbl : Label 'RECEIPT VOUCHER';
        Payment_ModeCaptionLbl : Label 'Payment Mode';
        Payment_DateCaptionLbl : Label 'Receipt Date';
        Cheque_NoCaptionLbl : Label 'Cheque No.';
        Cheque_DateCaptionLbl : Label 'Cheque Date';
        PV_NoCaptionLbl : Label 'Receipt No.';
        Served_ByCaptionLbl : Label 'SERVED BY:';
        Transaction_DetailsCaptionLbl : Label 'Transaction Details';
        Thank_YouCaptionLbl : Label 'THANK YOU!';
        PC_TotalCaptionLbl : Label '"TOTAL AMOUNT RECEIVED   "';
        PAYEECaptionLbl : Label 'Received From';
        DescriptionCaptionLbl : Label 'Description';
        Net_AmountCaptionLbl : Label 'Amount';
        LineAccount_NameCaptionLbl : Label 'Account Name';
        LIneDescriptionCaptionLbl : Label 'Description';
        Amount_InWordsCaptionLbl : Label 'AMOUNT IN WORDS';
        LineLNet_AmountCaptionLbl : Label 'Net Amount';
        LIneW_taxCaptionLbl : Label 'W/Tax';
        LineW_VATCaptionLbl : Label 'W/VAT';
        LIneGross_amountCaptionLbl : Label 'Gross Amount';
        FirstApproverID : Code[90];
        FirstApproverDate : DateTime;
        FirstApproverSignature : Byte;
        PaymentReceiptProcessing : Codeunit "Cash Management";
        PREPARED_BYCaptionLbl : Label 'PREPARED BY:';
        CHECKED_BYCaptionLbl : Label 'CHECKED BY:';
        APPROVED_BYCaptionLbl : Label 'APPROVED BY:';
        PAYMENT_RECEIVED_BYCaptionLbl : Label 'PAYMENT RECEIVED BY:';
        SIGNATURECaptionLbl : Label 'SIGNATURE';
        DATECaptionLbl : Label 'DATE';
        TableID : Integer;
        FirstUserSetup : Record "User Setup";
        SecondApproverID : Code[90];
        SecondApproverDate : DateTime;
        SecondApproverSignature : Char;
        SecondUserSetup : Record "User Setup";
        ThirdApproverID : Code[90];
        ThirdApproverDate : DateTime;
        ThirdApproverSignature : Char;
        ThirdUserSetup : Record "User Setup";
        ForthApproverID : Code[90];
        ForthApproverDate : DateTime;
        ForthApproverSignature : Char;
        ForthUserSetup : Record "User Setup";
        SenderID : Code[90];
        SenderDate : DateTime;
        SenderSignature : Char;
        SenderUserSetup : Record "User Setup";
        ServedBy : Code[150];
        NumberText : array [2] of Text[200];
}

