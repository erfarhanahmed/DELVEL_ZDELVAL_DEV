*&---------------------------------------------------------------------*
*&Report: ZSU_PO_SO_RATE
*&Transaction: ZSU_PO_VERIFY
*&Functional Cosultant: Tejaswini Kapadnis
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*



*&---------------------------------------------------------------------*
*& Report ZUS_PO_SO_RATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_PO_SO_RATE.


TABLES: VAPMA.


TYPES:BEGIN OF TY_VAPMA,
        MATNR TYPE VAPMA-MATNR,
        VKORG TYPE VAPMA-VKORG,
        VTWEG TYPE VAPMA-VTWEG,
        KUNNR TYPE VAPMA-KUNNR,
        BSTNK TYPE EKPO-EBELN,
        VBELN TYPE VAPMA-VBELN,
        POSNR TYPE VAPMA-POSNR,
        WERKS TYPE VAPMA-WERKS,
      END OF TY_VAPMA,

      BEGIN OF TY_VBAP,
        VBELN  TYPE VBAP-VBELN,
        POSNR  TYPE VBAP-POSNR,
        MATNR  TYPE VBAP-MATNR,
        NETPR  TYPE VBAP-NETPR,
        POSEX  TYPE VBAP-POSEX,
        ABGRU  TYPE VBAP-ABGRU,
        KWMENG TYPE VBAP-KWMENG,
        WAERK  TYPE VBAP-WAERK,    "SO CURRENCY ADDED BY SHUBHANGI SARODE ON DT 31.01.2024
      END OF TY_VBAP,

      BEGIN OF TY_EKPO,
        EBELN TYPE EKPO-EBELN,
        EBELP TYPE EKPO-EBELP,
        LOEKZ TYPE EKPO-LOEKZ,
        MATNR TYPE EKPO-MATNR,
        BUKRS TYPE EKPO-BUKRS,
        WERKS TYPE EKPO-WERKS,
        NETPR TYPE EKPO-NETPR,
        MENGE TYPE EKPO-MENGE,
        INCO1 TYPE EKPO-INCO1,
        INCO2 TYPE EKPO-INCO2,
      END OF TY_EKPO,

      BEGIN OF TY_EKKO,
        EBELN TYPE EKKO-EBELN,
        BEDAT TYPE EKKO-BEDAT,
        INCO1 TYPE EKKO-INCO1,
        INCO2 TYPE EKKO-INCO2,
        KNUMV TYPE EKKO-KNUMV,
        WAERS TYPE EKKO-WAERS,                  "Added By Shubhangi Sarode on dt 31.01.2024 po currency
      END OF TY_EKKO,


      BEGIN OF TY_VBKD,
        VBELN TYPE VBKD-VBELN,
        POSNR TYPE VBKD-POSNR,
        INCO1 TYPE VBKD-INCO1,
        INCO2 TYPE VBKD-INCO2,
      END OF TY_VBKD,

      BEGIN OF TY_KONV,
        KNUMV TYPE prcd_elements-KNUMV,
        KPOSN TYPE prcd_elements-KPOSN,
        STUNR TYPE prcd_elements-STUNR,
        ZAEHK TYPE prcd_elements-ZAEHK,
        KBETR TYPE prcd_elements-KBETR,
        KSCHL TYPE prcd_elements-KSCHL,
      END OF TY_KONV,


      BEGIN OF TY_FINAL,
        SO_MATNR     TYPE VAPMA-MATNR,
        PO_MATNR     TYPE VAPMA-MATNR,
        KUNNR        TYPE VAPMA-KUNNR,
        VBELN        TYPE VAPMA-VBELN,
        POSNR        TYPE VAPMA-POSNR,
        WERKS        TYPE VAPMA-WERKS,
        EBELN        TYPE EKPO-EBELN,
        EBELP        TYPE EKPO-EBELP,
        SO_RATE      TYPE EKPO-NETPR,
        PO_RATE      TYPE EKPO-NETPR,
        PO_CURRENCY  TYPE EKKO-WAERS,      "Added by Shubhangi Sarode on dt 31.01.2024
        SO_CURRENCY  TYPE VBAK-WAERK,      "Added by Shubhangi Sarode on dt 31.01.2024
        SO_PO_DIFF   TYPE CHAR5,           "Added by Shubhangi Sarode on dt 31.01.2024
        DIFF         TYPE EKPO-NETPR,
        PO_RES       TYPE CHAR15,
        PO_RES1      TYPE CHAR15,          "Added by Awais on 03.11.2023
        SO_DEL_IND   TYPE CHAR15,          "Added by Shubhangi Sarode on dt 01.02.2024   "So delivery indicator
        ABGRU        TYPE VBAP-ABGRU,
        SO_RES       TYPE CHAR50,
        PO_QTY       TYPE EKPO-MENGE,
        SO_QTY       TYPE EKPO-MENGE,
        BEDAT        TYPE EKKO-BEDAT,
        KDGRP        TYPE VBKD-KDGRP,
        TEXT         TYPE CHAR255,
        WRKST        TYPE MARA-WRKST,
        PO_INCO1     TYPE EKPO-INCO1,
        PO_INCO2     TYPE EKPO-INCO2,
        SO_INCO1     TYPE VBKD-INCO1,
        SO_INCO2     TYPE VBKD-INCO2,
        CUST_DETAILS TYPE CHAR300,
        CTBG_DETAILS TYPE CHAR300,
        KBETR        TYPE prcd_elements-KBETR,

      END OF TY_FINAL,

      BEGIN OF TY_DOWN,
        EBELN        TYPE CHAR20,
        EBELP        TYPE CHAR10,
        PO_MATNR     TYPE CHAR40,
        VBELN        TYPE CHAR20,
        POSNR        TYPE CHAR10,
