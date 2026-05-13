let
    // Connect to the OSP Lakehouse in the Fabric data warehouse
    Source = Sql.Database(
        "akelll3276yuxkzbgz77f3h4rm-m4untwscfssuzktaacrwgt2faq.datawarehouse.fabric.microsoft.com",
        "OSP_Lakehouse"
    ),

    // Pull the award table from the dbo schema
    dbo_award = Source{[Schema = "dbo", Item = "award"]}[Data],

    // Join award to sponsor lookup on SPONSOR_CODE
    Merged_sponsor = Table.NestedJoin(
        dbo_award, {"SPONSOR_CODE"},
        SPONSOR, {"SPONSOR_CODE"},
        "sponsor",
        JoinKind.LeftOuter
    ),

    // Expand sponsor name and type from the nested join
    Expanded_sponsor = Table.ExpandTableColumn(
        Merged_sponsor,
        "sponsor",
        {"SPONSOR_NAME", "SPONSOR_TYPE_DESCRIPTION"},
        {"SPONSOR_NAME", "SPONSOR_TYPE"}
    ),

    // Join award to sponsor lookup again on PRIME_SPONSOR_CODE
    Merged_prime_sponsor = Table.NestedJoin(
        Expanded_sponsor, {"PRIME_SPONSOR_CODE"},
        SPONSOR, {"SPONSOR_CODE"},
        "sponsor",
        JoinKind.LeftOuter
    ),

    // Expand prime sponsor name from the nested join
    Expanded_prime_sponsor = Table.ExpandTableColumn(
        Merged_prime_sponsor,
        "sponsor",
        {"SPONSOR_NAME"},
        {"sponsor.SPONSOR_NAME.1"}
    ),

    // Rename expanded columns to final readable names
    Renamed_columns = Table.RenameColumns(
        Expanded_prime_sponsor,
        {
            {"sponsor.SPONSOR_NAME.1", "PRIME_SPONSOR_NAME"},
            {"sponsor.SPONSOR_NAME", "SPONSOR_NAME"}
        }
    ),

    // Keep only the columns needed for downstream reporting
    Removed_other_columns = Table.SelectColumns(
        Renamed_columns,
        {
            "AWARD_ID",
            "TITLE",
            "AWARD_NUMBER",
            "LEAD_UNIT_NUMBER",
            "AWARD_STATUS",
            "ACCOUNT_NUMBER",
            "PROJECT_START_DT",
            "PROJECT_END_DT",
            "SPONSOR_AWARD_NUMBER",
            "AWARD_SEQUENCE_STATUS",
            "AWARD_NUMBER_ROOT",
            "OBLIGATED_AMOUNT",
            "SPONSOR_NAME",
            "PRIME_SPONSOR_NAME"
        }
    ),

    // Exclude awards with no account number
    Filtered_rows = Table.SelectRows(
        Removed_other_columns,
        each ([ACCOUNT_NUMBER] <> null and [ACCOUNT_NUMBER] <> "")
    )
in
    Filtered_rows
