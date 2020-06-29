report 50508 "Store Issuance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Procurement\StoreIssuanceReport.rdlc';

    dataset
    {
        dataitem(DataItem1; "Requisition Header")
        {
            DataItemTableView = WHERE("Requisition Type" = FILTER('Store Requisition'),
                                      Status = FILTER(Issued | 'Pending Return' | Returned));
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
            column(IssueDate_RequisitionHeader; "Issue Date")
            {
            }
            column(IssuedBy_RequisitionHeader; "Issued By")
            {
            }
            column(ReturnDate_RequisitionHeader; "Return Date")
            {
            }
            column(ReturnReceivedBy_RequisitionHeader; "Return Received By")
            {
            }
            column(StoreReturnNo_RequisitionHeader; "Store Return No.")
            {
            }
            column(Status_RequisitionHeader; Status)
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
        ReportTitle = 'Store Issuance Report';
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
}

