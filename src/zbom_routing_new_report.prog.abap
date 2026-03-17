*&---------------------------------------------------------------------*
*& Report ZPP_BOM_ROUTING_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPP_BOM_ROUTING_REPORT
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

TYPES : BEGIN OF ty_marc,
        matnr TYPE marc-matnr,
        werks TYPE marc-werks,
        beskz TYPE marc-beskz,
        sobsl TYPE marc-sobsl,
        sobsk type marc-sobsk,   "added by vs on 17/6/2020.
        END OF ty_marc.

DATA : lt_marc TYPE TABLE OF ty_marc,
       ls_marc TYPE          ty_marc.


TYPES: BEGIN OF final ,
*      INCLUDE STRUCTURE stpox_alv.
     dglvl          TYPE dglvl,
     posnr          TYPE posnr,
     objic          TYPE string,
     dobjt          TYPE sobjid,
     header         TYPE sobjid,
     ojtxp          TYPE ojtxp,
     ovfls          TYPE ovfls,
     mngko          TYPE cs_e_mngko,
     meins          TYPE meins,
     postp          TYPE postp,
     ausnm          TYPE ausnm,
     WERKS          TYPE WERKS_D,
     MTART          TYPE MTART,
     VPRSV          TYPE VPRSV,
     STPRS          TYPE STPRS,
     SBDKZ          TYPE SBDKZ,
     DISMM          TYPE DISMM,
     SOBSL          TYPE SOBSL,
     SOBSK          TYPE CK_SOBSL,
     FBSKZ          TYPE FBSKZ,
     PRCTR          TYPE PRCTR,
     IDNRK          TYPE IDNRK,
     MENGE          TYPE CS_KMPMG,
     DATUV          TYPE DATUV,
     ANDAT          TYPE ANDAT,
     DATUB          TYPE DTBIS,
     STKKZ          TYPE STKKZ,
     BOMFL          TYPE CSBFL,
     sgt_rcat       TYPE sgt_rcat,
     sgt_scat       TYPE sgt_scat,
     verpr          TYPE char15,
     zztext_en      TYPE char250,
     zztext_sp      TYPE char250,
     MATNR TYPE MAPL-MATNR,
*     WERKS TYPE MAPL-WERKS,
     PLNTY TYPE MAPL-PLNTY,
     PLNNR TYPE MAPL-PLNNR,
     PLNAL TYPE MAPL-PLNAL,
     ZAEHL TYPE MAPL-ZAEHL,
     VERWE TYPE PLKO-VERWE,
     STATU TYPE PLKO-STATU,
     VORNR TYPE PLPO-VORNR,
     STEUS TYPE PLPO-STEUS,
     ARBID TYPE PLPO-ARBID,
     OBJTY TYPE PLPO-OBJTY,
     LTXA1 TYPE PLPO-LTXA1,
     LAR01 TYPE PLPO-LAR01,
     VGE01 TYPE PLPO-VGE01,
     VGW01 TYPE PLPO-VGW01,
     OBJID TYPE CRHD-OBJID,
     ARBPL TYPE CRHD-ARBPL,
     KOSTL TYPE CRCO-KOSTL,
     valid TYPE MAPL-DATUV,
*     VPRSV TYPE MBEW-VPRSV,
*     VERPR TYPE MBEW-VERPR,
*     STPRS TYPE MBEW-STPRS,
     BESKZ TYPE MARC-BESKZ,
     ACT_TYPE TYPE STRING, "COST-TKG001,
     ACT_COST TYPE STRING, "COST-TKG001,

    END OF final.
DATA: i_final TYPE TABLE OF final,
      w_final TYPE final.
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

TYPES : BEGIN OF ty_down_ftp,
        DGLVL     TYPE dglvl,
        POSNR     TYPE posnr,
        OBJIC     TYPE string,
        DOBJT     TYPE string,
        HEADER    TYPE string,
        OJTXP     TYPE char50,
        OVFLS     TYPE CHAR10,
        MNGKO     TYPE char15,
        MEINS     TYPE char15,
        POSTP     TYPE char10,
        AUSNM     TYPE char10,
        WERKS     TYPE char10,
        MTART     TYPE char10,
        VPRSV     TYPE char10,
        STPRS     TYPE char15,
        VERPR     TYPE char15,
        SBDKZ     TYPE char10,
        DISMM     TYPE char10,
        SOBSL     TYPE char10,
        SOBSK     TYPE char10,
        FBSKZ     TYPE char10,
        PRCTR     TYPE char15,
        IDNRK     TYPE char20,
        MENGE     TYPE char15,
        DATUV     TYPE char15,
        ANDAT     TYPE char15,
        DATUB     TYPE char15,
        BOMFL     TYPE char10,
        SGT_RCAT  TYPE char20,
        SGT_SCAT  TYPE char20,
        ZZTEXT_EN TYPE char255,
