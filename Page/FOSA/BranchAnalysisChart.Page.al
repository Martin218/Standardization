page 50355 "Branch Analysis Chart"
{
    Caption = 'Branch Analysis';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            field(StatusText; StatusText)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Status Text';
                Editable = false;
                ShowCaption = false;
                ToolTip = 'Specifies the status of the chart.';
            }
            usercontrol(BusinessChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Basic, Suite;

                trigger DataPointClicked(point: JsonObject)
                begin
                    //        SetDrillDownIndexes(point);
                    TrailingMembersMgt.DrillDown(Rec);
                end;

                // trigger DataPointDoubleClicked(point: DotNet BusinessChartDataPoint)
                // begin
                // end;


                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    TrailingMembersMgt.OnOpenPage(TrailingMemberSetup);
                    UpdateStatus;
                    if IsChartDataReady then
                        UpdateChart;
                end;

                trigger Refresh()
                begin
                    if IsChartAddInReady and IsChartDataReady then begin
                        NeedsUpdate := true;
                        UpdateChart
                    end;
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Show)
            {
                Caption = 'Show';
                Image = View;
                action(AllMembers)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Members';
                    Enabled = AllMembersEnabled;
                    ToolTip = 'View all registered members, even with the future date';

                    trigger OnAction()
                    begin
                        // TrailingMemberSetup.SetShowMembers(TrailingMemberSetup."Show Members"::"All Members");
                        UpdateStatus;
                    end;
                }
                action(MembersUntilToday)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Members Until Today';
                    Enabled = MembersUntilTodayEnabled;
                    ToolTip = 'View all registered Members until today''s date.';

                    trigger OnAction()
                    begin
                        // TrailingMemberSetup.SetShowMembers(TrailingMemberSetup."Show Members"::"Members Until Today");
                        UpdateStatus;
                    end;
                }

            }
            group(PeriodLength)
            {
                Caption = 'Period Length';
                Image = Period;
                action(Day)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Day';
                    Enabled = DayEnabled;
                    ToolTip = 'Each stack covers one day.';

                    trigger OnAction()
                    begin
                        TrailingMemberSetup.SetPeriodLength(TrailingMemberSetup."Period Length"::Day);
                        UpdateStatus;
                    end;
                }
                action(Week)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Week';
                    Enabled = WeekEnabled;
                    ToolTip = 'Each stack except for the last stack covers one week. The last stack contains data from the start of the week until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        TrailingMemberSetup.SetPeriodLength(TrailingMemberSetup."Period Length"::Week);
                        UpdateStatus;
                    end;
                }
                action(Month)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Month';
                    Enabled = MonthEnabled;
                    ToolTip = 'Each stack except for the last stack covers one month. The last stack contains data from the start of the month until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        TrailingMemberSetup.SetPeriodLength(TrailingMemberSetup."Period Length"::Month);
                        UpdateStatus;
                    end;
                }
                action(Quarter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quarter';
                    Enabled = QuarterEnabled;
                    ToolTip = 'Each stack except for the last stack covers one quarter. The last stack contains data from the start of the quarter until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        TrailingMemberSetup.SetPeriodLength(TrailingMemberSetup."Period Length"::Quarter);
                        UpdateStatus;
                    end;
                }
                action(Year)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Year';
                    Enabled = YearEnabled;
                    ToolTip = 'Each stack except for the last stack covers one year. The last stack contains data from the start of the year until the date that is defined by the Show option.';

                    trigger OnAction()
                    begin
                        TrailingMemberSetup.SetPeriodLength(TrailingMemberSetup."Period Length"::Year);
                        UpdateStatus;
                    end;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                Image = SelectChart;
                group(ValueToCalculate)
                {
                    Caption = 'Value to Calculate';
                    Image = Calculate;
                    action(Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Amount';
                        Enabled = AmountEnabled;
                        ToolTip = 'The Y-axis shows the totaled LCY amount of the Members.';

                        trigger OnAction()
                        begin
                            // TrailingMemberSetup.SetValueToCalcuate(TrailingMemberSetup."Value to Calculate"::"Amount Excl. VAT");
                            UpdateStatus;
                        end;
                    }
                    action(NoofMembers)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Members';
                        Enabled = NoOfMembersEnabled;
                        ToolTip = 'The Y-axis shows the number of Members.';

                        trigger OnAction()
                        begin
                            TrailingMemberSetup.SetValueToCalcuate(TrailingMemberSetup."Value to Calculate"::"No. of Members");
                            UpdateStatus;
                        end;
                    }
                }
                group("Chart Type")
                {
                    Caption = 'Chart Type';
                    Image = BarChart;
                    action(StackedArea)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stacked Area';
                        Enabled = StackedAreaEnabled;
                        ToolTip = 'View the data in area layout.';

                        trigger OnAction()
                        begin
                            TrailingMemberSetup.SetChartType(TrailingMemberSetup."Chart Type"::"Stacked Area");
                            UpdateStatus;
                        end;
                    }
                    action(StackedAreaPct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stacked Area (%)';
                        Enabled = StackedAreaPctEnabled;
                        ToolTip = 'view the percentage distribution of the four member statuses in area layout.';

                        trigger OnAction()
                        begin
                            TrailingMemberSetup.SetChartType(TrailingMemberSetup."Chart Type"::"Stacked Area (%)");
                            UpdateStatus;
                        end;
                    }
                    action(StackedColumn)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stacked Column';
                        Enabled = StackedColumnEnabled;
                        ToolTip = 'view the data in column layout.';

                        trigger OnAction()
                        begin
                            TrailingMemberSetup.SetChartType(TrailingMemberSetup."Chart Type"::"Stacked Column");
                            UpdateStatus;
                        end;
                    }
                    action(StackedColumnPct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stacked Column (%)';
                        Enabled = StackedColumnPctEnabled;
                        ToolTip = 'view the percentage distribution of the four member statuses in column layout.';

                        trigger OnAction()
                        begin
                            TrailingMemberSetup.SetChartType(TrailingMemberSetup."Chart Type"::"Stacked Column (%)");
                            UpdateStatus;
                        end;
                    }
                }
            }
            separator(Action25)
            {
            }
            action(Setup)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Setup';
                Image = Setup;
                ToolTip = 'Specify if the chart will be based on a work date other than today''s date. This is mainly relevant in demonstration databases with fictitious Members.';

                trigger OnAction()
                begin
                    RunSetup;
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        UpdateChart;
        IsChartDataReady := true;

        if not IsChartAddInReady then
            SetActionsEnabled;
    end;

    trigger OnOpenPage()
    begin
        SetActionsEnabled;
    end;

    var
        TrailingMemberSetup: Record "Trailing Account Type Setup";
        OldTrailingMemberSetup: Record "Trailing Account Type Setup";
        TrailingMembersMgt: Codeunit "Trailing Account Types Mgt.";
        ChartMgt: Codeunit "Chart Management";
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        [InDataSet]
        AllMembersEnabled: Boolean;
        [InDataSet]
        MembersUntilTodayEnabled: Boolean;
        [InDataSet]

        DayEnabled: Boolean;
        [InDataSet]
        WeekEnabled: Boolean;
        [InDataSet]
        MonthEnabled: Boolean;
        [InDataSet]
        QuarterEnabled: Boolean;
        [InDataSet]
        YearEnabled: Boolean;
        [InDataSet]
        AmountEnabled: Boolean;
        [InDataSet]
        NoOfMembersEnabled: Boolean;
        [InDataSet]
        StackedAreaEnabled: Boolean;
        [InDataSet]
        StackedAreaPctEnabled: Boolean;
        [InDataSet]
        StackedColumnEnabled: Boolean;
        [InDataSet]
        StackedColumnPctEnabled: Boolean;
        IsChartAddInReady: Boolean;
        IsChartDataReady: Boolean;

    local procedure UpdateChart()
    begin
        if not NeedsUpdate then
            exit;
        if not IsChartAddInReady then
            exit;
        TrailingMembersMgt.UpdateData(Rec);
        Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := false;
    end;

    local procedure UpdateStatus()
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldTrailingMemberSetup."Period Length" <> TrailingMemberSetup."Period Length") or
          (OldTrailingMemberSetup."Show Members" <> TrailingMemberSetup."Show Members") or
           (OldTrailingMemberSetup."Use Work Date as Base" <> TrailingMemberSetup."Use Work Date as Base") or
          (OldTrailingMemberSetup."Value to Calculate" <> TrailingMemberSetup."Value to Calculate") or
          (OldTrailingMemberSetup."Chart Type" <> TrailingMemberSetup."Chart Type");

        OldTrailingMemberSetup := TrailingMemberSetup;

        if NeedsUpdate then
            StatusText := TrailingMemberSetup.GetCurrentSelectionText;

        SetActionsEnabled;
    end;

    local procedure RunSetup()
    begin
        // PAGE.RunModal(PAGE::"Trailing Members Setup", TrailingMemberSetup);
        TrailingMemberSetup.Get(UserId);
        UpdateStatus;
    end;

    procedure SetActionsEnabled()
    begin
        // AllMembersEnabled := (TrailingMemberSetup."Show Members" <> TrailingMemberSetup."Show Members"::"All Members") and
        //   IsChartAddInReady;
        //MembersUntilTodayEnabled :=
        //   (TrailingMemberSetup."Show Members" <> TrailingMemberSetup."Show Members"::"Members Until Today") and
        // IsChartAddInReady;
        //  DelayedMembersEnabled := (TrailingMemberSetup."Show Members" <> TrailingMemberSetup."Show Members"::"Delayed Members") and
        //  IsChartAddInReady;
        DayEnabled := (TrailingMemberSetup."Period Length" <> TrailingMemberSetup."Period Length"::Day) and
          IsChartAddInReady;
        WeekEnabled := (TrailingMemberSetup."Period Length" <> TrailingMemberSetup."Period Length"::Week) and
          IsChartAddInReady;
        MonthEnabled := (TrailingMemberSetup."Period Length" <> TrailingMemberSetup."Period Length"::Month) and
          IsChartAddInReady;
        QuarterEnabled := (TrailingMemberSetup."Period Length" <> TrailingMemberSetup."Period Length"::Quarter) and
          IsChartAddInReady;
        YearEnabled := (TrailingMemberSetup."Period Length" <> TrailingMemberSetup."Period Length"::Year) and
          IsChartAddInReady;
        // AmountEnabled :=
        //   (TrailingMemberSetup."Value to Calculate" <> TrailingMemberSetup."Value to Calculate"::"Amount Excl. VAT") and
        //   IsChartAddInReady;
        NoOfMembersEnabled :=
         (TrailingMemberSetup."Value to Calculate" <> TrailingMemberSetup."Value to Calculate"::"No. of Members") and
         IsChartAddInReady;
        StackedAreaEnabled := (TrailingMemberSetup."Chart Type" <> TrailingMemberSetup."Chart Type"::"Stacked Area") and
          IsChartAddInReady;
        StackedAreaPctEnabled := (TrailingMemberSetup."Chart Type" <> TrailingMemberSetup."Chart Type"::"Stacked Area (%)") and
          IsChartAddInReady;
        StackedColumnEnabled := (TrailingMemberSetup."Chart Type" <> TrailingMemberSetup."Chart Type"::"Stacked Column") and
          IsChartAddInReady;
        StackedColumnPctEnabled :=
          (TrailingMemberSetup."Chart Type" <> TrailingMemberSetup."Chart Type"::"Stacked Column (%)") and
          IsChartAddInReady;
    end;
}

