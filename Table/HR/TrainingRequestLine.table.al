table 50235 "Training Request Line"
{
    // version TL2.0


    fields
    {
        field(1; "Training Request No."; Code[20])
        {
            Editable = false;

            trigger OnValidate();
            begin
                CALCFIELDS("Training Cost");
                ValidateTotalCost;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee.FullName;
                    Branch := Employee."Branch Name";
                    Department := Employee."Department Name";
                    "Job Title" := Employee."Job Title";
                    Grade := Employee.Grade;
                    "Employment Date" := Employee."Employment Date";
                    "Confirmation Date" := Employee."Confirmation/Dismissal Date";
                    "Employment Status" := Employee.Status;
                    CALCFIELDS("Training Cost", "Other Costs");
                    ValidateTotalCost;
                END;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(4; Branch; Text[50])
        {
            Editable = false;
        }
        field(5; Department; Text[100])
        {
            Editable = false;
        }
        field(6; "Job Title"; Text[100])
        {
            Editable = false;
        }
        field(7; Grade; Code[10])
        {
            Editable = false;
        }
        field(8; "Employment Date"; Date)
        {
            Editable = false;
        }
        field(9; "Confirmation Date"; Date)
        {
            Editable = false;
        }
        field(10; "Employment Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Inactive,Terminated,Probation,Confirmed,Suspended,Separated';
            OptionMembers = Active,Inactive,Terminated,Probation,Confirmed,Suspended,Separated;
        }
        field(11; "Training Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Training Request"."Cost of Training" WHERE("No." = FIELD("Training Request No.")));
            Editable = false;


            trigger OnValidate();
            begin
                ValidateTotalCost;
            end;
        }
        field(12; "Other Costs"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Training Cost".Amount);
            Editable = false;


            trigger OnValidate();
            begin
                IF TrainingRequest.GET("Training Request No.") THEN BEGIN
                    TrainingRequest.CALCFIELDS("Total Cost of Training");
                    TrainingRequest.MODIFY;
                END;
            end;
        }
        field(13; "Total Cost"; Decimal)
        {
        }
        field(17; Cost; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Training Request No.", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record 5200;
        TrainingRequest: Record 50234;

    local procedure ValidateTotalCost();
    var
        TrainingRequest: Record 50234;
    begin
        "Total Cost" := "Other Costs" + "Training Cost";
    end;
}

