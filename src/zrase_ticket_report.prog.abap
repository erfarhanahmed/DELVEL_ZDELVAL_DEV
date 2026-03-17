*&---------------------------------------------------------------------*
*& Report ZRASE_TICKET_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRASE_TICKET_REPORT.
************************************************************************
* Developed by          : Primus Techsoftsoln
* PROGRAM TYPE          : Report
* PACKAGE               : ZPRIMUS
* PROGRAM TITLE         : Standard Costing Report
* PROGRAM NAME          : ZRASE_TICKET_REPORT
* Technical Consultant  : Sarika Thange
* Transaction Code      : ZSCR
* Transport Request     : DEVK904264
*----------------------------------------------------------------------*
******************************************************************************

TYPE-POOLS : SLIS.
TABLES : KEKO,KEPH.

TYPES : BEGIN OF TY_KEKO,
        KALNR TYPE KEKO-KALNR,
        KALKA TYPE KEKO-KALKA,
        KADKY TYPE KEKO-KADKY,
        TVERS TYPE KEKO-TVERS,
        BWVAR TYPE KEKO-BWVAR,
        MATNR TYPE KEKO-MATNR,
        WERKS TYPE KEKO-WERKS,
        BDATJ TYPE KEKO-BDATJ,
        POPER TYPE KEKO-POPER,
        BWKEY TYPE KEKO-BWKEY,
        KOKRS TYPE KEKO-KOKRS,
        KADAT TYPE KEKO-KADAT,
        BIDAT TYPE KEKO-BIDAT,
        BWDAT TYPE KEKO-BWDAT,
        ALDAT TYPE KEKO-ALDAT,
        STNUM TYPE KEKO-STNUM,
        PLNNR TYPE KEKO-PLNNR,
        LOEKZ TYPE KEKO-LOEKZ,
        LOSGR TYPE KEKO-LOSGR,
        ERFNM TYPE KEKO-ERFNM,
        CPUDT TYPE KEKO-CPUDT,
        FEH_STA TYPE KEKO-FEH_STA,
        FREIG TYPE KEKO-FREIG,
        SOBES TYPE KEKO-SOBES,
        KALSM TYPE KEKO-KALSM,
        KLVAR TYPE KEKO-KLVAR,
        BESKZ TYPE KEKO-BESKZ,
        END OF TY_KEKO.


TYPES : BEGIN OF TY_KEPH,
        KALNR TYPE  KEPH-KALNR,
        KALKA TYPE  KEPH-KALKA,
        KADKY TYPE  KEPH-KADKY,
        TVERS TYPE  KEPH-TVERS,
        BWVAR TYPE  KEPH-BWVAR,
        KKZST TYPE  KEPH-KKZST,
        KST001 TYPE KEPH-KST001,
        KST003 TYPE KEPH-KST003,
        KST005 TYPE KEPH-KST005,
        KST007 TYPE KEPH-KST007,
        KST009 TYPE KEPH-KST009,
        KST011 TYPE KEPH-KST011,
        KST013 TYPE KEPH-KST013,
        KST015 TYPE KEPH-KST015,
        KST017 TYPE KEPH-KST017,
        END OF TY_KEPH.

TYPES : BEGIN OF TY_MBEW,
         MATNR TYPE MBEW-MATNR,
         BWKEY TYPE MBEW-BWKEY,
         VPRSV TYPE MBEW-VPRSV,
         VERPR TYPE MBEW-VERPR,
         STPRS TYPE MBEW-STPRS,
        END OF   TY_MBEW.

TYPES : BEGIN OF TY_MARA,
        MATNR TYPE MARA-matnr,
        MTART TYPE MARA-MTART,
        END OF   TY_MARA.

