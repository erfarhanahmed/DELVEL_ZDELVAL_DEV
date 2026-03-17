FUNCTION zsample_process_00001110.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_BUKRS) LIKE  BKPF-BUKRS
*"     VALUE(I_LIFNR) LIKE  BSEG-LIFNR
*"     VALUE(I_WAERS) LIKE  BKPF-WAERS
*"     VALUE(I_BLDAT) LIKE  BKPF-BLDAT
*"     VALUE(I_XBLNR) LIKE  BKPF-XBLNR
*"     VALUE(I_WRBTR) LIKE  BSEG-WRBTR OPTIONAL
*"     VALUE(I_BELNR) LIKE  BSEG-BELNR OPTIONAL
*"     VALUE(I_GJAHR) LIKE  BSEG-GJAHR OPTIONAL
*"     VALUE(I_BUZEI) LIKE  BSEG-BUZEI OPTIONAL
*"     VALUE(I_SHKZG) LIKE  BSEG-SHKZG
*"     VALUE(I_BLART) TYPE  BLART OPTIONAL
*"  EXPORTING
*"     VALUE(E_NOSTD) LIKE  BOOLE-BOOLE
*"----------------------------------------------------------------------


  DATA:  not_shkzg LIKE bseg-shkzg.
  DATA: lt_bsip TYPE TABLE OF bsip,
        wa_bsip TYPE bsip.
   DATA: lt_check TYPE TABLE OF bsip,
        wa_check TYPE bsip.
*  FIELD-SYMBOLS : <budat>  TYPE any .
*  ASSIGN ('(SAPLFDCB)INVFO-BUDAT') TO <budat>.
  not_shkzg = i_shkzg.
  TRANSLATE not_shkzg USING 'SHHS'.
  BREAK PRIMUS.

  IF i_xblnr = space.
    SELECT * INTO TABLE lt_bsip FROM bsip
     WHERE bukrs = i_bukrs
     AND   lifnr = i_lifnr
     AND   waers = i_waers
*del and   xblnr = i_xblnr
     AND   wrbtr = i_wrbtr
     AND   gjahr = i_gjahr
     AND   shkzg NE not_shkzg.
  ELSE.
    SELECT * INTO TABLE lt_bsip FROM bsip
     WHERE bukrs = i_bukrs
     AND   lifnr = i_lifnr
     AND   waers = i_waers
     AND   xblnr = i_xblnr
     AND   gjahr = i_gjahr.
*     AND   shkzg NE not_shkzg.
  ENDIF.

  LOOP AT lt_bsip INTO wa_bsip.
    SELECT SINGLE * FROM bkpf INTO @DATA(ls_bkpf) WHERE bukrs = @wa_bsip-bukrs AND belnr = @wa_bsip-belnr AND gjahr = @wa_bsip-gjahr.
    IF i_bukrs = 'US00' AND i_xblnr = wa_bsip-xblnr AND i_lifnr = wa_bsip-lifnr AND i_gjahr = wa_bsip-gjahr
     AND ls_bkpf-xreversal EQ '' AND ls_bkpf-stblg EQ ''.  " AND i_wrbtr = wa_bsip-wrbtr --> COMMENTED BY SNEHAL ON 03 FEB 2021

      CALL FUNCTION 'CUSTOMIZED_MESSAGE'
        EXPORTING
          i_arbgb = 'F5'
          i_dtype = 'W'
          i_msgnr = '117'
          i_var01 = wa_bsip-bukrs
          i_var02 = wa_bsip-belnr
          i_var03 = wa_bsip-gjahr.

*    ELSEIF i_bukrs NE 'US00' AND i_xblnr = wa_bsip-xblnr AND i_lifnr = wa_bsip-lifnr AND i_wrbtr = wa_bsip-wrbtr AND i_bldat = wa_bsip-bldat.
*
*      CALL FUNCTION 'CUSTOMIZED_MESSAGE'
*        EXPORTING
*          i_arbgb = 'F5'
*          i_dtype = 'W'
*          i_msgnr = '117'
*          i_var01 = wa_bsip-bukrs
*          i_var02 = wa_bsip-belnr
*          i_var03 = wa_bsip-gjahr.
    ENDIF.
    Clear ls_bkpf.
  ENDLOOP.


ENDFUNCTION.
