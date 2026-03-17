*&---------------------------------------------------------------------*
*& Report ZTARGET_PROG
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztarget_prog.
TABLES : ztarget.

DATA : lt_target TYPE TABLE OF ztarget,
       ls_target TYPE ztarget,
       ls_target2 TYPE ztarget.

DATA : lt_ofm TYPE TABLE OF zofm_booking,
       ls_ofm TYPE zofm_booking.

TYPES : BEGIN OF ty_final,
          branch   TYPE ztarget-branch,
          B_HEAD  TYPE  ZTARGET-B_HEAD,
          zmonth   TYPE ztarget-zmonth,
          zyear    TYPE ztarget-zyear,
          ztarget  TYPE ztarget-ztarget,
          achieved TYPE ztarget-ztarget,
        END OF ty_final,

        BEGIN OF ty_final1,
          field1(15),
          field30(15),
          field2(15),
          field3(15),
          field4(15),
          field5(15),
          field6(15),
          field7(15),
          field8(15),
          field9(15),
          field10(15),
          field11(15),
          field12(15),
          field13(15),
          field14(15),
          field15(15),
          field16(15),
          field17(15),
          field18(15),
          field19(15),
          field20(15),
          field21(15),
          field22(15),
          field23(15),
          field24(15),
          field25(15),
          field26(15),
          field27(15),
          field28(15),
          field29(15),
          ref_dat  TYPE char15,  "Refresh Date
          ref_time TYPE char15,  "Refresh Time

          END OF ty_final1.

TYPES : BEGIN OF ty_down,
          branch   TYPE ztarget-branch,
          zmonth   TYPE ztarget-zmonth,
          zyear    TYPE ztarget-zyear,
          ztarget  TYPE ztarget-ztarget,
          achieved TYPE ztarget-ztarget,
          ref_dat  TYPE char15,  "Refresh Date
          ref_time TYPE char15,  "Refresh Time
        END OF ty_down.

DATA : lt_final TYPE TABLE OF ty_final,
       ls_final TYPE          ty_final,
       lt_final1 TYPE TABLE OF ty_final1,
       ls_final1 TYPE          ty_final1,
       lt_down1 TYPE TABLE OF ty_final1,
       ls_down1 TYPE          ty_final1,
       ls_new TYPE          ty_final1,


       LT_DOWN TYPE TABLE OF TY_DOWN,
       LS_DOWN TYPE          TY_DOWN.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.

DATA : gv_day  TYPE char2,
       gv_day1 TYPE char2.

DATA: s_date   TYPE TABLE OF rsdsselopt,
      w_date   TYPE rsdsselopt,
      gv_date  TYPE datum,
      gv_date1 TYPE datum.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_bran  FOR ztarget-branch,
                 s_month FOR ztarget-zmonth,
                 s_year  FOR ztarget-zyear.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\temp'.
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


  SELECT * FROM ztarget INTO TABLE lt_target
  WHERE branch IN s_bran AND zmonth IN s_month AND zyear IN s_year.

  IF lt_target IS NOT INITIAL.
    PERFORM sort_data.
    PERFORM get_fcat.