TYPES : BEGIN OF TY_FINAL,
        KALNR TYPE KEKO-KALNR,
        KALKA TYPE KEKO-KALKA,
        KADKY TYPE KEKO-KADKY,
        TVERS TYPE KEKO-TVERS,
        BWVAR TYPE KEKO-BWVAR,
        MATNR TYPE KEKO-MATNR,
        WERKS TYPE KEKO-WERKS,
        BWKEY TYPE KEKO-BWKEY,
        KOKRS TYPE KEKO-KOKRS,
        KADAT TYPE KEKO-KADAT,
        BIDAT TYPE KEKO-BIDAT,
        BWDAT TYPE KEKO-BWDAT,
        ALDAT TYPE KEKO-ALDAT,
        STNUM TYPE KEKO-STNUM,
        PLNNR TYPE KEKO-PLNNR,
        LOEKZ TYPE KEKO-LOEKZ,
        LOSGR TYPE KEKO-LOSGR,
        ERFNM TYPE KEKO-ERFNM,
        CPUDT TYPE KEKO-CPUDT,
        FEH_STA TYPE KEKO-FEH_STA,
        FREIG TYPE KEKO-FREIG,
        SOBES TYPE KEKO-SOBES,
        KALSM TYPE KEKO-KALSM,
        KLVAR TYPE KEKO-KLVAR,
        POPER TYPE KEKO-POPER,
        BDATJ TYPE KEKO-BDATJ,
        BESKZ TYPE KEKO-BESKZ,
        KKZST TYPE KEPH-KKZST,
        KST001 TYPE KEPH-KST001,
        KST003 TYPE KEPH-KST003,
        KST005 TYPE KEPH-KST005,
        KST007 TYPE KEPH-KST007,
        KST009 TYPE KEPH-KST009,
        KST011 TYPE KEPH-KST011,
        KST013 TYPE KEPH-KST013,
        KST015 TYPE KEPH-KST015,
        KST017 TYPE KEPH-KST017,
        VPRSV TYPE MBEW-VPRSV,
        VERPR TYPE MBEW-VERPR,
        STPRS type MBEW-STPRS,
        MTART TYPE MARA-mtart,
        TOT_COST TYPE KBETR,
        END OF TY_FINAL.

DATA : LT_KEKO TYPE TABLE OF TY_KEKO,
       LS_KEKO TYPE          TY_KEKO,
       LT_KEPH TYPE TABLE OF TY_KEPH,
       LS_KEPH TYPE          TY_KEPH,
       LT_MBEW TYPE TABLE OF TY_MBEW,
       Ls_MBEW TYPE          TY_MBEW,
       LT_MARA TYPE TABLE OF TY_MARA,
       LS_MARA TYPE          TY_MARA,
       LT_FINAL TYPE TABLE OF TY_FINAL,
       LS_FINAL TYPE          TY_FINAL.


"data declaration

*INTERNAL TABLE FOR FIELC CATALOG
DATA : T_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE.
*INTERNAL TABLE FOR SORTING
DATA : T_SORT TYPE SLIS_T_SORTINFO_ALV WITH HEADER LINE.
DATA : W_TABNAME TYPE SLIS_TABNAME,
       ICX TYPE SYTABIX.
DATA : FS_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA : IT_HEADER TYPE SLIS_T_LISTHEADER,
       WA_HEADER LIKE LINE OF IT_HEADER.

DATA : IT_EVENT TYPE SLIS_T_EVENT,
       WA_EVENT LIKE LINE OF IT_EVENT.
""""""""""""""""""""SELECTION SCREEN"""""""""""""""""""""
SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : S_MATNR FOR KEKO-MATNR,
                   S_WERKS FOR KEKO-WERKS,
                   S_POPER FOR KEKO-POPER,
                   S_BDATJ FOR KEKO-BDATJ,
                   S_FEH   FOR KEKO-FEH_STA,
                   S_FREIG FOR KEKO-FREIG.
SELECTION-SCREEN : END OF BLOCK B1.

"""""""""""""""""end of selection screen""""""""""""""""""""""""

