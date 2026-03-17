*&---------------------------------------------------------------------*
*& Report ZPP_WIP_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPP_WIP_REPORT.

TABLES : AFPO,RESB.
TYPES: BEGIN OF TY_AFPO_RESB,
         AUFNR TYPE AFPO-AUFNR,
         KDAUF TYPE AFPO-KDAUF,
         KDPOS TYPE AFPO-KDPOS,
         DAUAT TYPE AFPO-DAUAT,
         MATNR TYPE AFPO-MATNR,
         PSMNG TYPE AFPO-PSMNG,
         AMEIN TYPE AFPO-AMEIN,
         WEMNG TYPE AFPO-WEMNG,
         DWERK TYPE AFPO-DWERK,
         ELIKZ TYPE AFPO-ELIKZ,
         MEINS TYPE AFPO-MEINS,
         ERDAT TYPE CAUFV-ERDAT,
         ENMNG TYPE RESB-ENMNG,
         BDMNG TYPE RESB-BDMNG,
         SHKZG TYPE RESB-SHKZG,
         XLOEK TYPE RESB-XLOEK,
         RSNUM TYPE RESB-RSNUM,
         RSPOS TYPE RESB-RSPOS,
         LGORT TYPE AFPO-LGORT,       "" added by pavan 24.06.2024
       END OF TY_AFPO_RESB,

       BEGIN OF TY_AFKO,
         AUFNR TYPE AFKO-AUFNR,
         FTRMI TYPE AFKO-FTRMI,
       END OF TY_AFKO,

       BEGIN OF TY_RESB,
         AUFNR TYPE RESB-AUFNR,
         RSNUM TYPE RESB-RSNUM,
         MATNR TYPE RESB-MATNR,
         MEINS TYPE RESB-MEINS,
         RSPOS TYPE RESB-RSPOS,
       END OF TY_RESB,

       BEGIN OF TY_MAKT,
         MATNR TYPE MAKT-MATNR,
         MAKTX TYPE MAKT-MAKTX,
       END OF TY_MAKT,

       BEGIN OF TY_MBEW,
         MATNR TYPE MBEW-MATNR,
         BWKEY TYPE MBEW-BWKEY,
         VPRSV TYPE MBEW-VPRSV,
         VERPR TYPE MBEW-VERPR,
         STPRS TYPE MBEW-STPRS,
       END OF TY_MBEW,

       BEGIN OF TY_MSEG,
         MBLNR      TYPE MSEG-MBLNR,
         MJAHR      TYPE MSEG-MJAHR,
         ZEILE      TYPE MSEG-ZEILE,
         BWART      TYPE MSEG-BWART,
         MATNR      TYPE MSEG-MATNR,
         AUFNR      TYPE MSEG-AUFNR,
         BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
       END OF TY_MSEG,

       BEGIN OF TY_FINAL,
         AUFNR      TYPE AFPO-AUFNR,
         PSMNG      TYPE AFPO-PSMNG,
         AMEIN      TYPE AFPO-AMEIN,
         WEMNG      TYPE AFPO-WEMNG,
         MEINS      TYPE AFPO-MEINS,
         MATNR      TYPE AFPO-MATNR,
         MAKTX      TYPE MAKT-MAKTX,
         DWERK      TYPE AFPO-DWERK,
         DAUAT      TYPE AFPO-DAUAT,
         KDAUF      TYPE AFPO-KDAUF,
         KDPOS      TYPE AFPO-KDPOS,
         ELIKZ      TYPE AFPO-ELIKZ,
         RSNUM      TYPE RESB-RSNUM,
         BDMNG      TYPE RESB-BDMNG,
         ENMNG      TYPE RESB-ENMNG,
         RSPOS      TYPE RESB-RSPOS,
         SHKZG      TYPE RESB-SHKZG,
         XLOEK      TYPE RESB-XLOEK,
         MATNR1     TYPE RESB-MATNR,
         MEINS1     TYPE RESB-MEINS,
         MAKTX1     TYPE MAKT-MAKTX,
         PRICE      TYPE MBEW-STPRS,
         SHORTAGE   TYPE RESB-ENMNG,
         MAP        TYPE MBEW-VERPR,
         WIPQTY     TYPE RESB-ENMNG,
         WIPVALUE   TYPE MBEW-VERPR,
         RATIO      TYPE RESB-ENMNG,
         QTY        TYPE RESB-ENMNG,
         ERDAT      TYPE CAUFV-ERDAT,
         KUNNR      TYPE KNA1-KUNNR,
         NAME       TYPE KNA1-NAME1,
         VERPR      TYPE MBEW-VERPR,
         BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
         SO_LGORT   TYPE AFPO-LGORT,                   "" added by pavan on 24.06.2024
         P_LGORT    TYPE VBAP-LGORT,                   "" added by pavan on 24.06.2024
         SERIAL_NO  TYPE INT8, "addeed by jyoti
         FTRMI      TYPE AFKO-FTRMI, "addeed by jyotio n 24.12.2024

       END OF TY_FINAL,

       BEGIN OF TY_DOWN,
         ERDAT      TYPE STRING,
         DAUAT      TYPE AFPO-DAUAT,
         KDAUF      TYPE AFPO-KDAUF,
         KDPOS      TYPE AFPO-KDPOS,
         AUFNR      TYPE AFPO-AUFNR,
         KUNNR      TYPE KNA1-KUNNR,
         NAME       TYPE CHAR100,
         MATNR      TYPE MARA-MATNR,
         MAKTX      TYPE CHAR50,
         MATNR1     TYPE MARA-MATNR,
         MAKTX1     TYPE CHAR50,
         BDMNG      TYPE CHAR15,
         ENMNG      TYPE CHAR15,
         SHORTAGE   TYPE CHAR15,
         WIPQTY     TYPE CHAR15,
         PSMNG      TYPE CHAR15,
         WEMNG      TYPE CHAR15,
         MAP        TYPE CHAR15,
         VERPR      TYPE CHAR15,
         WIPVALUE   TYPE CHAR15,
         REF        TYPE CHAR15,
         TIME       TYPE SY-UZEIT,
         BUDAT_MKPF TYPE CHAR15,
         SO_LGORT   TYPE AFPO-LGORT,                   "" added by pavan on 24.06.2024
         P_LGORT    TYPE VBAP-LGORT,                   "" added by pavan on 24.06.2024
         SERIAL_NO  TYPE STRING,                    "addeed by jyoti
         FTRMI      TYPE CHAR11,      "addeed by jyoti on 24.12.2024
       END OF TY_DOWN.
