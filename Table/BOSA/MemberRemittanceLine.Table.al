table 50125 "Member Remittance Line"
{
    // version TL2.0


    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(4; "Account Type"; Code[20])
        {
            TableRelation = IF ("Account Category" = FILTER(Vendor)) "Account Type"
            ELSE
            IF ("Account Category" = FILTER(Customer)) "Loan Product Type";
        }
        field(5; "Account Category"; Option)
        {
            Editable = false;
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;
        }
        field(6; "Account No."; Code[20])
        {
            Editable = false;
            TableRelation = IF ("Account Type" = FILTER(1)) Customer
            ELSE
            IF ("Account Type" = FILTER(0)) Vendor;

            trigger OnValidate()
            begin
                IF "Account Category" = "Account Category"::Vendor THEN BEGIN
                    IF Vendor.GET("Account No.") THEN
                        "Account Name" := Vendor.Name;
                END;
                IF "Account Category" = "Account Category"::Customer THEN BEGIN
                    IF Customer.GET("Account No.") THEN
                        "Account Name" := Customer.Name;
                END;
            end;
        }
        field(7; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(8; "Remittance Code"; Code[20])
        {
            TableRelation = "Remittance Code";
        }
        field(9; "Expected Amount"; Decimal)
        {
            Editable = false;
        }
        field(10; "Actual Amount"; Decimal)
        {
        }
        field(11; "Contribution Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Normal,Principal Due,Interest Due,Insurance';
            OptionMembers = Normal,"Principal Due","Interest Due",Insurance;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        RemittanceHeader.GET("Document No.");
        RemittanceHeader."Last Modified By" := USERID;
        RemittanceHeader."Last Modified Date" := TODAY;
        RemittanceHeader."Last Modified Time" := TIME;
        RemittanceHeader.MODIFY;
    end;

    var
        Member: Record Member;
        Customer: Record "Customer";
        Vendor: Record Vendor;
        RemittanceHeader: Record "Member Remittance Header";
}
