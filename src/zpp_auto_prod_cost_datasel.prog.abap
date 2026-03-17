
START-OF-SELECTION.

*FIND COST AND LIST PRICE FOR HEADER MATERIAL
  REFRESH: it_konh, it_konp.
  CLEAR:   it_konh, it_konp.

*  FOR ZESC
  SELECT * FROM konh INTO TABLE it_konh WHERE kotabnr = '508'
                                          AND kschl  = 'ZESC'
                                          AND vakey = p_matnr
                                          AND datab <= p_erdat
                                          AND datbi >= p_erdat .

  SORT  it_konh DESCENDING BY knumh .
  CLEAR wa_konh.
  READ TABLE it_konh INTO wa_konh INDEX 1.

  CLEAR wa_konp.
  SELECT SINGLE * FROM konp INTO wa_konp WHERE knumh = wa_konh-knumh
                                          AND kschl  = 'ZESC'.

  IF wa_konp IS NOT INITIAL.
    APPEND wa_konp TO it_zesc.
  ENDIF.

  REFRESH: it_konh, it_konp.
  CLEAR:   it_konh, it_konp.

*  FOR ZLIP
  SELECT * FROM konh INTO TABLE it_konh WHERE kotabnr = '508'
                                          AND kschl  = 'ZLIP'
                                          AND vakey = p_matnr
                                          AND datab <= p_erdat
                                          AND datbi >= p_erdat .

  SORT  it_konh DESCENDING BY knumh.
  CLEAR wa_konh.
  READ TABLE it_konh INTO wa_konh INDEX 1.

  CLEAR wa_konp.
  SELECT SINGLE * FROM konp INTO wa_konp WHERE knumh = wa_konh-knumh
                                          AND kschl  = 'ZLIP'.
  IF wa_konp IS NOT INITIAL.
    APPEND wa_konp TO it_zlip.
  ENDIF.

  REFRESH: it_konh, it_konp.
  CLEAR:   it_konh, it_konp, head.

  IF it_zesc[] IS NOT INITIAL OR it_zlip[] IS NOT INITIAL.
*STOP FURTHER PROCESSING & display output IF ZESC AND ZLIP ARE FOUND for entered fert code

    CLEAR: wa_zesc, wa_zlip.
    READ TABLE it_zesc INTO wa_zesc INDEX 1.
    READ TABLE it_zlip INTO wa_zlip INDEX 1.
    head = 'X'. " to print just the header material

  ELSEIF it_zesc[] IS INITIAL AND it_zlip[] IS INITIAL.

*find componentts for header material
    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        capid                 = 'PP01'
        datuv                 = sy-datum
        emeng                 = 0         "Req Quantity
        mehrs                 = 'X'
        mtnrv                 = p_matnr
        stpst                 = 0        " level
        svwvo                 = 'X'
        werks                 = p_werks
        vrsvo                 = 'X'
      TABLES
        stb                   = it_stb
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

    CLEAR: wa_stb, wa_output, wa_ekko, wa_ekpo.
    REFRESH : it_output, it_ekko, it_ekko.
*use eina and eipa instead of ekko and ekpo
    SELECT * FROM ekko INTO TABLE it_ekko WHERE bstyp = 'F'
                                          AND   aedat IN s_aedat.


    LOOP AT it_stb INTO wa_stb WHERE stufe = 1.

      wa_output-idnrk = wa_stb-idnrk.
      wa_output-ojtxp = wa_stb-ojtxp.
      wa_output-mnglg = wa_stb-mnglg.

      CLEAR wa_mbew.
      SELECT SINGLE * FROM mbew INTO wa_mbew WHERE matnr = wa_stb-idnrk
                                               AND bwkey = p_werks.

      IF wa_mbew-vprsv = 'S'.
        wa_output-price = wa_mbew-stprs.
      ELSEIF wa_mbew-vprsv = 'V'.
        wa_output-price = wa_mbew-stprs.
      ENDIF.

