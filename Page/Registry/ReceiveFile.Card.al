page 50978 "Receive File Card"
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
                field(Received; Received)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("File Movement ID"; "File Movement ID")
                {
                    ApplicationArea = All;
                }
                field("File No."; "File No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Editable = false;
                }
                field("Cabinet No."; "Cabinet No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Volume; Volume)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("From Location"; "From Location")
                {
                    ApplicationArea = All;
                    Caption = 'From Branch';
                    Editable = false;
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
                    Editable = false;
                }
                field("Approval/Rejection Remarks"; "Approval/Rejection Remarks")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Editable = false;
                }
                field("Date Released"; "Date Released")
                {
                    ApplicationArea = All;
                }
                field("Received By"; "Received By")
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
            action("Receive File")
            {
                ApplicationArea = All;
                Image = ReceivableBill;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.ReceiveFile(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        FilesMvt: Record "File Movement";
        User: Record "User Setup";
        //smtprec : Record "409";
        //smtpcu : Codeunit "400";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegisterLines: Record "Registry Files Line";
        RegistrySetUp: Record "Registry SetUp";
        //Cust: Record "18";
        //NoSetup : Record "50011";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        noseries: Record "No. Series";
        ChangeApproved: Boolean;
        SendRequest: Boolean;
        TransferFilesLines: Record "Registry Files Line";
        //MemberAgencies : Record "50018";
        //DimensionValue : Record "349";
        Location: Code[50];
        CurrentYear: Integer;
        BranchNumberSeries: Code[50];
        FileStatus: Code[40];
        RegistryFileStatus: Record "Registry File Status";
        RegFileDesc: Text[50];
        RegistryFiles: Record "Registry File";
        branch: Code[50];
        // DimensionValue1 : Record "349";
        branchname: Text[20];
        branchName2: Text;
        RegistryManagement: Codeunit "Registry Management2";
}

