*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* 1.Program Owner           : Primus Techsystems Pvt Ltd.              *
* 2.Project                 : Display BOM Level by Level cs12          *
* 3.Program Name            : ZPP_MULTILEVEL_BOM                       *
* 4.Module Name             : PP                                       *
* 5.Request No              :                                *
* 6.Creation Date           : 27.03.2023                               *
* 7.Created/Changed BY      : Nilay Brahme                        *
* 8.Functional Consultant   : Subhashish Pande                           *
* 9.Description             : Display BOM Level by Level for Bharat               *
* 10.Tcode                  : zcs12                                        *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT ZBOM_CS12
       NO STANDARD PAGE HEADING LINE-SIZE 255.
*&*--------------------------------------------------------------------*
*&* TABLES
*&*--------------------------------------------------------------------*
TABLES: MARA.
*&*--------------------------------------------------------------------*
*&* STRUCTURE & INTERNAL TABLE DECLERATION
*&*--------------------------------------------------------------------*

DATA: BEGIN OF ALV_STB OCCURS 100.
        INCLUDE STRUCTURE STPOX_ALV.
DATA : LV_CNT(3).
DATA: INFO(3) TYPE C,
      END OF ALV_STB.

DATA: BEGIN OF DSP_SEL OCCURS 20,                           "YHG139715
        TEXT(30),                                           "YHG139715
        FILLER(2) VALUE '_ ',                               "YHG139715
        WERT(32),                                           "YHG139715
      END OF DSP_SEL.                                       "YHG139715

DATA: BEGIN OF ALV_STB1 OCCURS 0.
        INCLUDE STRUCTURE STPOX_ALV.


DATA : LV_CNT(3).
DATA: INFO(3) TYPE C.
DATA: LINE_COLOR(4) TYPE C,     "Used to store row color attributes
      END OF ALV_STB1.
DATA : CNT        TYPE SY-TABIX.
DATA: BEGIN OF ALV_STB2 OCCURS 0.
        INCLUDE STRUCTURE STPOX_ALV.
DATA : LV_CNT(3).
DATA: INFO(3) TYPE C.
DATA: LINE_COLOR(4) TYPE C,     "Used to store row color attributes
      END OF ALV_STB2.
DATA: BEGIN OF FTAB OCCURS 200.
        INCLUDE STRUCTURE DFIES.
DATA: END   OF FTAB.

TYPES: BEGIN OF TY_MBEW,
         MATNR TYPE MBEW-MATNR,
         BWKEY TYPE MBEW-BWKEY,
         BWTAR TYPE MBEW-BWTAR,
         VPRSV TYPE MBEW-VPRSV,
         VERPR TYPE MBEW-VERPR,
         STPRS TYPE MBEW-STPRS,
       END OF TY_MBEW.

DATA: LT_MBEW TYPE TABLE OF TY_MBEW,
      LS_MBEW TYPE TY_MBEW.

TYPES : BEGIN OF TY_MBEW1,
          MATNR TYPE MBEW-MATNR,
          WERKS TYPE MBEW-BWKEY,
        END OF TY_MBEW1.
DATA : LT_MBEW1 TYPE TABLE OF TY_MBEW1,
       LS_MBEW1 TYPE TY_MBEW1.

TYPES : BEGIN OF TY_MAKT,
          MANDT TYPE MAKT-MANDT,
          MATNR TYPE MAKT-MATNR,
          SPRAS TYPE MAKT-SPRAS,
          MAKTX TYPE MAKT-MAKTX,
        END OF TY_MAKT.

DATA : LT_MAKT TYPE TABLE OF TY_MAKT,
       LS_MAKT TYPE TY_MAKT.

TYPES : BEGIN OF TY_MAST,
          MATNR TYPE MAST-MATNR,
          WERKS TYPE MAST-WERKS,
          STLAN TYPE MAST-STLAN,
          STLNR TYPE MAST-STLNR,
          STLAL TYPE MAST-STLAL,
        END OF TY_MAST.

DATA : IT_MAST TYPE TABLE OF TY_MAST,
       WA_MAST TYPE          TY_MAST.

DATA:
  WA_STB_FIELDS_TB TYPE SLIS_FIELDCAT_ALV,
  STB_FIELDS_TB    TYPE SLIS_T_FIELDCAT_ALV,
  REPORT_NAME      LIKE SY-REPID,
  ALVLO_STB        TYPE SLIS_LAYOUT_ALV,
  BDCDATA          TYPE TABLE OF BDCDATA WITH HEADER LINE,
  LT_BDCMSG        TYPE TABLE OF BDCMSGCOLL,
  LS_BDCMSG        TYPE BDCMSGCOLL,
  LV_MATNR         TYPE MARA-MATNR.
