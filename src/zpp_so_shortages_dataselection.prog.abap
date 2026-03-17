*&---------------------------------------------------------------------*
*&  Include           ZPP_SO_SHORTAGES_DATASELECTION
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  INCLUDE           ZPP_SO_SHORTAGES_COPY_DATASEL
*&---------------------------------------------------------------------*
****SELECTION SCREEN RESULT
*>>
AT SELECTION-SCREEN.
  IF rb_plant = 'X' AND v_plnt_ind = 'X' .

    IF p_werks IS INITIAL.
      MESSAGE e023.
    ENDIF.

    IF s_vbeln IS INITIAL
      AND s_matnr IS INITIAL
      AND s_cdd   IS INITIAL.
      MESSAGE e024.
    ENDIF.
  ENDIF.


*>>
START-OF-SELECTION.
  IF rb_plant = 'X'.
    lv_werks = p_werks.
    PERFORM data_plant.
  ENDIF.

  IF rb_input = 'X'.
    lv_werks = p_werks1.
    PERFORM data_input.
  ENDIF.


************************************************************************

****AT SELECTING PLANT OPTION

FORM data_plant .

  SELECT a~vbeln a~posnr d~etenr a~matnr a~arktx a~werks a~meins a~deldate
d~edatu d~wmeng d~etenr c~lfsta
     INTO CORRESPONDING FIELDS OF TABLE it_data
     FROM vbap AS a
     JOIN  vbup AS c ON ( c~vbeln = a~vbeln  AND c~posnr = a~posnr )
     JOIN  vbep AS d ON ( a~vbeln = d~vbeln  AND a~posnr = d~posnr )
     WHERE a~vbeln IN s_vbeln
*      AND A~WERKS  = P_WERKS
      AND c~lfsta  NE 'C'
    AND c~lfgsa  IN s_lfgsa
      AND  a~matnr IN s_matnr
      AND d~edatu  IN s_cdd
    AND d~wmeng NE 0.

  IF sy-subrc = 0.
    DELETE it_data WHERE werks IS INITIAL.

*  SORT it_data BY edatu.
    SORT it_data BY edatu vbeln posnr.

*  LV_WERKS = P_WERKS.  " This variable is assigned the value of
    "P_WERKS and used later for display purpose.

    PERFORM bom_explode.   "fill it_material
*SORT IT_MATERIAL BY PLANT.
*SORT IT_idnrk BY PLANT STUFE.
    PERFORM stock_req .

    PERFORM add_schid.

*    PERFORM calc_poqty.

*  Perform sort_table_build CHANGING i_sort[].
    PERFORM stp3_eventtab_build   CHANGING gt_events[].
    PERFORM comment_build         CHANGING i_list_top_of_page[].
*  perform top_of_page.
    IF p_down IS   INITIAL.
      PERFORM layout_build     CHANGING wa_layout.
      PERFORM data_display.
    ELSE.
      PERFORM down_set.
    ENDIF.

  ELSEIF sy-subrc  <> 0.
*      MESSAGE E030.
    MESSAGE 'No Data found'
           TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE  LIST-PROCESSING.
  ENDIF.

ENDFORM.                    " DATA_PLANT


*&---------------------------------------------------------------------*
*&      FORM  BOM_EXPLODE
*&---------------------------------------------------------------------*
*  FM FOR BOM (BILL OF MATERIAL) EXPLODING.
*----------------------------------------------------------------------*

FORM bom_explode .

  LOOP AT it_data INTO wa_data.

    PERFORM bom_fm TABLES t_stb
                USING   0                   "Reqd Qty
                        wa_data-matnr       "Material for which BOM
"needs to be exploded
                        wa_data-werks."P_WERKS.            "Plant

*****DATA FETCHING FOR MAKTX, MEINS AND SBDKZ FIELDS AT MATERIAL LEVEL.

    PERFORM fetch_data USING wa_data-matnr  "Material
                             wa_data-werks "P_WERKS        "Plant
                             0  "Level
                             0.    "Level1 Level (in multi-level BOM
*explosions)
*=========================================================*
*Fill header material data in IT_MATERIAL
    CLEAR wa_material.
    wa_material-so_no = wa_data-vbeln .
    wa_material-posnr  = wa_data-posnr .
    wa_material-etenr  = wa_data-etenr .
    wa_material-comp_mat = wa_data-matnr.
    wa_material-head_mat = wa_data-matnr.
    wa_material-act_matnr = wa_data-matnr.
    wa_material-plant = wa_data-werks.
    APPEND wa_material TO it_material.
    CLEAR wa_material.
*=========================================================*
*dATA : P_WERKS1 TYPE P_WER KS.
    " SOBSL -> Special Procurement Key

    LOOP AT t_stb INTO wa_stb.
*      IF NOT wa_stb-sobsl IS INITIAL AND wa_stb-sobsl <> '30'.

      CLEAR: pl_werks, pl_werks2.
      IF wa_stb-sobsl = 'Z1'.
        pl_werks2 = 'PL02'.
      ELSEIF wa_stb-sobsl = 'Z2'.
        pl_werks2 = 'PL03'.
      ELSEIF wa_stb-sobsl = 'Z3'.
        pl_werks2 = 'PL04'.
      ELSEIF wa_stb-sobsl = 'Z4'.
        pl_werks2 = 'PL01'.
      ENDIF.

      IF pl_werks2 IS NOT INITIAL.
        pl_werks = pl_werks2 .
        CLEAR wa_material.
        wa_material-so_no = wa_data-vbeln .
        wa_material-posnr  = wa_data-posnr .
        wa_material-etenr  = wa_data-etenr .
        wa_material-comp_mat = wa_stb-idnrk.
        wa_material-head_mat = wa_data-matnr.
        wa_material-act_matnr = wa_stb-idnrk.
        wa_material-plant = pl_werks2.
        APPEND wa_material TO it_material.
        CLEAR wa_material.

      ENDIF.

      IF pl_werks IS NOT INITIAL.

        IF wa_stb-sobsl <> 'Z1' OR wa_stb-sobsl <> 'Z2' OR wa_stb-sobsl <> 'Z3'
          OR wa_stb-sobsl <> 'Z4'.

*         if p_werks = pl_werks.


          PERFORM bom_fm TABLES t_stb1
                         USING   0                      "Reqd Qty
                                 wa_stb-idnrk           "Component
                                 pl_werks.              "Plant
*endif.

          IF wa_stb-sobsl = 'Z1' OR wa_stb-sobsl = 'Z2'
             OR wa_stb-sobsl = 'Z3' OR wa_stb-sobsl = 'Z4'.

            PERFORM fetch_data USING wa_stb-idnrk
                               pl_werks
                               0
                               0.
          ELSE.
            PERFORM fetch_data USING wa_stb-idnrk
                                       pl_werks
                                       0
                                       wa_stb-stufe.
          ENDIF.
          LOOP AT t_stb1 INTO wa_stb1.

            lv_stlnr = wa_stb1-stlnr.
            " Component value asigned to the table.
            wa_material-so_no = wa_data-vbeln .
            wa_material-posnr  = wa_data-posnr .
            wa_material-etenr  = wa_data-etenr .
            wa_material-comp_mat = wa_stb1-idnrk.
            wa_material-plant = pl_werks.
*          CLEAR PL_WERKS.
*            IF WA_STB1-TTIDX = 1.
*              WA_MATERIAL-HEAD_MAT = WA_STB-IDNRK.
            wa_material-head_mat = wa_data-matnr.
*          ELSE.
*            READ TABLE T_STB1 INTO WA_STB1 WITH KEY  XTLNR = LV_STLNR .
*            WA_MATERIAL-HEAD_MAT = WA_STB1-IDNRK.
*-start Code commented to hide display of level 1 (wa_stb-ttidx = 1)
*components for header material.
*-Code for action_date calculation at component level.
*            IF wa_stb-ttidx = 1.
            IF wa_stb1-ttidx = 1.
*              wa_material-act_matnr = wa_data-matnr.
              wa_material-act_matnr = wa_stb-idnrk.
*            ELSEIF wa_stb1-ttidx = 1.
*              wa_material-act_matnr = wa_data-matnr.
*              ELSE.
**              clear wa_stb.
*              READ TABLE t_stb INTO wa_stb WITH KEY  xtlnr = lv_stlnr .
*              IF SY-SUBRC = 0.
*              wa_material-act_matnr = wa_stb-idnrk.
            ELSE.
              CLEAR wa_stb_tmp.
              READ TABLE t_stb1 INTO wa_stb_tmp WITH KEY  xtlnr = lv_stlnr .
              wa_material-act_matnr = wa_stb_tmp-idnrk.
            ENDIF.
*            ENDIF.
*          WA_final-ACT_MATNR = WA_MATERIAL-ACT_MATNR .
*end Code commented to hide display of level 1 (wa_stb-ttidx = 1)
*components for header material.

*            ENDIF.
********************************
            PERFORM fetch_data USING wa_stb1-idnrk
                                           pl_werks
                                           wa_stb-ttidx
                                           wa_stb1-stufe.

********************************

            APPEND wa_material TO it_material.
*            endif.
            CLEAR : wa_material.
          ENDLOOP.
        ENDIF.
      ENDIF.
*      ELSE.  "SOBSL

*=======================================================
*        PERFORM FETCH_DATA USING WA_STB-IDNRK
*                                 WA_DATA-WERKS "P_WERKS
*                                 WA_STB-TTIDX
*                                 WA_STB-STUFE.


      lv_stlnr = wa_stb-stlnr.
      " Component value asigned to the table.
      wa_material-head_mat  = wa_data-matnr.
      wa_material-so_no     = wa_data-vbeln .
      wa_material-posnr     = wa_data-posnr .
      wa_material-etenr     = wa_data-etenr .
      wa_material-comp_mat  = wa_stb-idnrk.
      wa_material-plant     = wa_data-werks ."P_WERKS.

