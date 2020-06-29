page 50702 "Procurement Plan Lines"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Procurement Plan Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Plan No"; "Plan No")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Current Budget"; "Current Budget")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Source Of Funds"; "Source Of Funds")
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; "G/L Account")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("G/L Name"; "G/L Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Procurement Type"; "Procurement Type")
                {
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Procurement Sub Type"; "Procurement Sub Type")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit On Measure"; "Unit On Measure")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Estimated Cost"; "Estimated Cost")
                {
                    ApplicationArea = All;
                }
                field("Budget Amount"; "Budget Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Committed Amount"; "Committed Amount")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Advertisement Date"; "Advertisement Date")
                {
                    ApplicationArea = All;
                }
                field("Expected Completion Date"; "Expected Completion Date")
                {
                    ApplicationArea = All;
                }
                field("Procurement Method"; "Procurement Method")
                {
                    ApplicationArea = All;
                }
                field("Distribution Type"; "Distribution Type")
                {
                    ApplicationArea = All;
                }
                field("1st Quarter"; "1st Quarter")
                {
                    ApplicationArea = All;
                }
                field("2nd Quarter"; "2nd Quarter")
                {
                    ApplicationArea = All;
                }
                field("3rd Quarter"; "3rd Quarter")
                {
                    ApplicationArea = All;
                }
                field("4th Quarter"; "4th Quarter")
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
        }
    }

    trigger OnInit();
    begin
        IF ProcurementPlanHeader.GET("Plan No") THEN BEGIN
            //IF ProcurementPlanHeader."Budget Period" = ProcurementPlanHeader."Budget Period"::
        END;
    end;

    var
        CancelMessage: Label 'Page Closed';
        Quarterly: Boolean;
        ProcurementPlanHeader: Record "Procurement Plan Header";
}

