pageextension 50811 VendorPageEXT extends "Vendor Card"
{

    layout
    {
        addafter("Search Name")
        {
            field("Vendor Type"; "Vendor Type")
            {
                ApplicationArea = All;
            }

            field("Pre-Qualified"; "Pre-Qualified")
            {
                ApplicationArea = All;
            }
            field("Prequalified Category Desc"; "Prequalified Category Desc")
            {
                ApplicationArea = All;
            }
            field("Prequalified Category Code"; "Prequalified Category Code")
            {
                ApplicationArea = All;
            }
            /* field("Bank Code"; "Bank Code")
            {
                ApplicationArea = All;
            }
            field("KBA Code"; "KBA Code")
            {
                ApplicationArea = All;
            }
            field("Bank Account"; "Bank Account")
            {
                ApplicationArea = All;
            } */
        }

    }

}
