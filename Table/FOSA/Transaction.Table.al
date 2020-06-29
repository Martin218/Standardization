table 50025 Transaction
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[30])
        {
        }
        field(2; "Account No."; Code[30])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                TESTFIELD("Transaction Type");
                IF Vend.GET("Account No.") THEN BEGIN
                    "Account Name" := Vend.Name;
                    "Member No." := Vend."Member No.";
                    Members.GET(Vend."Member No.");
                    "Member Name" := Members.Surname + ' ' + Members."First Name" + ' ' + Members."Last Name";
                    //   "ID No.":=Vend."National ID";
                    Cashier := USERID;
                    "Transacted By" := "Member Name";

                    //Update account details
                    AccountTypes.GET(Vend."Account Type");
                    IF Withdrawal THEN BEGIN
                        IF AccountTypes."Allow Withdrawal" = FALSE THEN BEGIN
                            ERROR(Error001);
                        END;
                    END;
                    "Account Type" := AccountTypes.Code;
                    "Account Description" := AccountTypes.Description;
                    "Minimum Account Balance" := AccountTypes."Minimum Balance";
                    Vend.CALCFIELDS(Balance);
                    CALCFIELDS("Book Balance");
                    "Available Balance" := Vend.Balance - AccountTypes."Minimum Balance";
                END;
            end;
        }
        field(3; "Account Name"; Text[200])
        {
        }
        field(4; "Transaction Type"; Code[30])
        {
            NotBlank = true;
            TableRelation = "Transaction -Type" WHERE("Application Area" = FILTER(Teller));

            trigger OnValidate()
            begin
                TellerGeneralSetup.GET;
                IF TransactionTypes.GET("Transaction Type") THEN BEGIN
                    IF TransactionTypes.Type = TransactionTypes.Type::"Teller Cash Deposit" THEN BEGIN
                        "No." := NoSeriesMgt.GetNextNo(TellerGeneralSetup."Cash Deposit Nos.", 0D, TRUE);
                        //Rename(NoSeriesMgt.GetNextNo(TellerGeneralSetup."Cash Deposit Nos.", 0D, TRUE));
                        Deposit := TRUE;
                        Withdrawal := FALSE;
                        Cheque := FALSE;
                        "Inter Account" := FALSE;
                    END;
                    IF TransactionTypes.Type = TransactionTypes.Type::"Teller Cash Withdrawal" THEN BEGIN
                        "No." := NoSeriesMgt.GetNextNo(TellerGeneralSetup."Cash Withdrawal Nos.", 0D, TRUE);
                        Deposit := FALSE;
                        Withdrawal := TRUE;
                        Cheque := FALSE;
                        "Inter Account" := FALSE;
                    END;
                    IF TransactionTypes.Type = TransactionTypes.Type::"Teller Cheque Deposit" THEN BEGIN
                        "No." := NoSeriesMgt.GetNextNo(TellerGeneralSetup."Cheque Deposit Nos.", 0D, TRUE);
                        Deposit := FALSE;
                        Withdrawal := FALSE;
                        Cheque := TRUE;
                        "Inter Account" := FALSE;
                    END;
                    IF TransactionTypes.Type = TransactionTypes.Type::PesaLink THEN BEGIN
                        "No." := NoSeriesMgt.GetNextNo(TellerGeneralSetup."Inter-Account Nos.", 0D, TRUE);
                        Deposit := FALSE;
                        Withdrawal := FALSE;
                        Cheque := FALSE;
                        "Inter Account" := TRUE;
                    END;
                END;

                TreasuryCoinage.RESET;
                TreasuryCoinage.SETRANGE(TreasuryCoinage."No.", "No.");
                IF TreasuryCoinage.FIND('-') THEN
                    EXIT;

                CBSSetup.GET;
                IF CBSSetup."Coinage Mandatory" THEN BEGIN
                    IF NOT Cheque OR "Inter Account" THEN BEGIN
                        Denomination.RESET;
                        TreasuryCoinage.RESET;
                        Denomination.INIT;
                        IF Denomination.FIND('-') THEN BEGIN
                            REPEAT
                                TreasuryCoinage.INIT;
                                TreasuryCoinage."No." := "No.";
                                TreasuryCoinage.Code := Denomination.Code;
                                TreasuryCoinage.Description := Denomination.Description;
                                TreasuryCoinage.Type := Denomination.Type;
                                TreasuryCoinage.Value := Denomination.Value;
                                TreasuryCoinage.Quantity := 0;
                                TreasuryCoinage.Priority := Denomination.Priority;
                                TreasuryCoinage.INSERT;
                            UNTIL Denomination.NEXT = 0;
                        END;
                    END;
                END;

                TellerSetup.GET(USERID);
                "Teller Tills" := TellerSetup."Till No";
                BankAccount.GET("Teller Tills");
                IF BankAccount.Blocked THEN BEGIN
                    ERROR(Error002);
                END;

                BankAccount.CALCFIELDS(Balance);
                "Teller Balance" := BankAccount.Balance;
                "Transaction Date" := TODAY;
                "Transaction Time" := TIME;
            end;
        }
        field(5; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                IF Withdrawal THEN BEGIN
                    IF Amount > "Available Balance" THEN BEGIN
                        ERROR(Error000);
                    END;
                    IF Amount > "Teller Balance" THEN BEGIN
                        ERROR(Error004);
                    END;
                END;
                IF Amount <= 0 THEN BEGIN
                    ERROR(Error003);
                END;
            end;
        }
        field(6; Cashier; Code[30])
        {
        }
        field(7; "Transaction Date"; Date)
        {

            trigger OnValidate()
            begin
                IF ChequeTypes.GET("Cheque Type") THEN BEGIN
                    Description := ChequeTypes.Description;
                    "Clearing Charges" := ChequeTypes."Clearing Charges";
                    "Clearing Days" := ChequeTypes."Clearing Days";
                    "Expected Maturity Date" := CALCDATE(ChequeTypes."Clearing Days", "Transaction Date");
                END;
            end;
        }
        field(8; "Transaction Time"; Time)
        {
        }
        field(9; Posted; Boolean)
        {
            Editable = true;
        }
        field(10; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(11; "Account Type"; Code[30])
        {
        }
        field(12; "Account Description"; Text[50])
        {
        }
        field(14; "Cheque Type"; Code[30])
        {
            TableRelation = "Cheque Type";

            trigger OnValidate()
            begin
                IF ChequeTypes.GET("Cheque Type") THEN BEGIN
                    Description := ChequeTypes.Description;
                    "Clearing Charges" := ChequeTypes."Clearing Charges";
                    "Clearing Days" := ChequeTypes."Clearing Days";
                    ClearingDays := ChequeTypes.CDays;
                    NonWorkingDays := 0;
                    CurrentDate := TODAY;
                    IF ChequeTypes.CDays <> 0 THEN BEGIN
                        REPEAT
                            BaseCalendarChange.RESET;
                            BaseCalendarChange.SETRANGE("Base Calendar Code", 'CBS');
                            BaseCalendarChange.SETRANGE(Date, CurrentDate);
                            IF BaseCalendarChange.FINDFIRST THEN BEGIN
                                NonWorkingDays += 1;
                            END ELSE BEGIN
                                ClearingDays -= 1;
                            END;
                            CurrentDate := CALCDATE('1D', CurrentDate);
                        UNTIL ClearingDays = 1;
                        "Expected Maturity Date" := CALCDATE(FORMAT(NonWorkingDays + ChequeTypes.CDays - 1) + 'D', TODAY);
                    END ELSE BEGIN
                        "Expected Maturity Date" := TODAY;
                    END;
                END;
            end;
        }
        field(15; "Cheque No"; Text[100])
        {
        }
        field(16; "Cheque Date"; Date)
        {
        }
        field(17; Payee; Text[100])
        {
        }
        field(19; "Bank No"; Code[30])
        {
            Caption = 'Drawer Bank No';
            TableRelation = Banks;

            trigger OnValidate()
            begin
                IF Banks.GET("Bank No") THEN BEGIN
                    "Bank Name" := Banks.Name;
                END;
            end;
        }
        field(20; "Bank Branch No."; Code[30])
        {
            Caption = 'Drawer Branch No';
            // TableRelation = "Bank Branch" WHERE("Bank Code" = FIELD("Bank No"));

            trigger OnValidate()
            begin
                IF BankBranch.GET("Bank Branch No.") THEN BEGIN
                    "Branch Name" := BankBranch."Branch Name";
                END;
            end;
        }
        field(21; "Clearing Charges"; Decimal)
        {
        }
        field(22; "Clearing Days"; DateFormula)
        {
        }
        field(23; Description; Text[150])
        {
        }
        field(24; "Bank Name"; Text[150])
        {
            Caption = 'Drawer Bank Name';
        }
        field(25; "Branch Name"; Text[150])
        {
            Caption = 'Drawer Branch Name';
        }
        field(32; "Minimum Account Balance"; Decimal)
        {
        }
        field(34; "Coinage Amount"; Decimal)
        {
            CalcFormula = Sum ("Treasury Coinage"."Total Amount" WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(36; Authorised; Option)
        {
            OptionMembers = No,Yes,Rejected,"No Charges";
        }
        field(39; "Checked By"; Text[50])
        {
        }
        field(42; "Cheque Status"; Option)
        {
            OptionMembers = Pending,Honoured,Stopped,Bounced,Holding;
        }
        field(43; "Date Posted"; Date)
        {
        }
        field(44; "Time Posted"; Time)
        {
        }
        field(45; "Posted By"; Text[50])
        {
        }
        field(46; "Expected Maturity Date"; Date)
        {
        }
        field(49; "Transaction Category"; Code[30])
        {
        }
        field(50; Deposited; Boolean)
        {
        }
        field(51; "Date Deposited"; Date)
        {
        }
        field(52; "Time Deposited"; Time)
        {
        }
        field(53; "Deposited By"; Text[30])
        {
        }
        field(58; "Supervisor Checked"; Boolean)
        {
        }
        field(59; "Book Balance"; Decimal)
        {
            CalcFormula = - Sum ("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("Account No.")));
            FieldClass = FlowField;
        }
        field(69; "Cheque Processed"; Boolean)
        {
        }
        field(84; "Banked By"; Code[30])
        {
        }
        field(85; "Date Banked"; Date)
        {
        }
        field(86; "Time Banked"; Time)
        {
        }
        field(87; "Banking Posted"; Boolean)
        {
        }
        field(88; "Cleared By"; Code[30])
        {
        }
        field(89; "Date Cleared"; Date)
        {
        }
        field(90; "Time Cleared"; Time)
        {
        }
        field(91; "Clearing Posted"; Boolean)
        {
        }
        field(92; "Needs Approval"; Option)
        {
            OptionMembers = Yes,No;
        }
        field(94; "ID No."; Code[30])
        {
        }
        field(103; Cheque; Boolean)
        {
        }
        field(131; "Member No."; Code[50])
        {
        }
        field(132; "Member Name"; Text[100])
        {
        }
        field(133; "Drawer Name"; Text[130])
        {
        }
        field(134; Cancelled; Boolean)
        {
        }
        field(135; "Teller Tills"; Code[10])
        {
            TableRelation = "Bank Account";
        }
        field(136; "Destination Account No"; Code[30])
        {
            NotBlank = true;
            //TableRelation = Vendor WHERE("Vendor Type" = FILTER("FOSA Account"));

            trigger OnValidate()
            begin
                //CHECK ACCOUNT ACTIVITY
                Members.RESET;
                IF Members.GET("Destination Account No") THEN BEGIN
                    IF Members.Status = Members.Status::Active THEN BEGIN
                        Members.Status := Members.Status::Active;
                        Members.MODIFY;
                    END;
                    IF Members.Status = Members.Status::Active THEN BEGIN
                    END
                    ELSE BEGIN
                        IF Members.Status <> Members.Status::Active THEN
                            ERROR('The account is not active and therefore cannot be transacted upon.');
                    END;
                END;
                IF Members.GET("Destination Account No") THEN BEGIN
                    "Destination Account Name" := AccountTypes.Description;
                    Cust.GET(Members."No.");
                    "Destination Payee" := Vend.Name
                END;
            end;
        }
        field(137; "Destination Account Name"; Text[150])
        {
        }
        field(138; "Destination Payee"; Text[150])
        {
        }
        field(139; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(140; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(141; "Teller Balance"; Decimal)
        {
        }
        field(142; "Transacted By"; Text[100])
        {
        }
        field(143; "Available Balance"; Decimal)
        {
        }
        field(149; "Cheque Custodian"; Code[20])
        {
        }
        field(150; "Destination Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(151; "Bounced Cheque Amount"; Decimal)
        {
        }
        field(152; Reversed; Boolean)
        {
        }
        field(153; Reconciled; Boolean)
        {
        }
        field(154; DestinationType; Option)
        {
            OptionMembers = Single,Multiple;
        }
        field(158; "Maturity Due"; Boolean)
        {
        }
        field(160; "Closing Till"; Boolean)
        {
        }
        field(161; Excess; Text[80])
        {
        }
        field(162; Shortage; Text[80])
        {
        }
        field(166; Deposit; Boolean)
        {
        }
        field(167; Withdrawal; Boolean)
        {
        }
        field(168; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(169; "Document Type"; Option)
        {
            OptionCaption = ' ,Account Transfer,Share Boosting';
            OptionMembers = " ","Account Transfer","Share Boosting";
        }
        field(170; "Inter Account"; Boolean)
        {
        }
        field(171; "Share Capital No."; Code[30])
        {
            // TableRelation = Customer WHERE("Customer Type"=FILTER(2));

            trigger OnValidate()
            begin
                TESTFIELD("Transaction Type");
                IF Cust.GET("Account No.") THEN BEGIN
                    "Account Name" := Cust.Name;
                    "Member No." := Cust."Member No.";
                    Members.GET(Cust."Member No.");
                    "Member Name" := Members.Surname + ' ' + Members."First Name" + ' ' + Members."Last Name";
                    //"ID No.":=Cust."National ID";
                    Cashier := USERID;

                    //Update account details
                    AccountTypes.GET(Cust."Account Type");
                    IF Withdrawal THEN BEGIN
                        IF AccountTypes."Allow Withdrawal" = FALSE THEN BEGIN
                            ERROR(Error001);
                        END;
                    END;
                    "Account Type" := AccountTypes.Code;
                    "Account Description" := AccountTypes.Description;
                    "Minimum Account Balance" := AccountTypes."Minimum Balance";
                    Cust.CALCFIELDS(Balance, "Account Type");
                    CALCFIELDS("Book Balance");
                    //"Available Balance":=Cust.Balance-Cust."Account Type"-AccountTypes."Minimum Balance";
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    var

        NoSeriesMgt: Codeunit NoSeriesManagement;
        Members: Record Member;
        AccountTypes: Record "Account Type";
        ChequeTypes: Record "Cheque Type";
        Bank: Record "Banks";
        PaymentMethod: Record "Payment Method";
        Cust: Record Customer;
        GLAcc: Record "G/L Account";
        Vend: Record "Vendor";
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        LoanApp: Record "Loan Application";
        GenLedgerSetup: Record "General Ledger Setup";
        VarAmtHolder: Decimal;
        DimValue: Record "Dimension Value";
        Amout: Integer;
        USersetup: Record "User Setup";
        OK: Boolean;
        BankAccount: Record "Bank Account";
        TransactionTypes: Record "Transaction -Type";
        TellerGeneralSetup: Record "Teller General Setup";
        TellerSetup: Record "Teller Setup";
        TreasuryCoinage: Record "Treasury Coinage";
        Denomination: Record Denomination;
        Error000: Label 'You cannot withdraw more than the available balance!';
        Error001: Label 'You are not allowed to withdraw from this account!';
        Error002: Label 'Till is closed!';
        Banks: Record "Banks";
        BankBranch: Record "Bank Branch";
        NonWorkingDays: Integer;
        BaseCalendarChange: Record "Base Calendar Change";
        ClearingDays: Integer;
        CurrentDate: Date;
        Error003: Label 'Amount cannot be less than or equal to zero!';
        CBSSetup: Record "CBS Setup";
        Error004: Label 'Amount entered is greater than your till balance! Kindly request for more funds before you can proceed with this transaction.';
}

