report 50089 "Accounts Movement"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = '/BOSA/Accounts Movement.rdlc';

    dataset
    {
        dataitem(DataItem7; "Dimension Value")
        {
            DataItemTableView = SORTING("Dimension Code", Code)
                                WHERE("Global Dimension No." = FILTER(1));
            PrintOnlyIfDetail = true;
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
            dataitem(DataItem19; Vendor)
            {
                DataItemLink = "Global Dimension 1 Code" = FIELD(Code);
                RequestFilterFields = "Account Type", "Member No.";
                column(No_Vendor; "No.")
                {
                }
                column(Name_Vendor; Name)
                {
                }
                column(TotalAmount_1; TotalAmount[1])
                {
                }
                column(AccountType_Vendor; "Account Type")
                {
                }
                column(MemberNo_Vendor; "Member No.")
                {
                }
                column(MemberName_Vendor; "Member Name")
                {
                }
                column(TotalAmount_2; TotalAmount[2])
                {
                }
                column(TotalAmount_3; TotalAmount[3])
                {
                }
                column(TotalAmount_4; TotalAmount[4])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TotalAmount[1] := 0;
                    TotalAmount[2] := 0;
                    TotalAmount[3] := 0;
                    TotalAmount[4] := 0;
                    TotalAmount[5] := 0;
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Vendor No.", "No.");
                    IF VendorLedgerEntry.FINDSET THEN BEGIN
                        REPEAT
                            VendorLedgerEntry.CALCFIELDS(Amount);
                            IF VendorLedgerEntry."Source Code" = SourceCodeSetup.Assembly THEN
                                TotalAmount[1] += VendorLedgerEntry.Amount
                            ELSE BEGIN
                                IF VendorLedgerEntry.Amount > 0 THEN
                                    TotalAmount[2] += VendorLedgerEntry.Amount;
                                IF VendorLedgerEntry.Amount < 0 THEN
                                    TotalAmount[3] += VendorLedgerEntry.Amount;
                            END;
                        UNTIL VendorLedgerEntry.NEXT = 0;
                    END;
                    TotalAmount[4] := TotalAmount[1] + TotalAmount[2] + TotalAmount[3];
                end;
            }

            trigger OnPreDataItem()
            begin
                SourceCodeSetup.GET;
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
        ReportTitle = 'Accounts Movement';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        GLEntry: Record "G/L Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        TotalAmount: array[10] of Decimal;
}