*        SO_MATNR     TYPE CHAR20,
        SO_MATNR     TYPE CHAR40,
        PO_RES1      TYPE CHAR15, "Added by Awais on 03.11.2023
        PO_RATE      TYPE CHAR15,
        SO_RATE      TYPE CHAR15,
        PO_CURRENCY  TYPE EKKO-WAERS,      "Added by Shubhangi Sarode on dt 31.01.2024
        SO_CURRENCY  TYPE VBAK-WAERK,      "Added by Shubhangi Sarode on dt 31.01.2024
        SO_PO_DIFF   TYPE CHAR5,           "Added by Shubhangi Sarode on dt 31.01.2024
        DIFF         TYPE CHAR15,
        PO_RES       TYPE CHAR15,
        SO_DEL_IND   TYPE CHAR15,          "Added by Shubhangi Sarode on dt 01.02.2024
        ABGRU        TYPE VBAP-ABGRU,
        SO_RES       TYPE CHAR50,
        PO_QTY       TYPE CHAR15,
        SO_QTY       TYPE CHAR15,
        BEDAT        TYPE CHAR15,
        KDGRP        TYPE VBKD-KDGRP,
        TEXT         TYPE CHAR255,
        WRKST        TYPE MARA-WRKST,
        PO_INCO1     TYPE EKPO-INCO1,
        PO_INCO2     TYPE EKPO-INCO2,
        SO_INCO1     TYPE VBKD-INCO1,
        SO_INCO2     TYPE VBKD-INCO2,
        CUST_DETAILS TYPE CHAR300,
        KBETR        TYPE CHAR30,
        CTBG_DETAILS TYPE CHAR300,
        REF          TYPE CHAR15,
        REF_TIME     TYPE CHAR15,
      END OF TY_DOWN.

