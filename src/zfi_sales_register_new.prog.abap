*&---------------------------------------------------------------------*
*& Report ZFI_SALES_REGISTER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi_sales_register_new.
TYPE-POOLS:slis.
TABLES bkpf.
DATA:
  tmp_belnr TYPE bkpf-belnr,
  tmp_budat TYPE bkpf-budat,
  tmp_gjahr TYPE bkpf-gjahr.

TYPES:
  BEGIN OF t_accounting_doc_hdr,
    bukrs TYPE bkpf-bukrs,
    belnr TYPE bkpf-belnr,
    gjahr TYPE bkpf-gjahr,
    blart TYPE bkpf-blart,
    budat TYPE bkpf-budat,
    xblnr TYPE bkpf-xblnr,
    bktxt TYPE bkpf-bktxt,
    waers TYPE bkpf-waers,
    kursf TYPE bkpf-kursf,
    STBLG TYPE BKPF-STBLG,

  END OF t_accounting_doc_hdr,
  tt_accounting_doc_hdr TYPE STANDARD TABLE OF t_accounting_doc_hdr.

TYPES:
  BEGIN OF t_accounting_doc_item,
    bukrs   TYPE bseg-bukrs,
    belnr   TYPE bseg-belnr,
    gjahr   TYPE bseg-gjahr,
    buzei   TYPE bseg-buzei,
    buzid   TYPE bseg-buzid,
    shkzg   TYPE bseg-shkzg,
    mwskz   TYPE bseg-mwskz,
    dmbtr   TYPE bseg-dmbtr,
    wrbtr   TYPE bseg-wrbtr,
    txgrp   TYPE bseg-txgrp,
    ktosl   TYPE bseg-ktosl,
    zuonr   TYPE bseg-zuonr,
    sgtxt   TYPE bseg-sgtxt,
    saknr   TYPE bseg-saknr,
    hkont   TYPE bseg-hkont,
    kunnr   TYPE bseg-kunnr,
    xbilk   TYPE bseg-xbilk,
    hsn_sac TYPE bseg-hsn_sac,
    koart   TYPE bseg-koart,
  END OF t_accounting_doc_item,
  tt_accounting_doc_item TYPE STANDARD TABLE OF t_accounting_doc_item.

TYPES:
  BEGIN OF t_bset,
    bukrs TYPE bset-bukrs,
    belnr TYPE bset-belnr,
    gjahr TYPE bset-gjahr,
    buzei TYPE bset-buzei,
    shkzg TYPE bset-shkzg,
    hwbas TYPE bset-hwbas,
    fwbas TYPE bset-fwbas,
    hwste TYPE bset-hwste,
    kschl TYPE bset-kschl,
    kbetr TYPE bset-kbetr,
    mwskz TYPE bset-mwskz,
  END OF t_bset,
  tt_bset TYPE STANDARD TABLE OF t_bset.


TYPES:
  BEGIN OF t_cust_info,
    kunnr TYPE kna1-kunnr,
    name1 TYPE kna1-name1,
    land1 TYPE kna1-land1,
    regio TYPE kna1-regio,
    adrnr TYPE kna1-adrnr,
    stcd3 TYPE kna1-stcd3,
  END OF t_cust_info,
  tt_cust_info TYPE STANDARD TABLE OF t_cust_info.

TYPES:
  BEGIN OF t_t005u,
    land1 TYPE t005u-land1,
    bland TYPE t005u-bland,
    bezei TYPE zgst_region-bezei,
  END OF t_t005u,
  tt_t005u TYPE STANDARD TABLE OF t_t005u.

TYPES:
  BEGIN OF t_zgst_region,
    gst_region TYPE zgst_region-gst_region,
    bezei      TYPE zgst_region-bezei,
  END OF t_zgst_region,
  tt_zgst_region TYPE STANDARD TABLE OF t_zgst_region.

TYPES:
  BEGIN OF t_adrc,
    addrnumber TYPE adrc-addrnumber,
    name1      TYPE adrc-name1,
    city2      TYPE adrc-city2,
    post_code1 TYPE adrc-post_code1,
    street     TYPE adrc-street,
    str_suppl1 TYPE adrc-str_suppl1,
    str_suppl2 TYPE adrc-str_suppl2,
    str_suppl3 TYPE adrc-str_suppl3,
    location   TYPE adrc-location,
    country    TYPE adrc-country,
  END OF t_adrc,
  tt_adrc TYPE STANDARD TABLE OF t_adrc.

TYPES:
  BEGIN OF t_knvi,
    kunnr TYPE knvi-kunnr,
    taxkd TYPE knvi-taxkd,
  END OF t_knvi,
  tt_knvi TYPE STANDARD TABLE OF t_knvi.

TYPES:
  BEGIN OF t_tskdt,
    tatyp TYPE tskdt-tatyp,
    taxkd TYPE tskdt-taxkd,
    vtext TYPE tskdt-vtext,
  END OF t_tskdt,
  tt_tskdt TYPE STANDARD TABLE OF t_tskdt.

TYPES:
  BEGIN OF t_t007s,
    mwskz TYPE t007s-mwskz,
    text1 TYPE t007s-text1,
  END OF t_t007s,
  tt_t007s TYPE STANDARD TABLE OF t_t007s.

TYPES:
  BEGIN OF t_skat,
    saknr TYPE skat-saknr,
    txt20 TYPE skat-txt20,
  END OF t_skat,
  tt_skat TYPE STANDARD TABLE OF t_skat.

TYPES:
  BEGIN OF t_final,
    belnr      TYPE bkpf-belnr,
    budat      TYPE string,"char10, "bkpf-budat,
    blart      TYPE bkpf-blart,
    bktxt      TYPE bkpf-bktxt,
    xblnr      TYPE bkpf-xblnr,
    kunnr      TYPE bseg-kunnr,
    name1      TYPE kna1-name1,
    vtext      TYPE tskdt-vtext,
    stcd3      TYPE kna1-stcd3,
    gst_region TYPE zgst_region-gst_region,
    bezei      TYPE zgst_region-bezei,
    sgtxt      TYPE bseg-sgtxt,
    hsn_sac    TYPE bseg-hsn_sac,
    mwskz      TYPE t007s-mwskz,
    text1      TYPE t007s-text1,
    fwbas      TYPE bset-fwbas,
    waers      TYPE bkpf-waers,
    kursf      TYPE bkpf-kursf,
    hwbas      TYPE bset-hwbas,
