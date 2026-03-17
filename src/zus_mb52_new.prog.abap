*&---------------------------------------------------------------------*
*&Report: ZUS_MB52_NEW
*&Transaction: ZUS_MB52
*&Functional Cosultant: Devshree kalamkar/Subhashish Pande
*&Technical Consultant: Shreya Sankpal / Nilay Brahme
*&TR: DEVK912309
*&Date: 15.11.2023
*&Owner: DelVal Flow Controls

*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_MB52_NEW.

TABLES:MARD,MARA.

TYPES: BEGIN OF TY_MARA,
         MATNR   TYPE MARA-MATNR,
         ZSERIES TYPE MARA-ZSERIES,
         ZSIZE   TYPE MARA-ZSIZE,
         BRAND   TYPE MARA-BRAND,
         MOC     TYPE MARA-MOC,
         TYPE    TYPE MARA-TYPE,
         WRKST   TYPE MARA-WRKST,
       END OF TY_MARA,

       BEGIN OF TY_MARA_MARD,
         MATNR TYPE MARD-MATNR,
         WERKS TYPE MARD-WERKS,
         LGORT TYPE MARD-LGORT,
         LGPBE TYPE MARD-LGPBE,
         MTART TYPE MARA-MTART,
         MATKL TYPE MARA-MATKL,
       END OF TY_MARA_MARD,

       BEGIN OF TY_MARD,
         MATNR TYPE MARD-MATNR,
         WERKS TYPE MARD-WERKS,
         LGORT TYPE MARD-LGORT,
         LABST TYPE MARD-LABST,
         UMLME TYPE MARD-UMLME,
         INSME TYPE MARD-INSME,
         EINME TYPE MARD-EINME,
         SPEME TYPE MARD-SPEME,
         RETME TYPE MARD-RETME,
         VMLAB TYPE MARD-VMLAB,
         VMUML TYPE MARD-VMUML,
         VMINS TYPE MARD-VMINS,
         VMEIN TYPE MARD-VMEIN,
         VMSPE TYPE MARD-VMSPE,
         VMRET TYPE MARD-VMRET,
       END OF TY_MARD,

       BEGIN OF TY_MAKT,
         MATNR TYPE MAKT-MATNR,
         MAKTX TYPE MAKT-MAKTX,
       END OF TY_MAKT,

       BEGIN OF TY_MBEW,
         MATNR TYPE MBEW-MATNR,
         BWKEY TYPE MBEW-BWKEY,
         LBKUM TYPE MBEW-LBKUM,
         SALK3 TYPE MBEW-SALK3,
         VPRSV TYPE MBEW-VPRSV,
         VERPR TYPE MBEW-VERPR,
         STPRS TYPE MBEW-STPRS,
         BKLAS TYPE MBEW-BKLAS,
       END OF TY_MBEW,

       BEGIN OF TY_EBEW,
         MATNR TYPE EBEW-MATNR,
         BWKEY TYPE EBEW-BWKEY,
         VBELN TYPE EBEW-VBELN,
         POSNR TYPE EBEW-POSNR,
         LBKUM TYPE EBEW-LBKUM,
         SALK3 TYPE EBEW-SALK3,
         VPRSV TYPE EBEW-VPRSV,
         VERPR TYPE EBEW-VERPR,
         STPRS TYPE EBEW-STPRS,
       END OF TY_EBEW,



       BEGIN OF TY_MSKA,
         MATNR TYPE MSKA-MATNR,
         WERKS TYPE MSKA-WERKS,
         LGORT TYPE MSKA-LGORT,
         SOBKZ TYPE MSKA-SOBKZ,
         VBELN TYPE MSKA-VBELN,
         POSNR TYPE MSKA-POSNR,
         KALAB TYPE MSKA-KALAB,
         KAINS TYPE MSKA-KAINS,
         KASPE TYPE MSKA-KASPE,
         KAVLA TYPE MSKA-KAVLA,
         KAVIN TYPE MSKA-KAVIN,
         KAVSP TYPE MSKA-KAVSP,
         KAVEI TYPE MSKA-KAVEI,
       END OF TY_MSKA,

       BEGIN OF TY_MSLB,
         MATNR TYPE MSLB-MATNR,
         WERKS TYPE MSLB-WERKS,
         LBLAB TYPE MSLB-LBLAB,
         LBINS TYPE MSLB-LBINS,
         LBVLA TYPE MSLB-LBVLA,
         LBVEI TYPE MSLB-LBVEI,
         LBUML TYPE MSLB-LBUML,
       END OF TY_MSLB,

       BEGIN OF TY_MSKU,
         MATNR TYPE MSKU-MATNR,
         WERKS TYPE MSKU-WERKS,
         CHARG TYPE MSKU-CHARG,
         SOBKZ TYPE MSKU-SOBKZ,
         KUNNR TYPE MSKU-KUNNR,
         KULAB TYPE MSKU-KULAB,
       END OF TY_MSKU,

       BEGIN OF TY_MSEG,
         MBLNR   TYPE MSEG-MBLNR,
         ZEILE   TYPE MSEG-ZEILE,
         LINE_ID TYPE MSEG-LINE_ID,
         BWART   TYPE MSEG-BWART,
         MATNR   TYPE MSEG-MATNR,
         WERKS   TYPE MSEG-WERKS,
         MENGE   TYPE MSEG-MENGE,
         SMBLN   TYPE MSEG-SMBLN,
       END OF TY_MSEG,




       BEGIN OF TY_FINAL,
         MATNR   TYPE MARD-MATNR,
         MATTXT  TYPE TEXT255,
         WRKST   TYPE MARA-WRKST,
         BRAND   TYPE MARA-BRAND,
         ZSERIES TYPE MARA-ZSERIES,
         ZSIZE   TYPE MARA-ZSIZE,
         MOC     TYPE MARA-MOC,
         TYPE    TYPE MARA-TYPE,
         MTART   TYPE MARA-MTART,
         MATKL   TYPE MARA-MATKL,
         WERKS   TYPE MARD-WERKS,
         LABST   TYPE MARD-LABST,
         UMLME   TYPE MARD-UMLME,
         INSME   TYPE MARD-INSME,
         KULAB   TYPE MSKU-KULAB,
         KALAB   TYPE MSKA-KALAB,
         KAINS   TYPE MSKA-KAINS,
         SPEME   TYPE MARD-SPEME,
         RETME   TYPE MARD-RETME,
         TOTAL   TYPE MSEG-MENGE,
         MENGE   TYPE MSEG-MENGE,
         REF     TYPE CHAR15,
         SALK3   TYPE MBEW-SALK3,
         LGORT   TYPE MARD-LGORT,          "added by pankaj 21.03.2022
       END OF TY_FINAL,

       BEGIN OF TY_STR,
         MATNR    TYPE MARD-MATNR,
         MATTXT   TYPE TEXT255,
         WRKST    TYPE MARA-WRKST,
         BRAND    TYPE MARA-BRAND,
         ZSERIES  TYPE MARA-ZSERIES,
         ZSIZE    TYPE MARA-ZSIZE,
         MOC      TYPE MARA-MOC,
         TYPE     TYPE MARA-TYPE,
         MTART    TYPE MARA-MTART,
         MATKL    TYPE MARA-MATKL,
         WERKS    TYPE MARD-WERKS,
         LABST    TYPE CHAR15,
         UMLME    TYPE CHAR15,
         INSME    TYPE CHAR15,
         KULAB    TYPE CHAR15,
         KALAB    TYPE CHAR15,
         SPEME    TYPE CHAR15,
         RETME    TYPE CHAR15,
         TOTAL    TYPE CHAR15,
         MENGE    TYPE CHAR15,
         REF      TYPE CHAR15,
         SALK3    TYPE CHAR15,
         LGORT    TYPE MARD-LGORT,          "added by pankaj 21.03.2022
         REF_TIME TYPE CHAR15,                        "Refresh Time ADDED BY SHREYA 18-11-22
       END OF TY_STR.


