table 50471 "Registry SetUp"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[30])
        {
        }
        field(2; "Request ID"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(3; "Return ID"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(4; "Member File Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(5; "Staff File Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(6; "Other File Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(7; "Loan File Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(8; "File Movement ID"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(9; "Files No."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(10; "Transfer ID"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(11; "Max. Files held by a person"; Integer)
        {
        }
        field(12; "Registry Email"; Code[50])
        {
        }
        field(32; "Branch1 Active"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33; "Branch2 Active"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(34; "Branch3 Active"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(35; "Branch4 Active"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(36; "Branch5 Active"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(37; "Branch6 Active"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(38; "Branch1 InActive"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(39; "Branch2 InActive"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(40; "Branch3 InActive"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(41; "Branch4 InActive"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(42; "Branch5 InActive"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(43; "Branch6 InActive"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(44; "Branch1 Withdrawn"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(45; "Branch2 Withdrawn"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(46; "Branch3 Withdrawn"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(47; "Branch4 Withdrawn"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(48; "Branch5 Withdrawn"; Code[10])
        {
            TableRelation = "No. Series";


        }
        field(49; "Branch6 Withdrawn"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50; "Branch1 Closed"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(51; "Branch2 Closed"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(52; "Branch3 Closed"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(53; "Branch4 Closed"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(54; "Branch5 Closed"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(55; "Branch6 Closed"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(56; "Branch1 Deceased"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(57; "Branch2 Deceased"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(58; "Branch3 Deceased"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(59; "Branch4 Deceased"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(60; "Branch5 Deceased"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(61; "Branch6 Deceased"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(62; "Branch1 Volume"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(63; "Branch2 Volume"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(64; "Branch3 Volume"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(65; "Branch4 Volume"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(66; "Branch5 Volume"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(67; "Branch6 Volume"; Code[10])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

