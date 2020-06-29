page 50640 "Budget Creation Header"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Budget Creation Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Budget Name"; "Budget Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field("G/L Account Name"; "G/L Account Name")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Lessamount; Lessamount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    Editable = false;
                    Visible = true;

                    trigger OnAssistEdit();
                    begin
                        GLBudgetName.GET("Budget Name");
                        BudgetLines.RESET;
                        UserSetup.GET(USERID);
                        BudgetLines.SETRANGE("Budget Name", "Budget Name");
                        BudgetLines.SETRANGE("Account No.", "G/L Account No.");
                        IF (GLBudgetName."Budget Per Branch?" = TRUE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                            BudgetLines.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 1 Code");
                            BudgetLines.SETRANGE("Global Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                        END;
                        IF (GLBudgetName."Budget Per Branch?" = TRUE) AND (GLBudgetName."Budget Per Department?" = FALSE) THEN BEGIN
                            BudgetLines.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 1 Code");
                        END;
                        IF (GLBudgetName."Budget Per Branch?" = FALSE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                            BudgetLines.SETRANGE("Global Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                        END;
                        PAGE.RUN(50571, BudgetLines);
                    end;
                }
                field("Total Monthly Amount"; "Total Monthly Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    Enabled = false;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Budget Dimension 1 Code"; "Budget Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Budget Dimension 2 Code"; "Budget Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Budget Dimension 3 Code"; "Budget Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Budget Dimension 4 Code"; "Budget Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {

            action("Populate Budget Header")
            {
                Image = CreateInventoryPickup;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    IF GLBudgetName.GET("Budget Name") THEN BEGIN
                        IF CONFIRM('Are You Sure You Want to Populate Budget Lines For ' + "Budget Name" + '  ?', FALSE) = TRUE THEN BEGIN
                            BudgetManagement.GenerateBudgetLines(GLBudgetName);
                            CurrPage.UPDATE;
                        END;
                    END;
                end;
            }
            action("Populate Budget Lines")
            {
                Image = CreateInventoryPickup;
                Promoted = true;
                PromotedCategory = Process;
                Visible = MonthlyDistribution;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    IF CONFIRM('Are You Sure You Want Generate Monthly Distribution For This Budget Line ' + "G/L Account No." + '  ?', FALSE) = TRUE THEN BEGIN
                        BudgetManagement.GeneralMonthlyLines(Rec);
                    END;
                end;
            }
            action("View Budget  Details")
            {
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    GLBudgetName.GET("Budget Name");
                    BudgetLines.RESET;
                    UserSetup.GET(USERID);
                    BudgetLines.SETRANGE("Budget Name", "Budget Name");
                    BudgetLines.SETRANGE("Account No.", "G/L Account No.");
                    IF (GLBudgetName."Budget Per Branch?" = TRUE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                        BudgetLines.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 1 Code");
                        BudgetLines.SETRANGE("Global Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                    END;
                    IF (GLBudgetName."Budget Per Branch?" = TRUE) AND (GLBudgetName."Budget Per Department?" = FALSE) THEN BEGIN
                        BudgetLines.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 1 Code");
                    END;
                    IF (GLBudgetName."Budget Per Branch?" = FALSE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                        BudgetLines.SETRANGE("Global Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                    END;
                    PAGE.RUN(50571, BudgetLines);
                end;
            }
            group("Budget Excel")
            {
                Caption = 'Budget Excel';
                action("Export to Excel")
                {
                    ApplicationArea = All;
                    ;
                    Caption = 'Export to Excel';
                    Ellipsis = true;
                    Image = ExportToExcel;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedOnly = true;
                    ToolTip = 'Export all or part of the budget to Excel for further analysis. If you make changes in Excel, you can import the budget afterwards.';

                    trigger OnAction();
                    var
                        GLBudgetEntry: Record "G/L Budget Entry";
                    begin
                        IF GLBudgetName.GET("Budget Name") THEN BEGIN
                            UserSetup.GET(USERID);
                            BudgetManagement.GenerateExcel(GLBudgetName, UserSetup."Global Dimension 1 Code", UserSetup."Global Dimension 2 Code");
                        END;
                    end;
                }
                action("Import from Excel")
                {
                    ApplicationArea = All;
                    ;
                    Caption = 'Import from Excel';
                    Ellipsis = true;
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedOnly = true;
                    ToolTip = 'Import a budget that you exported to Excel earlier.';

                    trigger OnAction();
                    var
                        ImportBudgetfromExcel: Report "Import Budget from Excel";
                    begin
                        IF GLBudgetName.GET("Budget Name") THEN BEGIN
                            UserSetup.GET(USERID);
                            BudgetManagement.ImportBudgetfromExcel(GLBudgetName, UserSetup."Global Dimension 1 Code", UserSetup."Global Dimension 2 Code");
                            CurrPage.UPDATE;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin

        GLBudgetName.GET("Budget Name");
        IF BudgetManagement.BudgetPeriod(GLBudgetName) THEN BEGIN
            MonthlyDistribution := TRUE;
            YearlyDistribution := FALSE;
        END ELSE BEGIN
            MonthlyDistribution := FALSE;
            YearlyDistribution := TRUE;
        END;
        IF BudgetManagement.BudgetPerBranch(GLBudgetName) THEN BEGIN
            BudgetPerBranch := TRUE;
        END;
        IF BudgetManagement.BudgetPerDepartment(GLBudgetName) THEN BEGIN
            BudgetPerDepartment := TRUE;
        END;
        Lessamount := 0;
        Lessamount := BudgetManagement.BudgetCreationperline(Rec);
    end;

    var
        GLBudgetName: Record "G/L Budget Name";
        BudgetManagement: Codeunit "Budget Management";
        MonthlyDistribution: Boolean;
        YearlyDistribution: Boolean;
        BudgetPerBranch: Boolean;
        BudgetPerDepartment: Boolean;
        Lessamount: Decimal;
        UserSetup: Record "User Setup";
        BudgetLines: Record "Monthly Distribution";
}

