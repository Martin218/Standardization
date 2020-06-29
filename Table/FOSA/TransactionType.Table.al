table 50022 "Transaction -Type"
{
    // version TL2.0


    fields
    {
        field(1; "Code"; Code[50])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = 'Teller Cash Deposit,Teller Cheque Deposit,Teller Cash Withdrawal,Teller Ministatement,ATM Card Application,Loan Application,Standing Order,ATM Balance Inquiry-Normal,ATM Withdrawal-Normal,ATM Ministatement-Normal,ATM Paybill-Normal,ATM Buy Goods & Services-Normal,ATM Withdrawal-POS Normal,ATM Deposit-POS Normal,ATM Balance Inquiry-POS Normal,ATM Ministatement-POS Normal,ATM Utility Payment-POS Normal,ATM Balance Inquiry-VISA,ATM Withdrawal-VISA,ATM Ministatement-VISA,ATM Withdrawal-POS VISA,ATM Deposit-POS VISA,ATM Ministatement-POS VISA,ATM Balance Inquiry-POS VISA,ATM Utility Payment-POS VISA,SPOTCASH Balance Inquiry,SPOTCASH Withdrawal,SPOTCASH Ministatement,SPOTCASH Deposit,Cheque Clearance,Cheque Bouncing,E-loan,Agency Withdrawal,Agency Deposit,Agency Airtime,Agency Balance Inquiry,Agency Ministatement,PesaLink,Inter-Account,Tea Payout,Salary Payout,SMS t';
            OptionMembers = "Teller Cash Deposit","Teller Cheque Deposit","Teller Cash Withdrawal","Teller Ministatement","ATM Card Application","Loan Application","Standing Order","ATM Balance Inquiry-Normal","ATM Withdrawal-Normal","ATM Ministatement-Normal","ATM Paybill-Normal","ATM Buy Goods & Services-Normal","ATM Withdrawal-POS Normal","ATM Deposit-POS Normal","ATM Balance Inquiry-POS Normal","ATM Ministatement-POS Normal","ATM Utility Payment-POS Normal","ATM Balance Inquiry-VISA","ATM Withdrawal-VISA","ATM Ministatement-VISA","ATM Withdrawal-POS VISA","ATM Deposit-POS VISA","ATM Ministatement-POS VISA","ATM Balance Inquiry-POS VISA","ATM Utility Payment-POS VISA","SPOTCASH Balance Inquiry","SPOTCASH Withdrawal","SPOTCASH Ministatement","SPOTCASH Deposit","Cheque Clearance","Cheque Bouncing","E-loan","Agency Withdrawal","Agency Deposit","Agency Airtime","Agency Balance Inquiry","Agency Ministatement",PesaLink,"Inter-Account","Tea Payout","Salary Payout","SMS t";
        }
        field(4; "Deduct Excise Duty"; Boolean)
        {
        }
        field(5; "Deduct Stamp Duty"; Boolean)
        {
        }
        field(6; "Deduct Withholding Tax"; Boolean)
        {
        }
        field(7; "Settlement Account Type"; Option)
        {
            Caption = 'Settlement Account Type (SACCO)';
            Description = 'This is reserved for SACCO commission';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account";
        }
        field(8; "Settlement Account No."; Code[20])
        {
            Caption = 'Settlement Account No. (SACCO)';
            Description = 'This is reserved for SACCO commission';
            TableRelation = IF ("Settlement Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                 Blocked = filter(false))
            ELSE
            IF ("Settlement Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Settlement Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Settlement Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(9; "Settlement2 Account Type"; Option)
        {
            Caption = 'Settlement Account Type (TL)';
            Description = 'This is reserved for TL commission';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account";
        }
        field(10; "Settlement2 Account No."; Code[20])
        {
            Caption = 'Settlement Account No. (TL)';
            Description = 'This is reserved for TL commission';
            TableRelation = IF ("Settlement2 Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                  Blocked = CONST(false))
            ELSE
            IF ("Settlement2 Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Settlement2 Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Settlement2 Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(11; "Settlement3 Account Type"; Option)
        {
            Caption = 'Settlement Account Type (COOP)';
            Description = 'This is reserved for COOP commission';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account";
        }
        field(12; "Settlement3 Account No."; Code[20])
        {
            Caption = 'Settlement Account No. (COOP)';
            Description = 'This is reserved for COOP commission';
            TableRelation = IF ("Settlement3 Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                  Blocked = CONST(false))
            ELSE
            IF ("Settlement3 Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Settlement3 Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Settlement3 Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(13; "Settlement4 Account Type"; Code[20])
        {
            Caption = 'Settlement Account Type (Agent)';
            Description = 'This is reserved for AGENT commission';
            TableRelation = "Account Type";
        }
        field(14; "Sett. Control Account Type"; Option)
        {
            Caption = 'Settlement Control Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account";
        }
        field(15; "Sett. Control Account No."; Code[20])
        {
            Caption = 'Settlement Control Account No.';
            TableRelation = IF ("Sett. Control Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                    Blocked = CONST(false))
            ELSE
            IF ("Sett. Control Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Sett. Control Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Sett. Control Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(16; "Service ID"; Code[20])
        {
        }
        field(17; "Application Area"; Option)
        {
            OptionCaption = 'Teller,SpotCash,ATM,Agency,Payout,Standing Order';
            OptionMembers = Teller,SpotCash,ATM,Agency,Payout,"Standing Order";
        }
        field(18; "Priority Posting"; Boolean)
        {
        }
        field(19; "Charge Penalty"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}

