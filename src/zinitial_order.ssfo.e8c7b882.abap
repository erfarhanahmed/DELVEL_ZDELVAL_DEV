
CONCATENATE ls_adrc_ag-STR_SUPPL1
ls_adrc_ag-STR_SUPPL2 ls_adrc_ag-LOCATION INTO gv_adr.

CONCATENATE ls_adrc_we-STR_SUPPL1 ls_adrc_we-STR_SUPPL2
ls_adrc_we-LOCATION INTO gv_adr1.

CONCATENATE  sy-datum+6(2) sy-datum+4(2) sy-datum+0(4)
                INTO GV_DATE SEPARATED BY '-'.

READ TABLE it_final INTO wa_final INDEX 1.