PERFORM FETCH_DATA.
PERFORM fieldcatlog.
PERFORM display.
PERFORM GET_EVENT.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .
SELECT  KALNR
        KALKA
        KADKY
        TVERS
        BWVAR
        MATNR
        WERKS
        BDATJ
        POPER
        BWKEY
        KOKRS
        KADAT
        BIDAT
        BWDAT
        ALDAT
        STNUM
        PLNNR
        LOEKZ
        LOSGR
        ERFNM
        CPUDT
        FEH_STA
        FREIG
        SOBES
        KALSM
        KLVAR
        BESKZ
        FROM KEKO
        INTO TABLE LT_KEKO
        WHERE MATNR IN S_MATNR
        AND WERKS IN S_WERKS
        AND POPER IN S_POPER
        AND BDATJ IN S_BDATJ
        AND FEH_STA IN S_FEH
        AND FREIG IN S_FREIG.

IF LT_KEKO IS NOT INITIAL.
  SELECT KALNR
         KALKA
         KADKY
         TVERS
         BWVAR
         KKZST
         KST001
         KST003
         KST005
         KST007
         KST009
         KST011
         KST013
         KST015
         KST017
         FROM KEPH
         INTO TABLE LT_KEPH
         FOR ALL ENTRIES IN LT_KEKO
         WHERE KALNR = LT_KEKO-KALNR
         AND KALKA = LT_KEKO-KALKA
         AND KADKY = LT_KEKO-KADKY
         AND TVERS = LT_KEKO-TVERS
         AND BWVAR = LT_KEKO-BWVAR
         AND KKZST = ''.

SELECT MATNR
       BWKEY
       VPRSV
       VERPR
       STPRS
       FROM MBEW
       INTO TABLE LT_MBEW
       FOR ALL ENTRIES IN LT_KEKO
       WHERE MATNR = LT_KEKO-MATNR
       AND BWKEY = LT_KEKO-BWKEY.

SELECT MATNR
       MTART
       FROM MARA
       INTO TABLE LT_MARA
       FOR ALL ENTRIES IN LT_KEKO
       WHERE MATNR = LT_KEKO-MATNR.
ENDIF.

LOOP AT LT_KEPH INTO LS_KEPH.

LS_FINAL-KALNR  = LS_KEPH-KALNR .
LS_FINAL-KALKA  = LS_KEPH-KALKA.
LS_FINAL-KADKY  = LS_KEPH-KADKY .
LS_FINAL-TVERS  = LS_KEPH-TVERS.
LS_FINAL-BWVAR  = LS_KEPH-BWVAR.
LS_FINAL-KKZST  = LS_KEPH-KKZST.
LS_FINAL-KST001 = LS_KEPH-KST001 .
LS_FINAL-KST003 = LS_KEPH-KST003 .
LS_FINAL-KST005 = LS_KEPH-KST005 .
LS_FINAL-KST007 = LS_KEPH-KST007 .
LS_FINAL-KST009 = LS_KEPH-KST009 .
LS_FINAL-KST011 = LS_KEPH-KST011 .
LS_FINAL-KST013 = LS_KEPH-KST013 .
LS_FINAL-KST015 = LS_KEPH-KST015.
LS_FINAL-KST017 = LS_KEPH-KST017.

