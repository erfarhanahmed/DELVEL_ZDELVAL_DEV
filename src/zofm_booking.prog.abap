*&---------------------------------------------------------------------*
*& Report ZOFM_BOOKING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zofm_booking.

TABLES : zofm_booking,vbak .

TYPES : BEGIN OF ty_ofm,
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
        END OF ty_ofm.

DATA : it_ofm TYPE TABLE OF ty_ofm,
       wa_ofm TYPE ty_ofm.

DATA : it_final TYPE TABLE OF ty_ofm,
       wa_final TYPE ty_ofm.

TYPES : BEGIN OF ty_down,
          zsoref        TYPE char20,           "zofm_booking-zsoref,
          zscope        TYPE char20,           "zofm_booking-zscope,
          zofm_rev_no   TYPE char20,           "zofm_booking-zofm_rev_no,
          zrev_date     TYPE char20,            "zofm_booking-zrev_date,
          zbooking_curr TYPE char20,            "zofm_booking-zbooking_curr,
          zcur_conv     TYPE char20,            "zofm_booking-zcur_conv,
          zbook_value   TYPE char20, "zofm_booking-zbook_value,
          zinr_val      TYPE char20, "zofm_booking-zinr_val,       "Value In Agreed Currency USD
          zagrr_val     TYPE char20, "zofm_booking-zagrr_val,
          zprice        TYPE char20, "zofm_booking-zprice,
          zbutt         TYPE char20, "zofm_booking-zbutt,
          zball_vales   TYPE char20, "zofm_booking-zball_vales,        "Ball Valves
          zoffset_val   TYPE char20, "zofm_booking-zoffset_val,
          zact_cnt      TYPE char20, "zofm_booking-zact_cnt,           "Actuation and Control
          zservice      TYPE char20, "zofm_booking-zservice,
          zremark       TYPE char20, "zofm_booking-zremark,
          zgross_m      TYPE char20, "zofm_booking-zgross_m,
          branch        TYPE char20, "zofm_booking-branch,
          ref_dat       TYPE char15,                         "Refresh Date
          ref_time      TYPE char15,                        "Refresh Time
        END OF ty_down.

DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.


DATA : wa_fcat   TYPE  slis_fieldcat_alv,                         "Field catalog work area
       i_fcat    TYPE  slis_t_fieldcat_alv,                        "field catalog internal table
       gd_layout TYPE slis_layout_alv.                            "ALV layout settings



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.  "Selection Scrren for TMG
SELECT-OPTIONS: s_sono   FOR zofm_booking-zsoref,
                s_date   FOR vbak-audat.
SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.


START-OF-SELECTION.

