dotnet
{
    assembly(GetNAVIPAddress)
    {
        type(GetNAVIPAddress.GetIPMac; GetIPMac) { }
    }
    assembly(System)
    {
        type(System.Net.IPAddress; IPAddress) { }
        type(System.Net.Dns; Dns) { }
        type(System.Net.IPHostEntry; IPHostEntry) { }
    }

}