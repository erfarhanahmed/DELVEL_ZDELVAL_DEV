*&---------------------------------------------------------------------*
*& Report ZMRP_REPORT
*&---------------------------------------------------------------------*
*&Report: ZMRP_REPORT
*&Transaction: ZSO_MRPDATE
*&Functional Cosultant: Subhashish Pande
*&Technical Consultant: Nilay Brahme
*&TR:  DEVK912058
*&Date: 03.02.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT ZMRP_REPORT.


TABLES : VBAP, VBEP, CDHDR.


TYPES : BEGIN OF TY_DATA,
          VBELN TYPE VBELN,
          POSNR TYPE POSNR,
          MATNR TYPE MATNR,    "edited by PJ 16-08-21
          LFSTA TYPE VBUP-LFSTA,
          LFGSA TYPE VBUP-LFGSA,
          FKSTA TYPE VBUP-FKSTA,
          ABSTA TYPE VBUP-ABSTA,
          GBSTA TYPE VBUP-GBSTA,
*         WERKS TYPE WERKS,
        END OF TY_DATA.

TYPES : BEGIN OF TY_CDHDR,
          OBJECTCLAS TYPE CDHDR-OBJECTCLAS,
          OBJECTID   TYPE CDHDR-OBJECTID,
          CHANGENR   TYPE CDHDR-CHANGENR,
          UDATE      TYPE CDHDR-UDATE,
          TCODE      TYPE CDHDR-TCODE,
        END OF TY_CDHDR.

TYPES: BEGIN OF TY_VBAP,
         VBELN        TYPE VBAP-VBELN,
         POSNR        TYPE VBAP-POSNR,
         MATNR        TYPE VBAP-MATNR,
         ARKTX        TYPE VBAP-ARKTX,
         ABGRU        TYPE VBAP-ABGRU,
         POSEX        TYPE VBAP-POSEX,
         KDMAT        TYPE VBAP-KDMAT,
         WAERK        TYPE VBAP-WAERK,
         KWMENG       TYPE VBAP-KWMENG,
         WERKS        TYPE VBAP-WERKS,
         NTGEW        TYPE VBAP-NTGEW,          "added by pankaj 28.01.2022
         OBJNR        TYPE VBAP-OBJNR,
         HOLDDATE     TYPE VBAP-HOLDDATE,
         HOLDRELDATE  TYPE VBAP-HOLDRELDATE,
         CANCELDATE   TYPE VBAP-CANCELDATE,
         DELDATE      TYPE VBAP-DELDATE,
         CUSTDELDATE  TYPE VBAP-CUSTDELDATE,
         ZGAD         TYPE VBAP-ZGAD,
         CTBG         TYPE VBAP-CTBG,  " ADDED BY AJAY
         RECEIPT_DATE TYPE VBAP-RECEIPT_DATE,          "added by pankaj 28.01.2022
         REASON       TYPE VBAP-REASON,                "added by pankaj 28.01.2022
         OFM_DATE     TYPE VBAP-OFM_DATE,                "added by pankaj 01.02.2022
         ERDAT        TYPE VBAP-ERDAT,
       END OF TY_VBAP.
TYPES : BEGIN OF TY_FINAL,
*          OBJCTID TYPE CDHDR-OBJECTID,
          VBELN TYPE VBEP-VBELN,
          POSNR TYPE VBEP-POSNR,
          UDATE TYPE CDHDR-UDATE,
        END OF TY_FINAL,

        BEGIN OF TY_DOWN,
          VBELN    TYPE VBEP-VBELN,
          POSNR    TYPE VBEP-POSNR,
          MRP_DT   TYPE CHAR15,
          REF_DATE TYPE CHAR30,
          REF_TIME TYPE CHAR30,

        END OF TY_DOWN.
TYPES:BEGIN OF TY_VBAP2,
*          vbeln        TYPE vbap-vbeln,
        VBELN        TYPE CDHDR-OBJECTID,
        POSNR        TYPE VBAP-POSNR,
        MATNR        TYPE VBAP-MATNR,
        ARKTX        TYPE VBAP-ARKTX,
        ABGRU        TYPE VBAP-ABGRU,
        POSEX        TYPE VBAP-POSEX,
        KDMAT        TYPE VBAP-KDMAT,
        WAERK        TYPE VBAP-WAERK,
        KWMENG       TYPE VBAP-KWMENG,
        WERKS        TYPE VBAP-WERKS,
        NTGEW        TYPE VBAP-NTGEW,          "added by pankaj 28.01.2022
        OBJNR        TYPE VBAP-OBJNR,
        HOLDDATE     TYPE VBAP-HOLDDATE,
        HOLDRELDATE  TYPE VBAP-HOLDRELDATE,
        CANCELDATE   TYPE VBAP-CANCELDATE,
        DELDATE      TYPE VBAP-DELDATE,
        CUSTDELDATE  TYPE VBAP-CUSTDELDATE,
        ZGAD         TYPE VBAP-ZGAD,
        CTBG         TYPE VBAP-CTBG,  " ADDED BY AJAY
        RECEIPT_DATE TYPE VBAP-RECEIPT_DATE,          "added by pankaj 28.01.2022
        REASON       TYPE VBAP-REASON,                "added by pankaj 28.01.2022
        OFM_DATE     TYPE VBAP-OFM_DATE,                "added by pankaj 01.02.2022
        ERDAT        TYPE VBAP-ERDAT,
      END OF TY_VBAP2.
