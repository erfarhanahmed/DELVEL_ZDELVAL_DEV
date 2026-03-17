*&---------------------------------------------------------------------*
*& REPORT  ZFI_PURCHASE_REGISTER
*&
*&---------------------------------------------------------------------*
*&------------------------Modification Log-----------------------------*
*& TR No.     Date        By          Modification For
*&---------------------------------------------------------------------*
*& DVDK902142 28-03-2012  MBHOSALE    - Add columns for document Type,
*&                                    Tax Rate
*&                                    - exclude base amount from the
*&                                    total-tax-value calculation
*&                                    - columns realigned
*& DVDK902152 03-04-2012  mbhosale    - Correction for display of Vendor
*&                                      info for non-service records
*& DVDK902160 05-04-2012  mbhosale    - Correction related with Base amt
*&                                      (ref. S1 record from BSEG)
*&                                    - Inclusion of the document types
*&                                      'BP' & 'KG' in the tax-report
*& DVDK902174 13-04-2012  mbhosale    - 1. Correction related with Vndor
*&                                        info for docs with type 'KG'
*&                                      2. Correction regarding ledger-
*&                                        info[HKONT] of MIRO-documensts
*&---------------------------------------------------------------------*

REPORT  zfi_service_tax_register.
** TABLES DECLARATION
TABLES : bkpf,bseg,bset,makt,rseg,lfa1."ZKPT_FI_BSEG.
TYPE-POOLS : slis.
CONSTANTS:c_101    TYPE i VALUE '101',
          c_105    TYPE i VALUE '105',
          c_4      TYPE i VALUE '4',
          c_10     TYPE i VALUE '10',
          c_15     TYPE i VALUE '15',
          c_20     TYPE i VALUE '20',
          c_35     TYPE i VALUE '35',
          c_1      TYPE i VALUE '1',
          c_x      TYPE char1 VALUE 'X',
          c_0      TYPE i VALUE '00000000',
          c_prcntg TYPE c VALUE '%'.

DATA : BEGIN OF it_bkpf OCCURS 0,
         bukrs   LIKE bkpf-bukrs,
         belnr   LIKE bkpf-belnr,
         gjahr   LIKE bkpf-gjahr,
         blart   LIKE bkpf-blart,
         bldat   LIKE bkpf-bldat,
         budat   LIKE bkpf-budat,
         xblnr   LIKE bkpf-xblnr,
         awkey   LIKE bkpf-awkey,
         g_belnr LIKE rseg-belnr, "GR INV NO
         g_gjahr LIKE rseg-gjahr, "GR INV YEAR
       END OF it_bkpf.

DATA : BEGIN OF it_rseg OCCURS 0,
         belnr  LIKE rseg-belnr,
         gjahr  LIKE rseg-gjahr,
         buzei  LIKE rseg-buzei,
         ebeln  LIKE rseg-ebeln,
         ebelp  LIKE rseg-ebelp,
         matnr  LIKE rseg-matnr,
         bukrs  LIKE rseg-bukrs,
         wrbtr  LIKE rseg-wrbtr,
         shkzg  LIKE rseg-shkzg,
         mwskz  LIKE rseg-mwskz,
         kschl  LIKE rseg-kschl, "CONDITION TYPE IN RSEG
         lfbnr  LIKE rseg-lfbnr, "REFERENCE DOCUMENT
         lfpos  LIKE rseg-lfpos, "REFERENCE DOCUMENET ITEM
         lifnr  LIKE rbkp-lifnr,
         name1  LIKE lfa1-name1,
         bukrs1 LIKE bkpf-bukrs,
         belnr1 LIKE bkpf-belnr,
         gjahr1 LIKE bkpf-gjahr,
         count1 TYPE sy-tabix,
       END OF it_rseg.

DATA : BEGIN OF it_rseg_lifnr OCCURS 0,
         belnr  LIKE rseg-belnr,
         gjahr  LIKE rseg-gjahr,
         buzei  LIKE rseg-buzei,
         ebeln  LIKE rseg-ebeln,
         ebelp  LIKE rseg-ebelp,
         matnr  LIKE rseg-matnr,
         bukrs  LIKE rseg-bukrs,
         wrbtr  LIKE rseg-wrbtr,
         shkzg  LIKE rseg-shkzg,
         mwskz  LIKE rseg-mwskz,
         kschl  LIKE rseg-kschl, "CONDITION TYPE IN RSEG
         lfbnr  LIKE rseg-lfbnr, "REFERENCE DOCUMENT
         lfpos  LIKE rseg-lfpos, "REFERENCE DOCUMENET ITEM
         lifnr  LIKE rbkp-lifnr,
         name1  LIKE lfa1-name1,
         bukrs1 LIKE bkpf-bukrs,
         belnr1 LIKE bkpf-belnr,
         gjahr1 LIKE bkpf-gjahr,
         count1 TYPE sy-tabix,
       END OF it_rseg_lifnr.

DATA : BEGIN OF it_lfa1 OCCURS 0,
         lifnr LIKE lfa1-lifnr,
         name1 LIKE lfa1-name1,
       END OF it_lfa1.

DATA : l_lfpos(4) TYPE c.

DATA : BEGIN OF it_bset OCCURS 0,
         bukrs    LIKE bset-bukrs,
         belnr    LIKE bset-belnr,
         gjahr    LIKE bset-gjahr,
         buzei    LIKE bset-buzei,
         txgrp(4) TYPE n, " LIKE BSET-TXGRP, "GR INVOICE ITEM
         shkzg    LIKE bset-shkzg, "DEBIT/CREDIT INDICATOR
         mwskz    LIKE bset-mwskz, "TAX CODE
         hwbas    LIKE bset-hwbas, "TAX BASE AMOUNT IN LOCAL CURRENCY
         hwste    LIKE bset-hwste, "TAX AMOUNT IN LOCAL CURRENCY
         ktosl    LIKE bset-ktosl, "TRANSACTION KEY
         kschl    LIKE bset-kschl, "CONDITION TYPE
         kbetr    LIKE bset-kbetr, "TAX RATE
         count    TYPE sy-tabix,
       END OF it_bset.

DATA: it_bset_temp LIKE it_bset OCCURS 0 WITH HEADER LINE.

DATA : BEGIN OF it_makt OCCURS 0,
         matnr LIKE makt-matnr,
         maktx LIKE makt-maktx,
       END OF it_makt.

