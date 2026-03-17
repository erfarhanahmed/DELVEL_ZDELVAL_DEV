*&---------------------------------------------------------------------*
*& Report ZBOM_CHANGE_DETAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBOM_CHANGE_DETAIL.

TABLES :MDKP,MAST,ZSTKO,ZSTPO.

TYPES: BEGIN OF TY_MDKP,
       MATNR TYPE MDKP-MATNR,
       DSDAT TYPE MDKP-DSDAT,
       END OF TY_MDKP,

       BEGIN OF TY_MAST,
       MATNR TYPE MAST-MATNR,
       STLNR TYPE MAST-STLNR,
       END OF TY_MAST,

       BEGIN OF TY_STKO,
       STLNR TYPE ZSTKO-STLNR,
       ANDAT TYPE ZSTKO-ANDAT,
       ANNAM TYPE ZSTKO-ANNAM,
       AEDAT TYPE ZSTKO-AEDAT,
       AENAM TYPE ZSTKO-AENAM,
       END OF TY_STKO,

       BEGIN OF TY_STPO,
       STLNR TYPE ZSTPO-STLNR,
       IDNRK TYPE ZSTPO-IDNRK,
       MENGE TYPE ZSTPO-MENGE,
       AEDAT TYPE ZSTPO-AEDAT,
       AENAM TYPE ZSTPO-AENAM,
       ANDAT TYPE ZSTPO-ANDAT,
       ANNAM TYPE ZSTPO-ANNAM,
       END OF TY_STPO,

       BEGIN OF TY_MARA,
       MATNR   TYPE MARA-MATNR,
       ZSERIES TYPE MARA-ZSERIES,
       ZSIZE   TYPE MARA-ZSIZE,
       BRAND   TYPE MARA-BRAND,
       END OF TY_MARA,

       BEGIN OF TY_FINAL,
       MATNR      TYPE MDKP-MATNR,
       DSDAT      TYPE MDKP-DSDAT,
       STLNR      TYPE MAST-STLNR,
       IDNRK      TYPE ZSTPO-IDNRK,
       AEDAT      TYPE ZSTPO-AEDAT,
       AENAM      TYPE ZSTPO-AENAM,
       ANDAT      TYPE ZSTPO-ANDAT,
       ANNAM      TYPE ZSTPO-ANNAM,
       ZSERIES    TYPE MARA-ZSERIES,
       ZSIZE      TYPE MARA-ZSIZE,
       BRAND      TYPE MARA-BRAND,
       MAT_TEXT   TYPE text100,
       COMP_TEXT  TYPE text100,
       END OF TY_FINAL.

TYPES: BEGIN OF TY_ITEM,
       STLNR      TYPE MAST-STLNR,
       MATNR      TYPE MDKP-MATNR,
       MAT_TEXT   TYPE text100,
       IDNRK      TYPE ZSTPO-IDNRK,
       COMP_TEXT  TYPE text100,
       DSDAT      TYPE CHAR15,
       ANDAT      TYPE CHAR15,
       ANNAM      TYPE ZSTPO-ANNAM,
       AEDAT      TYPE CHAR15,
       AENAM      TYPE ZSTPO-AENAM,
       ZSIZE      TYPE MARA-ZSIZE,
       ZSERIES    TYPE MARA-ZSERIES,
       BRAND      TYPE MARA-BRAND,
       REF        TYPE CHAR15,
       END OF TY_ITEM,

       BEGIN OF TY_HEADER,
       STLNR      TYPE MAST-STLNR,
       MATNR      TYPE MDKP-MATNR,
       MAT_TEXT   TYPE text100,
       DSDAT      TYPE CHAR15,
       ANDAT      TYPE CHAR15,
       ANNAM      TYPE ZSTKO-ANNAM,
       AEDAT      TYPE CHAR15,
       AENAM      TYPE ZSTKO-AENAM,
       ZSIZE      TYPE MARA-ZSIZE,
       ZSERIES    TYPE MARA-ZSERIES,
       BRAND      TYPE MARA-BRAND,
       REF        TYPE CHAR15,
       END OF TY_HEADER.

