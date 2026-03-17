
SELECT SINGLE ZREMARKS FROM ZSUB_REMARK
  INto gv_remarks WHERE MBLNR = mblnr.

data :ls_word type spell.

  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = GV_TOT
      currency  = 'USD'
*      FILLER    = ' '
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
 CONCATENATE  ls_WORD-word'DOLLARS' 'AND'
             ls_WORD-decword 'CENTS ' INTO GV_WORD SEPARATED BY SPACE.
 ELSEIF
   ls_WORD-decword = 'ZERO' .
    CONCATENATE  ls_WORD-word'DOLLARS'
              INTO GV_WORD SEPARATED BY SPACE.
 ENDIF.

















