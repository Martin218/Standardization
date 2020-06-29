report 50403 "Transfer Payroll To Journal"
{
    // version TL2.0

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                Window.UPDATE(1,Employee."First Name"+' '+Employee."Middle Name"+ ' '+Employee."Last Name");
                 CurrentRec+=1;
                 Window.UPDATE(2,((CurrentRec/Records)*10000) DIV 1);
                 GnJLineNumber:=PayrollProcessing.TransferingPayrollToJournal(Employee,GnJLineNumber);
                 GnJLineNumber:=GnJLineNumber+40;
            end;

            trigger OnPostDataItem();
            begin
                Window.CLOSE;
                MESSAGE('Transfering Payroll to Journal Successfull!');
            end;

            trigger OnPreDataItem();
            begin
                Window.OPEN('Transfering Payroll to Journal For: #1### Progress @2@@@@');
                Records:=0;
                CurrentRec:=0;
                Records:=Employee.COUNT;
                GnJLineNumber:=10;
                PayrollProcessing.ClearJournalLines();
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
        Window : Dialog;
        Records : Integer;
        CurrentRec : Integer;
        PayrollProcessing : Codeunit "Payroll Processing";
        GnJLineNumber : Integer;
}

