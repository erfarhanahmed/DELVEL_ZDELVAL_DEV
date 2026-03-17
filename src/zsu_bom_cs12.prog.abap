*&---------------------------------------------------------------------*
*&Report: ZSU_BOM_CS12
*&Transaction: ZSU_CS12
*&Functional Cosultant: Subhashish Pande
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* 1.Program Owner           : Primus Techsystems Pvt Ltd.              *
* 2.Project                 : Display BOM Level by Level cs12          *
* 3.Program Name            : ZPP_MULTILEVEL_BOM                       *
* 4.Module Name             : PP                                       *
* 5.Request No              : EEDK903445                               *
* 6.Creation Date           : 02.04.2019                               *
* 7.Created/Changed BY      : Mrunalee Deshmukh                        *
* 8.Functional Consultant   : Anuj Deshpande                           *
* 9.Description             : Display BOM Level by Level               *
* 10.Tcode                  : zcs12                                        *
*&---------------------------------------------------------------------*
* 1.Program Owner           : Primus Techsystems Pvt Ltd.              *
* 2.Project                 : Display BOM Level by Level cs12          *
* 3.Program Name            : ZBOM_CS12                    *
* 4.Module Name             : PP                                       *
* 5.Request No              : DEVK908535                               *
* 6.Creation Date           : 02.04.2019                               *
* 7.Created/Changed BY      : Nilay Brahme                        *
* 8.Functional Consultant   : Subhashish Pande                           *
* 9.Description             : Display BOM Level by Level               *
* 10.Tcode                  : ZCS12
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT zbom_cs12
       NO STANDARD PAGE HEADING LINE-SIZE 255.
*&*--------------------------------------------------------------------*
*&* TABLES
*&*--------------------------------------------------------------------*
TABLES: mara.
*&*--------------------------------------------------------------------*
*&* STRUCTURE & INTERNAL TABLE DECLERATION
*&*--------------------------------------------------------------------*

DATA: BEGIN OF alv_stb OCCURS 100.
    INCLUDE STRUCTURE stpox_alv.
DATA : lv_cnt(3).
DATA: info(3) TYPE c,
*        MATNR   TYPE MARA-MATNR,
*        BISMT   TYPE MARA-BISMT,
*        BRAND   TYPE MARA-BRAND,
*        ZSERIES TYPE MARA-ZSERIES,
*        ZSIZE   TYPE MARA-ZSIZE,
*        MOC     TYPE MARA-MOC,
*        TYPE    TYPE MARA-TYPE,
      END OF alv_stb.

DATA: BEGIN OF dsp_sel OCCURS 20,                           "YHG139715
        text(30),                                           "YHG139715
        filler(2) VALUE '_ ',                               "YHG139715
        wert(32),                                           "YHG139715
      END OF dsp_sel.                                       "YHG139715

DATA: BEGIN OF alv_stb1 OCCURS 0.
    INCLUDE STRUCTURE stpox_alv.

DATA : lv_cnt(3).
DATA: info(3) TYPE c.
DATA: line_color(4) TYPE c,     "Used to store row color attributes
        MATNR   TYPE MARA-MATNR,
        BISMT   TYPE MARA-BISMT,
        BRAND   TYPE MARA-BRAND,
        ZSERIES TYPE MARA-ZSERIES,
        ZSIZE   TYPE MARA-ZSIZE,
        MOC     TYPE MARA-MOC,
        TYPE    TYPE MARA-TYPE,
      END OF alv_stb1.
DATA : cnt        TYPE sy-tabix.
DATA: BEGIN OF alv_stb2 OCCURS 0.
    INCLUDE STRUCTURE stpox_alv.
DATA : lv_cnt(3).
DATA: info(3) TYPE c.
DATA: line_color(4) TYPE c,     "Used to store row color attributes
      END OF alv_stb2.
DATA: BEGIN OF ftab OCCURS 200.
    INCLUDE STRUCTURE dfies.
DATA: END   OF ftab.

TYPES: BEGIN OF ty_mbew,
         matnr TYPE mbew-matnr,
         bwkey TYPE mbew-bwkey,
         bwtar TYPE mbew-bwtar,
         vprsv TYPE mbew-vprsv,
         verpr TYPE mbew-verpr,
         stprs TYPE mbew-stprs,
       END OF ty_mbew.

DATA: lt_mbew TYPE TABLE OF ty_mbew,
      ls_mbew TYPE ty_mbew.

TYPES : BEGIN OF ty_mbew1,
          matnr TYPE mbew-matnr,
          werks TYPE mbew-bwkey,
        END OF ty_mbew1.
DATA : lt_mbew1 TYPE TABLE OF ty_mbew1,
       ls_mbew1 TYPE ty_mbew1.