*     cgst_p     TYPE PRCD_ELEMENTS-kbetr,              "CGST %
     cgst_p     TYPE p DECIMALS 2,              "CGST %
    cgst       TYPE PRCD_ELEMENTS-kwert,        "CGST
*    sgst_p     TYPE PRCD_ELEMENTS-kbetr,              "SGST %
    sgst_p     TYPE p DECIMALS 2,              "SGST %
    sgst       TYPE PRCD_ELEMENTS-kwert,        "SGST
*    igst_p     TYPE PRCD_ELEMENTS-kbetr,              "IGST %
    igst_p     TYPE p DECIMALS 2,              "IGST %
    igst       TYPE PRCD_ELEMENTS-kwert,        "JOIG
    tot        TYPE PRCD_ELEMENTS-kwert,        "Grand Total
    saknr      TYPE skat-saknr,
    txt20      TYPE skat-txt20,
    address    TYPE string,
    gjahr      TYPE bkpf-gjahr,
    ref_date   TYPE string,              " Abhishek Pisolkar (26.03.2018)
  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.
DATA:
  gt_final TYPE tt_final.
*----------------Download file------------------------------
TYPES:
  BEGIN OF ty_final ,
    belnr      TYPE string,"bkpf-belnr,
    budat      TYPE string,"char10, "bkpf-budat,
    blart      TYPE string,"bkpf-blart,
    bktxt      TYPE string,"bkpf-bktxt,
    xblnr      TYPE string,"bkpf-xblnr,
    kunnr      TYPE string,"bseg-kunnr,
    name1      TYPE string,"kna1-name1,
    vtext      TYPE string,"tskdt-vtext,
    stcd3      TYPE string,"kna1-stcd3,
    gst_region TYPE string,"zgst_region-gst_region,
    bezei      TYPE string,"zgst_region-bezei,
    sgtxt      TYPE string,"bseg-sgtxt,
    hsn_sac    TYPE string,"bseg-hsn_sac,
    mwskz      TYPE string,"t007s-mwskz,
    text1      TYPE string,"t007s-text1,
    fwbas      TYPE string,"string, "bset-fwbas,
    waers      TYPE string,"bkpf-waers,
    kursf      TYPE string,"bkpf-kursf,
    hwbas      TYPE string,"string,"bset-hwbas,
*    cgst_p     TYPE string,"string,"konv-kbetr,              "CGST %
    cgst_p     TYPE p DECIMALS 2,              "CGST %
    cgst       TYPE string,"string,"konv-kwert,        "CGST
*    sgst_p     TYPE string,"string,"konv-kbetr,              "SGST %
    sgst_p     TYPE p DECIMALS 2,              "SGST %
    sgst       TYPE string,"string,"konv-kwert,        "SGST
*    igst_p     TYPE string,"string,"konv-kbetr,              "IGST %
    igst_p     TYPE p DECIMALS 2,              "IGST %
    igst       TYPE string,"string,"konv-kwert,        "JOIG
    tot        TYPE string,"string,"konv-kwert,        "Grand Total
    saknr      TYPE string,"skat-saknr,
    txt20      TYPE string,"skat-txt20,
    address    TYPE string,"string,
    gjahr      TYPE string,"bkpf-gjahr,
    ref_date   TYPE string,"string,              " Abhishek Pisolkar (26.03.2018)
  END OF ty_final.

 data : it_final TYPE TABLE OF ty_final ,   " Abhishek Pisolkar (26.03.2018)
        wa_final TYPE ty_final.
*--------------------------------------------------------------------*
TYPES : BEGIN OF ls_fieldname,
          field_name(25),
        END OF ls_fieldname.

DATA : it_fieldname TYPE TABLE OF ls_fieldname.
DATA : wa_fieldname TYPE ls_fieldname.

TYPES : BEGIN OF ty_blart,
  blart TYPE bkpf-blart,
  END OF ty_blart.
data : it_blart TYPE TABLE OF ty_blart,
       wa_blart TYPE ty_blart.
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
SELECT-OPTIONS: so_belnr FOR tmp_belnr,
                so_budat FOR tmp_budat DEFAULT '20170401' TO sy-datum,
                so_gjahr FOR tmp_gjahr DEFAULT '2017',
                s_blart for bkpf-blart.       " Abhishek (27.03.2018)
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE abc .
PARAMETERS p_down AS CHECKBOX.
*PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.  "'/Delval/India'."temp'
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.  "'/Delval/India'."temp'
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

*****************************************************************************NEW ADD CODE ***********************************************
at SELECTION-SCREEN on value-REQUEST FOR s_blart-low.
*BREAK-POINT.
  SELECT DISTINCT blart from bkpf INTO TABLE it_blart WHERE blart in ('RV','DG','DR').
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
*       DDIC_STRUCTURE         = ' '
        retfield               = 'BLART'
*       PVALKEY                = ' '
       DYNPPROG               = SY-CPROG
       DYNPNR                 = SY-DYNNR
       DYNPROFIELD            = 'S_BLART'
       VALUE_ORG              = 'S'
      tables
        value_tab              = it_blart
*       FIELD_TAB              =
*       RETURN_TAB             =
*       DYNPFLD_MAPPING        =
     EXCEPTIONS
       PARAMETER_ERROR        = 1
       NO_VALUES_FOUND        = 2
       OTHERS                 = 3
              .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

at SELECTION-SCREEN on value-REQUEST FOR s_blart-high.
*  SELECT blart from bkpf INTO TABLE it_blart WHERE blart in ('RV','DG','DR').
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
*       DDIC_STRUCTURE         = ' '
        retfield               = 'BLART'
*       PVALKEY                = ' '
       DYNPPROG               = SY-CPROG
       DYNPNR                 = SY-DYNNR
       DYNPROFIELD            = 'S_BLART'
       VALUE_ORG              = 'S'
      tables
        value_tab              = it_blart