DATA:IT_MARA      TYPE TABLE OF TY_MARA,
     WA_MARA      TYPE          TY_MARA,

     IT_MAKT      TYPE TABLE OF TY_MAKT,
     WA_MAKT      TYPE          TY_MAKT,

     IT_MARD      TYPE TABLE OF TY_MARD,
     WA_MARD      TYPE          TY_MARD,

     IT_MARA_MARD TYPE TABLE OF TY_MARA_MARD,
     WA_MARA_MARD TYPE          TY_MARA_MARD,

     IT_MBEW      TYPE TABLE OF TY_MBEW,
     WA_MBEW      TYPE          TY_MBEW,

     IT_EBEW      TYPE TABLE OF TY_EBEW,
     WA_EBEW      TYPE          TY_EBEW,

     IT_MSKA      TYPE TABLE OF TY_MSKA,
     WA_MSKA      TYPE          TY_MSKA,

     IT_MSKU      TYPE TABLE OF TY_MSKU,
     WA_MSKU      TYPE          TY_MSKU,

     IT_MSLB      TYPE TABLE OF TY_MSLB,
     WA_MSLB      TYPE          TY_MSLB,

     IT_MSEG      TYPE TABLE OF TY_MSEG,
     WA_MSEG      TYPE          TY_MSEG,

     IT_MSEG1     TYPE TABLE OF TY_MSEG,
     WA_MSEG1     TYPE          TY_MSEG,

     IT_MSEG2     TYPE TABLE OF TY_MSEG,
     WA_MSEG2     TYPE          TY_MSEG,

     IT_REV       TYPE TABLE OF TY_MSEG,
     WA_REV       TYPE          TY_MSEG,

     IT_REV1      TYPE TABLE OF TY_MSEG,
     WA_REV1      TYPE          TY_MSEG,

     IT_REV2      TYPE TABLE OF TY_MSEG,
     WA_REV2      TYPE          TY_MSEG,

     IT_FINAL     TYPE TABLE OF TY_FINAL,
     WA_FINAL     TYPE          TY_FINAL,

     LT_FINAL     TYPE TABLE OF TY_STR,
     LS_FINAL     TYPE          TY_STR.



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



SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_MATNR FOR MARD-MATNR,
*                S_LGORT FOR MARD-LGORT,
               " S_LGPBE FOR MARD-LGPBE,
                S_MTART FOR MARA-MTART,
                S_WERKS FOR MARD-WERKS. " NO INTERVALS MODIF ID BU.
*PARAMETERS :
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/USA'."USA'."USA' .
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.

*AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
*LOOP AT SCREEN.
*  IF SCREEN-GROUP1 = 'BU'.
*    SCREEN-INPUT = '0'.
*    MODIFY SCREEN.
* ENDIF.
*ENDLOOP.

INITIALIZATION.
  S_WERKS-SIGN = 'I'.
  S_WERKS-OPTION = 'EQ' .
  S_WERKS-LOW = 'US01'.
  APPEND S_WERKS .
CLEAR:s_werks.
*  S_WERKS-LOW = 'US02'.
*  APPEND S_WERKS.
*CLEAR:s_werks.
*  S_WERKS-LOW = 'US03'.
*  APPEND S_WERKS.
*CLEAR:s_werks.

"Added BY Nilay B. On Date:27.11.2023" " Tr NO. DEVK912688
AT SELECTION-SCREEN ON S_WERKS.
IF S_werks-LOW = 'PL01' or  S_werks-LOW = 'SU01'  .

  MESSAGE 'You are not authorise for plant' TYPE 'E' DISPLAY LIKE 'E'.

ENDIF.
"Ended By NilaY B .



START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM SORT_DATA.
  PERFORM DET_FCAT.
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


  SELECT A~MATNR
           A~WERKS
           A~LGORT
           A~LGPBE
           B~MTART
           B~MATKL
           INTO TABLE IT_MARA_MARD FROM MARD AS A
           INNER JOIN MARA AS B ON B~MATNR = A~MATNR
           WHERE A~MATNR IN S_MATNR
*          AND  A~LGORT IN S_LGORT
         " AND  A~LGPBE IN S_LGPBE
          AND  B~MTART IN S_MTART
            AND  A~WERKS IN s_werks.


    SORT IT_MARA_MARD BY MATNR WERKS.
