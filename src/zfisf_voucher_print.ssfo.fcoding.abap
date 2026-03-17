*&---------------------------------------------------------------------*
*&      Form  convert_to_words
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LV_TOTAL     text
*      -->WRITE        text
*      -->IV_INVAMT    text
*      -->TO           text
*      -->LV_VALUE     text
*      -->CURRENCY     text
*      -->GV_CURRENCY  text
*----------------------------------------------------------------------*
FORM CONVERT_TO_WORDS USING LV_TOTAL
                      CHANGING LV_WORDS.

  DATA: LV_VALUE            TYPE CHAR18,
        LW_SPELL1           TYPE SPELL.


  WRITE LV_TOTAL TO LV_VALUE CURRENCY 'USD'.
* lv_value = iv_invamt.

  CALL FUNCTION 'SPELL_AMOUNT'
   EXPORTING
     AMOUNT          = LV_VALUE
     CURRENCY        = 'USD'
*   FILLER          = ' '
     LANGUAGE        = SY-LANGU
   IMPORTING
     IN_WORDS        = LW_SPELL1
   EXCEPTIONS
     NOT_FOUND       = 1
     TOO_LARGE       = 2
     OTHERS          = 3
            .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  IF LW_SPELL1-DECWORD <> 'ZERO'.
*    TRANSLATE LW_SPELL1-WORD TO LOWER CASE.
*    TRANSLATE LW_SPELL1-WORD+0(1) TO UPPER CASE.
*    TRANSLATE LW_SPELL1-DECWORD TO LOWER CASE.
*    CONCATENATE 'US Dollars' LW_SPELL1-WORD 'and cents' LW_SPELL1-DECWORD 'only' INTO LV_WORDS
*    SEPARATED BY SPACE.
    TRANSLATE LW_SPELL1-WORD TO UPPER CASE.
    TRANSLATE LW_SPELL1-DECWORD TO UPPER CASE.
    CONCATENATE 'US DOLLARS' LW_SPELL1-WORD 'AND CENTS' LW_SPELL1-DECWORD 'ONLY' INTO LV_WORDS
    SEPARATED BY SPACE.
  ELSE.
*    TRANSLATE LW_SPELL1-WORD TO LOWER CASE.
*    TRANSLATE LW_SPELL1-WORD+0(1) TO UPPER CASE.
*    CONCATENATE 'US Dollars' LW_SPELL1-WORD 'only' INTO LV_WORDS
*    SEPARATED BY SPACE.
    TRANSLATE LW_SPELL1-WORD TO UPPER CASE.
    CONCATENATE 'US DOLLARS' LW_SPELL1-WORD 'ONLY' INTO LV_WORDS
    SEPARATED BY SPACE.
  ENDIF.
ENDFORM.                    "convert_to_words


FORM CONVERT_TO_CAPITALISED CHANGING I_STR.
* Followingt block of code serves to convert the
* grand total amont text to sentence format
CONSTANTS:
  sm2big(52) VALUE
    'aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ'.

DATA:
  prev_space    TYPE c,
  my_len        TYPE i,
  my_pos        TYPE i,
  amtc(300)      ,
  amt(300).

 amtc = I_STR.
  amt = amtc.

  TRANSLATE amt TO LOWER CASE.
  my_len = strlen( amt ).

  prev_space = 'X'.
  my_pos = 0.
  WHILE my_pos LT my_len.
    IF prev_space = 'X'.
      CLEAR prev_space.
      TRANSLATE amt+my_pos(1) USING sm2big.
    ELSEIF amt+my_pos(1) = ' '.
      prev_space = 'X'.
    ENDIF.
    my_pos = my_pos + 1.
  ENDWHILE.
I_STR = AMT.
ENDFORM.