DATA: I_SORT             TYPE SLIS_T_SORTINFO_ALV, " SORT
      GT_EVENTS          TYPE SLIS_T_EVENT,        " EVENTS
      I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER,   " TOP-OF-PAGE
      WA_LAYOUT          TYPE  SLIS_LAYOUT_ALV..            " LAYOUT WORKAREA

TYPES : BEGIN OF OUTPUT,
          VBELN  TYPE VBELN,
          POSNR  TYPE VBAP-POSNR,
          MRP_DT TYPE CHAR15,
        END OF OUTPUT.


CONSTANTS:
  C_FORMNAME_TOP_OF_PAGE   TYPE SLIS_FORMNAME
                                   VALUE 'TOP_OF_PAGE',
  C_FORMNAME_PF_STATUS_SET TYPE SLIS_FORMNAME
                                 VALUE 'PF_STATUS_SET',
  C_S                      TYPE C VALUE 'S',
  C_H                      TYPE C VALUE 'H'.
TYPES : BEGIN OF TY_VBAK,
          VBELN       TYPE VBAK-VBELN,
          ERDAT       TYPE VBAK-ERDAT,
          AUART       TYPE VBAK-AUART,
          LIFSK       TYPE VBAK-LIFSK,
          WAERK       TYPE VBAK-WAERK,
          VKBUR       TYPE VBAK-VKBUR,
          KNUMV       TYPE VBAK-KNUMV,
          VDATU       TYPE VBAK-VDATU,
          BSTDK       TYPE VBAK-BSTDK,
          KUNNR       TYPE VBAK-KUNNR,
          OBJNR       TYPE VBAK-OBJNR,            "added by pankaj 04.02.2022
          ZLDFROMDATE TYPE VBAK-ZLDFROMDATE,
          ZLDPERWEEK  TYPE VBAK-ZLDPERWEEK,
          ZLDMAX      TYPE VBAK-ZLDMAX,
          FAKSK       TYPE VBAK-FAKSK,
        END OF TY_VBAK.
TYPES: BEGIN OF TY_VBEP,
         VBELN TYPE VBEP-VBELN,
         POSNR TYPE VBEP-POSNR,
         ETENR TYPE VBEP-ETENR,
         ETTYP TYPE VBEP-ETTYP,
         EDATU TYPE VBEP-EDATU,
       END OF TY_VBEP.

TYPES: BEGIN OF TY_VBEPTABKEY,
         VBELN   TYPE CHAR90,
         POSNR   TYPE VBEP-POSNR,
         ETENR   TYPE VBEP-ETENR,
         ETTYP   TYPE VBEP-ETTYP,
         EDATU   TYPE VBEP-EDATU,
         VTABKEY TYPE CDPOS-TABKEY,
       END OF TY_VBEPTABKEY.


DATA: IT_DATA         TYPE STANDARD TABLE OF TY_DATA,
      LS_DATA         TYPE TY_DATA,
      IT_VBAP2        TYPE TABLE OF TY_VBAP2,
      WA_VBAP2        TYPE TY_VBAP2,
      IT_VBAK         TYPE TABLE OF TY_VBAK,
      WA_VBAK         TYPE TY_VBAK,
      IT_VBAP         TYPE TABLE OF TY_VBAP,
      WA_VBAP         TYPE TY_VBAP,
      IT_CDPOS        TYPE STANDARD TABLE OF CDPOS,
      WA_CDPOS        TYPE CDPOS,
      IT_CDPOSTABKEY  TYPE STANDARD TABLE OF CDPOS,
      WA_CDPOSTABKEY  TYPE CDPOS,
      IT_CDPOSTABKEY1 TYPE STANDARD TABLE OF CDPOS,
      WA_CDPOSTABKEY1 TYPE CDPOS,

      IT_OUTPUT       TYPE STANDARD TABLE OF OUTPUT,
      WA_OUTPUT       TYPE OUTPUT,
      IT_CDHDR        TYPE TABLE OF CDHDR,
      WA_CDHDR        TYPE CDHDR,
      IT_CDHDROBJID   TYPE TABLE OF CDHDR,
      WA_CDHDROBJID   TYPE CDHDR,
      LT_VBEP         TYPE TABLE OF TY_VBEP,
      LS_VBEP         TYPE TY_VBEP,
      IT_VBEP         TYPE TABLE OF TY_VBEP,
      WA_VBEP         TYPE TY_VBEP,
      IT_VBEPTABKEY   TYPE TABLE OF TY_VBEPTABKEY,
      WA_VBEPTABKEY   TYPE TY_VBEPTABKEY,
      IT_VBEPTABKEY1  TYPE TABLE OF TY_VBEPTABKEY,
      WA_VBEPTABKEY1  TYPE TY_VBEPTABKEY,

