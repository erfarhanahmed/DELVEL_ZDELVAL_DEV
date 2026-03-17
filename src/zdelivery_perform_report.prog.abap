*&---------------------------------------------------------------------*
*& Report ZDELIVERY_PERFORM_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDELIVERY_PERFORM_REPORT.


TABLES:MSEG,MKPF,EKKN.

TYPES :BEGIN OF TY_MSEG,
         MBLNR      TYPE MSEG-MBLNR,
         MJAHR      TYPE MSEG-MJAHR,
         ZEILE      TYPE MSEG-ZEILE,
         BWART      TYPE MSEG-BWART,
         MATNR      TYPE MSEG-MATNR,
         WERKS      TYPE MSEG-WERKS,
         LIFNR      TYPE MSEG-LIFNR,
         MENGE      TYPE MSEG-MENGE,
         MEINS      TYPE MSEG-MEINS,
         EBELN      TYPE MSEG-EBELN,
         EBELP      TYPE MSEG-EBELP,
         SMBLN      TYPE MSEG-SMBLN,
         ABLAD      TYPE MSEG-ABLAD,
         DMBTR      TYPE MSEG-DMBTR,
         BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
         CPUDT_MKPF TYPE MSEG-CPUDT_MKPF,
         XBLNR_MKPF TYPE MSEG-XBLNR_MKPF,
         LGORT      TYPE MSEG-LGORT, "added by pavan
       END OF TY_MSEG,

       BEGIN OF TY_RETURN,
         MBLNR TYPE MSEG-MBLNR,
         MJAHR TYPE MSEG-MJAHR,
         ZEILE TYPE MSEG-ZEILE,
         BWART TYPE MSEG-BWART,
         SMBLN TYPE MSEG-SMBLN,
         LGORT TYPE MSEG-LGORT,
       END OF TY_RETURN,


       BEGIN OF TY_MKPF,
         MBLNR TYPE MKPF-MBLNR,
         MJAHR TYPE MKPF-MJAHR,
         BLDAT TYPE MKPF-BLDAT,
         BKTXT TYPE MKPF-BKTXT,
       END OF TY_MKPF,

       BEGIN OF TY_EKKO,
         EBELN TYPE EKKO-EBELN,
*         EBelp TYPE EKKO-EBelp, "Avinash
         AEDAT TYPE EKKO-AEDAT,
         LIFNR TYPE EKKO-LIFNR,
         WKURS TYPE EKKO-WKURS, "Avinash
         KNUMV TYPE EKKO-KNUMV, "Avinash
         BSART TYPE EKKO-BSART, "Avinash
         EKGRP TYPE EKKO-EKGRP, "Avinash
       END OF TY_EKKO,

       BEGIN OF TY_EKPO,
         EBELN TYPE EKPO-EBELN,
         EBELP TYPE EKPO-EBELP,
         MATNR TYPE EKPO-MATNR,
         MENGE TYPE EKPO-MENGE,
         INFNR TYPE EKPO-INFNR,
         LGORT TYPE EKPO-LGORT,
       END OF TY_EKPO,

       BEGIN OF TY_LFA1,
         LIFNR TYPE LFA1-LIFNR,
         NAME1 TYPE LFA1-NAME1,
       END OF TY_LFA1,

       BEGIN OF TY_EKET,
         EBELN TYPE EKET-EBELN,
         EBELP TYPE EKET-EBELN,
         EINDT TYPE EKET-EINDT,
       END OF TY_EKET,

       BEGIN OF TY_MARA,
         MATNR   TYPE MARA-MATNR,
         ZSERIES TYPE MARA-ZSERIES,
         ZSIZE   TYPE MARA-ZSIZE,
         BRAND   TYPE MARA-BRAND,
         MOC     TYPE MARA-MOC,
         TYPE    TYPE MARA-TYPE,
         MATKL   TYPE MARA-MATKL,                     "ADDED BY VINAYAK
       END OF TY_MARA,

*******Added By Avinash Bhagat****
       BEGIN OF TY_KONV,
         KNUMV TYPE PRCD_ELEMENTS-KNUMV,
         KPOSN TYPE PRCD_ELEMENTS-KPOSN,
         KSCHL TYPE PRCD_ELEMENTS-KSCHL,
         KWERT TYPE PRCD_ELEMENTS-KWERT,
       END OF TY_KONV,

****End of Avinash*****


*********added by saurabh ON 11.9.2024***************
       BEGIN OF ST_EKKN,
         EBELN TYPE EBELN,
         EBELP TYPE EBELP,
         VBELN TYPE VBELN_CO,
         VBELP TYPE POSNR_CO,
         AUFNR TYPE AUFNR,
         ANLN1 TYPE ANLN1,
         ANLN2 TYPE ANLN2,
       END OF ST_EKKN,


***************************************************
       BEGIN OF TY_T023T,
         MATKL TYPE T023T-MATKL,
         WGBEZ TYPE T023T-WGBEZ,
       END OF TY_T023T,

       BEGIN OF TY_FINAL,
         MBLNR         TYPE MSEG-MBLNR,
         BUDAT_MKPF    TYPE MSEG-BUDAT_MKPF,
*         BUDAT_MKPF    TYPE CHAR15,
         LIFNR         TYPE MSEG-LIFNR,
         NAME1         TYPE LFA1-NAME1,
         XBLNR_MKPF    TYPE MSEG-XBLNR_MKPF,
         BLDAT         TYPE MKPF-BLDAT,
