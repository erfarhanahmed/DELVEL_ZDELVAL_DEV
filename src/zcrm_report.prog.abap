*&---------------------------------------------------------------------*
*& Report ZCRM_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCRM_REPORT.

TABLES: VBAK,VBAP.

TYPES : BEGIN OF TY_VAPMA,
          VBELN TYPE VAPMA-VBELN,
          POSNR TYPE VAPMA-POSNR,
          MATNR TYPE VAPMA-MATNR,
          VKORG TYPE VAPMA-VKORG,
          AUDAT TYPE VAPMA-AUDAT,
          KUNNR TYPE VAPMA-KUNNR,
          VKBUR TYPE VAPMA-VKBUR,
          WERKS TYPE VAPMA-WERKS,
        END OF TY_VAPMA,

        BEGIN OF TY_VBAK,
          VBELN       TYPE VBAK-VBELN,
          ERDAT       TYPE VBAK-ERDAT,
          VKORG       TYPE VBAK-VKORG,
          AUDAT       TYPE VBAK-AUDAT,
          KUNNR       TYPE VBAK-KUNNR,
          VKBUR       TYPE VBAK-VKBUR,
          NETWR       TYPE VBAK-NETWR,
          WAERK       TYPE VBAK-WAERK,
          KNUMV       TYPE VBAK-KNUMV,
          VDATU       TYPE VBAK-VDATU,
          ZLDFROMDATE TYPE VBAK-ZLDFROMDATE,
          ZLDPERWEEK  TYPE VBAK-ZLDPERWEEK,
          ZLDMAX      TYPE VBAK-ZLDMAX,
        END OF TY_VBAK,

        BEGIN OF TY_VBKD,
          VBELN TYPE VBKD-VBELN,
          POSNR TYPE VBKD-POSNR,
          ZTERM TYPE VBKD-ZTERM,
          BSTKD TYPE VBKD-BSTKD,
          BSTDK TYPE VBKD-BSTDK,
          INCO1 TYPE VBKD-INCO1,
          INCO2 TYPE VBKD-INCO2,
          KURSK TYPE VBKD-KURSK,
        END OF TY_VBKD,


        BEGIN OF TY_KONV,
          KNUMV TYPE PRCD_ELEMENTS-KNUMV,
          KSCHL TYPE PRCD_ELEMENTS-KSCHL,
          KWERT TYPE PRCD_ELEMENTS-KWERT,
          KINAK TYPE PRCD_ELEMENTS-KINAK,
          KBETR TYPE PRCD_ELEMENTS-KBETR,
        END OF TY_KONV,

        BEGIN OF TY_FINAL,
          VBELN           TYPE VAPMA-VBELN,
          POSNR           TYPE VAPMA-POSNR,
          AUDAT           TYPE CHAR11, "VBAK-AUDAT,
          KUNNR           TYPE VBAK-KUNNR,
          VKBUR           TYPE VBAK-VKBUR,
          NETWR           TYPE CHAR50,
          WERKS           TYPE VBAP-WERKS,
          ZLDPERWEEK      TYPE VBAK-ZLDPERWEEK,
          ZLDMAX          TYPE VBAK-ZLDMAX,
          ZLDFROMDATE     TYPE CHAR11, "VBAK-ZLDFROMDATE,
          ZTERM           TYPE VBKD-ZTERM,
          VTEXT           TYPE TVZBT-VTEXT,
          INCO1           TYPE VBKD-INCO1,
          INCO2           TYPE VBKD-INCO2,
          OFM             TYPE CHAR255,
          OFM_DATE        TYPE CHAR255,
          PART            TYPE CHAR255,
          ZGAD            TYPE VBAP-ZGAD,


          NAME1           TYPE KNA1-NAME1,
          REF_NO          TYPE CHAR255,
          TAG             TYPE CHAR255,
          TPI             TYPE CHAR255,
          LD              TYPE CHAR255,


          Z90             TYPE CHAR255,
          Z91             TYPE CHAR255,
          Z92             TYPE CHAR255,
          Z93             TYPE CHAR255,
          Z94             TYPE CHAR255,
          Z95             TYPE CHAR255,
          Z96             TYPE CHAR255,
          Z97             TYPE CHAR255,
          Z98             TYPE CHAR255,
          BSTKD           TYPE VBKD-BSTKD,
          BSTDK           TYPE CHAR11, "VBKD-BSTDK,
          VDATU           TYPE CHAR11, "VBAK-VDATU,
          ZZ90            TYPE CHAR255,
          ZPR0            TYPE CHAR30,
          CURRENCY        TYPE VBAK-WAERK,
          EXCH_RATE       TYPE VBKD-KURSK,
          ZCUST_PROJ_NAME TYPE CHAR250, "added by jyoti on 04.12.2024
*          CTBG        TYPE VBAP-CTBG,
          AMENDMENT_HIS   TYPE CHAR250, "added by jyoti on 20.01.2025
          PO_DIS          TYPE CHAR250, "added by jyoti on 20.01.2025
          OFM_REC_DATE    TYPE CHAR255,
          OSS_REC_DATE    TYPE CHAR255,
          SOURCE_REST     TYPE CHAR255,
          SUPPL_REST      TYPE CHAR255,