DATA:
  ALVVR_SAV_ALL    TYPE C VALUE 'A',
  ALVVR_SAV_NO_USR TYPE C VALUE 'X'.
DATA:LV_DAY(2),
     LV_MONTH(2),
     LV_YEAR(4),
     LV_DATE(10).
DATA : LV_CNT(3) VALUE 1.
DATA : CNT3      TYPE SY-TABIX.
DATA : CNT1     TYPE SY-TABIX.
DATA : LV_TABIX TYPE SY-TABIX.

**Added by sarika Thange 22.04.2019
TYPES : BEGIN OF TY_DOWN_FTP,
          DGLVL     TYPE CHAR10,
          POSNR     TYPE POSNR,
*          objic    TYPE string,
          DOBJT     TYPE SOBJID,
          OJTXP     TYPE OJTXP,
          OVFLS     TYPE OVFLS,
          MNGKO     TYPE CHAR15,
          MEINS     TYPE MEINS,
          POSTP     TYPE POSTP,
          AUSNM     TYPE AUSNM,
          SGT_RCAT  TYPE SGT_RCAT,
          SGT_SCAT  TYPE SGT_SCAT,
          VERPR     TYPE CHAR15,
          ZZTEXT_EN TYPE CHAR250,
          ZZTEXT_SP TYPE CHAR250,
          REF_DT    TYPE CHAR11,

        END OF TY_DOWN_FTP.

DATA : GT_DOWN_FTP TYPE TABLE OF TY_DOWN_FTP,
       GS_DOWN_FTP TYPE TY_DOWN_FTP.

"------------------------------------------------------
DATA :I_TLINE TYPE STANDARD TABLE OF TLINE WITH HEADER LINE.
DATA :I_TLINE1 TYPE STANDARD TABLE OF TLINE WITH HEADER LINE.
DATA : LV_EBELN(70) TYPE C.
DATA : LV_TEXT(20000) TYPE C.
DATA : LV_TEXT1(20000) TYPE C.

DATA : LT_STXH TYPE TABLE OF STXH,
       LS_STXH TYPE STXH.

DATA : LT_STXH1 TYPE TABLE OF STXH,
       LS_STXH1 TYPE STXH.
DATA: EXP_DOWN(1) TYPE C.
CONSTANTS : LV_SPRAS(01) TYPE C VALUE 'S'.      "stxh-tdspras

*&*--------------------------------------------------------------------*
*&* SELECTION SCREEN
*&*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001 .
  SELECT-OPTIONS : S_MATNR  FOR MARA-MATNR  NO INTERVALS.
  PARAMETERS     : PM_WERKS LIKE MARC-WERKS,
                   PM_DATUV LIKE STKO-DATUV DEFAULT SY-DATUM,
                   PM_STLAN LIKE STZU-STLAN,
                   PM_STLAL LIKE STKO-STLAL,
                   PM_CAPID LIKE TC04-CAPID,
                   CTU_MODE LIKE CTU_PARAMS-DISMODE DEFAULT 'N' NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK B1.

**Added By Sarika Thange 06.03.2019
SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

*&*--------------------------------------------------------------------*
*&* START OF SELECTION
*&*--------------------------------------------------------------------*
START-OF-SELECTION.

  IF S_MATNR IS INITIAL.
    SELECT MATNR
           WERKS
           STLAN
           STLNR
           STLAL FROM MAST INTO TABLE IT_MAST
           WHERE WERKS = 'PL01'.
    PERFORM FETCH_DATA1.         "Fetch Data
  ELSE.
    PERFORM FETCH_DATA.         "Fetch Data
  ENDIF.

  IMPORT EXP_DOWN FROM MEMORY ID 'EXP_DOWN'.
  IF SY-SUBRC = 0.
    DATA(EXP_DOWN_FINAL) = EXP_DOWN.
  ENDIF.
  FREE MEMORY ID 'EXP_DOWN'.
  PERFORM DATA_RETRIEVAL.
  IF P_DOWN = 'X' OR EXP_DOWN_FINAL = 'X'.
    PERFORM DOWNLOAD TABLES GT_DOWN_FTP USING P_FOLDER..
  ELSE.
    PERFORM STB_FIELDS_TB_PREP. "Field Catlog
  ENDIF.



