codeunit 51180 "ATM API Integration"
{
    // version TL2.0


    trigger OnRun();
    begin
    end;

    var
        GenJournalLine: Record "Gen. Journal Line" temporary;
        GenJournalLine2: Record "Gen. Journal Line" temporary;
        LineNo: Integer;
        Vendor: Record Vendor;
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        Customer: Record Customer;
        TransactionTypes: Record "Transaction -Type";
        TransactionCharges: Record "Transaction Charge";
        ATMApplication: Record "ATM Application";
        SettlementAmount: array[4] of Decimal;
        SettlementAccount: array[4] of Code[20];
        MemberBalance: array[4] of Decimal;
        GeneralLedgerSetup: Record "General Ledger Setup";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        i: Integer;
        Text000: Label 'Entry been reversed successfully.';
        //SendSMS: Codeunit "50004";
        PhoneNo: Text[20];
        ATMEntries: Record "ATM Ledger Entry";
        EntryNo: Integer;
        Ministatement: array[4] of Text[1024];
        ActualBalance: Decimal;
        AccountTypes: Record "Account Type";
        ActualBal: Decimal;
        AvailableBal: Decimal;
        Text2: Text;
        j: Integer;
        GLEntry: Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";
        charge: Decimal;
        exciseDuty: Decimal;
        sln: Integer;
        m: Integer;
        newText: Text;
        Text0001: Label 'ATM Commission';
        SaccoID: Code[20];
        AccountNo: Code[20];
        MessID: Code[20];
        Transactionamount: Decimal;
        Transactionamount2: Text;
        bbalance: Decimal;
        bbalance2: Text;
        TEXT005: Label 'Withdrawal Amount';
        TEXT003: Label 'Settlement Amount';
        TEXT004: Label 'Excise Duty';
        TEXT002: Label 'Charge Amount';
        currentbalance: Decimal;
        currentbalance2: Text;
        thischar: Label '''<''';
        thisstring: Label '<currentBalance>%1</currentBlance>';
        EnquiryAmount: Decimal;
        MinistatementAmount: Decimal;
        EnquiryType: Code[10];
        ChannelType: Code[20];
        POSTransactionAmount: Decimal;
        PesalinkAmount: Decimal;

    procedure getBalanceEnquiry(var TransactionDate: DateTime; var ResponseCode: Code[50]; var CreditAccount: Text; var DebitAccount: Text; var Description: Code[30]; var ActualBalance: Decimal; var AvailableBalance: Decimal; var InstitutionCode: Code[50]; var terminalID: Code[20]);
    begin
        SaccoID := COPYSTR(DebitAccount, 1, (STRLEN(DebitAccount) - 8));
        EnquiryType := COPYSTR(terminalID, 1, 3);
        JournalTemplateName := 'GENERAL';
        JournalBatchName := 'ATM';
        ATMApplication.RESET;
        ATMApplication.SETRANGE("Card No.", DebitAccount);
        IF ATMApplication.FINDSET THEN BEGIN
            AccountNo := ATMApplication."Account No.";
        END;
        ATMApplication.RESET;
        ATMApplication.SETRANGE("Account No.", AccountNo);
        IF ATMApplication.FINDFIRST THEN BEGIN
            IF Vendor.GET(ATMApplication."Account No.") THEN;
            IF ATMApplication.Status <> ATMApplication.Status::Approved THEN BEGIN
                ResponseCode := '406';
                Description := 'Card is Inactive';
                EXIT;
            END;
        END ELSE BEGIN
            ResponseCode := '300';
            Description := 'Account not found';
            EXIT;
        END;

        TransactionDate := CURRENTDATETIME;
        ActualBalance := GetActualBalance(AccountNo);
        AvailableBalance := GetMemberBalance(AccountNo);
        DebitAccount := DebitAccount;
        CreditAccount := '2580';
        ResponseCode := '200';
        Description := 'Success';
        InstitutionCode := SaccoID;
        IF EnquiryType = 'POS' THEN BEGIN
            TransactionTypes.RESET;
            TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Balance Inquiry-POS Normal");
            IF TransactionTypes.FINDFIRST THEN BEGIN
                ClearLines(MessID);
                TransactionCharges.RESET;
                TransactionCharges.SETRANGE("Transaction Type Code", TransactionTypes.Code);
                IF TransactionCharges.FINDFIRST THEN;
                EnquiryAmount := TransactionCharges."Settlement Amount  (SACCO)"; //ERROR('%1',EnquiryAmount);
                MessID := 'POS Balance Inq';
                GetTransactionCharges('POSBALANCE', '0001', AccountNo, AvailableBalance);
                IF AvailableBalance >= EnquiryAmount THEN BEGIN
                    CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'POS Inquiry Settlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                    CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'POS Inquiry Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                    CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));

                    CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'POS Inquiry Charge Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));
                    PostJournal2(JournalTemplateName, JournalBatchName);

                END;
                ActualBalance := GetMemberBalance(AccountNo);
                AvailableBalance := GetActualBalance(AccountNo);
            END;
        END ELSE BEGIN
            EnquiryAmount := TransactionCharges."Settlement Amount  (SACCO)";
            ActualBalance := GetMemberBalance(AccountNo);
            AvailableBalance := GetActualBalance(AccountNo);
        END;
        EXIT;
    end;

    procedure sendFundsTransfer(var TransactionDate: DateTime; var Channel: Code[10]; var TransactionType: Code[10]; var DebitAccount: Code[100]; var ResponseCode: Code[20]; var Description: Text[100]; var TotalAmount: Decimal; var CreditAccount: Code[10]; var ChargeAmount: Decimal; var FeeAmount: Decimal; var InstitutionCode: Text; var TransactionReference: Text; var OriginalMessageID: Code[20]; var MessageID: Code[50]; var AccountBookBalance: Decimal; var AccountClearedBalance: Decimal);
    var
        NoofRecords: array[4] of Integer;
        GLEntry2: Record "G/L Entry";
    begin
        SaccoID := COPYSTR(DebitAccount, 1, (STRLEN(DebitAccount) - 8));
        MessID := COPYSTR(MessageID, 1, 12);
        ChannelType := COPYSTR(Channel, 1, 6);
        JournalTemplateName := 'GENERAL';
        JournalBatchName := 'ATM';
        ATMApplication.RESET;
        ATMApplication.SETRANGE("Card No.", DebitAccount);
        IF ATMApplication.FINDSET THEN BEGIN
            AccountNo := ATMApplication."Account No.";
        END;
        IF TransactionType <> '1420' THEN BEGIN
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Document No.", MessID);
            IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                ResponseCode := '405';
                Description := 'Duplicate Transaction';
                EXIT;
            END;
        END;
        IF TransactionType = '0009' THEN BEGIN
            ResponseCode := '404';
            Description := 'The task/operation does not exist.';
            EXIT;
        END;
        IF TransactionType <> '1420' THEN BEGIN
            ATMApplication.RESET;
            ATMApplication.SETRANGE("Card No.", DebitAccount);
            IF ATMApplication.FINDFIRST THEN BEGIN
                IF Vendor.GET(ATMApplication."Account No.") THEN;
                IF ATMApplication.Status <> ATMApplication.Status::Approved THEN BEGIN
                    ResponseCode := '406';
                    Description := ('Card is not Active');
                    EXIT;
                END;
            END ELSE BEGIN
                ResponseCode := '300';
                Description := 'Account not found';
                EXIT;
            END;

            IF TransactionType <> '0010' THEN BEGIN
                IF TransactionType <> '0027' THEN BEGIN
                    IF TotalAmount > GetActualBalance(AccountNo) THEN BEGIN
                        ResponseCode := '402';
                        Description := 'Insufficient funds';
                        EXIT;
                    END;
                END;
                IF TransactionType = '0027' THEN BEGIN
                    IF ChargeAmount > GetActualBalance(AccountNo) THEN BEGIN
                        ResponseCode := '402';
                        Description := 'Insufficient funds';
                        EXIT;
                    END;


                END;
            END;
        END;
        GeneralLedgerSetup.GET;
        TransactionTypes.RESET;
        CASE TransactionType OF
            '0001':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Withdrawal-POS VISA");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('ATMUTILITY', '0001', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Mpesa Transfer ', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'Mpesa Transfer ' + DebitAccount, -TotalAmount, GetBranchCode(AccountNo));
                        PostJournal2(JournalTemplateName, JournalBatchName);

                        CreateATMEntry(AccountNo, MessID, 'Mpesa B2C' + MessID, TotalAmount, Description, '');
                        CreateSMS(DebitAccount, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := '2580';
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);


                    END;
                END;
            '0004':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Utility Payment-POS Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('KPLC', '0002', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'KPLC postpaid', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[4], 'KPLC postpaid', -SettlementAmount[4], GetBranchCode(AccountNo));

                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'KPLC Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'KPLCSettlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));


                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'KPLC Charge Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));



                        PostJournal2(JournalTemplateName, JournalBatchName);
                        CreateATMEntry(AccountNo, MessID, 'KPLC postpaid ' + MessID, TotalAmount, Description, '');
                        CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := AccountNo;
                        InstitutionCode := SaccoID;
                        MessID := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);

                        EXIT;
                    END;
                END;
            '0005':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Paybill-Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('KPLC', '0002', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'KPLC prepaid', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[4], 'KPLC prepaid', -SettlementAmount[4], GetBranchCode(AccountNo));

                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'KPLC Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'KPLCSettlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));

                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'KPLC Charge Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));


                        PostJournal2(JournalTemplateName, JournalBatchName);
                        AvailableBal := GetMemberBalance(Vendor."No.");
                        CreateATMEntry(DebitAccount, MessID, 'KPLC prepaid ' + MessID, TotalAmount, Description, '');
                        CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := AccountNo;
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);
                        EXIT;
                    END;
                END;
            '0006':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Paybill-Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('ATMUTILITY', '0001', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'DSTV ', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'DSTV ' + DebitAccount, -TotalAmount, GetBranchCode(AccountNo));
                        PostJournal2(JournalTemplateName, JournalBatchName);
                        AvailableBal := GetMemberBalance(Vendor."No.");
                        CreateATMEntry(AccountNo, MessID, 'DSTV ' + MessID, TotalAmount, Description, '');
                        CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := AccountNo;
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);
                        EXIT;
                    END;
                END;
            '0007':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Paybill-Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('ATMUTILITY', '0001', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'ZUKU Payment ', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'ZUKU ' + DebitAccount, -TotalAmount, GetBranchCode(AccountNo));
                        PostJournal2(JournalTemplateName, JournalBatchName);
                        AvailableBal := GetMemberBalance(Vendor."No.");
                        CreateATMEntry(AccountNo, MessID, 'ZUKU ' + MessID, TotalAmount, Description, '');
                        CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := CreditAccount;
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);
                        EXIT;
                        //END;
                    END;
                END;
            '0008':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Paybill-Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('ATMUTILITY', '0001', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Safaricom Airtime purchase ', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'Safaricom Airtime purchase ' + DebitAccount, -TotalAmount, GetBranchCode(AccountNo));
                        PostJournal2(JournalTemplateName, JournalBatchName);
                        AvailableBal := GetMemberBalance(Vendor."No.");
                        CreateATMEntry(AccountNo, MessID, 'Safaricom Airtime purchase ' + MessID, TotalAmount, Description, '');
                        CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := CreditAccount;
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);
                        EXIT;
                    END;
                END;
            '0009':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::PesaLink);
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        PesalinkAmount := TotalAmount;
                        ClearLines(MessID);
                        GetTransactionCharges('PESALINK', '0009', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Pesalink', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[4], 'Pesalink', -SettlementAmount[4], GetBranchCode(AccountNo));

                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'Pesalink Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'Pesalink Settlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));

                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Pesalink Charge Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));

                        PostJournal2(JournalTemplateName, JournalBatchName);
                        AvailableBal := GetMemberBalance(Vendor."No.");
                        CreateATMEntry(AccountNo, MessID, 'PesaLink ' + MessID, TotalAmount, Description, '');
                        CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '404';
                        Description := 'The task/operation does not exist.';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := AccountNo;
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);
                        EXIT;
                    END;
                END;
            '0010':
                BEGIN

                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Deposit-POS Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('POSDEP', '0001', AccountNo, TotalAmount);

                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'POS Cash deposit ', -TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'POS Cash deposit ' + DebitAccount, TotalAmount, GetBranchCode(AccountNo));
                        PostJournal2(JournalTemplateName, JournalBatchName);

                        AvailableBal := GetMemberBalance(Vendor."No.");
                        CreateATMEntry(AccountNo, MessID, 'POS Cash deposit ' + MessID, TotalAmount, Description, '');
                        CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(ABS(TotalAmount)) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := ABS(TotalAmount);
                        CreditAccount := AccountNo;
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := ABS(GetActualBalance(AccountNo));

                        EXIT;
                    END;
                END;
            '0011':
                BEGIN
                    IF ((COPYSTR(Channel, 1, 3) = 'POS') AND (COPYSTR(Channel, 1, 5) <> 'POSBR')) THEN BEGIN
                        TransactionTypes.RESET;
                        TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Withdrawal-POS Normal");
                        IF TransactionTypes.FINDFIRST THEN BEGIN
                            POSTransactionAmount := TotalAmount;
                            ClearLines(MessID);
                            GetTransactionCharges('POSWTH', '0012', AccountNo, TotalAmount);
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'POS Cash Withdrawal', TotalAmount, GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[4], 'POS Cash Withdrawal', -SettlementAmount[4], GetBranchCode(AccountNo));

                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'POS Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'POS Settlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));

                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'POS Charge Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));



                            PostJournal2(JournalTemplateName, JournalBatchName);

                            ResponseCode := '200';
                            Description := 'SUCCESS';
                            TransactionDate := CREATEDATETIME(TODAY, TIME);
                            DebitAccount := AccountNo;
                            TotalAmount := TotalAmount;
                            CreditAccount := AccountNo;
                            InstitutionCode := SaccoID;
                            TransactionReference := MessID;
                            AccountBookBalance := GetMemberBalance(AccountNo);
                            AccountClearedBalance := GetActualBalance(AccountNo);
                            CreateATMEntry(AccountNo, MessID, 'POS Cash Withdrawal ' + MessID, TotalAmount, Description, '');
                            CreateSMS(DebitAccount, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        END;
                    END;

                    IF COPYSTR(Channel, 1, 2) = '00' THEN BEGIN
                        TransactionTypes.RESET;
                        TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Withdrawal-Normal");
                        IF TransactionTypes.FINDFIRST THEN BEGIN
                            ClearLines(MessID);
                            GetTransactionCharges('ATMWTH', '0011', AccountNo, TotalAmount);
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'ATM Cash Withdrawal', TotalAmount, GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[4], 'ATM Cash Withdrawal', -SettlementAmount[4], GetBranchCode(AccountNo));

                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'ATM Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'ATM Settlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));

                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'ATM Charge Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));




                            PostJournal2(JournalTemplateName, JournalBatchName);

                            ResponseCode := '200';
                            Description := 'SUCCESS';
                            TransactionDate := CREATEDATETIME(TODAY, TIME);
                            DebitAccount := AccountNo;
                            TotalAmount := TotalAmount;
                            CreditAccount := AccountNo;
                            InstitutionCode := SaccoID;
                            TransactionReference := MessID;
                            AccountBookBalance := GetMemberBalance(AccountNo);
                            AccountClearedBalance := GetActualBalance(AccountNo);
                            CreateATMEntry(AccountNo, MessID, 'Cash Withdrawal ' + MessID, TotalAmount, Description, '');
                            CreateSMS(DebitAccount, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        END;

                    END;
                    IF COPYSTR(Channel, 1, 5) = 'POSBR' THEN BEGIN
                        TransactionTypes.RESET;
                        TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"Agency Withdrawal");
                        IF TransactionTypes.FINDFIRST THEN BEGIN
                            ClearLines(MessID);
                            GetTransactionCharges('POSBRANCH', '0011', AccountNo, TotalAmount);
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'POS Branch Withdrawal', TotalAmount, GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[4], 'POS Branch Withdrawal', -SettlementAmount[4], GetBranchCode(AccountNo));

                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'POS Branch Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'POS Branch Settlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));

                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'POS Branch Charge Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));




                            PostJournal2(JournalTemplateName, JournalBatchName);

                            ResponseCode := '200';
                            Description := 'SUCCESS';
                            TransactionDate := CREATEDATETIME(TODAY, TIME);
                            DebitAccount := AccountNo;
                            TotalAmount := TotalAmount;
                            CreditAccount := AccountNo;
                            InstitutionCode := SaccoID;
                            TransactionReference := MessID;
                            AccountBookBalance := GetMemberBalance(AccountNo);
                            AccountClearedBalance := GetActualBalance(AccountNo);
                            CreateATMEntry(AccountNo, MessID, 'Cash Withdrawal ' + MessID, TotalAmount, Description, '');
                            CreateSMS(DebitAccount, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        END;
                    END;
                    IF ((COPYSTR(Channel, 1, 5) <> 'POSBR') AND (COPYSTR(Channel, 1, 2) <> '00') AND (COPYSTR(Channel, 1, 3) <> 'POS')) THEN BEGIN
                        TransactionTypes.RESET;
                        TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Withdrawal-VISA");
                        IF TransactionTypes.FINDFIRST THEN BEGIN
                            ClearLines(MessID);
                            GetTransactionCharges('VISAWTH', '0011', AccountNo, TotalAmount);
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'VISA Cash Withdrawal', TotalAmount, GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[4], 'VISA Cash Withdrawal', -SettlementAmount[4], GetBranchCode(AccountNo));

                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'VISA Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'VISA Settlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));

                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'VISA Charge Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));




                            PostJournal2(JournalTemplateName, JournalBatchName);

                            ResponseCode := '200';
                            Description := 'SUCCESS';
                            TransactionDate := CREATEDATETIME(TODAY, TIME);
                            DebitAccount := AccountNo;
                            TotalAmount := TotalAmount;
                            CreditAccount := AccountNo;
                            InstitutionCode := SaccoID;
                            TransactionReference := MessID;
                            AccountBookBalance := GetMemberBalance(AccountNo);
                            AccountClearedBalance := GetActualBalance(AccountNo);
                            CreateATMEntry(AccountNo, MessID, 'Cash Withdrawal ' + MessID, TotalAmount, Description, '');
                            CreateSMS(DebitAccount, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        END;
                    END;
                END;
            '0012':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Withdrawal-POS VISA");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('VISAWTH', '0011', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'VISA Cash Withdrawal', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[4], 'VISA Cash Withdrawal', -SettlementAmount[4], GetBranchCode(AccountNo));

                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'VISA Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'VISA Settlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));

                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'VISA Charge Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));



                        PostJournal2(JournalTemplateName, JournalBatchName);

                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := AccountNo;
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);
                        CreateATMEntry(AccountNo, MessID, 'Cash Withdrawal ' + MessID, TotalAmount, Description, '');
                        CreateSMS(DebitAccount, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);


                    END;
                END;

            '0013':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Paybill-Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('ATMUTILITY', '0001', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Safaricom C2B ', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'Safaricom C2B ' + DebitAccount, -TotalAmount, GetBranchCode(AccountNo));
                        PostJournal2(JournalTemplateName, JournalBatchName);
                        CreateATMEntry(AccountNo, MessID, 'Safaricom C2B' + MessID, TotalAmount, Description, '');
                        CreateSMS(DebitAccount, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := '2580';
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);

                        EXIT;

                    END;
                END;

            '0015':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Paybill-Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('ATMUTILITY', '0001', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Airtel Airtime purchase ', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'Safaricom Airtime purchase ' + DebitAccount, -TotalAmount, GetBranchCode(AccountNo));
                        PostJournal2(JournalTemplateName, JournalBatchName);
                        AvailableBal := GetMemberBalance(Vendor."No.");
                        CreateATMEntry(AccountNo, MessID, 'Airtel Airtime purchase ' + MessID, TotalAmount, Description, '');
                        CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := CreditAccount;
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);
                        EXIT;
                    END;
                END;
            '0017':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Paybill-Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('NWP', '0002', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Nairobi water bill payment', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[4], 'Nairobi water bill payment', -SettlementAmount[4], GetBranchCode(AccountNo));

                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'Settlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));

                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Settlement Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));



                        PostJournal2(JournalTemplateName, JournalBatchName);
                        AvailableBal := GetMemberBalance(Vendor."No.");
                        CreateATMEntry(AccountNo, MessID, 'Nairobi water bill payment ' + MessID, TotalAmount, Description, '');
                        CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := CreditAccount;
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);
                        EXIT;
                    END;
                END;
            '0020':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Paybill-Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('ATMUTILITY', '0001', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Airtel B2C ', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'Airtel B2C ', -TotalAmount, GetBranchCode(AccountNo));
                        PostJournal2(JournalTemplateName, JournalBatchName);
                        CreateATMEntry(AccountNo, MessID, 'Airtel B2C' + MessID, TotalAmount, Description, '');
                        CreateSMS(DebitAccount, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := '2580';
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);
                        EXIT;

                    END;
                END;
            '0021':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Paybill-Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('ATMUTILITY', '0001', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Telkom B2C ', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'Telkom B2C ', -TotalAmount, GetBranchCode(AccountNo));
                        PostJournal2(JournalTemplateName, JournalBatchName);
                        CreateATMEntry(AccountNo, MessID, 'Telkom B2C' + MessID, TotalAmount, Description, '');
                        CreateSMS(DebitAccount, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := '2580';
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);

                        EXIT;

                    END;
                END;
            '0027':
                BEGIN
                    IF COPYSTR(Channel, 1, 3) = 'POS' THEN BEGIN
                        TransactionTypes.RESET;
                        TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Buy Goods & Services-Normal");
                        IF TransactionTypes.FINDFIRST THEN BEGIN
                            ClearLines(MessID);
                            GetTransactionCharges('VISAPURCHASE', '0002', DebitAccount, TotalAmount);
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'COOP VISA Purchases', ChargeAmount, GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'COOP VISA Purchases', -ChargeAmount, GetBranchCode(AccountNo));

                            PostJournal2(JournalTemplateName, JournalBatchName);
                            AvailableBal := GetMemberBalance(Vendor."No.");
                            CreateATMEntry(AccountNo, MessID, 'VISA Purchases ' + MessID, TotalAmount, Description, '');
                            CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                            ResponseCode := '200';
                            Description := 'SUCCESS';
                            TransactionDate := CREATEDATETIME(TODAY, TIME);
                            DebitAccount := AccountNo;
                            TotalAmount := ChargeAmount;
                            CreditAccount := AccountNo;
                            InstitutionCode := SaccoID;
                            TransactionReference := MessID;
                            AccountBookBalance := GetMemberBalance(AccountNo);
                            AccountClearedBalance := GetActualBalance(AccountNo);
                            EXIT;
                        END;
                    END;
                    IF COPYSTR(Channel, 1, 3) <> 'POS' THEN BEGIN
                        TransactionTypes.RESET;
                        TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Buy Goods & Services-Normal");
                        IF TransactionTypes.FINDFIRST THEN BEGIN
                            ClearLines(MessID);
                            GetTransactionCharges('VISAPURCHASE2', '0002', DebitAccount, TotalAmount);
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'VISA Purchases', ChargeAmount, GetBranchCode(AccountNo));
                            CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'VISA Purchases', -ChargeAmount, GetBranchCode(AccountNo));

                            PostJournal2(JournalTemplateName, JournalBatchName);
                            AvailableBal := GetMemberBalance(Vendor."No.");
                            CreateATMEntry(AccountNo, MessID, 'VISA Purchases ' + MessID, TotalAmount, Description, '');
                            CreateSMS(AccountNo, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                            ResponseCode := '200';
                            Description := 'SUCCESS';
                            TransactionDate := CREATEDATETIME(TODAY, TIME);
                            DebitAccount := AccountNo;
                            TotalAmount := ChargeAmount;
                            CreditAccount := AccountNo;
                            InstitutionCode := SaccoID;
                            TransactionReference := MessID;
                            AccountBookBalance := GetMemberBalance(AccountNo);
                            AccountClearedBalance := GetActualBalance(AccountNo);
                            EXIT;
                        END;
                    END;
                END;
            '0026':
                BEGIN
                    TransactionTypes.RESET;
                    TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Paybill-Normal");
                    IF TransactionTypes.FINDFIRST THEN BEGIN
                        ClearLines(MessID);
                        GetTransactionCharges('ATMUTILITY', '0001', AccountNo, TotalAmount);
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'Telkom C2B ', TotalAmount, GetBranchCode(AccountNo));
                        CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"Bank Account", SettlementAccount[2], 'Telkom C2B ', -TotalAmount, GetBranchCode(AccountNo));
                        PostJournal2(JournalTemplateName, JournalBatchName);
                        CreateATMEntry(AccountNo, MessID, 'Telkom C2B' + MessID, TotalAmount, Description, '');
                        CreateSMS(DebitAccount, 'Dear Member, a debit of Ksh ' + FORMAT(TotalAmount) + ' has been done on your account ' + AccountNo);
                        ResponseCode := '200';
                        Description := 'SUCCESS';
                        TransactionDate := CREATEDATETIME(TODAY, TIME);
                        DebitAccount := AccountNo;
                        TotalAmount := TotalAmount;
                        CreditAccount := '2580';
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);

                        EXIT;

                    END;
                END;
            '1420':
                BEGIN
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", MessID);
                    GLEntry.SETRANGE(Reversed, TRUE);
                    IF GLEntry.FINDSET THEN BEGIN
                        Description := 'Duplicate Transmission';
                        ResponseCode := '405';
                        InstitutionCode := SaccoID;
                        EXIT;
                    END;
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", MessID);
                    // GLEntry.SETFILTER("Document No.",'');
                    IF NOT GLEntry.FINDSET THEN BEGIN
                        Description := 'The task/operation does not exist.';
                        ResponseCode := '404';
                        InstitutionCode := SaccoID;
                        EXIT;
                    END;
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", MessID);
                    GLEntry.SETRANGE(Reversed, FALSE);
                    IF GLEntry.FINDSET THEN BEGIN
                        REPEAT
                            ReversalEntry.RESET;
                            ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                        UNTIL GLEntry.NEXT = 0;
                        Description := 'Reversal Successful';
                        ResponseCode := '200';
                        InstitutionCode := SaccoID;
                        TransactionReference := MessID;
                        AccountBookBalance := GetMemberBalance(AccountNo);
                        AccountClearedBalance := GetActualBalance(AccountNo);
                        EXIT;
                    END;
                END;
        END;

    end;

    procedure sendMinistatement(var MessageID: Code[30]; var MaxNumberRows: Integer; var MobileNumber: Code[20]; var DebitAccount: Code[20]; var CreditAccount: Code[30]; var ChargeAmount: Decimal; var FeeAmount: Decimal; var ResponseCode: Code[10]; var Description: Code[30]; var MiniStatement: Text; var terminalID: Code[20]);
    begin

        ATMApplication.RESET;
        ATMApplication.SETRANGE("Card No.", DebitAccount);
        IF ATMApplication.FINDSET THEN BEGIN
            AccountNo := ATMApplication."Account No.";
        END;

        ATMApplication.RESET;
        ATMApplication.SETRANGE("Card No.", DebitAccount);
        IF ATMApplication.FINDFIRST THEN BEGIN
            IF Vendor.GET(ATMApplication."Account No.") THEN;
            IF ATMApplication.Status <> ATMApplication.Status::Approved THEN BEGIN
                ResponseCode := '406';
                Description := 'Card is Inactive';
                EXIT;
            END;
        END ELSE BEGIN
            ResponseCode := '300';
            Description := 'Account not found';
            EXIT;
        END;

        EnquiryType := COPYSTR(terminalID, 1, 3);
        IF EnquiryType = 'POS' THEN BEGIN
            TransactionTypes.RESET;
            TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"ATM Ministatement-POS Normal");
            IF TransactionTypes.FINDFIRST THEN BEGIN
                ClearLines(MessID);
                TransactionCharges.RESET;
                TransactionCharges.SETRANGE("Transaction Type Code", TransactionTypes.Code);
                IF TransactionCharges.FINDFIRST THEN;
                MinistatementAmount := TransactionCharges."Settlement Amount  (SACCO)";
                MessID := 'MNFee' + AccountNo;
                GetTransactionCharges('STATEMENT', '0001', AccountNo, GetActualBalance(AccountNo));
                IF GetActualBalance(AccountNo) >= MinistatementAmount THEN BEGIN

                    CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[2], 'POS Statement Settlement Amount', -SettlementAmount[2], GetBranchCode(AccountNo));
                    CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[1], 'POS Statement Charge Amount', -SettlementAmount[1], GetBranchCode(AccountNo));
                    CreateJournal(MessID, MessID, GenJournalLine."Account Type"::"G/L Account", SettlementAccount[3], TEXT004, -SettlementAmount[3], GetBranchCode(AccountNo));
                    CreateJournal(MessID, MessID, GenJournalLine."Account Type"::Vendor, AccountNo, 'POS Statement Charge Amount', SettlementAmount[2] + SettlementAmount[1] + SettlementAmount[3], GetBranchCode(AccountNo));




                    PostJournal2(JournalTemplateName, JournalBatchName);

                    MiniStatement := generateMini(AccountNo, MaxNumberRows);
                    ResponseCode := '200';
                    Description := 'SUCCESS';
                END;

                EXIT;
            END;
        END ELSE BEGIN
            MiniStatement := generateMini(AccountNo, MaxNumberRows);
            ResponseCode := '200';
            Description := 'SUCCESS';
        END;
    end;

    local procedure GetMemberBalance(AccountNo: Code[20]) MemberAccountBalance: Decimal;
    begin
        IF Vendor.GET(AccountNo) THEN BEGIN
            Vendor.CALCFIELDS("Balance (LCY)");
            MemberAccountBalance := ABS(Vendor."Balance (LCY)");
            EXIT(MemberAccountBalance);
        END;
    end;

    local procedure GetActualBalance(AccountNo: Code[20]) MemberAccountBalance: Decimal;
    begin
        IF Vendor.GET(AccountNo) THEN BEGIN
            AccountTypes.RESET;
            AccountTypes.SETRANGE(Code, Vendor."Vendor Posting Group");
            IF AccountTypes.FINDSET THEN BEGIN
                Vendor.CALCFIELDS("Balance (LCY)");
                MemberAccountBalance := ABS(Vendor."Balance (LCY)" - AccountTypes."Minimum Balance");
                EXIT(MemberAccountBalance);
            END;
        END;
    end;

    local procedure GetTransactionCharges(TransactionTypeCode: Code[20]; TransactionType: Code[20]; CardNo: Code[20]; Amount: Decimal);
    begin
        CASE TransactionType OF
            '0010':
                BEGIN
                    TransactionCharges.RESET;
                    TransactionCharges.SETRANGE("Transaction Type Code", TransactionTypeCode);
                    IF TransactionCharges.FINDFIRST THEN BEGIN
                        SettlementAmount[1] := TransactionCharges."Settlement Amount  (SACCO)";
                        //SettlementAccount[1] := TransactionCharges."GL Account";

                        SettlementAmount[2] := TransactionCharges."Settlement Amount (COOP)";
                        //SettlementAccount[2] := TransactionCharges."Settlement GL Account";

                        SettlementAmount[3] := (TransactionCharges."Settlement %" * SettlementAmount[1] / 100);
                        //SettlementAccount[3] := TransactionCharges."Excise G/L Account";

                        SettlementAmount[4] := SettlementAmount[1] + SettlementAmount[2] + Amount;
                    END;
                END;
            '0011':
                BEGIN
                    TransactionCharges.RESET;
                    TransactionCharges.SETRANGE("Transaction Type Code", TransactionTypeCode);
                    IF TransactionCharges.FINDFIRST THEN BEGIN
                        SettlementAmount[1] := TransactionCharges."Settlement Amount  (SACCO)";
                        //SettlementAccount[1] := TransactionCharges."GL Account";

                        SettlementAmount[2] := TransactionCharges."Settlement % (COOP)";
                        //SettlementAccount[2] := TransactionCharges."Settlement GL Account";


                        SettlementAmount[3] := (TransactionCharges."Settlement %" * SettlementAmount[1] / 100);
                        //SettlementAccount[3] := TransactionCharges."Excise G/L Account";

                        SettlementAmount[4] := Amount;
                        //SettlementAccount[4] := TransactionCharges."Settlement GL Account";
                    END;
                END;
            '0012':
                BEGIN
                    TransactionCharges.RESET;
                    TransactionCharges.SETRANGE("Transaction Type Code", TransactionTypeCode);
                    TransactionCharges.SETFILTER("Minimum Amount", '<=%1', POSTransactionAmount);
                    TransactionCharges.SETFILTER("Maximum Amount", '>=%1', POSTransactionAmount);
                    IF TransactionCharges.FINDFIRST THEN BEGIN

                        SettlementAmount[1] := TransactionCharges."Settlement Amount  (SACCO)";
                        //SettlementAccount[1] := TransactionCharges."GL Account";

                        SettlementAmount[2] := TransactionCharges."Settlement Amount (COOP)";
                        //SettlementAccount[2] := TransactionCharges."Settlement GL Account";


                        SettlementAmount[3] := (TransactionCharges."Settlement %" * SettlementAmount[1] / 100);
                        //SettlementAccount[3] := TransactionCharges."Excise G/L Account";

                        SettlementAmount[4] := Amount;
                        //SettlementAccount[4] := TransactionCharges."Settlement GL Account";
                    END;
                END;
            '0009':
                BEGIN
                    TransactionCharges.RESET;
                    TransactionCharges.SETRANGE("Transaction Type Code", TransactionTypeCode);
                    TransactionCharges.SETFILTER("Minimum Amount", '<=%1', PesalinkAmount);
                    TransactionCharges.SETFILTER("Maximum Amount", '>=%1', PesalinkAmount);
                    IF TransactionCharges.FINDFIRST THEN BEGIN

                        SettlementAmount[1] := TransactionCharges."Settlement Amount  (SACCO)";
                        //SettlementAccount[1] := TransactionCharges."GL Account";

                        SettlementAmount[2] := TransactionCharges."Settlement Amount (COOP)";
                        //SettlementAccount[2] := TransactionCharges."Settlement GL Account";


                        SettlementAmount[3] := (TransactionCharges."Settlement %" * SettlementAmount[1] / 100);
                        //SettlementAccount[3] := TransactionCharges."Excise G/L Account";

                        SettlementAmount[4] := Amount;
                        //SettlementAccount[4] := TransactionCharges."Settlement GL Account";
                    END;
                END;
            '0002':
                BEGIN
                    TransactionCharges.RESET;
                    TransactionCharges.SETRANGE("Transaction Type Code", TransactionTypeCode);
                    IF TransactionCharges.FINDFIRST THEN BEGIN
                        SettlementAmount[1] := TransactionCharges."Settlement Amount  (SACCO)";
                        // SettlementAccount[1] := TransactionCharges."GL Account";

                        SettlementAmount[2] := TransactionCharges."Settlement Amount (COOP)";
                        //SettlementAccount[2] := TransactionCharges."Settlement GL Account";


                        SettlementAmount[3] := (TransactionCharges."Settlement %" * SettlementAmount[1] / 100);
                        //SettlementAccount[3] := TransactionCharges."Excise G/L Account";

                        SettlementAmount[4] := Amount;
                        //SettlementAccount[4] := TransactionCharges."Settlement GL Account";
                    END;
                END;
            '0001':
                BEGIN
                    TransactionCharges.RESET;
                    TransactionCharges.SETRANGE("Transaction Type Code", TransactionTypeCode);
                    IF TransactionCharges.FINDSET THEN BEGIN
                        REPEAT
                            //IF ((Amount>=TransactionCharges."Minimum Amount") AND (Amount<=TransactionCharges."Maximum Amount")) THEN BEGIN
                            SettlementAmount[1] := TransactionCharges."Settlement Amount  (SACCO)";
                            //SettlementAccount[1] := TransactionCharges."GL Account";

                            SettlementAmount[2] := TransactionCharges."Settlement Amount (COOP)";
                            //SettlementAccount[2] := TransactionCharges."Settlement GL Account";

                            SettlementAmount[3] := (TransactionCharges."Settlement %" / 100) * SettlementAmount[1];
                            //SettlementAccount[3] := TransactionCharges."Excise G/L Account";


                            SettlementAmount[4] := Amount;
                        // SettlementAccount[4] := TransactionCharges."Settlement GL Account";//SettlementAmount[4]:=SettlementAmount[1]+SettlementAmount[2]+SettlementAmount[3]+Amount;
                        //END;
                        UNTIL TransactionCharges.NEXT = 0;
                    END;
                END;
        END;
    end;

    local procedure CreateJournal(DocumentNo: Code[20]; ExternalDocNo: Code[20]; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]; Description: Text[100]; Amount: Decimal; GlobalDimensionCode: Code[20]): Boolean;
    begin
        LineNo += 1000;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplateName;
        GenJournalLine."Journal Batch Name" := JournalBatchName;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."External Document No." := ExternalDocNo;
        GenJournalLine2.RESET;
        GenJournalLine2.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine2.SETRANGE("Journal Batch Name", JournalBatchName);
        /*IF GenJournalLine2.FINDLAST THEN
          LineNo:=GenJournalLine2."Line No."
        ELSE
          LineNo:=0;*/
        GenJournalLine."Line No." := LineNo;
        GenJournalLine.Description := Description;
        GenJournalLine."Account Type" := AccountType;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE("Account No.");
        GenJournalLine."Posting Date" := TODAY;
        GenJournalLine.Amount := Amount;
        GenJournalLine.VALIDATE(Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := GlobalDimensionCode;
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;

    end;

    local procedure CreateATMEntry(CardNo: Code[20]; DocumentNo: Code[20]; Description: Text[50]; Amount: Decimal; TransactionType: Code[20]; AccountNo: Code[20]);
    begin
        ATMEntries.INIT;
        ATMEntries."Card No." := CardNo;
        ATMEntries."Transaction No." := DocumentNo;
        IF ATMEntries.FINDLAST THEN
            EntryNo := ATMEntries."Entry No."
        ELSE
            EntryNo := 0;
        ATMEntries."Entry No." := EntryNo + 1;
        ATMEntries.Description := Description;
        ATMEntries."Transaction Date" := TODAY;
        ATMEntries."Transaction Time" := TIME;
        ATMEntries.Amount := Amount;
        //ATMEntries.UserID := USERID;
        //ATMEntries.TransactionType:=TransactionType;
        IF Amount <> 0 THEN
            ATMEntries.INSERT;
    end;

    local procedure GetBranchCode(AccountNo: Code[20]) BranchCode: Text[20];
    begin
        IF Vendor.GET(AccountNo) THEN BEGIN
            IF Customer.GET(Vendor."Member No.") THEN BEGIN
                BranchCode := Customer."Global Dimension 1 Code";
                EXIT(BranchCode);
            END;
        END;
    end;

    local procedure PostJournal(): Boolean;
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", JournalBatchName);
        COMMIT;
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);

        IF CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);

    end;

    local procedure CreateSMS(AccountNo: Code[20]; Message: Text[200]);
    begin
        IF Vendor.GET(AccountNo) THEN BEGIN
            IF Customer.GET(Vendor."Member No.") THEN;
            //SendSMS.Send(Customer."Mobile Phone No",Message);
        END;
    end;

    local procedure generateMini(var DebitAccount: Code[30]; var MaxRow: Integer) Text: Text;
    var
        DebitCreditFlag: Text[10];
        Amount: Decimal;
        Narration: Text[250];
        PostingDate: Date;
        TransactionDate: Date;
        BookBalance: Decimal;
        ClearedRunningBalance: Decimal;
        ChannelID: Code[20];
        TransactionReference: Code[30];
        AccountName: Code[30];
        AccountNumber: Code[30];
        ClearedRunningBalance2: Text;
    begin
        j := 0;
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE(Reversed, FALSE);
        VendorLedgerEntry.SETRANGE("Vendor No.", DebitAccount);
        VendorLedgerEntry.SETASCENDING("Entry No.", FALSE);
        IF VendorLedgerEntry.FINDSET THEN BEGIN
            Text := Text + '[';
            REPEAT
                VendorLedgerEntry.CALCFIELDS("Amount (LCY)");
                j += 1;
                BookBalance := GetMemberBalance(DebitAccount);
                ClearedRunningBalance := GetActualBalance(DebitAccount);
                ClearedRunningBalance := ABS(ClearedRunningBalance);
                ClearedRunningBalance2 := FORMAT(ClearedRunningBalance);
                ClearedRunningBalance2 := DELCHR(ClearedRunningBalance2, '=', ',');

                Transactionamount := VendorLedgerEntry."Amount (LCY)";
                IF Transactionamount < 0 THEN BEGIN
                    DebitCreditFlag := 'CR';
                END ELSE BEGIN
                    DebitCreditFlag := 'DR';
                END;
                Transactionamount := ABS(Transactionamount);
                Transactionamount2 := FORMAT(Transactionamount);
                Transactionamount2 := DELCHR(Transactionamount2, '=', ',');
                bbalance := GetMemberBalance(DebitAccount);

                bbalance := ABS(bbalance);
                bbalance2 := FORMAT(bbalance);
                bbalance2 := DELCHR(bbalance2, '=', ',');
                Text := Text + '{"TransactionReference":' + '"' + FORMAT(VendorLedgerEntry."Document No.") + '"' + ',';
                Text := Text + '"Narration":' + '"' + FORMAT(VendorLedgerEntry.Description) + '"' + ',';
                Text := Text + '"PostingDate":' + '"' + FORMAT(VendorLedgerEntry."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>');// + 'T' + FORMAT(VendorLedgerEntry."Transaction Time", 0, '<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>') + '"' + ',';
                Text := Text + '"ClearedRunningBalance":' + '"' + ClearedRunningBalance2 + '"' + ',';
                Text := Text + '"DebitCreditFlag":' + '"' + FORMAT(DebitCreditFlag) + '"' + ',';
                Text := Text + '"Amount":' + '"' + Transactionamount2 + '"' + ',';
                Text := Text + '"BookBalance":' + '"' + bbalance2 + '"' + ',';
                Text := Text + '"ChannelID":' + '"' + FORMAT(ChannelID) + '"' + ',';
                Text := Text + '"TransactionDate":' + '"' + FORMAT(VendorLedgerEntry."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>');// + 'T' + FORMAT(VendorLedgerEntry."Transaction Time", 0, '<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>') + '"' + ',';
                Text := Text + '"AccountName":' + '"' + FORMAT(VendorLedgerEntry."Vendor No.") + '"' + ',';
                Text := Text + '"AccountNumber":' + '"' + FORMAT(VendorLedgerEntry."Vendor No.") + '"' + '},';
            UNTIL (VendorLedgerEntry.NEXT = 0) OR (j = MaxRow);
            Text := Text + ']';
        END;

        sln := STRLEN(Text);
        m := sln - 1;
        Text := DELSTR(Text, m);
        Text := Text + ']';
        /*TransactionTypes.RESET;
              TransactionTypes.SETRANGE(Type,TransactionTypes.Type::"Pos Ministm");
              IF TransactionTypes.FINDFIRST THEN BEGIN
                ClearLines(MessID);
                TransactionCharges.RESET;
                TransactionCharges.SETRANGE("Transaction Type",TransactionTypes.Code);
                IF TransactionCharges.FINDFIRST THEN;
                MinistatementAmount:=TransactionCharges."Charge Amount";
                MessID:='MiniCharge';
         GetTransactionCharges('STATEMENT','0001',AccountNo,bbalance);
         IF bbalance>=MinistatementAmount THEN BEGIN
         CreateJournal(MessID,MessID,GenJournalLine."Account Type"::Vendor,AccountNo,'Mini Statement Charges'+MessID,MinistatementAmount,GetBranchCode(AccountNo));
         CreateJournal(MessID,MessID,GenJournalLine."Account Type"::"G/L Account",SettlementAccount[1],'Mini Statement Charges'+ DebitAccount,-MinistatementAmount,GetBranchCode(AccountNo));
         END;
         IF PostJournal THEN BEGIN
         bbalance:=GetMemberBalance(AccountNo);
         BookBalance:=GetActualBalance(AccountNo);
         END;
         END;*/

    end;

    procedure ClearLines(No: Code[20]);
    begin
        JournalTemplateName := 'GENERAL';
        JournalBatchName := 'ATM';
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        //GenJournalLine.SETRANGE(GenJournalLine."Document No.",No);
        GenJournalLine.DELETEALL;
    end;

    local procedure PostJournal2(var JournalTemplateName: Code[20]; var JournalBatchName: Code[20]);
    var
        TLPostGenJnl: Codeunit "TL-Post Gen Jnl";
    begin
        TLPostGenJnl.RunPostingGenJnl(GenJournalLine, JournalTemplateName, JournalBatchName);
    end;
}

