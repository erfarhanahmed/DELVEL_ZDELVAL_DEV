*&---------------------------------------------------------------------*
*& Report ZPACKING_DETAILS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPACKING_DETAILS.

TABLES : LIKP,VBFA,VBRK,LIPS,MARA,T001W,ADRC,VEPO,VEKP,VBRP.

TYPES : BEGIN OF TY_JOIN,
          VBELN TYPE LIKP-VERUR,
          VKORG TYPE LIKP-VKORG,
          KUNNR TYPE LIKP-KUNNR,
          KUNAG TYPE LIKP-KUNAG,
          VERUR TYPE LIKP-VERUR,
          BTGEW TYPE LIKP-BTGEW,
          BLDAT TYPE LIKP-BLDAT,
        END OF TY_JOIN,

        BEGIN OF TY_VBFA,
          VBELV   TYPE VBFA-VBELV,
          POSNV   TYPE VBFA-POSNV,
          VBELN   TYPE VBFA-VBELN,
          POSNN   TYPE VBFA-POSNN,
          VBTYP_N TYPE VBFA-VBTYP_N,
          ERDAT   TYPE VBFA-ERDAT,
        END OF TY_VBFA,

        BEGIN OF TY_VBRK,
          VBELN TYPE VBRK-VBELN,
          FKDAT TYPE VBRK-FKDAT,
          XBLNR TYPE VBRK-XBLNR,
          NETWR TYPE VBRK-NETWR,
        END OF TY_VBRK,

        BEGIN OF TY_VBAP,
          VBELN TYPE VBAP-VBELN,
          POSNR TYPE VBAP-POSNR,
          MATNR TYPE VBAP-MATNR,
          KDMAT TYPE VBAP-KDMAT,
          WERKS TYPE VBAP-WERKS,
        END OF TY_VBAP,

        BEGIN OF TY_T001W,
          WERKS TYPE T001W-WERKS,
          ADRNR TYPE T001W-ADRNR,
        END OF TY_T001W,

        BEGIN OF TY_ADRC,
          ADDRNUMBER TYPE ADRC-ADDRNUMBER,
          NAME1      TYPE ADRC-NAME1,
        END OF TY_ADRC,

        BEGIN OF TY_KNA1,
          KUNNR TYPE KNA1-KUNNR,
          ADRNR TYPE KNA1-ADRNR,
        END OF TY_KNA1,

        BEGIN OF TY_VEPO,
          VENUM TYPE VEPO-VENUM,
          VEPOS TYPE VEPO-VEPOS,
          VBELN TYPE VEPO-VBELN,
          VEMNG TYPE VEPO-VEMNG,
          POSNR TYPE VEPO-POSNR,
        END OF TY_VEPO,

        BEGIN OF TY_VEKP,
          VENUMT   TYPE VEKP-VENUM,
          VHILM    TYPE VEKP-VHILM,
          VHILM_KU TYPE MAKT-MATNR,
        END OF TY_VEKP,

        BEGIN OF TY_AO17,
          MATNR TYPE A017-MATNR,
          LIFNR TYPE A017-LIFNR,
          DATBI TYPE A017-DATBI,
          DATAB TYPE A017-DATAB,
          KNUMH TYPE A017-KNUMH,
        END OF TY_AO17,

        BEGIN OF TY_LIPS,
          VBELN TYPE LIKP-VERUR,
          POSNR TYPE LIPS-POSNR,
          MATNR TYPE LIPS-MATNR,
          WERKS TYPE LIPS-WERKS,
          LFIMG TYPE LIPS-LFIMG,
          NTGEW TYPE LIPS-NTGEW,
          VGBEL TYPE LIPS-VGBEL,
          VGPOS TYPE LIPS-VGPOS,
          VKBUR TYPE LIPS-VKBUR,
        END OF TY_LIPS,

        BEGIN OF TY_MARA,
          MATNR   TYPE MARA-MATNR,
          WRKST   TYPE MARA-WRKST,
          ZSERIES TYPE MARA-MATNR,
          ZSIZE   TYPE MARA-MATNR,
          BRAND   TYPE MARA-MATNR,
        END OF TY_MARA,

        BEGIN OF TY_MAKT,
          MATNR TYPE MAKT-MATNR,
          MAKTX TYPE MAKT-MAKTX,
        END OF TY_MAKT,

        BEGIN OF TY_VBKD,
          VBELN TYPE VBKD-VBELN,
          POSNR TYPE VBKD-POSNR,
          BSTKD TYPE VBKD-BSTKD,
        END OF TY_VBKD,

        BEGIN OF TY_VBRP,
          VBELV TYPE VBRP-VBELV,
          VGBEL TYPE VBRP-VGBEL,
          VGPOS TYPE VBRP-VGPOS,
          POSNV TYPE VBRP-POSNV,
        END OF TY_VBRP,

        BEGIN OF TY_MBEW,
          MATNR TYPE MBEW-MATNR,
          STPRS TYPE MBEW-STPRS,
          VERPR TYPE MBEW-VERPR,           " added by sonu
        END OF TY_MBEW,

        BEGIN OF TY_NEW,
          VBELN    TYPE LIKP-VBELN,
          VHILM    TYPE VEKP-VHILM,
          VHILM_KU TYPE VEKP-VHILM_KU,
          COUNT    TYPE STRING,
        END OF TY_NEW.



