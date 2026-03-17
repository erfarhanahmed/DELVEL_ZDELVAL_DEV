*&---------------------------------------------------------------------*
*& Report ZMM_UPLOAD_MAT_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_upload_mat_class.

TYPES: BEGIN OF ty_file,
         matnr(40),
         class(10),
         ch_stem(40),
         ch_seat(40),
         ch_body(40),
         ch_disc(40),
         ch_ball(40),
         ch_rating(40),
         ch_testing(40),
         ch_airfail(40),
         ch_minairp(40),
       END OF ty_file.

TYPES: BEGIN OF ty_ch,
         name(40),
         val(40),
       END OF ty_ch.

DATA: gv_file               TYPE ibipparms-path.
DATA: gt_file TYPE TABLE OF ty_file.
DATA gt_bdcdata TYPE TABLE OF bdcdata.

CONSTANTS :  c_x(01)     TYPE c VALUE 'X'.       "Assigning the Value X
*>>
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-t06 .
PARAMETERS : p_file LIKE rlgrap-filename .
SELECTION-SCREEN END OF BLOCK blk1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS p1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b2.

*>>
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = gv_file.
  p_file = gv_file .

*>>
START-OF-SELECTION.
  PERFORM read_data.
  PERFORM run_bdc.
*&---------------------------------------------------------------------*
*&      Form  READ_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_data .

  TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.

  DATA: lt_rawdata TYPE truxs_t_text_data.
  DATA: lv_str  TYPE string,
        lv_bool TYPE c.

*Read the upload file
  lv_str = p_file .
  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file   = lv_str
    RECEIVING
      result = lv_bool.

  IF lv_bool IS NOT INITIAL .
*    v_file_up = p_file .
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
*       I_LINE_HEADER        =
        i_tab_raw_data       = lt_rawdata
        i_filename           = p_file
      TABLES
        i_tab_converted_data = gt_file
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RUN_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM run_bdc .

  DATA: lt_ch   TYPE TABLE OF ty_ch,
        ls_ch   TYPE ty_ch,
        ls_file TYPE ty_file.

  DATA: lv_row(2) TYPE n,
        lv_fld    TYPE fnam_____4.

  LOOP AT gt_file INTO ls_file.

    REFRESH: lt_ch, gt_bdcdata.

    IF ls_file-ch_stem IS NOT INITIAL.
      ls_ch-name = 'STEM'.
      ls_ch-val = ls_file-ch_stem.
      APPEND ls_ch TO lt_ch.
    ENDIF.

    IF ls_file-ch_seat IS NOT INITIAL.
      ls_ch-name = 'SEAT'.
      ls_ch-val = ls_file-ch_seat.
      APPEND ls_ch TO lt_ch.
    ENDIF.

    IF ls_file-ch_body IS NOT INITIAL.
      ls_ch-name = 'BODY'.
      ls_ch-val = ls_file-ch_body.
      APPEND ls_ch TO lt_ch.
    ENDIF.

    IF ls_file-ch_disc IS NOT INITIAL.
      ls_ch-name = 'DISC'.
      ls_ch-val = ls_file-ch_disc.
      APPEND ls_ch TO lt_ch.
    ENDIF.

    IF ls_file-ch_ball IS NOT INITIAL.
      ls_ch-name = 'BALL'.
      ls_ch-val = ls_file-ch_ball.
      APPEND ls_ch TO lt_ch.
    ENDIF.

    IF ls_file-ch_rating IS NOT INITIAL.
      ls_ch-name = 'RATING'.
      ls_ch-val = ls_file-ch_rating.
      APPEND ls_ch TO lt_ch.
    ENDIF.

    IF ls_file-ch_testing IS NOT INITIAL.
      ls_ch-name = 'CLASS'.
      ls_ch-val = ls_file-ch_testing.
      APPEND ls_ch TO lt_ch.
    ENDIF.

    IF ls_file-ch_airfail IS NOT INITIAL.
      ls_ch-name = 'AIR_FAIL_POSITION'.
      ls_ch-val = ls_file-ch_airfail.
      APPEND ls_ch TO lt_ch.
    ENDIF.

    IF ls_file-ch_minairp IS NOT INITIAL.
      ls_ch-name = 'MIN_AIR_PRESSURE'.
      ls_ch-val = ls_file-ch_minairp.
      APPEND ls_ch TO lt_ch.
    ENDIF.

    PERFORM bdc_dynpro  USING 'SAPLCLFM' '1110'.
    PERFORM bdc_field   USING 'BDC_OKCODE'  '/00'.    "'=AL_CREATE'.
    PERFORM bdc_field   USING 'RMCLF-CLASN'  ls_file-class.  "'ZACT'.
    PERFORM bdc_field   USING 'RMCLF-KLART'  '001'.

    PERFORM bdc_dynpro  USING 'SAPLCLFM' '1110'.
    PERFORM bdc_field   USING 'BDC_OKCODE'   '=AL_CREATE'.
    PERFORM bdc_field   USING 'RMCLF-CLASN'  ls_file-class.  "'ZACT'.
    PERFORM bdc_field   USING 'RMCLF-KLART'  '001'.

    """"""""""""        Added By KD on 26.05.2017   """"""""""""""""""""""""
    PERFORM bdc_dynpro  USING 'SAPLCLFM' '0602'.
    PERFORM bdc_field   USING 'BDC_CURSOR' 'RMCLF-RADIO(02)'.
    PERFORM bdc_field   USING 'BDC_OKCODE' '=ENTE'.
    PERFORM bdc_field   USING 'RMCLF-RADIO(02)' 'X'.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    PERFORM bdc_dynpro  USING 'SAPLCLFM' '0512'.
    PERFORM bdc_field   USING 'BDC_OKCODE'  '/00'.
    PERFORM bdc_field   USING 'RMCLF-MATNR(01)' ls_file-matnr. "'JAY_FG_TEST001'.

    PERFORM bdc_dynpro  USING 'SAPLCTMS' '0109'.
    PERFORM bdc_field   USING 'BDC_OKCODE'  '=BACK'.

    lv_row = '01'.
    LOOP AT lt_ch INTO ls_ch.
      CLEAR lv_fld.
      CONCATENATE 'RCTMS-MNAME(' lv_row ')'
        INTO lv_fld.
      PERFORM bdc_field   USING lv_fld ls_ch-name.

      CLEAR lv_fld.
      CONCATENATE 'RCTMS-MWERT(' lv_row ')'
        INTO lv_fld.
      PERFORM bdc_field   USING lv_fld ls_ch-val.

      lv_row = lv_row + 1.

    ENDLOOP.

