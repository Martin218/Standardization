table 52017 "Group Member Allocation"
{
    // version MC2.0

    DrillDownPageID = "Group Member Allocation";
    LookupPageID = "Group Member Allocation";

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Transaction No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(4; "Member No."; Code[20])
        {

            trigger OnLookup()
            begin
                IF GroupAllocationHeader.GET("Document No.") THEN BEGIN
                    IF Member.GET(GroupAllocationHeader."Group No.") THEN;
                    Member2.RESET;
                    Member2.SETRANGE("Group Link No.", Member."No.");
                    // Member2.SETRANGE(Category, Member2.Category::Client);
                    Member2.SETRANGE(Status, Member2.Status::Active);
                    //Member2.SETRANGE("Exit Status", Member2."Exit Status"::" ");
                    IF PAGE.RUNMODAL(0, Member2) = ACTION::LookupOK THEN BEGIN
                        "Member No." := Member2."No.";
                        "Member Name" := Member2."Full Name";
                    END;
                END;
            end;
        }
        field(5; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Amount Due"; Decimal)
        {
            Editable = false;
        }
        field(7; "Account No."; Code[20])
        {
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF GroupAllocationHeader.GET("Document No.") THEN;
                IF Vendor.GET("Account No.") THEN BEGIN
                    "Account Name" := Vendor.Name;
                    IF Vendor."Account Type" = 'LOAN' THEN BEGIN
                        /*  "Amount Due" := MicroCreditManagement.GetExpectedRepaymentAmount("Account No.", GroupAllocationHeader."Current Meeting Date", 'I') +
                                       MicroCreditManagement.GetExpectedRepaymentAmount("Account No.", GroupAllocationHeader."Current Meeting Date", 'P');

                         ArrearsAmount[1] := MicroCreditManagement.CalculateLoanArrears("Account No.", GroupAllocationHeader."Current Meeting Date", 'P');
                         ArrearsAmount[2] := MicroCreditManagement.CalculateLoanArrears("Account No.", GroupAllocationHeader."Current Meeting Date", 'I'); */

                        IF ArrearsAmount[1] > 0 THEN
                            ArrearsAmount[3] := ArrearsAmount[1]
                        ELSE
                            ArrearsAmount[4] := ABS(ArrearsAmount[1]);

                        IF ArrearsAmount[2] > 0 THEN
                            ArrearsAmount[5] := ArrearsAmount[2]
                        ELSE
                            ArrearsAmount[6] := ABS(ArrearsAmount[2]);

                        "Amount in Arrears" := ArrearsAmount[3] + ArrearsAmount[5];
                        "Overpayment Amount" := ArrearsAmount[4] + ArrearsAmount[6];
                    END ELSE BEGIN
                        IF AccountType.GET(Vendor."Account Type") THEN BEGIN
                            IF AccountType.Type = AccountType.Type::Savings THEN BEGIN
                                IF Member.GET(GroupAllocationHeader."Group No.") THEN
                                    "Amount Due" := Member."Min. Contribution per Meeting";
                            END;
                        END;
                    END;
                END;
            end;
        }
        field(8; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(9; "Allocation Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Account No.");
                GroupAllocationLine.RESET;
                GroupAllocationLine.LOCKTABLE;
                IF GroupAllocationLine.GET("Document No.", "Transaction No.") THEN BEGIN
                    GroupAllocationLine.CALCFIELDS("Allocated Amount");
                    NetAllocatedAmount[1] := (Rec."Allocation Amount" - xRec."Allocation Amount");
                    NetAllocatedAmount[2] := GroupAllocationLine."Allocated Amount" + NetAllocatedAmount[1];
                    IF NetAllocatedAmount[2] > GroupAllocationLine."Amount to Allocate" THEN
                        ERROR(Error000, NetAllocatedAmount[2], GroupAllocationLine."Amount to Allocate");
                END;
            end;
        }
        field(10; "Amount in Arrears"; Decimal)
        {
            Editable = false;
        }
        field(11; "Overpayment Amount"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Transaction No.", "Line No.")
        {
        }
        key(Key2; "Document No.", "Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        OnDeleteAllocationLine;
    end;

    trigger OnInsert()
    begin
        "Line No." := GetLastAllocationLine + 10000;
        UpdateRemainingAmount;
    end;

    trigger OnModify()
    begin
        UpdateRemainingAmount;
    end;

    var
        Member: Record Member;
        Member2: Record Member;
        Vendor: Record Vendor;
        GroupAllocationLine: Record "Group Allocation Line";
        Error000: Label 'Amount Allocated (%1) exceeds the Amount to Allocate (%2)';
        NetAllocatedAmount: array[2] of Decimal;
        GroupCollectionEntry: Record "Group Collection Entry";
        // MicroCreditManagement: Codeunit "55001";
        GroupAllocationHeader: Record "Group Allocation Header";
        AccountType: Record "Account Type";
        ArrearsAmount: array[10] of Decimal;

    local procedure GetLastAllocationLine(): Integer
    var
        GroupMemberAllocation: Record "Group Member Allocation";
    begin
        GroupMemberAllocation.RESET;
        GroupMemberAllocation.SETRANGE("Document No.", Rec."Document No.");
        GroupMemberAllocation.SETRANGE("Transaction No.", Rec."Transaction No.");
        IF GroupMemberAllocation.FINDLAST THEN
            EXIT(GroupMemberAllocation."Line No.")
        ELSE
            EXIT(0);
    end;

    local procedure OnDeleteAllocationLine()
    begin
        IF GroupAllocationLine.GET("Document No.", "Transaction No.") THEN BEGIN
            GroupAllocationLine."Remaining Amount" += "Allocation Amount";
            GroupAllocationLine.MODIFY;
        END;
    end;

    procedure UpdateRemainingAmount(): Decimal
    begin
        IF GroupAllocationLine.GET("Document No.", "Transaction No.") THEN BEGIN
            GroupAllocationLine."Remaining Amount" -= "Allocation Amount";
            GroupAllocationLine.MODIFY;
        END;
        IF GroupCollectionEntry.GET("Transaction No.") THEN BEGIN
            GroupCollectionEntry."Remaining Amount" -= "Allocation Amount";
            GroupCollectionEntry.MODIFY;
        END;
    end;
}