DATA : IT_VAPMA TYPE TABLE OF TY_VAPMA,
       WA_VAPMA TYPE          TY_VAPMA,

       IT_VBAP  TYPE TABLE OF TY_VBAP,
       WA_VBAP  TYPE          TY_VBAP,

       IT_EKPO  TYPE TABLE OF TY_EKPO,
       WA_EKPO  TYPE          TY_EKPO,

       IT_EKKO  TYPE TABLE OF TY_EKKO,
       WA_EKKO  TYPE          TY_EKKO,

       IT_VBKD  TYPE TABLE OF TY_VBKD,
       WA_VBKD  TYPE          TY_VBKD,

       IT_KONV  TYPE TABLE OF TY_KONV,
       WA_KONV  TYPE          TY_KONV,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE          TY_FINAL,

       IT_DOWN  TYPE TABLE OF TY_DOWN,
       WA_DOWN  TYPE          TY_DOWN.

DATA: IT_FCAT   TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT   LIKE LINE OF IT_FCAT,
      GT_LAYOUT TYPE SLIS_LAYOUT_ALV,
      GT_EVENT  TYPE SLIS_T_EVENT        WITH HEADER LINE.


DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.

DATA : LV_TEXT TYPE STRING.
*DATA : lv_ctbg_details(50000)." TYPE string.

SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: SO FOR VAPMA-VBELN.
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'."Saudi'."Saudi'."Saudi'. "'/Delval/Saudi'."Saudi'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.

START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM SORT_DATA.
  PERFORM GET_FCAT.
*  PERFORM f_layout.
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
  SELECT MATNR
         VKORG
         VTWEG
         KUNNR
         BSTNK
         VBELN
         POSNR
         WERKS FROM VAPMA INTO TABLE IT_VAPMA
         WHERE VBELN IN SO
         AND KUNNR = '0000300315'.

  IF IT_VAPMA IS NOT INITIAL.
    SELECT VBELN
           POSNR
           MATNR
           NETPR
           POSEX
           ABGRU
           KWMENG
           WAERK
          FROM VBAP INTO TABLE IT_VBAP
           FOR ALL ENTRIES IN IT_VAPMA
           WHERE VBELN = IT_VAPMA-VBELN
            AND  POSNR = IT_VAPMA-POSNR.


    SELECT VBELN
           POSNR
           INCO1
           INCO2 FROM VBKD INTO TABLE IT_VBKD
           FOR ALL ENTRIES IN IT_VAPMA
           WHERE VBELN = IT_VAPMA-VBELN
            AND  POSNR = IT_VAPMA-POSNR.


    SELECT EBELN
           EBELP
           LOEKZ
           MATNR
           BUKRS
           WERKS
           NETPR
           MENGE
           INCO1
           INCO2 FROM EKPO INTO TABLE IT_EKPO
           FOR ALL ENTRIES IN IT_VAPMA
           WHERE EBELN = IT_VAPMA-BSTNK.
*           AND ebelp = it_vapma-posnr.

  ENDIF.


  IF IT_EKPO IS NOT INITIAL.
    SELECT EBELN
           BEDAT
           INCO1
           INCO2
           KNUMV
           WAERS
           FROM EKKO INTO TABLE IT_EKKO
           FOR ALL ENTRIES IN IT_EKPO
           WHERE EBELN = IT_EKPO-EBELN.


  ENDIF.
  IF IT_EKKO IS NOT INITIAL.
    SELECT KNUMV
           KPOSN
           STUNR
           ZAEHK
           KBETR
           KSCHL
           FROM prcd_elements
           INTO TABLE IT_KONV
           FOR ALL ENTRIES IN IT_EKKO
           WHERE KNUMV = IT_EKKO-KNUMV
           AND STUNR = '1'.




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
  LOOP AT IT_VAPMA INTO WA_VAPMA.
    WA_FINAL-VBELN = WA_VAPMA-VBELN.
    WA_FINAL-POSNR = WA_VAPMA-POSNR.

    READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_FINAL-VBELN POSNR = WA_FINAL-POSNR.
    IF SY-SUBRC = 0.
      WA_FINAL-SO_RATE = WA_VBAP-NETPR.
      WA_FINAL-SO_MATNR = WA_VBAP-MATNR.
      WA_FINAL-ABGRU   = WA_VBAP-ABGRU.
      WA_FINAL-SO_QTY   = WA_VBAP-KWMENG.
      WA_FINAL-SO_CURRENCY = WA_VBAP-WAERK. " Added by shubhangi sarode on dt 31.01.2024 so currency
    ENDIF.
