BREAK primus.
IF LS_VBRK_J-fkart = 'ZEXP'.
SELECT SINGLE * FROM kna1 INTO gv_kna1 WHERE kunnr = kunnr.
SELECT SINGLE * FROM kna1 INTO to_kna1 WHERE kunnr = LS_VBRK_J-kunag.
SELECT SINGLE * FROM adrc INTO to_adrc WHERE
                ADDRNUMBER = to_kna1-ADRNR.
CONCATENATE to_adrc-str_suppl1 to_adrc-street INTO ls_final_eway-toaddr1
                        SEPARATED BY space.
CONCATENATE to_adrc-str_suppl2 to_adrc-city2 INTO ls_final_eway-toaddr2
                    SEPARATED BY space.

ls_final_eway-tostatecode = ' '.
ls_final_eway-topincode = ' '.


ELSE.
SELECT SINGLE * FROM kna1 INTO gv_kna1 WHERE kunnr = ship_to.
ENDIF.


SELECT SINGLE * FROM adrc INTO gv_adrc WHERE
                ADDRNUMBER = gv_kna1-ADRNR.
CONCATENATE gv_adrc-str_suppl1 gv_adrc-street INTO GV_TOADDR1
                        SEPARATED BY space.

CONCATENATE gv_adrc-str_suppl2 gv_adrc-city2 INTO GV_TOADDR2
                    SEPARATED BY space.
SELECT SINGLE LEGAL_STATE_CODE INTO gv_tostatecode FROM j_1istatecdm
  WHERE STD_STATE_CODE = gv_kna1-regio.













