table 50480 "Registry Files Line"
{
    // version TL2.0


    fields
    {
        field(1; "File Type"; Code[30])
        {
            TableRelation = "Registry File" WHERE(Issued = filter('No'),
                                                   Created = filter('Yes'));
        }
        field(2; "File No."; Code[100])
        {
            TableRelation = "Registry File" WHERE(Created = filter('Yes'),
                                                   Status = FILTER(<> Closed));

            trigger OnValidate();
            begin
                /*IF FilesRegistry.GET("File No.") THEN BEGIN
                  IF FilesRegistry.Issued=TRUE THEN BEGIN
                    ERROR('This file has already been issued out.');
                  END;
                END;
                
                IF FilesRegistry.GET("File No.") THEN BEGIN
                  "File Number":=FilesRegistry."File Number";
                  "File Name":=FilesRegistry."File Name";
                  "File Type":=FilesRegistry."File Type";
                  Type:=FilesRegistry.Type;
                  Status:=FilesRegistry.Status;
                  Location:=FilesRegistry.Location;
                  "Member No.":=FilesRegistry."Member No.";
                  "ID No.":=FilesRegistry."ID No.";
                  "Payroll No.":=FilesRegistry."Payroll No.";
                  "Requisition By":=USERID;
                  Volume:=FilesRegistry.Volume;
                  //"Request ID":=Rec."Request ID";
                
                
                   FileVolumes.RESET;
                   FileVolumes.SETRANGE(No,"File No.");
                   IF FileVolumes.FINDSET THEN BEGIN
                      Noofvolumes:=FilesRegistry.COUNT;
                     IF Noofvolumes<>1 THEN BEGIN
                        MESSAGE('If you would like to request for a different volume of the file other than the current volume %1 please specify in the volume field.',Volume);
                     END;
                    END;
                
                END;
                */

            end;
        }
        field(3; "File Name"; Code[100])
        {
            Editable = false;
            TableRelation = "Registry File" WHERE(Issued = filter('No'),
                                                   Created = filter('Yes'));
        }
        field(4; Type; Option)
        {
            Editable = false;
            OptionCaption = ',Branch File,Sacco File';
            OptionMembers = ,"Branch File","Sacco File";
        }
        field(5; Status; Option)
        {
            Editable = false;
            OptionCaption = ',Active,Inactive,Dormant,Closed,Disposed,Archived';
            OptionMembers = ,Active,Inactive,Dormant,Closed,Disposed,Archived;
        }
        field(6; Location; Code[100])
        {
            Editable = false;
        }
        field(17; "No."; Integer)
        {
            AutoIncrement = true;
        }
        field(18; "Request ID"; Code[100])
        {
            Editable = false;
            TableRelation = "File Issuance";
        }
        field(19; "Member No."; Code[50])
        {
            Editable = false;
            TableRelation = "Registry File" WHERE(Issued = filter('No'),
                                                   Created = filter('Yes'));
        }
        field(20; "ID No."; Code[50])
        {
            Editable = false;
            TableRelation = "Registry File" WHERE(Issued = filter('No'),
                                                   Created = filter('Yes'));
        }
        field(21; "Payroll No."; Code[50])
        {
            Editable = false;
            TableRelation = "Registry File" WHERE(Issued = filter('No'),
                                                   Created = filter('Yes'));
        }
        field(22; Returned; Boolean)
        {
        }
        field(23; "Return Date"; Date)
        {
        }
        field(24; "Returned By"; Code[100])
        {
        }
        field(25; "Requisition By"; Code[100])
        {
            TableRelation = "File Issuance";
        }
        field(26; "Other User"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(27; "Member Status"; Option)
        {
            OptionCaption = 'Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,New,Approval Pending,Not Approved';
            OptionMembers = Active,"Non-Active",Blocked,Dormant,"Re-instated",Deceased,Withdrawal,Retired,Termination,Resigned,"Ex-Company",Casuals,"Family Member",New,"Approval Pending","Not Approved";
        }
        field(28; "HOD Approval"; Boolean)
        {
        }
        field(29; "HOD Comments"; Text[250])
        {
        }
        field(30; "Registry Approval"; Boolean)
        {
        }
        field(31; "Registry Comment"; Text[250])
        {
        }
        field(32; "Request Status"; Option)
        {
            OptionCaption = ',HOD Approved,HOD Rejected,Registry Approved,Registry Rejected';
            OptionMembers = ,"HOD Approved","HOD Rejected","Registry Approved","Registry Rejected";
        }
        field(33; "Confirm Receipt"; Boolean)
        {
            Editable = false;
        }
        field(34; "Received TimeStamp"; DateTime)
        {
            Editable = false;
        }
        field(35; "Released From"; Code[50])
        {
        }
        field(36; "Time Released"; DateTime)
        {
        }
        field(37; "Released To"; Code[50])
        {
        }
        field(38; "Received By"; Code[50])
        {
        }
        field(39; "Time Received"; DateTime)
        {
        }
        field(40; "Transfer ID"; Code[50])
        {
        }
        field(41; "Approved/Rejection Time"; DateTime)
        {
        }
        field(42; "HOD Rejected"; Boolean)
        {
        }
        field(43; "Registry Rejected"; Boolean)
        {
        }
        field(44; Status2; Option)
        {
            OptionCaption = 'New,Active,Issued,Rejected,Pending Approval,Not Approved,Ready For PickUp';
            OptionMembers = New,Active,Issued,Rejected,"Pending Approval","Not Approved","Ready For PickUp";
        }
        field(45; "File Number"; Code[100])
        {
            TableRelation = "Registry File" WHERE(Created = filter('Yes'),
                                                   Status = FILTER(<> Closed));

            trigger OnValidate();
            begin
                IF FilesRegistry.GET("File No.") THEN BEGIN
                    IF FilesRegistry.Issued = TRUE THEN BEGIN
                        ERROR('This file has already been issued out.');
                    END;
                END;

                IF FilesRegistry.GET("File Number") THEN BEGIN
                    "File No." := FilesRegistry."File No.";
                    "File Number" := FilesRegistry."File Number";
                    "File Name" := FilesRegistry."File Name";
                    "File Type" := FilesRegistry."File Type";
                    Type := FilesRegistry.Type;
                    Status := FilesRegistry.Status;
                    Location := FilesRegistry.Location1;
                    "Member No." := FilesRegistry."Member No.";
                    "ID No." := FilesRegistry."ID No.";
                    "Payroll No." := FilesRegistry."Payroll No.";
                    "Requisition By" := USERID;
                    Volume := FilesRegistry.Volume;
                    //"Request ID":=Rec."Request ID";


                    /* FileVolumes.RESET;
                     FileVolumes.SETRANGE(No,"File No.");
                     IF FileVolumes.FINDSET THEN BEGIN
                        Noofvolumes:=FilesRegistry.COUNT;
                       IF Noofvolumes<>1 THEN BEGIN
                          MESSAGE('If you would like to request for a different volume of the file other than the current volume %1 please specify in the volume field.',Volume);
                       END;
                      END;*/

                END;

            end;
        }
        field(46; Received; Boolean)
        {
        }
        field(47; Comment; Text[250])
        {
        }
        field(48; "Reject Receipt"; Boolean)
        {
        }
        field(49; Volume; Code[100])
        {
        }
        field(50; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(51; "Volume 2"; Code[100])
        {
            TableRelation = "File Volume".Volume WHERE(MemberNo = FIELD("Member No."));
        }
    }

    keys
    {
        key(Key1; "No.", "File No.", "Request ID", "Member No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "File No.", "File Name", "Member No.", "ID No.", "Payroll No.")
        {
        }
    }

    trigger OnInsert();
    begin
        /*UserRequestCount:=UserRec.COUNT;
        UserRequestCount:=0;
        UserRec.SETFILTER(Returned,'False');
        UserRec.SETRANGE("Requisition By","Requisition By");
        IF UserRec.FIND('-') THEN
         // MESSAGE('success');
          REPEAT
            UserRequestCount:=UserRequestCount + 1;
          UNTIL
            UserRec.NEXT=0;
         // MESSAGE('%1',UserRequestCount);
        IF UserRequestCount>20 THEN
          ERROR('You are currently in possession of more than 20 files. Please Return the files in order to be able to request for more files.');
        EXIT;*/

    end;

    var
        NoSetup: Record "Registry SetUp";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FilesRegistry: Record "Registry File";
        FileIssuance: Record "File Issuance";
        RegistryFilesLines: Record "Registry Files Line";
        UserRequestCount: Integer;
        UserRec: Record "Registry Files Line";
        FileVolumes: Record "File Volume";
        Noofvolumes: Integer;
}

