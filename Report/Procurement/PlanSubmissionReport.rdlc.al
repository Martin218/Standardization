report 50503 "Plan Submission Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Procurement\PlanSubmissionReport.rdlc';

    dataset
    {
        dataitem(DataItem3; "Plan Submission Entries")
        {
            column(CurrentBudget_PlanSubmissionEntries; "Current Budget")
            {
            }
            column(GlobalDimension1Code_PlanSubmissionEntries; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_PlanSubmissionEntries; "Global Dimension 2 Code")
            {
            }
            column(CreatedBy_PlanSubmissionEntries; "Created By")
            {
            }
            column(CreatedOn_PlanSubmissionEntries; "Created On")
            {
            }
            column(CreatedTime_PlanSubmissionEntries; "Created Time")
            {
            }
            column(BudgetPerBranch_PlanSubmissionEntries; "Budget Per Branch?")
            {
            }
            column(BudgetPerDepartment_PlanSubmissionEntries; "Budget Per Department?")
            {
            }
            column(Submitted_PlanSubmissionEntries; Submitted)
            {
            }
            column(Dim1Caption; Dim1Caption)
            {
            }
            column(Dim2Caption; Dim2Caption)
            {
            }
            column(UserResponsible; UserResponsible)
            {
            }
            column(Comp_Name; CompanyInformation.Name)
            {
            }
            column(Comp_Address; CompanyInformation.Address)
            {
            }
            column(Comp_City; CompanyInformation.City)
            {
            }
            column(Comp_Pic; CompanyInformation.Picture)
            {
            }
            column(Comp_Postal; CompanyInformation."Post Code")
            {
            }

            trigger OnPreDataItem();
            begin
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
                GeneralLedgerSetup.GET;
                IF GLBudgetName.GET(GeneralLedgerSetup."Current Bugdet") THEN BEGIN
                    ProcurementManagement.ViewPlansNotSubmitted(GLBudgetName);
                    SETRANGE("Current Budget", GLBudgetName.Name);
                    IF ViewSubmitted = FALSE THEN
                        SETRANGE(Submitted, FALSE)
                    ELSE
                        SETRANGE(Submitted, TRUE);
                END ELSE
                    IF ViewSubmitted = FALSE THEN
                        SETRANGE(Submitted, FALSE)
                    ELSE
                        SETRANGE(Submitted, TRUE);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("repeater")
                {
                    field(ViewSubmitted; ViewSubmitted)
                    {
                        Caption = 'View Submitted';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        TitleCaptionLbl = 'Plan Submission Report';
    }

    trigger OnPreReport();
    begin
        GetDimensionCaption();
    end;

    var
        Submitted: Option Yes,No;
        DimensionValue: Record "Dimension Value";
        DimensionRec: Record Dimension;
        ProcurementPlanHeader: Record "Procurement Plan Header";
        GeneralLedgerSetup: Record "General Ledger Setup";
        UserResponsible: Code[80];
        Dim1Caption: Text;
        Dim2Caption: Text;
        CompanyInformation: Record "Company Information";
        Budget: Code[30];
        GLBudgetName: Record "G/L Budget Name";
        PlanSubmissionEntries: Record "Plan Submission Entries";
        ProcurementManagement: Codeunit "Procurement Management";
        ViewSubmitted: Boolean;

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