*-start Code commented to hide display of level 1 (wa_stb-ttidx = 1)
*components for header material.
*-Code for action_date calculation at component level.
      IF wa_stb-ttidx = 1.
        wa_material-act_matnr = wa_data-matnr.
      ELSE.
        CLEAR wa_stb_tmp.
        READ TABLE t_stb INTO wa_stb_tmp WITH KEY  xtlnr = lv_stlnr .
        wa_material-act_matnr = wa_stb_tmp-idnrk.
      ENDIF.
*          WA_final-ACT_MATNR = WA_MATERIAL-ACT_MATNR .
*end Code commented to hide display of level 1 (wa_stb-ttidx = 1)
*components for header material.
*
      APPEND wa_material TO it_material.

      " Populate corresponding IDNRK record
      PERFORM fetch_data USING wa_stb-idnrk
                               wa_data-werks "P_WERKS
                               wa_stb-ttidx
                               wa_stb-stufe.

      CLEAR : wa_material.

*      ENDIF.   "SOBSL
*=========================================================

      CLEAR: wa_idnrk, wa_stb_tmp, wa_stb.


    ENDLOOP.


*****REFRESH TABLE AND CLEAR WORK AREA.
    REFRESH t_stb.
    CLEAR wa_stb.

  ENDLOOP ." PROPOSED

*===========Changes on 25/05/2011
  IF NOT it_idnrk[] IS INITIAL.
    SELECT    matnr
              brand
              zseries
              zsize
              moc
              type
              mtart
              bismt
         FROM mara
         INTO CORRESPONDING FIELDS OF TABLE it_mara
         FOR ALL ENTRIES IN it_idnrk
         WHERE matnr = it_idnrk-idnrk.

    SELECT   matnr
             werks
             dispo
             beskz
        FROM marc
        INTO CORRESPONDING FIELDS OF TABLE it_marc
        FOR ALL ENTRIES IN it_idnrk
        WHERE matnr = it_idnrk-idnrk
        AND werks = wa_data-werks."P_WERKS.
    v_bwkey = wa_data-werks."P_WERKS.
    SELECT matnr
            bwkey
           verpr
      FROM mbew
      INTO CORRESPONDING FIELDS OF TABLE it_mbew
      FOR ALL ENTRIES IN it_marc
      WHERE matnr = it_marc-matnr
      AND bwkey   = v_bwkey.

    SELECT  vbeln
            kunnr
      FROM  vbak
      INTO CORRESPONDING FIELDS OF TABLE it_vbak
      FOR ALL ENTRIES IN it_idnrk
      WHERE vbeln = it_idnrk-vbeln.

    SELECT  kunnr
            name1
      FROM  kna1
      INTO  CORRESPONDING FIELDS OF TABLE it_kna1
      FOR ALL ENTRIES IN it_vbak
      WHERE kunnr = it_vbak-kunnr.

  ENDIF.

ENDFORM.                    " BOM_EXPLODE


*&---------------------------------------------------------------------*
*&      FORM  STOCK_REQ
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*


FORM stock_req .
* CHECK  THE IND CONDITION AND STATUS OF FLAG1.(header items
*WA_IDNRK-LEVEL = '0')
* CHECK  THE WA_IDNRK-LEVEL IF '0' AND SET FLAG1 TO 0.
  DATA : idx TYPE sy-tabix VALUE 1.
  PERFORM determine_req_dt.

  " If there is no reqmt for the header material then there is no need
*for the stock req


  CLEAR wa_idnrk.
  LOOP AT it_idnrk INTO wa_idnrk .
    idx = sy-tabix.
    IF ( flag1 NE '1' OR wa_idnrk-level = '0' OR p_werks <>
wa_idnrk-plant ) AND wa_idnrk-idnrk <> '' .
      p_werks = wa_idnrk-plant.
      flag1 = '0'.
      " FM to fetch the planning (MD04) for specified material.
      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          matnr                    = wa_idnrk-idnrk
          werks                    = p_werks
        TABLES
          mdpsx                    = it_mdps
          mdezx                    = it_mdez
        EXCEPTIONS
          material_plant_not_found = 1
          plant_not_found          = 2
          OTHERS                   = 3.
      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      IF wa_idnrk-sbdkz = '1' OR wa_idnrk-level = 0.
        PERFORM ind TABLES it_material it_idnrk it_mdps CHANGING flag1.
      ELSE.
        PERFORM coll TABLES it_material it_idnrk it_mdps.
      ENDIF.
    ENDIF.
    READ TABLE it_idnrk INTO wa_idnrk INDEX idx.
    CLEAR : wa_idnrk, avail_stock.
  ENDLOOP.
ENDFORM.                    " STOCK_REQ

*&---------------------------------------------------------------------*
*&      FORM  IND
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->IT_IDNRK   TEXT
*      -->IT_MDPS    TEXT
*----------------------------------------------------------------------*
FORM ind TABLES it_material LIKE it_material  it_idnrk it_mdps  LIKE
it_mdps CHANGING flag1.

*TO CHECK IF THE WA_IDNRK-VBELN = WA_MDPS-KDAUF AND WA_IDNRK-POSNR =
*WA_MDPS-KDPOS .
* SET FLAG1 TO 1.
*GOTO FORM STOCK REQ AND CHECK THIS CONDITION WITH WA_IDNRK-LEVEL.
  READ TABLE  it_mdps   INTO  wa_mdps WITH KEY kdauf =  wa_idnrk-vbeln
   kdpos = wa_idnrk-posnr .
*IF   WA_IDNRK-VBELN = WA_MDPS-KDAUF AND WA_IDNRK-POSNR  =
*WA_MDPS-KDPOS.
  IF sy-subrc NE 0.
    flag1 = 1.
  ENDIF.
*ENDLOOP.

*-----------------------------------------------------------------------
  wa_final-stufe = wa_idnrk-stufe.
  wa_final-etenr = wa_idnrk-etenr.
  wa_final-action_days = wa_idnrk-actdys.
  wa_final-act_dt = wa_idnrk-act_dt.
  wa_final-action_dt = wa_idnrk-action_dt.
*-----------------------------------------------------------------------
*---
  IF flag1 NE '1'.
    LOOP AT it_mdps INTO wa_mdps.
      wa_mdps1 = wa_mdps.

      IF ( wa_idnrk-vbeln = wa_mdps-kdauf AND wa_idnrk-posnr = wa_mdps-kdpos ).
        IF wa_mdps-delet <> '' OR wa_mdps-delet <> 0000.
          CONCATENATE  wa_mdps-kdauf wa_mdps-kdpos wa_mdps-delet
                 INTO planseg." SEPARATED BY '/'.
        ELSE.
          lv_delnr = wa_mdps-delnr.

          CALL FUNCTION 'MD_PEGGING_NODIALOG'
            EXPORTING
              edelet                = 0000
              edelkz                = wa_mdps-delkz
              edelnr                = lv_delnr
              edelps                = wa_mdps-delps         "000000
              eplscn                = 000
              ematnr                = wa_idnrk-idnrk
              ewerks                = p_werks
              eplanr                = wa_mdps-planr          " EPLWRK = ' '
            TABLES
              imdrqx                = it_mdrqx
            EXCEPTIONS
              error                 = 1
              no_requirements_found = 2
              order_not_found       = 3
              OTHERS                = 4.
          IF sy-subrc <> 0.
*            MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
          ENDIF.

          READ TABLE it_mdrqx INTO wa_mdrqx WITH KEY planr = wa_mdps-planr.
          IF sy-subrc = 0.
            REPLACE ALL OCCURRENCES OF '/' IN wa_mdrqx-extra WITH ''.
          ENDIF.
          CONCATENATE  wa_idnrk-vbeln wa_idnrk-posnr wa_idnrk-etenr
                           INTO planseg1." SEPARATED BY '/'.

        ENDIF.

*        IF  WA_MDPS-DELKZ = 'KB' ."OR WA_MDPS-DELKZ = 'QM') .
*          SO_STOCK  = SO_STOCK + WA_MDPS-MNG01.  "UNRESTRICTED STOCK
*        ENDIF.
*
*        IF  WA_MDPS-DELKZ = 'QM' ."OR WA_MDPS-DELKZ = 'QM') .
*          SO_STOCK_QM  = SO_STOCK + WA_MDPS-MNG01.  " STOCK QUALITY
*        ENDIF.

*==============uNRESTRICTED sTOCK=======================
        CONCATENATE  wa_idnrk-vbeln wa_idnrk-posnr wa_idnrk-etenr
                         INTO planseg1." SEPARATED BY '/'.
        IF planseg1 = wa_mdrqx-extra OR planseg1 = planseg .
          IF ( wa_mdps-delkz = 'VC' OR wa_mdps-delkz = 'SB'
            OR  wa_mdps-delkz = 'U1' OR wa_mdps-delkz = 'U2'
            OR wa_mdps-delkz = 'AR' OR wa_mdps-delkz = 'BB' ).
            so_qty    =  so_qty + wa_mdps-mng01.
          ENDIF.

          IF wa_mdps-delkz = 'BE' .   " purchase order

*logic for unreleased po to be excluded from PO Quantity
            CLEAR: po_number, po_quantity, lv_tot_po_qty.

            LOOP AT it_mdez INTO wa_mdez.
              IF wa_mdez-delkz = 'BE'.
                po_number = wa_mdez-extra(10) .
                IF wa_mdps-delnr = po_number.
                  lv_tot_po_qty = lv_tot_po_qty + wa_mdez-mng01.
                  CLEAR wa_ekko.
                  SELECT SINGLE * FROM ekko INTO wa_ekko WHERE ebeln = po_number.
                  IF sy-subrc = 0.
                    IF wa_ekko-frgke = 'X'.
                      po_item = wa_mdez-extra+11(5).
                      CLEAR: wa_ekpo.
                      SELECT SINGLE * FROM ekpo INTO wa_ekpo WHERE ebeln = po_number
                                                               AND ebelp =  po_item.
                      IF sy-subrc = 0.
                        po_quantity =  po_quantity + wa_ekpo-menge.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDLOOP.

            wa_final-po_qty = lv_tot_po_qty - po_quantity.
            CLEAR po_quantity.

          ENDIF.

          wa_final-po_no = wa_mdps-delnr.  "DELNR
