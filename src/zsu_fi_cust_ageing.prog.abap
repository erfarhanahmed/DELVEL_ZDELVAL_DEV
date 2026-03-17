*&---------------------------------------------------------------------*
*&Report: ZSU_FI_CUST_AGEING
*&Transaction: ZCUSTAGE
*&Functional Cosultant: Aishwary Kadam
*&Technical Consultant: Nilay Brahme
*&TR:
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*

REPORT  ZSU_FI_CUST_AGEING
        NO STANDARD PAGE HEADING LINE-COUNT 300.

** **************TABLE DECLARATION
TABLES:BSID.
DATA:
   TMP_KUNNR TYPE KNA1-KUNNR.
*TABLES: bsid,kna1, bsad, knb1.
TYPE-POOLS : SLIS.

**************DATA DECLARATION

DATA : DATE1 TYPE SY-DATUM, DATE2 TYPE SY-DATUM, DATE3 TYPE I.

DATA   FS_LAYOUT TYPE SLIS_LAYOUT_ALV.
DATA : FM_NAME TYPE RS38L_FNAM.
DATA : T_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE.

*Internal Table for sorting
DATA T_SORT TYPE SLIS_T_SORTINFO_ALV WITH HEADER LINE.


TYPES:
  BEGIN OF T_KNVV,
    KUNNR TYPE KNVV-KUNNR,
    VKBUR TYPE KNVV-VKBUR,
  END OF T_KNVV,
  TT_KNVV TYPE STANDARD TABLE OF T_KNVV.

TYPES:
  BEGIN OF T_TVKBT,
    VKBUR TYPE TVKBT-VKBUR,
    BEZEI TYPE TVKBT-BEZEI,
  END OF T_TVKBT,
  TT_TVKBT TYPE STANDARD TABLE OF T_TVKBT.

TYPES:
  BEGIN OF T_VBRK,
    VBELN TYPE VBRK-VBELN,
    FKDAT TYPE VBRK-FKDAT,
  END OF T_VBRK,
  TT_VBRK TYPE STANDARD TABLE OF T_VBRK.

TYPES:
  BEGIN OF T_VBRP,
    VBELN TYPE VBRP-VBELN,
    AUBEL TYPE VBRP-AUBEL,
  END OF T_VBRP,
  TT_VBRP TYPE STANDARD TABLE OF T_VBRP.

TYPES:
  BEGIN OF T_SKAT,
    SAKNR TYPE SKAT-SAKNR,
    TXT50 TYPE SKAT-TXT50,
  END OF T_SKAT,
  TT_SKAT TYPE STANDARD TABLE OF T_SKAT.

TYPES:
  BEGIN OF T_VBAK,
    VBELN TYPE VBAK-VBELN,
    AUDAT TYPE VBAK-AUDAT,
    BSTNK TYPE VBAK-BSTNK,
    BSTDK TYPE VBAK-BSTDK,
  END OF T_VBAK,
  TT_VBAK TYPE STANDARD TABLE OF T_VBAK.

TYPES:BEGIN OF TY_VBKD,
        VBELN TYPE VBKD-VBELN,
        POSNR TYPE VBKD-POSNR,
        BSTKD TYPE VBKD-BSTKD,
      END OF TY_VBKD.
DATA : IT_VBKD TYPE TABLE OF TY_VBKD,
       WA_VBKD TYPE          TY_VBKD.


TYPES:
  BEGIN OF T_TVZBT,
    ZTERM TYPE TVZBT-ZTERM,
    VTEXT TYPE TVZBT-VTEXT,
  END OF T_TVZBT,
  TT_TVZBT TYPE STANDARD TABLE OF T_TVZBT.


TYPES: BEGIN OF IDATA ,
         NAME1      LIKE KNA1-NAME1,          "custmor Name
         KTOKD      LIKE KNA1-KTOKD,          " customer account group
         KUNNR      LIKE BSID-KUNNR,          "Customer Code
         SHKZG      LIKE BSID-SHKZG,          "debit/credit s/h
         BUKRS      LIKE BSID-BUKRS,          "Company Code
         AUGBL      LIKE BSID-AUGBL,          "Clearing Doc No
         AUGGJ      LIKE BSID-AUGGJ,
         AUGDT      LIKE BSID-AUGDT,          "Clearing Date
         GJAHR      LIKE BSID-GJAHR,          "Fiscal year
         BELNR      LIKE BSID-BELNR,          "Document no.
         UMSKZ      LIKE BSID-UMSKZ,          "Special G/L indicator
         BUZEI      LIKE BSID-BUZEI,          "Line item no.
         BUDAT      LIKE BSID-BUDAT,          "Posting date in the document
         BLDAT      LIKE BSID-BLDAT,          "Document date in document
         WAERS      LIKE BSID-WAERS,          "Currency
         BLART      LIKE BSID-BLART,          "Doc. Type
         XBLNR      TYPE BSID-XBLNR,          "ODN
         DMBTR      LIKE BSID-DMBTR,          "Amount in local curr.
         WRBTR      LIKE BSID-WRBTR,          "Amount in local curr.
         REBZG      LIKE BSID-REBZG,          "refr inv no
         REBZJ      LIKE BSID-REBZJ,          "Fiscal year
         REBZZ      LIKE BSID-REBZZ,          "Line Item no
         VBELN      TYPE BSAD-VBELN,          "Invoice Number
         DUEDATE    LIKE BSID-AUGDT,        "Due Date
         ZTERM      LIKE BSID-ZTERM,         "Payment Term
*         zbd1t     LIKE bsid-zbd1t,         "Cash Discount Days 1
         DAY        TYPE I,
         DAY1        TYPE I,
         DEBIT      LIKE BSID-DMBTR,         "Amount in local curr.
         CREDIT     LIKE BSID-DMBTR,         "Amount in local curr.
         DEBIT1      LIKE BSID-DMBTR,         "Amount in local curr.
         CREDIT1      LIKE BSID-DMBTR,         "Amount in local curr.
         NETBAL     LIKE BSID-DMBTR,         "Amount in local curr.
         NETBAL1     LIKE BSID-DMBTR,         "Amount in local curr.
         NOT_DUE_CR TYPE BSID-DMBTR,        "Amount in local curr.
         NOT_DUE_DB TYPE BSID-DMBTR,        "Amount in local curr.
         NOT_DUE    TYPE BSID-DMBTR,        "Amount in local curr.
         DEBIT30    LIKE BSID-DMBTR,        "Amount in local curr.
         CREDIT30   LIKE BSID-DMBTR,       "Amount in local curr.
         NETB30     LIKE BSID-DMBTR,         "Amount in local curr.
         DEBIT60    LIKE BSID-DMBTR,        "Amount in local curr.
         CREDIT60   LIKE BSID-DMBTR,       "Amount in local curr.
         NETB60     LIKE BSID-DMBTR,         "Amount in local curr.
         DEBIT90    LIKE BSID-DMBTR,        "Amount in local curr.
         CREDIT90   LIKE BSID-DMBTR,       "Amount in local curr.
         NETB90     LIKE BSID-DMBTR,         "Amount in local curr.
         DEBIT120   LIKE BSID-DMBTR,       "Amount in local curr.
         CREDIT120  LIKE BSID-DMBTR,      "Amount in local curr.
         NETB120    LIKE BSID-DMBTR,         "Amount in local curr.
         DEBIT180   LIKE BSID-DMBTR,       "Amount in local curr.
         CREDIT180  LIKE BSID-DMBTR,      "Amount in local curr.
         NETB180    LIKE BSID-DMBTR,         "Amount in local curr.
         DEBIT360   LIKE BSID-DMBTR,       "Amount in local curr.
         CREDIT360  LIKE BSID-DMBTR,      "Amount in local curr.
         NETB360    LIKE BSID-DMBTR,         "Amount in local curr.
         DEBIT720   LIKE BSID-DMBTR,       "Amount in local curr.
         CREDIT720  LIKE BSID-DMBTR,      "Amount in local curr.
         NETB720    LIKE BSID-DMBTR,         "Amount in local curr.
         DEBIT730   LIKE BSID-DMBTR,       "Amount in local curr.
         CREDIT730  LIKE BSID-DMBTR,      "Amount in local curr.
         NETB730    LIKE BSID-DMBTR,         "Amount in local curr.
         DEBIT_AB   LIKE BSID-DMBTR,       "Amount in local curr.
         CREDIT_AB  LIKE BSID-DMBTR,      "Amount in local curr.
         NETB_AB    LIKE BSID-DMBTR,         "Amount in local curr.
         TDISP      TYPE STRING,
         GROUP      TYPE STRING,
         AKONT      TYPE KNB1-AKONT,
         ZFBDT      TYPE BSID-ZFBDT,
         ZBD1T      TYPE BSID-ZBD1T,
         ZBD2T      TYPE BSID-ZBD2T,
         ZBD3T      TYPE BSID-ZBD3T,
         CURR       TYPE BSID-DMBTR,
         BEZEI      TYPE TVKBT-BEZEI,
         FKDAT      TYPE VBRK-FKDAT,
         AUBEL      TYPE VBRP-AUBEL,
         AUDAT      TYPE VBAK-AUDAT,
         BSTNK      TYPE VBAK-BSTNK,
         BSTDK      TYPE VBAK-BSTDK,
         VTEXT      TYPE CHAR200,
         TXT50      TYPE STRING,
         REC_TXT    TYPE CHAR70,     "Reconcilation Account text
         DEBIT1000  LIKE BSID-DMBTR,
         CREDIT1000 LIKE BSID-DMBTR,
         NETB1000   LIKE BSID-DMBTR,
         SALE       TYPE CHAR10,
         SALE_OFF   TYPE CHAR50,
         BSTKD      TYPE VBKD-BSTKD,
       END OF IDATA.