DATA : BEGIN OF it_bseg OCCURS 0,
         bukrs LIKE bseg-bukrs,
         belnr LIKE bseg-belnr,
         buzei LIKE bseg-buzei,
         gjahr LIKE bseg-gjahr,
         hkont LIKE bseg-hkont,
         lifnr LIKE bseg-lifnr,
         ebeln LIKE bseg-ebeln,
         ebelp LIKE bseg-ebelp,
         mwskz LIKE bseg-mwskz,
         shkzg LIKE bseg-shkzg,
         buzid LIKE bseg-buzid,
         dmbtr LIKE bseg-dmbtr,
         augdt LIKE bseg-augdt,
       END OF it_bseg.

       DATA : BEGIN OF it_bseg3 OCCURS 0,
         bukrs LIKE bseg-bukrs,
         belnr LIKE bseg-belnr,
         buzei LIKE bseg-buzei,
         gjahr LIKE bseg-gjahr,
         hkont LIKE bseg-hkont,
         lifnr LIKE bseg-lifnr,
         ebeln LIKE bseg-ebeln,
         ebelp LIKE bseg-ebelp,
         mwskz LIKE bseg-mwskz,
         shkzg LIKE bseg-shkzg,
         buzid LIKE bseg-buzid,
         dmbtr LIKE bseg-dmbtr,
         augdt LIKE bseg-augdt,
       END OF it_bseg3.

DATA : BEGIN OF it_bseg1 OCCURS 0,
         bukrs LIKE bseg-bukrs,
         belnr LIKE bseg-belnr,
         buzei LIKE bseg-buzei,
         gjahr LIKE bseg-gjahr,
         hkont LIKE bseg-hkont,
         lifnr LIKE bseg-lifnr,
         ebeln LIKE bseg-ebeln,
         ebelp LIKE bseg-ebelp,
         mwskz LIKE bseg-mwskz,
         shkzg LIKE bseg-shkzg,
         buzid LIKE bseg-buzid,
         dmbtr LIKE bseg-dmbtr,
         augdt LIKE bseg-augdt,
       END OF it_bseg1.



DATA : BEGIN OF it_ekbe OCCURS 0,
         buzei LIKE ekbe-buzei,
         lfbnr LIKE ekbe-lfbnr,
         lfpos LIKE rseg-lfpos,
       END OF it_ekbe.


DATA : BEGIN OF it_final OCCURS 0,
         bldat     LIKE bkpf-bldat,  "DOC DATE
         bukrs     LIKE bkpf-bukrs,  "COMPANY CODE
         blart     LIKE bkpf-blart,  "Document Type " by mbhosale on 28.03.2012
         belnr     LIKE bkpf-belnr,  "DOCUMENT NO
         gjahr     LIKE bkpf-gjahr,  "FISCAL YEAR
         lifnr     LIKE lfa1-lifnr,  "VENDOR
         name1     LIKE lfa1-name1,  "VENDOR NAME
         g_belnr   LIKE rseg-belnr, "MIRO INVOICE NO
         buzei     LIKE rseg-buzei,   "MIRO INVOICE ITEM
         hkont     LIKE bseg-hkont,   "GL A/C
         mwskz     LIKE bset-mwskz,   "TAX CODE
         matnr     LIKE rseg-matnr,   "MATERIAL
         maktx     LIKE makt-maktx,   "MATERIAL DESCRIPTION
         ebeln     LIKE rseg-ebeln,   "PO
         ebelp     LIKE rseg-ebelp,   "PO ITEM
         wrbtr     LIKE rseg-wrbtr, "AMOUNT
         bed       TYPE kwert,        "BED
         bedrate   TYPE kwert,    "BED RATE
         ecs       TYPE kwert,        "ECESS SETOFF
         ebed      TYPE kwert,       "ECESS ON BED
         rmded     TYPE kwert,      "RM DEDUCTABLE
         rmnon     TYPE kwert,      "RM NON-DEDUCTABLE
         cgded     TYPE kwert,      "CG DEDUCTABLE
         cgnon     TYPE kwert,      "CG NON-DEDUCTABLE
         cst       TYPE kwert,        "CST
         cstrate   TYPE kwert,    "CST RATE
         sertax    TYPE kwert,     "SERVICE TAX
         esertax   TYPE kwert,    "ECESS ON SERVICE TAX
         shcess    TYPE kwert,     "SHCESS
         shrate    TYPE kwert,     "SHCESS RATE
         acd       TYPE wrbtr,        "ADDITIONAL CUSTOMS DUTY
         bascus    TYPE wrbtr,     "BASIC CUSTOMS
         cvd       TYPE wrbtr,        "CVD
         ecvd      TYPE wrbtr,       "ECESS ON CVD
         ecustom   TYPE wrbtr,    "CUSTOMS ECESS
         gross     TYPE kwert,      "GROSS TOTAL
         xblnr     TYPE bkpf-xblnr,
         dmbtr     LIKE bsik-dmbtr,
         mwsts     LIKE bsik-mwsts,
         mwsk1     LIKE t007s-text1,
         belnr_b   LIKE bsik-belnr,
         erdat     LIKE lfc1-erdat,
         vatcst    TYPE char40,
         j_1ilstno LIKE j_1imovend-j_1ilstno,
         j_1icstno LIKE j_1imovend-j_1icstno,
         j_1isern  LIKE j_1imovend-j_1isern,
         awkey_inv TYPE char10,
         pur_text  TYPE txt20_skat,
         gross_tot TYPE kwert,
         pack_fwd  TYPE kwert,
         bst       TYPE kwert,        "BED
         paid_d    LIKE bkpf-bldat,  "DOC DATE
         stxrt     TYPE char8, " by mbhosale [30-03-2012]
       END OF it_final.

DATA : t_listheader   TYPE slis_t_listheader WITH HEADER LINE,
       t_fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       t_event        TYPE slis_t_event WITH HEADER LINE,
       fs_layout      TYPE slis_layout_alv,
       t_fieldcat     TYPE slis_t_fieldcat_alv WITH HEADER LINE.


DATA : BEGIN OF it_bset1 OCCURS 0,
         bukrs LIKE bset-bukrs,
         belnr LIKE bset-belnr,
         gjahr LIKE bset-gjahr,
       END OF it_bset1.


DATA : BEGIN OF it_bsik OCCURS 0,
         bukrs LIKE bsik-bukrs,
         gjahr LIKE bsik-gjahr,
         buzei LIKE bsik-buzei,
         belnr LIKE bsik-belnr,
         stceg LIKE bsik-stceg,
         dmbtr LIKE bsik-dmbtr,
         mwsts LIKE bsik-mwsts,
         mwsk1 LIKE bsik-mwsk1,
       END OF it_bsik.

DATA : BEGIN OF it_lfc1 OCCURS 0,
         bukrs LIKE lfc1-bukrs,
         lifnr LIKE lfc1-lifnr,
         gjahr LIKE lfc1-gjahr,
         erdat LIKE lfc1-erdat,
       END OF it_lfc1.

