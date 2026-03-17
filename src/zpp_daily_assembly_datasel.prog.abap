*&---------------------------------------------------------------------*
*&  Include           ZPP_DA_ASSEMBLY_DATASEL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  INCLUDE           ZPP_SO_SHORTAGES_COPY_DATASEL
*&---------------------------------------------------------------------*
****SELECTION SCREEN RESULT

AT SELECTION-SCREEN.

  IF p_werks IS INITIAL.
    MESSAGE e023.
  ENDIF.

START-OF-SELECTION.

  PERFORM data_plant.
************************************************************************
FORM data_plant .
  CLEAR : it_data .
  REFRESH : it_data .

  SELECT a~vbeln a~posnr a~matnr a~arktx a~werks a~meins d~edatu d~wmeng d~etenr c~lfsta
  INTO CORRESPONDING FIELDS OF TABLE it_data
  FROM  vbep AS d
  JOIN vbap AS a ON ( a~vbeln = d~vbeln  AND a~posnr = d~posnr )
  JOIN  vbup AS c ON ( c~vbeln = a~vbeln  AND c~posnr = a~posnr )
  WHERE a~werks  = p_werks
  AND   a~vbeln IN s_vbeln
  AND c~lfsta  IN s_status
    AND c~lfgsa  IN s_lfgsa
  AND d~edatu  IN s_cdd  " Schedule line date
  AND d~wmeng NE 0.

  SORT it_data BY edatu vbeln posnr.

  """"""""""""""        Added By KD 05.05.2017      """""""""""""""""
  SELECT matnr werks dispo sfcpf FROM marc INTO TABLE it_marc
                                      FOR ALL ENTRIES IN it_data
                                          WHERE matnr = it_data-matnr
                                            AND werks = it_data-werks .

  SELECT plnum matnr plwrk psttr kdauf kdpos FROM plaf INTO TABLE it_plaf
                                              FOR ALL ENTRIES IN it_data
                                                    WHERE kdauf = it_data-vbeln
                                                      AND kdpos = it_data-posnr.

  """""""""""""""""        END 05.05.2017        """"""""""""""""""""
  PERFORM bom_explode.
  SORT it_tot_stk.
  DELETE ADJACENT DUPLICATES FROM it_tot_stk COMPARING component comp_total_stk.
*  Perform sort_table_build CHANGING i_sort[].
  PERFORM stp3_eventtab_build   CHANGING gt_events[].
  PERFORM comment_build         CHANGING i_list_top_of_page[].
*  perform top_of_page.
  PERFORM data_display.
  PERFORM layout_build     CHANGING wa_layout.

ENDFORM.                    " DATA_PLANT


*&---------------------------------------------------------------------*
*&      FORM  BOM_EXPLODE
*&---------------------------------------------------------------------*
*  Data Fetching
*----------------------------------------------------------------------*

FORM bom_explode .

  CLEAR: itab_final, wa_itab_final, pending_qty.
  REFRESH itab_final.

  LOOP AT it_data INTO wa_data.

    REFRESH it_mdps.

*For Pending Qty
    CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
      EXPORTING
        matnr                    = wa_data-matnr
        werks                    = p_werks
      TABLES
        mdpsx                    = it_mdps
*       MDEZX                    =
*       MDSUX                    =
      EXCEPTIONS
        material_plant_not_found = 1
        plant_not_found          = 2
        OTHERS                   = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    CLEAR: wa_mdps, so_stk, ref_pp_stk , pending_qty.
