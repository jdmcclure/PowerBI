let
    Source = Json.Document(
        Web.Contents("http://worldtimeapi.org/api/timezone/America/Denver")),

    Converted_to_table = Record.ToTable(Source),

    Filtered_rows = Table.SelectRows(
        Converted_to_table, 
        each ([Name] = "datetime")
    ),
    
    Removed_columns = Table.RemoveColumns(
        Filtered_rows,
        {"Name"}
    ),
    
    Changed_type = Table.TransformColumnTypes(
        Removed_columns,
        {
            {"Value", type datetimezone}
        }
    ),
    
    Renamed_columns = Table.RenameColumns(
        Changed_type,
        {
            {"Value", "America/Denver"}
        }
    )
    
in
    Renamed_columns