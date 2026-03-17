*&---------------------------------------------------------------------*
*& Report ZQM_NCR_QUERY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zqm_ncr_query.

TABLES: zqm_ncr_report.

TYPES: BEGIN OF ty_ncr.
    INCLUDE TYPE zqm_ncr_report.
TYPES: name1 TYPE lfa1-name1,
       END OF ty_ncr.

DATA: gt_ncr TYPE TABLE OF ty_ncr.   "zqm_ncr_report.
FIELD-SYMBOLS <fs_ncr> TYPE ty_ncr.

*>>
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_ncrno FOR zqm_ncr_report-ncrno,
                s_ncrdt FOR zqm_ncr_report-ncrdt,
                s_mblnr FOR zqm_ncr_report-mblnr,
                s_mjahr FOR zqm_ncr_report-mjahr,
                s_zeile FOR zqm_ncr_report-zeile,
                s_lifnr FOR zqm_ncr_report-lifnr.
SELECTION-SCREEN : END OF BLOCK b1.

*>>
START-OF-SELECTION.
  SELECT * FROM zqm_ncr_report INTO CORRESPONDING FIELDS OF TABLE gt_ncr
    WHERE ncrno IN s_ncrno
      AND ncrdt IN s_ncrdt
      AND mblnr IN s_mblnr
      AND mjahr IN s_mjahr
      AND zeile IN s_zeile
      AND lifnr IN s_lifnr.

  LOOP AT gt_ncr ASSIGNING <fs_ncr>.
    SELECT SINGLE name1 FROM lfa1 INTO <fs_ncr>-name1
      WHERE lifnr = <fs_ncr>-lifnr.

  ENDLOOP.

  IF sy-subrc = 0.

    PERFORM output_display.

  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  OUTPUT_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM output_display .
  DATA:
    lt_fcat  TYPE slis_t_fieldcat_alv,
    ls_layo  TYPE slis_layout_alv,
    lv_repid TYPE sy-repid.

*  IF NOT gt_output IS INITIAL.

  SET TITLEBAR 'REP01' WITH sy-datum.

  PERFORM set_fcat CHANGING lt_fcat.
  PERFORM set_layo CHANGING ls_layo.

  lv_repid = sy-repid.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = lv_repid
*     i_callback_pf_status_set = 'PF_STATUS_SET'
*     i_callback_user_command  = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE   = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
      is_layout          = ls_layo
      it_fieldcat        = lt_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     it_sort            = lt_sort
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     it_events          = lt_evts
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab           = gt_ncr
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FCAT  text
*----------------------------------------------------------------------*
FORM set_fcat  CHANGING pt_fcat TYPE slis_t_fieldcat_alv.

  DATA: ps_fcat TYPE slis_fieldcat_alv,
        lv_pos  TYPE i.

  FIELD-SYMBOLS <fs_fcat> TYPE slis_fieldcat_alv.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-cprog
