*&---------------------------------------------------------------------*
*& Report ZJOB_SCHEDULES_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zjob_schedules_report.

TABLES : tbtcp,tstc,tbtco.

TYPES : BEGIN OF ty_tbtcp,
          jobname   TYPE tbtcp-jobname,
          jobcount  TYPE tbtcp-jobcount,
          stepcount TYPE tbtcp-stepcount,
          progname  TYPE tbtcp-progname,
          sdldate   TYPE tbtcp-sdldate,
          sdltime   TYPE tbtcp-sdltime,
          sdluname  TYPE tbtcp-sdluname,
          variant   TYPE tbtcp-variant,
          status    TYPE tbtcp-status,
        END OF ty_tbtcp,

        BEGIN OF ty_tstc,
          tcode TYPE tstc-tcode,
          pgmna TYPE tstc-pgmna,
        END OF ty_tstc,

        BEGIN OF ty_tbtco,
          jobname    TYPE tbtco-jobname,
          jobcount   TYPE tbtco-jobcount,
          sdlstrttm  TYPE tbtco-sdlstrttm,
          sdldate    TYPE tbtco-sdldate,
          sdltime    TYPE tbtco-sdltime,
          lastchdate TYPE tbtco-lastchdate,
          lastchtime TYPE tbtco-lastchtime,
          lastchname TYPE tbtco-lastchname,
          strtdate   TYPE tbtco-strtdate ,
          strttime   TYPE  tbtco-strttime,
          endtime    TYPE tbtco-endtime,
          prdhours   TYPE tbtco-prdhours,
          prddays    TYPE tbtco-prddays,
          prdweeks   TYPE tbtco-prdweeks,
          prdmonths  TYPE tbtco-prdmonths,
          priority   TYPE tbtco-priority,
          reldate    TYPE tbtco-reldate,
          reltime    TYPE tbtco-reltime,
        END OF ty_tbtco,

        BEGIN OF ty_final,
          tcode      TYPE tstc-tcode,
          progname   TYPE tbtcp-progname,
          jobname    TYPE tbtcp-jobname,
          jobcount   TYPE tbtco-jobcount,
          variant    TYPE tbtcp-variant,
          sdltime    TYPE char15,
          sdluname   TYPE tbtcp-sdluname,
          sdldate    TYPE tbtco-sdldate,
          lastchdate TYPE tbtco-lastchdate,
          lastchname TYPE tbtco-lastchname,
          freq       TYPE string,
          strtdate   TYPE sy-datum,
          strttime   TYPE sy-uzeit,
          duration   TYPE tbtco-endtime,
          priority   TYPE tbtco-priority,
        END OF ty_final,

        BEGIN OF ty_down,
          tcode      TYPE tstc-tcode,
          progname   TYPE tbtcp-progname,
          jobname    TYPE tbtcp-jobname,
          variant    TYPE tbtcp-variant,
          sdltime    TYPE char15,
          sdluname   TYPE tbtcp-sdluname,
          ref_dat    TYPE char18,
          ref_time   TYPE char15,
          sdldate    TYPE char18,
          lastchdate TYPE char18,
          lastchname TYPE tbtco-lastchname,
          freq       TYPE string,
          strtdate   TYPE char18,
          strttime   TYPE char15,
          duration   TYPE char15,
          priority   TYPE tbtco-priority,
        END OF ty_down.

DATA : lt_tstc  TYPE TABLE OF ty_tstc,
       ls_tstc  TYPE          ty_tstc,

       lt_tbtcp TYPE TABLE OF ty_tbtcp,
       ls_tbtcp TYPE          ty_tbtcp,

       lt_tbtco TYPE TABLE OF ty_tbtco,
       ls_tbtco TYPE          ty_tbtco,

       lt_final TYPE TABLE OF ty_final,
       ls_final TYPE          ty_final,

       lt_down  TYPE TABLE OF ty_down,
       ls_down  TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA: GV_ENDATE  TYPE TBTCO-ENDDATE,
      GV_ENDTIME TYPE TBTCO-ENDTIME.
