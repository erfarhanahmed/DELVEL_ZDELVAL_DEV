REPORT zqm_inspection_plan
       NO STANDARD PAGE HEADING LINE-SIZE 255.

TABLES :SSCRFIELDS.

TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.


TYPES:
  BEGIN OF t_mapl,
    matnr TYPE mapl-matnr,
    werks TYPE mapl-werks,
    plnty TYPE mapl-plnty,
    plnnr TYPE mapl-plnnr,
    plnal TYPE mapl-plnal,
  END OF t_mapl,
  tt_mapl TYPE STANDARD TABLE OF t_mapl.

TYPES:
  BEGIN OF t_plko,
    plnty TYPE plko-plnty,
    plnnr TYPE plko-plnnr,
    plnal TYPE plko-plnal,
    zaehl TYPE plko-zaehl,
    verwe TYPE plko-verwe,
    statu TYPE plko-statu,
  END OF t_plko,
  tt_plko TYPE STANDARD TABLE OF t_plko.

TYPES :
  BEGIN OF ty_file,
    matnr(018) TYPE c,
    werks(004) TYPE c,
    verwe(001) TYPE c,
    statu(001) TYPE c,
  END OF ty_file .

TYPES:
  BEGIN OF t_file,
    matnr TYPE mapl-matnr,
    werks TYPE mapl-werks,
    verwe TYPE plko-verwe,
    statu TYPE plko-statu,
  END OF t_file,
  tt_file TYPE STANDARD TABLE OF t_file.

DATA :
  gt_file TYPE TABLE OF ty_file,
  gs_file TYPE ty_file.

DATA:
  gv_file    TYPE ibipparms-path,
  gt_bdcdata TYPE TABLE OF bdcdata,
  wa_mapl    TYPE mapl,
  lv_date    TYPE c LENGTH 10,
  flag       TYPE c.

SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-t06 .
PARAMETERS : p_file LIKE rlgrap-filename .
SELECTION-SCREEN END OF BLOCK blk1.


SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN END OF LINE.

INITIALIZATION.
* Add displayed text string to buttons
  W_BUTTON = 'Download Excel Template'.


AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM EQ 'BUT1' .
    SUBMIT  ZQM_INSPECTION_EXCEL VIA SELECTION-SCREEN .
  ENDIF.




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

  DATA:
    lt_mapl TYPE tt_mapl,
    ls_mapl TYPE t_mapl,
    lt_plko TYPE tt_plko,
    ls_plko TYPE t_plko,
    lt_file TYPE tt_file.

  SORT gt_file BY werks matnr .
  lt_file[] = gt_file[].
  SELECT matnr
         werks
         plnty
         plnnr
         plnal
    FROM mapl
    INTO TABLE lt_mapl
    FOR ALL ENTRIES IN lt_file
    WHERE matnr = lt_file-matnr
    AND   werks = lt_file-werks
    AND   plnty = 'Q'
    AND   loekz = ' '.

  IF NOT lt_mapl IS INITIAL.
    SELECT plnty
           plnnr
           plnal
           zaehl
           verwe
           statu
      FROM plko
      INTO TABLE lt_plko
      FOR ALL ENTRIES IN lt_mapl
      WHERE plnty = lt_mapl-plnty
      AND   plnnr = lt_mapl-plnnr
      AND   plnal = lt_mapl-plnal.


  ENDIF.
  LOOP AT gt_file INTO gs_file.

**    CLEAR : ls_mapl , flag .
**    SELECT SINGLE *
**             FROM mapl
**             INTO wa_mapl
**             WHERE matnr = gs_file-matnr
**             AND   werks = gs_file-werks
**             AND   loekz = ' '.

    CLEAR: ls_mapl,ls_plko,flag.
    READ TABLE lt_mapl INTO ls_mapl WITH KEY matnr = gs_file-matnr
                                             werks = gs_file-werks.
    IF sy-subrc NE 0.
      flag = 'X' .

    ENDIF.
*    AT NEW matnr .

*    ENDAT .

    IF NOT ls_mapl IS INITIAL.
      READ TABLE lt_plko INTO ls_plko WITH KEY plnty = ls_mapl-plnty
                                               plnnr = ls_mapl-plnnr
*                                               plnal = ls_mapl-plnal
                                               verwe = gs_file-verwe
                                               statu = gs_file-statu.

***      SELECT SINGLE plnty
***                    plnnr
***                    plnal
***                    zaehl
***                    verwe
***                    statu
***               FROM plko
***               INTO ls_plko
***               WHERE plnty = ls_mapl-plnty
***               AND   plnnr = ls_mapl-plnnr
***               AND   plnal = ls_mapl-plnal
***               AND   verwe = gs_file-verwe
***               AND   statu = gs_file-statu.
    ENDIF.

    IF ls_plko IS INITIAL.
      CLEAR lv_date .
      CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum(4) INTO lv_date SEPARATED BY '.'.

      PERFORM bdc_dynpro      USING 'SAPLCPDI' '8010'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'RC27M-WERKS'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM bdc_field       USING 'RC27M-MATNR'
                                    gs_file-matnr .    """'bfv'.
      PERFORM bdc_field       USING 'RC27M-WERKS'
                                    gs_file-werks .    """"'PL01'.
      PERFORM bdc_field       USING 'RC271-STTAG'
                                    lv_date   .              """""'30.05.2017'.

      IF flag NE 'X'.
        PERFORM bdc_dynpro      USING 'SAPLCPDI' '1200'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      'RC27X-ENTRY_ACT'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '=ANLG'.
        PERFORM bdc_field       USING 'RC27X-ENTRY_ACT'
                                '1'.

        PERFORM bdc_dynpro      USING 'SAPLCPDA' '1200'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '=MTUE'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      'PLKOD-PLNAL'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      'PLKOD-STATU'.
        PERFORM bdc_field       USING 'PLKOD-VERWE'
                                      gs_file-verwe .
        PERFORM bdc_field       USING 'PLKOD-STATU'
                                      gs_file-statu .
        PERFORM bdc_dynpro      USING 'SAPLCZDI' '4010'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      'MAPL-LIFNR(01)'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '=BACK'.
        PERFORM bdc_dynpro      USING 'SAPLCPDA' '1200'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '=BU'.
*      PERFORM bdc_field       USING 'BDC_CURSOR'
*                                    'PLKOD-STATU'.
      ELSE.
        PERFORM bdc_dynpro      USING 'SAPLCPDA' '1200'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '/00'.

        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      'PLKOD-STATU'.
        PERFORM bdc_field       USING 'PLKOD-VERWE'
                                      gs_file-verwe .         """"""'5'.
        PERFORM bdc_field       USING 'PLKOD-STATU'
                                      gs_file-statu .         """""""'4'.
        PERFORM bdc_dynpro      USING 'SAPLCPDA' '1200'.
        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '=BU'.
      ENDIF.

      PERFORM bdc_transaction USING 'QP01'.
    ELSE.
      WRITE :/,'Inspection Plan is already created for ',gs_file-matnr.
    ENDIF.

    CLEAR gs_file .
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
