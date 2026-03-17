*&---------------------------------------------------------------------*
*& Report ZINSP_PEND_STOCK_QUALITY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zinsp_pend_stock_quality.

TABLES : mseg, qals, lfa1.

TYPES: BEGIN OF ty_qals,
         prueflos   TYPE qals-prueflos,
         lmengezub  TYPE qals-lmengezub,
         lifnr      TYPE qals-lifnr,
         mblnr      TYPE qals-mblnr,
         matnr      TYPE qals-matnr,
         budat      TYPE qals-budat,
         lagortvorg TYPE qals-lagortvorg,
         bwart      TYPE qals-bwart,
         werk       TYPE qals-werk,
         art        TYPE qals-art,
       END OF ty_qals.


TYPES : BEGIN OF ty_mseg,
          mblnr      TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          bwart      TYPE mseg-bwart,
          matnr      TYPE mseg-matnr,
          werks      TYPE mseg-werks,
          lgort      TYPE mseg-lgort,
          insmk      TYPE mseg-insmk,
          lifnr      TYPE mseg-lifnr,
          budat_mkpf TYPE mseg-budat_mkpf,
          ablad      TYPE mseg-ablad,

        END OF ty_mseg.

TYPES : BEGIN OF ty_final,
          mblnr      TYPE mseg-mblnr,
          matnr      TYPE mseg-matnr,
          mattxt     TYPE char250,
          lifnr      TYPE mseg-lifnr,
          name1      TYPE lfa1-name1,
          ablad      TYPE mseg-ablad,
          lmengezub  TYPE qals-lmengezub,
          xblnr      TYPE mkpf-xblnr,
          budat_mkpf TYPE mseg-budat_mkpf,
          prueflos   TYPE qals-prueflos,
          lgort      TYPE mseg-lgort,
          ART        TYPE QALS-ART,
        END OF ty_final.

TYPES : BEGIN OF ty_down,
          mblnr      TYPE string,
          matnr      TYPE string,
          mattxt     TYPE char250,
          lifnr      TYPE string,
          name1      TYPE string,
          ablad      TYPE string,
          lmengezub  TYPE string,
          xblnr      TYPE string,
          budat_mkpf TYPE char11,
          prueflos   TYPE string,
          lgort      TYPE string,
          art        type string,
          ref_date   TYPE string,
          ref_time   TYPE string,
        END OF ty_down.


DATA : it_qals  TYPE TABLE OF ty_qals,
       wa_qals  TYPE ty_qals,

       it_mseg  TYPE TABLE OF ty_mseg,
       wa_mseg  TYPE ty_mseg,

       it_mbew  TYPE TABLE OF mbew,
       wa_mbew  TYPE mbew,

       it_lfa1  TYPE TABLE OF lfa1,
       wa_lfa1  TYPE lfa1,

       it_mkpf  TYPE TABLE OF mkpf,
       wa_mkpf  TYPE mkpf,

       it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE ty_down,

       it_fcat  TYPE slis_t_fieldcat_alv,
       wa_fcat  TYPE LINE OF slis_t_fieldcat_alv.

DATA : i_sort             TYPE slis_t_sortinfo_alv, " SORT
       gt_events          TYPE slis_t_event,        " EVENTS
       i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
       wa_layout          TYPE  slis_layout_alv...


DATA : lv_name   TYPE thead-tdname,
       lv_lines  TYPE STANDARD TABLE OF tline,
       ls_mattxt TYPE tline.

***********************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS:
  c_formname_top_of_page   TYPE slis_formname
                                   VALUE 'TOP_OF_PAGE',
  c_formname_pf_status_set TYPE slis_formname
                                 VALUE 'PF_STATUS_SET',
  c_s                      TYPE c VALUE 'S',
  c_h                      TYPE c VALUE 'H'.



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
PARAMETERS : p_werks TYPE mseg-werks OBLIGATORY DEFAULT 'PL01' MODIF ID bu.
SELECT-OPTIONS   :  s_budat FOR mseg-budat_mkpf,
                    s_matnr FOR mseg-matnr.
.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'."India'."India'."temp' .         "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE TEXT-005.
SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
SELECTION-SCREEN END OF BLOCK b6.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM process_for_output.
  PERFORM alv_for_output.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT prueflos
         lmengezub
         lifnr
         mblnr
         matnr
         budat
         lagortvorg
         bwart
         werk
         art
         FROM qals
         INTO  TABLE it_qals
         WHERE matnr  IN s_matnr
         AND budat IN s_budat
         AND werk = p_werks