*          DIS_RATE        TYPE PRCD_ELEMENTS-KBETR,        "Discount

          TOT_ASS         TYPE STRING, "PRCD_ELEMENTS-KBETR,        "Discount
          ASS2_VAL        TYPE STRING, "PRCD_ELEMENTS-KWERT,
          DIS_RATE        TYPE P DECIMALS 2,
          DIS_AMT2        TYPE P DECIMALS 2,        "Discount
          DIS_AMT         TYPE CHAR40,        "Discount
          DIS_UNIT_RATE2  TYPE P DECIMALS 2, "PRCD_ELEMENTS-KWERT,
          DIS_UNIT_RATE   TYPE STRING, "PRCD_ELEMENTS-KWERT,
        END OF TY_FINAL,


        BEGIN OF TY_DOWN,
          NAME1           TYPE KNA1-NAME1,
          VKBUR           TYPE VBAK-VKBUR,
          VBELN           TYPE VAPMA-VBELN,
*        posnr       TYPE vapma-posnr,
          AUDAT           TYPE CHAR15,
          NETWR           TYPE CHAR40,
          TAG             TYPE CHAR255,
          TPI             TYPE CHAR255,
          LD              TYPE CHAR255,
          ZLDPERWEEK      TYPE VBAK-ZLDPERWEEK,
          ZLDMAX          TYPE VBAK-ZLDMAX,
          ZLDFROMDATE     TYPE CHAR15,
          ZTERM           TYPE VBKD-ZTERM,
          VTEXT           TYPE TVZBT-VTEXT,
          INCO1           TYPE VBKD-INCO1,
          INCO2           TYPE VBKD-INCO2,
          OFM             TYPE CHAR255,
          OFM_DATE        TYPE CHAR255,
          PART            TYPE CHAR255,
*        zgad        TYPE vbap-zgad,
          Z90             TYPE CHAR255,
          Z91             TYPE CHAR255,
          Z92             TYPE CHAR255,
          Z93             TYPE CHAR255,
          Z94             TYPE CHAR255,
          Z95             TYPE CHAR255,
          Z96             TYPE CHAR255,
          Z97             TYPE CHAR255,
          Z98             TYPE CHAR255,
          REF             TYPE CHAR15,
          TIME            TYPE CHAR10,
          VDATU           TYPE CHAR15,
          BSTKD           TYPE VBKD-BSTKD,
          BSTDK           TYPE CHAR15,
          ZZ90            TYPE CHAR255,
          ZPR0            TYPE CHAR15,
          CURRENCY        TYPE CHAR5,
          EXCH_RATE       TYPE CHAR250,
          ZCUST_PROJ_NAME TYPE STRING, "ADDED BY JYOTI ON 04.12.2024
          AMENDMENT_HIS   TYPE STRING, "added by jyoti on 20.01.2025
          PO_DIS          TYPE STRING, "added by jyoti on 20.01.2025
*          CTBG        TYPE CHAR10,   " ADDED BY AJAY>
          OFM_REC_DATE    TYPE CHAR255,
          OSS_REC_DATE    TYPE CHAR255,
          SOURCE_REST     TYPE CHAR255,
          SUPPL_REST      TYPE CHAR255,
          DIS_RATE        TYPE STRING, "P DECIMALS 2,
          DIS_AMT         TYPE STRING, "PRCD_ELEMENTS-KWERT,        "Discount
          DIS_UNIT_RATE   TYPE STRING, "PRCD_ELEMENTS-KWERT,
        END OF TY_DOWN.

DATA:IT_DOWN TYPE TABLE OF TY_DOWN,
     WA_DOWN TYPE          TY_DOWN.

DATA : IT_VAPMA TYPE TABLE OF TY_VAPMA,
       WA_VAPMA TYPE          TY_VAPMA,

       IT_VBAK  TYPE TABLE OF TY_VBAK,
       WA_VBAK  TYPE          TY_VBAK,

       IT_VBKD  TYPE TABLE OF TY_VBKD,
       WA_VBKD  TYPE          TY_VBKD,

       IT_KONV  TYPE STANDARD TABLE OF TY_KONV,
       WA_KONV  TYPE TY_KONV,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE          TY_FINAL.

DATA: LV_NAME           TYPE THEAD-TDNAME,
      LV_LINES          TYPE STANDARD TABLE OF TLINE,
      LS_LINES          LIKE TLINE,
      WA_CUST_PROJ_NAME TYPE TLINE, "ADDED BY JYOTIO N 04.12.2024
      WA_LINES          LIKE TLINE.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.
DATA : GV_KBETR2 TYPE PRCD_ELEMENTS-KBETR.
DATA : GV_KBETR3 TYPE PRCD_ELEMENTS-KBETR.
DATA : GV_KBETR TYPE PRCD_ELEMENTS-KBETR.
DATA : GV_KWERT TYPE PRCD_ELEMENTS-KWERT.
DATA : GV_KWERT2 TYPE PRCD_ELEMENTS-KWERT.



SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : S_AUDAT FOR VBAK-AUDAT OBLIGATORY,
                   S_KUNNR FOR VBAK-KUNNR,
                   S_VBELN FOR VBAK-VBELN.
  PARAMETERS     : P_WERKS TYPE VBAP-WERKS OBLIGATORY DEFAULT 'PL01'.
