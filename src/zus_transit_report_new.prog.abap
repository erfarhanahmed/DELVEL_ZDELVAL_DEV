*&---------------------------------------------------------------------*
*& Report ZUS_TRANSIT_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_TRANSIT_REPORT_NEW.

TABLES:EKKO,VBRK,VBFA.

TYPES:BEGIN OF TY_MARA,
        MATNR   TYPE MARA-MATNR,
        WRKST   TYPE MARA-WRKST,
        ZSERIES TYPE MARA-ZSERIES,
        ZSIZE   TYPE MARA-ZSIZE,
        BRAND   TYPE MARA-BRAND,
        MOC     TYPE MARA-MOC,
        TYPE    TYPE MARA-TYPE,
      END OF TY_MARA,

      BEGIN OF TY_MAKT,
        MATNR TYPE MAKT-MATNR,
        MAKTX TYPE MAKT-MAKTX,
      END OF TY_MAKT,

      BEGIN OF TY_EKPO,
        EBELN TYPE VBAK-BSTNK, "ekpo-ebeln,
        EBELP TYPE EKPO-EBELP,
        WERKS TYPE EKPO-WERKS,
        MENGE TYPE EKPO-MENGE,
        MATNR TYPE EKPO-MATNR,
      END OF TY_EKPO,

      BEGIN OF TY_EKKO,
        EBELN TYPE VBAK-BSTNK, "ekko-ebeln,
        BUKRS TYPE EKKO-BUKRS,
        AEDAT TYPE EKKO-AEDAT,
        BEDAT TYPE EKKO-BEDAT,
        LIFNR TYPE EKKO-LIFNR,
      END OF TY_EKKO,


      BEGIN OF TY_VBAK,
        VBELN TYPE VBAK-VBELN,
        BSTNK TYPE VBAK-BSTNK,
      END OF TY_VBAK,

      BEGIN OF TY_VBAP,
        VBELN  TYPE VBAP-VBELN,
        POSNR  TYPE VBAP-POSNR,
        MATNR  TYPE VBAP-MATNR,
        KWMENG TYPE VBAP-KWMENG,
        POSEX  TYPE VBAP-POSEX,
      END OF TY_VBAP,

      BEGIN OF TY_VBRP,
        VBELN     TYPE VBRP-VBELN,
        POSNR     TYPE VBRP-POSNR,
        FKIMG     TYPE VBRP-FKIMG,
        VGBEL(16),
        VGPOS     TYPE VBRP-VGPOS,
        AUBEL     TYPE VBRP-AUBEL,
        AUPOS     TYPE VBRP-AUPOS,
        MATNR     TYPE VBRP-MATNR,
        WERKS     TYPE VBRP-WERKS,
      END OF TY_VBRP,

      BEGIN OF TY_VBRK,
        VBELN  TYPE VBRK-VBELN,
        FKART  TYPE VBRK-FKART,
        FKDAT  TYPE VBRK-FKDAT,
        KNUMV  TYPE VBRK-KNUMV,
        RFBSK  TYPE VBRK-RFBSK,
        KUNAG  TYPE VBRK-KUNAG,
        EXNUM  TYPE VBRK-EXNUM,
        XBLNR  TYPE VBRK-XBLNR,
        LOGSYS TYPE VBRK-LOGSYS,
        FKSTO  TYPE VBRK-FKSTO,
      END OF TY_VBRK,

      BEGIN OF TY_VAPMA,
        MATNR TYPE VAPMA-MATNR,
        VKORG TYPE VAPMA-VKORG,
        BSTNK TYPE VAPMA-BSTNK,
        VBELN TYPE VAPMA-VBELN,
        POSNR TYPE VAPMA-POSNR,
        WERKS TYPE VAPMA-WERKS,
        KUNNR TYPE VAPMA-KUNNR, "added by jyoti on 02.07.2024
      END OF TY_VAPMA,
**********************added b yjyoti on 02.07.2024**************
      BEGIN OF TY_VBRP_VAPMA,
        VBELN TYPE VBRP-VBELN,
        POSNR TYPE VBRP-POSNR,
        FKIMG TYPE VBRP-FKIMG,
        VGBEL TYPE CHAR35, "CHAR16,
        VGPOS TYPE VBRP-VGPOS,
        AUBEL TYPE VBRP-AUBEL,
        AUPOS TYPE VBRP-AUPOS,
        MATNR TYPE VBRP-MATNR,
        WERKS TYPE VBRP-WERKS,
        VKORG TYPE VAPMA-VKORG,
        BSTNK TYPE VAPMA-BSTNK,
        KUNNR TYPE VAPMA-KUNNR,
*       mblnr      TYPE MSEG-MBLNR,
*       mjahr      TYPE MSEG-MJAHR,
*       bwart      TYPE mseg-bwart,
*       smbln      TYPE mseg-smbln,
*       xblnr_mkpf TYPE mseg-xblnr_mkpf,
*       vbeln_im   TYPE mseg-vbeln_im,
*       vbelp_im   TYPE mseg-vbelp_im,
      END OF TY_VBRP_VAPMA,

