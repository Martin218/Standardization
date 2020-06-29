table 50495 "CEO Schedule"
{
    // version TL2.0

    //Caption = 'To-do';
    //DrillDownPageID = 5096;
    //LookupPageID = 5096;

    fields
    {
        field(1; "No."; Code[30])
        {

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    NoSetup.GET();
                    //NoSeriesMgt.TestManual(NoSetup.Comments);
                    "No.Series" := '';
                END;
            end;
        }
        field(2; Date; Date)
        {
        }
        field(3; "No of meetings"; Integer)
        {
        }
        field(4; "Meeting Type"; Option)
        {
            OptionMembers = ,"Managers meeting","Credit Committee","Audit Committee","Education Committee","Finance & Administration","Board meeting",SPIC,"Board&Supervisory",External;
        }
        field(5; "No of appointments"; Integer)
        {
        }
        field(6; "Appointments type"; Option)
        {
            OptionMembers = ,Official,Personal;
        }
        field(7; "Appointments time"; Code[200])
        {
        }
        field(8; Schedule; Boolean)
        {
        }
        field(9; User; Text[30])
        {
            Editable = false;
        }
        field(10; Comments; Code[100])
        {
        }
        field(11; "No.Series"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
        //fieldgroup(DropDown; "No.", Field12, Comments)

    }

    trigger OnDelete();
    var
    //Attendee: Record "5199";
    //Todo: Record "5080";
    //TodoInteractionLanguage: Record "5196";
    begin
        /*RMCommentLine.SETRANGE("Table Name",RMCommentLine."Table Name"::"To-do");
        RMCommentLine.SETRANGE("No.","No.");
        RMCommentLine.DELETEALL;
        Todo.SETRANGE("Organizer To-do No.","No.");
        Todo.SETFILTER("No.",'<>%1',"No.");
        IF Todo.FINDFIRST THEN
          Todo.DELETEALL;
        
        Attendee.SETRANGE("To-do No.","No.");
        Attendee.DELETEALL;
        
        TodoInteractionLanguage.SETRANGE("To-do No.","No.");
        TodoInteractionLanguage.DELETEALL(TRUE);*/

    end;

    trigger OnInsert();
    begin
        User := USERID;
        IF "No." = '' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD(Comments);
            //NoSeriesMgt.InitSeries(NoSetup.Comments, xRec."No.Series", 0D, "No.", "No.Series");
        END;
    end;

    trigger OnModify();
    begin
        /*IF "No." <> '' THEN BEGIN
          "Last Date Modified" := TODAY;
          CreateAttendeesFromTeam := TIME;
        
          UpdateAttendeeTodos("No.");
        END;*/

    end;

    var
        Text000: Label '%1 must be specified.';
        Text001: Label '%1 No. %2 has been created from recurring %3 %4.';
        Text002: TextConst Comment = '%1 = Segment Header No.', ENU = 'Do you want to create a To-do for all contacts in the %1 Segment';
        Text003: TextConst Comment = '%1 = Segment Header No.', ENU = 'Do you want to assign an activity to all Contacts in the %1 Segment';
        Text004: Label 'Do you want to register an Interaction Log Entry?';
        Text005: Label 'Information that you have entered in this field will cause the duration to be negative which is not allowed. Please modify the ending date/time value.';
        Text006: Label 'The valid range of dates is from %1 to %2. Please enter a date within this range.';
        Text007: Label 'Information that you have entered in this field will cause the duration to be less than 1 minute, which is not allowed. Please modify the ending date/time value.';
        Text008: Label 'Information that you have entered in this field will cause the duration to be more than 10 years, which is not allowed. Please modify the ending date/time value.';
        Text009: TextConst Comment = '%1=Salesperson Code', ENU = 'You cannot change the %1 for this To-do, because this salesperson is the meeting organizer.';
        Text010: TextConst Comment = '%1=To-do Interaction Language,%2=Language Code', ENU = 'Do you want to create a new %2 value in %1 for this To-do?';
        Text012: Label 'You cannot change a to-do type from Blank or Phone Call to Meeting and vice versa. You can only change a To-do type from Blank to Phone Call or from Phone Call to Blank.';
        Text015: Label 'Dear %1,';
        Text016: TextConst Comment = '%1 = To-Do Date,%2 = To-Do StartTime,%3=To-Do location', ENU = 'You are cordially invited to attend the meeting, which will take place on %1, %2 at %3.';
        Text017: Label 'Yours sincerely,';
        Text018: Label 'The %1 check box is not selected.';
        Text019: Label 'Send invitations to all Attendees with selected %1 check boxes.';
        Text020: Label 'Send invitations to Attendees who have not been sent invitations yet.';
        Text021: Label 'Do not send invitations.';
        Text022: Label 'Invitations have already been sent to Attendees with selected %1 check boxes. Do you want to resend the invitations?';
        Text023: Label 'Outlook failed to send an invitation to %1.';
        Text029: TextConst Comment = '%1=Completed By', ENU = 'The %1 field must be filled in for To-dos assigned to a team.';
        Text030: Label 'The to-dos of the %1 team members who do not belong to the %2 team will be deleted. Do you want to continue?';
        Text032: TextConst Comment = '%1=To-do No.,%2=Salesperson Code', ENU = 'To-do No. %1 will be reassigned to %2 and the corresponding salesperson To-dos for team members will be deleted. Do you want to continue?';
        Text033: TextConst Comment = '%1=To-do No.,%2=Salesperson Code', ENU = 'To-do No. %1 will be reassigned to %2. Do you want to continue?';
        Text034: Label 'Do you want to close the To-do?';
        Text035: Label 'You must fill in either the %1 field or the %2 field.';
        Text036: Label 'Creating To-dos...\';
        Text037: Label 'To-do No. #1##############\';
        Text038: Label 'Status    @2@@@@@@@@@@@@@@';
        Text039: TextConst Comment = '%1=To-do No,%2=Team Code,%3=Team Code', ENU = 'To-do No. %1 is closed and will be reopened. The To-dos of the %2 team members who do not belong to the %3 team will be deleted. Do you want to continue?';
        Text040: TextConst Comment = '%1=To-do No.,%2=Salesperson Code', ENU = 'To-do No. %1 is closed and will be reopened. It will be reassigned to %2, and the corresponding salesperson To-dos for team members will be deleted. Do you want to continue?';
        Text041: TextConst Comment = '%1=To-do No.,%2=Salesperson Code', ENU = 'To-do No. %1 is closed. It will be reopened and reassigned to %2. Do you want to continue?';
        Text042: TextConst Comment = '%1=To-do No.,%2=Team Code', ENU = 'To-do No. %1 is closed. Do you want to reopen it and assign to the %2 team?';
        Text043: Label 'You must fill in the %1 field.';
        Text047: Label 'You cannot use the wizard to create an attachment. You can create an attachment in the Interaction Template window.';
        Text051: Label 'Activity Code';
        Text053: Label 'You must specify %1 or %2.';
        Text056: TextConst Comment = '%1=Activity Code', ENU = 'Activity %1 contains To-dos of type Meeting. You must fill in the Meeting Organizer field.';
        Text065: Label 'You must specify the To-do organizer.';
        Text067: Label 'The %1 must contain an attachment if you want to send an invitation to an %2 of the contact type.';
        Text068: Label 'You cannot select the Send invitation(s) on Finish check box, because none of the %1 check boxes are selected.';
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSetup: Record "Admin Numbering Setup";

    //procedure CreateToDoFromToDo(var ToDo: Record "5080");
    var
    // Cont: Record "5050";
    // SalesPurchPerson: Record "13";
    //Team: Record "5083";
    //Campaign: Record "5071";
    //Opp: Record "5092";
    //SegHeader: Record "5076";
    //begin
    /*DELETEALL;
    INIT;
    IF ToDo.GETFILTER("Contact Company No.") <> '' THEN
      IF Cont.GET(ToDo.GETRANGEMIN("Contact Company No.")) THEN BEGIN
        VALIDATE("No of appointments",Cont."No.");
        "No of meetings" := Cont."Salesperson Code";
        SETRANGE("Contact Company No.","No of appointments");
      END;
    IF Cont.GET(ToDo.GETFILTER("Contact No.")) THEN BEGIN
      VALIDATE("No of appointments",Cont."No.");
      "No of meetings" := Cont."Salesperson Code";
      SETRANGE("No of appointments","No of appointments");
    END;
    IF SalesPurchPerson.GET(ToDo.GETFILTER("Salesperson Code")) THEN BEGIN
      "No of meetings" := SalesPurchPerson.Code;
      SETRANGE("No of meetings","No of meetings");
    END;
    IF Team.GET(ToDo.GETFILTER("Team Code")) THEN BEGIN
      VALIDATE(Date,Team.Code);
      SETRANGE(Date,Date);
    END;
    IF Campaign.GET(ToDo.GETFILTER("Campaign No.")) THEN BEGIN
      "Meeting Type" := Campaign."No.";
      "No of meetings" := Campaign."Salesperson Code";
      SETRANGE("Meeting Type","Meeting Type");
    END;
    IF Opp.GET(ToDo.GETFILTER("Opportunity No.")) THEN BEGIN
      VALIDATE("Appointments type",Opp."No.");
      "No of appointments" := Opp."Contact No.";
      "Contact Company No." := Opp."Contact Company No.";
      "Meeting Type" := Opp."Campaign No.";
      "No of meetings" := Opp."Salesperson Code";
      SETRANGE("Appointments type","Appointments type");
    END;
    IF SegHeader.GET(ToDo.GETFILTER("Segment No.")) THEN BEGIN
      "Appointments time" := SegHeader."No.";
      "Meeting Type" := SegHeader."Campaign No.";
      "No of meetings" := SegHeader."Salesperson Code";
      SETRANGE("Appointments time","Appointments time");
    END;

    StartWizard;*/

    //end;

    //procedure CreateToDoFromSalesHeader(SalesHeader: Record "36");
    //begin
    /*DELETEALL;
    INIT;
    VALIDATE("No of appointments",SalesHeader."Sell-to Contact No.");
    SETRANGE("No of appointments",SalesHeader."Sell-to Contact No.");
    IF SalesHeader."Salesperson Code" <> '' THEN BEGIN
      "No of meetings" := SalesHeader."Salesperson Code";
      SETRANGE("No of meetings","No of meetings");
    END;
    IF SalesHeader."Campaign No." <> '' THEN BEGIN
      "Meeting Type" := SalesHeader."Campaign No.";
      SETRANGE("Meeting Type","Meeting Type");
    END;

    StartWizard;*/

    //end;

    //procedure CreateToDoFromInteractLogEntry(InteractionLogEntry: Record "5065");
    //begin
    /*INIT;
    VALIDATE("No of appointments",InteractionLogEntry."Contact No.");
    "No of meetings" := InteractionLogEntry."Salesperson Code";
    "Meeting Type" := InteractionLogEntry."Campaign No.";

    StartWizard;*/

    //end;

    local procedure CreateInteraction();
    var
    //TempSegLine: Record "5077" temporary;
    begin
        //TempSegLine.CreateInteractionFromToDo(Rec);
    end;

    local procedure CreateRecurringTodo();
    var
    // RMCommentLine: Record "5061";
    //ToDo2: Record "5080";
    //TodoInteractLanguage: Record "5196";
    //Attachment: Record "5062";
    //Attendee: Record "5199";
    //TempAttendee: Record "5199" temporary;
    //RMCommentLine3: Record "5061";
    begin
        /*TESTFIELD(FindAttendeeTodo);
        IF ImportAttachment = ImportAttachment::"0" THEN
          ERROR(
            STRSUBSTNO(Text000,FIELDCAPTION(ImportAttachment)));
        
        //ToDo2 := Rec;
        WITH ToDo2 DO BEGIN
          Status := 0;
          Closed := FALSE;
          Canceled := FALSE;
          "Date Closed" := 0D;
          "Completed By" := '';
          CASE "Calc. Due Date From" OF
            "Calc. Due Date From"::"Due Date":
              Date := CALCDATE("Recurring Date Interval",Date);
            "Calc. Due Date From"::"Closing Date":
              Date := CALCDATE("Recurring Date Interval",TODAY);
          END;
          GetEndDateTime;
        
          WITH RMCommentLine3 DO BEGIN
            RESET;
            SETRANGE("Table Name",RMCommentLine."Table Name"::"To-do");
            SETRANGE("No.","No.");
            SETRANGE("Sub No.",0);
          END;
        
          TodoInteractLanguage.SETRANGE("To-do No.","No.");
        
          IF Type = Type::Meeting THEN BEGIN
            Attendee.SETRANGE("To-do No.","No.");
            GET(InsertTodoAndRelatedData(
                ToDo2,TodoInteractLanguage,Attachment,Attendee,RMCommentLine3));
          END ELSE BEGIN
            CreateAttendeesFromTodo(TempAttendee,ToDo2,'');
            GET(InsertTodoAndRelatedData(
                ToDo2,TodoInteractLanguage,Attachment,TempAttendee,RMCommentLine3));
          END;
        END;
        
        MESSAGE(
          STRSUBSTNO(Text001,
            TABLECAPTION,ToDo2."Organizer To-do No.",TABLECAPTION,"No."));*/

    end;

    // procedure InsertTodo(Todo2: Record "5080"; var RMCommentLineTmp: Record "5061"; var TempAttendee: Record "5199" temporary; var TodoInteractLanguageTemp: Record "5196"; var TempAttachment: Record "5062" temporary; ActivityCode: Code[10]; Deliver: Boolean);
    var
        //SegHeader: Record "5076";
        //SegLine: Record "5077";
        ConfirmText: Text[250];
    /* begin
         /*IF SegHeader.GET(GETFILTER("Appointments time")) THEN BEGIN
           SegLine.SETRANGE("Segment No.",SegHeader."No.");
           SegLine.SETFILTER("Contact No.",'<>%1','');
           IF SegLine.FINDFIRST THEN BEGIN
             IF ActivityCode = '' THEN
               ConfirmText := Text002
             ELSE
               ConfirmText := Text003;
             IF CONFIRM(ConfirmText,TRUE,SegHeader."No.") THEN BEGIN
               IF ActivityCode = '' THEN BEGIN
                 Todo2.GET(InsertTodoAndRelatedData(
                     Todo2,TodoInteractLanguageTemp,
                     TempAttachment,TempAttendee,RMCommentLineTmp));
                 IF (Todo2.Type = Schedule::"1") AND Deliver THEN
                   SendMAPIInvitations(Todo2,TRUE);
               END ELSE
                 InsertActivityTodo(Todo2,ActivityCode,TempAttendee);
             END;
           END;
         END ELSE BEGIN
           IF ActivityCode = '' THEN BEGIN
             Todo2.GET(InsertTodoAndRelatedData(
                 Todo2,TodoInteractLanguageTemp,
                 TempAttachment,TempAttendee,RMCommentLineTmp));
             IF (Todo2.Type = Schedule::"1") AND Deliver THEN
               SendMAPIInvitations(Todo2,TRUE);
           END ELSE
             InsertActivityTodo(Todo2,ActivityCode,TempAttendee);
         END;

         IF (Todo2.Type = Todo2.Type::Meeting) AND
            Todo2.GET(Todo2."Organizer To-do No.")
         THEN
           Todo2.ArrangeOrganizerAttendee*/

    //end;

    //local procedure InsertTodoAndRelatedData(Todo2: Record "5080"; var TodoInteractLanguage: Record "5196"; var Attachment: Record "5062"; var Attendee: Record "5199"; var RMCommentLine: Record "5061") TodoNo: Code[20];
    var
        //TodoInteractLanguage2: Record "5196";
        //TempAttendee: Record "5199" temporary;
        //Todo: Record "5080";
        // TeamSalesperson: Record "5084";
        // Attendee2: Record "5199";
        Window: Dialog;
        AttendeeCounter: Integer;
        TotalAttendees: Integer;
        CommentLineInserted: Boolean;
    //begin/
    /*IF Todo2."Team Code" = '' THEN
      Todo2."System To-do Type" := LoadTempAttachment::"0"
    ELSE
      Todo2."System To-do Type" := LoadTempAttachment::"3";
    IF Todo2.Type = Schedule::"1" THEN BEGIN
      CLEAR(Todo2."No.");
      IF Todo2."System To-do Type" = Todo2."System To-do Type"::Team THEN
        Todo2."Salesperson Code" := '';
      Todo2.INSERT(TRUE);

      CreateTodoInteractLanguages(TodoInteractLanguage,Attachment,Todo2."No.");
      IF TodoInteractLanguage2.GET(Todo2."No.",Todo2."Language Code") THEN BEGIN
        Todo2."Attachment No." := TodoInteractLanguage2."Attachment No.";
        Todo2.MODIFY;
      END;

      IF Date <> '' THEN BEGIN
        Attendee.SETCURRENTKEY("To-do No.","Attendance Type");
        Attendee.SETRANGE("Attendance Type",Attendee."Attendance Type"::"To-do Organizer");
        IF Attendee.FIND('-') THEN BEGIN
          CreateSubTodo(Attendee,Todo2);
          Attendee2.INIT;
          Attendee2 := Attendee;
          Attendee2."To-do No." := Todo2."No.";
          Attendee2.INSERT;
        END;
        Attendee.SETFILTER("Attendance Type",'<>%1',Attendee."Attendance Type"::"To-do Organizer")
      END;
      IF Attendee.FIND('-') THEN
        REPEAT
          CreateSubTodo(Attendee,Todo2);
          Attendee2.INIT;
          Attendee2 := Attendee;
          Attendee2."To-do No." := Todo2."No.";
          Attendee2.INSERT
        UNTIL Attendee.NEXT = 0;

      Todo2.GetMeetingOrganizerTodo(Todo);
      TodoNo := Todo."No."
    END ELSE
      IF Todo2."Segment No." = '' THEN BEGIN
        CLEAR(Todo2."No.");

        Todo2.INSERT(TRUE);
        TodoNo := Todo2."No.";
        IF Todo2."System To-do Type" = LoadTempAttachment::"3" THEN BEGIN
          TeamSalesperson.SETRANGE("Team Code",Todo2."Team Code");
          IF TeamSalesperson.FIND('-') THEN
            REPEAT
              TempAttendee.CreateAttendee(
                TempAttendee,
                Todo2."No.",10000,
                TempAttendee."Attendance Type"::"To-do Organizer",
                TempAttendee."Attendee Type"::Salesperson,
                TeamSalesperson."Salesperson Code",
                TRUE);
              CreateSubTodo(TempAttendee,Todo2);
              TempAttendee.DELETEALL
            UNTIL TeamSalesperson.NEXT = 0
        END;
        IF Attendee.FIND('-') THEN
          REPEAT
            CreateSubTodo(Attendee,Todo2);
          UNTIL Attendee.NEXT = 0;
      END ELSE
        IF Attendee.FIND('-') THEN BEGIN
          Window.OPEN(Text036 + Text037 + Text038);
          TotalAttendees := Attendee.COUNT;
          REPEAT
            IF Todo2."System To-do Type" = LoadTempAttachment::"3" THEN BEGIN
              Todo.INIT;
              Todo := Todo2;
              CLEAR(Todo."No.");
              FillSalesPersonContact(Todo,Attendee);
              Todo.INSERT(TRUE);
              TodoNo := Todo."No.";
              TempAttendee.INIT;
              TempAttendee := Attendee;
              TempAttendee.INSERT;
              CreateSubTodo(TempAttendee,Todo);
              TempAttendee.DELETEALL;
              TeamSalesperson.SETRANGE("Team Code",Todo."Team Code");
              IF TeamSalesperson.FIND('-') THEN
                REPEAT
                  TempAttendee.CreateAttendee(
                    TempAttendee,
                    "No.",10000,
                    TempAttendee."Attendance Type"::"To-do Organizer",
                    TempAttendee."Attendee Type"::Salesperson,
                    TeamSalesperson."Salesperson Code",
                    TRUE);
                  CreateSubTodo(TempAttendee,Todo);
                  TempAttendee.DELETEALL
                UNTIL TeamSalesperson.NEXT = 0
            END ELSE BEGIN
              Todo.INIT;
              Todo := Todo2;
              CLEAR(Todo."No.");
              Todo."System To-do Type" := LoadTempAttachment::"0";
              FillSalesPersonContact(Todo,Attendee);
              Todo.INSERT(TRUE);
              TodoNo := Todo."No.";

              TempAttendee.INIT;
              TempAttendee := Attendee;
              TempAttendee.INSERT;
              CreateSubTodo(TempAttendee,Todo);
            END;
            AttendeeCounter := AttendeeCounter + 1;
            CreateCommentLines(RMCommentLine,TodoNo);
            Window.UPDATE(1,Todo."Organizer To-do No.");
            Window.UPDATE(2,ROUND(AttendeeCounter / TotalAttendees * 10000,1));
            COMMIT
          UNTIL Attendee.NEXT = 0;
          Window.CLOSE;
          CommentLineInserted := TRUE;
        END;
    IF NOT CommentLineInserted THEN
      CreateCommentLines(RMCommentLine,Todo2."No.");*/

    // end;

    //procedure CreateSubTodo(var Attendee: Record "5199"; Todo: Record "5080"): Code[20];
    var
    //Todo2: Record "5080";
    // begin
    /*Todo2.INIT;
    Todo2.TRANSFERFIELDS(Todo,FALSE);

    IF Attendee."Attendance Type" <> Attendee."Attendance Type"::"To-do Organizer" THEN BEGIN
      IF Attendee."Attendee Type" = Attendee."Attendee Type"::Salesperson THEN BEGIN
        Todo2.VALIDATE("Salesperson Code",TransformFromCode20ToCode10(Attendee."Attendee No."));
        Todo2."Organizer To-do No." := Todo."No.";
        Todo2."System To-do Type" := LoadTempAttachment::"1";
      END ELSE BEGIN
        Todo2.VALIDATE("Salesperson Code",Todo."Salesperson Code");
        Todo2.VALIDATE("Team Code",Todo."Team Code");
        Todo2.VALIDATE("Contact No.",Attendee."Attendee No.");
        Todo2."Organizer To-do No." := Todo."No.";
        Todo2."System To-do Type" := LoadTempAttachment::"2";
      END;
      Todo2.INSERT(TRUE)
    END ELSE
      IF Todo."Team Code" <> '' THEN BEGIN
        Todo2."System To-do Type" := Todo2."System To-do Type"::Organizer;
        Todo2.VALIDATE("Salesperson Code",TransformFromCode20ToCode10(Attendee."Attendee No."));

        Todo2.INSERT(TRUE);
      END;
    EXIT(Todo2."No.")*/

    //end;

    //procedure DeleteAttendeeTodo(Attendee: Record "5199");
    var
    //Todo: Record "5080";
    //begin
    /*IF FindAttendeeTodo(Todo,Attendee) THEN
      Todo.DELETE;*/

    //end;

    // procedure FindAttendeeTodo(var Todo : Record "5080";Attendee : Record "5199") : Boolean;
    //begin
    /*Todo.RESET;
    Todo.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
    Todo.SETRANGE("Organizer To-do No.",Attendee."To-do No.");
    IF Attendee."Attendee Type" = Attendee."Attendee Type"::Contact THEN BEGIN
      Todo.SETRANGE("System To-do Type",Todo."System To-do Type"::"Contact Attendee");
      Todo.SETRANGE("Contact No.",Attendee."Attendee No.")
    END ELSE BEGIN
      Todo.SETRANGE("System To-do Type",Todo."System To-do Type"::"Salesperson Attendee");
      Todo.SETRANGE("Salesperson Code",Attendee."Attendee No.");
    END;
    EXIT(Todo.FIND('-'));*/

    //end;

    //local procedure CreateAttendeesFromTodo(var Attendee : Record "5199";Todo : Record "5080";TeamMeetingOrganizer : Code[20]);
    var
        //Cont : Record "5050";
        //Salesperson : Record "13";
        //SegHeader : Record "5076";
        //SegLine : Record "5077";
        //Opp : Record "5092";
        AttendeeLineNo: Integer;
    //begin
    /*IF Todo."Segment No." = '' THEN BEGIN
      IF Todo.Type = Schedule::"1" THEN
        IF Todo."Team Code" = '' THEN BEGIN
          IF Salesperson.GET(Todo."Salesperson Code") THEN
            Attendee.CreateAttendee(
              Attendee,
              Todo."No.",10000,Attendee."Attendance Type"::"To-do Organizer",
              Attendee."Attendee Type"::Salesperson,
              Salesperson.Code,TRUE)
        END ELSE
          Todo.CreateAttendeesFromTeam(
            Attendee,
            TeamMeetingOrganizer);

      IF Attendee.FIND('+') THEN
        AttendeeLineNo := Attendee."Line No." + 10000
      ELSE
        AttendeeLineNo := 10000;

      IF Cont.GET(Todo."Contact No.") THEN
        Attendee.CreateAttendee(
          Attendee,
          Todo."No.",AttendeeLineNo,Attendee."Attendance Type"::Required,
          Attendee."Attendee Type"::Contact,
          Cont."No.",Cont."E-Mail" <> '');
    END ELSE BEGIN
      IF Todo."Team Code" = '' THEN BEGIN
        IF Salesperson.GET(Todo."Salesperson Code") THEN
          Attendee.CreateAttendee(
            Attendee,
            Todo."No.",10000,Attendee."Attendance Type"::"To-do Organizer",
            Attendee."Attendee Type"::Salesperson,
            Salesperson.Code,TRUE);
      END ELSE
        Todo.CreateAttendeesFromTeam(Attendee,TransformFromCode20ToCode10(Todo."Team Meeting Organizer"));

      IF Attendee.FIND('+') THEN
        AttendeeLineNo := Attendee."Line No." + 10000
      ELSE
        AttendeeLineNo := 10000;

      IF Opp.GET(Todo."Opportunity No.") THEN
        Attendee.CreateAttendee(
          Attendee,
          Todo."No.",AttendeeLineNo,Attendee."Attendance Type"::Required,
          Attendee."Attendee Type"::Contact,
          Opp."Contact No.",
          (Cont.GET(Opp."Contact No.") AND
           (Cont."E-Mail" <> '')))
      ELSE
        IF SegHeader.GET(Todo."Segment No.") THEN BEGIN
          SegLine.SETRANGE("Segment No.",Todo."Segment No.");
          SegLine.SETFILTER("Contact No.",'=%1',Todo."Contact No.");
          IF SegLine.FIND('-') THEN
            REPEAT
              Attendee.CreateAttendee(
                Attendee,
                Todo."No.",AttendeeLineNo,Attendee."Attendance Type"::Required,
                Attendee."Attendee Type"::Contact,
                SegLine."Contact No.",
                (Cont.GET(SegLine."Contact No.") AND
                 (Cont."E-Mail" <> '')));
              AttendeeLineNo := AttendeeLineNo + 10000;
            UNTIL SegLine.NEXT = 0;
        END;
    END;*/

    //end;

    //local procedure CreateTodoInteractLanguages(var TodoInteractLanguage : Record "5196";var Attachment : Record "5062";TodoNo : Code[20]);
    var
        // TodoInteractLanguage2 : Record "5196";
        //Attachment2 : Record "5062";
        //MarketingSetup : Record "5079";
        //AttachmentManagement : Codeunit "5052";
        FileName: Text;
    //begin
    /*IF TodoInteractLanguage.FIND('-') THEN
      REPEAT
        TodoInteractLanguage2.INIT;
        TodoInteractLanguage2."To-do No." := TodoNo;
        TodoInteractLanguage2."Language Code" := TodoInteractLanguage."Language Code";
        TodoInteractLanguage2.Description := TodoInteractLanguage.Description;
        IF TodoInteractLanguage."Attachment No." <> 0 THEN BEGIN
          Attachment.GET(TodoInteractLanguage."Attachment No.");
          Attachment2.GET(AttachmentManagement.InsertAttachment(0));
          Attachment2.TRANSFERFIELDS(Attachment,FALSE);
          Attachment.CALCFIELDS("Attachment File");
          Attachment2."Attachment File" := Attachment."Attachment File";
          Attachment2.WizSaveAttachment;
          Attachment2.MODIFY(TRUE);
          MarketingSetup.GET;
          IF MarketingSetup."Attachment Storage Type" = MarketingSetup."Attachment Storage Type"::"Disk File" THEN
            IF Attachment2."No." <> 0 THEN BEGIN
              FileName := Attachment2.ConstDiskFileName;
              IF FileName <> '' THEN
                Attachment.ExportAttachmentToServerFile(FileName);
            END;
          TodoInteractLanguage2."Attachment No." := Attachment2."No.";
        END ELSE
          TodoInteractLanguage2."Attachment No." := 0;
        TodoInteractLanguage2.INSERT;
      UNTIL TodoInteractLanguage.NEXT = 0;*/

    //end;

    //procedure AssignActivityFromToDo(var ToDo : Record "5080");
    var
    //Cont : Record "5050";
    //SalesPurchPerson : Record "13";
    //Team : Record "5083";
    // Campaign : Record "5071";
    //SegHeader : Record "5076";
    //Opp : Record "5092";
    //begin
    /*INIT;

    IF Cont.GET(ToDo.GETFILTER("Contact Company No.")) THEN BEGIN
      VALIDATE("No of appointments",Cont."No.");
      "No of meetings" := Cont."Salesperson Code";
      SETRANGE("Contact Company No.","No of appointments");
    END;

    IF Cont.GET(ToDo.GETFILTER("Contact No.")) THEN BEGIN
      VALIDATE("No of appointments",Cont."No.");
      "No of meetings" := Cont."Salesperson Code";
      SETRANGE("No of appointments","No of appointments");
    END;

    IF SegHeader.GET(ToDo.GETFILTER("Segment No.")) THEN BEGIN
      VALIDATE("Appointments time",SegHeader."No.");
      "Meeting Type" := SegHeader."Campaign No.";
      "No of meetings" := SegHeader."Salesperson Code";
      SETRANGE("Appointments time","Appointments time");
    END;

    IF SalesPurchPerson.GET(ToDo.GETFILTER("Salesperson Code")) THEN BEGIN
      "No of meetings" := SalesPurchPerson.Code;
      SETRANGE("No of meetings","No of meetings");
    END;

    IF Team.GET(ToDo.GETFILTER("Team Code")) THEN BEGIN
      Date := Team.Code;
      SETRANGE(Date,Date);
    END;

    IF Campaign.GET(ToDo.GETFILTER("Campaign No.")) THEN BEGIN
      "Meeting Type" := Campaign."No.";
      "No of meetings" := Campaign."Salesperson Code";
      SETRANGE("Meeting Type","Meeting Type");
    END;

    IF Opp.GET(ToDo.GETFILTER("Opportunity No.")) THEN BEGIN
      VALIDATE("Appointments type",Opp."No.");
      "No of appointments" := Opp."Contact No.";
      "Contact Company No." := Opp."Contact Company No.";
      "Meeting Type" := Opp."Campaign No.";
      "No of meetings" := Opp."Salesperson Code";
      SETRANGE("Appointments type","Appointments type");
    END;

    StartWizard2;*/

    //end;

    //local procedure InsertActivityTodo(Todo2 : Record "5080";ActivityCode : Code[10];var Attendee : Record "5199");
    var
        // ActivityStep : Record "5082";
        TodoDate: Date;
    // begin
    /*TodoDate := Todo2.Date;
    ActivityStep.SETRANGE("Activity Code",ActivityCode);
    IF ActivityStep.FIND('-') THEN BEGIN
      REPEAT
        InsertActivityStepTodo(Todo2,ActivityStep,TodoDate,Attendee);
      UNTIL ActivityStep.NEXT = 0;
    END ELSE
      InsertActivityStepTodo(Todo2,ActivityStep,TodoDate,Attendee);*/

    //end;

    //local procedure InsertActivityStepTodo(Todo2 : Record "5080";ActivityStep : Record "5082";TodoDate : Date;var Attendee2 : Record "5199") TodoNo : Code[20];
    var
    //TodoTemp : Record "5080" temporary;
    //InteractionTemplateSetup : Record "5122";
    //InteractionTemplate : Record "5064";
    //TodoInteractionLanguage : Record "5196" temporary;
    //TempAttachment : Record "5062" temporary;
    //TempAttendee : Record "5199" temporary;
    //RMCommentLine : Record "5061" temporary;
    //begin
    /*TodoTemp.INIT;
    TodoTemp := Todo2;
    TodoTemp.INSERT;
    IF NOT ActivityStep.ISEMPTY THEN BEGIN
      TodoTemp.Type := ActivityStep.Type;
      TodoTemp.Priority := ActivityStep.Priority;
      TodoTemp.Description := ActivityStep.Description;
      TodoTemp.Date := CALCDATE(ActivityStep."Date Formula",TodoDate);
    END;

    IF TodoTemp.Type = Schedule::"1" THEN BEGIN
      IF NOT Attendee2.ISEMPTY THEN BEGIN
        Attendee2.SETRANGE("Attendance Type",Attendee2."Attendance Type"::"To-do Organizer");
        Attendee2.FIND('-')
      END;
      TempAttendee.DELETEALL;
      TodoTemp.VALIDATE("All Day Event",TRUE);

      InteractionTemplateSetup.GET;
      IF (InteractionTemplateSetup."Meeting Invitation" <> '') AND
         InteractionTemplate.GET(InteractionTemplateSetup."Meeting Invitation")
      THEN
        UpdateInteractionTemplate(
          TodoTemp,TodoInteractionLanguage,TempAttachment,InteractionTemplate.Code,TRUE);

      CreateAttendeesFromTodo(TempAttendee,TodoTemp,Attendee2."Attendee No.");

      TodoTemp.VALIDATE("Contact No.",'');

      TodoNo := InsertTodoAndRelatedData(
          TodoTemp,TodoInteractionLanguage,
          TempAttachment,TempAttendee,RMCommentLine);
    END ELSE BEGIN
      TempAttendee.DELETEALL;
      CreateAttendeesFromTodo(TempAttendee,TodoTemp,'');

      InsertTodoAndRelatedData(
        TodoTemp,TodoInteractionLanguage,
        TempAttachment,TempAttendee,RMCommentLine);
    END;
    TodoTemp.DELETE;*/

    //end;

    procedure CancelOpenTodos(OpportunityNo: Code[20]);
    var
    // OldTodo : Record "5080";
    //OldTodo2 : Record "5080";
    begin
        /*IF OpportunityNo = '' THEN
          EXIT;
        
        OldTodo.RESET;
        OldTodo.SETCURRENTKEY("Opportunity No.");
        OldTodo.SETRANGE("Opportunity No.",OpportunityNo);
        OldTodo.SETRANGE(Closed,FALSE);
        OldTodo.SETRANGE(Canceled,FALSE);
        
        IF OldTodo.FIND('-') THEN
          REPEAT
            OldTodo2.GET(OldTodo."No.");
            OldTodo2.Recurring := FALSE;
            OldTodo2.VALIDATE(Canceled,TRUE);
            OldTodo2.MODIFY;
          UNTIL OldTodo.NEXT = 0;*/

    end;

    //local procedure CreateCommentLines(var RMCommentLineTmp : Record "5061";TodoNo : Code[20]);
    //begin
    /*IF RMCommentLineTmp.FIND('-') THEN
      REPEAT
        RMCommentLine.INIT;
        RMCommentLine := RMCommentLineTmp;
        RMCommentLine."No." := TodoNo;
        RMCommentLine.INSERT;
      UNTIL RMCommentLineTmp.NEXT = 0;*/

    //end;

    procedure SetDuration(EndingDate: Date; EndingTime: Time);
    begin
        /*IF (EndingDate < 01011900D) OR (EndingDate > 31122999D) THEN
          ERROR(Text006,01011900D,31122999D);
        IF NOT "All Day Event" AND (Schedule = Schedule::"1") THEN
          Duration := CREATEDATETIME(EndingDate,EndingTime) - CREATEDATETIME(AssignActivityFromToDo,RemoveAttachment)
        ELSE
          Duration := CREATEDATETIME(EndingDate + 1,0T) - CREATEDATETIME(AssignActivityFromToDo,0T);
        
        VALIDATE(Duration);*/

    end;

    procedure GetEndDateTime();
    begin
        /*IF (Schedule <> Schedule::"1") OR "All Day Event" THEN
          IF RemoveAttachment <> 0T THEN
            TempEndDateTime := CREATEDATETIME(AssignActivityFromToDo - 1,RemoveAttachment) + Duration
          ELSE BEGIN
            TempEndDateTime := CREATEDATETIME(AssignActivityFromToDo,0T) + Duration;
            IF "All Day Event" THEN
              TempEndDateTime := CREATEDATETIME(DT2DATE(TempEndDateTime - 1000),0T);
          END
        ELSE
          TempEndDateTime := CREATEDATETIME(AssignActivityFromToDo,RemoveAttachment) + Duration;
        
        "Ending Date" := DT2DATE(TempEndDateTime);
        IF "All Day Event" THEN
          "Ending Time" := 0T
        ELSE
          "Ending Time" := DT2TIME(TempEndDateTime);*/

    end;

    local procedure UpdateAttendeeTodos(OldTodoNo: Code[20]);
    var
    // Todo2 : Record "5080";
    // TodoBuffer : Record "5080" temporary;
    begin
        /*Todo2.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
        Todo2.SETRANGE("Organizer To-do No.",OldTodoNo);
        IF Date = '' THEN
          Todo2.SETFILTER(
            "System To-do Type",
            '%1|%2',
            Todo2."System To-do Type"::"Salesperson Attendee",
            Todo2."System To-do Type"::"Contact Attendee")
        ELSE
          Todo2.SETFILTER("System To-do Type",'<>%1',Todo2."System To-do Type"::Team);
        IF Todo2.FIND('-') THEN
          REPEAT
            TodoBuffer.INIT;
            TodoBuffer.TRANSFERFIELDS(Todo2,FALSE);
            TodoBuffer.INSERT;
            Todo2.TRANSFERFIELDS(Rec,FALSE);
            Todo2."System To-do Type" := TodoBuffer."System To-do Type";
            IF Todo2."System To-do Type" = Todo2."System To-do Type"::"Contact Attendee" THEN
              Todo2.VALIDATE("Contact No.",TodoBuffer."Contact No.")
            ELSE
              Todo2."Salesperson Code" := TodoBuffer."Salesperson Code";
            IF Todo2."No." <> OldTodoNo THEN
              Todo2.MODIFY(TRUE);
            TodoBuffer.DELETE;
          UNTIL Todo2.NEXT = 0*/

    end;

    //local procedure UpdateInteractionTemplate(var Todo : Record "5080";var TodoInteractionLanguage : Record "5196";var Attachment : Record "5062";InteractTmplCode : Code[10];AttachmentTemporary : Boolean);
    var
    //InteractTmpl : Record "5064";
    //InteractTemplLanguage : Record "5103";
    //Attachment2 : Record "5062";
    //AttachmentManagement : Codeunit "5052";
    //begin
    /*Todo.MODIFY;
    TodoInteractionLanguage.SETRANGE("To-do No.",Todo."No.");

    IF AttachmentTemporary THEN
      TodoInteractionLanguage.DELETEALL
    ELSE
      TodoInteractionLanguage.DELETEALL(TRUE);

    Todo."Interaction Template Code" := InteractTmplCode;

    IF InteractTmpl.GET(Todo."Interaction Template Code") THEN BEGIN
      Todo."Language Code" := InteractTmpl."Language Code (Default)";
      Todo.Subject := InteractTmpl.Description;
      Todo."Unit Cost (LCY)" := InteractTmpl."Unit Cost (LCY)";
      Todo."Unit Duration (Min.)" := InteractTmpl."Unit Duration (Min.)";
      IF Todo."Campaign No." = '' THEN
        Todo."Campaign No." := InteractTmpl."Campaign No.";

      IF AttachmentTemporary THEN
        Attachment.DELETEALL;

      InteractTemplLanguage.RESET;
      InteractTemplLanguage.SETRANGE("Interaction Template Code",Todo."Interaction Template Code");
      IF InteractTemplLanguage.FIND('-') THEN
        REPEAT
          TodoInteractionLanguage.INIT;
          TodoInteractionLanguage."To-do No." := Todo."No.";
          TodoInteractionLanguage."Language Code" := InteractTemplLanguage."Language Code";
          TodoInteractionLanguage.Description := InteractTemplLanguage.Description;
          IF Attachment2.GET(InteractTemplLanguage."Attachment No.") THEN BEGIN
            IF AttachmentTemporary THEN BEGIN
              Attachment.INIT;
              IF Attachment2."Storage Type" = Attachment2."Storage Type"::Embedded THEN
                Attachment2.CALCFIELDS("Attachment File");
              Attachment.TRANSFERFIELDS(Attachment2);
              Attachment.INSERT;
              TodoInteractionLanguage."Attachment No." := Attachment."No.";
            END ELSE
              TodoInteractionLanguage."Attachment No." :=
                AttachmentManagement.InsertAttachment(InteractTemplLanguage."Attachment No.");
          END;
          TodoInteractionLanguage.INSERT;
        UNTIL InteractTemplLanguage.NEXT = 0
      ELSE
        Todo."Attachment No." := 0;
    END ELSE BEGIN
      Todo."Language Code" := '';
      Todo.Subject := '';
      Todo."Unit Cost (LCY)" := 0;
      Todo."Unit Duration (Min.)" := 0;
      Todo."Attachment No." := 0;
    END;

    IF TodoInteractionLanguage.GET(Todo."No.",Todo."Language Code") THEN
      Todo."Attachment No." := TodoInteractionLanguage."Attachment No.";

    Todo.MODIFY;*/

    //end;

    //procedure SendMAPIInvitations(Todo : Record "5080";FromWizard : Boolean);
    var
        //Attendee : Record "5199";
        NoToSend: Integer;
        NoNotSent: Integer;
        Selected: Integer;
        Options: Text[1024];
    //begin
    /*IF Todo."System To-do Type" <> Todo."System To-do Type"::Organizer THEN
      Todo.GetMeetingOrganizerTodo(Todo);
    IF Todo."Attachment No." = 0 THEN BEGIN
      Attendee.SETRANGE("To-do No.",Todo."Organizer To-do No.");
      Attendee.SETRANGE("Send Invitation",TRUE);
      Attendee.SETRANGE("Attendee Type",Attendee."Attendee Type"::Contact);
      IF NOT Attendee.ISEMPTY THEN BEGIN
        Attendee.SETCURRENTKEY("To-do No.","Attendance Type");
        Attendee.SETRANGE("Send Invitation");
        Attendee.SETRANGE("Attendee Type");
        Attendee.SETRANGE("Attendance Type",Attendee."Attendance Type"::"To-do Organizer");
        IF NOT Attendee.ISEMPTY THEN
          ERROR(Text067,Todo.TABLECAPTION,Attendee.TABLECAPTION)
      END;
      Attendee.RESET;
    END;

    Attendee.SETRANGE("To-do No.",Todo."Organizer To-do No.");
    Attendee.SETFILTER("Attendance Type",'<>%1',Attendee."Attendance Type"::"To-do Organizer");
    Attendee.SETRANGE("Send Invitation",TRUE);

    IF NOT FromWizard THEN BEGIN
      NoToSend := Attendee.COUNT;
      Attendee.SETRANGE("Invitation Sent",FALSE);
      NoNotSent := Attendee.COUNT;
      IF NoToSend = 0 THEN
        ERROR(Text018,Attendee.FIELDCAPTION("Send Invitation"));
      IF (NoToSend > NoNotSent) AND (NoNotSent <> 0) THEN BEGIN
        Options :=
          STRSUBSTNO(
            Text019,Attendee.FIELDCAPTION("Send Invitation")) + ',' +
          Text020 + ',' +
          Text021;
        Selected := STRMENU(Options,1);
        IF Selected IN [0,3] THEN
          ERROR('');
      END;
      IF NoNotSent = 0 THEN BEGIN
        IF NOT CONFIRM(
             STRSUBSTNO(
               Text022,Attendee.FIELDCAPTION("Send Invitation")),FALSE)
        THEN
          ERROR('');
      END;
      IF NoToSend = NoNotSent THEN BEGIN
        IF NOT CONFIRM(STRSUBSTNO(Text019,Attendee.FIELDCAPTION("Send Invitation")),FALSE) THEN
          ERROR('');
      END;

      Attendee.RESET;
      Attendee.SETRANGE("To-do No.",Todo."Organizer To-do No.");
      Attendee.SETRANGE("Send Invitation",TRUE);
      IF Selected = 2 THEN
        Attendee.SETRANGE("Invitation Sent",FALSE);
    END;

    IF Attendee.FINDFIRST THEN
      ProcessAttendeeAppointment(Todo,Attendee);*/

    //end;

    procedure CreateAttachment(PageNotEditable: Boolean);
    var
    //TodoInteractionLanguage : Record "5196";
    begin
        /*IF "Interaction Template Code" = '' THEN
          EXIT;
        IF NOT TodoInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN BEGIN
          TodoInteractionLanguage.INIT;
          TodoInteractionLanguage."To-do No." := "Organizer To-do No.";
          TodoInteractionLanguage."Language Code" := "Language Code";
          TodoInteractionLanguage.INSERT(TRUE);
        END;
        IF TodoInteractionLanguage.CreateAttachment(PageNotEditable) THEN BEGIN
          GetMeetingOrganizerTodo := TodoInteractionLanguage."Attachment No.";
          MODIFY(TRUE);
        END;*/

    end;

    procedure OpenAttachment(PageNotEditable: Boolean);
    var
    //TodoInteractionLanguage : Record "5196";
    begin
        /*IF "Interaction Template Code" = '' THEN
          EXIT;
        IF TodoInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN
          IF TodoInteractionLanguage."Attachment No." <> 0 THEN
            TodoInteractionLanguage.OpenAttachment(PageNotEditable);
        MODIFY(TRUE);*/

    end;

    procedure ImportAttachment();
    var
    // TodoInteractionLanguage : Record "5196";
    begin
        /*IF "Interaction Template Code" = '' THEN
          EXIT;
        
        IF NOT TodoInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN BEGIN
          TodoInteractionLanguage.INIT;
          TodoInteractionLanguage."To-do No." := "Organizer To-do No.";
          TodoInteractionLanguage."Language Code" := "Language Code";
          TodoInteractionLanguage.INSERT(TRUE);
        END;
        TodoInteractionLanguage.ImportAttachment;
        GetMeetingOrganizerTodo := TodoInteractionLanguage."Attachment No.";
        MODIFY(TRUE);*/

    end;

    procedure ExportAttachment();
    var
    // TodoInteractionLanguage : Record "5196";
    begin
        /*IF "Interaction Template Code" = '' THEN
          EXIT;
        
        IF TodoInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN
          IF TodoInteractionLanguage."Attachment No." <> 0 THEN
            TodoInteractionLanguage.ExportAttachment;*/

    end;

    procedure RemoveAttachment(Prompt: Boolean);
    var
    //TodoInteractionLanguage : Record "5196";
    begin
        /*IF "Interaction Template Code" = '' THEN
          EXIT;
        
        IF TodoInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN
          IF TodoInteractionLanguage."Attachment No." <> 0 THEN
            IF TodoInteractionLanguage.RemoveAttachment(Prompt) THEN BEGIN
              GetMeetingOrganizerTodo := 0;
              MODIFY(TRUE);
            END;
        MODIFY(TRUE);*/

    end;

    //local procedure LogTodoInteraction(var Todo : Record "5080";var Todo2 : Record "5080";Deliver : Boolean);
    var
    //TempSegLine : Record "5077" temporary;
    //Cont : Record "5050";
    //Salesperson : Record "13";
    //Campaign : Record "5071";
    // Attachment : Record "5062";
    //TempAttachment : Record "5062" temporary;
    //TempInterLogEntryCommentLine : Record "5123" temporary;
    //SegManagement : Codeunit "5051";
    //begin
    /*IF Attachment.GET(Todo."Attachment No.") THEN BEGIN
      TempAttachment.DELETEALL;
      TempAttachment.INIT;
      TempAttachment.WizEmbeddAttachment(Attachment);
      TempAttachment.INSERT;
    END;*/

    /*TempSegLine.DELETEALL;
    TempSegLine.INIT;
    TempSegLine."To-do No." := Todo."Organizer To-do No.";
    TempSegLine.SETRANGE("To-do No.",TempSegLine."To-do No.");
    IF Cont.GET(Todo2."Contact No.") THEN
      TempSegLine.VALIDATE("Contact No.",Todo2."Contact No.");
    IF Salesperson.GET(Todo."Salesperson Code") THEN
      TempSegLine."Salesperson Code" := Salesperson.Code;
    IF Campaign.GET(Todo."Campaign No.") THEN
      TempSegLine."Campaign No." := Campaign."No.";
    TempSegLine."Interaction Template Code" := Todo."Interaction Template Code";
    TempSegLine."Attachment No." := Todo."Attachment No.";
    TempSegLine."Language Code" := Todo."Language Code";
    TempSegLine.Subject := Todo.Description;
    TempSegLine.Description := Todo.Description;
    TempSegLine."Correspondence Type" := TempSegLine."Correspondence Type"::Email;
    TempSegLine."Cost (LCY)" := Todo."Unit Cost (LCY)";
    TempSegLine."Duration (Min.)" := Todo."Unit Duration (Min.)";
    TempSegLine."Opportunity No." := Todo."Opportunity No.";
    TempSegLine.VALIDATE(Date,WORKDATE);

    TempSegLine.INSERT;
    SegManagement.LogInteraction(TempSegLine,TempAttachment,TempInterLogEntryCommentLine,Deliver,FALSE);*/

    //end;

    //procedure CreateAttendeesFromTeam(var Attendee : Record "5199";TeamMeetingOrganizer : Code[20]);
    var
    // TeamSalesperson : Record "5084";
    //AttendeeLineNo : Integer;
    //begin
    /*IF TeamMeetingOrganizer = '' THEN
      EXIT;
    Attendee.CreateAttendee(
      Attendee,
      "No.",10000,Attendee."Attendance Type"::"To-do Organizer",
      Attendee."Attendee Type"::Salesperson,
      TeamMeetingOrganizer,
      TRUE);

    TeamSalesperson.SETRANGE("Team Code",Date);
    IF TeamSalesperson.FIND('-') THEN BEGIN
      AttendeeLineNo := 20000;
      REPEAT
        IF TeamSalesperson."Salesperson Code" <> TeamMeetingOrganizer THEN
          Attendee.CreateAttendee(
            Attendee,
            "No.",AttendeeLineNo,Attendee."Attendance Type"::Required,
            Attendee."Attendee Type"::Salesperson,
            TeamSalesperson."Salesperson Code",
            FALSE);
        AttendeeLineNo := AttendeeLineNo + 10000;
      UNTIL TeamSalesperson.NEXT = 0;
    END;*/

    //end;

    local procedure ChangeTeam();
    var
    //  Todo : Record "5080";
    // TeamSalesperson : Record "5084";
    //TeamSalespersonOld : Record "5084";
    //TempAttendee : Record "5199" temporary;
    // Attendee : Record "5199";
    // Salesperson : Record "13";
    // AttendeeLineNo : Integer;
    //SendInvitation : Boolean;
    //TeamCode : Code[10];
    begin
        /*MODIFY;
        TeamSalespersonOld.SETRANGE("Team Code",xRec.Date);
        TeamSalesperson.SETRANGE("Team Code",Date);
        IF TeamSalesperson.FIND('-') THEN
          REPEAT
            TeamSalesperson.MARK(TRUE)
          UNTIL TeamSalesperson.NEXT = 0;
        
        IF Schedule = Schedule::"1" THEN BEGIN
          Attendee.SETCURRENTKEY("To-do No.","Attendee Type","Attendee No.");
          Attendee.SETRANGE("To-do No.","Organizer To-do No.");
          Attendee.SETRANGE("Attendee Type",Attendee."Attendee Type"::Salesperson);
          IF Attendee.FIND('-') THEN
            REPEAT
              TeamSalesperson.SETRANGE("Salesperson Code",Attendee."Attendee No.");
              IF TeamSalesperson.FIND('-') THEN
                TeamSalesperson.MARK(FALSE)
              ELSE
                IF Attendee."Attendance Type" <> Attendee."Attendance Type"::"To-do Organizer" THEN BEGIN
                  TeamSalespersonOld.SETRANGE("Salesperson Code",Attendee."Attendee No.");
                  IF TeamSalespersonOld.FINDFIRST THEN BEGIN
                    Attendee.MARK(TRUE);
                    DeleteAttendeeTodo(Attendee)
                  END
                END
            UNTIL Attendee.NEXT = 0;
          Attendee.MARKEDONLY(TRUE);
          Attendee.DELETEALL
        END ELSE BEGIN
          Todo.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
          Todo.SETRANGE("Organizer To-do No.","Organizer To-do No.");
          Todo.SETFILTER("System To-do Type",'%1|%2',
            Todo."System To-do Type"::Organizer,
            Todo."System To-do Type"::"Salesperson Attendee");
          IF Todo.FIND('-') THEN
            REPEAT
              TeamSalesperson.SETRANGE("Salesperson Code",Todo."Salesperson Code");
              IF TeamSalesperson.FIND('-') THEN
                TeamSalesperson.MARK(FALSE)
              ELSE
                Todo.DELETE(TRUE)
            UNTIL Todo.NEXT = 0
        END;
        
        TeamCode := Date;
        GET("No.");
        Date := TeamCode;
        
        TeamSalesperson.MARKEDONLY(TRUE);
        TeamSalesperson.SETRANGE("Salesperson Code");
        IF TeamSalesperson.FIND('-') THEN BEGIN
          IF Schedule = Schedule::"1" THEN
            REPEAT
              Attendee.RESET;
              Attendee.SETRANGE("To-do No.","Organizer To-do No.");
              IF Attendee.FIND('+') THEN
                AttendeeLineNo := Attendee."Line No." + 10000
              ELSE
                AttendeeLineNo := 10000;
              IF Salesperson.GET(TeamSalesperson."Salesperson Code") THEN
                IF Salesperson."E-Mail" <> '' THEN
                  SendInvitation := TRUE
                ELSE
                  SendInvitation := FALSE;
              Attendee.CreateAttendee(
                Attendee,
                "Organizer To-do No.",AttendeeLineNo,
                Attendee."Attendance Type"::Required,
                Attendee."Attendee Type"::Salesperson,
                TeamSalesperson."Salesperson Code",SendInvitation);
              //CreateSubTodo(Attendee,Rec)
            UNTIL TeamSalesperson.NEXT = 0
          ELSE
            REPEAT
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",10000,
                TempAttendee."Attendance Type"::"To-do Organizer",
                TempAttendee."Attendee Type"::Salesperson,
                TeamSalesperson."Salesperson Code",
                TRUE);
             // CreateSubTodo(TempAttendee,Rec);
              TempAttendee.DELETEALL
            UNTIL TeamSalesperson.NEXT = 0
        END;
        MODIFY(TRUE)*/

    end;

    local procedure ReassignTeamTodoToSalesperson();
    var
    //Todo : Record "5080";
    //Attendee : Record "5199";
    //AttendeeLineNo : Integer;
    //SalespersonCode : Code[10];
    begin
        /*MODIFY;
        IF Schedule = Schedule::"1" THEN BEGIN
          Todo.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
          Todo.SETRANGE("Organizer To-do No.","No.");
          Todo.SETRANGE("Salesperson Code","No of meetings");
          IF Todo.FINDFIRST THEN BEGIN
            Attendee.SETCURRENTKEY("To-do No.","Attendee Type","Attendee No.");
            Attendee.SETRANGE("To-do No.","No.");
            Attendee.SETRANGE("Attendee Type",Attendee."Attendee Type"::Salesperson);
            Attendee.SETRANGE("Attendee No.","No of meetings");
            IF Attendee.FINDFIRST THEN
              IF Attendee."Attendance Type" = Attendee."Attendance Type"::"To-do Organizer" THEN BEGIN
                Attendee.DELETE;
                Todo.DELETE;
              END ELSE
                Attendee.DELETE(TRUE)
          END;
        
          SalespersonCode := "No of meetings";
          GET("No.");
          "No of meetings" := SalespersonCode;
        
          Todo.SETRANGE("Salesperson Code");
          Todo.SETRANGE("System To-do Type",LoadTempAttachment::"0");
          IF Todo.FINDFIRST THEN BEGIN
            Attendee.RESET;
            Attendee.SETCURRENTKEY("To-do No.","Attendee Type","Attendee No.");
            Attendee.SETRANGE("To-do No.","No.");
            Attendee.SETRANGE("Attendee Type",Attendee."Attendee Type"::Salesperson);
            Attendee.SETRANGE("Attendee No.",Todo."Salesperson Code");
            IF Attendee.FINDFIRST THEN BEGIN
              Attendee."Attendance Type" := Attendee."Attendance Type"::Required;
              Attendee.MODIFY
            END;
            Todo."System To-do Type" := Todo."System To-do Type"::"Salesperson Attendee";
            Todo.MODIFY(TRUE)
          END;
        
          Attendee.RESET;
          Attendee.SETRANGE("To-do No.","No.");
          IF Attendee.FINDLAST THEN
            AttendeeLineNo := Attendee."Line No." + 10000
          ELSE
            AttendeeLineNo := 10000;
          Attendee.CreateAttendee(
            Attendee,"No.",AttendeeLineNo,
            Attendee."Attendance Type"::"To-do Organizer",
            Attendee."Attendee Type"::Salesperson,
            "No of meetings",TRUE);
          ArrangeOrganizerAttendee;
        END ELSE BEGIN
          Todo.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
          Todo.SETRANGE("Organizer To-do No.","No.");
          Todo.SETRANGE("System To-do Type",LoadTempAttachment::"0");
          IF Todo.FINDFIRST THEN
            Todo.DELETEALL(TRUE);
        
          IF "No of appointments" <> '' THEN BEGIN
            Todo.SETRANGE("System To-do Type",LoadTempAttachment::"2");
            IF Todo.FINDFIRST THEN BEGIN
              Todo."Salesperson Code" := "No of meetings";
              Todo.MODIFY(TRUE)
            END
          END
        END;
        
        LoadTempAttachment := LoadTempAttachment::"0";
        Date := '';
        MODIFY(TRUE);*/

    end;

    local procedure ReassignSalespersonTodoToTeam();
    var
    //TeamSalesperson : Record "5084";
    //Attendee : Record "5199";
    //TempAttendee : Record "5199" temporary;
    //Todo : Record "5080";
    //AttendeeLineNo : Integer;
    //SendInvitation : Boolean;
    //SalespersonCode : Code[10];
    //TodoNo : Code[20];
    begin
        /*MODIFY;
        SalespersonCode := "No of meetings";
        "No of meetings" := '';
        LoadTempAttachment := LoadTempAttachment::"3";
        MODIFY;
        
        Todo.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
        Todo.SETRANGE("Organizer To-do No.","No.");
        
        IF Schedule = Schedule::"1" THEN BEGIN
          Attendee.SETRANGE("To-do No.","No.");
          Attendee.SETRANGE("Attendance Type",Attendee."Attendance Type"::"To-do Organizer");
          IF Attendee.FINDFIRST THEN BEGIN
            Attendee."Attendance Type" := Attendee."Attendance Type"::Required;
            //TodoNo := CreateSubTodo(Attendee,Rec);
            Attendee."Attendance Type" := Attendee."Attendance Type"::"To-do Organizer";
            Attendee.MODIFY;
            IF Todo.GET(TodoNo) THEN BEGIN
              Todo."System To-do Type" := Todo."System To-do Type"::Organizer;
              Todo.MODIFY;
            END
          END;
        
          Todo.SETFILTER("System To-do Type",'<>%1',Todo."System To-do Type"::"Contact Attendee");
          TeamSalesperson.SETRANGE("Team Code",Date);
          IF TeamSalesperson.FIND('-') THEN
            REPEAT
              Todo.SETRANGE("Salesperson Code",TeamSalesperson."Salesperson Code");
              IF Todo.FINDFIRST THEN BEGIN
                IF (Todo."System To-do Type" = Todo."System To-do Type"::Organizer) AND
                   (Todo."Salesperson Code" <> SalespersonCode)
                THEN BEGIN
                  Todo."System To-do Type" := Todo."System To-do Type"::"Salesperson Attendee";
                  MODIFY(TRUE)
                END
              END ELSE BEGIN
                Attendee.RESET;
                Attendee.SETRANGE("To-do No.","No.");
                IF Attendee.FINDLAST THEN
                  AttendeeLineNo := Attendee."Line No." + 10000
                ELSE
                  AttendeeLineNo := 10000;
                IF Salesperson.GET(TeamSalesperson."Salesperson Code") THEN
                  IF Salesperson."E-Mail" <> '' THEN
                    SendInvitation := TRUE
                  ELSE
                    SendInvitation := FALSE;
                Attendee.CreateAttendee(
                  Attendee,"No.",AttendeeLineNo,
                  Attendee."Attendance Type"::Required,
                  Attendee."Attendee Type"::Salesperson,
                  TeamSalesperson."Salesperson Code",
                  SendInvitation);
                //CreateSubTodo(Attendee,Rec)
              END
            UNTIL TeamSalesperson.NEXT = 0
        END ELSE BEGIN
          TeamSalesperson.SETRANGE("Team Code",Date);
          IF TeamSalesperson.FIND('-') THEN
            REPEAT
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",10000,
                TempAttendee."Attendance Type"::"To-do Organizer",
                TempAttendee."Attendee Type"::Salesperson,
                TeamSalesperson."Salesperson Code",
                TRUE);
             // CreateSubTodo(TempAttendee,Rec);
              TempAttendee.DELETEALL
            UNTIL TeamSalesperson.NEXT = 0;
        END;
        
        MODIFY(TRUE)*/

    end;

    //  procedure GetMeetingOrganizerTodo(var Todo : Record "5080");
    //begin
    /*IF Schedule = Schedule::"1" THEN
      IF Date <> '' THEN BEGIN
        Todo.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
        Todo.SETRANGE("Organizer To-do No.","Organizer To-do No.");
        Todo.SETRANGE("System To-do Type",LoadTempAttachment::"0");
        Todo.FIND('-')
      END ELSE
        Todo.GET("Organizer To-do No.")*/

    //end;

    procedure ArrangeOrganizerAttendee();
    var
        //Attendee : Record "5199";
        FirstLineNo: Integer;
        LastLineNo: Integer;
        OrganizerLineNo: Integer;
    begin
        /*Attendee.SETRANGE("To-do No.","No.");
        IF NOT Attendee.FINDFIRST THEN
          EXIT;
        FirstLineNo := Attendee."Line No.";
        Attendee.FINDLAST;
        LastLineNo := Attendee."Line No.";
        
        Attendee.SETCURRENTKEY("To-do No.","Attendance Type");
        Attendee.SETRANGE("Attendance Type",Attendee."Attendance Type"::"To-do Organizer");
        Attendee.FINDFIRST;
        OrganizerLineNo := Attendee."Line No.";
        
        IF FirstLineNo <> OrganizerLineNo THEN BEGIN
          Attendee.RENAME("No.",LastLineNo + 1);
          Attendee.GET("No.",FirstLineNo);
          Attendee.RENAME("No.",OrganizerLineNo);
          Attendee.GET("No.",LastLineNo + 1);
          Attendee.RENAME("No.",FirstLineNo)
        END*/

    end;

    local procedure StartWizard();
    begin
        /*"Wizard Step" := "Wizard Step"::"1";
        
        "Wizard Contact Name" := GetContactName;
        IF Campaign.GET("Meeting Type") THEN
          "Wizard Campaign Description" := Campaign.Description;
        IF Opp.GET("Appointments type") THEN
          "Wizard Opportunity Description" := Opp.Description;
        IF SegHeader.GET(GETFILTER("Appointments time")) THEN
          "Segment Description" := SegHeader.Description;
        IF Team.GET(GETFILTER(Date)) THEN
          "Team To-do" := TRUE;
        
        Duration := 1440 * 1000 * 60;
        AssignActivityFromToDo := TODAY;
        GetEndDateTime;
        
        INSERT;
        IF PAGE.RUNMODAL(PAGE::"Create To-do",Rec) = ACTION::OK THEN;*/

    end;

    procedure CheckStatus();
    begin
        /*IF AssignActivityFromToDo = 0D THEN
          ErrorMessage(FIELDCAPTION(AssignActivityFromToDo));
        
        IF Description = '' THEN
          ErrorMessage(FIELDCAPTION(Description));
        
        IF "Team To-do" AND (Date = '') THEN
          ErrorMessage(FIELDCAPTION(Date));
        
        IF NOT "Team To-do" AND ("No of meetings" = '') THEN
          ErrorMessage(FIELDCAPTION("No of meetings"));
        
        IF Schedule = Schedule::"1" THEN BEGIN
          IF NOT "All Day Event" THEN BEGIN
            IF RemoveAttachment = 0T THEN
              ErrorMessage(FIELDCAPTION(RemoveAttachment));
            IF Duration = 0 THEN
              ErrorMessage(FIELDCAPTION(Duration));
          END;
        
          IF ("Interaction Template Code" = '') AND "Send on finish" THEN
            ErrorMessage(FIELDCAPTION("Interaction Template Code"));
        
          TempAttendee.RESET;
          TempAttendee.SETRANGE("Attendance Type",TempAttendee."Attendance Type"::"To-do Organizer");
          IF TempAttendee.ISEMPTY THEN BEGIN
            TempAttendee.RESET;
            ERROR(Text065);
          END;
        
          IF TempAttendee.FIND('-') THEN
            SalesPurchPerson.GET(TempAttendee."Attendee No.");
          TempAttendee.RESET;
          IF (GetMeetingOrganizerTodo = 0) AND "Send on finish" THEN BEGIN
            TempAttendee.SETRANGE("Send Invitation",TRUE);
            TempAttendee.SETRANGE("Attendee Type",TempAttendee."Attendee Type"::Contact);
            IF NOT TempAttendee.ISEMPTY THEN BEGIN
              TempAttendee.RESET;
              ERROR(Text067,TABLECAPTION,TempAttendee.TABLECAPTION);
            END;
            TempAttendee.RESET;
          END;
          TempAttendee.RESET;
          IF "Send on finish" THEN BEGIN
            TempAttendee.SETRANGE("Send Invitation",TRUE);
            IF TempAttendee.ISEMPTY THEN BEGIN
              TempAttendee.RESET;
              ERROR(Text068,TempAttendee.FIELDCAPTION("Send Invitation"));
            END;
            TempAttendee.RESET;
          END;
        END;
        
        IF (Location = '') AND "Send on finish" THEN
          ErrorMessage(FIELDCAPTION(Location));*/

    end;

    procedure FinishWizard(SendExchangeAppointment: Boolean);
    var
    //SegLine : Record "5077";
    //SendOnFinish : Boolean;
    begin
        /*CreateExchangeAppointment := SendExchangeAppointment;
        IF OpenAttachment THEN BEGIN
          TESTFIELD(FindAttendeeTodo);
          TESTFIELD(ImportAttachment);
        END;
        IF Schedule = Schedule::"1" THEN BEGIN
          IF NOT "Team To-do" THEN BEGIN
            TempAttendee.SETRANGE("Attendance Type",TempAttendee."Attendance Type"::"To-do Organizer");
            TempAttendee.FIND('-');
            VALIDATE("No of meetings",TransformFromCode20ToCode10(TempAttendee."Attendee No."));
            TempAttendee.RESET;
          END;
          VALIDATE("No of appointments",'');
        END ELSE BEGIN
          IF Cont.GET("No of appointments") THEN
            TempAttendee.CreateAttendee(
              TempAttendee,
              "No.",10000,TempAttendee."Attendance Type"::Required,
              TempAttendee."Attendee Type"::Contact,
              Cont."No.",Cont."E-Mail" <> '');
          IF SegHeader.GET("Appointments time") THEN BEGIN
            SegLine.SETRANGE("Segment No.","Appointments time");
            SegLine.SETFILTER("Contact No.",'<>%1','');
            IF SegLine.FIND('-') THEN
              REPEAT
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",SegLine."Line No.",TempAttendee."Attendance Type"::Required,
                  TempAttendee."Attendee Type"::Contact,
                  SegLine."Contact No.",
                  (Cont.GET(SegLine."Contact No.") AND
                   (Cont."E-Mail" <> '')));
              UNTIL SegLine.NEXT = 0;
          END;
        END;
        
        SendOnFinish := "Send on finish";
        "Wizard Step" := "Wizard Step"::"0";
        "Team To-do" := FALSE;
        "Send on finish" := FALSE;
        "Segment Description" := '';
        "Team Meeting Organizer" := '';
        "Activity Code" := '';
        "Wizard Contact Name" := '';
        "Wizard Campaign Description" := '';
        "Wizard Opportunity Description" := '';
        MODIFY;
        //InsertTodo(Rec,RMCommentLineTmp,TempAttendee,TodoInteractionLanguage,TempAttachment,'',SendOnFinish);
        DELETE;*/

    end;

    local procedure GetContactName(): Text[50];
    begin
        /*IF Cont.GET("No of appointments") THEN
          EXIT(Cont.Name);
        IF Cont.GET("Contact Company No.") THEN
          EXIT(Cont.Name);*/

    end;

    local procedure ErrorMessage(FieldName: Text[1024]);
    begin
        /*ERROR(Text043,FieldName);*/

    end;

    procedure AssignDefaultAttendeeInfo();
    var
    //InteractionTemplate : Record "5064";
    // InteractionTemplateSetup : Record "5122";
    //SegLine : Record "5077";
    //TeamSalesperson : Record "5084";
    //AttendeeLineNo : Integer;
    begin
        /*IF TempAttendee.FIND('+') THEN
          AttendeeLineNo := TempAttendee."Line No." + 10000
        ELSE
          AttendeeLineNo := 10000;
        CASE TRUE OF
          (GETFILTER("No of appointments") <> '') AND (GETFILTER("No of meetings") <> ''):
            BEGIN
              IF SalesPurchPerson.GET(GETFILTER("No of meetings")) THEN BEGIN
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::"To-do Organizer",
                  TempAttendee."Attendee Type"::Salesperson,
                  SalesPurchPerson.Code,TRUE);
                AttendeeLineNo += 10000;
              END;
              IF Cont.GET(GETFILTER("No of appointments")) THEN BEGIN
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::Required,
                  TempAttendee."Attendee Type"::Contact,
                  Cont."No.",
                  Cont."E-Mail" <> '');
                AttendeeLineNo += 10000;
              END;
            END;
          (GETFILTER("No of appointments") <> '') AND (GETFILTER("Meeting Type") <> ''):
            BEGIN
              IF Campaign.GET(GETFILTER("Meeting Type")) THEN
                IF SalesPurchPerson.GET(Campaign."Salesperson Code") THEN BEGIN
                  TempAttendee.CreateAttendee(
                    TempAttendee,
                    "No.",AttendeeLineNo,
                    TempAttendee."Attendance Type"::"To-do Organizer",
                    TempAttendee."Attendee Type"::Salesperson,
                    SalesPurchPerson.Code,TRUE);
                  AttendeeLineNo += 10000
                END;
              IF Cont.GET(GETFILTER("No of appointments")) THEN BEGIN
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::Required,
                  TempAttendee."Attendee Type"::Contact,
                  Cont."No.",Cont."E-Mail" <> '');
                AttendeeLineNo += 10000;
              END;
            END
          ELSE BEGIN
            IF Cont.GET(GETFILTER("No of appointments")) THEN BEGIN
              IF Cont."Salesperson Code" <> '' THEN BEGIN
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::"To-do Organizer",
                  TempAttendee."Attendee Type"::Salesperson,
                  Cont."Salesperson Code",TRUE);
                AttendeeLineNo += 10000
              END;
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::Required,
                TempAttendee."Attendee Type"::Contact,
                Cont."No.",Cont."E-Mail" <> '');
              AttendeeLineNo += 10000;
            END ELSE
              IF Cont.GET(GETFILTER("Contact Company No.")) THEN BEGIN
                IF Cont."Salesperson Code" <> '' THEN BEGIN
                  TempAttendee.CreateAttendee(
                    TempAttendee,
                    "No.",AttendeeLineNo,
                    TempAttendee."Attendance Type"::"To-do Organizer",
                    TempAttendee."Attendee Type"::Salesperson,
                    Cont."Salesperson Code",TRUE);
                  AttendeeLineNo += 10000
                END;
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::Required,
                  TempAttendee."Attendee Type"::Contact,
                  Cont."No.",Cont."E-Mail" <> '');
                AttendeeLineNo += 10000;
              END;
        
            IF SalesPurchPerson.GET(GETFILTER("No of meetings")) THEN BEGIN
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::"To-do Organizer",
                TempAttendee."Attendee Type"::Salesperson,
                SalesPurchPerson.Code,TRUE);
              AttendeeLineNo += 10000;
            END;
        
            IF Campaign.GET(GETFILTER("Meeting Type")) THEN
              IF SalesPurchPerson.GET(Campaign."Salesperson Code") THEN BEGIN
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::"To-do Organizer",
                  TempAttendee."Attendee Type"::Salesperson,
                  SalesPurchPerson.Code,TRUE);
                AttendeeLineNo += 10000
              END;
        
            IF Opp.GET(GETFILTER("Appointments type")) THEN BEGIN
              IF SalesPurchPerson.GET(Opp."Salesperson Code") THEN BEGIN
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::"To-do Organizer",
                  TempAttendee."Attendee Type"::Salesperson,
                  SalesPurchPerson.Code,TRUE);
                AttendeeLineNo += 10000
              END;
              IF Cont.GET(Opp."Contact No.") THEN BEGIN
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::Required,
                  TempAttendee."Attendee Type"::Contact,
                  Cont."No.",Cont."E-Mail" <> '');
                AttendeeLineNo += 10000
              END;
            END;
          END;
        END;
        
        IF SegHeader.GET(GETFILTER("Appointments time")) THEN BEGIN
          IF SalesPurchPerson.GET(SegHeader."Salesperson Code") THEN BEGIN
            TempAttendee.CreateAttendee(
              TempAttendee,
              "No.",AttendeeLineNo,
              TempAttendee."Attendance Type"::"To-do Organizer",
              TempAttendee."Attendee Type"::Salesperson,
              SalesPurchPerson.Code,TRUE);
            AttendeeLineNo += 10000
          END;
          SegLine.SETRANGE("Segment No.","Appointments time");
          SegLine.SETFILTER("Contact No.",'<>%1','');
          IF SegLine.FIND('-') THEN
            REPEAT
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::Required,
                TempAttendee."Attendee Type"::Contact,
                SegLine."Contact No.",
                (Cont.GET(SegLine."Contact No.") AND
                 (Cont."E-Mail" <> '')));
              AttendeeLineNo += 10000
            UNTIL SegLine.NEXT = 0;
        END;
        IF Team.GET(Date) THEN BEGIN
          TeamSalesperson.SETRANGE("Team Code",Team.Code);
          IF TeamSalesperson.FIND('-') THEN
            REPEAT
              TempAttendee.SETRANGE("Attendee Type",TempAttendee."Attendee Type"::Salesperson);
              TempAttendee.SETRANGE("Attendee No.",TeamSalesperson."Salesperson Code");
              IF NOT TempAttendee.FIND('-') THEN
                IF SalesPurchPerson.GET(TeamSalesperson."Salesperson Code") THEN BEGIN
                  TempAttendee.RESET;
                  TempAttendee.CreateAttendee(
                    TempAttendee,
                    "No.",AttendeeLineNo,
                    TempAttendee."Attendance Type"::Required,
                    TempAttendee."Attendee Type"::Salesperson,
                    TeamSalesperson."Salesperson Code",
                    SalesPurchPerson."E-Mail" <> '');
                  AttendeeLineNo += 10000
                END;
              TempAttendee.RESET;
            UNTIL TeamSalesperson.NEXT = 0;
        END;
        
        InteractionTemplateSetup.GET;
        IF (InteractionTemplateSetup."Meeting Invitation" <> '') AND
           InteractionTemplate.GET(InteractionTemplateSetup."Meeting Invitation")
        THEN
         // UpdateInteractionTemplate(
            //Rec,TodoInteractionLanguage,TempAttachment,InteractionTemplate.Code,TRUE);*/

    end;

    procedure ValidateInteractionTemplCode();
    begin
        //UpdateInteractionTemplate(
        //Rec,TodoInteractionLanguage,TempAttachment,"Interaction Template Code",TRUE);
        //LoadTempAttachment;
    end;

    procedure AssistEditAttachment();
    begin
        /*IF TempAttachment.GET(GetMeetingOrganizerTodo) THEN BEGIN
          TempAttachment.OpenAttachment("Interaction Template Code" + ' ' + Description,TRUE,"Language Code");
          TempAttachment.MODIFY;
        END ELSE
          ERROR(Text047);*/

    end;

    procedure ValidateLanguageCode();
    begin
        /*IF "Language Code" = xRec."Language Code" THEN
          EXIT;
        
        IF NOT TodoInteractionLanguage.GET("No.","Language Code") THEN BEGIN
          IF "No." = '' THEN
            ERROR(Text009,TodoInteractionLanguage.TABLECAPTION);
        END ELSE
          GetMeetingOrganizerTodo := TodoInteractionLanguage."Attachment No.";*/

    end;

    procedure LookupLanguageCode();
    begin
        /*TodoInteractionLanguage.SETFILTER("To-do No.",'');
        IF TodoInteractionLanguage.GET('',"Language Code") THEN
          IF PAGE.RUNMODAL(0,TodoInteractionLanguage) = ACTION::LookupOK THEN BEGIN
            "Language Code" := TodoInteractionLanguage."Language Code";
            GetMeetingOrganizerTodo := TodoInteractionLanguage."Attachment No.";
          END;*/

    end;

    procedure LoadTempAttachment();
    var
    //Attachment : Record "5062";
    //TempAttachment2 : Record "5062" temporary;
    begin
        /*IF TempAttachment.FINDSET THEN
          REPEAT
            TempAttachment2 := TempAttachment;
            TempAttachment2.INSERT;
          UNTIL TempAttachment.NEXT = 0;
        
        IF TempAttachment2.FINDSET THEN
          REPEAT
            Attachment.GET(TempAttachment2."No.");
            Attachment.CALCFIELDS("Attachment File");
            TempAttachment.GET(TempAttachment2."No.");
            TempAttachment.WizEmbeddAttachment(Attachment);
            TempAttachment."No." := TempAttachment2."No.";
            TempAttachment.MODIFY;
          UNTIL TempAttachment2.NEXT = 0;*/

    end;

    procedure ClearDefaultAttendeeInfo();
    begin
        /*TempAttendee.DELETEALL;
        TempAttachment.DELETEALL;
        TodoInteractionLanguage.DELETEALL;
        "Interaction Template Code" := '';
        "Language Code" := '';
        GetMeetingOrganizerTodo := 0;
        ArrangeOrganizerAttendee := '';
        FinishWizard := 0;
        CheckStatus := 0;
        MODIFY;*/

    end;

    //procedure GetAttendee(var Attendee : Record "5199");
    // begin
    /*Attendee.DELETEALL;
    IF TempAttendee.FIND('-') THEN
      REPEAT
        Attendee := TempAttendee;
        Attendee.INSERT;
      UNTIL TempAttendee.NEXT = 0;*/

    // end;

    //procedure SetAttendee(var Attendee : Record "5199");
    //begin
    /*TempAttendee.DELETEALL;

    IF Attendee.FINDSET THEN
      REPEAT
        TempAttendee := Attendee;
        TempAttendee.INSERT;
      UNTIL Attendee.NEXT = 0;*/

    //end;

    //procedure SetComments(var RMCommentLine : Record "5061");
    //begin
    /*RMCommentLineTmp.DELETEALL;

    IF RMCommentLine.FINDSET THEN
      REPEAT
        RMCommentLineTmp := RMCommentLine;
        RMCommentLineTmp.INSERT;
      UNTIL RMCommentLine.NEXT = 0;*/

    //end;

    local procedure StartWizard2();
    begin
        /*"Wizard Contact Name" := GetContactName;
        IF Cont.GET(GETFILTER("No of appointments")) THEN
          "Wizard Contact Name" := Cont.Name
        ELSE
          IF Cont.GET(GETFILTER("Contact Company No.")) THEN
            "Wizard Contact Name" := Cont.Name;
        
        IF Campaign.GET(GETFILTER("Meeting Type")) THEN
          "Wizard Campaign Description" := Campaign.Description;
        
        IF SegHeader.GET(GETFILTER("Appointments time")) THEN
          "Segment Description" := SegHeader.Description;
        
        "Wizard Step" := "Wizard Step"::"1";
        Duration := 1440 * 1000 * 60;
        
        INSERT;
        
        IF PAGE.RUNMODAL(PAGE::"Assign Activity",Rec) = ACTION::OK THEN;*/

    end;

    procedure CheckAssignActivityStatus();
    begin
        /*IF "Activity Code" = '' THEN
          ErrorMessage(Text051);
        IF AssignActivityFromToDo = 0D THEN
          ErrorMessage(FIELDCAPTION(AssignActivityFromToDo));
        IF (Date = '') AND ("No of meetings" = '') THEN
          ERROR(Text053,FIELDCAPTION("No of meetings"),FIELDCAPTION(Date));
        IF (Date <> '') AND
           Activity.IncludesMeeting("Activity Code") AND
           ("Team Meeting Organizer" = '')
        THEN
          ERROR(Text056,"Activity Code");*/

    end;

    //procedure FinishAssignActivity();
    var
    //TempRlshpMgtCommentLine : Record "5061" temporary;
    // TempAttendee : Record "5199" temporary;
    //TempToDoInteractionLanguage : Record "5196" temporary;
    //TempAttachment : Record "5062" temporary;
    //begin
    /*TempAttendee.DELETEALL;
    IF "Team Meeting Organizer" <> '' THEN
      TempAttendee.CreateAttendee(
        TempAttendee,
        "No.",10000,TempAttendee."Attendance Type"::"To-do Organizer",
        TempAttendee."Attendee Type"::Salesperson,
        "Team Meeting Organizer",
        TRUE)
    ELSE
      IF "No of meetings" <> '' THEN
        TempAttendee.CreateAttendee(
          TempAttendee,
          "No.",10000,TempAttendee."Attendance Type"::"To-do Organizer",
          TempAttendee."Attendee Type"::Salesperson,
          "No of meetings",
          TRUE);
    //InsertTodo(
      //Rec,TempRlshpMgtCommentLine,TempAttendee,
      //TempToDoInteractionLanguage,TempAttachment,"Activity Code",FALSE);
    //DELETE;*/

    //end;

    local procedure TransformFromCode20ToCode10(Code20Input: Code[20]): Code[10];
    begin
        /*IF STRLEN(Code20Input) > 10 THEN
          EXIT('');
        EXIT(COPYSTR(Code20Input,1,10));*/

    end;

    //local procedure FillSalesPersonContact(var ToDoParameter : Record "5080";AttendeeParameter : Record "5199");
    //begin
    /*CASE AttendeeParameter."Attendee Type" OF
      AttendeeParameter."Attendee Type"::Contact:
        ToDoParameter.VALIDATE("Contact No.",AttendeeParameter."Attendee No.");
      AttendeeParameter."Attendee Type"::Salesperson:
        ToDoParameter.VALIDATE("Salesperson Code",TransformFromCode20ToCode10(AttendeeParameter."Attendee No."));
    END;*/

    //end;

    procedure SetRunFromForm();
    begin
        /*RunFormCode := TRUE;*/

    end;

    local procedure IsCalledFromForm(): Boolean;
    begin
        /*EXIT((CurrFieldNo <> 0) OR RunFormCode);*/

    end;

    local procedure OneDayDuration(): Integer;
    begin
        /*EXIT(86400000); // 24 * 60 * 60 * 1000 = 86,400,000 ms in 24 hours*/

    end;

    //local procedure GetCurrentUserTimeZone(var TimeZoneInfo : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.TimeZoneInfo"; TimeZoneID : Text);

    var
    //TimeZoneInfoRussianStandard: DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.TimeZoneInfo";
    //begin
    /*IF TimeZoneID = 'Russian Standard Time' THEN BEGIN
      TimeZoneInfoRussianStandard := TimeZoneInfoRussianStandard.FindSystemTimeZoneById(TimeZoneID);
      TimeZoneInfo := TimeZoneInfo.CreateCustomTimeZone(TimeZoneID,TimeZoneInfoRussianStandard.BaseUtcOffset,'','');
    END ELSE
      TimeZoneInfo := TimeZoneInfo.FindSystemTimeZoneById(TimeZoneID);*/

    // end;

    //local procedure InitializeExchangeAppointment(var Appointment : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment";

    //var
    // ExchangeWebServicesServer: Codeunit "5321");
    //var
    //  TimeZoneInfo: DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.TimeZoneInfo";
    //begin
    /*SetupExchangeService(ExchangeWebServicesServer);
    ExchangeWebServicesServer.CreateAppointment(Appointment);
    GetCurrentUserTimeZone(TimeZoneInfo,ExchangeWebServicesServer.GetCurrentUserTimeZone);
    UpdateAppointment(Appointment,TimeZoneInfo);
    */

    //end;

    //local procedure UpdateAppointmentSalesPersonList(var SalesPersonList : Text;AddSalesPersonName : Text[50]);
    //begin
    /*IF AddSalesPersonName <> '' THEN
      IF SalesPersonList = '' THEN
        SalesPersonList := AddSalesPersonName
      ELSE
        SalesPersonList += ', ' + AddSalesPersonName ;*/

    //end;

    //local procedure SaveAppointment(var Appointment : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment");
    //begin
    /*Appointment.SendAppointment;*/

    //end;

    //procedure UpdateAppointment(var Appointment : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment"; TimeZoneInfo : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.TimeZoneInfo");

    // var
    //DateTime: DateTime;
    //begin
    /*Appointment.Subject := Description;
    Appointment.Location := Location;
    DateTime := CREATEDATETIME(AssignActivityFromToDo,RemoveAttachment);
    Appointment.MeetingStart := DateTime;
    IF "All Day Event" THEN
      Appointment.IsAllDayEvent := TRUE
    ELSE BEGIN
      DateTime := CREATEDATETIME("Ending Date","Ending Time");
      Appointment.MeetingEnd := DateTime;
    END;
    Appointment.StartTimeZone := TimeZoneInfo;
    Appointment.EndTimeZone := TimeZoneInfo;*/

    //end;

    // procedure SetupExchangeService(var ExchangeWebServicesServer : Codeunit "5321");
    var
        // User : Record "2000000120";
        //begin
        /*COMMIT;
        User.SETRANGE("User Name",USERID);
        IF NOT User.FINDFIRST AND NOT Initialize(ExchangeWebServicesServer,User."Authentication Email") THEN
          IF NOT InitializeServiceWithCredentials(ExchangeWebServicesServer) THEN
            ERROR('');*/

        //end;

        //local procedure MakeAppointmentBody(ToDo : Record "5080";SalespersonsList : Text;SalespersonName : Text[50]) : Text;
        //begin
        /*EXIT(
          STRSUBSTNO(Text015,SalespersonsList) + '<br/><br/>' +
          STRSUBSTNO(Text016,FORMAT(ToDo.Date),FORMAT(ToDo."Start Time"),FORMAT(ToDo.Location)) + '<br/><br/>' +
          Text017 + '<br/>' +
          SalespersonName + '<br/>' +
          FORMAT(TODAY) + ' ' + FORMAT(TIME));*/

        //end;

        //local procedure SetAttendeeInvitationSent(var Attendee : Record "5199");
        //begin
        /*Attendee."Invitation Sent" := TRUE;
        Attendee.MODIFY;*/

        //end;

        //procedure AddAppointmentAttendee(var Appointment : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment";

        //var
        //Attendee: Record "5199";
        //Email: Text);
        // begin
        /*IF Attendee."Attendance Type" = Attendee."Attendance Type"::Required THEN
          Appointment.AddRequiredAttendee(Email)
        ELSE
          Appointment.AddOptionalAttendee(Email);
        SetAttendeeInvitationSent(Attendee);*/

        // end;

        /*local procedure ProcessAttendeeAppointment(ToDo : Record "5080";var Attendee : Record "5199");
        var
            ToDo2 : Record "5080";
            Salesperson : Record "13";
            Salesperson2 : Record "13";
            ExchangeWebServicesServer : Codeunit "5321";
            Mail : Codeunit "397";
            //Appointment : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment";
            SalesPersonList : Text;
            Body : Text;
        begin
            /*IF CreateExchangeAppointment THEN
              InitializeExchangeAppointment(Appointment,ExchangeWebServicesServer);
            REPEAT
              IF FindAttendeeTodo(ToDo2,Attendee) THEN
                IF Attendee."Attendee Type" = Attendee."Attendee Type"::Salesperson THEN
                  IF Salesperson2.GET(ToDo2."Salesperson Code") AND
                     Salesperson.GET(ToDo."Salesperson Code")
                  THEN
                    IF CreateExchangeAppointment THEN BEGIN
                      UpdateAppointmentSalesPersonList(SalesPersonList,Salesperson2.Name);
                      IF Salesperson2."E-Mail" <> '' THEN
                        AddAppointmentAttendee(Appointment,Attendee,Salesperson2."E-Mail");
                    END ELSE BEGIN
                      Body := MakeAppointmentBody(ToDo,Salesperson2.Name,Salesperson.Name);
                      IF Mail.NewMessage(Salesperson2."E-Mail",'','',ToDo2.Description,Body,'',FALSE) THEN
                        SetAttendeeInvitationSent(Attendee)
                      ELSE
                        MESSAGE(Text023,Attendee."Attendee Name");
                    END
                  ELSE BEGIN
                    LogTodoInteraction(ToDo,ToDo2,TRUE);
                    SetAttendeeInvitationSent(Attendee);
                  END;
            UNTIL Attendee.NEXT = 0;
            IF CreateExchangeAppointment AND (SalesPersonList <> '') THEN BEGIN
              Body := MakeAppointmentBody(ToDo,SalesPersonList,Salesperson.Name);
              Appointment.Body := Body;
              SaveAppointment(Appointment)
            END;*/

        // end;

        // [TryFunction]
        //local procedure InitializeServiceWithCredentials(var ExchangeWebServicesServer : Codeunit "5321");
        //var
        //TempOfficeAdminCredentials : Record "1612" temporary;
        //WebCredentials : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.WebCredentials";
        //  WebCredentialsLogin : Text[250];
        //begin
        /*TempOfficeAdminCredentials.INIT;
        TempOfficeAdminCredentials.INSERT;
        COMMIT;
        CLEARLASTERROR;
        IF PAGE.RUNMODAL(PAGE::"Office 365 Credentials",TempOfficeAdminCredentials) <> ACTION::LookupOK THEN
          ERROR('');
        WebCredentialsLogin := TempOfficeAdminCredentials.Email;
        WebCredentials := WebCredentials.WebCredentials(WebCredentialsLogin,TempOfficeAdminCredentials.Password);
        TempOfficeAdminCredentials.DELETE;
        ExchangeWebServicesServer.Initialize(
          WebCredentialsLogin,ExchangeWebServicesServer.ProdEndpoint,WebCredentials,FALSE);*/

        //end;

        //[TryFunction]
        //local procedure Initialize(var ExchangeWebServicesServer : Codeunit "5321";AuthenticationEmail : Text[250]);
        //var
        //ExchangeServiceSetup : Record "5324";
        //AzureADMgt : Codeunit "6300";
        AccessToken: Text;
    // begin
    /*AccessToken := AzureADMgt.GetAccessToken(AzureADMgt.GetO365Resource,AzureADMgt.GetO365ResourceName,FALSE);

    IF AccessToken <> '' THEN BEGIN
      ExchangeWebServicesServer.InitializeWithOAuthToken(AccessToken,ExchangeWebServicesServer.GetEndpoint);
      EXIT;
    END;

    ExchangeServiceSetup.GET;

    ExchangeWebServicesServer.InitializeWithCertificate(
      ExchangeServiceSetup."Azure AD App. ID",ExchangeServiceSetup."Azure AD App. Cert. Thumbprint",
      ExchangeServiceSetup."Azure AD Auth. Endpoint",ExchangeServiceSetup."Exchange Service Endpoint",
      ExchangeServiceSetup."Exchange Resource Uri");

    ExchangeWebServicesServer.SetImpersonatedIdentity(AuthenticationEmail);
    */

    //end;
}

