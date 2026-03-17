*&---------------------------------------------------------------------*
*& Report ZDIRECT_BOMS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDIRECT_BOMS.



TYPES : BEGIN OF TY_FINAL,
    MATNR TYPE MARC-MATNR,
    MAKTX TYPE MAKT-MAKTX,
    STLNR TYPE MAST-STLNR,
    IDNRK TYPE STPO-IDNRK,
   MAKTX2 TYPE MAKT-MAKTX,
   MENGE TYPE STPO-MENGE,
  STLST TYPE C LENGTH 10,
   ref         TYPE char15,
  time        TYPE char10,


  END OF TY_FINAL.


TYPES : BEGIN OF TY_DOWN,
    MATNR TYPE MARC-MATNR,
    MAKTX TYPE MAKT-MAKTX,
    STLNR TYPE MAST-STLNR,
    IDNRK TYPE STPO-IDNRK,
   MAKTX2 TYPE MAKT-MAKTX,
   MENGE TYPE STPO-MENGE,
  STLST TYPE C LENGTH 10,
ref         TYPE char15,
          time        TYPE char10,


  END OF TY_DOWN.


  DATA: it_fcat  TYPE slis_t_fieldcat_alv,
      wa_fcat  LIKE LINE OF it_fcat,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final.
DATA:it_down TYPE TABLE OF ty_down,
     wa_down TYPE          ty_down.



SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_werks TYPE MARC-werks.
SELECTION-SCREEN : END OF BLOCK b1.



SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.


SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.




START-OF-SELECTION.

PERFORM get_data.
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
*BREAK primus.

SELECT MATNR , WERKS , BESKZ ,SOBSL FROM MARC INTO TABLE @DATA(IT_MARC)
  WHERE WERKS = @P_WERKS
  AND BESKZ = 'F'
  AND SOBSL = ''.

SELECT MATNR , MTART FROM MARA INTO TABLE @DATA(IT_MARA)
FOR ALL ENTRIES IN @IT_MARC
WHERE MATNR = @IT_MARC-MATNR.
*AND   MTART = 'HALB' or MTART = 'FERT'.
DELETE IT_MARA WHERE MTART <> 'HALB' AND MTART <> 'FERT'.
  SELECT matnr , maktx FROM makt INTO TABLE @DATA(it_makt)
    FOR ALL ENTRIES IN @it_mara
    WHERE MATNR = @IT_mara-matnr.

    SELECT matnr , stlnr FROM mast INTO TABLE @DATA(it_mast)
      FOR ALL ENTRIES IN @it_mara
    WHERE MATNR = @IT_mara-matnr.

      SELECT idnrk , stlnr , menge FROM stpo INTO TABLE @DATA(it_stpo)
        FOR ALL ENTRIES IN @it_mast
        WHERE stlnr = @it_mast-stlnr.

SELECT matnr , maktx FROM makt INTO TABLE @DATA(it_makt2)
    FOR ALL ENTRIES IN @it_stpo
    WHERE MATNR = @IT_stpo-idnrk.


SELECT stlnr , stlst FROM stko INTO TABLE @DATA(it_stko)
 FOR ALL ENTRIES IN @it_mast
  WHERE stlnr = @it_mast-stlnr.




****************** READ DATA *********************************

*BREAK PRIMUS.

LOOP AT IT_MARA INTO DATA(WA_MARA).
  WA_FINAL-MATNR = WA_MARA-MATNR.

  READ TABLE IT_MAKT INTO DATA(WA_MAKT) WITH KEY MATNR = WA_FINAL-MATNR.
  WA_FINAL-MAKTX = WA_MAKT-MAKTX.

  READ TABLE IT_MAST INTO DATA(WA_MAST) WITH KEY MATNR =  WA_FINAL-MATNR.
  WA_FINAL-STLNR = WA_MAST-STLNR.


