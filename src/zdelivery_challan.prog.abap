*----------------------------------------------------------------------*
*      Print of a invoice by SAPscript SMART FORMS               *
*----------------------------------------------------------------------*

REPORT ZSA_CHALLAN1.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_VBELN TYPE VBELN.
SELECTION-SCREEN END OF BLOCK B1.

INCLUDE ZSA_CHALAN1_DECLARE.
INCLUDE ZSA_CHALAN1_FORM01.
INCLUDE ZSA_CHALAN1_FORMS.

TYPES:BEGIN OF TY_FINAL,
        VBELN     TYPE VBRP-VBELN,
        POSNR     TYPE VBRP-POSNR,
        VGBEL     TYPE VBRP-VGBEL,
        VGPOS     TYPE VBRP-VGPOS,
        MATNR     TYPE VBRP-MATNR,
        ARKTX     TYPE VBRP-ARKTX,
        FKIMG     TYPE VBRP-FKIMG,
        VRKME     TYPE VBRP-VRKME,
        NETWR     TYPE VBRP-NETWR,
        WERKS     TYPE VBRP-WERKS,
        CGST      TYPE PRCD_ELEMENTS-KBETR,
        CGST_AMT  TYPE PRCD_ELEMENTS-KWERT,
        SGST      TYPE PRCD_ELEMENTS-KBETR,
        SGST_AMT  TYPE PRCD_ELEMENTS-KWERT,
        IGST      TYPE PRCD_ELEMENTS-KBETR,
        IGST_AMT  TYPE PRCD_ELEMENTS-KWERT,
        GV_SR1    TYPE I,
        GV_IS1    TYPE I,
        STEUC     TYPE MARC-STEUC,
        GV_MAT    TYPE CHAR100,
        GV_ZEINR2 TYPE MARA-ZEINR,
        GV_TEXT2  TYPE STRING,

      END OF TY_FINAL.

TYPES:BEGIN OF T_ITEM,
        VBELN TYPE VBRP-VBELN,
        POSNR TYPE VBRP-POSNR,
        VGBEL TYPE VBRP-VGBEL,
        VGPOS TYPE VBRP-VGPOS,
        MATNR TYPE VBRP-MATNR,
        ARKTX TYPE VBRP-ARKTX,
        FKIMG TYPE VBRP-FKIMG,
        VRKME TYPE VBRP-VRKME,
        NETWR TYPE VBRP-NETWR,
        WERKS TYPE VBRP-WERKS,
        LGORT TYPE VBRP-LGORT, "added byjyoti on 13.06.2024
      END OF T_ITEM.


TYPES : BEGIN OF TY_VBRK,
          VBELN TYPE VBRK-VBELN,
          KNUMV TYPE VBRK-KNUMV,
        END OF TY_VBRK.

TYPES: BEGIN OF TY_KONV,
         KNUMV TYPE PRCD_ELEMENTS-KNUMV,
         KPOSN TYPE PRCD_ELEMENTS-KPOSN,
         KSCHL TYPE PRCD_ELEMENTS-KSCHL,
         KAWRT TYPE PRCD_ELEMENTS-KAWRT,
         KBETR TYPE PRCD_ELEMENTS-KBETR,
         KWERT TYPE PRCD_ELEMENTS-KWERT,
       END OF TY_KONV.

TYPES:
  BEGIN OF T_MAT_DOC,
    MBLNR TYPE MSEG-MBLNR,
    MJAHR TYPE MSEG-MJAHR,
    ZEILE TYPE MSEG-ZEILE,
    BWART TYPE MSEG-BWART,
    MATNR TYPE MSEG-MATNR,
    EBELN TYPE MSEG-EBELN,
    EBELP TYPE MSEG-EBELP,
    LGORT TYPE MSEG-LGORT,
  END OF T_MAT_DOC.

TYPES:
  BEGIN OF T_J_1IG_SUBCON,
    BUKRS    TYPE J_1IG_SUBCON-BUKRS,
    MBLNR    TYPE J_1IG_SUBCON-MBLNR,
    MJAHR    TYPE J_1IG_SUBCON-MJAHR,
    ZEILE    TYPE J_1IG_SUBCON-ZEILE,
    CHLN_INV TYPE J_1IG_SUBCON-CHLN_INV,
    BWART    TYPE J_1IG_SUBCON-BWART,
    ITEM     TYPE J_1IG_SUBCON-ITEM,
    MENGE    TYPE J_1IG_SUBCON-MENGE,
    MEINS    TYPE J_1IG_SUBCON-MEINS,
    MATNR    TYPE J_1IG_SUBCON-MATNR,
  END OF T_J_1IG_SUBCON.

TYPES : BEGIN OF TY_MAKT,
          MATNR TYPE MAKT-MATNR,
          SPRAS TYPE MAKT-SPRAS,
          MAKTX TYPE MAKT-MAKTX,
        END OF TY_MAKT.

TYPES : BEGIN OF TY_EKKN,
          EBELN TYPE EKKN-EBELN,
          EBELP TYPE EKKN-EBELP,
          ZEKKN TYPE EKKN-ZEKKN,
          VBELN TYPE EKKN-VBELN,
          VBELP TYPE EKKN-VBELP,
        END OF TY_EKKN.

TYPES : BEGIN OF TY_MARC,
          MATNR TYPE MARC-MATNR,
          WERKS TYPE MARC-WERKS,
          DISPO TYPE MARC-DISPO,
        END OF TY_MARC.

TYPES : BEGIN OF TY_VBAP,
          VBELN TYPE VBAP-VBELN,
          POSNR TYPE VBAP-POSNR,
          ZCE   TYPE VBAP-ZCE,
          ZGAD  TYPE VBAP-ZGAD,
        END OF TY_VBAP.

TYPES :BEGIN OF T_MAT_DESC,
         MATNR TYPE MAKT-MATNR,
         MAKTX TYPE MAKT-MAKTX,
       END OF T_MAT_DESC.

TYPES:
  BEGIN OF t_marc,
    matnr TYPE marc-matnr,
    werks TYPE marc-werks,
    steuc TYPE marc-steuc,
    dispo TYPE marc-dispo,
  END OF t_marc.

TYPES: BEGIN OF T_PURCHASING,
         EBELN        TYPE EKPO-EBELN,
         EBELP        TYPE EKPO-EBELP,
         TXZ01        TYPE EKPO-TXZ01,
         MATNR        TYPE EKPO-MATNR,
         MENGE        TYPE EKPO-MENGE,
         MEINS        TYPE EKPO-MEINS,
         MWSKZ        TYPE EKPO-MWSKZ,
         WERKS        TYPE EKPO-WERKS,
         NETWR        TYPE EKPO-NETWR,
         GV_WRKST1    TYPE MARA-WRKST,
         VBELN        TYPE EKKN-VBELN,
         VBELP        TYPE EKKN-VBELP,
         LV_BRANCH1   TYPE BEZEI,
         GV_PC1       TYPE CHAR4,
         GV_TEXT_LD1  TYPE  CHAR50,
         GV_TEXT_TAG1 TYPE CHAR50,
         GV_TEXT_TPI1 TYPE CHAR50,
         GV_ZGAD1     TYPE CHAR50,
         LS_MARC1     TYPE MARC-DISPO,
         GV_MENGE2    TYPE EKPO-MENGE,
         GV_RATE1     TYPE VBRP-NETWR,
         GV_MAT_TEXT1 TYPE CHAR50,
         GV_TEXT1     TYPE CHAR50,
         GV_ZEINR_R1  TYPE MARA-ZEINR,
         GV_LINES1    TYPE CHAR250,




       END OF T_PURCHASING.

  DATA: LV_LENGTH     TYPE STRING.
    DATA: LV_LATRS      TYPE C.
    DATA: LV_LATRS1     TYPE C.
    DATA: LV_INDEX      TYPE SY-INDEX.
    DATA: LV_SAFE_LEN   TYPE SY-INDEX.
    DATA: LV_LINES      TYPE STRING.
    DATA: LV_SPACE      TYPE STRING.
    DATA: LV_SPACE1     TYPE STRING.
    DATA: LV_SPACE2     TYPE STRING.