DATA : BEGIN OF it_j_1imovend OCCURS 0,
         lifnr     LIKE j_1imovend-lifnr,
         j_1ilstno LIKE j_1imovend-j_1ilstno,
         j_1icstno LIKE j_1imovend-j_1icstno,
         j_1isern  LIKE j_1imovend-j_1isern,
       END OF it_j_1imovend.


DATA : BEGIN OF it_rseg1 OCCURS 0,
         ebeln  LIKE rseg-ebeln,
         ebelp  LIKE rseg-ebelp,
         belnr  LIKE rseg-belnr,
         gjahr  LIKE rseg-gjahr,
         buzei  LIKE rseg-buzei,
         matnr  LIKE rseg-matnr,
         bukrs  LIKE rseg-bukrs,
         wrbtr  LIKE rseg-wrbtr,
         shkzg  LIKE rseg-shkzg,
         mwskz  LIKE rseg-mwskz,
         kschl  LIKE rseg-kschl, "CONDITION TYPE IN RSEG
         lfpos  LIKE rseg-lfpos, "REFERENCE DOCUMENET ITEM
         lifnr  LIKE rbkp-lifnr,
         name1  LIKE lfa1-name1,
         bukrs1 LIKE bkpf-bukrs,
         belnr1 LIKE bkpf-belnr,
         gjahr1 LIKE bkpf-gjahr,
       END OF it_rseg1.
DATA: i TYPE sy-tabix.
DATA : BEGIN OF r_rseg OCCURS 0,
         belnr LIKE rseg-belnr,
         gjahr LIKE rseg-gjahr,
       END OF r_rseg.

DATA: BEGIN OF it_ekko OCCURS 0,
        ebeln LIKE ekko-ebeln,
        knumv LIKE ekko-knumv,
      END OF it_ekko.

DATA: it_rseg_ekko LIKE it_rseg OCCURS 0,
      wa_bseg      LIKE it_bseg,
      wa_rseg      LIKE it_rseg,
      wa_rseg1     LIKE it_rseg,
      wa_rseg2     LIKE it_rseg.

DATA: wa_text TYPE text1_007s,
      wa_1    TYPE text1_007s,
      wa_2    TYPE text1_007s.

DATA: wa_flag       TYPE c,
      wa_cst        TYPE c,
      wa_vat        TYPE c,
      wa_flag_lifnr TYPE c,
      wa_gross      TYPE kwert.

DATA: wa_lifnr      LIKE bseg-lifnr,
      wa_lifnr_bseg LIKE bseg-lifnr,
      v_flag        TYPE c,
      lv_shkzg      TYPE c.

" Begin of changes by mbhosale [29-03-2012]
DATA : wa_sort TYPE  slis_sortinfo_alv,
       it_sort TYPE  slis_t_sortinfo_alv.
" End of changes by mbhosale [29-03-2012]

**SELECTION-SCREEN
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_gjahr FOR bkpf-gjahr,
                 s_budat FOR bkpf-budat OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS p_inv TYPE c  NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK b2.


AT SELECTION-SCREEN ON s_gjahr.
  IF s_gjahr-low EQ ' '.
    MESSAGE TEXT-001 TYPE TEXT-002.
  ENDIF.

START-OF-SELECTION.
*&---------------------------------------------------------------------*
*& SUBROUTINE TO PROCESS REPORT DATA.
*&---------------------------------------------------------------------*
  PERFORM process_data.
*&---------------------------------------------------------------------*
*&      FORM  PROCESS_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM process_data .

*GET DATA FROM BKPF TABLE
  SELECT bukrs
         belnr
         gjahr
         blart
         bldat
         budat
         xblnr
         awkey FROM bkpf
         INTO CORRESPONDING FIELDS OF TABLE it_bkpf
       WHERE   gjahr IN s_gjahr AND
               budat IN s_budat AND
              ( blart = text-003
                OR blart = text-004
                OR blart = text-075 " Bank Payment
                OR blart = text-076 " Reversal doc / Credit Memo
    ).

  IF NOT it_bkpf[] IS INITIAL.

    LOOP AT it_bkpf.
      it_bkpf-g_belnr = it_bkpf-awkey+0(10).
      it_bkpf-g_gjahr = it_bkpf-awkey+10(4).
      IF sy-subrc EQ 0.
        MODIFY it_bkpf TRANSPORTING g_belnr g_gjahr.
      ENDIF.
    ENDLOOP.

*GET MIRO INVOICE ITEM DETAILS,VENDOR AND VENDOR NAME

    SELECT a~belnr a~gjahr a~buzei a~ebeln a~ebelp a~matnr a~bukrs
           a~wrbtr a~shkzg a~mwskz a~kschl a~lfbnr a~lfpos b~lifnr
           c~name1
      INTO TABLE it_rseg
      FROM rseg AS a INNER JOIN rbkp AS b ON a~belnr = b~belnr
                     INNER JOIN lfa1 AS c ON b~lifnr = c~lifnr
      FOR ALL ENTRIES IN it_bkpf
      WHERE a~belnr = it_bkpf-g_belnr AND
            a~gjahr = it_bkpf-g_gjahr.
  ENDIF.


*GET MATERIAL DESCRIPTION

  IF NOT it_bkpf[] IS INITIAL.

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
           kbetr FROM bset
           INTO CORRESPONDING FIELDS OF TABLE it_bset
           FOR ALL ENTRIES IN it_bkpf
           WHERE bukrs = it_bkpf-bukrs AND
                 belnr = it_bkpf-belnr AND
                 gjahr = it_bkpf-gjahr AND
                 mwskz = text-005.
    IF sy-subrc <> 0.
      MESSAGE TEXT-077 TYPE 'I'.
      EXIT.
    ENDIF.

    SELECT
       bukrs
       belnr
       buzei
       gjahr
       hkont
       lifnr
       ebeln
       ebelp
       mwskz
       shkzg
       buzid
       dmbtr
       augdt
      FROM bseg
        INTO CORRESPONDING FIELDS OF TABLE it_bseg
