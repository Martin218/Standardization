table 50340 "Budget Creation Lines"
{
    // version TL 2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name";
        }
        field(3; "Budget Dimension 1 Code"; Code[20])
        {
            Caption = 'Budget Dimension 1 Code';
            TableRelation = Dimension;

            trigger OnValidate();
            begin
                IF "Budget Dimension 1 Code" <> xRec."Budget Dimension 1 Code" THEN
                    IF Dim.CheckIfDimUsed("Budget Dimension 1 Code", 9, "Budget Name", '', 0) THEN
                        ERROR(Text000, Dim.GetCheckDimErr);
            end;
        }
        field(4; "Budget Dimension 2 Code"; Code[20])
        {
            Caption = 'Budget Dimension 2 Code';
            TableRelation = Dimension;

            trigger OnValidate();
            begin
                IF "Budget Dimension 2 Code" <> xRec."Budget Dimension 2 Code" THEN
                    IF Dim.CheckIfDimUsed("Budget Dimension 2 Code", 10, "Budget Name", '', 0) THEN
                        ERROR(Text000, Dim.GetCheckDimErr);
            end;
        }
        field(5; "Budget Dimension 3 Code"; Code[20])
        {
            Caption = 'Budget Dimension 3 Code';
            TableRelation = Dimension;

            trigger OnValidate();
            begin
                IF "Budget Dimension 3 Code" <> xRec."Budget Dimension 3 Code" THEN
                    IF Dim.CheckIfDimUsed("Budget Dimension 3 Code", 11, "Budget Name", '', 0) THEN
                        ERROR(Text000, Dim.GetCheckDimErr);
            end;
        }
        field(6; "Budget Dimension 4 Code"; Code[20])
        {
            Caption = 'Budget Dimension 4 Code';
            TableRelation = Dimension;

            trigger OnValidate();
            begin
                IF "Budget Dimension 4 Code" <> xRec."Budget Dimension 4 Code" THEN
                    IF Dim.CheckIfDimUsed("Budget Dimension 4 Code", 12, "Budget Name", '', 0) THEN
                        ERROR(Text000, Dim.GetCheckDimErr);
            end;
        }
        field(7; "G/L Account No."; Code[20])
        {

            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                   Blocked = CONST(false),
                                                   "Account Category" = FILTER(Assets | Liabilities | Expense),
                                                   "Direct Posting" = CONST(true));

            trigger OnValidate();
            begin

                TESTFIELD("Budget Name");
                TESTFIELD("Global Dimension 1 Code");
                TESTFIELD("Global Dimension 2 Code");
                IF BudgetManagement.CheckBudgetLines(Rec) THEN BEGIN
                    MESSAGE('Budget Line Already Exists!');
                    CLEAR("Global Dimension 1 Code");
                    CLEAR("Global Dimension 2 Code");
                    CLEAR("G/L Account No.");
                END;

                "G/L Account Name" := CashManagement."GetVendor/CustomerName"("G/L Account No.", "Account Type"::"G/L Account");

            end;
        }
        field(8; Amount; Decimal)
        {
        }
        field(9; "No of Budget Periods"; Option)
        {
            OptionMembers = "1","2","4","12";
        }
        field(10; "G/L Account Name"; Text[250])
        {
            Editable = false;
        }
        field(11; Description; Text[250])
        {
        }
        field(12; "Created By"; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(13; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                IF "Global Dimension 1 Code" = xRec."Global Dimension 1 Code" THEN
                    EXIT;
                // GetGLSetup;
                //ValidateDimValue(GLSetup."Global Dimension 1 Code","Global Dimension 1 Code");
                // UpdateDimensionSetId(GLSetup."Global Dimension 1 Code","Global Dimension 1 Code");
            end;
        }
        field(14; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                IF "Global Dimension 2 Code" = xRec."Global Dimension 2 Code" THEN
                    EXIT;
                // GetGLSetup;
                //ValidateDimValue(GLSetup."Global Dimension 2 Code","Global Dimension 2 Code");
                // UpdateDimensionSetId(GLSetup."Global Dimension 2 Code","Global Dimension 2 Code");
            end;
        }
        field(15; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                // ShowDimensions;
            end;

            trigger OnValidate();
            begin
                // IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                //  ERROR(DimMgt.GetDimCombErr);
            end;
        }
        field(16; "Total Monthly Amount"; Decimal)
        {
            CalcFormula = Sum ("Monthly Distribution".Amount WHERE("Entry No." = FIELD("Entry No."),
                                                                   "Account No." = FIELD("G/L Account No.")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate();
            begin
                // Sum("Monthly Distribution".Amount WHERE (Entry No.=FIELD(Entry No.),Account No.=FIELD(G/L Account No.)))
            end;
        }
        field(17; Posted; Boolean)
        {
        }
        field(18; Submitted; Boolean)
        {
            Editable = false;
        }
        field(19; Consolidated; Boolean)
        {
            Editable = false;
        }
        field(20; "Total Amount"; Decimal)
        {
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Budget Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        /*
          GLBudgetName.GET("Budget Name");
          "Created By":=USERID;
          UserSetup.RESET;
          UserSetup.GET(USERID);
          IF (GLBudgetName."Budget Per Branch?"=TRUE) AND (GLBudgetName."Budget Per Department?"=TRUE) THEN BEGIN
          "Global Dimension 1 Code":=UserSetup."Global Dimension 1 Code";
          "Global Dimension 2 Code":=UserSetup."Global Dimension 2 Code";
          END;
          IF (GLBudgetName."Budget Per Branch?"=TRUE) AND (GLBudgetName."Budget Per Department?"=FALSE) THEN BEGIN
          "Global Dimension 1 Code":=UserSetup."Global Dimension 1 Code";
          END;
          IF (GLBudgetName."Budget Per Branch?"=FALSE) AND (GLBudgetName."Budget Per Department?"=TRUE) THEN BEGIN
          "Global Dimension 2 Code":=UserSetup."Global Dimension 2 Code";
          END;
   */
    end;

    var
        Text000: Label '%1\You cannot use the same dimension twice in the same budget.';
        Text001: Label 'Updating budget entries @1@@@@@@@@@@@@@@@@@@';
        Dim: Record Dimension;
        DimSetEntry: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        GLSetupRetrieved: Boolean;
        GLSetup: Record "General Ledger Setup";
        GLBudgetName: Record "G/L Budget Name";
        CashManagement: Codeunit "Cash Management";
        "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        BudgetManagement: Codeunit "Budget Management";
        UserSetup: Record "User Setup";

    local procedure UpdateGLBudgetEntryDim();
    var
        GLBudgetEntry: Record "G/L Budget Entry";
        Window: Dialog;
        TotalCount: Integer;
        i: Integer;
        T0: Time;
    begin
        GLBudgetEntry.SETCURRENTKEY("Budget Name");
        GLBudgetEntry.SETRANGE("Budget Name", "Budget Name");
        GLBudgetEntry.SETFILTER("Dimension Set ID", '<>%1', 0);
        TotalCount := COUNT;
        Window.OPEN(Text001);
        T0 := TIME;
        GLBudgetEntry.LOCKTABLE;
        IF GLBudgetEntry.FINDSET THEN
            REPEAT
                i := i + 1;
                IF TIME > T0 + 750 THEN BEGIN
                    Window.UPDATE(1, 10000 * i DIV TotalCount);
                    T0 := TIME;
                END;
                GLBudgetEntry."Budget Dimension 1 Code" := GetDimValCode(GLBudgetEntry."Dimension Set ID", "Budget Dimension 1 Code");
                GLBudgetEntry."Budget Dimension 2 Code" := GetDimValCode(GLBudgetEntry."Dimension Set ID", "Budget Dimension 2 Code");
                GLBudgetEntry."Budget Dimension 3 Code" := GetDimValCode(GLBudgetEntry."Dimension Set ID", "Budget Dimension 3 Code");
                GLBudgetEntry."Budget Dimension 4 Code" := GetDimValCode(GLBudgetEntry."Dimension Set ID", "Budget Dimension 4 Code");
                GLBudgetEntry.MODIFY;
            UNTIL GLBudgetEntry.NEXT = 0;
        Window.CLOSE;
    end;

    local procedure GetDimValCode(DimSetID: Integer; DimCode: Code[20]): Code[20];
    begin
        IF DimCode = '' THEN
            EXIT('');
        IF TempDimSetEntry.GET(DimSetID, DimCode) THEN
            EXIT(TempDimSetEntry."Dimension Value Code");
        IF DimSetEntry.GET(DimSetID, DimCode) THEN
            TempDimSetEntry := DimSetEntry
        ELSE BEGIN
            TempDimSetEntry.INIT;
            TempDimSetEntry."Dimension Set ID" := DimSetID;
            TempDimSetEntry."Dimension Code" := DimCode;
        END;
        TempDimSetEntry.INSERT;
        EXIT(TempDimSetEntry."Dimension Value Code")
    end;

    local procedure ValidateDimValue(DimCode: Code[20]; var DimValueCode: Code[20]);
    var
        DimValue: Record "Dimension Value";
    begin
        IF DimValueCode = '' THEN
            EXIT;

        DimValue."Dimension Code" := DimCode;
        DimValue.Code := DimValueCode;
        DimValue.FIND('=><');
        IF DimValueCode <> COPYSTR(DimValue.Code, 1, STRLEN(DimValueCode)) THEN
            ERROR(Text000, DimValueCode, DimCode);
        DimValueCode := DimValue.Code;
    end;

    local procedure UpdateDimensionSetId(DimCode: Code[20]; DimValueCode: Code[20]);
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
        UpdateDimSet(TempDimSetEntry, DimCode, DimValueCode);
        "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;

    local procedure GetGLSetup();
    begin
        IF NOT GLSetupRetrieved THEN BEGIN
            GLSetup.GET;
            GLSetupRetrieved := TRUE;
        END;
    end;

    //[Scope('Personalization')]
    procedure UpdateDimSet(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimCode: Code[20]; DimValueCode: Code[20]);
    begin
    end;

    // [Scope('Personalization')]
    procedure ShowDimensions();
    var
        DimSetEntry: Record "Dimension Set Entry";
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Budget Name", "G/L Account No.", "Entry No."));

        IF OldDimSetID = "Dimension Set ID" THEN
            EXIT;

        GetGLSetup;
        GLBudgetName.GET("Budget Name");

        "Global Dimension 1 Code" := '';
        "Global Dimension 2 Code" := '';
        "Budget Dimension 1 Code" := '';
        "Budget Dimension 2 Code" := '';
        "Budget Dimension 3 Code" := '';
        "Budget Dimension 4 Code" := '';

        IF DimSetEntry.GET("Dimension Set ID", GLSetup."Global Dimension 1 Code") THEN
            "Global Dimension 1 Code" := DimSetEntry."Dimension Value Code";
        IF DimSetEntry.GET("Dimension Set ID", GLSetup."Global Dimension 2 Code") THEN
            "Global Dimension 2 Code" := DimSetEntry."Dimension Value Code";
        IF DimSetEntry.GET("Dimension Set ID", GLBudgetName."Budget Dimension 1 Code") THEN
            "Budget Dimension 1 Code" := DimSetEntry."Dimension Value Code";
        IF DimSetEntry.GET("Dimension Set ID", GLBudgetName."Budget Dimension 2 Code") THEN
            "Budget Dimension 2 Code" := DimSetEntry."Dimension Value Code";
        IF DimSetEntry.GET("Dimension Set ID", GLBudgetName."Budget Dimension 3 Code") THEN
            "Budget Dimension 3 Code" := DimSetEntry."Dimension Value Code";
        IF DimSetEntry.GET("Dimension Set ID", GLBudgetName."Budget Dimension 4 Code") THEN
            "Budget Dimension 4 Code" := DimSetEntry."Dimension Value Code";
    end;
}

