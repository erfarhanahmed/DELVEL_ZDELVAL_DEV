*&---------------------8------------------------------------------------*
*& Report ZPO_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGRN_LIST_NEW.

TYPE-POOLS: SLIS.

TABLES : EKKO,EKPO,LFA1,ADRC,EKBE,EKKN,VBAK,MARA,MSEG.

DATA: LV_LINES TYPE STANDARD TABLE OF TLINE,
      WA_LINES LIKE TLINE,
      LS_LINES LIKE TLINE,
      LV_NAME  TYPE THEAD-TDNAME.

TYPES : BEGIN OF TY_MSEG,
          MBLNR      TYPE MSEG-MBLNR,
          MJAHR      TYPE MSEG-MJAHR,
          ZEILE      TYPE MSEG-ZEILE,
          BWART      TYPE MSEG-BWART,
          WERKS      TYPE MSEG-WERKS,
          SOBKZ      TYPE MSEG-SOBKZ,
          MENGE      TYPE MSEG-MENGE,
          EBELN      TYPE MSEG-EBELN,
          EBELP      TYPE MSEG-EBELP,
          SMBLN      TYPE MSEG-SMBLN,
          SMBLP      TYPE MSEG-SMBLP,
          BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
        END OF TY_MSEG,

        BEGIN OF TY_VBAK,
          VBELN TYPE VBAK-VBELN,
          KUNNR TYPE VBAK-KUNNR,
          ERDAT TYPE VBAK-ERDAT, "changes by shreya
        END OF TY_VBAK,

        BEGIN OF TY_KNA1,
          KUNNR TYPE   KNA1-KUNNR,
          NAME1 TYPE KNA1-NAME1,
        END OF TY_KNA1,

        BEGIN OF TY_KNMT,
          KUNNR TYPE KNMT-KUNNR,
          KDMAT TYPE KNMT-KDMAT,
        END OF TY_KNMT,

        BEGIN OF TY_EKPO,
          EBELN TYPE EKPO-EBELN,
          EBELP TYPE EKPO-EBELP,
          LOEKZ TYPE EKPO-LOEKZ,
          TXZ01 TYPE EKPO-TXZ01,
          MATNR TYPE EKPO-MATNR,
          WERKS TYPE EKPO-WERKS,
          MENGE TYPE EKPO-MENGE,
          ELIKZ TYPE EKPO-ELIKZ,
          KNTTP TYPE EKPO-KNTTP,
        END OF TY_EKPO,

        BEGIN OF TY_EKKO,
          EBELN TYPE EKKO-EBELN,
          AEDAT TYPE EKKO-AEDAT,
          LIFNR TYPE EKKO-LIFNR,
          EKGRP TYPE EKKO-EKGRP,
        END OF TY_EKKO,

        BEGIN OF TY_LFA1,
          LIFNR TYPE LFA1-LIFNR,
          ADRNR TYPE LFA1-ADRNR,
        END OF TY_LFA1,

        BEGIN OF TY_ADRC,
          ADDRNUMBER TYPE ADRC-ADDRNUMBER,
          NAME1      TYPE ADRC-NAME1,
        END OF TY_ADRC,

        BEGIN OF TY_EKKN,
          EBELN TYPE EKKN-EBELN,
          EBELP TYPE EKKN-EBELP,
          VBELN TYPE EKKN-VBELN,
          VBELP TYPE EKKN-VBELP,
        END OF TY_EKKN,

        BEGIN OF TY_FINAL,
          EBELN      TYPE EKPO-EBELN, "PO NO
          EBELP      TYPE EKPO-EBELP, "PO Line item
          LIFNR      TYPE EKKO-LIFNR, "Vendor Code
          NAME1      TYPE ADRC-NAME1, "Vendor Name
          VBELN      TYPE EKKN-VBELN, "Sales Order No
          VBELP      TYPE EKKN-VBELP, "Line Item
          MATNR      TYPE EKPO-MATNR, "Material
          TXZ01      TYPE STRING, "Long Text
          MBLNR      TYPE MSEG-MBLNR,
          ZEILE      TYPE MSEG-ZEILE,
          BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
          MENGE      TYPE CHAR15,
          SMBLP      TYPE MSEG-SMBLP,
          KUNNR      TYPE  VBAK-KUNNR,
          MENGE_PO   TYPE CHAR15, "added by shreya 22-10-2021"
          ERDAT      TYPE  VBAK-ERDAT,
          KDMAT      TYPE  KNMT-KDMAT,
          BWART      TYPE MSEG-BWART,
          NAME11     TYPE KNA1-NAME1,
        END OF TY_FINAL,

        BEGIN OF TY_DOWN,
          EBELN      TYPE EKPO-EBELN, "PO NO
          EBELP      TYPE EKPO-EBELP, "PO Line item
          LIFNR      TYPE EKKO-LIFNR, "Vendor Code
          NAME1      TYPE ADRC-NAME1, "Vendor Name
          VBELN      TYPE EKKN-VBELN, "Sales Order No
          VBELP      TYPE EKKN-VBELP, "Line Item
          MATNR      TYPE EKPO-MATNR, "Material
          TXZ01      TYPE STRING, "Long Text
          MBLNR      TYPE MSEG-MBLNR,
          ZEILE      TYPE MSEG-ZEILE,
          BUDAT_MKPF TYPE STRING,
          MENGE      TYPE STRING,
          KUNNR      TYPE VBAK-KUNNR, " customer code added by shreya
          MENGE_PO   TYPE CHAR15, "added by shreya 22-10-2021"
          ERDAT      TYPE CHAR15,
          KDMAT      TYPE CHAR15,
          BWART      TYPE MSEG-BWART,
          REF_DAT    TYPE CHAR15,     "Refresh Date
          REF_TIME   TYPE CHAR15,     "Refresh Time
          NAME11     TYPE STRING,     "Refresh Time
        END OF TY_DOWN.

