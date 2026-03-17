***&---------------------------------------------------------------------*
***& Report ZPURCHASE_REGISTER_FI
***&---------------------------------------------------------------------*
***&
***&---------------------------------------------------------------------*
REPORT zpurchase_register_fi.

TYPE-POOLS:slis.

DATA:
  tmp_belnr TYPE bkpf-belnr,
  tmp_budat TYPE bkpf-budat,
  tmp_gjahr TYPE bkpf-gjahr.
*  tmp_lifnr TYPE lfa1-lifnr.   "avinash bhagat

TYPES:
  BEGIN OF t_accounting_doc_hdr,
    bukrs     TYPE bkpf-bukrs,
    belnr     TYPE bkpf-belnr,
    gjahr     TYPE bkpf-gjahr,
    blart     TYPE bkpf-blart,
    bldat     TYPE bkpf-bldat,
    budat     TYPE bkpf-budat,
    xblnr     TYPE bkpf-xblnr,
    bktxt     TYPE bkpf-bktxt,
    waers     TYPE bkpf-waers,
    kursf     TYPE bkpf-kursf,
    xblnr_alt TYPE bkpf-xblnr_alt,

    lifnr     TYPE lfa1-lifnr,
  END OF t_accounting_doc_hdr,
  tt_accounting_doc_hdr TYPE STANDARD TABLE OF t_accounting_doc_hdr.

TYPES:
  BEGIN OF t_accounting_doc_item,
    bukrs   TYPE bseg-bukrs,
    belnr   TYPE bseg-belnr,
    gjahr   TYPE bseg-gjahr,
    buzei   TYPE bseg-buzei,
    shkzg   TYPE bseg-shkzg,
    mwskz   TYPE bseg-mwskz,
    dmbtr   TYPE bseg-dmbtr,
    wrbtr   TYPE bseg-wrbtr,
    ktosl   TYPE bseg-ktosl,
    zuonr   TYPE bseg-zuonr,
    sgtxt   TYPE bseg-sgtxt,
    hkont   TYPE bseg-hkont,
    lifnr   TYPE bseg-lifnr,
    xbilk   TYPE bseg-xbilk,
    txgrp   TYPE bseg-txgrp,
    hsn_sac TYPE bseg-hsn_sac,
  END OF t_accounting_doc_item,
  tt_accounting_doc_item TYPE STANDARD TABLE OF t_accounting_doc_item.

TYPES:
  BEGIN OF t_bset,
    bukrs TYPE bset-bukrs,
    belnr TYPE bset-belnr,
    gjahr TYPE bset-gjahr,
    buzei TYPE bset-buzei,
    txgrp TYPE bset-txgrp,
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
  BEGIN OF t_bsec,
    bukrs TYPE bsec-bukrs,
    belnr TYPE bsec-belnr,
    gjahr TYPE bsec-gjahr,
    buzei TYPE bsec-buzei,
    name1 TYPE bsec-name1,
    name2 TYPE bsec-name2,
    name3 TYPE bsec-name3,
    name4 TYPE bsec-name4,
    pstlz TYPE bsec-pstlz,
    ort01 TYPE bsec-ort01,
    land1 TYPE bsec-land1,
    stras TYPE bsec-stras,
    regio TYPE bsec-regio,
    stcd3 TYPE bsec-stcd3,
  END OF t_bsec,
  tt_bsec TYPE STANDARD TABLE OF t_bsec.

TYPES:
  BEGIN OF t_ven_info,
    lifnr TYPE lfa1-lifnr,
    land1 TYPE lfa1-land1,
    name1 TYPE lfa1-name1,
    regio TYPE lfa1-regio,
    adrnr TYPE lfa1-adrnr,
    stcd3 TYPE lfa1-stcd3,
  END OF t_ven_info,
  tt_ven_info TYPE STANDARD TABLE OF t_ven_info.

TYPES:
  BEGIN OF t_adrc,
    addrnumber TYPE adrc-addrnumber,
    name1      TYPE adrc-name1,
    city2      TYPE adrc-city2,
    post_code1 TYPE adrc-post_code1,
    street     TYPE adrc-street,
    str_suppl3 TYPE adrc-str_suppl3,
    location   TYPE adrc-location,
    country    TYPE adrc-country,
  END OF t_adrc,
  tt_adrc TYPE STANDARD TABLE OF t_adrc.

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
  BEGIN OF t_j_1imovend,
    lifnr     TYPE j_1imovend-lifnr,
    ven_class TYPE dd07t-domvalue_l,
  END OF t_j_1imovend,
  tt_j_1imovend TYPE STANDARD TABLE OF t_j_1imovend.

TYPES:
  BEGIN OF t_dd07t,
    valpos     TYPE dd07t-valpos,
    ddtext     TYPE dd07t-ddtext,
    domvalue_l TYPE dd07t-domvalue_l,
  END OF t_dd07t,
  tt_dd07t TYPE STANDARD TABLE OF t_dd07t.

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
    gjahr      TYPE bkpf-gjahr,
    bldat      TYPE string, "char10, "bkpf-bldat,
    budat      TYPE string, "char10, "bkpf-budat,
    blart      TYPE bkpf-blart,
    xblnr_alt  TYPE bkpf-xblnr_alt,
    zuonr      TYPE bseg-zuonr,
    bktxt      TYPE bkpf-bktxt,
    xblnr      TYPE bkpf-xblnr,
    lifnr      TYPE bseg-lifnr, "avinash bhagat
