page 50043 "Activation Types List"
{
    // version TL2.0

    Caption = 'Activation Types';
    CardPageID = "Activation Types";
    PageType = List;
    SourceTable = "Activation Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Application Area"; "Application Area")
                {
                    ApplicationArea = All;
                }
                field("Action Type"; "Action Type")
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

