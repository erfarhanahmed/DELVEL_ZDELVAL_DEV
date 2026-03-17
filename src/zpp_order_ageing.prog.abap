*&---------------------------------------------------------------------*
*& Report ZPP_ORDER_AGEING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPP_ORDER_AGEING.

INCLUDE ZPP_ORDER_AGEING_TOP.

INCLUDE ZPP_ORDER_AGEING_SELSCR.

INCLUDE ZPP_ORDER_AGEING_DATASEL.


START-OF-SELECTION.

PERFORM get_data.

if lt_order is not INITIAL.

  PERFORM display.
else.
  MESSAGE 'No data found' type 'E' DISPLAY LIKE 'I'.
endif.
