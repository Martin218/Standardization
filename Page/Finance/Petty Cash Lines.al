page 50631 "Petty Cash Lines"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Imprest Lines";
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;

                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    BEGIN
                        IF "Account Type" <> "Account Type"::Vendor THEN BEGIN
                            ERROR('PETTY CASH CAN ONLY BE USED TO PAY VENDER!');
                        END;
                    END;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Applies to Doc. No"; "Applies to Doc. No")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Quantity; Quantity)
                {

                    ApplicationArea = All;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Link To Doc No."; "Link To Doc No.")
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

            group("Suggest Payments")
            {

                Caption = 'Suggest Payments';

                action("Suggest Imprest")
                {
                    Image = SuggestCustomerPayments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        CashManagement.SuggestImprest(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                action("Suggest Claim Lines")
                {
                    Image = SuggestCustomerBill;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        CashManagement.SuggestImprestClaim(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                action("Suggest Salary Advance")
                {
                    Image = SuggestCustomerBill;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        CashManagement.SuggestSalaryAdvance(Rec);
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        "Account Type" := "Account Type"::Vendor;
        IF CashManagement.EditImprestLines(Rec) = FALSE THEN BEGIN
            CurrPage.EDITABLE(FALSE);
        END;
    end;

    var
        CashManagement: Codeunit "Cash Management";
        ImprestLines: Record "Imprest Lines";
}

