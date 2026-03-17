
REPORT ZEXPORT_ORDER_PROG.
TABLES: NAST,                          "Messages
        *NAST,                         "Messages
        TNAPR,                         "Programs & Forms
        ITCPO,                         "Communicationarea for Spool
        ARC_PARAMS,                    "Archive parameters
        TOA_DARA,                      "Archive parameters
        ADDR_KEY,                      "Adressnumber for ADDRESS
        VBAK.
*DATA(lo_text_reader) = NEW zcl_read_text( ).
INCLUDE ZEXPORT_ORDER.

DATA : SO_CODE LIKE VBAK-VBELN.
DATA : BASIC_AMT TYPE P DECIMALS 2.
DATA : TOTAL TYPE P DECIMALS 2.
DATA : ZKBETR TYPE PRCD_ELEMENTS-KBETR.
DATA : HTEXT(40) TYPE C.
DATA : LV_LINES1 TYPE TLINE.
DATA : LV_MEMO TYPE TLINE.
DATA : LV_INSURANCE TYPE TLINE.
DATA : LV_MOD TYPE TLINE.
DATA : LV_DOCT TYPE TLINE.           " DOCUMENTS THROUGH
DATA : LV_SINST TYPE TLINE.          " SPECIAL INSTRUCTION
DATA : LV_LDDATE TYPE TLINE.
DATA : V_AMT TYPE CHAR100.
DATA : GRAND_TOTAL  TYPE P DECIMALS 2.
DATA : JOIG TYPE STRING.
DATA : TOT_QTY TYPE VBAP-KWMENG.
DATA : JOCG_AMT TYPE P DECIMALS 2.
DATA : JOSG_AMT TYPE P DECIMALS 2.
DATA : GV_KBETR TYPE KBETR .
DATA : GV_KBETR2 TYPE KBETR .



DATA : GS_CTRLOP  TYPE SSFCTRLOP,
       GS_OUTOPT  TYPE SSFCOMPOP,
       GS_OTFDATA TYPE SSFCRESCL.

DATA : CONTROL         TYPE SSFCTRLOP.
DATA : OUTPUT_OPTIONS  TYPE SSFCOMPOP.
DATA:   RETCODE   LIKE SY-SUBRC.         "Returncode
DATA:   XSCREEN(1) TYPE C.               "Output on printer or screen
DATA:   REPEAT(1) TYPE C.
DATA: NAST_ANZAL LIKE NAST-ANZAL.      "Number of outputs (Orig. + Cop.)
DATA: NAST_TDARMOD LIKE NAST-TDARMOD.  "Archiving only one time

DATA: GF_LANGUAGE LIKE SY-LANGU.
DATA: SO_DOC_EXP    LIKE     VBCO3.
DATA : GV_DEL_DT TYPE CHAR11.
DATA : SHIP_CODE TYPE STRING.
DATA : LV_TEXT TYPE STRING.
DATA: LV_LENGTH     TYPE STRING.
DATA: LV_LATRS      TYPE C.
DATA: LV_LATRS1     TYPE C.
DATA: LV_INDEX      TYPE SY-INDEX.
DATA: LV_SAFE_LEN   TYPE SY-INDEX.
DATA: LV_LINES      TYPE STRING.
DATA: LV_SPACE      TYPE STRING.
DATA: LV_SPACE1     TYPE STRING.
DATA: LV_SPACE2     TYPE STRING.

FORM ENTRY  USING RETURN_CODE US_SCREEN.
*  break primus.
  CLEAR RETCODE.
  XSCREEN = US_SCREEN.

  PERFORM PROCESSING USING US_SCREEN.
  CASE RETCODE.
    WHEN 0.
      RETURN_CODE = 0.
    WHEN 3.
      RETURN_CODE = 3.
    WHEN OTHERS.
      RETURN_CODE = 1.
  ENDCASE.
ENDFORM.

FORM PROCESSING USING US_SCREEN.

  SO_DOC_EXP-SPRAS = 'E'.
  SO_DOC_EXP-VBELN = NAST-OBJKY.

  SO_CODE = NAST-OBJKY.
  PERFORM CLEAR.
  PERFORM GET_DATA.
  PERFORM PROCESS_DATA.
  PERFORM GRANDWORDS.
  PERFORM GET_OFMDATE.
  PERFORM GET_MEMO.
  PERFORM SMARTFROM_DATA.

ENDFORM.

FORM GET_DATA .

  SELECT
    VBELN
    KUNNR
    ERDAT
    VDATU
    WAERK
    AUART
    KNUMV
    ZLDFROMDATE
    FROM VBAK
    INTO TABLE IT_VBAK
    WHERE VBELN = SO_CODE.
*break primus.
*  IF it_vbak IS NOT INITIAL.
  SELECT
    VBELN
    KUNNR
    PARVW
    FROM VBPA
    INTO TABLE IT_VBPA
    FOR ALL ENTRIES IN IT_VBAK
    WHERE VBELN EQ IT_VBAK-VBELN AND PARVW = 'WE'.