*       FIELD_TAB              =
*       RETURN_TAB             =
*       DYNPFLD_MAPPING        =
     EXCEPTIONS
       PARAMETER_ERROR        = 1
       NO_VALUES_FOUND        = 2
       OTHERS                 = 3
              .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

*SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE pqr .
*PARAMETERS p_own AS CHECKBOX.
**PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\temp'.
*SELECTION-SCREEN END OF BLOCK b6.


INITIALIZATION.
  xyz = 'Select Options'(tt1).
  abc = 'Download File'(tt2).
*  pqr = 'Download File to Own PC'(tt3)."ADD CODE 23.03.2018

START-OF-SELECTION.
  PERFORM get_data CHANGING gt_final.
  PERFORM display USING gt_final.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM get_data  CHANGING ct_final TYPE tt_final.
  DATA:
    lt_accounting_doc_hdr  TYPE tt_accounting_doc_hdr,
    ls_accounting_doc_hdr  TYPE t_accounting_doc_hdr,
    lt_accounting_doc_item TYPE tt_accounting_doc_item,
    lt_accounting_doc_itm1 TYPE tt_accounting_doc_item,
    ls_accounting_doc_itm1 TYPE t_accounting_doc_item,
    ls_accounting_doc_item TYPE t_accounting_doc_item,
    lt_bset                TYPE tt_bset,
    ls_bset                TYPE t_bset,
    lt_cust_info           TYPE tt_cust_info,
    ls_cust_info           TYPE t_cust_info,
    lt_t005u               TYPE tt_t005u,
    ls_t005u               TYPE t_t005u,
    lt_zgst_region         TYPE tt_zgst_region,
    ls_zgst_region         TYPE t_zgst_region,
    lt_knvi                TYPE tt_knvi,
    ls_knvi                TYPE t_knvi,
    lt_tskdt               TYPE tt_tskdt,
    ls_tskdt               TYPE t_tskdt,
    lt_t007s               TYPE tt_t007s,
    ls_t007s               TYPE t_t007s,
    lt_skat                TYPE tt_skat,
    ls_skat                TYPE t_skat,
    ls_final               TYPE t_final,
    lv_index               TYPE sy-tabix,
    lv_shkzg               TYPE c,
    lt_adrc                TYPE tt_adrc,
    ls_adrc                TYPE t_adrc.

if s_blart is NOT INITIAL.
  SELECT bukrs
         belnr
         gjahr
         blart
         budat
         xblnr
         bktxt
         waers
         kursf
    FROM bkpf
    INTO TABLE lt_accounting_doc_hdr
    WHERE belnr IN so_belnr
    AND   gjahr IN so_gjahr
    AND   budat IN so_budat
    AND   blart IN s_blart       "('RV','DG','DR') "DA AB
  AND   tcode IN ('FB70','FB75','FB05','FB08','FBVB','FB01','FV70','FV75' )" ,'FBCJ','FB1D'). "FBCJ FB1D
  AND BUKRS = '1000'." ADDED BY MD
else.

  SELECT bukrs
         belnr
         gjahr
         blart
         budat
         xblnr
         bktxt
         waers
         kursf
         STBLG
    FROM bkpf
    INTO TABLE lt_accounting_doc_hdr
    WHERE belnr IN so_belnr
    AND   gjahr IN so_gjahr
    AND   budat IN so_budat
    AND   blart IN ('RV','DG','DR') "DA AB
    AND   tcode IN ('FB70','FB75','FB05','FB08','FBVB','FB01','FV70','FV75' )" ,'FBCJ','FB1D'). "FBCJ FB1D
    AND BUKRS = '1000'." ADDED BY MD
  endif.

*  IF NOT sy-subrc IS INITIAL.
**    MESSAGE 'Data Not Found' TYPE 'E'.
*     MESSAGE 'Data Not Found' TYPE 'I' DISPLAY LIKE 'E'.."ADDED BY PRIMUS JYOTI ON 10.04.2024
*      LEAVE LIST-PROCESSING.
*  ENDIF.

  IF NOT lt_accounting_doc_hdr IS INITIAL.

    SELECT bukrs
           belnr
           gjahr
           buzei
           buzid
           shkzg
           mwskz
           dmbtr
           wrbtr
           txgrp
           ktosl
           zuonr
           sgtxt
           saknr
           hkont
           kunnr
           xbilk
           hsn_sac
           koart
      FROM bseg
      INTO TABLE lt_accounting_doc_item
      FOR ALL ENTRIES IN lt_accounting_doc_hdr
      WHERE belnr = lt_accounting_doc_hdr-belnr
    AND   gjahr = lt_accounting_doc_hdr-gjahr.

    SELECT bukrs
           belnr
           gjahr
           buzei
           shkzg
           hwbas
           fwbas
           hwste
           kschl
           kbetr
           mwskz
      FROM bset
      INTO TABLE lt_bset
      FOR ALL ENTRIES IN lt_accounting_doc_hdr
      WHERE belnr = lt_accounting_doc_hdr-belnr
    AND   gjahr = lt_accounting_doc_hdr-gjahr.

    SELECT saknr
           txt20
      FROM skat
      INTO TABLE lt_skat
      FOR ALL ENTRIES IN lt_accounting_doc_item
      WHERE saknr = lt_accounting_doc_item-hkont
      AND   spras = sy-langu
    AND   ktopl = '1000'.

    SELECT mwskz
           text1
      FROM t007s
      INTO TABLE lt_t007s
      FOR ALL ENTRIES IN lt_accounting_doc_item
      WHERE mwskz = lt_accounting_doc_item-mwskz
    AND   kalsm = 'ZTAXIN'.

    SELECT kunnr
           name1
           land1
           regio
           adrnr
           stcd3
      FROM kna1
      INTO TABLE lt_cust_info
      FOR ALL ENTRIES IN lt_accounting_doc_item
    WHERE kunnr = lt_accounting_doc_item-kunnr.

    IF NOT lt_cust_info IS INITIAL.
      SELECT addrnumber
               name1
               city2
               post_code1
               street
               str_suppl1
               str_suppl2
               str_suppl3
               location
               country
          FROM adrc
          INTO TABLE lt_adrc
          FOR ALL ENTRIES IN lt_cust_info
      WHERE addrnumber = lt_cust_info-adrnr.

      SELECT kunnr
             taxkd
        FROM knvi
        INTO TABLE lt_knvi
        FOR ALL ENTRIES IN lt_cust_info
        WHERE kunnr = lt_cust_info-kunnr
      AND   tatyp IN ('JOCG','JOIG').

      IF sy-subrc IS INITIAL.
        SELECT tatyp
               taxkd
               vtext
          FROM tskdt
          INTO TABLE lt_tskdt
          FOR ALL ENTRIES IN lt_knvi
          WHERE taxkd = lt_knvi-taxkd
        AND   spras = sy-langu.


      ENDIF.
      SELECT land1
             bland
             bezei
        FROM t005u
        INTO TABLE lt_t005u
        FOR ALL ENTRIES IN lt_cust_info
        WHERE spras = sy-langu
        AND   land1 = lt_cust_info-land1
      AND   bland = lt_cust_info-regio.

      SELECT gst_region
             bezei
        FROM zgst_region
        INTO TABLE lt_zgst_region
        FOR ALL ENTRIES IN lt_t005u
      WHERE bezei = lt_t005u-bezei.

    ENDIF.
  ENDIF.

  SORT lt_accounting_doc_hdr BY belnr gjahr.
  SORT lt_accounting_doc_item BY belnr gjahr buzei.
  SORT lt_bset BY belnr gjahr buzei.

  DATA:
  lv_flag TYPE c.
  lt_accounting_doc_itm1[] = lt_accounting_doc_item[].
  DELETE lt_accounting_doc_itm1 WHERE kunnr = space.
