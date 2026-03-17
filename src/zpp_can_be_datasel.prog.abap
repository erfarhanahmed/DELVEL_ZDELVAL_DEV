*&---------------------------------------------------------------------*
*&  Include           ZPP_DA_ASSEMBLY_DATASEL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  INCLUDE           ZPP_SO_SHORTAGES_COPY_DATASEL
*&---------------------------------------------------------------------*
****SELECTION SCREEN RESULT

AT SELECTION-SCREEN.
*  IF RB_PLANT = 'X' AND V_PLNT_IND = 'X' .

  IF p_werks IS INITIAL.
*    MESSAGE E023.
    SET CURSOR FIELD 'P_WERKS'.
    MESSAGE 'Please Enter Plant'
       TYPE 'E'.
  ELSEIF p_werks IS NOT INITIAL.

    CLEAR wa_t001w.
    SELECT SINGLE *
      FROM t001w
      INTO wa_t001w
     WHERE werks = p_werks.

    IF sy-subrc <> 0.
      SET CURSOR FIELD 'P_WERKS'.
      MESSAGE 'Please Enter Correct Plant' TYPE 'E'.
    ENDIF.


  ENDIF.

  IF p_matnr IS INITIAL.
    SET CURSOR FIELD 'P_MATNR'.
    MESSAGE 'Please Enter Material'
       TYPE 'E'.
  ELSEIF p_matnr IS NOT INITIAL.

    CLEAR wa_mara.
    SELECT SINGLE *
      FROM mara
      INTO wa_mara
     WHERE matnr = p_matnr.

    IF sy-subrc <> 0.
      SET CURSOR FIELD 'P_MATNR'.
      MESSAGE 'Please Enter Correct Material' TYPE 'E'.
    ENDIF.
  ENDIF.

  IF  p_qty <= 0.
    SET CURSOR FIELD 'P_QTY'.
    MESSAGE 'Required Quantity should be greter than zero'
       TYPE 'E'.
  ENDIF.

*    IF S_VBELN IS INITIAL
*      AND S_MATNR IS INITIAL
*      AND S_CDD   IS INITIAL.
*      MESSAGE E024.
*    ENDIF.
*  ENDIF.
*******************added by jyoti on 13.06.2024****************************
 IF p_lgort IS INITIAL.
*    MESSAGE E023.
    SET CURSOR FIELD 'P_LGORT'.
    MESSAGE 'Please Enter Storage Location'
       TYPE 'E'.
  ELSEIF p_lgort IS NOT INITIAL.

    CLEAR wa_t001l.
    SELECT SINGLE *
      FROM t001l
      INTO wa_t001l
     WHERE lgort = p_lgort.

    IF sy-subrc <> 0.
      SET CURSOR FIELD 'P_LGORT'.
      MESSAGE 'Please Enter Correct Storage Location' TYPE 'E'.
    ENDIF.


  ENDIF.
********************************************************


START-OF-SELECTION.


*  IF RB_PLANT = 'X'.
  PERFORM data_plant.
*  ENDIF.
*
*  IF RB_INPUT = 'X'.
*    PERFORM DATA_INPUT.
*  ENDIF.


************************************************************************

****AT SELECTING PLANT OPTION

FORM data_plant .
*  SELECT A~VBELN A~POSNR A~MATNR A~ARKTX A~WERKS A~MEINS D~EDATU D~WMENG D~ETENR C~LFSTA
*     INTO CORRESPONDING FIELDS OF WA_DATA
*     FROM  VBEP AS D
*    JOIN VBAP AS A ON ( A~VBELN = D~VBELN  AND A~POSNR = D~POSNR )
*     JOIN  VBAK AS B ON ( B~VBELN = A~VBELN )
*     JOIN  VBUP AS C ON ( C~VBELN = B~VBELN  AND C~POSNR = A~POSNR )
**     WHERE A~VBELN IN S_VBELN
*      where A~WERKS  = P_WERKS
*      AND C~LFSTA  NE 'C'
*      AND  A~MATNR EQ p_MATNR
**      AND D~EDATU  IN S_CDD
*      AND D~WMENG NE 0.
*    APPEND WA_DATA TO IT_DATA.
*  ENDSELECT.
  lv_werks = p_werks.  " This variable is assigned the value of P_WERKS and used later for display purpose.



  PERFORM bom_explode.
*  PERFORM STOCK_REQ.
*  PERFORM TOT_REQ.
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
*  FM FOR BOM (BILL OF MATERIAL) EXPLODING.
*----------------------------------------------------------------------*

FORM bom_explode .

*  LOOP AT IT_DATA INTO WA_DATA.

  PERFORM bom_fm TABLES t_stb
              USING   p_qty         "Reqd Qty
                      p_matnr       "Material for which BOM needs to be exploded
                      p_werks.      "Plant


*****DATA FETCHING FOR MAKTX, MEINS AND SBDKZ FIELDS AT MATERIAL LEVEL.
  PERFORM fetch_data USING p_matnr  "Material
                           p_werks "P_WERKS        "Plant
                           0.      "Level

*==============================================================================*
*dATA : P_WERKS1 TYPE P_WERKS.
  " SOBSL -> Special Procurement Key

  CLEAR: itab_final, wa_itab_final.
  REFRESH itab_final.

  LOOP AT t_stb INTO wa_stb.
    CLEAR wa_itab_final.
*      IF NOT WA_STB-SOBSL IS INITIAL AND WA_STB-SOBSL <> '30'.
*
*        IF WA_STB-SOBSL = '90'.
*          PL_WERKS = 'PL01'.
*        ELSEIF WA_STB-SOBSL = '91'.
*          PL_WERKS = 'PL02'.
*        ELSEIF WA_STB-SOBSL = '92'.
*          PL_WERKS = 'PL03'.
*        ENDIF.
*
*        PERFORM BOM_FM TABLES T_STB1
*                       USING   0                      "Reqd Qty
*                               WA_STB-IDNRK           "Component Material for which BOM
*                               PL_WERKS.              "Plant
*
*        PERFORM FETCH_DATA USING WA_STB-IDNRK
*                           PL_WERKS
*                           0.
*
*        LOOP AT T_STB1 INTO WA_STB1.
*
*
*          PERFORM FETCH_DATA USING WA_STB1-IDNRK
*                             PL_WERKS
*                             WA_STB-TTIDX.
*
*          LV_STLNR = WA_STB1-STLNR.
*          " Component value asigned to the table.
*          WA_MATERIAL-SO_NO = WA_DATA-VBELN .
*          WA_MATERIAL-POSNR  = WA_DATA-POSNR .
*          WA_MATERIAL-COMP_MAT = WA_STB1-IDNRK.
*          WA_MATERIAL-PLANT = PL_WERKS.
*          IF WA_STB1-TTIDX = 1.
*            WA_MATERIAL-HEAD_MAT = WA_STB-IDNRK.

*          ELSE.
*            READ TABLE T_STB1 INTO WA_STB1 WITH KEY  XTLNR = LV_STLNR .
*            WA_MATERIAL-HEAD_MAT = WA_STB1-IDNRK.
*          ENDIF.
*          APPEND WA_MATERIAL TO IT_MATERIAL.
*          CLEAR : WA_MATERIAL.
*        ENDLOOP.

*      ELSE.

*=======================================================
    wa_idnrk-ratio = ( 1 / wa_stb-mngko ).
    PERFORM fetch_data USING wa_stb-idnrk
                             p_werks
                             wa_stb-ttidx.


    lv_stlnr = wa_stb-stlnr.
    " Component value asigned to the table.
*      WA_MATERIAL-SO_NO = WA_DATA-VBELN .
*      WA_MATERIAL-POSNR  = WA_DATA-POSNR . " item no needs to be added
    wa_material-comp_mat = wa_stb-idnrk.
    wa_material-plant = p_werks.

    IF wa_stb-ttidx = 1.
      wa_material-head_mat = wa_data-matnr.
    ELSE.
      READ TABLE t_stb INTO wa_stb WITH KEY  xtlnr = lv_stlnr .
      wa_material-head_mat = wa_stb-idnrk.
    ENDIF.
    APPEND wa_material TO it_material.

    CLEAR : wa_material.

*      ENDIF.
*=========================================================

    CLEAR: wa_idnrk.


***********************************
    CLEAR it_mdps.
    REFRESH it_mdps.
    CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
      EXPORTING
        matnr                    = wa_stb-idnrk
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
* DATA PASSED TO INTERNAL TABLE IT_MDPS FROM FM.
* CALCULATION TO BE DONE ON FIELD MRP ELEMENT (DELKZ) BASES ON THE CRITERIA.
    CLEAR: wa_mdps, tot_req, stock_reserve .

    LOOP AT it_mdps INTO wa_mdps WHERE lgort = p_lgort.
