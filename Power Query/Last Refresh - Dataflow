let
    Refresh_datetime = DateTime.FixedLocalNow(),
    Converted_to_table = #table({"America/Denver"}, {{Refresh_datetime}}),
    Changed_type = Table.TransformColumnTypes(Converted_to_table, {{"America/Denver", type datetime}})
in
    Changed_type