*BREAK primus.
  LOOP AT lt_accounting_doc_item INTO ls_accounting_doc_item WHERE kunnr NE space.
    ls_final-belnr   = ls_accounting_doc_item-belnr.
    ls_final-gjahr   = ls_accounting_doc_item-gjahr.
    ls_final-kunnr   = ls_accounting_doc_item-kunnr.
    ls_final-sgtxt   = ls_accounting_doc_item-sgtxt.
    ls_final-hsn_sac = ls_accounting_doc_item-hsn_sac.
*    ls_final-dmbtr   = ls_accounting_doc_item-dmbtr.
*    ls_final-wrbtr   = ls_accounting_doc_item-wrbtr.

    READ TABLE lt_accounting_doc_hdr INTO ls_accounting_doc_hdr WITH KEY belnr = ls_accounting_doc_item-belnr
                                                                         gjahr = ls_accounting_doc_item-gjahr.
    IF sy-subrc IS INITIAL.
*      CONCATENATE ls_accounting_doc_hdr-budat+6(2) ls_accounting_doc_hdr-budat+4(2) ls_accounting_doc_hdr-budat+0(4)
*                  INTO ls_final-budat SEPARATED BY '-'.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_accounting_doc_hdr-budat
      IMPORTING
        output = ls_final-budat.
    CONCATENATE ls_final-budat+0(2) ls_final-budat+2(3) ls_final-budat+5(4)
                   INTO ls_final-budat SEPARATED BY '-'.
*--------------------------------------------------------------------*

      ls_final-blart = ls_accounting_doc_hdr-blart.
      ls_final-xblnr = ls_accounting_doc_hdr-xblnr.
      ls_final-bktxt = ls_accounting_doc_hdr-bktxt.
      ls_final-waers = ls_accounting_doc_hdr-waers.
      ls_final-kursf = ls_accounting_doc_hdr-kursf.
    ENDIF.


***    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
***                                             gjahr = ls_accounting_doc_item-gjahr
***                                             kschl = 'JOCG'.
***    IF sy-subrc IS INITIAL.
***      ls_final-hwbas   = ls_bset-hwbas.
***      ls_final-fwbas   = ls_bset-fwbas.
***      ls_final-cgst   = ls_bset-hwste.
***      ls_final-cgst_p = ls_bset-kbetr / 10.
***    ENDIF.
***
***    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
***                                             gjahr = ls_accounting_doc_item-gjahr
***                                             kschl = 'JOSG'.
***    IF sy-subrc IS INITIAL.
***      ls_final-sgst   = ls_bset-hwste.
***      ls_final-sgst_p = ls_bset-kbetr / 10.
***    ENDIF.
***
***    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
***                                             gjahr = ls_accounting_doc_item-gjahr
***                                             kschl = 'JOIG'.
***    IF sy-subrc IS INITIAL.
***      ls_final-hwbas   = ls_bset-hwbas.
***      ls_final-fwbas   = ls_bset-fwbas.
***      ls_final-igst   = ls_bset-hwste.
***      ls_final-igst_p = ls_bset-kbetr / 10.
***    ENDIF.

    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
                                             gjahr = ls_accounting_doc_item-gjahr.
    IF sy-subrc IS INITIAL.
      lv_index = sy-tabix.

      LOOP AT lt_bset INTO ls_bset FROM lv_index.
        IF ls_bset-belnr = ls_accounting_doc_item-belnr AND ls_bset-gjahr = ls_accounting_doc_item-gjahr.
***          IF ls_accounting_doc_hdr-blart = 'DG'.
***            IF ls_bset-shkzg = 'S'.
***              lv_shkzg = 'H'.
***            else.
***              lv_shkzg = 'S'.
***            ENDIF.
***          else.
          lv_shkzg = ls_bset-shkzg.
***          ENDIF.
          CASE ls_bset-kschl.
            WHEN 'JOCG'.
              IF lv_shkzg = 'S'.
                ls_final-cgst    = ls_final-cgst - ls_bset-hwste.
                ls_final-hwbas   = ls_final-hwbas - ls_bset-hwbas.
                ls_final-fwbas   = ls_final-fwbas - ls_bset-fwbas.

              ELSE.
                ls_final-hwbas   = ls_final-hwbas + ls_bset-hwbas.
                ls_final-fwbas   = ls_final-fwbas + ls_bset-fwbas.

                ls_final-cgst    = ls_final-cgst + ls_bset-hwste.
              ENDIF.
              lv_flag = 'X'.
              IF NOT ls_bset-kbetr IS INITIAL.
