*&---------------------------------------------------------------------*
*& Report ZMATERIAL_CHANGE_MAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBOM_STATUS_REPORT.


TABLES: cdhdr, cdpos,mara.

TYPES: BEGIN OF ty_cdpos,
         objectclas TYPE cdpos-objectclas,
         objectid   TYPE cdpos-objectid,
         changenr   TYPE cdpos-changenr,
         tabname    TYPE cdpos-tabname,
         tabkey     TYPE cdpos-tabkey,
         fname      TYPE cdpos-fname,
         chngind    TYPE cdpos-chngind,
         text_case  TYPE cdpos-text_case,
         unit_old   TYPE cdpos-unit_old,
         unit_new   TYPE cdpos-unit_new,
         cuky_old   TYPE cdpos-cuky_old,
         cuky_new   TYPE cdpos-cuky_new,
         value_new  TYPE cdpos-value_new,
         value_old  TYPE cdpos-value_old,
       END OF ty_cdpos,


       BEGIN OF ty_mara,
        matnr TYPE mara-matnr,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
       END OF ty_mara,

       BEGIN OF ty_final,
        matnr      TYPE mara-matnr,
         value_new TYPE cdpos-value_new,
        value_old  TYPE cdpos-value_old,
        username   TYPE cdhdr-username,
        udate      TYPE cdhdr-udate,
        utime      TYPE cdhdr-utime,
        tcode      TYPE cdhdr-tcode,
       END OF ty_final,

       BEGIN OF ty_down,
         matnr      TYPE char20,
         value_new TYPE char100,
         value_old  TYPE char100,
         username   TYPE char20,
         udate      TYPE char11,
         utime      TYPE char11,
         tcode      TYPE char20,
         ref        TYPE char11,
         time       TYPE char11,
       END OF ty_down.
DATA :
       wa_cdhdr TYPE          cdhdr,

       it_cdpos TYPE TABLE OF ty_cdpos,
       wa_cdpos TYPE          ty_cdpos,

       lt_cdpos TYPE TABLE OF ty_cdpos,
       ls_cdpos TYPE          ty_cdpos,

       it_mara  TYPE TABLE OF ty_mara,
       wa_mara  TYPE          ty_mara,

       it_final TYPE TABLE OF ty_final,
       wa_final TYPE          ty_final,

       it_down TYPE TABLE OF ty_down,
       wa_down TYPE          ty_down.


 DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA: i_sort             TYPE slis_t_sortinfo_alv, " SORT
      gt_events          TYPE slis_t_event,        " EVENTS
      i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
      wa_layout          TYPE  slis_layout_alv..            " LAYOUT WORKAREA
DATA t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_matnr FOR cdpos-objectid.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'."India'."India'."temp'."'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-006.
SELECTION-SCREEN END OF LINE.


START-OF-SELECTION.

  PERFORM get_data.
  PERFORM sort_data.
  PERFORM det_fcat.
  PERFORM get_display.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
*  break primus.
SELECT objectclas
       objectid
       changenr
       tabname
       tabkey
       fname
       chngind
       text_case
       unit_old
       unit_new
       cuky_old
       cuky_new
       value_new
       value_old FROM cdpos INTO TABLE lt_cdpos
*       WHERE objectid = s_matnr
         WHERE tabname = 'MARA'
         AND fname   = 'NORMT'.
*         AND   value_new = ' '
*         AND value_old NE ' '.

*IF lt_cdpos IS NOT INITIAL.
*SELECT matnr
*       mtart
*       matkl FROM mara INTO TABLE it_mara
*       FOR ALL ENTRIES IN lt_cdpos
*       WHERE matnr = lt_cdpos-objectid+0(18).
*
*
*ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SORT_DATA .
*LOOP AT it_mara INTO wa_mara.
*  wa_final-matnr = wa_mara-matnr.
*BREAK primus.
loop at lt_cdpos INTO ls_cdpos.
  wa_final-matnr = ls_cdpos-objectid.

*SELECT objectclas
*       objectid
*       changenr
*       tabname
*       tabkey
*       fname
*       chngind
*       text_case
*       unit_old
*       unit_new
*       cuky_old
*       cuky_new
*       value_new
*       value_old FROM cdpos INTO TABLE it_cdpos
*       WHERE objectid = wa_final-matnr
*         AND tabname = 'MARA'
*         AND fname   = 'NORMT'.
**         AND value_new = ' '
*         AND value_old NE ' '.


*LOOP AT it_cdpos INTO wa_cdpos WHERE objectid = wa_final-matnr.
*SORT it_cdpos DESCENDING by  changenr.

*READ TABLE it_cdpos INTO wa_cdpos INDEX 1.
IF sy-subrc = 0.
  wa_final-value_old = ls_cdpos-value_old.
  wa_final-value_new = ls_cdpos-value_new.
ENDIF.

SELECT SINGLE * FROM cdhdr INTO wa_cdhdr WHERE changenr = ls_cdpos-changenr.
 IF sy-subrc = 0.
   wa_final-username  = wa_cdhdr-username.
   wa_final-udate     = wa_cdhdr-udate   .
   wa_final-utime     = wa_cdhdr-utime   .
   wa_final-tcode     = wa_cdhdr-tcode   .
 ENDIF.

