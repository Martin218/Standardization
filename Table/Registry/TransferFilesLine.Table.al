table 50481 "Transfer Files Line"
{
    // version TL2.0


    fields
    {
        field(1; "Transfer ID"; Code[30])
        {
        }
        field(2; "File No"; Code[50])
        {
            TableRelation = "Registry File" WHERE(Issued = filter('Yes'));

            trigger OnValidate();
            begin
                IF RegistryFiles.GET("File No") THEN BEGIN
                    // MESSAGE('ok');
                    "File Number" := RegistryFiles."File Number";
                    "File Name" := RegistryFiles."File Name";
                    "Member No" := RegistryFiles."Member No.";
                    "ID No" := RegistryFiles."ID No.";
                    "Payroll No" := RegistryFiles."Payroll No.";
                    "File Volume" := RegistryFiles.Volume;
                    "Request ID" := RegistryFiles."Request ID";
                END;
            end;
        }
        field(3; "File Name"; Code[50])
        {
        }
        field(4; "Member No"; Code[50])
        {
        }
        field(5; "ID No"; Code[50])
        {
        }
        field(6; "Payroll No"; Code[50])
        {
        }
        field(7; "Released From"; Code[50])
        {
        }
        field(8; "Time Released"; DateTime)
        {
        }
        field(9; "Released To"; Code[50])
        {
        }
        field(10; "Received By"; Code[50])
        {
        }
        field(11; "Time Received"; DateTime)
        {
        }
        field(12; "File Type"; Code[30])
        {
            Editable = false;
            TableRelation = "File Type";
        }
        field(13; "Request ID"; Code[30])
        {
        }
        field(14; "Current User"; Boolean)
        {
        }
        field(15; "Current User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(16; Returned; Boolean)
        {
        }
        field(17; "Return date"; DateTime)
        {
        }
        field(18; "Returned by"; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(19; "Return ID"; Code[30])
        {
        }
        field(20; "File Number"; Code[100])
        {
            TableRelation = "Registry File" WHERE(Issued = filter('Yes'));

            trigger OnValidate();
            begin
                IF RegistryFiles.GET("File Number") THEN BEGIN
                    // MESSAGE('ok');
                    "File Number" := RegistryFiles."File Number";
                    "File Name" := RegistryFiles."File Name";
                    "Member No" := RegistryFiles."Member No.";
                    "ID No" := RegistryFiles."ID No.";
                    "Payroll No" := RegistryFiles."Payroll No.";
                    "File Volume" := RegistryFiles.Volume;
                END;
            end;
        }
        field(21; "Due Date"; DateTime)
        {
        }
        field(22; "File Volume"; Code[100])
        {
        }
        field(23; Overdue; Boolean)
        {
        }
        field(24; "SentRet Note"; Boolean)
        {
        }
        field(25; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(26; "Carried By"; Code[70])
        {
            TableRelation = "User Setup";
        }
    }

    keys
    {
        key(Key1; "Transfer ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "File No", "File Name", "Member No", "ID No", "Received By")
        {
        }
    }

    trigger OnInsert();
    begin
        "Released From" := USERID;
        "Time Released" := CURRENTDATETIME;
    end;

    var
        RegistryFilesLines: Record "Registry Files Line";
        RegistryFiles: Record "Registry File";
        TransferFilesLines: Record "Transfer Files Line";
        Overdue: Boolean;

    procedure IsOverdue(): Boolean;
    begin
        EXIT("Due Date" < CURRENTDATETIME);
    end;

    local procedure FormatField(Files: Record "Transfer Files Line"): Boolean;
    begin
        IF "Due Date" < CURRENTDATETIME THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;
}