*Pending Qty = VBEP-WMENG - Delivered Qty (lips-LFIMG) - Sales Order Stock(from MDPS)
*              - Sales order referenced Production Order (From MDPS)
*    LOOP AT IT_MDPS INTO WA_MDPS.
    LOOP AT it_mdps INTO wa_mdps WHERE kdauf = wa_data-vbeln
                                   AND kdpos = wa_data-posnr.
      IF  wa_mdps-delkz = 'KB' AND wa_mdps-kdauf = wa_data-vbeln
                              AND wa_mdps-kdpos = wa_data-posnr.
        so_stk          =  so_stk   + wa_mdps-mng01.
      ENDIF.
      IF   wa_mdps-delkz = 'FE' AND wa_mdps-kdauf = wa_data-vbeln
                                AND wa_mdps-kdpos = wa_data-posnr.
        ref_pp_stk = ref_pp_stk + wa_mdps-mng01.
      ENDIF.
    ENDLOOP.
    CLEAR : it_vbfa, it_lips, wa_vbfa, wa_lfimg, wa_lips .
    REFRESH : it_vbfa, it_lips, it_delivary.

*select delivery for pending qty
    SELECT vbeln posnv vbtyp_n bwart FROM vbfa
*    INTO TABLE IT_VBFA
    INTO TABLE it_delivary
    WHERE vbelv = wa_data-vbeln
*    AND POSNV   = WA_DATA-POSNR.
    AND posnv   = wa_data-posnr
    AND vbtyp_n =  'J'.

    REFRESH it_lips.
*select delivered QTY for the delivaries selected above
    IF it_delivary IS NOT INITIAL.
      SELECT lfimg
             FROM lips
             INTO TABLE it_lips
          FOR ALL ENTRIES IN it_delivary
          WHERE vbeln = it_delivary-vbeln
          AND posnr = it_delivary-posnv.
    ENDIF.
    CLEAR wa_lfimg.
    LOOP AT it_lips INTO wa_lips.
      wa_lfimg = wa_lfimg + wa_lips-lfimg.
    ENDLOOP.

    pending_qty = wa_data-wmeng - wa_lfimg - so_stk - ref_pp_stk .
    IF pending_qty < 0.
      pending_qty = 0.
    ENDIF.
******************************************************************
*find can-be for all components for sales order line item sum it and
*display for sales order line item
    PERFORM bom_fm TABLES t_stb
                USING   pending_qty         "Reqd Qty
                        wa_data-matnr       "Material for which BOM needs to be exploded
                        wa_data-werks.      "P_WERKS.

    LOOP AT t_stb INTO wa_stb. " component can-be qty calculations
*to be summed for a single vbeln posnr in this loop

      CLEAR: it_mdps.
      REFRESH it_mdps.

      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          matnr                    = wa_stb-idnrk
          werks                    = p_werks
        TABLES
          mdpsx                    = it_mdps
*         MDEZX                    =
*         MDSUX                    =
        EXCEPTIONS
          material_plant_not_found = 1
          plant_not_found          = 2
          OTHERS                   = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
* DATA PASSED TO INTERNAL TABLE IT_MDPS FROM FM.
* CALCULATION TO BE DONE ON FIELD MRP ELEMENT (DELKZ) BASES ON THE CRITERIA.
      CLEAR: wa_mdps, stock_reserve, mdps_so_stk .

      LOOP AT it_mdps INTO wa_mdps.
        IF   wa_mdps-delkz = 'AR'." and wa_mdps-plumi <> '+'.
          stock_reserve = stock_reserve + wa_mdps-mng01.
        ENDIF.
        IF   wa_mdps-delkz = 'KB' AND wa_mdps-kdauf EQ wa_data-vbeln " mdps_so_stk is
                                  AND wa_mdps-kdpos EQ wa_data-posnr. "component so stk
          mdps_so_stk = mdps_so_stk + wa_mdps-mng01.
        ENDIF.
      ENDLOOP.



*Total stock = unrestricted + quality + blocked + SO - reserve qty
      CLEAR: unrestrict_stock, stock_quality, blocked_stk .

      SELECT SUM( labst )
          SUM( insme )
*          SUM( SPEME )
          FROM mard
    INTO (unrestrict_stock ,
*           STOCK_QUALITY, BLOCKED_STK )
           stock_quality )
    WHERE matnr = wa_stb-idnrk
    AND werks = p_werks