*    lifnr type lfa1-lifnr,       "avinash bhagat
    name1      TYPE lfa1-name1,
    address    TYPE char100,
    ddtext     TYPE dd07t-ddtext,
    stcd3      TYPE lfa1-stcd3,
    gst_region TYPE zgst_region-gst_region,
    bezei      TYPE zgst_region-bezei,
    sgtxt      TYPE bseg-sgtxt,
    hsn_sac    TYPE bseg-hsn_sac,
    mwskz      TYPE t007s-mwskz,
    text1      TYPE t007s-text1,
    hwbas      TYPE bset-hwbas,  "char15, "
    waers      TYPE bkpf-waers,
    kursf      TYPE bkpf-kursf,
    fwbas      TYPE  bset-fwbas,                                        "           char15,
    vat_tax    TYPE  kwert,       "" ** VAT TAX                                    char15,
    cst_tax    TYPE  kwert,       "" ** CST TAX                                    char15,
    ser_val    TYPE  kwert,       "" ** Service Tax Value Credit                   char15,
    sbc        TYPE  kwert,       "" ** Swach Bharat Cess Credit                   char15,
    kkc        TYPE  kwert,       "" ** Krishi Kalyan Cess Credit                  char15,
    cgst_p     TYPE  prcd_elements-kbetr,              "CGST %                              char15,
    cgst       TYPE  prcd_elements-kwert,        "CGST                                      char15,
    sgst_p     TYPE  prcd_elements-kbetr,              "SGST %                              char15,
    sgst       TYPE  prcd_elements-kwert,        "SGST                                      char15,
    igst_p     TYPE  prcd_elements-kbetr,              "IGST %                              char15,
    igst       TYPE  prcd_elements-kwert,        "JOIG                                     char15,
    gst_amt    TYPE  prcd_elements-kwert,        "GST Total                                 char15,
    tot        TYPE  prcd_elements-kwert,        "Grand Total                               char15,
    saknr      TYPE skat-saknr,
    txt20      TYPE skat-txt20,
    status     TYPE string,
**    ref_date   TYPE string,
  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.
DATA:
  gt_final TYPE tt_final.

*-----------------for file Download---------------------------------------------------*
TYPES: BEGIN OF ty_final  ,
         belnr      TYPE string , "bkpf-belnr,
         gjahr      TYPE bkpf-gjahr,
         bldat      TYPE string, "char10, "bkpf-bldat,
         budat      TYPE string, "char10, "bkpf-budat,
         blart      TYPE bkpf-blart,
         xblnr_alt  TYPE bkpf-xblnr_alt,
         zuonr      TYPE bseg-zuonr,
         bktxt      TYPE bkpf-bktxt,
         xblnr      TYPE bkpf-xblnr,
         lifnr      TYPE bseg-lifnr, "avinash bhagat
*        lifnr type lfa1-lifnr,
         name1      TYPE lfa1-name1,
         address    TYPE char100,
         ddtext     TYPE dd07t-ddtext,
         stcd3      TYPE lfa1-stcd3,
         gst_region TYPE zgst_region-gst_region,
         bezei      TYPE zgst_region-bezei,
         sgtxt      TYPE bseg-sgtxt,
         hsn_sac    TYPE bseg-hsn_sac,
         mwskz      TYPE t007s-mwskz,
         text1      TYPE t007s-text1,
         hwbas      TYPE string, "bset-hwbas,
         waers      TYPE bkpf-waers,
         kursf      TYPE bkpf-kursf,
         fwbas      TYPE string, "bset-fwbas,
         vat_tax    TYPE string , " kwert,       "" ** VAT TAX
         cst_tax    TYPE string , "kwert,       "" ** CST TAX
         ser_val    TYPE string , "kwert,       "" ** Service Tax Value Credit
         sbc        TYPE string , "kwert,       "" ** Swach Bharat Cess Credit
         kkc        TYPE string , "kwert,       "" ** Krishi Kalyan Cess Credit
         cgst_p     TYPE string , "konv-kbetr,              "CGST %
         cgst       TYPE string , "konv-kwert,        "CGST
         sgst_p     TYPE string , "konv-kbetr,              "SGST %
         sgst       TYPE string , "konv-kwert,        "SGST
         igst_p     TYPE string , "konv-kbetr,              "IGST %
         igst       TYPE string , "konv-kwert,        "JOIG
         gst_amt    TYPE string , "konv-kwert,        "GST Total
         tot        TYPE string , "konv-kwert,        "Grand Total
         saknr      TYPE skat-saknr,
         txt20      TYPE skat-txt20,
         ref_date   TYPE string,
         status     TYPE string,
       END OF ty_final.

DATA: it_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final.



SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
  SELECT-OPTIONS: so_belnr FOR tmp_belnr,
                  so_budat FOR tmp_budat DEFAULT '20170401' TO sy-datum,
                  so_gjahr FOR tmp_gjahr DEFAULT '2017'.

*so_lifnr FOR tmp_lifnr.   "avinash bhagat


SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE abc .
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.

INITIALIZATION.
  xyz = 'Select Options'(tt1).
  abc = 'Download File'(tt2).

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
    ls_accounting_doc_item TYPE t_accounting_doc_item,
    ls_accounting_doc_itm1 TYPE t_accounting_doc_item,
    lt_bset                TYPE tt_bset,
    ls_bset                TYPE t_bset,
    lt_ven_info            TYPE tt_ven_info,
    ls_ven_info            TYPE t_ven_info,
    lt_adrc                TYPE tt_adrc,
    ls_adrc                TYPE t_adrc,
    lt_j_1imovend          TYPE tt_j_1imovend,
    ls_j_1imovend          TYPE t_j_1imovend,
    lt_dd07t               TYPE tt_dd07t,
    ls_dd07t               TYPE t_dd07t,
    lt_t005u               TYPE tt_t005u,
    ls_t005u               TYPE t_t005u,
    lt_zgst_region         TYPE tt_zgst_region,
    ls_zgst_region         TYPE t_zgst_region,
    lt_t007s               TYPE tt_t007s,
    ls_t007s               TYPE t_t007s,
    lt_skat                TYPE tt_skat,
    ls_skat                TYPE t_skat,
    ls_final               TYPE t_final,
    lv_index               TYPE sy-tabix,
    lt_bsec                TYPE tt_bsec,
    ls_bsec                TYPE t_bsec.

  DATA:
    lv_cgst TYPE bset-hwste,
    lv_sgst TYPE bset-hwste,
    lv_igst TYPE bset-hwste.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text       = 'Reading data...'(i01)
      percentage = 1.
