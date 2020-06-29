table 50069 "SpotCash Ledger Entry"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Transaction No."; Code[20])
        {
        }
        field(3; "Phone No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF SpotCashMember.GET("Phone No.") THEN BEGIN
                    "Account No." := SpotCashMember."Account Name";
                    "Member No." := SpotCashMember."Member Name";
                END;
            end;
        }
        field(4; "Member No."; Code[20])
        {
        }
        field(5; "Account No."; Code[20])
        {
        }
        field(6; "Transaction Date"; Date)
        {
        }
        field(7; "Transaction Time"; Time)
        {
        }
        field(8; Description; Text[50])
        {
        }
        field(9; Amount; Decimal)
        {
        }
        field(10; Reversed; Boolean)
        {
        }
        field(11; "Service ID"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Transaction Date" := TODAY;
        "Transaction Time" := TIME;
    end;

    var
        SpotCashMember: Record "SpotCash Member";
}
