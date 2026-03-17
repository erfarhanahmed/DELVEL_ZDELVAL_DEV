*&---------------------------------------------------------------------*
*& Report ZPENDPO_BOM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPENDPO_BOM.

TABLES :VBAP,VBAK,MAKT.

*DATA: CURRENT_DATE TYPE SY-DATUM,                   "Added by Saurabh on 12th August 2024
*      PREVIOUS_DATE TYPE SY-DATUM.                  "Added by Saurabh on 12th August 2024

TYPES: BEGIN OF TY_DATA,
         VBELN TYPE VBELN,
         POSNR TYPE POSNR,
         MATNR TYPE MATNR,
         WERKS TYPE VBAP-WERKS,
         LGORT TYPE VBAP-LGORT,
         LFSTA TYPE VBUP-LFSTA,
         LFGSA TYPE VBUP-LFGSA,
         FKSTA TYPE VBUP-FKSTA,
         ABSTA TYPE VBUP-ABSTA,
         GBSTA TYPE VBUP-GBSTA,
*         WERKS TYPE WERKS,
       END OF TY_DATA.

TYPES :BEGIN OF TY_FINAL,
         VBELN      TYPE VBAP-VBELN,
         MATNR      TYPE VBAP-MATNR,
         LONG_TEXT  TYPE CHAR200,
         WERKS      TYPE WERKS,
         STLAN      TYPE STLAN,
         IDNRK      TYPE IDNRK,
         POSNR      TYPE POSNR,
         MENGE      TYPE STPO-MENGE,
         ANDAT      TYPE ANDAT,
         ANNAM      TYPE ANNAM,
         STLAL      TYPE STLAL,
         BMENG      TYPE BMENG,
         BMEIN      TYPE BMEIN,
         MEINS      TYPE MEINS,
         STLST      TYPE STLST,
         LONG_TEXT1 TYPE CHAR200,
         BOM        TYPE MARA-BOM,
         BOM_STATUS TYPE CHAR5,
       END OF TY_FINAL.

TYPES :BEGIN OF TY_DOWN,
         VBELN      TYPE VBAP-VBELN,
         MATNR      TYPE VBAP-MATNR,
         LONG_TEXT  TYPE CHAR200,
         WERKS      TYPE WERKS,
         STLAN      TYPE STLAN,
         IDNRK      TYPE IDNRK,
         POSNR      TYPE POSNR,
         MENGE      TYPE STPO-MENGE,
         ANDAT      TYPE CHAR11,"ANDAT,
         ANNAM      TYPE ANNAM,
         STLAL      TYPE STLAL,
         BMENG      TYPE BMENG,
         BMEIN      TYPE BMEIN,
         MEINS      TYPE MEINS,
         STLST      TYPE STLST,
         LONG_TEXT1 TYPE CHAR200,
         BOM        TYPE MARA-BOM,
         BOM_STATUS TYPE CHAR5,
         REF_DATE TYPE CHAR11,       " Add by supriya on 6.08.2024
         REF_TIME TYPE CHAR15,       " Add by supriya on 6.08.2024
       END OF TY_DOWN.

TYPES :BEGIN OF TY_STPO,
         STLNR TYPE STPO-STLNR,
         STLTY TYPE STPO-STLTY,
         IDNRK TYPE STPO-IDNRK,
         POSNR TYPE STPO-POSNR,
         MENGE TYPE STPO-MENGE,
         ANDAT TYPE STPO-ANDAT,
         ANNAM TYPE STPO-ANNAM,
         MEINS TYPE STPO-MEINS,
       END OF TY_STPO.

TYPES :BEGIN OF TY_MAST_MAKT,
         MATNR TYPE    MATNR,
         MAKTX TYPE    MAKTX,
         WERKS TYPE    WERKS,
         STLAN TYPE    STLAN,
         STLNR TYPE  STPO-STLNR,
         STLTY TYPE  STPO-STLTY,
         STLAL TYPE    STLAL,
         STLST TYPE    STLST,
       END OF TY_MAST_MAKT.

TYPES :BEGIN OF TY_STRAS,
         STLTY TYPE  STAS-STLTY,
         STLNR TYPE  STAS-STLNR,
         STLAL TYPE  STAS-STLAL,
         STLKN TYPE  STAS-STLKN,
         STASZ TYPE  STAS-STASZ,
       END OF TY_STRAS.

TYPES :BEGIN OF TY_STKO,
         STLNR TYPE STKO-STLNR,
         STLTY TYPE STLTY,
         BMEIN TYPE BMEIN,
         BMENG TYPE BMENG,
         STLST TYPE STLST,
         STLAL TYPE STLAL,
         ANNAM TYPE ANNAM,
       END OF TY_STKO.