DATA : IT_DOWN TYPE TABLE OF TY_DOWN,
       WA_DOWN TYPE          TY_DOWN.
DATA CONFIRMED(001) TYPE C .


DATA : IT_AFPO_RESB TYPE TABLE OF TY_AFPO_RESB,
       WA_AFPO_RESB TYPE          TY_AFPO_RESB,

       IT_AFKO      TYPE TABLE OF TY_AFKO,
       WA_AFKO      TYPE TY_AFKO,

       IT_RESB      TYPE TABLE OF TY_RESB,
       WA_RESB      TYPE          TY_RESB,

       IT_MAKT      TYPE TABLE OF TY_MAKT,
       WA_MAKT      TYPE          TY_MAKT,

       IT_MBEW      TYPE TABLE OF TY_MBEW,
       WA_MBEW      TYPE          MBEW,

       IT_MSEG      TYPE TABLE OF TY_MSEG,
       WA_MSEG      TYPE          TY_MSEG,

       IT_FINAL     TYPE TABLE OF TY_FINAL,
       WA_FINAL     TYPE          TY_FINAL.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.



SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : S_ORDER FOR AFPO-AUFNR,
                   S_MATNR FOR AFPO-MATNR,
                   S_TYPE  FOR AFPO-DAUAT,
                   S_DELIV FOR AFPO-ELIKZ ,
*                   CONF    FOR CONFIRMED LOWER CASE,
                   S_SHKZG FOR RESB-SHKZG ,
                   S_XLOEK FOR RESB-XLOEK ,
                   S_WEMNG FOR AFPO-WEMNG.

  PARAMETERS  :    P_PLANT TYPE AFPO-DWERK DEFAULT 'PL01'.