*        ZZTEXT_SP TYPE char255,
        MATNR     TYPE char20,
        PLNTY     TYPE char10,
        PLNNR     TYPE char10,
        PLNAL     TYPE char10,
        ZAEHL     TYPE char10,
        VERWE     TYPE char10,
        STATU     TYPE char10,
        VORNR     TYPE char10,
        STEUS     TYPE char10,
        OBJTY     TYPE char10,
        LTXA1     TYPE char50,
        LAR01     TYPE char10,
        VGE01     TYPE char10,
        VGW01     TYPE char10,
        OBJID     TYPE char10,
        ARBPL     TYPE char10,
        KOSTL     TYPE char10,
        VALID     TYPE char15,
        BESKZ     TYPE char10,
        REF       TYPE char15,
        ACT_TYPE      TYPE char15,
        ACT_COST      TYPE char15,
        END OF ty_down_ftp.

DATA : gt_down TYPE TABLE OF ty_down_ftp,
       gs_down TYPE ty_down_ftp.

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

TYPES: BEGIN OF TY_MAPL,
        MATNR TYPE MAPL-MATNR,
        WERKS TYPE MAPL-WERKS,
        PLNTY TYPE MAPL-PLNTY,
        PLNNR TYPE MAPL-PLNNR,
        PLNAL TYPE MAPL-PLNAL,
        ZAEHL TYPE MAPL-ZAEHL,
        ANDAT TYPE MAPL-ANDAT,
        DATUV TYPE MAPL-DATUV,
       END OF TY_MAPL.

TYPES: BEGIN OF TY_PLKO,
        PLNTY TYPE PLKO-PLNTY,
        PLNNR TYPE PLKO-PLNNR,
        PLNAL TYPE PLKO-PLNAL,
        ZAEHL TYPE PLKO-ZAEHL,
        VERWE TYPE PLKO-VERWE,
        WERKS TYPE PLKO-WERKS,
        STATU TYPE PLKO-STATU,
      END OF TY_PLKO.

TYPES: BEGIN OF TY_PLPO,
        PLNTY TYPE PLPO-PLNTY,
        PLNNR TYPE PLPO-PLNNR,
        ZAEHL TYPE PLPO-ZAEHL,
        VORNR TYPE PLPO-VORNR,
        STEUS TYPE PLPO-STEUS,
        ARBID TYPE PLPO-ARBID,
        OBJTY TYPE PLPO-OBJTY,
        WERKS TYPE PLPO-WERKS,
        LTXA1 TYPE PLPO-LTXA1,
        LAR01 TYPE PLPO-LAR01,
        VGE01 TYPE PLPO-VGE01,
        VGW01 TYPE PLPO-VGW01,
        "ARBTY TYPE PLPO-ARBTY,
        "NETID TYPE PLPO-NETID,
      END OF TY_PLPO.

TYPES: BEGIN OF TY_CRHD,
        OBJTY TYPE CRHD-OBJTY,
        OBJID TYPE CRHD-OBJID,
        ARBPL TYPE CRHD-ARBPL,
        WERKS TYPE CRHD-WERKS,
*        KOSTL TYPE CRHD-KOSTL,
      END OF TY_CRHD.
TYPES : BEGIN OF ty_crco,
        OBJID TYPE CRHD-OBJID,
        kostl TYPE crco-kostl,
        END OF ty_crco.

TYPES: BEGIN OF TY_FINAL,
        MATNR TYPE MAPL-MATNR,
        WERKS TYPE MAPL-WERKS,
        PLNTY TYPE MAPL-PLNTY,
        PLNNR TYPE MAPL-PLNNR,
        PLNAL TYPE MAPL-PLNAL,
        ZAEHL TYPE MAPL-ZAEHL,
        ANDAT TYPE MAPL-ANDAT,
        DATUV TYPE MAPL-DATUV,

        VERWE TYPE PLKO-VERWE,
        STATU TYPE PLKO-STATU,
        VORNR TYPE PLPO-VORNR,
        STEUS TYPE PLPO-STEUS,
        ARBID TYPE PLPO-ARBID,
        OBJTY TYPE PLPO-OBJTY,
        LTXA1 TYPE PLPO-LTXA1,
        LAR01 TYPE PLPO-LAR01,
        VGE01 TYPE PLPO-VGE01,
        VGW01 TYPE PLPO-VGW01,
        OBJID TYPE CRHD-OBJID,
        ARBPL TYPE CRHD-ARBPL,
        KOSTL TYPE CRCO-KOSTL,
        ACT_TYPE TYPE DMBTR,   "ADDED BY DHANASHREE
        ACT_COST TYPE DMBTR,   "ADDED BY DHANASHREE
       END OF TY_FINAL.

DATA: LT_MAPL TYPE TABLE OF TY_MAPL,
      LS_MAPL TYPE TY_MAPL.
DATA: LT_PLKO TYPE TABLE OF TY_PLKO,
      LS_PLKO TYPE TY_PLKO.
DATA: LT_CRHD TYPE TABLE OF TY_CRHD,
      LS_CRHD TYPE TY_CRHD.
DATA: LT_CRco TYPE TABLE OF TY_CRco,
      LS_CRco TYPE TY_CRco.
DATA: LT_PLPO TYPE TABLE OF TY_PLPO,
      LS_PLPO TYPE TY_PLPO.
DATA: WA_MBEW TYPE MBEW,
      WA_MARC TYPE MARC.

