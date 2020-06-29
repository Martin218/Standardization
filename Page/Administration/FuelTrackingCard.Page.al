page 51012 "Fuel Tracking Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Fuel Tracking";

    layout
    {
        area(content)
        {
            group("Fuel Tracking")
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Number Plate"; "Vehicle Number Plate")
                {
                    ApplicationArea = All;
                    TableRelation = "Vehicle Register";
                }
                field(Driver; Driver)
                {
                    ApplicationArea = All;
                    TableRelation = "Driver Setup";
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Fuel Receipt Date"; "Fuel Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Fuel Cost"; "Fuel Cost")
                {
                    ApplicationArea = All;
                }
                field("Fueled Litres"; "Fueled Litres")
                {
                    ApplicationArea = All;
                }
                field("Opening Mileage"; "Opening Mileage")
                {
                    ApplicationArea = All;
                }
                field("Closing Mileage"; "Closing Mileage")
                {
                    ApplicationArea = All;
                }
                field(Mileage; Mileage)
                {
                    ApplicationArea = All;
                }
                field(Tracked; Tracked)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            // part(AttachmentFactBox; 50265)
            /* {
                 Caption = 'Attachment';
                 SubPageLink = Document No.=FIELD(No.);
             }*/
        }
    }

    actions
    {
        area(creation)
        {
            action("Attach Excel Fuel Statements")
            {
                ApplicationArea = all;
                Caption = 'Attach Fuel Statements';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = true;

                trigger OnAction();
                begin
                    AdminManagement.AttachFuelTrackingStatements(FuelTrackerSetup);
                    CurrPage.CLOSE;
                end;
            }
            action("View attached fuel statements")
            {
                ApplicationArea = All;
                Image = ViewCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var

                begin
                    AdminManagement.OpenAttachedFuelTrackingStatements(FuelTrackerSetup);

                    CurrPage.CLOSE;
                end;
            }
            action("Generate Excel Fuel Tracker")
            {
                ApplicationArea = All;
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    TempFile: File;
                    FileName: Text[250];
                    IStream: InStream;
                    ToFile: Text[250];
                begin
                    CLEAR(FuelTrackerTemplate);
                    TempFile.TEXTMODE(FALSE);
                    TempFile.WRITEMODE(TRUE);
                    FileName := 'C:\Temp\Minutes.xls';
                    TempFile.CREATE(FileName);
                    TempFile.CLOSE;

                    FuelTrackerTemplate.SAVEASEXCEL(FileName);
                    TempFile.OPEN(FileName);
                    TempFile.CREATEINSTREAM(IStream);
                    ToFile := "No." + '.xls';
                    DOWNLOADFROMSTREAM(IStream, 'Save file to client', '', 'Excel File *.xls| *.xls', ToFile);
                    TempFile.CLOSE();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        //CurrPage.AttachmentFactBox.PAGE.SetParameter(Rec.RECORDID, Rec."No.");
    end;

    var
        ongoingbl: Boolean;
        appealedbl: Boolean;
        closedbl: Boolean;
        openbl: Boolean;
        //FileCU : Codeunit "419";
        filename: Text;
        //HRsetup : Record "5218";
        filename2: Text;
        appealclosebl: Boolean;
        courtbl: Boolean;
        // user : Record "91";
        filerec: File;
        filename3: Text;
        "HOD File Path": Text;
        VehicleRegister: Record "Vehicle Register";
        AdminManagement: Codeunit "Admin Management";
        FuelTrackerTemplate: Report "Fuel Tracker Template";
        AdminDoc: Record "Admin Doc";
        FuelTrackerSetup: Record "Fuel Tracker Setup";
}

