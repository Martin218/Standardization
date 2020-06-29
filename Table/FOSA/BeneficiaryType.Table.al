table 50004 "Beneficiary Type"
{
    // version TL2.0


    fields
    {
        field(1; "Application No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Name; Text[50])
        {
            trigger OnValidate()
            begin
                Name := UpperCase(Name);
            end;
        }
        field(4; "National ID"; Integer)
        {
        }
        field(5; "Allocation (%)"; Decimal)
        {
        }
        field(6; Type; Option)
        {
            OptionCaption = 'Next of Kin,Nominee,Group Member,Group Trustee,Company Signatory,Company Trustee,Joint Member';
            OptionMembers = "Next of Kin",Nominee,"Group Member","Group Trustee","Company Signatory","Company Trustee","Joint Member";
        }
        field(8; Signature; Media)
        {
            ExtendedDatatype = Person;

        }
        field(9; "Front ID"; Media)
        {
            ExtendedDatatype = Person;
        }
        field(10; "Back ID"; Media)
        {
            ExtendedDatatype = Person;
        }
        field(11; Picture; Media)
        {
            ExtendedDatatype = Person;
        }
        field(12; Relationship; Option)
        {
            OptionCaption = 'Father,Mother,Brother,Sister,Son,Daughter,Wife,Husband,Uncle,Aunt,Cousin,Other';
            OptionMembers = Father,Mother,Brother,Sister,Son,Daughter,Wife,Husband,Uncle,Aunt,Cousin,Other;
        }
        field(13; "Phone No."; Code[30])
        {
        }
        field(14; "Witness Name"; Text[30])
        {
        }
        field(15; "Witness National ID"; Text[30])
        {
        }
        field(16; "Witness Mobile No."; Text[30])
        {
        }
        field(17; "Witness Postal Address"; Text[30])
        {
        }
        field(19; Position; Option)
        {
            OptionCaption = 'Chairperson,Vice Chairperson,Treasurer,Secretary,Member';
            OptionMembers = Chairperson,"Vice Chairperson",Treasurer,Secretary,Member;

            trigger OnValidate()
            begin
                /*Position1:=0;
                Next2.RESET;
                Next2.SETRANGE("Member Code","Member Code");
                Next2.SETRANGE(Type,Next2.Type::"Group Member");
                IF Next2.FINDSET THEN BEGIN
                  IF Position=Next2.Position::Chairman THEN BEGIN
                    REPEAT
                      Position1:=Position1+1;
                    UNTIL
                     Next2.NEXT=0;
                  END;
                END;
                IF Position1>1 THEN BEGIN
                  ERROR('Position %1 has already been used.',Next2.Position);
                END;
                 */

            end;
        }
    }

    keys
    {
        key(Key1; Type, "Application No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