*      LT_VBEP   TYPE TABLE OF TY_VBEP,
*      LS_VBEP   TYPE TY_VBEP,

*      IT_FINAL  TYPE TABLE OF TY_FINAL,
*      WA_FINAL  TYPE TY_FINAL,

      IT_DOWN         TYPE TABLE OF TY_DOWN,
      WA_DOWN         TYPE TY_DOWN.

DATA : LV_VBELN  TYPE CDHDR-OBJECTID,
       LV_VBELN2 TYPE VBAP-VBELN.

DATA : IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
       IS_FCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE.

DATA : IS_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA : R_OBJECTCLAS TYPE RANGE OF CDPOS-OBJECTCLAS.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001 .
SELECT-OPTIONS : S_VBELN FOR VBAP-VBELN,
                 S_POSNR FOR VBAP-POSNR,
                 S_WERKS FOR VBAP-WERKS.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

START-OF-SELECTION.

  PERFORM FETCH_DATA.
*  PERFORM GET_DATA.
*  PERFORM SORT_DATA.
  PERFORM DISPLAY.



*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FETCH_DATA .
*  SELECT A~VBELN,
*       A~POSNR,
*       A~MATNR,
*       B~LFSTA,
*       B~LFGSA,
*       B~FKSTA,
*       B~ABSTA,
*       B~GBSTA
*INTO TABLE @IT_DATA
*FROM  VBAP AS A
*LEFT OUTER JOIN  VBUP AS B ON ( B~VBELN = A~VBELN  AND B~POSNR = A~POSNR )
**    JOIN  vbak AS C ON a~vbeln = c~vbeln
*WHERE  A~VBELN  IN @S_VBELN         "SHREYAS
*AND   B~LFSTA  NE 'C'
*AND   B~LFGSA  NE 'C'
*AND   B~FKSTA  NE 'C'
*AND   B~GBSTA  NE 'C'.
**    AND   A~WERKS  = 'PLO1'.


  SELECT VBELN,
         POSNR,
         MATNR
    FROM VBAP
    INTO TABLE @DATA(IT_VBAP1)
    WHERE VBELN  IN @S_VBELN .

  IF IT_VBAP1 IS NOT INITIAL .
   SELECT VBELN,
          POSNR,
          LFSTA,
          LFGSA,
         FKSTA,
         ABSTA,
         GBSTA
     from vbup
     into TABLE @data(it_vbup)
     FOR ALL ENTRIES IN @IT_VBAP1
     where vbeln = @IT_VBAP1-VBELN
     AND   LFSTA  Eq 'C'
    AND    LFGSA  Eq 'C'
   AND    FKSTA  Eq 'C'
   AND    GBSTA  Eq 'C'.
  ENDIF.

LOOP AT it_vbup  INTO data(wa_vbup).

  READ TABLE it_vbap1 into data(wa_vbap) with key VBELN = WA_VBuP-VBELN
                                                  posnr  = wa_vbup-POSNR.

  IF sy-subrc = 0.
  delete it_vbap1 where vbeln = WA_VBuP-VBELN .

  REFRESH IT_DATA.

  it_data = IT_VBAP1.

  ENDIF.




ENDLOOP.

IF sy-subrc = 4.
  it_data = IT_VBAP1.
ENDIF.







*******ADDED BY SNEHAL RAJALE ON 29 JAN 201************
  LOOP AT IT_DATA INTO LS_DATA.
    IF LS_DATA-ABSTA = 'C'.
      IF LS_DATA-LFSTA = ' ' AND LS_DATA-LFGSA = ' ' AND LS_DATA-FKSTA = ' ' AND LS_DATA-GBSTA = ' '.
        IF SY-SUBRC = 0.
*            delete it_data[] from ls_data.
          DELETE IT_DATA[]  WHERE VBELN = LS_DATA-VBELN AND POSNR = LS_DATA-POSNR.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF IT_DATA[] IS NOT INITIAL.
    SELECT VBELN
           ERDAT
           AUART
           LIFSK
           WAERK
           VKBUR
           KNUMV
           VDATU
           BSTDK
           KUNNR
           OBJNR
           ZLDFROMDATE
           ZLDPERWEEK
           ZLDMAX
