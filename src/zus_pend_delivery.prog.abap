*&---------------------------------------------------------------------*
*& Report ZPEND_INV_QTY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zus_pend_delivery.

TYPE-POOLS: slis.

TABLES : vbpa,kna1,vbak,likp,lips,vbap.

TYPES : BEGIN OF ty_vbpa,
          vbeln TYPE vbpa-vbeln,
          posnr TYPE vbpa-posnr,
          parvw TYPE vbpa-parvw,
          kunnr TYPE vbpa-kunnr,
        END OF ty_vbpa,

        BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
        END OF ty_kna1,

        BEGIN OF ty_vbap,
          vbeln  TYPE vbap-vbeln,
          posnr  TYPE vbap-posnr,
          matnr  TYPE vbap-matnr,
          kwmeng TYPE vbap-kwmeng,
          vrkme  TYPE vbap-vrkme,
          werks  TYPE vbap-werks,
        END OF ty_vbap,

        BEGIN OF ty_likp,
          vbeln TYPE likp-vbeln,
          lfdat TYPE likp-lfdat,
        END OF ty_likp,

        BEGIN OF ty_vbfa,
          vbelv   TYPE  vbfa-vbeln,
          posnv   TYPE vbfa-posnv,
          vbeln   TYPE vbfa-vbeln,
          posnn   TYPE vbfa-posnn,
          vbtyp_n TYPE vbfa-vbtyp_n,
        END OF ty_vbfa,

        BEGIN OF ty_lips,
          vbeln TYPE lips-vbeln,
          posnr TYPE lips-posnr,
          lfimg TYPE lips-lfimg,
        END OF ty_lips,

        BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          erdat TYPE vbak-erdat,
        END OF ty_vbak,

        BEGIN OF ty_vbuk,
          vbeln TYPE vbuk-vbeln,
          fkstk TYPE vbuk-fkstk,
        END OF ty_vbuk,

        BEGIN OF ty_vbkd,
          VBELN TYPE vbkd-VBELN,
          posnr TYPE vbkd-posnr,
          BSTKD TYPE vbkd-BSTKD,
        END OF ty_vbkd,

        BEGIN OF ty_final,
          kunnr  TYPE vbpa-kunnr,  "customer code
          name1  TYPE kna1-name1,  "customer name
          vbeln  TYPE vbap-vbeln,  "sales order number
          posnr  TYPE vbap-posnr,  "Sales order item
          kwmeng TYPE vbap-kwmeng, "sales order quantity
          vrkme  TYPE vbap-vrkme,
          lfdat  TYPE likp-lfdat,  "delivery date
          vbeln1 TYPE likp-vbeln,  "delivery number
          lfimg  TYPE lips-lfimg,  "delivery quantity
          lfimg1 TYPE lips-lfimg,  "sales order pending qty
          fkstk  TYPE vbuk-fkstk,
          matnr  TYPE vbap-matnr,
          tdline TYPE tdline,
          werks  TYPE vbap-werks,
          BSTKD  TYPE vbkd-BSTKD,
        END OF ty_final,

        BEGIN OF ty_ref,
          kunnr    TYPE vbpa-kunnr,  "customer code
          name1    TYPE kna1-name1,  "customer name
          vbeln    TYPE vbap-vbeln,  "sales order order
          posnr    TYPE vbap-posnr,  "Sales order item
          kwmeng   TYPE string,      "sales order quantity
          vrkme    TYPE vbap-vrkme,  "unit
          lfdat    TYPE char18,      "delivery date
          vbeln1   TYPE likp-vbeln,  "delivery number
          lfimg    TYPE string,      "delivery quantity
          lfimg1   TYPE string,       "sales order pending qty
          matnr    TYPE vbap-matnr,
          tdline   TYPE tdline,
          werks    TYPE vbap-werks,
          ref_dat  TYPE char18,      "refresh date
          ref_time TYPE char18,      "refresh time
          BSTKD    TYPE vbkd-BSTKD,
        END OF ty_ref.

