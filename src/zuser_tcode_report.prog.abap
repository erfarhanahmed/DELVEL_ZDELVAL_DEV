*&---------------------------------------------------------------------*
*& Report ZUSER_TCODE_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zuser_tcode_report.

TYPE-POOLS: slis.

TABLES : agr_users,agr_tcodes,user_addr,usr21,adcp.

TYPES : BEGIN OF ty_join,
          agr_name TYPE  agr_users-agr_name,
          uname    TYPE  agr_users-uname,
          tcode    TYPE tstct-tcode,
        END OF ty_join,

        BEGIN OF ty_user,
          bname      TYPE user_addr-bname,
          name_textc TYPE user_addr-name_textc,
        END OF ty_user,

        BEGIN OF ty_tstct,
          sprsl TYPE tstct-sprsl,
          tcode TYPE tstct-tcode,
          ttext TYPE tstct-ttext,
        END OF ty_tstct,

        BEGIN OF ty_desc,
          agr_name TYPE agr_texts-agr_name,
          spras    TYPE agr_texts-spras,
          line     TYPE agr_texts-line,
          text     TYPE agr_texts-text,
        END OF ty_desc,

        BEGIN OF ty_usr21,
          bname      TYPE usr21-bname,
          persnumber TYPE usr21-persnumber,
          addrnumber TYPE usr21-addrnumber,
        END OF ty_usr21,

        BEGIN OF ty_usr02,
          bname TYPE usr02-bname,
          gltgb TYPE usr02-gltgb,
        END OF ty_usr02,

        BEGIN OF ty_adcp,
          addrnumber TYPE adcp-addrnumber,
          persnumber TYPE adcp-persnumber,
          department TYPE adcp-department,
        END OF ty_adcp,

        BEGIN OF ty_final,
          uname      TYPE  agr_users-uname,
          name_textc TYPE user_addr-name_textc,
          agr_name   TYPE agr_users-agr_name,
          text       TYPE agr_texts-text,
          department TYPE adcp-department,
          tcode      TYPE agr_tcodes-tcode,
          ttext      TYPE tstct-ttext,
        END OF ty_final,

        BEGIN OF ty_down,
          uname      TYPE  agr_users-uname,
          name_textc TYPE user_addr-name_textc,
          agr_name   TYPE  agr_users-agr_name,
          text       TYPE agr_texts-text,
          department TYPE adcp-department,
          tcode      TYPE agr_tcodes-tcode,
          ttext      TYPE tstct-ttext,
          ref_dat    TYPE char18,
          ref_time   TYPE char18,
        END OF ty_down.

DATA : lt_join  TYPE TABLE OF ty_join,
       ls_join  TYPE          ty_join,

       lt_user  TYPE TABLE OF ty_user,
       ls_user  TYPE          ty_user,

       lt_tstct TYPE TABLE OF ty_tstct,
       ls_tstct TYPE          ty_tstct,

       lt_final TYPE TABLE OF ty_final,
       ls_final TYPE          ty_final,

       lt_desc  TYPE TABLE OF ty_desc,
       ls_desc  TYPE          ty_desc,

       lt_usr21 TYPE TABLE OF ty_usr21,
       ls_usr21 TYPE          ty_usr21,

       lt_adcp  TYPE TABLE OF ty_adcp,
       ls_adcp  TYPE          ty_adcp,

       lt_usr02 TYPE TABLE OF ty_usr02,
       ls_usr02 TYPE          ty_usr02,

       lt_down  TYPE TABLE OF ty_down,
       ls_down  TYPE          ty_down,

       gv_gltgb TYPE usr02-gltgb.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_user  FOR agr_users-uname,
                 s_tcode FOR agr_tcodes-tcode.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT   '/Delval/India'."India'."India'."temp'.   "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.


AT SELECTION-SCREEN.

  IF s_user IS NOT INITIAL.

    SELECT SINGLE
    gltgb
    FROM usr02
    INTO gv_gltgb
    WHERE bname = s_user-low.

*    IF gv_gltgb LE sy-datum.
*      MESSAGE 'No user Found!' TYPE 'S' DISPLAY LIKE 'E'.
**    RETURN.
*    ENDIF.

  ENDIF.




START-OF-SELECTION.

  IF s_user IS INITIAL OR gv_gltgb GE sy-datum.
    PERFORM get_data.

  ELSE.
    MESSAGE 'No user Found!' TYPE 'S' DISPLAY LIKE 'E'.
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

  SELECT a~agr_name
         a~uname
         b~tcode
    INTO TABLE lt_join
    FROM agr_users AS a
    INNER JOIN agr_tcodes AS b ON
    b~agr_name = a~agr_name
    WHERE uname IN s_user AND
          tcode IN s_tcode.


  IF lt_join IS NOT INITIAL.

    SELECT bname
           name_textc
      FROM user_addr
      INTO TABLE lt_user
      FOR ALL ENTRIES IN lt_join
      WHERE bname = lt_join-uname.

    SELECT bname
           gltgb
     FROM usr02
     INTO TABLE lt_usr02
     FOR ALL ENTRIES IN lt_join
     WHERE bname = lt_join-uname.


    SELECT sprsl
           tcode
           ttext
      FROM tstct
      INTO TABLE lt_tstct
      FOR ALL ENTRIES IN lt_join
      WHERE tcode = lt_join-tcode AND
            sprsl = 'E'.

    SELECT agr_name
           spras
           line
           text
      FROM agr_texts
      INTO TABLE lt_desc
      FOR ALL ENTRIES IN lt_join
      WHERE agr_name = lt_join-agr_name.


    SELECT bname
           persnumber
           addrnumber
      FROM usr21
      INTO TABLE lt_usr21
      FOR ALL ENTRIES IN lt_join
      WHERE bname = lt_join-uname.

    IF lt_usr21 IS NOT INITIAL.

      SELECT addrnumber
             persnumber
             department
        FROM adcp
        INTO TABLE lt_adcp
        FOR ALL ENTRIES IN lt_usr21
        WHERE addrnumber = lt_usr21-addrnumber AND
              persnumber = lt_usr21-persnumber.
    ENDIF.


    PERFORM sort_data.
    PERFORM get_fcat.
    PERFORM display.


  ELSEIF lt_join IS INITIAL OR gv_gltgb LE sy-datum..

    MESSAGE 'No Data Found!' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.

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

  LOOP AT lt_join INTO ls_join.

    READ TABLE lt_usr02 INTO ls_usr02 WITH KEY bname = ls_join-uname.
    IF  ls_usr02-gltgb = '00000000' OR ( ls_usr02-gltgb GE sy-datum ).
