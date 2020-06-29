report 50512 "Goods Received Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Procurement\GoodsReceivedReport.rdlc';
    Caption = '"Goods Received Note "';

    dataset
    {
        dataitem(DataItem1; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyInfoBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyInfoAddress; CompanyInfo.Address)
            {
            }
            column(CompanyInfoCity; CompanyInfo.City)
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfoPostal; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(BuyfromVendorNo_PurchRcptHeader; "Buy-from Vendor No.")
            {
            }
            column(No_PurchRcptHeader; "No.")
            {
            }
            column(PaytoVendorNo_PurchRcptHeader; "Pay-to Vendor No.")
            {
            }
            column(PaytoName_PurchRcptHeader; "Pay-to Name")
            {
            }
            column(PaytoAddress_PurchRcptHeader; "Pay-to Address")
            {
            }
            column(PaytoCity_PurchRcptHeader; "Pay-to City")
            {
            }
            column(OrderDate_PurchRcptHeader; "Order Date")
            {
            }
            column(PostingDate_PurchRcptHeader; "Posting Date")
            {
            }
            column(PostingDescription_PurchRcptHeader; "Posting Description")
            {
            }
            dataitem(DataItem11; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Type_PurchRcptLine; Type)
                {
                }
                column(DocumentNo_PurchRcptLine; "Document No.")
                {
                }
                column(No_PurchRcptLine; "No.")
                {
                }
                column(Description_PurchRcptLine; Description)
                {
                }
                column(UnitofMeasure_PurchRcptLine; "Unit of Measure")
                {
                }
                column(Quantity_PurchRcptLine; Quantity)
                {
                }
                column(DirectUnitCost_PurchRcptLine; "Direct Unit Cost")
                {
                }
                column(UnitCostLCY_PurchRcptLine; "Unit Cost (LCY)")
                {
                }
                column(PhoneNoCaption; PhoneNoCaptionLbl)
                {
                }
                column(HomePageCaption; HomePageCaptionLbl)
                {
                }
                column(VATRegNoCaption; VATRegNoCaptionLbl)
                {
                }
                column(GiroNoCaption; GiroNoCaptionLbl)
                {
                }
                column(BankNameCaption; BankNameCaptionLbl)
                {
                }
                column(AccNoCaption; AccNoCaptionLbl)
                {
                }
                column(UOMCaptionLbl; UOMCaptionLbl)
                {
                }
                column(QtyCaptionLbl; QtyCaptionLbl)
                {
                }
                column(DescCaptionLbl; DescCaptionLbl)
                {
                }
                column(PaytoVenNoCaptionLbl; PaytoVenNoCaptionLbl)
                {
                }
                column(VendorNameCaptionLbl; VendorNameCaptionLbl)
                {
                }
                column(ItemNoCaptionLbl; ItemNoCaptionLbl)
                {
                }
                column(PayToVenAddCaptionLbl; PayToVenAddCaptionLbl)
                {
                }
                column(DocDateCaptionLbl; DocDateCaptionLbl)
                {
                }
                column(TotalCaptionLbl; TotalCaptionLbl)
                {
                }
                column(Signature1CaptionLbl; Signature1CaptionLbl)
                {
                }
                column(ReceivedByCaptionLbl; ReceivedByCaptionLbl)
                {
                }
                column(BroughtByCaptionLbl; BroughtByCaptionLbl)
                {
                }
                column(DashCaptionLbl; DashCaptionLbl)
                {
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
        ReportTitle = 'Goods Received Note';
    }

    trigger OnInitReport();
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        Text002: TextConst Comment = '%1 = Document No.', ENU = 'Purchase - Receipt %1';
        Text003: Label 'Page %1';
        PhoneNoCaptionLbl: Label 'Phone No.';
        HomePageCaptionLbl: Label 'Home Page';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        AccNoCaptionLbl: Label 'Account No.';
        DocDateCaptionLbl: Label 'Document Date';
        PageCaptionLbl: Label 'Page';
        DescCaptionLbl: Label 'Description';
        QtyCaptionLbl: Label 'Quantity';
        UOMCaptionLbl: Label 'Unit Of Measure';
        PaytoVenNoCaptionLbl: Label 'Vendor No.';
        EmailCaptionLbl: Label 'Email';
        VendorNameCaptionLbl: Label 'Vendor Name';
        ItemNoCaptionLbl: Label 'No.';
        PayToVenAddCaptionLbl: Label 'Vendor Address';
        TotalCaptionLbl: Label 'Total';
        Signature1CaptionLbl: Label 'Signature';
        ReceivedByCaptionLbl: Label 'Received By';
        BroughtByCaptionLbl: Label 'Delivered By';
        DashCaptionLbl: Label '.............................';
}

