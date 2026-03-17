*&---------------------------------------------------------------------*
*& Report ZUS_DEL_PER_INVN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_DEL_PER_INVN.


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
         VBELN_IM   TYPE MSEG-VBELN_IM,
       END OF TY_MSEG,


       BEGIN OF TY_MSEG_N,   ""PR
         EBELN      TYPE MSEG-EBELN,
         EBELP      TYPE MSEG-EBELP,
         BWART      TYPE MSEG-BWART,
         BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
         VBELN_IM   TYPE MSEG-VBELN_IM,
       END OF TY_MSEG_N,

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
         BUDAT TYPE MKPF-BUDAT,
         XBLNR TYPE MKPF-XBLNR, ""aDDED BY PRANIT 25.06.2024
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

       BEGIN OF TY_EKKO_N,
         EBELN TYPE EKKO-EBELN,
*         EBelp TYPE EKKO-EBelp, "Avinash
         AEDAT TYPE EKKO-AEDAT,
         LIFNR TYPE EKKO-LIFNR,
         WKURS TYPE EKKO-WKURS, "Avinash
         KNUMV TYPE EKKO-KNUMV, "Avinash
         BSART TYPE EKKO-BSART, "Avinash
         EKGRP TYPE EKKO-EKGRP, "Avinash
       END OF TY_EKKO_N,

       BEGIN OF TY_VBAK_N,
         BSTNK TYPE VBAK-BSTNK,
         VBELN TYPE VBAK-VBELN,
       END OF TY_VBAK_N,

       BEGIN OF TY_VBFA,
         VBELV   TYPE VBFA-VBELV,
         VBELN   TYPE VBFA-VBELN,
         VBTYP_N TYPE VBFA-VBTYP_N,
       END OF TY_VBFA,

       BEGIN OF TY_VBFA_N,
         VBELN TYPE VBRK-VBELN,
         FKDAT TYPE VBRK-FKDAT,
       END OF TY_VBFA_N,


       BEGIN OF TY_EKPO,
         EBELN TYPE EKPO-EBELN,
         EBELP TYPE EKPO-EBELP,
         MATNR TYPE EKPO-MATNR,
         MENGE TYPE EKPO-MENGE,
         INFNR TYPE EKPO-INFNR,
         NETPR TYPE EKPO-NETPR,     """Added by Pranit 20.03.2024
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

       BEGIN OF   TY_VBAP,
         VBELN TYPE VBAP-VBELN,
         POSNR TYPE VBAP-POSNR,
         MATNR TYPE VBAP-MATNR,
*         flag1 TYPE char1,
       END OF TY_VBAP,

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
         KWERT TYPE prcd_elements-KWERT,
         KBETR TYPE prcd_elements-KBETR,
       END OF TY_KONV,

**********************ADDED BY 01.04.2024
       BEGIN OF TY_BSTNK,
         BSTNK TYPE BSTNK,
       END OF TY_BSTNK,

******************************************


****End of Avinash*****
       BEGIN OF TY_FINAL,
         MBLNR         TYPE MSEG-MBLNR,
         BUDAT_MKPF    TYPE MSEG-BUDAT_MKPF,
         LV_BUDAT      TYPE CHAR10,
         LV_FKDAT      TYPE CHAR10,
*         BUDAT_MKPF    TYPE CHAR15,
         LIFNR         TYPE MSEG-LIFNR,
         NAME1         TYPE LFA1-NAME1,
         XBLNR_MKPF    TYPE MSEG-XBLNR_MKPF,
         BLDAT         TYPE MKPF-BLDAT,
         LV_BLDAT      TYPE CHAR10,
         BKTXT         TYPE MKPF-BKTXT,
         BUDAT         TYPE MKPF-BUDAT,
         MATNR         TYPE MSEG-MATNR,
         MATTXT        TYPE TEXT255,
         GRN_QTY       TYPE MSEG-MENGE,
         MENGE         TYPE EKPO-MENGE,
         BWART         TYPE MSEG-BWART,
         MEINS         TYPE MSEG-MEINS,
         ABLAD         TYPE MSEG-ABLAD,
         EBELN         TYPE MSEG-EBELN,
         EBELP         TYPE MSEG-EBELP,
         AEDAT         TYPE CHAR10,
         GV_AEDAT      TYPE CHAR10,
         LV_AEDAT      TYPE CHAR11,
         LV_EINDT      TYPE CHAR10,
         EINDT         TYPE EKET-EINDT,
         PER           TYPE CHAR10,
         PER1          TYPE CHAR10,
         ZSERIES       TYPE MARA-ZSERIES,
         ZSIZE         TYPE MARA-ZSIZE,
         BRAND         TYPE MARA-BRAND,
         MOC           TYPE MARA-MOC,
         TYPE          TYPE MARA-TYPE,
         WKURS         TYPE EKKO-WKURS, "Avinash
         UNIT_RATE     TYPE prcd_elements-KWERT,
*         unit_rate     TYPE C,
         DMBTR         TYPE MSEG-DMBTR,
*         dmbtr         TYPE C,
         ZPFL          TYPE prcd_elements-KWERT,
         ZPFV          TYPE prcd_elements-KWERT,   ""Added by Pranit 11.04.2024
         ZSCQ          TYPE prcd_elements-KWERT,   ""Added by Pranit 11.04.2024
         LV_PF         TYPE prcd_elements-KWERT,   ""Added by Pranit 11.04.2024
         LV_ZSCQ       TYPE prcd_elements-KWERT,   ""Added by Pranit 11.04.2024
         LV_FREIGHT    TYPE prcd_elements-KWERT,   ""Added by Pranit 11.04.2024
         LV_DEV        TYPE prcd_elements-KWERT,   ""Added by Pranit 11.04.2024
         LV_OTH        TYPE prcd_elements-KWERT,   ""Added by Pranit 11.04.2024
         ZINS          TYPE prcd_elements-KWERT,
         ZSCV          TYPE prcd_elements-KWERT,
         ZDVV          TYPE prcd_elements-KWERT,
         ZDVQ          TYPE prcd_elements-KWERT,
         ZRB1          TYPE prcd_elements-KWERT,
         ZRC1          TYPE prcd_elements-KWERT, ""Added by Pranit 11.04.2024
         ZOCQ          TYPE prcd_elements-KWERT,
         ZOCV          TYPE prcd_elements-KWERT,
         JCDB          TYPE prcd_elements-KWERT,
         ZSWS          TYPE prcd_elements-KWERT,
         LAND_COST_TOT TYPE prcd_elements-KWERT,
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
         NETPR         TYPE EKPO-NETPR,  """Added by Pranit 20.03.2024
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
         FKDAT         TYPE CHAR10, "vbrk-fkdat,
         TEXT_N        TYPE CHAR250,
         SHIPP         TYPE CHAR250,
         XBLNR         TYPE MKPF-XBLNR,   ""ADDED BY pRANIT 25.06.2024
         VBELN         TYPE VBAK-VBELN,   ""ADDED BY pRANIT 25.06.2024
         POSNR         TYPE VBAP-POSNR,   ""ADDED BY pRANIT 25.06.2024
         VBELN_IM      TYPE MSEG-VBELN_IM,   "added by jyoti 25.06.2024
         VBELN1        TYPE VBFA-VBELN,
         KBETR         TYPE prcd_elements-KBETR,
         KWERT         TYPE prcd_elements-KWERT,
         FLAG          TYPE CHAR1,
       END OF TY_FINAL,

       BEGIN OF TY_FINAL1,
         REF_DAT       TYPE CHAR15,     " ADDED BY SUPRIYA
         MBLNR         TYPE MSEG-MBLNR,
         FKDAT         TYPE CHAR15,
         LIFNR         TYPE MSEG-LIFNR,
         NAME1         TYPE LFA1-NAME1,
         XBLNR_MKPF    TYPE MSEG-XBLNR_MKPF,
         BUDAT         TYPE CHAR15,
         BKTXT         TYPE MKPF-BKTXT,
         MATNR         TYPE MSEG-MATNR,
         MATTXT        TYPE TEXT255,
         GRN_QTY       TYPE STRING,
         MENGE         TYPE STRING,
         BWART         TYPE MSEG-BWART,
         MEINS         TYPE MSEG-MEINS,
