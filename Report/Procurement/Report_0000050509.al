/* report 50509 "Phys. Inventory Report"
{
    // version NAVW111.00

    DefaultLayout = RDLC;
    RDLCLayout = './Phys. Inventory Report.rdlc';
    Caption = 'Phys. Inventory List';

    dataset
    {
        dataitem(PageLoop; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(CompanyName; COMPANYPROPERTY.DISPLAYNAME)
            {
            }
            column(ShowLotSN; ShowLotSN)
            {
            }
            column(CaptionFilter_ItemJnlBatch; "Item Journal Batch".TABLECAPTION + ': ' + ItemJnlBatchFilter)
            {
            }
            column(ItemJnlBatchFilter; ItemJnlBatchFilter)
            {
            }
            column(CaptionFilter_ItemJnlLine; "Item Journal Line".TABLECAPTION + ': ' + ItemJnlLineFilter)
            {
            }
            column(ItemJnlLineFilter; ItemJnlLineFilter)
            {
            }
            column(ShowQtyCalculated; ShowQtyCalculated)
            {
            }
            column(Note1; Note1Lbl)
            {
            }
            column(SummaryPerItem; SummaryPerItemLbl)
            {
            }
            column(ShowNote; ShowNote)
            {
            }
            column(PhysInventoryListCaption; PhysInventoryListCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(ItemJnlLinePostDtCaption; ItemJnlLinePostDtCaptionLbl)
            {
            }
            column(GetShorDimCodeCaption1; CAPTIONCLASSTRANSLATE('1,1,1'))
            {
            }
            column(GetShorDimCodeCaption2; CAPTIONCLASSTRANSLATE('1,1,2'))
            {
            }
            column(QtyPhysInventoryCaption; QtyPhysInventoryCaptionLbl)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(CompanyInformation_Postal_Code; CompanyInformation."Post Code")
            {
            }
            dataitem(DataItem8780; Table233)
            {
                RequestFilterFields = "Journal Template Name", Name;
                column(TemplateName_ItemJnlBatch; "Journal Template Name")
                {
                }
                column(Name_ItemJournalBatch; Name)
                {
                }
                dataitem(DataItem8280; Table83)
                {
                    DataItemLink = Journal Template Name=FIELD(Journal Template Name),
                                   Journal Batch Name=FIELD(Name);
                    DataItemTableView = SORTING(Journal Template Name,Journal Batch Name,Line No.);
                    RequestFilterFields = "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Location Code","Bin Code";
                    column(PostingDt_ItemJournalLine;FORMAT("Posting Date"))
                    {
                    }
                    column(DocNo_ItemJournalLine;"Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_ItemJournalLine;"Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Desc_ItemJournalLine;Description)
                    {
                        IncludeCaption = true;
                    }
                    column(ShotcutDim1Code_ItemJnlLin;"Shortcut Dimension 1 Code")
                    {
                    }
                    column(ShotcutDim2Code_ItemJnlLin;"Shortcut Dimension 2 Code")
                    {
                    }
                    column(LocCode_ItemJournalLine;"Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(QtyCalculated_ItemJnlLin;"Qty. (Calculated)")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_ItemJournalLine;"Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Note;Note)
                    {
                    }
                    column(ShowSummary;ShowSummary)
                    {
                    }
                    column(LineNo_ItemJournalLine;"Line No.")
                    {
                    }
                    dataitem(ItemTrackingSpecification;Table2000000026)
                    {
                        DataItemTableView = SORTING(Number);
                        column(LotNoCaption;GetLotNoCaption)
                        {
                        }
                        column(SerialNoCaption;GetSerialNoCaption)
                        {
                        }
                        column(QuantityBaseCaption;GetQuantityBaseCaption)
                        {
                        }
                        column(ReservEntryBufferLotNo;ReservEntryBuffer."Lot No.")
                        {
                        }
                        column(ReservEntryBufferSerialNo;ReservEntryBuffer."Serial No.")
                        {
                        }
                        column(ReservEntryBufferQtyBase;ReservEntryBuffer."Quantity (Base)")
                        {
                            DecimalPlaces = 0:0;
                        }
                        column(SummaryperItemCaption;SummaryperItemCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            IF Number = 1 THEN
                              ReservEntryBuffer.FINDSET
                            ELSE
                              ReservEntryBuffer.NEXT;
                        end;

                        trigger OnPreDataItem();
                        begin
                            ReservEntryBuffer.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name");
                            ReservEntryBuffer.SETRANGE("Source ID","Item Journal Line"."Journal Template Name");
                            ReservEntryBuffer.SETRANGE("Source Ref. No.","Item Journal Line"."Line No.");
                            ReservEntryBuffer.SETRANGE("Source Type",DATABASE::"Item Journal Line");
                            ReservEntryBuffer.SETFILTER("Source Subtype",'=%1',ReservEntryBuffer."Source Subtype"::"0");
                            ReservEntryBuffer.SETRANGE("Source Batch Name","Item Journal Line"."Journal Batch Name");

                            IF ReservEntryBuffer.ISEMPTY THEN
                              CurrReport.BREAK;
                            SETRANGE(Number,1,ReservEntryBuffer.COUNT);

                            GetLotNoCaption := ReservEntryBuffer.FIELDCAPTION("Lot No.");
                            GetSerialNoCaption := ReservEntryBuffer.FIELDCAPTION("Serial No.");
                            GetQuantityBaseCaption := ReservEntryBuffer.FIELDCAPTION("Quantity (Base)");
                        end;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        IF ShowLotSN THEN BEGIN
                          Note := '';
                          ShowSummary := FALSE;
                          IF "Bin Code" <> '' THEN
                            IF NOT WhseTrckg("Item No.") THEN BEGIN
                              Note := NoteTxt;
                              ShowSummary := TRUE;
                            END;
                          CLEAR(ReservEntryBuffer);
                        END;
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    IF ItemJournalTemplate.GET("Journal Template Name") THEN
                      IF ItemJournalTemplate.Type <> ItemJournalTemplate.Type::"Phys. Inventory" THEN
                        CurrReport.SKIP;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowCalculatedQty;ShowQtyCalculated)
                    {
                        ApplicationArea = Advanced;
                        Caption = 'Show Qty. (Calculated)';
                        ToolTip = 'Specifies if you want the report to show the calculated quantity of the items.';
                    }
                    field(ShowSerialLotNumber;ShowLotSN)
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Show Serial/Lot Number';
                        ToolTip = 'Specifies if you want the report to show lot and serial numbers.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    trigger OnPreReport();
    begin
        ItemJnlLineFilter := "Item Journal Line".GETFILTERS;
        ItemJnlBatchFilter := "Item Journal Batch".GETFILTERS;
        IF ShowLotSN THEN BEGIN
          ShowNote := FALSE;
          ItemJnlLine.COPYFILTERS("Item Journal Line");
          "Item Journal Batch".COPYFILTER("Journal Template Name",ItemJnlLine."Journal Template Name");
          "Item Journal Batch".COPYFILTER(Name,ItemJnlLine."Journal Batch Name");
          CreateSNLotEntries(ItemJnlLine);
        END;
    end;

    var
        ItemJournalTemplate : Record "82";
        ItemJnlLine : Record "83";
        ItemTrackingCode : Record "6502";
        ReservEntryBuffer : Record "337" temporary;
        ItemJnlLineFilter : Text;
        ItemJnlBatchFilter : Text;
        Note : Text[1];
        ShowQtyCalculated : Boolean;
        ShowLotSN : Boolean;
        ShowNote : Boolean;
        ShowSummary : Boolean;
        NoteTxt : Label '*', Comment='{locked}';
        EntryNo : Integer;
        GetLotNoCaption : Text[80];
        GetSerialNoCaption : Text[80];
        GetQuantityBaseCaption : Text[80];
        Note1Lbl : Label '*Note:';
        SummaryPerItemLbl : Label 'Your system is set up to use Bin Mandatory and not SN/Lot Warehouse Tracking. Therefore, you will not see serial/lot numbers by bin but merely as a summary per item.';
        PhysInventoryListCaptionLbl : Label 'Phys. Inventory List';
        CurrReportPageNoCaptionLbl : Label 'Page';
        ItemJnlLinePostDtCaptionLbl : Label 'Posting Date';
        QtyPhysInventoryCaptionLbl : Label 'Qty. (Phys. Inventory)';
        SummaryperItemCaptionLbl : Label 'Summary per Item *';
        CompanyInformation : Record "79";

    [Scope('Personalization')]
    procedure Initialize(ShowQtyCalculated2 : Boolean);
    begin
        ShowQtyCalculated := ShowQtyCalculated2;
    end;

    local procedure CreateSNLotEntries(var ItemJnlLine : Record "83");
    begin
        EntryNo := 0;
        IF ItemJnlLine.FINDSET THEN
          REPEAT
            IF ItemJnlLine."Bin Code" <> '' THEN BEGIN
              IF WhseTrckg(ItemJnlLine."Item No.") THEN
                PickSNLotFromWhseEntry(ItemJnlLine."Item No.",
                  ItemJnlLine."Variant Code",ItemJnlLine."Location Code",ItemJnlLine."Bin Code",ItemJnlLine."Unit of Measure Code")
              ELSE BEGIN
                CreateSummary(ItemJnlLine);
                ShowNote := TRUE;
              END;
            END
            ELSE BEGIN
              IF DirectedPutAwayAndPick(ItemJnlLine."Location Code") THEN
                CreateSummary(ItemJnlLine)
              ELSE
                PickSNLotFromILEntry(ItemJnlLine."Item No.",ItemJnlLine."Variant Code",ItemJnlLine."Location Code");
            END;
          UNTIL ItemJnlLine.NEXT = 0;
    end;

    local procedure PickSNLotFromILEntry(ItemNo : Code[20];VariantCode : Code[10];LocationCode : Code[10]);
    var
        ItemLedgEntry : Record "32";
    begin
        ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code","Location Code");
        ItemLedgEntry.SETRANGE("Item No.",ItemNo);
        IF ItemJnlLine."Qty. (Phys. Inventory)" = 0 THEN  // Item Not on Inventory, show old SN/Lot
          ItemLedgEntry.SETRANGE(Open,FALSE)
        ELSE
          ItemLedgEntry.SETRANGE(Open,TRUE);
        ItemLedgEntry.SETRANGE("Variant Code",VariantCode);
        ItemLedgEntry.SETRANGE("Location Code",LocationCode);
        ItemLedgEntry.SETFILTER("Item Tracking",'<>%1',ItemLedgEntry."Item Tracking"::None);

        IF ItemLedgEntry.FINDSET THEN
          REPEAT
            CreateReservEntry(ItemJnlLine,ItemLedgEntry."Remaining Quantity",
              ItemLedgEntry."Serial No.",ItemLedgEntry."Lot No.",ItemLedgEntry."Item Tracking");
          UNTIL ItemLedgEntry.NEXT = 0;
    end;

    local procedure PickSNLotFromWhseEntry(ItemNo : Code[20];VariantCode : Code[10];LocationCode : Code[10];BinCode : Code[20];UnitOM : Code[10]);
    var
        WhseEntry : Record "7312";
        ItemTrackg : Option "None","Lot No.","Lot and Serial No.","Serial No.";
    begin
        WhseEntry.SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code",
          "Lot No.","Serial No.","Entry Type");
        WhseEntry.SETRANGE("Item No.",ItemNo);
        WhseEntry.SETRANGE("Bin Code",BinCode);
        WhseEntry.SETRANGE("Location Code",LocationCode);
        WhseEntry.SETRANGE("Variant Code",VariantCode);
        WhseEntry.SETRANGE("Unit of Measure Code",UnitOM);

        IF WhseEntry.FINDSET THEN
          REPEAT
            IF (WhseEntry."Lot No." <> '') AND (WhseEntry."Serial No." <> '') THEN
              CreateReservEntry(ItemJnlLine,WhseEntry."Qty. (Base)",
                WhseEntry."Serial No.",WhseEntry."Lot No.",ItemTrackg::"Lot and Serial No.")
            ELSE BEGIN
              IF WhseEntry."Lot No." <> '' THEN
                CreateReservEntry(ItemJnlLine,WhseEntry."Qty. (Base)",
                  WhseEntry."Serial No.",WhseEntry."Lot No.",ItemTrackg::"Lot No.");
              IF WhseEntry."Serial No." <> '' THEN
                CreateReservEntry(ItemJnlLine,WhseEntry."Qty. (Base)",
                  WhseEntry."Serial No.",WhseEntry."Lot No.",ItemTrackg::"Serial No.");
            END;
          UNTIL WhseEntry.NEXT = 0;
    end;

    local procedure CreateReservEntry(ItemJournalLine : Record "83";Qty : Decimal;SerialNo : Code[20];LotNo : Code[20];ItemTracking : Option "None","Lot No.","Lot and Serial No.","Serial No.");
    var
        FoundRec : Boolean;
    begin
        ReservEntryBuffer.SETCURRENTKEY(
          "Item No.","Variant Code","Location Code","Item Tracking","Reservation Status","Lot No.","Serial No.");
        ReservEntryBuffer.SETRANGE("Item No.",ItemJournalLine."Item No.");
        ReservEntryBuffer.SETRANGE("Variant Code",ItemJournalLine."Variant Code");
        ReservEntryBuffer.SETRANGE("Location Code",ItemJournalLine."Location Code");
        ReservEntryBuffer.SETRANGE("Reservation Status",ReservEntryBuffer."Reservation Status"::Prospect);
        ReservEntryBuffer.SETRANGE("Item Tracking",ItemTracking);
        ReservEntryBuffer.SETRANGE("Serial No.",SerialNo);
        ReservEntryBuffer.SETRANGE("Lot No.",LotNo);

        IF ReservEntryBuffer.FINDSET THEN BEGIN
          REPEAT
            IF (ReservEntryBuffer."Source Ref. No." = ItemJournalLine."Line No.") AND
               (ReservEntryBuffer."Source ID" = ItemJournalLine."Journal Template Name") AND
               (ReservEntryBuffer."Source Batch Name" = ItemJournalLine."Journal Batch Name")
            THEN
              FoundRec := TRUE;
          UNTIL (ReservEntryBuffer.NEXT = 0) OR FoundRec;
        END;

        IF NOT FoundRec THEN BEGIN
          EntryNo += 1;
          ReservEntryBuffer."Entry No." := EntryNo;
          ReservEntryBuffer."Item No." := ItemJournalLine."Item No.";
          ReservEntryBuffer."Location Code" := ItemJournalLine."Location Code";
          ReservEntryBuffer."Quantity (Base)" := Qty;
          ReservEntryBuffer."Variant Code" := ItemJournalLine."Variant Code";
          ReservEntryBuffer."Reservation Status" := ReservEntryBuffer."Reservation Status"::Prospect;
          ReservEntryBuffer."Creation Date" := WORKDATE;
          ReservEntryBuffer."Source Type" := DATABASE::"Item Journal Line";
          ReservEntryBuffer."Source ID" := ItemJournalLine."Journal Template Name";
          ReservEntryBuffer."Source Batch Name" := ItemJournalLine."Journal Batch Name";
          ReservEntryBuffer."Source Ref. No." := ItemJournalLine."Line No.";
          ReservEntryBuffer."Qty. per Unit of Measure" := ItemJournalLine."Qty. per Unit of Measure";
          ReservEntryBuffer."Serial No." := SerialNo;
          ReservEntryBuffer."Lot No." := LotNo;
          ReservEntryBuffer."Item Tracking" := ItemTracking;
          ReservEntryBuffer.INSERT;
        END
        ELSE BEGIN
          ReservEntryBuffer."Quantity (Base)" += Qty;
          ReservEntryBuffer.MODIFY;
        END;
    end;

    local procedure WhseTrckg(ItemNo : Code[20]) : Boolean;
    var
        Item : Record "27";
        SNRequired : Boolean;
        LNRequired : Boolean;
    begin
        SNRequired := FALSE;
        LNRequired := FALSE;
        Item.GET(ItemNo);
        IF Item."Item Tracking Code" <> '' THEN BEGIN
          ItemTrackingCode.GET(Item."Item Tracking Code");
          SNRequired := ItemTrackingCode."SN Warehouse Tracking";
          LNRequired := ItemTrackingCode."Lot Warehouse Tracking";
        END;

        EXIT(SNRequired OR LNRequired);
    end;

    local procedure DirectedPutAwayAndPick(LocationCode : Code[10]) : Boolean;
    var
        Location : Record "14";
    begin
        IF LocationCode = '' THEN
          EXIT(FALSE);
        Location.GET(LocationCode);
        EXIT(Location."Directed Put-away and Pick");
    end;

    local procedure CreateSummary(var ItemJnlLine1 : Record "83");
    var
        ItemJnlLine2 : Record "83";
        ItemNo : Code[20];
        VariantCode : Code[10];
        LocationCode : Code[10];
        NewGroup : Boolean;
    begin
        // Create SN/Lot entry only for the last journal line in the group
        ItemNo := ItemJnlLine1."Item No.";
        VariantCode := ItemJnlLine1."Variant Code";
        LocationCode := ItemJnlLine1."Location Code";
        NewGroup := FALSE;
        ItemJnlLine2 := ItemJnlLine1;
        REPEAT
          IF (ItemNo <> ItemJnlLine1."Item No.") OR
             (VariantCode <> ItemJnlLine1."Variant Code") OR
             (LocationCode <> ItemJnlLine1."Location Code")
          THEN
            NewGroup := TRUE
          ELSE
            ItemJnlLine2 := ItemJnlLine1;
        UNTIL (ItemJnlLine1.NEXT = 0) OR NewGroup;
        ItemJnlLine1 := ItemJnlLine2;
        PickSNLotFromILEntry(ItemJnlLine1."Item No.",ItemJnlLine1."Variant Code",ItemJnlLine1."Location Code");
    end;
}

 */