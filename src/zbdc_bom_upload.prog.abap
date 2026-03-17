
REPORT zbom_prog
       NO STANDARD PAGE HEADING LINE-SIZE 255.

DATA: bdcdata LIKE bdcdata    OCCURS 0 WITH HEADER LINE.
DATA : lt_msgtab TYPE STANDARD TABLE OF bdcmsgcoll,
       wa_msgtab TYPE bdcmsgcoll.
DATA:   lv_mestext TYPE char100.
DATA: BEGIN OF itab OCCURS 0,
        matnr(018) TYPE c,           "EQUIPMENT NUMBER
        stlan(001) TYPE c,           "BOM USAGE
        idnrk(036) TYPE c,           "COMPONENT
        postp(001) TYPE c,
        menge(013) TYPE c,           "QUANTITY
        lgort(004) TYPE c,
      END OF itab .

DATA: BEGIN OF itab1 OCCURS 0,
        matnr(018) TYPE c,           "EQUIPMENT NUMBER
        stlan(001) TYPE c,           "BOM USAGE
        idnrk(036) TYPE c,           "COMPONENT
        postp(001) TYPE c,
        menge(013) TYPE c,           "QUANTITY
        lgort(004) TYPE c,
      END OF itab1  .

DATA: BEGIN OF itab2 OCCURS 0,
        matnr(018) TYPE c,           "EQUIPMENT NUMBER
        stlan(001) TYPE c,           "BOM USAGE
        idnrk(036) TYPE c,           "COMPONENT
        postp(001) TYPE c,
        menge(013) TYPE c,           "QUANTITY
        lgort(004) TYPE c,
      END OF itab2.


DATA : BEGIN OF itab3 OCCURS 0,
         matnr(018) TYPE c,           "EQUIPMENT NUMBER
         stlan(001) TYPE c,           "BOM USAGE
         idnrk(036) TYPE c,           "COMPONENT
         postp(001) TYPE c,
         menge(013) TYPE c,           "QUANTITY
         lgort(004) TYPE c,
       END OF itab3.

DATA : v_count2 TYPE i.
DATA : v_posnr TYPE i.

DATA : v_page TYPE i.
DATA : it_excel TYPE TABLE OF alsmex_tabline.
DATA : wa_excel TYPE alsmex_tabline.

v_page = 0.

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text_001.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) text_1_1.
PARAMETERS: p_file LIKE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b1.
PARAMETERS ctumode TYPE ctu_params-dismode DEFAULT 'N'.

*----------------------------------------------------------------------*
* Initialization Event
*----------------------------------------------------------------------*
INITIALIZATION.
  text_001 = 'File path selection'.
  text_1_1 = 'File Path'.

*----------------------------------------------------------------------*
* At Selection Screen Event
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = p_file.

*&---------------------------------------------------------------------*
*& Start of Selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM data_upload.
  PERFORM manipulate_data.
  IF itab[] IS NOT INITIAL.
    PERFORM open_group.

    REFRESH bdcdata.
    PERFORM bdcdata.

    PERFORM close_group.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  DATA_UPLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_upload.

  DATA: loc_filename TYPE localfile.

  loc_filename = p_file.

* Make to usable content
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = loc_filename
      i_begin_col             = '1'
      i_begin_row             = '2'
      i_end_col               = '34'
      i_end_row               = '9999'
    TABLES
      intern                  = it_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT it_excel INTO wa_excel.

    CASE wa_excel-col.

      WHEN '0001'. itab-matnr = wa_excel-value.
      WHEN '0002'. itab-stlan = wa_excel-value.
      WHEN '0003'. itab-idnrk = wa_excel-value.
      WHEN '0004'. itab-postp = wa_excel-value.
      WHEN '0005'. itab-menge = wa_excel-value.
      WHEN '0006'. itab-lgort = wa_excel-value.

    ENDCASE.
    AT END OF row.
      APPEND itab.
    ENDAT.
  ENDLOOP.
ENDFORM.                    " DATA_UPLOAD

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
ENDFORM.                    "BDC_FIELD

