table 50417 "Procurement Committee Setup"
{

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Description;Text[70])
        {
        }
        field(3;"Minimum Members";Integer)
        {
        }
        field(4;"Process Type";Option)
        {
            OptionCaption = 'None,Direct,Low Value,Open Tender,Restricted Tender,Request For Quotation,Request For Proposal,International Open Tender,National Open Tender';
            OptionMembers = "None",Direct,"Low Value","Open Tender","Restricted Tender","Request For Quotation","Request For Proposal","International Open Tender","National Open Tender";
        }
        field(5;"Process Stage";Option)
        {
            OptionCaption = '" ,Opening,Approval,Evaluation,Disposal,I&Acceptance"';
            OptionMembers = " ",Opening,Approval,Evaluation,Disposal,"I&Acceptance";
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
}

