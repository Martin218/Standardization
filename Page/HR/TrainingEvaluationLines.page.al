page 50517 "Training Evaluation Lines"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = 50276;
    SourceTableView = WHERE("Selective Question" = FILTER('Yes'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Question; Question)
                {
                    ApplicationArea = All;
                }
                field("Selective Answer"; "Selective Answer")
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

