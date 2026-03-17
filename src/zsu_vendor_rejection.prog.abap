*&---------------------------------------------------------------------*
*&Report: ZSU_VENDOR_REJECTION
*&Transaction: ZSU_VREJ
*&Functional Cosultant: Devshree kalamkar
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 04.11.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
REPORT ZSU_VENDOR_REJECTION.

TABLES : QALS.



TYPES : BEGIN OF TY_QALS,
          ART       TYPE QALS-ART,
          ENSTEHDAT TYPE QALS-ENSTEHDAT,
          AUFNR     TYPE QALS-AUFNR,
          PRUEFLOS  TYPE QALS-PRUEFLOS,
          OBJNR     TYPE QALS-OBJNR,
          LIFNR     TYPE QALS-LIFNR,
          SELMATNR  TYPE QALS-SELMATNR,
          MBLNR     TYPE QALS-MBLNR,
          ZEILE     TYPE QALS-ZEILE,
          MJAHR     TYPE QALS-MJAHR,
          BUDAT     TYPE QALS-BUDAT,
          LMENGE01  TYPE QALS-LMENGE01,
          MATNR     TYPE QALS-MATNR,
          WERK      TYPE QALS-WERK,
        END OF TY_QALS.

TYPES : BEGIN OF TY_MSEG,
          MBLNR TYPE MSEG-MBLNR,
          MJAHR TYPE MSEG-MJAHR,
          ZEILE TYPE MSEG-ZEILE,
          LGORT TYPE MSEG-LGORT,
          MENGE TYPE MSEG-MENGE,
          SGTXT TYPE MSEG-SGTXT,
          MATNR TYPE MSEG-MATNR,
          WERKS TYPE MSEG-WERKS,
          DMBTR TYPE MSEG-DMBTR,

        END OF TY_MSEG.

*TYPES : BEGIN OF ty_qinf,
*          matnr     TYPE qinf-matnr,
*          noinsp    TYPE qinf-noinsp,
*          lieferant TYPE qinf-lieferant,
*        END OF ty_qinf.

TYPES: BEGIN OF TY_QAVE,
         PRUEFLOS TYPE QAVE-PRUEFLOS,
         VCODE    TYPE QAVE-VCODE,
         VDATUM   TYPE QAVE-VDATUM,
       END OF TY_QAVE.

TYPES : BEGIN OF TY_MARA,
          MATNR   TYPE MARA-MATNR,
          MOC     TYPE MARA-MOC,
          TYPE    TYPE MARA-TYPE,
          ZSERIES TYPE MARA-ZSERIES,
          ZSIZE   TYPE MARA-ZSIZE,
          BRAND   TYPE MARA-BRAND,
        END OF TY_MARA.

TYPES: BEGIN OF TY_MAKT,
         MATNR TYPE MAKT-MATNR,
         MAKTG TYPE MAKT-MAKTG,
       END OF TY_MAKT.

TYPES: BEGIN OF TY_LFA1,
         LIFNR TYPE LFA1-LIFNR,
         NAME1 TYPE LFA1-NAME1,
       END OF TY_LFA1.

TYPES: BEGIN OF TY_AUFK,
         AUFNR TYPE AUFK-AUFNR,
         AUART TYPE AUFK-AUART,
       END OF TY_AUFK.
DATA : LT_AUFK TYPE STANDARD TABLE OF TY_AUFK,
       LS_AUFK TYPE TY_AUFK.

TYPES: BEGIN OF TY_MARD,
         MATNR TYPE MARD-MATNR,
         LGORT TYPE MARD-LGORT,
         LGPBE TYPE MARD-LGPBE,
       END OF TY_MARD.

TYPES : BEGIN OF TY_JEST,
          OBJNR TYPE JEST-OBJNR,
          STAT  TYPE JEST-STAT,
          INACT TYPE JEST-INACT,
        END OF TY_JEST.

TYPES : BEGIN OF TY_TJ02T,
          ISTAT TYPE TJ02T-ISTAT,
          TXT04 TYPE TJ02T-TXT04,
          SPRAS TYPE TJ02T-SPRAS,
        END OF TY_TJ02T.

TYPES : BEGIN OF TY_MKPF,
          MBLNR TYPE MKPF-MBLNR,
          MJAHR TYPE MKPF-MJAHR,
          BKTXT TYPE MKPF-BKTXT,
        END OF TY_MKPF.

TYPES : BEGIN OF TY_QPCT,                  "ADDED BY Snehal Rajale ON 07.04.2021
         CODE     TYPE QPCT-CODE,
         KURZTEXT TYPE QPCT-KURZTEXT,
         SPRACHE  TYPE QPCT-SPRACHE,      "Added By Nilay pn 05.06.2023
       END OF TY_QPCT.

