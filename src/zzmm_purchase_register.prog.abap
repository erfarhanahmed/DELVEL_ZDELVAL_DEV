*&---------------------------------------------------------------------*
*& REPORT  ZMM_PURCHASE_REGISTER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zzmm_purchase_register.
** TABLES DECLARATION
*TABLES : bkpf,bseg,bset,makt,rseg,lfa1."ZKPT_FI_BSEG.
"TYPE-POOLS : slis.
*INCLUDE : zclsalv, Z_CLASSES.
INCLUDE zzmm_purchase_register_cls.

TYPES : BEGIN OF t_bkpf,
          bukrs   TYPE bukrs,  " Company Code
          belnr   TYPE belnr_d, " Accounting Document Number
          gjahr   TYPE gjahr,  " Fiscal Year
          blart   TYPE blart,  " Document Type
          bldat   TYPE bldat,  " Document Date in Document
          budat   TYPE budat,  " Posting Date in the Document
          xblnr   TYPE xblnr1, " Reference Document Number
          awkey   TYPE awkey,  " Reference Key
          g_belnr TYPE belnr_d, " GR INV NO/ Acct Doc nO.
          g_gjahr TYPE gjahr,   " GR INV YEAR/ aAcct Doc Fiscal Year
        END OF t_bkpf,

        BEGIN OF t_bkpfr,
          belnr TYPE belnr_d, " Accounting Document Number
          blart TYPE blart,  " Document Type
          stblg	TYPE stblg,  " Reverse Document Number
        END OF t_bkpfr,

        BEGIN OF t_rseg,
          belnr  TYPE belnr_d,
          gjahr  TYPE gjahr,
          buzei  TYPE rblgp,  " Document Item in Invoice Document
          ebeln  TYPE ebeln,  " Purchasing Document Number
          ebelp  TYPE ebelp,  " Item Number of Purchasing Document
          matnr  TYPE matnr,  " Material Number
          bukrs  TYPE bukrs,  " Company Code
          wrbtr  TYPE wrbtr,  " Amount in Document Currency
          shkzg  TYPE shkzg,  " Debit/Credit Indicator
          mwskz  TYPE mwskz,  " Sales Tax Code
          kschl  TYPE kschl,  " CONDITION TYPE IN RSEG
          bnkan	 TYPE bnk_anteil, "	Delivery costs' share of item value
          lfbnr  TYPE lfbnr,  " Reference Document
          lfpos  TYPE lfpos,  " REFERENCE DOCUMENET ITEM
          lifnr  TYPE lifnr,  " Account Number of Vendor or Creditor
          kursf  TYPE kursf,  " Exchange rate
          name1  TYPE name1_gp, " Vendor Name
          bukrs1 TYPE bukrs,  " Company Code
          belnr1 TYPE belnr_d, " Accounting Document Number
          gjahr1 TYPE gjahr,  " Accounting Document Fiscal Year
          count1 TYPE txgrp,
        END OF t_rseg,

        BEGIN OF t_lfa1,
          lifnr LIKE lfa1-lifnr,
          name1 LIKE lfa1-name1,
          adrnr TYPE adrnr,
        END OF t_lfa1,

        BEGIN OF t_adrc,
          addrnumber TYPE ad_addrnum, " Address number
          city1      TYPE ad_city1,   " City
          post_code1 TYPE ad_pstcd1,  " City Postal Code
          street     TYPE ad_street,  " Street
          str_suppl1 TYPE ad_strspp1,                     " Street 2
          str_suppl2 TYPE ad_strspp2,                     " Street 3
        END OF t_adrc,

        BEGIN OF t_bset,
          bukrs TYPE bukrs,    " Company Code
          belnr TYPE belnr_d,  " Accounting Document Number
          gjahr TYPE gjahr,    " Fiscal Year
          buzei TYPE buzei,    " Number of Line Item Within Accounting Document
          "txgrp(4) TYPE n, " LIKE BSET-TXGRP, "GR INVOICE ITEM
          txgrp TYPE txgrp,    " Group Indicator for Tax Line Items
          shkzg TYPE shkzg,    " DEBIT/CREDIT INDICATOR
          mwskz TYPE mwskz,      " Sales Tax Code
          hwbas TYPE hwbas_bses, " Tax base amount in local currency
          hwste TYPE hwste,      " Tax Amount in Local Currency
          ktosl TYPE ktosl,      " Transaction Key
          kschl TYPE kschl,      " Condition Type
          kbetr TYPE kbetr_tax,  " Tax Rate
          count TYPE sy-tabix,
        END OF t_bset,

        BEGIN OF t_bseg,
          bukrs TYPE bukrs,   " Company Code
          belnr TYPE belnr_d, " Accounting Document Number
          gjahr TYPE gjahr,   " Fiscal Year
          buzei TYPE buzei,   " Number of Line Item Within Accounting Document
          buzid TYPE buzid,   " Identification of the Line Item
          bschl	TYPE bschl,   "	Posting Key
          koart	TYPE koart,   "	Account Type
          shkzg TYPE shkzg,   " Debit/Credit Indicator
          mwskz TYPE mwskz,   " Sales Tax Code
          dmbtr TYPE dmbtr,   " Amount in Local Currency
          ktosl	TYPE ktosl,   "	Transaction Key
          hkont TYPE hkont,   " General Ledger Account
          lifnr TYPE lifnr,   " Account Number of Vendor or Creditor
          ebeln TYPE ebeln,   " Purchasing Document
          ebelp TYPE ebelp,   " Item Number of Purchasing Doc
          tbtkz	TYPE tbtkz,   " Indicator: Subsequent Debit/Credit
        END OF t_bseg,

        BEGIN OF t_ekbe,
          buzei LIKE ekbe-buzei,
          lfbnr LIKE ekbe-lfbnr,
          lfpos LIKE rseg-lfpos,
        END OF t_ekbe,

        BEGIN OF t_bsik,
          bukrs LIKE bsik-bukrs,
          gjahr LIKE bsik-gjahr,
          buzei LIKE bsik-buzei,
          belnr LIKE bsik-belnr,
          stceg LIKE bsik-stceg,
          dmbtr LIKE bsik-dmbtr,
          mwsts LIKE bsik-mwsts,
          mwsk1 LIKE bsik-mwsk1,
        END OF t_bsik,

*        BEGIN OF t_lfc1,
*          bukrs LIKE lfc1-bukrs,
*          lifnr LIKE lfc1-lifnr,
*          gjahr LIKE lfc1-gjahr,
*          erdat LIKE lfc1-erdat,
*       END OF t_lfc1,

        BEGIN OF t_j_1imovend,
          lifnr     LIKE j_1imovend-lifnr,
          j_1icstno TYPE j_1icstno,  " Central Sales Tax Number
          j_1ilstno TYPE j_1ilstno,  " Local Sales Tax Number
          j_1isern  TYPE j_1isern,   " Service Tax Registration Number
        END OF t_j_1imovend,

        BEGIN OF t_r_rseg,
          belnr LIKE rseg-belnr,
          gjahr LIKE rseg-gjahr,
        END OF t_r_rseg,

        BEGIN OF t_ekko,
          ebeln TYPE ebeln,
          lifnr TYPE elifn,  " Vendor Account Number
          ekorg TYPE ekorg,  " Purchasing Organization
          bedat TYPE bedat,  " Purchase Doc Date
          knumv TYPE knumv,
        END OF t_ekko,

        BEGIN OF t_konv,
          knumv LIKE prcd_elements-knumv,
          kschl LIKE prcd_elements-kschl,
          kwert LIKE prcd_elements-kwert,
        END OF t_konv,

        BEGIN OF t_purtxt,
          saknr TYPE saknr,       " G/L Account Number
          txt20 TYPE txt20_skat,  " G/L account short text,
        END OF t_purtxt,

        BEGIN OF t_t007s,
          mwskz TYPE mwskz,       " Sales Tax Code
          text1 TYPE text1_007s,  " Name for value-added tax
        END OF t_t007s,

        BEGIN OF t_final,
          bukrs     TYPE bukrs,       " Company Code
          budat     TYPE bldat,       " DOC DATE
          belnr     TYPE belnr_d,     " Acct. DOCUMENT NO
          gjahr     TYPE gjahr,       " FISCAL YEAR
          ebeln     TYPE ebeln,       " PO
          bedat     TYPE bedat,       " Purchase Doc Date
          grnno     TYPE lfbnr,       " GRN No.
          "belnr_b    TYPE belnr_d,
*         g_belnr    type belnr_d,     "MIRO INVOICE NO
          awkey_inv TYPE char10,
          invdt     TYPE datum,       " Invoice Date
