page 50484 "Job Application List"
{
    // version TL2.0

    CardPageID = "Job Application Card";
    PageType = List;
    SourceTable = 50277;
    SourceTableView = WHERE(Status = FILTER('Application'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = All;
                }
                field("Recruitment Request No."; "Recruitment Request No.")
                {
                    ApplicationArea = All;
                }
                field("Job ID"; "Job ID")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("National ID/Passport No."; "National ID/Passport No.")
                {
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field(Email; Email)
                {
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("No. Years of Experience"; "No. Years of Experience")
                {
                    ApplicationArea = All;
                }
                field("Level of Education"; "Level of Education")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("View Applicants")
            {
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50484;
                Visible = false;
                ApplicationArea = All;
            }
        }
    }
}

