report 50401 "Creating Pay Period"
{

    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PayStartDate; PayStartDate)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = All;
                    }
                    field(NoOfPeriods; NoOfPeriods)
                    {
                        Caption = 'No. of Periods';
                        ApplicationArea = All;
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        Caption = 'Period Length';
                        ApplicationArea = All;
                    }
                    field(PeriodType; PeriodType)
                    {
                        Caption = 'Period Type';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        PayrollProcessing.CreatingPayrollPeriod(NoOfPeriods, PeriodLength, PayStartDate, PeriodType);
    end;

    var
        NoOfPeriods: Integer;
        PeriodLength: DateFormula;
        PayStartDate: Date;
        FirstPeriodStartDate: Date;
        LastPeriodStartDate: Date;
        PeriodType: Option " ",Daily,Weekly,"Bi-Weekly",Monthly;
        PayrollProcessing: Codeunit "Payroll Processing";
}