*break primus.
  SELECT bukrs
         belnr
         gjahr
         blart
         bldat
         budat
         xblnr
         bktxt
         waers
         kursf
         xblnr_alt

    FROM bkpf
    INTO TABLE lt_accounting_doc_hdr
    WHERE belnr IN so_belnr
    AND   gjahr IN so_gjahr
    AND   budat IN so_budat
    AND   blart IN ('KG','KR','RE','RL','RX', 'KA', 'ZA') " Doc type KA added Pravin Adgokar   "ZA ADDED BY DIKSHA
    AND   tcode IN ('FB60','FB65','FV60','FV65','FBVB', 'FB08') " transaction FB08 added by Pravin Adgokar
    AND   bukrs = '1000'." ADDED BY MD

  IF NOT sy-subrc IS INITIAL.
    MESSAGE 'Data Not Found' TYPE 'E'.
  ENDIF.

  IF NOT lt_accounting_doc_hdr IS INITIAL.

    SELECT bukrs
           belnr
           gjahr
           buzei
           shkzg
           mwskz
           dmbtr
           wrbtr
           ktosl
           zuonr
           sgtxt
           hkont
           lifnr
           xbilk
           txgrp
           hsn_sac
      FROM bseg
      INTO TABLE lt_accounting_doc_item
      FOR ALL ENTRIES IN lt_accounting_doc_hdr
      WHERE belnr = lt_accounting_doc_hdr-belnr
      AND   gjahr = lt_accounting_doc_hdr-gjahr.
*      AND lifnr IN so_lifnr. "AVINASH BHAGAT

    SELECT bukrs
           belnr
           gjahr
           buzei
           txgrp
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

    SELECT lifnr
           land1
           name1
           regio
           adrnr
           stcd3
      FROM lfa1
      INTO TABLE lt_ven_info
      FOR ALL ENTRIES IN lt_accounting_doc_item
      WHERE lifnr = lt_accounting_doc_item-lifnr.
*      AND lifnr IN so_lifnr. "avinash bhagat


    IF NOT lt_ven_info IS INITIAL.
      SELECT lifnr
             ven_class
        FROM j_1imovend
        INTO TABLE lt_j_1imovend
        FOR ALL ENTRIES IN lt_ven_info
        WHERE lifnr = lt_ven_info-lifnr.
*        AND lifnr IN so_lifnr.  "avinash bhagat

      SELECT valpos
             ddtext
             domvalue_l
        FROM dd07t
        INTO TABLE lt_dd07t
        FOR ALL ENTRIES IN lt_j_1imovend
        WHERE domname    = 'J_1IGTAXKD'
        AND   domvalue_l = lt_j_1imovend-ven_class
        AND   ddlanguage = sy-langu.

      SELECT land1
             bland
             bezei
        FROM t005u
        INTO TABLE lt_t005u
        FOR ALL ENTRIES IN lt_ven_info
        WHERE land1 = lt_ven_info-land1
        AND   bland = lt_ven_info-regio.


***      SELECT gst_region
***           bezei
***      FROM zgst_region
***      INTO TABLE lt_zgst_region
***      FOR ALL ENTRIES IN lt_t005u
***      WHERE bezei = lt_t005u-bezei.

      SELECT addrnumber
             name1
             city2
             post_code1
             street
             str_suppl3
             location
             country
        FROM adrc
        INTO TABLE lt_adrc
        FOR ALL ENTRIES IN lt_ven_info
        WHERE addrnumber = lt_ven_info-adrnr.
    ENDIF.

    SELECT bukrs
           belnr
           gjahr
           buzei
           name1
           name2
           name3
           name4
           pstlz
           ort01
           land1
           stras
           regio
           stcd3
      FROM bsec
      INTO TABLE lt_bsec
      FOR ALL ENTRIES IN lt_accounting_doc_item
      WHERE bukrs = lt_accounting_doc_item-bukrs
      AND   belnr = lt_accounting_doc_item-belnr
      AND   gjahr = lt_accounting_doc_item-gjahr.

    IF NOT lt_bsec IS INITIAL.
      SELECT land1
           bland
           bezei
      FROM t005u
      APPENDING TABLE lt_t005u
      FOR ALL ENTRIES IN lt_bsec
      WHERE land1 = lt_bsec-land1
      AND   bland = lt_bsec-regio.

    ENDIF.
    SELECT gst_region
         bezei
    FROM zgst_region
    INTO TABLE lt_zgst_region
    FOR ALL ENTRIES IN lt_t005u
    WHERE bezei = lt_t005u-bezei.

  ENDIF.
*if so_lifnr is not INITIAL.
  lt_accounting_doc_itm1 = lt_accounting_doc_item.
  DELETE lt_accounting_doc_itm1 WHERE lifnr IS INITIAL.
*  ENDIF.

  SORT lt_accounting_doc_item BY belnr gjahr.
  SORT lt_bset BY belnr gjahr buzei txgrp.
  LOOP AT lt_accounting_doc_item INTO ls_accounting_doc_item WHERE ktosl = space.  "or ktosl = 'KBS' OR ktosl = 'WRX' OR ktosl = 'JIC' OR ktosl = 'JIS' OR ktosl = 'WIT' ."lifnr NE space.
*  LOOP AT lt_accounting_doc_item INTO ls_accounting_doc_item ."where lifnr = so_lifnr. " avinash bhagaT
    ls_final-belnr   = ls_accounting_doc_item-belnr.
    ls_final-gjahr   = ls_accounting_doc_item-gjahr.
    ls_final-hsn_sac = ls_accounting_doc_item-hsn_sac.
