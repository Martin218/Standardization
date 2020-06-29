pageextension 50493 "Employee Extension" extends "Employee Card"
{
    layout
    {

        modify("Search Name")
        {
            Visible = false;
        }
        modify(Initials)
        {
            Visible = false;
        }
        modify("Alt. Address Code")
        {
            Visible = false;
        }
        modify(Status)
        {
            Visible = false;
        }
        modify("Alt. Address End Date")
        {
            Visible = false;
        }
        modify("Alt. Address Start Date")
        {
            Visible = false;
        }

        addafter("Union Membership No.")
        {
            field("PIN Number"; "PIN Number")
            {
                ApplicationArea = All;
            }
        }
        addafter("PIN Number")
        {
            field("ID Number"; "ID Number")
            {
                ApplicationArea = All;
            }
        }
        addafter("ID Number")
        {
            field(NSSF; NSSF)
            {
                ApplicationArea = All;
            }
        }
        addafter(NSSF)
        {
            field(NHIF; NHIF)
            {
                ApplicationArea = All;
            }
        }
        addafter(NHIF)
        {
            field("Passport Number"; "Passport Number")
            {
                ApplicationArea = All;
            }
        }
        addafter("Passport Number")
        {
            field("HELB No"; "HELB No")
            {
                ApplicationArea = All;
            }
        }
        addafter("Company E-Mail")
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
        }

        addafter("Global Dimension 1 Code")
        {
            field(Department; Department)
            {
                ApplicationArea = All;
            }
        }


        addafter(Control7)
        {
            field("Employee Type"; "Employee Type")
            {
                ApplicationArea = All;
            }
        }
        addafter("Employee Type")
        {
            field("Employee Status"; "Employee Status")
            {
                ApplicationArea = All;
            }
        }

        addafter("Birth Date")
        {
            field(Age; Age)
            {
                ApplicationArea = All;
            }
        }
        addafter(Age)
        {
            field("Marital Status"; "Marital Status")
            {
                ApplicationArea = All;
            }
        }
        addafter("Marital Status")
        {
            field("Blood Type"; "Blood Type")
            {
                ApplicationArea = All;
            }
        }
        addafter("Blood Type")
        {
            field(Disability; Disability)
            {
                ApplicationArea = All;
            }
        }
        addafter("Bank Branch No.")
        {
            field("Member No."; "Member No.")
            {
                ApplicationArea = All;
            }
        }

        addafter("Employment Date")
        {
            field("Probation Period"; "Probation Period")
            {
                ApplicationArea = All;
            }
        }

        addafter("Probation Period")
        {
            field("Probation End Date"; "Probation End Date")
            {
                ApplicationArea = All;
            }
        }

        addafter("Probation End Date")
        {
            field("Extend Probation Period"; "Extend Probation Period")
            {
                ApplicationArea = All;
            }
        }
        addafter("Extend Probation Period")
        {
            field("Extension Duration"; "Extension Duration")
            {
                ApplicationArea = All;
            }
        }
        addafter("Extension Duration")
        {
            field("Reason For Extension"; "Reason For Extension")
            {
                ApplicationArea = All;
            }
        }

        addafter("Reason For Extension")
        {
            field("Certificate No."; "Certificate No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Certificate No.")
        {
            field("Reference No."; "Reference No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Reference No.")
        {
            field("Date of Certificate"; "Date of Certificate")
            {
                ApplicationArea = All;
            }
        }
        addafter("Date of Certificate")
        {
            field("Confirmation Status"; "Confirmation Status")
            {
                ApplicationArea = All;
            }
        }

        addafter("Confirmation Status")
        {
            field("Confirmation/Dismissal Date"; "Confirmation/Dismissal Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Confirmation/Dismissal Date")
        {
            field(Remarks; Remarks)
            {
                ApplicationArea = All;
            }
        }

        addafter("HELB No")
        {
            field("Annual Leave Earned"; "Annual Leave Earned")
            {
                ApplicationArea = All;
            }
        }

        addafter("Annual Leave Earned")
        {
            field("Annual Leave Taken"; "Annual Leave Taken")
            {
                ApplicationArea = All;
            }
        }

        addafter("Annual Leave Taken")
        {
            field("Annual Leave Balance"; "Annual Leave Balance")
            {
                ApplicationArea = All;
            }
        }

        addafter("Annual Leave Balance")
        {
            field("Lost Days"; "Lost Days")
            {
                ApplicationArea = All;
            }
        }

        movebefore("Inactive Date"; Status)
        movefirst(Control13; "Phone No.2")

        moveafter("E-Mail"; "Company E-Mail")
        moveafter("Company E-Mail"; "Employment Date")

        modify(Pager)
        {
            Visible = false;
        }


    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        Validate("Annual Leave Balance");
    end;
}
