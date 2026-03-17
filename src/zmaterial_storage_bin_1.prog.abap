*&---------------------------------------------------------------------*
*& Report ZMATERIAL_STORAGE_BIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMATERIAL_STORAGE_BIN_1.

TABLES:MARD,MARA.

TYPES: BEGIN OF TY_MARA,
         MATNR TYPE MARA-MATNR,
         MTART TYPE MARA-MTART,
         MATKL TYPE MARA-MATKL,
       END OF TY_MARA,

       BEGIN OF TY_MARA_MARD,
         MATNR TYPE MARD-MATNR,
         WERKS TYPE MARD-WERKS,
         LGORT TYPE MARD-LGORT,
         LGPBE TYPE MARD-LGPBE,
         MTART TYPE MARA-MTART,
         MATKL TYPE MARA-MATKL,
         zitem_class type mara-ZITEM_CLASS,                                 "added by aakashk 07.10.2024
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
         CHARG TYPE MSLB-CHARG,
         SOBKZ TYPE MSLB-SOBKZ,
         LIFNR TYPE MSLB-LIFNR,
         LBLAB TYPE MSLB-LBLAB,
         LBINS TYPE MSLB-LBINS,
         LBVLA TYPE MSLB-LBVLA,
         LBVEI TYPE MSLB-LBVEI,
         LBUML TYPE MSLB-LBUML,
       END OF TY_MSLB,



       BEGIN OF TY_FINAL,
         MATNR       TYPE MARD-MATNR,
         WERKS       TYPE MARD-WERKS,
         LGORT       TYPE MARD-LGORT,
         LABST       TYPE MARD-LABST,
         UMLME       TYPE MARD-UMLME,
         INSME       TYPE MARD-INSME,
         EINME       TYPE MARD-EINME,
         SPEME       TYPE MARD-SPEME,
         RETME       TYPE MARD-RETME,
         VMLAB       TYPE MARD-VMLAB,
         VMUML       TYPE MARD-VMUML,
         VMINS       TYPE MARD-VMINS,
         VMEIN       TYPE MARD-VMEIN,
         VMSPE       TYPE MARD-VMSPE,
         VMRET       TYPE MARD-VMRET,
         LGPBE       TYPE MARD-LGPBE,
         MTART       TYPE MARA-MTART,
         MATKL       TYPE MARA-MATKL,
         ZITEM_CLASS TYPE MARA-ZITEM_CLASS,    "ATC
         MATTXT      TYPE TEXT100,
         LBKUM       TYPE MBEW-LBKUM,
         SALK3       TYPE MBEW-SALK3,
         PRICE       TYPE MBEW-STPRS, "p DECIMALS 2,"mbew-salk3,    "string,"
         UN_VAL      TYPE PRCD_ELEMENTS-KWERT,
         RATE        TYPE F,   "p LENGTH 15 DECIMALS 14, " mbew-salk3,  " string,
         VBELN       TYPE MSKA-VBELN,
         POSNR       TYPE MSKA-POSNR,
         KALAB       TYPE MSKA-KALAB,
         LBLAB       TYPE MSLB-LBLAB,
         STOCK_NO    TYPE CHAR100,
         QL_VAL      TYPE MBEW-SALK3,
         LIFNR       TYPE MSLB-LIFNR,
         BLOCK_STOCK TYPE MBEW-SALK3, "added by jyoti on 07.04.2025
       END OF TY_FINAL,

       BEGIN OF FINAL,
         MATNR       TYPE MARD-MATNR,
         MTART       TYPE MARA-MTART,
         MATKL       TYPE MARA-MATKL,
         WERKS       TYPE MARD-WERKS,
         LGORT       TYPE MARD-LGORT,
         LABST       TYPE CHAR15,
         UMLME       TYPE CHAR15,
         INSME       TYPE CHAR15,
         EINME       TYPE CHAR15,
         SPEME       TYPE CHAR15,
         RETME       TYPE CHAR15,
         VMLAB       TYPE CHAR15,
         VMUML       TYPE CHAR15,
         VMINS       TYPE CHAR15,
         VMEIN       TYPE CHAR15,
         VMSPE       TYPE CHAR15,
         VMRET       TYPE CHAR15,
         LGPBE       TYPE CHAR15,
         LBKUM       TYPE CHAR15,
         SALK3       TYPE CHAR15,
         PRICE       TYPE CHAR15,
         UN_VAL      TYPE CHAR15,
         STOCK_NO    TYPE CHAR100,
         VBELN       TYPE CHAR10,
         REF         TYPE CHAR15,
         QL_VAL      TYPE CHAR15,
         LIFNR       TYPE MSLB-LIFNR,
         ZITEM_CLASS TYPE MARA-ZITEM_CLASS,
         TIME        TYPE CHAR10,
         BLOCK_STOCK TYPE STRING, "ADDED BY JYOTI ON 07.04.2025
       END OF FINAL.



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

     IT_MSLB      TYPE TABLE OF TY_MSLB,
     WA_MSLB      TYPE          TY_MSLB,

     IT_FINAL     TYPE TABLE OF TY_FINAL,
     WA_FINAL     TYPE          TY_FINAL,

     LT_FINAL     TYPE TABLE OF FINAL,
     LS_FINAL     TYPE          FINAL.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.