**  DELETE ADJACENT DUPLICATES FROM it_mara_mard COMPARING matnr werks.
**  DELETE it_mara_mard WHERE werks IN  ( 'PL01' , 'US01' ).

    IF  IT_MARA_MARD IS NOT INITIAL .
      SELECT MATNR
             WERKS
             LGORT
             LABST
             UMLME
             INSME
             EINME
             SPEME
             RETME
             VMLAB
             VMUML
             VMINS
             VMEIN
             VMSPE
             VMRET FROM MARD INTO TABLE IT_MARD
              FOR ALL ENTRIES IN IT_MARA_MARD
             WHERE MATNR = IT_MARA_MARD-MATNR
             AND  WERKS IN s_werks.

*    DELETE it_mard WHERE werks = 'SU01'.

        SELECT MATNR
               WERKS
               LGORT
               SOBKZ
               VBELN
               POSNR
               KALAB
               KAINS
               KASPE
               KAVLA
               KAVIN
               KAVSP
               KAVEI FROM MSKA INTO TABLE IT_MSKA
               FOR ALL ENTRIES IN IT_MARA_MARD
               WHERE MATNR = IT_MARA_MARD-MATNR
*           AND   lgort = it_mara_mard-lgort
               AND   WERKS IN s_werks.
*           AND   SOBKZ = 'E'.

          SELECT MATNR
                 WERKS
                 CHARG
                 SOBKZ
                 KUNNR
                 KULAB FROM MSKU INTO TABLE IT_MSKU
                 FOR ALL ENTRIES IN IT_MARA_MARD
                 WHERE MATNR = IT_MARA_MARD-MATNR
                 AND   WERKS = IT_MARA_MARD-WERKS.

            SELECT MATNR
                   WERKS
                   LBLAB
                   LBINS
                   LBVLA
                   LBVEI
                   LBUML FROM MSLB INTO TABLE IT_MSLB
                   FOR ALL ENTRIES IN IT_MARA_MARD
                   WHERE MATNR = IT_MARA_MARD-MATNR
                   AND   WERKS = IT_MARA_MARD-WERKS.


              SELECT MATNR
                     MAKTX FROM MAKT INTO TABLE IT_MAKT
                     FOR ALL ENTRIES IN IT_MARA_MARD
                     WHERE MATNR = IT_MARA_MARD-MATNR.


                SELECT MATNR
                       ZSERIES
                       ZSIZE
                       BRAND
                       MOC
                       TYPE
                       WRKST    FROM MARA INTO TABLE IT_MARA
                       FOR ALL ENTRIES IN IT_MARA_MARD
                       WHERE MATNR = IT_MARA_MARD-MATNR.

                  SELECT MBLNR
                         ZEILE
                         LINE_ID
                         BWART
                         MATNR
                         WERKS
                         MENGE
                         SMBLN  FROM MSEG INTO TABLE IT_MSEG
                         FOR ALL ENTRIES IN IT_MARA_MARD
                         WHERE MATNR = IT_MARA_MARD-MATNR
                         AND   WERKS = IT_MARA_MARD-WERKS
                         AND   BWART = '103'.

                    SELECT MBLNR
                           ZEILE
                           LINE_ID
                           BWART
                           MATNR
                           WERKS
                           MENGE
                           SMBLN  FROM MSEG INTO TABLE IT_MSEG1
                           FOR ALL ENTRIES IN IT_MARA_MARD
                           WHERE MATNR = IT_MARA_MARD-MATNR
                           AND   WERKS = IT_MARA_MARD-WERKS
                           AND   BWART = '105'.

                      SELECT MBLNR
                             ZEILE
                             LINE_ID
                             BWART
                             MATNR
                             WERKS
                             MENGE
                             SMBLN  FROM MSEG INTO TABLE IT_MSEG2
                             FOR ALL ENTRIES IN IT_MARA_MARD
                             WHERE MATNR = IT_MARA_MARD-MATNR
                             AND   WERKS = IT_MARA_MARD-WERKS
                             AND   BWART = '104'.
                      ENDIF.

                      IF IT_MSEG IS NOT INITIAL.
                        SELECT MBLNR
                               ZEILE
                               LINE_ID
                               BWART
                               MATNR
                               WERKS
                               MENGE
                               SMBLN  FROM MSEG INTO TABLE IT_REV
                               FOR ALL ENTRIES IN IT_MSEG
                               WHERE SMBLN = IT_MSEG-MBLNR
                                AND  MATNR = IT_MSEG-MATNR.
                        ENDIF.

                        IF IT_MSEG1 IS NOT INITIAL.
                          SELECT MBLNR
                                 ZEILE
                                 LINE_ID
                                 BWART
                                 MATNR
                                 WERKS
                                 MENGE
                                 SMBLN  FROM MSEG INTO TABLE IT_REV1
                                 FOR ALL ENTRIES IN IT_MSEG1
                                 WHERE SMBLN = IT_MSEG1-MBLNR
                                 AND  MATNR = IT_MSEG1-MATNR.
                          ENDIF.

                          IF IT_MARA_MARD[] IS NOT INITIAL.
                            SELECT MATNR
                                   BWKEY
                                   LBKUM
                                   SALK3
                                   VPRSV
                                   VERPR
                                   STPRS
                                   BKLAS
                                   FROM MBEW
                                   INTO TABLE IT_MBEW
                                   FOR ALL ENTRIES IN IT_MARA_MARD
                                   WHERE MATNR = IT_MARA_MARD-MATNR
                                   AND   BWKEY = IT_MARA_MARD-WERKS.

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

  LOOP AT IT_MARD INTO WA_MARD.

    WA_FINAL-LGORT = WA_MARD-LGORT.            "added by pankaj 21.03.2022
    WA_FINAL-LABST = WA_MARD-LABST.
    WA_FINAL-UMLME = WA_MARD-UMLME.
    WA_FINAL-INSME = WA_MARD-INSME.
    WA_FINAL-SPEME = WA_MARD-SPEME.
    WA_FINAL-RETME = WA_MARD-RETME.


    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_MARD-MATNR
                                                       WERKS = WA_MARD-WERKS.
