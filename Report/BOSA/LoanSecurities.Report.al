report 50075 "Loan Securities"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Report/BOSA/Loan Securities.rdlc';
    ApplicationArea = All;
    dataset
    {

        dataitem("Loan Security"; "Loan Security")
        {

            column(LoanNo_LoanSecurity; "Loan No.")
            {
            }
            column(LineNo_LoanSecurity; "Line No.")
            {
            }
            column(SecurityCode_LoanSecurity; "Security Code")
            {
            }
            column(Description_LoanSecurity; Description)
            {
            }
            column(SecurityValue_LoanSecurity; "Security Value")
            {
            }
            column(GuaranteedAmount_LoanSecurity; "Guaranteed Amount")
            {
            }
            column(SecurityFactor_LoanSecurity; "Security Factor")
            {
            }
            column(DataText_1; DataText[1])
            {
            }
            column(DataText_2; DataText[2])
            {
            }
            column(DataText_3; DataText[3])
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF LoanApplication.GET("Loan No.") THEN BEGIN
                    DataText[1] := LoanApplication.Description;
                    DataText[2] := LoanApplication."Member No.";
                    DataText[3] := LoanApplication."Member Name";
                END ELSE
                    CurrReport.SKIP;
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
        ReportTitle = 'Loan Securities';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        DataText: array[4] of Text;
        LoanApplication: Record "Loan Application";
}