*&---------------------------------------------------------------------*
*&      Form  OPEN_GROUP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM open_group .

  CALL FUNCTION 'BDC_OPEN_GROUP'
    EXPORTING
      client = sy-mandt
      group  = 'GROUP_NAME'
      user   = sy-uname
      keep   = 'X'.

ENDFORM.                    " OPEN_GROUP

*&---------------------------------------------------------------------*
*&      Form  CLOSE_GROUP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM close_group .
  CALL FUNCTION 'BDC_CLOSE_GROUP'.
*  CALL TRANSACTION 'SM35'.
ENDFORM.                    " CLOSE_GROUP

*&---------------------------------------------------------------------*
*&      Form  bdcdata
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bdcdata .

  DATA : v_count1 TYPE i VALUE 0.
  DATA: v_field1 TYPE string,
        v_field2 TYPE string,
        v_field3 TYPE string,
        v_field4 TYPE string,
        v_field5 TYPE string.

  DATA : v_temp(2) TYPE c.
  DATA : v_temp1 TYPE c.
  DATA : flag TYPE i VALUE 0.

  DATA: lv_date(10) TYPE c.
  DATA : lv_day(2)    TYPE c,
         lv_day1(3)   TYPE c,
         lv_month(2)  TYPE c,
         lv_month1(3) TYPE c,
         lv_date1(6)  TYPE c,
         lv_year(4)   TYPE c,
         lv_matnr     TYPE mara-matnr.

*  lv_year = sy-datum+0(4).
*  lv_month = sy-datum+4(2).
*  lv_day = sy-datum+6(2).
*
*  CONCATENATE lv_day '.' INTO  lv_day1.
*  CONCATENATE lv_month '.' INTO lv_month1.
*  CONCATENATE lv_day1 lv_month1 INTO lv_date1.
*  CONCATENATE lv_date1 lv_year INTO lv_date.
  lv_date = '01.04.2017'.

  v_count1 = 0.

  LOOP AT itab1.
    PERFORM bdc_dynpro      USING 'SAPLCSDI' '0100'.
    PERFORM bdc_field       USING 'BDC_OKCODE'   '/00'.
    PERFORM bdc_field       USING 'RC29N-MATNR'  itab1-matnr.
    PERFORM bdc_field       USING 'RC29N-WERKS'  'PL01'.
    PERFORM bdc_field       USING 'RC29N-STLAN'   itab1-stlan.

    IF itab1-stlan = '2'.
      PERFORM bdc_field       USING 'RC29N-STLAL' '01'.
    ENDIF.

    IF itab1-stlan = '1'.
      PERFORM bdc_field       USING 'RC29N-STLAL'  '01'.
    ENDIF.

    PERFORM bdc_field       USING 'RC29N-DATUV'   lv_date .
    PERFORM bdc_dynpro      USING 'SAPLCSDI' '0110'.
    PERFORM bdc_field       USING 'BDC_CURSOR'   'RC29K-ZTEXT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'   '/00'.
    PERFORM bdc_field       USING 'RC29K-STLST'  '1'.

    PERFORM bdc_dynpro      USING 'SAPLCSDI' '0111'.
    PERFORM bdc_field       USING 'BDC_OKCODE'   '/00'.

    CLEAR v_count1.
    v_count1 = 0.
    LOOP AT itab2 WHERE  matnr = itab1-matnr AND
                         "werks = itab1-werks AND
                         stlan = itab1-stlan." AND
      "Datuv = itab1-datuv .
*                     menge = itab1-menge and
*                      meins = itab1-meins .
      IF flag = 1.
        v_count1 = v_count1 + 2.
      ELSE.
        v_count1 = v_count1 + 1.
      ENDIF.

      flag = 0.

      MOVE v_count1 TO v_temp.
*CONCATENATE 'RC29P-AUSKZ(' v_temp ')' INTO v_field1.
      CONCATENATE 'RC29P-idnrk(' v_temp ')' INTO v_field2.
      CONCATENATE 'RC29P-menge(' v_temp ')' INTO v_field3.
      CONCATENATE 'RC29P-POSTP(' v_temp ')' INTO v_field4.
