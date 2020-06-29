page 51014 "Driver Setup List"
{
    // version TL2.0

    CardPageID = "Driver Setup Card";
    PageType = List;
    SourceTable = "Driver Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Full Names"; "Full Names")
                {
                    ApplicationArea = All;
                }
                field("ID NO."; "ID NO.")
                {
                    ApplicationArea = All;
                }
                field("Driving License"; "Driving License")
                {
                    ApplicationArea = All;
                }
                field(Designation; Designation)
                {
                    ApplicationArea = All;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

