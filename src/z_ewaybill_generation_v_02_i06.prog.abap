*&---------------------------------------------------------------------*
*& Include          Z_EWAYBILL_GENERATION_V_02_I06
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0900  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0900 INPUT.
*CASE sy-ucomm.
*     WHEN '&CAN' OR 'CANCEL'.
**        SET SCREEN '0'.
*      LEAVE to SCREEN 700.
**      WHEN '&BACK'.
**        LEAVE TO SCREEN 600.
*     WHEN '&SAVE'   .
*         LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
*        gs_eway_multi_veh-bukrs           =    ls_final-bukrs.
*        gs_eway_multi_veh-vbeln           =    ls_final-vbeln.
*        gs_eway_multi_veh-GROUP1          =    zeway_MULTI_VEH-GROUP1.
*        gs_eway_multi_veh-OLD_VEHICAL     =    zeway_MULTI_VEH-OLD_VEHICAL.
*        gs_eway_multi_veh-NEW_VEHICAL     =    zeway_MULTI_VEH-NEW_VEHICAL.
*        gs_eway_multi_veh-OLD_TRANS_NO    =    zeway_MULTI_VEH-OLD_TRANS_NO.
*        gs_eway_multi_veh-NEW_TRANS_NO    =    zeway_MULTI_VEH-NEW_TRANS_NO.
*        gs_eway_multi_veh-FROMPLACE       =    zeway_MULTI_VEH-FROMPLACE.
*        gs_eway_multi_veh-FROMSTATECODE   =    zeway_MULTI_VEH-FROMSTATECODE.
*        gs_eway_multi_veh-REASONCODE      =    zeway_MULTI_VEH-REASONCODE.
*        gs_eway_multi_veh-REASON          =    zeway_MULTI_VEH-REASON.
*        gs_eway_multi_veh-lifnr           =    zeway_bill-lifnr.
*        gs_eway_multi_veh-eway_bill           =    ls_final-eway_bil.
*        APPEND gs_eway_multi_veh TO gt_eway_multi_veh.
*      ENDLOOP.
*
*      IF gt_eway_multi_veh IS NOT INITIAL.
*        MODIFY zeway_multi_veh FROM TABLE gt_eway_multi_veh.
*        CLEAR : gs_eway_multi_veh.
*        REFRESH : gt_eway_multi_veh.
*      ENDIF.
*  WHEN OTHERS.
*  ENDCASE.
ENDMODULE.
