page 50966 "File Issue Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "File Issuance";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Request ID"; "Request ID")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Required Date"; "Required Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Duration Required(Days)"; "Duration Required(Days)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("File No."; "File No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Requisiton By"; "Requisiton By")
                {
                    ApplicationArea = All;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Reason; Reason)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Carried By"; "Carried By")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            part("Registry Files Subform"; 50962)
            {
                Caption = 'Registry Files Request List';
                Editable = false;
                SubPageLink = "Request ID" = FIELD("Request ID");
            }
            group(Remarks)
            {
                field("Approval Comment"; "Approval Comment")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approver ID"; "Approver ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Issuer Remarks"; Remarks)
                {
                    ApplicationArea = All;
                    Caption = 'Issuer Remarks';
                }
                field("Issuer ID"; "Issuer ID")
                {
                    ApplicationArea = All;
                }
                field("Issued Date"; "Issued Date")
                {
                    ApplicationArea = All;
                }
                field("Rejection Comment"; "Rejection Comment")
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
            action("Ready For PickUp")
            {
                Image = Shipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.AvailFileForPickup(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Reject Request")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.RejectFilePickup(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        /*User.GET(USERID);
        IF User."Registry Approver"=TRUE THEN BEGIN
          RegistryApproval:=TRUE;
        END;*/

    end;

    var
        FileRegistry: Record "Registry File";
        Simple: Boolean;
        RegisterLines: Record "Registry Files Line";
        RegistryApproval: Boolean;
        User: Record "User Setup";
        // smtprec : Record "409";
        //smtpcu : Codeunit "400";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegistryFilesLines: Record "Registry Files Line";
        RegistrySetUp: Record "Registry SetUp";
        ApprovedRequests: Integer;
        RequestsRec: Record "Registry Files Line";
        RegistryManagement: Codeunit "Registry Management2";
}

