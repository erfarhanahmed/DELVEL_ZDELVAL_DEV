*&---------------------------------------------------------------------*
*& Report ZSOURCING_RESTRICTION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsourcing_restriction.


TABLES : vbap, vbak, zsource_restc2.

TYPES : BEGIN OF str_updated,

*          vbeln               TYPE vbak-vbeln,
*          component_type      TYPE zsource_restc1-component_type,
*          posnr               TYPE zsource_restc1-posnr,
*          com_code_desc       TYPE zsource_restc1-com_code_desc,
*          product             TYPE char50,     "zsource_restc1-product,
*          sub_cat             TYPE char50,     "zsource_restc1-sub_cat,
*          country_restriction TYPE zsource_restc1-country_restriction,
*          supply_restriction  TYPE zsource_restc1-supply_restriction,

          vbeln               TYPE zsource_restc2-vbeln,
          component_type      TYPE zsource_restc2-component_type,
          posnr               TYPE zsource_restc2-posnr,
          com_code_desc       TYPE zsource_restc2-com_code_desc,
          product             TYPE char50, "zsource_restc2-product,
          sub_cat             TYPE char50,  "zsource_restc2-sub_cat,
          country_restriction TYPE zsource_restc2-country_restriction,
          supply_restriction  TYPE zsource_restc2-supply_restriction,
          comp_restriction    type zsource_restc2-comp_restrcition,

        END OF str_updated.



TYPES : BEGIN OF str_final_out,

          vbeln               TYPE zsource_restc2-vbeln,
          component_type      TYPE zsource_restc2-component_type,
          posnr               TYPE zsource_restc2-posnr,
          com_code_desc       TYPE zsource_restc2-com_code_desc,
          product             TYPE zsource_restc2-product,
          sub_cat             TYPE zsource_restc2-sub_cat,
          country_restriction TYPE char50, "zsource_restc2-country_restriction,
          supply_restriction  TYPE char50, "zsource_restc2-supply_restriction,
          comp_restriction    TYPE char50,
          check_box           TYPE zsource_restc2-check_box,


*          vbeln               TYPE vbak-vbeln,
*          component_type      TYPE zsource_restc1-component_type,
*          posnr               TYPE zsource_restc1-posnr,
*          com_code_desc       TYPE zsource_restc1-com_code_desc,
*          product             TYPE zsource_restc1-product,
*          sub_cat             TYPE zsource_restc1-sub_cat,
*          country_restriction TYPE char50,      "zsource_restc1-country_restriction,
*          supply_restriction  TYPE char50,       "zsource_restc1-supply_restriction,
*          check_box           TYPE zsource_restc1-check_box,



        END OF str_final_out.

TYPES : BEGIN OF ty_data,
*          product        TYPE zsale_ord_val-product,
*          sub_cat        TYPE zsale_ord_val-sub_cat,
*          com_code_desc  TYPE zsale_ord_val-com_code_desc,
*          component_type TYPE zsale_ord_val-component_type,

          product        TYPE zsale_ord_val1-product,
          sub_cat        TYPE zsale_ord_val1-sub_cat,
          com_code_desc  TYPE zsale_ord_val1-com_code_desc,
          component_type TYPE zsale_ord_val1-component_type,

        END OF ty_data.

DATA : it_data1 TYPE TABLE OF ty_data,
       wa_data  TYPE ty_data.

TYPES : BEGIN OF str_vbap,
          vbeln TYPE vbap-vbeln,
          posnr TYPE vbap-posnr,
        END OF str_vbap.



DATA : v_vbeln     TYPE vbak-vbeln,
       var1        TYPE vbak-vbeln,
       v_update(1) TYPE c,
       gv_posnr    TYPE vbap-posnr.

DATA :lt_final_out   TYPE TABLE OF str_final_out,
      ls_final_out   TYPE str_final_out,
      lt_final_out_s TYPE TABLE OF str_final_out,
      ls_final_out_s TYPE str_final_out,
      lt_final_out1  TYPE TABLE OF str_updated,
      ls_final_out1  TYPE str_updated,
      lt_vbap        TYPE TABLE OF str_vbap,
      ls_vbap        TYPE str_vbap,
      lt_updated     TYPE TABLE OF zsource_restc2,
      ls_updated     TYPE zsource_restc2,
      lv_fresh       TYPE c.


DATA : lv_lines  TYPE STANDARD TABLE OF tline,
       wa_lines  LIKE tline,
       wa_ofm_no LIKE tline,
       lv_name   TYPE thead-tdname,
       wa_text   TYPE char20.

