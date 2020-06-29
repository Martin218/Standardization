page 50467 "Training Calendar"
{
    // version TL2.0

    CardPageID = "Training Requests Card";
    PageType = List;
    SourceTable = 50234;
    SourceTableView = WHERE(Status = FILTER('Open'),
                            "Added To Calendar" = FILTER('Yes'));
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
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Training Description"; "Training Description")
                {
                    ApplicationArea = All;
                }
                field("Course/Seminar Name"; "Course/Seminar Name")
                {
                    ApplicationArea = All;
                }
                field("Training Institution"; "Training Institution")
                {
                    ApplicationArea = All;
                }
                field(Venue; Venue)
                {
                    ApplicationArea = All;
                }
                field(Duration; Duration)
                {
                    ApplicationArea = All;
                }
                field("Duration Units"; "Duration Units")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; "End Date")
                {
                    ApplicationArea = All;
                }
                field(Location; Location)
                {
                    ApplicationArea = All;
                }
                field("Cost of Training"; "Cost of Training")
                {
                    ApplicationArea = All;
                }
                field("Total Cost of Training"; "Total Cost of Training")
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