TYPES : BEGIN OF ty_makt,
          mandt TYPE makt-mandt,
          matnr TYPE makt-matnr,
          spras TYPE makt-spras,
          maktx TYPE makt-maktx,
        END OF ty_makt.

DATA : lt_makt TYPE TABLE OF ty_makt,
       ls_makt TYPE ty_makt.

TYPES : BEGIN OF ty_mast,
        matnr TYPE mast-matnr,
        werks TYPE mast-werks,
        stlan TYPE mast-stlan,
        stlnr TYPE mast-stlnr,
        stlal TYPE mast-stlal,
        END OF ty_mast.

DATA : it_mast TYPE TABLE OF ty_mast,
       wa_mast TYPE          ty_mast.

"""""""""""""""""""""""""""""""""""""ADDED BY SP ON 22.09.2023"""""""""""""""""""""""""""
TYPES : BEGIN OF TY_MARA,
        MATNR   TYPE MARA-MATNR,
        BISMT   TYPE MARA-BISMT,
        BRAND(3),
        ZSERIES(3),
        ZSIZE(3),
        MOC(3),
        TYPE(3),

*        BRAND   TYPE MARA-BRAND,
*        ZSERIES TYPE MARA-ZSERIES,
*        ZSIZE   TYPE MARA-ZSIZE,
*        MOC     TYPE MARA-MOC,
*        TYPE    TYPE MARA-TYPE,
        END OF TY_MARA.
DATA : WA_MARA TYPE TY_MARA,
       IT_MARA TYPE TABLE OF TY_MARA.

TYPES : BEGIN OF TY_FINAL,
        BISMT   TYPE MARA-BISMT,
        BRAND(3),
        ZSERIES(3),
        ZSIZE(3),
        MOC(3),
        TYPE(3),
        END OF TY_FINAL.
DATA : WA_FINAL TYPE TY_FINAL,
       IT_FINAL TYPE TABLE OF TY_FINAL.
"""""""""""""""""""""""""""""""""""""ADDED BY SP ON 22.09.2023"""""""""""""""""""""""""""

DATA:
  wa_stb_fields_tb TYPE slis_fieldcat_alv,
  stb_fields_tb    TYPE slis_t_fieldcat_alv,
  report_name      LIKE sy-repid,
  alvlo_stb        TYPE slis_layout_alv,
  bdcdata          TYPE TABLE OF bdcdata WITH HEADER LINE,
  lt_bdcmsg        TYPE TABLE OF bdcmsgcoll,
  ls_bdcmsg        TYPE bdcmsgcoll,
  lv_matnr         TYPE mara-matnr.
DATA:
  alvvr_sav_all    TYPE c VALUE 'A',
  alvvr_sav_no_usr TYPE c VALUE 'X'.
DATA:lv_day(2),
     lv_month(2),
     lv_year(4),
     lv_date(10).
DATA : lv_cnt(3) VALUE 1.
DATA : cnt3      TYPE sy-tabix.
DATA : cnt1     TYPE sy-tabix.
DATA : lv_tabix TYPE sy-tabix.

**Added by sarika Thange 22.04.2019
TYPES : BEGIN OF ty_down_ftp,
          dglvl          TYPE char10,
          posnr          TYPE posnr,
*          objic    TYPE string,
          dobjt          TYPE sobjid,
          ojtxp          TYPE ojtxp,
          ovfls          TYPE ovfls,
          mngko          TYPE char15,
          meins          TYPE meins,
          postp          TYPE postp,
          ausnm          TYPE ausnm,
          sgt_rcat       TYPE sgt_rcat,
          sgt_scat       TYPE sgt_scat,
          verpr          TYPE char15,
          zztext_en      TYPE char250,
          zztext_sp      TYPE char250,
          ref_dt         TYPE char11,
           TIME     TYPE CHAR10,

        END OF ty_down_ftp.

DATA : gt_down_ftp TYPE TABLE OF ty_down_ftp,
       gs_down_ftp TYPE ty_down_ftp.
TABLES:MARC.
"------------------------------------------------------
DATA :i_tline TYPE STANDARD TABLE OF tline WITH HEADER LINE.
DATA :i_tline1 TYPE STANDARD TABLE OF tline WITH HEADER LINE.
DATA : lv_ebeln(70) TYPE c.
DATA : lv_text(20000) TYPE c.
DATA : lv_text1(20000) TYPE c.

DATA : lt_stxh TYPE TABLE OF stxh,
       ls_stxh TYPE stxh.

DATA : lt_stxh1 TYPE TABLE OF stxh,
       ls_stxh1 TYPE stxh.

CONSTANTS : lv_spras(01) TYPE c VALUE 'S'.      "stxh-tdspras