*         and stat35 = ''
         AND lmengezub <> ' '
         AND lagortvorg <> ' '
         AND art <> '02' .




  IF it_qals IS NOT INITIAL.

    SELECT *
      FROM mkpf
      INTO TABLE it_mkpf
      FOR ALL ENTRIES IN it_qals
      WHERE mblnr = it_qals-mblnr .

    SELECT * FROM lfa1
      INTO TABLE it_lfa1
      FOR ALL ENTRIES IN it_qals
      WHERE lifnr = it_qals-lifnr.


    SELECT mblnr
           mjahr
           bwart
           matnr
           werks
           lgort
           insmk
           lifnr
           budat_mkpf
           ablad
          FROM mseg
          INTO TABLE it_mseg
          FOR ALL ENTRIES IN it_qals
          WHERE mblnr = it_qals-mblnr
         AND insmk NE ' '.

    SELECT * FROM
      mbew
      INTO TABLE it_mbew
        FOR ALL ENTRIES IN it_qals
        WHERE matnr = it_qals-matnr.

  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*

FORM process_for_output .

  LOOP AT it_qals INTO DATA(wa_qals).

    wa_final-mblnr      = wa_qals-mblnr  .
*    wa_final-mjahr      = wa_data-mjahr   .
*    wa_final-bwart      = wa_qals-bwart    .
    wa_final-matnr      = wa_qals-matnr  .
    wa_final-ART      = wa_qals-ART  .


***    *Material text
    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_final-matnr.
    IF lv_name IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_name
          object                  = 'MATERIAL'
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ENDIF.
    READ TABLE lv_lines INTO ls_mattxt INDEX 1.
    wa_final-mattxt = ls_mattxt-tdline.

*    wa_final-werks      = wa_qals-werk .
    wa_final-lgort      = wa_qals-lagortvorg  .
*    wa_final-insmk      = wa_data-insmk  .
    wa_final-lifnr      = wa_qals-lifnr  .
    wa_final-budat_mkpf = wa_qals-budat.
    wa_final-prueflos   = wa_qals-prueflos  .
    wa_final-lmengezub  = wa_qals-lmengezub .

    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_final-lifnr.

    IF sy-subrc IS INITIAL.
      wa_final-name1 = wa_lfa1-name1.
    ENDIF.

    READ TABLE it_mkpf INTO wa_mkpf WITH KEY mblnr = wa_final-mblnr.

    IF sy-subrc IS INITIAL.
      wa_final-xblnr = wa_mkpf-xblnr.
    ENDIF.


    READ TABLE it_mseg INTO wa_mseg WITH KEY mblnr = wa_final-mblnr.

    IF sy-subrc IS INITIAL.
      wa_final-ablad = wa_mseg-ablad.
    ENDIF.

    IF wa_final-ablad IS INITIAL.
      READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_final-matnr.
      IF sy-subrc IS INITIAL.
        IF wa_mbew-vprsv = 'S'.
          wa_final-ablad = wa_mbew-stprs.
        ELSEIF wa_mbew-vprsv = 'V'.
          wa_final-ablad = wa_mbew-verpr.
        ENDIF..
      ENDIF.

    ENDIF.



    APPEND wa_final TO it_final.
    CLEAR wa_final .

  ENDLOOP.

  IF p_down = 'X'.

    LOOP AT it_final INTO wa_final.

      wa_down-mblnr      = wa_final-mblnr  .
      wa_down-matnr      = wa_final-matnr  .
      wa_down-mattxt     = wa_final-mattxt.
      wa_down-lgort      = wa_final-lgort.
      wa_down-lifnr      = wa_final-lifnr  .
      wa_down-name1      = wa_final-name1  .
      wa_down-prueflos   = wa_final-prueflos  .
      wa_down-lmengezub  = wa_final-lmengezub .
      wa_down-xblnr  = wa_final-xblnr.
      wa_down-ablad  = wa_final-ablad.
      wa_down-art = wa_final-art.

      IF wa_final-budat_mkpf IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-budat_mkpf
          IMPORTING
            output = wa_down-budat_mkpf.
      ENDIF.

      CONCATENATE wa_down-budat_mkpf+0(2) wa_down-budat_mkpf+2(3) wa_down-budat_mkpf+5(4)
                       INTO wa_down-budat_mkpf SEPARATED BY '-'.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref_date.

      CONCATENATE wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
                      INTO wa_down-ref_date SEPARATED BY '-'.

      wa_down-ref_time = sy-uzeit.
      CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.

      APPEND wa_down TO it_down.
      CLEAR :wa_down, wa_final.


    ENDLOOP.

  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
FORM alv_for_output .

  PERFORM stp3_eventtab_build   CHANGING gt_events[].
  PERFORM comment_build         CHANGING i_list_top_of_page[].
  PERFORM top_of_page.
  PERFORM layout_build          CHANGING wa_layout.

  PERFORM build_fieldcat USING 'MBLNR'          'X' '1'   'Material Doc No'              '15'     '' .
  PERFORM build_fieldcat USING 'MATNR'          'X' '2'   'Material No'                  '18'     '' .
  PERFORM build_fieldcat USING 'MATTXT'         'X' '3'   'Material Description'         '15'     '' .
  PERFORM build_fieldcat USING 'LIFNR'          'X' '4'   'Vendor No'                    '15'     '' .
  PERFORM build_fieldcat USING 'NAME1'          'X' '5'   'Vendor Description'           '15'     '' .
  PERFORM build_fieldcat USING 'ABLAD'          'X' '6'   'Rate'                         '15'     '' .
  PERFORM build_fieldcat USING 'LMENGEZUB'      'X' '7'   'Pending Quantity'             '15'     '' .
  PERFORM build_fieldcat USING 'XBLNR'          'X' '8'   'Invoice No'                   '15'     '' .
  PERFORM build_fieldcat USING 'BUDAT_MKPF'     'X' '9'   'Posting Date'                 '15'     '' .
  PERFORM build_fieldcat USING 'PRUEFLOS'       'X' '10'  'Inspection lot'               '15'     '' .
  PERFORM build_fieldcat USING 'LGORT'          'X' '11'  'Storage Location'             '15'     '' .
  PERFORM build_fieldcat USING 'ART'            'X' '12'  'Inspection Type'             '15'     '' .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