**---------------------------------------------------------------------*
**       FORM ENTRY
*---------------------------------------------------------------------*
FORM ENTRY USING RETURN_CODE US_SCREEN.

  DATA: LF_RETCODE TYPE SY-SUBRC.
  CLEAR RETCODE.
  XSCREEN = US_SCREEN.
  PERFORM PROCESSING "USING US_SCREEN
                     CHANGING LF_RETCODE.
  IF LF_RETCODE NE 0.
    RETURN_CODE = 1.
  ELSE.
    RETURN_CODE = 0.
  ENDIF.

ENDFORM.                    "ENTRY
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
FORM PROCESSING "USING PROC_SCREEN
                CHANGING CF_RETCODE.

  DATA: LS_PRINT_DATA_TO_READ TYPE LBBIL_PRINT_DATA_TO_READ.
  DATA: LS_BIL_INVOICE TYPE LBBIL_INVOICE.
  DATA: LF_FM_NAME            TYPE RS38L_FNAM.
  DATA: LS_CONTROL_PARAM      TYPE SSFCTRLOP.
  DATA: LS_COMPOSER_PARAM     TYPE SSFCOMPOP.
  DATA: LS_RECIPIENT          TYPE SWOTOBJID.
  DATA: LS_SENDER             TYPE SWOTOBJID.
  DATA: LF_FORMNAME           TYPE TDSFNAME.
  DATA: LS_ADDR_KEY           LIKE ADDR_KEY.
  DATA: LS_DLV-LAND           LIKE VBRK-LAND1.
  DATA: LS_JOB_INFO           TYPE SSFCRESCL.
  DATA: LV_CNT                TYPE CHAR1.
  DATA :WA_FINAL              TYPE TY_FINAL.
  DATA: IGST_TOT              TYPE VBRP-NETWR .
  DATA: SGST_TOT              TYPE VBRP-NETWR .
  DATA: CGST_TOT              TYPE VBRP-NETWR .
  DATA: TAX_AMT               TYPE VBRP-NETWR .
  DATA: IT_FINAL TYPE STANDARD TABLE OF TY_FINAL.
  DATA :CHECK_GST2           TYPE CHAR4.
  DATA :GT_ITEM  TYPE STANDARD TABLE OF T_ITEM .
  DATA :GS_ITEM              TYPE T_ITEM.
  DATA :IT_KONV TYPE STANDARD TABLE OF TY_KONV.
  DATA :WA_KONV              TYPE TY_KONV.
  DATA :IT_VBRK  TYPE STANDARD TABLE OF TY_VBRK.
  DATA :WA_VBRK              TYPE TY_VBRK.
  DATA :GT_PURCHASING TYPE STANDARD TABLE OF T_PURCHASING.
  DATA :GS_PURCHASING TYPE T_PURCHASING.
  DATA:GT_J_1IG_SUBCON  TYPE STANDARD TABLE OF T_J_1IG_SUBCON.
  DATA:GT_MAT_DOC TYPE STANDARD TABLE OF  T_MAT_DOC .
  DATA :S_LGORT TYPE  EKPO-LGORT.
  DATA :S_WERKS TYPE  EKPO-WERKS.
  DATA :IT_TAXCON    TYPE TAXCOM,
        LS_EKKO      TYPE EKKO,
        LS_EKPO      TYPE EKPO,
        GV_ZGAD      TYPE  STRING,
        GV_KNTTP     TYPE  STRING,
        GV_WRKST     TYPE  STRING,
        LS_MAKT      TYPE TY_MAKT,
        LS_EKKN      TYPE TY_EKKN,
        LS_MARC      TYPE TY_MARC,
        LS_VBAP      TYPE TY_VBAP,
        GV_PC        TYPE  CHAR4,
        LV_BRANCH    TYPE  BEZEI,
        GV_TEXT_NOTE TYPE  STRING,
        GV_TEXT_TAG  TYPE  STRING,
        GV_TEXT_LD   TYPE  STRING,
        GV_ZEINR_R   TYPE  MARA-ZEINR,
        GV_SR        TYPE  I,
        GV_RATE      TYPE  VBRP-NETWR,
        GS_MAT_DESC  TYPE  T_MAT_DESC.
  DATA : GT_MAT_DESC TYPE STANDARD TABLE OF T_MAT_DESC.
  DATA:  GV_MENGE TYPE  EKPO-MENGE,
         GV_MENGE1 TYPE  EKPO-MENGE,
         GV_MAT_TEXT  TYPE  STRING.
  DATA : GT_MARC TYPE STANDARD TABLE OF T_MARC.
  DATA : GS_MARC TYPE T_MARC.
  DATA : MAT_LT_LINES TYPE  ZTLINE_TBLTT  .
  DATA : GV_K TYPE  STRING.
  data : GV_IS  TYPE  I .
  data :  GV_ZEINR    TYPE MARA-ZEINR.
  DATA : GV_TEXT  TYPE  STRING  .
  data :GV_TEXT_TPI TYPE  STRING  .
  DATA: GV_NOTE_X TYPE  C .
  DATA : GV_LINES TYPE  STRING  .
  DATA: TEXT  TYPE  CHAR3 .
  DATA :  LD_TEXT2 TYPE STRING.
  DATA : GV_STEUC TYPE STRING.




















* SmartForm from customizing table TNAPR
LF_FORMNAME = TNAPR-SFORM.

* BEGIN: Country specific extension for Hungary
  DATA: LV_CCNUM TYPE IDHUCCNUM,
        LV_ERROR TYPE C.

* If a valid entry exists for the form in customizing view
* IDHUBILLINGOUT then the localized output shall be used.
*  SELECT SINGLE ccnum INTO lv_ccnum FROM idhubillingout WHERE
*    kschl = nast-kschl.