*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
FORM FETCH_DATA.
**Current Date
  CLEAR:LV_DAY,LV_MONTH,LV_YEAR,LV_DATE.
  LV_DAY   = PM_DATUV+6(2).
  LV_MONTH = PM_DATUV+4(2).
  LV_YEAR  = PM_DATUV+0(4).

  CONCATENATE LV_DAY LV_MONTH LV_YEAR INTO LV_DATE SEPARATED BY '.'.


  SELECT MANDT
         MATNR
         SPRAS
         MAKTX
    FROM MAKT
    INTO TABLE LT_MAKT
    WHERE MATNR IN S_MATNR
    AND   SPRAS EQ 'E'.


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  LOOP AT S_MATNR.
*    cnt1 = sy-tabix.
    "Report:ZCS11
    PERFORM BDC.
    "Import From "Report-ZCS11"
    IMPORT ALV_STB[] FROM MEMORY ID 'ALV_STB'.
*BREAK PRIMUS.
*    LOOP AT alv_stb INTO alv_stb WHERE MTART = 'HALB' OR MTART = 'FERT' AND POSNR IS NOT INITIAL.
*
*      SELECT SINGLE BESKZ  FROM MARC INTO @DATA(LV_BESKZ)
*        WHERE MATNR = @ALV_STB-IDNRK AND BESKZ = 'F' AND SOBSL = '' AND WERKS = 'PL01'.
*
*        IF  SY-SUBRC = 0.
*
*          SELECT SINGLE STLNR FROM MAST INTO @DATA(LV_STLNR)
*            WHERE MATNR = @ALV_STB-IDNRK.
*            SELECT SINGLE IDNRK FROM STPO INTO @DATA(GV_IDNRK)
*              WHERE STLNR = @LV_STLNR.
*
*
*       DELETE alv_stb WHERE IDNRK = GV_IDNRK.
*        ENDIF.
*
*
*
*    ENDLOOP.

    IF ALV_STB[] IS NOT INITIAL.
      "GET MATERIAL DESCRIPTION         """""""""""""""""""""ADDED ON 16.042019 BY MRUNALEE
      READ TABLE LT_MAKT INTO LS_MAKT WITH KEY MATNR = S_MATNR-LOW.
      IF SY-SUBRC = 0.
        ALV_STB-OJTXP = LS_MAKT-MAKTX.
      ENDIF.
      "GET MATERIAL NUMBER
      ALV_STB-DOBJT = S_MATNR-LOW.
      INSERT ALV_STB INTO ALV_STB[] INDEX 1. "
      APPEND LINES OF ALV_STB[] TO ALV_STB1[] .
    ENDIF.

    REFRESH ALV_STB[].
    FREE MEMORY ID 'ALV_STB'.
    CLEAR:S_MATNR,CNT1.
  ENDLOOP.

  LOOP AT ALV_STB1 INTO ALV_STB1.
    LS_MBEW1-MATNR = ALV_STB1-DOBJT.
    LS_MBEW1-WERKS = ALV_STB1-WERKS.
    APPEND LS_MBEW1 TO LT_MBEW1.
    CLEAR : LS_MBEW1 , ALV_STB1.
  ENDLOOP.
*
  SELECT   MATNR
           BWKEY
           BWTAR
           VPRSV
           VERPR
           STPRS
    FROM MBEW
    INTO TABLE LT_MBEW
    FOR ALL ENTRIES IN LT_MBEW1
    WHERE MATNR = LT_MBEW1-MATNR
    AND   BWKEY = LT_MBEW1-WERKS.

  LOOP AT ALV_STB1 INTO ALV_STB1.
    CNT3 = SY-TABIX.
    READ TABLE LT_MBEW1 INTO LS_MBEW1 WITH KEY MATNR = ALV_STB1-DOBJT WERKS = ALV_STB1-WERKS.
    IF SY-SUBRC = 0..
      READ TABLE LT_MBEW INTO LS_MBEW WITH KEY MATNR = LS_MBEW1-MATNR BWKEY = LS_MBEW1-WERKS.
      IF SY-SUBRC = 0.
        ALV_STB1-VERPR = LS_MBEW-VERPR.
        MODIFY ALV_STB1 FROM ALV_STB1 INDEX CNT3 TRANSPORTING VERPR.
      ENDIF.
    ENDIF.

    CLEAR : LS_MBEW,ALV_STB1,CNT3,LS_MBEW.
  ENDLOOP.


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""to get the long text
  LOOP AT ALV_STB1.

    LV_EBELN = ALV_STB1-DOBJT.

    SELECT *
      FROM STXH
      INTO TABLE LT_STXH
    WHERE TDOBJECT = 'MATERIAL'
      AND TDNAME   = LV_EBELN
      AND  TDSPRAS = 'EN'
      AND TDID     = 'GRUN'.

    SELECT *
     FROM STXH
     INTO TABLE LT_STXH1
   WHERE TDOBJECT = 'MATERIAL'
     AND TDNAME   = LV_EBELN
     AND  TDSPRAS = LV_SPRAS
     AND TDID     = 'GRUN'.


