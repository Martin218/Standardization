table 50001 "CBS Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "MA Individual Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Member Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "Loan Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Member No. Format"; Option)
        {
            OptionCaption = 'No. Series Only,Branch Code+No. Series';
            OptionMembers = "No. Series Only","Branch Code+No. Series";
        }
        field(6; "Account Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(7; "Account No. Format"; Option)
        {
            OptionCaption = 'No. Series Only,Member No.+Account Type';
            OptionMembers = "No. Series Only","Member No.+Account Type";
        }
        field(8; "Account Opening Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Member Activation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Closing Account Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Closure Fee GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(13; "Loan Product Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; "Treasury Request Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(15; "Treasury Transactions Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; "Account Activation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "Interim Accounts"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(18; "MA Joint Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(19; "MA Group Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(20; "MA Company Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(21; "Phone No. Format"; Option)
        {
            OptionCaption = '07XXXXXXXX,2547XXXXXXXX';
            OptionMembers = "07XXXXXXXX","2547XXXXXXXX";
        }
        field(22; "Loan Account Nos. Format"; Option)
        {
            OptionMembers = "No. series","MemberNo+No. series","MemberNo+Branch Code+No. Series";
        }
        field(23; "Loan AccountNos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(24; "Loan Recovery Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(25; "Loan Recovery Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Recovery Template Name"));
        }
        field(26; "Securities Path"; Text[250])
        {
        }
        field(27; "Loan Form Path"; Text[250])
        {
        }
        field(28; "Cheque Deposit Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(29; "ATM Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(30; "ATM Collection Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(31; "ATM Activation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(32; "SpotCash Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33; "SpotCash Activation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(34; "Excise Duty %"; Decimal)
        {
        }
        field(35; "Excise Duty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(36; "Withholding Tax %"; Decimal)
        {
        }
        field(37; "Withholding Tax G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(38; "Stamp Duty %"; Decimal)
        {
        }
        field(39; "Stamp Duty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(40; "ATM Journal Template"; Code[10])
        {
            Caption = 'ATM Journal Template';
            TableRelation = "Gen. Journal Template";
        }
        field(41; "ATM Batch Name"; Code[10])
        {
            Caption = 'ATM Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("ATM Journal Template"));
        }

        field(44; "Agency Template Name"; Code[10])
        {
            Caption = 'Agency Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(45; "Agency Batch Name"; Code[10])
        {
            Caption = 'Agency Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Agency Template Name"));
        }
        field(46; "Cheque Clearance Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(47; "Cheque Template Name"; Code[10])
        {
            Caption = 'Cheque Journal Template';
            TableRelation = "Gen. Journal Template";
        }
        field(48; "Cheque Batch Name"; Code[10])
        {
            Caption = 'Cheque Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Agency Template Name"));
        }
        field(49; "Coinage Mandatory"; Boolean)
        {
        }
        field(69; "Cheque Book Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(70; "Cheque Book Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(71; "Charge Interest Day"; Integer)
        {
        }
        field(72; "Interest Repayment Interval"; DateFormula)
        {
        }
        field(73; "Teller Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(74; "Teller Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Teller Template Name"));
        }
        field(75; "Treasury Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(76; "Treasury Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Treasury Template Name"));
        }
        field(77; "Standing Order Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(78; "Standing Order Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(79; "Standing Order Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Standing Order Template Name"));
        }
        field(80; "Payout Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(81; "Payout Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(82; "Payout Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payout Template Name"));
        }
        field(83; "Loan Repayment Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(84; "Loan Repayment Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Repayment Template Name"));
        }
        field(85; "Employee Line No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(86; "Member Exit Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(87; "Deposit %"; Decimal)
        {
        }
        field(88; "Deposit Figure"; Decimal)
        {
        }
        field(89; "Maximum Deposit Figure"; Decimal)
        {
        }
        field(90; "Share Capital Threshold"; Decimal)
        {
        }
        field(91; "Share Capital Threshold Period"; Decimal)
        {
        }
        field(94; "Loan Rescheduling Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(95; "Loan Disbursal Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(96; "Loan Disbursal Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Disbursal Template Name"));
        }
        field(97; "Loan Interest Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(98; "Loan Interest Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Interest Template Name"));
        }
        field(99; "Fund Transfer Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(100; "Fund Transfer Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(101; "Fund Transfer Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Fund Transfer Template Name"));
        }
        field(103; "Guarantor Substitution Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(104; "Member Remittance Advice Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(105; "Insurance Claim Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(106; "Refund Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(107; "Insurace Claim Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(108; "Insurace Claim Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Insurace Claim Template Name"));
        }
        field(109; "Refund Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(110; "Refund Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Refund Template Name"));
        }
        field(111; "Loan Selloff Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(112; "Loan Selloff Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(113; "Loan Selloff Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Selloff Template Name"));
        }
        field(118; "Dividend Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(119; "Dividend Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Dividend Template Name"));
        }
        field(120; "Dividend Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(121; "Reversal Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(122; "Reversal Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Reversal Template Name"));
        }
        field(123; "Shares Boosting Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(124; "Shares Boosting Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Shares Boosting Template Name"));
        }
        field(125; "Loan Writeoff Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(126; "Loan Writeoff Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(127; "Loan Writeoff Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Writeoff Template Name"));
        }
        field(128; "Spotcash Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(129; "Spotcash Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Spotcash Template Name"));
        }
        field(130; "Exit Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(140; "Exit Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Exit Template Name"));
        }
        field(141; "Agency Remittance Advice Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(142; "Remittance Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(143; "Remittance Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Remittance Template Name"));
        }
        field(144; "Group Allocation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(145; "Group Attendance Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }


        field(146; "GP Allocation Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(147; "GP Allocation Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("GP Allocation Template Name"));
        }
        field(148; "Group In-Transit Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }
        field(149; "Portfolio Transfer Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

