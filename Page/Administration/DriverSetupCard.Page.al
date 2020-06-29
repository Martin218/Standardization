page 51015 "Driver Setup Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Driver Setup";

    layout
    {
        area(content)
        {
            group(Driver)
            {
                field("Full Names"; "Full Names")
                {
                    ApplicationArea = All;

                }
                field("ID NO."; "ID NO.")
                {
                    ApplicationArea = All;

                }
                field("Driving License"; "Driving License")
                {
                    ApplicationArea = All;

                }
                field(Designation; Designation)
                {
                    ApplicationArea = All;

                }
                field(Branch; Branch)
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
            action("Save Driver Details")
            {
                Image = Save;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin

                    TESTFIELD("Full Names");
                    TESTFIELD("ID NO.");

                    MESSAGE(TEXT001);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        driver: Record "Driver Setup";
        AdminManagement: Codeunit "Admin Management";
        TEXT001: Label 'Details saved succesfully.';
}

