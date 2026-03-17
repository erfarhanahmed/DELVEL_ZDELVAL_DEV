*&---------------------------------------------------------------------*
*& Report ZASN_GRN_INVOICE_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zasn_grn_invoice_report.

selection-screen : begin of block b1 with frame.
parameters: r1 radiobutton group abc default 'X',
            r2 radiobutton group abc,
            r3 radiobutton group abc.

selection-screen: end of block b1.

initialization.

at selection-screen.
  if r1 = 'X'.
    submit  zasn_grn1 via selection-screen and return.
  elseif r2 = 'X'.
    submit ZASN_INBOUND_DELIVERY via selection-screen and return.

  elseif r3 = 'X'.
    submit zasn_invoicereceipt via selection-screen and return.
  endif.
