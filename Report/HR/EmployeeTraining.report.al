report 50275 "Employee Training Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Employee Training Report.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem8; 5200)
        {
            column(No_Employee; "No.")
            {
            }
            column(JobTitle_Employee; "Job Title")
            {
            }
            column(BranchName_Employee; "Branch Name")
            {
            }
            column(EmploymentDate_Employee; "Employment Date")
            {
            }
            column(DepartmentName_Employee; "Department Name")
            {
            }
            column(Name; Name)
            {
            }
            dataitem(DataItem12; 50235)
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = SORTING("Training Request No.", "Employee No.")
                                    ORDER(Ascending);
                column(DailyTransport_HRTrainingRequestLines; "Other Costs")
                {
                }
                column(Transport_HRTrainingRequestLines; "Training Cost")
                {
                }
                column(TransportToFromBranch_HRTrainingRequestLines; "Training Cost")
                {
                }
                column(NightOutAllowance_HRTrainingRequestLines; "Total Cost")
                {
                }

                column(TrainingCost_HRTrainingRequestLines; "Training Cost")
                {
                }
                column(TotalCost_HRTrainingRequestLines; Cost)
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
                column(EmploymentStatus_HRTrainingRequestLines; "Employment Status")
                {
                }

                column(sumamount; sumamount)
                {
                }
                dataitem(DataItem1; 50234)
                {
                    DataItemLink = "No." = FIELD("Training Request No.");
                    DataItemTableView = SORTING("No.")
                                        ORDER(Ascending);
                    //  RequestFilterFields = '';
                    column(No_TrainingRequest; "No.")
                    {
                    }
                    column(RequestDate_TrainingRequest; "Request Date")
                    {
                    }
                    column(TrainingDescription_TrainingRequest; "Training Description")
                    {
                    }
                    column(CourseSeminarName_TrainingRequest; "Course/Seminar Name")
                    {
                    }
                    column(TrainingInstitution_TrainingRequest; "Training Institution")
                    {
                    }
                    column(Venue_TrainingRequest; Venue)
                    {
                    }
                    column(StartDate_TrainingRequest; "Start Date")
                    {
                    }
                    column(EndDate_TrainingRequest; "End Date")
                    {
                    }
                    column(Location_TrainingRequest; Location)
                    {
                    }
                    column(CostofTraining_TrainingRequest; "Cost of Training")
                    {
                    }
                    column(HeaderText; HeaderText)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        IF "Course/Seminar Name" = ' ' THEN BEGIN
                            CurrReport.SKIP;
                        END;

                        IF Status <> Status::Released THEN BEGIN
                            CurrReport.SKIP;
                        END;
                        serialno += 1;
                    end;
                }
            }

            trigger OnAfterGetRecord();
            begin
                Name := FullName;
                serialno := 0;

                HRTrainingRequestLines.RESET;
                HRTrainingRequestLines.SETRANGE("Employee No.", "No.");
                IF NOT HRTrainingRequestLines.FINDSET THEN
                    CurrReport.SKIP;
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
        CompanyInformation.GET;
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record 79;
        serialno: Integer;
        sumamount: Decimal;
        HRTrainingRequestLines: Record 50235;
        HeaderText: Label 'Employee Training Report';
        Name: Text;
}

