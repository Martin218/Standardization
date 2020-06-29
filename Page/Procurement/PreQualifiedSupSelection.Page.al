page 50756 "Pre-Qualified Sup. Selection"
{
    // version TL2.0

    Editable = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Procurement Supplier Selection";
    PromotedActionCategories = 'New,Process,Reports,EOI Evaluation';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select; Select)
                {
                    Editable = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                    Editable = false;
                }
                field(Name; Name)
                {
                    Editable = true;
                }
                field("Tender Receipt No."; "Tender Receipt No.")
                {
                    Visible = SeeTender;
                }
                field("Tender Fee Paid"; "Tender Fee Paid")
                {
                    Editable = false;
                    Visible = SeeTender;
                }
                field("Quoted Amount"; "Quoted Amount")
                {
                }
                field("Category Code"; "Category Code")
                {
                    Editable = false;
                }
                field("Phone No."; "Phone No.")
                {
                    Editable = true;
                }
                field("E-Mail"; "E-Mail")
                {
                    Editable = true;
                }
                field("Attach Procurement Document"; "Attach Procurement Document")
                {
                    Editable = false;
                }
                field("Process No."; "Process No.")
                {
                    Editable = false;
                }
                field("Procurement Document File"; "Procurement Document File")
                {
                    Editable = false;
                }
                field("Attach Expression Of Interest"; "Attach Expression Of Interest")
                {
                    Editable = false;
                    Visible = SeeProposal;
                }
                field("Proceed To Proposal"; "Proceed To Proposal")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Attach Submitted Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;
                Visible = SeeAttachDoc;

                trigger OnAction();
                begin
                    //TESTFIELD("Quoted Amount");
                    ProcurementManagement.AttachSubmittedDocument(Rec, 1);
                end;
            }
            action("View Submitted Document")
            {
                Enabled = SeeProcDocument2;
                Image = Documents;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SeeAttachDoc2;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewAttachmentDocument(Rec, 1);
                end;
            }
            action("Attach EOI")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;
                Visible = SeeProposal;

                trigger OnAction();
                begin
                    ProcurementManagement.AttachSubmittedDocument(Rec, 2);
                end;
            }
            action("View Expression Of Interest")
            {
                Image = Documents;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SeeProposal2;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewAttachmentDocument(Rec, 2);
                end;
            }
            action("Proceed With Proposal")
            {
                Image = ApplyTemplate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeProposal;

                trigger OnAction();
                begin
                    ProcurementManagement.ForwardProcessToNextStage(Rec, 1);
                end;
            }
            action("Close EOI Evaluation")
            {
                Image = DefaultFault;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeProposal;

                trigger OnAction();
                begin
                    ProcurementManagement.ForwardProcessToNextStage(Rec, 2);
                    CurrPage.CLOSE;
                end;
            }
            action("Validate Tender Fee")
            {
                Image = ApplicationWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeTender;

                trigger OnAction();
                begin
                    TESTFIELD("Tender Receipt No.");
                    IF ProcurementRequest.GET("Process No.") THEN BEGIN
                        TenderFeePaid := ProcurementManagement.ValidateTenderReceipt(Rec, "Process No.");
                        IF TenderFeePaid = 0 THEN BEGIN
                            ERROR(NoFeeErr);
                        END ELSE
                            IF TenderFeePaid < ProcurementRequest."Tender Fee" THEN BEGIN
                                ERROR(LessFeeErr, TenderFeePaid, ProcurementRequest."Tender Fee");
                            END ELSE BEGIN
                                "Tender Fee Paid" := TRUE;
                                Select := TRUE;
                                MODIFY(TRUE);
                                MESSAGE(FeePaidMsg);
                            END;
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        ManageVisibility;
    end;

    var
        PrequalifiedSuppliers: Record "Prequalified Suppliers";
        Vendor: Record Vendor;
        ProcurementManagement: Codeunit "Procurement Management";
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        ProcurementRequest: Record "Procurement Request";
        SeeProposal: Boolean;
        seeProposal2: Boolean;
        SeeProcDocument: Boolean;
        seeProcDocument2: Boolean;
        SeeAttachDoc: Boolean;
        TenderFeePaid: Decimal;
        NoFeeErr: Label 'No Amount has been paid for that Receipt No.';
        LessFeeErr: Label 'The Fee Paid of %1 is less than the required amount of %2';
        FeePaidMsg: Label 'Fee Paid Fully. The Supplier can Proceed with the process.';
        SeeTender: Boolean;
        SeeAttachDoc2: Boolean;

    local procedure ManageVisibility();
    begin
        SeeProcDocument := TRUE;
        seeProcDocument2 := TRUE;
        SeeProposal := FALSE;
        seeProposal2 := FALSE;
        SeeAttachDoc2 := TRUE;
        ProcurementSupplierSelection.RESET;
        ProcurementSupplierSelection.COPYFILTERS(Rec);// ERROR(ProcurementSupplierSelection.GETFILTERS+FORMAT(ProcurementSupplierSelection."Process No."));
        IF ProcurementRequest.GET(Rec."Process No.") THEN BEGIN
            IF (ProcurementRequest."Request Email Sent" = TRUE) AND (ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::"Pending Opening")
               THEN
                SeeAttachDoc := TRUE;

            CASE ProcurementRequest."Procurement Option" OF
                ProcurementRequest."Procurement Option"::"Request For Proposal":
                    BEGIN
                        IF ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::"EOI Invitation" THEN BEGIN
                            SeeProcDocument := FALSE;
                            seeProcDocument2 := FALSE;
                            SeeProposal := TRUE;
                            seeProposal2 := TRUE;
                        END;
                        IF ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::"Pending Opening" THEN
                            seeProposal2 := FALSE;
                    END;
                ProcurementRequest."Procurement Option"::"Open Tender":
                    BEGIN
                        SeeTender := TRUE;
                        IF (ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::New) OR (ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::"Pending Opening") THEN BEGIN
                            SeeAttachDoc2 := TRUE;
                            SeeAttachDoc := TRUE;
                        END ELSE BEGIN
                            SeeTender := FALSE;
                        END;
                    END;
                ProcurementRequest."Procurement Option"::"Restricted Tender":
                    BEGIN
                        SeeTender := TRUE;
                        IF (ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::New) OR (ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::"Pending Opening") THEN BEGIN
                            SeeAttachDoc2 := TRUE;
                            SeeAttachDoc := TRUE;
                        END ELSE BEGIN
                            SeeTender := FALSE;
                        END;
                    END;
            END
        END;
    end;
}

