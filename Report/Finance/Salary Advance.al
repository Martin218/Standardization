report 50448 "Salary Advance"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Salary Advance.rdlc';

    dataset
    {
        dataitem("Imprest Management";"Imprest Management")
        {
            RequestFilterFields = "Imprest No.","Request Date";
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
            column(Imprest_No;"Imprest Management"."Imprest No.")
            {
            }
            column(Posted_Date;"Imprest Management"."Request Date")
            {
            }
            column(PC_Description;"Imprest Management".Description)
            {
            }
            column(Approved_Amount;"Imprest Management"."Amount Approved")
            {
            }
            column(EmployeeName;"Imprest Management"."Employee Name")
            {
            }
            column(Departmen_Name;"Imprest Management"."Department Name")
            {
            }
            column(Monthly_Repayment;"Imprest Management"."Monthly Repayment")
            {
            }
            column(Basic_Salary;"Imprest Management"."Basic Salary")
            {
            }
            column(Last_Pay_Month;"Imprest Management"."Last Pay Month")
            {
            }
            column(Onethird;"Imprest Management"."1/3 of Basic Pay")
            {
            }
            column(GrossPay;"Imprest Management"."Gross Pay")
            {
            }
            column(Net_Pay;"Imprest Management"."Net Pay")
            {
            }
            column(No_Of_Months;"Imprest Management"."No. Of Months")
            {
            }
            column(DepartmentCaptionLbl;DepartmentCaptionLbl)
            {
            }
            column(AmountInText_1_;AmountInText[1])
            {
            }
            column(AmountInWords_CaptionLbl;AmountInWordsCaptionLbl)
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
            column(Employee_NameCaptionLbl;Employee_NameCaptionLbl)
            {
            }
            column(Approved_AmountCaptionLbl;Approved_AmountCaptionLbl)
            {
            }
            column(Repaying_MonthsCaptionLbl;Repaying_MonthsCaptionLbl)
            {
            }
            column(Remaining_AmountCaptionLbl;Remaining_AmountCaptionLbl)
            {
            }
            column(Gross_PayCaptionLbl;Gross_PayCaptionLbl)
            {
            }
            column(Basic_payCaptionLbl;Basic_payCaptionLbl)
            {
            }
            column(Net_PayCaptionLbl;Net_PayCaptionLbl)
            {
            }
            column(One_ThirdCaptionLbl;One_ThirdCaptionLbl)
            {
            }
            column(No_OfMonthsCaptionLbl;No_OfMonthsCaptionLbl)
            {
            }
            column(Last_Pay_MonthCaptionLbl;Last_Pay_MonthCaptionLbl)
            {
            }
            column(Reason_RequestCaptionLbl;Reason_RequestCaptionLbl)
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

            trigger OnAfterGetRecord();
            begin
                FirstApproverID:=CashManagement.Approver(TableID,"Imprest Management"."Imprest No.",1);
                FirstApproverDate:=CashManagement.ApproverDate(TableID,"Imprest Management"."Imprest No.",1);
                IF FirstApproverID<>'' THEN BEGIN
                FirstUserSetup.RESET;
                FirstUserSetup.GET(FirstApproverID);
                FirstUserSetup.CALCFIELDS(Signature);
                FirstApproverID:=CashManagement.GetUsername(FirstApproverID);
                END;
                SecondApproverID:=CashManagement.Approver(TableID,"Imprest Management"."Imprest No.",2);
                SecondApproverDate:=CashManagement.ApproverDate(TableID,"Imprest Management"."Imprest No.",2);
                IF SecondApproverID<>'' THEN BEGIN
                SecondUserSetup.RESET;
                SecondUserSetup.GET(SecondApproverID);
                SecondUserSetup.CALCFIELDS(Signature);
                SecondApproverID:=CashManagement.GetUsername(SecondApproverID);
                END;
                ThirdApproverID:=CashManagement.Approver(TableID,"Imprest Management"."Imprest No.",3);
                ThirdApproverDate:=CashManagement.ApproverDate(TableID,"Imprest Management"."Imprest No.",3);
                IF ThirdApproverID<>'' THEN BEGIN
                ThirdUserSetup.RESET;
                ThirdUserSetup.GET(ThirdApproverID);
                ThirdUserSetup.CALCFIELDS(Signature);
                ThirdApproverID:=CashManagement.GetUsername(ThirdApproverID);
                END;
                ForthApproverID:=CashManagement.Approver(TableID,"Imprest Management"."Imprest No.",4);
                ForthApproverDate:=CashManagement.ApproverDate(TableID,"Imprest Management"."Imprest No.",4);
                IF ForthApproverID<>'' THEN BEGIN
                ForthUserSetup.RESET;
                ForthUserSetup.GET(ForthApproverID);
                ForthUserSetup.CALCFIELDS(Signature);
                ForthApproverID:=CashManagement.GetUsername(ForthApproverID);
                END;
                SenderID:=CashManagement.SenderApprover(TableID,"Imprest Management"."Imprest No.",1);
                SenderDate:=CashManagement.SenderDate(TableID,"Imprest Management"."Imprest No.",1);
                IF SenderID<>'' THEN BEGIN
                SenderUserSetup.RESET;
                SenderUserSetup.GET(SenderID);
                SenderUserSetup.CALCFIELDS(Signature);
                SenderID:=CashManagement.GetUsername(SenderID);
                END;
                CashManagement.FormatAmountToText(AmountInText,"Imprest Management"."Amount Approved",'');
            end;

            trigger OnPreDataItem();
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
                TableID:=DATABASE::"Imprest Management";
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
        Text001 : Label '" %1 | %2 | Mobile Phone: %3 | Email: %4 | Website: %5 | PIN No: %6"';
        TXT002 : Label '%1 %2 - %3';
        PAYMENT_VOUCHERCaptionLbl : Label 'SALARY ADVANCE';
        Payment_ModeCaptionLbl : Label 'Payment Mode';
        Payment_DateCaptionLbl : Label 'Request Date';
        Cheque_NoCaptionLbl : Label 'Cheque No.';
        Cheque_DateCaptionLbl : Label 'Cheque Date';
        PV_NoCaptionLbl : Label 'Advance No.';
        PAYEECaptionLbl : Label 'Payment Description';
        DescriptionCaptionLbl : Label 'Description';
        Net_AmountCaptionLbl : Label 'Approved Amount';
        LineAccount_NameCaptionLbl : Label 'Account Name';
        LIneDescriptionCaptionLbl : Label 'Description';
        LineLNet_AmountCaptionLbl : Label 'Amount';
        LIneW_taxCaptionLbl : Label 'W/Tax';
        LineW_VATCaptionLbl : Label 'W/VAT';
        LIneGross_amountCaptionLbl : Label 'Gross Amount';
        PREPARED_BYCaptionLbl : Label 'PREPARED BY:';
        CHECKED_BYCaptionLbl : Label 'CHECKED BY:';
        APPROVED_BYCaptionLbl : Label 'APPROVED BY:';
        PAYMENT_RECEIVED_BYCaptionLbl : Label 'PAYMENT RECEIVED BY:';
        SIGNATURECaptionLbl : Label 'SIGNATURE';
        DATECaptionLbl : Label 'DATE';
        CompInfo : Record "Company Information";
        FirstApproverID : Code[90];
        FirstApproverDate : DateTime;
        FirstApproverSignature : Char;
        CashManagement : Codeunit "Cash Management";
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
        AmountInWordsCaptionLbl : Label 'AMOUNT IN WORDS:';
        AmountInText : array [2] of Text[200];
        ImprestManagement : Record "Imprest Management";
        Approved_AmountCaptionLbl : Label 'Approved Amount';
        Repaying_MonthsCaptionLbl : Label 'Monthly Repayment';
        Remaining_AmountCaptionLbl : Label 'Remaining Amount';
        Gross_PayCaptionLbl : Label 'Gross Pay';
        Basic_payCaptionLbl : Label 'Basic Pay';
        Net_PayCaptionLbl : Label 'Net Pay';
        One_ThirdCaptionLbl : Label '1/3 of Basic Pay';
        Reason_RequestCaptionLbl : Label 'Reason For Request';
        DepartmentCaptionLbl : Label 'Department';
        Last_Pay_MonthCaptionLbl : Label 'Last Pay Month';
        ClearedCaptionLbl : Label 'Cleared';
        PostedCaptionLbl : Label 'Posted';
        No_OfMonthsCaptionLbl : Label 'No. Of Months';
        Employee_NameCaptionLbl : Label 'Employee Name';
}