TYPES : BEGIN OF TY_FINAL,
          VBELN    TYPE LIKP-VBELN,    "Packing list Nr
          BLDAT    TYPE LIKP-BLDAT,    "Packing list Date
          INBOUND  TYPE LIKP-VBELN,    "Inbound Delivery Nr
          VBELN1   TYPE VBFA-VBELN,    "Billing Doc. No.
          XBLNR    TYPE VBRK-XBLNR,    "Invoice No.
          FKDAT    TYPE VBRK-FKDAT,    "Invoice date
          NAME_X   TYPE ADRC-NAME1,    "Name of Exporter
          NAME_C   TYPE ADRC-NAME1,    "Consignee
          NAME_B   TYPE ADRC-NAME1,    "Buyer
          VHILM_KU TYPE VEKP-VHILM_KU, "Marks & Nos. Container No.
          GV_PO    TYPE CHAR255,       "PO reference
          KDMAT    TYPE VBAP-KDMAT,    "Customer  Item Code
          MATNR    TYPE LIPS-MATNR,    "DelVal Item Code
          MAKTX    TYPE MAKT-MAKTX,    "Item Description
          LFIMG    TYPE LIPS-LFIMG,    "Qty
          VGBEL    TYPE LIPS-VGBEL,    "SO Nr
          VGPOS    TYPE LIPS-VGPOS,    "PO Sr Nr
          ZSERIES  TYPE MARA-ZSERIES,    "series
          ZSIZE    TYPE MARA-ZSIZE,    "Size
          BRAND    TYPE MARA-BRAND,    "Brand
          NTGEW_R  TYPE LIPS-NTGEW,    "Wt. in KGS per unit
          NTGEW    TYPE LIPS-NTGEW,    "Net wt in Kgs.
          MAKTX1   TYPE MAKT-MAKTX,    "Description Pkg Material (Box category (W/C))
          VKBUR    TYPE LIPS-VKBUR,    "Branch
          VEMNG    TYPE VEPO-VEMNG,
          POSNR    TYPE VEPO-POSNR,
*          gv_po    TYPE char255,
          DESCR    TYPE STRING,        "makt-maktx,     " added by sonu
          GV_TR    TYPE CHAR255,
          GV_PD    TYPE CHAR255,
          GV_CFD   TYPE CHAR255,
          BTGEW    TYPE LIKP-BTGEW,
          VHILM    TYPE VEKP-VHILM,
          STPRS    TYPE STPRS,
*          tot_rate TYPE vepo-vemng, "STRING,
          NETWR    TYPE NETWR,
          MATTXT   TYPE STRING,                   "added by sonu
        END OF TY_FINAL.

TYPES : BEGIN OF TY_DOWN,
          VBELN    TYPE LIKP-VBELN,    "Packing list Nr
          BLDAT    TYPE CHAR18,        "Packing list Date
          INBOUND  TYPE LIKP-VBELN,    "Inbound Delivery Nr
          VBELN1   TYPE VBFA-VBELN,    "Billing Doc. No.
          XBLNR    TYPE VBRK-XBLNR,    "Invoice No.
          FKDAT    TYPE CHAR18,        "Invoice date
          NAME_X   TYPE ADRC-NAME1,    "Name of Exporter
          NAME_C   TYPE ADRC-NAME1,    "Consignee
          NAME_B   TYPE ADRC-NAME1,    "Buyer
          VHILM_KU TYPE VEKP-VHILM_KU, "Marks & Nos. Container No.
          GV_PO    TYPE CHAR255,       "PO reference
          KDMAT    TYPE VBAP-KDMAT,    "Customer  Item Code
          MATNR    TYPE LIPS-MATNR,    "DelVal Item Code
          MAKTX    TYPE MAKT-MAKTX,    "Item Description
          VEMNG    TYPE STRING,
          POSNR    TYPE VEPO-POSNR,
*          lfimg    TYPE string,         "Qty
          VGBEL    TYPE LIPS-VGBEL,    "SO Nr
          VGPOS    TYPE LIPS-VGPOS,    "PO Sr Nr
          ZSERIES  TYPE MARA-ZSERIES,    "series
          ZSIZE    TYPE MARA-ZSIZE,    "Size
          BRAND    TYPE MARA-BRAND,    "Brand
          NTGEW_R  TYPE STRING,    "Wt. in KGS per unit
          NTGEW    TYPE STRING,    "Net wt in Kgs.
          DESCR    TYPE STRING,     " added by sonu "makt-maktx,    "Description Pkg Material (Box category (W/C))
          VKBUR    TYPE LIPS-VKBUR,    "Branch
          GV_TR    TYPE CHAR255,
          GV_PD    TYPE CHAR255,
          GV_CFD   TYPE CHAR255,
          BTGEW    TYPE STRING,
          VHILM    TYPE VEKP-VHILM,
          REF_DAT  TYPE CHAR15,  "Refresh Date
          REF_TIME TYPE CHAR15,  "Refresh Time
          STPRS    TYPE STRING,
*          tot_rate TYPE string,
          NETWR    TYPE STRING,
        END OF TY_DOWN.


DATA : LT_JOIN   TYPE TABLE OF TY_JOIN,
       LS_JOIN   TYPE          TY_JOIN,
       LT_VBFA   TYPE TABLE OF TY_VBFA,
       LS_VBFA   TYPE          TY_VBFA,
       LT_VBRK   TYPE TABLE OF TY_VBRK,
       LS_VBRK   TYPE          TY_VBRK,
       LT_T001W  TYPE TABLE OF TY_T001W,
       LS_T001W  TYPE          TY_T001W,
       LT_ADRC   TYPE TABLE OF TY_ADRC,
       LS_ADRC   TYPE          TY_ADRC,
       LT_KNA1   TYPE TABLE OF TY_KNA1,
       LS_KNA1   TYPE          TY_KNA1,
       LT_KNA1_1 TYPE TABLE OF TY_KNA1,
       LS_KNA1_1 TYPE          TY_KNA1,
       LT_ADRC1  TYPE TABLE OF TY_ADRC,
       LS_ADRC1  TYPE          TY_ADRC,
       LT_ADRC2  TYPE TABLE OF TY_ADRC,
       LS_ADRC2  TYPE          TY_ADRC,
       LT_VBAP   TYPE TABLE OF TY_VBAP,
       LS_VBAP   TYPE          TY_VBAP,
       LT_VEPO   TYPE TABLE OF TY_VEPO,
       LS_VEPO   TYPE          TY_VEPO,
       LT_VEKP   TYPE TABLE OF TY_VEKP,
       LS_VEKP   TYPE          TY_VEKP,
       LT_AO17   TYPE TABLE OF TY_AO17,
       LS_AO17   TYPE          TY_AO17,
       LT_LIPS   TYPE TABLE OF TY_LIPS,
       LS_LIPS   TYPE          TY_LIPS,
       LT_MARA   TYPE TABLE OF TY_MARA,
       LS_MARA   TYPE          TY_MARA,
       LT_MAKT   TYPE TABLE OF TY_MAKT,
       LS_MAKT   TYPE          TY_MAKT,
       LT_MAKT1  TYPE TABLE OF TY_MAKT,
       LS_MAKT1  TYPE          TY_MAKT,
       LT_FINAL  TYPE TABLE OF TY_FINAL,
       LT_FINAL1 TYPE TABLE OF TY_FINAL,
       LS_FINAL  TYPE          TY_FINAL,
       LT_VBRP   TYPE TABLE OF TY_VBRP,
       LS_VBRP   TYPE TY_VBRP,
       LT_VBFA1  TYPE TABLE OF TY_VBFA,
       LS_VBFA1  TYPE          TY_VBFA,
       LT_LIKP   TYPE TABLE OF TY_JOIN,
       LS_LIKP   TYPE          TY_JOIN,
       LT_DOWN   TYPE TABLE OF TY_DOWN,
       LS_DOWN   TYPE         TY_DOWN,
       LT_LIKP1  TYPE TABLE OF TY_JOIN,
       LS_LIKP1  TYPE          TY_JOIN,
       LT_VBKD   TYPE TABLE OF TY_VBKD,
       LS_VBKD   TYPE TY_VBKD,
       LT_MBEW   TYPE TABLE OF TY_MBEW,
       LS_MBEW   TYPE TY_MBEW,
       LV_NAME   TYPE THEAD-TDNAME,                                   " added by sonu
       LV_LINES  TYPE STANDARD TABLE OF TLINE,                        " added by sonu
       WA_LINES  LIKE TLINE,                                          " added by sonu
       LS_ITMTXT TYPE TLINE,                                          " added by sonu
       LS_MATTXT TYPE TLINE..                                         " added by sonu


DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE.

DATA : LS_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA : IT_NEW  TYPE TABLE OF TY_NEW,
       IT_NEW1 TYPE TABLE OF TY_NEW,
       WA_NEW  TYPE TY_NEW.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : P_DATE FOR LIKP-BLDAT.
*                 i_date FOR vbfa-erdat.
  PARAMETERS : PLANT TYPE T001W-WERKS DEFAULT  'PL01'.
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.


SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF  SCREEN-NAME = 'PLANT'.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM GET_DATA.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA.

*  BREAK primus.

  SELECT VBELN
         VKORG
         KUNNR
         KUNAG
         VERUR
         BTGEW
         BLDAT
    FROM LIKP
    INTO TABLE LT_JOIN
    WHERE BLDAT IN P_DATE AND
          VKORG IN ( '1000' , ' ' ).

  IF LT_JOIN IS NOT INITIAL.

    SELECT VBELN
    POSNR
    MATNR
    WERKS
    LFIMG
    NTGEW
    VGBEL
    VGPOS
    VKBUR
    FROM LIPS
    INTO TABLE LT_LIPS
    FOR ALL ENTRIES IN LT_JOIN
    WHERE VBELN = LT_JOIN-VBELN+0(10) AND
          WERKS = 'PL01'.

  ENDIF.

  IF LT_LIPS IS NOT INITIAL.


    SELECT VBELN
    VKORG
    KUNNR
    KUNAG
    VERUR
    BTGEW
    BLDAT
      FROM LIKP
      INTO TABLE LT_LIKP
      FOR ALL ENTRIES IN LT_LIPS
      WHERE VERUR = LT_LIPS-VBELN.

    SELECT VBELN
    VKORG
    KUNNR
    KUNAG
    VERUR
    BTGEW
    BLDAT
    FROM LIKP
    INTO TABLE LT_LIKP1
    FOR ALL ENTRIES IN LT_LIPS
    WHERE VBELN = LT_LIPS-VBELN+0(10).

    SELECT VBELV
           POSNV
           VBELN
           POSNN
           VBTYP_N
           ERDAT
      FROM VBFA
      INTO TABLE LT_VBFA
      FOR ALL ENTRIES IN LT_LIPS
      WHERE VBELV = LT_LIPS-VBELN+0(10) AND
            VBTYP_N = 'M'." AND
*            erdat IN i_date.


*    SELECT vbelv  "commented by jyoti on 06.01.2024
*    posnv
*    vbeln
*    posnn
*    vbtyp_n
*    erdat
*    FROM vbfa
*    INTO TABLE lt_vbfa1
*    FOR ALL ENTRIES IN lt_lips
*    WHERE vbeln = lt_lips-vbeln+0(10) AND
*          erdat IN i_date.." AND
**            vbtyp_n = 'M'.


    SELECT VENUM
           VEPOS
           VBELN
           VEMNG
           POSNR
      FROM VEPO
      INTO TABLE LT_VEPO
      FOR ALL ENTRIES IN LT_LIPS
      WHERE VBELN = LT_LIPS-VBELN+0(10).


    SELECT KUNNR
           ADRNR
      FROM KNA1
      INTO TABLE LT_KNA1
      FOR ALL ENTRIES IN LT_LIKP1
      WHERE KUNNR = LT_LIKP1-KUNNR.

    SELECT KUNNR
    ADRNR
    FROM KNA1
    INTO TABLE LT_KNA1_1
    FOR ALL ENTRIES IN LT_LIKP1
    WHERE KUNNR = LT_LIKP1-KUNAG.

    IF LT_KNA1 IS NOT INITIAL.

      SELECT ADDRNUMBER
      NAME1
      FROM ADRC
      INTO TABLE LT_ADRC1
      FOR ALL ENTRIES IN LT_KNA1
      WHERE ADDRNUMBER = LT_KNA1-ADRNR.

    ENDIF.

    IF LT_KNA1_1 IS NOT INITIAL.

      SELECT ADDRNUMBER
      NAME1
      FROM ADRC
      INTO TABLE LT_ADRC2
      FOR ALL ENTRIES IN LT_KNA1_1
      WHERE ADDRNUMBER = LT_KNA1_1-ADRNR.

    ENDIF.

  ENDIF.

  IF LT_VBFA IS NOT INITIAL.

    SELECT VBELN
           FKDAT
           XBLNR
           NETWR
      FROM VBRK
      INTO TABLE LT_VBRK
      FOR ALL ENTRIES IN LT_VBFA
      WHERE VBELN = LT_VBFA-VBELN.

  ENDIF.

  IF LT_LIPS IS NOT INITIAL.

    SELECT WERKS
           ADRNR
      FROM T001W
      INTO TABLE LT_T001W
      FOR ALL ENTRIES IN LT_LIPS
      WHERE WERKS = LT_LIPS-WERKS.

    IF LT_T001W IS NOT INITIAL.

      SELECT ADDRNUMBER
             NAME1
        FROM ADRC
        INTO TABLE LT_ADRC
        FOR ALL ENTRIES IN LT_T001W
        WHERE ADDRNUMBER = LT_T001W-ADRNR.

    ENDIF.

    SELECT VBELN
    POSNR
    BSTKD
    FROM VBKD
    INTO TABLE LT_VBKD
    FOR ALL ENTRIES IN LT_LIPS
    WHERE VBELN = LT_LIPS-VGBEL." AND

  ENDIF.

  IF LT_VEPO IS NOT INITIAL.

    SELECT VENUM
           VHILM
           VHILM_KU
      FROM VEKP
      INTO TABLE LT_VEKP
      FOR ALL ENTRIES IN LT_VEPO
      WHERE VENUM = LT_VEPO-VENUM.
