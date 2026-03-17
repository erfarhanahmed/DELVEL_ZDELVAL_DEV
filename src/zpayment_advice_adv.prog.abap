*&---------------------------------------------------------------------*
*& Report ZPAYMENT_ADVICE
*&---------------------------------------------------------------------*
REPORT zpayment_advice_adv.

INCLUDE zpayment_voucher_adv_dec.

INCLUDE zpayment_voucher_adv_ss.

INCLUDE zpayment_advice_adv_f01.


AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.


  PERFORM get_bank_details.
  PERFORM get_vendor_data.
  PERFORM combine_header_details.

  PERFORM get_gross_details.
  PERFORM get_tds_details.

  PERFORM final_data.
  PERFORM display_smartform.
*
*  IF PDF = 'X'.
*     PERFORM print_pdf.
*  ENDIF.
