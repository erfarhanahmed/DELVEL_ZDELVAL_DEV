*&---------------------------------------------------------------------*
*&  Include           ZVEHICAL_DETAILS_NEW_O01
*&---------------------------------------------------------------------*

*&SPWIZARD: OUTPUT MODULE FOR TC 'TABC'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
module tabc_change_tc_attr output.
*  DESCRIBE TABLE I_VEHICAL LINES TABC-lines.

  if sy-tcode = 'VF02' or sy-tcode = 'VF03'.



    field-symbols : <fs> type any .
    assign ('(SAPMV60A)VBRK-VBELN') to <fs>.

    if <fs> is assigned.
      if i_vehical is initial .

        select * from ZVEHICLE_TB into corresponding fields of table i_vehical
               where billing_no = <fs>.
      endif.

**      append s_vehical to i_vehical.
      clear s_vehical.

    endif.

  endif.



endmodule.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TABC'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GET LINES OF TABLECONTROL
module tabc_get_lines output.
  g_tabc_lines = sy-loopc.
  if sy-tcode = 'VF02' and s_vehical-sr_no is not initial.
    loop at screen.
      if screen-name = 'S_VEHICAL-SR_NO'.
        screen-input = 0.
        modify screen.
      endif.
    endloop.
  endif.


  if  sy-tcode = 'VF03'.
    loop at screen.
      if screen-group4 = 'SC1'.
        screen-input = 0.
        modify screen.
      endif.
    endloop.
  endif.

endmodule.
