page 50761 "Mandatory Requirement Setup"
{
    PageType = List;
    SourceTable = "Procurement Requirement Setup";
    SourceTableView = WHERE("Evaluation Stage" = FILTER(Mandatory));

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
                    Editable = false;
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
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        "Evaluation Stage" := "Evaluation Stage"::Mandatory;
    end;
}

