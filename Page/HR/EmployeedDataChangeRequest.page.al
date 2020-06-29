page 50476 "Employee Data Change Request"
{
    // version TL2.0

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = 50245;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
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
                field("Field Caption"; "Field Caption")
                {
                    ApplicationArea = All;
                }
                field("Old Value"; "Old Value")
                {
                    ApplicationArea = All;
                }
                field("New Value"; "New Value")
                {
                    ApplicationArea = All;
                }
                field("Change Date"; "Change Date")
                {
                    ApplicationArea = All;
                }
                field("Change Time"; "Change Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(Approver; Approver)
                {
                    ApplicationArea = All;
                }
                field("Approval Date"; "Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Approval Time"; "Approval Time")
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
            action("View Employee Card")
            {
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunPageMode = View;
                ApplicationArea = All;
            }
        }
    }

    var
        Employee: Record 5200;
        DimensionValue: Record 349;
        Date1: Date;
        Date2: Date;
        CurrentYear: Integer;
        YearOfBirth: Integer;
        Employee2: Record 5200;
        NoSeriesManagement: Codeunit 396;
        HRSetup: Record 5218;
}

