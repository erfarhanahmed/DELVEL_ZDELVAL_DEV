*&---------------------------------------------------------------------*
*& REPORT  ZSD_SALESORDER_DRVR
*&
*&---------------------------------------------------------------------*

REPORT  ZSD_SALESORDER_DRVR.


*        V_SALESORDER TYPE THEAD-TDNAME, "VBELN,
*        V_SO_ITEM TYPE THEAD-TDNAME."POSNR
TYPES: BEGIN OF ITAB,
          VBELN         TYPE VBAK-VBELN,
          KUNNR         TYPE VBAK-KUNNR,
          J_1IMOEXRN    TYPE J_1IMOCUST-J_1IEXRN,
          J_1ICSTNO     TYPE J_1IMOCUST-J_1ICSTNO,
          J_1ILSTNO     TYPE J_1IMOCUST-J_1ILSTNO,
          AEDAT         TYPE J_1IMOCUST-AEDAT,
        END OF ITAB.

DATA: ITAB TYPE STANDARD TABLE OF ITAB,
      WA_ITAB TYPE ITAB.

PARAMETERS : P_VBELN TYPE VBAK-VBELN.
  BREAK SANSARI.

*&---------------------------------------------------------------------*
*&      FORM  GET_ORDACCP_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->IN_TAB     TEXT
*      -->OUT_TAB    TEXT
*----------------------------------------------------------------------*
FORM GET_ORDACCP_DATA TABLES IN_TAB STRUCTURE ITCSY
                            OUT_TAB STRUCTURE ITCSY  .

  DATA: V_HTEXT TYPE  THEAD-TDNAME,
         V_DID TYPE THEAD-TDID,"STRING ,

         WA_STXH TYPE STXH,

         IT_LINE_HEADER TYPE STANDARD TABLE OF TLINE,
         WA_LINE_HEADER TYPE TLINE,

         IT_LINE_ITEM TYPE STANDARD TABLE OF TLINE,
         WA_LINE_ITEM TYPE TLINE.

*****READING DATA FROM J_1IMOCUST FOR EXCISE DETAILS.
  SELECT  VBELN
          KUNNR
    FROM  VBAK
    INTO CORRESPONDING FIELDS OF TABLE ITAB
    WHERE VBELN = P_VBELN.

  IF SY-SUBRC = 0.
*    SELECT  KUNNR
*            J_1IEXRN
*            J_1ICSTNO
*            J_1ILSTNO
*            AEDAT
*      FROM  J_1IMOCUST
*      INTO CORRESPONDING FIELDS OF TABLE ITAB
*      WHERE vbeln = WA_ITAB-vbeln .
  ENDIF.
*****READING TEXT AT HEADER LEVEL.
  SELECT SINGLE * FROM STXH CLIENT SPECIFIED INTO WA_STXH
     WHERE MANDT    = SY-MANDT
       AND TDOBJECT = 'VBBK'
       AND TDNAME   =  V_HTEXT
       AND TDID     =  V_DID
       AND TDSPRAS  = 'E'.
  IF SY-SUBRC = 0.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        ID       = V_DID
        LANGUAGE = 'E'
        NAME     = V_HTEXT
        OBJECT   = 'VBBK'
      TABLES
        LINES    = IT_LINE_HEADER.
    .
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
  ENDIF.

****READING DATA FROM IN_TAB
  READ TABLE IN_TAB INDEX 1 .
  OUT_TAB-VALUE = IN_TAB-VALUE.
  MODIFY OUT_TAB INDEX 1.

ENDFORM.                    "GET_ORDACCP_DATA


















































