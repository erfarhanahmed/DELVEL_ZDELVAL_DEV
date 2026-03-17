*&---------------------------------------------------------------------*
*& Report ZOFM_BOOKING_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zofm_booking_report.

TYPE-POOLS: slis.

TABLES : zofm_booking,vbak,kna1.

TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          erdat TYPE vbak-erdat,
          vdatu TYPE vbak-vdatu,
          kunnr TYPE vbak-kunnr,
        END OF ty_vbak,

        BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
        END OF ty_kna1.

TYPES : BEGIN OF ty_final,
          zsoref        TYPE zofm_booking-zsoref,
          zscope        TYPE zofm_booking-zscope,
          zofm_rev_no   TYPE zofm_booking-zofm_rev_no,
          zrev_date     TYPE zofm_booking-zrev_date,
          zbooking_curr TYPE zofm_booking-zbooking_curr,
          zcur_conv     TYPE zofm_booking-zcur_conv,
          zbook_value   TYPE zofm_booking-zbook_value,
          zinr_val      TYPE zofm_booking-zinr_val,
          zagrr_val     TYPE zofm_booking-zagrr_val,
          zprice        TYPE zofm_booking-zprice,
          zbutt         TYPE zofm_booking-zbutt,
          zball_vales   TYPE zofm_booking-zball_vales,
          zoffset_val   TYPE zofm_booking-zoffset_val,
          zact_cnt      TYPE zofm_booking-zact_cnt,
          zservice      TYPE zofm_booking-zservice,
          zremark       TYPE zofm_booking-zremark,
          zgross_m      TYPE zofm_booking-zgross_m,
          branch        TYPE zofm_booking-branch,
          name1         TYPE kna1-name1,
          text          TYPE string,
          date          TYPE vbak-vdatu,
        END OF ty_final.


TYPES : BEGIN OF ty_down,
          zsoref        TYPE zofm_booking-zsoref,
          zscope        TYPE zofm_booking-zscope,
          zofm_rev_no   TYPE zofm_booking-zofm_rev_no,
          zrev_date     TYPE char18,
          zbooking_curr TYPE zofm_booking-zbooking_curr,
          zcur_conv     TYPE string,
          zbook_value   TYPE string,
          zinr_val      TYPE string,
          zagrr_val     TYPE string,
          zprice        TYPE string,
          zbutt         TYPE string,
          zball_vales   TYPE string,
          zoffset_val   TYPE string,
          zact_cnt      TYPE string,
          zservice      TYPE string,
          zremark       TYPE zofm_booking-zremark,
          zgross_m      TYPE string,
          branch        TYPE zofm_booking-branch,
          name1         TYPE kna1-name1,
          text          TYPE string,
          date          TYPE char18,
          ref_dat       TYPE char18,
          ref_time      TYPE char18,
        END OF ty_down.

DATA: count     TYPE i,
      lv_string TYPE string,
      lv_name   TYPE thead-tdname,
      gt_lines  TYPE TABLE OF tline.


DATA : lt_ofm   TYPE TABLE OF zofm_booking,
       ls_ofm   TYPE          zofm_booking,
       lt_ofm1   TYPE TABLE OF zofm_booking,
       ls_ofm1   TYPE          zofm_booking,

       it_final TYPE TABLE OF ty_final,
       wa_final TYPE          ty_final,

       lt_vbak  TYPE TABLE OF ty_vbak,
       ls_vbak  TYPE          ty_vbak,

       lt_kna1  TYPE TABLE OF ty_kna1,
       ls_kna1  TYPE          ty_kna1.

DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA : ls_layout TYPE slis_layout_alv.

SELECTION-SCREEN :BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_sono   FOR zofm_booking-zsoref,
                s_date   FOR zofm_booking-zrev_date,
                s_bran   FOR vbak-vkbur.
SELECTION-SCREEN : END OF BLOCK b1 .


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
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


  SELECT *
   FROM zofm_booking
   INTO TABLE lt_ofm1
   WHERE zsoref IN s_sono AND
         branch IN s_bran."AND
