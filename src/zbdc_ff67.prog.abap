*&---------------------------------------------------------------------*
*& Report  ZFF67
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zbdc_ff67.
*REPORT yfir_ff67_bdc   NO STANDARD PAGE HEADING LINE-SIZE 255.

*********************data declaration *****************************
* Upload Internal table structure.
TYPES : BEGIN OF ty_itab,
     bankl(15),
     bankn(18),
     waers(10),
     aznum(10),
     azdat(10),
     ssald(20),
     esald(20),
     budtm(10),
     nm1vb,
     vgman(4),
     valut(10),
     kwbtr(17),
     CHECT_KF(16),
     xblnr(16),
     belnr(10),
     kostl_kf(10),
     prctr_kf(10),
     kunnr(10),
     lifnr(10),
*     gsber_kf(4),
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

DATA:cupdate LIKE ctu_params-updmode VALUE 'S'.

*********************** Screen Selection **************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: p_file TYPE localfile OBLIGATORY,
            ctu_mode  TYPE ctu_mode  DEFAULT 'A'.
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

**&---------------------------------------------------------------------
*
**&      Form  UPLOAD_FILE
**&---------------------------------------------------------------------
*
**       text
**----------------------------------------------------------------------
*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------
*
FORM upload_file .
*  break vsankalp.
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

* Format the data to the internal table
  LOOP AT it_excel INTO wa_excel.
    AT NEW row.
      CLEAR: wa_itab.
    ENDAT.
    CASE wa_excel-col.
      WHEN '0001'. wa_itab-bankl = wa_excel-value.
      WHEN '0002'. wa_itab-bankn = wa_excel-value.
      WHEN '0003'. wa_itab-waers = wa_excel-value.
      WHEN '0004'. wa_itab-aznum = wa_excel-value.
      WHEN '0005'. wa_itab-azdat = wa_excel-value.
      WHEN '0006'. wa_itab-ssald = wa_excel-value.
      WHEN '0007'. wa_itab-esald = wa_excel-value.
      WHEN '0008'. wa_itab-budtm = wa_excel-value.
      WHEN '0009'. wa_itab-nm1vb = wa_excel-value.
      WHEN '0010'. wa_itab-vgman = wa_excel-value.
      WHEN '0011'. wa_itab-valut = wa_excel-value.
      WHEN '0012'. wa_itab-kwbtr = wa_excel-value.
      WHEN '0014'. wa_itab-belnr = wa_excel-value.

*      changed  by vidya sagar
      WHEN '0013'. wa_itab-CHECT_KF = wa_excel-value.
      WHEN '0015'. wa_itab-kostl_kf = wa_excel-value.
      WHEN '0016'. wa_itab-prctr_kf = wa_excel-value.
      WHEN '0014'. wa_itab-kunnr = wa_excel-value.
      WHEN '0018'. wa_itab-lifnr = wa_excel-value.

*      WHEN '0014'. wa_itab-gsber_kf = wa_excel-value.
*end vidya sagar.
    ENDCASE.
    AT END OF row.
      APPEND wa_itab TO it_itab.
    ENDAT.
  ENDLOOP.

  LOOP AT it_itab INTO wa_itab.
    IF sy-tabix <> 1.
      wa_itab-bankl = wa_itabt-bankl.
      wa_itab-bankn = wa_itabt-bankn.
      wa_itab-waers = wa_itabt-waers.
      wa_itab-aznum = wa_itabt-aznum.
      wa_itab-azdat = wa_itabt-azdat.
      wa_itab-ssald = wa_itabt-ssald.
      wa_itab-esald = wa_itabt-esald.
      wa_itab-budtm = wa_itabt-budtm.
      wa_itab-nm1vb = wa_itabt-nm1vb.
      MODIFY it_itab FROM wa_itab INDEX sy-tabix.
    ELSE.
      wa_itabt = wa_itab.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " UPLOAD_FILE

*&---------------------------------------------------------------------*
*&      Form  bdc_executation
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM bdc_executation.

*read dataset dataset into record.
*if sy-subrc <> 0. exit. endif.
  DATA : lv_index TYPE char5.
  DATA : lv_field TYPE bdc_fval.
  DATA : lv_count(5) TYPE n.
  DATA : lv_count1(5) TYPE n.

