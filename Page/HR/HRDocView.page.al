page 50441 "HR Documents View"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50226;
    SourceTableView = WHERE(Type = filter('Upload'),
                            Deleted = filter('No'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Name"; "Document Name")
                {
                    ApplicationArea = All;
                }
                field("Upload date"; "Upload date")
                {
                    ApplicationArea = All;
                }
                field("Upload By"; "Upload By")
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

