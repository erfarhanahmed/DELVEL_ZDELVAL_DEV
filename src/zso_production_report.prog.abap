*&---------------------------------------------------------------------*
*& Report ZSO_PRODUCTION_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zso_production_report.

TYPE-POOLS: slis.

TABLES : vbak,vbap,afpo,aufk,jest,kna1,afko,afru,qals,qamb.

TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          erdat TYPE vbak-erdat,
          vbtyp TYPE vbak-vbtyp,
          vdatu TYPE vbak-vdatu,
          kunnr TYPE vbak-kunnr,
        END OF ty_vbak,

        BEGIN OF ty_vbap,
          vbeln  TYPE vbap-vbeln,
          posnr  TYPE vbap-posnr,
          matnr  TYPE vbap-matnr,
          arktx  TYPE vbap-arktx,
          abgru  TYPE vbap-abgru,
          kwmeng TYPE vbap-kwmeng,
          werks  TYPE vbap-werks,
        END OF ty_vbap,

        BEGIN OF ty_afpo,
          aufnr TYPE afpo-aufnr,
          posnr TYPE afpo-posnr,
          strmp TYPE afpo-strmp,
          kdauf TYPE afpo-kdauf,
          kdpos TYPE afpo-kdpos,
          matnr TYPE afpo-matnr,
        END OF ty_afpo,

        BEGIN OF ty_aufk,
          aufnr TYPE aufk-aufnr,
          objnr TYPE aufk-objnr,
        END OF ty_aufk,

        BEGIN OF ty_jest,
          objnr TYPE jest-objnr,
          stat  TYPE jest-stat,
        END OF ty_jest,

        BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
        END OF ty_kna1,

        BEGIN OF ty_afko,
          aufnr TYPE afko-aufnr,
          gamng TYPE afko-gamng,
        END OF ty_afko,

        BEGIN OF ty_afru,
          rueck TYPE afru-rueck,
          rmzhl TYPE afru-rmzhl,
          gmnga TYPE afru-gmnga,
          aufnr TYPE afru-aufnr,
          stokz TYPE afru-stokz,
          stzhl TYPE afru-stzhl,
        END OF ty_afru,

        BEGIN OF ty_vbep,
          vbeln TYPE vbep-vbeln,
          posnr TYPE vbep-posnr,
          edatu TYPE vbep-edatu,
        END OF ty_vbep,

        BEGIN OF ty_qals,
          prueflos  TYPE qals-prueflos,
          werk      TYPE qals-werk,
          objnr     TYPE qals-objnr,
          aufnr     TYPE qals-aufnr,
          matnr     TYPE qals-matnr,
          ersteldat TYPE qals-ersteldat,
        END OF ty_qals,

        BEGIN OF ty_qamb,
          prueflos TYPE qamb-prueflos,
          zaehler  TYPE qamb-zaehler,
          typ      TYPE qamb-typ,
          mblnr    TYPE qamb-mblnr,
          mjahr    TYPE qamb-mjahr,
        END OF ty_qamb,

        BEGIN OF ty_mseg,
          mblnr      TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          xauto      TYPE mseg-xauto,
          budat_mkpf TYPE mseg-budat_mkpf,
        END OF ty_mseg,

        BEGIN OF ty_final,
          aufnr      TYPE afpo-aufnr,
          strmp      TYPE afpo-strmp,
          kdauf      TYPE afpo-kdauf,
          kdpos      TYPE afpo-kdpos,
          erdat      TYPE vbak-erdat,
          edatu      TYPE vbep-edatu,
          vdatu      TYPE vbak-vdatu,
          kunnr      TYPE kna1-kunnr,
          name1      TYPE kna1-name1,
          matnr      TYPE vbap-matnr,
          arktx      TYPE vbap-arktx,
          gamng      TYPE afko-gamng,
          gmnga      TYPE afru-gmnga,
          ersteldat  TYPE qals-ersteldat,
          kwmeng     TYPE vbap-kwmeng,
          stat       TYPE jest-stat,
          stat1      TYPE jest-stat,
          matnr1     TYPE vbap-matnr,
          budat_mkpf TYPE mseg-budat_mkpf,
          prueflos   TYPE qals-prueflos,
        END OF ty_final,

        BEGIN OF ty_ref,
          aufnr      TYPE afpo-aufnr,
          strmp      TYPE char18,
          kdauf      TYPE afpo-kdauf,
          kdpos      TYPE afpo-kdpos,
          erdat      TYPE char18,
          edatu      TYPE char18,
          vdatu      TYPE char18,
          kunnr      TYPE kna1-kunnr,
          name1      TYPE kna1-name1,
          matnr      TYPE vbap-matnr,
          arktx      TYPE vbap-arktx,
          gamng      TYPE string,
          gmnga      TYPE string,
          ersteldat  TYPE char18,
          kwmeng     TYPE string,
          matnr1     TYPE vbap-matnr,
          budat_mkpf TYPE char18,
          ref_dat    TYPE char15,  "Refresh Date
          ref_time   TYPE char15,  "Refresh Time
        END OF ty_ref.

