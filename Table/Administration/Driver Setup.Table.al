table 50502 "Driver Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Full Names"; Text[30])
        {
        }
        field(3; "ID NO."; Code[30])
        {
        }
        field(4; "Driving License"; Code[50])
        {
        }
        field(5; Designation; Code[50])
        {
        }
        field(6; Branch; Code[20])
        {
            //TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('BRANCH'));

            //trigger OnValidate();
            //begin
            //DimensionValue.RESET;
            //DimensionValue.SETFILTER("Global Dimension No.",'%1',1);
            //DimensionValue.SETRANGE(Code,Branch);
            //IF DimensionValue.FIND('-') THEN BEGIN
            //Branch := DimensionValue.Name;
            //END;
            // end;
        }
    }

    keys
    {
        key(Key1; "Full Names")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Full Names", "ID NO.", Branch, Designation, "Driving License")
        {
        }
    }

    var
    //DimensionValue: Record "Dimension Value";
}