*********************************************************


      BEGIN OF TY_EIKP,
        EXNUM TYPE EIKP-EXNUM,
        IEVER TYPE EIKP-IEVER,
      END OF TY_EIKP,

      BEGIN OF TY_MODE,
        EXPVZ TYPE ZTRANSIT-EXPVZ,
        BEZEI TYPE ZTRANSIT-BEZEI,
        ZDAYS TYPE ZTRANSIT-ZDAYS,
      END OF TY_MODE,

      BEGIN OF TY_KONV,
        KNUMV TYPE PRCD_ELEMENTS-KNUMV,
        KPOSN TYPE PRCD_ELEMENTS-KPOSN,
        KSCHL TYPE PRCD_ELEMENTS-KSCHL,
        KBETR TYPE PRCD_ELEMENTS-KBETR,
        KWERT TYPE PRCD_ELEMENTS-KWERT,
      END OF TY_KONV,

      BEGIN OF TY_KNA1,
        KUNNR TYPE KNA1-KUNNR,
        LAND1 TYPE KNA1-LAND1,
        ORT01 TYPE KNA1-ORT01,
        PSTLZ TYPE KNA1-PSTLZ,
      END OF TY_KNA1,

      BEGIN OF TY_T005T,
        SPRAS TYPE T005T-SPRAS,
        LAND1 TYPE T005T-LAND1,
        LANDX TYPE T005T-LANDX,
      END OF TY_T005T,

      BEGIN OF TY_MARD,
        MATNR TYPE MARD-MATNR,
        WERKS TYPE MARD-WERKS,
        LGORT TYPE MARD-LGORT,
        LABST TYPE MARD-LABST,
      END OF TY_MARD,


      BEGIN OF TY_LIPS,
        VGBEL TYPE LIPS-VGBEL,
        VGPOS TYPE LIPS-VGPOS,
        LFIMG TYPE LIPS-LFIMG,
      END OF TY_LIPS,

      BEGIN OF TY_LIKP,
        VBELN TYPE LIKP-VBELN,
        VERUR TYPE LIKP-VERUR,
        TRSPG TYPE LIKP-TRSPG,
      END OF TY_LIKP,


      BEGIN OF TY_T618T,
        SPRAS TYPE T618T-SPRAS,
        LAND1 TYPE T618T-LAND1,
        EXPVZ TYPE T618T-EXPVZ,
        BEZEI TYPE T618T-BEZEI,
      END OF TY_T618T,

      BEGIN OF TY_MSEG,
        MBLNR(16)," TYPE mseg-mblnr,
        MJAHR      TYPE MSEG-MJAHR,
        BWART      TYPE MSEG-BWART,
        MATNR      TYPE MSEG-MATNR,
        WERKS      TYPE MSEG-WERKS,
        SMBLN      TYPE MSEG-SMBLN,
        XBLNR_MKPF TYPE MSEG-XBLNR_MKPF,
        VBELN_IM   TYPE MSEG-VBELN_IM,
        VBELP_IM   TYPE MSEG-VBELP_IM,
        LIFNR      TYPE MSEG-LIFNR,
      END OF TY_MSEG,

      BEGIN OF TY_BKPF,
        BELNR TYPE BKPF-BELNR,
        BLART TYPE BKPF-BLART,
        XBLNR TYPE BKPF-XBLNR,
        STBLG TYPE BKPF-STBLG,
      END OF TY_BKPF,



      BEGIN OF TY_FINAL,
        MATNR    TYPE MARA-MATNR,
        WRKST    TYPE MARA-WRKST,
        ZSERIES  TYPE MARA-ZSERIES,
        ZSIZE    TYPE MARA-ZSIZE,
        BRAND    TYPE MARA-BRAND,
        MOC      TYPE MARA-MOC,
        TYPE     TYPE MARA-TYPE,
*      maktx       TYPE makt-maktx,
        DESC     TYPE CHAR100,
        EBELN    TYPE EKPO-EBELN,
        EBELP    TYPE EKPO-EBELP,
        MENGE    TYPE EKPO-MENGE,
        LIFNR    TYPE LFA1-LIFNR,
        NAME1    TYPE LFA1-NAME1,
        VBELN    TYPE VBAP-VBELN,
        POSNR    TYPE VBAP-POSNR,
        KWMENG   TYPE VBAP-KWMENG,
        INV_NO   TYPE VBRP-VBELN,
        INV_LINE TYPE VBRP-POSNR,
        FKIMG    TYPE VBRP-FKIMG,
        FKDAT    TYPE VBRK-FKDAT,
        XBLNR    TYPE VBRK-XBLNR,
        KBETR    TYPE PRCD_ELEMENTS-KBETR,
        KWERT    TYPE PRCD_ELEMENTS-KWERT,
        PONO     TYPE CHAR15,
        BEZEI    TYPE ZTRANSIT-BEZEI,
        ARRIVAL  TYPE SY-DATUM,
        DUE      TYPE SY-DATUM,
        PORT     TYPE CHAR100,
        PLACE    TYPE STRING,
        STOCK    TYPE MARD-LABST,
        PEND     TYPE VBRP-FKIMG,
        MBLNR    TYPE MSEG-MBLNR,
        VBELN_IM TYPE MSEG-VBELN_IM,
        BELNR    TYPE BKPF-BELNR,
        WERKS    TYPE EKPO-WERKS,

      END OF TY_FINAL,

      BEGIN OF TY_STR,
        EBELN    TYPE EKPO-EBELN,
        EBELP    TYPE EKPO-EBELP,
        MATNR    TYPE MARA-MATNR,
        WRKST    TYPE MARA-WRKST,
        DESC     TYPE CHAR100,
        MENGE    TYPE CHAR15,
        ZSERIES  TYPE MARA-ZSERIES,
        ZSIZE    TYPE MARA-ZSIZE,
        BRAND    TYPE MARA-BRAND,
        MOC      TYPE MARA-MOC,
        TYPE     TYPE MARA-TYPE,
        VBELN    TYPE VBAP-VBELN,
        POSNR    TYPE VBAP-POSNR,
        KWMENG   TYPE CHAR15,
        INV_NO   TYPE VBRP-VBELN,
        INV_LINE TYPE VBRP-POSNR,
        XBLNR    TYPE VBRK-XBLNR,
        FKIMG    TYPE CHAR15,
        FKDAT    TYPE CHAR15,
        KBETR    TYPE CHAR15,
        KWERT    TYPE CHAR15,
        BEZEI    TYPE ZTRANSIT-BEZEI,
        ARRIVAL  TYPE CHAR15,
        PORT     TYPE CHAR100,
        PLACE    TYPE STRING,
        VBELN_IM TYPE MSEG-VBELN_IM,
        MBLNR    TYPE MSEG-MBLNR,
        BELNR    TYPE BKPF-BELNR,
        REF      TYPE CHAR15,
        WERKS    TYPE CHAR10,
      END OF TY_STR.

************************ added by amit
TYPES : BEGIN OF TY_VBFA,
        VBELV   TYPE VBFA-VBELV,
        VBELN   TYPE VBFA-VBELN,
        VBTYP_V TYPE VBFA-VBTYP_V,
      END OF TY_VBFA.


 TYPES : BEGIN OF Ty_LIKP_str,
          VBELN     TYPE LIKP-VBELN,
          ITM_EXPVZ TYPE LIKP-ITM_EXPVZ,
        END OF Ty_LIKP_str.


