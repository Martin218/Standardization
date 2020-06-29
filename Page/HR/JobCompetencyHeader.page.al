page 50928 "Job Competency Header"
{
    // version TL2.0

    PageType = Card;
    SourceTable = 50284;


    layout
    {
        area(content)
        {
            group(General)
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
            part("Job Competency Lines"; 50529)
            {
                SubPageLink = "Entry No." = FIELD("Entry No.");
                ApplicationArea = all  ;
            }
        }
    }

    actions
    {
    }
}