TYPES : BEGIN OF TY_DOWN,
          GROUP    TYPE STRING,
          SALE     TYPE CHAR10,
          SALE_OFF TYPE CHAR50,
          KUNNR    TYPE CHAR15,
          TDISP    TYPE STRING,
          BLDAT    TYPE CHAR11,
          BUDAT    TYPE CHAR11,
          AKONT    TYPE CHAR50,
*         REC_TXT  TYPE CHAR100,
          DUEDATE  TYPE CHAR11,
          BLART    TYPE CHAR10,
          BELNR    TYPE CHAR15,
          VBELN    TYPE CHAR20,
*          XBLNR    TYPE CHAR20,
          FKDAT    TYPE CHAR11,
          VTEXT    TYPE CHAR200,
          AUBEL    TYPE CHAR15,
          AUDAT    TYPE CHAR11,
          BSTKD    TYPE CHAR50,
          BSTDK    TYPE CHAR11,
          CURR     TYPE CHAR15,
          WAERS    TYPE CHAR10,
          DEBIT    TYPE CHAR15,
          DEBIT1    TYPE CHAR15,
          CREDIT   TYPE CHAR15,
          CREDIT1   TYPE CHAR15,
          NETBAL   TYPE CHAR15,
          NETBAL1   TYPE CHAR15,
          NOT_DUE  TYPE CHAR15,
          NETB30   TYPE CHAR15,
          NETB60   TYPE CHAR15,
          NETB90   TYPE CHAR15,
          NETB120  TYPE CHAR15,
          NETB180  TYPE CHAR15,
          NETB360  TYPE CHAR15,
          NETB720  TYPE CHAR15,
          NETB1000 TYPE CHAR15,
          DAY      TYPE CHAR15,
          DAY1      TYPE CHAR15,
          REF      TYPE CHAR11,
          REF_TIME TYPE CHAR15,
        END OF TY_DOWN.

DATA : IT_DOWN TYPE TABLE OF TY_DOWN,
       WA_DOWN TYPE          TY_DOWN,

       LT_OFIC TYPE TABLE OF TY_DOWN,
       LS_OFIC TYPE          TY_DOWN,

       LT_MAIL TYPE TABLE OF ZCUST_MAIL,
       LS_MAIL TYPE          ZCUST_MAIL.

DATA: RP01(3) TYPE N,                                     "   0
      RP02(3) TYPE N,                                     "  20
      RP03(3) TYPE N,                                     "  40
      RP04(3) TYPE N,                                     "  80
      RP05(3) TYPE N,                                     " 100
      RP06(3) TYPE N,                                     "   1
      RP07(3) TYPE N,                                     "  21
      RP08(3) TYPE N,                                     "  41
      RP09(3) TYPE N,                                     "  81
      RP10(3) TYPE N,                                     " 101
      RP11(3) TYPE N,                                     " 101
      RP12(3) TYPE N,                                     " 101
      RP13(3) TYPE N,                                     " 101
      RP14(3) TYPE N.                                     " 101

DATA: RC01(14) TYPE C,                                     "  0
      RC02(14) TYPE C,                                    "  20
      RC03(14) TYPE C,                                    "  40
      RC04(14) TYPE C,                                    "  80
      RC05(14) TYPE C,                                    " 100
      RC06(14) TYPE C,                                    "   1
      RC07(14) TYPE C,                                    "  21
      RC08(14) TYPE C,                                    "  41
      RC09(14) TYPE C,                                    "  81
      RC10(14) TYPE C,                                    " 101
      RC11(14) TYPE C,                                    " 101
      RC12(14) TYPE C,                                    " 101
      RC13(14) TYPE C,                                    " 101
      RC14(20) TYPE C,                                    " 101
      RC15(20) TYPE C,                                    " 101
      RC16(20) TYPE C,                                    " 101
      RC17(20) TYPE C,                                    " 101
      RC18(30) TYPE C,                                    " 101
      RC19(30) TYPE C,                                    " 101
      RC20(30) TYPE C,                                    " 101
      RC21(30) TYPE C,                                    " 101
      RC22(30) TYPE C,                                    " 101
      RC23(30) TYPE C.                                    " 101

DATA: ITAB  TYPE IDATA OCCURS 0 WITH HEADER LINE.

******************SELECTION SCREEN

SELECTION-SCREEN BEGIN OF BLOCK A1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: PLANT FOR BSID-BUKRS  DEFAULT 'SU00' NO INTERVALS MODIF ID BU.
SELECT-OPTIONS: KUNNR FOR TMP_KUNNR.
*                akont FOR knb1-akont.
PARAMETERS: DATE  LIKE BSID-BUDAT DEFAULT SY-DATUM OBLIGATORY.                "no-extension obligatory.
SELECTION-SCREEN BEGIN OF LINE.

SELECTION-SCREEN COMMENT 01(30) TEXT-026 FOR FIELD RASTBIS1.

SELECTION-SCREEN POSITION POS_LOW.

PARAMETERS: RASTBIS1 LIKE RFPDO1-ALLGROGR DEFAULT '000'.
PARAMETERS: RASTBIS2 LIKE RFPDO1-ALLGROGR DEFAULT '030'.
PARAMETERS: RASTBIS3 LIKE RFPDO1-ALLGROGR DEFAULT '060'.
PARAMETERS: RASTBIS4 LIKE RFPDO1-ALLGROGR DEFAULT '090'.
PARAMETERS: RASTBIS5 LIKE RFPDO1-ALLGROGR DEFAULT '180'.
PARAMETERS: RASTBIS6 LIKE RFPDO1-ALLGROGR DEFAULT '360'.
PARAMETERS: RASTBIS7 LIKE RFPDO1-ALLGROGR DEFAULT '720'.

SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK A1.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME.
PARAMETERS: R1 RADIOBUTTON GROUP ABC DEFAULT 'X',
            R2 RADIOBUTTON GROUP ABC.
SELECTION-SCREEN: END OF BLOCK B1.
***********************Initialization.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'. "'E:/delval/Saudi'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003 .
PARAMETERS P_MAIL AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK B3.

SELECTION-SCREEN :BEGIN OF BLOCK B4 WITH FRAME TITLE TEXT-005.
SELECTION-SCREEN  COMMENT /1(60) TEXT-006.
SELECTION-SCREEN COMMENT /1(70) TEXT-007.
SELECTION-SCREEN: END OF BLOCK B4.




INITIALIZATION.

**************************************************
AT SELECTION-SCREEN.

  IF RASTBIS1 GT '998'
  OR RASTBIS2 GT '998'
  OR RASTBIS3 GT '998'
  OR RASTBIS4 GT '998'
  OR RASTBIS5 GT '998'
  OR RASTBIS6 GT '998'
  OR RASTBIS7 GT '998'.

    SET CURSOR FIELD RASTBIS7.
    MESSAGE 'Enter a consistent sorted list' TYPE 'E'.      "e381.
  ENDIF.
  IF NOT RASTBIS7 IS INITIAL.
    IF  RASTBIS7 GT RASTBIS6
    AND RASTBIS6 GT RASTBIS5
    AND RASTBIS5 GT RASTBIS4
    AND RASTBIS4 GT RASTBIS3
    AND RASTBIS3 GT RASTBIS2
    AND RASTBIS2 GT RASTBIS1.
    ELSE.
      MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
    ENDIF.
  ELSE.
    IF NOT RASTBIS6 IS INITIAL.
      IF  RASTBIS6 GT RASTBIS5
      AND RASTBIS5 GT RASTBIS4
      AND RASTBIS4 GT RASTBIS3
      AND RASTBIS3 GT RASTBIS2
      AND RASTBIS2 GT RASTBIS1.
      ELSE.
        MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
      ENDIF.
    ELSE.
      IF NOT RASTBIS5 IS INITIAL.
        IF  RASTBIS5 GT RASTBIS4
        AND RASTBIS4 GT RASTBIS3
        AND RASTBIS3 GT RASTBIS2
        AND RASTBIS2 GT RASTBIS1.
        ELSE.
          MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
        ENDIF.
      ELSE.
        IF NOT RASTBIS4 IS INITIAL.
          IF  RASTBIS4 GT RASTBIS3
          AND RASTBIS3 GT RASTBIS2
          AND RASTBIS2 GT RASTBIS1.
          ELSE.
            MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
          ENDIF.
        ELSE.
          IF NOT RASTBIS3 IS INITIAL.
            IF  RASTBIS3 GT RASTBIS2
            AND RASTBIS2 GT RASTBIS1.
            ELSE.
              MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
            ENDIF.
          ELSE.
            IF NOT RASTBIS2 IS INITIAL.
              IF  RASTBIS2 GT RASTBIS1.
              ELSE.
                MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
              ENDIF.
            ELSE.