" Begin of changes by mbhosale [03-04-2012]
*        FOR ALL ENTRIES IN it_bkpf
*        WHERE bukrs = it_bkpf-bukrs AND
*              belnr = it_bkpf-belnr AND
*              gjahr = it_bkpf-gjahr." AND
*              "mwskz = text-005. " DelVal-II / By mbhosale On 28-03-2012
        FOR ALL ENTRIES IN it_bset
        WHERE bukrs = it_bset-bukrs
          AND belnr = it_bset-belnr
          AND gjahr = it_bset-gjahr.
    " End of changes by mbhosale [03-04-2012]

    IF NOT it_bseg[] IS INITIAL.
      it_bseg1[] = it_bseg[].
      it_bseg3[] = it_bseg[].

      delete it_bseg3 where lifnr = ' '.
      DELETE ADJACENT DUPLICATES FROM it_bseg1 COMPARING bukrs belnr lifnr gjahr.
      SELECT  bukrs lifnr gjahr erdat FROM lfc1
        APPENDING CORRESPONDING FIELDS OF TABLE it_lfc1
     FOR ALL ENTRIES IN it_bseg1
    WHERE   bukrs = it_bseg1-bukrs AND
            lifnr  = it_bseg1-lifnr AND
            gjahr = it_bseg1-gjahr.

      SELECT lifnr j_1ilstno j_1icstno j_1isern
       FROM j_1imovend
       APPENDING CORRESPONDING FIELDS OF TABLE it_j_1imovend
       FOR ALL ENTRIES IN it_bseg1
       WHERE lifnr = it_bseg1-lifnr.
    ENDIF.

  ENDIF.


  IF NOT it_rseg[] IS INITIAL.

    SELECT matnr
           maktx FROM makt
           INTO TABLE it_makt
           FOR ALL ENTRIES IN it_rseg
           WHERE matnr = it_rseg-matnr AND
                 spras = text-006.
    it_rseg_ekko[] = it_rseg[].
    SORT it_rseg_ekko BY ebeln.
    DELETE ADJACENT DUPLICATES FROM it_rseg_ekko COMPARING ebeln.

    SELECT ebeln
           knumv
           FROM ekko
           INTO TABLE it_ekko
           FOR ALL ENTRIES IN it_rseg_ekko
           WHERE ebeln = it_rseg_ekko-ebeln.
    DATA: BEGIN OF it_konv OCCURS 0,
            knumv LIKE PRCD_ELEMENTS-knumv,
            kschl LIKE PRCD_ELEMENTS-kschl,
            kwert LIKE PRCD_ELEMENTS-kwert,
          END OF it_konv.
    SELECT knumv
           kschl
           kwert
           FROM PRCD_ELEMENTS
           INTO TABLE it_konv
           FOR ALL ENTRIES IN it_ekko
           WHERE knumv = it_ekko-knumv
             AND ( kschl = text-007
                  OR kschl = text-008
                  OR kschl = text-009
                  OR kschl = text-010
                  OR kschl = text-011 ).

    SELECT buzei
           lfbnr
           lfpos FROM ekbe
           INTO TABLE it_ekbe
           FOR ALL ENTRIES IN it_rseg
           WHERE lfbnr = it_rseg-lfbnr AND
                 lfpos = it_rseg-lfpos AND
                 bewtp = text-002 AND              "PO HISTORY
                 ( bwart = c_101 OR bwart = c_105 ).

    SORT it_rseg BY belnr gjahr.

    LOOP AT it_rseg.
      READ TABLE r_rseg WITH KEY belnr = it_rseg-belnr
                                 gjahr = it_bseg-gjahr.
      IF sy-subrc NE 0.
        r_rseg-belnr = it_rseg-belnr.
        r_rseg-gjahr = it_rseg-gjahr.
        APPEND r_rseg.
        CLEAR  r_rseg.
      ENDIF.
    ENDLOOP.

    SORT r_rseg BY belnr gjahr.
    DELETE ADJACENT DUPLICATES FROM r_rseg COMPARING belnr gjahr.
    SORT r_rseg BY belnr gjahr.

    LOOP AT r_rseg.
      i = 1.
      LOOP AT it_rseg WHERE belnr = r_rseg-belnr
                        AND gjahr = r_rseg-gjahr.
        it_rseg-count1 = i.
        i = i + 1.
        MODIFY it_rseg.
      ENDLOOP.
      CLEAR : i.
    ENDLOOP.
*MOVE ACCOUNTING DOCUMENT NUMBER,COMPANY CODE AND FISCAL YEAR TO IT_RSEG[] TABLE

    SORT it_rseg BY belnr buzei.

    LOOP AT it_rseg.

      IF it_rseg-shkzg = TEXT-014.
        it_rseg-wrbtr = it_rseg-wrbtr * ( -1 ).
        MODIFY it_rseg TRANSPORTING wrbtr.
      ENDIF.

      READ TABLE it_bkpf WITH KEY g_belnr = it_rseg-belnr
                                  g_gjahr = it_rseg-gjahr.
      IF sy-subrc EQ 0.
        it_rseg-bukrs1 = it_bkpf-bukrs.
        it_rseg-belnr1 = it_bkpf-belnr.
        it_rseg-gjahr1 = it_bkpf-gjahr.
        MODIFY it_rseg TRANSPORTING bukrs1 belnr1 gjahr1.
      ENDIF.

      READ TABLE it_ekbe WITH KEY lfbnr = it_rseg-lfbnr
                                  lfpos = it_rseg-lfpos.
      IF sy-subrc EQ 0.
        it_rseg-lfpos = it_ekbe-buzei.
        MODIFY it_rseg TRANSPORTING lfpos.
      ENDIF.


      IF it_rseg-lfpos = 0.
        READ TABLE it_bset WITH KEY belnr = it_rseg-belnr1
                                    bukrs = it_rseg-bukrs1
                                    gjahr = it_rseg-gjahr1.
        IF sy-subrc EQ 0.
          l_lfpos = it_rseg-buzei+2(4).
          it_rseg-lfpos = l_lfpos.
          MODIFY it_rseg TRANSPORTING lfpos.

        ENDIF.
      ENDIF.


    ENDLOOP.

  ENDIF.
  IF NOT it_bseg1[] IS INITIAL.
    SELECT  lifnr
            name1
           FROM lfa1
            INTO TABLE it_lfa1
            FOR ALL ENTRIES IN it_bseg1
            WHERE lifnr = it_bseg1-lifnr.
  ENDIF.

    IF NOT it_bseg3[] IS INITIAL.
    SELECT  lifnr
            name1
           FROM lfa1
            APPENDING TABLE it_lfa1
            FOR ALL ENTRIES IN it_bseg3
            WHERE lifnr = it_bseg3-lifnr.
  ENDIF.


  IF NOT it_rseg[] IS INITIAL.
    it_rseg_lifnr[] = it_rseg[].

    DELETE ADJACENT DUPLICATES FROM it_rseg_lifnr COMPARING lifnr.
    SELECT lifnr
           name1
          FROM lfa1
           APPENDING TABLE it_lfa1
           FOR ALL ENTRIES IN it_rseg_lifnr
           WHERE lifnr = it_rseg_lifnr-lifnr.

  ENDIF.

  SELECT  bukrs  gjahr buzei belnr stceg dmbtr mwsts mwsk1 FROM bsik
