page 50012 "Member List"
{
    // version TL2.0

    Caption = 'Members';
    CardPageID = "Member Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = Member;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; "Full Name")
                {
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
                field("National ID"; "National ID")
                {
                    ApplicationArea = All;
                }

                field("Application No."; "Application No.")
                {
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }

                field(Status; Status)
                {
                    ApplicationArea = All;
                }
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
                    Agency.SETRANGE("Member No.", Rec."No.");
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

    trigger OnAfterGetCurrRecord()
    begin
        SetVisible;
        SetEditable;
    end;

    trigger OnOpenPage()
    begin
        SetVisible;
        SetEditable;
    end;

    var
        BeneficiaryType: Record "Beneficiary Type";
        //ApprovalsMgmt: Codeunit "1535";
        [InDataSet]
        IsVisibleIndividual: Boolean;
        [InDataSet]
        IsVisibleGroup: Boolean;
        [InDataSet]
        IsVisibleCompany: Boolean;
        IsVisibleApprovalRequest: Boolean;
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