*FIND COST AND LIST PRICE FOR component MATERIAL
      REFRESH: it_konh, it_konp.
      CLEAR:   it_konh, it_konp.

*  FOR ZESC
      SELECT * FROM konh INTO TABLE it_konh WHERE kotabnr = '508'
                                              AND kschl  = 'ZESC'
                                              AND vakey = wa_stb-idnrk
                                              AND datab LE p_erdat
                                              AND datbi GE p_erdat .

      SORT  it_konh DESCENDING BY knumh.
      CLEAR wa_konh.
      READ TABLE it_konh INTO wa_konh INDEX 1.

      CLEAR wa_konp.
      SELECT SINGLE * FROM konp INTO wa_konp WHERE knumh = wa_konh-knumh.

*move zesc to output .
      wa_output-zesc = wa_konp-kbetr.
      wa_output-datab = wa_konh-datab.
      wa_output-datbi = wa_konh-datbi.

      REFRESH: it_konh, it_konp.
      CLEAR:   it_konh, it_konp.

*  FOR ZLIP
      SELECT * FROM konh INTO TABLE it_konh WHERE kotabnr = '508'
                                              AND kschl  = 'ZLIP'
                                              AND vakey = wa_stb-idnrk
                                              AND datab LE p_erdat
                                              AND datbi GE p_erdat .

      SORT  it_konh DESCENDING BY knumh.
      CLEAR wa_konh.
      READ TABLE it_konh INTO wa_konh INDEX 1.

      CLEAR wa_konp.
      SELECT SINGLE * FROM konp INTO wa_konp WHERE knumh = wa_konh-knumh
                                              AND kschl  = 'ZLIP'.

*move zlip to output .
      wa_output-zlip = wa_konp-kbetr.

      REFRESH: it_konh, it_konp.
      CLEAR:   it_konh, it_konp.

*LATES PO FOR A COMPONENT
      SELECT * FROM ekpo INTO TABLE it_ekpo FOR ALL ENTRIES IN it_ekko
                                                WHERE ebeln = it_ekko-ebeln
                                                AND   matnr = wa_stb-idnrk.

      SORT  it_ekpo DESCENDING BY ebeln.
      CLEAR: wa_ekko, wa_ekpo.
      READ TABLE it_ekpo INTO wa_ekpo INDEX 1.
      SELECT SINGLE * FROM ekko INTO wa_ekko WHERE ebeln = wa_ekpo-ebeln.

      wa_output-ebeln = wa_ekpo-ebeln.
      wa_output-waers = wa_ekko-waers.
      wa_output-netpr = wa_ekpo-netpr.
      wa_output-zesc_qty = wa_output-mnglg * wa_output-zesc.
      wa_output-zlip_qty = wa_output-mnglg * wa_output-zlip.

*check if material is fert and make it NONEDITABLE
      CLEAR wa_mara.

      SELECT SINGLE * FROM mara INTO wa_mara WHERE matnr = wa_stb-idnrk.
      IF wa_mara-mtart = 'FERT'.
*        ls_stylerow-fieldname = 'ZESC' .
*        ls_stylerow-style = cl_gui_alv_grid=>mc_style_disabled.
*        INSERT ls_stylerow INTO  TABLE wa_output-field_style.
*
*        ls_stylerow-fieldname = 'DATAB' .
*        ls_stylerow-style = cl_gui_alv_grid=>mc_style_disabled.
*        INSERT ls_stylerow INTO  TABLE wa_output-field_style.
*
*        ls_stylerow-fieldname = 'DATBI' .
*        ls_stylerow-style = cl_gui_alv_grid=>mc_style_disabled.
*        INSERT ls_stylerow INTO  TABLE wa_output-field_style.

*valid to

      ELSEIF wa_mara-mtart <> 'FERT'.
