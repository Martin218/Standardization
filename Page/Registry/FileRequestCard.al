page 50961 "File Request Card"
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
                }
                field("Duration Required(Days)"; "Duration Required(Days)")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Requisiton By"; "Requisiton By")
                {
                    ApplicationArea = All;
                }
                field(Reason; Reason)
                {
                    ApplicationArea = All;
                    LookupPageID = "Registry Request Reason";
                    ShowMandatory = true;
                }
                field("Request Status"; "Request Status")
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                }
            }
            part("Registry Files Subform"; 50962)
            {
                ApplicationArea = All;

                Caption = 'Registry Files Request List';
                SubPageLink = "Request ID" = FIELD("Request ID"),
                              "Request Status" = FIELD("Request Status");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send File Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;


                trigger OnAction();
                begin
                    RegistryManagement.SendFileRequest(Rec);

                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        Simple := TRUE;
        User.reset;
        User.GET(USERID);

        UserRequestCount := UserRec.COUNT;
        UserRequestCount := 0;
        UserRec.RESET;
        UserRec.SETFILTER(Returned, 'False');
        UserRec.SETRANGE(UserRec."Current User ID", USERID);
        IF UserRec.FIND('-') THEN BEGIN
            REPEAT
                UserRequestCount := UserRequestCount + 1;
            UNTIL
              UserRec.NEXT = 0;
        END;
        RegistrySetUp.RESET;
        RegistrySetUp.GET;
        IF UserRequestCount > RegistrySetUp."Max. Files held by a person" THEN
            ERROR('You are currently in possession of %1 files. Maximum files allowed per person is %2. Please Return the files in order to be able to request for more files.', UserRequestCount, RegistrySetUp."Max. Files held by a person");
        //  CurrPage.CLOSE;
        EXIT;
    end;

    var
        FileRegistry: Record "Registry File";
        AddMoreFileRequests: Label 'Add More File Requests';
        Simple: Boolean;
        FileIssuance: Record "File Issuance";
        RegistryFilesSubform: Page "Registry Files Subform";
        RegistryFilesLines: Record "Registry Files Line";
        UserRequestCount: Integer;
        UserRec: Record "Transfer Files Line";
        HODApproval: Boolean;
        NoHODApproval: Boolean;
        RegistrySetUp: Record "Registry SetUp";
        User: Record "User Setup";
        HODApproval2: Boolean;
        // smtprec : Record "409";
        // smtpcu : Codeunit "400";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegisterLines: Record "Registry Files Line";
        RegistryManagement: Codeunit "Registry Management2";
}