*         erdat      TYPE erdat,
          lifnr     TYPE lifnr,       " VENDOR
          name1     TYPE name1_gp,    " VENDOR NAME
          addrs     TYPE char100,     " Vendor Address
          vatcst    TYPE char40,      " VAT/CST No.
          tindt     TYPE char10,       " TIN No. Effect Date
          hkont     TYPE hkont,       " GL A/C / Purchase Ledger
          pur_text  TYPE txt20_skat,  " Pur. Ledger Description
          gross     TYPE kwert,       " GROSS TOTAL / Basic Amount
          pack_fwd  TYPE kwert,       " PFwd
          asval     TYPE kwert,       " Assessible Value
          bed       TYPE kwert,       " BED/ Excise Duty
          ecs       TYPE kwert,       " ECESS SETOFF
          shcess    TYPE kwert,       " SHCESS
          acd       TYPE kwert,       " ADD CUSTM DUTY/ Add duty on CVD
          gross_tot TYPE kwert,       " SubTotal
          mwsk1     TYPE text1_007s,  " Tax Code Name/ Tax Type
          mwskz     TYPE mwskz,       " Sales Tax Code
          mwsk2     TYPE char6,      " VAT/CST %
          mwsts     TYPE mwsts,       " Tax Amount
          sertax    TYPE kwert,        " SERVICE TAX
          esertax   TYPE kwert,        " ECESS ON SERVICE TAX
          hsertax   TYPE kwert,        " HE-CESS ON SERVICE TAX
          freight   TYPE kwert,        " Freight
          other     TYPE kwert,       " Other Amount
          gross_amt TYPE kwert,       " Gross Amount
*         buzei      type RBLGP,        "MIRO INVOICE ITEM
          inv_gros  TYPE kwert,       "Invoice Total
        END OF t_final,

        BEGIN OF  t_summry,
          hkont     TYPE hkont,       " GL A/C / Purchase Ledger
          pur_text  TYPE txt20_skat,  " Pur. Ledger Description
          mwsk1     TYPE text1_007s,  " Tax Code Name/ Tax Type
          mwskz     TYPE mwskz,       " Sales Tax Code
          mwsk2     TYPE char10,      " VAT/CST %
          gross     TYPE kwert,       " GROSS TOTAL / Basic Amount
          pack_fwd  TYPE kwert,       " PFwd
          asval     TYPE kwert,       " Assessible Value
          bed       TYPE kwert,       " BED/ Excise Duty
          ecs       TYPE kwert,       " ECESS SETOFF
          shcess    TYPE kwert,       " SHCESS
          acd       TYPE kwert,       " ADD CUSTM DUTY/ Add duty on CVD
          gross_tot TYPE kwert,       " SubTotal
*         mwsk1      type TEXT1_007S,  " Tax Code Name/ Tax Type
*         mwskz      type mwskz,       " Sales Tax Code
*         mwsk2      type char10,      " VAT/CST %
          mwsts     TYPE mwsts,       " Tax Amount
          sertax    TYPE kwert,        " SERVICE TAX
          esertax   TYPE kwert,        " ECESS ON SERVICE TAX
          hsertax   TYPE kwert,        " HE-CESS ON SERVICE TAX
          freight   TYPE kwert,        " Freight
          other     TYPE kwert,       " Other Amount
          gross_amt TYPE kwert,       " Gross Amount
*         buzei      type RBLGP,        "MIRO INVOICE ITEM
        END OF t_summry.

DATA : BEGIN OF params,
         gjahr TYPE RANGE OF gjahr,
         budat TYPE RANGE OF budat,
       END OF params.

DATA : wa_bkpf       TYPE t_bkpf,
       wa_bkpfr      TYPE t_bkpfr,
       wa_rseg       TYPE t_rseg,
       wa_lfa1       TYPE t_lfa1,
       wa_adrc       TYPE t_adrc,
       wa_bset       TYPE t_bset,
       wa_bseg       TYPE t_bseg,
       wa_ekbe       TYPE t_ekbe,
       wa_bsik       TYPE t_bsik,
*        wa_lfc1       TYPE t_lfc1,
       wa_j_1imovend TYPE t_j_1imovend,
       wa_r_rseg     TYPE t_r_rseg,
       wa_ekko       TYPE t_ekko,
       wa_purtxt     TYPE t_purtxt,
       wa_taxnam     TYPE t_t007s,
       wa_konv       TYPE t_konv,
       wa_final      TYPE t_final,
       wa_summry     TYPE t_summry,

       it_bkpf       TYPE TABLE OF t_bkpf,
       it_bkpfr      TYPE TABLE OF t_bkpfr,
       it_rseg       TYPE TABLE OF t_rseg,
       it_lfa1       TYPE TABLE OF t_lfa1,
       it_adrc       TYPE TABLE OF t_adrc,
       it_bset       TYPE TABLE OF t_bset,
       it_bseg       TYPE TABLE OF t_bseg,
       it_ekbe       TYPE TABLE OF t_ekbe,
       it_bsik       TYPE TABLE OF t_bsik,
*        it_lfc1 TYPE TABLE OF t_lfc1,
       it_j_1imovend TYPE TABLE OF t_j_1imovend,
       it_r_rseg     TYPE TABLE OF t_r_rseg,
       it_ekko       TYPE TABLE OF t_ekko,
       it_purtxt     TYPE TABLE OF t_purtxt,
       it_taxnam     TYPE TABLE OF t_t007s,
       it_konv       TYPE TABLE OF t_konv,
       it_final      TYPE TABLE OF t_final,
       it_summry     TYPE TABLE OF t_summry,

       l_lfpos(4)    TYPE c,
       i             TYPE sy-tabix,
       i_1           TYPE txgrp.

DATA: wa_text       TYPE text1_007s,
      wa_1          TYPE text1_007s,
      wa_2          TYPE text1_007s,
      wa_flag       TYPE c,
      wa_cst        TYPE c,
      wa_vat        TYPE c,
      wa_ser        TYPE c,
      wa_flag_lifnr TYPE c,
      wa_gross      TYPE kwert,
      wa_lifnr      TYPE lifnr,
      wa_lifnr_bseg TYPE lifnr,
      v_flag        TYPE c,
      v_grnno       TYPE lfbnr.

DATA: it_rseg_ekko TYPE TABLE OF t_rseg,

      alv_obj      TYPE REF TO cl_salv_table,

      wf_alv_dt    TYPE REF TO lcl_salv,
      wf_alv_sm    TYPE REF TO lcl_salv,
      lv_handler   TYPE REF TO lcl_salv_event_handler,

      ucomm        TYPE sy-ucomm.

CONSTANTS : c_x VALUE 'X'.

DEFINE reset_column_title.
  CALL METHOD &1->reset_column_title
    EXPORTING
      i_column = &2
      i_lbl_s  = &3
      i_lbl_m  = &4
      i_lbl_l  = &5
      i_tltip  = &6.
END-OF-DEFINITION.

**SELECTION-SCREEN
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : "S_BUKRS FOR BKPF-BUKRS,
                 "S_BELNR FOR BKPF-BELNR,
                 s_gjahr FOR wa_bkpf-gjahr,
                 s_budat FOR wa_bkpf-budat OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS : p_prchrg TYPE c RADIOBUTTON GROUP g1,
             p_ejvreg TYPE c RADIOBUTTON GROUP g1,
             p_crntrg TYPE c RADIOBUTTON GROUP g1,
             p_dbntrg TYPE c RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN ON s_gjahr.
  IF s_gjahr-high IS NOT INITIAL AND s_gjahr-low EQ ' '.
    MESSAGE 'ENTER FISCAL YEAR' TYPE 'E'.
  ENDIF.

INITIALIZATION.
  CREATE OBJECT lv_handler.

START-OF-SELECTION.
*&---------------------------------------------------------------------*
*& SUBROUTINE TO PROCESS REPORT DATA.
*&---------------------------------------------------------------------*
  PERFORM process_data.
  PERFORM determine_summary.

END-OF-SELECTION.
  IF NOT it_final IS INITIAL.
    CALL SCREEN 0101.
  ENDIF.

*&---------------------------------------------------------------------*
*&      FORM  PROCESS_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM process_data .

  DATA : flg_negamounts TYPE c.

*GET DATA FROM BKPF TABLE
  PERFORM get_accounting_docs.

* Fetch Accounting info
  PERFORM get_accouting_info.

