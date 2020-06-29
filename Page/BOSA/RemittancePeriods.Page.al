page 50297 "Remittance Periods"
{
    // version TL2.0

    Editable = false;
    PageType = List;
    SourceTable = "Remittance Period";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field(Month; Month)
                {
                    ApplicationArea = All;
                }
                field(Year; Year)
                {
                    ApplicationArea = All;
                }
                field(Closed; Closed)
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
            action("Create Period")
            {
                Image = CreateYear;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CreateRemittancePeriod.RUN;
                end;
            }
        }
    }

    var
        CreateRemittancePeriod: Report "Create Remittance Period";
}

