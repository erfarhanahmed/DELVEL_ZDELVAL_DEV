

REPORT ZMAT_SPAN_TEXT_CHANGE_BDC.

TYPES: BEGIN OF TY_ITAB ,
       MATNR(18)    TYPE C,
       MTART(04)    TYPE C,
       WERKS(04)    TYPE C,
       LMAKTX(2500) TYPE C,
*       LMAKTX TYPE string,
       ROW TYPE I,
       TSIZE TYPE I,
   END OF TY_ITAB.

TYPES : BEGIN OF ty_text,
*        ebeln(10)    TYPE C,
        text TYPE char255,
        END OF ty_text.
        DATA : lt_text TYPE TABLE OF ty_text,
               ls_text TYPE ty_text.

DATA : BEGIN OF i_error OCCURS 0 ,
         matnr     TYPE matnr,
         l_mstring TYPE string,
         msg       TYPE char20,
         ref       TYPE char15,
         time      TYPE char10,
       END OF i_error .



DATA : lv_matnr TYPE mara-matnr,
       lv_mtart TYPE mara-mtart,
       wa_mara  TYPE mara.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline.

*  Data Declarations - Internal Tables
DATA: I_TAB  TYPE STANDARD TABLE OF TY_ITAB  INITIAL SIZE 0,
      WA TYPE TY_ITAB ,
      IT_EXLOAD LIKE ZALSMEX_TABLINE  OCCURS 0 WITH HEADER LINE.

DATA: size TYPE i.
DATA: IT_LINES       LIKE STANDARD TABLE OF TLINE WITH HEADER LINE,
      IT_TEXT_HEADER LIKE STANDARD TABLE OF THEAD WITH HEADER LINE,
      P_ERROR TYPE  SY-LISEL ,
      LEN TYPE I .

DATA:gt_fldcat             TYPE STANDARD TABLE OF slis_fieldcat_alv,
     gwa_fldcat            TYPE slis_fieldcat_alv.
*    Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-002.
PARAMETERS:PFILE TYPE RLGRAP-FILENAME OBLIGATORY.
*           W_BEGIN TYPE I OBLIGATORY,
*           W_END TYPE I OBLIGATORY.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX DEFAULT 'X'.
*PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT  '/Delval/India'."India'."temp/item_master'." '/delval/temp/item_master_'  .                 "'/delval/temp/item_master'.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT  '/Delval/India/Item_Master/'."India'."temp/item_master'." '/delval/temp/item_master_'  .                 "'/delval/temp/item_master'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-001.
PARAMETERS: p_a RADIOBUTTON GROUP grp1 DEFAULT 'X',
            p_b RADIOBUTTON GROUP grp1..
SELECTION-SCREEN END OF BLOCK b3.

AT SELECTION-SCREEN.
  IF PFILE IS INITIAL.
    MESSAGE S368(00) WITH 'Please input filename'. STOP.
  ENDIF.


AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name EQ 'P_DOWN'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.

    IF screen-name EQ 'P_FOLDER'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  REFRESH:I_TAB.

  PERFORM EXCEL_DATA_INT_TABLE.
  PERFORM EXCEL_TO_INT.
  PERFORM error_log .
  PERFORM error_display.



*  PERFORM CONTOL_PARAMETER.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR PFILE.
  PERFORM F4_FILENAME.
*&---------------------------------------------------------------------*
*&      Form  F4_FILENAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F4_FILENAME .
  CALL FUNCTION 'F4_FILENAME'
  EXPORTING
    PROGRAM_NAME        = SYST-CPROG
    DYNPRO_NUMBER       = SYST-DYNNR
*   FIELD_NAME          = ' '
  IMPORTING
    FILE_NAME           = PFILE
           .
ENDFORM.                    " F4_FILENAME
*&---------------------------------------------------------------------*
*&      Form  EXCEL_DATA_INT_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM EXCEL_DATA_INT_TABLE .
IF p_a = 'X'.
  CALL FUNCTION 'ZALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      FILENAME    = PFILE
      I_BEGIN_COL = '0001'
      I_BEGIN_ROW = '0002'
      I_END_COL   = '0004'
      I_END_ROW   = '0501'                                   "65536
    TABLES
      INTERN      = IT_EXLOAD.

  LOOP AT IT_EXLOAD .
    CASE  IT_EXLOAD-COL.
      WHEN '0001'.
        WA-matnr   = IT_EXLOAD-VALUE.
      WHEN '0002'.
        WA-mtart   = IT_EXLOAD-VALUE.
      WHEN '0003'.
        WA-werks   = IT_EXLOAD-VALUE.
      WHEN '0004'.
        WA-LMAKTX   = IT_EXLOAD-VALUE.
    ENDCASE.
    AT END OF ROW.
      WA-TSIZE = STRLEN( WA-LMAKTX ) .
      WA-ROW = IT_EXLOAD-ROW .
      APPEND WA TO I_TAB.
      CLEAR WA .
    ENDAT.
  ENDLOOP.
