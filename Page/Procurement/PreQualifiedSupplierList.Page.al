page 50751 "Pre-Qualified Supplier List"
{
    // version TL2.0

    CardPageID = "Pre-Qualified Supplier Card";
    PageType = List;
    SourceTable = "Prequalified Suppliers";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select; Select)
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Category Code"; "Category Code")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Vendor List ")
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    ProcurementManagement.UpdatePrequalifiedSupplierOnVendor;
                end;
            }
        }
    }

    var
        PrequalifiedSuppliers: Record "Prequalified Suppliers";
        Vendor: Record Vendor;
        ProcurementManagement: Codeunit "Procurement Management";

    //[Scope('Personalization')]
    procedure SetSelection(PrequalifiedSuppliers: Record "Prequalified Suppliers"; DocNo: Code[20]; CategoryCode: Code[10]): Text;
    var
        PrequalifiedSuppliers2: Record "Prequalified Suppliers";
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
    begin
        PrequalifiedSuppliers.RESET;
        Rec.SETRANGE(Select, TRUE);
        PrequalifiedSuppliers.COPY(Rec);
        //CurrPage.SETSELECTIONFILTER(PrequalifiedSuppliers);
        //PrequalifiedSuppliers.MARKEDONLY(TRUE);
        ProcurementSupplierSelection.RESET;
        ProcurementSupplierSelection.SETRANGE("Process No.", DocNo);
        IF ProcurementSupplierSelection.FINDSET THEN BEGIN
            ProcurementSupplierSelection.DELETEALL;
        END;

        PrequalifiedSuppliers2.RESET;
        PrequalifiedSuppliers2.SETRANGE(Select, TRUE);
        PrequalifiedSuppliers2.SETRANGE("Category Code", CategoryCode);
        IF PrequalifiedSuppliers2.COUNT > 0 THEN BEGIN
            REPEAT
                ProcurementManagement.PopulateSelectedSuppliers(PrequalifiedSuppliers2, DocNo);
            //PopulateSupplierSelection(PrequalifiedSuppliers2,DocNo);
            UNTIL PrequalifiedSuppliers2.NEXT = 0;
        END;
    end;

    local procedure PopulateSupplierSelection(PrequalifiedSuppliers2: Record "Prequalified Suppliers"; ProcessNo: Code[20]);
    begin
        WITH PrequalifiedSuppliers2 DO BEGIN
            ProcurementManagement.PopulateSelectedSuppliers(PrequalifiedSuppliers2, ProcessNo);
        END;
    end;
}

