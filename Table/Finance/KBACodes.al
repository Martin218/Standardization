table 50334 "KBA Codes"
{
    // version TL 2.0

    DataCaptionFields = "KBA Code", "KBA Name";
    // LookupPageID = 50535;

    fields
    {
        field(1; "KBA Code"; Code[20])
        {
        }
        field(2; "KBA Name"; Text[90])
        {
        }
        field(3; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Name";
        }
        field(4; "KBA Branch Code"; Code[10])
        {

            trigger OnValidate();
            begin
                //"KBA Branch Code":=PaymentReceiptProcessing.KBABranchCodes(Rec);
                // "KBA Code":=PaymentReceiptProcessing.ConcatenateKBACodes(Rec)
            end;
        }
    }

    keys
    {
        key(Key1; "KBA Code", "Bank Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PaymentReceiptProcessing: Codeunit "Cash Management";
}