SELECTION-SCREEN : END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT  '/Delval/India'."India'."India'."temp'."'/Delval/India'."temp_'.            "'/delval/temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-006.
SELECTION-SCREEN END OF LINE.


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
  SELECT VBELN
         POSNR
         MATNR
         VKORG
         AUDAT
         KUNNR
         VKBUR
         WERKS FROM VAPMA INTO TABLE IT_VAPMA
         WHERE AUDAT IN S_AUDAT
           AND KUNNR IN S_KUNNR
           AND VBELN IN S_VBELN
           AND WERKS = P_WERKS.

  IF  IT_VAPMA IS NOT INITIAL.
    SELECT VBELN
           ERDAT
           VKORG
           AUDAT
           KUNNR
           VKBUR
           NETWR
           WAERK
           KNUMV
           VDATU
           ZLDFROMDATE
           ZLDPERWEEK
           ZLDMAX      FROM VBAK INTO TABLE IT_VBAK
           FOR ALL ENTRIES IN IT_VAPMA
           WHERE VBELN = IT_VAPMA-VBELN.

    SELECT VBELN
           POSNR
           ZTERM
           BSTKD
           BSTDK
           INCO1
           INCO2
           KURSK FROM VBKD INTO TABLE IT_VBKD
           FOR ALL ENTRIES IN IT_VAPMA
           WHERE VBELN = IT_VAPMA-VBELN.
*             AND posnr = it_vapma-posnr.


  ENDIF.

*if it_vbak is NOT INITIAL.
*
*
*  endif.

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

  LOOP AT IT_VBAK INTO WA_VBAK.
    WA_FINAL-VBELN = WA_VBAK-VBELN.
    WA_FINAL-KUNNR = WA_VBAK-KUNNR.
    WA_FINAL-AUDAT = WA_VBAK-AUDAT.
    IF WA_FINAL-AUDAT  IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-AUDAT
        IMPORTING
          OUTPUT = WA_FINAL-AUDAT.
      CONCATENATE WA_FINAL-AUDAT+0(2) WA_FINAL-AUDAT+2(3) WA_FINAL-AUDAT+5(4)
                     INTO WA_FINAL-AUDAT SEPARATED BY '-'.
      IF WA_FINAL-AUDAT = '--'.
        REPLACE ALL OCCURRENCES OF '--' IN WA_FINAL-AUDAT WITH ' '.
      ENDIF.

    ENDIF.
    WA_FINAL-VKBUR = WA_VBAK-VKBUR.


    WA_FINAL-NETWR         =  WA_VBAK-NETWR.
    WA_FINAL-ZLDFROMDATE   =  WA_VBAK-ZLDFROMDATE.
    IF WA_FINAL-ZLDFROMDATE IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-ZLDFROMDATE
        IMPORTING
          OUTPUT = WA_FINAL-ZLDFROMDATE.
      CONCATENATE WA_FINAL-ZLDFROMDATE+0(2) WA_FINAL-ZLDFROMDATE+2(3) WA_FINAL-ZLDFROMDATE+5(4)
                     INTO WA_FINAL-ZLDFROMDATE SEPARATED BY '-'.
      IF WA_FINAL-ZLDFROMDATE = '--'.
        REPLACE ALL OCCURRENCES OF '--' IN WA_FINAL-ZLDFROMDATE WITH ' '.
      ENDIF.
    ENDIF.
    WA_FINAL-ZLDPERWEEK    =  WA_VBAK-ZLDPERWEEK.
    WA_FINAL-ZLDMAX        =  WA_VBAK-ZLDMAX     .
    WA_FINAL-VDATU         =  WA_VBAK-VDATU.
    IF WA_FINAL-VDATU  IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-VDATU
        IMPORTING
          OUTPUT = WA_FINAL-VDATU.
      CONCATENATE WA_FINAL-VDATU+0(2) WA_FINAL-VDATU+2(3) WA_FINAL-VDATU+5(4)
                     INTO WA_FINAL-VDATU SEPARATED BY '-'.
      IF WA_FINAL-VDATU = '--'.
        REPLACE ALL OCCURRENCES OF '--' IN WA_FINAL-VDATU WITH ' '.
      ENDIF.

    ENDIF.
    WA_FINAL-CURRENCY         =  WA_VBAK-WAERK.


    SELECT
      KNUMV
      KSCHL
      KWERT
      KINAK
      KBETR
      FROM PRCD_ELEMENTS INTO TABLE IT_KONV  WHERE KNUMV = WA_VBAK-KNUMV
      AND KINAK = ' '.
    LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_VBAK-KNUMV AND KSCHL = 'ZPR0' AND KINAK = SPACE.
      WA_FINAL-ZPR0 = WA_FINAL-ZPR0 + WA_KONV-KWERT.
    ENDLOOP.
    IF WA_FINAL-ZPR0 IS INITIAL.
      WA_FINAL-ZPR0 = '0'.
    ENDIF.
    LOOP AT IT_KONV INTO DATA(WA_KONV1) WHERE KNUMV = WA_VBAK-KNUMV AND KSCHL = 'ZDIS'.
*      WA_FINAL-ZPR0 = WA_FINAL-ZPR0 + WA_KONV-KWERT.

      WA_FINAL-DIS_RATE = ABS( WA_KONV1-KBETR )."ADDED BY MAHADEV hement ON 10/12/2025
      GV_KBETR2 = WA_KONV-KBETR * WA_KONV1-KBETR / 100  . "ADDED BY MAHADEV hement ON 10/12/2025
      GV_KBETR = GV_KBETR2 - ( - WA_KONV-KBETR ). "ADDED BY MAHADEV hement ON 10/12/2025
      GV_KWERT = WA_KONV1-KWERT.

