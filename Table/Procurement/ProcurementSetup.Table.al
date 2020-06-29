table 50403 "Procurement Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[20])
        {
        }
        field(2; "Procurement Manager"; Code[80])
        {
            TableRelation = "User Setup";
        }
        field(3; "Procurement Plan Deadline"; Date)
        {
        }
        field(4; "Procurement Email"; Text[150])
        {
        }
        field(5; "Procurement Plan No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; "CEO's Account"; Code[80])
        {
            TableRelation = "User Setup";
        }
        field(7; "Purchase Requisition No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Store Requisition No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Store Return No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Item Journal Template"; Code[10])
        {
            Caption = 'Item Journal Template';
            TableRelation = "Item Journal Template";
        }
        field(11; "Item Journal Batch"; Code[10])
        {
            Caption = 'Item Journal Batch';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Item Journal Template"));
        }
        field(12; "Direct Procurement No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Low Value No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; "Request For Quotation No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(15; "Request For Proposal No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; "Open Tender No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "Purchase Order No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(18; "Max. Low Value Limit"; Decimal)
        {
        }
        field(19; "Purchase Requisition Source"; Option)
        {
            OptionCaption = 'Open,Procurement Plan';
            OptionMembers = Open,"Procurement Plan";
        }
        field(20; "Max. RFQ Limit"; Decimal)
        {
        }
        field(21; "Minimum Vendor Applicants"; Integer)
        {
        }
        field(22; "Purchase Req. From Plan"; Boolean)
        {
        }
        field(23; "Procurement Documents Path"; Text[250])
        {
        }
        field(24; "RFQ Request Option"; Option)
        {
            OptionCaption = '" ,All Selected,In Batch"';
            OptionMembers = " ","All Selected","In Batch";
        }
        field(25; "RFQ Request Batch"; Integer)
        {
        }
        field(26; "Evaluation Requirement No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(27; "Evaluation Based On"; Option)
        {
            OptionCaption = 'Individual,Group';
            OptionMembers = Individual,Group;
        }
        field(28; "Mandatory Pass Limit(%)"; Decimal)
        {
        }
        field(29; "Technical Pass Limit(%)"; Decimal)
        {
        }
        field(30; "Financial Pass Limit(%)"; Decimal)
        {
        }
        field(31; "Failed Supplier Regret Msg"; BLOB)
        {
            SubType = Memo;
        }
        field(32; "Evaluation Opening Text"; BLOB)
        {
        }
        field(33; "Committee Creator"; Code[80])
        {
            TableRelation = "User Setup";
        }
        field(34; "Evaluation Success Msg"; BLOB)
        {
        }
        field(35; "Overall Pass Limit(%)"; Decimal)
        {
        }
        field(36; "Contract No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(37; "Tender Fee G/L"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(38; "Tender Security Option"; Option)
        {
            OptionMembers = "Fixed Amount","Percentage of Cost";
        }
        field(39; "Fixed Tender Security Amount"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Tender Security Option" = "Tender Security Option"::"Percentage of Cost" THEN
                    ERROR(FixedAmountErr);
            end;
        }
        field(40; "Tender Security Percentage"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Tender Security Option" = "Tender Security Option"::"Fixed Amount" THEN
                    ERROR(PercentageErr);
            end;
        }
        field(41; "Restricted Tender No."; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    var
        FixedAmountErr: Label 'The Tender Option should be Fixed Amount';
        PercentageErr: Label 'The Tender Option should be Percentage of Cost';
}

