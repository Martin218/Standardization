page 50750 "Supplier Category"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Supplier Category";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Category Code"; "Category Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Vendor Posting Group"; "Vendor Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("No. Prequalified"; "No. Prequalified")
                {
                    ApplicationArea = All;
                }
                field("Year Filter"; "Year Filter")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

