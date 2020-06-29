table 50037 "Member Agency"
{
    // version TL2.0


    fields
    {
        field(1; "Agency Code"; Code[10])
        {
            TableRelation = Agency;

            trigger OnValidate()
            begin
                Agency.GET("Agency Code");
                "Agency Name" := Agency.Name;
            end;
        }
        field(2; "Member Agency No."; Code[20])
        {
        }
        field(3; "Payroll No."; Code[50])
        {
        }
        field(4; "Agency Name"; Code[100])
        {
        }
        field(5; "Member No."; Code[30])
        {
            TableRelation = Member;
        }
        field(6; "Pay To Account No."; Code[10])
        {
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));
        }
    }

    keys
    {
        key(Key1; "Member No.", "Agency Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Agency: Record Agency;
}

