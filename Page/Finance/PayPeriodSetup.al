page 50501 "Pay Period Setup"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Payroll Period";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Starting Date"; "Starting Date")
                {
                     ApplicationArea=All;
                }
                field(Name; Name)
                {
                     ApplicationArea=All;
                }
                field("New Fiscal Year"; "New Fiscal Year")
                {
                     ApplicationArea=All;
                }
                field(Closed; Closed)
                {
                     ApplicationArea=All;
                }
                field("Date Locked"; "Date Locked")
                {
                     ApplicationArea=All;
                }
                field("Pay Date"; "Pay Date")
                {
                     ApplicationArea=All;
                }
                field("Close Pay"; "Close Pay")
                {
                     ApplicationArea=All;
                }
                field("P.A.Y.E"; "P.A.Y.E")
                {
                     ApplicationArea=All;
                }
                field("Basic Pay"; "Basic Pay")
                {
                     ApplicationArea=All;
                }
                field("Closed By"; "Closed By")
                {
                     ApplicationArea=All;
                }
                field("Closed on Date"; "Closed on Date")
                {
                     ApplicationArea=All;
                }
                field(Type; Type)
                {
                     ApplicationArea=All;
                }
                field(Sendslip; Sendslip)
                {
                     ApplicationArea=All;
                }
                field(Status; Status)
                {
                     ApplicationArea=All;
                }
                field("Start Approval"; "Start Approval")
                {
                     ApplicationArea=All;
                }
                field("Period code"; "Period code")
                {
                     ApplicationArea=All;
                }
                field("Approval Status"; "Approval Status")
                {
                     ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
         area(Processing)
        {
            action("&Create Period")
            {
                Caption = '&Create Period';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Image=CreateReminders;
                RunObject = Report 50401;
            }
            action("&Close Pay Period")
            {
               Caption='&Close Pay Period';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea=All;
                trigger OnAction();
                begin
                 PayrollProcessing.ClosingPayrollPeriod();
                end;
            }
        }
    }

    var
   PayrollProcessing : Codeunit "Payroll Processing";
}

