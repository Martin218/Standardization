page 50024 "Teller General Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Teller General Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Teller Maximum Withholding"; "Teller Maximum Withholding")
                {ApplicationArea=All;
                }
                field("Teller Replenishing Level"; "Teller Replenishing Level")
                {ApplicationArea=All;
                }
                field("Treasury Maximum Withholding"; "Treasury Maximum Withholding")
                {ApplicationArea=All;
                }
                field("Teller Notification Level"; "Teller Notification Level")
                {ApplicationArea=All;
                }
                field("Approve Return To Treasury"; "Approve Return To Treasury")
                {ApplicationArea=All;
                }
                field("Approve Close Till"; "Approve Close Till")
                {ApplicationArea=All;
                }
            }
            group("No. Series")
            {
                field("Cash Deposit Nos."; "Cash Deposit Nos.")
                {ApplicationArea=All;
                }
                field("Cheque Deposit Nos."; "Cheque Deposit Nos.")
                {ApplicationArea=All;
                }
                field("Cash Withdrawal Nos."; "Cash Withdrawal Nos.")
                {ApplicationArea=All;
                }
                field("Cheque Withdrawal Nos."; "Cheque Withdrawal Nos.")
                {ApplicationArea=All;
                }
                field("Inter-Account Nos."; "Inter-Account Nos.")
                {ApplicationArea=All;
                }
            }
            part(TellerExcessShorttageSubform; "Teller Shortage/Excess Account")
            {
            }
        }
    }

    actions
    {
    }
}

