page 50435 "Leave Recall Card"
{
    // version TL2.0

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = 50222;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Recall Date"; "Recall Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Application"; "Leave Application")
                {
                    NotBlank = true;
                    ApplicationArea = All;
                }
                field("Employee No"; "Employee No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    Caption = 'Employee Name';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Department"; "Employee Department")
                {
                    Caption = 'Department';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Branch"; "Employee Branch")
                {
                    Caption = 'Branch';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Job Title"; "Employee Job Title")
                {
                    Caption = 'Job Title';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Start Date"; "Leave Start Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Days Applied"; "Days Applied")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Ending Date"; "Leave Ending Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Remaining Days"; "Remaining Days")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("Recall Details")
            {
                Caption = 'Recall Details';
                field("Recalled Days"; "Recalled Days")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Recalled From"; "Recalled From")
                {
                    ApplicationArea = All;
                }
                field("Recalled To"; "Recalled To")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Recalled By"; "Recalled By")
                {
                    NotBlank = true;
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Recall Department"; "Recall Department")
                {
                    Caption = 'Department.';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Recall Branch"; "Recall Branch")
                {
                    Caption = 'Branch.';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    Caption = 'Job Title.';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Reason for Recall"; "Reason for Recall")
                {
                    NotBlank = true;
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Recall & Notify Employee")
            {
                Caption = 'Recall Employee';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(TEXT001) THEN BEGIN
                        TESTFIELD("Leave Application");
                        TESTFIELD("Employee No");
                        //TESTFIELD(Name);
                        TESTFIELD("Leave Ending Date");
                        TESTFIELD("Recalled From");
                        TESTFIELD("Recalled To");
                        TESTFIELD("Recalled By");
                        TESTFIELD("Reason for Recall");
                        TESTFIELD("Recall Date");

                        HRJournalLine.INIT;
                        HRJournalLine."Document No" := "No.";
                        HRJournalLine."Leave Period" := FORMAT(DATE2DMY(TODAY, 3));
                        ;
                        HRJournalLine."Employee No." := "Employee No";
                        HRJournalLine."Employee Name" := "Employee Name";
                        // HRJournalLine.VALIDATE(HRJournalLine."Employee No.");
                        HRJournalLine."Posting Date" := TODAY;
                        HRJournalLine."Entry Type" := HRJournalLine."Entry Type"::Positive;
                        HRJournalLine.Description := "Reason for Recall";
                        HRJournalLine."Leave Code" := "Leave Code";
                        HRJournalLine.Days := "Recalled Days";
                        HRJournalLine."User ID" := USERID;
                        HRJournalLine.Recall := TRUE;
                        HRJournalLine.INSERT(TRUE);

                        Status := Status::Released;
                        MODIFY;

                        IF Employee.GET("Employee No") THEN BEGIN
                            IF UserSetup.GET(USERID) THEN BEGIN
                                HRSetup.GET;
                                CompanyInformation.GET;
                                RecipientMail := Employee."E-Mail" + ';' + UserSetup."E-Mail" + ';' + HRSetup."HR E-Mail";
                                /* HRManagement.SendMail(RecipientMail,TEXT002,TEXT003+"Employee Name"+TEXT004+"Leave Code"+TEXT005+Name+TEXT006+
                                                       FORMAT("Recalled Days")+TEXT007+FORMAT("Recalled From")+TEXT008+FORMAT("Recalled To")+TEXT009+CompanyInformation.Name);*/
                                MESSAGE(TEXT010);
                            END;
                        END;
                    END;

                end;
            }
        }
    }

    var
        HRJournalLine: Record 50209;
        TEXT001: Label 'Recall Employee from Leave?';
        HRManagement: Codeunit 50050;
        UserSetup: Record 91;
        Employee: Record 5200;
        RecipientMail: Text;
        HRSetup: Record 5218;
        TEXT002: Label 'LEAVE RECALL NOTICE';
        TEXT003: Label '"Dear  "';
        TEXT004: Label '",<br><br> Please note that your "';
        TEXT005: Label '" leave has been recalled by "';
        TEXT006: Label '" for "';
        TEXT007: Label '" days from "';
        TEXT008: Label '" to "';
        TEXT009: Label '. <br><br>Kind Regards,<br>';
        CompanyInformation: Record 79;
        TEXT010: Label 'Employee has been successfully recalled!';
}