SELECTION-SCREEN: END OF BLOCK B1.


SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.

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
  " BREAK primus.


  SELECT AFPO~AUFNR AFPO~KDAUF AFPO~KDPOS AFPO~DAUAT AFPO~MATNR AFPO~PSMNG AFPO~AMEIN AFPO~WEMNG AFPO~DWERK AFPO~ELIKZ AFPO~MEINS
         CAUFV~ERDAT RESB~ENMNG RESB~BDMNG RESB~SHKZG RESB~XLOEK RESB~RSNUM RESB~RSPOS AFPO~LGORT
              INTO TABLE IT_AFPO_RESB
      FROM ( AFPO
             INNER JOIN CAUFV
             ON  CAUFV~AUFNR = AFPO~AUFNR
             INNER JOIN RESB
             ON  RESB~AUFNR = AFPO~AUFNR )
           WHERE AFPO~AUFNR IN S_ORDER
             AND AFPO~DAUAT IN S_TYPE
             AND AFPO~DWERK = P_PLANT
             AND AFPO~ELIKZ IN S_DELIV
             AND AFPO~MATNR IN S_MATNR
             AND RESB~SHKZG IN S_SHKZG
             AND RESB~XLOEK IN S_XLOEK
             AND AFPO~WEMNG IN S_WEMNG.

*IF it_afpo_resb IS NOT INITIAL.
*SELECT aufnr
*       RSNUM
*       MATNR
*       MEINS
*       RSPOS FROM resb INTO TABLE it_resb
*       FOR ALL ENTRIES IN it_afpo_resb
*       WHERE aufnr = it_afpo_resb-aufnr.
******************added by snehal on 24.09.2020****************
  IF IT_AFPO_RESB IS NOT INITIAL.

    SELECT AUFNR
           FTRMI
           FROM AFKO
           INTO TABLE IT_AFKO
           FOR ALL ENTRIES IN IT_AFPO_RESB
           WHERE AUFNR = IT_AFPO_RESB-AUFNR.


*    SELECT mblnr
*           mjahr
*           zeile
*           bwart
*           matnr
*           aufnr
*           budat_mkpf
*      FROM mseg
*      INTO TABLE it_mseg
*      FOR ALL ENTRIES IN it_afpo_resb
*      WHERE  aufnr = it_afpo_resb-aufnr.
*
  ENDIF.
********************************************************************
  IF IT_RESB IS NOT INITIAL.
    SELECT MATNR
           BWKEY
           VPRSV
           VERPR
           STPRS FROM MBEW INTO TABLE IT_MBEW
           FOR ALL ENTRIES IN IT_RESB
           WHERE MATNR = IT_RESB-MATNR
             AND BWKEY = P_PLANT.


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


  IF IT_AFPO_RESB IS NOT INITIAL .
    SELECT RSNUM,RSPOS,AUFNR, MATNR INTO TABLE @DATA(IT_MAT)
      FROM RESB
      FOR ALL ENTRIES IN @IT_AFPO_RESB
       WHERE AUFNR = @IT_AFPO_RESB-AUFNR AND RSNUM = @IT_AFPO_RESB-RSNUM AND
                                         RSPOS = @IT_AFPO_RESB-RSPOS.
    SELECT  KUNNR , VBELN
      FROM VBAK
        INTO TABLE @DATA(IT_VBAK)
           FOR ALL ENTRIES IN @IT_AFPO_RESB
            WHERE VBELN = @IT_AFPO_RESB-KDAUF.

    IF IT_VBAK IS NOT INITIAL .
      SELECT   NAME1 , NAME2, KUNNR FROM KNA1 INTO TABLE @DATA(IT_KNA1)
            FOR ALL ENTRIES IN @IT_VBAK
                WHERE KUNNR = @IT_VBAK-KUNNR.

    ENDIF.

    SELECT VBELN ,POSNR ,LGORT
      FROM VBAP
        FOR ALL ENTRIES IN @IT_AFPO_RESB
          WHERE VBELN = @IT_AFPO_RESB-KDAUF
          AND   POSNR = @IT_AFPO_RESB-KDPOS
            INTO TABLE @DATA(IT_VBAP).

    SELECT MAKTX , MATNR
      FROM MAKT
       FOR ALL ENTRIES IN @IT_AFPO_RESB
        WHERE MATNR = @IT_AFPO_RESB-MATNR
          INTO TABLE @DATA(IT_MAKT) .

  ENDIF.

  IF IT_MAT IS NOT INITIAL .
    SELECT MAKTX , MATNR
  FROM MAKT
   FOR ALL ENTRIES IN @IT_MAT
    WHERE MATNR = @IT_MAT-MATNR
      INTO TABLE @DATA(IT_MAKT1) .

  ENDIF.


  LOOP AT IT_AFPO_RESB INTO WA_AFPO_RESB.
    IF WA_AFPO_RESB-PSMNG = WA_AFPO_RESB-WEMNG.
      CONFIRMED = 'X'.
    ENDIF.

    WA_FINAL-SHORTAGE = WA_AFPO_RESB-BDMNG - WA_AFPO_RESB-ENMNG .
