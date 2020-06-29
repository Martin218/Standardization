report 50000 "Cheque Books"
{
    // version CTS2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/Cheque Books.rdlc';

    dataset
    {
        dataitem("Cheque Book"; "Cheque Book")
        {
            RequestFilterFields = Status, "Member No.", Active, "Created By", "Created Date", "Issued By", "Issued Date", "Global Dimension 1 Code";
            column(No_ChequeBookHeader; "Cheque Book"."No.")
            {
            }
            column(SerialNo_ChequeBookHeader; "Cheque Book"."Serial No.")
            {
            }
            column(MemberNo_ChequeBookHeader; "Cheque Book"."Member No.")
            {
            }
            column(NoofLeaves_ChequeBookHeader; "Cheque Book"."No. of Leaves")
            {
            }
            column(LastLeafUsed_ChequeBookHeader; "Cheque Book"."Last Leaf Used")
            {
            }
            column(StartLeafNo_ChequeBookHeader; "Cheque Book"."Start Leaf No.")
            {
            }
            column(EndLeafNo_ChequeBookHeader; "Cheque Book"."End Leaf No.")
            {
            }
            column(MemberName_ChequeBookHeader; "Cheque Book"."Member Name")
            {
            }
            column(GlobalDimension1Code_ChequeBookHeader; "Cheque Book"."Global Dimension 1 Code")
            {
            }
            column(NoSeries_ChequeBookHeader; "Cheque Book"."No. Series")
            {
            }
            column(Status_ChequeBookHeader; "Cheque Book".Status)
            {
            }

            column(AccountNo_ChequeBookHeader; "Cheque Book"."Account No.")
            {
            }
            column(AccountName_ChequeBookHeader; "Cheque Book"."Account Name")
            {
            }
            column(Active_ChequeBookHeader; "Cheque Book".Active)
            {
            }
            column(IssuedDate_ChequeBookHeader; "Cheque Book"."Issued Date")
            {
            }
            column(IssuedBy_ChequeBookHeader; "Cheque Book"."Issued By")
            {
            }
            column(IssuedTime_ChequeBookHeader; "Cheque Book"."Issued Time")
            {
            }
            column(CreatedBy_ChequeBookHeader; "Cheque Book"."Created By")
            {
            }
            column(CreatedDate_ChequeBookHeader; "Cheque Book"."Created Date")
            {
            }
            column(CreatedTime_ChequeBookHeader; "Cheque Book"."Created Time")
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(Picture; CompanyInfo.Picture)
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
        ReportTitle = 'Cheque Books Register';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}