INTO CORRESPONDING FIELDS OF TABLE it_bsik
 WHERE   gjahr IN s_gjahr AND
         budat IN s_budat AND
      ( blart = text-003 OR blart = text-004 OR blart = text-015 ).

  IF NOT it_rseg[] IS INITIAL.
    SELECT  bukrs lifnr gjahr erdat FROM lfc1
    APPENDING CORRESPONDING FIELDS OF TABLE it_lfc1
      FOR ALL ENTRIES IN it_rseg

             "BELNR IN S_BELNR AND
       WHERE bukrs = it_rseg-bukrs1 AND
             lifnr  = it_rseg-lifnr AND
             gjahr = it_rseg-gjahr1.


    SELECT lifnr j_1ilstno j_1icstno j_1isern
      FROM j_1imovend
      APPENDING CORRESPONDING FIELDS OF TABLE it_j_1imovend
      FOR ALL ENTRIES IN it_rseg
      WHERE lifnr = it_rseg-lifnr.

  ENDIF.

*ADDING RECORDS TO FINAL INTERNAL TABLE

  SORT it_bseg BY bukrs belnr gjahr buzei.
  SORT it_bset BY bukrs belnr gjahr buzei.
  SORT it_rseg BY bukrs1 belnr1 gjahr1.
  DELETE ADJACENT DUPLICATES FROM it_lfa1 COMPARING lifnr.
  SORT it_lfa1 BY lifnr.

  LOOP AT it_bseg.
    AT NEW belnr.
      v_flag = ' '.
    ENDAT.
    IF v_flag = ' '.
      wa_lifnr_bseg = it_bseg-lifnr.
      v_flag = c_x.
    ENDIF.
    IF wa_lifnr_bseg = it_bseg-lifnr.
*    DO NOTHING
    ELSE.
      it_bseg-lifnr = wa_lifnr_bseg.
      MODIFY it_bseg TRANSPORTING lifnr.
    ENDIF.
  ENDLOOP.

  LOOP AT it_bseg .

    READ TABLE it_bset WITH KEY bukrs = it_bseg-bukrs
                                belnr = it_bseg-belnr
                                gjahr = it_bseg-gjahr
                                kschl = TEXT-016.
    IF sy-subrc = 0.
      it_final-bed = it_bset-hwste.
      it_final-bedrate = it_bset-kbetr / 10.
    ENDIF.

    READ TABLE it_bset WITH KEY bukrs = it_bseg-bukrs
                              belnr = it_bseg-belnr
                              gjahr = it_bseg-gjahr
                              kschl = TEXT-017.
    IF sy-subrc = 0.
      it_final-ebed = it_bset-hwste.
    ENDIF.

    READ TABLE it_bset WITH KEY bukrs = it_bseg-bukrs
                                      belnr = it_bseg-belnr
                                      gjahr = it_bseg-gjahr
                                      kschl = TEXT-018.
    IF sy-subrc = 0.
      it_final-ecs = it_bset-hwste.
    ENDIF.

    READ TABLE it_bset WITH KEY bukrs = it_bseg-bukrs
                                      belnr = it_bseg-belnr
                                      gjahr = it_bseg-gjahr
                                      kschl = TEXT-019.
    IF sy-subrc = 0.
      it_final-shcess = it_bset-hwste.
    ENDIF.

    READ TABLE it_bset WITH KEY bukrs = it_bseg-bukrs
                                      belnr = it_bseg-belnr
                                      gjahr = it_bseg-gjahr
                                      kschl = TEXT-020. " JSVD
    IF sy-subrc = 0.
      it_final-bst = it_bset-hwste.
      it_final-gross = it_bset-hwbas.
    ENDIF.


    READ TABLE it_rseg WITH KEY bukrs1 = it_bset-bukrs
                              belnr1 = it_bset-belnr
                              gjahr1 = it_bset-gjahr
                              count1 = it_bset-txgrp.
    IF sy-subrc EQ 0.
      MOVE it_rseg-bukrs1 TO it_final-bukrs.
      MOVE it_rseg-belnr1 TO it_final-belnr.
      MOVE it_rseg-gjahr1 TO it_final-gjahr.
      MOVE it_rseg-ebeln TO it_final-ebeln.
      MOVE it_rseg-ebelp TO it_final-ebelp.
      MOVE it_rseg-wrbtr TO it_final-wrbtr.
      MOVE it_rseg-wrbtr TO it_final-gross.
      MOVE it_rseg-lifnr TO it_final-lifnr.
      MOVE it_rseg-matnr TO it_final-matnr.
      MOVE it_rseg-mwskz TO it_final-mwskz.
      MOVE it_rseg-belnr TO it_final-g_belnr.
      MOVE it_rseg-buzei TO it_final-buzei.

      READ TABLE it_rseg INTO wa_rseg1 WITH KEY bukrs1 = it_bset-bukrs
                              belnr1 = it_bset-belnr
                              gjahr1 = it_bset-gjahr
                              kschl = TEXT-010.
      IF sy-subrc = 0.
        MOVE wa_rseg1-wrbtr TO it_final-bascus.
      ENDIF.

      READ TABLE it_rseg INTO wa_rseg2 WITH KEY bukrs1 = it_bset-bukrs
                               belnr1 = it_bset-belnr
                               gjahr1 = it_bset-gjahr
                               kschl = TEXT-011.
      IF sy-subrc = 0.
        MOVE wa_rseg2-wrbtr TO it_final-ecustom.
      ENDIF.

      READ TABLE it_makt WITH KEY matnr = it_rseg-matnr.
      IF sy-subrc EQ 0.
        MOVE it_makt-maktx TO it_final-maktx.
      ENDIF.

      READ TABLE it_lfa1 WITH KEY lifnr = it_rseg-lifnr.
      IF sy-subrc EQ 0.
        MOVE it_lfa1-name1 TO it_final-name1.
      ENDIF.


      READ TABLE it_j_1imovend WITH KEY lifnr = it_rseg-lifnr.