*                                                     mtart = wa_mard-mtart.
    IF SY-SUBRC = 0.
      WA_FINAL-MTART = WA_MARA_MARD-MTART.
      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.
      WA_FINAL-WERKS = WA_MARA_MARD-WERKS.
    ENDIF.


    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MARA_MARD-MATNR .
    IF SY-SUBRC = 0.
      WA_FINAL-MATNR       = WA_MARA-MATNR.
      WA_FINAL-ZSERIES     = WA_MARA-ZSERIES .
      WA_FINAL-ZSIZE       = WA_MARA-ZSIZE   .
      WA_FINAL-BRAND       = WA_MARA-BRAND   .
      WA_FINAL-MOC         = WA_MARA-MOC     .
      WA_FINAL-TYPE        = WA_MARA-TYPE    .
      WA_FINAL-WRKST       = WA_MARA-WRKST   .
    ENDIF.

    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MARA_MARD-MATNR BWKEY = WA_MARA_MARD-WERKS.
    IF SY-SUBRC = 0.
      WA_FINAL-SALK3 = WA_MBEW-SALK3.
    ENDIF.

    LOOP AT IT_MSKA INTO WA_MSKA WHERE MATNR = WA_MARA_MARD-MATNR AND  WERKS = WA_MARA_MARD-WERKS AND LGORT = WA_MARA_MARD-LGORT.
      IF SY-SUBRC = 0.
        WA_FINAL-KALAB =  WA_FINAL-KALAB + WA_MSKA-KALAB.
*      wa_final-KAINS =  wa_final-KAINS + wa_mska-KAINS.
      ENDIF.
    ENDLOOP.
*     READ TABLE it_mska INTO wa_mska WITH KEY matnr = wa_mara_mard-matnr   werks = wa_mara_mard-werks  lgort = wa_mard-LGORT.
*     IF SY-SUBRC = 0.
*      wa_final-kalab =  wa_mska-kalab.
*     ENDIF.
    LOOP AT IT_MSKU INTO WA_MSKU WHERE MATNR = WA_MARA_MARD-MATNR AND  WERKS = WA_MARA_MARD-WERKS.
      WA_FINAL-KULAB = WA_FINAL-KULAB + WA_MSKU-KULAB.
    ENDLOOP.

    LOOP AT IT_MSEG INTO WA_MSEG WHERE MATNR = WA_MARA-MATNR AND  WERKS = WA_MARA_MARD-WERKS..
      READ TABLE IT_REV INTO WA_REV WITH KEY SMBLN = WA_MSEG-MBLNR MATNR = WA_MSEG-MATNR.
      IF SY-SUBRC = 4.
        WA_FINAL-MENGE = WA_FINAL-MENGE  + WA_MSEG-MENGE.
      ENDIF.
      WA_FINAL-WERKS = WA_MSEG-WERKS.

    ENDLOOP.

    LOOP AT IT_MSEG1 INTO WA_MSEG1 WHERE MATNR = WA_MARA-MATNR AND  WERKS = WA_MARA_MARD-WERKS.