*&*--------------------------------------------------------------------*
*&* SELECTION SCREEN
*&*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001 .
SELECT-OPTIONS : s_matnr  FOR mara-matnr  NO INTERVALS.
PARAMETERS     :  pm_werks LIKE marc-werks DEFAULT 'SU01' MODIF ID BU .
PARAMETERS     :
                 pm_datuv LIKE stko-datuv DEFAULT sy-datum,
                 pm_stlan LIKE stzu-stlan,
                 pm_stlal LIKE stko-stlal,
                 pm_capid LIKE tc04-capid,
                 ctu_mode LIKE ctu_params-dismode DEFAULT 'N' NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK b1.

**Added By Sarika Thange 06.03.2019
SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/Saudi'."Saudi'."Saudi'.  "'E:/delval/Saudi'
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.


AT SELECTION-SCREEN OUTPUT. " ADDED BY MD
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
*&*--------------------------------------------------------------------*
*&* START OF SELECTION
*&*--------------------------------------------------------------------*
START-OF-SELECTION.

IF s_matnr IS INITIAL.
  SELECT matnr
         werks
         stlan
         stlnr
         stlal FROM mast INTO TABLE it_mast
         WHERE werks = pm_werks.
  PERFORM fetch_data1.         "Fetch Data
ELSE.
  PERFORM fetch_data.         "Fetch Data
ENDIF.


*  PERFORM fetch_data.         "Fetch Data
  PERFORM data_retrieval.     "Color Rows in report
  IF p_down = 'X'.
    BREAK primus.
    PERFORM download.
  ELSE.
    PERFORM stb_fields_tb_prep. "Field Catlog
  ENDIF.



*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
FORM fetch_data.
**Current Date
  CLEAR:lv_day,lv_month,lv_year,lv_date.
  lv_day   = pm_datuv+6(2).
  lv_month = pm_datuv+4(2).
  lv_year  = pm_datuv+0(4).

  CONCATENATE lv_day lv_month lv_year INTO lv_date SEPARATED BY '.'.


  SELECT mandt
         matnr
         spras
         maktx
    FROM makt
    INTO TABLE lt_makt
    WHERE matnr IN s_matnr
    AND   spras EQ 'E'.


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  LOOP AT s_matnr.
*    cnt1 = sy-tabix.
    "Report:ZCS11
    PERFORM bdc.
    "Import From "Report-ZCS11"
    IMPORT alv_stb[] FROM MEMORY ID 'ALV_STB'.
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

    IF alv_stb[] IS NOT INITIAL.
      "GET MATERIAL DESCRIPTION         """""""""""""""""""""ADDED ON 16.042019 BY MRUNALEE
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = s_matnr-low.
      IF sy-subrc = 0.
        alv_stb-ojtxp = ls_makt-maktx.
      ENDIF.
      "GET MATERIAL NUMBER
      alv_stb-dobjt = s_matnr-low.
      INSERT alv_stb INTO alv_stb[] INDEX 1. "
      APPEND LINES OF alv_stb[] TO alv_stb1[] .
    ENDIF.

    REFRESH alv_stb[].
    FREE MEMORY ID 'ALV_STB'.
    CLEAR:s_matnr,cnt1.
  ENDLOOP.

  LOOP AT alv_stb1 INTO alv_stb1.
    ls_mbew1-matnr = alv_stb1-dobjt.
    ls_mbew1-werks = alv_stb1-werks.
    APPEND ls_mbew1 TO lt_mbew1.
    CLEAR : ls_mbew1 , alv_stb1.
  ENDLOOP.
*
  SELECT   matnr
           bwkey
           bwtar
           vprsv
           verpr
           stprs
    FROM mbew
    INTO TABLE lt_mbew
    FOR ALL ENTRIES IN lt_mbew1
    WHERE matnr = lt_mbew1-matnr
    AND   bwkey = lt_mbew1-werks.

  LOOP AT alv_stb1 INTO alv_stb1.
    cnt3 = sy-tabix.
    READ TABLE lt_mbew1 INTO ls_mbew1 WITH KEY matnr = alv_stb1-dobjt werks = alv_stb1-werks.
    IF sy-subrc = 0..
      READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_mbew1-matnr bwkey = ls_mbew1-werks.
      IF sy-subrc = 0.
        alv_stb1-verpr = ls_mbew-verpr.
        MODIFY alv_stb1 FROM alv_stb1 INDEX cnt3 TRANSPORTING verpr.
      ENDIF.
    ENDIF.

endloop.
    """""""""""""""""""""""""""""""""""""""""""""""""""ADDED BY SP 0N 22.09.2023"""""""""""""""""""""""""""""
