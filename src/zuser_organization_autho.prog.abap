*&---------------------------------------------------------------------*
*& Report ZUSER_ORGANIZATION_AUTHO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zuser_organization_autho.

TABLES :agr_users,agr_1252.
*****************structure for user name*******************
*TYPES: BEGIN OF ty_users,
*         agr_name TYPE agr_users-agr_name,
*         uname    TYPE agr_users-uname,
*         from_dat TYPE agr_users-from_dat,
*         to_dat   TYPE agr_users-to_dat,
*         exclude  TYPE agr_users-exclude,
*       END OF ty_users.
******************************************************************
****************structure for orgniazational Data*******************
TYPES : BEGIN OF ty_agr_1252,
          agr_name TYPE agr_1252-agr_name,
          counter  TYPE agr_1252-counter,
          varbl    TYPE agr_1252-varbl,
          low      TYPE agr_1252-low,
          high     TYPE agr_1252-high,
        END OF ty_agr_1252.
****************************************************************
*****************structure for role description*******************
TYPES : BEGIN OF ty_desc,
          agr_name TYPE agr_texts-agr_name,
          spras    TYPE agr_texts-spras,
          line     TYPE agr_texts-line,
          text     TYPE agr_texts-text,
        END OF ty_desc.
*******************************************************************
*****************structure for organization level description*******************
TYPES    : BEGIN OF ty_usvart,
             langu TYPE usvart-langu,
             varbl TYPE usvart-varbl,
             vtext TYPE usvart-vtext,
           END OF ty_usvart.

*********structure for final output*********************************
TYPES : BEGIN OF ty_final,
*          uname    TYPE  agr_users-uname, "user name
          agr_name TYPE agr_users-agr_name,  "role
          text     TYPE agr_texts-text,        "role description
          varbl    TYPE agr_1252-varbl,
          vtext    TYPE usvart-vtext,
          low      TYPE agr_1252-low,
*          high     TYPE agr_1252-high,
*          india    TYPE char1,
*          usa      TYPE char1,
*          saudi    TYPE char1,
        END OF ty_final.
**********************************************************************
*******************structure for refreshable file**********************
TYPES : BEGIN OF ty_down,
*          uname    TYPE  agr_users-uname, "user name
          agr_name TYPE agr_1252-agr_name,  "role
          text     TYPE agr_texts-text,        "role description
          varbl    TYPE agr_1252-varbl,
          vtext    TYPE usvart-vtext,
          low      TYPE agr_1252-low,
*          high     TYPE agr_1252-high,
*          india    TYPE char1,
*          usa      TYPE char1,
*          saudi    TYPE char1,
          ref_dat  TYPE char18,
          ref_time TYPE char18,
        END OF ty_down.
************************************************************************
***************** internal tables and work area***********************
DATA :
  it_agr_1252 TYPE TABLE OF ty_agr_1252,
  wa_agr_1252 TYPE ty_agr_1252,
  it_usvart   TYPE TABLE OF ty_usvart,
  wa_usvart   TYPE ty_usvart,
  it_desc     TYPE TABLE OF ty_desc,
  wa_desc     TYPE ty_desc,
  it_final    TYPE TABLE OF ty_final,
  wa_final    TYPE ty_final,
  it_down     TYPE TABLE OF ty_down,
  wa_down     TYPE ty_down,
  gv_gltgb    TYPE usr02-gltgb.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.
*************************************************************************
***********************Selection screen**********************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_role  FOR agr_1252-agr_name.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'."India'."India'."temp'.
     "'/delval/temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK b3.

*AT SELECTION-SCREEN.


START-OF-SELECTION.

*  IF s_role IS NOT INITIAL.
    PERFORM get_data.
    PERFORM sort_data.
    PERFORM get_fcat.
    PERFORM display.