*             faksk
           FROM VBAK INTO TABLE IT_VBAK
           FOR ALL ENTRIES IN IT_DATA WHERE VBELN = IT_DATA-VBELN.

    SELECT VBELN
                POSNR
                MATNR
                ARKTX
                ABGRU
                POSEX
                KDMAT
                WAERK
                KWMENG
                WERKS
                NTGEW                  "added by pankaj 28.01.2022
                OBJNR
                HOLDDATE
                HOLDRELDATE
                CANCELDATE
                DELDATE
                CUSTDELDATE
                ZGAD
                CTBG
                RECEIPT_DATE            "added by pankaj 28.01.2022
                REASON                   "added by pankaj 28.01.2022
                OFM_DATE               "added by pankaj 01.02.2022
                ERDAT
                FROM VBAP INTO TABLE IT_VBAP
                FOR ALL ENTRIES IN IT_DATA WHERE VBELN = IT_DATA-VBELN
                                            AND POSNR = IT_DATA-POSNR
                                            AND WERKS = 'PL01'.


*    IF IT_VBAP IS NOT INITIAL.
*      LOOP AT IT_VBAP INTO WA_VBAP.
*        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*          EXPORTING
*            INPUT  = WA_VBAP-VBELN
*          IMPORTING
*            OUTPUT = LV_VBELN.
*
*        MOVE-CORRESPONDING WA_VBAP TO WA_VBAP2.
*        WA_VBAP2-VBELN = LV_VBELN.
*        APPEND WA_VBAP2 TO IT_VBAP2.
*
*      ENDLOOP.
*
**      CLEAR: lv_vbeln, wa_vbap, wa_vbap2.
*    ENDIF.
*
*    LOOP AT IT_VBAP2 INTO WA_VBAP2.
*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*        EXPORTING
*          INPUT  = WA_VBAP2-VBELN
*        IMPORTING
*          OUTPUT = LV_VBELN2.
*
*      WA_VBAP2-VBELN = LV_VBELN2.
*      MODIFY IT_VBAP2 FROM WA_VBAP2.
*    ENDLOOP.
*
*    SELECT VBELN
*               POSNR
*               ETENR
*               ETTYP
*               EDATU
*               FROM VBEP INTO TABLE IT_VBEP
*               FOR ALL ENTRIES IN IT_VBAP WHERE VBELN = IT_VBAP-VBELN
*                                           AND  POSNR = IT_VBAP-POSNR.

*    SORT IT_VBEP BY VBELN POSNR ETENR.
    SELECT VBELN
             POSNR
             ETENR
             ETTYP
             EDATU
             FROM VBEP INTO TABLE LT_VBEP
             FOR ALL ENTRIES IN IT_VBAP WHERE VBELN = IT_VBAP-VBELN
                                         AND  POSNR = IT_VBAP-POSNR
                                         AND  ETENR = '0001'
                                         AND  ETTYP = 'CP'.

    SORT LT_VBEP BY VBELN POSNR ETENR.


    IF LT_VBEP IS NOT INITIAL.
      SELECT * FROM CDPOS INTO TABLE IT_CDPOS WHERE  TABNAME = 'VBEP' AND VALUE_NEW = 'CP'.
*                                           AND OBJECTID = LT_VBEP-VBELN.

      SELECT * FROM CDHDR INTO TABLE IT_CDHDR WHERE OBJECTCLAS = 'VERKBELEG'
       AND ( TCODE = 'VA02' OR TCODE = 'ZUNLOCKMRP').

      DATA VARTABKEY TYPE CDPOS-TABKEY.

      LOOP AT LT_VBEP INTO WA_VBEP.
        WA_VBEPTABKEY-VBELN = WA_VBEP-VBELN.
        WA_VBEPTABKEY-POSNR = WA_VBEP-POSNR.
        WA_VBEPTABKEY-ETENR = WA_VBEP-ETENR.
        WA_VBEPTABKEY-ETTYP = WA_VBEP-ETTYP.
        WA_VBEPTABKEY-EDATU = WA_VBEP-EDATU.
        CONCATENATE SY-MANDT WA_VBEP-VBELN WA_VBEP-POSNR WA_VBEP-ETENR INTO VARTABKEY.
        WA_VBEPTABKEY-VTABKEY = VARTABKEY.
        APPEND WA_VBEPTABKEY TO IT_VBEPTABKEY.
      ENDLOOP.
*        SORT IT_CDPOS BY TABKEY.
*        SORT IT_VBEPTABKEY BY VTABKEY.

*         SELECT * FROM CDPOS INTO TABLE IT_CDPOS WHERE TABKEY = WA_VBEPTABKEY-VTABKEY AND TABNAME = 'VBEP' AND VALUE_NEW = 'CP'.

