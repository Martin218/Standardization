page 50782 "Procurement Contract Card"
{
    // version TL2.0

    DeleteAllowed = false;
    Editable = true;
    PageType = Card;
    SourceTable = "Contract Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Process No."; "Process No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Procurement Plan"; "Procurement Plan")
                {
                    ApplicationArea = All;
                }
                field("Procurement Plan Item No."; "Procurement Plan Item No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Award Date"; "Award Date")
                {
                    ApplicationArea = All;
                }
                field("Attached Contract"; "Attached Contract")
                {
                    ApplicationArea = All;
                }
                field("Contract Path"; "Contract Path")
                {
                    ApplicationArea = All;
                }
            }
            part(page; "Payment Terms List")
            {
                SubPageLink = "Process No." = FIELD("Process No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Attach Contract")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF ProcurementRequest.GET("Process No.") THEN BEGIN
                        ProcurementManagement.AttachSubmittedDocument(ProcurementRequest, 6);
                        IF ProcurementRequest2.GET("Process No.") THEN BEGIN
                            IF ProcurementRequest2."Contract Path" <> '' THEN BEGIN
                                "Attached Contract" := TRUE;
                                "Contract Path" := ProcurementRequest2."Contract Path";
                                MODIFY;
                            END;
                        END;
                    END;
                end;
            }
            action("View Contract Document")
            {
                Image = Documents;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF ProcurementRequest.GET("Process No.") THEN BEGIN
                        ProcurementManagement.ViewAttachmentDocument(ProcurementRequest, 6);
                    END;
                end;
            }
            action("Capture Payment Terms")
            {
            }
        }
        area(navigation)
        {
            action("View Process Request")
            {
                Image = PostedCreditMemo;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    ProcurementManagement.OpenProcurementRequest("Process No.");
                end;
            }
            action("View LPO(s) Generated")
            {
                Image = ViewPostedOrder;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewLPOGenerated(Rec);
                end;
            }
        }
    }

    var
        ProcurementRequest: Record "Procurement Request";
        ProcurementManagement: Codeunit "Procurement Management";
        ProcurementRequest2: Record "Procurement Request";
}

