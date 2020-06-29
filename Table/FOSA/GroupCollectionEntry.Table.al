table 52016 "Group Collection Entry"
{
    // version MC2.0

    DrillDownPageID = "Group Collection Entries";

    fields
    {
        field(1; "Transaction No.";
        Code[20])
        {
            Editable = false;
        }
        field(2; "Transaction Date"; Date)
        {
            Editable = false;
        }
        field(3; "Transaction Time"; Time)
        {
            Editable = false;
        }
        field(4; "External Document No."; Code[20])
        {
            Editable = false;
        }
        field(5; Description; Text[50])
        {
            Editable = false;
        }
        field(6; "Sender Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Phone No."; Code[20])
        {
            Editable = false;
        }
        field(8; "Group No."; Code[20])
        {
            Editable = false;
            TableRelation = "Member";

            trigger OnValidate()
            begin
                IF Member.GET("Group No.") THEN BEGIN
                    "Group No." := Member."No.";
                    "Loan Officer ID" := Member."Loan Officer ID";
                END;
            end;
        }
        field(9; "Deposited Amount"; Decimal)
        {
            Editable = false;
        }
        field(10; "Loan Officer ID"; Code[20])
        {
            Editable = false;
            TableRelation = "Loan Officer Setup";
        }
        field(11; "Allocated Amount"; Decimal)
        {
            CalcFormula = Sum ("Group Member Allocation"."Allocation Amount" WHERE("Transaction No." = FIELD("Transaction No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Remaining Amount"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CALCFIELDS("Allocated Amount");
                "Remaining Amount" -= "Allocated Amount";
            end;
        }
        field(14; "Posted Destination"; Option)
        {
            Editable = false;
            OptionCaption = ' ,To Group Account,To Member Account';
            OptionMembers = " ","To Group Account","To Member Account";
        }
        field(15; "Group Name"; Text[50])
        {
            Editable = false;
        }
        field(16; "Posting Status"; Option)
        {
            OptionCaption = 'Success,Fail';
            OptionMembers = Success,Fail;
        }
        field(17; "Posting Message"; Text[100])
        {
            Editable = false;
        }
        field(18; "Group Paybill Code"; Code[20])
        {

            trigger OnValidate()
            begin
                Member.RESET;
                Member.SETRANGE("Group Paybill Code", Rec."Group Paybill Code");
                IF Member.FINDFIRST THEN BEGIN
                    "Group No." := Member."No.";
                    "Loan Officer ID" := Member."Loan Officer ID";
                END ELSE BEGIN
                    "Group No." := 'NA';
                    "Loan Officer ID" := 'NA'
                END;
            end;
        }
        field(19; "Source Code"; Code[20])
        {
            Editable = false;
        }
        field(20; "Debit Account Code"; Code[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Transaction No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;
        Member2: Record Member;
}