*         nichts zu tun
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.


  RP01 = RASTBIS1.
  RP02 = RASTBIS2.
  RP03 = RASTBIS3.
  RP04 = RASTBIS4.
  RP05 = RASTBIS5.
  RP06 = RASTBIS6.
  RP07 = RASTBIS7.

  RP08 = RP01 + 1.
  IF NOT RP02 IS INITIAL.
    RP09 = RP02 + 1.
  ELSE.
    RP09 = ''.
  ENDIF.
  IF NOT RP03 IS INITIAL.
    RP10 = RP03 + 1.
  ELSE.
    RP10 = ''.
  ENDIF.
  IF NOT RP04 IS INITIAL.
    RP11 = RP04 + 1.
  ELSE.
    RP11 = ''.
  ENDIF.
  IF NOT RP05 IS INITIAL.
    RP12 = RP05 + 1.
  ELSE.
    RP12 = ''.
  ENDIF.
  IF NOT RP06 IS INITIAL.
    RP13 = RP06 + 1.
  ELSE.
    RP13 = ''.
  ENDIF.
  IF NOT RP07 IS INITIAL.
    RP14 = RP07 + 1.
  ELSE.
    RP14 = ''.
  ENDIF.

  IF NOT RP01 IS INITIAL.
    CONCATENATE 'Upto'    RP01 'Dr' INTO RC01 SEPARATED BY SPACE.
    CONCATENATE 'Upto'    RP01 'Cr' INTO RC08 SEPARATED BY SPACE.
    CONCATENATE '000 to'  RP01 'Days' INTO RC17 SEPARATED BY SPACE.
  ELSE.
    CONCATENATE 'Upto'    RP01 'Dr' INTO RC01 SEPARATED BY SPACE.
    CONCATENATE 'Upto'    RP01 'Cr' INTO RC08 SEPARATED BY SPACE.
    CONCATENATE RP01 'Days' INTO RC17 SEPARATED BY SPACE.
  ENDIF.


  IF NOT RP02 IS INITIAL.
    CONCATENATE RP08 'To' RP02 'Dr' INTO RC02 SEPARATED BY SPACE.
    CONCATENATE RP08 'To' RP02 'Cr' INTO RC09 SEPARATED BY SPACE.
    CONCATENATE RP08 'To' RP02 'Days' INTO RC18 SEPARATED BY SPACE.
  ELSEIF RP03 IS INITIAL.
    CONCATENATE RP08 '& Above' 'Dr' INTO RC02 SEPARATED BY SPACE.
    CONCATENATE RP08 '& Above' 'Cr' INTO RC09 SEPARATED BY SPACE.
    CONCATENATE RP08 'Days' INTO RC18 SEPARATED BY SPACE.
  ENDIF.

  IF NOT RP03 IS INITIAL.
    CONCATENATE RP09 'To' RP03 'Dr' INTO RC03 SEPARATED BY SPACE.
    CONCATENATE RP09 'To' RP03 'Cr' INTO RC10 SEPARATED BY SPACE.
    CONCATENATE RP09 'To' RP03 'Days' INTO RC19 SEPARATED BY SPACE.
  ELSEIF RP02 IS INITIAL.
    RC03 = ''.
    RC08 = ''.
    RC15 = ''.
  ELSEIF RP04 IS INITIAL.
    CONCATENATE RP09 '& Above' 'Dr' INTO RC03 SEPARATED BY SPACE.
    CONCATENATE RP09 '& Above' 'Cr' INTO RC10 SEPARATED BY SPACE.
    CONCATENATE RP09 'Days' INTO RC19 SEPARATED BY SPACE.
  ENDIF.

  IF NOT RP04 IS INITIAL .
    CONCATENATE RP10 'To' RP04 'Dr' INTO RC04 SEPARATED BY SPACE.
    CONCATENATE RP10 'To' RP04 'Cr' INTO RC11 SEPARATED BY SPACE.
    CONCATENATE RP10 'To' RP04 'Days' INTO RC20 SEPARATED BY SPACE.
  ELSEIF RP03 IS INITIAL.
    RC04 = ''.
    RC09 = ''.
    RC16 = ''.
  ELSEIF RP05 IS INITIAL.
    CONCATENATE RP10 '& Above' 'Dr' INTO RC04 SEPARATED BY SPACE.
    CONCATENATE RP10 '& Above' 'Cr' INTO RC11 SEPARATED BY SPACE.
*    CONCATENATE rp08 '& Above' 'Net Bal' INTO rc16 SEPARATED BY space.
    CONCATENATE RP10 'Days' INTO RC20 SEPARATED BY SPACE.
  ENDIF.

  IF NOT RP05 IS INITIAL.
    CONCATENATE RP11 'To' RP05 'Dr' INTO RC05 SEPARATED BY SPACE.
    CONCATENATE RP11 'To' RP05 'Cr' INTO RC12 SEPARATED BY SPACE.
*    CONCATENATE rp09 'To' rp05 'Net Bal' INTO rc17 SEPARATED BY space.
    CONCATENATE RP11 'To' RP05 'Days' INTO RC21 SEPARATED BY SPACE.
  ELSEIF RP04 IS INITIAL.
    RC05 = ''.
    RC10 = ''.
    RC17 = ''.
  ELSE.
    CONCATENATE RP11 '& Above' 'Dr' INTO RC05 SEPARATED BY SPACE.
    CONCATENATE RP11 '& Above' 'Cr' INTO RC12 SEPARATED BY SPACE.
    CONCATENATE RP11 'Days' INTO RC21 SEPARATED BY SPACE.
  ENDIF.


  IF NOT RP06 IS INITIAL.
    CONCATENATE RP12 'To' RP06 'Dr' INTO RC06 SEPARATED BY SPACE.
    CONCATENATE RP12 'To' RP06 'Cr' INTO RC13 SEPARATED BY SPACE.
*    CONCATENATE rp09 'To' rp05 'Net Bal' INTO rc17 SEPARATED BY space.
    CONCATENATE RP12 'To' RP06 'Days' INTO RC22 SEPARATED BY SPACE.
  ELSEIF RP05 IS INITIAL.
    RC05 = ''.
    RC10 = ''.
    RC17 = ''.
  ELSE.
    CONCATENATE RP12 '& Above' 'Dr' INTO RC06 SEPARATED BY SPACE.
    CONCATENATE RP12 '& Above' 'Cr' INTO RC13 SEPARATED BY SPACE.
    CONCATENATE RP12 'Days' INTO RC22 SEPARATED BY SPACE.
  ENDIF.


  IF NOT RP07 IS INITIAL.
    CONCATENATE RP13 'To' RP07 'Dr' INTO RC07 SEPARATED BY SPACE.
    CONCATENATE RP13 'To' RP07 'Cr' INTO RC14 SEPARATED BY SPACE.
*    CONCATENATE rp09 'To' rp05 'Net Bal' INTO rc17 SEPARATED BY space.
    CONCATENATE RP13 'To' RP07 'Days' INTO RC23 SEPARATED BY SPACE.
  ELSEIF RP06 IS INITIAL.
    RC05 = ''.
    RC10 = ''.
    RC17 = ''.
  ELSE.
    CONCATENATE RP13 '& Above' 'Dr' INTO RC07 SEPARATED BY SPACE.
    CONCATENATE RP13 '& Above' 'Cr' INTO RC14 SEPARATED BY SPACE.
    CONCATENATE RP13 'Days' INTO RC23 SEPARATED BY SPACE.
  ENDIF.

  IF NOT RP14 IS INITIAL.
    CONCATENATE RP14 '& Above' 'Dr' INTO RC15 SEPARATED BY SPACE.
    CONCATENATE RP14 '& Above' 'Cr' INTO RC16 SEPARATED BY SPACE.
    CONCATENATE RP14 'Days and Above' INTO RC14 SEPARATED BY SPACE.
  ENDIF.
*******************************************
AT SELECTION-SCREEN OUTPUT.       "Added by SR on 07.05.2021

  LOOP AT SCREEN.

    IF SCREEN-NAME CS 'P_MAIL'.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
    ENDIF.

  ENDLOOP.

  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
**************************************************
START-OF-SELECTION.

  PERFORM DATALIST_BSID.

  PERFORM FILL_FIELDCATALOG.
  PERFORM SORT_LIST.
  PERFORM FILL_LAYOUT.
  PERFORM LIST_DISPLAY.
*  PERFORM send_email.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  datalist_bsid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM DATALIST_BSID .
  DATA:
    LS_FAEDE_I TYPE FAEDE,
    LS_FAEDE_E TYPE FAEDE,
    LV_INDEX   TYPE SY-TABIX,
    LV_KTOPL   TYPE T001-KTOPL.

  DATA:
    LT_KNVV  TYPE TT_KNVV,
    LS_KNVV  TYPE T_KNVV,
    LT_TVKBT TYPE TT_TVKBT,
    LS_TVKBT TYPE T_TVKBT,
    LT_VBRK  TYPE TT_VBRK,
    LS_VBRK  TYPE T_VBRK,
    LT_VBRP  TYPE TT_VBRP,
    LS_VBRP  TYPE T_VBRP,
    LT_VBAK  TYPE TT_VBAK,
    LS_VBAK  TYPE T_VBAK,
    LT_TVZBT TYPE TT_TVZBT,
    LS_TVZBT TYPE T_TVZBT,
    LT_SKAT  TYPE TT_SKAT,
    LS_SKAT  TYPE T_SKAT,
    LT_DATA  TYPE STANDARD TABLE OF IDATA,
    LS_DATA  TYPE IDATA.

  SELECT BSID~BUKRS
         BSID~KUNNR
         AUGBL
         AUGGJ
         AUGDT
         GJAHR
         BELNR
         BUZEI
         BUDAT
         BLDAT
         WAERS
         SHKZG
         DMBTR
         WRBTR
         REBZG
         REBZJ
         REBZZ
         UMSKZ
         BSID~ZTERM
         ZBD1T
         XBLNR
         BLART
