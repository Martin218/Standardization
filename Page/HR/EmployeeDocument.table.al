table 50228 "Employee Document"
{
    // version TL2.0


    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;

        }
        field(2; "Employee No"; Code[50])
        {

        }
        field(3; "Employee Name"; Code[100])
        {

        }
        field(4; "File Name"; Text[250])
        {

        }
        field(5; Name; Text[250])
        {

        }
        field(6; "Separation Documents"; Boolean)
        {

        }
        field(7; "Document Type"; Option)
        {
            OptionCaption = ',Handover Report,Clearance Form,Exit Interview Form,Other Documents';
            OptionMembers = ,"Handover Report","Clearance Form","Exit Interview Form","Other Documents";

        }
    }

    keys
    {
        key(Key1; No, "Employee No")
        {

        }
    }

    fieldgroups
    {
    }
}