*         ablad         TYPE mseg-ablad,
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
*         netpr         TYPE ekpo-netpr,      """Added by Pranit 20.03.2024
         WKURS         TYPE EKKO-WKURS, "Avinash
         UNIT_RATE     TYPE STRING,
         DMBTR         TYPE STRING,
         ZPFL          TYPE STRING,
         ZINS          TYPE STRING,
         ZSCV          TYPE STRING,
         ZDVV          TYPE STRING,
         ZRB1          TYPE STRING,
         ZOCQ          TYPE STRING,
*         jcdb          TYPE string,
*         zsws          TYPE string,
         LAND_COST_TOT TYPE STRING,
         BSART         TYPE EKKO-BSART, "Avinash
         EKGRP         TYPE EKKO-EKGRP, "Avinash
         INFNR         TYPE EKPO-INFNR,
         URZZT         TYPE EINA-URZZT,
         PER1          TYPE CHAR10,            "added by Nilay B. 12.01.2024
         TEXT_N        TYPE CHAR250,
         SHIPP         TYPE CHAR250,
*         REF_DAT       TYPE CHAR15,        " COMMENTED BY SUPRIYA
         REF_TIME      TYPE CHAR15,
         XBLNR         TYPE MKPF-XBLNR,
         VBELN         TYPE VBAK-VBELN,
         POSNR         TYPE VBAP-POSNR,
         VBELN_IM      TYPE MSEG-VBELN_IM,
         VBELN1        TYPE VBFA-VBELN,
         KBETR         TYPE prcd_elements-KBETR,
         KWERT         TYPE prcd_elements-KWERT,
       END OF TY_FINAL1,

       BEGIN OF TY_LIPS,                      " ADDED BY PM ON 27.06.2024
         VBELN TYPE LIPS-VBELN,
         MATNR TYPE LIPS-MATNR,
         VGBEL TYPE LIPS-VGBEL,
         VGPOS TYPE LIPS-VGPOS,
       END OF TY_LIPS.                         " ADDED BY PM ON 27.06.2024


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

       IT_VBAP   TYPE TABLE OF TY_VBAP,
       WA_VBAP   TYPE          TY_VBAP,

       IT_MSEG_N TYPE TABLE OF TY_MSEG_N,
       WA_MSEG_N TYPE          TY_MSEG_N,

       IT_101    TYPE TABLE OF TY_MSEG,
       WA_101    TYPE          TY_MSEG,

       IT_RETURN TYPE TABLE OF TY_RETURN,
       WA_RETURN TYPE          TY_RETURN,

       IT_EKKO   TYPE TABLE OF TY_EKKO,
       WA_EKKO   TYPE          TY_EKKO,


       IT_EKKO_N TYPE TABLE OF TY_EKKO_N,
       WA_EKKO_N TYPE          TY_EKKO_N,

       IT_VBAK_N TYPE TABLE OF TY_VBAK_N,
       WA_VBAK_N TYPE          TY_VBAK_N,


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

       IT_BSTNK  TYPE TABLE OF TY_BSTNK,
       WA_BSTNK  TYPE          TY_BSTNK,

       IT_VBFA   TYPE TABLE OF TY_VBFA,
       WA_VBFA   TYPE          TY_VBFA,

       IT_VBFA_N TYPE TABLE OF TY_VBFA_N,
       WA_VBFA_N TYPE          TY_VBFA_N,

       IT_LIPS   TYPE TABLE OF TY_LIPS,                                           " ADDED BY PM ON 27.06.2024
       WA_LIPS   TYPE          TY_LIPS.                                           " ADDED BY PM ON 27.06.2024


DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: LV_NAME  TYPE THEAD-TDNAME,
      LV_LINES TYPE STANDARD TABLE OF TLINE,
      WA_LINES LIKE TLINE.

SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_EBELN FOR MSEG-EBELN,
                S_MATNR FOR MSEG-MATNR,
                S_DATE  FOR MSEG-BUDAT_MKPF OBLIGATORY,
                S_BLDAT FOR MKPF-BLDAT,  "added By Nilay B. on 15.01.2024
                P_WERKS FOR MSEG-WERKS OBLIGATORY.
*                s_lifnr FOR mseg-lifnr OBLIGATORY NO INTERVALS DEFAULT '1100000' MODIF ID new,
PARAMETERS:         S_LIFNR TYPE MSEG-LIFNR DEFAULT '0001100000' MODIF ID NEW.
*PARAMETERS :    p_werks TYPE mseg-werks MATCHCODE OBJECT zsh_del_per_n .
"MATCHCODE OBJECT zsh_del_per_n . "OBLIGATORY DEFAULT 'PL01' MODIF ID BU
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/USA'."USA'."USA'.   "'E:\delval\USA'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT. " ADDED BY NB on 15.01.2024
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'NEW'.
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
         BKTXT
         BUDAT FROM MKPF INTO TABLE IT_MKPF
         WHERE BLDAT IN S_BLDAT
         AND   BUDAT IN S_DATE.

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
           VBELN_IM
          FROM MSEG INTO TABLE IT_MSEG
*           FOR ALL ENTRIES IN it_mkpf
           WHERE EBELN IN S_EBELN
             AND MATNR IN S_MATNR
             AND BUDAT_MKPF IN S_DATE
             AND WERKS IN P_WERKS
             AND BWART IN ('103','104', '105','106')
              AND LIFNR EQ S_LIFNR.
*           AND EBELN NE ' '
**             AND mjahr = it_mkpf-mjahr
**             AND mblnr = it_mkpf-mblnr  .

    SELECT EBELN
           EBELP
           BWART
           BUDAT_MKPF
           VBELN_IM
      FROM MSEG
      INTO TABLE IT_MSEG_N
        FOR ALL ENTRIES IN IT_MKPF
     WHERE EBELN IN S_EBELN
       AND MATNR IN S_MATNR
       AND BUDAT_MKPF IN S_DATE
       AND WERKS IN P_WERKS
       AND BWART IN ('103', '105')
        AND LIFNR EQ S_LIFNR
*     AND EBELN NE ' '
       AND MJAHR = IT_MKPF-MJAHR
       AND MBLNR = IT_MKPF-MBLNR  .
*
*      DATA : LV_SMBLN TYPE MSEG-SMBLN.
*      READ TABLE it_mseg INTO WA_MSEG WITH KEY BWART = '104'
*      LV_SMBLN = WA_MSEG-smbln.

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
           BKTXT
           BUDAT
           XBLNR      FROM MKPF INTO TABLE IT_MKPF
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
           WHERE EBELN = IT_MSEG-EBELN .
*    BREAK-POINT.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""LOGIC FOR POSTING DATE IN INDIA VENDOR
    SELECT EBELN
     AEDAT
     LIFNR
     WKURS
     KNUMV
     BSART
     EKGRP
     FROM EKKO INTO TABLE IT_EKKO_N
     FOR ALL ENTRIES IN IT_MSEG
     WHERE EBELN = IT_MSEG-EBELN
     AND BSART EQ 'UIDV'.

    LOOP AT IT_EKKO_N INTO DATA(WA_EKKO_N).

      MOVE WA_EKKO_N-EBELN TO WA_BSTNK-BSTNK.

      APPEND WA_BSTNK TO IT_BSTNK.
      CLEAR : WA_BSTNK , WA_EKKO_N.

    ENDLOOP.

    SELECT BSTNK
               VBELN FROM VBAK INTO TABLE   IT_VBAK_N
               FOR ALL ENTRIES IN IT_BSTNK
               WHERE BSTNK =  IT_BSTNK-BSTNK.

    SELECT VBELN POSNR MATNR FROM VBAP INTO CORRESPONDING FIELDS OF TABLE IT_VBAP
      FOR ALL ENTRIES IN IT_VBAK_N
      WHERE VBELN = IT_VBAK_N-VBELN.

    SELECT VBELV
           VBELN
           VBTYP_N
      FROM VBFA INTO TABLE IT_VBFA
      FOR ALL ENTRIES IN IT_VBAK_N
      WHERE VBELV = IT_VBAK_N-VBELN
      AND  VBTYP_N EQ 'M'.

    SELECT VBELN
           FKDAT
      FROM VBRK
      INTO TABLE IT_VBFA_N
      FOR ALL ENTRIES IN IT_VBFA
      WHERE VBELN = IT_VBFA-VBELN.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  ENDIF.
  IF IT_EKKO IS NOT INITIAL.
    SELECT
      KNUMV
      KPOSN
      KSCHL
      KWERT
      KBETR
      FROM prcd_elements INTO TABLE IT_KONV
      FOR ALL ENTRIES IN IT_EKKO
      WHERE KNUMV = IT_EKKO-KNUMV AND KSCHL IN ('ZPFL', 'ZINS', 'ZSCV','ZSCQ', 'ZDVV','ZDVQ', 'ZRB1','ZRC1','ZRC1', 'ZOCQ','ZOCV','ZOC%', 'JCDB', 'ZSWS','ZPFV','R000')."and kpson = it_ekko-ebelp.
    DELETE IT_KONV WHERE KWERT = SPACE.
  ENDIF.

  IF IT_MSEG IS NOT INITIAL.
    SELECT EBELN
           EBELP
           MATNR
           MENGE
           INFNR
           NETPR     """Added by Pranit 20.03.2024
           FROM EKPO INTO TABLE IT_EKPO
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

  "------------SOC BY PM ON 27.06.2024 LOGIC AKHILESH  FOR POSNR-------------"
  SELECT VBELN
         MATNR
         VGBEL
         VGPOS
     FROM LIPS INTO CORRESPONDING FIELDS OF TABLE IT_LIPS
     FOR ALL ENTRIES IN IT_MKPF
