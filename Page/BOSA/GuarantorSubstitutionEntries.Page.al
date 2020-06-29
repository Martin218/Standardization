page 50278 "Guarantor Substitution Entries"
{
    // version TL2.0

    Editable = false;
    PageType = List;
    SourceTable = "Guarantor Substitution Entry";
    UsageCategory = History;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Previous Guarantor No."; "Previous Guarantor No.")
                {
                    ApplicationArea = All;
                }
                field("Previous Guarantor Name"; "Previous Guarantor Name")
                {
                    ApplicationArea = All;
                }
                field("New Guarantor No."; "New Guarantor No.")
                {
                    ApplicationArea = All;
                }
                field("Previous Amount Guaranteed"; "Previous Amount Guaranteed")
                {
                    ApplicationArea = All;
                }
                field("New Guarantor Name"; "New Guarantor Name")
                {
                    ApplicationArea = All;
                }
                field("New Amount Guaranteed"; "New Amount Guaranteed")
                {
                    ApplicationArea = All;
                }
                field("Substitution Date"; "Substitution Date")
                {
                    ApplicationArea = All;
                }
                field("Substitution Time"; "Substitution Time")
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

