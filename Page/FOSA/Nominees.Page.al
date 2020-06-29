page 50005 Nominees
{
    // version TL2.0

    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Beneficiary Type";
    SourceTableView = WHERE(Type = FILTER(Nominee));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("National ID"; "National ID")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Allocation (%)"; "Allocation (%)")
                {
                    ApplicationArea = All;
                }
                field(Picture; Picture)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Person;
                }
                field(Signature; Signature)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Person;
                }
                field("Front Side ID"; "Front ID")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Person;
                }
                field("Back Side ID"; "Back ID")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Person;
                }
            }
        }
        area(factboxes)
        {
            part("Nominee Picture"; "Nominee Picture")
            {
                ApplicationArea = All;
                SubPageLink = "Application No." = FIELD("Application No."), "Line No." = field("Line No.");

            }
            part("Nominee Front ID"; "Nominee Front ID")
            {
                ApplicationArea = All;
                SubPageLink = "Application No." = FIELD("Application No."), "Line No." = field("Line No.");

            }
            part("Nominee Back ID"; "Nominee Back ID")
            {
                ApplicationArea = All;
                SubPageLink = "Application No." = FIELD("Application No."), "Line No." = field("Line No.");

            }
            part("Nominee Signature"; "Nominee Signature")
            {
                ApplicationArea = All;
                SubPageLink = "Application No." = FIELD("Application No."), "Line No." = field("Line No.");

            }
        }

    }
}


