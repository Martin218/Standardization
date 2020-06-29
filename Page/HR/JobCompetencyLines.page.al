page 50529 "Job Competency Lines"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = 50285;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Performance Competency Code"; "Performance Competency Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
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

