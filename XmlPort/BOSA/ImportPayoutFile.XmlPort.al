xmlport 50001 "Import Payout File"
{
    // version TL2.0

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
                SourceTableView = SORTING(Number)
                                  WHERE(Number = CONST(1));
                textelement(MemberNo)
                {
                }
                textelement(Amount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Integer.SETRANGE(Number, 1, 1);
                end;

                trigger OnAfterInsertRecord()
                var
                    ChargeAmount: array[4] of Decimal;
                begin

                    i += 1;
                    PayoutLine.INIT;
                    IF i > 1 THEN BEGIN
                        WITH PayoutLine DO BEGIN
                            "Document No." := DocumentNo;
                            "Line No." := GetLastLineNo(DocumentNo) + 10000;
                            VALIDATE("Member No.", MemberNo);
                            VALIDATE("Account No.", GetAccountNo(MemberNo, PayoutSetup."FOSA Account Type"));
                            EVALUATE("Gross Amount", Amount);
                            ChargeAmount[1] := 0;
                            ChargeAmount[2] := 0;
                            ChargeAmount[3] := 0;
                            IF PayoutSetup."Charges Calculation Method" = PayoutSetup."Charges Calculation Method"::"Flat Amount" THEN
                                ChargeAmount[1] := PayoutSetup."Flat Amount";
                            IF PayoutSetup."Charges Calculation Method" = PayoutSetup."Charges Calculation Method"::"%" THEN
                                ChargeAmount[1] := (PayoutSetup."Charge %" / 100) * "Gross Amount";
                            IF PayoutSetup."Charge Excise Duty" THEN
                                ChargeAmount[2] := (CBSSetup."Excise Duty %" / 100) * ChargeAmount[1]
                            ELSE
                                ChargeAmount[2] := 0;
                            IF PayoutSetup."Charge Witholding Tax" THEN
                                ChargeAmount[3] := (CBSSetup."Withholding Tax %" / 100) * ChargeAmount[1]
                            ELSE
                                ChargeAmount[3] := 0;
                            "Charge Amount" := ChargeAmount[1];
                            "Excise Duty Amount" := ChargeAmount[2];
                            "Withholding Tax Amount" := ChargeAmount[3];
                            "Net Amount" := "Gross Amount" - (ChargeAmount[1] + ChargeAmount[2] + ChargeAmount[3]);
                            IF "Net Amount" > 0 THEN
                                "Net Amount" := "Net Amount"
                            ELSE
                                "Net Amount" := 0;
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
        PayoutLine.RESET;
        IF PayoutLine.GET(DocumentNo, 0) THEN
            PayoutLine.DELETE;
    end;

    trigger OnPreXmlPort()
    begin
        CBSSetup.GET;
        PayoutSetup.GET;

        PayoutLine.RESET;
        PayoutLine.SETRANGE("Document No.", DocumentNo);
        PayoutLine.DELETEALL;
    end;

    var
        Text000: Label 'Records Uploaded successfully!';
        PayoutLine: Record "Payout Line";
        i: Integer;
        DocumentNo: Code[20];
        LineNo: Integer;
        Member: Record "Member";
        PayoutSetup: Record "Payout Setup";
        CBSSetup: Record "CBS Setup";

    procedure SetPayoutNo(var PayoutNo: Code[20])
    begin
        DocumentNo := PayoutNo;
    end;

    local procedure GetLastLineNo(DocumentNo: Code[20]): Integer
    var
        PayoutLine: Record "Payout Line";
    begin
        PayoutLine.RESET;
        PayoutLine.SETRANGE("Document No.", DocumentNo);
        IF PayoutLine.FINDLAST THEN
            EXIT(PayoutLine."Line No.")
        ELSE
            EXIT(0);
    end;

    local procedure GetAccountNo(MemberNo: Code[20]; AccountTypeCode: Code[20]): Code[20]
    var
        AccountType: Record "Account Type";
        Vendor: Record "Vendor";
    begin
        AccountType.GET(AccountTypeCode);
        Vendor.RESET;
        Vendor.SETRANGE("Member No.", MemberNo);
        Vendor.SETRANGE("Account Type", AccountType.Code);
        IF Vendor.FINDFIRST THEN
            EXIT(Vendor."No.");
    end;
}

