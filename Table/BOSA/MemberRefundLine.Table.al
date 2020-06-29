table 50118 "Member Refund Line"
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
        field(3; "Account Category"; Option)
        {
            OptionCaption = 'Customer,Vendor';
            OptionMembers = Customer,Vendor;
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = FILTER(0)) Vendor
            ELSE
            IF ("Account Type" = FILTER(1)) Customer;

            trigger OnValidate()
            begin
                IF Vendor.GET("Account No.") THEN BEGIN
                    Vendor.CALCFIELDS("Balance (LCY)");
                    "Account Name" := Vendor.Name;
                    "Account Balance" := ABS(Vendor."Balance (LCY)");
                END;
                IF Customer.GET("Account No.") THEN BEGIN
                    Vendor.CALCFIELDS("Balance (LCY)");
                    "Account Name" := Customer.Name;
                    "Account Balance" := ABS(Customer."Balance (LCY)");
                END;
            end;
        }
        field(5; "Account Name"; Text[50])
        {
        }
        field(6; "Account Balance"; Decimal)
        {
        }
        field(7; "Account Ownership"; Option)
        {
            OptionCaption = 'Self,Guaranteed';
            OptionMembers = Self,Guaranteed;
        }
        field(8; "Account Type"; Code[20])
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
        Vendor: Record Vendor;
        Customer: Record "Customer";
}

