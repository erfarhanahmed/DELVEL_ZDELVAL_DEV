*&---------------------------------------------------------------------*
*& Report ZPRD_USERS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprd_users.

TABLES : usr02,usr06.

TYPES : BEGIN OF ty_final,

          mandt     TYPE mandt,
          bname     TYPE usr02-bname,
          lic_type  TYPE usr06-lic_type,
          type      TYPE char25,
          ustyp     TYPE usr02-ustyp,
          text      TYPE char25,
          trdat     TYPE char15, "usr02-TRDAT ,
          ltime     TYPE usr02-ltime,
          gltgv     TYPE char15, "usr02-GLTGV ,
          gltgb     TYPE char15, "usr02-GLTGB,
          ref       TYPE char15,
          time      TYPE char8,"""char10,
          name_text TYPE char80,


        END OF ty_final.

DATA : it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final.
DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat,
      it_down TYPE TABLE OF ty_final,
      wa_down TYPE          ty_final.

DATA : v_name_text TYPE user_addrs-name_text.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS : s_bname FOR usr02-bname.

SELECTION-SCREEN : END OF BLOCK b1 .


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.



SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.


SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-006.
SELECTION-SCREEN END OF LINE.



START-OF-SELECTION .

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



  SELECT mandt , bname , ustyp, trdat , ltime, gltgv ,gltgb FROM usr02 INTO TABLE @DATA(it_usr02)
  WHERE bname IN @s_bname.


  SELECT bname , lic_type FROM usr06  INTO TABLE @DATA(it_usr06) FOR ALL ENTRIES IN @it_usr02
    WHERE bname = @it_usr02-bname.


******************read data ********************

  LOOP AT it_usr02 INTO DATA(wa_usr02) .
    wa_final-mandt = wa_usr02-mandt.
    wa_final-bname = wa_usr02-bname.
    wa_final-ustyp = wa_usr02-ustyp.



    IF wa_final-ustyp = 'A'.
      wa_final-text = 'Dailog'.

    ELSEIF wa_final-ustyp = 'B'.
      wa_final-text = 'System'.
    ELSEIF wa_final-ustyp = 'C'.
      wa_final-text = 'Communication Data'.
    ELSEIF wa_final-ustyp = 'L'.
      wa_final-text = 'Reference (Logon not possible) '.

    ELSEIF wa_final-ustyp = 'S'.
      wa_final-text = 'Service '.


    ENDIF.

    wa_final-trdat = wa_usr02-trdat.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-trdat
      IMPORTING
        output = wa_final-trdat.

    CONCATENATE wa_final-trdat+0(2) wa_final-trdat+2(3) wa_final-trdat+5(4)
                    INTO wa_final-trdat SEPARATED BY '-'.


    IF wa_final-trdat = '--'.
      wa_final-trdat = ''.

    ENDIF.


    wa_final-ltime = wa_usr02-ltime.
    wa_final-gltgv = wa_usr02-gltgv.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-gltgv
      IMPORTING
        output = wa_final-gltgv.

    CONCATENATE wa_final-gltgv+0(2) wa_final-gltgv+2(3) wa_final-gltgv+5(4)
                    INTO wa_final-gltgv SEPARATED BY '-'.


    IF wa_final-gltgv = '--'.
      wa_final-gltgv = ''.

    ENDIF.

    wa_final-gltgb = wa_usr02-gltgb.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = wa_final-gltgb
      IMPORTING
        output = wa_final-gltgb.

    CONCATENATE wa_final-gltgb+0(2) wa_final-gltgb+2(3) wa_final-gltgb+5(4)
                    INTO wa_final-gltgb  SEPARATED BY '-'.


    IF wa_final-gltgb  = '--'.
      wa_final-gltgb  = ''.

    ENDIF.


    READ TABLE it_usr06 INTO DATA(wa_usr06) WITH KEY bname = wa_final-bname.

    wa_final-lic_type = wa_usr06-lic_type.

    IF wa_final-lic_type = '91'.
      wa_final-type = 'Test'.

    ELSEIF wa_final-lic_type = 'CA'.
      wa_final-type = 'SAP Application Developer'.
    ELSEIF wa_final-lic_type = 'CB'.
      wa_final-type = 'SAP Application Professional'.
    ELSEIF wa_final-lic_type = 'FD'.
      wa_final-type = ' '.

    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = wa_final-ref.

    CONCATENATE wa_final-ref+0(2) wa_final-ref+2(3) wa_final-ref+5(4)
                    INTO wa_final-ref SEPARATED BY '-'.

    CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO wa_final-time SEPARATED BY ':'.

    SELECT SINGLE name_text FROM  user_addrs INTO v_name_text WHERE bname = wa_final-bname.

    wa_final-name_text = v_name_text.

    APPEND wa_final TO it_final.

    CLEAR : wa_final, v_name_text.

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

  PERFORM fcat USING :     '1'   'MANDT'               'IT_FINAL'      'Client'                           '18' ,
                             '2'   'BNAME'           'IT_FINAL'      'User Name'                         '18',
                             '3'   'LIC_TYPE'         'IT_FINAL'      'Contractual User Type ID'        '18' ,
                             '4'   'TYPE'           'IT_FINAL'      'Contractual User Type '            '18' ,
                             '5'   'USTYP'           'IT_FINAL'      'Technical User Type'                       '18' ,
                             '6'   'TEXT'             'IT_FINAL'      'User Type Text'                   '18' ,
                             '7'   'TRDAT'             'IT_FINAL'      'Last Logon Date'                           '18' ,
                             '8'   'LTIME'              'IT_FINAL'      'Last Logon Time'                    '18' ,
                             '9'   'GLTGV'                'IT_FINAL'      'Valid from'                            '18' ,
                            '10'   'GLTGB'          'IT_FINAL'      'Valid To'                                 '18' ,
                            '11'   'NAME_TEXT'          'IT_FINAL'      'Employee Name'                                 '18' .

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
      i_save             = 'X'
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
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  IF p_down = 'X'.

    it_down[] = it_final[].

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


  lv_file = 'ZPRD_USERS_REPORT.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPRD_USERS_REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_379 TYPE string.
DATA lv_crlf_379 TYPE string.
lv_crlf_379 = cl_abap_char_utilities=>cr_lf.
lv_string_379 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_379 lv_crlf_379 wa_csv INTO lv_string_379.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_619 TO lv_fullfile.
*TRANSFER lv_string_496 TO lv_fullfile.
TRANSFER lv_string_379 TO lv_fullfile.
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


  lv_file = 'ZPRD_USERS.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPRD_USERS_REPORT started on', sy-datum, 'at', sy-uzeit.
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
*TRANSFER lv_string_619 TO lv_fullfile.
*TRANSFER lv_string_496 TO lv_fullfile.
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
FORM cvs_header  USING    hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE     'Client'
                 'User Name'
                  'Contractual User Type ID'
                'Contractual User Type '
                 'Technical User Type'
                  'User Type Text'
                   'Last Logon Date'
                    'Last Logon Time'
                      'Valid from'
                'Valid To'
                'Refresh Date'
                'Refresh Time'
                'Employee Name'
              INTO hd_csv
                SEPARATED BY l_field_seperator.



ENDFORM.
