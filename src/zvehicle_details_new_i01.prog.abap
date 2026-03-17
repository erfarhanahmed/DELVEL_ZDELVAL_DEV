*&---------------------------------------------------------------------*
*&  Include           ZVEHICAL_DETAILS_NEW_I01
*&---------------------------------------------------------------------*

*&SPWIZARD: INPUT MODULE FOR TC 'TABC'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MODIFY TABLE
module tabc_modify input.
  modify i_vehical
    from s_vehical
    index tabc-current_line.


 IF sy-subrc <> 0 AND S_VEHICAL IS NOT INITIAL.
   APPEND S_VEHICAL TO I_VEHICAL.
   CLEAR S_VEHICAL.
 ENDIF.
endmodule.

*&SPWIZARD: INPUT MODUL FOR TC 'TABC'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MARK TABLE
module tabc_mark input.
  data: g_tabc_wa2 like line of i_vehical.
  if tabc-line_sel_mode = 1
  and s_vehical-sel = 'X'.
    loop at i_vehical into g_tabc_wa2
      where sel = 'X'.
      g_tabc_wa2-sel = ''.
      modify i_vehical
        from g_tabc_wa2
        transporting sel.
    endloop.
  endif.
  modify i_vehical
    from s_vehical
    index tabc-current_line
    transporting sel.
endmodule.

*&SPWIZARD: INPUT MODULE FOR TC 'TABC'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: PROCESS USER COMMAND
module tabc_user_command input.
  ok_code = sy-ucomm.
  perform user_ok_tc using    'TABC'
                              'I_VEHICAL'
                              'SEL'
                     changing ok_code.
  sy-ucomm = ok_code.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_5001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_5001 input.

  field-symbols : <fs1> type any .
  assign ('(SAPMV60A)VBRK-VBELN') to <fs1>.
  if sy-tcode = 'VF01'.
  if <fs1> is assigned.
    loop at i_vehical into data(ls_vehical).

      if ls_vehical-sr_no is not initial.
        select count(*) from ZVEHICLE_TB where billing_no = <fs1> and sr_no = ls_vehical-sr_no.
        if sy-subrc = 0.
          update ZVEHICLE_TB set vehical_no = ls_vehical-vehical_no
                                      quantity  = ls_vehical-quantity
                                      unit_of_measure = ls_vehical-unit_of_measure
                                  where billing_no = <fs1>
                                    and sr_no = ls_vehical-sr_no.

        else.
          data : ls_veh type ZVEHICLE_TB.

          ls_veh-billing_no = <fs1>.
          ls_veh-sr_no = ls_vehical-sr_no.
          ls_veh-quantity = ls_vehical-quantity.
          ls_veh-unit_of_measure = ls_vehical-unit_of_measure.
          ls_veh-vehical_no = ls_vehical-vehical_no.

          insert ZVEHICLE_TB from ls_veh.
        endif.
      endif.
    endloop.


  endif.
    export i_vehical to memory id 'ABCD'.
  endif.




  if sy-tcode = 'VF02'.
*    if sy-ucomm = 'SAVE'.
    if sy-ucomm = 'SICH'.
      data : Gs_veh type ZVEHICLE_TB.

      delete from ZVEHICLE_TB where  billing_no = <FS1>.
*                              and   billing_no = S_vehical-vbeln.

      loop at i_vehical into s_vehical.

        Gs_veh-billing_no = <fs1>.
        Gs_veh-sr_no = s_vehical-sr_no.
        Gs_veh-quantity = s_vehical-quantity.
        Gs_veh-unit_of_measure = s_vehical-unit_of_measure.
        Gs_veh-vehical_no = s_vehical-vehical_no.

        insert ZVEHICLE_TB from Gs_veh.
      endloop.
    endif.
  endif.

endmodule.
