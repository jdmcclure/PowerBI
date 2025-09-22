CREATE OR REPLACE TEMP VIEW pi_concat AS
    SELECT
        KEY_ID,
        concat_ws("; ", collect_set(PERSON_FULL_NM)) AS PRIMARY_INVESTIGATORS
    FROM Research_PBI_RS.RIT_RS_Source_Lakehouse.vprprod.AWARD_HIST_PIS
    GROUP BY KEY_ID;