*         BLDAT         TYPE CHAR15,
         BKTXT         TYPE MKPF-BKTXT,
         MATNR         TYPE MSEG-MATNR,
         MATTXT        TYPE TEXT255,
         GRN_QTY       TYPE MSEG-MENGE,
         MENGE         TYPE EKPO-MENGE,
         BWART         TYPE MSEG-BWART,
         MEINS         TYPE MSEG-MEINS,
         ABLAD         TYPE MSEG-ABLAD,
         EBELN         TYPE MSEG-EBELN,        "COMMENTED BY SAURABH
         EBELP         TYPE MSEG-EBELP,        "COMMENTED BY SAURABH
         AEDAT         TYPE CHAR15,
*         aedat         TYPE ekko-aedat,
*         EINDT         TYPE CHAR15,
         EINDT         TYPE EKET-EINDT,
         PER           TYPE CHAR10,
         PER1          TYPE CHAR10,
         MATKL         TYPE MARA-MATKL,         "ADDED BY VINAYAK
         WGBEZ         TYPE T023T-WGBEZ,        "ADDED BY VINAYAK
         ZSERIES       TYPE MARA-ZSERIES,
         ZSIZE         TYPE MARA-ZSIZE,
         BRAND         TYPE MARA-BRAND,
         MOC           TYPE MARA-MOC,
         TYPE          TYPE MARA-TYPE,
         WKURS         TYPE EKKO-WKURS, "Avinash
         UNIT_RATE     TYPE PRCD_ELEMENTS-KWERT,
*         unit_rate     TYPE C,
         DMBTR         TYPE MSEG-DMBTR,
*         dmbtr         TYPE C,
         ZPFL          TYPE PRCD_ELEMENTS-KWERT,
         ZINS          TYPE PRCD_ELEMENTS-KWERT,
         ZSCV          TYPE PRCD_ELEMENTS-KWERT,
         ZDVV          TYPE PRCD_ELEMENTS-KWERT,
         ZRB1          TYPE PRCD_ELEMENTS-KWERT,
         ZOCQ          TYPE PRCD_ELEMENTS-KWERT,
         JCDB          TYPE PRCD_ELEMENTS-KWERT,
         ZSWS          TYPE PRCD_ELEMENTS-KWERT,
         LAND_COST_TOT TYPE PRCD_ELEMENTS-KWERT,
*         zpfl          TYPE c,
*         zins          TYPE c,
*         zscv          TYPE c,
*         zdvv          TYPE c,
*         zrb1          TYPE c,
*         zocq          TYPE c,
*         jcdb          TYPE c,
*         zsws          TYPE c,
*         land_cost_tot TYPE c,
         BSART         TYPE EKKO-BSART, "Avinash
         EKGRP         TYPE EKKO-EKGRP, "Avinash
         INFNR         TYPE EKPO-INFNR,
         URZZT         TYPE EINA-URZZT,
         LGORT         TYPE EKPO-LGORT,               "" Added by Pavan 21.06.2024
*         mjahr         TYPE mseg-mjahr,
*         zeile         TYPE mseg-zeile,
*         werks         TYPE mseg-werks,
*         smbln         TYPE mseg-smbln,
*         cpudt_mkpf    TYPE mseg-cpudt_mkpf,
*         knumv         TYPE ekko-knumv, "Avinash
*         kposn         TYPE konv-kposn, "Avinash
*         kschl         TYPE konv-kschl, "Avinash
*         kwert         TYPE konv-kwert, "Avinash
*********ADDED BY SAURABH ON 11.9.2024**************
*         EBELN TYPE EBELN,
*         EBELP  TYPE EBELP,
         VBELN         TYPE VBELN_CO,
         VBELP         TYPE POSNR_CO,
         AUFNR         TYPE AUFNR,
         ANLN1         TYPE ANLN1,
         ANLN2         TYPE ANLN2,
****************************************************

       END OF TY_FINAL,

       BEGIN OF TY_FINAL1,
         MBLNR         TYPE MSEG-MBLNR,
         BUDAT_MKPF    TYPE CHAR15,
         LIFNR         TYPE MSEG-LIFNR,
         NAME1         TYPE LFA1-NAME1,
         XBLNR_MKPF    TYPE MSEG-XBLNR_MKPF,
         BLDAT         TYPE CHAR15,
         BKTXT         TYPE MKPF-BKTXT,
         MATNR         TYPE MSEG-MATNR,
         MATTXT        TYPE TEXT255,
         GRN_QTY       TYPE STRING,
         MENGE         TYPE STRING,
         BWART         TYPE MSEG-BWART,
         MEINS         TYPE MSEG-MEINS,
         ABLAD         TYPE MSEG-ABLAD,
         EBELN         TYPE MSEG-EBELN,               "     COMMENTED BY SAURABH
         EBELP         TYPE MSEG-EBELP,                "    COMMENTED BY SAURABH
         AEDAT         TYPE CHAR15,
         EINDT         TYPE CHAR15,
         PER           TYPE CHAR10,
         ZSERIES       TYPE MARA-ZSERIES,
         ZSIZE         TYPE MARA-ZSIZE,
         BRAND         TYPE MARA-BRAND,
         MOC           TYPE MARA-MOC,
         TYPE          TYPE MARA-TYPE,
         WKURS         TYPE EKKO-WKURS, "Avinash
         UNIT_RATE     TYPE STRING,
         DMBTR         TYPE STRING,
         ZPFL          TYPE STRING,
         ZINS          TYPE STRING,
         ZSCV          TYPE STRING,
         ZDVV          TYPE STRING,
         ZRB1          TYPE STRING,
         ZOCQ          TYPE STRING,
         JCDB          TYPE STRING,
         ZSWS          TYPE STRING,
         LAND_COST_TOT TYPE STRING,
         BSART         TYPE EKKO-BSART, "Avinash
         EKGRP         TYPE EKKO-EKGRP, "Avinash
         INFNR         TYPE EKPO-INFNR,
         URZZT         TYPE EINA-URZZT,
         REF_DAT       TYPE CHAR15,
         REF_TIME      TYPE CHAR15,
         PER1          TYPE CHAR10,            "added by Nilay B. 12.01.2024
         LGORT         TYPE EKPO-LGORT,        "" Added by Pavan 21.06.2024
