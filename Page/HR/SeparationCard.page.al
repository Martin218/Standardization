page 50492 "Separation Card"
{
    // version TL2.0

    Caption = 'Separation Form';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = 50237;

    layout
    {
        area(content)
        {
            group(Info)
            {
                Caption = 'Info';
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Separation Date"; "Separation Date")
                {
                    ApplicationArea = All;
                }
                field("Separation Type"; "Separation Type")
                {
                    ApplicationArea = All;
                }
                field("Notification Start Date"; "Notification Start Date")
                {
                    ApplicationArea = All;
                }
                field("Notice Period"; "Notice Period")
                {
                    ApplicationArea = All;
                }
                field("Notification End Date"; "Notification End Date")
                {
                    ApplicationArea = All;
                }
                field("Last Working Date"; "Last Working Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Accrual End Date"; "Leave Accrual End Date")
                {
                    ApplicationArea = All;
                }
                field("Days In Lieu of Notice"; "Days In Lieu of Notice")
                {
                    ApplicationArea = All;
                }
                field("Reason for Separation"; "Reason for Separation")
                {
                    ApplicationArea = All;
                }
                field("Separation Status"; "Separation Status")
                {
                    ApplicationArea = All;
                }
            }
            group("Leave Days")
            {
                Caption = 'Leave Days';
                field("Leave Balance"; "Leave Days Earned to Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Days in Notice"; "Leave Days in Notice")
                {
                    ApplicationArea = All;
                }
                field("Leave Start Date"; "Leave Start Date")
                {
                    ApplicationArea = All;
                }
                field("Leave End Date"; "Leave End Date")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Leave Days"; "Outstanding Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Pay for Outstanding Leave Days"; "Pay for Outstanding Leave Days")
                {
                    ApplicationArea = All;
                }
            }
            group(Salary)
            {
                Caption = 'Salary';
                field("Basic Salary"; "Basic Salary")
                {
                    ApplicationArea = All;
                }
                field("No. Of Months Salary"; "No. Of Months Salary")
                {
                    ApplicationArea = All;
                }
                field("Salary(Full Month)"; "Salary(Full Month)")
                {
                    ApplicationArea = All;
                }
                field("Salary(Extra Days)"; "Salary(Extra Days)")
                {
                    ApplicationArea = All;
                }
                field("Part Salary Start Date"; "Part Salary Start Date")
                {
                    ApplicationArea = All;
                }
                field("Part Salary End Date"; "Part Salary End Date")
                {
                    ApplicationArea = All;
                }
                field("Part Salary to be paid"; "Part Salary to be paid")
                {
                    ApplicationArea = All;
                }
            }
            group(Allowances)
            {
                Caption = 'Allowances';
                field("Golden Handshake"; "Golden Handshake")
                {
                    ApplicationArea = All;
                }
                field("Transport Allowance"; "Transport Allowance")
                {
                    ApplicationArea = All;
                }
                field("No of Years Worked"; "No of Years Worked")
                {
                    ApplicationArea = All;
                }
                field("Severence Pay"; "Severence Pay")
                {
                    ApplicationArea = All;
                }
                field("Pay Leave Allowance"; "Pay Leave Allowance")
                {
                    ApplicationArea = All;
                }
                field("Leave Alowance Paid"; "Leave Alowance Paid")
                {
                    ApplicationArea = All;
                }
                field("Pay Car Allowance"; "Pay Car Allowance")
                {
                    ApplicationArea = All;
                }
                field("No of Months Car Allowance"; "No of Months Car Allowance")
                {
                    ApplicationArea = All;
                }
                field("Car Allowance(Months)"; "Car Allowance(Months)")
                {
                    ApplicationArea = All;
                }
                field("No of Days for Car Allowance"; "No of Days for Car Allowance")
                {
                    ApplicationArea = All;
                }
                field("Car Allowance"; "Car Allowance")
                {
                    ApplicationArea = All;
                }
            }
            group(Totals)
            {
                Caption = 'Totals';
                field(Completed; Completed)
                {
                    Caption = 'Update Balances';
                    ApplicationArea = All;
                }
                field(Total; Total)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(PAYE)
            {
                Caption = 'PAYE';
                field("PAYE Due"; "PAYE Due")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total after PAYE"; "Total after PAYE")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Offset Leave Days"; "Offset Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Amount In Lieu of Notice"; "Amount In Lieu of Notice")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Payable)
            {
                Caption = 'Payable';
                field("Total Deductions"; "Total Deductions")
                {
                    ApplicationArea = All;
                }
                field("Amount Payable"; "Amount Payable")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

        }
    }

    actions
    {
        area(processing)
        {
            action("Employee Termination Report")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    HRSeparation.RESET;
                    HRSeparation.SETRANGE("Employee No.", "Employee No.");
                    IF HRSeparation.FINDSET THEN BEGIN
                        REPORT.RUN(75089, TRUE, TRUE, HRSeparation);
                    END;
                end;
            }

            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                RunObject = page "Document Attachment Details";
                RunPageLink = "No." = field("Separation No");

            }
            action("Mark As Processed")
            {
                Image = Save;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    HRManagement.UpdateSeparationInfo(Rec);
                end;
            }
        }
    }

    var
        smtpsetup: Record 409;
        approvalentries: Record 454;
        ApprovalEntry: Record 454;
        Employee: Record 5200;
        HRsetup: Record 5218;
        LeaveLedgerEntry: Record 50209;
        EmployeeDocuments: Record 50228;
        HRSeparation: Record 50237;
        SeperationSetup: Record 50238;
        TerminalDues: Record 50243;
        smtpcu: Codeunit 400;
        fileCU: Codeunit 419;
        FileManagement: Codeunit 419;
        CalMgt: Codeunit 7600;
        // EmployeeTerminationReport: Report 50271;
        HRManagement: Codeunit 50050;
        ok: Boolean;

        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        //  ApprovalMgt: Codeunit 1535;
        //  approvalsmgmt: Codeunit 1535;
        seesubmit: Boolean;
        seeterminaldues: Boolean;
        sendapproval: Boolean;
        CalendarCode: Code[10];
        cDay: Date;
        lastdate: Date;
        MonthBegin: Date;
        MonthEnd: Date;
        newdate: Date;
        addedbackdays: Decimal;
        basicsalary: Decimal;
        days: Decimal;
        daysBF: Decimal;
        leaveearned: Decimal;
        recalleddays: Decimal;
        useddays: Decimal;
        daycounter: Integer;
        DaysInMonth: Integer;
        doccounter: Integer;
        MonthNo: Integer;
        NoOfDaysInMonth: Integer;
        year1: Integer;
        year2: Integer;
        YearNo: Integer;
        TEXT001: Label '%1 %2 has been approved successfully.';
        TEXT002: Label 'Separate Employee.';
        DescriptionText: Text;

        documentname: Text;
        mailbody: Text;
        mailheader: Text;
        Month: Text;
        Month2: Text;
        filename: Text[150];
        docname: Text[200];
        filename2: Text[200];
        SeparationFile: Text[200];
}

