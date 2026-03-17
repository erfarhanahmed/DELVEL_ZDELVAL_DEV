*&---------------------------------------------------------------------*
*& Report ZMM_UPLOAD_MAT_LONG_TXT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_UPLOAD_MAT_LONG_TXT.

*>>
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS SESSION RADIOBUTTON GROUP CTU.  "create session
SELECTION-SCREEN COMMENT 3(20) TEXT-S07 FOR FIELD SESSION.
SELECTION-SCREEN POSITION 45.
PARAMETERS CTU RADIOBUTTON GROUP  CTU DEFAULT 'X'.     "call transaction
SELECTION-SCREEN COMMENT 48(20) TEXT-S08 FOR FIELD CTU.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 3(20) TEXT-S01 FOR FIELD GROUP.
SELECTION-SCREEN POSITION 25.
PARAMETERS GROUP(12).                      "group name of session
SELECTION-SCREEN COMMENT 48(20) TEXT-S05 FOR FIELD CTUMODE.
SELECTION-SCREEN POSITION 70.
PARAMETERS CTUMODE LIKE CTU_PARAMS-DISMODE DEFAULT 'N'.
"A: show all dynpros
"E: show dynpro on error only
"N: do not display dynpro
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 3(20) TEXT-S02 FOR FIELD USER.
SELECTION-SCREEN POSITION 25.
PARAMETERS: USER(12) DEFAULT SY-UNAME.     "user for session in batch
SELECTION-SCREEN COMMENT 48(20) TEXT-S06 FOR FIELD CUPDATE.
SELECTION-SCREEN POSITION 70.
PARAMETERS CUPDATE LIKE CTU_PARAMS-UPDMODE DEFAULT 'L'.
"S: synchronously
"A: asynchronously
"L: local
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 3(20) TEXT-S03 FOR FIELD KEEP.
SELECTION-SCREEN POSITION 25.
PARAMETERS: KEEP AS CHECKBOX.       "' ' = delete session if finished
"'X' = keep   session if finished
SELECTION-SCREEN COMMENT 48(20) TEXT-S09 FOR FIELD E_GROUP.
SELECTION-SCREEN POSITION 70.
PARAMETERS E_GROUP(12).             "group name of error-session
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 3(20) TEXT-S04 FOR FIELD HOLDDATE.
SELECTION-SCREEN POSITION 25.
PARAMETERS: HOLDDATE LIKE SY-DATUM.
SELECTION-SCREEN COMMENT 51(17) TEXT-S02 FOR FIELD E_USER.
SELECTION-SCREEN POSITION 70.
PARAMETERS: E_USER(12) DEFAULT SY-UNAME.    "user for error-session
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 51(17) TEXT-S03 FOR FIELD E_KEEP.
SELECTION-SCREEN POSITION 70.
PARAMETERS: E_KEEP AS CHECKBOX.     "' ' = delete session if finished
"'X' = keep   session if finished
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 51(17) TEXT-S04 FOR FIELD E_HDATE.
SELECTION-SCREEN POSITION 70.
PARAMETERS: E_HDATE LIKE SY-DATUM.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(33) TEXT-S10 FOR FIELD NODATA.
PARAMETERS: NODATA DEFAULT '/' LOWER CASE.          "nodata
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(33) TEXT-S11 FOR FIELD SMALLLOG.
PARAMETERS: SMALLLOG AS CHECKBOX.  "' ' = log all transactions
"'X' = no transaction logging
SELECTION-SCREEN END OF LINE.

*>>
*----------------------------------------------------------------------*
*   data definition
*----------------------------------------------------------------------*
*       Batchinputdata of single transaction
DATA:   BDCDATA LIKE BDCDATA    OCCURS 0 WITH HEADER LINE.
*       messages of call transaction
DATA:   MESSTAB LIKE BDCMSGCOLL OCCURS 0 WITH HEADER LINE.
*       error session opened (' ' or 'X')
DATA:   E_GROUP_OPENED.
*       message texts
TABLES: T100.
DATA: T_LONGTEXT TYPE STANDARD TABLE OF BAPI_MLTX,
      W_LONGTEXT TYPE STANDARD TABLE OF BAPI_MLTX.
