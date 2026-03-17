*&---------------------------------------------------------------------*
*& REPORT  zus_inventory_ageing
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zus_inventory_ageing_new MESSAGE-ID zdel.

TYPES : BEGIN OF t_mara,
          matnr   TYPE matnr,     " MATERIAL NUMBER
          meins	  TYPE meins,     "	BASE UNIT OF MEASURE
          mtart   TYPE mtart,
          wrkst   TYPE wrkst,
          zseries TYPE zser_code, "	SERIES CODE
          zsize	  TYPE zsize,     "	SIZE
          brand	  TYPE zbrand,    "	BRAND1
          moc	    TYPE zmoc,      "	MOC
          type    TYPE ztyp,      " TYPE
        END OF t_mara,

        BEGIN OF t_plstk,
          matnr	TYPE matnr,     "	MATERIAL NUMBER
          "WERKS    TYPE WERKS_D,   " PLANT
          lgort	TYPE lgort_d,   "	Storage Location
          labst	TYPE labst,     "	VALUATED UNRESTRICTED-USE STOCK
          insme	TYPE insme,     "	STOCK IN QUALITY INSPECTION
        END OF t_plstk,

        BEGIN OF t_makt,
          matnr TYPE matnr,     " MATERIAL NUMBER
          maktx TYPE maktx,     " MATERIAL DESCRIPTION (SHORT TEXT)
        END OF t_makt,

        BEGIN OF t_mbew,
          matnr	TYPE matnr,     " MATERIAL NUMBER
          vprsv TYPE vprsv,     " PRICE CONTROL INDICATOR
          verpr TYPE verpr,      "  MOVING AVERAGE PRICE/PERIODIC UNIT PRICE
          stprs	TYPE stprs,	     " STANDARD PRICE
        END OF t_mbew,

        BEGIN OF t_mseg,
          mblnr	TYPE mblnr,     " NUMBER OF MATERIAL DOCUMENT
          mjahr TYPE mjahr,
          ZEILE TYPE mblpo,
          bwart	TYPE bwart,     "	MOVEMENT TYPE (INVENTORY MANAGEMENT)
          lgort TYPE lgort_d,
          sobkz	TYPE sobkz,     " SPECIAL STOCK INDICATOR
          shkzg TYPE shkzg,
          menge	TYPE menge_d,   "	QUANTITY
          smbln	TYPE mblnr,     "	NUMBER OF MATERIAL DOCUMENT
          budat TYPE budat,
        END OF t_mseg,

        BEGIN OF t_mkpf,
          mblnr	TYPE mblnr,     "	NUMBER OF MATERIAL DOCUMENT
          cpudt	TYPE cpudt,     "	DAY ON WHICH ACCOUNTING DOCUMENT WAS ENTERED
          dspan TYPE int4,
        END OF t_mkpf,
        BEGIN OF t_qals,
         PRUEFLOS TYPE QPLOS,
         MBLNR TYPE MBLNR,
         MJAHR TYPE MJAHR,
        END OF t_qals,

        BEGIN OF t_qamb,
         PRUEFLOS TYPE QPLOS,
         MBLNR TYPE MBLNR,
         MJAHR TYPE MJAHR,
         zeile TYPE mblpo,
       END OF t_qamb,

        BEGIN OF t_result,
          matnr           TYPE matnr,     " MATERIAL NUMBER
          maktx           TYPE maktx,     " MATERIAL DESCRIPTION (SHORT TEXT)
          werks	          TYPE werks_d,   "	PLANT
          lgort           TYPE mard-lgort,   " Storage Location
          meins	          TYPE meins,     "	BASE UNIT OF MEASURE
          zrate           TYPE zrate,     " RATE
          mtart           TYPE mara-mtart,

          urq_lt30        TYPE zurq_lt30,
          v_urq_lt30      TYPE zv_urq_lt30,
          soq_lt30        TYPE zsoq_lt30,
          v_soq_lt30      TYPE zv_soq_lt30,

          urq_bt31_60     TYPE zurq_bt31_60,
          v_urq_bt31_60   TYPE zv_urq_bt31_60,
          soq_bt31_60     TYPE zsoq_bt31_60,
          v_soq_bt31_60   TYPE zv_soq_bt31_60,

          urq_bt61_90     TYPE zurq_bt61_90,
          v_urq_bt61_90   TYPE zv_urq_bt61_90,
          soq_bt61_90     TYPE zsoq_bt61_90,
          v_soq_bt61_90   TYPE zv_soq_bt61_90,

          urq_bt91_120    TYPE zurq_bt91_120,
          v_urq_bt91_120  TYPE zv_urq_bt91_120,
          soq_bt91_120    TYPE zsoq_bt91_120,
          v_soq_bt91_120  TYPE zv_soq_bt91_120,

          urq_bt121_150   TYPE zurq_bt121_150,
          v_urq_bt121_150 TYPE zv_urq_bt121_150,
          soq_bt121_150   TYPE zsoq_bt121_150,
          v_soq_bt121_150 TYPE zv_soq_bt121_150,

          urq_bt151_180   TYPE zurq_bt151_180,
          v_urq_bt151_180 TYPE zv_urq_bt151_180,
          soq_bt151_180   TYPE zsoq_bt151_180,
          v_soq_bt151_180 TYPE zv_soq_bt151_180,

          urq_bt181_365   TYPE zurq_bt181_365,
          v_urq_bt181_365 TYPE zv_urq_bt181_365,
          soq_bt181_365   TYPE zsoq_bt181_365,
          v_soq_bt181_365 TYPE zv_soq_bt181_365,

          urq_bt1_2   TYPE zurq_bt1_2,
          v_urq_bt1_2 TYPE zv_urq_bt1_2,
          soq_bt1_2   TYPE zsoq_bt1_2,
          v_soq_bt1_2 TYPE zv_soq_bt1_2,

          urq_bt2_3   TYPE zurq_bt2_3,
          v_urq_bt2_3 TYPE zv_urq_bt2_3,
          soq_bt2_3   TYPE zsoq_bt2_3,
          v_soq_bt2_3 TYPE zv_soq_bt2_3,

          urq_bt3_4   TYPE zurq_bt3_4,
          v_urq_bt3_4 TYPE zv_urq_bt3_4,
          soq_bt3_4   TYPE zsoq_bt3_4,
          v_soq_bt3_4 TYPE zv_soq_bt3_4,

          urq_bt4_5   TYPE zurq_bt4_5,
          v_urq_bt4_5 TYPE zv_urq_bt4_5,
          soq_bt4_5   TYPE zsoq_bt4_5,
          v_soq_bt4_5 TYPE zv_soq_bt4_5,

*          urq_gt180       TYPE zurq_gt180,
*          v_urq_gt180     TYPE zv_urq_gt180,
*          soq_gt180       TYPE zsoq_gt180,
*          v_soq_gt180     TYPE zv_soq_gt180,

          ur_totqty       TYPE zur_tot_qty, " UNRESTRICTED STOCK : TOTAL QUANTITY
          ur_totval       TYPE zurtotval,   " UNRESTRICTED STOCK : TOTAL VALUE
          so_totqty       TYPE zso_tot_qty, " SALES ORDER STOCK : TOTAL QUANTITY
          so_totval       TYPE zsototval,   " SALES ORDER STOCK : TOTAL VALUE


          zseries         TYPE zser_code, "	SERIES CODE
          zsize	          TYPE zsize,     "	SIZE
          brand	          TYPE zbrand,                              "	BRAND1
          moc	            TYPE zmoc,      " MOC
          type            TYPE ztyp,      " TYPE
          wrkst           TYPE wrkst,

        END OF t_result,

        BEGIN OF t_rslt,
          q_lt30        TYPE zurq_lt30,
          q_bt31_60     TYPE zurq_bt31_60,
          q_bt61_90     TYPE zurq_bt61_90,
          q_bt91_120    TYPE zurq_bt91_120,
          q_bt121_150   TYPE zurq_bt121_150,
          q_bt151_180   TYPE zurq_bt151_180,
          q_bt181_365   TYPE zurq_bt181_365,
          q_bt1_2       TYPE zurq_bt1_2,
          q_bt2_3       TYPE zurq_bt2_3,
          q_bt3_4       TYPE zurq_bt3_4,
          q_bt4_5       TYPE zurq_bt4_5,
*          q_gt180       TYPE zurq_gt180,

          v_q_lt30      TYPE zv_urq_lt30,
          v_q_bt31_60   TYPE zv_urq_bt31_60,
          v_q_bt61_90   TYPE zv_urq_bt61_90,
          v_q_bt91_120  TYPE zv_urq_bt91_120,
          v_q_bt121_150 TYPE zv_urq_bt121_150,
          v_q_bt151_180 TYPE zv_urq_bt151_180,

          v_q_bt181_365 TYPE zv_urq_bt181_365,
          v_q_bt1_2     TYPE zv_urq_bt1_2,
          v_q_bt2_3     TYPE zv_urq_bt2_3,
          v_q_bt3_4     TYPE zv_urq_bt3_4,
          v_q_bt4_5     TYPE zv_urq_bt4_5,