*     kna1~name1
*     kna1~ktokd
    KNB1~AKONT
    BSID~ZFBDT
    BSID~ZBD1T
    BSID~ZBD2T
    BSID~ZBD3T
    BSID~VBELN
  INTO CORRESPONDING FIELDS OF TABLE ITAB
                             FROM BSID INNER JOIN KNB1 ON BSID~KUNNR = KNB1~KUNNR AND KNB1~BUKRS = BSID~BUKRS
                             WHERE BSID~BUKRS IN PLANT
                             AND   BSID~KUNNR IN KUNNR
                             AND   UMSKZ <> 'F'
                             AND   BUDAT <= DATE
                             AND BLART NOT IN ( 'YY','ZV', 'AB' ).
*                             AND   knb1~akont IN akont .
*                             AND   kna1~ktokd IN ktokd.

  SELECT BSAD~BUKRS
         BSAD~KUNNR
         AUGBL
         AUGGJ
         AUGDT
         GJAHR
         BELNR
         BUZEI
         BUDAT
         BLDAT
         WAERS
         SHKZG
         DMBTR
         WRBTR
         REBZG
         REBZJ
         REBZZ
         UMSKZ
         BSAD~ZTERM
         ZBD1T
         BLART
         XBLNR
    KNB1~AKONT
    BSAD~ZFBDT
    BSAD~ZBD1T
    BSAD~ZBD2T
    BSAD~ZBD3T
    BSAD~VBELN
APPENDING CORRESPONDING FIELDS OF TABLE ITAB
                             FROM BSAD INNER JOIN KNB1 ON KNB1~KUNNR = BSAD~KUNNR AND KNB1~BUKRS = BSAD~BUKRS
                             WHERE BSAD~BUKRS IN PLANT
                             AND   BSAD~KUNNR IN KUNNR
                             AND   UMSKZ <> 'F'
*                             AND   budat <= date
                             AND   AUGDT >  DATE
                             AND BLART NOT IN ( 'YY', 'ZV', 'AB' ).
*                             AND  augdt = ' '
*                             AND   knb1~akont IN akont.

  DELETE ITAB WHERE BUDAT > DATE.

  LT_DATA[] = ITAB[].

  DELETE ITAB[] WHERE REBZG IS NOT INITIAL .
*  DELETE lt_data WHERE bldat EQ 'DR'.

  IF NOT ITAB[] IS INITIAL.
    SELECT SINGLE KTOPL
                FROM  T001
                INTO  LV_KTOPL
                WHERE BUKRS = PLANT.

    SELECT KUNNR
           VKBUR
      FROM KNVV
      INTO TABLE LT_KNVV
      FOR ALL ENTRIES IN ITAB
      WHERE KUNNR = ITAB-KUNNR.

    IF SY-SUBRC IS INITIAL.
      SELECT VKBUR
             BEZEI
        FROM TVKBT
        INTO TABLE LT_TVKBT
        FOR ALL ENTRIES IN LT_KNVV
        WHERE VKBUR = LT_KNVV-VKBUR
        AND   SPRAS = SY-LANGU.
    ENDIF.

    SELECT VBELN
           FKDAT
      FROM VBRK
      INTO TABLE LT_VBRK
      FOR ALL ENTRIES IN ITAB
      WHERE VBELN = ITAB-VBELN.

    SELECT VBELN
           AUBEL
      FROM VBRP
      INTO TABLE LT_VBRP
      FOR ALL ENTRIES IN ITAB
      WHERE VBELN = ITAB-VBELN.

    IF SY-SUBRC IS INITIAL.
      SELECT VBELN
             AUDAT
             BSTNK
             BSTDK
        FROM VBAK
        INTO TABLE LT_VBAK
        FOR ALL ENTRIES IN LT_VBRP
        WHERE VBELN = LT_VBRP-AUBEL.
    ENDIF.

    IF LT_VBAK IS NOT INITIAL.
      SELECT VBELN
             POSNR
             BSTKD FROM VBKD INTO TABLE IT_VBKD
             FOR ALL ENTRIES IN LT_VBAK
             WHERE VBELN = LT_VBAK-VBELN
               AND POSNR = ' '.
    ENDIF.

    SELECT ZTERM
           VTEXT
      FROM TVZBT
      INTO TABLE LT_TVZBT
      FOR ALL ENTRIES IN ITAB
      WHERE ZTERM = ITAB-ZTERM
      AND   SPRAS =  SY-LANGU.

    SELECT SAKNR
           TXT50
      FROM SKAT
      INTO TABLE LT_SKAT
      FOR ALL ENTRIES IN ITAB
      WHERE SAKNR = ITAB-AKONT
      AND   KTOPL = LV_KTOPL
      AND   SPRAS = SY-LANGU.

  ENDIF.

  SORT ITAB[] BY BELNR GJAHR BUZEI.
  SORT LT_DATA[] BY REBZG REBZJ REBZZ.

  LOOP AT ITAB .
    READ TABLE LT_DATA INTO LS_DATA WITH KEY REBZG = ITAB-BELNR
                                             REBZJ = ITAB-GJAHR
                                             REBZZ = ITAB-BUZEI.
    IF SY-SUBRC IS INITIAL.
      LV_INDEX = SY-TABIX.
      LOOP AT LT_DATA INTO LS_DATA FROM LV_INDEX.
        IF LS_DATA-REBZG = ITAB-BELNR AND LS_DATA-REBZJ = ITAB-GJAHR AND LS_DATA-REBZZ = ITAB-BUZEI.
          IF LS_DATA-SHKZG = 'S'.
            ITAB-CREDIT = ITAB-CREDIT - LS_DATA-DMBTR.
            ITAB-CREDIT1 = ITAB-CREDIT1 - LS_DATA-wrbtr.
          ELSE.
            ITAB-CREDIT = ITAB-CREDIT + LS_DATA-DMBTR.
             ITAB-CREDIT1 = ITAB-CREDIT1 + LS_DATA-wrbtr.
          ENDIF.

        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
    MODIFY ITAB TRANSPORTING CREDIT CREDIT1.
  ENDLOOP.

  LOOP AT ITAB.

    SELECT SINGLE NAME1 INTO ITAB-NAME1 FROM KNA1 WHERE KUNNR = ITAB-KUNNR.

***********Calculating DEBIT and CREDIT
    IF ITAB-SHKZG  = 'S'.
      ITAB-DEBIT  = ITAB-DMBTR.
    ELSE.
      ITAB-CREDIT = ITAB-CREDIT + ITAB-DMBTR.
    ENDIF.

    IF ITAB-SHKZG  = 'S'.
      ITAB-DEBIT1  = ITAB-wrBTR.
    ELSE.
      ITAB-CREDIT1 = ITAB-CREDIT1 + ITAB-WRBTR.
    ENDIF.

    IF ITAB-UMSKZ  = ''.
      ITAB-GROUP  = 'Normal'.
    ELSE.
      ITAB-GROUP  = 'Special G/L'.
    ENDIF.


*    itab-duedate = itab-bldat. " + itab-zbd1t.

    LS_FAEDE_I-KOART = 'D'.
    LS_FAEDE_I-ZFBDT = ITAB-ZFBDT.
    LS_FAEDE_I-ZBD1T = ITAB-ZBD1T.
    LS_FAEDE_I-ZBD2T = ITAB-ZBD2T.
    LS_FAEDE_I-ZBD3T = ITAB-ZBD3T.

    CALL FUNCTION 'DETERMINE_DUE_DATE'
      EXPORTING
        I_FAEDE                    = LS_FAEDE_I
*       I_GL_FAEDE                 =
      IMPORTING
        E_FAEDE                    = LS_FAEDE_E
      EXCEPTIONS
        ACCOUNT_TYPE_NOT_SUPPORTED = 1
        OTHERS                     = 2.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

    ITAB-DUEDATE = LS_FAEDE_E-NETDT.
    IF R1 = 'X'.
      IF ITAB-BLDAT = DATE.
        ITAB-DAY  = 0.
      ELSE."if itab-bldat < date.
        ITAB-DAY     = DATE - ITAB-BLDAT.

      ENDIF.
    ELSE.
      IF ITAB-DUEDATE = DATE.
        ITAB-DAY  = 0.
      ELSE.
        ITAB-DAY     = DATE - ITAB-DUEDATE.
      ENDIF.
    ENDIF.
