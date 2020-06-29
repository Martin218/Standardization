page 50976 "Ready For Transfer File Card"
{
    // version TL2.0

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
                    ApplicationArea = All;
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
                }
                field("To Location"; "To Location")
                {
                    ApplicationArea = All;
                    Caption = 'To Branch';
                }
                field("Request Remarks"; "Request Remarks")
                {
                    ApplicationArea = All;
                }
                field("Approval/Rejection Remarks"; "Approval/Rejection Remarks")
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; "Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approver ID"; "Approver ID")
                {
                    ApplicationArea = All;
                }
                field("Released By"; "Released By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Released To"; "Released To")
                {
                    ApplicationArea = All;
                }
                field("Carried By"; "Carried By")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field("Date Released"; "Date Released")
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
            action("Dispatch File")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.DispatchFile(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        "Released By" := USERID;
        "Date Released" := CURRENTDATETIME;
        "Released To" := "Requested By";
    end;

    var
        User: Record "User Setup";
        //smtprec : Record "409";
        // smtpcu : Codeunit "400";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegisterLines: Record "Registry Files Line";
        RegistrySetUp: Record "Registry SetUp";
        RegistryManagement: Codeunit "Registry Management2";
}

