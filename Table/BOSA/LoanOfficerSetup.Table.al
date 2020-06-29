table 52001 "Loan Officer Setup"
{
    // version MC2.0

    DrillDownPageID = "Loan Officer Setup";
    LookupPageID = "Loan Officer Setup";

    fields
    {
        field(1; "User ID"; Code[30])
        {
            TableRelation = "User Setup";
        }
        field(2; "ID No."; Code[20])
        {
        }
        field(3; "Phone No."; Code[20])
        {
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                //MODIFY;
            end;
        }
        field(5; Status; Option)
        {
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
        field(6; "First Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "First Name" := UPPERCASE("First Name");
            end;
        }
        field(7; "Last Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Last Name" := UPPERCASE("Last Name");
            end;
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
        }
    }

    fieldgroups
    {
    }
}

