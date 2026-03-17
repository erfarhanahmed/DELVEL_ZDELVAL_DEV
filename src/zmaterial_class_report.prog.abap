*&---------------------------------------------------------------------*
*& Report ZMATERIAL_CLASS_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmaterial_class_report.

TYPE-POOLS:slis.
TABLES:mara.

TYPES: BEGIN OF ty_mara,
         matnr TYPE  mara-matnr,
         ersda TYPE  mara-ersda,
         mtart TYPE  mara-mtart,
         matkl TYPE  mara-matkl,
         extwg TYPE  mara-extwg,
       END OF ty_mara,

       BEGIN OF ty_makt,
         matnr TYPE  makt-matnr,
         maktx TYPE  makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_kssk,
         objek TYPE  kssk-objek,
         clint TYPE  kssk-clint,
       END OF ty_kssk,

       BEGIN OF ty_klah,
         clint TYPE  klah-clint,
         class TYPE  klah-class,
       END OF ty_klah,

       BEGIN OF ty_qmat,
         matnr TYPE  qmat-matnr,
         werks TYPE  qmat-WERKS,
         art   TYPE  qmat-art,
       END OF ty_qmat,

       BEGIN OF ty_material,
*         matnr TYPE  objnum,
         matnr TYPE  char90,
         ersda TYPE  ersda,
         mtart TYPE  mtart,
         matkl TYPE  matkl,
         extwg TYPE  extwg,
       END OF ty_material,



       BEGIN OF ty_final,
         matnr   TYPE  mara-matnr,
         ersda   TYPE  mara-ersda,
         mtart   TYPE  mara-mtart,
         matkl   TYPE  mara-matkl,
         extwg   TYPE  mara-extwg,
         maktx   TYPE  makt-maktx,
         class   TYPE  klah-class,
         art     TYPE  qmat-art,
         insp_01 TYPE qmat-art,
         insp_04 TYPE qmat-art,
         insp_06 TYPE qmat-art,
         insp_08 TYPE qmat-art,
         werks   TYPE qmat-werks,
       END OF ty_final.


TYPES : BEGIN OF ty_down,

          matnr    TYPE  mara-matnr,
          maktx    TYPE  makt-maktx,
          mtart    TYPE  mara-mtart,
          extwg    TYPE  mara-extwg,
          class    TYPE  klah-class,
          insp_01  TYPE qmat-art,
          insp_04  TYPE qmat-art,
          insp_06  TYPE qmat-art,
          insp_08  TYPE qmat-art,
          ref_dat  TYPE char15,                         "Refresh Date
          ref_time TYPE char15,
          werks   TYPE qmat-werks,
        END OF ty_down.


DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.


DATA: it_mara     TYPE TABLE OF ty_mara,
      wa_mara     TYPE          ty_mara,

      it_makt     TYPE TABLE OF ty_makt,
      wa_makt     TYPE          ty_makt,

      it_kssk     TYPE TABLE OF ty_kssk,
      wa_kssk     TYPE          ty_kssk,

      it_klah     TYPE TABLE OF ty_klah,
      wa_klah     TYPE          ty_klah,

      it_qmat     TYPE TABLE OF ty_qmat,
      wa_qmat     TYPE          ty_qmat,

      it_material TYPE TABLE OF ty_material,
      wa_material TYPE          ty_material,

      it_final    TYPE TABLE OF ty_final,
      wa_final    TYPE          ty_final.


DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_fieldcat_alv.

DATA : gv_obj TYPE objnum.

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS :s_date  FOR mara-ersda.
SELECT-OPTIONS :s_mtart FOR mara-mtart.
PARAMETERS     :s_werks LIKE qmat-werks.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.


START-OF-SELECTION.

  PERFORM get_data.
  PERFORM get_fcat.
  PERFORM get_display.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

* BREAK PRIMUS.
  SELECT matnr
         ersda
         mtart
         matkl
         extwg FROM mara INTO TABLE it_mara
         WHERE ersda IN s_date AND mtart In s_mtart.

*APPEND LINES OF IT_MARA TO IT_MATERIAL.


  IF  it_mara IS NOT INITIAL.
    SELECT matnr
           maktx FROM makt INTO TABLE it_makt
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr.

    SELECT matnr
           ersda
           mtart
           matkl
           extwg FROM mara INTO TABLE it_material
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr.

*   SELECT OBJEK
*          CLINT FROM KSSK INTO TABLE IT_KSSK
*          FOR ALL ENTRIES IN IT_MARA
*          WHERE OBJEK = IT_MARA-MATNR.

    SELECT matnr
           werks
           art FROM qmat INTO TABLE it_qmat
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr AND werks = s_werks..

  ENDIF.

  IF it_material IS NOT INITIAL.

    SELECT objek
           clint FROM kssk INTO TABLE it_kssk
           FOR ALL ENTRIES IN it_material
           WHERE objek = it_material-matnr.
  ENDIF.

  IF it_kssk IS NOT INITIAL.
    SELECT clint
           class FROM klah INTO TABLE it_klah
           FOR ALL ENTRIES IN it_kssk
           WHERE clint = it_kssk-clint.
  ENDIF.

  LOOP AT it_mara INTO wa_mara.
    wa_final-matnr = wa_mara-matnr.
    wa_final-mtart = wa_mara-mtart.
    wa_final-matkl = wa_mara-matkl.
    wa_final-extwg = wa_mara-extwg.

