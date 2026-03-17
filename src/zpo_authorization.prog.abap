*&---------------------------------------------------------------------*
*& Report ZPO_AUTHORIZATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpo_authorization.

TABLES : ekko,ekpo,cdhdr.

TYPES : BEGIN OF ty_cdhdr,
          objectclas TYPE cdhdr-objectclas,
          objectid   TYPE cdhdr-objectid,
          changenr   TYPE cdhdr-changenr,
          username   TYPE cdhdr-username,
          udate      TYPE cdhdr-udate,
          utime      TYPE cdhdr-utime,
          tcode      TYPE cdhdr-tcode,
        END OF ty_cdhdr,

        BEGIN OF ty_ekko,
          ebeln TYPE cdhdr-objectid,
          aedat TYPE ekko-aedat,
          lifnr TYPE ekko-lifnr,
          ekorg TYPE ekko-ekorg,
          bedat TYPE ekko-bedat,
          RLWRT TYPE ekko-RLWRT,
        END OF ty_ekko,
       BEGIN OF TY_LFA1,
         LIFNR2 TYPE LFA1-LIFNR,
         ADRNR TYPE LFA1-ADRNR,

         END OF TY_LFA1,

        BEGIN OF TY_ADRC,
         ADDRNUMBER TYPE ADRC-ADDRNUMBER ,
          NAME1   TYPE ADRC-NAME1,

          END OF TY_ADRC,

        BEGIN OF ty_ekpo,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          loekz TYPE ekpo-loekz,
        END OF ty_ekpo,

        BEGIN OF ty_final,
          objectid TYPE cdhdr-objectid,
          username TYPE cdhdr-username,
          udate    TYPE cdhdr-udate,
          utime    TYPE cdhdr-utime,
          tcode    TYPE cdhdr-tcode,
          dlt      TYPE char1,
          ebeln    TYPE ekpo-ebeln,
          ebelp    TYPE ekpo-ebelp,
          BEDAT    TYPE EKKO-BEDAT,
          LIFNR    TYPE EKKO-LIFNR,
          NAME1    TYPE ADRC-NAME1,
          ekorg    TYPE ekko-ekorg,
          PONETAMT    TYPE STRING,
        END OF ty_final,

        BEGIN OF ty_down,
          objectid TYPE cdhdr-objectid,
          username TYPE cdhdr-username,
          udate    TYPE char18,
          utime    TYPE char18,
          tcode    TYPE cdhdr-tcode,
          dlt      TYPE char1,
          BEDAT    TYPE CHAR15,
          LIFNR    TYPE EKKO-LIFNR,
           NAME1    TYPE ADRC-NAME1,
          ref_dat  TYPE char15,  "Refresh Date
          ref_time TYPE char15,  "Refresh Time
          ekorg    TYPE ekko-ekorg,
          PONETAMT    TYPE STRING,
        END OF ty_down.


DATA : BEGIN OF lt_temp OCCURS 0,
         ebeln1 TYPE cdhdr-objectid,
       END OF lt_temp.

DATA : lt_cdhdr TYPE TABLE OF ty_cdhdr,
       ls_cdhdr TYPE          ty_cdhdr,

       lt_ekko  TYPE TABLE OF ty_ekko,
       ls_ekko  TYPE          ty_ekko,

       lt_ekpo  TYPE TABLE OF ty_ekpo,
       ls_ekpo  TYPE          ty_ekpo,

       LT_LFA1 TYPE TABLE OF TY_LFA1,
       LS_LFA1 TYPE          TY_LFA1,

       LT_ADRC TYPE TABLE OF TY_ADRC,
       LS_ADRC TYPE  TY_ADRC,

       ls_temp  LIKE LINE OF lt_temp,

       lt_final TYPE TABLE OF ty_final,
       ls_final TYPE          ty_final,

       lt_down  TYPE TABLE OF ty_down,
       ls_down  TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_dat  FOR ekko-aedat,
                 s_ven  FOR ekko-lifnr,
                 s_org  FOR ekko-ekorg OBLIGATORY.
*PARAMETERS     : p_org TYPE ekko-ekorg OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

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

  SELECT ebeln
         aedat
         lifnr
         ekorg
         BEDAT
         RLWRT
    FROM ekko
    INTO TABLE lt_ekko
    WHERE aedat IN s_dat AND
          ekorg IN s_org AND
          lifnr IN s_ven.



