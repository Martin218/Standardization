page 55045 "Portfolio Transfer Entries"
{
    // version MC2.0

    Editable = false;
    PageType = List;
    SourceTable = "Portfolio Transfer Entry";

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
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Transfer Date"; "Transfer Date")
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
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Transferred Loan Amount"; "Transferred Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Previous Loan Officer ID"; "Previous Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field("Previous Branch Code"; "Previous Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Current Loan Officer ID"; "Current Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field("Current Branch Code"; "Current Branch Code")
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

