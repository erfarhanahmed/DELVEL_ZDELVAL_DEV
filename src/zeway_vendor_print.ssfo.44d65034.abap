

SELECT SINGLE * FROM kna1 INTO gv_kna1 WHERE kunnr = ship_to.

SELECT SINGLE * FROM adrc INTO gv_adrc WHERE
                ADDRNUMBER = gv_kna1-ADRNR.
CONCATENATE gv_adrc-str_suppl1 gv_adrc-street INTO GV_TOADDR1
                        SEPARATED BY space.

CONCATENATE gv_adrc-str_suppl2 gv_adrc-city2 INTO GV_TOADDR2
                    SEPARATED BY space.
SELECT SINGLE LEGAL_STATE_CODE INTO gv_tostatecode FROM j_1istatecdm
  WHERE STD_STATE_CODE = gv_kna1-regio.

















