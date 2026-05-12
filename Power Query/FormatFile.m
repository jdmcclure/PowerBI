let
    Source = Sql.Database(
        "akelll3276yuxkzbgz77f3h4rm-72oyib2nkaiubetlsrpjb3yyme.datawarehouse.fabric.microsoft.com", 
        "RIT_RS_Reporting_Lakehouse"
    ),

    eps_proposal = Source{[Schema="dbo",Item="eps_proposal"]}[Data],

    Changed_type = Table.TransformColumnTypes(
        eps_proposal,
        {
            {"PROJECT_START_DATE", type date}, 
            {"PROJECT_END_DATE", type date}
        }
    ),

    Merged_sponsor = Table.NestedJoin(
        Changed_type, 
        {"SPONSOR_CODE"}, sponsor, 
        {"SPONSOR_CODE"}, "SPONSOR", 
        JoinKind.LeftOuter
    ),

    Expanded_sponsor = Table.ExpandTableColumn(
        Merged_sponsor, 
        "SPONSOR", 
        {"SPONSOR_NAME"}, 
        {"SPONSOR_NAME"}
    ),

    Merged_prime_sponsor = Table.NestedJoin(
        Expanded_sponsor, 
        {"PRIME_SPONSOR_CODE"}, sponsor, 
        {"SPONSOR_CODE"}, "SPONSOR", 
        JoinKind.LeftOuter
    ),

    Expanded_prime_sponsor = Table.ExpandTableColumn(
        Merged_prime_sponsor, 
        "SPONSOR", 
        {"SPONSOR_NAME"}, 
        {"SPONSOR_NAME_PRIME"}
    ),

    Removed_columns = Table.RemoveColumns(
        Expanded_prime_sponsor,
        {
            "IS_HIERARCHY", 
            "UPDATE_TIMESTAMP", 
            "DEADLINE_DATE", 
            "SUBMIT_FLAG", 
            "DEADLINE_TYPE", 
            "HIERARCHY_PROPOSAL_NUMBER", 
            "ACTIVITY_TYPE_CODE", 
            "NARRATIVE_STATUS", 
            "NSF_SEQUENCE_NUMBER", 
            "SPONSOR_PROPOSAL_NUMBER", 
            "DOCUMENT_NUMBER", 
            "PROPOSAL_TYPE_CODE", 
            "STATUS_CODE", 
            "BASE_PROPOSAL_NUMBER", 
            "ORGANIZATION_ID", 
            "AGENCY_ROUTING_IDENTIFIER", 
            "PROGRAM_ANNOUNCEMENT_NUMBER", 
            "PROGRAM_ANNOUNCEMENT_TITLE", 
            "CONTINUED_FROM", 
            "INST_PROP_CREATE_DATE", 
            "SUBMISSION_TYPE", 
            "ACTION_NEEDED_BY", 
            "ROUTING_STATUS", 
            "SUBMITTED_BY", 
            "SUBMITTED_TO_ROUTING_DATE", 
            "IP_STATUS", 
            "PERSONS_ASSOCIATED", 
            "INST_PROP_CREATE_USER", 
            "ASSOCIATED_AWARDS_AND_ACCOUNTS", 
            "ASSOCIATED_NEGOTIATIONS", 
            "LAST_UPDATED_BY", 
            "PRIME_SPONSOR_CODE", 
            "SPONSOR_CODE",
            "CURRENT_ACCOUNT_NUMBER",
            "CURRENT_AWARD_NUMBER",
            "BUDGET_APPROVAL_DATE", 
            "ON_OFF_CAMPUS", 
            "TOTAL_COST", 
            "TOTAL_DIRECT_COST", 
            "TOTAL_INDIRECT_COST", 
            "FA_RATE", 
            "RATE_CLASS", 
            "COUNT_RECALLS", 
            "COUNT_RETURNS"
        }
    ),

    Changed_type = Table.TransformColumnTypes(
        Removed_columns,
        {
            {"FINALIZED_DATE", type date}
        }
    )

in
    Changed_type