tableextension 50291 "HR Setup Extension" extends "Human Resources Setup"
{
    // version NAVW111.00;TL2.0

    fields
    {
        field(32; "Leave Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(5; "Leave Plan Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(6; "Disciplinary Cases Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(7; "Incident Nos"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(8; "File Path"; Text[250])
        {
        }
        field(9; "Leave Recall Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(10; "HR E-Mail"; Text[80])
        {
        }
        field(11; "Employee Docs File Path"; Text[250])
        {
        }
        field(12; "Permanent Probation"; DateFormula)
        {
        }
        field(13; "Intern Probation"; DateFormula)
        {
        }
        field(14; "Contract Probation"; DateFormula)
        {
        }
        field(15; "Staff Transfer Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; "Training Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "Training Request Source"; Option)
        {
            OptionCaption = '" ,Employee,HOD,Both"';
            OptionMembers = " ",Employee,HOD,Both;
        }
        field(18; "Separation No"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(19; "Recruitment Needs Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(20; "Department Dimension Code"; Code[10])
        {
            TableRelation = Dimension.Code;
        }
        field(21; "Use Quantitative Goals"; Boolean)
        {
        }
        field(22; "Use Qualitative Goals"; Boolean)
        {
        }
        field(23; "Individual Appraisal"; Boolean)
        {
        }
        field(24; "Supervisor Appraisal"; Boolean)
        {
        }
        field(25; "Agreed Appraisal"; Boolean)
        {
        }
        field(26; "Contract Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(27; "Capture Training Requests"; Boolean)
        {
        }
        field(28; "Evaluation No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(29; "Job Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(30; "Review Frequency"; Option)
        {
            OptionCaption = ',Monthly,Quarterly,Bi-Annually,Annually';
            OptionMembers = ,Monthly,Quarterly,"Bi-Annually",Annually;
        }
        field(31; "Performance Review Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
    }

    fieldgroups
    {
    }

    var
        HumanResUnitOfMeasure: Record 5220;
        Text001: Label 'You cannot change %1 because there are %2.';
}