*DISPLAY COST AND LIST PRICE FOR THIS NON-FERT COMPONENT FROM ZAUTO_COST

        CLEAR: wa_zauto_cost1, wa_output-zesc,
               wa_output-zlip, wa_output-datbi.


*  FOR ZLIP
        SELECT SINGLE * FROM zautocost1 INTO wa_zauto_cost1 WHERE
                                                matnr = wa_stb-idnrk
                                                AND datab <= p_erdat
                                                AND datbi >= p_erdat .

        IF sy-subrc = 0.
          wa_output-zesc = wa_zauto_cost1-zesc.
*        WA_OUTPUT-ZLIP = WA_OUTPUT-KBETR * WA_OUTPUT-ZESC.
*          WA_OUTPUT-ZLIP = WA_ZAUTO_COST1-ZLIP.
          wa_output-datab = wa_zauto_cost1-datab.
          wa_output-datbi = wa_zauto_cost1-datbi.
        ENDIF.
      ENDIF.

*get the factor from konp
      CLEAR: wa_output-kbetr, wa_konh, wa_konp .
      SELECT SINGLE * FROM konh INTO wa_konh WHERE
                                     kotabnr = '914'
                                 AND kschl = 'ZTB1'
                                 AND vakey = wa_stb-idnrk(2)
                                 AND datab <= p_erdat
                                 AND datbi >= p_erdat.

      SELECT SINGLE * FROM konp INTO wa_konp WHERE
                             knumh = wa_konh-knumh.

      wa_output-kbetr     = wa_konp-kbetr.  "factor
      IF wa_mara-mtart <> 'FERT'.
        wa_output-zlip      = wa_output-zesc * wa_output-kbetr.  "zlip
      ENDIF.
      wa_output-zesc_qty  = wa_output-zesc * wa_output-mnglg.  "Est Amount
      wa_output-zlip_qty  = wa_output-zlip * wa_output-mnglg.  "Lst Amount

***
*      WA_OUTPUT-ZLIP = WA_OUTPUT-KBETR * WA_OUTPUT-ZESC.
***
      APPEND wa_output TO it_output.

    ENDLOOP.
*  PERFORM build_layout.
**    PERFORM display_alv_report.
*  CALL SCREEN 9002.

  ENDIF.

*build layout
*    PERFORM zf_build_field_catalog.
*  PERFORM build_layout.
*    PERFORM display_alv_report.
  IF head <> 'X'.
    CALL SCREEN 9002.
  ELSEIF head = 'X'.
    CLEAR wa_makt.
    SELECT SINGLE * FROM makt INTO wa_makt WHERE matnr = p_matnr
                                             AND spras = 'EN'.
    WRITE:
           / 'Plant       :',   p_werks ,
           / 'Material    :',   p_matnr,
           / 'Description :',   wa_makt-maktx,
           / 'Date        :',   p_erdat,
           / 'Cost Price  :',   wa_zesc-kbetr,
           / 'List Price  :',   wa_zlip-kbetr.

  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       Build layout for ALV grid report
*----------------------------------------------------------------------*
FORM build_layout.
* Set layout field for field attributes(i.e. input/output)
  gd_layout-zebra             = 'X'.
  gd_layout-stylefname = 'FIELD_STYLE'.
  gd_layout-no_toolbar        = 'X'.
ENDFORM.                    " BUILD_LAYOUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*

MODULE status_9002 OUTPUT.
  SET PF-STATUS 'ZF_MENU'.
  SET TITLEBAR 'Z_AUTO'.

  IF gw_container IS INITIAL.
    PERFORM zf_create_alv.
  ENDIF.

ENDMODULE.                 " STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  ZF_CREATE_ALV
*&---------------------------------------------------------------------*
FORM zf_create_alv .
  DATA : lw_layout TYPE lvc_s_layo.

*&--Create object for the container
  CREATE OBJECT gw_container
    EXPORTING
      container_name = 'CUSTM_CNTNR'.