**    PERFORM bdc_field   USING 'RCTMS-MNAME(01)'  'STEM'.
**    PERFORM bdc_field   USING 'RCTMS-MWERT(01)'  '40'.

    PERFORM bdc_dynpro  USING 'SAPLCLFM' '0512'.
    PERFORM bdc_field   USING 'BDC_OKCODE'  '=SAVE'.
    PERFORM bdc_field   USING 'RMCLF-PAGPOS'  '1'.

    PERFORM bdc_dynpro  USING 'SAPLCLFM' '1110'.
    PERFORM bdc_field   USING 'BDC_OKCODE'   '=SAVE'.
    PERFORM bdc_field   USING 'RMCLF-PAGPOS'  '1'.

    PERFORM bdc_transaction USING 'CL24N'.

  ENDLOOP.

ENDFORM.
*&--------------------------------------------------------------------*
*&      Form  bdc_dynpro
*&--------------------------------------------------------------------*
FORM bdc_dynpro  USING rprogram TYPE bdc_prog
                       rdynpro  TYPE bdc_dynr.

*Work Area for the Internal table T_BDCDATA
  DATA : wa_bdcdata TYPE bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-program  = rprogram.
  wa_bdcdata-dynpro   = rdynpro.
  wa_bdcdata-dynbegin = c_x.
  APPEND wa_bdcdata TO gt_bdcdata.

ENDFORM.                    " bdc_dynpro
*&--------------------------------------------------------------------*
*&      Form  bdc_field
*&--------------------------------------------------------------------*
FORM bdc_field  USING rfnam TYPE fnam_____4
                      rfval.
*Work Area for the Internal table T_BDCDATA
  DATA : wa_bdcdata TYPE bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = rfnam.
  wa_bdcdata-fval = rfval.
  APPEND wa_bdcdata TO gt_bdcdata.

ENDFORM.                    " bdc_field
*----------------------------------------------------------------------*
*        Start new transaction according to parameters                 *
*----------------------------------------------------------------------*
FORM bdc_transaction USING tcode.

  DATA: l_mstring(480).
  DATA: messtab LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE.
  DATA: l_subrc LIKE sy-subrc,
        ctumode LIKE ctu_params-dismode VALUE 'N',
        cupdate LIKE ctu_params-updmode VALUE 'L'.

  IF p1 = 'X'.
    ctumode = 'A'.
  ELSE.
    ctumode = 'N'.
  ENDIF.

  REFRESH messtab.
  CALL TRANSACTION tcode USING gt_bdcdata
                   MODE   ctumode
                   UPDATE cupdate
                   MESSAGES INTO messtab.
  l_subrc = sy-subrc.
*    IF SMALLLOG <> 'X'.
  WRITE: / 'CALL_TRANSACTION', tcode,
           'returncode:'(i05),
           l_subrc,  'RECORD:', sy-index.
  LOOP AT messtab.
    MESSAGE ID     messtab-msgid
            TYPE   messtab-msgtyp
            NUMBER messtab-msgnr
            INTO l_mstring
            WITH messtab-msgv1
                 messtab-msgv2
                 messtab-msgv3
                 messtab-msgv4.
    WRITE: / messtab-msgtyp, l_mstring(250).
  ENDLOOP.
  WRITE: / '!----------------*--------------->'.
  SKIP.
*    ENDIF.
  REFRESH gt_bdcdata.
ENDFORM.
