table 50342 "Commitment Entry"
{
    // version TL 2.0


    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Document No.";Code[10])
        {
        }
        field(3;"Commitment Date";Date)
        {
        }
        field(4;"Commitment Type";Option)
        {
            OptionCaption = '" ,LPO,LSO,IMPREST,ITEMS"';
            OptionMembers = " ",LPO,LSO,IMPREST,ITEMS;
        }
        field(5;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Department';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(6;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Department';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(7;"Budget Name";Code[10])
        {
            TableRelation = "G/L Budget Name";
        }
        field(8;"User ID";Code[50])
        {
        }
        field(9;"Time Stamp";Time)
        {
        }
        field(10;Type;Option)
        {
            OptionMembers = Committed,Reversal;
        }
        field(11;"Budget Line";Code[10])
        {
            TableRelation = "G/L Budget Name";
        }
        field(12;Amount;Decimal)
        {
        }
        field(13;"Source Type";Option)
        {
            Caption = 'Source Type';
            OptionCaption = '" ,G/L Account,Item,,Fixed Asset,Charge (Item)"';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(14;"Remaining Amount";Decimal)
        {
           // CalcFormula = Sum("Commitment Entry".Amount WHERE (Document No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15;"Fully Accounted for";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