*          v_q_gt180     TYPE zv_urq_gt180,

          totqty        TYPE menge_d, " TOTAL QUANTITY
        END OF t_rslt,

        tt_mseg   TYPE TABLE OF t_mseg,
        tt_plstk  TYPE TABLE OF t_plstk,
        tt_result TYPE TABLE OF t_result,

        rng_matnr TYPE RANGE OF matnr,
        rng_lgort TYPE RANGE OF lgort.

TYPES: BEGIN OF ty_final,
*          matnr           TYPE char20,     " MATERIAL NUMBER
          matnr           TYPE char40,     " MATERIAL NUMBER
          maktx           TYPE char100,     " MATERIAL DESCRIPTION (SHORT TEXT)
          werks           TYPE char20,   "  PLANT
          lgort           TYPE char20,   " Storage Location
          meins           TYPE char20,     "  BASE UNIT OF MEASURE
          zrate           TYPE char50,     " RATE
          mtart           TYPE char20,

          urq_lt30        TYPE char50,
          v_urq_lt30      TYPE char50,
          soq_lt30        TYPE char50,
          v_soq_lt30      TYPE char50,

          urq_bt31_60     TYPE char50,
          v_urq_bt31_60   TYPE char50,
          soq_bt31_60     TYPE char50,
          v_soq_bt31_60   TYPE char50,

          urq_bt61_90     TYPE char50,
          v_urq_bt61_90   TYPE char50,
          soq_bt61_90     TYPE char50,
          v_soq_bt61_90   TYPE char50,

          urq_bt91_120    TYPE char50,
          v_urq_bt91_120  TYPE char50,
          soq_bt91_120    TYPE char50,
          v_soq_bt91_120  TYPE char50,

          urq_bt121_150   TYPE char50,
          v_urq_bt121_150 TYPE char50,
          soq_bt121_150   TYPE char50,
          v_soq_bt121_150 TYPE char50,

          urq_bt151_180   TYPE char50,
          v_urq_bt151_180 TYPE char50,
          soq_bt151_180   TYPE char50,
          v_soq_bt151_180 TYPE char50,

          urq_bt181_365   TYPE char50,
          v_urq_bt181_365 TYPE char50,
          soq_bt181_365   TYPE char50,
          v_soq_bt181_365 TYPE char50,

          urq_bt1_2   TYPE char50,
          v_urq_bt1_2 TYPE char50,
          soq_bt1_2   TYPE char50,
          v_soq_bt1_2 TYPE char50,

          urq_bt2_3   TYPE char50,
          v_urq_bt2_3 TYPE char50,
          soq_bt2_3   TYPE char50,
          v_soq_bt2_3 TYPE char50,

          urq_bt3_4   TYPE char50,
          v_urq_bt3_4 TYPE char50,
          soq_bt3_4   TYPE char50,
          v_soq_bt3_4 TYPE char50,

          urq_bt4_5   TYPE char50,
          v_urq_bt4_5 TYPE char50,
          soq_bt4_5   TYPE char50,
          v_soq_bt4_5 TYPE char50,

*          urq_gt180       TYPE char50,
*          v_urq_gt180     TYPE char50,
*          soq_gt180       TYPE char50,
*          v_soq_gt180     TYPE char50,

          ur_totqty       TYPE char50, " UNRESTRICTED STOCK : TOTAL QUANTITY
          ur_totval       TYPE char50,   " UNRESTRICTED STOCK : TOTAL VALUE
          so_totqty       TYPE char50, " SALES ORDER STOCK : TOTAL QUANTITY
          so_totval       TYPE char50,   " SALES ORDER STOCK : TOTAL VALUE


          zseries         TYPE char50, "  SERIES CODE
          zsize           TYPE char50,     "  SIZE
          brand	          TYPE char50,                              "	BRAND1
          moc	            TYPE char50,    " MOC
          type            TYPE char50,    " TYPE
          wrkst           TYPE char50,
          REF             TYPE char15,

        END OF ty_final.

DATA: it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final.


DATA : wa_rslt TYPE t_result,
       it_rslt TYPE tt_result.
DATA : it_qals TYPE STANDARD TABLE OF t_qals,
       wa_qals TYPE t_qals,
       it_qamb TYPE STANDARD TABLE OF t_qamb,
       wa_qamb TYPE t_qamb.
DATA : lc_msg    TYPE REF TO cx_salv_msg,
       alv_obj   TYPE REF TO cl_salv_table,
       alv_fncts TYPE REF TO cl_salv_functions_list.
DATA : lv_tabix_s TYPE sy-index,
       lv_tabix_h TYPE sy-index,
       lv_tabix TYPE sy-index.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : v_matnr FOR wa_rslt-matnr." OBLIGATORY.
PARAMETERS     : v_werks TYPE werks_d OBLIGATORY DEFAULT 'US01'.
SELECT-OPTIONS : v_lgort FOR wa_rslt-LGORT." OBLIGATORY NO INTERVALS.
*SELECT-OPTIONS : v_mtart FOR wa_rslt-mtart OBLIGATORY NO INTERVALS.
SELECT-OPTIONS : v_mtart FOR wa_rslt-mtart NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT    '/Delval/USA'."USA'."usa'.         "'E:\delval\usa'.
SELECTION-SCREEN END OF BLOCK B2.

 SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE TEXT-005.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
  SELECTION-SCREEN END OF BLOCK b6.


*AT SELECTION-SCREEN ON V_MATNR.
*  IF NOT V_MATNR-LOW IS INITIAL.
*    SELECT SINGLE MATNR
*      FROM MARA
*      INTO WA_RSLT-MATNR
*      WHERE MATNR = V_MATNR-LOW.
*    IF SY-SUBRC <> 0.
*      MESSAGE E011 WITH TEXT-002.
*    ENDIF.
*  ENDIF.
*  IF NOT V_MATNR-HIGH IS INITIAL.
*    SELECT SINGLE MATNR
*      FROM MARA
*      INTO WA_RSLT-MATNR
*      WHERE MATNR = V_MATNR-HIGH.
*    IF SY-SUBRC <> 0.
*      MESSAGE E011 WITH TEXT-002.
*    ENDIF.
*  ENDIF.

AT SELECTION-SCREEN ON v_werks.
  SELECT SINGLE werks
    FROM t001w
    INTO wa_rslt-werks
    WHERE werks = v_werks.
  IF sy-subrc <> 0.
    MESSAGE e023.
  ENDIF.


START-OF-SELECTION.
  PERFORM get_data USING v_matnr[]
*                         v_lgort[]
                         v_werks

                   CHANGING it_rslt.

  PERFORM display_results USING it_rslt[].



*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR    text
*      -->P_WERKS    text
*      -->P_RSLT     text
*----------------------------------------------------------------------*
FORM get_data USING p_matnr TYPE rng_matnr
*                      p_lgort TYPE rng_lgort
                      p_werks TYPE werks_d

                   CHANGING p_rslt TYPE tt_result.

  DATA : wa_mara TYPE t_mara,
         wa_mard TYPE t_plstk,
         wa_mska TYPE t_plstk,
         wa_makt TYPE t_makt,
         wa_mbew TYPE t_mbew,
         wa_rslt TYPE t_result,
         w_rslt  TYPE t_rslt,
         "WA_MDPS TYPE MDPS,
         "WA_MSEG TYPE T_MSEG,
         "WA_MKPF TYPE T_MKPF,

         it_mara TYPE TABLE OF t_mara,
         it_mard TYPE TABLE OF t_plstk,
         it_mska TYPE TABLE OF t_plstk,
         it_makt TYPE TABLE OF t_makt,
         it_mbew TYPE TABLE OF t_mbew.
  "IT_MDPS TYPE TABLE OF MDPS,
  "IT_MKPF TYPE TABLE OF T_MKPF.

  DATA : zrate   TYPE zrate.     " RATE.

  CLEAR : wa_mara, wa_mard, wa_mska, wa_makt, wa_rslt, wa_mbew,
          zrate.", WA_MDPS,
  ", WA_MKPF, DSPAN.
  REFRESH : it_mara, it_mard, it_mska, it_makt, p_rslt, it_mbew.", IT_MDPS, IT_MKPF.

  SELECT matnr
         lgort
         labst
         insme
      FROM mard
      INTO TABLE it_mard
      WHERE matnr IN v_matnr
        AND werks = v_werks
        AND lgort IN v_lgort   "IN ('RM01', 'FG01', 'PRD1', 'SFG1' )
    "  GROUP BY MATNR WERKS
    .

  IF it_mard IS NOT INITIAL.

  SELECT matnr
         meins
         mtart
         wrkst
         zseries
         zsize
         brand
         moc
         type
    FROM mara
    INTO TABLE it_mara
    FOR ALL ENTRIES IN it_mard
    WHERE mtart IN v_mtart AND matnr = it_mard-matnr.

    SELECT matnr
           maktx
      FROM makt
      INTO TABLE it_makt
      FOR ALL ENTRIES IN it_mara
      WHERE matnr = it_mara-matnr.

    SELECT matnr
           vprsv
           verpr
           stprs
      FROM mbew
      INTO TABLE it_mbew
      FOR ALL ENTRIES IN it_mara
      WHERE matnr = it_mara-matnr
        AND bwkey = v_werks.