*    ls_final-lifnr   = ls_accounting_doc_item-lifnr.
***    ls_final-zuonr   = ls_accounting_doc_item-zuonr.
***    ls_final-sgtxt   = ls_accounting_doc_item-sgtxt.

    READ TABLE lt_accounting_doc_itm1 INTO ls_accounting_doc_itm1 WITH KEY belnr = ls_accounting_doc_item-belnr
                                                                           gjahr = ls_accounting_doc_item-gjahr.
    IF sy-subrc IS INITIAL.
      ls_final-lifnr   = ls_accounting_doc_itm1-lifnr.
      ls_final-zuonr   = ls_accounting_doc_itm1-zuonr.
      ls_final-sgtxt   = ls_accounting_doc_itm1-sgtxt.

*      ls_final-hsn_sac = ls_accounting_doc_item-hsn_sac.
    ENDIF.

    DATA :lv_status TYPE j_1imovend-j_1issist.
    CLEAR lv_status.
    SELECT SINGLE j_1issist INTO lv_status FROM j_1imovend WHERE lifnr = ls_final-lifnr.
    IF lv_status = '1'.
      ls_final-status = 'Micro'.
    ELSEIF lv_status = '2'.
      ls_final-status = 'Small'.
    ELSEIF lv_status = '3'.
      ls_final-status = 'Medium'.
    ELSEIF lv_status = '4'.
      ls_final-status = 'NA'.
    ENDIF.




    READ TABLE lt_accounting_doc_hdr INTO ls_accounting_doc_hdr WITH KEY belnr = ls_accounting_doc_item-belnr
                                                                         gjahr = ls_accounting_doc_item-gjahr.
    IF sy-subrc IS INITIAL.
*      CONCATENATE ls_accounting_doc_hdr-budat+6(2) ls_accounting_doc_hdr-budat+4(2) ls_accounting_doc_hdr-budat+0(4)
*        INTO ls_final-budat SEPARATED BY '-'.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_accounting_doc_hdr-budat
        IMPORTING
          output = ls_final-budat.
      IF ls_final-budat IS NOT INITIAL AND ls_final-budat NE '00000000' .
        CONCATENATE ls_final-budat+0(2) ls_final-budat+2(3) ls_final-budat+5(4)
                   INTO ls_final-budat SEPARATED BY '-'.
      ENDIF.


      IF ls_accounting_doc_hdr-bldat IS NOT INITIAL AND ls_accounting_doc_hdr-bldat NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_accounting_doc_hdr-bldat
          IMPORTING
            output = ls_final-bldat.

        CONCATENATE ls_final-bldat+0(2) ls_final-bldat+2(3) ls_final-bldat+5(4)
                     INTO ls_final-bldat SEPARATED BY '-'.
      ENDIF.

      ls_final-blart = ls_accounting_doc_hdr-blart.
      ls_final-xblnr_alt = ls_accounting_doc_hdr-xblnr_alt.
      ls_final-xblnr = ls_accounting_doc_hdr-xblnr.
      ls_final-bktxt = ls_accounting_doc_hdr-bktxt.
      ls_final-waers = ls_accounting_doc_hdr-waers.
      ls_final-kursf = ls_accounting_doc_hdr-kursf.
    ENDIF.

    READ TABLE lt_bsec INTO ls_bsec WITH KEY belnr = ls_accounting_doc_item-belnr
                                             gjahr = ls_accounting_doc_item-gjahr.
    IF sy-subrc IS INITIAL.
      ls_final-name1 = ls_bsec-name1.
      ls_final-stcd3 = ls_bsec-stcd3.

      IF NOT ls_bsec-name2 IS INITIAL.
        CONCATENATE ls_final-address ls_bsec-name2 INTO ls_final-address.
      ENDIF.

      IF NOT ls_bsec-name3 IS INITIAL.
        CONCATENATE ls_final-address ls_bsec-name3 INTO ls_final-address SEPARATED BY ','.
      ENDIF.

      IF NOT ls_bsec-name4 IS INITIAL.
        CONCATENATE ls_final-address ls_bsec-name4 INTO ls_final-address SEPARATED BY ','.
      ENDIF.

      IF NOT ls_bsec-pstlz IS INITIAL.
        CONCATENATE ls_final-address ls_bsec-pstlz INTO ls_final-address SEPARATED BY ', Pin:'.
      ENDIF.

      CONDENSE ls_final-address.
      READ TABLE lt_t005u INTO ls_t005u WITH KEY land1 = ls_bsec-land1
                                                 bland = ls_bsec-regio.
      IF sy-subrc IS INITIAL.
        ls_final-bezei = ls_t005u-bezei.
      ENDIF.
    ELSE.
      READ TABLE lt_ven_info INTO ls_ven_info WITH KEY lifnr = ls_accounting_doc_itm1-lifnr.
      IF sy-subrc IS INITIAL.
        ls_final-name1 = ls_ven_info-name1.
        ls_final-stcd3 = ls_ven_info-stcd3.
      ENDIF.
      READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_ven_info-adrnr.
      IF sy-subrc IS INITIAL.
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

      READ TABLE lt_t005u INTO ls_t005u WITH KEY land1 = ls_ven_info-land1
                                                 bland = ls_ven_info-regio.
      IF sy-subrc IS INITIAL.
        ls_final-bezei = ls_t005u-bezei.
      ENDIF.
    ENDIF.
    READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY bezei = ls_final-bezei.
    IF sy-subrc IS INITIAL.
      ls_final-gst_region = ls_zgst_region-gst_region.
    ENDIF.


    READ TABLE lt_j_1imovend INTO ls_j_1imovend WITH KEY lifnr = ls_final-lifnr.
    IF sy-subrc IS INITIAL.
      READ TABLE lt_dd07t INTO ls_dd07t WITH KEY domvalue_l = ls_j_1imovend-ven_class.
      IF sy-subrc IS INITIAL.
        ls_final-ddtext = ls_dd07t-ddtext.
      ENDIF.
    ENDIF.