***********ADDED BY SAURABH ON 11.9.2024**********
*         EBELN TYPE EBELN,
*         EBELP  TYPE EBELP,
         VBELN         TYPE VBELN_CO,
         VBELP         TYPE STRING,
         AUFNR         TYPE AUFNR,
         ANLN1         TYPE ANLN1,
         ANLN2         TYPE ANLN2,
*************************************************

       END OF TY_FINAL1.

DATA : ZPFL TYPE PRCD_ELEMENTS-KWERT,
       ZINS TYPE PRCD_ELEMENTS-KWERT,
       ZSCV TYPE PRCD_ELEMENTS-KWERT,
       ZDVV TYPE PRCD_ELEMENTS-KWERT,
       ZRB1 TYPE PRCD_ELEMENTS-KWERT,
       ZOCQ TYPE PRCD_ELEMENTS-KWERT,
       JCDB TYPE PRCD_ELEMENTS-KWERT,
       ZSWS TYPE PRCD_ELEMENTS-KWERT.

DATA : IT_MSEG   TYPE TABLE OF TY_MSEG,
       WA_MSEG   TYPE          TY_MSEG,

       IT_101    TYPE TABLE OF TY_MSEG,
       WA_101    TYPE          TY_MSEG,

       IT_RETURN TYPE TABLE OF TY_RETURN,
       WA_RETURN TYPE          TY_RETURN,

       IT_EKKO   TYPE TABLE OF TY_EKKO,
       WA_EKKO   TYPE          TY_EKKO,

       IT_KONV   TYPE TABLE OF TY_KONV, "Avinash
       WA_KONV   TYPE          TY_KONV, "Avinash

       IT_EKPO   TYPE TABLE OF TY_EKPO,
       WA_EKPO   TYPE          TY_EKPO,

       IT_LFA1   TYPE TABLE OF TY_LFA1,
       WA_LFA1   TYPE          TY_LFA1,

       IT_EKET   TYPE TABLE OF TY_EKET,
       WA_EKET   TYPE          TY_EKET,

       IT_MKPF   TYPE TABLE OF TY_MKPF,
       WA_MKPF   TYPE          TY_MKPF,

       IT_MARA   TYPE TABLE OF TY_MARA,
       WA_MARA   TYPE          TY_MARA,

       IT_FINAL  TYPE TABLE OF TY_FINAL,
       WA_FINAL  TYPE          TY_FINAL,

       IT_DOWN   TYPE TABLE OF TY_FINAL1,
       WA_DOWN   TYPE          TY_FINAL1,

       IT_EKKN   TYPE TABLE OF ST_EKKN,               "ADDED BY SAURABH ON 11.9.2024
       WA_EKKN   TYPE          ST_EKKN,               "ADDED BY SAURABH ON 11.9.2024

       IT_T023T  TYPE TABLE OF TY_T023T,              "ADDED BY VINAYAK
       WA_T023T  TYPE          TY_T023T.              "ADDED BY VINAYAK

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: LV_NAME  TYPE THEAD-TDNAME,
      LV_LINES TYPE STANDARD TABLE OF TLINE,
      WA_LINES LIKE TLINE.

SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_EBELN FOR MSEG-EBELN,
                  S_MATNR FOR MSEG-MATNR,
                  S_DATE  FOR MSEG-BUDAT_MKPF,
                  S_BLDAT FOR MKPF-BLDAT,  "added By Nilay B. on 15.01.2024
                  S_LIFNR FOR MSEG-LIFNR.
  PARAMETERS :    P_WERKS TYPE MSEG-WERKS OBLIGATORY DEFAULT 'PL01' MODIF ID BU.
  SELECT-OPTIONS: S_LGORT FOR MSEG-LGORT.
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT    '/Delval/India'."India'."India'."temp'.        "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT. " ADDED BY NB on 15.01.2024
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM SORT_DATA.
  PERFORM GET_FCAT.
  PERFORM GET_DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

*IF S_BLDAT IS NOT INITIAL.
  SELECT MBLNR
         MJAHR
         BLDAT
         BKTXT FROM MKPF INTO TABLE IT_MKPF
         WHERE BLDAT IN S_BLDAT
         AND   BUDAT IN S_DATE.