********************************************************  Added by shubhangi sarode on dt 01.02.2024 So Del Indicatot
    IF WA_FINAL-ABGRU IS NOT INITIAL.
      WA_FINAL-SO_DEL_IND = 'YES'.
    ELSE.
      WA_FINAL-SO_DEL_IND = 'NO'.
    ENDIF.
******************************************************* End on 01.02.2024

    READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_FINAL-VBELN
                                             POSNR = WA_FINAL-POSNR.
    IF SY-SUBRC = 0.
      WA_FINAL-SO_INCO1   = WA_VBKD-INCO1.
      WA_FINAL-SO_INCO2   = WA_VBKD-INCO2.
    ENDIF.

    IF WA_FINAL-SO_INCO1 IS INITIAL .
      SELECT SINGLE INCO1 INCO2 INTO ( WA_FINAL-SO_INCO1 , WA_FINAL-SO_INCO2 ) FROM VBKD WHERE VBELN = WA_FINAL-VBELN.
    ENDIF.

    SELECT SINGLE WRKST INTO WA_FINAL-WRKST FROM MARA WHERE MATNR = WA_FINAL-SO_MATNR.
    SELECT SINGLE BEZEI INTO WA_FINAL-SO_RES FROM TVAGT WHERE ABGRU = WA_FINAL-ABGRU AND SPRAS ='EN'.

    READ TABLE IT_EKPO INTO WA_EKPO WITH KEY EBELN = WA_VAPMA-BSTNK EBELP = WA_VBAP-POSEX.
    IF SY-SUBRC = 0.
      WA_FINAL-EBELN = WA_EKPO-EBELN.
      WA_FINAL-EBELP = WA_EKPO-EBELP.
      WA_FINAL-PO_RATE = WA_EKPO-NETPR.
      WA_FINAL-PO_MATNR = WA_EKPO-MATNR.
      WA_FINAL-PO_QTY = WA_EKPO-MENGE.

      IF WA_EKPO-LOEKZ = 'L'.
        WA_FINAL-PO_RES = 'YES'.
      ELSE.
        WA_FINAL-PO_RES = 'NO'.
      ENDIF.
    ENDIF.

**------Added by Awais on 03.11.2023-------*
*    IF WA_FINAL-POSNR EQ WA_FINAL-EBELP AND WA_FINAL-SO_MATNR EQ WA_FINAL-PO_MATNR.
*      WA_FINAL-PO_RES1 = 'YES'.
*    ELSE.
*      WA_FINAL-PO_RES1 = 'NO'.
*    ENDIF.
**------Ended by Awais on 03.11.2023-------*

*------Added by Sanjay on 03.11.2023-------*
    IF  WA_FINAL-SO_MATNR EQ WA_FINAL-PO_MATNR.
      WA_FINAL-PO_RES1 = 'YES'.
    ELSE.
      WA_FINAL-PO_RES1 = 'NO'.
    ENDIF.
*------Ended by Sanjay on 03.11.2023-------*

    CLEAR: LV_LINES,WA_LINES,LV_NAME.
    REFRESH LV_LINES.
*      lv_name = wa_final-ebeln.
    CONCATENATE WA_FINAL-EBELN WA_FINAL-EBELP INTO LV_NAME.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'F09'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'EKPO'
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
          CONCATENATE WA_FINAL-TEXT WA_LINES-TDLINE INTO WA_FINAL-TEXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.

    ENDIF.

    READ TABLE IT_EKKO INTO WA_EKKO WITH KEY EBELN = WA_FINAL-EBELN .
    IF SY-SUBRC = 0.
      WA_FINAL-BEDAT = WA_EKKO-BEDAT.
      WA_FINAL-PO_INCO1 = WA_EKKO-INCO1.
      WA_FINAL-PO_INCO2 = WA_EKKO-INCO2.
      WA_FINAL-PO_CURRENCY = WA_EKKO-WAERS.             "Added by Shubhangi Sarode on dt 31.01.2024 PO Currency
    ENDIF.


    READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_EKKO-KNUMV KPOSN = WA_FINAL-EBELP.     "kposn = wa_final-posnr..
    IF SY-SUBRC = 0.
      WA_FINAL-KBETR = WA_KONV-KBETR.
    ENDIF.

