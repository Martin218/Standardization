table 50238 "Separation Type"
{
    // version TL2.0


    fields
    {
        field(1;"Separation Type";Text[100])
        {
        }
        field(2;No;Integer)
        {
            AutoIncrement = true;
        }
        field(3;"Notice Period";Decimal)
        {
        }
        field(4;"Golden Handshake";Decimal)
        {
        }
        field(5;"Transport Allowance";Decimal)
        {
        }
        field(6;"Service Pay";Option)
        {
            OptionCaption = ',Yes,No';
            OptionMembers = ,Yes,No;
        }
        field(7;"Notification Type";Option)
        {
            OptionCaption = ',Employer to Employee,Employee to Employer,Not Applicable';
            OptionMembers = ,"Employer to Employee","Employee to Employer","Not Applicable";
        }
        field(8;"No. of Months Salary";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Separation Type")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Separation Type","Notice Period","Golden Handshake","Golden Handshake","Service Pay","Notification Type")
        {
        }
    }
}

