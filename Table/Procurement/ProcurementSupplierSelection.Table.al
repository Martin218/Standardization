

table 50418 "Procurement Supplier Selection"
{

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;//WHERE("Vendor Type" = FILTER(Normal));

            trigger OnValidate();
            begin
                IF Vendor.GET("Vendor No.") THEN
                    UpdateVendorDetails;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(6; "Company PIN No."; Code[20])
        {
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
        }
        field(8; Contact; Text[50])
        {
            Caption = 'Contact';

            trigger OnLookup();
            var
                ContactBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
            end;
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(89; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
        }
        field(92; County; Text[30])
        {
            Caption = 'County';
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate();
            var
                MailManagement: Codeunit "Mail Management";
            begin
            end;
        }
        field(103; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(140; Image; Media)
        {
            Caption = 'Image';
            ExtendedDatatype = Person;
        }
        field(50011; "Bank Account"; Code[20])
        {
        }
        field(50012; "KBA Code"; Code[20])
        {
            TableRelation = "KBA Codes" WHERE("Bank Code" = FIELD("Bank Code"));
        }
        field(50013; "Bank Code"; Code[10])
        {
            TableRelation = "Bank Name";
        }
        field(50101; Blacklisted; Boolean)
        {
        }
        field(50102; Status; Option)
        {
            OptionMembers = Active,Inactive;
        }
        field(50103; "AGPO Cert"; Code[30])
        {
        }
        field(50104; "AGPO Category"; Option)
        {
            OptionCaption = 'Youth,PWD,Women';
            OptionMembers = Youth,PWD,Women;
        }
        field(50105; "Maximum Order Quantity"; Decimal)
        {
        }
        field(50106; "Minimum Order Quantity"; Decimal)
        {
        }
        field(50107; "Maximum Order Amount"; Decimal)
        {
        }
        field(50108; "Minimum Order Amount"; Decimal)
        {
        }
        field(50109; "Category Code"; Code[10])
        {
            TableRelation = "Supplier Category";

            trigger OnValidate();
            begin
                IF SupplierCategory.GET("Category Code") THEN
                    "Category Description" := SupplierCategory.Description;
            end;
        }
        field(50110; "Category Description"; Text[200])
        {
        }
        field(50111; "Attach Procurement Document"; Boolean)
        {
        }
        field(50112; Select; Boolean)
        {
        }
        field(50113; "Process No."; Code[20])
        {
        }
        field(50114; "Procurement Document File"; Text[250])
        {
        }
        field(50115; "Request Email Sent"; Boolean)
        {
        }
        field(50116; "Forwarded For Evaluation"; Boolean)
        {
        }
        field(50117; "Expression On Interest File"; Text[250])
        {
        }
        field(50118; "Attach Expression Of Interest"; Boolean)
        {
        }
        field(50119; "Proceed To Proposal"; Boolean)
        {
        }
        field(50120; "Tender Receipt No."; Code[20])
        {
        }
        field(50121; "Tender Fee Paid"; Boolean)
        {
        }
        field(50122; "Quoted Amount"; Decimal)
        {
        }
        field(50123; "Agreed Amount"; Decimal)
        {
        }
        field(50124; "Attached Procurement Document"; Blob)
        {

        }
        field(50125; "Attached EOI"; Blob)
        {

        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Process No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        IF Vendor.GET("Vendor No.") THEN BEGIN
            Vendor."Pre-Qualified" := FALSE;
            Vendor.MODIFY;
        END;
    end;

    trigger OnInsert();
    begin
        IF Vendor.GET("Vendor No.") THEN BEGIN
            Vendor."Pre-Qualified" := TRUE;
            Vendor."Prequalified Category Code" := "Category Code";
            Vendor."Prequalified Category Desc" := "Category Description";
            Vendor.MODIFY;
        END;
    end;

    var
        Vendor: Record Vendor;
        SupplierCategory: Record "Supplier Category";

    local procedure UpdateVendorDetails();
    var
        Vend2: Record Vendor;
    begin
        IF Vend2.GET("Vendor No.") THEN BEGIN
            Rec.TRANSFERFIELDS(Vend2);
            VALIDATE("Category Code");
            Vend2."Pre-Qualified" := TRUE;
            Vend2.MODIFY(TRUE);
        END;
    end;
}

