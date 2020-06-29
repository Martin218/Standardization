report 50002 "CTS Entries"
{
    // version CTS2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/CTS Entries.rdlc';

    dataset
    {
        dataitem("CTS Entry"; "CTS Entry")
        {
            RequestFilterFields = "Clearance Date", "Member No.", "Paid Date", "Global Dimension 1 Code";
            column(ClearanceNo_CTSEntry; "CTS Entry"."Document No.")
            {
            }
            column(ChequeNo_CTSEntry; "CTS Entry"."Cheque No.")
            {
            }
            column(AccountNo_CTSEntry; "CTS Entry"."Account No.")
            {
            }
            column(AccountName_CTSEntry; "CTS Entry"."Account Name")
            {
            }
            column(MemberNo_CTSEntry; "CTS Entry"."Member No.")
            {
            }
            column(MemberName_CTSEntry; "CTS Entry"."Member Name")
            {
            }
            column(ClearanceDate_CTSEntry; "CTS Entry"."Clearance Date")
            {
            }
            column(AmountToPay_CTSEntry; "CTS Entry"."Amount To Pay")
            {
            }
            column(Paid_CTSEntry; "CTS Entry".Paid)
            {
            }

            column(GlobalDimension1Code_CTSEntry; "CTS Entry"."Global Dimension 1 Code")
            {
            }
            column(Description_CTSEntry; "CTS Entry".Description)
            {
            }
            column(UnpaidReason_CTSEntry; "CTS Entry"."Unpaid Reason")
            {
            }
            column(UnpaidCode_CTSEntry; "CTS Entry"."Unpaid Code")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
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
        ReportTitle = 'CTS Entries';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}