DATA : lt_final TYPE TABLE OF ty_final,
       ls_final TYPE          ty_final,

       lt_ref   TYPE TABLE OF ty_ref,
       ls_ref   TYPE          ty_ref,

       lt_vbpa  TYPE TABLE OF ty_vbpa,
       ls_vbpa  TYPE          ty_vbpa,

       lt_vbap  TYPE TABLE OF ty_vbap,
       ls_vbap  TYPE          ty_vbap,

       lt_likp  TYPE TABLE OF ty_likp,
       ls_likp  TYPE          ty_likp,

       lt_lips  TYPE TABLE OF ty_lips,
       ls_lips  TYPE          ty_lips,

       lt_kna1  TYPE TABLE OF ty_kna1,
       ls_kna1  TYPE          ty_kna1,

       lt_vbak  TYPE TABLE OF ty_vbak,
       ls_vbak  TYPE          ty_vbak,

       lt_vbuk  TYPE TABLE OF ty_vbuk,
       ls_vbuk  TYPE          ty_vbuk,

       lt_vbkd  TYPE TABLE OF ty_vbkd,
       ls_vbkd  TYPE          ty_vbkd,

       lt_vbfa  TYPE TABLE OF ty_vbfa,
       ls_vbfa  TYPE          ty_vbfa.

DATA : gv_vbpa TYPE ty_vbpa.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tdline.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_so  FOR vbak-vbeln,
                 s_date FOR vbak-erdat,
                 s_plant FOR vbap-werks.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS: p_down   AS CHECKBOX,
            p_folder LIKE rlgrap-filename DEFAULT '/Delval/USA'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
*  SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.


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

  SELECT vbeln
         erdat
    FROM vbak
    INTO TABLE lt_vbak
    WHERE vbeln IN s_so AND
          erdat IN s_date.

  IF lt_vbak IS NOT INITIAL.

    SELECT vbeln
           posnr
           matnr
           kwmeng
           vrkme
           werks
        FROM vbap
        INTO TABLE lt_vbap
        FOR ALL ENTRIES IN lt_vbak
        WHERE vbeln = lt_vbak-vbeln AND
              werks IN s_plant AND
              werks IN ( 'US01' , 'US03' ) .

    SELECT VBELN
           posnr
           BSTKD FROM vbkd INTO TABLE lt_vbkd
           FOR ALL ENTRIES IN lt_vbak
           WHERE vbeln = lt_vbak-vbeln.



  ENDIF.

  IF  lt_vbap IS NOT INITIAL.

    SELECT vbeln
           posnr
           parvw
           kunnr
      FROM vbpa
      INTO TABLE lt_vbpa
      FOR ALL ENTRIES IN lt_vbap
      WHERE vbeln = lt_vbap-vbeln AND
            parvw = 'AG'      .

  ENDIF.

  IF lt_vbpa IS NOT INITIAL.

    SELECT kunnr
           name1
      FROM kna1
      INTO TABLE lt_kna1
      FOR ALL ENTRIES IN lt_vbpa
      WHERE kunnr = lt_vbpa-kunnr.

    SELECT vbelv
           posnv
           vbeln
           posnn
           vbtyp_n
      FROM vbfa
      INTO TABLE lt_vbfa
      FOR ALL ENTRIES IN lt_vbpa
      WHERE vbelv = lt_vbpa-vbeln AND
            vbtyp_n = 'J'.

  ENDIF.

  IF lt_vbfa IS NOT INITIAL.

    SELECT vbeln
           lfdat
      FROM likp
      INTO TABLE lt_likp
      FOR ALL ENTRIES IN lt_vbfa
      WHERE vbeln = lt_vbfa-vbeln.


    SELECT vbeln
           posnr
           lfimg
      FROM lips
      INTO TABLE lt_lips
      FOR ALL ENTRIES IN lt_vbfa
      WHERE vbeln = lt_vbfa-vbeln.

    SELECT vbeln
           fkstk
      FROM vbuk
      INTO TABLE lt_vbuk
      FOR ALL ENTRIES IN lt_vbfa
      WHERE vbeln = lt_vbfa-vbeln.

  ENDIF.

  IF lt_vbap IS NOT INITIAL.
    PERFORM sort_data.
    PERFORM ref_data.
    PERFORM get_fcat.
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

  LOOP AT lt_vbap INTO ls_vbap.

    ls_final-vbeln  = ls_vbap-vbeln.
    ls_final-posnr  = ls_vbap-posnr.
    ls_final-kwmeng = ls_vbap-kwmeng.
    ls_final-vrkme  = ls_vbap-vrkme.
    ls_final-matnr  = ls_vbap-matnr.
    ls_final-werks  = ls_vbap-werks.

    READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = ls_vbap-vbeln.
    IF sy-subrc = 0.
      ls_final-kunnr = ls_vbpa-kunnr.
    ENDIF.

    READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = ls_final-kunnr.
    IF sy-subrc = 0.
      ls_final-name1 = ls_kna1-name1.
    ENDIF.

    READ TABLE lt_vbfa INTO ls_vbfa WITH KEY vbelv = ls_final-vbeln
                                             posnv = ls_final-posnr
                                             vbtyp_n = 'J'.
    IF sy-subrc = 0.
      ls_final-vbeln1 = ls_vbfa-vbeln.
    ENDIF.

    READ TABLE lt_vbuk INTO ls_vbuk WITH KEY vbeln = ls_final-vbeln1.
    IF sy-subrc = 0.
      ls_final-fkstk = ls_vbuk-fkstk.
    ENDIF.

    READ TABLE lt_likp INTO ls_likp WITH KEY vbeln = ls_final-vbeln1.
    IF sy-subrc = 0.
      ls_final-lfdat = ls_likp-lfdat.
    ENDIF.

    READ TABLE lt_lips INTO ls_lips WITH KEY vbeln = ls_final-vbeln1
                                             posnr = ls_vbfa-posnn.
    IF sy-subrc = 0.
      ls_final-lfimg = ls_lips-lfimg.
    ENDIF.

    READ TABLE lt_vbkd INTO ls_vbkd WITH KEY vbeln = ls_final-vbeln.
    IF sy-subrc = 0.
      ls_final-bstkd = ls_vbkd-bstkd.
    ENDIF.

    ls_final-lfimg1 = ls_final-lfimg.