APPEND wa_final TO it_final.
CLEAR :wa_final,wa_cdhdr,wa_cdpos.
REFRESH it_cdpos.

ENDLOOP.

IF p_down = 'X'.
  LOOP AT it_final INTO wa_final.
   wa_down-matnr       = wa_final-matnr     .
   wa_down-value_new       = wa_final-value_new      .
   wa_down-value_old   = wa_final-value_old .
   wa_down-username    = wa_final-username  .
   wa_down-udate       = wa_final-udate     .

   wa_down-tcode       = wa_final-tcode     .
     CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = wa_down-ref.

      CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                      INTO wa_down-ref SEPARATED BY '-'.


IF wa_final-udate IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = wa_final-udate
        IMPORTING
          OUTPUT = wa_down-udate.

      CONCATENATE wa_down-udate+0(2) wa_down-udate+2(3) wa_down-udate+5(4)
                      INTO wa_down-udate SEPARATED BY '-'.
ENDIF.
IF wa_final-utime IS NOT INITIAL.
CONCATENATE wa_final-utime+0(2) wa_final-utime+2(2) wa_final-utime+4(2)  INTO wa_down-utime SEPARATED BY ':'.
ENDIF.

CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO wa_down-time SEPARATED BY ':'.

APPEND wa_down TO it_down.
CLEAR wa_down.
ENDLOOP.


ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DET_FCAT .
PERFORM fcat USING :
                         '1'  'MATNR'         'IT_FINAL'  'Material.No.'                                     '18' ,
                         '2'  'VALUE_NEW'     'IT_FINAL'  'New Value'                                     '18' ,
                         '3'  'VALUE_OLD'     'IT_FINAL'  'Old Value'                                     '18' ,
                         '4'  'USERNAME'      'IT_FINAL'  'Changed By'                                     '18' ,
                         '5'  'UDATE'         'IT_FINAL'  'Changed On'                                     '18' ,
                         '6'  'UTIME'         'IT_FINAL'  'Change Time'                                     '18' ,
                         '7'  'TCODE'         'IT_FINAL'  'T-code'                                     '18' .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0439   text
*      -->P_0440   text
*      -->P_0441   text
*      -->P_0442   text
*      -->P_0443   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*  wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DISPLAY .
 CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_CMD'
      i_callback_top_of_page  = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = wa_layout
      it_fieldcat             = it_fcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
      it_sort                 = t_sort[]
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
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
IF p_down = 'X'.

    PERFORM download.

ENDIF.
ENDFORM.


FORM top-of-page.
*ALV HEADER DECLARATIONS
  DATA: lt_header     TYPE slis_t_listheader,
        ls_header     TYPE slis_listheader,
        lt_line       LIKE ls_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

* TITLE
  ls_header-typ  = 'H'.
  ls_header-info = 'Material Change'.
  APPEND ls_header TO lt_header.
  CLEAR ls_header.

* DATE
  ls_header-typ  = 'S'.
  ls_header-key  = 'RUN DATE :'.
  CONCATENATE ls_header-info sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum(4) INTO ls_header-info.
  APPEND ls_header TO lt_header.
  CLEAR: ls_header.

*TIME
  ls_header-typ  = 'S'.
  ls_header-key  = 'RUN TIME :'.
  CONCATENATE ls_header-info sy-timlo(2) '.' sy-timlo+2(2) '.' sy-timlo+4(2) INTO ls_header-info.
  APPEND ls_header TO lt_header.
  CLEAR: ls_header.

* TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE it_final LINES ld_lines.
  ld_linesc = ld_lines.
  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' ld_linesc
     INTO lt_line SEPARATED BY space.


  ls_header-typ  = 'A'.
  ls_header-info = lt_line.
  APPEND ls_header TO lt_header.
  CLEAR: ls_header, lt_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.
ENDFORM.                    " TOP-OF-PAG
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD .
TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
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

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


    lv_file = 'ZBOM_STATUS.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZBOM_STATUS REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_465 TYPE string.
DATA lv_crlf_465 TYPE string.
lv_crlf_465 = cl_abap_char_utilities=>cr_lf.
lv_string_465 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_465 lv_crlf_465 wa_csv INTO lv_string_465.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1323 TO lv_fullfile.
TRANSFER lv_string_465 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*********************************************SQL UPLOAD FILE *****************************************
CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
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

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


    lv_file = 'ZBOM_STATUS.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZBOM_STATUS REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_502 TYPE string.
DATA lv_crlf_502 TYPE string.
lv_crlf_502 = cl_abap_char_utilities=>cr_lf.
lv_string_502 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_502 lv_crlf_502 wa_csv INTO lv_string_502.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1323 TO lv_fullfile.
TRANSFER lv_string_502 TO lv_fullfile.
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
CONCATENATE 'Material.No.'
            'New Value'
            'Old Value'
            'Changed By'
            'Changed On'
            'Change Time'
            'T-code'
            'Refresh Date'
            'Refresh Time'
              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.
