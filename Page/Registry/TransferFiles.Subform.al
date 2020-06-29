page 50980 "Transfer Files Subform"
{
    // version TL2.0

    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Transfer Files Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("File No"; "File No")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("File Number"; "File Number")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Member No"; "Member No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("ID No"; "ID No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Payroll No"; "Payroll No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Released From"; "Released From")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Time Released"; "Time Released")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Released To"; "Released To")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Received By"; "Received By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Time Received"; "Time Received")
                {
                    ApplicationArea = All;
                }
                field("Current User ID"; "Current User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        User.GET(USERID);
    end;

    var
        User: Record "User Setup";
        TransferFilesLines: Record "Transfer Files Line";
}

