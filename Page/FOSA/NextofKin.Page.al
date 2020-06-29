page 50006 "Next of Kin"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Beneficiary Type";
    SourceTableView = WHERE(Type = FILTER("Next of Kin"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Name)
                {ApplicationArea=All;
                }
                field("National ID"; "National ID")
                {ApplicationArea=All;
                }
                field("Phone No."; "Phone No.")
                {ApplicationArea=All;
                }
                field(Relationship; Relationship)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