*    LOOP AT lt_stxh INTO ls_stxh.

    READ TABLE LT_STXH INTO LS_STXH INDEX 1.
    IF SY-SUBRC = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          ID                      = LS_STXH-TDID    "GRUN
          LANGUAGE                = LS_STXH-TDSPRAS "sy-langu
          NAME                    = LS_STXH-TDNAME  "4410LE00027EB001'
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = I_TLINE
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
    ENDIF.

    READ TABLE LT_STXH1 INTO LS_STXH1 INDEX 1.
    IF SY-SUBRC = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          ID                      = LS_STXH1-TDID    "GRUN
          LANGUAGE                = LS_STXH1-TDSPRAS "sy-langu
          NAME                    = LS_STXH1-TDNAME  "4410LE00027EB001'
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = I_TLINE1
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
    ENDIF.

    LOOP AT I_TLINE.
      CONCATENATE LV_TEXT I_TLINE-TDLINE INTO LV_TEXT SEPARATED BY SPACE.
      CLEAR: I_TLINE.
    ENDLOOP.

    LOOP AT I_TLINE1.
      CONCATENATE LV_TEXT1 I_TLINE1-TDLINE INTO LV_TEXT1 SEPARATED BY SPACE.
      CLEAR: I_TLINE1.
    ENDLOOP.


    "get Material Long Text EN
    ALV_STB1-ZZTEXT_EN = LV_TEXT. """""""""""""""""""""""""""""""""""""""""added ON 26.042019 BY MRUNALEE
    ALV_STB1-ZZTEXT_SP = LV_TEXT1.

    MODIFY ALV_STB1 TRANSPORTING ZZTEXT_EN ZZTEXT_SP.

    CLEAR : LV_TEXT,ALV_STB1-ZZTEXT_EN,ALV_STB1-ZZTEXT_SP,LV_TEXT1.

  ENDLOOP.

*BREAK primus.
*DATA AJ TYPE C.
*DATA : count TYPE sy-tabix..
*SELECT matnr , stlnr FROM mast INTO TABLE @data(it_bom)
*  FOR ALL ENTRIES IN @alv_stb1 WHERE matnr = @alv_stb1-idnrk.

*  LOOP AT alv_stb1 INTO alv_stb1 WHERE MTART = 'HALB' OR MTART = 'FERT' AND POSNR IS NOT INITIAL.
*
*      SELECT SINGLE BESKZ  FROM MARC INTO @DATA(LV_BESKZ)
*        WHERE MATNR = @ALV_STB1-IDNRK AND BESKZ = 'F' AND SOBSL = '' AND WERKS = 'PL01'.
*
*        IF  SY-SUBRC = 0.
*         count = sy-tabix + 1.
*
*          LOOP AT alv_stb1 INTO alv_stb1."" WHERE index = count.
*          if  count le sy-tabix..
*          IF alv_stb1-stufe <> 1.
*          DELETE alv_stb1 WHERE index = sy-tabix.
*          else.
*            exit.
*          ENDIF.
**          count = count + 1.
*          ENDIF.
*          ENDLOOP.
*        ENDIF.
*    ENDLOOP.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  BDC
*&---------------------------------------------------------------------*
FORM BDC.
  REFRESH BDCDATA[].
  REFRESH LT_BDCMSG[].

  PERFORM BDC_DYNPRO      USING 'ZCS12' '1000'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'PM_MTNRV'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=ONLI'.
  PERFORM BDC_FIELD       USING 'PM_MTNRV'
                                 S_MATNR-LOW.    "'A5003C-20001426-02'.
  PERFORM BDC_FIELD       USING 'PM_WERKS'
                                PM_WERKS.        "'PL01'.
  PERFORM BDC_FIELD       USING 'PM_CAPID'
                                PM_CAPID.        "'PP01'.
  PERFORM BDC_FIELD       USING 'PM_DATUV'
                                LV_DATE.         "'02.04.2019'.
  PERFORM BDC_FIELD       USING 'PM_EHNDL'
                                '1'.
  PERFORM BDC_DYNPRO      USING 'SAPMSSY0' '0120'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=&F03'.
  PERFORM BDC_DYNPRO      USING 'ZCS12' '1000'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '/EENDE'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'PM_MTNRV'.


  CALL TRANSACTION 'ZCS12_NEW'
          USING BDCDATA
                MODE CTU_MODE
                UPDATE 'S'
                MESSAGES INTO LT_BDCMSG.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  STB_FIELDS_TB_PREP
*&---------------------------------------------------------------------*
FORM STB_FIELDS_TB_PREP.

  "Field Documentation
  CALL FUNCTION 'DDIF_FIELDINFO_GET'                          "uc 070302
    EXPORTING                                                 "uc 070302
      LANGU     = SY-LANGU                                    "uc 070302
      TABNAME   = 'STPOX_ALV'                                 "uc 070302
*     UCLEN     = '01'                                        "uc 070302
    TABLES                                                    "uc 070302
      DFIES_TAB = FTAB                                        "uc 070302
    EXCEPTIONS                                                "uc 070302
      OTHERS    = 1.                                          "uc 070302

  LOOP AT FTAB.
    CLEAR: WA_STB_FIELDS_TB.

    CASE FTAB-FIELDNAME.
      WHEN 'DGLVL'.
        WA_STB_FIELDS_TB-FIELDNAME = 'DGLVL'.
        WA_STB_FIELDS_TB-COL_POS   =  1.
        WA_STB_FIELDS_TB-FIX_COLUMN = 'X' .
        WA_STB_FIELDS_TB-OUTPUTLEN = 11.
        WA_STB_FIELDS_TB-JUST      = 'L' .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'POSNR'.
        WA_STB_FIELDS_TB-FIELDNAME = 'POSNR'.
        WA_STB_FIELDS_TB-COL_POS   =  2.
        WA_STB_FIELDS_TB-FIX_COLUMN =  'X' .
        WA_STB_FIELDS_TB-OUTPUTLEN = 4 .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'OBJIC'.
        WA_STB_FIELDS_TB-FIELDNAME = 'OBJIC'.
        WA_STB_FIELDS_TB-COL_POS   =  3.
        WA_STB_FIELDS_TB-FIX_COLUMN =  'X' .
        WA_STB_FIELDS_TB-OUTPUTLEN = 3 .
        WA_STB_FIELDS_TB-ICON       =  'X' .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'DOBJT'.
        WA_STB_FIELDS_TB-FIELDNAME = 'DOBJT'.
        WA_STB_FIELDS_TB-COL_POS   =  4.
        WA_STB_FIELDS_TB-FIX_COLUMN =  'X' .
        WA_STB_FIELDS_TB-OUTPUTLEN = 23 .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'OJTXP'.
        WA_STB_FIELDS_TB-FIELDNAME = 'OJTXP'.
        WA_STB_FIELDS_TB-COL_POS   =  5.
        WA_STB_FIELDS_TB-OUTPUTLEN = 19.
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'OVFLS'.
        WA_STB_FIELDS_TB-FIELDNAME = 'OVFLS'.
        WA_STB_FIELDS_TB-COL_POS   = 6.
        WA_STB_FIELDS_TB-OUTPUTLEN = 3 .
        WA_STB_FIELDS_TB-JUST      = 'R' .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'MNGKO'.
        WA_STB_FIELDS_TB-FIELDNAME = 'MNGKO'.
        WA_STB_FIELDS_TB-COL_POS   = 7.
        WA_STB_FIELDS_TB-OUTPUTLEN = 18.
        WA_STB_FIELDS_TB-NO_SUM    = 'X'.
        WA_STB_FIELDS_TB-NO_ZERO   = 'X'.
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'MEINS'.
        WA_STB_FIELDS_TB-FIELDNAME = 'MEINS'.
        WA_STB_FIELDS_TB-COL_POS   = 8.
        WA_STB_FIELDS_TB-OUTPUTLEN = 3 .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'POSTP'.
        WA_STB_FIELDS_TB-FIELDNAME = 'POSTP'.
        WA_STB_FIELDS_TB-COL_POS   = 9.
        WA_STB_FIELDS_TB-OUTPUTLEN = 3 .
        WA_STB_FIELDS_TB-JUST      = 'C' .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'AUSNM'.
        WA_STB_FIELDS_TB-FIELDNAME = 'AUSNM'.
        WA_STB_FIELDS_TB-COL_POS   = 10.
        WA_STB_FIELDS_TB-OUTPUTLEN = 5 .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'SGT_RCAT'.
        WA_STB_FIELDS_TB-FIELDNAME = 'SGT_RCAT'.  "requirement segment
        WA_STB_FIELDS_TB-COL_POS   = 11.
        WA_STB_FIELDS_TB-OUTPUTLEN = 16 .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'SGT_SCAT'.
        WA_STB_FIELDS_TB-FIELDNAME = 'SGT_SCAT'.       "stock segment
        WA_STB_FIELDS_TB-COL_POS   = 12.
        WA_STB_FIELDS_TB-OUTPUTLEN = 16 .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'VERPR'.
        WA_STB_FIELDS_TB-FIELDNAME = 'VERPR'.       "Moving Average price
        WA_STB_FIELDS_TB-COL_POS   = 13.
        WA_STB_FIELDS_TB-OUTPUTLEN = 16 .
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'ZZTEXT_EN'.
        WA_STB_FIELDS_TB-FIELDNAME = 'ZZTEXT_EN'.       "Material Long Text EN
        WA_STB_FIELDS_TB-COL_POS   = 14.
        WA_STB_FIELDS_TB-OUTPUTLEN = 50.
        WA_STB_FIELDS_TB-SELTEXT_L = TEXT-032.
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN 'ZZTEXT_SP'.
        WA_STB_FIELDS_TB-FIELDNAME = 'ZZTEXT_SP'.       "Material Long Text SP
        WA_STB_FIELDS_TB-COL_POS   = 15.
        WA_STB_FIELDS_TB-OUTPUTLEN = 50.
        WA_STB_FIELDS_TB-SELTEXT_L = TEXT-033.
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

      WHEN OTHERS.
        WA_STB_FIELDS_TB-FIELDNAME = FTAB-FIELDNAME.
        WA_STB_FIELDS_TB-NO_OUT    = 'X'.
        WA_STB_FIELDS_TB-NO_SUM    = 'X'.
        APPEND WA_STB_FIELDS_TB TO STB_FIELDS_TB.

    ENDCASE.
  ENDLOOP.

  "Row color in Report
  ALVLO_STB-INFO_FIELDNAME = 'LINE_COLOR'.

  "Display Report
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      IS_LAYOUT          = ALVLO_STB
      I_SAVE             = 'X'
      I_STRUCTURE_NAME   = 'STPOX_ALV'
      IT_FIELDCAT        = STB_FIELDS_TB
    TABLES
      T_OUTTAB           = ALV_STB1
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
ENDFORM. "stb_fields_tb_prep

*&---------------------------------------------------------------------*
*&      Form  DATA_RETRIEVAL
*&---------------------------------------------------------------------*

FORM DATA_RETRIEVAL.
  DATA: LD_COLOR(1) TYPE C.
*Populate field with color attributes
  LOOP AT ALV_STB1.
    IF ALV_STB1-POSNR IS INITIAL AND ALV_STB1-DSTUF IS NOT INITIAL.
* Populate color variable with colour properties("alv_stb1-line_color")
* Char 1 = C (This is a color property)
* Char 2 = 3 (Color codes: 1 - 7)
* Char 3 = Intensified on/off ( 1 or 0 )
* Char 4 = Inverse display on/off ( 1 or 0 )
      "Yellow
      LD_COLOR = 3.

      CONCATENATE 'C' LD_COLOR '00' INTO ALV_STB1-LINE_COLOR.
      MODIFY ALV_STB1 TRANSPORTING LINE_COLOR.
    ELSEIF ALV_STB1-POSNR IS INITIAL AND ALV_STB1-DSTUF IS INITIAL.
      "Red
      LD_COLOR = 6.

      CONCATENATE 'C' LD_COLOR '00' INTO ALV_STB1-LINE_COLOR.
      MODIFY ALV_STB1 TRANSPORTING LINE_COLOR.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " DATA_RETRIEVAL
*----------------------------------------------------------------------*
*        START NEW SCREEN                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        INSERT FIELD                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
*  IF FVAL <> NODATA.
  CLEAR BDCDATA.
  BDCDATA-FNAM = FNAM.
  BDCDATA-FVAL = FVAL.
  APPEND BDCDATA.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*      text
*----------------------------------------------------------------------*
*-->  p1        text
* <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD TABLES GT_DOWN_FTP USING P_FOLDER.
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  PERFORM FILL_FTP_STR.
  EXPORT GT_DOWN_FTP TO MEMORY ID 'ZCS12_BHARAT'.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = GT_DOWN_FTP
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.


  LV_FILE = 'ZCS12_BHARAT.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZCS12 Bharat Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_723 TYPE STRING.
    DATA LV_CRLF_723 TYPE STRING.
    LV_CRLF_723 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_723 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_723 LV_CRLF_723 WA_CSV INTO LV_STRING_723.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_4031 TO lv_fullfile.
    TRANSFER LV_STRING_723 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_FTP_STR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILL_FTP_STR .

  LOOP AT ALV_STB1 INTO DATA(WA_FINAL).

    GS_DOWN_FTP-DGLVL     = WA_FINAL-DGLVL.
    GS_DOWN_FTP-POSNR     = WA_FINAL-POSNR.
    GS_DOWN_FTP-DOBJT     = WA_FINAL-DOBJT.
    GS_DOWN_FTP-OJTXP     = WA_FINAL-OJTXP.
    GS_DOWN_FTP-OVFLS     = WA_FINAL-OVFLS.
    GS_DOWN_FTP-MNGKO     = WA_FINAL-MNGKO.
    GS_DOWN_FTP-MEINS     = WA_FINAL-MEINS..
    GS_DOWN_FTP-POSTP     = WA_FINAL-POSTP.
    GS_DOWN_FTP-AUSNM     = WA_FINAL-AUSNM.
    GS_DOWN_FTP-SGT_RCAT  = WA_FINAL-SGT_RCAT.
    GS_DOWN_FTP-SGT_SCAT  = WA_FINAL-SGT_SCAT.
    GS_DOWN_FTP-VERPR     = WA_FINAL-VERPR.
    GS_DOWN_FTP-ZZTEXT_EN = WA_FINAL-ZZTEXT_EN.
    GS_DOWN_FTP-ZZTEXT_SP = WA_FINAL-ZZTEXT_SP.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = GS_DOWN_FTP-REF_DT.

    CONCATENATE GS_DOWN_FTP-REF_DT+0(2) GS_DOWN_FTP-REF_DT+2(3) GS_DOWN_FTP-REF_DT+5(4) INTO GS_DOWN_FTP-REF_DT SEPARATED BY '-'.

    APPEND GS_DOWN_FTP TO GT_DOWN_FTP.
    CLEAR : GS_DOWN_FTP,WA_FINAL.

  ENDLOOP.

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

  CONCATENATE
  'Explosion Level'
  'Item Number'
*  'Objects'
  'Component NO.'
  'Object Discription'
  'Overflow Indicator'
  'Comp. Qty(CUn)'
  'Component Unit'
  'Item Category'
  'Exception'
  'Requirement Segment'
  'Stock Segment'
  'Moving Average price'
  'Material Long Text EN'
  'Material Long Text SP'
  'Refreshed On'


  INTO PD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FETCH_DATA1 .
**Current Date
  CLEAR:LV_DAY,LV_MONTH,LV_YEAR,LV_DATE.
  LV_DAY   = PM_DATUV+6(2).
  LV_MONTH = PM_DATUV+4(2).
  LV_YEAR  = PM_DATUV+0(4).

  CONCATENATE LV_DAY LV_MONTH LV_YEAR INTO LV_DATE SEPARATED BY '.'.


  SELECT MANDT
         MATNR
         SPRAS
         MAKTX
    FROM MAKT
    INTO TABLE LT_MAKT
    FOR ALL ENTRIES IN IT_MAST
    WHERE MATNR = IT_MAST-MATNR "IN s_matnr
    AND   SPRAS EQ 'E'.


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  LOOP AT IT_MAST INTO WA_MAST.
*    cnt1 = sy-tabix.
    "Report:ZCS11
    PERFORM BDC1.
    "Import From "Report-ZCS11"
    IMPORT ALV_STB[] FROM MEMORY ID 'ALV_STB'.

    IF ALV_STB[] IS NOT INITIAL.
      "GET MATERIAL DESCRIPTION         """""""""""""""""""""ADDED ON 16.042019 BY MRUNALEE
      READ TABLE LT_MAKT INTO LS_MAKT WITH KEY MATNR = WA_MAST-MATNR."s_matnr-low.
      IF SY-SUBRC = 0.
        ALV_STB-OJTXP = LS_MAKT-MAKTX.
      ENDIF.
      "GET MATERIAL NUMBER
      ALV_STB-DOBJT = WA_MAST-MATNR.  "s_matnr-low.
      INSERT ALV_STB INTO ALV_STB[] INDEX 1. "
      APPEND LINES OF ALV_STB[] TO ALV_STB1[] .
    ENDIF.

    REFRESH ALV_STB[].
    FREE MEMORY ID 'ALV_STB'.
    CLEAR:WA_MAST,CNT1.
  ENDLOOP.

  LOOP AT ALV_STB1 INTO ALV_STB1.
    LS_MBEW1-MATNR = ALV_STB1-DOBJT.
    LS_MBEW1-WERKS = ALV_STB1-WERKS.
    APPEND LS_MBEW1 TO LT_MBEW1.
    CLEAR : LS_MBEW1 , ALV_STB1.
  ENDLOOP.
