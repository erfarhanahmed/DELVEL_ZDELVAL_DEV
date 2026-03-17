CLEAR us_code.

select SINGLE wrkst INTO us_code FROM mara WHERE
  matnr = wa_final-matnr.
IF us_code IS NOT INITIAL.
CONCATENATE '(' us_code ')' INTO us_code.
CONDENSE us_code.
ENDIF.
CLEAR wa_vbap.
SELECT SINGLE * FROM vbap INTO wa_vbap
  WHERE vbeln = wa_final-vbeln AND posnr = wa_final-posnr.

CLEAR: CUST_DT.
IF WA_vbap-CUSTDELDATE IS NOT INITIAL.

CONCATENATE  WA_vbap-CUSTDELDATE+6(2) WA_vbap-CUSTDELDATE+4(2) WA_vbap-CUSTDELDATE+0(4)
                INTO CUST_DT SEPARATED BY '-'.
ENDIF.

DATA: lv_name   TYPE thead-tdname.
  CLEAR: it_lines,wa_LINES,lv_name,SHIP_CODE.
CONCATENATE WA_FINAL-vbeln WA_FINAL-POSNR INTO lv_name.

      REFRESH it_lines.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = '0010'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBP'
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
IF it_lines IS NOT INITIAL.
READ TABLE it_lines INTO wa_lines INDEX 1.
IF sy-subrc = 0.
SHIP_CODE = wa_lines-tdline.
ENDIF.
ENDIF.

IF SHIP_CODE IS NOT INITIAL.
CONCATENATE '('SHIP_CODE ')' INTO SHIP_CODE.
CONDENSE ship_code.
ENDIF.





