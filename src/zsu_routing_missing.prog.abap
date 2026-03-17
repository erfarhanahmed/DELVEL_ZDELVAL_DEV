*&---------------------------------------------------------------------*
*& Report ZROUTING_MATERIAL_CHECK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZROUTING_MATERIAL_CHECK.

TYPE-POOLS:SLIS.

TABLES:MARA.

TYPES : BEGIN OF TY_MARA,
          MATNR   TYPE MARA-MATNR,
          MTART   TYPE MARA-MTART,
          BRAND   TYPE MARA-BRAND,
          ZSERIES TYPE MARA-ZSERIES,
          ZSIZE   TYPE MARA-ZSIZE,
          MOC     TYPE MARA-MOC,
          TYPE    TYPE MARA-TYPE,
*          ZSERIES TYPE MARA-ZSERIES,
*          ZSIZE   TYPE MARA-ZSIZE,
        END OF TY_MARA,

        BEGIN OF TY_MARC,
          MATNR TYPE MARC-MATNR,
          BESKZ TYPE MARC-BESKZ,
          WERKS TYPE MARC-WERKS,
        END OF TY_MARC,

        BEGIN OF TY_MAPL,
          MATNR TYPE MAPL-MATNR,
          PLNTY TYPE MAPL-PLNTY,
          LOEKZ TYPE MAPL-LOEKZ,
        END OF TY_MAPL,


        BEGIN OF TY_FINAL,
          MATNR   TYPE MARA-MATNR,
          MTART   TYPE MARA-MTART,
          BRAND   TYPE MARA-BRAND,
          ZSERIES TYPE MARA-ZSERIES,
          ZSIZE   TYPE MARA-ZSIZE,
          MOC     TYPE MARA-MOC,
          TYPE    TYPE MARA-TYPE,
          BESKZ   TYPE MARC-BESKZ,
          MATTXT  TYPE TEXT100,
        END OF TY_FINAL,

        BEGIN OF TY_DOWN,
          MATNR    TYPE MARA-MATNR,
          MATTXT   TYPE TEXT100,
          ZSIZE    TYPE MARA-ZSIZE,
          ZSERIES  TYPE MARA-ZSERIES,
          MTART    TYPE MARA-MTART,
          BRAND    TYPE MARA-BRAND,
          MOC      TYPE MARA-MOC,
          TYPE     TYPE MARA-TYPE,
          REF      TYPE CHAR15,
          REF_TIME TYPE CHAR20,

        END OF TY_DOWN.


DATA: IT_MARA  TYPE TABLE OF TY_MARA,
      WA_MARA  TYPE          TY_MARA,

      IT_MARC  TYPE TABLE OF TY_MARC,
      WA_MARC  TYPE          TY_MARC,

      IT_MAPL  TYPE TABLE OF TY_MAPL,
      WA_MAPL  TYPE          TY_MAPL,

      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL,

      IT_DOWN  TYPE TABLE OF TY_DOWN,
      WA_DOWN  TYPE          TY_DOWN.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT TYPE SLIS_FIELDCAT_ALV.

DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.



SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS : S_TYPE TYPE MARA-MTART OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."saudi'.  "'/delval/saudi'
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.


PERFORM GET_DATA.
PERFORM GET_FCAT.
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
*BREAK fujiabap.


  IF S_TYPE = 'FERT'.
    SELECT MATNR
                BESKZ
                WERKS FROM MARC INTO TABLE IT_MARC
                WHERE WERKS = 'SU01'
                AND BESKZ = 'X'.

    IF IT_MARC[] IS NOT INITIAL.

      SELECT MATNR
             MTART
             ZSERIES
             ZSIZE FROM MARA INTO TABLE IT_MARA
             FOR ALL ENTRIES IN IT_MARC
             WHERE MTART = S_TYPE
             AND MATNR = IT_MARC-MATNR.


    ENDIF.
    IF IT_MARA[] IS NOT INITIAL.
      SELECT MATNR
             PLNTY
             LOEKZ
             FROM MAPL INTO TABLE IT_MAPL
             FOR ALL ENTRIES IN IT_MARA
             WHERE MATNR = IT_MARA-MATNR
             AND PLNTY EQ 'N'
             AND LOEKZ NE 'X'.

    ENDIF.


    LOOP AT IT_MARA INTO WA_MARA.

      WA_FINAL-MATNR =  WA_MARA-MATNR.
      WA_FINAL-ZSIZE   =  WA_MARA-ZSIZE .
      WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
      WA_FINAL-MTART   =  WA_MARA-MTART.
      WA_FINAL-BRAND   =  WA_MARA-BRAND .
      WA_FINAL-TYPE   =  WA_MARA-TYPE.
      WA_FINAL-MOC   =  WA_MARA-MOC .




      CLEAR: LV_LINES, LS_MATTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_FINAL-MATNR.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'GRUN'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      READ TABLE LV_LINES INTO LS_MATTXT INDEX 1.

      WA_FINAL-MATTXT = LS_MATTXT-TDLINE.

      APPEND WA_FINAL TO IT_FINAL.


      LOOP AT IT_MAPL INTO WA_MAPL WHERE MATNR =  WA_MARA-MATNR.

        DELETE IT_FINAL WHERE MATNR EQ WA_MARA-MATNR .
      ENDLOOP.
    ENDLOOP.
    delete ADJACENT DUPLICATES FROM IT_FINAL COMPARING MATNR.
  ENDIF.