DATA: IT_MDKP TYPE TABLE OF TY_MDKP,
      WA_MDKP TYPE          TY_MDKP,

      IT_MAST TYPE TABLE OF TY_MAST,
      WA_MAST TYPE          TY_MAST,

      IT_STKO TYPE TABLE OF TY_STKO,
      WA_STKO TYPE          TY_STKO,

      IT_STPO TYPE TABLE OF TY_STPO,
      WA_STPO TYPE          TY_STPO,

      IT_MARA TYPE TABLE OF TY_MARA,
      WA_MARA TYPE          TY_MARA,

      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL.

DATA: IT_ITEM TYPE TABLE OF TY_ITEM,
      WA_ITEM TYPE          TY_ITEM,

      IT_HEADER TYPE TABLE OF TY_HEADER,
      WA_HEADER TYPE          TY_HEADER.

DATA: it_fcat type slis_t_fieldcat_alv,
      wa_fcat like line of it_fcat.
DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt  TYPE tline,
      ls_mattxt  TYPE tline.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_DATE FOR MDKP-DSDAT.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN: BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: R1 RADIOBUTTON GROUP RG,
              R2 RADIOBUTTON GROUP RG.
SELECTION-SCREEN: END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B3.

IF R1 = 'X'.
  PERFORM GET_DATA_HEADER.
  PERFORM GET_FCAT_HEADER.
  PERFORM GET_DISPLAY_HEADER.
ENDIF.



IF R2 = 'X'.
  PERFORM GET_DATA.
  PERFORM GET_FCAT.
  PERFORM GET_DISPLAY.
ENDIF.


*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  SELECT MATNR
         DSDAT FROM MDKP INTO TABLE IT_MDKP
         WHERE DSDAT IN S_DATE.

 IF IT_MDKP IS NOT INITIAL.
   SELECT MATNR
          STLNR FROM MAST INTO TABLE IT_MAST
          FOR ALL ENTRIES IN IT_MDKP
          WHERE MATNR = IT_MDKP-MATNR.

 ENDIF.

 IF IT_MAST IS NOT INITIAL .

   SELECT STLNR
          IDNRK
          MENGE
          AEDAT
          AENAM
          ANDAT
          ANNAM
          FROM ZSTPO INTO TABLE IT_STPO
          FOR ALL ENTRIES IN IT_MAST
          WHERE STLNR = IT_MAST-STLNR.


 ENDIF.

IF IT_STPO IS NOT INITIAL.
   SELECT MATNR
          ZSERIES
          ZSIZE
          BRAND   FROM MARA INTO TABLE IT_MARA
          FOR ALL ENTRIES IN IT_STPO
          WHERE MATNR = IT_STPO-IDNRK.
ENDIF.



LOOP AT IT_STPO INTO WA_STPO.
  WA_FINAL-STLNR   = WA_STPO-STLNR.
  WA_FINAL-IDNRK   = WA_STPO-IDNRK.
  WA_FINAL-AEDAT   = WA_STPO-AEDAT.
  WA_FINAL-AENAM   = WA_STPO-AENAM.
  WA_FINAL-ANDAT   = WA_STPO-ANDAT.
  WA_FINAL-ANNAM   = WA_STPO-ANNAM.

READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_STPO-IDNRK.
 IF SY-SUBRC = 0.
   WA_FINAL-ZSERIES  = WA_MARA-ZSERIES.
   WA_FINAL-ZSIZE    = WA_MARA-ZSIZE  .
   WA_FINAL-BRAND    = WA_MARA-BRAND  .

 ENDIF.
 READ TABLE IT_MAST INTO WA_MAST WITH KEY STLNR = WA_STPO-STLNR.
 IF SY-SUBRC = 0.
   WA_FINAL-MATNR = WA_MAST-MATNR.

 ENDIF.
 READ TABLE IT_MDKP INTO WA_MDKP WITH KEY MATNR = WA_MAST-MATNR.
 IF SY-SUBRC = 0.
   WA_FINAL-DSDAT = WA_MDKP-DSDAT.

 ENDIF.

 CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = wa_mara-matnr.
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
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE WA_final-MAT_TEXT wa_lines-tdline INTO wa_final-MAT_TEXT SEPARATED BY space.
          ENDIF.
        ENDLOOP.

      ENDIF.

CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = WA_STPO-IDNRK.
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
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE WA_final-COMP_TEXT wa_lines-tdline INTO wa_final-COMP_TEXT SEPARATED BY space.
          ENDIF.
        ENDLOOP.

      ENDIF.

 WA_ITEM-STLNR     =   WA_STPO-STLNR.
 WA_ITEM-MATNR     =   WA_MAST-MATNR.
 WA_ITEM-MAT_TEXT  =   WA_final-MAT_TEXT.
 WA_ITEM-IDNRK     =   WA_STPO-IDNRK.
 WA_ITEM-COMP_TEXT =   WA_final-COMP_TEXT.
* WA_ITEM-DSDAT     =   WA_MDKP-DSDAT.
 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_MDKP-DSDAT
   IMPORTING
     OUTPUT        = WA_ITEM-DSDAT
            .

CONCATENATE WA_ITEM-DSDAT+0(2) WA_ITEM-DSDAT+2(3) WA_ITEM-DSDAT+5(4)
                INTO WA_ITEM-DSDAT SEPARATED BY '-'.


* WA_ITEM-ANDAT     =   WA_STPO-ANDAT.
 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_STPO-ANDAT
   IMPORTING
     OUTPUT        = WA_ITEM-ANDAT
            .

CONCATENATE WA_ITEM-ANDAT+0(2) WA_ITEM-ANDAT+2(3) WA_ITEM-ANDAT+5(4)
                INTO WA_ITEM-ANDAT SEPARATED BY '-'.


 WA_ITEM-ANNAM     =   WA_STPO-ANNAM.
* WA_ITEM-AEDAT     =   WA_STPO-AEDAT.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_STPO-AEDAT
   IMPORTING
     OUTPUT        = WA_ITEM-AEDAT
            .

CONCATENATE WA_ITEM-AEDAT+0(2) WA_ITEM-AEDAT+2(3) WA_ITEM-AEDAT+5(4)
                INTO WA_ITEM-AEDAT SEPARATED BY '-'.


 WA_ITEM-AENAM     =   WA_STPO-AENAM.
 WA_ITEM-ZSIZE     =   WA_MARA-ZSIZE  .
 WA_ITEM-ZSERIES   =   WA_MARA-ZSERIES.
 WA_ITEM-BRAND     =   WA_MARA-BRAND  .
 WA_ITEM-REF       =   SY-DATUM.

 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_ITEM-REF
   IMPORTING
     OUTPUT        = WA_ITEM-REF
            .

CONCATENATE WA_ITEM-REF+0(2) WA_ITEM-REF+2(3) WA_ITEM-REF+5(4)
                INTO WA_ITEM-REF SEPARATED BY '-'.


 IF WA_FINAL-DSDAT <= WA_FINAL-AEDAT.

   APPEND WA_FINAL TO IT_FINAL.
   APPEND WA_ITEM TO IT_ITEM.
   SORT IT_FINAL BY STLNR .
 ENDIF.

* SORT IT_FINAL BY
 CLEAR WA_FINAL.
 CLEAR WA_ITEM.
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
FORM get_fcat .

  PERFORM FCAT USING : '1'  'STLNR'     'IT_FINAL'  'Bom'           '18' ,
                       '2'  'MATNR'     'IT_FINAL'  'Material'      '18' ,
                       '3'  'MAT_TEXT'  'IT_FINAL'  'MAT.Desc'      '20',
                       '4'  'IDNRK '    'IT_FINAL'  'Component'     '18',
                       '5'  'COMP_TEXT'  'IT_FINAL'  'COMP.Desc'     '20',
                       '6'  'DSDAT'     'IT_FINAL'  'MRP Date'      '10',
                       '7'  'ANDAT'     'IT_FINAL'  'created on'    '10' ,
                       '8'  'ANNAM'     'IT_FINAL'  'created By'    '10' ,
                       '9'  'AEDAT'     'IT_FINAL'  'Change On'     '10',
                       '10'  'AENAM'     'IT_FINAL'  'Change By'     '10',
                       '11'  'ZSIZE'     'IT_FINAL'  'Size'          '10',
                       '12'  'ZSERIES'   'IT_FINAL'  'Series'       '5',
                       '13'  'BRAND'     'IT_FINAL'  'Brand'        '8'.







ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0434   text
*      -->P_0435   text
*      -->P_0436   text
*      -->P_0437   text
*      -->P_0438   text
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