*                ls_final-cgst_p  = ls_bset-kbetr / 10.
                ls_final-cgst_p  = ls_bset-kbetr .
                ls_final-mwskz = ls_bset-mwskz.
              ENDIF.

            WHEN 'JICG'.
              IF lv_shkzg = 'S'.
                ls_final-cgst    = ls_final-cgst - ls_bset-hwste.
                ls_final-hwbas   = ls_final-hwbas - ls_bset-hwbas.
                ls_final-fwbas   = ls_final-fwbas - ls_bset-fwbas.

              ELSE.
                ls_final-cgst    = ls_final-cgst + ls_bset-hwste.
                ls_final-hwbas   = ls_final-hwbas + ls_bset-hwbas.
                ls_final-fwbas   = ls_final-fwbas + ls_bset-fwbas.

              ENDIF.

*              **************************added by jyoti on 26.03.2025************
              IF LS_FINAL-BLART = 'DG'.
                IF  LS_FINAL-CGST GT '0'.
                  LS_FINAL-CGST =  LS_FINAL-CGST * -1.
                ENDIF.
              ENDIF.
************************************************
*              IF NOT ls_bset-kbetr IS INITIAL.
*              ls_final-cgst_p  = ls_bset-kbetr / 10.
              ls_final-cgst_p  = ls_bset-kbetr .
              ls_final-mwskz = ls_bset-mwskz.
*              ENDIF.
              lv_flag = 'X'.

            WHEN 'JOSG'.
              IF lv_shkzg = 'S'.
                ls_final-sgst    = ls_final-sgst - ls_bset-hwste.
              ELSE.
                ls_final-sgst    = ls_final-sgst + ls_bset-hwste.
              ENDIF.

              IF NOT ls_bset-kbetr IS INITIAL.
*                ls_final-sgst_p  = ls_bset-kbetr / 10.
                ls_final-sgst_p  = ls_bset-kbetr .
*              ls_final-mwskz = ls_bset-mwskz.
              ENDIF.

            WHEN 'JISG'.
              IF lv_shkzg = 'S'.
                ls_final-sgst    = ls_final-sgst - ls_bset-hwste.
              ELSE.
                ls_final-sgst    = ls_final-sgst + ls_bset-hwste.
              ENDIF.

***********************added by JYOTI ON 26.03.2025
              IF LS_FINAL-BLART = 'DG'.
                IF  LS_FINAL-SGST GT '0'.
                  LS_FINAL-SGST =  LS_FINAL-SGST * -1.
                ENDIF.
              ENDIF.
*************************************

              IF NOT ls_bset-kbetr IS INITIAL.
*                ls_final-sgst_p  = ls_bset-kbetr / 10.
                ls_final-sgst_p  = ls_bset-kbetr .
*                ls_final-mwskz = ls_bset-mwskz.
              ENDIF.

            WHEN 'JOIG'.
              IF lv_shkzg = 'S'.
                ls_final-igst    = ls_final-igst - ls_bset-hwste.
                ls_final-hwbas   = ls_final-hwbas - ls_bset-hwbas.
                ls_final-fwbas   = ls_final-fwbas - ls_bset-fwbas.

              ELSE.
                ls_final-igst    = ls_final-igst + ls_bset-hwste.
                ls_final-hwbas   = ls_final-hwbas + ls_bset-hwbas.
                ls_final-fwbas   = ls_final-fwbas + ls_bset-fwbas.

              ENDIF.
              lv_flag = 'X'.
              IF NOT ls_bset-kbetr IS INITIAL.
*                ls_final-igst_p  = ls_bset-kbetr / 10.
                ls_final-igst_p  = ls_bset-kbetr.
                ls_final-mwskz = ls_bset-mwskz.
              ENDIF.


            WHEN 'JIIG'.
              IF lv_shkzg = 'S'.
                ls_final-igst    = ls_final-igst - ls_bset-hwste.
                ls_final-hwbas   = ls_final-hwbas - ls_bset-hwbas.
                ls_final-fwbas   = ls_final-fwbas - ls_bset-fwbas.

              ELSE.
                ls_final-igst    = ls_final-igst + ls_bset-hwste.
                ls_final-hwbas   = ls_final-hwbas + ls_bset-hwbas.
                ls_final-fwbas   = ls_final-fwbas + ls_bset-fwbas.

              ENDIF.

************************added by JYOTI ON 26.03.2025
              IF LS_FINAL-BLART = 'DG'.
                IF  LS_FINAL-IGST GT '0'.
                  LS_FINAL-IGST =  LS_FINAL-IGST * -1.
                ENDIF.
              ENDIF.
********************************
              IF NOT ls_bset-kbetr IS INITIAL.
*                ls_final-igst_p  = ls_bset-kbetr / 10.
                ls_final-igst_p  = ls_bset-kbetr.
                ls_final-mwskz = ls_bset-mwskz.
              ENDIF.
              lv_flag = 'X'.
          ENDCASE.
        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
    IF lv_flag IS INITIAL.
      READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
                                               gjahr = ls_accounting_doc_item-gjahr.
      IF sy-subrc IS INITIAL.
        IF ls_bset-shkzg = 'S'.
          ls_final-hwbas   = ls_bset-hwbas * -1.
          ls_final-fwbas   = ls_bset-fwbas * -1.
        ELSE.
          ls_final-hwbas   = ls_bset-hwbas.
          ls_final-fwbas   = ls_bset-fwbas.
        ENDIF.
        ls_final-mwskz = ls_bset-mwskz.
      ELSE.
**        READ TABLE lt_accounting_doc_item INTO ls_accounting_doc_itm1 WITH KEY belnr = ls_accounting_doc_item-belnr
**                                                                               gjahr = ls_accounting_doc_item-gjahr
**                                                                               xbilk = space.
        READ TABLE lt_accounting_doc_item INTO ls_accounting_doc_itm1 WITH KEY belnr = ls_accounting_doc_item-belnr
                                                                               gjahr = ls_accounting_doc_item-gjahr
                                                                               ktosl = space
                                                                               saknr = space.
        IF sy-subrc IS INITIAL.
          IF ls_accounting_doc_itm1-shkzg = 'S'.
            ls_final-hwbas   = ls_accounting_doc_itm1-dmbtr * -1.
            ls_final-fwbas   = ls_accounting_doc_itm1-dmbtr * -1.
          ELSE.
            ls_final-hwbas   = ls_accounting_doc_itm1-dmbtr.
            ls_final-fwbas   = ls_accounting_doc_itm1-dmbtr.
          ENDIF.

