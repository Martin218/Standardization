report 50052 "Generate Member Advice"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Member; Member)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                i += 1;

                IF GUIALLOWED THEN BEGIN
                    ProgressWindow.UPDATE(1, "No.");
                    ProgressWindow.UPDATE(2, "Full Name");
                END;
                IF NOT RenittanceAdviceExist("No.") THEN
                    BOSAManagement.GenerateMemberRemittanceAdvice(Member);
                IF GUIALLOWED THEN
                    ProgressWindow.UPDATE(3, (i / TotalMember * 10000) DIV 1);
            end;

            trigger OnPostDataItem()
            begin
                IF GUIALLOWED THEN
                    ProgressWindow.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                TotalMember := COUNT;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003);
                i := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ProgressWindow: Dialog;
        i: Integer;
        TotalMember: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        CBSSetup: Record "CBS Setup";
        Text000: Label 'Generating Remittance Advice\';
        Text001: Label 'Member No.     #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Progress          @3@@@@@@@@@@@@@@@@@@@@@@@\';

    local procedure RenittanceAdviceExist(MemberNo: Code[20]): Boolean
    var
        RemittanceHeader: Record "Member Remittance Header";
    begin
        RemittanceHeader.RESET;
        RemittanceHeader.SETRANGE("Member No.", MemberNo);
        EXIT(RemittanceHeader.FINDFIRST);
    end;
}

