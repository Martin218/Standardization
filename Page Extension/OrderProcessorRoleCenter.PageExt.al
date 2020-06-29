pageextension 50120 "PRE Order Processor RC" extends "Order Processor Role Center"
{

    actions
    {
        addfirst(Sections)
        {
            group("BOSA")
            {
                action("Customer Bank Account List")
                {
                    RunObject = page "Customer Bank Account List";
                    ApplicationArea = All;
                }
                action("Customer Ledger Entries")
                {
                    RunObject = page "Customer Ledger Entries";
                    ApplicationArea = All;
                }

                // Creates a sub-menu
                group("Sales Documents")
                {
                    action("Sales Document Entity")
                    {
                        ApplicationArea = All;
                        RunObject = page "Sales Document Entity";
                    }
                    action("Sales Document Line Entity")
                    {
                        ApplicationArea = All;
                        RunObject = page "Sales Document Line Entity";
                    }
                }
            }
        }
        addlast(Embedding)
        {
            action("Members")
            {
                RunObject = page "Sales Cycles";
                ApplicationArea = All;
            }
        }
        addlast(Creation)
        {
            action("Loan Application")
            {
                ApplicationArea = All;
                RunObject = page "Sales Journal";
            }
        }
        addlast(Processing)
        {
            group("Periodic Activities")
            {
                action("Capitalize Interest")
                {
                    ApplicationArea = All;
                    RunObject = report "Capitalize Interest";
                }
                action("Run Standing Orders")
                {
                    ApplicationArea = All;
                    RunObject = report "Run Standing Order";
                }
                action("Generate Classification")
                {
                    ApplicationArea = All;
                    RunObject = report "Generate Loan Classification";
                }
            }

            group(Documents)
            {
                action("Loan Classification")
                {
                    ApplicationArea = All;
                    RunObject = page "Sales Document Entity";
                }
                action("Defaulted Loans")
                {
                    ApplicationArea = All;
                    RunObject = page "Sales Document Line Entity";
                }
            }
        }
        addlast(Reporting)
        {
            action("Classification Summary")
            {
                ApplicationArea = All;
                RunObject = report "Classification Summary";
            }
        }
    }

}