***********Avinash Bhagat
    CLEAR: LV_LINES,WA_LINES,LV_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-EBELN.
*      CONCATENATE wa_final-ebeln wa_final-ebelp INTO lv_name.
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
          CONCATENATE WA_FINAL-CUST_DETAILS WA_LINES-TDLINE INTO WA_FINAL-CUST_DETAILS SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.

    ENDIF.

    REPLACE ALL OCCURRENCES OF '<(>' IN WA_FINAL-CUST_DETAILS WITH SPACE.
    REPLACE ALL OCCURRENCES OF '<)>' IN WA_FINAL-CUST_DETAILS WITH SPACE.

***********END AVINASH

*    SELECT SINGLE BEDAT INTO WA_FINAL-BEDAT FROM EKKO WHERE EBELN = WA_FINAL-EBELN.
    SELECT SINGLE KDGRP INTO WA_FINAL-KDGRP FROM VBKD WHERE VBELN = WA_FINAL-VBELN AND POSNR = ' '.
    WA_FINAL-DIFF = WA_FINAL-SO_RATE - WA_FINAL-PO_RATE.
*    WA_FINAL-QTY_DIFF = WA_FINAL-PO_QTY - WA_FINAL-SO_QTY.

*---------------------------------------------------------------------------------------------*"Added By PB 05.03.2022

    CLEAR: LV_LINES,WA_LINES,LV_NAME.
    REFRESH LV_LINES.

    CONCATENATE WA_FINAL-EBELN WA_FINAL-EBELP INTO LV_TEXT.
    LV_NAME = LV_TEXT.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'F08'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_NAME
        OBJECT                  = 'EKPO'
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

    IF NOT LV_LINES IS INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL.
          CONCATENATE WA_FINAL-CTBG_DETAILS WA_LINES-TDLINE INTO WA_FINAL-CTBG_DETAILS SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
    ENDIF.
*---------------------------------------------------------------------------------------------*"Added By PB 05.03.2022

********************************************************************* Code added by Shubhangi Sarode so po diff on date 31.01.2024
    IF WA_FINAL-SO_CURRENCY = WA_FINAL-PO_CURRENCY.
      WA_FINAL-SO_PO_DIFF = 'YES'.
    ELSE.
      WA_FINAL-SO_PO_DIFF = 'NO'.
    ENDIF.
