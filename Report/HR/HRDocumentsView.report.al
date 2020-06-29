report 50261 "HR Documents View"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\HR Documents View.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50227)
        {
            column(User_HRDocumentView; User)
            {
            }
            column(DocumentName_HRDocumentView; "Document Name")
            {
            }
            column(Date_HRDocumentView; Date)
            {
            }
            column(Picture; CompanyInformation.Picture)
            {
            }
            column(Name; CompanyInformation.Name)
            {
            }
            column(Address; CompanyInformation.Address)
            {
            }
            column(EmployeeNo; Empno)
            {
            }
            column(EmployeeName; Name)
            {
            }
            column(JobTitle; Jobtitle)
            {
            }
            column(SerialNo; "SerialNo.")
            {
            }
            column(ViewDate_HRDocumentView; "View Date")
            {
            }

            trigger OnAfterGetRecord();
            begin
                Empno := '';
                Jobtitle := '';
                Name := '';
                CompanyInformation.RESET;
                CompanyInformation.CALCFIELDS(Picture);
                UserSetup.RESET;
                UserSetup.SETRANGE("User ID", HRDocumentView.User);
                IF UserSetup.FIND('-') THEN BEGIN
                    Employee.RESET;
                    // Employee.SETRANGE("No.", UserSetup."Employee No.");
                    IF Employee.FIND('-') THEN BEGIN
                        Empno := Employee."No.";
                        Name := Employee."Search Name";
                        Jobtitle := Employee."Job Title";

                    END;
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

    trigger OnInitReport();
    begin
        "SerialNo." += 1;
    end;

    var
        CompanyInformation: Record 79;
        UserSetup: Record 91;
        "SerialNo.": Integer;
        Empno: Code[80];
        Name: Text[150];
        Jobtitle: Text[100];
        HRDocumentView: Record 50227;
        Employee: Record 5200;
}

