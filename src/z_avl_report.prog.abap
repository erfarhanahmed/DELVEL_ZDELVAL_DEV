*&---------------------------------------------------------------------*
*& Report Z_AVL_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_avl_report.


TABLES : lfa1, adrc, lfm1, lfb1.
TABLES: sscrfields.
TYPE-POOLS : slis.


DATA : lv_lines  TYPE STANDARD TABLE OF tline,
       wa_lines  LIKE tline,
       wa_ofm_no LIKE tline,
       lv_name   TYPE thead-tdname,
       wa_text   TYPE char20.
DATA : v_lifnr TYPE lfa1-lifnr.


TYPES : BEGIN OF ty_lfa1,
          lifnr     TYPE lfa1-lifnr,           "Vendor code
          name1     TYPE text40,                "Name 1
          name3     TYPE name3_gp,              "09.09. addedName3
          stras     TYPE lfa1-stras,           "Street and House Number
          adrnr     TYPE lfa1-adrnr,           "Address
          loevm     TYPE lfa1-loevm,           "Central Deletion Flag for Master Record
          sperr     TYPE lfa1-sperr,           "Central posting block
          sperm     TYPE lfa1-sperm,           "Centrally imposed purchasing block
          j_1kftbus TYPE lfa1-j_1kftbus,       "Type of Business
          j_1kftind TYPE lfa1-j_1kftind,       "Type of Industry
        END OF ty_lfa1.


DATA: it_lfa1 TYPE STANDARD TABLE OF ty_lfa1,
      wa_lfa1 TYPE ty_lfa1.



TYPES : BEGIN OF ty_adrc,
          addrnumber TYPE adrc-addrnumber,            "Address number
          name1      TYPE text40,                 "Name 1
          str_suppl3 TYPE adrc-str_suppl3,            "Street 4
          tel_number TYPE adrc-tel_number,            "First telephone no
        END OF ty_adrc.

DATA: it_adrc TYPE STANDARD TABLE OF ty_adrc,
      wa_adrc TYPE ty_adrc.



TYPES: BEGIN OF ty_lfm1,
         lifnr TYPE lfm1-lifnr,                     "Vendor code
         verkf TYPE lfm1-verkf,                     "Contact
       END OF ty_lfm1.

DATA : it_lfm1 TYPE STANDARD TABLE OF ty_lfm1,
       wa_lfm1 TYPE ty_lfm1.


TYPES : BEGIN OF ty_adr6,
          addrnumber TYPE adrc-addrnumber,            "Address number
          smtp_addr  TYPE adr6-smtp_addr,              "Emai Id
        END OF ty_adr6.

DATA : it_adr6 TYPE STANDARD TABLE OF ty_adr6,
       wa_adr6 TYPE ty_adr6.

DATA : wa_fcat   TYPE  slis_fieldcat_alv,                         "Field catalog work area
       i_fcat    TYPE  slis_t_fieldcat_alv,                        "field catalog internal table
       gd_layout TYPE slis_layout_alv.                            "ALV layout settings


DATA v_repid LIKE sy-repid.

TYPES : BEGIN OF ty_final,
          status     TYPE c,
          name1      TYPE text40,
          name3      type text40,
          lifnr      TYPE lfa1-lifnr,
          stras      TYPE lfa1-stras,
          adrnr      TYPE lfa1-adrnr,
          loevm      TYPE lfa1-loevm,
          sperr      TYPE lfa1-sperr,
          sperm      TYPE lfa1-sperm,
          verkf      TYPE lfm1-verkf,
          tel_number TYPE adrc-tel_number,
          smtp_addr  TYPE adr6-smtp_addr,
          j_1kftbus  TYPE lfa1-j_1kftbus,
          j_1kftind  TYPE lfa1-j_1kftind,
          str_suppl3 TYPE adrc-str_suppl3,
          tdline     TYPE tline,
          include    TYPE tline,
          IN5 type DFKKBPTAXNUM-taxnum,
          IN6  TYPE DFKKBPTAXNUM-taxnum.




TYPES :   END OF ty_final.

DATA : it_final TYPE STANDARD TABLE OF ty_final,
       wa_final TYPE ty_final.


TYPES : BEGIN OF ty_down,
          status     TYPE c,
          name1      TYPE text40,
          lifnr      TYPE char10,       "lfa1-lifnr,
          stras      TYPE char35,       "lfa1-stras,
