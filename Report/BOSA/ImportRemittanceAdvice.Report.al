report 50099 "Import Remittance Advice"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            IF CloseAction = ACTION::OK THEN BEGIN
                //ServerFileName := FileManagement.UploadFile(Text006, ExcelExtensionTok);
                IF ServerFileName = '' THEN
                    EXIT(FALSE);

                //SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);
                IF SheetName = '' THEN
                    EXIT(FALSE);
            END;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        X: Integer;
    begin
        ExcelBuffer.LOCKTABLE;
        //ExcelBuffer.OpenBook(ServerFileName, SheetName);
        ExcelBuffer.ReadSheet;
        GetLastRowandColumn;

        AgencyRemittanceHeader.RESET;
        AgencyRemittanceHeader.SETRANGE("Agency Code", GetValueAtCell(3, 2));
        AgencyRemittanceHeader.SETRANGE("Period Month", GetValueAtCell(5, 2));
        EVALUATE(PY, GetValueAtCell(6, 2));
        AgencyRemittanceHeader.SETRANGE("Period Year", PY);
        IF AgencyRemittanceHeader.FINDFIRST THEN BEGIN
            FOR X := 12 TO TotalRows DO
                InsertData(X);

            ExcelBuffer.DELETEALL;
            MESSAGE('Import Completed');
            AgencyRemittanceHeader.Status := AgencyRemittanceHeader.Status::Imported;
            AgencyRemittanceHeader.MODIFY;
        END;
    end;

    var
        ExcelBuffer: Record "Excel Buffer";
        ServerFileName: Text;
        SheetName: Text[250];
        FileManagement: Codeunit "File Management";
        Window: Dialog;
        TotalColumns: Integer;
        TotalRows: Integer;
        AgencyRemittanceLine: Record "Agency Remittance Line";
        Text005: Label 'Imported from Excel ';
        Text006: Label 'Import Excel File';
        ExcelExtensionTok: Label '.xlsx', Locked = true;
        Text010: Label 'Add entries,Replace entries';
        Text001: Label 'Do you want to create %1 %2.';
        Text003: Label 'Are you sure you want to %1 for %2 %3.';
        AgencyRemittanceHeader: Record "Agency Remittance Header";
        PY: Integer;
        i: Integer;

    procedure GetLastRowandColumn()
    begin
        ExcelBuffer.SETRANGE("Row No.", 11);
        TotalColumns := ExcelBuffer.COUNT;

        ExcelBuffer.RESET;
        IF ExcelBuffer.FINDLAST THEN
            TotalRows := ExcelBuffer."Row No.";
    end;

    procedure InsertData(RowNo: Integer)
    var
        ItemNo: Code[20];
        LMonth: Integer;
    begin
        i := 1;

        FOR i := 1 TO TotalColumns DO BEGIN
            IF i >= 3 THEN BEGIN
                AgencyRemittanceLine.INIT;
                AgencyRemittanceLine.SETRANGE("Document No.", AgencyRemittanceHeader."No.");
                AgencyRemittanceLine.SETRANGE("Member No.", GetValueAtCell(12, 1));
                AgencyRemittanceLine.SETRANGE("Remittance Code", GetValueAtCell(11, i));
                IF AgencyRemittanceLine.FINDSET THEN BEGIN
                    REPEAT
                        EVALUATE(AgencyRemittanceLine."Actual Amount", GetValueAtCell(12, i));
                        AgencyRemittanceLine.MODIFY;
                    UNTIL AgencyRemittanceLine.NEXT = 0;
                END;
            END;
        END;
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuffer2: Record "Excel Buffer";
    begin
        ExcelBuffer2.GET(RowNo, ColNo);
        EXIT(ExcelBuffer2."Cell Value as Text");
    end;
}

