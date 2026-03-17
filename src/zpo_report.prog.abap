*&---------------------8------------------------------------------------*
*& Report ZPO_REPORT
*&---------------------------------------------------------------------*
*&Modification on 12.03.2026  - OCPL:VBK
*&Request No : DEVK942940 - GRN QTY and PO qty appeared same , which is corrected
*&---------------------------------------------------------------------*
REPORT zpo_report.

TYPE-POOLS: slis.

TABLES : ekko,ekpo,lfa1,adrc,ekbe,ekkn,vbak,mara,mseg.

TYPES : BEGIN OF ty_mseg,
          mblnr      TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          zeile      TYPE mseg-zeile,
          bwart      TYPE mseg-bwart,
          werks      TYPE mseg-werks,
          sobkz      TYPE mseg-sobkz,
          menge      TYPE mseg-menge,
          ebeln      TYPE mseg-ebeln,
          ebelp      TYPE mseg-ebelp,
          smbln      TYPE mseg-smbln,
          smblp      TYPE mseg-smblp,
          budat_mkpf TYPE mseg-budat_mkpf,
          DMBTR      TYPE DMBTR,
        END OF ty_mseg,

        BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          KUNNR TYPE vbak-kunnr,
          erdat type vbak-erdat, "changes by shreya
        END OF ty_vbak,

        BEGIN OF ty_knmt,
          kunnr type knmt-kunnr,
          kdmat type knmt-kdmat,
        END OF ty_knmt,

        BEGIN OF ty_ekpo,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          loekz TYPE ekpo-loekz,
          txz01 TYPE ekpo-txz01,
          matnr TYPE ekpo-matnr,
          werks TYPE ekpo-werks,
          menge TYPE ekpo-menge,
          elikz TYPE ekpo-elikz,
          knttp TYPE ekpo-knttp,
        END OF ty_ekpo,

        BEGIN OF ty_ekko,
          ebeln TYPE ekko-ebeln,
          aedat TYPE ekko-aedat,
          lifnr TYPE ekko-lifnr,
          ekgrp TYPE ekko-ekgrp,
        END OF ty_ekko,

        BEGIN OF ty_lfa1,
          lifnr TYPE lfa1-lifnr,
          adrnr TYPE lfa1-adrnr,
        END OF ty_lfa1,

        BEGIN OF ty_adrc,
          addrnumber TYPE adrc-addrnumber,
          name1      TYPE adrc-name1,
        END OF ty_adrc,

        BEGIN OF ty_ekkn,
          ebeln TYPE ekkn-ebeln,
          ebelp TYPE ekkn-ebelp,
          vbeln TYPE ekkn-vbeln,
          vbelp TYPE ekkn-vbelp,
        END OF ty_ekkn,

        BEGIN OF ty_final,
          ebeln      TYPE ekpo-ebeln, "PO NO
          ebelp      TYPE ekpo-ebelp, "PO Line item
          lifnr      TYPE ekko-lifnr, "Vendor Code
          name1      TYPE adrc-name1, "Vendor Name
          vbeln      TYPE ekkn-vbeln, "Sales Order No
          vbelp      TYPE ekkn-vbelp, "Line Item
          matnr      TYPE ekpo-matnr, "Material
          txz01      TYPE ekpo-txz01, "Long Text
          mblnr      TYPE mseg-mblnr,
          zeile      TYPE mseg-zeile,
          budat_mkpf TYPE mseg-budat_mkpf,
          menge      TYPE char15,
          smblp      TYPE mseg-smblp,
          kunnr     TYPE  vbak-kunnr,
          menge_po      type char15, "added by shreya 22-10-2021"
          erdat     type  vbak-erdat,
          kdmat     type  knmt-kdmat,
         DMBTR      TYPE DMBTR,
         bwart       TYPE bwart,
        END OF ty_final,

        BEGIN OF ty_down,
          ebeln      TYPE ekpo-ebeln, "PO NO
          ebelp      TYPE ekpo-ebelp, "PO Line item
          lifnr      TYPE ekko-lifnr, "Vendor Code
          name1      TYPE adrc-name1, "Vendor Name
          vbeln      TYPE ekkn-vbeln, "Sales Order No
          vbelp      TYPE ekkn-vbelp, "Line Item
          matnr      TYPE ekpo-matnr, "Material
          txz01      TYPE ekpo-txz01, "Long Text
          mblnr      TYPE mseg-mblnr,
          zeile      TYPE mseg-zeile,
          budat_mkpf TYPE string,
          menge      TYPE string,
          ref_dat    TYPE char15,     "Refresh Date
          ref_time   TYPE char15,     "Refresh Time
          kunnr      TYPE vbak-kunnr, " customer code added by shreya
          menge_po   type char15, "added by shreya 22-10-2021"
          erdat      type char15,
          kdmat      TYPE char15,
          DMBTR      TYPE char25,
          bwart       TYPE bwart,
        END OF ty_down.

