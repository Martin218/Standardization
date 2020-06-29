report 50502 "Consolidated Procurement Plan"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Procurement\ConsolidatedProcurementPlan.rdlc';

    dataset
    {
        dataitem(DataItem1; "Procurement Plan Header")
        {
            column(No_ProcurementPlanHeader; "No.")
            {
            }
            column(GlobalDimension1Code_ProcurementPlanHeader; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_ProcurementPlanHeader; "Global Dimension 2 Code")
            {
            }
            column(Comp_Name; CompanyInformation.Name)
            {
            }
            column(Comp_Address; CompanyInformation.Address)
            {
            }
            column(Comp_City; CompanyInformation.City)
            {
            }
            column(Comp_Postal; CompanyInformation."Post Code")
            {
            }
            column(Comp_Pic; CompanyInformation.Picture)
            {
            }
            dataitem(DataItem14; "Procurement Plan Line")
            {
                DataItemLink = "Plan No" = FIELD("No.");
                column(Type_ProcurementPlanLines; Type)
                {
                }
                column(No_ProcurementPlanLines; "No.")
                {
                }
                column(Description_ProcurementPlanLines; Description)
                {
                }
                column(Quantity_ProcurementPlanLines; Quantity)
                {
                }
                column(UnitOnMeasure_ProcurementPlanLines; "Unit On Measure")
                {
                }
                column(UnitPrice_ProcurementPlanLines; "Unit Price")
                {
                }
                column(EstimatedCost_ProcurementPlanLines; "Estimated Cost")
                {
                }
                column(GLName_ProcurementPlanLines; "G/L Name")
                {
                }
                column(BudgetAmount_ProcurementPlanLines; "Budget Amount")
                {
                }
                column(CurrentBudget_ProcurementPlanLines; "Current Budget")
                {
                }
                column(ExpectedCompletionDate_ProcurementPlanLines; "Expected Completion Date")
                {
                }
                column(ProcurementType_ProcurementPlanLines; "Procurement Type")
                {
                }
                column(ProcurementMethod_ProcurementPlanLines; MethodOfProcurement)
                {
                }
                column(ProcurementSubType_ProcurementPlanLines; "Procurement Sub Type")
                {
                }
                column(SourceOfFunds_ProcurementPlanLines; "Source Of Funds")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    MethodOfProcurement := '';
                    IF ProcurementMethod.GET("Procurement Method") THEN
                        MethodOfProcurement := ProcurementMethod.Description;
                end;
            }
        }
        dataitem(DataItem11; "Dimension Value")
        {
            column(Code_DimensionValue; Code)
            {
            }
            column(Name_DimensionValue; Name)
            {
            }
            column(CaptionLbl; CaptionLbl)
            {
            }
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
        ReportTitle = 'Consolidated Procurement Plan';
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        Submitted: Boolean;
        DimensionValue: Record "Dimension Value";
        ProcurementMethod: Record "Procurement Method";
        MethodOfProcurement: Text;
        CaptionLbl: Label 'Consolidated Procurement Plan';
        CompanyInformation: Record "Company Information";
}