LOOP at  alv_stb1.

    IF ALV_STB1[] IS NOT INITIAL.
    SELECT MATNR
           BISMT
           BRAND
           ZSERIES
           ZSIZE
           MOC
           TYPE
       FROM MARA
       INTO TABLE IT_MARA
       FOR ALL ENTRIES IN ALV_STB1[]
      WHERE MATNR = ALV_STB1-IDNRK.

  ENDIF.

  READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = ALV_STB1-IDNRK.
*  ALV_STB1-BISMT = WA_MARA-BISMT.
   ALV_STB1-BISMT    = WA_MARA-BISMT   .
   ALV_STB1-BRAND    = WA_MARA-BRAND   .
   ALV_STB1-ZSERIES  = WA_MARA-ZSERIES .
   ALV_STB1-ZSIZE    = WA_MARA-ZSIZE   .
   ALV_STB1-MOC      = WA_MARA-MOC     .
   ALV_STB1-TYPE     = WA_MARA-TYPE    .

  MODIFY alv_stb1 FROM alv_stb1 TRANSPORTING  bismt  brand zseries zsize moc type.
 CLEAR : wa_mara,alv_stb1.
*   APPEND LINES OF alv_stb[] TO alv_stb1[] .
**   APPEND WA_FINAL TO IT_FINAL.
  ENDLOOP.

  """""""""""""""""""""""""""""""""""""""""""""""""""ADDED BY SP 0N 22.09.2023"""""""""""""""""""""""""""""


    CLEAR : ls_mbew,alv_stb1,cnt3,ls_mbew.






  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""to get the long text
  LOOP AT alv_stb1.

    lv_ebeln = alv_stb1-dobjt.

    SELECT *
      FROM stxh
      INTO TABLE lt_stxh
    WHERE tdobject = 'MATERIAL'
      AND tdname   = lv_ebeln
      AND  tdspras = 'EN'
      AND tdid     = 'GRUN'.

    SELECT *
     FROM stxh
     INTO TABLE lt_stxh1
   WHERE tdobject = 'MATERIAL'
     AND tdname   = lv_ebeln
     AND  tdspras = lv_spras
     AND tdid     = 'GRUN'.