*          ENDIF.
*=========Vendor Stk====13/05/2011
*        IF WA_MDPS-DELKZ = 'LK' .
*          VENDOR_STK  = VENDOR_STK + WA_MDPS-MNG01.
*        ENDIF.
*           IF WA_MDPS-DELKZ = 'FE' AND WA_IDNRK-LEVEL = 0.
          IF wa_mdps-delkz = 'FE'." AND WA_IDNRK-LEVEL = 0.
*          IF WA_MDPS-DELKZ = 'AR'." AND WA_IDNRK-LEVEL = 0.
*Production order
            prod_ord  = wa_mdps-del12.
          ENDIF.
*****PURCHASE REQUESITION NO**********
          IF wa_mdps-delkz = 'BA' .   "PURCHASE REQUISITION
            wa_final-pr_qty = wa_mdps-mng01.
            wa_final-pr_no = wa_mdps-delnr.
          ENDIF.

          CLEAR:wa_mast.
          REFRESH: it_mast.

        ENDIF.
        CLEAR wa_mdrqx.

        AT END OF planr.

          SELECT SUM( kalab )
                  SUM( kains )
                  SUM( kaspe )
            FROM mska
            INTO (so_stock ,
                   so_stock_qm,
                    so_block_stk)
            WHERE vbeln = wa_idnrk-vbeln
            AND posnr = wa_idnrk-posnr
            AND matnr = wa_idnrk-idnrk
            AND werks = p_werks
            AND lgort <> 'RJ01' AND lgort <> 'SCR1' AND lgort <> 'SRN1'.

          IF rb_input = 'X'.
            READ TABLE it_zsoplan INTO wa_zsoplan
            WITH KEY  so_no = wa_idnrk-vbeln
                      so_item = wa_idnrk-posnr.

            IF wa_zsoplan-quantity > so_qty.
              wa_zsoplan-quantity = so_qty.
            ELSE.
              so_qty = wa_zsoplan-quantity.
            ENDIF.

          ENDIF.

******Production order and reservation details.
          IF prod_ord IS INITIAL.
            CLEAR wa_material3.
            READ TABLE it_material INTO wa_material3
            WITH KEY so_no = wa_idnrk-vbeln
                           posnr = wa_idnrk-posnr
                           etenr = wa_idnrk-etenr
                           comp_mat = wa_idnrk-idnrk
                           plant = wa_idnrk-plant.
            IF sy-subrc = 0.
              CLEAR: wa_mdps2, it_mdps2.
              REFRESH: it_mdps2, it_afpo.
              CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
                EXPORTING
                  matnr = wa_material3-act_matnr
                  werks = wa_idnrk-plant
                TABLES
                  mdpsx = it_mdps2.

              LOOP AT it_mdps2 INTO wa_mdps2 WHERE kdauf = wa_idnrk-vbeln AND kdpos = wa_idnrk-posnr.
                IF wa_mdps2-delkz = 'FE'.
                  wa_order-order =  wa_mdps2-del12.
                  APPEND wa_order TO it_order.
                ENDIF.
              ENDLOOP.
              IF it_order[] IS NOT INITIAL.
                SELECT aufnr psmng wemng FROM afpo INTO CORRESPONDING FIELDS
                  OF TABLE it_afpo FOR ALL ENTRIES IN it_order WHERE
                  aufnr = it_order-order.
                CLEAR: wa_afpo2, wa_resb, wa_final_new-wip_stk.
                LOOP AT it_afpo INTO wa_afpo2.
                  CLEAR wa_resb.
                  SELECT SINGLE matnr
                                  bdmng
                                  enmng
                                  aufnr
                            FROM  resb
                            INTO CORRESPONDING FIELDS OF  wa_resb
                              WHERE aufnr = wa_afpo2-aufnr
                              AND matnr = wa_idnrk-idnrk
                              AND xloek <> 'X'              "
                              AND enmng > 0
                              AND shkzg = 'H'.
                  IF sy-subrc = 0.
                    wa_resb-wipqty = wa_resb-enmng - ( wa_afpo2-wemng * (
                                     wa_resb-bdmng / wa_afpo2-psmng ) ).
                    IF wa_resb-wipqty > 0.
                      wa_final_new-wip_stk = wa_final_new-wip_stk + wa_resb-wipqty.
                    ENDIF.
                  ENDIF.
                ENDLOOP.
              ENDIF.
            ENDIF.
            REFRESH: it_mdps2, it_afpo, it_order.
            CLEAR: wa_mdps2, wa_afpo2, wa_resb..

          ELSEIF NOT prod_ord IS INITIAL.
            SELECT SINGLE aufnr
                   psmng
                   wemng
                   "MATNR
              FROM afpo
              INTO CORRESPONDING FIELDS OF wa_afpo
              WHERE aufnr = prod_ord.
*          AND ELIKZ <> 'X'

            SELECT SINGLE matnr
                          bdmng
                          enmng
                          aufnr
                    FROM  resb
                    INTO CORRESPONDING FIELDS OF  wa_resb
                      WHERE aufnr = prod_ord
                      AND matnr = wa_idnrk-idnrk
                      AND xloek <> 'X'              "
                      AND enmng > 0
                      AND shkzg = 'H'.

            IF sy-subrc = 0.
              wa_resb-wipqty = wa_resb-enmng - ( wa_afpo-wemng * ( wa_resb-bdmng
                                 / wa_afpo-psmng ) ).
              IF wa_resb-wipqty > 0.
                wa_final_new-wip_stk = wa_resb-wipqty.
              ENDIF.

            ENDIF.
          ENDIF.
*********
*  rem_qty = so_qty - wa_final_new-wip_stk.
*   so_qty = so_qty - wa_final_new-wip_stk.
          CLEAR short_qty.
          IF so_qty >= wa_final_new-wip_stk.
            short_qty = so_qty - wa_final_new-wip_stk.
          ENDIF.

          IF short_qty GE so_stock.
            short_qty = short_qty - so_stock.
          ELSEIF short_qty < so_stock.
            short_qty =   short_qty - so_stock.
          ENDIF.

*          IF so_qty > so_stock.
*            short_qty = so_qty - so_stock.
*          ENDIF.
*
*          if short_qty > wa_final_new-wip_stk.
*             short_qty = short_qty - wa_final_new-wip_stk.
*           endif.


          IF short_qty < 0.
            short_qty = 0.
          ENDIF.

          IF so_qty = 0 AND wa_idnrk-level = 0.
            flag1 = 1.
          ENDIF.
          "======Changes on*25/05/2011================================"
          READ TABLE  it_mara   INTO
          w_mara WITH KEY matnr = wa_idnrk-idnrk.
          READ TABLE  it_marc   INTO
          wa_marc WITH KEY matnr = wa_idnrk-idnrk.
          READ TABLE  it_mbew   INTO
          wa_mbew WITH KEY matnr = wa_idnrk-idnrk.
          READ TABLE  it_vbak   INTO
          w_vbak WITH KEY vbeln = wa_idnrk-vbeln.
          READ TABLE  it_kna1   INTO
           wa_kna1 WITH KEY kunnr = w_vbak-kunnr.
          "==Changes on*13/05/2011========================================"
          wa_final_new-zseries     = w_mara-zseries.
          wa_final_new-brand       = w_mara-brand.
          wa_final_new-zsize       = w_mara-zsize.
          wa_final_new-moc         = w_mara-moc.
          wa_final_new-type        = w_mara-type.
          wa_final_new-mtart       = w_mara-mtart.
          wa_final_new-bismt       = w_mara-bismt.
          wa_final_new-dispo       = wa_marc-dispo.
          wa_final_new-beskz       = wa_marc-beskz.
          wa_final_new-verpr       = wa_mbew-verpr.
          wa_final_new-customer    = wa_kna1-name1.
          wa_final_new-plant       = wa_idnrk-plant.
          wa_final_new-stufe       = wa_final-stufe.
          wa_final_new-etenr       = wa_final-etenr.
          wa_final_new-action_days = wa_idnrk-actdys.
          wa_final_new-act_dt      = wa_final-act_dt.
          wa_final_new-action_dt   = wa_final-action_dt.
*          WA_FINAL_NEW-ACTION_DT   = WA_FINAL-ACT_DT - ACTION_DAYS.
          "===Changes on*14/06/2011=================================="
          pr_qty_verpr = wa_final-pr_qty * wa_mbew-verpr.
          wa_final_new-pr_qty_verpr = pr_qty_verpr.

          po_qty_verpr = wa_final-po_qty * wa_mbew-verpr.
          wa_final_new-po_qty_verpr = po_qty_verpr.

          "==========================================================="

          IF wa_idnrk-level = 0.
            header    = wa_idnrk-idnrk."====CHANGE================="
            header_desc = wa_idnrk-maktx.
          ENDIF.

          CLEAR wa_material.
          READ TABLE it_material INTO wa_material
                WITH KEY so_no = wa_idnrk-vbeln
                         posnr = wa_idnrk-posnr
                         etenr = wa_idnrk-etenr
                         comp_mat = wa_idnrk-idnrk
                         plant = p_werks.
          CLEAR header.
          IF sy-subrc = 0.
            header = wa_material-head_mat.
*         read TABLE it_IDNRK INTO WA_IDNRK1
*                  WITH KEY IDNRK = WA_IDNRK-IDNRK. "HEADER.
            "wa_material-head_mat.
