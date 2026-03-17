*&---------------------------------------------------------------------*
*& Report ZUS_DEL_PER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_DEL_PER_N.

TABLES:MSEG,MKPF.

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
       END OF TY_MSEG,

       BEGIN OF TY_RETURN,
         MBLNR TYPE MSEG-MBLNR,
         MJAHR TYPE MSEG-MJAHR,
         ZEILE TYPE MSEG-ZEILE,
         BWART TYPE MSEG-BWART,
         SMBLN TYPE MSEG-SMBLN,
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
       END OF TY_MARA,

*******Added By Avinash Bhagat****
       BEGIN OF TY_KONV,
         KNUMV TYPE prcd_elements-KNUMV,
         KPOSN TYPE prcd_elements-KPOSN,
         KSCHL TYPE prcd_elements-KSCHL,
         KBETR TYPE prcd_elements-KBETR,"ADDED BY SUPRIYA ON 01.07.2024
         KWERT TYPE prcd_elements-KWERT,
       END OF TY_KONV,

****End of Avinash*****
       BEGIN OF TY_FINAL,
         MBLNR         TYPE MSEG-MBLNR,
         budat_mkpf    TYPE mseg-budat_mkpf,
         LV_BUDAT      TYPE CHAR10,
*         BUDAT_MKPF    TYPE CHAR15,
         LIFNR         TYPE MSEG-LIFNR,
         NAME1         TYPE LFA1-NAME1,
         XBLNR_MKPF    TYPE MSEG-XBLNR_MKPF,
         bldat         TYPE mkpf-bldat,
         lv_BLDAT         TYPE CHAR10,
         BKTXT         TYPE MKPF-BKTXT,
         MATNR         TYPE MSEG-MATNR,
         MATTXT        TYPE TEXT255,
         GRN_QTY       TYPE string,"MSEG-MENGE,
         MENGE         TYPE string,"EKPO-MENGE,
         BWART         TYPE MSEG-BWART,
         MEINS         TYPE MSEG-MEINS,
         ABLAD         TYPE MSEG-ABLAD,
         EBELN         TYPE MSEG-EBELN,
         EBELP         TYPE MSEG-EBELP,
         AEDAT         TYPE CHAR15,
         LV_aedat      TYPE CHAR11,
         lv_EINDT         TYPE CHAR10,
         eindt         TYPE eket-eindt,
         PER           TYPE CHAR10,
         PER1          TYPE CHAR10,
         ZSERIES       TYPE MARA-ZSERIES,
         ZSIZE         TYPE MARA-ZSIZE,
         BRAND         TYPE MARA-BRAND,
         MOC           TYPE MARA-MOC,
         TYPE          TYPE MARA-TYPE,
         WKURS         TYPE EKKO-WKURS, "Avinash
         UNIT_RATE     TYPE string ,"KONV-KWERT,
*         unit_rate     TYPE C,
         DMBTR         TYPE  string," MSEG-DMBTR,
*         dmbtr         TYPE C,
         ZPFL          TYPE string,"KONV-KWERT,
         ZINS          TYPE string," KONV-KWERT,
         ZSCV          TYPE string,"KONV-KWERT,
         ZDVV          TYPE string," KONV-KWERT,
         ZRB1          TYPE string,"KONV-KWERT,
         ZOCQ          TYPE string,"KONV-KWERT,
         JCDB          TYPE string,"KONV-KWERT,
         ZSWS          TYPE string,"KONV-KWERT,
         LAND_COST_TOT TYPE string ,"KONV-KWERT,
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
*         mjahr         TYPE mseg-mjahr,
*         zeile         TYPE mseg-zeile,
*         werks         TYPE mseg-werks,
*         smbln         TYPE mseg-smbln,
*         cpudt_mkpf    TYPE mseg-cpudt_mkpf,
*         knumv         TYPE ekko-knumv, "Avinash
*         kposn         TYPE konv-kposn, "Avinash
*         kschl         TYPE konv-kschl, "Avinash
*         kwert         TYPE konv-kwert, "Avinash

       END OF TY_FINAL,

       BEGIN OF TY_FINAL1,
         REF_DAT       TYPE CHAR15,      " add by supriya on 19.07.2024
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
         EBELN         TYPE MSEG-EBELN,
         EBELP         TYPE MSEG-EBELP,
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
*         REF_DAT       TYPE CHAR15,     " commented by supriya on 19.07.2024
         REF_TIME      TYPE CHAR15,
         PER1          TYPE CHAR10,            "added by Nilay B. 12.01.2024

       END OF TY_FINAL1.

