page 50786 "Procurement Vendor Card"
{
    // version NAVW111.00

    Caption = 'Vendor Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval,New Document,Navigate,Incoming Documents';
    RefreshOnActivate = true;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                    Visible = NoFieldVisible;

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies which transactions with the vendor that cannot be posted.';
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = Basic, All;
                    Importance = Additional;
                    ToolTip = 'Specifies when the vendor card was last modified.';
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all completed purchase invoices and credit memos.';

                    trigger OnDrillDown();
                    begin
                        OpenVendorLedgerEntries(FALSE);
                    end;
                }
                field("Balance Due (LCY)"; "Balance Due (LCY)")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies the total value of your unpaid purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all open purchase invoices and credit memos.';

                    trigger OnDrillDown();
                    begin
                        OpenVendorLedgerEntries(TRUE);
                    end;
                }
                field("Document Sending Profile"; "Document Sending Profile")
                {
                    ApplicationArea = Basic, All;
                    Importance = Additional;
                    ToolTip = 'Specifies the preferred method of sending documents to this vendor, so that you do not have to select a sending option every time that you post and send a document to the vendor. Documents to this vendor will be sent using the specified sending profile and will override the default document sending profile.';
                }
                field("Search Name"; "Search Name")
                {
                    ApplicationArea = Advanced;
                    Importance = Additional;
                    ToolTip = 'Specifies a search name.';
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                    ApplicationArea = Intercompany;
                    Importance = Additional;
                    ToolTip = 'Specifies the vendor''s IC partner code, if the vendor is one of your intercompany partners.';
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                    ApplicationArea = Advanced;
                    Importance = Additional;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = Advanced;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the responsibility center that will administer this vendor by default.';
                }
            }
            group("Address & Contact")
            {
                Caption = 'Address & Contact';
                group(Address_)
                {
                    Caption = 'Address';
                    field(Address; Address)
                    {
                        ApplicationArea = Basic, All;
                        ToolTip = 'Specifies the vendor''s address.';
                    }
                    field("Address 2"; "Address 2")
                    {
                        ApplicationArea = Basic, All;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Post Code"; "Post Code")
                    {
                        ApplicationArea = Basic, All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field(City; City)
                    {
                        ApplicationArea = Basic, All;
                        ToolTip = 'Specifies the vendor''s city.';
                    }
                    field("Country/Region Code"; "Country/Region Code")
                    {
                        ApplicationArea = Basic, All;
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field(ShowMap; ShowMapLbl)
                    {
                        ApplicationArea = Advanced;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = TRUE;
                        ToolTip = 'Specifies you can view the customer''s address on your preferred map website.';

                        trigger OnDrillDown();
                        begin
                            CurrPage.UPDATE(TRUE);
                            DisplayMap;
                        end;
                    }
                }
                group(Contact_)
                {
                    Caption = 'Contact';
                    field("Primary Contact No."; "Primary Contact No.")
                    {
                        ApplicationArea = Basic, All;
                        Caption = 'Primary Contact Code';
                        ToolTip = 'Specifies the primary contact number for the customer.';
                    }
                    field(Contact; Contact)
                    {
                        ApplicationArea = Basic, All;
                        Editable = ContactEditable;
                        Importance = Promoted;
                        ToolTip = 'Specifies the name of the person you regularly contact when you do business with this vendor.';

                        trigger OnValidate();
                        begin
                            //ContactOnAfterValidate;
                        end;
                    }
                    field("Phone No."; "Phone No.")
                    {
                        ApplicationArea = Basic, All;
                        ToolTip = 'Specifies the vendor''s telephone number.';
                    }
                    field("E-Mail"; "E-Mail")
                    {
                        ApplicationArea = Basic, All;
                        ExtendedDatatype = EMail;
                        Importance = Promoted;
                        ToolTip = 'Specifies the vendor''s email address.';
                    }
                    field("Fax No."; "Fax No.")
                    {
                        ApplicationArea = Advanced;
                        Importance = Additional;
                        ToolTip = 'Specifies the customer''s fax number.';
                    }
                    field("Home Page"; "Home Page")
                    {
                        ApplicationArea = Basic, All;
                        ToolTip = 'Specifies the vendor''s home page address.';
                    }
                    field("Our Account No."; "Our Account No.")
                    {
                        ApplicationArea = Basic, All;
                        ToolTip = 'Specifies your account number with the vendor, if you have one.';
                    }
                    field("Language Code"; "Language Code")
                    {
                        ApplicationArea = Basic, All;
                        Importance = Additional;
                        ToolTip = 'Specifies the language on printouts for this vendor.';
                    }
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies the vendor''s VAT registration number.';
                    /*
                        trigger OnDrillDown();
                      var
                            VATRegistrationLogMgt: Codeunit "249";
                        begin
                            VATRegistrationLogMgt.AssistEditVendorVATReg(Rec);
                        end; */
                }
                field(GLN; GLN)
                {
                    ApplicationArea = Basic, All;
                    Importance = Additional;
                    ToolTip = 'Specifies the vendor in connection with electronic document receiving.';
                }
                field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                    ApplicationArea = Basic, All;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of a different vendor whom you pay for products delivered by the vendor on the vendor card.';
                }
                field("Invoice Disc. Code"; "Invoice Disc. Code")
                {
                    ApplicationArea = Basic, All;
                    Importance = Additional;
                    NotBlank = true;
                    ToolTip = 'Specifies the vendor''s invoice discount code. When you set up a new vendor card, the number you have entered in the No. field is automatically inserted.';
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';
                }
                group("Posting Details")
                {
                    Caption = 'Posting Details';
                    field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                    {
                        ApplicationArea = Basic, All;
                        Importance = Additional;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
                    }
                    field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                    {
                        ApplicationArea = Basic, All;
                        Importance = Additional;
                        ToolTip = 'Specifies the vendor''s VAT specification to link transactions made for this vendor with the appropriate general ledger account according to the VAT posting setup.';
                    }
                    field("Vendor Posting Group"; "Vendor Posting Group")
                    {
                        ApplicationArea = Basic, All;
                        Importance = Additional;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the vendor''s market type to link business transactions made for the vendor with the appropriate account in the general ledger.';
                    }
                }
                group("Foreign Trade")
                {
                    Caption = 'Foreign Trade';
                    field("Currency Code"; "Currency Code")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        ToolTip = 'Specifies the currency code that is inserted by default when you create purchase documents or journal lines for the vendor.';
                    }
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Prepayment %"; "Prepayment %")
                {
                    ApplicationArea = Prepayments;
                    Importance = Additional;
                    ToolTip = 'Specifies a prepayment percentage that applies to all orders for this vendor, regardless of the items or services on the order lines.';
                }
                field("Application Method"; "Application Method")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies how to apply payments to entries for this vendor.';
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    ApplicationArea = Basic, All;
                    Importance = Promoted;
                    ToolTip = 'Specifies a code that indicates the payment terms that the vendor usually requires.';
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    ApplicationArea = Basic, All;
                    Importance = Promoted;
                    ToolTip = 'Specifies how the vendor requires you to submit payment, such as bank transfer or check.';
                }
                field(Priority; Priority)
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies the importance of the vendor when suggesting payments using the Suggest Vendor Payments function.';
                }
                field("Block Payment Tolerance"; "Block Payment Tolerance")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies if the vendor allows payment tolerance.';

                    trigger OnValidate();
                    begin
                        /* IF "Block Payment Tolerance" THEN BEGIN
                            IF CONFIRM(Text002, FALSE) THEN
                                PaymentToleranceMgt.DelTolVendLedgEntry(Rec);
                        END ELSE BEGIN
                            IF CONFIRM(Text001, FALSE) THEN
                                PaymentToleranceMgt.CalcTolVendLedgEntry(Rec);
                        END; */
                    end;
                }
                field("Preferred Bank Account Code"; "Preferred Bank Account Code")
                {
                    ApplicationArea = Basic, All;
                    ToolTip = 'Specifies the vendor bank account that will be used by default on payment journal lines for export to a payment bank file.';
                }
                field("Bank Code"; "Bank Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("KBA Code"; "KBA Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Bank Account"; "Bank Account")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Partner Type"; "Partner Type")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies if the vendor is a person or a company.';
                }
                field("Cash Flow Payment Terms Code"; "Cash Flow Payment Terms Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies a payment term that will be used for calculating cash flow.';
                }
                field("Creditor No."; "Creditor No.")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the number of the vendor.';
                }
            }
            group(Receiving)
            {
                Caption = 'Receiving';
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Location;
                    Importance = Promoted;
                    ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = Advanced;
                    Importance = Promoted;
                    ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    ApplicationArea = Advanced;
                    Importance = Promoted;
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                }
                field("Base Calendar Code"; "Base Calendar Code")
                {
                    ApplicationArea = Advanced;
                    DrillDown = false;
                    ToolTip = 'Specifies the code for the vendor''s customized calendar.';
                }

            }
        }
        area(factboxes)
        {
            /*
            part(;786)
            {
                ApplicationArea = Basic,All;
                SubPageLink = No.=FIELD(No.);
                Visible = NOT IsOfficeAddin;
            }
            part(VendorStatisticsFactBox;9094)
            {
                ApplicationArea = All;
                SubPageLink = No.=FIELD(No.),
                              Currency Filter=FIELD(Currency Filter),
                              Date Filter=FIELD(Date Filter),
                              Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                              Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
            }
            part(AgedAccPayableChart;769)
            {
                ApplicationArea = Basic,All;
                SubPageLink = No.=FIELD(No.);
                Visible = IsOfficeAddin;
            }
            part(;875)
            {
                ApplicationArea = All;
                SubPageLink = Source Type=CONST(Vendor),
                              Source No.=FIELD(No.);
                Visible = SocialListeningVisible;
            }
            part(;876)
            {
                ApplicationArea = All;
                SubPageLink = Source Type=CONST(Vendor),
                              Source No.=FIELD(No.);
                UpdatePropagation = Both;
                Visible = SocialListeningSetupVisible;
            }
            part(VendorHistBuyFromFactBox;9095)
            {
                ApplicationArea = Basic,All;
                SubPageLink = No.=FIELD(No.),
                              Currency Filter=FIELD(Currency Filter),
                              Date Filter=FIELD(Date Filter),
                              Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                              Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
            }
            part(VendorHistPayToFactBox;9096)
            {
                ApplicationArea = All;
                SubPageLink = No.=FIELD(No.),
                              Currency Filter=FIELD(Currency Filter),
                              Date Filter=FIELD(Date Filter),
                              Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                              Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                Visible = false;
            }
            part(WorkflowStatus;1528)
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(;Links)
            {
            }
            systempart(;Notes)
            {
            }
            */
        }
    }

    actions
    {
        area(navigation)
        {
            group(Documents)
            {
                Caption = 'Documents';
                Image = Administration;

            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin

    end;

    trigger OnAfterGetRecord();
    begin
        ActivateFields;
    end;

    trigger OnInit();
    begin
        //SetVendorNoVisibilityOnFactBoxes;

        ContactEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    var
    // DocumentNoVisibility : Codeunit "1400";
    begin
        /* IF GUIALLOWED THEN BEGIN
          IF "No." = '' THEN BEGIN
            IF DocumentNoVisibility.VendorNoSeriesIsDefault THEN BEGIN
              NewMode := TRUE;
            END;
            END;
            END; */
    end;

    trigger OnOpenPage();
    var
    //PermissionManager : Codeunit "9002";
    begin
        /*  ActivateFields;
         IsOfficeAddin := OfficeMgt.IsAvailable;
         SetNoFieldVisible;
         IsSaaS := PermissionManager.SoftwareAsAService; */
    end;

    var
        /*         CustomizedCalEntry : Record "7603";
                CustomizedCalendar : Record "7602";
                OfficeMgt : Codeunit "1630";
                CalendarMgmt : Codeunit "7600";
                PaymentToleranceMgt : Codeunit "426";
                WorkflowWebhookManagement : Codeunit "1543"; */
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Text001: Label 'Do you want to allow payment tolerance for entries that are currently open?';
        Text002: Label 'Do you want to remove payment tolerance from entries that are currently open?';
        [InDataSet]
        ContactEditable: Boolean;
        [InDataSet]
        SocialListeningSetupVisible: Boolean;
        [InDataSet]
        SocialListeningVisible: Boolean;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        ShowMapLbl: Label 'Show on Map';
        IsOfficeAddin: Boolean;
        CanCancelApprovalForRecord: Boolean;
        SendToOCREnabled: Boolean;
        SendToOCRVisible: Boolean;
        SendToIncomingDocEnabled: Boolean;
        SendIncomingDocApprovalRequestVisible: Boolean;
        SendToIncomingDocumentVisible: Boolean;
        NoFieldVisible: Boolean;
        NewMode: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        IsSaaS: Boolean;

    local procedure ActivateFields();
    begin
        /*  SetSocialListeningFactboxVisibility;
         ContactEditable := "Primary Contact No." = '';
         IF OfficeMgt.IsAvailable THEN
           ActivateIncomingDocumentsFields; */
    end;

    /*     local procedure ContactOnAfterValidate();
        begin
            ActivateFields;
        end;

        local procedure SetSocialListeningFactboxVisibility();
        var
            SocialListeningMgt : Codeunit "871";
        begin
            SocialListeningMgt.GetVendFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
        end;

        local procedure SetVendorNoVisibilityOnFactBoxes();
        begin
            CurrPage.VendorHistBuyFromFactBox.PAGE.SetVendorNoVisibility(FALSE);
            CurrPage.VendorHistPayToFactBox.PAGE.SetVendorNoVisibility(FALSE);
            CurrPage.VendorStatisticsFactBox.PAGE.SetVendorNoVisibility(FALSE);
        end;

        local procedure RunReport(ReportNumber : Integer);
        var
            Vendor : Record "23";
        begin
            Vendor.SETRANGE("No.","No.");
            REPORT.RUNMODAL(ReportNumber,TRUE,TRUE,Vendor);
        end;

        local procedure ActivateIncomingDocumentsFields();
        var
            IncomingDocument : Record "130";
        begin
            IF OfficeMgt.OCRAvailable THEN BEGIN
              SendToIncomingDocumentVisible := TRUE;
              SendToIncomingDocEnabled := OfficeMgt.EmailHasAttachments;
              SendToOCREnabled := OfficeMgt.EmailHasAttachments;
              SendToOCRVisible := IncomingDocument.OCRIsEnabled AND NOT IsIncomingDocApprovalsWorkflowEnabled;
              SendIncomingDocApprovalRequestVisible := IsIncomingDocApprovalsWorkflowEnabled;
            END;
        end;

        local procedure IsIncomingDocApprovalsWorkflowEnabled() : Boolean;
        var
            WorkflowEventHandling : Codeunit "1520";
            WorkflowDefinition : Query "1502";
        begin
            WorkflowDefinition.SETRANGE(Table_ID,DATABASE::"Incoming Document");
            WorkflowDefinition.SETRANGE(Entry_Point,TRUE);
            WorkflowDefinition.SETRANGE(Enabled,TRUE);
            WorkflowDefinition.SETRANGE(Type,WorkflowDefinition.Type::"Event");
            WorkflowDefinition.SETRANGE(Function_Name,WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode);
            WorkflowDefinition.OPEN;
            WHILE WorkflowDefinition.READ DO
              EXIT(TRUE);

            EXIT(FALSE);
        end; 

        local procedure CreateVendorFromTemplate();
        var
            MiniVendorTemplate : Record "1303";
            Vendor : Record "23";
            VATRegNoSrvConfig : Record "248";
            EUVATRegistrationNoCheck : Page "1339";
                                           VendorRecRef : RecordRef;
        begin
            IF NewMode THEN BEGIN
              IF MiniVendorTemplate.NewVendorFromTemplate(Vendor) THEN BEGIN
                IF VATRegNoSrvConfig.VATRegNoSrvIsEnabled THEN
                  IF Vendor."Validate EU Vat Reg. No." THEN BEGIN
                    EUVATRegistrationNoCheck.SetRecordRef(Vendor);
                    COMMIT;
                    EUVATRegistrationNoCheck.RUNMODAL;
                    EUVATRegistrationNoCheck.GetRecordRef(VendorRecRef);
                    VendorRecRef.SETTABLE(Vendor);
                  END;
                COPY(Vendor);
                CurrPage.UPDATE;
              END;
              NewMode := FALSE;
            END;
        end;

        local procedure SetNoFieldVisible();
        var
            DocumentNoVisibility : Codeunit "1400";
        begin
            NoFieldVisible := DocumentNoVisibility.VendorNoIsVisible;
        end;
        */
}