TYPES :BEGIN OF TY_MARA,
         MATNR TYPE MARA-MATNR,
         BOM   TYPE MARA-BOM,
       END OF TY_MARA.

DATA: IT_DATA      TYPE STANDARD TABLE OF TY_DATA,
      LS_DATA      TYPE TY_DATA,
      IT_FINAL     TYPE STANDARD TABLE OF TY_FINAL,
      LS_FINAL     TYPE TY_FINAL,
      IT_DOWN      TYPE STANDARD TABLE OF TY_DOWN,
      LS_DOWN      TYPE TY_DOWN,
      IT_STPO      TYPE STANDARD TABLE OF TY_STPO,
      LS_STPO      TYPE TY_STPO,
      IT_MAST_MAKT TYPE STANDARD TABLE OF TY_MAST_MAKT,
      LS_MAST_MAKT TYPE TY_MAST_MAKT,
      IT_STRAS     TYPE STANDARD TABLE OF TY_STRAS,
      LS_STRAS     TYPE TY_STRAS,
      IT_STKO      TYPE STANDARD TABLE OF TY_STKO,
      LS_STKO      TYPE TY_STKO,
      IT_MARA      TYPE STANDARD TABLE OF TY_MARA,
      LS_MARA      TYPE TY_MARA.

DATA:
  LV_ID    TYPE THEAD-TDNAME,
  LT_LINES TYPE STANDARD TABLE OF TLINE,
  LS_LINES TYPE TLINE.


DATA: I_SORT             TYPE SLIS_T_SORTINFO_ALV, " SORT
      GT_EVENTS          TYPE SLIS_T_EVENT,        " EVENTS
      I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER,   " TOP-OF-PAGE
      WA_LAYOUT          TYPE  SLIS_LAYOUT_ALV..            " LAYOUT WORKAREA

TYPE-POOLS : SLIS.
DATA: FIELDCATALOG TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
      FIELDLAYOUT  TYPE SLIS_LAYOUT_ALV,

      IT_FCAT      TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT      TYPE LINE OF SLIS_T_FIELDCAT_ALV. " SLIS_T_FIELDCAT_ALV.

DATA : LS_LAYOUT TYPE SLIS_LAYOUT_ALV.

CONSTANTS:
  C_FORMNAME_TOP_OF_PAGE   TYPE SLIS_FORMNAME
                                   VALUE 'TOP_OF_PAGE',
  C_FORMNAME_PF_STATUS_SET TYPE SLIS_FORMNAME
                                 VALUE 'PF_STATUS_SET',
  C_S                      TYPE C VALUE 'S',
  C_H                      TYPE C VALUE 'H'.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME .
SELECT-OPTIONS   :  S_DATE  FOR VBAP-ERDAT,
                    S_MATNR FOR VBAP-MATNR,
                    S_VBELN FOR VBAP-VBELN,
                    S_WERKS FOR VBAP-WERKS.
SELECTION-SCREEN END OF BLOCK B2.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE ABC .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT   '/Delval/India'."India'."India'."temp'.       "'/Delval/India'."temp'."added by jyoti on ..
*PARAMETERS : P_FOLDER LIKE RLGRAP-FILENAME DEFAULT 'ZPENDSO_BOM.TXT' MODIF ID NEE."commented by jyoti on 09.09.2024
SELECTION-SCREEN END OF BLOCK B5.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.
*&---------------------------------------------------------------------*
*&  Include           ZPENDPO_BOM_DATA
*&---------------------------------------------------------------------*

**************Added by Saurabh on 12th August 2024******************
*INITIALIZATION.
*  CURRENT_DATE = SY-DATUM.
*  PREVIOUS_DATE = SY-DATUM - 1.
*
*  S_DATE-LOW = PREVIOUS_DATE.
*  S_DATE-HIGH = CURRENT_DATE.
*  APPEND S_DATE.

********************************************************************

START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM PROCESS_FOR_OUTPUT.
  PERFORM ALV_FOR_OUTPUT.
  PERFORM DISPLAYDATA.