*
  SELECT   MATNR
           BWKEY
           BWTAR
           VPRSV
           VERPR
           STPRS
    FROM MBEW
    INTO TABLE LT_MBEW
    FOR ALL ENTRIES IN LT_MBEW1
    WHERE MATNR = LT_MBEW1-MATNR
    AND   BWKEY = LT_MBEW1-WERKS.

  LOOP AT ALV_STB1 INTO ALV_STB1.
    CNT3 = SY-TABIX.
    READ TABLE LT_MBEW1 INTO LS_MBEW1 WITH KEY MATNR = ALV_STB1-DOBJT WERKS = ALV_STB1-WERKS.
    IF SY-SUBRC = 0..
      READ TABLE LT_MBEW INTO LS_MBEW WITH KEY MATNR = LS_MBEW1-MATNR BWKEY = LS_MBEW1-WERKS.
      IF SY-SUBRC = 0.
        ALV_STB1-VERPR = LS_MBEW-VERPR.
        MODIFY ALV_STB1 FROM ALV_STB1 INDEX CNT3 TRANSPORTING VERPR.
      ENDIF.
    ENDIF.

    CLEAR : LS_MBEW,ALV_STB1,CNT3,LS_MBEW.
  ENDLOOP.


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""to get the long text
  LOOP AT ALV_STB1.

    LV_EBELN = ALV_STB1-DOBJT.

    SELECT *
      FROM STXH
      INTO TABLE LT_STXH
    WHERE TDOBJECT = 'MATERIAL'
      AND TDNAME   = LV_EBELN
      AND  TDSPRAS = 'EN'
      AND TDID     = 'GRUN'.

    SELECT *
     FROM STXH
     INTO TABLE LT_STXH1
   WHERE TDOBJECT = 'MATERIAL'
     AND TDNAME   = LV_EBELN
     AND  TDSPRAS = LV_SPRAS
     AND TDID     = 'GRUN'.