*TOTAL REQUIREMENT:- ( OPEN REQUIREMENT)
*SUM ALL REQUIREMENT QUANTITIES AGAINST MRP ELEMENT VC OR SB.

      IF  wa_mdps-delkz = 'VC'
        OR wa_mdps-delkz = 'SB'
        OR ( wa_mdps-delkz = 'BB' AND wa_mdps-plaab <> 26 )
        OR wa_mdps-delkz = 'U2'
        OR ( wa_mdps-delkz = 'AR' AND wa_mdps-plumi <> '+' ).

        tot_req          =  tot_req   + wa_mdps-mng01.
      ENDIF.

      IF   wa_mdps-delkz = 'AR'." and wa_mdps-plumi <> '+'.

        stock_reserve = stock_reserve + wa_mdps-mng01.
      ENDIF.


    ENDLOOP.

*Total stock unrestricted + quality - reserve qty
    CLEAR: unrestrict_stock, stock_quality.

    SELECT SUM( labst )
        SUM( insme )
        FROM mard
  INTO (unrestrict_stock ,
         stock_quality)
  WHERE matnr = wa_stb-idnrk
  AND werks = p_werks
*  AND lgort <> 'RJ01' AND lgort <> 'SCR1'.
*  AND lgort = 'RM01'."commented by jyoti on 13.06.2024
   AND lgort = p_lgort. "added by jyoti on 13.06.2024
************added by jyoti on 13.06.2024********************
      SELECT single lgort
        INTO lgort
         FROM mard
        WHERE matnr = wa_stb-idnrk
  AND werks = p_werks
    AND lgort = p_lgort."added by jyoti on 13.06.2024

    if  p_lgort = 'RM01'.
       SELECT SUM( labst )
       INTO (unrestrict_stock_new)
       FROM mard
       WHERE matnr = wa_stb-idnrk
       AND werks = p_werks
       AND lgort = 'KRM0'.
    elseif p_lgort = 'KRM0'.
       SELECT SUM( labst )
       INTO (unrestrict_stock_new)
       FROM mard
       WHERE matnr = wa_stb-idnrk
       AND werks = p_werks
       AND lgort = 'RM01'.
    endif.
*************************************************************
*---------------------------ADDED BY DIKSHA HALVE 05.01.2023
    SELECT SUM( bdmng )
          SUM( enmng )
          FROM resb
      INTO (reqmnt_qty ,
            qty_withdrawn )
      WHERE matnr = wa_stb-idnrk
  AND werks = p_werks
  AND bdart = 'AR'
  AND xloek NE 'X'
  AND kzear NE 'X'
  AND lgort = p_lgort."added by jyoti on 13.06.2024.

    wa_itab_final-reserve_qty = reqmnt_qty - qty_withdrawn.

* *************added by jyoti on 14.06.2024****************************
     if  p_lgort = 'RM01'.
        SELECT SUM( bdmng )
          SUM( enmng )
          FROM resb
      INTO (reqmnt_qty_new ,
            qty_withdrawn_new )
      WHERE matnr = wa_stb-idnrk
  AND werks = p_werks
  AND bdart = 'AR'
  AND xloek NE 'X'
  AND kzear NE 'X'
       AND lgort = 'KRM0'.
          wa_itab_final-reserve_qty_new = reqmnt_qty_new - qty_withdrawn_new.
    elseif p_lgort = 'KRM0'.
        SELECT SUM( bdmng )
          SUM( enmng )
          FROM resb
      INTO (reqmnt_qty_new ,
            qty_withdrawn_new )
      WHERE matnr = wa_stb-idnrk
  AND werks = p_werks
  AND bdart = 'AR'
  AND xloek NE 'X'
  AND kzear NE 'X'
       AND lgort = 'RM01'.
           wa_itab_final-reserve_qty_new = reqmnt_qty_new - qty_withdrawn_new.
    endif.


    SELECT SUM( menge )
           SUM( wemng )
      FROM mdbs
      INTO (scheduled_qty ,
            qty_delivered )
      WHERE  matnr = wa_stb-idnrk
      AND werks = p_werks
      AND bstyp = 'F'
      AND loekz NE 'L'
      AND elikz NE 'X'
      AND retpo NE 'X'
        AND lgort = p_lgort."added by jyoti on 13.06.2024.

    wa_itab_final-on_order_stock = scheduled_qty - qty_delivered.

* *************added by jyoti on 14.06.2024****************************
     if  p_lgort = 'RM01'.
       SELECT SUM( menge )
           SUM( wemng )
      FROM mdbs
      INTO (scheduled_qty_new ,
            qty_delivered_new )
      WHERE  matnr = wa_stb-idnrk
      AND werks = p_werks
      AND bstyp = 'F'
      AND loekz NE 'L'
      AND elikz NE 'X'
      AND retpo NE 'X'
       AND lgort = 'KRM0'.
          wa_itab_final-on_order_stock_new = scheduled_qty_new - qty_delivered_new.
    elseif p_lgort = 'KRM0'.
        SELECT SUM( menge )
           SUM( wemng )
      FROM mdbs
      INTO (scheduled_qty_new ,
            qty_delivered_new )
      WHERE  matnr = wa_stb-idnrk
      AND werks = p_werks
      AND bstyp = 'F'
      AND loekz NE 'L'
      AND elikz NE 'X'
      AND retpo NE 'X'
       AND lgort = 'RM01'.
           wa_itab_final-on_order_stock_new = scheduled_qty_new - qty_delivered_new.
    endif.
*************************************************************************
*------------------------------------------------------------------END OF ADDITION BY DIKSHA HALVE


*wa_itab_final-werks   = p_werks. " plant
*wa_itab_final-matnr   = p_matnr.  " Header Material
*add header material description
    CLEAR lv_maktx.

    SELECT SINGLE maktx
            FROM makt
            INTO lv_maktx
           WHERE matnr = p_matnr
            AND  spras = sy-langu.
*if sy-subrc = 0.
*wa_itab_final-maktx   = lv_maktx. " header material description
*endif.
     wa_itab_final-lgort   = lgort. "added by jyoti on 13.06.2024
     wa_itab_final-unrestrict_stock_new   = unrestrict_stock_new. "added by jyoti on 13.06.2024
    wa_itab_final-idnrk   = wa_stb-idnrk. " component
    wa_itab_final-ojtxp   = wa_stb-ojtxp. " component Description
    wa_itab_final-mnglg   = wa_stb-mnglg. "req qty from BOM explosion
    wa_itab_final-tot_req = tot_req. " MRP Tot Requirement
*    wa_itab_final-tot_stock = unrestrict_stock + stock_quality - stock_reserve..
    wa_itab_final-tot_stock = unrestrict_stock - stock_reserve . "- stock_quality.
    IF wa_itab_final-tot_stock < 0.
      wa_itab_final-tot_stock = 0.
    ENDIF.
    wa_itab_final-shortage = wa_itab_final-mnglg - wa_itab_final-tot_stock. "shortages
    IF wa_itab_final-shortage < 0.
      wa_itab_final-shortage = 0.
    ENDIF.

*RATE >> Moving Average price
    CLEAR wa_mbew.
    SELECT SINGLE matnr
           bwkey
           vprsv
           verpr
           stprs
           FROM mbew
           INTO wa_mbew
           WHERE matnr = wa_stb-idnrk
           AND bwkey   = p_werks.

    IF wa_mbew-vprsv = 'V'.
      wa_itab_final-rate = wa_mbew-verpr.
    ELSEIF wa_mbew-vprsv = 'S'.
      wa_itab_final-rate = wa_mbew-stprs.
    ENDIF.

    wa_itab_final-shortage_value = wa_itab_final-shortage * wa_itab_final-rate.
    IF wa_itab_final-mnglg <> 0.
*wa_itab_final-COMP_canbe = ( ( wa_itab_final-TOT_STOCK * p_qty ) / wa_itab_final-TOT_REQ ).
      wa_itab_final-comp_canbe = ( ( wa_itab_final-tot_stock * p_qty ) / wa_itab_final-mnglg ).
    ELSEIF wa_itab_final-mnglg = 0.
      wa_itab_final-comp_canbe = 0.
    ENDIF.

*if component can be is greater than entered required quantity
    IF wa_itab_final-comp_canbe > p_qty.
      wa_itab_final-comp_canbe = p_qty.
    ENDIF.

    SELECT SINGLE ekgrp INTO wa_itab_final-ekgrp FROM marc
            WHERE matnr = wa_stb-idnrk
              AND werks   = p_werks.
*--------------  Added 'Storage Bin' By Milind 06.01.2021  ----------*
    SELECT SINGLE lgpbe INTO wa_itab_final-lgpbe FROM mard
           WHERE matnr = wa_stb-idnrk
             AND werks   = p_werks
