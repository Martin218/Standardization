report 50100 "Export Agency Rem. Advice"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Export Agency Rem. Advice.rdlc';

    dataset
    {
        dataitem(DataItem7; Integer)
        {
            DataItemTableView = SORTING(Number);
            column(Description_i; Description[i])
            {
            }
            column(Description_j; Description2[j])
            {
            }
            column(Code_i; Code[i])
            {
            }
            column(Code_j; Code2[j])
            {
            }
            column(Code3_1; Code3[1])
            {
            }
            column(Code3_2; Code3[2])
            {
            }
            column(Code3_3; Code3[3])
            {
            }
            column(Code3_4; Code3[4])
            {
            }
            dataitem(DataItem17; "Agency Remittance Header")
            {
                RequestFilterFields = "No.";
                column(No_AgencyRemittanceHeader; "No.")
                {
                }
                column(AgencyCode_AgencyRemittanceHeader; "Agency Code")
                {
                }
                column(AgencyName_AgencyRemittanceHeader; "Agency Name")
                {
                }
                column(Description_AgencyRemittanceHeader; Description)
                {
                }
                column(RemittanceMonth; RemittanceMonth)
                {
                }
                column(RemittanceYear; RemittanceYear)
                {
                }
                dataitem(DataItem4; "Agency Remittance Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    column(MemberNo_AgencyRemittanceLine; AgencyRemittanceLine."Member No.")
                    {
                    }
                    column(MemberName_AgencyRemittanceLine; AgencyRemittanceLine."Member Name")
                    {
                    }
                    column(Data_1; Data1)
                    {
                    }
                    column(Data2_1; Data2[1])
                    {
                    }
                    column(Data2_2; Data2[2])
                    {
                    }
                    column(Data2_3; Data2[3])
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Data1 := 0;
                        Data2[1] := 0;
                        Data2[2] := 0;
                        Data2[3] := 0;
                        AgencyRemittanceLine.RESET;
                        AgencyRemittanceLine.SETRANGE("Member No.", "Member No.");
                        IF AgencyRemittanceLine.FINDSET THEN BEGIN
                            REPEAT
                                IF AgencyRemittanceLine."Contribution Type" = AgencyRemittanceLine."Contribution Type"::Normal THEN BEGIN
                                    IF AgencyRemittanceLine."Remittance Code" = Code3[1] THEN
                                        Data1 := AgencyRemittanceLine."Expected Amount";
                                END;
                                IF AgencyRemittanceLine."Contribution Type" = AgencyRemittanceLine."Contribution Type"::"Principal Due" THEN BEGIN
                                    IF AgencyRemittanceLine."Remittance Code" = Code3[2] THEN
                                        Data2[1] := AgencyRemittanceLine."Expected Amount";
                                END;
                                IF AgencyRemittanceLine."Contribution Type" = AgencyRemittanceLine."Contribution Type"::"Interest Due" THEN BEGIN
                                    IF AgencyRemittanceLine."Remittance Code" = Code3[3] THEN
                                        Data2[2] := AgencyRemittanceLine."Expected Amount";
                                END;
                                IF AgencyRemittanceLine."Contribution Type" = AgencyRemittanceLine."Contribution Type"::Insurance THEN BEGIN
                                    IF AgencyRemittanceLine."Remittance Code" = Code3[4] THEN
                                        Data2[3] := AgencyRemittanceLine."Expected Amount";
                                END;
                            UNTIL AgencyRemittanceLine.NEXT = 0;
                        END
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    RemittanceMonth := "Period Month";
                    RemittanceYear := "Period Year";
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("No.", DocumentNo);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN BEGIN
                    AccountType.FINDSET;
                    LoanProductType.FINDSET;
                    i := 1;
                    j := 1;
                END ELSE BEGIN
                    AccountType.NEXT;
                    LoanProductType.NEXT;
                    i := Number;
                    j := Number;
                END;

                Description[i] := AccountType.Description;
                Code[i] := AccountType.Code;

                Description2[j] := LoanProductType.Description;
                Code2[j] := LoanProductType.Code;

                RemittanceCode.RESET;
                RemittanceCode.SETRANGE("Account Category", RemittanceCode."Account Category"::Vendor);
                RemittanceCode.SETRANGE("Account Type", AccountType.Code);
                RemittanceCode.SETRANGE("Contribution Type", RemittanceCode."Contribution Type"::Normal);
                IF RemittanceCode.FINDFIRST THEN BEGIN
                    IF RemittanceCode."Account Type" = AccountType.Code THEN
                        Code3[1] := RemittanceCode.Code;
                END;
                Code3[2] := '';
                Code3[3] := '';
                Code3[4] := '';
                RemittanceCode.RESET;
                RemittanceCode.SETRANGE("Account Category", RemittanceCode."Account Category"::Customer);
                RemittanceCode.SETRANGE("Account Type", LoanProductType.Code);
                IF RemittanceCode.FINDSET THEN BEGIN
                    REPEAT
                        IF RemittanceCode."Contribution Type" = RemittanceCode."Contribution Type"::"Principal Due" THEN
                            Code3[2] := RemittanceCode.Code;
                        IF RemittanceCode."Contribution Type" = RemittanceCode."Contribution Type"::"Interest Due" THEN
                            Code3[3] := RemittanceCode.Code;
                        IF RemittanceCode."Contribution Type" = RemittanceCode."Contribution Type"::Insurance THEN
                            Code3[4] := RemittanceCode.Code;
                    UNTIL RemittanceCode.NEXT = 0;
                END;
                /*Data1:=0;
                Data2[1]:=0;
                Data2[2]:=0;
                Data2[3]:=0;*/

            end;

            trigger OnPreDataItem()
            begin
                AccountType.FINDSET;
                LoanProductType.FINDSET;
                TotalColumn := AccountType.COUNT + LoanProductType.COUNT;
                SETRANGE(Number, 1, TotalColumn);
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
        j: Integer;
        TotalAgency: Integer;
        Text000: Label 'Generating Remittance Advice\';
        Text001: Label 'Member No.     #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Progress          @3@@@@@@@@@@@@@@@@@@@@@@@\';
        Description: array[100] of Text[50];
        Description2: array[100] of Text[50];
        "Code": array[100] of Code[20];
        Code2: array[100] of Code[20];
        Code3: array[10] of Code[20];
        LoanProductType: Record "Loan Product Type";
        AccountType: Record "Account Type";
        TotalColumn: Integer;
        RemittanceCode: Record "Remittance Code";
        RemittanceMonth: Text[20];
        RemittanceYear: Integer;
        Data1: Decimal;
        Data2: array[10] of Decimal;
        AgencyRemittanceLine: Record "Agency Remittance Line";
        DocumentNo: Code[20];

    procedure SetDocumentNo(var DocNo: Code[20]): Boolean
    var
        RemittanceHeader: Record "Member Remittance Header";
    begin
        DocumentNo := DocNo;
    end;
}

