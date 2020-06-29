report 50098 "Generate Agency Advice"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem4; Agency)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code";
            column(Code_Agency; Code)
            {
            }
            column(Name_Agency; Name)
            {
            }

            trigger OnAfterGetRecord()
            begin
                DocumentNo := '';
                AgencyRemittanceHeader.RESET;
                AgencyRemittanceHeader.SETRANGE("Agency Code", Code);
                AgencyRemittanceHeader.SETRANGE("Period Month", RemittanceMonth);
                AgencyRemittanceHeader.SETRANGE("Period Year", RemittanceYear);
                IF AgencyRemittanceHeader.FINDFIRST THEN BEGIN
                    IF CONFIRM(STRSUBSTNO(Text004, AgencyRemittanceHeader."Agency Name", AgencyRemittanceHeader."Period Month", AgencyRemittanceHeader."Period Year"), TRUE) THEN BEGIN
                        AgencyRemittanceLine.SETRANGE("Document No.", AgencyRemittanceHeader."No.");
                        IF AgencyRemittanceHeader.Status <> AgencyRemittanceHeader.Status::New THEN
                            ERROR(Error001, FORMAT(AgencyRemittanceHeader.Status));

                        AgencyRemittanceLine.DELETEALL;
                        AgencyRemittanceHeader.DELETE;

                        CreateAgencyRemittanceAdvice;
                    END ELSE
                        EXIT;
                END ELSE
                    CreateAgencyRemittanceAdvice;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate; RemittanceStartDate)
                {
                    Caption = 'Period';
                    TableRelation = "Remittance Period";
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        IF RemittancePeriod.GET(RemittanceStartDate) THEN BEGIN
                            RemittanceMonth := RemittancePeriod.Month;
                            RemittanceYear := RemittancePeriod.Year;
                        END;
                    end;
                }
                field(Month; RemittanceMonth)
                {
                    Caption = 'Month';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Year; RemittanceYear)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF RemittanceStartDate = 0D THEN
            ERROR(Error002);
    end;

    var
        ProgressWindow: Dialog;
        i: Integer;
        j: Integer;
        TotalAgency: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        CBSSetup: Record "CBS Setup";
        Text000: Label 'Generating Remittance Advice\';
        Text001: Label 'Member No.     #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Progress          @3@@@@@@@@@@@@@@@@@@@@@@@\';
        RemittanceStartDate: Date;
        RemittanceMonth: Text[10];
        RemittancePeriod: Record "Remittance Period";
        RemittanceYear: Integer;
        MemberRemittanceHeader: Record "Member Remittance Header";
        Member: Record "Member";
        MemberRemittanceLine: Record "Member Remittance Line";
        RemittanceAmount: array[10] of Decimal;
        DocumentNo: Code[20];
        MemberAgency: Record "Member Agency";
        AgencyRemittanceHeader: Record "Agency Remittance Header";
        Text004: Label 'Remittance Advice for %1 Period %2 %3 already exist. Do you wish to replace?';
        AgencyRemittanceLine: Record "Agency Remittance Line";
        Error001: Label 'You cannot replace remittance for this period because it is already %1';
        Error002: Label 'You must select remittance period';

    local procedure CreateAgencyRemittanceAdvice()
    begin
        BOSAManagement.GenerateAgencyRemittanceHeader(DataItem4.Code, RemittanceStartDate, DocumentNo);
        Member.RESET;
        Member.SETRANGE("Agency Code", DataItem4.Code);
        IF Member.FINDSET THEN BEGIN
            REPEAT
                MemberRemittanceHeader.RESET;
                MemberRemittanceHeader.SETRANGE("Member No.", Member."No.");
                IF MemberRemittanceHeader.FINDFIRST THEN BEGIN
                    MemberRemittanceLine.RESET;
                    MemberRemittanceLine.SETRANGE("Document No.", MemberRemittanceHeader."No.");
                    IF MemberRemittanceLine.FINDSET THEN BEGIN
                        REPEAT
                            BOSAManagement.GenerateAgencyRemittanceLine(MemberRemittanceHeader, MemberRemittanceLine, DocumentNo);
                        UNTIL MemberRemittanceLine.NEXT = 0;
                    END;
                END;
            UNTIL Member.NEXT = 0;
        END;
    end;
}

