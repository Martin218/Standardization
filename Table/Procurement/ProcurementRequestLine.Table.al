table 50414 "Procurement Request Line"
{

    fields
    {
        field(1; "Request No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; Type; Option)
        {
            OptionCaptionML = ENU = ' ,G/L Account,Item,Fixed Asset,Charge (Item)',
                              ENG = ' ,G/L Account,Item';
            OptionMembers = " ","G/L Account",Item,"Fixed Asset","Charge (Item)";

            trigger OnValidate();
            begin
                IF "Requisition Type" = "Requisition Type"::"Store Requisition" THEN
                    IF Type = Type::"G/L Account" THEN
                        ERROR(GLAccountErr);
            end;
        }
        field(4; "No."; Code[10])
        {
            Editable = true;
            TableRelation = IF (Type = CONST(Item)) Item."No."
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No.";

            trigger OnValidate();
            begin
                ValidateTypeNo(Type, "No.");
            end;
        }
        field(5; Description; Text[100])
        {
        }
        field(6; Quantity; Decimal)
        {

            trigger OnValidate();
            begin
                ValidateAmount;
                IF RequisitionHeader.GET("Request No.") THEN BEGIN
                    IF RequisitionHeader."Requisition Type" = RequisitionHeader."Requisition Type"::"Store Requisition" THEN BEGIN
                        IF GetItemQuantity("No.") < Quantity THEN BEGIN
                            ERROR(ExcessQuantityErr, GetItemQuantity("No."));
                        END;
                    END;
                END;
            end;
        }
        field(7; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(8; "Unit Price"; Decimal)
        {

            trigger OnValidate();
            begin
                ValidateAmount;
            end;
        }
        field(9; Amount; Decimal)
        {
            Editable = false;
        }
        field(10; "Procurement Plan"; Code[10])
        {
            TableRelation = "G/L Budget Name".Name WHERE("Procurement Plan Approved" = FILTER('Yes'));
        }
        field(11; "Procurement Plan Item"; Integer)
        {
            TableRelation = "Procurement Plan Line" WHERE(Approved = FILTER('Yes'),
                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code"));

            trigger OnValidate();
            begin
                InsertPlanItemDetails("Procurement Plan Item");
            end;
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Branch';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14; Select; Boolean)
        {
        }
        field(15; "Quantity in Store"; Decimal)
        {
            Editable = false;
        }
        field(16; "Approved Budget Amount"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(17; "Commitment Amount"; Decimal)
        {
            Editable = false;
        }
        field(18; "Actual Expense"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(19; "Available amount"; Decimal)
        {
            Editable = false;
        }
        field(20; "Requisition Status"; Option)
        {
            OptionMembers = " ",Approved,Rejected;
        }
        field(21; "Requisition Date"; Date)
        {
        }
        field(22; "Requisition Type"; Option)
        {
            OptionCaption = 'Purchase Requisition,Store Requisition,Store Return';
            OptionMembers = "Purchase Requisition","Store Requisition","Store Return";
        }
        field(23; "Current Budget"; Code[100])
        {
            TableRelation = "G/L Budget Name";
        }
        field(24; "Budget Link"; Integer)
        {
            TableRelation = "G/L Budget Entry"."Entry No." WHERE(Approved = FILTER('Yes'));

            trigger OnValidate();
            begin
                UpdateBudgetEntries("Budget Link");
            end;
        }
        field(25; "Quantity Returned"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Quantity Returned" > Quantity THEN
                    ERROR(ExcessReturnQuantityErr)
                ELSE
                    IF "Quantity Returned" < Quantity THEN
                        ERROR(LessReturnQuantityErr);
            end;
        }
        field(26; "Item Category"; Option)
        {
            OptionCaption = 'Consumable,Non Consumable';
            OptionMembers = Consumable,"Non Consumable";
        }
        field(27; "Procurement Method"; Code[20])
        {
        }
        field(28; "Procurement Method No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Request No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        UserSetup.GET(USERID);
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        IF RequisitionHeader.GET("Request No.") THEN
            "Requisition Type" := RequisitionHeader."Requisition Type";
    end;

    var
        ProcurementPlanLines: Record "Procurement Plan Line";
        UserSetup: Record "User Setup";
        ProcurementManagement: Codeunit "Procurement Management";
        ExcessQuantityErr: Label 'You can not request more than the Available Quantity of %1';
        RequisitionHeader: Record "Requisition Header";
        GLAccountErr: Label 'You cannot request a GL account from the Stores.';
        Item: Record Item;
        ExcessReturnQuantityErr: Label 'The Quantity returned is More than the Quantity Requested.';
        LessReturnQuantityErr: Label 'The Quantity returned is Less than the Quantity Requested.';

    local procedure ValidateTypeNo(RequestType: Option " ","G/L Account",Item,"Fixed Asset","Charge (Item)"; TypeNo: Code[30]);
    var
        Item: Record Item;
        GLAccount: Record "G/L Account";
        FixedAsset: Record "Fixed Asset";
    begin
        CASE RequestType OF
            RequestType::Item:
                BEGIN
                    IF Item.GET(TypeNo) THEN BEGIN
                        Description := Item.Description;
                        "Unit of Measure" := Item."Base Unit of Measure";
                        "Unit Price" := Item."Unit Price";
                        "Quantity in Store" := GetItemQuantity(TypeNo);
                        "Item Category" := Item."Item Category";
                    END;
                END;
            RequestType::"G/L Account":
                BEGIN
                    IF GLAccount.GET(TypeNo) THEN BEGIN
                        Description := GLAccount.Name;
                    END;
                END;
            RequestType::"Fixed Asset":
                BEGIN
                    IF FixedAsset.GET(TypeNo) THEN BEGIN
                        Description := FixedAsset.Description;
                    END;
                END;
        END;
    end;

    local procedure ValidateAmount();
    var
        ExcessAmountErr: Label 'Please Note the Amount of %1 is more than the Budgeted Amount of %2';
    begin
        IF (Quantity <> 0) AND ("Unit Price" <> 0) THEN
            Amount := "Unit Price" * Quantity;

        IF (Amount > "Approved Budget Amount") AND ("Requisition Type" = "Requisition Type"::"Purchase Requisition") THEN
            ERROR(ExcessAmountErr, Amount, "Approved Budget Amount");
    end;

    local procedure UpdateBudgetEntries(BudgetLine: Integer);
    var
        GLBudgetEntry: Record "G/L Budget Entry";
        ProcurementPlanLines: Record "Procurement Plan Line";
    begin
        IF GLBudgetEntry.GET(BudgetLine) THEN BEGIN
            "Approved Budget Amount" := GLBudgetEntry.Amount;
        END;
    end;

    local procedure GetItemQuantity(Item_No: Code[20]): Integer;
    var
        ItemRec: Record Item;
    begin
        IF ItemRec.GET(Item_No) THEN BEGIN
            ItemRec.CALCFIELDS(Inventory);
            EXIT(ItemRec.Inventory);
        END;
    end;

    //[Scope('Personalization')]
    procedure InsertPlanItemDetails(LineNo: Integer);
    var
        ProcurementPlanLines: Record "Procurement Plan Line";
    begin
        IF ProcurementPlanLines.GET(LineNo) THEN BEGIN
            "Budget Link" := ProcurementPlanLines."Source Of Funds";
            VALIDATE("Budget Link");
            "No." := ProcurementPlanLines."No.";
            Description := ProcurementPlanLines.Description;
            "Unit of Measure" := ProcurementPlanLines."Unit On Measure";
            "Unit Price" := ProcurementPlanLines."Unit Price";
            Quantity := ProcurementPlanLines.Quantity;
            Type := ProcurementPlanLines.Type;
            Amount := ProcurementPlanLines."Estimated Cost";
            "Procurement Method" := ProcurementPlanLines."Procurement Method";
            IF ProcurementPlanLines.Type = ProcurementPlanLines.Type::Item THEN BEGIN
                IF Item.GET("No.") THEN
                    "Item Category" := Item."Item Category";
                "Quantity in Store" := GetItemQuantity(ProcurementPlanLines."No.");
            END;
        END;
    end;
}