*  ENDIF.
*BREAK PRIMUS.
*  IF it_vbak IS NOT INITIAL.
  SELECT
    VBELN
    KUNNR
    PARVW
    FROM VBPA
    INTO TABLE IT_VBPA1
    FOR ALL ENTRIES IN IT_VBAK
    WHERE VBELN EQ IT_VBAK-VBELN AND PARVW = 'AG'.
*  ENDIF.
*break primus.
  IF IT_VBPA IS NOT INITIAL.
    SELECT
      KUNNR
      NAME1
      PSTLZ
      ORT01
      STCD3
      FROM KNA1
      INTO TABLE IT_KNA12
      FOR ALL ENTRIES IN IT_VBPA
      WHERE KUNNR EQ IT_VBPA-KUNNR1.


  ENDIF.

  IF IT_VBPA1 IS NOT INITIAL.

    SELECT
      KUNNR
      NAME1
      NAME2
      PSTLZ
      ORT01
      STCD3
      FROM KNA1
      INTO TABLE IT_KNA1
*      FOR ALL ENTRIES IN it_vbak
*      WHERE kunnr EQ it_vbak-kunnr.
      FOR ALL ENTRIES IN IT_VBPA1
      WHERE KUNNR EQ IT_VBPA1-KUNNR3.
  ENDIF.

  IF IT_KNA1 IS NOT INITIAL.
    SELECT
      VBELN
      BSTKD
      BSTDK
      FROM VBKD
      INTO  TABLE IT_VBKD
      FOR ALL ENTRIES IN IT_VBAK
      WHERE VBELN EQ IT_VBAK-VBELN.
  ENDIF.

  IF IT_VBAK IS NOT INITIAL.
    SELECT
      VBELN
      POSNR
      MATNR
      ARKTX
      MEINS
      KWMENG
      ZMENG
      DELDATE
      NETPR
      NETWR
      ABGRU
      KZWI1
      FROM VBAP
      INTO TABLE IT_VBAP
      FOR ALL ENTRIES IN IT_VBAK
      WHERE VBELN EQ IT_VBAK-VBELN
      AND  ( REASON NE '02' AND REASON NE '11' )..
  ENDIF.

  SELECT
    VBELN
    ZTERM
    FROM VBKD
    INTO TABLE IT_VBKD1
    FOR ALL ENTRIES IN IT_VBAP
    WHERE VBELN EQ IT_VBAP-VBELN.

  SELECT
    ZTERM
    VTEXT
    SPRAS
    FROM TVZBT
    INTO TABLE IT_TVZBT
    FOR ALL ENTRIES IN IT_VBKD1
    WHERE ZTERM EQ IT_VBKD1-ZTERM AND
    SPRAS = 'E'.

  SELECT
    VBELV
    VBELN
    VBTYP_N
    FROM VBFA
    INTO TABLE IT_VBFA
    FOR ALL ENTRIES IN IT_VBAK
    WHERE VBELV EQ IT_VBAK-VBELN AND VBTYP_N = 'M'.

*  IF it_vbfa IS NOT INITIAL.
*    SELECT
*      vbeln
*      knumv
*      FROM vbrk
*      INTO TABLE it_vbrk
*      FOR ALL ENTRIES IN it_vbfa
*      WHERE vbeln EQ it_vbfa-vbeln1.
*  ENDIF.
*BREAK PRIMUS.
*  IF it_vbrk IS NOT INITIAL.
  SELECT
    KNUMV
    KPOSN
    KSCHL
    KBETR
    KNTYP
    KWERT
    FROM PRCD_ELEMENTS
    INTO TABLE IT_KONV
    FOR ALL ENTRIES IN IT_VBAK
    WHERE KNUMV EQ IT_VBAK-KNUMV.
*  ENDIF.

  SELECT
  KNUMV
*  kbetr
*    kschl
  KNTYP
*  kwert
  FROM PRCD_ELEMENTS
  INTO TABLE IT_KONV1
  FOR ALL ENTRIES IN IT_VBAK
  WHERE KNUMV EQ IT_VBAK-KNUMV AND KNTYP = 'D' .
ENDFORM.

