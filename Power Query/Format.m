let
    Source = Oracle.Database("dbodsprod.is.colostate.edu:1521/odsprod.infosys.colostate.edu", [HierarchicalNavigation=true]),

    CSUSR = Source{[Schema="CSUSR"]}[Data],

    CSUV_RPS_ACCOUNTING_SUMMARY1 = CSUSR{[Name="CSUV_RPS_ACCOUNTING_SUMMARY"]}[Data],

    Filtered_rows = Table.SelectRows(
        CSUV_RPS_ACCOUNTING_SUMMARY1, 
        each 
            Text.StartsWith([ACCOUNT_NBR], "53")
        ),

    Added_cost_type_column = Table.AddColumn(
        Filtered_rows, 
        "COST_TYPE", 
        each 
            if [BUDGET_FIN_OBJ_CD_NM] = "Indirect Cost Recovery" then "F&A" 
            else if [BUDGET_FIN_OBJ_CD_NM] = "Subcontractors" then "Subrecipients" 
            else "Direct Cost"
        ),

    Added_balance_amount_column = Table.AddColumn(
        Added_cost_type_column, 
        "Balance Amount", 
        each 
            if [BALANCE_AMT] >= 1000 then "Additional Work" 
            else "Completed"
        ),

    Added_cost_category_column = Table.AddColumn(
        Added_balance_amount_column, 
        "Cost Category", 
        each 
            if [BUDGET_FIN_OBJ_CD_NM] = "Personnel" then "Personnel" 
            else if [BUDGET_FIN_OBJ_CD_NM] = "Indirect Cost Recovery" then "F&A" 
            else "Other Direct Cost"
        ),

    Added_sort_column = Table.AddColumn(
        Added_cost_category_column,
        "Sort by Cost Category", 
        each 
            if [Cost Category] = "Personnel" then 1 
            else if [Cost Category] = "F&A" then 3 
            else 2
    )
    
in
    Added_sort_column