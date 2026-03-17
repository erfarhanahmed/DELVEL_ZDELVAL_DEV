*&---------------------------------------------------------------------*
*& Report ZTCS_ACCU_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztcs_accu_report.

TABLES : J_1IG_ACCUMDTL,BSEG,KNA1,BSET.

TYPE-POOLS : SLIS,
             OLE2.

TYPES : BEGIN OF ty_j_1ig_accumdtl,
          thld_cat     TYPE j_1ig_accumdtl-thld_cat,
          seller_pan   TYPE j_1ig_accumdtl-seller_pan,
          buyer_idtype TYPE j_1ig_accumdtl-buyer_idtype,
          buyer_id     TYPE j_1ig_accumdtl-buyer_id,
          kunnr        TYPE j_1ig_accumdtl-kunnr,
          valid_from   TYPE j_1ig_accumdtl-valid_from,
          accum_seq    TYPE j_1ig_accumdtl-accum_seq,
          bukrs        TYPE j_1ig_accumdtl-bukrs,
          belnr        TYPE j_1ig_accumdtl-belnr,
          gjahr        TYPE j_1ig_accumdtl-gjahr,
          buzei        TYPE j_1ig_accumdtl-buzei,
          blart        TYPE j_1ig_accumdtl-blart,
          budat        TYPE j_1ig_accumdtl-budat,
          accum_prev   TYPE j_1ig_accumdtl-accum_prev,
          tcs_prev     TYPE j_1ig_accumdtl-tcs_prev,
          item_amt     TYPE j_1ig_accumdtl-item_amt,
          tcs_base     TYPE j_1ig_accumdtl-tcs_base,
          tcs_rate     TYPE j_1ig_accumdtl-tcs_rate,
          tcs_amt      TYPE j_1ig_accumdtl-tcs_amt,
          accum_curr   TYPE j_1ig_accumdtl-accum_curr,
          tcs_curr     TYPE j_1ig_accumdtl-tcs_curr,
          adj_amt      TYPE j_1ig_accumdtl-adj_amt,
          adv_amt      TYPE j_1ig_accumdtl-adv_amt,
          jv           TYPE j_1ig_accumdtl-jv,
          jv_status    TYPE j_1ig_accumdtl-jv_status,
          thld_amt     TYPE j_1ig_accumdtl-thld_amt,
        END OF ty_j_1ig_accumdtl.

TYPES : BEGIN OF  ty_bseg,
          bukrs TYPE bseg-bukrs,
          belnr TYPE bseg-belnr,
          gjahr TYPE bseg-gjahr,
          buzei TYPE bseg-buzei,
          shkzg TYPE bseg-shkzg,
          txgrp TYPE vbrp-posnr,
          vbeln TYPE bseg-vbeln,
          kunnr TYPE bseg-kunnr,
        END OF ty_bseg.

TYPES : BEGIN OF ty_bseg1,
          bukrs TYPE bseg-bukrs,
          belnr TYPE bseg-belnr,
          gjahr TYPE bseg-gjahr,
          buzei TYPE bseg-buzei,
          mwskz TYPE bseg-mwskz,
          txgrp TYPE bseg-txgrp,
          ktosl TYPE bseg-ktosl,
          matnr TYPE bseg-matnr,
          meins TYPE bseg-meins,
       END OF ty_bseg1.

TYPES : BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
        END OF ty_kna1.

TYPES : BEGIN OF ty_vbrk,
          vbeln TYPE vbrk-vbeln,
          fkart TYPE vbrk-fkart,
        END OF ty_vbrk.

TYPES : BEGIN OF ty_bset,
          bukrs TYPE bset-bukrs,
          belnr TYPE bset-belnr,
          gjahr TYPE bset-gjahr,
          buzei TYPE bset-buzei,
          txgrp TYPE bset-txgrp,
        END OF ty_bset.

TYPES : BEGIN OF ty_vbrp,
          vbeln TYPE vbrp-vbeln,
          posnr TYPE vbrp-posnr,
          matnr TYPE vbrp-matnr,
        END OF ty_vbrp.