DATA: LEN TYPE I.
      LOOP AT IT_CDPOS INTO WA_CDPOS.
        LOOP AT IT_VBEPTABKEY INTO WA_VBEPTABKEY.
          IF   WA_VBEPTABKEY-VTABKEY = WA_CDPOS-TABKEY .
            WA_CDPOSTABKEY-MANDANT = WA_CDPOS-MANDANT.
            WA_CDPOSTABKEY-OBJECTCLAS = WA_CDPOS-OBJECTCLAS.
*            WA_CDPOSTABKEY-OBJECTID = WA_CDPOS-OBJECTID.
            LEN = STRLEN( WA_CDPOS-OBJECTID ).
            IF LEN = 8.
             CONCATENATE '00' WA_CDPOS-OBJECTID INTO WA_CDPOSTABKEY-OBJECTID.
             ELSE.
            WA_CDPOSTABKEY-OBJECTID = WA_CDPOS-OBJECTID.
            ENDIF.
            CLEAR LEN.
            WA_CDPOSTABKEY-CHANGENR = WA_CDPOS-CHANGENR.
            WA_CDPOSTABKEY-TABNAME = WA_CDPOS-TABNAME.
            WA_CDPOSTABKEY-TABKEY = WA_CDPOS-TABKEY.
            WA_CDPOSTABKEY-FNAME = WA_CDPOS-FNAME.
            WA_CDPOSTABKEY-CHNGIND = WA_CDPOS-CHNGIND.
            WA_CDPOSTABKEY-TEXT_CASE = WA_CDPOS-TEXT_CASE.
            WA_CDPOSTABKEY-VALUE_NEW = WA_CDPOS-VALUE_NEW.
            WA_CDPOSTABKEY-VALUE_OLD = WA_CDPOS-VALUE_OLD.
*               WA_CDPOSTABKEY-TCODE = WA_CDPOS-TCODE.
            APPEND WA_CDPOSTABKEY TO IT_CDPOSTABKEY.
            CLEAR WA_CDPOSTABKEY.
          ENDIF.
        ENDLOOP.
      ENDLOOP.



DATA: LEN1 TYPE I.
      LOOP AT IT_CDHDR INTO WA_CDHDR.

             WA_CDHDROBJID-OBJECTCLAS = WA_CDHDR-OBJECTCLAS.
*            WA_CDPOSTABKEY-OBJECTID = WA_CDPOS-OBJECTID.
            LEN1 = STRLEN( WA_CDHDR-OBJECTID ).
            IF LEN1 = 8.
             CONCATENATE '00' WA_CDHDR-OBJECTID INTO WA_CDHDROBJID-OBJECTID.
             ELSE.
            WA_CDHDROBJID-OBJECTID = WA_CDHDR-OBJECTID.
            ENDIF.
            CLEAR LEN1.
            WA_CDHDROBJID-CHANGENR = WA_CDHDR-CHANGENR.
            WA_CDHDROBJID-UDATE = WA_CDHDR-UDATE.

              WA_CDHDROBJID-TCODE = WA_CDHDR-TCODE.
            APPEND WA_CDHDROBJID TO IT_CDHDROBJID.
            CLEAR WA_CDHDROBJID.
      ENDLOOP.


*      LOOP AT IT_CDPOS INTO WA_CDPOS.
*        LOOP AT IT_VBEPTABKEY1 INTO WA_VBEPTABKEY1.
*
*          WA_CDPOSTABKEY-MANDANT = WA_CDPOS-MANDANT.
*          WA_CDPOSTABKEY-OBJECTCLAS = WA_CDPOS-OBJECTCLAS.
*          WA_CDPOSTABKEY-OBJECTID = WA_CDPOS-OBJECTID.
*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*            EXPORTING
*              INPUT  = WA_CDPOSTABKEY-OBJECTID
*            IMPORTING
*              OUTPUT = WA_CDPOSTABKEY-OBJECTID.
*
*          WA_CDPOSTABKEY-CHANGENR = WA_CDPOS-CHANGENR.
*          WA_CDPOSTABKEY-TABNAME = WA_CDPOS-TABNAME.
*          WA_CDPOSTABKEY-TABKEY = WA_CDPOS-TABKEY.
*          WA_CDPOSTABKEY-FNAME = WA_CDPOS-FNAME.
*          WA_CDPOSTABKEY-CHNGIND = WA_CDPOS-CHNGIND.
*          WA_CDPOSTABKEY-TEXT_CASE = WA_CDPOS-TEXT_CASE.
*          WA_CDPOSTABKEY-VALUE_NEW = WA_CDPOS-VALUE_NEW.
*          WA_CDPOSTABKEY-VALUE_OLD = WA_CDPOS-VALUE_OLD.
*          APPEND WA_CDPOSTABKEY1 TO IT_CDPOSTABKEY1.
*          CLEAR WA_CDPOSTABKEY1.
**          ENDIF.
*        ENDLOOP.
*      ENDLOOP.