DATA: LV_NAME   TYPE THEAD-TDNAME,
      LV_LINES  TYPE STANDARD TABLE OF TLINE,
      WA_LINES  LIKE TLINE,
      LS_ITMTXT TYPE TLINE,
      LS_MATTXT TYPE TLINE.



SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_MATNR FOR MARD-MATNR,
                  S_LGORT FOR MARD-LGORT,
                  S_LGPBE FOR MARD-LGPBE,
                  S_MTART FOR MARA-MTART.
  PARAMETERS :    P_WERKS TYPE MARD-WERKS OBLIGATORY.
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT  '/Delval/India'.    "'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.

START-OF-SELECTION.
  PERFORM GET_DATA.
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
          AND  A~LGORT IN S_LGORT
          AND  A~LGPBE IN S_LGPBE
          AND  A~WERKS = P_WERKS
          AND  B~MTART IN S_MTART.

***********************************************************************************************************************
  IF P_WERKS = 'PL01'.                                                         "added by aakashk 08.10.2024
    READ TABLE IT_MARA_MARD WITH KEY WERKS = 'PL01' TRANSPORTING NO FIELDS.
    IF SY-SUBRC <> 0.

      MESSAGE E001(00) WITH 'Material' S_MATNR 'does not belong to plant' P_WERKS.
      RETURN.  " Stop further execution
    ENDIF.
  ENDIF.
**************************************************************************************************************************


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
           AND   LGORT = IT_MARA_MARD-LGORT
           AND   WERKS = IT_MARA_MARD-WERKS.
*           AND labst <> 0."ADDED BY JYOTI ON 06.08.2024
  ENDIF.
  DELETE IT_MARD WHERE LABST EQ 0 AND INSME EQ 0 AND  EINME EQ 0 AND SPEME EQ 0
      AND RETME EQ 0.
  IF S_LGORT IS NOT INITIAL.
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
           WHERE MATNR IN S_MATNR
          AND  LGORT IN S_LGORT
          AND  WERKS = P_WERKS.

  ELSE.
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
           AND   WERKS = IT_MARA_MARD-WERKS
           AND LGORT IN S_LGORT.
*           and kalab <> 0 .
    "ADDED BY JYOTI ON 06.08.2024
*           AND   SOBKZ = 'E'.
  ENDIF.
**************Add by supriya on 06.08.2024
  DELETE IT_MSKA WHERE  KALAB EQ 0 AND KAINS EQ 0 AND  KASPE EQ 0 AND KAVLA EQ 0
  AND KAVIN EQ 0 AND KAVSP EQ 0 AND KAVEI EQ 0.

*     labst EQ 0 AND insme EQ 0 AND  einme EQ 0 AND speme EQ 0
*         AND retme EQ 0.
  IF  IT_MARA_MARD IS NOT INITIAL .
    SELECT MATNR
           WERKS
           CHARG
           SOBKZ
           LIFNR
           LBLAB
           LBINS
           LBVLA
           LBVEI
           LBUML FROM MSLB INTO TABLE IT_MSLB
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR
           AND   WERKS = IT_MARA_MARD-WERKS.
*            and lgort IN s_lgort.
*            and lblab <> 0."ADDED BY JYOTI ON 06.08.2024

    DELETE IT_MSLB WHERE LBLAB EQ 0 AND LBINS EQ 0 AND LBVLA EQ 0 AND LBVEI EQ 0
        AND LBUML EQ 0 .

    SELECT MATNR
           MAKTX FROM MAKT INTO TABLE IT_MAKT
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR.

    SELECT MATNR
           BWKEY
           LBKUM
           SALK3
           VPRSV
           VERPR
           STPRS FROM MBEW INTO TABLE IT_MBEW
           FOR ALL ENTRIES IN IT_MARA_MARD
           WHERE MATNR = IT_MARA_MARD-MATNR
           AND   BWKEY = IT_MARA_MARD-WERKS.

