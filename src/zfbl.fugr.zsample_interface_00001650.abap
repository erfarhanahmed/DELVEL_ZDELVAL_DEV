FUNCTION zsample_interface_00001650.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_POSTAB) LIKE  RFPOS STRUCTURE  RFPOS
*"  EXPORTING
*"     VALUE(E_POSTAB) LIKE  RFPOS STRUCTURE  RFPOS
*"----------------------------------------------------------------------

*-------------- Initialize Output by using the following line ----------
* E_POSTAB = I_POSTAB.

  e_postab = i_postab.

  TABLES : bseg, lfa1,rbkp,bkpf,rseg.
  TABLES:skat,kna1.
  DATA: v_kunnr TYPE kunnr,
        v_lifnr TYPE lifnr,
        v_zuonr TYPE bseg-zuonr,
        v_matnr TYPE bseg-matnr,
        v_qty   TYPE mseg-menge,
        v_brgew TYPE mara-brgew,
        v_ton   TYPE mara-brgew.

  TYPES : BEGIN OF t_mkpf,
            mblnr TYPE mkpf-mblnr,
            mjahr TYPE mkpf-mjahr,
          END OF t_mkpf.
  DATA : gt_mkpf TYPE TABLE OF t_mkpf,
         gs_mkpf TYPE t_mkpf.

  TYPES : BEGIN OF t_mseg,
            mblnr TYPE mseg-mblnr,
            mjahr TYPE mseg-mjahr,
            bwart TYPE mseg-bwart,
            menge TYPE mseg-menge,
            lifnr TYPE mseg-lifnr,
            werks TYPE mseg-werks,
            bukrs TYPE mseg-werks,
          END OF t_mseg.
  DATA : gt_mseg TYPE TABLE OF t_mseg,
         gs_mseg TYPE t_mseg.
  DATA : gv_hkont TYPE bseg-hkont,
         gv_buzei TYPE bseg-buzei.
  DATA : gv_count TYPE bseg-buzei.
  DATA : rem TYPE i.
  e_postab-zlifnr  =  i_postab-konto.

********************************MIRO Document Number***********************************************
  SELECT SINGLE awkey INTO e_postab-zmiro FROM bkpf WHERE belnr EQ i_postab-belnr
                                                      AND bukrs EQ i_postab-bukrs
                                                      AND gjahr EQ i_postab-gjahr
                                                      AND blart EQ 'RE'.
  IF syst-tcode = 'FBL3N' OR syst-tcode = 'FBL1N' OR syst-tcode = 'FBL5N'.

********************************Customer Code***********************************************
    SELECT SINGLE kunnr INTO v_kunnr FROM bseg WHERE belnr EQ i_postab-belnr
                                                   AND bukrs EQ i_postab-bukrs
                                                   AND gjahr EQ i_postab-gjahr
                                                   AND kunnr NE space.
    e_postab-zkunnr = v_kunnr.

********************************Customer Name***********************************************

    SELECT SINGLE name1 INTO e_postab-zc_name FROM kna1 WHERE kunnr EQ v_kunnr.

********************************Vendor Code*************************************************

    SELECT SINGLE lifnr INTO v_lifnr FROM bseg WHERE belnr EQ i_postab-belnr
                                                 AND bukrs EQ i_postab-bukrs
                                                 AND gjahr EQ i_postab-gjahr
                                                 AND Lifnr NE space.
    e_postab-zlifnr = v_lifnr.

********************************Vendor Name*************************************************

    SELECT SINGLE name1 INTO e_postab-zname1 FROM lfa1 WHERE lifnr EQ v_lifnr.

********************************Material Weight***********************************************

    SELECT SINGLE matnr menge INTO (v_matnr, v_qty) FROM bseg WHERE belnr EQ i_postab-belnr
                                                       AND bukrs EQ i_postab-bukrs
                                                       AND gjahr EQ i_postab-gjahr
                                                       AND hkont EQ i_postab-hkont
                                                       AND buzei EQ i_postab-buzei.