*      WA_FINAL-DIS_AMT  = abs( WA_KONV1-KWERT ).
      WA_FINAL-DIS_AMT2  = ABS( GV_KBETR2 ).
      WA_FINAL-DIS_AMT = WA_FINAL-DIS_AMT2.

    ENDLOOP.
    IF WA_FINAL-DIS_AMT IS  INITIAL.
      WA_FINAL-DIS_AMT = WA_FINAL-DIS_AMT2.
      CONDENSE WA_FINAL-DIS_AMT.
    ENDIF.
*    BREAK ctpl.
    IF GV_KBETR IS INITIAL .
      WA_FINAL-DIS_UNIT_RATE2  = WA_KONV-KBETR.
      WA_FINAL-DIS_UNIT_RATE  = WA_FINAL-DIS_UNIT_RATE2.
    ENDIF.
*    WA_FINAL-DIS_UNIT_RATE  =  WA_KONV-KWERT - ( - WA_KONV1-KWERT ).
    IF GV_KBETR IS NOT INITIAL.
      WA_FINAL-DIS_UNIT_RATE2  =  GV_KBETR.
      WA_FINAL-DIS_UNIT_RATE = WA_FINAL-DIS_UNIT_RATE2.
    ENDIF.
*     WA_FINAL-ASS2_VAL = WA_KONV-KWERT - ( - GV_Kwert ). " ADDED BY MAHADEV HEMENT ON 10/12/2025
*
*    "" TOTAL assesable value
*     WA_FINAL-TOT_ASS = GV_KBETR . " ADDED BY MAHADEV HEMENT ON 10/12/2025




*LOOP AT it_vapma INTO wa_vapma.
*  wa_final-vbeln = wa_vapma-vbeln.
*  wa_final-posnr = wa_vapma-posnr.
*  wa_final-kunnr = wa_vapma-kunnr.
*  wa_final-AUDAT = wa_vapma-AUDAT.
*  wa_final-VKBUR = wa_vapma-VKBUR.
*  wa_final-WERKS = wa_vapma-WERKS.

*READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vapma-vbeln.
*  IF  sy-subrc = 0.
*    wa_final-netwr         =  wa_vbak-netwr.
*    wa_final-ZLDFROMDATE   =  wa_vbak-ZLDFROMDATE.
*    wa_final-ZLDPERWEEK    =  wa_vbak-ZLDPERWEEK.
*    wa_final-ZLDMAX        =  wa_vbak-ZLDMAX     .
*  ENDIF.

    READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_FINAL-VBELN." posnr = wa_vapma-posnr.
    IF SY-SUBRC = 0.
      WA_FINAL-ZTERM = WA_VBKD-ZTERM.
      WA_FINAL-INCO1 = WA_VBKD-INCO1.
      WA_FINAL-INCO2 = WA_VBKD-INCO2.
      WA_FINAL-BSTKD = WA_VBKD-BSTKD.
      WA_FINAL-BSTDK = WA_VBKD-BSTDK.
      IF WA_FINAL-BSTDK IS NOT INITIAL .

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-BSTDK
          IMPORTING
            OUTPUT = WA_FINAL-BSTDK.
        CONCATENATE WA_FINAL-BSTDK+0(2) WA_FINAL-BSTDK+2(3) WA_FINAL-BSTDK+5(4)
                       INTO WA_FINAL-BSTDK SEPARATED BY '-'.
        IF WA_FINAL-BSTDK = '--'.
          REPLACE ALL OCCURRENCES OF '--' IN WA_FINAL-BSTDK WITH ' '.
        ENDIF.
      ENDIF.
    ENDIF.

    READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_FINAL-VBELN POSNR = SPACE." posnr = wa_vapma-posnr.
    IF SY-SUBRC = 0.
      WA_FINAL-EXCH_RATE = WA_VBKD-KURSK.
    ENDIF.

    GV_KWERT2 = WA_KONV-KWERT - ( - GV_KWERT ). " ADDED BY MAHADEV HEMENT ON 10/12/2025
    WA_FINAL-ASS2_VAL = GV_KWERT2 * WA_VBKD-KURSK. " ADDED BY MAHADEV HEMENT ON 10/12/2025

    "" TOTAL assesable value
    WA_FINAL-TOT_ASS = GV_KBETR * WA_VBKD-KURSK . " ADDED BY MAHADEV HEMENT ON 10/12/2025

    SELECT SINGLE VTEXT INTO WA_FINAL-VTEXT FROM TVZBT WHERE ZTERM = WA_FINAL-ZTERM AND SPRAS = 'EN'.

