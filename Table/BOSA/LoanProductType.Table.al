table 50102 "Loan Product Type"
{
    // version TL2.0

    DrillDownPageID = 50213;
    LookupPageID = 50213;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Editable = true;
        }
        field(2; Description; Text[30])
        {

        }
        field(3; "Interest Rate"; Decimal)
        {
        }
        field(5; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(6; "Grace Period"; DateFormula)
        {
        }
        field(7; "Rounding Precision"; Decimal)
        {
            InitValue = 1;
            MaxValue = 1;
            MinValue = 0.01;
        }
        field(8; "Min. Loan Amount"; Decimal)
        {
        }
        field(9; "Max. Loan Amount"; Decimal)
        {
        }
        field(10; Category; Option)
        {
            OptionCaption = 'All,BOSA,FOSA,Micro';
            OptionMembers = All,BOSA,FOSA,Micro;
        }

        field(12; "Interest Income Account"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CreateCustomerPostingGroup("Interest Income Account");
            end;
        }
        field(13; "Interest Accrued Account"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CreateCustomerPostingGroup("Interest Accrued Account");
            end;
        }
        field(15; "Repayment Period"; Decimal)
        {
        }
        field(16; "Min. Membership period"; DateFormula)
        {
        }
        field(17; "Repayment Method"; Option)
        {
            OptionCaption = 'Straight Line,Reducing Balance,Amortization';
            OptionMembers = "Straight Line","Reducing Balance",Amortization;
        }
        field(18; Active; Boolean)
        {
        }
        field(20; "Repayment Frequency"; Option)
        {
            OptionCaption = 'Daily,Weekly,Monthly,Quarterly,Annually';
            OptionMembers = Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually;
        }
        field(21; "E-Loan"; Boolean)
        {
        }
        field(23; "No. of Guarantors"; Integer)
        {
        }
        field(24; "Recovery Method"; Option)
        {
            OptionCaption = 'On Due Date,On End Month';
            OptionMembers = "On Due Date","On End Month";
        }

        field(27; "Loan Deposit Ratio"; Integer)
        {
        }
        field(29; "No. of Loans at a Time"; Integer)
        {
        }
        field(30; "Turn Around Time"; Integer)
        {
        }
        field(31; "Loan Savings Ratio"; Integer)
        {
        }
        field(32; "More Rates"; Boolean)
        {
        }
        field(33; "Defaulter Loan"; Boolean)
        {
        }
        field(34; "Based on Savings"; Boolean)
        {
        }

        field(37; "Paybill Short Code"; Code[20])
        {
        }
        field(38; "Based on Deposits"; Boolean)
        {
        }
        field(39; "E-Loan Threshold"; Decimal)
        {
        }
        field(40; "Loan Shares Ratio"; Integer)
        {
        }
        field(53; "Based on Shares"; Boolean)
        {
        }
        field(54; "Loan Class"; Option)
        {
            OptionCaption = ' ,Farm Produce,Salary Based,Business Based,E-Loan';
            OptionMembers = " ","Farm Produce","Salary Based","Business Based","E-Loan";
        }
        field(55; "Loan Posting Group"; Code[20])
        {
            TableRelation = "Customer Posting Group";
        }
        field(56; "Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }

        field(57; "Membership Category"; Option)
        {
            OptionCaption = 'All,Individual,Group,Joint,Company';
            OptionMembers = "All","Individual","Group","Joint","Company";

        }
        field(62; "Security Type"; Option)
        {
            OptionCaption = 'Both,Guarantors Only,Security Only,Either';
            OptionMembers = Both,"Guarantors Only","Security Only",Either;
        }
        field(63; "Apply Graduation Schedule"; Boolean)
        {
        }
        field(64; "Allow Refinancing"; Boolean)
        {
        }
        field(65; "Refinancing Mode"; Option)
        {
            OptionCaption = 'Same Product,Different Product,Both';
            OptionMembers = "Same Product","Different Product",Both;
        }
        field(66; "Member Class"; Option)
        {
            OptionMembers = Both,"Members Only","Staff Only";
        }
        field(67; "Apply 1/3 Rule"; Boolean)
        {
        }
        field(68; "Attachment Mandatory"; Boolean)
        {
        }
        field(69; "Interest Control Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(70; "Interest Realization Mode"; Option)
        {
            Caption = 'Realize Interest on Capitalization';
            OptionCaption = 'On Payment,On Capitalization';
            OptionMembers = "On Payment","On Capitalization";
        }


        field(74; "Interest Cap. Frequency"; Option)
        {
            OptionCaption = 'On Due Date,On Every';
            OptionMembers = "On Due Date","On Every";
        }
        field(75; "Interest Cap. Day"; Integer)
        {
        }
        field(76; "Boost on Recovery"; Boolean)
        {
        }
        field(77; "Insurance Rate"; Decimal)
        {
        }
        field(78; "Insurance Account"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }

    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CreateCustomerPostingGroup(Code);
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CBSSetup: Record "CBS Setup";
        loanproducts: Record "Loan Product Type";
        //MembershipManagement: Codeunit "50000";
        RecRef: RecordRef;
        XRecRef: RecordRef;
        "Trigger": Option OnCreate,OnModify;
        /*  [RunOnClient]
         IPAddress: DotNet IPAddress;
         [RunOnClient]
         DNS: DotNet Dns;
         HostName: Code[30];
         [RunOnClient]
         IPHostEntry: DotNet IPHostEntry;
         [RunOnClient]
         GetIPMacAddress: DotNet GetIPMac; */
        HostMacAddress: Text[100];

    local procedure GetHostInfo()
    begin
        /*  HostName:=DNS.GetHostName();
         IPHostEntry:=DNS.GetHostEntry(HostName);
         IPAddress:=IPHostEntry.AddressList();
         CLEAR(GetIPMacAddress);
         GetIPMacAddress := GetIPMacAddress.GetIPMac; */
    end;

    local procedure CreateCustomerPostingGroup(PostingGroupCode: Code[20])
    var
        CustomerPostingGroup: Record "Customer Posting Group";
        GLAccount: Record "G/L Account";
    begin
        IF NOT CustomerPostingGroup.GET(PostingGroupCode) THEN BEGIN
            CustomerPostingGroup.INIT;
            CustomerPostingGroup.Code := PostingGroupCode;
            CustomerPostingGroup."Receivables Account" := PostingGroupCode;
            IF GLAccount.GET(PostingGroupCode) THEN
                CustomerPostingGroup.Description := GLAccount.Name;
            CustomerPostingGroup.INSERT;
        END;
    end;
}

