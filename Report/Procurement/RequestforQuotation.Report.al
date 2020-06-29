report 50504 "Request for Quotation"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Procurement\RequestforQuotation.rdlc';

    dataset
    {
        dataitem(DataItem1; "Procurement Supplier Selection")
        {
            column(VendorNo_ProcurementSupplierSelection; "Vendor No.")
            {
            }
            column(Name_ProcurementSupplierSelection; Name)
            {
            }
            column(ProcessNo_ProcurementSupplierSelection; "Process No.")
            {
            }
            column(CONDITIONSCaption; CONDITIONSCaptionLbl)
            {
            }
            column(ConditionOneCaption; ConditionOneLbl)
            {
            }
            column(ConditionTwoCaption; ConditionTwoLbl)
            {
            }
            column(ConditionThreeCaption; ConditionThreeLbl)
            {
            }
            column(ConditionFourCaption; ConditionFourLbl)
            {
            }
            column(ConditionFiveCaption; ConditionFiveLbl)
            {
            }
            column(ConditionSixCaption; ConditionSixLbl)
            {
            }
            column(ConditionSevenCaption; ConditionSevenLbl)
            {
            }
            column(ConditionEightCaption; ConditionEightLbl)
            {
            }
            column(ConditionNineCaption; ConditionNineLbl)
            {
            }
            column(Paragraph1Lbl; Paragraph1Lbl)
            {
            }
            column(Paragraph1Lbl2; Paragraph1Lbl2)
            {
            }
            column(Paragraph1Lbl3; Paragraph1Lbl3)
            {
            }
            column(Paragraph1Lbl4; Paragraph1Lbl4)
            {
            }
            column(Paragraph1Lbl5; Paragraph1Lbl5)
            {
            }
            column(Paragraph1Lbl6; Paragraph1Lbl6Txt)
            {
            }
            column(Paragraph1Lbl7; Paragraph1Lbl7)
            {
            }
            column(Paragraph1Lbl8; Paragraph1Lbl8)
            {
            }
            column(Comp_Name; CompanyInformation.Name)
            {
            }
            column(Comp_Address; CompanyInformation.Address)
            {
            }
            column(Comp_City; CompanyInformation.City)
            {
            }
            column(Comp_Phone; CompanyInformation."Phone No.")
            {
            }
            column(Comp_Pic; CompanyInformation.Picture)
            {
            }
            column(Comp_Post; CompanyInformation."Post Code")
            {
            }
            column(DateCaption; DateCaption)
            {
            }
            column(ProcessNoCaption; ProcessNoCaption)
            {
            }
            column(SpecialLbl; SpecialLbl)
            {
            }
            column(Instruction_Lbl; Instruction_Lbl)
            {
            }
            column(Signature_Lbl; Signature_Lbl)
            {
            }
            column(Instruction_Lbl2; Instruction_Lbl2)
            {
            }
            column(Instruction_Lbl3; Instruction_Lbl3)
            {
            }
            column(Instruction_Lbl4; Instruction_Lbl4)
            {
            }
            column(Instruction_Lbl5; Instruction_Lbl5)
            {
            }
            column(Instruction_Lbl5_1; Instruction_Lbl5_1)
            {
            }
            column(Instruction_Lbl6; Instruction_Lbl6)
            {
            }
            dataitem(DataItem23; "Procurement Request Line")
            {
                DataItemLink = "Request No." = FIELD("Process No.");
                column(Type_ProcurementRequestLine; Type)
                {
                }
                column(No_ProcurementRequestLine; "No.")
                {
                }
                column(Description_ProcurementRequestLine; Description)
                {
                }
                column(Quantity_ProcurementRequestLine; Quantity)
                {
                }
                column(UnitofMeasure_ProcurementRequestLine; "Unit of Measure")
                {
                }
                column(UnitPrice_ProcurementRequestLine; "Unit Price")
                {
                }
                column(Amount_ProcurementRequestLine; Amount)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                IF ProcurementRequest.GET("Process No.") THEN BEGIN
                    Paragraph1Lbl6Txt := STRSUBSTNO(Paragraph1Lbl6, ProcurementRequest."Closing Time", ProcurementRequest."Closing Date");
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitle = 'REQUEST FOR QUOTATION';
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        DateCaption: Label 'Date';
        ProcessNoCaption: Label 'Quotation No.';
        CONDITIONSCaptionLbl: Label 'NOTE:';
        ConditionOneLbl: Label '1. Delivery lead-time and validity period of your quotation MUST be indicated';
        ConditionTwoLbl: Label '2. The quotation should be enclosed in plain sealed envelope and the quotation reference number MUST be indicated on the envelope';
        ConditionThreeLbl: Label '3. Prices quoted MUST be inclusive of VAT and all other costs where applicable.';
        ConditionFourLbl: Label '4. The quotation MUST be stamped and signed.';
        ConditionFiveLbl: Label '5. The quotation MUST be placed in the quotation box at NEMA Hqs in South C off Popo Road, Nairobi Kenya.';
        ConditionSixLbl: Label '6. The supplier shall retain a COPY of the quotation on the quotation submission date.';
        ConditionSevenLbl: Label '"7. Attach copies of certificate of registration/Incorporation "';
        ConditionEightLbl: Label '8. Failure to observe the above conditions shall lead to automatic disqualification of the bidder';
        ConditionNineLbl: Label '9. NEMA reserves the right to accept or reject any bid wholly or in part and does not bind itself to accept any bid.';
        To_CaptionLbl: Label 'To:';
        CompanyInformation: Record "Company Information";
        Ref: Label 'REF:';
        Paragraph1Lbl: Label 'Quotation number should be indicated on the envelope top left corner.';
        Paragraph1Lbl2: Label 'Notes:';
        SpecialLbl: Label 'Special Instructions:';
        Paragraph1Lbl3: Label '"                 (a)   THIS IS NOT AN ORDER."';
        Paragraph1Lbl4: Label '"                        Read the Conditions and Instructions below before quoting."';
        Paragraph1Lbl5: Label '"                 (b)  This quotation should be submitted in a plain wax sealed Envelope marked ""Quotation No:"""';
        Paragraph1Lbl6: Label '"                        to reach the Buyer or be placed in the Quotation/Tender Box not later than %1 on %2"';
        Paragraph1Lbl7: Label '"                 (c)   Your Quotation should indicate Final Unit Price, which includes all costs for Delivery, Discount, Duty and Sales Tax."';
        Paragraph1Lbl8: Label '"                 (d)   Return the Original Copy and Retain the Duplicate for your Record."';
        Paragraph1Lbl6Txt: Text;
        Instruction_Lbl: Label '"We undertake if our quotation is accepted to supply the goods in accordance with the schedule of prices and delivery period Specified here in above.                                                                                                            "';
        Signature_Lbl: Label '"Authorized Signature............................................... Date ......................................Company''s Rubber stamp....................................     "';
        Instruction_Lbl2: Label '"               1.  All entries must be typed or written in ink. Mistakes must be erased but should be crossed out and corrections be made and initialed by the person signing the quotation."';
        Instruction_Lbl3: Label '"               2.  Quote on each item separately and in units as specified."';
        Instruction_Lbl4: Label '"               3.  This form must be signed by a competent person and rubber stamped/sealed."';
        Instruction_Lbl5: Label '"               4.  If you do not wish to quote, please endorse the reason on this form and return it, otherwise your name may be deleted from the buyers'' mailing list for the items list hereon"';
        Instruction_Lbl5_1: Label 'INSTRUCTIONS';
        Instruction_Lbl6: Label '"               5.  Payment shall be made within 30 days after delivery"';
        ProcurementRequest: Record "Procurement Request";
}