*         zrev_date IN s_date.


  SELECT vbeln
         erdat
         vdatu
         kunnr
    FROM vbak
    INTO TABLE lt_vbak
    FOR ALL ENTRIES IN lt_ofm1
        WHERE vbeln = lt_ofm1-zsoref
        and audat in s_date.


  SELECT kunnr
         name1
     FROM kna1
     INTO TABLE lt_kna1
     FOR ALL ENTRIES IN lt_vbak
        WHERE kunnr = lt_vbak-kunnr.

 LOOP AT lt_vbak INTO ls_vbak.
   READ TABLE lt_ofm1 INTO LS_OFM1 WITH KEY zsoref = lS_VBAK-VBELN.
   IF sy-subrc = 0.
          LS_OFM-zsoref        = LS_OFM1-zsoref.
          LS_OFM-zscope        = LS_OFM1-zscope.
          LS_OFM-zofm_rev_no   = LS_OFM1-zofm_rev_no.
          LS_OFM-zrev_date     = LS_OFM1-zrev_date.
          LS_OFM-zbooking_curr = LS_OFM1-zbooking_curr.
          LS_OFM-zcur_conv     = LS_OFM1-zcur_conv.
          LS_OFM-zbook_value   = LS_OFM1-zbook_value.
          LS_OFM-zinr_val      = LS_OFM1-zinr_val.
          LS_OFM-zagrr_val     = LS_OFM1-zagrr_val.
          LS_OFM-zprice        = LS_OFM1-zprice.
          LS_OFM-zbutt         = LS_OFM1-zbutt.
          LS_OFM-zball_vales   = LS_OFM1-zball_vales.
          LS_OFM-zoffset_val   = LS_OFM1-zoffset_val.
          LS_OFM-zact_cnt      = LS_OFM1-zact_cnt.
          LS_OFM-zservice      = LS_OFM1-zservice.
          LS_OFM-zremark       = LS_OFM1-zremark.
          LS_OFM-zgross_m      = LS_OFM1-zgross_m.
          LS_OFM-branch        = LS_OFM1-branch.
          APPEND ls_ofm to lt_ofm.
        ENDIF.


   ENDLOOP.

  IF lt_vbak IS NOT INITIAL.
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

************process data*********
  LOOP AT lt_ofm INTO ls_ofm.

    wa_final-zsoref            =  ls_ofm-zsoref.
    wa_final-zscope            =  ls_ofm-zscope.
    wa_final-zofm_rev_no       =  ls_ofm-zofm_rev_no.
    wa_final-zrev_date         =  ls_ofm-zrev_date  .
    wa_final-zbooking_curr     =  ls_ofm-zbooking_curr.
    wa_final-zcur_conv         =  ls_ofm-zcur_conv  .
    wa_final-zbook_value       =  ls_ofm-zbook_value.
    wa_final-zinr_val          =  ls_ofm-zinr_val   .
    wa_final-zagrr_val         =  ls_ofm-zagrr_val  .
    wa_final-zprice            =  ls_ofm-zprice     .
    wa_final-zbutt             =  ls_ofm-zbutt      .
    wa_final-zball_vales       =  ls_ofm-zball_vales.
    wa_final-zoffset_val       =  ls_ofm-zoffset_val.
    wa_final-zact_cnt          =  ls_ofm-zact_cnt   .
    wa_final-zservice          =  ls_ofm-zservice   .
    wa_final-zremark           =  ls_ofm-zremark    .
    wa_final-zgross_m          =  ls_ofm-zgross_m   .
    wa_final-branch            =  ls_ofm-branch     .


    READ TABLE lt_vbak INTO DATA(ls_vbak) WITH  KEY vbeln = wa_final-zsoref.
    wa_final-date      = ls_vbak-vdatu .

    READ TABLE lt_kna1 INTO DATA(ls_kna1) WITH KEY kunnr = ls_vbak-kunnr.
    wa_final-name1      = ls_kna1-name1.

    lv_name = wa_final-zsoref.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'ZZ99'
        language                = sy-langu
        name                    = lv_name
        object                  = 'VBBK'
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
* IMPORTING
*       HEADER                  =
*       OLD_LINE_COUNTER        =
      TABLES
        lines                   = gt_lines
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

    IF NOT gt_lines IS INITIAL.
      READ TABLE gt_lines INTO DATA(wa_lines) INDEX 1.
      wa_final-text = wa_lines-tdline.
    ENDIF.

    APPEND wa_final TO it_final.
    CLEAR : wa_final,ls_ofm,ls_vbak,ls_kna1.

  ENDLOOP .

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

  PERFORM fcat USING :      '1'   'ZSOREF'           'IT_FINAL'           'SOREF'                           '18' ,
                            '2'   'ZSCOPE'           'IT_FINAL'           'SCOPE'                           '50',
                            '3'   'ZOFM_REV_NO'      'IT_FINAL'           'OFM Revision No'                 '10' ,
                            '4'   'ZREV_DATE'        'IT_FINAL'           'Rev Date'                        '18' ,
                            '5'   'ZBOOKING_CURR'    'IT_FINAL'           'Booking Currency'                '18' ,
                            '6'   'ZCUR_CONV'        'IT_FINAL'           'Currency Conversion'             '18' ,
                            '7'   'ZBOOK_VALUE'      'IT_FINAL'           'Booking Value'                   '18' ,
                            '8'   'ZINR_VAL'         'IT_FINAL'           'Value In Home Currency INR'      '18' ,
                            '9'   'ZAGRR_VAL'        'IT_FINAL'           'Value In Agreed Currency USD'    '18' ,
                           '10'   'ZPRICE'           'IT_FINAL'           'Base Price from Sales Order'     '18' ,
                           '11'   'ZBUTT'            'IT_FINAL'           'Butterfly Valves'                '18' ,
                           '12'   'ZBALL_VALES'      'IT_FINAL'           'Ball Valves'                     '18' ,
                           '13'   'ZOFFSET_VAL'      'IT_FINAL'           'Triple Offset Valves'            '18' ,
                           '14'   'ZACT_CNT'         'IT_FINAL'           'Actuation and Control'           '18' ,
                           '15'   'ZSERVICE'         'IT_FINAL'           'Service'                         '18' ,
                           '16'   'ZREMARK'          'IT_FINAL'           'Remarks'                         '250' ,
                           '17'   'ZGROSS_M'         'IT_FINAL'           'Gross Margin'                    '18' ,
                           '18'   'BRANCH'           'IT_FINAL'           'Branch'                          '10' ,
                           '19'   'NAME1'            'IT_FINAL'           'Customer Name'                   '50' ,
                           '20'   'TEXT'             'IT_FINAL'           'PO Reference No'                 '50' ,
                           '21'   'DATE'             'IT_FINAL'           'Customer Del date'                 '18' .

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
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
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
      i_callback_program = sy-repid