READ TABLE LT_KEKO INTO LS_KEKO WITH  KEY  KALNR = LS_FINAL-KALNR KALKA = LS_FINAL-KALKA KADKY = LS_FINAL-KADKY.
LS_FINAL-MATNR  = LS_KEKO-MATNR.
LS_FINAL-WERKS  = LS_KEKO-WERKS .
LS_FINAL-BWKEY  = LS_KEKO-BWKEY  .
LS_FINAL-KOKRS  = LS_KEKO-KOKRS  .
LS_FINAL-KADAT  = LS_KEKO-KADAT  .
LS_FINAL-BIDAT  = LS_KEKO-BIDAT  .
LS_FINAL-BWDAT  = LS_KEKO-BWDAT  .
LS_FINAL-ALDAT  = LS_KEKO-ALDAT  .
LS_FINAL-STNUM  = LS_KEKO-STNUM  .
LS_FINAL-PLNNR  = LS_KEKO-PLNNR  .
LS_FINAL-LOEKZ  = LS_KEKO-LOEKZ  .
LS_FINAL-LOSGR  = LS_KEKO-LOSGR  .
LS_FINAL-ERFNM  = LS_KEKO-ERFNM  .
LS_FINAL-CPUDT  = LS_KEKO-CPUDT  .
LS_FINAL-FEH_STA = LS_KEKO-FEH_STA.
LS_FINAL-FREIG  = LS_KEKO-FREIG  .
LS_FINAL-SOBES  = LS_KEKO-SOBES  .
LS_FINAL-KALSM  = LS_KEKO-KALSM  .
LS_FINAL-KLVAR  = LS_KEKO-KLVAR  .
LS_FINAL-POPER  = LS_KEKO-POPER  .
LS_FINAL-BDATJ  = LS_KEKO-BDATJ  ..
LS_FINAL-BESKZ  = LS_KEKO-BESKZ  .

READ TABLE LT_MBEW INTO LS_MBEW WITH KEY MATNR = LS_FINAL-MATNR BWKEY = LS_FINAL-BWKEY.
LS_FINAL-vprsv = LS_MBEW-vprsv.
LS_FINAL-VERPR = LS_MBEW-VERPR.
LS_FINAL-STPRS = LS_MBEW-STPRS.

READ TABLE LT_MARA INTO LS_MARA WITH KEY MATNR = LS_FINAL-MATNR.
LS_FINAL-MTART = LS_MARA-MTART.

LS_FINAL-tot_cost = LS_FINAL-KST001 + LS_FINAL-KST003 + LS_FINAL-KST005 + LS_FINAL-KST007 +
                    LS_FINAL-KST009 + LS_FINAL-KST011 + LS_FINAL-KST013 + LS_FINAL-KST015 + LS_FINAL-KST017.
APPEND LS_FINAL TO LT_FINAL.
CLEAR: LS_FINAL,LS_MBEW,LS_MARA,LS_KEKO,LS_KEPH.
ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcatlog .
REFRESH T_FIELDCAT.
DATA(cnt) = 0.
cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KALNR'       'Cost Estimate Number'. cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KALKA'       'Costing Type'.         cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KADKY'       'Costing Date'.         cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'TVERS'       'Costing Version'.      cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'BWVAR'       'Valuation Variant in Costing'.  cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'MATNR'       'Material Number'.               cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'WERKS'       'Plant'.                         cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'BWKEY'       'Valuation Area'.                cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KOKRS'       'Controlling Area'.              cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KADAT'       'Costing Date From'.             cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'BIDAT'       'Costing Date'.               cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'BWDAT'       'PValuation Date of a Cost Estimate'.  cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'ALDAT'       'Quantity Structure Date for Costing'.  cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'STNUM'       'Bill of material'.                     cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'PLNNR'       'Key for Task List Group'.              cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'LOEKZ'       'Deletion Indicator '.                  cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'LOSGR'       'Lot Size'.                             cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'ERFNM'       'Costed by User'.                       cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'CPUDT'       'Date on Which Cost Estimate Was Created'. cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'FEH_STA'     'Costing Status'.                         cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'FREIG'       'Release of Standard Cost Estimate'.      cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'SOBES'       'Special procurement type'.               cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KALSM'       'Costing Sheet for Calculating Overhead'. cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KLVAR'       'Costing Variant'.           cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'POPER'       'Posting Period'.            cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'BDATJ'       'Posting Date'.              cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'BESKZ'       'Procurement Type'.          cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KKZST'       'Indicator Lower Level'.     cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KST001'      'Material Cost'.               cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KST003'      'Machine Hours '.               cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KST005'      'Labour Hours'.               cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KST007'      'Power Consumption '.               cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KST009'      'Process Cost'.               cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KST011'      'Dressing '.              cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KST013'      'Fuel Cost'.              cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'KST015'      'PRODUCTION OH'.              cnt = cnt + 1.
PERFORM t_fieldcatlog USING  cnt   'KST017'      'Subcontracting Cost'.              cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'VPRSV'       'Price Control'.              cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'VERPR'       'Present  Moving Average Price'.              cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'STPRS'       'Standard Price'.              cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'MTART'       'Material Type'.              cnt = cnt + 1.
PERFORM T_FIELDCATLOG USING  cnt   'TOT_COST'    ' Total Cost'.              cnt = cnt + 1.



  FS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  FS_LAYOUT-ZEBRA = 'X'.
