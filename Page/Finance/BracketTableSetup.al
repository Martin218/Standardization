page 50502 "Bracket Table Setup"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Bracket Table";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table Code"; "Table Code")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Effective Starting Date"; "Effective Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Effective End Date"; "Effective End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            //Caption = 'General';
            group(Braket)
            {
                action("Bracket Lines")
                {
                    Image = AllLines;
                    Promoted = true;
                    PromotedCategory = Process;                    
                    RunObject = Page "Bracket Lines";
                    RunPageLink = "Table Code" = FIELD("Table Code");
                    ApplicationArea=All;
                }
            }
        }
        area(Processing)
        {
            action(Lines)
            {
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Bracket Lines";
                RunPageLink = "Table Code" = FIELD("Table Code");
            }
        }
    }
}