*ENDFORM.
**
  IF S_TYPE = 'HALB'. "2
    SELECT MATNR
                BESKZ
                WERKS FROM MARC INTO TABLE IT_MARC
                WHERE WERKS = 'SU01'
                AND BESKZ = 'X'.


    SELECT MATNR
           MTART
           ZSERIES
           ZSIZE FROM MARA INTO TABLE IT_MARA
           FOR ALL ENTRIES IN IT_MARC
           WHERE MTART = S_TYPE
           AND MATNR = IT_MARC-MATNR.



  IF IT_MARC IS NOT INITIAL.
    SELECT MATNR
           PLNTY
           LOEKZ
           FROM MAPL INTO TABLE IT_MAPL
           FOR ALL ENTRIES IN IT_MARC
           WHERE MATNR = IT_MARC-MATNR
           AND PLNTY EQ 'N'
            AND LOEKZ NE 'X'.

  ENDIF.
* LOOP AT IT_MARA INTO WA_MARA.
  LOOP AT IT_MARC INTO WA_MARC.



*IF IT_MARC IS NOT INITIAL.
    LOOP AT IT_MARA INTO WA_MARA WHERE MATNR = WA_MARC-MATNR.
      WA_FINAL-MATNR =  WA_MARA-MATNR.
      WA_FINAL-ZSIZE   =  WA_MARA-ZSIZE .
      WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
      WA_FINAL-MTART   =  WA_MARA-MTART.
      WA_FINAL-BRAND   =  WA_MARA-BRAND .
      WA_FINAL-TYPE   =  WA_MARA-TYPE.
      WA_FINAL-MOC   =  WA_MARA-MOC .
*



      CLEAR: LV_LINES, LS_MATTXT." 3
      REFRESH LV_LINES.
      LV_NAME = WA_FINAL-MATNR.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'GRUN'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      READ TABLE LV_LINES INTO LS_MATTXT INDEX 1.

      WA_FINAL-MATTXT = LS_MATTXT-TDLINE.
*      IF WA_MARC-WERKS = 'SU01'.
        APPEND WA_FINAL TO IT_FINAL.
*      ENDIF.
      LOOP AT  IT_MAPL INTO WA_MAPL WHERE MATNR = WA_MARC-MATNR.

        DELETE  IT_FINAL  WHERE MATNR = WA_MARC-MATNR.
      ENDLOOP.
    ENDLOOP.
*ENDIF.
  ENDLOOP.
ENDIF.

  IF  P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-MATNR    = WA_FINAL-MATNR   .
      WA_DOWN-MATTXT   = WA_FINAL-MATTXT  .
      WA_DOWN-ZSIZE    = WA_FINAL-ZSIZE   .
      WA_DOWN-ZSERIES  = WA_FINAL-ZSERIES .
      WA_DOWN-MTART  = WA_FINAL-MTART .
      WA_DOWN-BRAND    = WA_FINAL-BRAND   .
      WA_DOWN-TYPE    = WA_FINAL-TYPE   .
      WA_DOWN-MOC    = WA_FINAL-MOC   .


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.


      WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

      APPEND WA_DOWN TO IT_DOWN.
    ENDLOOP.
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
FORM GET_FCAT .
  PERFORM FCAT USING :   '1'  'MATNR'   'IT_FINAL'  'Item_Code'          '18',
                         '2'  'mattxt'   'IT_FINAL'  'Description'       '50',
                         '3'  'ZSIZE'   'IT_FINAL'  'Size'               '10',
                         '4'  'ZSERIES'   'IT_FINAL'  'Series'           '10',
                         '5'  'MTART'   'IT_FINAL'  'Mtl.Type'           '10',
                         '6'  'BRAND'   'IT_FINAL'  'Brand'           '10',
                         '7'  'TYPE'   'IT_FINAL'  'Type'           '10',
                         '8'  'MOC'   'IT_FINAL'  'MOC'           '10'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0189   text
*      -->P_0190   text
*      -->P_0191   text
*      -->P_0192   text
*      -->P_0193   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5).
  WA_FCAT-COL_POS = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME = P3.
  WA_FCAT-SELTEXT_L = P4.
  WA_FCAT-OUTPUTLEN = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.


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
      I_CALLBACK_PROGRAM = SY-REPID
      IT_FIELDCAT        = IT_FCAT
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB           = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
*    PERFORM gui_download.
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
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.
  IF S_TYPE = 'FERT'.
    LV_FILE = 'ZSU_ROUTING_FERT.TXT'.
  ELSE.
    LV_FILE = 'ZSU_ROUTING_HALB.TXT'.
  ENDIF.

*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'SU Routing Missing Report', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_453 TYPE string.
DATA lv_crlf_453 TYPE string.
lv_crlf_453 = cl_abap_char_utilities=>cr_lf.
lv_string_453 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_453 lv_crlf_453 wa_csv INTO lv_string_453.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_453 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Item_Code'
              'Description'
              'Size'
              'Series'
              'Mtl.Type'
              'BRAND'
              'TYPE'
              'MOC'
              'Refresh File Date'
              'Refresh Time'
               INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.




ENDFORM.