*     I_INTERNAL_TABNAME     =
      i_structure_name       = 'ZQM_NCR_REPORT'
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_INCLNAME             =
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    CHANGING
      ct_fieldcat            = pt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  CLEAR ps_fcat.
  ps_fcat-col_pos = 11.
  ps_fcat-fieldname = 'NAME1'.
  ps_fcat-seltext_l = 'Vendor Name'.
  ps_fcat-seltext_m = 'Vendor Name'.
  ps_fcat-seltext_s = 'Vendor Name'.
  ps_fcat-datatype = 'CHAR'.
  ps_fcat-inttype = 'C'.
  ps_fcat-intlen = '000035'.
  ps_fcat-ref_tabname = 'ZQM_NCR_REPORT'.
  ps_fcat-reptext_ddic = 'Name'.
  ps_fcat-ddic_outputlen = '000035'.
  APPEND ps_fcat TO pt_fcat.

  LOOP AT pt_fcat ASSIGNING <fs_fcat>.
    CASE <fs_fcat>-fieldname.
      WHEN 'NCRNO'.
        <fs_fcat>-seltext_l = 'NCR No.'.
        <fs_fcat>-seltext_m = 'NCR No.'.
        <fs_fcat>-seltext_s = 'NCR No.'.
        <fs_fcat>-key = 'X'.
      WHEN 'NCRDT'.
        <fs_fcat>-seltext_l = 'NCR Date'.
        <fs_fcat>-seltext_m = 'NCR Date'.
        <fs_fcat>-seltext_s = 'NCR Date'.
        <fs_fcat>-key = 'X'.
      WHEN 'NCRUS'.
        <fs_fcat>-seltext_l = 'Raised By'.
        <fs_fcat>-seltext_m = 'Raised By'.
        <fs_fcat>-seltext_s = 'Raised By'.
      WHEN 'NCRQT'.
        <fs_fcat>-seltext_l = 'NCR Quantity'.
        <fs_fcat>-seltext_m = 'NCR Quantity'.
        <fs_fcat>-seltext_s = 'NCR Quantity'.
      WHEN 'CAT01'.
        <fs_fcat>-seltext_l = 'NC Detail 1'.
        <fs_fcat>-seltext_m = 'NC Detail 1'.
        <fs_fcat>-seltext_s = 'NC Detail 1'.
        <fs_fcat>-reptext_ddic = 'Detail 1'.
      WHEN 'QTY01'.
        <fs_fcat>-seltext_l = 'NC Qty 1'.
        <fs_fcat>-seltext_m = 'NC Qty 1'.
        <fs_fcat>-seltext_s = 'NC Qty 1'.
      WHEN 'CAT02'.
        <fs_fcat>-seltext_l = 'NC Detail 2'.
        <fs_fcat>-seltext_m = 'NC Detail 2'.
        <fs_fcat>-seltext_s = 'NC Detail 2'.
        <fs_fcat>-reptext_ddic = 'Detail 2'.
      WHEN 'QTY02'.
        <fs_fcat>-seltext_l = 'NC Qty 2'.
        <fs_fcat>-seltext_m = 'NC Qty 2'.
        <fs_fcat>-seltext_s = 'NC Qty 2'.
      WHEN 'CAT03'.
        <fs_fcat>-seltext_l = 'NC Detail 3'.
        <fs_fcat>-seltext_m = 'NC Detail 3'.
        <fs_fcat>-seltext_s = 'NC Detail 3'.
        <fs_fcat>-reptext_ddic = 'Detail 3'.
      WHEN 'QTY03'.
        <fs_fcat>-seltext_l = 'NC Qty 3'.
        <fs_fcat>-seltext_m = 'NC Qty 3'.
        <fs_fcat>-seltext_s = 'NC Qty 3'.
      WHEN 'CAT04'.
        <fs_fcat>-seltext_l = 'NC Detail 4'.
        <fs_fcat>-seltext_m = 'NC Detail 4'.
        <fs_fcat>-seltext_s = 'NC Detail 4'.
        <fs_fcat>-reptext_ddic = 'Detail 4'.
      WHEN 'QTY04'.
        <fs_fcat>-seltext_l = 'NC Qty 4'.
        <fs_fcat>-seltext_m = 'NC Qty 4'.
        <fs_fcat>-seltext_s = 'NC Qty 4'.
      WHEN 'CAT05'.
        <fs_fcat>-seltext_l = 'NC Detail 5'.
        <fs_fcat>-seltext_m = 'NC Detail 5'.
        <fs_fcat>-seltext_s = 'NC Detail 5'.
        <fs_fcat>-reptext_ddic = 'Detail 5'.
      WHEN 'QTY05'.
        <fs_fcat>-seltext_l = 'NC Qty 5'.
        <fs_fcat>-seltext_m = 'NC Qty 5'.
        <fs_fcat>-seltext_s = 'NC Qty 5'.
    ENDCASE.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_LAYO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LS_LAYO  text
*----------------------------------------------------------------------*
FORM set_layo  CHANGING ps_layo TYPE slis_layout_alv.
  ps_layo-zebra  = 'X'.
  ps_layo-colwidth_optimize  = 'X'.

ENDFORM.
