table 50420 "Procurement Process Evaluation"
{

    fields
    {
        field(1; "Process No."; Code[20])
        {
        }
        field(3; Type; Option)
        {
            OptionCaptionML = ENU = ' ,G/L Account,Item,Fixed Asset,Charge (Item)',
                              ENG = ' ,G/L Account,Item';
            OptionMembers = " ","G/L Account",Item,"Fixed Asset","Charge (Item)";
        }
        field(4; "No."; Code[10])
        {
            Editable = true;
            TableRelation = IF (Type = CONST(Item)) Item."No."
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No.";
        }
        field(5; Description; Text[100])
        {
        }
        field(6; Quantity; Decimal)
        {
        }
        field(7; "Unit of Measure"; Code[10])
        {
        }
        field(8; "Unit Amount"; Decimal)
        {

            trigger OnValidate();
            begin
                IF Quantity <> 0 THEN
                    Amount := Quantity * "Unit Amount";
            end;
        }
        field(9; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                IF Quantity <> 0 THEN
                    "Unit Amount" := Amount / Quantity;
            end;
        }
        field(100; "Mandatory Score"; Decimal)
        {
        }
        field(101; "Technical Score"; Decimal)
        {
        }
        field(102; "Financial Score"; Decimal)
        {
        }
        field(103; "Supplier Quoted Amount"; Decimal)
        {
        }
        field(104; "Supply Awarded"; Boolean)
        {
        }
        field(105; "Evaluation minutes"; Text[250])
        {
        }
        field(106; "Evaluation Stage"; Option)
        {
            OptionCaption = '" ,Mandatory,Technical,Financial,Awarding"';
            OptionMembers = " ",Mandatory,Technical,Financial,Awarding;
        }
        field(107; "Mandatory Requirements Summary"; Option)
        {
            OptionCaption = '" ,Pass,Fail"';
            OptionMembers = " ",Pass,Fail;
        }
        field(108; "Technical Requirements Summary"; Option)
        {
            OptionCaption = '" ,Pass,Fail"';
            OptionMembers = " ",Pass,Fail;
        }
        field(109; "Financial Requirements Summary"; Option)
        {
            OptionCaption = '" ,Pass,Fail"';
            OptionMembers = " ",Pass,Fail;
        }
        field(110; "Attached Evaluation Minutes"; Boolean)
        {
        }
        field(111; "No. of Committee Members"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Selected Committee Member" where("Process No." = field("Process No.")));

        }
        field(112; "Letter Type"; Option)
        {
            OptionCaption = '" ,Regret,Success"';
            OptionMembers = " ",Regret,Success;
        }
        field(113; "Letter Sent"; Boolean)
        {
        }
        field(114; "Vendor Name"; Text[70])
        {
        }
        field(115; "Quote Generated"; Boolean)
        {
        }
        field(116; "Procurement Option"; Option)
        {
            OptionCaption = ',Direct,Low Value,Open Tender,Restricted Tender,Request For Quotation,Request For Proposal,International Open Tender,National Open Tender';
            OptionMembers = ,Direct,"Low Value","Open Tender","Restricted Tender","Request For Quotation","Request For Proposal","International Open Tender","National Open Tender";
        }
        field(117; "Category Code"; Code[10])
        {
            TableRelation = "Supplier Category";
        }
        field(118; "Category Description"; Text[200])
        {
        }
        field(119; "Evaluation Date"; Date)
        {
        }
        field(120; "Contract Signing Date"; Date)
        {
        }
        field(121; "Award Approval Date"; Date)
        {
        }
        field(122; "Vendor No."; Code[20])
        {
        }
        field(123; Awarded; Boolean)
        {
        }
        field(124; "Evaluation Complete"; Boolean)
        {
        }
        field(125; Email; Text[100])
        {
        }
        field(126; "Total Score"; Decimal)
        {
        }
        field(127; "Overall Requirements Summary"; Option)
        {
            OptionCaption = '" ,Pass,Fail"';
            OptionMembers = " ",Pass,Fail;
        }
        field(128; "Quoted Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Process No.")
        {
        }
    }

    fieldgroups
    {
    }
}