DATA : lt_final TYPE TABLE OF ty_final,
       ls_final TYPE          ty_final,

       lt_ref   TYPE TABLE OF ty_ref,
       ls_ref   TYPE          ty_ref,

       lt_vbep  TYPE TABLE OF ty_vbep,
       ls_vbep  TYPE          ty_vbep,

       lt_afru  TYPE TABLE OF ty_afru,
       ls_afru  TYPE          ty_afru,

       lt_afko  TYPE TABLE OF ty_afko,
       ls_afko  TYPE          ty_afko,

       lt_afpo  TYPE TABLE OF ty_afpo,
       ls_afpo  TYPE          ty_afpo,

       lt_kna1  TYPE TABLE OF ty_kna1,
       ls_kna1  TYPE          ty_kna1,

       lt_vbak  TYPE TABLE OF ty_vbak,
       ls_vbak  TYPE          ty_vbak,

       lt_vbap  TYPE TABLE OF ty_vbap,
       ls_vbap  TYPE          ty_vbap,

       lt_jest  TYPE TABLE OF ty_jest,
       ls_jest  TYPE          ty_jest,

       lt_jest1 TYPE TABLE OF ty_jest,
       ls_jest1 TYPE          ty_jest,

       lt_aufk  TYPE TABLE OF ty_aufk,
       ls_aufk  TYPE          ty_aufk,

       lt_qals  TYPE TABLE OF ty_qals,
       ls_qals  TYPE          ty_qals,

       lt_qamb  TYPE TABLE OF ty_qamb,
       ls_qamb  TYPE          ty_qamb,

       lt_mseg  TYPE TABLE OF ty_mseg,
       ls_mseg  TYPE          ty_mseg.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA : ls_layout TYPE slis_layout_alv.