*  SELECT  bukrs
*          gjahr
*          buzei
*          belnr
*          stceg
*          dmbtr
*          mwsts
*          mwsk1
*    FROM bsik
*    INTO CORRESPONDING FIELDS OF TABLE it_bsik
*    WHERE "BUKRS IN S_BUKRS AND
*         "BELNR IN S_BELNR AND
*         gjahr IN s_gjahr AND
*         budat IN s_budat AND
*        ( blart = 'KR' OR blart = 'RE' OR blart = 'KA').


* Get Miro Invoice Item Details,vendor And Vendor Name
  PERFORM fetch_invc_related_info.

* Get Tax Data
  PERFORM get_tax_info.


  PERFORM get_vendor_details.

* Adding Records To Final Internal Table
  LOOP AT it_bkpf INTO wa_bkpf.
    wa_final-bukrs = wa_bkpf-bukrs.
    wa_final-budat = wa_bkpf-budat.
    wa_final-belnr = wa_bkpf-belnr.
    wa_final-gjahr = wa_bkpf-gjahr.
    "wa_final-belnr_b =  wa_bkpf-xblnr.
*    wa_final-awkey_inv = wa_bkpf-awkey+0(10).
    wa_final-awkey_inv = wa_bkpf-xblnr.
    wa_final-invdt = wa_bkpf-bldat.

    CLEAR v_grnno.

    SELECT SINGLE rmwwr FROM rbkp INTO wa_final-inv_gros
      WHERE belnr = wa_bkpf-g_belnr
        AND gjahr = wa_bkpf-g_gjahr.

    LOOP AT it_rseg INTO wa_rseg WHERE belnr = wa_bkpf-g_belnr
                                   AND gjahr = wa_bkpf-g_gjahr.
      IF wa_rseg-count1 = '001'.
        v_grnno = wa_rseg-lfbnr.
        IF NOT v_grnno IS INITIAL.
          ." Get GRN date info
        ENDIF.

        wa_final-ebeln = wa_rseg-ebeln.
        wa_final-grnno = v_grnno.
***        IF wa_rseg-kschl IS INITIAL.    "--Jayant19.07.2017
***          wa_final-gross = wa_rseg-wrbtr.
***        ENDIF.
        wa_final-lifnr = wa_rseg-lifnr.
        wa_final-mwskz = wa_rseg-mwskz.
        "wa_final-kursf = wa_rseg-kursf.
*        wa_final-freight = wa_rseg-bnkan.

        READ TABLE it_ekko INTO wa_ekko WITH KEY ebeln = wa_rseg-ebeln.
        IF sy-subrc = 0.
          wa_final-bedat = wa_ekko-bedat.  " Purchase Doc Date
        ENDIF.

        LOOP AT it_bset INTO wa_bset WHERE bukrs = wa_bkpf-bukrs
                                        AND belnr = wa_bkpf-belnr
                                        AND gjahr = wa_bkpf-gjahr.
*                                        AND txgrp = wa_rseg-count1.
*                                           buzei = wa_bseg-buzei.

          IF wa_bset-shkzg = 'H'.
            wa_bset-hwste = wa_bset-hwste * ( -1 ).
          ENDIF.

          CASE wa_bset-kschl.
            WHEN 'JMOP'.
              wa_final-bed = wa_final-bed + wa_bset-hwste.
*                it_final-bedrate = it_bset-kbetr / 10.
            WHEN 'JEC1' OR 'ZECS'.
              wa_final-ecs = wa_final-ecs + wa_bset-hwste.
            WHEN 'JEC2'.
*                wa_final-ebed = wa_bset-hwste.
            WHEN 'JVRD'.
*                wa_final-rmded = wa_bset-hwste.
              wa_final-mwsts = wa_final-mwsts + wa_bset-hwste.
              wa_vat = 'X'.
            WHEN 'JVRN'.
*                wa_final-rmnon = wa_bset-hwste.
            WHEN 'JVCD'.
*                wa_final-cgded = wa_bset-hwste.
            WHEN 'JVCN'.
*                wa_final-cgnon = wa_bset-hwste.
            WHEN 'JIPC'.   "'JVCS' OR
              wa_final-mwsts = wa_final-mwsts + wa_bset-hwste.
*               wa_final-cst = wa_bset-hwste.
*               wa_final-cstrate = wa_bset-kbetr / 10.
              wa_cst = 'X'.
            WHEN 'JSTX' OR 'ZSTX'.
*                wa_final-sertax = wa_bset-hwste.
            WHEN 'JEC5'.
*                wa_final-esertax = wa_bset-hwste.
            WHEN 'JSEP'.
              wa_final-shcess = wa_final-shcess + wa_bset-hwste.
*                wa_final-shrate = wa_bset-kbetr / 10.
            WHEN 'JAIP' OR 'JAIQ' OR 'JAOP' OR 'JAOQ'.
              wa_final-acd = wa_final-acd + wa_bset-hwste.
          ENDCASE.
          CLEAR wa_bset.
        ENDLOOP.
      ENDIF.

      IF wa_rseg-kschl = 'ZPC1' OR
         wa_rseg-kschl = 'ZPFL' OR
         wa_rseg-kschl = 'ZPFV' .
        wa_final-pack_fwd = wa_final-pack_fwd + ( wa_rseg-wrbtr * wa_rseg-kursf ).
*      elseIF wa_rseg-kschl = 'FRA1' OR
*         wa_rseg-kschl = 'FRB1' OR
*         wa_rseg-kschl = 'FRC1' .
*         wa_final-freight = wa_final-freight +
*                            ( wa_rseg-wrbtr * wa_rseg-kursf ).
      ELSEIF wa_rseg-kschl = 'JCDB'.
*          wa_final-BASCUS = wa_rseg-wrbtr * wa_final-kursf.
      ELSEIF wa_rseg-kschl = 'JCZ2'.
*          wa_final-ECUSTOM = wa_rseg-wrbtr * wa_final-kursf.
      ENDIF.

      CLEAR : wa_rseg, v_grnno.
    ENDLOOP.

    LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bkpf-belnr.
      CASE wa_bseg-ktosl.
        WHEN 'WRX' OR 'ANL'.
          wa_final-hkont = wa_bseg-hkont.
          wa_final-mwskz = wa_bseg-mwskz.
          IF p_prchrg = c_x AND ( wa_bseg-bschl = '86' OR wa_bseg-bschl = '70' ).
            wa_final-gross = wa_final-gross + wa_bseg-dmbtr.
          ENDIF.
        WHEN 'FR1' OR 'FR2'.
          IF wa_final-hkont IS INITIAL.
            wa_final-hkont = wa_bseg-hkont.
          ENDIF.
          wa_final-freight = wa_final-freight + wa_bseg-dmbtr.
        WHEN 'ESE' OR 'ESA'.
          wa_final-sertax = wa_final-sertax + wa_bseg-dmbtr.
          wa_ser = 'X'.
        WHEN 'ES1'.
          wa_final-esertax = wa_final-esertax + wa_bseg-dmbtr.
        WHEN 'ES2'.
          wa_final-hsertax = wa_final-hsertax + wa_bseg-dmbtr.
        WHEN 'KBS' OR 'ZR1'.     " OR 'BSX'.
          IF wa_bseg-bschl = '40'.
            wa_final-other = wa_final-other + wa_bseg-dmbtr.
          ENDIF.
          IF wa_bseg-bschl = '50'.
            wa_final-other = wa_final-other - wa_bseg-dmbtr.
          ENDIF.
        WHEN 'BSX'.
          IF wa_bseg-bschl = '89'.
            wa_final-other = wa_final-other + wa_bseg-dmbtr.
          ENDIF.
          IF wa_bseg-bschl = '99'.
            wa_final-other = wa_final-other - wa_bseg-dmbtr.
          ENDIF.
*        WHEN 'ZR1'.
*          IF wa_bseg-bschl = '40'.
*            wa_final-other = wa_final-other + wa_bseg-dmbtr.
*          ENDIF.
        WHEN ''.
          IF ( p_ejvreg = c_x AND wa_bseg-bschl = '40')
            OR ( p_crntrg = c_x AND wa_bseg-bschl = '40')
            OR ( p_dbntrg = c_x AND wa_bseg-bschl = '50').
            wa_final-hkont = wa_bseg-hkont.
            wa_final-mwskz = wa_bseg-mwskz.
            wa_final-gross = wa_final-gross + wa_bseg-dmbtr.
          ENDIF.
      ENDCASE.

      IF wa_bseg-bschl = '31' OR wa_bseg-bschl = '21'.
        wa_final-lifnr = wa_bseg-lifnr.
      ENDIF.

      CLEAR wa_bseg.
    ENDLOOP.

    IF wa_final-hkont IS NOT INITIAL.
