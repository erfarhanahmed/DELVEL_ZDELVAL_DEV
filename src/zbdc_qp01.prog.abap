report ZBDC_QP01
       no standard page heading line-size 255.
TYPE-POOLS: truxs.
TYPES: BEGIN OF ty_itab,
         MATNR(018) TYPE c,
         werks(004) TYPE c,
         verwe(001) TYPE c,
         statu(001) TYPE c,
         vornr(004) TYPE c,
         steus(004) TYPE c,
         ltxa1(040) TYPE c,

       END OF ty_itab.

****include bdcrecx1.

DATA : it_itab TYPE STANDARD TABLE OF ty_itab.
DATA : it_itab1 TYPE STANDARD TABLE OF ty_itab.
DATA : wa_itab LIKE LINE OF it_itab.
DATA : wa_itab1 LIKE LINE OF it_itab.
DATA : wa_itabt LIKE LINE OF it_itab.
DATA : bdcdata LIKE bdcdata OCCURS 0 WITH HEADER LINE.
DATA : lt_msgtab TYPE STANDARD TABLE OF bdcmsgcoll,
       wa_msgtab TYPE bdcmsgcoll.
DATA:   lv_mestext TYPE char100.
DATA : filename TYPE string.
DATA : lv_fname TYPE localfile.
DATA : it_excel TYPE TABLE OF alsmex_tabline.
DATA : wa_excel TYPE alsmex_tabline.

DATA : lin_count(002), in_count(003).
DATA : x1(015),x2(015),x3(015),x4(015).


DATA:cupdate LIKE ctu_params-updmode VALUE 'S'.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: p_file   TYPE localfile OBLIGATORY.
PARAMETERS group(12).
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.


START-OF-SELECTION.

  PERFORM upload_file.
  PERFORM bdc_executation.

END-OF-SELECTION.


*&---------------------------------------------------------------------*
*&      Form  UPLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM upload_file .

  lv_fname = p_file.

* Make to usable content
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = lv_fname
      i_begin_col             = '1'
      i_begin_row             = '2'
      i_end_col               = '8'
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

  DATA : lv_count(006) TYPE c.
  CLEAR lv_count.
  LOOP AT it_excel INTO wa_excel.

    CASE wa_excel-col.

      WHEN '0001'. wa_itab-matnr = wa_excel-value.
      WHEN '0002'. wa_itab-werks = wa_excel-value.
      WHEN '0003'. wa_itab-verwe = wa_excel-value.
      WHEN '0004'. wa_itab-statu = wa_excel-value.
      WHEN '0005'. wa_itab-vornr = wa_excel-value.
      WHEN '0006'. wa_itab-steus = wa_excel-value.
      WHEN '0007'. wa_itab-ltxa1 = wa_excel-value.

    ENDCASE.
    AT END OF row.
      APPEND wa_itab TO it_itab.
    ENDAT.
  ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_EXECUTATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bdc_executation .

PERFORM open_group.

loop at it_itab INTO wa_itab.

 on change of wa_itab-matnr.

   lin_count = 1.

perform bdc_dynpro      using 'SAPLCPDI' '8010'.
perform bdc_field       using 'BDC_CURSOR'
                              'RC27M-WERKS'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'RC27M-MATNR'
                              wa_itab-matnr.
perform bdc_field       using 'RC27M-WERKS'
                              wa_itab-werks.

perform bdc_dynpro      using 'SAPLCPDI' '1200'.
perform bdc_field       using 'BDC_CURSOR'
                              'RC27X-ENTRY_ACT'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ANLG'.
****perform bdc_field       using 'RC27X-ENTRY_ACT'
****                              '1'.


perform bdc_dynpro      using 'SAPLCPDA' '1200'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.

perform bdc_field       using 'BDC_CURSOR'
                              'PLKOD-STATU'.
perform bdc_field       using 'PLKOD-VERWE'
                              wa_itab-verwe.
perform bdc_field       using 'PLKOD-STATU'
                              wa_itab-statu.

perform bdc_dynpro      using 'SAPLCPDA' '1200'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VOUE'.

endon.

if lin_count < 18.

PERFORM concat.

perform bdc_dynpro      using 'SAPLCPDI' '1400'.
perform bdc_field       using 'BDC_CURSOR'
                              'PLPOD-LTXA1(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using x1
                              wa_itab-steus.
perform bdc_field       using x2
                              wa_itab-ltxa1.

ENDIF.

IF lin_count = 18 or lin_count = 35 or lin_count = 52 or lin_count = 69 or lin_count = 86 or lin_count = 103 or lin_count = 120 or lin_count = 137
  or lin_count = 154 or lin_count = 171.

  lin_count = 1.

PERFORM concat.

perform bdc_dynpro      using 'SAPLCPDI' '1400'.
perform bdc_field       using 'BDC_CURSOR'
                              'PLPOD-LTXA1(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using x1
                              wa_itab-steus.
perform bdc_field       using x2
                              wa_itab-ltxa1.

endif.

lin_count = lin_count + 1.

at end of matnr.

perform bdc_field       using 'BDC_OKCODE'
                              'BU'.
endat.

PERFORM session  USING 'QP01'.

REFRESH bdcdata.

endloop.

 PERFORM close_group.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CONCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM concat .

  IF lin_count < 18.
    CONCATENATE 'PLPOD-STEUS(' lin_count ')' INTO x1.
    CONCATENATE 'PLPOD-LTXA1(' lin_count ')' INTO x2.

   endif.

ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  IF fval <> ''.
    CLEAR bdcdata.
    bdcdata-fnam = fnam.
    bdcdata-fval = fval.
    APPEND bdcdata.
  ENDIF.
ENDFORM.                    "BDC_FIELD

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
*&---------------------------------------------------------------------*
*&      Form  OPEN_GROUP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM open_group .

  SKIP.
  WRITE: /(20) 'Create group'(i01), group.
  SKIP.
  CALL FUNCTION 'BDC_OPEN_GROUP'
    EXPORTING
      client = sy-mandt
      group  = group
      user   = sy-uname
      keep   = 'X'.
*              HOLDDATE = HOLDDATE.
  WRITE: /(30) 'BDC_OPEN_GROUP'(i02),
    (12) 'returncode:'(i05),
         sy-subrc.


ENDFORM.
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
  WRITE: /(30) 'BDC_CLOSE_GROUP'(i04),
          (12) 'returncode:'(i05),
               sy-subrc.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SESSION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0506   text
*----------------------------------------------------------------------*
FORM session  USING TCODE.

  CALL FUNCTION 'BDC_INSERT'
    EXPORTING
      tcode     = tcode
    TABLES
      dynprotab = bdcdata.
  WRITE: /(25) 'BDC_INSERT'(i03),
               tcode,
          (12) 'returncode:'(i05),
               sy-subrc.
  REFRESH bdcdata.

ENDFORM.
