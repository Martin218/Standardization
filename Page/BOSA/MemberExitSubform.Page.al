page 50231 "Member Exit Subform"
{
    // version TL2.0

    Editable = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Member Exit Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Category"; "Account Category")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = All;
                }
                field("Account Ownership"; "Account Ownership")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Boost Shares")
            {
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    BOSAManagement: Codeunit "BOSA Management";
                    MemberExitLine: Record "Member Exit Line";
                begin
                    CurrPage.SETSELECTIONFILTER(MemberExitLine);
                    BOSAManagement.BoostShares(MemberExitLine);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        FILTERGROUP(0);
    end;
}

