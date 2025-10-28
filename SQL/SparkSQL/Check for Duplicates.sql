%%sql

-- Unit table
SELECT UNIT_NUMBER, COUNT(*) 
FROM Research_PBI_RS.RIT_RS_Source_Lakehouse.kr.unit
GROUP BY UNIT_NUMBER
HAVING COUNT(*) > 1;

-- Sponsor table
SELECT SPONSOR_CODE, COUNT(*)
FROM RIT_RS_Reporting_Lakehouse.kr.sponsor
GROUP BY SPONSOR_CODE
HAVING COUNT(*) > 1;