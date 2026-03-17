DATA : ls_hd_fin TYPE LINE OF  lb_t_bil_hd_fin .

READ TABLE is_bil_invoice-hd_fin  INTO ls_hd_fin INDEX 1.
*gv_amtwords = ls_hd_fin-gawrd.
*gv_amtwords = gs_total-kwert.
DATA:  grosze TYPE p DECIMALS 2 VALUE 0.
DATA: BEGIN OF amt_in_words.
          INCLUDE STRUCTURE spell.
  DATA: END OF amt_in_words.
DATA: LV_WAERK(4) TYPE C VALUE 'USD'.

IF  IS_BIL_INVOICE-HD_GEN-BIL_WAERK = 'SAR'.
CALL FUNCTION 'SPELL_AMOUNT'
  EXPORTING
  amount    = gs_total-kwert
  currency  = 'SAR'
  filler    = ' '
*  language  = sy-langu "langu
  IMPORTING
  in_words  = amt_in_words
  EXCEPTIONS
  not_found = 1
  too_large = 2
  OTHERS    = 3.
 IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.
 CONCATENATE 'SAUDI RIYAL'  amt_in_words-word 'AND'
            amt_in_words-decword 'HALALAS'
            INTO gv_amtwords SEPARATED BY SPACE.
ELSEIF  IS_BIL_INVOICE-HD_GEN-BIL_WAERK = 'USD'.
CALL FUNCTION 'SPELL_AMOUNT'
  EXPORTING
  amount    = gs_total-kwert
  currency  = 'USD'
  filler    = ' '
*  language  = sy-langu "langu
  IMPORTING
  in_words  = amt_in_words
  EXCEPTIONS
  not_found = 1
  too_large = 2
  OTHERS    = 3.
 IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.
  IF amt_in_words-decword NE 'ZERO'.
 CONCATENATE  amt_in_words-word 'DOLLARS' 'AND'
             amt_in_words-decword 'CENTS '
             INTO gv_amtwords SEPARATED BY SPACE.
 ELSEIF
    amt_in_words-decword = 'ZERO' .
    CONCATENATE  amt_in_words-word 'DOLLARS'
              INTO gv_amtwords SEPARATED BY SPACE.

 ENDIF.

ELSEIF  IS_BIL_INVOICE-HD_GEN-BIL_WAERK = 'INR'.
CALL FUNCTION 'SPELL_AMOUNT'
  EXPORTING
  amount    = gs_total-kwert
  currency  = 'INR'
  filler    = ' '
*  language  = sy-langu "langu
  IMPORTING
  in_words  = amt_in_words
  EXCEPTIONS
  not_found = 1
  too_large = 2
  OTHERS    = 3.
 IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.
  IF amt_in_words-decword NE 'ZERO'.
 CONCATENATE  amt_in_words-word 'RUPEES' 'AND'
             amt_in_words-decword 'PAISE '
             INTO gv_amtwords SEPARATED BY SPACE.
 ELSEIF
    amt_in_words-decword = 'ZERO' .
    CONCATENATE  amt_in_words-word 'RUPEES'
              INTO gv_amtwords SEPARATED BY SPACE.

 ENDIF.



ENDIF.


*CONCATENATE amt_in_words-WORD LV_WAERK  amt_in_words-DECWORD  INTO gv_amtwords.
*REPLACE ALL OCCURRENCES OF 'USD' IN gv_amtwords
*  WITH ' and CENTS '.
*CONCATENATE gv_amtwords ' ONLY' INTO gv_amtwords .

DATA: v_kwert1 TYPE pc207-betrg.
*REPLACE ALL OCCURRENCES OF ',' IN V_KWERT WITH ''.
*v_kwert1 = is_bil_invoice-hd_gen-bil_netwr * g_kurrf.
v_kwert1 = gs_total-kwert * g_kurrf.
*V_KWERT = V_KWERT1.
IF v_kwert1 LT 0.
  v_kwert1 = v_kwert1 * -1.
ENDIF.




*CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
*  EXPORTING
*    amt_in_num         = v_kwert1
*  IMPORTING
*    amt_in_words       = gv_txt1
*  EXCEPTIONS
*    data_type_mismatch = 1
*    OTHERS             = 2.
*IF sy-subrc <> 0.
*  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*ENDIF.
*
*REPLACE ALL OCCURRENCES OF 'Paise' IN gv_txt1 WITH ' '.
*REPLACE ALL OCCURRENCES OF 'Rupees' IN gv_txt1 WITH ' and Paise '.
*CONCATENATE gv_txt1 ' ONLY' INTO gv_txt1.


*LOOP AT gt_total INTO gs_total.
*  if  gs_total-text NE 'Total'.
*    TG_QTY = space.
*    GS_IT_GEN-FKIMG = space.
*    gv_fkimg = space.
*    endif.
*  endloop.

DATA: BEGIN OF amt_in_words_ar.
          INCLUDE STRUCTURE spell.
  DATA: END OF amt_in_words_ar.

CALL FUNCTION 'SPELL_AMOUNT'
  EXPORTING
  amount    = v_kwert1
  currency  = 'SAR'
  filler    = ' '
*  language  = sy-langu "langu
  IMPORTING
  in_words  = amt_in_words_ar
  EXCEPTIONS
  not_found = 1
  too_large = 2
  OTHERS    = 3.
 IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.
 CONCATENATE 'SAUDI RIYAL'  amt_in_words_ar-word 'AND'
            amt_in_words_ar-decword 'HALALAS'
            INTO gv_txt1 SEPARATED BY SPACE.
