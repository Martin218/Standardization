page 50011 "Member Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Group/Company Related Info,Category 7,Category 8';
    SourceTable = "Member";
    Editable = false;

    layout
    {
        area(content)
        {
            field(Category; Category)
            {

                trigger OnValidate()
                begin
                    SetVisible;
                end;
            }
            group(Individual)
            {
                Caption = 'Individual';
                Visible = IsVisibleIndividual;
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Surname; Surname)
                {
                    ApplicationArea = All;
                }
                field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("National ID"; "National ID")
                {
                    ApplicationArea = All;
                }
                field("Passport ID"; "Passport ID")
                {
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field("Date of Birth"; "Date of Birth")
                {
                    ApplicationArea = All;
                }
                field("Marital Status"; "Marital Status")
                {
                    ApplicationArea = All;
                }
                field(Occupation; Occupation)
                {
                    ApplicationArea = All;
                }
                group("GroupLink")
                {
                    Caption = '';
                    Visible = Category = 0;
                    field("Group Link Type"; "Group Link Type")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            "Group Link No." := '';
                        end;
                    }
                    group(GroupLinkNo)
                    {
                        Caption = '';
                        Visible = "Group Link Type" > 0;
                        field("Group Link No."; "Group Link No.")
                        {
                            ApplicationArea = All;
                        }
                    }

                }
                field("Introducer Member No."; "Introducer Member No.")
                {
                    ApplicationArea = All;
                }
                field("Introducer Member Name"; "Introducer Member Name")
                {
                    ApplicationArea = All;
                }
                field("PIN No."; "PIN No.")
                {
                    ApplicationArea = All;
                }
                field(Nationality; Nationality)
                {
                    ApplicationArea = All;
                }
                field("Payroll No."; "Payroll No.")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;
                }

                group(IsGroupOfficial)
                {
                    Caption = '';
                    Visible = "Group Link Type" > 0;
                    field("Is Group Official"; "Is Group Official")
                    {
                        ApplicationArea = All;
                    }
                }
                group(GroupOfficialPosition)
                {
                    Caption = '';
                    Visible = "Is Group Official" = true;
                    field("Group Official Position"; "Group Official Position")
                    {
                        ApplicationArea = All;
                    }
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
            group("Group Details")
            {
                Caption = 'Group';
                Visible = IsVisibleGroup;
                field("Group Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("Group Registration No."; "Registration No.")
                {
                    Caption = ' Registration No.';
                    ApplicationArea = All;
                }
                field("Group Date of Registration"; "Date of Registration")
                {
                    Caption = ' Date of Registration';
                    ApplicationArea = All;
                }

                // field("<Group Date of Renewal>"; "Date of Renewal")
                // {
                //     Caption = ' Date of Renewal';
                // }
                field("Group Meeting Day"; "Group Meeting Day")
                {
                    ApplicationArea = All;
                }
                field("Group Meeting Time"; "Group Meeting Time")
                {
                    ApplicationArea = All;
                }
                field("Group Meeting Frequency Option"; "Group Meeting Frequency Option")
                {
                    ApplicationArea = All;
                }
                field("Group Meeting Venue"; "Group Meeting Venue")
                {
                    ApplicationArea = All;
                }
                field("Last Meeting Date"; "Last Meeting Date")
                {
                    ApplicationArea = All;
                }
                field("Min. Contribution per Meeting"; "Min. Contribution per Meeting")
                {
                    ApplicationArea = All;
                }

                field("Office Location"; "Office Location")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("No. of Members"; "No. of Members")
                {
                    ApplicationArea = All;
                }

                field("Group Loan Officer ID"; "Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field("Group Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }

                field(GroupStatus; Status)
                {
                    ApplicationArea = All;
                }

            }
            group("Company Details")
            {
                Caption = 'Company';
                Visible = IsVisibleCompany;
                field("Company Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("Registration No."; "Registration No.")
                {
                    ApplicationArea = All;
                }

                field("Date of Registration"; "Date of Registration")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }

                field("Company Activity"; Activity)
                {
                    Caption = 'Company Activity';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Company KRA PIN"; "PIN No.")
                {
                    Caption = ' KRA PIN';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }

                field("Company Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(CompanyStatus; Status)
                {
                    ApplicationArea = All;
                }
            }
            group(Joint)
            {
                Caption = 'Joint';
                Visible = IsVisibleJoint;
                field("Joint Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("Joint ID"; "National ID")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Joint Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(JointStatus; Status)
                {
                    ApplicationArea = All;
                }

            }
            group(Communication)
            {
                field("E-mail"; "E-mail")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Postal Address"; "Postal Address")
                {
                    ApplicationArea = All;
                }
                field("Physical Address"; "Physical Address")
                {
                    ApplicationArea = All;
                }
                group("Residence")
                {
                    Caption = '';
                    Visible = Category = 0;
                    field("Current Residence"; "Current Residence")
                    {
                        ApplicationArea = All;
                    }
                    field("Home Ownership"; "Home Ownership")
                    {
                        ApplicationArea = All;
                    }
                    field("Home Village"; "Home Village")
                    {
                        ApplicationArea = All;
                    }
                    field("Nearest LandMark"; "Nearest LandMark")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Audit)
            {
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field("Created By Host Name"; "Created By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Created By Host IP"; "Created By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Created By Host MAC"; "Created By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Member Picture"; "Member Picture")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsVisiblePicture;
            }

            part("Member Front ID"; "Member Front ID")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsVisibleFrontID;
            }
            part("Member Back ID"; "Member Back ID")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsVisibleBackID;
            }
            part("Member Signature"; "Member Signature")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsVisibleSignature;
            }
            part("Member Reg. Certficate"; "Member Reg. Certficate")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsVisibleCR;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Member Nominees")
            {
                Ellipsis = true;
                Image = Customer;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleIndividual;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::Nominee);
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50005, BeneficiaryType);
                end;
            }
            action("Next of Kin")
            {
                Ellipsis = true;
                Image = Hierarchy;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleIndividual;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Next of Kin");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50006, BeneficiaryType);
                end;
            }
            action(Agencies)
            {
                Image = ContactPerson;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleIndividual;

                trigger OnAction()
                begin
                    Agency.FILTERGROUP(10);
                    Agency.SETRANGE("Member No.", Rec."Application No.");
                    Agency.FILTERGROUP(0);
                    PAGE.RUN(50052, Agency);
                end;
            }
            action("Monthly Contributions")
            {
                Ellipsis = true;
                Image = ElectronicPayment;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    MemberMonthlyContribution.FILTERGROUP(10);
                    MemberMonthlyContribution.SETRANGE("Application No.", Rec."Application No.");
                    Agency.FILTERGROUP(0);
                    PAGE.RUN(50053, MemberMonthlyContribution);
                end;
            }
            action("Group Members")
            {
                Image = ContactPerson;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleGroup;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Group Member");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50057, BeneficiaryType);
                end;
            }
            action("Group Trustees")
            {
                Image = Trace;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleGroup;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Group Trustee");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50059, BeneficiaryType);
                end;
            }
            action("Company Signatories")
            {
                Image = Company;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleCompany;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Company Signatory");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50056, BeneficiaryType);
                end;
            }
            action("Company Trustees")
            {
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleCompany;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Company Trustee");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50058, BeneficiaryType);
                end;
            }
            action("Joint Members")
            {
                Image = Holiday;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleJoint;

                trigger OnAction()
                begin
                    BeneficiaryType.FILTERGROUP(10);
                    BeneficiaryType.SETRANGE("Application No.", Rec."Application No.");
                    BeneficiaryType.SETRANGE(Type, BeneficiaryType.Type::"Joint Member");
                    BeneficiaryType.FILTERGROUP(0);
                    PAGE.RUN(50071, BeneficiaryType);
                end;
            }
            action("Savings/Deposit Accounts")
            {
                Image = MapAccounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Vendor.FILTERGROUP(10);
                    Vendor.SETRANGE("Member No.", Rec."No.");
                    Vendor.FILTERGROUP(0);
                    PAGE.RUN(50033, Vendor);
                end;
            }
            action("Loan Accounts")
            {
                Image = SocialListening;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Customer.FILTERGROUP(10);
                    Customer.SETRANGE("Member No.", Rec."No.");
                    Customer.FILTERGROUP(0);
                    PAGE.RUN(50202, Customer);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetVisible;
        SetEditable;
        "Registration Date" := "Date of Registration";
        MODIFY;
    end;

    var
        Text000: Label 'Are you sure you want to send member application %1 for approval?';
        Text001: Label 'Are you sure you want to cancel member application %1?';
        Text002: Label 'Member Application %1 has been submitted successfully';
        Text003: Label 'Member Application %1 has been cancelled successfully';
        [InDataSet]
        IsVisibleIndividual: Boolean;
        [InDataSet]
        IsVisibleGroup: Boolean;
        [InDataSet]
        IsVisibleCompany: Boolean;
        BeneficiaryType: Record "Beneficiary Type";
        IsVisibleApprovalRequest: Boolean;
        //ApprovalsMgmt: Codeunit "1535";
        Agency: Record "Member Agency";
        MemberMonthlyContribution: Record "Member Contribution";
        IsVisibleJoint: Boolean;
        IsVisibleSignature: Boolean;
        [InDataSet]
        IsVisiblePicture: Boolean;
        [InDataSet]
        IsVisibleFrontID: Boolean;
        [InDataSet]
        IsVisibleBackID: Boolean;
        IsVisibleCR: Boolean;
        Vendor: Record "Vendor";
        Customer: Record "Customer";

    local procedure SetVisible()
    begin
        IF Category = Category::Individual THEN BEGIN
            IsVisibleGroup := FALSE;
            IsVisibleCompany := FALSE;
            IsVisibleIndividual := TRUE;
            IsVisibleJoint := FALSE;
            IsVisiblePicture := TRUE;
            IsVisibleSignature := TRUE;
            IsVisibleBackID := TRUE;
            IsVisibleFrontID := TRUE;
            IsVisibleCR := FALSE;
        END ELSE
            IF Category = Category::Group THEN BEGIN
                IsVisibleIndividual := FALSE;
                IsVisibleCompany := FALSE;
                IsVisibleGroup := TRUE;
                IsVisibleJoint := FALSE;
                IsVisiblePicture := TRUE;
                IsVisibleSignature := FALSE;
                IsVisibleFrontID := FALSE;
                IsVisibleBackID := FALSE;
                IsVisibleCR := TRUE;
            END ELSE
                IF Category = Category::Company THEN BEGIN
                    IsVisibleIndividual := FALSE;
                    IsVisibleGroup := FALSE;
                    IsVisibleCompany := TRUE;
                    IsVisibleJoint := FALSE;
                    IsVisiblePicture := TRUE;
                    IsVisibleSignature := FALSE;
                    IsVisibleFrontID := FALSE;
                    IsVisibleBackID := FALSE;
                    IsVisibleCR := TRUE;
                END ELSE
                    IF Category = Category::Joint THEN BEGIN
                        IsVisibleGroup := FALSE;
                        IsVisibleCompany := FALSE;
                        IsVisibleIndividual := FALSE;
                        IsVisibleJoint := TRUE;
                        IsVisiblePicture := TRUE;
                        IsVisibleSignature := FALSE;
                        IsVisibleFrontID := FALSE;
                        IsVisibleBackID := FALSE;
                        IsVisibleCR := FALSE;
                    END;
        IF Status = Status::Active THEN
            IsVisibleApprovalRequest := TRUE
        ELSE
            IsVisibleApprovalRequest := FALSE
    end;

    local procedure SetEditable()
    begin
        IF Status = Status::Active THEN
            CurrPage.EDITABLE := TRUE;
        IF Status = Status::Dormant THEN
            CurrPage.EDITABLE := FALSE;
        IF Status = Status::Suspended THEN
            CurrPage.EDITABLE := FALSE;
    end;
}

