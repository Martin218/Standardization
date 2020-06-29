table 50515 "Admin Cue"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Code[250])
        {

            DataClassification = ToBeClassified;
        }
        field(2; "Vehicle Booking-New"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Vehicle Booking" where(Status = FILTER(New)));

        }

        field(3; "Vehicle Approval-Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Vehicle Booking" where(Status = FILTER("Pending")));

        }
        field(4; "Vehicle Insurance-Scheduled"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Vehicle Insurance Scheduling" where(Scheduled = FILTER(true)));

        }
        field(5; "Vehicle Booking-Rejected"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Vehicle Booking" where(Status = FILTER(Rejected)));

        }
        field(6; "Vehicle Booking-Booked"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Vehicle Booking" where(Status = FILTER(Booked)));

        }
        field(7; "Total Fueled Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum ("Fuel Tracking"."Fuel Cost");

        }
        field(8; "Total Valuation Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum ("Vehicle Insurance Scheduling"."Last Valuation Amount");

        }
        field(12; "Boardroom Booking-New"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Booking Process" where(Status = FILTER(New)));

        }

        field(13; "Boardroom Booking-Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Booking Process" where(Status = FILTER("Pending")));

        }
        field(14; "Boardroom Booking-Approved"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Booking Process" where(Status = FILTER(Booked)));

        }
        field(15; "Boardroom Booking-Rejected"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Booking Process" where(Status = FILTER(Rescheduled)));

        }

    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }
}