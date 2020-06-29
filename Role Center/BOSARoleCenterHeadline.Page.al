page 50347 "BOSA RoleCenter Headline"
{
    PageType = HeadLinePart;

    layout
    {
        area(content)
        {
            field(Headline1; StrSubstNo(text001, Member.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50012);
                end;
            }
            field(Headline2; StrSubstNo(text002, LoanApplication.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                // DrillDownURL: TextConst ENU = 'https://go.microsoft.com/fwlink/?linkid=867580';
                begin
                    // Hyperlink(DrillDownURL)
                    page.Run(50207);
                end;
            }
            field(Headline3; StrSubstNo(text003, StandingOrder.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    // Hyperlink(DrillDownURL)
                    page.Run(50190);
                end;
            }
            field(Headline4; StrSubstNo(text004, GetTotalDisbursedAmount()))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    // Hyperlink(DrillDownURL)
                    page.Run(50207);
                end;
            }
        }
    }
    procedure GetTotalDisbursedAmount(): Decimal

    begin
        LoanApplication.CalcSums("Approved Amount");
        exit(LoanApplication."Approved Amount")
    end;

    var

        text001: TextConst ENU = '<qualifier>Members</qualifier><payload>You have registered<emphasize> %1 </emphasize>members so far.</payload>';
        //'You have registered %1 members so far';
        text002: TextConst ENU = '<qualifier>Loans</qualifier><payload>You have disbursed<emphasize> %1 </emphasize>loans so far.</payload>';
        //'%1 loans have been disbursed so far';
        text003: TextConst ENU = '<qualifier>Standing Orders</qualifier><payload>You have <emphasize> %1 </emphasize>running standing orders.</payload>';
        text004: TextConst ENU = '<qualifier>Loans</qualifier><payload>You have disbursed loans worth KES<emphasize> %1 </emphasize> so far</payload>';

        Member: Record Member;
        LoanApplication: Record "Loan Application";
        StandingOrder: Record "Standing Order";
}