report 50001 "Cheque Clearance"
{
    // version CTS2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/Cheque Clearance.rdlc';

    dataset
    {
        dataitem("Cheque Clearance Header"; "Cheque Clearance Header")
        {
            RequestFilterFields = "No.", "Created By", "Created Date", "Cleared By", "Cleared Date";
            column(CreatedDate_ChequeClearanceHeader; "Cheque Clearance Header"."Created Date")
            {
            }
            column(CreatedBy_ChequeClearanceHeader; "Cheque Clearance Header"."Created By")
            {
            }
            column(CreatedTime_ChequeClearanceHeader; "Cheque Clearance Header"."Created Time")
            {
            }
            column(ApprovedBy_ChequeClearanceHeader; "Cheque Clearance Header"."Approved By")
            {
            }
            column(ApprovedDate_ChequeClearanceHeader; "Cheque Clearance Header"."Approved Date")
            {
            }
            column(ClearedBy_ChequeClearanceHeader; "Cheque Clearance Header"."Cleared By")
            {
            }
            column(ClearedDate_ChequeClearanceHeader; "Cheque Clearance Header"."Cleared Date")
            {
            }
            column(ClearedTime_ChequeClearanceHeader; "Cheque Clearance Header"."Cleared Time")
            {
            }
            dataitem("Cheque Clearance Line"; "Cheque Clearance Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                RequestFilterFields = "Global Dimension 1 Code", Indicator, "Member No.", Validated;
                column(DocumentNo_ChequeClearanceLine; "Cheque Clearance Line"."Document No.")
                {
                }
                column(LineNo_ChequeClearanceLine; "Cheque Clearance Line"."Line No.")
                {
                }
                column(AccountNo_ChequeClearanceLine; "Cheque Clearance Line"."Account No.")
                {
                }
                column(SerialNo_ChequeClearanceLine; "Cheque Clearance Line"."Serial No.")
                {
                }
                column(SortCode_ChequeClearanceLine; "Cheque Clearance Line"."Sort Code")
                {
                }
                column(Amount_ChequeClearanceLine; "Cheque Clearance Line".Amount)
                {
                }
                column(VoucherType_ChequeClearanceLine; "Cheque Clearance Line"."Voucher Type")
                {
                }
                column(PostingDate_ChequeClearanceLine; "Cheque Clearance Line"."Posting Date")
                {
                }
                column(ProcessingDate_ChequeClearanceLine; "Cheque Clearance Line"."Processing Date")
                {
                }
                column(Indicator_ChequeClearanceLine; "Cheque Clearance Line".Indicator)
                {
                }
                column(UnpaidReason_ChequeClearanceLine; "Cheque Clearance Line"."Unpaid Reason")
                {
                }
                column(UnpaidCode_ChequeClearanceLine; "Cheque Clearance Line"."Unpaid Code")
                {
                }
                column(PresentingBank_ChequeClearanceLine; "Cheque Clearance Line"."Presenting Bank")
                {
                }
                column(CurrencyCode_ChequeClearanceLine; "Cheque Clearance Line"."Currency Code")
                {
                }
                column(Session_ChequeClearanceLine; "Cheque Clearance Line".Session)
                {
                }
                column(BankNo_ChequeClearanceLine; "Cheque Clearance Line"."Bank No.")
                {
                }
                column(BranchNo_ChequeClearanceLine; "Cheque Clearance Line"."Branch No.")
                {
                }
                column(SaccoAccountNo_ChequeClearanceLine; "Cheque Clearance Line"."Sacco Account No.")
                {
                }
                column(Validated_ChequeClearanceLine; "Cheque Clearance Line".Validated)
                {
                }
                column(MemberNo_ChequeClearanceLine; "Cheque Clearance Line"."Member No.")
                {
                }
                column(MemberName_ChequeClearanceLine; "Cheque Clearance Line"."Member Name")
                {
                }

                column(GlobalDimension1Code_ChequeClearanceLine; "Cheque Clearance Line"."Global Dimension 1 Code")
                {
                }
                column(Description_ChequeClearanceLine; "Cheque Clearance Line".Description)
                {
                }
                column(Picture; CompanyInfo.Picture)
                {
                }
                column(Name; CompanyInfo.Name)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ChequeClearanceHeader.GET("Cheque Clearance Line"."Document No.");
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
        ReportTitle = 'Cheque Clearance';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        ChequeClearanceHeader: Record "Cheque Clearance Header";
}

