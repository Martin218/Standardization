xmlport 50003 "Export PRM File"
{
    // version CTS2.0

    Direction = Export;
    FieldDelimiter = '<None>';
    Format = VariableText;
    TableSeparator = '<NewLine>';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Integer';
                SourceTableView = WHERE(Number = CONST(1));
                textelement(AccountNoHeaderText)
                {
                    Width = 20;

                    trigger OnBeforePassVariable()
                    begin
                        AccountNoHeaderText := 'Account No';
                    end;
                }
                textelement(SerialNoHeaderText)
                {
                    Width = 20;

                    trigger OnBeforePassVariable()
                    begin
                        SerialNoHeaderText := 'Serial No';
                    end;
                }
                textelement(SortCodeHeaderText)
                {
                    Width = 20;

                    trigger OnBeforePassVariable()
                    begin
                        SortCodeHeaderText := 'Sort Code';
                    end;
                }
                textelement(AmountHeaderText)
                {
                    Width = 20;

                    trigger OnBeforePassVariable()
                    begin
                        AmountHeaderText := 'Amount';
                    end;
                }
                textelement(VoucherTypeHeaderText)
                {
                    Width = 20;

                    trigger OnBeforePassVariable()
                    begin
                        VoucherTypeHeaderText := 'Voucher Type';
                    end;
                }
                textelement(PostingDateHeaderText)
                {
                    Width = 10;

                    trigger OnBeforePassVariable()
                    begin
                        PostingDateHeaderText := 'Posting Date';
                    end;
                }
                textelement(ProcessingDateHeaderText)
                {
                    Width = 10;

                    trigger OnBeforePassVariable()
                    begin
                        ProcessingDateHeaderText := 'Processing Date';
                    end;
                }
                textelement(IndicatorHeaderText)
                {
                    Width = 10;

                    trigger OnBeforePassVariable()
                    begin
                        IndicatorHeaderText := 'Indicator';
                    end;
                }
                textelement(UnpaidReasonHeaderText)
                {
                    Width = 30;

                    trigger OnBeforePassVariable()
                    begin
                        UnpaidReasonHeaderText := 'Unpaid Reason';
                    end;
                }
                textelement(UnpaidCodeHeaderText)
                {
                    Width = 10;

                    trigger OnBeforePassVariable()
                    begin
                        UnpaidCodeHeaderText := 'Unpaid Code';
                    end;
                }
                textelement(PresentingBankHeaderText)
                {
                    Width = 10;

                    trigger OnBeforePassVariable()
                    begin
                        PresentingBankHeaderText := 'Presenting Bank';
                    end;
                }
                textelement(CurrencyCodeHeaderText)
                {
                    Width = 10;

                    trigger OnBeforePassVariable()
                    begin
                        CurrencyCodeHeaderText := 'Currency Code';
                    end;
                }
                textelement(SessionHeaderText)
                {
                    Width = 10;

                    trigger OnBeforePassVariable()
                    begin
                        SessionHeaderText := 'Session';
                    end;
                }
                textelement(BankNoHeaderText)
                {
                    Width = 10;

                    trigger OnBeforePassVariable()
                    begin
                        BankNoHeaderText := 'Bank No';
                    end;
                }
                textelement(BranchNoHeaderText)
                {
                    Width = 10;

                    trigger OnBeforePassVariable()
                    begin
                        BranchNoHeaderText := 'Branch No';
                    end;
                }
                textelement(SaccoAccountNoHeaderText)
                {
                    Width = 10;

                    trigger OnBeforePassVariable()
                    begin
                        SaccoAccountNoHeaderText := 'Sacco AccountNo';
                    end;
                }
            }
            tableelement("Cheque Clearance Line"; "Cheque Clearance Line")
            {
                XmlName = 'ChequeClearanceLine';
                fieldelement(AccountNo; "Cheque Clearance Line"."Account No.")
                {
                    Width = 20;
                }
                fieldelement(SerialNo; "Cheque Clearance Line"."Serial No.")
                {
                    Width = 20;
                }
                fieldelement(SortCode; "Cheque Clearance Line"."Sort Code")
                {
                    Width = 20;
                }
                fieldelement(Amount; "Cheque Clearance Line".Amount)
                {
                    Width = 20;
                }
                fieldelement(VoucherType; "Cheque Clearance Line"."Voucher Type")
                {
                    Width = 20;
                }
                fieldelement(PostingDate; "Cheque Clearance Line"."Posting Date")
                {
                    Width = 10;
                }
                fieldelement(ProcessingDate; "Cheque Clearance Line"."Processing Date")
                {
                    Width = 10;
                }
                fieldelement(Indicator; "Cheque Clearance Line".Indicator)
                {
                    Width = 10;
                }
                fieldelement(UnpaidReason; "Cheque Clearance Line"."Unpaid Reason")
                {
                    Width = 30;
                }
                fieldelement(UnpaidCode; "Cheque Clearance Line"."Unpaid Code")
                {
                    Width = 10;
                }
                fieldelement(PresentingBank; "Cheque Clearance Line"."Presenting Bank")
                {
                    Width = 10;
                }
                fieldelement(CurrencyCode; "Cheque Clearance Line"."Currency Code")
                {
                    Width = 10;
                }
                fieldelement(Session; "Cheque Clearance Line".Session)
                {
                    Width = 10;
                }
                fieldelement(BankNo; "Cheque Clearance Line"."Bank No.")
                {
                    Width = 10;
                }
                fieldelement(BranchNo; "Cheque Clearance Line"."Branch No.")
                {
                    Width = 10;
                }
                fieldelement(SaccoAccountNo; "Cheque Clearance Line"."Sacco Account No.")
                {
                    Width = 10;
                }

                trigger OnPreXmlItem()
                begin
                    "Cheque Clearance Line".SETRANGE("Document No.", DocumentNo);
                end;
            }
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

    var
        Text000: Label 'PRM Entries imported successfully.';
        DocumentNo: Code[20];

    procedure SetDocumentNo(DocNo: Code[20])
    begin
        DocumentNo := DocNo;
    end;
}