*  SORT it_itab ASCENDING BY bankl.
  DESCRIBE TABLE it_itab LINES lv_count.
  LOOP AT it_itab INTO wa_itab.
    lv_count1 = lv_count1 + 1.

    lv_index = lv_index + 1.

    ON CHANGE OF wa_itab-bankl.

      PERFORM bdc_dynpro      USING 'SAPMF40K' '0102'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'FEBMKA-NM1VB'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM bdc_field       USING 'FEBMKA-BANKL'
                                    wa_itab-bankl.
      PERFORM bdc_field       USING 'FEBMKA-BANKN'
                                    wa_itab-bankn.
      PERFORM bdc_field       USING 'FEBMKA-WAERS'
                                    wa_itab-waers.
      PERFORM bdc_field       USING 'FEBMKA-AZNUM'
                                     wa_itab-aznum.
      PERFORM bdc_field       USING 'FEBMKA-AZDAT'
                                    wa_itab-azdat.
      PERFORM bdc_field       USING 'FEBMKA-SSALD'
                                    wa_itab-ssald.
      PERFORM bdc_field       USING 'FEBMKA-ESALD'
                                    wa_itab-esald.
      PERFORM bdc_field       USING 'FEBMKA-BUDTM'
                                    wa_itab-budtm.
      PERFORM bdc_field       USING 'FEBMKA-NM1VB'
                                    wa_itab-nm1vb.

        PERFORM bdc_dynpro      USING 'SAPMF40K' '8000'.

      IF lv_count > 18.
        PERFORM bdc_field       USING 'BDC_OKCODE'   '=P+'.
      ENDIF.
    ENDON.

    IF lv_count1 EQ 18 AND lv_count1 <= lv_count.



        PERFORM bdc_dynpro      USING 'SAPMF40K' '8000'.
        PERFORM bdc_field       USING 'BDC_OKCODE'   '=P+'.

      lv_count = lv_count - 18.
      lv_count1 = 0.
      lv_index = 1.
    ENDIF.

    CONDENSE lv_index.

    CONCATENATE 'FEBMKA-VGMAN(' lv_index ')' INTO lv_field.
    PERFORM bdc_field       USING lv_field    "'FEBMKA-VGMAN'
                                  wa_itab-vgman.

    CONCATENATE 'FEBEP-VALUT(' lv_index ')' INTO lv_field.
    PERFORM bdc_field       USING lv_field    "'FEBEP-VALUT'
                                  wa_itab-valut.

    CONCATENATE 'FEBMKA-KWBTR(' lv_index ')' INTO lv_field.
    PERFORM bdc_field       USING lv_field    "'FEBMKA-KWBTR'
                                  wa_itab-kwbtr.

    CONCATENATE 'FEBMKK-BELNR(' lv_index ')' INTO lv_field.
    PERFORM bdc_field       USING lv_field    "'FEBMKK-XBLNR'
                                  wa_itab-belnr.
*changed by vidya sagar
    CONCATENATE 'FEBMKK-KOSTL_KF(' lv_index ')' INTO lv_field.
    PERFORM bdc_field       USING lv_field    "'FEBMKK-XBLNR'
                                  wa_itab-kostl_kf.

    CONCATENATE 'FEBMKK-PRCTR_KF(' lv_index ')' INTO lv_field.
    PERFORM bdc_field       USING lv_field    "'FEBMKK-XBLNR'
                                  wa_itab-prctr_kf.

CONCATENATE 'FEBMKK-CHECT_KF(' lv_index ')' INTO lv_field.
    PERFORM bdc_field       USING lv_field    "'FEBMKK-XBLNR'
                                  wa_itab-CHECT_KF.

    CONCATENATE 'FEBMKK-KUNNR(' lv_index ')' INTO lv_field.
    PERFORM bdc_field       USING lv_field    "'FEBMKK-XBLNR'
                                  wa_itab-kunnr.

    CONCATENATE 'FEBMKK-LIFNR(' lv_index ')' INTO lv_field.
    PERFORM bdc_field       USING lv_field    "'FEBMKK-XBLNR'
                                  wa_itab-lifnr.

* changed by vidya sagar.

*    CONCATENATE 'FEBMKK-GSBER_KF(' lv_index ')' INTO lv_field.
*    PERFORM bdc_field       USING lv_field    "'FEBMKK-GSBER_KF'
*                                  wa_itab-gsber_kf.

    AT END OF bankl.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=SICH'.

      PERFORM bdc_dynpro      USING 'SAPMF40K' '0102'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'FEBMKA-BANKL'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=BUCH'.

****      PERFORM bdc_dynpro      USING 'SAPMSSY0' '0120'.
****      PERFORM bdc_field       USING 'BDC_OKCODE'
****                                    '/00'.
****      PERFORM bdc_dynpro      USING 'SAPMSSY0' '0120'.
****      PERFORM bdc_field       USING 'BDC_OKCODE'
****                                    '=&F03'.
****      PERFORM bdc_dynpro      USING 'SAPMF40K' '0102'.
****
****      PERFORM bdc_field       USING 'BDC_OKCODE'
****                                    '=BACK'.

    ENDAT.
  ENDLOOP.

  CALL TRANSACTION 'FF67' USING bdcdata
        MODE ctu_mode UPDATE cupdate
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

ENDFORM.                    "bdc_executation


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
  IF fval <> ''.
    CLEAR bdcdata.
    bdcdata-fnam = fnam.
    bdcdata-fval = fval.
    APPEND bdcdata.
  ENDIF.
ENDFORM.                    "BDC_FIELD
