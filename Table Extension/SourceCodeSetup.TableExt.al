tableextension 50002 SourceCodeSetupExt extends "Source Code Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Loan; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50001; "Appraisal Fee"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50002; "Insurance Fee"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50003; "Refinancing Fee"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50004; "Principal Paid"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50005; "Interest Paid"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50006; "Interest Due"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50007; "Standing Order"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50008; "Fund Transfer"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50009; Payout; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50010; Default; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50011; "Guarantor"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50012; Dividend; Code[20])
        {
            TableRelation = "Source Code";
        }

        field(50013; "Loan Recovery"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50014; "Refund"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50015; "Member Exit"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50016; "Loan Writeoff"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50017; "Loan Selloff"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50018; "Opening Balance"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50019; Remittance; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50025; CTS; Code[20])
        {
            TableRelation = "Source Code";
        }
    }

    var
        myInt: Integer;
}