FORM PROCESS_DATA .

  DATA(LO_TEXT_READER) = NEW ZCL_READ_TEXT( ).
  DATA LV_LINES1 TYPE STRING.
  DATA: US_CODE TYPE CHAR50.
  SELECT * FROM MARA
  INTO TABLE @DATA(IT_MARA)
  FOR ALL ENTRIES IN @IT_VBAP
  WHERE MATNR = @IT_VBAP-MATNR.
  IF US_CODE IS NOT INITIAL.
    CONCATENATE '(' US_CODE ')' INTO US_CODE.
    CONDENSE US_CODE.
  ENDIF.

  DATA: LV_NAME     TYPE THEAD-TDNAME,
        IT_LINES    TYPE ZTLINE_TBL,
        WA_LINES    TYPE TLINE,
        WA_MAT_TEXT TYPE CHAR255.

  SORT IT_VBAP BY POSNR.
  LOOP AT IT_VBAP INTO WA_VBAP.

    WA_FINAL-VBELN   = WA_VBAP-VBELN.
    WA_FINAL-POSNR   = WA_VBAP-POSNR.
    WA_FINAL-MATNR   = WA_VBAP-MATNR.
    CLEAR: IT_LINES,WA_LINES, LV_NAME,WA_MAT_TEXT.
    REFRESH IT_LINES.
    LV_NAME = WA_FINAL-MATNR.

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = 'GRUN'
*        LANGUAGE                = SY-LANGU
*        NAME                    = LV_NAME
*        OBJECT                  = 'MATERIAL'
*      TABLES
*        LINES                   = IT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
**    IF IT_LINES IS NOT INITIAL.
**      LOOP AT IT_LINES INTO WA_LINES.
**        IF NOT WA_LINES-TDLINE IS INITIAL.
**          CONCATENATE WA_MAT_TEXT WA_LINES-TDLINE INTO WA_MAT_TEXT SEPARATED BY SPACE.
**        ENDIF.
**        CONDENSE WA_MAT_TEXT.
**      ENDLOOP.
**    ENDIF.
*        CONCATENATE LV_SPACE1 LV_SPACE2 INTO LV_SPACE SEPARATED BY CL_ABAP_CHAR_UTILITIES=>NEWLINE.
*    CONDENSE LV_SPACE.
*
*    IF IT_LINES IS NOT INITIAL.
*      LOOP AT IT_LINES INTO WA_LINES.
*        LV_LENGTH = STRLEN( WA_LINES-TDLINE ).
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
*      ENDLOOP.
*    ENDIF.
    CLEAR:LV_LINES1 .
    LO_TEXT_READER->READ_TEXT_STRING( EXPORTING ID = 'GRUN' NAME = LV_NAME OBJECT = 'MATERIAL' IMPORTING LV_LINES = LV_LINES1 ).

*    WA_MAT_TEXT  = LV_LINES.
    WA_MAT_TEXT  = LV_LINES1.

    IF WA_MAT_TEXT IS NOT INITIAL.
      WA_FINAL-ARKTX = WA_MAT_TEXT.
    ELSE.
      WA_FINAL-ARKTX = WA_VBAP-ARKTX.
    ENDIF.
*BREAK ctpl.
    WA_FINAL-MEINS   = WA_VBAP-MEINS  .
    WA_FINAL-KWMENG  = WA_VBAP-KWMENG .
    WA_FINAL-ZMENG  = WA_VBAP-ZMENG .
    WA_FINAL-DELDATE = WA_VBAP-DELDATE.
*    WA_FINAL-NETPR   = WA_VBAP-NETPR  .           "COMMENTED BY MAHADEV SUVRNA ON 08.01.2025
*    WA_FINAL-NETWR   = WA_VBAP-NETWR  .              "COMMENTED BY MAHADEV SUVRNA ON 08.01.2025
    WA_FINAL-NETWR   = WA_VBAP-KZWI1  .


    WA_FINAL-ABGRU   = WA_VBAP-ABGRU.
    IF WA_VBAP-ABGRU IS NOT INITIAL.
      DELETE IT_VBAP WHERE ABGRU IS NOT INITIAL.
      CONTINUE.
      WA_FINAL-ABGRU   = WA_VBAP-ABGRU.
    ENDIF.

    READ TABLE IT_VBPA1 INTO WA_VBPA1 WITH KEY VBELN = WA_FINAL-VBELN." wa_final
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR = WA_VBPA1-KUNNR3.
      CLEAR WA_VBPA1.
    ENDIF.
    """"""added by md
    IF WA_FINAL-KWMENG IS NOT INITIAL.
      WA_FINAL-TOT_QTY =  WA_FINAL-TOT_QTY +  WA_FINAL-KWMENG.
    ELSE.
      WA_FINAL-TOT_QTY =  WA_FINAL-TOT_QTY +  WA_FINAL-ZMENG.
    ENDIF.

    READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_FINAL-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-VBELN = WA_VBPA-VBELN.
      WA_FINAL-KUNNR1 = WA_VBPA-KUNNR1.
      WA_FINAL-PARVW = WA_VBPA-PARVW.
    ENDIF.

    READ TABLE IT_KNA12 INTO WA_KNA12 WITH KEY KUNNR2 = WA_FINAL-KUNNR1 BINARY SEARCH.
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR2 = WA_KNA12-KUNNR2.
      WA_FINAL-NAME12 = WA_KNA12-NAME12.
      WA_FINAL-PSTLZ1 = WA_KNA12-PSTLZ1.
      WA_FINAL-ORT012 = WA_KNA12-ORT012.
      WA_FINAL-STCD31 = WA_KNA12-STCD31.
    ENDIF.

    READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_FINAL-KUNNR.
    IF SY-SUBRC EQ 0 .
      WA_FINAL-KUNNR = WA_KNA1-KUNNR.
      WA_FINAL-NAME1 = WA_KNA1-NAME1.
      WA_FINAL-NAME2 = WA_KNA1-NAME2.
      WA_FINAL-PSTLZ = WA_KNA1-PSTLZ.
      WA_FINAL-ORT01 = WA_KNA1-ORT01.
      WA_FINAL-STCD3 = WA_KNA1-STCD3.
    ENDIF.

    READ TABLE IT_VBKD INTO WA_VBKD WITH  KEY VBELN = WA_FINAL-VBELN BINARY SEARCH.
    IF SY-SUBRC EQ 0 .
      WA_FINAL-VBELN = WA_VBKD-VBELN.
      WA_FINAL-BSTKD = WA_VBKD-BSTKD.
      WA_FINAL-BSTDK = WA_VBKD-BSTDK.
    ENDIF.

    READ TABLE IT_VBAK INTO WA_VBAK WITH  KEY VBELN = WA_FINAL-VBELN BINARY SEARCH.