*    ls_final-pend_qty = ls_final-kwmeng - ls_final-lfimg.

    lv_name = ls_final-matnr.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = sy-langu
        name                    = lv_name
        object                  = 'MATERIAL'
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
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    LOOP AT lv_lines INTO DATA(ls_line).
      CONCATENATE ls_mattxt ls_line-tdline INTO ls_mattxt.
    ENDLOOP.

    ls_final-tdline = ls_mattxt.

    CLEAR ls_mattxt.




    APPEND ls_final TO lt_final.

    DELETE lt_final WHERE fkstk NE 'A'.
    CLEAR : ls_vbap,ls_vbpa,ls_kna1,ls_likp,ls_lips,ls_vbfa,ls_final,ls_vbak.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REF_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ref_data .

  LOOP AT lt_final INTO ls_final.

    ls_ref-kunnr      =    ls_final-kunnr.
    ls_ref-vbeln      =    ls_final-vbeln.
    ls_ref-posnr      =    ls_final-posnr.
    ls_ref-name1      =    ls_final-name1.
    ls_ref-kwmeng     =    ls_final-kwmeng.
    ls_ref-vrkme      =    ls_final-vrkme.
    ls_ref-vbeln1     =    ls_final-vbeln1.
    ls_ref-matnr      =    ls_final-matnr.
    ls_ref-tdline     =    ls_final-tdline.
    ls_ref-werks      =    ls_final-werks.
    ls_ref-bstkd      =    ls_final-bstkd.

    IF ls_final-lfdat IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-lfdat
        IMPORTING
          output = ls_ref-lfdat.

      CONCATENATE ls_ref-lfdat+0(2) ls_ref-lfdat+2(3) ls_ref-lfdat+5(4)
      INTO ls_ref-lfdat SEPARATED BY '-'.

    ENDIF.

    ls_ref-lfimg        =    ls_final-lfimg .
    ls_ref-lfimg1       =    ls_final-lfimg .