TYPES : BEGIN OF ty_final,
          thld_cat     TYPE j_1ig_accumdtl-thld_cat,
          seller_pan   TYPE j_1ig_accumdtl-seller_pan,
          buyer_idtype TYPE j_1ig_accumdtl-buyer_idtype,
          buyer_id     TYPE j_1ig_accumdtl-buyer_id,
          kunnr        TYPE j_1ig_accumdtl-kunnr,
          valid_from   TYPE j_1ig_accumdtl-valid_from,
          accum_seq    TYPE j_1ig_accumdtl-accum_seq,
          bukrs        TYPE j_1ig_accumdtl-bukrs,
          belnr        TYPE j_1ig_accumdtl-belnr,
          gjahr        TYPE j_1ig_accumdtl-gjahr,
          buzei        TYPE j_1ig_accumdtl-buzei,
          blart        TYPE j_1ig_accumdtl-blart,
          budat        TYPE j_1ig_accumdtl-budat,
          accum_prev   TYPE j_1ig_accumdtl-accum_prev,
          tcs_prev     TYPE j_1ig_accumdtl-tcs_prev,
          item_amt     TYPE j_1ig_accumdtl-item_amt,
          tcs_base     TYPE j_1ig_accumdtl-tcs_base,
          "tcs_rate     TYPE j_1ig_accumdtl-tcs_rate,
          tcs_rate(11)  TYPE  p DECIMALS 3,
          tcs_amt      TYPE j_1ig_accumdtl-tcs_amt,
          accum_curr   TYPE j_1ig_accumdtl-accum_curr,
          tcs_curr     TYPE j_1ig_accumdtl-tcs_curr,
          adj_amt      TYPE j_1ig_accumdtl-adj_amt,
          adv_amt      TYPE j_1ig_accumdtl-adv_amt,
          jv           TYPE j_1ig_accumdtl-jv,
          jv_status    TYPE j_1ig_accumdtl-jv_status,
          thld_amt     TYPE j_1ig_accumdtl-thld_amt,
          vbeln        TYPE bseg-vbeln,
          kunnr1       TYPE bseg-kunnr,
          name1        TYPE kna1-name1,
          fkart        TYPE vbrk-fkart,
          txgrp        TYPE bset-txgrp,
          matnr        TYPE bseg-matnr,
END OF ty_final.

TYPES : BEGIN OF ty_ref,
          thld_cat     TYPE j_1ig_accumdtl-thld_cat,
          seller_pan   TYPE j_1ig_accumdtl-seller_pan,
          buyer_idtype TYPE j_1ig_accumdtl-buyer_idtype,
          buyer_id     TYPE j_1ig_accumdtl-buyer_id,
          kunnr        TYPE j_1ig_accumdtl-kunnr,
          valid_from   TYPE char15,
          accum_seq    TYPE j_1ig_accumdtl-accum_seq,
          bukrs        TYPE j_1ig_accumdtl-bukrs,
          belnr        TYPE j_1ig_accumdtl-belnr,
          gjahr        TYPE j_1ig_accumdtl-gjahr,
          buzei        TYPE j_1ig_accumdtl-buzei,
          blart        TYPE j_1ig_accumdtl-blart,
          budat        TYPE char15,
          accum_prev   TYPE char15,
          tcs_prev     TYPE char15,
          item_amt     TYPE char15,
          tcs_base     TYPE char15,
          tcs_rate     TYPE char15,
          tcs_amt      TYPE char15,
          accum_curr   TYPE char15,
          tcs_curr     TYPE char15,
          adj_amt      TYPE char15,
          adv_amt      TYPE char15,
          jv           TYPE j_1ig_accumdtl-jv,
          jv_status    TYPE j_1ig_accumdtl-jv_status,
          thld_amt     TYPE char15,
          sdate        TYPE char15,
          vbeln        TYPE bseg-vbeln,
          kunnr1       TYPE bseg-kunnr,
          name1        TYPE kna1-name1,
          fkart        TYPE vbrk-fkart,
          txgrp        TYPE bset-txgrp,
          matnr        TYPE bseg-matnr,
        END OF ty_ref.

