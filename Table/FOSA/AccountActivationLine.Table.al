table 50032 "Account Activation Line"
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
                IF Member.GET("Member No.") THEN BEGIN
                    "Member Name" := Member."Application No.";
                    "National ID" := Member."National ID";
                END;
            end;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "National ID"; Code[20])
        {
            Editable = false;
        }
        field(6; "Current Account Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Dormant,Withdrawn,Deceased';
            OptionMembers = Active,Dormant,Withdrawn,Deceased;
        }
        field(7; "New Member Status"; Option)
        {
            OptionCaption = 'Active,Dormant,Withdrawn,Deceased';
            OptionMembers = Active,Dormant,Withdrawn,Deceased;
        }
        field(8; "Activation Code"; Code[20])
        {
            TableRelation = "Activation Type" WHERE("Application Area" = FILTER(Account));

            trigger OnValidate()
            begin
                TESTFIELD("Member No.");
            end;
        }
        field(9; "Account No."; Code[30])
        {
            TableRelation = IF ("Account Type" = FILTER(Vendor)) Vendor
            ELSE
            IF ("Account Type" = FILTER(Customer)) Customer;

            trigger OnValidate()
            begin
                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    IF Customer.GET("Account No.") THEN BEGIN
                        "Account Name" := Customer.Name;
                        "Current Account Status" := Customer.Status;
                    END;
                END;
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET("Account No.") THEN BEGIN
                        "Account Name" := Vendor.Name;
                        "Current Account Status" := Vendor.Status;
                    END;
                END;
            end;
        }
        field(10; "Account Type"; Option)
        {
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;
        }
        field(11; "Account Name"; Text[50])
        {
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
        Member: Record Member;
        Customer: Record Customer;
        Vendor: Record Vendor;
}