DATA : LT_EKPO  TYPE TABLE OF TY_EKPO,
       LS_EKPO  TYPE          TY_EKPO,

       LT_EKKO  TYPE TABLE OF TY_EKKO,
       LS_EKKO  TYPE          TY_EKKO,

       LT_EKKN  TYPE TABLE OF TY_EKKN,
       LS_EKKN  TYPE          TY_EKKN,

       LT_VBAK  TYPE TABLE OF TY_VBAK,
       LS_VBAK  TYPE          TY_VBAK,

       LT_KNA1  TYPE TABLE OF TY_KNA1,
       LS_KNA1  TYPE          TY_KNA1,

       LT_KNMT  TYPE TABLE OF TY_KNMT,
       LS_KNMT  TYPE TY_KNMT,

       LT_LFA1  TYPE TABLE OF TY_LFA1,
       LS_LFA1  TYPE          TY_LFA1,

       LT_ADRC  TYPE TABLE OF TY_ADRC,
       LS_ADRC  TYPE          TY_ADRC,

       LT_FINAL TYPE TABLE OF TY_FINAL,
       LS_FINAL TYPE          TY_FINAL,

       LT_DOWN  TYPE TABLE OF TY_DOWN,
       LS_DOWN  TYPE          TY_DOWN,

       LT_MSEG  TYPE TABLE OF TY_MSEG,
       LS_MSEG  TYPE          TY_MSEG,

       LT_MSEG1 TYPE TABLE OF TY_MSEG,
       LS_MSEG1 TYPE          TY_MSEG.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE.

DATA : LS_LAYOUT TYPE SLIS_LAYOUT_ALV.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*SELECT-OPTIONS : s_lifnr  FOR mseg-lifnr DEFAULT 0000100063,
  SELECT-OPTIONS : S_LIFNR  FOR MSEG-LIFNR ,
                   S_DATE   FOR MSEG-BUDAT_MKPF.
  PARAMETERS     : P_PLANT TYPE EKPO-WERKS OBLIGATORY DEFAULT 'PL01' MODIF ID BU.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT  '/Delval/India'."India'."India'."temp'.          "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK B2.


SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM GET_DATA.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  SELECT MBLNR
         MJAHR
         ZEILE
         BWART
         WERKS
         SOBKZ
         MENGE
         EBELN
         EBELP
         SMBLN
         SMBLP
         BUDAT_MKPF
    FROM MSEG
    INTO TABLE LT_MSEG
    WHERE WERKS = P_PLANT AND
          BUDAT_MKPF IN S_DATE AND
          LIFNR IN S_LIFNR AND
          BWART IN ( '101' , '102' ) .
