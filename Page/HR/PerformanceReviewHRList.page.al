page 50932 "Performance Review HR List"
{
    // version TL2.0

    CardPageID = "Performance Review Card";
    PageType = List;
    SourceTable = 50286;
    SourceTableView = WHERE("Released to HR Admin" = FILTER('Yes'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Period; Period)
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name"; "Middle Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;
                }
                field("Department Code"; "Department Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        FILTERGROUP(2);
        UserSetup.GET(USERID);
        //   SETRANGE("Appraiser Employee No.", UserSetup."Employee No.");
        FILTERGROUP(0);
    end;

    var
        UserSetup: Record 91;
}

