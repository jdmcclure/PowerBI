// Originating from a table where I needed to calculate the number of days until
// compliance training is due.

Days_to_expiration = Table.AddColumn(
    Expiration_date,  // Reference the step before
    "EXPIRING_DAYS",  // Name the new column
    each try    // For each row, try the below steps
        if Duration.Days([EXPIRATION_DATE] - DateTime.Date(DateTime.LocalNow())) >= 0   // If the number of days between now and the expiration date is greater than or equal to 0
        then Duration.Days([EXPIRATION_DATE] - DateTime.Date(DateTime.LocalNow()))    // Then calculate the date difference
        else null   // Otherwise return null, because we are only interested in calculating dates that have not passed
    otherwise null,   // End the try statement by returning null if there is an error (i.e. - calculation cannot be done due to a null)
    Int64.Type    // Set the column type as a whole number
)

// And here without all of the comments

Days_to_expiration = Table.AddColumn(
        Expiration_date,
        "EXPIRING_DAYS",
        each try 
            if Duration.Days([EXPIRATION_DATE] - DateTime.Date(DateTime.LocalNow())) >= 0 
            then Duration.Days([EXPIRATION_DATE] - DateTime.Date(DateTime.LocalNow())) 
            else null 
        otherwise null,
        Int64.Type
    ),