*    ls_ref-pend_qty     =    ls_final-pend_qty .


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_ref-ref_dat.

    CONCATENATE ls_ref-ref_dat+0(2) ls_ref-ref_dat+2(3) ls_ref-ref_dat+5(4)
    INTO ls_ref-ref_dat SEPARATED BY '-'.

    ls_ref-ref_time = sy-uzeit.

    CONCATENATE ls_ref-ref_time+0(2) ':' ls_ref-ref_time+2(2)  INTO ls_ref-ref_time.

    APPEND ls_ref TO lt_ref.
    CLEAR : ls_ref,ls_final.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .

  PERFORM fcat USING : '1'    'KUNNR'       'LT_FINAL'  'Customer Code'                    '15' .
  PERFORM fcat USING : '2'    'NAME1'       'LT_FINAL'  'Customer Name'                    '40' .
  PERFORM fcat USING : '3'    'VBELN'       'LT_FINAL'  'Sales order Number'               '15' .
  PERFORM fcat USING : '4'    'POSNR'       'LT_FINAL'  'Sales order Item'                 '08' .
  PERFORM fcat USING : '5'    'KWMENG'      'LT_FINAL'  'Sales Order QTY'                  '18' .
  PERFORM fcat USING : '6'    'VRKME'       'LT_FINAL'  'Unit'                             '08' .
  PERFORM fcat USING : '7'    'LFDAT'       'LT_FINAL'  'Delivery Date'                    '15' .
  PERFORM fcat USING : '8'    'VBELN1'      'LT_FINAL'  'Delivery Number'                  '15' .
  PERFORM fcat USING : '9'    'LFIMG'       'LT_FINAL'  'Delivery Qty'                     '18' .
  PERFORM fcat USING : '10'   'LFIMG1'      'LT_FINAL'  'Pending Qty'                      '18' .
  PERFORM fcat USING : '11'   'MATNR'       'LT_FINAL'  'Material No'                      '18' .
  PERFORM fcat USING : '12'   'TDLINE'      'LT_FINAL'  'Long Description'                 '132' .
  PERFORM fcat USING : '13'   'WERKS'       'LT_FINAL'  'Plant'                            '10' .
  PERFORM fcat USING : '14'   'BSTKD'       'LT_FINAL'  'Customer PO NO.'                  '15' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0784   text
*      -->P_0785   text
*      -->P_0786   text
*      -->P_0787   text
*      -->P_0788   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).

  wa_fcat-col_pos    = p1.
  wa_fcat-fieldname  = p2.
  wa_fcat-tabname    = p3.
  wa_fcat-seltext_l  = p4.
  wa_fcat-outputlen  = p5.

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

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
      is_layout          = ls_layout
      it_fieldcat        = it_fcat[]
*     IT_SORT            =
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
    TABLES
      t_outtab           = lt_final[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download_excel.
  ENDIF.


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
*  BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_ref
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
  lv_file = 'ZUS_PEND_INV.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZUS_PEND_INV Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_596 TYPE string.
DATA lv_crlf_596 TYPE string.
lv_crlf_596 = cl_abap_char_utilities=>cr_lf.
lv_string_596 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_596 lv_crlf_596 wa_csv INTO lv_string_596.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
*TRANSFER lv_string_1019 TO lv_fullfile.
TRANSFER lv_string_596 TO lv_fullfile.
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

  CONCATENATE 'Customer Code'
              'Customer Name'
              'Sales Order Number'
              'Sales Order Item'
              'Sales Order QTY'
              'Unit'
              'Delivery Date'
              'Delivery Number'
              'Delivery Qty'
              'Pending Qty'
              'Material No'
              'Long Description'
              'Plant'
              'Refresh Date'
              'Refresh Time'
              'Customer PO NO.'
  INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
