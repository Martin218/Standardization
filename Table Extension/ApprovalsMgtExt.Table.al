tableextension 50434 ApprovalMgtExt extends "Approval Entry"
{
    Caption = 'ApprovalMgtExt';
    //DataClassification = ToBeClassified;    
    fields
    {
        field(50000; "Document Type Ext"; Option)
        {
            OptionMembers = "Procurement Plan",GLBudget,"Purchase Requisition","Store Requisition","Store Return",RFQ;
            OptionCaption = '"Procurement Plan",GLBudget,"Purchase Requisition","Store Requisition","Store Return",RFQ';
        }
    }
    keys
    {
    }

}
