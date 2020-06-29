table 50484 "File Movement"
{
    // version TL2.0


    fields
    {
        field(1; "File Movement ID"; Code[30])
        {
            Editable = false;
        }
        field(2; "File No."; Code[30])
        {
            TableRelation = "Registry File";

            trigger OnValidate();
            begin
                IF FileRegister.GET("File No.") THEN BEGIN
                    "File Number" := FileRegister."File Number";
                    "File Name" := FileRegister."File Name";
                    "Member No" := FileRegister."Member No.";
                    "ID No" := FileRegister."ID No.";
                    "Payroll No" := FileRegister."Payroll No.";
                    "Cabinet No." := FileRegister."Cabinet/Rack No.";
                    Volume := FileRegister.Volume;
                    // "From Location":=FileRegister.Location;

                    "To Location2" := "To Location";
                    DimensionValue.RESET;
                    DimensionValue.SETRANGE(Code, FileRegister.Location1);
                    IF DimensionValue.FIND('-') THEN BEGIN
                        "From Location" := DimensionValue.Name;
                        "To Location" := DimensionValue.Name
                    END;
                    /*Branch.RESET;
                    Branch.SETRANGE(Code, FileRegister.Location1);
                    IF Branch.FIND('-') THEN BEGIN
                        "From Location" := Branch.Name;
                    END;*/
                END;

            end;
        }
        field(3; "File Name"; Code[50])
        {
        }
        field(4; "Reason Code"; Text[250])
        {
            TableRelation = "Request File Reason";

            trigger OnValidate();
            begin
                IF RequestFileReasons.GET("Reason Code") THEN BEGIN
                    "Reason Code" := RequestFileReasons.Reason;
                END;
            end;
        }
        field(5; "Cabinet No."; Code[10])
        {
        }
        field(6; Volume; Code[10])
        {
        }
        field(7; "From Location"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                /*Branch.RESET;
                Branch.SETRANGE(Code,"From Location");
                IF Branch.FIND('-') THEN BEGIN MESSAGE('0');
                  "From Location":=Branch.Name;
                END;*/

            end;
        }
        field(8; "To Location"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                IF Branch.GET("To Location") THEN
                    "To Location" := Branch.Name;

                IF "From Location" = "To Location" THEN BEGIN
                    ERROR('From Location and To Location cannot have the same value.');
                END;
            end;
        }
        field(9; "Request Remarks"; Text[250])
        {
        }
        field(10; "Released By"; Code[30])
        {
            TableRelation = "User Setup";
        }
        field(11; "Released To"; Code[30])
        {
            TableRelation = "User Setup";

            trigger OnValidate();
            begin
                IF "Released By" = "Released To" THEN BEGIN
                    ERROR('Released To cannot have the same value as Released By');
                END;
            end;
        }
        field(12; "No. Series"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(13; "Date Released"; DateTime)
        {
            Editable = false;
        }
        field(14; "Carried By"; Text[250])
        {
        }
        field(15; Status; Option)
        {
            OptionCaption = 'New,Approval Pending,Approved,Rejected,Ready For Transfer,Dispatched,Received,Returned';
            OptionMembers = New,"Approval Pending",Approved,Rejected,"Ready For Transfer",Dispatched,Received,Returned;
        }
        field(16; "Approval/Rejection Remarks"; Text[250])
        {
        }
        field(17; "Request Date"; DateTime)
        {
            Editable = false;
        }
        field(18; "Approved Date"; DateTime)
        {
            Editable = false;
        }
        field(19; "Approver ID"; Code[30])
        {
            Editable = false;
        }
        field(20; "Received By"; Code[30])
        {
            Editable = false;
        }
        field(21; Received; Boolean)
        {
        }
        field(22; "Member No"; Code[30])
        {
            Editable = false;
        }
        field(23; "ID No"; Code[30])
        {
            Editable = false;
        }
        field(24; "Payroll No"; Code[30])
        {
            Editable = false;
        }
        field(25; "Requested By"; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(26; "File Number"; Code[100])
        {
        }
        field(30; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(31; "To Location2"; Code[30])
        {
        }
    }

    keys
    {
        key(Key1; "File Movement ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "File Movement ID", "File No.", "File Name", "From Location", "To Location", "Released By", "Released To", "Carried By")
        {
        }
    }

    trigger OnInsert();
    begin
        IF "File Movement ID" = '' THEN BEGIN
            NoSetup.GET();
            NoSetup.TESTFIELD("File Movement ID");
            NoSeriesMgt.InitSeries(NoSetup."File Movement ID", xRec."No. Series", 0D, "File Movement ID", "No. Series");
        END;
        "Request Date" := CURRENTDATETIME;
        Status := Status::New;
        "Requested By" := USERID;
    end;

    var
        FileRegister: Record "Registry File";
        NoSetup: Record "Registry SetUp";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Branch: Record Branch;
        DimensionValue: Record "Dimension Value";
        RequestFileReasons: Record "Request File Reason";
        Reason: Text[50];
}