*  ELSE.
*    MESSAGE 'No role Found!' TYPE 'S' DISPLAY LIKE 'E'.
*  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*  SELECT agr_name
*         uname
*         from_dat
*         to_dat
*         exclude
*   FROM agr_users
*   INTO TABLE it_users
*   WHERE uname IN s_user .

*  IF it_users IS NOT INITIAL.


  SELECT agr_name
         counter
         varbl
         low
         high
    FROM agr_1252
    INTO TABLE it_agr_1252
    WHERE agr_name IN s_role.

  IF it_agr_1252 IS NOT INITIAL.

    SELECT agr_name
           spras
           line
           text
      FROM agr_texts
      INTO TABLE it_desc
      FOR ALL ENTRIES IN it_agr_1252
      WHERE agr_name = it_agr_1252-agr_name
      and spras = 'E'.

    SELECT langu
           varbl
           vtext
    FROM usvart
    INTO TABLE it_usvart
    FOR ALL ENTRIES IN it_agr_1252
     WHERE varbl = it_agr_1252-varbl
      AND langu = 'E'.

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
*  LOOP AT it_users INTO wa_users.
*    ls_final-uname    = ls_join-uname.
  LOOP AT it_agr_1252 INTO wa_agr_1252.
    wa_final-agr_name = wa_agr_1252-agr_name.
    wa_final-varbl = wa_agr_1252-varbl.
    wa_final-low = wa_agr_1252-low.
*        wa_final-high = wa_agr_1252-high.

    READ TABLE it_desc INTO wa_desc WITH KEY agr_name = wa_final-agr_name.
    IF sy-subrc = 0.
      wa_final-text = wa_desc-text.
    ENDIF.


    READ TABLE it_usvart INTO wa_usvart WITH KEY varbl = wa_final-varbl.
    IF sy-subrc = 0.
      wa_final-vtext = wa_usvart-vtext.
    ENDIF.

 wa_down-agr_name =  wa_final-agr_name.
     wa_down-text =  wa_final-text.
    wa_down-varbl =  wa_final-varbl .
    wa_down-vtext =  wa_final-vtext .
     wa_down-low  =   wa_final-low.
     CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = wa_down-ref_dat.

    CONCATENATE wa_down-ref_dat+0(2) wa_down-ref_dat+2(3) wa_down-ref_dat+5(4)
    INTO wa_down-ref_dat SEPARATED BY '-'.

    wa_down-ref_time = sy-uzeit.

    CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.

    APPEND wa_final TO it_final.
    APPEND wa_down TO it_down.


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

  PERFORM fcat USING : '1'    'AGR_NAME'    'LT_FINAL'  'Role'                          '20' .
  PERFORM fcat USING : '2'    'TEXT'        'LT_FINAL'  'Role Short Description'        '40' .
  PERFORM fcat USING : '3'    'VARBL'       'LT_FINAL'  'Organization level'                    '40' .
  PERFORM fcat USING : '4'    'VTEXT'        'LT_FINAL'  'Organization level Description'   '40' .
  PERFORM fcat USING : '5'    'LOW'         'LT_FINAL'  'Authorization value'            '40' .

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
      t_outtab           = it_final[]
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
  lv_file = 'ZUSER_ORGANIZATION_AUTHO.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
  BREAK primus.
  WRITE: / 'ZUSER_ORGANIZATION_AUTHO Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_355 TYPE string.
DATA lv_crlf_355 TYPE string.
lv_crlf_355 = cl_abap_char_utilities=>cr_lf.
lv_string_355 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_355 lv_crlf_355 wa_csv INTO lv_string_355.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1495 TO lv_fullfile.
TRANSFER lv_string_355 TO lv_fullfile.
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

  CONCATENATE  'Role'
               'Role Short Description'
               'Organization level'
               'Organization level Description'
               'Authorization value'
               'Refresh Date'
               'Refresh Time'
          INTO p_hd_csv
SEPARATED BY l_field_seperator.
ENDFORM.
