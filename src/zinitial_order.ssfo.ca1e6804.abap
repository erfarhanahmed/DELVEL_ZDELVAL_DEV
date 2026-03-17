

DATA lv_base TYPE pc207-betrg.

lv_base = lv_base_amt.

CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    amt_in_num               = LV_BASE
 IMPORTING
   AMT_IN_WORDS             = lv_vamt
 EXCEPTIONS
   DATA_TYPE_MISMATCH       = 1
   OTHERS                   = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

IF wa_final-waerk = 'USD'.
  REPLACE 'Rupees' IN lv_vamt with 'DOLLAR'.
  REPLACE 'Paise'  IN lv_vamt with 'CENTS ONLY'.
ELSEIF wa_final-waerk = 'EUR'.
  REPLACE 'Rupees' IN lv_vamt with 'EURO'.
  REPLACE 'Paise'  IN lv_vamt with 'CENTS ONLY'.
ENDIF.


CALL FUNCTION 'ISP_CONVERT_FIRSTCHARS_TOUPPER'
  EXPORTING
    input_string        = lv_vamt
*   SEPARATORS          = ' -.,;:'
 IMPORTING
   OUTPUT_STRING       = lv_vamt
          .