DATA : ls_layout TYPE slis_layout_alv.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_job FOR tbtcp-jobname.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS : p_down   AS CHECKBOX,
             p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'.        "'/delval/temp'.
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

  SELECT jobname
         jobcount
         stepcount
         progname
          sdldate
         sdltime
         sdluname
         variant
         status
    FROM tbtcp
    INTO TABLE lt_tbtcp
    WHERE jobname IN s_job AND
          jobname LIKE 'Z%' AND
          status = 'P' .

  IF lt_tbtcp IS NOT INITIAL.

    SELECT tcode
           pgmna
      FROM tstc
      INTO TABLE lt_tstc
      FOR ALL ENTRIES IN lt_tbtcp
      WHERE pgmna = lt_tbtcp-progname.



    SELECT jobname
           jobcount
           sdlstrttm
           sdldate
           sdltime
           lastchdate
           lastchtime
           lastchname
           strtdate
           strttime
           endtime
           prdhours
           prddays
           prdweeks
           prdmonths
           priority
           reldate
           reltime
      FROM tbtco
      INTO CORRESPONDING FIELDS OF TABLE lt_tbtco
      FOR ALL ENTRIES IN lt_tbtcp
      WHERE jobname = lt_tbtcp-jobname
      AND   strtdate = lt_tbtcp-sdldate
      and   strttime = lt_tbtcp-sdltime.
    DELETE lt_tbtco WHERE strtdate = ''.
  endif.
  IF lt_tbtcp IS NOT INITIAL.
    PERFORM sort_data.
    PERFORM get_fcat.
    PERFORM display.

  ELSE.
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

  LOOP AT lt_tbtcp INTO ls_tbtcp.

    ls_final-progname = ls_tbtcp-progname.
*    ls_final-sdltime  = ls_tbtcp-sdltime.
    ls_final-sdluname = ls_tbtcp-sdluname.
    ls_final-variant  = ls_tbtcp-variant.
    ls_final-jobname  = ls_tbtcp-jobname.
    ls_final-jobcount  = ls_tbtcp-jobcount.


    SORT lt_tbtco DESCENDING BY lastchdate lastchtime.
*    LOOP AT lt_tbtcp INTO
    READ TABLE lt_tbtco INTO ls_tbtco WITH KEY jobname = ls_tbtcp-jobname strtdate = ls_tbtcp-sdldate
    strttime = ls_tbtcp-sdltime.
*     STRTDATE = lS_tbtcp-sdldate
*       STRTTIME   = lS_tbtcp-sdltime.
*
    IF sy-subrc = 0.
      ls_final-lastchdate = ls_tbtco-lastchdate.
      ls_final-lastchname = ls_tbtco-lastchname.
      ls_final-sdltime    = ls_tbtco-sdlstrttm.
*      ls_final-strtdate   = ls_tbtco-strtdate.
      ls_final-sdldate   = ls_tbtco-sdldate.
      DATA: WA_TBTCO01 TYPE TBTCO.
      CLEAR WA_TBTCO01 .


*    SELECT SINGLE * FROM TBTCO INTO CORRESPONDING FIELDS OF WA_TBTCO01 WHERE jobname = ls_tbtcp-jobname
*      AND STRTDATE = lS_tbtcp-sdldate
*       AND STRTTIME   = lS_tbtcp-sdltime.


*       AND jobcount = ls_tbtcp-jobcount.  ""ADDED BY MA ON 26.03.2024
      ls_final-strtdate   = ls_tbtco-strtdate.
*      CLEAR WA_TBTCO01.
*      ls_final-strtdate   = ls_tbtco-RELDATE.                     "added by satyajeet on 12.03.2021
*      ls_final-strttime   = ls_tbtco-strttime.
*      ls_final-strtdate   = GV_ENDATE .
      ls_final-strttime   = ls_tbtco-strttime.
