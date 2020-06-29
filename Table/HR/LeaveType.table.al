table 50208 "Leave Type"
{
    // version TL2.0


    fields
    {
        field(1;"Code";Code[20])
        {
            NotBlank = true;
        }
        field(2;Description;Text[200])
        {
        }
        field(3;Days;Decimal)
        {
        }
        field(4;"Acrue Days";Boolean)
        {
        }
        field(5;"Unlimited Days";Boolean)
        {
        }
        field(6;Gender;Option)
        {
            OptionCaption = 'Both,Male,Female';
            OptionMembers = Both,Male,Female;
        }
        field(7;Balance;Option)
        {
            OptionCaption = 'Ignore,Carry Forward,Convert to Cash';
            OptionMembers = Ignore,"Carry Forward","Convert to Cash";
        }
        field(8;"Calendar Days";Boolean)
        {

            trigger OnValidate();
            begin
                IF "Calendar Days" THEN BEGIN
                    IF Weekdays THEN BEGIN
                       ERROR(Error000);
                    END;
                END;
            end;
        }
        field(9;Weekdays;Boolean)
        {

            trigger OnValidate();
            begin
                IF Weekdays THEN BEGIN
                    IF "Calendar Days" THEN BEGIN
                       ERROR(Error000);
                    END;
                END;
            end;
        }
        field(11;"Off/Holidays Days Leave";Boolean)
        {
        }
        field(12;"Max Carry Forward Days";Decimal)
        {

            trigger OnValidate();
            begin
                IF Balance<>Balance::"Carry Forward" THEN
                "Max Carry Forward Days":=0;
            end;
        }
        field(13;"Conversion Rate Per Day";Decimal)
        {
        }
        field(14;"Annual Leave";Boolean)
        {
        }
        field(15;Status;Option)
        {
            OptionMembers = Active,Inactive;
        }
        field(16;"Eligible Staff";Option)
        {
            OptionCaption = 'Both,Permanent,Temporary';
            OptionMembers = Both,Permanent,"Temporary";
        }
        field(17;"Contract Days";Decimal)
        {
        }
        field(18;"Notice Period";Decimal)
        {
        }
        field(19;"Minimum Days Allowed";Decimal)
        {
        }
        field(20;"Maximum Days Allowed";Decimal)
        {
        }
        field(21;"Employment Status";Option)
        {
            OptionCaption = ',Confirmed,Both';
            OptionMembers = ,Confirmed,Both;
        }
        field(22;"Minimum Balance Allowed";Decimal)
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

    var
        Error000 : Label 'Only one option is allowed! Either Calendar Days or Weekdays!';
}

