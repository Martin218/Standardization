page 50523 "Evaluation Questions"
{
    // version TL2.0

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = 50282;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Select; Select)
                {
                    ApplicationArea = All;
                }
                field(Question; Question)
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

