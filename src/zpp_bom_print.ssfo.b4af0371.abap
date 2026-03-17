*BREAK-POINT.
*break primus.
CLEAR str.
str = wa_stpox-mnglg.
CONDENSE str.
*data: TOT_Qty TYPE string.
DATA:
  ls_mat   TYPE cscmat,
  ls_stpo  TYPE t_stpo,
  ls_stpo1 TYPE stpox.

CLEAR: ls_stpo,ls_stpo1,gv_qty.

READ TABLE gt_stpo INTO ls_stpo
                   WITH KEY idnrk = wa_stpox-idnrk.
IF sy-subrc IS INITIAL.
  READ TABLE it_stpox INTO ls_stpo1
                      WITH KEY idnrk = ls_stpo-matnr.
  IF ls_stpo-rekrs = 'X'.
*    gv_qty = ls_stpo1-mnglg * wa_stpox-menge.
    gv_qty =  wa_stpox-mnglg.
 elseif
    gv_qty = ls_stpo1-mnglg * wa_stpox-menge.

  ENDIF.

ENDIF.
IF gv_qty IS INITIAL.
  gv_qty = wa_stpox-mnglg.
ENDIF.


TOT_Qty = TOT_Qty + gv_qty.







