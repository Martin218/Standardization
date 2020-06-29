table 50301 "Payroll Period"
{

    fields
    {
        field(1; "Starting Date"; Date)
        {
            NotBlank = true;

            trigger OnValidate();
            begin
                Name := FORMAT("Starting Date", 0, '<Month Text>');
                "Period code" := FORMAT(DATE2DMY("Starting Date", 3)) + FORMAT(DATE2DMY("Starting Date", 2)) + FORMAT(DATE2DMY("Starting Date", 1))
            end;
        }
        field(2; Name; Text[20])
        {

            trigger OnValidate();
            begin
                "Period code" := FORMAT(DATE2DMY("Starting Date", 3)) + FORMAT(DATE2DMY("Starting Date", 2)) + FORMAT(DATE2DMY("Starting Date", 1))
            end;
        }
        field(3; "New Fiscal Year"; Boolean)
        {

            trigger OnValidate();
            begin
                TESTFIELD("Date Locked", FALSE);
            end;
        }
        field(4; Closed; Boolean)
        {
            Editable = true;
        }
        field(5; "Date Locked"; Boolean)
        {
            Editable = true;
        }
        field(6; "Pay Date"; Date)
        {
        }
        field(7; "Close Pay"; Boolean)
        {
            Editable = true;

            trigger OnValidate();
            begin
                TESTFIELD("Close Pay", FALSE);
                IF "Close Pay" = TRUE THEN BEGIN
                    "Closed By" := USERID;
                    "Closed on Date" := CURRENTDATETIME;
                END;
            end;
        }
        field(8; "P.A.Y.E"; Decimal)
        {

            CalcFormula = Sum ("Payroll Entries".Amount WHERE("Payroll Period" = FIELD("Starting Date"),
                                                           Paye = CONST(true)));
            FieldClass = FlowField;
        }
        field(9; "Basic Pay"; Decimal)
        {

            CalcFormula = Sum ("Payroll Entries".Amount WHERE("Payroll Period" = FIELD("Starting Date"),
              "Basic Salary Code" = CONST(true)));
            FieldClass = FlowField;
        }
        field(10; "CMS Starting Date"; Date)
        {
        }
        field(11; "CMS End Date"; Date)
        {
        }
        field(12; "Closed By"; Code[30])
        {
        }
        field(13; "Closed on Date"; DateTime)
        {
        }
        field(14; Type; Option)
        {
            OptionCaption = '" ,Daily,Weekly,Bi-Weekly,Monthly"';
            OptionMembers = " ",Daily,Weekly,"Bi-Weekly",Monthly;
        }
        field(15; Sendslip; Boolean)
        {
        }
        field(16; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Released,Canceled,Rejected';
            OptionMembers = Open,"Pending Approval",Released,Canceled,Rejected;
        }
        field(17; "Start Approval"; Boolean)
        {
        }
        field(18; "Period code"; Code[20])
        {
        }
        field(19; "Approval Status"; Integer)
        {
            //  CalcFormula = Count("Approval Entry" WHERE ("Document Type"=CONST("Training Request"),
            // "Document No." =FIELD("Period code")));
            FieldClass = Normal;
        }
        field(20; "No. Series"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Starting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

