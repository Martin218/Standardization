report 50506 "Purchase Requisitions Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Procurement\PurchaseRequisitionsReport.rdlc';

    dataset
    {
        dataitem(DataItem1; "Requisition Header")
        {
            DataItemTableView = WHERE("Requisition Type" = FILTER('Purchase Requisition'));
            RequestFilterFields = "Global Dimension 1 Code", "Global Dimension 2 Code", "Requested By", "Employee Code", Status;
            column(No_RequisitionHeader; "No.")
            {
            }
            column(EmployeeCode_RequisitionHeader; "Employee Code")
            {
            }
            column(EmployeeName_RequisitionHeader; "Employee Name")
            {
            }
            column(Description_RequisitionHeader; Description)
            {
            }
            column(RequisitionDate_RequisitionHeader; "Requisition Date")
            {
            }
            column(RequestedBy_RequisitionHeader; "Requested By")
            {
            }
            column(GlobalDimension1Code_RequisitionHeader; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_RequisitionHeader; "Global Dimension 2 Code")
            {
            }
            column(ProcurementPlan_RequisitionHeader; "Procurement Plan")
            {
            }
            column(Status_RequisitionHeader; Status)
            {
            }
            column(ProcurementProcessInitiated_RequisitionHeader; "Procurement Process Initiated")
            {
            }
            column(ProcurementProcessNo_RequisitionHeader; "Procurement Process No.")
            {
            }
            column(ProcurementMethod_RequisitionHeader; ProcurementMethodTxt)
            {
            }
            column(Company_Name; CompanyInformation.Name)
            {
            }
            column(Company_Address; CompanyInformation.Address)
            {
            }
            column(Company_City; CompanyInformation.City)
            {
            }
            column(Company_Pic; CompanyInformation.Picture)
            {
            }
            column(Company_County; CompanyInformation.County)
            {
            }
            column(Company_Postal; CompanyInformation."Post Code")
            {
            }
            dataitem(DataItem16; "Requisition Header Line")
            {
                DataItemLink = "Requisition No." = FIELD("No.");
                column(Type_RequisitionHeaderLine; Type)
                {
                }
                column(No_RequisitionHeaderLine; No)
                {
                }
                column(Description_RequisitionHeaderLine; Description)
                {
                }
                column(Quantity_RequisitionHeaderLine; Quantity)
                {
                }
                column(UnitofMeasure_RequisitionHeaderLine; "Unit of Measure")
                {
                }
                column(UnitPrice_RequisitionHeaderLine; "Unit Price")
                {
                }
                column(Amount_RequisitionHeaderLine; Amount)
                {
                }
                column(ProcurementPlan_RequisitionHeaderLine; "Procurement Plan")
                {
                }
                column(ProcurementPlanItem_RequisitionHeaderLine; "Procurement Plan Item")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                ProcurementMethodTxt := '';
                IF "Procurement Method" <> '' THEN
                    IF ProcurementMethod.GET("Procurement Method") THEN
                        ProcurementMethodTxt := ProcurementMethod.Description;
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
        ReportTitle = 'Purchase Requisition Report';
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        ProcurementMethodTxt: Text;
        ProcurementMethod: Record "Procurement Method";
}

