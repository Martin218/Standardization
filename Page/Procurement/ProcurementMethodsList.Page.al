page 50805 "Procurement Methods List"
{

    PageType = List;
    SourceTable = "Procurement Method";
    Caption = 'Procurement Methods List';
    CardPageId = "Procurement Methods";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Method; Method)
                {
                    ApplicationArea = All;
                }
                field("Award Approval"; "Award Approval")
                {
                    ApplicationArea = All;
                }
                field("Closing Period"; "Closing Period")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
