table 50081 "Standing Order Line"
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
        field(3; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN
                    "Member Name" := Member."Full Name";
            end;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = FILTER(Customer)) Customer WHERE("Member No." = FIELD("Member No."))
            ELSE
            IF ("Account Type" = FILTER(Vendor)) Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET("Account No.") THEN
                        "Account Name" := Vendor.Name;
                END;

                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    IF Customer.GET("Account No.") THEN
                        "Account Name" := Customer.Name;
                END;
            end;
        }
        field(6; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Line Amount"; Decimal)
        {

            trigger OnValidate()
            var
                NetAllocatedAmount: array[4] of Decimal;
            begin

            end;
        }
        field(9; Priority; Integer)
        {
        }
        field(10; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = ',Customer,Vendor';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(11; "Destination Type"; Option)
        {
            OptionCaption = 'Internal,External';
            OptionMembers = Internal,External;
        }
        field(12; "Destination Account No."; Code[10])
        {
        }
        field(13; "Destination Account Name"; Text[50])
        {
        }
        field(14; "Destination Bank Name"; Text[50])
        {
        }
        field(15; "Destination Branch Name"; Text[50])
        {
        }
        field(16; "Swift Code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Destination Type", "Line No.")
        {
        }
        key(Key2; Priority)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;
        Vendor: Record Vendor;
        StandingOrder: Record "Standing Order";
        Customer: Record Customer;
        StandingOrderLine: Record "Standing Order Line";
        Error000: Label 'Allocated Amount cannot exceed the Amount to Deduct';
}