**    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
**                                             gjahr = ls_accounting_doc_item-gjahr
**                                             kschl = 'JICG'.
**    IF sy-subrc IS INITIAL.
**      ls_final-hwbas   = ls_bset-hwbas.
**      ls_final-fwbas   = ls_bset-fwbas.
**      ls_final-cgst   = ls_bset-hwste.
**      ls_final-cgst_p = ls_bset-kbetr / 10.
**    ENDIF.
**
**    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
**                                             gjahr = ls_accounting_doc_item-gjahr
**                                             kschl = 'JISG'.
**    IF sy-subrc IS INITIAL.
**      ls_final-sgst   = ls_bset-hwste.
**      ls_final-sgst_p = ls_bset-kbetr / 10.
**    ENDIF.
**
**    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
**                                             gjahr = ls_accounting_doc_item-gjahr
**                                             kschl = 'JIIG'.
**    IF sy-subrc IS INITIAL.
**      ls_final-hwbas   = ls_bset-hwbas.
**      ls_final-fwbas   = ls_bset-fwbas.
**      ls_final-igst   = ls_bset-hwste.
**      ls_final-igst_p = ls_bset-kbetr / 10.
**    ENDIF.
**
**    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
**                                             gjahr = ls_accounting_doc_item-gjahr
**                                             kschl = 'JSER'.
**    IF sy-subrc IS INITIAL.
**      ls_final-hwbas   = ls_bset-hwbas.
**      ls_final-fwbas   = ls_bset-fwbas.
**      ls_final-ser_val   = ls_bset-hwste.
**    ENDIF.
**
**    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
**                                             gjahr = ls_accounting_doc_item-gjahr
**                                             kschl = 'JSSB'.
**    IF sy-subrc IS INITIAL.
**      ls_final-hwbas   = ls_bset-hwbas.
**      ls_final-fwbas   = ls_bset-fwbas.
**      ls_final-sbc     = ls_bset-hwste.
**
**    ENDIF.
**
**    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
**                                             gjahr = ls_accounting_doc_item-gjahr
**                                             kschl = 'JKKP'.
**    IF sy-subrc IS INITIAL.
**      ls_final-hwbas   = ls_bset-hwbas.
**      ls_final-fwbas   = ls_bset-fwbas.
**      ls_final-kkc     = ls_bset-hwste.
**
**    ENDIF.
**
**    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
**                                             gjahr = ls_accounting_doc_item-gjahr
**                                             kschl = 'JVCS'.
**    IF sy-subrc IS INITIAL.
**      ls_final-hwbas   = ls_bset-hwbas.
**      ls_final-fwbas   = ls_bset-fwbas.
**      ls_final-cst_tax   = ls_bset-hwste.
**
**    ENDIF.
**
**    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
**                                             gjahr = ls_accounting_doc_item-gjahr
**                                             kschl = 'JVRD'.
**    IF sy-subrc IS INITIAL.
**      ls_final-hwbas   = ls_bset-hwbas.
**      ls_final-fwbas   = ls_bset-fwbas.
**      ls_final-vat_tax = ls_bset-hwste.
**
**    ENDIF.
**    IF ls_final-hwbas IS INITIAL.
**      READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
**                                               gjahr = ls_accounting_doc_item-gjahr
**                                               kschl = space.
**      IF sy-subrc IS INITIAL.
**        ls_final-hwbas   = ls_bset-hwbas.
**        ls_final-fwbas   = ls_bset-fwbas.
**      ENDIF.
**    ENDIF.

    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
                                             gjahr = ls_accounting_doc_item-gjahr
                                             txgrp = ls_accounting_doc_item-txgrp.
    IF sy-subrc IS INITIAL.
      lv_index = sy-tabix.

      LOOP AT lt_bset INTO ls_bset FROM lv_index.
        IF ls_bset-belnr = ls_accounting_doc_item-belnr AND ls_bset-gjahr = ls_accounting_doc_item-gjahr
          AND ls_bset-txgrp = ls_accounting_doc_item-txgrp.

          CASE ls_bset-kschl.
            WHEN 'JICG' OR 'JICN' OR 'JICR' OR 'ZCRN'.
              IF ls_bset-kschl = 'JICG' OR ls_bset-kschl = 'JICN'.
                IF ls_bset-shkzg = 'S'.
                  ls_final-hwbas   = ls_final-hwbas + ls_bset-hwbas.
                  ls_final-fwbas   = ls_final-fwbas + ls_bset-fwbas.
                  ls_final-cgst    = ls_final-cgst + ls_bset-hwste.
                ELSE.
                  ls_final-hwbas   = ls_final-hwbas - ls_bset-hwbas.
                  ls_final-fwbas   = ls_final-fwbas - ls_bset-fwbas.
                  ls_final-cgst    = ls_final-cgst - ls_bset-hwste.
                ENDIF.
                IF NOT ls_bset-kbetr IS INITIAL.
                  ls_final-cgst_p  = ls_bset-kbetr / 10.
                  ls_final-mwskz = ls_bset-mwskz.
                ENDIF.
              ENDIF.
              IF ls_bset-shkzg = 'S'.
                lv_cgst = lv_cgst + ls_bset-hwste.
              ELSE.
                lv_cgst = lv_cgst - ls_bset-hwste.
              ENDIF.

            WHEN 'JISG' OR 'JISN' OR 'JISR' OR 'ZSRN'.
              IF ls_bset-kschl = 'JISG' OR ls_bset-kschl = 'JISN'.
**              ls_final-hwbas   = ls_final-hwbas + ls_bset-hwbas.
**              ls_final-fwbas   = ls_final-fwbas + ls_bset-fwbas.
                IF ls_bset-shkzg = 'S'.
                  ls_final-sgst    = ls_final-sgst + ls_bset-hwste.
                ELSE.
                  ls_final-sgst    = ls_final-sgst - ls_bset-hwste.
                ENDIF.
                IF NOT ls_bset-kbetr IS INITIAL.
                  ls_final-sgst_p  = ls_bset-kbetr / 10.