DATA : ZPFL TYPE prcd_elements-KWERT,
       ZINS TYPE prcd_elements-KWERT,
       ZSCV TYPE prcd_elements-KWERT,
       ZDVV TYPE prcd_elements-KWERT,
       ZRB1 TYPE prcd_elements-KWERT,
       ZOCQ TYPE prcd_elements-KWERT,
       JCDB TYPE prcd_elements-KWERT,
       ZSWS TYPE prcd_elements-KWERT.

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
       WA_DOWN   TYPE          TY_FINAL1.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: LV_NAME  TYPE THEAD-TDNAME,
      LV_LINES TYPE STANDARD TABLE OF TLINE,
      WA_LINES LIKE TLINE.

DATA : LV_BLDAT TYPE CHAR10.

SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_EBELN FOR MSEG-EBELN,
                S_MATNR FOR MSEG-MATNR,
                S_DATE  FOR MSEG-BUDAT_MKPF,
                S_BLDAT FOR MKPF-BLDAT,  "added By Nilay B. on 15.01.2024
                S_LIFNR FOR MSEG-LIFNR.
PARAMETERS :    P_WERKS TYPE MSEG-WERKS  MATCHCODE OBJECT ZSH_DEL_PER_N . "OBLIGATORY DEFAULT 'PL01' MODIF ID BU
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/USA'."USA'."USA'."USA'."'E:/Delval/USA'."USA'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

*AT SELECTION-SCREEN ON S_BLDAT.
*    BREAK-POINT.
*  CONCATENATE  S_BLDAT-LOW+4(2) S_BLDAT-LOW+6(2) S_BLDAT-LOW+0(4) INTO LV_BLDAT .
*  S_BLDAT-LOW = LV_BLDAT.

AT SELECTION-SCREEN OUTPUT.
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
         XBLNR_MKPF FROM MSEG INTO TABLE IT_MSEG
         FOR ALL ENTRIES IN IT_MKPF
         WHERE EBELN IN S_EBELN
           AND LIFNR IN S_LIFNR
           AND MATNR IN S_MATNR
           AND BUDAT_MKPF IN S_DATE
           AND WERKS = P_WERKS
           AND BWART = '101'
           AND EBELN NE ' '
           AND MJAHR = IT_MKPF-MJAHR
           AND MBLNR = IT_MKPF-MBLNR  .
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
           SMBLN FROM MSEG INTO TABLE IT_RETURN
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
      KBETR "ADDED BY SUPRIYA ON 01.07.2024
      KWERT
      FROM prcd_elements INTO TABLE IT_KONV
      FOR ALL ENTRIES IN IT_EKKO
      "P000 ADDED BY SUPRIYA ON 01.07.2024
      WHERE KNUMV = IT_EKKO-KNUMV AND KSCHL IN ('ZPFL', 'ZINS', 'ZSCV', 'ZDVV', 'ZRB1', 'ZOCQ', 'JCDB', 'ZSWS','P000')."and kpson = it_ekko-ebelp.
  ENDIF.

  IF IT_MSEG IS NOT INITIAL.
    SELECT EBELN
           EBELP
           MATNR
           MENGE
           INFNR FROM EKPO INTO TABLE IT_EKPO
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
           TYPE     FROM MARA INTO TABLE IT_MARA
           FOR ALL ENTRIES IN IT_MSEG
           WHERE MATNR = IT_MSEG-MATNR.


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
***************************Added by jyoti on 01.07.2024*******************************
      WA_FINAL-GRN_QTY = REPLACE( val =  WA_FINAL-GRN_QTY sub = ',' with = '' ).
***************************************************************************************
      wa_final-budat_mkpf = wa_mseg-budat_mkpf.
      WA_FINAL-XBLNR_MKPF = WA_MSEG-XBLNR_MKPF.

