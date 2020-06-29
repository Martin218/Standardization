tableextension 50429 ItemExt extends Item
{
    Caption = 'ItemExt';
    //DataClassification = ToBeClassified;

    fields
    {
        field(50000; "Item Category"; Option)
        {
            OptionMembers = Consumable,"Non Consumable";
            OptionCaption = 'Consumable,Non Consumable';
        }
    }
    keys
    {
    }

}
