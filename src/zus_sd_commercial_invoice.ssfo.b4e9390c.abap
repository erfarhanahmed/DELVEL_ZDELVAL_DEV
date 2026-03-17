
data :ls_word type spell.

  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = GV_TOT
      currency  = 'USD'
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
 BREAK PRIMUSABAP.

 DATA : INPUT TYPE CHAR128.
 INPUT = GV_WORD.
GV_WORD1 = GV_WORD.
*BREAK CTPLMM.
* CALL FUNCTION 'HR_IN_CHG_INR_WRDS'"'ISP_CONVERT_FIRSTCHARS_TOUPPER'
*   EXPORTING
*     input_string        = GV_TOT  "INPUT
**    SEPARATORS          = ' -.,;:'
*  IMPORTING
*    OUTPUT_STRING       = GV_WORD1
*           .














