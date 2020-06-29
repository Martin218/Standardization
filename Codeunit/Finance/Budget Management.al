codeunit 50040 "Budget Management"
{
    // version TL 2.0


    trigger OnRun();
    begin
        CommitingBudgetLine(CommitmentTypes::IMPREST, Types::Committed, '2019NBD', '2019NBD-02', '1120', 75000, '', '');
    end;

    var
        BudgetCreationLines: Record "Budget Creation Lines";
        BudgetCreationCopy: Record "Budget Creation Lines";
        GLBudgetEntry: Record "G/L Budget Entry";
        "EntryNo.": Integer;
        GLAccount: Record "G/L Account";
        UserSetup: Record "User Setup";
        MonthlyDistribution: Record "Monthly Distribution";
        YearlyDistribution: Record "Monthly Distribution";
        GLBudgetName: Record "G/L Budget Name";
        Month: Date;
        i: Integer;
        Window: Dialog;
        Counting: Integer;
        NoofRows: Integer;
        CommitmentEntry: Record "Commitment Entry";
        CommittedAmount: Decimal;
        GLSetup: Record "General Ledger Setup";
        GLEntry: Record "G/L Entry";
        ActualAmountExpense: Decimal;
        CommitmentTypes: Option " ",LPO,LSO,IMPREST,ITEMS;
        Types: Option Committed,Reversal;
        CommitedAmount: Decimal;
        BudgettedAmount: Decimal;
        PostedLine: Boolean;
        TempBudgetBuf1: Record "Budget Buffer" temporary;
        TempBudgetBuf2: Record "Budget Buffer" temporary;
        ExcelBuf: Record "Excel Buffer" temporary;
        J: Integer;
        RowNo: Integer;
        ColNo: Integer;
        Text001: Label 'Export Filters';
        ConstantColNo: Integer;
        RecNo: Integer;
        HeaderRowNo: Integer;
        TestMode: Boolean;
        Text002: Label 'Budget Line Description';
        StartDate: Date;
        Enddate: Date;
        CurrentDate: Date;
        Continue: Boolean;
        Text003: Label 'Budget Line Amount';
        NoOfPeriods: Integer;
        MatrixMgt: Codeunit "Matrix Management";
        Defualt: Integer;
        RoundingFactor: Option "None","1","1000","1000000";
        Text004: Label 'Are you sure that you want to %1 for the budget name %2?';
        Text005: Label '%1 table has been successfully updated with %2 entries.';
        Text006: Label 'Replace Entries,Add Entries';
        ImportOption: Option "Replace entries","Add entries";
        ServerFileName: Text;
        SheetName: Text[250];
        ToGLBudgetName: Code[20];
        Text007: Label 'Import Excel File';
        Text008: Label 'BUDGET NAME';
        Text009: Label 'BRANCH CODE';
        Text010: Label 'DEPARTMENT CODE';
        Dim1Code: Label 'BRANCH';
        Dim2Code: Label 'DEPARTMENT';
        FileExtensionFilterTok: Label 'Excel Files (*.xlsx)|*.xlsx';
        ExcelFileNameTok: TextConst Comment = '%1 = String generated from current datetime to make sure file names are unique ', ENU = '*%1.xlsx';
        ImportFromExcelTxt: Label 'Import from Excel';
        ExcelFileExtensionTok: Label '.xlsx';
        ConfigExcelExchange: Codeunit "Config. Excel Exchange";
        FileMgt: Codeunit "File Management";
        ExcelExt: Label '"Excel Files (*.xlsx;*.xls)"';
        TotalRowNo: Integer;
        MonthDate: Date;
        MyBudgetName: Code[20];
        DataStartLineNo: Integer;
        R: Integer;
        GetEntrNo: Integer;
        CashManagement: Codeunit "Cash Management";
        GlobalDimension1Code: Code[20];
        GlobalDimension2Code: Code[20];
        DimensionValue: Record "Dimension Value";
        ShowBranch: Boolean;
        ShowDepartment: Boolean;
        EntryType: Option Monthly,Yearly;
        SelectBranch: Label '&Ship,&Invoice,Ship &and Invoice';
        SelectDepartment: Code[20];
        SelectBranchname: Code[20];
        ImprestLines: Record "Imprest Lines";
        CashMgtSetup: Record "Cash Management Setup";

    procedure GenerateBudgetLines(GLBudgetName: Record "G/L Budget Name");
    begin
        WITH GLBudgetName DO BEGIN
            "EntryNo." += 1;
            BudgetCreationLines.RESET;
            BudgetCreationLines.SETCURRENTKEY("Entry No.");
            BudgetCreationLines.ASCENDING(FALSE);
            IF BudgetCreationLines.FINDFIRST THEN BEGIN
                "EntryNo." := BudgetCreationLines."Entry No." + 1;
            END;
            UserSetup.RESET;
            UserSetup.GET(USERID);
            UserSetup.TESTFIELD("Global Dimension 2 Code");
            UserSetup.TESTFIELD("Global Dimension 1 Code");
            GLAccount.RESET;
            GLAccount.SETRANGE("Account Type", GLAccount."Account Type"::Posting);
            GLAccount.SETRANGE(Blocked, FALSE);
            GLAccount.SETFILTER("Account Category", '%1|%2|%3', GLAccount."Account Category"::Assets, GLAccount."Account Category"::Liabilities, GLAccount."Account Category"::Expense);
            GLAccount.SETRANGE("Direct Posting", TRUE);
            IF GLAccount.FINDFIRST THEN BEGIN
                REPEAT
                    BudgetCreationLines.INIT;
                    BudgetCreationLines."Entry No." := "EntryNo.";
                    IF "Budget Per Branch?" = TRUE THEN BEGIN
                        BudgetCreationLines."Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
                    END;
                    IF "Budget Per Department?" = TRUE THEN BEGIN
                        BudgetCreationLines."Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
                    END;
                    BudgetCreationLines."G/L Account No." := GLAccount."No.";
                    BudgetCreationLines."G/L Account Name" := GLAccount.Name;
                    BudgetCreationLines."Budget Name" := Name;
                    IF NOT CheckBudgetLines(BudgetCreationLines) THEN BEGIN
                        BudgetCreationLines.INSERT;
                    END;
                    "EntryNo." += 1;
                UNTIL GLAccount.NEXT = 0;
            END;
        END;
    end;

    procedure PostingBudgetLines(GLBudgetName: Record "G/L Budget Name");
    begin
        WITH GLBudgetName DO BEGIN
            IF Blocked = FALSE THEN BEGIN
                Window.OPEN('Posting Budget for G/L: #1### Progress @2@@@@');
                NoofRows := 0;
                Counting := 0;
                "EntryNo." += 1;
                PostedLine := FALSE;
                GLBudgetEntry.RESET;
                GLBudgetEntry.SETCURRENTKEY("Entry No.");
                GLBudgetEntry.ASCENDING(FALSE);
                IF GLBudgetEntry.FINDFIRST THEN BEGIN
                    "EntryNo." := GLBudgetEntry."Entry No." + 1;
                END;
                BudgetCreationLines.RESET;
                BudgetCreationLines.SETRANGE("Budget Name", Name);
                NoofRows := BudgetCreationLines.COUNT;
                IF BudgetCreationLines.FINDFIRST THEN BEGIN
                    REPEAT
                        Window.UPDATE(1, BudgetCreationLines."G/L Account No." + ' : ' + BudgetCreationLines."G/L Account Name");
                        Counting += 1;
                        Window.UPDATE(2, ((Counting / NoofRows) * 10000) DIV 1);
                        MonthlyDistribution.RESET;
                        MonthlyDistribution.SETRANGE("Entry No.", BudgetCreationLines."Entry No.");
                        MonthlyDistribution.SETRANGE("Account No.", BudgetCreationLines."G/L Account No.");
                        //MonthlyDistribution.SETRANGE(Consolidated,TRUE);
                        MonthlyDistribution.SETRANGE(Posted, FALSE);
                        IF MonthlyDistribution.FINDFIRST THEN BEGIN
                            REPEAT
                                GLBudgetEntry.INIT;
                                GLBudgetEntry."Entry No." := "EntryNo.";
                                GLBudgetEntry.Date := 0D;
                                IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                                    GLBudgetEntry.Date := MonthlyDistribution.Month;
                                END;
                                GLBudgetEntry."Budget Name" := BudgetCreationLines."Budget Name";
                                GLBudgetEntry."G/L Account No." := BudgetCreationLines."G/L Account No.";
                                GLBudgetEntry.Amount := MonthlyDistribution.Amount;
                                GLBudgetEntry.Description := MonthlyDistribution.Description;
                                GLBudgetEntry."Global Dimension 1 Code" := MonthlyDistribution."Global Dimension 1 Code";
                                GLBudgetEntry."Global Dimension 2 Code" := MonthlyDistribution."Global Dimension 2 Code";
                                GLBudgetEntry."User ID" := USERID;
                                IF GLBudgetEntry.Amount <> 0 THEN BEGIN
                                    IF GLBudgetEntry.INSERT(TRUE) THEN BEGIN
                                        "EntryNo." += 1;
                                        MonthlyDistribution.Posted := TRUE;
                                        MonthlyDistribution.MODIFY(TRUE);
                                    END;
                                END;
                            UNTIL MonthlyDistribution.NEXT = 0;
                        END;
                    UNTIL BudgetCreationLines.NEXT = 0;
                    Window.CLOSE;
                    MESSAGE('Budget Posting Successfully Done!');
                END;
            END;
        END;
    end;

    procedure CheckBudgetLines(BudgetCreationLines: Record "Budget Creation Lines"): Boolean;
    var
        BgtLines: Record "Budget Creation Lines";
    begin
        WITH BudgetCreationLines DO BEGIN
            BgtLines.RESET;
            BgtLines.SETRANGE("Budget Name", "Budget Name");
            BgtLines.SETRANGE("G/L Account No.", "G/L Account No.");
            IF BgtLines.FINDFIRST THEN BEGIN
                GetEntrNo := BgtLines."Entry No.";
                EXIT(TRUE);
            END ELSE BEGIN
                EXIT(FALSE);
            END;
        END;
    end;

    procedure GeneralMonthlyLines(BudgetCreationLines: Record "Budget Creation Lines");
    begin
        WITH BudgetCreationLines DO BEGIN
            GLBudgetName.GET("Budget Name");
            IF GLBudgetName."Budget Period" = GLBudgetName."Budget Period"::Monthly THEN BEGIN
                Month := 0D;
                GLBudgetName.GET("Budget Name");
                GLBudgetName.TESTFIELD("Budget Start Date");
                Month := GLBudgetName."Budget Start Date";
                FOR i := 1 TO 12 DO BEGIN
                    MonthlyDistribution.INIT;
                    MonthlyDistribution."Entry No." := "Entry No.";
                    MonthlyDistribution."Account No." := "G/L Account No.";
                    MonthlyDistribution.Description := "G/L Account Name";
                    MonthlyDistribution."Global Dimension 1 Code" := BudgetCreationLines."Global Dimension 1 Code";
                    MonthlyDistribution."Global Dimension 2 Code" := BudgetCreationLines."Global Dimension 2 Code";
                    MonthlyDistribution.Month := Month;
                    MonthlyDistribution."Budget Period" := MonthlyDistribution."Budget Period"::Monthly;
                    IF NOT MonthlyDistribution.GET("Entry No.", "G/L Account No.", Month) THEN BEGIN
                        MonthlyDistribution.INSERT;
                        Month := CALCDATE('1M', Month);
                    END;
                END;
            END;
            IF GLBudgetName."Budget Period" = GLBudgetName."Budget Period"::Yearly THEN BEGIN
                IF (GLBudgetName."Budget Per Branch?" = TRUE) AND (GLBudgetName."Budget Per Department?" = FALSE) THEN BEGIN
                    Month := TODAY;
                    DimensionValue.RESET;
                    DimensionValue.SETRANGE("Dimension Code", Dim1Code);
                    IF DimensionValue.FINDFIRST THEN BEGIN
                        REPEAT
                            MonthlyDistribution.INIT;
                            MonthlyDistribution."Entry No." := "Entry No.";
                            MonthlyDistribution."Account No." := "G/L Account No.";
                            MonthlyDistribution.Description := "G/L Account Name";
                            MonthlyDistribution."Global Dimension 1 Code" := DimensionValue.Code;
                            MonthlyDistribution.Month := Month;
                            MonthlyDistribution."Budget Period" := MonthlyDistribution."Budget Period"::Yearly;
                            IF NOT MonthlyDistribution.GET("Entry No.", "G/L Account No.", Month) THEN BEGIN
                                MonthlyDistribution.INSERT;
                                Month := CALCDATE('1D', Month);
                            END;
                        UNTIL DimensionValue.NEXT = 0;
                    END;
                END;
                IF (GLBudgetName."Budget Per Branch?" = FALSE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                    Month := TODAY;
                    DimensionValue.RESET;
                    DimensionValue.SETRANGE("Dimension Code", Dim2Code);
                    IF DimensionValue.FINDFIRST THEN BEGIN
                        REPEAT
                            MonthlyDistribution.INIT;
                            MonthlyDistribution."Entry No." := "Entry No.";
                            MonthlyDistribution."Account No." := "G/L Account No.";
                            MonthlyDistribution.Description := "G/L Account Name";
                            MonthlyDistribution."Global Dimension 1 Code" := DimensionValue.Code;
                            MonthlyDistribution.Month := Month;
                            MonthlyDistribution."Budget Period" := MonthlyDistribution."Budget Period"::Yearly;
                            IF NOT MonthlyDistribution.GET("Entry No.", "G/L Account No.", Month) THEN BEGIN
                                MonthlyDistribution.INSERT;
                                Month := CALCDATE('1D', Month);
                            END;
                        UNTIL DimensionValue.NEXT = 0;
                    END;
                END;
            END;
            MonthlyDistribution.SETRANGE("Entry No.", "Entry No.");
            PAGE.RUN(50571, MonthlyDistribution);
        END;
    end;

    procedure BudgetPeriod(GLBudgetName: Record "G/L Budget Name"): Boolean;
    begin
        WITH GLBudgetName DO BEGIN
            IF "Budget Period" = "Budget Period"::Yearly THEN BEGIN
                IF ("Budget Per Department?" = TRUE) AND ("Budget Per Branch?" = FALSE) THEN BEGIN
                    EXIT(TRUE);
                END;
                IF ("Budget Per Department?" = FALSE) AND ("Budget Per Branch?" = TRUE) THEN BEGIN
                    EXIT(TRUE);
                END;
                IF ("Budget Per Department?" = FALSE) AND ("Budget Per Branch?" = FALSE) THEN BEGIN
                    EXIT(FALSE);
                END;
                IF ("Budget Per Department?" = TRUE) AND ("Budget Per Branch?" = TRUE) THEN BEGIN
                    EXIT(TRUE);
                END;
            END;
            IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                EXIT(TRUE);
            END;
        END;
    end;

    procedure BudgetPerBranch(GLBudgetName: Record "G/L Budget Name"): Boolean;
    begin
        WITH GLBudgetName DO BEGIN
            IF "Budget Per Branch?" = TRUE THEN BEGIN
                EXIT(TRUE);
            END;
            IF "Budget Per Department?" = FALSE THEN BEGIN
                EXIT(FALSE);
            END;
        END;
    end;

    procedure BudgetPerDepartment(GLBudgetName: Record "G/L Budget Name"): Boolean;
    begin
        WITH GLBudgetName DO BEGIN
            IF "Budget Per Branch?" = TRUE THEN BEGIN
                EXIT(FALSE);
            END;
            IF "Budget Per Department?" = TRUE THEN BEGIN
                EXIT(TRUE);
            END;
        END;
    end;

    procedure CommitingBudgetLine(CommitmentType: Option " ",LPO,LSO,IMPREST,ITEMS; Type: Option Committed,Reversal; BudgetName: Code[20]; "DocumentNo.": Code[20]; GLAccount: Code[20]; Amount: Decimal; GlobalDimension1: Code[20]; GlobalDimension2: Code[20]);
    begin
        "EntryNo." += 1;
        CommittedAmount := 0;
        CommitmentEntry.RESET;
        CommitmentEntry.SETCURRENTKEY("Entry No.");
        CommitmentEntry.ASCENDING(FALSE);
        IF CommitmentEntry.FINDFIRST THEN BEGIN
            "EntryNo." := CommitmentEntry."Entry No." + 1;
        END;
        IF Type = Type::Reversal THEN BEGIN
            CommitmentEntry.RESET;
            CommitmentEntry.SETRANGE("Budget Name", BudgetName);
            CommitmentEntry.SETRANGE("Document No.", "DocumentNo.");
            CommitmentEntry.SETRANGE("Budget Line", GLAccount);
            IF CommitmentEntry.FINDFIRST THEN BEGIN
                REPEAT
                    CommittedAmount := CommittedAmount + CommitmentEntry.Amount;
                UNTIL CommitmentEntry.NEXT = 0;
                IF (ABS(CommittedAmount) = ABS(Amount)) OR (CommitedAmount = 0) THEN BEGIN
                    CommitmentEntry."Fully Accounted for" := TRUE;
                    CommitmentEntry.MODIFY;
                END;
            END;
        END;
        CommitmentEntry.INIT;
        CommitmentEntry."Entry No." := "EntryNo.";
        CommitmentEntry."Commitment Type" := CommitmentType;
        CommitmentEntry.Type := Type;
        CommitmentEntry."Document No." := "DocumentNo.";
        CommitmentEntry."Budget Line" := GLAccount;
        CommitmentEntry."Budget Name" := BudgetName;
        CommitmentEntry."Commitment Date" := TODAY;
        CommitmentEntry."Time Stamp" := TIME;
        CommitmentEntry."User ID" := USERID;
        CommitmentEntry."Global Dimension 1 Code" := GlobalDimension1;
        CommitmentEntry."Global Dimension 2 Code" := GlobalDimension2;
        CommitmentEntry."Source Type" := CommitmentEntry."Source Type"::"G/L Account";
        CommitmentEntry.Amount := Amount;
        IF ABS(CommittedAmount) = ABS(Amount) THEN BEGIN
            CommitmentEntry."Fully Accounted for" := TRUE;
        END;
        IF Type = Type::Reversal THEN BEGIN
            CommitmentEntry.Amount := -Amount;
        END;
        IF CommitmentEntry.Amount <> 0 THEN BEGIN
            IF ((CommittedAmount + CommitmentEntry.Amount) = 0) OR ((CommittedAmount + CommitmentEntry.Amount) > 0) THEN BEGIN
                CommitmentEntry.INSERT;
                MESSAGE('Budget Line %1: %3 Amount %2 was Successfully !', "DocumentNo.", Amount, Type);
            END ELSE BEGIN
                MESSAGE('No Budget Line committed/Reversed!');
            END;
        END;
    end;

    procedure ActualExpense(GLAccount: Code[20]; GlobalDimension1: Code[20]; GlobalDimesion2: Code[20]; CurrentBugdet: Code[20]): Decimal;
    var
        BudgetStartDate: Date;
        BudgetEndDate: Date;
    begin
        GLSetup.RESET;
        GLSetup.GET;
        GLSetup.TESTFIELD("Current Bugdet");
        GLSetup.TESTFIELD("Current Budget Start Date");
        GLSetup.TESTFIELD("Current Budget End Date");
        IF CurrentBugdet = '' THEN BEGIN
            CurrentBugdet := GLSetup."Current Bugdet";
            BudgetStartDate := GLSetup."Current Budget Start Date";
            BudgetEndDate := GLSetup."Current Budget End Date";
            GLBudgetName.GET(CurrentBugdet);
        END ELSE BEGIN
            GLBudgetName.GET(CurrentBugdet);
            BudgetStartDate := GLBudgetName."Budget Start Date";
            BudgetEndDate := GLBudgetName."Budget End Date";
        END;
        ActualAmountExpense := 0;
        WITH GLBudgetName DO BEGIN
            IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                GLEntry.RESET;
                GLEntry.SETRANGE("G/L Account No.", GLAccount);
                GLEntry.SETRANGE("Posting Date", BudgetStartDate, BudgetEndDate);
                GLEntry.SETRANGE("Global Dimension 1 Code", GlobalDimension1);
                IF GLEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ActualAmountExpense := ActualAmountExpense + GLEntry.Amount;
                    UNTIL GLEntry.NEXT = 0;
                END;
            END;
            IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                GLEntry.RESET;
                GLEntry.SETRANGE("G/L Account No.", GLAccount);
                GLEntry.SETRANGE("Posting Date", BudgetStartDate, BudgetEndDate);
                GLEntry.SETRANGE("Global Dimension 1 Code", GlobalDimension1);
                GLEntry.SETRANGE("Global Dimension 2 Code", GlobalDimesion2);
                IF GLEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ActualAmountExpense := ActualAmountExpense + GLEntry.Amount;
                    UNTIL GLEntry.NEXT = 0;
                END;
            END;
            IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                GLEntry.RESET;
                GLEntry.SETRANGE("G/L Account No.", GLAccount);
                GLEntry.SETRANGE("Posting Date", BudgetStartDate, BudgetEndDate);
                GLEntry.SETRANGE("Global Dimension 2 Code", GlobalDimesion2);
                IF GLEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ActualAmountExpense := ActualAmountExpense + GLEntry.Amount;
                    UNTIL GLEntry.NEXT = 0;
                END;
            END;
            IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                GLEntry.RESET;
                GLEntry.SETRANGE("G/L Account No.", GLAccount);
                GLEntry.SETRANGE("Posting Date", BudgetStartDate, BudgetEndDate);
                IF GLEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ActualAmountExpense := ActualAmountExpense + GLEntry.Amount;
                    UNTIL GLEntry.NEXT = 0;
                END;
            END;
        END;
        EXIT(ActualAmountExpense);
    end;

    procedure GetcommitedAmount(GLAccount: Code[20]; GlobalDimension1: Code[20]; GlobalDimesion2: Code[20]; CurrentBugdet: Code[20]): Decimal;
    begin
        GLSetup.RESET;
        GLSetup.GET;
        GLSetup.TESTFIELD("Current Bugdet");
        GLSetup.TESTFIELD("Current Budget Start Date");
        GLSetup.TESTFIELD("Current Budget End Date");
        IF CurrentBugdet = '' THEN BEGIN
            CurrentBugdet := GLSetup."Current Bugdet";
        END;
        CommitedAmount := 0;
        GLBudgetName.GET(CurrentBugdet);
        CommitmentEntry.RESET;
        CommitmentEntry.SETRANGE("Budget Line", GLAccount);
        CommitmentEntry.SETRANGE("Budget Name", GLBudgetName.Name);
        IF GLBudgetName."Budget Per Branch?" = TRUE THEN BEGIN
            CommitmentEntry.SETRANGE("Global Dimension 1 Code", GlobalDimension1);
        END;
        IF GLBudgetName."Budget Per Department?" = TRUE THEN BEGIN
            CommitmentEntry.SETRANGE("Global Dimension 2 Code", GlobalDimesion2);
        END;
        IF CommitmentEntry.FINDFIRST THEN BEGIN
            REPEAT
                CommitedAmount := CommitedAmount + CommitmentEntry.Amount;
            UNTIL CommitmentEntry.NEXT = 0;
        END;
        EXIT(CommitedAmount);
    end;

    procedure GetBudgetLineAmount(GLAccount: Code[20]; GlobalDimension1: Code[20]; GlobalDimesion2: Code[20]): Decimal;
    begin
        GLSetup.RESET;
        GLSetup.GET;
        GLSetup.TESTFIELD("Current Bugdet");
        GLSetup.TESTFIELD("Current Budget Start Date");
        GLSetup.TESTFIELD("Current Budget End Date");
        GLBudgetName.GET(GLSetup."Current Bugdet");
        WITH GLBudgetName DO BEGIN
            BudgettedAmount := 0;
            GLBudgetName.GET(GLSetup."Current Bugdet");
            GLBudgetEntry.RESET;
            GLBudgetEntry.SETRANGE("Budget Name", Name);
            GLBudgetEntry.SETRANGE("G/L Account No.", GLAccount);
            IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                GLBudgetEntry.SETRANGE(Date, GLSetup."Current Budget Start Date", CALCDATE('CM', TODAY));
            END;
            IF GLBudgetName."Budget Per Branch?" = TRUE THEN BEGIN
                GLBudgetEntry.SETRANGE("Global Dimension 1 Code", GlobalDimension1);
            END;
            IF GLBudgetName."Budget Per Department?" = TRUE THEN BEGIN
                GLBudgetEntry.SETRANGE("Global Dimension 2 Code", GlobalDimesion2);
            END;
            IF GLBudgetEntry.FINDFIRST THEN BEGIN
                REPEAT
                    BudgettedAmount := BudgettedAmount + GLBudgetEntry.Amount;
                UNTIL GLBudgetEntry.NEXT = 0;
            END;
        END;
        EXIT(BudgettedAmount);
    end;

    procedure GenerateExcel(GLBudgetName: Record "G/L Budget Name"; MyBranch: Code[20]; MyDepartment: Code[20]);
    var
        SelectionDepartment: Integer;
        SelectionBranch: Integer;
    begin
        WITH GLBudgetName DO BEGIN
            ExcelBuf.DELETEALL;
            RecNo := 0;
            RowNo := 1;
            NoOfPeriods := 1;
            CashMgtSetup.GET;
            UserSetup.GET(USERID);
            GlobalDimension1Code := UserSetup."Global Dimension 1 Code";
            GlobalDimension2Code := UserSetup."Global Dimension 2 Code";
            EnterCell(RowNo, 1, Text001, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            EnterCell(RowNo, 2, '', FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            EnterFilterInCell(Name, Text008, '');
            IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                EnterFilterInCell(GlobalDimension1Code, Text009, CashManagement.GetDimensionName(GlobalDimension1Code, 1));
                IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                    EnterFilterInCell(GlobalDimension2Code, Text010, CashManagement.GetDimensionName(GlobalDimension2Code, 2));
                END;
            END;
            IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                    EnterFilterInCell(GlobalDimension1Code, Text009, CashManagement.GetDimensionName(GlobalDimension1Code, 1));
                END;
            END;
            IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                    EnterFilterInCell(GlobalDimension2Code, Text010, CashManagement.GetDimensionName(GlobalDimension2Code, 2));
                END;
            END;
            RowNo := RowNo + 2;
            HeaderRowNo := RowNo;
            EnterCell(HeaderRowNo, 1, BudgetCreationLines.FIELDCAPTION("G/L Account No."), FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            EnterCell(HeaderRowNo, 2, BudgetCreationLines.FIELDCAPTION("G/L Account Name"), FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            EnterCell(HeaderRowNo, 3, Text002, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ColNo := 3;
            IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                StartDate := "Budget Start Date";
                Enddate := "Budget End Date";
                CurrentDate := StartDate;
                MonthDate := StartDate;
                NoOfPeriods := (DATE2DMY("Budget End Date", 2) - DATE2DMY("Budget Start Date", 2)) + 1;
                ColNo := ColNo + 1;
                WHILE CurrentDate <= Enddate DO BEGIN
                    EnterCell(HeaderRowNo, ColNo, FORMAT(CurrentDate), FALSE, TRUE, '', ExcelBuf."Cell Type"::Date);
                    CurrentDate := CALCDATE('1M', CurrentDate);
                    ColNo := ColNo + 1;
                END;
            END;
            IF "Budget Period" = "Budget Period"::Yearly THEN BEGIN
                IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                    GetDimensionValue(Dim1Code, MyBranch, MyBranch);
                END;
                IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                    GetDimensionValue(Dim2Code, MyDepartment, MyDepartment);
                END;
                IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                    ColNo := ColNo + 1;
                    EnterCell(HeaderRowNo, ColNo, Text003, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                END;
                IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                    GetDimensionValue(Dim2Code, MyDepartment, MyDepartment);
                END;
            END;
            RowNo := RowNo + 1;
            BudgetCreationLines.RESET;
            BudgetCreationLines.SETRANGE("Budget Name", Name);
            IF BudgetCreationLines.FINDFIRST THEN BEGIN
                REPEAT
                    EnterCell(RowNo, 1, BudgetCreationLines."G/L Account No.", FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 2, BudgetCreationLines."G/L Account Name", FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 3, BudgetCreationLines.Description, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    RecNo := 4;
                    MonthDate := StartDate;
                    J := 1;
                    IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                        WHILE J <= NoOfPeriods DO BEGIN
                            IF MonthlyDistribution.GET(BudgetCreationLines."Entry No.", BudgetCreationLines."G/L Account No.", MonthDate, GlobalDimension1Code, GlobalDimension2Code) THEN BEGIN
                                EnterCell(RowNo, RecNo, MatrixMgt.FormatValue(MonthlyDistribution.Amount, RoundingFactor, FALSE), FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
                            END;
                            RecNo := RecNo + 1;
                            J += 1;
                            IF MonthDate <> 0D THEN BEGIN
                                MonthDate := CALCDATE('1M', MonthDate);
                            END;
                        END;
                    END;
                    IF "Budget Period" = "Budget Period"::Yearly THEN BEGIN
                        IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                            DimensionValue.RESET;
                            DimensionValue.SETRANGE("Dimension Code", Dim2Code);
                            IF DimensionValue.FINDFIRST THEN BEGIN
                                REPEAT
                                    EnterCell(RowNo, RecNo, MatrixMgt.FormatValue(GetLineDepartmentAmount(BudgetCreationLines."Entry No.", BudgetCreationLines."G/L Account No.", GlobalDimension1Code, DimensionValue.Code), RoundingFactor, FALSE), FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
                                    RecNo := RecNo + 1;
                                UNTIL DimensionValue.NEXT = 0;
                            END;
                        END;
                        IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                            NoOfPeriods := DimensionValueCount(Dim2Code, '');
                            DimensionValue.RESET;
                            DimensionValue.SETRANGE("Dimension Code", Dim2Code);
                            IF CashMgtSetup."Budget Admin" <> USERID THEN BEGIN
                                DimensionValue.SETRANGE(Code, MyDepartment);
                            END;
                            IF DimensionValue.FINDFIRST THEN BEGIN
                                REPEAT
                                    EnterCell(RowNo, RecNo, MatrixMgt.FormatValue(GetLineDepartmentAmount(BudgetCreationLines."Entry No.", BudgetCreationLines."G/L Account No.", MyBranch, MyDepartment), RoundingFactor, FALSE), FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
                                    RecNo := RecNo + 1;
                                UNTIL DimensionValue.NEXT = 0;
                            END;
                        END;
                        IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                            NoOfPeriods := DimensionValueCount(Dim1Code, '');
                            DimensionValue.RESET;
                            DimensionValue.SETRANGE("Dimension Code", Dim1Code);
                            IF CashMgtSetup."Budget Admin" <> USERID THEN BEGIN
                                DimensionValue.SETRANGE(Code, MyBranch);
                            END;
                            IF DimensionValue.FINDFIRST THEN BEGIN
                                REPEAT
                                    EnterCell(RowNo, RecNo, MatrixMgt.FormatValue(GetLineDepartmentAmount(BudgetCreationLines."Entry No.", BudgetCreationLines."G/L Account No.", MyBranch, ''), RoundingFactor, FALSE), FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
                                    RecNo := RecNo + 1;
                                UNTIL DimensionValue.NEXT = 0;
                            END;
                        END;
                        IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                            EnterCell(RowNo, RecNo, MatrixMgt.FormatValue(GetLineDepartmentAmount(BudgetCreationLines."Entry No.", BudgetCreationLines."G/L Account No.", DimensionValue.Code, ''), RoundingFactor, FALSE), FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
                        END;
                    END;
                    RowNo := RowNo + 1;
                UNTIL BudgetCreationLines.NEXT = 0;
            END;
            ExcelBuf.CreateBookAndOpenExcel('', Name, Name, COMPANYNAME, USERID);
        END;
    end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; UnderLine: Boolean; NumberFormat: Text[30]; CellType: Option);
    begin
        ExcelBuf.INIT;
        ExcelBuf.VALIDATE("Row No.", RowNo);
        ExcelBuf.VALIDATE("Column No.", ColumnNo);
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Underline := UnderLine;
        ExcelBuf.NumberFormat := NumberFormat;
        ExcelBuf."Cell Type" := CellType;
        ExcelBuf.INSERT;
    end;

    local procedure EnterFilterInCell("Filter": Text; FieldName: Text[100]; DepartmentName: Code[100]);
    begin
        IF Filter <> '' THEN BEGIN
            RowNo := RowNo + 1;
            EnterCell(RowNo, 1, FieldName, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            EnterCell(RowNo, 2, COPYSTR(Filter, 1, 250), FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;
    end;

    procedure ImportBudgetfromExcel(GLBudgetName: Record "G/L Budget Name"; MyBranch: Code[20]; MyDepartment: Code[20]);
    begin
        WITH GLBudgetName DO BEGIN
            ExcelBuf.DELETEALL;
            "EntryNo." := 0;
            ServerFileName := FileMgt.UploadFile(Text007, ExcelFileExtensionTok);
            IF CONFIRM(Text004, FALSE, LOWERCASE(FORMAT(SELECTSTR(ImportOption + 1, Text006))), Name) THEN BEGIN
                IF SheetName = '' THEN BEGIN
                    SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                END;
                ExcelBuf.LOCKTABLE;
                BudgetCreationLines.LOCKTABLE;
                ExcelBuf.OpenBook(ServerFileName, SheetName);
                ExcelBuf.ReadSheet;
                InsertBudgetCreationLine(GLBudgetName, MyBranch, MyDepartment);
            END;
        END;
    end;

    // [Scope('Personalization')]
    procedure SetParameters(NewToGLBudgetName: Code[10]; NewImportOption: Option);
    begin
        ToGLBudgetName := NewToGLBudgetName;
        ImportOption := NewImportOption;
    end;

    //[Scope('Personalization')]
    procedure SetFileName(NewFileName: Text);
    begin
        ServerFileName := NewFileName;
    end;

    // [Scope('Internal')]
    procedure ImportExcelFromPackage(): Boolean;
    var
      //TempBlob: Record TempBlob;
      TempBlob: Codeunit "Temp Blob";
    begin

        ServerFileName := FileMgt.BLOBImportWithFilter(TempBlob, ImportFromExcelTxt, '', FileExtensionFilterTok, ExcelFileExtensionTok);
        IF ServerFileName <> '' THEN BEGIN
            EXIT(TRUE);
        END;
        EXIT(FALSE)
    end;

    local procedure GetExcelCell(RowsNo: Integer; ColumnNo: Integer): Text;
    begin
        IF ExcelBuf.GET(RowsNo, ColumnNo) THEN BEGIN
            EXIT(ExcelBuf."Cell Value as Text");
        END ELSE BEGIN
            EXIT('');
        END;
    end;

    local procedure GetExcelCellAmount(RowsNo: Integer; ColumnNo: Integer): Decimal;
    begin
        IF ExcelBuf.GET(RowsNo, ColumnNo) THEN BEGIN
            EXIT(ExcelBuf."Cell Type"::Number);
        END ELSE BEGIN
            EXIT(0);
        END;
    end;

    local procedure InsertBudgetCreationLine(GLBudgetName: Record "G/L Budget Name"; MyBranch: Code[20]; MyDepartment: Code[20]): Code[20];
    var
        Budget_Name: Code[20];
        GlobalDimension1Code: Code[20];
        GlobalDimension2Code: Code[20];
        GLAccountNo: Code[20];
        GLAccountName: Text[120];
        Description: Text[120];
        Amount: Decimal;
        StartRow: Integer;
        ContantStartRow: Integer;
        Check: Boolean;
        BgtLines: Record "Budget Creation Lines";
        AmountPermonth: array[100] of Decimal;
        EntryNo: Integer;
        CodeDim: Code[20];
    begin
        WITH GLBudgetName DO BEGIN
            CashMgtSetup.GET;
            "EntryNo." += 1;
            TotalRowNo := GetTotaRowNo;
            IF MyBudgetName = '' THEN BEGIN
                MyBudgetName := GetExcelCell(2, 2);
                IF MyBudgetName <> Name THEN BEGIN
                    ERROR('Busget Name Selected Should be %1 Not %2', Name, MyBudgetName);
                END;
            END;
            IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                IF "Budget Period" = "Budget Period"::Yearly THEN BEGIN
                    StartRow := 6;
                    GlobalDimension1Code := GetExcelCell(3, 2);
                END ELSE BEGIN
                    StartRow := 7;
                    GlobalDimension1Code := GetExcelCell(3, 2);
                    GlobalDimension2Code := GetExcelCell(4, 2);
                END;
            END;
            IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                    StartRow := 6;
                    GlobalDimension1Code := GetExcelCell(3, 2);
                END ELSE BEGIN
                    StartRow := 5;
                END;
            END;
            IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                    StartRow := 6;
                    GlobalDimension2Code := GetExcelCell(3, 2);
                END ELSE BEGIN
                    StartRow := 5;
                END;
            END;
            IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                StartRow := 5;
            END;
            ContantStartRow := StartRow - 1;
            Window.OPEN('Creating Budget For G/L: #1### Progress @2@@@@');
            NoofRows := 0;
            Counting := 0;
            WHILE StartRow <= TotalRowNo DO BEGIN
                Amount := 0;
                GLAccountNo := GetExcelCell(StartRow, 1);
                GLAccountName := GetExcelCell(StartRow, 2);
                Description := GetExcelCell(StartRow, 3);
                ColNo := 4;
                ConstantColNo := ColNo;
                IF "Budget Period" = "Budget Period"::Yearly THEN BEGIN
                    Check := EVALUATE(Amount, GetExcelCell(StartRow, ColNo));
                    Amount := Amount;
                END;
                BudgetCreationLines.RESET;
                BudgetCreationLines.SETCURRENTKEY("Entry No.");
                BudgetCreationLines.ASCENDING(FALSE);
                IF BudgetCreationLines.FINDFIRST THEN BEGIN
                    "EntryNo." := BudgetCreationLines."Entry No." + 1;
                END;
                Window.UPDATE(1, GLAccountNo + ' : ' + GLAccountName);
                Window.UPDATE(2, ((StartRow / TotalRowNo) * 10000) DIV 1);
                BudgetCreationLines.INIT;
                BudgetCreationLines."Entry No." := "EntryNo.";
                BudgetCreationLines."Budget Name" := MyBudgetName;
                BudgetCreationLines."G/L Account No." := GLAccountNo;
                BudgetCreationLines."G/L Account Name" := GLAccountName;
                BudgetCreationLines.Description := Description;
                IF NOT CheckBudgetLines(BudgetCreationLines) THEN BEGIN
                    BudgetCreationLines.INSERT;
                    EntryNo := "EntryNo.";
                    "EntryNo." += 1;
                    StartRow += 1;
                END ELSE BEGIN
                    IF BgtLines.GET(GetEntrNo, MyBudgetName) THEN BEGIN
                        BgtLines.Amount := Amount;
                        BgtLines.MODIFY;
                        EntryNo := GetEntrNo;
                    END;
                    StartRow += 1;
                END;
                NoOfPeriods := 0;
                IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                    StartDate := GLBudgetName."Budget Start Date";
                    Enddate := GLBudgetName."Budget End Date";
                    MonthDate := StartDate;
                    NoOfPeriods := (DATE2DMY("Budget End Date", 2) - DATE2DMY("Budget Start Date", 2)) + 1;
                    R := 1;
                    WHILE R <= NoOfPeriods DO BEGIN
                        Amount := 0;
                        CurrentDate := 0D;
                        Check := EVALUATE(Amount, GetExcelCell(StartRow - 1, ColNo));
                        Check := EVALUATE(CurrentDate, GetExcelCell(ContantStartRow, ColNo));
                        AmountPermonth[R] := Amount;
                        IF (AmountPermonth[R] <> 0) AND (CurrentDate IN [StartDate .. Enddate]) THEN BEGIN
                            IF (GlobalDimension1Code = MyBranch) AND (GlobalDimension2Code = MyDepartment) THEN BEGIN
                                InsertMonthlyDistribution(EntryNo, GLAccountNo, CurrentDate, Description, AmountPermonth[R], GlobalDimension1Code, GlobalDimension2Code, EntryType::Monthly, Name);
                            END;
                        END;
                        R += 1;
                        ColNo += 1;
                    END;
                END;
                IF "Budget Period" = "Budget Period"::Yearly THEN BEGIN
                    CurrentDate := TODAY;
                    IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                        R := 1;
                        NoOfPeriods := DimensionValueCount(Dim1Code, '');
                        WHILE R <= NoOfPeriods DO BEGIN
                            Amount := 0;
                            Check := EVALUATE(Amount, GetExcelCell(StartRow - 1, ColNo));
                            CodeDim := GetExcelCell(ContantStartRow, ColNo);
                            AmountPermonth[R] := Amount;
                            IF (AmountPermonth[R] <> 0) THEN BEGIN
                                IF DimensionValue.GET(Dim1Code, CodeDim) THEN BEGIN
                                    IF (CodeDim = MyBranch) OR (CashMgtSetup."Budget Admin" = USERID) THEN BEGIN
                                        InsertMonthlyDistribution(EntryNo, GLAccountNo, CurrentDate, Description, AmountPermonth[R], CodeDim, '', EntryType::Yearly, Name);
                                    END;
                                END;
                            END;
                            R += 1;
                            CurrentDate := CALCDATE('1D', CurrentDate);
                            ColNo += 1;
                        END;
                    END;
                    IF ("Budget Per Department?" = TRUE) AND ("Budget Per Branch?" = FALSE) THEN BEGIN
                        R := 1;
                        NoOfPeriods := DimensionValueCount(Dim1Code, '');
                        WHILE R <= NoOfPeriods DO BEGIN
                            Amount := 0;
                            Check := EVALUATE(Amount, GetExcelCell(StartRow - 1, ColNo));
                            CodeDim := GetExcelCell(ContantStartRow, ColNo);
                            AmountPermonth[R] := Amount;
                            IF (AmountPermonth[R] <> 0) THEN BEGIN
                                IF DimensionValue.GET(Dim2Code, CodeDim) THEN BEGIN
                                    IF (CodeDim = MyDepartment) OR (CashMgtSetup."Budget Admin" = USERID) THEN BEGIN
                                        InsertMonthlyDistribution(EntryNo, GLAccountNo, CurrentDate, Description, AmountPermonth[R], '', CodeDim, EntryType::Yearly, Name);
                                    END;
                                END;
                            END;
                            R += 1;
                            CurrentDate := CALCDATE('1D', CurrentDate);
                            ColNo += 1;
                        END;
                    END;
                    IF ("Budget Per Department?" = TRUE) AND ("Budget Per Branch?" = TRUE) THEN BEGIN
                        R := 1;
                        NoOfPeriods := DimensionValueCount(Dim1Code, '');
                        WHILE R <= NoOfPeriods DO BEGIN
                            Amount := 0;
                            Check := EVALUATE(Amount, GetExcelCell(StartRow - 1, ColNo));
                            CodeDim := GetExcelCell(ContantStartRow, ColNo);
                            AmountPermonth[R] := Amount;
                            IF (AmountPermonth[R] <> 0) THEN BEGIN
                                IF DimensionValue.GET(Dim2Code, CodeDim) THEN BEGIN
                                    IF ((CodeDim = MyDepartment) AND (GlobalDimension1Code = MyBranch)) OR (CashMgtSetup."Budget Admin" = USERID) THEN BEGIN
                                        InsertMonthlyDistribution(EntryNo, GLAccountNo, CurrentDate, Description, AmountPermonth[R], GlobalDimension1Code, CodeDim, EntryType::Yearly, Name);
                                    END;
                                END;
                            END;
                            R += 1;
                            CurrentDate := CALCDATE('1D', CurrentDate);
                            ColNo += 1;
                        END;
                    END;
                    IF ("Budget Per Department?" = FALSE) AND ("Budget Per Branch?" = FALSE) THEN BEGIN
                        IF (CashMgtSetup."Budget Admin" = USERID) THEN BEGIN
                            InsertMonthlyDistribution(EntryNo, GLAccountNo, TODAY, Description, Amount, '', '', EntryType::Yearly, Name);
                        END;
                    END;
                END;
            END;
            Window.CLOSE;
            MESSAGE('Budget Creation Successfully Done!');
            ExcelBuf.DELETEALL;
        END;
    end;

    local procedure GetTotaRowNo(): Integer;
    begin
        DataStartLineNo := 3;
        ExcelBuf.RESET;
        ExcelBuf.SETFILTER("Row No.", '%1..', DataStartLineNo);
        IF ExcelBuf.FINDLAST THEN BEGIN
            EXIT(ExcelBuf."Row No.");
        END
    end;

    local procedure InsertMonthlyDistribution(EntryNo: Integer; GLAccountNo: Code[20]; MonthDate: Date; Description: Text[100]; Amount: Decimal; LineBranchCode: Code[20]; LineDepartment: Code[20]; EntryType: Option Monthly,Yearly; BudgetName: Code[20]);
    begin
        MonthlyDistribution.INIT;
        MonthlyDistribution."Entry No." := EntryNo;
        MonthlyDistribution."Account No." := GLAccountNo;
        MonthlyDistribution."Global Dimension 1 Code" := LineBranchCode;
        MonthlyDistribution."Global Dimension 2 Code" := LineDepartment;
        MonthlyDistribution.Month := MonthDate;
        MonthlyDistribution.Amount := Amount;
        MonthlyDistribution.CreatedBy := USERID;
        MonthlyDistribution.Description := Description;
        MonthlyDistribution."Budget Name" := BudgetName;
        IF MonthlyDistribution."Budget Period" = EntryType::Monthly THEN BEGIN
            IF NOT YearlyDistribution.GET(EntryNo, GLAccountNo, MonthDate, LineBranchCode, LineDepartment) THEN BEGIN
                IF MonthlyDistribution.Amount <> 0 THEN BEGIN
                    MonthlyDistribution.INSERT;
                END;
            END ELSE BEGIN
                YearlyDistribution."Global Dimension 1 Code" := LineBranchCode;
                YearlyDistribution."Global Dimension 2 Code" := LineDepartment;
                MonthlyDistribution."Budget Name" := BudgetName;
                YearlyDistribution.Month := MonthDate;
                YearlyDistribution.Amount := Amount;
                YearlyDistribution.CreatedBy := USERID;
                YearlyDistribution.Description := Description;
                IF (MonthlyDistribution.Amount <> 0) AND (YearlyDistribution.Posted = FALSE) THEN BEGIN
                    YearlyDistribution.MODIFY;
                END;
            END;
        END ELSE BEGIN
            YearlyDistribution.RESET;
            YearlyDistribution.SETRANGE("Entry No.", EntryNo);
            YearlyDistribution.SETRANGE("Account No.", GLAccountNo);
            YearlyDistribution.SETRANGE("Global Dimension 1 Code", LineBranchCode);
            YearlyDistribution.SETRANGE("Global Dimension 2 Code", LineDepartment);
            YearlyDistribution.SETRANGE("Budget Name", BudgetName);
            IF NOT YearlyDistribution.FINDFIRST THEN BEGIN
                IF MonthlyDistribution.Amount <> 0 THEN BEGIN
                    MonthlyDistribution.INSERT;
                END ELSE BEGIN
                    YearlyDistribution."Global Dimension 1 Code" := LineBranchCode;
                    YearlyDistribution."Global Dimension 2 Code" := LineDepartment;
                    YearlyDistribution.Month := MonthDate;
                    YearlyDistribution.Amount := Amount;
                    YearlyDistribution.CreatedBy := USERID;
                    YearlyDistribution.Description := Description;
                    MonthlyDistribution."Budget Name" := BudgetName;
                    IF (MonthlyDistribution.Amount <> 0) AND (YearlyDistribution.Posted = FALSE) THEN BEGIN
                        YearlyDistribution.MODIFY;
                    END;
                END;
            END;
        END;
    end;

    local procedure GetDimensionValue(DimCode: Code[20]; MyBranch: Code[20]; MyDepartment: Code[20]);
    var
        TextStr: Text;
        CodeStr: Code[120];
        FindWhat: Text;
    begin
        CashMgtSetup.GET;
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", DimCode);
        IF DimensionValue.FINDFIRST THEN BEGIN
            REPEAT
                IF ((DimensionValue.Code <> '') AND (MyBranch = DimensionValue.Code)) OR (CashMgtSetup."Budget Admin" = USERID) THEN BEGIN
                    ColNo := ColNo + 1;
                    EnterCell(HeaderRowNo, ColNo, DimensionValue.Code, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(HeaderRowNo - 1, ColNo, UPPERCASE(DimensionValue.Name), FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                END;
            UNTIL DimensionValue.NEXT = 0;
        END;
    end;

    procedure CallFromDepartment(GLBudgetName: Record "G/L Budget Name"; Show_Branch: Code[20]; Show_Department: Code[20]);
    begin
        WITH GLBudgetName DO BEGIN
            GenerateExcel(GLBudgetName, Show_Branch, Show_Department);
        END;
    end;

    local procedure DimensionValueCount(Dim1: Code[20]; Dim2: Code[20]): Integer;
    begin
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", Dim1);
        EXIT(DimensionValue.COUNT);
    end;

    procedure GetLineDepartmentAmount(entryNo: Integer; GL_No: Code[20]; Dim1: Code[20]; Dim2: Code[20]): Decimal;
    begin
        MonthlyDistribution.RESET;
        MonthlyDistribution.SETRANGE("Entry No.", entryNo);
        MonthlyDistribution.SETRANGE("Account No.", GL_No);
        MonthlyDistribution.SETRANGE("Global Dimension 1 Code", Dim1);
        MonthlyDistribution.SETRANGE("Global Dimension 2 Code", Dim2);
        IF MonthlyDistribution.FINDFIRST THEN BEGIN
            EXIT(MonthlyDistribution.Amount);
        END;
    end;

    local procedure GetActualSpentBudget(GLBudgetName: Record "G/L Budget Name"; Dimension1: Code[20]; Dimension2: Code[20]; GLAccount: Code[20]): Decimal;
    begin
    end;

    procedure GetDepartmentsList();
    begin
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", Dim2Code);
        IF PAGE.RUNMODAL(537, DimensionValue) = ACTION::LookupOK THEN BEGIN
            SelectDepartment := DimensionValue.Code;
        END;
    end;

    procedure GetBranchList();
    begin
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", Dim1Code);
        IF PAGE.RUNMODAL(537, DimensionValue) = ACTION::LookupOK THEN BEGIN
            SelectBranchname := DimensionValue.Code;
        END;
    end;

    procedure CummulativeCommitment(GLBudgetEntry: Record "G/L Budget Entry"; CommType: Option Department,Branch,GL,Budget): Decimal;
    var
        TotalAmount: Decimal;
    begin
        WITH GLBudgetEntry DO BEGIN
            TotalAmount := 0;
            IF CommType = CommType::Branch THEN BEGIN
                CommitmentEntry.RESET;
                CommitmentEntry.SETRANGE("Budget Name", "Budget Name");
                CommitmentEntry.SETRANGE("Budget Line", "G/L Account No.");
                CommitmentEntry.SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
                IF CommitmentEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        TotalAmount := TotalAmount + CommitmentEntry.Amount;
                    UNTIL CommitmentEntry.NEXT = 0;
                END;
            END;
            IF CommType = CommType::Department THEN BEGIN
                CommitmentEntry.RESET;
                CommitmentEntry.SETRANGE("Budget Name", "Budget Name");
                CommitmentEntry.SETRANGE("Budget Line", "G/L Account No.");
                CommitmentEntry.SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
                CommitmentEntry.SETRANGE("Global Dimension 2 Code", "Global Dimension 2 Code");
                IF CommitmentEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        TotalAmount := TotalAmount + CommitmentEntry.Amount;
                    UNTIL CommitmentEntry.NEXT = 0;
                END;
            END;
            IF CommType = CommType::GL THEN BEGIN
                CommitmentEntry.RESET;
                CommitmentEntry.SETRANGE("Budget Name", "Budget Name");
                CommitmentEntry.SETRANGE("Budget Line", "G/L Account No.");
                IF CommitmentEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        TotalAmount := TotalAmount + CommitmentEntry.Amount;
                    UNTIL CommitmentEntry.NEXT = 0;
                END;
            END;
            IF CommType = CommType::Budget THEN BEGIN
                CommitmentEntry.RESET;
                CommitmentEntry.SETRANGE("Budget Name", "Budget Name");
                IF CommitmentEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        TotalAmount := TotalAmount + CommitmentEntry.Amount;
                    UNTIL CommitmentEntry.NEXT = 0;
                END;
            END;
        END;
        EXIT(TotalAmount);
    end;

    procedure CummulativeAmountSpent(GLBudgetEntry: Record "G/L Budget Entry"; CommType: Option Department,Branch,GL,Budget): Decimal;
    var
        TotalAmount: Decimal;
        GLBudgetEntries: Record "G/L Budget Entry";
    begin
        WITH GLBudgetEntry DO BEGIN
            GLBudgetName.GET("Budget Name");
            TotalAmount := 0;
            IF CommType = CommType::Branch THEN BEGIN
                GLEntry.RESET;
                GLEntry.SETRANGE("G/L Account No.", "G/L Account No.");
                GLEntry.SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
                GLEntry.SETRANGE("Posting Date", GLBudgetName."Budget Start Date", GLBudgetName."Budget End Date");
                IF GLEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        GLBudgetEntries.RESET;
                        GLBudgetEntries.SETRANGE("Budget Name", "Budget Name");
                        GLBudgetEntries.SETRANGE("G/L Account No.", GLEntry."G/L Account No.");
                        IF GLBudgetEntries.FINDFIRST THEN BEGIN
                            TotalAmount := TotalAmount + GLEntry.Amount;
                        END;
                    UNTIL GLEntry.NEXT = 0;
                END;
            END;
            IF CommType = CommType::GL THEN BEGIN
                GLEntry.RESET;
                GLEntry.SETRANGE("G/L Account No.", "G/L Account No.");
                IF "Global Dimension 1 Code" <> '' THEN BEGIN
                    GLEntry.SETFILTER("Global Dimension 1 Code", '<>%1', '');
                END;
                IF "Global Dimension 2 Code" <> '' THEN BEGIN
                    GLEntry.SETFILTER("Global Dimension 2 Code", '<>%1', '');
                END;
                GLEntry.SETRANGE("Posting Date", GLBudgetName."Budget Start Date", GLBudgetName."Budget End Date");
                IF GLEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        TotalAmount := TotalAmount + GLEntry.Amount
                    UNTIL GLEntry.NEXT = 0;
                END;
            END;
            IF CommType = CommType::Budget THEN BEGIN
                GLEntry.RESET;
                GLEntry.SETRANGE("Posting Date", GLBudgetName."Budget Start Date", GLBudgetName."Budget End Date");
                IF GLEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        GLBudgetEntries.RESET;
                        GLBudgetEntries.SETRANGE("Budget Name", "Budget Name");
                        GLBudgetEntries.SETRANGE("G/L Account No.", GLEntry."G/L Account No.");
                        IF GLBudgetEntries.FINDFIRST THEN BEGIN
                            TotalAmount := TotalAmount + GLEntry.Amount;
                        END;
                    UNTIL GLEntry.NEXT = 0;
                END;
            END;
            IF CommType = CommType::Department THEN BEGIN
                GLEntry.RESET;
                GLEntry.SETRANGE("G/L Account No.", "G/L Account No.");
                GLEntry.SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
                GLEntry.SETRANGE("Global Dimension 2 Code", "Global Dimension 2 Code");
                GLEntry.SETRANGE("Posting Date", GLBudgetName."Budget Start Date", GLBudgetName."Budget End Date");
                IF GLEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        GLBudgetEntries.RESET;
                        GLBudgetEntries.SETRANGE("Budget Name", "Budget Name");
                        GLBudgetEntries.SETRANGE("G/L Account No.", GLEntry."G/L Account No.");
                        IF GLBudgetEntries.FINDFIRST THEN BEGIN
                            TotalAmount := TotalAmount + GLEntry.Amount;
                        END;
                    UNTIL GLEntry.NEXT = 0;
                END;
            END;
        END;
        EXIT(TotalAmount);
    end;

    procedure SendForConsolidation(GLBudgetName: Record "G/L Budget Name");
    var
        LastNumberused: Integer;
    begin
        WITH GLBudgetName DO BEGIN
            IF CONFIRM('Are You Sure You Want To send Your Budget for Consolidation?', FALSE) = TRUE THEN BEGIN
                UserSetup.GET(USERID);
                CashMgtSetup.GET;
                LastNumberused := GetLastNumber + 1;
                BudgetCreationLines.RESET;
                BudgetCreationLines.SETRANGE("Budget Name", Name);
                IF BudgetCreationLines.FINDFIRST THEN BEGIN
                    REPEAT
                        MonthlyDistribution.RESET;
                        MonthlyDistribution.SETRANGE(CreatedBy, USERID);
                        MonthlyDistribution.SETRANGE("Entry No.", BudgetCreationLines."Entry No.");
                        MonthlyDistribution.SETRANGE("Account No.", BudgetCreationLines."G/L Account No.");
                        IF CashMgtSetup."Budget Admin" <> USERID THEN BEGIN
                            IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                                MonthlyDistribution.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 1 Code");
                                MonthlyDistribution.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 2 Code");
                            END;
                            IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                                MonthlyDistribution.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 1 Code");
                            END;
                            IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                                MonthlyDistribution.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 2 Code");
                            END;
                        END;
                        MonthlyDistribution.SETRANGE(Submitted, FALSE);
                        MonthlyDistribution.SETRANGE(Posted, FALSE);
                        IF MonthlyDistribution.FINDFIRST THEN BEGIN
                            REPEAT
                                MonthlyDistribution.Submitted := TRUE;
                                MonthlyDistribution.MODIFY(TRUE);
                            UNTIL MonthlyDistribution.NEXT = 0;
                        END;
                    UNTIL BudgetCreationLines.NEXT = 0;
                END;
                MESSAGE('Budget Line Successfully Submitted For Consolidation');
            END;
        END;
    end;

    procedure Consolidate(GLBudgetName: Record "G/L Budget Name");
    begin
        WITH GLBudgetName DO BEGIN
            IF CONFIRM('Are You Sure You Want To Consolidate this Budget?', FALSE) = TRUE THEN BEGIN
                BudgetCreationLines.RESET;
                BudgetCreationLines.SETRANGE("Budget Name", Name);
                IF BudgetCreationLines.FINDFIRST THEN BEGIN
                    REPEAT
                        MonthlyDistribution.RESET;
                        //MonthlyDistribution.SETRANGE(CreatedBy,USERID);
                        MonthlyDistribution.SETRANGE("Entry No.", BudgetCreationLines."Entry No.");
                        MonthlyDistribution.SETRANGE("Account No.", BudgetCreationLines."G/L Account No.");
                        MonthlyDistribution.SETRANGE(Submitted, TRUE);
                        MonthlyDistribution.SETRANGE(Posted, FALSE);
                        IF MonthlyDistribution.FINDFIRST THEN BEGIN
                            REPEAT
                                MonthlyDistribution.Submitted := TRUE;
                                MonthlyDistribution.MODIFY(TRUE);
                            UNTIL MonthlyDistribution.NEXT = 0;
                        END;
                    UNTIL BudgetCreationLines.NEXT = 0;
                END;
                MESSAGE('Budget Line Successfully  Consolidated');
            END;
        END;
    end;

    procedure CommitImprest(ImprestManagement: Record "Imprest Management");
    begin
        WITH ImprestManagement DO BEGIN
            ImprestLines.RESET;
            ImprestLines.SETRANGE(Code, "Imprest No.");
            IF ImprestLines.FINDFIRST THEN BEGIN
                REPEAT
                    CommitingBudgetLine(CommitmentTypes::IMPREST, Types::Committed, "Budget Name", "Imprest No.", ImprestLines."Account No.", ImprestLines.Amount, "Global Dimension 1 Code", "Global Dimension 2 Code");
                UNTIL ImprestLines.NEXT = 0;
            END;
        END;
    end;

    procedure CummulativeImprestLine(ImprestLines: Record "Imprest Lines"): Decimal;
    var
        ImpLine: Record "Imprest Lines";
        AmountAvailable: Decimal;
    begin
        WITH ImprestLines DO BEGIN
            AmountAvailable := 0;
            ImpLine.RESET;
            ImpLine.SETRANGE(Code, Code);
            ImpLine.SETRANGE("Account No.", "Account No.");
            IF ImpLine.FINDFIRST THEN BEGIN
                REPEAT
                    IF ImpLine.Amount = 0 THEN BEGIN
                        ERROR('You cannot Populate this Line before finishing the Above Line with  %1 Amount', ImpLine.Amount);
                    END;
                    AmountAvailable := AmountAvailable + ImpLine.Amount;
                UNTIL ImpLine.NEXT = 0;
            END
        END;
        EXIT(AmountAvailable);
    end;

    procedure ReverseImprest(ImprestManagement: Record "Imprest Management");
    begin
        WITH ImprestManagement DO BEGIN
            ImprestLines.RESET;
            ImprestLines.SETRANGE(Code, "Imprest No.");
            IF ImprestLines.FINDFIRST THEN BEGIN
                REPEAT
                    CommitingBudgetLine(CommitmentTypes::IMPREST, Types::Reversal, "Budget Name", "Imprest No.", ImprestLines."Account No.", ImprestLines.Amount, "Global Dimension 1 Code", "Global Dimension 2 Code");
                UNTIL ImprestLines.NEXT = 0;
            END;
        END;
    end;

    local procedure GetLastNumber(): Integer;
    begin
        BudgetCreationLines.RESET;
        BudgetCreationLines.SETCURRENTKEY("Entry No.");
        BudgetCreationLines.ASCENDING(FALSE);
        IF BudgetCreationLines.FINDLAST THEN BEGIN
            EXIT(BudgetCreationLines."Entry No.");
        END;
    end;

    procedure BudgetCreationperline(BudgetCreation: Record "Budget Creation Lines"): Decimal;
    var
        Totalbudgetline: Decimal;
    begin
        WITH BudgetCreation DO BEGIN
            Totalbudgetline := 0;
            UserSetup.GET(USERID);
            GLBudgetName.GET("Budget Name");
            BudgetCreationLines.RESET;
            MonthlyDistribution.RESET;
            MonthlyDistribution.SETRANGE("Budget Name", "Budget Name");
            MonthlyDistribution.SETRANGE("Account No.", "G/L Account No.");
            IF (GLBudgetName."Budget Per Branch?" = TRUE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                MonthlyDistribution.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 1 Code");
                MonthlyDistribution.SETRANGE("Global Dimension 2 Code", UserSetup."Global Dimension 2 Code");
            END;
            IF (GLBudgetName."Budget Per Branch?" = TRUE) AND (GLBudgetName."Budget Per Department?" = FALSE) THEN BEGIN
                MonthlyDistribution.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 1 Code");
            END;
            IF (GLBudgetName."Budget Per Branch?" = FALSE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                MonthlyDistribution.SETRANGE("Global Dimension 2 Code", UserSetup."Global Dimension 2 Code");
            END;
            IF MonthlyDistribution.FINDFIRST THEN BEGIN
                REPEAT
                    Totalbudgetline := Totalbudgetline + MonthlyDistribution.Amount;
                UNTIL MonthlyDistribution.NEXT = 0;
            END;
        END;
        EXIT(Totalbudgetline);
    end;
}