TYPES : BEGIN OF TY_FINAL,
          ART          TYPE QALS-ART,
          ENSTEHDAT    TYPE QALS-ENSTEHDAT,
          AUFNR        TYPE QALS-AUFNR,
          PRUEFLOS     TYPE QALS-PRUEFLOS,
          LIFNR        TYPE QALS-LIFNR,
          SELMATNR     TYPE QALS-SELMATNR,
          MBLNR        TYPE QALS-MBLNR,
          MJAHR        TYPE QALS-MJAHR,
          BUDAT        TYPE QALS-BUDAT,
          REC_QTY      TYPE QALS-LMENGE01,
          LMENGE01     TYPE QALS-LMENGE01,
          ZEILE        TYPE MSEG-ZEILE,
          LGORT        TYPE MSEG-LGORT,
          LGPBE        TYPE MARD-LGPBE,
          SURM_MENGE   TYPE MSEG-MENGE,
          SUTP_MENGE   TYPE MSEG-MENGE,
          SURJ_MENGE   TYPE MSEG-MENGE,
          SURW_MENGE   TYPE MSEG-MENGE,
          SUSC_MENGE   TYPE MSEG-MENGE,
          SSRN_MENGE   TYPE MSEG-MENGE,
          SGTXT        TYPE MSEG-SGTXT,
          MOC          TYPE MARA-MOC,
          TYPE         TYPE MARA-TYPE,
          ZSERIES      TYPE MARA-ZSERIES,
          ZSIZE        TYPE MARA-ZSIZE,
          BRAND        TYPE MARA-BRAND,
          MAKTX        TYPE MAKT-MAKTX,
          NAME1        TYPE LFA1-NAME1,
          REW_QTY      TYPE prcd_elements-KBETR,
          TOTAL_REJ    TYPE prcd_elements-KBETR,
          AUART        TYPE AUFK-AUART,
          SRN_VENDOR   TYPE MKPF-BKTXT,
          MATTXT(1320) TYPE C,
          VDATUM       TYPE QAVE-VDATUM,
          STAT         TYPE CHAR100,
          DMBTR        TYPE MSEG-DMBTR,
          SGTXT1       TYPE MSEG-SGTXT,
          KURZTEXT     TYPE QPCT-KURZTEXT,
        END OF TY_FINAL,

        BEGIN OF STR,
          LIFNR      TYPE QALS-LIFNR,
          NAME1      TYPE LFA1-NAME1,
          SELMATNR   TYPE QALS-SELMATNR,
          MAKTX      TYPE MAKT-MAKTX,
          MBLNR      TYPE QALS-MBLNR,
          BUDAT      TYPE CHAR15,
          PRUEFLOS   TYPE QALS-PRUEFLOS,
          VDATUM     TYPE CHAR15,
          LGPBE      TYPE MARD-LGPBE,
          ART        TYPE QALS-ART,
          LMENGE01   TYPE CHAR15,
          SURM_MENGE TYPE CHAR15,
          SURJ_MENGE TYPE CHAR15,
          SURW_MENGE TYPE CHAR15,
          SSRN_MENGE TYPE CHAR15,
          SUSC_MENGE TYPE CHAR15,
          SUTP_MENGE TYPE CHAR15,
          MATTXT     TYPE CHAR100,
          ZSERIES    TYPE MARA-ZSERIES,
          ZSIZE      TYPE MARA-ZSIZE,
          BRAND      TYPE MARA-BRAND,
          MOC        TYPE MARA-MOC,
          TYPE       TYPE MARA-TYPE,
          AUFNR      TYPE QALS-AUFNR,
          AUART      TYPE AUFK-AUART,
          STAT       TYPE CHAR100,
          DMBTR      TYPE CHAR15,
          SGTXT1     TYPE MSEG-SGTXT,
          KURZTEXT   TYPE QPCT-KURZTEXT,
          REF        TYPE CHAR15,
          REF_TIME        TYPE CHAR15,
        END OF STR.

DATA : IT_QALS  TYPE TABLE OF TY_QALS,
       WA_QALS  TYPE TY_QALS,


       IT_QAMB  TYPE STANDARD TABLE OF QAMB,
       WA_QAMB  TYPE QAMB,

       IT_QAMB1 TYPE STANDARD TABLE OF QAMB,
       WA_QAMB1 TYPE QAMB,

       IT_MSEG  TYPE TABLE OF TY_MSEG,
       WA_MSEG  TYPE TY_MSEG,

       IT_MSEG1 TYPE TABLE OF TY_MSEG,
       WA_MSEG1 TYPE          TY_MSEG,

       IT_MARA  TYPE TABLE OF TY_MARA,
       WA_MARA  TYPE TY_MARA,

       IT_MAKT  TYPE TABLE OF TY_MAKT,
       WA_MAKT  TYPE TY_MAKT,

       IT_LFA1  TYPE TABLE OF TY_LFA1,
       WA_LFA1  TYPE TY_LFA1,

       IT_MARD  TYPE TABLE OF TY_MARD,
       WA_MARD  TYPE TY_MARD,

       IT_QAVE  TYPE TABLE OF TY_QAVE,
       WA_QAVE  TYPE          TY_QAVE,

       IT_JEST  TYPE TABLE OF TY_JEST,
       WA_JEST  TYPE          TY_JEST,

       IT_TJ02T TYPE TABLE OF TY_TJ02T,
       WA_TJ02T TYPE          TY_TJ02T,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE TY_FINAL,

       LT_FINAL TYPE TABLE OF STR,
       LS_FINAL TYPE          STR,

       LT_MKPF TYPE TABLE OF TY_MKPF,
       LS_MKPF TYPE          TY_MKPF,

       LT_QPCT TYPE TABLE OF TY_QPCT,
       LS_QPCT TYPE          TY_QPCT.

DATA : LT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
       LS_FCAT TYPE SLIS_FIELDCAT_ALV.

DATA : LS_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA:
  LV_CLINT   LIKE SY-MANDT,   "Client
  LV_ID      LIKE THEAD-TDID, "Text ID of text to be read
  LV_LANG    LIKE THEAD-TDSPRAS, "Language
  LV_NAME    LIKE THEAD-TDNAME, "Name of text to be read
  LV_OBJECT  LIKE THEAD-TDOBJECT, "Object of text to be read
  LV_A(132)  TYPE C,           "local variable to store text
  LV_B(132)  TYPE C,           "local variable to store text
  LV_D(132)  TYPE C,           "local variable to store text
  LV_E(132)  TYPE C,           "local variable to store text
  LV_L(132)  TYPE C,           "local variable to store text
  LV_G(132)  TYPE C,           "local variable to store text
  LV_H(132)  TYPE C,           "local variable to store text
  LV_I(132)  TYPE C,           "local variable to store text
  LV_J(132)  TYPE C,           "local variable to store text
  LV_K(132)  TYPE C,           "local variable to store text
  LV_F(1320) TYPE C.           "local variable to store concatenated text