*  PERFORM download.
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

          LS_FINAL1-field1 = 'BRANCH'.
          LS_FINAL1-field30 = 'BRANCH HEAD'.
           LS_FINAL1-field2 = 'YEAR'.
           LS_FINAL1-field3 = 'TARGET'.
           LS_FINAL1-field4 = 'ACHIEVED'.
           LS_FINAL1-field5 = 'TARGET'.
           LS_FINAL1-field6 = 'ACHIEVED'.
           LS_FINAL1-field7 = 'TARGET'.
           LS_FINAL1-field8 = 'ACHIEVED'.
           LS_FINAL1-field9 = 'TARGET'.
           LS_FINAL1-field10 = 'ACHIEVED'.
           LS_FINAL1-field11 = 'TARGET'.
           LS_FINAL1-field12 = 'ACHIEVED'.
           LS_FINAL1-field13 = 'TARGET'.
           LS_FINAL1-field14 = 'ACHIEVED'.
           LS_FINAL1-field15 = 'TARGET'.
           LS_FINAL1-field16 = 'ACHIEVED'.
           LS_FINAL1-field17 = 'TARGET'.
           LS_FINAL1-field18 = 'ACHIEVED'.
           LS_FINAL1-field19 = 'TARGET'.
           LS_FINAL1-field20 = 'ACHIEVED'.
           LS_FINAL1-field21 = 'TARGET'.
           LS_FINAL1-field22 = 'ACHIEVED'.
           LS_FINAL1-field23 = 'TARGET'.
           LS_FINAL1-field24 = 'ACHIEVED'.
           LS_FINAL1-field25 = 'TARGET'.
           LS_FINAL1-field26 = 'ACHIEVED'.
           LS_FINAL1-field27 = 'FINAL TARGET'.
           LS_FINAL1-field28 = 'FINAL ACHIEVED'.
           LS_FINAL1-field29 = 'PERCENTAGE(%)'.


  APPEND LS_FINAL1 TO LT_FINAL1.
  CLEAR LS_FINAL1.

*BREAK primus.

  LOOP AT lt_target INTO ls_target.


    ls_final-branch  = ls_target-branch.
    ls_final-b_head  = ls_target-b_head.
    ls_final-zmonth  = ls_target-zmonth.
    ls_final-zyear   = ls_target-zyear.
    ls_final-ztarget = ls_target-ztarget.

    IF ls_final-zmonth = 'JAN'.
      ls_final-zmonth = '01'.
    ELSEIF ls_final-zmonth = 'FEB'.
      ls_final-zmonth = '02'.
    ELSEIF ls_final-zmonth = 'MAR'.
      ls_final-zmonth = '03'.
    ELSEIF ls_final-zmonth = 'APR'.
      ls_final-zmonth = '04'.
    ELSEIF ls_final-zmonth = 'MAY'.
      ls_final-zmonth = '05'.
    ELSEIF ls_final-zmonth = 'JUN'.
      ls_final-zmonth = '06'.
    ELSEIF ls_final-zmonth = 'JUL'.
      ls_final-zmonth = '07'.
    ELSEIF ls_final-zmonth = 'AUG'.
      ls_final-zmonth = '08'.
    ELSEIF ls_final-zmonth = 'SEP'.
      ls_final-zmonth = '09'.
    ELSEIF ls_final-zmonth = 'OCT'.
      ls_final-zmonth = '10'.
    ELSEIF ls_final-zmonth = 'NOV'.
      ls_final-zmonth = '11'.
    ELSEIF ls_final-zmonth = 'DEC'.
      ls_final-zmonth = '12'.
    ENDIF.

    gv_day = '01'.
    gv_day1 = '31'.
    CONCATENATE ls_target-zyear ls_final-zmonth gv_day  INTO gv_date.
    CONCATENATE ls_target-zyear ls_final-zmonth gv_day1 INTO gv_date1.

  ls_final-zmonth  = ls_target-zmonth.

    SELECT * FROM zofm_booking INTO TABLE lt_ofm
    WHERE branch = ls_target-branch AND
          zrev_date GE gv_date AND
          zrev_date LE gv_date1 .

    LOOP AT lt_ofm INTO ls_ofm.

      ls_final-achieved = ls_final-achieved +  ls_ofm-zbook_value.