*    LOOP AT lt_stxh INTO ls_stxh.

    READ TABLE lt_stxh INTO ls_stxh INDEX 1.
    IF sy-subrc = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = ls_stxh-tdid    "GRUN
          language                = ls_stxh-tdspras "sy-langu
          name                    = ls_stxh-tdname  "4410LE00027EB001'
          object                  = 'MATERIAL'
        TABLES
          lines                   = i_tline
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
    ENDIF.

    READ TABLE lt_stxh1 INTO ls_stxh1 INDEX 1.
    IF sy-subrc = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = ls_stxh1-tdid    "GRUN
          language                = ls_stxh1-tdspras "sy-langu
          name                    = ls_stxh1-tdname  "4410LE00027EB001'
          object                  = 'MATERIAL'
        TABLES
          lines                   = i_tline1
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
    ENDIF.

    LOOP AT i_tline.
      CONCATENATE lv_text i_tline-tdline INTO lv_text SEPARATED BY space.
      CLEAR: i_tline.
    ENDLOOP.

    LOOP AT i_tline1.
      CONCATENATE lv_text1 i_tline1-tdline INTO lv_text1 SEPARATED BY space.
      CLEAR: i_tline1.
    ENDLOOP.


    "get Material Long Text EN
    alv_stb1-zztext_en = lv_text. """""""""""""""""""""""""""""""""""""""""added ON 26.042019 BY MRUNALEE
    alv_stb1-zztext_sp = lv_text1.

    MODIFY alv_stb1 TRANSPORTING zztext_en zztext_sp.

    CLEAR : lv_text,alv_stb1-zztext_en,alv_stb1-zztext_sp,lv_text1.

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
FORM bdc.
  REFRESH bdcdata[].
  REFRESH lt_bdcmsg[].

  PERFORM bdc_dynpro      USING 'ZCS12' '1000'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'PM_MTNRV'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=ONLI'.
  PERFORM bdc_field       USING 'PM_MTNRV'
                                 s_matnr-low.    "'A5003C-20001426-02'.
  PERFORM bdc_field       USING 'PM_WERKS'
                                pm_werks.        "'PL01'.
  PERFORM bdc_field       USING 'PM_CAPID'
                                pm_capid.        "'PP01'.
  PERFORM bdc_field       USING 'PM_DATUV'
                                lv_date.         "'02.04.2019'.
  PERFORM bdc_field       USING 'PM_EHNDL'
                                '1'.
  PERFORM bdc_dynpro      USING 'SAPMSSY0' '0120'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=&F03'.
  PERFORM bdc_dynpro      USING 'ZCS12' '1000'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/EENDE'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'PM_MTNRV'.


  CALL TRANSACTION 'ZCS12_NEW'
          USING bdcdata
                MODE ctu_mode
                UPDATE 'S'
                MESSAGES INTO lt_bdcmsg.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  STB_FIELDS_TB_PREP
*&---------------------------------------------------------------------*
FORM stb_fields_tb_prep.

  "Field Documentation
  CALL FUNCTION 'DDIF_FIELDINFO_GET'                          "uc 070302
    EXPORTING                                                 "uc 070302
      langu     = sy-langu                                    "uc 070302
      tabname   = 'STPOX_ALV'                                 "uc 070302
*     UCLEN     = '01'                                        "uc 070302
    TABLES                                                    "uc 070302
      dfies_tab = ftab                                        "uc 070302
    EXCEPTIONS                                                "uc 070302
      OTHERS    = 1.                                          "uc 070302

  LOOP AT ftab.
    CLEAR: wa_stb_fields_tb.
 alvlo_stb-COLWIDTH_OPTIMIZE = 'X'.
* alvlo_stb- = 'X'.
    CASE ftab-fieldname.
      WHEN 'DGLVL'.
        wa_stb_fields_tb-fieldname = 'DGLVL'.
        wa_stb_fields_tb-col_pos   =  1.
        wa_stb_fields_tb-fix_column = 'X' .
        wa_stb_fields_tb-outputlen = 11.
        wa_stb_fields_tb-just      = 'L' .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'POSNR'.
        wa_stb_fields_tb-fieldname = 'POSNR'.
        wa_stb_fields_tb-col_pos   =  2.
        wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-outputlen = 4 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'OBJIC'.
        wa_stb_fields_tb-fieldname = 'OBJIC'.
        wa_stb_fields_tb-col_pos   =  3.
        wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-outputlen = 3 .
        wa_stb_fields_tb-icon       =  'X' .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'DOBJT'.
        wa_stb_fields_tb-fieldname = 'DOBJT'.
        wa_stb_fields_tb-col_pos   =  4.
        wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-outputlen = 23 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'OJTXP'.
        wa_stb_fields_tb-fieldname = 'OJTXP'.
        wa_stb_fields_tb-col_pos   =  5.
        wa_stb_fields_tb-outputlen = 19.
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'OVFLS'.
        wa_stb_fields_tb-fieldname = 'OVFLS'.
        wa_stb_fields_tb-col_pos   = 6.
        wa_stb_fields_tb-outputlen = 3 .
        wa_stb_fields_tb-just      = 'R' .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'MNGKO'.
        wa_stb_fields_tb-fieldname = 'MNGKO'.
        wa_stb_fields_tb-col_pos   = 7.
        wa_stb_fields_tb-outputlen = 18.
        wa_stb_fields_tb-no_sum    = 'X'.
        wa_stb_fields_tb-no_zero   = 'X'.
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'MEINS'.
        wa_stb_fields_tb-fieldname = 'MEINS'.
        wa_stb_fields_tb-col_pos   = 8.
        wa_stb_fields_tb-outputlen = 3 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'POSTP'.
        wa_stb_fields_tb-fieldname = 'POSTP'.
        wa_stb_fields_tb-col_pos   = 9.
        wa_stb_fields_tb-outputlen = 3 .
        wa_stb_fields_tb-just      = 'C' .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'AUSNM'.
        wa_stb_fields_tb-fieldname = 'AUSNM'.
        wa_stb_fields_tb-col_pos   = 10.
        wa_stb_fields_tb-outputlen = 5 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'SGT_RCAT'.
        wa_stb_fields_tb-fieldname = 'SGT_RCAT'.  "requirement segment
        wa_stb_fields_tb-col_pos   = 11.
        wa_stb_fields_tb-outputlen = 16 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'SGT_SCAT'.
        wa_stb_fields_tb-fieldname = 'SGT_SCAT'.       "stock segment
        wa_stb_fields_tb-col_pos   = 12.
        wa_stb_fields_tb-outputlen = 16 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'VERPR'.
        wa_stb_fields_tb-fieldname = 'VERPR'.       "Moving Average price
        wa_stb_fields_tb-col_pos   = 13.
        wa_stb_fields_tb-outputlen = 16 .
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'ZZTEXT_EN'.
        wa_stb_fields_tb-fieldname = 'ZZTEXT_EN'.       "Material Long Text EN
        wa_stb_fields_tb-col_pos   = 14.
        wa_stb_fields_tb-outputlen = 20.
        wa_stb_fields_tb-seltext_l = TEXT-032.
        APPEND wa_stb_fields_tb TO stb_fields_tb.

      WHEN 'ZZTEXT_SP'.
        wa_stb_fields_tb-fieldname = 'ZZTEXT_SP'.       "Material Long Text SP
        wa_stb_fields_tb-col_pos   = 15.
        wa_stb_fields_tb-outputlen = 20.
        wa_stb_fields_tb-seltext_l = TEXT-033.
        APPEND wa_stb_fields_tb TO stb_fields_tb.
         CLEAR wa_stb_fields_tb .
        """""""""""""""""""ADDED BY SP ON 22.09.2023""""""""""""""""""""""""

        """"""""""""""""""""ADDED BY SP ON 22.09.2023""""""""""""""""""""""""

      WHEN OTHERS.
        wa_stb_fields_tb-fieldname = ftab-fieldname.
        wa_stb_fields_tb-no_out    = 'X'.
        wa_stb_fields_tb-no_sum    = 'X'.
        wa_stb_fields_tb-outputlen    = 5.
        APPEND wa_stb_fields_tb TO stb_fields_tb.
      CLEAR wa_stb_fields_tb .


    ENDCASE.

  ENDLOOP.

        wa_stb_fields_tb-fieldname = 'BISMT'.       "Material Long Text SP
        wa_stb_fields_tb-col_pos   = 16.
         wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-outputlen = 5.
        wa_stb_fields_tb-DDIC_OUTPUTLEN = 3.
        wa_stb_fields_tb-DDICTXT = 'S'.
        wa_stb_fields_tb-seltext_l = 'Old Material'.
        APPEND wa_stb_fields_tb TO stb_fields_tb.
        CLEAR wa_stb_fields_tb .

         wa_stb_fields_tb-fieldname = 'BRAND'.       "Material Long Text SP
        wa_stb_fields_tb-col_pos   = 17.
*        wa_stb_fields_tb-outputlen = 3.
          wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-DDIC_OUTPUTLEN = '3'.
        wa_stb_fields_tb-seltext_l = 'Brand'.
        APPEND wa_stb_fields_tb TO stb_fields_tb.
        CLEAR wa_stb_fields_tb .

         wa_stb_fields_tb-fieldname = 'ZSERIES'.       "Material Long Text SP
*        wa_stb_fields_tb-col_pos   = 16.
        wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-outputlen = 3.
        wa_stb_fields_tb-seltext_l = 'Series'.
        APPEND wa_stb_fields_tb TO stb_fields_tb.
        CLEAR wa_stb_fields_tb .

         wa_stb_fields_tb-fieldname = 'ZSIZE'.       "Material Long Text SP
*        wa_stb_fields_tb-col_pos   = 16.
*        wa_stb_fields_tb-outputlen = 5.
        wa_stb_fields_tb-seltext_l = 'Size'.
        APPEND wa_stb_fields_tb TO stb_fields_tb.
        CLEAR wa_stb_fields_tb .

         wa_stb_fields_tb-fieldname = 'MOC'.       "Material Long Text SP
*        wa_stb_fields_tb-col_pos   = 16.
         wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-outputlen = 3.
        wa_stb_fields_tb-seltext_l = 'Moc'.
        APPEND wa_stb_fields_tb TO stb_fields_tb.
        CLEAR wa_stb_fields_tb .

         wa_stb_fields_tb-fieldname = 'TYPE'.       "Material Long Text SP
*        wa_stb_fields_tb-col_pos   = 16.
         wa_stb_fields_tb-fix_column =  'X' .
        wa_stb_fields_tb-outputlen = 3.
        wa_stb_fields_tb-seltext_l = 'Type'.
        APPEND wa_stb_fields_tb TO stb_fields_tb.
        CLEAR wa_stb_fields_tb .

  "Row color in Report
  alvlo_stb-info_fieldname = 'LINE_COLOR'.


  "Display Report
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = alvlo_stb
      i_save             = 'X'
      i_structure_name   = 'STPOX_ALV'
      it_fieldcat        = stb_fields_tb
    TABLES
      t_outtab           = alv_stb1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
ENDFORM. "stb_fields_tb_prep

*&---------------------------------------------------------------------*
*&      Form  DATA_RETRIEVAL
*&---------------------------------------------------------------------*

FORM data_retrieval.
  DATA: ld_color(1) TYPE c.
*Populate field with color attributes
  LOOP AT alv_stb1.
    IF alv_stb1-posnr IS INITIAL AND alv_stb1-dstuf IS NOT INITIAL.
* Populate color variable with colour properties("alv_stb1-line_color")
* Char 1 = C (This is a color property)
* Char 2 = 3 (Color codes: 1 - 7)
* Char 3 = Intensified on/off ( 1 or 0 )
* Char 4 = Inverse display on/off ( 1 or 0 )
      "Yellow
      ld_color = 3.

      CONCATENATE 'C' ld_color '00' INTO alv_stb1-line_color.
      MODIFY alv_stb1 TRANSPORTING line_color.
    ELSEIF alv_stb1-posnr IS INITIAL AND alv_stb1-dstuf IS INITIAL.
      "Red
      ld_color = 6.

      CONCATENATE 'C' ld_color '00' INTO alv_stb1-line_color.
      MODIFY alv_stb1 TRANSPORTING line_color.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " DATA_RETRIEVAL
*----------------------------------------------------------------------*
*        START NEW SCREEN                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        INSERT FIELD                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF FVAL <> NODATA.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
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
FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  PERFORM fill_ftp_str.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_down_ftp
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.


  lv_file = 'ZSU_CS12.TXT'.

*  CONCATENATE p_folder '\' lv_file
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZSU_CS12 Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_898 TYPE string.
DATA lv_crlf_898 TYPE string.
lv_crlf_898 = cl_abap_char_utilities=>cr_lf.
lv_string_898 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_898 lv_crlf_898 wa_csv INTO lv_string_898.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_898 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
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
FORM fill_ftp_str .

  LOOP AT alv_stb1 INTO DATA(wa_final).

    gs_down_ftp-dglvl     = wa_final-dglvl.
    gs_down_ftp-posnr     = wa_final-posnr.
    gs_down_ftp-dobjt     = wa_final-dobjt.
    gs_down_ftp-ojtxp     = wa_final-ojtxp.
    gs_down_ftp-ovfls     = wa_final-ovfls.
    gs_down_ftp-mngko     = wa_final-mngko.
    gs_down_ftp-meins     = wa_final-meins..
    gs_down_ftp-postp     = wa_final-postp.
    gs_down_ftp-ausnm     = wa_final-ausnm.
    gs_down_ftp-sgt_rcat  = wa_final-sgt_rcat.
    gs_down_ftp-sgt_scat  = wa_final-sgt_scat.
    gs_down_ftp-verpr     = wa_final-verpr.
    gs_down_ftp-zztext_en = wa_final-zztext_en.
    gs_down_ftp-zztext_sp = wa_final-zztext_sp.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = gs_down_ftp-ref_dt.

    CONCATENATE gs_down_ftp-ref_dt+0(2) gs_down_ftp-ref_dt+2(3) gs_down_ftp-ref_dt+5(4) INTO gs_down_ftp-ref_dt SEPARATED BY '-'.

     CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO gs_down_ftp-TIME SEPARATED BY ':'.

    APPEND gs_down_ftp TO gt_down_ftp.
    CLEAR : gs_down_ftp,wa_final.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE
  'Explosion Level'
  'Item Number'
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
  'Refreshed Date'
  'Refreshed Time'


  INTO pd_csv
  SEPARATED BY l_field_seperator.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data1 .
**Current Date
  CLEAR:lv_day,lv_month,lv_year,lv_date.
  lv_day   = pm_datuv+6(2).
  lv_month = pm_datuv+4(2).
  lv_year  = pm_datuv+0(4).

  CONCATENATE lv_day lv_month lv_year INTO lv_date SEPARATED BY '.'.


  SELECT mandt
         matnr
         spras
         maktx
    FROM makt
    INTO TABLE lt_makt
    FOR ALL ENTRIES IN it_mast
    WHERE matnr = it_mast-matnr "IN s_matnr
    AND   spras EQ 'E'.


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  LOOP AT it_mast INTO wa_mast.
*    cnt1 = sy-tabix.
    "Report:ZCS11
    PERFORM bdc1.
    "Import From "Report-ZCS11"
    IMPORT alv_stb[] FROM MEMORY ID 'ALV_STB'.

    IF alv_stb[] IS NOT INITIAL.
      "GET MATERIAL DESCRIPTION         """""""""""""""""""""ADDED ON 16.042019 BY MRUNALEE
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = wa_mast-matnr."s_matnr-low.
      IF sy-subrc = 0.
        alv_stb-ojtxp = ls_makt-maktx.
      ENDIF.
      "GET MATERIAL NUMBER
      alv_stb-dobjt = wa_mast-matnr.  "s_matnr-low.
      INSERT alv_stb INTO alv_stb[] INDEX 1. "
      APPEND LINES OF alv_stb[] TO alv_stb1[] .
    ENDIF.

    REFRESH alv_stb[].
    FREE MEMORY ID 'ALV_STB'.
    CLEAR:wa_mast,cnt1.
  ENDLOOP.

  LOOP AT alv_stb1 INTO alv_stb1.
    ls_mbew1-matnr = alv_stb1-dobjt.
    ls_mbew1-werks = alv_stb1-werks.
    APPEND ls_mbew1 TO lt_mbew1.
    CLEAR : ls_mbew1 , alv_stb1.
  ENDLOOP.
