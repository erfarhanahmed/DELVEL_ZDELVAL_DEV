
CLEAR wa_mara.

SELECT SINGLE
        matnr
*          GROES
        wrkst
        zsize
  FROM mara INTO CORRESPONDING FIELDS OF wa_mara
  WHERE matnr = gs_it_gen-material.
SELECT SINGLE * FROM vbrp INTO wa_vbrp
   WHERE vbeln = gs_it_gen-BIL_NUMBER
    AND  posnr = gs_it_gen-ITM_NUMBER.
CLEAR:gv_soline,gv_material.
CONCATENATE wa_vbrp-VBELV wa_vbrp-POSNV INTO gv_soline.

*CLEAR: lv_lines,wa_lines.
*      REFRESH lv_lines.
      lv_name = gv_soline.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = '0010'
*          language                = sy-langu
*          name                    = lv_name
*          object                  = 'VBBP'
*        TABLES
*          lines                   = lv_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*      ENDIF.
*      IF NOT lv_lines IS INITIAL.
*       READ TABLE lv_lines INTO wa_lines INDEX 1.
*      ENDIF.

*IF wa_lines-tdline IS NOT INITIAL.
*  gv_material = wa_lines-tdline.
*
*ELSE.
*  gv_material = wa_mara-wrkst.
*
*ENDIF.
IF wa_lines-tdline IS INITIAL.
  gv_material = wa_mara-wrkst.
ENDIF.