*** additional coding:

    WA_FINAL-RATIO = WA_AFPO_RESB-BDMNG / WA_AFPO_RESB-PSMNG.
    WA_FINAL-QTY = WA_AFPO_RESB-ENMNG - ( WA_AFPO_RESB-WEMNG * WA_FINAL-RATIO ).
    IF WA_FINAL-QTY < 0.
      WA_FINAL-WIPQTY = 0.
    ELSE.
      WA_FINAL-WIPQTY = WA_FINAL-QTY.
    ENDIF.
    WA_FINAL-ERDAT = WA_AFPO_RESB-ERDAT.
    WA_FINAL-AUFNR = WA_AFPO_RESB-AUFNR.
    WA_FINAL-PSMNG = WA_AFPO_RESB-PSMNG.
    WA_FINAL-AMEIN = WA_AFPO_RESB-AMEIN.
    WA_FINAL-WEMNG = WA_AFPO_RESB-WEMNG.
    WA_FINAL-MEINS = WA_AFPO_RESB-MEINS.
    WA_FINAL-MATNR = WA_AFPO_RESB-MATNR.
    WA_FINAL-DWERK = WA_AFPO_RESB-DWERK.
    WA_FINAL-DAUAT = WA_AFPO_RESB-DAUAT.
    WA_FINAL-KDAUF = WA_AFPO_RESB-KDAUF.
    WA_FINAL-KDPOS = WA_AFPO_RESB-KDPOS.
    WA_FINAL-ELIKZ = WA_AFPO_RESB-ELIKZ.
    WA_FINAL-RSNUM = WA_AFPO_RESB-RSNUM.
    WA_FINAL-BDMNG = WA_AFPO_RESB-BDMNG.
    WA_FINAL-ENMNG = WA_AFPO_RESB-ENMNG.
    WA_FINAL-RSPOS = WA_AFPO_RESB-RSPOS.
    WA_FINAL-SHKZG = WA_AFPO_RESB-SHKZG.
    WA_FINAL-XLOEK = WA_AFPO_RESB-XLOEK.
    WA_FINAL-P_LGORT = WA_AFPO_RESB-LGORT.

    READ TABLE IT_AFKO INTO WA_AFKO WITH KEY AUFNR = WA_FINAL-AUFNR.
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-FTRMI = WA_AFKO-FTRMI.
    ENDIF.


