report 50281 "Employee Data Changes Approval"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Employee Data Changes Approval.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50245)
        {
            RequestFilterFields = "Employee No", "Change Date", Status, "Approval Date";
            column(EntryNo_EmployeeHRAuditTrail; "Entry No.")
            {
            }
            column(UserID_EmployeeHRAuditTrail; "User ID")
            {
            }
            column(Type_EmployeeHRAuditTrail; Type)
            {
            }
            column(EmployeeNo_EmployeeHRAuditTrail; "Employee No")
            {
            }
            column(EmployeeName_EmployeeHRAuditTrail; "Employee Name")
            {
            }
            column(FieldCaption_EmployeeHRAuditTrail; "Field Caption")
            {
            }
            column(OldValue_EmployeeHRAuditTrail; "Old Value")
            {
            }
            column(NewValue_EmployeeHRAuditTrail; "New Value")
            {
            }
            column(ChangeDate_EmployeeHRAuditTrail; "Change Date")
            {
            }
            column(ChangeTime_EmployeeHRAuditTrail; "Change Time")
            {
            }
            column(Status_EmployeeHRAuditTrail; Status)
            {
            }
            column(Approver_EmployeeHRAuditTrail; Approver)
            {
            }
            column(ApprovalDate_EmployeeHRAuditTrail; "Approval Date")
            {
            }
            column(ApprovalTime_EmployeeHRAuditTrail; "Approval Time")
            {
            }
            column(ChangeType_EmployeeHRAuditTrail; "Change Type")
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(CompanyInformation_PostCode; CompanyInformation."Post Code")
            {
            }
            column(HeaderText; HeaderText)
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
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record 79;
        HeaderText: Label 'Employee Data Changes Approval';
}

