wa_hdr = LS_BIL_INVOICE-HD_GEN.
it_item = LS_BIL_INVOICE-it_gen.
IT_ADR = LS_BIL_INVOICE-HD_ADR.
WA_TERMS = LS_BIL_INVOICE-HD_GEN_DESCRIPT.
WA_PURCH = LS_BIL_INVOICE-HD_REF.

"gv_qty = gv_qty + wa_item-fkimg.

PG_FR = SFSY-PAGE.


PG_TO = SFSY-FORMPAGES.


SELECT knumv
      kposn
      kschl
      kbetr
      waers
      kwert
      kinak
* FROM konv
 FROM PRCD_ELEMENTS
 INTO TABLE IT_KONV
 WHERE knumv = wa_hdr-kond_numb.

SORT IT_KONV BY kposn.



*LOOP AT IT_KONV INTO WA_KONV.
* CASE WA_KONV-KSCHL.
*    WHEN 'ULOC' .
*      GV_ULOC = GV_ULOC + WA_KONV-KWERT.
*    WHEN 'USTA'.
*      GV_USTA = GV_USTA + WA_KONV-KWERT.
*    WHEN 'UCOU'.
*      GV_UCOU = GV_UCOU + WA_KONV-KWERT.
*ENDLOOP.

*SELECT SINGLE * FROM bsid INTO wa_bsid
*  WHERE zuonr = wa_hdr-BIL_NUMBER.
*
*SELECT SINGLE * FROM bsad INTO wa_bsad
*  WHERE zuonr = wa_hdr-BIL_NUMBER.

SELECT SINGLE * FROM t052 INTO wa_t052
  WHERE ZTERM = wa_hdr-TERMS_PAYM.

SELECT SINGLE * FROM vbrp INTO wa_vbrp
  WHERE vbeln = wa_hdr-BIL_NUMBER.

SELECT SINGLE * FROM vbrK INTO wa_vbrK
  WHERE vbeln = wa_hdr-BIL_NUMBER.


SELECT SINGLE * FROM T001W INTO WA_T001W
  WHERE WERKS = WA_VBRP-WERKS.

SELECT SINGLE * FROM ADRC INTO WA_ADRC
  WHERE ADDRNUMBER = WA_T001W-ADRNR.

SELECT SINGLE * FROM LIKP INTO WA_LIKP
  WHERE VBELN = WA_VBRP-VGBEL.

SELECT SINGLE * FROM TINCT INTO WA_TINCT
  WHERE INCO1 = wa_vbrk-inco1 and spras = 'E'.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt  TYPE tline,
      ls_mattxt  TYPE tline.

CLEAR: lv_lines, ls_mattxt,wa_lines.
      REFRESH lv_lines.
      lv_name = wa_hdr-BIL_NUMBER.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U004'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
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
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE  wa_lines-tdline GV_CREDIT INTO GV_CREDIT SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE GV_CREDIT.
      ENDIF.


CLEAR: lv_lines, ls_mattxt,wa_lines.
      REFRESH lv_lines.
      lv_name = wa_hdr-BIL_NUMBER.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U003'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
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
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE GV_TRACK wa_lines-tdline INTO GV_TRACK SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE GV_TRACK.
      ENDIF.



*CALL FUNCTION 'IDWT_READ_MONTH_TEXT'
*  EXPORTING
*    langu         = sy-langu
*    month         = wa_vbrk-fkdat+4(2)
* IMPORTING
*   T247          = WA_T247
*          .
*TRANSLATE wa_t247-ktx+1(2) TO LOWER CASE.
CONCATENATE  WA_VBRK-FKDAT+4(2) wa_vbrk-fkdat+6(2) wa_vbrk-fkdat+0(4)
                INTO GV_BILL_DATE SEPARATED BY '.'.


CLEAR WA_T247.
IF WA_LIKP-WADAT IS NOT INITIAL.
*CALL FUNCTION 'IDWT_READ_MONTH_TEXT'
*  EXPORTING
*    langu         = sy-langu
*    month         = WA_LIKP-WADAT+4(2)
* IMPORTING
*   T247          = WA_T247
*          .
*
*TRANSLATE wa_t247-ktx+1(2) TO LOWER CASE.
CONCATENATE  WA_LIKP-WADAT+4(2) WA_LIKP-WADAT+6(2) WA_LIKP-WADAT+0(4)
                INTO GV_SHIP_DATE SEPARATED BY '.'.

ENDIF.




CLEAR: lv_lines, ls_mattxt,gv_remark,wa_lines.
      REFRESH lv_lines.
      lv_name = wa_hdr-BIL_NUMBER.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U005'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
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
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE gv_remark wa_lines-tdline INTO gv_remark SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE gv_remark.
      ENDIF.

CLEAR: lv_lines, ls_mattxt,GV_ref,wa_lines.
      REFRESH lv_lines.
      lv_name = wa_vbrp-aubel.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U002'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
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
          IF NOT wa_lines-tdline IS INITIAL.
             GV_ref = wa_lines-tdline .
          ENDIF.
      ENDIF.

CLEAR: lv_lines, ls_mattxt,GV_SOREM,wa_lines.
      REFRESH lv_lines.
      lv_name = wa_vbrp-aubel.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U005'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
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
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE GV_SOREM wa_lines-tdline  INTO GV_SOREM SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE GV_SOREM.
      ENDIF.
