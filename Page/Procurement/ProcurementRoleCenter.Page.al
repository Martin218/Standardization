page 50820 "Procurement RoleCenter"
{
    Caption = 'Procurement RoleCenter';

    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            group(ProcurementPlan_)
            {
                /* part(Page; "Procurement  Plan List")
                {
                    ApplicationArea = All;
                } */
                part(Part1; "Procurement RoleCenter_Test")
                {
                    ApplicationArea = All;
                }

                // part(Part2; "Sales Invoice Cue")
                // {
                //     Caption = 'PROCUREMENT';
                //     ApplicationArea = All;
                // }
            }
        }
    }
    actions
    {
        area(Sections)
        {
            group(ProcurementModule)
            {
                caption = 'Procurement Management';
                //Image = RegisteredDocs;
                group(Finance)
                {
                    Caption = 'Budgets';
                    action(GLSetup)
                    {
                        ApplicationArea = All;
                        Caption = 'General Ledger Setup';
                        RunObject = page "General Ledger Setup";
                    }
                    action(GLBudgets)
                    {
                        ApplicationArea = All;
                        Caption = 'GL Budgets';
                        RunObject = page "G/L Budget Names";
                    }
                }
                group(AllSetups)
                {
                    caption = 'Procurement Management Setups';
                    action(ProcurementSetups_)
                    {
                        ApplicationArea = All;
                        Caption = 'Procurement Setup';
                        RunObject = page "Procurement Setup";
                    }
                    action(SupplierCategory)
                    {
                        ApplicationArea = All;
                        Caption = 'Supplier Category';
                        RunObject = page "Supplier Category";
                    }
                    action(PrequalifiedSuppliers)
                    {
                        ApplicationArea = All;
                        Caption = 'Prequalified Suppliers';
                        RunObject = page "Pre-Qualified Supplier List";
                    }

                    action(ProcurementMethodsSetup)
                    {
                        ApplicationArea = All;
                        Caption = 'Procurement Methods';
                        RunObject = page "Procurement Methods List";
                    }

                    action(ProcurementTypes)
                    {
                        ApplicationArea = All;
                        Caption = 'Procurement Types';
                        RunObject = page "Procurement Types";
                    }
                    action(ProcurementSubTypes)
                    {
                        ApplicationArea = All;
                        Caption = 'Procurement Sub Types';
                        RunObject = page "Procurement Sub Types";
                    }
                    action(DimensionHeads)
                    {
                        ApplicationArea = All;
                        Caption = 'Dimension Heads';
                        RunObject = page "Dimension Heads";
                    }
                    action(CommitteeSetups)
                    {
                        ApplicationArea = All;
                        Caption = 'Committee Setups';
                        RunObject = page "Procurement Committee Setup";
                    }
                    action(EvaluationRequirements)
                    {
                        ApplicationArea = All;
                        Caption = 'Evaluation Requirements';
                        RunObject = page "Evaluation Requirement Setup";
                    }
                }
                group(ProcurementPlan)
                {
                    Caption = 'Procurement Plan';
                    group(PlanApplication)
                    {
                        caption = 'Procurement Plan Application';
                        Action(ProcurementPlanOpen)
                        {
                            ApplicationArea = All;
                            Caption = 'Procurement Plan List - Open';
                            RunObject = page "Procurement  Plan List";
                        }
                        Action(ProcurementPlansPending)
                        {
                            ApplicationArea = All;
                            Caption = 'Procurement Plan List - Pending Approval';
                            RunObject = page "Procurement Plans - Pending";
                        }
                        Action(ProcurementPlanApproved)
                        {
                            ApplicationArea = All;
                            Caption = 'Procurement Plan List - Approved';
                            RunObject = page "Procurement Plans - Approved";
                        }
                        Action(ProcurementPlanRejected)
                        {
                            ApplicationArea = All;
                            Caption = 'Procurement Plan List - Rejected';
                            RunObject = page "Procurement Plans - Rejected";
                        }
                    }
                    Group(SubmittedPlans)
                    {
                        caption = 'Submitted Plans';
                        action(SubmittedPlan_)
                        {
                            ApplicationArea = All;
                            Caption = 'Submitted Procurement Plans';
                            RunObject = page "Submitted Procurement Plans";
                        }
                        action(SubmittedPlanCEO)
                        {
                            ApplicationArea = All;
                            Caption = 'Submitted Procurement Plans - CEO';
                            RunObject = page "Submitted Plans - CEO's Desk";
                        }
                        action(SubmittedPlanApproved)
                        {
                            ApplicationArea = All;
                            Caption = 'Submitted Procurement Plans - Approved';
                            RunObject = page "Submitted Plans - DG Approved";
                        }
                    }

                }
                group(Requisitions)
                {
                    caption = 'Requisitions';
                    //Image = RegisteredDocs;
                    group(PurchaseRequisitions)
                    {
                        Caption = 'Purchase Requisition';
                        //Image = reg
                        action(OpenPurchReqList)
                        {
                            ApplicationArea = All;
                            Caption = 'Purchase Requisition List - Open';
                            RunObject = page "Purchase Requisition List";
                        }
                        action(PendingPurchReqList)
                        {
                            ApplicationArea = All;
                            Caption = 'Purchase Requisition List - Pending Approval';
                            RunObject = page "Purch Requisition List-Pending";
                        }
                        action(ApprovedPurchReqList)
                        {
                            ApplicationArea = All;
                            Caption = 'Purchase Requisition List - Approved';
                            RunObject = page "Purch Requisition List-Approve";
                        }

                    }
                    group(StoreRequisitions)
                    {
                        Caption = 'Store Requisition';
                        //Image = reg
                        action(StoreReqListOpen)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Requisition List - Open';
                            RunObject = page "Store Requisition List - Open";
                        }
                        action(StoreReqListPending)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Requisition List - Pending Approval';
                            RunObject = page "Store Requisition List - Pend";
                        }
                        action(StoreReqListApproved)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Requisition List - Approved';
                            RunObject = page "Store Requisition List - Appr";
                        }
                        action(StoreReqListPendingReturn)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Requisition List - Pending Return';
                            RunObject = page "Store Requisitions - To Return";
                        }
                        action(StoreReqListIssued)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Requisition List - Issued';
                            RunObject = page "Issued Store Requisitions";
                        }
                        action(StoreReqListRejected)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Requisition List - Rejected';
                            RunObject = page "Store Req. List - Rejected";
                        }
                    }

                }

                group(ProcurementMethods)
                {
                    caption = 'Procurement Methods';
                    //Image = RegisteredDocs;
                    group(DirectProc)
                    {
                        Caption = 'Direct Procurement';
                        action(DP_New)
                        {
                            ApplicationArea = All;
                            Caption = 'Direct Procurement List - New';
                            RunObject = Page "Direct Procurement List - New";
                        }
                        action(DP_Released)
                        {
                            ApplicationArea = All;
                            Caption = 'Direct Procurement List - Released';
                            RunObject = Page "Direct Procurement List - Rele";
                        }
                        action(DP_Posted)
                        {
                            ApplicationArea = All;
                            Caption = 'Direct Procurement List - Posted';
                            RunObject = Page "Direct Procurement List - Post";
                        }
                    }
                    Group(LowValue)
                    {
                        Caption = 'Low Value Procurement';
                        action(NewLowValueProc)
                        {
                            ApplicationArea = All;
                            Caption = 'Low Value Procurement - Open';
                            RunObject = page "Low Value Procurement - New";
                        }
                        action(ReleasedLowValueProc)
                        {
                            ApplicationArea = All;
                            Caption = 'Low Value Procurement - Released';
                            RunObject = page "Low Value Procurement - Releas";
                        }
                        action(PostedLowValueProc)
                        {
                            ApplicationArea = All;
                            Caption = 'Low Value Procurement - Posted';
                            RunObject = page "Low Value Proc. List - Posted";
                        }
                    }
                    group(RFQ)
                    {
                        Caption = 'Request For Quotation';
                        action(RFQListNew)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Quotation List - New';
                            RunObject = page "RFQ List - New";
                        }
                        action(RFQListOpening)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Quotation List - Opening';
                            RunObject = page "RFQ List - Opening Stage";
                        }
                        action(RFQListEvaluation)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Quotation List - Evaluation';
                            RunObject = page "RFQ List - Evaluation Stage";
                        }
                        action(RFQListProcManager)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Quotation List - Procurement Manager';
                            RunObject = page "Evaluated RFQ List-Proc";
                        }
                        action(RFQListCEO)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Quotation List - CEO';
                            RunObject = page "Evaluated RFQ List - Approved";
                        }
                        action(RFQListPendingLPO)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Quotation List - Pending LPO';
                            RunObject = page "RFQ List - Pending LPO";
                        }
                        action(RFQListPosted)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Quotation List - Posted';
                            RunObject = page "RFQ List - Posted";
                        }
                    }
                    group(RFP)
                    {
                        Caption = 'Request For Proposal';
                        action(RFPListNew)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Proposal List - New';
                            RunObject = page "Request For Proposal List- New";
                        }
                        action(RFPListEOI)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Proposal List- EOI';
                            RunObject = page "Request For Proposal List- EOI";
                        }
                        action(RFPListOpening)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Proposal List - Opening';
                            RunObject = page "RFP List - Opening Stage";
                        }
                        action(RFPListEvaluation)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Proposal List - Evaluation';
                            RunObject = page "RFP List - Evaluation Stage";
                        }
                        action(RFPListProcManager)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Proposal List - Procurement Manager';
                            RunObject = page "Evaluated RFP List-Proc";
                        }
                        action(RFPListCEO)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Proposal List - CEO';
                            RunObject = page "Evaluated RFP List - Approved";
                        }
                        action(RFPListPendingLPO)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Proposal List - Pending LPO';
                            RunObject = page "RFP List - Pending LPO";
                        }
                        action(RFPListPosted)
                        {
                            ApplicationArea = All;
                            Caption = 'Request For Proposal List - Posted';
                            RunObject = page "RFP List - Posted";
                        }
                    }
                    group(OpenTender)
                    {
                        Caption = 'Open Tender';
                        action(OpenTenderNew)
                        {
                            ApplicationArea = All;
                            Caption = 'Open Tender List- New';
                            RunObject = page "Open Tender List - New";
                        }
                        action(OpenTenderOpening)
                        {
                            ApplicationArea = All;
                            Caption = 'Open Tender List- Opening';
                            RunObject = page "Open Tender List - Opening";
                        }
                        action(OpenTenderEvaluation)
                        {
                            ApplicationArea = All;
                            Caption = 'Open Tender List- Evaluation';
                            RunObject = page "Open Tender List - Evaluation";
                        }
                        action(OpenTenderProcManager)
                        {
                            ApplicationArea = All;
                            Caption = 'Open Tender List - Procurement Manager';
                            RunObject = page "Open Tender List - Procurement";
                        }
                        action(OpenTenderCEO)
                        {
                            ApplicationArea = All;
                            Caption = 'Open Tender - CEO Approved';
                            RunObject = page "Open Tender List- CEO Approved";
                        }
                        action(OpenTenderPendingContract)
                        {
                            ApplicationArea = All;
                            Caption = 'Open Tender List - Pending Contract';
                            RunObject = page "Open Tender List- Pend. Contra";
                        }
                        action(OpenTenderContract)
                        {
                            ApplicationArea = All;
                            Caption = 'Open Tender List - Contract List';
                            RunObject = page "Open Tender List- Contracts";
                        }
                        action(OpenTenderPosted)
                        {
                            ApplicationArea = All;
                            Caption = 'Open Tender - New';
                            RunObject = page "Open Tender List- Posted";
                        }
                    }
                    group(RestrTender)
                    {
                        Caption = 'Restricted Tender';
                        action(RestrictedTenderNew)
                        {
                            ApplicationArea = All;
                            Caption = 'Restricted Tender List- New';
                            RunObject = page "Restricted Tender List - New";
                        }
                        action(RestrictedTenderOpening)
                        {
                            ApplicationArea = All;
                            Caption = 'Restricted Tender List- Opening';
                            RunObject = page "Restr. Tender List - Opening";
                        }
                        action(RestrictedTenderEvaluation)
                        {
                            ApplicationArea = All;
                            Caption = 'Restricted Tender List- Evaluation';
                            RunObject = page "Restr. Tender List- Evaluation";
                        }
                        action(RestrictedTenderProcManager)
                        {
                            ApplicationArea = All;
                            Caption = 'Restricted Tender List - Procurement Manager';
                            RunObject = page "Restr. Tender List- Proc. Mgr";
                        }
                        action(RestrictedTenderCEO)
                        {
                            ApplicationArea = All;
                            Caption = 'Restricted Tender - CEO Approved';
                            RunObject = page "Restr. Tender List-CEO Appr.";
                        }
                        action(RestrictedTenderPendingContract)
                        {
                            ApplicationArea = All;
                            Caption = 'Restricted Tender List - Pending Contract';
                            RunObject = page "Restr. Tender List- Pend. Con";
                        }
                        action(RestrictedTenderContract)
                        {
                            ApplicationArea = All;
                            Caption = 'Restricted Tender List - Contract List';
                            RunObject = page "Restr. Tender List- Contracts";
                        }
                        action(RestrictedTenderPosted)
                        {

                            ApplicationArea = All;
                            Caption = 'Restricted Tender - New';
                            RunObject = page "Restr. Tender List- Contracts";
                        }
                    }
                    group(Contracts)
                    {
                        Caption = 'Procurement Contracts';
                        action(ProcContracts)
                        {
                            Caption = 'Procurement Contracts';
                            RunObject = page "Procurement Contract List";
                        }
                    }
                }
                group(StoresMgt)
                {
                    caption = 'Stores Management';
                    //Image = RegisteredDocs;
                    /*                     group(Stores_Requisitions)
                                        {
                                            Caption = 'Store Requisitions';
                                            action(Test_)
                                            {

                                            }
                                        } 
                    */
                    group(StoresIssuance)
                    {
                        Caption = 'Store Issuance';
                        action(ReleasedStoresReq)
                        {
                            ApplicationArea = All;
                            Caption = 'Released Store Requisitions';
                            RunObject = page "Store Requisition List - Appr";
                        }
                        action(IssuedStoresReq)
                        {
                            ApplicationArea = All;
                            Caption = 'Issued Store Requisitions';
                            RunObject = page "Issued Store Requisitions";
                        }
                    }
                    group(StoreReturn)
                    {
                        Caption = 'Store Return';
                        action(StoreReturnListOpen)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Return List - Open';
                            RunObject = page "Store Return List - Open";
                        }
                        action(StoreReturnListPending)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Return List - Pending';
                            RunObject = page "Store Return List - Pending";
                        }
                        action(StoreReturnListAppr)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Return List - Approved';
                            RunObject = page "Store Return List - Approved";
                        }
                        action(StoreReturnListReturned)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Return List - Returned';
                            RunObject = page "Store Return List - Returned";
                        }
                        action(StoreReturnListRejected)
                        {
                            ApplicationArea = All;
                            Caption = 'Store Return List - Rejected';
                            RunObject = page "Store Return List - Rejected";
                        }
                    }
                    group(InventoryCosting)
                    {
                        caption = 'Inventory & Costing';
                        //Image = RegisteredDocs;
                        action(Items)
                        {
                            ApplicationArea = All;
                            Caption = 'Items';
                            RunObject = Page "Item List";
                        }
                        action(ItemJnl)
                        {
                            ApplicationArea = All;
                            Caption = 'Item Journal';
                            RunObject = Page "Item Journal";
                        }
                    }

                }
                group(OrderProcessing)
                {
                    Caption = 'Order Processing';
                    action(OrderReq)
                    {
                        ApplicationArea = All;
                        Caption = 'Order List';
                        RunObject = page "Purchase Order List";
                    }
                    action(PurchInv)
                    {
                        ApplicationArea = All;
                        Caption = 'Purchase Invoices';
                        RunObject = page "Purchase Invoices";
                    }
                }
                group(Reports)
                {
                    Caption = 'Procurement Reports';
                    action(StoreReq)
                    {
                        ApplicationArea = All;
                        Caption = 'Store Requisitions';
                        RunObject = report "Store Requisitions Report";
                    }
                    action(PurchReq)
                    {
                        ApplicationArea = All;
                        Caption = 'Purchase Requisitions';
                        RunObject = report "Purchase Requisitions Report";
                    }
                    action(StoreRet)
                    {
                        ApplicationArea = All;
                        Caption = 'Stores Return';
                        RunObject = report "Stores Return Report";
                    }
                    action(StoreIssuance)
                    {
                        ApplicationArea = All;
                        Caption = 'Store Issuance';
                        RunObject = report "Store Issuance Report";
                    }
                    action(ItemList)
                    {
                        ApplicationArea = All;
                        Caption = 'Item List';
                        RunObject = report "Item - List";
                    }
                    action(GoodsReceived)
                    {
                        ApplicationArea = All;
                        Caption = 'Good Received Report';
                        RunObject = report "Goods Received Report";
                    }
                    action(RFQ_)
                    {
                        ApplicationArea = All;
                        caption = 'Request For Quotation';
                        RunObject = report "Request for Quotation";
                    }
                }
                group(Workflows_)
                {
                    Caption = 'Workflows';
                    action(Workflows)
                    {
                        ApplicationArea = All;
                        Caption = 'Workflows';
                        RunObject = page Workflow;
                    }
                    action(Templates)
                    {
                        ApplicationArea = All;
                        Caption = 'Workflow Templates';
                        RunObject = page "Workflow Templates";
                    }
                    action(TableRelations)
                    {
                        ApplicationArea = All;
                        Caption = 'Workflow Table Relations';
                        RunObject = page "Workflow - Table Relations";
                    }
                    action(EventHierarchy)
                    {
                        ApplicationArea = All;
                        Caption = 'Workflow Event Hierarchy';
                        RunObject = page "Workflow Event Hierarchies";
                    }
                    action(EventCombinations)
                    {
                        ApplicationArea = All;
                        Caption = 'Workflow Event/Response Combination';
                        RunObject = page "WF Event/Response Combinations";
                    }
                    action(UserGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Workflow User Groups';
                        RunObject = page "Workflow User Groups";
                    }
                }

            }
        }
        area(Embedding)
        {
            action(ProcurementPlans)
            {
                Caption = 'Procurement Plans';
                RunObject = Page "Procurement Plans - Approved";
                ApplicationArea = All;

            }
            action(Purchase_Requisitions)
            {
                Caption = 'Purchase Requisitions';
                RunObject = page "Purch Requisition List-Approve";
                ApplicationArea = All;
            }
            action(Store_Requisitions)
            {
                Caption = 'Store Requisitions';
                RunObject = page "Store Requisition List - Appr";
                ApplicationArea = All;
            }
            action(Store_Return)
            {
                Caption = 'Stores Return';
                RunObject = page "Store Return List - Approved";
                ApplicationArea = All;
            }
        }
        area(Creation)
        {
            action(NewProcurementPlan)
            {
                Caption = 'New Procurement Plan';
                Image = NewInvoice;
                RunObject = Page "Procurement  Plan List";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(PurchaseReq)
            {
                Caption = 'New Purchase Requisition';
                Image = NewInvoice;
                RunObject = Page "Purchase Requisition List";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(Store_Req)
            {
                Caption = 'New Store Requisition';
                Image = NewInvoice;
                RunObject = Page "Store Requisition List - Open";
                RunPageMode = Create;
                ApplicationArea = All;
            }
        }

    }

}

profile Procurement
{
    Caption = 'Procurement Profile';
    RoleCenter = "Procurement RoleCenter";
    ProfileDescription = 'Sample Profile';
}