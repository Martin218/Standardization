report 50560 "Fuel Tracker Template"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Administration\Fuel Tracker Template.rdlc';

    dataset
    {
        dataitem("Fuel Tracker Setup"; "Fuel Tracker Setup")
        {
            column(Logbook; vehiclelogbook)
            {
            }
            column(Type; vehicletypeandmake)
            {
            }
            column(Regno; vehicleregistrationnumber)
            {
            }
            column(Date; date)
            {
            }
            column(Reason; descriptionandreasonoftrip)
            {
            }
            column(DriverName; driversname)
            {
            }
            column(Authoriser; authoriser)
            {
            }
            column(MeterStart; meterstart)
            {
            }
            column(MeterEnd; meterend)
            {
            }
            column(Mileage; 'mileage')
            {
            }
            column(FuelUtilisation; 'fuelutilisation')
            {
            }
            column(LitresTanked; 'litrestanked')
            {
            }
            column(PricePaid; 'pricepaid')
            {
            }
            column(VoucherNumber; 'vouchernumber')
            {
            }
            column(FuelConsumptionperKm; 'fuelconsumptionperkm')
            {
            }
            column(ChasisNo; chasisno)
            {
            }

            trigger OnAfterGetRecord();
            begin
                date := STRSUBSTNO(TEXT001);
                vehiclelogbook := TEXT002;
                vehiclechasisnumber := TEXT004;
                vehicleregistrationnumber := TEXT005;
                vehicletypeandmake := TEXT003;
                descriptionandreasonoftrip := TEXT006;
                driversname := TEXT007;
                authoriser := TEXT008;
                meterstart := TEXT009;
                meterend := TEXT010;
                mileage := TEXT011;
                fuelutilisation := TEXT012;
                litrestanked := TEXT013;
                pricepaid := TEXT014;
                vouchernumber := TEXT015;
                fuelconsumptionperkm := TEXT016;
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
    }

    var
        vehiclelogbook: Text;
        vehicletypeandmake: Text;
        vehiclechasisnumber: Text;
        vehicleregistrationnumber: Text;
        date: Text;
        descriptionandreasonoftrip: Text;
        driversname: Text;
        authoriser: Text;
        meterstart: Text;
        meterend: Text;
        mileage: Text;
        fuelutilisation: Text;
        litrestanked: Text;
        pricepaid: Text;
        vouchernumber: Text;
        fuelconsumptionperkm: Text;
        TEXT001: Label 'Date';
        TEXT002: Label 'VEHICLE LOG BOOK (1)';


        TEXT003: Label 'VEHICLE TYPE AND MAKE : __________________________';


        TEXT004: Label 'VEHICLE CHASSIS NUMBER : _________________';


        TEXT005: Label 'VEHICLE REGISTRATION PLATE NUMBER: _________________';


        TEXT006: Label 'Description and reason of the trip';


        TEXT007: Label 'Drivers name';


        TEXT008: Label 'Person authorising the trip';


        TEXT009: Label 'Meter at start of trip';


        TEXT010: Label 'Meter at end of trip';


        TEXT011: Label 'Mileage (or kilometers) made';


        TEXT012: Label 'Fuel utilisation';


        TEXT013: Label 'Liters of fuel tanked';


        TEXT014: Label 'Price paid';


        TEXT015: Label 'Voucher number';


        TEXT016: Label 'Fuel consumption (liters/100km)';


        chasisno: Text;
        TEXT017: Label 'VEHICLE CHASSIS NUMBER : _________________';


}

