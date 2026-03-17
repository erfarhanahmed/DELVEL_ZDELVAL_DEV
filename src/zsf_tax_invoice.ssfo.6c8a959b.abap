


*data : grd_amt TYPE PC207-BETRG.
*data : gv_amt1 TYPE konv-kbetr.
****clear grd_amt.
*BREAK kdeshmukh.
IF GS_TAXS-kschl ne ' '.
  GRD_AMT = GRD_AMT + GS_TAXS-KWERT.
ENDIF.


 gv_amount_text = GS_TAXS-KWERT.
 gv_amount_text1 = GRD_AMT.

IF GS_TAXS-KWERT LT 0.

  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
  CHANGING
    value         = gv_amount_text.
              .
  ENDIF.

  if grd_amt lt 0.

  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
  CHANGING
    value         = gv_amount_text1.

 endif.

*if wa_hdr-waerk = 'INR'.

CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    amt_in_num               = grd_amt
 IMPORTING
   AMT_IN_WORDS             = v_text1
 EXCEPTIONS
   DATA_TYPE_MISMATCH       = 1
   OTHERS                   = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

*ELSE.
*
*  CALL FUNCTION 'SPELL_AMOUNT'
* EXPORTING
*   AMOUNT          = grd_amt
*   CURRENCY        = wa_hdr-waerk
*   FILLER          = ' '
*   LANGUAGE        = SY-LANGU
* IMPORTING
*   IN_WORDS        = spell
* EXCEPTIONS
*   NOT_FOUND       = 1
*   TOO_LARGE       = 2
*   OTHERS          = 3
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.

*v_text1 = spell-word.
*
*ENDIF.









