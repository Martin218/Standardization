report 50093 "Members & Accounts Summary"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Members & Accounts Summary.rdlc';
    Caption = 'Members & Accounts Summary-by Branch';

    dataset
    {
        dataitem(DataItem10; "Dimension Value")
        {
            DataItemTableView = SORTING("Dimension Code", Code)
                                WHERE("Global Dimension No." = FILTER(1));
            RequestFilterFields = "Code";
            column(Code_DimensionValue; Code)
            {
            }
            column(Name_DimensionValue; UPPERCASE(Name))
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(RCount_1; RCount[1])
            {
            }
            dataitem(DataItem1; "Account Type")
            {
                column(Code_AccountType; Code)
                {
                }
                column(Description_AccountType; Description)
                {
                }
                column(RSum_1; RSum[1])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RSum[1] := 0;
                    RSum[2] := 0;
                    IF Type = Type::Loan THEN BEGIN
                        Customer.RESET;
                        Vendor.SETRANGE("Account Type", Code);
                        Customer.SETRANGE("Global Dimension 1 Code", Code);
                        IF Customer.FINDSET THEN BEGIN
                            REPEAT
                                Customer.CALCFIELDS("Balance (LCY)");
                                RSum[1] += Customer."Balance (LCY)";
                            UNTIL Customer.NEXT = 0;
                        END;
                    END ELSE BEGIN
                        Vendor.RESET;
                        Vendor.SETRANGE("Account Type", Code);
                        Vendor.SETRANGE("Global Dimension 1 Code", Code);
                        IF Vendor.FINDSET THEN BEGIN
                            REPEAT
                                Vendor.CALCFIELDS("Balance (LCY)");
                                RSum[1] += Vendor."Balance (LCY)";
                            UNTIL Vendor.NEXT = 0;
                        END;
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RCount[1] := 0;
                RSum[1] := 0;
                RSum[2] := 0;
                i += 1;

                Member.RESET;
                Member.SETRANGE("Global Dimension 1 Code", Code);
                RCount[1] := Member.COUNT;
            end;

            trigger OnPreDataItem()
            begin
                TotalDimension := COUNT;
                i := 0;
            end;
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
        ReportTitle = 'Members & Accounts Summary';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        RCount: array[4] of Integer;
        RSum: array[10] of Decimal;
        Member: Record "Member";
        LoanApplication: Record "Loan Application";
        Vendor: Record "Vendor";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record "Customer";
        TotalDimension: Integer;
        i: Integer;
}