* LOOP AT IT_CDHDROBJID INTO WA_CDHDROBJID WHERE OBJECTCLAS = 'VERKBELEG'.
*    LOOP AT IT_CDPOSTABKEY INTO WA_CDPOSTABKEY WHERE OBJECTID = WA_CDHDROBJID-OBJECTID AND CHANGENR = WA_CDHDROBJID-CHANGENR.
*             WA_CDHDROBJID-OBJECTCLAS = WA_CDPOSTABKEY-OBJECTCLAS.
*            WA_CDHDROBJID-OBJECTID = WA_CDPOSTABKEY-OBJECTID.
*
*            WA_CDHDROBJID-CHANGENR = WA_CDPOSTABKEY-CHANGENR.
*            WA_CDHDROBJID-UDATE = WA_CDHDROBJID-UDATE.
*
*              WA_CDHDROBJID-TCODE = WA_CDHDROBJID-TCODE.
*            APPEND WA_CDHDROBJID TO IT_CDHDROBJID.
*            CLEAR WA_CDHDROBJID.
*      ENDLOOP.
*    ENDLOOP.


      SELECT  OBJECTCLAS OBJECTID CHANGENR UDATE TCODE FROM CDHDR INTO CORRESPONDING FIELDS OF TABLE IT_CDHDR
   FOR ALL ENTRIES IN IT_CDPOSTABKEY
   WHERE OBJECTCLAS = 'VERKBELEG'
   AND OBJECTID = IT_CDPOSTABKEY-OBJECTID            "it_vbap-vbeln
   AND CHANGENR = IT_CDPOSTABKEY-CHANGENR             "it_vbap-vbeln
    AND ( TCODE = 'VA02' OR TCODE = 'ZUNLOCKMRP')
        .

*      SELECT  OBJECTCLAS OBJECTID CHANGENR UDATE TCODE FROM CDHDR INTO CORRESPONDING FIELDS OF TABLE IT_CDHDR
*  FOR ALL ENTRIES IN IT_CDPOSTABKEY1
*  WHERE  OBJECTID = IT_CDPOSTABKEY1-OBJECTID
*   AND CHANGENR = IT_CDPOSTABKEY1-CHANGENR             "it_vbap-vbeln
*    AND TCODE = 'VA02'.       .           "it_vbap-vbeln

    ENDIF.

    SORT IT_CDHDROBJID BY UDATE ASCENDING.
    CLEAR WA_VBEPTABKEY.

    PERFORM GET_DATA.

    PERFORM SORT_DATA.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
*  LOOP AT IT_VBAP INTO WA_VBAP.
  DATA:
    LV_RATIO TYPE RESB-ENMNG,
    LV_QTY   TYPE RESB-ENMNG,
    LV_INDEX TYPE SY-TABIX.

*  IF IT_VBAP[] IS NOT INITIAL.
  CLEAR: WA_VBAP.
  SORT IT_VBAP BY VBELN POSNR MATNR WERKS.

*  LOOP AT LT_VBEP INTO LS_VBEP.


  LOOP AT IT_VBEPTABKEY INTO WA_VBEPTABKEY  .

    WA_OUTPUT-VBELN = WA_VBEPTABKEY-VBELN.

*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*        EXPORTING
*          INPUT  = WA_OUTPUT-VBELN
*        IMPORTING
*          OUTPUT = WA_OUTPUT-VBELN.

    WA_OUTPUT-POSNR = WA_VBEPTABKEY-POSNR.


*      SORT IT_CDPOS BY CHANGENR ASCENDING.
*      READ TABLE IT_CDPOS INTO WA_CDPOS WITH KEY OBJECTID =  LS_VBEP-VBELN  VALUE_NEW = 'CP'  .
*      IF  SY-SUBRC = 0.

    SORT IT_CDPOSTABKEY BY CHANGENR ASCENDING.
    READ TABLE IT_CDPOSTABKEY INTO WA_CDPOSTABKEY WITH KEY OBJECTID =  WA_VBEPTABKEY-VBELN  VALUE_NEW = 'CP'  TABKEY = WA_VBEPTABKEY-VTABKEY.
    IF  SY-SUBRC = 0.



*    READ TABLE IT_CDHDR INTO WA_CDHDR WITH  KEY  OBJECTID = WA_CDPOSTABKEY-OBJECTID  CHANGENR = WA_CDPOSTABKEY-CHANGENR   TCODE = 'VA02'.

    READ TABLE IT_CDHDROBJID INTO WA_CDHDROBJID WITH  KEY  OBJECTID = WA_CDPOSTABKEY-OBJECTID  CHANGENR = WA_CDPOSTABKEY-CHANGENR   TCODE = 'ZUNLOCKMRP' .
    IF  SY-SUBRC = 0.