***********Net Balance
    ITAB-NETBAL = ITAB-DEBIT - ITAB-CREDIT.
     itab-day1 = sy-datum - ITAB-DUEDATE.
    IF ITAB-DAY < 0.
      ITAB-NOT_DUE_DB = ITAB-DEBIT.
      ITAB-NOT_DUE_CR = ITAB-CREDIT.
      ITAB-NOT_DUE    = ITAB-NOT_DUE_DB - ITAB-NOT_DUE_CR.
    ELSEIF ITAB-DAY <= RASTBIS1.
      ITAB-DEBIT30  = ITAB-DEBIT.
      ITAB-CREDIT30 = ITAB-CREDIT.
      ITAB-NETB30 = ITAB-DEBIT30 - ITAB-CREDIT30.
    ELSEIF RASTBIS2 IS INITIAL.
      ITAB-DEBIT60  = ITAB-DEBIT.
      ITAB-CREDIT60 = ITAB-CREDIT.
      ITAB-NETB60   = ITAB-DEBIT60 - ITAB-CREDIT60.
    ELSE.
      IF ITAB-DAY > RASTBIS1 AND ITAB-DAY <= RASTBIS2.
        ITAB-DEBIT60  = ITAB-DEBIT.
        ITAB-CREDIT60 = ITAB-CREDIT.
        ITAB-NETB60   = ITAB-DEBIT60 - ITAB-CREDIT60.
      ELSEIF RASTBIS3 IS INITIAL.
        ITAB-DEBIT90  = ITAB-DEBIT.
        ITAB-CREDIT90 = ITAB-CREDIT.
        ITAB-NETB90   = ITAB-DEBIT90 - ITAB-CREDIT90.
      ELSE.
        IF ITAB-DAY > RASTBIS2 AND ITAB-DAY <= RASTBIS3.
          ITAB-DEBIT90  = ITAB-DEBIT.
          ITAB-CREDIT90 = ITAB-CREDIT.
          ITAB-NETB90   = ITAB-DEBIT90 - ITAB-CREDIT90.
        ELSEIF RASTBIS4 IS INITIAL.
          ITAB-DEBIT120  = ITAB-DEBIT.
          ITAB-CREDIT120 = ITAB-CREDIT.
          ITAB-NETB120   = ITAB-DEBIT120 - ITAB-CREDIT120.
        ELSE.
          IF ITAB-DAY > RASTBIS3 AND ITAB-DAY <= RASTBIS4.
            ITAB-DEBIT120  = ITAB-DEBIT.
            ITAB-CREDIT120 = ITAB-CREDIT.
            ITAB-NETB120   = ITAB-DEBIT120 - ITAB-CREDIT120.
          ELSEIF RASTBIS5 IS INITIAL.
            ITAB-DEBIT180  = ITAB-DEBIT.
            ITAB-CREDIT180 = ITAB-CREDIT.
            ITAB-NETB180   = ITAB-DEBIT180 - ITAB-CREDIT180.
          ELSE.
            IF ITAB-DAY > RASTBIS4 AND ITAB-DAY <= RASTBIS5.
              ITAB-DEBIT180  = ITAB-DEBIT.
              ITAB-CREDIT180 = ITAB-CREDIT.
              ITAB-NETB180   = ITAB-DEBIT180 - ITAB-CREDIT180.
            ELSEIF RASTBIS6 IS INITIAL.
              ITAB-DEBIT360  = ITAB-DEBIT.
              ITAB-CREDIT360 = ITAB-CREDIT.
              ITAB-NETB360   = ITAB-DEBIT360 - ITAB-CREDIT360.
            ELSE.
              IF ITAB-DAY > RASTBIS5 AND ITAB-DAY <= RASTBIS6.
                ITAB-DEBIT360  = ITAB-DEBIT.
                ITAB-CREDIT360 = ITAB-CREDIT.
                ITAB-NETB360   = ITAB-DEBIT360 - ITAB-CREDIT360.
              ELSEIF RASTBIS6 IS INITIAL.
                ITAB-DEBIT720  = ITAB-DEBIT.
                ITAB-CREDIT720 = ITAB-CREDIT.
                ITAB-NETB720   = ITAB-DEBIT720 - ITAB-CREDIT720.

              ELSE.
                IF ITAB-DAY > RASTBIS6 AND ITAB-DAY <= RASTBIS7.
                  ITAB-DEBIT720  = ITAB-DEBIT.
                  ITAB-CREDIT720 = ITAB-CREDIT.
                  ITAB-NETB720   = ITAB-DEBIT720 - ITAB-CREDIT720.
                ELSEIF RASTBIS7 IS INITIAL.
                  ITAB-DEBIT1000  = ITAB-DEBIT.
                  ITAB-CREDIT1000 = ITAB-CREDIT.
                  ITAB-NETB1000   = ITAB-DEBIT1000 - ITAB-CREDIT1000.

                ELSE.
                  IF ITAB-DAY > RASTBIS7.
                    ITAB-DEBIT1000  = ITAB-DEBIT.
                    ITAB-CREDIT1000 = ITAB-CREDIT.
                    ITAB-NETB1000   = ITAB-DEBIT1000 - ITAB-CREDIT1000.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

    CONCATENATE ITAB-KUNNR ITAB-NAME1 INTO ITAB-TDISP SEPARATED BY SPACE."itab-umskz
    SHIFT ITAB-XBLNR LEFT DELETING LEADING '0'.

    READ TABLE LT_KNVV INTO LS_KNVV WITH KEY KUNNR = ITAB-KUNNR.
    IF SY-SUBRC IS INITIAL.
      READ TABLE LT_TVKBT INTO LS_TVKBT WITH KEY VKBUR = LS_KNVV-VKBUR.
      IF SY-SUBRC IS INITIAL.
        ITAB-BEZEI = LS_TVKBT.
      ENDIF.
    ENDIF.

    READ TABLE LT_VBRK INTO LS_VBRK WITH KEY VBELN = ITAB-VBELN.
    IF SY-SUBRC IS INITIAL.
      ITAB-FKDAT = LS_VBRK-FKDAT.
    ENDIF.

    READ TABLE LT_VBRP INTO LS_VBRP WITH KEY VBELN = ITAB-VBELN.
    IF SY-SUBRC IS INITIAL.
      READ TABLE LT_VBAK INTO LS_VBAK WITH KEY VBELN = LS_VBRP-AUBEL.
      IF SY-SUBRC IS INITIAL.
        ITAB-AUBEL = LS_VBAK-VBELN.
        ITAB-AUDAT = LS_VBAK-AUDAT.
        ITAB-BSTNK = LS_VBAK-BSTNK.
        ITAB-BSTDK = LS_VBAK-BSTDK.

        READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = ITAB-AUBEL.
        IF SY-SUBRC = 0.
          ITAB-BSTKD = WA_VBKD-BSTKD.
        ENDIF.
      ENDIF.
    ENDIF.

    READ TABLE LT_TVZBT INTO LS_TVZBT WITH KEY ZTERM = ITAB-ZTERM.
    IF SY-SUBRC IS INITIAL.
      CONCATENATE LS_TVZBT-ZTERM LS_TVZBT-VTEXT INTO ITAB-VTEXT SEPARATED BY SPACE.
    ENDIF.
    IF ITAB-WAERS = 'INR'.
      IF NOT ITAB-DEBIT IS INITIAL.
*        ITAB-CURR = ITAB-DMBTR.
        ITAB-CURR = ITAB-WRBTR.
      ELSEIF NOT ITAB-CREDIT IS INITIAL.
        ITAB-CURR = ITAB-DMBTR * -1.
      ENDIF.
    ELSE.

      IF NOT ITAB-DEBIT IS INITIAL.
        ITAB-CURR = ITAB-WRBTR.
      ELSEIF NOT ITAB-CREDIT IS INITIAL.
        ITAB-CURR = ITAB-WRBTR * -1.
      ENDIF.
    ENDIF.

     ITAB-NETBAL1 = ITAB-debit1 - ITAB-CREDIT1.

    READ TABLE LT_SKAT INTO LS_SKAT WITH KEY SAKNR = ITAB-AKONT.
    IF SY-SUBRC IS INITIAL.
      ITAB-TXT50 = LS_SKAT-TXT50.
      CONCATENATE ITAB-AKONT LS_SKAT-TXT50 INTO ITAB-REC_TXT SEPARATED BY SPACE.
    ELSE.
      ITAB-REC_TXT = ITAB-AKONT.
    ENDIF.
    SHIFT ITAB-REC_TXT LEFT DELETING LEADING '0'.
    MODIFY ITAB.

  ENDLOOP.

  IF P_DOWN = 'X'.

    LOOP AT ITAB.
      WA_DOWN-GROUP    = ITAB-GROUP   .


      WA_DOWN-SALE     = ITAB-BEZEI+0(2).
      WA_DOWN-SALE_OFF = ITAB-BEZEI+2(18).
      WA_DOWN-TDISP    = ITAB-NAME1   .
      WA_DOWN-KUNNR    = ITAB-KUNNR   .
*   wa_down-BLDAT    = itab-BLDAT   .

      IF ITAB-BLDAT IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = ITAB-BLDAT
          IMPORTING
            OUTPUT = WA_DOWN-BLDAT.

        CONCATENATE WA_DOWN-BLDAT+0(2) WA_DOWN-BLDAT+2(3) WA_DOWN-BLDAT+5(4)
                        INTO WA_DOWN-BLDAT SEPARATED BY '-'.

      ENDIF.

*   wa_down-BUDAT    = itab-BUDAT   .

      IF ITAB-BUDAT IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = ITAB-BUDAT
          IMPORTING
            OUTPUT = WA_DOWN-BUDAT.

        CONCATENATE WA_DOWN-BUDAT+0(2) WA_DOWN-BUDAT+2(3) WA_DOWN-BUDAT+5(4)
                        INTO WA_DOWN-BUDAT SEPARATED BY '-'.

      ENDIF.


*      WA_DOWN-REC_TXT  = ITAB-TXT50.
      WA_DOWN-AKONT  = ITAB-AKONT .
*   wa_down-DUEDATE  = itab-DUEDATE .

      IF ITAB-BUDAT IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = ITAB-DUEDATE
          IMPORTING
            OUTPUT = WA_DOWN-DUEDATE.

        CONCATENATE WA_DOWN-DUEDATE+0(2) WA_DOWN-DUEDATE+2(3) WA_DOWN-DUEDATE+5(4)
                        INTO WA_DOWN-DUEDATE SEPARATED BY '-'.

      ENDIF.
      WA_DOWN-BLART    = ITAB-BLART   .
      WA_DOWN-BELNR    = ITAB-BELNR   .
      WA_DOWN-VBELN    = ITAB-VBELN   .
*      WA_DOWN-XBLNR    = ITAB-XBLNR   .
*   wa_down-FKDAT    = itab-FKDAT   .

      IF ITAB-FKDAT IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = ITAB-FKDAT
          IMPORTING
            OUTPUT = WA_DOWN-FKDAT.

        CONCATENATE WA_DOWN-FKDAT+0(2) WA_DOWN-FKDAT+2(3) WA_DOWN-FKDAT+5(4)
                        INTO WA_DOWN-FKDAT SEPARATED BY '-'.

      ENDIF.


      WA_DOWN-VTEXT    = ITAB-VTEXT   .
      WA_DOWN-AUBEL    = ITAB-AUBEL   .
