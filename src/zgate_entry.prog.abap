*&---------------------------------------------------------------------*
*& Report ZGATE_ENTRY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgate_entry.

TABLES : mkpf.

DATA:
  tmp_budat TYPE mkpf-budat.
TYPES:
  BEGIN OF t_mat_doc_hdr,
    mblnr TYPE mkpf-mblnr,
    mjahr TYPE mkpf-mjahr,
    bldat TYPE mkpf-bldat,
    budat TYPE mkpf-budat,
    xblnr TYPE mkpf-xblnr,
    frbnr TYPE mkpf-frbnr,
    BKTXT TYPE mkpf-BKTXT,
  END OF t_mat_doc_hdr,
  tt_mat_doc_hdr TYPE STANDARD TABLE OF t_mat_doc_hdr.

TYPES:
  BEGIN OF t_mat_doc,
    mblnr TYPE mseg-mblnr,
    mjahr TYPE mseg-mjahr,
    lifnr TYPE mseg-lifnr,
    BWART TYPE mseg-BWART, "Added by Sarika Thange 10.08.2018
    werks TYPE mseg-werks, "Added by Sarika Thange 10.08.2018
  END OF t_mat_doc,
  tt_mat_doc TYPE STANDARD TABLE OF t_mat_doc.

TYPES:
  BEGIN OF t_vend_info,
    lifnr TYPE lfa1-lifnr,
    name1 TYPE lfa1-name1,
  END OF t_vend_info,
  tt_vend_info TYPE STANDARD TABLE OF t_vend_info.

TYPES:
  BEGIN OF t_final,
    mblnr  TYPE mkpf-mblnr,
    budat  TYPE char11,
    lifnr  TYPE mseg-lifnr,
    name1  TYPE lfa1-name1,
    frbnr  TYPE mkpf-frbnr,
    xblnr  TYPE mkpf-xblnr,
    bldat  TYPE char11,
    WERKS TYPE MSEG-WERKS,"ADDED BY JYOTI MAHAJAN
    ref_dt TYPE char11,
    ref_time  TYPE char10,"ADDED BY JYOTI MAHAJAN
  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.

DATA:
  gt_final TYPE tt_final.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS: so_budat FOR tmp_budat,
                so_frbnr FOR mkpf-frbnr.                            " add subodh 20 feb 2018
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE abc .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

START-OF-SELECTION.

  PERFORM getdata.
  PERFORM display.
*&---------------------------------------------------------------------*
*&      Form  GETDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM getdata .
  DATA:
    lt_mat_doc_hdr TYPE tt_mat_doc_hdr,
    ls_mat_doc_hdr TYPE t_mat_doc_hdr,
    lt_mat_doc     TYPE tt_mat_doc,
    ls_mat_doc     TYPE t_mat_doc,
    lt_vend_info   TYPE tt_vend_info,
    ls_vend_info   TYPE t_vend_info,
    ls_final       TYPE t_final.

  SELECT mblnr
         mjahr
         bldat
         budat
         xblnr
         frbnr
         BKTXT
    FROM mkpf
    INTO TABLE lt_mat_doc_hdr
    WHERE budat IN so_budat
    AND   frbnr IN so_frbnr                               " add subodh 20 feb 2018
    AND  vgart in ('WE','WA'). "Added by Sarika Thange 10.08.2018
*    and vgart = 'WA'.

  IF NOT lt_mat_doc_hdr IS INITIAL.
    SELECT mblnr
           mjahr
           lifnr
           BWART
           WERKS
      FROM mseg
      INTO TABLE lt_mat_doc
      FOR ALL ENTRIES IN lt_mat_doc_hdr
      WHERE mblnr = lt_mat_doc_hdr-mblnr
      AND   mjahr = lt_mat_doc_hdr-mjahr
      AND BWART IN ( '101' ,'543','102','161','162','544','542' ) "Added by Sarika Thange 10.08.2018
      AND WERKS = 'PL01'."ADDED BY MD

    SELECT lifnr
           name1
      FROM lfa1
      INTO TABLE lt_vend_info
      FOR ALL ENTRIES IN lt_mat_doc
      WHERE lifnr = lt_mat_doc-lifnr.

  ENDIF.

  LOOP AT lt_mat_doc_hdr INTO ls_mat_doc_hdr.

    READ TABLE lt_mat_doc INTO ls_mat_doc WITH KEY mblnr = ls_mat_doc_hdr-mblnr
                                                   mjahr = ls_mat_doc_hdr-mjahr.
    LS_FINAL-WERKS = ls_mat_doc-WERKS.
    if ls_mat_doc_hdr-mblnr eq ls_mat_doc-mblnr.
    ls_final-mblnr = ls_mat_doc_hdr-mblnr.
    ELSE.
      CONTINUE.
    ENDIF.
    IF ls_mat_doc-BWART EQ '542'. "Added By Sarika Thange 16.08.2018
      ls_final-frbnr = ls_mat_doc_hdr-BKTXT.

    ELSE.
         ls_final-frbnr = ls_mat_doc_hdr-frbnr.
    ENDIF.