DATA :save_ok  LIKE sy-ucomm.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA : gt_listheader   TYPE slis_t_listheader   WITH HEADER LINE,
       gt_fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       gt_event        TYPE slis_t_event        WITH HEADER LINE,
       gt_layout       TYPE slis_layout_alv,
       gt_sort         TYPE slis_t_sortinfo_alv WITH HEADER LINE.

DATA : ref_grid TYPE REF TO cl_gui_alv_grid.

DATA : dd07v_tab TYPE TABLE OF dd07v.


DATA: gt_return  TYPE TABLE OF ddshretval,
      gwa_return TYPE ddshretval.

DATA: gwa_dynpfields TYPE dynpread,
      gt_dynpfields  TYPE TABLE OF dynpread.

DATA : p_vbeln1 TYPE  vbak-vbeln,
       p_prdct1 TYPE  zsource_restc2-product.


SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.


PARAMETERS : p_vbeln     TYPE vbak-vbeln.
PARAMETERS : p_posnr     TYPE vbap-posnr.
PARAMETERS:  p_prdct     TYPE zsource_restc2-product.  "AS LISTBOX VISIBLE LENGTH 6.
PARAMETERS:  p_subcat    TYPE zsource_restc2-sub_cat.  "AS LISTBOX VISIBLE LENGTH 6.
PARAMETERS:  p_count     TYPE char50.   "zsource_restc1-country_restriction.
PARAMETERS:  p_supply    TYPE char50.   "zsource_restc1-supply_restriction.
PARAMETERS:  p_comp      TYPE char50.

SELECTION-SCREEN : END OF BLOCK b1.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vbeln.
*   PERFORM vbeln_f4 CHANGING p_vbeln.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_posnr.
  PERFORM posnr_f4 CHANGING p_posnr.

START-OF-SELECTION .

  PERFORM get_data.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .


  CALL FUNCTION 'DD_DOMVALUES_GET'
    EXPORTING
      domname   = 'ZCOMPONENT_TYPE'
*     TEXT      = ' '
      langu     = sy-langu
*     BYPASS_BUFFER        = ' '
* IMPORTING
*     RC        =
    TABLES
      dd07v_tab = dd07v_tab
* EXCEPTIONS
*     WRONG_TEXTFLAG       = 1
*     OTHERS    = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*  IF p_vbeln IS NOT INITIAL .

*  BREAK primus.

  SELECT   product
           sub_cat
           com_code_desc
           component_type   FROM zsale_ord_val1  INTO TABLE it_data1 WHERE  sub_cat = p_subcat AND product = p_prdct.

  DELETE ADJACENT DUPLICATES FROM it_data1 COMPARING ALL FIELDS.

  SELECT SINGLE vbeln FROM vbap INTO v_vbeln WHERE vbeln = p_vbeln AND posnr = p_posnr.



  IF sy-subrc = 0.

    LOOP AT it_data1 INTO wa_data.

      ls_final_out-component_type      = wa_data-component_type.
      ls_final_out-vbeln               = v_vbeln.
      ls_final_out-posnr               = p_posnr.
      ls_final_out-sub_cat             = wa_data-sub_cat.
      ls_final_out-product             = wa_data-product.
      ls_final_out-com_code_desc       = wa_data-com_code_desc.

      APPEND ls_final_out TO lt_final_out.
*        CLEAR ls_final_out.

*        REFRESH : lt_updated, it_data1.

    ENDLOOP.
  ENDIF.

*  REFRESH : lt_updated,lt_vbap,lt_final_out.


  IF v_vbeln IS NOT INITIAL.
    UNPACK v_vbeln TO v_vbeln.

    SELECT vbeln FROM vbak INTO var1 WHERE vbeln = p_vbeln.
    ENDSELECT.


    IF var1 IS NOT INITIAL.

      SELECT vbeln
             posnr FROM vbap INTO TABLE lt_vbap  WHERE vbeln EQ var1 AND posnr = p_posnr.


      SELECT * FROM zsource_restc2 INTO TABLE lt_updated WHERE vbeln EQ p_vbeln.



*      BREAK primus.

      IF lt_vbap IS NOT INITIAL.

        LOOP AT lt_vbap INTO ls_vbap.

          READ TABLE lt_updated INTO ls_updated WITH KEY vbeln = ls_vbap-vbeln posnr = ls_vbap-posnr.
          IF sy-subrc = 0.

            ls_final_out-vbeln  = ls_updated-vbeln.
*
            CLEAR: lv_lines.
            REFRESH lv_lines.

*      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
            CONCATENATE ls_vbap-vbeln ls_vbap-posnr INTO lv_name.
