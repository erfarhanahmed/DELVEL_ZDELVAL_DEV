*break primusabap.
GV_TOTAL_VALUE = GV_TOTAL_VALUE + wa_line_item-value.

*DATA : LV_VALUE TYPE BAPICURR-BAPICURR.
*DATA : LV_VALUE1 TYPE BAPICURR-BAPICURR.
*LV_VALUE = wa_line_item-value.
*
*CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
*  EXPORTING
**    currency                   =
*    amount_external            = LV_VALUE
*    max_number_of_digits       = 15
* IMPORTING
*   AMOUNT_INTERNAL             = LV_VALUE1
**   RETURN                     =
*          .

















