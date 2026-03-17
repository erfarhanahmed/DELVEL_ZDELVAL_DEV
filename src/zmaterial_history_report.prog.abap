*&---------------------------------------------------------------------*
*& Report ZMATERIAL_HISTORY_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMATERIAL_HISTORY_REPORT.

TABLES: MARc.


TYPES: BEGIN OF ty_marc,
       matnr TYPE marc-matnr,
       werks TYPE marc-werks,
       END OF ty_marc,

       BEGIN OF ty_vbap,
       vbeln TYPE vbap-vbeln,
       posnr TYPE vbap-posnr,
       matnr TYPE vbap-matnr,
       werks TYPE vbap-werks,
       END OF ty_vbap,

       BEGIN OF ty_ekpo,
       ebeln TYPE ekpo-ebeln,
       ebelp TYPE ekpo-ebelp,
       matnr TYPE ekpo-matnr,
       werks TYPE ekpo-werks,
       END OF ty_ekpo,

       BEGIN OF ty_afpo,
       aufnr TYPE afpo-aufnr,
       posnr TYPE afpo-posnr,
       matnr TYPE afpo-matnr,
       pwerk TYPE afpo-pwerk,
       loekz TYPE aufk-loekz,
       END OF ty_afpo,

       BEGIN OF ty_final,
       matnr TYPE char20,
       werks TYPE char15,
       po    TYPE char10,
       so    TYPE char10,
       prod  TYPE char10,
       ref   TYPE char15,
       END OF ty_final.





DATA: it_marc TYPE TABLE OF ty_marc,
      wa_marc TYPE          ty_marc,

      it_ekpo TYPE TABLE OF ty_ekpo,
      wa_ekpo TYPE          ekpo,

      it_vbap TYPE TABLE OF ty_vbap,
      wa_vbap TYPE          vbap,

      it_afpo TYPE TABLE OF ty_afpo,
      wa_afpo TYPE          afpo.
*      wa_afpo TYPE          ty_afpo.

DATA: it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final.


DATA: it_fcat type slis_t_fieldcat_alv,
      wa_fcat like line of it_fcat,

      fs_layout TYPE slis_layout_alv.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_MAT FOR MARc-MATNR.
  PARAMETERS    : p_werks TYPE marc-werks OBLIGATORY DEFAULT 'PL01'.

SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'."'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.


START-OF-SELECTION.
PERFORM GET_DATA.
PERFORM sort_data.
PERFORM GET_FCAT.
PERFORM fill_layout.
PERFORM GET_DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
BREAK primus.
  SELECT matnr
         werks
         FROM marc INTO TABLE it_marc
         WHERE matnr IN s_mat
          AND  werks = p_werks.


DELETE ADJACENT DUPLICATES FROM it_marc COMPARING matnr.

*IF it_marc IS NOT INITIAL.
*  SELECT vbeln
*         posnr
*         matnr
*         werks FROM vbap INTO TABLE it_vbap
*         FOR ALL ENTRIES IN it_marc
*         WHERE matnr = it_marc-matnr
*           AND werks = it_marc-werks.
*
*  SELECT ebeln
*         ebelp
*         matnr
*         werks FROM ekpo INTO TABLE it_ekpo
*         FOR ALL ENTRIES IN it_marc
*         WHERE matnr = it_marc-matnr
*           AND werks = it_marc-werks.
*
*
*  SELECT aufnr
*         posnr
*         matnr
*         pwerk FROM afpo INTO TABLE it_afpo
*         FOR ALL ENTRIES IN it_marc
*         WHERE matnr = it_marc-matnr
*           AND pwerk = it_marc-werks.
*
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
LOOP AT it_marc INTO wa_marc.

wa_final-matnr = wa_marc-matnr.
wa_final-werks = wa_marc-werks.

CLEAR:wa_ekpo,wa_vbap,wa_afpo.

SELECT SINGLE * FROM ekpo INTO wa_ekpo WHERE matnr = wa_final-matnr AND werks = wa_final-werks.
IF wa_ekpo IS NOT INITIAL.
  wa_final-po = 'YES'.
ELSE.
  wa_final-po = 'NO'.
ENDIF.


SELECT SINGLE * FROM vbap INTO wa_vbap WHERE matnr = wa_final-matnr AND werks = wa_final-werks.
IF wa_vbap IS NOT INITIAL.
  wa_final-so = 'YES'.
