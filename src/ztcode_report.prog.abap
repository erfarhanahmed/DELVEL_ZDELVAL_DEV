*&---------------------------------------------------------------------*
*& Report ZTCODE_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztcode_report.

TYPE-POOLS: slis.

TABLES : tstc,tstct.

TYPES : BEGIN OF ty_tstc,
          tcode TYPE tstc-tcode,
          pgmna TYPE tstc-pgmna,
        END OF ty_tstc,

        BEGIN OF ty_desc,
          sprsl TYPE tstct-sprsl,
          tcode TYPE tstct-tcode,
          ttext TYPE tstct-ttext,
        END OF ty_desc,

        BEGIN OF ty_trdir,
          name TYPE trdir-name,
          cnam TYPE trdir-cnam,
          cdat TYPE trdir-cdat,
          udat TYPE trdir-udat,
        END OF ty_trdir,

        BEGIN OF ty_trdirt,
          name TYPE trdirt-name,
          text TYPE trdirt-text,
        END OF ty_trdirt,

        begin of ty_d010inc,
           master type d010inc-master,
           include type d010inc-include,
        end of ty_d010inc,


        BEGIN OF ty_final,
          tcode TYPE tstc-tcode,
          pgmna TYPE tstc-pgmna,
*          text  TYPE trdirt-text,
          include type d010inc-include,"added by jyoti on 25.09.2024
          ttext TYPE tstct-ttext,
          name  TYPE trdir-name,
          cnam  TYPE trdir-cnam,
          cdat  TYPE trdir-cdat,
          udat  TYPE trdir-udat,
          text  TYPE trdirt-text,
        END OF ty_final,

        BEGIN OF ty_down,
          tcode    TYPE tstc-tcode,
          pgmna    TYPE tstc-pgmna,
*          text     TYPE trdirt-text,
          include type d010inc-include,"added by jyoti on 25.09.2024
          ttext    TYPE tstct-ttext,
          cdat     TYPE char18,
          udat     TYPE char18,
          cnam     TYPE trdir-cnam,
          ref_dat  TYPE char18,
          ref_time TYPE char15,
          text     TYPE trdirt-text,
        END OF ty_down.

DATA : lt_tstc   TYPE TABLE OF ty_tstc,
       ls_tstc   TYPE          ty_tstc,

       lt_D010INC   TYPE TABLE OF ty_D010INC, "ADDED BY JYOTI ON 25.09.2024
       ls_D010INC   TYPE          ty_D010INC,"ADDED BY JYOTI ON 25.09.2024

       lt_desc   TYPE TABLE OF ty_desc,
       ls_desc   TYPE          ty_desc,

       lt_trdir  TYPE TABLE OF ty_trdir,
       ls_trdir  TYPE          ty_trdir,

       lt_trdirt TYPE TABLE OF ty_trdirt,
       ls_trdirt TYPE          ty_trdirt,

       lt_final  TYPE TABLE OF ty_final,
       ls_final  TYPE          ty_final,

       lt_down   TYPE TABLE OF ty_down,
       ls_down   TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_prog FOR tstc-pgmna,
                 s_tcode FOR tstc-tcode.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'."India'."India'."temp'.          "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK b3.

START-OF-SELECTION.

  PERFORM get_data.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT tcode
  pgmna
  FROM tstc
  INTO TABLE lt_tstc
  WHERE tcode IN s_tcode
  AND   pgmna IN s_prog AND
        tcode LIKE 'Z%' AND
        pgmna NE ' '.

  IF lt_tstc IS NOT INITIAL.

    SELECT sprsl
           tcode
           ttext
    FROM tstct
    INTO TABLE lt_desc
    FOR ALL ENTRIES IN lt_tstc
    WHERE tcode = lt_tstc-tcode.

    SELECT name
           cnam
           cdat
           udat
      FROM trdir
      INTO TABLE lt_trdir
      FOR ALL ENTRIES IN lt_tstc
      WHERE name = lt_tstc-pgmna.
*************ADED BY JYOTI ON 25.09.2024*************
      SELECT master
             include
          FROM D010INC
      INTO TABLE lt_D010INC
      FOR ALL ENTRIES IN lt_tstc
      WHERE master = lt_tstc-pgmna
        and  include LIKE 'Z%'.
*********************************************************

    IF lt_trdir IS NOT INITIAL.

      SELECT name
             text
        FROM trdirt
        INTO TABLE lt_trdirt
        FOR ALL ENTRIES IN lt_tstc
        WHERE name = lt_tstc-pgmna.

    ENDIF.

  ENDIF.

  IF lt_tstc IS NOT INITIAL.
    PERFORM sort_data.
    PERFORM get_fcat.
    PERFORM display.
  ELSE.
    MESSAGE 'No Data Found!' TYPE 'S' DISPLAY LIKE 'E'.
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
*  LOOP AT lt_D010INC INTO lS_D010INC.
*
*  ls_final-include = lS_D010INC-include.
  LOOP AT lt_tstc INTO ls_tstc.