*
  SELECT   matnr
           bwkey
           bwtar
           vprsv
           verpr
           stprs
    FROM mbew
    INTO TABLE lt_mbew
    FOR ALL ENTRIES IN lt_mbew1
    WHERE matnr = lt_mbew1-matnr
    AND   bwkey = lt_mbew1-werks.

  LOOP AT alv_stb1 INTO alv_stb1.
    cnt3 = sy-tabix.
    READ TABLE lt_mbew1 INTO ls_mbew1 WITH KEY matnr = alv_stb1-dobjt werks = alv_stb1-werks.
    IF sy-subrc = 0..
      READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_mbew1-matnr bwkey = ls_mbew1-werks.
      IF sy-subrc = 0.
        alv_stb1-verpr = ls_mbew-verpr.
        MODIFY alv_stb1 FROM alv_stb1 INDEX cnt3 TRANSPORTING verpr.
      ENDIF.
    ENDIF.

    CLEAR : ls_mbew,alv_stb1,cnt3,ls_mbew.
  ENDLOOP.


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""to get the long text
  LOOP AT alv_stb1.

    lv_ebeln = alv_stb1-dobjt.

    SELECT *
      FROM stxh
      INTO TABLE lt_stxh
    WHERE tdobject = 'MATERIAL'
      AND tdname   = lv_ebeln
      AND  tdspras = 'EN'
      AND tdid     = 'GRUN'.

    SELECT *
     FROM stxh
     INTO TABLE lt_stxh1
   WHERE tdobject = 'MATERIAL'
     AND tdname   = lv_ebeln
     AND  tdspras = lv_spras
     AND tdid     = 'GRUN'.