*    AND LGORT <> 'RJ01' AND LGORT <> 'SCR1'.
    AND lgort = 'RM01'." AND LGORT <> 'SCR1'.

*******start of Logic for Maxum possible can-be qty*******
*TOTAL_STOCK is component total stock
      CLEAR total_stock.
*      TOTAL_STOCK = UNRESTRICT_STOCK + STOCK_QUALITY + BLOCKED_STK
      total_stock = unrestrict_stock + stock_quality + mdps_so_stk - stock_reserve .
*TEMP STOCK
      temp_stock =  unrestrict_stock + stock_quality  - stock_reserve .
      IF temp_stock < 0.
        temp_stock = 0.
      ENDIF.
*save sales order & TEMP STOCK  stock in a table
* mdps_so_stk
      CLEAR wa_so_stk.
      wa_so_stk-so = wa_data-vbeln.
      wa_so_stk-item = wa_data-posnr.
      wa_so_stk-component = wa_stb-idnrk.
      wa_so_stk-so_qty = mdps_so_stk.
      wa_so_stk-temp_stock = temp_stock.
      APPEND wa_so_stk TO it_so_stk.
      SORT it_tot_stk.
      READ TABLE it_tot_stk INTO wa_tot_stk WITH KEY component = wa_stb-idnrk.
      IF sy-subrc = 0.
        total_stock = wa_tot_stk-comp_total_stk + mdps_so_stk.
      ELSEIF sy-subrc <> 0.
*store component wise Total stock for all header meaterial components
*in another internal table
        CLEAR :wa_comp_qty.
*      wa_comp_qty-HEADER_MATERIAL = wa_DATA-MATNR.
        wa_comp_qty-component  = wa_stb-idnrk.
        wa_comp_qty-comp_total_stk  = total_stock.
        wa_comp_qty-temp_stock = temp_stock.
        APPEND wa_comp_qty TO it_tot_stk.
      ENDIF.
      IF total_stock < 0.
        total_stock = 0.
      ENDIF.

      SORT it_tot_stk.
      DELETE ADJACENT DUPLICATES FROM it_tot_stk COMPARING component comp_total_stk.


      IF wa_stb-mnglg <> 0.
        comp_canbe  = ( ( total_stock * pending_qty ) / wa_stb-mnglg ).
      ELSEIF wa_stb-mnglg = 0.
        comp_canbe = 0.
      ENDIF.

*if component can be is greater than Pending quantity
      IF comp_canbe > pending_qty.
        comp_canbe = pending_qty.
      ENDIF.

      CLEAR : wa_comp_canbe.
      wa_comp_canbe-comp_canbe = comp_canbe.
      APPEND wa_comp_canbe TO it_comp_canbe.

    ENDLOOP. " loop at stb for component can be calculation
*****REFRESH TABLE AND CLEAR WORK AREA.
    REFRESH t_stb.
    CLEAR: wa_stb.

*find the least can be qty & Also compare with Pending qty
    CLEAR: wa_comp_canbe, lv_actul_canbe.
    LOOP AT it_comp_canbe INTO wa_comp_canbe.
      IF sy-tabix = 1.
        lv_actul_canbe = wa_comp_canbe-comp_canbe.
      ENDIF.
      IF wa_comp_canbe-comp_canbe < lv_actul_canbe.
        lv_actul_canbe = wa_comp_canbe-comp_canbe.
      ENDIF.
    ENDLOOP.
*if least can be qty is < 0
    IF lv_actul_canbe < 0.
      lv_actul_canbe = 0.
    ENDIF.
    CLEAR: it_comp_canbe, lt_stb.
    REFRESH: it_comp_canbe, lt_stb .

    lv_actul_canbe = trunc( lv_actul_canbe ).


