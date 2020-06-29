page 50810 "Procurement RoleCenter_Test"
{
    PageType = HeadLinePart;

    layout
    {
        area(content)
        {
            field(Headline1; StrSubstNo(text001, PurchaseReq.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50722);
                end;
            }
            field(Headline2; StrSubstNo(text002, PurchaseReq.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50727);
                end;
            }
            field(Headline3; StrSubstNo(text005, PurchaseReq.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50735);
                end;
            }

            /* field(Headline2; StrSubstNo(text002, 20))
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
 */
            field(Headline4; text003)
            {
                ApplicationArea = All;
            }
            field(Headline5; text004)
            {
                ApplicationArea = All;
            }
        }
    }

    var

        text001: TextConst ENU = '<qualifier>Purchase Requisitions</qualifier><payload>You have <emphasize> %1 </emphasize>approved purchase requisitions</payload>';
        //'You have registered %1 members so far';
        text002: TextConst ENU = '<qualifier>Store Requisitions</qualifier><payload>You have <emphasize> %1 </emphasize>approved Store requisitions</payload>';
        text005: TextConst ENU = '<qualifier>Store Return</qualifier><payload>You have <emphasize> %1 </emphasize>approved Store returns</payload>';
        //        text002: TextConst ENU = '<qualifier>Loans</qualifier><payload>You have disbursed<emphasize> %1 </emphasize>loans so far.</payload>';
        //'%1 loans have been disbursed so far';
        text003: TextConst ENU = 'This is headline 3';
        text004: TextConst ENU = 'This is headline 4';
        PurchaseReq: Record "Requisition Header";
}