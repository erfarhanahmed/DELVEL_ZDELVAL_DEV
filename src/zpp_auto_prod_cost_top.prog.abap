*&---------------------------------------------------------------------*
*&  Include           ZPP_AUTO_PROD_COST_TOP
*&---------------------------------------------------------------------*


TYPES : BEGIN OF t_output,
*          SR_NO         TYPE CHAR_02,
          IDNRK         TYPE IDNRK,
          OJTXP         TYPE OJTXP,
          MNGLG         TYPE CS_E_MNGLG,
          EBELN         TYPE EBELN,        "PO
          WAERS         TYPE WAERS,        "PO CURRENCY
          Price         TYPE VERPR,        "standard or moving avg price
          NETPR         TYPE BPREI,
*          ZESC          TYPE ZESC1,
          ZESC          TYPE KBETR,
*          FACTOR        TYPE DEC3_2STUN,
          KBETR        TYPE KBETR_KOND,    " FACTOR
*          ZLIP          TYPE ZLIP1,
          ZLIP          TYPE KBETR,
          ZESC_QTY      TYPE KBETR,
          ZLIP_QTY      TYPE KBETR,
          DATAB         TYPE DATAB, " valid from date
          DATBI         TYPE DATBI, " valid to date
          field_style   TYPE lvc_t_styl, "FOR DISABLE
          END OF t_output.

DATA: it_konh   TYPE STANDARD TABLE OF konh,
      wa_konh   TYPE konh,
      it_konp   TYPE STANDARD TABLE OF konp,
      it_ZESC   TYPE STANDARD TABLE OF konp,
      wa_ZESC   TYPE konp,
      it_ZLIP   TYPE STANDARD TABLE OF konp,
      wa_ZLIP   TYPE konp,
      wa_konp   TYPE konp,
      it_stb    TYPE STANDARD TABLE OF stpox,
      wa_stb    TYPE stpox,
      it_mbew   TYPE STANDARD TABLE OF mbew,
      wa_mbew   TYPE mbew,
      wa_mara   TYPE mara,
      wa_makt   TYPE makt,
      it_output TYPE STANDARD TABLE OF t_output initial size 0,
      wa_output TYPE t_output,
      it_ekko   TYPE STANDARD TABLE OF ekko,
      wa_ekko   TYPE ekKo,
      it_ekpo   TYPE STANDARD TABLE OF ekpo,
      wa_ekpo   TYPE ekpo,
      it_ZAUTO_COSTH  TYPE STANDARD TABLE OF ZAUTO_COSTH1,
      wa_ZAUTO_COSTH  TYPE ZAUTO_COSTH1,
      wa_ZAUTO_COSTH1  TYPE ZAUTO_COSTH1,
      it_ZAUTO_COST  TYPE STANDARD TABLE OF ZAUTOCOST1,
      wa_ZAUTO_COST  TYPE ZAUTOCOST1,
      wa_ZAUTO_COST1  TYPE ZAUTOCOST1,
      old_date type DATUM.

*variables
data: l_ANSWER TYPE CHAR1,
      history type flag,
      L_HST   type flag,
  L_est_lip   type flag,
      L_data  type flag,
      L_VALID type flag,
      L_qty   type flag,
      head    type flag,
      lv_date type dats.


*For ALV
*ALV data declarations
TYPE-POOLS: slis.

DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE.
DATA: it_fieldcat  TYPE lvc_t_fcat,     "slis_t_fieldcat_alv WITH HEADER LINE,
      wa_fieldcat  TYPE lvc_s_fcat,
      gd_tab_group TYPE slis_t_sp_group_alv,
      gd_layout    TYPE lvc_s_layo,     "slis_layout_alv,
      gd_repid     LIKE sy-repid.

*&--Display using cl_gui_alv_grid class
*CLASS lcl_handle_events DEFINITION DEFERRED.
DATA : gr_tab       TYPE REF TO cl_gui_alv_grid,
       gw_container TYPE REF TO cl_gui_custom_container.",
*       gr_event_rec TYPE REF TO lcl_handle_events.
DATA : gt_fcat      TYPE lvc_t_fcat.


*for making field field editable non editable
*DATA ls_stylerow TYPE lvc_s_styl .


*---------------------------------------------------------------------*
*       CLASS lcl_handle_events DEFINITION
*---------------------------------------------------------------------*
* §5.1 define a local class for handling events of cl_salv_table
*---------------------------------------------------------------------*
*CLASS lcl_handle_events DEFINITION.
*  PUBLIC SECTION.
*    DATA : ok_code TYPE sy-ucomm.
*    METHODS:
*      on_user_command FOR EVENT added_function OF cl_salv_events
*        IMPORTING e_salv_function,
*       handle_data_changed  FOR EVENT data_changed OF cl_gui_alv_grid
*        IMPORTING er_data_changed,
**      on_user_command FOR EVENT user_command OF cl_gui_alv_grid
**        IMPORTING e_ucomm,
*      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
*        IMPORTING e_object e_interactive,
*
*      after_user_command FOR EVENT after_user_command OF cl_gui_alv_grid
*        IMPORTING e_ucomm.
*ENDCLASS.                    "lcl_handle_events DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_handle_events IMPLEMENTATION
*---------------------------------------------------------------------*
* §5.2 implement the events for handling the events of cl_salv_table
*---------------------------------------------------------------------*
*CLASS lcl_handle_events IMPLEMENTATION.

*  METHOD handle_data_changed.
*    PERFORM zf_handle_data_changed USING er_data_changed.
*  ENDMETHOD.                    "handle_data_changed
*
**  METHOD on_user_command.
**    PERFORM ON USER COMMAND.
**  ENDMETHOD.                    "on_user_command
*
*  METHOD handle_toolbar.
**    PERFORM zf_handle_toolbar USING e_object e_interactive.
*  ENDMETHOD.                    "handle_toolbar

*  METHOD after_user_command.
*    PERFORM z
*  ENDMETHOD.                    "after_user_command
*ENDCLASS.                    "lcl_handle_events IMPLEMENTATION


*DATA:   go_events         TYPE REF TO lcl_handle_events.





INITIALIZATION.
*clear refresh all tables and work areas

*  REFRESH : it_KONH, it_KONP.
*  CLEAR   : wa_KONH, wa_KONP .