*     i_structure_name         = 'OUTPUT'
      is_layout                = wa_layout
      it_fieldcat              = it_fcat
      it_sort                  = i_sort
      i_callback_pf_status_set = 'PF_STATUS_SET'
*     i_callback_user_command  = 'USER_COMMAND'
*     i_default                = 'A'
*     i_save                   = 'A'
      i_save                   = 'X'
      it_events                = gt_events[]
    TABLES
      t_outtab                 = it_final
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF p_down = 'X'.

    PERFORM download.
  ENDIF.


ENDFORM.
FORM pf_status_set USING extab TYPE slis_t_extab.
  SET PF-STATUS 'STANDARD'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*

FORM stp3_eventtab_build  CHANGING p_gt_events TYPE slis_t_event.

  DATA: lf_event TYPE slis_alv_event. "WORK AREA

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = p_gt_events
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  MOVE c_formname_top_of_page TO lf_event-form.
  MODIFY p_gt_events  FROM  lf_event INDEX 3 TRANSPORTING form."TO P_I_EVENTS .

ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
FORM comment_build CHANGING i_list_top_of_page TYPE slis_t_listheader.
  DATA: lf_line       TYPE slis_listheader, "WORK AREA
        ld_lines      TYPE i,
        t_line        LIKE lf_line-info,
        ld_linesc(10) TYPE c.
*--LIST HEADING -  TYPE H
  CLEAR lf_line.
  lf_line-typ  = c_h.
  lf_line-info =  ''(042).
  APPEND lf_line TO i_list_top_of_page.
*--HEAD INFO: TYPE S
  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-key  = TEXT-043.
  lf_line-info = sy-datum.
  WRITE sy-datum TO lf_line-info USING EDIT MASK '__.__.____'.
  APPEND lf_line TO i_list_top_of_page.
*   Total No. of Records Selected
  DESCRIBE TABLE it_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. of Records Selected: ' ld_linesc
     INTO t_line SEPARATED BY space.

  lf_line-typ  = 'A'.
  lf_line-info = t_line.

  APPEND lf_line TO i_list_top_of_page.



ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM top_of_page .

*** THIS FM IS USED TO CREATE ALV HEADER
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = i_list_top_of_page[]. "INTERNAL TABLE WITH


ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM layout_build  CHANGING p_wa_layout TYPE slis_layout_alv.

*        IT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  wa_layout-zebra          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
  p_wa_layout-zebra          = 'X'.
  p_wa_layout-no_colhead        = ' '.
*  WA_LAYOUT-BOX_FIELDNAME     = 'BOX'.
*  WA_LAYOUT-BOX_TABNAME       = 'IT_FINAL_ALV'.


ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM build_fieldcat  USING    v1  v2 v3 v4 v5 v6.
  wa_fcat-fieldname   = v1 ." 'VBELN'.
  wa_fcat-tabname     = 'IT_FINAL'.  "'IT_FINAL_NEW'.
  wa_fcat-key         =  v2 ."  'X'.
  wa_fcat-seltext_l   =  v4.
  wa_fcat-outputlen   =  v5." 20.
  wa_fcat-col_pos     =  v3.
  wa_fcat-edit     =  v6.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.                    " BUILD_FIELDCAT
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

  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

  lv_file = 'ZPEND_QA.TXT'.

  CONCATENATE p_folder '/' lv_file
     INTO lv_fullfile.

  WRITE: / 'ZPEND_QA.TXT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_578 TYPE string.
DATA lv_crlf_578 TYPE string.
lv_crlf_578 = cl_abap_char_utilities=>cr_lf.
lv_string_578 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_578 lv_crlf_578 wa_csv INTO lv_string_578.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_473 TO lv_fullfile.
TRANSFER lv_string_578 TO lv_fullfile.
    CLOSE DATASET lv_fullfile.
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
FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE  'Material Doc No'
               'Material No'
               'Material Description'
               'Vendor No'
               'Vendor Description'
               'Rate'
               'Pending Quantity'
               'Invoice No'
               'Posting Date'
               'Inspection lot'
               'Storage Location'
               'Inspection Type'
               'Refeshable Date'
               'Refreshable Time'
               INTO p_hd_csv
              SEPARATED BY l_field_seperator.
ENDFORM.
