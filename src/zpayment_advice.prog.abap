*&---------------------------------------------------------------------*
*& Report ZPAYMENT_ADVICE
*&---------------------------------------------------------------------*
REPORT zpayment_advice.

INCLUDE zpayment_voucher_dec.
INCLUDE zpayment_voucher_ss.
INCLUDE zpayment_advice_f01.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  "Get header table details


  PERFORM get_acc_header_data.
  IF it_bkpf IS NOT INITIAL. "header data is not initial

    PERFORM get_bank_details.
    PERFORM get_vendor_data.
    PERFORM combine_header_details.

    PERFORM get_gross_details.
    PERFORM get_tds_details.

    PERFORM FINAL_DATA.
    PERFORM display_smartform.
*
*  IF PDF = 'X'.
*    PERFORM print_pdf.
*    ENDIF.

  ELSE.
    MESSAGE TEXT-e03 TYPE TEXT-t01.
  ENDIF.
