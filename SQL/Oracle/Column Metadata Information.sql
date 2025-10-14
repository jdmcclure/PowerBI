SELECT
    column_name,
    data_type,
    data_length,
    char_used

FROM
    all_tab_columns

WHERE
    table_name == "ORS.AWARD_HIST";