TYPES : BEGIN OF TY_TVTRT,
        SPRAS TYPE TVTRT-SPRAS,
        VKTRA TYPE TVTRT-VKTRA,
        BEZEI TYPE TVTRT-BEZEI,
      END OF TY_TVTRT.




*************************  added by amit

DATA :DAY TYPE I.

DATA : IT_VBRP_VAPMA TYPE TABLE OF TY_VBRP_VAPMA,
       WA_VBRP_VAPMA TYPE TY_VBRP_VAPMA.

DATA: IT_MARA  TYPE TABLE OF TY_MARA,
      WA_MARA  TYPE          TY_MARA,

      IT_MARD  TYPE TABLE OF TY_MARD,
      WA_MARD  TYPE          TY_MARD,

      IT_MAKT  TYPE TABLE OF TY_MAKT,
      WA_MAKT  TYPE          TY_MAKT,

      IT_EKKO  TYPE TABLE OF TY_EKKO,
      WA_EKKO  TYPE          TY_EKKO,

      IT_EKPO  TYPE TABLE OF TY_EKPO,
      WA_EKPO  TYPE          TY_EKPO,

      IT_LIKP  TYPE TABLE OF TY_LIKP,
      WA_LIKP  TYPE          TY_LIKP,


      IT_VBAP  TYPE TABLE OF TY_VBAP,
      WA_VBAP  TYPE          TY_VBAP,

      IT_VBAK  TYPE TABLE OF TY_VBAK,
      WA_VBAK  TYPE          TY_VBAK,

      IT_VBRP  TYPE TABLE OF TY_VBRP,
      WA_VBRP  TYPE          TY_VBRP,

      IT_VBRK  TYPE TABLE OF TY_VBRK,
      WA_VBRK  TYPE          TY_VBRK,

      IT_VAPMA TYPE TABLE OF TY_VAPMA,
      WA_VAPMA TYPE          TY_VAPMA,

      IT_EIKP  TYPE TABLE OF TY_EIKP,
      WA_EIKP  TYPE          TY_EIKP,

      IT_T618T TYPE TABLE OF TY_T618T,
      WA_T618T TYPE          TY_T618T,

      IT_MODE  TYPE TABLE OF TY_MODE,
      WA_MODE  TYPE          TY_MODE,

      IT_MSEG  TYPE TABLE OF TY_MSEG,
      WA_MSEG  TYPE          TY_MSEG,

      IT_MSEG1 TYPE TABLE OF TY_MSEG,
      WA_MSEG1 TYPE          TY_MSEG,

      IT_MSEG2 TYPE TABLE OF TY_MSEG,
      WA_MSEG2 TYPE          TY_MSEG,

      IT_BKPF  TYPE TABLE OF TY_BKPF,
      WA_BKPF  TYPE          TY_BKPF,

      IT_BKPF1 TYPE TABLE OF TY_BKPF,
      WA_BKPF1 TYPE          TY_BKPF,

      IT_REV   TYPE TABLE OF TY_MSEG,
      WA_REV   TYPE          TY_MSEG,

      IT_KONV  TYPE TABLE OF TY_KONV,
      WA_KONV  TYPE          TY_KONV,

      IT_KNA1  TYPE TABLE OF TY_KNA1,
      WA_KNA1  TYPE          TY_KNA1,

      IT_T005T TYPE TABLE OF TY_T005T,
      WA_T005T TYPE          TY_T005T,

      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL,

      IT_DOWN  TYPE TABLE OF TY_STR,
      WA_DOWN  TYPE          TY_STR,
*  ************************************* ADDEDD BY AMIT
      IT_VBFAT TYPE STANDARD TABLE OF TY_VBFA,
      WA_VBFAT LIKE LINE OF  IT_VBFAT ,

      IT_LIKPT  TYPE STANDARD TABLE OF Ty_LIKP_str,
      WA_LIKPT LIKE LINE OF IT_LIKPT,

      IT_TVTRT  TYPE STANDARD TABLE OF TY_TVTRT,
      WA_TVTRT  LIKE LINE OF  IT_TVTRT.


*  ************************************* ADDED BY AMIT







DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: I_SORT             TYPE SLIS_T_SORTINFO_ALV, " SORT
      GT_EVENTS          TYPE SLIS_T_EVENT,        " EVENTS
      I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER,   " TOP-OF-PAGE
      WA_LAYOUT          TYPE  SLIS_LAYOUT_ALV..            " LAYOUT WORKAREA
DATA T_SORT TYPE SLIS_T_SORTINFO_ALV WITH HEADER LINE.

DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.


SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*SELECT-OPTIONS: po FOR ekko-ebeln,
*                date FOR ekko-bedat OBLIGATORY.

  PARAMETERS: CUST TYPE VBRK-KUNAG DEFAULT '0000300000' .
  SELECT-OPTIONS: INV FOR VBRK-VBELN,
                  DATE FOR VBRK-FKDAT.
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/USA'."USA'."USA'."usa'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 5(63) TEXT-006.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 5(63) TEXT-004.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 5(63) TEXT-005.
  SELECTION-SCREEN END OF LINE.



*SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
*SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.


START-OF-SELECTION.
  IF CUST = '0000300000'.
    PERFORM GET_DATA.
    PERFORM SORT_DATA.
  ELSE.
    MESSAGE 'This Report valid For USA Customer' TYPE 'S'.

  ENDIF.

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

  SELECT VBELN
         FKART
         FKDAT
         KNUMV
         RFBSK
         KUNAG
         EXNUM
         XBLNR
         LOGSYS
         FKSTO FROM VBRK INTO TABLE IT_VBRK
         WHERE VBELN IN INV
           AND FKDAT IN DATE
           AND KUNAG = '0000300000'
           AND FKSTO NE 'X'
           AND FKART NE 'ZS1'  AND FKART NE 'ZF5'
           AND LOGSYS NE ' '.

************************** ADDED BY AMIT
 IF IT_VBRK IS NOT INITIAL.


SELECT VBELV
       VBELN
       VBTYP_V

  FROM VBFA
  INTO TABLE IT_VBFAT
  FOR ALL ENTRIES IN IT_VBRK
  WHERE VBELN = IT_VBRK-VBELN
  AND VBTYP_V = 'J'.

