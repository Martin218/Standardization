table 50046 "Supervisor Approval Amount"
{
    // version TL2.0


    fields
    {
        field(1; SupervisorID; Code[50])
        {
            NotBlank = true;
            TableRelation = "User Setup";
        }
        field(2; "Maximum Approval Amount"; Decimal)
        {
        }
        field(3; "Transaction Type"; Option)
        {
            OptionMembers = "Cash Deposits","Cheque Deposits",Withdrawals;
        }
        field(4; "Approval Level"; Integer)
        {
        }
        field(5; Branch; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                Ok := DimensionValue.GET('Branch', Branch);
                "Branch Name" := DimensionValue.Name;
            end;
        }
        field(6; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Global Administrator"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; SupervisorID, "Transaction Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Approval Level" = 0 THEN
            "Approval Level" := 1;
    end;

    var
        Ok: Boolean;
        DimensionValue: Record "Dimension Value";
}