**      READ TABLE it_purtxt INTO wa_purtxt WITH KEY saknr = wa_final-hkont.
**      IF sy-subrc = 0.
**        wa_final-pur_text = wa_purtxt-txt20.
**      ENDIF.
      DATA ls_skat TYPE skat.
      CLEAR ls_skat.
      SELECT SINGLE * FROM skat INTO ls_skat
        WHERE spras = sy-langu
          AND ktopl = '1000'
          AND saknr = wa_final-hkont.
      wa_final-pur_text = ls_skat-txt50.
    ENDIF.

*******************************************************************************
*    IF p_dbntrg = c_x and wa_bkpf-blart <> 'KG'.
*      clear wa_bseg.
*      read table it_bseg into wa_bseg with key belnr = wa_final-belnr
*                                              koart = 'K'
*                                              shkzg = 'S'.
*      IF sy-subrc = 0.
*        wa_final-gross    = wa_final-gross    * -1.
*        wa_final-pack_fwd = wa_final-pack_fwd * -1.
*        wa_final-bed      = wa_final-bed      * -1.
*        wa_final-ecs      = wa_final-ecs      * -1.
*        wa_final-shcess   = wa_final-shcess   * -1.
*        wa_final-acd      = wa_final-acd      * -1.
*        wa_final-freight  = wa_final-freight  * -1.
*        wa_final-sertax   = wa_final-sertax   * -1.
*        wa_final-esertax  = wa_final-esertax  * -1.
*        wa_final-hsertax  = wa_final-hsertax  * -1.
*        wa_final-mwsts    = wa_final-mwsts    * -1.
*
*      ENDIF.
*    ENDIF.
*
*    wa_final-asval = wa_final-gross + wa_final-pack_fwd.
*    wa_final-gross_tot = wa_final-asval + wa_final-bed + wa_final-ecs
*                        + wa_final-shcess + wa_final-acd.
*
*    wa_final-gross_amt = wa_final-gross_tot + wa_final-freight
*                        + wa_final-sertax   + wa_final-esertax
*                        + wa_final-hsertax  + wa_final-mwsts.
*******************************************************************************

    " Vendor related info
    CLEAR wa_lfa1.
    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_final-lifnr.
    IF sy-subrc = 0.
      wa_final-name1 = wa_lfa1-name1.
      IF NOT wa_lfa1-adrnr IS INITIAL.
        CLEAR wa_adrc.
        READ TABLE it_adrc INTO wa_adrc WITH KEY addrnumber = wa_lfa1-adrnr.
        IF sy-subrc = 0.
          CONCATENATE wa_adrc-str_suppl1 wa_adrc-str_suppl2
            wa_adrc-street wa_adrc-city1 wa_adrc-post_code1
            INTO wa_final-addrs SEPARATED BY ','.
        ENDIF.
      ENDIF.
    ENDIF.

    CLEAR wa_bset.
    READ TABLE it_bset INTO wa_bset WITH KEY belnr = wa_final-belnr.
    IF sy-subrc = 0.
      wa_final-mwskz = wa_bset-mwskz.
      CASE wa_bset-ktosl.
        WHEN 'JP4'.
          wa_cst = 'X'.
          wa_final-mwsts = wa_bset-hwste.
*        WHEN 'JP5'.
*          wa_vat = 'X'.
*          wa_final-mwsts = wa_bset-hwste.
        WHEN OTHERS.
      ENDCASE.
    ENDIF.

    CLEAR wa_j_1imovend.
    READ TABLE it_j_1imovend INTO wa_j_1imovend
      WITH KEY lifnr = wa_final-lifnr.
    IF sy-subrc = 0.
      IF wa_j_1imovend IS NOT INITIAL.
        IF wa_cst = 'X'.
          wa_final-vatcst = wa_j_1imovend-j_1icstno.
        ELSEIF wa_vat = 'X'.
          wa_final-vatcst = wa_j_1imovend-j_1ilstno.
        ELSEIF wa_ser = 'X'.
          wa_final-vatcst = wa_j_1imovend-j_1isern.
        ELSE. " condition added till usr confirms to remove it
          wa_final-vatcst = wa_j_1imovend-j_1ilstno.
        ENDIF.

        IF wa_final-vatcst IS NOT INITIAL AND wa_final-vatcst CS '/'.
          SPLIT wa_final-vatcst AT '/'
            INTO wa_final-vatcst wa_final-tindt.
        ENDIF.
      ENDIF.
    ENDIF.

    "///////////???????????
*    clear wa_lfc1.
*    READ TABLE it_lfc1 INTO wa_lfc1
*      WITH KEY "bukrs = wa_rseg-bukrs1
*               lifnr = wa_final-lifnr
*               gjahr = wa_bkpf-gjahr.
*    IF sy-subrc = 0.
*      wa_final-erdat = wa_lfc1-erdat.
*    ENDIF.
    "///////////???????????

*    READ TABLE it_bsik INTO wa_bsik
*      WITH KEY bukrs = wa_rseg-bukrs1
*              belnr = wa_rseg-belnr1
*              gjahr = wa_rseg-gjahr1.
*    IF sy-subrc EQ 0.
**        MOVE wa_bsik-dmbtr TO wa_final-dmbtr.
**        MOVE wa_bsik-mwsts TO wa_final-mwsts.
*    ENDIF.

    IF wa_final-mwskz IS NOT INITIAL."wa_cst = 'X' OR wa_vat = 'X'.
      READ TABLE it_taxnam INTO wa_taxnam
        WITH KEY mwskz = wa_final-mwskz.
      IF sy-subrc = 0.
        wa_final-mwsk1 = wa_taxnam-text1.
        wa_text = wa_taxnam-text1.
        "SPLIT wa_text AT '@ ' INTO wa_1 wa_final-mwsk2 .
        FIND REGEX '([0-9]+([/.][0-9]+)?%)' IN wa_text
         SUBMATCHES wa_final-mwsk2.
      ENDIF.
    ENDIF.


    " Final amounts
    IF p_dbntrg = c_x AND wa_bkpf-blart <> 'KG'.
      CLEAR wa_bseg.
      READ TABLE it_bseg INTO wa_bseg WITH KEY belnr = wa_final-belnr
                                              koart = 'K'
                                              shkzg = 'S'.
      IF sy-subrc = 0.
        wa_final-gross    = wa_final-gross    * -1.
        wa_final-pack_fwd = wa_final-pack_fwd * -1.
        wa_final-bed      = wa_final-bed      * -1.
        wa_final-ecs      = wa_final-ecs      * -1.
        wa_final-shcess   = wa_final-shcess   * -1.
        wa_final-acd      = wa_final-acd      * -1.
        wa_final-freight  = wa_final-freight  * -1.
        wa_final-sertax   = wa_final-sertax   * -1.
        wa_final-esertax  = wa_final-esertax  * -1.
        wa_final-hsertax  = wa_final-hsertax  * -1.
        wa_final-mwsts    = wa_final-mwsts    * -1.

      ENDIF.
    ENDIF.

    wa_final-asval = wa_final-gross + wa_final-pack_fwd.
    wa_final-gross_tot = wa_final-asval + wa_final-bed + wa_final-ecs
                        + wa_final-shcess + wa_final-acd.

    wa_final-gross_amt = wa_final-gross_tot + wa_final-freight
                        + wa_final-sertax   + wa_final-esertax
                        + wa_final-hsertax  + wa_final-mwsts
                        + wa_final-other.


    APPEND wa_final TO it_final.
    CLEAR : wa_final, wa_rseg, wa_cst, wa_vat, wa_ser, wa_taxnam,
            wa_1, wa_text, wa_final, wa_bkpf.
  ENDLOOP.
ENDFORM.                    " PROCESS_DATA