*  AND lgort = 'RM01'."commented by jyoti on 13.06.2024
   AND lgort = p_lgort."added by jyoti on 13.06.2024
*--------------------------------------------------------------------*
*-----------------------Added by Diksha Halve 04.01.22
    SELECT SINGLE insme INTO wa_itab_final-insme FROM mard
         WHERE matnr = wa_stb-idnrk
             AND werks   = p_werks
*  AND lgort = 'RM01'."commented by jyoti on 13.06.2024
   AND lgort = p_lgort."added by jyoti on 13.06.2024
if p_lgort = 'RM01'.
    SELECT SINGLE labst INTO wa_itab_final-labst FROM mard        "11.01.2023
      WHERE matnr = wa_stb-idnrk
              AND werks   = p_werks
              AND lgort = 'SC01'.
    ELSEIF p_lgort = 'KRM0'.
       SELECT SINGLE labst INTO wa_itab_final-labst FROM mard        "11.01.2023
      WHERE matnr = wa_stb-idnrk
              AND werks   = p_werks
              AND lgort = 'KSC0'.
  ENDIF.
*--------------------------------------------------------------------*

    APPEND wa_itab_final TO itab_final.
  ENDLOOP.

*find the least can be qty & Also compare with entered qty
  CLEAR: wa_itab_final, lv_actul_canbe.
  LOOP AT itab_final INTO wa_itab_final.
    IF sy-tabix = 1.
      lv_actul_canbe = wa_itab_final-comp_canbe.
    ENDIF.
    IF wa_itab_final-comp_canbe < lv_actul_canbe.
      lv_actul_canbe = wa_itab_final-comp_canbe.
    ENDIF.
  ENDLOOP.

*Maximum can be "lv_Actul_canbe"
  IF lv_actul_canbe > p_qty.
    lv_actul_canbe = p_qty.
  ENDIF.


*Plant Txt
  CLEAR lv_werks_txt.
  CONCATENATE 'Plant :' p_werks
  INTO lv_werks_txt SEPARATED BY space.
**************added by jyoti on 13.06.2024**********
* Storage Location txt
  CLEAR lv_lgort_txt.
  CONCATENATE 'Storage Location :' p_lgort
  INTO lv_lgort_txt SEPARATED BY space.
**********************************************
*Material Txt
  CLEAR lv_matnr_txt.
  CONCATENATE 'Material :' p_matnr
  INTO lv_matnr_txt SEPARATED BY space.

*Material Description Txt
  CLEAR lv_maktx_txt.
  CONCATENATE 'Description :' lv_maktx
  INTO lv_maktx_txt SEPARATED BY space.

*Required Qty Txt
  CLEAR: lv_qty, lv_req_txt.
  lv_qty = p_qty.
  CONCATENATE 'Required Quantity :' lv_qty
  INTO lv_req_txt SEPARATED BY space.

*Max can Be Txt
  CLEAR: lv_qty, lv_canbe_txt.
  lv_qty = lv_actul_canbe.
  CONCATENATE 'Maximum possible can be quantity :' lv_qty
  INTO lv_canbe_txt SEPARATED BY space.


*MODIFY FINAL TABLE WITH MAX POSSIBLE CAN BE QTY
*IF lv_Actul_canbe <> 0.
*loop at itab_final into wa_itab_final.
*if sy-tabix = 1.
*wa_itab_final-ACTUL_canbe = lv_Actul_canbe .
*MODIFY ITab_FINAL INDEX 1 FROM wa_itab_final TRANSPORTING ACTUL_CANBE.
*endif.
*endloop.
*ENDIF.


*SELECT MIN comp_canbe FROM itab_final into lv_Actul_canbe .


*****REFRESH TABLE AND CLEAR WORK AREA.
  REFRESH t_stb.
  CLEAR wa_stb.

*  ENDLOOP ." PROPOSED

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
             ekgrp
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
            knumv
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

    SELECT    knumv
           kposn
           kschl
           kbetr
*     FROM konv
     FROM PRCD_ELEMENTS
     INTO CORRESPONDING FIELDS OF TABLE it_konv
     FOR ALL ENTRIES IN it_vbak
      WHERE knumv = it_vbak-knumv AND kschl = 'ZPR0'.


  ENDIF.

*===========*===========*===========*===========
ENDFORM.                    " BOM_EXPLODE
*&---------------------------------------------------------------------*
*&      Form  TOT_REQ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM tot_req .
  CLEAR it_mdps.
  REFRESH it_mdps.
  CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
    EXPORTING
      matnr                    = p_matnr
      werks                    = p_werks
    TABLES
      mdpsx                    = it_mdps
*     MDEZX                    =
*     MDSUX                    =
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
  CLEAR: wa_mdps, tot_req.

  LOOP AT it_mdps INTO wa_mdps.
*TOTAL REQUIREMENT:- ( OPEN REQUIREMENT)
*SUM ALL REQUIREMENT QUANTITIES AGAINST MRP ELEMENT VC OR SB.

    IF  wa_mdps-delkz = 'VC'
      OR wa_mdps-delkz = 'SB'
      OR ( wa_mdps-delkz = 'BB' AND wa_mdps-plaab <> 26 )
      OR wa_mdps-delkz = 'U2'
      OR ( wa_mdps-delkz = 'AR' AND wa_mdps-plumi <> '+' ).

      tot_req          =  tot_req   + wa_mdps-mng01.
    ENDIF.
  ENDLOOP.
**Select unrestricted + quality - reserve qty
*
*  SELECT SUM( LABST )
*      SUM( INSME )
*      FROM MARD
*INTO (UNRESTRICT_STOCK ,
*       STOCK_QUALITY )
*WHERE MATNR = P_matnr
*AND WERKS = P_WERKS
*AND LGORT <> 'RJ01' AND LGORT <> 'SCR1'.

ENDFORM.                    "TOT_REQ

*&---------------------------------------------------------------------*
*&      FORM  STOCK_REQ
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*


FORM stock_req .
  DATA: lv_lines TYPE i,
        lv_tabix TYPE i.
  DESCRIBE TABLE it_idnrk LINES lv_lines.
* CHECK  THE IND CONDITION AND STATUS OF FLAG1.(header items WA_IDNRK-LEVEL = '0')
* CHECK  THE WA_IDNRK-LEVEL IF '0' AND SET FLAG1 TO 0.

  " If there is no reqmt for the header material then there is no need for the stock req
  lv_stkpos = 20000000.
  LOOP AT it_idnrk INTO wa_idnrk .
    lv_tabix = sy-tabix.
    IF ( flag1 NE '1' OR wa_idnrk-level = '0' OR p_werks <> wa_idnrk-plant ) AND wa_idnrk-idnrk <> '' .

      IF wa_idnrk-level = 0 AND lv_vbeln NE ' ' AND lv_stkpos NE 20000000.
        wa_final_new-canbqty = lv_stkpos.

        READ TABLE  it_vbak   INTO  w_vbak WITH KEY vbeln =  lv_vbeln.

        IF sy-subrc = 0.
          READ TABLE  it_konv   INTO  wa_konv WITH KEY knumv = w_vbak-knumv
                                                       kposn = lv_posnr.
        ENDIF.

        SHIFT lv_vbeln LEFT DELETING LEADING '0'.
        SHIFT lv_idnrk LEFT DELETING LEADING '0'.
        wa_final_new-amount = wa_final_new-canbqty * wa_konv-kbetr.
*        CONDENSE: lv_vbeln, LV_IDNRK.

        MODIFY it_final_new
           FROM wa_final_new
           TRANSPORTING canbqty amount
             WHERE vbeln = lv_vbeln AND plant = lv_plant
             AND matnr = lv_idnrk
             AND posnr = lv_posnr.
*        CLEAR LV_STKPOS.
        lv_stkpos = 20000000.
      ENDIF.

      p_werks = wa_idnrk-plant.
      flag1 = '0'.
      " FM to fetch the planning (MD04) for specified material.
      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          matnr                    = wa_idnrk-idnrk
          werks                    = p_werks
        TABLES
          mdpsx                    = it_mdps
        EXCEPTIONS
          material_plant_not_found = 1
          plant_not_found          = 2
          OTHERS                   = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      IF wa_idnrk-sbdkz = '1' OR wa_idnrk-level = 0.
        PERFORM ind TABLES it_idnrk it_mdps CHANGING flag1.
      ELSE.
        PERFORM coll TABLES it_idnrk it_mdps.
      ENDIF.
      CLEAR : avail_stock.


    ENDIF.


  ENDLOOP.


  IF  lv_tabix = lv_lines AND lv_stkpos NE 20000000.
