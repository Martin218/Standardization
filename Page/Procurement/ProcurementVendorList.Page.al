page 50785 "Procurement Vendor List"
{
    // version NAVW111.00

    Caption = 'Vendors';
    CardPageID = "Procurement Vendor Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,New Document,Vendor';
    RefreshOnActivate = true;
    SourceTable = Vendor;
    //SourceTableView = WHERE("Vendor Type" = FILTER('Normal'));

    layout
    {
        area(content)
        {
            repeater(group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies the postal code.';
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies the vendor''s telephone number.';
                }
                field("Fax No."; "Fax No.")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies the vendor''s fax number.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Documents)
            {
                /*
                Caption = 'Documents';
                Image = Administration;
                action(Quotes)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Quotes';
                    Image = Quote;
                    RunObject = Page 9306;
                    RunPageLink = Buy-from Vendor No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Buy-from Vendor No.);
                    ToolTip = 'View a list of ongoing sales quotes.';
                }
                action(Orders)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page 9307;
                    RunPageLink = Buy-from Vendor No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Buy-from Vendor No.);
                    ToolTip = 'View a list of ongoing purchase orders for the vendor.';
                }
                action("Return Orders")
                {
                    ApplicationArea = PurchReturnOrder;
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page 9311;
                    RunPageLink = Buy-from Vendor No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Buy-from Vendor No.);
                    ToolTip = 'Open the list of ongoing return orders.';
                }
                action("Blanket Orders")
                {
                    ApplicationArea = Advanced;
                    Caption = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page 9310;
                    RunPageLink = Buy-from Vendor No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Buy-from Vendor No.);
                    ToolTip = 'Open the list of ongoing blanket orders.';
                }
                */
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {

                }
                /*
                */
            }
        }
    }


    trigger OnAfterGetCurrRecord();
    begin
        /*
        SetSocialListeningFactboxVisibility;
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);

        // Contextual Power BI FactBox: send data to filter the report in the FactBox
        */
    end;

    trigger OnAfterGetRecord();
    begin
        FILTERGROUP(1);
        Rec.RESET;
        FILTERGROUP(2);
    end;

    trigger OnInit();
    begin
        //SetVendorNoVisibilityOnFactBoxes;
    end;

    trigger OnOpenPage();
    begin

        //ResyncVisible := ReadSoftOCRMasterDataSync.IsSyncEnabled;
    end;

    var
        /*
            PowerBIUserConfiguration : Record "6304";
            SetPowerBIUserConfig : Codeunit "6305";
            ApprovalsMgmt : Codeunit "1535";
            ReadSoftOCRMasterDataSync : Codeunit "884";
            WorkflowWebhookManagement : Codeunit "1543";
            [InDataSet]
            SocialListeningSetupVisible : Boolean;
            [InDataSet]
            SocialListeningVisible : Boolean;
            OpenApprovalEntriesExist : Boolean;
            CanCancelApprovalForRecord : Boolean;
            PowerBIVisible : Boolean;
            ResyncVisible : Boolean;
            CanRequestApprovalForFlow : Boolean;
            CanCancelApprovalForFlow : Boolean;
            */
        ProcurementManagement: Codeunit "Procurement Management";
        Vendor2: Record Vendor;
        ProcurementRequest: Record "Procurement Request";
    //[Scope('Personalization')]
    /*    procedure GetSelectionFilter(): Text;
    var
        Vend: Record "23";
        SelectionFilterManagement: Codeunit "46";
    begin
        CurrPage.SETSELECTIONFILTER(Vend);
        EXIT(SelectionFilterManagement.GetSelectionFilterForVendor(Vend));
    end;

    [Scope('Personalization')]
    procedure SetSelection(var Vend: Record "23");
    begin
        CurrPage.SETSELECTIONFILTER(Vend);
    end;

    local procedure SetSocialListeningFactboxVisibility();
    var
        SocialListeningMgt: Codeunit "871";
    begin
        SocialListeningMgt.GetVendFactboxVisibility(Rec, SocialListeningSetupVisible, SocialListeningVisible);
    end;

    local procedure SetVendorNoVisibilityOnFactBoxes();
    begin
    end;
    */
    //[Scope('Personalization')]
    procedure UpdateSupplierSelection(Vendor: Record Vendor; ProcessNo: Code[10]);
    begin
        CurrPage.SETSELECTIONFILTER(Rec);
        //ProcurementManagement.
        Rec.MARKEDONLY(TRUE);
        IF Rec.FINDSET THEN BEGIN
            REPEAT
                ProcurementManagement.MakeVendorSelectionEntries(Rec, ProcessNo);
            UNTIL Rec.NEXT = 0;
            /*IF ProcurementRequest.GET(ProcessNo) THEN BEGIN
              ProcurementManagement.ViewSelectedSuppliers(ProcurementRequest,4);
            END;
            */
        END;

    end;
}