*    ****
        ELSE.
          READ TABLE lt_accounting_doc_item INTO ls_accounting_doc_itm1 WITH KEY belnr = ls_accounting_doc_item-belnr
                                                                               gjahr = ls_accounting_doc_item-gjahr
                                                                               koart = 'D'
                                                                               shkzg = 'S'.
          IF sy-subrc IS INITIAL.
            IF ls_accounting_doc_itm1-shkzg = 'S'.
              ls_final-hwbas   = ls_accounting_doc_itm1-dmbtr * -1.
              ls_final-fwbas   = ls_accounting_doc_itm1-dmbtr * -1.
            ELSE.
              ls_final-hwbas   = ls_accounting_doc_itm1-dmbtr.
              ls_final-fwbas   = ls_accounting_doc_itm1-dmbtr.
            ENDIF.
          ENDIF.

*         ***
        ENDIF.
      ENDIF.
    ENDIF.

*******************ADDED BYJYOTIO N26.03.2025
      IF LS_FINAL-BLART = 'DG'.
        IF  LS_FINAL-FWBAS GT '0'.
          LS_FINAL-FWBAS =  LS_FINAL-FWBAS * -1.
        ENDIF.
*        IF LS_ACCOUNTING_DOC_ITEM-AUGBL IS NOT INITIAL.
*          LS_FINAL-FWBAS = 0.
*        ENDIF.
      ENDIF.
**********************************************

    IF ls_final-mwskz IS INITIAL.
      ls_final-mwskz = ls_accounting_doc_itm1-mwskz.
    ENDIF.
    READ TABLE lt_t007s INTO ls_t007s WITH KEY mwskz = ls_final-mwskz.
    IF sy-subrc IS INITIAL.
      ls_final-text1 = ls_t007s-text1.
    ENDIF.
    READ TABLE lt_cust_info INTO ls_cust_info WITH KEY kunnr = ls_accounting_doc_item-kunnr.
    IF sy-subrc IS INITIAL.
      ls_final-name1 = ls_cust_info-name1.
      ls_final-stcd3 = ls_cust_info-stcd3.
    ENDIF.
    READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_cust_info-adrnr.
    IF sy-subrc IS INITIAL.
      IF NOT ls_adrc-str_suppl1 IS INITIAL.
        CONCATENATE ls_final-address ls_adrc-str_suppl1 INTO ls_final-address.
      ENDIF.

      IF NOT ls_adrc-str_suppl2 IS INITIAL.
        CONCATENATE ls_final-address ls_adrc-str_suppl2 INTO ls_final-address.
      ENDIF.

      IF NOT ls_adrc-street IS INITIAL.
        CONCATENATE ls_final-address ls_adrc-street INTO ls_final-address.
      ENDIF.

      IF NOT ls_adrc-str_suppl3 IS INITIAL.
        CONCATENATE ls_final-address ls_adrc-str_suppl3 INTO ls_final-address SEPARATED BY ','.
      ENDIF.
      IF NOT ls_adrc-location IS INITIAL.
        CONCATENATE ls_final-address ls_adrc-location INTO ls_final-address SEPARATED BY ','.
      ENDIF.

      IF NOT ls_adrc-city2 IS INITIAL.
        CONCATENATE ls_final-address ls_adrc-city2 INTO ls_final-address SEPARATED BY ','.
      ENDIF.
      IF NOT ls_adrc-post_code1 IS INITIAL.
        CONCATENATE ls_final-address 'PIN:' ls_adrc-post_code1 INTO ls_final-address SEPARATED BY ','.
      ENDIF.
      CONDENSE ls_final-address.
    ENDIF.
    READ TABLE lt_t005u INTO ls_t005u WITH KEY land1 = ls_cust_info-land1
                                               bland = ls_cust_info-regio.
    IF sy-subrc IS INITIAL.
      ls_final-bezei = ls_t005u-bezei.
    ENDIF.

    IF ls_cust_info-land1 = 'IN'.
      READ TABLE lt_knvi INTO ls_knvi WITH KEY kunnr = ls_cust_info-kunnr.
      IF sy-subrc IS INITIAL.
        IF ls_cust_info-regio = '13'.
          READ TABLE lt_tskdt INTO ls_tskdt WITH KEY tatyp = 'JOCG'.
          IF sy-subrc IS INITIAL.
            ls_final-vtext = ls_tskdt-vtext.
          ENDIF.
        ELSE.
          READ TABLE lt_tskdt INTO ls_tskdt WITH KEY tatyp = 'JOIG'.
          IF sy-subrc IS INITIAL.
            ls_final-vtext = ls_tskdt-vtext.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY bezei = ls_t005u-bezei.
    IF sy-subrc IS INITIAL.
      ls_final-gst_region = ls_zgst_region-gst_region.
    ENDIF.

    READ TABLE lt_accounting_doc_item INTO ls_accounting_doc_itm1 WITH KEY belnr = ls_accounting_doc_item-belnr
                                                                           gjahr = ls_accounting_doc_item-gjahr
                                                                           ktosl = space
                                                                           saknr = space.
    IF sy-subrc IS INITIAL.
      ls_final-saknr = ls_accounting_doc_itm1-hkont.
    ELSE.
      READ TABLE lt_accounting_doc_item INTO ls_accounting_doc_itm1 WITH KEY belnr = ls_accounting_doc_item-belnr
                                                                          gjahr = ls_accounting_doc_item-gjahr
                                                                          koart = 'D'
                                                                          shkzg = 'S'.
      IF sy-subrc IS INITIAL.
        ls_final-saknr = ls_accounting_doc_itm1-hkont.
      ENDIF.
    ENDIF.

    READ TABLE lt_skat INTO ls_skat WITH KEY saknr = ls_final-saknr.
    IF sy-subrc IS INITIAL.
      ls_final-txt20 = ls_skat-txt20.
    ENDIF.

    ls_final-tot = ls_final-hwbas + ls_final-cgst + ls_final-sgst + ls_final-igst.


    IF LS_FINAL-BLART = 'DG' OR LS_FINAL-BLART = 'DR'.

