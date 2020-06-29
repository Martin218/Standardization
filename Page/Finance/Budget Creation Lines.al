page 50641 "Budget Creation Lines"
{
    // version TL 2.0

    InsertAllowed = false;
    PageType = List;
    SourceTable = "Monthly Distribution";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = Dim1;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = Dim2;
                }
                field(Month;Month)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = Mon;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = All;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = All;
                }
                field(Submitted;Submitted)
                {
                    ApplicationArea = All;
                }
                field(Consolidated;Consolidated)
                {
                    ApplicationArea = All;
                }
                field(CreatedBy;CreatedBy)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        IF "Budget Period"="Budget Period"::Monthly THEN BEGIN
        Mon:=TRUE;
        IF "Global Dimension 1 Code"<>'' THEN BEGIN
        Dim1:=TRUE;
        END;
        IF "Global Dimension 2 Code"<>'' THEN BEGIN
        Dim2:=TRUE;
        END;
        END;
        IF "Budget Period"="Budget Period"::Yearly THEN BEGIN
        IF "Global Dimension 1 Code"<>'' THEN BEGIN
        Dim1:=TRUE;
        END;
        IF "Global Dimension 2 Code"<>'' THEN BEGIN
        Dim2:=TRUE;
        END;
        END;
    end;

    trigger OnOpenPage();
    begin
        IF "Budget Period"="Budget Period"::Monthly THEN BEGIN
        Mon:=TRUE;
        IF "Global Dimension 1 Code"<>'' THEN BEGIN
        Dim1:=TRUE;
        END;
        IF "Global Dimension 2 Code"<>'' THEN BEGIN
        Dim2:=TRUE;
        END;
        END;
        IF "Budget Period"="Budget Period"::Yearly THEN BEGIN
        IF "Global Dimension 1 Code"<>'' THEN BEGIN
        Dim1:=TRUE;
        END;
        IF "Global Dimension 2 Code"<>'' THEN BEGIN
        Dim2:=TRUE;
        END;
        END;
        FILTERGROUP(2);
        FILTERGROUP(1);
    end;

    var
        Mon : Boolean;
        Dim1 : Boolean;
        Dim2 : Boolean;
        BudgetCreationLines : Record "Budget Creation Lines";
        GLBudgetName : Record "G/L Budget Name";
        BudgetManagement : Codeunit "Budget Management";
}