*SELECT SINGLE CTBG INTO wa_final-CTBG FROM vbap WHERE vbeln = wa_final-vbeln AND posnr = wa_final-posnr.

    SELECT SINGLE NAME1 INTO WA_FINAL-NAME1 FROM KNA1 WHERE KUNNR = WA_FINAL-KUNNR.


    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z039'
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
          CONCATENATE WA_FINAL-TAG WA_LINES-TDLINE INTO WA_FINAL-TAG SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TAG.
    ENDIF.

    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z999'
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
          CONCATENATE WA_FINAL-TPI WA_LINES-TDLINE INTO WA_FINAL-TPI SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-TPI.
    ENDIF.

    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z038'
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
          CONCATENATE WA_FINAL-LD WA_LINES-TDLINE INTO WA_FINAL-LD SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-LD.
    ENDIF.

    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z015'
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
          CONCATENATE WA_FINAL-OFM WA_LINES-TDLINE INTO WA_FINAL-OFM SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-OFM.
    ENDIF.

    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z016'
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

          CONCATENATE WA_FINAL-OFM_DATE WA_LINES-TDLINE INTO WA_FINAL-OFM_DATE SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-OFM_DATE.
    ENDIF.
*******************************ADDED BY JYOTI ON 04.12.2024
*************** CUSTOMER PROJECT NAME*********************
    CLEAR: LV_LINES,  WA_CUST_PROJ_NAME.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    IF LV_NAME IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z063'
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
    ENDIF.
    IF LV_LINES IS NOT INITIAL.
      LOOP AT LV_LINES INTO  WA_CUST_PROJ_NAME.
        IF  WA_CUST_PROJ_NAME-TDLINE IS NOT INITIAL.
          CONCATENATE WA_FINAL-ZCUST_PROJ_NAME  WA_CUST_PROJ_NAME-TDLINE INTO WA_FINAL-ZCUST_PROJ_NAME SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
    ENDIF.

*  *  *********************************ADDED BY JYOTI ON 20.01.2024**********************************
    CLEAR: LV_LINES."wa_cust_proj_name.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    IF LV_NAME IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z064'
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
    ENDIF.
    IF LV_LINES IS NOT INITIAL.
      LOOP AT LV_LINES INTO  WA_CUST_PROJ_NAME.
*          IF  wa_cust_proj_name-tdline IS NOT INITIAL.
        CONCATENATE WA_FINAL-AMENDMENT_HIS  WA_CUST_PROJ_NAME-TDLINE INTO WA_FINAL-AMENDMENT_HIS SEPARATED BY SPACE.
*          ENDIF.
      ENDLOOP.
    ENDIF.

    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    IF LV_NAME IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z065'
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
    ENDIF.
    IF LV_LINES IS NOT INITIAL.
      LOOP AT LV_LINES INTO  WA_CUST_PROJ_NAME.
*          IF  wa_cust_proj_name-tdline IS NOT INITIAL.
        CONCATENATE WA_FINAL-PO_DIS WA_CUST_PROJ_NAME-TDLINE INTO WA_FINAL-PO_DIS SEPARATED BY SPACE.
*          ENDIF.
      ENDLOOP.
    ENDIF.



*********************************************************************************************


    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z047'
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
          CONCATENATE WA_FINAL-PART WA_LINES-TDLINE INTO WA_FINAL-PART SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-PART.
    ENDIF.


    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'ZZ90'
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
          CONCATENATE WA_FINAL-Z90 WA_LINES-TDLINE INTO WA_FINAL-Z90 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-Z90.
    ENDIF.

    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'ZZ91'
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
          CONCATENATE WA_FINAL-Z91 WA_LINES-TDLINE INTO WA_FINAL-Z91 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-Z91.
    ENDIF.


    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'ZZ92'
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
          CONCATENATE WA_FINAL-Z92 WA_LINES-TDLINE INTO WA_FINAL-Z92 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-Z92.
    ENDIF.



    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'ZZ93'
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
          CONCATENATE WA_FINAL-Z93 WA_LINES-TDLINE INTO WA_FINAL-Z93 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-Z93.
    ENDIF.


    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'ZZ94'
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
          CONCATENATE WA_FINAL-Z94 WA_LINES-TDLINE INTO WA_FINAL-Z94 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-Z94.
    ENDIF.


    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'ZZ95'
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
          CONCATENATE WA_FINAL-Z95 WA_LINES-TDLINE INTO WA_FINAL-Z95 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-Z95.
    ENDIF.


    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'ZZ96'
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
          CONCATENATE WA_FINAL-Z96 WA_LINES-TDLINE INTO WA_FINAL-Z96 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-Z96.
    ENDIF.


    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'ZZ97'
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
          CONCATENATE WA_FINAL-Z97 WA_LINES-TDLINE INTO WA_FINAL-Z97 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-Z97.
    ENDIF.


    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'ZZ98'
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
          CONCATENATE WA_FINAL-Z98 WA_LINES-TDLINE INTO WA_FINAL-Z98 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-Z98.
    ENDIF.

    CLEAR: LV_LINES,WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'ZZ90'
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
          CONCATENATE WA_FINAL-ZZ90 WA_LINES-TDLINE INTO WA_FINAL-ZZ90 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-ZZ90.
    ENDIF.

*    ******added by Laxmi on 07.04.2025
    REFRESH :LV_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z066'
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
          CONCATENATE WA_FINAL-OFM_REC_DATE WA_LINES-TDLINE INTO WA_FINAL-OFM_REC_DATE SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-OFM_REC_DATE.
    ENDIF.
    REFRESH :LV_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z067'
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
          CONCATENATE WA_FINAL-OSS_REC_DATE WA_LINES-TDLINE INTO WA_FINAL-OSS_REC_DATE SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-OSS_REC_DATE.
    ENDIF.
