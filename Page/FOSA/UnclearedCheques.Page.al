page 50093 "Uncleared Cheques"
{
    // version TL2.0

    CardPageID = "Teller Transaction";
    PageType = List;
    SourceTable = Transaction;
    SourceTableView = WHERE(Cheque = FILTER(false),
                            "Cheque Processed" = FILTER(true),
                            Deposited = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Maturity Due"; "Maturity Due")
                {ApplicationArea=All;
                }
                field("Expected Maturity Date"; "Expected Maturity Date")
                {ApplicationArea=All;
                }
                field("No."; "No.")
                {ApplicationArea=All;
                }
                field("Account No."; "Account No.")
                {ApplicationArea=All;
                }
                field("Account Name"; "Account Name")
                {ApplicationArea=All;
                }
                field("Transaction Type"; "Transaction Type")
                {ApplicationArea=All;
                }
                field(Amount; Amount)
                {ApplicationArea=All;
                }
                field("Transaction Date"; "Transaction Date")
                {ApplicationArea=All;
                }
                field("Transaction Time"; "Transaction Time")
                {ApplicationArea=All;
                }
                field("Cheque Type"; "Cheque Type")
                {ApplicationArea=All;
                }
                field("Cheque No"; "Cheque No")
                {ApplicationArea=All;
                }
                field("Cheque Date"; "Cheque Date")
                {ApplicationArea=All;
                }
                field(Payee; Payee)
                {ApplicationArea=All;
                }
                field("Bank No"; "Bank No")
                {ApplicationArea=All;
                }
                field("Bank Name"; "Bank Name")
                {ApplicationArea=All;
                }
                field("Bank Branch No."; "Bank Branch No.")
                {ApplicationArea=All;
                }
                field("Branch Name"; "Branch Name")
                {ApplicationArea=All;
                }
                field("Cheque Status"; "Cheque Status")
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Process Cheques")
            {
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    IF NOT "Maturity Due" THEN BEGIN
                        ERROR(Error000);
                    END;
                    IF CONFIRM(Text000) THEN BEGIN
                        // TellerManagement.ProcessCheques(Rec);
                    END;
                end;
            }
            action("Mark as Bounced")
            {
                Image = StaleCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    IF CONFIRM(Text003) THEN BEGIN
                        //TellerManagement.BouncedCheques(Rec);
                        "Cheque Status" := "Cheque Status"::Bounced;
                        MODIFY;
                    END;
                end;
            }
            action("Special Clearance")
            {
                Image = PostedVoucherGroup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    IF CONFIRM(Text000) THEN BEGIN
                        //TellerManagement.SpecialClearance(Rec);
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF "Expected Maturity Date" <= TODAY THEN BEGIN
            "Maturity Due" := TRUE;
            MODIFY;
        END;
    end;

    var
        Error000: Label 'Maturity Date for this date is not yet due!';
        Text000: Label 'Are you sure you want to process this cheque?';
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        BalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        Text001: Label 'Cheque Clearance';
        Text002: Label 'Cheque Processing Fee';
        TellerTransaction: Page "Teller Transaction";
        TransactionTypes: Record "Transaction Type";
        PaymentType: Option " ",Cheque,Cash;
        LineNo: Integer;
        ChequeType: Record "Cheque Type";
        AccountTypes: Record "Account Type";
        Vendor: Record "Vendor";

        Text003: Label 'Are you sure you want to mark this cheque as bounced?';
        Text004: Label 'Bounced Cheque Charges';
        Text005: Label 'Special Clearance Charges';
        Text006: Label 'Bounced Cheque';
    //TellerManagement: Codeunit "50013";
}

