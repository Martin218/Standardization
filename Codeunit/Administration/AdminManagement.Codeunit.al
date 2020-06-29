codeunit 50070 "Admin Management"
{
    // version TL2.0


    trigger OnRun();
    begin
    end;

    procedure RegisterVehicle(VehicleRegister: Record "Vehicle Register");
    var
        TEXT001: Label 'Add vehicle to vehicle registry?';
        TEXT002: Label 'Vehicle Successfully added to Vehicle Registry.';
    begin
        WITH VehicleRegister DO BEGIN

            TESTFIELD("Number Plate");
            TESTFIELD("Chassis No");
            TESTFIELD(Color);
            TESTFIELD(Model);
            IF CONFIRM(TEXT001, FALSE) = TRUE THEN BEGIN
                TESTFIELD("No.");

                IF Registered = FALSE THEN
                    Registered := TRUE;
                MODIFY;
                MESSAGE(TEXT002);
            END;
        END;
    end;

    procedure BookVehicle(VehicleBooking: Record "Vehicle Booking");
    var
        GvVehicle: Record "Vehicle Register";
        // CurrentUser: Record "91";
        // Mail: Codeunit "397";
        Employee: Record Employee;
        //smtpcu: Codeunit "400";
        //smtpsetup: Record "409";
        // mailheader: Text;
        //mailbody: Text;
        //depemails: Record "349";
        TEXT001: Label 'Vehicle booking sent for your approval.';
        TEXT002: Label '''Hello, <br><br>''';
        TEXT003: Label '''Please note that vehicle booking no ''';
        TEXT004: Label ''' has been sent for your approval. <br><br>''';
        TEXT005: Label '''Kindly proceed to the system to approve.Thanks<br><br>''';
        TEXT006: Label '''Kind Regards<br><br>''';
        TEXT007: Label '''<i>Administration</i><bt><br>''';
        TEXT008: Label '''Administration''';
        TEXT009: Label 'Booked Successfully,Kindly wait for vehicle approval.';
        TEXT010: Label 'Status should be new.';
        TEXT011: Label 'Vehicle is currently booked.';
        VehicleRegister: Record "Vehicle Register";
    begin
        WITH VehicleBooking DO BEGIN
            /*depemails.SETRANGE("Global Dimension No.", 5);
            depemails.SETRANGE(Code, 'ADM');
            IF depemails.FIND('-') THEN BEGIN
                CurrentUser.RESET;
                CurrentUser.GET(User);
                mailheader := TEXT001;
                mailbody := TEXT002;
                mailbody := mailbody + TEXT003 + FORMAT("No.") + TEXT004;
                mailbody := mailbody + TEXT005;
                mailbody := mailbody + TEXT006;
                mailbody := mailbody + TEXT007;
                smtpsetup.RESET;
                smtpsetup.GET;
                smtpcu.CreateMessage(TEXT008, CurrentUser."E-Mail", depemails."E-Mail Address", mailheader, mailbody, TRUE);
                smtpcu.Send;
            END;*/

            IF Status = Status::Booked THEN
                ERROR(TEXT011);
            IF Status = Status::New THEN BEGIN
                Status := Status::Pending;
                MODIFY;

                MESSAGE(TEXT009);
            END ELSE BEGIN
                ERROR(TEXT010);
            END;
        END;
    end;

    procedure ApproveVehicleBooking(VehicleBooking: Record "Vehicle Booking");
    var
        CurrentUser: Record "User Setup";
        //Mail: Codeunit "397";
        Employee: Record Employee;
        //smtpcu: Codeunit "400";
        //smtpsetup: Record "409";
        mailheader: Text;
        mailbody: Text;
        //depemails: Record "349";
        TEXT001: Label 'Approve this vehicle booking';
        TEXT002: Label 'Vehicle succesfully Approved.';
        TEXT003: Label 'You have not been set up as a vehicle approver.';
        TEXT004: Label 'Check approval status';
        TEXT005: Label '''Dear ''';
        TEXT006: Label ''',<br><br>''';
        TEXT007: Label '''Kindly check the approval status of the vehicle: <b>''';
        TEXT008: Label '''</b> Ready for use.<br><br>''';
        TEXT009: Label '''Your assigned driver is.<b>''';
        TEXT010: Label '''</b><br>Kindly bring it back on time.Thanks<br><br>''';
        TEXT011: Label '''Kind Regards<br><br>''';
        TEXT012: Label '''<i>Administration</i><bt><br>''';
        TEXT013: Label 'Admin';
        TEXT014: Label 'Email Sent.';
    begin
        WITH VehicleBooking DO BEGIN


            CurrentUser.GET(USERID);
            //IF CurrentUser."Vehicle Approver" = TRUE THEN BEGIN
            IF CONFIRM(TEXT001) THEN BEGIN
                IF Status = Status::Pending THEN
                    Status := Status::Booked;
                Booked := TRUE;
                MODIFY;
                MESSAGE(TEXT002);
            END;
            //END ELSE BEGIN
            MESSAGE(TEXT003);
            EXIT;

        END;

        /*depemails.SETRANGE("Global Dimension No.", 5);
        depemails.SETRANGE(Code, 'ADM');
        IF depemails.FIND('-') THEN BEGIN
            CurrentUser.RESET;
            CurrentUser.GET(User);
            mailheader := TEXT004;
            mailbody := TEXT005 + User + TEXT006;
            mailbody := mailbody + TEXT007 + "Available Car" + TEXT008;
            mailbody := mailbody + TEXT009 + "Assign Driver" + TEXT010;
            mailbody := mailbody + TEXT011;
            mailbody := mailbody + TEXT012;
            smtpsetup.RESET;
            smtpsetup.GET;
            smtpcu.CreateMessage(TEXT013, depemails."E-Mail Address", CurrentUser."E-Mail", mailheader, mailbody, TRUE);
            smtpcu.Send;
        END;
        MESSAGE(FORMAT(TEXT014));
          */

    END;
    //end;

    procedure RejectVehicleBooking(VehicleBooking: Record "Vehicle Booking");
    var
        CurrentUser: Record "User Setup";
        TEXT001: Label 'Reject car booking.';
        TEXT002: Label 'Vehicle approval rejected.';
        TEXT003: Label 'You have not been set up as a vehicle approver.';
    begin
        WITH VehicleBooking DO BEGIN

            CurrentUser.GET(USERID);
            //IF CurrentUser."Vehicle Approver" = TRUE THEN BEGIN
            IF CONFIRM(TEXT001) THEN BEGIN
                IF Status = Status::Pending THEN
                    Status := Status::Rejected;
                MODIFY;
                MESSAGE(TEXT002);
            END;
            //END ELSE BEGIN
            MESSAGE(TEXT003);
            EXIT;

        END;

    END;
    //end;

    procedure ScheduleVehicleMaintenance(VehicleMaintenance: Record "Vehicle Maintenance");
    var
        TEXT001: Label 'Do you want to schedule?';
        TEXT002: Label 'Scheduled Successfully.';
    begin
        WITH VehicleMaintenance DO BEGIN


            IF CONFIRM(TEXT001, FALSE) = TRUE THEN BEGIN
                TESTFIELD("Vehicle Number Plate");

                IF Scheduled = FALSE THEN
                    Scheduled := TRUE;
                MODIFY;
                MESSAGE(TEXT002);
            END;
        END;
    end;

    procedure ScheduleInsuranceValuation(VehicleInsuranceScheduling: Record "Vehicle Insurance Scheduling");
    var
        TEXT001: Label 'Do you want to schedule?';
        TEXT002: Label 'Scheduled Successfully.';
    begin
        WITH VehicleInsuranceScheduling DO BEGIN
            IF CONFIRM(TEXT001, FALSE) = TRUE THEN BEGIN
                TESTFIELD("Insurance Company");

                IF Scheduled = FALSE THEN
                    Scheduled := TRUE;
                MODIFY;
                MESSAGE(TEXT002);
            END;
        END;
    end;

    procedure AttachFuelTrackingStatements(FuelTracking: Record "Fuel Tracker Setup");
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
        AdminDoc: Record "Admin Doc";
    begin
        WITH FuelTracking DO BEGIN
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
                filename3 := AdminNumberingSetup."HOD File Path" + AdminNumberingSetup."No." + FileManagement.GetFileName(filename);
                filename3 := DELCHR(filename3, '<>', ' ');
                FileManagement.CopyClientFile(filename, filename3, TRUE);
                // "HOD File Path" := filename3;
                // "Notice Doc" := filename3;
                MODIFY;
                MESSAGE(TEXT002);
            END;
        END;
    end;

    procedure OpenAttachedFuelTrackingStatements(FuelTracking: Record "Fuel Tracker Setup");
    var
        TEXT001: Label '''Doc not Attached...!''.';
        VehicleRegister: Record "Vehicle Register";
    begin
        WITH FuelTracking DO BEGIN
            /* IF "Notice Doc" <> '' THEN BEGIN
                 HYPERLINK("Notice Doc");
             END ELSE BEGIN
                 ERROR(TEXT001);
             END;*/
        END;
    end;

    procedure ReturnVehicle(VehicleBooking: Record "Vehicle Booking");
    var
        CurrentUser: Record "User Setup";
        //Mail: Codeunit "397
        Employee: Record Employee;
        // smtpcu: Codeunit "400";
        // smtpsetup: Record "409";
        mailheader: Text;
        mailbody: Text;
        //depemails: Record "349";
        TEXT001: Label 'Vehicle return done successfully.';
        TEXT002: Label 'Status must be Booked.';
        TEXT003: Label 'Return of vehicle';
        TEXT004: Label '''Dear ''';
        TEXT005: Label ''',<br><br>''';
        TEXT006: Label '''Kindly acknowledge vehicle return.It is in good condition cheers!! <b>''';
        TEXT007: Label '''</b> Vehicle returned.<br><br>''';
        TEXT008: Label '''Return <br><br>''';
        TEXT009: Label '''Kind Regards<br><br>''';
        TEXT010: Label '''Current vehicle user''';

        VehicleRegister: Record "Vehicle Register";
    begin
        WITH VehicleBooking DO BEGIN
            TESTFIELD("Vehicle Return Date");
            IF Status = Status::Booked THEN BEGIN
                Status := Status::Returned;
                MODIFY;
                VehicleRegister.RESET;
                VehicleRegister.Booked := FALSE;
                VehicleRegister.MODIFY;
                MESSAGE(TEXT001);
            END ELSE BEGIN
                ERROR(TEXT002);
            END;
            // depemails.SETRANGE("Global Dimension No.", 5);
            //depemails.SETRANGE(Code, 'ADM');
            /*IF depemails.FIND('-') THEN BEGIN
                CurrentUser.RESET;
                CurrentUser.GET(USERID);
                mailheader := TEXT003;
                mailbody := TEXT004 + User + TEXT005;
                mailbody := mailbody + TEXT006 + "Available Car" + TEXT007;
                mailbody := mailbody + TEXT008;
                mailbody := mailbody + TEXT009;
                smtpsetup.RESET;
                smtpsetup.GET;
                depemails.TESTFIELD("E-Mail Address");
                CurrentUser.TESTFIELD("E-Mail");
                smtpsetup.TESTFIELD("User ID");
                smtpcu.CreateMessage(TEXT010, smtpsetup."User ID", depemails."E-Mail Address" + ';' + CurrentUser."E-Mail", mailheader, mailbody, TRUE);


                smtpcu.Send;
            END;*/

        END;
    end;

    procedure CheckInsuranceExpirydate(VehicleRegister: Record "Vehicle Register");
    var
        CurrentUser: Record "User Setup";
        // Mail: Codeunit "397";
        Employee: Record Employee;
        //smtpcu: Codeunit "400";
        //smtpsetup: Record "409";
        mailheader: Text;
        mailbody: Text;
        //depemails: Record "349";
        TEXT001: Label 'Check the insurance date of the vehicle.';
        TEXT002: Label '"Dear "';
        TEXT003: Label ''',<br><br>''';
        TEXT004: Label '''Kindly check the insurance expiry date of the vehicle: <b>''';
        TEXT005: Label '''</b> Renew the insurance asap if it has expired.<br><br>''';
        TEXT006: Label '''The vehicle insurance date is<br>''';
        TEXT007: Label '''Kind Regards<br><br>''';
        TEXT008: Label '''<i>Administration</i><bt><br>''';
        TEXT009: Label '''Administration''';

    begin
        WITH VehicleRegister DO BEGIN
            TESTFIELD("Date of Insurance");
            ///depemails.RESET;
            // depemails.SETRANGE("Global Dimension No.", 5);
            // depemails.SETRANGE(Code, 'ADM');
            /*  IF depemails.FIND('-') THEN BEGIN
                  CurrentUser.RESET;
                  CurrentUser.GET(USERID);
                  mailheader := TEXT001;
                  mailbody := TEXT002 + "Responsible Driver" + TEXT003;
                  mailbody := mailbody + TEXT004 + "Number Plate" + TEXT005;
                  mailbody := mailbody + TEXT006 + FORMAT("Insurance Expiry Date");
                  mailbody := mailbody + TEXT007;
                  mailbody := mailbody + TEXT008;
                  smtpsetup.RESET;
                  smtpsetup.GET;
                  smtpcu.CreateMessage(TEXT009, smtpsetup."User ID", CurrentUser."E-Mail", mailheader, mailbody, TRUE);

                  smtpcu.Send;
              END;*/

        END;
    end;

    procedure ViewAdminDocs(HumanResourceDoc: Record "Human Resource Doc");
    var
        lastno: Integer;
        HRDocumentView: Record "HR Document View";
        TEXT005: Label 'View Attached Doc';
    begin
        WITH HumanResourceDoc DO BEGIN
            IF CONFIRM(TEXT005) THEN BEGIN
                HumanResourceDoc.SETRANGE("No.", "No.");
                IF HumanResourceDoc.FIND('-') THEN BEGIN
                    HYPERLINK("Document Path");
                END;

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
}

