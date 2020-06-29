table 50413 "Procurement Request"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; Description; Text[80])
        {
        }
        field(3; "Requisition No."; Code[10])
        {
            TableRelation = "Requisition Header" WHERE("Requisition Type" = FILTER("Purchase Requisition"),
                                                        Status = FILTER(Released));

            trigger OnValidate();
            begin
                IF "Auto Generated" = TRUE THEN
                    ERROR(AutoGenerateErr);
            end;
        }
        field(4; "Procurement Plan No."; Code[10])
        {
        }
        field(5; "Created On"; Date)
        {
        }
        field(6; "Current Budget"; Code[10])
        {
        }
        field(7; "Procurement Method"; Code[20])
        {
            TableRelation = "Procurement Method";
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Department';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(11; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; Posted; Boolean)
        {
        }
        field(14; "Assigned User"; Code[80])
        {
        }
        field(15; "Procurement Option"; Option)
        {
            OptionCaption = ',Direct,Low Value,Open Tender,Restricted Tender,Request For Quotation,Request For Proposal,International Open Tender,National Open Tender';
            OptionMembers = ,Direct,"Low Value","Open Tender","Restricted Tender","Request For Quotation","Request For Proposal","International Open Tender","National Open Tender";
        }
        field(16; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Released,Rejected,Archived';
            OptionMembers = New,"Pending Approval",Released,Rejected,Archived;
        }
        field(17; "Created By"; Code[80])
        {
        }
        field(18; "LPO Generated"; Boolean)
        {
        }
        field(19; "LPO No."; Code[20])
        {
        }
        field(20; "LPO Posted"; Boolean)
        {
        }
        field(21; "Procurement Amount"; Decimal)
        {
            //CalcFormula = Sum ("Procurement Request Line".Amount WHERE("Request No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(22; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;// WHERE("Vendor Type" = FILTER(Normal));
        }
        field(23; "Auto Generated"; Boolean)
        {
        }
        field(24; "LPO Posting Date"; Date)
        {
        }
        field(25; "Closing Date"; Date)
        {
        }
        field(26; "Closing Time"; Time)
        {
        }
        field(27; "Opening Date"; Date)
        {
        }
        field(28; "Notification of Award Date"; Date)
        {
        }
        field(29; "Issued Date"; Date)
        {
        }
        field(30; "Issued Time"; Time)
        {
        }
        field(31; "Process Status"; Option)
        {
            OptionMembers = New,"Pending Opening",Opening,Evaluation,"Procurement Manager",CEO,LPO,Award,"EOI Invitation",Proposal;
        }
        field(32; "Advertisement Date"; Date)
        {

            trigger OnValidate();
            begin
                ValidateProcurementDates("Advertisement Date");
            end;
        }
        field(33; "Category Code"; Code[10])
        {
            TableRelation = "Supplier Category";

            trigger OnValidate();
            begin
                IF SupplierCategory.GET("Category Code") THEN
                    "Category Description" := SupplierCategory.Description;
            end;
        }
        field(34; "Category Description"; Text[200])
        {
        }
        field(35; "Evaluation Date"; Date)
        {
        }
        field(36; "Contract Signing Date"; Date)
        {
        }
        field(37; "Award Approval Date"; Date)
        {
        }
        field(38; "Process Completion Date"; Date)
        {
        }
        field(39; "Forwarded to Opening"; Boolean)
        {
        }
        field(40; "Forwarded to Evaluation"; Boolean)
        {
        }
        field(41; "Attached Opening Minutes"; Boolean)
        {
        }
        field(42; "Opening Minutes Path"; Text[200])
        {
        }
        field(43; "Attached Evaluation Minutes"; Boolean)
        {
        }
        field(44; "Evaluation Minutes Path"; Text[200])
        {
        }
        field(45; "Attached Professional Opinion"; Boolean)
        {
        }
        field(46; "Professional Opinion Path"; Text[200])
        {
        }
        field(47; "Evaluation Complete"; Boolean)
        {
        }
        field(48; "Award Initiated"; Boolean)
        {
        }
        field(49; "Request Email Sent"; Boolean)
        {
        }
        field(50; "Process Summary"; BLOB)
        {
            SubType = Memo;
        }
        field(51; "Attached Terms Of Reference"; Boolean)
        {
        }
        field(52; "Terms Of Reference Path"; Text[100])
        {
        }
        field(53; "Invitation Title"; Text[100])
        {
        }
        field(54; "Process Detail path"; Text[100])
        {
        }
        field(55; "Attached Process Details"; Boolean)
        {
        }
        field(56; "Contract Path"; Text[100])
        {
        }
        field(57; "Attached Contract"; Boolean)
        {
        }
        field(58; "Contract Generated"; Boolean)
        {
        }
        field(59; "Contract No."; Code[20])
        {
        }
        field(60; "Tender Fee"; Decimal)
        {
        }
        field(61; "Tender Extension Period"; DateFormula)
        {

            trigger OnValidate();
            begin
                TESTFIELD("Closing Date");
                "Closing Date" := CALCDATE(FORMAT("Tender Extension Period"), "Closing Date");
            end;
        }
        field(62; "Minimum Tender Submissions"; Integer)
        {
        }
        field(63; "Attached Opening Minutes Doc."; Blob)
        {

        }
        field(64; "Attached Eval Minutes Doc."; Blob)
        {

        }
        field(65; "Attached Professional Doc."; Blob)
        {

        }
        field(66; "Attached TOR Doc."; Blob)
        {

        }
        field(67; "Attached Proposal Doc."; Blob)
        {

        }
        field(68; "Attached Contract Doc."; Blob)
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
    }
    trigger OnInsert();
    begin

    end;

    var
        AutoGenerateErr: Label 'You are not allowed to update this request which was AutoGenerated.';
        SupplierCategory: Record "Supplier Category";
        ProcurementManagement: Codeunit "Procurement Management";

    //[Scope('Personalization')]
    procedure ValidateProcurementDates(AdvertDate: Date);
    var
        ProcurementMethod: Record "Procurement Method";
        AdvertDateErr: Label 'Kindly Capture All the Advertisement Dates.';
        ProcurementPlanLine: Record "Procurement Plan Line";
        RecRef: RecordRef;
        ProcurementRequest: Record "Procurement Request";
        AdvertisementDate: Date;
        ProcurementRequest2: Record "Procurement Request";
    begin
        AdvertisementDate := AdvertDate;
        IF ProcurementMethod.GET("Procurement Method") THEN BEGIN
            IF FORMAT(ProcurementMethod."Document Open Period") <> '0D' THEN
                "Opening Date" := CALCDATE(ProcurementMethod."Document Open Period", AdvertisementDate);
            IF FORMAT(ProcurementMethod."Process Evaluation Period") <> '0D' THEN
                "Evaluation Date" := CALCDATE(ProcurementMethod."Process Evaluation Period", AdvertisementDate);
            IF FORMAT(ProcurementMethod."Award Approval") <> '0D' THEN
                "Award Approval Date" := CALCDATE(ProcurementMethod."Award Approval", AdvertisementDate);
            IF FORMAT(ProcurementMethod."Notification Of Award") <> '0D' THEN
                "Notification of Award Date" := CALCDATE(ProcurementMethod."Notification Of Award", AdvertisementDate);
            IF FORMAT(ProcurementMethod."Time For Contract signature") <> '0D' THEN
                "Contract Signing Date" := CALCDATE(ProcurementMethod."Time For Contract Completion", AdvertisementDate);
            IF FORMAT(ProcurementMethod."Closing Period") <> '0D' THEN
                "Closing Date" := CALCDATE(ProcurementMethod."Closing Period", AdvertisementDate);
            "Closing Time" := 120000T;
            MODIFY;
        END;
    end;
}

