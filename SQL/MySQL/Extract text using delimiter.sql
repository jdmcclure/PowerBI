-- Extract everything before the @ symbol.

SUBSTRING_INDEX(column_name, '@', 1) AS column_name