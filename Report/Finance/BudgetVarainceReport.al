report 50450 "Budget Varaince Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Budget Varaince Report.rdlc';

    dataset
    {
        dataitem("G/L Budget Name"; "G/L Budget Name")
        {
            RequestFilterFields = Name;
            column(CompanyInformation; STRSUBSTNO(TXT002, CompInfo.Address, CompInfo."Address 2", CompInfo.City))
            {
            }
            column(ContactInfo; STRSUBSTNO(Text001, CompInfo.Address, CompInfo."Address 2", CompInfo."Phone No.", CompInfo."E-Mail", CompInfo."Home Page", CompInfo."Company P.I.N"))
            {
            }
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(TITLECaptionLbl; TITLECaptionLbl)
            {
            }
            column(Budget_Name; "G/L Budget Name".Name)
            {
            }
            column(Description; "G/L Budget Name".Description)
            {
            }
            column(AccountLbl; AccountLbl)
            {
            }
            column(DescriptionLbl; DescriptionLbl)
            {
            }
            column(BudgetamountLbl; BudgetamountLbl)
            {
            }
            column(monthLbl; MonthCaptions)
            {
            }
            column(BrachLbl; BrachLbl)
            {
            }
            column(DepartmentLbl; DepartmentLbl)
            {
            }
            column(BudgetType; BudgetType)
            {
            }
            column(CategoryName; CategoryName)
            {
            }
            column(GlobalDim1; GlobalDim1)
            {
            }
            column(GlobalDim2; GlobalDim2)
            {
            }
            column(SpentCaptionLbl; SpentCaptionLbl)
            {
            }
            column(commtedCaptionLbl; commtedCaptionLbl)
            {
            }
            column(AvailabeCaptionLbl; AvailabeCaptionLbl)
            {
            }
            dataitem("G/L Budget Entry"; "G/L Budget Entry")
            {
                DataItemLink = "Budget Name" = FIELD(Name);
                RequestFilterFields = "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code";
                column(Account; "G/L Budget Entry"."G/L Account No.")
                {
                }
                column(BudgetLineDate; "G/L Budget Entry".Date)
                {
                }
                column(Branch; DimensionName1)
                {
                }
                column(Department; DimensionName2)
                {
                }
                column(Budget_Description; "G/L Budget Entry".Description)
                {
                }
                column(Amount; "G/L Budget Entry".Amount)
                {
                }
                column(BudgetDescription; BudgetDescription)
                {
                }
                column(AmountSpent; AmountSpent)
                {
                }
                column(CommittedAmount; CommittedAmount)
                {
                }
                column(TotalBooked; TotalBooked)
                {
                }
                column(BrachAmount; TotalCommBranch)
                {
                }
                column(TotalCommPerPerdepartment; TotalCommPerPerdepartment)
                {
                }
                column(TotalSpentBranch; TotalSpentBranch)
                {
                }
                column(TotalSpentPerGL; TotalSpentPerGL)
                {
                }
                column(GrandTotalBooked; GrandTotalBooked)
                {
                }
                column(TotalSpentPerdepartment; TotalSpentPerdepartment)
                {
                }
                column(TotalSpentPerBranch; TotalSpentPerBranch)
                {
                }
                column(AverageAmountPerLine; AverageAmountPerLine)
                {
                }
                column(AverageSpentPerGL; AverageSpentPerGL)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    BudgetDescription := '';
                    AmountSpent := 0;
                    TotalBooked := 0;
                    CommittedAmount := 0;
                    BrachAmount := 0;
                    TotalCommBranch := 0;
                    Countintpergl := 0;
                    TotalCommPerPerdepartment := 0;
                    TotalSpentPerBranch := 0;
                    TotalSpentPerdepartment := 0;
                    AverageAmountPerLine := 0;
                    AverageSpentPerGL := 0;
                    TotalSpentPerGL := 0;
                    IF (BudgetType = 2) AND ("G/L Budget Entry"."Global Dimension 1 Code" <> '') THEN BEGIN
                        DimensionName1 := CashManagement.GetDimensionName("G/L Budget Entry"."Global Dimension 1 Code", 1);
                    END;
                    IF (BudgetType = 2) AND ("G/L Budget Entry"."Global Dimension 2 Code" <> '') THEN BEGIN
                        DimensionName1 := CashManagement.GetDimensionName("G/L Budget Entry"."Global Dimension 2 Code", 2);
                    END;
                    IF BudgetType = 1 THEN BEGIN
                        DimensionName1 := CashManagement.GetDimensionName("G/L Budget Entry"."Global Dimension 1 Code", 1);
                        DimensionName2 := CashManagement.GetDimensionName("G/L Budget Entry"."Global Dimension 2 Code", 2);
                    END;
                    BudgetDescription := "G/L Budget Entry".Description;
                    IF BudgetDescription = '' THEN BEGIN
                        GLAccount.GET("G/L Budget Entry"."G/L Account No.");
                        BudgetDescription := GLAccount.Name;
                    END;
                    BudgetDescription := "G/L Budget Entry"."G/L Account No." + ':- ' + BudgetDescription;
                    CommittedAmount := BudgetManagement.GetcommitedAmount("G/L Budget Entry"."G/L Account No.", "G/L Budget Entry"."Global Dimension 1 Code", "G/L Budget Entry"."Global Dimension 2 Code", "G/L Budget Name".Name);
                    AmountSpent := BudgetManagement.ActualExpense("G/L Budget Entry"."G/L Account No.", "G/L Budget Entry"."Global Dimension 1 Code", "G/L Budget Entry"."Global Dimension 2 Code", "G/L Budget Name".Name);
                    TotalBooked := AmountSpent + CommittedAmount;
                    IF CommittedAmount <> 0 THEN BEGIN
                        TotalCommBranch := BudgetManagement.CummulativeCommitment("G/L Budget Entry", CommType::Branch);
                        TotalCommPerPerdepartment := BudgetManagement.CummulativeCommitment("G/L Budget Entry", CommType::Department);
                    END;
                    GLBudgetName.GET("G/L Budget Entry"."Budget Name");
                    WITH GLBudgetName DO BEGIN
                        IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                            CommittedAmount := BudgetManagement.CummulativeCommitment("G/L Budget Entry", CommType::GL);
                            TotalSpentPerGL := BudgetManagement.CummulativeAmountSpent("G/L Budget Entry", CommType::GL);
                        END;
                        IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                            CommittedAmount := BudgetManagement.CummulativeCommitment("G/L Budget Entry", CommType::Branch);
                            TotalSpentPerGL := BudgetManagement.CummulativeAmountSpent("G/L Budget Entry", CommType::Branch);
                            TotalCommPerPerdepartment := BudgetManagement.CummulativeCommitment("G/L Budget Entry", CommType::Branch);
                            TotalSpentPerdepartment := BudgetManagement.CummulativeAmountSpent("G/L Budget Entry", CommType::Department);
                        END;
                        IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                            CommittedAmount := BudgetManagement.CummulativeCommitment("G/L Budget Entry", CommType::Department);
                            TotalSpentPerGL := BudgetManagement.CummulativeAmountSpent("G/L Budget Entry", CommType::Department);
                            TotalCommPerPerdepartment := BudgetManagement.CummulativeCommitment("G/L Budget Entry", CommType::Department);
                            TotalSpentPerdepartment := BudgetManagement.CummulativeAmountSpent("G/L Budget Entry", CommType::Department);
                            TotalSpentPerBranch := BudgetManagement.CummulativeAmountSpent("G/L Budget Entry", CommType::GL);
                        END;
                    END;
                    GLBudgetEntry.RESET;
                    GLBudgetEntry.SETRANGE("Budget Name", "G/L Budget Entry"."Budget Name");
                    GLBudgetEntry.SETRANGE("Global Dimension 1 Code", "G/L Budget Entry"."Global Dimension 1 Code");
                    GLBudgetEntry.SETRANGE("Global Dimension 2 Code", "G/L Budget Entry"."Global Dimension 2 Code");
                    GLBudgetEntry.SETRANGE("G/L Account No.", "G/L Budget Entry"."G/L Account No.");
                    Countintpergl := GLBudgetEntry.COUNT;
                    IF CommittedAmount <> 0 THEN BEGIN
                        AverageAmountPerLine := (CommittedAmount / Countintpergl);
                    END;
                    IF TotalSpentPerGL <> 0 THEN BEGIN
                        AverageSpentPerGL := (TotalSpentPerGL / Countintpergl);
                    END;
                    IF (GLBudgetName."Budget Per Branch?" = TRUE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                        TotalSpentPerdepartment := BudgetManagement.CummulativeAmountSpent("G/L Budget Entry", CommType::Department);
                    END;
                    IF (GLBudgetName."Budget Per Branch?" = TRUE) THEN BEGIN
                        TotalSpentPerBranch := BudgetManagement.CummulativeAmountSpent("G/L Budget Entry", CommType::Branch);
                    END;
                    GrandTotalBooked := TotalSpentPerBranch + BrachAmount;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                BudgetType := 0;
                MonthCaptions := '';
                GLBudgetName.COPY("G/L Budget Name");
                WITH GLBudgetName DO BEGIN
                    IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                        BudgetType := 1;
                        GlobalDim1 := 'BRANCH';
                        GlobalDim2 := 'DEPARTMENT';
                    END;
                    IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                        BudgetType := 2;
                        CategoryName := 'BRANCH';
                    END;
                    IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                        BudgetType := 2;
                        CategoryName := 'DEPARTMENT';
                    END;
                    IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                        BudgetType := 3;
                    END;
                    IF "Budget Period" = "Budget Period"::Monthly THEN BEGIN
                        MonthCaptions := monthLbl;
                    END;
                END;
            end;

            trigger OnPreDataItem();
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
                EntrireBudgetSpent := FALSE;
                TotalSpentBranch := 0;
                GrandTotalBooked := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        BudgetType: Integer;
        AccountLbl: Label 'Budget Line:';
        DescriptionLbl: Label 'Description';
        BudgetamountLbl: Label 'Budgetted';
        monthLbl: Label 'Budgetted For Month';
        BrachLbl: Label 'Branch';
        DepartmentLbl: Label 'Department';
        GLBudgetName: Record "G/L Budget Name";
        CategoryName: Text;
        DimensionName1: Text;
        DimensionName2: Text;
        BudgetManagement: Codeunit "Budget Management";
        CashManagement: Codeunit "Cash Management";
        Text001: Label '" %1 | %2 | Mobile Phone: %3 | Email: %4 | Website: %5 | PIN No: %6"';
        TXT002: Label '%1 %2 - %3';
        TITLECaptionLbl: Label 'BUDGET VARIANCE  REPORT';
        CompInfo: Record "Company Information";
        BudgetDescription: Text;
        GLAccount: Record "G/L Account";
        AmountSpent: Decimal;
        CommittedAmount: Decimal;
        TotalBooked: Decimal;
        GlobalDim1: Text;
        GlobalDim2: Text;
        MonthCaptions: Text;
        SpentCaptionLbl: Label 'Spent';
        commtedCaptionLbl: Label 'Committed';
        AvailabeCaptionLbl: Label 'Available';
        BrachAmount: Decimal;
        GLBudgetEntry: Record "G/L Budget Entry";
        CommType: Option Department,Branch,GL,Budget;
        TotalCommBranch: Decimal;
        TotalCommPerPerdepartment: Decimal;
        TotalSpentBranch: Decimal;
        TotalSpentPerGL: Decimal;
        EntrireBudgetSpent: Boolean;
        GrandTotalBooked: Decimal;
        TotalSpentPerdepartment: Decimal;
        TotalSpentPerBranch: Decimal;
        Countintpergl: Integer;
        AverageAmountPerLine: Decimal;
        AverageSpentPerGL: Decimal;
}