*&--Create object for the grid
  CREATE OBJECT gr_tab
    EXPORTING
      i_parent = gw_container.

*&--Build Field Catalog
  PERFORM zf_build_field_catalog.
*&--Setting Layout parameters
  lw_layout-zebra      = 'X'.
*  lw_layout-CWIDTH_OPT = 'X'.
  lw_layout-col_opt    = 'X'.
*  lw_layout-col_opt    = 'X'.
  lw_layout-stylefname = 'FIELD_STYLE'.
*  lw_layout-NO_TOOLBAR    = 'X'.

*  CREATE OBJECT gr_event_rec.
*  SET HANDLER gr_event_rec->handle_toolbar FOR gr_tab.

  CALL METHOD gr_tab->set_table_for_first_display
    EXPORTING
      is_layout       = lw_layout
    CHANGING
      it_fieldcatalog = gt_fcat
      it_outtab       = it_output.

  CALL METHOD gr_tab->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter
    EXCEPTIONS
      error      = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

*  SET HANDLER gr_event_rec->on_user_command FOR gr_tab.
*  SET HANDLER gr_event_rec->after_user_command  FOR gr_tab.
*  SET HANDLER gr_event_rec->handle_data_changed FOR gr_tab.
ENDFORM.                    " ZF_CREATE_ALV
*&---------------------------------------------------------------------*
*&      Form  ZF_BUILD_FIELD_CATALOG
*&---------------------------------------------------------------------*

FORM zf_build_field_catalog .
  DATA : lw_fcat TYPE lvc_s_fcat,
         lv_col  TYPE i VALUE 1.

  CLEAR lw_fcat.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'IDNRK'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-key       = 'X'.
  lw_fcat-scrtext_l = 'BOM ITEM'.
  lw_fcat-outputlen = 18.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'OJTXP'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-scrtext_l = 'Description'.
  lw_fcat-key       = 'X'.
  lw_fcat-outputlen = 13.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'MNGLG'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-scrtext_l = 'Req Qty'.
  lw_fcat-key       = 'X'.
  lw_fcat-outputlen = 10.
  lw_fcat-datatype     = 'QUAN'.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'EBELN'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-scrtext_l = 'PO'.
  lw_fcat-key       = 'X'.
  lw_fcat-outputlen = 10.
*  lw_fcat-datatype     = 'QUAN'.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'WAERS'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-scrtext_l = 'PO'.
  lw_fcat-key       = 'Curr.'.
  lw_fcat-outputlen = 3.
*  lw_fcat-datatype     = 'QUAN'.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'NETPR'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-scrtext_l = 'Latest PO Price'.
  lw_fcat-key       = 'X'.
  lw_fcat-outputlen = 10.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'PRICE'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-scrtext_l = 'Price'.
  lw_fcat-key       = 'X'.
  lw_fcat-outputlen = 10.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'ZESC'.
*  lw_fcat-edit      = 'X'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-ref_field = 'KBETR'.
  lw_fcat-ref_table = 'RV13A'.
  lw_fcat-currency  = 'X'.
  lw_fcat-scrtext_l = 'Est. Price'.
  lw_fcat-key       = 'X'.
  lw_fcat-outputlen = 10.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'KBETR'.
*  lw_fcat-edit      = 'X'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
*  lw_fcat-scrtext_l = 'Factor'.
  lw_fcat-coltext = 'Factor'.
  lw_fcat-ref_field = 'KBETR'.
  lw_fcat-ref_table = 'RV13A'.
*  lw_fcat-key       = 'X'.
  lw_fcat-outputlen = 10.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'ZLIP'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-ref_field = 'KBETR'.
  lw_fcat-ref_table = 'RV13A'.
  lw_fcat-scrtext_l = 'List Price'.
  lw_fcat-key       = 'X'.
  lw_fcat-outputlen = 10.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'ZESC_QTY'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-ref_field = 'KBETR'.
  lw_fcat-ref_table = 'RV13A'.
