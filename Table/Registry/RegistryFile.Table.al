table 50470 "Registry File"
{
    // version TL2.0

    DataCaptionFields = "File No.", "File Name", "File Type";

    fields
    {
        field(1; "File Type"; Code[30])
        {
            TableRelation = "File Type";
        }
        field(2; "File No."; Code[30])
        {
            Editable = false;
        }
        field(3; "File Name"; Code[50])
        {
        }
        field(4; Type; Option)
        {
            OptionCaption = ',Branch File,Sacco File';
            OptionMembers = ,"Branch File","Sacco File";
        }
        field(5; Status; Option)
        {
            OptionCaption = ',Active,Inactive,Dormant,Closed,Disposed,Archived,Deceased,Suspended,Withdrawn';
            OptionMembers = ,Active,Inactive,Dormant,Closed,Disposed,Archived,Deceased,Suspended,Withdrawn;

            trigger OnValidate();
            begin
                IF Status = Status::Closed THEN
                    "Date File Closed" := TODAY;
            end;
        }
        field(6; Location1; Code[30])
        {
            Editable = false;
            TableRelation = Branch;
        }
        field(7; "Cabinet/Rack No."; Code[30])
        {

            trigger OnValidate();
            begin
                IF STRLEN("Cabinet/Rack No.") <> 4 THEN
                    ERROR('Cabinet/Rack No must have a total of 4 characters.');
            end;
        }
        field(8; "Row No."; Code[30])
        {

            trigger OnValidate();
            begin
                IF STRLEN("Row No.") <> 4 THEN
                    ERROR('Row No. must have a total of 4 characters.');
            end;
        }
        field(9; "Column No."; Code[30])
        {

            trigger OnValidate();
            begin
                IF STRLEN("Column No.") <> 4 THEN
                    ERROR('Column No. must have a total of 4 characters.');
            end;
        }
        field(10; "Pocket No."; Code[30])
        {

            trigger OnValidate();
            begin
                IF STRLEN("Pocket No.") <> 4 THEN
                    ERROR('Pocket No. must have a total of 4 characters.');
            end;
        }
        field(11; Remarks; Text[250])
        {
        }
        field(12; "Date File Closed"; Date)
        {
            Editable = false;
        }
        field(13; "No. Series"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(14; Issued; Boolean)
        {
        }
        field(15; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(16; "Date Created"; DateTime)
        {
            Editable = false;
        }
        field(17; Created; Boolean)
        {
        }
        field(18; "Member No."; Code[30])
        {
            TableRelation = Member; //WHERE("Branch Name" = FIELD(Location1));

            trigger OnValidate();
            begin
                Member.RESET;
                Member.SETRANGE("No.", "Member No.");
                IF Member.FINDFIRST THEN BEGIN
                    "File Name" := Member."Full Name";
                    "Member No." := Member."No.";
                    "ID No." := Member."National ID";
                    "Member Status" := Member.Status;
                    Location1 := Member."Global Dimension 1 Code";
                END;

                //IF Member.GET("Member No.") THEN BEGIN

                // "Payroll No.":=Customer.pay;
                //END;

                IF "Member No." <> '' THEN BEGIN
                    registry.RESET;
                    registry.SETRANGE("Member No.", "Member No.");
                    registry.SETRANGE(Created, TRUE);
                    /*IF registry.FINDSET THEN BEGIN
                      REPEAT
                        IF "Member No."=registry."Member No." THEN BEGIN
                          ERROR('This Member already has a file in Registry.');
                          END;
                      UNTIL
                       registry.NEXT=0;
                    END;*/
                END;

                User.RESET;
                User.GET(USERID);
                /*DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.", 1);
                DimensionValue.SETRANGE(Code, User."Global Dimension 1 Code");
                IF DimensionValue.FIND('-') THEN BEGIN
                    Branch1 := DimensionValue.Name;
                END;*/

                Member.RESET;
                Member.GET("Member No.");
                /*DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.", 1);
                DimensionValue.SETRANGE(Code, Member."Global Dimension 1 Code");
                IF DimensionValue.FIND('-') THEN BEGIN
                    Branch2 := DimensionValue.Name;
                END;*/
                IF Branch1 <> Branch2 THEN
                    ERROR('You cannot create a file for a member belonging to a different branch');

            end;
        }
        field(19; "ID No."; Code[30])
        {
        }
        field(20; "Payroll No."; Code[30])
        {
        }
        field(21; "Member Status"; Option)
        {
            OptionCaption = 'Active,InActive,Dormant,Deceased,CLOSED,Suspended,Withdrawn,Achived';
            OptionMembers = Active,"Non-Active",Blocked,Dormant,"Re-instated",Deceased,Withdrawal,Retired,Termination,Resigned,"Ex-Company",Casuals,"Family Member",New,"Approval Pending","Not Approved";
        }
        field(22; "File Location"; Code[50])
        {
        }
        field(23; Volume; Code[100])
        {
        }
        field(24; "Current User"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(25; "File Number"; Code[100])
        {

            trigger OnValidate();
            begin
                registry.RESET;
                registry.SETRANGE("File Number", "File Number");
                registry.SETRANGE(Created, TRUE);
                IF registry.FIND('-') THEN BEGIN
                    ERROR('You cannot use the same file number twice.');
                END;

                IF STRLEN("File Number") <> 20 THEN
                    ERROR('File Number must have a total of 20 characters.');


                //Location:=PADSTR("File Number",3);
                branchvalue2 := PADSTR("File Number", 3);
                branchvalue := '0' + FORMAT(Location1);
                //MESSAGE('%1,%2',branchvalue,branchvalue2);
                IF branchvalue <> branchvalue2 THEN BEGIN
                    ERROR('Branch value for the file does not match the user branch value!');
                END;
            end;
        }
        field(26; "File Request Status"; Option)
        {
            OptionMembers = "In Registry","Issued Out";
        }
        field(27; "Creation Option"; Option)
        {
            OptionMembers = Exists,"Does not Exist";
        }
        field(28; "Member No2"; Code[30])
        {

            trigger OnValidate();
            begin
                "Member No." := "Member No2";
            end;
        }
        field(29; "Member Status2"; Option)
        {
            Editable = false;
            OptionMembers = Archived;
        }
        field(30; "RegFile Status"; Code[30])
        {
            TableRelation = "Registry File Status"."Status Code";

            trigger OnValidate();
            begin
                BranchNumberSeries := '';
                FileStatus := "RegFile Status";
                IF "File Number" = '' THEN BEGIN
                    FileStatus := "RegFile Status";
                END;
                RegistryFileStatus.RESET;
                RegistryFileStatus.SETRANGE("Status Code", FileStatus);
                IF RegistryFileStatus.FINDFIRST THEN BEGIN
                    RegFileDesc := RegistryFileStatus.Description;
                END;
                //MESSAGE(RegFileDesc);


                User.GET(USERID);
                Location1 := '02';
                branchvalue := '01' + Location1;
                CurrentYear := DATE2DMY(TODAY, 3);


                RegistryNumbers.RESET;
                // RegistryNumbers.GET(Location1, FileStatus);
                RegistryNumbers.SETRANGE(Branch, Location1);//MESSAGE('%1..%2',RegistryNumbers.Branch,Location);
                RegistryNumbers.SETRANGE("RegFile Status", FileStatus);
                IF RegistryNumbers.FINDFIRST THEN BEGIN
                    RegistryNumbers.TESTFIELD("No. Series");//MESSAGE('in');
                                                            //NoSeriesMgt.InitSeries(RegistryNumbers."Branch1 Active",xRec."No. Series",0D,"Branch1 Active","No. Series");
                    BranchNumberSeries := RegistryNumbers."No. Series";
                    BranchNumberSeries := NoSeriesMgt.GetNextNo(RegistryNumbers."No. Series", TODAY, TRUE);
                    "File Number" := branchvalue + '/' + FileStatus + '/' + BranchNumberSeries + '/' + FORMAT(CurrentYear);
                    //MESSAGE('%1',"File Number");
                END;


                /*
                //=====begin Location 01
                 IF Location='01' THEN BEGIN
                  IF FileStatus='CMF1' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch1 Active");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch1 Active",xRec."No. Series",0D,"Branch1 Active","No. Series");
                    BranchNumberSeries:="Branch1 Active";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 Active",TODAY,TRUE);
                    "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF2' THEN BEGIN
                        NoSetup.GET;
                        NoSetup.TESTFIELD("Branch1 InActive");
                        //NoSeriesMgt.InitSeries(NoSetup."Branch1 InActive",xRec."No. Series",0D,"Branch1 InActive","No. Series");
                        //MESSAGE("Branch1 InActive");
                        BranchNumberSeries:="Branch1 InActive";
                        BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 InActive",TODAY,TRUE);
                        "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                      END;
                
                  //MESSAGE('%1',"File Number");
                  IF FileStatus='CMF3' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch1 Withdrawn");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch1 Withdrawn",xRec."No. Series",0D,"Branch1 Withdrawn","No. Series");
                    BranchNumberSeries:="Branch1 Withdrawn";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 Withdrawn",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF4' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch1 Closed");
                    //MESSAGE(NoSeriesMgt.GetNextNo(NoSetup."Branch1 Closed",TODAY,FALSE));
                    //NoSeriesMgt.InitSeries(NoSetup."Branch1 Closed",xRec."No. Series",0D,"Branch1 Closed","No. Series");
                    //MESSAGE("Branch1 Closed");
                    BranchNumberSeries:="Branch1 Closed";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 Closed",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF5' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch1 Deceased");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch1 Deceased",xRec."No. Series",0D,"Branch1 Deceased","No. Series");
                    BranchNumberSeries:="Branch1 Deceased";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 Deceased",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF6' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch1 Volume");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch1 Volume",xRec."No. Series",0D,"Branch1 Volume","No. Series");
                    BranchNumberSeries:="Branch1 Volume";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 Volume",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                END;//end Location 01
                
                //begin Location 02
                IF Location='02' THEN BEGIN
                  IF FileStatus='CMF1' THEN BEGIN
                      NoSetup.GET;
                      NoSetup.TESTFIELD("Branch2 Active");
                      //NoSeriesMgt.InitSeries(NoSetup."Branch2 Active",xRec."No. Series",0D,"Branch2 Active","No. Series");
                      BranchNumberSeries:="Branch2 Active";
                      BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 Active",TODAY,TRUE);
                      "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                      //MESSAGE('%1...',"File Number");
                   END;
                   IF FileStatus='CMF2' THEN BEGIN
                      NoSetup.GET;
                      NoSetup.TESTFIELD("Branch2 InActive");
                      //NoSeriesMgt.InitSeries(NoSetup."Branch2 InActive",xRec."No. Series",0D,"Branch2 InActive","No. Series");
                      BranchNumberSeries:="Branch2 InActive";
                      BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 InActive",TODAY,TRUE);
                      "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                      //MESSAGE('%1...',"File Number");
                  END;
                  IF FileStatus='CMF3' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch2 Withdrawn");
                   // NoSeriesMgt.InitSeries(NoSetup."Branch2 Withdrawn",xRec."No. Series",0D,"Branch2 Withdrawn","No. Series");
                    BranchNumberSeries:="Branch2 Withdrawn";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 Withdrawn",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  //MESSAGE('%1...',"File Number");
                  END;
                  IF FileStatus='CMF4' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch2 Closed");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch2 Closed",xRec."No. Series",0D,"Branch2 Closed","No. Series");
                    BranchNumberSeries:="Branch2 Closed";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 Closed",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                 // MESSAGE('%1...%2',BranchNumberSeries,"Branch2 Closed");
                  END;
                  IF FileStatus='CMF5' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch2 Deceased");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch2 Deceased",xRec."No. Series",0D,"Branch2 Deceased","No. Series");
                    BranchNumberSeries:="Branch2 Deceased";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 Deceased",TODAY,TRUE);
                    "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                    //MESSAGE('%1...',"File Number");
                  END;
                  IF FileStatus='CMF6' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch2 Volume");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch2 Volume",xRec."No. Series",0D,"Branch2 Volume","No. Series");
                    BranchNumberSeries:="Branch2 Volume";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 Volume",TODAY,TRUE);
                    "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                    //MESSAGE('%1...',"File Number");
                  END;
                END;
                //end Location 02
                
                //=====begin Location 03
                 IF Location='03' THEN BEGIN
                  IF FileStatus='CMF1' THEN BEGIN
                       NoSetup.GET;
                        NoSetup.TESTFIELD("Branch3 Active");
                       //NoSeriesMgt.InitSeries(NoSetup."Branch3 Active",xRec."No. Series",0D,"Branch3 Active","No. Series");
                        BranchNumberSeries:="Branch3 Active";
                        BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 Active",TODAY,TRUE);
                        "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                      END;
                      IF FileStatus='CMF2' THEN BEGIN
                        NoSetup.GET;
                        NoSetup.TESTFIELD("Branch3 InActive");
                        //NoSeriesMgt.InitSeries(NoSetup."Branch3 InActive",xRec."No. Series",0D,"Branch3 InActive","No. Series");
                        BranchNumberSeries:="Branch3 InActive";
                        BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 InActive",TODAY,TRUE);
                        "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  //MESSAGE('%1',"File Number");
                  IF FileStatus='CMF3' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch3 Withdrawn");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch3 Withdrawn",xRec."No. Series",0D,"Branch3 Withdrawn","No. Series");
                    BranchNumberSeries:="Branch3 Withdrawn";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 Withdrawn",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF4' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch3 Closed");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch3 Closed",xRec."No. Series",0D,"Branch3 Closed","No. Series");
                    BranchNumberSeries:="Branch3 Closed";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 Closed",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF5' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch3 Deceased");
                    NoSeriesMgt.InitSeries(NoSetup."Branch3 Deceased",xRec."No. Series",0D,"Branch3 Deceased","No. Series");
                    BranchNumberSeries:="Branch3 Deceased";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 Deceased",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF6' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch3 Volume");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch3 Volume",xRec."No. Series",0D,"Branch3 Volume","No. Series");
                    BranchNumberSeries:="Branch3 Volume";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 Volume",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                END;
                //=====end Location 3
                
                //=====Begin Location 4
                 IF Location='04' THEN BEGIN
                  IF FileStatus='CMF1' THEN BEGIN
                        NoSetup.GET;
                        NoSetup.TESTFIELD("Branch4 Active");
                        //NoSeriesMgt.InitSeries(NoSetup."Branch4 Active",xRec."No. Series",0D,"Branch4 Active","No. Series");
                        BranchNumberSeries:="Branch4 Active";
                        BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 Active",TODAY,TRUE);
                        "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                      END;
                      IF FileStatus='CMF2' THEN BEGIN
                          NoSetup.GET;
                          NoSetup.TESTFIELD("Branch4 InActive");
                         // NoSeriesMgt.InitSeries(NoSetup."Branch4 InActive",xRec."No. Series",0D,"Branch4 InActive","No. Series");
                          BranchNumberSeries:="Branch4 InActive";
                          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 InActive",TODAY,TRUE);
                      "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                      //MESSAGE(RegFileDesc);
                  END;
                  //MESSAGE('%1',"File Number");
                  IF FileStatus='CMF3' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch4 Withdrawn");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch4 Withdrawn",xRec."No. Series",0D,"Branch4 Withdrawn","No. Series");
                    BranchNumberSeries:="Branch4 Withdrawn";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 Withdrawn",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF4' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch4 Closed");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch4 Closed",xRec."No. Series",0D,"Branch4 Closed","No. Series");
                    BranchNumberSeries:="Branch4 Closed";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 Closed",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF5' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch4 Deceased");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch4 Deceased",xRec."No. Series",0D,"Branch4 Deceased","No. Series");
                    BranchNumberSeries:="Branch4 Deceased";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 Deceased",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF6' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch4 Volume");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch4 Volume",xRec."No. Series",0D,"Branch4 Volume","No. Series");
                    BranchNumberSeries:="Branch4 Volume";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 Volume",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                END;
                //=====end location 4
                
                //=====begin Location 5
                 IF Location='05' THEN BEGIN
                  IF FileStatus='CMF1' THEN BEGIN
                      //IF RegFileDesc='Active Member' THEN BEGIN
                        NoSetup.GET;
                        NoSetup.TESTFIELD("Branch5 Active");
                       //NoSeriesMgt.InitSeries(NoSetup."Branch5 Active",xRec."No. Series",0D,"Branch5 Active","No. Series");
                        BranchNumberSeries:="Branch5 Active";
                        BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 Active",TODAY,TRUE);
                        "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                      END;
                      IF FileStatus='CMF2' THEN BEGIN
                          NoSetup.GET;
                          NoSetup.TESTFIELD("Branch5 InActive");
                          //NoSeriesMgt.InitSeries(NoSetup."Branch5 InActive",xRec."No. Series",0D,"Branch5 InActive","No. Series");
                          BranchNumberSeries:="Branch5 InActive";
                          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 InActive",TODAY,TRUE);
                      "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  //MESSAGE('%1',"File Number");
                  IF FileStatus='CMF3' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch5 Withdrawn");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch5 Withdrawn",xRec."No. Series",0D,"Branch5 Withdrawn","No. Series");
                    BranchNumberSeries:="Branch5 Withdrawn";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 Withdrawn",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF4' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch5 Closed");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch5 Closed",xRec."No. Series",0D,"Branch5 Closed","No. Series");
                    BranchNumberSeries:="Branch5 Closed";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 Closed",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF5' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch5 Deceased");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch5 Deceased",xRec."No. Series",0D,"Branch5 Deceased","No. Series");
                    BranchNumberSeries:="Branch5 Deceased";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 Deceased",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF6' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch5 Volume");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch5 Volume",xRec."No. Series",0D,"Branch5 Volume","No. Series");
                    BranchNumberSeries:="Branch5 Volume";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 Volume",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                END;
                //====end Location 5
                
                //=====Begin Location 6
                 IF Location='06' THEN BEGIN
                  IF FileStatus='CMF1' THEN BEGIN
                      //IF RegFileDesc='Active Member' THEN BEGIN
                        NoSetup.GET;
                        NoSetup.TESTFIELD("Branch6 Active");
                        //NoSeriesMgt.InitSeries(NoSetup."Branch6 Active",xRec."No. Series",0D,"Branch6 Active","No. Series");
                        BranchNumberSeries:="Branch6 Active";
                        BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 Active",TODAY,TRUE);
                        "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                       END;
                      IF FileStatus='CMF2' THEN BEGIN
                          NoSetup.GET;
                          NoSetup.TESTFIELD("Branch6 InActive");
                          //NoSeriesMgt.InitSeries(NoSetup."Branch6 InActive",xRec."No. Series",0D,"Branch6 InActive","No. Series");
                          BranchNumberSeries:="Branch6 InActive";
                          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 InActive",TODAY,TRUE);
                          "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  //MESSAGE('%1',"File Number");
                  IF FileStatus='CMF3' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch6 Withdrawn");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch6 Withdrawn",xRec."No. Series",0D,"Branch6 Withdrawn","No. Series");
                    BranchNumberSeries:="Branch6 Withdrawn";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 Withdrawn",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF4' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch6 Closed");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch6 Closed",xRec."No. Series",0D,"Branch6 Closed","No. Series");
                    BranchNumberSeries:="Branch6 Closed";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 Closed",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF5' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch6 Deceased");
                   // NoSeriesMgt.InitSeries(NoSetup."Branch6 Deceased",xRec."No. Series",0D,"Branch6 Deceased","No. Series");
                    BranchNumberSeries:="Branch6 Deceased";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 Deceased",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                  IF FileStatus='CMF6' THEN BEGIN
                    NoSetup.GET;
                    NoSetup.TESTFIELD("Branch6 Volume");
                    //NoSeriesMgt.InitSeries(NoSetup."Branch6 Volume",xRec."No. Series",0D,"Branch6 Volume","No. Series");
                    BranchNumberSeries:="Branch6 Volume";
                    BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 Volume",TODAY,TRUE);
                  "File Number":=branchvalue+'/'+FileStatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
                  END;
                END;
                //====end Location 6
                */

            end;
        }
        field(31; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(68; "Request ID"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "File No.")
        {
        }
        key(Key2; "File Number")
        {
        }
        key(Key3; "File Name")
        {
        }
        key(Key4; "File Type")
        {
        }
        key(Key5; "Member No.")
        {
        }
        key(Key6; "ID No.")
        {
        }
        key(Key7; "Payroll No.")
        {
        }
        key(Key8; "Current User")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "File No.", "File Number", "File Type", "File Name", "Member No.", "ID No.", "Payroll No.", "File Request Status", "Current User")
        {
        }
    }

    trigger OnInsert();
    begin
        IF "File No." = '' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Files No.");
            NoSeriesMgt.InitSeries(NoSetup."Files No.", xRec."No. Series", 0D, "File No.", "No. Series");
        END;


        Status := Status::Active;
        "Created By" := USERID;
        "Date Created" := CURRENTDATETIME;
        Volume := 'Volume 1';
        User.RESET;
        User.GET(USERID);
        Location1 := User."Global Dimension 1 Code";
        branchvalue := '0' + Location1;

        //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        //"RegFile Status":='CMF1';
        /*
        IF Location='01' THEN BEGIN
          IF "Branch1 No."='' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Branch1 No.");
            NoSeriesMgt.InitSeries(NoSetup."Branch1 No.",xRec."No. Series",0D,"Branch1 No.","No. Series");
          END;
        END;
        IF Location='02' THEN BEGIN
          IF "Branch2 No."='' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Branch2 No.");
            NoSeriesMgt.InitSeries(NoSetup."Branch2 No.",xRec."No. Series",0D,"Branch2 No.","No. Series");
          END;
        END;
        IF Location='03' THEN BEGIN
          IF "Branch3 No."='' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Branch3 No.");
            NoSeriesMgt.InitSeries(NoSetup."Branch3 No.",xRec."No. Series",0D,"Branch3 No.","No. Series");
          END;
        END;
        IF Location='04' THEN BEGIN
          IF "Branch4 No."='' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Branch4 No.");
            NoSeriesMgt.InitSeries(NoSetup."Branch4 No.",xRec."No. Series",0D,"Branch4 No.","No. Series");
          END;
        END;
        IF Location='05' THEN BEGIN
          IF "Branch5 No."='' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Branch5 No.");
            NoSeriesMgt.InitSeries(NoSetup."Branch5 No.",xRec."No. Series",0D,"Branch5 No.","No. Series");
          END;
        END;
        IF Location='06' THEN BEGIN
          IF "Branch6 No."='' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Branch6 No.");
            NoSeriesMgt.InitSeries(NoSetup."Branch6 No.",xRec."No. Series",0D,"Branch6 No.","No. Series");
          END;
        END;
        
        */
        /*
        noseries.RESET;
        IF noseries.GET("No. Series") THEN BEGIN
          "File Type":=noseries."Linked File Type";
        END;*/

        //'''''''''''''''''''''''''''''''''''''''''''''''''''''''
        User.RESET;
        User.GET(USERID);
        Location1 := User."Global Dimension 1 Code";
        branchvalue := '0' + Location1;
        //''''''''''''''''''''''''''''''''''''''''''''''''''''''''


        /*
        IF Location='01' THEN BEGIN
          BranchNumberSeries:="Branch1 No.";
          END;
        IF Location='02' THEN BEGIN
          BranchNumberSeries:="Branch2 No.";
          END;
        IF Location='03' THEN BEGIN
          BranchNumberSeries:="Branch3 No.";
          END;
        IF Location='04' THEN BEGIN
          BranchNumberSeries:="Branch4 No.";
          END;
        IF Location='05' THEN BEGIN
          BranchNumberSeries:="Branch5 No.";
          END;
        IF Location='06' THEN BEGIN
          BranchNumberSeries:="Branch6 No.";
          END;
        */

        //MESSAGE('%1,%2',CurrentYear,branchvalue);
        IF "RegFile Status" <> '' THEN BEGIN

            // "File Number" := branchvalue + '/' + FileStatus + '/' + BranchNumberSeries + '/' + FORMAT(CurrentYear);
        END;

    end;

    trigger OnRename();
    begin
        IF "File No." <> '' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Files No.");
            NoSeriesMgt.InitSeries(NoSetup."Files No.", xRec."No. Series", 0D, "File No.", "No. Series");
        END;
        /*noseries.RESET;
        IF noseries.GET("No. Series") THEN BEGIN
          "File Type":=noseries."Linked File Type";
        END;*/

    end;

    var
        NoSetup: Record "Registry SetUp";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //Vendor: Record "23";
        //Customer: Record 
        noseries: Record "No. Series";
        registry: Record "Registry File";
        //DimensionValue: Record "349";
        User: Record "User Setup";
        Branch1: Text;
        Branch2: Text;
        // MemberAgencies: Record "50018";
        branchvalue: Code[10];
        branchvalue2: Code[10];
        CurrentYear: Integer;
        BranchNumberSeries: Code[10];
        FileStatus: Code[10];
        RegistryFileStatus: Record "Registry File Status";
        RegFileDesc: Text[50];
        RegistryNumbers: Record "Registry Number";
        Member: Record Member;

    procedure NewFileNumber(var branch: Code[10]; var filestatus: Code[10]);
    begin

        User.RESET;
        User.GET(USERID);
        branch := '02';
        branchvalue := '0' + branch;
        CurrentYear := DATE2DMY(TODAY, 3);

        RegistryNumbers.RESET;
        // RegistryNumbers.GET(branch, filestatus);
        RegistryNumbers.SETRANGE(Branch, branch);//MESSAGE('%1..%2',RegistryNumbers.Branch,Location);
        RegistryNumbers.SETRANGE("RegFile Status", filestatus);
        IF RegistryNumbers.FINDFIRST THEN BEGIN
            RegistryNumbers.TESTFIELD("No. Series");//MESSAGE('in');
            //NoSeriesMgt.InitSeries(RegistryNumbers."Branch1 Active", xRec."No. Series", 0D, "Branch1 Active", "No. Series");
            BranchNumberSeries := RegistryNumbers."No. Series";
            BranchNumberSeries := NoSeriesMgt.GetNextNo(RegistryNumbers."No. Series", TODAY, TRUE);
            "File Number" := branchvalue + '/' + filestatus + '/' + BranchNumberSeries + '/' + FORMAT(CurrentYear);
            //MESSAGE('%1',"File Number");
        END;
        MODIFY
        /*
      //=====begin Location 01
       IF branch='01' THEN BEGIN
        IF filestatus='CMF1' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch1 Active");
          //NoSeriesMgt.InitSeries(NoSetup."Branch1 Active",xRec."No. Series",0D,"Branch1 Active","No. Series");
          BranchNumberSeries:="Branch1 Active";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 Active",TODAY,TRUE);
          "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF2' THEN BEGIN
              NoSetup.GET;
              NoSetup.TESTFIELD("Branch1 InActive");
              //NoSeriesMgt.InitSeries(NoSetup."Branch1 InActive",xRec."No. Series",0D,"Branch1 InActive","No. Series");
              //MESSAGE("Branch1 InActive");
              BranchNumberSeries:="Branch1 InActive";
              BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 InActive",TODAY,TRUE);
              "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
            END;

        //MESSAGE('%1',"File Number");
        IF filestatus='CMF3' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch1 Withdrawn");
          //NoSeriesMgt.InitSeries(NoSetup."Branch1 Withdrawn",xRec."No. Series",0D,"Branch1 Withdrawn","No. Series");
          BranchNumberSeries:="Branch1 Withdrawn";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 Withdrawn",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF4' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch1 Closed");
          //MESSAGE(NoSeriesMgt.GetNextNo(NoSetup."Branch1 Closed",TODAY,FALSE));
          NoSeriesMgt.InitSeries(NoSetup."Branch1 Closed",xRec."No. Series",0D,"Branch1 Closed","No. Series");
          //MESSAGE("Branch1 Closed");
          BranchNumberSeries:="Branch1 Closed";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 Closed",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF5' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch1 Deceased");
          //NoSeriesMgt.InitSeries(NoSetup."Branch1 Deceased",xRec."No. Series",0D,"Branch1 Deceased","No. Series");
          BranchNumberSeries:="Branch1 Deceased";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 Deceased",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF6' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch1 Volume");
          //NoSeriesMgt.InitSeries(NoSetup."Branch1 Volume",xRec."No. Series",0D,"Branch1 Volume","No. Series");
          BranchNumberSeries:="Branch1 Volume";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch1 Volume",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
      END;//end branch 01

      //begin branch 02
      IF branch='02' THEN BEGIN
        IF filestatus='CMF1' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Branch2 Active");
            //NoSeriesMgt.InitSeries(NoSetup."Branch2 Active",xRec."No. Series",0D,"Branch2 Active","No. Series");
            BranchNumberSeries:="Branch2 Active";
            BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 Active",TODAY,TRUE);
            "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
            //MESSAGE('%1...',"File Number");
         END;
         IF filestatus='CMF2' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Branch2 InActive");
            //NoSeriesMgt.InitSeries(NoSetup."Branch2 InActive",xRec."No. Series",0D,"Branch2 InActive","No. Series");
            BranchNumberSeries:="Branch2 InActive";
            BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 InActive",TODAY,TRUE);
            "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
            //MESSAGE('%1...',"File Number");
        END;
        IF filestatus='CMF3' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch2 Withdrawn");
         // NoSeriesMgt.InitSeries(NoSetup."Branch2 Withdrawn",xRec."No. Series",0D,"Branch2 Withdrawn","No. Series");
          BranchNumberSeries:="Branch2 Withdrawn";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 Withdrawn",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        //MESSAGE('%1...',"File Number");
        END;
        IF filestatus='CMF4' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch2 Closed");
          //NoSeriesMgt.InitSeries(NoSetup."Branch2 Closed",xRec."No. Series",0D,"Branch2 Closed","No. Series");
          BranchNumberSeries:="Branch2 Closed";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 Closed",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
       // MESSAGE('%1...%2',BranchNumberSeries,"Branch2 Closed");
        END;
        IF filestatus='CMF5' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch2 Deceased");
          //NoSeriesMgt.InitSeries(NoSetup."Branch2 Deceased",xRec."No. Series",0D,"Branch2 Deceased","No. Series");
          BranchNumberSeries:="Branch2 Deceased";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 Deceased",TODAY,TRUE);
          "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
          //MESSAGE('%1...',"File Number");
        END;
        IF filestatus='CMF6' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch2 Volume");
          //NoSeriesMgt.InitSeries(NoSetup."Branch2 Volume",xRec."No. Series",0D,"Branch2 Volume","No. Series");
          BranchNumberSeries:="Branch2 Volume";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch2 Volume",TODAY,TRUE);
          "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
          //MESSAGE('%1...',"File Number");
        END;
      END;
      //end branch 02

      //=====begin branch 03
       IF branch='03' THEN BEGIN
        IF filestatus='CMF1' THEN BEGIN
             NoSetup.GET;
              NoSetup.TESTFIELD("Branch3 Active");
             //NoSeriesMgt.InitSeries(NoSetup."Branch3 Active",xRec."No. Series",0D,"Branch3 Active","No. Series");
              BranchNumberSeries:="Branch3 Active";
              BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 Active",TODAY,TRUE);
              "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
            END;
            IF filestatus='CMF2' THEN BEGIN
              NoSetup.GET;
              NoSetup.TESTFIELD("Branch3 InActive");
              //NoSeriesMgt.InitSeries(NoSetup."Branch3 InActive",xRec."No. Series",0D,"Branch3 InActive","No. Series");
              BranchNumberSeries:="Branch3 InActive";
              BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 InActive",TODAY,TRUE);
              "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        //MESSAGE('%1',"File Number");
        IF filestatus='CMF3' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch3 Withdrawn");
          //NoSeriesMgt.InitSeries(NoSetup."Branch3 Withdrawn",xRec."No. Series",0D,"Branch3 Withdrawn","No. Series");
          BranchNumberSeries:="Branch3 Withdrawn";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 Withdrawn",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF4' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch3 Closed");
          //NoSeriesMgt.InitSeries(NoSetup."Branch3 Closed",xRec."No. Series",0D,"Branch3 Closed","No. Series");
          BranchNumberSeries:="Branch3 Closed";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 Closed",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF5' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch3 Deceased");
          NoSeriesMgt.InitSeries(NoSetup."Branch3 Deceased",xRec."No. Series",0D,"Branch3 Deceased","No. Series");
          BranchNumberSeries:="Branch3 Deceased";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 Deceased",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF6' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch3 Volume");
          //NoSeriesMgt.InitSeries(NoSetup."Branch3 Volume",xRec."No. Series",0D,"Branch3 Volume","No. Series");
          BranchNumberSeries:="Branch3 Volume";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch3 Volume",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
      END;
      //=====end branch 3

      //=====Begin branch 4
       IF branch='04' THEN BEGIN
        IF filestatus='CMF1' THEN BEGIN
              NoSetup.GET;
              NoSetup.TESTFIELD("Branch4 Active");
              //NoSeriesMgt.InitSeries(NoSetup."Branch4 Active",xRec."No. Series",0D,"Branch4 Active","No. Series");
              BranchNumberSeries:="Branch4 Active";
              BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 Active",TODAY,TRUE);
              "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
            END;
            IF filestatus='CMF2' THEN BEGIN
                NoSetup.GET;
                NoSetup.TESTFIELD("Branch4 InActive");
               // NoSeriesMgt.InitSeries(NoSetup."Branch4 InActive",xRec."No. Series",0D,"Branch4 InActive","No. Series");
                BranchNumberSeries:="Branch4 InActive";
                BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 InActive",TODAY,TRUE);
            "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
            //MESSAGE(RegFileDesc);
        END;
        //MESSAGE('%1',"File Number");
        IF filestatus='CMF3' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch4 Withdrawn");
          //NoSeriesMgt.InitSeries(NoSetup."Branch4 Withdrawn",xRec."No. Series",0D,"Branch4 Withdrawn","No. Series");
          BranchNumberSeries:="Branch4 Withdrawn";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 Withdrawn",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF4' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch4 Closed");
          //NoSeriesMgt.InitSeries(NoSetup."Branch4 Closed",xRec."No. Series",0D,"Branch4 Closed","No. Series");
          BranchNumberSeries:="Branch4 Closed";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 Closed",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF5' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch4 Deceased");
          //NoSeriesMgt.InitSeries(NoSetup."Branch4 Deceased",xRec."No. Series",0D,"Branch4 Deceased","No. Series");
          BranchNumberSeries:="Branch4 Deceased";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 Deceased",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF6' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch4 Volume");
          //NoSeriesMgt.InitSeries(NoSetup."Branch4 Volume",xRec."No. Series",0D,"Branch4 Volume","No. Series");
          BranchNumberSeries:="Branch4 Volume";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch4 Volume",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
      END;
      //=====end branch 4

      //=====begin branch 5
       IF branch='05' THEN BEGIN
        IF filestatus='CMF1' THEN BEGIN
            //IF RegFileDesc='Active Member' THEN BEGIN
              NoSetup.GET;
              NoSetup.TESTFIELD("Branch5 Active");
             //NoSeriesMgt.InitSeries(NoSetup."Branch5 Active",xRec."No. Series",0D,"Branch5 Active","No. Series");
              BranchNumberSeries:="Branch5 Active";
              BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 Active",TODAY,TRUE);
              "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
            END;
            IF filestatus='CMF2' THEN BEGIN
                NoSetup.GET;
                NoSetup.TESTFIELD("Branch5 InActive");
                //NoSeriesMgt.InitSeries(NoSetup."Branch5 InActive",xRec."No. Series",0D,"Branch5 InActive","No. Series");
                BranchNumberSeries:="Branch5 InActive";
                BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 InActive",TODAY,TRUE);
            "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        //MESSAGE('%1',"File Number");
        IF filestatus='CMF3' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch5 Withdrawn");
          //NoSeriesMgt.InitSeries(NoSetup."Branch5 Withdrawn",xRec."No. Series",0D,"Branch5 Withdrawn","No. Series");
          BranchNumberSeries:="Branch5 Withdrawn";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 Withdrawn",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF4' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch5 Closed");
          //NoSeriesMgt.InitSeries(NoSetup."Branch5 Closed",xRec."No. Series",0D,"Branch5 Closed","No. Series");
          BranchNumberSeries:="Branch5 Closed";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 Closed",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF5' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch5 Deceased");
          //NoSeriesMgt.InitSeries(NoSetup."Branch5 Deceased",xRec."No. Series",0D,"Branch5 Deceased","No. Series");
          BranchNumberSeries:="Branch5 Deceased";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 Deceased",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF6' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch5 Volume");
          //NoSeriesMgt.InitSeries(NoSetup."Branch5 Volume",xRec."No. Series",0D,"Branch5 Volume","No. Series");
          BranchNumberSeries:="Branch5 Volume";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch5 Volume",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
      END;
      //====end branch 5

      //=====Begin branch 6
       IF branch='06' THEN BEGIN
        IF filestatus='CMF1' THEN BEGIN
            //IF RegFileDesc='Active Member' THEN BEGIN
              NoSetup.GET;
              NoSetup.TESTFIELD("Branch6 Active");
              //NoSeriesMgt.InitSeries(NoSetup."Branch6 Active",xRec."No. Series",0D,"Branch6 Active","No. Series");
              BranchNumberSeries:="Branch6 Active";
              BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 Active",TODAY,TRUE);
              "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
             END;
            IF filestatus='CMF2' THEN BEGIN
                NoSetup.GET;
                NoSetup.TESTFIELD("Branch6 InActive");
                //NoSeriesMgt.InitSeries(NoSetup."Branch6 InActive",xRec."No. Series",0D,"Branch6 InActive","No. Series");
                BranchNumberSeries:="Branch6 InActive";
                BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 InActive",TODAY,TRUE);
                "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        //MESSAGE('%1',"File Number");
        IF filestatus='CMF3' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch6 Withdrawn");
          //NoSeriesMgt.InitSeries(NoSetup."Branch6 Withdrawn",xRec."No. Series",0D,"Branch6 Withdrawn","No. Series");
          BranchNumberSeries:="Branch6 Withdrawn";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 Withdrawn",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF4' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch6 Closed");
          //NoSeriesMgt.InitSeries(NoSetup."Branch6 Closed",xRec."No. Series",0D,"Branch6 Closed","No. Series");
          BranchNumberSeries:="Branch6 Closed";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 Closed",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF5' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch6 Deceased");
         // NoSeriesMgt.InitSeries(NoSetup."Branch6 Deceased",xRec."No. Series",0D,"Branch6 Deceased","No. Series");
          BranchNumberSeries:="Branch6 Deceased";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 Deceased",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
        IF filestatus='CMF6' THEN BEGIN
          NoSetup.GET;
          NoSetup.TESTFIELD("Branch6 Volume");
          //NoSeriesMgt.InitSeries(NoSetup."Branch6 Volume",xRec."No. Series",0D,"Branch6 Volume","No. Series");
          BranchNumberSeries:="Branch6 Volume";
          BranchNumberSeries:=NoSeriesMgt.GetNextNo(NoSetup."Branch6 Volume",TODAY,TRUE);
        "File Number":=branchvalue+'/'+filestatus+'/'+BranchNumberSeries+'/'+FORMAT(CurrentYear);
        END;
      END;
      */
        //====end branch 6

    end;
}

