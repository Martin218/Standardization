codeunit 50100 "Registry Management2"
{
    // version TL2.0

    // z


    trigger OnRun();
    begin
    end;

    procedure CreateNewFile(RegistryFile: Record "Registry File");
    var
        FileVolume: Record "File Volume";
        RegistryFileNumber: Record "Registry File Number";
        UserSetup: Record "User Setup";
        TEXT001: Label 'Are you sure you want to add the file to the registry?';
        TEXT002: Label 'File Successfully Created.';
        TEXT003: Label 'File has already been created.';
        TEXT004: Label 'You are not allowed to create this file.';
    begin
        WITH RegistryFile DO BEGIN
            TESTFIELD(Location1);
            TESTFIELD("File Number");
            TESTFIELD("Member No.");
            TESTFIELD("File Location");
            UserSetup.GET(USERID);
            //IF UserSetup."Registry User" = TRUE THEN BEGIN
            IF CONFIRM(TEXT001) THEN BEGIN

                RegistryFileNumber.INIT;
                RegistryFileNumber."No." := "File No.";
                RegistryFileNumber."File Number" := "File Number";
                RegistryFileNumber.Date := CURRENTDATETIME;
                RegistryFileNumber."File Status" := "RegFile Status";
                RegistryFileNumber."Changed By" := USERID;
                RegistryFileNumber.INSERT;
                FileVolume.INIT;
                FileVolume.No := "File No.";
                FileVolume.Volume := Volume;
                FileVolume."File Number" := "File Number";
                FileVolume."File Location" := "File Location";
                FileVolume."Date Created" := TODAY;
                FileVolume.MemberNo := "Member No.";
                FileVolume."Created By" := USERID;

                FileVolume.INSERT;

                IF Created <> TRUE THEN BEGIN
                    Created := TRUE;
                    "Created By" := USERID;
                    MODIFY;
                    MESSAGE(TEXT002);
                END ELSE BEGIN
                    MESSAGE(TEXT003);
                END;
            END;

            //END ELSE BEGIN
            //ERROR(TEXT004);
            //END;


        END;
    end;

    procedure SendFileRequest(FileIssuance: Record "File Issuance");
    var
        RegistryFilesLine: Record "Registry Files Line";
        RegistryFile: Record "Registry File";
        UserSetup: Record "User Setup";
        TEXT001: Label 'Please select a file.';
        TEXT002: Label 'Are you sure you want to send the file request?';
        TEXT003: Label 'Request sent to Registry.';
        TEXT004: Label 'Request sent to Registry.';
        TEXT005: Label 'Email Sent.';
        TEXT006: Label 'NOTIFICATION OF FILE REQUESTED';
        TEXT007: Label '''Dear Registry <br><br>''';
        smtprec: Record "SMTP Mail Setup";
        smtpcu: Codeunit "SMTP Mail";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegistrySetUp: Record "Registry SetUp";
        TransferFilesLine: Record "Transfer Files Line";
        TEXT008: Label '''Please Note that the following file(s) have been requested under request ID: <b>''';
        TEXT009: Label '''by ''';
        TEXT010: Label '''</b> <br><br>''';
        TEXT011: Label ''' File No: <b>''';
        TEXT012: Label '''</b> File Name <b> ''';
        TEXT013: Label '''</b> Member No. <b>''';
        TEXT014: Label '''</b> ID No. <b>''';
        TEXT015: Label '''</b> <br><br>''';
        TEXT016: Label '''Please confirm the availability of the files <br><br>''';
        TEXT017: Label '''Kind Regards<br><br>''';
        TEXT018: Label '''<i>Registry</i><bt><br>''';
        TEXT019: Label '''Registry Request''';
    begin
        WITH FileIssuance DO BEGIN
            TESTFIELD(Reason);
            TESTFIELD("Duration Required(Days)");

            RegistryFilesLine.RESET;
            RegistryFilesLine.SETRANGE("Request ID", FileIssuance."Request ID");
            IF NOT RegistryFilesLine.FIND('-') THEN BEGIN
                ERROR(TEXT001);
            END;

            IF CONFIRM(TEXT002) THEN BEGIN

                IF "Request Status" = "Request Status"::New THEN BEGIN
                    "Request Status" := "Request Status"::"Pending Approval";
                    RegistryFilesLine."Request ID" := FileIssuance."Request ID";
                    RegistryFilesLine."Requisition By" := FileIssuance."Requisiton By";
                    RegistryFilesLine.Status2 := RegistryFilesLine.Status2::Active;
                    MODIFY;
                    MESSAGE(TEXT003)
                END ELSE BEGIN
                    ERROR(TEXT004);
                END;

                RegistryFilesLine.RESET;
                RegistryFilesLine.SETRANGE("Request ID", FileIssuance."Request ID");
                IF RegistryFilesLine.FIND('-') THEN BEGIN
                    REPEAT
                        IF RegistryFilesLine.Status2 = RegistryFilesLine.Status2::New THEN BEGIN
                            RegistryFilesLine.Status2 := RegistryFilesLine.Status2::Active;
                            RegistryFilesLine."Request ID" := FileIssuance."Request ID";
                            RegistryFilesLine."Requisition By" := FileIssuance."Requisiton By";
                            RegistryFilesLine.Status2 := RegistryFilesLine.Status2::Active;
                            RegistryFilesLine.MODIFY;
                        END;
                    UNTIL
                      RegistryFilesLine.NEXT = 0;
                END;


                UserSetup.RESET;
                UserSetup.GET("Requisiton By");
                RegistrySetUp.RESET;
                RegistrySetUp.GET;
                mailheader := TEXT006;
                mailbody := TEXT007;
                mailbody := mailbody + TEXT008 + "Request ID" + TEXT009 + "Requisiton By" + TEXT010;
                RegistryFilesLine.RESET;
                RegistryFilesLine.SETRANGE("Request ID", "Request ID");
                IF RegistryFilesLine.FINDSET THEN BEGIN
                    REPEAT
                        mailbody := mailbody + TEXT011 + RegistryFilesLine."File Number" + TEXT012 + RegistryFilesLine."File Name" + TEXT013 + RegistryFilesLine."Member No." + TEXT014 + RegistryFilesLine."ID No." + TEXT015;
                    UNTIL
                     RegistryFilesLine.NEXT = 0;
                END;
                mailbody := mailbody + TEXT016;
                mailbody := mailbody + TEXT017;
                mailbody := mailbody + TEXT018;
                smtprec.RESET;
                smtprec.GET;
                //smtpcu.CreateMessage(TEXT019,smtprec."User ID",RegistrySetUp."Registry Email",mailheader,mailbody,TRUE);
                //smtpcu.AddBCC(UserSetup."E-Mail");
                smtpcu.Send;
                bddialog.CLOSE;
                MESSAGE(TEXT005);
            END;
        END;

    end;

    procedure TransferFile(TransferFilesLine: Record "Transfer Files Line");
    var
        TransferRegistryFile: Record "Transfer Registry File";
        RegistrySetUp: Record "Registry SetUp";
        TEXT001: Label 'Are you sure you want to transfer this file?';
        NoSeriesManagement: Codeunit NoSeriesManagement;
        FileReturn: Record "File Return";
    begin
        WITH TransferFilesLine DO BEGIN

            IF CONFIRM(TEXT001) THEN BEGIN

                TransferRegistryFile.INIT;
                TransferRegistryFile."Transfer ID" := '';
                RegistrySetUp.GET();
                RegistrySetUp.TESTFIELD("Transfer ID");
                NoSeriesManagement.InitSeries(RegistrySetUp."Transfer ID", TransferRegistryFile."No. Series", 0D, TransferRegistryFile."Transfer ID", TransferRegistryFile."No. Series");
                MESSAGE('%1', TransferRegistryFile."Transfer ID");
                TransferRegistryFile."Released From" := USERID;
                TransferRegistryFile."Time Released" := CURRENTDATETIME;
                TransferRegistryFile.Status := TransferRegistryFile.Status::New;
                TransferRegistryFile.INSERT;
                TransferRegistryFile.VALIDATE("Transfer ID");



                TransferFilesLine.INIT;
                TransferFilesLine."Transfer ID" := TransferRegistryFile."Transfer ID";
                TransferFilesLine."File No" := "File No";
                TransferFilesLine."File Number" := "File Number";
                TransferFilesLine."Member No" := "Member No";
                TransferFilesLine."File Name" := "File Name";
                TransferFilesLine."Member No" := "Member No";
                TransferFilesLine."ID No" := "ID No";
                TransferFilesLine."Payroll No" := "Payroll No";
                TransferFilesLine."File Volume" := "File Volume";
                TransferFilesLine."Released From" := USERID;
                TransferFilesLine."Time Released" := CURRENTDATETIME;
                TransferFilesLine."Request ID" := "Request ID";
                TransferFilesLine.INSERT;
                PAGE.RUN(50980, TransferRegistryFile);
            END;
        END;
    end;

    procedure SendReturnNote(TransferFilesLine: Record "Transfer Files Line");
    var
        RegistrySetUp: Record "Registry SetUp";
        UserSetup: Record "User Setup";
        TEXT001: Label 'The file return note has already been sent.';
        TEXT002: Label 'Are you sure you want to return this file?';
        TEXT003: Label 'File Return.';
        TEXT004: Label 'File Return Note has been sent to registry under file return ID: %1';
        FileReturn: Record "File Return";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        WITH TransferFilesLine DO BEGIN
            UserSetup.GET(USERID);
            IF "SentRet Note" = TRUE THEN
                ERROR(TEXT001);
            IF CONFIRM(TEXT002) THEN BEGIN
                FileReturn.INIT;
                FileReturn."Return ID" := '';
                RegistrySetUp.GET();
                RegistrySetUp.TESTFIELD("Return ID");
                NoSeriesManagement.InitSeries(RegistrySetUp."Return ID", FileReturn."No. Series", 0D, FileReturn."Return ID", FileReturn."No. Series");
                FileReturn."Return Date" := CURRENTDATETIME;
                FileReturn."Staff Name" := USERID;
                FileReturn.Remarks := TEXT003;
                FileReturn."File Return Status" := FileReturn."File Return Status"::"Pending Acceptance";
                FileReturn."Branch Code" := UserSetup."Global Dimension 1 Code";
                FileReturn.Posted := TRUE;
                FileReturn."Request ID" := "Request ID";
                FileReturn.INSERT;
                FileReturn.VALIDATE("Return ID");

                TransferFilesLine.RESET;
                TransferFilesLine.SETFILTER("Transfer ID", "Transfer ID");
                IF TransferFilesLine.FINDFIRST THEN BEGIN
                    TransferFilesLine."SentRet Note" := TRUE;
                    TransferFilesLine.MODIFY;
                    COMMIT;
                END;

                TransferFilesLine.INIT;
                TransferFilesLine."Transfer ID" := FileReturn."Return ID";
                TransferFilesLine."File No" := "File No";
                TransferFilesLine."File Number" := "File Number";
                TransferFilesLine."Member No" := "Member No";
                TransferFilesLine."File Name" := "File Name";
                TransferFilesLine."Member No" := "Member No";
                TransferFilesLine."ID No" := "ID No";
                TransferFilesLine."Payroll No" := "Payroll No";
                TransferFilesLine."File Volume" := "File Volume";
                TransferFilesLine."Released From" := USERID;
                TransferFilesLine."Time Released" := CURRENTDATETIME;
                TransferFilesLine."Request ID" := "Request ID";
                TransferFilesLine."SentRet Note" := TRUE;
                TransferFilesLine."Carried By" := "Received By";
                TransferFilesLine."Due Date" := "Due Date";
                TransferFilesLine."File Type" := "File Type";
                TransferFilesLine.INSERT;
                MESSAGE(TEXT004, FileReturn."Return ID");

            END;

        END;
    end;

    procedure SubmitInterBranchTransfer(FileMovement: Record "File Movement");
    var
        UserSetup: Record "User Setup";
        smtprec: Record "SMTP Mail Setup";
        smtpcu: Codeunit "SMTP Mail";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegistrySetUp: Record "Registry SetUp";
        TEXT001: Label 'You can only transfer files between different locations. Kindly select a different To Location.';
        TEXT002: Label 'Are you sure you want to submit the file request?';
        TEXT003: Label 'Request Submitted for Approval.';
        TEXT004: Label 'Sending email to registry.';
        TEXT005: Label 'NOTIFICATION OF FILE MOVEMENT REQUESTED.';
        TEXT006: Label '''Dear Registry <br><br>''';
        TEXT007: Label '''Please Note that the following file(s) have been requested for transfer under request ID: <b>''';
        TEXT008: Label '"''</b> <br><br>'';"';
        TEXT009: Label '''<b> File No:''';
        TEXT010: Label '''Please confirm the availability of the files <br><br>''';
        TEXT011: Label '''Kind Regards<br><br>''';
        TEXT012: Label '''<i>Registry</i><bt><br>''';
        TEXT013: Label '''Registry Request''';
    //TEXT014: ;
    begin
        WITH FileMovement DO BEGIN
            TESTFIELD("Request Remarks");
            IF "From Location" = "To Location" THEN BEGIN
                MESSAGE(TEXT001);
            END;
            IF CONFIRM(TEXT002) THEN BEGIN

                IF Status = Status::New THEN
                    Status := Status::"Approval Pending";
                MODIFY;
                MESSAGE(TEXT003);
            END;
            RegistrySetUp.RESET;
            mailheader := TEXT005;
            mailbody := TEXT006;
            mailbody := mailbody + TEXT007 + "File Movement ID" + TEXT008;
            mailbody := mailbody + TEXT009 + "File Number" + ' ' + "File Name" + TEXT008;
            mailbody := mailbody + TEXT010;
            mailbody := mailbody + TEXT011;
            mailbody := mailbody + TEXT012;
            smtprec.RESET;
            smtprec.GET;
            //smtpcu.CreateMessage(TEXT013,smtprec."User ID",RegistrySetUp."Registry Email",mailheader,mailbody,TRUE);
            smtpcu.Send;



        END;

    end;

    procedure ApproveFileTransfer(FileMovement: Record "File Movement");
    var
        UserSetup: Record "User Setup";
        TEXT001: Label 'Are you sure you want to Approve the file request?';
        TEXT002: Label 'Request Approved and Ready for Transfer';
        TEXT003: Label 'You are not a registry approver.';
    begin
        WITH FileMovement DO BEGIN
            UserSetup.GET(USERID);
            TESTFIELD("Approval/Rejection Remarks");
            IF UserSetup."Registry Approver" = TRUE THEN BEGIN
                IF CONFIRM(TEXT001) THEN BEGIN
                    IF Status = Status::"Approval Pending" THEN
                        Status := Status::"Ready For Transfer";
                    MODIFY;
                    MESSAGE(TEXT002);
                    "Approved Date" := CURRENTDATETIME;
                END;
            END ELSE BEGIN
                MESSAGE(TEXT003);
            END;


        END;
    end;

    procedure RejectFileTransfer(FileMovement: Record "File Movement");
    var
        UserSetup: Record "User Setup";
        TEXT001: Label 'Are you sure you want to Reject the file request?';
        TEXT002: Label 'Request Rejected.';
    begin
        WITH FileMovement DO BEGIN
            UserSetup.GET(USERID);
            IF UserSetup."Registry Approver" = TRUE THEN BEGIN
                IF CONFIRM(TEXT001) THEN BEGIN
                    IF Status = Status::"Approval Pending" THEN
                        Status := Status::Rejected;
                    MODIFY;
                    MESSAGE(TEXT002);
                END;
            END;
        END;
    end;

    procedure DispatchFile(FileMovement: Record "File Movement");
    var
        UserSetup: Record "User Setup";
        TEXT001: Label 'Are you sure you want to Dispatch File.';
        TEXT002: Label 'File Dispatched.';
        TEXT003: Label 'Sending email to file requester.';
        TEXT004: Label 'Email Sent.';
        TEXT005: Label '''NOTIFICATION OF FILE MOVEMENT APPROVED AND DISPATCHED''';
        smtprec: Record "SMTP Mail Setup";
        smtpcu: Codeunit "SMTP Mail";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegistrySetUp: Record "Registry SetUp";
        TEXT006: Label '''Dear''';
        TEXT007: Label ''' <br><br>''';
        TEXT008: Label '''Please Note that the following file(s) have been requested for transfer under request ID: <b>''';
        TEXT009: Label '''</b>have been approved and dipatched. <br><br>''';
        TEXT010: Label '''<b> File No:''';
        TEXT011: Label '''</b> <br><br>''';
        TEXT012: Label '''Released by:''';
        TEXT013: Label ''' <br><br>''';
        TEXT014: Label '''Carried by:''';
        TEXT015: Label ''' <br><br>''';
        TEXT016: Label '''Kind Regards<br><br>''';
        TEXT017: Label '''<i>Registry</i><bt><br>''';
        TEXT018: Label '''Registry Request''';
    begin
        WITH FileMovement DO BEGIN
            UserSetup.GET(USERID);
            TESTFIELD("Released To");
            IF CONFIRM(TEXT001) THEN BEGIN
                IF Status = Status::"Ready For Transfer" THEN
                    Status := Status::Dispatched;
                MODIFY;
                MESSAGE(TEXT002);

                "Released By" := USERID;
                "Date Released" := CURRENTDATETIME;
                UserSetup.GET("Requested By");
                RegistrySetUp.RESET;
                RegistrySetUp.GET;
                mailheader := TEXT005;
                mailbody := TEXT006 + "Requested By" + TEXT007;
                mailbody := mailbody + TEXT008 + "File Movement ID" + TEXT009;
                mailbody := mailbody + TEXT010 + "File Number" + ' ' + "File Name" + TEXT011;
                mailbody := mailbody + TEXT012 + "Released By" + TEXT013;
                mailbody := mailbody + TEXT014 + "Carried By" + TEXT015;
                mailbody := mailbody + TEXT016;
                mailbody := mailbody + TEXT017;
                smtprec.RESET;
                smtprec.GET;
                //smtpcu.CreateMessage(TEXT018,smtprec."User ID",UserSetup."E-Mail",mailheader,mailbody,TRUE);
                IF RegistrySetUp."Registry Email" <> '' THEN BEGIN
                    //smtpcu.AddCC(RegistrySetUp."Registry Email");
                END;
                smtpcu.Send;

                MESSAGE(TEXT004);
            END;
        END;

    end;

    procedure ReceiveFile(FileMovement: Record "File Movement");
    var
        RegistryFile: Record "Registry File";
        DimensionValue: Record "Dimension Value";
        TransferFilesLine: Record "Transfer Files Line";
        UserSetup: Record "User Setup";
        branch: Code[50];
        branchname: Text[20];
        branchName2: Text;
        TEXT001: Label 'You cannot receive this file!';
        TEXT002: Label 'Are you sure you want to Receive File.';
        TEXT003: Label 'File Received.';
    begin
        WITH FileMovement DO BEGIN
            UserSetup.GET(USERID);
            IF "Released To" <> USERID THEN BEGIN
                ERROR(TEXT001);
            END;

            IF CONFIRM(TEXT002) THEN BEGIN
                IF Status = Status::Dispatched THEN BEGIN
                    Status := Status::Received;
                    "Received By" := USERID;
                    Received := TRUE;
                    MODIFY;
                    MESSAGE(TEXT003);
                END;
                RegistryFile.RESET;
                RegistryFile.SETRANGE("Member No.", "Member No");
                IF RegistryFile.FINDFIRST THEN BEGIN
                    DimensionValue.RESET;
                    DimensionValue.SETRANGE("Global Dimension No.", 1);
                    IF DimensionValue.FIND('-') THEN BEGIN
                        branch := DimensionValue.Code;
                        RegistryFile.Location1 := branch;
                        RegistryFile.MODIFY;
                        RegistryFile.NewFileNumber(branch, RegistryFile."RegFile Status");
                        "File Number" := RegistryFile."File Number";
                        RegistryFile.MODIFY;
                    END;
                END;



                TransferFilesLine.INIT;
                TransferFilesLine."Transfer ID" := "File Movement ID";
                TransferFilesLine."File No" := "File No.";
                TransferFilesLine."File Number" := "File Number";
                TransferFilesLine."File Name" := "File Name";
                TransferFilesLine."Member No" := "Member No";
                TransferFilesLine."ID No" := "ID No";
                TransferFilesLine."Payroll No" := "Payroll No";
                TransferFilesLine."File Volume" := Volume;
                TransferFilesLine."Released From" := "Released By";
                TransferFilesLine."Time Released" := "Date Released";
                TransferFilesLine."Released To" := "Received By";
                TransferFilesLine."Time Received" := CURRENTDATETIME;
                RegistryFile.RESET;
                RegistryFile.SETRANGE("Member No.", "Member No");
                IF RegistryFile.FINDFIRST THEN BEGIN
                    TransferFilesLine."Request ID" := RegistryFile."Request ID";
                END;
                TransferFilesLine.Returned := TRUE;
                TransferFilesLine.INSERT;

            END;
        END;
    end;

    procedure AvailFileForPickup(FileIssuance: Record "File Issuance");
    var
        RegistryFile: Record "Registry File";
        UserSetup: Record "User Setup";
        RegistryFilesLine: Record "Registry Files Line";
        smtprec: Record "SMTP Mail Setup";
        smtpcu: Codeunit "SMTP Mail";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegistrySetUp: Record "Registry SetUp";
        TEXT001: Label 'Are you sure you want to release the file for pickup?';
        TEXT002: Label 'You have not approved any file request.';
        TEXT003: Label '"This file has already been issued to %1 "';
        TEXT004: Label 'File Is Ready for PickUp.';
        TEXT005: Label 'Registry,';
        TEXT006: Label '''NOTIFICATION TO PICK UP FILE REQUESTED''';
        TEXT007: Label '''Dear ''';
        TEXT008: Label ''',<br><br>''';
        TEXT009: Label '''Please Note that the file(s) that you requested for under request ID: <b>''';
        TEXT010: Label '''</b> are ready for pickup.<br><br>''';
        TEXT011: Label ''' File No: <b>''';
        TEXT012: Label '''</b> File Name <b> ''';
        TEXT013: Label '''</b> Member No. <b>''';
        TEXT014: Label '''</b> ID No. <b>''';
        TEXT015: Label '''</b> <br><br>''';
        TEXT016: Label '''<i>Registry</i><bt><br>''';
        TEXT017: Label '''Registry''';
    begin
        WITH FileIssuance DO BEGIN
            TESTFIELD(Remarks);
            IF CONFIRM(TEXT001) THEN BEGIN
                RegistryFilesLine.RESET;
                RegistryFilesLine.SETRANGE("Request ID", "Request ID");


                RegistryFilesLine.RESET;
                RegistryFilesLine.SETRANGE("Request ID", FileIssuance."Request ID");
                IF RegistryFilesLine.FINDSET THEN BEGIN
                    REPEAT
                        RegistryFile.RESET;
                        RegistryFile.SETRANGE("File Number", RegistryFilesLine."File Number");
                        RegistryFile.SETRANGE(Volume, RegistryFilesLine.Volume);
                        IF RegistryFile.FINDSET THEN BEGIN
                            IF RegistryFile.Issued = TRUE THEN BEGIN
                                ERROR(TEXT003, RegistryFile."Current User");
                                IF "Request Status" = "Request Status"::Active THEN
                                    "Request Status" := "Request Status"::"Ready For PickUp";
                                MODIFY;
                            END ELSE BEGIN
                                RegistryFile.Issued := TRUE;
                                RegistryFile."File Request Status" := RegistryFile."File Request Status"::"Issued Out";
                                RegistryFile."Current User" := "Requisiton By";
                                RegistryFile."Request ID" := "Request ID";
                                RegistryFile.MODIFY;
                            END;
                        END;
                        RegistryFilesLine."Released From" := TEXT005 + USERID;
                        RegistryFilesLine."Released To" := "Requisiton By";
                        RegistryFilesLine.MODIFY;
                    UNTIL RegistryFilesLine.NEXT = 0;
                END;

                "Issued Date" := CURRENTDATETIME;
                Issued := TRUE;
                MODIFY;
                MESSAGE(TEXT004);




                RegistryFilesLine.RESET;
                RegistryFilesLine.SETRANGE("Request ID", FileIssuance."Request ID");
                IF RegistryFilesLine.FIND('-') THEN BEGIN
                    REPEAT
                        IF RegistryFilesLine.Status2 = RegistryFilesLine.Status2::Active THEN BEGIN
                            RegistryFilesLine.Status2 := RegistryFilesLine.Status2::"Ready For PickUp";
                            RegistryFilesLine.MODIFY;
                        END;
                    UNTIL
                      RegistryFilesLine.NEXT = 0;
                END;

                UserSetup.RESET;
                UserSetup.GET("Requisiton By");
                mailheader := TEXT006;
                mailbody := TEXT007 + "Requisiton By" + TEXT008;
                mailbody := mailbody + TEXT009 + "Request ID" + TEXT010;
                RegistryFilesLine.RESET;
                RegistryFilesLine.SETRANGE("Request ID", "Request ID");
                RegistryFilesLine.SETRANGE("Registry Approval", TRUE);
                IF RegistryFilesLine.FINDSET THEN BEGIN
                    REPEAT
                        mailbody := mailbody + TEXT011 + RegistryFilesLine."File Number" + TEXT012 + RegistryFilesLine."File Name" + TEXT013 + RegistryFilesLine."Member No." + TEXT014 + RegistryFilesLine."ID No." + TEXT015;
                    UNTIL
                     RegistryFilesLine.NEXT = 0;
                END;
                mailbody := mailbody + TEXT016;
                smtprec.RESET;
                smtprec.GET;
                //smtpcu.CreateMessage(TEXT017, smtprec."User ID", UserSetup."E-Mail", mailheader, mailbody, TRUE);
                RegistrySetUp.RESET;
                RegistrySetUp.GET;
                IF RegistrySetUp."Registry Email" <> '' THEN BEGIN
                    //smtpcu.AddCC(RegistrySetUp."Registry Email");
                END;
                smtpcu.Send;

            END;

        END;
    end;

    procedure RejectFilePickup(FileIssuance: Record "File Issuance");
    var
        UserSetup: Record "User Setup";
        RegistrySetUp: Record "Registry SetUp";
        TransferFilesLine: Record "Transfer Files Line";
        RegistryFilesLine: Record "Registry Files Line";
        smtprec: Record "SMTP Mail Setup";
        smtpcu: Codeunit "SMTP Mail";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        TEXT001: Label 'Are you sure you want to reject file request?';
        TEXT002: Label 'Kindly fill in a rejection comment.';
        TEXT003: Label 'Request Rejected';
        TEXT004: Label 'Sending email to the file requester.';
        TEXT005: Label '''NOTIFICATION OF REJECTION FILE REQUESTED''';
        TEXT006: Label '''Dear ''';
        TEXT007: Label ''',<br><br>''';
        TEXT008: Label '''Please Note that the file(s) that you requested for under request ID: <b>''';
        TEXT009: Label '''</b> have been rejected.<br><br>''';
        TEXT010: Label ''' File No: <b>''';
        TEXT011: Label '''</b> File Name <b> ''';
        TEXT012: Label '''</b> Member No. <b>''';
        TEXT013: Label '''</b> ID No. <b>''';
        TEXT014: Label '''</b> <br><br>''';
        TEXT015: Label '''Reason ''';
        TEXT016: Label '''<br><br>''';
        TEXT017: Label '''<i>Registry</i><bt><br>''';
        TEXT018: Label '''Registry''';
    begin
        WITH FileIssuance DO BEGIN
            IF CONFIRM(TEXT001) THEN BEGIN
                TESTFIELD("Rejection Comment");
                MESSAGE(TEXT002);

                IF "Request Status" = "Request Status"::Active THEN
                    "Request Status" := "Request Status"::Rejected;
                MODIFY;
                MESSAGE(TEXT003);
                UserSetup.RESET;
                UserSetup.GET("Requisiton By");
                mailheader := TEXT005;
                mailbody := TEXT006 + "Requisiton By" + TEXT007;
                mailbody := mailbody + TEXT008 + "Request ID" + TEXT009;
                RegistryFilesLine.RESET;
                RegistryFilesLine.SETRANGE("Request ID", "Request ID");
                RegistryFilesLine.SETRANGE("Registry Rejected", TRUE);
                IF RegistryFilesLine.FINDSET THEN BEGIN
                    REPEAT
                        mailbody := mailbody + TEXT010 + RegistryFilesLine."File Number" + TEXT011 + RegistryFilesLine."File Name" + TEXT012 + RegistryFilesLine."Member No." + TEXT013 + RegistryFilesLine."ID No." + TEXT014;
                    UNTIL
                     RegistryFilesLine.NEXT = 0;
                END;
                mailbody := mailbody + TEXT015 + Remarks + TEXT016;
                mailbody := mailbody + TEXT017;
                smtprec.RESET;
                smtprec.GET;
                // smtpcu.CreateMessage(TEXT018, smtprec."User ID", UserSetup."E-Mail", mailheader, mailbody, TRUE);
                smtpcu.Send;


                RegistryFilesLine.RESET;
                RegistryFilesLine.SETRANGE("Request ID", FileIssuance."Request ID");
                IF RegistryFilesLine.FIND('-') THEN BEGIN
                    IF RegistryFilesLine.Status2 = RegistryFilesLine.Status2::Active THEN BEGIN
                        RegistryFilesLine.Status2 := RegistryFilesLine.Status2::Rejected;
                        RegistryFilesLine.Status2 := RegistryFilesLine.Status2::Rejected;
                        RegistryFilesLine.MODIFY;
                    END;
                END;
            END;



        END;
    end;

    procedure ReturnFile(FileReturn: Record "File Return");
    var
        TEXT001: Label 'Are you sure you want to return file to registry?';
        TEXT002: Label 'Return Notification sent to Registry.';
    begin
        WITH FileReturn DO BEGIN
            TESTFIELD(Remarks);
            IF CONFIRM(TEXT001) THEN BEGIN

                IF "File Return Status" = "File Return Status"::New THEN BEGIN
                    "File Return Status" := "File Return Status"::"Pending Acceptance";
                    MODIFY;
                END;

                IF Posted = FALSE THEN
                    Posted := TRUE;
                MODIFY;
                MESSAGE(TEXT002);

            END;
        END;
    end;

    procedure NotifyRegistry(FileIssuance: Record "File Issuance");
    var
        UserSetup: Record "User Setup";
        ApprovedRequests: Integer;
        RegistryFilesLine: Record "Registry Files Line";
        ApprovedDate: Date;
        ApprovedTime: Time;
        TEXT001: Label 'Are you sure you want to approve this file request?';
        TEXT002: Label 'Approved Requests have been sent to Registry for approval.';
        TEXT003: Label 'You have not approved any file request.';
        TEXT004: Label 'True';
    begin
        WITH FileIssuance DO BEGIN
            UserSetup.GET(USERID);
            TESTFIELD("Approval Comment");
            IF UserSetup.HOD = TRUE THEN BEGIN
                IF CONFIRM(TEXT001) THEN BEGIN
                    ApprovedRequests := RegistryFilesLine.COUNT;
                    ApprovedRequests := 0;
                    RegistryFilesLine.SETRANGE("Request ID", "Request ID");
                    RegistryFilesLine.SETFILTER("HOD Approval", TEXT004);
                    IF RegistryFilesLine.FINDLAST THEN BEGIN
                        REPEAT
                            ApprovedRequests := ApprovedRequests + 1;
                        UNTIL
                          RegistryFilesLine.NEXT = 0;
                    END;
                    IF ApprovedRequests > 0 THEN BEGIN
                        IF "Request Status" = "Request Status"::"Pending Approval" THEN BEGIN
                            "Request Status" := "Request Status"::Active;
                            "Approver ID" := USERID;
                            ApprovedDate := TODAY;
                            ApprovedTime := TIME;
                            "Approved Date" := CREATEDATETIME(ApprovedDate, ApprovedTime);
                            MESSAGE(TEXT002);
                            MODIFY;
                        END ELSE BEGIN
                            ERROR(TEXT003);
                        END;

                    END;
                END;
            END;

        end;
    end;

    procedure HODReject(FileIssuance: Record "File Issuance");
    var
        UserSetup: Record "User Setup";
        RegistryFilesLine: Record "Registry Files Line";
        TEXT001: Label 'Are you sure you want to reject this file request?';
        TEXT002: Label 'You have not approved any file request.';
        TEXT003: Label 'Request Rejected.';
        TEXT004: Label 'False';
        ApprovedRequests: Integer;
    begin

        WITH FileIssuance DO BEGIN
            UserSetup.GET(USERID);
            TESTFIELD("Approval Comment");
            IF UserSetup.HOD = TRUE THEN BEGIN
                IF CONFIRM(TEXT001) THEN BEGIN
                    ApprovedRequests := RegistryFilesLine.COUNT;
                    ApprovedRequests := 0;
                    RegistryFilesLine.SETRANGE("Request ID", "Request ID");
                    RegistryFilesLine.SETFILTER("HOD Approval", TEXT004);
                    IF RegistryFilesLine.FIND('-') THEN BEGIN

                        REPEAT
                            ApprovedRequests := ApprovedRequests + 1;
                        UNTIL
                          RegistryFilesLine.NEXT = 0;
                    END ELSE BEGIN
                        ERROR(TEXT002);
                    END;
                    IF ApprovedRequests = 0 THEN BEGIN
                        IF "Request Status" = "Request Status"::"Pending Approval" THEN
                            "Request Status" := "Request Status"::"Not Approved";
                        MESSAGE(TEXT003);
                        MODIFY;
                    END;

                END;
            END;
        END;
    end;

    procedure SaveBoardroomDetails(BoardroomDetail: Record "Boardroom Detail");
    var
        TEXT001: Label 'Do you want to register boardroom?';
        TEXT002: Label 'Boardroom Successfully added to boardroom Registry.';

    begin
        WITH BoardroomDetail DO BEGIN
            IF CONFIRM(TEXT001, FALSE) = TRUE THEN BEGIN
                TESTFIELD("Boardroom No");

                IF Register = FALSE THEN
                    Register := TRUE;
                MODIFY;
                MESSAGE(TEXT002);


            END;
        END;
    end;

    procedure BookBoardroom(BookingProcess: Record "Booking Process");
    var
        Employee: Record Employee;
        HODEmail: Text[80];
        smtpcu: Codeunit "SMTP Mail";
        bdDialog: Dialog;
        smtpsetup: Record "SMTP Mail Setup";
        mailheader: Text;
        mailbody: Text;
        depemails: Record "Dimension Value";
        UserSetup: Record "User Setup";
        TEXT001: Label 'Boardroom booking sent for your approval.';
        TEXT002: Label '''Hello, <br><br>''';
        TEXT003: Label '''Please note that boardroom booking no ''+FORMAT("No.")+'' has been sent for your approval. <br><br>''';
        TEXT004: Label '''Kindly proceed to the system to approve.Thanks<br><br>''';
        TEXT005: Label '''Kind Regards<br><br>''';
        TEXT006: Label '''<i>Administration</i><bt><br>''';
        TEXT007: Label '''Administration''';
        TEXT008: Label 'Booked Successfully,Kindly wait forPA to approve.';
        TEXT009: Label 'Status must be New.';
        TEXT010: Label 'HR';
    begin
        WITH BookingProcess DO BEGIN

            TESTFIELD(Duration);
            TESTFIELD(Book);
            TESTFIELD(User);
            //TESTFIELD("Meeting Agenda");
            TESTFIELD("Boardroom Name");
            TESTFIELD("Type of Meeting");
            //TESTFIELD(Agenda);
            //TESTFIELD("Attendee Names");
            //TESTFIELD("Attendee Names");


            depemails.SETRANGE("Global Dimension No.", 5);
            depemails.SETRANGE(Code, TEXT010);
            IF depemails.FIND('-') THEN BEGIN
                UserSetup.RESET;
                UserSetup.GET(User);
                mailheader := TEXT001;
                mailbody := TEXT002;
                mailbody := mailbody + TEXT003;
                mailbody := mailbody + TEXT004;
                mailbody := mailbody + TEXT005;
                mailbody := mailbody + TEXT006;
                smtpsetup.RESET;
                smtpsetup.GET;
                //smtpcu.CreateMessage(TEXT007, UserSetup."E-Mail", depemails."E-Mail Address", mailheader, mailbody, TRUE);
                smtpcu.Send;
            END;


            IF Status = Status::New THEN BEGIN
                Status := Status::Pending;
                MODIFY;
                MESSAGE(TEXT008);
            END ELSE BEGIN
                ERROR(TEXT009);
            END;

        END;
    end;

    procedure ApproveBoardroomAllocation(BookingProcess: Record "Booking Process");
    var

        Employee: Record Employee;
        HODEmail: Text[80];
        smtpcu: Codeunit "SMTP Mail";
        smtpsetup: Record "SMTP Mail Setup";
        mailheader: Text;
        mailbody: Text;
        depemails: Record "Dimension Value";
        UserSetup: Record "User Setup";
        Attendance: Record Attendance;
        no: Integer;
    begin
        WITH BookingProcess DO BEGIN
            UserSetup.GET(USERID);
            IF UserSetup."Boardroom Authoriser" = TRUE THEN BEGIN
                IF CONFIRM('Approve this Boardroom?') THEN BEGIN
                    IF Status = Status::Pending THEN
                        Status := Status::Booked;
                    MODIFY;
                    MESSAGE('Boardroom succesfully Approved.');
                END;


                depemails.SETRANGE("Global Dimension No.", 5);
                depemails.SETFILTER(Code, 'HR');
                IF depemails.FIND('-') THEN BEGIN

                    UserSetup.RESET;
                    UserSetup.GET(User);
                    mailheader := 'Check approval status.';
                    mailbody := '"Dear "' + User + '<br><br>';
                    mailbody := mailbody + 'Your boardroom booking for : <b>' + "Boardroom Name" + '</b> on <b>' + FORMAT("Required Date") + '</b> from <b>' + FORMAT("Specific time of use") + '</b> on <b>' + FORMAT("End Time") + '</b> has been successfully approved.<br><br>';
                    mailbody := mailbody + 'Be punctual. <br><br>';
                    mailbody := mailbody + 'Kind Regards<br><br>';
                    mailbody := mailbody + '<i>Administration</i><bt><br>';
                    smtpsetup.RESET;
                    smtpsetup.GET;
                    //smtpcu.CreateMessage(TEXT013, depemails."E-Mail Address", UserSetup."E-Mail", mailheader, mailbody, TRUE);
                    smtpcu.Send;


                END;
                no := 0;
                Attendance.RESET;
                Attendance.SETRANGE("No.", "No.");
                IF Attendance.FIND('-') THEN BEGIN
                    REPEAT
                        IF Attendance.Remarks <> '' THEN BEGIN
                            mailheader := 'NOTIFICATION OF SCHEDULED MEETING';
                            mailbody := '"Dear "' + Attendance."Attendee Names" + '<br><br>';
                            mailbody := mailbody + 'This is a notification that you are required to attend a meeting at: <b>' + "Boardroom Name" + '</b> boardroom on <b>' + FORMAT("Required Date") + '</b> from <b>' + FORMAT("Specific time of use") + '</b> <br><br>';
                            mailbody := mailbody + 'Please be Punctual. <br><br>';
                            mailbody := mailbody + 'Kind Regards<br><br>';
                            smtpsetup.RESET;
                            smtpsetup.GET;
                            //smtpcu.CreateMessage(TEXT013, depemails."E-Mail Address", Attendance.Remarks, mailheader, mailbody, TRUE);
                            smtpcu.Send;
                            MESSAGE(FORMAT('Email sent.'));

                        END;
                    UNTIL
                       Attendance.NEXT = 0;

                END;


            END ELSE BEGIN
                ERROR('You have not been set up as a boardroom approver.');
                EXIT;
            END;
        END;
    end;




    procedure RejectBoardroomAllocation(BookingProcess: Record "Booking Process");
    var
        TEXT001: Label 'Reject boardroom booking.';
        TEXT002: Label 'Boardroom approval cancelled.';
        TEXT003: Label 'You have not been set up as a boardroom approver.';
        UserSetup: Record "User Setup";
    begin
        WITH BookingProcess DO BEGIN

            UserSetup.GET(USERID);
            IF UserSetup."Boardroom Authoriser" = TRUE THEN BEGIN
                IF CONFIRM(TEXT001) THEN BEGIN
                    IF Status = Status::Pending THEN
                        Status := Status::New;
                    MODIFY;
                    MESSAGE(TEXT002);
                END;
            END ELSE BEGIN
                ERROR(TEXT003);
                EXIT;
            END;
        END;
    end;

    procedure ReallocateBoardroom(BookingProcess: Record "Booking Process");
    var
        TEXT001: Label 'Reschedule Boardroom booking.';
        TEXT002: Label 'Boardroom allocation has been rescheduled.';
        TEXT003: Label 'You have not been set up as a boardroom approver.';
        UserSetup: Record "User Setup";
    begin
        WITH BookingProcess DO BEGIN
            UserSetup.GET(USERID);
            IF UserSetup."Boardroom Authoriser" = TRUE THEN BEGIN
                IF CONFIRM(TEXT001) THEN BEGIN
                    IF Status = Status::Pending THEN
                        Status := Status::Rescheduled;
                    MODIFY;
                    MESSAGE(TEXT002);
                END;
            END ELSE BEGIN
                MESSAGE(TEXT003);
            END;
        END;
    end;

    procedure PreviewBoardroomReport(BookingProcess: Record "Booking Process");
    var
        BoardroomBooking: Report "Boardroom Booking";
    begin
        WITH BookingProcess DO BEGIN
            BookingProcess.RESET;
            BookingProcess.SETRANGE(Status, Status);
            BoardroomBooking.SETTABLEVIEW(BookingProcess);
            BoardroomBooking.RUN;
        END;
    end;

    procedure ViewBookedBoardrooms(BookingProcess: Record "Booking Process");
    var
        BoardroomBooking: Report "Boardroom Booking";
    begin
        WITH BookingProcess DO BEGIN
            BookingProcess.RESET;
            BookingProcess.SETRANGE(Status, Status);
            BookingProcess.SETRANGE(Status, BookingProcess.Status::Booked);
            BoardroomBooking.SETTABLEVIEW(BookingProcess);
            BoardroomBooking.RUN;
        END;
    end;

    procedure AttachNotice(Notice: Record Notice);
    var
        filename2: Text;
        filepath: Record "Admin Numbering Setup";
        user: Record "User Setup";
        filerec: File;
        filename3: Text;
        FileManagement: Codeunit "File Management";
        filename: Text;
        AdminNumberingSetup: Record "Admin Numbering Setup";
        TEXT001: Label '''Select  File'','''',''''';
        TEXT002: Label 'File Attached Successfully.';
    begin
        WITH Notice DO BEGIN
            filename := FileManagement.OpenFileDialog('Select  File', '', '');
            IF filename <> '' THEN BEGIN
                AdminNumberingSetup.RESET;
                AdminNumberingSetup.GET;
                AdminNumberingSetup.TESTFIELD("HOD File Path");
                filename2 := FORMAT(CURRENTDATETIME) + '_' + USERID;
                filename2 := CONVERTSTR(filename2, '/', '_');
                filename2 := CONVERTSTR(filename2, '\', '_');
                filename2 := CONVERTSTR(filename2, ':', '_');
                filename2 := CONVERTSTR(filename2, '.', '_');
                filename2 := CONVERTSTR(filename2, ',', '_');
                filename2 := CONVERTSTR(filename2, ' ', '_');
                filename3 := AdminNumberingSetup."HOD File Path" + "No." + FileManagement.GetFileName(filename);
                filename3 := DELCHR(filename3, '<>', ' ');
                FileManagement.CopyClientFile(filename, filename3, TRUE);
                "HOD File Path" := filename3;
                "Notice Doc" := filename3;
                MODIFY;
                MESSAGE(TEXT002);
            END;
        END;
    end;

    procedure OpenAttachedNotice(Notice: Record Notice);
    var
        TEXT001: Label '''Doc not Attached...!''.';
    begin
        WITH Notice DO BEGIN
            IF "Notice Doc" <> '' THEN BEGIN
                HYPERLINK("Notice Doc");
            END;
            IF "Notice Doc" = '' THEN BEGIN
                ERROR(TEXT001);
            END;

        END;
    end;

    procedure SaveNoticeDetails(Notice: Record Notice);
    var
        TEXT001: Label 'Notice Details Successfully saved.';
        TEXT002: Label 'Status must be New.';
    begin
        WITH Notice DO BEGIN

            IF Status = Status::New THEN BEGIN
                Status := Status::Pending;
                MODIFY;
                MESSAGE(TEXT001);
            END ELSE BEGIN
                ERROR(TEXT002);
            END;
        END;
    end;

    procedure ApproveNotice(Notice: Record Notice);
    var
        HODEmail: Text[80];
        smtpcu: Codeunit "SMTP Mail";
        bdDialog: Dialog;
        smtpsetup: Record "SMTP Mail Setup";
        mailheader: Text;
        mailbody: Text;
        depemails: Record "Dimension Value";
        UserSetup: Record "User Setup";
        TEXT001: Label 'Approve this Notice.';
        TEXT002: Label 'Notice succesfully Approved.';
        TEXT003: Label 'You have not been set up as a boardroom approver/Notice Approver.';
        TEXT004: Label 'HR';
        TEXT005: Label 'Check approval status.';
        TEXT006: Label '"Dear "';
        TEXT007: Label ''',<br><br>''';
        TEXT008: Label '''Kindly check the approval status of the Notices sent <b>''';
        TEXT009: Label '''</b> Approved/Rejected.<br><br>''';
        TEXT010: Label '''Proceed to send. <br><br>''';
        TEXT011: Label '''Kind Regards<br><br>''';
        TEXT012: Label '''<i>C.E.O,CBS</i><bt><br>''';
        TEXT013: Label '''C.E.O,CBS''';
        TEXT014: Label 'Email Sent.';
    begin
        WITH Notice DO BEGIN
            UserSetup.GET(USERID);
            IF UserSetup."C.E.O" = TRUE THEN BEGIN
                IF CONFIRM(TEXT001) THEN BEGIN
                    IF Status = Status::Pending THEN
                        Status := Status::Approved;
                    MODIFY;
                    MESSAGE(TEXT002);
                END;
            END ELSE BEGIN
                MESSAGE(TEXT003);
                EXIT;
            END;
            depemails.RESET;
            depemails.SETRANGE("Global Dimension No.", 5);
            depemails.SETRANGE(Code, FORMAT(TEXT004));
            IF depemails.FIND('-') THEN BEGIN
                UserSetup.RESET;
                mailheader := TEXT005;
                mailbody := TEXT006 + User + TEXT007;
                mailbody := mailbody + TEXT008 + "No." + TEXT009;
                mailbody := mailbody + TEXT010;
                mailbody := mailbody + TEXT011;
                mailbody := mailbody + TEXT012;
                smtpsetup.RESET;
                smtpsetup.GET;
                //smtpcu.CreateMessage(TEXT013, depemails."E-Mail Address", UserSetup."E-Mail", mailheader, mailbody, TRUE);
                smtpcu.Send;
            END;

            MESSAGE(FORMAT(TEXT014));



        END;
    end;

    procedure RejectNotice(Notice: Record Notice);
    var
        UserSetup: Record "User Setup";
        TEXT001: Label 'Reject Notice Approval.';
        TEXT002: Label 'Notice approval cancelled.';
        TEXT003: Label 'You have not been set up as a boardroom approver/Notice Approver.';
    begin
        WITH Notice DO BEGIN
            UserSetup.GET(USERID);
            IF UserSetup."Boardroom Authoriser" = TRUE THEN BEGIN
                IF CONFIRM(TEXT001) THEN BEGIN
                    IF Status = Status::Pending THEN
                        Status := Status::New;
                    MESSAGE(TEXT002);
                END;
            END ELSE BEGIN
                MESSAGE(TEXT003);
                EXIT;

            END;
        END;
    end;

    procedure AttachMinutes(MinuteTemplate: Record MinuteTemplate);
    var
        filename2: Text;
        filepath: Record "Admin Numbering Setup";
        user: Record "User Setup";
        filerec: File;
        filename3: Text;
        FileManagement: Codeunit "File Management";
        filename: Text;
        AdminNumberingSetup: Record "Admin Numbering Setup";
        TEXT001: Label '''Select  File'','''',''''';
        TEXT002: Label 'File Attached Successfully.';
    begin
        WITH MinuteTemplate DO BEGIN
            filename := FileManagement.OpenFileDialog('Select  File', '', '');
            IF filename <> '' THEN BEGIN
                AdminNumberingSetup.RESET;
                AdminNumberingSetup.GET;
                AdminNumberingSetup.TESTFIELD("HOD File Path");
                filename2 := FORMAT(CURRENTDATETIME) + '_' + USERID;
                filename2 := CONVERTSTR(filename2, '/', '_');
                filename2 := CONVERTSTR(filename2, '\', '_');
                filename2 := CONVERTSTR(filename2, ':', '_');
                filename2 := CONVERTSTR(filename2, '.', '_');
                filename2 := CONVERTSTR(filename2, ',', '_');
                filename2 := CONVERTSTR(filename2, ' ', '_');
                filename3 := AdminNumberingSetup."HOD File Path" + "No." + FileManagement.GetFileName(filename);
                filename3 := DELCHR(filename3, '<>', ' '); //ERROR(filename3);
                FileManagement.CopyClientFile(filename, filename3, TRUE);
                "HOD File Path" := filename3;
                "Notice Doc" := filename3;
                MODIFY;
                MESSAGE(TEXT002);
            END;
        END;
    end;

    procedure OpenAttachedMinutes(MinuteTemplate: Record MinuteTemplate);
    var
        TEXT001: Label '''Doc not Attached...!''.';
    begin
        WITH MinuteTemplate DO BEGIN
            IF "Notice Doc" <> '' THEN BEGIN
                HYPERLINK("Notice Doc");
            END;
            IF "Notice Doc" = '' THEN BEGIN
                ERROR(TEXT001);
            END;

        END;
    end;

    procedure SaveMinuteDetails(MinuteTemplate: Record MinuteTemplate);
    var
        TEXT001: Label 'Minutes succesfully saved.';
    begin
        WITH MinuteTemplate DO BEGIN

            TESTFIELD(Remarks);
            MESSAGE(TEXT001);

        END;
    end;

    procedure SaveCEOScheduleDetails(CEOSchedule: Record "CEO Schedule");
    var
        TEXT001: Label 'Details successfully saved.';
    begin
        WITH CEOSchedule DO BEGIN

            TESTFIELD(Comments);
            TESTFIELD(Date);
            MESSAGE(TEXT001);

        END;
    end;
}