********************************************************************* End on so po diff on date 31.01.2024



    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
  ENDLOOP.

  SORT IT_FINAL BY VBELN POSNR.
  DELETE IT_FINAL WHERE EBELN = ' '.
  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.

      WA_DOWN-EBELN       = WA_FINAL-EBELN     .
      WA_DOWN-EBELP       = WA_FINAL-EBELP     .
      WA_DOWN-PO_MATNR    = WA_FINAL-PO_MATNR  .
      WA_DOWN-VBELN       = WA_FINAL-VBELN     .
      WA_DOWN-POSNR       = WA_FINAL-POSNR     .
      WA_DOWN-SO_MATNR    = WA_FINAL-SO_MATNR  .
      WA_DOWN-PO_RATE     = WA_FINAL-PO_RATE   .
      WA_DOWN-SO_RATE     = WA_FINAL-SO_RATE   .
      WA_DOWN-PO_CURRENCY = WA_FINAL-PO_CURRENCY  .      "Added by Shubhangi Sarode on dt 31.01.2024
      WA_DOWN-SO_CURRENCY = WA_FINAL-SO_CURRENCY  .      "Added by Shubhangi Sarode on dt 31.01.2024
      WA_DOWN-SO_PO_DIFF  = WA_FINAL-SO_PO_DIFF .             "Added by Shubhangi Sarode on dt 31.01.2024
      WA_DOWN-DIFF        = WA_FINAL-DIFF      .
      WA_DOWN-ABGRU        = WA_FINAL-ABGRU      .
      WA_DOWN-SO_RES        = WA_FINAL-SO_RES      .
      WA_DOWN-PO_RES        = WA_FINAL-PO_RES      .
      WA_DOWN-SO_DEL_IND    = WA_FINAL-SO_DEL_IND     .   "Added by Shubhangi Sarode on dt 01.02.2024 so del indicator
      WA_DOWN-PO_RES1        = WA_FINAL-PO_RES1      .
      WA_DOWN-SO_QTY        = WA_FINAL-SO_QTY      .
      WA_DOWN-PO_QTY        = WA_FINAL-PO_QTY      .
      WA_DOWN-KDGRP         = WA_FINAL-KDGRP.
      WA_DOWN-TEXT          = WA_FINAL-TEXT .
      WA_DOWN-CUST_DETAILS  = WA_FINAL-CUST_DETAILS .
      WA_DOWN-WRKST         = WA_FINAL-WRKST.
      WA_DOWN-SO_INCO1      = WA_FINAL-SO_INCO1.
      WA_DOWN-SO_INCO2      = WA_FINAL-SO_INCO2.
      WA_DOWN-PO_INCO1      = WA_FINAL-PO_INCO1.
      WA_DOWN-PO_INCO2      = WA_FINAL-PO_INCO2.
      WA_DOWN-CTBG_DETAILS  = WA_FINAL-CTBG_DETAILS.

      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = WA_DOWN-DIFF.

      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = WA_DOWN-PO_RATE.

      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = WA_DOWN-SO_RATE.


      IF WA_FINAL-BEDAT IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-BEDAT
          IMPORTING
            OUTPUT = WA_DOWN-BEDAT.

        CONCATENATE WA_DOWN-BEDAT+0(2) WA_DOWN-BEDAT+2(3) WA_DOWN-BEDAT+5(4)
                        INTO WA_DOWN-BEDAT SEPARATED BY '-'.
      ENDIF.


      WA_DOWN-REF = SY-DATUM.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_DOWN-REF
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

      "added by pankaj 28.12.2021
      WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

      WA_DOWN-KBETR = WA_FINAL-KBETR.
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

  PERFORM FCAT USING :  '1'  'EBELN '           'IT_FINAL'  'SA PO No'                       '18' ,
                        '2'  'EBELP '           'IT_FINAL'  'SA PO Item'                     '18' ,
                        '3'  'PO_MATNR'         'IT_FINAL'  'SA PO Code'                     '18' ,
                        '4'  'POSNR'            'IT_FINAL'  'IND SO Item'                    '18' ,
                        '5'  'SO_MATNR'         'IT_FINAL'  'IND SO Code'                    '18' ,
                        '6'  'PO_RES1'          'IT_FINAL'  'SA PO Item Code Match'          '18' ,
                        '7'  'VBELN'            'IT_FINAL'  'IND So No'                       '18' ,
                        '8'  'PO_RATE'          'IT_FINAL'  'PO Unit Price After Discount'    '30' ,
                        '10'  'PO_CURRENCY'     'IT_FINAL'  'PO Currency'                     '18' ,
                        '11'  'SO_RATE'         'IT_FINAL'  'IND SO Rate'                     '18' ,
                        '12'  'SO_CURRENCY'     'IT_FINAL'  'SO Currency'                     '18' ,
                        '13'  'SO_PO_DIFF'      'IT_FINAL'  'SO_PO Currency Match'            '25' ,
                        '14'  'DIFF'            'IT_FINAL'  'Difference'                      '18' ,
                        '15'  'PO_RES'          'IT_FINAL'  'PO Del.Ind.'                     '18' ,
                        '16'  'SO_DEL_IND'      'IT_FINAL'  'SO Del.Ind.'                     '18' ,        "SO Del.Ind. added by Shubhangi Sarode on 01.02.2024
                        '17'  'ABGRU'           'IT_FINAL'  'Rejection Code'                     '18' ,
                        '18'  'SO_RES'          'IT_FINAL'  'Reason For Rejection'            '18' ,
                        '19'  'PO_QTY'          'IT_FINAL'  'PO Quantity'                     '18' ,
                        '20'  'SO_QTY'          'IT_FINAL'  'SO Quantity'                     '18' ,
                        '21'  'BEDAT'           'IT_FINAL'  'PO Date'                         '18' ,
                        '22'  'KDGRP'           'IT_FINAL'  'Customer Group'                  '18' ,
                        '23'  'TEXT'            'IT_FINAL'  'SA Part No.ON CTBG'             '18' ,
                        '24'  'WRKST'           'IT_FINAL'  'SA Part No.India SO'            '18' ,
                        '25'  'PO_INCO1'        'IT_FINAL'  'Po Incoterms'                    '18' ,
                        '26'  'PO_INCO2'        'IT_FINAL'  'Po Inco Desc.'                   '18' ,
                        '27'  'SO_INCO1'        'IT_FINAL'  'So Incoterms'                    '18' ,
                        '28'  'SO_INCO2'        'IT_FINAL'  'So Inco Desc.'                   '18' ,
                        '29'  'CUST_DETAILS'    'IT_FINAL'  'Customer Details'                '18' ,
                        '30'   'KBETR'           'IT_FINAL'  'PO Unit Price Before Discount'   '30' ,
                        '31'  'CTBG_DETAILS'    'IT_FINAL'  'SA CTBG Details'            '50' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0377   text