*Data declaration
DATA : BEGIN OF IT_MM02 OCCURS 0,
*    WERKS TYPE MARC-WERKS,
         MATNR TYPE MARA-MATNR,
         TEXT  TYPE TDLINE,
       END OF IT_MM02.

DATA : WA_MM02 LIKE  IT_MM02.

*SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
*SELECTION-SCREEN BEGIN OF LINE.
*PARAMETERS p_input LIKE rlgrap-filename ."OBLIGATORY . " Input File
*SELECTION-SCREEN :END OF BLOCK b1.

DATA : IT_HEAD     TYPE TABLE OF  BAPIMATHEAD  WITH HEADER LINE,
       V_KZSEL(20),

       IT_RET      LIKE STANDARD   TABLE OF   BAPIRET2,
       IT_PLANT    TYPE TABLE OF BAPI_MARC WITH HEADER LINE.


*DATA : IT_RET1 LIKE  LINE OF  IT_RET .
*IT_TEXT-APPLOBJECT  = 'MATERIAL'.
*IT_TEXT-TEXT_NAME  = WA_MM02-MATNR.
*IT_TEXT-TEXT_ID  = 'BEST'.
*IT_TEXT-LANGU = 'EN'.
*IT_TEXT-TEXT_LINE = WA_MM02-TEXT.
*APPEND IT_TEXT.
*CLEAR IT_TEXT.

DATA: BEGIN OF IT_SUC OCCURS 0,
        MES(280) TYPE C,
        TYPE     TYPE CHAR1,
        MATNR    TYPE MARA-MATNR,
      END OF IT_SUC.

DATA: BEGIN OF IT_ERR OCCURS 0,
        MES(280) TYPE C,
        TYPE     TYPE CHAR1,
        MATNR    TYPE MARA-MATNR,
      END OF IT_ERR.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_input.*
*  DATA: f_file LIKE ibipparms-path.*
*  CALL FUNCTION 'F4_FILENAME'
*    IMPORTING
*      file_name = f_file.
*  p_input = f_file.

*----------------------------------------------------------------------*
*   at selection screen                                                *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
* group and user must be filled for create session
  IF SESSION = 'X' AND
     GROUP = SPACE OR USER = SPACE.
    MESSAGE E613(MS).
  ENDIF.


START-OF-SELECTION.
  DATA: WA_FILE-MATNR     TYPE MATNR,
        WA_FILE-TEXT_LINE TYPE STRING. " ZMdata-long_text.
*Read values  from memory
  IMPORT WA_FILE-MATNR WA_FILE-TEXT_LINE FROM MEMORY ID 'zmat'.
*  IMPORT t_longtext  FROM MEMORY ID 'zlog'.
*sort it_mm02 by werks matnr.
*LOOP AT IT_MM02 INTO WA_MM02.
  DATA: V_INDEX(3) .
*V_KZSEL(30).

*perform open_group.

**  PERFORM bdc_dynpro      USING 'SAPLMGMM' '0060'.
**  PERFORM bdc_field       USING 'BDC_CURSOR'
**                                'RMMG1-MATNR'.
**  PERFORM bdc_field       USING 'BDC_OKCODE'   '/00'.
**  PERFORM bdc_field       USING 'RMMG1-MATNR' wa_file-matnr ." 'C-FG01'.
**  PERFORM bdc_dynpro      USING 'SAPLMGMM' '0070'.
**  PERFORM bdc_field       USING 'BDC_CURSOR'  'MSICHTAUSW-DYTXT(01)'.
**
**  PERFORM bdc_field       USING 'BDC_CURSOR' 'MSICHTAUSW-DYTXT(01)'.
**  PERFORM bdc_field       USING 'BDC_OKCODE' '=ENTR'.
**  PERFORM bdc_field       USING 'MSICHTAUSW-KZSEL(01)' 'X'.
**  PERFORM bdc_dynpro      USING 'SAPLMGMM' '4004'.
**  PERFORM bdc_field       USING 'BDC_OKCODE' '=PB26'.
**  PERFORM bdc_field       USING 'BDC_CURSOR' 'MAKT-MAKTX'.
***perform bdc_field       using 'MAKT-MAKTX'
***                              'Test for Screen Exit'.
***perform bdc_field       using 'MARA-MEINS'
***                              'EA'.
**  PERFORM bdc_field       USING 'DESC_LANGU_GDTXT' 'E'.
**  PERFORM bdc_dynpro      USING 'SAPLMGMM' '4300'.
**  PERFORM bdc_field       USING 'BDC_OKCODE' '=BU'.

  PERFORM WRITE_TEXT.            .
