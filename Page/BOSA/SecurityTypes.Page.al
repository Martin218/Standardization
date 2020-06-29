page 50208 "Security Type List"
{
    // version TL2.0

    Caption = 'Security Types';
    PageType = List;
    SourceTable = "Security Type";
    UsageCategory = Administration;
    ApplicationArea = All;

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
                    ApplicationArea = All;
                }
                field(Factor; Factor)
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

