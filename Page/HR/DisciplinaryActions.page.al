page 50427 "Disciplinary Actions"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50218;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Terminate; Terminate)
                {
                    ApplicationArea = All;
                }
                field(Document; Document)
                {
                    ApplicationArea = All;
                }
                field(Comments; Comments)
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

