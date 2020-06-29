table 50107 "Loan Product Charge"
{
    // version TL2.0


    fields
    {
        field(1; "Loan Product Type"; Code[20])
        {
        }
        field(2; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Loan Charge Setup";

            trigger OnValidate()
            begin
                LoanChargeSetup.GET(Code);
                Description := LoanChargeSetup."Charge Description";
            end;
        }
        field(3; Description; Text[30])
        {
            Editable = false;
        }
        field(4; "Calculation Mode"; Option)
        {
            OptionCaption = '% of Loan,Flat Amount,% of Outstanding Loan';
            OptionMembers = "% of Loan","Flat Amount","% of Outstanding Loan";
        }
        field(5; Value; Decimal)
        {
        }
        field(6; "Account Type"; Option)
        {
            OptionMembers = ,"GL Account",Member;
        }
        field(7; "Account No"; Code[50])
        {
            TableRelation = IF ("Account Type" = CONST("GL Account")) "G/L Account" WHERE(Blocked = CONST(false),
                                                                                     "Direct Posting" = CONST(true));
            //ELSE
            // IF ("Account Type" = CONST(Member)) Code;
        }
        field(8; "Source Code"; Code[20])
        {
            TableRelation = "Source Code";
        }
    }

    keys
    {
        key(Key1; "Loan Product Type", "Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Description)
        {
        }
    }

    var
        LoanChargeSetup: Record "Loan Charge Setup";
}

