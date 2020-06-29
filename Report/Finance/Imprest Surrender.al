report 50445 "Imprest Surrender"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Imprest Surrender.rdlc';

    dataset
    {
        dataitem("Imprest Management"; "Imprest Management")
        {
            RequestFilterFields = "Imprest No.", "Request Date";
            column(PAYMENT_VOUCHERCaptionLbl; PAYMENT_VOUCHERCaptionLbl)
            {
            }
            column(Payment_ModeCaptionLbl; Payment_ModeCaptionLbl)
            {
            }
            column(Payment_DateCaptionLbl; Payment_DateCaptionLbl)
            {
            }
            column(Cheque_NoCaptionLbl; Cheque_NoCaptionLbl)
            {
            }
            column(Cheque_DateCaptionLbl; Cheque_DateCaptionLbl)
            {
            }
            column(PV_NoCaptionLbl; PV_NoCaptionLbl)
            {
            }
            column(PAYEECaptionLbl; PAYEECaptionLbl)
            {
            }
            column(DescriptionCaptionLbl; DescriptionCaptionLbl)
            {
            }
            column(Net_AmountCaptionLbl; Net_AmountCaptionLbl)
            {
            }
            column(Department_CodeCaptionLbl; Department_CodeCaptionLbl)
            {
            }
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(CompanyInformation; STRSUBSTNO(TXT002, CompInfo.Address, CompInfo."Address 2", CompInfo.City))
            {
            }
            column(ContactInfo; STRSUBSTNO(Text001, CompInfo.Address, CompInfo."Address 2", CompInfo."Phone No.", CompInfo."E-Mail", CompInfo."Home Page", CompInfo."Company P.I.N"))
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(Imprest_No; "Imprest Management"."Imprest No.")
            {
            }
            column(Request_Date; "Imprest Management"."Request Date")
            {
            }
            column(Imprest_Amount; "Imprest Management"."Imprest Amount")
            {
            }
            column(Actual_Spent; "Imprest Management"."Actual Spent")
            {
            }
            column(Employee_No; "Imprest Management"."Employee No")
            {
            }
            column(Employee_Name; "Imprest Management"."Employee Name")
            {
            }
            column(Branch_Code; "Imprest Management"."Global Dimension 1 Code")
            {
            }
            column(Branch_Name; "Imprest Management"."Branch Name")
            {
            }
            column(Department; "Imprest Management"."Department Name")
            {
            }
            column(AmountInText_1_; AmountInText[1])
            {
            }
            column(AmountInWords_CaptionLbl; AmountInWordsCaptionLbl)
            {
            }
            column(LineAccount_NoCaptionLbl; LineAccount_NoCaptionLbl)
            {
            }
            column(LineAccount_NameCaptionLbl; LineAccount_NameCaptionLbl)
            {
            }
            column(LIneDescriptionCaptionLbl; LIneDescriptionCaptionLbl)
            {
            }
            column(LineLNet_AmountCaptionLbl; LineLNet_AmountCaptionLbl)
            {
            }
            column(LIneW_taxCaptionLbl; LIneW_taxCaptionLbl)
            {
            }
            column(LineW_VATCaptionLbl; LineW_VATCaptionLbl)
            {
            }
            column(LIneGross_amountCaptionLbl; LIneGross_amountCaptionLbl)
            {
            }
            column(Amount_dueCaptionLbl; Amount_dueCaptionLbl)
            {
            }
            column(Imprest_amountCaptionLbl; Imprest_amountCaptionLbl)
            {
            }
            column(Expense_AmountCaptionLbl; Expense_AmountCaptionLbl)
            {
            }
            column(AmountDue; AmountDue)
            {
            }
            column(PREPARED_BYCaptionLbl; PREPARED_BYCaptionLbl)
            {
            }
            column(CHECKED_BYCaptionLbl; CHECKED_BYCaptionLbl)
            {
            }
            column(APPROVED_BYCaptionLbl; APPROVED_BYCaptionLbl)
            {
            }
            column(PAYMENT_RECEIVED_BYCaptionLbl; PAYMENT_RECEIVED_BYCaptionLbl)
            {
            }
            column(SIGNATURECaptionLbl; SIGNATURECaptionLbl)
            {
            }
            column(DATECaptionLbl; DATECaptionLbl)
            {
            }
            column(FirstApproverID; FirstApproverID)
            {
            }
            column(FirstApproverDate; FirstApproverDate)
            {
            }
            column(FirstApproverSignature; FirstUserSetup.Signature)
            {
            }
            column(SecondApproverID; SecondApproverID)
            {
            }
            column(SecondApproverDate; SecondApproverDate)
            {
            }
            column(SecondApproverSignature; SecondUserSetup.Signature)
            {
            }
            column(ThirdApproverID; ThirdApproverID)
            {
            }
            column(ThirdApproverDate; ThirdApproverDate)
            {
            }
            column(ThirdApproverSignature; ThirdUserSetup.Signature)
            {
            }
            column(SenderID; SenderID)
            {
            }
            column(SenderDate; SenderDate)
            {
            }
            column(SenderSignature; SenderUserSetup.Signature)
            {
            }
            dataitem("Imprest Lines"; "Imprest Lines")
            {
                DataItemLink = Code = FIELD("Imprest No.");
                column(Account_Name; "Imprest Lines"."Account Name")
                {
                }
                column(Description; "Imprest Lines".Description)
                {
                }
                column(Amount; "Imprest Lines"."Actual Spent")
                {
                }
                column(Account_No; "Imprest Lines"."Account No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                FirstApproverID := CashManagement.Approver(TableID, "Imprest Management"."Imprest No.", 1);
                FirstApproverDate := CashManagement.ApproverDate(TableID, "Imprest Management"."Imprest No.", 1);
                IF FirstApproverID <> '' THEN BEGIN
                    FirstUserSetup.RESET;
                    FirstUserSetup.GET(FirstApproverID);
                    FirstUserSetup.CALCFIELDS(Signature);
                    FirstApproverID := CashManagement.GetUsername(FirstApproverID);
                END;
                SecondApproverID := CashManagement.Approver(TableID, "Imprest Management"."Imprest No.", 2);
                SecondApproverDate := CashManagement.ApproverDate(TableID, "Imprest Management"."Imprest No.", 2);
                IF SecondApproverID <> '' THEN BEGIN
                    SecondUserSetup.RESET;
                    SecondUserSetup.GET(SecondApproverID);
                    SecondUserSetup.CALCFIELDS(Signature);
                    SecondApproverID := CashManagement.GetUsername(SecondApproverID);
                END;
                ThirdApproverID := CashManagement.Approver(TableID, "Imprest Management"."Imprest No.", 3);
                ThirdApproverDate := CashManagement.ApproverDate(TableID, "Imprest Management"."Imprest No.", 3);
                IF ThirdApproverID <> '' THEN BEGIN
                    ThirdUserSetup.RESET;
                    ThirdUserSetup.GET(ThirdApproverID);
                    ThirdUserSetup.CALCFIELDS(Signature);
                    ThirdApproverID := CashManagement.GetUsername(ThirdApproverID);
                END;
                ForthApproverID := CashManagement.Approver(TableID, "Imprest Management"."Imprest No.", 4);
                ForthApproverDate := CashManagement.ApproverDate(TableID, "Imprest Management"."Imprest No.", 4);
                IF ForthApproverID <> '' THEN BEGIN
                    ForthUserSetup.RESET;
                    ForthUserSetup.GET(ForthApproverID);
                    ForthUserSetup.CALCFIELDS(Signature);
                    ForthApproverID := CashManagement.GetUsername(ForthApproverID);
                END;
                SenderID := CashManagement.SenderApprover(TableID, "Imprest Management"."Imprest No.", 1);
                SenderDate := CashManagement.SenderDate(TableID, "Imprest Management"."Imprest No.", 1);
                IF SenderID <> '' THEN BEGIN
                    SenderUserSetup.RESET;
                    SenderUserSetup.GET(SenderID);
                    SenderUserSetup.CALCFIELDS(Signature);
                    SenderID := CashManagement.GetUsername(SenderID);
                END;
                "Imprest Management".CALCFIELDS("Imprest Amount", "Actual Spent");
                CashManagement.FormatAmountToText(AmountInText, "Imprest Management"."Imprest Amount", '');
                AmountDue := "Imprest Management"."Actual Spent" - "Imprest Management"."Imprest Amount";
            end;

            trigger OnPreDataItem();
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
                TableID := DATABASE::"Imprest Management";
                AmountDue := 0;
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
        Text001: Label '" %1 | %2 | Mobile Phone: %3 | Email: %4 | Website: %5 | PIN No: %6"';
        TXT002: Label '%1 %2 - %3';
        PAYMENT_VOUCHERCaptionLbl: Label 'IMPREST SURRENDER';
        Payment_ModeCaptionLbl: Label 'Payment Mode';
        Payment_DateCaptionLbl: Label 'Request Date';
        Cheque_NoCaptionLbl: Label 'Cheque No.';
        Cheque_DateCaptionLbl: Label 'Cheque Date';
        PV_NoCaptionLbl: Label 'No.';
        PAYEECaptionLbl: Label 'Employee Name';
        Department_CodeCaptionLbl: Label 'Department';
        DescriptionCaptionLbl: Label 'Description';
        Net_AmountCaptionLbl: Label 'Amount';
        LineAccount_NoCaptionLbl: Label 'Account No.';
        LineAccount_NameCaptionLbl: Label 'Account Name';
        LIneDescriptionCaptionLbl: Label 'Description';
        LineLNet_AmountCaptionLbl: Label 'Amount';
        LIneW_taxCaptionLbl: Label 'W/Tax';
        LineW_VATCaptionLbl: Label 'W/VAT';
        LIneGross_amountCaptionLbl: Label 'Gross Amount';
        Amount_dueCaptionLbl: Label 'AMOUNT DUE TO/(FROM) EMPLOYEE';
        Imprest_amountCaptionLbl: Label 'LESS: IMPREST AMOUNT';
        Expense_AmountCaptionLbl: Label 'TOTAL EXPENSE';
        PREPARED_BYCaptionLbl: Label 'PREPARED BY:';
        CHECKED_BYCaptionLbl: Label 'CHECKED BY:';
        APPROVED_BYCaptionLbl: Label 'APPROVED BY:';
        PAYMENT_RECEIVED_BYCaptionLbl: Label 'PAYMENT RECEIVED BY:';
        SIGNATURECaptionLbl: Label 'SIGNATURE';
        DATECaptionLbl: Label 'DATE';
        CompInfo: Record "Company Information";
        FirstApproverID: Code[90];
        FirstApproverDate: DateTime;
        FirstApproverSignature: Char;
        CashManagement: Codeunit "Cash Management";
        TableID: Integer;
        FirstUserSetup: Record "User Setup";
        SecondApproverID: Code[90];
        SecondApproverDate: DateTime;
        SecondApproverSignature: Char;
        SecondUserSetup: Record "User Setup";
        ThirdApproverID: Code[90];
        ThirdApproverDate: DateTime;
        ThirdApproverSignature: Char;
        ThirdUserSetup: Record "User Setup";
        ForthApproverID: Code[90];
        ForthApproverDate: DateTime;
        ForthApproverSignature: Char;
        ForthUserSetup: Record "User Setup";
        SenderID: Code[90];
        SenderDate: DateTime;
        SenderSignature: Char;
        SenderUserSetup: Record "User Setup";
        AmountInWordsCaptionLbl: Label 'AMOUNT IN WORDS:';
        Text002: Label 'ONE';
        Text003: Label 'TWO';
        Text004: Label 'THREE';
        Text005: Label 'FOUR';
        Text006: Label 'FIVE';
        Text007: Label 'SIX';
        Text008: Label 'SEVEN';
        Text009: Label 'EIGHT';
        Text010: Label 'NINE';
        Text011: Label 'TEN';
        Text012: Label 'ELEVEN';
        Text013: Label 'TWELVE';
        Text014: Label 'THIRTEEN';
        Text015: Label 'FOURTEEN';
        Text016: Label 'FIFTEEN';
        Text017: Label 'SIXTEEN';
        Text018: Label 'SEVENTEEN';
        Text019: Label 'EIGHTEEN';
        Text020: Label 'NINETEEN';
        Text021: Label 'TWENTY';
        Text022: Label 'THIRTY';
        Text023: Label 'FORTY';
        Text024: Label 'FIFTY';
        Text025: Label 'SIXTY';
        Text026: Label 'SEVENTY';
        Text027: Label 'EIGHTY';
        Text028: Label 'NINETY';
        Text029: Label 'THOUSAND';
        Text030: Label 'MILLION';
        Text031: Label 'BILLION';
        AmountInText: array[2] of Text[200];
        ImprestManagement: Record "Imprest Management";
        AmountDue: Decimal;
}

