REPORT zsd_cust_mat
       NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPES: BEGIN OF ty_itab,
         kunnr(010),
         vkorg(004),
         vtweg(002),
         matnr(018),
         kdmat(035),
       END OF ty_itab.


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
      i_end_col               = '5'
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

      WHEN '0001'. wa_itab-kunnr = wa_excel-value.
      WHEN '0002'. wa_itab-vkorg = wa_excel-value.
      WHEN '0003'. wa_itab-vtweg = wa_excel-value.
      WHEN '0004'. wa_itab-matnr = wa_excel-value.
      WHEN '0005'. wa_itab-kdmat = wa_excel-value.

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

  LOOP AT it_itab INTO wa_itab.

    ON CHANGE OF wa_itab-kunnr.

      lin_count = 0.

      PERFORM bdc_dynpro      USING 'SAPMV10A' '0100'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'MV10A-VTWEG'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM bdc_field       USING 'MV10A-KUNNR'
                                    wa_itab-kunnr.
      PERFORM bdc_field       USING 'MV10A-VKORG'
                                    wa_itab-vkorg.
      PERFORM bdc_field       USING 'MV10A-VTWEG'
                                    wa_itab-vtweg.

    ENDON.

    ON CHANGE OF wa_itab-matnr.

      lin_count = lin_count + 1.

      IF lin_count < 15.

        PERFORM concat.

        PERFORM bdc_dynpro      USING 'SAPMV10A' '0200'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      'MV10A-KDMAT(01)'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '/00'.
        PERFORM bdc_field       USING x1
                                      wa_itab-matnr.
        PERFORM bdc_field       USING x2
                                      wa_itab-kdmat.
      ENDIF.



      IF lin_count = 15 OR lin_count = 29 OR lin_count = 43 OR lin_count = 57 OR lin_count = 71 OR lin_count = 85
          OR lin_count = 99 OR lin_count = 113 OR lin_count = 127 OR lin_count = 141.

        lin_count = 1.

        PERFORM concat.

        PERFORM bdc_dynpro      USING 'SAPMV10A' '0200'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '=P+'.

        PERFORM bdc_dynpro      USING 'SAPMV10A' '0200'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      'MV10A-KDMAT(01)'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '/00'.
        PERFORM bdc_field       USING x1
                                      wa_itab-matnr.
        PERFORM bdc_field       USING x2
                                      wa_itab-kdmat.

      ENDIF.

    ENDON.

    AT END OF kunnr.

      PERFORM bdc_dynpro      USING 'SAPMV10A' '0200'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'MV10A-MATNR(01)'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=SICH'.

     PERFORM session  USING 'VD51'.

    ENDAT.

  ENDLOOP.

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

  IF lin_count < 15.
    CONCATENATE 'MV10A-MATNR(' lin_count ')' INTO x1.
    CONCATENATE 'MV10A-KDMAT(' lin_count ')' INTO x2.
  ENDIF.

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
*&      Form  SESSION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0471   text
*----------------------------------------------------------------------*
FORM session  USING  tcode.

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