*        IF LS_ACCOUNTING_DOC_ITEM-AUGBL IS NOT INITIAL.
        IF LS_ACCOUNTING_DOC_HDR-STBLG IS NOT INITIAL."added by jyoti on 02.04.2024
          LS_FINAL-FWBAS = 0.
          LS_FINAL-HWBAS = 0.
          LS_FINAL-CGST = 0.
          LS_FINAL-CGST_P = 0.
          LS_FINAL-SGST = 0.
          LS_FINAL-SGST_p = 0.
          LS_FINAL-IGST = 0.
          LS_FINAL-TOT = 0.
        ENDIF.
      ENDIF.



*---------------Refreshable Date-----------------------
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_final-ref_date.
    CONCATENATE ls_final-ref_date+0(2) ls_final-ref_date+2(3) ls_final-ref_date+5(4)
                   INTO ls_final-ref_date SEPARATED BY '-'.
*--------------------------------------------------------------------*
    APPEND ls_final TO ct_final.
    CLEAR:
      ls_final,ls_bset,ls_accounting_doc_item,ls_accounting_doc_itm1,ls_accounting_doc_hdr,ls_cust_info,ls_zgst_region,
      ls_tskdt,ls_t005u,ls_skat,lv_flag.

  ENDLOOP.
*  BREAK-POINT.
  SORT ct_final BY belnr gjahr.
  DELETE ADJACENT DUPLICATES FROM ct_final COMPARING belnr fwbas .
  LOOP AT ct_final INTO ls_final.
  wa_final-belnr      =     ls_final-belnr     .
  wa_final-budat      =     ls_final-budat     .
  wa_final-blart      =     ls_final-blart     .
  wa_final-bktxt      =     ls_final-bktxt     .
  wa_final-xblnr      =     ls_final-xblnr     .
  wa_final-kunnr      =     ls_final-kunnr     .
  wa_final-name1      =     ls_final-name1     .
  wa_final-vtext      =     ls_final-vtext     .
  wa_final-stcd3      =     ls_final-stcd3     .
  wa_final-gst_region =     ls_final-gst_region.
  wa_final-bezei      =     ls_final-bezei     .
  wa_final-sgtxt      =     ls_final-sgtxt     .
  wa_final-hsn_sac    =     ls_final-hsn_sac   .
  wa_final-mwskz      =     ls_final-mwskz     .
  wa_final-text1      =     ls_final-text1     .
  wa_final-fwbas      =     ls_final-fwbas     .
  wa_final-waers      =     ls_final-waers     .
  wa_final-kursf      =     ls_final-kursf     .
  wa_final-hwbas      =     ls_final-hwbas     .
  wa_final-cgst_p     =     ls_final-cgst_p    .
  wa_final-cgst       =     ls_final-cgst      .
  wa_final-sgst_p     =     ls_final-sgst_p    .
  wa_final-sgst       =     ls_final-sgst      .
  wa_final-igst_p     =     ls_final-igst_p    .
  wa_final-igst       =     ls_final-igst      .
  wa_final-tot        =     ls_final-tot       .
  wa_final-saknr      =     ls_final-saknr     .
  wa_final-txt20      =     ls_final-txt20     .
  wa_final-address    =     ls_final-address   .
  wa_final-gjahr      =     ls_final-gjahr     .
  wa_final-ref_date   =     ls_final-ref_date  .
*------------------Refreshable Date / Shift negative sign to left logic ------------------------------------------
*BREAK primus.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = wa_final-cgst.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = wa_final-sgst.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = wa_final-igst.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = wa_final-fwbas.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = wa_final-tot.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = wa_final-hwbas.

  append wa_final to it_final.
  CLEAR : ls_final, wa_final.
  ENDLOOP.

*  it_final[] = ct_final[].         " Abhishek Pisolkar (26.03.2018)
*  BREAK primus.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM display  USING    ct_final TYPE tt_final.
  DATA:
    lt_fieldcat     TYPE slis_t_fieldcat_alv,
    ls_alv_layout   TYPE slis_layout_alv,
    l_callback_prog TYPE sy-repid.

  l_callback_prog = sy-repid.

  PERFORM prepare_display CHANGING lt_fieldcat.
  CLEAR ls_alv_layout.
  ls_alv_layout-zebra = 'X'.
  ls_alv_layout-colwidth_optimize = 'X'.

****************************************************************************************ADD CODE 23.03.2018*****************************
*  IF p_own = 'X'.
**    PERFORM fieldnames.
**    PERFORM download_log.
*  ENDIF.
***************************************************************************************end code 23,03,2018**********************************

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = l_callback_prog
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
      is_layout               = ls_alv_layout
      it_fieldcat             = lt_fieldcat
      i_save                  = 'X'
    TABLES
      t_outtab                = ct_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  IF p_down = 'X'.
    PERFORM download.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM prepare_display  CHANGING ct_fieldcat TYPE slis_t_fieldcat_alv .
  DATA:
    gv_pos      TYPE i,
    ls_fieldcat TYPE slis_fieldcat_alv.

  REFRESH ct_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BELNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Accounting Doc.No.'(100).
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BUDAT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Doc.Date'(101).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BLART'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'FI Doc.Type'(102).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BKTXT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Original Doc.No.'(103).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'XBLNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Invoice No.'(104).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KUNNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer Code'(105).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NAME1'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Name'(106).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VTEXT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'REGD/URD/SEZ/DEEMED/GOV'(107).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STCD3'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer GSTIN'(108).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GST_REGION'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer State Code'(109).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BEZEI'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer State Name'(110).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SGTXT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Description'(111).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'HSN_SAC'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'HSN/SAC'(112).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MWSKZ'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Tax Code'(113).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TEXT1'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Tax Code Description'(114).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FWBAS'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Basic Amount(DC) '(115).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'WAERS'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Currency'(116).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KURSF'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Exchange Rate'(117).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'HWBAS'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Basic Amount(LC) '(118).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'CGST_P'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'CGST%'(119).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'CGST'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'CGST'(120).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SGST_P'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'SGST%'(121).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SGST'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'SGST'(122).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'IGST_P'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'IGST%'(123).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'IGST'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'IGST'(124).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TOT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Total Amt.'(125).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SAKNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Ledger Code'(126).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TXT20'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Ledger Head'(127).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  UCOMM_ON_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM ucomm_on_alv USING r_ucomm LIKE sy-ucomm
                    rs_selfield TYPE slis_selfield.
  DATA:
    ls_final TYPE t_final,
    lv_burks TYPE bseg-bukrs VALUE '1000'.

  CASE r_ucomm.
    WHEN '&IC1'. "for double click
      IF rs_selfield-fieldname = 'BELNR'.
        READ TABLE gt_final INTO ls_final INDEX rs_selfield-tabindex.
        SET PARAMETER ID 'BLN' FIELD rs_selfield-value.
        SET PARAMETER ID 'BUK' FIELD lv_burks.
        SET PARAMETER ID 'GJR' FIELD ls_final-gjahr.
        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDIF.
  ENDCASE.
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
*BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_final "gt_final         " Abhishek Pisolkar (26.03.2018)
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
  lv_file = 'ZSALES_FI1.TXT'.

  CONCATENATE p_folder '/'  lv_file
    INTO lv_fullfile.

  WRITE: / 'ZSALES_FI Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1362 TYPE string.
