report 50270 Positions
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Positions.rdlc';
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
            column(Grade_Position; Grade)
            {
            }
            column(NoofPosts_Position; "No. of Posts")
            {
            }
            column(OccupiedPositions_Position; "Occupied Positions")
            {
            }
            column(VacantPositions_Position; "Vacant Positions")
            {
            }
            column(Active_Position; Active)
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
            column(HeaderTxt000; HeaderTxt000)
            {
            }
            column(HeaderTxt001; HeaderTxt001)
            {
            }
            column(HeaderTxt002; HeaderTxt002)
            {
            }
            column(HeaderTxt003; HeaderTxt003)
            {
            }
            dataitem(DataItem11; 50232)
            {
                DataItemLink = "Position Code" = FIELD(Code);
                column(PositionCode_PositionQualification; "Position Code")
                {
                }
                column(QualificationType_PositionQualification; "Qualification Type")
                {
                }
                column(QualificationCode_PositionQualification; "Qualification Code")
                {
                }
                column(Description_PositionQualification; Description)
                {
                }
                column(Priority_PositionQualification; Priority)
                {
                }
            }
            dataitem(DataItem16; 50233)
            {
                DataItemLink = "Position Code" = FIELD(Code);
                column(PositionCode_PositionResponsibility; "Position Code")
                {
                }
                column(Responsibility_PositionResponsibility; Responsibility)
                {
                }
                column(Remarks_PositionResponsibility; Remarks)
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
        HeaderTxt000: Label 'Job Report';
        HeaderTxt001: Label 'General Details';
        HeaderTxt002: Label 'Job Qualifications';
        HeaderTxt003: Label 'Job Responsibilities';
}

