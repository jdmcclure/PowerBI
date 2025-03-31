let
    // Source is OSP Lakehouse
    Source = Sql.Database("Database", "Schema"),
    // Get the minimum and maximum dates from other tables in query
    MinDate = List.Min(negotiation[NEGOTIATION_START_DATE]),
    MaxDate = List.Max(negotiation_activity[END_DATE]),
    // Pull in the calendar table from the OSP Lakehouse
    dbo_calendar = Source{[Schema = "dbo", Item = "calendar"]}[Data],
    // Filter the calendar table to pull in only required number of rows
    filtered_calendar = Table.SelectRows(dbo_calendar, each [Date] >= MinDate and [Date] <= MaxDate)
in
    filtered_calendar