*      WA_OUTPUT-MRP_DT      = WA_CDHDR-UDATE.
      WA_OUTPUT-MRP_DT      = WA_CDHDROBJID-UDATE.
    ENDIF.

    READ TABLE IT_CDHDROBJID INTO WA_CDHDROBJID WITH  KEY  OBJECTID = WA_CDPOSTABKEY-OBJECTID  CHANGENR = WA_CDPOSTABKEY-CHANGENR   TCODE = 'VA02' .
    IF  SY-SUBRC = 0.
*      WA_OUTPUT-MRP_DT      = WA_CDHDR-UDATE.
      WA_OUTPUT-MRP_DT      = WA_CDHDROBJID-UDATE.
    ENDIF.
    ENDIF.
    CLEAR WA_CDHDROBJID.

*    READ TABLE IT_CDPOSTABKEY1 INTO WA_CDPOSTABKEY1 WITH KEY OBJECTID =  WA_VBEPTABKEY-VBELN  VALUE_NEW = 'CP'  TABKEY = WA_VBEPTABKEY-VTABKEY.
*    IF  SY-SUBRC = 0.
*
*    ENDIF.
**    ENDIF.
**    READ TABLE IT_CDHDR INTO WA_CDHDR WITH  KEY  OBJECTID = WA_CDPOSTABKEY1-OBJECTID  CHANGENR = WA_CDPOSTABKEY1-CHANGENR   TCODE = 'VA02'.
*     READ TABLE IT_CDHDROBJID INTO WA_CDHDROBJID WITH  KEY  OBJECTID = WA_CDPOSTABKEY1-OBJECTID  CHANGENR = WA_CDPOSTABKEY1-CHANGENR   TCODE = 'VA02'.
*
*    IF  SY-SUBRC = 0.
*      WA_OUTPUT-MRP_DT      = WA_CDHDR-UDATE.
*
*
*    ENDIF.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_OUTPUT-MRP_DT
      IMPORTING
        OUTPUT = WA_OUTPUT-MRP_DT.

    CONCATENATE WA_OUTPUT-MRP_DT+0(2) WA_OUTPUT-MRP_DT+2(3) WA_OUTPUT-MRP_DT+5(4)
                    INTO WA_OUTPUT-MRP_DT SEPARATED BY '-'.

    IF WA_OUTPUT-MRP_DT = '--'.
      REPLACE ALL OCCURRENCES OF '--' IN WA_OUTPUT-MRP_DT WITH ' '.
    ENDIF.

    APPEND WA_OUTPUT TO IT_OUTPUT.

    CLEAR: WA_OUTPUT.
  ENDLOOP.
*    ENDLOOP.
  CLEAR :WA_CDPOS,LS_VBEP,WA_VBEPTABKEY,WA_CDPOSTABKEY1,WA_CDPOSTABKEY.
*  ENDIF.

  DELETE ADJACENT DUPLICATES FROM IT_OUTPUT COMPARING VBELN POSNR.
****************added By Nilay on 16.01.2023
  LOOP AT IT_OUTPUT INTO WA_OUTPUT.
     READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_OUTPUT-VBELN POSNR = WA_OUTPUT-POSNR.
    IF WA_OUTPUT-MRP_DT IS INITIAL.

      WA_OUTPUT-MRP_DT  = WA_VBAP-ERDAT.

       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_OUTPUT-MRP_DT
      IMPORTING
        OUTPUT = WA_OUTPUT-MRP_DT.
       CONCATENATE WA_OUTPUT-MRP_DT+0(2) WA_OUTPUT-MRP_DT+2(3) WA_OUTPUT-MRP_DT+5(4)
                    INTO WA_OUTPUT-MRP_DT SEPARATED BY '-'.

    IF WA_OUTPUT-MRP_DT = '--'.
      REPLACE ALL OCCURRENCES OF '--' IN WA_OUTPUT-MRP_DT WITH ' '.
    ENDIF.

    MODIFY  IT_OUTPUT FROM WA_OUTPUT TRANSPORTING MRP_DT.

    ENDIF.

  ENDLOOP.