*      CLEAR ls_ofm.

    ENDLOOP.


    APPEND ls_final TO lt_final.


    LS_FINAL1-FIELD1 = ls_target-branch.
    LS_FINAL1-FIELD30 = ls_target-b_head.
    LS_FINAL1-FIELD2 = ls_target-ZYEAR.

    IF ls_final-zmonth = 'JAN'.
      LS_FINAL1-FIELD3 = ls_final-ztarget.
      LS_FINAL1-FIELD4 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'FEB'.
      LS_FINAL1-FIELD5 = ls_final-ztarget.
      LS_FINAL1-FIELD6 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'MAR'.
      LS_FINAL1-FIELD7 = ls_final-ztarget.
      LS_FINAL1-FIELD8 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'APR'.
      LS_FINAL1-FIELD9 = ls_final-ztarget.
      LS_FINAL1-FIELD10 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'MAY'.
      LS_FINAL1-FIELD11 = ls_final-ztarget.
      LS_FINAL1-FIELD12 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'JUN'.
     LS_FINAL1-FIELD13 = ls_final-ztarget.
      LS_FINAL1-FIELD14 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'JUL'.
      LS_FINAL1-FIELD15 = ls_final-ztarget.
      LS_FINAL1-FIELD16 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'AUG'.
      LS_FINAL1-FIELD17 = ls_final-ztarget.
      LS_FINAL1-FIELD18 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'SEP'.
      LS_FINAL1-FIELD19 = ls_final-ztarget.
      LS_FINAL1-FIELD20 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'OCT'.
      LS_FINAL1-FIELD21 = ls_final-ztarget.
      LS_FINAL1-FIELD22 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'NOV'.
      LS_FINAL1-FIELD23 = ls_final-ztarget.
      LS_FINAL1-FIELD24 = ls_final-ACHIEVED.
    ELSEIF ls_final-zmonth = 'DEC'.
      LS_FINAL1-FIELD25 = ls_final-ztarget.
      LS_FINAL1-FIELD26 = ls_final-ACHIEVED.
    ENDIF.


CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = LS_FINAL1-ref_dat.

      CONCATENATE LS_FINAL1-ref_dat+0(2) LS_FINAL1-ref_dat+2(3) LS_FINAL1-ref_dat+5(4)
                      INTO LS_FINAL1-ref_dat SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO LS_FINAL1-ref_time SEPARATED BY ':'.



  READ TABLE lt_final1 INTO ls_new WITH KEY field1 = ls_final-branch
                                                field2 = ls_final-zyear.

  IF sy-subrc <> 0.


*LS_FINAL1-FIELD27 = LS_FINAL1-FIELD27 +  ls_final-ztarget.
*LS_FINAL1-FIELD28 = LS_FINAL1-FIELD28 +  ls_final-ACHIEVED.


    APPEND ls_final1 TO lt_final1.

    ELSe.

      MODIFY lt_final1 FROM ls_final1 TRANSPORTING field1
                                                   field2
                                                   field3
                                                   field4
                                                   field5
                                                   field6
                                                   field7
                                                   field8
                                                   field9
                                                   field10
                                                   field11
                                                   field12
                                                   field13
                                                   field14
                                                   field15
                                                   field16
                                                   field17
                                                   field18
                                                   field19
                                                   field20
                                                   field21
                                                   field22
                                                   field23
                                                   field24
                                                   field25
                                                   field26
                                                   field30


                                          WHERE field1 = ls_final-branch
                                    AND            field2 = ls_final-zyear .

  ENDIF.

    CLEAR : ls_final,ls_ofm,ls_target.
  ENDLOOP.
    CLEAR: LS_FINAL1-FIELD9. " MODIFIED BY PJ.
*BREAK PRIMUS.
LOOP AT lt_final1 INTO ls_final1 .
  IF sy-tabix <> 1.

ls_final1-field27 = LS_FINAL1-FIELD3 + LS_FINAL1-FIELD5 + LS_FINAL1-FIELD7 + LS_FINAL1-FIELD9 + LS_FINAL1-FIELD11 + LS_FINAL1-FIELD13 + LS_FINAL1-FIELD15
                    + LS_FINAL1-FIELD17 + LS_FINAL1-FIELD19 + LS_FINAL1-FIELD21 + LS_FINAL1-FIELD23 + LS_FINAL1-FIELD25 .

ls_final1-field28 = LS_FINAL1-FIELD4 + LS_FINAL1-FIELD6 + LS_FINAL1-FIELD8 + LS_FINAL1-FIELD10 + LS_FINAL1-FIELD12 + LS_FINAL1-FIELD14
                    + LS_FINAL1-FIELD16 + LS_FINAL1-FIELD18 + LS_FINAL1-FIELD20 + LS_FINAL1-FIELD22 + LS_FINAL1-FIELD24 + LS_FINAL1-FIELD26.
