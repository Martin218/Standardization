page 50499 "Employee Separation Document"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50228;
    SourceTableView = WHERE("Separation Documents" = filter('Yes'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Upload Separation Form")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    selected := 0;
                    selected := STRMENU('Handover Report,Clearance Form,Exit Interview Form,Other Documents', 0, 'Please Specify which document you want to upload');
                    //MESSAGE('%1',selected);
                    docname := "Employee No";
                    docname := CONVERTSTR(docname, '/', '_');
                    docname := CONVERTSTR(docname, '\', '_');

                    HRSetup.RESET;
                    HRSetup.GET;
                    // HRSetup.TESTFIELD("File Path");
                    //FileName := filecu.OpenFileDialog('Select the Exit form', 'Exit', 'PDF Files (*.PDF)|*.PDF|All Files (*.*)|*.*');
                    FileName2 := HRSetup."File Path" + docname + '_Clearance Form_' + filecu.GetFileName(FileName);
                    //  filecu.CopyClientFile(FileName, FileName2, TRUE);
                    // namefile := filecu.GetFileName(FileName);
                    //MODIFY;

                    lastno := 0;
                    EmployeeDocuments.RESET;
                    IF EmployeeDocuments.FINDLAST THEN BEGIN
                        lastno := EmployeeDocuments.No + 1;
                    END ELSE
                        lastno := 1;

                    EmployeeDocuments.INIT;
                    EmployeeDocuments.No := lastno;
                    EmployeeDocuments."Employee No" := "Employee No";
                    EmployeeDocuments."Employee Name" := "Employee Name";
                    EmployeeDocuments."File Name" := FileName2;
                    EmployeeDocuments.Name := namefile;
                    EmployeeDocuments."Separation Documents" := TRUE;
                    IF selected = 1 THEN BEGIN
                        EmployeeDocuments."Document Type" := EmployeeDocuments."Document Type"::"Handover Report";
                    END;
                    IF selected = 2 THEN BEGIN
                        EmployeeDocuments."Document Type" := EmployeeDocuments."Document Type"::"Clearance Form";
                    END;
                    IF selected = 3 THEN BEGIN
                        EmployeeDocuments."Document Type" := EmployeeDocuments."Document Type"::"Exit Interview Form";
                    END;
                    IF selected = 4 THEN BEGIN
                        EmployeeDocuments."Document Type" := EmployeeDocuments."Document Type"::"Other Documents";
                    END;
                    EmployeeDocuments.INSERT;

                    MESSAGE('Document Attached Successfully');
                end;
            }
            action("View Document")
            {
                Image = DocumentEdit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM('Are you sure you want to view this file?') THEN BEGIN
                        EmployeeDocuments.RESET;
                        EmployeeDocuments.SETRANGE("Employee No", "Employee No");
                        IF EmployeeDocuments.FIND('-') THEN BEGIN
                            HYPERLINK("File Name");
                        END;
                    END;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        "Separation Documents" := TRUE;
    end;

    var
        FileName: Text[500];
        FileName2: Text[500];
        docname: Text;
        docname2: Text;
        filecu: Codeunit 419;
        HRSetup: Record 5218;
        DocPath: Text;
        HRDocuments: Record 50226;
        HRDocView: Record 50227;
        lastno: Integer;
        EmployeeDocuments: Record 50228;
        namefile: Text;
        selected: Integer;
}

