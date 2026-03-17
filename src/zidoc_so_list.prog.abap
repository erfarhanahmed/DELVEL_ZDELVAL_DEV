*&---------------------------------------------------------------------*
*& Report ZIDOC_SO_LIST
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& (C)   P R I M U S  TECHSYSTEMS PVT. LTD.
*&---------------------------------------------------------------------*
*& Program Name      : ZIDOC_SO_LIST
*& Type / Module     : REPORT
*& Created by        : Gyanendra Kumar
*& Created on        : 11.09.2018
*& Consultant        : Pranav Khadatkar
*& TCode used        : ZIDOC_SO
*& Description       : Report to Dispay Sales Order Number against IDoc Number on Date.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT zidoc_so_list.
TYPE-POOLS : slis.
TABLES: vbak, ekko.

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
         so   TYPE vbak-vbeln,                     "srrelroles-objkey,
         idoc TYPE srrelroles-objkey,
       END OF ty_final.

TYPES: BEGIN OF ty_final1,
         idoc   TYPE srrelroles-objkey,
         vbeln  TYPE vbap-vbeln,
         posnr  TYPE vbap-posnr,
         ebeln  TYPE vbak-bstnk,
         posex  TYPE vbap-posex,
         kwmeng TYPE vbap-kwmeng,
       END OF ty_final1.

DATA: lt_rid   TYPE TABLE OF ty_roleid,
      lt_ra    TYPE TABLE OF ty_role_a,
      lt_okey  TYPE TABLE OF ty_objkey,
      lt_final TYPE TABLE OF ty_final,
      ls_rid   TYPE ty_roleid,
      ls_ra    TYPE ty_role_a,
      ls_okey  TYPE ty_objkey,
      ls_final TYPE ty_final.

DATA: lt_final1 TYPE TABLE OF ty_final1,
      ls_final1 TYPE ty_final1,
      lt_vbak   TYPE TABLE OF vbak,
      ls_vbak   TYPE vbak,
      lt_vbap   TYPE TABLE OF vbap,
      ls_vbap   TYPE vbap.

RANGES: r_ebeln FOR ekko-ebeln,
        r_vbeln FOR vbak-vbeln.

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
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE t-001.
SELECT-OPTIONS: s_datum FOR sy-datum OBLIGATORY NO-EXTENSION NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2  WITH FRAME TITLE t-002.
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln NO INTERVALS,
                s_ebeln FOR ekko-ebeln NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b2.
* Start-of-selection.
START-OF-SELECTION.

  CONCATENATE s_datum-low '000000' INTO lv_utctime_low.
  CONCATENATE s_datum-low '235959' INTO lv_utctime_high.

* Get the role id
  SELECT objkey
         roleid
    FROM srrelroles
    INTO TABLE lt_rid
    WHERE objtype = 'BUS2032'                            "objkey = p_vbeln
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
    SELECT *
      FROM vbak
      INTO TABLE lt_vbak
      FOR ALL ENTRIES IN lt_final
      WHERE vbeln = lt_final-so.
    IF NOT lt_vbak IS INITIAL.
      SELECT *
        FROM vbap
        INTO TABLE lt_vbap
        FOR ALL ENTRIES IN lt_vbak
        WHERE vbeln = lt_vbak-vbeln.
    ENDIF.

    SORT lt_vbak BY vbeln ASCENDING.
    SORT lt_vbap BY vbeln ASCENDING posnr ASCENDING.

    LOOP AT lt_vbap INTO ls_vbap.
      READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_vbap-vbeln.

      ls_final1-vbeln  = ls_vbak-vbeln.
      ls_final1-posnr  = ls_vbap-posnr.
      ls_final1-ebeln  = ls_vbak-bstnk.
      ls_final1-posex  = ls_vbap-posex.
      ls_final1-kwmeng = ls_vbap-kwmeng.

      READ TABLE lt_final INTO ls_final WITH KEY so = ls_vbap-vbeln.
      ls_final1-idoc = ls_final-idoc.

      APPEND ls_final1 TO lt_final1.
      CLEAR: ls_final, ls_final1, ls_vbak, ls_vbap.
    ENDLOOP.

    IF NOT s_vbeln IS INITIAL.
      DELETE lt_final1 WHERE vbeln NOT IN s_vbeln.
    ENDIF.

    IF NOT s_ebeln IS INITIAL.
      DELETE lt_final1 WHERE ebeln NOT IN s_ebeln.
    ENDIF.

    IF NOT lt_final1 IS INITIAL.
      PERFORM display_table.
    ELSE.
      MESSAGE s208(00) WITH 'Specific Data Not found'.
      LEAVE LIST-PROCESSING.
    ENDIF.
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
  fieldcatalog-outputlen   = 20.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'VBELN'.
  fieldcatalog-seltext_m   = 'Sales Order No.'.
  fieldcatalog-hotspot     = 'X'.
  fieldcatalog-emphasize   = 'C510'.
  fieldcatalog-col_pos     = 2.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'POSNR'.
  fieldcatalog-seltext_m   = 'Sales Order Item No.'.
  fieldcatalog-lzero       = 'X'.
  fieldcatalog-just        = 'L'.
  fieldcatalog-col_pos     = 3.
  fieldcatalog-outputlen   = 20.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'KWMENG'.
  fieldcatalog-seltext_m   = 'Sales Order Qty'.
  fieldcatalog-col_pos     = 4.
  fieldcatalog-outputlen   = 20.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'EBELN'.
  fieldcatalog-seltext_m   = 'Purchase Order No.'.
  fieldcatalog-hotspot     = 'X'.
  fieldcatalog-emphasize   = 'C310'.
  fieldcatalog-col_pos     = 5.
  fieldcatalog-outputlen   = 20.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'POSEX'.
  fieldcatalog-seltext_m   = 'Purchase Order Line No.'.
  fieldcatalog-col_pos     = 6.
  fieldcatalog-outputlen   = 20.
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
  gd_layout-zebra = 'X'.
  gd_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = gd_repid
      is_layout               = gd_layout
      i_callback_top_of_page  = 'TOP-OF-PAGE'
      i_callback_user_command = 'USER_COMMAND'
      it_fieldcat             = fieldcatalog[]
*     i_save                  = 'X'
*     is_variant              = g_variant
    TABLES
      t_outtab                = lt_final1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
FORM user_command USING r_ucomm     LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  CASE r_ucomm.
    WHEN '&IC1'.
      CASE rs_selfield-fieldname.
        WHEN 'VBELN'.
          SET PARAMETER ID 'AUN' FIELD rs_selfield-value.
          CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
        WHEN 'EBELN'.
          SET PARAMETER ID 'BES' FIELD rs_selfield-value.
          CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
      ENDCASE.
  ENDCASE.
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
  wa_header-info = 'Sale Order Number Against IDoc Number'.
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
