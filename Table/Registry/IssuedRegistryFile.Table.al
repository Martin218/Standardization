table 50485 "Issued Registry File"
{
    // version TL2.0


    fields
    {
        field(1; "Request ID"; Code[30])
        {
            TableRelation = "File Issuance";
        }
        field(2; "Request Date"; DateTime)
        {
        }
        field(3; "Required Date"; DateTime)
        {
        }
        field(4; "Duration Required(Days)"; DateFormula)
        {

            trigger OnValidate();
            begin
                //"Due Date":=CALCDATE("Duration Required(Days)","Required Date");
            end;
        }
        field(5; "Due Date"; DateTime)
        {
        }
        field(6; "Requisiton By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(7; "File No."; Code[30])
        {
            TableRelation = "Registry File";
        }
        field(8; "File Name"; Code[30])
        {
            TableRelation = "Registry File";
        }
        field(9; "Reason Code"; Text[250])
        {
        }
        field(10; Remarks; Text[250])
        {

            trigger OnValidate();
            begin
                "Issuer ID" := USERID;
            end;
        }
        field(11; "No. Series"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(12; "Request Status"; Option)
        {
            OptionCaption = 'New,Active,Issued,Rejected,Pending Approval,Not Approved';
            OptionMembers = New,Active,Issued,Rejected,"Pending Approval","Not Approved";
        }
        field(13; "Issuer ID"; Code[50])
        {
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
        }
        field(19; "Approval Comment"; Text[250])
        {
        }
        field(20; Overdue; Boolean)
        {
        }
        field(21; "Overdue Days"; Date)
        {
        }
        field(22; Days; DateFormula)
        {
        }
        field(23; Returned; Boolean)
        {
        }
        field(24; "Other User"; Code[50])
        {
            // CalcFormula = Lookup ("Registry Files Line"."Other User" WHERE(Request ID=FIELD(Request ID)));
            FieldClass = FlowField;
            TableRelation = "User Setup";
        }
        field(25; "Confirm Receipt"; Boolean)
        {
        }
        field(26; "Received TimeStamp"; DateTime)
        {
        }
        field(27; "File Number"; Code[100])
        {
        }
        field(28; "Carried By"; Text[150])
        {
        }
        field(29; "Date Filter"; Date)
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
        fieldgroup(DropDown; "Request ID", "Request Date", "Requisiton By")
        {
        }
    }

    var
        NoSetup: Record 50471;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Overdue: Boolean;

    procedure IsOverdue(): Boolean;
    begin
        EXIT("Due Date" < CURRENTDATETIME);
    end;

    local procedure FormatField(Files: Record "Issued Registry File"): Boolean;
    begin
        IF "Due Date" < CURRENTDATETIME THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;
}

