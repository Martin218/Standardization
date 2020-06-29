page 50480 "Qualifications Subform"
{
    // version TL2.0

    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = 50248;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Qualification Type"; "Qualification Type")
                {
                    ApplicationArea = All;
                }
                field("Qualification Code"; "Qualification Code")
                {
                    Caption = 'Qualification';
                    ApplicationArea = All;
                }
                field(Qualification; Qualification)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Priority; Priority)
                {
                    ApplicationArea = All;
                }
                field("Score ID"; "Score ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