*   IF WA_IDNRK-LEVEL = 0 AND LV_VBELN NE ' '.
    wa_final_new-canbqty = lv_stkpos.
    READ TABLE  it_vbak   INTO  w_vbak WITH KEY vbeln =  lv_vbeln.

    IF sy-subrc = 0.
      READ TABLE  it_konv   INTO  wa_konv WITH KEY knumv = w_vbak-knumv
                                                   kposn = lv_posnr.
    ENDIF.

    SHIFT lv_vbeln LEFT DELETING LEADING '0'.
    SHIFT lv_idnrk LEFT DELETING LEADING '0'.

    wa_final_new-amount = wa_final_new-canbqty * wa_konv-kbetr.
*        CONDENSE: lv_vbeln, LV_IDNRK.
    MODIFY it_final_new
       FROM wa_final_new
       TRANSPORTING canbqty amount
         WHERE vbeln = lv_vbeln AND plant = lv_plant
         AND matnr = lv_idnrk
         AND posnr = lv_posnr.
*        CLEAR LV_STKPOS.
    lv_stkpos = 20000000.
  ENDIF.
ENDFORM.                    " STOCK_REQ

*&---------------------------------------------------------------------*
*&      FORM  IND
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->IT_IDNRK   TEXT
*      -->IT_MDPS    TEXT
*----------------------------------------------------------------------*
FORM ind TABLES  it_idnrk it_mdps LIKE it_mdps CHANGING flag1.

*TO CHECK IF THE WA_IDNRK-VBELN = WA_MDPS-KDAUF AND WA_IDNRK-POSNR = WA_MDPS-KDPOS .
* SET FLAG1 TO 1.
*GOTO FORM STOCK REQ AND CHECK THIS CONDITION WITH WA_IDNRK-LEVEL.
  READ TABLE  it_mdps   INTO  wa_mdps WITH KEY kdauf =  wa_idnrk-vbeln
   kdpos = wa_idnrk-posnr .
*IF   WA_IDNRK-VBELN = WA_MDPS-KDAUF AND WA_IDNRK-POSNR  = WA_MDPS-KDPOS.
  IF sy-subrc NE 0.
    flag1 = 1.
  ENDIF.
*ENDLOOP.

  IF wa_idnrk-level = 0.
    lv_idnrk = wa_idnrk-idnrk.
    lv_vbeln = wa_idnrk-vbeln.
    lv_posnr = wa_idnrk-posnr.
    lv_plant = p_werks.
  ENDIF.

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
              edelps                = wa_mdps-delps    "000000
              eplscn                = 000
              ematnr                = wa_idnrk-idnrk
              ewerks                = p_werks
*             EPLWRK                = ' '
*             EPLAAB                = ' '
              eplanr                = wa_mdps-planr
*             EBERID                = ' '
*             EDAT00                = 00000000
            TABLES
*             EMDPSX                = it_mdpsx
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
          IF ( wa_mdps-delkz = 'VC' OR wa_mdps-delkz = 'SB'  OR wa_mdps-delkz = 'U2' OR wa_mdps-delkz = 'AR' OR wa_mdps-delkz = 'BB' ).
            so_qty    =  so_qty + wa_mdps-mng01.
          ENDIF.

*          IF WA_MDPS-DELKZ = 'BE' .   " purchase order
*            WA_FINAL-PO_QTY = WA_MDPS-MNG01.
*            WA_FINAL-PO_NO = WA_MDPS-DELNR.  "DELNR
*          ENDIF.
*=========Vendor Stk====13/05/2011
*        IF WA_MDPS-DELKZ = 'LK' .
*          VENDOR_STK  = VENDOR_STK + WA_MDPS-MNG01.
*        ENDIF.
*          IF WA_MDPS-DELKZ = 'FE' AND WA_IDNRK-LEVEL = 0.  " Production order
*            PROD_ORD  = WA_MDPS-DEL12.
*          ENDIF.
******PURCHASE REQUESITION NO**********
*          IF WA_MDPS-DELKZ = 'BA' .   "PURCHASE REQUISITION
*            WA_FINAL-PR_QTY = WA_MDPS-MNG01.
*            WA_FINAL-PR_NO = WA_MDPS-DELNR.

          "*****Action Date**********
*            SELECT SINGLE PLIFZ
*              INTO ACTION_DAYS
*              FROM MARC
*              WHERE MATNR = WA_IDNRK-IDNRK AND WERKS = P_WERKS.
*            WA_FINAL-ACT_DT = WA_MDPS-DAT00.
*            WA_FINAL-ACTION_DT = WA_MDPS-DAT00 - ACTION_DAYS.
********Action Date**********
*          ENDIF.

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
            AND lgort <> 'RJ01' AND lgort <> 'SCR1'.

          lv_stock = so_stock + so_stock_qm.
          wa_final_new-canbqty  = lv_stock * wa_idnrk-ratio.

          IF  lv_stkpos > wa_final_new-canbqty  AND wa_idnrk-level NE 0.
            lv_stkpos = wa_final_new-canbqty.
          ENDIF.

*          IF RB_INPUT = 'X'.
*            READ TABLE IT_ZSOPLAN INTO WA_ZSOPLAN
*            WITH KEY  SO_NO = WA_IDNRK-VBELN
*                      SO_ITEM = WA_IDNRK-POSNR.
*
*            IF WA_ZSOPLAN-QUANTITY > SO_QTY.
*              WA_ZSOPLAN-QUANTITY = SO_QTY.
*            ELSE.
*              SO_QTY = WA_ZSOPLAN-QUANTITY.
*            ENDIF.
*
*          ENDIF.

******Production order and reservation details.
*          IF NOT PROD_ORD IS INITIAL.
*            SELECT SINGLE AUFNR
*                   PSMNG
*                   WEMNG
*                   "MATNR
*              FROM AFPO
*              INTO CORRESPONDING FIELDS OF WA_AFPO
*              WHERE AUFNR = PROD_ORD.
**          AND ELIKZ <> 'X'
*
*            SELECT SINGLE MATNR
*                         BDMNG
*                         ENMNG
*                         AUFNR
*                    FROM RESB
*                    INTO CORRESPONDING FIELDS OF  WA_RESB
*                      WHERE AUFNR = PROD_ORD
*                      AND MATNR = WA_IDNRK-IDNRK
*                      AND XLOEK <> 'X'              "
*                      AND ENMNG > 0
*                      AND SHKZG = 'H'.
*
*            IF SY-SUBRC = 0.
*              WA_RESB-WIPQTY = WA_RESB-ENMNG - ( WA_AFPO-WEMNG * ( WA_RESB-BDMNG / WA_AFPO-PSMNG ) ).
*              IF WA_RESB-WIPQTY > 0.
*                WA_FINAL_NEW-WIP_STK = WA_RESB-WIPQTY.
*              ENDIF.
*
*            ENDIF.
*          ENDIF.

*_____________________________________________
          IF so_qty > so_stock.
            short_qty = so_qty - so_stock.
          ENDIF.

          IF so_qty = 0 AND wa_idnrk-level = 0.
            flag1 = 1.
          ENDIF.
          "======Changes on 25/05/2011=========================================================="
          READ TABLE  it_mara   INTO  w_mara WITH KEY matnr =  wa_idnrk-idnrk.
          READ TABLE  it_marc   INTO  wa_marc WITH KEY matnr =  wa_idnrk-idnrk.
          READ TABLE  it_mbew   INTO  wa_mbew WITH KEY matnr =  wa_idnrk-idnrk.
          READ TABLE  it_vbak   INTO  w_vbak WITH KEY vbeln =  wa_idnrk-vbeln.

          IF sy-subrc = 0.
            READ TABLE  it_konv   INTO  wa_konv WITH KEY knumv = w_vbak-knumv
                                                         kposn = wa_idnrk-posnr.
          ENDIF.

          READ TABLE  it_kna1   INTO  wa_kna1 WITH KEY kunnr =  w_vbak-kunnr.



          "==Changes on 13/05/2011=============================================================="
          wa_final_new-zseries   = w_mara-zseries.
          wa_final_new-brand     = w_mara-brand.
          wa_final_new-zsize     = w_mara-zsize.
          wa_final_new-moc       = w_mara-moc.
          wa_final_new-type      = w_mara-type.
          wa_final_new-mtart      = w_mara-mtart.
          wa_final_new-bismt      = w_mara-bismt.
          wa_final_new-dispo     = wa_marc-dispo.
          wa_final_new-ekgrp     = wa_marc-ekgrp.
          wa_final_new-beskz     = wa_marc-beskz.
          wa_final_new-verpr     = wa_mbew-verpr.
          wa_final_new-act_dt    = wa_final-act_dt.
          wa_final_new-customer  = wa_kna1-name1.
          wa_final_new-plant     = wa_idnrk-plant.
          wa_final_new-kbetr     = wa_konv-kbetr.
          wa_final_new-amount = wa_final_new-canbqty * wa_konv-kbetr.
          "===Changes on 14/06/2011==========================================="
