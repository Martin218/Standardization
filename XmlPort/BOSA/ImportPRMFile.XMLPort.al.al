xmlport 50002 "Import PRM File"
{
    // version CTS2.0

    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                SourceTableView = WHERE(Number = CONST(1));
                textelement(AccountNo)
                {
                    Width = 20;
                }
                textelement(SerialNo)
                {
                    Width = 20;
                }
                textelement(SortCode)
                {
                    Width = 20;
                }
                textelement(Amount2)
                {
                    Width = 20;
                }
                textelement(VoucherType)
                {
                    Width = 20;
                }
                textelement(PostingDate)
                {
                    Width = 10;
                }
                textelement(ProcessingDate)
                {
                    Width = 10;
                }
                textelement(Indicator)
                {
                    Width = 10;
                }
                textelement(UnpaidReason)
                {
                    Width = 30;
                }
                textelement(UnpaidCode)
                {
                    Width = 10;
                }
                textelement(PresentingBank)
                {
                    Width = 10;
                }
                textelement(CurrencyCode)
                {
                    Width = 10;
                }
                textelement(Session2)
                {
                    Width = 10;
                }
                textelement(BankNo)
                {
                    Width = 10;
                }
                textelement(BranchNo)
                {
                    Width = 10;
                }
                textelement(SaccoAccountNo)
                {
                    Width = 10;
                }

                trigger OnAfterGetRecord()
                begin
                    Integer.SETRANGE(Number, 1, 1);
                end;

                trigger OnAfterInsertRecord()
                begin
                    i += 1;
                    ChequeClearanceLine.INIT;
                    IF i > 1 THEN BEGIN
                        WITH ChequeClearanceLine DO BEGIN
                            // MESSAGE(DocumentNo);
                            "Document No." := DocumentNo;
                            "Line No." := GetLastLineNo(DocumentNo) + 10000;
                            "Account No." := AccountNo;
                            "Serial No." := SerialNo;
                            "Sort Code" := SortCode;
                            EVALUATE(Amount, Amount2);
                            "Voucher Type" := VoucherType;
                            "Posting Date" := PostingDate;
                            "Processing Date" := ProcessingDate;
                            Indicator := Indicator;
                            "Unpaid Reason" := UnpaidReason;
                            "Unpaid Code" := UnpaidCode;
                            "Presenting Bank" := PresentingBank;
                            "Currency Code" := CurrencyCode;
                            Session := Session2;
                            "Bank No." := BankNo;
                            "Branch No." := BranchNo;
                            "Sacco Account No." := SaccoAccountNo;
                            INSERT(TRUE);
                        END;
                    END;
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

    trigger OnPostXmlPort()
    begin
        ChequeClearanceLine.RESET;
        IF ChequeClearanceLine.GET(DocumentNo, 0) THEN
            ChequeClearanceLine.DELETE;
    end;

    var
        i: Integer;
        Text000: Label 'PRM Entries imported successfully.';
        ChequeClearanceLine: Record "Cheque Clearance Line";
        DocumentNo: Code[20];
        LineNo: Integer;

    procedure SetDocumentNo(var DocNo: Code[20])
    begin
        DocumentNo := DocNo;
    end;

    local procedure GetLastLineNo(DocumentNo: Code[20]): Integer
    var
        ChequeClearanceLine2: Record "Cheque Clearance Line";
    begin
        ChequeClearanceLine2.RESET;
        ChequeClearanceLine2.SETRANGE("Document No.", DocumentNo);
        IF ChequeClearanceLine2.FINDLAST THEN
            EXIT(ChequeClearanceLine2."Line No.")
        ELSE
            EXIT(0);
    end;
}