*   SELECT matnr
*           bwkey
*           lbkum
*           salk3
*           vprsv
*           verpr
*           stprs FROM ebew INTO TABLE it_ebew
*           FOR ALL ENTRIES IN it_mara_mard
*           WHERE matnr = it_mara_mard-matnr
*           AND   bwkey = it_mara_mard-werks.

  ENDIF.

  IF IT_MSKA IS NOT INITIAL.
    SELECT MATNR
           BWKEY
           VBELN
           POSNR
           LBKUM
           SALK3
           VPRSV
           VERPR
           STPRS FROM EBEW INTO TABLE IT_EBEW
           FOR ALL ENTRIES IN IT_MSKA
           WHERE MATNR = IT_MSKA-MATNR
           AND   BWKEY = IT_MSKA-WERKS
           AND   VBELN = IT_MSKA-VBELN
           AND   POSNR = IT_MSKA-POSNR.

  ENDIF.

*LOOP AT IT_MARA_MARD INTO DATA(WA).
*READ TABLE IT_MARD INTO DATA(WA_1) WITH KEY MATNR = WA-MATNR
*                                           WERKS = WA-WERKS
*                                            LGORT = WA-LGORT.
**  IF SY-SUBRC IS NOT INITIAL.
*    IF WA-LGORT NE WA_1-LGORT.
*  DELETE IT_MARA_MARD WHERE MATNR EQ WA_1-MATNR AND WERKS EQ WA_1-WERKS AND LGORT EQ WA-LGORT.
*   ENDIF.
**  ENDIF.
*ENDLOOP.


**************************************Logic for Store Stock********************************
  LOOP AT IT_MARD INTO WA_MARD ."ADDED BY JYOTI ON 06.08.2024

*  LOOP AT it_mara_mard INTO wa_mara_mard."COMMENTED BY JYPTI ON 06.08.2024
    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_MARD-MATNR LGORT = WA_MARD-LGORT WERKS = WA_MARD-WERKS.
    IF  SY-SUBRC = 0.
      WA_FINAL-MATNR = WA_MARA_MARD-MATNR.
      WA_FINAL-WERKS = WA_MARA_MARD-WERKS.
      WA_FINAL-LGORT = WA_MARA_MARD-LGORT.
      WA_FINAL-LGPBE = WA_MARA_MARD-LGPBE.
      WA_FINAL-MTART = WA_MARA_MARD-MTART.
      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.

      WA_FINAL-ZITEM_CLASS = WA_MARA_MARD-ZITEM_CLASS.       "added by aakashk 07.10.2024        ""added by aakashk 07.10.2024
    ENDIF.

*    READ TABLE IT_MSKA INTO wa_mska WITH KEY matnr = wa_mara_mard-matnr werks = wa_mara_mard-werks lgort = wa_mara_mard-lgort.
*    IF sy-subrc = 0.
*      wa_final-vbeln = wa_mska-vbeln.
*      wa_final-posnr = wa_mska-posnr.
*      wa_final-kalab = wa_mska-kalab.
*
*    ENDIF.

*    READ TABLE it_mslb INTO wa_mslb WITH KEY matnr = wa_mara_mard-matnr werks = wa_mara_mard-werks.
*    IF sy-subrc = 0.
*      wa_final-lblab = wa_mslb-lblab.
*
*    ENDIF.

    READ TABLE IT_MAKT INTO WA_MAKT WITH KEY MATNR = WA_MARA_MARD-MATNR.
    IF  SY-SUBRC = 0.
*      wa_final-maktx = wa_makt-maktx.

    ENDIF.

    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MARA_MARD-MATNR BWKEY = WA_MARA_MARD-WERKS..
    IF  SY-SUBRC = 0.
*      wa_final-lbkum = wa_mbew-lbkum.
      WA_FINAL-SALK3 = WA_MBEW-SALK3.                      "commented by Ganga 17.10.2018

      IF WA_MBEW-VPRSV = 'S'.
        WA_FINAL-PRICE = WA_MBEW-STPRS.
      ELSEIF WA_MBEW-VPRSV = 'V'..
        WA_FINAL-PRICE = WA_MBEW-VERPR.

      ENDIF.

    ENDIF.

