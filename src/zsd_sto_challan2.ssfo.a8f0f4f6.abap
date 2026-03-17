
*BREAK fujiabap.
SELECT SINGLE bktxt FROM MKPF INTO GV_BKTXT
  WHERE MBLNR = GS_J_1IG_SUBCON-MBLNR.
*-----------Added By Abhishek Pisolkar (10.04.2018)
SELECT SINGLE XBLNR INTO GV_XBLNR
  FROM VBRK WHERE VBELN = LS_BIL_INVOICE-HD_GEN-BIL_NUMBER.
*--------------------------------------------------------------------*

DATA: lv_name   TYPE thead-tdname.

  CLEAR: it_lines,wa_LINES.
      REFRESH it_lines.
      lv_name = ls_bil_invoice-hd_gen-bil_number.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = '0002'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = it_lines
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

READ TABLE it_lines INTO wa_lines INDEX 1.
IF sy-subrc = 0.
txt1  = wa_lines-tdline.
ENDIF.
READ TABLE it_lines INTO wa_lines INDEX 2.
IF sy-subrc = 0.
txt2  = wa_lines-tdline.
ENDIF.
READ TABLE it_lines INTO wa_lines INDEX 3.
IF sy-subrc = 0.
txt3  = wa_lines-tdline.
ENDIF.
READ TABLE it_lines INTO wa_lines INDEX 4.
IF sy-subrc = 0.
txt4  = wa_lines-tdline.
ENDIF.
READ TABLE it_lines INTO wa_lines INDEX 5.
IF sy-subrc = 0.
txt5  = wa_lines-tdline.
ENDIF.
READ TABLE it_lines INTO wa_lines INDEX 6.
IF sy-subrc = 0.
txt6  = wa_lines-tdline.
ENDIF.
READ TABLE it_lines INTO wa_lines INDEX 7.
IF sy-subrc = 0.
txt7  = wa_lines-tdline.
ENDIF.
READ TABLE it_lines INTO wa_lines INDEX 8.
IF sy-subrc = 0.
txt8  = wa_lines-tdline.
ENDIF.
