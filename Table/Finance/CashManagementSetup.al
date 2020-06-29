table 50330 "Cash Management Setup"
{
    // version TL 2.0


    fields
    {
        field(1;"Primary Key";Code[10])
        {
        }
        field(2;"PV Template";Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("AP Journal Template Name"));
        }
        field(3;"Imprest Template";Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(4;"Imprest Surrender Template";Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(5;"Petty Cash Template";Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(6;"PV No.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7;"Imprest No.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8;"Imprest Surrender No.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9;"Petty Cash No.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10;"Cash Receipt No.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11;"Salary Advace";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(12;"AP Journal Template Name";Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(13;"AR Journal Template Name";Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(14;"Tax Withheld Description";Text[60])
        {
        }
        field(15;"VAT Withheld Description";Text[60])
        {
        }
        field(16;"Imprest Code";Code[20])
        {
            TableRelation = "Account Mapping Type";
        }
        field(17;"Cash Receipt Template";Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("AR Journal Template Name"));
        }
        field(18;"Sales Journal Template Name";Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(19;"Sales Batch Template Name";Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Sales Journal Template Name"));
        }
        field(20;"Claim No.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(21;"Imprest Path";Option)
        {
            OptionCaption = 'Petty Cash,Teller';
            OptionMembers = "Petty Cash",Teller;
        }
        field(22;"Petty Cash Bank";Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(23;"Salary Advance Code";Code[20])
        {
            TableRelation = "Account Mapping Type";
        }
        field(24;"Budget Admin";Code[120])
        {
            TableRelation = "User Setup";
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