* LOOP AT IT_VBAP INTO WA_VBAP.
    IF SY-SUBRC EQ 0.
      WA_FINAL-VBELN = WA_VBAK-VBELN.
      WA_FINAL-KUNNR = WA_VBAK-KUNNR.
      WA_FINAL-ERDAT = WA_VBAK-ERDAT.
      WA_FINAL-VDATU = WA_VBAK-VDATU.
      WA_FINAL-WAERK = WA_VBAK-WAERK.
      WA_FINAL-AUART = WA_VBAK-AUART.
      WA_FINAL-KNUMV = WA_VBAK-KNUMV.
      WA_FINAL-ZLDFROMDATE = WA_VBAK-ZLDFROMDATE.

      WA_FINAL-BASIC_AMT = WA_FINAL-BASIC_AMT + WA_FINAL-NETWR .
    ENDIF.

    READ TABLE IT_VBFA INTO WA_VBFA WITH KEY VBELV = WA_FINAL-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-VBELV = WA_VBFA-VBELV.
      WA_FINAL-VBELN1 = WA_VBFA-VBELN1.
      WA_FINAL-VBTYP_N = WA_VBFA-VBTYP_N.
    ENDIF.


*BREAK CTPL.
    LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_VBAK-KNUMV AND KPOSN = WA_VBAP-POSNR AND KSCHL = 'ZPR0' .
      WA_FINAL-NETPR   = WA_KONV-KBETR.
    ENDLOOP.
    LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_VBAK-KNUMV AND KPOSN = WA_VBAP-POSNR .
*      IF WA_KONV-KSCHL = 'ZPR0'.
*
*        WA_FINAL-NETPR   = WA_KONV-KBETR.
*      ENDIF.

      IF WA_KONV-KSCHL = 'ZPFO'.
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
        WA_FINAL-KBETR =  WA_KONV-KBETR.
        WA_FINAL-KWERT =  WA_KONV-KWERT.
         WA_FINAL-NETWR =  WA_FINAL-NETWR + WA_KONV-KWERT.


      ELSEIF WA_KONV-KSCHL = 'ZIN1' .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
        WA_FINAL-KBETR1 =  WA_KONV-KBETR.

*      ELSEIF WA_KONV-KSCHL = 'ZFR1'  .     " commented by mahadev suvrna on 13/01/2025
*        WA_FINAL-KNUMV = WA_KONV-KNUMV.
*        WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        WA_FINAL-KBETR2 =  WA_KONV-KBETR.

      ELSEIF WA_KONV-KSCHL = 'ZFR1'  .     " Added on 02.03.2026 by bk "
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
        WA_FINAL-KBETR2 =  WA_KONV-KBETR.

      ELSEIF WA_KONV-KSCHL = 'ZTE1'  .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
        WA_FINAL-KBETR3 =  WA_KONV-KBETR.

      ELSEIF WA_KONV-KSCHL = 'ZTCS' .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
        WA_FINAL-KBETR4 =  WA_KONV-KBETR. "WA_KONV-KBETR.
        WA_FINAL-KBETR4 =  WA_KONV-KWERT.
        CLEAR : GV_KBETR2, GV_KBETR.
      ELSEIF WA_KONV-KSCHL = 'ZDIS' .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        WA_FINAL-KBETR5 =  WA_KONV-KBETR. "WA_KONV-KBETR.
        WA_FINAL-KBETR5 = ABS( WA_KONV-KBETR ).
*        WA_FINAL-KBETR9 =  WA_KONV-KWERT.
        GV_KBETR2 = WA_FINAL-NETPR * WA_KONV-KBETR / 100  .  "Added by mahadev SUVRNA on 04/12/2025
        GV_KBETR = WA_FINAL-NETPR - ( - GV_KBETR2 ). " - ( - WA_KONV-KBETR ).
        WA_FINAL-KBETR9 = GV_KBETR.
        WA_FINAL-NETWR =  WA_FINAL-NETWR + WA_KONV-KWERT.

        IF WA_FINAL-KWMENG IS NOT INITIAL.
