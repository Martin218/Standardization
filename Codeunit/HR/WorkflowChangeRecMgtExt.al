codeunit 50055 "Workflow Change Rec Mgt Ext"
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRevertValueForField(var Variant: Variant; xVariant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")

    begin

    end;

    var
        HRManagement: Codeunit 50050;
}