*    LOOP AT lt_stxh INTO ls_stxh.

    READ TABLE LT_STXH INTO LS_STXH INDEX 1.
    IF SY-SUBRC = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          ID                      = LS_STXH-TDID    "GRUN
          LANGUAGE                = LS_STXH-TDSPRAS "sy-langu
          NAME                    = LS_STXH-TDNAME  "4410LE00027EB001'
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = I_TLINE
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
    ENDIF.

    READ TABLE LT_STXH1 INTO LS_STXH1 INDEX 1.
    IF SY-SUBRC = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          ID                      = LS_STXH1-TDID    "GRUN
          LANGUAGE                = LS_STXH1-TDSPRAS "sy-langu
          NAME                    = LS_STXH1-TDNAME  "4410LE00027EB001'
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = I_TLINE1
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
    ENDIF.

    LOOP AT I_TLINE.
      CONCATENATE LV_TEXT I_TLINE-TDLINE INTO LV_TEXT SEPARATED BY SPACE.
      CLEAR: I_TLINE.
    ENDLOOP.

    LOOP AT I_TLINE1.
      CONCATENATE LV_TEXT1 I_TLINE1-TDLINE INTO LV_TEXT1 SEPARATED BY SPACE.
      CLEAR: I_TLINE1.
    ENDLOOP.


    "get Material Long Text EN
    ALV_STB1-ZZTEXT_EN = LV_TEXT. """""""""""""""""""""""""""""""""""""""""added ON 26.042019 BY MRUNALEE
    ALV_STB1-ZZTEXT_SP = LV_TEXT1.

    MODIFY ALV_STB1 TRANSPORTING ZZTEXT_EN ZZTEXT_SP.

    CLEAR : LV_TEXT,ALV_STB1-ZZTEXT_EN,ALV_STB1-ZZTEXT_SP,LV_TEXT1.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BDC1 .
  REFRESH BDCDATA[].
  REFRESH LT_BDCMSG[].

  PERFORM BDC_DYNPRO      USING 'ZCS12' '1000'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'PM_MTNRV'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=ONLI'.
  PERFORM BDC_FIELD       USING 'PM_MTNRV'
                                 WA_MAST-MATNR.    "'A5003C-20001426-02'.
  PERFORM BDC_FIELD       USING 'PM_WERKS'
                                PM_WERKS.        "'PL01'.
  PERFORM BDC_FIELD       USING 'PM_CAPID'
                                PM_CAPID.        "'PP01'.
  PERFORM BDC_FIELD       USING 'PM_DATUV'
                                LV_DATE.         "'02.04.2019'.
  PERFORM BDC_FIELD       USING 'PM_EHNDL'
                                '1'.
  PERFORM BDC_DYNPRO      USING 'SAPMSSY0' '0120'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=&F03'.
  PERFORM BDC_DYNPRO      USING 'ZCS12' '1000'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '/EENDE'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'PM_MTNRV'.


  CALL TRANSACTION 'ZCS12_NEW'
          USING BDCDATA
                MODE CTU_MODE
                UPDATE 'S'
                MESSAGES INTO LT_BDCMSG.
ENDFORM.