**************************    SELECT SINGLE matnr INTO wa_final-matnr1 FROM resb WHERE aufnr = wa_final-aufnr AND rsnum = wa_final-rsnum AND
**************************                                                             rspos = wa_final-rspos.   """" CMT BY NC
    READ TABLE IT_MAT INTO DATA(WA_MAT) WITH KEY AUFNR = WA_FINAL-AUFNR
                                                 RSNUM = WA_FINAL-RSNUM
                                                 RSPOS = WA_FINAL-RSPOS.


    IF SY-SUBRC EQ 0 .
      WA_FINAL-MATNR1 = WA_MAT-MATNR .
    ENDIF.

*READ TABLE it_resb INTO wa_resb WITH KEY aufnr = wa_final-aufnr.
*IF sy-subrc = 0.
*  wa_final-matnr1 = wa_resb-matnr.
*  wa_final-MEINS1 = wa_resb-MEINS.
*
*ENDIF.
*****************added by snehal on 24.09.2020************
*    SELECT SINGLE * FROM mseg into wa_mseg WHERE aufnr = wa_final-aufnr.
    READ TABLE IT_MSEG INTO WA_MSEG WITH KEY AUFNR = WA_FINAL-AUFNR.
    IF SY-SUBRC = 0.
      IF WA_MSEG-BWART = '261'.
        WA_FINAL-BUDAT_MKPF = WA_MSEG-BUDAT_MKPF.
      ENDIF.
    ENDIF.
*************************************************************
*    SELECT SINGLE * FROM MBEW INTO WA_MBEW WHERE MATNR = WA_FINAL-MATNR1 AND BWKEY = WA_AFPO_RESB-DWERK.  """"""" cmt by nc
    SELECT SINGLE STPRS, VERPR , VPRSV  FROM MBEW INTO CORRESPONDING FIELDS OF @WA_MBEW  WHERE MATNR = @WA_FINAL-MATNR1 AND BWKEY = @WA_AFPO_RESB-DWERK.  """"""" cmt by nc
*READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_final-matnr1.
    IF SY-SUBRC = 0.
      IF WA_MBEW-VPRSV = 'S'.
        WA_FINAL-MAP = WA_MBEW-STPRS.
      ELSEIF WA_MBEW-VPRSV = 'V'.
        WA_FINAL-MAP = WA_MBEW-VERPR.
      ENDIF.
      WA_FINAL-VERPR = WA_MBEW-VERPR.
    ENDIF.

    WA_FINAL-WIPVALUE = WA_FINAL-WIPQTY * WA_FINAL-MAP.


    DATA : V_NAME1 TYPE KNA1-NAME1,
           V_NAME2 TYPE KNA1-NAME2.
    CLEAR : V_NAME1 , V_NAME2 .
*****    SELECT SINGLE KUNNR FROM VBAK INTO WA_FINAL-KUNNR
*****                        WHERE VBELN = WA_FINAL-KDAUF.    """""""""" Cmt ty NC

    READ TABLE IT_VBAK INTO DATA(WA_VBAK) WITH KEY VBELN = WA_FINAL-KDAUF.
    IF SY-SUBRC EQ 0.
      WA_FINAL-KUNNR = WA_VBAK-KUNNR .
    ENDIF.

    IF WA_FINAL-KUNNR IS NOT INITIAL.
