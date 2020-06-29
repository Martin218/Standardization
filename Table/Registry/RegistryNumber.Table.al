table 50473 "Registry Number"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[50])
        {
        }
        field(2; Branch; Code[10])
        {
            //TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=FILTER(1));
        }
        field(3; "RegFile Status"; Code[20])
        {
            TableRelation = "Registry File Status"."Status Code";
        }
        field(4; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; Branch, "RegFile Status")
        {
        }
    }

    fieldgroups
    {
    }
}

