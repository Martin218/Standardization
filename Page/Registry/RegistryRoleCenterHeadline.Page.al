page 51022 "Registry RoleCenter Headline"
{
    PageType = HeadLinePart;

    layout
    {
        area(content)
        {
            field(Headline1; StrSubstNo(text002, Files.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                begin
                    Page.Run(50967);
                end;
            }
            field(Headline2; StrSubstNo(text001, Files2.Count))
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                // DrillDownURL: TextConst ENU = 'https://go.microsoft.com/fwlink/?linkid=867580';
                begin
                    // Hyperlink(DrillDownURL)
                    page.Run(50967);
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

        text001: TextConst ENU = '<qualifier>files</qualifier><payload>Approved Files<emphasize> %1 </emphasize>currently.</payload>';

        text002: TextConst ENU = '<qualifier>Files</qualifier><payload>You have approved<emphasize> %1 </emphasize>files currently.</payload>';
        text003: TextConst ENU = 'You are Welcome';
        text004: TextConst ENU = 'Analytics';

        Files: Record "Registry File";
        Files2: Record "Registry File";
}