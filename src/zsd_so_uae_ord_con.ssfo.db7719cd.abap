
*CONCATENATE ls_adrc_ag-STR_SUPPL1
*ls_adrc_ag-STR_SUPPL2 ls_adrc_ag-LOCATION INTO gv_adr.

*CONCATENATE ls_adrc_we-STR_SUPPL1 ls_adrc_we-STR_SUPPL2
*ls_adrc_we-LOCATION INTO gv_adr1.

DATA:
  lv_kunnr TYPE kna1-kunnr,
  lv_adrnr TYPE kna1-adrnr.
*  lv_tele TYPE kna1-TELF1.
SELECT SINGLE adrnr
        FROM  kna1
        INTO lv_adrnr
        WHERE kunnr = wa_final-kunnr.
SELECT SINGLE smtp_addr
        FROM  adr6
        INTO  gv_email
        WHERE addrnumber = lv_adrnr.













