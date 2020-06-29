report 50449 "Budget Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Budget Report.rdlc';

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

                trigger OnAfterGetRecord();
                begin
                    BudgetDescription := '';
                    AmountSpent := 0;
                    CommittedAmount := 0;
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
        BudgetamountLbl: Label 'Budgetted Amount';
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
        TITLECaptionLbl: Label 'BUDGET REPORT';
        CompInfo: Record "Company Information";
        BudgetDescription: Text;
        GLAccount: Record "G/L Account";
        AmountSpent: Decimal;
        CommittedAmount: Decimal;
        GlobalDim1: Text;
        GlobalDim2: Text;
        MonthCaptions: Text;
}