ENDIF.
    SELECT matnr
           "WERKS
           lgort
           SUM( kalab ) AS labst
           SUM( kains ) AS insme
      FROM mska
      INTO TABLE it_mska
      WHERE matnr IN v_matnr
        AND werks = v_werks
        AND lgort IN v_lgort "IN ('RM01', 'FG01', 'PRD1', 'SFG1')
      GROUP BY matnr werks lgort.
*Added by swati
      IF it_mska IS NOT INITIAL.
  SELECT matnr
         meins
         mtart
         wrkst
         zseries
         zsize
         brand
         moc
         type
    FROM mara
    APPENDING TABLE it_mara
    FOR ALL ENTRIES IN it_mska
    WHERE mtart IN v_mtart AND matnr = it_mska-matnr.
     SORT it_mara by matnr.
     delete ADJACENT DUPLICATES FROM it_mara COMPARING matnr.

    SELECT matnr
           maktx
      FROM makt
      APPENDING TABLE it_makt
      FOR ALL ENTRIES IN it_mara
      WHERE matnr = it_mara-matnr.
    SELECT matnr
           vprsv
           verpr
           stprs
      FROM mbew
      APPENDING TABLE it_mbew
      FOR ALL ENTRIES IN it_mara
      WHERE matnr = it_mara-matnr
        AND bwkey = v_werks.
      ENDIF.

    LOOP AT it_mara INTO wa_mara.
      CLEAR wa_rslt.
      wa_rslt-matnr   = wa_mara-matnr.
      wa_rslt-mtart   = wa_mara-mtart.
      wa_rslt-wrkst   = wa_mara-wrkst.
      wa_rslt-meins   = wa_mara-meins.
      wa_rslt-zseries = wa_mara-zseries.
      wa_rslt-zsize   = wa_mara-zsize.
      wa_rslt-brand   = wa_mara-brand.
      wa_rslt-moc     = wa_mara-moc.
      wa_rslt-type    = wa_mara-type.

      wa_rslt-werks   = v_werks.

      READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mara-matnr.
      IF sy-subrc = 0.
        wa_rslt-maktx = wa_makt-maktx.
      ENDIF.

      READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_mara-matnr.
      IF sy-subrc = 0.
        IF wa_mbew-vprsv = 'V'.
          zrate = wa_mbew-verpr.
        ELSEIF wa_mbew-vprsv = 'S'.
          zrate = wa_mbew-stprs.
        ENDIF.
      ENDIF.
      wa_rslt-zrate = zrate.

      LOOP AT it_mard INTO wa_mard WHERE matnr = wa_mara-matnr .        "AND ( labst IS NOT INITIAL or insme IS NOT INITIAL ).
        wa_rslt-lgort = wa_mard-lgort.
        " UNRESTRICTED QUANTITY RELATED CALCULATIONS
        CLEAR w_rslt.
        PERFORM getstockinfo USING wa_rslt-matnr
                                   wa_rslt-werks
                                   wa_rslt-lgort
                                   it_mard[]
                                   'UR'
                             CHANGING w_rslt.
        IF NOT w_rslt IS INITIAL.
          wa_rslt-urq_lt30      = w_rslt-q_lt30.
          wa_rslt-urq_bt31_60   = w_rslt-q_bt31_60.
          wa_rslt-urq_bt61_90   = w_rslt-q_bt61_90.
          wa_rslt-urq_bt91_120  = w_rslt-q_bt91_120.
          wa_rslt-urq_bt121_150 = w_rslt-q_bt121_150.
          wa_rslt-urq_bt151_180 = w_rslt-q_bt151_180.

          wa_rslt-urq_bt181_365  = w_rslt-q_bt181_365 .
          wa_rslt-urq_bt1_2      = w_rslt-q_bt1_2     .
          wa_rslt-urq_bt2_3      = w_rslt-q_bt2_3     .
          wa_rslt-urq_bt3_4      = w_rslt-q_bt3_4     .
          wa_rslt-urq_bt4_5      = w_rslt-q_bt4_5     .
*          wa_rslt-urq_gt180     = w_rslt-q_gt180.

          wa_rslt-v_urq_lt30       = zrate * wa_rslt-urq_lt30     .
          wa_rslt-v_urq_bt31_60    = zrate * wa_rslt-urq_bt31_60  .
          wa_rslt-v_urq_bt61_90    = zrate * wa_rslt-urq_bt61_90  .
          wa_rslt-v_urq_bt91_120   = zrate * wa_rslt-urq_bt91_120 .
          wa_rslt-v_urq_bt121_150  = zrate * wa_rslt-urq_bt121_150.
          wa_rslt-v_urq_bt151_180  = zrate * wa_rslt-urq_bt151_180.

          wa_rslt-v_urq_bt181_365  = zrate * wa_rslt-urq_bt181_365 .
          wa_rslt-v_urq_bt1_2      = zrate * wa_rslt-urq_bt1_2     .
          wa_rslt-v_urq_bt2_3      = zrate * wa_rslt-urq_bt2_3     .
          wa_rslt-v_urq_bt3_4      = zrate * wa_rslt-urq_bt3_4     .
          wa_rslt-v_urq_bt4_5      = zrate * wa_rslt-urq_bt4_5     .
*          wa_rslt-v_urq_gt180      = zrate * wa_rslt-urq_gt180    .

          wa_rslt-ur_totqty = w_rslt-totqty.

        ENDIF.
        " END : UNRESTRICTED MSEG

        " SALES ORDER STOCK RELATED CALCULATIONS
        CLEAR w_rslt.
        PERFORM getstockinfo USING wa_rslt-matnr
                                   wa_rslt-werks
                                   wa_rslt-lgort
                                   it_mska[]
                                   'SO'
                             CHANGING w_rslt.
        DELETE it_mska WHERE matnr = wa_rslt-matnr AND lgort = wa_rslt-lgort.
        IF NOT w_rslt IS INITIAL.
          wa_rslt-soq_lt30         = w_rslt-q_lt30.
          wa_rslt-soq_bt31_60      = w_rslt-q_bt31_60.
          wa_rslt-soq_bt61_90      = w_rslt-q_bt61_90.
          wa_rslt-soq_bt91_120     = w_rslt-q_bt91_120.
          wa_rslt-soq_bt121_150    = w_rslt-q_bt121_150.
          wa_rslt-soq_bt151_180    = w_rslt-q_bt151_180.


          wa_rslt-soq_bt181_365    = w_rslt-q_bt181_365.
          wa_rslt-soq_bt1_2        = w_rslt-q_bt1_2    .
          wa_rslt-soq_bt2_3        = w_rslt-q_bt2_3    .
          wa_rslt-soq_bt3_4        = w_rslt-q_bt3_4    .
          wa_rslt-soq_bt4_5        = w_rslt-q_bt4_5    .
*          wa_rslt-soq_gt180        = w_rslt-q_gt180.

          wa_rslt-v_soq_lt30       = zrate * wa_rslt-soq_lt30     .
          wa_rslt-v_soq_bt31_60    = zrate * wa_rslt-soq_bt31_60  .
          wa_rslt-v_soq_bt61_90    = zrate * wa_rslt-soq_bt61_90  .
          wa_rslt-v_soq_bt91_120   = zrate * wa_rslt-soq_bt91_120 .
          wa_rslt-v_soq_bt121_150  = zrate * wa_rslt-soq_bt121_150.
          wa_rslt-v_soq_bt151_180  = zrate * wa_rslt-soq_bt151_180.

          wa_rslt-v_soq_bt181_365  = zrate * wa_rslt-soq_bt181_365.
          wa_rslt-v_soq_bt1_2      = zrate * wa_rslt-soq_bt1_2    .
          wa_rslt-v_soq_bt2_3      = zrate * wa_rslt-soq_bt2_3    .
          wa_rslt-v_soq_bt3_4      = zrate * wa_rslt-soq_bt3_4    .
          wa_rslt-v_soq_bt4_5      = zrate * wa_rslt-soq_bt4_5    .

*          wa_rslt-v_soq_gt180      = zrate * wa_rslt-soq_gt180    .

          wa_rslt-so_totqty = w_rslt-totqty.
        ENDIF.
        " END : SALES ORDER STOCK RELATED CALCULATIONS

        wa_rslt-ur_totval = wa_rslt-ur_totqty * zrate.
        wa_rslt-so_totval = wa_rslt-so_totqty * zrate.