*  IF sy-subrc EQ 0.
  IF LV_CCNUM IS INITIAL.
    LV_CCNUM = 1.
  ENDIF.

  IF ( NAST-DELET IS INITIAL OR NAST-DIMME IS INITIAL ).

    NAST-DELET = 'X'.
    NAST-DIMME = 'X'.

    SY-MSGID = 'IDFIHU'.
    SY-MSGTY = 'W'.
    SY-MSGNO = 201.
    SY-MSGV1 = NAST-OBJKY.

    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        MSG_ARBGB = SY-MSGID
        MSG_NR    = SY-MSGNO
        MSG_TY    = SY-MSGTY
        MSG_V1    = SY-MSGV1
        MSG_V2    = ''
        MSG_V3    = ''
        MSG_V4    = ''
      EXCEPTIONS
        OTHERS    = 1.
  ENDIF.

  IF CF_RETCODE = 0.
    PERFORM GET_DATA USING    LS_PRINT_DATA_TO_READ
                     CHANGING LS_ADDR_KEY
                              LS_DLV-LAND
                              LS_BIL_INVOICE
                              CF_RETCODE.
  ENDIF.

  IF CF_RETCODE = 0.
    PERFORM SET_PRINT_PARAM USING    LS_ADDR_KEY
                                     LS_DLV-LAND
                            CHANGING LS_CONTROL_PARAM
                                     LS_COMPOSER_PARAM
                                     LS_RECIPIENT
                                     LS_SENDER
                                     CF_RETCODE.
  ENDIF.

  IF CF_RETCODE = 0.
    DATA: LV_FM_NAME       TYPE FUNCNAME,
          LV_DOC_PARAMS    TYPE SFPDOCPARAMS,
          LV_OUTPUT_PARAMS TYPE SFPOUTPUTPARAMS,
          LS_FORM_OUTPUT   TYPE FPFORMOUTPUT.

    SELECT VBELN
       POSNR
       VGBEL
       VGPOS
       MATNR
       ARKTX
       FKIMG
       VRKME
       NETWR
       WERKS
       LGORT
  FROM VBRP
  INTO TABLE GT_ITEM
  WHERE VBELN = LS_BIL_INVOICE-HD_GEN-BIL_NUMBER.

  iF NOT GT_ITEM IS INITIAL.
  SELECT VBELN
         KNUMV FROM VBRK INTO TABLE IT_VBRK
         FOR ALL ENTRIES IN GT_ITEM
         WHERE VBELN = GT_ITEM-VBELN.
  SELECT MATNR
         WERKS
         STEUC
         DISPO
    FROM MARC
    INTO TABLE GT_MARC
    FOR ALL ENTRIES IN GT_ITEM
    WHERE MATNR = GT_ITEM-MATNR
      AND WERKS = GT_ITEM-WERKS.
  endif.

    IF NOT GT_ITEM IS INITIAL.
      SELECT VBELN
             KNUMV FROM VBRK INTO TABLE IT_VBRK
             FOR ALL ENTRIES IN GT_ITEM
             WHERE VBELN = GT_ITEM-VBELN.

    ENDIF.
    IF IT_VBRK IS NOT INITIAL.
      SELECT KNUMV
             KPOSN
             KSCHL
             KAWRT
             KBETR
             KWERT FROM PRCD_ELEMENTS INTO TABLE IT_KONV
             FOR ALL ENTRIES IN IT_VBRK
             WHERE KNUMV = IT_VBRK-KNUMV.
    ENDIF.
    IF GT_ITEM IS NOT INITIAL.
      SELECT BUKRS
             MBLNR
             MJAHR
             ZEILE
             CHLN_INV
             BWART
             ITEM
             MENGE
             MEINS
             MATNR
        FROM J_1IG_SUBCON
        INTO TABLE GT_J_1IG_SUBCON
        FOR ALL ENTRIES IN GT_ITEM
        WHERE CHLN_INV = GT_ITEM-VBELN.
    ENDIF.

    IF NOT GT_J_1IG_SUBCON IS INITIAL.
      SELECT MBLNR
             MJAHR
             ZEILE
             BWART
             MATNR
             EBELN
             EBELP
             LGORT
        FROM MSEG
        INTO TABLE GT_MAT_DOC
        FOR ALL ENTRIES IN GT_J_1IG_SUBCON
        WHERE MBLNR = GT_J_1IG_SUBCON-MBLNR
        AND   MJAHR = GT_J_1IG_SUBCON-MJAHR
        AND   ZEILE = GT_J_1IG_SUBCON-ZEILE
        AND   BWART = '541'
        AND   MATNR = GT_J_1IG_SUBCON-MATNR.

      SORT GT_MAT_DOC BY MBLNR DESCENDING.
      SORT GT_MAT_DOC BY ZEILE DESCENDING.
      SORT GT_MAT_DOC BY EBELN ASCENDING.

      SELECT EBELN
             EBELP
             TXZ01
             MATNR
             MENGE
             MEINS
             MWSKZ
             WERKS
             NETWR
        FROM EKPO
        INTO TABLE GT_PURCHASING
        FOR ALL ENTRIES IN GT_MAT_DOC
        WHERE EBELN = GT_MAT_DOC-EBELN
        AND   EBELP = GT_MAT_DOC-EBELP.

    ENDIF.

    LOOP AT GT_ITEM INTO GS_ITEM.
      WA_FINAL-VBELN   = GS_ITEM-VBELN.
      WA_FINAL-POSNR   = GS_ITEM-POSNR.
      WA_FINAL-VGBEL   = GS_ITEM-VGBEL.
      WA_FINAL-VGPOS   = GS_ITEM-VGPOS.
      WA_FINAL-MATNR   = GS_ITEM-MATNR.
      WA_FINAL-ARKTX   = GS_ITEM-ARKTX.
      WA_FINAL-FKIMG   = GS_ITEM-FKIMG.
      WA_FINAL-VRKME   = GS_ITEM-VRKME.
      WA_FINAL-NETWR   = GS_ITEM-NETWR.
      WA_FINAL-WERKS   = GS_ITEM-WERKS.
      READ TABLE GT_J_1IG_SUBCON INTO DATA(GS_J_1IG_SUBCON) WITH KEY
                                         CHLN_INV = WA_FINAL-VBELN.
      READ TABLE GT_MAT_DOC INTO DATA(GS_MAT_DOC) WITH KEY MBLNR = GS_J_1IG_SUBCON-MBLNR
                                                           LGORT+0(1) = 'K'.
      S_LGORT = GS_MAT_DOC-LGORT.

      READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_FINAL-VBELN.
      IF SY-SUBRC = 0.

      ENDIF.
  DATA(lo_text_reader) = NEW zcl_read_text( ).
      DATA: LV_TEXTNAME TYPE THEAD-TDNAME,
            LV_TEXT     TYPE STRING,
            LT_LINES    TYPE TABLE OF TLINE,
            LS_LINE     TYPE TLINE,
            WA_LINES    TYPE TLINE.


      CLEAR : LT_LINES , WA_LINES  .
      DATA: LV_NAME TYPE TDOBNAME.
      REFRESH LT_LINES.

      LV_NAME = WA_FINAL-MATNR.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          ID        = 'GRUN'
