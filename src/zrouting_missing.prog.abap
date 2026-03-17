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
        ZSERIES TYPE MARA-ZSERIES,
        ZSIZE   TYPE MARA-ZSIZE,
        END OF TY_MARA,

        BEGIN OF TY_MARC,
        MATNR TYPE MARC-MATNR,
        BESKZ TYPE MARC-BESKZ,
        END OF TY_MARC,

        BEGIN OF TY_MAPL,
        MATNR TYPE MAPL-MATNR,
        PLNTY TYPE MAPL-PLNTY,
        LOEKZ TYPE MAPL-LOEKZ,
        END OF TY_MAPL,


        BEGIN OF TY_FINAL,
        MATNR TYPE MARA-MATNR,
        MTART TYPE MARA-MTART,
        ZSERIES TYPE MARA-ZSERIES,
        ZSIZE   TYPE MARA-ZSIZE,
        BESKZ TYPE MARC-BESKZ,
        mattxt      TYPE text100,
        END OF TY_FINAL,

        BEGIN OF ty_Down,
        MATNR   TYPE MARA-MATNR,
        mattxt  TYPE text100,
        ZSIZE   TYPE MARA-ZSIZE,
        ZSERIES TYPE MARA-ZSERIES,
        MTART   TYPE MARA-MTART,
        ref     TYPE char15,

        END OF ty_Down.


DATA: IT_MARA TYPE TABLE OF TY_MARA,
      WA_MARA TYPE          TY_MARA,

      IT_MARC TYPE TABLE OF TY_MARC,
      WA_MARC TYPE          TY_MARC,

      IT_MAPL TYPE TABLE OF TY_MAPL,
      WA_MAPL TYPE          TY_MAPL,

      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL,

      it_down TYPE TABLE OF ty_down,
      wa_down TYPE          ty_down.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT TYPE SLIS_FIELDCAT_ALV.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt  TYPE tline,
      ls_mattxt  TYPE tline.



SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : S_TYPE TYPE MARA-MTART OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
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
FORM get_data .
*BREAK fujiabap.


IF S_TYPE = 'FERT'.
  SELECT MATNR
         MTART
         ZSERIES
         ZSIZE FROM MARA INTO TABLE IT_MARA
         WHERE MTART = S_TYPE.



  IF IT_MARA IS NOT INITIAL.
   SELECT MATNR
          PLNTY
          LOEKZ
          FROM MAPL INTO TABLE IT_MAPL
          FOR ALL ENTRIES IN IT_MARA
          WHERE MATNR = IT_MARA-MATNR
          AND PLNTY eq 'N'
          and LOEKZ ne 'X'.

 ENDIF.


LOOP AT IT_maRA INTO WA_MARA.




WA_FINAL-MTART = WA_MARA-MTART.
 WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
 WA_FINAL-ZSIZE   =  WA_MARA-ZSIZE .
 WA_FINAL-MATNR = WA_MARA-MATNR.




CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = wa_FINAL-matnr.
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
      READ TABLE lv_lines INTO ls_mattxt INDEX 1.

WA_FINAL-mattxt = ls_mattxt-tdline.

APPEND WA_FINAL TO IT_FINAL.


loop at IT_MAPL INTO WA_MAPL WHERE MATNR =  wa_MARA-MATNR.

delete IT_FINAL WHERE MATNR EQ WA_MARA-MATNR .
endloop.
ENDLOOP.
ENDIF.
*ENDFORM.
**
IF S_TYPE = 'HALB'. "2
 SELECT MATNR
        MTART
        ZSERIES
        ZSIZE  FROM MARA INTO TABLE IT_MARA
        WHERE MTART = S_TYPE.
   IF  IT_MARA IS NOT INITIAL.
     SELECT MATNR
            BESKZ FROM MARC INTO TABLE IT_MARC
            FOR ALL ENTRIES IN IT_MARA
            WHERE MATNR = IT_MARA-MATNR
            AND BESKZ = 'X'.

   ENDIF.

   IF IT_MARC IS NOT INITIAL.
   SELECT MATNR
          PLNTY
          LOEKZ
          FROM MAPL INTO TABLE IT_MAPL
          FOR ALL ENTRIES IN IT_MARC
          WHERE MATNR = IT_MARC-MATNR
          AND PLNTY eq 'N'
           and LOEKZ ne 'X'.

 ENDIF.