*          AND  sobkz = 'E'.

  IF LT_MSEG IS NOT INITIAL.

    SELECT EBELN
           EBELP
           LOEKZ
           TXZ01
           MATNR
           WERKS
           MENGE
           ELIKZ
           KNTTP
      FROM EKPO
      INTO TABLE LT_EKPO
      FOR ALL ENTRIES IN LT_MSEG[]
      WHERE EBELN = LT_MSEG-EBELN AND
            EBELP = LT_MSEG-EBELP AND
*            loekz = ' ' AND
            WERKS = P_PLANT ."AND
*            knttp = 'E'.

  ENDIF.

  IF LT_EKPO IS  NOT INITIAL.

    SELECT EBELN
           AEDAT
           LIFNR
           EKGRP
      FROM EKKO
      INTO TABLE LT_EKKO[]
      FOR ALL ENTRIES IN LT_EKPO
      WHERE EBELN = LT_EKPO-EBELN.

    SELECT EBELN
    EBELP
    VBELN
    VBELP
    FROM EKKN
    INTO TABLE LT_EKKN
    FOR ALL ENTRIES IN LT_EKPO
    WHERE EBELN = LT_EKPO-EBELN AND
    EBELP = LT_EKPO-EBELP.

    IF LT_EKKN IS NOT INITIAL.

      SELECT VBELN
             KUNNR
             ERDAT
      FROM VBAK
      INTO TABLE LT_VBAK
      FOR ALL ENTRIES IN LT_EKKN
      WHERE VBELN = LT_EKKN-VBELN.

      SELECT KUNNR
             NAME1
        FROM KNA1
        INTO TABLE LT_KNA1
        FOR ALL ENTRIES IN LT_VBAK
        WHERE KUNNR = LT_VBAK-KUNNR.


    ENDIF.

    IF LT_VBAK[] IS NOT INITIAL.
      SELECT KUNNR
             KDMAT
      FROM   KNMT
      INTO TABLE LT_KNMT
      FOR ALL ENTRIES IN LT_VBAK
      WHERE KUNNR = LT_VBAK-KUNNR.
    ENDIF.


    SELECT MBLNR
    MJAHR
    ZEILE
    BWART
    WERKS
    SOBKZ
    MENGE
    EBELN
    EBELP
    SMBLN
    SMBLP
    BUDAT_MKPF
    FROM MSEG
    INTO TABLE LT_MSEG1
    FOR ALL ENTRIES IN LT_EKPO
    WHERE EBELN = LT_EKPO-EBELN AND
          EBELP = LT_EKPO-EBELP AND
          WERKS = P_PLANT AND
          BUDAT_MKPF IN S_DATE AND
          LIFNR IN S_LIFNR AND
          BWART IN ( '101' , '102' ) ."AND
*         sobkz = 'E'.

  ENDIF.

  IF LT_EKKO IS NOT INITIAL.

    SELECT LIFNR
    ADRNR
    FROM LFA1
    INTO TABLE LT_LFA1
    FOR ALL ENTRIES IN LT_EKKO
    WHERE LIFNR = LT_EKKO-LIFNR.

  ENDIF.

  IF LT_LFA1 IS NOT INITIAL.

    SELECT ADDRNUMBER
    NAME1
    FROM ADRC
    INTO TABLE LT_ADRC
    FOR ALL ENTRIES IN LT_LFA1
    WHERE ADDRNUMBER = LT_LFA1-ADRNR.

  ENDIF.

  IF LT_EKPO IS NOT INITIAL.
    PERFORM SORT_DATA.
    PERFORM GET_FCAT.
    PERFORM DISPLAY.
*    PERFORM download.
  ELSE.
    MESSAGE 'No Data Found!' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
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

  LOOP AT LT_MSEG1 INTO LS_MSEG1.

*    IF ls_mseg1-mblnr NE ls_mseg1-smbln.
*    IF ls_mseg1-smbln = ' '.

    LS_FINAL-MBLNR      = LS_MSEG1-MBLNR.
    LS_FINAL-BUDAT_MKPF = LS_MSEG1-BUDAT_MKPF.
    LS_FINAL-ZEILE      = LS_MSEG1-ZEILE.
    CALL FUNCTION 'ROUND'
      EXPORTING