SELECT LIFNR ADRNR FROM LFA1
  INTO TABLE LT_LFA1
  FOR ALL ENTRIES IN LT_EKKO
  WHERE LIFNR = LT_EKKO-LIFNR.

  SELECT ADDRNUMBER
         NAME1
    FROM ADRC
    INTO TABLE LT_ADRC
    FOR ALL ENTRIES IN LT_LFA1
    WHERE ADDRNUMBER = LT_LFA1-ADRNR.

  IF lt_ekko IS NOT INITIAL.

    SELECT objectclas
           objectid
           changenr
           username
           udate
           utime
           tcode
      FROM cdhdr
      INTO TABLE lt_cdhdr
      FOR ALL ENTRIES IN lt_ekko
      WHERE objectid = lt_ekko-ebeln AND
            tcode IN ( 'ME28' , 'ME29N' ).

    SELECT ebeln
           ebelp
           loekz
      FROM ekpo
      INTO TABLE lt_ekpo
      FOR ALL ENTRIES IN lt_ekko
      WHERE ebeln = lt_ekko-ebeln+0(10) AND
            loekz NE ' '.
 DELETE ADJACENT DUPLICATES FROM LT_EKPO COMPARING EBELN  loekz.
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
*  BREAK primus.
DATA : PONAMT TYPE STRING.
  LOOP AT lt_cdhdr INTO ls_cdhdr.

    ls_final-objectid = ls_cdhdr-objectid.
    ls_final-username = ls_cdhdr-username.
    ls_final-udate    = ls_cdhdr-udate.
    ls_final-utime    = ls_cdhdr-utime.
    ls_final-tcode    = ls_cdhdr-tcode.
    ls_final-dlt = 'N'.

          READ TABLE  lt_ekko INTO LS_EKKO WITH  KEY EBELN = ls_final-objectid .

          LS_FINAL-BEDAT = LS_EKKO-BEDAT.
          LS_FINAL-LIFNR = LS_EKKO-LIFNR.
          LS_FINAL-ekorg = LS_EKKO-ekorg.
          PONAMT = LS_EKKO-RLWRT.
          REPLACE ALL OCCURRENCES OF ',' IN PONAMT WITH ''.
          LS_FINAL-PONETAMT = PONAMT.

          READ TABLE LT_LFA1 INTO LS_LFA1 WITH KEY LIFNR2 = LS_FINAL-LIFNR.
            DATA(ADDRESS) = LS_LFA1-ADRNR.

            READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = ADDRESS.
            LS_FINAL-NAME1 = LS_ADRC-NAME1.


    APPEND ls_final TO lt_final.
    CLEAR : ls_final,ls_cdhdr,ls_ekpo,sy-subrc,ADDRESS.
    CLEAR PONAMT.

  ENDLOOP.

*  BREAK primus.

  LOOP AT lt_ekpo INTO ls_ekpo.
    ls_final-objectid = ls_ekpo-ebeln.
    ls_final-utime    = ' '.


          READ TABLE  lt_ekko INTO LS_EKKO WITH  KEY EBELN = ls_final-objectid .

          LS_FINAL-BEDAT = LS_EKKO-BEDAT.
          LS_FINAL-LIFNR = LS_EKKO-LIFNR.
          LS_FINAL-ekorg = LS_EKKO-ekorg.
          PONAMT = LS_EKKO-RLWRT.
          REPLACE ALL OCCURRENCES OF ',' IN PONAMT WITH ''.
          LS_FINAL-PONETAMT = PONAMT.


          READ TABLE LT_LFA1 INTO LS_LFA1 WITH KEY LIFNR2 = LS_FINAL-LIFNR.
            ADDRESS = LS_LFA1-ADRNR.

            READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = ADDRESS.
            LS_FINAL-NAME1 = LS_ADRC-NAME1.



    READ TABLE lt_cdhdr INTO ls_cdhdr WITH KEY  objectid = ls_ekpo-ebeln.
    IF sy-subrc NE 0.
      ls_final-dlt = 'Y'.
    ENDIF.

    IF ls_final-dlt IS NOT INITIAL.
      APPEND ls_final TO lt_final.

    ENDIF.
*    DELETE ADJACENT DUPLICATES FROM LT_FINAL

    CLEAR: ls_final,ADDRESS,PONAMT.
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

  PERFORM fcat USING : '1'    'OBJECTID'       'LT_FINAL'  'Purchasing Document'     '18' .
  PERFORM fcat USING : '2'    'USERNAME'       'LT_FINAL'  'Released By'             '18' .
  PERFORM fcat USING : '3'    'UDATE'          'LT_FINAL'  'Released on '            '18' .
  PERFORM fcat USING : '4'    'UTIME'          'LT_FINAL'  'Time'                    '18' .
  PERFORM fcat USING : '5'    'TCODE'          'LT_FINAL'  'TCode'                   '18' .
  PERFORM fcat USING : '6'    'DLT'            'LT_FINAL'  'Deleted'                 '18' .
  PERFORM fcat USING : '7'    'BEDAT'            'LT_FINAL'    'Purchase Order Date'  '18' .
  PERFORM fcat USING : '8'    'LIFNR'            'LT_FINAL'  'Vendor'               '18' .
  PERFORM fcat USING : '9'    'NAME1'            'LT_FINAL'  'Vendor Name'          '18' .
  PERFORM fcat USING : '10'   'EKORG'            'LT_FINAL'  'Purchase Org.'          '18' .
  PERFORM fcat USING : '11'   'PONETAMT'            'LT_FINAL'  'PO Relased Net Val.'          '18' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0416   text