*          PR_QTY_VERPR = WA_FINAL-PR_QTY * WA_MBEW-VERPR.
*          WA_FINAL_NEW-PR_QTY_VERPR = PR_QTY_VERPR.
*
*          PO_QTY_VERPR = WA_FINAL-PO_QTY * WA_MBEW-VERPR.
*          WA_FINAL_NEW-PO_QTY_VERPR = PO_QTY_VERPR.
          "================================================================"

          IF wa_idnrk-level = 0.
            header    = wa_idnrk-idnrk."====CHANGE================="
            header_desc = wa_idnrk-maktx.
          ENDIF.
*            so_no    TYPE vbap-vbeln,
*         posnr    TYPE vbap-posnr,
*         Head_mat TYPE mara-matnr,
*         comp_mat TYPE mara-matnr,
*         plant    TYPE marc-werks,
*         mat_Qty  TYPE vbap-kwmeng,

          READ TABLE it_material INTO wa_material
                WITH KEY so_no = wa_idnrk-vbeln
                         posnr = wa_idnrk-posnr
                         comp_mat = wa_idnrk-idnrk
                         plant = p_werks.
          IF sy-subrc = 0.
            header = wa_material-head_mat.
*         read TABLE it_IDNRK INTO WA_IDNRK1
*                  WITH KEY IDNRK = WA_IDNRK-IDNRK. "HEADER. "wa_material-head_mat.
*         READ TABLE IT_IDNRK INTO WA_IDNRK1
*         HEADER_DESC = WA_IDNRK1-MAKTX.
            SELECT SINGLE maktx FROM makt INTO header_desc
               WHERE matnr = header.
          ENDIF.


          wa_final_new-header = header.
          wa_final_new-header_desc = header_desc.
          wa_final_new-vbeln     = wa_idnrk-vbeln. .
          wa_final_new-posnr     = wa_idnrk-posnr. "WA_IDNRK-POSNR
          wa_final_new-matnr     = wa_idnrk-idnrk. "WA_FINAL-MATNR
          wa_final_new-arktx     = wa_idnrk-maktx. "WA_FINAL-ARKTX
          wa_final_new-uom       = wa_idnrk-uom.   "WA_FINAL-UOM
          wa_final_new-edatu     = wa_idnrk-edatu. "WA_FINAL-eDATU
          wa_final_new-wmeng    = wa_idnrk-wmeng."WA_FINAL-KWMENG.
          wa_final_new-open_so   = so_qty.
          wa_final_new-unres_stk = so_stock .
          wa_final_new-qm_stk        = so_stock_qm.
*          WA_FINAL_NEW-VENDOR_STK     = VENDOR_STK.
          wa_final_new-block_stk = so_block_stk.

          wa_final_new-short_qty = short_qty .
          wa_final_new-po_qty    = wa_final-po_qty.
          wa_final_new-po_no     = wa_final-po_no."WA_MDPS1-EBELN."WA_MDPS-EBELN."
          wa_final_new-pr_qty    = wa_final-pr_qty.
          wa_final_new-pr_no     = wa_final-pr_no.
          wa_final_new-action_dt = wa_final-action_dt.

*          SHIFT WA_FINAL_NEW-VBELN LEFT DELETING LEADING '0'.
          SHIFT wa_final_new-vbeln LEFT DELETING LEADING '0'.
          SHIFT wa_final_new-matnr LEFT DELETING LEADING '0'.
*          Condense WA_FINAL_NEW-PO_NO.
          SHIFT wa_final_new-header LEFT DELETING LEADING '0'.
* To display records with werks as P_werks as per selection screen only.
          IF lv_werks = wa_final_new-plant .
            APPEND wa_final_new TO it_final_new.
          ENDIF.


          CLEAR  wa_final_new.
          CLEAR  wa_final.
          CLEAR action_days.

          wa_material-mat_qty = so_qty.

          MODIFY it_material
          FROM wa_material
          TRANSPORTING mat_qty
            WHERE head_mat = wa_idnrk-idnrk AND plant = p_werks
            AND so_no = wa_idnrk-vbeln
            AND posnr = wa_idnrk-posnr.

          CLEAR:
            so_stock_qm,
            so_block_stk,
            so_stock ,
            so_qty ,
            short_qty ,
            po_qty ,
            vendor_stk,
            wa_mast.
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
FORM coll  TABLES   it_idnrk   it_mdps LIKE it_mdps.

  LOOP AT it_mdps INTO wa_mdps.
    wa_mdps1 = wa_mdps.

    IF ( wa_mdps-planr = '' ).

**      IF  WA_MDPS-DELKZ = 'WB' . " Unrestricted Stock.
**        AVAIL_STOCK  = AVAIL_STOCK + WA_MDPS-MNG01.
**      ENDIF.
**
**      IF  WA_MDPS-DELKZ = 'QM' .
**        AVAIL_QM  =  AVAIL_QM + WA_MDPS-MNG01.
**      ENDIF.
*
*      IF WA_MDPS-DELKZ = 'BE' .        "Purchase order
*        READ TABLE IT_PO INTO WA_PO WITH KEY PONO = WA_MDPS-DELNR.
*        IF SY-SUBRC <> 0.
*          WA_PO-MATNR = WA_IDNRK-IDNRK.
*          WA_PO-REQD_DT = WA_MDPS-DAT00.
*          WA_PO-PONO  = WA_MDPS-DELNR.
*          WA_PO-POQTY = WA_MDPS-MNG01.
*          APPEND WA_PO TO IT_PO.
*        ENDIF.
*      ENDIF.
*
**====Vendor Stk====13/05/2011
**      IF WA_MDPS-DELKZ = 'LK' .      " Vendor stock
**        AVAIL_VS  =  AVAIL_VS + WA_MDPS-MNG01.
**      ENDIF.
*
******PURCHASE REQUESITION NO**********
*      IF WA_MDPS-DELKZ = 'BA' .   "PURCHASE REQUISITION
*        READ TABLE IT_PR INTO WA_PR WITH KEY PRNO = WA_MDPS-DELNR.
*        IF SY-SUBRC <> 0.
*          WA_PR-MATNR = WA_IDNRK-IDNRK.
*          WA_PR-REQD_DT = WA_MDPS-DAT00.
*          WA_PR-PRNO  = WA_MDPS-DELNR.
*          WA_PR-PRQTY = WA_MDPS-MNG01.
*          APPEND WA_PR TO IT_PR.
*        ENDIF.
*      ENDIF.

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
            AND lgort <> 'RJ01' AND lgort <> 'SCR1'.


        READ TABLE it_material INTO wa_material WITH KEY comp_mat = wa_idnrk-idnrk
                                                            so_no = wa_idnrk-vbeln
                                                            posnr = wa_idnrk-posnr.
        lv_level = wa_material-mat_qty.
        lv_matnr = wa_material-head_mat.

        PERFORM bom_fm TABLES t_stb
                        USING   lv_level
                                lv_matnr
                                p_werks
                             .
        LOOP AT t_stb INTO wa_stb.
          IF wa_stb-idnrk = wa_idnrk-idnrk.
            so_qty = wa_stb-mnglg.
          ENDIF.
        ENDLOOP.

        "*****Action Date**********
*        SELECT SINGLE PLIFZ
*          INTO ACTION_DAYS
*          FROM MARC
*          WHERE MATNR = WA_IDNRK-IDNRK AND WERKS = P_WERKS.
        "*****Action Date**********

******Production order and reservation details.
*        IF NOT PROD_ORD IS INITIAL.
*          SELECT SINGLE AUFNR
*                 PSMNG
*                 WEMNG
*                 "MATNR
*            FROM AFPO
*            INTO CORRESPONDING FIELDS OF WA_AFPO
*            WHERE AUFNR = PROD_ORD.
**          AND ELIKZ <> 'X'
*
*          SELECT SINGLE MATNR
*                       BDMNG
*                       ENMNG
*                       AUFNR
*                  FROM RESB
*                  INTO CORRESPONDING FIELDS OF  WA_RESB
*                    WHERE AUFNR = PROD_ORD
*                    AND MATNR = WA_IDNRK-IDNRK
*                    AND XLOEK <> 'X'
*                    AND ENMNG > 0
*                    AND SHKZG = 'H'.
*
*          IF SY-SUBRC = 0.
*            WA_RESB-WIPQTY = WA_RESB-ENMNG - ( WA_AFPO-WEMNG * ( WA_RESB-BDMNG / WA_AFPO-PSMNG ) ).
*            IF WA_RESB-WIPQTY > 0.
*              WA_FINAL_NEW-WIP_STK = WA_RESB-WIPQTY.
*            ENDIF.
*
*          ENDIF.
*        ENDIF.

        rem_qty = so_qty - wa_final_new-wip_stk.

