table 50027 "Treasury Request"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[30])
        {
            Editable = false;

        }
        field(2; "Request Date"; Date)
        {
        }
        field(3; "Request By"; Text[30])
        {
        }
        field(4; "Requested Amount"; Decimal)
        {
        }
        field(5; Serviced; Option)
        {
            OptionMembers = No,Yes;
        }
        field(6; "Date Serviced"; Date)
        {
        }
        field(7; "Time Serviced"; Time)
        {
        }
        field(8; "Serviced By"; Text[30])
        {
        }
        field(9; Comments; Text[250])
        {
        }
        field(10; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(11; Requested; Boolean)
        {
        }
        field(12; "Issue No"; Text[30])
        {
        }
        field(13; "Amount Issued"; Decimal)
        {
        }
        field(14; "Float Difference"; Decimal)
        {
        }
        field(15; "Teller Till"; Code[10])
        {
        }
        field(16; Posted; Boolean)
        {
        }
        field(17; Cancelled; Boolean)
        {
        }
        field(18; "Teller Balance"; Decimal)
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
        fieldgroup(DropDown; "No.", "Request By", "Requested Amount")
        {
        }
    }

    trigger OnDelete()
    begin

        IF Serviced = Serviced::Yes THEN
            ERROR('The request has already been serviced and therefore cannot be deleted.');
    end;

    trigger OnInsert()
    begin

        CBSSetup.GET;
        "No." := NoSeriesMgt.GetNextNo(CBSSetup."Treasury Request Nos.", TODAY, TRUE);

        "Request Date" := TODAY;
        "Request By" := USERID;
        TellerSetup.GET(USERID);
        "Teller Till" := TellerSetup."Till No";

        //add teller bal

        Banks.GET("Teller Till");
        Banks.CALCFIELDS("Balance (LCY)");
        "Teller Balance" := Banks."Balance (LCY)";

        TreasuryCoinage.RESET;
        TreasuryCoinage.SETRANGE(TreasuryCoinage."No.", "No.");
        IF TreasuryCoinage.FIND('-') THEN
            EXIT;

        Denomination.RESET;
        TreasuryCoinage.RESET;
        Denomination.INIT;
        IF Denomination.FIND('-') THEN BEGIN
            //MESSAGE(';');
            REPEAT
                // TreasuryCoinage.INIT;
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
    end;

    trigger OnModify()
    begin

        IF Serviced = Serviced::Yes THEN
            ERROR('The request has already been serviced and therefore cannot be modified.');
    end;

    trigger OnRename()
    begin

        IF Serviced = Serviced::Yes THEN
            ERROR('The request has already been serviced and therefore cannot be modified.');
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Banks: Record "Bank Account";
        CBSSetup: Record "CBS Setup";
        TellerSetup: Record "Teller Setup";
        TreasuryCoinage: Record "Treasury Coinage";
        Denomination: Record Denomination;
}

