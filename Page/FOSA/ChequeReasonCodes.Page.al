page 50167 "Cheq. Reason Codes"
{
    // version TL2.0

    Caption = 'Cheque Reason Codes';
    PageType = List;
    SourceTable = "CC Reason Code";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
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
            }
        }
    }

    actions
    {
    }
}