*  lw_fcat-scrtext_l = 'Estimated Amount'.
  lw_fcat-coltext = 'Est. Amount'.
  lw_fcat-key       = 'X'.
  lw_fcat-do_sum       = 'X'.
  lw_fcat-outputlen = 10.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'ZLIP_QTY'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
  lw_fcat-ref_field = 'KBETR'.
  lw_fcat-ref_table = 'RV13A'.
  lw_fcat-scrtext_l = 'Lst. Amt'.
  lw_fcat-key       = 'X'.
  lw_fcat-do_sum       = 'X'.
  lw_fcat-outputlen = 10.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'DATAB'.
*  lw_fcat-edit      = 'X'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
*  lw_fcat-scrtext_l = 'Factor'.
  lw_fcat-f4availabl = 'X'.
  lw_fcat-coltext = 'Valid FROM.'.
  lw_fcat-ref_field = 'DATAB'.
  lw_fcat-ref_table = 'KONH'.
*  lw_fcat-key       = 'X'.
  lw_fcat-outputlen = 10.
  APPEND lw_fcat TO gt_fcat.

  CLEAR lw_fcat.
  lv_col = lv_col + 1.
  lw_fcat-col_pos   = lv_col.
  lw_fcat-fieldname = 'DATBI'.
*  lw_fcat-edit      = 'X'.
  lw_fcat-tabname   = 'IT_OUTPUT'.
*  lw_fcat-scrtext_l = 'Factor'.
  lw_fcat-f4availabl = 'X'.
  lw_fcat-coltext = 'Valid to.'.
  lw_fcat-ref_field = 'DATBI'.
  lw_fcat-ref_table = 'KONH'.
*  lw_fcat-key       = 'X'.
  lw_fcat-outputlen = 10.
  APPEND lw_fcat TO gt_fcat.



ENDFORM.                    " ZF_BUILD_FIELD_CATALOG
*&---------------------------------------------------------------------*
*&      Form  ZF_HANDLE_DATA_CHANGED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ER_DATA_CHANGED  text
*----------------------------------------------------------------------*

FORM zf_handle_data_changed     USING    p_er_data_changed
                          TYPE REF TO cl_alv_changed_data_protocol.

  DATA lv_mod TYPE lvc_s_modi.
  DATA: ls_roid   TYPE  lvc_s_roid,
        l_col_id  TYPE  lvc_s_col,
        l_row_id  TYPE  lvc_s_roid,
        lv_col_id TYPE i.

  DATA: oref TYPE REF TO cx_root,
        text TYPE string.
  DATA: w_num TYPE i.           "new

  DATA: wa_row TYPE lvc_t_modi.

  FIELD-SYMBOLS : <l_mod>   TYPE lvc_s_modi,
                  <l_table> TYPE t_output.
*                  <l_row> TYPE REF TO DATA.

  TRY.

      LOOP AT p_er_data_changed->mt_mod_cells ASSIGNING <l_mod>.

        READ TABLE it_output ASSIGNING <l_table> INDEX <l_mod>-row_id.
*    IF <l_mod>-fieldname = 'FACTOR'.
*      <l_table>-factor = <l_mod>-value.
        IF <l_mod>-fieldname = 'ZESC'.
          <l_table>-zesc = <l_mod>-value.
        ENDIF.

*from date should be greater than to date

        IF <l_mod>-fieldname = 'DATAB'.
          <l_table>-zesc = <l_mod>-value.
**    conversion exit for <L_TABLE>-DATBI and compare with datab

*      MESSAGE 'From Date should be Greater than to date' TYPE 'E'.

        ENDIF.

