DATA ls_word TYPE spell.
  DATA lv_waers TYPE EKKO-waers.
  DATA lv_discnt_word TYPE char255.
*BREAK-POINT.

IF GV_VBAK-WAERK = 'SAR'.
  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = LV_TOTAL_AMT
      currency  =  GV_VBAK-WAERK
      FILLER    = ' '
      language  = sy-langu
    IMPORTING
      in_words  = ls_word
    EXCEPTIONS
      not_found = 1
      too_large = 2
      OTHERS    = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.

 CONCATENATE 'SAUDI RIYAL'  ls_word-word 'AND'
             ls_word-decword 'HALALAS ONLY' INTO LV_WORD SEPARATED BY SPACE.


 ELSEIF GV_VBAK-WAERK = 'USD'.
     CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = LV_TOTAL_AMT
      currency  = GV_VBAK-WAERK
      FILLER    = ' '
      language  = sy-langu
    IMPORTING
      in_words  = ls_word
    EXCEPTIONS
      not_found = 1
      too_large = 2
      OTHERS    = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.


*BREAK-POINT.
IF ls_word-decword NE 'ZERO'.
 CONCATENATE  ls_word-word'DOLLARS' 'AND'
             ls_word-decword 'CENTS ' INTO LV_WORD SEPARATED BY SPACE.
 ELSEIF
    ls_word-decword = 'ZERO' .
    CONCATENATE  ls_word-word'DOLLARS'
              INTO LV_WORD SEPARATED BY SPACE.

 ENDIF.
ENDIF.
















