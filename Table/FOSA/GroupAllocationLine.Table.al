table 52019 "Group Allocation Line"
{
    // version MC2.0

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Transaction No."; Code[20])
        {
        }
        field(3; Description; Text[50])
        {
        }
        field(4; "Transaction Date"; Date)
        {
        }
        field(5; "Transaction Time"; Time)
        {
        }
        field(6; "Sender Name"; Text[50])
        {
        }
        field(7; "Phone No."; Code[20])
        {

            trigger OnValidate()
            begin
                //GetMemberAccounts("Phone No.");
            end;
        }
        field(8; "Group No."; Code[20])
        {
            TableRelation = Member;
        }
        field(9; "Deposited Amount"; Decimal)
        {
        }
        field(10; "Amount to Allocate"; Decimal)
        {
            Editable = false;
        }
        field(11; "Allocated Amount"; Decimal)
        {
            CalcFormula = Sum ("Group Member Allocation"."Allocation Amount" WHERE("Document No." = FIELD("Document No."),
                                                                                   "Transaction No." = FIELD("Transaction No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Remaining Amount"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Transaction No.")
        {
        }
        key(Key2; "Transaction No.")
        {
        }
    }

    fieldgroups
    {
    }

    local procedure GetMemberAccounts(PhoneNo: Code[20])
    var
        Vendor: Record Vendor;
        Member: Record Member;
        GroupMemberAllocation: Record "Group Member Allocation";
        LineNo: Integer;
    begin
        Member.RESET;
        Member.SETRANGE("Phone No.", PhoneNo);
        IF Member.FINDFIRST THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Member No.", Member."No.");
            IF Vendor.FINDSET THEN BEGIN
                REPEAT
                    GroupMemberAllocation.INIT;
                    GroupMemberAllocation."Document No." := "Document No.";
                    GroupMemberAllocation."Transaction No." := "Transaction No.";
                    GroupMemberAllocation."Line No." := GetLastLineNo(GroupMemberAllocation) + 10000;
                    GroupMemberAllocation.VALIDATE("Member No.", Member."No.");
                    GroupMemberAllocation.VALIDATE("Account No.", Vendor."No.");
                    GroupMemberAllocation.INSERT;
                UNTIL Vendor.NEXT = 0;
            END;
        END;
    end;

    local procedure GetAmountDue()
    begin
    end;

    local procedure GetLastLineNo(GroupMemberAllocation: Record "Group Member Allocation"): Integer
    var
        GroupMemberAllocation2: Record "Group Member Allocation";
    begin
        WITH GroupMemberAllocation DO BEGIN
            GroupMemberAllocation2.RESET;
            GroupMemberAllocation2.SETRANGE("Document No.", "Document No.");
            GroupMemberAllocation2.SETRANGE("Transaction No.", "Transaction No.");
            IF GroupMemberAllocation2.FINDLAST THEN
                EXIT(GroupMemberAllocation2."Line No.")
            ELSE
                EXIT(0);
        END;
    end;
}