*ENDIF.

  IF IT_MKPF[] IS NOT INITIAL.
    SELECT MBLNR
           MJAHR
           ZEILE
           BWART
           MATNR
           WERKS
           LIFNR
           MENGE
           MEINS
           EBELN
           EBELP
           SMBLN
           ABLAD
           DMBTR
           BUDAT_MKPF
           CPUDT_MKPF
           XBLNR_MKPF
           LGORT
           FROM MSEG INTO TABLE IT_MSEG
           FOR ALL ENTRIES IN IT_MKPF
           WHERE EBELN IN S_EBELN
             AND LIFNR IN S_LIFNR
             AND MATNR IN S_MATNR
             AND BUDAT_MKPF IN S_DATE
             AND WERKS = P_WERKS
             AND BWART = '101'
             AND EBELN NE ' '
             AND MJAHR = IT_MKPF-MJAHR
             AND MBLNR = IT_MKPF-MBLNR
             AND LGORT IN S_LGORT  ."added by pavan
*
*  SELECT MBLNR
*         MJAHR
*         ZEILE
*         BWART
*         MATNR
*         WERKS
*         LIFNR
*         MEINS
*         EBELN
*         EBELP
*         SMBLN
*         ABLAD
*         BUDAT_MKPF
*         CPUDT_MKPF
*         XBLNR_MKPF FROM MSEG INTO TABLE IT_101
*         WHERE EBELN IN S_EBELN
*           AND LIFNR IN S_LIFNR
*           AND MATNR IN S_MATNR
*           AND BUDAT_MKPF IN S_DATE
*           AND WERKS = P_WERKS
*           AND BWART = '101'.
  ENDIF.
  IF IT_MSEG IS NOT INITIAL.
    SELECT MBLNR
           MJAHR
           ZEILE
           BWART
           SMBLN
           LGORT FROM MSEG INTO TABLE IT_RETURN
           FOR ALL ENTRIES IN IT_MSEG
           WHERE SMBLN = IT_MSEG-MBLNR.




  ENDIF.

  IF IT_MSEG IS NOT INITIAL.
    SELECT MBLNR
           MJAHR
           BLDAT
           BKTXT FROM MKPF INTO TABLE IT_MKPF
           FOR ALL ENTRIES IN IT_MSEG
           WHERE MBLNR = IT_MSEG-MBLNR
             AND MJAHR = IT_MSEG-MJAHR
             AND BLDAT IN S_BLDAT.


    SELECT EBELN
*           ebelp
           AEDAT
           LIFNR
           WKURS
           KNUMV
           BSART
           EKGRP
      FROM EKKO INTO TABLE IT_EKKO
           FOR ALL ENTRIES IN IT_MSEG
           WHERE EBELN = IT_MSEG-EBELN.
  ENDIF.
  IF IT_EKKO IS NOT INITIAL.
    SELECT
      KNUMV
      KPOSN
      KSCHL
      KWERT
      FROM PRCD_ELEMENTS INTO TABLE IT_KONV
      FOR ALL ENTRIES IN IT_EKKO
      WHERE KNUMV = IT_EKKO-KNUMV AND KSCHL IN ('ZPFL', 'ZINS', 'ZSCV', 'ZDVV', 'ZRB1', 'ZOCQ', 'JCDB', 'ZSWS')."and kpson = it_ekko-ebelp.
  ENDIF.

  IF IT_MSEG IS NOT INITIAL.
    SELECT EBELN
           EBELP
           MATNR
           MENGE
           INFNR
           LGORT FROM EKPO INTO TABLE IT_EKPO
           FOR ALL ENTRIES IN IT_MSEG
           WHERE EBELN = IT_MSEG-EBELN
             AND EBELP = IT_MSEG-EBELP.
  ENDIF.

  IF IT_MSEG IS NOT INITIAL.
    SELECT EBELN
           EBELP
           EINDT FROM EKET INTO TABLE IT_EKET
           FOR ALL ENTRIES IN IT_MSEG
           WHERE EBELN = IT_MSEG-EBELN
             AND EBELP = IT_MSEG-EBELP.
  ENDIF.

  IF IT_MSEG IS NOT INITIAL.
    SELECT MATNR
           ZSERIES
           ZSIZE
           BRAND
           MOC
           TYPE
           MATKL     FROM MARA INTO TABLE IT_MARA
           FOR ALL ENTRIES IN IT_MSEG
           WHERE MATNR = IT_MSEG-MATNR.

    "ADDED BY VINAYAK
    SELECT MATKL
           WGBEZ FROM T023T INTO TABLE IT_T023T
      FOR ALL ENTRIES IN IT_MARA
      WHERE MATKL EQ IT_MARA-MATKL
      AND SPRAS EQ SY-LANGU.


  ENDIF.

  IF IT_EKKO IS NOT INITIAL.
    SELECT LIFNR
           NAME1 FROM LFA1 INTO TABLE IT_LFA1
           FOR ALL ENTRIES IN IT_EKKO
           WHERE LIFNR = IT_EKKO-LIFNR.



  ENDIF.

  IF IT_EKPO IS NOT INITIAL.
    SELECT EBELN
           EBELP
           EINDT FROM EKET INTO TABLE IT_EKET
           FOR ALL ENTRIES IN IT_EKPO
           WHERE EBELN = IT_EKPO-EBELN
             AND EBELP = IT_EKPO-EBELP.



  ENDIF.
*********ADDED BY SAURABH ON 11.9.2024*************
  IF IT_MSEG IS NOT INITIAL.
    SELECT EBELN
           EBELP
           VBELN
           VBELP
           AUFNR
           ANLN1
           ANLN2
           FROM EKKN INTO TABLE IT_EKKN
           FOR ALL ENTRIES IN IT_MSEG
           WHERE EBELN = IT_MSEG-EBELN
           AND EBELP = IT_MSEG-EBELP.

  ENDIF.