*                CONCATENATE ls_updated-vbeln ls_updated-posnr INTO lv_name.

            SHIFT ls_updated-posnr LEFT DELETING LEADING '0'.
            ls_final_out-posnr  = ls_updated-posnr.

            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = 'Z102'
                language                = sy-langu
                name                    = lv_name
                object                  = 'VBBP'
              TABLES
                lines                   = lv_lines
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.


            ls_final_out-vbeln                = ls_updated-vbeln.
            ls_final_out-posnr                = ls_updated-posnr.
            ls_final_out-product              = ls_updated-product.
            ls_final_out-sub_cat              = ls_updated-sub_cat.
            ls_final_out-component_type       = ls_updated-component_type.
            ls_final_out-com_code_desc        = ls_updated-com_code_desc.
            ls_final_out-country_restriction  = ls_updated-country_restriction.
            ls_final_out-supply_restriction   = ls_updated-supply_restriction.
            ls_final_out-comp_restriction     = ls_updated-comp_restrcition.


            IF lv_fresh = 'F2'.
              CLEAR ls_final_out-check_box.
            ENDIF.
          ELSE.

            ls_final_out-vbeln = ls_vbap-vbeln.
*                SHIFT ls_vbap-posnr LEFT DELETING LEADING '0'.

            CLEAR: lv_lines.
            REFRESH lv_lines.
*      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
            CONCATENATE ls_vbap-vbeln ls_vbap-posnr INTO lv_name.

            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = 'Z102'
                language                = sy-langu
                name                    = lv_name
                object                  = 'VBBP'
              TABLES
                lines                   = lv_lines
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.

            ls_final_out-posnr = ls_vbap-posnr.

          ENDIF.

          APPEND ls_final_out TO lt_final_out.
          CLEAR ls_final_out.

        ENDLOOP.
      ENDIF.

      PERFORM f_listheader.
      PERFORM fcat.
      PERFORM f_layout.
      PERFORM get_display.

    ELSE.
      MESSAGE 'Sales Order Number not exists.' TYPE 'I'.
    ENDIF.

  ELSE.
    MESSAGE 'Insert Sales Order Number.' TYPE 'I'.
  ENDIF.


*        ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fcat .

  REFRESH it_fcat.

  PERFORM fieldcat USING :    '1'     'VBELN'                       'LT_FINAL_OUT'     'Sale Order Number'         ''        '15'       '',
                              '2'     'COM_CODE_DESC'               'LT_FINAL_OUT'     'Company Code Desc'         ''        '20'       '',
                              '3'     'POSNR'                       'LT_FINAL_OUT'     'Position No'               ''        '6'        '',
                              '4'     'COMPONENT_TYPE'              'LT_FINAL_OUT'     'Component Type  '          ''        '3'       '',
                              '5'     'CHECK_BOX'                   'LT_FINAL_OUT'     'Check Box'                 'X'       '3'       'X'.
*                              '6'     'COUNTRY_RESTRICTION'         'LT_FINAL_OUT'     'Country Restriction'       'X'       '50'    '',
*                              '7'     'SUPPLY_RESTRICTION'        'LT_FINAL_OUT'     'Supplier Restriction'      'X'       '50'    ''.


ENDFORM.


FORM fieldcat USING VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5)
                    VALUE(p6)
                    VALUE(p7).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
  wa_fcat-edit      = p5.
  wa_fcat-outputlen   = p6.
  wa_fcat-checkbox   = p7.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.



FORM get_display .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'SET_PF_STATUS'
      i_callback_user_command  = 'USER_CMD'
      i_callback_top_of_page   = 'TOP-OF-PAGE'
      is_layout                = gt_layout
      it_fieldcat              = it_fcat
      it_events                = gt_event[]
      i_save                   = 'X'
    TABLES
      t_outtab                 = lt_final_out
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



ENDFORM.

FORM set_pf_status USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'ZSOURCE_REST'.

ENDFORM.

FORM user_cmd USING r_ucomm LIKE sy-ucomm  rs_selfield TYPE slis_selfield.

*  BREAK primus.
  save_ok = sy-ucomm.
*  CLEAR ok_code.
*   break primus.

  CASE r_ucomm.
    WHEN 'BACK'.
*      BREAK primus.
***      LEAVE PROGRAM.
      LEAVE TO SCREEN '1000'.

    WHEN 'SAVE'.
*      BREAK primus.
      PERFORM save_entries .

    WHEN 'REFRESH'.
*        break primus.
      lv_fresh = 'F2'.
      PERFORM get_data.
*      clear lv_fresh.
  ENDCASE.
ENDFORM.