********************************
    REFRESH :LV_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z068'
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
          CONCATENATE WA_FINAL-SOURCE_REST WA_LINES-TDLINE INTO WA_FINAL-SOURCE_REST SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-SOURCE_REST.
    ENDIF.
    REFRESH :LV_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'Z069'
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
          CONCATENATE WA_FINAL-SUPPL_REST WA_LINES-TDLINE INTO WA_FINAL-SUPPL_REST SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE WA_FINAL-SUPPL_REST.
    ENDIF.
*****ended
    APPEND WA_FINAL TO IT_FINAL.
    CLEAR :WA_FINAL.
    REFRESH : IT_KONV.

  ENDLOOP.

  IF P_DOWN = 'X'..
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-NAME1       = WA_FINAL-NAME1      .
      WA_DOWN-VKBUR       = WA_FINAL-VKBUR      .
      WA_DOWN-VBELN       = WA_FINAL-VBELN      .
*      WA_DOWN-posnr       = WA_FINAL-posnr      .
*      WA_DOWN-AUDAT       = WA_FINAL-AUDAT      .
      IF WA_FINAL-AUDAT IS NOT INITIAL.
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            INPUT  = WA_FINAL-AUDAT
*          IMPORTING
*            OUTPUT = WA_DOWN-AUDAT.
*
*        CONCATENATE WA_DOWN-AUDAT+0(2) WA_DOWN-AUDAT+2(3) WA_DOWN-AUDAT+5(4)
*                        INTO WA_DOWN-AUDAT SEPARATED BY '-'.
*        IF WA_DOWN-AUDAT = '--'.
*          REPLACE ALL OCCURRENCES OF '--' IN WA_DOWN-AUDAT WITH ' '.
*        ENDIF.
        WA_DOWN-AUDAT =    WA_FINAL-AUDAT.
      ENDIF.
      IF WA_FINAL-NETWR    < 0.
        CONDENSE WA_FINAL-NETWR   .
        REPLACE ALL OCCURRENCES OF '-' IN WA_FINAL-NETWR WITH ' '.
        CONCATENATE '-' WA_FINAL-NETWR    INTO WA_FINAL-NETWR   .
      ENDIF.
      CONDENSE WA_FINAL-NETWR   .
      WA_DOWN-NETWR       = WA_FINAL-NETWR      .
      CONDENSE WA_DOWN-NETWR   .


      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = WA_DOWN-NETWR.


      WA_DOWN-TAG         = WA_FINAL-TAG        .
      WA_DOWN-TPI         = WA_FINAL-TPI        .
      WA_DOWN-LD          = WA_FINAL-LD         .
      WA_DOWN-ZLDPERWEEK  = WA_FINAL-ZLDPERWEEK .
      WA_DOWN-ZLDMAX      = WA_FINAL-ZLDMAX     .
*      WA_DOWN-ZLDFROMDATE = WA_FINAL-ZLDFROMDATE.
      IF WA_FINAL-ZLDFROMDATE IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-ZLDFROMDATE
          IMPORTING
            OUTPUT = WA_DOWN-ZLDFROMDATE.

        CONCATENATE WA_DOWN-ZLDFROMDATE+0(2) WA_DOWN-ZLDFROMDATE+2(3) WA_DOWN-ZLDFROMDATE+5(4)
                        INTO WA_DOWN-ZLDFROMDATE SEPARATED BY '-'.
        IF WA_DOWN-ZLDFROMDATE = '--'.
          REPLACE ALL OCCURRENCES OF '--' IN WA_DOWN-ZLDFROMDATE WITH ' '.
        ENDIF.

      ENDIF.

      IF WA_FINAL-VDATU IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-VDATU
          IMPORTING
            OUTPUT = WA_DOWN-VDATU.

        CONCATENATE WA_DOWN-VDATU+0(2) WA_DOWN-VDATU+2(3) WA_DOWN-VDATU+5(4)
        INTO WA_DOWN-VDATU SEPARATED BY '-'.
        IF WA_DOWN-VDATU = '--'.
          REPLACE ALL OCCURRENCES OF '--' IN WA_DOWN-VDATU WITH ' '.

        ENDIF.

      ENDIF.

      IF WA_FINAL-BSTDK IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-BSTDK
          IMPORTING
            OUTPUT = WA_DOWN-BSTDK.

        CONCATENATE WA_DOWN-BSTDK+0(2) WA_DOWN-BSTDK+2(3) WA_DOWN-BSTDK+5(4)
        INTO WA_DOWN-BSTDK SEPARATED BY '-'.
        IF WA_DOWN-BSTDK = '--'.
          REPLACE ALL OCCURRENCES OF '--' IN WA_DOWN-BSTDK WITH ' '.
        ENDIF.

      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

      CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO WA_DOWN-TIME SEPARATED BY ':'.
      WA_DOWN-ZTERM       = WA_FINAL-ZTERM      .
      WA_DOWN-VTEXT       = WA_FINAL-VTEXT      .
      WA_DOWN-INCO1       = WA_FINAL-INCO1      .
      WA_DOWN-INCO2       = WA_FINAL-INCO2      .
      WA_DOWN-OFM         = WA_FINAL-OFM        .
      WA_DOWN-OFM_DATE    = WA_FINAL-OFM_DATE   .
      WA_DOWN-PART = WA_FINAL-PART.