*          LANGUAGE  = 'E'
*          NAME      = LV_NAME
*          OBJECT    = 'MATERIAL'
**  IMPORTING
**         header    = ld_header
*        TABLES
*          LINES     = LT_LINES
*        EXCEPTIONS
*          ID        = 1
*          LANGUAGE  = 2
*          NAME      = 3
*          NOT_FOUND = 4
*          OBJECT    = 5.
*      IF SY-SUBRC <> 0.
*
*      ELSE.
*        READ TABLE LT_LINES INTO WA_LINES INDEX 1.
*                LV_LENGTH = STRLEN( WA_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = WA_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*              IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*        WA_FINAL-GV_MAT = LV_LINES .
*
*      ENDIF.
   lo_text_reader->read_text_string( EXPORTING id = 'GRUN' name = LV_NAME object = 'MATERIAL' IMPORTING lv_lines = DATA(lv_lines1) ).
  WA_FINAL-GV_MAT = lv_lines1 .
  clear lv_lines1.
    .
      LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_VBRK-KNUMV AND KPOSN = WA_FINAL-POSNR.
        CASE WA_KONV-KSCHL.
          WHEN 'JOCG'.
*        WA_FINAL-CGST = WA_KONV-KBETR / 10.
            WA_FINAL-CGST = WA_KONV-KBETR.
            WA_FINAL-CGST_AMT = WA_KONV-KWERT.
          WHEN 'JOSG'.
*        WA_FINAL-SGST = WA_KONV-KBETR / 10.
            WA_FINAL-SGST = WA_KONV-KBETR .
            WA_FINAL-SGST_AMT = WA_KONV-KWERT.
          WHEN 'JOIG'.
*        WA_FINAL-IGST = WA_KONV-KBETR / 10.
            WA_FINAL-IGST = WA_KONV-KBETR .
            WA_FINAL-IGST_AMT = WA_KONV-KWERT.
        ENDCASE.
      ENDLOOP.

   GV_IS = GV_IS + 1.

SELECT SINGLE steuc INTO GV_STEUC FROM marc
  WHERE matnr = gs_item-matnr.

cgst_tot = wa_final-cgst_amt + cgst_tot.
sgst_tot = wa_final-sgst_amt + sgst_tot.
igst_tot = wa_final-igst_amt + igst_tot.
tax_amt = wa_final-netwr + tax_amt.


       WA_FINAL-STEUC = GV_STEUC.
       WA_FINAL-GV_IS1 = GV_IS.
      APPEND WA_FINAL TO IT_FINAL.
      CLEAR WA_FINAL.
    ENDLOOP.




    LOOP AT GT_PURCHASING INTO GS_PURCHASING.
      SELECT SINGLE *
*        EBELN
*      EBELP
*      KNTTP
      FROM EKPO
      INTO LS_EKPO
      WHERE EBELN = GS_PURCHASING-EBELN AND
      EBELP = GS_PURCHASING-EBELP AND
      KNTTP = 'E'.
      IF SY-SUBRC = 0 .
        GV_KNTTP = LS_EKPO-KNTTP.
        SELECT SINGLE MATNR
                      SPRAS
                      MAKTX
                      FROM MAKT
                      INTO LS_MAKT
                      WHERE MATNR = GS_PURCHASING-MATNR.

        SELECT SINGLE EBELN
                      EBELP
                      ZEKKN
                      VBELN
                      VBELP
                  FROM EKKN
                  INTO LS_EKKN
                  WHERE EBELN = GS_PURCHASING-EBELN  AND
                  EBELP = GS_PURCHASING-EBELP.

        SELECT SINGLE  VKBUR FROM VBAK INTO @DATA(LV_VKBUR)
          WHERE VBELN = @LS_EKKN-VBELN.
*break dvbasis.
        SELECT SINGLE BEZEI FROM TVKBT INTO LV_BRANCH
          WHERE VKBUR = LV_VKBUR.

        SELECT SINGLE MATNR
        WERKS
        DISPO
        FROM MARC
        INTO LS_MARC
        WHERE MATNR = GS_PURCHASING-MATNR AND
        WERKS = GS_PURCHASING-WERKS.

*    BREAK dvbasis..
        SELECT SINGLE WRKST
        INTO GV_WRKST
        FROM MARA
        WHERE MATNR = GS_PURCHASING-MATNR .
*
        GS_PURCHASING-GV_WRKST1 = GV_WRKST.
        SELECT SINGLE VBELN
        POSNR
        ZCE
        ZGAD
        FROM VBAP
        INTO LS_VBAP
        WHERE VBELN = LS_EKKN-VBELN.
        IF LS_VBAP-ZCE = 'X'.
          GV_PC = 'CE'.
        ENDIF.
*
        IF LS_VBAP-ZGAD = '1'.
          GV_ZGAD = 'Reference'.
        ELSEIF LS_VBAP-ZGAD = '2'.
          GV_ZGAD = 'Approved'.
        ELSEIF LS_VBAP-ZGAD = '3'.
          GV_ZGAD = 'Standard'.
        ENDIF.


        DATA : OBJNAME TYPE TDOBNAME.
*    objname = ls_ekkn-vbeln.
*    PERFORM get_text USING objname 'VBBK' 'Z038' 'E' CHANGING gv_text_LD.
        DATA: "LV_TEXTNAME TYPE THEAD-TDNAME,
              "LV_TEXT     TYPE STRING,
              LT_LINES1   TYPE TABLE OF TLINE.
        "LS_LINE     TYPE TLINE.
clear lv_textname.
        LV_TEXTNAME = LS_EKKN-VBELN.
*BREAK DVBASIS.
*        CALL FUNCTION 'READ_TEXT'
*          EXPORTING
*            ID        = 'Z038'         "
*            LANGUAGE  = SY-LANGU
*            NAME      = LV_TEXTNAME
*            OBJECT    = 'VBBK'
*          TABLES
*            LINES     = LT_LINES1
*          EXCEPTIONS
*            NOT_FOUND = 1
*            OTHERS    = 2.
*        IF SY-SUBRC = 0.
*          LOOP AT LT_LINES1 INTO LS_LINE.
*                    LV_LENGTH = STRLEN( WA_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = WA_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*              IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*            CONCATENATE LV_TEXT LV_LINES INTO LV_TEXT SEPARATED BY SPACE.
*          ENDLOOP.
*          GV_TEXT_LD = LV_TEXT.
*        ENDIF.
    lo_text_reader->read_text_string( EXPORTING id = 'Z038' name = LV_TEXTNAME object = 'VBBK' IMPORTING lv_lines = lv_lines1 ).

   GV_TEXT_LD = lv_lines1.
    clear lv_lines1.
        CLEAR OBJNAME.
        OBJNAME = LS_EKKN-VBELN.
*        PERFORM GET_TEXT USING OBJNAME 'VBBK' 'Z039' 'E' CHANGING GV_TEXT_TAG.
*
*
*        CLEAR OBJNAME.
*        OBJNAME = LS_EKKN-VBELN.
*        PERFORM GET_TEXT USING OBJNAME 'VBBK' 'Z999' 'E' CHANGING GV_TEXT_TPI.
**BREAK-POINT.
*        CLEAR OBJNAME.
*        OBJNAME = GS_PURCHASING-MATNR.
*        PERFORM GET_TEXT USING OBJNAME 'MATERIAL' 'GRUN' 'S' CHANGING GV_TEXT_NOTE.
break dvbasis.

      ENDIF.
*break dvbasis.
      IF GV_KNTTP = 'E'.
        GV_K = 'E'.
      ENDIF.
      DATA : TEMP_EKPO TYPE EKPO,
             TEMP_VBRK TYPE VBRK.

      CLEAR:
        GS_MAT_DESC,GS_J_1IG_SUBCON.

      READ TABLE GT_MAT_DOC INTO GS_MAT_DOC
                  WITH KEY EBELN = GS_PURCHASING-EBELN
                           EBELP = GS_PURCHASING-EBELP.

      READ TABLE GT_J_1IG_SUBCON INTO GS_J_1IG_SUBCON
                  WITH KEY MBLNR  = GS_MAT_DOC-MBLNR
                           ZEILE  = GS_MAT_DOC-ZEILE.


      GV_RATE = GS_PURCHASING-NETWR / GS_PURCHASING-MENGE.

      SELECT SINGLE ZEINR
              FROM MARA
              INTO GV_ZEINR_R
              WHERE MATNR = GS_PURCHASING-MATNR.

      IF SY-SUBRC IS INITIAL.
        READ TABLE GT_MAT_DESC INTO GS_MAT_DESC
                   WITH KEY MATNR = GS_PURCHASING-MATNR.

      ENDIF.


      CLEAR GV_MENGE.
      DATA:
        LT_STB TYPE STANDARD TABLE OF STPOX,
        LS_STB TYPE STPOX.

      CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
        EXPORTING
          CAPID                 = 'PP01'
          DATUV                 = SY-DATUM
          MKTLS                 = 'X'
          MTNRV                 = GS_PURCHASING-MATNR
          STLAL                 = '01'
          STLAN                 = '1'
          STPST                 = '0'
          SVWVO                 = 'X'
          WERKS                 = GS_PURCHASING-WERKS
          VRSVO                 = 'X'
        TABLES
          STB                   = LT_STB
        EXCEPTIONS
          ALT_NOT_FOUND         = 1
          CALL_INVALID          = 2
          MATERIAL_NOT_FOUND    = 3
          MISSING_AUTHORIZATION = 4
          NO_BOM_FOUND          = 5
          NO_PLANT_DATA         = 6
          NO_SUITABLE_BOM_FOUND = 7
          CONVERSION_ERROR      = 8
          OTHERS                = 9.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.

      DATA:
        LV_MENGE TYPE RESB-ERFMG.

      DATA : RESB   TYPE RESB,
             MSEG   TYPE MSEG,
             CALC_1 TYPE STRING.

      SELECT SINGLE MENGE FROM EKPO INTO GV_MENGE1 WHERE EBELN = GS_PURCHASING-EBELN.

      GV_SR = GV_SR + 1.

      CLEAR:
        GS_MAT_DESC,GS_J_1IG_SUBCON.

      READ TABLE GT_MAT_DOC INTO GS_MAT_DOC
                  WITH KEY EBELN = GS_PURCHASING-EBELN
                           EBELP = GS_PURCHASING-EBELP.

      READ TABLE GT_J_1IG_SUBCON INTO GS_J_1IG_SUBCON
                  WITH KEY MBLNR  = GS_MAT_DOC-MBLNR
                           ZEILE  = GS_MAT_DOC-ZEILE.


      GV_RATE = GS_PURCHASING-NETWR / GS_PURCHASING-MENGE.
      SELECT SINGLE ZEINR
              FROM MARA
              INTO GV_ZEINR_R
              WHERE MATNR = GS_PURCHASING-MATNR.

      IF SY-SUBRC IS INITIAL.
        READ TABLE GT_MAT_DESC INTO GS_MAT_DESC
                   WITH KEY MATNR = GS_PURCHASING-MATNR.

      ENDIF.


      CLEAR GV_MENGE.

      CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
        EXPORTING
          CAPID                 = 'PP01'
          DATUV                 = SY-DATUM
          MKTLS                 = 'X'
          MTNRV                 = GS_PURCHASING-MATNR
          STLAL                 = '01'
          STLAN                 = '1'
          STPST                 = '0'
          SVWVO                 = 'X'
          WERKS                 = GS_PURCHASING-WERKS
          VRSVO                 = 'X'
        TABLES
          STB                   = LT_STB
        EXCEPTIONS
          ALT_NOT_FOUND         = 1
          CALL_INVALID          = 2
          MATERIAL_NOT_FOUND    = 3
          MISSING_AUTHORIZATION = 4
          NO_BOM_FOUND          = 5
          NO_PLANT_DATA         = 6
          NO_SUITABLE_BOM_FOUND = 7
          CONVERSION_ERROR      = 8
          OTHERS                = 9.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.


      SELECT SINGLE MENGE FROM EKPO INTO GV_MENGE1 WHERE EBELN = GS_PURCHASING-EBELN.




      "LT_LINES TYPE STANDARD TABLE OF TLINE,
      "WA_LINES TYPE TLINE.

*  DATA: LV_NAME TYPE TDOBNAME.
       DATA: LD_TEXT(1000) TYPE C.
*DATA: gv_text(1300) TYPE c.
      CLEAR : LT_LINES , WA_LINES , LV_NAME , lv_lines1 .
      CONCATENATE GS_ITEM-VBELN GS_ITEM-POSNR INTO LV_NAME.
*CONCATENATE

*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          ID        = 'Z888'
*          LANGUAGE  = 'E'
*          NAME      = LV_NAME
*          OBJECT    = 'VBBP'
**  IMPORTING
**         header    = ld_header
*        TABLES
*          LINES     = LT_LINES
*        EXCEPTIONS
*          ID        = 1
*          LANGUAGE  = 2
*          NAME      = 3
*          NOT_FOUND = 4
*          OBJECT    = 5.
*      IF SY-SUBRC <> 0.
*      ELSE.
*        LOOP AT LT_LINES INTO WA_LINES.
*                  LV_LENGTH = STRLEN( WA_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = WA_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*              IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*          CONCATENATE LD_TEXT LV_LINES INTO LD_TEXT.
*        ENDLOOP.
*      ENDIF.
*      GV_TEXT = LD_TEXT.
    lo_text_reader->read_text_string( EXPORTING id = 'Z888' name = LV_NAME object = 'VBBP' IMPORTING lv_lines = lv_lines1 ).

  GV_TEXT = lv_lines1.
 clear lv_lines1.

      CLEAR: LV_NAME,LT_LINES,WA_LINES,GV_MAT_TEXT ,lv_lines1.
      LV_NAME = GS_PURCHASING-MATNR.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          ID        = 'GRUN'
*          LANGUAGE  = 'E'
*          NAME      = LV_NAME
*          OBJECT    = 'MATERIAL'
**  IMPORTING
**         header    = ld_header
*        TABLES
*          LINES     = LT_LINES
*        EXCEPTIONS
*          ID        = 1
*          LANGUAGE  = 2
*          NAME      = 3
*          NOT_FOUND = 4
*          OBJECT    = 5.
*      IF SY-SUBRC <> 0.
*      ELSE.
*
*        LOOP AT LT_LINES INTO WA_LINES.
*                  LV_LENGTH = STRLEN( WA_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = WA_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*              IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*          CONCATENATE GV_MAT_TEXT LV_LINES INTO GV_MAT_TEXT SEPARATED BY CL_ABAP_CHAR_UTILITIES=>NEWLINE.
*          CLEAR LV_LINES.
*        ENDLOOP.
*      ENDIF.
       lo_text_reader->read_text_string( EXPORTING id = 'GRUN' name = LV_NAME object = 'MATERIAL' IMPORTING lv_lines = lv_lines1 ).
      GV_MAT_TEXT = lv_lines1.
    clear lv_lines1.


*-----------------------------------------------------------------------------------*
      LOOP AT LT_LINES INTO LS_LINE.
        CLEAR :LV_NAME,LT_LINES,LS_LINE,GV_NOTE_X,MAT_LT_LINES.
        LV_NAME = GS_PURCHASING-MATNR.
*        CALL FUNCTION 'READ_TEXT'
*          EXPORTING
**           CLIENT                  = SY-MANDT
*            ID                      = 'GRUN'
*            LANGUAGE                = 'S'
*            NAME                    = LV_NAME
*            OBJECT                  = 'MATERIAL'
**           ARCHIVE_HANDLE          = 0
**           LOCAL_CAT               = ' '
** IMPORTING
**           HEADER                  =
**           OLD_LINE_COUNTER        =
*          TABLES
*            LINES                   = MAT_LT_LINES
*          EXCEPTIONS
*            ID                      = 1
*            LANGUAGE                = 2
*            NAME                    = 3
*            NOT_FOUND               = 4
*            OBJECT                  = 5
*            REFERENCE_CHECK         = 6
*            WRONG_ACCESS_TO_ARCHIVE = 7
*            OTHERS                  = 8.
*        IF SY-SUBRC <> 0.
** Implement suitable error handling here
*        ELSE.
*
*          LOOP AT MAT_LT_LINES INTO LS_LINE.
*                    LV_LENGTH = STRLEN( LS_LINE-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = LS_LINE-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*              IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*            CONCATENATE GV_LINES  LV_LINES INTO GV_LINES SEPARATED BY CL_ABAP_CHAR_UTILITIES=>NEWLINE.
*          ENDLOOP.
** LOOP AT MAT_LT_LINES INTO LS_LINE.
**        CONCATENATE GV_LINES  LS_LINE-TDLINE INTO GV_LINES SEPARATED BY CL_ABAP_CHAR_UTILITIES=>NEWLINE.
**      ENDLOOP.
*        ENDIF.
          lo_text_reader->READ_TEXT_STRING_S( EXPORTING id = 'GRUN' name = LV_NAME object = 'MATERIAL' IMPORTING lv_lines = lv_lines1 ).
  GV_LINES  = lv_lines1.
  clear lv_lines1.
      ENDLOOP.
*      SORT IT_FINAL BY VBELN POSNR.
*
*      LOOP AT IT_FINAL INTO WA_FINAL.
*        GV_IS = GV_IS + 1.
*        READ TABLE GT_MARC INTO GS_MARC
*                     WITH KEY MATNR = WA_FINAL-MATNR.
*
*        CLEAR GV_ZEINR.
*        SELECT SINGLE ZEINR
*                FROM MARA
*                INTO GV_ZEINR
*                WHERE MATNR = WA_FINAL-MATNR.
*
*        TAX_AMT = WA_FINAL-NETWR + TAX_AMT.
*        CGST_TOT = WA_FINAL-CGST_AMT + CGST_TOT.
*        SGST_TOT = WA_FINAL-SGST_AMT + SGST_TOT.
*        IGST_TOT = WA_FINAL-IGST_AMT + IGST_TOT.
*
*
*
*        IF IGST_TOT IS NOT INITIAL.
*          CHECK_GST2 = 'IGST'.
*        ELSE.
*          CHECK_GST2 = 'CGST'.
*        ENDIF.
*
*        CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR INTO LV_NAME.
*CONCATENATE
*
*
*        CALL FUNCTION 'READ_TEXT'
*          EXPORTING
*            ID        = 'Z888'
*            LANGUAGE  = 'E'
*            NAME      = LV_NAME
*            OBJECT    = 'VBBP'
*  IMPORTING
*           header    = ld_header
*          TABLES
*            LINES     = LT_LINES
*          EXCEPTIONS
*            ID        = 1
*            LANGUAGE  = 2
*            NAME      = 3
*            NOT_FOUND = 4
*            OBJECT    = 5.
*        IF SY-SUBRC <> 0.
*        ELSE.
*          LOOP AT LT_LINES INTO WA_LINES.
*            CONCATENATE LD_TEXT WA_LINES-TDLINE INTO LD_TEXT.
*          ENDLOOP.
*        ENDIF.
*        GV_TEXT = LD_TEXT.
*
*
*        WA_FINAL-GV_ZEINR2 = GV_ZEINR.
*        WA_FINAL-GV_SR1 = GV_SR.
*        WA_FINAL-GV_IS1 = GV_IS.
*        WA_FINAL-STEUC = GS_MARC-STEUC.
*
*        MODIFY IT_FINAL FROM WA_FINAL  .
*        CLEAR : WA_FINAL.
*      ENDLOOP.

      DATA : IT_XKOMV  TYPE KOMV OCCURS 0 WITH HEADER LINE.
      "IT_TAXCON TYPE TAXCOM,
        "LS_EKKO TYPE EKKO,
        "LS_EKPO TYPE EKPO.
      DATA:
        LV_FKART      TYPE VBRK-FKART.


      SELECT SINGLE FKART INTO LV_FKART
              FROM VBRK
              WHERE VBELN = LS_BIL_INVOICE-HD_GEN-BIL_NUMBER.
      IF LV_FKART = 'ZSN'.
        SELECT SINGLE * FROM EKKO
                INTO LS_EKKO
                WHERE EBELN = GS_PURCHASING-EBELN.

        SELECT SINGLE * FROM EKPO
                INTO LS_EKPO
                WHERE EBELN = GS_PURCHASING-EBELN.

        CLEAR:
         IT_TAXCON,IT_XKOMV[].

        IT_TAXCON-BUKRS = LS_EKKO-BUKRS.
        IT_TAXCON-BUDAT = LS_EKKO-AEDAT.
        IT_TAXCON-BLDAT = LS_EKKO-BEDAT.
        IT_TAXCON-WAERS = LS_EKKO-WAERS.
        IT_TAXCON-HWAER = LS_EKKO-WAERS.
        IT_TAXCON-KPOSN = LS_EKPO-EBELP.
        IT_TAXCON-MWSKZ = LS_EKPO-MWSKZ.
        IT_TAXCON-WRBTR = LS_EKPO-NETWR.

        IT_TAXCON-XMWST = 'X'.
        IT_TAXCON-SHKZG =  'H'.
*  it_taxcon-txjcd = it_ekpo-txjcd.
        IT_TAXCON-LIFNR = LS_EKKO-LIFNR.
        IT_TAXCON-EKORG = LS_EKKO-EKORG.
        IT_TAXCON-EBELN = LS_EKPO-EBELN.
        IT_TAXCON-EBELP = LS_EKPO-EBELP.
        IT_TAXCON-MATNR = LS_EKPO-MATNR.
        IT_TAXCON-WERKS = LS_EKPO-WERKS.
        IT_TAXCON-MATKL = LS_EKPO-MATKL.
        IT_TAXCON-MEINS = LS_EKPO-MEINS.
        IT_TAXCON-MGLME = LS_EKPO-MENGE.
        IT_TAXCON-MTART = LS_EKPO-MTART.
        IT_TAXCON-LAND1 = LS_EKKO-LANDS.
        "**************************START OF FUNCTION CALCULATE TAX
        "ITEM****************************


        CALL FUNCTION 'CALCULATE_TAX_ITEM'   "This is tHe Function Module
          EXPORTING
            DIALOG              = 'DIAKZ'
            DISPLAY_ONLY        = 'X'
            I_TAXCOM            = IT_TAXCON
          TABLES
            T_XKOMV             = IT_XKOMV
          EXCEPTIONS
            MWSKZ_NOT_DEFINED   = 1
            MWSKZ_NOT_FOUND     = 2
            MWSKZ_NOT_VALID     = 3
            STEUERBETRAG_FALSCH = 4
            COUNTRY_NOT_FOUND   = 5
            OTHERS              = 6.

        READ TABLE IT_XKOMV" INTO ls_conditions
           WITH KEY KSCHL = 'JICR'. " AND
        IF SY-SUBRC IS INITIAL.
          TEXT = 'YES'.
        ENDIF.

        READ TABLE IT_XKOMV"  INTO ls_conditions
         WITH KEY KSCHL = 'ZCRN'. " AND
        IF SY-SUBRC IS INITIAL.
          TEXT = 'YES'.
        ENDIF.

        READ TABLE IT_XKOMV"  INTO ls_conditions
         WITH KEY KSCHL = 'JISR'. " AND
        IF SY-SUBRC IS INITIAL.
          TEXT = 'YES'.
        ENDIF.


        READ TABLE IT_XKOMV"  INTO ls_conditions
         WITH KEY KSCHL = 'ZSRN'. " AND
        IF SY-SUBRC IS INITIAL.
          TEXT = 'YES'.
        ENDIF.

        READ TABLE IT_XKOMV"  INTO ls_conditions
         WITH KEY KSCHL = 'ZIRN'. " AND
        IF SY-SUBRC IS INITIAL.
          TEXT = 'YES'.
        ENDIF.

        IF TEXT IS INITIAL.
          TEXT = 'NO'.
        ENDIF.

      ENDIF.


      GS_PURCHASING-VBELN = LS_EKKN-VBELN.
      GS_PURCHASING-VBELP = LS_EKKN-VBELP.
      GS_PURCHASING-LV_BRANCH1  = LV_BRANCH.
      GS_PURCHASING-GV_PC1  = GV_PC.
      GS_PURCHASING-GV_TEXT_LD1 = GV_TEXT_LD.
      GS_PURCHASING-GV_TEXT_TAG1 = GV_TEXT_TAG.
      GS_PURCHASING-GV_TEXT_TPI1  = GV_TEXT_TPI .
      GS_PURCHASING-GV_ZGAD1  = GV_ZGAD .
      GS_PURCHASING-LS_MARC1  = LS_MARC-DISPO .

      GS_PURCHASING-GV_RATE1 = GV_RATE.
      GS_PURCHASING-GV_MENGE2 = GV_MENGE.
      GS_PURCHASING-GV_MAT_TEXT1 =  GV_MAT_TEXT.
      GS_PURCHASING-GV_TEXT1  =  GV_TEXT .
      GS_PURCHASING-GV_ZEINR_R1  = GV_ZEINR_R .
*  GS_PURCHASING-GV_MAT  =  GV_MAT_ITEM.
*  GS_PURCHASING-GV_ZEINR2  =  GV_ZEINR.
      MODIFY GT_PURCHASING FROM GS_PURCHASING.
    ENDLOOP.


    SORT IT_FINAL BY VBELN POSNR.

      LOOP AT IT_FINAL INTO WA_FINAL.
        GV_IS = GV_IS + 1.
        READ TABLE GT_MARC INTO GS_MARC
                     WITH KEY MATNR = WA_FINAL-MATNR.

        CLEAR GV_ZEINR.
        SELECT SINGLE ZEINR
                FROM MARA
                INTO GV_ZEINR
                WHERE MATNR = WA_FINAL-MATNR.

        TAX_AMT = WA_FINAL-NETWR + TAX_AMT.
        CGST_TOT = WA_FINAL-CGST_AMT + CGST_TOT.
        SGST_TOT = WA_FINAL-SGST_AMT + SGST_TOT.
        IGST_TOT = WA_FINAL-IGST_AMT + IGST_TOT.



        IF IGST_TOT IS NOT INITIAL.
          CHECK_GST2 = 'IGST'.
        ELSE.
          CHECK_GST2 = 'CGST'.
        ENDIF.
clear : lv_name , lv_lines1.
        CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR INTO LV_NAME.
*CONCATENATE

*
*        CALL FUNCTION 'READ_TEXT'
*          EXPORTING
*            ID        = 'Z888'
*            LANGUAGE  = 'E'
*            NAME      = LV_NAME
*            OBJECT    = 'VBBP'
**  IMPORTING
**           header    = ld_header
*          TABLES
*            LINES     = LT_LINES
*          EXCEPTIONS
*            ID        = 1
*            LANGUAGE  = 2
*            NAME      = 3
*            NOT_FOUND = 4
*            OBJECT    = 5.
*        IF SY-SUBRC <> 0.
*        ELSE.
*          LOOP AT LT_LINES INTO WA_LINES.
*                    LV_LENGTH = STRLEN( WA_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = WA_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*              IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
*               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
*               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
*               LV_LATRS CA ''''''.
*
*            IF LV_LATRS EQ ' '.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES SEPARATED BY ' '.
*            ELSE.
*              CONCATENATE LV_LINES LV_LATRS1 INTO LV_LINES.
*            ENDIF.
*          ENDIF.
*        ENDDO.
*
*        CONDENSE LV_LINES.
*            CONCATENATE LD_TEXT LV_LINES INTO LD_TEXT.
*            CLEAR LV_LINES.
*          ENDLOOP.
*        ENDIF.
    lo_text_reader->read_text_string( EXPORTING id = 'Z888' name = LV_NAME object = 'VBBP' IMPORTING lv_lines = lv_lines1 ).

  GV_TEXT = lv_lines1.
    clear lv_lines1.
*        GV_TEXT = LD_TEXT.


        WA_FINAL-GV_ZEINR2 = GV_ZEINR.
        WA_FINAL-GV_SR1 = GV_SR.
        WA_FINAL-GV_IS1 = GV_IS.
        WA_FINAL-STEUC = GS_MARC-STEUC.

        MODIFY IT_FINAL FROM WA_FINAL  .
        CLEAR : WA_FINAL.
      ENDLOOP.


    IF IGST_TOT IS NOT INITIAL.
      CHECK_GST2 = 'IGST'.
    ELSE.
      CHECK_GST2 = 'CGST'.
    ENDIF.
break dvbasis.
    IF GT_PURCHASING IS NOT INITIAL AND IT_FINAL IS NOT INITIAL.
      IF CHECK_GST2 ='CGST'.
        LF_FORMNAME = 'ZSD_DELIVERY_CHALLAN_CGST'.
        LV_FM_NAME =  '/1BCDWB/SM00000168'.
      ELSE.
        LF_FORMNAME = 'ZSD_DELIVERY_CHALLAN_IGST'.
        LV_FM_NAME =  '/1BCDWB/SM00000169'.
      ENDIF.
    ENDIF.
    IF GT_PURCHASING IS INITIAL AND IT_FINAL IS NOT INITIAL.
      IF CHECK_GST2 ='CGST'.
        LF_FORMNAME = 'ZSD_DELIVERY_CHALLAN_WPO_CGST'.
        LV_FM_NAME =  '/1BCDWB/SM00000171'.
      ELSE.
        LF_FORMNAME = 'ZSD_DELIVERY_CHALLAN_IGST_WPO'.
        LV_FM_NAME =  ' /1BCDWB/SM00000170'.
      ENDIF .
    ENDIF.


LV_OUTPUT_PARAMS-DEVICE = 'PRINTER'.
LV_OUTPUT_PARAMS-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.

LV_OUTPUT_PARAMS-NODIALOG = 'X'.
LV_OUTPUT_PARAMS-PREVIEW = ''.
LV_OUTPUT_PARAMS-REQIMM = 'X'.

ELSE.
LV_OUTPUT_PARAMS-NODIALOG = ''.
LV_OUTPUT_PARAMS-PREVIEW = 'X'.

ENDIF.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        IE_OUTPUTPARAMS = LV_OUTPUT_PARAMS
*   EXCEPTIONS
*       CANCEL          = 1
*       USAGE_ERROR     = 2
*       SYSTEM_ERROR    = 3
*       INTERNAL_ERROR  = 4
*       OTHERS          = 5
      .
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        I_NAME     = LF_FORMNAME
      IMPORTING
        E_FUNCNAME = LV_FM_NAME
*       E_INTERFACE_TYPE           =
*       EV_FUNCNAME_INBOUND        =
      .
*    LV_OUTPUT_PARAMS-COPIES  = 4.
     data: lv_out TYPE string.
     lv_out = lv_output_params-COPIES.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
      CF_RETCODE = SY-SUBRC.
      PERFORM PROTOCOL_UPDATE.

    ENDIF.

    IF CF_RETCODE = 0.
      PERFORM CHECK_REPEAT.
      IF LS_COMPOSER_PARAM-TDCOPIES EQ 0.
        NAST_ANZAL = 1.
      ELSE.
        NAST_ANZAL = LS_COMPOSER_PARAM-TDCOPIES.
      ENDIF.
      LS_COMPOSER_PARAM-TDCOPIES = 1.

      DO NAST_ANZAL TIMES.
* In case of repetition only one time archiving
        IF SY-INDEX > 1 AND NAST-TDARMOD = 3.
          NAST_TDARMOD = NAST-TDARMOD.
          NAST-TDARMOD = 1.
          LS_COMPOSER_PARAM-TDARMOD = 1.
        ENDIF.
        IF SY-INDEX NE 1 AND REPEAT IS INITIAL.
          REPEAT = 'X'.
        ENDIF.
* BEGIN: Country specific extension for Hungary
        IF LV_CCNUM IS NOT INITIAL.
          IF NAST-REPID IS INITIAL.
            NAST-REPID = 1.
          ELSE.
            NAST-REPID = NAST-REPID + 1.
          ENDIF.
          NAST-PFLD1 = LV_CCNUM.
        ENDIF.
* END: Country specific extension for Hungary
* call smartform invoice



        DO LV_OUTPUT_PARAMS-COPIES TIMES.
          LV_CNT = LV_CNT + 1.
          IF GT_PURCHASING IS NOT INITIAL AND IT_FINAL IS NOT INITIAL.
            IF CHECK_GST2 = 'CGST'.

              CALL FUNCTION LV_FM_NAME "'/1BCDWB/SM00000168'
                EXPORTING
*                 /1BCDWB/DOCPARAMS        =
                  USER_SETTINGS  = SPACE
                  LS_BIL_INVOICE = LS_BIL_INVOICE
                  LV_COUNT       = LV_CNT
*   IMPORTING
*                 /1BCDWB/FORMOUTPUT       =
                EXCEPTIONS
                  USAGE_ERROR    = 1
                  SYSTEM_ERROR   = 2
                  INTERNAL_ERROR = 3
                  OTHERS         = 4.
              IF SY-SUBRC <> 0.
* Implement suitable error handling here
              ENDIF.

            ENDIF.

            IF CHECK_GST2 = 'IGST'.

              CALL FUNCTION LV_FM_NAME "'/1BCDWB/SM00000169'
                EXPORTING
*                 /1BCDWB/DOCPARAMS        =
                  USER_SETTINGS  = SPACE
                  LS_BIL_INVOICE = LS_BIL_INVOICE
                  LV_COUNT       = LV_CNT
*   IMPORTING
*                 /1BCDWB/FORMOUTPUT       =
                EXCEPTIONS
                  USAGE_ERROR    = 1
                  SYSTEM_ERROR   = 2
                  INTERNAL_ERROR = 3
                  OTHERS         = 4.
              IF SY-SUBRC <> 0.
* Implement suitable error handling here
              ENDIF.

            ENDIF.
          ENDIF.

          IF GT_PURCHASING IS INITIAL AND IT_FINAL IS NOT INITIAL.
            IF CHECK_GST2 = 'IGST'.
              CALL FUNCTION LV_FM_NAME "'/1BCDWB/SM00000170'
                EXPORTING
*                 /1BCDWB/DOCPARAMS        =
                  USER_SETTINGS  = SPACE
                  LS_BIL_INVOICE = LS_BIL_INVOICE
                  LV_COUNT       = LV_CNT
* IMPORTING
*                 /1BCDWB/FORMOUTPUT       =
                EXCEPTIONS
                  USAGE_ERROR    = 1
                  SYSTEM_ERROR   = 2
                  INTERNAL_ERROR = 3
                  OTHERS         = 4.
              IF SY-SUBRC <> 0.
* Implement suitable error handling here
              ENDIF.


            ENDIF.

            IF CHECK_GST2 = 'CGST'.
              CALL FUNCTION LV_FM_NAME "'/1BCDWB/SM00000171'
                EXPORTING
*                 /1BCDWB/DOCPARAMS        =
                  USER_SETTINGS  = SPACE
                  LS_BIL_INVOICE = LS_BIL_INVOICE
                  LV_COUNT       = LV_CNT
*   IMPORTING
*                 /1BCDWB/FORMOUTPUT       =
                EXCEPTIONS
                  USAGE_ERROR    = 1
                  SYSTEM_ERROR   = 2
                  INTERNAL_ERROR = 3
                  OTHERS         = 4.
              IF SY-SUBRC <> 0.
* Implement suitable error handling here
              ENDIF.

            ENDIF.

          ENDIF.
        ENDDO.
* get SmartForm spoolid and store it in the NAST protocoll
        DATA LS_SPOOLID LIKE LINE OF LS_JOB_INFO-SPOOLIDS.
        LOOP AT LS_JOB_INFO-SPOOLIDS INTO LS_SPOOLID.
          IF LS_SPOOLID NE SPACE.
            PERFORM PROTOCOL_UPDATE_SPOOL USING '342' LS_SPOOLID
                                                SPACE SPACE SPACE.
          ENDIF.
        ENDLOOP.
        LS_COMPOSER_PARAM-TDCOPIES = NAST_ANZAL.
        IF NOT NAST_TDARMOD IS INITIAL.
          NAST-TDARMOD = NAST_TDARMOD.
          CLEAR NAST_TDARMOD.
        ENDIF.
      ENDDO.
    ENDIF.

    CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             =
      EXCEPTIONS
        USAGE_ERROR    = 1
        SYSTEM_ERROR   = 2
        INTERNAL_ERROR = 3
        OTHERS         = 4.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.



  ENDIF.




















* determine smartform function module for invoice
*    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*      EXPORTING
*        formname           = lf_formname
**       variant            = ' '
**       direct_call        = ' '
*      IMPORTING
*        fm_name            = lf_fm_name
*      EXCEPTIONS
*        no_form            = 1
*        no_function_module = 2
*        OTHERS             = 3.
*    IF sy-subrc <> 0.
**   error handling
*      cf_retcode = sy-subrc.
*      PERFORM protocol_update.
*    ENDIF.
*  ENDIF.
*
*  IF cf_retcode = 0.
*    PERFORM check_repeat.
*    IF ls_composer_param-tdcopies EQ 0.
*      nast_anzal = 1.
*    ELSE.
*      nast_anzal = ls_composer_param-tdcopies.
*    ENDIF.
*    ls_composer_param-tdcopies = 1.
*
*    DO nast_anzal TIMES.
** In case of repetition only one time archiving
*      IF sy-index > 1 AND nast-tdarmod = 3.
*        nast_tdarmod = nast-tdarmod.
*        nast-tdarmod = 1.
*        ls_composer_param-tdarmod = 1.
*      ENDIF.
*      IF sy-index NE 1 AND repeat IS INITIAL.
*        repeat = 'X'.
*      ENDIF.
** BEGIN: Country specific extension for Hungary
*      IF lv_ccnum IS NOT INITIAL.
*        IF nast-repid IS INITIAL.
*          nast-repid = 1.
*        ELSE.
*          nast-repid = nast-repid + 1.
*        ENDIF.
*        nast-pfld1 = lv_ccnum.
*      ENDIF.
** END: Country specific extension for Hungary
** call smartform invoice
*      CALL FUNCTION  '/1BCDWB/SM00000076'
*        EXPORTING
**         /1BCDWB/DOCPARAMS        =
*          user_settings  = space
*          ls_bil_invoice = ls_bil_invoice
** IMPORTING
**         /1BCDWB/FORMOUTPUT       =
*        EXCEPTIONS
*          usage_error    = 1
*          system_error   = 2
*          internal_error = 3
*          OTHERS         = 4.
*      IF sy-subrc <> 0.
**   error handling
*        cf_retcode = sy-subrc.
*        PERFORM protocol_update.
** get SmartForm protocoll and store it in the NAST protocoll
*        PERFORM add_smfrm_prot.
*      ENDIF.
*    ENDDO.
** get SmartForm spoolid and store it in the NAST protocoll
*    DATA ls_spoolid LIKE LINE OF ls_job_info-spoolids.
*    LOOP AT ls_job_info-spoolids INTO ls_spoolid.
*      IF ls_spoolid NE space.
*        PERFORM protocol_update_spool USING '342' ls_spoolid
*                                            space space space.
*      ENDIF.
*    ENDLOOP.
*    ls_composer_param-tdcopies = nast_anzal.
*    IF NOT nast_tdarmod IS INITIAL.
*      nast-tdarmod = nast_tdarmod.
*      CLEAR nast_tdarmod.
*    ENDIF.
*
*  ENDIF.

* get SmartForm protocoll and store it in the NAST protocoll
* PERFORM ADD_SMFRM_PROT.

ENDFORM.                    "PROCESSING
