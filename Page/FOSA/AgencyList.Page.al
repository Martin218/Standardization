page 50055 "Agency List"
{
    // version TL2.0

    Caption = 'Agencies';
    CardPageID = "Agency Card";
    PageType = List;
    SourceTable = Agency;

    layout
    {
        area(content)
        {
            repeater(Agency)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

