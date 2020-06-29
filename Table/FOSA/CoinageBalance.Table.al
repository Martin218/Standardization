table 50051 "Coinage Balance"
{
    // version TL2.0


    fields
    {
        field(1; "Bank No"; Code[30])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(2; "Code"; Code[30])
        {
            NotBlank = true;
            TableRelation = Denomination;

            trigger OnValidate()
            begin

                //IF Coinage.GET(Coinage.Priority) THEN BEGIN
                //Description:=Coinage.Description;
                //Type:=Coinage.Type;
                //Value:=Coinage.Value;
                //END;
            end;
        }
        field(3; Description; Text[50])
        {
        }
        field(4; Type; Option)
        {
            OptionMembers = Note,Coin;
        }
        field(5; Value; Decimal)
        {
        }
        field(6; Quantity; Integer)
        {

            trigger OnValidate()
            begin
                IF Quantity <> 0 THEN BEGIN
                    "Total Amount" := Value * Quantity;
                END;
            end;
        }
        field(7; "Total Amount"; Decimal)
        {
        }
        field(8; "Received From"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(9; "Request ID"; Code[20])
        {
        }
        field(10; "Entry Type"; Option)
        {
            OptionCaption = 'Positive,Negative';
            OptionMembers = Positive,Negative;
        }
        field(11; "Posting Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Bank No", "Code", "Request ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Coinage: Record "Treasury Transaction";
        TotalDN: Decimal;
        AddVarDN: Decimal;
        Transactions: Record Transaction;
        TransactionDetails: Record "Treasury Coinage";
}