********************************* Download File Data*******************************************************
        wa_final-matnr       =     wa_rslt-matnr  .
        wa_final-mtart       =     wa_rslt-mtart  .
        wa_final-wrkst       =     wa_rslt-wrkst  .
        wa_final-meins       =     wa_rslt-meins  .
        wa_final-zseries     =     wa_rslt-zseries.
        wa_final-zsize       =     wa_rslt-zsize  .
        wa_final-brand       =     wa_rslt-brand  .
        wa_final-moc         =     wa_rslt-moc    .
        wa_final-type        =     wa_rslt-type   .

        wa_final-werks       =     wa_rslt-werks  .
        wa_final-maktx       =     wa_rslt-maktx  .
        wa_final-zrate       =     wa_rslt-zrate  .
        wa_final-lgort        =     wa_rslt-lgort  .

        wa_final-urq_lt30     =     wa_rslt-urq_lt30    .
        wa_final-urq_bt31_60  =     wa_rslt-urq_bt31_60  .
        wa_final-urq_bt61_90  =     wa_rslt-urq_bt61_90   .
        wa_final-urq_bt91_120 =     wa_rslt-urq_bt91_120  .
        wa_final-urq_bt121_150 =    wa_rslt-urq_bt121_150 .
        wa_final-urq_bt151_180 =    wa_rslt-urq_bt151_180 .

        wa_final-urq_bt181_365 =    wa_rslt-urq_bt181_365 .
        wa_final-urq_bt1_2     =    wa_rslt-urq_bt1_2     .
        wa_final-urq_bt2_3     =    wa_rslt-urq_bt2_3     .
        wa_final-urq_bt3_4     =    wa_rslt-urq_bt3_4     .
        wa_final-urq_bt4_5     =    wa_rslt-urq_bt4_5     .
*        wa_final-urq_gt180     =    wa_rslt-urq_gt180     .

        wa_final-v_urq_lt30      =   wa_rslt-v_urq_lt30     .
        wa_final-v_urq_bt31_60   =   wa_rslt-v_urq_bt31_60   .
        wa_final-v_urq_bt61_90   =   wa_rslt-v_urq_bt61_90   .
        wa_final-v_urq_bt91_120  =   wa_rslt-v_urq_bt91_120  .
        wa_final-v_urq_bt121_150 =   wa_rslt-v_urq_bt121_150 .
        wa_final-v_urq_bt151_180 =   wa_rslt-v_urq_bt151_180 .

        wa_final-v_urq_bt181_365 =   wa_rslt-v_urq_bt181_365 .
        wa_final-v_urq_bt1_2     =   wa_rslt-v_urq_bt1_2     .
        wa_final-v_urq_bt2_3     =   wa_rslt-v_urq_bt2_3     .
        wa_final-v_urq_bt3_4     =   wa_rslt-v_urq_bt3_4     .
        wa_final-v_urq_bt4_5     =   wa_rslt-v_urq_bt4_5     .


*        wa_final-v_urq_gt180     =   wa_rslt-v_urq_gt180     .

        wa_final-ur_totqty        =   wa_rslt-ur_totqty .

        wa_final-soq_lt30         =   wa_rslt-soq_lt30         .
        wa_final-soq_bt31_60      =   wa_rslt-soq_bt31_60      .
        wa_final-soq_bt61_90      =   wa_rslt-soq_bt61_90      .
        wa_final-soq_bt91_120     =   wa_rslt-soq_bt91_120     .
        wa_final-soq_bt121_150    =   wa_rslt-soq_bt121_150    .
        wa_final-soq_bt151_180    =   wa_rslt-soq_bt151_180    .

        wa_final-soq_bt181_365    =   wa_rslt-soq_bt181_365    .
        wa_final-soq_bt1_2        =   wa_rslt-soq_bt1_2        .
        wa_final-soq_bt2_3        =   wa_rslt-soq_bt2_3        .
        wa_final-soq_bt3_4        =   wa_rslt-soq_bt3_4        .
        wa_final-soq_bt4_5        =   wa_rslt-soq_bt4_5        .

*        wa_final-soq_gt180        =   wa_rslt-soq_gt180        .

        wa_final-so_totqty         =   wa_rslt-so_totqty .
        wa_final-ur_totval         =   wa_rslt-ur_totval .
        wa_final-so_totval         =   wa_rslt-so_totval .

        wa_final-v_soq_lt30         =   wa_rslt-v_soq_lt30      .
        wa_final-v_soq_bt31_60      =   wa_rslt-v_soq_bt31_60   .
        wa_final-v_soq_bt61_90      =   wa_rslt-v_soq_bt61_90   .
        wa_final-v_soq_bt91_120     =   wa_rslt-v_soq_bt91_120  .
        wa_final-v_soq_bt121_150    =   wa_rslt-v_soq_bt121_150 .
        wa_final-v_soq_bt151_180    =   wa_rslt-v_soq_bt151_180 .

        wa_final-v_soq_bt181_365    =   wa_rslt-v_soq_bt181_365 .
        wa_final-v_soq_bt1_2        =   wa_rslt-v_soq_bt1_2     .
        wa_final-v_soq_bt2_3        =   wa_rslt-v_soq_bt2_3     .
        wa_final-v_soq_bt3_4        =   wa_rslt-v_soq_bt3_4     .
        wa_final-v_soq_bt4_5        =   wa_rslt-v_soq_bt4_5     .
*        wa_final-v_soq_gt180        =   wa_rslt-v_soq_gt180     .

        wa_final-ref = sy-datum.

            CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
              EXPORTING
                input         = wa_final-ref
              IMPORTING
                OUTPUT        = wa_final-ref
                .

            CONCATENATE wa_final-ref+0(2) wa_final-ref+2(3) wa_final-ref+5(4)
                INTO wa_final-ref SEPARATED BY '-'.

***********************************************************************************************************************

        IF ( wa_rslt-ur_totqty IS NOT INITIAL or wa_rslt-so_totqty IS NOT INITIAL ).
          APPEND wa_rslt TO p_rslt.
          APPEND wa_final TO it_final.

        ENDIF.

        CLEAR : WA_RSLT-URQ_LT30,WA_RSLT-V_URQ_LT30,WA_RSLT-SOQ_LT30,WA_RSLT-V_SOQ_LT30,WA_RSLT-URQ_BT31_60,WA_RSLT-V_URQ_BT31_60,WA_RSLT-SOQ_BT31_60,
          WA_RSLT-V_SOQ_BT31_60,WA_RSLT-URQ_BT61_90,WA_RSLT-V_URQ_BT61_90,WA_RSLT-SOQ_BT61_90,WA_RSLT-V_SOQ_BT61_90,WA_RSLT-URQ_BT91_120,
          WA_RSLT-V_URQ_BT91_120,WA_RSLT-SOQ_BT91_120,WA_RSLT-V_SOQ_BT91_120,WA_RSLT-URQ_BT121_150,WA_RSLT-V_URQ_BT121_150,WA_RSLT-SOQ_BT151_180,
          WA_RSLT-V_URQ_BT151_180,WA_RSLT-SOQ_BT151_180,WA_RSLT-V_SOQ_BT151_180,
          WA_RSLT-UR_TOTQTY,WA_RSLT-UR_TOTVAL,WA_RSLT-SO_TOTQTY,WA_RSLT-SO_TOTVAL,
          WA_RSLT-SOQ_BT181_365,WA_RSLT-V_URQ_BT181_365,WA_RSLT-SOQ_BT181_365,WA_RSLT-V_SOQ_BT181_365,
          WA_RSLT-SOQ_BT1_2,WA_RSLT-V_URQ_BT1_2,WA_RSLT-SOQ_BT1_2,WA_RSLT-V_SOQ_BT1_2,
          WA_RSLT-SOQ_BT2_3,WA_RSLT-V_URQ_BT2_3,WA_RSLT-SOQ_BT2_3,WA_RSLT-V_SOQ_BT2_3,
          WA_RSLT-SOQ_BT3_4,WA_RSLT-V_URQ_BT3_4,WA_RSLT-SOQ_BT3_4,WA_RSLT-V_SOQ_BT3_4,
          WA_RSLT-SOQ_BT4_5,WA_RSLT-V_URQ_BT4_5,WA_RSLT-SOQ_BT4_5,WA_RSLT-V_SOQ_BT4_5.

        CLEAR wa_mard.
      ENDLOOP.

      LOOP AT it_mska INTO wa_mska WHERE matnr = wa_mara-matnr .
        wa_rslt-lgort = wa_mska-lgort.
         CLEAR w_rslt.
        PERFORM getstockinfo USING wa_rslt-matnr
                                   wa_rslt-werks
                                   wa_rslt-lgort
                                   it_mska[]
                                   'SO'
                             CHANGING w_rslt.

        IF NOT w_rslt IS INITIAL.
          wa_rslt-soq_lt30         = w_rslt-q_lt30.
          wa_rslt-soq_bt31_60      = w_rslt-q_bt31_60.
          wa_rslt-soq_bt61_90      = w_rslt-q_bt61_90.
          wa_rslt-soq_bt91_120     = w_rslt-q_bt91_120.
          wa_rslt-soq_bt121_150    = w_rslt-q_bt121_150.
          wa_rslt-soq_bt151_180    = w_rslt-q_bt151_180.

          wa_rslt-soq_bt181_365    = w_rslt-q_bt181_365.
          wa_rslt-soq_bt1_2        = w_rslt-q_bt1_2    .
          wa_rslt-soq_bt2_3        = w_rslt-q_bt2_3    .
          wa_rslt-soq_bt3_4        = w_rslt-q_bt3_4    .
          wa_rslt-soq_bt4_5        = w_rslt-q_bt4_5    .