******************************************************
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
  LOOP AT IT_MSEG INTO WA_MSEG.
    READ TABLE IT_RETURN INTO WA_RETURN WITH KEY SMBLN = WA_MSEG-MBLNR.
    IF SY-SUBRC = 4.

      WA_FINAL-MBLNR      = WA_MSEG-MBLNR.
      WA_FINAL-MEINS      = WA_MSEG-MEINS.
      WA_FINAL-ABLAD      = WA_MSEG-ABLAD.
*      wa_final-dmbtr      = wa_mseg-dmbtr.
      WA_FINAL-BWART      = WA_MSEG-BWART.
      WA_FINAL-GRN_QTY    = WA_MSEG-MENGE.
      WA_FINAL-BUDAT_MKPF = WA_MSEG-BUDAT_MKPF.
      WA_FINAL-XBLNR_MKPF = WA_MSEG-XBLNR_MKPF.
      WA_FINAL-LGORT = WA_MSEG-LGORT.
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          INPUT  = WA_MSEG-BUDAT_MKPF
*        IMPORTING
*          OUTPUT = WA_FINAL-BUDAT_MKPF.
*
*      CONCATENATE WA_FINAL-BUDAT_MKPF+0(2) WA_FINAL-BUDAT_MKPF+2(3) WA_FINAL-BUDAT_MKPF+5(4)
*                      INTO WA_FINAL-BUDAT_MKPF SEPARATED BY '-'.

*      wa_final-cpudt_mkpf = wa_mseg-cpudt_mkpf.

      READ TABLE IT_MKPF INTO WA_MKPF WITH KEY MBLNR = WA_MSEG-MBLNR.
      IF SY-SUBRC = 0 .
        WA_FINAL-BKTXT = WA_MKPF-BKTXT.
        WA_FINAL-BLDAT = WA_MKPF-BLDAT.

      ENDIF.

      READ TABLE IT_EKKO INTO WA_EKKO WITH KEY EBELN = WA_MSEG-EBELN.
      IF SY-SUBRC = 0.
        WA_FINAL-EBELN = WA_EKKO-EBELN.
        WA_FINAL-LIFNR = WA_EKKO-LIFNR.
*        wa_final-aedat = wa_ekko-aedat.

***********************ADDED BY SAURABH**************************************
        READ TABLE IT_EKKN INTO WA_EKKN WITH KEY EBELN = WA_MSEG-EBELN EBELP = WA_MSEG-EBELP.
*        READ TABLE IT_EKKN INTO WA_EKKN WITH KEY  EBELN = wa_EKET-EBELN.
        IF SY-SUBRC = 0.
          WA_FINAL-VBELN = WA_EKKN-VBELN.
          WA_FINAL-VBELP = WA_EKKN-VBELP.
          WA_FINAL-AUFNR = WA_EKKN-AUFNR.
          WA_FINAL-ANLN1 = WA_EKKN-ANLN1.
          WA_FINAL-ANLN2 = WA_EKKN-ANLN2.