*      SELECT SINGLE NAME1 NAME2 FROM KNA1 INTO (V_NAME1,V_NAME2)
*                            WHERE KUNNR = WA_FINAL-KUNNR.    """""""""" cmt by nc

      READ TABLE IT_KNA1 INTO DATA(WA_KNA1) WITH KEY KUNNR = WA_FINAL-KUNNR.
      IF  WA_KNA1-NAME2 IS NOT INITIAL.
        CONCATENATE WA_KNA1-NAME1 WA_KNA1-NAME2 INTO WA_FINAL-NAME SEPARATED BY ' '.
      ELSE.
        WA_FINAL-NAME =  WA_KNA1-NAME1 .
      ENDIF.
    ENDIF.

*****    SELECT SINGLE LGORT
*****      FROM VBAP
*****      INTO WA_FINAL-SO_LGORT
*****      WHERE VBELN = WA_FINAL-KDAUF
*****        AND POSNR = WA_FINAL-KDPOS.   """""""""""" cmt by NC

    READ TABLE IT_VBAP INTO DATA(WA_VBAP) WITH KEY VBELN = WA_FINAL-KDAUF
                                                   POSNR = WA_FINAL-KDPOS.
    IF SY-SUBRC EQ 0.
      WA_FINAL-SO_LGORT = WA_VBAP-LGORT .
    ENDIF.

*************    SELECT SINGLE MAKTX INTO WA_FINAL-MAKTX FROM MAKT WHERE MATNR = WA_FINAL-MATNR.   cmt by nc
    READ TABLE IT_MAKT INTO DATA(WA_MAKT) WITH KEY MATNR = WA_FINAL-MATNR.
    IF SY-SUBRC EQ 0.
      WA_FINAL-MAKTX = WA_MAKT-MAKTX .
    ENDIF.
*******    SELECT SINGLE MAKTX INTO WA_FINAL-MAKTX1 FROM MAKT WHERE MATNR = WA_FINAL-MATNR1.  cmt by nc

    READ TABLE IT_MAKT1 INTO DATA(WA_MAKT1) WITH KEY MATNR = WA_FINAL-MATNR1.
    IF SY-SUBRC EQ 0.
      WA_FINAL-MAKTX1 = WA_MAKT1-MAKTX .
    ENDIF.

    IF WA_FINAL-SHORTAGE < 0.
      WA_FINAL-SHORTAGE = 0.
    ENDIF.
    DATA: GV_COUNT TYPE INT8.
    GV_COUNT = GV_COUNT + 1.
    WA_FINAL-SERIAL_NO =  GV_COUNT.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
*DELETE it_final WHERE WIPVALUE IS INITIAL.
  ENDLOOP.

  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
*  wa_down-ERDAT  = wa_final-ERDAT .
      WA_DOWN-DAUAT  = WA_FINAL-DAUAT .
      WA_DOWN-KDAUF  = WA_FINAL-KDAUF .
      WA_DOWN-KDPOS  = WA_FINAL-KDPOS .
      WA_DOWN-AUFNR  = WA_FINAL-AUFNR .
      WA_DOWN-KUNNR  = WA_FINAL-KUNNR .
      WA_DOWN-NAME   = WA_FINAL-NAME  .
      WA_DOWN-MATNR  = WA_FINAL-MATNR .
      WA_DOWN-MAKTX  = WA_FINAL-MAKTX .
      WA_DOWN-MATNR1 = WA_FINAL-MATNR1.
      WA_DOWN-MAKTX1 = WA_FINAL-MAKTX1.
      WA_DOWN-BDMNG  = WA_FINAL-BDMNG .
      WA_DOWN-ENMNG  = WA_FINAL-ENMNG .

      WA_DOWN-SO_LGORT  = WA_FINAL-SO_LGORT .
      WA_DOWN-P_LGORT   = WA_FINAL-P_LGORT .

      WA_DOWN-SHORTAGE = WA_FINAL-SHORTAGE.
      WA_DOWN-WIPQTY  = WA_FINAL-WIPQTY  .
      WA_DOWN-PSMNG   = WA_FINAL-PSMNG   .
      WA_DOWN-WEMNG   = WA_FINAL-WEMNG   .
      WA_DOWN-MAP     = WA_FINAL-MAP     .
      WA_DOWN-VERPR    = WA_FINAL-VERPR   .
      WA_DOWN-WIPVALUE = WA_FINAL-WIPVALUE.
*  wa_down-budat_mkpf = wa_final-budat_mkpf.
      WA_DOWN-TIME     = SY-UZEIT.
      WA_DOWN-SERIAL_NO = WA_FINAL-SERIAL_NO.

      IF WA_FINAL-ERDAT IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-ERDAT
          IMPORTING
            OUTPUT = WA_DOWN-ERDAT.

        CONCATENATE WA_DOWN-ERDAT+0(2) WA_DOWN-ERDAT+2(3) WA_DOWN-ERDAT+5(4)
                        INTO WA_DOWN-ERDAT SEPARATED BY '-'.
      ENDIF.
      """"""""""""""""""added by jyoti on 24.12.2024
      IF WA_FINAL-FTRMI IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-FTRMI
          IMPORTING
            OUTPUT = WA_DOWN-FTRMI.

        CONCATENATE WA_DOWN-FTRMI+0(2) WA_DOWN-FTRMI+2(3) WA_DOWN-FTRMI+5(4)
                        INTO WA_DOWN-FTRMI SEPARATED BY '-'.
      ENDIF.

      IF WA_FINAL-BUDAT_MKPF IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-BUDAT_MKPF
          IMPORTING
            OUTPUT = WA_DOWN-BUDAT_MKPF.

        CONCATENATE WA_DOWN-BUDAT_MKPF+0(2) WA_DOWN-BUDAT_MKPF+2(3) WA_DOWN-BUDAT_MKPF+5(4)
                        INTO WA_DOWN-BUDAT_MKPF SEPARATED BY '-'.
      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
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
  PERFORM FCAT USING :    '1'  'SERIAL_NO'     'IT_FINAL'  'Serial No'            '18',                       " added by jyoti on 20.12.2024
                          '2'  'ERDAT'         'IT_FINAL'  'Start Date'                                        '18',
                          '3'  'DAUAT'         'IT_FINAL'  'Order Type'                   '18',
                          '4'  'KDAUF'         'IT_FINAL'  'Sales Order No'                   '18',
                          '5'  'KDPOS'         'IT_FINAL'  'Sales Order Item'                   '18',
                          '6'  'AUFNR'         'IT_FINAL'  'Order'                                        '18',
                          '7'  'KUNNR'         'IT_FINAL'  'Customer Code'                                        '18',
                          '8'  'NAME'          'IT_FINAL'  'Customer Name'                                        '18',
                          '9'  'MATNR'         'IT_FINAL'  'Material'                   '18',
                          '10'  'MAKTX'         'IT_FINAL'  'Material Description'                   '18',
                         '11'  'MATNR1'        'IT_FINAL'  'Component'                   '18',
                         '12'  'MAKTX1'        'IT_FINAL'  'Component Description'                   '18',
                         '13'  'BDMNG'         'IT_FINAL'  'Reqmt Qty'                   '18',
                         '14'  'ENMNG'         'IT_FINAL'  'Issue Qty.'                   '18',
                         '15'  'SHORTAGE'      'IT_FINAL'  'Shortage Qty.'                   '18',
                         '16'  'WIPQTY'        'IT_FINAL'  'WIP Qty.'                   '18',
                         '17'  'PSMNG'         'IT_FINAL'  'Order Quantity'                                        '18',
                         '18'  'WEMNG'         'IT_FINAL'  'Confirmation Qty.'                   '18',
                         '19'  'MAP'           'IT_FINAL'  'Price'                   '18',
                         '20'  'VERPR'         'IT_FINAL'  'MovAvgPrice'                   '18',
                         '21'  'WIPVALUE'      'IT_FINAL'  'WIP Value'                   '18',
                         '22'  'BUDAT_MKPF'    'IT_FINAL'  'Issued Date'                 '18',
                         '23'  'SO_LGORT'      'IT_FINAL'  'SO Sloc'                     '18',                         " added by pavan on 24.06.2024
                         '24'  'P_LGORT'       'IT_FINAL'  'Prod. Order Sloc'            '18',                   " added by pavan on 24.06.20244
                         '25'  'FTRMI'        'IT_FINAL'  'Prod. Order Release Date'            '15'.   "added by jyoti on 24.12.2024



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
*  IF p_down = 'X'.
*    PERFORM download.
**    PERFORM gui_download.
*  ENDIF.
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
*      -->P_0593   text
*      -->P_0594   text
*      -->P_0595   text
*      -->P_0596   text
*      -->P_0597   text
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


  LV_FILE = 'ZPP_WIP.TXT'.


  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPPWIP REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_658 TYPE STRING.
    DATA LV_CRLF_658 TYPE STRING.
    LV_CRLF_658 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_658 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_658 LV_CRLF_658 WA_CSV INTO LV_STRING_658.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_565 TO lv_fullfile.
    TRANSFER LV_STRING_658 TO LV_FULLFILE.
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
  CONCATENATE 'Start Date'
              'Order Type'
              'Sales Order No'
              'Sales Order Item'
              'Order'
              'Customer Code'
              'Customer Name'
              'Material'
              'Material Description'
               'Component'
              'Component Description'
              'Reqmt Qty'
               'Issue Qty.'
              'Shortage Qty.'
              'WIP Qty.'
              'Order Quantity'
              'Confirmation Qty.'
              'Price'
              'MovAvgPrice'
              'WIP Value'
              'Refreshable Date'
              'Refreshable Time'
              'Issued Date'
              'SO Sloc'
              'Prod. Order Sloc'
              'Serial No'
              'Production Order Release Date'   "added by jyoti on 24.12.2024
              INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
