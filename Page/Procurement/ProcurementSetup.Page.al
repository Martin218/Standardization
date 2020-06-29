page 50703 "Procurement Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Procurement Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Procurement Manager"; "Procurement Manager")
                {
                    ApplicationArea = All;
                }
                field("Procurement Plan Deadline"; "Procurement Plan Deadline")
                {
                    ApplicationArea = All;
                }
                field("Procurement Email"; "Procurement Email")
                {
                    ExtendedDatatype = EMail;
                    ApplicationArea = All;
                }
                field("CEO's Account"; "CEO's Account")
                {
                    ApplicationArea = All;
                }
                field("Purchase Requisition Source"; "Purchase Requisition Source")
                {
                    ApplicationArea = All;
                }
                field("Procurement Documents Path"; "Procurement Documents Path")
                {
                    ApplicationArea = All;
                }
                field("Purchase Req. From Plan"; "Purchase Req. From Plan")
                {
                    ToolTip = 'Should the Purchase Requisition be read from the Procurement Plan?';
                    ApplicationArea = All;
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Procurement Plan No."; "Procurement Plan No.")
                {
                    ApplicationArea = All;
                }
                field("Purchase Requisition No."; "Purchase Requisition No.")
                {
                    ApplicationArea = All;
                }
                field("Store Requisition No."; "Store Requisition No.")
                {
                    ApplicationArea = All;
                }
                field("Store Return No."; "Store Return No.")
                {
                    ApplicationArea = All;
                }
                field("Direct Procurement No."; "Direct Procurement No.")
                {
                    ApplicationArea = All;
                }
                field("Low Value No."; "Low Value No.")
                {
                    ApplicationArea = All;
                }
                field("Request For Quotation No."; "Request For Quotation No.")
                {
                    ApplicationArea = All;
                }
                field("Request For Proposal No."; "Request For Proposal No.")
                {
                    ApplicationArea = All;
                }
                field("Open Tender No."; "Open Tender No.")
                {
                    ApplicationArea = All;
                }
                field("Restricted Tender No."; "Restricted Tender No.")
                {
                    ApplicationArea = All;
                }
                field("Purchase Order No."; "Purchase Order No.")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Requirement No."; "Evaluation Requirement No.")
                {
                    ApplicationArea = All;
                }
                field("Contract No."; "Contract No.")
                {
                    ApplicationArea = All;
                }
            }
            group("Posting Setup")
            {
                Caption = 'Posting Setup';
                field("Item Journal Template"; "Item Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Item Journal Batch"; "Item Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Tender Fee G/L"; "Tender Fee G/L")
                {
                    ApplicationArea = All;
                }
            }
            group("Procurement Methods Setup")
            {
                Caption = 'Procurement Methods Setup';
                field("Max. RFQ Limit"; "Max. RFQ Limit")
                {
                    ApplicationArea = All;
                }
                field("Max. Low Value Limit"; "Max. Low Value Limit")
                {
                    ApplicationArea = All;
                }
                field("Tender Security Option"; "Tender Security Option")
                {
                    ApplicationArea = All;
                }
                field("Fixed Tender Security Amount"; "Fixed Tender Security Amount")
                {
                    ApplicationArea = All;
                }
                field("Tender Security Percentage"; "Tender Security Percentage")
                {
                    ApplicationArea = All;
                }
                field("RFQ Request Option"; "RFQ Request Option")
                {
                    ApplicationArea = All;

                }
            }
            group("Evaluation Process")
            {
                field("Evaluation Based On"; "Evaluation Based On")
                {
                    ApplicationArea = All;
                }
                field("Mandatory Pass Limit(%)"; "Mandatory Pass Limit(%)")
                {
                    ApplicationArea = All;
                }
                field("Technical Pass Limit(%)"; "Technical Pass Limit(%)")
                {
                    ApplicationArea = All;
                }
                field("Financial Pass Limit(%)"; "Financial Pass Limit(%)")
                {
                    ApplicationArea = All;
                }
                field("Overall Pass Limit(%)"; "Overall Pass Limit(%)")
                {
                    ApplicationArea = All;

                }
                field(FailedSupplierTxt; FailedSupplierTxt)
                {
                    Caption = 'Failed Supplier Regret Message';
                    MultiLine = true;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        "Failed Supplier Regret Msg".CREATEOUTSTREAM(FailedSupplierOutstr);
                        FailedSupplierOutstr.WRITE(FailedSupplierTxt);
                    end;
                }
                field(EvaluationSuccessTxt; EvaluationSuccessTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Evaluation Success Message';
                    MultiLine = true;

                    trigger OnValidate();
                    begin
                        "Evaluation Success Msg".CREATEOUTSTREAM(EvaluationSuccessOutstr);
                        EvaluationSuccessOutstr.WRITE(EvaluationSuccessTxt);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        ManageVisibility
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        ManageVisibility
    end;

    trigger OnOpenPage();
    begin
        ManageVisibility;
    end;

    var
        FailedSupplierTxt: Text;
        FailedSupplierOutstr: OutStream;
        FailedSupplierInstr: InStream;
        EvaluationSuccessTxt: Text;
        EvaluationSuccessOutstr: OutStream;
        EvaluationSuccessInstr: InStream;

    local procedure ManageVisibility();
    begin
        CALCFIELDS("Failed Supplier Regret Msg");
        "Failed Supplier Regret Msg".CREATEINSTREAM(FailedSupplierInstr);
        FailedSupplierInstr.READ(FailedSupplierTxt);

        CALCFIELDS("Evaluation Success Msg");
        "Evaluation Success Msg".CREATEINSTREAM(EvaluationSuccessInstr);
        EvaluationSuccessInstr.READ(EvaluationSuccessTxt);
    end;
}

