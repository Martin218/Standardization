table 50402 "Procurement Plan Line"
{
    // version TL2.0

    //DrillDownPageID = 50705;
    //LookupPageID = 50705;

    fields
    {
        field(1; "Plan No"; Code[20])
        {

            trigger OnValidate();
            begin
                IF ProcurementPlanHeader.GET("Plan No") THEN BEGIN
                    "Current Budget" := ProcurementPlanHeader."Current Budget";
                    "Global Dimension 1 Code" := ProcurementPlanHeader."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := ProcurementPlanHeader."Global Dimension 2 Code";
                END;
            end;
        }
        field(2; "Plan Year"; Text[30])
        {
        }
        field(3; "Procurement Type"; Text[50])
        {
            TableRelation = "Procurement Type";
        }
        field(4; Type; Option)
        {
            OptionCaption = '" ,G/L Account,Item,Fixed Asset,Charge (Item)"';
            OptionMembers = " ","G/L Account",Item,"Fixed Asset","Charge (Item)";
        }
        field(5; "No."; Code[30])
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"."No." WHERE("Income/Balance" = CONST("Income Statement"))
            ELSE
            IF (Type = CONST(Item)) Item."No."
            ELSE
            IF (Type = CONST("Charge (Item)")) Item."No."
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No.";

            trigger OnValidate();
            begin
                ValidateType(Type);
            end;
        }
        field(6; Description; Text[100])
        {
        }
        field(7; Quantity; Decimal)
        {

            trigger OnValidate();
            begin
                ValidateEstimatedCost;
            end;
        }
        field(8; "Unit On Measure"; Code[30])
        {
            TableRelation = "Unit of Measure";
        }
        field(9; "Unit Price"; Decimal)
        {

            trigger OnValidate();
            begin
                ValidateEstimatedCost;
            end;
        }
        field(10; "Estimated Cost"; Decimal)
        {
        }
        field(11; "G/L Name"; Text[50])
        {
        }
        field(12; "Budget Amount"; Decimal)
        {
        }
        field(13; "Current Budget"; Code[25])
        {
        }
        field(14; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(15; "Source Of Funds"; Integer)
        {
            TableRelation = "G/L Budget Entry" WHERE("Budget Name" = FIELD("Current Budget"),
                                                      "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                      "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code"));

            trigger OnValidate();
            begin
                ValidateBudgetAmount;
            end;
        }
        field(16; "Committed Amount"; Decimal)
        {
        }
        field(17; "Global Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = FILTER(Standard));
        }
        field(18; "Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = FILTER(Standard));
        }
        field(19; "G/L Account"; Code[20])
        {
        }
        field(20; "Remaining Amount"; Decimal)
        {
        }
        field(21; "Expected Completion Date"; Date)
        {

            trigger OnValidate();
            begin
                IF "Expected Completion Date" < TODAY THEN
                    ERROR(CompletionDateErr);
            end;
        }
        field(22; "1st Quarter"; Decimal)
        {

            trigger OnValidate();
            begin
                ValidateQuarterlyAmount();
            end;
        }
        field(23; "2nd Quarter"; Decimal)
        {

            trigger OnValidate();
            begin
                ValidateQuarterlyAmount();
            end;
        }
        field(24; "3rd Quarter"; Decimal)
        {

            trigger OnValidate();
            begin
                ValidateQuarterlyAmount();
            end;
        }
        field(25; "4th Quarter"; Decimal)
        {

            trigger OnValidate();
            begin
                ValidateQuarterlyAmount();
            end;
        }
        field(26; "Procurement Method"; Code[30])
        {
            TableRelation = "Procurement Method";
        }
        field(27; "Procurement Sub Type"; Text[150])
        {
            TableRelation = "Procurement Sub Types"."Sub Type" WHERE(Type = FIELD("Procurement Type"));
        }
        field(28; "Document Opening Date"; Date)
        {
        }
        field(29; "Proposal Evaluation Date"; Date)
        {
        }
        field(30; "Award Approval Date"; Date)
        {
        }
        field(31; "Notification Of Award Date"; Date)
        {
        }
        field(32; "Contract Signing Date"; Date)
        {
        }
        field(33; "Negotiation Date"; Date)
        {
        }
        field(34; "Contract Completion Date"; Date)
        {
        }
        field(35; "Advertisement Date"; Date)
        {

            trigger OnValidate();
            begin
                //ProcurementManagement.ValidateProcurementDates(Rec);
                ValidateProcurementDates("Advertisement Date");
            end;
        }
        field(36; "Time Process"; Option)
        {
            OptionCaption = 'Planned Dates,Actual Dates';
            OptionMembers = "Planned Dates","Actual Dates";
        }
        field(37; "Forwarded To CEO"; Boolean)
        {
        }
        field(38; Select; Boolean)
        {
        }
        field(39; Approved; Boolean)
        {
        }
        field(40; Submitted; Boolean)
        {
        }
        field(41; "Distribution Type"; Option)
        {
            OptionMembers = Amount,Quantity;
        }
    }

    keys
    {
        key(Key1; "Plan No", "Line No")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(dropdown; "Plan Year", Type, "No.", Quantity, "Estimated Cost", "Budget Amount")
        {
        }
    }

    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
        GLBudgetEntry: Record "G/L Budget Entry";
        CompletionDateErr: Label 'You cannot select a date earlier than today.';
        GLAccount: Record "G/L Account";
        ProcurementType: Record "Procurement Type";
        ProcurementManagement: Codeunit "Procurement Management";

    local procedure ValidateType(ItemType: Option " ","G/L Account",Item,"Fixed Asset","Charge (Item)");
    var
        GLAccount: Record "G/L Account";
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
    begin
        CASE ItemType OF
            ItemType::"G/L Account":
                BEGIN
                    IF GLAccount.GET("No.") THEN BEGIN
                        Description := GLAccount.Name;
                    END;
                END;
            ItemType::Item:
                BEGIN
                    IF Item.GET("No.") THEN BEGIN
                        Description := Item.Description;
                        "Unit On Measure" := Item."Base Unit of Measure";
                        "Unit Price" := Item."Unit Price";
                    END;
                END;
            ItemType::"Fixed Asset":
                BEGIN
                    IF FixedAsset.GET("No.") THEN BEGIN
                        Description := FixedAsset.Description;
                    END;
                END;
        END;
    end;

    local procedure ValidateEstimatedCost();
    var
        ExcessErr: Label 'Please Note that the estimated cost of %1 is higher than the available budget amount of %2.';
    begin
        IF (Quantity <> 0) AND ("Unit Price" <> 0) THEN
            "Estimated Cost" := Quantity * "Unit Price";
        ValidateBudgetAmount;
    end;

    local procedure ValidateBudgetAmount();
    var
        ExcessErr: Label 'Please Note that the estimated cost of %1 is higher than the available budget amount of %2.';
        ProcurementPlanLines: Record "Procurement Plan Line";
        BudgetAmountOnLines: Decimal;
        AvailableBudgetAmount: Decimal;
        ExcessErr2: Label 'Please Note that the available budget amount on %1 is %2';
    begin
        IF GLBudgetEntry.GET("Source Of Funds") THEN BEGIN
            BudgetAmountOnLines := 0;
            AvailableBudgetAmount := 0;
            ProcurementPlanLines.RESET;
            //ProcurementPlanLines.SETRANGE("Plan No","Plan No");
            ProcurementPlanLines.SETFILTER("Line No", '<>%1', "Line No");
            ProcurementPlanLines.SETRANGE("Source Of Funds", "Source Of Funds");
            IF ProcurementPlanLines.FINDSET THEN BEGIN
                REPEAT
                    BudgetAmountOnLines += ProcurementPlanLines."Estimated Cost";
                UNTIL ProcurementPlanLines.NEXT = 0;
            END;
            AvailableBudgetAmount := GLBudgetEntry.Amount - BudgetAmountOnLines;
            IF AvailableBudgetAmount <= 0 THEN
                ERROR(ExcessErr2, GLBudgetEntry."G/L Account No.", AvailableBudgetAmount);
            IF "Estimated Cost" > AvailableBudgetAmount THEN BEGIN
                ERROR(ExcessErr, "Estimated Cost", AvailableBudgetAmount);
            END ELSE BEGIN
                "G/L Account" := GLBudgetEntry."G/L Account No.";
                IF GLAccount.GET("G/L Account") THEN
                    "G/L Name" := GLAccount.Name;
                "Budget Amount" := GLBudgetEntry.Amount;
                "Remaining Amount" := AvailableBudgetAmount - "Estimated Cost";
            END;
        END;
    end;

    local procedure ValidateQuarterlyAmount();
    var
        QuarterErr: Label 'Quarterly amounts of %1 exceeds the estimated cost of %2.';
        TotalAmount: Decimal;
        QuarterErr2: Label 'Quarterly allocation of %1 exceeds the requested Quantity of %2.';
    begin
        IF "Distribution Type" = "Distribution Type"::Amount THEN BEGIN
            TotalAmount := 0;
            TotalAmount := "1st Quarter" + "2nd Quarter" + "3rd Quarter" + "4th Quarter";
            IF TotalAmount > "Estimated Cost" THEN BEGIN
                ERROR(QuarterErr, TotalAmount, "Estimated Cost");
            END;
        END ELSE BEGIN
            TotalAmount := 0;
            TotalAmount := "1st Quarter" + "2nd Quarter" + "3rd Quarter" + "4th Quarter";
            IF TotalAmount > Quantity THEN BEGIN
                ERROR(QuarterErr2, TotalAmount, Quantity);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ValidateProcurementDates(AdvertDate: Date);
    var
        ProcurementMethod: Record "Procurement Method";
        AdvertDateErr: Label 'Kindly Capture All the Advertisement Dates.';
        ProcurementPlanLine: Record "Procurement Plan Line";
        RecRef: RecordRef;
        ProcurementRequest: Record "Procurement Request";
        AdvertisementDate: Date;
        ProcurementRequest2: Record "Procurement Request";
    begin
        IF ProcurementMethod.GET(ProcurementPlanLine."Procurement Method") THEN BEGIN
            IF AdvertDate <> 0D THEN BEGIN
                IF FORMAT(ProcurementMethod."Document Open Period") <> '0D' THEN
                    "Document Opening Date" := CALCDATE(ProcurementMethod."Document Open Period", AdvertDate);
                IF FORMAT(ProcurementMethod."Process Evaluation Period") <> '0D' THEN
                    "Proposal Evaluation Date" := CALCDATE(ProcurementMethod."Process Evaluation Period", AdvertDate);
                IF FORMAT(ProcurementMethod."Award Approval") <> '0D' THEN
                    "Award Approval Date" := CALCDATE(ProcurementMethod."Award Approval", AdvertDate);
                IF FORMAT(ProcurementMethod."Notification Of Award") <> '0D' THEN
                    "Notification Of Award Date" := CALCDATE(ProcurementMethod."Notification Of Award", AdvertDate);
                IF FORMAT(ProcurementMethod."Time For Contract signature") <> '0D' THEN
                    "Contract Signing Date" := CALCDATE(ProcurementMethod."Time For Contract Completion", AdvertDate);
                MODIFY;
            END;
        END;
    end;
}