*       ls_final-strttime   = GV_ENDTIME .
*      ls_final-strttime   = ls_tbtco-RELTIME.                       "added by satyajeet on 12.03.2021
      ls_final-duration   = ls_tbtco-endtime - ls_tbtco-strttime ."ls_tbtco-endtime - ls_final-strttime .
*      ls_final-duration   = GV_ENDTIME - ls_final-strttime .

*      ls_final-priority   = ls_tbtco-priority.
      ls_final-priority   = ls_tbtco-priority.

      IF ls_tbtco-prdhours = '1'.
        ls_final-freq = 'Hourly'.

      ELSEIF ls_tbtco-prddays = '1'.
        ls_final-freq = 'Daily'.

      ELSEIF ls_tbtco-prdweeks = '1'.
        ls_final-freq = 'Weekly'.

      ELSEIF ls_tbtco-prdmonths = '1'.
        ls_final-freq = 'Monthly'.

      ENDIF.
    ENDIF.

    SORT lt_tbtco ASCENDING BY sdldate.

    READ TABLE lt_tstc INTO ls_tstc WITH KEY pgmna = ls_tbtcp-progname.
    IF sy-subrc = 0.
      ls_final-tcode = ls_tstc-tcode.
    ENDIF.

    ls_down-progname = ls_final-progname.
    ls_down-tcode    = ls_final-tcode.

    IF ls_final-sdltime = ' '.
      ls_final-sdltime = '000000'.
    ENDIF.

    IF ls_final-sdltime IS NOT INITIAL.

      CONCATENATE ls_final-sdltime+0(2) ':' ls_final-sdltime+2(2)  ':' ls_final-sdltime+4(2) INTO ls_down-sdltime.
      ls_final-sdltime =  ls_down-sdltime.              " Added by Satyajeet on 12.03.2021

    ENDIF.
    ls_down-sdluname = ls_final-sdluname.
    ls_down-variant  = ls_final-variant.
    ls_down-jobname    = ls_final-jobname.
    ls_down-lastchname = ls_final-lastchname .
    ls_down-freq       = ls_final-freq.
    ls_down-priority   = ls_final-priority.

    IF ls_final-strttime = ' '.
      ls_final-strttime = '000000'.
    ENDIF.

    IF ls_final-strttime IS NOT INITIAL.
      CONCATENATE ls_final-strttime+0(2) ':' ls_final-strttime+2(2) ':' ls_final-strttime+4(2) INTO ls_down-strttime.
    ENDIF.

    IF ls_final-duration IS NOT INITIAL.
      CONCATENATE ls_final-duration+0(2) ':' ls_final-duration+2(2) ':' ls_final-duration+4(2)  INTO ls_down-duration.
    ENDIF.

    IF ls_final-lastchdate = ' '.
      ls_final-lastchdate = '00000000'.
    ENDIF.

    IF ls_final-lastchdate IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-lastchdate
        IMPORTING
          output = ls_down-lastchdate.

      CONCATENATE ls_down-lastchdate+0(2) ls_down-lastchdate+2(3) ls_down-lastchdate+5(4)
      INTO ls_down-lastchdate SEPARATED BY '-'.

    ENDIF.

    IF ls_final-strtdate = ' '.
      ls_final-strtdate = '00000000'.
    ENDIF.

    IF ls_final-strtdate IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-strtdate
        IMPORTING
          output = ls_down-strtdate.

      CONCATENATE ls_down-strtdate+0(2) ls_down-strtdate+2(3) ls_down-strtdate+5(4)
      INTO ls_down-strtdate SEPARATED BY '-'.

    ENDIF.

    IF ls_final-sdldate IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-sdldate
        IMPORTING
          output = ls_down-sdldate.

      CONCATENATE ls_down-sdldate+0(2) ls_down-sdldate+2(3) ls_down-sdldate+5(4)
      INTO ls_down-sdldate SEPARATED BY '-'.

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

    APPEND ls_final TO lt_final.


    APPEND ls_down TO lt_down.

    CLEAR : ls_final,ls_tstc,ls_tbtcp,ls_down.

  ENDLOOP.

  DELETE lt_final WHERE SDLDATE = '00000000'.
  DELETE lt_final WHERE LASTCHNAME = ''.
  DELETE lt_down  WHERE SDLDATE = '00000000'.
  DELETE lt_down  WHERE LASTCHNAME = ''.

  sort lt_final DESCENDING by LASTCHDATE LASTCHNAME.
  sort lt_down DESCENDING by LASTCHDATE LASTCHNAME.

  DELETE ADJACENT DUPLICATES FROM lt_final COMPARING jobname LASTCHDATE.
  DELETE ADJACENT DUPLICATES FROM lt_down COMPARING jobname LASTCHDATE.
  DELETE ADJACENT DUPLICATES FROM lt_final COMPARING jobname  sdldate sdltime.
  DELETE ADJACENT DUPLICATES FROM lt_down COMPARING jobname  sdldate sdltime.