*         READ TABLE IT_IDNRK INTO WA_IDNRK1 W
*         HEADER_DESC = WA_IDNRK1-MAKTX.
            SELECT SINGLE maktx FROM makt INTO header_desc
               WHERE matnr = header.
          ENDIF.

          IF header IS NOT INITIAL.
            wa_final_new-header = header.
          ELSE.
            wa_final_new-header = wa_data-matnr.
          ENDIF.
          wa_final_new-header_desc = header_desc.
          wa_final_new-vbeln     = wa_idnrk-vbeln. .
          wa_final_new-posnr     = wa_idnrk-posnr. "WA_IDNRK-POSNR

          CLEAR lv_so_plant.
          SELECT SINGLE werks FROM vbap INTO lv_so_plant WHERE
            vbeln = wa_final_new-vbeln AND posnr = wa_final_new-posnr.
          wa_final_new-so_plant = lv_so_plant.



          wa_final_new-matnr     = wa_idnrk-idnrk. "Wcomponent
          wa_final_new-arktx     = wa_idnrk-maktx. "WA_FINAL-ARKTX
          wa_final_new-uom       = wa_idnrk-uom.   "WA_FINAL-UOM
          wa_final_new-edatu     = wa_idnrk-edatu. "WA_FINAL-eDATU
          wa_final_new-wmeng    = wa_idnrk-wmeng."WA_FINAL-KWMENG.
          wa_final_new-deldate  = wa_idnrk-deldate.

          wa_final_new-open_so   = so_qty.
          wa_final_new-unres_stk = so_stock .
          wa_final_new-qm_stk        = so_stock_qm.
*          WA_FINAL_NEW-VENDOR_STK     = VENDOR_STK.
          wa_final_new-block_stk = so_block_stk.

          wa_final_new-short_qty  = short_qty .
*if shortage qty = 0 , then PO Oty is assigned 0 value
          IF wa_final_new-short_qty = 0.
            wa_final_new-po_qty = 0.
          ELSE.
            wa_final_new-po_qty     = wa_final-po_qty.
          ENDIF.

          wa_final_new-net_indent = wa_final_new-short_qty -  wa_final_new-po_qty .
          IF wa_final_new-net_indent < 0.
            wa_final_new-net_indent = 0.
          ENDIF.



          wa_final_new-po_no      =
wa_final-po_no."WA_MDPS1-EBELN."WA_MDPS-EBELN."
          wa_final_new-pr_qty     = wa_final-pr_qty.
          wa_final_new-pr_no      = wa_final-pr_no.
          wa_final_new-act_dt     = wa_idnrk-act_dt.
*          WA_FINAL_NEW-ACTION_DT  = WA_FINAL_new-ACT_DT -
*ACTION_DAYS."WA_FINAL-ACTION_DT.
          wa_final_new-action_dt  = wa_idnrk-action_dt.
          wa_final_new-act_matnr = wa_final-act_matnr.
*          WA_FINAL_NEW-STUFE       = WA_IDNRK-STUFE.
*          SHIFT WA_FINAL_NEW-VBELN LEFT DELETING LEADING '0'.
          SHIFT wa_final_new-vbeln LEFT DELETING LEADING '0'.
          SHIFT wa_final_new-matnr LEFT DELETING LEADING '0'.
*          Condense WA_FINAL_NEW-PO_NO.
          SHIFT wa_final_new-header LEFT DELETING LEADING '0'.

          CLEAR: wa_marc1, wa_mbew1.
          SELECT SINGLE * FROM marc INTO wa_marc1 WHERE
            matnr = wa_final_new-matnr AND werks = p_werks.

          SELECT SINGLE * FROM mbew INTO wa_mbew1 WHERE
            matnr = wa_final_new-matnr AND bwkey = p_werks.

          wa_final_new-action_days = wa_marc1-plifz.
          wa_final_new-dispo = wa_marc1-dispo.
          wa_final_new-beskz = wa_marc1-beskz.
          wa_final_new-sobsl = wa_marc1-sobsl.
          wa_final_new-verpr = wa_mbew1-verpr.

* To display records with werks as P_werks as per selection screen only.
          wa_final_new-plant2 =  wa_idnrk-plant2.
          IF lv_werks = wa_final_new-plant AND wa_final_new-open_so <> 0.
            APPEND wa_final_new TO it_final_new.
          ENDIF.
**********************************
          REFRESH t_stb.
          CLEAR: lv_mat_qty, lv_matnr.
          lv_matnr = wa_idnrk-idnrk.
          lv_mat_qty = wa_final_new-net_indent.
          PERFORM bom_fm TABLES t_stb
                                  USING   lv_mat_qty
                                          lv_matnr
                                          p_werks.

          CLEAR wa_stb_tmp.
*              READ TABLE t_stb INTO wa_stb_tmp WITH KEY  IDNRK =
*              wa_material-act_matnr = wa_stb_tmp-idnrk.
          LOOP AT t_stb INTO wa_stb_tmp WHERE stufe = 1.
            CLEAR wa_material.
***************************
            IF lv_mat_qty = 0.
              wa_material-mat_qty = 0.
            ELSEIF lv_mat_qty <> 0.
              wa_material-mat_qty = wa_stb_tmp-mnglg.
            ENDIF.
***************************
            MODIFY it_material
            FROM wa_material
            TRANSPORTING mat_qty
            WHERE comp_mat = wa_stb_tmp-idnrk
**      WHERE head_mat = wa_idnrk-idnrk
          AND plant = p_werks
          AND so_no = wa_idnrk-vbeln
          AND posnr = wa_idnrk-posnr
          AND etenr = wa_idnrk-etenr.

          ENDLOOP.

***********************************
          CLEAR wa_material.
          wa_material-mat_qty = so_qty.
*          if wa_idnrk-hdmat is not initial.
*           lv_matnr_5 =  wa_idnrk-hdmat.
*           elseif wa_idnrk-hdmat is initial.
**           lv_matnr_5 =  .
*          endif.

          MODIFY it_material
          FROM wa_material
          TRANSPORTING mat_qty
            WHERE comp_mat = wa_idnrk-idnrk
*            WHERE head_mat = wa_idnrk-idnrk
            AND plant = p_werks
            AND so_no = wa_idnrk-vbeln
            AND posnr = wa_idnrk-posnr
            AND etenr = wa_idnrk-etenr.


          CLEAR:
            so_stock_qm,
            so_block_stk,
            so_stock ,
            so_qty ,
            short_qty ,
            po_qty ,
            vendor_stk,
            wa_mast,
            wa_final_new,
            wa_final,
            action_days.
          REFRESH: it_mast.
*        ENDAT.
        ENDAT.

*      ENDIF. " WHEN SALES ORDER AND ITEM LINE CHECK
        CLEAR planseg.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " IND

*&---------------------------------------------------------------------*
*&      FORM  COLL
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->IT_IDNRK   TEXT
*      -->IT_MDPS    TEXT
*----------------------------------------------------------------------*
FORM coll  TABLES it_material LIKE it_material  it_idnrk   it_mdps
LIKE it_mdps.

  wa_final-etenr = wa_idnrk-etenr.
  wa_final-stufe = wa_idnrk-stufe.
  wa_final-action_days = wa_idnrk-actdys.
  wa_final-act_dt = wa_idnrk-act_dt.
  wa_final-action_dt = wa_idnrk-action_dt.
*-----------------------------------------------------------------------
  LOOP AT it_mdps INTO wa_mdps.
    wa_mdps1 = wa_mdps.

    IF ( wa_mdps-planr = '' ).

*      IF  WA_MDPS-DELKZ = 'WB' . " Unrestricted Stock.
*        AVAIL_STOCK  = AVAIL_STOCK + WA_MDPS-MNG01.
*      ENDIF.
*
*      IF  WA_MDPS-DELKZ = 'QM' .
*        AVAIL_QM  =  AVAIL_QM + WA_MDPS-MNG01.
*      ENDIF.

      IF wa_mdps-delkz = 'BE' .        "Purchase order
*logic for unreleased po to be excluded "#col_po
        CLEAR: po_number, po_quantity, lv_tot_po_qty.

        LOOP AT it_mdez INTO wa_mdez.
          IF wa_mdez-delkz = 'BE'.
            po_number = wa_mdez-extra(10) .
            IF wa_mdps-delnr = po_number.
              lv_tot_po_qty = lv_tot_po_qty + wa_mdez-mng01.
              CLEAR wa_ekko.
              SELECT SINGLE * FROM ekko INTO wa_ekko WHERE ebeln = po_number.
              IF sy-subrc = 0.
                IF wa_ekko-frgke = 'X'.
                  po_item = wa_mdez-extra+11(5).
                  CLEAR: wa_ekpo.
                  SELECT SINGLE * FROM ekpo INTO wa_ekpo WHERE ebeln = po_number
                                                           AND ebelp =  po_item.
                  IF sy-subrc = 0.
                    po_quantity =  po_quantity + wa_ekpo-menge.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
        wa_final-po_qty = lv_tot_po_qty - po_quantity.
*    clear po_quantity.
*logic for unreleased po to be excluded "#col_po
        READ TABLE it_po INTO wa_po WITH KEY pono = wa_mdps-delnr.
        IF sy-subrc <> 0.
          wa_po-matnr = wa_idnrk-idnrk.
          wa_po-reqd_dt = wa_mdps-dat00.
          wa_po-pono  = wa_mdps-delnr.
          CLEAR wa_ekko.
          SELECT SINGLE * FROM ekko INTO wa_ekko WHERE ebeln = wa_po-pono.
          IF sy-subrc = 0.
            IF wa_ekko-frgke = 'X'.
*          WA_PO-POQTY = WA_MDPS-MNG01 .
              wa_po-poqty = 0.
            ELSE.
              wa_po-poqty = lv_tot_po_qty - po_quantity.
            ENDIF.
          ENDIF.
          APPEND wa_po TO it_po.
        ENDIF.
        CLEAR po_quantity.
      ENDIF.

*====Vendor Stk====13/05/2011
*      IF WA_MDPS-DELKZ = 'LK' .      " Vendor stock
*        AVAIL_VS  =  AVAIL_VS + WA_MDPS-MNG01.
*      ENDIF.

