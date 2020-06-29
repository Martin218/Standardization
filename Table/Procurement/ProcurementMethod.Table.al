table 50404 "Procurement Method"
{

    fields
    {
        field(1;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[100])
        {
        }
        field(3;"Document Open Period";DateFormula)
        {
        }
        field(4;"Process Evaluation Period";DateFormula)
        {
        }
        field(5;"Award Approval";DateFormula)
        {
        }
        field(6;"Notification Of Award";DateFormula)
        {
        }
        field(7;"Contract Signing";DateFormula)
        {
        }
        field(8;"Time For Contract signature";DateFormula)
        {
        }
        field(9;"Time For Contract Completion";DateFormula)
        {
        }
        field(10;Method;Option)
        {
            OptionCaption = ',Direct,Low Value,Open Tender,Restricted Tender,Request For Quotation,Request For Proposal,International Open Tender,National Open Tender';
            OptionMembers = ,Direct,"Low Value","Open Tender","Restricted Tender","Request For Quotation","Request For Proposal","International Open Tender","National Open Tender";
        }
        field(11;"Closing Period";DateFormula)
        {
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