FORM display_results .
  DATA : container_obj TYPE REF TO cl_gui_custom_container,
         splitter_obj  TYPE REF TO cl_gui_splitter_container,
         container_1   TYPE REF TO cl_gui_container,
         container_2   TYPE REF TO cl_gui_container,
         wf_alv_obj    TYPE REF TO cl_salv_table,
         wf_alv_obj1   TYPE REF TO cl_salv_table.

  CREATE OBJECT container_obj
    EXPORTING
      container_name              = 'CSTM_CTRL'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    CREATE OBJECT splitter_obj
      EXPORTING
        parent            = container_obj
        rows              = 2
        columns           = 1
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      " Container to display PO records
      CALL METHOD splitter_obj->get_container
        EXPORTING
          row       = 1
          column    = 1
        RECEIVING
          container = container_1.

      PERFORM create_alv USING container_1
                               it_final
                         CHANGING wf_alv_obj.

      CREATE OBJECT wf_alv_dt
        EXPORTING
          i_alv_obj       = wf_alv_obj
          i_set_all       = c_x
          i_set_optimized = c_x.

      PERFORM set_salv_view USING wf_alv_dt 'DETL'.
      "-----------------------------------------------------------------------
      " Container for Summary Table display
      CALL METHOD splitter_obj->get_container
        EXPORTING
          row       = 2
          column    = 1
        RECEIVING
          container = container_2.
      CLEAR wf_alv_obj1.

      PERFORM create_alv USING container_2
                               it_summry
                         CHANGING wf_alv_obj1.


      CREATE OBJECT wf_alv_sm
        EXPORTING
          i_alv_obj       = wf_alv_obj1
          i_set_all       = c_x
          i_set_optimized = c_x.

      PERFORM set_salv_view USING wf_alv_sm 'SMRY'.

      PERFORM display_contents CHANGING wf_alv_dt  wf_alv_sm.
    ENDIF.
  ENDIF.
ENDFORM.                    " DISPLAY_RESULTS

*&---------------------------------------------------------------------*
*&      Form  set_detail_salv_view
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM set_salv_view USING wf_alv TYPE REF TO lcl_salv
                        p_list  TYPE char4.
  DATA : lv_title TYPE lvc_title.
  IF p_list = 'DETL'.
    CASE c_x.
      WHEN p_prchrg.  lv_title = TEXT-004.
      WHEN p_ejvreg.  lv_title = TEXT-005.
      WHEN p_crntrg.  lv_title = TEXT-006.
      WHEN p_dbntrg.  lv_title = TEXT-007.
    ENDCASE.
    wf_alv->display_company_header( i_title = lv_title ).

    " Set Totals for the columns
    wf_alv->set_total( 'GROSS' ).
    wf_alv->set_total( 'PACK_FWD' ).
    wf_alv->set_total( 'ASVAL' ).
    wf_alv->set_total( 'BED' ).
    wf_alv->set_total( 'ECS' ).
    wf_alv->set_total( 'SHCESS' ).
    wf_alv->set_total( 'ACD' ).
    wf_alv->set_total( 'GROSS_TOT' ).
    wf_alv->set_total( 'MWSTS' ).
    wf_alv->set_total( 'SERTAX' ).
    wf_alv->set_total( 'ESERTAX' ).
    wf_alv->set_total( 'HSERTAX' ).
    wf_alv->set_total( 'FREIGHT' ).
    wf_alv->set_total( 'GROSS_AMT').

  ELSEIF p_list = 'SMRY'.
    wf_alv->set_title( i_title = TEXT-076 ).

    " Set Totals for the columns
    wf_alv->set_total( 'GROSS' ).
    wf_alv->set_total( 'PACK_FWD' ).
    wf_alv->set_total( 'ASVAL' ).
    wf_alv->set_total( 'BED' ).
    wf_alv->set_total( 'ECS' ).
    wf_alv->set_total( 'SHCESS' ).
    wf_alv->set_total( 'ACD' ).
    wf_alv->set_total( 'GROSS_TOT' ).
    wf_alv->set_total( 'MWSTS' ).
    wf_alv->set_total( 'SERTAX' ).
    wf_alv->set_total( 'ESERTAX' ).
    wf_alv->set_total( 'HSERTAX' ).
    wf_alv->set_total( 'FREIGHT' ).
    wf_alv->set_total( 'OTHER' ).
    wf_alv->set_total( 'GROSS_AMT').

    " Subtotals
    wf_alv->set_sort( i_column = 'HKONT'
                       i_subtot = if_salv_c_bool_sap=>true ).
  ENDIF.

  " Set event handlers
  wf_alv->get_events( ).


  SET HANDLER lv_handler->handle_double_click FOR wf_alv->events.

  reset_column_title :
     wf_alv  'BUDAT'   'VHR. DATE' 'VHR. DATE' 'VHR. DATE' 'VHR. DATE'  "TEXT-011
    , wf_alv 'BELNR'   'ACC DOC' 'ACC DOC' 'ACC DOC' 'ACC DOC'          "TEXT-015
    , wf_alv 'BEDAT'   'PO Date' 'PO Date' 'PO Date' 'PO Date'          "TEXT-049 TEXT-049 TEXT-049 TEXT-049
    , wf_alv 'GRNNO'   'GRN No' 'GRN No' 'GRN No' 'GRN No'              "TEXT-050 TEXT-050 TEXT-050 TEXT-050
    , wf_alv 'BELNR_B' 'BKPF_XBLNR' 'BKPF_XBLNR' 'BKPF_XBLNR' 'BKPF_XBLNR'
    , wf_alv 'AWKEY_INV' 'INV DOC' 'INV DOC' 'INV DOC' 'INV DOC'   "TEXT-018 TEXT-019 TEXT-020 TEXT-020
    , wf_alv 'INVDT'      'Invoice Dt' 'Invoice Dt' 'Invoice Dt' 'Invoice Dt' " TEXT-075 TEXT-074 TEXT-074 TEXT-074
    , wf_alv 'ERDAT'   'ERDAT' 'ERDAT' 'ERDAT' 'ERDAT'
    , wf_alv 'LIFNR'   'ACC DOC' 'ACC DOC' 'ACC DOC' 'ACC DOC' "TEXT-023 TEXT-023  TEXT-023  TEXT-023
    , wf_alv 'NAME1'   'Name' 'Name' 'Name' 'Name'             "TEXT-022 TEXT-022 TEXT-022 TEXT-022
    , wf_alv 'ADDRS'   'Address' 'Address' 'Address' 'Address'        "TEXT-051 TEXT-051 TEXT-051 TEXT-051
    , wf_alv 'VATCST'  'VATTIN/CST' 'VATTIN/CST' 'VATTIN/CST' 'VATTIN/CST'   "TEXT-012 TEXT-013 TEXT-014 TEXT-014
    , wf_alv 'TINDT'    'TINNoEffDt' 'TINNoEffDt' 'TINNoEffDt' 'TINNoEffDt'  "TEXT-052 TEXT-053 TEXT-054 TEXT-054
    , wf_alv 'HKONT'  'PUR.LEDGER' 'PUR.LEDGER' 'PUR.LEDGER' 'PUR.LEDGER'    "TEXT-024 TEXT-024 TEXT-024 TEXT-024
    , wf_alv 'PUR_TEXT'  'PURLDGRTxt'  'PURLDGRTxt'  'PURLDGRTxt'  'PURLDGRTxt'  "TEXT-025 TEXT-026 TEXT-027 TEXT-027
    , wf_alv 'GROSS'   'Basic Amt' 'Basic Amt' 'Basic Amt' 'Basic Amt'     "TEXT-028 TEXT-028 TEXT-028 TEXT-028
    , wf_alv 'PACK_FWD' 'PFwd' 'PFwd' 'PFwd' 'PFwd'                        " TEXT-029 TEXT-029 TEXT-029 TEXT-029
    , wf_alv 'ASVAL'   'Assess Val' 'Assess Val' 'Assess Val' 'Assess Val'  "  TEXT-055 TEXT-056 TEXT-057 TEXT-057
    , wf_alv 'BED'     'BSC EX DTY' 'BSC EX DTY' 'BSC EX DTY' 'BSC EX DTY'    " TEXT-030 TEXT-031 TEXT-032 TEXT-032
    , wf_alv 'ECS'     'ECESS' 'ECESS' 'ECESS' 'ECESS'                        "TEXT-036 TEXT-037 TEXT-037 TEXT-037
    , wf_alv 'SHCESS'  'SEC H.ECSS' 'SEC H.ECSS' 'SEC H.ECSS' 'SEC H.ECSS'    "TEXT-033 TEXT-034 TEXT-035 TEXT-035
    , wf_alv 'ACD'     'AddCstmDut' 'AddCstmDut' 'AddCstmDut' 'AddCstmDut'    "TEXT-059 TEXT-058 TEXT-060 TEXT-060
    , wf_alv 'GROSS_TOT'  'SubTot' 'SubTot' 'SubTot' 'SubTot'
