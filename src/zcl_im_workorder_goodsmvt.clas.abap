class ZCL_IM_WORKORDER_GOODSMVT definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_WORKORDER_GOODSMVT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_WORKORDER_GOODSMVT IMPLEMENTATION.


  method IF_EX_WORKORDER_GOODSMVT~BACKFLUSH.
  endmethod.


  method IF_EX_WORKORDER_GOODSMVT~COGI_AUTHORITY_CHECK.
  endmethod.


  method IF_EX_WORKORDER_GOODSMVT~COGI_POST.
    BREAK-POINT.
  endmethod.


  METHOD if_ex_workorder_goodsmvt~complete_goodsmovement.
****    IF ( sy-tcode = 'CO11N' OR sy-tcode = 'CO15' )." AND IS_COWB_HEADER-aueru = 'X'.
****
****      DATA : lv_bdmng TYPE resb-bdmng,
****             lv_enmng TYPE resb-enmng.
****
*****      SELECT SUM( bdmng ) FROM resb INTO lv_bdmng WHERE aufnr = is_cowb_header-aufnr
*****                                                  AND xloek NE 'X' .
****
****
****      SELECT SUM( enmng ) FROM resb INTO lv_enmng WHERE aufnr = is_cowb_header-aufnr
****                                                    AND xloek NE 'X' .
****
****      IF lv_enmng LT cs_cowb_comp-erfmg .
****        MESSAGE 'Material Shortages exists or partial quantity confirmation' TYPE 'E' . "DISPLAY LIKE 'I'.
****        SET SCREEN sy-dynnr.
****        LEAVE SCREEN.
****      ENDIF.
****    ENDIF.
  ENDMETHOD.


  method IF_EX_WORKORDER_GOODSMVT~GM_SCREEN_LINE_CHECK.
  endmethod.


  method IF_EX_WORKORDER_GOODSMVT~GM_SCREEN_OKCODE_CHECK.
  endmethod.


  method IF_EX_WORKORDER_GOODSMVT~GM_WIPBATCH_CHECK.
  endmethod.


  method IF_EX_WORKORDER_GOODSMVT~GM_WIPBATCH_PROPOSE.
  endmethod.


  method IF_EX_WORKORDER_GOODSMVT~GOODS_RECEIPT.

  endmethod.


  method IF_EX_WORKORDER_GOODSMVT~IM_CALLED.
  endmethod.


  method IF_EX_WORKORDER_GOODSMVT~IM_CALLED_PICKLIST.
  endmethod.


  method IF_EX_WORKORDER_GOODSMVT~MANUAL_GOODS_RECEIPT.
  endmethod.


  method IF_EX_WORKORDER_GOODSMVT~PICKLIST.
  endmethod.
ENDCLASS.