LV_CLINT = SY-MANDT. "Client
LV_LANG = 'EN'.      "Language
LV_ID = 'QAVE'.      "Text ID of text to be read
LV_OBJECT = 'QPRUEFLOS'. "Object of text to be read

TYPES : BEGIN OF T_LINE,
          TDFORMAT(2) TYPE C , "Tag column
          TDLINE(132) TYPE C , "Text Line
        END OF T_LINE.

DATA:IT_LINE TYPE STANDARD TABLE OF T_LINE, "Table to store read_text data
     WA_LINE TYPE T_LINE.



SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : S_DATE   FOR QALS-BUDAT,
                 S_VENDOR FOR QALS-LIFNR,
                 P_INSP FOR QALS-ART .
SELECTION-SCREEN : END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'. "'E:/delval/Saudi'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.

START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM READDATA.
  PERFORM FIELDCAT.
  PERFORM DISPDATA.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

*  BREAK fujiabap.

  SELECT  ART
          ENSTEHDAT
          AUFNR
          PRUEFLOS
          OBJNR
          LIFNR
          SELMATNR
          MBLNR
          ZEILE
          MJAHR
          BUDAT
          LMENGE01
          MATNR
          WERK
          FROM QALS INTO TABLE IT_QALS
          WHERE BUDAT IN S_DATE
            AND LIFNR IN S_VENDOR
            AND ART   IN P_INSP
            AND WERK = 'SU01'.

  IF IT_QALS IS NOT INITIAL.
    SELECT MATNR MAKTG FROM MAKT INTO TABLE IT_MAKT
      FOR ALL ENTRIES IN IT_QALS
      WHERE MATNR = IT_QALS-MATNR.

    SELECT OBJNR
           STAT
           INACT FROM JEST INTO TABLE IT_JEST
           FOR ALL ENTRIES IN IT_QALS
           WHERE OBJNR = IT_QALS-OBJNR
           AND INACT NE 'X'.

  ENDIF.

  IF  IT_JEST IS NOT INITIAL  .
    SELECT ISTAT
           TXT04
           SPRAS FROM TJ02T INTO TABLE IT_TJ02T
           FOR ALL ENTRIES IN IT_JEST
           WHERE ISTAT = IT_JEST-STAT
           AND   SPRAS = 'E'.
  ENDIF.


  IF IT_QALS IS NOT INITIAL.
    SELECT AUFNR AUART FROM AUFK INTO TABLE LT_AUFK
      FOR ALL ENTRIES IN IT_QALS
      WHERE AUFNR = IT_QALS-AUFNR.
  ENDIF.

  IF IT_QALS IS NOT INITIAL.
    SELECT LIFNR NAME1 FROM LFA1 INTO TABLE IT_LFA1
      FOR ALL ENTRIES IN IT_QALS
      WHERE LIFNR = IT_QALS-LIFNR.
  ENDIF.

  IF IT_QALS IS NOT INITIAL.
    SELECT MATNR MOC TYPE ZSERIES ZSIZE BRAND FROM MARA INTO TABLE IT_MARA
      FOR ALL ENTRIES IN IT_QALS
      WHERE MATNR = IT_QALS-MATNR.
  ENDIF.

  IF IT_QALS IS NOT INITIAL.
    SELECT * FROM QAMB INTO TABLE IT_QAMB
      FOR ALL ENTRIES IN IT_QALS
      WHERE PRUEFLOS EQ IT_QALS-PRUEFLOS
        AND TYP EQ '3'.

    SELECT PRUEFLOS
           VCODE
           VDATUM  FROM QAVE INTO TABLE IT_QAVE
           FOR ALL ENTRIES IN IT_QALS
           WHERE PRUEFLOS EQ IT_QALS-PRUEFLOS.

*    SELECT * FROM qamb INTO TABLE it_qamb1
*      FOR ALL ENTRIES IN it_qals
*      WHERE prueflos EQ it_qals-prueflos
*        AND typ EQ '1'.

  ENDIF .


  IF IT_QAMB IS NOT INITIAL .

    SELECT
             MBLNR
             MJAHR
             ZEILE
             LGORT
             MENGE
             SGTXT
             MATNR
             WERKS
             DMBTR FROM MSEG INTO TABLE IT_MSEG
                    FOR ALL ENTRIES IN IT_QAMB
                    WHERE MBLNR = IT_QAMB-MBLNR
                      AND MJAHR = IT_QAMB-MJAHR
                      AND XAUTO = 'X'
                      AND BWART = '321'
                      AND WERKS = 'SU01'.


     SELECT MBLNR                            "ADDED BY Snehal Rajale On 07.04.2021.
            MJAHR
            BKTXT
       FROM MKPF
       INTO TABLE LT_MKPF
       FOR ALL ENTRIES IN IT_QAMB
       WHERE MBLNR = IT_QAMB-MBLNR AND
             MJAHR = IT_QAMB-MJAHR.


  ENDIF.

  IF IT_QALS IS NOT INITIAL .
    SELECT
             MBLNR
             MJAHR
             ZEILE
             LGORT
             MENGE
             SGTXT
             MATNR
             WERKS
             DMBTR  FROM MSEG INTO TABLE IT_MSEG1
                    FOR ALL ENTRIES IN IT_QALS
                    WHERE MBLNR = IT_QALS-MBLNR
                    AND   ZEILE = IT_QALS-ZEILE
                    AND WERKS = 'SU01'.
  ENDIF.

  IF IT_MSEG IS NOT INITIAL.

    SELECT MATNR LGORT LGPBE FROM MARD INTO TABLE IT_MARD
      FOR ALL ENTRIES IN  IT_MSEG1           "changed by pankaj on 15.11.2021 it_mseg to it_mseg1
      WHERE MATNR = IT_MSEG1-MATNR           "changed by pankaj on 15.11.2021 it_mseg to it_mseg1
        AND LGPBE <> ''.

  ENDIF.

  IF IT_QAVE IS NOT INITIAL.

    SELECT CODE
           KURZTEXT
           SPRACHE
      FROM QPCT
      INTO TABLE LT_QPCT
      FOR ALL ENTRIES IN IT_QAVE
      WHERE CODE = IT_QAVE-VCODE
      AND   SPRACHE = 'EN'.


  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM READDATA .

