page 55164 "Pending CTS Entries"
{
    // version CTS2.0

    Editable = false;
    PageType = List;
    SourceTable = "CTS Entry";

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
                field("Clearance Date"; "Clearance Date")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Cheque No."; "Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Cheque Amount"; "Cheque Amount")
                {
                    ApplicationArea = All;
                }

                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Indicator; Indicator)
                {
                    ApplicationArea = All;
                }
                field("Unpaid Code"; "Unpaid Code")
                {
                    ApplicationArea = All;
                }
                field("Unpaid Reason"; "Unpaid Reason")
                {
                    ApplicationArea = All;
                }
                field("Amount To Pay"; "Amount To Pay")
                {
                    ApplicationArea = All;
                }
                field(Paid; Paid)
                {
                    ApplicationArea = All;
                }
                field("Paid Date"; "Paid Date")
                {
                    ApplicationArea = All;
                }
                field("Paid Time"; "Paid Time")
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