*   wa_down-AUDAT    = itab-AUDAT   .

      IF ITAB-AUDAT IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = ITAB-AUDAT
          IMPORTING
            OUTPUT = WA_DOWN-AUDAT.

        CONCATENATE WA_DOWN-AUDAT+0(2) WA_DOWN-AUDAT+2(3) WA_DOWN-AUDAT+5(4)
                        INTO WA_DOWN-AUDAT SEPARATED BY '-'.

      ENDIF.



*   wa_down-BSTNK    = itab-BSTNK   .
      WA_DOWN-BSTKD    = ITAB-BSTKD   .
*   wa_down-BSTDK    = itab-BSTDK   .

      IF ITAB-BSTDK IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = ITAB-BSTDK
          IMPORTING
            OUTPUT = WA_DOWN-BSTDK.

        CONCATENATE WA_DOWN-BSTDK+0(2) WA_DOWN-BSTDK+2(3) WA_DOWN-BSTDK+5(4)
                        INTO WA_DOWN-BSTDK SEPARATED BY '-'.

      ENDIF.


      WA_DOWN-WAERS        = ITAB-WAERS  .
      WA_DOWN-CURR         = ABS( ITAB-CURR )   .

      WA_DOWN-DEBIT        = ABS( ITAB-DEBIT )  .
      WA_DOWN-CREDIT       = ABS( ITAB-CREDIT ) .
      WA_DOWN-DEBIT1        = ABS( ITAB-DEBIT1 )  .
      WA_DOWN-CREDIT1       = ABS( ITAB-CREDIT1 ) .
      WA_DOWN-NETBAL       = ABS( ITAB-NETBAL )  .
      WA_DOWN-NETBAL1       = ABS( ITAB-NETBAL1 )  .
      WA_DOWN-NOT_DUE      = ABS( ITAB-NOT_DUE ).
      WA_DOWN-NETB30       = ABS( ITAB-NETB30 )  .
      WA_DOWN-NETB60       = ABS( ITAB-NETB60 ) .
      WA_DOWN-NETB90       = ABS( ITAB-NETB90 )    .
      WA_DOWN-NETB120      = ABS( ITAB-NETB120 )    .
      WA_DOWN-NETB180      = ABS( ITAB-NETB180 )   .
      WA_DOWN-NETB360      = ABS( ITAB-NETB360 )   .
      WA_DOWN-NETB720      = ABS( ITAB-NETB720 )   .
      WA_DOWN-NETB1000     = ABS( ITAB-NETB1000 )   .
      WA_DOWN-DAY          = ABS( ITAB-DAY )       .
      WA_DOWN-DAY1          = ABS( ITAB-DAY1 )       .

      CONDENSE WA_DOWN-CURR.
      IF ITAB-CURR < 0.
        CONCATENATE '-' WA_DOWN-CURR INTO WA_DOWN-CURR.
      ENDIF.



      CONDENSE WA_DOWN-DEBIT.
      IF ITAB-DEBIT < 0.
        CONCATENATE '-' WA_DOWN-DEBIT INTO WA_DOWN-DEBIT.
      ENDIF.

      CONDENSE WA_DOWN-CREDIT.
      IF ITAB-CREDIT < 0.
        CONCATENATE '-' WA_DOWN-CREDIT INTO WA_DOWN-CREDIT.
      ENDIF.
*
    CONDENSE WA_DOWN-DEBIT1.
      IF ITAB-DEBIT1 < 0.
        CONCATENATE '-' WA_DOWN-DEBIT1 INTO WA_DOWN-DEBIT1.
      ENDIF.

      CONDENSE WA_DOWN-CREDIT1.
      IF ITAB-CREDIT1 < 0.
        CONCATENATE '-' WA_DOWN-CREDIT1 INTO WA_DOWN-CREDIT1.
      ENDIF.




      CONDENSE WA_DOWN-NETBAL.
      IF ITAB-NETBAL < 0.
        CONCATENATE '-' WA_DOWN-NETBAL INTO WA_DOWN-NETBAL.
      ENDIF.

      CONDENSE WA_DOWN-NOT_DUE.
      IF ITAB-NOT_DUE < 0.
        CONCATENATE '-' WA_DOWN-NOT_DUE INTO WA_DOWN-NOT_DUE.
      ENDIF.

      CONDENSE WA_DOWN-NETB30.
      IF ITAB-NETB30 < 0.
        CONCATENATE '-' WA_DOWN-NETB30 INTO WA_DOWN-NETB30.
      ENDIF.

      CONDENSE WA_DOWN-NETB60.
      IF ITAB-NETB60 < 0.
        CONCATENATE '-' WA_DOWN-NETB60 INTO WA_DOWN-NETB60.
      ENDIF.

      CONDENSE WA_DOWN-NETB90.
      IF ITAB-NETB90 < 0.
        CONCATENATE '-' WA_DOWN-NETB90 INTO WA_DOWN-NETB90.
      ENDIF.

      CONDENSE WA_DOWN-NETB120.
      IF ITAB-NETB120 < 0.
        CONCATENATE '-' WA_DOWN-NETB120 INTO WA_DOWN-NETB120.
      ENDIF.

      CONDENSE WA_DOWN-NETB180.
      IF ITAB-NETB180 < 0.
        CONCATENATE '-' WA_DOWN-NETB180 INTO WA_DOWN-NETB180.
      ENDIF.

      CONDENSE WA_DOWN-NETB360.
      IF ITAB-NETB360 < 0.
        CONCATENATE '-' WA_DOWN-NETB360 INTO WA_DOWN-NETB360.
      ENDIF.

      CONDENSE WA_DOWN-NETB720.
      IF ITAB-NETB720 < 0.
        CONCATENATE '-' WA_DOWN-NETB720 INTO WA_DOWN-NETB720.
      ENDIF.

      CONDENSE WA_DOWN-NETB1000.
      IF ITAB-NETB1000 < 0.
        CONCATENATE '-' WA_DOWN-NETB1000 INTO WA_DOWN-NETB1000.
      ENDIF.

      CONDENSE WA_DOWN-DAY.
      IF ITAB-DAY < 0.
        CONCATENATE '-' WA_DOWN-DAY INTO WA_DOWN-DAY.
      ENDIF.



      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

      WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.


      APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_DOWN.
    ENDLOOP.




  ENDIF.


ENDFORM.                    " DATALIST_Bsak


*&---------------------------------------------------------------------*
*&      Form  fill_fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FILL_FIELDCATALOG.

  PERFORM F_FIELDCATALOG USING '1'   'GROUP'     'GL Type'.
  PERFORM F_FIELDCATALOG USING '2'   'BEZEI'     'Sales Office'.
  PERFORM F_FIELDCATALOG USING '3'   'TDISP'     'Customer Code Name'.
  PERFORM F_FIELDCATALOG USING '4'   'BLDAT'     'Document Date'.
  PERFORM F_FIELDCATALOG USING '5'   'BUDAT'     'Posting Date'.
  PERFORM F_FIELDCATALOG USING '6'   'REC_TXT'   'Reconciliation Account'.
  PERFORM F_FIELDCATALOG USING '7'   'DUEDATE'   'Due Date'.
  PERFORM F_FIELDCATALOG USING '8'   'BLART'     'FI Doc Type'.
  PERFORM F_FIELDCATALOG USING '9'   'BELNR'     'Accounting Doc No.'.
  PERFORM F_FIELDCATALOG USING '10'   'VBELN'     'Billing Doc.No.'.
*  PERFORM F_FIELDCATALOG USING '11'  'XBLNR'     'Tax Invoice No.(ODN)'.
  PERFORM F_FIELDCATALOG USING '12'  'FKDAT'     'Tax Invoice Date'.
  PERFORM F_FIELDCATALOG USING '13'  'VTEXT'     'Payment Terms'.
  PERFORM F_FIELDCATALOG USING '14'  'AUBEL'     'Sales Order No.'.
  PERFORM F_FIELDCATALOG USING '15'  'AUDAT'     'Sales Order Date'.
  PERFORM F_FIELDCATALOG USING '16'  'BSTKD'     'Customer PO. NO.'.
  PERFORM F_FIELDCATALOG USING '17'  'BSTDK'     'Customer PO. Date'.
  PERFORM F_FIELDCATALOG USING '18'   'CURR'      'Amt Document Currency'.
  PERFORM F_FIELDCATALOG USING '19'   'WAERS'     'Currency Key'.
  PERFORM F_FIELDCATALOG USING '20'   'DEBIT'     'Total Inv Amt (SAR)' ."'Total Pending DR'.
  PERFORM F_FIELDCATALOG USING '21'  'CREDIT'    'Total Rec/Cre Memo Amt (SAR)' . "'Total Pending CR'.
  PERFORM F_FIELDCATALOG USING '24'  'NETBAL'    'Total Outstanding (SAR)'. "'Net Pending'.
  PERFORM F_FIELDCATALOG USING '22'   'DEBIT1'     'Total Inv Amt Doc Curr' .
  PERFORM F_FIELDCATALOG USING '23'  'CREDIT1'    'Total Rec/Cre Memo Amt Doc Curr'. ""Total Pending CR'.
  PERFORM F_FIELDCATALOG USING '24'  'NETBAL1'    'Total Outstanding Doc Curr' . "'Net Pending'.
  PERFORM F_FIELDCATALOG USING '25'  'NOT_DUE'   'Not Due'. "'Net Balance'.
  PERFORM F_FIELDCATALOG USING '26'  'NETB30'     RC17. "'Net Balance'.
  PERFORM F_FIELDCATALOG USING '27'  'NETB60'     RC18. "'Net Balance'.
  PERFORM F_FIELDCATALOG USING '28'  'NETB90'     RC19. "'Net Balance'.
  PERFORM F_FIELDCATALOG USING '29'  'NETB120'    RC20. "'Net Balance'.
  PERFORM F_FIELDCATALOG USING '30'  'NETB180'    RC21. "'Net Balance'.
  PERFORM F_FIELDCATALOG USING '31'  'NETB360'    RC22. "'Net Balance'.
  PERFORM F_FIELDCATALOG USING '32'  'NETB720'    RC23. "'Net Balance'.
  PERFORM F_FIELDCATALOG USING '33'  'NETB1000'   RC14. "'Net Balance'.
  PERFORM F_FIELDCATALOG USING '34'  'DAY'        'Days from Invoice Date'.
  PERFORM F_FIELDCATALOG USING '35'  'DAY1'       'Days from Due Date'.