*    BREAK primusabap.

*    SELECT matnr
*           lifnr
*           DATBI
*           datab
*           knumh
*      FROM a017
*      INTO TABLE lt_ao17
*      FOR ALL ENTRIES IN lt_vekp
*      WHERE matnr = lt_vekp-vhilm
*       and DATBI = '99991231'.

*      and datab ge

*      SORT lt_ao17 BY datab DESCENDING.

    SELECT MATNR
           STPRS VERPR
      FROM MBEW
      INTO TABLE LT_MBEW
      FOR ALL ENTRIES IN LT_VEKP
      WHERE MATNR = LT_VEKP-VHILM.


    SELECT VBELV
           VGBEL
           VGPOS
           POSNV
      FROM VBRP
      INTO TABLE LT_VBRP
      FOR ALL ENTRIES IN LT_VEPO
      WHERE VGBEL = LT_VEPO-VBELN
        AND VGPOS = LT_VEPO-POSNR.

    SELECT MATNR
    MAKTX
    FROM MAKT
    INTO TABLE LT_MAKT1
    FOR ALL ENTRIES IN LT_VEKP
    WHERE MATNR = LT_VEKP-VHILM.


  ENDIF.

  IF LT_LIPS IS NOT INITIAL.

    SELECT VBELN
    POSNR
    MATNR
    KDMAT
    WERKS
    FROM VBAP
    INTO TABLE LT_VBAP
    FOR ALL ENTRIES IN LT_LIPS
    WHERE  VBELN = LT_LIPS-VGBEL AND
    POSNR = LT_LIPS-VGPOS.


*    posnr = lt_vbrp-vgpos.

  ENDIF.

  IF LT_LIPS IS NOT INITIAL.

    SELECT MATNR
           WRKST
           ZSERIES
           ZSIZE
           BRAND
      FROM MARA
      INTO TABLE LT_MARA
      FOR ALL ENTRIES IN LT_LIPS
      WHERE MATNR = LT_LIPS-MATNR.

    SELECT MATNR
           MAKTX
      FROM MAKT
      INTO TABLE LT_MAKT
      FOR ALL ENTRIES IN LT_LIPS
      WHERE MATNR = LT_LIPS-MATNR.

  ENDIF.

  IF LT_JOIN IS NOT INITIAL.
    PERFORM SORT_DATA.
    PERFORM GET_FCAT.
    PERFORM DISPLAY.
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
FORM SORT_DATA .
*BREAK PRIMUSABAP.
  LOOP AT LT_VEPO INTO LS_VEPO.

    LS_FINAL-VBELN = LS_VEPO-VBELN.
    LS_FINAL-VEMNG = LS_VEPO-VEMNG.
    LS_FINAL-POSNR = LS_VEPO-POSNR.

    READ TABLE LT_VEKP INTO LS_VEKP WITH KEY VENUMT = LS_VEPO-VENUM.
    IF SY-SUBRC = 0.
      LS_FINAL-VHILM_KU = LS_VEKP-VHILM_KU.
      LS_FINAL-VHILM    = LS_VEKP-VHILM.
    ENDIF.

    READ TABLE LT_MBEW INTO LS_MBEW WITH KEY MATNR = LS_FINAL-VHILM.
    IF SY-SUBRC = 0.
*      ls_final-stprs = ls_mbew-stprs.
    ENDIF.

    READ TABLE LT_MAKT1 INTO LS_MAKT1 WITH KEY MATNR = LS_VEKP-VHILM.
    IF SY-SUBRC = 0.
      LS_FINAL-DESCR = LS_MAKT1-MAKTX.
    ENDIF.

    READ TABLE LT_LIKP1 INTO LS_LIKP1 WITH KEY VBELN = LS_VEPO-VBELN.
*                                             posnv = ls_vepo-posnr.
    IF SY-SUBRC = 0.

      LS_FINAL-BLDAT = LS_LIKP1-BLDAT.
      LS_FINAL-BTGEW = LS_LIKP1-BTGEW.
    ENDIF.

    READ TABLE LT_LIKP INTO LS_LIKP WITH KEY VERUR = LS_FINAL-VBELN .
    IF SY-SUBRC = 0.
      LS_FINAL-INBOUND = LS_LIKP-VBELN.
    ENDIF.

    READ TABLE LT_VBFA INTO LS_VBFA WITH KEY VBELV = LS_FINAL-VBELN
                                             VBTYP_N = 'M'.
    IF SY-SUBRC = 0.
      LS_FINAL-VBELN1 = LS_VBFA-VBELN.
    ENDIF.