******
******TYPES: BEGIN OF TY_VBAK,
******          KUNNR TYPE VBAK-KUNNR,  "CUSTOMER
******          "KUNAG TYPE VBAK-KUNAG,  "CONSIGNEE
******          "POSNR TYPE VBAK-POSNR,  "ITEM
******          VBELN TYPE VBAK-VBELN,  "DELVAL ORDER ACCEPTANCE REFERENCE
******          AUDAT TYPE VBAK-AUDAT,  "DATE
******          BSTKD TYPE VBKD-BSTKD,  "CUSTOMER  P.O .REF .N.O
******          BSTDK TYPE VBKD-BSTDK,  "DATE
******          NETWR TYPE VBAK-NETWR,  " BASIC AMOUNT
******          KWERT TYPE VBAK-KNUMV,  "P&F  CHARGES
******      END OF TY_VBAK,
******
******      BEGIN OF TY_VBAP,
******          POSNR TYPE VBAP-POSNR,  ".ITEM NO
******          ARKTX TYPE VBAP-ARKTX,  "ITEM DESCRIPTION
******          VRKME TYPE VBAP-VRKME,  "UNIT
******          KWMENG TYPE VBAP-KWMENG,"QUANTITY
******        END OF TY_VBAP,
******
******      BEGIN OF TY_VBKD,
******          VBELN TYPE VBKD-VBELN,
******          POSNR TYPE VBKD-POSNR,
******          BSTKD TYPE VBKD-BSTKD, "CUSTOMER PURCHASE ORDER NUMBER
******          BSTDK TYPE VBKD-BSTDK, " CUSTOMER PURCHASE ORDER DATE
******        END OF TY_VBKD,
******
******     BEGIN OF TY_ORD_ACCP,
******       CUSTOMER TYPE VBAK-KUNNR,
******       SO_NO TYPE VBAK-VBELN,
******       ITEM_NO TYPE  VBAP-POSNR,
******       SHORT_TEXT TYPE VBAP-ARKTX,
******       UOM TYPE VBAP-VRKME,
******       DOC_DATE TYPE VBAK-AUDAT,
******       PO_REF TYPE VBKD-BSTKD,
******       PO_DATE TYPE VBKD-BSTDK,
******       NET_VALUE TYPE VBAK-NETWR,
******       QUANTITY TYPE VBAP-KWMENG,
******     END OF TY_ORD_ACCP.
******
******  DATA: IT_ORDACCP TYPE STANDARD TABLE OF TY_ORD_ACCP,
******        WA_ORDACCP TYPE TY_ORD_ACCP.
******
******
******     DATA: IT_VBAK TYPE STANDARD TABLE OF TY_VBAK,
******      WA_VBAK TYPE TY_VBAK,
******
******      IT_VBAP TYPE STANDARD TABLE OF TY_VBAP,
******      WA_VBAP TYPE TY_VBAP,
******
******      IT_VBKD TYPE STANDARD TABLE OF TY_VBKD,
******      WA_VBKD TYPE TY_VBKD,
******
******      V_SO TYPE VBELN,
******
******
******
********SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
********      PARAMETERS: P_VBELN TYPE VBAK-VBELN." MODIF ID PLT ."MEMORY ID MAT.
********SELECTION-SCREEN END OF BLOCK B1.
******
**********READING ORDER NUMBER FROM IN_TAB
******  READ TABLE IN_TAB INDEX 1 .
******  V_SO = IN_TAB-VALUE.
******
******SELECT VBELN
******              POSNR
******              ARKTX
******              MEINS
******              KWMENG
******              FROM  VBAP
******              INTO CORRESPONDING FIELDS OF TABLE IT_VBAP
******              "FOR ALL ENTRIES IN IT_VBAK
******              WHERE VBELN =  V_SO
******              AND   POSNR =  IT_VBAP-POSNR.
******    IF SY-SUBRC EQ 0.
******      SORT IT_VBAP BY VBELN POSNR.
******    ENDIF.
******
******IF NOT I_VBAP[] IS INITIAL.
******
******        SELECT KUNNR
******               VBELN
******               AUDAT
******               NETWR
******               KNUMV
******          FROM  VBAK
******          INTO CORRESPONDING FIELDS OF TABLE IT_VBAK
******          FOR ALL ENTRIES IN IT_VBAP
******          WHERE VBELN = IT_VBAP-VBELN.
******
******IF SY-SUBRC EQ 0.
******    SORT IT_VBAK BY VBELN.
******  ENDIF.
******
******        SELECT VBELN
******               POSNR
******               BSTKD
******               BSTDK
******         FROM VBKD
******         INTO CORRESPONDING FIELDS OF TABLE IT_VBKD
******         FOR ALL ENTRIES IN IT_VBAP
******         WHERE  VBELN     =  IT_VBAP-VBELN
******         AND    POSNR     =  IT_VBAP-POSNR.
******    IF SY-SUBRC EQ 0.
******      SORT IT_VBKD BY VBELN POSNR.
******    ENDIF.
******
******
******
******
******
******
******
******
******  IF SY-SUBRC EQ 0.
******    SORT IT_VBAK BY VBELN.
******  ENDIF.
******
******  IF NOT IT_VBAP[] IS INITIAL.
******
******           SELECT VBELN
******                  POSNR
******                  BSTKD
******                  BSTDK
******              FROM  VBKD
******              INTO CORRESPONDING FIELDS OF TABLE IT_VBKD
******              FOR ALL ENTRIES IN IT_VBAK
******              WHERE VBELN =  IT_VBAK-VBELN
******              AND    POSNR = IT_VBAP-POSNR.
******    IF SY-SUBRC EQ 0.
******      SORT IT_VBKD BY VBELN POSNR.
******    ENDIF.
******
******
******
*********
*********  BEGIN OF TY_ORD_ACCP,
*********       CUSTOMER TYPE VBAK-KUNNR,
*********       SO_NO TYPE VBAK-VBELN,
*********       ITEM_NO TYPE  VBAP-POSNR,
*********       SHORT_TEXT TYPE VBAP-ARKTX,
*********       UOM TYPE VBAP-VRKME,
*********       DOC_DATE TYPE VBAK-AUDAT,
*********       PO_REF TYPE VBKD-BSTKD,
*********       PO_DATE TYPE VBKD-BSTDK,
*********       NET_VALUE TYPE VBAK-NETWR,
*********       QUANTITY TYPE VBAP-KWMENG,
*********     END OF TY_ORD_ACCP.
******
******  LOOP AT IT_VBAP INTO WA_VBAP.
******
******    WA_ORDACCP-ITEM_NO = WA_VBAP-POSNR.
******    WA_ORDACCP-SHORT_TEXT = WA_VBAP-ARKTX.
******    WA_ORDACCP-UOM = WA_VBAP-MEIN.
******    WA_ORDACCP-QUANTITY = WA_VBAP-KWMENG
******  ENDLOOP.
******
******  LOOP AT IT_VBAK INTO WA_VBAK.
******    WA_ORDACCP-CUSTOMER = WA_VBAK-KUNNR.
******    WA_ORDACCP-SO_NO = WA_VBAK-VBELN.
******    WA_ORDACCP-DOC_DATE = WA_VBAK-AUDAT.
******    WA_ORDACCP-NET_VALUE = WA_VBAK-NETWR.
******  ENDLOOP.
******
******  LOOP AT IT_VBKD INTO WA_VBKD.
******    WA_ORDACCP-PO_REF = WA_VBKD-BSTKD.
******    WA_ORDACCP-PO_DATE = WA_VBKD-BSTDK.
******  ENDLOOP.