DATA : lt_accumdtl TYPE STANDARD TABLE OF ty_j_1ig_accumdtl,
       ls_accumdtl TYPE                   ty_j_1ig_accumdtl,

       lt_bseg     TYPE STANDARD TABLE OF ty_bseg,
       ls_bseg     TYPE                   ty_bseg,

       lt_kna1     TYPE STANDARD TABLE OF ty_kna1,
       ls_kna1     TYPE                   ty_kna1,

       lt_vbrk     TYPE STANDARD TABLE OF ty_vbrk,
       ls_vbrk     TYPE                   ty_vbrk,

       lt_bset    TYPE STANDARD TABLE OF ty_bset,
       ls_bset    TYPE                   ty_bset,

       lt_bseg1   TYPE STANDARD TABLE OF ty_bseg1,
       ls_bseg1   TYPE                   ty_bseg1,

       lt_vbrp    TYPE STANDARD TABLE OF ty_vbrp,
       ls_vbrp    TYPE                   ty_vbrp,

       lt_final   TYPE STANDARD TABLE OF ty_final,
       ls_final   TYPE                   ty_final,

       lt_ref     TYPE STANDARD TABLE OF ty_ref,
       ls_ref     TYPE                   ty_ref.

DATA : gv_posnr type vbrp-posnr.

DATA:
      LT_FIELDCAT     TYPE SLIS_T_FIELDCAT_ALV,
      LS_ALV_LAYOUT   TYPE SLIS_LAYOUT_ALV.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE XYZ.
  SELECT-OPTIONS : s_bukrs    FOR j_1ig_accumdtl-bukrs,
                   s_buyid    FOR j_1ig_accumdtl-buyer_id,
                   s_belnr    FOR j_1ig_accumdtl-belnr.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE ABC .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER TYPE RLGRAP-FILENAME DEFAULT  '/Delval/India'."India'."temp'.            "'/delval/temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
  SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.



AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FOLDER.

CALL FUNCTION 'F4_FILENAME'
EXPORTING
  PROGRAM_NAME  = SYST-CPROG
  DYNPRO_NUMBER = SYST-DYNNR

IMPORTING
  FILE_NAME     = P_FOLDER.


START-OF-SELECTION.

PERFORM GET_DATA.
PERFORM FIELDCAT.

END-OF-SELECTION.