*    READ TABLE lt_vbfa1 INTO ls_vbfa1 WITH KEY vbeln = ls_final-vbeln.



    READ TABLE LT_VBRK INTO LS_VBRK WITH KEY VBELN = LS_FINAL-VBELN1.
    IF SY-SUBRC = 0.
      LS_FINAL-XBLNR = LS_VBRK-XBLNR.
      LS_FINAL-FKDAT = LS_VBRK-FKDAT.
      LS_FINAL-NETWR = LS_VBRK-NETWR.
    ENDIF.

    READ TABLE LT_KNA1 INTO LS_KNA1 WITH KEY KUNNR = LS_LIKP1-KUNNR.
    IF  SY-SUBRC = 0.
      READ TABLE LT_ADRC1 INTO LS_ADRC1 WITH KEY ADDRNUMBER = LS_KNA1-ADRNR.
      IF SY-SUBRC = 0 .
        LS_FINAL-NAME_C = LS_ADRC1-NAME1.                                                     "Consignee
      ENDIF.
    ENDIF.

    READ TABLE LT_KNA1_1 INTO LS_KNA1_1 WITH KEY KUNNR = LS_LIKP1-KUNAG.
    IF SY-SUBRC = 0.
      READ TABLE LT_ADRC2 INTO LS_ADRC2 WITH KEY ADDRNUMBER = LS_KNA1_1-ADRNR.
      IF SY-SUBRC = 0.
        LS_FINAL-NAME_B = LS_ADRC2-NAME1.                                                    "buyer
      ENDIF.
    ENDIF.

    LOOP AT LT_LIPS INTO LS_LIPS WHERE VBELN = LS_FINAL-VBELN AND
                                       POSNR = LS_FINAL-POSNR.

      LS_FINAL-MATNR = LS_LIPS-MATNR.
      LS_FINAL-LFIMG = LS_FINAL-LFIMG + LS_LIPS-LFIMG.
      LS_FINAL-VGBEL = LS_LIPS-VGBEL.
      LS_FINAL-VGPOS = LS_LIPS-VGPOS.
*      ls_final-ntgew = ls_final-ntgew + ls_lips-ntgew.
      LS_FINAL-NTGEW_R = LS_LIPS-NTGEW / LS_FINAL-LFIMG.
      LS_FINAL-NTGEW = LS_FINAL-NTGEW_R * LS_FINAL-VEMNG.
      LS_FINAL-VKBUR  = LS_LIPS-VKBUR.

    ENDLOOP.

    READ TABLE LT_MAKT INTO LS_MAKT WITH KEY MATNR = LS_FINAL-MATNR.
    IF SY-SUBRC = 0.
      LS_FINAL-MAKTX = LS_MAKT-MAKTX.
    ENDIF.

    READ TABLE LT_MARA INTO LS_MARA WITH KEY MATNR = LS_FINAL-MATNR.
    IF SY-SUBRC = 0.
      LS_FINAL-ZSERIES = LS_MARA-ZSERIES.
      LS_FINAL-ZSIZE   = LS_MARA-ZSIZE.
      LS_FINAL-BRAND   = LS_MARA-BRAND.
    ENDIF.

    READ TABLE LT_T001W INTO LS_T001W WITH KEY WERKS = LS_LIPS-WERKS.
    IF SY-SUBRC = 0.
      READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_T001W-ADRNR.
      IF SY-SUBRC = 0.
        LS_FINAL-NAME_X = LS_ADRC-NAME1.                                                   "name of exporter
      ENDIF.
    ENDIF.

    READ TABLE LT_VBRP INTO LS_VBRP WITH  KEY VGBEL = LS_VEPO-VBELN
                                              VGPOS = LS_VEPO-POSNR.

    IF LS_FINAL-INBOUND IS NOT INITIAL.
      LS_FINAL-KDMAT = LS_MARA-WRKST.

    ELSE.
      READ TABLE LT_VBAP INTO LS_VBAP WITH KEY VBELN = LS_FINAL-VGBEL
                                               POSNR = LS_FINAL-VGPOS.
      IF SY-SUBRC = 0.
        LS_FINAL-KDMAT = LS_VBAP-KDMAT.                                                        "customer item code
      ENDIF.
    ENDIF.

    DATA :LV_LINES TYPE STANDARD TABLE OF TLINE,
          GV_PO    LIKE TLINE,
          GV_TR    LIKE TLINE,
          GV_PD    LIKE TLINE,
          GV_CFD   LIKE TLINE,
          LV_NAME  TYPE THEAD-TDNAME.

*    CONCATENATE ls_vbrp-vbelv ls_vbrp-posnv INTO lv_name.

    IF LS_FINAL-INBOUND IS NOT INITIAL.

      CLEAR: LV_LINES, GV_PO,LV_NAME.
      REFRESH LV_LINES.
      LV_NAME = LS_FINAL-VGBEL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'ZZ99'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
* IMPORTING
*         HEADER                  =
*         OLD_LINE_COUNTER        =
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.

      READ TABLE LV_LINES INTO GV_PO INDEX 1.

      IF LV_LINES IS NOT INITIAL.
