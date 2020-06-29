table 50336 "Imprest Management"
{

    fields
    {
        field(1; "Imprest No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Request Date"; Date)
        {
            Editable = false;
        }
        field(3; "Employee No"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                PopulateDetails(Rec);
            end;
        }
        field(4; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = FILTER(Standard));
        }
        field(6; "No. Series"; Code[20])
        {
        }
        field(7; Description; Text[40])
        {
        }
        field(8; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Rejected';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Rejected;
        }
        field(9; "Transaction Type"; Option)
        {
            OptionCaption = 'Imprest,Imprest Claim/Refund,Imprest Surrender,Petty Cash,Salary Advance';
            OptionMembers = Imprest,"Imprest Claim/Refund","Imprest Surrender","Petty Cash","Salary Advance";
        }
        field(10; "User ID"; Code[50])
        {
        }
        field(11; "Paying Bank Account"; Code[20])
        {
            Editable = true;
            TableRelation = "Bank Account";// WHERE ("Account Type"=CONST("Till Account"));

            trigger OnValidate();
            begin
                IF "Paying Bank Account" <> '' THEN BEGIN
                    "Paying Bank Name" := CashManagement.GetBankName("Paying Bank Account");
                END;
            end;
        }
        field(12; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(13; "Staff A/C"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor."No.";
        }
        field(14; "Imprest Amount"; Decimal)
        {
            CalcFormula = Sum ("Imprest Lines".Amount WHERE(Code = FIELD("Imprest No.")));
            FieldClass = FlowField;
        }
        field(15; "A/C Balance"; Decimal)
        {
            Editable = false;
        }
        field(16; "Posted By"; Code[90])
        {
            TableRelation = "User Setup";
        }
        field(17; Posted; Boolean)
        {
            Editable = false;
        }
        field(18; "Applies-to Doc. No."; Code[20])
        {
        }
        field(19; "Total Amount Requested"; Decimal)
        {
        }
        field(20; "No of Approvals"; Integer)
        {
        }
        field(21; Surrendered; Boolean)
        {
        }
        field(22; "Remaining Amount"; Decimal)
        {
            Editable = false;
        }
        field(23; "Cheque No"; Code[20])
        {
        }
        field(24; "Actual Amount"; Decimal)
        {
        }
        field(25; "Imprest Type"; Option)
        {
            OptionCaption = 'Individual,Group';
            OptionMembers = Individual,Group;
        }
        field(26; "Pay Mode"; Code[30])
        {
            NotBlank = true;
        }
        field(27; "Requested By"; Code[70])
        {
        }
        field(28; "Branch Name"; Text[30])
        {
            Editable = false;
        }
        field(29; "Paying Bank"; Code[10])
        {
        }
        field(30; "Paying Bank Name"; Text[90])
        {
            Editable = false;
        }
        field(31; "Staff Name"; Text[90])
        {
            Editable = false;
        }
        field(32; "Imprest To Surrender"; Code[20])
        {
            TableRelation = "Imprest Management" WHERE("Employee No" = FIELD("Employee No"),
                                                      "Transaction Type" = CONST(Imprest),
                                                        Status = CONST(Released),
                                                        Posted = CONST(true),
                                                        Surrendered = CONST(false));

            trigger OnValidate();
            begin
                "Remaining Amount" := CashManagement.GetPostedImprestBalance("Imprest To Surrender");
                PopulateDetails(Rec);
                CashManagement.CreateSurrenderLines(Rec);
            end;
        }
        field(33; "Surplus Amount"; Decimal)
        {
            CalcFormula = Sum ("Imprest Lines"."Remaining Amount" WHERE(Code = FIELD("Imprest No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "Actual Spent"; Decimal)
        {
            CalcFormula = Sum ("Imprest Lines"."Actual Spent" WHERE(Code = FIELD("Imprest No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Claim Type"; Option)
        {
            Editable = false;
            FieldClass = Normal;
            OptionCaption = 'From Imprest,Normal Claim';
            OptionMembers = "From Imprest","Normal Claim";
        }
        field(36; "Imprest Surrender No."; Code[20])
        {
            Editable = false;
            TableRelation = "Imprest Management" WHERE("Employee No" = FIELD("Employee No"),
                                                        "Transaction Type" = CONST("Imprest Surrender"),
                                                        Posted = CONST(true));

        }
        field(37; "Posted Date Time"; DateTime)
        {
        }
        field(38; "Paying Document"; Code[20])
        {
            Caption = 'Attached To PCV/PV No.';
            Editable = false;
        }
        field(39; "Reference No."; Code[20])
        {
            Editable = false;
        }
        field(40; "Department Name"; Text[70])
        {
            Editable = false;
        }
        field(41; "Gross Pay"; Decimal)
        {
            Editable = false;
        }
        field(42; "Net Pay"; Decimal)
        {
            Editable = false;
        }
        field(43; "Requested Amount"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "No. Of Months" <> 0 THEN BEGIN
                    MonthlyRepayment();
                END;
                "Amount Approved" := "Requested Amount";
            end;
        }
        field(44; "No. Of Months"; Integer)
        {

            trigger OnValidate();
            begin
                TESTFIELD("Requested Amount");
                MonthlyRepayment();
            end;
        }
        field(45; "Monthly Repayment"; Decimal)
        {
            Editable = false;
        }
        field(46; "Basic Salary"; Decimal)
        {
            Editable = false;
        }
        field(47; "Last Pay Month"; Date)
        {
            Editable = false;
        }
        field(48; "1/3 of Basic Pay"; Decimal)
        {
            Editable = false;
        }
        field(49; "Amount Approved"; Decimal)
        {

            trigger OnValidate();
            begin
                MonthlyRepayment();
            end;
        }
        field(50; "Maximum Advance Allowed"; Decimal)
        {
            Editable = false;
        }
        field(51; Cleared; Boolean)
        {
            Editable = false;
        }
        field(52; "Repaid Amount"; Decimal)
        {
            CalcFormula = Sum ("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("Staff A/C"),
                                                                        "Document No." = FIELD("Paying Document")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Budget Name"; Code[20])
        {
            Editable = false;
            TableRelation = "G/L Budget Name";
        }
    }

    keys
    {
        key(Key1; "Imprest No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        IF Status <> Status::Open THEN BEGIN
            ERROR(ERROR1);
        END;
    end;

    trigger OnInsert();
    begin

        CashMgtSetup.RESET;
        CashMgtSetup.GET;
        IF "Transaction Type" = "Transaction Type"::Imprest THEN BEGIN
            CashMgtSetup.TESTFIELD("Imprest No.");
            NoSeriesMgt.InitSeries(CashMgtSetup."Imprest No.", xRec."No. Series", 0D, "Imprest No.", "No. Series");
            PopulateDetails(Rec);
            PopulateDetails(Rec);
        END;
        IF "Transaction Type" = "Transaction Type"::"Imprest Surrender" THEN BEGIN
            CashMgtSetup.TESTFIELD("Imprest Surrender No.");
            NoSeriesMgt.InitSeries(CashMgtSetup."Imprest Surrender No.", xRec."No. Series", 0D, "Imprest No.", "No. Series");
            PopulateDetails(Rec);
            PopulateDetails(Rec);
        END;
        IF "Transaction Type" = "Transaction Type"::"Imprest Claim/Refund" THEN BEGIN
            CashMgtSetup.TESTFIELD("Claim No.");
            NoSeriesMgt.InitSeries(CashMgtSetup."Claim No.", xRec."No. Series", 0D, "Imprest No.", "No. Series");
            PopulateDetails(Rec);
            PopulateDetails(Rec);
        END;
        IF "Transaction Type" = "Transaction Type"::"Petty Cash" THEN BEGIN
            CashMgtSetup.TESTFIELD("Petty Cash No.");
            CashMgtSetup.TESTFIELD("Petty Cash Bank");
            NoSeriesMgt.InitSeries(CashMgtSetup."Petty Cash No.", xRec."No. Series", 0D, "Imprest No.", "No. Series");
            "Paying Bank Account" := CashMgtSetup."Petty Cash Bank";
            "Paying Bank Name" := CashManagement.GetBankName("Paying Bank Account");
        END;
        IF "Transaction Type" = "Transaction Type"::"Salary Advance" THEN BEGIN
            CashMgtSetup.TESTFIELD("Salary Advace");
            NoSeriesMgt.InitSeries(CashMgtSetup."Salary Advace", xRec."No. Series", 0D, "Imprest No.", "No. Series");
            PopulateDetails(Rec);
            PopulateDetails(Rec);
            Employee.GET("Employee No");
            ClosedPayPeriod := PayrollProcessing.GetOpenPeriod();
            // "Gross Pay":=PayrollProcessing.GetGrossPay(Employee,ClosedPayPeriod);
            //"Basic Salary":=PayrollProcessing.GetBasicPay(Employee);
            // "Net Pay":="Gross Pay"-PayrollProcessing.GetTotalDeductions(Employee,ClosedPayPeriod);
            "Last Pay Month" := ClosedPayPeriod;
            //"1/3 of Basic Pay":=PayrollProcessing.CalculateOneThirdOfBasic(Employee);
            "Maximum Advance Allowed" := "Net Pay" - "1/3 of Basic Pay";
        END;
        "Request Date" := TODAY;
        "Requested By" := USERID;
        "User ID" := USERID;
        "Global Dimension 1 Code" := CashManagement.GetBranchCode("Employee No");
        "Global Dimension 2 Code" := CashManagement.GetDepartmentCode("Employee No");
        "Branch Name" := CashManagement.GetDimensionName("Global Dimension 1 Code", 1);
        ;
        "Department Name" := CashManagement.GetDimensionName("Global Dimension 2 Code", 2);
        UserSetup.GET(USERID);
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";

    end;

    var
        CashMgtSetup: Record "Cash Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CashManagement: Codeunit "Cash Management";
        ERROR1: Label 'You Cannot Delete This Document At This Stage!';
        DimensionValue: Record "Dimension Value";
        ImprestLines: Record "Imprest Lines";
        PayrollProcessing: Codeunit "Payroll Processing";
        ClosedPayPeriod: Date;
        Employee: Record Employee;
        PayrollSetup: Record "Payroll Setup";
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";

    local procedure PopulateDetails(ImprestManagement: Record "Imprest Management");
    begin
        "Employee No" := CashManagement."GetEmployeeNo."(USERID);
        "Employee Name" := CashManagement.GetEmployeeName("Employee No");
        "Staff A/C" := CashManagement.GetCustomerAccount(ImprestManagement);
        "Staff Name" := CashManagement.GetCustomerName("Staff A/C");
        "A/C Balance" := CashManagement.GetCustomerBalance("Staff A/C");
        "Global Dimension 1 Code" := CashManagement.GetBranchCode("Employee No");
        "Applies-to Doc. No." := "Imprest To Surrender";
        IF ImprestManagement.GET("Imprest To Surrender") THEN BEGIN
            IF ImprestManagement."Paying Document" <> '' THEN BEGIN
                "Applies-to Doc. No." := ImprestManagement."Paying Document";
            END;
        END;
        GLSetup.GET;
        //"Budget Name":=GLSetup."Current Bugdet";

    end;

    // [Scope('Personalization')]
    procedure ImprestLinesExist(): Boolean;
    begin
        ImprestLines.RESET;
        ImprestLines.SETRANGE(Code, "Imprest No.");
        EXIT(ImprestLines.FINDFIRST);
    end;

    local procedure MonthlyRepayment();
    begin
        PayrollSetup.GET;
        IF "Amount Approved" <> 0 THEN BEGIN
            "Monthly Repayment" := ROUND("Amount Approved" / "No. Of Months", 1);
        END ELSE BEGIN
            "Monthly Repayment" := ROUND("Requested Amount" / "No. Of Months", 1);
        END;
        IF "Monthly Repayment" > "Maximum Advance Allowed" THEN BEGIN
            ERROR('You Salary Advance Monthly Deduction Cannot go Beyond %1!', "Maximum Advance Allowed");
        END;
    end;
}

