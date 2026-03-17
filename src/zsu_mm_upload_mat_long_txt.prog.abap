*&---------------------------------------------------------------------*
*& Report ZUS_MM_UPLOAD_MAT_LONG_TXT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_MM_UPLOAD_MAT_LONG_TXT.

*>>
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS session RADIOBUTTON GROUP ctu.  "create session
SELECTION-SCREEN COMMENT 3(20) TEXT-s07 FOR FIELD session.
SELECTION-SCREEN POSITION 45.
PARAMETERS ctu RADIOBUTTON GROUP  ctu DEFAULT 'X'.     "call transaction
SELECTION-SCREEN COMMENT 48(20) TEXT-s08 FOR FIELD ctu.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 3(20) TEXT-s01 FOR FIELD group.
SELECTION-SCREEN POSITION 25.
PARAMETERS group(12).                      "group name of session
SELECTION-SCREEN COMMENT 48(20) TEXT-s05 FOR FIELD ctumode.
SELECTION-SCREEN POSITION 70.
PARAMETERS ctumode LIKE ctu_params-dismode DEFAULT 'N'.
"A: show all dynpros
"E: show dynpro on error only
"N: do not display dynpro
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 3(20) TEXT-s02 FOR FIELD user.
SELECTION-SCREEN POSITION 25.
PARAMETERS: user(12) DEFAULT sy-uname.     "user for session in batch
SELECTION-SCREEN COMMENT 48(20) TEXT-s06 FOR FIELD cupdate.
SELECTION-SCREEN POSITION 70.
PARAMETERS cupdate LIKE ctu_params-updmode DEFAULT 'L'.
"S: synchronously
"A: asynchronously
"L: local
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 3(20) TEXT-s03 FOR FIELD keep.
SELECTION-SCREEN POSITION 25.
PARAMETERS: keep AS CHECKBOX.       "' ' = delete session if finished
"'X' = keep   session if finished
SELECTION-SCREEN COMMENT 48(20) TEXT-s09 FOR FIELD e_group.
SELECTION-SCREEN POSITION 70.
PARAMETERS e_group(12).             "group name of error-session
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 3(20) TEXT-s04 FOR FIELD holddate.
SELECTION-SCREEN POSITION 25.
PARAMETERS: holddate LIKE sy-datum.
SELECTION-SCREEN COMMENT 51(17) TEXT-s02 FOR FIELD e_user.
SELECTION-SCREEN POSITION 70.
PARAMETERS: e_user(12) DEFAULT sy-uname.    "user for error-session
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 51(17) TEXT-s03 FOR FIELD e_keep.
SELECTION-SCREEN POSITION 70.
PARAMETERS: e_keep AS CHECKBOX.     "' ' = delete session if finished
"'X' = keep   session if finished
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 51(17) TEXT-s04 FOR FIELD e_hdate.
SELECTION-SCREEN POSITION 70.
PARAMETERS: e_hdate LIKE sy-datum.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(33) TEXT-s10 FOR FIELD nodata.
PARAMETERS: nodata DEFAULT '/' LOWER CASE.          "nodata
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(33) TEXT-s11 FOR FIELD smalllog.
PARAMETERS: smalllog AS CHECKBOX.  "' ' = log all transactions
"'X' = no transaction logging
SELECTION-SCREEN END OF LINE.

*>>
*----------------------------------------------------------------------*
*   data definition
*----------------------------------------------------------------------*
*       Batchinputdata of single transaction
DATA:   bdcdata LIKE bdcdata    OCCURS 0 WITH HEADER LINE.
*       messages of call transaction
DATA:   messtab LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE.
*       error session opened (' ' or 'X')
DATA:   e_group_opened.
*       message texts
TABLES: t100.

*Data declaration
  DATA : BEGIN OF it_mm02 OCCURS 0,
*    WERKS TYPE MARC-WERKS,
           matnr TYPE mara-matnr,
           text  TYPE tdline,
         END OF it_mm02.

  DATA : wa_mm02 LIKE  it_mm02.

*SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
*SELECTION-SCREEN BEGIN OF LINE.
*PARAMETERS p_input LIKE rlgrap-filename ."OBLIGATORY . " Input File
*SELECTION-SCREEN :END OF BLOCK b1.

  DATA : it_head     TYPE TABLE OF  bapimathead  WITH HEADER LINE,
         v_kzsel(20),

         it_ret      LIKE STANDARD   TABLE OF   bapiret2,
         it_plant    TYPE TABLE OF bapi_marc WITH HEADER LINE.


*DATA : IT_RET1 LIKE  LINE OF  IT_RET .
*IT_TEXT-APPLOBJECT  = 'MATERIAL'.
*IT_TEXT-TEXT_NAME  = WA_MM02-MATNR.
*IT_TEXT-TEXT_ID  = 'BEST'.
*IT_TEXT-LANGU = 'EN'.
*IT_TEXT-TEXT_LINE = WA_MM02-TEXT.
*APPEND IT_TEXT.
*CLEAR IT_TEXT.

  DATA: BEGIN OF it_suc OCCURS 0,
          mes(280) TYPE c,
          type     TYPE char1,
          matnr    TYPE mara-matnr,
        END OF it_suc.

  DATA: BEGIN OF it_err OCCURS 0,
          mes(280) TYPE c,
          type     TYPE char1,
          matnr    TYPE mara-matnr,
        END OF it_err.

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
  IF session = 'X' AND
     group = space OR user = space.
    MESSAGE e613(ms).
  ENDIF.


START-OF-SELECTION.
  DATA: wa_file-matnr     TYPE matnr,
        wa_file-text_line TYPE char200. " ZMdata-long_text.
*Read values  from memory
  IMPORT wa_file-matnr wa_file-text_line FROM MEMORY ID 'zmat'.

*sort it_mm02 by werks matnr.
*LOOP AT IT_MM02 INTO WA_MM02.
  DATA: v_index(3) .
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

  PERFORM write_text.            .
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
FORM f_upload .
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
FORM write_text .
  DATA : it_header  TYPE TABLE OF thead WITH HEADER LINE,
         it_line    TYPE TABLE OF tline WITH HEADER LINE,
         l_name(70).

  it_header-tdobject =  'MATERIAL'.
  it_header-tdname = wa_file-matnr.
  it_header-tdid = 'GRUN'.
  it_header-tdspras =  'E'.
  APPEND it_header.
  CLEAR it_header.
*TDTITLE *TDFORM *TDSTYLE

  it_line-tdformat = 'ST'.
  it_line-tdline = wa_file-text_line.
  APPEND it_line.
  CLEAR it_line.
  READ TABLE it_header.
  READ TABLE it_line.
  MOVE  wa_file-matnr TO l_name.

  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = l_name
    IMPORTING
      output = l_name.

  CALL FUNCTION 'CREATE_TEXT'
    EXPORTING
      fid         = 'GRUN' "L_ID
      flanguage   = sy-langu
      fname       = l_name
      fobject     = 'MATERIAL' "W_OBJECT
      save_direct = 'X'
*     FFORMAT     = '*'
    TABLES
      flines      = it_line
    EXCEPTIONS
      no_init     = 1
      no_save     = 2
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
FORM get_view USING matnr  CHANGING index.
  DATA : it_bild TYPE TABLE OF mbildtab WITH HEADER LINE.

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
FORM write_mes USING matnr .
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
FORM dis_mes .

  IF it_suc[] IS NOT INITIAL.
    WRITE : / 'Material' , 20  'Type' ,  25 'Message' .
    LOOP AT it_suc.
      WRITE : / it_suc-matnr, 20  it_suc-type , 28  it_suc-mes.
    ENDLOOP.
  ENDIF.
  SKIP 3.
  IF it_err[] IS NOT INITIAL.
    WRITE : / 'ERROR'  COLOR COL_NEGATIVE.
    WRITE : / 'Material' , 20 'Type' , 28  'Message' .
    LOOP AT it_err.
      WRITE : / it_err-matnr, 20 it_err-type , 25  it_err-mes.
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