ENDIF.

IF IT_VBFAT IS NOT INITIAL .

SELECT  VBELN
        ITM_EXPVZ
  FROM LIKP
  INTO TABLE IT_LIKPT
  FOR ALL ENTRIES IN  IT_VBFAT
  WHERE VBELN = IT_VBFAT-VBELV.

IF IT_LIKPT IS NOT INITIAL .

SELECT SPRAS
       VKTRA
       BEZEI
  FROM TVTRT
  INTO TABLE IT_TVTRT
  FOR ALL ENTRIES IN IT_LIKPT
  WHERE SPRAS = 'EN'
  AND VKTRA =  IT_LIKPT-ITM_EXPVZ.

ENDIF.


ENDIF.



  IF IT_VBRK IS NOT INITIAL.
    SELECT VBELV,
           POSNV,
           VBTYP_N
          FROM VBFA
          INTO TABLE @DATA(IT_VBFA)
          FOR ALL ENTRIES IN @IT_VBRK
          WHERE VBELV = @IT_VBRK-VBELN
         AND VBTYP_N = 'O'.

    IF IT_VBFA IS NOT INITIAL.
      LOOP AT IT_VBFA INTO DATA(WA_VBFA).
        DELETE IT_VBRK WHERE VBELN = WA_VBFA-VBELV.
      ENDLOOP.
    ENDIF.
  ENDIF.


  IF IT_VBRK IS NOT INITIAL.
*    SELECT vbeln
*           posnr
*           fkimg
*           vgbel
*           vgpos
*           aubel
*           aupos
*           matnr
*           werks FROM vbrp INTO TABLE it_vbrp
*           FOR ALL ENTRIES IN it_vbrk
*           WHERE vbeln = it_vbrk-vbeln.

    SELECT A~VBELN
           A~POSNR
           A~FKIMG
           VGBEL
           A~VGPOS
           A~AUBEL
           A~AUPOS
           A~MATNR
           A~WERKS
           B~VKORG
           B~BSTNK
           B~KUNNR
*
         INTO TABLE IT_VBRP_VAPMA
          FROM VBRP AS A
          JOIN VAPMA AS B
*          JOIN mseg as c
*         on ( a~aupos = b~vbeln AND a~aupos = b~posnr ) "and a~matnr = b~matnr and a~werks = b~werks )
         ON ( B~VBELN = A~AUBEL AND B~POSNR = A~AUPOS ) "and a~matnr = b~matnr and a~werks = b~werks )
         FOR ALL ENTRIES IN IT_VBRK
         WHERE A~VBELN = IT_VBRK-VBELN
         AND B~KUNNR = '0000300000'
        .


    SELECT KNUMV
           KPOSN
           KSCHL
           KBETR
           KWERT FROM PRCD_ELEMENTS INTO TABLE IT_KONV
           FOR ALL ENTRIES IN IT_VBRK
           WHERE KNUMV = IT_VBRK-KNUMV
             AND KSCHL = 'ZPR0'.


    SELECT EXNUM
           IEVER FROM EIKP INTO TABLE IT_EIKP
           FOR ALL ENTRIES IN IT_VBRK
           WHERE EXNUM = IT_VBRK-EXNUM.


    SELECT KUNNR
           LAND1
           ORT01
           PSTLZ FROM KNA1 INTO TABLE IT_KNA1
           FOR ALL ENTRIES IN IT_VBRK
           WHERE KUNNR = IT_VBRK-KUNAG.

  ENDIF.


  IF IT_EIKP IS NOT INITIAL.

    SELECT SPRAS
           LAND1
           EXPVZ
           BEZEI FROM T618T INTO TABLE IT_T618T
           FOR ALL ENTRIES IN IT_EIKP
           WHERE EXPVZ = IT_EIKP-IEVER
            AND  SPRAS = 'EN'
            AND  LAND1 = 'IN'.


    SELECT EXPVZ
           BEZEI
           ZDAYS FROM ZTRANSIT INTO TABLE IT_MODE
           FOR ALL ENTRIES IN IT_EIKP
           WHERE EXPVZ = IT_EIKP-IEVER.

  ENDIF.

  IF IT_VBRP_VAPMA IS NOT INITIAL.

*    SELECT matnr
*           vkorg
*           bstnk
*           vbeln
*           posnr
*           werks
*           kunnr FROM vapma INTO TABLE it_vapma
*           FOR ALL ENTRIES IN it_vbrp
*           WHERE vbeln = it_vbrp-aubel
*             AND posnr = it_vbrp-aupos
*            AND kunNR = '0000300000'. "ADDED BY JYOTI ON 02.07.2024

*  SELECT vbeln
*         verur FROM likp INTO TABLE it_likp
*         FOR ALL ENTRIES IN it_vbrp
*         WHERE VERUR = it_vbrp-VGBEL.

**********************added by jyoti on 23.07.2024*************
    SELECT VBELN
             VERUR
             TRSPG
             FROM LIKP
             INTO TABLE IT_LIKP
             FOR ALL ENTRIES IN IT_VBRP_VAPMA
             WHERE VERUR = IT_VBRP_VAPMA-VGBEL.



    SORT IT_LIKP DESCENDING BY VBELN.
**************************************************************


    SELECT MBLNR
           MJAHR
           BWART
           MATNR
           WERKS
           SMBLN
           XBLNR_MKPF
           VBELN_IM
           VBELP_IM
           LIFNR FROM MSEG INTO TABLE IT_MSEG
           FOR ALL ENTRIES IN IT_VBRP_VAPMA
           WHERE XBLNR_MKPF = IT_VBRP_VAPMA-VGBEL+(16)
             AND BWART = '103'.
*            AND lifnr = '0000110000'.


    SELECT MBLNR
           MJAHR
           BWART
           MATNR
           WERKS
           SMBLN
           XBLNR_MKPF
           VBELN_IM
           VBELP_IM
           LIFNR FROM MSEG INTO TABLE IT_REV
           FOR ALL ENTRIES IN IT_VBRP_VAPMA
           WHERE XBLNR_MKPF = IT_VBRP_VAPMA-VGBEL+(16)
           AND BWART = '105'.