*  READ TABLE lt_tstc INTO ls_tstc WITH KEY pgmna = LS_D010INC-master.

    ls_final-tcode = ls_tstc-tcode.
    ls_final-pgmna = ls_tstc-pgmna.


    READ TABLE lt_desc INTO ls_desc WITH KEY tcode = ls_tstc-tcode.
    IF sy-subrc = 0.
*      ls_final-text = ls_desc-ttext.
      ls_final-ttext = ls_desc-ttext.
    ENDIF.

    READ TABLE lt_trdir INTO ls_trdir WITH KEY name = ls_final-pgmna.
    IF sy-subrc = 0.
*      ls_final-name = ls_trdir-name.
      ls_final-cnam = ls_trdir-cnam.
      ls_final-cdat = ls_trdir-cdat.
      ls_final-udat = ls_trdir-udat.
    ENDIF.

    READ TABLE lt_trdirt INTO ls_trdirt WITH KEY name = ls_final-pgmna.
    IF sy-subrc = 0.
      ls_final-text = ls_trdirt-text.
    ENDIF.

    LOOP AT lt_D010INC INTO lS_D010INC where master = ls_final-pgmna.

        ls_final-include = lS_D010INC-include.


    APPEND ls_final TO lt_final.
     clear : lS_D010INC  .
    endloop.
     APPEND ls_final TO lt_final.
     clear lS_final.

    endloop.


delete ADJACENT DUPLICATES FROM lt_final COMPARING ALL FIELDS.

    loop at lt_final INTO ls_final.

    ls_down-tcode = ls_final-tcode.
    ls_down-pgmna = ls_final-pgmna.
    ls_down-include = ls_final-include.
    ls_down-ttext  = ls_final-ttext.

    ls_down-cnam  = ls_final-cnam.

    IF ls_final-cdat IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-cdat
        IMPORTING
          output = ls_down-cdat.

      CONCATENATE ls_down-cdat+0(2) ls_down-cdat+2(3) ls_down-cdat+5(4)
      INTO ls_down-cdat SEPARATED BY '-'.

    ENDIF.

    IF ls_final-udat IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-udat
        IMPORTING
          output = ls_down-udat.

      CONCATENATE ls_down-udat+0(2) ls_down-udat+2(3) ls_down-udat+5(4)
      INTO ls_down-udat SEPARATED BY '-'.

    ENDIF.


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_down-ref_dat.

    CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
    INTO ls_down-ref_dat SEPARATED BY '-'.

    ls_down-ref_time = sy-uzeit.

    CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  INTO ls_down-ref_time.

    ls_down-text = ls_final-text.

*    APPEND ls_final TO lt_final.
    APPEND ls_down TO lt_down.

    CLEAR : ls_final,ls_tstc,ls_tstc,ls_down.

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

  PERFORM fcat USING : '1'    'TCODE'       'LT_FINAL'  'Tcode'                    '18' .
  PERFORM fcat USING : '2'    'PGMNA'       'LT_FINAL'  'Program_Name'             '25' .
  PERFORM fcat USING : '3'    'INCLUDE'     'LT_FINAL'  'Include_Name'             '25' .
  PERFORM fcat USING : '4'    'TTEXT'       'LT_FINAL'  'Tcode Description'      '40' .
  PERFORM fcat USING : '5'    'CDAT'        'LT_FINAL'  'Created On'               '18' .
  PERFORM fcat USING : '6'    'UDAT'        'LT_FINAL'  'Changed On'               '18' .
  PERFORM fcat USING : '7'    'CNAM'        'LT_FINAL'  'Created By'               '18' .
  PERFORM fcat USING : '8'    'TEXT'        'LT_FINAL'  'Program_Description'      '40'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0305   text
*      -->P_0306   text
*      -->P_0307   text
*      -->P_0308   text
*      -->P_0309   text
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
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

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
  lv_file = 'ZTCODE.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZTCODE Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_424 TYPE string.
DATA lv_crlf_424 TYPE string.
lv_crlf_424 = cl_abap_char_utilities=>cr_lf.
lv_string_424 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_424 lv_crlf_424 wa_csv INTO lv_string_424.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1019 TO lv_fullfile.
TRANSFER lv_string_424 TO lv_fullfile.
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

  CONCATENATE 'Tcode'
              'Program_Name'
              'Include_Name'
              'Tcode Description'
              'Created On'
              'Changed On'
              'Created By'
              'Refresh Date'
              'Refresh Time'
              'Program_Description'
               INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
