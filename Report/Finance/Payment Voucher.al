report 50440 "Payment Voucher"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Payment Voucher.rdlc';

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
            column(PREPARED_BYCaptionLbl;PREPARED_BYCaptionLbl)
            {
            }
            column(CHECKED_BYCaptionLbl;CHECKED_BYCaptionLbl)
            {
            }
            column(APPROVED_BYCaptionLbl;APPROVED_BYCaptionLbl)
            {
            }
            column(PAYMENT_RECEIVED_BYCaptionLbl;PAYMENT_RECEIVED_BYCaptionLbl)
            {
            }
            column(SIGNATURECaptionLbl;SIGNATURECaptionLbl)
            {
            }
            column(DATECaptionLbl;DATECaptionLbl)
            {
            }
            column(FirstApproverID;FirstApproverID)
            {
            }
            column(FirstApproverDate;FirstApproverDate)
            {
            }
            column(FirstApproverSignature;FirstUserSetup.Signature)
            {
            }
            column(SecondApproverID;SecondApproverID)
            {
            }
            column(SecondApproverDate;SecondApproverDate)
            {
            }
            column(SecondApproverSignature;SecondUserSetup.Signature)
            {
            }
            column(ThirdApproverID;ThirdApproverID)
            {
            }
            column(ThirdApproverDate;ThirdApproverDate)
            {
            }
            column(ThirdApproverSignature;ThirdUserSetup.Signature)
            {
            }
            column(SenderID;SenderID)
            {
            }
            column(SenderDate;SenderDate)
            {
            }
            column(SenderSignature;SenderUserSetup.Signature)
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
                FirstApproverID:=PaymentReceiptProcessing.Approver(TableID,PaymentVoucher."Paying Code.",1);
                FirstApproverDate:=PaymentReceiptProcessing.ApproverDate(TableID,PaymentVoucher."Paying Code.",1);
                IF FirstApproverID<>'' THEN BEGIN
                FirstUserSetup.RESET;
                FirstUserSetup.GET(FirstApproverID);
                FirstUserSetup.CALCFIELDS(Signature);
                FirstApproverID:=PaymentReceiptProcessing.GetUsername(FirstApproverID);
                END;
                SecondApproverID:=PaymentReceiptProcessing.Approver(TableID,PaymentVoucher."Paying Code.",2);
                SecondApproverDate:=PaymentReceiptProcessing.ApproverDate(TableID,PaymentVoucher."Paying Code.",2);
                IF SecondApproverID<>'' THEN BEGIN
                SecondUserSetup.RESET;
                SecondUserSetup.GET(SecondApproverID);
                SecondUserSetup.CALCFIELDS(Signature);
                SecondApproverID:=PaymentReceiptProcessing.GetUsername(SecondApproverID);
                END;
                ThirdApproverID:=PaymentReceiptProcessing.Approver(TableID,PaymentVoucher."Paying Code.",3);
                ThirdApproverDate:=PaymentReceiptProcessing.ApproverDate(TableID,PaymentVoucher."Paying Code.",3);
                IF ThirdApproverID<>'' THEN BEGIN
                ThirdUserSetup.RESET;
                ThirdUserSetup.GET(ThirdApproverID);
                ThirdUserSetup.CALCFIELDS(Signature);
                ThirdApproverID:=PaymentReceiptProcessing.GetUsername(ThirdApproverID);
                END;
                ForthApproverID:=PaymentReceiptProcessing.Approver(TableID,PaymentVoucher."Paying Code.",4);
                ForthApproverDate:=PaymentReceiptProcessing.ApproverDate(TableID,PaymentVoucher."Paying Code.",4);
                IF ForthApproverID<>'' THEN BEGIN
                ForthUserSetup.RESET;
                ForthUserSetup.GET(ForthApproverID);
                ForthUserSetup.CALCFIELDS(Signature);
                ForthApproverID:=PaymentReceiptProcessing.GetUsername(ForthApproverID);
                END;
                SenderID:=PaymentReceiptProcessing.SenderApprover(TableID,PaymentVoucher."Paying Code.",1);
                SenderDate:=PaymentReceiptProcessing.SenderDate(TableID,PaymentVoucher."Paying Code.",1);
                IF SenderID<>'' THEN BEGIN
                SenderUserSetup.RESET;
                SenderUserSetup.GET(SenderID);
                SenderUserSetup.CALCFIELDS(Signature);
                SenderID:=PaymentReceiptProcessing.GetUsername(SenderID);
                END;
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
        PAYMENT_VOUCHERCaptionLbl : Label 'PAYMENT VOUCHER';
        Payment_ModeCaptionLbl : Label 'Payment Mode';
        Payment_DateCaptionLbl : Label 'Payment Date';
        Cheque_NoCaptionLbl : Label 'Cheque No.';
        Cheque_DateCaptionLbl : Label 'Cheque Date';
        PV_NoCaptionLbl : Label 'PV No.';
        PAYEECaptionLbl : Label 'PAYEE';
        DescriptionCaptionLbl : Label 'Description';
        Net_AmountCaptionLbl : Label 'Net Amount';
        LineAccount_NameCaptionLbl : Label 'Account Name';
        LIneDescriptionCaptionLbl : Label 'Description';
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
}