*              ls_final-mwskz = ls_bset-mwskz.
                ENDIF.
              ENDIF.
              IF ls_bset-shkzg = 'S'.
                lv_sgst = lv_sgst + ls_bset-hwste.
              ELSE.
                lv_sgst = lv_sgst - ls_bset-hwste.
              ENDIF.

            WHEN 'JIIG' OR 'JIIN' OR 'JIMD' OR 'ZIRN' OR 'JIIR'.
              IF ls_bset-kschl = 'JIIG' OR ls_bset-kschl = 'JIIN' OR ls_bset-kschl = 'JIMD'.
                IF ls_bset-shkzg = 'S'.
                  ls_final-hwbas   = ls_final-hwbas + ls_bset-hwbas.
                  ls_final-fwbas   = ls_final-fwbas + ls_bset-fwbas.
                  ls_final-igst    = ls_final-igst + ls_bset-hwste.
                ELSE.
                  ls_final-hwbas   = ls_final-hwbas - ls_bset-hwbas.
                  ls_final-fwbas   = ls_final-fwbas - ls_bset-fwbas.
                  ls_final-igst    = ls_final-igst - ls_bset-hwste.
                ENDIF.

                IF NOT ls_bset-kbetr IS INITIAL.
                  ls_final-igst_p  = ls_bset-kbetr / 10.
                  ls_final-mwskz = ls_bset-mwskz.
                ENDIF.
              ENDIF.
              IF ls_bset-shkzg = 'S'.
                lv_igst = lv_igst + ls_bset-hwste.
              ELSE.
                lv_igst = lv_igst - ls_bset-hwste.
              ENDIF.

            WHEN 'JSER'.
              IF ls_bset-shkzg = 'S'.
                ls_final-hwbas   = ls_final-hwbas   + ls_bset-hwbas.
                ls_final-fwbas   = ls_final-fwbas   + ls_bset-fwbas.
                ls_final-ser_val = ls_final-ser_val + ls_bset-hwste.
              ELSE.
                ls_final-hwbas   = ls_final-hwbas   - ls_bset-hwbas.
                ls_final-fwbas   = ls_final-fwbas   - ls_bset-fwbas.
                ls_final-ser_val = ls_final-ser_val - ls_bset-hwste.

              ENDIF.
              IF ls_final-mwskz IS INITIAL.
                ls_final-mwskz = ls_bset-mwskz.
              ENDIF.

            WHEN 'JSSB'.
*              ls_final-hwbas   = ls_final-hwbas  + ls_bset-hwbas.
*              ls_final-fwbas   = ls_final-fwbas  + ls_bset-fwbas.
              IF ls_bset-shkzg = 'S'.
                ls_final-sbc     = ls_final-sbc + ls_bset-hwste.
              ELSE.
                ls_final-sbc     = ls_final-sbc - ls_bset-hwste.
              ENDIF.
              IF ls_final-mwskz IS INITIAL.
                ls_final-mwskz = ls_bset-mwskz.
              ENDIF.
            WHEN 'JKKP'.
*              ls_final-hwbas   = ls_final-hwbas + ls_bset-hwbas.
*              ls_final-fwbas   = ls_final-fwbas + ls_bset-fwbas.
              IF ls_bset-shkzg = 'S'.
                ls_final-kkc     = ls_final-kkc + ls_bset-hwste.
              ELSE.
                ls_final-kkc     = ls_final-kkc - ls_bset-hwste.
              ENDIF.
              IF ls_final-mwskz IS INITIAL.
                ls_final-mwskz = ls_bset-mwskz.
              ENDIF.
            WHEN 'JVCS'.
              IF ls_final-hwbas IS INITIAL.
                IF ls_bset-shkzg = 'S'.
                  ls_final-hwbas   = ls_final-hwbas + ls_bset-hwbas.
                  ls_final-fwbas   = ls_final-fwbas + ls_bset-fwbas.
                ELSE.
                  ls_final-hwbas   = ls_final-hwbas - ls_bset-hwbas.
                  ls_final-fwbas   = ls_final-fwbas - ls_bset-fwbas.
                ENDIF.

              ENDIF.
              IF ls_bset-shkzg = 'S'.
                ls_final-cst_tax = ls_final-cst_tax + ls_bset-hwste.
              ELSE.
                ls_final-cst_tax = ls_final-cst_tax - ls_bset-hwste.
              ENDIF.

              IF ls_final-mwskz IS INITIAL.
                ls_final-mwskz = ls_bset-mwskz.
              ENDIF.
            WHEN 'JVRD'.
              IF ls_final-hwbas IS INITIAL.
                IF ls_bset-shkzg = 'S'.
                  ls_final-hwbas   = ls_final-hwbas + ls_bset-hwbas.
                  ls_final-fwbas   = ls_final-fwbas + ls_bset-fwbas.
                ELSE.
                  ls_final-hwbas   = ls_final-hwbas - ls_bset-hwbas.
                  ls_final-fwbas   = ls_final-fwbas - ls_bset-fwbas.
                ENDIF.

              ENDIF.
              IF ls_bset-shkzg = 'S'.
                ls_final-vat_tax = ls_final-vat_tax + ls_bset-hwste.
              ELSE.
                ls_final-vat_tax = ls_final-vat_tax - ls_bset-hwste.
              ENDIF.

              IF ls_final-mwskz IS INITIAL.
                ls_final-mwskz = ls_bset-mwskz.
              ENDIF.
          ENDCASE.
        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
    IF ls_final-mwskz IS INITIAL.
      ls_final-mwskz = ls_accounting_doc_item-mwskz.
    ENDIF.

    READ TABLE lt_t007s INTO ls_t007s WITH KEY mwskz = ls_final-mwskz.
    IF sy-subrc IS INITIAL.
      ls_final-text1 = ls_t007s-text1.
    ENDIF.

