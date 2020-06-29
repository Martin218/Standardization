report 50406 "P10A Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\P10A Report.rdlc';
    Caption = 'P10A Report';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(FORMAT_DateSpecified_0___year4___;FORMAT(DateSpecified,0,'<year4>'))
            {
            }
            column(CoName;CoName)
            {
            }
            column(Employee__First_Name_;"First Name"+' '+"Middle Name"+' '+"Last Name")
            {
            }
            column(Employee__Last_Name_;"Last Name")
            {
            }
            column(Employee_PAYE;TotalTax)
            {
            }
            column(Employee_Employee__PIN_Number_;Employee."PIN Number")
            {
            }
            column(Employee__No__;"No.")
            {
            }
            column(Employee_Employee__Taxable_Income_;TaxableIncome)
            {
            }
            column(Employee_PAYE_Control5;PAYE)
            {
            }
            column(Employee_Employee__Taxable_Income__Control1000000001;Employee."Taxable Income")
            {
            }
            column(SUPPORTING_LIST_TO_THE_END_OF_YEAR_CERTIFICATECaption;SUPPORTING_LIST_TO_THE_END_OF_YEAR_CERTIFICATECaptionLbl)
            {
            }
            column(Payroll_NumberCaption;Payroll_NumberCaptionLbl)
            {
            }
            column(Employee_Caption;Employee_CaptionLbl)
            {
            }
            column(PIN_NumberCaption;PIN_NumberCaptionLbl)
            {
            }
            column(Total_Tax_KshsCaption;Total_Tax_KshsCaptionLbl)
            {
            }
            column(PERIODCaption;PERIODCaptionLbl)
            {
            }
            column(TAXABLE_PAYCaption;TAXABLE_PAYCaptionLbl)
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }
            column(P10ACaption;P10ACaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                TotalTax:=0;
                TaxableIncome:=0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Deduction);
                TLPayrollEntries.SETRANGE("Payroll Period",StartDate,EndDate);
                TLPayrollEntries.SETRANGE(Code,PAYECode);
                TLPayrollEntries.SETRANGE("Employee No",Employee."No.");
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                  REPEAT
                TaxableIncome:=TaxableIncome+ABS(TLPayrollEntries."Taxable amount");
                TotalTax:=TotalTax+ABS(TLPayrollEntries.Amount);
                UNTIL TLPayrollEntries.NEXT=0;
                END;
                IF TotalTax=0 THEN BEGIN
                  CurrReport.SKIP;
                  END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Period)
                {
                }
                field("Enter Year";Years)
                {
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

    trigger OnPreReport();
    begin

        CompRec.GET();
        CoName:=CompRec.Name;
        IF  Years=0 THEN BEGIN
           ERROR('Please Specify The YEAR For The Period');
          END;

          IF STRLEN(FORMAT(Years))<>4 THEN BEGIN
            ERROR('ENTER A FOUR DIGIT NUMBER, I.e %1',DATE2DMY(TODAY,3)-1);
            END;
           EVALUATE(MyDate,'0101'+''+FORMAT(Years));
           StartDate:=CALCDATE('<-CY>',MyDate);
           EndDate:=CALCDATE('<CY>',MyDate);
           DateSpecified:=StartDate;
           TLDeduction.RESET;
           TLDeduction.SETRANGE("PAYE Code",TRUE);
           IF TLDeduction.FINDFIRST THEN BEGIN
        PAYECode:=TLDeduction.Code;
             END;
    end;

    var
        PAYE : Decimal;
        TotalTax : Decimal;
        CompRec : Record "Company Information";
        CoName : Text[30];
        DateSpecified : Date;
        GroupCode : Code[20];
        CUser : Code[20];
        StartDate : Date;
        EndDate : Date;
        TLPayrollEntries : Record "Payroll Entries";
        TaxableIncome : Decimal;
        SUPPORTING_LIST_TO_THE_END_OF_YEAR_CERTIFICATECaptionLbl : Label 'SUPPORTING LIST TO THE END OF YEAR CERTIFICATE';
        Payroll_NumberCaptionLbl : Label 'Payroll Number';
        Employee_CaptionLbl : Label '"Employee "';
        PIN_NumberCaptionLbl : Label 'PIN Number';
        Total_Tax_KshsCaptionLbl : Label 'Total Tax Kshs';
        PERIODCaptionLbl : Label 'PERIOD';
        TAXABLE_PAYCaptionLbl : Label 'TAXABLE PAY';
        TotalsCaptionLbl : Label 'Totals';
        P10ACaptionLbl : Label 'P10A';
        Years : Integer;
        MyDate : Date;
        TLDeduction : Record "Deductions Setup";
        PAYECode : Code[10];
}