*      WA_DOWN-zgad = WA_FINAL-zgad.
      WA_DOWN-Z90  = WA_FINAL-Z90 .
      WA_DOWN-Z91  = WA_FINAL-Z91 .
      WA_DOWN-Z92  = WA_FINAL-Z92 .
      WA_DOWN-Z93  = WA_FINAL-Z93 .
      WA_DOWN-Z94  = WA_FINAL-Z94 .
      WA_DOWN-Z95  = WA_FINAL-Z95 .
      WA_DOWN-Z96  = WA_FINAL-Z96 .
      WA_DOWN-Z97  = WA_FINAL-Z97 .
      WA_DOWN-Z98  = WA_FINAL-Z98 .
      WA_DOWN-ZZ90 = WA_FINAL-ZZ90.
      WA_DOWN-BSTKD = WA_FINAL-BSTKD.
*      BREAK CTPL.
      IF WA_FINAL-ZPR0    < 0.
        CONDENSE WA_FINAL-ZPR0   .
        CONCATENATE '-' WA_FINAL-ZPR0    INTO WA_FINAL-ZPR0   .
      ELSE.
        CONDENSE WA_FINAL-ZPR0 .
        WA_DOWN-ZPR0      = WA_FINAL-ZPR0     .
      ENDIF.
      WA_DOWN-CURRENCY  = WA_FINAL-CURRENCY .
      WA_DOWN-EXCH_RATE = WA_FINAL-EXCH_RATE.
      WA_DOWN-ZCUST_PROJ_NAME = WA_FINAL-ZCUST_PROJ_NAME.
      WA_DOWN-AMENDMENT_HIS = WA_FINAL-AMENDMENT_HIS.
      WA_DOWN-PO_DIS = WA_FINAL-PO_DIS.
*      wa_down-CTBG = wa_final-CTBG.
      WA_DOWN-OFM_REC_DATE = WA_FINAL-OFM_REC_DATE.
      WA_DOWN-OSS_REC_DATE = WA_FINAL-OSS_REC_DATE.
      WA_DOWN-SOURCE_REST = WA_FINAL-SOURCE_REST.
      WA_DOWN-SUPPL_REST = WA_FINAL-SUPPL_REST.
      IF WA_FINAL-DIS_AMT    < 0.
        CONDENSE WA_FINAL-DIS_AMT   .
        CONCATENATE '-' WA_FINAL-DIS_AMT    INTO WA_DOWN-DIS_AMT   .
      ELSE.
        WA_DOWN-DIS_AMT  = WA_FINAL-DIS_AMT .
      ENDIF.
*      WA_DOWN-DIS_AMT = WA_FINAL-DIS_AMT.
      WA_DOWN-DIS_RATE = WA_FINAL-DIS_RATE.
      WA_DOWN-DIS_UNIT_RATE = WA_FINAL-DIS_UNIT_RATE.
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
  PERFORM FCAT USING :   '1'   'NAME1'           'IT_FINAL'      'Customer_Name'                           '20' ,
                         '2'   'VKBUR'           'IT_FINAL'      'Sales_Office'                             '10',
                         '3'   'VBELN'           'IT_FINAL'      'Sales_Order_No'                           '18' ,
*                       '4'   'POSNR'           'IT_FINAL'      'Sales_Order_Item'                        '18' ,
                         '4'   'AUDAT'           'IT_FINAL'      'Sales_Order_Date'                        '18' ,
                         '5'   'NETWR'           'IT_FINAL'      'Pending_So_Amount'                       '18' ,
                         '6'   'TAG'             'IT_FINAL'      'Tag_Required'                           '18' ,
                         '7'   'TPI'             'IT_FINAL'      'TPI_Required'                           '18' ,
                         '8'   'LD'              'IT_FINAL'      'LD_Required'                            '18' ,
                         '9'   'ZLDPERWEEK'      'IT_FINAL'      'LD_Per_Week'                            '18' ,
                        '10'   'ZLDMAX'          'IT_FINAL'      'LD_Max'                                 '18' ,
                        '11'   'ZLDFROMDATE'     'IT_FINAL'      'LD_From_Date'                            '18' ,
                        '12'   'ZTERM'           'IT_FINAL'      'Payment_Terms'                           '18' ,
                        '13'   'VTEXT'           'IT_FINAL'      'Payment_Terms_Desc'                     '18' ,
                        '14'   'INCO1'           'IT_FINAL'      'Inco_Terms'                             '18' ,
                        '15'   'INCO2'           'IT_FINAL'      'Inco_Terms_Desc'                          '18' ,
                        '16'   'OFM'             'IT_FINAL'      'OFM_No'                                   '18' ,
                        '17'   'OFM_DATE'        'IT_FINAL'      'OFM_Date'                                 '18' ,
                        '18'   'PART'            'IT_FINAL'      'Partial_Delivery'                         '18' ,
