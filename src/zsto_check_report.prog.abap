*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsto_check_report.

TABLES :a005.

****************structure for CHECK CONDITION TYPE*******************
TYPES : BEGIN OF ty_a005,
          kschl TYPE a005-kschl,
          matnr TYPE a005-matnr,
        END OF ty_a005.
****************************************************************
*********structure for final output*********************************
TYPES : BEGIN OF ty_final,
          material              TYPE a005-matnr,
          description           TYPE char256,
          condition_type_status TYPE char15,
          kbetr                 TYPE konp-kbetr,
        END OF ty_final.
**********************************************************************
*******************structure for refreshable file**********************
TYPES : BEGIN OF ty_down,
          material              TYPE a005-matnr,
          description           TYPE char256,
          condition_type_status TYPE char15,
          kbetr                 TYPE CHAR20,
          ref_dat               TYPE char18,
          ref_time              TYPE char18,
        END OF ty_down.
************************************************************************
TYPES:BEGIN OF ty_matnr,
        sign   TYPE char1,
        option TYPE char2,
        low    TYPE char18,
        high   TYPE char18,
      END OF ty_matnr.
***************** internal tables and work area***********************
DATA :
  it_a005    TYPE TABLE OF ty_a005,
  wa_a005    TYPE ty_a005,
  lt_a005    TYPE TABLE OF a005,
  ls_a005    TYPE a005,
  it_final   TYPE TABLE OF ty_final,
  wa_final   TYPE ty_final,
  it_down    TYPE TABLE OF ty_down,
  wa_down    TYPE ty_down,
  wa_somatnr TYPE ty_matnr,
  lv_longtxt TYPE char256,
  gv_gltgb   TYPE usr02-gltgb.

DATA: lv_id    TYPE thead-tdname,
      lt_lines TYPE STANDARD TABLE OF tline,
      ls_lines TYPE tline.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.
*************************************************************************
***********************Selection screen**********************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_cond TYPE a005-kschl OBLIGATORY DEFAULT 'ZSTO' MODIF ID bu.
SELECT-OPTIONS : s_matnr  FOR a005-matnr .
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
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