*_____________________________________________

* Start of Stock Netting ------------------------------------------------
*data: rem_qty type vbap-kwmeng.
        READ TABLE it_stock INTO wa_stock WITH KEY matnr = wa_idnrk-idnrk.

        IF sy-subrc <> 0.
          wa_stock-matnr = wa_idnrk-idnrk.
          wa_stock-rt_stock = avail_stock.
          wa_stock-qm_net_stock = avail_qm.
          wa_stock-block_stk = avail_block.
*          WA_STOCK-VEN_NET_STK = AVAIL_VS.
          APPEND wa_stock TO it_stock.
        ENDIF.

        READ TABLE it_stock INTO wa_stock WITH KEY matnr = wa_idnrk-idnrk.
*        IF FLAG <> 1.
*          WA_STOCK-MATNR = WA_IDNRK-IDNRK.
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
              rem_qty = rem_qty - blk_stk.
            ENDIF.
          ENDIF.
        ENDIF.

        MODIFY it_stock
        FROM wa_stock
        TRANSPORTING rt_stock
                     qm_net_stock
                     block_stk
        WHERE matnr = wa_idnrk-idnrk .
*

        lv_stock = so_stock + so_stock_qm.
        wa_final_new-canbqty  = lv_stock * wa_idnrk-ratio.

        IF lv_stkpos > wa_final_new-canbqty.
          lv_stkpos = wa_final_new-canbqty.
        ENDIF.

        CLEAR : wa_stock.
*        ENDIF.
* End of Stock Netting ----------------------------------------------------
*        IF SO_QTY > SO_STOCK.
        short_qty = rem_qty.
        CLEAR rem_qty.

*Start of Po & Pr Netting ----------------logic as on 27/06/2011--------------------------------
*        SORT IT_PO BY MATNR REQD_DT.
*        SORT IT_PR BY MATNR REQD_DT.
*        REM_QTY = SHORT_QTY.
*        LOOP AT IT_PO INTO WA_PO WHERE MATNR = WA_IDNRK-IDNRK." and rem_qty > 0.
*          IF REM_QTY > 0.
*            IF REM_QTY <= WA_PO-POQTY.
**         wa_final-po_qty = rem_qty.
**         wa_final-act_dt = wa_po-reqd_dt.
*              WA_PO-POQTY = WA_PO-POQTY - REM_QTY.
*              REM_QTY = 0.
*            ELSE.
*              REM_QTY = REM_QTY - WA_PO-POQTY.
*              WA_PO-POQTY = 0.
*            ENDIF.
*            WA_FINAL-PO_QTY = SHORT_QTY -  REM_QTY.
*            IF NOT WA_FINAL-ACT_DT IS INITIAL.
*              IF WA_FINAL-ACT_DT > WA_PO-REQD_DT.
*                WA_FINAL-ACT_DT = WA_PO-REQD_DT.
*              ENDIF.
*            ELSE.
*              WA_FINAL-ACT_DT = WA_PO-REQD_DT.
*            ENDIF.
*
*
*            MODIFY IT_PO
*              FROM WA_PO
*              TRANSPORTING POQTY
*              WHERE MATNR = WA_IDNRK-IDNRK AND PONO = WA_PO-PONO .
*          ENDIF.
*        ENDLOOP.
*
*        IF REM_QTY > 0.
*          LOOP AT IT_PR INTO WA_PR WHERE MATNR = WA_IDNRK-IDNRK." and rem_qty > 0.
*            IF REM_QTY > 0.
*              IF REM_QTY <= WA_PR-PRQTY.
*                WA_PR-PRQTY = WA_PR-PRQTY - REM_QTY.
*                REM_QTY = 0.
*              ELSE.
*                REM_QTY = REM_QTY - WA_PR-PRQTY.
*                WA_PR-PRQTY = 0.
*              ENDIF.
*              WA_FINAL-PR_QTY = SHORT_QTY - WA_FINAL-PO_QTY - REM_QTY.
*
*              IF NOT WA_FINAL-ACT_DT IS INITIAL.
*                IF WA_FINAL-ACT_DT > WA_PR-REQD_DT.
*                  WA_FINAL-ACT_DT = WA_PR-REQD_DT.
*                ENDIF.
*              ELSE.
*                WA_FINAL-ACT_DT = WA_PR-REQD_DT.
*              ENDIF.
*
*              MODIFY IT_PR
*                FROM WA_PR
*                TRANSPORTING PRQTY
*                WHERE MATNR = WA_IDNRK-IDNRK AND PRNO = WA_PR-PRNO .
*            ENDIF.
*          ENDLOOP.
*        ENDIF.
*        WA_FINAL-ACTION_DT = WA_FINAL-ACT_DT - ACTION_DAYS.
** End of PR & PO Netting ----------------------logic as on 27/06/2011----------------------------
*        IF WA_IDNRK-LEVEL = 0.
*          HEADER    = WA_IDNRK-IDNRK."====CHANGE================="
*          HEADER_DESC = WA_IDNRK-MAKTX.
*
*        ENDIF.
        READ TABLE it_material INTO wa_material
      WITH KEY so_no = wa_idnrk-vbeln
               posnr = wa_idnrk-posnr
               comp_mat = wa_idnrk-idnrk
               plant = p_werks.
        IF sy-subrc = 0.
          header = wa_material-head_mat.
*         read TABLE it_IDNRK INTO WA_IDNRK1 WITH KEY IDNRK = HEADER.
*         HEADER_DESC = WA_IDNRK1-MAKTX.
          SELECT SINGLE maktx FROM makt INTO header_desc
             WHERE matnr = header.
        ENDIF.
        "======Changes on 25/05/2011=========================================================="
        READ TABLE  it_mara   INTO  w_mara WITH KEY matnr =  wa_idnrk-idnrk.
        READ TABLE  it_marc   INTO  wa_marc WITH KEY matnr =  wa_idnrk-idnrk.
        READ TABLE  it_mbew   INTO  wa_mbew WITH KEY matnr =  wa_idnrk-idnrk.
        READ TABLE  it_vbak   INTO  w_vbak WITH KEY vbeln =  wa_idnrk-vbeln.
        IF sy-subrc = 0.
          READ TABLE  it_konv   INTO  wa_konv WITH KEY knumv = w_vbak-knumv
                                                       kposn = wa_idnrk-posnr.
        ENDIF.
        READ TABLE  it_kna1   INTO  wa_kna1 WITH KEY kunnr =  w_vbak-kunnr.
        "===Changes on 14/06/2011==========================================="
*        WA_FINAL_NEW-PR_QTY_VERPR = WA_FINAL-PR_QTY * WA_MBEW-VERPR.
**        wa_final_new-PR_qty_verpr = PR_qty_verpr.
*
*        WA_FINAL_NEW-PO_QTY_VERPR = WA_FINAL-PO_QTY * WA_MBEW-VERPR.
*        wa_final_new-PO_qty_verpr = PO_qty_verpr.
        "================================================================"

*        IF WA_IDNRK-LEVEL = 0.
*          WA_FINAL_NEW-HEADER    = WA_IDNRK-IDNRK."====CHANGE================="
*        ENDIF.

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
        wa_final_new-act_dt    = wa_final-act_dt.
        wa_final_new-customer  = wa_kna1-name1.
        wa_final_new-header    = header.
        wa_final_new-header_desc = header_desc.
        wa_final_new-plant     = wa_idnrk-plant.
        "================================================================"

        wa_final_new-vbeln   = wa_idnrk-vbeln. .
        wa_final_new-posnr   = wa_idnrk-posnr.  "WA_IDNRK-POSNR
        wa_final_new-matnr   = wa_idnrk-idnrk.  "WA_FINAL-MATNR
        wa_final_new-arktx   = wa_idnrk-maktx.  "WA_FINAL-ARKTX
        wa_final_new-uom     = wa_idnrk-uom.    "WA_FINAL-UOM
        wa_final_new-edatu   = wa_idnrk-edatu.  "WA_FINAL-VDATU
        wa_final_new-wmeng  = wa_idnrk-wmeng."WA_FINAL-KWMENG.
        wa_final_new-open_so = so_qty.
        wa_final_new-unres_stk  = so_stock .
        wa_final_new-qm_stk = so_stock_qm.
        wa_final_new-block_stk = blk_stk.
*        WA_FINAL_NEW-VENDOR_STK = VENDOR_STK.

        wa_final_new-short_qty = short_qty .
        wa_final_new-po_qty  = wa_final-po_qty.