**    READ TABLE lt_accounting_doc_item INTO ls_accounting_doc_item WITH KEY belnr = ls_accounting_doc_hdr-belnr
**                                                                           gjahr = ls_accounting_doc_hdr-gjahr
**                                                                           xbilk = space.
**    IF sy-subrc IS INITIAL.
    ls_final-saknr   = ls_accounting_doc_item-hkont.

    READ TABLE lt_skat INTO ls_skat WITH KEY saknr = ls_accounting_doc_item-hkont.
    IF sy-subrc IS INITIAL.
      ls_final-txt20 = ls_skat-txt20.
    ENDIF.
***    ENDIF.
    IF ls_final-hwbas IS INITIAL.
      IF ls_accounting_doc_item-shkzg = 'S'.
        ls_final-hwbas = ls_accounting_doc_item-dmbtr.
        ls_final-fwbas = ls_accounting_doc_item-wrbtr.
      ELSE.
        ls_final-hwbas = ls_accounting_doc_item-dmbtr * -1.
        ls_final-fwbas = ls_accounting_doc_item-wrbtr * -1.

      ENDIF.
    ENDIF.

    SHIFT ls_final-saknr LEFT DELETING LEADING '0'.
    SHIFT ls_final-belnr LEFT DELETING LEADING '0'.
    SHIFT ls_final-xblnr_alt LEFT DELETING LEADING '0'.

    ls_final-gst_amt = ls_final-cgst + ls_final-sgst + ls_final-igst.
    ls_final-tot =
        ls_final-hwbas + ls_final-cst_tax + lv_cgst + lv_sgst + lv_igst
        + ls_final-ser_val + ls_final-sbc + ls_final-kkc + ls_final-vat_tax.


    APPEND ls_final TO ct_final.
    CLEAR:
      ls_final,ls_bset,ls_accounting_doc_item,ls_accounting_doc_itm1,ls_accounting_doc_hdr,
      ls_ven_info,ls_zgst_region,ls_t005u,ls_skat,lv_cgst,lv_sgst,lv_igst.

  ENDLOOP.

*BREAK primus.

  LOOP AT ct_final INTO ls_final.

    wa_final-belnr       = ls_final-belnr     .
    wa_final-gjahr       = ls_final-gjahr     .
    wa_final-bldat       = ls_final-bldat     .
    wa_final-budat       = ls_final-budat     .
    wa_final-blart       = ls_final-blart     .
    wa_final-xblnr_alt   = ls_final-xblnr_alt .
    wa_final-zuonr       = ls_final-zuonr     .
    wa_final-bktxt       = ls_final-bktxt     .
    wa_final-xblnr       = ls_final-xblnr     .
    wa_final-lifnr       = ls_final-lifnr     .
    wa_final-name1       = ls_final-name1     .
    wa_final-address     = ls_final-address   .
    wa_final-ddtext      = ls_final-ddtext    .
    wa_final-stcd3       = ls_final-stcd3     .
    wa_final-gst_region  = ls_final-gst_region.
    wa_final-bezei       = ls_final-bezei     .
    wa_final-sgtxt       = ls_final-sgtxt     .
    wa_final-hsn_sac     = ls_final-hsn_sac   .
    wa_final-mwskz       = ls_final-mwskz     .
    wa_final-text1       = ls_final-text1     .
    wa_final-hwbas       = ls_final-hwbas     .
    wa_final-waers       = ls_final-waers     .
    wa_final-kursf       = ls_final-kursf     .
    wa_final-fwbas       = ls_final-fwbas     .
    wa_final-vat_tax     = ls_final-vat_tax   .
    wa_final-cst_tax     = ls_final-cst_tax   .
    wa_final-ser_val     = ls_final-ser_val   .
    wa_final-sbc         = ls_final-sbc       .
    wa_final-kkc         = ls_final-kkc       .
    wa_final-cgst_p      = ls_final-cgst_p    .
    wa_final-cgst        = ls_final-cgst      .
    wa_final-sgst_p      = ls_final-sgst_p    .
    wa_final-sgst        = ls_final-sgst      .
    wa_final-igst_p      = ls_final-igst_p    .
    wa_final-igst        = ls_final-igst      .
    wa_final-gst_amt     = ls_final-gst_amt   .
    wa_final-tot         = ls_final-tot       .
    wa_final-saknr       = ls_final-saknr     .
    wa_final-txt20       = ls_final-txt20     .
    wa_final-status      = ls_final-status     .

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = wa_final-ref_date.

    CONCATENATE wa_final-ref_date+0(2) wa_final-ref_date+2(3) wa_final-ref_date+5(4)
               INTO wa_final-ref_date SEPARATED BY '-'.

*    *------------------Refreshable Date / Shift negative sign to left logic ------------------------------------------

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = wa_final-fwbas.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = wa_final-hwbas.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = wa_final-gst_amt.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING value = wa_final-tot.


    APPEND wa_final TO it_final.

*  CLEAR : wa_final , ls_final .

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM display  USING    ct_final TYPE tt_final.

  IF p_down = 'X'.
    PERFORM download.
**    PERFORM gui_download.
  ELSE.
    DATA:
      lt_fieldcat     TYPE slis_t_fieldcat_alv,
      ls_alv_layout   TYPE slis_layout_alv,
      l_callback_prog TYPE sy-repid.

    l_callback_prog = sy-repid.

    PERFORM prepare_display CHANGING lt_fieldcat.
    CLEAR ls_alv_layout.
    ls_alv_layout-zebra = 'X'.
    ls_alv_layout-colwidth_optimize = 'X'.


    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program      = l_callback_prog
*       I_CALLBACK_PF_STATUS_SET          = ' '
        i_callback_user_command = 'UCOMM_ON_ALV'
