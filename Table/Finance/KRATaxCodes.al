table 50333 "KRA Tax Codes"
{
    // version TL 2.0

   // DrillDownPageID = 50534;
   // LookupPageID = 50534;

    fields
    {
        field(1;"Tax Code";Code[20])
        {
        }
        field(2;"Tax Description";Text[60])
        {
        }
        field(3;Percentage;Decimal)
        {
        }
        field(4;"Account Type";Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(5;"Account No.";Code[20])
        {
           /* TableRelation = IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                      Blocked=CONST(No))
                                                                                      ELSE IF (Account Type=CONST(Customer)) Customer
                                                                                      ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                                      ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                                                                                      ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                      ELSE IF (Account Type=CONST(IC Partner)) "IC Partner"
                                                                                      ELSE IF (Account Type=CONST(Employee)) Employee;
       */
       }
    }

    keys
    {
        key(Key1;"Tax Code")
        {
        }
    }

    fieldgroups
    {
    }
}

