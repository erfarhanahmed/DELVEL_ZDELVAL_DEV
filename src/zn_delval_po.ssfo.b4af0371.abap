**CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
**  EXPORTING
**    input          = wa_item-meins
**    language       = sy-langu
**  IMPORTING
**    output         = wa_item-meins
**  EXCEPTIONS
**    unit_not_found = 1
**    OTHERS         = 2.
**IF sy-subrc <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**ENDIF.
**
**v_text = wa_item-meins.
**CONDENSE v_text.


