*    , wf_alv 'GROSS_AMT'  'Gross Amt' 'Gross Amt' 'Gross Amt' 'Gross Amt'     "TEXT-038 TEXT-038 TEXT-038 TEXT-038
    , wf_alv 'MWSK1'      'Tax Type' 'Tax Type' 'Tax Type' 'Tax Type'         "  TEXT-061 TEXT-061 TEXT-061 TEXT-061
    , wf_alv 'MWSK2'  'VAT/CST %' 'VAT/CST %' 'VAT/CST %' 'VAT/CST %'         "  TEXT-073 TEXT-073 TEXT-073 TEXT-073
    , wf_alv 'MWSKZ'  'Tax Code' 'Tax Code' 'Tax Code' 'Tax Code'             " TEXT-062 TEXT-062 TEXT-062 TEXT-062
    , wf_alv 'MWSTS'  'Tax Amount' 'Tax Amount' 'Tax Amount' 'Tax Amount'     " TEXT-039 TEXT-039 TEXT-039 TEXT-039

    , wf_alv 'SERTAX'   'ServiceTax' 'ServiceTax' 'ServiceTax' 'ServiceTax'   "  TEXT-063 TEXT-064 TEXT-064 TEXT-064
    , wf_alv 'ESERTAX'  'ECS SerTax' 'ECS SerTax' 'ECS SerTax' 'ECS SerTax'   "   TEXT-065 TEXT-066 TEXT-067 TEXT-067
    , wf_alv 'HSERTAX'  'HCS SerTax' 'HCS SerTax' 'HCS SerTax' 'HCS SerTax'   " TEXT-068 TEXT-069 TEXT-070 TEXT-071
    , wf_alv 'FREIGHT'  'Freight' 'Freight' 'Freight' 'Freight'               "TEXT-072 TEXT-072 TEXT-072 TEXT-072
    , wf_alv 'OTHER'    'Diff/Other' 'Diff/Others' 'Diff/Others' 'Diff/Others'
    , wf_alv 'GROSS_AMT' 'Gross Amt' 'Gross Amt' 'Gross Amt' 'Gross Amt'      "  TEXT-046 TEXT-047 TEXT-047 TEXT-047
    , wf_alv 'INV_GROS'  'Inv.Tot' 'Inv.Tot' 'Inv.Tot' 'Inv.Tot'
  .

  wf_alv->hide_column( 'INV_GROS' ).

ENDFORM.                    " SET_DETAIL_SALV_VIEW

*&---------------------------------------------------------------------*
*&      Form  DETERMINE_SUMMARY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM determine_summary .
  DATA :lv_hkont TYPE hkont,
        lv_mwskz TYPE mwskz.

  SORT it_final BY hkont mwskz.
  LOOP AT it_final INTO wa_final.
    IF lv_hkont <> wa_final-hkont OR lv_mwskz <> wa_final-mwskz.
      IF NOT wa_summry IS INITIAL." not lv_hkont is initial .
        APPEND wa_summry TO it_summry.
        CLEAR : wa_summry, lv_hkont, lv_mwskz.
      ENDIF.

      lv_hkont = wa_final-hkont.
      lv_mwskz = wa_final-mwskz.
      wa_summry-hkont     = wa_final-hkont    .
      wa_summry-pur_text  = wa_final-pur_text .
      wa_summry-mwsk1     = wa_final-mwsk1    .
      wa_summry-mwskz     = wa_final-mwskz    .
      wa_summry-mwsk2     = wa_final-mwsk2    .
    ENDIF.

    wa_summry-gross     = wa_summry-gross     + wa_final-gross    .
    wa_summry-pack_fwd  = wa_summry-pack_fwd  + wa_final-pack_fwd .
    wa_summry-asval     = wa_summry-asval     + wa_final-asval    .
    wa_summry-bed       = wa_summry-bed       + wa_final-bed      .
    wa_summry-ecs       = wa_summry-ecs       + wa_final-ecs      .
    wa_summry-shcess    = wa_summry-shcess    + wa_final-shcess   .
    wa_summry-acd       = wa_summry-acd       + wa_final-acd      .
    wa_summry-gross_tot = wa_summry-gross_tot + wa_final-gross_tot.
    wa_summry-mwsts     = wa_summry-mwsts     + wa_final-mwsts    .
    wa_summry-sertax    = wa_summry-sertax    + wa_final-sertax   .
    wa_summry-esertax   = wa_summry-esertax   + wa_final-esertax  .
    wa_summry-hsertax   = wa_summry-hsertax   + wa_final-hsertax  .
    wa_summry-freight   = wa_summry-freight   + wa_final-freight  .
    wa_summry-gross_amt = wa_summry-gross_amt + wa_final-gross_amt.

    CLEAR wa_final.
  ENDLOOP.
  IF NOT wa_summry IS INITIAL." not lv_hkont is initial .
    APPEND wa_summry TO it_summry.
    CLEAR : wa_summry, lv_hkont, lv_mwskz.
  ENDIF.
  SORT it_final BY belnr ebeln.
  SORT it_summry BY hkont mwskz.
ENDFORM.                    " DETERMINE_SUMMARY

FORM display_contents CHANGING p_alv_dt TYPE REF TO lcl_salv
                              p_alv_sm TYPE REF TO lcl_salv.

  DATA : container_h TYPE REF TO cl_gui_docking_container,
         container_f TYPE REF TO cl_gui_docking_container,

         hdr_obj     TYPE REF TO cl_salv_form_dydos.
*         ftr_obj TYPE REF TO cl_salv_form_dydos.

  PERFORM create_doc_container
    USING cl_gui_docking_container=>dock_at_top
          50
    CHANGING container_h. " for header

*  perform create_doc_container
*    USING cl_gui_docking_container=>dock_at_bottom
*          75
*    CHANGING container_f. " For footer
  " Display Headers
  CREATE OBJECT hdr_obj
    EXPORTING
      r_container = container_h
      r_content   = p_alv_dt->alv_hdr.
  hdr_obj->display( ).

  " Display ALVs
  p_alv_dt->display( ).
  p_alv_sm->display( ).

*  " Display Footer
*  create object ftr_obj
*    exporting
*      r_container = container_f
*      r_content   = p_alv_sm->alv_ftr.
*
*  ftr_obj->display( ).
ENDFORM.

FORM create_alv USING p_container   TYPE REF TO cl_gui_container
                      p_tab         TYPE table
                CHANGING p_alv_obj TYPE REF TO cl_salv_table.
  TRY .
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          r_container  = p_container
        IMPORTING
          r_salv_table = p_alv_obj
        CHANGING
          t_table      = p_tab.
    CATCH cx_salv_msg.
      MESSAGE 'Error in displaying ALV' TYPE 'I'.
      EXIT.
  ENDTRY.

ENDFORM.

FORM create_doc_container USING p_side    TYPE i
                                p_height  TYPE i
                          CHANGING p_container TYPE REF TO
                                cl_gui_docking_container.
  CREATE OBJECT p_container
    EXPORTING
      side                        = p_side
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF NOT p_height IS INITIAL.
    CALL METHOD p_container->set_height
      EXPORTING
        height = p_height.
  ENDIF.
ENDFORM.

MODULE display_results OUTPUT.
  PERFORM display_results.
ENDMODULE.                 " DISPLAY_RESULTS  OUTPUT

MODULE handle_user_command INPUT.
  CASE ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                 " HANDLE_USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*&      Module  SET_PF_STATUS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_pf_status OUTPUT.
  SET TITLEBAR 'ZPUR_REG'.
  SET PF-STATUS 'ZPUR_REG'.
ENDMODULE.                 " SET_PF_STATUS  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  GET_ACCOUNTING_DOCS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_accounting_docs .
  DATA : condstr TYPE string.

  CLEAR condstr.

  CASE c_x.
    WHEN p_prchrg.
      condstr = 'blart = ''RE'''.
    WHEN p_ejvreg.
      condstr = 'blart = ''KR'' AND tcode = ''FB60'''.
    WHEN p_crntrg.
      condstr = 'blart = ''KR'' AND tcode = ''FB65'''.
    WHEN p_dbntrg.
      condstr = 'blart = ''KG'' AND tcode = ''FB65'''.
  ENDCASE.

  SELECT bukrs
         belnr
         gjahr
         blart
         bldat
         budat
         xblnr
         awkey
    FROM bkpf
    INTO TABLE it_bkpf
    WHERE "BUKRS IN S_BUKRS AND
          "BELNR IN S_BELNR AND
        gjahr IN s_gjahr AND
        budat IN s_budat AND
        (condstr).

  CLEAR condstr.

  IF p_dbntrg = c_x OR p_crntrg = c_x.
    PERFORM add_miro_docs.
  ENDIF.

  " Filter documents reversed
  PERFORM filter_reversed_docs.

  LOOP AT it_bkpf INTO wa_bkpf.
    wa_bkpf-g_belnr = wa_bkpf-awkey+0(10).
    wa_bkpf-g_gjahr = wa_bkpf-awkey+10(4).
*    IF sy-subrc EQ 0.  "--Jayant 3/7/17
    MODIFY it_bkpf FROM wa_bkpf TRANSPORTING g_belnr g_gjahr.