*       DECIMALS            = 0
        INPUT  = LS_MSEG1-MENGE
*       SIGN   = ' '
      IMPORTING
        OUTPUT = LS_MSEG1-MENGE
*       EXCEPTIONS
*       INPUT_INVALID       = 1
*       OVERFLOW            = 2
*       TYPE_INVALID        = 3
*       OTHERS = 4
      .
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

    LS_FINAL-MENGE      = LS_MSEG1-MENGE.
    SHIFT LS_FINAL-MENGE RIGHT DELETING TRAILING '0'.
    LS_FINAL-EBELN      = LS_MSEG1-EBELN.
    LS_FINAL-EBELP      = LS_MSEG1-EBELP.

    READ TABLE LT_EKPO INTO LS_EKPO WITH KEY EBELN = LS_MSEG1-EBELN
                                             EBELP = LS_MSEG1-EBELP.
    IF SY-SUBRC = 0.
      LS_FINAL-MATNR = LS_EKPO-MATNR.
*      ls_final-txz01 = ls_ekpo-txz01.
      CALL FUNCTION 'ROUND'
        EXPORTING
*         DECIMALS            = 0
          INPUT  = LS_EKPO-MENGE
*         SIGN   = ' '
        IMPORTING
          OUTPUT = LS_EKPO-MENGE
*         EXCEPTIONS
*         INPUT_INVALID       = 1
*         OVERFLOW            = 2
*         TYPE_INVALID        = 3
*         OTHERS = 4
        .
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.

*      ls_final-menge = ls_ekpo-menge.
*      SHIFT ls_final-menge RIGHT DELETING TRAILING '0'.

      LS_FINAL-MENGE_PO = LS_EKPO-MENGE.
      SHIFT LS_FINAL-MENGE_PO RIGHT DELETING TRAILING '0'.
    ENDIF.

    READ TABLE LT_EKKO INTO LS_EKKO WITH KEY EBELN = LS_FINAL-EBELN .
    IF SY-SUBRC = 0.
      LS_FINAL-LIFNR  = LS_EKKO-LIFNR.
    ENDIF.
    READ TABLE LT_LFA1 INTO LS_LFA1 WITH KEY LIFNR = LS_FINAL-LIFNR.

    IF SY-SUBRC = 0.

      READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_LFA1-ADRNR.
      IF SY-SUBRC = 0.
        LS_FINAL-NAME1 = LS_ADRC-NAME1.

      ENDIF.

    ENDIF.

    READ TABLE LT_EKKN INTO LS_EKKN WITH KEY EBELN = LS_FINAL-EBELN
    EBELP = LS_EKPO-EBELP.
    IF SY-SUBRC = 0.
      LS_FINAL-VBELN = LS_EKKN-VBELN.
      LS_FINAL-VBELP = LS_EKKN-VBELP.

    ENDIF.

    READ TABLE LT_VBAK INTO LS_VBAK WITH KEY VBELN = LS_FINAL-VBELN.
    IF SY-SUBRC = 0.
      LS_FINAL-KUNNR = LS_VBAK-KUNNR.
      LS_FINAL-ERDAT = LS_VBAK-ERDAT.
    ENDIF.

    " APPEND ls_final TO lt_final.

    READ TABLE LT_KNMT INTO LS_KNMT WITH KEY KUNNR = LS_VBAK-KUNNR.
    IF SY-SUBRC = 0.
      "ls_final-kunnr = ls_vbak-kunnr.
      LS_FINAL-KDMAT = LS_KNMT-KDMAT.
    ENDIF.


    READ TABLE LT_MSEG INTO LS_MSEG WITH KEY MBLNR = LS_FINAL-MBLNR.
    IF SY-SUBRC = 0.
      LS_FINAL-BWART = LS_MSEG-BWART.
    ENDIF.

    READ TABLE LT_KNA1 INTO LS_KNA1 WITH KEY KUNNR = LS_FINAL-KUNNR.
    IF SY-SUBRC = 0.
      LS_FINAL-NAME11 = LS_KNA1-NAME1.
    ENDIF.
    """"""""""""""""""""""""""""""""""""""""""""""""""
    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = LS_FINAL-MATNR.
    IF LV_NAME  IS NOT INITIAL.
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
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.
    ENDIF.
    IF LV_LINES IS NOT INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF WA_LINES-TDLINE IS NOT INITIAL.
          CONCATENATE LS_FINAL-TXZ01 WA_LINES-TDLINE INTO LS_FINAL-TXZ01 SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-TXZ01.
    ENDIF.

    APPEND LS_FINAL TO LT_FINAL.

    CLEAR : LS_FINAL,LS_MSEG1,LS_EKKO,LS_EKPO,LS_LFA1,LS_ADRC,LS_EKKN, LS_VBAK.