FORM GET_DATA.

  SELECT A~VBELN
         A~POSNR
         A~MATNR
         A~WERKS
         A~LGORT
         B~LFSTA
         B~LFGSA
         B~FKSTA
         B~ABSTA
         B~GBSTA
  INTO TABLE IT_DATA
  FROM  VBAP AS A
  JOIN  VBUP AS B ON ( B~VBELN = A~VBELN  AND B~POSNR = A~POSNR )
  WHERE A~ERDAT  IN S_DATE
  AND   A~MATNR  IN S_MATNR
  AND   A~VBELN  IN S_VBELN
  AND   A~WERKS  EQ 'PL01'
  AND   B~LFSTA  NE 'C'
  AND   B~LFGSA  NE 'C'
  AND   B~FKSTA  NE 'C'
  AND   B~GBSTA  NE 'C'.

  LOOP AT IT_DATA INTO LS_DATA.
    IF LS_DATA-ABSTA = 'C'.
      IF LS_DATA-LFSTA = ' ' AND LS_DATA-LFGSA = ' ' AND LS_DATA-FKSTA = ' ' AND LS_DATA-GBSTA = ' '.
        IF SY-SUBRC = 0.
          DELETE IT_DATA[]  WHERE VBELN = LS_DATA-VBELN AND POSNR = LS_DATA-POSNR.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

  SELECT MAST~MATNR
       MAKT~MAKTX
       MAST~WERKS
       MAST~STLAN
       MAST~STLNR
       STKO~STLTY
       MAST~STLAL
       STKO~STLST
  INTO TABLE IT_MAST_MAKT
  FROM MAST
  INNER JOIN MAKT ON MAST~MATNR = MAKT~MATNR
  INNER JOIN STKO ON MAST~STLNR = STKO~STLNR
    FOR ALL ENTRIES IN IT_DATA
  WHERE  MAST~MATNR = IT_DATA-MATNR
  AND    MAST~WERKS = IT_DATA-WERKS .

  IF IT_MAST_MAKT IS NOT INITIAL.

    SELECT STLNR
           STLTY
           IDNRK
           POSNR
           MENGE
           ANDAT
           ANNAM
           MEINS
      INTO TABLE IT_STPO
      FROM STPO
      FOR ALL ENTRIES IN IT_MAST_MAKT
      WHERE STLNR = IT_MAST_MAKT-STLNR
      AND   STLTY = IT_MAST_MAKT-STLTY.
    SORT IT_MAST_MAKT BY STLNR.
  ENDIF.

  IF IT_STPO IS NOT INITIAL.

    SELECT STLNR
           STLTY
           BMEIN
           BMENG
           STLST
           STLAL
           ANNAM
      INTO TABLE  IT_STKO
      FROM STKO
      FOR ALL ENTRIES IN IT_STPO
      WHERE STLNR = IT_STPO-STLNR."" AND stlal = i_mast_makt-stlal AND stlst = i_mast_makt-stlst.

  ENDIF.

  IF IT_STKO IS NOT INITIAL.
    SELECT STLTY
          STLNR
          STLAL
          STLKN
          STASZ
     FROM STAS
     INTO TABLE IT_STRAS
     FOR ALL ENTRIES IN IT_STPO
     WHERE STLNR = IT_STPO-STLNR.
  ENDIF.


  SELECT MATNR
         BOM
    FROM MARA
    INTO TABLE IT_MARA
    FOR ALL ENTRIES IN IT_DATA
    WHERE MATNR = IT_DATA-MATNR.

ENDFORM.

