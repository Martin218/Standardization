report 50274 "Staff Trained"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Staff Trained.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50234)
        {
            DataItemTableView = WHERE(Status = FILTER(Released));
            PrintOnlyIfDetail = true;
            // RequestFilterFields = '';
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
            dataitem(DataItem12; 50235)
            {
                DataItemLink = "Training Request No." = FIELD("No.");
                column(EmployeeNo_HRTrainingRequestLines; "Employee No.")
                {
                }
                column(EmployeeName_HRTrainingRequestLines; "Employee Name")
                {
                }
                column(OtherCosts_HRTrainingRequestLines; "Other Costs")
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
                column(TotalCost_HRTrainingRequestLines; "Total Cost")
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
                column(EmploymentStatus_HRTrainingRequestLines; "Employment Status")
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
                column(serialno; serialno)
                {
                }
                column(sumamount; sumamount)
                {
                }
                column(CompanyInformation_Picture; CompanyInformation.Picture)
                {
                }
                column(HeaderText; HeaderText)
                {
                }
                column(TrainingRequestNo_TrainingRequestLine; "Training Request No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    HRTrainingRequestLines.RESET;
                    HRTrainingRequestLines.SETRANGE("Training Request No.", HRTrainingRequestLines."Training Request No.");
                    IF HRTrainingRequestLines.FIND('-') THEN BEGIN
                        sumamount += HRTrainingRequestLines.Cost;
                    END;
                end;
            }

            trigger OnAfterGetRecord();
            begin
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
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record 79;
        serialno: Integer;
        sumamount: Decimal;
        HRTrainingRequestLines: Record 50235;
        HeaderText: Label 'Staff Trained Report';
}