*  FS_LAYOUT-DETAIL_POPUP = 'X'.
*  FS_LAYOUT-SUBTOTALS_TEXT = 'TOTAL'.
ENDFORM.                    " FILL_LAYOUT

*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        I_CALLBACK_PROGRAM       = SY-REPID
        IS_LAYOUT                = FS_LAYOUT
        I_CALLBACK_TOP_OF_PAGE   = 'TOP_OF_PAGE'
        IT_FIELDCAT              = T_FIELDCAT[]
*        IT_SORT                  = T_SORT[]
        I_SAVE                   = 'X'
         IT_EVENTS                         = IT_EVENT

      TABLES
        T_OUTTAB                 = lt_final
      EXCEPTIONS
        PROGRAM_ERROR      = 1
        OTHERS             = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  T_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CNT  text
*      -->P_0438   text
*      -->P_0439   text
*----------------------------------------------------------------------*
FORM t_fieldcatlog  USING    p_cnt
                             VALUE(p_0438)
                             VALUE(p_0439).

    T_FIELDCAT-col_pos = p_cnt.
    T_FIELDCAT-fieldname = p_0438.
    T_FIELDCAT-seltext_l = p_0439.
     APPEND T_FIELDCAT.
     CLEAR T_FIELDCAT.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  GET_EVENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_event .
CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
 EXPORTING
   I_LIST_TYPE           = 0
 IMPORTING
   ET_EVENTS             = IT_EVENT
 EXCEPTIONS
   LIST_TYPE_WRONG       = 1
   OTHERS                = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.



  READ TABLE IT_EVENT INTO WA_EVENT WITH KEY NAME = 'TOP_OF_PAGE'.
  WA_EVENT-FORM = 'TOP_OF_PAGE'.
  MODIFY IT_EVENT FROM WA_EVENT INDEX SY-TABIX.
ENDFORM.
FORM TOP_OF_PAGE.
 data : date1 TYPE string.

  WA_HEADER-TYP = 'H'.  "header
  WA_HEADER-INFO = 'Standard Costing Report'.
  APPEND WA_HEADER TO IT_HEADER.
  CLEAR WA_HEADER.

 CONCATENATE SY-DATUM+6(2)
 ' : '
 SY-DATUM+4(2)
 ' : '
 SY-DATUM(4) INTO DATE1 SEPARATED BY SPACE.

  WA_HEADER-TYP = 'S'. "selection
  WA_HEADER-KEY = 'USER : '.
  WA_HEADER-INFO = sy-UNAME.
  APPEND WA_HEADER TO IT_HEADER.
   CLEAR WA_HEADER.

  WA_HEADER-TYP = 'S'. "Action
  WA_HEADER-KEY = 'Current Date : '.
  WA_HEADER-INFO = date1.
  APPEND WA_HEADER TO IT_HEADER.
CLEAR: WA_HEADER.

CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
  EXPORTING
    IT_LIST_COMMENTARY       = IT_HEADER
*   I_LOGO                   =
*   I_END_OF_LIST_GRID       =
*   I_ALV_FORM               =
          .
CLEAR IT_HEADER.
ENDFORM.
