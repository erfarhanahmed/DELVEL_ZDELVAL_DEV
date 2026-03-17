REPORT zstor_loc_ext
       NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPES: BEGIN OF ty_itab,
         matnr(018),
         werks(004),
         lgort(004),
       END OF ty_itab.

TYPES: BEGIN OF ty_mard,
            MATNR TYPE MARD-MATNR,
            WERKS TYPE MARD-WERKS,
*         matnr(018),
*         werks(004),
       END OF ty_mard.


*DATA : gt_mard TYPE STANDARD TABLE OF mard.
data :  gt_mard TYPE STANDARD TABLE OF ty_mard.

****include bdcrecx1.

DATA : it_itab TYPE STANDARD TABLE OF ty_itab.
DATA : it_itab1 TYPE STANDARD TABLE OF ty_itab.
DATA : wa_itab LIKE LINE OF it_itab.
DATA : wa_itab1 LIKE LINE OF it_itab.
DATA : wa_itabt LIKE LINE OF it_itab.
DATA : bdcdata LIKE bdcdata OCCURS 0 WITH HEADER LINE.
DATA : lt_msgtab TYPE STANDARD TABLE OF bdcmsgcoll,
       wa_msgtab TYPE bdcmsgcoll.
DATA : lv_mestext TYPE char100.
DATA : filename TYPE string.
DATA : lv_fname TYPE localfile.
DATA : it_excel TYPE TABLE OF alsmex_tabline.
DATA : wa_excel TYPE alsmex_tabline.

DATA : lin_count(002), in_count(003).
DATA : x1(015),x2(015),x3(015),x4(015).


DATA: cupdate LIKE ctu_params-updmode VALUE 'S'.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: p_file   TYPE localfile OBLIGATORY,
            ctu_mode TYPE ctu_mode  DEFAULT 'A'.
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

      WHEN '0001'. wa_itab-matnr = wa_excel-value.
      WHEN '0002'. wa_itab-werks = wa_excel-value.
      WHEN '0003'. wa_itab-lgort = wa_excel-value.

    ENDCASE.

    AT END OF row.
      APPEND wa_itab TO it_itab.
    ENDAT.
  ENDLOOP.
  ENDFORM.

*  *&---------------------------------------------------------------------*
*&      Form  BDC_EXECUTATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bdc_executation .

data : lv_matnr TYPE mard-matnr.

DESCRIBE TABLE gt_mard[] LINES data(n).

LOOP AT it_itab[] INTO wa_itab. "FROM 1 to n.

REFRESH: gt_mard[], bdcdata.

*--paresh workbench------------------------------------------------------------------*
CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
  EXPORTING
    input              = wa_itab-matnr
 IMPORTING
   OUTPUT             =  lv_matnr.
*----counter purpose----------------------------------------------------------------*
      SELECT  matnr werks
      FROM mard
      INTO TABLE gt_mard[]
      WHERE matnr = lv_matnr . "WA_ITAB-MATNR.
*      AND   werks = WA_ITAB-WERKS.
CLEAR: lv_matnr.

  IF SY-SUBRC = 0.
    DESCRIBE TABLE gt_mard[] LINES lin_count.
  ELSE.
    MESSAGE 'LINE COUNT IS ZERO' TYPE 'E'.
  ENDIF.
*--------------------------------------------------------------------*
    ON CHANGE OF wa_itab-matnr.

      PERFORM bdc_dynpro      USING 'SAPMM03M' '0105'.
*      PERFORM bdc_field       USING 'BDC_CURSOR'
*                                    'RM03M-MATNR'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM bdc_field       USING 'RM03M-MATNR'
                                    wa_itab-matnr.
      PERFORM bdc_field       USING 'RM03M-WERKS'
                                    wa_itab-werks.
****perform bdc_field       using 'RM03M-LFLAG'
****                              'X'.

*    ENDON.

*    ON CHANGE OF wa_itab-lgort.

      lin_count = lin_count + 1.

      IF lin_count < 11.

        PERFORM concat.

        PERFORM bdc_dynpro      USING 'SAPMM03M' '0195'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      x1.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '/00'.

        PERFORM bdc_field       USING  x1
                                      wa_itab-lgort.

      IF lin_count = 11 OR lin_count = 21 OR lin_count = 31 OR lin_count = 41 OR lin_count = 51 OR lin_count = 61 OR lin_count = 71
      OR lin_count = 81 OR lin_count = 91 OR lin_count = 101.

        lin_count = 1.

        PERFORM concat.

        PERFORM bdc_dynpro      USING 'SAPMM03M' '0195'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '=FCNP'.

        PERFORM bdc_dynpro      USING 'SAPMM03M' '0195'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                x1.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.

          PERFORM bdc_field     USING  x1
                                wa_itab-lgort.

          lin_count = lin_count + 1.
****          PERFORM concat.
      endif.

        endif.
    ENDON.

    AT END OF matnr.
      PERFORM bdc_dynpro      USING 'SAPMM03M' '0195'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '=BU'.
*      PERFORM CALL_MMSC.
  CALL TRANSACTION 'MMSC' USING bdcdata
             MODE ctu_mode
             UPDATE cupdate
             MESSAGES INTO lt_msgtab.

clear : wa_itab-matnr,wa_itab-werks,wa_itab-lgort.

    ENDAT.
*   CLEAR x1.

ENDLOOP.



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


ENDFORM.


FORM concat .

  IF lin_count < 15.
    CONCATENATE 'RM03M-LGORT' '(' lin_count ')' INTO x1.
  ENDIF.

ENDFORM.

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
*&      Form  CALL_MMSC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM call_mmsc .
*
*  CALL TRANSACTION 'MMSC' USING bdcdata
*             MODE ctu_mode
*             UPDATE cupdate
*             MESSAGES INTO lt_msgtab.
*
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALL_MMSC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM call_mmsc .
*
*ENDFORM.