*    ELSE.
    DATA : GV_SMBLN TYPE MSEG-SMBLN,
           GV_SMBLP TYPE MSEG-SMBLP.
    GV_SMBLN = LS_MSEG1-SMBLN.
    GV_SMBLP = LS_MSEG1-SMBLP.
*    ENDIF.

*    DELETE lt_final WHERE mblnr = gv_smbln AND zeile = gv_smblp.

  ENDLOOP.
*  DELETE ADJACENT DUPLICATES FROM LT_FINAL COMPARING ALL FIELDS.

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

  PERFORM FCATLOG USING : '1'    'EBELN'       'LT_FINAL'  'PO NO'             '18' ''.
  PERFORM FCATLOG USING : '2'    'EBELP'       'LT_FINAL'  'PO Line Item'      '18' ''.
  PERFORM FCATLOG USING : '3'    'LIFNR'       'LT_FINAL'  'Vendor Code'       '18' ''.
  PERFORM FCATLOG USING : '4'    'NAME1'       'LT_FINAL'  'Vendor Name'       '40' ''.
  PERFORM FCATLOG USING : '5'    'VBELN'       'LT_FINAL'  'Sale Order No'     '18' ''.
  PERFORM FCATLOG USING : '6'    'VBELP'       'LT_FINAL'  'Line Item'         '18' ''.
  PERFORM FCATLOG USING : '7'    'MATNR'       'LT_FINAL'  'Material'          '18' ''.
  PERFORM FCATLOG USING : '8'    'TXZ01'       'LT_FINAL'  'Item Description'  '40' ''.
  PERFORM FCATLOG USING : '9'    'MBLNR'       'LT_FINAL'  'GRN No.'           '18' ''.
  PERFORM FCATLOG USING : '10'   'ZEILE'       'LT_FINAL'  'GRN Line Item.'    '10' ''.
  PERFORM FCATLOG USING : '11'   'BUDAT_MKPF'  'LT_FINAL'  'GRN Date'          '18' ''.
  PERFORM FCATLOG USING : '12'   'MENGE'       'LT_FINAL'  'Quantity'          '20' '0'.
  PERFORM FCATLOG USING : '13'   'KUNNR'       'LT_FINAL'  'Customer Code'     '20' ''.
  PERFORM FCATLOG USING : '14'   'MENGE_PO'    'LT_FINAL'  'PO Quantity'       '20' '0'.
  PERFORM FCATLOG USING : '15'   'ERDAT'       'LT_FINAL'  'Sales Ord Date'    '20' ''.
  PERFORM FCATLOG USING : '16'   'KDMAT'       'LT_FINAL'  'Customer Item Code' '20' ''.
  PERFORM FCATLOG USING : '17'   'BWART'       'LT_FINAL'  'Mov. Type'          '20' ''.
  PERFORM FCATLOG USING : '18'   'NAME11'      'LT_FINAL'  'Customer Name'      '20' ''.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FCATLOG USING    VALUE(P1)
      VALUE(P2)
      VALUE(P3)
      VALUE(P4)
      VALUE(P5)
      VALUE(P6).
  "VALUE(p7).


  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.
  WA_FCAT-DECIMALS_OUT = P6.


  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT..

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

  LOOP AT LT_FINAL INTO LS_FINAL.

    LS_DOWN-MBLNR      = LS_FINAL-MBLNR.
    LS_DOWN-MENGE      = LS_FINAL-MENGE.
    LS_DOWN-EBELN      = LS_FINAL-EBELN.
    LS_DOWN-EBELP      = LS_FINAL-EBELP.
    LS_DOWN-MATNR      = LS_FINAL-MATNR.
    LS_DOWN-TXZ01      = LS_FINAL-TXZ01.
    LS_DOWN-LIFNR      = LS_FINAL-LIFNR.
    LS_DOWN-NAME1      = LS_FINAL-NAME1.
    LS_DOWN-VBELN      = LS_FINAL-VBELN.
    LS_DOWN-VBELP      = LS_FINAL-VBELP.
    LS_DOWN-ZEILE      = LS_FINAL-ZEILE.
    LS_DOWN-KUNNR      = LS_FINAL-KUNNR.
    LS_DOWN-MENGE_PO   = LS_FINAL-MENGE_PO.
    LS_DOWN-NAME11     = LS_FINAL-NAME11.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-ERDAT
      IMPORTING
        OUTPUT = LS_DOWN-ERDAT.

    CONCATENATE LS_DOWN-ERDAT+0(2) LS_DOWN-ERDAT+2(3) LS_DOWN-ERDAT+5(4)
    INTO LS_DOWN-ERDAT SEPARATED BY '-'.

