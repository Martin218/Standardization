report 50510 "Item - List"
{
    // version NAVW111.00

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Procurement\ItemList.rdlc';
    Caption = 'Inventory - List';

    dataset
    {
        dataitem(DataItem8129; Item)
        {
            DataItemTableView = WHERE(Type = CONST(Inventory));
            RequestFilterFields = "No.", "Search Description", "Assembly BOM", "Inventory Posting Group", "Shelf No.", "Statistics Group";
            column(CompanyName; COMPANYPROPERTY.DISPLAYNAME)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(No_Item; "No.")
            {
                IncludeCaption = true;
            }
            column(Description_Item; Description)
            {
                IncludeCaption = true;
            }
            column(AssemblyBOM_Item; FORMAT("Assembly BOM"))
            {
            }
            column(BaseUnitofMeasure_Item; "Base Unit of Measure")
            {
                IncludeCaption = true;
            }
            column(InventoryPostingGrp_Item; "Inventory Posting Group")
            {
                IncludeCaption = true;
            }
            column(ShelfNo_Item; "Shelf No.")
            {
                IncludeCaption = true;
            }
            column(VendorItemNo_Item; "Vendor Item No.")
            {
                IncludeCaption = true;
            }
            column(LeadTimeCalculation_Item; "Lead Time Calculation")
            {
                IncludeCaption = true;
            }
            column(ReorderPoint_Item; "Reorder Point")
            {
                IncludeCaption = true;
            }
            column(AlternativeItemNo_Item; "Alternative Item No.")
            {
                IncludeCaption = true;
            }
            column(Blocked_Item; FORMAT(Blocked))
            {
            }
            column(InventoryListCaption; InventoryListCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(ItemAssemblyBOMCaption; ItemAssemblyBOMCaptionLbl)
            {
            }
            column(ItemBlockedCaption; ItemBlockedCaptionLbl)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(CompanyInformation_Pic; CompanyInformation.Picture)
            {
            }
            column(CompanyInformation_Post; CompanyInformation."Post Code")
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
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    trigger OnPreReport();
    begin
        //ItemFilter := Item.GETFILTERS;
    end;

    var
        ItemFilter: Text;
        InventoryListCaptionLbl: Label 'Inventory - List';
        CurrReportPageNoCaptionLbl: Label 'Page';
        ItemAssemblyBOMCaptionLbl: Label 'BOM';
        ItemBlockedCaptionLbl: Label 'Blocked';
        CompanyInformation: Record "Company Information";
}