*  BREAK primus.


  SELECT  zsoref
          zscope
          zofm_rev_no
          zrev_date
          zbooking_curr
          zcur_conv
          zbook_value
          zinr_val
          zagrr_val
          zprice
          zbutt
          zball_vales
          zoffset_val
          zact_cnt
          zservice
          zremark
          zgross_m
          branch     FROM zofm_booking INTO TABLE it_ofm WHERE zsoref IN  s_sono.

  LOOP AT it_ofm INTO wa_ofm.



    IF sy-subrc = 0.

      wa_final-zsoref                = wa_ofm-zsoref.
      wa_final-zscope                = wa_ofm-zscope.
      wa_final-zofm_rev_no           = wa_ofm-zofm_rev_no.
      wa_final-zrev_date             = wa_ofm-zrev_date.
      wa_final-zbooking_curr         = wa_ofm-zbooking_curr.
      wa_final-zcur_conv             =  wa_ofm-zcur_conv.
      wa_final-zbook_value           = wa_ofm-zbook_value.
      wa_final-zinr_val              = wa_ofm-zinr_val.
      wa_final-zagrr_val            = wa_ofm-zagrr_val.
      wa_final-zprice               = wa_ofm-zprice.
      wa_final-zbutt                = wa_ofm-zbutt.
      wa_final-zball_vales          = wa_ofm-zball_vales.
      wa_final-zoffset_val          = wa_ofm-zoffset_val.
      wa_final-zact_cnt             = wa_ofm-zact_cnt.
      wa_final-zservice             = wa_ofm-zservice.
      wa_final-zremark              = wa_ofm-zremark.
      wa_final-zgross_m             = wa_ofm-zgross_m.
      wa_final-branch               = wa_ofm-branch.

    ENDIF.
    APPEND wa_final TO it_final.
    CLEAR wa_final.
  ENDLOOP.


  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ZSOREF' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'SOREF' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'ZSCOPE' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'SCOPE' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'ZOFM_REV_NO' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'OFM Revision No' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'ZREV_DATE' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Rev Date' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'ZBOOKING_CURR' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Booking Currency' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'ZCUR_CONV' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Currency Conversion' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'ZBOOK_VALUE' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Booking Value' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'ZINR_VAL' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Value In Home Currency INR' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'ZAGRR_VAL' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Value In Agreed Currency USD' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  wa_fcat-col_pos = '10' .
  wa_fcat-fieldname = 'ZPRICE' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Base Price from Sales Order' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  wa_fcat-col_pos = '11' .
  wa_fcat-fieldname = 'ZBUTT' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Butterfly Valves' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '12' .
  wa_fcat-fieldname = 'ZBALL_VALES' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Ball Valves' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '13' .
  wa_fcat-fieldname = 'ZOFFSET_VAL' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Triple Offset Valves' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '14' .
  wa_fcat-fieldname = 'ZACT_CNT' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Actuation and Control' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '15' .
  wa_fcat-fieldname = 'ZSERVICE' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Service' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '16' .
  wa_fcat-fieldname = 'ZREMARK' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Remarks' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '17' .
  wa_fcat-fieldname = 'ZGROSS_M' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Gross Margin' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '18' .
  wa_fcat-fieldname = 'BRANCH' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Branch Code' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  gd_layout-zebra = 'X'.
  gd_layout-colwidth_optimize = 'X' .


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gd_layout
      it_fieldcat        = i_fcat[]
    TABLES
      t_outtab           = it_final[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



  IF p_down = 'X'.

    PERFORM download.
    PERFORM download_file.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .

  LOOP AT it_final INTO wa_final.

    IF sy-subrc = 0.

      ls_down-zsoref          =  wa_final-zsoref.
      ls_down-zscope          = wa_final-zscope.
      ls_down-zofm_rev_no     = wa_final-zofm_rev_no.
*      ls_down-zrev_date       = wa_final-zrev_date.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-zrev_date
        IMPORTING
          output = ls_down-zrev_date.

      CONCATENATE ls_down-zrev_date+0(2) ls_down-zrev_date+2(3) ls_down-zrev_date+5(4)
     INTO ls_down-zrev_date SEPARATED BY '-'.

      ls_down-zbooking_curr   = wa_final-zbooking_curr.
      ls_down-zcur_conv       = wa_final-zcur_conv.
*      ls_down-zbook_value     = wa_final-zbook_value .
******************       Avinash Bhagat
                   ls_down-zbook_value        = abs( wa_final-zbook_value ).
CONDENSE ls_down-zbook_value.
IF wa_final-zbook_value < 0.
        CONCATENATE '-' ls_down-zbook_value INTO ls_down-zbook_value.
ENDIF.

ls_down-zinr_val        = abs( wa_final-zinr_val ).
CONDENSE ls_down-zinr_val.
IF wa_final-zinr_val < 0.
        CONCATENATE '-' ls_down-zinr_val INTO ls_down-zinr_val.
ENDIF.
*      ls_down-zinr_val        = wa_final-zinr_val.                      "Value In Agreed Currency USD

ls_down-zagrr_val        = abs( wa_final-zagrr_val ).
CONDENSE ls_down-zagrr_val.
IF wa_final-zagrr_val < 0.
        CONCATENATE '-' ls_down-zagrr_val INTO ls_down-zagrr_val.
ENDIF.
*      ls_down-zagrr_val     = wa_final-zagrr_val.
ls_down-zprice        = abs( wa_final-zprice ).
CONDENSE ls_down-zprice.
IF wa_final-zprice < 0.
        CONCATENATE '-' ls_down-zprice INTO ls_down-zprice.
ENDIF.
*      ls_down-zprice        = wa_final-zagrr_val.

      IF  wa_final-zbutt = 0.
        ls_down-zbutt = space.
      ELSE.
*        ls_down-zbutt         = wa_final-zbutt.
        ls_down-zbutt        = abs( wa_final-zbutt ).
CONDENSE ls_down-zbutt.
IF wa_final-zbutt < 0.
        CONCATENATE '-' ls_down-zbutt INTO ls_down-zbutt.
ENDIF.
      ENDIF.



      IF  wa_final-zball_vales = 0.
        ls_down-zball_vales = space.
      ELSE.
*        ls_down-zball_vales   = wa_final-zball_vales.
                ls_down-zball_vales        = abs( wa_final-zball_vales ).
CONDENSE ls_down-zball_vales.
IF wa_final-zball_vales < 0.
        CONCATENATE '-' ls_down-zball_vales INTO ls_down-zball_vales.
ENDIF.
      ENDIF.                    "Ball Valves

      IF  wa_final-zoffset_val = 0.
        ls_down-zoffset_val = space.
      ELSE.
*        ls_down-zoffset_val   = wa_final-zoffset_val.
                        ls_down-zoffset_val        = abs( wa_final-zoffset_val ).
CONDENSE ls_down-zoffset_val.
IF wa_final-zoffset_val < 0.
        CONCATENATE '-' ls_down-zoffset_val INTO ls_down-zoffset_val.
ENDIF.
      ENDIF.


*      IF  wa_final-zoffset_val = 0.
*        ls_down-zoffset_val = space.
*      ELSE.
**        ls_down-zoffset_val   = wa_final-zoffset_val.
*                                ls_down-zoffset_val        = abs( wa_final-zoffset_val ).
*CONDENSE ls_down-zoffset_val.
*IF wa_final-zoffset_val < 0.
*        CONCATENATE '-' ls_down-zoffset_val INTO ls_down-zoffset_val.
*ENDIF.
*      ENDIF.

      IF  wa_final-zact_cnt = 0.
        ls_down-zact_cnt = space.
      ELSE.
*      ls_down-zact_cnt      = wa_final-zact_cnt .
                              ls_down-zact_cnt        = abs( wa_final-zact_cnt ).
CONDENSE ls_down-zact_cnt.
IF wa_final-zact_cnt < 0.
        CONCATENATE '-' ls_down-zact_cnt INTO ls_down-zact_cnt.
ENDIF.                    "Actuation and Control
      endif.

      IF  wa_final-zservice = 0.
        ls_down-zservice = space.
      ELSE.

*        ls_down-zservice      = wa_final-zservice.
                                      ls_down-zservice        = abs( wa_final-zservice ).
CONDENSE ls_down-zservice.
IF wa_final-zservice < 0.
        CONCATENATE '-' ls_down-zservice INTO ls_down-zservice.
ENDIF.
      ENDIF.

      ls_down-zremark       = wa_final-zremark.

      IF  wa_final-zgross_m = 0.
        ls_down-zgross_m = space.
      ELSE.
        ls_down-zgross_m      = wa_final-zgross_m.
      ENDIF.

      ls_down-branch        = wa_final-branch.


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
      CLEAR: ls_down.

    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_file .

  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.


  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

*BREAK-POINT.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
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
  lv_file = 'ZOFM_BOOKING.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZOFM_BOOKING Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_504 TYPE string.
DATA lv_crlf_504 TYPE string.
lv_crlf_504 = cl_abap_char_utilities=>cr_lf.
lv_string_504 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_504 lv_crlf_504 wa_csv INTO lv_string_504.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_278 TO lv_fullfile.
TRANSFER lv_string_504 TO lv_fullfile.
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

  CONCATENATE  'Soref'
               'Scope'
               'OFM Revision no'
               'Rev Date'
               'Booking Currency'
               'Currency Conversion'
               'Booking Value'
               'Value in Home Currency Inr'
               'Value in agreed currency USD'
               'Base price from sales order'
               'Butterfly valves'
               'Ball Valves'
               'Triple offset valves'
               'Actuation and Control'
               'Service'
               'Remarks'
               'Gross Margin'
               'Branch Code'
               'Refresh date'
               'Refresh time'
          INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