else.
  DATA: l_wa_raw_data TYPE string,
        v_str                 TYPE string.
  v_str = pfile.
  OPEN DATASET v_str FOR INPUT IN TEXT MODE ENCODING NON-UNICODE.
  IF sy-subrc = 0.
    DO.
      READ DATASET v_str INTO l_wa_raw_data.
      IF sy-subrc = 0.

        SPLIT l_wa_raw_data AT cl_abap_char_utilities=>horizontal_tab INTO :
         WA-matnr
         WA-mtart
         WA-werks
         WA-LMAKTX .
        APPEND WA TO I_TAB.
      CLEAR WA .
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

ENDIF.
ENDIF.
ENDFORM.                    " EXCEL_DATA_INT_TABLE
*&---------------------------------------------------------------------*
*&      Form  EXCEL_TO_INT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM EXCEL_TO_INT .


  LOOP AT IT_EXLOAD .
    CASE  IT_EXLOAD-COL.
      WHEN '0001'.
        WA-matnr   = IT_EXLOAD-VALUE.
      WHEN '0002'.
        WA-mtart   = IT_EXLOAD-VALUE.
      WHEN '0003'.
        WA-werks   = IT_EXLOAD-VALUE.
      WHEN '0004'.
        WA-LMAKTX   = IT_EXLOAD-VALUE.
    ENDCASE.
    AT END OF ROW.
      WA-TSIZE = STRLEN( WA-LMAKTX ) .
      WA-ROW = IT_EXLOAD-ROW .
      APPEND WA TO I_TAB.
      CLEAR WA .
    ENDAT.
  ENDLOOP.



LOOP AT i_tab INTO wa.

  SELECT SINGLE matnr FROM mara INTO lv_matnr
      WHERE matnr = wa-matnr.
  IF sy-subrc = 0.

    SELECT SINGLE * FROM mara INTO wa_mara
      WHERE matnr = wa-matnr AND mtart = wa-mtart.
   IF sy-subrc = 0.
     CLEAR: lv_lines,lv_name.
    REFRESH lv_lines.
    lv_name = wa-matnr.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = 'S'
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
    IF  lv_lines IS INITIAL.



    SPLIT wa-LMAKTX AT CL_ABAP_CHAR_UTILITIES=>NEWLINE INTO TABLE lt_text .

    IT_TEXT_HEADER-TDID     = 'GRUN'.
    IT_TEXT_HEADER-TDSPRAS  = 'S' .
    IT_TEXT_HEADER-TDNAME   = WA-matnr.
    IT_TEXT_HEADER-TDOBJECT = 'MATERIAL'.

*    MOVE WA-TSIZE TO LEN .

*    LEN =  LEN / 70  + 1.

*    DO LEN TIMES .
LOOP AT lt_text INTO ls_text.
*  SIZE = STRLEN( ls_text-text ) .


*    DO size TIMES.
      MOVE '*' TO IT_LINES-TDFORMAT.
      MOVE  ls_text-text TO IT_LINES-TDLINE .
      SHIFT IT_LINES-TDLINE LEFT DELETING LEADING ' '.

      SHIFT IT_LINES-TDLINE LEFT DELETING LEADING ' " '.
      SHIFT IT_LINES-TDLINE RIGHT DELETING TRAILING ' " '.
      CONDENSE IT_LINES-TDLINE.

*      OFF = OFF + 70 .
      APPEND IT_LINES.
      CLEAR IT_LINES .
*    ENDDO.
ENDLOOP.
*    AT END OF ROW.
      CALL FUNCTION 'SAVE_TEXT'
        EXPORTING
          CLIENT          = SY-MANDT
          HEADER          = IT_TEXT_HEADER
          INSERT          = ' '
          SAVEMODE_DIRECT = 'X'
        TABLES
          LINES           = IT_LINES
        EXCEPTIONS
          ID              = 1
          LANGUAGE        = 2
          NAME            = 3
          OBJECT          = 4
          OTHERS          = 5.
* Check the Return Code
      IF SY-SUBRC = 0.
         MOVE wa-matnr TO i_error-matnr.
           i_error-l_mstring = 'Material Changed'.
           i_error-msg       = 'Changed'.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = sy-datum
        IMPORTING
          OUTPUT = i_error-REF.

      CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                      INTO i_error-REF SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.

