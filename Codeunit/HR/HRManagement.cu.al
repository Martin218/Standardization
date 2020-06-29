codeunit 50050 "HR Management"
{
    // version TL2.0


    trigger OnRun();
    begin
    end;

    var
        FileManagement: Codeunit 419;
        TEXT001: Label '0001';
        TEXT002: Label 'Document';
        TEXT003: Label 'You cannot upload the same document twice.';
        TEXT004: Label 'Document Attached Successfully.';
        TEXT005: Label 'View this file?';
        TEXT006: Label 'Shortlisting Successful';
        TEXT007: Label 'Are you sure you want to process this separation request?';
        HumanResourcesSetup: Record 5218;
        Employee: Record 5200;


    procedure ValidateLeaveTypeByGender(var LeaveApplication: Record 50206);
    var
        LeaveType: Record 50208;
        Employee: Record 5200;
        Error000: Label 'Leave Type %1 is only applicable to male employees!';
        Error001: Label 'Leave Type %1 is only applicable to female employees!';
    begin
        WITH LeaveApplication DO BEGIN
            IF LeaveType.GET("Leave Code") THEN BEGIN
                IF Employee.GET("Employee No") THEN BEGIN
                    IF LeaveType.Gender = LeaveType.Gender::Male THEN BEGIN
                        IF Employee.Gender = Employee.Gender::Female THEN BEGIN
                            ERROR(FORMAT(Error000), LeaveType.Code);
                        END;
                    END;
                    IF LeaveType.Gender = LeaveType.Gender::Female THEN BEGIN
                        IF Employee.Gender = Employee.Gender::Male THEN BEGIN
                            ERROR(FORMAT(Error001), LeaveType.Code);
                        END;
                    END;
                END;
            END;
        END;
    end;

    procedure ValidateLeaveTypeByEmployeeType(var LeaveApplication: Record 50206);
    var
        LeaveType: Record 50208;
        Employee: Record 5200;
        Error000: Label 'Leave Type %1 is only applicable to permanent employees!';
        Error001: Label 'Leave Type %1 is only applicable to temporary employees!';
    begin
        WITH LeaveApplication DO BEGIN
            IF LeaveType.GET("Leave Code") THEN BEGIN
                IF Employee.GET("Employee No") THEN BEGIN
                    IF LeaveType."Eligible Staff" = LeaveType."Eligible Staff"::Permanent THEN BEGIN
                        IF Employee."Employee Type" = Employee."Employee Type"::Permanent THEN BEGIN
                        END ELSE BEGIN
                            ERROR(FORMAT(Error000), LeaveType.Code);
                        END;
                    END ELSE BEGIN
                        IF LeaveType."Eligible Staff" <> LeaveType."Eligible Staff"::Both THEN BEGIN
                            //      END ELSE BEGIN
                            IF Employee."Employee Type" = Employee."Employee Type"::Permanent THEN BEGIN
                                ERROR(FORMAT(Error001), LeaveType.Code);
                            END;
                        END;
                    END;
                END;
            END;
        END;
    END;

    procedure ValidateLeaveTypeByConfirmationStatus(var LeaveApplication: Record 50206);
    var
        LeaveType: Record 50208;
        Employee: Record 5200;
        Error000: Label 'Leave Type %1 is only applicable to confirmed employees!';
    begin
        WITH LeaveApplication DO BEGIN
            IF LeaveType.GET("Leave Code") THEN BEGIN
                IF Employee.GET("Employee No") THEN BEGIN
                    IF LeaveType."Employment Status" = LeaveType."Employment Status"::Confirmed THEN BEGIN
                        ///  IF Employee.Status=Employee.Status::Probation THEN BEGIN
                        //  ERROR(FORMAT(Error000),LeaveType.Code);
                        //   END;
                    END;
                END;
            END;
        END;
    end;

    procedure GetEarnedLeaveDays(EmployeeNo: Code[20]; LeaveCode: Code[20]; Date: Date): Decimal;
    var
        LeaveLedgerEntry: Record 50209;
        EarnedDays: Decimal;
    begin
        LeaveLedgerEntry.RESET;
        LeaveLedgerEntry.SETRANGE("Leave Code", LeaveCode);
        LeaveLedgerEntry.SETRANGE("Employee No.", EmployeeNo);
        LeaveLedgerEntry.SETRANGE(Closed, FALSE);
        LeaveLedgerEntry.SETRANGE("Earned Leave Days", TRUE);
        LeaveLedgerEntry.SETFILTER("Posting Date", '<=%1', Date);
        IF LeaveLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                EarnedDays += ABS(LeaveLedgerEntry.Days);
            UNTIL LeaveLedgerEntry.NEXT = 0;
        END;
        EXIT(EarnedDays);
    end;

    procedure GetUsedLeaveDays(EmployeeNo: Code[20]; LeaveCode: Code[20]; Date: Date): Decimal;
    var
        LeaveLedgerEntry: Record 50209;
        UsedDays: Decimal;
    begin
        LeaveLedgerEntry.RESET;
        LeaveLedgerEntry.SETRANGE("Leave Code", LeaveCode);
        LeaveLedgerEntry.SETRANGE("Employee No.", EmployeeNo);
        LeaveLedgerEntry.SETRANGE(Closed, FALSE);
        LeaveLedgerEntry.SETRANGE("Entry Type", LeaveLedgerEntry."Entry Type"::Negative);
        LeaveLedgerEntry.SETFILTER("Posting Date", '<=%1', Date);
        IF LeaveLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                UsedDays += ABS(LeaveLedgerEntry.Days);
            UNTIL LeaveLedgerEntry.NEXT = 0;
        END;
        EXIT(UsedDays);
    end;

    procedure GetBalanceBroughtForward(EmployeeNo: Code[20]; LeaveCode: Code[20]; Date: Date): Decimal;
    var
        LeaveLedgerEntry: Record 50209;
        BroughtForwardDays: Decimal;
    begin
        LeaveLedgerEntry.RESET;
        LeaveLedgerEntry.SETRANGE("Leave Code", LeaveCode);
        LeaveLedgerEntry.SETRANGE("Employee No.", EmployeeNo);
        LeaveLedgerEntry.SETRANGE(Closed, FALSE);
        LeaveLedgerEntry.SETRANGE("Balance Brought Forward", TRUE);
        LeaveLedgerEntry.SETFILTER("Posting Date", '<=%1', Date);
        IF LeaveLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                BroughtForwardDays += ABS(LeaveLedgerEntry.Days);
            UNTIL LeaveLedgerEntry.NEXT = 0;
        END;
        EXIT(BroughtForwardDays);
    end;

    procedure GetRecalledDays(EmployeeNo: Code[20]; LeaveCode: Code[20]; Date: Date): Decimal;
    var
        LeaveLedgerEntry: Record 50209;
        RecalledDays: Decimal;
    begin
        LeaveLedgerEntry.RESET;
        LeaveLedgerEntry.SETRANGE("Leave Code", LeaveCode);
        LeaveLedgerEntry.SETRANGE("Employee No.", EmployeeNo);
        LeaveLedgerEntry.SETRANGE(Closed, FALSE);
        LeaveLedgerEntry.SETRANGE(Recall, TRUE);
        LeaveLedgerEntry.SETFILTER("Posting Date", '<=%1', Date);
        IF LeaveLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                RecalledDays += ABS(LeaveLedgerEntry.Days);
            UNTIL LeaveLedgerEntry.NEXT = 0;
        END;
        EXIT(RecalledDays);
    end;

    procedure GetLostDays(EmployeeNo: Code[20]; LeaveCode: Code[20]; Date: Date): Decimal;
    var
        LeaveLedgerEntry: Record 50209;
        LostDays: Decimal;
    begin
        LeaveLedgerEntry.RESET;
        LeaveLedgerEntry.SETRANGE("Leave Code", LeaveCode);
        LeaveLedgerEntry.SETRANGE("Employee No.", EmployeeNo);
        LeaveLedgerEntry.SETRANGE(Closed, FALSE);
        LeaveLedgerEntry.SETRANGE("Lost Days", TRUE);
        LeaveLedgerEntry.SETFILTER("Posting Date", '<=%1', Date);
        IF LeaveLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                LostDays += ABS(LeaveLedgerEntry.Days);
            UNTIL LeaveLedgerEntry.NEXT = 0;
        END;
        EXIT(LostDays);
    end;

    procedure GetAddedBackDays(EmployeeNo: Code[20]; LeaveCode: Code[20]; Date: Date): Decimal;
    var
        LeaveLedgerEntry: Record 50209;
        AddedBackDays: Decimal;
    begin
        LeaveLedgerEntry.RESET;
        LeaveLedgerEntry.SETRANGE("Leave Code", LeaveCode);
        LeaveLedgerEntry.SETRANGE("Employee No.", EmployeeNo);
        LeaveLedgerEntry.SETRANGE(Closed, FALSE);
        LeaveLedgerEntry.SETRANGE("Added Back Days", TRUE);
        LeaveLedgerEntry.SETFILTER("Posting Date", '<=%1', Date);
        IF LeaveLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                AddedBackDays += ABS(LeaveLedgerEntry.Days);
            UNTIL LeaveLedgerEntry.NEXT = 0;
        END;
        EXIT(AddedBackDays);
    end;

    procedure GetLeaveBalance(EmployeeNo: Code[20]; LeaveCode: Code[20]; Date: Date): Decimal;
    var
        LeaveLedgerEntry: Record 50209;
        LeaveBalance: Decimal;
    begin
        LeaveLedgerEntry.RESET;
        LeaveLedgerEntry.SETRANGE("Leave Code", LeaveCode);
        LeaveLedgerEntry.SETRANGE("Employee No.", EmployeeNo);
        LeaveLedgerEntry.SETRANGE(Closed, FALSE);
        LeaveLedgerEntry.SETFILTER("Posting Date", '<=%1', Date);
        IF LeaveLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                LeaveBalance += LeaveLedgerEntry.Days;
            UNTIL LeaveLedgerEntry.NEXT = 0;
        END;
        EXIT(LeaveBalance);
    end;

    procedure CalculateLeaveEndDate(LeaveDays: Decimal; StartDate: Date): Date;
    var
        BaseCalendarChange: Record 7601;
        Days: Decimal;
        FullDays: Decimal;
        HalfDays: Decimal;
        EndDate: Date;
    begin
        FullDays := LeaveDays DIV 1;
        HalfDays := LeaveDays MOD 1;
        Days := FullDays + HalfDays;
        EndDate := StartDate;
        WHILE Days > 1 DO BEGIN
            EndDate := CALCDATE('1D', EndDate);
            BaseCalendarChange.RESET;
            BaseCalendarChange.SETRANGE("Base Calendar Code", 'CBS');
            BaseCalendarChange.SETRANGE(Date, EndDate);
            IF NOT BaseCalendarChange.FINDFIRST THEN BEGIN
                Days -= 1;
            END;
        END;
        EXIT(EndDate);
    end;

    procedure CalculateResumptionDate(var LeaveApplication: Record 50206);
    var
        BaseCalendarChange: Record 7601;
    begin
        WITH LeaveApplication DO BEGIN
            "Resumption Date" := CALCDATE('1D', "End Date");
            BaseCalendarChange.RESET;
            BaseCalendarChange.SETRANGE("Base Calendar Code", 'CBS');
            IF BaseCalendarChange.FINDSET THEN BEGIN
                REPEAT
                    IF BaseCalendarChange.Date = "Resumption Date" THEN BEGIN
                        "Resumption Date" := CALCDATE('1D', "Resumption Date");
                    END;
                UNTIL BaseCalendarChange.NEXT = 0;
            END;
        END;
    end;

    procedure InsertLeaveLedgerEntry(Period: Code[10]; DocumentNo: Code[20]; EmployeeNo: Code[20]; LeaveCode: Code[20]; Description: Text; Days: Decimal; EntryType: Option; LostDays: Boolean; EarnedDays: Boolean; BalanceBroughtForward: Boolean; RecalledDays: Boolean; AddedBackDays: Boolean);
    var
        LeaveLedgerEntry: Record 50209;
        Employee: Record 5200;
    begin
        LeaveLedgerEntry.INIT;
        LeaveLedgerEntry."Posting Date" := TODAY;
        LeaveLedgerEntry."Document No" := DocumentNo;
        LeaveLedgerEntry."Leave Code" := LeaveCode;
        LeaveLedgerEntry."Leave Period" := Period;
        LeaveLedgerEntry."Employee No." := EmployeeNo;
        IF Employee.GET(EmployeeNo) THEN;
        LeaveLedgerEntry."Employee Name" := Employee.FullName;
        LeaveLedgerEntry.Description := Description;
        LeaveLedgerEntry."Entry Type" := EntryType;
        LeaveLedgerEntry."User ID" := USERID;
        LeaveLedgerEntry.Days := Days;
        LeaveLedgerEntry."Lost Days" := LostDays;
        LeaveLedgerEntry."Added Back Days" := AddedBackDays;
        LeaveLedgerEntry."Balance Brought Forward" := BalanceBroughtForward;
        LeaveLedgerEntry."Earned Leave Days" := EarnedDays;
        LeaveLedgerEntry.Recall := RecalledDays;
        LeaveLedgerEntry.INSERT;
    end;

    procedure PostLeaveJournal(var LeaveJournal: Record 50224);
    var
        Selected: Integer;
        Text000: Label 'Balance Brought Forward,Added back days,Lost Days';
        Text001: Label 'Please confirm the type of posting';
    begin
        Selected := 0;
        Selected := DIALOG.STRMENU(Text000, 4, Text001);
        IF Selected <> 0 THEN BEGIN
            WITH LeaveJournal DO BEGIN
                IF Selected = 1 THEN BEGIN
                    InsertLeaveLedgerEntry(FORMAT(DATE2DMY(TODAY, 3)), FORMAT(DATE2DMY(TODAY, 3)), "Employee No.", "Leave Type", Description, Days, "Entry Type"::Positive, FALSE, FALSE, TRUE, FALSE, FALSE);
                END;
                IF Selected = 2 THEN BEGIN
                    InsertLeaveLedgerEntry(FORMAT(DATE2DMY(TODAY, 3)), FORMAT(DATE2DMY(TODAY, 3)), "Employee No.", "Leave Type", Description, Days, "Entry Type"::Positive, FALSE, FALSE, FALSE, FALSE, TRUE);
                END;
                IF Selected = 3 THEN BEGIN
                    InsertLeaveLedgerEntry(FORMAT(DATE2DMY(TODAY, 3)), FORMAT(DATE2DMY(TODAY, 3)), "Employee No.", "Leave Type", Description, Days, "Entry Type"::Positive, TRUE, FALSE, FALSE, FALSE, FALSE);
                END;
                LeaveJournal.DELETE;
            END;
        END;
    end;

    procedure SendMail(Recipient: Text; Subject: Text; Body: Text; Attachment: Text; FileName: Text);
    var
        SMTPMailSetup: Record 409;
        SMTPMail: Codeunit 400;
        CompanyInformation: Record 79;
    begin
        CompanyInformation.GET;
        SMTPMailSetup.GET;
        // SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."User ID", Recipient, Subject, Body, TRUE);
        IF Attachment <> '' THEN
            //   SMTPMail.AddAttachment(Attachment, FileName);
            SMTPMail.Send;
    end;

    procedure CloseLeaveYear();
    var
        LeavePeriod: Record 50212;
        LeavePeriod2: Record 50212;
        Text000: Label 'Leave Period has been closed successfully!';
    begin
        LeavePeriod.RESET;
        LeavePeriod.SETRANGE(Closed, FALSE);
        LeavePeriod.SETRANGE("New Fiscal Year", TRUE);
        IF LeavePeriod.FINDFIRST THEN BEGIN
            LeavePeriod2.RESET;
            LeavePeriod2.SETFILTER("Starting Date", '%1..%2', LeavePeriod."Starting Date", CALCDATE('11M', LeavePeriod."Starting Date"));
            IF LeavePeriod2.FINDSET THEN BEGIN
                REPEAT
                    LeavePeriod2.Closed := TRUE;
                    LeavePeriod2."Date Locked" := TRUE;
                    LeavePeriod2.MODIFY;
                UNTIL LeavePeriod2.NEXT = 0;
                MESSAGE(Text000);
            END;
            UpdateLeaveBalances(DATE2DMY(LeavePeriod."Starting Date", 3));
        END;
    end;

    procedure AttachHRDocs(HumanResourceDoc: Record 50226);
    var
        FileName: Text[500];
        FileName2: Text[500];
        docname: Text;
        docname2: Text;
        filecu: Codeunit 419;
        EmployeeDocuments: Record 50228;
        HRSetup: Record 5218;
        DocPath: Text;
        Text000: Label 'Select HR Document';
        Text001: Label 'HR Document';
        Text002: Label 'PDF Files (*.PDF)|*.PDF|All Files (*.*)|*.*';
        Text003: Label '_HR_Document';
    begin
        WITH HumanResourceDoc DO BEGIN

            HRSetup.RESET;
            HRSetup.GET;
            HRSetup.TESTFIELD("Employee Docs File Path");
            FileName := filecu.OpenFileDialog(Text000, '', '');

            docname := Text001;
            docname2 := Text002;
            docname := CONVERTSTR(docname, '/', '_');
            docname := CONVERTSTR(docname, '\', '_');
            docname := CONVERTSTR(docname, ':', '_');
            docname := CONVERTSTR(docname, '.', '_');
            docname := CONVERTSTR(docname, ',', '_');
            docname := CONVERTSTR(docname, ' ', '_');
            docname := CONVERTSTR(docname, ' ', '_');
            docname2 := CONVERTSTR(docname2, '/', '_');
            docname2 := CONVERTSTR(docname2, '\', '_');
            docname2 := CONVERTSTR(docname2, ':', '_');
            docname2 := CONVERTSTR(docname2, '.', '_');
            docname2 := CONVERTSTR(docname2, ',', '_');
            docname2 := CONVERTSTR(docname2, ' ', '_');
            docname2 := CONVERTSTR(docname2, ' ', '_');


            FileName2 := HRSetup."Employee Docs File Path" + docname + '_' + docname2 + Text003 + '_' + filecu.GetFileName(FileName);
            filecu.CopyClientFile(FileName, HRSetup."Employee Docs File Path" + filecu.GetFileName(FileName), TRUE);
            //  filecu.CopyClientFile();

            HumanResourceDoc.RESET;
            HumanResourceDoc.SETRANGE("Document Name", filecu.GetFileName(FileName));
            IF HumanResourceDoc.FIND('-') THEN BEGIN
                ERROR(Text003);
            END;

            HumanResourceDoc.INIT;
            HumanResourceDoc."Document Path" := FileName2;
            HumanResourceDoc."Document Name" := filecu.GetFileName(FileName);
            HumanResourceDoc."Upload By" := USERID;
            HumanResourceDoc."Upload date" := TODAY;
            HumanResourceDoc."Upload Time" := TIME;
            HumanResourceDoc.INSERT(TRUE);
            MESSAGE(TEXT004);
        END;
    end;

    procedure ViewHRDocs(HumanResourceDoc: Record 50226);
    var
        lastno: Integer;
        HRDocumentView: Record 50227;
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        DocumentStream: OutStream;
        FullFileName: Text;
    begin
        WITH HumanResourceDoc DO BEGIN
            IF CONFIRM(TEXT005) THEN BEGIN
                //   Message("Document Path");
                //HYPERLINK("Document Path");

                FullFileName := "Document Name";
                TempBlob.CreateOutStream(DocumentStream);
                //   "Document Reference ID".ExportStream(DocumentStream);
                FileManagement.BLOBExport(TempBlob, FullFileName, true);

                HRDocumentView.RESET;
                IF HRDocumentView.FINDLAST THEN BEGIN
                    lastno := HRDocumentView."No." + 1;
                END;

                HRDocumentView.INIT;
                HRDocumentView."No." := lastno;
                HRDocumentView.User := USERID;
                HRDocumentView."Document Name" := "Document Name";
                HRDocumentView.Date := CURRENTDATETIME;
                HRDocumentView."View Date" := TODAY;
                HRDocumentView.INSERT;
            END;
        END;
    end;

    procedure UpdateLeaveBalances(LeavePeriodClosed: Integer);
    var
        Employee: Record 5200;
        LeaveLedgerEntry: Record 50209;
        Balance: Decimal;
        Balance2: Decimal;
        LeaveType: Record 50208;
        Text000: Label '"BF "';
        Text001: Label '"LOST DAYS "';
    begin
        LeaveType.RESET;
        LeaveType.SETFILTER("Max Carry Forward Days", '<>%1', 0);
        IF LeaveType.FINDSET THEN BEGIN
            REPEAT
                Employee.RESET;
                //  Employee.SETRANGE("Employee Type", Employee."Employee Type"::Permanent);
                Employee.SETFILTER(Status, '<>%1', Employee.Status::Terminated);
                IF Employee.FINDSET THEN BEGIN
                    REPEAT
                        Balance := 0;
                        Balance := GetLeaveBalance(Employee."No.", LeaveType.Code, TODAY);
                        IF Balance > 0 THEN BEGIN
                            Balance2 := Balance - LeaveType."Max Carry Forward Days";
                            IF Balance2 = 0 THEN BEGIN
                                InsertLeaveLedgerEntry(FORMAT(LeavePeriodClosed + 1), Text000 + FORMAT(LeavePeriodClosed), Employee."No.", LeaveType.Code, '', Balance, LeaveLedgerEntry."Entry Type"::Positive, FALSE, FALSE, TRUE, FALSE, FALSE);
                            END;
                            IF Balance2 > 0 THEN BEGIN
                                InsertLeaveLedgerEntry(FORMAT(LeavePeriodClosed + 1), Text000 + FORMAT(LeavePeriodClosed), Employee."No.", LeaveType.Code, '', LeaveType."Max Carry Forward Days", LeaveLedgerEntry."Entry Type"::Positive, FALSE, FALSE, TRUE, FALSE, FALSE);
                                InsertLeaveLedgerEntry(FORMAT(LeavePeriodClosed + 1), Text001 + FORMAT(LeavePeriodClosed), Employee."No.", LeaveType.Code, '', Balance2, LeaveLedgerEntry."Entry Type"::Positive, TRUE, FALSE, FALSE, FALSE, FALSE);
                            END;
                            IF Balance2 < 0 THEN BEGIN
                                InsertLeaveLedgerEntry(FORMAT(LeavePeriodClosed + 1), Text000 + FORMAT(LeavePeriodClosed), Employee."No.", LeaveType.Code, '', Balance, LeaveLedgerEntry."Entry Type"::Positive, FALSE, FALSE, TRUE, FALSE, FALSE);
                            END;
                        END ELSE BEGIN
                            InsertLeaveLedgerEntry(FORMAT(LeavePeriodClosed + 1), Text000 + FORMAT(LeavePeriodClosed), Employee."No.", LeaveType.Code, '', Balance, LeaveLedgerEntry."Entry Type"::Positive, FALSE, FALSE, TRUE, FALSE, FALSE);
                        END;
                        CloseLeaveEntries(Employee."No.", LeavePeriodClosed);
                    UNTIL Employee.NEXT = 0;
                END;
            UNTIL LeaveType.NEXT = 0;
        END;
    end;

    local procedure CloseLeaveEntries(EmployeeNo: Code[20]; LeavePeriod: Integer);
    var
        LeaveLedgerEntry: Record 50209;
    begin
        LeaveLedgerEntry.RESET;
        LeaveLedgerEntry.SETRANGE(Closed, FALSE);
        LeaveLedgerEntry.SETRANGE("Employee No.", EmployeeNo);
        LeaveLedgerEntry.SETFILTER("Leave Period", FORMAT(LeavePeriod));
        IF LeaveLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                LeaveLedgerEntry.Closed := TRUE;
                LeaveLedgerEntry.MODIFY;
            UNTIL LeaveLedgerEntry.NEXT = 0;
        END;
    end;

    procedure PostStaffMovement(var EmployeeMovement: Record 50229);
    var
        Employee: Record 5200;
        Text000: Label 'Staff %1 has been posted successfully!';
    begin
        WITH EmployeeMovement DO BEGIN
            IF Employee.GET("Employee No.") THEN BEGIN
                //   Employee."Global Dimension 1 Code" := "New Branch Code";
                //   Employee.VALIDATE("Global Dimension 1 Code");
                //    Employee."Global Dimension 2 Code" := "New Department Code";
                //    Employee.VALIDATE("Global Dimension 2 Code");
                Employee."Job Title" := "New Job Title";
                IF "New Salary" <> 0 THEN;
                Employee."Basic Pay" := "New Salary";
                IF Employee.MODIFY THEN BEGIN
                    "Posted By" := USERID;
                    "Posted Date" := TODAY;
                    "Posted Time" := TIME;
                    Status := Status::Posted;
                    IF MODIFY THEN BEGIN
                        MESSAGE(FORMAT(Text000), Type);
                    END;
                END;
            END;
        END;
    end;

    procedure ViewEmployeeData(Employee: Record 5200);
    var
        lastno: Integer;
        EmployeeDataView: Record 50244;
    begin
        WITH Employee DO BEGIN

            EmployeeDataView.INIT;
            EmployeeDataView.User := USERID;
            EmployeeDataView."Employee No" := "No.";
            EmployeeDataView."Employee Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            EmployeeDataView.Date := TODAY;
            EmployeeDataView.Time := TIME;
            EmployeeDataView.INSERT;

        END;
    end;

    procedure GetCurrentAppraisalPeriod(): Code[10];
    var
        AppraisalPeriod: Record 50260;
    begin
        AppraisalPeriod.RESET;
        AppraisalPeriod.SETRANGE(Active, TRUE);
        IF AppraisalPeriod.FINDFIRST THEN
            EXIT(FORMAT(AppraisalPeriod.Code));
    end;
    /*
                procedure CreateAppraisalEntries(var PerformanceContract: Record 50264);
                var
                    AppraisalPeriod: Record "50260";
                    EmployeeQuantitativeGoal: Record "50265";
                    EmployeeQualitativeGoal: Record "50266";
                    QuantitativeGoal: Record "50262";
                    QualitativeGoal: Record "50263";
                    AppraisalYear: Integer;
                begin
                    WITH PerformanceContract DO BEGIN
                        HumanResourcesSetup.GET;
                        IF HumanResourcesSetup."Use Quantitative Goals" THEN BEGIN
                            QuantitativeGoal.RESET;
                            IF QuantitativeGoal.FINDSET THEN BEGIN
                                REPEAT
                                    IF QuantitativeGoal.Department = '' THEN BEGIN
                                        EmployeeQuantitativeGoal.RESET;
                                        EmployeeQuantitativeGoal.SETRANGE(Code, QuantitativeGoal.Code);
                                        EmployeeQuantitativeGoal.SETRANGE("Appraisal Year", "Appraisal Year");
                                        IF NOT EmployeeQuantitativeGoal.FINDFIRST THEN BEGIN
                                            EmployeeQuantitativeGoal.INIT;
                                            EmployeeQuantitativeGoal."Contract No." := PerformanceContract."Contract No.";
                                            EmployeeQuantitativeGoal."Employee No." := "Employee No.";
                                            EmployeeQuantitativeGoal."Employee Name" := "Employee Name";
                                            EmployeeQuantitativeGoal.Code := QuantitativeGoal.Code;
                                            EmployeeQuantitativeGoal.Description := QuantitativeGoal.Description;
                                            EmployeeQuantitativeGoal."Percentage Weighting" := QuantitativeGoal.Percentage;
                                            EmployeeQuantitativeGoal."Appraisal Year" := "Appraisal Year";
                                            EmployeeQuantitativeGoal.Original := TRUE;
                                            EmployeeQuantitativeGoal.INSERT(TRUE);
                                        END;
                                    END ELSE BEGIN
                                        IF "Employee Department Code" = QuantitativeGoal.Department THEN BEGIN
                                            EmployeeQuantitativeGoal.RESET;
                                            EmployeeQuantitativeGoal.SETRANGE(Code, QuantitativeGoal.Code);
                                            EmployeeQuantitativeGoal.SETRANGE("Appraisal Year", "Appraisal Year");
                                            IF NOT EmployeeQuantitativeGoal.FINDFIRST THEN BEGIN
                                                EmployeeQuantitativeGoal.INIT;
                                                EmployeeQuantitativeGoal."Contract No." := PerformanceContract."Contract No.";
                                                EmployeeQuantitativeGoal."Employee No." := "Employee No.";
                                                EmployeeQuantitativeGoal."Employee Name" := "Employee Name";
                                                EmployeeQuantitativeGoal.Code := QuantitativeGoal.Code;
                                                EmployeeQuantitativeGoal.Description := QuantitativeGoal.Description;
                                                EmployeeQuantitativeGoal."Percentage Weighting" := QuantitativeGoal.Percentage;
                                                EmployeeQuantitativeGoal."Appraisal Year" := "Appraisal Year";
                                                EmployeeQuantitativeGoal.Original := TRUE;
                                                EmployeeQuantitativeGoal.INSERT(TRUE);
                                            END;
                                        END;
                                    END;
                                UNTIL QuantitativeGoal.NEXT = 0;
                            END;
                        END;

                        IF HumanResourcesSetup."Use Qualitative Goals" THEN BEGIN
                            QualitativeGoal.RESET;
                            IF QualitativeGoal.FINDSET THEN BEGIN
                                REPEAT
                                    EmployeeQualitativeGoal.INIT;
                                    EmployeeQualitativeGoal."Contract No." := "Contract No.";
                                    EmployeeQualitativeGoal."Employee No." := "Employee No.";
                                    EmployeeQualitativeGoal."Employee Name" := "Employee Name";
                                    EmployeeQualitativeGoal.Code := QualitativeGoal.Code;
                                    EmployeeQualitativeGoal.Description := QualitativeGoal.Description;
                                    EmployeeQualitativeGoal."Percentage Weighting" := QualitativeGoal.Percentage;
                                    EmployeeQualitativeGoal."Appraisal Year" := "Appraisal Year";
                                    EmployeeQualitativeGoal.Original := TRUE;
                                    EmployeeQualitativeGoal.INSERT(TRUE);
                                UNTIL QualitativeGoal.NEXT = 0;
                            END;
                        END;
                    END;
                end;

                procedure CreateAppraisalEntries2(var PerformanceContract: Record "50264"; Period: Code[10]);
                var
                    AppraisalPeriod: Record "50260";
                    EmployeeQuantitativeGoal: Record "50265";
                    EmployeeQualitativeGoal: Record "50266";
                    EmployeeQuantitativeGoal2: Record "50265";
                    EmployeeQualitativeGoal2: Record "50266";
                    QuantitativeGoal: Record "50262";
                    QualitativeGoal: Record "50263";
                    AppraisalYear: Integer;
                    ActionPlan: Record "50272";
                    ActionPlan2: Record "50272";
                begin
                    WITH PerformanceContract DO BEGIN
                        QuantitativeGoal.RESET;
                        IF QuantitativeGoal.FINDSET THEN BEGIN
                            REPEAT
                                EmployeeQuantitativeGoal2.RESET;
                                EmployeeQuantitativeGoal2.SETRANGE("Appraisal Year", "Appraisal Year");
                                EmployeeQuantitativeGoal2.SETRANGE(Code, QuantitativeGoal.Code);
                                IF EmployeeQuantitativeGoal2.FINDFIRST THEN BEGIN
                                    EmployeeQuantitativeGoal.INIT;
                                    EmployeeQuantitativeGoal."Contract No." := "Contract No.";
                                    EmployeeQuantitativeGoal."Employee No." := "Employee No.";
                                    EmployeeQuantitativeGoal."Employee Name" := "Employee Name";
                                    EmployeeQuantitativeGoal.Code := QuantitativeGoal.Code;
                                    EmployeeQuantitativeGoal.Description := QuantitativeGoal.Description;
                                    EmployeeQuantitativeGoal."Appraisal Year" := "Appraisal Year";
                                    EmployeeQuantitativeGoal."Appraisal Period" := Period;
                                    EmployeeQuantitativeGoal."Percentage Weighting" := EmployeeQuantitativeGoal2."Percentage Weighting";
                                    EmployeeQuantitativeGoal.INSERT(TRUE);
                                END;
                            UNTIL QuantitativeGoal.NEXT = 0;
                        END;

                        QualitativeGoal.RESET;
                        IF QualitativeGoal.FINDSET THEN BEGIN
                            REPEAT
                                EmployeeQualitativeGoal2.RESET;
                                EmployeeQualitativeGoal2.SETRANGE("Appraisal Year", "Appraisal Year");
                                EmployeeQualitativeGoal2.SETRANGE(Code, QualitativeGoal.Code);
                                IF EmployeeQualitativeGoal2.FINDFIRST THEN BEGIN
                                    EmployeeQualitativeGoal.INIT;
                                    EmployeeQualitativeGoal."Contract No." := "Contract No.";
                                    EmployeeQualitativeGoal."Employee No." := "Employee No.";
                                    EmployeeQualitativeGoal."Employee Name" := "Employee Name";
                                    EmployeeQualitativeGoal.Code := QualitativeGoal.Code;
                                    EmployeeQualitativeGoal.Description := QualitativeGoal.Description;
                                    EmployeeQualitativeGoal."Appraisal Year" := "Appraisal Year";
                                    EmployeeQualitativeGoal."Appraisal Period" := Period;
                                    EmployeeQualitativeGoal."Percentage Weighting" := EmployeeQualitativeGoal2."Percentage Weighting";
                                    EmployeeQualitativeGoal.INSERT(TRUE);
                                END;
                            UNTIL QualitativeGoal.NEXT = 0;
                        END;

                        ActionPlan.RESET;
                        ActionPlan.SETRANGE("Contract No.", "Contract No.");
                        IF ActionPlan.FINDSET THEN BEGIN
                            REPEAT
                            UNTIL ActionPlan.NEXT = 0;
                        END;

                    END;
                end;

                procedure UpdateTerminalDues(HRSeparation: Record "50237");
                var
                    LookupTableLine: Record "50267";
                begin
                    WITH HRSeparation DO BEGIN
                        Total := "Pay for Outstanding Leave Days" + "Salary(Full Month)" + "Salary(Extra Days)" + "Leave Alowance Paid" + "Car Allowance" + "Golden Handshake" + "Transport Allowance" + "Severence Pay" + "Car Allowance(Months)";
                        "PAYE Due" := 0;

                        LookupTableLine.RESET;
                        LookupTableLine.SETRANGE("Table ID", 'PAYE');
                        LookupTableLine.SETFILTER("Lower Amount (LCY)", '<%1', Total);
                        IF LookupTableLine.FINDSET THEN BEGIN
                            REPEAT
                                IF LookupTableLine."Upper Amount (LCY)" < Total THEN BEGIN

                                    "PAYE Due" += LookupTableLine."Relief Amount";

                                END;
                                IF LookupTableLine."Upper Amount (LCY)" > Total THEN BEGIN
                                    "PAYE Due" := "PAYE Due" + (((Total - LookupTableLine."Lower Amount (LCY)") * LookupTableLine.Percent) / 100);
                                END;
                            UNTIL LookupTableLine.NEXT = 0;
                        END;
                        LookupTableLine.RESET;
                        LookupTableLine.SETRANGE("Table ID", 'RELIEF');
                        IF LookupTableLine.FINDFIRST THEN BEGIN
                            "PAYE Due" := "PAYE Due" - LookupTableLine."Extract Amount (LCY)";
                        END;

                        "Total after PAYE" := Total - "PAYE Due";
                        "Amount Payable" := "Total after PAYE" - "Amount In Lieu of Notice" - "Total Deductions";

                    END;
                end;*/

    procedure CreateAuditTrail(var Employee: Record 5200);
    var
        ApprovalEntry: Record 454;
        WorkflowRecordChange: Record 1525;
        RecRef: RecordRef;
        EmployeeHRAuditTrail: Record 50245;
    begin
        WITH Employee DO BEGIN
            EmployeeHRAuditTrail.INIT;
            EmployeeHRAuditTrail."User ID" := USERID;
            EmployeeHRAuditTrail.Type := EmployeeHRAuditTrail.Type::Change;
            EmployeeHRAuditTrail."Employee No" := "No.";
            EmployeeHRAuditTrail."Employee Name" := Employee.FullName;
            EmployeeHRAuditTrail."Change Date" := TODAY;
            EmployeeHRAuditTrail."Change Time" := TIME;
            EmployeeHRAuditTrail.Status := EmployeeHRAuditTrail.Status::"Approval Pending";
            EmployeeHRAuditTrail.INSERT(TRUE);
        END;
    end;

    procedure UpdateAuditTrail(WorkflowStepInstance: Record 1504; Stage: Integer);
    var
        ApprovalEntry: Record 454;
        WorkflowRecordChange: Record 1525;
        RecRef: RecordRef;
        EmployeeHRAuditTrail: Record 50245;
        Employee: Record 5200;
    begin
        WITH WorkflowStepInstance DO BEGIN
            WorkflowRecordChange.RESET;
            WorkflowRecordChange.SETRANGE("Workflow Step Instance ID", ID);
            IF WorkflowRecordChange.FINDFIRST THEN BEGIN
                EmployeeHRAuditTrail.RESET;
                EmployeeHRAuditTrail.SETRANGE("User ID", USERID);
                EmployeeHRAuditTrail.SETRANGE("Change Date", TODAY);
                IF EmployeeHRAuditTrail.FINDLAST THEN BEGIN
                    WorkflowRecordChange.CALCFIELDS("Field Caption");
                    EmployeeHRAuditTrail."Field Caption" := WorkflowRecordChange."Field Caption";
                    EmployeeHRAuditTrail."Old Value" := WorkflowRecordChange."Old Value";
                    EmployeeHRAuditTrail."New Value" := WorkflowRecordChange."New Value";
                    CASE Stage OF
                        1:
                            BEGIN
                                EmployeeHRAuditTrail.Status := EmployeeHRAuditTrail.Status::Approved;
                                EmployeeHRAuditTrail."Approval Date" := TODAY;
                                EmployeeHRAuditTrail."Approval Time" := TIME;
                                EmployeeHRAuditTrail.Approver := USERID;
                            END;
                        2:
                            BEGIN
                                EmployeeHRAuditTrail.Status := EmployeeHRAuditTrail.Status::Rejected;
                                EmployeeHRAuditTrail."Approval Date" := TODAY;
                                EmployeeHRAuditTrail."Approval Time" := TIME;
                                EmployeeHRAuditTrail.Approver := USERID;
                            END;
                    END;
                    EmployeeHRAuditTrail.MODIFY(TRUE);
                END;
            END;
        END;
    end;

    procedure UpdateSeparationInfo(HRSeparation: Record 50237);
    var
        Employee: Record 5200;
        TEXT111: Label '%1%2 has been separated successfully.';
    begin
        WITH HRSeparation DO BEGIN
            IF CONFIRM(TEXT007) THEN BEGIN
                TESTFIELD(Completed);
                TESTFIELD("Separation Type");
                TESTFIELD("Reason for Separation");
                IF "Separation Status" = "Separation Status"::New THEN BEGIN
                    "Separation Status" := "Separation Status"::Processed;
                    Status := Status::Approved;
                    IF Employee.GET("Employee No.") THEN;
                    Employee.Status := Employee.Status::Terminated;
                    Employee.MODIFY;
                    IF MODIFY(TRUE) THEN BEGIN
                        MESSAGE(TEXT111, "Separation No", "Employee Name");
                    END;
                END;
            END;
        END;
    end;

    procedure "Shortlist Applicants"(RecruitmentCode: Code[10]);
    var
        JobApplications: Record 50277;
        RecruitmentRequest: Record 50246;
    begin
        IF RecruitmentRequest.GET(RecruitmentCode) THEN BEGIN
            JobApplications.RESET;
            JobApplications.SETRANGE("Recruitment Request No.", RecruitmentCode);
            JobApplications.SETFILTER("No. Years of Experience", '>=%1', RecruitmentRequest."No. of Years of Experience");
            JobApplications.SETFILTER("Level of Education", RecruitmentRequest."Level of Education");
            IF JobApplications.FINDSET THEN BEGIN
                REPEAT
                    JobApplications.Status := JobApplications.Status::Shortlisted;
                    JobApplications.MODIFY;
                UNTIL JobApplications.NEXT = 0;
                MESSAGE(TEXT006);
            END;
        END;
    end;
    /*
                      procedure ConfirmationMail(var Employee: Record 5200);
                      var
                          Text000: Label '%1 Confirmation Letter.pdf';
                          Text001: Label 'C:\Program Files\Microsoft Dynamics NAV\100\Web Client\Pics\';
                          ConfirmationLetter: Report 50286;
                          FileName: Text;
                          Text002: Label 'CONFIMATION LETTER';
                          Text003: Label 'Dear %1, </br>We are glad to inform you that you have been successfully confirmed upon successful completion of your probation period. </br>Please find the attached document with the details of your confirmation.</br>Kind Regards,';
                      begin
                          WITH Employee DO BEGIN
                              CLEARLASTERROR;
                              HumanResourcesSetup.GET;
                              CLEAR(ConfirmationLetter);
                              ConfirmationLetter.USEREQUESTPAGE(FALSE);
                              FileName := HumanResourcesSetup."File Path" + STRSUBSTNO(Text000, Employee.FullName);
                              IF ConfirmationLetter.SAVEASPDF(FileName) THEN BEGIN
                                  SendMail(Employee."E-Mail", Text002, STRSUBSTNO(Text003, Employee.FullName), Text002, FileName);
                              END ELSE
                                  MESSAGE(GETLASTERRORTEXT);
                          END;
                      end;

                      procedure ExtensionMail(var Employee: Record 5200);
                      begin
                      end;
          */
    procedure CloseAppraisalPeriod();
    var
        Text000: Label 'Are you sure you want to close appraisal period %1 %2?';
        Text001: Label 'Appraisal Period %1 %2 has been closed successfully';
        AppraisalPeriod: Record 50260;
    begin
        AppraisalPeriod.RESET;
        AppraisalPeriod.SETRANGE(Active, TRUE);
        IF AppraisalPeriod.FINDFIRST THEN BEGIN
            IF CONFIRM(STRSUBSTNO(Text000, AppraisalPeriod.Code, AppraisalPeriod.Year)) THEN BEGIN
                AppraisalPeriod.Active := FALSE;
                AppraisalPeriod.Closed := TRUE;
                AppraisalPeriod.MODIFY;
                MESSAGE(STRSUBSTNO(Text001, AppraisalPeriod.Code, AppraisalPeriod.Year));
            END;
        END;
    end;

    procedure FetchJobCompetencyLines(var EmployeeNo: code[20]; var EmpPosition: Text; var Period: code[30]; var ReviewNo: Code[20]);
    var
        JobCompetencyHeader: Record 50284;
        JobCompetencyLine: Record 50285;
        PerformanceCompetencyLine: Record 50287;
    begin
        // WITH PerformanceReviewHeader DO BEGIN
        JobCompetencyHeader.RESET;
        //  JobCompetencyHeader.SETRANGE("Appraisal Period", Period);
        // JobCompetencyHeader.SETRANGE("Job Description", EmpPosition);
        IF JobCompetencyHeader.FINDFIRST THEN BEGIN
            //    MESSAGE('%1\%2', EmpPosition, Period);
            JobCompetencyLine.RESET;
            //   JobCompetencyLine.SETRANGE("Entry No.", JobCompetencyHeader."Entry No.");
            IF JobCompetencyLine.FINDSET THEN BEGIN
                REPEAT
                    PerformanceCompetencyLine.INIT;
                    PerformanceCompetencyLine.Period := Period;
                    PerformanceCompetencyLine."Employee No." := EmployeeNo;
                    PerformanceCompetencyLine."Review No." := ReviewNo;
                    PerformanceCompetencyLine.Code := JobCompetencyLine."Performance Competency Code";
                    PerformanceCompetencyLine.VALIDATE(Code);
                    PerformanceCompetencyLine.INSERT;
                UNTIL JobCompetencyLine.NEXT = 0;
            END;
        END;
    END;
    //   end;
}