*READ TABLE IT_STPO INTO DATA(WA_STPO) WITH KEY STLNR = WA_FINAL-STLNR.
LOOP AT IT_STPO INTO DATA(WA_STPO) WHERE STLNR = WA_FINAL-STLNR.

WA_FINAL-IDNRK = WA_STPO-IDNRK.
WA_FINAL-MENGE = WA_STPO-MENGE.


READ TABLE IT_MAKT2 INTO DATA(WA_MAKT2) WITH KEY MATNR = WA_FINAL-IDNRK.
WA_FINAL-MAKTX2 = WA_MAKT2-MAKTX.



READ TABLE IT_STKO INTO DATA(WA_STKO) WITH KEY STLNR = WA_FINAL-STLNR.

WA_FINAL-STLST   = WA_STKO-STLST.

IF  wa_final-STLST = '01'.

  wa_final-STLST = 'ACTIVE'.

ELSE.

  wa_final-STLST = 'INACTIVE'.
ENDIF.



CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_FINAL-ref.

      CONCATENATE wa_FINAL-ref+0(2) wa_FINAL-ref+2(3) wa_FINAL-ref+5(4)
                      INTO wa_final-ref SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO wa_final-time SEPARATED BY ':'.



APPEND WA_FINAL TO IT_FINAL.


ENDLOOP.
CLEAR : WA_FINAL, wa_mast.


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

 PERFORM fcat USING :     '1'   'MATNR'           'IT_FINAL'      'Master Code.'                           '18' ,
                           '2'   'MAKTX'           'IT_FINAL'      'Description'                             '40',
                           '3'   'STLNR'            'IT_FINAL'       'BOM No,'                           '18' ,

                           '4'   'IDNRK'           'IT_FINAL'      'Child Code'                        '18' ,
                           '5'   'MAKTX2'           'IT_FINAL'      'Description'                       '40' ,
                           '6'   'MENGE'             'IT_FINAL'      'Quantity'                           '18' ,
                           '7'   'STLST'             'IT_FINAL'      'BOM Status'                           '18' .
*                           '8'   'CONSIGNEE'              'IT_FINAL'      'Consignee'                            '18' ,
*                           '9'   'BUYER'                'IT_FINAL'      'Buyer'                            '18' ,
*                          '10'   'VHILM_KU'          'IT_FINAL'      'Marks & Nos'                                 '18' .
*



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


***********************DISPLAY ************************



CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = SY-REPID
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
   IT_FIELDCAT                       = IT_FCAT
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    t_outtab                          = IT_FINAL.
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


IF p_down = 'X'.


  IT_DOWN[] = IT_FINAL[].


    PERFORM download.

  ENDIF.




ENDFORM.




FORM fcat  USING   VALUE(p1)
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
*
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


  lv_file = 'ZDIRECT_BOM.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZDIRECT_BOM_REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_369 TYPE string.
DATA lv_crlf_369 TYPE string.
lv_crlf_369 = cl_abap_char_utilities=>cr_lf.
lv_string_369 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_369 lv_crlf_369 wa_csv INTO lv_string_369.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_619 TO lv_fullfile.
TRANSFER lv_string_369 TO lv_fullfile.
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


  lv_file = 'ZDIRECT_BOM.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZDIRECT_BOM_REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_407 TYPE string.
DATA lv_crlf_407 TYPE string.
lv_crlf_407 = cl_abap_char_utilities=>cr_lf.
lv_string_407 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_407 lv_crlf_407 wa_csv INTO lv_string_407.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_619 TO lv_fullfile.
TRANSFER lv_string_407 TO lv_fullfile.
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
FORM cvs_header  USING    hd_csv.

DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Master Code.'
               'Description'
                 'BOM No,'
               'Child Code'
                'Description'
                 'Quantity'
                 'BOM Status'
                  'Refresh Date'
                   'Refresh Time'
              INTO Hd_csv
                SEPARATED BY l_field_seperator.



ENDFORM.







*ENDFORM.