*        MESSAGE ID SY-MSGID TYPE SY-MSGTY
*            NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4 INTO P_ERROR.
           APPEND i_error .
           CLEAR i_error.
        ELSE.
          MOVE wa-matnr TO i_error-matnr.
           i_error-l_mstring = 'Material Not Changed'.
           i_error-msg       = 'Error'.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = sy-datum
        IMPORTING
          OUTPUT = i_error-REF.

      CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                      INTO i_error-REF SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.

           APPEND i_error .
           CLEAR i_error.
      ENDIF.
      CLEAR: WA ,LEN ,ls_text,lv_matnr.
      REFRESH :IT_LINES ,lt_text.

  ELSE.
           MOVE wa-matnr TO i_error-matnr.
           i_error-l_mstring = 'Text Already Created'.
           i_error-msg       = 'Not Created'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = sy-datum
        IMPORTING
          OUTPUT = i_error-REF.

      CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                      INTO i_error-REF SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.


           APPEND i_error .
           CLEAR i_error.
  ENDIF.


   ELSE.
           MOVE wa-matnr TO i_error-matnr.
           i_error-l_mstring = 'Material Type Different'.
           i_error-msg       = 'Different'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = sy-datum
        IMPORTING
          OUTPUT = i_error-REF.

      CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                      INTO i_error-REF SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.


           APPEND i_error .
           CLEAR i_error.
ENDIF.

 ELSE.
           MOVE wa-matnr TO i_error-matnr.
           i_error-l_mstring = 'Material Is Not Created'.
           i_error-msg       = 'Not Created'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = sy-datum
        IMPORTING
          OUTPUT = i_error-REF.

      CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                      INTO i_error-REF SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.


           APPEND i_error .
           CLEAR i_error.
ENDIF.


  ENDLOOP.



ENDFORM.                    " EXCEL_TO_INT
*&---------------------------------------------------------------------*
*&      Form  ERROR_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ERROR_LOG .
REFRESH: gt_fldcat.

  gwa_fldcat-COL_POS    = '1'.
  gwa_fldcat-fieldname  = 'MATNR'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = 'Material'.
  gwa_fldcat-seltext_m  = 'Material'.
  gwa_fldcat-seltext_s  = 'Material'.
  gwa_fldcat-outputlen  = '000018'.

  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.
  gwa_fldcat-COL_POS    = '2'.
  gwa_fldcat-fieldname  = 'L_MSTRING'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = ' Message'.
*  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
  gwa_fldcat-outputlen  = '000030'.
  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.

  gwa_fldcat-COL_POS    = '3'.
  gwa_fldcat-fieldname  = 'MSG'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = 'Status'.
*  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
  gwa_fldcat-outputlen  = '000020'.

  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.

  gwa_fldcat-COL_POS    = '4'.
  gwa_fldcat-fieldname  = 'REF'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = 'Refresh Date'.
*  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
  gwa_fldcat-outputlen  = '000020'.

  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.

  gwa_fldcat-COL_POS    = '5'.
  gwa_fldcat-fieldname  = 'TIME'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = 'Time'.
*  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
  gwa_fldcat-outputlen  = '000010'.

  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ERROR_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ERROR_DISPLAY .
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     is_layout   = gwa_layout_col
      I_CALLBACK_PROGRAM = SY-REPID
      it_fieldcat = gt_fldcat
    TABLES
      t_outtab    = i_error.

IF P_DOWN = 'X'.
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
      I_TAB_SAP_DATA       = I_error
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  LV_FILE = 'SPAN_TEXT.TXT'.


  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZMATERIAL started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_501 TYPE string.
DATA lv_crlf_501 TYPE string.
lv_crlf_501 = cl_abap_char_utilities=>cr_lf.
lv_string_501 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_501 lv_crlf_501 wa_csv INTO lv_string_501.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
TRANSFER lv_string_501 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


******************************
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = I_error
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  LV_FILE = 'SPAN_TEXT.TXT'.


  CONCATENATE P_FOLDER '/'  LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZMATERIAL started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_540 TYPE string.
DATA lv_crlf_540 TYPE string.
lv_crlf_540 = cl_abap_char_utilities=>cr_lf.
lv_string_540 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_540 lv_crlf_540 wa_csv INTO lv_string_540.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
TRANSFER lv_string_540 TO lv_fullfile.
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
  CONCATENATE  'Material'
               'Message'
               'Status'
               'Refresh Date'
               'Time'
              INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
