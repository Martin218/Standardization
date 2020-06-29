page 50161 "Cheque Clearance Subform"
{
    // version CTS2.0

    AutoSplitKey = true;
    DeleteAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Cheque Clearance Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select; Select)
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Sort Code"; "Sort Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Voucher Type"; "Voucher Type")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Processing Date"; "Processing Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
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
                field("Unpaid Reason"; "Unpaid Reason")
                {
                    ApplicationArea = All;
                }
                field("Unpaid Code"; "Unpaid Code")
                {
                    ApplicationArea = All;
                }
                field(Validated; Validated)
                {
                    ApplicationArea = All;
                }
                field("Presenting Bank"; "Presenting Bank")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Session; Session)
                {
                    ApplicationArea = All;
                }
                field("Bank No."; "Bank No.")
                {
                    ApplicationArea = All;
                }
                field("Branch No."; "Branch No.")
                {
                    ApplicationArea = All;
                }
                field("Sacco Account No."; "Sacco Account No.")
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
            action("Import PRM File")
            {
                Image = ImportCodes;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CLEAR(ImportPRMFile);
                    ChequeClearanceHeader.GET("Document No.");
                    ChequeClearanceHeader.TESTFIELD(Status, ChequeClearanceHeader.Status::New);
                    ImportPRMFile.SetDocumentNo(ChequeClearanceHeader."No.");
                    ImportPRMFile.RUN;
                end;
            }
            action("Validate PRM File")
            {
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    ChequeClearanceHeader.GET("Document No.");
                    ChequeClearanceHeader.TESTFIELD(Status, ChequeClearanceHeader.Status::New);
                    IF CONFIRM(ConfirmValidatePRMMsg, TRUE) THEN BEGIN
                        IF NOT LinesExist("Document No.") THEN
                            ERROR(NoLinesExistErr);

                        FOSAManagement.ValidatePRMEntry(ChequeClearanceHeader);
                    END;
                end;
            }
            action("Export PRM File")
            {
                Image = Export1099;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ChequeClearanceHeader.GET("Document No.");
                    ChequeClearanceHeader.TESTFIELD(Status, ChequeClearanceHeader.Status::Approved);
                    ChequeClearanceHeader.TESTFIELD(Posted, TRUE);
                    IF NOT LinesExist("Document No.") THEN
                        ERROR(NoLinesExistErr);
                    IF LinesNotValidated("Document No.") THEN
                        ERROR(NotValidatedErr);

                    CLEAR(ExportPRMFile);
                    ExportPRMFile.SetDocumentNo(Rec."Document No.");
                    ExportPRMFile.RUN;
                end;
            }
        }
    }

    var
        i: Integer;
        LineNo: Integer;
        ImportPRMFile: XMLport "Import PRM File";
        ExportPRMFile: XMLport "Export PRM File";
        ChequeClearanceHeader: Record "Cheque Clearance Header";
        IsVisibleExportPRMFile: Boolean;
        IsVisibleImportPRMFile: Boolean;
        FOSAManagement: Codeunit "FOSA Management";
        ConfirmValidatePRMMsg: Label 'Do you want to the validate PRM entries?';
        NoLinesExistErr: Label 'No PRM Entries Exist';
        NotValidatedErr: Label 'PRM Entries have not been validated';
}