*  BREAK-POINT.
  .
  LOOP AT  IT_QALS INTO WA_QALS.
    WA_FINAL-LIFNR    = WA_QALS-LIFNR.

    WA_FINAL-SELMATNR = WA_QALS-MATNR.

    WA_FINAL-MBLNR    = WA_QALS-MBLNR.
    WA_FINAL-MJAHR    = WA_QALS-MJAHR.
    WA_FINAL-BUDAT    = WA_QALS-BUDAT.
    WA_FINAL-LMENGE01 = WA_QALS-LMENGE01.
    WA_FINAL-AUFNR    = WA_QALS-AUFNR.
    WA_FINAL-PRUEFLOS = WA_QALS-PRUEFLOS.

    SHIFT WA_FINAL-AUFNR LEFT DELETING LEADING '0'.
    WA_FINAL-ART      = WA_QALS-ART.


    LOOP AT IT_JEST INTO WA_JEST WHERE OBJNR = WA_QALS-OBJNR.

      READ TABLE IT_TJ02T INTO WA_TJ02T WITH KEY ISTAT = WA_JEST-STAT.
      IF SY-SUBRC = 0.
        CONCATENATE WA_TJ02T-TXT04 WA_FINAL-STAT INTO WA_FINAL-STAT SEPARATED BY SPACE.

      ENDIF.
    ENDLOOP.

*BREAK-POINT.
*    READ TABLE it_qamb1 INTO wa_qamb1 WITH KEY  prueflos = wa_qals-prueflos
*                                                typ = '1'.
*    IF sy-subrc = 0.
    READ TABLE IT_MSEG1 INTO WA_MSEG1 WITH KEY MBLNR = WA_QALS-MBLNR ZEILE = WA_QALS-ZEILE .
    IF SY-SUBRC = 0.
      WA_FINAL-REC_QTY = WA_MSEG1-MENGE.
      WA_FINAL-DMBTR   = WA_MSEG1-DMBTR.
      WA_FINAL-SGTXT1  = WA_MSEG1-SGTXT.                    "Added By Snehal Rajale ON 01.02.2021
    ENDIF.

*    ENDIF.

    LOOP AT IT_QAMB INTO WA_QAMB WHERE PRUEFLOS = WA_QALS-PRUEFLOS .


      READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MBLNR = WA_QAMB-MBLNR  MJAHR = WA_QAMB-MJAHR.
      IF SY-SUBRC = 0.
        WA_FINAL-SGTXT      = WA_MSEG-SGTXT.
        WA_FINAL-LGORT      = WA_MSEG-LGORT.
        IF WA_MSEG-LGORT = 'SURM'.
          WA_FINAL-SURM_MENGE = WA_MSEG-MENGE.
        ENDIF.
        IF WA_MSEG-LGORT = 'SUTP'.
          WA_FINAL-SUTP_MENGE = WA_MSEG-MENGE.
        ENDIF.
        IF WA_MSEG-LGORT = 'SURJ'.
          WA_FINAL-SURJ_MENGE = WA_MSEG-MENGE.
        ENDIF.
        IF WA_MSEG-LGORT = 'SURW'.
          WA_FINAL-SURW_MENGE = WA_MSEG-MENGE.
        ENDIF.
        IF WA_MSEG-LGORT = 'SUSC'.
          WA_FINAL-SUSC_MENGE = WA_MSEG-MENGE.
        ENDIF.
        IF WA_MSEG-LGORT = 'SSNR'.
          WA_FINAL-SSRN_MENGE = WA_MSEG-MENGE.
        ENDIF.
      ENDIF.
      CLEAR :WA_MSEG.

      READ TABLE LT_MKPF INTO LS_MKPF WITH KEY MBLNR = WA_QAMB-MBLNR  MJAHR = WA_QAMB-MJAHR.
      IF SY-SUBRC = 0.
        WA_FINAL-SRN_VENDOR = LS_MKPF-BKTXT.
      ENDIF.

    ENDLOOP.
    CLEAR : WA_QAMB.
    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_FINAL-SELMATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-MOC      = WA_MARA-MOC     .
      WA_FINAL-TYPE     = WA_MARA-TYPE    .
      WA_FINAL-ZSERIES  = WA_MARA-ZSERIES .
      WA_FINAL-ZSIZE    = WA_MARA-ZSIZE   .
      WA_FINAL-BRAND    = WA_MARA-BRAND.
    ENDIF.

    READ TABLE IT_MAKT INTO WA_MAKT WITH KEY MATNR = WA_FINAL-SELMATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-MAKTX = WA_MAKT-MAKTG.

    ENDIF.

    READ TABLE IT_LFA1 INTO WA_LFA1 WITH KEY LIFNR = WA_FINAL-LIFNR .
    IF SY-SUBRC = 0.
      WA_FINAL-NAME1 = WA_LFA1-NAME1.
    ENDIF.

    READ TABLE LT_AUFK INTO LS_AUFK WITH KEY AUFNR = WA_QALS-AUFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-AUART = LS_AUFK-AUART.
    ENDIF.

    READ TABLE IT_MARD INTO WA_MARD WITH KEY MATNR = WA_FINAL-SELMATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-LGPBE = WA_MARD-LGPBE.
    ENDIF.
    IF WA_FINAL-LMENGE01 IS NOT INITIAL.
      WA_FINAL-REW_QTY   =  ( WA_FINAL-SURW_MENGE / WA_FINAL-LMENGE01 ) * 100.
      WA_FINAL-TOTAL_REJ = ( ( WA_FINAL-SURW_MENGE + WA_FINAL-SURJ_MENGE + WA_FINAL-SUSC_MENGE ) /  WA_FINAL-LMENGE01 ) * 100 .
    ENDIF.

    READ TABLE IT_QAVE INTO WA_QAVE WITH KEY PRUEFLOS = WA_QALS-PRUEFLOS.
    IF SY-SUBRC = 0.
      WA_FINAL-VDATUM = WA_QAVE-VDATUM.

    ENDIF.

     READ TABLE LT_QPCT INTO LS_QPCT WITH KEY CODE = WA_QAVE-VCODE.
     IF SY-SUBRC = 0.
        WA_FINAL-KURZTEXT = LS_QPCT-KURZTEXT.
     ENDIF.

    CLEAR LV_F.
    CONCATENATE LV_CLINT WA_FINAL-PRUEFLOS 'L' INTO LV_NAME.

