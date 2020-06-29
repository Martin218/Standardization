page 50969 "File Return Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "File Return";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Return ID"; "Return ID")
                {
                    ApplicationArea = All;
                }
                field("Return Date"; "Return Date")
                {
                    ApplicationArea = All;
                }
                field("Staff Name"; "Staff Name")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                }
            }
            part(Page; 50962)
            {
                SubPageLink = "Transfer ID" = FIELD("Return ID");
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Return File")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.ReturnFile(Rec);
                end;
            }
        }
    }

    var

        FileRegistry: Record "Registry File";
        RegisterLines: Record "Registry Files Line";
        RegistryManagement: Codeunit "Registry Management2";

}