* wa_final-werks = wa_mseg-werks.
      READ TABLE IT_REV1 INTO WA_REV1 WITH KEY SMBLN = WA_MSEG1-MBLNR MATNR = WA_MSEG1-MATNR.
      IF SY-SUBRC = 4.
        WA_FINAL-MENGE = WA_FINAL-MENGE  - WA_MSEG1-MENGE.
      ENDIF.
    ENDLOOP.

    CLEAR: LV_LINES, LS_MATTXT.
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

    REPLACE ALL OCCURRENCES OF '<(>' IN WA_FINAL-MATTXT WITH SPACE.
    REPLACE ALL OCCURRENCES OF '<)>' IN WA_FINAL-MATTXT WITH SPACE.

    WA_FINAL-TOTAL = WA_FINAL-LABST + WA_FINAL-UMLME + WA_FINAL-INSME + WA_FINAL-KULAB
                     + WA_FINAL-KALAB + WA_FINAL-SPEME + WA_FINAL-RETME.

    WA_FINAL-REF = SY-DATUM.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_FINAL-REF
      IMPORTING
        OUTPUT = WA_FINAL-REF.

    CONCATENATE WA_FINAL-REF+0(2) WA_FINAL-REF+2(3) WA_FINAL-REF+5(4)
                    INTO WA_FINAL-REF SEPARATED BY '-'.


    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
    CLEAR:WA_MARA_MARD.
  ENDLOOP.
  CLEAR:WA_MARD,WA_MARA,WA_MSKA,WA_MBEW.


  IF  P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      LS_FINAL-MATNR    = WA_FINAL-MATNR   .
      LS_FINAL-MATTXT   = WA_FINAL-MATTXT  .
      LS_FINAL-WRKST    = WA_FINAL-WRKST   .
      LS_FINAL-BRAND    = WA_FINAL-BRAND   .
      LS_FINAL-ZSERIES  = WA_FINAL-ZSERIES .
      LS_FINAL-ZSIZE    = WA_FINAL-ZSIZE   .
      LS_FINAL-MOC      = WA_FINAL-MOC     .
      LS_FINAL-TYPE     = WA_FINAL-TYPE    .
      LS_FINAL-MTART    = WA_FINAL-MTART   .
      LS_FINAL-MATKL    = WA_FINAL-MATKL   .
      LS_FINAL-WERKS    = WA_FINAL-WERKS   .
      LS_FINAL-LABST    = WA_FINAL-LABST   .
      LS_FINAL-UMLME    = WA_FINAL-UMLME   .
      LS_FINAL-INSME    = WA_FINAL-INSME   .
      LS_FINAL-KULAB    = WA_FINAL-KULAB   .
      LS_FINAL-KALAB    = WA_FINAL-KALAB   .
      LS_FINAL-SPEME    = WA_FINAL-SPEME   .
      LS_FINAL-RETME    = WA_FINAL-RETME   .
      LS_FINAL-TOTAL    = WA_FINAL-TOTAL   .
      LS_FINAL-MENGE    = WA_FINAL-MENGE   .
      LS_FINAL-REF      = WA_FINAL-REF     .
      LS_FINAL-SALK3    = WA_FINAL-SALK3     .
      LS_FINAL-LGORT    = WA_FINAL-LGORT     .      "added by pankaj 21.03.2022
