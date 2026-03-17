


  DATA:  grosze TYPE p DECIMALS 2 VALUE 0.

  DATA: BEGIN OF amt_in_words.
          INCLUDE STRUCTURE spell.
  DATA: END OF amt_in_words.

  DATA: tmpslo(10), dziesiatki(3), minussl(5).

  DATA waerk TYPE waerk.

  IF NOT excur IS INITIAL.
    waerk = excur.
  ELSE.
    waerk = bil_waerk.
  ENDIF.

DATA:
  lv_amt TYPE pc207-betrg.

*BREAK-POINT.
lv_amt = TOTAL.

CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    amt_in_num         = lv_amt
  IMPORTING
    amt_in_words       = inwords
  EXCEPTIONS
    data_type_mismatch = 1
    OTHERS             = 2.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

    TRANSLATE inwords TO LOWER CASE.
*    TRANSLATE amt_in_words-decword TO LOWER CASE.

"TO CONVERT TEXT FIRST LETTER TO UPPERCASE
    CALL FUNCTION 'ISP_CONVERT_FIRSTCHARS_TOUPPER'
      EXPORTING
        input_string        = inwords
*       SEPARATORS          = ' -.,;:'
     IMPORTING
       OUTPUT_STRING       = inwords
              .

    TRANSLATE amt_in_words-decword TO LOWER CASE.
 "TO CONVERT TEXT FIRST LETTER TO UPPERCASE
    CALL FUNCTION 'ISP_CONVERT_FIRSTCHARS_TOUPPER'
      EXPORTING
        input_string        = amt_in_words-decword
*       SEPARATORS          = ' -.,;:'
     IMPORTING
       OUTPUT_STRING       = amt_in_words-decword
              .



*    CONCATENATE minussl inwords waerk ' ' tmpslo
    CONCATENATE inwords 'Rs. Only'
    INTO inwords
    SEPARATED BY space.


*ENDFORM.                    "spell_amount




































