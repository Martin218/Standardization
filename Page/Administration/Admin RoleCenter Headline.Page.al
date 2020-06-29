page 51020 "Admin RoleCenter Headline"
{
    PageType = HeadLinePart;

    layout
    {
        area(content)
        {
            field(Headline1; StrSubstNo(text002, Vehicle.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(51000);
                end;
            }
            field(Headline2; StrSubstNo(text001, Boardroom.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                // DrillDownURL: TextConst ENU = 'https://go.microsoft.com/fwlink/?linkid=867580';
                begin
                    // Hyperlink(DrillDownURL)
                    page.Run(50983);
                end;
            }
            field(Headline3; text003)

            {
                ApplicationArea = All;
            }
            field(Headline4; text004)
            {
                ApplicationArea = All;
            }
        }
    }

    var

        text001: TextConst ENU = '<qualifier>Boardrooms</qualifier><payload>Approved Boardrooms<emphasize> %1 </emphasize>currently.</payload>';

        text002: TextConst ENU = '<qualifier>Vehicles</qualifier><payload>You have approved<emphasize> %1 </emphasize>vehicles currently.</payload>';
        text003: TextConst ENU = 'You are Welcome';
        text004: TextConst ENU = 'Analytics';

        Vehicle: Record "Vehicle Register";
        Boardroom: Record "Boardroom Detail";
}