*FM to fetch reason according to inspection lot
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = LV_CLINT
        ID                      = LV_ID
        LANGUAGE                = LV_LANG
        NAME                    = LV_NAME
        OBJECT                  = LV_OBJECT
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
*   IMPORTING
*       HEADER                  =
      TABLES
        LINES                   = IT_LINE[]
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

    CLEAR SY-TABIX.
    LOOP AT IT_LINE INTO WA_LINE.

      IF SY-TABIX = '1'.
        LV_A = WA_LINE-TDLINE.
      ENDIF.

      IF SY-TABIX = '2'.
        LV_B = WA_LINE-TDLINE.
      ENDIF.

      IF SY-TABIX = '3'.
        LV_D = WA_LINE-TDLINE.
      ENDIF.

      IF SY-TABIX = '4'.
        LV_E = WA_LINE-TDLINE.
      ENDIF.

      IF SY-TABIX = '5'.
        LV_L = WA_LINE-TDLINE.
      ENDIF.

      IF SY-TABIX = '6'.
        LV_G = WA_LINE-TDLINE.
      ENDIF.

      IF SY-TABIX = '7'.
        LV_H = WA_LINE-TDLINE.
      ENDIF.

      IF SY-TABIX = '8'.
        LV_I = WA_LINE-TDLINE.
      ENDIF.

      IF SY-TABIX = '9'.
        LV_J = WA_LINE-TDLINE.
      ENDIF.

      IF SY-TABIX = '10'.
        LV_K = WA_LINE-TDLINE.
      ENDIF.

    ENDLOOP.

    CONCATENATE LV_A LV_B LV_D LV_E LV_L LV_G LV_H LV_I LV_J LV_K INTO LV_F SEPARATED BY SPACE.
    WA_FINAL-MATTXT = LV_F.


    LS_FINAL-LIFNR        = WA_FINAL-LIFNR   .
    LS_FINAL-NAME1        = WA_FINAL-NAME1   .
    LS_FINAL-SELMATNR     = WA_FINAL-SELMATNR .
    LS_FINAL-MAKTX        = WA_FINAL-MAKTX     .
    LS_FINAL-MBLNR        = WA_FINAL-MBLNR     .
*ls_final-budat        = wa_final-budat     .

    IF WA_FINAL-BUDAT IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-BUDAT
        IMPORTING
          OUTPUT = LS_FINAL-BUDAT.

      CONCATENATE LS_FINAL-BUDAT+0(2) LS_FINAL-BUDAT+2(3) LS_FINAL-BUDAT+5(4)
                      INTO LS_FINAL-BUDAT SEPARATED BY '-'.
    ENDIF.

    LS_FINAL-PRUEFLOS     = WA_FINAL-PRUEFLOS  .
*ls_final-VDATUM       = wa_final-VDATUM    .

    IF WA_FINAL-VDATUM IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-VDATUM
        IMPORTING
          OUTPUT = LS_FINAL-VDATUM.

      CONCATENATE LS_FINAL-VDATUM+0(2) LS_FINAL-VDATUM+2(3) LS_FINAL-VDATUM+5(4)
                      INTO LS_FINAL-VDATUM SEPARATED BY '-'.
    ENDIF.