********************************Weight in ton***********************************************
    SELECT SINGLE brgew INTO v_brgew FROM mara WHERE matnr EQ v_matnr.
    IF v_brgew IS NOT INITIAL.
      v_ton = ( ( v_qty * v_brgew ) / 1000 ).        " WEIGHT IN TONS = ( I/P QUANTITY * GROSS WEIGHT ) / 1000000 .
    ENDIF.

    e_postab-zunit = v_ton.

    CLEAR : v_matnr, v_qty, v_brgew, v_ton.
    IF i_postab-bukrs = 'US00'.
      IF i_postab-buzei MOD 2 EQ 0.
        gv_buzei = '001'.
        gv_buzei  = gv_buzei  - i_postab-buzei.
        SELECT SINGLE hkont INTO gv_hkont FROM bseg WHERE belnr EQ i_postab-belnr
                                                        AND bukrs EQ i_postab-bukrs
                                                        AND gjahr EQ i_postab-gjahr
                                                        AND buzei EQ gv_buzei.
        IF gv_hkont IS NOT INITIAL.
          e_postab-gkont = gv_hkont.
        ENDIF.
        CLEAR: gv_buzei, gv_hkont.
      ELSEIF i_postab-buzei MOD 2 <> 0.
        gv_buzei = '001'.
        gv_buzei  = gv_buzei  + i_postab-buzei.
        SELECT SINGLE hkont INTO gv_hkont FROM bseg WHERE belnr EQ i_postab-belnr
                                                        AND bukrs EQ i_postab-bukrs
                                                        AND gjahr EQ i_postab-gjahr
                                                        AND buzei EQ gv_buzei.
        IF gv_hkont IS NOT INITIAL.
          e_postab-gkont = gv_hkont.
        ENDIF.
        CLEAR: gv_buzei, gv_hkont.

      ENDIF.
    ENDIF.
    IF sy-tcode = 'FBL3N' OR syst-tcode = 'FBL1N' OR syst-tcode = 'FBL5N'.
      e_postab-gkart = 'S'.
      SELECT SINGLE * FROM skat WHERE spras = sy-langu AND saknr = e_postab-gkont.
      IF sy-subrc = 0.
        e_postab-zzgkont_ltxt = skat-txt50         .
      ENDIF.
    ELSEIF
      e_postab-gkart = 'D'.
      SELECT SINGLE * FROM kna1 WHERE kunnr = e_postab-gkont.
      IF sy-subrc = 0.
        e_postab-zzgkont_ltxt = kna1-name1.
      ENDIF.
    ELSEIF e_postab-gkart = 'K'.
      SELECT SINGLE * FROM lfa1 WHERE lifnr = e_postab-gkont.
      IF sy-subrc = 0.
        e_postab-zzgkont_ltxt = lfa1-name1.
      ENDIF.
    ENDIF.

    IF sy-tcode = 'FBL3N'.
      CLEAR : e_postab-trade_p_number, e_postab-trade_p_desc.

      IF e_postab-zlifnr IS NOT INITIAL.
        SELECT SINGLE trade_p_number, trade_p_desc
          FROM zfi_trade_partnr
          INTO ( @e_postab-trade_p_number,
                 @e_postab-trade_p_desc )
          WHERE lifnr = @e_postab-zlifnr
            and from_date le @e_postab-BUDAT
            and to_date   ge @e_postab-BUDAT.
      ENDIF.

      IF e_postab-zkunnr IS NOT INITIAL.
        SELECT SINGLE trade_p_number, trade_p_desc
          FROM zfi_trade_partnr
          INTO ( @e_postab-trade_p_number,
                 @e_postab-trade_p_desc )
          WHERE kuunr = @e_postab-zkunnr
            and from_date le @e_postab-BUDAT
            and to_date   ge @e_postab-BUDAT.
      ENDIF.

    ENDIF.


  ENDIF.
ENDFUNCTION.