*          AND lifnr = '0000110000'.







  ENDIF.
  IF IT_VBRP_VAPMA IS NOT INITIAL.
    SELECT VBELN
           POSNR
           MATNR
           KWMENG
           POSEX FROM VBAP INTO TABLE IT_VBAP
           FOR ALL ENTRIES IN IT_VBRP_VAPMA
           WHERE VBELN = IT_VBRP_VAPMA-AUBEL
             AND POSNR = IT_VBRP_VAPMA-AUPOS.


    SELECT EBELN
           EBELP
           WERKS
           MENGE
           MATNR FROM EKPO INTO TABLE IT_EKPO
           FOR ALL ENTRIES IN IT_VBRP_VAPMA
           WHERE EBELN = IT_VBRP_VAPMA-BSTNK+0(10).



  ENDIF.

  IF IT_KNA1 IS NOT INITIAL.
    SELECT SPRAS
           LAND1
           LANDX FROM T005T INTO TABLE IT_T005T
           FOR ALL ENTRIES IN IT_KNA1
           WHERE SPRAS = 'EN'
            AND  LAND1 = IT_KNA1-LAND1.


  ENDIF.

  IF IT_EKPO IS NOT INITIAL.
    SELECT MATNR
           WRKST
           ZSERIES
           ZSIZE
           BRAND
           MOC
           TYPE   FROM MARA INTO TABLE IT_MARA
           FOR ALL ENTRIES IN IT_EKPO
           WHERE MATNR = IT_EKPO-MATNR.

  ENDIF.

  IF IT_MSEG IS NOT INITIAL.
*  BREAK PRIMUSUSA.
    SELECT BELNR
           BLART
           XBLNR
           STBLG FROM BKPF INTO TABLE IT_BKPF
           FOR ALL ENTRIES IN IT_MSEG
           WHERE XBLNR = IT_MSEG-MBLNR
             AND BLART = 'TR'.

    SELECT MBLNR
           MJAHR
           BWART
           MATNR
           WERKS
           SMBLN
           XBLNR_MKPF
           VBELN_IM
           VBELP_IM
           LIFNR FROM MSEG INTO TABLE IT_MSEG1
           FOR ALL ENTRIES IN IT_MSEG
           WHERE SMBLN = IT_MSEG-MBLNR+0(10).


  ENDIF.

  IF IT_BKPF IS NOT INITIAL.

    SELECT BELNR
           BLART
           XBLNR
           STBLG FROM BKPF INTO TABLE IT_BKPF1
           FOR ALL ENTRIES IN IT_BKPF
           WHERE STBLG = IT_BKPF-BELNR
           AND BUKRS = 'US00'.
*         AND blart = 'TR'.

  ENDIF.
****************ADDED BY JYOTI ON 03.03.2025******************************
  IF IT_REV IS NOT INITIAL.
    SELECT MBLNR
         MJAHR
         BWART
         MATNR
         WERKS
         SMBLN
         XBLNR_MKPF
         VBELN_IM
         VBELP_IM
         LIFNR FROM MSEG INTO TABLE IT_MSEG2
         FOR ALL ENTRIES IN IT_REV
         WHERE SMBLN = IT_REV-MBLNR+0(10).
  ENDIF.
*****************************************************************************



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
*  LOOP AT it_vbrp INTO wa_vbrp WHERE vgbel NE space.
*  break primusabap.
  LOOP AT IT_VBRP_VAPMA INTO WA_VBRP_VAPMA WHERE VGBEL NE SPACE.


    WA_FINAL-INV_NO   = WA_VBRP_VAPMA-VBELN.
    WA_FINAL-INV_LINE = WA_VBRP_VAPMA-POSNR.
    WA_FINAL-FKIMG    = WA_VBRP_VAPMA-FKIMG.

*SELECT SINGLE vbeln INTO wa_final-VBELN_IM FROM likp WHERE verur = wa_vbrp-vgbel.

*    SELECT vbeln
*           verur
*           trspg FROM likp INTO TABLE it_likp
*           WHERE verur = wa_vbrp_vapma-vgbel.
*
*
*    SORT it_likp DESCENDING BY vbeln.

*    READ TABLE it_likp INTO wa_likp INDEX 1.
    READ TABLE IT_LIKP INTO WA_LIKP  WITH KEY VERUR = WA_VBRP_VAPMA-VGBEL..
    IF SY-SUBRC = 0.

      WA_FINAL-VBELN_IM = WA_LIKP-VBELN.

    ENDIF.

    READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_VBRP_VAPMA-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-FKDAT = WA_VBRK-FKDAT.
      WA_FINAL-XBLNR = WA_VBRK-XBLNR.

    ENDIF.

    READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP_VAPMA-POSNR.
    IF SY-SUBRC = 0.

      WA_FINAL-KBETR = WA_KONV-KBETR.
      WA_FINAL-KWERT = WA_KONV-KWERT.

    ENDIF.


*    READ TABLE it_vapma INTO wa_vapma WITH KEY vbeln = wa_vbrp_vapma-aubel posnr = wa_vbrp_vapma-aupos.
*    IF sy-subrc = 0.
    WA_FINAL-VBELN = WA_VBRP_VAPMA-AUBEL.
*      wa_final-vbeln = wa_vbrp_vapma-vbeln.
*      wa_final-posnr = wa_vbrp_vapma-posnr.
    WA_FINAL-POSNR = WA_VBRP_VAPMA-AUPOS.
