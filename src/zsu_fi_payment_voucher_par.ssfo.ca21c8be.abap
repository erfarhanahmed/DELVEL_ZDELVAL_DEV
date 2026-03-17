
  LV_AMOUNT = WA_FINAL1-AMOUNT.

loop AT IT_BSIK1 INTO WA_BSIK1.

gv_total = gv_total + WA_BSIK1-DMBTR.

ENDLOOP.


DATA ls_word TYPE spell.

*CLEAR ls_word.
IF  WA_FINAL1-CURR = 'SAR'.               """"For SAR only
  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = WA_FINALN-GV_sum1
      currency  = WA_FINAL1-CURR
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
IF ls_word-decword = 'ZERO'.
  CONCATENATE  'SAUDI RIYAL'ls_word-word 'ONLY' INTO
  GV_WORD SEPARATED BY SPACE.
ELSE.
 CONCATENATE 'SAUDI RIYAL'  ls_word-word 'AND'
             ls_word-decword 'HALALAS ONLY' INTO GV_WORD SEPARATED BY SPACE.
ENDIF.

ELSEIF WA_FINAL1-CURR = 'USD'.     ""fOR USD CURR.
  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = WA_FINAL1-WRBTR1
      currency  = WA_FINAL1-CURR
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
 CONCATENATE  ls_word-word'DOLLARS' 'AND'
             ls_word-decword 'CENTS ' INTO GV_WORD SEPARATED BY SPACE.
 ELSEIF
    ls_word-decword = 'ZERO' .
    CONCATENATE  ls_word-word'DOLLARS'
              INTO GV_WORD SEPARATED BY SPACE.
 ENDIF.

 ELSEIF WA_FINAL1-CURR = 'INR'.     ""fOR INR CURR.
  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = WA_FINAL1-WRBTR1
      currency  = WA_FINAL1-CURR
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
 CONCATENATE  'RUPEES' ls_word-word 'AND'
             ls_word-decword 'PAISA ONLY' INTO GV_WORD SEPARATED BY SPACE.
 ELSEIF
    ls_word-decword = 'ZERO' .
    CONCATENATE 'RUPEES' ls_word-word 'ONLY'
              INTO GV_WORD SEPARATED BY SPACE.
 ENDIF.


ENDIF.
