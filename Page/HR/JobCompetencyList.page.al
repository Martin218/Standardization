page 50930 "Job Competency List"
{
    // version TL2.0

    CardPageID = "Job Competency Header";
    PageType = List;
    SourceTable = 50284;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal Year"; "Appraisal Year")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Period"; "Appraisal Period")
                {
                    ApplicationArea = All;
                }
                field("Department Code"; "Department Code")
                {
                    ApplicationArea = All;
                }
                field("Job Code"; "Job Code")
                {
                    ApplicationArea = All;
                }
                field("Job Description"; "Job Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

