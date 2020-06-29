report 50079 "NWDs vs Loan Book"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/NWDs vs Loan Book.rdlc';

    dataset
    {
        dataitem(DataItem1; "Dimension Value")
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
            column(RSum_1; RSum[1])
            {
            }
            column(RSum_2; RSum[2])
            {
            }
            column(RSum_3; RSum[3])
            {
            }
            column(RCount_1; RCount[1])
            {
            }
            column(RCount_2; RCount[2])
            {
            }

            trigger OnAfterGetRecord()
            begin
                RCount[1] := 0;
                RCount[2] := 0;
                RSum[1] := 0;
                RSum[2] := 0;
                RSum[3] := 0;
                Member.RESET;
                Member.SETRANGE("Global Dimension 1 Code", Code);
                IF Member.FINDSET THEN BEGIN
                    REPEAT
                        RCount[1] += 1;
                        Vendor.RESET;
                        Vendor.SETRANGE("Member No.", Member."No.");
                        IF Vendor.FINDSET THEN BEGIN
                            REPEAT
                                Vendor.CALCFIELDS("Balance (LCY)");
                                IF IsDepositAccount(Vendor."Account Type") THEN
                                    RSum[1] += ABS(Vendor."Balance (LCY)");
                                IF IsSavingsAccount(Vendor."Account Type") THEN
                                    RSum[3] += ABS(Vendor."Balance (LCY)");
                            UNTIL Vendor.NEXT = 0;
                        END;

                        LoanApplication.RESET;
                        LoanApplication.SETRANGE("Global Dimension 1 Code", Member."Global Dimension 1 Code");
                        LoanApplication.CALCSUMS("Approved Amount");
                        RSum[2] := LoanApplication."Approved Amount";
                        RCount[2] := LoanApplication.COUNT;
                    UNTIL Member.NEXT = 0;
                END;
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
        ReportTitle = 'NWDs vs Loan Book';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        LoanApplication: Record "Loan Application";
        Member: Record "Member";
        AccountType: Record "Account Type";
        RSum: array[4] of Decimal;
        RCount: array[4] of Decimal;
        Vendor: Record "Vendor";

    local procedure IsDepositAccount(AccountTypeCode: Code[20]): Boolean
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Code, AccountTypeCode);
        AccountType.SETRANGE(Type, AccountType.Type::Deposit);
        EXIT(AccountType.FINDFIRST);
    end;

    local procedure IsSavingsAccount(AccountTypeCode: Code[20]): Boolean
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Code, AccountTypeCode);
        AccountType.SETRANGE(Type, AccountType.Type::Savings);
        EXIT(AccountType.FINDFIRST);
    end;
}