**Maximum can be "lv_Actul_canbe"
    IF lv_actul_canbe <> 0.
      PERFORM bom_fm TABLES lt_stb
                   USING  lv_actul_canbe       "Reqd Qty
                           wa_data-matnr       "Material for which BOM needs to be exploded
                           wa_data-werks.      "P_WERKS.

      CLEAR: lwa_stb,wa_max_comp_canbe.
      REFRESH it_max_comp_canbe.
      LOOP AT lt_stb INTO lwa_stb.
        wa_max_comp_canbe-component  = lwa_stb-idnrk.
        wa_max_comp_canbe-comp_canbe = lwa_stb-mnglg.
        APPEND wa_max_comp_canbe TO it_max_comp_canbe.
      ENDLOOP.



      CLEAR: wa_comp_qty, wa_max_comp_canbe.


      LOOP AT it_tot_stk INTO  wa_comp_qty.
        SORT it_max_comp_canbe.
        READ TABLE it_max_comp_canbe INTO wa_max_comp_canbe WITH KEY
                                 component = wa_comp_qty-component.
        IF sy-subrc = 0.
          CLEAR wa_so_stk.
          READ TABLE it_so_stk INTO wa_so_stk WITH KEY
                                 so = wa_data-vbeln
                                 item = wa_data-posnr
                                 component = wa_comp_qty-component .
          IF sy-subrc = 0.
            CLEAR lv_qty.
            lv_qty =  wa_so_stk-so_qty - wa_max_comp_canbe-comp_canbe .
            IF lv_qty >= 0.
*              wa_comp_qty-comp_total_stk = WA_SO_STK-temp_STOCK.
              wa_comp_qty-comp_total_stk = wa_comp_qty-temp_stock.
              wa_comp_qty-temp_stock = wa_comp_qty-comp_total_stk.
              IF wa_comp_qty-comp_total_stk < 0.
                wa_comp_qty-comp_total_stk = 0.
              ENDIF.
              IF wa_comp_qty-temp_stock < 0.
                wa_comp_qty-temp_stock = 0.
              ENDIF.
              MODIFY it_tot_stk FROM wa_comp_qty.
              CLEAR lv_qty.
            ELSEIF lv_qty < 0.
*              wa_comp_qty-comp_total_stk = LV_QTY + WA_SO_STK-temp_STOCK.
              wa_comp_qty-comp_total_stk = lv_qty + wa_comp_qty-temp_stock.
              wa_comp_qty-temp_stock = wa_comp_qty-comp_total_stk.
              IF wa_comp_qty-comp_total_stk < 0.
                wa_comp_qty-comp_total_stk = 0.
              ENDIF.
              IF wa_comp_qty-temp_stock < 0.
                wa_comp_qty-temp_stock = 0.
              ENDIF.
              MODIFY it_tot_stk FROM wa_comp_qty.
              CLEAR lv_qty.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
****************************************************************************

    ENDIF. "lv_Actul_canbe <> 0
*process & APPEND lv_Actul_canbe AS Maximum possible can be qty after processing
*in the in the above loop pass
*for the current sales order and line item
**********End of Logic for Maximum possible can-be qty********

*Sales Order Rate
    CLEAR: lv_knumv, lv_kbetr.
    SELECT SINGLE knumv  FROM vbak INTO lv_knumv WHERE vbeln = wa_data-vbeln .
    SELECT SINGLE
           kbetr
    FROM   prcd_elements
    INTO lv_kbetr
    WHERE knumv = lv_knumv
      AND kposn = wa_data-posnr
      AND kschl = 'ZPR0'.

*Name of Customer
    CLEAR: lv_kunnr, lv_name1.
    SELECT SINGLE kunnr FROM vbak INTO lv_kunnr WHERE vbeln = wa_data-vbeln .
    SELECT SINGLE name1 FROM kna1 INTO lv_name1 WHERE kunnr = lv_kunnr .