*    ENDIF.             "--Jayant 3/7/17
    CLEAR wa_bkpf.
  ENDLOOP.

ENDFORM.                    " GET_ACCOUNTING_DOCS
*&---------------------------------------------------------------------*
*&      Form  FETCH_INVC_RELATED_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_invc_related_info .
  IF it_bkpf IS NOT INITIAL.
    SELECT  a~belnr
            a~gjahr
            a~buzei
            a~ebeln
            a~ebelp
            a~matnr
            a~bukrs
            a~wrbtr
            a~shkzg
            a~mwskz
            a~kschl
            a~bnkan
            a~lfbnr
            a~lfpos
            b~lifnr
            b~kursf
            c~name1
      INTO TABLE it_rseg
      FROM rseg AS a
        INNER JOIN rbkp AS b ON a~belnr = b~belnr
        LEFT OUTER JOIN lfa1 AS c ON b~lifnr = c~lifnr
      FOR ALL ENTRIES IN it_bkpf
      WHERE a~belnr = it_bkpf-g_belnr AND
            a~gjahr = it_bkpf-g_gjahr.
    IF sy-subrc = 0.
      PERFORM get_pur_order_info.

      LOOP AT it_rseg INTO wa_rseg.

        IF wa_rseg-shkzg = 'H'.
          wa_rseg-wrbtr = wa_rseg-wrbtr * ( -1 ).
          MODIFY it_rseg FROM wa_rseg TRANSPORTING wrbtr.
        ENDIF.

        READ TABLE it_bkpf INTO wa_bkpf WITH KEY g_belnr = wa_rseg-belnr
                                                 g_gjahr = wa_rseg-gjahr.
        IF sy-subrc EQ 0.
          wa_rseg-bukrs1 = wa_bkpf-bukrs.
          wa_rseg-belnr1 = wa_bkpf-belnr.
          wa_rseg-gjahr1 = wa_bkpf-gjahr.
          MODIFY it_rseg FROM wa_rseg TRANSPORTING bukrs1 belnr1 gjahr1.
        ENDIF.

        READ TABLE it_ekbe INTO wa_ekbe WITH KEY lfbnr = wa_rseg-lfbnr
                                                 lfpos = wa_rseg-lfpos.
        IF sy-subrc EQ 0.
          wa_rseg-lfpos = wa_ekbe-buzei.
          MODIFY it_rseg FROM wa_rseg TRANSPORTING lfpos.
        ENDIF.

        IF wa_rseg-lfpos = 0.
          READ TABLE it_bset INTO wa_bset WITH KEY belnr = wa_rseg-belnr1
                                      bukrs = wa_rseg-bukrs1
                                      gjahr = wa_rseg-gjahr1.
          IF sy-subrc EQ 0.
            l_lfpos = wa_rseg-buzei+2(4).
            wa_rseg-lfpos = l_lfpos.
            MODIFY it_rseg FROM wa_rseg TRANSPORTING lfpos.
          ENDIF.
        ENDIF.
      ENDLOOP.

      SORT it_rseg BY belnr gjahr buzei.
      LOOP AT it_rseg INTO wa_rseg.
        AT NEW belnr.
          CLEAR i_1.
        ENDAT.

        " For BSET tax-group match
        i_1 = i_1 + 1.
        wa_rseg-count1 = i_1.
        MODIFY it_rseg FROM wa_rseg TRANSPORTING count1.
        CLEAR wa_rseg.
      ENDLOOP.

      SORT it_rseg BY bukrs1 belnr1 gjahr1.
    ENDIF.
  ENDIF.
ENDFORM.                    " FETCH_INVC_RELATED_INFO
*&---------------------------------------------------------------------*
*&      Form  GET_TAX_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_tax_info .
  IF it_bkpf IS NOT INITIAL.
    SELECT bukrs
           belnr
           gjahr
           buzei
           txgrp
           shkzg
           mwskz
           hwbas
           hwste
           ktosl
           kschl
           kbetr
      FROM bset
      INTO TABLE it_bset
      FOR ALL ENTRIES IN it_bkpf
      WHERE bukrs = it_bkpf-bukrs AND
            belnr = it_bkpf-belnr AND
            gjahr = it_bkpf-gjahr AND
            mwskz NE 'S1'.
    IF sy-subrc = 0.
      SORT it_bset BY bukrs belnr gjahr buzei.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_TAX_INFO
*&---------------------------------------------------------------------*
*&      Form  GET_ACCOUTING_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_accouting_info .
  DATA lv_parbelnr TYPE belnr_d.
  CLEAR lv_parbelnr.

  IF it_bkpf IS NOT INITIAL.
    SELECT bukrs
           belnr
           gjahr
           buzei
           buzid
           bschl
           koart
           shkzg
           mwskz
           dmbtr
           ktosl
           hkont
           lifnr
           ebeln
           ebelp
           tbtkz
       FROM bseg
       INTO TABLE it_bseg
       FOR ALL ENTRIES IN it_bkpf
       WHERE bukrs = it_bkpf-bukrs AND
             belnr = it_bkpf-belnr AND
             gjahr = it_bkpf-gjahr . "AND
*            ( bschl = '31' or bschl = '40' ).
    IF sy-subrc = 0.
      SORT it_bseg BY bukrs belnr gjahr buzei.
      IF p_prchrg = c_x.
        LOOP AT it_bseg INTO wa_bseg
          WHERE ( koart = 'K' AND shkzg = 'S') " Subsequent Cedit Memo
            OR tbtkz = 'X'. " Subsequent Debit
          DELETE it_bseg WHERE belnr = wa_bseg-belnr.
          DELETE it_bkpf WHERE belnr = wa_bseg-belnr.
          CLEAR wa_bseg.
        ENDLOOP.
      ENDIF.
      PERFORM get_g_l_acc_info.
      PERFORM get_tax_code_info.

      SORT it_bseg BY bukrs belnr gjahr buzei.
      LOOP AT it_bseg INTO wa_bseg.
        AT NEW belnr.
          v_flag = ' '.
        ENDAT.
        IF v_flag = ' '.
          wa_lifnr_bseg = wa_bseg-lifnr.
          v_flag = 'X'.
        ENDIF.
        IF wa_lifnr_bseg <> wa_bseg-lifnr.
          wa_bseg-lifnr = wa_lifnr_bseg.
          MODIFY it_bseg FROM wa_bseg TRANSPORTING lifnr.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_ACCOUTING_INFO
*&---------------------------------------------------------------------*
*&      Form  GET_VENDOR_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_vendor_details .
  IF it_bseg IS NOT INITIAL.


    SELECT  lifnr
              name1
              adrnr
        FROM lfa1
        INTO TABLE it_lfa1
        FOR ALL ENTRIES IN it_bseg
        WHERE lifnr = it_bseg-lifnr.

*      SELECT  bukrs
*              lifnr
*              gjahr
*              erdat
*        FROM lfc1
*        APPENDING TABLE it_lfc1
*        FOR ALL ENTRIES IN it_bseg
*        WHERE "BUKRS IN S_BUKRS AND
*            "BELNR IN S_BELNR AND
*            bukrs = it_bseg-bukrs AND
*            lifnr = it_bseg-lifnr AND
*            gjahr = it_bseg-gjahr.

    SELECT  lifnr
            j_1icstno
            j_1ilstno
            j_1isern
      FROM j_1imovend
      APPENDING TABLE it_j_1imovend
      FOR ALL ENTRIES IN it_bseg
      WHERE lifnr = it_bseg-lifnr.
  ENDIF.

*  IF it_rseg is not initial.
*    SORT it_rseg BY lifnr.
*    SELECT  lifnr
*            name1
*            adrnr
*      FROM lfa1
*      APPENDING TABLE it_lfa1
*      FOR ALL ENTRIES IN it_rseg
*      WHERE lifnr = it_rseg-lifnr.
*
*    SELECT  lifnr
*            j_1ilstno
*            j_1icstno
*      FROM j_1imovend
*      APPENDING TABLE it_j_1imovend
*      FOR ALL ENTRIES IN it_rseg
*      WHERE lifnr = it_rseg-lifnr.
*
*    SELECT  bukrs
*            lifnr
*            gjahr
*            erdat
*      FROM lfc1
*      APPENDING TABLE it_lfc1
*      FOR ALL ENTRIES IN it_rseg
*       WHERE "BUKRS IN S_BUKRS AND
*             "BELNR IN S_BELNR AND
*             bukrs = it_rseg-bukrs1 AND
*             lifnr = it_rseg-lifnr AND
*             gjahr = it_rseg-gjahr1.
*  ENDIF.

  " Get Vendors' address info
  IF NOT it_lfa1 IS INITIAL.
