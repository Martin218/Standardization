table 50421 "Procurement Requirement Setup"
{

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[100])
        {
        }
        field(3;"Needs Attachment";Boolean)
        {
        }
        field(4;"Evaluation Stage";Option)
        {
            OptionCaption = '" ,Mandatory,Technical,Financial,Awarding"';
            OptionMembers = " ",Mandatory,Technical,Financial,Awarding;
        }
        field(5;"No. Series";Code[20])
        {
        }
        field(6;"Procurement Option";Option)
        {
            OptionCaption = ',Direct,Low Value,Open Tender,Restricted Tender,Request For Quotation,Request For Proposal,International Open Tender,National Open Tender,All';
            OptionMembers = ,Direct,"Low Value","Open Tender","Restricted Tender","Request For Quotation","Request For Proposal","International Open Tender","National Open Tender",All;
        }
        field(7;Status;Option)
        {
            OptionCaption = 'Created,Open,Reviewed';
            OptionMembers = Created,Open,Reviewed;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        ProcurementSetup.GET;
        ProcurementSetup.TESTFIELD("Evaluation Requirement No.");
        NoSeriesManagement.InitSeries(ProcurementSetup."Evaluation Requirement No.",xRec.Code,0D,Code,"No. Series");
        "Procurement Option" := "Procurement Option"::All;
    end;

    var
        PrimaryKeyNo : Integer;
        NoSeriesManagement : Codeunit NoSeriesManagement;
        ProcurementSetup : Record "Procurement Setup";
}