*******************************************************************************
        ENDIF.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_EKKO-AEDAT
          IMPORTING
            OUTPUT = WA_FINAL-AEDAT.

        CONCATENATE WA_FINAL-AEDAT+0(2) WA_FINAL-AEDAT+2(3) WA_FINAL-AEDAT+5(4)
                        INTO WA_FINAL-AEDAT SEPARATED BY '-'.

        WA_FINAL-WKURS = WA_EKKO-WKURS.
        WA_FINAL-BSART = WA_EKKO-BSART.
        WA_FINAL-EKGRP = WA_EKKO-EKGRP.
      ENDIF.

      READ TABLE IT_LFA1 INTO WA_LFA1 WITH KEY LIFNR = WA_FINAL-LIFNR.
      IF SY-SUBRC = 0.
        WA_FINAL-NAME1 = WA_LFA1-NAME1.
      ENDIF.

      READ TABLE IT_EKPO INTO WA_EKPO WITH KEY EBELN = WA_MSEG-EBELN EBELP = WA_MSEG-EBELP.
      IF SY-SUBRC = 0.
        WA_FINAL-MATNR = WA_EKPO-MATNR.
        WA_FINAL-MENGE = WA_EKPO-MENGE.
        WA_FINAL-EBELP = WA_EKPO-EBELP.
        WA_FINAL-INFNR = WA_EKPO-INFNR.

      ENDIF.
      IF  WA_FINAL-INFNR IS NOT INITIAL.
        SELECT SINGLE URZZT FROM EINA INTO WA_FINAL-URZZT WHERE INFNR = WA_FINAL-INFNR.
      ENDIF.
      WA_FINAL-UNIT_RATE = WA_FINAL-ABLAD * WA_FINAL-WKURS.
      WA_FINAL-DMBTR      = WA_FINAL-GRN_QTY * WA_FINAL-UNIT_RATE.
      LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_EKKO-KNUMV AND KPOSN = WA_FINAL-EBELP.
        CASE WA_KONV-KSCHL.
          WHEN 'ZPFL'.
            WA_FINAL-ZPFL = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
          WHEN 'ZINS'.
            WA_FINAL-ZINS = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
          WHEN 'ZSCV'.
            WA_FINAL-ZSCV = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
          WHEN 'ZDVV'.
            WA_FINAL-ZDVV = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
          WHEN 'ZRB1'.
            WA_FINAL-ZRB1 = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
          WHEN 'ZOCQ'.
            WA_FINAL-ZOCQ = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
          WHEN 'JCDB'.
            WA_FINAL-JCDB = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
          WHEN 'ZSWS'.
            WA_FINAL-ZSWS = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        ENDCASE.
        CLEAR WA_KONV.
      ENDLOOP.

      WA_FINAL-LAND_COST_TOT = WA_FINAL-DMBTR + WA_FINAL-ZPFL + WA_FINAL-ZINS + WA_FINAL-ZSCV + WA_FINAL-ZDVV + WA_FINAL-ZRB1 + WA_FINAL-ZOCQ + WA_FINAL-JCDB ."+ wa_final-unit_rate.

      READ TABLE IT_EKET INTO WA_EKET WITH KEY EBELN = WA_FINAL-EBELN EBELP = WA_FINAL-EBELP.
      IF SY-SUBRC = 0.

        WA_FINAL-EINDT = WA_EKET-EINDT.
      ENDIF.

      READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_FINAL-MATNR.
      IF SY-SUBRC = 0.
        WA_FINAL-ZSERIES   = WA_MARA-ZSERIES  .
        WA_FINAL-ZSIZE     = WA_MARA-ZSIZE    .
        WA_FINAL-BRAND     = WA_MARA-BRAND    .
        WA_FINAL-MOC       = WA_MARA-MOC      .
        WA_FINAL-TYPE      = WA_MARA-TYPE     .
        WA_FINAL-MATKL     = WA_MARA-MATKL    .

        READ TABLE IT_T023T INTO wa_t023t WITH KEY MATKL = WA_MARA-MATKL.
        IF SY-SUBRC EQ 0.
          WA_FINAL-WGBEZ = wa_t023t-WGBEZ.
        ENDIF.

      ENDIF.
      IF WA_FINAL-BUDAT_MKPF LE  WA_FINAL-EINDT.
        WA_FINAL-PER = '100'.
      ELSE.
        WA_FINAL-PER = '0'.
      ENDIF.

      IF WA_FINAL-BLDAT LE  WA_FINAL-EINDT.
        WA_FINAL-PER1 = '100'.
      ELSE.
        WA_FINAL-PER1 = '0'.
      ENDIF.

      CLEAR: LV_LINES, LV_NAME,WA_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_FINAL-MATNR.
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO WA_LINES.
          IF NOT WA_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_FINAL-MATTXT WA_LINES-TDLINE INTO WA_FINAL-MATTXT SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
        CONDENSE WA_FINAL-MATTXT.
      ENDIF.




      APPEND WA_FINAL TO IT_FINAL.
      CLEAR:WA_FINAL.
    ENDIF.
  ENDLOOP.


  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-MBLNR         = WA_FINAL-MBLNR        .
*      WA_DOWN-BUDAT_MKPF    = WA_FINAL-BUDAT_MKPF   .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-BUDAT_MKPF
        IMPORTING
          OUTPUT = WA_DOWN-BUDAT_MKPF.

      CONCATENATE WA_DOWN-BUDAT_MKPF+0(2) WA_DOWN-BUDAT_MKPF+2(3) WA_DOWN-BUDAT_MKPF+5(4)
                      INTO WA_DOWN-BUDAT_MKPF SEPARATED BY '-'.


      WA_DOWN-LIFNR         = WA_FINAL-LIFNR        .
      WA_DOWN-NAME1         = WA_FINAL-NAME1        .
      WA_DOWN-XBLNR_MKPF    = WA_FINAL-XBLNR_MKPF   .
*      WA_DOWN-BLDAT         = WA_FINAL-BLDAT        .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-BLDAT
        IMPORTING
          OUTPUT = WA_DOWN-BLDAT.

      CONCATENATE WA_DOWN-BLDAT+0(2) WA_DOWN-BLDAT+2(3) WA_DOWN-BLDAT+5(4)
                      INTO WA_DOWN-BLDAT SEPARATED BY '-'.
      WA_DOWN-BKTXT         = WA_FINAL-BKTXT        .
      WA_DOWN-MATNR         = WA_FINAL-MATNR        .
      WA_DOWN-MATTXT        = WA_FINAL-MATTXT       .
      WA_DOWN-GRN_QTY       = WA_FINAL-GRN_QTY      .
      WA_DOWN-MENGE         = WA_FINAL-MENGE        .
      WA_DOWN-BWART         = WA_FINAL-BWART        .
      WA_DOWN-MEINS         = WA_FINAL-MEINS        .
      WA_DOWN-ABLAD         = WA_FINAL-ABLAD        .
      WA_DOWN-EBELN         = WA_FINAL-EBELN        .
      WA_DOWN-EBELP         = WA_FINAL-EBELP        .
      WA_DOWN-AEDAT         = WA_FINAL-AEDAT        .