*
*    ENDIF.


    READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_VBRP_VAPMA-AUBEL POSNR = WA_VBRP_VAPMA-AUPOS.
    IF SY-SUBRC = 0.
      WA_FINAL-KWMENG = WA_VBAP-KWMENG.
    ENDIF.

    READ TABLE IT_EKPO INTO WA_EKPO WITH KEY EBELN = WA_VBRP_VAPMA-BSTNK  MATNR = WA_VBRP_VAPMA-MATNR EBELP = WA_VBAP-POSEX.
    IF SY-SUBRC = 0.
      WA_FINAL-EBELN = WA_EKPO-EBELN.
      WA_FINAL-EBELP = WA_EKPO-EBELP.
      WA_FINAL-MATNR = WA_EKPO-MATNR.
      WA_FINAL-MENGE = WA_EKPO-MENGE.
      WA_FINAL-WERKS = WA_EKPO-WERKS.

    ENDIF.

    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_EKPO-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-WRKST     = WA_MARA-WRKST.
      WA_FINAL-ZSERIES   = WA_MARA-ZSERIES.
      WA_FINAL-ZSIZE     = WA_MARA-ZSIZE.
      WA_FINAL-BRAND     = WA_MARA-BRAND.
      WA_FINAL-MOC       = WA_MARA-MOC.
      WA_FINAL-TYPE      = WA_MARA-TYPE   .

    ENDIF.





    READ TABLE IT_EIKP INTO WA_EIKP WITH KEY EXNUM = WA_VBRK-EXNUM.
    IF SY-SUBRC = 0.

    ENDIF.
    READ TABLE IT_T618T INTO WA_T618T WITH KEY EXPVZ = WA_EIKP-IEVER.
    IF SY-SUBRC = 0.
      WA_FINAL-BEZEI = WA_T618T-BEZEI.

    ENDIF.
*    *****************8888 added by amit
    IF  WA_FINAL-BEZEI = ''.

READ TABLE IT_VBFAT into WA_VBFAT with key VBELN = WA_VBRK-VBELN.

IF sy-subrc = 0 .

ENDIF.

READ TABLE IT_LIKPT into WA_LIKPT with key VBELN = WA_VBFAT-VBELV.

IF sy-subrc = 0 .

ENDIF.

READ TABLE IT_TVTRT into WA_TVTRT with key VKTRA = WA_LIKPT-ITM_EXPVZ.

IF sy-subrc = 0 .
 WA_FINAL-BEZEI = WA_TVTRT-BEZEI.
ENDIF.

    ENDIF.





*    ******************************



    READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_VBRK-KUNAG.
    IF SY-SUBRC = 0.
      READ TABLE IT_T005T INTO WA_T005T WITH KEY SPRAS = 'EN' LAND1 = WA_KNA1-LAND1.
      IF SY-SUBRC = 0.
        CONCATENATE WA_KNA1-ORT01 WA_KNA1-PSTLZ WA_T005T-LANDX INTO WA_FINAL-PLACE SEPARATED BY ','.

      ENDIF.

    ENDIF.

    READ TABLE IT_MODE INTO WA_MODE WITH KEY EXPVZ = WA_EIKP-IEVER.
    IF SY-SUBRC = 0.
      DAY = WA_MODE-ZDAYS.
      CALL FUNCTION 'BKK_ADD_WORKINGDAY'
        EXPORTING
          I_DATE = WA_FINAL-FKDAT
          I_DAYS = DAY
*         I_CALENDAR1       =
*         I_CALENDAR2       =
        IMPORTING
          E_DATE = WA_FINAL-ARRIVAL
*         E_RETURN          =
        .

    ENDIF.

    CLEAR: LV_LINES, LS_MATTXT,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-INV_NO.
    IF LV_NAME IS NOT INITIAL.        """"Added by Pranit 03.04.2024

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z010'
          LANGUAGE                = SY-LANGU
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
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO WA_LINES.
          IF NOT WA_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_FINAL-PORT WA_LINES-TDLINE INTO WA_FINAL-PORT SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
        CONDENSE WA_FINAL-PORT.
      ENDIF.
    ENDIF.

    CLEAR: LV_LINES, LS_MATTXT.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-MATNR.

    IF LV_NAME IS NOT INITIAL.                        """"Added by Pranit 03.04.2024

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
            CONCATENATE WA_FINAL-DESC WA_LINES-TDLINE INTO WA_FINAL-DESC SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
        CONDENSE WA_FINAL-DESC.
      ENDIF.
    ENDIF.

    REPLACE ALL OCCURRENCES OF '<(>' IN WA_FINAL-DESC WITH SPACE.
    REPLACE ALL OCCURRENCES OF '<)>' IN WA_FINAL-DESC WITH SPACE.
    SORT IT_MSEG DESCENDING BY MBLNR.
*    READ TABLE   it_mseg INTO wa_mseg WITH KEY xblnr_mkpf = wa_vbrp_vapma-vgbel." VBELP_IM = wa_vbrp-posnr.
    READ TABLE IT_MSEG INTO WA_MSEG WITH KEY XBLNR_MKPF = WA_VBRP_VAPMA-VGBEL."  vbelp_im = wa_vbrp_vapma-vgpos.
    IF SY-SUBRC = 0.

      READ TABLE IT_MSEG1 INTO WA_MSEG1 WITH KEY SMBLN = WA_MSEG-MBLNR.
      IF SY-SUBRC = 4.
        WA_FINAL-MBLNR = WA_MSEG-MBLNR.
      ENDIF.


    ENDIF.
*BREAK PRIMUSUSA.
    LOOP AT IT_BKPF INTO WA_BKPF WHERE XBLNR = WA_MSEG-MBLNR.
*IF sy-subrc = 0.
      READ TABLE IT_BKPF1 INTO WA_BKPF1 WITH KEY STBLG = WA_BKPF-BELNR.
      IF SY-SUBRC = 4.
        WA_FINAL-BELNR = WA_BKPF-BELNR.
      ENDIF.

*ENDIF.
    ENDLOOP.

*    READ TABLE it_rev INTO wa_rev WITH KEY xblnr_mkpf = wa_vbrp_vapma-vgbel." VBELP_IM = wa_vbrp-posnr.
*    READ TABLE it_rev INTO wa_rev WITH KEY xblnr_mkpf = wa_vbrp_vapma-vgbel."  vbelp_im = wa_vbrp_vapma-vgpos.
*
*    IF sy-subrc = 4.
*      IF wa_likp-trspg NE '03' .
*        APPEND wa_final TO it_final.
*      ENDIF.
***************************ADDED BY JYOTI ON 03.03.2025*******************************************
*    ELSE.
    SORT IT_REV DESCENDING BY MBLNR.
    READ TABLE IT_REV INTO WA_REV WITH KEY XBLNR_MKPF = WA_VBRP_VAPMA-VGBEL."  vbelp_im = wa_vbrp_vapma-vgpos.

    IF SY-SUBRC IS INITIAL.
      READ TABLE IT_MSEG2 INTO WA_MSEG2 WITH KEY SMBLN = WA_REV-MBLNR.
      IF SY-SUBRC IS INITIAL.
        IF WA_LIKP-TRSPG NE '03' .
          APPEND WA_FINAL TO IT_FINAL.
        ENDIF.
      ENDIF.

    ELSE .

      READ TABLE IT_REV INTO WA_REV WITH KEY XBLNR_MKPF = WA_VBRP_VAPMA-VGBEL."  vbelp_im = wa_vbrp_vapma-vgpos.

      IF SY-SUBRC = 4.
        IF WA_LIKP-TRSPG NE '03' .
          APPEND WA_FINAL TO IT_FINAL.
        ENDIF.

      ENDIF.
    ENDIF.
