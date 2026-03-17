*&---------------------------------------------------------------------*
*& Include          Z_EWAYBILL_GENERATION_V_02_I05
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0800  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0800 INPUT.
*  CASE sy-ucomm.
*     WHEN '&CAN' OR 'CANCEL'.
**      SET SCREEN '0'.
*      LEAVE to SCREEN 700.
**      WHEN '&BACK'.
**        LEAVE TO SCREEN 600.
*     WHEN '&SAVE'.
*
*     LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
*        gs_eway_multi_veh-bukrs           =    ls_final-bukrs.
*        gs_eway_multi_veh-vbeln           =    ls_final-vbeln.
*        gs_eway_multi_veh-GROUP1          =    zeway_multi_veh-GROUP1.
*        gs_eway_multi_veh-VEHICAL_NO      =  zeway_multi_veh-VEHICAL_NO.
*        gs_eway_multi_veh-TRANS_DOC       =  zeway_multi_veh-TRANS_DOC.
*        gs_eway_multi_veh-DOC_DT          =  zeway_multi_veh-DOC_DT.
*        gs_eway_multi_veh-QTY             =  zeway_multi_veh-QTY.
*        gs_eway_multi_veh-lifnr           =  zeway_bill-lifnr.
*        gs_eway_multi_veh-eway_bill       =  ls_final-eway_bil.
*        APPEND gs_eway_multi_veh TO gt_eway_multi_veh.
*      ENDLOOP.
*
*      IF gt_eway_multi_veh IS NOT INITIAL.
*        MODIFY zeway_multi_veh FROM TABLE gt_eway_multi_veh.
*        CLEAR : gs_eway_multi_veh.
*        REFRESH : gt_eway_multi_veh.
*      ENDIF.
*
*
*
*  WHEN OTHERS.
*  ENDCASE.
ENDMODULE.
