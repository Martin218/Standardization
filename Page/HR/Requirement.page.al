page 50481 Requirements
{
    // version TL2.0

    Caption = 'Employee Responsibilities';
    PageType = List;
    SourceTable = 50249;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Requirement; Requirement)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
        }
    }

    var
        instr: InStream;
        outstr: OutStream;
        Initiatives1: Text;
        Total: Decimal;
}