DATA : lt_ekpo  TYPE TABLE OF ty_ekpo,
       ls_ekpo  TYPE          ty_ekpo,

       lt_ekko  TYPE TABLE OF ty_ekko,
       ls_ekko  TYPE          ty_ekko,

       lt_ekkn  TYPE TABLE OF ty_ekkn,
       ls_ekkn  TYPE          ty_ekkn,

       lt_vbak TYPE TABLE OF ty_vbak,
       ls_vbak TYPE          ty_vbak,

       lt_knmt TYPE TABLE OF ty_knmt,
       ls_knmt type ty_knmt,

       lt_lfa1  TYPE TABLE OF ty_lfa1,
       ls_lfa1  TYPE          ty_lfa1,

       lt_adrc  TYPE TABLE OF ty_adrc,
       ls_adrc  TYPE          ty_adrc,

       lt_final TYPE TABLE OF ty_final,
       ls_final TYPE          ty_final,

       lt_down  TYPE TABLE OF ty_down,
       ls_down  TYPE          ty_down,

       lt_mseg  TYPE TABLE OF ty_mseg,
       ls_mseg  TYPE          ty_mseg,

       lt_mseg1 TYPE TABLE OF ty_mseg,
       ls_mseg1 TYPE          ty_mseg.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_lifnr  FOR mseg-lifnr DEFAULT 0000100063,
                 s_date   FOR mseg-budat_mkpf.
PARAMETERS     : p_plant TYPE ekpo-werks OBLIGATORY DEFAULT 'PL01'.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.


SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
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

  SELECT mblnr
         mjahr
         zeile
         bwart
         werks
         sobkz
         menge
         ebeln
         ebelp
         smbln
         smblp
         budat_mkpf
         DMBTR
    FROM mseg
    INTO TABLE lt_mseg
    WHERE werks = p_plant AND
          budat_mkpf IN s_date AND
          lifnr IN s_lifnr AND
          bwart IN ( '101' , '102' ) AND
          sobkz = 'E'.

  IF lt_mseg IS NOT INITIAL.

    SELECT ebeln
           ebelp
           loekz
           txz01
           matnr
           werks
           menge
           elikz
           knttp
      FROM ekpo
      INTO TABLE lt_ekpo
      FOR ALL ENTRIES IN lt_mseg[]
      WHERE ebeln = lt_mseg-ebeln AND
            ebelp = lt_mseg-ebelp AND
            loekz = ' ' AND
            werks = p_plant AND
            knttp = 'E'.

  ENDIF.

  IF lt_ekpo IS  NOT INITIAL.

    SELECT ebeln
           aedat
           lifnr
           ekgrp
      FROM ekko
      INTO TABLE lt_ekko[]
      FOR ALL ENTRIES IN lt_ekpo
      WHERE ebeln = lt_ekpo-ebeln.

    SELECT ebeln
    ebelp
    vbeln
    vbelp
    FROM ekkn
    INTO TABLE lt_ekkn
    FOR ALL ENTRIES IN lt_ekpo
    WHERE ebeln = lt_ekpo-ebeln AND
    ebelp = lt_ekpo-ebelp.

    if lt_ekkn is not INITIAL.

    SELECT vbeln
           kunnr
           erdat
    FROM vbak
    into table lt_vbak
    FOR ALL ENTRIES IN lt_ekkn
    where vbeln = lt_ekkn-vbeln.

    endif.

    if lt_vbak[] is NOT INITIAL.
      SELECT KUNNR
             kdmat
      from   knmt
      into table lt_knmt
      FOR ALL ENTRIES IN lt_vbak
      where kunnr = lt_vbak-kunnr.
    endif.


    SELECT mblnr
    mjahr
    zeile
    bwart
    werks
    sobkz
    menge
    ebeln
    ebelp
    smbln
    smblp
    budat_mkpf
    DMBTR
    FROM mseg
    INTO TABLE lt_mseg1
    FOR ALL ENTRIES IN lt_ekpo
    WHERE ebeln = lt_ekpo-ebeln AND
          ebelp = lt_ekpo-ebelp AND
          werks = p_plant AND
          budat_mkpf IN s_date AND
          lifnr IN s_lifnr AND
          bwart IN ( '101' , '102' ) AND
         sobkz = 'E'.

  ENDIF.

  IF lt_ekko IS NOT INITIAL.

    SELECT lifnr
    adrnr
    FROM lfa1
    INTO TABLE lt_lfa1
    FOR ALL ENTRIES IN lt_ekko
    WHERE lifnr = lt_ekko-lifnr.

  ENDIF.

  IF lt_lfa1 IS NOT INITIAL.

    SELECT addrnumber
    name1
    FROM adrc
    INTO TABLE lt_adrc
    FOR ALL ENTRIES IN lt_lfa1
    WHERE addrnumber = lt_lfa1-adrnr.

  ENDIF.

  IF lt_ekpo IS NOT INITIAL.
    PERFORM sort_data.
    PERFORM get_fcat.
    PERFORM display.
*    PERFORM download.
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

  LOOP AT lt_mseg1 INTO ls_mseg1.

*    IF ls_mseg1-mblnr NE ls_mseg1-smbln.
    IF ls_mseg1-smbln = ' '.
      ls_final-DMBTR      = ls_mseg1-DMBTR.
      ls_final-mblnr      = ls_mseg1-mblnr.
      ls_final-budat_mkpf = ls_mseg1-budat_mkpf.
      ls_final-zeile      = ls_mseg1-zeile.
      CALL FUNCTION 'ROUND'
        EXPORTING
*         DECIMALS            = 0
          input               = ls_mseg1-menge
*         SIGN                = ' '
       IMPORTING
         OUTPUT              = ls_mseg1-menge
*       EXCEPTIONS
*         INPUT_INVALID       = 1
*         OVERFLOW            = 2
*         TYPE_INVALID        = 3
*         OTHERS              = 4
                .
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      ls_final-menge      = ls_mseg1-menge.
      SHIFT ls_final-menge RIGHT DELETING TRAILING '0'.
      ls_final-ebeln      = ls_mseg1-ebeln.
      ls_final-ebelp      = ls_mseg1-ebelp.

      READ TABLE lt_ekpo INTO ls_ekpo WITH KEY ebeln = ls_mseg1-ebeln
                                               ebelp = ls_mseg1-ebelp.
      IF sy-subrc = 0.
        ls_final-matnr = ls_ekpo-matnr.
        ls_final-txz01 = ls_ekpo-txz01.
        CALL FUNCTION 'ROUND'
          EXPORTING
*           DECIMALS            = 0
            input               = ls_ekpo-menge
*           SIGN                = ' '
         IMPORTING
           OUTPUT              = ls_ekpo-menge
*         EXCEPTIONS
*           INPUT_INVALID       = 1
*           OVERFLOW            = 2
*           TYPE_INVALID        = 3
*           OTHERS              = 4
                  .
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

