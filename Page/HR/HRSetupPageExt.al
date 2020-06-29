pageextension 50937 "HR Setup Page Ext" extends 5233

{
    layout
    {
        addafter("Employee Nos.")
        {
            field("Leave Nos."; "Leave Nos.")
            {

                ApplicationArea = All;
            }
            field("Training Nos."; "Training Nos.")
            {

                ApplicationArea = All;
            }
            field("Leave Plan Nos."; "Leave Plan Nos.")
            {

                ApplicationArea = All;
            }
            field("Staff Transfer Nos."; "Staff Transfer Nos.")
            {

                ApplicationArea = All;
            }
            field("Recruitment Needs Nos."; "Recruitment Needs Nos.")
            {

                ApplicationArea = All;
            }
            field("Job Application Nos."; "Job Application Nos.")
            {

                ApplicationArea = All;
            }
            field("Separation No"; "Separation No")
            {

                ApplicationArea = All;
            }
            field("Disciplinary Cases Nos."; "Disciplinary Cases Nos.")
            {

                ApplicationArea = All;
            }
            field("Evaluation No."; "Evaluation No.")
            {

                ApplicationArea = All;
            }
            field("Permanent Probation"; "Permanent Probation")
            {

                ApplicationArea = All;
            }
            field("Intern Probation"; "Intern Probation")
            {

                ApplicationArea = All;
            }
            field("Contract Probation"; "Contract Probation")
            {

                ApplicationArea = All;
            }
            field("Performance Review Nos."; "Performance Review Nos.")
            {

                ApplicationArea = All;
            }
            field("Leave Recall Nos."; "Leave Recall Nos.")
            {

                ApplicationArea = All;
            }
            field("Employee Docs File Path"; "Employee Docs File Path")
            {

                ApplicationArea = All;
            }
            field("HR E-Mail"; "HR E-Mail")
            {

                ApplicationArea = All;
            }

        }

    }
    actions
    {
        modify("Human Res. Units of Measure")
        {
            Visible = false;
        }
        modify("Causes of Absence")
        {
            Visible = false;
        }
        modify("Causes of Inactivity")
        {
            Visible = false;
        }
        modify(Unions)
        {
            Visible = false;
        }
        modify("Misc. Articles")
        {
            Visible = false;
        }
        modify(Confidential)
        {
            Visible = false;
        }
        modify("Employee Statistics Groups")
        {
            Visible = false;
        }
        addbefore("Grounds for Termination")
        {
            action("Leave Types")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Leave Types";
                ApplicationArea = All;
            }
        }
        addafter("Leave Types")
        {
            action("Leave Period")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Leave Periods";
                ApplicationArea = All;
            }
        }
        addafter("Leave Period")
        {
            action("Evaluation Question")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Training Evaluation Questions";
                ApplicationArea = All;
            }
        }
        addafter("Evaluation Question")
        {
            action("Evaluation Option Set")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Option Set";
                ApplicationArea = All;
            }
        }
        addafter("Evaluation Option Set")
        {
            action("Training Cost")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Training Cost Setup";
                ApplicationArea = All;
            }
        }
        addafter("Training Cost")
        {
            action("Appraisal Periods")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Appraisal Periods";
                ApplicationArea = All;
            }
        }
        addafter("Appraisal Periods")
        {
            action(Grades)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Employee Grades";
                ApplicationArea = All;
            }
        }
        addafter(Grades)
        {
            action("Saparation Types")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Separation Type Setup";
                ApplicationArea = All;
            }
        }
    }
}