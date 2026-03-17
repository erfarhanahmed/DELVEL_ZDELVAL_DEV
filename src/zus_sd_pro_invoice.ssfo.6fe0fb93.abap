
SELECT SINGLE * FROM mara INTO wa_mara
  WHERE matnr = WA_ITEM-MATERIAL.

SELECT SINGLE * FROM vbrp INTO wa_vbrp
  WHERE vbeln = wa_item-BIL_NUMBER
    AND posnr = wa_item-ITM_NUMBER.

SELECT SINGLE * FROM vbap INTO wa_vbap
  WHERE vbeln = wa_vbrp-aubel
    AND posnr = wa_vbrp-aupos.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt  TYPE tline,
      ls_mattxt  TYPE tline.



CLEAR: lv_lines, GV_TAG,lv_name,wa_lines.
      REFRESH lv_lines.
*      lv_name = IS_VBDKA-VBELN.
CONCATENATE wa_vbrp-aubel wa_vbrp-aupos INTO lv_name.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = '0001'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBP'
        TABLES
          lines                   = lv_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF NOT lv_lines IS INITIAL.

      READ TABLE lv_lines INTO wa_lines INDEX 1.
        IF sy-subrc = 0.
          gv_tag = wa_lines-tdline.
        ENDIF.
       ENDIF.

















