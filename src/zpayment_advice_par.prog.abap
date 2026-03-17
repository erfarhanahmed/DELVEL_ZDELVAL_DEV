*&---------------------------------------------------------------------*
*& Report ZPAYMENT_ADVICE
*&---------------------------------------------------------------------*
REPORT zpayment_advice_par.

INCLUDE zpayment_voucher_par_dec.
INCLUDE zpayment_voucher_par_ss.
INCLUDE zpayment_advice_par_f01.


START-OF-SELECTION.

  PERFORM get_acc_header_data.
  IF gt_bseg IS NOT INITIAL. "header data is not initial

    PERFORM get_vendor_data.
*    PERFORM combine_header_details.

    PERFORM get_gross_details.
*    PERFORM GET_TDS_DETAILS.

    PERFORM final_data.
    PERFORM display_smartform.

*    IF pdf = 'X'.
*      PERFORM print_pdf.
*    ENDIF.
*    PERFORM print_pdf.

  ELSE.
    MESSAGE TEXT-e03 TYPE TEXT-t01.
  ENDIF.