*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          INPUT  = WA_MSEG-BUDAT_MKPF
*        IMPORTING
*          OUTPUT = WA_FINAL-BUDAT_MKPF.
      DATA lv_budat TYPE CHAR10.                                                                      """Added by Pranit 04.03.2024
      CONCATENATE wa_mseg-BUDAT_MKPF+4(2) wa_mseg-BUDAT_MKPF+6(2) wa_mseg-BUDAT_MKPF+0(4)
                      INTO lv_budat SEPARATED BY '.'.

      wa_final-lv_budat = lv_budat.                                                                    """Ended by Pranit 04.03.2024

      READ TABLE IT_MKPF INTO WA_MKPF WITH KEY MBLNR = WA_MSEG-MBLNR.
      IF SY-SUBRC = 0 .
        WA_FINAL-BKTXT = WA_MKPF-BKTXT.
        wa_final-bldat = wa_mkpf-bldat.

              DATA LV_bldat TYPE CHAR10.                                                               """Added by Pranit 04.03.2024
      CONCATENATE wa_mkpf-bldat+4(2) wa_mkpf-bldat+6(2) wa_mkpf-bldat+0(4)
                      INTO LV_bldat SEPARATED BY '.'.

      wa_final-lv_bldat = LV_bldat.

      ENDIF.

      READ TABLE IT_EKKO INTO WA_EKKO WITH KEY EBELN = WA_MSEG-EBELN.
      IF SY-SUBRC = 0.
        WA_FINAL-EBELN = WA_EKKO-EBELN.
        WA_FINAL-LIFNR = WA_EKKO-LIFNR.
*        wa_final-aedat = wa_ekko-aedat.

********************************************************* by supriya on 13.07.2024
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            INPUT  = WA_EKKO-AEDAT
*          IMPORTING
*            OUTPUT = WA_FINAL-AEDAT.
*
*        CONCATENATE WA_FINAL-AEDAT+0(2) WA_FINAL-AEDAT+2(3) WA_FINAL-AEDAT+5(4)
*                        INTO WA_FINAL-AEDAT SEPARATED BY '-'.
*         DATA lv_AEDAT TYPE CHAR11.
********************************************************************** Add by supriya on 13.07.2024
         wa_final-aedat = wa_ekko-aedat.
          DATA LV_AEDAT TYPE CHAR15.
         CONCATENATE WA_EKKO-AEDAT+4(2) WA_EKKO-AEDAT+6(2)  WA_EKKO-AEDAT+0(4)
                        INTO LV_AEDAT  SEPARATED BY '.'.
          WA_FINAL-AEDAT = LV_AEDAT.
******************************************************************
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
***************************added by jyoti on 01.07.2024*********************************
         WA_FINAL-MENGE = REPLACE( val =  WA_FINAL-MENGE sub = ',' with = '' ).
*****************************************************************************************
        WA_FINAL-EBELP = WA_EKPO-EBELP.
        WA_FINAL-INFNR = WA_EKPO-INFNR.
      ENDIF.
*      IF  WA_FINAL-INFNR IS NOT INITIAL.
*        SELECT SINGLE URZZT FROM EINA INTO WA_FINAL-URZZT WHERE INFNR = WA_FINAL-INFNR.
*      ENDIF.
*      WA_FINAL-UNIT_RATE = WA_FINAL-ABLAD * WA_FINAL-WKURS.

*     START ADDED BY SUPRIYA ON 01.07.2024
      READ TABLE it_konv INTO wa_konv WITH KEY kschl = 'P000' knumv = WA_EKKO-KNUMV KPOSN = WA_EKPO-EBELP.
      if sy-subrc = 0.
              WA_FINAL-UNIT_RATE  = wa_konv-KBETR.
* ********************added by jyoti on 01.07.2024**************************
              DATA : gv_unitrate type string.
              gv_unitrate =  WA_FINAL-UNIT_RATE."ADDED BY SUPRIYA ON 01.07.2024
                gv_unitrate = REPLACE( val = gv_unitrate sub = ',' with = '' ).
                clear :WA_FINAL-UNIT_RATE.
                 WA_FINAL-UNIT_RATE = gv_unitrate.
                   DATA : gv_dmbtr type string.
              WA_FINAL-DMBTR      = WA_FINAL-GRN_QTY * WA_FINAL-UNIT_RATE."ADDED BY SUPRIYA ON 01.07.2024
              gv_dmbtr = WA_FINAL-DMBTR .
               gv_dmbtr = REPLACE( val = gv_dmbtr sub = ',' with = '' ).
               wa_final-dmbtr = gv_dmbtr.
********************************************************************************
      endif.
*     END ADDED BY SUPRIYA ON 01.07.2024
*      WA_FINAL-DMBTR      = WA_FINAL-GRN_QTY * WA_FINAL-UNIT_RATE.
      CLEAR:WA_KONV."ADDED BY SUPRIYA ON 01.07.2024
      LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_EKKO-KNUMV AND KPOSN = WA_FINAL-EBELP.
        CASE WA_KONV-KSCHL.
          WHEN 'ZPFL'.
            WA_FINAL-ZPFL = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
            WA_FINAL-ZPFL = REPLACE( val = WA_FINAL-ZPFL sub = ',' with = '' )."added by jyoti on 01.07.2024
          WHEN 'ZINS'.
            WA_FINAL-ZINS = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
            WA_FINAL-ZINS = REPLACE( val = WA_FINAL-ZINS sub = ',' with = '' )."added by jyoti on 01.07.2024
          WHEN 'ZSCV'.
            WA_FINAL-ZSCV = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
            WA_FINAL-ZSCV = REPLACE( val = WA_FINAL-ZSCV sub = ',' with = '' )."added by jyoti on 01.07.2024
          WHEN 'ZDVV'.
            WA_FINAL-ZDVV = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
            WA_FINAL-ZDVV = REPLACE( val = WA_FINAL-ZDVV sub = ',' with = '' )."added by jyoti on 01.07.2024
          WHEN 'ZRB1'.
            WA_FINAL-ZRB1 = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
            WA_FINAL-ZRB1 = REPLACE( val = WA_FINAL-ZRB1 sub = ',' with = '' )."added by jyoti on 01.07.2024
          WHEN 'ZOCQ'.
            WA_FINAL-ZOCQ = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
            WA_FINAL-ZOCQ = REPLACE( val = WA_FINAL-ZOCQ sub = ',' with = '' )."added by jyoti on 01.07.2024
          WHEN 'JCDB'.
            WA_FINAL-JCDB = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
            WA_FINAL-JCDB = REPLACE( val = WA_FINAL-JCDB sub = ',' with = '' )."added by jyoti on 01.07.2024
          WHEN 'ZSWS'.
            WA_FINAL-ZSWS = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
            WA_FINAL-ZSWS = REPLACE( val = WA_FINAL-ZSWS sub = ',' with = '' )."added by jyoti on 01.07.2024
        ENDCASE.
        CLEAR WA_KONV.
      ENDLOOP.

      WA_FINAL-LAND_COST_TOT = WA_FINAL-DMBTR + WA_FINAL-ZPFL + WA_FINAL-ZINS + WA_FINAL-ZSCV + WA_FINAL-ZDVV + WA_FINAL-ZRB1 + WA_FINAL-ZOCQ + WA_FINAL-JCDB ."+ wa_final-unit_rate.
*****************************added by jyotion 01.07.2024
         DATA : gv_LAND_COST_TOT TYPE string.
         gv_LAND_COST_TOT = WA_FINAL-LAND_COST_TOT .
          gv_LAND_COST_TOT  = REPLACE( val =   gv_LAND_COST_TOT  sub = ',' with = '' ).
         WA_FINAL-LAND_COST_TOT  =  gv_LAND_COST_TOT .
******************************************************
      READ TABLE IT_EKET INTO WA_EKET WITH KEY EBELN = WA_FINAL-EBELN EBELP = WA_FINAL-EBELP.
      IF SY-SUBRC = 0.

        wa_final-eindt = wa_eket-eindt.

                      DATA LV_eindt TYPE CHAR10.                                                               """Added by Pranit 04.03.2024
      CONCATENATE wa_eket-eindt+4(2) wa_eket-eindt+6(2) wa_eket-eindt+0(4)
                      INTO LV_eindt SEPARATED BY '.'.

      wa_final-LV_eindt = LV_eindt.
      ENDIF.

      READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_FINAL-MATNR.
      IF SY-SUBRC = 0.
        WA_FINAL-ZSERIES   = WA_MARA-ZSERIES  .
        WA_FINAL-ZSIZE     = WA_MARA-ZSIZE    .
        WA_FINAL-BRAND     = WA_MARA-BRAND    .
        WA_FINAL-MOC       = WA_MARA-MOC      .
        WA_FINAL-TYPE      = WA_MARA-TYPE     .


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
      IF LV_NAME is NOT INITIAL.                  """Added by Pranit 05.02.2024

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
      ENDIF.
      APPEND WA_FINAL TO IT_FINAL.
      CLEAR:WA_FINAL.
    ENDIF.
  ENDLOOP.


  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-MBLNR         = WA_FINAL-MBLNR        .
*      WA_DOWN-BUDAT_MKPF    = WA_FINAL-BUDAT_MKPF   .
*       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          INPUT  = WA_FINAL-BUDAT_MKPF
*        IMPORTING
*          OUTPUT = WA_DOWN-BUDAT_MKPF.
*
*      CONCATENATE WA_FINAL-BUDAT_MKPF+0(4) WA_DOWN-BUDAT_MKPF+4(2) WA_DOWN-BUDAT_MKPF+6(2)
*                      INTO WA_DOWN-BUDAT_MKPF SEPARATED BY '.'.
*BREAK-POINT.
WA_DOWN-BUDAT_MKPF = wa_final-lv_budat.

*        WA_DOWN-BUDAT_MKPF = WA_FINAL-BUDAT_MKPF.

      WA_DOWN-LIFNR         = WA_FINAL-LIFNR        .
      WA_DOWN-NAME1         = WA_FINAL-NAME1        .
      WA_DOWN-XBLNR_MKPF    = WA_FINAL-XBLNR_MKPF   .
*      WA_DOWN-BLDAT         = WA_FINAL-BLDAT        .

*       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            INPUT  = WA_FINAL-BLDAT
*          IMPORTING
*            OUTPUT = WA_DOWN-BLDAT.
*
*        CONCATENATE WA_DOWN-BLDAT+0(2) WA_DOWN-BLDAT+2(3) WA_DOWN-BLDAT+5(4)
*                        INTO WA_DOWN-BLDAT SEPARATED BY '-'.

WA_DOWN-BLDAT = WA_FINAL-LV_BLDAT.

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

*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            INPUT  = WA_FINAL-EINDT
*          IMPORTING
*            OUTPUT = WA_DOWN-EINDT.
*
*        CONCATENATE WA_DOWN-EINDT+0(2) WA_DOWN-EINDT+2(3) WA_DOWN-EINDT+5(4)
*                        INTO WA_DOWN-EINDT SEPARATED BY '-'.

        WA_DOWN-EINDT = WA_FINAL-LV_EINDT.


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

*****************************************  ,added by shreya ***********************
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          INPUT  = SY-DATUM
*        IMPORTING
*          OUTPUT = WA_DOWN-REF_DAT.

      CONCATENATE SY-DATUM+4(2) SY-DATUM+6(2) SY-DATUM+0(4)
      INTO WA_DOWN-REF_DAT SEPARATED BY '.'.

      WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

      WA_DOWN-PER1           = WA_FINAL-PER1        .
***********************    ,added by shreya*****************

      APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_FINAL.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&----------------------  -----------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT .
  PERFORM FCAT USING :   '1'   'MBLNR'                'IT_FINAL'      'Mat. Doc.'                     '20' ,
*                        '2'   'BUDAT_MKPF'           'IT_FINAL'      'Posting Date'                  '10' ,
                         '2'   'lv_budat'             'IT_FINAL'      'Posting Date'                  '10' ,
                         '3'   'LIFNR'                'IT_FINAL'      'Vendor Code'                   '15' ,
                         '4'   'NAME1'                'IT_FINAL'      'Vendor Name'                   '15' ,
                         '5'   'XBLNR_MKPF'           'IT_FINAL'      'Reference'                     '15' ,
*                        '6'   'BLDAT'                'IT_FINAL'      'Doc. Date'                     '15' ,
                         '6'   'LV_bldat'             'IT_FINAL'      'Doc. Date'                     '15' ,
                         '7'   'BKTXT'                'IT_FINAL'      'Doc.Header Text'               '15' ,
                         '8'   'MATNR'                'IT_FINAL'      'Material'                      '15' ,
                         '9'   'MATTXT'               'IT_FINAL'      'Material Des'                  '15' ,
                        '10'   'GRN_QTY'              'IT_FINAL'      'GRN Quantity'                  '15' ,
                        '11'   'MENGE'                'IT_FINAL'      'PO Quantity'                   '15' ,
                        '12'   'BWART'                'IT_FINAL'      'Mov.Type'                      '15' ,
                        '13'   'MEINS'                'IT_FINAL'      'UOM'                           '15' ,
                        '14'   'ABLAD'                'IT_FINAL'      'Unloading Point'               '15' ,
                        '15'   'EBELN'                'IT_FINAL'      'PO No'                         '15' ,
                        '16'   'EBELP'                'IT_FINAL'      'PO Line Item'                  '15' ,
                        '17'   'AEDAT'                'IT_FINAL'      'PO Date'                       '15' ,
*                       '18'   'EINDT'                'IT_FINAL'      'PO Del Date'                   '15' ,
                        '18'   'LV_eindt'             'IT_FINAL'      'PO Del Date'                   '15' ,
                        '19'   'PER'                  'IT_FINAL'      'Delivery Rating(Posting Date)' '30' ,  "
                        '20'   'ZSERIES'              'IT_FINAL'      'Series'                        '15' ,
                        '21'   'ZSIZE'                'IT_FINAL'      'Size'                          '15' ,
                        '22'   'BRAND'                'IT_FINAL'      'Brand'                         '15' ,
                        '23'   'MOC'                  'IT_FINAL'      'MOC'                           '15' ,
                        '24'   'TYPE'                 'IT_FINAL'      'TYPE'                          '15' ,
                        '25'   'WKURS'                'IT_FINAL'      'Exchange Rate'                 '13' ,
                        '26'   'UNIT_RATE'            'IT_FINAL'      'Unit Rate in USD'              '13' ,
                        '27'   'DMBTR'                'IT_FINAL'      'Total Basic Value in USD'      '13' ,
                        '28'   'ZPFL'                 'IT_FINAL'      'P&F charges in USD'            '13' ,
                        '29'   'ZINS'                 'IT_FINAL'      'Inspection Charges in USD'     '13' ,
                        '30'   'ZSCV'                 'IT_FINAL'      'Setting Charges in USD'        '13' ,
                        '31'   'ZDVV'                 'IT_FINAL'      'Development charges in USD'    '13' ,
                        '32'   'ZRB1'                 'IT_FINAL'      'Freight Charges in USD'        '13' ,
                        '33'   'ZOCQ'                 'IT_FINAL'      'Other Charges in USD'          '13' ,
                        '34'   'JCDB'                 'IT_FINAL'      'Basic Custom Duty in USD'      '13' ,
                        '35'   'ZSWS'                 'IT_FINAL'      'Social Welfare Cess in USD'    '13' ,
                        '36'   'LAND_COST_TOT'        'IT_FINAL'      'Landed Cost  in USD'           '13' ,
                        '37'   'BSART'                'IT_FINAL'      'PO Type'                       '4' ,
                        '38'   'EKGRP'                'IT_FINAL'      'Purchasing Group'              '3' ,
                        '39'   'INFNR'                'IT_FINAL'      'INFO Record'                   '10' ,
                        '40'   'URZZT'                'IT_FINAL'      'Casting Weight'                '16' ,
                        '41'   'PER1'                 'IT_FINAL'      'Delivery Rating(Document Date)' '30' . "Added by Nilay B. 12.01.2024



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
  LV_FILE =   'ZUS_DELIVERY_PERFORMANCE.TXT'.
*BREAK primus.
*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'DELIVERY PERFORM REPORT Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1007 TYPE string.
DATA lv_crlf_1007 TYPE string.
lv_crlf_1007 = cl_abap_char_utilities=>cr_lf.
lv_string_1007 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1007 lv_crlf_1007 wa_csv INTO lv_string_1007.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1495 TO lv_fullfile.
TRANSFER lv_string_1007 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
ENDFORM.

FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Refreshed On Date'   "add by supriya
              'Mat. Doc.'
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
              'Unit Rate in USD'
              'Total Basic Value in USD'
              'P&F charges in USD'
              'Inspection Charges in USD'
              'Setting Charges in USD'
              'Development charges in USD'
              'Freight Charges in USD'
              'Other Charges in USD'
              'Basic Custom Duty in USD'
              'Social Welfare Cess in USD'
              'Landed Cost  in USD'
              'PO Type'
              'Purchasing Group'
              'INFO Record'
              'Casting Weight'
*              'Refreshed On Date'
              'Ref Time'
              'Delivery Rating(Document Date)'  "Added By Nilay on 12.01.2024
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