*       WHERE MATNR = IT_MSEG-MATNR
*       AND VGBEL = IT_MSEG-VGBEL
     WHERE VBELN = IT_MKPF-XBLNR+0(10).
*  ------------EOC BY PM ON 27.06.2024 LOGIC AKHILESH  FOR POSNR-------------"

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
*  DATA : lv_pf TYPE char10.
  LOOP AT IT_MSEG INTO WA_MSEG.
    READ TABLE IT_RETURN INTO WA_RETURN WITH KEY SMBLN = WA_MSEG-MBLNR.
*    IF sy-subrc = 4.

    WA_FINAL-MBLNR      = WA_MSEG-MBLNR.
    WA_FINAL-MEINS      = WA_MSEG-MEINS.
*    wa_final-ablad      = wa_mseg-ablad.
*      wa_final-dmbtr      = wa_mseg-dmbtr.
    WA_FINAL-BWART      = WA_MSEG-BWART.
    WA_FINAL-GRN_QTY    = WA_MSEG-MENGE.
    WA_FINAL-BUDAT_MKPF = WA_MSEG-BUDAT_MKPF.
    WA_FINAL-XBLNR_MKPF = WA_MSEG-XBLNR_MKPF.
    WA_FINAL-VBELN_IM = WA_MSEG-VBELN_IM."added by pranit