*    READ TABLE it_mard INTO wa_mard WITH KEY matnr = wa_mara_mard-matnr lgort = wa_mara_mard-lgort werks = wa_mara_mard-werks.
*    IF sy-subrc = 0.
    WA_FINAL-LABST = WA_MARD-LABST.
    WA_FINAL-UMLME = WA_MARD-UMLME.
    WA_FINAL-INSME = WA_MARD-INSME.
    WA_FINAL-EINME = WA_MARD-EINME.
    WA_FINAL-SPEME = WA_MARD-SPEME.
    WA_FINAL-RETME = WA_MARD-RETME.
    WA_FINAL-VMLAB = WA_MARD-VMLAB.
    WA_FINAL-VMUML = WA_MARD-VMUML.
    WA_FINAL-VMINS = WA_MARD-VMINS.
    WA_FINAL-VMEIN = WA_MARD-VMEIN.
    WA_FINAL-VMSPE = WA_MARD-VMSPE.
    WA_FINAL-VMRET = WA_MARD-VMRET.


*    ENDIF.
**********************************added by jyoti on 07.08.2024**************************
    WA_FINAL-LBKUM = WA_FINAL-LABST + WA_FINAL-UMLME + WA_FINAL-INSME + WA_FINAL-SPEME
                      +  WA_FINAL-RETME + WA_FINAL-VMLAB + WA_FINAL-VMUML + WA_FINAL-VMINS
                      + WA_FINAL-VMEIN + WA_FINAL-VMSPE + WA_FINAL-VMRET.


* *****************************************************************************
*BREAK PRIMUS..
    IF WA_FINAL-LBKUM NE 0.
      WA_FINAL-RATE  = WA_FINAL-SALK3 / WA_FINAL-LBKUM.
*      wa_final-un_val = wa_final-labst * wa_final-rate.
      WA_FINAL-UN_VAL = WA_FINAL-PRICE * WA_FINAL-LABST.
*      wa_final-salk3  =  wa_final-labst * wa_final-rate.
      WA_FINAL-SALK3  =  WA_FINAL-LBKUM * WA_FINAL-PRICE.
    ELSE.
      WA_FINAL-RATE  = WA_FINAL-PRICE.      "wa_final-salk3 / wa_final-lbkum.
      WA_FINAL-UN_VAL = WA_FINAL-PRICE * WA_FINAL-LABST.
*      wa_final-un_val = wa_final-labst * wa_final-rate.
*      wa_final-salk3  =  wa_final-labst * wa_final-rate.
      WA_FINAL-SALK3  =  WA_FINAL-LBKUM * WA_FINAL-PRICE.
    ENDIF.

    IF WA_FINAL-INSME NE 0.
      WA_FINAL-QL_VAL = WA_FINAL-INSME * WA_FINAL-PRICE."rate.
    ENDIF.

    IF WA_FINAL-SPEME NE 0.
      WA_FINAL-BLOCK_STOCK = WA_FINAL-SPEME * WA_FINAL-PRICE."rate.
    ENDIF.

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
*
*      IF wa_final-vbeln IS NOT INITIAL.
*        CONCATENATE wa_final-vbeln wa_final-posnr  INTO wa_final-stock_no SEPARATED BY '/'.
*      ENDIF.






    APPEND WA_FINAL TO IT_FINAL.

    CLEAR: WA_FINAL,LS_FINAL.
  ENDLOOP.
***************************************************Logic for Sales Order Stock*****************
  LOOP AT IT_MSKA INTO WA_MSKA.
    WA_FINAL-MATNR = WA_MSKA-MATNR.
    WA_FINAL-WERKS = WA_MSKA-WERKS.
    WA_FINAL-LGORT = WA_MSKA-LGORT.
    WA_FINAL-VBELN = WA_MSKA-VBELN.
    WA_FINAL-POSNR = WA_MSKA-POSNR.
    WA_FINAL-LABST = WA_MSKA-KALAB.
    WA_FINAL-INSME = WA_MSKA-KAINS.
    WA_FINAL-SPEME = WA_MSKA-KASPE.
    WA_FINAL-VMLAB = WA_MSKA-KAVLA.
    WA_FINAL-VMINS = WA_MSKA-KAVIN.
    WA_FINAL-VMEIN = WA_MSKA-KAVEI.
    WA_FINAL-VMSPE = WA_MSKA-KAVSP.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        INPUT  = WA_FINAL-VBELN
      IMPORTING
        OUTPUT = WA_FINAL-VBELN.


    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        INPUT  = WA_FINAL-POSNR
      IMPORTING
        OUTPUT = WA_FINAL-POSNR.


    IF WA_FINAL-VBELN IS NOT INITIAL.
      CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR  INTO WA_FINAL-STOCK_NO SEPARATED BY '/'.
    ENDIF.
    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_MSKA-MATNR WERKS = WA_MSKA-WERKS LGORT = WA_MSKA-LGORT.
    IF SY-SUBRC = 0.
      WA_FINAL-MTART = WA_MARA_MARD-MTART.
      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.
      WA_FINAL-ZITEM_CLASS = WA_MARA_MARD-ZITEM_CLASS.                                                         "added by aakashk 07.10.2024
      WA_FINAL-LGPBE = WA_MARA_MARD-LGPBE.
    ENDIF.
    SELECT SINGLE MTART INTO WA_FINAL-MTART FROM MARA WHERE MATNR = WA_MSKA-MATNR.
    READ TABLE IT_EBEW INTO WA_EBEW WITH KEY MATNR = WA_MSKA-MATNR BWKEY = WA_MSKA-WERKS VBELN = WA_MSKA-VBELN POSNR = WA_MSKA-POSNR.
    IF  SY-SUBRC = 0.
