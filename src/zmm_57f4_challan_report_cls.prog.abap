*&---------------------------------------------------------------------*
*&  Include           ZMM_57F4_CHALLAN_REPORT_CLS
*&---------------------------------------------------------------------*
*DEFINE reset_column_title.
*  call method &1->reset_column_title
*    exporting
*      i_column = &2
*      i_lbl_s  = &3
*      i_lbl_m  = &4
*      i_lbl_l  = &5
*      i_tltip  = &6.
*END-OF-DEFINITION.

DEFINE set_footer_text.
  CALL METHOD &1->set_footer_text
    EXPORTING
      i_row = &2
      i_col = &3
      i_typ = &4
      i_txt = &5.
END-OF-DEFINITION.

DEFINE convert_to_str.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = &1
    IMPORTING
      output = &2
    EXCEPTIONS
      OTHERS = 0.
END-OF-DEFINITION.

*----------------------------------------------------------------------*
*       CLASS lcl_salv DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_salv DEFINITION.
  PUBLIC SECTION.
    DATA :
      alv_obj    TYPE REF TO cl_salv_table,
      alv_fncts  TYPE REF TO cl_salv_functions_list,
      grid_obj   TYPE REF TO cl_salv_form_layout_grid,
      "lyot_flow   TYPE REF TO cl_salv_form_layout_flow,
      "lyot_lbl    TYPE REF TO cl_salv_form_label,
      "ui_content  TYPE REF TO cl_salv_form_element,
      alv_hdr    TYPE REF TO cl_salv_form_layout_logo,
      alv_ftr    TYPE REF TO cl_salv_form_layout_grid,
      dispsetngs TYPE REF TO cl_salv_display_settings,
      colmns     TYPE REF TO cl_salv_columns_table,
      colmn      TYPE REF TO cl_salv_column,
      colm       TYPE REF TO cl_salv_column_list,
      aggrs      TYPE REF TO cl_salv_aggregations,
      events     TYPE REF TO cl_salv_events_table,
      sorts      TYPE REF TO cl_salv_sorts.

    METHODS : constructor IMPORTING i_alv_obj       TYPE REF TO cl_salv_table
                                    i_set_all       TYPE char1
                                    i_set_optimized TYPE char1 OPTIONAL,

      set_all_functions,
      get_column              IMPORTING i_column  TYPE lvc_fname,
      get_list_column         IMPORTING i_column  TYPE lvc_fname,
      get_columns,
      hide_column             IMPORTING i_column  TYPE lvc_fname,
      get_events,
      get_aggregations,
      get_sorts,
      set_all_optimized,
      set_title               IMPORTING i_title   TYPE lvc_title,
      display_company_header  IMPORTING i_title   TYPE lvc_title,
      set_footer_text         IMPORTING i_row TYPE i
                                        i_col TYPE i
                                        i_typ TYPE char1
                                        i_txt TYPE char100,
      reset_column_title      IMPORTING i_column TYPE lvc_fname
                                        i_lbl_s  TYPE scrtext_s
                                        i_lbl_m  TYPE scrtext_m
                                        i_lbl_l  TYPE scrtext_l
                                        i_tltip  TYPE lvc_tip,
      set_total               IMPORTING i_column  TYPE lvc_fname,
      set_total_line_on_top,
      show_hotspot_links      IMPORTING i_column  TYPE lvc_fname,
      set_sort                IMPORTING i_column TYPE lvc_fname
                                        i_subtot TYPE sap_bool,
      set_edit_mask           IMPORTING i_column TYPE lvc_fname
                                        i_mask   TYPE lvc_edtmsk,
      align                   IMPORTING i_column TYPE lvc_fname
                                        i_align  TYPE salv_de_alignment,
      display.

ENDCLASS.                    "lcl_salv DEFINITION if_salv_c_bool_sap=>true.