**Ended By Sarika T. 16.08.2018
    ls_final-xblnr = ls_mat_doc_hdr-xblnr.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_mat_doc_hdr-bldat
      IMPORTING
        output = ls_final-bldat.
    CONCATENATE ls_final-bldat+0(2) ls_final-bldat+2(3) ls_final-bldat+5(4)
                   INTO ls_final-bldat SEPARATED BY '-'.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_mat_doc_hdr-budat
      IMPORTING
        output = ls_final-budat.
    CONCATENATE ls_final-budat+0(2) ls_final-budat+2(3) ls_final-budat+5(4)
                   INTO ls_final-budat SEPARATED BY '-'.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_final-ref_dt.
    CONCATENATE ls_final-ref_dt+0(2) ls_final-ref_dt+2(3) ls_final-ref_dt+5(4)
                   INTO ls_final-ref_dt SEPARATED BY '-'.

    READ TABLE lt_mat_doc INTO ls_mat_doc WITH KEY mblnr = ls_mat_doc_hdr-mblnr
                                                   mjahr = ls_mat_doc_hdr-mjahr.
    ls_final-lifnr = ls_mat_doc-lifnr.
    READ TABLE lt_vend_info INTO ls_vend_info WITH KEY lifnr = ls_mat_doc-lifnr.
    IF sy-subrc IS INITIAL.
      ls_final-name1 = ls_vend_info-name1.
    ENDIF.

    ls_final-ref_time = sy-uzeit.
    CONCATENATE ls_final-ref_time+0(2) ':' ls_final-ref_time+2(2)  INTO ls_final-ref_time.

IF ls_final-werks = 'PL01'.
   APPEND ls_final TO gt_final.
ENDIF.

    CLEAR:
      ls_final,ls_mat_doc_hdr,ls_mat_doc,ls_vend_info.


  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .
  DATA:
    lt_fieldcat     TYPE slis_t_fieldcat_alv,
    ls_alv_layout   TYPE slis_layout_alv,
    l_callback_prog TYPE sy-repid.

  l_callback_prog = sy-repid.

  PERFORM prepare_display CHANGING lt_fieldcat.
  CLEAR ls_alv_layout.
  ls_alv_layout-zebra = 'X'.
  ls_alv_layout-colwidth_optimize = 'X'.

*DELETE GT_FINAL WHERE WERKS NE 'PL01'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = l_callback_prog
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
      is_layout               = ls_alv_layout
      it_fieldcat             = lt_fieldcat
    TABLES
      t_outtab                = gt_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
BREAK PRIMUS.
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
      i_tab_sap_data       = gt_final
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
  lv_file = 'ZGate.TXT'.

  CONCATENATE p_folder '/' lv_file
      INTO lv_fullfile.

  WRITE: / 'ZGateEntry Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_291 TYPE string.
DATA lv_crlf_291 TYPE string.
lv_crlf_291 = cl_abap_char_utilities=>cr_lf.
lv_string_291 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_291 lv_crlf_291 wa_csv INTO lv_string_291.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
*TRANSFER lv_string_778 TO lv_fullfile.
TRANSFER lv_string_291 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Material Doc.No.'
              'Material Doc.Dt.'
              'Vendor Code'
              'Vendor Name'
              'Gate Entry No.'
              'Challan No.'
              'Challan Date'
              'Plant'
              'File Create Dt.'
             'Refreshable Time'
      INTO pd_csv
      SEPARATED BY l_field_seperator.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM prepare_display  CHANGING ct_fieldcat TYPE slis_t_fieldcat_alv.
  DATA:
    gv_pos      TYPE i,
    ls_fieldcat TYPE slis_fieldcat_alv.

  REFRESH ct_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MBLNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Material Doc.No.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BUDAT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Material Doc.Dt.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LIFNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Vendor Code'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NAME1'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Vendor Name'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FRBNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Gate Entry No.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'XBLNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Challan No.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BLDAT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Challan Dt.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

   gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'WERKS'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Plant'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'REF_DT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'File Create Dt.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
ENDFORM.