*at end of matnr.
*perform bdc_transaction using 'MM02'.
*perform write_mes using wa_mm02-matnr.

*endat .

*perform close_group.

*endloop.
*PERFORM DIS_MES.

*&---------------------------------------------------------------------*
*&      Form  f_upload
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_UPLOAD .
*
* DATA: ff_file TYPE  RLGRAP-FILENAME ."string.
*  ff_file = p_input.
*  types truxs_t_text_data(4096) type c occurs 0.
*data : rawdata type TRUXS_T_TEXT_DATA.
*
*
*               CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
*                 EXPORTING
**                  I_FIELD_SEPERATOR          =
**                  I_LINE_HEADER              =
*                   i_tab_raw_data             = rawdata
*                   i_filename                 = ff_file
*                 tables
*                   i_tab_converted_data       = it_MM02
**                EXCEPTIONS
**                  CONVERSION_FAILED          = 1
**                  OTHERS                     = 2
*                         .
*               IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*               ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  write_text
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM WRITE_TEXT .
  DATA : IT_HEADER  TYPE TABLE OF THEAD WITH HEADER LINE,
         IT_LINE    TYPE TABLE OF TLINE WITH HEADER LINE,
         L_NAME(70).
  DATA: GV_TEXT1(132) TYPE C.
  DATA: GV_TEXT2(132) TYPE C.

  DATA LEN TYPE I.
  IT_HEADER-TDOBJECT =  'MATERIAL'.
  IT_HEADER-TDNAME = WA_FILE-MATNR.
  IT_HEADER-TDID = 'GRUN'.
  IT_HEADER-TDSPRAS =  'E'.
  APPEND IT_HEADER.
  CLEAR IT_HEADER.
*TDTITLE *TDFORM *TDSTYLE
******** Code added by sagar dev (primus) 19/01/2024
  CLEAR: GV_TEXT1,GV_TEXT2,LEN.
  LEN = STRLEN( WA_FILE-TEXT_LINE ).
  GV_TEXT1 = WA_FILE-TEXT_LINE.
  IF LEN >= '132'.
    GV_TEXT2 = WA_FILE-TEXT_LINE+132.
    IT_LINE-TDFORMAT = 'ST'.
    IT_LINE-TDLINE = GV_TEXT1."wa_file-text_line.
    APPEND IT_LINE.
    CLEAR IT_LINE.
    IT_LINE-TDFORMAT = ''.
    IT_LINE-TDLINE = GV_TEXT2.
    APPEND IT_LINE.
    CLEAR IT_LINE.
  ELSE.
    IT_LINE-TDFORMAT = 'ST'.
    IT_LINE-TDLINE = GV_TEXT1."wa_file-text_line.
    APPEND IT_LINE.
    CLEAR IT_LINE.
  ENDIF.

********* end code ******** Code added by sagar dev (primus) 19/01/2024

  READ TABLE IT_HEADER.
  READ TABLE IT_LINE.

  MOVE  WA_FILE-MATNR TO L_NAME.

  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      INPUT  = L_NAME
    IMPORTING
      OUTPUT = L_NAME.

  CALL FUNCTION 'ZCREATE_TEXT'
    EXPORTING
      FID         = 'GRUN' "L_ID
      FLANGUAGE   = SY-LANGU
      FNAME       = L_NAME
      FOBJECT     = 'MATERIAL' "W_OBJECT
      SAVE_DIRECT = 'X'
*     FFORMAT     = '*'
    TABLES
      FLINES      = IT_LINE
    EXCEPTIONS
      NO_INIT     = 1
      NO_SAVE     = 2
      OTHERS      = 3.