DATA : IT_COST TYPE TABLE OF COST,
       WA_COST TYPE COST,
       ACT_TYPE TYPE STRING.

DATA: LT_FINAL TYPE TABLE OF TY_FINAL,
      LS_FINAL TYPE TY_FINAL.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.


*&*--------------------------------------------------------------------*
*&* SELECTION SCREEN
*&*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001 .
SELECT-OPTIONS : s_matnr  FOR mara-matnr  NO INTERVALS.
PARAMETERS     : pm_werks LIKE marc-werks,
                 pm_datuv LIKE stko-datuv DEFAULT sy-datum,
                 pm_stlan LIKE stzu-stlan,
                 pm_stlal LIKE stko-stlal,
                 pm_capid LIKE tc04-capid,
************ added by dhanashree req by Atul Sir ************
                 S_GJAHR TYPE COST-GJAHR,
                 S_PERIOD TYPE ZPERIOD ,
********** ended ***************
                 ctu_mode LIKE ctu_params-dismode DEFAULT 'N' NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK b1.

**Added By Sarika Thange 06.03.2019
SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT   '/Delval/India'."India'."temp'."'E:/delval/temp_23'.       "'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK b5.

*&*--------------------------------------------------------------------*
*&* START OF SELECTION
*&*--------------------------------------------------------------------*
START-OF-SELECTION.
BREAK primus.
  PERFORM fetch_data.         "Fetch Data

  PERFORM routing.
  PERFORM sort.
  PERFORM data_retrieval.     "Color Rows in report
*    PERFORM stb_fields_tb_prep. "Field Catlog
    PERFORM get_fcat.
    PERFORM get_display.




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

SELECT matnr
       werks
       beskz
       sobsl
       sobsk FROM marc INTO TABLE lt_marc
       WHERE matnr IN s_matnr
       AND werks = pm_werks
       AND beskz = 'F'
      AND sobsl NE '20'.
"       AND sobsl EQ '30'.
"       OR sobsk EQ '20'.

  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  LOOP AT s_matnr.
*    cnt1 = sy-tabix.
    "Report:ZCS11
*################################################


  READ TABLE lt_marc INTO ls_marc WITH KEY matnr = s_matnr-low. "sobsk = 20 .

*IF ls_marc-sobsl is INITIAL.
*  "IF ls_marc-sobsk = 20 OR ls_marc-sobsk = ' ' .
*
*      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = s_matnr-low.
*      IF sy-subrc = 0.
*        alv_stb-ojtxp = ls_makt-maktx.
*      ENDIF.
*      "GET MATERIAL NUMBER
*      alv_stb-dobjt = s_matnr-low.
*      INSERT alv_stb INTO alv_stb[] INDEX 1. "
*      APPEND LINES OF alv_stb[] TO alv_stb1[] .
**  endif.
*
*   else
     if ls_marc-sobsl = '30' AND  ls_marc-BESKZ = 'F' AND ls_marc-sobsk NE '20'.

    PERFORM bdc.
    "Import From "Report-ZCS11"
    IMPORT alv_stb[] FROM MEMORY ID 'ALV_STB'.

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

   elseif ls_marc-sobsl NE '30' AND ls_marc-sobsk NE '20' and ls_marc-BESKZ = 'F'.

      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = s_matnr-low.
      IF sy-subrc = 0.
        alv_stb-ojtxp = ls_makt-maktx.
      ENDIF.
      "GET MATERIAL NUMBER
      alv_stb-dobjt = s_matnr-low.
      INSERT alv_stb INTO alv_stb[] INDEX 1. "
      APPEND LINES OF alv_stb[] TO alv_stb1[] .

     elseif ls_marc-sobsl = '30' AND  ls_marc-BESKZ = 'F' AND ls_marc-sobsk = '20'.

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

*##############################################



*  LOOP AT alv_stb1 INTO alv_stb1.
*    ls_mbew1-matnr = alv_stb1-dobjt.
*    ls_mbew1-werks = alv_stb1-werks.
*    APPEND ls_mbew1 TO lt_mbew1.
*    CLEAR : ls_mbew1 , alv_stb1.
*  ENDLOOP.
*
*  SELECT   matnr
*           bwkey
*           bwtar
*           vprsv
*           verpr
*           stprs
*    FROM mbew
*    INTO TABLE lt_mbew
*    FOR ALL ENTRIES IN lt_mbew1
*    WHERE matnr = lt_mbew1-matnr
*    AND   bwkey = lt_mbew1-werks.
*
*  LOOP AT alv_stb1 INTO alv_stb1.
*    cnt3 = sy-tabix.
*    READ TABLE lt_mbew1 INTO ls_mbew1 WITH KEY matnr = alv_stb1-dobjt werks = alv_stb1-werks.
*    IF sy-subrc = 0..
*      READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_mbew1-matnr bwkey = ls_mbew1-werks.
*      IF sy-subrc = 0.
*        alv_stb1-verpr = ls_mbew-verpr.
*        MODIFY alv_stb1 FROM alv_stb1 INDEX cnt3 TRANSPORTING verpr.
*      ENDIF.
*    ENDIF.
*
*    CLEAR : ls_mbew,alv_stb1,cnt3,ls_mbew.
*  ENDLOOP.


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
*&      Form  ROUTING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM routing .


  SELECT MATNR
         WERKS
         PLNTY
         PLNNR
         PLNAL
         ZAEHL
         ANDAT
         DATUV FROM MAPL
               INTO TABLE LT_MAPL
               FOR ALL ENTRIES IN alv_stb1
