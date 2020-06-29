table 50052 "Account Transfer Line"
{
    // version TL2.0


    fields
    {
        field(1; "Transaction ID"; Code[30])
        {
        }
        field(2; "Member No."; Code[30])
        {
            TableRelation = Member;
        }
        field(3; "Member Name"; Text[80])
        {
            Editable = false;
        }
        field(4; "Account No."; Code[30])
        {
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF Vendor.GET("Account No.") THEN BEGIN
                    AccountTypes.GET(Vendor."Account Type");
                    "Account Name" := Vendor.Name;
                    Vendor.CALCFIELDS(Balance);
                    "Account Balance" := Vendor.Balance;
                    "Member Name" := Vendor."Member Name";
                    "Member No." := Vendor."Member No.";
                END;
            end;
        }
        field(5; "Account Name"; Text[50])
        {
        }
        field(6; "Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(7; Posted; Boolean)
        {
        }
        field(8; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Transaction ID", "Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
        Member: Record "Member";
}

