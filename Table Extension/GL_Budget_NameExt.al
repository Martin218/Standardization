tableextension 50428 "G/L Budget Name Ext" extends "G/L Budget Name"
{
    fields
    {
 field(8;"Budget Period";Option)
        {
            OptionCaption = ',Yearly,Monthly';
            OptionMembers = ,Yearly,Monthly;
        }
        field(9;"Budget Start Date";Date)
        {
            TableRelation = "Accounting Period" WHERE (Closed=CONST(false));
        }
        field(10;"Budget End Date";Date)
        {
            TableRelation = "Accounting Period" WHERE (Closed=CONST(false));
        }
        field(11;"Budget Per Branch?";Boolean)
        {
        }
        field(12;"Budget Per Department?";Boolean)
        {
        }
        field(13;"Forwarded To CEO?";Boolean)
        {
        }
        field(14;"CEO Approved";Boolean)
        {
        }
        field(15;"Procurement Plan Approved";Boolean)
        {
        }
        field(16;"Procurement Plan Status";Option)
        {
            OptionCaption = 'Open,Pending Approval,Released';
            OptionMembers = Open,"Pending Approval",Released;
        }
    }
}