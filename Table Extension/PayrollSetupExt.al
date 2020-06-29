tableextension 50307 "Payroll Setup Ext" extends "Payroll Setup"
{
 
    
    fields
    {
        field(11; "Payroll Roundoff"; decimal)
        {

        }
        field(12; "Tax Roundoff"; Decimal)
        {

        }
        field(13; "Pension Cap"; Decimal)
        {

        }
        field(14; "Insurance Relief Cap"; Decimal)
        {

        }
        field(15; "Owner Occupier"; Code[20])
        {
            TableRelation = "Deductions Setup" where(Loan = const(false));
        }
        field(16; "NSSF Code"; Code[20])
        {
            TableRelation = "Deductions Setup" where(Loan = const(false));
        }
        field(17; "NHIF Code"; Code[20])
        {
            TableRelation = "Deductions Setup" where(Loan = const(false));
        }
        field(18; "Employer NSSF No."; Code[20])
        {

        }
        field(19; "Employer NHIF No."; Code[20])
        {

        }
        field(20; "Provident Fund Code (Employee)"; Code[20])
        {
            TableRelation = "Deductions Setup" where(Loan = const(false));
        }
        field(21; "Provident Fund Code (Employer)"; Code[20])
        {
            TableRelation = "Earnings Setup" where("Non-Cash Benefit" = const(true));
        }
        field(22; "Duty Allowance Code"; Code[20])
        {
            TableRelation = "Earnings Setup" where("Non-Cash Benefit" = const(false));
        }
        field(23; "Bonus Code"; Code[20])
        {
            TableRelation = "Earnings Setup" where("Non-Cash Benefit" = const(false));
        }
        field(24; "Arrears Code"; Code[20])
        {
            TableRelation = "Earnings Setup" where("Non-Cash Benefit" = const(false));
        }
        field(25; "House Allowance Code"; Code[20])
        {
            TableRelation = "Earnings Setup" where("Non-Cash Benefit" = const(false));
        }
        field(26; "Transport Allowance Code"; Code[20])
        {
            TableRelation = "Earnings Setup" where("Non-Cash Benefit" = const(false));
        }
        field(27; "HELB Code"; Code[20])
        {
            TableRelation = "Deductions Setup" where(Loan = const(false));
        }
        field(28; "Apply 1/3 Rule?"; Boolean)
        {

        }
        field(29; "Salary Advance Code"; Code[20])
        {
            TableRelation = "Deductions Setup" where(Loan = const(false));
        }
    }
  trigger OnInsert()
  begin
   "Primary Key":=0;
  end; 
}