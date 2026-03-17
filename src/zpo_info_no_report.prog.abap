*&---------------------------------------------------------------------*
*& Report ZPO_INFO_NO_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPO_INFO_NO_REPORT.


TABLES:ekko,ekpo.



TYPES :
        BEGIN OF ty_ekpo,
        ebeln TYPE ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
        LOEKZ TYPE ekpo-LOEKZ,
        MATNR TYPE ekpo-MATNR,
        WERKS TYPE ekpo-WERKS,
        INFNR TYPE ekpo-INFNR,
        END OF ty_ekpo,

        BEGIN OF ty_ekko,
        ebeln TYPE ekko-ebeln,
        BUKRS TYPE ekko-BUKRS,
        BSART TYPE ekko-BSART,
        LOEKZ TYPE ekko-LOEKZ,
        END OF ty_ekko,

        BEGIN OF ty_final,
        ebeln TYPE ekko-ebeln,
        ebelp TYPE ekpo-ebelp,
        MATNR TYPE ekpo-MATNR,
        BSART TYPE ekko-BSART,
        INFNR TYPE eine-INFNR,
        END OF ty_final,

        BEGIN OF ty_down,
        ebeln TYPE ekko-ebeln,
        ebelp TYPE ekpo-ebelp,
        MATNR TYPE ekpo-MATNR,
        BSART TYPE ekko-BSART,
        INFNR TYPE eine-INFNR,
        ref   TYPE char15,
        END OF ty_down.


DATA : it_ekko TYPE TABLE OF ty_ekko,
       wa_ekko TYPE          ty_ekko,

       it_ekpo TYPE TABLE OF ty_ekpo,
       wa_ekpo TYPE          ty_ekpo,
*       it_eine TYPE TABLE OF ty_eine,
*       wa_eine TYPE          ty_eine,
*
*       it_data TYPE TABLE OF ty_data,
*       wa_data TYPE          ty_data,

       it_final TYPE TABLE OF ty_final,
       wa_final TYPE          ty_final,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE          ty_down.

DATA : lt_fcat TYPE slis_t_fieldcat_alv,
       ls_fcat TYPE slis_fieldcat_alv.


SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS : s_ebeln FOR ekko-ebeln.

  PARAMETERS     : p_werks TYPE ekpo-werks OBLIGATORY DEFAULT 'PL01'.
SELECTION-SCREEN :END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE abc .
PARAMETERS : p_down   AS CHECKBOX,
             p_folder TYPE rlgrap-filename DEFAULT      '/Delval/India'.        "'/delval/temp'.
SELECTION-SCREEN END OF BLOCK b2.



START-OF-SELECTION.

PERFORM get_data.
PERFORM sort_data.
PERFORM fieldcat.
PERFORM display.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

SELECT ebeln
       ebelp
       LOEKZ
       MATNR
       WERKS
       INFNR FROM ekpo INTO TABLE it_ekpo
       WHERE ebeln IN s_ebeln
        AND  werks = p_werks
         AND loekz NE 'L'.

IF it_ekpo IS NOT INITIAL.
SELECT ebeln
       BUKRS
       BSART
       LOEKZ FROM ekko INTO TABLE it_ekko
       FOR ALL ENTRIES IN it_EKPO
       WHERE ebeln = it_EKPO-ebeln.
ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort_data .
LOOP AT it_ekpo INTO wa_ekpo.
  wa_final-ebeln = wa_ekpo-ebeln.
  wa_final-ebelp = wa_ekpo-ebelp.
  wa_final-MATNR = wa_ekpo-MATNR.
  wa_final-infnr = wa_ekpo-infnr.

READ TABLE it_ekko INTO wa_ekko WITH KEY ebeln = wa_ekpo-ebeln.
IF sy-subrc = 0.
  wa_final-bsart = wa_ekko-bsart.
ENDIF.


APPEND wa_final TO it_final.
CLEAR wa_final.
ENDLOOP.

IF p_down = 'X'.
  LOOP AT it_final INTO wa_final.

    wa_down-ebeln = wa_final-ebeln.
    wa_down-ebelp = wa_final-ebelp.
    wa_down-MATNR = wa_final-MATNR.
    wa_down-bsart = wa_final-bsart.
    wa_down-infnr = wa_final-infnr.

   CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

   APPEND WA_DOWN TO IT_DOWN.
   CLEAR WA_DOWN.

  ENDLOOP.
ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcat .

  PERFORM fcat USING : '1'   'EBELN'           'IT_FINAL'      'PO No.'                 '15',
                       '2'   'EBELP'           'IT_FINAL'      'Line Item'                   '15' ,
                       '3'   'MATNR'           'IT_FINAL'      'Material'                   '20' ,
                       '4'   'BSART'           'IT_FINAL'      'PO Type'                   '15' ,
                       '5'   'INFNR'           'IT_FINAL'      'Info Record.'                   '15' .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
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
      it_fieldcat        = lt_fcat
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
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


IF p_down = 'X'.

    PERFORM download.

ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0241   text
*      -->P_0242   text
*      -->P_0243   text
*      -->P_0244   text
*      -->P_0245   text
*----------------------------------------------------------------------*
FORM fcat  USING VALUE(p1)
                 VALUE(p2)
                 VALUE(p3)
                 VALUE(p4)
                 VALUE(p5).
*                 VALUE(p6).

  ls_fcat-col_pos       = p1.
  ls_fcat-fieldname     = p2.
  ls_fcat-tabname       = p3.
  ls_fcat-seltext_l     = p4.
  ls_fcat-outputlen     = p5.
*  ls_fcat-ref_fieldname = p6.

  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

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


    lv_file = 'ZPO_INFO.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPO_INFO REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_320 TYPE string.
DATA lv_crlf_320 TYPE string.
lv_crlf_320 = cl_abap_char_utilities=>cr_lf.
lv_string_320 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_320 lv_crlf_320 wa_csv INTO lv_string_320.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_565 TO lv_fullfile.
TRANSFER lv_string_320 TO lv_fullfile.
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


    lv_file = 'ZPO_INFO.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPO_INFO REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_357 TYPE string.
DATA lv_crlf_357 TYPE string.
lv_crlf_357 = cl_abap_char_utilities=>cr_lf.
lv_string_357 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_357 lv_crlf_357 wa_csv INTO lv_string_357.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_565 TO lv_fullfile.
TRANSFER lv_string_357 TO lv_fullfile.
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
FORM cvs_header USING    PD_CSV.         "p_hd_csv.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'PO No.'
              'Line Item'
              'Material Code'
              'PO Type'
              'Info Record.'
              'Refreshable Date'
              INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