PERFORM DISPLAY_DATA.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
break primus.
  SELECT thld_cat
         seller_pan
         buyer_idtype
         buyer_id
         kunnr
         valid_from
         accum_seq
         bukrs
         belnr
         gjahr
         buzei
         blart
         budat
         accum_prev
         tcs_prev
         item_amt
         tcs_base
         tcs_rate
         tcs_amt
         accum_curr
         tcs_curr
         adj_amt
         adv_amt
         jv
         jv_status
         thld_amt
         FROM j_1ig_accumdtl
         INTO TABLE lt_accumdtl
         WHERE bukrs    IN s_bukrs and
               buyer_id IN s_buyid and
               belnr    IN s_belnr.

  IF lt_accumdtl IS NOT INITIAL.

    SELECT bukrs
           belnr
           gjahr
           buzei
           shkzg
           txgrp
           vbeln
           kunnr
           FROM bseg
           INTO TABLE lt_bseg
           FOR ALL ENTRIES IN lt_accumdtl
           WHERE belnr = lt_accumdtl-belnr and
                 gjahr = lt_accumdtl-gjahr and
                 vbeln NE ' '.
                " shkzg = 'H'.
  ENDIF.

  IF lt_bseg IS NOT INITIAL.

    SELECT kunnr
           name1
           FROM kna1
           INTO TABLE lt_kna1
           FOR ALL ENTRIES IN lt_bseg
           WHERE kunnr = lt_bseg-kunnr.

    SELECT vbeln
           fkart
           FROM vbrk
           INTO TABLE lt_vbrk
           FOR ALL ENTRIES IN lt_bseg
           WHERE vbeln = lt_bseg-vbeln.

  ENDIF.

   IF lt_accumdtl IS NOT INITIAL.

     SELECT bukrs
            belnr
            gjahr
            buzei
            txgrp
            FROM bset
            INTO TABLE lt_bset
            FOR ALL ENTRIES IN lt_accumdtl
            WHERE belnr = lt_accumdtl-belnr AND
                  buzei = lt_accumdtl-buzei.
   ENDIF.

   IF lt_bseg IS NOT INITIAL.

      SELECT vbeln
             posnr
             matnr
             FROM vbrp
             INTO TABLE lt_vbrp
             FOR ALL ENTRIES IN lt_bseg
             WHERE vbeln = lt_bseg-vbeln AND
                   posnr = lt_bseg-txgrp.

   ENDIF.
   IF lt_bset IS NOT INITIAL.
     SELECT bukrs
            belnr
            gjahr
            buzei
            mwskz
            txgrp
            ktosl
            matnr
            meins
            FROM bseg
            INTO TABLE lt_bseg1
            FOR ALL ENTRIES IN lt_bset
            WHERE belnr = lt_bset-belnr AND
                  txgrp = lt_bset-txgrp AND
                  gjahr = lt_bset-gjahr AND
                  bukrs = lt_bset-bukrs AND
                  meins NE ' '.

   ENDIF.

   LOOP AT lt_accumdtl INTO ls_accumdtl.

     ls_final-thld_cat     = ls_accumdtl-thld_cat.
     ls_final-seller_pan   = ls_accumdtl-seller_pan.
     ls_final-buyer_idtype = ls_accumdtl-buyer_idtype.
     ls_final-buyer_id     = ls_accumdtl-buyer_id.
     ls_final-kunnr        = ls_accumdtl-kunnr.
     ls_final-valid_from   = ls_accumdtl-valid_from.
     ls_final-accum_seq    = ls_accumdtl-accum_seq.
     ls_final-bukrs        = ls_accumdtl-bukrs.
     ls_final-belnr        = ls_accumdtl-belnr.
     ls_final-gjahr        = ls_accumdtl-gjahr.
     ls_final-buzei        = ls_accumdtl-buzei.
     ls_final-blart        = ls_accumdtl-blart.
     ls_final-budat        = ls_accumdtl-budat.
     ls_final-accum_prev   = ls_accumdtl-accum_prev.
     ls_final-tcs_prev     = ls_accumdtl-tcs_prev.
     ls_final-item_amt     = ls_accumdtl-item_amt.
     ls_final-tcs_base     = ls_accumdtl-tcs_base.
     ls_final-tcs_rate     = ls_accumdtl-tcs_rate / 10.
     ls_final-tcs_amt      = ls_accumdtl-tcs_amt.
     ls_final-accum_curr   = ls_accumdtl-accum_curr.
     ls_final-tcs_curr     = ls_accumdtl-tcs_curr.
     ls_final-adj_amt      = ls_accumdtl-adj_amt.
     ls_final-adv_amt      = ls_accumdtl-adv_amt.
     ls_final-jv           = ls_accumdtl-jv.
     ls_final-jv_status    = ls_accumdtl-jv_status.
     ls_final-thld_amt     = ls_accumdtl-thld_amt.

     READ TABLE lt_bseg INTO ls_bseg WITH KEY belnr = ls_final-belnr
                                              gjahr = ls_final-gjahr.
       IF SY-SUBRC IS INITIAL.
          ls_final-vbeln  = ls_bseg-vbeln.
          ls_final-kunnr1 = ls_bseg-kunnr.
       ENDIF.

     READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = ls_final-kunnr1.
       IF SY-SUBRC IS INITIAL.
          ls_final-name1 = ls_kna1-name1.
       ENDIF.

     READ TABLE lt_vbrk INTO ls_vbrk WITH KEY vbeln = ls_final-vbeln.
       IF SY-SUBRC IS INITIAL.
          ls_final-fkart = ls_vbrk-fkart.
       ENDIF.

     READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_final-belnr
                                              buzei = ls_final-buzei.
       IF SY-SUBRC IS INITIAL.
          ls_final-txgrp = ls_bset-txgrp.
       ENDIF.

     READ TABLE lt_bseg1 INTO ls_bseg1 WITH KEY belnr = ls_bset-belnr
                                                txgrp = ls_bset-txgrp.
       IF SY-SUBRC IS INITIAL.
          ls_final-matnr = ls_bseg1-matnr.
       ENDIF.

      READ TABLE lt_vbrp INTO ls_vbrp WITH KEY vbeln = ls_bseg-vbeln
                                               posnr = ls_bseg-txgrp.
        IF SY-SUBRC IS INITIAL.
           ls_final-matnr = ls_vbrp-matnr.
        ENDIF.


    APPEND ls_final TO lt_final.
    CLEAR : ls_final,ls_accumdtl,ls_bseg,ls_kna1,ls_vbrk,ls_bset,ls_bseg1,ls_vbrp.
 ENDLOOP.

 IF P_DOWN = 'X'.
  LOOP AT lt_final INTO ls_final.
   ls_ref-thld_cat     = ls_final-thld_cat.
   ls_ref-seller_pan   = ls_final-seller_pan.
   ls_ref-buyer_idtype = ls_final-buyer_idtype.
   ls_ref-buyer_id     = ls_final-buyer_id.
   ls_ref-kunnr        = ls_final-kunnr.