*********************************************************************************************************

    CLEAR:WA_FINAL,WA_MSEG,WA_REV,WA_BKPF,WA_MSEG1,WA_VBRP,WA_EIKP,WA_MODE,WA_KNA1,WA_T005T,WA_VBRK,WA_T618T,WA_MARA,WA_EKPO,
          WA_VBAP,WA_VAPMA,WA_KONV,WA_MSEG1,WA_REV,WA_LIKP, WA_VBRP_VAPMA,WA_VBFAT, WA_LIKPT, WA_TVTRT.
*    DELETE it_final WHERE ebeln  = ' '.
*    DELETE it_final WHERE vbeln_im  = ' '.
  ENDLOOP.
  DELETE IT_FINAL WHERE EBELN  = ' '.
  DELETE IT_FINAL WHERE VBELN_IM  = ' '.


  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL .
      WA_DOWN-EBELN    = WA_FINAL-EBELN   .
      WA_DOWN-EBELP    = WA_FINAL-EBELP   .
      WA_DOWN-MATNR    = WA_FINAL-MATNR   .
      WA_DOWN-WRKST    = WA_FINAL-WRKST   .
      WA_DOWN-DESC     = WA_FINAL-DESC    .
      WA_DOWN-MENGE    = WA_FINAL-MENGE   .
      WA_DOWN-ZSERIES  = WA_FINAL-ZSERIES .
      WA_DOWN-ZSIZE    = WA_FINAL-ZSIZE   .
      WA_DOWN-BRAND    = WA_FINAL-BRAND   .
      WA_DOWN-MOC      = WA_FINAL-MOC     .
      WA_DOWN-TYPE     = WA_FINAL-TYPE    .
      WA_DOWN-VBELN    = WA_FINAL-VBELN   .
      WA_DOWN-POSNR    = WA_FINAL-POSNR   .
      WA_DOWN-KWMENG   = WA_FINAL-KWMENG  .
      WA_DOWN-INV_NO   = WA_FINAL-INV_NO  .
      WA_DOWN-INV_LINE = WA_FINAL-INV_LINE.
      WA_DOWN-XBLNR    = WA_FINAL-XBLNR   .
      WA_DOWN-FKIMG    = WA_FINAL-FKIMG   .
      WA_DOWN-WERKS    = WA_FINAL-WERKS   .
*    wa_down-fkdat    = wa_final-fkdat   .
      IF WA_FINAL-FKDAT IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-FKDAT
          IMPORTING
            OUTPUT = WA_DOWN-FKDAT.

        CONCATENATE WA_DOWN-FKDAT+0(2) WA_DOWN-FKDAT+2(3) WA_DOWN-FKDAT+5(4)
                        INTO WA_DOWN-FKDAT SEPARATED BY '-'.
      ENDIF.


      WA_DOWN-KBETR    = WA_FINAL-KBETR   .
      WA_DOWN-KWERT    = WA_FINAL-KWERT   .
      WA_DOWN-BEZEI    = WA_FINAL-BEZEI   .
*    wa_down-arrival  = wa_final-arrival .

      IF WA_FINAL-ARRIVAL IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-ARRIVAL
          IMPORTING
            OUTPUT = WA_DOWN-ARRIVAL.

        CONCATENATE WA_DOWN-ARRIVAL+0(2) WA_DOWN-ARRIVAL+2(3) WA_DOWN-ARRIVAL+5(4)
                        INTO WA_DOWN-ARRIVAL SEPARATED BY '-'.
      ENDIF.

      WA_DOWN-PORT     = WA_FINAL-PORT     .
      WA_DOWN-PLACE    = WA_FINAL-PLACE    .
      WA_DOWN-VBELN_IM = WA_FINAL-VBELN_IM .
      WA_DOWN-MBLNR    = WA_FINAL-MBLNR    .
      WA_DOWN-BELNR    = WA_FINAL-BELNR    .
      WA_DOWN-REF = SY-DATUM.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_DOWN-REF
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.


      APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_DOWN.

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
  PERFORM FCAT USING :  '1'  'EBELN '           'IT_FINAL'  'Purchase Order No'         '18' ,
                        '2'  'EBELP '           'IT_FINAL'  'Purchase Order Line'         '18' ,
                        '3'  'MATNR '           'IT_FINAL'  'Material Number'           '18' ,
                        '4'  'WRKST '           'IT_FINAL'  'USA Material Code'         '18' ,
                        '5'  'DESC  '           'IT_FINAL'  'Material Desc.'            '18' ,
                        '6'  'MENGE '           'IT_FINAL'  'Purchase Order Quantity'         '18' ,
                        '7'  'ZSERIES'          'IT_FINAL'  'Series code'               '18' ,
                        '8'  'ZSIZE '           'IT_FINAL'  'Size'                      '18' ,
                        '9'  'BRAND '           'IT_FINAL'  'Brand'                     '18' ,
                       '10'  'MOC '             'IT_FINAL'  'Moc'                       '18' ,
                       '11'  'TYPE '            'IT_FINAL'  'Type'                      '18' ,

                      '12'  'VBELN '          'IT_FINAL'  'Sale Order No'             '18' ,
                      '13'  'POSNR '          'IT_FINAL'  'Sale Ord.Item'             '18' ,
                      '14'  'KWMENG '         'IT_FINAL'  'Sale Ord.Qty'             '18' ,
                      '15'  'INV_NO'          'IT_FINAL'  'Billing Doc No'                '18' ,
                      '16'  'INV_LINE'        'IT_FINAL'  'Billing Item'              '18' ,
                      '17'  'XBLNR'           'IT_FINAL'  'Invoice No'              '18' ,
                      '18'  'FKIMG'           'IT_FINAL'  'Invoice Qty'               '18' ,
                      '19'  'FKDAT'           'IT_FINAL'  'Invoice Date'              '18' ,
                      '20'  'KBETR'           'IT_FINAL'  'Invoice Rate'                '18' ,
                      '21'  'KWERT'           'IT_FINAL'  'Net Value'                 '18' ,
                      '22'  'BEZEI'           'IT_FINAL'  'Mode of Transp'            '18' ,
                      '23'  'ARRIVAL'         'IT_FINAL'  'Expected arrival date'     '18' ,
                      '24'  'PORT'            'IT_FINAL'  'Port Of Discharge'            '18' ,
                      '25'  'PLACE'           'IT_FINAL'  'Place Of Delivery'            '18' ,
                      '26'  'VBELN_IM'        'IT_FINAL'  'Inbound Delivery'            '18',
                      '27'  'MBLNR'           'IT_FINAL'  'Material Document No'            '18',
                      '28'  'BELNR'           'IT_FINAL'  'FI Document No'            '18',
                      '29'  'WERKS'           'IT_FINAL'  'Plant'                    '18'.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0729   text
