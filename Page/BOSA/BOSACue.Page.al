page 50348 "BOSA Activities"
{
    PageType = CardPart;
    SourceTable = "BOSA Cue";

    layout
    {
        area(content)
        {
            cuegroup(LoanApplicationWideLayout)
            {

                Caption = 'Summary';
                CuegroupLayout = Wide;
                field("Total Requested Amount"; "Total Requested Amount")
                {
                    Caption = 'Total Requested Amount';
                    DrillDownPageId = "Posted Loan List";
                    ApplicationArea = All;
                }
                field("Total Disbursed Amount"; "Total Disbursed Amount")
                {
                    Caption = 'Total Disbursed Amount';

                    DrillDownPageId = "Posted Loan List";
                    ApplicationArea = All;
                }


            }
            cuegroup(LoanApplicationCueContainer)
            {
                Caption = 'Loan Application';
                //CuegroupLayout = Wide;
                field("LoanApplication-New"; "LoanApplication-New")
                {
                    Caption = 'New';
                    DrillDownPageId = "Loan Application List";
                    ApplicationArea = All;
                }
                field("LoanApplication-Pending"; "LoanApplication-Pending")
                {
                    Caption = 'Pending Appraisal';
                    DrillDownPageId = "Pending Loan Applications List";
                    ApplicationArea = All;
                }
                field("LoanApplication-Approved"; "LoanApplication-Approved")
                {
                    Caption = 'Pending Disbursal';
                    DrillDownPageId = "Pending Disbursal Loan List";
                    ApplicationArea = All;
                }

            }
            cuegroup(StandingOrderCueContainer)
            {
                Caption = 'Standing Order';
                //CuegroupLayout = Wide;
                field("StandingOrder-New"; "StandingOrder-New")
                {
                    Caption = 'New';
                    DrillDownPageId = "Standing Order List";
                    ApplicationArea = All;
                }
                field("StandingOrder-Pending"; "StandingOrder-Pending")
                {
                    Caption = 'Pending Approval';
                    DrillDownPageId = "Pending Standing Order List";
                    ApplicationArea = All;
                }
                field("StandingOrder-Running"; "StandingOrder-Running")
                {
                    Caption = 'Running';
                    DrillDownPageId = "Running Standing Order List";
                    ApplicationArea = All;
                }
                field("StandingOrder-Approved"; "StandingOrder-Approved")
                {
                    Caption = 'Stopped';
                    DrillDownPageId = "Approved Standing Order List";
                    ApplicationArea = All;
                }

            }


            cuegroup(LoanApplicationActionContainer)
            {
                Caption = 'New Loan Application';

                actions
                {

                    action("New Loan Application")
                    {
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = page "Loan Application Card";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        RESET;
        if not get then begin
            INIT;
            INSERT;
        end;
    end;
}