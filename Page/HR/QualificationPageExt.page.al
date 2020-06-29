pageextension 50933 "Qualification Extension" extends Qualifications
{
    layout
    {
        addafter(Description)
        {
            field("Qualification Type"; "Qualification Type")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}