*BREAK primus.
      LS_FINAL-LGPBE             = WA_FINAL-LGPBE       .
         LS_FINAL-ART               = WA_FINAL-ART.
    LS_FINAL-LMENGE01     = WA_FINAL-REC_QTY  .
    LS_FINAL-SURM_MENGE   = WA_FINAL-SURM_MENGE.
     LS_FINAL-SURJ_MENGE   = WA_FINAL-SURJ_MENGE.
    LS_FINAL-SURW_MENGE   = WA_FINAL-SURW_MENGE.
    LS_FINAL-SSRN_MENGE        = WA_FINAL-SSRN_MENGE  .
     LS_FINAL-SUSC_MENGE        = WA_FINAL-SUSC_MENGE  .
    LS_FINAL-SUTP_MENGE   = WA_FINAL-SUTP_MENGE.
    LS_FINAL-MATTXT            = WA_FINAL-MATTXT      .
    LS_FINAL-ZSERIES           = WA_FINAL-ZSERIES     .
    LS_FINAL-ZSIZE             = WA_FINAL-ZSIZE       .
    LS_FINAL-BRAND             = WA_FINAL-BRAND       .
    LS_FINAL-MOC               = WA_FINAL-MOC         .
    LS_FINAL-TYPE              = WA_FINAL-TYPE        .
    LS_FINAL-AUFNR             = WA_FINAL-AUFNR       .
    LS_FINAL-AUART             = WA_FINAL-AUART       .
    LS_FINAL-STAT              = WA_FINAL-STAT.
    LS_FINAL-DMBTR             = WA_FINAL-DMBTR.
    LS_FINAL-SGTXT1            = WA_FINAL-SGTXT1.          "Added By Snehal Rajale ON 01.02.2021
    LS_FINAL-KURZTEXT          = WA_FINAL-KURZTEXT.        "ADDED BY Snehal Rajale On 07.04.2021
     LS_FINAL-REF               = SY-DATUM.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-REF
      IMPORTING
        OUTPUT = LS_FINAL-REF.

    CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
                    INTO LS_FINAL-REF SEPARATED BY '-'.

     LS_FINAL-REF_TIME  = SY-DATUM.
    CONCATENATE LS_FINAL-REF_TIME+0(2) ':' LS_FINAL-REF_TIME+2(2)  INTO LS_FINAL-REF_TIME.
*BREAK primus.
    APPEND LS_FINAL TO LT_FINAL.
    APPEND WA_FINAL TO IT_FINAL.
    CLEAR : WA_FINAL ,LS_FINAL,LS_AUFK,WA_LFA1,WA_MAKT,WA_MARA,WA_QALS,LS_MKPF,LS_QPCT.
    REFRESH IT_LINE.
    CLEAR : WA_FINAL-MATTXT,
            LV_A,
            LV_B,
            LV_D,
            LV_E,
            LV_L,
            LV_G,
            LV_H,
            LV_I,
            LV_J,
            LV_K,
            LV_F.

  ENDLOOP.


*  LOOP AT it_mseg INTO wa_mseg.
*    wa_final-sgtxt      = wa_mseg-sgtxt.
*    wa_final-lgort      = wa_mseg-lgort.
*    IF wa_mseg-lgort = 'RM01'.
*      wa_final-rm01_menge = wa_mseg-menge.
*    ENDIF.
*    IF wa_mseg-lgort = 'TPI1'.
*      wa_final-tpi1_menge = wa_mseg-menge.
*    ENDIF.
*    IF wa_mseg-lgort = 'RJ01'.
*      wa_final-rj01_menge = wa_mseg-menge.
*    ENDIF.
*    IF wa_mseg-lgort = 'RWK1'.
*      wa_final-rwk1_menge = wa_mseg-menge.
*    ENDIF.
*    IF wa_mseg-lgort = 'SCR1'.
*      wa_final-scr1_menge = wa_mseg-menge.
*    ENDIF.
*    IF wa_mseg-lgort = 'SRN1'.
*      wa_final-srn1_menge = wa_mseg-menge.
*    ENDIF.
*
*    READ TABLE it_qamb INTO wa_qamb WITH KEY mblnr = wa_mseg-mblnr  mjahr = wa_mseg-mjahr.
*    IF sy-subrc = 0.
*      wa_final-prueflos = wa_qamb-prueflos.
*    ENDIF.
*
*    READ TABLE it_qals INTO wa_qals WITH KEY prueflos = wa_qamb-prueflos.
*    IF sy-subrc = 0.
*      wa_final-lifnr    = wa_qals-lifnr.
*      wa_final-selmatnr = wa_qals-selmatnr.
*      wa_final-mblnr    = wa_qals-mblnr.
*      wa_final-mjahr    = wa_qals-mjahr.
*      wa_final-budat    = wa_qals-budat.
*      wa_final-lmenge01 = wa_qals-lmenge01.
*      wa_final-aufnr    = wa_qals-aufnr.
*      wa_final-art      = wa_qals-art.
*    ENDIF.
*
*    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_final-selmatnr .
*    IF sy-subrc = 0.
*      wa_final-moc      = wa_mara-moc     .
*      wa_final-type     = wa_mara-type    .
*      wa_final-zseries  = wa_mara-zseries .
*      wa_final-zsize    = wa_mara-zsize   .
*      wa_final-brand_id = wa_mara-brand_id.
*    ENDIF.
*
*    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_final-selmatnr .
*    IF sy-subrc = 0.
*      wa_final-maktx = wa_makt-maktg.
*    ENDIF.
*
*    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_final-lifnr .
*    IF sy-subrc = 0.
*      wa_final-name1 = wa_lfa1-name1.
*    ENDIF.
*
*    READ TABLE it_mard INTO wa_mard WITH KEY matnr = wa_mseg-matnr lgort = wa_mseg-lgort  .
*    IF sy-subrc = 0.
*      wa_final-lgpbe = wa_mard-lgpbe.
*    ENDIF.
*    IF wa_final-lmenge01 IS NOT INITIAL.
*      wa_final-rew_qty   =  ( wa_final-rwk1_menge / wa_final-lmenge01 ) * 100.
*      wa_final-total_rej = ( ( wa_final-rwk1_menge + wa_final-rj01_menge + wa_final-scr1_menge ) /  wa_final-lmenge01 ) * 100 .
*    ENDIF.
*
*    APPEND wa_final TO it_final.
*    CLEAR : wa_final.
*  ENDLOOP.