*     IF lv_lines IS NOT INITIAL.
        IF GV_PO-TDLINE IS NOT INITIAL.
          LS_FINAL-GV_PO = GV_PO-TDLINE.
        ENDIF.
      ELSE.
        READ TABLE LT_VBKD INTO LS_VBKD WITH KEY VBELN = LS_FINAL-VGBEL.
        IF SY-SUBRC = 0.
          LS_FINAL-GV_PO = LS_VBKD-BSTKD.
        ENDIF.

      ENDIF.
    ELSE.
      READ TABLE LT_VBKD INTO LS_VBKD WITH KEY VBELN = LS_FINAL-VGBEL.
      IF SY-SUBRC = 0.
        LS_FINAL-GV_PO = LS_VBKD-BSTKD.
      ENDIF.
    ENDIF.


    CLEAR: LV_LINES, GV_PD.
    REFRESH LV_LINES.
    LV_NAME = LS_FINAL-VBELN1.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z010'
        LANGUAGE                = 'E'
        NAME                    = LV_NAME
        OBJECT                  = 'VBBK'
      TABLES
        LINES                   = LV_LINES
      EXCEPTIONS
        ID                      = 1
        LANGUAGE                = 2
        NAME                    = 3
        NOT_FOUND               = 4
        OBJECT                  = 5
        REFERENCE_CHECK         = 6
        WRONG_ACCESS_TO_ARCHIVE = 7
        OTHERS                  = 8.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    READ TABLE LV_LINES INTO GV_PD INDEX 1.
    IF LV_LINES IS NOT INITIAL.
      IF GV_PD-TDLINE IS NOT INITIAL.
        LS_FINAL-GV_PD = GV_PD-TDLINE.
      ENDIF.
    ENDIF.

    CLEAR: LV_LINES, GV_TR.
    REFRESH LV_LINES.
    LV_NAME = LS_FINAL-VBELN1.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z008'
        LANGUAGE                = 'E'
        NAME                    = LV_NAME
        OBJECT                  = 'VBBK'
      TABLES
        LINES                   = LV_LINES
      EXCEPTIONS
        ID                      = 1
        LANGUAGE                = 2
        NAME                    = 3
        NOT_FOUND               = 4
        OBJECT                  = 5
        REFERENCE_CHECK         = 6
        WRONG_ACCESS_TO_ARCHIVE = 7
        OTHERS                  = 8.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    READ TABLE LV_LINES INTO GV_TR INDEX 1.
    IF LV_LINES IS NOT INITIAL.
      IF GV_TR-TDLINE IS NOT INITIAL.
        LS_FINAL-GV_TR = GV_TR-TDLINE.
      ENDIF.
    ENDIF.

    CLEAR: LV_LINES, GV_CFD.
    REFRESH LV_LINES.
    LV_NAME = LS_FINAL-VBELN1.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z033'
        LANGUAGE                = 'E'
        NAME                    = LV_NAME
        OBJECT                  = 'VBBK'
      TABLES
        LINES                   = LV_LINES
      EXCEPTIONS
        ID                      = 1
        LANGUAGE                = 2
        NAME                    = 3
        NOT_FOUND               = 4
        OBJECT                  = 5
        REFERENCE_CHECK         = 6
        WRONG_ACCESS_TO_ARCHIVE = 7
        OTHERS                  = 8.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    READ TABLE LV_LINES INTO GV_CFD INDEX 1.
    IF LV_LINES IS NOT INITIAL.
      IF GV_CFD-TDLINE IS NOT INITIAL.
        LS_FINAL-GV_CFD = GV_CFD-TDLINE.
      ENDIF.
    ENDIF.

    CLEAR: LV_LINES, LS_MATTXT. "VK                  " added by sonu
    REFRESH LV_LINES.
    LV_NAME = LS_FINAL-VHILM.     "matnr.
    IF LV_NAME IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'GRUN'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
*MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ENDIF.
    IF NOT LV_LINES IS INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL.
          REPLACE ALL OCCURRENCES OF '<(>' IN WA_LINES-TDLINE WITH SPACE.
          REPLACE ALL OCCURRENCES OF '<)>' IN WA_LINES-TDLINE WITH SPACE.
          CONCATENATE LS_FINAL-MATTXT WA_LINES-TDLINE INTO LS_FINAL-MATTXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-MATTXT.
    ENDIF.  "Vk


*    DELETE LT_AO17 WHERE MATNR = ls_final-VHILM
*
*                      AND datab LT ls_final-BLDAT.
    SELECT MATNR
             LIFNR
             DATBI
             DATAB
             KNUMH
        FROM A017
        INTO TABLE LT_AO17
*      FOR ALL ENTRIES IN lt_vekp
        WHERE MATNR = LS_FINAL-VHILM.
*        and DATBI = '99991231'.


    LOOP AT LT_AO17 INTO LS_AO17 WHERE MATNR = LS_FINAL-VHILM.
      IF LS_FINAL-BLDAT BETWEEN LS_AO17-DATAB AND LS_AO17-DATBI.
*        if LS_FINAL-BLDAT+0(4) Ge LS_AO17-DATAB+0(4).
        DATA(GV_YEAR) = LS_FINAL-BLDAT+0(4).
        GV_YEAR = GV_YEAR - 1.
*        IF LS_AO17-DATAB+0(4) = GV_YEAR.
        DATA(GV_YEAR1) = LS_AO17-DATAB+0(4).
*        if LS_AO17-DATAB+0(4) GE GV_YEAR .
        IF GV_YEAR LE GV_YEAR1.
          IF SY-SUBRC IS INITIAL.
            SELECT SINGLE KBETR FROM KONP INTO @DATA(WA_KONP) WHERE KNUMH = @LS_AO17-KNUMH.
            LS_FINAL-STPRS = WA_KONP.
          ENDIF.
        ENDIF.

*        ENDIF.
      ENDIF.

    ENDLOOP.
    IF LS_FINAL-STPRS IS INITIAL.
      SORT LT_AO17 BY DATAB DESCENDING.
      READ TABLE LT_AO17 INTO LS_AO17 WITH KEY MATNR = LS_FINAL-VHILM.
      IF SY-SUBRC = 0.
        SELECT SINGLE KBETR FROM KONP INTO WA_KONP WHERE KNUMH = LS_AO17-KNUMH.
        LS_FINAL-STPRS = WA_KONP.
      ENDIF.

    ENDIF.

*    READ TABLE LT_AO17 INTO LS_AO17 WITH KEY MATNR = ls_final-VHILM.
*    IF SY-subrc = 0.
*      SELECT SINGLE KBETR FROM KONP INTO @DATA(WA_KONP) WHERE KNUMH = @LS_AO17-knumh.
*        ls_final-STPRS = WA_KONP.
*    ENDIF.


*    ls_final-tot_rate = ls_final-vemng * ls_final-stprs.

    WA_NEW-VBELN = LS_FINAL-VBELN.
    WA_NEW-VHILM = LS_FINAL-VHILM.
    WA_NEW-VHILM_KU = LS_FINAL-VHILM_KU.

    APPEND WA_NEW TO IT_NEW.

    APPEND LS_FINAL TO LT_FINAL1.
    CLEAR : LS_FINAL,LS_JOIN,LS_VBFA,LS_ADRC,LS_ADRC1,LS_ADRC2,LS_T001W,LS_LIPS,LS_KNA1,LS_KNA1_1,
            LS_VEPO,LS_VEKP,LS_VBRK,LS_VBAP,WA_KONP,WA_NEW.
  ENDLOOP.

  IF P_DATE IS INITIAL ."AND i_date IS NOT INITIAL.
    DELETE LT_FINAL1 WHERE FKDAT IS INITIAL.
*    DELETE it_new WHERE fkdat IS INITIAL.
  ENDIF.
*break primusabap.
  LOOP AT LT_FINAL1 INTO LS_FINAL.
    LOOP AT IT_NEW INTO WA_NEW WHERE VBELN = LS_FINAL-VBELN
                                    AND VHILM = LS_FINAL-VHILM
                                    AND VHILM_KU = LS_FINAL-VHILM_KU.
      DATA : GV_COUNT TYPE STRING.
      GV_COUNT  = GV_COUNT + 1.