*          WA_FINAL-NETWR   = WA_FINAL-NETPR * WA_FINAL-KWMENG  . "COMMENTED BY MAHADEV SUVARNA ON 04 /12/2025
*          WA_FINAL-NETWR   = WA_FINAL-KBETR9 * WA_FINAL-KWMENG  . "COMMENTED BY MAHADEV SUVARNA ON 12/1/2025
        ELSE.
          WA_FINAL-NETWR   = WA_FINAL-NETPR * WA_FINAL-ZMENG  ." added by md
        ENDIF.
*      ENDIF.
*endloop.
*LOOP AT it_konv1 INTO wa_konv1. .
      ELSEIF WA_KONV-KSCHL = 'JOIG' AND WA_KONV-KNTYP = 'D'.
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-JOIG = WA_KONV-KBETR. " / 10 .

*  CONCATENATE 'IGST' WA_FINAL-JOIG '%' INTO JOIG SEPARATED BY ' '.

      ELSEIF WA_KONV-KSCHL = 'JOCG' AND WA_KONV-KNTYP = 'D'.
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-JOCG = WA_KONV-KBETR . "/ 10 .

      ELSEIF WA_KONV-KSCHL = 'JOSG' AND WA_KONV-KNTYP = 'D'.
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-JOSG = WA_KONV-KBETR . " / 10 .
      ENDIF.
    ENDLOOP.
*    ON CHANGE OF wa_vbap-vbeln .
*on CHANGE OF wa_vbak-vbeln.
    IF WA_FINAL-JOIG IS NOT INITIAL.
      LOOP AT IT_KONV1 INTO WA_KONV1.
        WA_FINAL-KNUMV = WA_KONV1-KNUMV.
*  WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kwert =  wa_konv1-kwert.
*        wa_final-total1 =  wa_final-total1 + wa_final-kwert .
        WA_FINAL-TOTAL1 = ( WA_FINAL-BASIC_AMT * WA_FINAL-JOIG ) / 100.
      ENDLOOP.
    ENDIF.
    IF  WA_FINAL-JOCG IS NOT INITIAL AND WA_FINAL-JOSG IS NOT INITIAL.
      LOOP AT IT_KONV1 INTO WA_KONV1.
        WA_FINAL-KNUMV = WA_KONV1-KNUMV.
*  WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kwert =  wa_konv1-kwert.
*        wa_final-total1 =  wa_final-total1 + wa_final-kwert .
        WA_FINAL-JOCG_AMT = ( WA_FINAL-BASIC_AMT * WA_FINAL-JOCG ) / 100 .
        WA_FINAL-JOSG_AMT = ( WA_FINAL-BASIC_AMT * WA_FINAL-JOSG ) / 100 .
*wa_final-total1 = wa_final-jocg_amt + wa_final-josg_amt.

      ENDLOOP.
    ENDIF.

*    ENDON.

    WA_FINAL-TOTAL =  WA_FINAL-BASIC_AMT + WA_FINAL-KBETR + WA_FINAL-KBETR1 + WA_FINAL-KBETR2 + WA_FINAL-KBETR3 + WA_FINAL-KBETR4.
    IF WA_FINAL-JOIG IS NOT INITIAL.
      WA_FINAL-GRAND =  WA_FINAL-TOTAL + WA_FINAL-TOTAL1.
    ENDIF.
    IF  WA_FINAL-JOCG IS NOT INITIAL AND WA_FINAL-JOSG IS NOT INITIAL.
      WA_FINAL-GRAND =  WA_FINAL-TOTAL + WA_FINAL-JOCG_AMT + WA_FINAL-JOSG_AMT.
    ENDIF.
    IF WA_FINAL-AUART = 'ZDEX' OR WA_FINAL-AUART = 'ZEXP'.
      WA_FINAL-GRAND =  WA_FINAL-TOTAL.
    ENDIF.
    GRAND_TOTAL = WA_FINAL-BASIC_AMT.

    READ TABLE IT_VBKD1 INTO WA_VBKD1 WITH KEY VBELN = WA_FINAL-VBELN BINARY SEARCH.
    IF SY-SUBRC = 0.
      WA_FINAL-VBELN = WA_VBKD1-VBELN.
      WA_FINAL-ZTERM = WA_VBKD1-ZTERM.
    ENDIF.

    READ TABLE IT_TVZBT INTO WA_TVZBT WITH KEY ZTERM = WA_FINAL-ZTERM.
    IF SY-SUBRC = 0.
      WA_FINAL-ZTERM = WA_TVZBT-ZTERM.
      WA_FINAL-VTEXT = WA_TVZBT-VTEXT.
    ENDIF.

    READ TABLE IT_MARA INTO DATA(WA_MARA) WITH KEY  MATNR = WA_VBAP-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-STRAS = WA_MARA-WRKST.
    ENDIF.

    DATA : WA_VBAP1 TYPE VBAP.
    DATA : CUST_DT TYPE CHAR11.
    SELECT SINGLE * FROM VBAP INTO WA_VBAP1
    WHERE VBELN = WA_FINAL-VBELN AND POSNR = WA_FINAL-POSNR.

    CLEAR: CUST_DT.
    IF WA_VBAP1-CUSTDELDATE IS NOT INITIAL.

      CONCATENATE  WA_VBAP1-CUSTDELDATE+4(2) WA_VBAP1-CUSTDELDATE+6(2) WA_VBAP1-CUSTDELDATE+0(4)
                      INTO CUST_DT SEPARATED BY '-'.
    ENDIF.

    WA_FINAL-CUST_DT = CUST_DT.
    CLEAR: IT_LINES,WA_LINES,LV_NAME,SHIP_CODE , LV_LINES.
    CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR INTO LV_NAME.

    REFRESH IT_LINES.

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = '0010'
*        LANGUAGE                = SY-LANGU
*        NAME                    = LV_NAME
*        OBJECT                  = 'VBBP'
*      TABLES
*        LINES                   = IT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
*
*    IF IT_LINES IS NOT INITIAL.
*      LOOP AT IT_LINES INTO WA_LINES.
*
**        CONCATENATE SHIP_CODE WA_LINES-TDLINE INTO SHIP_CODE .
**        WA_FINAL-SHIP_CODE = SHIP_CODE.
*        LV_LENGTH = STRLEN( WA_LINES-TDLINE ).
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
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
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
*
*       WA_FINAL-SHIP_CODE = LV_LINES.
*      ENDLOOP.
    LO_TEXT_READER->READ_TEXT_STRING( EXPORTING ID = '0010' NAME = LV_NAME OBJECT = 'VBBP' IMPORTING LV_LINES = DATA(LV_LINES3) ).