*      WA_DOWN-EINDT         = WA_FINAL-EINDT        .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-EINDT
        IMPORTING
          OUTPUT = WA_DOWN-EINDT.

      CONCATENATE WA_DOWN-EINDT+0(2) WA_DOWN-EINDT+2(3) WA_DOWN-EINDT+5(4)
                      INTO WA_DOWN-EINDT SEPARATED BY '-'.
      WA_DOWN-PER           = WA_FINAL-PER          .
      WA_DOWN-ZSERIES       = WA_FINAL-ZSERIES      .
      WA_DOWN-ZSIZE         = WA_FINAL-ZSIZE        .
      WA_DOWN-BRAND         = WA_FINAL-BRAND        .
      WA_DOWN-MOC           = WA_FINAL-MOC          .
      WA_DOWN-TYPE          = WA_FINAL-TYPE         .
      WA_DOWN-WKURS         = WA_FINAL-WKURS        .
      WA_DOWN-UNIT_RATE     = WA_FINAL-UNIT_RATE    .
      WA_DOWN-DMBTR         = WA_FINAL-DMBTR        .
      WA_DOWN-ZPFL          = WA_FINAL-ZPFL         .
      WA_DOWN-ZINS          = WA_FINAL-ZINS         .
      WA_DOWN-ZSCV          = WA_FINAL-ZSCV         .
      WA_DOWN-ZDVV          = WA_FINAL-ZDVV         .
      WA_DOWN-ZRB1          = WA_FINAL-ZRB1         .
      WA_DOWN-ZOCQ          = WA_FINAL-ZOCQ         .
      WA_DOWN-JCDB          = WA_FINAL-JCDB         .
      WA_DOWN-ZSWS          = WA_FINAL-ZSWS         .
      WA_DOWN-LAND_COST_TOT = WA_FINAL-LAND_COST_TOT.
      WA_DOWN-BSART         = WA_FINAL-BSART        .
      WA_DOWN-EKGRP         = WA_FINAL-EKGRP        .
      WA_DOWN-INFNR         = WA_FINAL-INFNR        .
      WA_DOWN-URZZT         = WA_FINAL-URZZT        .

      WA_DOWN-LGORT         = WA_FINAL-LGORT        .                     "" added by Pavan 21.06.24
      "added by saurabh on 11.9.2024
      WA_DOWN-VBELN = WA_FINAL-VBELN.
*          WA_DOWN-VBELP = WA_FINAL-VBELP.                     "already commented
      IF WA_FINAL-VBELP IS NOT INITIAL.                  "added by aakashk 13.08.2024
        WA_DOWN-VBELP = WA_FINAL-VBELP.
      ENDIF.
      IF WA_DOWN-VBELP = 0.
        CLEAR  WA_DOWN-VBELP.
*            wa_down-vbelp = ''.
      ENDIF.                                                 "endadd by aakashk 13.08.2024
      WA_DOWN-AUFNR = WA_FINAL-AUFNR.
      WA_DOWN-ANLN1 = WA_FINAL-ANLN1.
      WA_DOWN-ANLN2 = WA_FINAL-ANLN2.
      "end of changes by saurabh
*****************************************  ,added by shreya ***********************
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF_DAT.

      CONCATENATE WA_DOWN-REF_DAT+0(2) WA_DOWN-REF_DAT+2(3) WA_DOWN-REF_DAT+5(4)
      INTO WA_DOWN-REF_DAT SEPARATED BY '-'.

      WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

      WA_DOWN-PER1           = WA_FINAL-PER1        .
***********************    ,added by shreya*****************
      APPEND WA_DOWN TO IT_DOWN.
