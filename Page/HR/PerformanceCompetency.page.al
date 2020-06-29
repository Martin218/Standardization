page 50527 "Performance Competency"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50283;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
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

