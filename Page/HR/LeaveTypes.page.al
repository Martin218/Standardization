page 50412 "Leave Types"
{
    // version TL2.0

    Editable = true;
    PageType = List;
    SourceTable = 50208;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Days; Days)
                {
                    ApplicationArea = All;
                }
                field("Unlimited Days"; "Unlimited Days")
                {
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    ApplicationArea = All;
                }
                field("Max Carry Forward Days"; "Max Carry Forward Days")
                {
                    ApplicationArea = All;
                }
                field("Calendar Days"; "Calendar Days")
                {
                    ApplicationArea = All;
                }
                field(Weekdays; Weekdays)
                {
                    ApplicationArea = All;
                }
                field("Off/Holidays Days Leave"; "Off/Holidays Days Leave")
                {
                    ApplicationArea = All;
                }
                field("Employment Status"; "Employment Status")
                {
                    ApplicationArea = All;
                }
                field("Eligible Staff"; "Eligible Staff")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit();
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;
}

