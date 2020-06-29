table 50422 "Supplier Evaluation"
{

    fields
    {
        field(1;"Vendor No.";Code[20])
        {
        }
        field(2;"Evaluation Stage";Option)
        {
            OptionCaption = '" ,Mandatory,Technical,Financial,Awarding"';
            OptionMembers = " ",Mandatory,Technical,Financial,Awarding;
        }
        field(3;"Evaluation Code";Code[10])
        {

            trigger OnValidate();
            begin
                IF ProcurementRequirementSetup.GET("Evaluation Code") THEN BEGIN
                  "Evaluation Description" := ProcurementRequirementSetup.Description;
                  "Needs Attachment" := ProcurementRequirementSetup."Needs Attachment";
                END;
            end;
        }
        field(4;"Evaluation Description";Text[200])
        {
        }
        field(5;"Needs Attachment";Boolean)
        {
            Editable = false;
        }
        field(6;"Document Attached";Boolean)
        {
        }
        field(7;"Score(%)";Decimal)
        {

            trigger OnValidate();
            begin
                IF "Score(%)" > 100 THEN
                  ERROR(GreaterScoreErr)
                ELSE IF "Score(%)" < 0 THEN
                  ERROR(LessScoreErr);
            end;
        }
        field(8;"Success Option";Option)
        {
            OptionCaption = '" ,Pass,Fail"';
            OptionMembers = " ",Pass,Fail;
        }
        field(9;"Evaluating UserID";Code[80])
        {
        }
        field(10;"Process No.";Code[20])
        {
        }
        field(11;Remarks;Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Vendor No.","Evaluation Code","Process No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ProcurementRequirementSetup : Record "Procurement Requirement Setup";
        GreaterScoreErr : Label 'Score cannot go beyond 100%';
        LessScoreErr : Label 'Score cannot be less than 0%';
}