FORM PROCESS_FOR_OUTPUT.
  SORT IT_STPO BY STLNR IDNRK POSNR.
  LOOP AT IT_DATA INTO LS_DATA  .

    LS_FINAL-VBELN = LS_DATA-VBELN.
    LS_FINAL-MATNR = LS_DATA-MATNR.
    LS_FINAL-WERKS = LS_DATA-WERKS.

    READ TABLE IT_MARA INTO LS_MARA WITH KEY MATNR = LS_FINAL-MATNR.
    IF  SY-SUBRC = 0.
      LS_FINAL-BOM   = LS_MARA-BOM.
    ENDIF.

    READ TABLE IT_MAST_MAKT INTO LS_MAST_MAKT WITH KEY MATNR = LS_DATA-MATNR.
    IF  SY-SUBRC = 0.
      LS_FINAL-STLAN = LS_MAST_MAKT-STLAN.
      LS_FINAL-STLAL = LS_MAST_MAKT-STLAL.
      LS_FINAL-BOM_STATUS = 'YES'.
    ELSE.
      IF  LS_MAST_MAKT IS INITIAL.
        LS_FINAL-STLAN = LS_MAST_MAKT-STLAN.
        LS_FINAL-STLAL = LS_MAST_MAKT-STLAL.
        LS_FINAL-BOM_STATUS = 'NO'.
      ENDIF.
    ENDIF.

    READ TABLE  IT_STKO INTO LS_STKO WITH KEY STLNR = LS_MAST_MAKT-STLNR.
    IF  SY-SUBRC = 0.
      LS_FINAL-BMEIN = LS_STKO-BMEIN.
      LS_FINAL-BMENG = LS_STKO-BMENG.
      LS_FINAL-STLST = LS_STKO-STLST.
    ENDIF.

    LV_ID = LS_FINAL-MATNR.
    CLEAR: LT_LINES,LS_LINES.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'GRUN'
        LANGUAGE                = SY-LANGU
        NAME                    = LV_ID
        OBJECT                  = 'MATERIAL'
      TABLES
        LINES                   = LT_LINES
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
    IF NOT LT_LINES IS INITIAL.
      LOOP AT LT_LINES INTO LS_LINES.
        IF NOT LS_LINES-TDLINE IS INITIAL.
          CONCATENATE LS_FINAL-LONG_TEXT LS_LINES-TDLINE INTO LS_FINAL-LONG_TEXT SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
      CONDENSE LS_FINAL-LONG_TEXT.
    ENDIF.

    LOOP AT IT_STPO INTO LS_STPO WHERE STLNR = LS_MAST_MAKT-STLNR.
      LS_FINAL-IDNRK = LS_STPO-IDNRK.
      LS_FINAL-MEINS = LS_STPO-MEINS.
      LS_FINAL-ANDAT = LS_STPO-ANDAT.
      LS_FINAL-ANNAM = LS_STPO-ANNAM.

      CLEAR : LV_ID,LS_FINAL-LONG_TEXT1.
      LV_ID = LS_FINAL-IDNRK.
      CLEAR: LT_LINES,LS_LINES.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'GRUN'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_ID
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = LT_LINES
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
      IF NOT LT_LINES IS INITIAL.
        LOOP AT LT_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE LS_FINAL-LONG_TEXT1 LS_LINES-TDLINE INTO LS_FINAL-LONG_TEXT1 SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
        CONDENSE LS_FINAL-LONG_TEXT1.
      ENDIF.
      CLEAR LV_ID.

      LS_FINAL-POSNR = LS_STPO-POSNR.
      LS_FINAL-MENGE = LS_STPO-MENGE.
      APPEND LS_FINAL TO IT_FINAL.
    ENDLOOP.

    APPEND LS_FINAL TO IT_FINAL.
     SORT IT_FINAL BY VBELN MATNR POSNR.
    DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING ALL FIELDS.
    CLEAR:LS_FINAL,LS_DATA, LS_MAST_MAKT, LS_STKO, LS_STPO, LS_MARA.
  ENDLOOP.

  IF P_DOWN = 'X'.
     LOOP AT IT_FINAL INTO LS_FINAL.
      LS_DOWN-VBELN       =  LS_FINAL-VBELN.
      LS_DOWN-MATNR       =  LS_FINAL-MATNR.
      LS_DOWN-WERKS       =  LS_FINAL-WERKS.
      LS_DOWN-BOM         =  LS_FINAL-BOM.
      LS_DOWN-LONG_TEXT   =  LS_FINAL-LONG_TEXT.
      LS_DOWN-STLAN       =  LS_FINAL-STLAN.
      LS_DOWN-STLAL       =  LS_FINAL-STLAL.
      LS_DOWN-LONG_TEXT1  =  LS_FINAL-LONG_TEXT1.
      LS_DOWN-BMEIN       =  LS_FINAL-BMEIN.
      LS_DOWN-BOM_STATUS  =  LS_FINAL-BOM_STATUS.
      LS_DOWN-BMENG       =  LS_FINAL-BMENG.
      LS_DOWN-STLST       =  LS_FINAL-STLST.
      LS_DOWN-IDNRK       =  LS_FINAL-IDNRK.
      LS_DOWN-MEINS       =  LS_FINAL-MEINS.
      LS_DOWN-ANDAT       =  LS_FINAL-ANDAT.
*      IF LS_FINAL-ANDAT IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_FINAL-ANDAT
          IMPORTING
            OUTPUT = LS_DOWN-ANDAT.
        IF LS_DOWN-ANDAT IS NOT INITIAL.
         CONCATENATE  LS_DOWN-ANDAT+0(2)  LS_DOWN-ANDAT+2(3)  LS_DOWN-ANDAT+5(4)
                        INTO  LS_DOWN-ANDAT SEPARATED BY '-'.
        ENDIF.

      LS_DOWN-ANNAM       =  LS_FINAL-ANNAM.
      LS_DOWN-POSNR       =  LS_FINAL-POSNR.
      LS_DOWN-MENGE       =  LS_FINAL-MENGE.