*   ls_ref-valid_from   = ls_final-valid_from.
   ls_ref-accum_seq    = ls_final-accum_seq.
   ls_ref-bukrs        = ls_final-bukrs.
   ls_ref-belnr        = ls_final-belnr.
   ls_ref-gjahr        = ls_final-gjahr.
   ls_ref-buzei        = ls_final-buzei.
   ls_ref-blart        = ls_final-blart.
   ls_ref-budat        = ls_final-budat.
   ls_ref-accum_prev   = ls_final-accum_prev.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
         VALUE = ls_ref-accum_prev.

   ls_ref-tcs_prev     = ls_final-tcs_prev.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
         VALUE = ls_ref-tcs_prev.

   ls_ref-item_amt     = ls_final-item_amt.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
         VALUE = ls_ref-item_amt.

   ls_ref-tcs_base     = ls_final-tcs_base.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
         VALUE = ls_ref-tcs_base.

   ls_ref-tcs_rate     = ls_final-tcs_rate.

   ls_ref-tcs_amt      = ls_final-tcs_amt.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
         VALUE = ls_ref-tcs_amt.

   ls_ref-accum_curr   = ls_final-accum_curr.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
         VALUE = ls_ref-accum_curr.

   ls_ref-tcs_curr     = ls_final-tcs_curr.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
         VALUE = ls_ref-tcs_curr.

   ls_ref-adj_amt      = ls_final-adj_amt.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
         VALUE = ls_ref-adj_amt.

   ls_ref-adv_amt      = ls_final-adv_amt.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
         VALUE = ls_ref-adv_amt.
   ls_ref-jv           = ls_final-jv.
   ls_ref-jv_status    = ls_final-jv_status.
   ls_ref-thld_amt     = ls_final-thld_amt.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
         VALUE = ls_ref-thld_amt.

    IF ls_final-valid_from IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      INPUT  = ls_final-valid_from
    IMPORTING
      OUTPUT = ls_ref-valid_from.

    CONCATENATE ls_ref-valid_from+0(2) ls_ref-valid_from+2(3) ls_ref-valid_from+5(4)
    INTO ls_ref-valid_from SEPARATED BY '-'.
    ENDIF.

    IF ls_final-budat IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      INPUT  = ls_final-budat
    IMPORTING
      OUTPUT = ls_ref-budat.

    CONCATENATE ls_ref-budat+0(2) ls_ref-budat+2(3) ls_ref-budat+5(4)
    INTO ls_ref-budat SEPARATED BY '-'.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      INPUT  = SY-DATUM
    IMPORTING
      OUTPUT = ls_ref-sdate.

    CONCATENATE ls_ref-sdate+0(2) ls_ref-sdate+2(3) ls_ref-sdate+5(4)
    INTO ls_ref-sdate SEPARATED BY '-'.

    ls_ref-vbeln  = ls_final-vbeln.
    ls_ref-kunnr1 = ls_final-kunnr1.
    ls_ref-name1  = ls_final-name1.
    ls_ref-fkart  = ls_final-fkart.
    ls_ref-txgrp  = ls_final-txgrp.
    ls_ref-matnr  = ls_final-matnr.


   APPEND ls_ref TO lt_ref.
   CLEAR : ls_final,ls_accumdtl,ls_ref.

  ENDLOOP.
 ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcat .

  DATA:
        GV_POS      TYPE I,
        LS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

  REFRESH LT_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'THLD_CAT'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Threshold amt category'.
  LS_FIELDCAT-SELTEXT_L  = 'Threshold amt category'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'SELLER_PAN'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Permanent account no'.
  LS_FIELDCAT-SELTEXT_L  = 'Permanent account no'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'BUYER_IDTYPE'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Type of ID Number'.
  LS_FIELDCAT-SELTEXT_L  = 'Type of ID Number'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'BUYER_ID'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Identification Number'.
  LS_FIELDCAT-SELTEXT_L  = 'Identification Number'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'KUNNR'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Customer Number'.
  LS_FIELDCAT-SELTEXT_L  = 'Customer Number'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'VALID_FROM'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Valid From Date'.
  LS_FIELDCAT-SELTEXT_L  = 'Valid From Date'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'ACCUM_SEQ'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Sequence number'.
  LS_FIELDCAT-SELTEXT_L  = 'Sequence number'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'BUKRS'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Company Code'.
  LS_FIELDCAT-SELTEXT_L  = 'Company Code'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'BELNR'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Accounting Doc No'.
  LS_FIELDCAT-SELTEXT_L  = 'Accounting Doc No'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'GJAHR'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Fiscal Year'.
  LS_FIELDCAT-SELTEXT_L  = 'Fiscal Year'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'BUZEI'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Line Item'.
  LS_FIELDCAT-SELTEXT_L  = 'Line Item'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'BLART'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Document type'.
  LS_FIELDCAT-SELTEXT_L  = 'Document type'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'BUDAT'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Posting Date'.
  LS_FIELDCAT-SELTEXT_L  = 'Posting Date'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'ACCUM_PREV'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Previous Accu Amt.'.
  LS_FIELDCAT-SELTEXT_L  = 'Previous Accu Amt.'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'TCS_PREV'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Previous TCS Amt'.
  LS_FIELDCAT-SELTEXT_L  = 'Previous TCS Amt'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'ITEM_AMT'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Item Amount'.
  LS_FIELDCAT-SELTEXT_L  = 'Item Amount'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'TCS_BASE'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'TCS Base Amount'.
  LS_FIELDCAT-SELTEXT_L  = 'TCS Base Amount'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'TCS_RATE'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Rate'.
  LS_FIELDCAT-SELTEXT_L  = 'Rate'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'TCS_AMT'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'TCS Amount'.
  LS_FIELDCAT-SELTEXT_L  = 'TCS Amount'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'ACCUM_CURR'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Current Accu Amt.'.
  LS_FIELDCAT-SELTEXT_L  = 'Current Accu Amt.'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'TCS_CURR'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Current TCS Amt'.
  LS_FIELDCAT-SELTEXT_L  = 'Current TCS Amt'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'ADJ_AMT'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Adjustment Amount'.
  LS_FIELDCAT-SELTEXT_L  = 'Adjustment Amount'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'ADV_AMT'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Net Advance Amount'.
  LS_FIELDCAT-SELTEXT_L  = 'Net Advance Amount'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'JV'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Tax adjustment doc. No.'.
  LS_FIELDCAT-SELTEXT_L  = 'Tax adjustment doc. No.'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'JV_STATUS'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'JV Status'.
  LS_FIELDCAT-SELTEXT_L  = 'JV Status'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'THLD_AMT'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Threshold Amount'.
  LS_FIELDCAT-SELTEXT_L  = 'Threshold Amount'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'VBELN'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Billing document no'.
  LS_FIELDCAT-SELTEXT_L  = 'Billing document no'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'KUNNR1'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Customer Code'.
  LS_FIELDCAT-SELTEXT_L  = 'Customer Code'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'NAME1'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Customer Name'.
  LS_FIELDCAT-SELTEXT_L  = 'Customer Name'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'FKART'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Billing Type'.
  LS_FIELDCAT-SELTEXT_L  = 'Billing Type'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'TXGRP'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Line Item'.
  LS_FIELDCAT-SELTEXT_L  = 'Line Item'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME  = 'MATNR'.
  LS_FIELDCAT-TABNAME    = 'LT_FINAL'.
  LS_FIELDCAT-SELTEXT_M  = 'Material No.'.
  LS_FIELDCAT-SELTEXT_L  = 'Material No.'.
  LS_FIELDCAT-COL_POS    = GV_POS.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
  CLEAR LS_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data .

 DATA : L_CALLBACK_PROG TYPE SY-REPID.
        L_CALLBACK_PROG = SY-REPID.
 CLEAR LS_ALV_LAYOUT.
   LS_ALV_LAYOUT-ZEBRA = 'X'.
   LS_ALV_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    I_CALLBACK_PROGRAM                = L_CALLBACK_PROG
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
    IS_LAYOUT                         = LS_ALV_LAYOUT
    IT_FIELDCAT                       = LT_FIELDCAT
  TABLES
    t_outtab                          = LT_FINAL
  EXCEPTIONS
   PROGRAM_ERROR                     = 1
  OTHERS                             = 2
          .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.

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

  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
  TABLES
    I_TAB_SAP_DATA       = LT_REF
  CHANGING
    I_TAB_CONVERTED_DATA = IT_CSV
  EXCEPTIONS
    CONVERSION_FAILED    = 1
    OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZTCS_ACCUMULATION.TXT'.

  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
  INTO LV_FULLFILE.

  WRITE: / 'ZTCS_ACCUMULATION REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_946 TYPE string.