FORM save_entries .

  REFRESH : lt_updated.

  CLEAR :ls_updated,ls_final_out,lv_fresh,ref_grid.
  IF ref_grid IS INITIAL.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = ref_grid.
  ENDIF.

  IF NOT ref_grid IS INITIAL.
    CALL METHOD ref_grid->check_changed_data.
  ENDIF.


*  BREAK primus.

  LOOP AT lt_final_out INTO ls_final_out WHERE check_box = 'X'.

    ls_updated-vbeln                = ls_final_out-vbeln .
    ls_updated-posnr                = ls_final_out-posnr .
    ls_updated-product              = ls_final_out-product.
    ls_updated-sub_cat              = ls_final_out-sub_cat.
    ls_updated-component_type       = ls_final_out-component_type.
    ls_updated-com_code_desc        = ls_final_out-com_code_desc.
*    ls_updated-country_restriction  = ls_final_out-country_restriction.
*    ls_updated-supply_restriction   = ls_final_out-supply_restriction.
    ls_updated-country_restriction  = p_count  .
    ls_updated-supply_restriction    = p_supply .
    ls_updated-comp_restrcition      = p_comp.

    MODIFY zsource_restc2 FROM ls_updated.
    APPEND ls_updated TO lt_updated .
    CLEAR ls_updated.

    IF sy-subrc = 0.

      MESSAGE 'Sales Order Number Is Saved.' TYPE 'S'.

    ENDIF.

  ENDLOOP.
*        refresh LT_FINAL_OUT-chk_box.
  CLEAR ref_grid.


ENDFORM.


FORM top_of_page.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = gt_listheader[].

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_LISTHEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_listheader .

  REFRESH gt_listheader.
  DATA : frmdt(10) TYPE c,
         todt(10)  TYPE c,
         v_str     TYPE string,
         line      TYPE string.


  gt_listheader-typ = 'H'.
  gt_listheader-key = ' '.
  gt_listheader-info = 'Sourcing Restriction'(001).
  APPEND gt_listheader.

  DESCRIBE TABLE lt_final_out LINES line.
  gt_listheader-typ = 'S'.
  gt_listheader-key  = 'TOTAL NO.OF RECORDS:'(108).
  gt_listheader-info = line.
  APPEND gt_listheader.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_layout .

  REFRESH gt_event.
  gt_event-name = slis_ev_top_of_page.
  gt_event-form = 'TOP_OF_PAGE'.
  APPEND gt_event.
  gt_layout-colwidth_optimize = 'X'.

ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  POSNR_F4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_POSNR  text
*----------------------------------------------------------------------*


FORM posnr_f4  CHANGING p_p_posnr.

*  break primus.


  DATA: dyn_field   TYPE dynpread,
        temp_fields TYPE TABLE OF dynpread,
        zlv_dynpro  TYPE syst-repid.
  zlv_dynpro = syst-repid.
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = zlv_dynpro
      dynumb     = syst-dynnr
      request    = 'A'
    TABLES
      dynpfields = temp_fields
    EXCEPTIONS
      OTHERS     = 0.


*break primus.
  LOOP AT temp_fields INTO dyn_field.
    IF dyn_field-fieldname EQ 'P_VBELN'.
      p_vbeln1 = dyn_field-fieldvalue.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = p_vbeln1
        IMPORTING
          output = p_vbeln1.

      SELECT vbeln
           posnr FROM vbap INTO TABLE lt_vbap  WHERE vbeln EQ  p_vbeln1.
      EXIT.
    ENDIF.
  ENDLOOP.

*      SELECT vbeln
*             posnr FROM vbap INTO TABLE lt_vbap  WHERE vbeln EQ p_vbeln."AND posnr = p_posnr.



  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'POSNR'
      value_org       = 'S'
    TABLES
      value_tab       = lt_vbap
      return_tab      = gt_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE gt_return INTO gwa_return INDEX 1.
  IF sy-subrc = 0.
    p_posnr = gwa_return-fieldval.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VBELN_F4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_VBELN  text
*----------------------------------------------------------------------*
*FORM vbeln_f4  CHANGING p_p_vbeln.
*data : i_returntab TYPE STANDARD TABLE OF DDSHRETVAL,
* i_returntab_line TYPE  DDSHRETVAL.
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*
*EXPORTING
*
*retfield = 'VBELN'
*
*dynpprog = sy-repid
*
*dynpnr = sy-dynnr
*
*dynprofield = 'P_VBELN'
*
*value_org = 'S'
*
*TABLES
*
**value_tab = LT_VBELN
*
*return_tab = i_returntab
*.
*IF sy-subrc = 0.
*
*READ TABLE i_returntab INTO i_returntab_line INDEX 1.
*
*P_VBELN = i_returntab_line-fieldval.
*endif.
*ENDFORM.
