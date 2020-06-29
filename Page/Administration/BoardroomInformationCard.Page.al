page 50984 "Boardroom Information Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Boardroom Detail";

    layout
    {
        area(content)
        {
            group("Boardroom Info")
            {
                field("Boardroom No"; "Boardroom No")
                {
                    ApplicationArea = All;

                }
                field("Boardroom Name"; "Boardroom Name")
                {
                    ApplicationArea = All;

                }
                field(Location; Location)
                {
                    ApplicationArea = All;

                }
                field(Address; Address)
                {
                    ApplicationArea = All;

                }
                field(Save; Register)
                {
                    ApplicationArea = All;

                }
                field("Equipment Available"; "Equipment Available")
                {
                    ApplicationArea = All;

                }
                field("Maximum Capacity"; "Maximum Capacity")
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
            action(Register)
            {
                ApplicationArea = all;
                Caption = 'Save Boardroom Details';
                Image = CreateWhseLoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.SaveBoardroomDetails(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        RegistryManagement: Codeunit "Registry Management2";
}

