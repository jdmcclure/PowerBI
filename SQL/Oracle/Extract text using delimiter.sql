-- Extract text before the @ symbol

SUBSTR(column_name, 1, INSTR(column_name, '@') - 1) AS column_name