*     I_GRID_SETTINGS    =
      is_layout          = ls_layout
      it_fieldcat        = it_fcat
      i_save             = 'X'
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download_sort.
    PERFORM download.
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
  lv_file = 'ZOFM_BOOKING_REPORT.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZOFM_BOOKING_REPORT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_415 TYPE string.
DATA lv_crlf_415 TYPE string.
lv_crlf_415 = cl_abap_char_utilities=>cr_lf.
lv_string_415 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_415 lv_crlf_415 wa_csv INTO lv_string_415.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_415 TO lv_fullfile.
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
FORM cvs_header  USING   hd_csv.


  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.


  CONCATENATE  'SOREF'
               'SCOPE'
               'OFM Revision No'
               'Rev Date'
               'Booking Currency'
               'Currency Conversion'
               'Booking Value'
               'Value In Home Currency INR'
               'Value In Agreed Currency USD'
               'Base Price from Sales Order'
               'Butterfly Valves'
               'Ball Valves'
               'Triple Offset Valves'
               'Actuation and Control'
               'Service'
               'Remarks'
               'Gross Margin'
               'Branch'
               'Customer Name'
               'PO Reference No'
               'Customer Del date'
               'Refresh Date'
               'Refresh Time'
                INTO hd_csv
                SEPARATED BY l_field_seperator.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_sort.

  LOOP AT it_final INTO wa_final.

    ls_down-zsoref            =  wa_final-zsoref.
    ls_down-zscope            =  wa_final-zscope.
    ls_down-zofm_rev_no       =  wa_final-zofm_rev_no.
    ls_down-zbooking_curr     =  wa_final-zbooking_curr.
    ls_down-zcur_conv         =  wa_final-zcur_conv.

   IF wa_final-zbook_value LT 0.
    ls_down-zbook_value       =  wa_final-zbook_value * -1.
   ELSE.
    ls_down-zbook_value       =  wa_final-zbook_value.
   ENDIF.

    CONDENSE ls_down-zbook_value.
    if wa_finAL-zbook_value < 0.
      CONCATENATE '-' ls_down-zbook_value INTO ls_down-zbook_value.
    ENDIF.

IF wa_final-zinr_val LT 0.
    ls_down-zinr_val       =  wa_final-zinr_val * -1.
   ELSE.
    ls_down-zinr_val       =  wa_final-zinr_val.
   ENDIF.

    CONDENSE ls_down-zinr_val.
    if wa_finAL-zinr_val < 0.
      CONCATENATE '-' ls_down-zinr_val INTO ls_down-zinr_val.
    ENDIF.