*      wa_final-lbkum = wa_ebew-lbkum.
      WA_FINAL-SALK3 = WA_EBEW-SALK3.

      IF WA_EBEW-VPRSV = 'S'.
        WA_FINAL-PRICE = WA_EBEW-STPRS.
      ELSEIF WA_EBEW-VPRSV = 'V'..
        WA_FINAL-PRICE = WA_EBEW-VERPR.

      ENDIF.

    ENDIF.
    WA_FINAL-LBKUM = WA_FINAL-LABST + WA_FINAL-UMLME + WA_FINAL-INSME + WA_FINAL-SPEME
                     +  WA_FINAL-RETME + WA_FINAL-VMLAB + WA_FINAL-VMUML + WA_FINAL-VMINS
                     + WA_FINAL-VMEIN + WA_FINAL-VMSPE + WA_FINAL-VMRET.
    IF WA_FINAL-LBKUM NE 0.
      WA_FINAL-RATE  = WA_FINAL-SALK3 / WA_FINAL-LBKUM.
      WA_FINAL-SALK3  =  WA_FINAL-LBKUM * WA_FINAL-PRICE."rate .
      WA_FINAL-UN_VAL = WA_FINAL-PRICE * WA_FINAL-LABST.
    ELSE.
      WA_FINAL-RATE  = WA_FINAL-PRICE.      "wa_final-salk3 / wa_final-lbkum.
      WA_FINAL-SALK3  = WA_FINAL-LBKUM * WA_FINAL-PRICE."rate.
      WA_FINAL-UN_VAL = WA_FINAL-PRICE * WA_FINAL-LABST.
    ENDIF.

    IF WA_FINAL-INSME NE 0.
      WA_FINAL-QL_VAL = WA_FINAL-INSME * WA_FINAL-PRICE."rate.
    ENDIF.

    IF WA_FINAL-SPEME NE 0.
      WA_FINAL-BLOCK_STOCK = WA_FINAL-SPEME * WA_FINAL-PRICE."rate.
    ENDIF.


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


    APPEND WA_FINAL TO IT_FINAL.
    CLEAR: WA_FINAL,LS_FINAL.
  ENDLOOP.


*****************************************Logic for Stock At Vendor*************************************
  LOOP AT IT_MSLB INTO WA_MSLB.

    WA_FINAL-MATNR = WA_MSLB-MATNR.
    WA_FINAL-WERKS = WA_MSLB-WERKS.
    WA_FINAL-LABST = WA_MSLB-LBLAB.
    WA_FINAL-UMLME = WA_MSLB-LBUML.
    WA_FINAL-INSME = WA_MSLB-LBINS.
    WA_FINAL-VMLAB = WA_MSLB-LBVLA.
    WA_FINAL-VMEIN = WA_MSLB-LBVEI.
    WA_FINAL-LIFNR = WA_MSLB-LIFNR.

    READ TABLE IT_MARA_MARD INTO WA_MARA_MARD WITH KEY MATNR = WA_MSLB-MATNR WERKS = WA_MSLB-WERKS .
    IF SY-SUBRC = 0.
      WA_FINAL-MTART = WA_MARA_MARD-MTART..
      WA_FINAL-MATKL = WA_MARA_MARD-MATKL.
      WA_FINAL-ZITEM_CLASS = WA_MARA_MARD-ZITEM_CLASS.                                            "added by aakashk 07.10.2024
      WA_FINAL-LGPBE = WA_MARA_MARD-LGPBE.
    ENDIF.


    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MSLB-MATNR BWKEY = WA_MSLB-WERKS.
    IF  SY-SUBRC = 0.