*      -->P_0730   text
*      -->P_0731   text
*      -->P_0732   text
*      -->P_0733   text
*----------------------------------------------------------------------*
FORM FCAT   USING    VALUE(P1)
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
      I_CALLBACK_USER_COMMAND = 'USER_CMD'
      I_CALLBACK_TOP_OF_PAGE  = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      IS_LAYOUT               = WA_LAYOUT
      IT_FIELDCAT             = IT_FCAT
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
      IT_SORT                 = T_SORT[]
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


FORM TOP-OF-PAGE.
*ALV HEADER DECLARATIONS
  DATA: LT_HEADER     TYPE SLIS_T_LISTHEADER,
        LS_HEADER     TYPE SLIS_LISTHEADER,
        LT_LINE       LIKE LS_HEADER-INFO,
        LD_LINES      TYPE I,
        LD_LINESC(10) TYPE C.

* TITLE
  LS_HEADER-TYP  = 'H'.
  LS_HEADER-INFO = 'Transit Report'.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR LS_HEADER.

* DATE
  LS_HEADER-TYP  = 'S'.
  LS_HEADER-KEY  = 'RUN DATE :'.
  CONCATENATE LS_HEADER-INFO SY-DATUM+6(2) '.' SY-DATUM+4(2) '.' SY-DATUM(4) INTO LS_HEADER-INFO.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR: LS_HEADER.

*TIME
  LS_HEADER-TYP  = 'S'.
  LS_HEADER-KEY  = 'RUN TIME :'.
  CONCATENATE LS_HEADER-INFO SY-TIMLO(2) '.' SY-TIMLO+2(2) '.' SY-TIMLO+4(2) INTO LS_HEADER-INFO.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR: LS_HEADER.

* TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE IT_FINAL LINES LD_LINES.
  LD_LINESC = LD_LINES.
  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' LD_LINESC
     INTO LT_LINE SEPARATED BY SPACE.


  LS_HEADER-TYP  = 'A'.
  LS_HEADER-INFO = LT_LINE.
  APPEND LS_HEADER TO LT_HEADER.
  CLEAR: LS_HEADER, LT_LINE.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = LT_HEADER.
ENDFORM.                    " TOP-OF-PAGE


*
*FORM sort_list.
*  t_sort-spos      = '1'.
*  t_sort-fieldname = 'SR'.
*  t_sort-tabname   = 'IT_FINAL'.
*  t_sort-up        = 'X'.
*  t_sort-subtot    = 'X'.
*  APPEND t_sort.
*  endform.

FORM USER_CMD USING R_UCOMM LIKE SY-UCOMM
                    RS_SELFIELD TYPE SLIS_SELFIELD.
  IF R_UCOMM = '&IC1'.
*     IF rs_selfield-fieldname = 'BELNR'.
*       READ TABLE itab WITH KEY belnr = rs_selfield-value.
*       SET PARAMETER ID 'BLN' FIELD rs_selfield-value.
*       SET PARAMETER ID 'BUK' FIELD plant.
*       SET PARAMETER ID 'GJR' FIELD itab-gjahr.
*       CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
*     ENDIF.
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


  LV_FILE = 'ZUS_TRANSIT_NEW.TXT'.


  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUS_TRANSIT REPORT_NEW started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1315 TYPE STRING.
    DATA LV_CRLF_1315 TYPE STRING.
    LV_CRLF_1315 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1315 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1315 LV_CRLF_1315 WA_CSV INTO LV_STRING_1315.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_4031 TO lv_fullfile.
    TRANSFER LV_STRING_1315 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
*********************************************SQL UPLOAD FILE *****************************************
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


  LV_FILE = 'ZUS_TRANSIT_NEW.TXT'.


  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUS_TRANSIT REPORT_NEW started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1352 TYPE STRING.
    DATA LV_CRLF_1352 TYPE STRING.
    LV_CRLF_1352 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1352 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1352 LV_CRLF_1352 WA_CSV INTO LV_STRING_1352.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_4031 TO lv_fullfile.
    TRANSFER LV_STRING_1352 TO LV_FULLFILE.
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
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Purchase Order No'
              'Purchase Order Line'
              'Material Number'
              'USA Material Code'
              'Material Desc.'
              'Purchase Order Quantity'
              'Series code'
              'Size'
              'Brand'
              'Moc'
              'Type'
              'Sale Order No'
              'Sale Ord.Item'
              'Sale Ord.Qty'
              'Billing Doc No'
              'Billing Item'
              'Invoice No'
              'Invoice Qty'
              'Invoice Date'
              'Invoice Rate'
              'Net Value'
              'Mode of Transp'
              'Expected arrival date'
              'Port Of Discharge'
              'Place Of Delivery'
              'Inbound Delivery'
              'Material Document No'
              'FI Document No'
              'Refresh File Date'
              'Plant'
                INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