*  GV_OBJ = WA_FINAL-MATNR.
    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc = 0.
      wa_final-maktx = wa_makt-maktx.

    ENDIF.

    READ TABLE it_material INTO wa_material WITH KEY matnr = wa_final-matnr.
    READ TABLE it_kssk INTO wa_kssk WITH KEY objek = wa_material-matnr.
*
    READ TABLE it_klah INTO wa_klah WITH KEY clint = wa_kssk-clint.
    IF sy-subrc = 0.
      wa_final-class = wa_klah-class.

    ENDIF.

*READ TABLE IT_QMAT INTO WA_QMAT WITH KEY MATNR = WA_MARA-MATNR.
    LOOP AT it_qmat INTO wa_qmat WHERE matnr = wa_mara-matnr.

      wa_final-werks = wa_qmat-werks.

      CASE wa_qmat-art.
        WHEN '01'.
          wa_final-insp_01 = wa_qmat-art.
        WHEN '04'.
          wa_final-insp_04 = wa_qmat-art.
        WHEN '06'.
          wa_final-insp_06 = wa_qmat-art.
        WHEN '08'.
          wa_final-insp_08 = wa_qmat-art.
      ENDCASE.

    ENDLOOP.

    APPEND wa_final TO it_final.
    CLEAR:wa_final,wa_kssk.
  ENDLOOP.

  IF s_werks IS NOT INITIAL.

    DELETE  it_final WHERE werks NE s_werks .

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .

  PERFORM fcat USING :
                     '1'  'MATNR'   'IT_FINAL'  'MATERIAL'          '18',
                     '2'  'MAKTX'   'IT_FINAL'  'DESCRIPTION'         '30',
                     '3'  'MTART'   'IT_FINAL'  'MATERIAL TYPE'   '12',
                     '4'  'EXTWG'   'IT_FINAL'  'Ext.Mat.Group'              '20',
                     '6'  'INSP_01'   'IT_FINAL'  'Inspection Type(01)'        '20',
                     '7'  'INSP_04'   'IT_FINAL'  'Inspection Type(04)'        '20',
                     '8'  'INSP_06'   'IT_FINAL'  'Inspection Type(06)'        '20',
                     '9'  'INSP_08'   'IT_FINAL'  'Inspection Type(08)'        '20',
                     '5'  'CLASS'   'IT_FINAL'  'Class'           '20',
                     '10'  'WERKS'   'IT_FINAL'  'Plant'           '20'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = it_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.

    PERFORM download.
    PERFORM download_file.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0207   text
*      -->P_0208   text
*      -->P_0209   text
*      -->P_0210   text
*      -->P_0211   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
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


  LOOP AT it_final INTO wa_final.

    ls_down-matnr    = wa_final-matnr.
    ls_down-maktx    = wa_final-maktx.
    ls_down-mtart    = wa_final-mtart.
    ls_down-extwg    = wa_final-extwg.
    ls_down-class    = wa_final-class.
    ls_down-insp_01  = wa_final-insp_01.
    ls_down-insp_04  = wa_final-insp_04.
    ls_down-insp_06  = wa_final-insp_06.
    ls_down-insp_08  = wa_final-insp_08.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_down-ref_dat.
    CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
   INTO ls_down-ref_dat SEPARATED BY '-'.

    ls_down-ref_time = sy-uzeit.
    CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  INTO ls_down-ref_time.

   ls_down-werks  = wa_final-werks.

    APPEND ls_down TO lt_down.
    CLEAR: ls_down.


  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_file .


TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.


  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

*BREAK-POINT.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.
  lv_file = 'ZQMAT.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZQMAT.TXT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_464 TYPE string.
DATA lv_crlf_464 TYPE string.
lv_crlf_464 = cl_abap_char_utilities=>cr_lf.
lv_string_464 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_464 lv_crlf_464 wa_csv INTO lv_string_464.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_778 TO lv_fullfile.
TRANSFER lv_string_464 TO lv_fullfile.
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

  CONCATENATE  'MATERIAL'
               'DESCRIPTION'
               'MATERIAL TYPE'
               'Ext.Mat.Group'
               'Class'
               'Inspection Type(01)'
               'Inspection Type(04)'
               'Inspection Type(06)'
               'Inspection Type(08)'
               'Refresh date'
               'Refresh time'
               'Plant'
          INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
