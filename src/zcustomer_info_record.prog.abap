*&---------------------------------------------------------------------*
*& Report ZCUSTOMER_INFO_RECORD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCUSTOMER_INFO_RECORD.


TABLES:KNMT.

TYPES : BEGIN OF TY_KNMT,
        VKORG  TYPE KNMT-VKORG,
        VTWEG  TYPE KNMT-VTWEG,
        KUNNR  TYPE KNMT-KUNNR,
        MATNR  TYPE KNMT-MATNR,
        ERNAM  TYPE KNMT-ERNAM,
        ERDAT  TYPE KNMT-ERDAT,
        KDMAT  TYPE KNMT-KDMAT,
        END OF ty_knmt,

        BEGIN OF ty_final,
        VKORG  TYPE char10,
        VTWEG  TYPE char10,
        KUNNR  TYPE char10,
        MATNR  TYPE char20,
        ERNAM  TYPE char15,
        ERDAT  TYPE char15,
        KDMAT  TYPE char50,
        ref    TYPE char15,
        END OF ty_final.

DATA : it_knmt TYPE TABLE OF ty_knmt,
       wa_knmt TYPE          ty_knmt,

       it_final TYPE TABLE OF ty_final,
       wa_final TYPE          ty_final.

DATA: it_fcat type slis_t_fieldcat_alv,
      wa_fcat like line of it_fcat.


SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS : s_KUNNR FOR knmt-KUNNR,
                   s_matnr FOR knmt-matnr.
  PARAMETERS     : p_vkorg TYPE knmt-vkorg OBLIGATORY DEFAULT '1000'.
SELECTION-SCREEN : END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.


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
  SELECT VKORG
         VTWEG
         KUNNR
         MATNR
         ERNAM
         ERDAT
         KDMAT FROM knmt INTO TABLE it_knmt
         WHERE kunnr IN s_kunnr
           AND matnr IN s_matnr
           AND vkorg = p_vkorg.


LOOP AT it_knmt INTO wa_knmt.
 wa_final-VKORG = wa_knmt-VKORG.
 wa_final-VTWEG = wa_knmt-VTWEG.
 wa_final-KUNNR = wa_knmt-KUNNR.
 wa_final-MATNR = wa_knmt-MATNR.
 wa_final-ERNAM = wa_knmt-ERNAM.
 wa_final-ERDAT = wa_knmt-ERDAT.
 wa_final-KDMAT = wa_knmt-KDMAT.


IF wa_knmt-ERDAT IS NOT INITIAL.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_knmt-ERDAT
      IMPORTING
        output = wa_final-ERDAT.

    CONCATENATE wa_final-ERDAT+0(2) wa_final-ERDAT+2(3) wa_final-ERDAT+5(4)
                    INTO wa_final-ERDAT SEPARATED BY '-'.
ENDIF.




 CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = wa_final-ref.

    CONCATENATE wa_final-ref+0(2) wa_final-ref+2(3) wa_final-ref+5(4)
                    INTO wa_final-ref SEPARATED BY '-'.






 APPEND wa_final TO it_final.
 clear wa_final.


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
PERFORM FCAT USING : '1'   'VKORG'           'IT_FINAL'      'Sales Organization'                 '20' ,
                     '2'   'VTWEG'           'IT_FINAL'      'Distribution Channel'        '20' ,
                     '3'   'KUNNR'           'IT_FINAL'      'Customer number'        '20' ,
                     '4'   'MATNR'           'IT_FINAL'      'Material Number'        '20' ,
                     '5'   'ERNAM'           'IT_FINAL'      'Created By'              '20' ,
                     '6'   'ERDAT'           'IT_FINAL'      'Created Date'            '20' ,
                     '7'   'KDMAT'           'IT_FINAL'      'Customer Material'        '20' .
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

*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1083   text
*      -->P_1084   text
*      -->P_1085   text
*      -->P_1086   text
*      -->P_1087   text
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


    lv_file = 'ZCUSTOMER_INFO_RECORD.TXT'.


  CONCATENATE p_folder '/'  lv_file
    INTO lv_fullfile.

  WRITE: / 'ZCUSTOMER_INFO_RECORD REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_296 TYPE string.
DATA lv_crlf_296 TYPE string.
lv_crlf_296 = cl_abap_char_utilities=>cr_lf.
lv_string_296 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_296 lv_crlf_296 wa_csv INTO lv_string_296.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_565 TO lv_fullfile.
TRANSFER lv_string_296 TO lv_fullfile.
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
CONCATENATE 'Sales Organization'
            'Distribution Channel'
            'Customer number'
            'Material Number'
            'Created By'
            'Created Date'
            'Customer Material'
            'Refresh Date'

              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.