*----------------------------------------------------------------------*
*       CLASS lcl_salv IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_salv IMPLEMENTATION.
  METHOD constructor.       " Set ALV Object
    me->alv_obj = i_alv_obj.
    IF NOT i_set_all IS INITIAL.
      set_all_functions( ).
    ENDIF.
    IF NOT i_set_optimized IS INITIAL .
      set_all_optimized( ).
    ENDIF.
    CREATE OBJECT grid_obj.
    CREATE OBJECT alv_hdr.
    CREATE OBJECT alv_ftr.
  ENDMETHOD.                    "constructor

  METHOD display.           " Display AlV
    IF NOT me->alv_hdr IS INITIAL.
      me->alv_obj->set_top_of_list( me->alv_hdr ).
    ENDIF.
    IF NOT me->alv_ftr IS INITIAL.
      me->alv_obj->set_end_of_list( me->alv_ftr ).
    ENDIF.
    me->alv_obj->display( ).
  ENDMETHOD.                    "display

  METHOD set_all_functions. " Set all functions enabled
    CLEAR me->alv_fncts.
    me->alv_fncts = me->alv_obj->get_functions( ).
    me->alv_fncts->set_all( abap_true ).
  ENDMETHOD.                    "set_all_functions

  METHOD set_title. "set list title
    CLEAR me->dispsetngs.
    me->dispsetngs = me->alv_obj->get_display_settings( ).
    me->dispsetngs->set_list_header( i_title ).
    "me->dispsetngs->set_striped_pattern( if_salv_c_bool_sap=>true ).
  ENDMETHOD.                    "set_title

  METHOD display_company_header. " Set default Header
    DATA : lv_i          TYPE i VALUE 0,
           lv_str        TYPE string,

           lv_time_stamp TYPE timestamp,
           lv_tzone      TYPE tznzone,
           lv_date       TYPE datum,
           lv_time       TYPE uzeit.

    CLEAR : lv_str, lv_time_stamp, lv_tzone, lv_date, lv_time.

    me->set_title( i_title = i_title ).

    lv_i = lv_i + 1.
    me->grid_obj->create_header_information( row = lv_i
                                             column  = 1
                                             text = 'Delval Flow Controls Pvt. Ltd.' ).

    lv_i = lv_i + 1.
    me->grid_obj->create_label( row    = lv_i
                                column = 1
                                text   = 'Report : ' ).
    me->grid_obj->create_text( row = lv_i column = 2 text = sy-repid ).

    lv_i = lv_i + 1.
    "-- Time Stamp
    GET TIME STAMP FIELD lv_time_stamp.
    SELECT SINGLE tzone
    INTO lv_tzone
    FROM usr02
    WHERE bname = sy-uname.
    IF sy-subrc EQ 0.
      CONVERT TIME STAMP lv_time_stamp TIME ZONE lv_tzone INTO
              DATE lv_date TIME lv_time.
    ENDIF.
    CONCATENATE sy-sysid(5) '(' sy-mandt ')--' sy-uname '--'
                lv_date+4(2) '/' lv_date+6(2) '/' lv_date(4) '-'
                lv_time(2) ':' lv_time+2(2) ':' lv_time+4(2)
       INTO lv_str.
    me->grid_obj->create_label( row = lv_i
                                column = 1
                                text = 'Stst/User/Timestmp : ' ).
    me->grid_obj->create_text( row = lv_i column = 2 text = lv_str ).

    me->alv_hdr->set_left_content( me->grid_obj ).
