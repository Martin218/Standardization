table 50482 "File Return"
{
    // version TL2.0


    fields
    {
        field(1; "Return ID"; Code[30])
        {
            Editable = false;

        }
        field(2; "Return Date"; DateTime)
        {
            Editable = false;
        }
        field(3; "Staff Name"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(4; "Received By"; Code[50])
        {
            Editable = false;
        }
        field(5; "File No."; Code[30])
        {
            Editable = false;
        }
        field(6; Remarks; Text[250])
        {
        }
        field(7; "No. Series"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(8; "File Name"; Code[50])
        {
            Editable = false;
        }
        field(9; "Request ID"; Code[30])
        {
            TableRelation = "Transfer Files Line" WHERE("Current User ID" = FIELD("Staff Name"),
                                                         Returned = filter('No'));

            trigger OnValidate();
            begin
                FileIssuance.RESET;
                FileIssuance.SETRANGE(Issued, TRUE);
                IF FileIssuance.GET("Request ID") THEN BEGIN
                    "File No." := FileIssuance."File No.";
                    "File Name" := FileIssuance."File Name";
                END;
            end;
        }
        field(10; "Received Note"; Text[250])
        {
        }
        field(11; Posted; Boolean)
        {
            Editable = false;
        }
        field(12; "File Return Status"; Option)
        {
            Editable = false;
            OptionCaption = 'New,Accepted,Rejected,Pending Acceptance';
            OptionMembers = New,Accepted,Rejected,"Pending Acceptance";
        }
        field(13; "Branch Code"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Return ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Return ID", "Return Date", "Staff Name", "Received By", "Request ID")
        {
        }
    }

    trigger OnInsert();
    begin
        IF "Return ID" = '' THEN BEGIN
            NoSetup.GET();
            NoSetup.TESTFIELD("Return ID");
            NoSeriesMgt.InitSeries(NoSetup."Return ID", xRec."No. Series", 0D, "Return ID", "No. Series");
        END;

        "Return Date" := CURRENTDATETIME;
        "Staff Name" := USERID;

        User.GET(USERID);
        //"Branch Code":=User."Global Dimension 1 Code"; //MESSAGE('%1',"Branch Code");
    end;

    var
        NoSetup: Record "Registry SetUp";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RegistryLines: Record "Registry Files Line";
        TransferFilesLines: Record "Transfer Files Line";
        User: Record "User Setup";
        FileIssuance: Record "File Issuance";
}

