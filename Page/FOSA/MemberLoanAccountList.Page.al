page 50202 "Member Loan Account List"
{
    // version TL2.0

    Caption = 'Member Loan Accounts';
    CardPageID = "Member Loan Account Card";
    PageType = List;
    SourceTable = Customer;
    SourceTableView = WHERE("Member No." = FILTER(<> ''));
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                }

                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