*
      IF sy-subrc EQ 0.
        IF wa_cst = c_x.

          MOVE it_j_1imovend-j_1icstno TO it_final-vatcst.
          MOVE it_j_1imovend-j_1isern TO it_final-j_1isern.
        ELSEIF wa_vat = c_x.
          MOVE it_j_1imovend-j_1ilstno TO it_final-vatcst.
          MOVE it_j_1imovend-j_1isern TO it_final-j_1isern.
        ENDIF.
      ENDIF.

      READ TABLE it_bsik WITH KEY bukrs = it_rseg-bukrs1
                                  belnr = it_rseg-belnr1
                                  gjahr = it_rseg-gjahr1.

      IF sy-subrc EQ 0.
        MOVE it_bsik-dmbtr TO it_final-dmbtr.
      ENDIF.
      READ TABLE it_lfc1 WITH KEY bukrs = it_rseg-bukrs1
                                  lifnr = it_rseg-lifnr
                                  gjahr = it_rseg-gjahr1.
      IF sy-subrc EQ 0.
      ENDIF.

      READ TABLE it_bkpf WITH KEY bukrs = it_rseg-bukrs1
                                  belnr = it_rseg-belnr1
                                  gjahr = it_rseg-gjahr1.
      IF sy-subrc EQ 0.
        MOVE it_bkpf-bldat TO it_final-bldat.
        MOVE it_bkpf-budat TO it_final-erdat.
        MOVE it_bkpf-xblnr TO it_final-belnr_b.
        MOVE it_bkpf-blart TO it_final-blart.

        PERFORM get_ref_doc_info.
      ENDIF.
      READ TABLE it_bseg INTO wa_bseg WITH KEY
                                  belnr = it_bseg-belnr
                                  shkzg = TEXT-021.
      IF sy-subrc = 0.
        it_final-hkont = wa_bseg-hkont.

        SELECT  txt20 INTO it_final-pur_text
                 FROM skat
              UP TO 1 ROWS
                 WHERE spras = text-006
                   AND saknr = wa_bseg-hkont.
        ENDSELECT.
      ENDIF.

      READ TABLE it_bseg WITH KEY bukrs = it_bkpf-bukrs
                                belnr = it_bkpf-belnr
                                gjahr = it_bkpf-gjahr.
      IF sy-subrc = 0.
        it_final-paid_d = it_bseg-augdt.
      ENDIF.

      IF wa_cst = c_x OR wa_vat = c_x.
        SELECT SINGLE text1 INTO wa_text
                 FROM t007s
                 WHERE spras = text-006
                   AND kalsm = text-022
                   AND mwskz = it_bseg-mwskz.
        SPLIT wa_text AT '@ ' INTO wa_1 wa_2 .
        MOVE wa_2 TO it_final-mwsk1.
      ENDIF.

    ELSE.

      it_final-name1 = ' '.
      it_final-matnr = ' '.
      it_final-mwskz = ' '.

      MOVE it_bseg-bukrs TO it_final-bukrs.
      MOVE it_bseg-belnr TO it_final-belnr.
      MOVE it_bseg-gjahr TO it_final-gjahr.

      READ TABLE it_bkpf WITH KEY bukrs = it_bseg-bukrs
                                  belnr = it_bseg-belnr
                                  gjahr = it_bseg-gjahr.
      IF sy-subrc EQ 0.
        MOVE it_bkpf-bldat TO it_final-bldat.
        MOVE it_bkpf-budat TO it_final-erdat.
        MOVE it_bkpf-xblnr TO it_final-belnr_b.
        MOVE it_bkpf-blart TO it_final-blart.
        PERFORM get_ref_doc_info.
      ENDIF.

      CLEAR : lv_shkzg.
      IF it_final-blart = TEXT-076. " 'KG'/Reversal Doc
        lv_shkzg = TEXT-021.
      ELSE.
        lv_shkzg = TEXT-014.
      ENDIF.
      IF it_bseg-shkzg = lv_shkzg.
        wa_lifnr = it_bseg-lifnr.
      ENDIF.

      CLEAR : wa_bseg, lv_shkzg.
      IF it_final-blart = TEXT-076. " 'KG'/Reversal Doc
        lv_shkzg = TEXT-014.
      ELSE.
        lv_shkzg = TEXT-021.
      ENDIF.
      READ TABLE it_bseg INTO wa_bseg WITH KEY
                                  belnr = it_bseg-belnr
                                  shkzg = lv_shkzg
                                  mwskz = TEXT-005." [06-04-2012]
      IF NOT wa_bseg IS INITIAL.
        it_final-hkont = wa_bseg-hkont.
        SELECT  txt20 INTO it_final-pur_text
                 FROM skat
              UP TO 1 ROWS
                 WHERE spras = text-006
                   AND saknr = wa_bseg-hkont.
        ENDSELECT.
      ENDIF.
      IF wa_flag_lifnr = c_x.
      ELSE.
        wa_lifnr = it_bseg-lifnr.
      ENDIF.
      IF wa_cst = c_x OR wa_vat = c_x.
        SELECT SINGLE text1 INTO wa_text
                 FROM t007s
                 WHERE spras = text-006
                   AND kalsm = text-022
                   AND mwskz = it_bseg-mwskz.
        SPLIT wa_text AT '@ ' INTO wa_1 wa_2 .
        MOVE wa_2 TO it_final-mwsk1.
      ENDIF.

      READ TABLE it_j_1imovend WITH KEY lifnr = wa_lifnr.
      IF sy-subrc EQ 0.

        MOVE it_j_1imovend-j_1isern TO it_final-j_1isern.
      ENDIF.

      READ TABLE it_lfc1 WITH KEY bukrs = it_bseg-bukrs
                                  lifnr = wa_lifnr
                                  gjahr = it_bseg-gjahr.
      IF sy-subrc EQ 0.
      ENDIF.


      READ TABLE it_bsik WITH KEY bukrs = it_bseg-bukrs
                                  belnr = it_bseg-belnr
                                  gjahr = it_bseg-gjahr.
      IF sy-subrc EQ 0.
        MOVE it_bsik-dmbtr TO it_final-dmbtr.
      ENDIF.

      IF it_bseg-shkzg = TEXT-014 AND it_bset-shkzg NE TEXT-021.
        wa_flag_lifnr = c_x.
        wa_gross = it_bseg-dmbtr.
        CONTINUE.
      ENDIF.

    ENDIF.

    READ TABLE it_lfa1 WITH KEY lifnr = wa_lifnr.
    IF sy-subrc EQ 0.
      MOVE wa_lifnr TO it_final-lifnr .
      MOVE it_lfa1-name1 TO it_final-name1.
    ENDIF.

     READ TABLE it_j_1imovend WITH KEY lifnr = it_bseg-lifnr.
      IF sy-subrc EQ 0.

        MOVE it_j_1imovend-j_1isern TO it_final-j_1isern.
      ENDIF.

    READ TABLE it_bseg WITH KEY bukrs = it_bkpf-bukrs
                                    belnr = it_bkpf-belnr
                                    gjahr = it_bkpf-gjahr.
    IF sy-subrc = 0.
      " Pay date for BP docs shld b same as posting date of Acct doc
      IF it_final-blart = TEXT-075.
        it_final-paid_d = it_final-erdat.
      ELSE.
        it_final-paid_d = it_bseg-augdt.
      ENDIF.
    ENDIF.

    IF it_final-blart = TEXT-076. "'KG': Reversal Doc/ Credit Memo
      it_final-bed    = it_final-bed    * -1.
      it_final-ebed   = it_final-ebed   * -1.
      it_final-ecs    = it_final-ecs    * -1.
      it_final-shcess = it_final-shcess * -1.
      it_final-bst    = it_final-bst    * -1.
      it_final-gross  = it_final-gross  * -1.
    ENDIF.

    it_final-gross_tot = it_final-bst + it_final-ecs + it_final-shcess.
    IF sy-tabix GE c_1.
      " TRANSPORTING ECS SHCESS.
      MODIFY it_final FROM it_final INDEX sy-tabix.
      IF sy-subrc NE 0.
        APPEND it_final.
      ENDIF.
    ENDIF.

    CLEAR : it_makt,it_bseg,it_rseg,it_bkpf, it_j_1imovend, it_lfc1,
        it_bsik , wa_flag_lifnr, it_final, wa_cst, wa_vat, wa_lifnr.

  ENDLOOP.

  it_rseg[] = it_rseg1[].
  SORT it_rseg1 BY ebeln ebelp belnr.

  DELETE it_rseg1 WHERE lfpos NE 0.
  LOOP AT it_rseg1.
    READ TABLE it_final WITH KEY g_belnr = it_rseg1-belnr
                                 buzei   = it_rseg1-buzei.
    IF sy-subrc NE 0.
      CLEAR : it_final-bed ,it_final-bedrate,it_final-ecs,it_final-ebed,
              it_final-rmded, it_final-rmnon, it_final-cgded,
              it_final-cgnon,it_final-cstrate,it_final-sertax,
              it_final-esertax,it_final-shcess, it_final-shrate.

      CASE it_rseg1-kschl.
        WHEN TEXT-023.
          it_final-acd = it_rseg1-wrbtr.
        WHEN TEXT-024.
          it_final-cvd = it_rseg1-wrbtr.
        WHEN TEXT-025.
          it_final-ecvd = it_rseg1-wrbtr.
        WHEN TEXT-026.
      ENDCASE.


      MOVE it_rseg1-bukrs1 TO it_final-bukrs.
      MOVE it_rseg1-belnr1 TO it_final-belnr.
      MOVE it_rseg1-gjahr1 TO it_final-gjahr.
      MOVE it_rseg1-ebeln TO it_final-ebeln.
      MOVE it_rseg1-ebelp TO it_final-ebelp.
      MOVE it_rseg1-wrbtr TO it_final-wrbtr.
      MOVE it_rseg1-lifnr TO it_final-lifnr.
      MOVE it_rseg1-name1 TO it_final-name1.
      MOVE it_rseg1-matnr TO it_final-matnr.
      MOVE it_rseg1-mwskz TO it_final-mwskz.
      MOVE it_rseg1-belnr TO it_final-g_belnr.
      MOVE it_rseg1-buzei TO it_final-buzei.

      READ TABLE it_makt WITH KEY matnr = it_final-matnr.
      IF sy-subrc EQ 0.
        MOVE it_makt-maktx TO it_final-maktx.
      ENDIF.

      AT END OF belnr.
        it_final-gross_tot = it_final-bst + it_final-ecs + it_final-shcess.
        APPEND it_final.
        CLEAR it_final.
      ENDAT.
    ENDIF.
  ENDLOOP.

  loop at it_final.
    break ajoshi.
    read table it_bseg3 with key belnr = it_final-belnr gjahr = it_final-gjahr.
    if sy-subrc = 0.
      if it_final-lifnr is INITIAL.
      it_final-lifnr = it_bseg3-lifnr.

   READ TABLE it_lfa1 WITH KEY lifnr = it_bseg3-lifnr.
    IF sy-subrc EQ 0.
        MOVE it_lfa1-name1 TO it_final-name1.
    ENDIF.
    endif.
    endif.
   modify it_final.
   endloop.


  SORT it_final BY erdat bukrs belnr gjahr g_belnr buzei.
  DELETE it_final WHERE belnr EQ space.
  DELETE ADJACENT DUPLICATES FROM it_final COMPARING bukrs belnr gjahr g_belnr buzei.
  SORT it_bset1 BY bukrs belnr gjahr.
  DELETE ADJACENT DUPLICATES FROM it_bset1 COMPARING bukrs belnr gjahr.

  " calculation for the Service Tax Rate
  PERFORM get_service_tax_rate.

  IF p_inv NE c_x.
    PERFORM f_listheader.
    PERFORM f_fieldcatalog.
    PERFORM f_layout.
    PERFORM f_displaygrid.
  ENDIF.

  IF p_inv EQ c_x.
    PERFORM f_fieldcat.
    PERFORM f_dispgrid.
  ENDIF.

  CLEAR : wa_flag_lifnr, wa_gross, wa_lifnr, wa_text, wa_1, wa_2, wa_cst, wa_bseg.
  CLEAR : it_bseg, it_bkpf, it_bset, it_rseg, lv_shkzg.

