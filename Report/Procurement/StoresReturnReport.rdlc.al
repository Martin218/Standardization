report 50507 "Stores Return Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Procurement\StoresReturnReport.rdlc';

    dataset
    {
        dataitem(DataItem1; "Requisition Header")
        {
            DataItemTableView = WHERE("Requisition Type" = FILTER('Store Return'));
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
            column(IssueDate_RequisitionHeader; IssuedOnDate)
            {
            }
            column(IssuedBy_RequisitionHeader; IssuedByUser)
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
            column(StoreRequisitionNo_RequisitionHeader; "Store Requisition No.")
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
                column(QuantityReturned_RequisitionHeaderLine; "Quantity Returned")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                IssuedByUser := '';
                IssuedOnDate := 0D;
                IF RequisitionHeader.GET("Store Requisition No.") THEN BEGIN
                    IssuedByUser := RequisitionHeader."Issued By";
                    IssuedOnDate := RequisitionHeader."Issue Date";
                END;
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
        ReportTitle = 'Stores Return Report';
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        RequisitionHeader: Record "Requisition Header";
        IssuedOnDate: Date;
        IssuedByUser: Code[80];
}

