page 50463 "Training Request Lines"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = 50235;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
                field(Department; Department)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field(Grade; Grade)
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Confirmation Date"; "Confirmation Date")
                {
                    ApplicationArea = All;
                }
                field("Employment Status"; "Employment Status")
                {
                    ApplicationArea = All;
                }

                field("Training Cost"; "Training Cost")
                {
                    ApplicationArea = All;
                }
                field("Other Costs"; "Other Costs")
                {
                    ApplicationArea = All;
                }
                field("Total Cost"; "Total Cost")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        Visibility;
    end;

    var
        SeeAllowances: Boolean;

    local procedure Visibility();
    var
        TrainingRequest: Record 50234;
    begin
        IF TrainingRequest.GET("Training Request No.") THEN BEGIN
            IF TrainingRequest."Submitted To HR" THEN BEGIN
                SeeAllowances := TRUE;
            END ELSE BEGIN
                SeeAllowances := FALSE;
            END;
        END;
    end;
}

