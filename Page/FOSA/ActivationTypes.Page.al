page 50041 "Activation Types"
{
    // version TL2.0

    PageType = Document;
    SourceTable = "Activation Type";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code2; Code)
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
            part("Activation Charge Subform"; "Activation Charge Subform")
            {
                SubPageLink = "Activation Code" = FIELD(Code);
            }
        }
    }

    actions
    {
    }
}

