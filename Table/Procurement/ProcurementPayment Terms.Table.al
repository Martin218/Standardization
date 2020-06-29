table 50424 "Procurement Payment Terms"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Description; Text[250])
        {
        }
        field(3; "Payment Type"; Option)
        {
            OptionCaption = 'One Off,Recurring';
            OptionMembers = "One Off",Recurring;
        }
        field(4; "Process No."; Code[10])
        {
        }
        field(5; "Payment Option"; Option)
        {
            OptionCaption = 'Fixed Amount,Percentage Of Cost';
            OptionMembers = "Fixed Amount","Percentage Of Cost";

            trigger OnValidate();
            begin
                IF "Payment Option" = "Payment Option"::"Fixed Amount" THEN BEGIN
                    "Percentage Amount" := 0;
                    "Percentage On Cost" := 0;
                END ELSE BEGIN
                    "Fixed Amount" := 0;
                END;
            end;
        }
        field(6; "Fixed Amount"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Payment Option" = "Payment Option"::"Percentage Of Cost" THEN
                    ERROR(PaymentOptErr1);
            end;
        }
        field(7; "Percentage On Cost"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Payment Option" = "Payment Option"::"Fixed Amount" THEN
                    ERROR(PaymentOptErr2);
                IF "Percentage On Cost" > 100 THEN
                    ERROR(GreaterThanErr)
                ELSE
                    IF "Percentage On Cost" < 0 THEN
                        ERROR(LessThanErr);

                ContractHeader.RESET;
                ContractHeader.SETRANGE("Process No.", "Process No.");
                IF ContractHeader.FINDFIRST THEN BEGIN
                    "Percentage Amount" := ("Percentage On Cost" / 100) * ContractHeader.Amount;
                END;
            end;
        }
        field(8; "LPO Generated"; Boolean)
        {
        }
        field(9; "LPO No."; Code[20])
        {
        }
        field(10; "Percentage Amount"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Process No.", "Entry No.")
        {
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
    }

    var
        PaymentOptErr1: Label 'Payment Option should be Fixed Amount';
        PaymentOptErr2: Label 'Payment Option should be Percentage On Cost';
        ContractHeader: Record "Contract Header";
        GreaterThanErr: Label 'Percentage should not exceed 100';
        LessThanErr: Label 'Percentage should not be less than 0';
}