ENDFORM.                    " FILL_FIELDCATALOG

*&---------------------------------------------------------------------*
*&      Form  sort_list
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM SORT_LIST.
  T_SORT-SPOS      = '1'.
  T_SORT-FIELDNAME = 'GROUP'.
  T_SORT-TABNAME   = 'ITAB'.
  T_SORT-UP        = 'X'.
  T_SORT-SUBTOT    = 'X'.
  APPEND T_SORT.

  T_SORT-SPOS      = '2'.
  T_SORT-FIELDNAME = 'TDISP'.
  T_SORT-TABNAME   = 'ITAB'.
  T_SORT-UP        = 'X'.
  T_SORT-SUBTOT    = 'X'.
  APPEND T_SORT.

  T_SORT-SPOS      = '3'.
  T_SORT-FIELDNAME = 'BLDAT'.
  T_SORT-TABNAME   = 'ITAB'.
  T_SORT-UP        = 'X'.
  T_SORT-SUBTOT    = ' '.
  APPEND T_SORT.

ENDFORM.                    " sort_list

*&---------------------------------------------------------------------*
*&      Form  fill_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FILL_LAYOUT.
  FS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  FS_LAYOUT-ZEBRA             = 'X'.
  FS_LAYOUT-DETAIL_POPUP      = 'X'.
  FS_LAYOUT-SUBTOTALS_TEXT    = 'DR'.

ENDFORM.                    " fill_layout

*&---------------------------------------------------------------------*
*&      Form  f_fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->VALUE(X)   text
*      -->VALUE(F1)  text
*      -->VALUE(F2)  text
*----------------------------------------------------------------------*
FORM F_FIELDCATALOG  USING   VALUE(X)
                             VALUE(F1)
                             VALUE(F2).
  T_FIELDCAT-COL_POS      = X.
  T_FIELDCAT-FIELDNAME    = F1.
  T_FIELDCAT-SELTEXT_L    = F2.
*  t_fieldcat-decimals_out = '2'.

  IF F1 = 'DEBIT'    OR F1 = 'CREDIT'    OR F1 = 'DEBIT30'  OR F1 = 'CREDIT30'  OR
     F1 = 'DEBIT60'  OR F1 = 'CREDIT60'  OR F1 = 'DEBIT90'  OR F1 = 'CREDIT90'  OR
     F1 = 'DEBIT120' OR F1 = 'CREDIT120' OR F1 = 'DEBIT180' OR F1 = 'CREDIT180' OR
     F1 = 'DEBIT360' OR F1 = 'CREDIT360' OR F1 = 'NETBAL'   OR F1 = 'NETB30'    OR  F1 = 'NETBAL1' or
     F1 = 'NETB60'   OR F1 = 'NETB90'    OR F1 = 'NETB120'  OR F1 = 'NETB180'   OR F1 = 'DEBIT1' or
     F1 = 'NETB360'  OR F1 = 'NETB720'   OR F1 = 'NETB1000'   OR F1 = 'NOT_DUE' or  F1 = 'CREDIT1'  .

    T_FIELDCAT-DO_SUM = 'X'.
  ENDIF.

  IF F1 = 'BELNR'.
    T_FIELDCAT-HOTSPOT = 'X'.
  ENDIF.
  APPEND T_FIELDCAT.
  CLEAR T_FIELDCAT.

ENDFORM.                    " f_fieldcatalog

*&---------------------------------------------------------------------*
*&      Form  list_display
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM LIST_DISPLAY.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM      = SY-REPID
      I_CALLBACK_USER_COMMAND = 'USER_CMD'
      IS_LAYOUT               = FS_LAYOUT
      I_CALLBACK_TOP_OF_PAGE  = 'TOP-OF-PAGE'
      IT_FIELDCAT             = T_FIELDCAT[]
      IT_SORT                 = T_SORT[]
      I_SAVE                  = 'X'
    TABLES
      T_OUTTAB                = ITAB[]
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  IF P_DOWN = 'X'.

    PERFORM DOWNLOAD.
    BREAK PRIMUS.
    IF P_MAIL = 'X'.
      IF DATE = SY-DATUM.
        PERFORM SEND_MAIL.
      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.                    " list_display


*&---------------------------------------------------------------------*
*&      Form  top-of-page
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM TOP-OF-PAGE.

*  ALV Header declarations
  DATA: T_HEADER      TYPE SLIS_T_LISTHEADER,
        WA_HEADER     TYPE SLIS_LISTHEADER,
        T_LINE        LIKE WA_HEADER-INFO,
        LD_LINES      TYPE I,
        LD_LINESC(10) TYPE C.

*  Title
  WA_HEADER-TYP  = 'H'.
  WA_HEADER-INFO = 'Customer Ageing Report'.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR WA_HEADER.

*  Date
  WA_HEADER-TYP  = 'S'.
  WA_HEADER-KEY  = 'As on   :'.
  CONCATENATE WA_HEADER-INFO DATE+6(2) '.' DATE+4(2) '.' DATE(4) INTO WA_HEADER-INFO.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER.

*  Date
  WA_HEADER-TYP  = 'S'.
  WA_HEADER-KEY  = 'Run Date : '.
  CONCATENATE WA_HEADER-INFO SY-DATUM+6(2) '.' SY-DATUM+4(2) '.'
                      SY-DATUM(4) INTO WA_HEADER-INFO.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER.

*  Time
  WA_HEADER-TYP  = 'S'.
  WA_HEADER-KEY  = 'Run Time: '.
  CONCATENATE WA_HEADER-INFO SY-TIMLO(2) ':' SY-TIMLO+2(2) ':'
                      SY-TIMLO+4(2) INTO WA_HEADER-INFO.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER.

*   Total No. of Records Selected
  DESCRIBE TABLE ITAB LINES LD_LINES.
  LD_LINESC = LD_LINES.

  CONCATENATE 'Total No. of Records Selected: ' LD_LINESC
     INTO T_LINE SEPARATED BY SPACE.

  WA_HEADER-TYP  = 'A'.
  WA_HEADER-INFO = T_LINE.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER, T_LINE.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = T_HEADER.
ENDFORM.                    " top-of-page


*&---------------------------------------------------------------------*
*&      Form  USER_CMD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM USER_CMD USING R_UCOMM LIKE SY-UCOMM
                    RS_SELFIELD TYPE SLIS_SELFIELD.
  IF R_UCOMM = '&IC1'.
    IF RS_SELFIELD-FIELDNAME = 'BELNR'.
      READ TABLE ITAB WITH KEY BELNR = RS_SELFIELD-VALUE.
      SET PARAMETER ID 'BLN' FIELD RS_SELFIELD-VALUE.
      SET PARAMETER ID 'BUK' FIELD ITAB-BUKRS ."PLANT.
      SET PARAMETER ID 'GJR' FIELD ITAB-GJAHR.
      CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
    ENDIF.
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


  LV_FILE = 'ZSU_CUST_AGE.TXT'.


*  CONCATENATE P_FOLDER '\' SY-DATUM SY-UZEIT LV_FILE
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_CUST_AGE REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1551 TYPE string.
DATA lv_crlf_1551 TYPE string.
lv_crlf_1551 = cl_abap_char_utilities=>cr_lf.
lv_string_1551 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1551 lv_crlf_1551 wa_csv INTO lv_string_1551.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1551 TO lv_fullfile.
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


  LV_FILE = 'ZSU_CUST_AGE.TXT'.


*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_CUST_AGE REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1590 TYPE string.
DATA lv_crlf_1590 TYPE string.
lv_crlf_1590 = cl_abap_char_utilities=>cr_lf.
lv_string_1590 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1590 lv_crlf_1590 wa_csv INTO lv_string_1590.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1590 TO lv_fullfile.
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
  CONCATENATE 'GL Type'
              'Sales Office'
              'Sales Office Description'
              'Customer Code'
              'Customer Code Name'
              'Document Date'
              'Posting Date'
              'Reconciliation Account'
*             'Reconciliation Account Desc'
              'Due Date'
              'FI Doc Type'
              'Accounting Doc No.'
              'Billing Doc.No.'
