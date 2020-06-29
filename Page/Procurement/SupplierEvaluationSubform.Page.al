page 50764 "Supplier Evaluation Subform"
{
    PageType = ListPart;
    SourceTable = "Supplier Evaluation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Stage"; "Evaluation Stage")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Code"; "Evaluation Code")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Description"; "Evaluation Description")
                {
                    ApplicationArea = All;
                }
                field("Needs Attachment"; "Needs Attachment")
                {
                    ApplicationArea = All;
                }
                field("Document Attached"; "Document Attached")
                {
                    ApplicationArea = All;
                }
                field("Score(%)"; "Score(%)")
                {
                    ApplicationArea = All;
                }
                field("Success Option"; "Success Option")
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