*    BREAK-POINT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FIELDCAT .

  LS_FCAT-COL_POS   = '1'.
  LS_FCAT-FIELDNAME = 'LIFNR'.
  LS_FCAT-SELTEXT_M = 'VENDOR'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS  = '2'.
  LS_FCAT-FIELDNAME = 'NAME1'.
  LS_FCAT-SELTEXT_M = 'VENDOR NAME'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '3'.
  LS_FCAT-FIELDNAME = 'SELMATNR'.
  LS_FCAT-SELTEXT_M = 'ITEM CODE'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '4'.
  LS_FCAT-FIELDNAME = 'MAKTX'.
  LS_FCAT-SELTEXT_M = 'ITEM DESCRIPTION'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.
*
*  ls_fcat-col_pos   = '5'.
*  ls_fcat-fieldname = 'MAKTX'.
*  ls_fcat-seltext_m = 'ITEM DESCRIPTION'.
*  APPEND  ls_fcat TO lt_fcat.
*  CLEAR ls_fcat.

  LS_FCAT-COL_POS   = '5'.
  LS_FCAT-FIELDNAME = 'MBLNR'.
  LS_FCAT-SELTEXT_M = 'MATERIAL DOCUMENT'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '6'.
  LS_FCAT-FIELDNAME = 'BUDAT'.
  LS_FCAT-SELTEXT_M = 'MATERIAL DOC DATE'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '7'.
  LS_FCAT-FIELDNAME = 'PRUEFLOS'.
  LS_FCAT-SELTEXT_M = 'INSPECTION LOT'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '8'.
  LS_FCAT-FIELDNAME = 'VDATUM'."vdatum'.               "'BUDAT'.
  LS_FCAT-SELTEXT_M = 'INSPECTION DATE'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '10'.
  LS_FCAT-FIELDNAME = 'ART'."vdatum'.               "'BUDAT'.
  LS_FCAT-SELTEXT_M = 'INSPECTION TYPE'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.


  LS_FCAT-COL_POS   = '11'.
*  ls_fcat-fieldname = 'LMENGE01'.
  LS_FCAT-FIELDNAME = 'REC_QTY'.
  LS_FCAT-SELTEXT_M = 'RECEIVED QTY'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '12'.
  LS_FCAT-FIELDNAME = 'SURM_MENGE'.
  LS_FCAT-SELTEXT_M = 'ACCEPTED QTY'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '17'.
  LS_FCAT-FIELDNAME = 'SUTP_MENGE'.
  LS_FCAT-SELTEXT_M = 'TPI STOCK'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '13'.
  LS_FCAT-FIELDNAME = 'SURJ_MENGE'.
  LS_FCAT-SELTEXT_M = 'REJECTED QTY'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '14'.
  LS_FCAT-FIELDNAME = 'SURW_MENGE'.
  LS_FCAT-SELTEXT_M = 'REWORK QTY'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '09'.
  LS_FCAT-FIELDNAME = 'LGPBE'.
  LS_FCAT-SELTEXT_M = 'STORAGE BIN'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

*  LS_FCAT-COL_POS   = '16'.
*  LS_FCAT-FIELDNAME = 'REW_QTY'.
*  LS_FCAT-SELTEXT_M = 'REWORK %'.
*  APPEND  LS_FCAT TO LT_FCAT.
*  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '16'.
  LS_FCAT-FIELDNAME = 'SUSC_MENGE'.
  LS_FCAT-SELTEXT_M = 'SCRAP QTY'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '15'.
  LS_FCAT-FIELDNAME = 'SSRN_MENGE'.
  LS_FCAT-SELTEXT_M = 'SRN QTY'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

*  ls_fcat-col_pos   = '19'.
*  ls_fcat-fieldname = 'SRN1_MENGE'.
*  ls_fcat-seltext_m = 'SRN QTY'.
*  APPEND  ls_fcat TO lt_fcat.
*  CLEAR ls_fcat.

*  LS_FCAT-COL_POS   = '19'.
*  LS_FCAT-FIELDNAME = 'TOTAL_REJ'.
*  LS_FCAT-SELTEXT_M = 'TOTAL REJ%'.
*  APPEND  LS_FCAT TO LT_FCAT.
*  CLEAR LS_FCAT.

*  LS_FCAT-COL_POS   = '20'.
**  ls_fcat-fieldname = 'SRN1_MENGE'.
*  LS_FCAT-FIELDNAME = 'SRN_VENDOR'.  ".srn_vendor'.
*  LS_FCAT-SELTEXT_M = 'SRN VENDOR'.
*  APPEND  LS_FCAT TO LT_FCAT.
*  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '18'.
  LS_FCAT-FIELDNAME = 'MATTXT'. "'mattxt'.
  LS_FCAT-SELTEXT_M = 'REASON'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '19'.
  LS_FCAT-FIELDNAME = 'ZSERIES'.
  LS_FCAT-SELTEXT_M = 'SERIES CODE'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '20'.
  LS_FCAT-FIELDNAME = 'ZSIZE'.
  LS_FCAT-SELTEXT_M = 'SIZE'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '21'.
  LS_FCAT-FIELDNAME = 'BRAND'.
  LS_FCAT-SELTEXT_M = 'BRAND'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '22'.
  LS_FCAT-FIELDNAME = 'MOC'.
  LS_FCAT-SELTEXT_M = 'MOC'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '23'.
  LS_FCAT-FIELDNAME = 'TYPE'.
  LS_FCAT-SELTEXT_M = 'TYPE'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '24'.
  LS_FCAT-FIELDNAME = 'AUFNR'.
  LS_FCAT-SELTEXT_M = 'ORDER NO'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '25'.
  LS_FCAT-FIELDNAME = 'AUART'.
  LS_FCAT-SELTEXT_M = 'ORDER TYPE'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '26'.
  LS_FCAT-FIELDNAME = 'STAT'.
  LS_FCAT-SELTEXT_M = 'SYSTEM STATUS'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '27'.
  LS_FCAT-FIELDNAME = 'DMBTR'.
  LS_FCAT-SELTEXT_M = 'GRN VALUE'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '28'.               "Added By Snehal Rajale ON 01.02.2021
  LS_FCAT-FIELDNAME = 'SGTXT1'.
  LS_FCAT-SELTEXT_M = 'TEXT'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS   = '29'.               "Added By Snehal Rajale ON 07.04.2021
  LS_FCAT-FIELDNAME = 'KURZTEXT'.
  LS_FCAT-SELTEXT_M = 'UD Code Description'.
  APPEND  LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