*          wa_rslt-soq_gt180        = w_rslt-q_gt180.

          wa_rslt-v_soq_lt30       = zrate * wa_rslt-soq_lt30     .
          wa_rslt-v_soq_bt31_60    = zrate * wa_rslt-soq_bt31_60  .
          wa_rslt-v_soq_bt61_90    = zrate * wa_rslt-soq_bt61_90  .
          wa_rslt-v_soq_bt91_120   = zrate * wa_rslt-soq_bt91_120 .
          wa_rslt-v_soq_bt121_150  = zrate * wa_rslt-soq_bt121_150.
          wa_rslt-v_soq_bt151_180  = zrate * wa_rslt-soq_bt151_180.

          wa_rslt-v_soq_bt181_365  = zrate * wa_rslt-soq_bt181_365.
          wa_rslt-v_soq_bt1_2      = zrate * wa_rslt-soq_bt1_2    .
          wa_rslt-v_soq_bt2_3      = zrate * wa_rslt-soq_bt2_3    .
          wa_rslt-v_soq_bt3_4      = zrate * wa_rslt-soq_bt3_4    .
          wa_rslt-v_soq_bt4_5      = zrate * wa_rslt-soq_bt4_5    .

*          wa_rslt-v_soq_gt180      = zrate * wa_rslt-soq_gt180    .

          wa_rslt-so_totqty = w_rslt-totqty.
        ENDIF.
        " END : SALES ORDER STOCK RELATED CALCULATIONS


        wa_rslt-so_totval = wa_rslt-so_totqty * zrate.

***************************************Download file*******************************************************
        wa_final-soq_lt30            =    wa_rslt-soq_lt30      .
        wa_final-soq_bt31_60         =    wa_rslt-soq_bt31_60   .
        wa_final-soq_bt61_90         =    wa_rslt-soq_bt61_90   .
        wa_final-soq_bt91_120        =    wa_rslt-soq_bt91_120  .
        wa_final-soq_bt121_150       =    wa_rslt-soq_bt121_150 .
        wa_final-soq_bt151_180       =    wa_rslt-soq_bt151_180 .

        wa_final-soq_bt181_365       =    wa_rslt-soq_bt181_365 .
        wa_final-soq_bt1_2           =    wa_rslt-soq_bt1_2     .
        wa_final-soq_bt2_3           =    wa_rslt-soq_bt2_3     .
        wa_final-soq_bt3_4           =    wa_rslt-soq_bt3_4     .
        wa_final-soq_bt4_5           =    wa_rslt-soq_bt4_5     .

*        wa_final-soq_gt180           =    wa_rslt-soq_gt180     .


        wa_final-v_soq_lt30           =     wa_rslt-v_soq_lt30     .
        wa_final-v_soq_bt31_60        =     wa_rslt-v_soq_bt31_60  .
        wa_final-v_soq_bt61_90        =     wa_rslt-v_soq_bt61_90  .
        wa_final-v_soq_bt91_120       =     wa_rslt-v_soq_bt91_120 .
        wa_final-v_soq_bt121_150      =     wa_rslt-v_soq_bt121_150.
        wa_final-v_soq_bt151_180      =     wa_rslt-v_soq_bt151_180.

        wa_final-v_soq_bt181_365      =     wa_rslt-v_soq_bt181_365.
        wa_final-v_soq_bt1_2          =     wa_rslt-v_soq_bt1_2    .
        wa_final-v_soq_bt2_3          =     wa_rslt-v_soq_bt2_3    .
        wa_final-v_soq_bt3_4          =     wa_rslt-v_soq_bt3_4    .
        wa_final-v_soq_bt4_5          =     wa_rslt-v_soq_bt4_5    .
*        wa_final-v_soq_gt180          =     wa_rslt-v_soq_gt180    .

        wa_final-so_totqty            =     wa_rslt-so_totqty.
        wa_final-so_totval            =     wa_rslt-so_totval.

****************************************************************************************************************

        IF NOT  wa_rslt-so_totqty IS INITIAL .
          APPEND wa_rslt TO p_rslt.
          APPEND wa_final TO it_final.
          CLEAR : wa_rslt.
        ENDIF.
        CLEAR wa_mska.
      ENDLOOP.
      CLEAR : wa_mara, wa_mard, wa_makt, wa_rslt, zrate.
    ENDLOOP.

ENDFORM.                    "GET_DATA

*&---------------------------------------------------------------------*
*&      Form  GETSTOCKINFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR    text
*      -->P_WERKS    text
*      -->IT_PLSTK   text
*      -->STKTYP     text
*      -->W_RSLT     text
*----------------------------------------------------------------------*
FORM getstockinfo USING   p_matnr TYPE matnr
                          p_werks TYPE werks_d
                          p_lgort TYPE lgort_d
                          it_plstk TYPE tt_plstk
                          stktyp TYPE char2
                  CHANGING w_rslt TYPE t_rslt.

  DATA : wa_plstk TYPE t_plstk,
         wa_mseg  TYPE t_mseg,
         wa_mseg_TEMP  TYPE t_mseg,
         wa_mkpf  TYPE t_mkpf,

         tmp_qty  TYPE menge_d,
         dspan    TYPE int4,
         str      TYPE string,
*           V1 TYPE CHAR5,
*           V2 TYPE CHAR5,

         it_mseg  TYPE TABLE OF t_mseg,
         it_mseg_322_h  TYPE TABLE OF t_mseg,
         it_mseg_322_s TYPE TABLE OF t_mseg,
         wa_mseg_322_s TYPE t_mseg,
         wa_mseg_322_h TYPE t_mseg,
         it_mseg_temp TYPE TABLE OF t_mseg,
         it_mseg1  TYPE TABLE OF t_mseg,
         it_mkpf  TYPE TABLE OF t_mkpf.

  CLEAR : w_rslt, wa_mseg, wa_mkpf, dspan, tmp_qty, str.
  REFRESH : it_mseg, it_mkpf.

  LOOP AT it_plstk INTO wa_plstk WHERE matnr = p_matnr
                                  AND lgort = p_lgort.
    tmp_qty = tmp_qty + wa_plstk-labst + wa_plstk-insme.
  ENDLOOP.



  IF stktyp = 'UR'.
    str = 'BWART IN (101,105,561,309,311,411,412,501,531,653,701,321,Z11) AND MATNR = P_MATNR '.
    CONCATENATE str 'AND WERKS = P_WERKS AND LGORT = P_LGORT'
    INTO str SEPARATED BY space.
    CONCATENATE str 'AND SHKZG = ''S'''INTO str SEPARATED BY space.
    CONCATENATE str ' AND SOBKZ <> ''E''' INTO str.
  ELSEIF stktyp = 'SO'.
    str = 'BWART IN (101,105,561,309,311,411,412,501,531,653,701,321,Z11) AND MATNR = P_MATNR '.
    CONCATENATE str 'AND WERKS = P_WERKS AND LGORT = P_LGORT'
    INTO str SEPARATED BY space.
    CONCATENATE str 'AND SHKZG = ''S'''INTO str SEPARATED BY space.
    CONCATENATE str ' AND SOBKZ = ''E''' INTO str.
  ENDIF.
  IF stktyp = 'UR'.
  SELECT mblnr
         mjahr
         zeile
         bwart
         lgort
         sobkz
         shkzg
         menge
         smbln
    FROM mseg
    INTO TABLE it_mseg
    WHERE BWART IN ('101','105','561','309','311','411','412','501','531','653','701','Z11','542','262',
    '602','301','413','344','Z42','202','343','312','544','166')
    AND MATNR = P_MATNR
    AND WERKS = P_WERKS AND LGORT = P_LGORT                                                                        "(str).
    AND SHKZG = 'S'
    AND SOBKZ <> 'E'.

    ELSEIF stktyp = 'SO'.
          SELECT mblnr
                 mjahr
                 zeile
                 bwart
                 lgort
                 sobkz
                 shkzg
                 menge
                 smbln
           FROM mseg
           INTO TABLE it_mseg
           WHERE BWART IN ('101','105','561','309','311','411','412','501','531','653','701','Z11','542','262',
            '602','301','413','344','Z42','202','343','312','544','166')    "(str).
           AND MATNR = P_MATNR
           AND WERKS = P_WERKS AND LGORT = P_LGORT
           AND SHKZG = 'S'
           AND SOBKZ = 'E'.
   ENDIF.

  " TO SKIP DOCUMENTS OF TYPE 102/102E AND THE RESPECTIVE SMBLN DOCS
  LOOP AT it_mseg INTO wa_mseg WHERE bwart = '102' OR bwart = '122' OR bwart = '161' OR bwart = '162'  OR bwart = '202' OR bwart = '261'
   OR bwart = '312' OR bwart = '322'  OR bwart = '532' OR bwart = '543' OR bwart = '562' OR bwart = '602' OR bwart = '702' OR bwart = '541'.
