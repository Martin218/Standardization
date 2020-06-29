page 50752 "Pre-Qualified Supplier Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Prequalified Suppliers";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Category Code"; "Category Code")
                {
                    ApplicationArea = All;
                }
                field("Category Description"; "Category Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                }
                field("Company PIN No."; "Company PIN No.")
                {
                    ApplicationArea = All;
                }
                field(City; City)
                {
                    ApplicationArea = All;
                }
                field(County; County)
                {
                    ApplicationArea = All;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Contact; Contact)
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Home Page"; "Home Page")
                {
                    ApplicationArea = All;
                }
            }
            group("Other Details")
            {
                field("AGPO Cert"; "AGPO Cert")
                {
                    ApplicationArea = All;
                }
                field("AGPO Category"; "AGPO Category")
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; "Bank Account")
                {
                    ApplicationArea = All;
                }
                field("KBA Code"; "KBA Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Code"; "Bank Code")
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