DATA lv_crlf_946 TYPE string.
lv_crlf_946 = cl_abap_char_utilities=>cr_lf.
lv_string_946 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_946 lv_crlf_946 wa_csv INTO lv_string_946.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_946 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

*************************************************SECOND FILE ***************************************

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
  TABLES
    I_TAB_SAP_DATA       = LT_REF
  CHANGING
    I_TAB_CONVERTED_DATA = IT_CSV
  EXCEPTIONS
    CONVERSION_FAILED    = 1
    OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZTCS_ACCUMULATION.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
  INTO LV_FULLFILE.

  WRITE: / 'ZTCS_ACCUMULATION REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_982 TYPE string.
DATA lv_crlf_982 TYPE string.
lv_crlf_982 = cl_abap_char_utilities=>cr_lf.
lv_string_982 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_982 lv_crlf_982 wa_csv INTO lv_string_982.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_982 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
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

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE 'Threshold amt Category'
              'Permanent account no'
              'Type of ID Number'
              'Identification Number'
              'Customer Number'
              'Valid From Date'
              'Sequence number'
              'Company Code'
              'Accounting Doc No'
              'Fiscal Year'
              'Line Item'
              'Document type'
              'Posting Date'
              'Previous Accu Amt.'
              'Previous TCS Amt'
              'Item Amount'
              'TCS Base Amount'
              'Rate'
              'TCS Amount'
              'Current Accu Amt.'
              'Current TCS Amt'
              'Adjustment Amount'
              'Net Advance Amount'
              'Tax adjustment doc. No.'
              'JV Status'
              'Threshold Amount'
              'Refresh Date'
              'Billing document no'
              'Customer Code'
              'Customer Name'
              'Billing Type'
              'Line Item'
              'Material No.'
              INTO p_hd_csv
              SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