*At enter in Factor calculate List Price, list/estimated amount
*    IF <l_mod>-fieldname = 'FACTOR' OR <l_mod>-fieldname = 'ZESC'.
*      IF <l_mod>-value IS NOT INITIAL .
*        IF <l_table>-zesc IS NOT INITIAL .

        <l_table>-zlip = <l_table>-kbetr * <l_table>-zesc. " LST PRICE
        <l_table>-zesc_qty = <l_table>-zesc * <l_table>-mnglg. "Est Amount
        <l_table>-zlip_qty = <l_table>-zlip * <l_table>-mnglg. "List Amount
*        ENDIF.
*      ENDIF.
*    ENDIF.

        CLEAR lv_col_id.
        IF <l_mod>-fieldname = 'ZESC'.
          l_col_id-fieldname = 'ZESC'.
        ELSEIF <l_mod>-fieldname = 'DATAB'.
          l_col_id-fieldname = 'DATAB'.
        ELSEIF <l_mod>-fieldname = 'DATBI'.
          l_col_id-fieldname = 'DATBI'.
        ENDIF.

        l_row_id-row_id = <l_mod>-row_id.

*************************
        CLEAR wa_zauto_cost.

*CHECK IF THE RECORD EXIST FOR SAME start date
        SELECT SINGLE * FROM zautocost1 INTO wa_zauto_cost WHERE
                                           matnr = <l_table>-idnrk
                                           AND datab = <l_table>-datab.

        IF sy-subrc = 0.
          MESSAGE 'Date Range for this material is overlapping with already existing record' TYPE 'E'.
          CLEAR wa_zauto_cost.
        ENDIF.

*CHECK IF THE RECORD EXIST FOR SAME start date entered less than the record in table
        SELECT SINGLE * FROM zautocost1 INTO wa_zauto_cost WHERE
                                           matnr = <l_table>-idnrk
                                           AND datab = <l_table>-datab.

        IF sy-subrc = 0.
          MESSAGE 'Date Range for this material is overlapping with already existing record' TYPE 'E'.
          CLEAR wa_zauto_cost.
        ENDIF.

*CHECK IF THE RECORD EXIST FOR SAME start date entered less than the record in table
*select latest record into internal table >> to be done yet
        CLEAR wa_zauto_cost.
        SELECT SINGLE * FROM zautocost1 INTO wa_zauto_cost WHERE
                                               matnr = <l_table>-idnrk .
        IF <l_table>-datab < wa_zauto_cost-datab.
          MESSAGE 'Valid from date is lower than previous record' TYPE 'E'.
          CLEAR wa_zauto_cost.
        ENDIF.


*************************
*************************
*    CLEAR wa_zauto_cost.
*
**CHECK IF THE RECORD EXIST with same list/cost price
*    SELECT SINGLE * FROM zauto_cost INTO wa_zauto_cost WHERE
*                                       matnr = <l_table>-idnrk
*                                       AND datab = <l_table>-datab
*                                       AND databi = <l_table>-databi.
*    IF sy-subrc = 0.
*      if wa_zauto_cost-ZESC = <l_table>-zesc.
*      MESSAGE 'Component with same Estimated cost Exists' TYPE 'E'.
*      endif.
*      if wa_zauto_cost-zlip = <l_table>-zlip.
*      MESSAGE 'Component with same List Price Exists' TYPE 'E'.
*      endif.
*      CLEAR wa_zauto_cost.
*    ENDIF.
*************************

      ENDLOOP.

      CALL METHOD gr_tab->refresh_table_display.

*sets cursor to the current field
      CALL METHOD gr_tab->set_current_cell_via_id
        EXPORTING
          is_column_id = l_col_id
          is_row_no    = l_row_id.

    CATCH cx_root INTO oref.
      text = oref->get_text( ).
      MESSAGE 'Exception' TYPE 'E' .
  ENDTRY.

*******
ENDFORM.                    " ZF_HANDLE_DATA_CHANGED
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9002 INPUT.
  CLEAR : l_data,l_valid.

  CASE sy-ucomm.
    WHEN 'EXIT'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'BACK'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'SAVE'.
