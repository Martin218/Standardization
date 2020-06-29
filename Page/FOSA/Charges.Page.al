page 50051 Charges
{
    // version TL2.0

    PageType = List;
    SourceTable = Charge;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Charge Code"; "Charge Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Charge Amount"; "Charge Amount")
                {
                    ApplicationArea = All;
                }
                field("Percentage of Amount"; "Percentage of Amount")
                {
                    ApplicationArea = All;
                }
                field("Use Percentage"; "Use Percentage")
                {
                    ApplicationArea = All;
                }
                field("GL Account"; "GL Account")
                {
                    ApplicationArea = All;
                }
                field("Minimum Amount"; "Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; "Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field("Deduct Excise"; "Deduct Excise")
                {
                    ApplicationArea = All;
                }
                field("Excise %"; "Excise %")
                {
                    ApplicationArea = All;
                }
                field("Excise G/L Account"; "Excise G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Posting Description"; "Posting Description")
                {
                    ApplicationArea = All;
                }
                field(Interbranch; Interbranch)
                {
                    ApplicationArea = All;
                }
                field("Settlement Amount"; "Settlement Amount")
                {
                    ApplicationArea = All;
                }
                field("Settlement GL Account"; "Settlement GL Account")
                {
                    ApplicationArea = All;
                }
                field(Mobile; Mobile)
                {
                    ApplicationArea = All;
                }
                field(Classified; Classified)
                {
                    ApplicationArea = All;
                }
                field("Stamp Duty"; "Stamp Duty")
                {
                    ApplicationArea = All;
                }
                field("Stamp Duty G/L Account"; "Stamp Duty G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Safaricom Account"; "Safaricom Account")
                {
                    ApplicationArea = All;
                }
                field("Safaricom Amount"; "Safaricom Amount")
                {
                    ApplicationArea = All;
                }
                field("TL Account"; "TL Account")
                {
                    ApplicationArea = All;
                }
                field("TL Amount"; "TL Amount")
                {
                    ApplicationArea = All;
                }
                field("Agent Store"; "Agent Store")
                {
                    ApplicationArea = All;
                }
                field("Agent Settlement Amount"; "Agent Settlement Amount")
                {
                    ApplicationArea = All;
                }
                field("Settlement Bank"; "Settlement Bank")
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

