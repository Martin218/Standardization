page 50420 "Disciplinary Case List"
{
    // version TL2.0

    CardPageID = "Disciplinary Cases Card";
    PageType = List;
    SourceTable = 50215;
    SourceTableView = WHERE("Case Status" = filter('New'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Case No"; "Case No")
                {
                    ApplicationArea = All;
                }
                field("Case Description"; "Case Description")
                {
                    ApplicationArea = All;
                }
                field("Date of the Case"; "Date of the Case")
                {
                    ApplicationArea = All;
                }
                field("Offense Type"; "Offense Type")
                {
                    ApplicationArea = All;
                }
                field("Offense Name"; "Offense Name")
                {
                    ApplicationArea = All;
                }
                field("Employee No"; "Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Case Status"; "Case Status")
                {
                    ApplicationArea = All;
                }
                field("HOD Name"; "HOD Name")
                {
                    ApplicationArea = All;
                }
                field("HOD Recommendation"; "HOD Recommendation")
                {
                    ApplicationArea = All;
                }
                field("HR Recommendation"; "HR Recommendation")
                {
                    ApplicationArea = All;
                }
                field("Commitee Recommendation"; "Commitee Recommendation")
                {
                    ApplicationArea = All;
                }
                field("Action Taken"; "Action Taken")
                {
                    ApplicationArea = All;
                }
                field(Appealed; Appealed)
                {
                    ApplicationArea = All;
                }
                field("Committee Recon After Appeal"; "Committee Recon After Appeal")
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

