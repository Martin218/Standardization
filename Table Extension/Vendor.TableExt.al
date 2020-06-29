tableextension 50000 VendorExt extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Member No."; Code[20])
        {
            TableRelation = Member;
        }
        field(50001; "Member Name"; Text[50])
        {

        }
        field(50002; "Account Type"; Code[20])
        {
            TableRelation = "Account Type";

        }

        field(50004; "Vendor Type"; Option)
        {
            OptionCaption = 'FOSA,Normal,Staff';
            OptionMembers = FOSA,Normal,Staff;

        }
        field(50005; Status; Option)
        {
            OptionCaption = 'Active,Blocked,Dormant,Frozen,Closed';
            OptionMembers = Active,Blocked,Dormant,Frozen,Closed;

        }
        field(50007; "Source Code"; Code[20])
        {
        }
        field(50009; "Withholding Tax"; Code[20])
        {
            TableRelation = "KRA Tax Codes";
        }
        field(50010; "VAT Withheld"; Code[20])
        {
            TableRelation = "KRA Tax Codes";
        }

        //Proc added
        field(50011; "Bank Account"; Code[20])
        {
            //TableRelation b
        }
        field(50012; "KBA Code"; Code[20])
        {

        }
        field(50013; "Bank Code"; Code[20])
        {

        }
        field(50016; "Pre-Qualified"; Boolean)
        {

        }
        field(50017; "Prequalified Category Code"; Code[20])
        {

        }
        field(50018; "Prequalified Category Desc"; Text[250])
        {

        }
    }

    var
        myInt: Integer;
}