DATA : gv_stat TYPE jest-stat.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_sono FOR vbak-vbeln,
                 s_date FOR vbak-erdat OBLIGATORY,
                 s_plant FOR vbap-werks.
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

  SELECT vbeln
         erdat
         vbtyp
         vdatu
         kunnr
    FROM vbak
    INTO TABLE lt_vbak
    WHERE vbeln IN s_sono AND
          erdat IN s_date.

  IF lt_vbak IS NOT INITIAL.

    SELECT vbeln
           posnr
           matnr
           arktx
           abgru
           kwmeng
           werks
      FROM vbap
      INTO TABLE lt_vbap
      FOR ALL ENTRIES IN lt_vbak
      WHERE vbeln = lt_vbak-vbeln AND
            werks = 'PL01' AND
            abgru = ' '.

    SELECT kunnr
           name1
      FROM kna1
      INTO TABLE lt_kna1
      FOR ALL ENTRIES IN lt_vbak
      WHERE kunnr = lt_vbak-kunnr.

  ENDIF.

  IF lt_vbap IS NOT INITIAL.

    SELECT aufnr
           posnr
           strmp
           kdauf
           kdpos
           matnr
      FROM afpo
      INTO TABLE lt_afpo
      FOR ALL ENTRIES IN lt_vbap
      WHERE kdauf = lt_vbap-vbeln AND
            kdpos = lt_vbap-posnr.

  ENDIF.

  IF lt_afpo IS NOT INITIAL.

    SELECT aufnr
           objnr
      FROM aufk
      INTO TABLE lt_aufk
      FOR ALL ENTRIES IN lt_afpo
      WHERE aufnr = lt_afpo-aufnr.

    SELECT vbeln
             posnr
             edatu
        FROM vbep
        INTO TABLE lt_vbep
        FOR ALL ENTRIES IN lt_afpo
        WHERE vbeln = lt_afpo-kdauf AND
              posnr = lt_afpo-kdpos.

    SELECT aufnr
              gamng
         FROM afko
         INTO TABLE lt_afko
         FOR ALL ENTRIES IN lt_afpo
         WHERE aufnr = lt_afpo-aufnr.

    SELECT rueck
           rmzhl
           gmnga
           aufnr
           stokz
           stzhl
      FROM afru
      INTO TABLE lt_afru
      FOR ALL ENTRIES IN lt_afpo
      WHERE aufnr = lt_afpo-aufnr AND
            stokz = ' ' AND
            stzhl = ' '.


  ENDIF.

  IF lt_aufk IS NOT INITIAL.

    SELECT objnr
           stat
      FROM jest
      INTO TABLE lt_jest
      FOR ALL ENTRIES IN lt_aufk
      WHERE  objnr = lt_aufk-objnr.

  ENDIF.

  IF lt_afpo IS NOT   INITIAL.
    SELECT prueflos
           werk
           objnr
           aufnr
           matnr
       ersteldat
      FROM qals
      INTO TABLE lt_qals
      FOR ALL ENTRIES IN lt_afpo
      WHERE werk = 'PL01' AND
            aufnr = lt_afpo-aufnr.
  ENDIF.

  IF lt_qals IS NOT INITIAL.

    SELECT objnr
    stat
    FROM jest
    INTO TABLE lt_jest1
    FOR ALL ENTRIES IN lt_qals
    WHERE  objnr = lt_qals-objnr.


    SELECT prueflos
           zaehler
           typ
           mblnr
           mjahr
      FROM qamb
      INTO TABLE lt_qamb
      FOR ALL ENTRIES IN lt_qals
      WHERE prueflos = lt_qals-prueflos AND
            typ      = '3'.

  ENDIF.

  IF lt_qamb IS NOT INITIAL.

    SELECT mblnr
           mjahr
           xauto
           budat_mkpf
      FROM mseg
      INTO TABLE lt_mseg
      FOR ALL ENTRIES IN lt_qamb
      WHERE mblnr = lt_qamb-mblnr AND
            mjahr = lt_qamb-mjahr AND
            xauto = ' '.

  ENDIF.

  IF lt_vbap IS NOT INITIAL.

    PERFORM sort_data.
    PERFORM get_fcat.
    PERFORM sort_ref.
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
*  BREAK primus.
  LOOP AT lt_afpo INTO ls_afpo.

    ls_final-aufnr = ls_afpo-aufnr.
    ls_final-strmp = ls_afpo-strmp.
    ls_final-kdauf = ls_afpo-kdauf.
    ls_final-kdpos = ls_afpo-kdpos.
    ls_final-matnr1 = ls_afpo-matnr.

    READ TABLE lt_aufk INTO ls_aufk WITH KEY aufnr = ls_afpo-aufnr.
    IF sy-subrc = 0.
      READ TABLE lt_jest INTO ls_jest WITH KEY objnr = ls_aufk-objnr.
      IF sy-subrc = 0.
        ls_final-stat = ls_jest-stat.
      ENDIF.
    ENDIF.

    READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_final-kdauf.
    IF sy-subrc = 0.
      ls_final-erdat = ls_vbak-erdat.
      ls_final-vdatu = ls_vbak-vdatu.
      ls_final-kunnr = ls_vbak-kunnr.
    ENDIF.

    READ TABLE lt_vbep INTO ls_vbep WITH KEY vbeln = ls_final-kdauf
                                             posnr = ls_afpo-kdpos.

    IF sy-subrc = 0.
      ls_final-edatu = ls_vbep-edatu.
    ENDIF.

    READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = ls_final-kunnr.
    IF sy-subrc = 0.
      ls_final-name1 = ls_kna1-name1.
    ENDIF.

    READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = ls_final-kdauf
                                             posnr = ls_afpo-kdpos.
    IF sy-subrc = 0.
      ls_final-matnr = ls_vbap-matnr.
      ls_final-arktx = ls_vbap-arktx.
      ls_final-kwmeng = ls_vbap-kwmeng.
    ENDIF.

    READ TABLE lt_afko INTO ls_afko WITH KEY aufnr = ls_final-aufnr.
    IF sy-subrc = 0.
      ls_final-gamng = ls_afko-gamng.
    ENDIF.

    LOOP AT lt_afru INTO ls_afru WHERE aufnr = ls_final-aufnr.
      ls_final-gmnga = ls_final-gmnga + ls_afru-gmnga.
    ENDLOOP.

    LOOP AT lt_qals INTO ls_qals WHERE werk = ls_vbap-werks AND
                                       aufnr = ls_final-aufnr.
      LOOP AT lt_jest1 INTO ls_jest1 WHERE objnr = ls_qals-objnr .
        IF ls_jest1-stat = 'I0224'.
          gv_stat = 'I0224'.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF gv_stat IS INITIAL.
        ls_final-ersteldat = ls_qals-ersteldat.
        ls_final-prueflos  = ls_qals-prueflos.
      ENDIF.
      CLEAR : gv_stat.
    ENDLOOP.

    READ TABLE lt_qamb INTO ls_qamb WITH KEY prueflos = ls_final-prueflos
                                              typ     = '3'.
    IF sy-subrc = 0.
      READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_qamb-mblnr
                                               mjahr = ls_qamb-mjahr
                                               xauto = ' '.
      IF sy-subrc = 0.
        ls_final-budat_mkpf = ls_mseg-budat_mkpf.
      ENDIF.
    ENDIF.

    APPEND ls_final TO lt_final.
    DELETE lt_final WHERE stat = 'I0013'.

    CLEAR : ls_final,ls_qals,ls_vbap,ls_vbak,ls_vbep,ls_kna1,ls_afpo,ls_afko,ls_afru,ls_aufk,ls_jest,ls_qamb,ls_mseg.
  ENDLOOP.

  SORT lt_final BY kdauf kdpos.
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

  PERFORM fcat USING : '1'    'AUFNR'       'LT_FINAL'  'Production Order Number'               '18' .
  PERFORM fcat USING : '2'    'STRMP'       'LT_FINAL'  'Production Order Date'                 '18' .
  PERFORM fcat USING : '3'    'KDAUF'       'LT_FINAL'  'Sales Order'                           '18' .
  PERFORM fcat USING : '4'    'KDPOS'       'LT_FINAL'  'Sales Order Line Item'                 '10' .
  PERFORM fcat USING : '5'    'ERDAT'       'LT_FINAL'  'Sales Order Date'                      '18' .
  PERFORM fcat USING : '6'    'EDATU'       'LT_FINAL'  'Delivery Date(Line Item)'              '18' .
  PERFORM fcat USING : '7'    'VDATU'       'LT_FINAL'  'Delivery Date Header'                  '18' .
  PERFORM fcat USING : '8'    'KUNNR'       'LT_FINAL'  'Customer Code'                         '18' .
  PERFORM fcat USING : '9'    'NAME1'       'LT_FINAL'  'Customer Name'                         '40' .
  PERFORM fcat USING : '10'   'MATNR'       'LT_FINAL'  'Item Code(SO)'                         '18' .
  PERFORM fcat USING : '11'   'ARKTX'       'LT_FINAL'  'Item Description'                      '45' .
  PERFORM fcat USING : '12'   'GAMNG'       'LT_FINAL'  'Production Order Quantity'             '18' .
  PERFORM fcat USING : '13'   'GMNGA'       'LT_FINAL'  'Production Order Confirmed Quantity'   '18' .
  PERFORM fcat USING : '14'   'ERSTELDAT'   'LT_FINAL'  'Confirmed Date'                        '18' .
  PERFORM fcat USING : '15'   'KWMENG'      'LT_FINAL'  'SO Quantity'                           '18' .
  PERFORM fcat USING : '16'   'MATNR1'      'LT_FINAL'  'Production Order Confirmed Item'       '18' .
  PERFORM fcat USING : '17'   'BUDAT_MKPF'  'LT_FINAL'  'Inspection Date'                       '18' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0832   text