*       I_CALLBACK_TOP_OF_PAGE  = ' '
        is_layout               = ls_alv_layout
        it_fieldcat             = lt_fieldcat
      TABLES
        t_outtab                = ct_final
      EXCEPTIONS
        program_error           = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
*  BREAK primus.

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
  ls_fieldcat-fieldname = 'GJAHR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Fiscal Year'(100).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BLDAT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Doc.Date'(101).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BUDAT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Posting Date'(130).
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
  ls_fieldcat-fieldname = 'XBLNR_ALT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Invoice No.'(103).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZUONR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Original Doc.No.'(103).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BKTXT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Original Doc.Dt.'(103).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'XBLNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Vendor Invoice No.'(104).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LIFNR'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Vendor Code'(105).
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
  ls_fieldcat-fieldname = 'ADDRESS'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Address'(128).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'DDTEXT'.
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
  ls_fieldcat-seltext_m = 'GSTIN No.'(108).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'GST_REGION'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'State Code'(109).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BEZEI'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'State Name'(110).
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

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MWSKZ'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Tax Code'(113).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
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

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FWBAS'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Basic Amount(DC) '(115).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
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

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KURSF'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Exchange Rate'(117).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
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

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VAT_TAX'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'VAT'(131).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'CST_TAX'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'CST'(132).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SER_VAL'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Service Tax'(129).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SBC'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Swatch Bharat Cess'(130).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KKC'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Krushi Kalyan Cess'(130).
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
  ls_fieldcat-fieldname = 'GST_AMT'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Total GST Amt.'(125).
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
  ls_fieldcat-seltext_m = 'GR Ledger Code'(126).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TXT20'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'GR Ledger Description'(127).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STATUS'.
*  ls_fieldcat-outputlen = '5'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'MSME Status'.
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
    lv_bukrs TYPE bkpf-bukrs VALUE '1000'.

  CASE r_ucomm.
    WHEN '&IC1'. "for double click
      IF rs_selfield-fieldname = 'BELNR'.
        READ TABLE gt_final INTO ls_final INDEX rs_selfield-tabindex.

        SET PARAMETER ID 'BLN' FIELD rs_selfield-value.
        SET PARAMETER ID 'BUK' FIELD lv_bukrs."s_bukrs-low.
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

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_final                "gt_final
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
  lv_file = 'ZPUR_REG_FI.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPUR_REG_FI Download started on', sy-datum, 'at', sy-uzeit.
  WRITE: / 'Dest. File:', lv_fullfile.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.

  IF sy-subrc = 0.
    DATA lv_string_263 TYPE string.
    DATA lv_crlf_263 TYPE string.

*    TRANSFER hd_csv TO lv_fullfile.

    lv_crlf_263   = cl_abap_char_utilities=>cr_lf.
    lv_string_263 = hd_csv.

    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_263  lv_crlf_263   wa_csv INTO lv_string_263 .
      CLEAR: wa_csv.
    ENDLOOP.

    TRANSFER lv_string_263 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.







*  IF sy-subrc = 0.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.

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
  CONCATENATE 'Accounting Doc.No.'
              'Fiscal Year'
              'Doc.Date'
              'Posting Date'
              'FI Doc.Type'
              'Invoice No.'
              'Original Doc.No.'
              'Original Doc.Dt.'
              'Vendor Invoice No.'
              'Vendor Code'
              'Name'
              'Address'
              'REGD/URD/SEZ/DEEMED/GOV'
              'GSTIN No.'
              'State Code'
              'State Name'
              'Description'
              'HSN/SAC'
              'Tax Code'
              'Tax Code Description'
              'Basic Amount(DC)'
              'Currency'
              'Exchange Rate'
              'Basic Amount(LC)'
              'VAT'
              'CST'
              'Service Tax'
              'Swatch Bharat Cess'
              'Krushi Kalyan Cess'
**              'KKC'
              'CGST%'
              'CGST'
              'SGST%'
              'SGST'
              'IGST%'
              'IGST'
              'GST Amt.'
              'Total Amt.'
              'GR Ledger Code'
              'GR Ledger Description'
              'Refreshable Date'
              'MSME Status'
              INTO pd_csv
  SEPARATED BY l_field_seperator.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GUI_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM gui_download .

  DATA file TYPE string VALUE 'D:\PURCHASE.TXT'.
  TYPES : BEGIN OF ls_fieldname,
            field_name(25),
          END OF ls_fieldname.
  DATA : it_fieldname TYPE TABLE OF ls_fieldname.
  DATA : wa_fieldname TYPE ls_fieldname.

*------------Heading------------------------
  wa_fieldname-field_name = 'Accounting Doc.No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Fiscal Year'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Doc.Date'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Posting Date'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'FI Doc.Type'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Original Doc.No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Original Doc.Dt'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Vendor Invoice No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Invoice No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Vendor Code'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Name'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Address'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'REGD/URD/SEZ/DEEMED/GOV'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GSTIN No'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'State Code'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'State Name'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Description'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'HSN/SAC'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Tax Code'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Tax Code Description'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Basic Amount(DC)'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Currency'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Exchange Rate'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Basic Amount(LC)'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'VAT'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'CST'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Service Tax'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Swatch Bharat Cess'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Krushi Kalyan Cess'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'KKC'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'CGST%'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'CGST'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'SGST%'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'SGST'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'IGST%'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'IGST'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GST Amt'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Total Amt'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GR Ledger Code'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Refreshable Date'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'GR Ledger Description'.
  APPEND wa_fieldname TO it_fieldname.



*--------------------------------------------------------------------*

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE            =
      filename                = file
      filetype                = 'ASC'
*     APPEND                  = ' '
      write_field_separator   = 'X'
*     HEADER                  = '00'
    TABLES
      data_tab                = it_final
      fieldnames              = it_fieldname
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.




ENDFORM.
