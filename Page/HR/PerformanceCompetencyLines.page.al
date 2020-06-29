page 50534 "Performance Competency Lines"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = 50287;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Indicators; Indicators)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Employee Comment"; "Employee Comment")
                {
                    ApplicationArea = All;
                }
                field("Employee Score"; "Employee Score")
                {
                    ApplicationArea = All;
                }
                field("Appraiser Remarks"; "Appraiser Remarks")
                {
                    ApplicationArea = All;
                }
                field("Appraiser Score"; "Appraiser Score")
                {
                    ApplicationArea = All;
                }
                field("Agreed Score"; "Agreed Score")
                {
                    ApplicationArea = All;
                }
                field(Notes; Notes)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

