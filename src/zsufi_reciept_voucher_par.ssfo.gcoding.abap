
   SELECT BELNR
         BUKRS
         GJAHR
         REBZG
         REBZJ
         BUDAT
         DMBTR
         BUZEI
         WRBTR
    FROM BSID INTO TABLE IT_BSIK_N
         WHERE BELNR = WA_FINAL2-BELNR
         AND BUKRS = WA_FINAL2-BUKRS
         AND GJAHR = WA_FINAL2-GJAHR.
DELETE ADJACENT DUPLICATES FROM IT_BSIK_N COMPARING ALL FIELDS.

    SELECT XBLNR,
           DMBTR,
           BELNR,
           BUZEI,
           WRBTR
      FROM BSID
      INTO TABLE @DATA(IT_BSID)
      FOR ALL ENTRIES IN @IT_BSIK_N
      WHERE BELNR = @IT_BSIK_N-REBZG.
    CLEAR : LV_SUM1,LV_SUM.
    LOOP AT IT_BSIK_N INTO WA_BSIK_N.

      WA_BSIK-BELNR = WA_BSIK_N-BELNR.
      WA_BSIK-REBZG = WA_BSIK_N-REBZG.
      WA_BSIK-BUDAT = WA_BSIK_N-BUDAT.
      WA_BSIK-DMBTR1 = WA_BSIK_N-DMBTR.
      WA_BSIK-WRBTR1 = WA_BSIK_N-WRBTR.

       LV_SUM1 = LV_SUM1 + WA_BSIK-WRBTR1.
      READ TABLE IT_BSID INTO DATA(WA_BSID) WITH KEY BELNR
      = WA_BSIK_N-REBZG.
      WA_BSIK-XBLNR = WA_BSID-XBLNR.
      WA_BSIK-DMBTR = WA_BSID-DMBTR.
      WA_BSIK-WRBTR = WA_BSID-WRBTR.
      APPEND WA_BSIK TO IT_BSIK.

    ENDLOOP.

    LOOP AT IT_BSIK_N INTO WA_BSIK_N.

      LV_SUM = LV_SUM + WA_BSIK_N-DMBTR.

    ENDLOOP.

DATA ls_word TYPE spell.
IF  WA_FINAL2-CURR = 'SAR'.               """"For SAR only
  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = LV_SUM
      currency  = WA_FINAL2-CURR
      FILLER    = ' '
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
             ls_word-decword 'HALALAS' INTO GV_WORD SEPARATED BY SPACE.
ENDIF.

ELSEIF WA_FINAL2-CURR = 'USD'.     ""fOR USD CURR.
  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = LV_SUM1
      currency  = WA_FINAL2-CURR
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

 ELSEIF WA_FINAL2-CURR = 'INR'.     ""fOR INR CURR.
  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = LV_SUM1
      currency  = WA_FINAL2-CURR
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




