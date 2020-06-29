table 50050 "Teller Setup"
{
    // version TL2.0

    Caption = 'Teller Setup';

    fields
    {
        field(1; "Teller ID"; Code[50])
        {
            NotBlank = true;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                UserSetup.GET("Teller ID");
                // "Branch Code" := UserSetup."Global Dimension 1 Code";
            end;
        }
        field(3; "Till No"; Code[30])
        {
            //TableRelation = "Bank Account" WHERE("Account Type" = FILTER("Till Account"));

            trigger OnValidate()
            begin
                //check if one is allocated the same till with someone else
                TellerSetup.RESET;
                TellerSetup.SETRANGE(TellerSetup."Till No", "Till No");
                IF TellerSetup.FIND('-') THEN BEGIN
                    ERROR('You cannot allocate the same till as teller %1', TellerSetup."Teller ID");
                END;

                IF Banks.GET("Till No") THEN BEGIN
                    "Till Name" := Banks.Name;
                END;

                IF "Teller ID" <> '' THEN BEGIN
                    IF Banks.GET("Till No") THEN BEGIN
                        IF Banks."Global Dimension 1 Code" <> "Branch Code" THEN
                            ERROR('You cannot allocate this user a till belonging to another branch.');
                    END;
                END;
                //Password:='1234';
            end;
        }
        field(4; "Till Name"; Text[50])
        {
        }
        field(5; Status; Boolean)
        {
        }
        field(6; "Branch Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Max Deposit"; Decimal)
        {
        }
        field(8; "Max Withdrawal"; Decimal)
        {
        }
        field(9; Type; Option)
        {
            OptionMembers = ,"Customer Service",Teller,Cashier;
        }
        field(10; "Mobile Teller"; Boolean)
        {
        }
        field(11; "Teller Maximum Withholding."; Decimal)
        {
        }
        field(12; "Treasury Account"; Code[30])
        {
            // TableRelation = "Bank Account" WHERE("Account Type" = FILTER("Treasury Account));
        }
    }

    keys
    {
        key(Key1; "Teller ID")
        {
        }
        key(Key2; "Till No")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Teller ID")
        {
        }
        fieldgroup(Brick; "Teller ID")
        {
        }
    }

    var
        UserSetup: Record "User Setup";
        TellerSetup: Record "Teller Setup";
        Banks: Record Banks;
}