ENDFORM.                    " PROCESS_DATA
*&---------------------------------------------------------------------*
*&      FORM  F_FIELDCATALOG
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM f_fieldcatalog .

  t_fieldcatalog-fieldname = TEXT-027.
  t_fieldcatalog-seltext_l = TEXT-028.
  t_fieldcatalog-outputlen = c_10.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  " Begin of changes by mbhosale [28/03/2012]
  t_fieldcatalog-fieldname = TEXT-070.
  t_fieldcatalog-seltext_l = TEXT-071.
  t_fieldcatalog-outputlen = c_4.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.
  " End of changes by mbhosale [28/03/2012]

  t_fieldcatalog-fieldname = TEXT-031.
  t_fieldcatalog-seltext_l = TEXT-032.
  t_fieldcatalog-outputlen = c_20.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-033.
  t_fieldcatalog-seltext_l = TEXT-034.
  t_fieldcatalog-outputlen = c_20.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-035.
  t_fieldcatalog-seltext_l = TEXT-036.
  t_fieldcatalog-outputlen = c_10.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-039.
  t_fieldcatalog-seltext_l = TEXT-040.
  t_fieldcatalog-outputlen = c_10.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-037.
  t_fieldcatalog-seltext_l = TEXT-038.
  t_fieldcatalog-outputlen = c_35.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-029.
  t_fieldcatalog-seltext_l = TEXT-030.
  t_fieldcatalog-outputlen = c_15.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-041.
  t_fieldcatalog-seltext_l = TEXT-042.
  t_fieldcatalog-outputlen = c_10.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-043.
  t_fieldcatalog-seltext_l = TEXT-045.
  t_fieldcatalog-outputlen = c_20.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-044.
  t_fieldcatalog-seltext_l = TEXT-046.
  t_fieldcatalog-outputlen = c_15.
  t_fieldcatalog-do_sum = 'X'.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.


  t_fieldcatalog-fieldname = TEXT-073.
  t_fieldcatalog-seltext_l = TEXT-074.
  t_fieldcatalog-outputlen = c_10.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-047.
  t_fieldcatalog-seltext_l = TEXT-048.
  t_fieldcatalog-outputlen = c_15.
  t_fieldcatalog-do_sum = 'X'.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-049.
  t_fieldcatalog-seltext_l = TEXT-050.
  t_fieldcatalog-outputlen = c_15.
  t_fieldcatalog-do_sum = 'X'.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-051.
  t_fieldcatalog-seltext_l = TEXT-052.
  t_fieldcatalog-outputlen = c_15.
  t_fieldcatalog-do_sum = 'X'.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-053.
  t_fieldcatalog-seltext_l = TEXT-054.
  t_fieldcatalog-outputlen = c_15.
  t_fieldcatalog-do_sum = 'X'.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

  t_fieldcatalog-fieldname = TEXT-055.
  t_fieldcatalog-seltext_l = TEXT-056.
  t_fieldcatalog-outputlen = c_10.
  APPEND t_fieldcatalog.
  CLEAR t_fieldcatalog.

