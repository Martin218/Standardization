page 50209 "Loan  Security List"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Loan Security";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Security Code"; "Security Code")
                {ApplicationArea = All;
                }
                field(Description; Description)
                {ApplicationArea = All;
                }
                field("Security Value"; "Security Value")
                {ApplicationArea = All;
                }
                field("Security Factor"; "Security Factor")
                {ApplicationArea = All;
                }
                field("Guaranteed Amount"; "Guaranteed Amount")
                {ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Attach Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Open Attachment")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
        }
    }

    var
        filename: Text;
        filename2: Text;
        CBSSetup: Record "CBS Setup";
}

