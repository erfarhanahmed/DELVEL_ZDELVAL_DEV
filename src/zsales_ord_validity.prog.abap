*&---------------------------------------------------------------------*
*& Report ZSALES_ORD_VALIDITY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSALES_ORD_VALIDITY.

TABLES :vbak,vbap,ZSALES_ORD_VALID.

TYPES: BEGIN OF str_final_out,
*  mark,
  vbeln  TYPE vbak-vbeln,
  ofm_no(16) TYPE C,
  posnr  TYPE ZSALES_ORD_VALID-POSNR,
  chk_box type C,
  STATUS TYPE ZSALES_ORD_VALID-STATUS,
  LVBELN TYPE ZSALES_ORD_VALID-LVBELN,
  ERNAM  TYPE SY-UNAME,
  ZABDAT TYPE sy-datum,
  END OF str_final_out.

TYPES : BEGIN OF STR_UPDATED,
*  mandt type mandt,
  vbeln  TYPE vbak-vbeln,
  posnr  TYPE ZSALES_ORD_VALID-POSNR,
  STATUS TYPE ZSALES_ORD_VALID-STATUS,
  LVBELN TYPE ZSALES_ORD_VALID-LVBELN,
  ERNAM  TYPE ZSALES_ORD_VALID-ERNAM,
  ZABDAT TYPE ZSALES_ORD_VALID-ZABDAT,
  END OF STR_UPDATED.


TYPES :BEGIN OF str_vbap,
  vbeln TYPE vbap-vbeln,
  posnr TYPE vbap-posnr,
  END OF str_vbap.


DATA : v_vbeln TYPE vbak-vbeln,
      var1 TYPE vbak-vbeln,
      v_ofm_no(16) TYPE C,
      v_update(1) TYPE C .

DATA :lt_final_out TYPE TABLE OF str_final_out,
      ls_final_out TYPE str_final_out,
      lt_final_out_s TYPE TABLE OF str_final_out,
      ls_final_out_s TYPE str_final_out,
      lt_final_out1 TYPE TABLE OF STR_UPDATED,
      ls_final_out1 TYPE STR_UPDATED,
      lt_vbap TYPE TABLE OF str_vbap,
      ls_vbap TYPE str_vbap,
      LT_UPDATED TYPE TABLE OF zsales_ord_valid,
      LS_UPDATED TYPE zsales_ord_valid,
      lv_fresh type c.

**********ofm**********************
DATA : lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      wa_ofm_no LIKE tline,
      lv_name   TYPE thead-tdname,
      wa_text   TYPE char20.

DATA :save_ok            LIKE sy-ucomm.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA : gt_listheader   TYPE slis_t_listheader   WITH HEADER LINE,
       gt_fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       gt_event        TYPE slis_t_event        WITH HEADER LINE,
       gt_layout       TYPE slis_layout_alv,
       gt_sort         TYPE slis_t_sortinfo_alv WITH HEADER LINE.

DATA : REF_GRID TYPE REF TO CL_GUI_ALV_GRID.
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  PARAMETERS : p_vbeln TYPE vbak-vbeln.
SELECTION-SCREEN : END OF BLOCK b1.

START-OF-SELECTION.
PERFORM GET_DATA.


FORM get_data .
  refresh : lt_updated,lt_vbap,lt_final_out.
  IF P_VBELN IS NOT INITIAL.
   SELECT vbeln FROM vbak INTO var1 WHERE vbeln = p_vbeln.
        ENDSELECT.
*        break primus.
        IF VAR1 IS NOT INITIAL.
SELECT vbeln posnr FROM vbap INTO TABLE lt_vbap
            WHERE vbeln EQ p_vbeln.

          SELECT * FROM zsales_ord_valid INTO TABLE lt_updated
            WHERE vbeln EQ p_vbeln.

          IF lt_vbap IS NOT INITIAL.
            LOOP AT lt_vbap INTO ls_vbap.
              READ TABLE lt_updated INTO ls_updated WITH KEY vbeln = ls_vbap-vbeln
                                                             posnr = ls_vbap-posnr.
              IF sy-subrc = 0."  AND lS_UPDATED-STATUS is NOT INITIAL .

                ls_final_out-vbeln  = ls_updated-vbeln.