*              'Tax Invoice No.(ODN)'
              'Tax Invoice Date'
              'Payment Terms'
              'Sales Order No.'
              'Sales Order Date'
              'Customer PO. NO.'
              'Customer PO. Date'
              'Amt Document Currency'
              'Currency Key'
              'Total Inv Amt (SAR)'
              'Total Rec/Cre Memo Amt (SAR)'
              'Total Outstanding (SAR)'
              'Total Inv Amt Doc Curr'
              'Total Rec/Cre Memo Amt Doc Curr'
              'Total Outstanding Doc Curr'
              'Not Due'
                RC17
                RC18
                RC19
                RC20
                RC21
                RC22
                RC23
                RC14
              'Days from Invoice Date'
              'Days from Due Date'
              'Refresh Date'
              'Refresh Time'
              INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SEND_MAIL .


  DATA : LV_SUBJECT   TYPE SO_OBJ_DES,
         LT_MAIL_BODY TYPE BCSY_TEXT,
*         ls_message   TYPE soli,
*         lt_message   TYPE solisti1,
         LT_MESSAGE   TYPE TABLE OF SOLISTI1,
         LS_MESSAGE   LIKE LINE OF LT_MESSAGE,
         LT_HEADINGS  TYPE BCSY_TEXT,
         LS_HEADINGS  TYPE SOLI,
         LT_SOLIX     TYPE SOLIX_TAB.

  TYPES : BEGIN OF TY_REC,
            EMAIL_ID TYPE AD_SMTPADR,
          END OF TY_REC .

  DATA : LS_REC TYPE  TY_REC,
         LT_REC TYPE TABLE OF  TY_REC.

  DATA : GV_SALE_OFF   TYPE CHAR50,

         IT_RECLIST    TYPE STANDARD TABLE OF  SOMLRECI1,
         WA_IT_RECLIST TYPE  SOMLRECI1,

         IMESSAGE      TYPE STANDARD TABLE OF  SOLISTI1,
         WA_IMESSAGE   LIKE LINE OF IMESSAGE,

         LO_MAIL_APP   TYPE REF TO ZCL_MAIL_APP,

         I_LINE        TYPE TABLE OF TY_DOWN,
         W_LINE        TYPE TY_DOWN.

  CREATE OBJECT LO_MAIL_APP .

  LT_OFIC[] = IT_DOWN[] .
  SORT LT_OFIC BY SALE_OFF.
  DELETE ADJACENT DUPLICATES FROM LT_OFIC COMPARING SALE_OFF.

*  BREAK primus.
  LOOP AT LT_OFIC INTO LS_OFIC.

* e-mail receivers.
    GV_SALE_OFF = LS_OFIC-SALE_OFF.
    SHIFT GV_SALE_OFF LEFT DELETING LEADING SPACE.
    TRANSLATE GV_SALE_OFF TO UPPER CASE.

    SELECT * FROM ZCUST_MAIL
    INTO TABLE LT_MAIL
    WHERE ZOFFICE = GV_SALE_OFF.


    REFRESH LT_REC.
    LOOP AT LT_MAIL INTO LS_MAIL WHERE ZOFFICE = GV_SALE_OFF.

      CHECK LS_MAIL-ZTO IS NOT INITIAL.
      LS_REC-EMAIL_ID = LS_MAIL-ZTO.
      APPEND LS_REC TO LT_REC.
      CLEAR LS_REC.

    ENDLOOP.

    IF LT_REC IS NOT INITIAL.
      " populate the text for body of the mail

      LV_SUBJECT = 'Customer Ageing Report'.


      REFRESH LT_MESSAGE.
      LS_MESSAGE-LINE  = 'Dear Sir/Madam,'.
      APPEND LS_MESSAGE TO LT_MESSAGE.
      CLEAR LS_MESSAGE.

      LS_MESSAGE-LINE =   'Please find below the Attachment of Customer Ageing Report'.
      APPEND LS_MESSAGE TO LT_MESSAGE.
      CLEAR LS_MESSAGE.


      REFRESH I_LINE.
      LOOP AT IT_DOWN INTO WA_DOWN WHERE SALE_OFF = LS_OFIC-SALE_OFF.

*        CONCATENATE
        W_LINE-GROUP           =  WA_DOWN-GROUP.
        W_LINE-SALE            =  WA_DOWN-SALE.
        W_LINE-SALE_OFF        =  WA_DOWN-SALE_OFF.
        W_LINE-KUNNR           =  WA_DOWN-KUNNR.
        W_LINE-TDISP           =  WA_DOWN-TDISP.
        W_LINE-BLDAT           =  WA_DOWN-BLDAT.
        W_LINE-BUDAT           =  WA_DOWN-BUDAT.
        W_LINE-AKONT           =  WA_DOWN-AKONT.
*       W_LINE-REC_TXT         =  WA_DOWN-REC_TXT.
        W_LINE-DUEDATE         =  WA_DOWN-DUEDATE.
        W_LINE-BLART           =  WA_DOWN-BLART.
        W_LINE-BELNR           =  WA_DOWN-BELNR.
        W_LINE-VBELN           =  WA_DOWN-VBELN.
*        W_LINE-XBLNR           =  WA_DOWN-XBLNR.
        W_LINE-FKDAT           =  WA_DOWN-FKDAT.
        W_LINE-VTEXT           =  WA_DOWN-VTEXT.
        W_LINE-AUBEL           =  WA_DOWN-AUBEL.
        W_LINE-AUDAT           =  WA_DOWN-AUDAT.
        W_LINE-BSTKD           =  WA_DOWN-BSTKD.
        W_LINE-BSTDK           =  WA_DOWN-BSTDK.
        W_LINE-CURR            =  WA_DOWN-CURR.
        W_LINE-WAERS           =  WA_DOWN-WAERS.
        W_LINE-DEBIT           =  WA_DOWN-DEBIT.
        W_LINE-DEBIT1           =  WA_DOWN-DEBIT1.
        W_LINE-CREDIT          =  WA_DOWN-CREDIT.
        W_LINE-CREDIT1          =  WA_DOWN-CREDIT1.
        W_LINE-NETBAL          =  WA_DOWN-NETBAL.
        W_LINE-NETBAL1          =  WA_DOWN-NETBAL1.
        W_LINE-NOT_DUE         =  WA_DOWN-NOT_DUE.
        W_LINE-NETB30          =  WA_DOWN-NETB30.
        W_LINE-NETB60          =  WA_DOWN-NETB60.
        W_LINE-NETB90          =  WA_DOWN-NETB90.
        W_LINE-NETB120         =  WA_DOWN-NETB120.
        W_LINE-NETB180         =  WA_DOWN-NETB180.
        W_LINE-NETB360         =  WA_DOWN-NETB360.
        W_LINE-NETB720         =  WA_DOWN-NETB720.
        W_LINE-NETB1000        =  WA_DOWN-NETB1000.
        W_LINE-DAY             =  WA_DOWN-DAY.
        W_LINE-DAY1             =  WA_DOWN-DAY1.
        W_LINE-REF             =  WA_DOWN-REF.

        APPEND W_LINE TO I_LINE.
        CLEAR : W_LINE, WA_DOWN.

      ENDLOOP.

      REFRESH LT_HEADINGS.

      LS_HEADINGS-LINE  = 'GL Type'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Sales Office'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Sales Office Description'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Customer Code'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Customer Code Name'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Document Date'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Posting Date'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Reconciliation Account'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

*      LS_HEADINGS-LINE  = 'Reconciliation Account Desc'.
*      APPEND LS_HEADINGS TO LT_HEADINGS.
*      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Due Date'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'FI Doc Type'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Accounting Doc No.'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Billing Doc.No.'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Tax Invoice No.(ODN)'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Tax Invoice Date'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Payment Terms'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Sales Order No.'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Sales Order Date'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Customer PO. NO.'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Customer PO. Date'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Amt Document Currency'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Currency Key'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Total Inv Amt (SAR)'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Total Rec/Cre Memo Amt (SAR)'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Total Outstanding (SAR)'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Total Inv Amt Doc Currency'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Total Rec/Cre Memo Amt Doc Curr'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

       LS_HEADINGS-LINE  = 'Total Outstanding Doc Curr'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.


      LS_HEADINGS-LINE  = 'Not Due'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  =   rc17 .
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  =  rc18 .
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  =  rc19 .
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = rc20 .
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  =  rc21 .
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = rc22.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = rc23.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = rc14.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Days from Invoice Date'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

       LS_HEADINGS-LINE  = 'Days from Due Date'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      LS_HEADINGS-LINE  = 'Refresh Date'.
      APPEND LS_HEADINGS TO LT_HEADINGS.
      CLEAR LS_HEADINGS.

      REFRESH LT_MAIL_BODY.
      CALL METHOD LO_MAIL_APP->ADD_BODY_MSG
        EXPORTING
          IM_T_MESSAGE = LT_MESSAGE
        CHANGING
          CH_T_BODY    = LT_MAIL_BODY.

      CLEAR LT_MESSAGE.


*  For attachment
      REFRESH LT_SOLIX.
      CALL METHOD LO_MAIL_APP->CREATE_ATTACHMENT
        EXPORTING
          IM_T_HEADINGS = LT_HEADINGS
          IM_T_DATA     = I_LINE
*         im_v_pdf      =
        IMPORTING
          EX_T_SOLIX    = LT_SOLIX.

      CALL METHOD LO_MAIL_APP->SEND_MAIL
        EXPORTING
          IM_T_RECEIVERS  = LT_REC
          IM_SUBJECT      = LV_SUBJECT
          IM_T_BODY       = LT_MAIL_BODY
          IM_T_ATTACH_HEX = LT_SOLIX
          IM_ATT_TYPE     = 'XLS'
          IM_ATT_SUBJ     = 'Customer Ageing Report'.

    ENDIF.
  ENDLOOP.
ENDFORM.
