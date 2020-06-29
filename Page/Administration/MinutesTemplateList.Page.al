page 50996 "Minutes Template List"
{
    // version TL2.0

    CardPageID = "Minutes Template Card";
    PageType = List;
    SourceTable = MinuteTemplate;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Day of meeting"; "Day of meeting")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(user; user)
                {
                    Caption = 'Attached By';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