*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          INPUT  = WA_MSEG-BUDAT_MKPF
*        IMPORTING
*          OUTPUT = WA_FINAL-BUDAT_MKPF.
    DATA LV_BUDAT TYPE CHAR10.                                                                      """Added by Pranit 04.03.2024
    CONCATENATE WA_MSEG-BUDAT_MKPF+4(2) WA_MSEG-BUDAT_MKPF+6(2) WA_MSEG-BUDAT_MKPF+0(4)
                    INTO LV_BUDAT SEPARATED BY '.'.

    WA_FINAL-LV_BUDAT = LV_BUDAT.                                                                    """Ended by Pranit 04.03.2024

    READ TABLE IT_MKPF INTO WA_MKPF WITH KEY MBLNR = WA_MSEG-MBLNR.
    IF SY-SUBRC = 0 .
      WA_FINAL-BKTXT = WA_MKPF-BKTXT.
      WA_FINAL-BUDAT = WA_MKPF-BUDAT.
      WA_FINAL-XBLNR = WA_MKPF-XBLNR.                                                          """aDDED BY PRANIT 25.06.2024


      DATA LV_BLDAT TYPE CHAR10.                                                               """Added by Pranit 04.03.2024
      CONCATENATE WA_MKPF-BUDAT+4(2) WA_MKPF-BUDAT+6(2) WA_MKPF-BUDAT+0(4)
                      INTO LV_BLDAT SEPARATED BY '.'.

      WA_FINAL-LV_BLDAT = LV_BLDAT.

    ENDIF.

    READ TABLE IT_EKKO INTO WA_EKKO WITH KEY EBELN = WA_MSEG-EBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-EBELN = WA_EKKO-EBELN.
      WA_FINAL-LIFNR = WA_EKKO-LIFNR.
      WA_FINAL-AEDAT = WA_EKKO-AEDAT.
      WA_FINAL-GV_AEDAT = WA_FINAL-AEDAT.

      CONCATENATE WA_FINAL-AEDAT+4(2) WA_FINAL-AEDAT+6(2) WA_FINAL-AEDAT+0(4)
                      INTO WA_FINAL-AEDAT SEPARATED BY '.'.

      READ TABLE IT_EKKO_N INTO WA_EKKO_N WITH KEY EBELN = WA_FINAL-EBELN.
      IF SY-SUBRC IS INITIAL.
        READ TABLE IT_BSTNK INTO WA_BSTNK WITH KEY BSTNK = WA_EKKO_N-EBELN  .
        IF SY-SUBRC IS INITIAL.
          READ TABLE  IT_VBAK_N INTO WA_VBAK_N WITH KEY BSTNK = WA_BSTNK-BSTNK.
          WA_FINAL-VBELN = WA_VBAK_N-VBELN.
          IF SY-SUBRC IS INITIAL.
            READ TABLE IT_VBFA INTO WA_VBFA WITH KEY VBELV = WA_VBAK_N-VBELN.
            IF SY-SUBRC IS INITIAL.
              WA_FINAL-VBELN1 = WA_VBFA-VBELN.
              READ TABLE IT_VBFA_N INTO  WA_VBFA_N WITH KEY VBELN = WA_VBFA-VBELN.
              IF SY-SUBRC IS INITIAL.
                WA_FINAL-FKDAT = WA_VBFA_N-FKDAT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      READ TABLE IT_MSEG_N INTO WA_MSEG_N WITH KEY EBELN = WA_FINAL-EBELN.
      WA_FINAL-BLDAT = WA_MSEG_N-BUDAT_MKPF.

      WA_FINAL-LV_FKDAT =  WA_FINAL-FKDAT.
      IF WA_FINAL-FKDAT IS NOT INITIAL.
        CONCATENATE WA_FINAL-FKDAT+4(2) WA_FINAL-FKDAT+6(2) WA_FINAL-FKDAT+0(4)
                        INTO WA_FINAL-FKDAT SEPARATED BY '.'.
      ENDIF.

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
      WA_FINAL-NETPR = WA_EKPO-NETPR.       """Added by Pranit 20.03.2024
    ENDIF.

    IF  WA_FINAL-INFNR IS NOT INITIAL.
      SELECT SINGLE URZZT FROM EINA INTO WA_FINAL-URZZT WHERE INFNR = WA_FINAL-INFNR.
    ENDIF.
*    wa_final-unit_rate = wa_final-ablad * wa_final-wkurs.  """Commented by Pranit 10.04.2024
    WA_FINAL-UNIT_RATE = WA_EKPO-NETPR.                     """Added by Pranit 10.04.2024
    WA_FINAL-DMBTR      = WA_FINAL-GRN_QTY * WA_FINAL-UNIT_RATE.
*    BREAK-POINT.
    LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_EKKO-KNUMV AND KPOSN = WA_FINAL-EBELP.
      CASE WA_KONV-KSCHL.
        WHEN 'ZPFL'.
          WA_FINAL-ZPFL = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZPFV'.                                                                                            ""Added by pranit 11.04.2024
          WA_FINAL-ZPFV = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZINS'.
          WA_FINAL-ZINS = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZSCV'.
          WA_FINAL-ZSCV = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZSCQ'.                                                                                              ""ADDED BY PRANIT 11.04.2024
          WA_FINAL-ZSCQ = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZDVV'.
          WA_FINAL-ZDVV = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZDVQ'.
          WA_FINAL-ZDVQ = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZRB1'.
          WA_FINAL-ZRB1 = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZRC1'.
          WA_FINAL-ZRC1 = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZOCQ'.
          WA_FINAL-ZOCQ = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZOCV'.
          WA_FINAL-ZOCV = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
        WHEN 'ZOC%'.
          WA_FINAL-ZOCV = ( ( WA_KONV-KWERT * WA_FINAL-WKURS ) / WA_FINAL-MENGE ) * WA_FINAL-GRN_QTY.
*        WHEN 'JCDB'.
*          wa_final-jcdb = ( ( wa_konv-kwert * wa_final-wkurs ) / wa_final-menge ) * wa_final-grn_qty.
*        WHEN 'ZSWS'.
*          wa_final-zsws = ( ( wa_konv-kwert * wa_final-wkurs ) / wa_final-menge ) * wa_final-grn_qty.
      ENDCASE.
      CLEAR WA_KONV.
    ENDLOOP.

    """for P&F charges
    IF WA_FINAL-ZPFL IS NOT INITIAL.  "'Added by Pranit 11.04.2024
      WA_FINAL-LV_PF = WA_FINAL-ZPFL.
    ELSE.
      WA_FINAL-LV_PF = WA_FINAL-ZPFV.
    ENDIF.

    """for Setting charge
    IF WA_FINAL-ZSCV IS NOT INITIAL.  "'Added by Pranit 11.04.2024
      WA_FINAL-LV_ZSCQ = WA_FINAL-ZSCV.
    ELSE.
      WA_FINAL-LV_ZSCQ = WA_FINAL-ZSCQ.
    ENDIF.

    """"for freight charge
    IF WA_FINAL-ZRC1 IS NOT INITIAL.  "'Added by Pranit 11.04.2024
      WA_FINAL-LV_FREIGHT = WA_FINAL-ZRC1.
    ELSE.
      WA_FINAL-LV_FREIGHT = WA_FINAL-ZRB1.
    ENDIF.

    """"for Other charges
    IF WA_FINAL-ZOCV IS NOT INITIAL.  "'Added by Pranit 11.04.2024
      WA_FINAL-LV_OTH = WA_FINAL-ZOCV.
    ELSE.
      WA_FINAL-LV_OTH = WA_FINAL-ZOCQ.
    ENDIF.

    """"for Devlopment charges
    IF WA_FINAL-ZDVQ IS NOT INITIAL.  "'Added by Pranit 11.04.2024
      WA_FINAL-LV_DEV = WA_FINAL-ZDVQ.
    ELSE.
      WA_FINAL-LV_DEV = WA_FINAL-ZDVV.
    ENDIF.

    READ TABLE IT_KONV INTO WA_KONV WITH KEY KPOSN = WA_MSEG-EBELP.
    IF SY-SUBRC = 0.
      WA_FINAL-KBETR = WA_KONV-KBETR / -10 .
      WA_FINAL-KWERT = WA_KONV-KWERT.
    ENDIF.

    WA_FINAL-LAND_COST_TOT = WA_FINAL-DMBTR + WA_FINAL-ZPFL + WA_FINAL-ZPFV + WA_FINAL-ZINS + WA_FINAL-ZSCV + WA_FINAL-ZSCQ + WA_FINAL-ZDVV + WA_FINAL-ZRB1 + WA_FINAL-ZRC1
   + WA_FINAL-ZDVQ + WA_FINAL-ZOCQ + WA_FINAL-ZOCV + WA_FINAL-JCDB + WA_FINAL-KWERT ."+ wa_final-unit_rate.

    IF WA_FINAL-LAND_COST_TOT LT 0 .

      WA_FINAL-LAND_COST_TOT = - WA_FINAL-LAND_COST_TOT.


    ENDIF.

    READ TABLE IT_EKET INTO WA_EKET WITH KEY EBELN = WA_FINAL-EBELN EBELP = WA_FINAL-EBELP.
    IF SY-SUBRC = 0.

      WA_FINAL-EINDT = WA_EKET-EINDT.

      DATA LV_EINDT TYPE CHAR10.                                                               """Added by Pranit 04.03.2024
      CONCATENATE WA_EKET-EINDT+4(2) WA_EKET-EINDT+6(2) WA_EKET-EINDT+0(4)
                      INTO LV_EINDT SEPARATED BY '.'.

      WA_FINAL-LV_EINDT = LV_EINDT.
    ENDIF.


    READ TABLE IT_VBAP INTO WA_VBAP WITH KEY MATNR = WA_VBAP-MATNR.
    IF  SY-SUBRC = 0.
      WA_FINAL-POSNR = WA_VBAP-POSNR.
    ENDIF.

    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_FINAL-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-ZSERIES   = WA_MARA-ZSERIES  .
      WA_FINAL-ZSIZE     = WA_MARA-ZSIZE    .
      WA_FINAL-BRAND     = WA_MARA-BRAND    .
      WA_FINAL-MOC       = WA_MARA-MOC      .
      WA_FINAL-TYPE      = WA_MARA-TYPE     .


    ENDIF.
**      IF wa_final-budat_mkpf LE  wa_final-eindt.
*        wa_final-per = '100'.
*      ELSE.
*        wa_final-per = '0'.
*      ENDIF.

    IF WA_FINAL-LV_BLDAT LE  WA_FINAL-LV_EINDT.
      WA_FINAL-PER1 = '100'.
    ELSE.
      WA_FINAL-PER1 = '0'.
    ENDIF.

******added by pranit on 01.04.2024*********************
*BREAK primus.
    IF WA_FINAL-FKDAT IS NOT INITIAL.
*  if wa_final-fkdat gt lv_eindt.
*      wa_final-per1 = '0'.
*  elseif wa_final-fkdat LE lv_eindt.
*    wa_final-per1 = '100'.
*  endif.
*        IF wa_final-fkdat LE wa_final-eindt.
*          wa_final-per = '100'.
*        ELSE.
*          wa_final-per = '0'.
*        ENDIF.

      IF  WA_FINAL-LV_EINDT LE WA_FINAL-FKDAT.
        WA_FINAL-PER = '0'.
      ENDIF.
      IF WA_FINAL-LV_EINDT GE WA_FINAL-FKDAT.
        WA_FINAL-PER = '100'.
      ENDIF.

    ENDIF.
***********************************************************



    CLEAR: LV_LINES, LV_NAME,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-MATNR.
    IF LV_NAME IS NOT INITIAL.                  """Added by Pranit 05.02.2024

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

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""for CUstomer details

    CLEAR: LV_LINES, LV_NAME,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_EKKO-EBELN.
    IF LV_NAME IS NOT INITIAL.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'F22'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'EKKO'
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
            WA_FINAL-TEXT_N = WA_LINES-TDLINE.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