*  DELETE ADJACENT DUPLICATES FROM lt_final COMPARING jobname  .
*  DELETE ADJACENT DUPLICATES FROM lt_down COMPARING jobname  .
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
  PERFORM fcat USING : '2'    'PROGNAME'    'LT_FINAL'  'Program Name'             '25' .
  PERFORM fcat USING : '3'    'JOBNAME'     'LT_FINAL'  'Job Name'                 '25' .
  PERFORM fcat USING : '4'    'VARIANT'     'LT_FINAL'  'Variant Name'             '25' .
  PERFORM fcat USING : '5'    'SDLTIME'     'LT_FINAL'  'Scheduled On'             '18' .
  PERFORM fcat USING : '6'    'SDLUNAME'    'LT_FINAL'  'Scheduled By'             '18' .
  PERFORM fcat USING : '7'    'SDLDATE'     'LT_FINAL'  'Job Creation Date'        '18' .
  PERFORM fcat USING : '8'    'LASTCHDATE'  'LT_FINAL'  'Last Changed Date'        '18' .
  PERFORM fcat USING : '9'    'LASTCHNAME'  'LT_FINAL'  'Last Changed Name'        '30' .
  PERFORM fcat USING : '10'   'FREQ'        'LT_FINAL'  'Frequency'                '18' .
  PERFORM fcat USING : '11'   'STRTDATE'    'LT_FINAL'  'Latest Date'              '18' .
  PERFORM fcat USING : '12'   'STRTTIME'    'LT_FINAL'  'Latest Time'              '18' .
  PERFORM fcat USING : '13'   'DURATION'    'LT_FINAL'  'Duration'                 '18' .
  PERFORM fcat USING : '14'   'PRIORITY'    'LT_FINAL'  'Priority'                 '18' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0365   text
*      -->P_0366   text
*      -->P_0367   text
*      -->P_0368   text
*      -->P_0369   text
*----------------------------------------------------------------------*
FORM fcat  USING VALUE(p1)
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
  BREAK primus.
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
  lv_file = 'ZJOB_SCHEDULES.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
  BREAK primus.
  WRITE: / 'ZJOB_SCHEDULES Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_529 TYPE string.
DATA lv_crlf_529 TYPE string.
lv_crlf_529 = cl_abap_char_utilities=>cr_lf.
lv_string_529 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_529 lv_crlf_529 wa_csv INTO lv_string_529.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
*TRANSFER lv_string_1019 TO lv_fullfile.
TRANSFER lv_string_529 TO lv_fullfile.
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
              'Job Name'
              'Variant Name'
              'Scheduled On'
              'Scheduled By'
              'Refresh Date'
              'Refresh Time'
              'Job Creation Date'
              'Last Changed Date'
              'Last Changed Name'
              'Frequency'
              'Latest Date'
              'Latest Time'
              'Duration'
              'Priority'

  INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