*      IF SY-SUBRC = 0.

      ls_final-uname    = ls_join-uname.
      ls_final-agr_name = ls_join-agr_name.
      ls_final-tcode    = ls_join-tcode.

      READ TABLE lt_user INTO ls_user WITH KEY bname = ls_final-uname.
      IF sy-subrc = 0.
        ls_final-name_textc = ls_user-name_textc.
      ENDIF.

      READ TABLE lt_tstct INTO ls_tstct WITH KEY tcode = ls_final-tcode.
      IF sy-subrc = 0.
        ls_final-ttext = ls_tstct-ttext.
      ENDIF.

      READ TABLE lt_desc INTO ls_desc WITH KEY agr_name = ls_final-agr_name.
      IF sy-subrc = 0.
        ls_final-text = ls_desc-text.
      ENDIF.

      READ TABLE lt_usr21 INTO ls_usr21 WITH KEY bname = ls_final-uname.
      IF sy-subrc = 0.
        READ TABLE lt_adcp INTO ls_adcp WITH KEY addrnumber = ls_usr21-addrnumber
                                                 persnumber = ls_usr21-persnumber.
        IF sy-subrc = 0.
          ls_final-department = ls_adcp-department.
        ENDIF.
      ENDIF.

*    ELSE.
*         MESSAGE 'Please Enter Valid User' TYPE 'S' DISPLAY LIKE 'E'.
*         RETURN.
*    ENDIF.

    ls_down-uname    = ls_final-uname.
    ls_down-agr_name = ls_final-agr_name.
    ls_down-text     = ls_final-text.
    ls_down-tcode    = ls_final-tcode.
    ls_down-name_textc = ls_final-name_textc.
    ls_down-ttext    = ls_final-ttext.
    ls_down-department = ls_final-department.


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_down-ref_dat.

    CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
    INTO ls_down-ref_dat SEPARATED BY '-'.

    ls_down-ref_time = sy-uzeit.

    CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  INTO ls_down-ref_time.

    APPEND ls_final TO lt_final.
    APPEND ls_down TO lt_down.

    ENDIF.

    CLEAR : ls_final,ls_down,ls_user,ls_tstct,ls_join,ls_desc,ls_usr21,ls_adcp.

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

  PERFORM fcat USING : '1'    'UNAME'       'LT_FINAL'  'User'                          '20' .
  PERFORM fcat USING : '2'    'NAME_TEXTC'  'LT_FINAL'  'User Name'                     '40' .
  PERFORM fcat USING : '3'    'AGR_NAME'    'LT_FINAL'  'Role'                          '20' .
  PERFORM fcat USING : '4'    'TEXT'        'LT_FINAL'  'Role Short Description'        '40' .
  PERFORM fcat USING : '5'    'DEPARTMENT'  'LT_FINAL'  'Department'                    '40' .
  PERFORM fcat USING : '6'    'TCODE'       'LT_FINAL'  'T-Code'                        '18' .
  PERFORM fcat USING : '7'    'TTEXT'       'LT_FINAL'  'T-Code Description'            '40' .


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
      is_layout          = ls_layout
      it_fieldcat        = it_fcat[]
    TABLES
      t_outtab           = lt_final[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download_excel.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0439   text
*      -->P_0440   text
*      -->P_0441   text
*      -->P_0442   text
*      -->P_0443   text
*----------------------------------------------------------------------*
FORM fcat  USING   VALUE(p1)
      VALUE(p2)
      VALUE(p3)
      VALUE(p4)
      VALUE(p5).

  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
  wa_fcat-outputlen = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_excel .

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
*  BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_down
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
  lv_file = 'ZUSER_DETAILS.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
  BREAK primus.
  WRITE: / 'ZUSER_DETAILS Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_457 TYPE string.
DATA lv_crlf_457 TYPE string.
lv_crlf_457 = cl_abap_char_utilities=>cr_lf.
lv_string_457 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_457 lv_crlf_457 wa_csv INTO lv_string_457.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1019 TO lv_fullfile.
TRANSFER lv_string_457 TO lv_fullfile.
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
FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE 'User'
              'User Name'
              'Role'
              'Role Short Description'
              'Department'
              'T-Code'
              'T-Code Description'
              'Refresh Date'
              'Refresh Time'
          INTO p_hd_csv
SEPARATED BY l_field_seperator.
ENDFORM.