*               WHERE MATNR = alv_stb1-dobjt+0(18)"IN P_MATNR
               WHERE MATNR = alv_stb1-dobjt "IN P_MATNR  """""""""" added By NC
*                 AND ANDAT IN P_ANDAT
                 AND WERKS EQ 'PL01'
                 AND PLNTY = 'N'.

  SELECT PLNTY
         PLNNR
         PLNAL
         ZAEHL
         VERWE
         WERKS
         STATU FROM PLKO
               INTO TABLE LT_PLKO
               FOR ALL ENTRIES IN LT_MAPL
               WHERE PLNTY = LT_MAPL-PLNTY
                 AND PLNNR = LT_MAPL-PLNNR
                 AND WERKS = LT_MAPL-WERKS
                 and PLNAL = LT_MAPL-PLNAL
                 and ZAEHL = LT_MAPL-ZAEHL.
    .
IF LT_PLKO IS NOT INITIAL.

   SELECT PLNTY
          PLNNR
          ZAEHL
          VORNR
          STEUS
          ARBID
          OBJTY
          WERKS
          LTXA1
          LAR01
          VGE01
          VGW01 FROM PLPO
                INTO TABLE LT_PLPO
                FOR ALL ENTRIES IN LT_MAPL
                WHERE PLNTY = LT_MAPL-PLNTY
                  AND PLNNR = LT_MAPL-PLNNR
                  AND ZAEHL = LT_MAPL-ZAEHL.
ENDIF.
IF lt_plpo IS NOT INITIAL.
    SELECT OBJTY
           OBJID
           ARBPL
           WERKS

                 FROM CRHD INTO TABLE LT_CRHD
                 FOR ALL ENTRIES IN LT_PLPO
                 WHERE OBJID = LT_PLPO-ARBID.
                   "AND OBJID = LT_PLPO-NETID.

SELECT OBJID
       kostl FROM crco INTO TABLE lt_crco
       FOR ALL ENTRIES IN LT_PLPO
       WHERE OBJID = LT_PLPO-ARBID.
ENDIF.

****************** ADDED BY DHANASHREE REQ BY ATUL SIR***************
SELECT OBJNR
       GJAHR
       TKG001
       TKG002
       TKG003
       TKG004
       TKG005
       TKG006
       TKG007
       TKG008
       TKG009
       TKG010
       TKG011
       TKG012
       TKG013
       TKG014
       TKG015
       TKG016
   FROM COST
   INTO CORRESPONDING FIELDS OF TABLE IT_COST
   WHERE GJAHR = S_GJAHR.

******************** ENDED *******************

  LOOP AT LT_MAPL INTO LS_MAPL.
  LS_FINAL-MATNR = LS_MAPL-MATNR.
  LS_FINAL-WERKS = LS_MAPL-WERKS.
  LS_FINAL-PLNTY = LS_MAPL-PLNTY.
  LS_FINAL-PLNNR = LS_MAPL-PLNNR.
  LS_FINAL-PLNAL = LS_MAPL-PLNAL.
  LS_FINAL-ZAEHL = LS_MAPL-ZAEHL.
  LS_FINAL-ANDAT = LS_MAPL-ANDAT.
  LS_FINAL-DATUV = LS_MAPL-DATUV.


  READ TABLE LT_PLKO INTO LS_PLKO WITH KEY PLNTY = LS_MAPL-PLNTY PLNNR = LS_MAPL-PLNNR WERKS = LS_MAPL-WERKS ZAEHL = LS_MAPL-ZAEHL.
  IF SY-SUBRC = 0.
*  LS_FINAL-PLNTY = LS_PLKO-PLNTY.
*  LS_FINAL-PLNNR = LS_PLKO-PLNNR.
*  LS_FINAL-PLNAL = LS_PLKO-PLNAL.
*  LS_FINAL-ZAEHL = LS_PLKO-ZAEHL.
  LS_FINAL-VERWE = LS_PLKO-VERWE.
*  LS_FINAL-WERKS = LS_PLKO-WERKS.
  LS_FINAL-STATU = LS_PLKO-STATU.
  ENDIF.

  READ TABLE LT_PLPO INTO LS_PLPO WITH KEY PLNTY = LS_MAPL-PLNTY PLNNR = LS_MAPL-PLNNR ZAEHL = LS_MAPL-ZAEHL.
 IF SY-SUBRC = 0.
*  LS_FINAL-PLNTY = LS_PLPO-PLNTY.
*  LS_FINAL-PLNNR = LS_PLPO-PLNNR.
*  LS_FINAL-ZAEHL = LS_PLPO-ZAEHL.
  LS_FINAL-VORNR = LS_PLPO-VORNR.
  LS_FINAL-STEUS = LS_PLPO-STEUS.
*  LS_FINAL-ARBID = LS_PLPO-ARBID.
*  LS_FINAL-OBJTY = LS_PLPO-OBJTY.
*  LS_FINAL-WERKS = LS_PLPO-WERKS.
  LS_FINAL-LTXA1 = LS_PLPO-LTXA1.
  LS_FINAL-LAR01 = LS_PLPO-LAR01.
  LS_FINAL-VGE01 = LS_PLPO-VGE01.
  LS_FINAL-VGW01 = LS_PLPO-VGW01.
ENDIF.

READ TABLE LT_CRHD INTO LS_CRHD WITH KEY OBJID = LS_PLPO-ARBID.
 IF SY-SUBRC = 0.
  LS_FINAL-OBJID = LS_CRHD-OBJID.
  LS_FINAL-OBJTY = LS_CRHD-OBJTY.
  LS_FINAL-ARBPL = LS_CRHD-ARBPL.
*  LS_FINAL-KOSTL = LS_CRHD-KOSTL.
ENDIF.

READ TABLE LT_CRCO INTO LS_CRCO WITH KEY OBJID = LS_PLPO-ARBID.
IF SY-SUBRC = 0.
  LS_FINAL-KOSTL = LS_CRCO-KOSTL.
ENDIF.

*************** ADDED BY DHANASHREE REQ BY ATUL SIR **************
CONCATENATE 'KLDL00' LS_FINAL-KOSTL LS_FINAL-LAR01 INTO ACT_TYPE.
 DATA : PER TYPE CHAR2,
        TKG1 TYPE STRING.

READ TABLE IT_COST INTO WA_COST WITH KEY OBJNR = ACT_TYPE.
IF SY-SUBRC = 0.
CASE S_PERIOD.
WHEN '1'.
LS_FINAL-ACT_TYPE = WA_COST-TKG001.
WHEN '2'.
LS_FINAL-ACT_TYPE = WA_COST-TKG002.
WHEN '3'.
LS_FINAL-ACT_TYPE = WA_COST-TKG003.
WHEN '4'.
LS_FINAL-ACT_TYPE = WA_COST-TKG004.
WHEN '5'.
LS_FINAL-ACT_TYPE = WA_COST-TKG005.
WHEN '6'.
LS_FINAL-ACT_TYPE = WA_COST-TKG006.
WHEN '7'.
LS_FINAL-ACT_TYPE = WA_COST-TKG007.
WHEN '8'.
LS_FINAL-ACT_TYPE = WA_COST-TKG008.
WHEN '9'.
LS_FINAL-ACT_TYPE = WA_COST-TKG009.
WHEN '10'.
LS_FINAL-ACT_TYPE = WA_COST-TKG010.
WHEN '11'.
LS_FINAL-ACT_TYPE = WA_COST-TKG011.
WHEN '12'.
LS_FINAL-ACT_TYPE = WA_COST-TKG012.
WHEN '13'.
LS_FINAL-ACT_TYPE = WA_COST-TKG013.
WHEN '14'.
LS_FINAL-ACT_TYPE = WA_COST-TKG014.
WHEN '15'.
LS_FINAL-ACT_TYPE = WA_COST-TKG015.
WHEN '16'.
LS_FINAL-ACT_TYPE = WA_COST-TKG016.
ENDCASE.
ENDIF.

LS_FINAL-ACT_COST = LS_FINAL-VGW01 * LS_FINAL-ACT_TYPE.

************ ENDED **************************

APPEND LS_FINAL TO LT_FINAL.
CLEAR LS_FINAL.

ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort .
DATA:index TYPE sy-index.
DATA:header TYPE mara-matnr.
*SORT alv_stb1 by dobjt.
SORT lt_final by matnr.
*BREAK primus.
LOOP AT alv_stb1.
w_final-dglvl     = alv_stb1-dglvl    .
w_final-posnr     = alv_stb1-posnr    .
IF w_final-posnr IS INITIAL.
header  = alv_stb1-dobjt.
ENDIF.
w_final-header    = header.
w_final-objic     = alv_stb1-objic    .
w_final-dobjt     = alv_stb1-dobjt    .
w_final-ojtxp     = alv_stb1-ojtxp    .
w_final-ovfls     = alv_stb1-ovfls    .
w_final-mngko     = alv_stb1-mngko    .
w_final-meins     = alv_stb1-meins    .
w_final-postp     = alv_stb1-postp    .
w_final-ausnm     = alv_stb1-ausnm    .
w_final-sgt_rcat  = alv_stb1-sgt_rcat .
w_final-sgt_scat  = alv_stb1-sgt_scat .
*w_final-verpr     = alv_stb1-verpr    .
w_final-zztext_en = alv_stb1-zztext_en.
w_final-zztext_sp = alv_stb1-zztext_sp.

w_final-WERKS = alv_stb1-WERKS.
w_final-MTART = alv_stb1-MTART.
*w_final-VPRSV = alv_stb1-VPRSV.
*w_final-STPRS = alv_stb1-STPRS.
w_final-SBDKZ = alv_stb1-SBDKZ.
w_final-DISMM = alv_stb1-DISMM.
w_final-SOBSL = alv_stb1-SOBSL.
w_final-SOBSK = alv_stb1-SOBSK.
w_final-FBSKZ = alv_stb1-FBSKZ.
w_final-PRCTR = alv_stb1-PRCTR.
w_final-IDNRK = alv_stb1-IDNRK.
w_final-MENGE = alv_stb1-MENGE.
w_final-DATUV = alv_stb1-DATUV.
w_final-ANDAT = alv_stb1-ANDAT.
w_final-DATUB = alv_stb1-DATUB.
w_final-STKKZ = alv_stb1-STKKZ.
w_final-BOMFL = alv_stb1-BOMFL.

SELECT SINGLE * FROM MBEW INTO WA_MBEW WHERE MATNR = w_final-dobjt AND BWKEY = w_final-WERKS.

SELECT SINGLE * FROM MARC INTO WA_MARC WHERE MATNR = w_final-dobjt AND WERKS = w_final-WERKS.

W_FINAL-VPRSV = WA_MBEW-VPRSV.
W_FINAL-VERPR = WA_MBEW-VERPR.
W_FINAL-STPRS = WA_MBEW-STPRS.
W_FINAL-BESKZ = WA_MARC-BESKZ.

LOOP AT lt_final INTO ls_final WHERE MATNR = alv_stb1-dobjt+0(18).

w_final-MATNR   = ls_final-MATNR.
*w_final-WERKS   = ls_final-WERKS.
w_final-PLNTY   = ls_final-PLNTY.
w_final-PLNNR   = ls_final-PLNNR.
w_final-PLNAL   = ls_final-PLNAL.
w_final-ZAEHL   = ls_final-ZAEHL.
w_final-VERWE   = ls_final-VERWE.
w_final-STATU   = ls_final-STATU.
w_final-VORNR   = ls_final-VORNR.
w_final-STEUS   = ls_final-STEUS.
w_final-ARBID   = ls_final-ARBID.
w_final-OBJTY   = ls_final-OBJTY.
w_final-LTXA1   = ls_final-LTXA1.
w_final-LAR01   = ls_final-LAR01.
w_final-VGE01   = ls_final-VGE01.
w_final-VGW01   = ls_final-VGW01.
w_final-OBJID   = ls_final-OBJID.
w_final-ARBPL   = ls_final-ARBPL.
w_final-KOSTL   = ls_final-KOSTL.
w_final-valid   = ls_final-DATUV.
w_final-ACT_TYPE   = ls_final-ACT_TYPE.
w_final-ACT_COST   = ls_final-ACT_COST.

APPEND w_final TO i_final.

ENDLOOP.
IF w_final-matnr IS INITIAL.
APPEND w_final TO i_final.
ENDIF.

CLEAR: w_final,wa_mbew,wa_marc.
ENDLOOP.
*BREAK primus.
IF p_down = 'X'.
 LOOP AT i_final INTO w_final.
   gs_down-DGLVL  = w_final-DGLVL .
   gs_down-POSNR  = w_final-POSNR .
   gs_down-OBJIC  = w_final-OBJIC .
   gs_down-DOBJT  = w_final-DOBJT .
   gs_down-HEADER = w_final-HEADER.
   gs_down-OJTXP  = w_final-OJTXP .
   gs_down-OVFLS  = w_final-OVFLS .
   gs_down-MNGKO  = w_final-MNGKO .
   gs_down-MEINS  = w_final-MEINS .
   gs_down-POSTP  = w_final-POSTP .
   gs_down-AUSNM  = w_final-AUSNM .
   gs_down-WERKS  = w_final-WERKS .
   gs_down-MTART  = w_final-MTART .
   gs_down-VPRSV  = w_final-VPRSV .
   gs_down-STPRS  = w_final-STPRS .
   gs_down-VERPR  = w_final-VERPR .
   gs_down-SBDKZ  = w_final-SBDKZ .
   gs_down-DISMM  = w_final-DISMM .
   gs_down-SOBSL  = w_final-SOBSL .
   gs_down-SOBSK  = w_final-SOBSK .
   gs_down-FBSKZ  = w_final-FBSKZ .
   gs_down-PRCTR  = w_final-PRCTR .

   gs_down-IDNRK      = w_final-IDNRK     .
   gs_down-MENGE      = w_final-MENGE     .
*   gs_down-DATUV      = w_final-DATUV     .

IF w_final-DATUV IS NOT INITIAL.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = w_final-DATUV
        IMPORTING
          output = gs_down-DATUV.

      CONCATENATE gs_down-DATUV+0(2) gs_down-DATUV+2(3) gs_down-DATUV+5(4)
                      INTO gs_down-DATUV SEPARATED BY '-'.
ENDIF.


*   gs_down-ANDAT      = w_final-ANDAT     .
IF w_final-ANDAT IS NOT INITIAL.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = w_final-ANDAT
        IMPORTING
          output = gs_down-ANDAT.

      CONCATENATE gs_down-ANDAT+0(2) gs_down-ANDAT+2(3) gs_down-ANDAT+5(4)
                      INTO gs_down-ANDAT SEPARATED BY '-'.
ENDIF.

*   gs_down-DATUB      = w_final-DATUB     .
IF w_final-DATUB IS NOT INITIAL.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = w_final-DATUB
        IMPORTING
          output = gs_down-DATUB.

      CONCATENATE gs_down-DATUB+0(2) gs_down-DATUB+2(3) gs_down-DATUB+5(4)
                      INTO gs_down-DATUB SEPARATED BY '-'.
ENDIF.

   gs_down-BOMFL      = w_final-BOMFL     .
   gs_down-SGT_RCAT   = w_final-SGT_RCAT  .
   gs_down-SGT_SCAT   = w_final-SGT_SCAT  .
   gs_down-ZZTEXT_EN  = w_final-ZZTEXT_EN .
*   gs_down-ZZTEXT_SP  = w_final-ZZTEXT_SP .
   gs_down-MATNR      = w_final-MATNR     .
   gs_down-PLNTY      = w_final-PLNTY     .
   gs_down-PLNNR      = w_final-PLNNR     .
   gs_down-PLNAL      = w_final-PLNAL     .
   gs_down-ZAEHL      = w_final-ZAEHL     .
   gs_down-VERWE      = w_final-VERWE     .
   gs_down-STATU      = w_final-STATU     .
   gs_down-VORNR      = w_final-VORNR     .
   gs_down-STEUS      = w_final-STEUS     .
   gs_down-OBJTY      = w_final-OBJTY     .
   gs_down-LTXA1      = w_final-LTXA1     .
   gs_down-LAR01      = w_final-LAR01     .
   gs_down-VGE01      = w_final-VGE01     .

   gs_down-VGW01      = w_final-VGW01     .
   gs_down-OBJID      = w_final-OBJID     .
   gs_down-ARBPL      = w_final-ARBPL     .
   gs_down-KOSTL      = w_final-KOSTL     .
*   gs_down-VALID      = w_final-VALID     .
   gs_down-BESKZ      = w_final-BESKZ     .
   gs_down-ACT_TYPE      = w_final-ACT_TYPE     .
   gs_down-ACT_COST      = w_final-ACT_COST     .

IF w_final-VALID IS NOT INITIAL.
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = w_final-VALID
        IMPORTING
          output = gs_down-VALID.

      CONCATENATE gs_down-VALID+0(2) gs_down-VALID+2(3) gs_down-VALID+5(4)
                      INTO gs_down-VALID SEPARATED BY '-'.
ENDIF.

   CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = gs_down-ref.

      CONCATENATE gs_down-ref+0(2) gs_down-ref+2(3) gs_down-ref+5(4)
                      INTO gs_down-ref SEPARATED BY '-'.
 APPEND gs_down TO gt_down.
 CLEAR gs_down.
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
FORM get_fcat .
PERFORM fcat USING :     '1'   'DGLVL'           'IT_FINAL'      'Explosion level '                            '10' ,
                         '2'   'POSNR'           'IT_FINAL'      'BOM Item Number'                             '10' ,
                         '3'   'OBJIC'           'IT_FINAL'      'Object Type'                                 '10',
                         '4'   'DOBJT'           'IT_FINAL'      'Object ID'                                   '20',
                         '5'   'HEADER'          'IT_FINAL'      'Header Material'                             '20',
                         '6'   'OJTXP'           'IT_FINAL'      'Object description '                         '20',
                         '7'   'OVFLS'           'IT_FINAL'      'Indicator: value exceeds maximum length'     '20',
                         '8'   'MNGKO'           'IT_FINAL'      'Comp.Qty(CUn)'                               '20',
                         '9'   'MEINS'           'IT_FINAL'      'Base Unit of Measure'                        '20',
                        '10'   'POSTP'           'IT_FINAL'      'Item category'                               '10',
                        '11'   'AUSNM'           'IT_FINAL'      'Exception'                                   '20',

                        '12'   'WERKS'           'IT_FINAL'      'Plant'                                       '10',
                        '13'   'MTART'           'IT_FINAL'      'Material Type'                               '10',
                        '14'   'VPRSV'           'IT_FINAL'      'Price control indicator'                     '10',
                        '15'   'STPRS'           'IT_FINAL'      'Standard price'                              '10',
                        '16'   'VERPR'           'IT_FINAL'      'Moving Price'                                '10',
                        '17'   'SBDKZ'           'IT_FINAL'      'Individual /Collective Indicator'            '10',
                        '18'   'DISMM'           'IT_FINAL'      'MRP Type'                                    '10',
                        '19'   'SOBSL'           'IT_FINAL'      'Special procurement type'                    '10',
                        '20'   'SOBSK'           'IT_FINAL'      'Special Procurement Type for Costing'        '10',
                        '21'   'FBSKZ'           'IT_FINAL'      'Indicator: procured externally'              '10',
                        '22'   'PRCTR'           'IT_FINAL'      'Profit Center'                               '10',
                        '23'   'IDNRK'           'IT_FINAL'      'Component'                                   '20',
                        '24'   'MENGE'           'IT_FINAL'      'Component quantity'                          '10',
                        '25'   'DATUV'           'IT_FINAL'      'Valid-from'                                  '10',
                        '26'   'ANDAT'           'IT_FINAL'      'Created on'                                  '10',
                        '27'   'DATUB'           'IT_FINAL'      'Valid-to date'                               '10',
                        '28'   'BOMFL'           'IT_FINAL'      'Assembly indicator'                          '10',

                        '29'   'SGT_RCAT'        'IT_FINAL'      'Requirement Segment'                         '10',
                        '30'   'SGT_SCAT'        'IT_FINAL'      'Stock Segment'                               '10',
                        '31'   'ZZTEXT_EN'       'IT_FINAL'      'Material Long Text EN'                       '20',
                        '32'   'ZZTEXT_SP'       'IT_FINAL'      'Material Long Text SP'                       '20',
                        '33'   'MATNR'           'IT_FINAL'      'Material Number'                             '20',

                        '34'   'PLNTY'           'IT_FINAL'      'Task List Type'                              '10',
                        '35'   'PLNNR'           'IT_FINAL'      'Group'                                       '10',
                        '36'   'PLNAL'           'IT_FINAL'      'Group Counter'                               '10',
                        '37'   'ZAEHL'           'IT_FINAL'      'Counter'                                     '10',
                        '38'   'VERWE'           'IT_FINAL'      'Task list usage'                             '10',
                        '39'   'STATU'           'IT_FINAL'      'Status'                                      '10',
                        '40'   'VORNR'           'IT_FINAL'      'Activity Number'                             '10',
                        '41'   'STEUS'           'IT_FINAL'      'Control key'                                 '10',
                        '42'   'OBJTY'           'IT_FINAL'      'Object Type'                                 '10',
                        '43'   'LTXA1'           'IT_FINAL'      'Operation short text'                        '20',
                        '44'   'LAR01'           'IT_FINAL'      'Description of standard value 1'             '20',
                        '45'   'VGE01'           'IT_FINAL'      'Unit of Measurement of Standard Value'       '10',
                        '46'   'VGW01'           'IT_FINAL'      'Std.Value'                                   '10',
                        '47'   'OBJID'           'IT_FINAL'      'Object ID'                                   '10',
                        '48'   'ARBPL'           'IT_FINAL'      'Work center'                                 '10',
                        '49'   'KOSTL'           'IT_FINAL'      'Cost center'                                 '10',
                        '50'   'VALID'           'IT_FINAL'      'Valid From'                                  '10',
                        '51'   'BESKZ'           'IT_FINAL'      'Procurement Type'                            '10',
                        '52'   'ACT_TYPE'           'IT_FINAL'      'Activity Rate'                          '10' , " added by Dhanashree
                        '53'   'ACT_COST'           'IT_FINAL'      'Activity Cost'                          '10'.  " added by Dhanashree
*                        '50'   'VPRSV'           'IT_FINAL'      'Price indicator'                  '10',
*
*                        '52'   'STPRS'           'IT_FINAL'      'Standard price'                   '10',


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display .
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
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
      it_fieldcat        = it_fcat
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
      t_outtab           = i_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

IF p_down = 'X'.

    PERFORM down.

ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_2194   text
*      -->P_2195   text
*      -->P_2196   text
*      -->P_2197   text
*      -->P_2198   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM down .
TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  lv_file = 'ZBOM_ROUTING.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZBOM_ROUTING REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1357 TYPE string.
DATA lv_crlf_1357 TYPE string.
lv_crlf_1357 = cl_abap_char_utilities=>cr_lf.
lv_string_1357 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1357 lv_crlf_1357 wa_csv INTO lv_string_1357.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1357 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

********************************Second File**********************************
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  lv_file = 'ZBOM_ROUTING.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZBOM_ROUTING REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1395 TYPE string.
DATA lv_crlf_1395 TYPE string.
lv_crlf_1395 = cl_abap_char_utilities=>cr_lf.
lv_string_1395 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1395 lv_crlf_1395 wa_csv INTO lv_string_1395.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1395 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

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
  CONCATENATE 'Explosion level '
              'BOM Item Number'
              'Object Type'
              'Object ID'
              'Header Material'
              'Object description '
              'Indicator: value exceeds maximum length'
              'Comp.Qty(CUn)'
              'Base Unit of Measure'
              'Item category'
              'Exception'
              'Plant'
              'Material Type'
              'Price control indicator'
              'Standard price'
              'Moving Price'
              'Individual /Collective Indicator'
              'MRP Type'
              'Special procurement type'
              'Special Procurement Type for Costing'
              'Indicator: procured externally'
              'Profit Center'
              'Component'
              'Component quantity'
              'Valid-from'
              'Created on'
              'Valid-to date'
              'Assembly indicator'
              'Requirement Segment'
              'Stock Segment'
              'Material Long Text EN'
*              'Material Long Text SP'
              'Material Number'
              'Task List Type'
              'Group'
              'Group Counter'
              'Counter'
              'Task list usage'
              'Status'
              'Activity Number'
              'Control key'
              'Object Type'
              'Operation short text'
              'Description of standard value 1'
              'Unit of Measurement of Standard Value'
              'Std.Value'
              'Object ID'
              'Work center'
              'Cost center'
              'Valid From'
              'Procurement Type'
              'Refresh Date'
              'Activity Rate'
              'Activity Cost'
               INTO pd_csv
               SEPARATED BY l_field_seperator.

ENDFORM.
