page 50168 "Cheque Book"
{
    // version CTS2.0

    PageType = Card;
    SourceTable = "Cheque Book";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
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
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = All;
                }
                field("No. of Leaves"; "No. of Leaves")
                {
                    ApplicationArea = All;
                }
                field("Start Leaf No."; "Start Leaf No.")
                {
                    ApplicationArea = All;
                }
                field("End Leaf No."; "End Leaf No.")
                {
                    ApplicationArea = All;
                }
                field("Last Leaf Used"; "Last Leaf Used")
                {
                    ApplicationArea = All;
                    // BlankZero=true;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(Active; Active)
                {
                    ApplicationArea = All;
                }

            }
            group(Audit)
            {
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
            }

        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    var

    begin
        SetEditable();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF Status <> Status::New THEN
            ERROR('');
    end;

    local procedure SetEditable()
    begin

        IF Status = Status::Issued THEN
            CurrPage.EDITABLE := FALSE
        else
            CurrPage.Editable := true;

    end;

}