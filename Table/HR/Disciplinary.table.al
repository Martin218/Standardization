table 50215 "Disciplinary Case"
{
    // version TL2.0


    fields
    {
        field(1; "Case No"; Code[20])
        {
        }
        field(2; "Case Description"; Text[250])
        {
        }
        field(3; "Date of the Case"; Date)
        {
        }
        field(4; "Offense Type"; Code[20])
        {
            TableRelation = "Disciplinary Offense";

            trigger OnValidate();
            begin
                IF offenserec.GET("Offense Type") THEN BEGIN
                    "Offense Name" := offenserec.Description;
                END;
            end;
        }
        field(5; "Offense Name"; Text[250])
        {
        }
        field(6; "Employee No"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No") THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    userrec.RESET;
                    //    userrec.SETFILTER(userrec."Global Dimension 1 Code", "Employee No");
                    /*IF userrec.FINDSET THEN BEGIN
                       userrec2.RESET;
                       IF userrec2.GET(userrec."Accounts Approver") THEN BEGIN
                          "HOD Name":=userrec2."User ID";
                          IF "HOD Name"<>'' THEN BEGIN
                             userrec2.GET(userrec2."User ID");
                              EmployeeGET(userrec2."Global Dimension 1 Code");
                             "HOD Name":= Employee"First Name"+' '+ Employee"Middle Name"+' '+ Employee"Last Name";
                          END;
                       END;

                    END;*/
                END;

            end;
        }
        field(7; "Employee Name"; Text[250])
        {
        }
        field(8; "Case Status"; Option)
        {
            OptionMembers = New,Ongoing,Appealed,Closed,Court;
        }
        field(9; "HOD Recommendation"; Text[250])
        {
        }
        field(10; "HR Recommendation"; Text[250])
        {
        }
        field(11; "Commitee Recommendation"; Text[250])
        {
        }
        field(12; "Action Taken"; Text[250])
        {
        }
        field(13; Appealed; Boolean)
        {
        }
        field(14; "Committee Recon After Appeal"; Text[250])
        {
        }
        field(15; "HOD File Path"; Text[250])
        {
        }
        field(16; "HR File Path"; Text[250])
        {
        }
        field(17; "Committe File Path"; Text[250])
        {
        }
        field(18; "Committee File-After Appeal"; Text[250])
        {
        }
        field(19; "No. series"; Code[10])
        {
        }
        field(20; "HOD Name"; Text[250])
        {
        }
        field(21; "No. of Appeals"; Integer)
        {
        }
        field(22; "DG Recommendation"; Text[250])
        {
        }
        field(23; "Court's Decision"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Case No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "Case No" = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD(HumanResSetup."Disciplinary Cases Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Disciplinary Cases Nos.", xRec."No. series", 0D, "Case No", "No. series");
        END;
    end;

    var
        Employee: Record 5200;
        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit 396;
        offenserec: Record 50216;
        userrec: Record 91;
        userrec2: Record 91;
}