*      IF STKTYP = 'SO' AND WA_MSEG-SOBKZ <> 'E'.
*        CONTINUE.
*      ENDIF.
    DELETE it_mseg WHERE mblnr = wa_mseg-smbln OR mblnr = wa_mseg-mblnr.
  ENDLOOP.
*Added by swati on 18.01.2017 for 322  movement
  IF stktyp = 'UR'.
  SELECT mblnr
         mjahr
         zeile
         bwart
         lgort
         sobkz
         shkzg
         menge
         smbln
    FROM mseg
    INTO TABLE it_mseg_322_s
    WHERE BWART IN ('321','322')
    AND MATNR = P_MATNR
    AND WERKS = P_WERKS AND LGORT = P_LGORT                                                                        "(str).
    AND SOBKZ <> 'E'.

    ELSEIF stktyp = 'SO'.
          SELECT mblnr
                 mjahr
                 zeile
                 bwart
                 lgort
                 sobkz
                 shkzg
                 menge
                 smbln
           FROM mseg
           INTO TABLE it_mseg_322_s
           WHERE BWART IN ('321','322')    "(str).
           AND MATNR = P_MATNR
           AND WERKS = P_WERKS AND LGORT = P_LGORT
           AND SOBKZ = 'E'.
   ENDIF.
  IF it_mseg_322_s IS NOT INITIAL.
    it_mseg_322_h = it_mseg_322_s.
*    LOOP AT it_mseg_322_s INTO wa_mseg_322_s WHERE shkzg = 'S'.      "Commented by swati on 23.10.2018
*      lv_tabix = sy-tabix.
*      READ TABLE it_mseg_322_h INTO wa_mseg_322_h WITH  KEY shkzg = 'H'
*                                                            lgort = wa_mseg_322_s-lgort.
*      IF sy-subrc = 0.
*        DELETE it_mseg_322_s INDEX lv_tabix.
*      ENDIF.
*      CLEAR : wa_mseg_322_s,wa_mseg_322_h,lv_tabix.
*    ENDLOOP.
    LOOP AT it_mseg_322_s INTO wa_mseg_322_s WHERE shkzg = 'S'.       "Added by swati on 23.10.2018
      lv_tabix_s = sy-tabix.
      READ TABLE it_mseg_322_h INTO wa_mseg_322_h WITH  KEY shkzg = 'H'
                                                            menge = wa_mseg_322_s-menge
                                                            lgort = wa_mseg_322_s-lgort.

      IF sy-subrc = 0.
        lv_tabix_h = sy-tabix.
        DELETE it_mseg_322_s INDEX lv_tabix_s.
        DELETE it_mseg_322_h INDEX  lv_tabix_h .

      ENDIF.
      CLEAR : wa_mseg_322_s,wa_mseg_322_h,lv_tabix_s, lv_tabix_h .
    ENDLOOP.
  ENDIF.
  IF it_mseg_322_s IS NOT INITIAL.
    DELETE it_mseg_322_s WHERE shkzg = 'H'.
  ENDIF.
  append LINES OF it_mseg_322_s TO it_mseg.
*Commented on 19.01.2018
*it_mseg_101 = it_mseg.
*DELETE it_mseg_101 WHERE bwart <> '101'.
*IF it_mseg_101 IS NOT INITIAL.
*   SELECT PRUEFLOS
*          MBLNR
*          MJAHR
*          FROM qals INTO TABLE it_qals
*          FOR ALL ENTRIES IN it_mseg_101
*          WHERE mblnr = it_mseg_101-mblnr
*          AND mjahr = it_mseg_101-mjahr.
*  IF  it_qals IS NOT INITIAL.
*      SELECT PRUEFLOS
*             mblnr
*             mjahr
*             zeile
*             FROM qamb
*             INTO TABLE it_qamb
*             FOR ALL ENTRIES IN it_qals
*             WHERE prueflos = it_qals-prueflos.
*
*  ENDIF.
*  IF  it_qamb IS NOT INITIAL.
*    IF stktyp = 'UR'.
*      SELECT mblnr
*             mjahr
*             zeile
*             bwart
*         lgort
*         sobkz
*         menge
*         smbln
*         FROM mseg
*    INTO TABLE it_mseg_322
*    FOR ALL ENTRIES IN it_qamb
*    WHERE mblnr = it_qamb-mblnr
*    AND mjahr = it_qamb-mjahr
*    AND BWART IN ('321','322')
*    AND MATNR = P_MATNR
*    AND WERKS = P_WERKS AND LGORT = P_LGORT                                                                        "(str).
*    AND SHKZG = 'S'
*    AND SOBKZ <> 'E'.
*   ELSEIF stktyp = 'SO'.
*        SELECT mblnr
*               mjahr
*         zeile
*         bwart
*         lgort
*         sobkz
*         menge
*         smbln
*    FROM mseg
*    INTO TABLE it_mseg_322
*    FOR ALL ENTRIES IN it_qamb
*    WHERE mblnr = it_qamb-mblnr
*    AND mjahr = it_qamb-mjahr
*    AND BWART IN ('321','322')
*    AND MATNR = P_MATNR
*    AND WERKS = P_WERKS AND LGORT = P_LGORT                                                                        "(str).
*    AND SHKZG = 'S'
*    AND SOBKZ = 'E'.
*  ENDIF.
*  ENDIF.
*ENDIF.
  IF NOT it_mseg IS INITIAL.

      SELECT mblnr
             budat AS cpudt
        FROM mkpf
        INTO TABLE it_mkpf
        FOR ALL ENTRIES IN it_mseg
        WHERE mblnr = it_mseg-mblnr.

     IF sy-subrc = 0.
        LOOP AT it_mseg INTO wa_mseg.
          READ TABLE it_mkpf INTO wa_mkpf WITH  KEY mblnr = wa_mseg-mblnr.
          wa_mseg-budat = wa_mkpf-cpudt.
          MODIFY it_mseg FROM wa_mseg TRANSPORTING budat.
          CLEAR :wa_mseg,wa_mkpf.
        ENDLOOP.
        SORT it_mseg BY budat DESCENDING.
*    SORT it_mseg BY mblnr DESCENDING.
    LOOP AT it_mseg INTO wa_mseg.
*READ TABLE it_qals INTO wa_qals WITH  KEY mblnr = wa_mseg-mblnr
*                                          mjahr = wa_mseg-mjahr.
*IF  sy-subrc = 0.
*  READ TABLE it_qamb INTO wa_qamb WITH  KEY prueflos = wa_qals-prueflos
*                                            zeile = wa_mseg-zeile.
*  IF sy-subrc = 0.
*    READ TABLE it_mseg_322 INTO wa_mseg_322 WITH  KEY mblnr = wa_qamb-mblnr
*                                                      mjahr = wa_qamb-mjahr
*                                                      zeile = wa_qamb-zeile.
*    IF wa_mseg_322-lgort = wa_mseg-lgort.
*      wa_mseg-menge = wa_mseg_322-menge.
*    ENDIF.
*  ENDIF.
*ENDIF.
      IF wa_mseg-menge <= tmp_qty.
        tmp_qty = tmp_qty - wa_mseg-menge.
        wa_mseg_temp = wa_mseg.                   "Added by swati on 08.01.2018
        APPEND wa_mseg_temp TO it_mseg_temp.      "Added by swati on 08.01.2018
        IF tmp_qty = 0.
          EXIT.
        ENDIF.
      ELSE.
        wa_mseg-menge = tmp_qty.
        wa_mseg_temp = wa_mseg.               "Added by swati on 08.01.2018
        APPEND wa_mseg_temp TO it_mseg_temp.   "Added by swati on 08.01.2018
        MODIFY it_mseg FROM wa_mseg TRANSPORTING menge WHERE mblnr = wa_mseg-mblnr AND zeile = wa_mseg-zeile.
        EXIT.
      ENDIF.
      CLEAR : wa_mseg,wa_mseg_temp,wa_qals,wa_qamb,wa_mseg_322_s.
    ENDLOOP.
*Added by swati on 08.1.2018
      LOOP AT it_mseg INTO wa_mseg.
        lv_tabix = sy-tabix.
          READ TABLE it_mseg_temp INTO wa_mseg_temp WITH  KEY mblnr = wa_mseg-mblnr
                                                         zeile = wa_mseg-zeile.
          IF sy-subrc <> 0.
            DELETE it_mseg INDEX lv_tabix.
          ENDIF.
          CLEAR :wa_mseg,wa_mseg_temp.
      ENDLOOP.
