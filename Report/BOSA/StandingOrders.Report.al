report 50105 "Standing Orders"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Standing Orders.rdlc';

    dataset
    {
        dataitem(DataItem1; "Standing Order")
        {
            DataItemTableView = WHERE(Status = FILTER(Approved));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_StandingOrder; "No.")
            {
            }
            column(Description_StandingOrder; Description)
            {
            }
            column(MemberNo_StandingOrder; "Member No.")
            {
            }
            column(MemberName_StandingOrder; "Member Name")
            {
            }
            column(SourceAccountNo_StandingOrder; "Source Account No.")
            {
            }
            column(SourceAccountName_StandingOrder; "Source Account Name")
            {
            }
            column(Running_StandingOrder; Running)
            {
            }
            column(NextRunDate_StandingOrder; "Next Run Date")
            {
            }
            column(StartDate_StandingOrder; "Start Date")
            {
            }
            column(EndDate_StandingOrder; "End Date")
            {
            }
            column(Frequency_StandingOrder; Frequency)
            {
            }
            column(NoSeries_StandingOrder; "No. Series")
            {
            }
            column(SourceAccountBalance_StandingOrder; "Source Account Balance")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem2; "Standing Order Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(MemberNo_StandingOrderLine; "Member No.")
                {
                }
                column(MemberName_StandingOrderLine; "Member Name")
                {
                }
                column(AccountNo_StandingOrderLine; "Account No.")
                {
                }
                column(AccountName_StandingOrderLine; "Account Name")
                {
                }
                column(LineAmount_StandingOrderLine; "Line Amount")
                {
                }
                column(Priority_StandingOrderLine; Priority)
                {
                }
                column(AccountType_StandingOrderLine; "Account Type")
                {
                }
                column(DestinationType_StandingOrderLine; "Destination Type")
                {
                }
                column(DestinationAccountNo_StandingOrderLine; "Destination Account No.")
                {
                }
                column(DestinationAccountName_StandingOrderLine; "Destination Account Name")
                {
                }
                column(DestinationBankName_StandingOrderLine; "Destination Bank Name")
                {
                }
                column(DestinationBranchName_StandingOrderLine; "Destination Branch Name")
                {
                }
                column(SwiftCode_StandingOrderLine; "Swift Code")
                {
                }
                column(Visiblity_1; Visibility[1])
                {
                }
                column(Visiblity_2; Visibility[2])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF "Destination Type" = "Destination Type"::Internal THEN
                        Visibility[1] := FALSE;

                    IF "Destination Type" = "Destination Type"::External THEN
                        Visibility[2] := FALSE;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitle = 'Standing Orders';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        LoanApplication: Record "Loan Application";
        Visibility: array[4] of Boolean;
}