ls_final1-field29 = ( ls_final1-field28 / ls_final1-field27 ) * 100.

modify lt_final1 FROM ls_final1 TRANSPORTING field27 field28 field29.

**CLEAR ls_final1.
ENDIF.
ENDLOOP.



ENDFORM.

FORM get_fcat .

  PERFORM fcat USING : '1'    'FIELD1'      'LT_FINAL1'  ''     '18' .
  PERFORM fcat USING : '1'    'FIELD30'      'LT_FINAL1'  ''     '18' .
  PERFORM fcat USING : '2'    'FIELD2'       'LT_FINAL1'  ''       '18' .
  PERFORM fcat USING : '3'    'FIELD3'      'LT_FINAL1'  ' '      '18' .
  PERFORM fcat USING : '4'    'FIELD4'     'LT_FINAL1'  'JAN'     '18' .
  PERFORM fcat USING : '5'    'FIELD5'    'LT_FINAL1'  ' '   '18' .
  PERFORM fcat USING : '6'    'FIELD6'    'LT_FINAL1'  'FEB'   '18' .
  PERFORM fcat USING : '7'    'FIELD7'    'LT_FINAL1'  ''   '18' .
  PERFORM fcat USING : '8'    'FIELD8'    'LT_FINAL1'  'MAR'   '18' .
  PERFORM fcat USING : '9'    'FIELD9'    'LT_FINAL1'  ''   '18' .
  PERFORM fcat USING : '10'    'FIELD10'    'LT_FINAL1'  'APR'   '18' .
  PERFORM fcat USING : '11'    'FIELD11'    'LT_FINAL1'  ''   '18' .
  PERFORM fcat USING : '12'    'FIELD12'    'LT_FINAL1'  'MAY'   '18' .
  PERFORM fcat USING : '13'    'FIELD13'    'LT_FINAL1'  ''   '18' .
  PERFORM fcat USING : '14'    'FIELD14'    'LT_FINAL1'  'JUN'   '18' .
  PERFORM fcat USING : '15'    'FIELD15'    'LT_FINAL1'  ' '   '18' .
  PERFORM fcat USING : '16'    'FIELD16'    'LT_FINAL1'  'JUL'   '18' .
  PERFORM fcat USING : '17'    'FIELD17'    'LT_FINAL1'  ' '   '18' .
  PERFORM fcat USING : '18'    'FIELD18'    'LT_FINAL1'  'AUG'   '18' .
  PERFORM fcat USING : '19'    'FIELD19'    'LT_FINAL1'  ' '   '18' .
  PERFORM fcat USING : '20'    'FIELD20'    'LT_FINAL1'  'SEP'   '18' .
  PERFORM fcat USING : '21'    'FIELD21'    'LT_FINAL1'  ' '   '18' .
  PERFORM fcat USING : '22'    'FIELD22'    'LT_FINAL1'  'OCT'   '18' .
  PERFORM fcat USING : '23'    'FIELD23'    'LT_FINAL1'  ' '   '18' .
  PERFORM fcat USING : '24'    'FIELD24'    'LT_FINAL1'  'NOV'   '18' .
  PERFORM fcat USING : '25'    'FIELD25'    'LT_FINAL1'  ' '   '18' .
  PERFORM fcat USING : '26'    'FIELD26'    'LT_FINAL1'  'DEC'   '18' .
  PERFORM fcat USING : '27'    'FIELD27'    'LT_FINAL1'  ' '   '18' .
  PERFORM fcat USING : '28'    'FIELD28'    'LT_FINAL1'  ''   '18' .
  PERFORM fcat USING : '29'    'FIELD29'    'LT_FINAL1'  ''   '18' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1097   text
