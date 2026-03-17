
CLEAR wa_vbap.
SELECT SINGLE * FROM vbap INTO wa_vbap
  WHERE vbeln = wa_final-vbeln AND posnr = wa_final-posnr.

*CLEAR: CUST_DT.
*IF WA_vbap-CUSTDELDATE IS NOT INITIAL.
*
*CONCATENATE  WA_vbap-CUSTDELDATE+0(4) WA_vbap-CUSTDELDATE+4(2) WA_vbap-CUSTDELDATE+0(4)
*                INTO CUST_DT SEPARATED BY '-'.
*ENDIF.
*BREAK-POINT.
DATA: lv_name   TYPE thead-tdname.

  CLEAR: LT_TLINE,LS_TLINE,WA_CUST_MAT.
      REFRESH LT_TLINE.
      CONCATENATE wa_final-VBELN wa_final-POSNR INTO lv_name.
*      lv_name = wa_final-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = '0001'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBP'
        TABLES
          lines                   = LT_TLINE
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

IF LT_TLINE IS NOT INITIAL.
LOOP AT LT_TLINE INTO LS_TLINE.
IF NOT LS_TLINE-tdline IS INITIAL.
 CONCATENATE WA_CUST_MAT LS_TLINE-tdline INTO WA_CUST_MAT SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.