*      wa_final-lbkum = wa_mbew-lbkum.
      WA_FINAL-SALK3 = WA_MBEW-SALK3.

      IF WA_MBEW-VPRSV = 'S'.
        WA_FINAL-PRICE = WA_MBEW-STPRS.
      ELSEIF WA_MBEW-VPRSV = 'V'..
        WA_FINAL-PRICE = WA_MBEW-VERPR.

      ENDIF.

    ENDIF.
    WA_FINAL-LBKUM = WA_FINAL-LABST + WA_FINAL-UMLME + WA_FINAL-INSME + WA_FINAL-SPEME
                          +  WA_FINAL-RETME + WA_FINAL-VMLAB + WA_FINAL-VMUML + WA_FINAL-VMINS
                          + WA_FINAL-VMEIN + WA_FINAL-VMSPE + WA_FINAL-VMRET.

    IF WA_FINAL-LBKUM NE 0.
      WA_FINAL-RATE  = WA_FINAL-SALK3 / WA_FINAL-LBKUM.
      WA_FINAL-SALK3  = WA_FINAL-LBKUM * WA_FINAL-PRICE."rate.
      WA_FINAL-UN_VAL = WA_FINAL-PRICE * WA_FINAL-LABST.
    ELSE.
      WA_FINAL-RATE  = WA_FINAL-PRICE.      "wa_final-salk3 / wa_final-lbkum.
      WA_FINAL-SALK3  =  WA_FINAL-LBKUM * WA_FINAL-PRICE."rate.
      WA_FINAL-UN_VAL = WA_FINAL-PRICE * WA_FINAL-LABST.
    ENDIF.


    IF WA_FINAL-INSME NE 0.
      WA_FINAL-QL_VAL = WA_FINAL-INSME * WA_FINAL-PRICE."rate.
    ENDIF.


    IF WA_FINAL-SPEME NE 0.
      WA_FINAL-BLOCK_STOCK = WA_FINAL-SPEME * WA_FINAL-PRICE."rate.
    ENDIF.


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



    APPEND WA_FINAL TO IT_FINAL.
    CLEAR: WA_FINAL,LS_FINAL.
  ENDLOOP.
  IF S_LGORT IS NOT INITIAL.
    DELETE IT_FINAL WHERE LGORT EQ ' '.
  ENDIF.

*********************************Downlaod File****************************

  LOOP AT IT_FINAL INTO WA_FINAL.


    LS_FINAL-MATNR = WA_FINAL-MATNR.
    LS_FINAL-WERKS = WA_FINAL-WERKS.
    LS_FINAL-LGORT = WA_FINAL-LGORT.
    LS_FINAL-LGPBE = WA_FINAL-LGPBE.
    LS_FINAL-MTART = WA_FINAL-MTART.
    LS_FINAL-MATKL = WA_FINAL-MATKL.
    LS_FINAL-LBKUM = WA_FINAL-LBKUM.
    LS_FINAL-SALK3 = WA_FINAL-SALK3.
    LS_FINAL-PRICE = WA_FINAL-PRICE.
    LS_FINAL-LABST = WA_FINAL-LABST.
    LS_FINAL-UMLME = WA_FINAL-UMLME.
    LS_FINAL-INSME = WA_FINAL-INSME.
    LS_FINAL-EINME = WA_FINAL-EINME.
    LS_FINAL-SPEME = WA_FINAL-SPEME.
    LS_FINAL-RETME = WA_FINAL-RETME.
    LS_FINAL-VMLAB = WA_FINAL-VMLAB.
    LS_FINAL-VMUML = WA_FINAL-VMUML.
    LS_FINAL-VMINS = WA_FINAL-VMINS.
    LS_FINAL-VMEIN = WA_FINAL-VMEIN.
    LS_FINAL-VMSPE = WA_FINAL-VMSPE.
    LS_FINAL-VMRET = WA_FINAL-VMRET.
    LS_FINAL-UN_VAL = WA_FINAL-UN_VAL.
    LS_FINAL-STOCK_NO = WA_FINAL-STOCK_NO.
    LS_FINAL-VBELN = WA_FINAL-VBELN.
    LS_FINAL-REF = SY-DATUM.
    LS_FINAL-QL_VAL = WA_FINAL-QL_VAL.
    LS_FINAL-LIFNR = WA_FINAL-LIFNR.
    LS_FINAL-ZITEM_CLASS = WA_FINAL-ZITEM_CLASS.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-REF
      IMPORTING
        OUTPUT = LS_FINAL-REF.

    CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
                    INTO LS_FINAL-REF SEPARATED BY '-'.

    CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO LS_FINAL-TIME SEPARATED BY ':'.

ls_final-block_stock = wa_final-block_stock. "ADDED BY JYOTI ON 07.04.2025
    APPEND LS_FINAL TO LT_FINAL.
    CLEAR LS_FINAL.
  ENDLOOP.
  SORT IT_FINAL BY MATNR.
  SORT LT_FINAL BY MATNR.
