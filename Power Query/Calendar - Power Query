// Create a calendar table within Power Query. Great for Dataflows/Lakehouses.
// Modify the first two steps depending on the range needed.
let
    //1 Set a minimum date of Jan 1 of todays year - 25
    StartDate = #date(2001, 1, 1),
    //2 Set a maximum date to December 31 in todays year + 5
    EndDate = Date.EndOfYear(Date.AddYears(Date.From(DateTime.FixedLocalNow()), 5)),
    //3 Calculate the number of days
    NumberOfDays = Duration.Days(EndDate - StartDate),
    //4 Insert the dates into a list in 1 day increments. #duration(days,hours,mins,secs)
    Source = List.Dates(StartDate, NumberOfDays + 1, #duration(1, 0, 0, 0)),
    //5 Convert the list of dates into a table
    Convert_to_table = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    //6 Renamed the auto-generated name Column1 to Date
    Renamed_column = Table.RenameColumns(Convert_to_table, {{"Column1", "Date"}}),
    //7 Changed Date into a date type
    Changed_type = Table.TransformColumnTypes(Renamed_column, {{"Date", type date}}),
    //8 Added calendar year column
    Year = Table.AddColumn(Changed_type, "CY Year", each Date.Year([Date]), Int64.Type),
    //9: Insert a fiscal year column that starts July 1
    Fiscal_year = Table.AddColumn(Year, "FY Year", each Date.Year(Date.AddMonths([Date], 6)), Int64.Type),
    //10: Insert a short cy column for the calendar year
    Short_CY = Table.AddColumn(
        Fiscal_year, "CY Short", each Text.PadStart(Text.End(Text.From([FY Year]), 2), 2, "0"), type text
    ),
    //11 Insert a short fy column for the fiscal year
    Short_FY = Table.AddColumn(
        Short_CY, "FY Short", each Text.PadStart(Text.End(Text.From([FY Year]), 2), 2, "0"), type text
    ),
    //12 Insert a month column based on the calendar year for sorting the CY Month column
    CY_month_num = Table.AddColumn(Short_FY, "CY Month Num", each Date.Month([Date]), Int64.Type),
    //13 Insert a month name column
    CY_month = Table.AddColumn(CY_month_num, "CY Month", each Date.ToText([Date], "MMM"), type text),
    //14 Added a month-year column based on calendar year
    CY_month_year = Table.AddColumn(CY_month, "CY Month Year", each Date.ToText([Date], "MMM-yy"), Text.Type),
    //15 Added a sort column for the CY Month Year
    CY_month_year_num = Table.AddColumn(
        CY_month_year, "CY Month Year Num", each Date.Year([Date]) * 100 + Date.Month([Date]), Int64.Type
    ),
    //16 Added a fiscal month sort column to sort the FY Month column
    FY_month_num = Table.AddColumn(
        CY_month_year_num,
        "FY Month Num",
        each if Date.Month([Date]) >= 7 then Date.Month([Date]) - 6 else Date.Month([Date]) + 6,
        Int64.Type
    ),
    //17 Added a fiscal period 2-digit column
    FY_period = Table.AddColumn(
        FY_month_num,
        "Fiscal Period",
        each
            if [FY Month Num] < 10 then
                Text.Combine({"0", Text.From([FY Month Num], "en-US")})
            else
                Text.From([FY Month Num], "en-US"),
        Text.Type
    ),
    //18 Added a fiscal month column. Be sure to sort by "FY Month Sort" and not "CY Month Sort" column
    FY_month = Table.AddColumn(FY_period, "FY Month", each Date.ToText([Date], "MMM"), Text.Type),
    //19 Added a Federal Fiscal Year column
    Federal_FY = Table.AddColumn(
        FY_month, "Federal Fiscal Year", each Date.Year(Date.AddMonths([Date], 3)), Int64.Type
    ),
    //20 Added a week of year column
    Week_of_year = Table.AddColumn(Federal_FY, "Week of Year", each Date.WeekOfYear([Date]), Int64.Type),
    //21 Added day of week sort column to sort the Day of Week column
    Day_of_week_num = Table.AddColumn(Week_of_year, "Day of Week Num", each Date.DayOfWeek([Date]), Int64.Type),
    //22 Added Day of Week column
    Day_of_week = Table.AddColumn(
        Day_of_week_num, "Day of Week", each Text.Middle(Date.DayOfWeekName([Date]), 0, 3), Text.Type
    ),
    //23 Added Day of Year column
    Day_of_year = Table.AddColumn(Day_of_week, "Day of Year", each Date.DayOfYear([Date]), Int64.Type),
    //24 Added a weekend flag
    Is_weekday = Table.AddColumn(
        Day_of_year,
        "Is Weekday",
        each if [Day of Week Num] = 6 then false else if [Day of Week Num] = 0 then false else true,
        Logical.Type
    ),
    //25 Add a flag for the last 5 and current fiscal year. Choose true in a filter to show only the last 5 fiscal years.
    CurrentDate = DateTime.LocalNow(),
    CurrentFY = if Date.Month(CurrentDate) >= 7 then Date.Year(CurrentDate) + 1 else Date.Year(CurrentDate),
    Last_5_and_current_fy = Table.AddColumn(
        Is_weekday,
        "Last 5 and Current FY",
        each if [FY Year] >= CurrentFY - 5 and [FY Year] <= CurrentFY then true else false,
        Logical.Type
    ),
    //26 Add calendar year quarter
    CY_quarter = Table.AddColumn(
        Last_5_and_current_fy, "CY Quarter", each "Q" & Text.From(Number.RoundUp(Date.Month([Date]) / 3, 0)),
        Text.Type
    ),
    //27 Add fiscal year quarter
    FY_quarter = Table.AddColumn(
        CY_quarter,
        "FY Quarter",
        each
            if Date.Month([Date]) = 7 or Date.Month([Date]) = 8 or Date.Month([Date]) = 9 then
                "Q1"
            else if Date.Month([Date]) = 10 or Date.Month([Date]) = 11 or Date.Month([Date]) = 12 then
                "Q2"
            else if Date.Month([Date]) = 1 or Date.Month([Date]) = 2 or Date.Month([Date]) = 3 then
                "Q3"
            else
                "Q4",
        Text.Type
    ),
    //28 Add calendar year quarter number for sorting
    CY_quarter_num = Table.AddColumn(
        FY_quarter, "CY Quarter Num", each Number.RoundUp(Date.Month([Date]) / 3, 0), Int64.Type
    ),
    //29 Add fiscal year quarter number for sorting
    FY_quarter_num = Table.AddColumn(
        CY_quarter_num,
        "FY Quarter Num",
        each
            if Date.Month([Date]) = 7 or Date.Month([Date]) = 8 or Date.Month([Date]) = 9 then
                1
            else if Date.Month([Date]) = 10 or Date.Month([Date]) = 11 or Date.Month([Date]) = 12 then
                2
            else if Date.Month([Date]) = 1 or Date.Month([Date]) = 2 or Date.Month([Date]) = 3 then
                3
            else
                4,
        Int64.Type
    ),
    //30 Add fiscal year month year column
    FY_month_year = Table.AddColumn(
        FY_quarter_num, "FY Month Year", each [FY Month] & "-" & Text.From([FY Short]), type text
    ),
    //31 Add fiscal year month year sort column
    FY_month_year_num = Table.AddColumn(
        FY_month_year, "FY Month Year Num", each [FY Year] * 100 + [FY Month Num], Int64.Type
    ),
    //32 Fiscal year quarter and year column
    FY_quarter_year = Table.AddColumn(
        FY_month_year_num, "FY Quarter Year", each [FY Quarter] & "-" & [FY Short], type text
    ),
    //33 Fiscal year quarter and year sort column
    FY_quarter_year_num = Table.AddColumn(
        FY_quarter_year, "FY Quarter Year Num", each Number.FromText([FY Short]) * 10 + [FY Quarter Num], Int64.Type
    ),
    //34 Calendar year quarter and year column
    CY_quarter_year = Table.AddColumn(
        FY_quarter_year_num, "CY Quarter Year", each [CY Quarter] & "-" & [CY Short], type text
    ),
    //35 Calendar year quarter and year sort column
    CY_quarter_year_num = Table.AddColumn(
        CY_quarter_year, "CY Quarter Year Num", each Number.FromText([CY Short]) * 10 + [CY Quarter Num], Int64.Type
    )
in
    CY_quarter_year_num