*      CLEAR wa_final.                        "commented by aakashk 15.09.2024
      CLEAR WA_DOWN.                         "added by aakashk 15.09.2024
    ENDLOOP.
  ENDIF.
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
  PERFORM FCAT USING :   '1'   'MBLNR'                'IT_FINAL'      'Mat. Doc.'                     '20' ,
                         '2'   'BUDAT_MKPF'           'IT_FINAL'      'Posting Date'                  '10' ,
                         '3'   'LIFNR'                'IT_FINAL'      'Vendor Code'                   '15' ,
                         '4'   'NAME1'                'IT_FINAL'      'Vendor Name'                   '15' ,
                         '5'   'XBLNR_MKPF'           'IT_FINAL'      'Reference'                     '15' ,
                         '6'   'BLDAT'                'IT_FINAL'      'Doc. Date'                     '15' ,
                         '7'   'BKTXT'                'IT_FINAL'      'Doc.Header Text'                     '15' ,
                         '8'   'MATNR'                'IT_FINAL'      'Material'                        '15' ,
                         '9'   'MATKL'                'IT_FINAL'      'Material Group'                  '15',               "ADDED BY VINAYAK
                         '10'   'WGBEZ'                'IT_FINAL'      'Material Group Des'                  '15',          "ADDED BY VINAYAK
                         '11'   'MATTXT'               'IT_FINAL'      'Material Des'                        '15' ,
                        '12'   'GRN_QTY'              'IT_FINAL'      'GRN Quantity'                        '15' ,
                        '13'   'MENGE'                'IT_FINAL'      'PO Quantity'                        '15' ,
                        '14'   'BWART'                'IT_FINAL'      'Mov.Type'                        '15' ,
                        '15'   'MEINS'                'IT_FINAL'      'UOM'                        '15' ,
                        '16'   'ABLAD'                'IT_FINAL'      'Unloading Point'                        '15' ,
                        '17'   'EBELN'                'IT_FINAL'      'PO No'                        '15' ,
                        '18'   'EBELP'                'IT_FINAL'      'PO Line Item'                        '15' ,
                        '19'   'AEDAT'                'IT_FINAL'      'PO Date'                        '15' ,
                        '20'   'EINDT'                'IT_FINAL'      'PO Del Date'                        '15' ,
                        '21'   'PER'                  'IT_FINAL'      'Delivery Rating(Posting Date)' '30' ,  "
                        '22'   'ZSERIES'              'IT_FINAL'      'Series'                        '15' ,
                        '23'   'ZSIZE'                'IT_FINAL'      'Size'                        '15' ,
                        '24'   'BRAND'                'IT_FINAL'      'Brand'                        '15' ,
                        '25'   'MOC'                  'IT_FINAL'      'MOC'                        '15' ,
                        '26'   'TYPE'                  'IT_FINAL'     'TYPE'                        '15' ,
                        '27'   'WKURS'                 'IT_FINAL'     'Exchange Rate'                '13' ,
                        '28'   'UNIT_RATE'              'IT_FINAL'    'Unit Rate in INR'                '13' ,
                        '29'   'DMBTR'              'IT_FINAL'        'Total Basic Value in INR'                '13' ,
                        '30'   'ZPFL'                  'IT_FINAL'     'P&F charges in INR'             '13' ,
                        '31'   'ZINS'                  'IT_FINAL'     'Inspection Charges in INR'   '13' ,
                        '32'   'ZSCV'                  'IT_FINAL'     'Setting Charges in INR'       '13' ,
                        '33'   'ZDVV'                  'IT_FINAL'     'Development charges in INR'  '13' ,
                        '34'   'ZRB1'                  'IT_FINAL'     'Freight Charges in INR'         '13' ,
                        '35'   'ZOCQ'                  'IT_FINAL'     'Other Charges in INR'           '13' ,
                        '36'   'JCDB'                  'IT_FINAL'     'Basic Custom Duty in INR'           '13' ,
                        '37'   'ZSWS'                  'IT_FINAL'     'Social Welfare Cess in INR'      '13' ,
                        '38'   'LAND_COST_TOT'         'IT_FINAL'     'Landed Cost  in INR'          '13' ,
                        '39'   'BSART'                  'IT_FINAL'    'PO Type'      '4' ,
                        '40'   'EKGRP'                  'IT_FINAL'    'Purchasing Group'            '3' ,
                        '41'   'INFNR'                  'IT_FINAL'    'INFO Record'            '10' ,
                        '42'   'URZZT'                  'IT_FINAL'    'Casting Weight'            '16' ,
                        '43'   'PER1'                   'IT_FINAL'    'Delivery Rating(Document Date)'            '30',  "Added by Nilay B. 12.01.2024
                         '44'   'LGORT'                  'IT_FINAL'    'Storage Location'            '30' ,              "Added by Pavan A. 20.06.2024
**************************************ADDED BY SAURABH ON 11.9.024 ***********************************************
                        '45'   'VBELN'                  'IT_FINAL'    'Sales order number'            '30' ,
                        '46'   'VBELP'                  'IT_FINAL'    'SO Line'            '30' ,
                        '47'   'AUFNR'                  'IT_FINAL'    'Internal order number'            '30' ,
                        '48'   'ANLN1'                  'IT_FINAL'    'ASSET Number'            '30' ,
                        '49'   'ANLN2'                  'IT_FINAL'    'Sub Asset Number'            '30' .
*******************************************************************************************************************



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DISPLAY .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      IT_FIELDCAT        = IT_FCAT
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB           = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1005   text
*      -->P_1006   text
*      -->P_1007   text
*      -->P_1008   text
*      -->P_1009   text
*----------------------------------------------------------------------*
FORM FCAT USING    VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.

FORM DOWNLOAD .
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
*  break primus.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
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
  LV_FILE =   'ZDELIVERY_PERFORMANCE.TXT'.
*BREAK primus.
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'DELIVERY PERFORM REPORT Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1023 TYPE STRING.
    DATA LV_CRLF_1023 TYPE STRING.
    LV_CRLF_1023 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1023 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1023 LV_CRLF_1023 WA_CSV INTO LV_STRING_1023.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_982 TO lv_fullfile.
    TRANSFER LV_STRING_1023 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
ENDFORM.

FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Mat. Doc.'
              'Posting Date'
              'Vendor Code'
              'Vendor Name'
              'Reference'
              'Doc. Date'
              'Doc.Header Text'
              'Material'
              'Material Des'
              'GRN Quantity'
              'PO Quantity'
              'Mov.Type'
              'UOM'
              'Unloading Point'
              'PO No'
              'PO Line Item'
              'PO Date'
              'PO Del Date'
              'Delivery Rating(Posting Date)'
              'Series'
              'Size'
              'Brand'
              'MOC'
              'TYPE'
              'Exchange Rate'
              'Unit Rate in INR'
              'Total Basic Value in INR'
              'P&F charges in INR'
              'Inspection Charges in INR'
              'Setting Charges in INR'
              'Development charges in INR'
              'Freight Charges in INR'
              'Other Charges in INR'
              'Basic Custom Duty in INR'
              'Social Welfare Cess in INR'
              'Landed Cost  in INR'
              'PO Type'
              'Purchasing Group'
              'INFO Record'
              'Casting Weight'
              'Ref Date'
              'Ref Time'
              'Delivery Rating(Document Date)'  "Added By Nilay on 12.01.2024
              'Storage Location'
**************ADDED BY SAURABH ON 11.9.2024******************
              'Sales order number'
              'SO Line'
              'Internal order number'
              'ASSET Number'
              'Sub Asset Number'
**************************************************************
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
