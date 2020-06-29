page 50759 "Evaluation Requirement Setup"
{
    PageType = List;
    SourceTable = "Procurement Requirement Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Evaluation Stage"; "Evaluation Stage")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Needs Attachment"; "Needs Attachment")
                {
                    ApplicationArea = All;
                }
                field("Procurement Option"; "Procurement Option")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Mandatory Requirements")
            {
                ApplicationArea = All;
                RunObject = Page 50761;
            }
            action("Technical Requirements")
            {
                ApplicationArea = All;
                RunObject = Page 50763;
            }
            action("Financial Requirements")
            {
                ApplicationArea = All;
                RunObject = Page 50762;
            }
        }
    }
}

