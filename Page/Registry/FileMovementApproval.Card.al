page 50973 "File Movement Approval Card"
{
    // version TL2.0

    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "File Movement";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("File Movement ID"; "File Movement ID")
                {
                    ApplicationArea = All;
                }
                field("File No."; "File No.")
                {
                    ApplicationArea = All;
                }
                field("File Number"; "File Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Member No"; "Member No")
                {
                    ApplicationArea = All;
                }
                field("ID No"; "ID No")
                {
                    ApplicationArea = All;
                }
                field("Payroll No"; "Payroll No")
                {
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Cabinet No."; "Cabinet No.")
                {
                    ApplicationArea = All;
                }
                field(Volume; Volume)
                {
                    ApplicationArea = All;
                }
                field("From Location"; "From Location")
                {
                    ApplicationArea = All;
                    Caption = 'From Branch';
                    Editable = true;
                }
                field("To Location"; "To Location")
                {
                    ApplicationArea = All;
                    Caption = 'To Branch';
                    Editable = false;
                }
                field("Request Remarks"; "Request Remarks")
                {
                    ApplicationArea = All;
                }
                field("Approval/Rejection Remarks"; "Approval/Rejection Remarks")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        "Approver ID" := USERID;
                        "Approved Date" := CURRENTDATETIME;
                    end;
                }
                field("Approved Date"; "Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approver ID"; "Approver ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Approve Request")
            {
                ApplicationArea = All;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.ApproveFileTransfer(Rec);
                end;
            }
            action("Reject Request")
            {
                ApplicationArea = All;
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.RejectFileTransfer(Rec);
                end;
            }
        }
    }

    var
        User: Record "User Setup";
        RegistryManagement: Codeunit "Registry Management2";
}