*      -->P_0833   text
*      -->P_0834   text
*      -->P_0835   text
*      -->P_0836   text
*----------------------------------------------------------------------*
FORM fcat  USING   VALUE(p1)
      VALUE(p2)
      VALUE(p3)
      VALUE(p4)
      VALUE(p5).

  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
  wa_fcat-outputlen = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort_ref.

  LOOP AT lt_final INTO ls_final.

    ls_ref-aufnr = ls_final-aufnr.
    ls_ref-kdauf =  ls_final-kdauf.
    ls_ref-kdpos = ls_final-kdpos.
    ls_ref-kunnr =  ls_final-kunnr.
    ls_ref-name1 = ls_final-name1.
    ls_ref-matnr  = ls_final-matnr .
    ls_ref-arktx  =  ls_final-arktx .
    ls_ref-kwmeng =  ls_final-kwmeng.
    ls_ref-gamng = ls_final-gamng.
    ls_ref-gmnga = ls_final-gmnga.
    ls_ref-matnr1 = ls_final-matnr1.

    IF ls_final-erdat IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-erdat
        IMPORTING
          output = ls_ref-erdat.

      CONCATENATE ls_ref-erdat+0(2) ls_ref-erdat+2(3) ls_ref-erdat+5(4)
      INTO ls_ref-erdat SEPARATED BY '-'.

    ENDIF.

    IF ls_final-strmp IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-strmp
        IMPORTING
          output = ls_ref-strmp.

      CONCATENATE ls_ref-strmp+0(2) ls_ref-strmp+2(3) ls_ref-strmp+5(4)
      INTO ls_ref-strmp SEPARATED BY '-'.

    ENDIF.

    IF ls_final-vdatu IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-vdatu
        IMPORTING
          output = ls_ref-vdatu.

      CONCATENATE ls_ref-vdatu+0(2) ls_ref-vdatu+2(3) ls_ref-vdatu+5(4)
      INTO ls_ref-vdatu SEPARATED BY '-'.
    ENDIF.

    IF ls_final-edatu IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-edatu
        IMPORTING
          output = ls_ref-edatu.

      CONCATENATE ls_ref-edatu+0(2) ls_ref-edatu+2(3) ls_ref-edatu+5(4)
      INTO ls_ref-edatu SEPARATED BY '-'.
    ENDIF.


    IF ls_final-ersteldat IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-ersteldat
        IMPORTING
          output = ls_ref-ersteldat.

      CONCATENATE ls_ref-ersteldat+0(2) ls_ref-ersteldat+2(3) ls_ref-ersteldat+5(4)
      INTO ls_ref-ersteldat SEPARATED BY '-'.
    ENDIF.

    IF ls_final-budat_mkpf IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-budat_mkpf
        IMPORTING
          output = ls_ref-budat_mkpf.

      CONCATENATE ls_ref-budat_mkpf+0(2) ls_ref-budat_mkpf+2(3) ls_ref-budat_mkpf+5(4)
      INTO ls_ref-budat_mkpf SEPARATED BY '-'.
    ENDIF.

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
  lv_file = 'ZSO_QADATE.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
*  BREAK primus.
  WRITE: / 'ZSO_QADATE Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_742 TYPE string.
DATA lv_crlf_742 TYPE string.
lv_crlf_742 = cl_abap_char_utilities=>cr_lf.
lv_string_742 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_742 lv_crlf_742 wa_csv INTO lv_string_742.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
*TRANSFER lv_string_669 TO lv_fullfile.
TRANSFER lv_string_742 TO lv_fullfile.
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

  CONCATENATE 'Production Order Number'
              'Production Order Date'
              'Sales Order'
              'Sales Order Line Item'
              'Sales Order Date'
              'Delivery Date(Line Item)'
              'Delivery Date Header'
              'Customer Code'
              'Customer Name'
              'Item Code(SO)'
              'Item Description'
              'Production Order Quantity'
              'Production Order Confirmed Quantity'
              'Confirmed Date'
              'SO Quantity'
              'Production Order Confirmed Item'
              'Inspection Date'
              'Refresh Date'
              'Refresh Time'

  INTO p_hd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
