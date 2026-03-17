
CONCATENATE ls_adrc_ag-STR_SUPPL1
ls_adrc_ag-STR_SUPPL2 ls_adrc_ag-MC_STREET ls_adrc_ag-STR_SUPPL3
ls_adrc_ag-LOCATION INTO gv_adr.

* BREAK-POINT.
CONCATENATE ls_adrc_we-STR_SUPPL1 ls_adrc_we-STR_SUPPL2 ls_adrc_we-MC_STREET
ls_adrc_we-STR_SUPPL3 ls_adrc_we-LOCATION INTO gv_adr1 SEPARATED BY SPACE.

CONCATENATE  sy-datum+4(2) sy-datum+6(2) sy-datum+0(4)
                INTO GV_DATE SEPARATED BY '-'.

*BREAK-POINT.
 READ TABLE it_final INTO wa_final INDEX 1.
    CLEAR FLAG .
    IF  sy-subrc = 0.
    IF WA_FINAL-KUNNR EQ '0000300000' and  WA_FINAL-KUNNR1 EQ '0000300000'.
    IF wa_final-erdat GE '20240812'.
        FLAG = 'X'.
    GV_ADR            = '6535 Industrial Dr,St 103'.
    ls_adrc_ag-STREET = '6535 Industrial Dr,St 103'.
    ls_adrc_we-NAME2  = '6535 Industrial Dr,St 103'.
    gv_adr1           = '6535 Industrial Dr,St 103'.
    ENDIF.
    elseif  WA_FINAL-KUNNR EQ '0000300000'.
      IF wa_final-erdat GE '20240812'.
        FLAG = 'X'.
    GV_ADR            = '6535 Industrial Dr,St 103'.
    ls_adrc_ag-STREET = '6535 Industrial Dr,St 103'.
*    ls_adrc_we-NAME2  = '6535 Industrial Dr,St 103'.
*    gv_adr1           = '6535 Industrial Dr,St 103'.
    ENDIF.
    ENDIF.

    ENDIF.




