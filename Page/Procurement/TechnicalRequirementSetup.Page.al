page 50763 "Technical Requirement Setup"
{
    PageType = List;
    SourceTable = "Procurement Requirement Setup";
    SourceTableView = WHERE("Evaluation Stage" = FILTER(Technical));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Evaluation Stage"; "Evaluation Stage")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Needs Attachment"; "Needs Attachment")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        "Evaluation Stage" := "Evaluation Stage"::Technical;
    end;
}