*
                CLEAR: lv_lines, wa_ofm_no.
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

                READ TABLE lv_lines INTO wa_ofm_no INDEX 1.

                IF lv_lines IS NOT INITIAL.
                  LOOP AT lv_lines INTO wa_ofm_no.
                    IF wa_ofm_no-tdline IS NOT INITIAL.
                      CLEAR wa_text.
                      wa_text = wa_ofm_no-tdline(20).     "ofm sr no
                      TRANSLATE wa_text TO UPPER CASE .
                      ls_final_out-ofm_no         = wa_text.
                    ENDIF.
                  ENDLOOP.
                ENDIF.

                ls_final_out-status = ls_updated-status.
                ls_final_out-lvbeln = ls_updated-lvbeln.
                ls_final_out-ernam  = ls_updated-ernam.
                ls_final_out-zabdat = ls_updated-zabdat.

                CLEAR :v_ofm_no.
                if lv_fresh = 'F'.
                clear ls_final_out-chk_box.
                endif.
              ELSE.

                ls_final_out-vbeln = ls_vbap-vbeln.
*                SHIFT ls_vbap-posnr LEFT DELETING LEADING '0'.
**********************************************************************************
*********OFM SR. NO.
                CLEAR: lv_lines, wa_ofm_no.
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

                READ TABLE lv_lines INTO wa_ofm_no INDEX 1.

                IF lv_lines IS NOT INITIAL.
                  LOOP AT lv_lines INTO wa_ofm_no.
                    IF wa_ofm_no-tdline IS NOT INITIAL.
                      CLEAR wa_text.
                      wa_text = wa_ofm_no-tdline(20).     "ofm sr no
                      TRANSLATE wa_text TO UPPER CASE .
                      ls_final_out-ofm_no         = wa_text.
                    ENDIF.
                  ENDLOOP.
                ENDIF.

                ls_final_out-posnr = ls_vbap-posnr.

              ENDIF.

              APPEND ls_final_out TO lt_final_out.
              CLEAR ls_final_out.
              CLEAR v_ofm_no.
            ENDLOOP.
          ENDIF.
perform f_listheader.
PERFORM FCAT.
 PERFORM f_layout.
PERFORM get_display.
        ELSE.
          MESSAGE 'Sales Order Number not exists.' TYPE 'I'.
        ENDIF.
         ELSE.
        MESSAGE 'Insert Sales Order Number.' TYPE 'I'.
      ENDIF.
ENDFORM.

FORM fcat .
  refresh it_fcat.
PERFORM fieldcat USING :    '1'     'VBELN'       'LT_FINAL_OUT'  'Sale Order Number'            ''        '15' '',
                            '2'     'OFM_NO'       'LT_FINAL_OUT'  'OFM Sr No'            ''        '30' '',
                            '3'     'POSNR'       'LT_FINAL_OUT'  'Position No'            ''        '6' '',
                            '4'     'CHK_BOX'       'LT_FINAL_OUT'  'Check Box'            'X'        '1'   'X',
                            '5'     'STATUS'       'LT_FINAL_OUT'  'Validation Status'          ''       '25' '',
                            '6'     'LVBELN'       'LT_FINAL_OUT'  'Linked Sales order'          'X'          '10' '',
                            '7'     'ERNAM'   'LT_FINAL_OUT'  'Last User'          'X'          '12' '',
                            '8'     'ZABDAT'   'LT_FINAL_OUT'  'Date'          'X'          '8' ''.

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
   wa_fcat-CHECKBOX   = p7.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.