*  LS_LAYOUT-EDIT = 'X'.
  LS_LAYOUT-ZEBRA = 'X'.
  LS_LAYOUT-COLWIDTH_OPTIMIZE = 'X' .



ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPDATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPDATA .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      I_CALLBACK_PROGRAM     = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      I_CALLBACK_TOP_OF_PAGE = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      IS_LAYOUT              = LS_LAYOUT
      IT_FIELDCAT            = LT_FCAT
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
*     I_SAVE                 = 'X'
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*    IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      T_OUTTAB               = IT_FINAL
*    EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.

ENDFORM.


FORM TOP.
*  BREAK-POINT.
  DATA: LT_LISTHEADER TYPE TABLE OF SLIS_LISTHEADER,
        LS_LISTHEADER TYPE SLIS_LISTHEADER,
        LS_MONTH_NAME TYPE T7RU9A-REGNO,
        GS_STRING     TYPE STRING,
        GS_MONTH(2)   TYPE N,
        T_LINE        LIKE LS_LISTHEADER-INFO,
        LD_LINES      TYPE I,
        LD_LINESC(10) TYPE C.

  REFRESH LT_LISTHEADER.
  CLEAR LS_LISTHEADER.

  LS_LISTHEADER-TYP = 'S'.
  LS_LISTHEADER-INFO =  '. '.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.

  GS_STRING = ''.
  GS_MONTH = SY-DATUM+4(2).
  CALL FUNCTION 'HR_RU_MONTH_NAME_IN_GENITIVE'
    EXPORTING
      MONTH = GS_MONTH
    IMPORTING
      NAME  = LS_MONTH_NAME.
*
  TRANSLATE LS_MONTH_NAME TO UPPER CASE.
*  CONCATENATE 'DAILY DISPATCH REPORT'." LS_MONTH_NAME SY-DATUM+0(4) INTO GS_STRING SEPARATED BY ' '.
  LS_LISTHEADER-TYP = 'H'.
  LS_LISTHEADER-INFO = 'VENDOR REJECTION REPORT'."GS_STRING.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.

  GS_STRING = ''.
  CONCATENATE 'REPORT DATE :' SY-DATUM+6(2) '.' SY-DATUM+4(2) '.' SY-DATUM+0(4) INTO GS_STRING SEPARATED BY ''.
  LS_LISTHEADER-TYP = 'S'.
  LS_LISTHEADER-INFO =  GS_STRING.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.

  GS_STRING = ''.
  LS_LISTHEADER-TYP = 'S'.
  LS_LISTHEADER-INFO =  GS_STRING.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.


  DESCRIBE TABLE IT_FINAL LINES LD_LINES.
  LD_LINESC = LD_LINES.

  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' LD_LINESC
   INTO T_LINE SEPARATED BY SPACE.

  LS_LISTHEADER-TYP  = 'A'.
  LS_LISTHEADER-INFO = T_LINE.
  APPEND LS_LISTHEADER TO LT_LISTHEADER.
  CLEAR: LS_LISTHEADER, T_LINE.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = LT_LISTHEADER
      I_LOGO             = 'NEW_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
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
*BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = LT_FINAL
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
  LV_FILE = 'ZSU_VREJ.TXT'.

*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.
*BREAK primus.
  WRITE: / 'ZSU_VREJ Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1244 TYPE string.
DATA lv_crlf_1244 TYPE string.
lv_crlf_1244 = cl_abap_char_utilities=>cr_lf.
lv_string_1244 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1244 lv_crlf_1244 wa_csv INTO lv_string_1244.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1244 TO lv_fullfile.
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
FORM CVS_HEADER  USING PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'VENDOR'
              'VENDOR NAME'
              'ITEM CODE'
              'ITEM DESCRIPTION'
              'MATERIAL DOCUMENT'
              'MATERIAL DOC DATE'
              'INSPECTION LOT'
              'INSPECTION DATE'
              'STORAGE BIN'
              'INSPECTION TYPE'
              'RECEIVED QTY'
              'ACCEPTED QTY'
              'REJECTED QTY'
              'REWORK QTY'
              'SRN QTY'
            'SCRAP QTY'
              'TPI STOCK'
*              'TOTAL REJ%'
*              'SRN VENDOR'
              'REASON'
              'SERIES CODE'
              'SIZE'
              'BRAND'
              'MOC'
              'TYPE'
              'ORDER NO'
              'ORDER TYPE'
              'SYSTEM STATUS'
              'GRN VALUE'
              'TEXT'
              'UD Code Description'
              'Refresh Date'
              'Refresh Time'
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