append wa_fcat to it_fcat.
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
FORM get_display .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
     I_CALLBACK_PROGRAM                = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
*     IS_LAYOUT                         =
     IT_FIELDCAT                       = it_fcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT                           =
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
*     I_SAVE                            = ' '
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
      t_outtab                          = it_final
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

FORM download .
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
BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = IT_ITEM
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
  lv_file = 'ZBOMITEM.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.
BREAK primus.
  WRITE: / 'ZBOM HISTORY ITEM', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_534 TYPE string.
DATA lv_crlf_534 TYPE string.
lv_crlf_534 = cl_abap_char_utilities=>cr_lf.
lv_string_534 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_534 lv_crlf_534 wa_csv INTO lv_string_534.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_534 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

ENDFORM.

FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Bom'
              'Material'
              'MAT.Desc'
              'Component'
              'COMP.Desc'
              'MRP Date'
              'Created on'
              'Created By'
              'Change On'
              'Change By'
              'Size'
              'Series'
              'Brand'
              'Refresh DATE'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.

********************************************HEADER LEVEL CHANGES REPORT*****************************************


*&---------------------------------------------------------------------*
*&      Form  GET_DATA_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_header .
  SELECT MATNR
         DSDAT FROM MDKP INTO TABLE IT_MDKP
         WHERE DSDAT IN S_DATE.

  IF IT_MDKP IS NOT INITIAL.
   SELECT MATNR
          STLNR FROM MAST INTO TABLE IT_MAST
          FOR ALL ENTRIES IN IT_MDKP
          WHERE MATNR = IT_MDKP-MATNR.

 ENDIF.

 IF IT_MAST IS NOT INITIAL .
   SELECT STLNR
          ANDAT
          ANNAM
          AEDAT
          AENAM FROM ZSTKO INTO TABLE IT_STKO
          FOR ALL ENTRIES IN IT_MAST
          WHERE STLNR = IT_MAST-STLNR.


   SELECT MATNR
          ZSERIES
          ZSIZE
          BRAND   FROM MARA INTO TABLE IT_MARA
          FOR ALL ENTRIES IN IT_MAST
          WHERE MATNR = IT_MAST-MATNR.

 ENDIF.



LOOP AT IT_STKO INTO WA_STKO.
  WA_FINAL-STLNR   = WA_STKO-STLNR.
  WA_FINAL-AEDAT   = WA_STKO-AEDAT.
  WA_FINAL-AENAM   = WA_STKO-AENAM.
  WA_FINAL-ANDAT   = WA_STKO-ANDAT.
  WA_FINAL-ANNAM   = WA_STKO-ANNAM.



READ TABLE IT_MAST INTO WA_MAST WITH KEY STLNR = WA_STKO-STLNR.
 IF SY-SUBRC = 0.
   WA_FINAL-MATNR = WA_MAST-MATNR.

 ENDIF.

READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MAST-MATNR.
 IF SY-SUBRC = 0.
   WA_FINAL-ZSERIES  = WA_MARA-ZSERIES.
   WA_FINAL-ZSIZE    = WA_MARA-ZSIZE  .
   WA_FINAL-BRAND    = WA_MARA-BRAND  .

 ENDIF.

 READ TABLE IT_MDKP INTO WA_MDKP WITH KEY MATNR = WA_MAST-MATNR.
 IF SY-SUBRC = 0.
   WA_FINAL-DSDAT = WA_MDKP-DSDAT.

 ENDIF.

 CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = wa_mara-matnr.
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
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE WA_final-MAT_TEXT wa_lines-tdline INTO wa_final-MAT_TEXT SEPARATED BY space.
          ENDIF.
        ENDLOOP.

      ENDIF.


 WA_HEADER-STLNR     =   WA_STKO-STLNR.
 WA_HEADER-MATNR     =   WA_MAST-MATNR.
 WA_HEADER-MAT_TEXT  =   WA_final-MAT_TEXT.


* WA_ITEM-DSDAT     =   WA_MDKP-DSDAT.
 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_MDKP-DSDAT
   IMPORTING
     OUTPUT        = WA_HEADER-DSDAT
            .