*  BREAK primus.
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
  PERFORM FCAT USING : "mara table.
                        '1'  'MATNR'         'IT_FINAL'  'Material'                                        '18',
                        '2'  'MATTXT'        'IT_FINAL'  'Material Description'                            '18',
                        '3'  'MTART'         'IT_FINAL'  'Material Type'                                   '18',
                        '4'  'MATKL'         'IT_FINAL'  'Material Group'                                  '18',
                        '5'  'WERKS'         'IT_FINAL'  'Plant'                                           '10',
                        '6'  'LGORT'         'IT_FINAL'  'Storage location'                                '10',
                        '7'  'LABST'         'IT_FINAL'  'Unrestricted'                                    '18',
                        '8'  'UMLME'         'IT_FINAL'  'Stock in transfer '                              '18',
                        '9'  'INSME'         'IT_FINAL'  'Stock in Quality Inspection'                     '18',
                       '10'  'EINME'         'IT_FINAL'  'Total Stock'                                     '18',
                       '11'  'SPEME'         'IT_FINAL'  'Blocked Stock'                                   '18',
                       '12'  'RETME'         'IT_FINAL'  'Blocked Stock Returns'                           '18',
                       '13'  'VMLAB'         'IT_FINAL'  'Valuated unrestricted-use stock'                 '18',
                       '14'  'VMUML'         'IT_FINAL'  'Stock in Transfer in Previous Period'            '18',
                       '15'  'VMINS'         'IT_FINAL'  'Stock in Quality Inspection in Previous Period'  '18',
                       '16'  'VMEIN'         'IT_FINAL'  'Restricted-Use Stock in Previous Period'         '18',
                       '17'  'VMSPE'         'IT_FINAL'  'Blocked stock of previous period'                '18',
                       '18'  'VMRET'         'IT_FINAL'  'Blocked Stock Returns in Previous Period'        '18',
                       '19'  'LGPBE'         'IT_FINAL'  'Storage Bin'                                     '18',
                       '20'  'LBKUM'         'IT_FINAL'  'Total Valuated Stock'                            '18',
                       '21'  'SALK3'         'IT_FINAL'  'Value of Total Valuated Stock'                   '18',
                       '22'  'QL_VAL'        'IT_FINAL'  'Value Of Quality Stock'                          '18',
                       '23'  'PRICE'         'IT_FINAL'  'Price'                                           '18',
                       '24'  'UN_VAL'        'IT_FINAL'  'value Unresticted'                               '18',
                       '25'  'STOCK_NO'      'IT_FINAL'  'Special stock number'                            '20',
                       '26'  'VBELN'         'IT_FINAL'  'Sales Document'                                  '15',
                       '27'  'LIFNR'         'IT_FINAL'  'Subcon Vendor'                                   '15',
                       '28'  'ZITEM_CLASS'   'IT_FINAL'  'item class'                                      '15',      "added by aakashk 07.10.2024
                       '29'  'BLOCK_STOCK'   'IT_FINAL'  'Valued Blocked Stock'                                      '15'.       "added by JYOTI 07.04.2025

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
*BREAK primusabap.
  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
*    PERFORM gui_download.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0542   text
*      -->P_0543   text
*      -->P_0544   text
*      -->P_0545   text
*      -->P_0546   text
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

  IF P_WERKS = 'PL01'.
    LV_FILE = 'ZMB52_PL01_1.TXT'.
  ELSEIF P_WERKS = 'US01'.
    LV_FILE = 'ZMB52_US01.TXT'.
  ELSEIF P_WERKS = 'US02'.
    LV_FILE = 'ZMB52_US02.TXT'.
  ENDIF.
*  lv_file = 'ZMB52.TXT'.
*BREAK primus.
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZMATERIAL STORAGE BIN REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_999 TYPE STRING.
    DATA LV_CRLF_999 TYPE STRING.
    LV_CRLF_999 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_999 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_999 LV_CRLF_999 WA_CSV INTO LV_STRING_999.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_999 TO LV_FULLFILE.
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
  CONCATENATE  'Material'
               'Material Type'
               'Material Group'
               'Plant'
               'Storage location'
               'Unrestricted'
               'Stock in transfer '
               'Stock in Quality Inspection'
               'Total Stock'
               'Blocked Stock'
               'Blocked Stock Returns'
               'Valuated unrestricted-use stock'
               'Stock in Transfer in Previous Period'
               'Stock in Quality Inspection in Previous Period'
               'Restricted-Use Stock in Previous Period'
               'Blocked stock of previous period'
               'Blocked Stock Returns in Previous Period'
               'Storage Bin'
               'Total Valuated Stock'
               'Value of Total Valuated Stock'
               'Price'
               'value Unresticted'
               'Special stock number'
               'Sales Document'
               'Refresh File Date'
               'Value Of Quality Stock'
               'Subcon Vendor'
               'item class'
               'Refresh Time'
               'Value Blocked Stock'
              INTO PD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.

