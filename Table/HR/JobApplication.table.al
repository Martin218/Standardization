table 50277 "Job Application"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Application Date"; Date)
        {
        }
        field(3; "Recruitment Request No."; Code[20])
        {
            TableRelation = "Recruitment Request"."Recruitment Needs Code" WHERE(Status = FILTER(Released));

            trigger OnValidate();
            begin
                IF RecruitmentRequest.GET("Recruitment Request No.") THEN BEGIN
                    "Job ID" := RecruitmentRequest."Job ID";
                    "Job Title" := RecruitmentRequest."Job Title Request";

                END;
            end;
        }
        field(4; "Job ID"; Code[20])
        {
        }
        field(5; "Job Title"; Text[100])
        {
        }
        field(6; Name; Text[100])
        {
        }
        field(7; "National ID/Passport No."; Text[30])
        {
        }
        field(8; Gender; Option)
        {
            OptionCaption = ',Male,Female,Other';
            OptionMembers = ,Male,Female,Other;
        }
        field(9; Email; Text[30])
        {
        }
        field(10; "Mobile Phone No."; Text[30])
        {
        }
        field(11; Status; Option)
        {
            OptionCaption = 'Application,Shortlisted,Aptitude Test,Interview,Passed,Rejected';
            OptionMembers = Application,Shortlisted,"Aptitude Test",Interview,Passed,Rejected;
        }
        field(12; "No. Years of Experience"; Decimal)
        {
        }
        field(13; "Level of Education"; Code[20])
        {
            TableRelation = Qualification WHERE("Qualification Type" = FILTER('Academic'));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        HumanResourcesSetup.GET;
        "No." := NoSeriesManagement.GetNextNo(HumanResourcesSetup."Job Application Nos.", 0D, TRUE);
    end;

    var
        HumanResourcesSetup: Record 5218;
        NoSeriesManagement: Codeunit 396;
        RecruitmentRequest: Record 50246;
}

