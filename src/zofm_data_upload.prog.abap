*&---------------------------------------------------------------------*
*& Report ZOFM_DATA_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zofm_data_upload.

TABLES : sscrfields,kna1.

TYPE-POOLS : truxs.

TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          erdat TYPE vbak-erdat,
          knumv TYPE vbak-knumv,
          vkbur TYPE vbak-vkbur,
        END OF ty_vbak.

TYPES : BEGIN OF ty_konv,
          knumv TYPE prcd_elements-knumv,
          kposn TYPE prcd_elements-kposn,
          kschl TYPE prcd_elements-kschl,
          kwert TYPE prcd_elements-kwert,
        END OF ty_konv.

DATA : ls_vbak TYPE ty_vbak,
       ls_konv TYPE ty_konv,
       lt_konv TYPE TABLE OF ty_konv,
       ls_curr TYPE zcurr_tab.

DATA : sum_kwert TYPE prcd_elements-kwert,
       sum_book  TYPE zofm_booking-zbook_value,
       diff_book TYPE string,
       usd_rate  TYPE  zcurr_tab-zex_rate,
       lv_msg    TYPE string.

TYPES : BEGIN OF ty_ofm,
          zsoref        TYPE zofm_booking-zsoref,
          zscope        TYPE zofm_booking-zscope,
          zofm_rev_no   TYPE zofm_booking-zofm_rev_no,
          zrev_date     TYPE datum,
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

TYPES: trux_t_text_data(4096) TYPE c OCCURS 0.
DATA : lt_raw TYPE trux_t_text_data.

DATA : count    TYPE i VALUE 0,
       cnt      TYPE i VALUE 0,
       gv_cnt   TYPE i VALUE 0,
       wa_vbeln TYPE vbak-vbeln.
DATA : year TYPE i.

DATA : lt_final TYPE TABLE OF zofm_booking,
       ls_final TYPE          zofm_booking,
       lt_ofm   TYPE TABLE OF ty_ofm,
       ls_ofm   TYPE          ty_ofm.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS     : p_file TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) download USER-COMMAND down.
SELECTION-SCREEN END OF LINE.

***************************************************************
INITIALIZATION.
*Assign Text string To Button
  download = 'Download Excel Template'.
***************************************************************

AT SELECTION-SCREEN.
  IF sscrfields-ucomm EQ 'DOWN' .
    IF sy-subrc = 0.
      SUBMIT zofm_excel VIA SELECTION-SCREEN .
    ENDIF.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name = syst-cprog
*     dynpro_number = syst-dynnr
      field_name   = 'P_FILE'
    IMPORTING
      file_name    = p_file.


START-OF-SELECTION .

  PERFORM upload.
*&---------------------------------------------------------------------*
*&      Form  UPLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM upload .

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = lt_raw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = lt_ofm[]
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT lt_ofm INTO ls_ofm.

    SELECT SINGLE vbeln                                                        "check whether the entered sales order is present in sap
    erdat
    knumv
    vkbur
    FROM vbak
    INTO ls_vbak
    WHERE vbeln EQ ls_ofm-zsoref .

    IF sy-subrc = 0.

      ls_final-zsoref  = ls_ofm-zsoref.
      ls_final-branch  = ls_vbak-vkbur.

      SELECT knumv
      kposn
      kschl
      kwert
      FROM prcd_elements
      INTO TABLE lt_konv
      WHERE knumv = ls_vbak-knumv AND
      kschl = 'ZPR0'.

      LOOP AT lt_konv INTO ls_konv.
        sum_kwert = sum_kwert + ls_konv-kwert.
      ENDLOOP.

      ls_final-zprice = sum_kwert.                                             "Base Price from Sales Order
      CLEAR sum_kwert.
      year = ls_vbak-erdat+0(4).

      SELECT SINGLE *
      FROM zcurr_tab
      INTO ls_curr
      WHERE zyear = year AND
      zcurr = ls_ofm-zbooking_curr.

      ls_final-zcur_conv  = ls_curr-zex_rate.                                     "Currency Conversion

      ls_final-zinr_val  = ls_ofm-zbook_value * ls_curr-zex_rate.           "to get the value in home currency

      SELECT SINGLE zex_rate
      FROM zcurr_tab
      INTO usd_rate
      WHERE zyear = year AND zcurr = 'USD'.

*    IF zofm_booking-zbooking_curr = 'USD'.
*      zofm_booking-zagrr_val = zofm_booking-zbook_value.                           "value in agreed currency usd
      ls_final-zagrr_val  = ls_final-zinr_val / usd_rate.
*    ENDIF.

      ls_final-zscope            =  ls_ofm-zscope.
      ls_final-zofm_rev_no       =  ls_ofm-zofm_rev_no.
      ls_final-zrev_date         =  ls_ofm-zrev_date  .
      ls_final-zbooking_curr     =  ls_ofm-zbooking_curr.
*      ls_final-zcur_conv         =  ls_ofm-zcur_conv  .
      ls_final-zbook_value       =  ls_ofm-zbook_value.
*      ls_final-zinr_val          =  ls_ofm-zinr_val   .
*      ls_final-zagrr_val         =  ls_ofm-zagrr_val  .
*      ls_final-zprice            =  ls_ofm-zprice     .
      ls_final-zbutt             =  ls_ofm-zbutt      .
      ls_final-zball_vales       =  ls_ofm-zball_vales.
      ls_final-zoffset_val       =  ls_ofm-zoffset_val.
      ls_final-zact_cnt          =  ls_ofm-zact_cnt   .
      ls_final-zservice          =  ls_ofm-zservice   .
      ls_final-zremark           =  ls_ofm-zremark    .
      ls_final-zgross_m          =  ls_ofm-zgross_m   .
*      ls_final-branch            =  ls_ofm-branch     .

*    APPEND ls_final TO lt_final.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_final-zsoref
        IMPORTING
          output = ls_final-zsoref.
      .

*      SELECT SINGLE vbeln FROM vbak INTO wa_vbeln WHERE vbeln = ls_final-zsoref .
*      IF sy-subrc = 0.
      INSERT zofm_booking FROM ls_final.
      count = count + 1.
    ENDIF.

*    INSERT zcust_reco FROM lt_final.
    cnt = cnt + 1.

    CLEAR ls_final.
  ENDLOOP.
  gv_cnt = cnt - count.
  WRITE : / 'Successfuly records inserted ' , count , 'unsuccessful records ' , gv_cnt .


ENDFORM.