*****PURCHASE REQUESITION NO**********
      IF wa_mdps-delkz = 'BA' .   "PURCHASE REQUISITION
        READ TABLE it_pr INTO wa_pr WITH KEY prno = wa_mdps-delnr.
        IF sy-subrc <> 0.
          wa_pr-matnr = wa_idnrk-idnrk.
          wa_pr-reqd_dt = wa_mdps-dat00.
          wa_pr-prno  = wa_mdps-delnr.
          wa_pr-prqty = wa_mdps-mng01.
          APPEND wa_pr TO it_pr.
        ENDIF.
      ENDIF.

****Action Date**********
      AT END OF planr.

        SELECT SUM( labst )
                  SUM( insme )
                  SUM( speme )
            FROM mard
            INTO (avail_stock ,
                   avail_qm,
                    avail_block)
            WHERE matnr = wa_idnrk-idnrk
            AND werks = p_werks
            AND lgort <> 'RJ01' AND lgort <> 'SCR1' AND lgort <> 'SRN1'.

        CLEAR: wa_material, lv_mat_qty, lv_matnr.

        READ TABLE it_material INTO wa_material
          WITH KEY comp_mat = wa_idnrk-idnrk
                   plant    = wa_idnrk-plant
                   so_no = wa_idnrk-vbeln
                   posnr = wa_idnrk-posnr
                   etenr = wa_idnrk-etenr.

        lv_mat_qty = wa_material-mat_qty.
*        lv_matnr = wa_material-head_mat.
        lv_matnr = wa_material-act_matnr.

*************EXPLODE HEADER MATERIALS REQ QTY
        CLEAR wa_material2.
        READ TABLE it_material INTO wa_material2
                  WITH KEY comp_mat = lv_matnr
                           plant    = wa_idnrk-plant
                           so_no = wa_idnrk-vbeln
                           posnr = wa_idnrk-posnr
                           etenr = wa_idnrk-etenr.
        IF sy-subrc = 0.

          lv_mat_qty = wa_material2-mat_qty.
*        lv_matnr = wa_material-head_mat.
*        lv_matnr = wa_material-ACT_matNR.
        ELSE.
          CLEAR wa_data2.
          READ TABLE it_data INTO wa_data2
                    WITH KEY vbeln  = wa_idnrk-vbeln
                             posnr = wa_idnrk-posnr
                             etenr = wa_idnrk-etenr.
          IF wa_data2-werks IS NOT INITIAL.
            CLEAR wa_material2.
            READ TABLE it_material INTO wa_material2
                      WITH KEY comp_mat = lv_matnr
                               plant    = wa_data2
                              so_no = wa_idnrk-vbeln
                               posnr = wa_idnrk-posnr
                               etenr = wa_idnrk-etenr.
            IF sy-subrc = 0.
              lv_mat_qty = wa_material2-mat_qty.
            ENDIF.
          ENDIF.
        ENDIF.
*************


*        PERFORM bom_fm TABLES t_stb
*                        USING   lv_mat_qty
*                                lv_matnr
*                                p_werks
*                             .
*        LOOP AT t_stb INTO wa_stb.
*          IF wa_stb-idnrk = wa_idnrk-idnrk.
*            so_qty = wa_stb-mnglg.
*          ENDIF.
*        ENDLOOP.

        CLEAR wa_material3.
        READ TABLE it_material INTO wa_material3
        WITH KEY      so_no = wa_idnrk-vbeln
                       posnr = wa_idnrk-posnr
                       etenr = wa_idnrk-etenr
                       comp_mat = wa_idnrk-idnrk
                       plant = wa_idnrk-plant.
        IF sy-subrc = 0.
          so_qty = wa_material3-mat_qty.
        ENDIF.


******Production order and reservation details.<WIP>
        CLEAR wa_stock.
        READ TABLE it_stock INTO wa_stock
            WITH KEY matnr = wa_idnrk-idnrk.
        IF sy-subrc = 0.
*if wip exist for this component use this wip for further calculation
          wa_final_new-wip_stk = wa_stock-wip_stk.
        ELSE.
          IF prod_ord IS INITIAL.
            CLEAR wa_material3.
            READ TABLE it_material INTO wa_material3
            WITH KEY so_no = wa_idnrk-vbeln
                           posnr = wa_idnrk-posnr
                           etenr = wa_idnrk-etenr
                           comp_mat = wa_idnrk-idnrk
                           plant = wa_idnrk-plant.
            IF sy-subrc = 0.
              CLEAR: wa_mdps2, it_mdps2.
              REFRESH: it_mdps2, it_afpo.
              CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
                EXPORTING
                  matnr = wa_material3-act_matnr
                  werks = wa_idnrk-plant
                TABLES
                  mdpsx = it_mdps2.

