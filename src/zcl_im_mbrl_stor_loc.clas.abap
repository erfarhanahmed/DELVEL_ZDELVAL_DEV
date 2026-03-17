class ZCL_IM_MBRL_STOR_LOC definition
  public
  final
  create public .

public section.

  interfaces IF_EX_MB_STOR_LOC_BADI_GTS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_MBRL_STOR_LOC IMPLEMENTATION.


  method IF_EX_MB_STOR_LOC_BADI_GTS~CHANGE_STOR_LOC_GTS.
    DATA: lv_bname   TYPE zhead_user-bname.
    DATA: LV_LGORT  TYPE MSEG-lgort.

 IF sy-tcode = 'MBRL'.
*      SELECT SINGLE bname FROM zhead_user INTO lv_bname WHERE trans = sy-tcode.

*     IF sy-uname = lv_bname.
       if sy-uname = 'VMHATUGADE'.
       LGORT = 'KPRD'.
       elseif sy-uname = 'MKHANDAIT'.
       LGORT = 'PRD1'.
       endif.
*     ENDIF.

 ENDIF.

  endmethod.
ENDCLASS.