IF wa_final-zagrr_val  LT 0.
    ls_down-zagrr_val        =  wa_final-zagrr_val  * -1.
   ELSE.
    ls_down-zagrr_val        =  wa_final-zagrr_val .
   ENDIF.

    CONDENSE ls_down-zagrr_val .
    if wa_finAL-zagrr_val  < 0.
      CONCATENATE '-' ls_down-zagrr_val  INTO ls_down-zagrr_val .
    ENDIF.


    IF wa_final-zprice     LT 0.
    ls_down-zprice           =  wa_final-zprice     * -1.
   ELSE.
    ls_down-zprice           =  wa_final-zprice    .
   ENDIF.

    CONDENSE ls_down-zprice    .
    if wa_finAL-zprice    < 0.
      CONCATENATE '-' ls_down-zprice     INTO ls_down-zprice    .
    ENDIF.

  IF wa_final-zbutt       LT 0.
    ls_down-zbutt            =  wa_final-zbutt       * -1.
   ELSE.
    ls_down-zbutt             =  wa_final-zbutt      .
   ENDIF.

    CONDENSE ls_down-zbutt      .
    if wa_finAL-zbutt      < 0.
      CONCATENATE '-' ls_down-zbutt       INTO ls_down-zbutt     .
    ENDIF.

   IF wa_final-zball_vales    LT 0.
    ls_down-zball_vales              =  wa_final-zball_vales          * -1.
   ELSE.
    ls_down-zball_vales               =  wa_final-zball_vales        .
   ENDIF.

    CONDENSE ls_down-zball_vales         .
    if wa_finAL-zball_vales     < 0.
      CONCATENATE '-' ls_down-zball_vales   INTO ls_down-zball_vales  .
    ENDIF.

    IF wa_final-zoffset_val  LT 0.
    ls_down-zoffset_val   =  wa_final-zoffset_val  * -1.
   ELSE.
    ls_down-zoffset_val               =  wa_final-zoffset_val        .
   ENDIF.

    CONDENSE ls_down-zoffset_val         .
    if wa_finAL-zoffset_val       < 0.
      CONCATENATE '-' ls_down-zoffset_val    INTO ls_down-zoffset_val  .
    ENDIF.

    IF wa_final-zact_cnt   LT 0.
    ls_down-zact_cnt  =  wa_final-zact_cnt   * -1.
   ELSE.
    ls_down-zact_cnt =  wa_final-zact_cnt         .
   ENDIF.

    CONDENSE ls_down-zact_cnt         .
    if wa_finAL-zact_cnt       < 0.
      CONCATENATE '-' ls_down-zact_cnt   INTO ls_down-zact_cnt  .
    ENDIF.


    IF wa_final-zservice LT 0.
       ls_down-zservice = wa_final-zservice * -1.
    ELSE.
       ls_down-zservice = wa_final-zservice      .
    ENDIF.

    CONDENSE ls_down-zservice.
    IF wa_final-zservice < 0.
      CONCATENATE '-' ls_down-zservice INTO ls_down-zservice.
    ENDIF.

    ls_down-zremark           =  wa_final-zremark.

    IF wa_final-zgross_m    LT 0.
    ls_down-zgross_m  =  wa_final-zgross_m  * -1.
   ELSE.
    ls_down-zgross_m  =  wa_final-zgross_m         .
   ENDIF.

    CONDENSE ls_down-zgross_m         .
    if wa_finAL-zgross_m       < 0.
      CONCATENATE '-' ls_down-zgross_m   INTO ls_down-zgross_m  .
    ENDIF.

    ls_down-branch            =  wa_final-branch.
    ls_down-name1             =  wa_final-name1.
    ls_down-text              =  wa_final-text.

    IF wa_final-date IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-date
        IMPORTING
          output = ls_down-date.

      CONCATENATE ls_down-date+0(2) ls_down-date+2(3) ls_down-date+5(4)
      INTO ls_down-date SEPARATED BY '-'.

    ENDIF.

    IF wa_final-zrev_date IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-zrev_date
        IMPORTING
          output = ls_down-zrev_date.

      CONCATENATE ls_down-zrev_date+0(2) ls_down-zrev_date+2(3) ls_down-zrev_date+5(4)
      INTO ls_down-zrev_date SEPARATED BY '-'.

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
    CLEAR : ls_down,wa_final.

  ENDLOOP.

ENDFORM.