*      wa_new-count = wa_new-count + 1.
*     at END OF vbeln.
*      modify it_new from wa_new TRANSPORTING count.
*    endat.
    ENDLOOP.
*    at END OF vbeln.

    WA_NEW-COUNT = GV_COUNT.
    APPEND WA_NEW TO IT_NEW1.
*      modify it_new from wa_new ."where vbeln = ls_final-vbeln
*                                    and vhilm = ls_final-vhilm.
    CLEAR : GV_COUNT,LS_FINAL,WA_NEW.
*                              TRANSPORTING count .
*    endat.
  ENDLOOP.
  BREAK PRIMUSABAP.
  DELETE ADJACENT DUPLICATES FROM IT_NEW1 COMPARING ALL FIELDS.
  LOOP AT LT_FINAL1 INTO LS_FINAL.
    READ TABLE IT_NEW1 INTO WA_NEW WITH KEY VBELN = LS_FINAL-VBELN
                                            VHILM = LS_FINAL-VHILM
                                             VHILM_KU = LS_FINAL-VHILM_KU.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-STPRS = LS_FINAL-STPRS / WA_NEW-COUNT.
    ENDIF.
    APPEND LS_FINAL TO LT_FINAL.
    CLEAR : LS_FINAL, WA_NEW.
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
FORM GET_FCAT .

  PERFORM FCAT USING :     '1'   'VBELN'           'LT_FINAL'      'Packing List No.'                           '18' ,
                           '2'   'BLDAT'           'LT_FINAL'      'Packing list date'                          '18',
                           '3'   'INBOUND'         'LT_FINAL'      'Inbound Delivery No.'                       '18' ,
                           '4'   'VBELN1'          'LT_FINAL'      'Billing Doc No.'                            '18' ,
                           '5'   'XBLNR'           'LT_FINAL'      'Invoice No.'                                '18' ,
                           '6'   'FKDAT'           'LT_FINAL'      'Invoice Date'                               '18' ,
                           '7'   'NAME_X'          'LT_FINAL'      'Name of exporter'                           '18' ,
                           '8'   'NAME_C'          'LT_FINAL'      'Consignee'                                  '18' ,
                           '9'   'NAME_B'          'LT_FINAL'      'Buyer'                                      '18' ,
                           '10'  'VHILM_KU'        'LT_FINAL'      'Marks & Nos'                                '18' ,
                           '11'  'GV_PO'           'LT_FINAL'      'PO Reference'                               '18' ,
                           '12'  'KDMAT'           'LT_FINAL'      'Customer Item code'                         '18' ,
                           '13'  'MATNR'           'LT_FINAL'      'Delval Item code'                           '18' ,
                           '14'  'MAKTX'           'LT_FINAL'      'Item Description'                           '18' ,
                           '15'  'VEMNG'           'LT_FINAL'      'Packed QTY'                                 '10' ,
                           '16'  'POSNR'           'LT_FINAL'      'ODB Line Item'                              '18' ,
                           '17'  'VGBEL'           'LT_FINAL'      'SO No.'                                     '18' ,
                           '18'  'VGPOS'           'LT_FINAL'      'PO Sr No.'                                  '18' ,
                           '19'  'ZSERIES'         'LT_FINAL'      'Series'                                     '18' ,
                           '20'  'ZSIZE'           'LT_FINAL'      'Size'                                       '18' ,
                           '21'  'BRAND'           'LT_FINAL'      'Brand'                                      '18' ,
                           '22'  'NTGEW_R'         'LT_FINAL'      'Wt in Kgs Per Unit'                         '18' ,
                           '23'  'NTGEW'           'LT_FINAL'      'Total Net Wt in Kgs'                        '18' ,
                           '24'  'DESCR'           'LT_FINAL'      'Description Pkg Material'                   '40' ,
                           '25'  'VKBUR'           'LT_FINAL'      'Branch'                                     '18' ,
                           '26'  'GV_TR'           'LT_FINAL'      'Vessel/Flight No'                           '80' ,
                           '27'  'GV_PD'           'LT_FINAL'      'Port Of Discharge'                          '80' ,
                           '28'  'GV_CFD'          'LT_FINAL'      'Country of Final Destination'               '80' ,
                           '29'  'BTGEW'           'LT_FINAL'      'Gross Weight'                               '18' ,
                           '30'  'VHILM'           'LT_FINAL'      'Packaging Material'                         '18' ,
                           '31'  'STPRS'           'LT_FINAL'      'Box Rate'                                   '18' ,
*                           '32'  'TOT_RATE'        'LT_FINAL'      'Total Box Rate'                             '18' ,
                           '33'  'NETWR'           'LT_FINAL'      'Total Invoice Value'                        '18' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1334   text
*      -->P_1335   text
*      -->P_1336   text
*      -->P_1337   text
*      -->P_1338   text
*----------------------------------------------------------------------*
FORM FCAT  USING   VALUE(P1)
      VALUE(P2)
      VALUE(P3)
      VALUE(P4)
      VALUE(P5).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
  WA_FCAT-OUTPUTLEN = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY .

  LS_LAYOUT-ZEBRA = 'X'.
  LS_LAYOUT-COLWIDTH_OPTIMIZE = 'X' .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = 'sy-repid'
      IS_LAYOUT          = LS_LAYOUT
      IT_FIELDCAT        = IT_FCAT
    TABLES
      T_OUTTAB           = LT_FINAL.
*    EXCEPTIONS
*      program_error      = 1
*      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.



  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
    PERFORM DOWNLOAD_EXCEL.
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
FORM DOWNLOAD .

  LOOP AT LT_FINAL INTO LS_FINAL.

    LS_DOWN-VEMNG    = LS_FINAL-VEMNG.
    LS_DOWN-POSNR    = LS_FINAL-POSNR.
    LS_DOWN-VHILM_KU = LS_FINAL-VHILM_KU.
    LS_DOWN-DESCR    = LS_FINAL-MATTXT.  "descr.   " added by sonu
    LS_DOWN-VBELN    = LS_FINAL-VBELN.