*      IF wa_final-bsart EQ 'UIDV' AND wa_final-fkdat IS NOT INITIAL.
*        APPEND wa_final TO it_final.
*      ENDIF.
*      CLEAR:wa_final, wa_vbfa_n,wa_vbfa.


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""for Shipping directly from

    CLEAR: LV_LINES, LV_NAME,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_EKKO-EBELN.
    IF LV_NAME IS NOT INITIAL.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'F29'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'EKKO'
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
            WA_FINAL-SHIPP = WA_LINES-TDLINE.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF WA_FINAL-BSART EQ 'UIDV' AND WA_FINAL-FKDAT IS NOT INITIAL.
      APPEND WA_FINAL TO IT_FINAL.
    ENDIF.
    CLEAR:WA_FINAL, WA_VBFA_N,WA_VBFA.",lv_pf,lv_zscq,lv_freight,lv_oth,lv_dev.


  ENDLOOP.

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  LOOP AT IT_RETURN INTO WA_RETURN .
    DELETE IT_FINAL WHERE MBLNR = WA_RETURN-SMBLN.
  ENDLOOP.

  DELETE IT_FINAL WHERE BWART = 104.
  DELETE IT_FINAL WHERE BWART = 106.
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Pranit 03.04.2024
  DATA FLAG TYPE CHAR1.
*BREAK PRIMUSABAP.
  DATA(IT_LIPS_NEW) = IT_LIPS.
  LOOP AT IT_FINAL INTO WA_FINAL WHERE FLAG NE 'X'.           """""Mon type 103
*    READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN =  WA_FINAL-VBELN MATNR = WA_FINAL-MATNR.
*    READ TABLE IT_LIPS INTO WA_LIPS WITH KEY VBELN =  WA_FINAL-XBLNR+0(10) MATNR = WA_FINAL-MATNR.
    LOOP AT IT_LIPS INTO WA_LIPS WHERE VBELN =  WA_FINAL-XBLNR+0(10) AND MATNR = WA_FINAL-MATNR.

      IF SY-SUBRC = 0.
        WA_FINAL-POSNR =  WA_LIPS-VGPOS.
        WA_FINAL-FLAG = 'X'.
      ENDIF.
      DELETE IT_LIPS WHERE VGPOS  = WA_FINAL-POSNR
                        AND VGBEL = WA_FINAL-XBLNR+0(10)
                        AND MATNR = WA_FINAL-MATNR.


*    DELETE IT_VBAP WHERE POSNR  = WA_FINAL-POSNR
*                      AND VBELN = WA_FINAL-VBELN
*                      AND MATNR = WA_FINAL-MATNR.          .
      MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING FLAG POSNR .
    ENDLOOP.
  ENDLOOP.
  LOOP AT IT_FINAL INTO WA_FINAL WHERE FLAG NE 'X'.
*      READ TABLE IT_LIPS_new INTO DATA(WA_LIPS_new) WITH KEY VBELN =  WA_FINAL-XBLNR+0(10) MATNR = WA_FINAL-MATNR.
    LOOP AT IT_LIPS_NEW INTO DATA(WA_LIPS_NEW) WHERE VBELN =  WA_FINAL-XBLNR+0(10) AND MATNR = WA_FINAL-MATNR.

      IF SY-SUBRC = 0.
        WA_FINAL-POSNR =  WA_LIPS_NEW-VGPOS.
        WA_FINAL-FLAG = 'X'.
      ENDIF.
      DELETE IT_LIPS_NEW WHERE VGPOS  = WA_FINAL-POSNR
                       AND VGBEL = WA_FINAL-XBLNR+0(10)
                       AND MATNR = WA_FINAL-MATNR.
      MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING FLAG POSNR .
    ENDLOOP.
  ENDLOOP.
*  LOOP AT IT_FINAL INTO WA_FINAL WHERE FLAG NE 'X'.           """""Mon type 105
*    READ TABLE IT_VBAP_NEW INTO WA_VBAP WITH KEY VBELN =  WA_FINAL-VBELN MATNR = WA_FINAL-MATNR.
*
*    IF SY-SUBRC = 0.
*      WA_FINAL-POSNR =  WA_VBAP-POSNR.
*      WA_FINAL-FLAG = 'X'.
*    ENDIF.
*
*    DELETE IT_VBAP_NEW WHERE POSNR  = WA_FINAL-POSNR
*                      AND VBELN = WA_FINAL-VBELN
*                      AND MATNR = WA_FINAL-MATNR.          .
*    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING FLAG POSNR .
*  ENDLOOP.

  IF P_DOWN = 'X'.
