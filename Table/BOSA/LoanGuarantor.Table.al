table 50105 "Loan Guarantor"
{
    // version TL2.0

    DrillDownPageID = 50210;
    LookupPageID = 50210;

    fields
    {
        field(1; "Loan No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN
                    "Member Name" := Member."Full Name";
                CalculateGuaranteedAmount;
            end;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Account No."; Code[20])
        {
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF Vendor.GET("Account No.") THEN BEGIN
                    "Account Name" := Vendor.Name;
                    CalculateGuaranteedAmount;
                    "Account Balance" := BOSAManagement.GetAccountBalance(0, "Account No.");
                    "Net Account Balance" := "Account Balance" - "Other Guaranteed Amount";
                    IF "Net Account Balance" <= 0 THEN
                        ERROR(Error001);
                END;
            end;
        }
        field(6; "Account Name"; Text[50])
        {
        }
        field(7; "Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(8; "Other Guaranteed Amount"; Decimal)
        {
            Editable = false;
        }
        field(9; "Net Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(10; "Amount To Guarantee"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Amount To Guarantee" > "Net Account Balance" THEN
                    ERROR(Error000, FIELDCAPTION("Amount To Guarantee"), FIELDCAPTION("Net Account Balance"));
            end;
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;
        Vendor: Record Vendor;
        AccountType: Record "Account Type";
        LoanGuarantor: Record "Loan Guarantor";
        LoanApplication: Record "Loan Application";
        BOSAManagement: Codeunit "BOSA Management";
        Error000: Label '%1 cannot exceed %2';
        Error001: Label 'This account has insufficient balance';

    local procedure CalculateGuaranteedAmount()
    begin
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Member No.", "Member No.");
        LoanGuarantor.CALCSUMS("Amount To Guarantee");
        "Other Guaranteed Amount" := LoanGuarantor."Amount To Guarantee";
    end;
}

