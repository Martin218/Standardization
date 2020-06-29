table 50401 "Procurement Plan Header"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Global Dimension 1 Code"; Code[50])
        {
            //CaptionClass = '1,1,1';
            Caption = 'Branch';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = FILTER(Standard));
        }
        field(3; "Global Dimension 2 Code"; Code[50])
        {
            //CaptionClass = '1,1,2';
            Caption = 'Department';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = FILTER(Standard));
        }
        field(4; Description; Text[150])
        {
        }
        field(5; Blocked; Boolean)
        {
        }
        field(6; Amount; Decimal)
        {
            CalcFormula = Sum ("Procurement Plan Line"."Estimated Cost" WHERE("Plan No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(7; "Created By"; Code[80])
        {
        }
        field(8; "Created On"; Date)
        {
        }
        field(9; "Created Time"; Time)
        {
        }
        field(10; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(11; "Budget Period"; Option)
        {
            OptionCaption = ',Yearly,Monthly';
            OptionMembers = ,Yearly,Monthly;
        }
        field(12; Submitted; Boolean)
        {
        }
        field(13; "Current Budget"; Code[25])
        {
        }
        field(14; "No. Series"; Code[80])
        {
            TableRelation = "No. Series";
        }
        field(15; "Budget Per Branch?"; Boolean)
        {
        }
        field(16; "Budget Per Department?"; Boolean)
        {
        }
        field(17; "No. Of Approvals"; Integer)
        {
            CalcFormula = Count ("Approval Entry" WHERE("Document No." = FIELD("No."),
                                                        Status = FILTER(Open | Created)));
            FieldClass = FlowField;
        }
        field(18; "Approval Comments"; Text[100])
        {
        }
        field(19; "Forwarded To CEO"; Boolean)
        {
        }
        field(20; "CEO Approved"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, Amount, "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
        }
    }

    trigger OnInsert();
    begin
        ProcurementSetup.GET;
        ProcurementSetup.TESTFIELD("Procurement Plan No.");
        NoSeriesManagement.InitSeries(ProcurementSetup."Procurement Plan No.", xRec."No. Series", 0D, "No.", "No. Series");

        "Created By" := USERID;
        "Created On" := TODAY;
        "Created Time" := TIME;
        if UserSetup.Get(USERID) then begin
            "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        end;
        GetCurrentBudget;
        CheckIfPlanExisting();
        ValidateGlobalDimensions(USERID);
    end;

    var
        ProcurementManagement: Codeunit "Procurement Management";
        UserSetup: Record "User Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ProcurementSetup: Record "Procurement Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Dim1Caption: Text;
        Dim2Caption: Text;
        GLBudgetName: Record "G/L Budget Name";

    local procedure ValidateGlobalDimensions(UserID: Code[100]);
    var
        Dimension1Error: Label 'Your %1 setup is missing.';
        Dimension2Error: Label 'Your %1 setup is missing.';
    begin
        UserSetup.GET(UserID);
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        IF GLBudgetName.GET("Current Budget") THEN BEGIN
            IF (GLBudgetName."Budget Per Branch?" = TRUE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                IF UserSetup."Global Dimension 1 Code" = '' THEN BEGIN
                    GetDimensionCaption;
                    ERROR(Dimension1Error, Dim1Caption);
                END;
                IF UserSetup."Global Dimension 2 Code" = '' THEN BEGIN
                    GetDimensionCaption;
                    ERROR(Dimension2Error, Dim2Caption);
                END;
            END ELSE
                IF (GLBudgetName."Budget Per Branch?" = TRUE) AND (GLBudgetName."Budget Per Department?" = FALSE) THEN BEGIN
                    IF UserSetup."Global Dimension 1 Code" = '' THEN BEGIN
                        GetDimensionCaption;
                        ERROR(Dimension1Error, Dim1Caption);
                    END;
                END ELSE
                    IF (GLBudgetName."Budget Per Branch?" = FALSE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                        IF UserSetup."Global Dimension 2 Code" = '' THEN BEGIN
                            GetDimensionCaption;
                            ERROR(Dimension2Error, Dim2Caption);
                        END;
                    END;
        END;
    end;

    local procedure GetCurrentBudget();
    var
        CurrentBudgetErr: Label 'Current Budget Setup is Missing!';
    begin
        GeneralLedgerSetup.GET;
        "Current Budget" := GeneralLedgerSetup."Current Bugdet";
        IF GLBudgetName.GET("Current Budget") THEN BEGIN
            IF GLBudgetName."Budget Per Branch?" = TRUE THEN
                "Budget Per Branch?" := GLBudgetName."Budget Per Branch?";
            IF GLBudgetName."Budget Per Department?" = TRUE THEN
                "Budget Per Department?" := GLBudgetName."Budget Per Department?";
            "Budget Period" := GLBudgetName."Budget Period";
        END;
        IF "Current Budget" = '' THEN BEGIN
            ERROR(CurrentBudgetErr);
        END;
    end;

    local procedure CheckIfPlanExisting();
    var
        ProcurementPlanHeader01: Record "Procurement Plan Header";
        PlanExistErr: Label '%1 Procurement Plan for  %2 %3, and  %4  %5 already Exist.';
    begin
        UserSetup.GET(USERID);
        ProcurementPlanHeader01.RESET;
        ProcurementPlanHeader01.SETRANGE("Current Budget", "Current Budget");
        ProcurementPlanHeader01.SETRANGE("Global Dimension 1 Code", UserSetup."Global Dimension 1 Code");
        ProcurementPlanHeader01.SETRANGE("Global Dimension 2 Code", UserSetup."Global Dimension 2 Code");
        IF ProcurementPlanHeader01.FINDFIRST THEN BEGIN
            GetDimensionCaption;
            ERROR(PlanExistErr, "Current Budget", Dim1Caption, UserSetup."Global Dimension 1 Code", Dim2Caption, UserSetup."Global Dimension 2 Code");
        END;
    end;

    local procedure GetDimensionCaption();
    var
        Dim1Field: FieldRef;
        Dim2Field: FieldRef;
        UserRecRef: RecordRef;
    begin
        UserRecRef.OPEN(91);
        Dim1Field := UserRecRef.FIELD(50001);
        Dim1Caption := Dim1Field.CAPTION;
        Dim2Field := UserRecRef.FIELD(50006);
        Dim2Caption := Dim2Field.CAPTION;
        UserRecRef.CLOSE;
    end;
}

