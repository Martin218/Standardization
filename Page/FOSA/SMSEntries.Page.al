page 50250 "SMS Entries"
{
    // version TL2.0

    Editable = false;
    PageType = List;
    SourceTable = "SMS Entry";
    UsageCategory = History;
    ApplicationArea = All;
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
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field(SMSText; SMSText)
                {
                    Caption = 'SMS Text';
                    ApplicationArea = All;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field(Sent; Sent)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SMSText := GetSMSTemplate;
        CalcFields("SMS Text");
    end;

    var
        SMSText: Text;
}

