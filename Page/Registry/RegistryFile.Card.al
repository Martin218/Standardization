page 50956 "Registry File Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Registry File";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("File No."; "File No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("RegFile Status"; "RegFile Status")
                {
                    Caption = 'File Status';
                    ApplicationArea = All;
                }
                field("File Number"; "File Number")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("File Type"; "File Type")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    Visible = MemberExists;
                    ApplicationArea = All;
                }
                field("Member No2"; "Member No2")
                {
                    Caption = 'Old Member No.';
                    Visible = MemberExistsNot;
                    ApplicationArea = All;
                }
                field("File Name"; "File Name")
                {
                    Editable = EditDetails;
                    ApplicationArea = All;
                }
                field("ID No."; "ID No.")
                {
                    Editable = EditDetails;
                    ApplicationArea = All;
                }
                field("Payroll No."; "Payroll No.")
                {
                    Editable = EditDetails;
                    ApplicationArea = All;
                }
                field("Member Status2"; "Member Status2")
                {
                    Caption = 'Member Status';
                    Visible = MemberExistsNot;
                    ApplicationArea = All;
                }
                field("Member Status"; "Member Status")
                {
                    Visible = MemberExists;
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ShowMandatory = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    Caption = 'File Status';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Location; Location1)
                {
                    Caption = 'Branch Location';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("File Location"; "File Location")
                {
                    Caption = 'File Location/ Box Reference';
                    ApplicationArea = All;
                }
                field("Cabinet/Rack No."; "Cabinet/Rack No.")
                {
                    ApplicationArea = All;
                }
                field("Row No."; "Row No.")
                {
                    ApplicationArea = All;
                }
                field("Column No."; "Column No.")
                {
                    ApplicationArea = All;
                }
                field("Pocket No."; "Pocket No.")
                {
                    ApplicationArea = All;
                }
                field(Volume; Volume)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Date Created"; "Date Created")
                {
                    ApplicationArea = All;
                }
                field("<Date  File Closed>"; "Date File Closed")
                {
                    Caption = 'Date  File Closed';
                    Visible = false;
                    ApplicationArea = All;
                }
            }

        }
    }

    actions
    {
        area(processing)
        {
            action("Create File")
            {
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    RegistryManagement.CreateNewFile(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin

        IF CONFIRM('Please confirm if the member exists in the system. If the member exist select Yes, if not select No') THEN BEGIN
            MemberExists := TRUE;
            MemberExistsNot := FALSE;
            EditDetails := FALSE;
        END ELSE BEGIN
            MemberExists := FALSE;
            MemberExistsNot := TRUE;
            EditDetails := TRUE;
            Status := Status::Archived;
        END;
    end;

    var
        User: Record "User Setup";
        RegistryFileNumbers: Record "Registry Number";
        FileVolumes: Record "File Volume";
        Selected: Integer;
        MemberExists: Boolean;
        MemberExistsNot: Boolean;
        EditDetails: Boolean;
        RegistryFiles: Record "Registry File";
        //Cust : Record 
        RegistryManagement: Codeunit "Registry Management2";
}

