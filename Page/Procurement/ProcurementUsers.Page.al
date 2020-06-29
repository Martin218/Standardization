page 50745 "Procurement Users"
{
    // version TL2.0

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "User Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        UserSetup2: Record "User Setup";
        ProcurementManagement: Codeunit "Procurement Management";

    //[Scope('Personalization')]
    procedure SetSelection(UserSetup: Record "User Setup"; ProcessNo: Code[20]; StageNo: Integer);
    var
        SelectionSuccessMsg: Label 'Committee Members selected Successfully.';
    begin
        UserSetup.RESET;
        CurrPage.SETSELECTIONFILTER(Rec);
        Rec.MARKEDONLY(TRUE);

        UserSetup.COPY(Rec);
        UserSetup2.RESET;
        UserSetup2.COPY(UserSetup);
        IF UserSetup2.FINDSET THEN BEGIN
            REPEAT
                UpdateSelectedCommitteeMembers(UserSetup2, ProcessNo, StageNo);
            UNTIL UserSetup2.NEXT = 0;
            MESSAGE(SelectionSuccessMsg);
        END;
    end;

    local procedure UpdateSelectedCommitteeMembers(UserSetup: Record "User Setup"; ProcessNo: Code[20]; StageNo: Integer);
    begin
        WITH UserSetup DO BEGIN
            ProcurementManagement.PopulateSelectedCommiteeMembers(UserSetup, ProcessNo, StageNo);
        END;
    end;
}

