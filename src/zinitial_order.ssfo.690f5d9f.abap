
"Customer Inspection
CLEAR: it_lines,wa_LINES,lv_name.
lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z999'
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

IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE gv_cust_insp wa_lines-tdline
             INTO gv_cust_insp SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.

"Document Approval By Customer
CLEAR: it_lines,wa_LINES,lv_name.
lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z020'
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

IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE gv_doc_approval wa_lines-tdline
             INTO gv_doc_approval SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.

"Conditional Delivery
CLEAR: it_lines,wa_LINES,lv_name.
lv_name = WA_FINAL-vbeln.

      REFRESH it_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z103'
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

IF it_lines IS NOT INITIAL.
LOOP AT it_lines INTO wa_lines.
IF NOT wa_lines-tdline IS INITIAL.
 CONCATENATE gv_con_delivery wa_lines-tdline
             INTO gv_con_delivery SEPARATED BY space.
ENDIF.
ENDLOOP.
ENDIF.














