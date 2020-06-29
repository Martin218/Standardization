table 50411 "Requisition Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Employee Code"; Code[20])
        {
            Editable = true;
            TableRelation = Employee;
        }
        field(3; "Employee Name"; Text[50])
        {
        }
        field(4; Description; Text[100])
        {
        }
        field(5; "Requisition Date"; Date)
        {
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Archived,Issued,Pending Return,Returned';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Archived,Issued,"Pending Return",Returned;
        }
        field(7; "Requested By"; Code[100])
        {
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Department';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(10; "Procurement Plan"; Code[10])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(11; "No. Series"; Code[80])
        {
            TableRelation = "No. Series";
        }
        field(12; "Requisition Type"; Option)
        {
            OptionCaption = 'Purchase Requisition,Store Requisition,Store Return';
            OptionMembers = "Purchase Requisition","Store Requisition","Store Return";
        }
        field(13; Posted; Boolean)
        {
        }
        field(14; "No of Approvals"; Integer)
        {
            CalcFormula = Count ("Approval Entry" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(15; "Posted By"; Code[30])
        {
            TableRelation = "User Setup";
        }
        field(16; "Date Posted"; Date)
        {
        }
        field(17; "LPO Generated"; Boolean)
        {
        }
        field(18; "Assigned User ID"; Code[70])
        {
            TableRelation = "User Setup";
        }
        field(19; Select; Boolean)
        {
        }
        field(20; "Date of Assignment"; Date)
        {
        }
        field(21; Amount; Decimal)
        {
            CalcFormula = Sum ("Requisition Header Line".Amount WHERE("Requisition No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(22; "Procurement Type"; Option)
        {
            OptionCaption = 'Goods&Services,Works';
            OptionMembers = "Goods&Services",Works;
        }
        field(23; "Issue Date"; Date)
        {
        }
        field(24; "Issued By"; Code[80])
        {
        }
        field(25; "Return Date"; Date)
        {
        }
        field(26; "Return Received By"; Code[80])
        {
        }
        field(27; "Issuance Status"; Option)
        {
            OptionCaption = 'Released,Issued,Pending Return,Returned';
            OptionMembers = Released,Issued,"Pending Return",Returned;
        }
        field(28; "Has Item To Return"; Boolean)
        {
        }
        field(29; "Store Requisition No."; Code[20])
        {
        }
        field(30; "Store Return No."; Code[20])
        {
        }
        field(31; "Purchase Requisition No."; Code[20])
        {
        }
        field(32; "Assignment Date"; Date)
        {
        }
        field(33; "Procurement Process Initiated"; Boolean)
        {
        }
        field(34; "LPO No."; Code[20])
        {
        }
        field(35; "Procurement Method"; Code[30])
        {
            TableRelation = "Procurement Method";
        }
        field(36; "Procurement Process No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        UserSetup.GET(USERID);
        ProcurementSetup.GET;
        GeneralLedgerSetup.GET;
        IF "Requisition Type" = "Requisition Type"::"Purchase Requisition" THEN BEGIN
            ProcurementSetup.TESTFIELD("Purchase Requisition No.");
            NoSeriesManagement.InitSeries(ProcurementSetup."Purchase Requisition No.", xRec."No.", 0D, "No.", "No. Series");
        END ELSE
            IF "Requisition Type" = "Requisition Type"::"Store Requisition" THEN BEGIN
                ProcurementSetup.TESTFIELD("Store Requisition No.");
                NoSeriesManagement.InitSeries(ProcurementSetup."Store Requisition No.", xRec."No.", 0D, "No.", "No. Series");
            END ELSE
                IF "Requisition Type" = "Requisition Type"::"Store Return" THEN BEGIN
                    ProcurementSetup.TESTFIELD("Store Return No.");
                    NoSeriesManagement.InitSeries(ProcurementSetup."Store Return No.", xRec."No.", 0D, "No.", "No. Series");
                END;
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Global Dimension 1 Code");
        UserSetup.TESTFIELD("Global Dimension 2 Code");
        UserSetup.TESTFIELD("Employee No.");
        "Requested By" := USERID;
        "Requisition Date" := TODAY;
        "Employee Code" := UserSetup."Employee No.";
        "Employee Name" := GetEmployeeName("Employee Code");
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        "Procurement Plan" := GeneralLedgerSetup."Current Bugdet";
    end;

    var
        ProcurementSetup: Record "Procurement Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;

    //[Scope('Personalization')]
    procedure ValidateFieldsOnInsert(RequisitionHeader: Record "Requisition Header");
    begin
        WITH RequisitionHeader DO BEGIN
            UserSetup.GET(USERID);
            UserSetup.TESTFIELD("Global Dimension 1 Code");
            UserSetup.TESTFIELD("Global Dimension 2 Code");
            UserSetup.TESTFIELD("Employee No.");
            "Requested By" := USERID;
            "Requisition Date" := TODAY;
            "Employee Code" := UserSetup."Employee No.";
            "Employee Name" := GetEmployeeName("Employee Code");
            "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
            "Procurement Plan" := GeneralLedgerSetup."Current Bugdet";
            MODIFY(TRUE);
        END;
    end;

    local procedure GetEmployeeName(EmployeeCode: Code[20]) EmpName: Text;
    var
        Employee: Record Employee;
    begin
        IF Employee.GET(EmployeeCode) THEN BEGIN
            EmpName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
            EXIT(EmpName);
        END;
    end;
}