* LOOP AT IT_MARA INTO WA_MARA.
 LOOP AT IT_MARc INTO WA_MARc.



*IF IT_MARC IS NOT INITIAL.
LOOP AT IT_MARA INTO WA_MARA WHERE MATNR = WA_MARC-MATNR.
     WA_FINAL-MATNR =  WA_MARA-MATNR.
     WA_FINAL-MTART   =  WA_MARA-MTART.
    WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
    WA_FINAL-ZSIZE   =  WA_MARA-ZSIZE .
*
*READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MARC-MATNR.
*  IF SY-SUBRC = 0.
*    WA_FINAL-MTART = WA_MARA-MTART.
*    WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
*    WA_FINAL-ZSIZE   =  WA_MARA-ZSIZE .
*  ENDIF.



CLEAR: lv_lines, ls_mattxt." 3
      REFRESH lv_lines.
      lv_name = wa_FINAL-matnr.
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
   READ TABLE lv_lines INTO ls_mattxt INDEX 1.

WA_FINAL-mattxt = ls_mattxt-tdline.

APPEND WA_FINAL TO IT_FINAL.
LOOP AT  IT_MAPL INTO WA_MAPL WHERE MATNR = WA_MARC-MATNR.

DELETE  IT_FINAL  WHERE MATNR = WA_MARC-MATNR.
ENDLOOP.
ENDLOOP.
*ENDIF.
ENDLOOP.
ENDIF.

IF  p_down = 'X'.
LOOP AT it_final INTO wa_final.
wa_down-MATNR    = wa_final-MATNR   .
wa_down-mattxt   = wa_final-mattxt  .
wa_down-ZSIZE    = wa_final-ZSIZE   .
wa_down-ZSERIES  = wa_final-ZSERIES .
wa_down-MTART    = wa_final-MTART   .




    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = wa_down-ref.

    CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                    INTO wa_down-ref SEPARATED BY '-'.
  APPEND wa_down TO it_down.
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
FORM get_fcat .
PERFORM fcat USING :   '1'  'MATNR'   'IT_FINAL'  'Item_Code'          '18',
                       '2'  'mattxt'   'IT_FINAL'  'Description'       '50',
                       '3'  'ZSIZE'   'IT_FINAL'  'Size'               '10',
                       '4'  'ZSERIES'   'IT_FINAL'  'Series'           '10',
                       '5'  'MTART'   'IT_FINAL'  'Mtl.Type'           '10'.
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
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
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
FORM get_display .
 CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = it_fcat

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

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = It_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.
  IF S_TYPE = 'FERT'.
    lv_file = 'ZROUTING_FERT.TXT'.
  ELSE.
    lv_file = 'ZROUTING_HALB.TXT'.
  ENDIF.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'Routing Missing Report', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_417 TYPE string.
DATA lv_crlf_417 TYPE string.
lv_crlf_417 = cl_abap_char_utilities=>cr_lf.
lv_string_417 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_417 lv_crlf_417 wa_csv INTO lv_string_417.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_879 TO lv_fullfile.
*TRANSFER lv_string_417 TO lv_fullfile.
TRANSFER lv_string_417 TO lv_fullfile.
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
  CONCATENATE 'Item_Code'
              'Description'
              'Size'
              'Series'
              'Mtl.Type'
              'Refresh File Date'
               INTO pd_csv
               SEPARATED BY l_field_seperator.

ENDFORM.
