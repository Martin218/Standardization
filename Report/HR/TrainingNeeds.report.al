report 50273 "Training Needs"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Training Needs.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1000000000; 50234)
        {
            column(serialnumber; serialno)
            {
            }
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
            column(Location_TrainingRequest; Location)
            {
            }
            column(CostofTraining_TrainingRequest; "Cost of Training")
            {
            }
            column(TotalCostofTraining_TrainingRequest; "Total Cost of Training")
            {
            }
            column(ReasonforRequest_TrainingRequest; "Reason for Request")
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(RequestedBy_TrainingRequest; "Requested By")
            {
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
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record 79;
        serialno: Integer;
        HeaderText: Label 'Training Needs Report';
}

