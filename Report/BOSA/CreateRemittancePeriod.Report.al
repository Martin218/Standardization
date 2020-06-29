report 50065 "Create Remittance Period"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1));

            trigger OnAfterGetRecord()
            begin
                EndDate := CALCDATE(PeriodLength, StartDate);
                Calendar.RESET;
                Calendar.SETRANGE("Period Type", Calendar."Period Type"::Month);
                Calendar.SETRANGE("Period Start", StartDate, EndDate);
                IF Calendar.FINDSET THEN BEGIN
                    REPEAT
                        RemittancePeriod.INIT;
                        RemittancePeriod."Start Date" := Calendar."Period Start";
                        RemittancePeriod.Year := DATE2DMY(Calendar."Period Start", 3);
                        RemittancePeriod.Month := Calendar."Period Name";
                        RemittancePeriod.INSERT;
                    UNTIL Calendar.NEXT = 0;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate; StartDate)
                {
                    Caption = 'Start Date';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(PeriodLength; PeriodLength)
                {
                    Caption = 'Period Length';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IntializeStartDate();
        end;
    }

    labels
    {
    }

    var
        StartDate: Date;
        EndDate: Date;
        PeriodLength: DateFormula;
        RemittancePeriod: Record "Remittance Period";
        Calendar: Record "Date";
        Month2: Integer;
        MonthTxt: Text[2];
        i: Integer;

    local procedure IntializeStartDate()
    begin
        EVALUATE(PeriodLength, '<12M>');

        RemittancePeriod.RESET;
        IF RemittancePeriod.FINDLAST THEN
            StartDate := CALCDATE('1M', RemittancePeriod."Start Date")
        ELSE
            StartDate := TODAY;
    end;
}

