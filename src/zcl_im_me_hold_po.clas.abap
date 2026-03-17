class ZCL_IM_ME_HOLD_PO definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ME_HOLD_PO .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_ME_HOLD_PO IMPLEMENTATION.


  method IF_EX_ME_HOLD_PO~IS_ALLOWED.
*    BREAK primus.
  endmethod.
ENDCLASS.
