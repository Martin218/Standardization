page 50936 "HR Role Centre"
{
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {


        }
    }

    actions
    {
        area(Creation)
        {

            action("Create New Employee")
            {
                RunObject = Page "Employee List";
                ApplicationArea = All;
            }
            action("Leave Application")
            {
                RunObject = Page "Leave Application List";
                ApplicationArea = All;
            }
            action("Leave Journal")
            {
                RunObject = page "Leave Journal";
                ApplicationArea = All;
            }
            action("Leave Plan")
            {
                RunObject = Page "Employee Leave Plan List";
                ApplicationArea = All;
            }
        }
        area(Sections)
        {
            group("Employee Management")
            {
                action("Employee List")
                {
                    RunObject = page "Employee List";
                    ApplicationArea = All;
                }
                action("Employee Relatives")
                {
                    RunObject = page "Employee Relatives";
                    ApplicationArea = All;
                }
                group("Employee Reports")
                {
                    action("Employee Report")
                    {
                        RunObject = report "Employee Report";
                        ApplicationArea = All;
                    }
                    action("Report Per Employee")
                    {
                        RunObject = report "Report Per Employee";
                        ApplicationArea = All;
                    }
                }
            }
            group("Probation Management")
            {
                action("Employees On Probation")
                {
                    RunObject = page "Employees On Probation";

                    ApplicationArea = All;
                }
                action("Employees Due For Confirmation")
                {
                    RunObject = page "Employees Due For Confirmation";
                    ApplicationArea = All;
                }

                action("Confirmed Employees")
                {
                    RunObject = page "Confirmed Employees";

                    ApplicationArea = All;
                }
                group("Probation Reports")
                {
                    action("Reference Check Report")
                    {
                        RunObject = report "Reference Check Report";
                        ApplicationArea = All;
                    }
                    action("Confirmed Employee Report")
                    {
                        RunObject = report "Confirmed Employee Report";
                        ApplicationArea = All;
                    }
                }
            }
            group("Leave Management")
            {
                group("Leave Applications")
                {
                    action("Leave Application List")
                    {
                        RunObject = Page "Leave Application List";
                        ApplicationArea = All;
                    }
                    action("Leave Application Pending Approval")
                    {
                        RunObject = page "Leave App. Pending Approval";
                        ApplicationArea = All;
                    }
                    action("Approved Leave")
                    {
                        RunObject = Page "Approved Leave Application";
                        ApplicationArea = All;
                    }
                    action("Rejected Leave")
                    {
                        RunObject = Page "Rejected  Leave Application";
                        ApplicationArea = All;
                    }
                    action("Leave Ledger Entry")
                    {
                        RunObject = page "Leave Ledger Entry";
                        ApplicationArea = All;
                    }
                }
                group("Employee Leave Plan")
                {
                    action("Create Leave Plan")
                    {
                        RunObject = Page "Employee Leave Plan List";
                        ApplicationArea = All;
                    }
                    action("Submitted Leave Plan")
                    {
                        RunObject = page "Submitted Leave Plan";
                        ApplicationArea = All;
                    }
                }

                group("Leave Recalls")
                {
                    action("Leave Recall")
                    {
                        RunObject = Page "Leave Recalls List";
                        ApplicationArea = All;
                    }
                    action("Submitted Leave Recall")
                    {
                        RunObject = page "Submitted Leave Recalls";
                        ApplicationArea = All;
                    }

                }
                group(Setups)
                {
                    action("Human Resources Setup")
                    {
                        RunObject = page "Human Resources Setup";
                        ApplicationArea = All;
                    }
                    action("Leave Types Setup")
                    {
                        RunObject = page "Leave Types";
                        ApplicationArea = All;
                    }
                    action("Training Evaluation Question")
                    {
                        RunObject = page "Select Evaluation Questions";
                        ApplicationArea = All;
                    }

                }
                group("Leave Reports")
                {
                    action("Leave Balance Report")
                    {
                        RunObject = report "Leave Balance";
                        ApplicationArea = All;
                    }

                    action("Leave Balance Quarterly")
                    {
                        RunObject = report "Leave Balance Quarterly";
                        ApplicationArea = All;
                    }

                    action("Leave Recall Report")
                    {
                        RunObject = report "Leave Recall Report";
                        ApplicationArea = All;
                    }

                    action("Leave Calender Plan Report")
                    {
                        RunObject = report "Leave Calendar Plan";
                        ApplicationArea = All;
                    }

                    action("Leave Utilization Report")
                    {
                        RunObject = report "Leave Utilization Report";

                        ApplicationArea = All;
                    }

                }
            }

            group("Staff Movements")
            {
                action("Staff Movement")
                {
                    RunObject = page "Employee Movement List";
                    ApplicationArea = All;
                }
                action("Posted Staff Movement")
                {
                    RunObject = page "Posted Employee Movement";
                    ApplicationArea = All;
                }
                group("Staff Movement Reports")
                {
                    action("Staff Posting")
                    {
                        RunObject = report "Staff Postings";
                        ApplicationArea = All;
                    }
                    action("Staff Transfer")
                    {
                        RunObject = report "Staff Transfers";
                        ApplicationArea = All;
                    }
                    action("Staff Promotions")
                    {
                        RunObject = report "Staff Promotions";
                        ApplicationArea = All;
                    }

                }
            }
            group("Job Management")
            {
                action("Job List")
                {
                    RunObject = page "Position List";
                    ApplicationArea = All;
                }

                action("Job Report")
                {
                    RunObject = report Positions;
                    ApplicationArea = All;
                }
                action("Job Description")
                {
                    RunObject = report "Job Description";
                    ApplicationArea = All;
                }
            }
            group("Training Management")
            {
                group("Training Requests")
                {
                    action("Employee Training Requests")
                    {
                        RunObject = page "Training Request List";
                        ApplicationArea = All;
                    }
                    action("Submitted Training Requests")
                    {
                        RunObject = page "Submitted Training Requests";
                        ApplicationArea = All;
                    }
                    action("Training Calendar")
                    {
                        RunObject = page "Training Calendar";
                        ApplicationArea = All;
                    }
                    action("Training Requests Pending Approval")
                    {
                        RunObject = page "Training Req. Pending Approval";
                        ApplicationArea = All;
                    }
                    action("Approved Training Requests")
                    {
                        RunObject = page "Approved Training Requests";
                        ApplicationArea = All;
                    }
                }
                group("Training Evaluation")
                {
                    action("Employee Training Evaluation")
                    {
                        RunObject = page "Employee Training Eval. List";
                        ApplicationArea = All;
                    }
                    action("Submitted Training Evaluation")
                    {
                        RunObject = page "Submitted Employee Eval.";
                        ApplicationArea = All;
                    }
                }
                group("Training Reports")
                {
                    action("Training Needs Report")
                    {
                        RunObject = report "Training Needs";
                        ApplicationArea = All;
                    }
                    action("Staff Trained Report")
                    {
                        RunObject = report "Staff Trained";

                        ApplicationArea = All;
                    }
                    action("Employee Training Report")
                    {
                        RunObject = report "Employee Training Report";
                        ApplicationArea = All;
                    }
                    action("Monthly Staff Training Report")
                    {
                        RunObject = report "Monthly Staff Training Report";
                        ApplicationArea = All;
                    }
                    action("Annual Staff Training Report")
                    {
                        RunObject = report "Annual Staff Training Report";
                        ApplicationArea = All;
                    }
                }
            }
            group("Separation Management")
            {
                action("Separation Application")
                {
                    RunObject = page "Separation List";
                    ApplicationArea = All;
                }
                action("Processed Separations")
                {
                    RunObject = page "Approved Separation List";
                    ApplicationArea = All;
                }
                action("Separation Types Setup")
                {
                    RunObject = page "Separation Type Setup";
                    ApplicationArea = All;
                }
            }
            group("Recruitment & Selection")
            {
                group("Recruitement Request")
                {
                    action("Recruitment Request")
                    {
                        RunObject = page "Recruitment List";
                        ApplicationArea = All;
                    }
                    action("Recruitment Request Pending Approval")
                    {
                        RunObject = page "Recruitment Pending Approval";
                        ApplicationArea = All;
                    }
                    action("Recruitment Request Approved")
                    {
                        RunObject = page RecruitmentApproved;
                        ApplicationArea = All;
                    }
                    action("Recruitment Request Rejected")
                    {
                        RunObject = page "Recruitment Rejected";
                        ApplicationArea = All;
                    }
                }
                group("Job Applications")
                {
                    action("Job Application List")
                    {
                        RunObject = page "Job Application List";
                        ApplicationArea = All;
                    }
                    action("Shortlisted Job Applications")
                    {
                        RunObject = page "Short Listed Job Application";
                        ApplicationArea = All;
                    }
                    action("Recruitment Report")
                    {
                        RunObject = report "Recruitment Report";
                        ApplicationArea = All;
                    }
                }
            }
            group("Performance Management")
            {
                action("Performance Competency")
                {
                    RunObject = page "Performance Competency";
                    ApplicationArea = All;
                }
                action("Job Competency")
                {
                    RunObject = page "Job Competency List";
                    ApplicationArea = All;
                }
                action("Performance Review")
                {
                    RunObject = page "Performance Review List";
                    ApplicationArea = All;
                }
                action("Appraiser's Review List")
                {
                    RunObject = page "Appraiser's Review List";
                    ApplicationArea = All;
                }
                action("Performance Review HR")
                {
                    RunObject = page "Performance Review HR List";
                    ApplicationArea = All;
                }
            }
            group("Disciplinary Management")
            {
                action("Disciplinary Cases")
                {
                    RunObject = page "Disciplinary Case List";
                    ApplicationArea = All;
                }

                action("Current Cases")
                {
                    RunObject = page "Current Cases";
                    ApplicationArea = All;
                }

                action("Legal Cases")
                {
                    RunObject = page "Legal Cases";
                    ApplicationArea = All;
                }

                action("Closed Cases")
                {
                    RunObject = page "Closed Cases";
                    ApplicationArea = All;
                }
                action("Appealed Cases")
                {
                    RunObject = page "Appealed Cases";
                    ApplicationArea = All;
                }
            }
            group(Audit)
            {
                group("HR Audit")
                {
                    action("Employee Data Change Request")
                    {
                        RunObject = page "Employee Data Change Request";
                        ApplicationArea = All;
                    }
                    action("Employee Data View")
                    {
                        RunObject = page "Employee Data View List";
                        ApplicationArea = All;
                    }
                    action("Employee Data Changes")
                    {
                        RunObject = page "Employee Data Changes";
                        ApplicationArea = All;
                    }
                }
                group("Audit Reports")
                {
                    action("Employee Data Change Report")
                    {
                        RunObject = report "Employee Data Change Report";
                        ApplicationArea = All;
                    }
                }
                action("Employee Data Changes Approval")
                {
                    RunObject = report "Employee Data Changes Approval";
                    ApplicationArea = All;
                }
            }
            group("HR Documents")
            {
                action("Documents")
                {
                    RunObject = page "Human Resource Doc";
                    ApplicationArea = All;
                }
                group(Reports)
                {
                    action("HR Uploaded Documents")
                    {
                        RunObject = report "HR Documents Report";
                        ApplicationArea = All;
                    }
                    action("HR Documents View")
                    {
                        RunObject = report "HR Documents View";
                        ApplicationArea = All;
                    }
                }
            }



        }



    }
}