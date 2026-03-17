
gv_sub_tot = GV_BASE_AMT + GV_CUSTMAT_AMT + GV_DISC_AMT.
gv_sub_tot_tax = gv_sub_tot + gv_pf + gv_fri + gv_dc + gv_ins
            + gv_test .

*gv_sub_tot = gv_pf + gv_fri + gv_ins
*            + gv_test + gv_tot_amt.

gv_t_gst = gv_cgst + gv_sgst + gv_igst + GV_MWAS.

GV_TCS = GV_MWSBK - gv_t_gst.

gv_grand_tot = gv_sub_tot_tax + gv_t_gst + gv_tcs.

DATA:
  lv_amt TYPE pc207-betrg.

lv_amt = gv_t_gst.

DATA ls_word TYPE spell.
*BREAK PRIMUS.
*CLEAR ls_word.
IF  LS_BIL_INVOICE-HD_GEN-BIL_WAERK = 'SAR'.

  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = lv_amt
      currency  = LS_BIL_INVOICE-HD_GEN-BIL_WAERK
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
if ls_word-decword = 'ZERO' .
  CONCATENATE 'SAUDI RIYAL'  ls_word-word 'ONLY'
             INTO gv_gst_wrd SEPARATED BY SPACE.
else.
 CONCATENATE 'SAUDI RIYAL'  ls_word-word 'AND'
            ls_word-decword 'HALAL' INTO gv_gst_wrd SEPARATED BY SPACE.
endif.
ELSEIF LS_BIL_INVOICE-HD_GEN-BIL_WAERK = 'USD'.

  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = lv_amt
      currency  = LS_BIL_INVOICE-HD_GEN-BIL_WAERK
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
             ls_word-decword 'CENTS ' INTO gv_gst_wrd SEPARATED BY SPACE.
 ELSEIF
    ls_word-decword = 'ZERO' .
    CONCATENATE  ls_word-word'DOLLARS'
              INTO gv_gst_wrd SEPARATED BY SPACE.

 ENDIF.
ENDIF.


*CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
*  EXPORTING
*    amt_in_num         = lv_amt
*  IMPORTING
*    amt_in_words       = gv_gst_wrd
*  EXCEPTIONS
*    data_type_mismatch = 1
*    OTHERS             = 2.
*IF sy-subrc <> 0.
*  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*ENDIF.

CLEAR lv_amt.
lv_amt = gv_grand_tot.
*CLEAR ls_word.


IF  LS_BIL_INVOICE-HD_GEN-BIL_WAERK = 'SAR'.

  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = lv_amt
      currency  = LS_BIL_INVOICE-HD_GEN-BIL_WAERK
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
 CONCATENATE  'SAUDI RIYAL' ls_word-word 'AND'
  ls_word-decword 'HALAL'  INTO gv_tot_wrd SEPARATED BY SPACE.
 ELSEIF
    ls_word-decword = 'ZERO' .
    CONCATENATE 'SAUDI RIYAL' ls_word-word'ONLY'
              INTO gv_tot_wrd SEPARATED BY SPACE.

 ENDIF.

* CONCATENATE 'SAUDI RIYAL'  ls_word-word 'AND'
*             ls_word-decword 'HALALAS' INTO gv_tot_wrd SEPARATED BY SPACE.

ELSEIF LS_BIL_INVOICE-HD_GEN-BIL_WAERK = 'USD'.

  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = lv_amt
      currency  = LS_BIL_INVOICE-HD_GEN-BIL_WAERK
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
             ls_word-decword 'CENTS ' INTO gv_tot_wrd SEPARATED BY SPACE.
 ELSEIF
    ls_word-decword = 'ZERO' .
    CONCATENATE  ls_word-word'DOLLARS'
              INTO gv_tot_wrd SEPARATED BY SPACE.

 ENDIF.
ENDIF.