ENDFORM.                    " F_FIELDCATALOG
*&---------------------------------------------------------------------*
*&      FORM  F_DISPLAYGRID
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM f_displaygrid .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = TEXT-057 "Top of page
      is_layout              = fs_layout
      it_fieldcat            = t_fieldcatalog[]
      it_events              = t_event[]
      i_save                 = 'A'
    TABLES
      t_outtab               = it_final
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.                    " F_DISPLAYGRID
*&---------------------------------------------------------------------*
*&      FORM  F_LISTHEADER
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM f_listheader .

  DATA : frmdt(10) TYPE c,
         todt(10)  TYPE c,
         v_str     TYPE string.


  t_listheader-typ = TEXT-014."H
  t_listheader-key = ' '.
  t_listheader-info = TEXT-059.
  APPEND t_listheader.

  IF s_budat-low NE c_0 AND  s_budat-high NE c_0      .
    WRITE s_budat-low  TO frmdt USING EDIT MASK TEXT-061."'__.__.____'.
    WRITE s_budat-high TO todt  USING EDIT MASK TEXT-061.
    CONCATENATE TEXT-062
                 frmdt
                 TEXT-063
                 todt
           INTO v_str SEPARATED BY space.
  ELSEIF s_budat-low NE c_0 AND  s_budat-high EQ c_0      .
    WRITE s_budat-low  TO frmdt USING EDIT MASK TEXT-061.
    CONCATENATE TEXT-069
                 frmdt
           INTO v_str SEPARATED BY space.
  ELSEIF s_budat-low EQ c_0 AND  s_budat-high NE c_0      .
    WRITE s_budat-high  TO todt USING EDIT MASK TEXT-061.
    CONCATENATE TEXT-069
                 todt
           INTO v_str SEPARATED BY space.
  ENDIF.
  t_listheader-typ = TEXT-021."S
  t_listheader-key = ' '.
  t_listheader-info = v_str.
  APPEND t_listheader.


ENDFORM.                    " F_LISTHEADER
*&---------------------------------------------------------------------*
*&      FORM  F_LAYOUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM f_layout .
  t_event-name = slis_ev_top_of_page.
  t_event-form = TEXT-057."'TOP_OF_PAGE'.
  APPEND t_event.
  fs_layout-colwidth_optimize = c_x.
  fs_layout-totals_text = 'TOTALS_TEXT'.
ENDFORM.                    " F_LAYOUT

*&---------------------------------------------------------------------*
*&      FORM  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM top_of_page.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_listheader[].

ENDFORM.                    "TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      FORM  F_FIELDCAT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM f_fieldcat .

  t_fieldcat-fieldname = TEXT-068.
  t_fieldcat-seltext_l = TEXT-067.
  t_fieldcat-outputlen = c_10.
  APPEND t_fieldcat.
  CLEAR t_fieldcat.

  t_fieldcat-fieldname = TEXT-031.
  t_fieldcat-seltext_l = TEXT-066.
  t_fieldcat-outputlen = c_10.
  APPEND t_fieldcat.
  CLEAR t_fieldcat.

  t_fieldcat-fieldname = TEXT-065.
  t_fieldcat-seltext_l = TEXT-064.
  t_fieldcat-outputlen = c_4.
  APPEND t_fieldcat.
  CLEAR t_fieldcat.



ENDFORM.                    " F_FIELDCAT
*&---------------------------------------------------------------------*
*&      FORM  F_DISPGRID
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM f_dispgrid .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = t_fieldcat[]
      i_save             = 'A'
    TABLES
      t_outtab           = it_bset1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " F_DISPGRID
*&---------------------------------------------------------------------*
*&      Form  GET_REF_DOC_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_ref_doc_info .
  DATA lv_str TYPE char10.
  CLEAR lv_str.

  IF it_final-blart = 'RE'.
    "it_final-awkey_inv = it_bkpf-awkey+0(10).
    " invoice receipt number
    lv_str = it_bkpf-awkey+0(10).
    " Extract ref. doc. no. for the invoice receipt
    SELECT SINGLE xblnr
      FROM rbkp
      INTO it_final-awkey_inv
      WHERE belnr = lv_str.
  ELSEIF it_final-blart = 'KR'.
    it_final-awkey_inv = it_bkpf-xblnr.
  ENDIF.
ENDFORM.                    " GET_REF_DOC_INFO
*&---------------------------------------------------------------------*
*&      Form  GET_SERVICE_TAX_RATE
*&---------------------------------------------------------------------*
*       Calculate the Service Tax Rate
*----------------------------------------------------------------------*
FORM get_service_tax_rate.
  DATA stxrt TYPE p DECIMALS 2.
  LOOP AT it_final.
    CLEAR stxrt.
    IF it_final-gross NE '0.00' AND it_final-gross_tot NE '0.00'.
      stxrt = ( it_final-gross_tot / it_final-gross ) * 100.
    ENDIF.
    it_final-stxrt = stxrt.
    CONCATENATE it_final-stxrt c_prcntg INTO it_final-stxrt.
    MODIFY it_final.
    CLEAR it_final.
  ENDLOOP.
ENDFORM.                    " GET_SERVICE_TAX_RATE
