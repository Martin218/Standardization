page 50494 "Training Evaluation Questions"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50274;
    UsageCategory = Lists;
    ApplicationArea = all;

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
                field("Selective Question"; "Selective Question")
                {
                    ApplicationArea = All;
                }
                field("Option Set"; "Option Set")
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

