tableextension 50425 "Dimension Value Ext" extends "Dimension Value"
{
    Caption = 'Dimension Value.TableExt.al';
    //DataClassification = ToBeClassified;

    fields
    {
        field(13; "Global Dimension No2"; Code[10])
        {
            Caption = 'Global Dimension No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Global Dimension No2")
        {
            //Clustered = true;
        }
    }

}
