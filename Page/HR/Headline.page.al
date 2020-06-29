page 50937 "Headline Page"
{
    PageType = HeadlinePart;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Headline1; Text000)
                {
                    ApplicationArea = All;

                }
                field(Headline2; Text001)
                {
                    ApplicationArea = All;

                }
                field(Headline3; Text002)
                {
                    ApplicationArea = All;

                }
            }
        }
    }


    var
        Text000: TextConst ENU = 'This is headline one';
        Text001: TextConst ENU = 'This is headline two';
        Text002: TextConst ENU = 'This is headline three';
}