*        WA_FINAL_NEW-PO_NO   = WA_FINAL-PO_NO."WA_FINAL-PO_NO.
        wa_final_new-pr_qty  = wa_final-pr_qty .
        wa_final_new-action_dt = wa_final-action_dt.
        wa_final_new-kbetr     = wa_konv-kbetr.
        wa_final_new-amount = wa_final_new-canbqty * wa_konv-kbetr.

        SHIFT wa_final_new-vbeln LEFT DELETING LEADING '0'.
        SHIFT wa_final_new-matnr LEFT DELETING LEADING '0'.
        SHIFT wa_final_new-header LEFT DELETING LEADING '0'..

* To display records with werks as P_werks as per selection screen only.
        IF lv_werks = wa_final_new-plant .
          APPEND wa_final_new TO it_final_new.
        ENDIF.

        wa_material-mat_qty = so_qty.

        MODIFY it_material
        FROM wa_material
        TRANSPORTING mat_qty
      WHERE head_mat = wa_idnrk-idnrk AND plant = p_werks
      AND so_no = wa_idnrk-vbeln
      AND posnr = wa_idnrk-posnr..

        CLEAR:
          so_stock ,
          so_qty ,
          short_qty ,
          po_qty ,
          so_stock_qm,
*          VENDOR_STK,
          avail_stock,
          avail_qm,
          rem_qty,
          blk_stk,
          wa_final_new,
*          wa_prpo,
          tot_pr,
          tot_po.
        .

        CLEAR wa_final.
      ENDAT.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " COL
*&---------------------------------------------------------------------*


FORM data_display .

**&---------------------------------------------------------------------*
**&  INCLUDE           ZPP_SO_SHORTAGES_COPY_ALV
**&---------------------------------------------------------------------*

** STORE REPORT NAME
  i_repid = sy-repid.
***************ADDED BY JYOTI ON 14.06.2024*****************
if  p_lgort = 'RM01'.
CONCATENATE 'Total Stock' 'KRM0' INTO DATA(gv_stock) SEPARATED BY SPACE.
else.
  CONCATENATE 'Total Stock' 'PL01' INTO gv_stock SEPARATED BY SPACE.
endif.
if  p_lgort = 'RM01'.
CONCATENATE 'ON Order Stock'  'KRM0' INTO DATA(gv_on_stock) SEPARATED BY SPACE.
ELSE.
  CONCATENATE 'ON Order Stock'  'PL01' INTO gv_on_stock SEPARATED BY SPACE.
ENDIF.
if  p_lgort = 'RM01'.
CONCATENATE 'Reserved Qty' 'KRM0' INTO DATA(gv_res_qty) SEPARATED BY SPACE.
else.
  CONCATENATE 'Reserved Qty' 'PL01' INTO gv_res_qty SEPARATED BY SPACE.
endif.
*PERFORM BUILD_FIELDCAT USING 'WERKS'       ' ' '1'  'Plant'.
*PERFORM BUILD_FIELDCAT USING 'MATNR'       ' ' '2'  'Header Material'.
*PERFORM BUILD_FIELDCAT USING 'MAKTX'       ' ' '3'  'Header Description'(011).

  PERFORM build_fieldcat USING 'IDNRK'       ' ' '1'  'Components'(010).
  PERFORM build_fieldcat USING 'OJTXP'       ' ' '2'  'Description'(011).
  PERFORM build_fieldcat USING 'MNGLG'       ' ' '3'  'Required Quantity'.
  PERFORM build_fieldcat USING 'TOT_REQ'       ' ' '4'  'MRP Total Requirement'.
  PERFORM build_fieldcat USING 'TOT_STOCK'       ' ' '5'  'Total Stock'.
  PERFORM build_fieldcat USING 'SHORTAGE'       ' ' '6'  'Shortages'.
  PERFORM build_fieldcat USING 'RATE'       ' ' '7'  'Rate'.
  PERFORM build_fieldcat USING 'SHORTAGE_VALUE'       ' ' '8'  'Shortages Value'.
  PERFORM build_fieldcat USING 'COMP_CANBE'       ' ' '9' 'Can Be Qty'(037).
  PERFORM build_fieldcat USING 'EKGRP'       ' ' '10' 'Purchasing Group'.
  PERFORM build_fieldcat USING 'LGPBE'       ' ' '11' 'Storage Bin'.     " Added By Milind 06.01.2021
  PERFORM build_fieldcat USING 'INSME'       ' ' '12' 'Quality Stock'.     " Added By diksha 05.01.2023
  PERFORM build_fieldcat USING 'RESERVE_QTY'       ' ' '13' 'Reserved Qty'.     " Added By diksha 05.01.2023
  PERFORM build_fieldcat USING 'ON_ORDER_STOCK'       ' ' '14' 'ON Order Stock'.     " Added By diksha 05.01.2023
  PERFORM build_fieldcat USING 'LABST'       ' ' '15' 'SC01 Stock Qty'.     " Added By diksha 11.01.2023
  PERFORM build_fieldcat USING 'UNRESTRICT_STOCK_NEW'       ' ' '16' gv_stock ."'Total Stock Other SLOC'.     " Added By diksha 11.01.2023
   PERFORM build_fieldcat USING 'ON_ORDER_STOCK_NEW'       ' ' '17' gv_on_stock."'ON Order Stock Other SLOC'."added by jyoti on 13.06.2024
    PERFORM build_fieldcat USING 'RESERVE_QTY_NEW'       ' ' '18' gv_res_qty."'Reserved Qty'."added by jyoti on 13.06.2024
*  PERFORM build_fieldcat USING 'LGORT'       ' ' '16' 'Storage Location'. "added by jyoti on 13.06.2024
*  PERFORM build_fieldcat USING 'LMENGEZUB'       ' ' '12'  'Quality Stock'.
*PERFORM BUILD_FIELDCAT USING 'ACTUL_CANBE'       ' ' '13' 'Maximum Possible Can Be Qty'(037).

*  PERFORM BUILD_FIELDCAT USING 'VBELN'       'X' '1'  'Sales Order'(003).
*  PERFORM BUILD_FIELDCAT USING 'POSNR'       ' ' '2'  'Sales Item'(007).
*  PERFORM BUILD_FIELDCAT USING 'PLANT'       ' ' '3'  'Plant'(008).
*  PERFORM BUILD_FIELDCAT USING 'HEADER'      ' ' '4'  'Header Material'(009).
*  PERFORM BUILD_FIELDCAT USING 'HEADER_DESC' ' ' '31'  'Header Description'(036).
*  PERFORM BUILD_FIELDCAT USING 'MATNR'       ' ' '5'  'Components'(010).
*  PERFORM BUILD_FIELDCAT USING 'ARKTX'       ' ' '6'  'Description'(011).
*  PERFORM BUILD_FIELDCAT USING 'UOM'         ' ' '6'  'UOM'.
*  PERFORM BUILD_FIELDCAT USING 'CUSTOMER'    ' ' '7'  'Customer'(012).
*  PERFORM BUILD_FIELDCAT USING 'EDATU'       ' ' '8'  'Cust. Del. Date'(013).
*  PERFORM BUILD_FIELDCAT USING 'WMENG'      ' ' '9'  'Qty in Sales unit'(014).
*  PERFORM BUILD_FIELDCAT USING 'OPEN_SO'     ' ' '10'  'Open SO Qty'(015).
*  PERFORM BUILD_FIELDCAT USING 'UNRES_STK'   ' ' '11'  'Stock Unrestricted'(016).
*  PERFORM BUILD_FIELDCAT USING 'QM_STK' ' '  '12' 'Stock Quality'(017).
*  PERFORM BUILD_FIELDCAT USING 'VENDOR_STK'  ' ' '13' 'Vendor Stock'(018).
*  PERFORM BUILD_FIELDCAT USING 'BLOCK_STK'  ' ' '13' 'Block Stock'(018).
*  PERFORM BUILD_FIELDCAT USING 'WIP_STK'     ' ' '14' 'WIP Stock'(019).
*  PERFORM BUILD_FIELDCAT USING 'SHORT_QTY'   ' ' '15' 'Shortage Qty.'(020).
*  PERFORM BUILD_FIELDCAT USING 'PR_NO'       ' ' '15' 'Purch Req no'.
*  PERFORM BUILD_FIELDCAT USING 'PR_QTY'      ' ' '16' 'PR Qty'(021).
**  PERFORM BUILD_FIELDCAT USING 'PO_NO'       ' ' '17' 'PO Number'.
*  PERFORM BUILD_FIELDCAT USING 'PO_QTY'      ' ' '17' 'PO Qty'(022).
*  PERFORM BUILD_FIELDCAT USING 'ACTION_DT'   ' ' '18' 'Action Date'(023).
**===========Changes on 13/05/2011
*  PERFORM BUILD_FIELDCAT USING 'ACT_DT'      ' ' '19' 'Required Date'(024).
*  PERFORM BUILD_FIELDCAT USING 'DISPO'       ' ' '20' 'MRP Controller'(025).
*  PERFORM BUILD_FIELDCAT USING 'BESKZ'       ' ' '21' 'Procurement Type'(026).
*  PERFORM BUILD_FIELDCAT USING 'BRAND'       ' ' '22' 'Brand'(027).
*  PERFORM BUILD_FIELDCAT USING 'ZSERIES'     ' ' '23' 'Series'(028).
*  PERFORM BUILD_FIELDCAT USING 'ZSIZE'       ' ' '24' 'Size'(029).
*  PERFORM BUILD_FIELDCAT USING 'MOC'         ' ' '25' 'MOC'(030).
*  PERFORM BUILD_FIELDCAT USING 'TYPE'        ' ' '26' 'Type'(031).
*  PERFORM BUILD_FIELDCAT USING 'MTART'        ' ' '28' 'Material Type'.
*  PERFORM BUILD_FIELDCAT USING 'BISMT'        ' ' '27' 'Old Material Number'(032).
*  PERFORM BUILD_FIELDCAT USING 'VERPR'       ' ' '28' 'Moving Avg.Price'(033).
*  PERFORM BUILD_FIELDCAT USING 'PR_QTY_VERPR' ' ' '29' 'PR_Valuation'(034).
*  PERFORM BUILD_FIELDCAT USING 'PO_QTY_VERPR' ' ' '30' 'PO_Valuation'(035).
*  PERFORM BUILD_FIELDCAT USING 'CANBQTY'       ' ' '31' 'Can Be Qty'(037).
*  PERFORM BUILD_FIELDCAT USING 'KBETR'       ' ' '32' 'SO Rate'(038).
*  PERFORM BUILD_FIELDCAT USING 'AMOUNT'       ' ' '33' 'Can be Value'(039).
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
      it_sort            = i_sort
    TABLES