*                      '20'   'ZGAD'            'IT_FINAL'      'GAD'                                      '18' ,
                        '19'   'Z90'             'IT_FINAL'      'Special_Instructions'                     '18' ,
                        '20'   'Z91'             'IT_FINAL'      'CRM Instructions'                          '18' ,
                        '21'   'Z92'             'IT_FINAL'      'Contract Review Date '                      '18' ,
                        '22'   'Z93'             'IT_FINAL'      'Engg Document Submission Trail '                  '18' ,
                        '23'   'Z94'             'IT_FINAL'      'Quality Document Submission Trail '                  '18' ,
                        '24'   'Z95'             'IT_FINAL'      'Order Given to Engg for Codes'                  '18' ,
                        '25'   'Z96'             'IT_FINAL'      'Code Receipt trail'                           '18' ,
                        '26'   'Z97'             'IT_FINAL'      'Order Given to PPC for Scheduling'                 '18' ,
                        '27'   'Z98'             'IT_FINAL'      'Order Ack Submitted ON'                            '18' ,
                        '28'   'VDATU'           'IT_FINAL'      'Customer Delivery date '                          '18' ,
                        '29'   'BSTKD'           'IT_FINAL'      'Customer PO reference no'                            '18' ,
                        '30'   'BSTDK'           'IT_FINAL'      'Customer PO date'                            '18' ,
                        '31'   'ZZ90'            'IT_FINAL'      'Special Instructions 2'                             '18' ,
                        '32'   'ZPR0'            'IT_FINAL'      'ZPR0 Condition'                             '18' ,
                        '33'   'CURRENCY'            'IT_FINAL'  'Currency'                             '18' ,
                        '34'   'EXCH_RATE'            'IT_FINAL' 'Exchange rate'                             '18' ,
                        '35'   'ZCUST_PROJ_NAME'            'IT_FINAL' 'Customer Project Name'                             '18' ,
                        '36'   'AMENDMENT_HIS'            'IT_FINAL' 'Amendment_history'                             '18' ,
                        '37'   'PO_DIS'            'IT_FINAL' 'Po Discrepancy'                             '18' ,
                        '38'   'OFM_REC_DATE'            'IT_ FINAL' 'OFM Received date from pre-sales'                             '18' ,
                        '39'   'OSS_REC_DATE'            'IT_FINAL' 'OSS Received from Technical Cell'                             '18' ,
                        '40'   'SOURCE_REST'            'IT_FINAL' 'Sourcing restrictions'                             '18' ,
                        '41'   'SUPPL_REST'            'IT_FINAL' 'Supplier restrictions'                             '18' ,
                        '42'   'DIS_RATE'            'IT_FINAL' 'Dis %'                             '18' ,
                        '43'   'DIS_AMT'            'IT_FINAL' 'Discount Amount'                             '18' ,
                        '44'   'DIS_UNIT_RATE'            'IT_FINAL' 'Discount Unit Rate'                             '18' .
*                        '32'   'CTBG'            'IT_FINAL'      'CTBG Details'                             '18' .
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
      I_SAVE             = 'X'
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
*      -->P_1934   text
*      -->P_1935   text
*      -->P_1936   text
*      -->P_1937   text
*      -->P_1938   text
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
*wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
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


  LV_FILE = 'ZCRM_REPORT.TXT'.


  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZCRM_REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1329 TYPE STRING.
    DATA LV_CRLF_1329 TYPE STRING.
    LV_CRLF_1329 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1329 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1329 LV_CRLF_1329 WA_CSV INTO LV_STRING_1329.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
*TRANSFER lv_string_805 TO lv_fullfile.
    TRANSFER LV_STRING_1329 TO LV_FULLFILE.
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


  LV_FILE = 'ZCRM_REPORT.TXT'.


  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZCRM_REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1367 TYPE STRING.
    DATA LV_CRLF_1367 TYPE STRING.
    LV_CRLF_1367 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1367 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1367 LV_CRLF_1367 WA_CSV INTO LV_STRING_1367.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
*TRANSFER lv_string_805 TO lv_fullfile.
    TRANSFER LV_STRING_1367 TO LV_FULLFILE.
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
  CONCATENATE  'Customer_Name'
               'Sales_Office'
               'Sales_Order_No'
*               'Sales_Order_Item'
               'Sales_Order_Date'
               'Pending_So_Amount'
               'Tag_Required'
               'TPI_Required'
               'LD_Required'
               'LD_Per_Week'
               'LD_Max'
               'LD_From_Date'
               'Payment_Terms'
               'Payment_Terms_Desc'
               'Inco_Terms'
               'Inco_Terms_Desc'
               'OFM_No'
               'OFM_Date'
               'Partial_Delivery'
*               'GAD'
               'Special_Instructions'
               'CRM Instructions'
               'Contract Review Date '
               'Engg Document Submission Trail '
               'Quality Document Submission Trail '
               'Order Given to Engg for Codes'
               'Code Receipt trail'
               'Order Given to PPC for Scheduling'
               'Order Ack Submitted ON'
               'Refresh Date'
               'Refresh Time'
               'Customer Delivery date '
               'Customer PO reference no'
               'Customer PO date'
               'Special Instructions 2'
               'ZPR0 Condition'
               'Currency'
               'Exchange rate'
               'Customer Project Name'
               'Amendment_history'
               'Po Discrepancy'
*               'CTBG Details'
               'OFM Received date from pre-sales'
               'OSS Received from Technical Cell'
               'Sourcing restrictions'
               'Supplier restrictions'
               'Dis %'               "added by mahadev 17.12.2025
               'Discount Amount'               "added by mahadev 17.12.2025
               'Discount Unit Rate'               "added by mahadev 17.12.2025
              INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
