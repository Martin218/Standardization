page 50303 "Loan Default Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Default Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("First Notice Template"; "First Notice Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Second Notice Template"; "Second Notice Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Third Notice Template"; "Third Notice Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Guarantor Notice Template"; "Guarantor Notice Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Grace Period"; "Grace Period")
                {
                    ApplicationArea = All;
                }
                field("Attach on"; "Attach on")
                {
                    ApplicationArea = All;
                }
            }
            group("Demand Letter")
            {
                Caption = 'Demand Letter';
                grid(DemandLetter)
                {
                    group(DemandLetterTemp)
                    {
                        Caption = '';
                        field(DemandLetterTemplate; DemandLetterTemplate)
                        {
                            MultiLine = true;
                            ApplicationArea = All;
                            Caption = '';
                            trigger OnValidate()
                            begin
                                SetDemandLetterTemplate(DemandLetterTemplate);
                            end;
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DemandLetterTemplate := GetDemandLetterTemplate;
    end;

    var
        DemandLetterTemplate: Text;
}