*    ls_down-bldat    = ls_final-bldat.
    LS_DOWN-BTGEW    = LS_FINAL-BTGEW.
    LS_DOWN-INBOUND  = LS_FINAL-INBOUND.
    LS_DOWN-VBELN1   = LS_FINAL-VBELN1.
    LS_DOWN-KDMAT    = LS_FINAL-KDMAT.
    LS_DOWN-XBLNR    = LS_FINAL-XBLNR.
*    ls_down-fkdat    = ls_final-fkdat.
    LS_DOWN-NAME_C   = LS_FINAL-NAME_C.
    LS_DOWN-NAME_B   = LS_FINAL-NAME_B.
    LS_DOWN-MATNR    = LS_FINAL-MATNR.
*    ls_down-lfimg    = ls_final-lfimg.
    LS_DOWN-VGBEL    = LS_FINAL-VGBEL.
    LS_DOWN-VGPOS    = LS_FINAL-VGPOS.
    LS_DOWN-NTGEW    = LS_FINAL-NTGEW.
    LS_DOWN-NTGEW_R  =  LS_FINAL-NTGEW_R.
    LS_DOWN-NTGEW    = LS_FINAL-NTGEW.
    LS_DOWN-VKBUR    = LS_FINAL-VKBUR.
    LS_DOWN-MAKTX    = LS_FINAL-MAKTX.
    LS_DOWN-ZSERIES  = LS_FINAL-ZSERIES.
    LS_DOWN-ZSIZE    = LS_FINAL-ZSIZE.
    LS_DOWN-BRAND    = LS_FINAL-BRAND.
    LS_DOWN-NAME_X   = LS_FINAL-NAME_X.
    LS_DOWN-GV_PO    = LS_FINAL-GV_PO.
    LS_DOWN-GV_PD    = LS_FINAL-GV_PD .
    LS_DOWN-GV_TR    = LS_FINAL-GV_TR.
    LS_DOWN-GV_CFD   = LS_FINAL-GV_CFD.
    LS_DOWN-VHILM    = LS_FINAL-VHILM.
    LS_DOWN-STPRS    = LS_FINAL-STPRS.
*    ls_down-tot_rate = ls_final-tot_rate.
    LS_DOWN-NETWR    = LS_FINAL-NETWR.

    IF LS_FINAL-NETWR < 0.     """""""""" NC
      CONDENSE  LS_DOWN-NETWR NO-GAPS  .
      REPLACE ALL OCCURRENCES OF '-' IN  LS_DOWN-NETWR WITH SPACE .
      CONCATENATE '-'  LS_DOWN-NETWR  INTO  LS_DOWN-NETWR .
    ENDIF.
    CONDENSE  LS_DOWN-NETWR NO-GAPS  .

  IF LS_FINAL-BLDAT IS NOT INITIAL.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-BLDAT
      IMPORTING
        OUTPUT = LS_DOWN-BLDAT.

    CONCATENATE LS_DOWN-BLDAT+0(2) LS_DOWN-BLDAT+2(3) LS_DOWN-BLDAT+5(4)
    INTO LS_DOWN-BLDAT SEPARATED BY '-'.

  ENDIF.

  IF LS_FINAL-FKDAT IS NOT INITIAL.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-FKDAT
      IMPORTING
        OUTPUT = LS_DOWN-FKDAT.

    CONCATENATE LS_DOWN-FKDAT+0(2) LS_DOWN-FKDAT+2(3) LS_DOWN-FKDAT+5(4)
    INTO LS_DOWN-FKDAT SEPARATED BY '-'.

  ENDIF.

  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      INPUT  = SY-DATUM
    IMPORTING
      OUTPUT = LS_DOWN-REF_DAT.

  CONCATENATE LS_DOWN-REF_DAT+0(2) LS_DOWN-REF_DAT+2(3) LS_DOWN-REF_DAT+5(4)
  INTO LS_DOWN-REF_DAT SEPARATED BY '-'.

  LS_DOWN-REF_TIME = SY-UZEIT.
  CONCATENATE LS_DOWN-REF_TIME+0(2) ':' LS_DOWN-REF_TIME+2(2)  INTO LS_DOWN-REF_TIME.


  APPEND LS_DOWN TO LT_DOWN.
  CLEAR LS_DOWN.

ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD_EXCEL .

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
*  BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = LT_DOWN
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
  LV_FILE = 'ZPACKING_DETAILS.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
  INTO LV_FULLFILE.
*  BREAK primus.
  WRITE: / 'ZPACKING_DETAILS Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1238 TYPE STRING.   " commented by sonu
    DATA LV_CRLF_1238 TYPE STRING.     " commented by sonu
    LV_CRLF_1238 = CL_ABAP_CHAR_UTILITIES=>CR_LF.    " commented by sonu
    LV_STRING_1238 = HD_CSV.            " commented by sonu
*    TRANSFER hd_csv TO lv_fullfile.   "added by sonu
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1238 LV_CRLF_1238 WA_CSV INTO LV_STRING_1238.    " commented by sonu
      CLEAR: WA_CSV.                             "commented by sonu
*  IF sy-subrc = 0.                            " added by sonu
*        TRANSFER wa_csv TO lv_fullfile.        " added by sonu
*        endif.
    ENDLOOP.
*TRANSFER lv_string_619 TO lv_fullfile.
    TRANSFER LV_STRING_1238 TO LV_FULLFILE.      "commented by sonu
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
FORM CVS_HEADER  USING    P_HD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE 'Packing List No.'
              'Packing list date'
              'Inbound Delivery No.'
              'Billing Doc No.'
              'Invoice No.'
              'Invoice Date'
              'Name of exporter'
              'Consignee'
              'Buyer'
              'Marks & Nos'
              'PO Reference'
              'Customer Item code'
              'Delval Item code'
              'Item Description'
              'Packed QTY'
              'ODB Line Item'
              'SO No.'
              'PO Sr No.'
              'Series'
              'Size'
              'Brand'
              'Wt in Kgs Per Unit'
              'Total Net Wt in Kgs'
              'Description Pkg Material'
              'Branch'
              'Vessel/Flight No'
              'Port Of Discharge'
              'Country of Final Destination'
              'Gross Weight'
              'Packaging Material'
              'Refresh Date'
              'Refresh Time'
              'Box Rate'
*              'Total Box Rate'
              'Total Invoice Value'
  INTO P_HD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.



ENDFORM.
