tableextension 50427 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Disallow Own Approver"; Boolean)
        {
        }
        field(50001; "Current Bugdet"; Code[20])
        {
            TableRelation = "G/L Budget Name";

            trigger OnValidate();
            begin
                GLBudgetName.GET("Current Bugdet");
                "Current Budget Start Date" := GLBudgetName."Budget Start Date";
                "Current Budget End Date" := GLBudgetName."Budget End Date";
            end;
        }
        field(50002; "Current Budget Start Date"; Date)
        {
            Editable = false;
        }
        field(50003; "Current Budget End Date"; Date)
        {
            Editable = false;
        }
    }
    var
        GLBudgetName: Record "G/L Budget Name";

}