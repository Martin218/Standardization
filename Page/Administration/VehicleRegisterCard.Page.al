page 50177 "Vehicle Register card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Vehicle Register";

    layout
    {
        area(content)
        {
            group("Vehicle Registry")
            {
                field("No."; "No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Fixed Asset Car No."; "Fixed Asset Car No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Responsible Driver"; "Responsible Driver")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    TableRelation = "Driver Setup";
                }
                field(Insured; Insured)
                {
                    ApplicationArea = All;
                }
                field("Date of Insurance"; "Date of Insurance")
                {
                    ApplicationArea = All;
                }
                field(Months; Months)
                {
                    ApplicationArea = All;
                }
                field("Insurance Expiry Date"; "Insurance Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; "Branch Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Number Plate"; "Number Plate")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Chassis No"; "Chassis No")
                {
                    ApplicationArea = All;
                }
                field("Body Type"; "Body Type")
                {
                    ApplicationArea = All;
                }
                field(Colour; Colour)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Color; Color)
                {
                    ApplicationArea = All;
                }
                field(Model; Model)
                {
                    ApplicationArea = All;
                }
                field("Engine No"; "Engine No")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(YOM; YOM)
                {
                    ApplicationArea = All;
                    Caption = 'Year Of Manufacture-Year';
                }
                field("YOM-Month"; "YOM-Month")
                {
                    ApplicationArea = All;
                    Caption = 'Year Of Manufacture-Month';
                }
                field(Registered; Registered)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Visible = false;
                }
                field(Booked; Booked)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Visible = false;
                }
                field("Condition of Vehicle"; "Condition of Vehicle")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Add Vehicle to Registry")
            {
                Image = BookingsLogo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    AdminManagement.RegisterVehicle(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        AdminManagement: Codeunit "Admin Management";
}