*WA_FINAL-SHIP_CODE = lv_lines1.
    WA_FINAL-SHIP_CODE = LV_LINES3.

    IF WA_FINAL-SHIP_CODE IS NOT INITIAL.
      CONCATENATE '('SHIP_CODE ')' INTO SHIP_CODE.
      CONDENSE SHIP_CODE.
    ENDIF.
*    ENDIF.
*    WA_FINAL-SHIP_CODE = SHIP_CODE.

    CLEAR: IT_LINES,WA_LINES,LV_NAME.
    CONCATENATE WA_FINAL-VBELN WA_FINAL-POSNR INTO LV_NAME.
*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = '0001'
*        LANGUAGE                = SY-LANGU
*        NAME                    = LV_NAME
*        OBJECT                  = 'VBBP'
**       ARCHIVE_HANDLE          = 0
**       LOCAL_CAT               = ' '
**       USE_OLD_PERSISTENCE     = ABAP_FALSE
** IMPORTING
**       HEADER                  =
**       OLD_LINE_COUNTER        =
*      TABLES
*        LINES                   = IT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** Implement suitable error handling here
*    ENDIF.
*
*
*
*
*    CONCATENATE LV_SPACE1 LV_SPACE2 INTO LV_SPACE SEPARATED BY CL_ABAP_CHAR_UTILITIES=>NEWLINE.
*    CONDENSE LV_SPACE.
*
*    IF IT_LINES IS NOT INITIAL.
*      LOOP AT IT_LINES INTO WA_LINES.
*        LV_LENGTH = STRLEN( WA_LINES-TDLINE ).
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
*
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
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
*      ENDLOOP.
*    ENDIF.
*
**    REPLACE ALL OCCURENCES OF '#' IN LV_LINES WITH SPACE.
*    REPLACE ALL OCCURRENCES OF '*' IN LV_LINES WITH ''.
*    REPLACE ALL OCCURENCES OF '<(>' IN LV_LINES WITH ''.
*    REPLACE ALL OCCURENCES OF '<)>' IN LV_LINES WITH ''.
*
*    CONDENSE  LV_LINES.
*    WA_FINAL-LV_TEXT = LV_LINES.
    LO_TEXT_READER->READ_TEXT_STRING( EXPORTING ID = '0001' NAME = LV_NAME OBJECT = 'VBBP' IMPORTING LV_LINES = DATA(LV_LINES2) ).
    WA_FINAL-LV_TEXT = LV_LINES2.

    APPEND WA_FINAL TO IT_FINAL.
*delete it_final where abgru is NOT INITIAL.
    CLEAR WA_FINAL.
    CLEAR: SHIP_CODE ,LV_TEXT ,LV_LINES.
  ENDLOOP.

*  clear wa_final-total1.

ENDFORM.


FORM GRANDWORDS.
  CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
    EXPORTING
      AMT_IN_NUM         = GRAND_TOTAL
    IMPORTING
      AMT_IN_WORDS       = V_AMT
    EXCEPTIONS
      DATA_TYPE_MISMATCH = 1
      OTHERS             = 2.

*  CALL FUNCTION 'ISP_CONVERT_FIRSTCHARS_TOUPPER'
*    EXPORTING
*      input_string  = v_amt
*      separators    = ' '
*    IMPORTING
*      output_string = v_amt.

ENDFORM.

