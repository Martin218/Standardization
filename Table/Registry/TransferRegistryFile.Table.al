table 50483 "Transfer Registry File"
{
    // version TL2.0


    fields
    {
        field(1; "Transfer ID"; Code[30])
        {
            Editable = false;
        }
        field(2; "Released From"; Code[50])
        {
            Editable = false;

            trigger OnValidate();
            begin
                User.RESET;
                User.SETRANGE("User ID", "Released From");
                IF User.FINDFIRST THEN BEGIN
                    /* DimensionValue.RESET;
                     DimensionValue.SETRANGE("Global Dimension No.", 1);
                     DimensionValue.SETRANGE(Code, User."Global Dimension 1 Code");
                     IF DimensionValue.FIND('-') THEN BEGIN
                         //Branch1:=DimensionValue.Name;
                         "Branch Code" := DimensionValue.Code;
                     END;*/
                END;
            end;
        }
        field(3; "Time Released"; DateTime)
        {
            Editable = false;
        }
        field(4; "Released To"; Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate();
            begin
                IF "Released To" = "Released From" THEN BEGIN
                    ERROR('Please select a different user.');
                END;

                User.RESET;
                User.GET(USERID);
                /* DimensionValue.RESET;
                 DimensionValue.SETRANGE("Global Dimension No.", 1);
                 DimensionValue.SETRANGE(Code, User."Global Dimension 1 Code");
                 IF DimensionValue.FIND('-') THEN BEGIN
                     Branch1 := DimensionValue.Name;
                 END;*/

                User.RESET;
                User.GET("Released To");
                /*DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.", 1);
                DimensionValue.SETRANGE(Code, User."Global Dimension 1 Code");
                IF DimensionValue.FIND('-') THEN BEGIN
                    Branch2 := DimensionValue.Name;
                END;*/

                IF Branch1 <> Branch2 THEN
                    ERROR('You cannot transfer a file to a user in a different branch');
                "Carried By" := "Released To";
            end;
        }
        field(5; "No. Series"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(6; Comments; Text[250])
        {
        }
        field(7; Status; Option)
        {
            OptionCaption = 'New,Pending Receipt,Received';
            OptionMembers = New,"Pending Receipt",Received;
        }
        field(8; "Duration Required(Days)"; DateFormula)
        {

            trigger OnValidate();
            begin
                /*IF "Duration Required(Days)"><30D>' THEN
                  ERROR('Max. Days allowed is 30 Days');*/

                txtNoNumbers := '';
                txtNoNumbers := FORMAT("Duration Required(Days)");
                Duration := '';
                Duration := DELCHR(txtNoNumbers, '>', 'D,W,M');
                EVALUATE(Duration3, Duration);
                IF Duration3 > 10 THEN BEGIN
                    ERROR('Maximum duration required per person is 10 days');
                END;

                CurrentTime := TIME;
                Date := CALCDATE("Duration Required(Days)", TODAY);
                "Due Date" := CREATEDATETIME(Date, CurrentTime);

            end;
        }
        field(9; "Due Date"; DateTime)
        {
            Editable = false;
        }
        field(10; "Carried By"; Code[80])
        {

            trigger OnValidate();
            begin
                Employee.RESET;
                //Employee.SETFILTER("No.","Carried By");
                IF Employee.FINDFIRST THEN BEGIN
                    //"Carried By(Name)":=Employee.Name;
                END;
            end;
        }
        field(11; "Carried By(Name)"; Text[100])
        {
        }
        field(12; "Branch Code"; Code[10])
        {
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
    }

    trigger OnInsert();
    begin
        IF "Transfer ID" = '' THEN BEGIN
            NoSetup.GET();
            NoSetup.TESTFIELD("Transfer ID");
            NoSeriesMgt.InitSeries(NoSetup."Transfer ID", xRec."No. Series", 0D, "Transfer ID", "No. Series");
        END;

        "Released From" := USERID;
        "Time Released" := CURRENTDATETIME;
    end;

    var
        NoSetup: Record "Registry SetUp";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //DimensionValue : Record 
        User: Record "User Setup";
        Branch1: Text;
        Branch2: Text;
        CurrentTime: Time;
        Date: Date;
        MaxDate: DateFormula;
        Duration: Text;
        CurrentTime2: Time;
        txtNoNumbers: Text;
        Duration2: Code[10];
        Duration3: Integer;
        Employee: Record Employee;
}

