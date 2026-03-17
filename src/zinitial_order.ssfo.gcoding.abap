
CLEAR: wa_final ,lv_total_amt, lv_cgst_tot,
       lv_sgst_tot,lv_igst_tot,lv_total_qty,
       lv_pf,lv_zin1,lv_zfr1,lv_zte1,lv_ztcs.

READ TABLE it_final INTO wa_final INDEX 1.

SELECT adrnr,parvw  FROM vbpa
 INTO TABLE @DATA(lt_vbpa)
  WHERE vbeln = @LV_VBELN"@wa_final-vbeln
  AND      posnr = ' '
  AND ( parvw = 'AG' OR parvw = 'WE' ).

IF lt_vbpa IS NOT INITIAL.

  LOOP AT lt_vbpa ASSIGNING FIELD-SYMBOL(<f1>).

    CASE <f1>-parvw.
      WHEN 'AG'.
        SELECT SINGLE * FROM adrc INTO ls_adrc_ag
       WHERE addrnumber = <f1>-adrnr.
        IF ls_adrc_AG-COUNTRY = 'IN' .
         SELECT SINGLE bezei FROM zgst_region1
           INTO lv_state_ag
           WHERE region = ls_adrc_AG-region.
         ENDIF.
      WHEN 'WE'.
        SELECT SINGLE * FROM adrc INTO ls_adrc_we
              WHERE addrnumber = <f1>-adrnr.
        IF ls_adrc_we-COUNTRY = 'IN' .
           SELECT SINGLE bezei FROM zgst_region1
           INTO lv_state_we
           WHERE region = ls_adrc_we-region.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

  ENDLOOP.

ENDIF.

CLEAR WA_FINAL.

*---------------------------------------------------------*
lv_name = lv_vbeln.
CALL FUNCTION 'READ_TEXT'
  EXPORTING
   CLIENT                        = SY-MANDT
    id                            = 'Z020'
    language                      = sy-langu
    NAME                          = lv_name
    OBJECT                        = 'VBBK'
*   ARCHIVE_HANDLE                = 0
*   LOCAL_CAT                     = ' '
* IMPORTING
*   HEADER                        =
*   OLD_LINE_COUNTER              =
  TABLES
    lines                         = lt_lines
 EXCEPTIONS
  ID                            = 1
   LANGUAGE                      = 2
   NAME                          = 3
   NOT_FOUND                     = 4
   OBJECT                        = 5
   REFERENCE_CHECK               = 6
   WRONG_ACCESS_TO_ARCHIVE       = 7
   OTHERS                        = 8 .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

*---------------------------------------------------------*