FORM GET_OFMDATE.
  DATA(LO_TEXT_READER) = NEW ZCL_READ_TEXT( ).
  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.
  CLEAR : LV_LINES .
  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = 'Z016'
*        LANGUAGE                = 'E'
*        NAME                    = VBELN_1
*        OBJECT                  = 'VBBK'
*      TABLES
*        LINES                   = GT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT GT_LINES INTO LS_LINES.
*      READ TABLE GT_LINES INTO LS_LINES INDEX 1.  "Added by Awais on 03.11.2023(DEVK912485)
*      LV_LENGTH = STRLEN( LS_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = LS_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
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
*      CONDENSE LV_LINES.
*      IF SY-SUBRC EQ 0.
**        LV_LINES1 = LS_LINES-TDLINE.
**        WA_FINAL-LV_LINES1 = LV_LINES1 .
*        LV_LINES1 = LV_LINES.
*        WA_FINAL-LV_LINES1 = LV_LINES1 .
*      ENDIF.                                      "Ended by Awais on 03.11.2023(DEVK912485)
*    ENDLOOP.
    LO_TEXT_READER->READ_TEXT_STRING( EXPORTING ID = 'Z016' NAME = VBELN_1 OBJECT = 'VBBK' IMPORTING LV_LINES = DATA(LV_LINES_TEMP) ).
    WA_FINAL-LV_LINES1 = LV_LINES_TEMP.

    CONCATENATE  WA_FINAL-DELDATE+4(2) WA_FINAL-DELDATE+6(2) WA_FINAL-DELDATE+0(4)
                INTO GV_DEL_DT SEPARATED BY '-'.
    WA_FINAL-GV_DEL_DT = GV_DEL_DT.

    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_LINES1 GV_DEL_DT.
    CLEAR : LV_LINES1 ,WA_FINAL.
  ENDLOOP.

ENDFORM.

FORM GET_MEMO.
  DATA(LO_TEXT_READER) = NEW ZCL_READ_TEXT( ).
  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.
  CLEAR :GT_LINES ,LV_LINES , LS_LINES.
  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = 'Z015'
*        LANGUAGE                = 'E'
*        NAME                    = VBELN_1
*        OBJECT                  = 'VBBK'
*      TABLES
*        LINES                   = GT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT GT_LINES INTO LS_LINES.
**      lv_memo = ls_lines-tdline.
**      wa_final-lv_memo  = lv_memo.
*
**      CONCATENATE LV_MEMO LS_LINES-TDLINE INTO LV_MEMO.
*      LV_LENGTH = STRLEN( LS_LINES-TDLINE ).
*
*        CLEAR: LV_INDEX,LV_SAFE_LEN.
*
*        DO  LV_LENGTH TIMES.
*          CLEAR: LV_LATRS.
*          LV_INDEX    = SY-INDEX - 1.
*          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
*          LV_LATRS = LS_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
*          LV_LATRS1 = LV_LATRS.
*          TRANSLATE LV_LATRS TO UPPER CASE.
*
*
*            IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
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
*        LV_MEMO = LV_LINES.
*    ENDLOOP.
    LO_TEXT_READER->READ_TEXT_STRING( EXPORTING ID = 'Z015' NAME = VBELN_1 OBJECT = 'VBBK' IMPORTING LV_LINES = DATA(LV_LINES_TEMP) ).


*    WA_FINAL-LV_MEMO = LV_MEMO.  " added by sakshi
    WA_FINAL-LV_MEMO = LV_LINES_TEMP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_MEMO.
    CLEAR: LV_MEMO ,WA_FINAL , LV_LINES .
  ENDLOOP.
ENDFORM.

FORM SMARTFROM_DATA .

  GS_CTRLOP-GETOTF = 'X'.
  GS_CTRLOP-DEVICE = 'PRINTER'.
  GS_CTRLOP-PREVIEW = ''.
  GS_CTRLOP-NO_DIALOG = 'X'.
  GS_OUTOPT-TDDEST = 'LOCL'.
  DATA : LV_OUTPUT_PARAMS TYPE SFPOUTPUTPARAMS.
*         lv_fm_name TYPE funcname.

  DATA: LV_FM_NAME     TYPE FUNCNAME,
        LV_DOC_PARAMS  TYPE SFPDOCPARAMS,
*      lv_output_params TYPE sfpoutputparams,
*      lv_control_params TYPE sfpcontrol,
        LS_FORM_OUTPUT TYPE FPFORMOUTPUT.

*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname = sf_name
**     VARIANT  = ' '
**     DIRECT_CALL              = ' '
*    IMPORTING
*      fm_name  = fm_name
** EXCEPTIONS
**     NO_FORM  = 1
**     NO_FUNCTION_MODULE       = 2
**     OTHERS   = 3
*    .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.





  DATA : LS_DLV-LAND LIKE VBRK-LAND1 VALUE 'IN'.
  DATA: LS_COMPOSER_PARAM     TYPE SSFCOMPOP.
*  PERFORM set_print_param USING    "ls_addr_key
*                                   ls_dlv-land
*                          CHANGING gs_ctrlop
*                                   gs_outopt.

*  CALL FUNCTION fm_name "'/1BCDWB/SF00000110'
*    EXPORTING
*      lv_vbeln         = so_code
*      v_amt            = v_amt
*    IMPORTING
*      job_output_info  = gs_otfdata
*    TABLES
*      it_final         = it_final
*    EXCEPTIONS
*      formatting_error = 1
*      internal_error   = 2
*      send_error       = 3
*      user_canceled    = 4
*      OTHERS           = 5.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  REFRESH it_final.
*  CLEAR wa_final.

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
    EXCEPTIONS
      CANCEL          = 1
      USAGE_ERROR     = 2
      SYSTEM_ERROR    = 3
      INTERNAL_ERROR  = 4
      OTHERS          = 5.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      I_NAME     = SF_NAME   "'ZEXPORT_ORDER_SFP_F'
    IMPORTING
      E_FUNCNAME = LV_FM_NAME.
*   E_INTERFACE_TYPE           =
*   EV_FUNCNAME_INBOUND        =

  .

  PERFORM SET_PRINT_PARAM USING    "ls_addr_key
                                   LS_DLV-LAND
                          CHANGING GS_CTRLOP
                                  GS_OUTOPT.

  CALL FUNCTION LV_FM_NAME "'/1BCDWB/SM00000010'
    EXPORTING
*     /1BCDWB/DOCPARAMS        =
      LV_VBELN       = SO_CODE
      V_AMT          = V_AMT
      IT_FINAL       = IT_FINAL
* IMPORTING
*     /1BCDWB/FORMOUTPUT       =
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

*CALL FUNCTION    lv_fm_name  "'/1BCDWB/SM00000010'
*  EXPORTING
**   /1BCDWB/DOCPARAMS        =
*    LV_VBELN                 =  so_code
*    V_AMT                    =  v_amt
*    IT_FINAL                 =  it_final
**    GT_LINES                 =  gt_lines
** IMPORTING
**   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   OTHERS                   = 4
*          .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.




*CALL FUNCTION '/1BCDWB/SM00000010'
*  EXPORTING
**   /1BCDWB/DOCPARAMS        =
*    lv_vbeln                 = so_code
*    v_amt                    = v_amt
*    it_final                 = it_final
*    lt_lines                 = gt_lines
** IMPORTING
**   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   OTHERS                   = 4
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.




*CALL FUNCTION     lv_fm_name   """ '/1BCDWB/SM00000010'
*  EXPORTING
**   /1BCDWB/DOCPARAMS        =
*    LV_VBELN                 =  so_code
*    V_AMT                    =  v_amt
*    IT_FINAL                 =  it_final
** IMPORTING
**   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   OTHERS                   = 4
*          .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.
  .

  CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.






ENDFORM.


FORM SET_PRINT_PARAM USING    "IS_ADDR_KEY LIKE ADDR_KEY
                              IS_DLV-LAND LIKE VBRK-LAND1
                     CHANGING GS_CTRLOP TYPE SSFCTRLOP
                              GS_OUTOPT TYPE SSFCOMPOP.

  DATA: LS_ITCPO     TYPE ITCPO.
  DATA: LF_REPID     TYPE SY-REPID.
  DATA: LF_DEVICE    TYPE TDDEVICE.
  DATA: LS_RECIPIENT TYPE SWOTOBJID.
  DATA: LS_SENDER    TYPE SWOTOBJID.

  LF_REPID = SY-REPID.

  CALL FUNCTION 'WFMC_PREPARE_SMART_FORM'
    EXPORTING
      PI_NAST    = NAST
      PI_COUNTRY = IS_DLV-LAND
*     PI_ADDR_KEY   = IS_ADDR_KEY
      PI_REPID   = LF_REPID
      PI_SCREEN  = XSCREEN
    IMPORTING
*     PE_RETURNCODE = CF_RETCODE
      PE_ITCPO   = LS_ITCPO
      PE_DEVICE  = LF_DEVICE.
*            PE_RECIPIENT  = CS_RECIPIENT
*            PE_SENDER     = CS_SENDER.

  MOVE-CORRESPONDING LS_ITCPO TO GS_OUTOPT.
  GS_CTRLOP-DEVICE      = LF_DEVICE.
  GS_CTRLOP-NO_DIALOG   = 'X'.
  GS_CTRLOP-PREVIEW     = XSCREEN.
  GS_CTRLOP-GETOTF      = LS_ITCPO-TDGETOTF.
  GS_CTRLOP-LANGU       = NAST-SPRAS.
ENDFORM.                               " SET_PRINT_PARAM
*&---------------------------------------------------------------------*
*&      Form  CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CLEAR .
  REFRESH IT_VBAK.
  REFRESH IT_VBPA.
  REFRESH IT_KNA1.
  REFRESH IT_VBKD.
  REFRESH IT_VBAP.
  REFRESH IT_TVZBT.
  REFRESH IT_VBFA.
  REFRESH IT_KONV.
  REFRESH IT_FINAL.
ENDFORM.
