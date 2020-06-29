table 50101 "Loan Application"
{
    // version TL2.0

    DataCaptionFields = "No.", Description, "Member No.", "Member Name";
    //DrillDownPageID = 50207;
    //LookupPageID = 50207;

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
            NotBlank = false;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = IF ("Member Category" = FILTER(Staff)) Employee
            ELSE
            IF ("Member Category" = FILTER(Member)) Member;

            trigger OnValidate()
            begin
                IF "Member Category" = "Member Category"::Member THEN BEGIN
                    IF Member.GET("Member No.") THEN BEGIN
                        "Member Name" := Member."Full Name";
                        "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                    END;
                    CalculateMemberBalance;
                END;
                IF "Member Category" = "Member Category"::Staff THEN BEGIN
                    IF Employee.GET("Member No.") THEN BEGIN
                        "Member Name" := Employee.FullName;
                        "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    END;
                END;
            end;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Loan Product Type"; Code[20])
        {
            TableRelation = "Loan Product Type";

            trigger OnValidate()
            begin
                ValidateLoanProduct;
            end;
        }
        field(5; Description; Text[50])
        {
            Editable = false;
        }
        field(6; "Interest Rate"; Decimal)
        {
            Editable = false;
        }
        field(7; "Repayment Period"; Decimal)
        {

        }
        field(8; "Repayment Method"; Option)
        {
            Editable = false;
            OptionCaption = 'Straight Line,Reducing Balance,Amortization';
            OptionMembers = "Straight Line","Reducing Balance",Amortization;
        }
        field(10; "Requested Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateRequestedAmount;
            end;
        }
        field(11; "Approved Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Approved Amount" > "Requested Amount" THEN
                    ERROR(Error005, FIELDCAPTION("Approved Amount"), FIELDCAPTION("Requested Amount"));

                IF Status = Status::"Pending Approval" THEN BEGIN
                    "Appraised By" := USERID;
                    "Appraisal Date" := TODAY;
                    "Appraisal Time" := TIME;

                    BosaManagement.GetHostInfo(HostName, HostIP, HostMac);
                    "Appraised By Host IP" := HostIP;
                    "Appraised By Host MAC" := HostMac;
                    "Appraised By Host Name" := HostName;
                END;
            end;
        }
        field(12; "Total Savings Amount"; Decimal)
        {
            Editable = false;
        }
        field(13; "Total Deposits Amount"; Decimal)
        {
            Editable = false;
        }
        field(14; "Total Shares Amount"; Decimal)
        {
            Editable = false;
        }
        field(15; "Maximum Eligible Amount"; Decimal)
        {
            Editable = false;
        }
        field(16; "No. Series"; Code[20])
        {

        }
        field(17; "Refinance Another Loan"; Boolean)
        {

        }
        field(18; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(19; "Date of Completion"; Date)
        {
            Editable = false;
        }
        field(20; "Next Due Date"; Date)
        {
            Editable = false;
        }
        field(21; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(22; "Created Date"; Date)
        {
            Editable = false;
        }
        field(23; "Created Time"; Time)
        {
            Editable = false;
        }
        field(24; "Appraised By"; Code[20])
        {
            Editable = false;
        }
        field(25; "Appraisal Date"; Date)
        {
            Editable = false;
        }
        field(26; "Appraisal Time"; Time)
        {
            Editable = false;
        }
        field(27; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(28; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(29; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(30; Posted; Boolean)
        {
            Editable = false;
        }
        field(31; "Total Guaranteed Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Loan Guarantor"."Amount To Guarantee" WHERE("Loan No." = FIELD("No.")));
            Editable = false;

        }
        field(32; "Total Security Amount"; Decimal)
        {
            CalcFormula = Sum ("Loan Security"."Guaranteed Amount" WHERE("Loan No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; Remarks; Text[50])
        {
        }
        field(34; "No. of Guarantors"; Integer)
        {
            CalcFormula = Count ("Loan Guarantor" WHERE("Loan No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "No. of Other Securities"; Integer)
        {
            CalcFormula = Count ("Loan Security" WHERE("Loan No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "No. of Loans Refinanced"; Integer)
        {
            CalcFormula = Count ("Loan Refinancing Entry" WHERE("Loan No." = FIELD("No."),
                                                                Select = FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "Total Refinanced Amount"; Decimal)
        {
            CalcFormula = Sum ("Loan Refinancing Entry"."Outstanding Balance" WHERE("Loan No." = FIELD("No."),
                                                                                    Select = FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(39; "Repayment Frequency"; Option)
        {
            Editable = false;
            OptionCaption = 'Daily,Weekly,Monthly,Quarterly,Annually';
            OptionMembers = Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually;
        }
        field(40; "Disbursed By"; Code[20])
        {

        }
        field(41; "Disbursal Date"; Date)
        {

        }
        field(42; "Disbursal Time"; Time)
        {
            Editable = true;
        }
        field(43; "FOSA Account No."; Code[20])
        {
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF Vendor.GET("FOSA Account No.") THEN
                    "FOSA Account Name" := Vendor.Name;
            end;
        }
        field(44; "Phone No."; Code[20])
        {
            Editable = false;
        }
        field(45; "FOSA Account Name"; Text[50])
        {
            Editable = false;
        }
        field(46; "Created By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(47; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(48; "Created By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(49; "Appraised By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(50; "Appraised By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(51; "Appraised By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(52; "Approved By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(53; "Approved By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(54; "Approved By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(55; "Disbursed By Host Name"; Code[30])
        {

        }
        field(56; "Disbursed By Host IP"; Code[30])
        {

        }
        field(57; "Disbursed By Host MAC"; Code[30])
        {

        }
        field(58; "Basic Salary"; Decimal)
        {

        }
        field(59; "Total Deduction Amount"; Decimal)
        {

        }
        field(60; "Net Amount"; Decimal)
        {

        }
        field(61; "Company Name"; Text[50])
        {

        }
        field(62; "No. of KG"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Payout Amount" := "No. of KG" * "Rate per KG"
            end;
        }
        field(63; "Rate per KG"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Payout Amount" := "No. of KG" * "Rate per KG"
            end;
        }
        field(64; "View Payout History"; Boolean)
        {

        }
        field(65; "Payroll No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(66; "Member Category"; Option)
        {
            OptionCaption = 'Staff,Member';
            OptionMembers = Staff,Member;
        }
        field(67; "Total Payout Amount"; Decimal)
        {
            Editable = false;
        }
        field(68; Cleared; Boolean)
        {

        }
        field(69; "Outstanding Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No.")));
            Editable = false;

        }
        field(70; "External Loan"; Boolean)
        {

        }
        field(71; "Institution Name"; Text[50])
        {

        }
        field(72; "Institution Branch Name"; Text[50])
        {

        }
        field(75; "Principal Arrears Amount"; Decimal)
        {

        }
        field(76; "Interest Arrears Amount"; Decimal)
        {

        }
        field(77; "Total Arrears Amount"; Decimal)
        {

        }
        field(78; "Principal Overpayment"; Decimal)
        {

        }
        field(79; "Interest Overpayment"; Decimal)
        {

        }
        field(80; "Total Overpayment"; Decimal)
        {

        }
        field(81; "Mode of Disbursement"; Option)
        {
            OptionCaption = 'FOSA Account,Mobile Banking,RTGS';
            OptionMembers = "FOSA Account","Mobile Banking",RTGS;
            trigger OnValidate()
            var
                SpotCashMember: Record "SpotCash Member";
            begin
                "Phone No." := '';
                "FOSA Account No." := '';
                "FOSA Account Name" := '';
                "External Account No." := '';
                TestField("Member No.");
                TestField("Loan Product Type");
                if "Mode of Disbursement" = "Mode of Disbursement"::"Mobile Banking" then begin
                    SpotCashMember.Reset();
                    SpotCashMember.SetRange("Member No.", "Member No.");
                    if SpotCashMember.FindFirst() then begin
                        if SpotCashMember.Status = SpotCashMember.Status::Active then
                            "Phone No." := SpotCashMember."Phone No."
                        else
                            Error(Error013);
                    end else
                        Error(Error014);
                end;


            end;
        }
        field(82; "External Account No."; Code[20])
        {
            // Editable = false;
        }
        field(84; "Notice Category"; Option)
        {
            OptionCaption = ' ,First Notice,Second Notice,Third Notice';
            OptionMembers = " ","First Notice","Second Notice","Third Notice";
        }
        field(85; "Notice Date"; Date)
        {

        }
        field(86; "Attach Due Date"; Date)
        {

        }
        field(87; "Attach Status"; Option)
        {
            OptionCaption = ' ,Attached,Reversed';
            OptionMembers = " ",Attached,Reversed;
        }
        field(88; "Attach Loan No."; Code[20])
        {
            TableRelation = "Loan Application";
        }
    }

    keys
    {
        key(Key1; "No.")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DeleteRelatedLinks;
    end;

    trigger OnInsert()
    begin
        CBSSetup.GET;

        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(CBSSetup."Loan Application Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        BosaManagement.GetHostInfo(HostName, HostIP, HostMac);

        "Created By Host IP" := HostIP;
        "Created By Host MAC" := HostMac;
        "Created By Host Name" := HostName;
    end;

    var
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LoanProductType: Record "Loan Product Type";
        Member: Record Member;
        Vendor: Record Vendor;
        AccountType: Record "Account Type";
        LoanApplication: Record "Loan Application";
        Error000: Label 'Member %1 does not have enough Savings';
        Error001: Label 'Member %1 does not have enough Deposits';
        Error002: Label 'Member %1 does not have enough Shares';
        Error003: Label '%1 cannot be be less than the Minimum Amount set for this Loan product';
        Error004: Label '%1 cannot exceed the Maximum Amount set for this Loan product';
        DateFormula: DateFormula;
        Error005: Label '%1 cannot exceed %2';
        HostMac: Code[20];
        HostName: Code[20];
        HostIP: Code[20];
        Customer: Record Customer;
        Error006: Label 'Loan Product %1 is not Active';
        Error007: Label 'Member %1 has violated 1/3 rule';
        Employee: Record Employee;
        Error008: Label 'Member %1 does not qualify for this Loan product';
        LoanProductAdditionalRate: Record "Loan Product Additional Rate";
        Error009: Label 'Member %1 has exceeded the number of loans allowed for this Loan product';
        MembershipDate: Date;
        Error010: Label 'Member %1 has not attained the Minimum Membership period';
        Error011: Label 'Member %1 does not have sufficient Payouts';
        Error012: Label 'You must attach supporting documents';
        Error013: Label 'Member is not Active on Mobile Banking';
        Error014: Label 'Member is not registered on Mobile Banking';
        BosaManagement: Codeunit "BOSA Management";

    local procedure CalculateMemberBalance()
    var
        AccountBalance: Decimal;
    begin
        "Total Deposits Amount" := 0;
        "Total Savings Amount" := 0;
        "Total Shares Amount" := 0;

        AccountType.RESET;
        AccountType.SETFILTER(Type, '%1|%2|%3', AccountType.Type::Savings, AccountType.Type::"Share Capital", AccountType.Type::Deposit);
        IF AccountType.FINDSET THEN BEGIN
            REPEAT
                Vendor.RESET;
                Vendor.SETRANGE("Member No.", "Member No.");
                IF Vendor.FINDSET THEN BEGIN
                    REPEAT
                        Vendor.CALCFIELDS("Balance (LCY)");
                        IF Vendor."Account Type" = AccountType.Code THEN BEGIN
                            AccountBalance := ABS(Vendor."Balance (LCY)") - AccountType."Minimum Balance";
                            IF AccountType.Type = AccountType.Type::Savings THEN
                                "Total Savings Amount" += AccountBalance;
                            IF AccountType.Type = AccountType.Type::"Share Capital" THEN
                                "Total Shares Amount" += AccountBalance;
                            IF AccountType.Type = AccountType.Type::Deposit THEN
                                "Total Deposits Amount" += AccountBalance;
                        END;
                    UNTIL Vendor.NEXT = 0;
                END;
            UNTIL AccountType.NEXT = 0;
        END;
    end;

    procedure GetLoansToRefinance()
    var
        LoanRefinancingEntry: Record "Loan Refinancing Entry";
    begin
        LoanApplication.RESET;
        LoanApplication.SETRANGE("Member No.", "Member No.");
        IF LoanProductType.GET("Loan Product Type") THEN BEGIN
            IF LoanProductType."Allow Refinancing" THEN BEGIN
                IF LoanProductType."Refinancing Mode" = LoanProductType."Refinancing Mode"::"Same Product" THEN
                    LoanApplication.SETRANGE("Loan Product Type", LoanProductType.Code);
            END;
        END;
        LoanApplication.SETRANGE(Posted, TRUE);
        IF LoanApplication.FINDSET THEN BEGIN
            REPEAT
                IF Customer.GET(LoanApplication."No.") THEN BEGIN
                    Customer.CALCFIELDS("Balance (LCY)");
                    IF Customer."Balance (LCY)" > 0 THEN BEGIN
                        LoanRefinancingEntry.INIT;
                        LoanRefinancingEntry."Loan No." := "No.";
                        LoanRefinancingEntry."Loan To Refinance" := LoanApplication."No.";
                        LoanRefinancingEntry.Description := LoanApplication.Description;
                        LoanRefinancingEntry."Outstanding Balance" := ABS(Customer."Balance (LCY)");
                        LoanRefinancingEntry.INSERT;
                    END;
                END;
            UNTIL LoanApplication.NEXT = 0;
        END;

        LoanRefinancingEntry.RESET;
        LoanRefinancingEntry.SETRANGE("Loan No.", "No.");
        PAGE.RUN(0, LoanRefinancingEntry);
    end;

    local procedure ValidateLoanProduct()
    begin
        TESTFIELD("Member No.");
        IF LoanProductType.GET("Loan Product Type") THEN BEGIN
            IF NOT LoanProductType.Active THEN
                ERROR(Error006, "Loan Product Type");

            Description := LoanProductType.Description;
            "Interest Rate" := LoanProductType."Interest Rate";
            "Repayment Period" := LoanProductType."Repayment Period";
            "Repayment Method" := LoanProductType."Repayment Method";
            "Repayment Frequency" := LoanProductType."Repayment Frequency";
            "Date of Completion" := CALCDATE(FORMAT("Repayment Period") + 'M', "Created Date");

            IF FORMAT(LoanProductType."Grace Period") <> '' THEN BEGIN
                "Next Due Date" := CALCDATE(LoanProductType."Grace Period", "Created Date");
            END ELSE BEGIN
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Annually THEN
                    EVALUATE(DateFormula, '1Y');
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Quarterly THEN
                    EVALUATE(DateFormula, '3M');
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Monthly THEN
                    EVALUATE(DateFormula, '1M');
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Fortnightly THEN
                    EVALUATE(DateFormula, '2W');
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Weekly THEN
                    EVALUATE(DateFormula, '1W');
                IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Daily THEN
                    EVALUATE(DateFormula, '1D');
                "Next Due Date" := CALCDATE(DateFormula, "Created Date");
            END;
            IF LoanProductType."Based on Savings" THEN BEGIN
                IF "Requested Amount" > ("Total Savings Amount" * LoanProductType."Loan Savings Ratio") THEN
                    ERROR(Error000, "Member Name");
            END;
            IF LoanProductType."Based on Deposits" THEN BEGIN
                IF "Requested Amount" > ("Total Deposits Amount" * LoanProductType."Loan Deposit Ratio") THEN
                    ERROR(Error001, "Member Name");
            END;
            IF LoanProductType."Based on Shares" THEN BEGIN
                IF "Requested Amount" > ("Total Shares Amount" * LoanProductType."Loan Shares Ratio") THEN
                    ERROR(Error002, "Member Name");
            END;

            IF LoanProductType."Member Class" = LoanProductType."Member Class"::"Members Only" THEN BEGIN
                IF NOT ("Member Category" = "Member Category"::Member) THEN
                    ERROR(Error008, "Member Name");
                IF Employee.GET("Member No.") THEN BEGIN
                    MembershipDate := CALCDATE(LoanProductType."Min. Membership period", TODAY);
                    IF MembershipDate < Employee."Employment Date" THEN
                        ERROR(Error010, "Member Name");
                END;
            END;
            IF LoanProductType."Member Class" = LoanProductType."Member Class"::"Staff Only" THEN BEGIN
                IF NOT ("Member Category" = "Member Category"::Staff) THEN
                    ERROR(Error008, "Member Name");
                IF Member.GET("Member No.") THEN BEGIN
                    MembershipDate := CALCDATE(LoanProductType."Min. Membership period", TODAY);
                    IF MembershipDate < Member."Approval Date" THEN
                        ERROR(Error010, "Member Name");
                END;
            END;
            IF LoanProductType."Apply Graduation Schedule" THEN BEGIN

            END;
            IF GetNoofLoan > LoanProductType."No. of Loans at a Time" THEN
                ERROR(Error009, "Member Name");
        END;
    end;

    procedure GetGuarantors(): Boolean
    var
        LoanGuarantor: Record "Loan Guarantor";
    begin
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Loan No.", "No.");
        EXIT(LoanGuarantor.FINDFIRST);
    end;

    procedure GetSecurities(): Boolean
    var
        LoanSecurity: Record "Loan Security";
    begin
        LoanSecurity.RESET;
        LoanSecurity.SETRANGE("Loan No.", "No.");
        EXIT(LoanSecurity.FINDFIRST);
    end;

    local procedure DeleteRelatedLinks()
    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanSecurity: Record "Loan Security";
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Loan No.", "No.");
        LoanGuarantor.DELETEALL;

        LoanSecurity.RESET;
        LoanSecurity.SETRANGE("Loan No.", "No.");
        LoanSecurity.DELETEALL;

        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", "No.");
        LoanRepaymentSchedule.DELETEALL;
    end;

    procedure CheckMinimumGuarantors(): Integer
    begin
        IF LoanProductType.GET("Loan Product Type") THEN
            EXIT(LoanProductType."No. of Guarantors");
    end;

    procedure GetTotalSecurityAmount(): Decimal
    begin
        CALCFIELDS("Total Guaranteed Amount", "Total Security Amount");
        EXIT("Total Guaranteed Amount" + "Total Security Amount")
    end;

    local procedure GetNoofLoan(): Integer
    begin
        LoanApplication.RESET;
        LoanApplication.SETRANGE("Member No.", "Member No.");
        LoanApplication.SETRANGE(Cleared, FALSE);
        LoanApplication.SETRANGE(Posted, TRUE);
        EXIT(LoanApplication.COUNT);
    end;

    local procedure ValidateRequestedAmount()
    begin
        TESTFIELD("Member No.");
        TESTFIELD("Loan Product Type");
        IF LoanProductType.GET("Loan Product Type") THEN BEGIN
            IF NOT (LoanProductType."More Rates") THEN BEGIN
                IF "Requested Amount" < LoanProductType."Min. Loan Amount" THEN
                    ERROR(Error003, FIELDCAPTION("Requested Amount"));

                IF "Requested Amount" > LoanProductType."Max. Loan Amount" THEN
                    ERROR(Error004, FIELDCAPTION("Requested Amount"));
            END;
            IF LoanProductType."More Rates" THEN BEGIN
                LoanProductAdditionalRate.RESET;
                LoanProductAdditionalRate.SETRANGE("Loan Product Type", LoanProductType.Code);
                IF LoanProductAdditionalRate.FINDSET THEN BEGIN
                    REPEAT
                        IF ("Requested Amount" >= LoanProductAdditionalRate."Minimum Amount") AND ("Requested Amount" <= LoanProductAdditionalRate."Maximum Amount") THEN BEGIN
                            "Interest Rate" := LoanProductAdditionalRate."Interest Rate";
                            "Repayment Period" := LoanProductAdditionalRate."Repayment Period";
                        END;
                    UNTIL LoanProductAdditionalRate.NEXT = 0;
                END;
            END;

        END;
    end;

    procedure ValidateAttachment()
    var
        CBSAttachment: Record "CBS Attachment";
    begin
        IF LoanProductType.GET("Loan Product Type") THEN BEGIN
            IF LoanProductType."Attachment Mandatory" THEN BEGIN
                CBSAttachment.RESET;
                CBSAttachment.SETRANGE("Document No.", Rec."No.");
                IF NOT CBSAttachment.FINDFIRST THEN
                    ERROR(Error012);
            END;
        END;
    end;
}

