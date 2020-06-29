table 50478 "File Issuance"
{
    // version TL2.0


    fields
    {
        field(1; "Request ID"; Code[30])
        {
            Editable = false;
        }
        field(2; "Request Date"; DateTime)
        {
            Editable = false;
        }
        field(3; "Required Date"; DateTime)
        {

            trigger OnValidate();
            begin
                CurrentTime := TIME;
                CurrentTime2 := DT2TIME("Required Date");
                date := DT2DATE("Required Date");
                IF CurrentTime <> CurrentTime2 THEN BEGIN
                    "Required Date" := CREATEDATETIME(date, CurrentTime);
                END;

                IF "Required Date" < CURRENTDATETIME THEN
                    ERROR('You cannot select a date earlier than today.');
            end;
        }
        field(4; "Duration Required(Days)"; DateFormula)
        {

            trigger OnValidate();
            begin
                txtNoNumbers := '';
                txtNoNumbers := FORMAT("Duration Required(Days)");
                Duration := '';
                Duration := DELCHR(txtNoNumbers, '>', 'D,W,M');
                EVALUATE(Duration3, Duration);
                IF Duration3 > 10 THEN BEGIN
                    ERROR('Maximum duration required per person is 10 days');
                END;


                //"Due Date":=CALCDATE("Duration Required(Days)","Required Date");
                date := DT2DATE("Required Date");
                "Due Time" := TIME;
                DueDate := CALCDATE("Duration Required(Days)", date);
                "Due Date" := CREATEDATETIME(DueDate, "Due Time");
            end;
        }
        field(5; "Due Date"; DateTime)
        {
            Editable = false;
        }
        field(6; "Requisiton By"; Code[50])
        {
            Editable = true;
            TableRelation = "User Setup";

            trigger OnValidate();
            begin
                "Carried By" := "Requisiton By";
            end;
        }
        field(7; "File No."; Code[30])
        {
            TableRelation = "Registry File" WHERE(Issued = filter('No'),
            Created = filter('Yes'));

            trigger OnValidate();
            begin
                RegistryFiles.RESET;
                RegistryFiles.SETFILTER("File No.", "File No.");
                IF RegistryFiles.FINDFIRST THEN BEGIN
                    Location := RegistryFiles.Location1;
                END;
            end;
        }
        field(8; "File Name"; Code[30])
        {
            TableRelation = "Registry File" WHERE(Issued = filter('No'),
             Created = filter('Yes'));
        }
        field(9; Reason; Text[250])
        {
            TableRelation = "Request File Reason";

            trigger OnValidate();
            begin
                IF RequestFileReasons.GET(Reason) THEN BEGIN
                    Reason := RequestFileReasons.Reason;
                END;
            end;
        }
        field(10; Remarks; Text[250])
        {

            trigger OnValidate();
            begin
                "Issuer ID" := USERID;
                "Issued Date" := CURRENTDATETIME;
            end;
        }
        field(11; "No. Series"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(12; "Request Status"; Option)
        {
            OptionCaption = 'New,Active,Issued,Rejected,Pending Approval,Not Approved,Ready For PickUp';
            OptionMembers = New,Active,Issued,Rejected,"Pending Approval","Not Approved","Ready For PickUp";
        }
        field(13; "Issuer ID"; Code[50])
        {
            Editable = false;
        }
        field(14; "Rejection Comment"; Text[250])
        {
        }
        field(15; "Issued Date"; DateTime)
        {
            Editable = false;
        }
        field(16; Issued; Boolean)
        {
            TableRelation = "Registry File";
        }
        field(17; Picked; Boolean)
        {
        }
        field(18; "Approver ID"; Code[50])
        {
            Editable = false;
        }
        field(19; "Approval Comment"; Text[250])
        {

            trigger OnValidate();
            begin
                "Approved Date" := CURRENTDATETIME;
            end;
        }
        field(20; Returned; Boolean)
        {
        }
        field(21; "Request on Behalf Of"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(22; "Issued Time"; Time)
        {
        }
        field(23; "Confirm Receipt"; Boolean)
        {
            Editable = false;
        }
        field(24; "Received TimeStamp"; DateTime)
        {
            Editable = false;
        }
        field(25; "Approved Date"; DateTime)
        {
        }
        field(26; "Rejection Date"; DateTime)
        {
        }
        field(27; "Due Time"; Time)
        {
        }
        field(28; "Branch Code"; Code[30])
        {
        }
        field(29; "HOD Approver"; Code[50])
        {
        }
        field(30; "Carried By"; Code[80])
        {

            trigger OnValidate();
            begin
                Employee.RESET;
                //Employee.SETFILTER(Carried By");
                IF Employee.FINDFIRST THEN BEGIN
                    //"Carried By(Name)":=Employee.Name;
                END;
            end;
        }
        field(31; "Carried By(Name)"; Text[150])
        {
        }
        field(32; Location; Code[10])
        {
        }
        field(33; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Request ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Request ID", "Request Date", "Required Date", "Requisiton By", "Request ID")
        {
        }
    }

    trigger OnInsert();
    begin
        IF "Request ID" = '' THEN BEGIN
            NoSetup.GET();
            NoSetup.TESTFIELD(NoSetup."Request ID");
            NoSeriesMgt.InitSeries(NoSetup."File Movement ID", xRec."No. Series", 0D, "Request ID", "No. Series");
        END;

        "Request Date" := CURRENTDATETIME;
        "Requisiton By" := USERID;

        "Request Status" := "Request Status"::New;
        User.reset;
        //User.GET(USERID);
        //"Branch Code" := User."Global Dimension 1 Code";
    end;

    var
        NoSetup: Record "Registry SetUp";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        date: Date;
        date2: Time;
        RequestFileReasons: Record "Request File Reason";
        DueDate: Date;
        User: Record "User Setup";
        Duration: Text;
        CurrentTime: Time;
        CurrentTime2: Time;
        txtNoNumbers: Text;
        Duration2: Code[10];
        Duration3: Integer;
        Employee: Record Employee;
        RegistryFiles: Record "Registry File";
}