*-----------------------------------------------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  GUI_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM gui_download .
*  TYPES : BEGIN OF ls_fieldname,
*            field_name(25),
*          END OF ls_fieldname.
*
*  DATA : it_fieldname TYPE TABLE OF ls_fieldname.
*  DATA : wa_fieldname TYPE ls_fieldname.
**----------------Fieldnames---------------------------------------------------------
*  wa_fieldname-field_name = 'Material.No.'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Material Desc'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Material Type'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Plant'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Storage loc'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Unrestricted-Use Stock'.
*  APPEND wa_fieldname TO it_fieldname.
*  CLEAR wa_fieldname.
*
*  wa_fieldname-field_name = 'Stock in transfer '.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Stock in Quality Inspection'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Total Stock'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Blocked Stock'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Blocked Stock Returns'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Valuated unrestricted-use stock'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Stock in Transfer in Previous Period'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Stock in Quality Inspection in Previous Period' .
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Restricted-Use Stock in Previous Period'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Blocked stock of previous period'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Blocked Stock Returns in Previous Period'.
*  APPEND wa_fieldname TO it_fieldname.
***--------------------------------------------------------------------*
*  wa_fieldname-field_name = 'Storage Bin'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Total Valuated Stock'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Value of Total Valuated Stock'.             " 25/05/2018
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Price'.                   " 25/05/2018
*  APPEND wa_fieldname TO it_fieldname.
**--------------------------------------------------------------------*
*  wa_fieldname-field_name = 'Unresticted value'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Refresh File Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*
**--------------------------------------------------------------------*
*  DATA file TYPE string." VALUE 'F:\Zmb52.TXT'.
**BREAK primusabap.
*  IF p_werks = 'PL01'.
*    file = 'D:\ZMB52_PL01.TXT'.
*  ELSEIF p_werks = 'US01'.
*    file = 'D:\ZMB52_US01.TXT'.
*  ELSEIF p_werks = 'US02'.
*    file = 'D:\ZMB52_US02.TXT'.
*  ENDIF.
*
*
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
**     BIN_FILESIZE            =
*      filename                = file
*      filetype                = 'ASC'
**     APPEND                  = ' '
*      write_field_separator   = 'X'
**     HEADER                  = '00'
**     TRUNC_TRAILING_BLANKS   = ' '
**     WRITE_LF                = 'X'
**     COL_SELECT              = ' '
**     COL_SELECT_MASK         = ' '
**     DAT_MODE                = ' '
**     CONFIRM_OVERWRITE       = ' '
**     NO_AUTH_CHECK           = ' '
**     CODEPAGE                = ' '
**     IGNORE_CERR             = ABAP_TRUE
**     REPLACEMENT             = '#'
**     WRITE_BOM               = ' '
**     TRUNC_TRAILING_BLANKS_EOL       = 'X'
**     WK1_N_FORMAT            = ' '
**     WK1_N_SIZE              = ' '
**     WK1_T_FORMAT            = ' '
**     WK1_T_SIZE              = ' '
**     WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
**     SHOW_TRANSFER_STATUS    = ABAP_TRUE
**     VIRUS_SCAN_PROFILE      = '/SCET/GUI_DOWNLOAD'
** IMPORTING
**     FILELENGTH              =
*    TABLES
*      data_tab                = lt_final
*      fieldnames              = it_fieldname
*    EXCEPTIONS
*      file_write_error        = 1
*      no_batch                = 2
*      gui_refuse_filetransfer = 3
*      invalid_type            = 4
*      no_authority            = 5
*      unknown_error           = 6
*      header_not_allowed      = 7
*      separator_not_allowed   = 8
*      filesize_not_allowed    = 9
*      header_too_long         = 10
*      dp_error_create         = 11
*      dp_error_send           = 12
*      dp_error_write          = 13
*      unknown_dp_error        = 14
*      access_denied           = 15
*      dp_out_of_memory        = 16
*      disk_full               = 17
*      dp_timeout              = 18
*      file_not_found          = 19
*      dataprovider_exception  = 20
*      control_flush_error     = 21
*      OTHERS                  = 22.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*ENDFORM.
