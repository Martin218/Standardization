table 50335 "Bank Name"
{
    // version TL 2.0

    DataCaptionFields = "Bank Code","BAnk Name";
   // DrillDownPageID = 50536;
   // LookupPageID = 50536;

    fields
    {
        field(1;"Bank Code";Code[10])
        {
        }
        field(2;"BAnk Name";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Bank Code")
        {
        }
        key(Key2;"BAnk Name")
        {
        }
    }

    fieldgroups
    {
    }
}