FORM get_display .
*  if LT_FINAL_OUT is not INITIAL.
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = sy-repid
      I_CALLBACK_PF_STATUS_SET  = 'SET_PF_STATUS'
      i_callback_user_command = 'USER_CMD'
      i_callback_top_of_page  = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = gt_layout
      it_fieldcat             = it_fcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*      it_sort                 = t_sort[]
it_events               = gt_event[]
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'X'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
* *     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = LT_FINAL_OUT
*   EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
    .
  iF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*  endif.
ENDFORM.

FORM set_pf_status USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'Z_STANDARD_SALES'.

ENDFORM.

FORM USER_CMD USING r_ucomm LIKE sy-ucomm  rs_selfield TYPE slis_selfield..
*  BREAK primusabap.
  save_ok = sy-ucomm.
*  CLEAR ok_code.
*   break primus.
  CASE r_ucomm.
    WHEN 'BACK'.
*      break primus.
***      LEAVE PROGRAM.
      LEAVE TO SCREEN '1000'.
    WHEN 'SAVE'.
*      BREAK primus.
      PERFORM save_entries .
      when 'REFRESH'.
*        break primus.
        lv_fresh = 'F'.
      perform get_data.
*      clear lv_fresh.
  ENDCASE.
ENDFORM.

FORM save_entries .
REFRESH : LT_UPDATED.
  CLEAR :LS_UPDATED,LS_FINAL_OUT,lv_fresh,REF_GRID.
        IF REF_GRID IS INITIAL.
        CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
          IMPORTING
            E_GRID = REF_GRID.
      ENDIF.

      IF NOT REF_GRID IS INITIAL.
        CALL METHOD REF_GRID->CHECK_CHANGED_DATA.
      ENDIF.

      LOOP AT LT_FINAL_OUT INTO LS_FINAL_OUT where chk_box = 'X'.
LS_UPDATED-VBELN  = LS_FINAL_OUT-VBELN .
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    INPUT  = LS_FINAL_OUT-POSNR
  IMPORTING
    OUTPUT = LS_FINAL_OUT-POSNR.

LS_UPDATED-POSNR  = LS_FINAL_OUT-POSNR .
if LS_FINAL_OUT-STATUS is not INITIAL.
LS_UPDATED-STATUS = LS_FINAL_OUT-STATUS.
else.
LS_UPDATED-STATUS = 'Product under Validation'.
endif.
LS_UPDATED-LVBELN = LS_FINAL_OUT-LVBELN.
LS_UPDATED-ERNAM  = sy-uname . .
LS_UPDATED-ZABDAT = sy-datum.
         MODIFY ZSALES_ORD_VALID FROM LS_UPDATED.
    APPEND LS_UPDATED TO LT_UPDATED .
    CLEAR LS_UPDATED.
        endloop.
*        refresh LT_FINAL_OUT-chk_box.
        clear REF_GRID.
ENDFORM.

FORM top_of_page.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = gt_listheader[].

ENDFORM.

FORM f_listheader .
refresh gt_listheader.
DATA : frmdt(10) TYPE c,
         todt(10)  TYPE c,
         v_str     TYPE string,
          line         TYPE string.


  gt_listheader-typ = 'H'.
  gt_listheader-key = ' '.
  gt_listheader-info = 'Sales Order Validation'.
  APPEND gt_listheader.

  DESCRIBE TABLE LT_FINAL_OUT LINES line.
  gt_listheader-typ = 'S'.
  gt_listheader-key  = 'TOTAL NO.OF RECORDS:'(108).
  gt_listheader-info = line.
  APPEND gt_listheader.
*  CLEAR: ls_line.
ENDFORM.

FORM f_layout .
  REFRESH gt_event.
  gt_event-name = slis_ev_top_of_page.
  gt_event-form = 'TOP_OF_PAGE'.
  APPEND gt_event.
  gt_layout-colwidth_optimize = 'X'.
ENDFORM.
