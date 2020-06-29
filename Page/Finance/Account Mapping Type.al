page 50612 "Account Mapping Type"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Account Mapping Type";

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
                field(Prefix; Prefix)
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
                field("Staff Posting Group"; "Staff Posting Group")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {

            action("Account Mapping")
            {
                ApplicationArea = Basic, Suite;
                Image = AccountingPeriods;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Account Mapping";
                RunPageLink = "Account Type" = FIELD(Code);
            }
        }
    }
}

