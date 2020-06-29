report 50501 "Submitted Procurement Plan"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Procurement\SubmittedProcurementPlan.rdlc';

    dataset
    {
        dataitem(DataItem1; "Procurement Plan Header")
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(No_ProcurementPlanHeader; "No.")
            {
            }
            column(GlobalDimension1Code_ProcurementPlanHeader; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_ProcurementPlanHeader; "Global Dimension 2 Code")
            {
            }
            column(Description_ProcurementPlanHeader; Description)
            {
            }
            column(Amount_ProcurementPlanHeader; Amount)
            {
            }
            column(CreatedBy_ProcurementPlanHeader; "Created By")
            {
            }
            column(CreatedOn_ProcurementPlanHeader; "Created On")
            {
            }
            column(Status_ProcurementPlanHeader; Status)
            {
            }
            column(CurrentBudget_ProcurementPlanHeader; "Current Budget")
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
            column(ViewQuarterlyDist; ViewQuarterlyDist)
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
                column(V1stQuarter_ProcurementPlanLines; "1st Quarter")
                {
                }
                column(V2ndQuarter_ProcurementPlanLines; "2nd Quarter")
                {
                }
                column(V3rdQuarter_ProcurementPlanLines; "3rd Quarter")
                {
                }
                column(V4thQuarter_ProcurementPlanLines; "4th Quarter")
                {
                }
                column(CaptionLbl; CaptionLbl)
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
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("View Quarterly Distribution"; ViewQuarterlyDist)
                {
                    Caption = 'View Quarterly Distribution';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
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
        CaptionLbl: Label 'Submitted Procurement Plan';
        CompanyInformation: Record "Company Information";
        ViewQuarterlyDist: Boolean;
}

