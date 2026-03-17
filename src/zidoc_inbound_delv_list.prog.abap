*&---------------------------------------------------------------------*
*& Report ZIDOC_SO_LIST
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& (C)   P R I M U S  TECHSYSTEMS PVT. LTD.
*&---------------------------------------------------------------------*
*& Program Name      : ZIDOC_INBOUND_DELV_LIST
*& Type / Module     : REPORT
*& Created by        : Gyanendra Kumar
*& Created on        : 17.09.2018
*& Consultant        : Pranav Khadatkar
*& TCode used        : ZIDOC_DELV
*& Description       : Report to Dispay Inbound Delivery Number against IDoc Number on Date.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT zidoc_inbound_delv_list.
TYPE-POOLS : slis.

* Declarations.
TYPES: BEGIN OF ty_roleid,
         objkey TYPE srrelroles-objkey,
         roleid TYPE srrelroles-roleid,
       END OF ty_roleid,

       BEGIN OF ty_role_a,
         role_a TYPE idocrel-role_a,
         role_b TYPE idocrel-role_b,
       END OF ty_role_a,

       BEGIN OF ty_objkey,
         idoc   TYPE srrelroles-objkey,
         roleid TYPE srrelroles-roleid,
       END OF ty_objkey.

TYPES: BEGIN OF ty_final,
         so   TYPE srrelroles-objkey,
         idoc TYPE srrelroles-objkey,
       END OF ty_final.

DATA: lt_rid   TYPE TABLE OF ty_roleid,
      lt_ra    TYPE TABLE OF ty_role_a,
      lt_okey  TYPE TABLE OF ty_objkey,
      lt_final TYPE TABLE OF ty_final,
      ls_rid   TYPE ty_roleid,
      ls_ra    TYPE ty_role_a,
      ls_okey  TYPE ty_objkey,
      ls_final TYPE ty_final.

DATA: lv_utctime_low(15)  TYPE c,
      lv_utctime_high(15) TYPE c.

DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      gd_layout    TYPE slis_layout_alv,
      gd_repid     LIKE sy-repid,
      g_save       TYPE c VALUE 'X',
      g_variant    TYPE disvariant,
      gx_variant   TYPE disvariant,
      g_exit       TYPE c.

* Selection Screen
SELECT-OPTIONS: s_datum FOR sy-datum OBLIGATORY NO-EXTENSION NO INTERVALS.

* Start-of-selection.
START-OF-SELECTION.

  CONCATENATE s_datum-low '000000' INTO lv_utctime_low.
  CONCATENATE s_datum-low '235959' INTO lv_utctime_high.

* Get the role id
  SELECT objkey
         roleid
    FROM srrelroles
    INTO TABLE lt_rid
    WHERE objtype = 'BUS2015'                            "objkey = p_vbeln
      AND utctime BETWEEN lv_utctime_low AND lv_utctime_high.

  IF sy-subrc = 0.
* Get the Link between IDOC and application object.
    SELECT role_a
           role_b
      INTO TABLE lt_ra
      FROM idocrel
      FOR ALL ENTRIES IN lt_rid
      WHERE role_b = lt_rid-roleid.

    IF sy-subrc = 0.
* Get the IDOc number.
      SELECT objkey
             roleid
        FROM srrelroles
        INTO TABLE lt_okey
        FOR ALL ENTRIES IN lt_ra
        WHERE roleid = lt_ra-role_a.
    ENDIF.
  ENDIF.

  LOOP AT lt_rid INTO ls_rid.
    READ TABLE lt_ra INTO ls_ra WITH KEY role_b = ls_rid-roleid.
    IF sy-subrc = 0.
      READ TABLE lt_okey INTO ls_okey WITH KEY roleid = ls_ra-role_a.
      IF sy-subrc = 0.
        ls_final-so = ls_rid-objkey.
        ls_final-idoc = ls_okey-idoc.

        APPEND ls_final TO lt_final.
        CLEAR: ls_final, ls_rid, ls_ra, ls_okey.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF NOT lt_final IS INITIAL.
    PERFORM display_table.
  ELSE.
    MESSAGE s208(00) WITH 'IDOC Not found'.
    LEAVE LIST-PROCESSING.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_table .
  PERFORM build_fieldcatalog.
  PERFORM display_alv_report.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcatalog .
  fieldcatalog-fieldname   = 'IDOC'.
  fieldcatalog-seltext_m   = 'IDoc Number'.
  fieldcatalog-col_pos     = 1.
  fieldcatalog-outputlen     = 20.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'SO'.
  fieldcatalog-seltext_m   = 'Inbound Delivery Number'.
  fieldcatalog-col_pos     = 2.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_REPORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv_report .
  gd_repid = sy-repid.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = gd_repid
      i_callback_top_of_page  = 'TOP-OF-PAGE'  "see FORM
      i_callback_user_command = 'USER_COMMAND'
      it_fieldcat             = fieldcatalog[]
      i_save                  = 'X'
      is_variant              = g_variant
    TABLES
      t_outtab                = lt_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.

*-------------------------------------------------------------------*
* Form  TOP-OF-PAGE                                                 *
*-------------------------------------------------------------------*
* ALV Report Header                                                 *
*-------------------------------------------------------------------*
FORM top-of-page.
*ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.
* Title
  wa_header-typ  = 'H'.
  wa_header-info = 'Inbound Delivery Number Against IDoc Number'.
  APPEND wa_header TO t_header.
  CLEAR wa_header.
* Date
  wa_header-typ  = 'S'.
  wa_header-key = 'Date: '.
  CONCATENATE  sy-datum+6(2) '.'
               sy-datum+4(2) '.'
               sy-datum(4) INTO wa_header-info.   "todays date
  APPEND wa_header TO t_header.
  CLEAR: wa_header.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.
ENDFORM.                    "top-of-page
