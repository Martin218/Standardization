report 50082 "Member Statement"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Member Statement.rdlc';

    dataset
    {
        dataitem(DataItem1; Member)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_Member; "No.")
            {
            }
            column(Surname_Member; Surname)
            {
            }
            column(FullName_Member; "Full Name")
            {
            }
            column(GlobalDimension1Code_Member; "Global Dimension 1 Code")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem7; Vendor)
            {
                DataItemLink = "Member No." = FIELD("No.");
                DataItemTableView = SORTING("No.");
                column(No_Vendor; "No.")
                {
                }
                column(Name_Vendor; Name)
                {
                }
                column(BalanceLCY_Vendor; "Balance (LCY)")
                {
                }
                dataitem(DataItem6; "Vendor Ledger Entry")
                {
                    //DataItemLink = "Vendor No.""=FIELD("No.");
                    DataItemTableView = SORTING("Entry No.");
                    column(VendorNo_VendorLedgerEntry; "Vendor No.")
                    {
                    }
                    column(PostingDate_VendorLedgerEntry; "Posting Date")
                    {
                    }
                    column(DocumentType_VendorLedgerEntry; "Document Type")
                    {
                    }
                    column(DocumentNo_VendorLedgerEntry; "Document No.")
                    {
                    }
                    column(Description_VendorLedgerEntry; Description)
                    {
                    }
                    column(CurrencyCode_VendorLedgerEntry; "Currency Code")
                    {
                    }
                    column(Amount_VendorLedgerEntry; Amount)
                    {
                    }
                    column(RemainingAmount_VendorLedgerEntry; "Remaining Amount")
                    {
                    }
                    column(RunningBalance; RunningBalance)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        RunningBalance += Amount;
                    end;

                    trigger OnPreDataItem()
                    begin
                        RunningBalance := 0;
                    end;
                }
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
        ReportTitle = 'Member Statement';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        RunningBalance: Decimal;
}