*    BREAK-POINT.

    LOOP AT IT_FINAL INTO WA_FINAL.
*      *****************************************  ,added by shreya ***********************
** start commented by 102423 0n 08.07.2024

*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          INPUT  = SY-DATUM " yyyymmdd
*        IMPORTING
*          OUTPUT = WA_DOWN-REF_DAT.

*      CONCATENATE WA_DOWN-REF_DAT+0(2) WA_DOWN-REF_DAT+2(3) WA_DOWN-REF_DAT+5(4)
*      INTO WA_DOWN-REF_DAT SEPARATED BY '-'.
** end commented by 102423 0n 08.07.2024

* start of added by 102423 0n 08.07.2024
      IF SY-DATUM IS NOT INITIAL.
        CONCATENATE SY-DATUM+4(2) SY-DATUM+6(2) SY-DATUM+0(4) INTO WA_DOWN-REF_DAT SEPARATED BY '.'.
      ENDIF.
* end of added by 102423 0n 08.07.2024

      WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

      WA_DOWN-PER1          = WA_FINAL-PER1.
      WA_DOWN-MBLNR         = WA_FINAL-MBLNR .
*      WA_DOWN-BUDAT_MKPF    = WA_FINAL-BUDAT_MKPF   .
** start commented by 102423 0n 08.07.2024
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          input  = wa_final-budat_mkpf
*        IMPORTING
*          output = wa_down-budat_mkpf.
*
*      CONCATENATE wa_down-budat_mkpf+0(2) wa_down-budat_mkpf+2(3) wa_down-budat_mkpf+5(4)
*                      INTO wa_down-budat_mkpf SEPARATED BY '-'.
** End commented by 102423 0n 08.07.2024
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          INPUT  = WA_FINAL-LV_FKDAT
*        IMPORTING
*          OUTPUT = WA_DOWN-FKDAT.

*      CONCATENATE WA_DOWN-FKDAT+0(2) WA_DOWN-FKDAT+2(3) WA_DOWN-FKDAT+5(4)
*                      INTO WA_DOWN-FKDAT SEPARATED BY '-'.
******************************************************
* start of added by 102423 0n 08.07.2024
      IF WA_FINAL-LV_FKDAT IS NOT INITIAL.
        CONCATENATE  WA_FINAL-LV_FKDAT+4(2)  WA_FINAL-LV_FKDAT+6(2)  WA_FINAL-LV_FKDAT+0(4) INTO WA_DOWN-FKDAT SEPARATED BY '.'.
      ENDIF.
* end of added by 102423 0n 08.07.2024


      WA_DOWN-LIFNR         = WA_FINAL-LIFNR        .
      WA_DOWN-NAME1         = WA_FINAL-NAME1        .
      WA_DOWN-XBLNR_MKPF    = WA_FINAL-XBLNR_MKPF   .
*      WA_DOWN-BLDAT         = WA_FINAL-BLDAT        .
*BREAK-POINT.
*************************************
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          INPUT  = WA_FINAL-BUDAT
*        IMPORTING
*          OUTPUT = WA_DOWN-BUDAT.

*      CONCATENATE WA_DOWN-BUDAT+0(2) WA_DOWN-BUDAT+2(3) WA_DOWN-BUDAT+5(4)
*                      INTO WA_DOWN-BUDAT SEPARATED BY '-'.
*******************************************
* start of added by 102423 0n 08.07.2024
      IF WA_FINAL-BUDAT IS NOT INITIAL.
        CONCATENATE WA_FINAL-BUDAT+4(2) WA_FINAL-BUDAT+6(2) WA_FINAL-BUDAT+0(4) INTO WA_DOWN-BUDAT SEPARATED BY '.'.
      ENDIF.
* end of added by 102423 0n 08.07.2024


      WA_DOWN-BKTXT         = WA_FINAL-BKTXT        .
      WA_DOWN-MATNR         = WA_FINAL-MATNR        .
      WA_DOWN-MATTXT        = WA_FINAL-MATTXT       .
      WA_DOWN-GRN_QTY       = WA_FINAL-GRN_QTY      .
      WA_DOWN-MENGE         = WA_FINAL-MENGE        .
      WA_DOWN-BWART         = WA_FINAL-BWART        .
      WA_DOWN-MEINS         = WA_FINAL-MEINS        .
*      wa_down-ablad         = wa_final-ablad        .
      WA_DOWN-EBELN         = WA_FINAL-EBELN        .
      WA_DOWN-EBELP         = WA_FINAL-EBELP        .
      WA_DOWN-TEXT_N         = WA_FINAL-TEXT_N        .
      WA_DOWN-SHIPP         = WA_FINAL-SHIPP        .
**************************************************
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'  "addded by jyoti
*        EXPORTING
*          INPUT  = WA_FINAL-GV_AEDAT
*        IMPORTING
*          OUTPUT = WA_DOWN-AEDAT.

*      CONCATENATE WA_DOWN-AEDAT+0(2) WA_DOWN-AEDAT+2(3) WA_DOWN-AEDAT+5(4)
*                      INTO WA_DOWN-AEDAT SEPARATED BY '-'.
*************************************************
* start of added by 102423 0n 08.07.2024
      IF WA_FINAL-GV_AEDAT IS NOT INITIAL.
        CONCATENATE WA_FINAL-GV_AEDAT+4(2) WA_FINAL-GV_AEDAT+6(2) WA_FINAL-GV_AEDAT+0(4) INTO WA_DOWN-AEDAT SEPARATED BY '.'.
      ENDIF.
* end of added by 102423 0n 08.07.2024



*      wa_down-netpr         = wa_final-netpr        .  """Added by Pranit 20.03.2024
*      WA_DOWN-EINDT         = WA_FINAL-EINDT        .
*************************************************************
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          INPUT  = WA_FINAL-WA_FINAL-EINDT
*        IMPORTING
*          OUTPUT = WA_DOWN-EINDT.

*      CONCATENATE WA_DOWN-EINDT+0(2) WA_DOWN-EINDT+2(3) WA_DOWN-EINDT+5(4)
*                      INTO WA_DOWN-EINDT SEPARATED BY '-'.
*****************************************
* start of added by 102423 0n 08.07.2024
      IF WA_FINAL-EINDT IS NOT INITIAL.
        CONCATENATE WA_FINAL-EINDT+4(2) WA_FINAL-EINDT+6(2) WA_FINAL-EINDT+0(4) INTO WA_DOWN-EINDT SEPARATED BY '.'.
      ENDIF.
* end of added by 102423 0n 08.07.2024



      WA_DOWN-PER           = WA_FINAL-PER          .
      WA_DOWN-ZSERIES       = WA_FINAL-ZSERIES      .
      WA_DOWN-ZSIZE         = WA_FINAL-ZSIZE        .
      WA_DOWN-BRAND         = WA_FINAL-BRAND        .
      WA_DOWN-MOC           = WA_FINAL-MOC          .
      WA_DOWN-TYPE          = WA_FINAL-TYPE         .
      WA_DOWN-WKURS         = WA_FINAL-WKURS        .
      WA_DOWN-UNIT_RATE     = WA_FINAL-NETPR        .    """Changed by pranit 10.04.2024
      WA_DOWN-DMBTR         = WA_FINAL-DMBTR        .