*  IF s_role IS NOT INITIAL.
  PERFORM get_data.
  PERFORM sort_data.
  IF s_matnr IS NOT INITIAL.
      PERFORM get_fcat01.
   ELSE.
       PERFORM get_fcat.
  ENDIF.

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

  SELECT * FROM a005 INTO CORRESPONDING FIELDS OF TABLE lt_a005 WHERE kschl = 'ZSTO' AND vkorg = '1000'.

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
  IF s_matnr IS NOT INITIAL.
    LOOP AT s_matnr INTO wa_somatnr.

      SELECT SINGLE kschl matnr
              FROM a005
              INTO wa_a005
              WHERE matnr = wa_somatnr-low
              AND   vkorg = '1000'.
      IF wa_a005 IS INITIAL.

        IF wa_a005-kschl <> 'ZSTO' .

          wa_final-material = wa_somatnr-low.

          IF wa_final-material IS NOT INITIAL.
            lv_id = wa_final-material.
            CLEAR: lt_lines,ls_lines.
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = 'GRUN'
                language                = 'E'
                name                    = lv_id
                object                  = 'MATERIAL'
              TABLES
                lines                   = lt_lines
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
* Implement suitable error handling here
            ENDIF.
            IF NOT lt_lines IS INITIAL.
              LOOP AT lt_lines INTO ls_lines.
                IF NOT ls_lines-tdline IS INITIAL.
                  CONCATENATE lv_longtxt ls_lines-tdline INTO lv_longtxt SEPARATED BY space.
                ENDIF.
              ENDLOOP.
              CONDENSE lv_longtxt.
            ENDIF.
          ENDIF.
          SHIFT  wa_final-material LEFT DELETING LEADING '0'.
          wa_final-description = lv_longtxt.
          wa_final-condition_type_status = 'Not Maintained'.

          wa_down-material  =  wa_final-material.
          wa_down-description   = wa_final-description.
          wa_down-condition_type_status  =  wa_final-condition_type_status.

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
        ENDIF.
      ENDIF.
      CLEAR :wa_final,wa_down,wa_somatnr,wa_a005,lv_longtxt.
    ENDLOOP.
  ELSE.
    LOOP AT lt_a005 INTO ls_a005.

      wa_final-material = ls_a005-matnr.

      IF wa_final-material IS NOT INITIAL.
        lv_id = wa_final-material.
        CLEAR: lt_lines,ls_lines.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'GRUN'
            language                = 'E'
            name                    = lv_id
            object                  = 'MATERIAL'
          TABLES
            lines                   = lt_lines
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
* Implement suitable error handling here
        ENDIF.
        IF NOT lt_lines IS INITIAL.
          LOOP AT lt_lines INTO ls_lines.
            IF NOT ls_lines-tdline IS INITIAL.
              CONCATENATE lv_longtxt ls_lines-tdline INTO lv_longtxt SEPARATED BY space.
            ENDIF.
          ENDLOOP.
          CONDENSE lv_longtxt.
        ENDIF.
      ENDIF.
      SHIFT  wa_final-material LEFT DELETING LEADING '0'.
      wa_final-description = lv_longtxt.
      wa_final-condition_type_status = 'Maintained'.

      IF ls_a005-knumh IS NOT INITIAL.
        SELECT SINGLE kbetr FROM konp INTO @DATA(lv_kbetr) WHERE knumh = @ls_a005-knumh AND kschl = 'ZSTO'.
        wa_final-kbetr =  lv_kbetr.
      ENDIF.

      wa_down-material  =  wa_final-material.
      wa_down-description   = wa_final-description.
      wa_down-condition_type_status  =  wa_final-condition_type_status.
      wa_down-kbetr =  wa_final-kbetr.

      REPLACE ALL OCCURRENCES OF ',' IN wa_down-kbetr WITH ''.

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
      CLEAR :wa_final,wa_down,wa_somatnr,wa_a005,lv_longtxt,lv_kbetr.
    ENDLOOP.
  ENDIF.
* ENDIF.

* ENDIF.
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

  PERFORM fcat USING : '1'    'Material'    'IT_FINAL'  'MATERIAL'                          '20' .
  PERFORM fcat USING : '2'    'description'        'IT_FINAL'  'MATERIAL DESCRIPTION'        '50' .
  PERFORM fcat USING : '3'    'CONDITION_TYPE_STATUS'        'IT_FINAL'  'CONDITION TYPE STATUS'        '20' .
  PERFORM fcat USING : '4'    'KBETR'        'IT_FINAL'  'RATE'        '10' .

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
  lv_file = 'ZSTO_CHECK.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZSTO_CHECK Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_396 TYPE string.
DATA lv_crlf_396 TYPE string.
lv_crlf_396 = cl_abap_char_utilities=>cr_lf.
lv_string_396 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_396 lv_crlf_396 wa_csv INTO lv_string_396.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
*TRANSFER lv_string_1495 TO lv_fullfile.
TRANSFER lv_string_396 TO lv_fullfile.
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

  CONCATENATE  'Material'
               'MATERIAL DESCRIPTION'
               'CONDITION TYPE STATUS'
               'RATE'
               'Refresh Date'
               'Refresh Time'
          INTO p_hd_csv
SEPARATED BY l_field_seperator.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT01
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat01 .
  PERFORM fcat USING : '1'    'Material'    'IT_FINAL'  'MATERIAL'                          '20' .
  PERFORM fcat USING : '2'    'description'        'IT_FINAL'  'MATERIAL DESCRIPTION'        '50' .
  PERFORM fcat USING : '3'    'CONDITION_TYPE_STATUS'        'IT_FINAL'  'CONDITION TYPE STATUS'        '20' .
*  PERFORM fcat USING : '4'    'KBETR'        'IT_FINAL'  'RATE'        '10' .

ENDFORM.