*    LOOP AT lt_stxh INTO ls_stxh.

    READ TABLE lt_stxh INTO ls_stxh INDEX 1.
    IF sy-subrc = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = ls_stxh-tdid    "GRUN
          language                = ls_stxh-tdspras "sy-langu
          name                    = ls_stxh-tdname  "4410LE00027EB001'
          object                  = 'MATERIAL'
        TABLES
          lines                   = i_tline
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
    ENDIF.

    READ TABLE lt_stxh1 INTO ls_stxh1 INDEX 1.
    IF sy-subrc = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = ls_stxh1-tdid    "GRUN
          language                = ls_stxh1-tdspras "sy-langu
          name                    = ls_stxh1-tdname  "4410LE00027EB001'
          object                  = 'MATERIAL'
        TABLES
          lines                   = i_tline1
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
    ENDIF.

    LOOP AT i_tline.
      CONCATENATE lv_text i_tline-tdline INTO lv_text SEPARATED BY space.
      CLEAR: i_tline.
    ENDLOOP.

    LOOP AT i_tline1.
      CONCATENATE lv_text1 i_tline1-tdline INTO lv_text1 SEPARATED BY space.
      CLEAR: i_tline1.
    ENDLOOP.


    "get Material Long Text EN
    alv_stb1-zztext_en = lv_text. """""""""""""""""""""""""""""""""""""""""added ON 26.042019 BY MRUNALEE
    alv_stb1-zztext_sp = lv_text1.

    MODIFY alv_stb1 TRANSPORTING zztext_en zztext_sp.

    CLEAR : lv_text,alv_stb1-zztext_en,alv_stb1-zztext_sp,lv_text1.

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
FORM bdc1 .
REFRESH bdcdata[].
  REFRESH lt_bdcmsg[].

  PERFORM bdc_dynpro      USING 'ZCS12' '1000'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'PM_MTNRV'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=ONLI'.
  PERFORM bdc_field       USING 'PM_MTNRV'
                                 wa_mast-matnr.    "'A5003C-20001426-02'.
  PERFORM bdc_field       USING 'PM_WERKS'
                                pm_werks.        "'PL01'.
  PERFORM bdc_field       USING 'PM_CAPID'
                                pm_capid.        "'PP01'.
  PERFORM bdc_field       USING 'PM_DATUV'
                                lv_date.         "'02.04.2019'.
  PERFORM bdc_field       USING 'PM_EHNDL'
                                '1'.
  PERFORM bdc_dynpro      USING 'SAPMSSY0' '0120'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=&F03'.
  PERFORM bdc_dynpro      USING 'ZCS12' '1000'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/EENDE'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'PM_MTNRV'.


  CALL TRANSACTION 'ZCS12_NEW'
          USING bdcdata
                MODE ctu_mode
                UPDATE 'S'
                MESSAGES INTO lt_bdcmsg.
ENDFORM.