*    DELETE ADJACENT DUPLICATES FROM it_lfa1 COMPARING lifnr.
    SORT it_lfa1 BY adrnr.

    REFRESH it_adrc.
    SELECT addrnumber
           city1
           post_code1
           street
           str_suppl1
           str_suppl2
      INTO TABLE it_adrc
      FROM adrc
      FOR ALL ENTRIES IN it_lfa1
      WHERE addrnumber = it_lfa1-adrnr.
    IF sy-subrc = 0.
      SORT it_adrc BY addrnumber.
    ENDIF.

    SORT it_lfa1 BY lifnr.
  ENDIF.

ENDFORM.                    " GET_VENDOR_DETAILS
*&---------------------------------------------------------------------*
*&      Form  GET_G_L_ACC_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_g_l_acc_info .
  SELECT  saknr
          txt20
    INTO TABLE it_purtxt
    FROM skat
    FOR ALL ENTRIES IN it_bseg
    WHERE spras = 'EN'
      AND saknr = it_bseg-hkont.
ENDFORM.                    " GET_G_L_ACC_INFO
*&---------------------------------------------------------------------*
*&      Form  GET_TAX_CODE_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_tax_code_info .
  SELECT  mwskz
          text1
    INTO TABLE it_taxnam
    FROM t007s
    FOR ALL ENTRIES IN it_bseg
    WHERE spras = 'EN'
      AND kalsm = 'ZTAXIN'
      AND mwskz = it_bseg-mwskz.
ENDFORM.                    " GET_TAX_CODE_INFO
*&---------------------------------------------------------------------*
*&      Form  GET_PUR_ORDER_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_pur_order_info .
  SORT it_rseg BY ebeln.
  SELECT  ebeln
          lifnr
          ekorg
          bedat
          knumv
    FROM ekko
    INTO TABLE it_ekko
    FOR ALL ENTRIES IN it_rseg
    WHERE ebeln = it_rseg-ebeln.
  IF sy-subrc = 0.
    " Filter import vendors
    PERFORM filter_import_vendor_data.
  ENDIF.

  SELECT buzei
         lfbnr
         lfpos
    FROM ekbe
    INTO TABLE it_ekbe
    FOR ALL ENTRIES IN it_rseg
    WHERE lfbnr = it_rseg-lfbnr AND
          lfpos = it_rseg-lfpos AND
          bewtp = 'E' AND              "PO HISTORY
          bwart IN ('101', '105' ).

ENDFORM.                    " GET_PUR_ORDER_INFO

FORM handle_event USING action TYPE char50.
  DATA : v TYPE char100.
  CASE action.
    WHEN 'DOUBLE_CLICK'.
      PERFORM handle_double_click.
  ENDCASE.
ENDFORM.

FORM handle_double_click.
  CLEAR wa_final.
  READ TABLE it_final INTO wa_final INDEX lv_handler->row_id.

  IF lv_handler->col = 'BELNR'.
    SET PARAMETER ID : 'BLN' FIELD wa_final-belnr,
                       'BUK' FIELD wa_final-bukrs,
                       'GJR' FIELD wa_final-gjahr.
    CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADD_MIRO_DOCS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM add_miro_docs .
  DATA : it_bkpf1 TYPE TABLE OF t_bkpf.
  REFRESH : it_bkpf1, it_bseg.

  " MIRO Credit memo should be considered under debit note
  IF p_dbntrg = c_x .
    SELECT DISTINCT
           bkpf~bukrs
           bkpf~belnr
           bkpf~gjahr
      FROM bkpf
      JOIN bsik ON bkpf~gjahr = bsik~gjahr
                AND bkpf~belnr = bsik~belnr
      INTO TABLE it_bseg
      WHERE bkpf~blart = 'RE'
        AND bkpf~gjahr IN s_gjahr
        AND bkpf~budat IN s_budat
        AND shkzg = 'S'.
  ELSEIF p_crntrg = c_x.
    SELECT DISTINCT
           bukrs
           belnr
           gjahr
      FROM bkpf
      INTO TABLE it_bkpf1
      WHERE bkpf~blart = 'RE'
        AND bkpf~gjahr IN s_gjahr
        AND bkpf~budat IN s_budat.
    IF sy-subrc = 0.
      SELECT bukrs
             belnr
             gjahr
        FROM bseg
        INTO TABLE it_bseg
        FOR ALL ENTRIES IN it_bkpf1
        WHERE bukrs = it_bkpf1-bukrs
          AND belnr = it_bkpf1-belnr
          AND gjahr = it_bkpf1-gjahr
          AND buzei = 1
          AND shkzg = 'H'
          AND ( tbtkz = 'X' OR qsskz = 'XX' )
        .
    ENDIF.
  ENDIF.
  IF it_bseg IS NOT INITIAL.
    SELECT bukrs
          belnr
          gjahr
          blart
          bldat
          budat
          xblnr
          awkey
      FROM bkpf
      APPENDING TABLE it_bkpf
      FOR ALL ENTRIES IN it_bseg
      WHERE bukrs = it_bseg-bukrs
        AND belnr = it_bseg-belnr
        AND gjahr = it_bseg-gjahr.
    REFRESH it_bseg.
  ENDIF.
ENDFORM.                    " ADD_MIRO_DOCS
*&---------------------------------------------------------------------*
*&      Form  FILTER_IMPORT_VENDOR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM filter_import_vendor_data .
  TYPES : BEGIN OF t_imp_vndr,
            lifnr TYPE elifn,  "  Vendor Account Number
            ekorg TYPE ekorg,  "  Purchasing Organization
          END OF t_imp_vndr.

  DATA : it_import_vendors TYPE TABLE OF t_imp_vndr,
         wa_import_vendor  TYPE t_imp_vndr.

  REFRESH : it_import_vendors.

  SELECT DISTINCT
      lifnr
      ekorg
    FROM lfm1
    INTO TABLE it_import_vendors
    FOR ALL ENTRIES IN it_ekko
    WHERE lifnr = it_ekko-lifnr
      AND ekorg = it_ekko-ekorg
      AND kalsk = '04'.
  IF sy-subrc = 0.
    LOOP AT it_import_vendors INTO wa_import_vendor.
      LOOP AT it_ekko INTO wa_ekko WHERE lifnr = wa_import_vendor-lifnr
                                    AND ekorg = wa_import_vendor-ekorg.
        LOOP AT it_rseg INTO wa_rseg WHERE ebeln = wa_ekko-ebeln.
          DELETE it_bkpf WHERE g_belnr = wa_rseg-belnr.
          DELETE it_rseg WHERE belnr = wa_rseg-belnr.
          CLEAR wa_rseg.
        ENDLOOP.
        DELETE it_ekko WHERE ebeln = wa_ekko-ebeln.
        CLEAR wa_ekko.
      ENDLOOP.
      CLEAR wa_import_vendor.
    ENDLOOP.
  ENDIF.

  " delete all records concerened with vendors having purch_org 2xxx.
  CLEAR : wa_ekko, wa_rseg.
  LOOP AT it_ekko INTO wa_ekko.
    IF wa_ekko-ekorg(1) <> '2'.
      CONTINUE.
    ENDIF.
    LOOP AT it_rseg INTO wa_rseg WHERE ebeln = wa_ekko-ebeln.
      DELETE it_bkpf WHERE g_belnr = wa_rseg-belnr.
      DELETE it_rseg WHERE belnr = wa_rseg-belnr.
      CLEAR wa_rseg.
    ENDLOOP.
    CLEAR wa_ekko.
  ENDLOOP.
ENDFORM.                    " FILTER_IMPORT_VENDOR_DATA
*&---------------------------------------------------------------------*
*&      Form  FILTER_REVERSED_DOCS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM filter_reversed_docs .
  REFRESH it_bkpfr.
  CLEAR wa_bkpfr.
  IF it_bkpf IS NOT INITIAL.
    SELECT belnr
           blart
           stblg
      FROM bkpf
      INTO TABLE it_bkpfr
      FOR ALL ENTRIES IN it_bkpf
      WHERE tcode = 'FB08'
        AND stblg = it_bkpf-belnr
        AND stjah = it_bkpf-gjahr.
    IF sy-subrc = 0.
      SORT it_bkpfr BY stblg.
      LOOP AT it_bkpfr INTO wa_bkpfr.
        DELETE it_bkpf WHERE belnr = wa_bkpfr-stblg.
        CLEAR wa_bkpfr.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.                    " FILTER_REVERSED_DOCS