***----Commented by VBK on 12.03.2026 --- as GRN qty is same as PO qty - which is wrong. -
*        ls_final-menge = ls_ekpo-menge.
        SHIFT ls_final-menge RIGHT DELETING TRAILING '0'.

        ls_final-menge_po = ls_ekpo-menge.
        SHIFT ls_final-menge_po RIGHT DELETING TRAILING '0'.
      ENDIF.

      READ TABLE lt_ekko INTO ls_ekko WITH KEY ebeln = ls_final-ebeln .
      IF sy-subrc = 0.
        ls_final-lifnr  = ls_ekko-lifnr.
      ENDIF.
      READ TABLE lt_lfa1 INTO ls_lfa1 WITH KEY lifnr = ls_final-lifnr.

      IF sy-subrc = 0.

        READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_lfa1-adrnr.
        IF sy-subrc = 0.
          ls_final-name1 = ls_adrc-name1.

        ENDIF.

      ENDIF.

      READ TABLE lt_ekkn INTO ls_ekkn WITH KEY ebeln = ls_final-ebeln
      ebelp = ls_ekpo-ebelp.
      IF sy-subrc = 0.
        ls_final-vbeln = ls_ekkn-vbeln.
        ls_final-vbelp = ls_ekkn-vbelp.

      ENDIF.

      READ TABLE lt_vbak into ls_vbak with key vbeln = ls_final-vbeln.
      if sy-subrc = 0.
        ls_final-kunnr = ls_vbak-kunnr.
         ls_final-erdat = ls_vbak-erdat.
      endif.

     " APPEND ls_final TO lt_final.

     READ TABLE lt_knmt INTO ls_knmt with key KUNNR = ls_vbak-KUNNR.
      if sy-subrc = 0.
        "ls_final-kunnr = ls_vbak-kunnr.
         ls_final-kdmat = ls_knmt-kdmat.
      endif.
     ls_final-bwart = ls_mseg1-bwart.
    append ls_final to lt_final.

      CLEAR : ls_final,ls_mseg1,ls_ekko,ls_ekpo,ls_lfa1,ls_adrc,ls_ekkn, ls_vbak.



    ELSE.
      DATA : gv_smbln TYPE mseg-smbln,
             gv_smblp TYPE mseg-smblp.
      gv_smbln = ls_mseg1-smbln.
      gv_smblp = ls_mseg1-smblp.
    ENDIF.

    DELETE lt_final WHERE mblnr = gv_smbln AND zeile = gv_smblp.

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

  PERFORM fcatlog USING : '1'    'EBELN'       'LT_FINAL'  'PO NO'             '18' ''.
  PERFORM fcatlog USING : '2'    'EBELP'       'LT_FINAL'  'PO Line Item'      '18' ''.
  PERFORM fcatlog USING : '3'    'LIFNR'       'LT_FINAL'  'Vendor Code'       '18' ''.
  PERFORM fcatlog USING : '4'    'NAME1'       'LT_FINAL'  'Vendor Name'       '40' ''.
  PERFORM fcatlog USING : '5'    'VBELN'       'LT_FINAL'  'Sale Order No'     '18' ''.
  PERFORM fcatlog USING : '6'    'VBELP'       'LT_FINAL'  'Line Item'         '18' ''.
  PERFORM fcatlog USING : '7'    'MATNR'       'LT_FINAL'  'Material'          '18' ''.
  PERFORM fcatlog USING : '8'    'TXZ01'       'LT_FINAL'  'Item Description'  '40' ''.
  PERFORM fcatlog USING : '9'    'MBLNR'       'LT_FINAL'  'GRN No.'           '18' ''.
  PERFORM fcatlog USING : '10'   'ZEILE'       'LT_FINAL'  'GRN Line Item.'    '10' ''.
  PERFORM fcatlog USING : '11'   'BUDAT_MKPF'  'LT_FINAL'  'GRN Date'          '18' ''.
  PERFORM fcatlog USING : '12'   'MENGE'       'LT_FINAL'  'Quantity'          '20' '0'.
  PERFORM fcatlog USING : '13'   'KUNNR'       'LT_FINAL'  'Customer Code'     '20' ''.
  PERFORM fcatlog USING : '14'   'MENGE_PO'    'LT_FINAL'  'PO Quantity'       '20' '0'.
  PERFORM fcatlog USING : '15'   'ERDAT'       'LT_FINAL'  'Sales Ord Date'    '20' ''.
  PERFORM fcatlog USING : '16'   'KDMAT'       'LT_FINAL'  'Customer Item Code' '20' ''.
  PERFORM fcatlog USING : '16'   'DMBTR'       'LT_FINAL'  'GRN Basic Value'    '20' ''.
  PERFORM fcatlog USING : '16'   'BWART'       'LT_FINAL'  'Movement Type'    '20' ''.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fcatlog USING    VALUE(p1)
      VALUE(p2)
      VALUE(p3)
      VALUE(p4)
      VALUE(p5)
      VALUE(p6).
      "VALUE(p7).


  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.
  wa_fcat-DECIMALS_OUT = p6.


  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat..

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

  LOOP AT lt_final INTO ls_final.

    ls_down-mblnr      = ls_final-mblnr.
    ls_down-menge      = ls_final-menge.
    ls_down-ebeln      = ls_final-ebeln.
    ls_down-ebelp      = ls_final-ebelp.
    ls_down-matnr      = ls_final-matnr.
    ls_down-txz01      = ls_final-txz01.
    ls_down-lifnr      = ls_final-lifnr.
    ls_down-name1      = ls_final-name1.
    ls_down-vbeln      = ls_final-vbeln.
    ls_down-vbelp      = ls_final-vbelp.
    ls_down-zeile      = ls_final-zeile.
    ls_down-kunnr      = ls_final-kunnr.
    ls_down-menge_po   = ls_final-menge_po.
    ls_down-erdat     = ls_final-erdat.
    ls_down-kdmat     = ls_final-kdmat.
    ls_down-DMBTR     = ls_final-DMBTR.
    CONDENSE: ls_down-DMBTR .
    IF ls_final-budat_mkpf IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-budat_mkpf
        IMPORTING
          output = ls_down-budat_mkpf.

      CONCATENATE ls_down-budat_mkpf+0(2) ls_down-budat_mkpf+2(3) ls_down-budat_mkpf+5(4)
      INTO ls_down-budat_mkpf SEPARATED BY '-'.

    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_down-ref_dat.

    CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
    INTO ls_down-ref_dat SEPARATED BY '-'.

    ls_down-ref_time = sy-uzeit.
    CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  INTO ls_down-ref_time.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_down-erdat.

    CONCATENATE ls_down-erdat+0(2) ls_down-erdat+2(3) ls_down-erdat+5(4)
    INTO ls_down-erdat SEPARATED BY '-'.

     ls_down-bwart = ls_final-bwart.
    APPEND ls_down TO lt_down.
    CLEAR : ls_down,ls_final.

  ENDLOOP.

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
      t_outtab           = lt_final[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download.
    PERFORM download_excel.
*    PERFORM download.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*

                                      .
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
      i_tab_sap_data       = lt_down
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
  lv_file = 'ZBHARAT_GRN.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
  BREAK primus.
  WRITE: / 'ZBHARAT_GRN Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_665 TYPE string.
DATA lv_crlf_665 TYPE string.
lv_crlf_665 = cl_abap_char_utilities=>cr_lf.
lv_string_665 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_665 lv_crlf_665 wa_csv INTO lv_string_665.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_669 TO lv_fullfile.
TRANSFER lv_string_665 TO lv_fullfile.
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

  CONCATENATE 'PO NO'
              'PO Line Item'
              'Vendor Code'
              'Vendor Name'
              'Sale Order No'
              'Line Item'
              'Material'
              'Item Description'
              'GRN No.'
              'GRN Line Item'
              'GRN Date'
              'Quantity'
              'Refresh Date'
              'Refresh Time'
              'Customer Code'
              'PO Quantity'
              'Sales Ord Date'
              'Customer Item Code'
              'GRN Basic Value'
              'Movement type'

    INTO p_hd_csv
    SEPARATED BY l_field_seperator.


ENDFORM.