*populate final internal table
    CLEAR : wa_itab_final.
    wa_itab_final-vbeln = wa_data-vbeln .
    wa_itab_final-posnr = wa_data-posnr .
    wa_itab_final-customer = lv_name1 .
    wa_itab_final-matnr = wa_data-matnr .
    wa_itab_final-edatu = wa_data-edatu .
    wa_itab_final-arktx = wa_data-arktx .
    wa_itab_final-pending_qty = pending_qty .
    wa_itab_final-canbe_qty = lv_actul_canbe.
    wa_itab_final-so_rate = lv_kbetr.
    wa_itab_final-canbe_value = lv_actul_canbe * wa_itab_final-so_rate.

    """""""""""         Added By KD on 05.05.2017         """"""""""""""

    CLEAR wa_marc .
    READ TABLE it_marc INTO wa_marc WITH KEY matnr = wa_data-matnr .
    IF sy-subrc = 0.
      wa_itab_final-dispo = wa_marc-dispo .
      wa_itab_final-sfcpf = wa_marc-sfcpf .
    ENDIF.
    CLEAR wa_plaf .
    READ TABLE it_plaf INTO wa_plaf WITH KEY kdauf = wa_data-vbeln kdpos = wa_data-posnr .
    IF sy-subrc = 0.
      wa_itab_final-plnum = wa_plaf-plnum .
      wa_itab_final-psttr = wa_plaf-psttr .
    ENDIF.

    """"""""""""""          END 05.05.2017              """"""""""""""""
    IF wa_itab_final-plnum IS NOT INITIAL.
      APPEND wa_itab_final TO itab_final.
    ENDIF .
    CLEAR wa_itab_final .
  ENDLOOP ." IT_DATA INTO WA_DATA


ENDFORM.                    " BOM_EXPLODE
*&---------------------------------------------------------------------*
*&      Form  DATA_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM data_display .

**&---------------------------------------------------------------------*
**&  INCLUDE           ZPP_SO_SHORTAGES_COPY_ALV
**&---------------------------------------------------------------------*

  PERFORM build_fieldcat USING 'VBELN'           'X' '1'  'Sales Order No'(003).
  PERFORM build_fieldcat USING 'POSNR'           ' ' '2'  'Sales Item'(007).
  PERFORM build_fieldcat USING 'CUSTOMER'        ' ' '3'  'Customer'(008).
  PERFORM build_fieldcat USING 'EDATU'           ' ' '4'  'Production Delivary Date'(016).
  PERFORM build_fieldcat USING 'MATNR'           ' ' '5'  'Item Code'(010).
  PERFORM build_fieldcat USING 'ARKTX'           ' ' '6'  'Item Description'(011).
  PERFORM build_fieldcat USING 'PENDING_QTY'     ' ' '7'  'Pending QTY'(012).
  PERFORM build_fieldcat USING 'CANBE_QTY'       ' ' '8'  'Can Be Quantity'(013).
  PERFORM build_fieldcat USING 'SO_RATE'         ' ' '9'  'SO Rate'(014).
  PERFORM build_fieldcat USING 'CANBE_VALUE'     ' ' '10'  'Can Be Value'(015).
  """""""""""         Added By KD on 05.05.2017         """""""""""""""""
  PERFORM build_fieldcat USING 'DISPO'           ' ' '11'  'MRP Controller'(017).
  PERFORM build_fieldcat USING 'SFCPF'           ' ' '12'  'Order Type'(018).
  PERFORM build_fieldcat USING 'PLNUM'           ' ' '13'  'Planned Order Number'(019).
  PERFORM build_fieldcat USING 'PSTTR'           ' ' '14'  'Planned Start Date'(020).
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_structure_name   = 'TY_FINAL'
      is_layout          = wa_layout
      it_fieldcat        = it_fcat
      i_default          = 'X'
      i_save             = 'A'
      it_events          = gt_events[]
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
      it_sort            = i_sort
    TABLES
      t_outtab           = itab_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    " DATA_DISPLAY
*&---------------------------------------------------------------------*
*&      FORM  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
FORM build_fieldcat USING f1 f2 f3 f4 .

  wa_fcat-fieldname   = f1 ." 'VBELN'.
  wa_fcat-tabname     = 'IT_FINAL_NEW'.