*    DELETE it_mseg WHERE mblnr < wa_mseg-mblnr or ( mblnr = wa_mseg-mblnr AND zeile > wa_mseg-zeile ). "commented by swati on 08.01.2018
*    DELETE it_mkpf WHERE mblnr < wa_mseg-mblnr.
*    IF NOT it_mseg[] IS INITIAL.
*      SELECT mblnr
*             budat AS cpudt
*        FROM mkpf
*        INTO TABLE it_mkpf
*        FOR ALL ENTRIES IN it_mseg
*        WHERE mblnr = it_mseg-mblnr.
*      IF sy-subrc = 0.
*        LOOP AT it_mseg INTO wa_mseg.
*          READ TABLE it_mkpf INTO wa_mkpf WITH  KEY mblnr = wa_mseg-mblnr.
*          wa_mseg-budat = wa_mkpf-cpudt.
*          MODIFY it_mseg FROM wa_mseg TRANSPORTING budat.
*          CLEAR :wa_mseg,wa_mkpf.
*        ENDLOOP.
*        SORT it_mseg BY budat DESCENDING.

        LOOP AT it_mkpf INTO wa_mkpf.
          CLEAR : dspan, wa_mseg.
          dspan = sy-datum - wa_mkpf-cpudt.
*          READ TABLE it_mseg INTO wa_mseg WITH KEY mblnr = wa_mkpf-mblnr.
*          IF sy-subrc = 0.
            LOOP AT it_mseg INTO wa_mseg WHERE mblnr = wa_mkpf-mblnr .
              IF dspan <= 30.
              w_rslt-q_lt30       = wa_mseg-menge + w_rslt-q_lt30.
            ELSEIF dspan BETWEEN 31 AND 60.
              w_rslt-q_bt31_60    = wa_mseg-menge + w_rslt-q_bt31_60.
            ELSEIF dspan BETWEEN 61 AND 90.
              w_rslt-q_bt61_90    = wa_mseg-menge + w_rslt-q_bt61_90.
            ELSEIF dspan BETWEEN 91 AND 120.
              w_rslt-q_bt91_120   = wa_mseg-menge + w_rslt-q_bt91_120.
            ELSEIF dspan BETWEEN 121 AND 150.
              w_rslt-q_bt121_150  = wa_mseg-menge + w_rslt-q_bt121_150.
            ELSEIF dspan BETWEEN 151 AND 180.
              w_rslt-q_bt151_180  = wa_mseg-menge + w_rslt-q_bt151_180.

            ELSEIF dspan BETWEEN 181 AND 365.
              w_rslt-q_bt181_365  = wa_mseg-menge + w_rslt-q_bt181_365.
            ELSEIF dspan BETWEEN 366 AND 730.
              w_rslt-q_bt1_2  = wa_mseg-menge + w_rslt-q_bt1_2.
            ELSEIF dspan BETWEEN 731 AND 1095.
              w_rslt-q_bt2_3  = wa_mseg-menge + w_rslt-q_bt2_3.
            ELSEIF dspan BETWEEN 1096 AND 1460.
              w_rslt-q_bt3_4  = wa_mseg-menge + w_rslt-q_bt3_4.
            ELSEIF dspan BETWEEN 1461 AND 1825.
              w_rslt-q_bt4_5  = wa_mseg-menge + w_rslt-q_bt4_5.
*            ELSE.
*              w_rslt-q_gt180      = wa_mseg-menge + w_rslt-q_gt180.
            ENDIF.

            w_rslt-totqty = w_rslt-totqty + wa_mseg-menge.
            CLEAR wa_mseg.
            ENDLOOP.

*          ENDIF.
          CLEAR wa_mkpf.
        ENDLOOP.
      ENDIF.
    ENDIF.
*  ENDIF.
ENDFORM.                    "GETSTOCKINFO

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_RESULTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RSLT     text
*----------------------------------------------------------------------*
FORM display_results USING p_rslt TYPE tt_result.

  ".....................................................
  DATA : l_columns    TYPE REF TO cl_salv_columns_table,
         l_column     TYPE REF TO cl_salv_column_table,
         o_selections TYPE REF TO cl_salv_selections,
         o_layout     TYPE REF TO cl_salv_layout,
         o_color      TYPE        lvc_s_colo,
         key          TYPE        salv_s_layout_key,
         lyot_txt     TYPE REF TO cl_salv_form_layout_grid,
         lyot_lbl     TYPE REF TO cl_salv_form_label,
         lyot_flow    TYPE REF TO cl_salv_form_layout_flow,

         wa_matnr     TYPE LINE OF rng_matnr,

         var_i        TYPE        i,
         line         TYPE        string
         .

  ".....................................................

  IF NOT p_rslt[] IS INITIAL.
    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = alv_obj
          CHANGING
            t_table      = p_rslt[].
      CATCH cx_salv_msg INTO lc_msg .
    ENDTRY.

    " ENABLE SAVE LAYOUT OPTION
    o_layout = alv_obj->get_layout( ).
    key-report = sy-repid.
    o_layout->set_key( key ).
    CALL METHOD o_layout->set_save_restriction
      EXPORTING
        value = if_salv_c_layout=>restrict_none.

    " ENABLE DEFAULT FUNCTIONS
    alv_fncts = alv_obj->get_functions( ).
    alv_fncts->set_all( abap_true ).

    " ENABLE ROW-SELCTION
    o_selections = alv_obj->get_selections( ).
    CALL METHOD o_selections->set_selection_mode
      EXPORTING
        value = 3.

    " HEADER TEXT (IN BOLD)
    CREATE OBJECT lyot_txt.
    var_i = 1.
*      LYOT_LBL = LYOT_TXT->CREATE_LABEL( ROW = VAR_I COLUMN = 1 TEXT = 'SELECTION CRITERIA : ').
*
*      IF NOT V_MATNR IS INITIAL.
*        VAR_I = VAR_I + 1.
*        LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
*        LYOT_FLOW->CREATE_TEXT( TEXT = 'MATERIAL(S) : ' ).
*
*        LOOP AT V_MATNR INTO WA_MATNR.
*          LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 2 ).
*          IF WA_MATNR-SIGN = 'E'.
*            LINE = 'EXCLUDING -'.
*          ELSE.
*            LINE = 'INCLUDING -'.
*          ENDIF.
*          IF WA_MATNR-HIGH IS INITIAL.
*            CONCATENATE LINE WA_MATNR-LOW INTO LINE SEPARATED BY SPACE.
*          ELSE.
*            CONCATENATE LINE WA_MATNR-LOW 'TO' WA_MATNR-HIGH INTO LINE SEPARATED BY SPACE.
*          ENDIF.
*          LYOT_FLOW->CREATE_TEXT( TEXT = LINE ).
*          VAR_I = VAR_I + 1.
*          CLEAR WA_MATNR.
*        ENDLOOP.
*      ENDIF.
*
*      VAR_I = VAR_I + 1.
*      LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
*      LYOT_FLOW->CREATE_TEXT( TEXT = 'PLANT : ' ).
*
*      LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 2 ).
*      LYOT_FLOW->CREATE_TEXT( TEXT = V_WERKS ).
*
*      VAR_I = VAR_I + 1.
    lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
    lyot_flow->create_text( text = 'DATE OF REPORT GENERATION : ' ).

    lyot_flow = lyot_txt->create_flow( row = var_i column = 2 ).
    lyot_flow->create_text( text = sy-datum ).

    alv_obj->set_top_of_list( lyot_txt ).


    " SET COLORS TO INDICATE COLUMN-GROUPS
    CLEAR : o_color, l_column, l_columns.
    l_columns = alv_obj->get_columns( ).

    o_color-col = 4.
    o_color-int = 1.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_LT30' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_LT30' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_LT30' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_LT30' ).
    l_column->set_color( o_color ).


    CLEAR : o_color, l_column.
    o_color-col = 3.
    o_color-int = 0.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_BT31_60' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_BT31_60' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_BT31_60' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_BT31_60' ).
    l_column->set_color( o_color ).


    CLEAR : o_color, l_column.
    o_color-col = 5.
    o_color-int = 0.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_BT61_90' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_BT61_90' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_BT61_90' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_BT61_90' ).
    l_column->set_color( o_color ).


    CLEAR : o_color, l_column.
    o_color-col = 7.
    o_color-int = 0.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_BT91_120' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_BT91_120' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_BT91_120' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_BT91_120' ).
    l_column->set_color( o_color ).


    CLEAR : o_color, l_column.
    o_color-col = 2.
    o_color-int = 1.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_BT121_150' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_BT121_150' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_BT121_150' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_BT121_150' ).
    l_column->set_color( o_color ).


    CLEAR : o_color, l_column.
    o_color-col = 6.
    o_color-int = 0.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_BT151_180' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_BT151_180' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_BT151_180' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_BT151_180' ).
    l_column->set_color( o_color ).

    CLEAR : o_color, l_column.
    o_color-col = 6.
    o_color-int = 0.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_BT181_365' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_BT181_365' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_BT181_365' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_BT181_365' ).
    l_column->set_color( o_color ).

    CLEAR : o_color, l_column.
    o_color-col = 6.
    o_color-int = 0.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_BT1_2' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_BT1_2' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_BT1_2' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_BT1_2' ).
    l_column->set_color( o_color ).


    CLEAR : o_color, l_column.
    o_color-col = 6.
    o_color-int = 0.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_BT2_3' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_BT2_3' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_BT2_3' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_BT2_3' ).
    l_column->set_color( o_color ).

    CLEAR : o_color, l_column.
    o_color-col = 6.
    o_color-int = 0.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_BT3_4' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_BT3_4' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_BT3_4' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_BT3_4' ).
    l_column->set_color( o_color ).


    CLEAR : o_color, l_column.
    o_color-col = 6.
    o_color-int = 0.
    o_color-inv = 0.
    l_column ?= l_columns->get_column( 'URQ_BT4_5' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_URQ_BT4_5' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'SOQ_BT4_5' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'V_SOQ_BT4_5' ).
    l_column->set_color( o_color ).


*    CLEAR : o_color, l_column.
*    o_color-col = 4.
*    o_color-int = 0.
*    o_color-inv = 0.
*    l_column ?= l_columns->get_column( 'URQ_GT180' ).
*    l_column->set_color( o_color ).
*    CLEAR : l_column.
*    l_column ?= l_columns->get_column( 'V_URQ_GT180' ).
*    l_column->set_color( o_color ).
*    CLEAR : l_column.
*    l_column ?= l_columns->get_column( 'SOQ_GT180' ).
*    l_column->set_color( o_color ).
*    CLEAR : l_column.
*    l_column ?= l_columns->get_column( 'V_SOQ_GT180' ).
*    l_column->set_color( o_color ).

    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'ZSERIES' ).
    l_column->set_color( o_color ).

    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'ZSIZE' ).
    l_column->set_color( o_color ).

    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'BRAND' ).
    l_column->set_color( o_color ).

    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'MOC' ).
    l_column->set_color( o_color ).

    CLEAR : l_column.
    l_column ?= l_columns->get_column( 'TYPE' ).
    l_column->set_color( o_color ).
    CLEAR : l_column.




