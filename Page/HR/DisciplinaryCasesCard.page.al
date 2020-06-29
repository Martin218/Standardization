page 50421 "Disciplinary Cases Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = 50215;


    layout
    {
        area(content)
        {
            group(General)
            {
                field("Case No"; "Case No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Case Description"; "Case Description")
                {
                    ApplicationArea = All;
                }
                field("Date of the Case"; "Date of the Case")
                {
                    ApplicationArea = All;
                }
                field("Offense Type"; "Offense Type")
                {
                    ApplicationArea = All;
                }
                field("Offense Name"; "Offense Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee No"; "Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Case Status"; "Case Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("HOD Name"; "HOD Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("HOD Recommendation"; "HOD Recommendation")
                {
                    Caption = 'Supervisor Recommendation';
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("HR Recommendation"; "HR Recommendation")
                {
                    Caption = 'HR Recommendation';
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Commitee Recommendation"; "Commitee Recommendation")
                {
                    MultiLine = true;
                    Visible = ongoingbl;
                    ApplicationArea = All;
                }
                field("Action Taken"; "Action Taken")
                {
                    Visible = ongoingbl;
                    ApplicationArea = All;
                }
                field(Appealed; Appealed)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Committee Recon After Appeal"; "Committee Recon After Appeal")
                {
                    Caption = 'Board-Finance & HR Committe Recomendation';
                    Visible = appealedbl;
                    ApplicationArea = All;
                }
                field("No. of Appeals"; "No. of Appeals")
                {
                    Visible = closedbl;
                    ApplicationArea = All;
                }
                field("Court's Decision"; "Court's Decision")
                {
                    Visible = courtbl;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Proceed To Ongoing")
            {
                Image = OutboundEntry;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = openbl;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF "HOD Recommendation" = '' THEN BEGIN
                        ERROR('Supervisor Advisory Comments are empty');
                    END;


                    "Case Status" := "Case Status"::Ongoing;
                    MESSAGE('Moved to Ongoing Cases Menu...');
                    CurrPage.CLOSE;
                    //DisciplinaryManagement.Proceedtoongoing("Case No");
                end;
            }
            action("Attach HOD Recommendation")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = openbl;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //filename := FileCU.OpenFileDialog('Select  File', '', '');
                    IF filename <> '' THEN BEGIN
                        HRsetup.RESET;
                        HRsetup.GET;
                        filename2 := FORMAT(CURRENTDATETIME) + '_' + USERID;
                        filename2 := CONVERTSTR(filename2, '/', '_');
                        filename2 := CONVERTSTR(filename2, '\', '_');
                        filename2 := CONVERTSTR(filename2, ':', '_');
                        filename2 := CONVERTSTR(filename2, '.', '_');
                        filename2 := CONVERTSTR(filename2, ',', '_');
                        filename2 := CONVERTSTR(filename2, ' ', '_');
                        filename2 := CONVERTSTR(filename2, ' ', '_');
                        //   FileCU.CopyClientFile(filename, HRsetup."File Path" + FileCU.GetFileName(filename), TRUE);
                        "HOD File Path" := HRsetup."File Path" + FileCU.GetFileName(filename);
                        MESSAGE('File Attached Successfully');
                    END;
                end;
            }
            action("Attach HR Recommendation")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = openbl;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    filename := FileCU.OpenFileDialog('Select  File', '', '');
                    IF filename <> '' THEN BEGIN
                        HRsetup.RESET;
                        HRsetup.GET;
                        filename2 := FORMAT(CURRENTDATETIME) + '_' + USERID;
                        filename2 := CONVERTSTR(filename2, '/', '_');
                        filename2 := CONVERTSTR(filename2, '\', '_');
                        filename2 := CONVERTSTR(filename2, ':', '_');
                        filename2 := CONVERTSTR(filename2, '.', '_');
                        filename2 := CONVERTSTR(filename2, ',', '_');
                        filename2 := CONVERTSTR(filename2, ' ', '_');
                        filename2 := CONVERTSTR(filename2, ' ', '_');
                        //   FileCU.CopyClientFile(filename, HRsetup."File Path" + FileCU.GetFileName(filename), TRUE);
                        "HR File Path" := HRsetup."File Path" + FileCU.GetFileName(filename);
                        MESSAGE('File Attached Successfully');
                    END;
                end;
            }
            action("Attach Commitee Recommendation")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ongoingbl;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    filename := FileCU.OpenFileDialog('Select  File', '', '');
                    IF filename <> '' THEN BEGIN
                        HRsetup.RESET;
                        HRsetup.GET;
                        filename2 := FORMAT(CURRENTDATETIME) + '_' + USERID;
                        filename2 := CONVERTSTR(filename2, '/', '_');
                        filename2 := CONVERTSTR(filename2, '\', '_');
                        filename2 := CONVERTSTR(filename2, ':', '_');
                        filename2 := CONVERTSTR(filename2, '.', '_');
                        filename2 := CONVERTSTR(filename2, ',', '_');
                        filename2 := CONVERTSTR(filename2, ' ', '_');
                        filename2 := CONVERTSTR(filename2, ' ', '_');
                        //FileCU.CopyClientFile(filename, HRsetup."File Path" + FileCU.GetFileName(filename), TRUE);
                        "Committe File Path" := HRsetup."File Path" + FileCU.GetFileName(filename);
                        MESSAGE('File Attached Successfully');
                    END;
                end;
            }
            action("Attach File After Appeal")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = appealclosebl;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    filename := FileCU.OpenFileDialog('Select  File', '', '');
                    IF filename <> '' THEN BEGIN
                        HRsetup.RESET;
                        HRsetup.GET;
                        filename2 := FORMAT(CURRENTDATETIME) + '_' + USERID;
                        filename2 := CONVERTSTR(filename2, '/', '_');
                        filename2 := CONVERTSTR(filename2, '\', '_');
                        filename2 := CONVERTSTR(filename2, ':', '_');
                        filename2 := CONVERTSTR(filename2, '.', '_');
                        filename2 := CONVERTSTR(filename2, ',', '_');
                        filename2 := CONVERTSTR(filename2, ' ', '_');
                        filename2 := CONVERTSTR(filename2, ' ', '_');
                        //   FileCU.CopyClientFile(filename, HRsetup."File Path" + FileCU.GetFileName(filename), TRUE);
                        "Committee File-After Appeal" := HRsetup."File Path" + FileCU.GetFileName(filename);
                        MESSAGE('File Attached Successfully');
                    END;
                end;
            }
            action("Open Attached HOD File")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF "HOD File Path" <> '' THEN BEGIN
                        HYPERLINK("HOD File Path");
                    END;
                end;
            }
            action("Open Attached HR File")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF "HR File Path" <> '' THEN BEGIN
                        HYPERLINK("HR File Path");
                    END;
                end;
            }
            action("Open Attached Commitee File")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF "Committe File Path" <> '' THEN BEGIN
                        HYPERLINK("Committe File Path");
                    END;
                end;
            }
            action("Open File After Appeal")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = appealclosebl;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF "Committee File-After Appeal" <> '' THEN BEGIN
                        HYPERLINK("Committee File-After Appeal");
                    END;
                end;
            }
            action("Close Case")
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Ongoingbl;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF "Action Taken" = '' THEN BEGIN
                        ERROR('Fill Action Taken!!');
                    END;
                    IF "Commitee Recommendation" = '' THEN BEGIN
                        ERROR('Please Fill Commitee Recomendation!!');
                    END;

                    IF "Action Taken" <> '' THEN BEGIN
                        "Case Status" := "Case Status"::Closed;
                    END;

                    MESSAGE('Taken to Closed Cases');

                    CurrPage.CLOSE;
                end;
            }
            action("Appeal Case")
            {
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = closedbl;
                ApplicationArea = All;

                trigger OnAction();
                var
                    ans: Boolean;
                begin
                    ans := CONFIRM('Are you sure you want to Appeal this case?');
                    IF FORMAT(ans) = 'Yes' THEN BEGIN
                        "Case Status" := "Case Status"::Appealed;
                    END;
                    "No. of Appeals" += 1;
                    CurrPage.CLOSE;
                end;
            }
            action("Close Case After Appeal")
            {
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = appealedbl;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF "Committee Recon After Appeal" = '' THEN BEGIN
                        ERROR('Please Fill Commitee Recommendation After Appeal!!!');
                    END;
                    "Case Status" := "Case Status"::Closed;
                    MESSAGE('Case moved to Closed Cases');
                    CurrPage.CLOSE;
                end;
            }
            action("HR Close Case")
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = openbl;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF "HR Recommendation" = '' THEN BEGIN
                        ERROR('Fill HR Recommenation!!');
                    END;

                    //IF "Action Taken"<>'' THEN BEGIN
                    "Case Status" := "Case Status"::Closed;
                    //END;

                    MESSAGE('Taken to Closed Cases');

                    CurrPage.CLOSE;
                end;
            }
            action("Moved to Court")
            {
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                var
                    ans: Boolean;
                begin
                    ans := CONFIRM('Are you sure you want to move this case to court?');
                    IF FORMAT(ans) = 'Yes' THEN BEGIN
                        "Case Status" := "Case Status"::Court;
                    END;
                    //`"No. of Appeals"+=1;
                    CurrPage.CLOSE;
                end;
            }
            action("Close Case2")
            {
                Caption = 'Close Case';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = courtbl;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF "Court's Decision" = '' THEN BEGIN
                        ERROR('Please Fill Courts Decision"!!');
                    END;
                    "Case Status" := "Case Status"::Closed;

                    MESSAGE('Taken to Closed Cases');

                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        IF "Case Status" <> "Case Status"::New THEN BEGIN
            ERROR('You cannot Create a new Record at this level. Create it in New Cases Tab');
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        IF "Case Status" <> "Case Status"::New THEN BEGIN
            ERROR('You cannot Create a new Record at this level. Create it in New Cases Tab');
        END;
    end;

    trigger OnOpenPage();
    begin



        IF "Case Status" = "Case Status"::Ongoing THEN BEGIN
            ongoingbl := TRUE;
        END;
        IF "Case Status" = "Case Status"::Appealed THEN BEGIN
            appealedbl := TRUE;
        END;
        IF "Case Status" = "Case Status"::Closed THEN BEGIN
            closedbl := TRUE;
        END;
        IF "Case Status" = "Case Status"::New THEN BEGIN
            openbl := TRUE;
        END;
        IF "Case Status" <> "Case Status"::New THEN BEGIN
            openbl := FALSE;
        END;
        IF ("Case Status" = "Case Status"::Appealed) OR ("Case Status" = "Case Status"::Closed) THEN BEGIN
            appealclosebl := TRUE;
        END;
        IF ("Case Status" = "Case Status"::Closed) OR ("Case Status" = "Case Status"::Court) THEN BEGIN
            courtbl := TRUE;
        END;
    end;

    var
        ongoingbl: Boolean;
        appealedbl: Boolean;
        closedbl: Boolean;
        openbl: Boolean;
        FileCU: Codeunit "File Management";
        filename: Text;
        HRsetup: Record 5218;
        filename2: Text;
        appealclosebl: Boolean;
        courtbl: Boolean;
    // DisciplinaryManagement: Codeunit 50047;
}