*          adrnr      TYPE char10,         "lfa1-adrnr,
*          loevm      TYPE char1,        "lfa1-loevm,
*          sperr      TYPE char1,        "lfa1-sperr,
*          sperm      TYPE char1,       "lfa1-sperm,
          verkf      TYPE char30,          "lfm1-verkf,
          tel_number TYPE char30,       "adrc-tel_number,
          smtp_addr  TYPE char30,       "adr6-smtp_addr,
          j_1kftind  TYPE char30,             "lfa1-j_1kftind,
*          str_suppl3 TYPE adrc-str_suppl3,
          tdline     TYPE tline,
          j_1kftbus  TYPE char30,             "lfa1-j_1kftbus,
*          include    TYPE tline,
          ref_dat    TYPE char15,                         "Refresh Date
          ref_time   TYPE char15.                         "Refresh Time

TYPES :   END OF ty_down.

DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.

data: lt_partner type TABLE of DFKKBPTAXNUM.


""""""""""""
DATA: x_events  TYPE slis_alv_event,
      it_events TYPE slis_t_event.
""""""""""

*FIELD-SYMBOLS : <fs_lfa1> like  it_final.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS: s_lifnr FOR lfa1-lifnr.

SELECT-OPTIONS : s_bukrs FOR lfb1-bukrs OBLIGATORY.

SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.




START-OF-SELECTION.

  PERFORM get_data.
  PERFORM read_data.
  PERFORM field_cat.
  PERFORM display.
*  PERFORM download.


  v_repid = sy-repid.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*  BREAK primus.

  SELECT    lifnr
            name1
            name3
            stras
            adrnr
            loevm
            sperr
            sperm
            j_1kftbus
            j_1kftind FROM lfa1 INTO CORRESPONDING FIELDS OF TABLE it_lfa1 WHERE lifnr IN s_lifnr  AND name3 = 'AVL'. " OR name4 = 'NON AVL'.

  IF it_lfa1 IS NOT INITIAL.

    SELECT addrnumber
           name1
           str_suppl3
           tel_number  FROM adrc INTO CORRESPONDING FIELDS OF TABLE it_adrc FOR ALL ENTRIES IN it_lfa1 WHERE name1 = it_lfa1-name1.

  ENDIF.

  IF it_adrc IS NOT INITIAL.

    SELECT  lifnr
            verkf  FROM lfm1 INTO CORRESPONDING FIELDS OF TABLE it_lfm1 FOR ALL ENTRIES IN it_lfa1 WHERE lifnr = it_lfa1-lifnr.

  ENDIF.

  IF it_lfm1 IS  NOT INITIAL  .

    SELECT addrnumber
           smtp_addr FROM adr6 INTO CORRESPONDING FIELDS OF TABLE it_adr6 FOR ALL ENTRIES IN it_adrc WHERE addrnumber = it_adrc-addrnumber.

  ENDIF.


  " Logic for supplier
SELECT * from DFKKBPTAXNUM INTO CORRESPONDING FIELDS OF TABLE @lt_partner FOR ALL ENTRIES IN @it_lfa1 WHERE PARTNER = @it_lfa1-lifnr.





ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_data .

*BREAK-POINT.
  LOOP AT it_lfa1 INTO wa_lfa1.


    READ TABLE it_adrc INTO wa_adrc WITH  KEY  name1 = wa_lfa1-name1.


*    READ TABLE it_lfm1 INTO wa_lfm1 WITH  KEY lifnr = wa_lfm1-lifnr.

***************************************************************************************
    READ TABLE it_lfm1 INTO wa_lfm1 WITH  KEY lifnr = wa_lfa1-lifnr.

*    BREAK-POINT.

    lv_name = wa_lfa1-lifnr.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = '0001'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      TABLES
        lines                   = lv_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc = 0.
* Implement suitable error handling here
*    wa_final-tdline = lv_lines.

*      APPEND lv_lines to it_final.
      LOOP AT lv_lines INTO DATA(ls_line).

        wa_final-tdline = ls_line-tdline.

      ENDLOOP.

    ENDIF.

***********************************************************************************************

    READ TABLE it_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_adrc-addrnumber.


    wa_final-name1       = wa_lfa1-name1.
    wa_final-name3       = wa_lfa1-name3.
    wa_final-lifnr       = wa_lfa1-lifnr.
    wa_final-stras       = wa_lfa1-stras.
*    wa_final-adrnr       = wa_lfa1-adrnr.
    wa_final-str_suppl3  = wa_adrc-str_suppl3.
    wa_final-loevm       = wa_lfa1-loevm.
    wa_final-sperr       = wa_lfa1-sperr.
    wa_final-sperm       = wa_lfa1-sperm.
    wa_final-verkf       = wa_lfm1-verkf.
    wa_final-tel_number  = wa_adrc-tel_number.
    wa_final-smtp_addr   = wa_adr6-smtp_addr.
    wa_final-j_1kftind   = wa_lfa1-j_1kftind.
    wa_final-tdline      = ls_line-tdline.
    wa_final-j_1kftbus   = wa_lfa1-j_1kftbus.
     READ TABLE lt_partner INTO data(wa_in5) WITH  KEY  partner = wa_lfa1-lifnr taxtype = 'IN5'.
    wa_final-in5 = wa_in5-taxnumxl.
      READ TABLE lt_partner INTO data(wa_in6) WITH  KEY  partner = wa_lfa1-lifnr taxtype = 'IN6'.
    wa_final-in6 = wa_in6-taxnumxl.

* IF  wa_final-status =  'H'.
*      wa_final-loevm =  'X'.
*      wa_final-sperr =  'X'.
*      wa_final-sperm =  'X'.
**
*    ELSE.
*      wa_final-status = 'C'.
*      wa_final-loevm  NE 'X'.
*      wa_final-sperr  NE 'X'.
*      wa_final-sperm  NE  'X'.
*    ENDIF.

    IF wa_final-loevm = 'X'. "  IS NOT INITIAL.    "= 'X'.
      wa_final-status = 'H'.
     ELSEIF wa_final-loevm NE 'X'.
      wa_final-status = 'C'.
    ENDIF.

    IF wa_final-sperr = 'X'.     " IS NOT INITIAL.      "'X'.
     wa_final-status = 'H'.
     ELSEIF wa_final-sperr NE 'X' .
      wa_final-status = 'C'.
    ENDIF.

    IF wa_final-sperm = 'X'. "  IS NOT INITIAL.     "= 'X'.
     wa_final-status = 'H'.
     ELSEIF wa_final-sperm NE 'X' .
     wa_final-status = 'C'.
    ENDIF.

*IF wa_final-status is NOT INITIAL.
*
*  wa_final-loevm = 'H'.
*  wa_final-sperr = 'H'.
*  wa_final-sperm = 'H'.
*
*  ELSEIF wa_final-status is INITIAL.
*
*    wa_final-loevm = 'C'.
*    wa_final-sperr = 'C'.
*    wa_final-sperm = 'C'.
*
*ENDIF.


*    IF  wa_final-loevm IS  INITIAL.
*      wa_final-status = 'H'.
*    ELSE.
*      wa_final-status = 'C'.
*    ENDIF.
*
*    IF  wa_final-sperr IS   INITIAL.
*      wa_final-status = 'H'.
*    ELSE.
*      wa_final-status = 'C'.
*    ENDIF.
*
*    IF  wa_final-sperm IS INITIAL.
*      wa_final-status = 'H'.
*    ELSE.
*      wa_final-status = 'C'.
*    ENDIF.

*BREAK-POINT.

*IF wa_final-j_1kftbus IS INITIAL.
    IF  wa_final-j_1kftbus =  'Critical'.
      wa_final-j_1kftbus = 'Y' .
    ELSE.
      wa_final-j_1kftbus = 'Non Critical'.
      wa_final-j_1kftbus = 'N'.
    ENDIF.

*    CONCATENATE  wa_final-stras wa_final-str_suppl3 INTO wa_final-adrnr.

    APPEND wa_final TO it_final.
    CLEAR wa_final.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELD_CAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM field_cat .


  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'STATUS' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Status Continued/ Added/Hold' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'NAME1' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Name of Supplier' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

   wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'NAME3' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Name 3' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'LIFNR' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Vendor Code' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '5' .
*  wa_fcat-fieldname = 'ADRNR' .
  wa_fcat-fieldname = 'STRAS' .
*   wa_fcat-fieldname = 'STR_SUPPL3' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Address' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'VERKF' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Contact Person' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'TEL_NUMBER' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Contact Number' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'SMTP_ADDR' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Email' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

*  wa_fcat-col_pos = '8' .
*  wa_fcat-fieldname = 'SCOPE OF SUPPLY ' .
*  wa_fcat-inttype = 'CHAR ' .
*  wa_fcat-seltext_l = 'Scope Of Supply' .
*  APPEND wa_fcat TO i_fcat .
*  CLEAR wa_fcat .

   wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'IN5' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Supplier Type' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

   wa_fcat-col_pos = '10' .
  wa_fcat-fieldname = 'IN6' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Supplier Header' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  wa_fcat-col_pos = '11' .
  wa_fcat-fieldname = 'J_1KFTIND ' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Scope Of Supply (Category)' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

  wa_fcat-col_pos = '12' .
  wa_fcat-fieldname = 'TDLINE ' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Scope Of Supply (Details)' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .


  wa_fcat-col_pos = '13' .
  wa_fcat-fieldname = 'J_1KFTBUS ' .
  wa_fcat-tabname = 'it_final' .
  wa_fcat-seltext_l = 'Critical Item' .
*  wa_fcat-key = 'X' .
  APPEND wa_fcat TO i_fcat .
  CLEAR wa_fcat .

ENDFORM.

FORM display.

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

ENDFORM.


FORM download .

*  wa_final-status      = 'Status Continued/ Added/Hold'.
*  wa_final-name1       = 'Name of Supplier' .               "wa_lfa1-name1.
*  wa_final-lifnr       = 'Vendor Code'.                      " wa_lfa1-lifnr.
*  wa_final-stras       = 'Address' .                       "wa_lfa1-stras.
*  wa_final-adrnr       = 'Address' .
*  wa_final-str_suppl3  = 'Address' .                      "wa_adrc-str_suppl3.                       "wa_lfa1-adrnr.
**    wa_final-loevm       = wa_lfa1-loevm.
**    wa_final-sperr       = wa_lfa1-sperr.
**    wa_final-sperm       = wa_lfa1-sperm.
*  wa_final-verkf       = 'Contact Person' .             "wa_lfm1-verkf.
*  wa_final-tel_number  = 'Contact Number' .                  "wa_adrc-tel_number.
*  wa_final-smtp_addr   = 'Email' .                 "wa_adr6-smtp_addr.
*  wa_final-j_1kftind   = 'Scope Of Supply (Category)'.      "  wa_lfa1-j_1kftind.
*  wa_final-tdline      = 'Scope Of Supply (Details)'.      "ls_line-tdline.
*  wa_final-j_1kftbus   = 'Critical Item'.
*
*  CONCATENATE  wa_final-stras wa_final-str_suppl3 INTO wa_final-adrnr.
*
*BREAK-POINT.
  LOOP AT it_final INTO wa_final.

*    MOVE-CORRESPONDING it_final TO lt_down.

*   READ TABLE it_final INTO wa_final WITH  KEY lifnr = wa_final-lifnr.

    IF sy-subrc = 0.

      ls_down-status = wa_final-status.
      ls_down-name1  = wa_final-name1.
      ls_down-lifnr  = wa_final-lifnr.
      ls_down-stras  = wa_final-stras.
*    ls_down-adrnr  = wa_final-adrnr.
*    ls_down-str_suppl3  = wa_final-str_suppl3.
      ls_down-verkf  = wa_final-verkf.
      ls_down-tel_number  = wa_final-tel_number.
      ls_down-smtp_addr  = wa_final-smtp_addr.
      ls_down-j_1kftind  = wa_final-j_1kftind.
      ls_down-tdline  = wa_final-tdline.
      ls_down-j_1kftbus  = wa_final-j_1kftbus.
*    ls_down-ref_dat  = wa_final-ref_dat.
*    ls_down- ref_time = wa_final-ref_time.


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
      CLEAR: ls_down.     "wa_final.

* lt_down[] = it_final[].
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
  lv_file = 'Z_AVL_REPORT.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'Z_AVL_REPORT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_619 TYPE string.
DATA lv_crlf_619 TYPE string.
lv_crlf_619 = cl_abap_char_utilities=>cr_lf.
lv_string_619 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_619 lv_crlf_619 wa_csv INTO lv_string_619.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_619 TO lv_fullfile.
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

  CONCATENATE  'Status Continued/ Added/Hold'
               'Name of Supplier'
               'Vendor Code'
               'Address'
               'Contact Person'
               'Contact Number'
               'Email'
               'Scope Of Supply (Category)'
               'Scope Of Supply (Details)'
               'Critical Item'
               'Refresh date'
               'Refresh time'
          INTO p_hd_csv
  SEPARATED BY l_field_seperator.


ENDFORM.
