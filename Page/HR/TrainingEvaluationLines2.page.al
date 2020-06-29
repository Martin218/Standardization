page 50518 "Training Evaluation Lines2"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = 50276;
    SourceTableView = WHERE("Selective Question" = FILTER('No'));

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
                field("Narrative Answer"; "Narrative Answer")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