* WA_FCAT-_ZEBRA       = 'X'.
  wa_fcat-key         = f2 ."  'X'.
  wa_fcat-seltext_m   = f4.
  wa_fcat-outputlen   = 18.
  wa_fcat-ddictxt     = 'M'.
  wa_fcat-col_pos     =  f3.

  IF   wa_fcat-fieldname = 'VBELN'
    OR wa_fcat-fieldname = 'POSNR'
    OR wa_fcat-fieldname = 'PLANT'
    OR wa_fcat-fieldname = 'HEADER'
    OR wa_fcat-fieldname = 'MATNR'
    OR wa_fcat-fieldname = 'ARKTX'.
    wa_fcat-key       = 'X'.
  ENDIF.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  BOM_FM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_REQQTY  text
*      -->P_V_MATNR  text
*      -->P_P_WERKS  text
*      <--P_T_STB1  text
*----------------------------------------------------------------------*
FORM bom_fm  TABLES p_t_stb1
            USING   p_reqqty
                      p_v_matnr
                      p_p_werks.


  CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
    EXPORTING
      capid                 = 'PP01'
      datuv                 = sy-datum
      emeng                 = p_reqqty
*     MEHRS                 = 'X'
      mtnrv                 = p_v_matnr
      stpst                 = 0
      svwvo                 = 'X'
      werks                 = p_p_werks
      vrsvo                 = 'X'
    TABLES
      stb                   = p_t_stb1
    EXCEPTIONS
      alt_not_found         = 1
      call_invalid          = 2
      material_not_found    = 3
      missing_authorization = 4
      no_bom_found          = 5
      no_plant_data         = 6
      no_suitable_bom_found = 7
      conversion_error      = 8
      OTHERS                = 9.
  IF sy-subrc <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " BOM_FM
*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_EVENTS[]  text
*----------------------------------------------------------------------*
FORM stp3_eventtab_build  CHANGING p_i_events TYPE slis_t_event.
  DATA: lf_event TYPE slis_alv_event. "Work area

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = p_i_events
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  MOVE c_formname_top_of_page TO lf_event-form.
  MODIFY p_i_events  FROM  lf_event INDEX 3 TRANSPORTING form."to p_i_events .

ENDFORM.                    " STP3_EVENTTAB_BUILD

*<perform top-of-page.
*&---------------------------------------------------------------------*
*&      Form  TOP-OF-PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM top_of_page .
*form top_of_page.
*** This FM is used to create ALV header
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = i_list_top_of_page[]. "Internal table with
*  details which are required as header for the ALV.
*    I_LOGO                   =
*    I_END_OF_LIST_GRID       =
*    I_ALV_FORM               =  .
ENDFORM.                    " TOP-OF-PAGE
*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_LIST_TOP_OF_PAGE[]  text
*----------------------------------------------------------------------*
FORM comment_build  CHANGING i_list_top_of_page TYPE slis_t_listheader.
  DATA: lf_line       TYPE slis_listheader. "Work Area
*--List heading -  Type H
  CLEAR lf_line.
  lf_line-typ  = c_h.
  lf_line-info = 'DAILY ASSEMBLY LOADING PLAN'(040).
  APPEND lf_line TO i_list_top_of_page.
*--Head info: Type S
  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-key  = 'DATE'.
  lf_line-info = sy-datum.
  WRITE sy-datum TO lf_line-info USING EDIT MASK '__.__.____'.
  APPEND lf_line TO i_list_top_of_page.

ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM layout_build  CHANGING p_wa_layout TYPE slis_layout_alv.
  wa_layout-colwidth_optimize  = 'X'.
  wa_layout-zebra              = 'X'.
*       p_wa_layout-Info_fieldname   = 'C51'.
  p_wa_layout-zebra            = 'X'.
  p_wa_layout-no_colhead       = ' '.
*        p_wa_layout-box_fieldname    = 'BOX'.

ENDFORM.                    " LAYOUT_BUILD
