DATA ls_word TYPE spell.
IF LV_NETAMT IS NOT INITIAL.
    CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = LV_NETAMT
      currency  = 'INR'
*      FILLER    = ' '
*      language  = sy-langu
      language  = 'E'
    IMPORTING
      in_words  = ls_word
    EXCEPTIONS
      not_found = 1
      too_large = 2
      OTHERS    = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.
 IF ls_word-decword NE 'ZERO'.
 CONCATENATE 'RUPEES' ls_word-word 'AND'
             ls_word-decword 'PAISA ONLY' INTO GV_WORD SEPARATED BY SPACE.
 ELSEIF
    ls_word-decword = 'ZERO' .
    CONCATENATE  'RUPEES' ls_word-word 'ONLY'
              INTO GV_WORD SEPARATED BY SPACE.
 ENDIF.
ENDIF.























