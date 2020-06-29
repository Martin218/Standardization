report 50285 "Job Description"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Job Description.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50230)
        {
            column(Code_Position; Code)
            {
            }
            column(JobTitle_Position; "Job Title")
            {
            }
            column(ReportingTo_Position; "Reporting To")
            {
            }
            column(Department_Position; Department)
            {
            }
            column(JobDescription_Position; "Job Description")
            {
            }
            column(JobKPIs_Position; "Job KPI's")
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(HeaderTxt; HeaderTxt)
            {
            }
            dataitem(DataItem9; 50233)
            {
                DataItemLink = "Position Code" = FIELD(Code);
                DataItemTableView = SORTING("Entry No.", "Position Code");
                column(Responsibility_PositionResponsibility; Responsibility)
                {
                }
                column(PositionCode_PositionResponsibility; "Position Code")
                {
                }
            }
            dataitem(DataItem14; 50232)
            {
                DataItemLink = "Position Code" = FIELD(Code);
                DataItemTableView = SORTING("Entry No.", "Position Code");
                column(QualificationType_PositionQualification; "Qualification Type")
                {
                }
                column(QualificationCode_PositionQualification; "Qualification Code")
                {
                }
                column(Description_PositionQualification; Description)
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
        HeaderTxt: Label 'Job Description';
}