*      LS_DOWN-REF_DATE    = LS_FINAL-REF_DATE.   " ADD BY SUPRIYA ON 6.08.2024
*      LS_DOWN-REF_TIME    = LS_FINAL-REF_TIME.    " ADD BY SUPRIYA ON 6.08.2024



        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = SY-DATUM
          IMPORTING
            OUTPUT = LS_DOWN-REF_DATE.
 IF LS_DOWN-REF_DATE IS NOT INITIAL.
        CONCATENATE LS_DOWN-REF_DATE+0(2) LS_DOWN-REF_DATE+2(3) LS_DOWN-REF_DATE+5(4)
                        INTO LS_DOWN-REF_DATE SEPARATED BY '-'.

 ENDIF.
  LS_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE LS_DOWN-REF_TIME+0(2) ':' LS_DOWN-REF_TIME+2(2)  INTO LS_DOWN-REF_TIME.



      APPEND LS_DOWN TO IT_DOWN.
    ENDLOOP.

  ENDIF.
ENDFORM.

FORM ALV_FOR_OUTPUT.

  PERFORM FCAT USING :         '1'     'VBELN'        'IT_FINAL'     'sales order no'               '10' ,
                               '2'     'MATNR'        'IT_FINAL'     'Material Number'              '18' ,
                               '3'     'LONG_TEXT'    'IT_FINAL'     'Material Description'         '30' ,
                               '4'     'WERKS'        'IT_FINAL'     'Plant'                        '5'  ,
                               '5'     'IDNRK'        'IT_FINAL'     'Component'                    '13' ,
                               '6'     'POSNR'        'IT_FINAL'     'Item No'                      '5'  ,
                               '7'     'MENGE'        'IT_FINAL'     'Quantity'                     '5'  ,
                               '8'     'STLAN'        'IT_FINAL'     'Bom Usage'                    '5'  ,
                               '9'     'STLAL'        'IT_FINAL'     'ALT Bom'                      '5'  ,
                               '10'    'BMENG'        'IT_FINAL'     'Base Qty'                     '5'  ,
                               '11'    'BMEIN'        'IT_FINAL'     'UOM'                          '5'  ,
                               '12'    'LONG_TEXT1'   'IT_FINAL'     'Component Description'        '25' ,
                               '13'    'MEINS'        'IT_FINAL'     'UOM'                          '5'  ,
                               '14'    'STLST'        'IT_FINAL'     'BOM Status'                   '5'  ,
                               '15'    'ANDAT'        'IT_FINAL'     'Created Date'                 '10' ,
                               '16'    'ANNAM'        'IT_FINAL'     'Created By'                   '10'  ,
                               '17'    'BOM'          'IT_FINAL'     'BOM Status'                   '10' ,
                               '18'    'BOM_STATUS'   'IT_FINAL'     'BOM Status Desc'              '5'  .

ENDFORM.

FORM FCAT USING     VALUE(P_0813)
                    VALUE(P_0814)
                    VALUE(P_0815)
                    VALUE(P_0816)
                    VALUE(P_0817).

  WA_FCAT-COL_POS   = P_0813.
  WA_FCAT-FIELDNAME = P_0814.
  WA_FCAT-TABNAME   = P_0815.
  WA_FCAT-SELTEXT_L = P_0816.
  WA_FCAT-OUTPUTLEN = P_0817.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.

FORM DISPLAYDATA .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      IS_LAYOUT          = LS_LAYOUT
      IT_FIELDCAT        = IT_FCAT
       I_SAVE                 = 'X'
    TABLES
      T_OUTTAB           = IT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN EQ 'X'.



    PERFORM DOWNLOAD.

  ENDIF.

ENDFORM.

FORM DOWNLOAD.
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

  LV_FILE = 'ZPENDSO_BOM.TXT'.

  CONCATENATE P_FOLDER '/'  LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_587 TYPE string.
DATA lv_crlf_587 TYPE string.
lv_crlf_587 = cl_abap_char_utilities=>cr_lf.
lv_string_587 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_587 lv_crlf_587 wa_csv INTO lv_string_587.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_999 TO lv_fullfile.
TRANSFER lv_string_587 TO lv_fullfile.
    CLOSE DATASET LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
ENDFORM.

FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE           'sales order no'
                        'Material Number'
                        'Material Description'
                        'Plant'
                        'Bom Usage'
                        'Component'
                        'Item No'
                        'Quantity'
                        'Created Date'
                        'Created By'
                        'ALT Bom'
                        'Base Qty'
                        'UOM'
                        'UOM'
                        'BOM Status'
                        'Component Description'
                        'BOM Status'
                        'BOM Status Desc'
                        'Refreshable Date'
                        'Refreshable Time'
       INTO PD_CSV SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
