table 50119 "Beneficiary Allocation"
{
    // version TL2.0


    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Source Account No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
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
        field(6; "Allocation Amount"; Decimal)
        {
        }
        field(7; "Account Category"; Option)
        {
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;
        }
        field(8; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Category" = FILTER(Vendor)) Vendor WHERE("Member No." = FIELD("Member No."))
            ELSE
            IF ("Account Category" = FILTER(Customer)) Customer WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                ExitSetup.GET;

                IF "Account Category" = "Account Category"::Customer THEN BEGIN
                    IF Customer.GET("Account No.") THEN
                        "Account Name" := Customer.Name;
                END;
                IF "Account Category" = "Account Category"::Vendor THEN BEGIN
                    IF ExitSetup."Refund Shares to Shares" THEN BEGIN
                        IF IsSharesAccount("Account No.") <> IsSharesAccount("Source Account No.") THEN
                            ERROR(Error000);
                    END;

                    IF Vendor.GET("Account No.") THEN
                        "Account Name" := Vendor.Name;
                END;
            end;
        }
        field(9; "Account Name"; Text[50])
        {
            Editable = false;

        }
    }

    keys
    {
        key(Key1; "Document No.", "Source Account No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;
        Vendor: Record Vendor;
        Customer: Record "Customer";
        ExitSetup: Record "Exit Setup";
        Error000: Label 'You can only refund to a shares account';

    local procedure IsSharesAccount(AccountNo: Code[20]): Boolean
    var
        AccountType: Record "Account Type";
    begin
        Vendor.GET(AccountNo);
        AccountType.SETRANGE(Code, Vendor."Account Type");
        AccountType.SETRANGE(Type, AccountType.Type::"Share Capital");
        EXIT(AccountType.FINDFIRST);
    end;
}

