-- Extracts text before the @ symbol

LEFT(column_name, CHARINDEX('@', column_name) - 1) AS column_name