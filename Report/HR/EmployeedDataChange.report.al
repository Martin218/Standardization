report 50271 "Employee Data Change Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Employee Data Change Report.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 405)
        {
            DataItemTableView = WHERE("Table No." = FILTER(5200));
            column(DateandTime_ChangeLogEntry; "Date and Time")
            {
            }
            column(UserID_ChangeLogEntry; "User ID")
            {
            }
            column(TableCaption_ChangeLogEntry; "Table Caption")
            {
            }
            column(FieldCaption_ChangeLogEntry; "Field Caption")
            {
            }
            column(TypeofChange_ChangeLogEntry; "Type of Change")
            {
            }
            column(OldValue_ChangeLogEntry; "Old Value")
            {
            }
            column(NewValue_ChangeLogEntry; "New Value")
            {
            }
            column(PrimaryKeyField1No_ChangeLogEntry; "Primary Key Field 1 No.")
            {
            }
            column(PrimaryKeyField1Caption_ChangeLogEntry; "Primary Key Field 1 Caption")
            {
            }
            column(PrimaryKeyField1Value_ChangeLogEntry; "Primary Key Field 1 Value")
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_PostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(serialno; serialno)
            {
            }
            column(Name; Name)
            {
            }

            trigger OnAfterGetRecord();
            begin
                serialno += 1;
                Name := '';
                IF "Primary Key Field 1 Value" <> '' THEN BEGIN
                    IF Employee.GET("Primary Key Field 1 Value") THEN
                        Name := Employee."Search Name";
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
    }

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
        serialno := 0;
    end;

    var
        CompanyInformation: Record 79;
        serialno: Integer;
        Employee: Record 5200;
        Name: Text;
}

