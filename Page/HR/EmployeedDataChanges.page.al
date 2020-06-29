page 50475 "Employee Data Changes"
{
    // version TL2.0

    Caption = 'Change Log Entries';
    Editable = false;
    PageType = List;
    SourceTable = 405;
    SourceTableView = WHERE("Table No." = FILTER('5200'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Date and Time"; "Date and Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date and time when this change log entry was created.';
                    // ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the user ID of the user who made the change to the field.';
                    //  ApplicationArea = All;
                }
                field("Primary Key Field 1 Value"; "Primary Key Field 1 Value")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Employee No';
                    ToolTip = 'Specifies the value of the first primary key for the changed field.';
                    // ApplicationArea = All;
                }
                field(Name; Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field("Field Caption"; "Field Caption")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies the field caption of the changed field.';
                    //  ApplicationArea = All;
                }
                field("Type of Change"; "Type of Change")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of change made to the field.';
                    //ApplicationArea = All;
                }
                field("Old Value"; "Old Value")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value that the field had before a user made changes to the field.';
                    // ApplicationArea = All;
                }
                field("New Value"; "New Value")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value that the field had after a user made changes to the field.';
                    //  ApplicationArea = All;
                }
            }
        }

    }

    actions
    {
        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Visible = false;

                trigger OnAction();
                begin
                    REPORT.RUN(REPORT::"Change Log Entries", TRUE, FALSE, Rec);
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        IF "Primary Key Field 1 Value" <> '' THEN BEGIN
            Employee.GET("Primary Key Field 1 Value");
            Name := Employee."Search Name";
        END ELSE BEGIN
            Name := '';
        END;
    end;

    var
        Name: Text;
        Employee: Record 5200;
}

