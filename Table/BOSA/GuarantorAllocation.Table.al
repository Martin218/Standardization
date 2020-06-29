table 50139 "Guarantor Allocation"
{
    // version TL2.0


    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Guarantor Member No."; Code[20])
        {
        }
        field(4; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN
                    "Member Name" := Member."Full Name";
            end;
        }
        field(5; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Account No."; Code[20])
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
        field(7; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(8; "Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(9; "Other Guaranteed Amount"; Decimal)
        {
            Editable = false;
        }
        field(11; "Net Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(12; "Amount To Guarantee"; Decimal)
        {

            trigger OnValidate()
            var
                NetAllocatedAmount: array[4] of Decimal;
            begin
                TESTFIELD("Account No.");

                IF "Amount To Guarantee" > "Net Account Balance" THEN
                    ERROR(Error000, FIELDCAPTION("Amount To Guarantee"), FIELDCAPTION("Net Account Balance"));
            end;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Guarantor Member No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;
        Vendor: Record Vendor;
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        GuarantorSubstitutionLine: Record "Guarantor Substitution Line";
        BOSAManagement: Codeunit "BOSA Management";
        Error000: Label '%1 cannot exceed %2';
        Error001: Label 'This account has insufficient balance';

    local procedure CalculateGuaranteedAmount()
    var
        LoanGuarantor: Record "Loan Guarantor";
    begin
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Member No.", "Member No.");
        LoanGuarantor.CALCSUMS("Amount To Guarantee");
        "Other Guaranteed Amount" := LoanGuarantor."Amount To Guarantee";
    end;
}