*    ls_down-erdat     = ls_final-erdat.
    LS_DOWN-KDMAT     = LS_FINAL-KDMAT.
    LS_DOWN-BWART     = LS_FINAL-BWART.
    IF LS_FINAL-BUDAT_MKPF IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-BUDAT_MKPF
        IMPORTING
          OUTPUT = LS_DOWN-BUDAT_MKPF.

      CONCATENATE LS_DOWN-BUDAT_MKPF+0(2) LS_DOWN-BUDAT_MKPF+2(3) LS_DOWN-BUDAT_MKPF+5(4)
      INTO LS_DOWN-BUDAT_MKPF SEPARATED BY '-'.

    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = LS_DOWN-REF_DAT.

    CONCATENATE LS_DOWN-REF_DAT+0(2) LS_DOWN-REF_DAT+2(3) LS_DOWN-REF_DAT+5(4)
    INTO LS_DOWN-REF_DAT SEPARATED BY '-'.

    LS_DOWN-REF_TIME = SY-UZEIT.
    CONCATENATE LS_DOWN-REF_TIME+0(2) ':' LS_DOWN-REF_TIME+2(2)  INTO LS_DOWN-REF_TIME.

    IF LS_DOWN-ERDAT EQ '00000000' OR LS_DOWN-ERDAT EQ '--'.
      LS_DOWN-ERDAT = ''.
    ENDIF.


    APPEND LS_DOWN TO LT_DOWN.
    CLEAR : LS_DOWN,LS_FINAL.

  ENDLOOP.

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

  LS_LAYOUT-ZEBRA = 'X'.
  LS_LAYOUT-COLWIDTH_OPTIMIZE = 'X' .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      IS_LAYOUT          = LS_LAYOUT
      IT_FIELDCAT        = IT_FCAT[]
    TABLES
      T_OUTTAB           = LT_FINAL[]
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
    PERFORM DOWNLOAD_EXCEL.
*    PERFORM download.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*

.
*&      Form  DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD_EXCEL .

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
*  BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = LT_DOWN
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
  LV_FILE = 'ZGRN_LIST_NEW.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
  INTO LV_FULLFILE.
*  BREAK primus.
  WRITE: / 'ZGRN_LIST_NEW Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_757 TYPE STRING.
    DATA LV_CRLF_757 TYPE STRING.
    LV_CRLF_757 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_757 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_757 LV_CRLF_757 WA_CSV INTO LV_STRING_757.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_2076 TO lv_fullfile.
    TRANSFER LV_STRING_757 TO LV_FULLFILE.
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

  CONCATENATE 'PO NO'
              'PO Line Item'
              'Vendor Code'
              'Vendor Name'
              'Sale Order No'
              'Line Item'
              'Material'
              'Item Description'
              'GRN No.'
              'GRN Line Item'
              'GRN Date'
              'Quantity'
              'Customer Code'
              'PO Quantity'
              'Sales Ord Date'
              'Customer Item Code'
              'Mov. Type'
              'Refresh Date'
              'Refresh Time'
              'Customer Name'

    INTO P_HD_CSV
    SEPARATED BY L_FIELD_SEPERATOR.


ENDFORM.