*      -->P_1098   text
*      -->P_1099   text
*      -->P_1100   text
*      -->P_1101   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
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


  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X' .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = ls_layout
      it_fieldcat        = it_fcat[]
    TABLES
      t_outtab           = lt_final1[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
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



*LS_FINAL1-field4 = 'JAN'.
**           LS_FINAL1-field5 = 'TARGET'.
*           LS_FINAL1-field6 = 'FEB'.
**           LS_FINAL1-field7 = 'TARGET'.
*           LS_FINAL1-field8 = 'MARCH'.
**           LS_FINAL1-field9 = 'TARGET'.
*           LS_FINAL1-field10 = 'APR'.
**           LS_FINAL1-field11 = 'TARGET'.
*           LS_FINAL1-field12 = 'MAY'.
**           LS_FINAL1-field13 = 'TARGET'.
*           LS_FINAL1-field14 = 'JUN'.
**           LS_FINAL1-field15 = 'TARGET'.
*           LS_FINAL1-field16 = 'JULY'.
**           LS_FINAL1-field17 = 'TARGET'.
*           LS_FINAL1-field18 = 'AUG'.
**           LS_FINAL1-field19 = 'TARGET'.
*           LS_FINAL1-field20 = 'SEP'.
**           LS_FINAL1-field21 = 'TARGET'.
*           LS_FINAL1-field22 = 'OCT'.
**           LS_FINAL1-field23 = 'TARGET'.
*           LS_FINAL1-field24 = 'NOV'.
**           LS_FINAL1-field25 = 'TARGET'.
*           LS_FINAL1-field26 = 'DEC'.
*
*
*  APPEND LS_FINAL1 TO LT_down1.
*  CLEAR ls_down1.


*          LS_FINAL1-field1 = 'BRANCH'.
*           LS_FINAL1-field2 = 'Year'.
           LS_FINAL1-field3 = 'TARGET'.
           LS_FINAL1-field4 = 'ACHIEVED'.
           LS_FINAL1-field5 = 'TARGET'.
           LS_FINAL1-field6 = 'ACHIEVED'.
           LS_FINAL1-field7 = 'TARGET'.
           LS_FINAL1-field8 = 'ACHIEVED'.
           LS_FINAL1-field9 = 'TARGET'.
           LS_FINAL1-field10 = 'ACHIEVED'.
           LS_FINAL1-field11 = 'TARGET'.
           LS_FINAL1-field12 = 'ACHIEVED'.
           LS_FINAL1-field13 = 'TARGET'.
           LS_FINAL1-field14 = 'ACHIEVED'.
           LS_FINAL1-field15 = 'TARGET'.
           LS_FINAL1-field16 = 'ACHIEVED'.
           LS_FINAL1-field17 = 'TARGET'.
           LS_FINAL1-field18 = 'ACHIEVED'.
           LS_FINAL1-field19 = 'TARGET'.
           LS_FINAL1-field20 = 'ACHIEVED'.
           LS_FINAL1-field21 = 'TARGET'.
           LS_FINAL1-field22 = 'ACHIEVED'.
           LS_FINAL1-field23 = 'TARGET'.
           LS_FINAL1-field24 = 'ACHIEVED'.
           LS_FINAL1-field25 = 'TARGET'.
           LS_FINAL1-field26 = 'ACHIEVED'.
           LS_FINAL1-field27 = 'FINAL TARGET'.
           LS_FINAL1-field28 = 'FINAL ACHIEVED'.
           LS_FINAL1-field29 = 'PERCENTAGE(%)'.


  APPEND LS_FINAL1 TO LT_down1.
  CLEAR ls_down1.

lt_down1[] = lt_final1[].

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
      i_tab_sap_data       = lt_down1
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

  CONCATENATE p_folder '\' lv_file
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZOFM_BOOKING_REPORT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
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

  CONCATENATE ' '
              ' '
              ' '
              ' '
              'JAN'
              ' '
              'FEB'
              ' '
              'MAR '
              '  '
              'APR'
              ' '
              'MAY '
              ' '
              'JUN '
              ' '
              'JULY '
              ' '
              'AUG '
              ' '
              'SEP'
              ' '
              'OCT'
              ' '
              'NOV'
              ' '
              'DEC'
              ' '
              ' '
              ' '
              'Refresh date'
              'Refresh time'
    INTO p_hd_csv
    SEPARATED BY l_field_seperator.


ENDFORM.