*      -->P_0417   text
*      -->P_0418   text
*      -->P_0419   text
*      -->P_0420   text
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
  wa_fcat-outputlen = p5.

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

  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X' .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'TOP'
      i_background_id        = 'ALV_BACKGROUND'
      is_layout              = ls_layout
      it_fieldcat            = it_fcat[]
    TABLES
      t_outtab               = lt_final[]
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download.
    PERFORM download_excel.
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

  LOOP AT lt_final INTO ls_final.

    ls_down-objectid = ls_final-objectid.
    ls_down-username = ls_final-username.
    ls_down-tcode    = ls_final-tcode.
    ls_down-dlt      = ls_final-dlt.
    ls_down-BEDAT      = LS_FINAL-BEDAT.
    ls_down-LIFNR      =  LS_FINAL-LIFNR.
    ls_down-name1      =  LS_FINAL-name1.
    ls_down-ekorg      =  LS_FINAL-ekorg.
    ls_down-PONETAMT      =  LS_FINAL-PONETAMT.


    IF LS_FINAL-BEDAT IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = LS_FINAL-BEDAT
        IMPORTING
          output = ls_down-BEDAT.

      CONCATENATE ls_down-BEDAT+0(2) ls_down-BEDAT+2(3) ls_down-BEDAT+5(4)
      INTO ls_down-BEDAT SEPARATED BY '-'.

    ENDIF.

    IF ls_final-udate IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-udate
        IMPORTING
          output = ls_down-udate.

      CONCATENATE ls_down-udate+0(2) ls_down-udate+2(3) ls_down-udate+5(4)
      INTO ls_down-udate SEPARATED BY '-'.

    ENDIF.

    IF ls_final-utime IS NOT INITIAL.

      CONCATENATE ls_final-utime+0(2) ':' ls_final-utime+2(2)  INTO ls_down-utime.

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

    APPEND ls_down TO lt_down.
    CLEAR ls_down.

  ENDLOOP.

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
  lv_file = 'ZPO_AUTHORIZATION.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZPO_AUTHORIZATION Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_496 TYPE string.
DATA lv_crlf_496 TYPE string.
lv_crlf_496 = cl_abap_char_utilities=>cr_lf.
lv_string_496 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_496 lv_crlf_496 wa_csv INTO lv_string_496.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_619 TO lv_fullfile.
TRANSFER lv_string_496 TO lv_fullfile.
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

  CONCATENATE 'Purchasing Document'
              'Released By'
              'Released on '
              'Time'
              'TCode'
              'Deleted'
              'Purchase Order Date'
                'Vendor'
                'Vendor Name'
                'Refresh Date'
                'Refresh Time'
                'Purchase Org.'
                'PO Released Net Val.'
  INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.

FORM top.

  DATA: lt_listheader TYPE TABLE OF slis_listheader,
        ls_listheader TYPE slis_listheader,
        ls_month_name TYPE t7ru9a-regno,
        gs_string     TYPE string,
        gs_month(2)   TYPE n,
        t_line        LIKE ls_listheader-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

  REFRESH lt_listheader.
  CLEAR ls_listheader.

  ls_listheader-typ = 'H'.
  ls_listheader-info = 'ZPO_AUTHORIZATION REPORT'."GS_STRING.
  APPEND ls_listheader TO lt_listheader.
  CLEAR ls_listheader.

  gs_string = ''.
  CONCATENATE 'REPORT RUN DATE :' sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum+0(4) INTO gs_string SEPARATED BY ''.
  ls_listheader-typ = 'S'.
  ls_listheader-info =  gs_string.
  APPEND ls_listheader TO lt_listheader.
  CLEAR ls_listheader.

  gs_string = ''.
  CONCATENATE 'REPORT RUN TIME :' sy-uzeit+0(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2) INTO gs_string SEPARATED BY ''.
  ls_listheader-typ = 'S'.
*  LS_LISTHEADER-KEY = 'REPORT RUN TIME'.
  ls_listheader-info =  gs_string.
  APPEND ls_listheader TO lt_listheader.
  CLEAR ls_listheader.

  DESCRIBE TABLE lt_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' ld_linesc
  INTO t_line SEPARATED BY space.

  ls_listheader-typ  = 'A'.
  ls_listheader-info = t_line.
  APPEND ls_listheader TO lt_listheader.
  CLEAR: ls_listheader, t_line.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_listheader
      i_logo             = 'NEW_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

ENDFORM.
