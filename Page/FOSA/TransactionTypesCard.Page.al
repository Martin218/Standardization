page 50025 "Transaction Types Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Charges,Approval Request,Comments,Category 7,Category 8';
    SourceTable = "Transaction -Type";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {ApplicationArea=All;
                }
                field(Description; Description)
                {ApplicationArea=All;
                }
                field("Application Area"; "Application Area")
                {ApplicationArea=All;
                }
                 field(Type; Type)
                 {
                     ApplicationArea=All;
                 }
                field("Service ID"; "Service ID")
                {ApplicationArea=All;
                }
            }
            group(Posting)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                field("Priority Posting"; "Priority Posting")
                {

                    trigger OnValidate()
                    begin
                        IF "Priority Posting" THEN
                            ShowPriorityPosting := TRUE
                        ELSE
                            ShowPriorityPosting := FALSE;
                    end;
                }
                group("Control Account")
                {
                    field("Sett. Control Account Type"; "Sett. Control Account Type")
                    {
                    }
                    field("Sett. Control Account No."; "Sett. Control Account No.")
                    {
                    }
                }
                group(SACCO)
                {
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    field("Settlement Account Type"; "Settlement Account Type")
                    {
                    }
                    field("Settlement Account No."; "Settlement Account No.")
                    {
                    }
                }
                group(TL)
                {
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    field("Settlement2 Account Type"; "Settlement2 Account Type")
                    {
                    }
                    field("Settlement2 Account No."; "Settlement2 Account No.")
                    {
                    }
                }
                group(COOP)
                {
                    field("Settlement3 Account No."; "Settlement3 Account No.")
                    {
                    }
                    field("Settlement3 Account Type"; "Settlement3 Account Type")
                    {
                    }
                }
                group(AGENT)
                {
                    field("Settlement4 Account Type"; "Settlement4 Account Type")
                    {
                    }
                }
                group("Statutory Deductions")
                {
                    field("Deduct Excise Duty"; "Deduct Excise Duty")
                    {
                    }
                    field("Deduct Stamp Duty"; "Deduct Stamp Duty")
                    {
                    }
                    field("Deduct Withholding Tax"; "Deduct Withholding Tax")
                    {
                    }
                    field("Charge Penalty"; "Charge Penalty")
                    {
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Transaction Charges")
            {
                Image = ProdBOMMatrixPerVersion;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    TransactionCharge.RESET;
                    //TransactionCharge.SETRANGE("Transaction Type Code", Code);
                    PAGE.RUN(50027, TransactionCharge);
                end;
            }
            action("Priority Posting2")
            {
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                PromotedOnly = true;
                //RunObject = Page 50070;
                // RunPageLink = "Transaction Type" = FIELD(Code);
                Visible = ShowPriorityPosting;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetVisible;
    end;

    var
        TransactionCharge: Record "Transaction Charge";
        IsSaccoGroupVisible: Boolean;
        IsTLGroupVisible: Boolean;
        IsCOOPGroupVisible: Boolean;
        IsAgentGroupVisible: Boolean;
        ShowPriorityPosting: Boolean;

    local procedure SetVisible()
    begin
        IF "Priority Posting" THEN BEGIN
            ShowPriorityPosting := TRUE;
        END;
    end;
}