ENDFORM.                    " write_text
*&---------------------------------------------------------------------*
*&      Form  GET_VIEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_VIEW USING MATNR  CHANGING INDEX.
  DATA : IT_BILD TYPE TABLE OF MBILDTAB WITH HEADER LINE.

*IT_BILD-GUIFU = 'SP07' .
*IT_BILD-DYTXT = 'Purchase order Text'.
*append it_bild.
*clear it_bild.

*DATA : VPSTA LIKE MARA-VPSTA,
*V_MTART LIKE MARA-MTART.
*CLEAR VPSTA.
*SELECT SINGLE VPSTA MTART FROM MARA INTO (VPSTA , V_MTART) WHERE MATNR = MATNR.

ENDFORM.                    " GET_VIEW
*&---------------------------------------------------------------------*
*&      Form  write_mes
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM WRITE_MES USING MATNR .
*data : l_mstring(250) type c.
* LOOP AT MESSTAB.
*        SELECT SINGLE * FROM T100 WHERE SPRSL = MESSTAB-MSGSPRA
*                                  AND   ARBGB = MESSTAB-MSGID
*                                  AND   MSGNR = MESSTAB-MSGNR.
*        IF SY-SUBRC = 0.
*          L_MSTRING = T100-TEXT.
*          IF L_MSTRING CS '&1'.
*            REPLACE '&1' WITH MESSTAB-MSGV1 INTO L_MSTRING.
*            REPLACE '&2' WITH MESSTAB-MSGV2 INTO L_MSTRING.
*            REPLACE '&3' WITH MESSTAB-MSGV3 INTO L_MSTRING.
*            REPLACE '&4' WITH MESSTAB-MSGV4 INTO L_MSTRING.
*          ELSE.
*            REPLACE '&' WITH MESSTAB-MSGV1 INTO L_MSTRING.
*            REPLACE '&' WITH MESSTAB-MSGV2 INTO L_MSTRING.
*            REPLACE '&' WITH MESSTAB-MSGV3 INTO L_MSTRING.
*            REPLACE '&' WITH MESSTAB-MSGV4 INTO L_MSTRING.
*          ENDIF.
*          CONDENSE L_MSTRING.
**          WRITE: / MESSTAB-MSGTYP, L_MSTRING(250).
**          WRITE : / 'Purchase text created for Material :' .
**          i_suc-matnr = wa_mm02-matnr.
*
*          IF MESSTAB-MSGTYP = 'S'.
*IT_SUC-MATNR = WA_MM02-MATNR.
*IT_SUC-MES = L_MSTRING..
*IT_SUC-TYPE = 'S'.
*APPEND IT_SUC.
*ELSEIF MESSTAB-MSGTYP = 'E'.
*IT_ERR-MATNR = WA_MM02-MATNR.
*IT_ERR-MES = L_MSTRING..
*IT_ERR-TYPE = 'E'.
*APPEND IT_ERR.
*ENDIF.
*        ENDIF.
*      ENDLOOP.

ENDFORM.                    " write_mes
*&---------------------------------------------------------------------*
*&      Form  DIS_MES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DIS_MES .

  IF IT_SUC[] IS NOT INITIAL.
    WRITE : / 'Material' , 20  'Type' ,  25 'Message' .
    LOOP AT IT_SUC.
      WRITE : / IT_SUC-MATNR, 20  IT_SUC-TYPE , 28  IT_SUC-MES.
    ENDLOOP.
  ENDIF.
  SKIP 3.
  IF IT_ERR[] IS NOT INITIAL.
    WRITE : / 'ERROR'  COLOR COL_NEGATIVE.
    WRITE : / 'Material' , 20 'Type' , 28  'Message' .
    LOOP AT IT_ERR.
      WRITE : / IT_ERR-MATNR, 20 IT_ERR-TYPE , 25  IT_ERR-MES.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " DIS_MES
*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.
*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
  IF FVAL <> NODATA.
    CLEAR BDCDATA.
    BDCDATA-FNAM = FNAM.
    BDCDATA-FVAL = FVAL.
    APPEND BDCDATA.
  ENDIF.
ENDFORM.