*    me->alv_hdr->set_right_logo( 'XXXXX' ).
    CLEAR lv_i.
  ENDMETHOD.                    "display_Company_header

  METHOD set_footer_text.
    IF i_typ EQ 'L'." Print as Label
      me->alv_ftr->create_label( row = i_row column = i_col text =
i_txt ).
    ELSE. " Print as text
      me->alv_ftr->create_text( row = i_row column = i_col text =
i_txt ).
    ENDIF.
  ENDMETHOD.                    "set_footer_text

  METHOD get_column.
    get_columns( ).
    CLEAR colmn.
    TRY.
        colmn = colmns->get_column( i_column ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDMETHOD.

  METHOD get_list_column.
    get_columns( ).
    CLEAR colm.
    TRY.
        colm ?= colmns->get_column( i_column ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDMETHOD.

  METHOD reset_column_title.
    get_column( i_column ).
    IF NOT colmn IS INITIAL.
      IF NOT i_lbl_s IS INITIAL.
        colmn->set_short_text( i_lbl_s ).
      ENDIF.
      IF NOT i_lbl_m IS INITIAL.
        colmn->set_medium_text( i_lbl_m ).
      ENDIF.
      IF NOT i_lbl_l IS INITIAL.
        colmn->set_long_text( i_lbl_l ).
      ENDIF.
      IF NOT i_tltip IS INITIAL.
        colmn->set_tooltip( i_tltip ).
      ENDIF.
    ENDIF.

  ENDMETHOD.                    "reset_column_title

  METHOD set_all_optimized.
    get_columns( ).
    colmns->set_optimize( abap_true ).
  ENDMETHOD.                    "set_all_optimized

  METHOD get_columns.
    IF colmns IS INITIAL.
      colmns = alv_obj->get_columns( ).
    ENDIF.
  ENDMETHOD.                    "get_columns

  METHOD get_events.
    IF events IS INITIAL.
      events = alv_obj->get_event( ).
    ENDIF.
  ENDMETHOD.

  METHOD get_aggregations.
    IF aggrs IS INITIAL.
      aggrs = alv_obj->get_aggregations( ).
    ENDIF.
  ENDMETHOD.

  METHOD set_total.
    get_aggregations( ).
    TRY.
        CALL METHOD aggrs->add_aggregation
          EXPORTING
            columnname  = i_column
            aggregation = if_salv_c_aggregation=>total.
      CATCH cx_salv_data_error .                        "#EC NO_HANDLER
      CATCH cx_salv_not_found .                         "#EC NO_HANDLER
      CATCH cx_salv_existing .                          "#EC NO_HANDLER
    ENDTRY.
  ENDMETHOD.                    "set_total

  METHOD set_total_line_on_top.    " Bring the total line to top
    get_aggregations( ).
    aggrs->set_aggregation_before_items( ).
  ENDMETHOD.

  METHOD show_hotspot_links.
    get_list_column( i_column ).
    IF NOT colm IS INITIAL.
      colm->set_cell_type( if_salv_c_cell_type=>hotspot )."link
    ENDIF.
  ENDMETHOD.

  METHOD hide_column.
    get_column( i_column ).
    IF NOT colmn IS INITIAL.
      colmn->set_visible( space ).
    ENDIF.
  ENDMETHOD.

  METHOD get_sorts.
    IF sorts IS INITIAL.
      sorts = alv_obj->get_sorts( ).
    ENDIF.
  ENDMETHOD.

  METHOD set_edit_mask.
    get_column( i_column ).
    IF NOT colmn IS INITIAL.
      colmn->set_edit_mask( i_mask ).
    ENDIF.
  ENDMETHOD.

  METHOD align.
    get_column( i_column ).
    IF NOT colmn IS INITIAL.
      colmn->set_alignment( i_align ).
    ENDIF.
  ENDMETHOD.

  METHOD set_sort.
    get_sorts( ).

*   Set the SORT on the AUART with Subtotal
    TRY.
        CALL METHOD sorts->add_sort
          EXPORTING
            columnname = i_column
            subtotal   = i_subtot.
      CATCH cx_salv_not_found .                         "#EC NO_HANDLER
      CATCH cx_salv_existing .                          "#EC NO_HANDLER
      CATCH cx_salv_data_error .                        "#EC NO_HANDLER
    ENDTRY.
*
  ENDMETHOD.                    "set_sorts
ENDCLASS.                    "lcl_salv IMPLEMENTATION