*       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          input  = sy-datum
*        IMPORTING
*          output = ls_FINAL-ref_dat.
*      CONCATENATE ls_FINAL-ref_dat+0(2) ls_FINAL-ref_dat+2(3) ls_FINAL-ref_dat+5(4)
*     INTO ls_FINAL-ref_dat SEPARATED BY '-'.

      LS_FINAL-REF_TIME = SY-UZEIT.
      CONCATENATE LS_FINAL-REF_TIME+0(2) ':' LS_FINAL-REF_TIME+2(2)  INTO LS_FINAL-REF_TIME.


      APPEND LS_FINAL TO LT_FINAL.
      CLEAR LS_FINAL.
    ENDLOOP.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DET_FCAT .
  PERFORM FCAT USING :
                         '1'  'MATNR'         'IT_FINAL'  'Material.No.'                                     '18' ,
                         '2'  'MATTXT'        'IT_FINAL'  'Material Desc'                                    '18',
                         '3'  'WRKST'         'IT_FINAL'  'USA Code'                                         '18' ,
                         '4'  'BRAND  '       'IT_FINAL'  'Brand'                                            '10',
                         '5'  'ZSERIES'       'IT_FINAL'  'Series'                                           '10',
                         '6'  'ZSIZE  '       'IT_FINAL'  'Size'                                             '10',
                         '7'  'MOC    '       'IT_FINAL'  'MOC'                                              '10',
                         '8'  'TYPE   '       'IT_FINAL'  'Type'                                             '10',
                         '9'  'MTART'         'IT_FINAL'  'Material Type'                                    '18',
                        '10'  'MATKL'         'IT_FINAL'  'Material Group'                                   '18',
                        '11'  'WERKS'         'IT_FINAL'  'Plant'                                            '10',
                        '12'  'LABST'         'IT_FINAL'  'Unrestricted-Use Stock'                           '18',
                        '13'  'SALK3'         'IT_FINAL'  'Unrestricted-Use Stock Value'                     '20',
                        '14'  'UMLME'         'IT_FINAL'  'Stock in transfer '                               '18',
                        '15'  'INSME'         'IT_FINAL'  'Stock in Quality Inspection'                      '18',
                        '16'  'KULAB'         'IT_FINAL'  'Consignment Stock'                                '18',
                        '17'  'KALAB'         'IT_FINAL'  'SO Allocated Stock'                               '18',
                        '18'  'SPEME'         'IT_FINAL'  'Blocked Stock'                                   '18',
                        '19'  'RETME'         'IT_FINAL'  'Blocked Stock Returns'                           '18',
                        '20'  'TOTAL'         'IT_FINAL'  'Total Stock '                                  '18',
                        '21'  'MENGE'         'IT_FINAL'  'In Transit Block'                                      '15',
                        '22'  'LGORT'         'IT_FINAL'  'Storage Location'                                      '15'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1435   text
*      -->P_1436   text
*      -->P_1437   text
*      -->P_1438   text
*      -->P_1439   text
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
*  wa_fcat-key       = .
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
*      I_CALLBACK_USER_COMMAND = 'USER_CMD'
      I_CALLBACK_TOP_OF_PAGE  = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
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
  LS_HEADER-INFO = 'USA MB52 Report New'.
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
    EXPORTING
*     I_FIELD_SEPERATOR    =
*     I_LINE_HEADER        =
      I_FILENAME           = 'DAT'
*     I_APPL_KEEP          = ' '
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


  LV_FILE = 'ZUS_MB52.TXT'.


  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUS_MB52 REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_923 TYPE string.
DATA lv_crlf_923 TYPE string.
lv_crlf_923 = cl_abap_char_utilities=>cr_lf.
lv_string_923 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_923 lv_crlf_923 wa_csv INTO lv_string_923.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_923 TO lv_fullfile.
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


  LV_FILE = 'ZUS_MB52.TXT'.


  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUS_MB52 REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_960 TYPE string.
DATA lv_crlf_960 TYPE string.
lv_crlf_960 = cl_abap_char_utilities=>cr_lf.
lv_string_960 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_960 lv_crlf_960 wa_csv INTO lv_string_960.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_960 TO lv_fullfile.
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
  CONCATENATE 'Material.No.'
              'Material Desc'
              'USA Code'
              'Brand'
              'Series'
              'Size'
              'MOC'
              'Type'
              'Material Type'
              'Material Group'
              'Plant'
              'Unrestricted-Use Stock'
              'Stock in transfer '
              'Stock in Quality Inspection'
              'Consignment Stock'
              'SO Allocated Stock'
              'Blocked Stock'
              'Blocked Stock Returns'
              'Total Stock '
              'In Transit Block'
              'Refresh File Date'
              'Unrestricted-Use Stock Value'
              'Storage Location'
              'Ref Time'
                INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
