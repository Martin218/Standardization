table 50149 "Agency Remittance Line"
{

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
        }
        field(4; "Member Name"; Text[50])
        {
        }
        field(5; "Account Category"; Option)
        {
            Editable = false;
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;
        }
        field(6; "Account Type"; Code[20])
        {
            TableRelation = IF ("Account Category" = FILTER(Vendor)) "Account Type"
            ELSE
            IF ("Account Category" = FILTER(Customer)) "Loan Product Type";
        }
        field(7; "Account No."; Code[20])
        {
            Editable = false;
            TableRelation = IF ("Account Type" = FILTER(0)) Customer
            ELSE
            IF ("Account Type" = FILTER(1)) Vendor;

            trigger OnValidate()
            begin
                IF "Account Category" = "Account Category"::Vendor THEN BEGIN
                    IF Vendor.GET("Account No.") THEN
                        "Account Name" := Vendor.Name;
                END;
                IF "Account Category" = "Account Category"::Customer THEN BEGIN
                    IF Customer.GET("Account No.") THEN
                        "Account Name" := Customer.Name;
                END;
            end;
        }
        field(8; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(9; "Remittance Code"; Code[20])
        {
            TableRelation = "Remittance Code";
        }
        field(10; "Expected Amount"; Decimal)
        {
        }
        field(11; "Actual Amount"; Decimal)
        {
        }
        field(12; "Contribution Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Normal,Principal Due,Interest Due,Insurance';
            OptionMembers = Normal,"Principal Due","Interest Due",Insurance;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record Vendor;
        Customer: Record "Customer";
}

