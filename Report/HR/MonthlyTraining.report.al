report 50277 "Monthly Staff Training Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Monthly Staff Training Report.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem12; 50235)
        {
            DataItemTableView = WHERE("Employee No." = FILTER(<> ''));
            column(EmployeeNo_HRTrainingRequestLines; "Employee No.")
            {
            }
            column(EmployeeName_HRTrainingRequestLines; "Employee Name")
            {
            }
            column(DailyTransport_HRTrainingRequestLines; "Other Costs")
            {
            }
            column(Transport_HRTrainingRequestLines; "Training Cost")
            {
            }
            column(JobTitle_HRTrainingRequestLines; "Job Title")
            {
            }
            column(EmploymentDate_HRTrainingRequestLines; "Employment Date")
            {
            }
            column(ConfirmationDate_HRTrainingRequestLines; "Confirmation Date")
            {
            }
            column(Grade_HRTrainingRequestLines; Grade)
            {
            }
            column(TransportToFromBranch_HRTrainingRequestLines; "Training Cost")
            {
            }
            column(NightOutAllowance_HRTrainingRequestLines; "Total Cost")
            {
            }
            column(Branch_TrainingRequestLine; Branch)
            {
            }
            column(Department_TrainingRequestLine; Department)
            {
            }

            column(TrainingCost_HRTrainingRequestLines; "Training Cost")
            {
            }
            column(TotalCost_HRTrainingRequestLines; Cost)
            {
            }
            column(EmploymentStatus_HRTrainingRequestLines; "Employment Status")
            {
            }

            column(TrainingRequestNo_TrainingRequestLine; "Training Request No.")
            {
            }
            column(TotalCost_TrainingRequestLine; Cost)
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
            column(sumamount; sumamount)
            {
            }
            dataitem(DataItem1; 50234)
            {
                DataItemLink = "No." = FIELD("Training Request No.");
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending);
                // RequestFilterFields = '';
                column(No_TrainingRequest; "No.")
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
                column(Duration_TrainingRequest; Duration)
                {
                }
                column(DurationUnits_TrainingRequest; "Duration Units")
                {
                }
                column(StartDate_TrainingRequest; "Start Date")
                {
                }
                column(EndDate_TrainingRequest; "End Date")
                {
                }
                column(CostofTraining_TrainingRequest; "Cost of Training")
                {
                }
                column(TotalCostofTraining_TrainingRequest; "Total Cost of Training")
                {
                }
                column(HeaderText; HeaderText)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF Status <> Status::Released THEN
                        CurrReport.SKIP;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                TrainingRequest.RESET;
                TrainingRequest.SETRANGE("No.", "Training Request No.");
                TrainingRequest.SETRANGE(Status, TrainingRequest.Status::Released);
                IF NOT TrainingRequest.FINDFIRST THEN
                    CurrReport.SKIP;

                serialno += 1;
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
        HeaderText: Label 'Monthly Staff Training Report';
        TrainingRequest: Record 50234;
}