*      wa_down-zpfl          = wa_final-zpfl         .
      WA_DOWN-ZPFL          = WA_FINAL-LV_PF         .    """Changed by pranit 10.04.2024
      WA_DOWN-ZINS          = WA_FINAL-ZINS         .
*      wa_down-zscv          = wa_final-zscv         .
      WA_DOWN-ZSCV          = WA_FINAL-LV_ZSCQ      .     """Changed by pranit 10.04.2024
      WA_DOWN-ZDVV          = WA_FINAL-LV_DEV         .
*      wa_down-zdvv          = wa_final-zdvv         .
      WA_DOWN-ZRB1          = WA_FINAL-LV_FREIGHT  .
*      wa_down-zrb1          = wa_final-zrb1         .
      WA_DOWN-ZOCQ          = WA_FINAL-LV_OTH         .
*      wa_down-zocq          = wa_final-zocq         .
*      wa_down-jcdb          = wa_final-jcdb         .
*      wa_down-zsws          = wa_final-zsws         .
      WA_DOWN-LAND_COST_TOT = WA_FINAL-LAND_COST_TOT.
      WA_DOWN-BSART         = WA_FINAL-BSART        .
      WA_DOWN-EKGRP         = WA_FINAL-EKGRP        .
      WA_DOWN-INFNR         = WA_FINAL-INFNR        .
      WA_DOWN-URZZT         = WA_FINAL-URZZT        .
      WA_DOWN-VBELN_IM         = WA_FINAL-VBELN_IM        ."added by pranit on 25.06.2024
*      wa_down-fkdat        = wa_vbfa_n-fkdat        .
      WA_DOWN-XBLNR         = WA_FINAL-XBLNR.
      WA_DOWN-VBELN         = WA_FINAL-VBELN.
      WA_DOWN-POSNR         = WA_FINAL-POSNR.
      WA_DOWN-VBELN_IM      = WA_FINAL-VBELN_IM.
      WA_DOWN-VBELN1        = WA_FINAL-VBELN1.
      WA_DOWN-KBETR         = WA_FINAL-KBETR.
      WA_DOWN-KWERT         = WA_FINAL-KWERT.

      .
***********************    ,added by shreya*****************
      APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_FINAL.
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
*                        '2'   'BUDAT_MKPF'           'IT_FINAL'      'Posting Date'                  '10' ,
*                        '2'   'lv_budat'             'IT_FINAL'      'Posting Date'                  '10' ,
                         '2'   'FKDAT'                 'IT_FINAL'     'DV INDIA INV Date'                  '15', "added by jyoti on 01.04.2024
                         '3'   'LIFNR'                'IT_FINAL'      'Vendor Code'                   '15' ,
                         '4'   'NAME1'                'IT_FINAL'      'Vendor Name'                   '15' ,
*                         '5'   'XBLNR_MKPF'           'IT_FINAL'      'Reference'                     '15' ,
                         '5'   'XBLNR_MKPF'           'IT_FINAL'      'Delivery Note'                     '15' ,
*                        '6'   'BLDAT'                'IT_FINAL'      'Doc. Date'                     '15' ,
                         '6'   'LV_bldat'             'IT_FINAL'      'Doc. Date'                     '15' ,
                         '7'   'BKTXT'                'IT_FINAL'      'Doc.Header Text'               '15' ,
                         '8'   'MATNR'                'IT_FINAL'      'Material'                      '15' ,
                         '9'   'MATTXT'               'IT_FINAL'      'Material Des'                  '15' ,
                        '10'   'GRN_QTY'              'IT_FINAL'      'GRN Quantity'                  '15' ,
                        '11'   'MENGE'                'IT_FINAL'      'PO Quantity'                   '15' ,
                        '12'   'BWART'                'IT_FINAL'      'Mov.Type'                      '15' ,
                        '13'   'MEINS'                'IT_FINAL'      'UOM'                           '15' ,
*                       '14'   'ABLAD'                'IT_FINAL'      'Unloading Point'               '15' ,
                        '14'   'EBELN'                'IT_FINAL'      'PO No'                         '15' ,
                        '15'   'EBELP'                'IT_FINAL'      'PO Line Item'                  '15' ,
                        '16'   'AEDAT'                'IT_FINAL'      'PO Date'                       '15' ,
*                       '17'   'EINDT'                'IT_FINAL'      'PO Del Date'                   '15' ,
                        '18'   'LV_EINDT'             'IT_FINAL'      'PO Del Date'                   '15' ,
                        '18'   'PER'                  'IT_FINAL'      'Delivery Rating(DV INDIA INV Date)' '30' ,  "
                        '19'   'ZSERIES'              'IT_FINAL'      'Series'                        '15' ,
                        '20'   'ZSIZE'                'IT_FINAL'      'Size'                          '15' ,
                        '21'   'BRAND'                'IT_FINAL'      'Brand'                         '15' ,
                        '22'   'MOC'                  'IT_FINAL'      'MOC'                           '15' ,
                        '23'   'TYPE'                 'IT_FINAL'      'TYPE'                          '15' ,
*                       '24'   'NETPR'                'IT_FINAL'      'Net Price'                     '15' , "Added by Pranit 03.20.2024
                        '25'   'WKURS'                'IT_FINAL'      'Exchange Rate'                 '13' ,
                        '25'   'UNIT_RATE'            'IT_FINAL'      'Unit Rate in USD'              '13' ,
                        '26'   'DMBTR'                'IT_FINAL'      'Total Basic Value in USD'      '13' ,
                        '27'   'lv_pf'                'IT_FINAL'      'P&F charges in USD'            '13' ,       "'ZPFL'
                        '28'   'ZINS'                 'IT_FINAL'      'Inspection Charges in USD'     '13' ,
                        '29'   'lv_zscq'              'IT_FINAL'      'Setting Charges in USD'        '13' ,      "   'ZSCV'
                        '30'   'lv_dev'               'IT_FINAL'      'Development charges in USD'    '13' ,    " 'ZDVV'
                        '31'   'ZRB1'                 'IT_FINAL'      'Freight Charges in USD'        '13' ,
                        '32'   'lv_oth'               'IT_FINAL'      'Other Charges in USD'          '13' ,     "   'ZOCQ'