*      -->P_0378   text
*      -->P_0379   text
*      -->P_0380   text
*      -->P_0381   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(P1)
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
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND = 'USER_CMD'
*     i_callback_top_of_page = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     is_layout          = gt_layout
      IT_FIELDCAT        = IT_FCAT
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            = t_sort[]
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
      I_SAVE             = 'X'
*     IS_VARIANT         =
*it_events               = gt_event[]
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
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
*     ES_EXIT_CAUSED_BY_USER =
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


  LV_FILE = 'ZSU_PO_VERIFY.TXT'.


*  CONCATENATE P_FOLDER '\' SY-DATUM SY-UZEIT LV_FILE
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_PO_VERIFY REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_803 TYPE string.
DATA lv_crlf_803 TYPE string.
lv_crlf_803 = cl_abap_char_utilities=>cr_lf.
lv_string_803 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_803 lv_crlf_803 wa_csv INTO lv_string_803.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_574 TO lv_fullfile.
TRANSFER lv_string_803 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

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


  LV_FILE = 'ZSU_PO_VERIFY.TXT'.


*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_PO_VERIFY REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_841 TYPE string.
DATA lv_crlf_841 TYPE string.
lv_crlf_841 = cl_abap_char_utilities=>cr_lf.
lv_string_841 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_841 lv_crlf_841 wa_csv INTO lv_string_841.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_574 TO lv_fullfile.
TRANSFER lv_string_841 TO lv_fullfile.
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

  CONCATENATE 'SA PO No'
              'SA PO Item'
              'SA PO Code'
              'IND So No'
              'IND SO Item'
              'IND SO Code'
              'SA PO Item Code Match'
              'PO Unit Price After Discount'
              'IND SO Rate'
              'PO Currency'
              'SO Currency'
              'SO_PO Currency Match'
              'Difference'
              'PO Del.Ind.'
              'SO Del.Ind.'
              'Rejection Code'
              'Reason For Rejection'
              'PO Quantity'
              'SO Quantity'
              'PO Date'
              'Customer Group'
              'SA Part No.-ON CTBG'
              'SA Part No.-India SO'
              'Po Incoterms'
              'Po Inco Desc.'
              'So Incoterms'
              'So Inco Desc.'
              'Customer Details'
              'PO Unit Price Before Discount'
              'SA CTBG DETIALS'
              'Refresh On'
              'Ref Time'

               INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
