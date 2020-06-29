pageextension 50502 "Accountant Mngr Role Center" extends "Accounting Manager Role Center"
{
    layout
    {
       
   
    }
    actions
    { 
        addlast(processing)
        {
            group("Cash Mnnt Setup")
            {
                 Caption = 'Cash Management Setup';
                action("Cash Management Setup")
                {
                  
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Management Setup';
                    Image = QuestionaireSetup;
                    RunObject = Page "Pay Period Setup";
                    ToolTip = 'Set up core functionality such as Cash Management Setup';
                }
                action("Account Mapping")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Account Mapping';
                    Image = QuestionaireSetup;
                    RunObject = Page "Pay Period Setup";
                    ToolTip = 'Set up core functionality such as Account Mapping';
                }
            }

        }
    }
}