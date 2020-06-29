page 50056 "Company Signatory"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Beneficiary Type";
    SourceTableView = WHERE(Type = CONST("Company Signatory"));

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
                field(Position; Position)
                {
                    ApplicationArea = All;
                }
                field(Signature; Signature)
                {
                    ApplicationArea = All;
                }
                field("Front Side ID"; "Front ID")
                {
                    ApplicationArea = All;
                }
                field("Back Side ID"; "Back ID")
                {
                    ApplicationArea = All;
                }
                field(Picture; Picture)
                {
                    ApplicationArea = All;
                }
                field("Allocation (%)"; "Allocation (%)")
                {
                    ApplicationArea = All;
                }
                field("Witness Name"; "Witness Name")
                {
                    ApplicationArea = All;
                }
                field("Witness National ID"; "Witness National ID")
                {
                    ApplicationArea = All;
                }
                field("Witness Mobile No."; "Witness Mobile No.")
                {
                    ApplicationArea = All;
                }
                field("Witness Postal Address"; "Witness Postal Address")
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

