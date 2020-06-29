tableextension 50426 UserSetupExt extends "User Setup"
{
    fields
    {
        field(50001; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50002; "Substitute ID"; Code[50])
        {
            TableRelation = User."User Name";
        }
        field(50003; Signature; BLOB)
        {
            SubType = Bitmap;
        }
        field(50004; "User Name"; Text[100])
        {
        }
        field(50005; "Employee No."; Code[30])
        {
            TableRelation = Employee."No.";
        }
        field(50006; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50007; "Withdrawal Authorizing Officer"; Boolean)
        {
        }
        field(50008; "Registry User"; Boolean)
        {
        }
        field(50009; "Registry Approver"; Boolean)
        {
        }
        field(50010; HOD; Boolean)
        {
        }
        field(50011; "Boardroom Authoriser"; Boolean)
        {
        }
        field(50012; "C.E.O"; Boolean)
        {
        }
        field(50013; "Vehicle Approver"; Boolean)
        {
        }
    }


}