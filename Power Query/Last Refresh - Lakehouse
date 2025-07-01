let
    // Source is OSP Lakehouse
    Source = Sql.Database(
        "database-url", 
        "OSP_Lakehouse"
    ),

    // Navigate to schema and table
    Dbo_last_refresh = Source{[Schema="schema",Item="table_name"]}[Data],

    // Renamed column to "America/Denver"
    Renamed_column = Table.RenameColumns(
        dbo_last_refresh,
        {
            {"Last_Refresh", "America/Denver"}
        }
    )

in
    Renamed_column