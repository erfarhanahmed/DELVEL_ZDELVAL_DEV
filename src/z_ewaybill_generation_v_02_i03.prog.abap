*----------------------------------------------------------------------*
***INCLUDE Z_EWAYBILL_GENERATION_V_02_I03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0700  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0700 INPUT.
DATA : sr_no TYPe i,
       lv_bukrs type bukrs,
       lv_vbeln TYPE vbeln.
  CASE sy-ucomm.
     WHEN '&CAN' OR 'CANCEL'.
      SET SCREEN '0'.
      LEAVE SCREEN.

       WHEN '&SAVE' .
*BREAK primus.
CLEAR :gs_eway_multi_veh.
REFRESH :gt_eway_multi_veh.
select max( sr_no ) INTO @data(lv_no) FROM zeway_multi_veh.

      LOOP AT lt_final ASSIGNING <ls_final> WHERE selection = 'X'.
      if lv_no is INITIAL .
       gs_eway_multi_veh-sr_no            =    1.
      endif.
        gs_eway_multi_veh-sr_no           =    lv_no + 1.
        gs_eway_multi_veh-bukrs           =    <ls_final>-bukrs.
        gs_eway_multi_veh-vbeln           =    <ls_final>-vbeln.
        gs_eway_multi_veh-REASONCODE      =    zeway_multi_veh-REASONCODE.
        gs_eway_multi_veh-fromplace       =    zeway_multi_veh-fromplace.
        gs_eway_multi_veh-fromstatecode   =    zeway_multi_veh-fromstatecode.
        gs_eway_multi_veh-trns_md         =    zeway_multi_veh-trns_md.
        gs_eway_multi_veh-unit            =    zeway_multi_veh-unit.
        gs_eway_multi_veh-reason          =    zeway_multi_veh-reason.
        gs_eway_multi_veh-to_place        =    zeway_multi_veh-TO_PLACE.
        gs_eway_multi_veh-to_state        =    zeway_multi_veh-TO_state.
        gs_eway_multi_veh-tot_qty         =    zeway_multi_veh-TOt_qty.
        gs_eway_multi_veh-lifnr           =    zeway_bill-lifnr.
        gs_eway_multi_veh-eway_bill       =    <ls_final>-eway_bil.
        gs_eway_multi_veh-GROUP1          =    zeway_multi_veh-GROUP1.
        gs_eway_multi_veh-VEHICAL_NO      =   zeway_multi_veh-VEHICAL_NO.
        gs_eway_multi_veh-TRANS_DOC       =   zeway_multi_veh-TRANS_DOC.
        gs_eway_multi_veh-DOC_DT          =   zeway_multi_veh-DOC_DT.
        gs_eway_multi_veh-QTY             =   zeway_multi_veh-QTY.
        gs_eway_multi_veh-OLD_VEHICAL     =    zeway_MULTI_VEH-OLD_VEHICAL.
        gs_eway_multi_veh-NEW_VEHICAL     =    zeway_MULTI_VEH-NEW_VEHICAL.
        gs_eway_multi_veh-OLD_TRANS_NO    =    zeway_MULTI_VEH-OLD_TRANS_NO.
        gs_eway_multi_veh-NEW_TRANS_NO    =    zeway_MULTI_VEH-NEW_TRANS_NO..
        APPEND gs_eway_multi_veh TO gt_eway_multi_veh.
      ENDLOOP.

*      IF gt_eway_multi_veh IS NOT INITIAL.
*        modify zeway_multi_veh FROM TABLE gt_eway_multi_veh.
*       CLEAR : gs_eway_multi_veh.
*        REFRESH : gt_eway_multi_veh.
*      ENDIF.
IF R1 = 'X' .
PERFORM multi_vehical.
ENDIF.
IF R2 = 'X'.
PERFORM multi_vehical_add.
ENDIF.
*BREAK primu.
IF R3 = 'X'.
PERFORM multi_vehical_chng.
ENDIF.
*
*      SET SCREEN '0'.
*      LEAVE SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