*      ALV_FNCTS->SET_GROUP_AGGREGATION( ABAP_TRUE ).
*      ALV_FNCTS->SET_GROUP_EXPORT( ABAP_TRUE ).
*      ALV_FNCTS->SET_GROUP_FILTER( ABAP_TRUE ).
*      ALV_FNCTS->SET_GROUP_LAYOUT( ABAP_TRUE ).
*      ALV_FNCTS->SET_GROUP_SORT( ABAP_TRUE ).
*      ALV_FNCTS->SET_GROUP_SUBTOTAL( ABAP_TRUE ).
*      ALV_FNCTS->SET_GROUP_VIEW( ABAP_TRUE ).


*      L_COLUMNS = ALV_OBJ->GET_COLUMNS( ).
*      L_COLUMN ?= L_COLUMNS->GET_COLUMN( 'SPAN_LT30' ).
*      L_COLUMN->SET_LONG_TEXT( '<= 30 DAYS' ).
*      L_COLUMN->SET_MEDIUM_TEXT( '<= 30 DAYS' ).
*      L_COLUMN->SET_SHORT_TEXT( '<= 30 DAYS' ).
    ".....................................................
    l_columns->set_optimize( abap_true ).
    alv_obj->display( ).

    ELSE.
      MESSAGE 'No Record Exists For Given Selection' TYPE 'S' DISPLAY LIKE 'E'.

  ENDIF.

  IF p_down = 'X'.
      PERFORM download.
  ENDIF.

ENDFORM.                    "DISPLAY_RESULTS
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
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
*BREAK primus.
*if v_lgort is NOT INITIAL.
*IF 'RM01' in v_lgort .
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_FINAL
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZUSMATLINVAGRM01.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*  WRITE: / 'ZUSMATLINVAGRM01 Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*ENDIF.
*
*IF 'FG01' in v_lgort .
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_FINAL
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZUSMATLINVAGFG01.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*  WRITE: / 'ZUSMATLINVAGFG01 Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*ENDIF.
*
*IF 'TPI1' in v_lgort .
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_FINAL
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZUSMATLINVAGTPI1.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*  WRITE: / 'ZUSMATLINVAGTPI1 Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*ENDIF.
*
*IF 'RJ01' in v_lgort .
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_FINAL
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZUSMATLINVAGRJ01.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*  WRITE: / 'ZUSMATLINVAGRJ01 Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*ENDIF.
*
*IF 'RWK1' in v_lgort .
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_FINAL
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZUSMATLINVAGRWK1.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*  WRITE: / 'ZUSMATLINVAGRWK1 Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*ENDIF.
*
*IF 'SCR1' in v_lgort .
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_FINAL
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZUSMATLINVAGSCR1.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*  WRITE: / 'ZUSMATLINVAGSCR1 Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*ENDIF.
*
*IF 'SFG1' in v_lgort .
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_FINAL
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZUSMATLINVAGSFG1.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*  WRITE: / 'ZUSMATLINVAGSFG1 Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*ENDIF.
*
*IF 'VLD1' in v_lgort .
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_FINAL
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZUSMATLINVAGVLD1.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*  WRITE: / 'ZUSMATLINVAGVLD1 Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*ENDIF.
*
*IF 'SRN1' in v_lgort .
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_FINAL
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'ZUSMATLINVAGSRN1.TXT'.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*  WRITE: / 'ZUSMATLINVAGSRN1 Download started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
*ENDIF.
*else.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_FINAL
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
  lv_file = 'ZUS_INVAG_NEW.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.
  WRITE: / 'ZUS_INVAG_NEW.TXT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1954 TYPE string.
DATA lv_crlf_1954 TYPE string.
lv_crlf_1954 = cl_abap_char_utilities=>cr_lf.
lv_string_1954 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1954 lv_crlf_1954 wa_csv INTO lv_string_1954.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1954 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

*ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING pd_csv.
DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Material'
              'Description'
              'Plant'
              'Stor. Loc.'
              'Unit'
              'Rate'
              'Material Type'
              'Unrstr. Stc. (<= 30 Days)'
              'UR Stc. Value (<=30 Days)'
              'Sales Ordr. (<= 30 Days)'
              'SO Stc. Value (<=30 Days)'
              'Unrestricted Stc. (31-60 Days)'
              'UR Stc. Value (31-60 Days)'
              'Sales Ordr. (31-60 Days)'
              'SO Stc. Value (31-60 Days)'
              'Unrestricted Stc. (61-90 Days)'
              'UR Stc. Value (61-90 Days)'
              'Sales Ordr. (61-90 Days)'
              'SO Stc. Value (61-90 Days)'
              'Unrestricted Stc.(91-120 Days)'
              'UR Stc. Value (91-120 Days)'
              'Sales Ordr Stc. (91-120 Days)'
              'SO Stc. Value (91-120 Days)'
              'Unrestricted Stc(121-150 Days)'
              'UR Stc. Value (121-150 Days)'
              'Sales Ordr Stc. (121-150 Days)'
              'SO Stc. Value (121-150 Days)'
              'Unrestricted Stc(151-180 Days)'
              'UR Stc. Value (151-180 Days)'
              'Sales Ordr Stc. (151-180 Days)'
              'SO Stc. Value (151-180 Days)'

              'Unrestricted Stc(181-365 Days)'
              'UR Stc. Value (181-365 Days)'
              'Sales Ordr Stc. (181-365 Days)'
              'SO Stc. Value (181-365 Days)'

              'Unrestricted Stc(1-2 Year)'
              'UR Stc. Value (1-2 Year)'
              'Sales Ordr Stc. (1-2 Year)'
              'SO Stc. Value (1-2 Year)'

              'Unrestricted Stc(2-3 Year)'
              'UR Stc. Value (2-3 Year)'
              'Sales Ordr Stc. (2-3 Year)'
              'SO Stc. Value (2-3 Year)'

              'Unrestricted Stc(3-4 Year)'
              'UR Stc. Value (3-4 Year)'
              'Sales Ordr Stc. (3-4 Year)'
              'SO Stc. Value (3-4 Year)'

              'Unrestricted Stc(4-5 Year)'
              'UR Stc. Value (4-5 Year)'
              'Sales Ordr Stc. (4-5 Year)'
              'SO Stc. Value (4-5 Year)'


              'UR Total Quantity'
              'UR Total Value'
              'SO Total Quantity'
              'SO Total Value'
              'series code'
              'size'
              'Brand'
              'MOC'
              'Type'
              'USA Code'
              'Refresh Date'
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
