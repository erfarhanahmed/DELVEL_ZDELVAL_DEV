REPORT zmm_material_desc_bdc
       NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.

TYPES : BEGIN OF ty_file,
          matnr(18),        """  Material
          maktx(40),        """  Vendor
        END OF ty_file .

DATA : gt_file TYPE TABLE OF ty_file,
       gs_file TYPE ty_file.

DATA: gv_file    TYPE ibipparms-path,
      gt_bdcdata TYPE TABLE OF bdcdata.

SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-t06 .
PARAMETERS : p_file LIKE rlgrap-filename .
SELECTION-SCREEN END OF BLOCK blk1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = gv_file.
  p_file = gv_file .

START-OF-SELECTION.
  PERFORM read_data.
  IF gt_file[] IS NOT INITIAL.
    PERFORM run_bdc.
  ELSE.
    MESSAGE 'No Data found' TYPE 'E'.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  READ_DATA
*&---------------------------------------------------------------------*
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
FORM run_bdc .

  LOOP AT gt_file INTO gs_file.

    PERFORM bdc_dynpro      USING 'SAPLMGMM' '0060'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RMMG1-MATNR'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTR'.
    PERFORM bdc_field       USING 'RMMG1-MATNR'
                                   gs_file-matnr     .       "'BFV'.
    PERFORM bdc_dynpro      USING 'SAPLMGMM' '0070'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'MSICHTAUSW-DYTXT(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTR'.
    PERFORM bdc_field       USING 'MSICHTAUSW-KZSEL(01)'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPLMGMM' '4004'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BU'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'MAKT-MAKTX'.
    PERFORM bdc_field       USING 'MAKT-MAKTX'
                                   gs_file-maktx .        """""' BFV 1'.

    PERFORM bdc_transaction USING 'MM02'.
    CLEAR gs_file.
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
  wa_bdcdata-dynbegin = 'X'.
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

*  IF p1 = 'X'.
*    ctumode = 'A'.
*  ELSE.
  ctumode = 'N'.
*  ENDIF.

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
