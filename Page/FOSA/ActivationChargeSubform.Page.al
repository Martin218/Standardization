page 50042 "Activation Charge Subform"
{
    // version TL2.0

    Caption = 'Activation Charge Subform';
    PageType = ListPart;
    SourceTable = "Activation Charge Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Charge Code"; "Charge Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("GL Account No."; "GL Account No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
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