*              LOOP AT it_mdps2 INTO wa_mdps2 WHERE (  kdauf = space or ( kdauf = wa_idnrk-vbeln
              LOOP AT it_mdps2 INTO wa_mdps2 WHERE delkz = 'FE'.
*                IF wa_mdps2-delkz = 'FE'.
                wa_order-order =  wa_mdps2-del12.
                APPEND wa_order TO it_order.
*                ENDIF.
              ENDLOOP.
              IF it_order[] IS NOT INITIAL.
                SELECT aufnr psmng wemng FROM afpo INTO CORRESPONDING FIELDS
                  OF TABLE it_afpo FOR ALL ENTRIES IN it_order WHERE
                  aufnr = it_order-order.
                CLEAR: wa_afpo2, wa_resb, wa_final_new-wip_stk.
                LOOP AT it_afpo INTO wa_afpo2.
                  CLEAR wa_resb.
                  SELECT SINGLE matnr
                                  bdmng
                                  enmng
                                  aufnr
                            FROM  resb
                            INTO CORRESPONDING FIELDS OF  wa_resb
                              WHERE aufnr = wa_afpo2-aufnr
                              AND matnr = wa_idnrk-idnrk
                              AND xloek <> 'X'              "
                              AND enmng > 0
                              AND shkzg = 'H'.
                  IF sy-subrc = 0.
                    wa_resb-wipqty = wa_resb-enmng - ( wa_afpo2-wemng * (
                                     wa_resb-bdmng / wa_afpo2-psmng ) ).
                    IF wa_resb-wipqty > 0.
                      wa_final_new-wip_stk = wa_final_new-wip_stk + wa_resb-wipqty.
                    ENDIF.
                  ENDIF.
                ENDLOOP.
              ENDIF.
            ENDIF.
            REFRESH: it_mdps2, it_afpo, it_order.
            CLEAR: wa_mdps2, wa_afpo2, wa_resb..
          ELSEIF NOT prod_ord IS INITIAL.
            SELECT SINGLE aufnr
                   psmng
                   wemng
              FROM afpo
              INTO CORRESPONDING FIELDS OF wa_afpo
              WHERE aufnr = prod_ord.
*          AND ELIKZ <> 'X'

            SELECT SINGLE matnr
                         bdmng
                         enmng
                         aufnr
                    FROM resb
                    INTO CORRESPONDING FIELDS OF  wa_resb
                      WHERE aufnr = prod_ord
                      AND matnr = wa_idnrk-idnrk
                      AND xloek <> 'X'
                      AND enmng > 0
                      AND shkzg = 'H'.

            IF sy-subrc = 0.
              wa_resb-wipqty = wa_resb-enmng - ( wa_afpo-wemng * (
  wa_resb-bdmng / wa_afpo-psmng ) ).
              IF wa_resb-wipqty > 0.
                wa_final_new-wip_stk = wa_resb-wipqty.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

*        rem_qty = so_qty - wa_final_new-wip_stk.
        rem_qty = so_qty." - wa_final_new-wip_stk.

*_____________________________________________

* Start of Stock Netting
*------------------------------------------------
*data: rem_qty type vbap-kwmeng.
        READ TABLE it_stock INTO wa_stock
        WITH KEY matnr = wa_idnrk-idnrk.
        IF sy-subrc <> 0.
          wa_stock-matnr = wa_idnrk-idnrk.
          wa_stock-rt_stock = avail_stock.
          wa_stock-qm_net_stock = avail_qm.
          wa_stock-block_stk = avail_block.
          wa_stock-wip_stk = wa_final_new-wip_stk.
*          WA_STOCK-VEN_NET_STK = AVAIL_VS.
          APPEND wa_stock TO it_stock.
        ENDIF.
        CLEAR so_wip.
        READ TABLE it_stock INTO wa_stock
         WITH KEY matnr = wa_idnrk-idnrk.
*        IF FLAG <> 1.
*          WA_STOCK-MATNR = WA_IDNRK-IDNRK.
********wip allocation
        IF wa_stock-wip_stk >= rem_qty.
          so_wip = rem_qty.
          wa_stock-wip_stk = wa_stock-wip_stk - rem_qty.
          rem_qty = 0.
        ELSE.
*          so_wip = wa_final_new-wip_stk.
          so_wip = wa_stock-wip_stk.
          wa_final_new-wip_stk = 0.
          rem_qty = rem_qty - so_wip.
*        ENDIF.
          IF wa_stock-rt_stock >= rem_qty.
            so_stock = rem_qty.
            wa_stock-rt_stock = wa_stock-rt_stock - rem_qty.
            rem_qty = 0.
          ELSE.
            so_stock = wa_stock-rt_stock.
            wa_stock-rt_stock = 0.
            rem_qty = rem_qty - so_stock.
            IF  wa_stock-qm_net_stock >= rem_qty .
              so_stock_qm = rem_qty.
              wa_stock-qm_net_stock = wa_stock-qm_net_stock - rem_qty.
              rem_qty = 0.
            ELSE.
              so_stock_qm = wa_stock-qm_net_stock.
              wa_stock-qm_net_stock = 0.
              rem_qty = rem_qty - so_stock_qm.
              IF wa_stock-block_stk >= rem_qty.
                blk_stk = rem_qty.
                wa_stock-block_stk = wa_stock-block_stk - rem_qty.
*              WA_STOCK-VEN_NET_STK = WA_STOCK-VEN_NET_STK - REM_QTY.
                rem_qty = 0.
              ELSE.
                blk_stk = wa_stock-block_stk.
                avail_block = 0.
                wa_stock-block_stk = avail_block .
                rem_qty = rem_qty - blk_stk.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

*        wa_final_new-wip_stk = so_wip.
        wa_stock-wip_stk = wa_final_new-wip_stk .

        MODIFY it_stock
        FROM wa_stock
        TRANSPORTING rt_stock
                     qm_net_stock
                     block_stk
                     wip_stk
        WHERE matnr = wa_idnrk-idnrk .

        wa_final_new-wip_stk = so_wip. " wip for display

        CLEAR : wa_stock.
*        ENDIF.
* End of Stock Netting
*----------------------------------------------------
*        IF SO_QTY > SO_STOCK.
        short_qty = rem_qty.
        CLEAR rem_qty.

*Start of Po & Pr Netting ----------------logic as on
*27/06/2011--------------------------------
        SORT it_po BY matnr reqd_dt.
        SORT it_pr BY matnr reqd_dt.
        rem_qty = short_qty.
        LOOP AT it_po INTO wa_po WHERE matnr = wa_idnrk-idnrk." and
*rem_qty > 0.
          IF rem_qty > 0.
            IF rem_qty <= wa_po-poqty.
*         wa_final-po_qty = rem_qty.
*         wa_final-act_dt = wa_po-reqd_dt.
              wa_po-poqty = wa_po-poqty - rem_qty.
              rem_qty = 0.
            ELSE.
              rem_qty = rem_qty - wa_po-poqty.
              wa_po-poqty = 0.
            ENDIF.
            wa_final-po_qty = short_qty -  rem_qty.
            IF NOT wa_final-act_dt IS INITIAL.
              IF wa_final-act_dt > wa_po-reqd_dt.
                wa_final-act_dt = wa_po-reqd_dt.
              ENDIF.
            ELSE.
              wa_final-act_dt = wa_po-reqd_dt.
            ENDIF.


            MODIFY it_po
              FROM wa_po
              TRANSPORTING poqty
              WHERE matnr = wa_idnrk-idnrk AND pono = wa_po-pono .
          ENDIF.
        ENDLOOP.

        IF rem_qty > 0.
          LOOP AT it_pr INTO wa_pr WHERE matnr = wa_idnrk-idnrk." and
*rem_qty > 0.
            IF rem_qty > 0.
              IF rem_qty <= wa_pr-prqty.
                wa_pr-prqty = wa_pr-prqty - rem_qty.
                rem_qty = 0.
              ELSE.
                rem_qty = rem_qty - wa_pr-prqty.
                wa_pr-prqty = 0.
              ENDIF.
              wa_final-pr_qty = short_qty - wa_final-po_qty - rem_qty.

              IF NOT wa_final-act_dt IS INITIAL.
                IF wa_final-act_dt > wa_pr-reqd_dt.
                  wa_final-act_dt = wa_pr-reqd_dt.
                ENDIF.
              ELSE.
                wa_final-act_dt = wa_pr-reqd_dt.
              ENDIF.


              MODIFY it_pr
                FROM wa_pr
                TRANSPORTING prqty
                WHERE matnr = wa_idnrk-idnrk AND prno = wa_pr-prno .
            ENDIF.
          ENDLOOP.
        ENDIF.
** End of PR & PO Netting ----------------------logic as on
*27/06/2011----------------------------
*        IF WA_IDNRK-LEVEL = 0.
*          HEADER    = WA_IDNRK-IDNRK."====CHANGE================="
*          HEADER_DESC = WA_IDNRK-MAKTX.
*
*        ENDIF.
        READ TABLE it_material INTO wa_material
      WITH KEY so_no = wa_idnrk-vbeln
               posnr = wa_idnrk-posnr
               etenr = wa_idnrk-etenr
               comp_mat = wa_idnrk-idnrk
               plant = p_werks.
        IF sy-subrc = 0.
          header = wa_material-head_mat.
*         read TABLE it_IDNRK INTO WA_IDNRK1 WITH KEY IDNRK = HEADER.
*         HEADER_DESC = WA_IDNRK1-MAKTX.
          SELECT SINGLE maktx FROM makt INTO header_desc
             WHERE matnr = header.
        ENDIF.
        "======Changes on
*25/05/2011=========================================================="
        READ TABLE  it_mara   INTO  w_mara WITH KEY matnr =  wa_idnrk-idnrk.
        READ TABLE  it_marc   INTO  wa_marc WITH KEY matnr = wa_idnrk-idnrk.
        READ TABLE  it_mbew   INTO  wa_mbew WITH KEY matnr = wa_idnrk-idnrk.
        READ TABLE  it_vbak   INTO  w_vbak WITH KEY vbeln =  wa_idnrk-vbeln.
        READ TABLE  it_kna1   INTO  wa_kna1 WITH KEY kunnr = w_vbak-kunnr.
        "===Changes on
*14/06/2011==========================================="
        wa_final_new-pr_qty_verpr = wa_final-pr_qty * wa_mbew-verpr.
        wa_final_new-po_qty_verpr = wa_final-po_qty * wa_mbew-verpr.
        wa_final_new-zseries   = w_mara-zseries.
        wa_final_new-brand     = w_mara-brand.
        wa_final_new-zsize     = w_mara-zsize.
        wa_final_new-moc       = w_mara-moc.
        wa_final_new-type      = w_mara-type.
        wa_final_new-mtart     = w_mara-mtart.
        wa_final_new-bismt     = w_mara-bismt.
        wa_final_new-dispo     = wa_marc-dispo.
        wa_final_new-beskz     = wa_marc-beskz.
        wa_final_new-verpr     = wa_mbew-verpr.
        wa_final_new-customer  = wa_kna1-name1.
        wa_final_new-header    = header.
        wa_final_new-header_desc = header_desc.
        wa_final_new-plant     = wa_idnrk-plant.
        wa_final_new-stufe     = wa_final-stufe.
        wa_final_new-vbeln   = wa_idnrk-vbeln. .
        wa_final_new-posnr   = wa_idnrk-posnr.  "WA_IDNRK-POSNR
        wa_final_new-etenr   = wa_idnrk-etenr.
        CLEAR lv_so_plant.
        SELECT SINGLE werks FROM vbap INTO lv_so_plant WHERE
          vbeln = wa_final_new-vbeln AND posnr = wa_final_new-posnr.
        wa_final_new-so_plant = lv_so_plant.


        wa_final_new-matnr   = wa_idnrk-idnrk.  "component
        wa_final_new-arktx   = wa_idnrk-maktx.  "WA_FINAL-ARKTX
        wa_final_new-uom     = wa_idnrk-uom.    "WA_FINAL-UOM
        wa_final_new-edatu   = wa_idnrk-edatu.  "WA_FINAL-VDATU
        wa_final_new-wmeng  = wa_idnrk-wmeng."WA_FINAL-KWMENG.
        wa_final_new-open_so = so_qty.
        wa_final_new-unres_stk  = so_stock .
        wa_final_new-qm_stk = so_stock_qm.
        wa_final_new-block_stk = blk_stk.
*        WA_FINAL_NEW-VENDOR_STK = VENDOR_STK.
        wa_final_new-deldate  = wa_idnrk-deldate.
        wa_final_new-short_qty = short_qty .

*if shortage qty = 0 , then PO Oty is assigned 0 value
        IF wa_final_new-short_qty = 0.
          wa_final_new-po_qty = 0.
        ELSE.
          wa_final_new-po_qty  = wa_final-po_qty.
        ENDIF.
        wa_final_new-net_indent = wa_final_new-short_qty -  wa_final_new-po_qty .
*net indent zeroed if < 0
        IF wa_final_new-net_indent < 0.
          wa_final_new-net_indent = 0.
        ENDIF.
*        WA_FINAL_NEW-PO_NO   = WA_FINAL-PO_NO."WA_FINAL-PO_NO.
        wa_final_new-pr_qty  = wa_final-pr_qty .
        wa_final_new-act_dt     = wa_idnrk-act_dt.
        wa_final_new-action_dt = wa_idnrk-action_dt .
        wa_final_new-action_days = wa_idnrk-actdys.
        wa_final_new-act_matnr = wa_final-act_matnr.

        SHIFT wa_final_new-vbeln LEFT DELETING LEADING '0'.
        SHIFT wa_final_new-matnr LEFT DELETING LEADING '0'.
        SHIFT wa_final_new-header LEFT DELETING LEADING '0'.

        CLEAR: wa_marc1, wa_mbew1.
        SELECT SINGLE * FROM marc INTO wa_marc1 WHERE
          matnr = wa_final_new-matnr AND werks = p_werks.

        SELECT SINGLE * FROM mbew INTO wa_mbew1 WHERE
          matnr = wa_final_new-matnr AND bwkey = p_werks.

        wa_final_new-action_days = wa_marc1-plifz.
        wa_final_new-dispo = wa_marc1-dispo.
        wa_final_new-beskz = wa_marc1-beskz.
        wa_final_new-sobsl = wa_marc1-sobsl.
        wa_final_new-verpr = wa_mbew1-verpr.

* To display records with werks as P_werks as per selection screen only.
        wa_final_new-plant2 = wa_idnrk-plant2.
        IF lv_werks = wa_final_new-plant AND wa_final_new-open_so <> 0.
          APPEND wa_final_new TO it_final_new.
        ENDIF.
*************************************
        REFRESH t_stb.
        CLEAR: lv_mat_qty, lv_matnr.
        lv_matnr = wa_idnrk-idnrk.
        lv_mat_qty = wa_final_new-net_indent.
        PERFORM bom_fm TABLES t_stb
                                USING   lv_mat_qty
                                        lv_matnr
                                        p_werks.

        CLEAR wa_stb_tmp.
*              READ TABLE t_stb INTO wa_stb_tmp WITH KEY  IDNRK =
*              wa_material-act_matnr = wa_stb_tmp-idnrk.
        LOOP AT t_stb INTO wa_stb_tmp WHERE stufe = 1.
          CLEAR wa_material.
          IF lv_mat_qty = 0.
            wa_material-mat_qty = 0.
          ELSEIF lv_mat_qty <> 0.
            wa_material-mat_qty = wa_stb_tmp-mnglg.
          ENDIF.
          MODIFY it_material
                  FROM wa_material
                  TRANSPORTING mat_qty
                  WHERE comp_mat = wa_stb_tmp-idnrk
**      WHERE head_mat = wa_idnrk-idnrk
                AND plant = p_werks
                AND so_no = wa_idnrk-vbeln
                AND posnr = wa_idnrk-posnr
                AND etenr = wa_idnrk-etenr.

        ENDLOOP.


**************************************
*        wa_material-mat_qty = so_qty.
*
*        MODIFY it_material
*        FROM wa_material
*        TRANSPORTING mat_qty
*        WHERE comp_mat = wa_idnrk-idnrk
***      WHERE head_mat = wa_idnrk-idnrk
*      AND plant = p_werks
*      AND so_no = wa_idnrk-vbeln
*      AND posnr = wa_idnrk-posnr
*      AND etenr = wa_idnrk-etenr.

        CLEAR:
          so_stock ,
          so_qty ,
          short_qty ,
          po_qty ,
          so_stock_qm,
          avail_stock,
          avail_qm,
          avail_vs,
          rem_qty,
*          VENDOR_STK,
          blk_stk,
          wa_final_new,
*          wa_prpo,
          tot_pr,
          action_days,
          tot_po.
        .

        CLEAR wa_final.
      ENDAT.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " COL
*&---------------------------------------------------------------------*


FORM data_display .

**&---------------------------------------------------------------------
*
**&  INCLUDE           ZPP_SO_SHORTAGES_COPY_ALV
**&---------------------------------------------------------------------
** STORE REPORT NAME
  i_repid = sy-repid.


  PERFORM build_fieldcat USING 'VBELN'       'X' '1'  'Sales Order'(003).
  PERFORM build_fieldcat USING 'POSNR'       ' ' '2'  'Sales Item'(007).
  PERFORM build_fieldcat USING 'ETENR'       ' ' '3'  'Schedule Lines'(041).
  PERFORM build_fieldcat USING 'PLANT'       ' ' '4'  'Plant'(008).
  PERFORM build_fieldcat USING 'PLANT2'      ' ' '5'  'Supplying Plant'.
  PERFORM build_fieldcat USING 'HEADER'      ' ' '6'  'Header Material'(009).
  PERFORM build_fieldcat USING 'HEADER_DESC' ' ' '7'  'Header Description'(036).
  PERFORM build_fieldcat USING 'MATNR'       ' ' '8'  'Components'(010).
  PERFORM build_fieldcat USING 'STUFE'       ' ' '9'  'Level'.
  PERFORM build_fieldcat USING 'ARKTX'       ' ' '10'  'Description'(011).
  PERFORM build_fieldcat USING 'MTART'       ' ' '11' 'Material Type'(071).
  PERFORM build_fieldcat USING 'UOM'         ' ' '12'  'UOM'(037).
  PERFORM build_fieldcat USING 'CUSTOMER'    ' ' '13'  'Customer'(012).
  PERFORM build_fieldcat USING 'EDATU'       ' ' '14'  'Prod. Del.Date'(013).
  PERFORM build_fieldcat USING 'WMENG'      ' ' '15'  'Qty in Salesunit'(014).
  PERFORM build_fieldcat USING 'OPEN_SO'     ' ' '16'  'Open SO Qty'(015).
  PERFORM build_fieldcat USING 'UNRES_STK'   ' ' '17'  'Stock Unrestricted'(016).
  PERFORM build_fieldcat USING 'QM_STK' ' '  '18' 'Stock Quality'(017).
*  PERFORM BUILD_FIELDCAT USING 'VENDOR_STK'  ' ' '13' 'Vendor Stock'(018).
  PERFORM build_fieldcat USING 'BLOCK_STK'  ' ' '19' 'Block Stock'. "(018).
  PERFORM build_fieldcat USING 'WIP_STK'     ' ' '20' 'WIP Stock'(019).
  PERFORM build_fieldcat USING 'SHORT_QTY'   ' ' '21' 'Shortage Qty.'(020).
*  PERFORM BUILD_FIELDCAT USING 'PR_NO'       ' ' '15' 'Purch Req no'.
  PERFORM build_fieldcat USING 'PR_QTY'      ' ' '22' 'PR Qty'(021).
*  PERFORM BUILD_FIELDCAT USING 'PO_NO'       ' ' '17' 'PO Number'.
  PERFORM build_fieldcat USING 'PO_USD'      ' ' '23' 'PO Qty'.
  PERFORM build_fieldcat USING 'PO_QTY'      ' ' '23' 'Net PO Qty'.
*  PERFORM build_fieldcat USING 'ACT_MATNR'      ' ' '24' 'Act_matnr'(040).
  PERFORM build_fieldcat USING 'ACTION_DT'   ' ' '24' 'Action Date'(023).
  PERFORM build_fieldcat USING 'ACTION_DAYS'   ' ' '25' 'Action Days'(038).
*===========Changes on 13/05/2011
  PERFORM build_fieldcat USING 'ACT_DT'      ' ' '26' 'Required Date'(024).
  PERFORM build_fieldcat USING 'DISPO'       ' ' '27' 'MRP Controller'(025).
  PERFORM build_fieldcat USING 'BESKZ'       ' ' '28' 'Procurement Type'(026).
  PERFORM build_fieldcat USING 'BRAND'       ' ' '29' 'Brand'(027).
  PERFORM build_fieldcat USING 'ZSERIES'     ' ' '30' 'Series'(028).
  PERFORM build_fieldcat USING 'ZSIZE'       ' ' '31' 'Size'(029).
  PERFORM build_fieldcat USING 'MOC'         ' ' '32' 'MOC'(030).
  PERFORM build_fieldcat USING 'TYPE'        ' ' '33' 'Type'(031).
  PERFORM build_fieldcat USING 'BISMT'        ' ' '34' 'Old Material Number'(032).
  PERFORM build_fieldcat USING 'VERPR'       ' ' '35' 'Moving Avg.Price'(033).
  PERFORM build_fieldcat USING 'PR_QTY_VERPR' ' ' '36' 'PR_Valuation'(034).
  PERFORM build_fieldcat USING 'PO_QTY_VERPR' ' ' '37' 'PO_Valuation'(035).
  PERFORM build_fieldcat USING 'DELDATE'   ' ' '38' 'DEL DATE'(039).
  PERFORM build_fieldcat USING 'NET_INDENT'   ' ' '39' 'Net Indent'(070).
  PERFORM build_fieldcat USING 'SO_PLANT'   ' ' '40' 'Sales Order Plant'.
  PERFORM build_fieldcat USING 'SOBSL'   ' ' '41' 'Special Procurement'.
  PERFORM build_fieldcat USING 'SCHID'   ' ' '42' 'Schedule ID'.
*  PERFORM BUILD_FIELDCAT USING 'DELDATE'      ' ' '32' 'Deldate' (039).
*===========Changes on 13/05/2011


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
*
      i_structure_name   = 'TY_FINAL'
      is_layout          = wa_layout
      it_fieldcat        = it_fcat
      i_default          = 'X'
      i_save             = 'A'
      it_events          = gt_events[]
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*      it_sort            = i_sort
    TABLES
      t_outtab           = it_final_new
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
*&AT SELECTING INPUT OPTION
*&---------------------------------------------------------------------*

FORM data_input .

  SELECT   so_no
           so_item
           quantity
           deldt
           FROM zsoplan
           INTO CORRESPONDING FIELDS OF TABLE it_zsoplan
           WHERE zmonth IN p_month
           AND    zyear IN p_year.
  IF sy-subrc EQ 0.
    SORT it_zsoplan BY deldt.  "so_no
  ENDIF.

  IF NOT it_zsoplan[] IS INITIAL.

    SELECT    vbeln
              posnr
              matnr
              arktx
              werks
              meins
              kwmeng
              FROM  vbap
              INTO CORRESPONDING FIELDS OF TABLE i_vbap
              FOR ALL ENTRIES IN it_zsoplan
              WHERE vbeln =  it_zsoplan-so_no
              AND    posnr = it_zsoplan-so_item
              AND werks = p_werks1.
*  ENDIF.

    IF NOT i_vbap[] IS INITIAL.

      SELECT vbeln
             vdatu
           FROM vbak
           INTO CORRESPONDING FIELDS OF TABLE i_vbak
           FOR ALL ENTRIES IN i_vbap
           WHERE vbeln =  i_vbap-vbeln .
      IF sy-subrc EQ 0.
        SORT i_vbak BY vbeln.
      ENDIF.

      SELECT vbeln
             posnr
             lfsta
           FROM vbup
           INTO CORRESPONDING FIELDS OF TABLE it_vbup
           FOR ALL ENTRIES IN i_vbap
                WHERE vbeln     =  i_vbap-vbeln
                AND   posnr     =  i_vbap-posnr.
      IF sy-subrc EQ 0.
        SORT it_vbup BY vbeln posnr.
      ENDIF.

    ENDIF.

    LOOP AT i_vbap INTO wa_vbap.

      wa_data-vbeln = wa_vbap-vbeln.
      wa_data-posnr = wa_vbap-posnr.
      wa_data-matnr = wa_vbap-matnr.
      wa_data-arktx = wa_vbap-arktx.
      wa_data-werks = wa_vbap-werks.
      wa_data-meins = wa_vbap-meins.
      wa_data-wmeng = wa_vbap-kwmeng.


      READ TABLE it_zsoplan INTO wa_zsoplan WITH KEY so_no =
  wa_vbap-vbeln so_item = wa_vbap-posnr
              BINARY SEARCH.
      IF sy-subrc = 0.
        wa_data-edatu = wa_zsoplan-deldt.
      ENDIF.



      CLEAR wa_vbak.

      READ TABLE it_vbup INTO wa_vbup WITH KEY vbeln = wa_vbap-vbeln
                 posnr = wa_vbap-posnr
                 BINARY SEARCH.
      IF sy-subrc = 0.
        wa_data-lfsta = wa_vbup-lfsta.
      ENDIF.
      CLEAR wa_vbup.

      APPEND wa_data TO it_data.
      p_werks = wa_data-werks.
      CLEAR : wa_vbap, wa_data.
    ENDLOOP.

    PERFORM bom_explode.
    PERFORM stock_req.

    PERFORM add_schid.

    IF p_down IS INITIAL.
      PERFORM data_display.
    ELSE.
      PERFORM down_set.
    ENDIF.
  ELSEIF it_zsoplan[] IS INITIAL.
    MESSAGE 'No Data found'
             TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE  LIST-PROCESSING.
  ENDIF.
ENDFORM.                    " DATA_INPUT
*&---------------------------------------------------------------------*
*&      Form  SORT_TABLE_BUILD
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*****fill it_idnrk in fetch_data
*----------------------------------------------------------------------*
*      -->P_WA_DATA_MATNR  text
*      -->P_P_WERKS  text
*      -->P_WA_STB_TTIDX  text
*----------------------------------------------------------------------*
FORM fetch_data  USING  p_wa_data_matnr
                        p_p_werks
                        p_wa_stb_ttidx
                        p_wa_stb_stufe.
  CLEAR wa_idnrk.
  wa_idnrk-hdmat = wa_material-act_matnr.
  wa_idnrk-vbeln = wa_data-vbeln .
  wa_idnrk-posnr = wa_data-posnr .
  wa_idnrk-etenr = wa_data-etenr .
  wa_idnrk-edatu = wa_data-edatu .
  wa_idnrk-wmeng = wa_data-wmeng .
  wa_idnrk-etenr = wa_data-etenr .
  wa_idnrk-deldate = wa_data-deldate.
  SELECT SINGLE
            maktx
       FROM makt
      INTO  wa_idnrk-maktx
   WHERE matnr = p_wa_data_matnr AND spras = 'E'.

  SELECT SINGLE
         meins
    FROM mara
    INTO wa_idnrk-uom
    WHERE matnr = p_wa_data_matnr.

  wa_idnrk-idnrk = p_wa_data_matnr.

  SELECT SINGLE
          plifz AS actdys
          sbdkz
      INTO CORRESPONDING FIELDS OF wa_idnrk
      FROM marc
      WHERE matnr = p_wa_data_matnr
    AND werks = p_p_werks.

  wa_idnrk-level = p_wa_stb_ttidx.
  wa_idnrk-plant =  p_p_werks.
  wa_idnrk-plant2 =  pl_werks2.
* IF  wa_stb-sobsl = 'Z1' OR wa_stb-sobsl = 'Z2'
*    OR wa_stb-sobsl = 'Z3' OR wa_stb-sobsl = 'Z4' .
* clear wa_idnrk-stufe.
* else.
  wa_idnrk-stufe = p_wa_stb_stufe.
*endif.
  APPEND wa_idnrk TO it_idnrk.

  CLEAR wa_idnrk.
ENDFORM.                    " FETCH_DATA
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
            USING    p_reqqty
                      p_v_matnr
                      p_p_werks.


  CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
    EXPORTING
      capid                 = 'PP01'
      datuv                 = sy-datum
      emeng                 = p_reqqty
      mehrs                 = 'X'
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
*          MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " BOM_FM
*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_EVENTS[]  text
*----------------------------------------------------------------------*
FORM stp3_eventtab_build  CHANGING p_i_events TYPE slis_t_event..
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
  MODIFY p_i_events  FROM  lf_event INDEX 3 TRANSPORTING form."to
*p_i_events .

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
  lf_line-info = 'SALES ORDER SHORTAGES REPORT'(006).
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
*       it_layout-colwidth_optimize  = 'X'.
  wa_layout-zebra              = 'X'.
*       p_wa_layout-Info_fieldname   = 'C51'.
  p_wa_layout-zebra            = 'X'.
  p_wa_layout-no_colhead       = ' '.
*        p_wa_layout-box_fieldname    = 'BOX'.

ENDFORM.                    " LAYOUT_BUILD
*

FORM determine_req_dt.
  DATA : wa_idnrk_chld TYPE st_idnrk,
         chld_stufe    TYPE i,
         idx           TYPE sy-tabix.
  CLEAR : wa_idnrk, wa_idnrk_chld, chld_stufe.
  LOOP AT it_idnrk INTO wa_idnrk.
*  LOOP AT it_material into wa_material.
*    read table it_idnrk into wa_idnrk with key hdmat = wa_material-act_matnr
*                                               idnrk = wa_material-comp_mat.
    idx = sy-tabix.
    IF wa_idnrk-stufe IS INITIAL.
      wa_idnrk-act_dt = wa_idnrk-edatu.
      wa_idnrk-action_dt = wa_idnrk-act_dt - wa_idnrk-actdys.
      MODIFY it_idnrk FROM wa_idnrk
        TRANSPORTING act_dt action_dt
        WHERE hdmat = wa_idnrk-hdmat
          AND vbeln = wa_idnrk-vbeln
          AND posnr = wa_idnrk-posnr
          AND etenr = wa_idnrk-etenr
          AND idnrk = wa_idnrk-idnrk
          AND stufe = wa_idnrk-stufe.
    ENDIF.
    chld_stufe = wa_idnrk-stufe + 1.
    LOOP AT it_idnrk INTO wa_idnrk_chld WHERE hdmat = wa_idnrk-idnrk
                                          AND vbeln = wa_idnrk-vbeln
                                          AND posnr = wa_idnrk-posnr
                                          AND etenr = wa_idnrk-etenr
                                          AND stufe = chld_stufe.
      wa_idnrk_chld-act_dt = wa_idnrk-action_dt.
      wa_idnrk_chld-action_dt =
          wa_idnrk_chld-act_dt - wa_idnrk_chld-actdys.
      MODIFY it_idnrk FROM wa_idnrk_chld
        TRANSPORTING act_dt action_dt
        WHERE hdmat = wa_idnrk_chld-hdmat
          AND vbeln = wa_idnrk_chld-vbeln
          AND posnr = wa_idnrk_chld-posnr
          AND etenr = wa_idnrk_chld-etenr
          AND idnrk = wa_idnrk_chld-idnrk
          AND stufe = wa_idnrk_chld-stufe.
      CLEAR wa_idnrk_chld.
    ENDLOOP.
    " reset the curser to current record again for the correct data
    " retrieval from subsequent records.
    READ TABLE it_idnrk INTO wa_idnrk INDEX idx.
    CLEAR : wa_idnrk, chld_stufe.
  ENDLOOP.

ENDFORM.                    " GET_REQ_DT
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM down_set .

  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_final_new
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZPPSOS.TXT'.

  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPPSOS Download started on', sy-datum, 'at', sy-uzeit.
  WRITE: / 'Plant', p_werks.
  WRITE: / 'Sales Order No. From', s_vbeln-low, 'To', s_vbeln-high.
  WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
  WRITE: / 'SO Date         From', s_cdd-low, 'To', s_cdd-high.
  WRITE: / 'Dest. File:', lv_fullfile.

  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVD_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv TYPE any.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE
  'HEADER'
  'SO NO.'
  'POSN'
  'SCHEDULE LINE'
  'SO_PLANT'
  'MAT NR'
  'DESCRIPTION'
  'UOM'
  'PROD. DEL.DATE'
  'QTY'
  'OPEN SO QTY'
  'UNRES_STK'
  'QM_STK'
  'VENDOR_STK'
  'BLOCK_STK'
  'WIP_STK'
  'DEL DATE'
  'SO_BLOCK_STK'
  'SHORTAGE_QTY'
  'PO_QTY'
  'NET_PO_QTY'
  'PO_NO'
  'PR_QTY'
  'PR_NO'
  'ACTION_DT'
  'REQD_DT'
  'BRAND'
  'SERIES'
  'SIZE'
  'MOC'
  'TYPE'
  'MAT TYP'
  'OLD MAT NO'
  'MRP CONTRLR'
  'PROC TYPE'
  'MOV AVG PRICE'
  'CUSTOMER'
  'PR_VALUATION'
  'PO_VALUATION'
  'PLANT'
  'SUPPLY PLANT'
  'HEADER_DESC'
  'ACTION_DAYS'
  'ACT_MATNR'
  'LEVEL'
  'NET_INDENT'
  'SPL PROCUREMENT'
  'SCHEDULE_ID'
  INTO pd_csv
  SEPARATED BY l_field_seperator.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADD_SCHID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM add_schid .

  FIELD-SYMBOLS <fs_final> TYPE ty_final.

  LOOP AT it_final_new ASSIGNING <fs_final>.
    CONCATENATE <fs_final>-vbeln <fs_final>-posnr
      <fs_final>-etenr INTO <fs_final>-schid.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALC_POQTY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM calc_poqty .

  DATA ls_final TYPE ty_final.
  DATA lv_left_qty TYPE vbap-kwmeng.
  DATA lv_new.

  SORT it_final_new BY matnr vbeln posnr.

  LOOP AT it_final_new INTO ls_final.
    AT NEW matnr.
      CLEAR lv_left_qty.
      lv_new = 'X'.

    ENDAT.
    IF lv_new = 'X'.
      lv_left_qty = ls_final-po_qty.
      CLEAR lv_new.
    ENDIF.
    IF lv_left_qty > 0.
      IF lv_left_qty GE ls_final-short_qty.
        ls_final-po_usd = ls_final-short_qty.
        lv_left_qty = lv_left_qty - ls_final-short_qty.
        ls_final-pr_qty = 0.
      ELSE.
        ls_final-po_usd = lv_left_qty.
        ls_final-pr_qty = ls_final-short_qty - lv_left_qty.
        lv_left_qty = 0.
      ENDIF.
    ELSE.
      ls_final-pr_qty = ls_final-short_qty.
    ENDIF.
    MODIFY it_final_new FROM ls_final
      TRANSPORTING po_usd pr_qty.
  ENDLOOP.

ENDFORM.
