report 50550 "Registry Inventory"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Registry\Registry Inventory.rdlc';
    Caption = 'Registry Member Files Inventory';

    dataset
    {
        dataitem("Registry File"; "Registry File")
        {
            DataItemTableView = WHERE(Created = filter('Yes'));
            RequestFilterFields = "File Number", "File Type", "Member No.", "Date Filter";
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(Address_CompanyInformation; CompanyInformation.Address)
            {
            }
            column(PostCode_CompanyInformation; CompanyInformation."Post Code")
            {
            }
            column(City_CompanyInformation; CompanyInformation.City)
            {
            }
            column(Pic_CompanyInformation; CompanyInformation.Picture)
            {
            }
            column(FileType_RegistryFile; "Registry File"."File Type")
            {
            }
            column(FileNo_RegistryFile; "Registry File"."File No.")
            {
            }
            column(FileName_RegistryFile; "Registry File"."File Name")
            {
            }
            column(Type_RegistryFile; "Registry File".Type)
            {
            }
            column(Status_RegistryFile; "Registry File".Status)
            {
            }
            column(Location_RegistryFile; "Registry File".Location1)
            {
            }
            column(CabinetRackNo_RegistryFile; "Registry File"."Cabinet/Rack No.")
            {
            }
            column(RowNo_RegistryFile; "Registry File"."Row No.")
            {
            }
            column(ColumnNo_RegistryFile; "Registry File"."Column No.")
            {
            }
            column(PocketNo_RegistryFile; "Registry File"."Pocket No.")
            {
            }
            column(CreatedBy_RegistryFile; "Registry File"."Created By")
            {
            }
            column(DateCreated_RegistryFile; "Registry File"."Date Created")
            {
            }
            column(MemberNo_RegistryFile; "Registry File"."Member No.")
            {
            }
            column(IDNo_RegistryFile; "Registry File"."ID No.")
            {
            }
            column(MemberStatus_RegistryFile; "Registry File"."Member Status")
            {
            }
            column(FileLocation_RegistryFile; "Registry File"."File Location")
            {
            }
            column(FileRequestStatus_RegistryFile; "Registry File"."File Request Status")
            {
            }
            column(FileNumber_RegistryFile; "Registry File"."File Number")
            {
            }
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

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        date1: Date;
        date2: Date;
        datefilterstring: Text;
        date1string: Text;
        date2string: Text;
        CreatedDate1: Date;
        CreatedDate2: Date;
        RegistryStatus: Text;
        RegistryFiles: Record "Registry File";
        StatusRequest: Text;
        RegistryFiles2: Record "Registry File";
        IssuedRegistryFiles: Record "Issued Registry File";
        IssuedTo: Code[100];
        dept: Code[10];
        //DimensionValue : Record "349";
        User: Record "User Setup";
        deptName: Text;
        BranchName: Text[20];
}