DATA lv_crlf_1362 TYPE string.
lv_crlf_1362 = cl_abap_char_utilities=>cr_lf.
lv_string_1362 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1362 lv_crlf_1362 wa_csv INTO lv_string_1362.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1581 TO lv_fullfile.
TRANSFER lv_string_1362 TO lv_fullfile.
    CLOSE DATASET lv_fullfile.
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
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
*  CONCATENATE 'Accounting Doc.No.'
*              'Fiscal Year'
*              'Doc.Date'
*              'FI Doc.Type'
*              'Invoice No.'
*              'Original Doc.No.'
*              'Customer Code'
*              'Name'
*              'REGD/URD/SEZ/DEEMED/GOV'
*              'Customer GSTIN'
*              'Customer State Code'
*              'Customer State Name'
*              'Description'
*              'HSN/SAC'
*              'Tax Code'
*              'Tax Code Description'
*              'Basic Amount(DC)'
*              'Currency'
*              'Exchange Rate'
*              'Basic Amount(LC)'
*              'CGST%'
*              'CGST'
*              'SGST%'
*              'SGST'
*              'IGST%'
*              'IGST'
*              'Total Amt.'
*              'Sales Ledger Code'
*              'Sales Ledger Head'
*              'Customer Address'
*              'Refreshable Date'               " Abhishek Pisolkar
*              INTO pd_csv
*  SEPARATED BY l_field_seperator.

  CONCATENATE 'Accounting Doc.No.'
              'Doc.Date'
              'FI Doc.Type'
              'Original Doc.No.'
              'Invoice No.'
              'Customer Code'
              'Name'
              'REGD/URD/SEZ/DEEMED/GOV'
              'Customer GSTIN'
              'Customer State Code'
              'Customer State Name'
              'Description'
              'HSN/SAC'
              'Tax Code'
              'Tax Code Description'
              'Basic Amount(DC)'
              'Currency'
              'Exchange Rate'
              'Basic Amount(LC)'
              'CGST%'
              'CGST'
              'SGST%'
              'SGST'
              'IGST%'
              'IGST'
              'Total Amt.'
              'Sales Ledger Code'
              'Sales Ledger Head'
              'Customer Address'               " Abhishek Pisolkar
              'Fiscal Year'                    " Abhishek Pisolkar
              'Refreshable Date'               " Abhishek Pisolkar
       INTO pd_csv SEPARATED BY l_field_seperator.
ENDFORM.

INCLUDE ZFI_SALES_REG_FIELDNAMF_NEW.
*INCLUDE zfi_sales_register_fieldnamf01.
*&---------------------------------------------------------------------*
*&      Form  FIELDNAMES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM fieldnames .
*
*  wa_fieldname-field_name = 'Accounting Doc.No.'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Doc.Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'FI Doc.Type'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Original Doc No.'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Invoice No.'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Name'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'REGD/URD/SEZ/DEEMED/GOV'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer GSTIN'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer State Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer State Name'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Description'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'HSN/SAC'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Tax Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Tax Code Description'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Basic Amount(DC)'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Currency'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Exchange Rate'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Basic Amount(LC) '.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'CGST%'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'CGST'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'SGST%'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'SGST'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'IGST%'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'IGST'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Total Amt.'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Sales Ledger Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Sales Ledger Head'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Address'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Fiscal Year'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Refreshable Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM download_log .
*  DATA : v_fullpath      TYPE string.
*
*  CALL FUNCTION 'GUI_FILE_SAVE_DIALOG'
*    EXPORTING
*      window_title      = 'STATUS RECORD FILE'
*      default_extension = '.xls'
*    IMPORTING
**     filename          = v_efile
*      fullpath          = v_fullpath.
*
*
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
*      filename                = v_fullpath
*      filetype                = 'ASC'
*      write_field_separator   = 'X'
*    TABLES
*      data_tab                = it_final
*      fieldnames              = it_fieldname
*    EXCEPTIONS
*      file_write_error        = 1
*      no_batch                = 2
*      gui_refuse_filetransfer = 3
*      invalid_type            = 4
*      no_authority            = 5
*      unknown_error           = 6
*      header_not_allowed      = 7
*      separator_not_allowed   = 8
*      filesize_not_allowed    = 9
*      header_too_long         = 10
*      dp_error_create         = 11
*      dp_error_send           = 12
*      dp_error_write          = 13
*      unknown_dp_error        = 14
*      access_denied           = 15
*      dp_out_of_memory        = 16
*      disk_full               = 17
*      dp_timeout              = 18
*      file_not_found          = 19
*      dataprovider_exception  = 20
*      control_flush_error     = 21
*      OTHERS                  = 22.
*
*  IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ELSE.
*    MESSAGE 'Please check Status File' TYPE 'S'.
*  ENDIF.
*
*
*
*ENDFORM.
*ENDFORM.
