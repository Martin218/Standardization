page 50979 "Transfer Files Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Transfer Registry File";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Transfer ID"; "Transfer ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Released From"; "Released From")
                {
                    ApplicationArea = All;
                }
                field("Time Released"; "Time Released")
                {
                    ApplicationArea = All;
                }
                field("Released To"; "Released To")
                {
                    ApplicationArea = All;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Duration Required(Days)"; "Duration Required(Days)")
                {
                    Visible = DueDate;
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    Visible = DueDate;
                    ApplicationArea = All;
                }
                field("Carried By"; "Carried By")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Branch Code"; "Branch Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Carried By(Name)"; "Carried By(Name)")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
            }


        }
    }

    actions
    {
        area(creation)
        {
            action("Transfer File")
            {
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = TransferFiles;

                trigger OnAction();
                begin
                    TESTFIELD("Released To");
                    TESTFIELD(Comments);

                    TransferFilesLines.RESET;
                    TransferFilesLines.SETRANGE("Transfer ID", "Transfer ID");
                    IF NOT TransferFilesLines.FINDSET THEN BEGIN
                        ERROR('Please select a file to transfer.');
                    END;

                    IF CONFIRM('Are you sure you want to transfer file?') THEN BEGIN
                        TransferFilesLines.RESET;
                        TransferFilesLines.SETRANGE("Transfer ID", "Transfer ID");
                        IF TransferFilesLines.FIND('-') THEN BEGIN
                            REPEAT
                                //TransferFilesLines."Released To":="Released To";
                                TransferFilesLines.MODIFY;
                            UNTIL
                             TransferFilesLines.NEXT = 0;
                        END;

                        IF Status = Status::New THEN BEGIN
                            Status := Status::"Pending Receipt";
                            MESSAGE('File transferred successfully.');
                        END;


                        TransferFilesLines.RESET;
                        TransferFilesLines.SETRANGE("Transfer ID", "Transfer ID");
                        IF TransferFilesLines.FIND('-') THEN BEGIN
                            REPEAT
                                FileNo := TransferFilesLines."File No";
                                FileName := TransferFilesLines."File Name";
                            UNTIL
                             TransferFilesLines.NEXT = 0;
                        END;


                        //send mail to the recepient of the file transfer
                        bddialog.OPEN('Sending email to the recepient of the file transfer');
                        User.RESET;
                        User.GET("Released To");
                        mailheader := 'NOTIFICATION OF FILE TRANSFER';
                        mailbody := 'Dear ' + "Released To" + ',<br><br>';
                        mailbody := mailbody + 'Please Note that ' + "Released From" + ' has transferred the following files to you' + "Released To" + ' under transfer ID:<b>' + "Transfer ID" + '</b> <br><br>';
                        TransferFilesLines.RESET;
                        TransferFilesLines.SETRANGE("Transfer ID", "Transfer ID");
                        IF TransferFilesLines.FINDSET THEN BEGIN
                            REPEAT
                                mailbody := mailbody + ' File No:<b>' + TransferFilesLines."File Number" + '</b> Name:<b> ' + TransferFilesLines."File Name" + '</b> Member No: <b> ' + TransferFilesLines."Member No" + '</b> ID No <b> ' + TransferFilesLines."ID No" + '</b> <br><br>';
                            UNTIL
                             TransferFilesLines.NEXT = 0;
                        END;
                        //mailbody:=mailbody+'File No: <b>'+FileNo+'  '+FileName+'</b> <br><br>';
                        mailbody := mailbody + 'Kindly confirm the receipt of the files. <br><br>';
                        mailbody := mailbody + 'Kind Regards<br><br>';
                        mailbody := mailbody + '<i>Registry</i><bt><br>';
                        //smtprec.RESET;
                        //smtprec.GET;
                        //smtpcu.CreateMessage('Registry', smtprec."User ID", User."E-Mail", mailheader, mailbody, TRUE);
                        User.RESET;
                        User.GET("Released From");
                        //smtpcu.AddBCC(User."E-Mail");
                        RegistrySetUp.RESET;
                        RegistrySetUp.GET;
                        IF RegistrySetUp."Registry Email" <> '' THEN BEGIN
                            //smtpcu.AddBCC(RegistrySetUp."Registry Email");
                        END;
                        //smtpcu.Send;

                        bddialog.CLOSE;
                        MESSAGE(FORMAT('Email sent.'));
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action("Receive File")
            {
                Image = Receipt;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ReceiveFile;

                trigger OnAction();
                begin
                    TESTFIELD("Duration Required(Days)");
                    User.GET(USERID);
                    IF User."User ID" <> "Released To" THEN BEGIN
                        ERROR('You cannot receive the file transferred to %1.', "Released To");
                    END;
                    IF CONFIRM('Are you sure you want to receive the file(s)?') THEN BEGIN
                        TransferFilesLines.RESET;
                        TransferFilesLines.SETRANGE("Transfer ID", "Transfer ID");
                        IF TransferFilesLines.FIND('-') THEN BEGIN
                            REPEAT
                                TransferFilesLines."Received By" := USERID;
                                TransferFilesLines."Carried By" := "Released To";
                                TransferFilesLines."Time Received" := CURRENTDATETIME;
                                TransferFilesLines."Current User" := TRUE;
                                TransferFilesLines."Current User ID" := USERID;
                                TransferFilesLines."Due Date" := "Due Date";
                                TransferFilesLines.MODIFY;
                            UNTIL
                              TransferFilesLines.NEXT = 0;
                        END;

                        TransferFilesLines.RESET;
                        TransferFilesLines.SETRANGE("Received By", "Released From");
                        TransferFilesLines.SETRANGE("File Number", TransferFilesLines."File Number");
                        TransferFilesLines.SETRANGE(Returned, FALSE);
                        IF TransferFilesLines.FIND('-') THEN BEGIN
                            REPEAT
                                TransferFilesLines."Current User" := FALSE;
                                TransferFilesLines.Returned := TRUE;
                                TransferFilesLines."Return date" := CURRENTDATETIME;
                                TransferFilesLines."Returned by" := "Released From";
                                TransferFilesLines.MODIFY;
                            UNTIL
                              TransferFilesLines.NEXT = 0;
                        END;

                        TransferFilesLines.RESET;
                        TransferFilesLines.SETRANGE("Transfer ID", "Transfer ID");
                        IF TransferFilesLines.FIND('-') THEN BEGIN
                            REPEAT
                                FileRegistry.RESET;
                                FileRegistry.SETRANGE("File No.", TransferFilesLines."File No");
                                FileRegistry.SETRANGE("ID No.", TransferFilesLines."ID No");
                                IF FileRegistry.FINDSET THEN BEGIN
                                    //FileRegistry.Issued:=TRUE;
                                    FileRegistry."Current User" := TransferFilesLines."Current User ID";
                                    FileRegistry.MODIFY;
                                END;
                            UNTIL
                          TransferFilesLines.NEXT = 0;
                        END;

                        IF Status = Status::"Pending Receipt" THEN
                            Status := Status::Received;
                        MESSAGE('File Received successfully.');


                        //send mail of confirmation of the file transfer
                        bddialog.OPEN('Sending email of confirmation of file transfer');
                        User.RESET;
                        User.GET("Released From");
                        mailheader := 'NOTIFICATION OF CONFIRMATION OF FILE TRANSFER';
                        mailbody := 'Dear ' + "Released From" + ',<br><br>';
                        mailbody := mailbody + 'Please Note that ' + "Released To" + ' has confirmed receipt of the following files transferred under transfer ID:<b>' + "Transfer ID" + '</b> by <b>' + "Released From" + '</b> <br><br>';
                        TransferFilesLines.RESET;
                        TransferFilesLines.SETRANGE("Transfer ID", "Transfer ID");
                        IF TransferFilesLines.FINDSET THEN BEGIN
                            REPEAT
                                mailbody := mailbody + ' File No:<b>' + TransferFilesLines."File Number" + '</b> Name:<b> ' + TransferFilesLines."File Name" + '</b> Member No: <b> ' + TransferFilesLines."Member No" + '</b> ID No <b> ' + TransferFilesLines."ID No" + '</b> <br><br>';
                            UNTIL
                             TransferFilesLines.NEXT = 0;
                        END;
                        //mailbody:=mailbody+'File No: <b>'+FileNo+'  '+FileName+'</b> <br><br>';
                        mailbody := mailbody + 'Thank you <br><br>';
                        mailbody := mailbody + 'Kind Regards<br><br>';
                        mailbody := mailbody + '<i>Registry</i><bt><br>';
                        //smtprec.RESET;
                        //smtprec.GET;
                        //smtpcu.CreateMessage('Registry', smtprec."User ID", User."E-Mail", mailheader, mailbody, TRUE);
                        User.RESET;
                        User.GET("Released To");
                        //smtpcu.AddBCC(User."E-Mail");
                        RegistrySetUp.RESET;
                        RegistrySetUp.GET;
                        IF RegistrySetUp."Registry Email" <> '' THEN BEGIN
                            //smtpcu.AddBCC(RegistrySetUp."Registry Email");
                        END;
                        //smtpcu.Send;

                        bddialog.CLOSE;
                        MESSAGE(FORMAT('Email sent.'));
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action("Cancel File Transfer")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    IF Status = Status::Received THEN BEGIN
                        ERROR('File has already been received! You cannot cancel this transfer.');
                    END;

                    IF "Released From" <> USERID THEN BEGIN
                        ERROR('You do not have rights to cancel this request!');
                    END;

                    IF CONFIRM('Are you sure you want to cancel this file transfer') THEN BEGIN
                        TransferFilesLines.RESET;
                        TransferFilesLines.SETRANGE("Transfer ID", "Transfer ID");
                        IF TransferFilesLines.FIND('-') THEN BEGIN
                            MESSAGE('%1', TransferFilesLines."Transfer ID");
                            REPEAT
                                TransferFilesLines.DELETE;
                            // TransferFilesLines.MODIFY;
                            UNTIL
                              TransferFilesLines.NEXT = 0;
                        END;

                        TransferRegistryFiles.RESET;
                        TransferRegistryFiles.SETRANGE("Transfer ID", "Transfer ID");
                        IF TransferRegistryFiles.FIND('-') THEN BEGIN
                            TransferRegistryFiles.DELETE;
                        END;
                    END;
                    MESSAGE('File Transfer Cancelled.');
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        User.GET(USERID);
        IF Status = Status::New THEN BEGIN
            TransferFiles := TRUE;
        END;
        ReceiveFile := FALSE;
        IF Status = Status::"Pending Receipt" THEN BEGIN
            IF USERID <> "Released To" THEN BEGIN
                ReceiveFile := FALSE;
                DueDate := FALSE;
            END;
            IF USERID = "Released To" THEN BEGIN
                ReceiveFile := TRUE;
                DueDate := TRUE;
            END;
        END;
    end;

    var
        TransferFilesLines: Record "Transfer Files Line";
        ReceiveFile: Boolean;
        TransferFiles: Boolean;
        User: Record "User Setup";
        //smtprec: Record "409";
        //smtpcu: Codeunit "400";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        FileNo: Code[10];
        FileName: Text;
        Comment: Text;
        RegisterLines: Record "Registry Files Line";
        FileRegistry: Record "Registry File";
        RegistrySetUp: Record "Registry SetUp";
        DueDate: Boolean;
        TransferRegistryFiles: Record "Transfer Registry File";
    // DimensionValue: Record "349";
}