*CONCATENATE 'RC29P-meins(' v_temp ')' INTO v_field4.               "asim

      PERFORM bdc_dynpro      USING 'SAPLCSDI' '0140'.
      PERFORM bdc_field       USING 'BDC_CURSOR'  'RC29P-AUSKZ(01)'.
      PERFORM bdc_field       USING 'BDC_OKCODE'  '/00'.
*  perform bdc_field       using 'BDC_OKCODE'  '=WIZU'.
*  perform bdc_field       using v_field1   'X'.
      PERFORM bdc_field       USING v_field2   itab2-idnrk.   "'2780603001'.
      PERFORM bdc_field       USING v_field3   itab2-menge.
      PERFORM bdc_field       USING v_field4   itab2-postp .

      PERFORM bdc_dynpro      USING 'SAPLCSDI' '0130'.
      PERFORM bdc_field       USING 'BDC_OKCODE'   '/00'.
      PERFORM bdc_field       USING 'BDC_CURSOR'   'RC29P-POSNR'.
      PERFORM bdc_field       USING 'RC29P-IDNRK'   itab2-idnrk .
      PERFORM bdc_field       USING 'RC29P-MENGE'   itab2-menge .
*  perform bdc_field       using 'RC29P-MEINS'               "asim   "changed
**                                'NO'.
*                              itab2-meins .

      PERFORM bdc_dynpro      USING 'SAPLCSDI' '0131'.
      PERFORM bdc_field       USING 'BDC_OKCODE'   '/00'.
      PERFORM bdc_field       USING 'BDC_CURSOR'   'RC29P-POTX1'.
      PERFORM bdc_field       USING 'RC29P-SANKA'  'X'.
      IF itab2-stlan = '1'.
        PERFORM bdc_field       USING 'RC29P-LGORT'   itab2-lgort.
      ENDIF.

      IF v_count1 > 13 .           "8
        v_page = v_count1 MOD 14.           "9
        IF v_page = 0.
          PERFORM bdc_dynpro      USING 'SAPLCSDI' '0140'.          " asim 24.12.2008
          PERFORM bdc_field       USING 'BDC_CURSOR'  'RC29P-POSNR(01)'.
          PERFORM bdc_field       USING 'BDC_OKCODE'  '=FCNP'.
          flag = 1.
          v_count1 = 0.
        ENDIF.

      ENDIF.
    ENDLOOP.

    PERFORM bdc_dynpro      USING 'SAPLCSDI' '0140'.
    PERFORM bdc_field       USING 'BDC_CURSOR'   'RC29P-POSNR(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'   '=FCBU'.

    CALL TRANSACTION 'CS01' USING bdcdata
              MODE ctumode
              UPDATE 'A'
              MESSAGES INTO lt_msgtab.
    WRITE : /5 'Type',  10 'Description'.
    WRITE : /.
    LOOP AT lt_msgtab INTO wa_msgtab.
      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          id        = wa_msgtab-msgid
          lang      = sy-langu
          no        = wa_msgtab-msgnr
          v1        = wa_msgtab-msgv1
          v2        = wa_msgtab-msgv2
          v3        = wa_msgtab-msgv3
          v4        = wa_msgtab-msgv4
        IMPORTING
          msg       = lv_mestext
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc EQ 0.
        WRITE : /5 wa_msgtab-msgtyp, 10 lv_mestext.
      ENDIF.
    ENDLOOP.

    CLEAR bdcdata.
    REFRESH bdcdata.
  ENDLOOP.

ENDFORM.                    " bdcdata

*&---------------------------------------------------------------------*
*&      Form  MANIPULATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM manipulate_data .
  LOOP AT itab.
    MOVE-CORRESPONDING itab TO itab1.
    APPEND itab1.
    MOVE-CORRESPONDING itab TO itab2.
    APPEND itab2.
    MOVE-CORRESPONDING itab TO itab3.
    APPEND itab3.
    CLEAR: itab1, itab , itab2 .

  ENDLOOP.
  DELETE ADJACENT DUPLICATES FROM itab1 COMPARING matnr stlan .
  DELETE ADJACENT DUPLICATES FROM itab2 COMPARING matnr stlan idnrk menge.  "meins." asim


ENDFORM.                    " MANIPULATE_DATA