*     T_OUTTAB           = IT_FINAL_NEW
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
  " ======cODE FOR COLORING THE HEADER MATERIAL ROW ONLY=================*
*  IF WA_FCAT-FIELDNAME = 'HEADER'
*    AND WA_FCAT-FIELDNAME <> ' '.
*    WA_LAYOUT-INFO_FieldNAME = 'HEADER'.
*  ENDIF.
  " ======cODE FOR COLORING THE HEADER MATERIAL ROW ONLY=================*
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&AT SELECTING INPUT OPTION
*&---------------------------------------------------------------------*

*FORM DATA_INPUT .
*
*  SELECT   SO_NO
*           SO_ITEM
*           QUANTITY
*           DELDT
*           FROM ZSOPLAN
*           INTO CORRESPONDING FIELDS OF TABLE IT_ZSOPLAN
*           WHERE ZMONTH IN P_MONTH
*           AND    ZYEAR IN P_YEAR.
*  IF SY-SUBRC EQ 0.
*    SORT IT_ZSOPLAN BY DELDT.  "so_no
*  ENDIF.
*
*  IF NOT IT_ZSOPLAN[] IS INITIAL.
*
*    SELECT    VBELN
*              POSNR
*              MATNR
*              ARKTX
*              WERKS
*              MEINS
*              KWMENG
*              FROM  VBAP
*              INTO CORRESPONDING FIELDS OF TABLE I_VBAP
*              FOR ALL ENTRIES IN IT_ZSOPLAN
*              WHERE VBELN =  IT_ZSOPLAN-SO_NO
*              AND    POSNR = IT_ZSOPLAN-SO_ITEM
*              AND WERKS = P_WERKS1.
*    "AND    KWMENG = IT_ZSOPLAN-QUANTITY.
**    IF SY-SUBRC EQ 0.
**      SORT I_VBAP BY VBELN POSNR.
**    ENDIF.
*
*  ENDIF.
*
*  IF NOT I_VBAP[] IS INITIAL.
*
*    SELECT VBELN
*           VDATU
*         FROM VBAK
*         INTO CORRESPONDING FIELDS OF TABLE I_VBAK
*         FOR ALL ENTRIES IN I_VBAP
*         WHERE VBELN =  I_VBAP-VBELN .
*    IF SY-SUBRC EQ 0.
*      SORT I_VBAK BY VBELN.
*    ENDIF.
*
*    SELECT VBELN
*           POSNR
*           LFSTA
*         FROM VBUP
*         INTO CORRESPONDING FIELDS OF TABLE IT_VBUP
*  FOR ALL ENTRIES IN I_VBAP
*              WHERE VBELN     =  I_VBAP-VBELN
*              AND   POSNR     =  I_VBAP-POSNR.
*    IF SY-SUBRC EQ 0.
*      SORT IT_VBUP BY VBELN POSNR.
*    ENDIF.
*
*  ENDIF.
*
*  LOOP AT I_VBAP INTO WA_VBAP.
*
*    WA_DATA-VBELN = WA_VBAP-VBELN.
*    WA_DATA-POSNR = WA_VBAP-POSNR.
*    WA_DATA-MATNR = WA_VBAP-MATNR.
*    WA_DATA-ARKTX = WA_VBAP-ARKTX.
*    WA_DATA-WERKS = WA_VBAP-WERKS.
*    WA_DATA-MEINS = WA_VBAP-MEINS.
*    WA_DATA-WMENG = WA_VBAP-KWMENG.
*
*
*    READ TABLE IT_ZSOPLAN INTO WA_ZSOPLAN WITH KEY SO_NO = WA_VBAP-VBELN SO_ITEM = WA_VBAP-POSNR
*            BINARY SEARCH.
*    IF SY-SUBRC = 0.
*      WA_DATA-EDATU = WA_ZSOPLAN-DELDT.
*    ENDIF.
*
*
*
*    CLEAR WA_VBAK.
*
*    READ TABLE IT_VBUP INTO WA_VBUP WITH KEY VBELN = WA_VBAP-VBELN
*               POSNR = WA_VBAP-POSNR
*               BINARY SEARCH.
*    IF SY-SUBRC = 0.
*      WA_DATA-LFSTA = WA_VBUP-LFSTA.
*    ENDIF.
*    CLEAR WA_VBUP.
*
*    APPEND WA_DATA TO IT_DATA.
*    P_WERKS = WA_DATA-WERKS.
*    CLEAR : WA_VBAP, WA_DATA.
*  ENDLOOP.
*
*
*  PERFORM BOM_EXPLODE.
*  PERFORM STOCK_REQ.
*  PERFORM DATA_DISPLAY.
*
*
*ENDFORM.                    " DATA_INPUT
*&---------------------------------------------------------------------*
*&      Form  SORT_TABLE_BUILD
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_DATA_MATNR  text
*      -->P_P_WERKS  text
*      -->P_WA_STB_TTIDX  text
*----------------------------------------------------------------------*
FORM fetch_data  USING  p_wa_data_matnr
                        p_p_werks
                        p_wa_stb_ttidx.
  wa_idnrk-vbeln  = wa_data-vbeln .
  wa_idnrk-posnr  = wa_data-posnr .
  wa_idnrk-edatu  = wa_data-edatu .
  wa_idnrk-wmeng = wa_data-wmeng .
  wa_idnrk-etenr = wa_data-etenr .

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
          sbdkz

      FROM marc
  INTO wa_idnrk-sbdkz

  WHERE matnr = p_wa_data_matnr
    AND werks = p_p_werks.

  wa_idnrk-level = p_wa_stb_ttidx.
  wa_idnrk-plant =  p_p_werks.

  APPEND wa_idnrk TO it_idnrk.


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
*  CLEAR LF_LINE.
*  LF_LINE-TYP  = C_H.
*  LF_LINE-INFO = 'Can Be Report'(040).
*  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.
*--------------------------------------------------------------------*


  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-info = lv_werks_txt.
  APPEND lf_line TO i_list_top_of_page.
******************added by jyoti on 13.06.2024*******************
  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-info = lv_lgort_txt.
  APPEND lf_line TO i_list_top_of_page.

****************************************************************


  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-info = lv_matnr_txt.
  APPEND lf_line TO i_list_top_of_page.

  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-info = lv_maktx_txt.
  APPEND lf_line TO i_list_top_of_page.

  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-info = lv_req_txt.
  APPEND lf_line TO i_list_top_of_page.

*max can be qty
  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-info = lv_canbe_txt .
  APPEND lf_line TO i_list_top_of_page.


*--Head info: Type S
*  CLEAR LF_LINE.
*  LF_LINE-TYP  = C_S.
*  LF_LINE-KEY  = 'DATE'.
*  LF_LINE-INFO = SY-DATUM.
*  WRITE SY-DATUM TO LF_LINE-INFO USING EDIT MASK '__.__.____'.
*  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.

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
