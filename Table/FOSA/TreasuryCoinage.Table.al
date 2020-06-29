table 50048 "Treasury Coinage"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[30])
        {
            TableRelation = Transaction."No.";
        }
        field(2; "Code"; Code[30])
        {
            NotBlank = true;
            TableRelation = Denomination;

            trigger OnValidate()
            begin
                IF Coinage.GET(Code) THEN BEGIN
                    Description := Coinage.Description;
                    Type := Coinage.Type;
                    Value := Coinage.Value;
                    Priority := Coinage.Priority;
                END;
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
                TotalDN := 0;
                AddVarDN := 0;
                MODIFY;

                TransactionDetails.RESET;
                TransactionDetails.SETRANGE("No.", "No.");
                IF TransactionDetails.FIND('-') THEN BEGIN
                    REPEAT
                        AddVarDN := 0;
                        AddVarDN := TransactionDetails.Value * TransactionDetails.Quantity;
                        TotalDN := TotalDN + AddVarDN;
                    UNTIL TransactionDetails.NEXT = 0;
                END;

                TransactionDetails.RESET;
                TransactionDetails.SETRANGE("No.", "Request No");
                IF TransactionDetails.FIND('-') THEN BEGIN
                    REPEAT
                        AddVarDN := 0;
                        AddVarDN := TransactionDetails.Value * TransactionDetails.Quantity;
                        TotalDN := TotalDN + AddVarDN;
                    UNTIL TransactionDetails.NEXT = 0;
                END;

                //IF Quantity<>0 THEN
                "Total Amount" := Quantity * Value;

                TreasuryTransaction.RESET;
                IF TreasuryTransaction.GET("No.") THEN BEGIN
                    ;
                    TreasuryTransaction."Coinage Amount" := TotalDN;
                    TreasuryTransaction.MODIFY;
                    "Treasury Account" := TreasuryTransaction."Treasury Account";
                END;

                Transactions.RESET;
                Transactions.SETRANGE("No.", "No.");
                IF Transactions.FINDFIRST THEN BEGIN
                    Transactions.CALCFIELDS("Coinage Amount");
                END;
            end;
        }
        field(7; "Total Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TotalDN := 0;
                AddVarDN := 0;

                MODIFY;

                TransactionDetails.RESET;
                TransactionDetails.SETRANGE("No.", "No.");
                IF TransactionDetails.FINDSET THEN BEGIN
                    REPEAT
                        AddVarDN := 0;
                        AddVarDN := TransactionDetails.Value * TransactionDetails.Quantity;
                        TotalDN := TotalDN + AddVarDN;
                    UNTIL TransactionDetails.NEXT = 0;
                END;

                Quantity := "Total Amount" / Value;

                IF Quantity <> 0 THEN
                    "Total Amount" := Quantity * Value;
                IF Quantity = 0 THEN
                    VALIDATE(Quantity, ("Total Amount" / Value));

                MODIFY;

                TreasuryTransaction.RESET;
                IF TreasuryTransaction.GET("No.") THEN BEGIN
                    ;
                    TreasuryTransaction."Coinage Amount" := TotalDN;
                    TreasuryTransaction.MODIFY;
                    "Treasury Account" := TreasuryTransaction."Treasury Account";
                END;

                //===========Update totals on the Receipt Card
                totalcoinage := 0;
                thisrec.RESET;
                thisrec.SETFILTER("No.", "No.");
                IF thisrec.FINDSET THEN
                    REPEAT
                        totalcoinage += thisrec."Total Amount";
                    UNTIL thisrec.NEXT = 0;

                ReceiptTran.RESET;
                ReceiptTran.SETFILTER("No.", "No.");
                IF ReceiptTran.FINDSET THEN BEGIN
                    ReceiptTran."Coinage Amount" := 0;
                    ReceiptTran."Coinage Amount" := totalcoinage;
                    ReceiptTran.MODIFY;
                END;
                //============================================
            end;
        }
        field(8; Priority; Integer)
        {
        }
        field(9; "Request No"; Code[50])
        {
        }
        field(10; "Treasury Account"; Code[100])
        {
        }
        field(50000; "Posting Date"; Date)
        {
            CalcFormula = Lookup ("Bank Account Ledger Entry"."Posting Date" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Priority, "No.", Value)
        {
            SumIndexFields = "Total Amount";
        }
        key(Key2; Value)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Coinage: Record "Treasury Coinage";
        TotalDN: Decimal;
        AddVarDN: Decimal;
        TreasuryTransaction: Record "Treasury Transaction";
        TransactionDetails: Record "Treasury Coinage";
        TotalAMT: Decimal;
        Amount: Decimal;
        ReceiptTran: Record "Treasury Transaction";
        thisrec: Record "Treasury Coinage";
        totalcoinage: Decimal;
        Transactions: Record Transaction;
}

