page 50959 "Inventory File Card"
{
    // version TL2.0

    Editable = false;
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
                    ApplicationArea = All;
                    Visible = false;
                }
                field("RegFile Status"; "RegFile Status")
                {
                    ApplicationArea = All;
                    Caption = 'File Status';
                }
                field("File Number"; "File Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("File Type"; "File Type")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field("Member No2"; "Member No2")
                {
                    ApplicationArea = All;
                    Caption = 'Old Member No.';
                    Visible = true;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("ID No."; "ID No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payroll No."; "Payroll No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Member Status2"; "Member Status2")
                {
                    ApplicationArea = All;
                    Caption = 'Member Status';
                    Visible = true;
                }
                field("Member Status"; "Member Status")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Caption = 'File Status';
                    Visible = false;
                }
                field(Location; Location1)
                {
                    ApplicationArea = All;
                    Caption = 'Branch Location';
                    ShowMandatory = true;
                }
                field("File Location"; "File Location")
                {
                    ApplicationArea = All;
                    Caption = 'File Location/ Box Reference';
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
                    ApplicationArea = All;
                    Caption = 'Date  File Closed';
                    Visible = false;
                }
            }
            part(Page; "Registry File Numbers")
            {
                SubPageLink = "No." = FIELD("File No.");
                Visible = true;
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

                trigger OnAction();
                begin
                    RegistryManagement.CreateNewFile(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        User: Record "User Setup";
        RegistryFileNumbers: Record "Registry Number";
        FileVolumes: Record "File Volume";
        Selected: Integer;
        MemberExists: Boolean;
        MemberExistsNot: Boolean;
        EditDetails: Boolean;
        RegistryFiles: Record "Registry File";
        //Cust : Record "18";
        RegistryManagement: Codeunit "Registry Management2";
}

