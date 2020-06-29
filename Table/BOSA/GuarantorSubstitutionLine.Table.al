table 50138 "Guarantor Substitution Line"
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
        field(3; "Member No."; Code[20])
        {
            Editable = false;
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN
                    "Member Name" := Member."Full Name";
            end;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Account No."; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF Vendor.GET("Account No.") THEN
                    "Account Name" := Vendor.Name;
            end;
        }
        field(6; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(8; "Guaranteed Amount"; Decimal)
        {
            Editable = false;
        }
        field(9; "No. of Guarantors"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("Guarantor Allocation" WHERE("Document No." = FIELD("Document No."),
                                                              "Guarantor Member No." = FIELD("Member No.")));
            Editable = false;

        }
        field(10; "Substitution Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Guarantor Allocation"."Amount To Guarantee" WHERE("Document No." = FIELD("Document No."),
                                                                                  "Guarantor Member No." = FIELD("Member No.")));
            Editable = false;

        }
        field(12; Substitute; Boolean)
        {

            trigger OnValidate()
            begin
                IF NOT Substitute THEN BEGIN
                    DeleteRelatedLinks("Member No.");
                END;
            end;
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

    var
        Vendor: Record Vendor;
        Member: Record Member;

    local procedure DeleteRelatedLinks(MemberNo: Code[20])
    var
        GuarantorSubAllocation: Record "Guarantor Allocation";
    begin
        GuarantorSubAllocation.RESET;
        GuarantorSubAllocation.SETRANGE("Document No.", "Document No.");
        GuarantorSubAllocation.SETRANGE("Guarantor Member No.", MemberNo);
        GuarantorSubAllocation.DELETEALL;
    end;
}

