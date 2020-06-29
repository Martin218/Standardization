table 50047 "Treasury Transaction"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[30])
        {
        }
        field(2; "Transaction Date"; Date)
        {
        }
        field(3; "Transaction Type"; Option)
        {
            OptionCaption = 'Issue To Teller,Return To Treasury,Receive From Bank,Return To Bank,Intertreasury transfers,Cheque Receipts,Request From Treasury,Close Till';
            OptionMembers = "Issue To Teller","Return To Treasury","Receive From Bank","Return To Bank","Intertreasury transfers","Cheque Receipts","Request From Treasury","Close Till";

            trigger OnValidate()
            begin
                Description := FORMAT("Transaction Type");
            end;
        }
        field(4; "Treasury Account"; Code[30])
        {
            TableRelation = "Bank Account" WHERE("Account Type" = FILTER('Treasury Account'));

            trigger OnValidate()
            begin
                Bank.GET("Treasury Account");
                Bank.CALCFIELDS("Balance (LCY)");
                "Branch Code" := Bank."Global Dimension 1 Code";
                "Treasury Balance" := Bank."Balance (LCY)"
            end;
        }
        field(5; "Teller Account"; Code[30])
        {
            TableRelation = "Bank Account" WHERE("Account Type" = FILTER('Till Account'));

            trigger OnValidate()
            begin
                IF Bank.GET("Teller Account") THEN BEGIN
                    Bank.CALCFIELDS("Balance (LCY)");
                    "Till Balance" := Bank."Balance (LCY)";
                    "Branch Code" := Bank."Global Dimension 1 Code";
                END;
                TellerSetup.RESET;
                TellerSetup.SETRANGE("Till No", "Teller Account");
                IF TellerSetup.FINDSET THEN BEGIN
                    "Till Owner" := TellerSetup."Teller ID";
                    "Treasury Account" := TellerSetup."Treasury Account";
                    VALIDATE("Treasury Account");
                END;
            end;
        }
        field(6; Description; Text[100])
        {
        }
        field(7; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                IF Amount < 0 THEN
                    ERROR(Error001);

                IF "Transaction Type" = "Transaction Type"::"Request From Treasury" THEN BEGIN
                    TellerGeneralSetup.GET;
                    IF Amount + "Till Balance" > TellerGeneralSetup."Teller Maximum Withholding" THEN BEGIN
                        ERROR(Error000, TellerGeneralSetup."Teller Maximum Withholding");
                    END;
                END;
            end;
        }
        field(8; Posted; Boolean)
        {
        }
        field(9; "Date Posted"; Date)
        {
        }
        field(10; "Time Posted"; Time)
        {
        }
        field(11; "Posted By"; Text[30])
        {
        }
        field(12; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(13; "Transaction Time"; Time)
        {
        }
        field(14; "Coinage Amount"; Decimal)
        {
        }
        field(15; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(16; Issued; Option)
        {
            OptionMembers = No,Yes,"N/A";
        }
        field(17; "Date Issued"; Date)
        {
        }
        field(18; "Time Issued"; Time)
        {
        }
        field(19; "Issue Received"; Option)
        {
            OptionMembers = No,Yes,"N/A";
        }
        field(20; "Date Issue Received"; Date)
        {
        }
        field(21; "Time Issue Received"; Time)
        {
        }
        field(22; "Issued By"; Text[30])
        {
        }
        field(23; "Received By"; Text[30])
        {
        }
        field(24; "Return Received"; Option)
        {
            OptionMembers = No,Yes,"N/A";
        }
        field(25; "Date Return Received"; Date)
        {
        }
        field(26; "Time Return Received"; Time)
        {
        }
        field(27; "Returned By"; Text[30])
        {
        }
        field(28; "Return Received By"; Text[30])
        {
        }
        field(29; Returned; Option)
        {
            OptionMembers = No,Yes,"N/A";
        }
        field(30; "Date Returned"; Date)
        {
        }
        field(31; "Time Returned"; Time)
        {
        }
        field(32; "Request No"; Code[30])
        {
        }
        field(33; "Bank No"; Code[30])
        {
            TableRelation = "Bank Account"."No." WHERE("Account Type" = FILTER('Bank Account'));
        }
        field(34; "Denomination Total"; Decimal)
        {
            CalcFormula = Sum ("Treasury Coinage"."Total Amount" WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(35; "External Document No."; Code[30])
        {
        }
        field(36; "Treasury Account From"; Code[30])
        {
            TableRelation = "Bank Account" WHERE("Account Type" = FILTER('Treasury Account'));
        }
        field(37; "G/L Account"; Code[50])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                GLAccount.GET("G/L Account");
                "Account Name" := GLAccount.Name;
            end;
        }
        field(38; "Account Name"; Text[100])
        {
        }
        field(39; "Cheque Drawer"; Text[50])
        {
        }
        field(40; "Date of Cheque"; Date)
        {
        }
        field(41; "Drawer Bank"; Text[50])
        {
        }
        field(42; "Drawer Branch"; Text[50])
        {
        }
        field(43; "Cheque No"; Code[50])
        {
        }
        field(44; "Branch Code"; Code[20])
        {
            Editable = false;
        }
        field(45; "Till Owner"; Code[50])
        {
        }
        field(46; "Till Balance"; Decimal)
        {
        }
        field(47; "Treasury Balance"; Decimal)
        {
        }
        field(48; "Request Sent"; Boolean)
        {
        }
        field(49; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(50; "Cheque Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if CBSSetup.Get() then begin
            //      message('%1', CBSSetup."Treasury Request Nos.");
            "No." := NoSeriesMgt.GetNextNo(CBSSetup."Treasury Request Nos.", 0D, TRUE);
        end;
        "Transaction Date" := TODAY;
        "Transaction Time" := TIME;

        TreasuryCoinage.RESET;
        TreasuryCoinage.SETRANGE("No.", "No.");
        IF TreasuryCoinage.FIND('-') THEN
            EXIT;

        Denomination.RESET;
        IF Denomination.FindSet() THEN BEGIN
            REPEAT
                TreasuryCoinage.INIT;
                TreasuryCoinage."No." := "No.";
                TreasuryCoinage.Code := Denomination.Code;
                TreasuryCoinage.Description := Denomination.Description;
                TreasuryCoinage.Type := Denomination.Type;
                TreasuryCoinage.Value := Denomination.Value;
                TreasuryCoinage.Quantity := 0;
                TreasuryCoinage.Priority := Denomination.Priority;
                TreasuryCoinage.INSERT;
            UNTIL Denomination.NEXT = 0;
        END;

        IF TellerSetup.GET(USERID) THEN BEGIN
            "Teller Account" := TellerSetup."Till No";
        END;
        VALIDATE("Teller Account");
        VALIDATE("Transaction Type");
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Bank: Record "Bank Account";
        GLAccount: Record "G/L Account";
        UserSetup: Record "User Setup";
        TellerGeneralSetup: Record "Teller General Setup";
        CBSSetup: Record "CBS Setup";
        TellerSetup: Record "Teller Setup";
        TreasuryCoinage: Record "Treasury Coinage";
        Denomination: Record Denomination;
        Error000: Label 'You cannot exceed your maximum withholding amount of %1 ';
        Error001: Label 'You cannot request for a negative figure!';
}