CONCATENATE WA_HEADER-DSDAT+0(2) WA_HEADER-DSDAT+2(3) WA_HEADER-DSDAT+5(4)
                INTO WA_HEADER-DSDAT SEPARATED BY '-'.


* WA_ITEM-ANDAT     =   WA_STKO-ANDAT.
 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_STKO-ANDAT
   IMPORTING
     OUTPUT        = WA_HEADER-ANDAT
            .

CONCATENATE WA_HEADER-ANDAT+0(2) WA_HEADER-ANDAT+2(3) WA_HEADER-ANDAT+5(4)
                INTO WA_HEADER-ANDAT SEPARATED BY '-'.


 WA_HEADER-ANNAM     =   WA_STKO-ANNAM.
* WA_ITEM-AEDAT     =   WA_STKO-AEDAT.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_STKO-AEDAT
   IMPORTING
     OUTPUT        = WA_HEADER-AEDAT
            .

CONCATENATE WA_HEADER-AEDAT+0(2) WA_HEADER-AEDAT+2(3) WA_HEADER-AEDAT+5(4)
                INTO WA_HEADER-AEDAT SEPARATED BY '-'.


 WA_HEADER-AENAM     =   WA_STKO-AENAM.
 WA_HEADER-ZSIZE     =   WA_MARA-ZSIZE  .
 WA_HEADER-ZSERIES   =   WA_MARA-ZSERIES.
 WA_HEADER-BRAND     =   WA_MARA-BRAND  .
 WA_HEADER-REF       =   SY-DATUM.

 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = WA_HEADER-REF
   IMPORTING
     OUTPUT        = WA_HEADER-REF
            .

CONCATENATE WA_HEADER-REF+0(2) WA_HEADER-REF+2(3) WA_HEADER-REF+5(4)
                INTO WA_HEADER-REF SEPARATED BY '-'.



IF WA_FINAL-DSDAT <= WA_FINAL-AEDAT.
   APPEND WA_FINAL TO IT_FINAL.
   APPEND WA_HEADER TO IT_HEADER.
   SORT IT_FINAL BY STLNR .
 ENDIF.


 CLEAR WA_FINAL.
ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat_header .
  PERFORM FCAT USING : '1'  'STLNR'     'IT_FINAL'  'Bom'           '18' ,
                       '2'  'MATNR'     'IT_FINAL'  'Material'      '18' ,
                       '3'  'MAT_TEXT'  'IT_FINAL'  'MAT.Desc'      '20',
                       '4'  'DSDAT'     'IT_FINAL'  'MRP Date'      '10',
                       '5'  'ANDAT'     'IT_FINAL'  'created on'    '10' ,
                       '6'  'ANNAM'     'IT_FINAL'  'created By'    '10' ,
                       '7'  'AEDAT'     'IT_FINAL'  'Change On'     '10',
                       '8'  'AENAM'     'IT_FINAL'  'Change By'     '10',
                       '9'  'ZSIZE'     'IT_FINAL'  'Size'          '10',
                       '10'  'ZSERIES'   'IT_FINAL' 'Series'       '5',
                       '11'  'BRAND'     'IT_FINAL' 'Brand'        '8'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display_header .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
     I_CALLBACK_PROGRAM                = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
*     IS_LAYOUT                         =
     IT_FIELDCAT                       = it_fcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT                           =
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
*     I_SAVE                            = ' '
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
      t_outtab                          = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  IF p_down = 'X'.
    PERFORM download_Header.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_header .
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
BREAK PRIMUS.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = IT_HEADER
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header_head USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZBOMHEADER.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.
BREAK primus.
  WRITE: / 'ZBOM HISTORY HEADER', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_879 TYPE string.
DATA lv_crlf_879 TYPE string.
lv_crlf_879 = cl_abap_char_utilities=>cr_lf.
lv_string_879 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_879 lv_crlf_879 wa_csv INTO lv_string_879.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_879 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER_HEAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header_head  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Bom'
              'Material'
              'MAT.Desc'
              'MRP Date'
              'created on'
              'created By'
              'Change On'
              'Change By'
              'Size'
              'Series'
              'Brand'
              'Refresh DATE'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