ELSE.
  wa_final-so = 'NO'.
ENDIF.

*SELECT SINGLE a~aufnr
*        a~posnr
*        a~matnr
*        a~pwerk
**        b~aufnr
*        b~loekz INTO wa_afpo FROM afpo as a
*        INNER JOIN aufk as b ON a~aufnr = b~aufnr
*        WHERE a~matnr = wa_final-matnr
*          AND a~pwerk = wa_final-werks
*          AND b~loekz ne 'X'.


SELECT SINGLE * FROM afpo INTO wa_afpo WHERE matnr = wa_final-matnr AND pwerk = wa_final-werks.
IF wa_afpo IS NOT INITIAL.
  wa_final-prod = 'YES'.
ELSE.
  wa_final-prod = 'NO'.
ENDIF.

CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = SY-DATUM
   IMPORTING
     OUTPUT        = wa_final-REF
            .

CONCATENATE wa_final-REF+0(2) wa_final-REF+2(3) wa_final-REF+5(4)
                INTO wa_final-REF SEPARATED BY '-'.


APPEND wa_final TO it_final.
CLEAR wa_final.
ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT .
PERFORM FCAT USING : "mara table.
                     '1'  'MATNR'         'IT_FINAL'  'Material No.'             '18' ,
                     '2'  'WERKS'         'IT_FINAL'  'Plant'                    '18',
                     '3'  'PO'            'IT_FINAL'  'Purchase Order'           '18' ,
                     '4'  'SO'            'IT_FINAL'  'Sales Order'              '18' ,
                     '5'  'PROD'          'IT_FINAL'  'Production Order'         '18' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILL_LAYOUT .
  fs_layout-colwidth_optimize = 'X'.
  fs_layout-zebra             = 'X'.
  fs_layout-detail_popup      = 'X'.
  fs_layout-subtotals_text    = 'DR'.
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
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
     I_CALLBACK_PROGRAM                = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
     I_CALLBACK_USER_COMMAND           = 'USER_CMD'
     I_CALLBACK_TOP_OF_PAGE            = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       =
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
     IS_LAYOUT                         = fs_layout
     IT_FIELDCAT                       = it_fcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT                           =
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
      i_save                            = 'X'
*     IS_VARIANT                        =
*     IT_EVENTS                         =
*     IT_EVENT_EXIT                     =
*     IS_PRINT                          =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                          = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS                            = 2
            .
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
      i_tab_sap_data       = it_final
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
  lv_file = 'ZMATERIAL_HISTORY.TXT'.
*BREAK primus.
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZMATERIAL_HISTORY Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_362 TYPE string.
DATA lv_crlf_362 TYPE string.
lv_crlf_362 = cl_abap_char_utilities=>cr_lf.
lv_string_362 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_362 lv_crlf_362 wa_csv INTO lv_string_362.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_396 TO lv_fullfile.
TRANSFER lv_string_362 TO lv_fullfile.
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
FORM CVS_HEADER  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Material No.'
              'Plant'
              'Purchase Order'
              'Sales Order'
              'Production Order'
              'Refresh Date'
              INTO pd_csv
              SEPARATED BY l_field_seperator.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0393   text
*      -->P_0394   text
*      -->P_0395   text
*      -->P_0396   text
*      -->P_0397   text
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

  append wa_fcat to it_fcat.
  CLEAR wa_fcat.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  top-of-page
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top-of-page.

*  ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

*  Title
  wa_header-typ  = 'H'.
  wa_header-info = 'Material History Report'.
  APPEND wa_header TO t_header.
  CLEAR wa_header.



*  Date
  wa_header-typ  = 'S'.
  wa_header-key  = 'Run Date : '.
  CONCATENATE wa_header-info sy-datum+6(2) '.' sy-datum+4(2) '.'
                      sy-datum(4) INTO wa_header-info.
  APPEND wa_header TO t_header.
  CLEAR: wa_header.

*  Time
  wa_header-typ  = 'S'.
  wa_header-key  = 'Run Time: '.
  CONCATENATE wa_header-info sy-timlo(2) ':' sy-timlo+2(2) ':'
                      sy-timlo+4(2) INTO wa_header-info.
  APPEND wa_header TO t_header.
  CLEAR: wa_header.

*   Total No. of Records Selected
  DESCRIBE TABLE it_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. of Records Selected: ' ld_linesc
     INTO t_line SEPARATED BY space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.
ENDFORM.                    " top-of-page