**********Ended By Nilay B. on 16.01.2024****************
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SORT_DATA .
*  PERFORM STP3_EVENTTAB_BUILD   CHANGING GT_EVENTS[].
*  PERFORM COMMENT_BUILD         CHANGING I_LIST_TOP_OF_PAGE[].
*  PERFORM TOP_OF_PAGE.
*  PERFORM LAYOUT_BUILD          CHANGING WA_LAYOUT.

  PERFORM FCAT USING : '1'     'VBELN'     'IT_OUTPUT'  'Sales Order No'                  '18' .
  PERFORM FCAT USING : '2'    'POSNR'       'IT_OUTPUT'  'Sales Line Item'                  '18' .
  PERFORM FCAT USING : '3'    'MRP_DT'       'IT_OUTPUT'  'MRP Date'                         '18' .
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0374   text
*      -->P_0375   text
*      -->P_0376   text
*      -->P_0377   text
*      -->P_0378   text
*----------------------------------------------------------------------*
FORM FCAT  USING VALUE(P1)
      VALUE(P2)
      VALUE(P3)
      VALUE(P4)
      VALUE(P5).

  IS_FCAT-COL_POS   = P1.
  IS_FCAT-FIELDNAME = P2.
  IS_FCAT-TABNAME   = P3.
  IS_FCAT-SELTEXT_L = P4.
  IS_FCAT-OUTPUTLEN = P5.

  APPEND IS_FCAT TO IT_FCAT.
  CLEAR IS_FCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY .

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
      IT_FIELDCAT        = IT_FCAT[]
    TABLES
      T_OUTTAB           = IT_OUTPUT[].
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
  IF P_DOWN = 'X'.

    PERFORM DOWNLOAD.
    PERFORM DOWNLOAD_FILE.
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

*  IT_FINAL = IT_OUTPUT.
  LOOP AT IT_OUTPUT INTO WA_OUTPUT.
    WA_DOWN-VBELN   = WA_OUTPUT-VBELN.
    WA_DOWN-POSNR   = WA_OUTPUT-POSNR.
    WA_DOWN-MRP_DT  = WA_OUTPUT-MRP_DT.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = WA_DOWN-REF_DATE.
    CONCATENATE WA_DOWN-REF_DATE+0(2) WA_DOWN-REF_DATE+2(3) WA_DOWN-REF_DATE+5(4)
    INTO WA_DOWN-REF_DATE SEPARATED BY '-'.

    WA_DOWN-REF_TIME = SY-UZEIT.
    CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.


    APPEND WA_DOWN TO IT_DOWN.
    CLEAR WA_DOWN.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD_FILE .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.


  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

*BREAK-POINT.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
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
  LV_FILE = 'ZSO_MRPDATE.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
  INTO LV_FULLFILE.
* BREAK primus.
  WRITE: / 'ZSO MRP DATE Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_802 TYPE string.
DATA lv_crlf_802 TYPE string.
lv_crlf_802 = cl_abap_char_utilities=>cr_lf.
lv_string_802 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_802 lv_crlf_802 wa_csv INTO lv_string_802.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_802 TO lv_fullfile.
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
FORM CVS_HEADER  USING    P_HD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Sales Order No'
              'Sales Line Item'
              'MRP Date'
              'Refresh Date'
              'Refresh Time'
              INTO P_HD_CSV
 SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_LIST_TOP_OF_PAGE[]  text
*----------------------------------------------------------------------*
FORM COMMENT_BUILD  CHANGING P_I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER..

  DATA: LF_LINE       TYPE SLIS_LISTHEADER. "WORK AREA
*--LIST HEADING -  TYPE H
  CLEAR LF_LINE.


  LF_LINE-TYP  = C_H.
  LF_LINE-INFO =  ''(042).
  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.
*--HEAD INFO: TYPE S
  CLEAR LF_LINE.
  LF_LINE-TYP  = C_S.
  LF_LINE-KEY  = TEXT-043.
  LF_LINE-INFO = SY-DATUM.
  WRITE SY-DATUM TO LF_LINE-INFO USING EDIT MASK '__.__.____'.
  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM LAYOUT_BUILD  CHANGING P_WA_LAYOUT TYPE SLIS_LAYOUT_ALV.
  WA_LAYOUT-ZEBRA          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
  P_WA_LAYOUT-ZEBRA          = 'X'.
  P_WA_LAYOUT-NO_COLHEAD        = ' '.
*  WA_LAYOUT-BOX_FIELDNAME     = 'BOX'.
*  WA_LAYOUT-BOX_TABNAME       = 'IT_FINAL_ALV'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_EVENTS[]  text
*----------------------------------------------------------------------*
FORM STP3_EVENTTAB_BUILD  CHANGING P_GT_EVENTS TYPE SLIS_T_EVENT.
  DATA: LF_EVENT TYPE SLIS_ALV_EVENT. "WORK AREA

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      I_LIST_TYPE     = 0
    IMPORTING
      ET_EVENTS       = P_GT_EVENTS
    EXCEPTIONS
      LIST_TYPE_WRONG = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  MOVE C_FORMNAME_TOP_OF_PAGE TO LF_EVENT-FORM.
  MODIFY P_GT_EVENTS  FROM  LF_EVENT INDEX 3 TRANSPORTING FORM."TO P_I_EVENTS .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM TOP_OF_PAGE .
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = I_LIST_TOP_OF_PAGE[]. "INTERNAL TABLE WITH
ENDFORM.