*                       '33'   'JCDB'                 'IT_FINAL'      'Basic Custom Duty in USD'      '13' ,
*                       '34'   'ZSWS'                 'IT_FINAL'      'Social Welfare Cess in USD'    '13' ,
                        '33'   'LAND_COST_TOT'        'IT_FINAL'      'Landed Cost  in USD'           '13' ,
                        '34'   'BSART'                'IT_FINAL'      'PO Type'                       '4' ,
                        '35'   'EKGRP'                'IT_FINAL'      'Purchasing Group'              '3' ,
                        '36'   'INFNR'                'IT_FINAL'      'INFO Record'                   '10' ,
                        '37'   'URZZT'                'IT_FINAL'      'Casting Weight'                '16' ,
                        '38'   'PER1'                 'IT_FINAL'      'Delivery Rating(MIGO Date)'    '30' , "Added by Nilay B. 12.01.2024
                        '39'   'TEXT_N'               'IT_FINAL'      'Customer Details'              '30' ,
                        '40'   'SHIPP'                'IT_FINAL'      'Shipping Directly From'        '30' ,
                        '41'   'XBLNR'                'IT_FINAL'      'DV Outbound Number'            '10' , ""Added by Pranit 25.06.2024
                        '42'   'VBELN'                'IT_FINAL'      'Sales Order'                   '10' , ""Added by Pranit 25.06.2024
                        '42'   'POSNR'                'IT_FINAL'      'Sales Order Line Item'         '10' , ""Added by Pranit 25.06.2024
                        '43'   'VBELN_IM'             'IT_FINAL'      'Inbound Delivery'              '10' , ""Added by Pranit 25.06.2024
                        '44'   'VBELN1'               'IT_FINAL'      'DV Invoice No.'                '10' , ""Added by Pranit 25.06.2024
                        '45'   'KBETR'                'IT_FINAL'      'Discount%'                     '10' , ""Added by Pranit 25.06.2024
                        '46'   'KWERT'                'IT_FINAL'      'Discounted Value'              '10' . ""Added by Pranit 25.06.2024

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
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      I_CALLBACK_PROGRAM      = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
      I_CALLBACK_USER_COMMAND = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
*     IS_LAYOUT               =
      IT_FIELDCAT             = IT_FCAT
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      I_SAVE                  = 'X'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      T_OUTTAB                = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
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
  LV_FILE =   'ZUS_DELIVERY_PERFORMANCE_INVN.TXT'.
*BREAK primus.
*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'DELIVERY PERFORM REPORT Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1495 TYPE string.
DATA lv_crlf_1495 TYPE string.
lv_crlf_1495 = cl_abap_char_utilities=>cr_lf.
lv_string_1495 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1495 lv_crlf_1495 wa_csv INTO lv_string_1495.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
TRANSFER lv_string_1495 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
ENDFORM.

FORM UCOMM_ON_ALV
  USING U_UCOMM    TYPE SY-UCOMM "#EC CALLED       "Form ucomm is called indirectly.
        U_SELFIELD TYPE SLIS_SELFIELD .
  DATA:
    LS_FINAL_N     TYPE TY_FINAL,
    L_INV_DISPLAY  TYPE TCODE VALUE 'VA03',
    L_DINV_DISPLAY TYPE TCODE VALUE 'VF03',
    L_OINV_DISPLAY TYPE TCODE VALUE 'VL03N',
    L_PO_DISPLAY   TYPE TCODE VALUE 'ME23N',
    L_INB_DISPLAY  TYPE TCODE VALUE 'VL33N'.


  IF U_UCOMM = '&IC1'.  "Klick on field

    READ TABLE IT_FINAL
         INDEX U_SELFIELD-TABINDEX
          INTO LS_FINAL_N.

    IF U_SELFIELD-FIELDNAME = 'VBELN' .
      IF U_SELFIELD-VALUE IS NOT INITIAL.
        SET PARAMETER ID 'AUN'
            FIELD U_SELFIELD-VALUE.
        CALL TRANSACTION  L_INV_DISPLAY AND SKIP FIRST SCREEN . "#EC CI_CALLTA       " Needs authorization for call transaction
      ENDIF.
    ENDIF.

    IF U_SELFIELD-FIELDNAME = 'VBELN1' .
      IF U_SELFIELD-VALUE IS NOT INITIAL.
        SET PARAMETER ID 'VF'
            FIELD U_SELFIELD-VALUE.
        CALL TRANSACTION  L_DINV_DISPLAY AND SKIP FIRST SCREEN . "#EC CI_CALLTA       " Needs authorization for call transaction
      ENDIF.
    ENDIF.


    IF U_SELFIELD-FIELDNAME = 'XBLNR' .
      IF U_SELFIELD-VALUE IS NOT INITIAL.
        SET PARAMETER ID 'VL'
            FIELD U_SELFIELD-VALUE.
        CALL TRANSACTION  L_OINV_DISPLAY AND SKIP FIRST SCREEN . "#EC CI_CALLTA       " Needs authorization for call transaction
      ENDIF.
    ENDIF.

    IF U_SELFIELD-FIELDNAME = 'EBELN' .
      IF U_SELFIELD-VALUE IS NOT INITIAL.
        SET PARAMETER ID 'BES'
            FIELD U_SELFIELD-VALUE.
        CALL TRANSACTION  L_PO_DISPLAY AND SKIP FIRST SCREEN . "#EC CI_CALLTA       " Needs authorization for call transaction
      ENDIF.
    ENDIF.

*        IF U_SELFIELD-FIELDNAME = 'VBELN_IM' .
*      IF U_SELFIELD-VALUE IS NOT INITIAL.
*        SET PARAMETER ID 'VL'
*            FIELD U_SELFIELD-VALUE.
*        CALL TRANSACTION  L_INB_DISPLAY AND SKIP FIRST SCREEN . "#EC CI_CALLTA       " Needs authorization for call transaction
*      ENDIF.
*    ENDIF.

  ENDIF.



ENDFORM.

FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Refreshed On'                "'Ref Date'
              'Mat. Doc.'
              'DV INDIA INV Date'
              'Vendor Code'
              'Vendor Name'
              'Delivery Note'
              'Doc. Date'
              'Doc.Header Text'
              'Material'
              'Material Description'
              'GRN Quantity'
              'PO Quantity'
              'Mov.Type'
              'UOM'
*             'Unloading Point'
              'PO No'
              'PO Line Item'
              'PO Date'
              'PO Del Date'
              'Delivery Rating(DV INDIA INV Date)'
              'Series'
              'Size'
              'Brand'
              'MOC'
              'TYPE'
*              'Net Price'   """Added by Pranit 20.03.2024
              'Exchange Rate'
              'Unit Rate in USD'
              'Total Basic Value in USD'
              'P&F charges in USD'
              'Inspection Charges in USD'
              'Setting Charges in USD'
              'Development charges in USD'
              'Freight Charges in USD'
              'Other Charges in USD'
*              'Basic Custom Duty in USD'
*              'Social Welfare Cess in USD'
              'Landed Cost  in USD'
              'PO Type'
              'Purchasing Group'
              'INFO Record'
              'Casting Weight'
              'Delivery Rating(MIGO Date)'  "Added By Nilay on 12.01.2024
              'Customer Details'
              'Shipping Directly From'
*              'Ref Date'
              'Ref Time'
              'DV Outbound Number'
              'Sales Order'
              'Sales Order Line Item'
              'Inbound Delivery'
              'DV Invoice No.'
              'Discount%'
              'Discounted Value'
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