*logic for saving and changing data in the z table
      CLEAR l_answer.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar      = 'SAVE IN TABLES'
*         DIAGNOSE_OBJECT             = ' '
          text_question = 'Are you sure you want to save this data?'(005)
          text_button_1 = 'Yes'(006)
          text_button_2 = 'No'(007)
        IMPORTING
          answer        = l_answer.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF  l_answer = 1.

*check if the fert material list and cost prices are zero
*        then do not updated history table

        CLEAR: wa_output, wa_mara, l_hst,l_valid,l_est_lip.
        REFRESH it_zauto_costh.

*do not save in history table if zesc_qty and zlip_qty <= 0
        LOOP AT it_output INTO wa_output.
          IF wa_output-zesc_qty <= 0 OR wa_output-zlip_qty <= 0.
            l_hst = 'X'.
            EXIT.
          ENDIF.
*          ENDIF.
        ENDLOOP.

*********************************************************
        CLEAR: wa_output, wa_mara.

*        IF l_valid <> 'X'.
        IF l_hst <> 'X'.
          LOOP AT it_output INTO wa_output.
*add the above record to history table IF cost and list price for all
*components are non zero
            CLEAR wa_zauto_costh.
            wa_zauto_costh-mandt = sy-mandt .
            wa_zauto_costh-header = p_matnr .
            wa_zauto_costh-plant  = p_werks .
            wa_zauto_costh-so_date = p_erdat.
            wa_zauto_costh-idnrk = wa_output-idnrk.
            wa_zauto_costh-ojtxp = wa_output-ojtxp.
            wa_zauto_costh-mnglg = wa_output-mnglg.
            wa_zauto_costh-ebeln = wa_output-ebeln.
            wa_zauto_costh-waers = wa_output-waers.
            wa_zauto_costh-verpr = wa_output-price.
            wa_zauto_costh-netpr = wa_output-netpr.
            wa_zauto_costh-zesc  = wa_output-zesc .
            wa_zauto_costh-kbetr = wa_output-kbetr.
            wa_zauto_costh-zlip =  wa_output-zlip .
            wa_zauto_costh-zesc_qty =  wa_output-zesc_qty.
            wa_zauto_costh-zlip_qty =  wa_output-zlip_qty.
            wa_zauto_costh-datab =  wa_output-datab.
            wa_zauto_costh-datbi =  wa_output-datbi.
            APPEND wa_zauto_costh TO it_zauto_costh.
          ENDLOOP.
*          APPEND LINES OF IT_ZAUTO_COSTH TO ZAUTO_COSTH.
*          MODIFY ZAUTO_COSTH FROM IT_ZAUTO_COSTH[] .
          SORT it_zauto_costh.
          DELETE ADJACENT DUPLICATES FROM it_zauto_costh.
*          INSERT ZAUTO_COSTH FROM TABLE IT_ZAUTO_COSTH[] .
*          update ZAUTO_COSTH FROM TABLE IT_ZAUTO_COSTH[] .
          MODIFY zauto_costh1 FROM TABLE it_zauto_costh[] .
          COMMIT WORK.
          MESSAGE 'Data Saved in History Table' TYPE 'S'.
          l_data = 'X'.
        ELSEIF l_hst = 'X'.
          l_est_lip = 'X'.
        ENDIF.
      ELSEIF l_answer <> 1.
      ENDIF.
  ENDCASE.

  IF l_data = 'X'.
    SET SCREEN 0.
    LEAVE SCREEN.

  ELSEIF  l_est_lip = 'X'.
    SET SCREEN 0.
    LEAVE SCREEN.
    MESSAGE 'Components have Cost/List Price as 0 data not saved in History Table ' TYPE 'I'.
  ENDIF.

ENDMODULE.                 " USER_COMMAND_9002
