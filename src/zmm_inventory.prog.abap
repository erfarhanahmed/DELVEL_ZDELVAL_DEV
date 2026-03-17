*&---------------------------------------------------------------------*
*& Report ZMM_INVENTORY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_inventory MESSAGE-ID zdel.

TYPES : BEGIN OF t_mara,
          matnr   TYPE matnr,     " Material Number
          meins	  TYPE meins,     "	Base Unit of Measure
          mtart   TYPE mtart,
          zseries TYPE zser_code, "	series code
          zsize	  TYPE zsize,     "	Size
          brand	  TYPE zbrand,                              "	Brand1
          moc	    TYPE zmoc,      "	MOC
          type    TYPE ztyp,      " Type
        END OF t_mara,

        BEGIN OF t_marc,
          matnr	TYPE matnr,     "	Material Number
          werks	TYPE werks_d,   "	Plant
          eisbe	TYPE eisbe,     "	Safety Stock
*          BSTMI   TYPE BSTMI,    " Minimum Lot Size
        END OF t_marc,

        tt_marc TYPE TABLE OF t_marc,

        BEGIN OF t_makt,
          matnr TYPE matnr,     " Material Number
          maktx TYPE maktx,     " Material Description (Short Text)
        END OF t_makt,

        BEGIN OF t_mbew,
          matnr	TYPE matnr,     " Material Number
          bwkey	TYPE bwkey,     "	Valuation Area
          vprsv TYPE vprsv,     " Price Control Indicator
          verpr TYPE verpr,      "  Moving Average Price/Periodic Unit Price
          stprs	TYPE stprs,	          " Standard price
        END OF t_mbew,

        BEGIN OF t_mslb,
          matnr TYPE matnr  ,     " Material Number
          "WERKS  TYPE WERKS_D,   " Plant
          lblab TYPE labst  ,     " Valuated Unrestricted-Use Stock
        END OF t_mslb,

        tt_mslb TYPE TABLE OF t_mslb,

        BEGIN OF t_ekpo,
          ebeln  TYPE ebeln,     "  Purchasing Document Number
          ebelp  TYPE ebelp,     "  Item Number of Purchasing Document
          matnr  TYPE matnr,     " Material Number
          menge  TYPE bstmg,     " Purchase Order Quantity
          pndmng TYPE bstmg,     " Quantity of Goods Received
        END OF t_ekpo,

        tt_ekpo TYPE TABLE OF t_ekpo,

        BEGIN OF t_eket,
          ebeln	TYPE ebeln,     "	Purchasing Document Number
          ebelp	TYPE ebelp,     "	Item Number of Purchasing Document
          wemng	TYPE weemg,     "	Quantity of Goods Received
        END OF t_eket,

        BEGIN OF t_mseg,
          mblnr	     TYPE mblnr,     " Number of Material Document
          mjahr      TYPE mjahr,
          zeile      TYPE mblpo,
          bwart      TYPE bwart,     "  Movement Type (Inventory Management)
          matnr      TYPE matnr,
          menge      TYPE menge_d,   "  Quantity
          smbln      TYPE mblnr,     "  Number of Material Document
          budat_mkpf TYPE budat,
        END OF t_mseg,

        BEGIN OF t_mseg1,
          mblnr	TYPE string, "mblnr,     " Number of Material Document
          mjahr TYPE string, "mjahr,
          matnr TYPE string,
          menge	TYPE menge_d,   "	Quantity
*          smbln  TYPE mblnr,     " Number of Material Document
        END OF t_mseg1,


        BEGIN OF t_mkpf,
          mblnr	TYPE mblnr,     "	Number of Material Document
          mjahr TYPE mjahr,
*          cpudt    TYPE cpudt,   " Day On Which Accounting Document Was Entered
          budat TYPE budat,     " Posting Date in the Document
          dspan TYPE int4,
        END OF t_mkpf,

        BEGIN OF t_afpo,
          aufnr	TYPE aufnr,       " Order Number
          psmng TYPE co_psmng,    " Order item quantity
          wemng TYPE co_wemng,    " Quantity of goods received for the order item
          matnr	TYPE co_matnr,    "	Material Number for Order
        END OF t_afpo,

        BEGIN OF t_moq,
          matnr TYPE matnr,       " Material Number
          minbm TYPE minbm,       " Minimum Order Quantity
        END OF t_moq,

        BEGIN OF t_mard,
          matnr	TYPE matnr,     "	Material Number
          lgort TYPE lgort_d,   " Storage Location
          labst TYPE labst,      "  Valuated Unrestricted-Use Stock
          insme	TYPE insme,     "	Stock in Quality Inspection
          speme TYPE speme,
          diskz type mard-diskz,
        END OF t_mard,

        BEGIN OF t_result,
          werks      TYPE werks_d,  " Plant
          matnr      TYPE matnr,     " Material Number
          maktx      TYPE maktx,     " Material Description (Short Text)
          meins      TYPE meins,     " Base Unit of Measure
*          BSTMI   TYPE ZBSTMI,   " Minimum Order Quantity
          minbm      TYPE minbm,     "  EINE-MINBM : Minimum PO Quantity
          totreq     TYPE menge_d,   " Total requirement                      changes subodh 23 feb 2018
          sbcntr     TYPE zsbcntrstk, " Subcontractor Stock
*****          lgort      TYPE mard-lgort,
          mtart      TYPE mara-mtart,
          ".........................................................
          sl1        TYPE menge_d,   " UR stock at storg. Loc. SL01
          sl2        TYPE menge_d,   " UR stock at storg. Loc. SL02
*****          sl3        TYPE menge_d,   " UR stock at storg. Loc. SL03
          sl4        TYPE menge_d,   " UR stock at storg. Loc. SL04
          sl5        TYPE menge_d,   " UR stock at storg. Loc. SL05
          sl6        TYPE menge_d,   " UR stock at storg. Loc. SL06
*****          sl7        TYPE menge_d,   " UR stock at storg. Loc. SL07
          sl8        TYPE menge_d,   " UR stock at storg. Loc. SL08
          sl9        TYPE menge_d,   " UR stock at storg. Loc. SL09
          sl10       TYPE menge_d,   " UR stock at storg. Loc. SL10
          sl11       TYPE menge_d,   " UR stock at storg. Loc. SL11
          sl12       TYPE menge_d,   " UR stock at storg. Loc. SL12
          sl13       TYPE menge_d,   " UR stock at storg. Loc. SL13
          sl14       TYPE menge_d,   " UR stock at storg. Loc. SL14
          sl15       TYPE menge_d,   " UR stock at storg. Loc. SL14
          sl16       TYPE menge_d,   " UR stock at storg. Loc. SL14
          sl17       TYPE menge_d,   " UR stock at storg. Loc. SL14
*-----------------------Commented By Abhishek Pisolkar (06.04.2018)------------------
*          sl14       TYPE menge_d,   " UR stock at storg. Loc. SL14
*          sl15       TYPE menge_d,   " UR stock at storg. Loc. SL15
*          sl16       TYPE menge_d,   " UR stock at storg. Loc. SL16
*          sl17       TYPE menge_d,   " UR stock at storg. Loc. SL17
*          sl18       TYPE menge_d,   " UR stock at storg. Loc. SL18
*          sl19       TYPE menge_d,   " UR stock at storg. Loc. SL19
*          sl20       TYPE menge_d,   " UR stock at storg. Loc. SL20
*          sl21       TYPE menge_d,   " UR stock at storg. Loc. SL21
*          sl22       TYPE menge_d,   " UR stock at storg. Loc. SL22
*          sl23       TYPE menge_d,   " UR stock at storg. Loc. SL23
*          sl24       TYPE menge_d,   " UR stock at storg. Loc. SL24
*          sl25       TYPE menge_d,   " UR stock at storg. Loc. SL25
*          sl26       TYPE menge_d,   " UR stock at storg. Loc. SL26
*          sl27       TYPE menge_d,   " UR stock at storg. Loc. SL27
*          sl28       TYPE menge_d,   " UR stock at storg. Loc. SL28
*          sl29       TYPE menge_d,   " UR stock at storg. Loc. SL29
*          sl30       TYPE menge_d,   " UR stock at storg. Loc. SL30
*--------------------------------------------------------------------*
          ".........................................................
          unrst      TYPE zunrst,    "  Unrestricted Stock
          insme      TYPE insme,     "  Stock in Quality Inspection
          totstck    TYPE menge_d,   " Total stock
          "STKQTY  TYPE ZSTCK,    " Stock Quantity
          sfqty      TYPE eisbe,     " Safety Stock
          frinv      TYPE menge_d,   " Free Inventory
          zrate      TYPE zrate,     " Rate

*          SOSTC   TYPE MC_MKABEST," Total sales order stock
*          REQQTY  TYPE BMENGE,    " Required Quantity
*          WIPQTY  TYPE ZWIPQTY,   " WIP Stock

*          FRQTY   TYPE ZFRQTY,    " Free Quantity
          "................................................................
          lt30       TYPE zlt30,
          vlt30      TYPE zprice,
          bt30_60    TYPE zbt30_60,
          vbt30_60   TYPE zprice,
          bt60_90    TYPE zbt60_90,
          vbt60_90   TYPE zprice,
          bt90_120   TYPE zbt90_120,
          vbt90_120  TYPE zprice,
          bt120_150  TYPE zbt120_150,
          vbt120_150 TYPE zprice,
          bt150_180  TYPE zbt150_180,
          vbt150_180 TYPE zprice,
          gt180      TYPE zgt180,
          vgt180     TYPE zprice,
          "................................................................
          value      TYPE zprice,
          zseries    TYPE zser_code, " series code
          zsize      TYPE zsize,     " Size
          brand      TYPE zbrand,                              " Brand1
          moc        TYPE zmoc,      " Three-digit character field for IDocs
          type       TYPE ztyp,      " Three-digit character field for IDocs
*          ref_date TYPE string,         " Added By Abhishek Pisolkar (22.03.2018)
          budat_mkpf TYPE string, "budat, " added by md
          speme      TYPE speme,
        END OF t_result,

        tt_result TYPE TABLE OF t_result,

        BEGIN OF t_sl_col,
          lgort TYPE lgort_d,
          col   TYPE char4,
        END OF t_sl_col,

        rng_matnr TYPE RANGE OF matnr,
        so_matnr  TYPE TABLE OF rng_matnr,
        rng_werks TYPE RANGE OF werks_d,
        rng_datum TYPE RANGE OF sy-datum,
        rng_lgort TYPE RANGE OF lgort_d,
        rng_mtart TYPE RANGE OF mtart.

DATA : wa_rslt TYPE t_result,
       it_rslt TYPE tt_result,
       ss      TYPE string.

FIELD-SYMBOLS : <fs> TYPE any.

DATA : lc_msg    TYPE REF TO cx_salv_msg,
       alv_obj   TYPE REF TO cl_salv_table,
       alv_fncts TYPE REF TO cl_salv_functions_list.
DATA : lv_tabix TYPE sy-index.

DATA : wa_mara      TYPE t_mara,
       wa_marc      TYPE t_marc,
       wa_makt      TYPE t_makt,
       wa_mbew      TYPE t_mbew,
       "wa_rslt TYPE t_result,
       wa_mdps      TYPE mdps,
       wa_mseg      TYPE t_mseg,
       wa_mkpf      TYPE t_mkpf,
       wa_afpo      TYPE t_afpo,
       wa_mslb      TYPE t_mslb,
       wa_ekpo      TYPE t_ekpo,
       wa_moq       TYPE t_moq,
       wa_mard      TYPE t_mard,
       wa_sl_col    TYPE t_sl_col,

       it_mara      TYPE TABLE OF t_mara,
       it_marc      TYPE TABLE OF t_marc,
       it_makt      TYPE TABLE OF t_makt,
       it_mbew      TYPE TABLE OF t_mbew,
       it_mdps      TYPE TABLE OF mdps,
       it_mseg      TYPE TABLE OF t_mseg,
       it_mseg1     TYPE TABLE OF t_mseg,
       it_mkpf      TYPE TABLE OF t_mkpf,
       it_afpo      TYPE TABLE OF t_afpo,
       "IT_mslb_tmp TYPE TABLE OF T_mslb,
       it_mslb      TYPE TABLE OF t_mslb,
       it_ekpo      TYPE TABLE OF t_ekpo,
       it_moq_tmp   TYPE TABLE OF t_moq,
       it_moq       TYPE TABLE OF t_moq,
       it_mard      TYPE TABLE OF t_mard,
       it_sl_col    TYPE TABLE OF t_sl_col,
       it_mseg3     TYPE TABLE OF t_mseg1,
       it_mseg4     TYPE TABLE OF t_mseg1,
       it_mseg_temp TYPE TABLE OF t_mseg,
       wa_mseg_temp TYPE t_mseg.

DATA : tmp_qty TYPE menge_d,
       dspan   TYPE int4.
DATA : ls_mseg3 TYPE t_mseg1.
********************************************Structure For Download file************************************
*-------------------------------Added By AG DT:19.02.2018-------------------------------------------------
TYPES : BEGIN OF itab,
          werks      TYPE string, "char20,
          matnr      TYPE string, "char100,
          maktx      TYPE string, "char20,
          meins      TYPE string, "char20,
          minbm      TYPE string, "char20,
          totreq     TYPE string, "char50,
          sbcntr     TYPE string, "char20,
****        lgort      TYPE string,"CHAR15,        // date 06-june-2018 Parag nakhate
          mtart      TYPE string, "CHAR50,
          sl1        TYPE string, "CHAR50,             "'FINISHED GOODS'
          sl2        TYPE string, "CHAR50,             "'PRODUCTION'
*          sl3        TYPE string, "CHAR70,             "'REJECTION'
          sl4        TYPE string, "CHAR15,             "'RAW MATERIALS'
          sl5        TYPE string, "CHAR50,             "'REWORK'
          sl6        TYPE string, "CHAR15,             "'Subcon Stk Loc'
*          sl7        TYPE string, "CHAR50,             "'SCRAP'
          sl8        TYPE string, "CHAR10,             "FG Sales Return
          sl9        TYPE string, "CHAR10,             "''WIP ASSEMBLED''
          sl10       TYPE string, "CHAR20,             "'SPARES & CONSUM'
          sl11       TYPE string, "CHAR15,             "'SRN STORES'
          sl12       TYPE string, "CHAR5,              "'THIRD PARTY INSP'
          sl13       TYPE string, "CHAR50,             "'VALIDATION'
          sl14       TYPE string, "CHAR50,             "'QA OK STOCK SL'
          sl15       TYPE string, "CHAR50,             "'Planning'
*----------Commented By Abhishek Pisolkar (06.04.2018)-------------
*        sl14       TYPE string,"CHAR50,
*        sl15       TYPE string,"CHAR250,
*        sl16       TYPE string,"CHAR10,
*        sl17       TYPE string,"CHAR15,
*        sl18       TYPE string,"CHAR20,
*        sl19       TYPE string,"CHAR100,
*        sl20       TYPE string,"CHAR100,
*        sl21       TYPE string,"CHAR50,
*        sl22       TYPE string,"CHAR10,
*        sl23       TYPE string,"CHAR50,
*        sl24       TYPE string,"CHAR50,
*        sl25       TYPE string,"CHAR15,
*        sl26       TYPE string,"CHAR15,
*        sl27       TYPE string,"CHAR10,
*        sl28       TYPE string,"CHAR10,
*        sl29       TYPE string,"CHAR50,
*        sl30       TYPE string,"CHAR10,
*--------------------------------------------------------------------*
          unrst      TYPE string, "CHAR10,
          insme      TYPE string, "CHAR10,
          totstck    TYPE string, "CHAR50,
          sfqty      TYPE string, "CHAR10,
          frinv      TYPE string, "CHAR50,
          zrate      TYPE string, "CHAR50,
          lt30       TYPE string, "CHAR10,
          vlt30      TYPE string, "CHAR10,
          bt30_60    TYPE string, "CHAR10,
          vbt30_60   TYPE string, "CHAR20,
          bt60_90    TYPE string, "CHAR80,
          vbt60_90   TYPE string, "CHAR50,
          bt90_120   TYPE string, "CHAR50,
          vbt90_120  TYPE string, "CHAR50,
          bt120_150  TYPE string, "CHAR50,
          vbt120_150 TYPE string, "CHAR80,
          bt150_180  TYPE string, "CHAR80,
          vbt150_180 TYPE string, "CHAR80,
          gt180      TYPE string, "CHAR10,
          vgt180     TYPE string, "CHAR50,
          value      TYPE string, "CHAR10,
          zseries    TYPE string, "CHAR50,
          zsize      TYPE string, "CHAR10,
          brand      TYPE string, "CHAR20,
          moc        TYPE string, "CHAR15,
          type       TYPE string, "CHAR15,
          ref        TYPE string, "CHAR15,
          budat_mkpf TYPE string,
          speme      TYPE string,
          sl16       TYPE string, "CHAR50,             "'Planning'
          sl17       TYPE string, "CHAR50,             "'Planning'
        END OF itab.

DATA : lt_final TYPE TABLE OF itab,
       ls_final TYPE itab.
*--------------------Added By Abhishek Pisolkar (06.04.2018)-----------------------------------
DATA : it_fldcat TYPE slis_t_fieldcat_alv,
       wa_fldcat TYPE slis_fieldcat_alv,
       wa_layout TYPE slis_layout_alv,
       it_event  TYPE slis_t_event,
       wa_event  TYPE slis_alv_event.
*----------------------------------------------------------------------------------------------

INITIALIZATION.
  "SET PF-STATUS 'ZMM_FRINV_STAT1'.
  CLEAR : wa_mara, wa_marc, wa_makt, wa_mbew, wa_mdps, wa_mslb,
          wa_rslt, tmp_qty, wa_mseg, wa_mkpf, wa_afpo, dspan,
          wa_ekpo, wa_moq, wa_mard, wa_sl_col.
  REFRESH : it_mara, it_marc, it_makt, it_mbew, it_mdps, it_ekpo,
            it_mseg, it_mkpf, it_afpo, it_mslb, it_moq, it_mard,
            it_sl_col.


  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS v_matnr FOR wa_rslt-matnr.
  PARAMETERS v_werks TYPE werks_d OBLIGATORY.
*  SELECT-OPTIONS v_lgort FOR wa_rslt-lgort NO INTERVALS.
  SELECT-OPTIONS v_mtart FOR wa_rslt-mtart.
  "SELECT-OPTIONS V_DATE FOR SY-DATUM  OBLIGATORY.
  SELECTION-SCREEN END OF BLOCK b1.

  SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT  '/Delval/India'."India'."temp'. "'C:\Users\user\Desktop\Delval'.
  SELECTION-SCREEN : END OF BLOCK b2.

  SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-010.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-011.
  SELECTION-SCREEN: END OF BLOCK B3.

AT SELECTION-SCREEN .
  IF v_mtart IS INITIAL.
    MESSAGE 'Please Enter Material Type' TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN ON v_matnr.
  IF NOT v_matnr-low IS INITIAL.
    SELECT SINGLE matnr
      FROM mara
      INTO wa_rslt-matnr
    WHERE matnr = v_matnr-low.
    IF sy-subrc <> 0.
      MESSAGE e011 WITH TEXT-002.
    ENDIF.
  ENDIF.
  IF NOT v_matnr-high IS INITIAL.
    SELECT SINGLE matnr
      FROM mara
      INTO wa_rslt-matnr
    WHERE matnr = v_matnr-high.
    IF sy-subrc <> 0.
      MESSAGE e011 WITH TEXT-002.
    ENDIF.
  ENDIF.

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
                   v_werks
*                   v_lgort[]                                              " 25/05/2018
                   v_mtart[]
                   "V_DATE[]
             CHANGING it_rslt.

  IF NOT it_rslt[] IS INITIAL.
*-----------------------Commented by Abhishek Pisolkar (06.04.2018)----------------
*    PERFORM generate_alv USING it_rslt[] CHANGING alv_obj.
*    PERFORM set_header USING v_matnr[]
*                             v_werks
*                             "V_DATE[]
*                             alv_obj.
*    alv_obj->display( ).
*--------------------------------------------------------------------*
*----------------Added By Abhishek Pisolkar (06.04.2018)-------------
    PERFORM fieldcat.
    IF  p_down = 'X'.
      PERFORM download.
      PERFORM gui_download.
    ENDIF.
    PERFORM display.
*--------------------------------------------------------------------*
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR    text
*      -->P_WERKS    text
*      -->P_RSLT     text
*----------------------------------------------------------------------*
FORM get_data USING p_matnr TYPE rng_matnr
                    p_werks TYPE werks_d
*                    p_lgort TYPE rng_lgort                       " 25/05/2018
                    p_mtart TYPE rng_mtart
                   "P_DATE  TYPE RNG_DATUM
                 CHANGING p_rslt TYPE tt_result.
  CLEAR p_rslt.
  " Get Material-Plant info

*BREAK-POINT.
  SELECT matnr
           lgort
           labst
           insme
           speme
           diskz  "Added by jyoti on 01.07.2024
      FROM mard
      INTO TABLE it_mard
  WHERE matnr IN p_matnr AND werks = p_werks
    and diskz NE '1'. "ADDED BY JYOTI ON 01.07.2024
    " AND lgort IN p_lgort.            " 25/05/2018
*      FOR ALL ENTRIES IN it_marc
*      WHERE matnr = it_marc-matnr
*        AND werks = it_marc-werks AND lgort IN p_lgort.

  SELECT matnr
         werks
         eisbe
*           BSTMI
      FROM marc
      INTO TABLE it_marc
      FOR ALL ENTRIES IN it_mard
  WHERE matnr = it_mard-matnr AND matnr IN p_matnr AND werks = p_werks.

  IF sy-subrc = 0.

    " Get Material Details
    SELECT matnr
         meins
         mtart
         zseries
         zsize
         brand
         moc
         type
    FROM mara
    INTO TABLE it_mara
    FOR ALL ENTRIES IN it_marc
    WHERE mtart IN p_mtart AND matnr = it_marc-matnr.

    " get Material Texts
    SELECT matnr
           maktx
      FROM makt
      INTO TABLE it_makt
      FOR ALL ENTRIES IN it_mara
      WHERE matnr = it_mara-matnr
    AND spras = sy-langu.

    " Get respective Min.Order Quantities
    SELECT matnr
           minbm
      INTO TABLE it_moq_tmp
      FROM eina
      JOIN eine ON eine~infnr = eina~infnr
      FOR ALL ENTRIES IN it_marc
      WHERE matnr = it_marc-matnr
        "and WERKS = it_marc-werks
    .
    IF sy-subrc = 0.
      SORT it_moq BY matnr minbm DESCENDING.
      LOOP AT it_moq_tmp INTO wa_moq.
        APPEND wa_moq TO it_moq.
        DELETE it_moq_tmp WHERE matnr = wa_moq-matnr.
      ENDLOOP.
      IF it_moq IS NOT INITIAL.
        SORT it_moq BY matnr.
      ENDIF.
    ENDIF.

    " Fetch Rate related Info
    SELECT matnr
           bwkey
           vprsv
           verpr
           stprs
      FROM mbew
      INTO TABLE it_mbew
      FOR ALL ENTRIES IN it_marc
      WHERE matnr = it_marc-matnr
    AND bwkey = it_marc-werks.

    " Get subcontractor-stock details
    PERFORM get_subcontract_stock TABLES it_marc it_mslb it_ekpo.

    " Get Unrestricted stock Details
*    SELECT matnr
*           lgort
*           labst
*           insme
*      FROM mard
*      INTO TABLE it_mard
*      FOR ALL ENTRIES IN it_marc
*      WHERE matnr = it_marc-matnr
*        AND werks = it_marc-werks AND lgort IN p_lgort.
*    IF sy-subrc = 0.
    DELETE it_mard WHERE lgort CS 'RJ0' OR lgort CS 'SCR' OR lgort CS 'SRN' OR lgort CS 'VLD'.
    LOOP AT it_mard INTO wa_mard.
      CLEAR wa_sl_col.
      wa_sl_col-lgort = wa_mard-lgort.
      APPEND wa_sl_col TO it_sl_col.
      CLEAR : wa_mard.
    ENDLOOP.
    IF it_sl_col IS NOT INITIAL.
      SORT it_sl_col BY lgort.
      DELETE ADJACENT DUPLICATES FROM it_sl_col COMPARING ALL FIELDS.
    ENDIF.
    SORT it_mard BY matnr lgort.
  ENDIF.
*BREAK primus.
  " Prepare results
  LOOP AT it_mara INTO wa_mara.
    wa_rslt-matnr   = wa_mara-matnr.
    wa_rslt-meins   = wa_mara-meins.
    wa_rslt-mtart   = wa_mara-mtart.                       " add subodh 22 feb 2018
    wa_rslt-zseries = wa_mara-zseries.
    wa_rslt-zsize   = wa_mara-zsize.
    wa_rslt-brand   = wa_mara-brand.
    wa_rslt-moc     = wa_mara-moc.
    wa_rslt-type    = wa_mara-type.

    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc = 0.
*      Replace all OCCURRENCES OF CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB in wa_makt-maktx with space.
      IF wa_makt-maktx CS '#'.
        CONCATENATE space wa_makt-maktx INTO wa_rslt-maktx RESPECTING BLANKS.
*      wa_rslt-maktx = wa_makt-maktx.
      ELSE.
        wa_rslt-maktx = wa_makt-maktx.
      ENDIF.
      wa_rslt-maktx = wa_makt-maktx.
    ENDIF.

    LOOP AT it_marc INTO wa_marc WHERE matnr = wa_mara-matnr..
      wa_rslt-werks = wa_marc-werks.
*            WA_RSLT-BSTMI = WA_MARC-BSTMI.

      " Minimum Order Quantity
      READ TABLE it_moq INTO wa_moq WITH KEY matnr = wa_marc-matnr.
      IF sy-subrc = 0.
        wa_rslt-minbm = wa_moq-minbm.
      ENDIF.

      " Rate
      READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_mara-matnr
                                               bwkey = wa_marc-werks.
      IF sy-subrc = 0.
        IF wa_mbew-vprsv = 'V'.
          wa_rslt-zrate = wa_mbew-verpr.
        ELSEIF wa_mbew-vprsv = 'S'.
          wa_rslt-zrate = wa_mbew-stprs.
        ENDIF.
      ENDIF.

      " Total Requirement
      REFRESH it_mdps.
      IF NOT wa_rslt-werks IS INITIAL.
        CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
          EXPORTING
            matnr                    = wa_rslt-matnr
            werks                    = wa_rslt-werks
          TABLES
            mdpsx                    = it_mdps
          EXCEPTIONS
            material_plant_not_found = 1
            plant_not_found          = 2
            OTHERS                   = 3.
        IF sy-subrc <> 0.
*                MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ELSEIF NOT it_mdps[] IS INITIAL.
          LOOP AT it_mdps INTO wa_mdps.
            IF wa_mdps-delkz = 'VC' OR wa_mdps-delkz = 'SB'
              OR wa_mdps-delkz = 'U1' OR wa_mdps-delkz = 'U2'
              OR wa_mdps-delkz = 'PP'
              OR ( wa_mdps-delkz = 'BB' AND wa_mdps-plaab <> 26 )
              OR ( wa_mdps-delkz = 'AR' AND wa_mdps-plumi <> '+' ).
              wa_rslt-totreq = wa_rslt-totreq + wa_mdps-mng01.
            ENDIF.
            CLEAR wa_mdps.
          ENDLOOP.
        ENDIF.
      ENDIF.

      " Subcontractor stock
      READ TABLE it_mslb INTO wa_mslb WITH KEY matnr = wa_marc-matnr.
      IF sy-subrc = 0.
        wa_rslt-sbcntr = wa_mslb-lblab.
      ENDIF.

      LOOP AT it_ekpo INTO wa_ekpo WHERE matnr = wa_marc-matnr.
        wa_rslt-sbcntr = wa_rslt-sbcntr + wa_ekpo-pndmng.
        CLEAR wa_ekpo.
      ENDLOOP.
*-----------------------------------Added By Abhishek Pisolkar (04.04.2018)----------------
*      data : lv_lines TYPE i.
**      DESCRIBE TABLE it_mard LINES lv_lines.
*      LOOP AT it_mard INTO wa_mard WHERE matnr = wa_marc-matnr.
*      lv_lines = lv_lines + 1.
*      ENDLOOP.
*      if lv_lines > 1.
*      LOOP AT it_mard INTO wa_mard WHERE matnr = wa_marc-matnr and labst <> ' '.
**        if .
*        wa_rslt-lgort = wa_mard-lgort.
*        clear wa_mard.
**        ELSE.
**          wa_rslt-lgort = wa_mard-lgort.
**          ENDIF.
*       endloop.
*        ELSE.
*          READ TABLE it_mard INTO wa_mard WITH key matnr = wa_marc-matnr.
*          IF sy-subrc = 0.
*          wa_rslt-lgort = wa_mard-lgort.
*          CLEAR wa_mard.
*          ENDIF.
*        ENDIF.
*        clear lv_lines.
*--------------------------------------------------------------------*
      LOOP AT it_mard INTO wa_mard WHERE matnr = wa_marc-matnr.
*****        wa_rslt-lgort = wa_mard-lgort.                                            " add subodh 22 feb 2018

        " Unrestricted Stock
        CLEAR ss.
        READ TABLE it_sl_col INTO wa_sl_col WITH KEY lgort = wa_mard-lgort.
*--------------Commented by Abhishek Pisolkar (06.04.2018)------------
*        ss = sy-tabix."sy-index.
*        "concatenate 'WA_RSLT-SL' wa_mard-lgort into ss.
*        CONCATENATE 'WA_RSLT-SL' ss INTO ss.
*        ASSIGN (ss) TO <fs>.
*        <fs> = wa_mard-labst.
*--------------------------------------------------------------------*
*--------------------Added By Abhishek Pisolkar (06.04.2018)-------------
        IF wa_sl_col-lgort = 'FG01'.           " Finished Goods
          wa_rslt-sl1 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'PRD1'.       " Production
          wa_rslt-sl2 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'RJ01'.      " Rejection
*****          wa_rslt-sl3 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'RM01'.      " Raw Materials
          wa_rslt-sl4 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'RWK1'.      " Rework
          wa_rslt-sl5 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'SC01'.      " Subcon
          wa_rslt-sl6 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'SCR1'.      " Scrap
*****          wa_rslt-sl7 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'SFG1'.      " WIP assembled
          wa_rslt-sl8 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'SLR1'.      " FG Sales Return
          wa_rslt-sl9 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'SPC1'.      " Spares & Consum
          wa_rslt-sl10 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'SRN1'.      " SRN Stores
*****          wa_rslt-sl11 = wa_mard-labst.  commented to exclude SRN1 storage location
        ELSEIF wa_sl_col-lgort = 'TPI1'.      " Third Party
          wa_rslt-sl12 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'VLD1'.      " Validation
*****          wa_rslt-sl13 = wa_mard-labst.  "commented to exclude VLD1 storage location
        ELSEIF wa_sl_col-lgort = 'TR01'.      " QA OK STOCK SL            " 25/05/2018
          wa_rslt-sl14 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'PLG1'.      " Planning            " 25/05/2018
          wa_rslt-sl15 = wa_mard-labst.
        ELSEIF wa_sl_col-lgort = 'SAN1'.      " Planning            " 25/05/2018
          wa_rslt-sl16 = wa_mard-labst.
         ELSEIF wa_sl_col-lgort = 'MCN1'.      " Planning            " 25/05/2018
          wa_rslt-sl17 = wa_mard-labst.
        ENDIF.
*--------------------------------------------------------------------*

        wa_rslt-unrst = wa_rslt-unrst + wa_mard-labst.
        wa_rslt-speme = wa_rslt-speme + wa_mard-speme.
        UNASSIGN <fs>.

        " Stock in Quality Inspection
        wa_rslt-insme = wa_rslt-insme + wa_mard-insme.
        CLEAR wa_mard.
      ENDLOOP. "(05.04.2018)

      " Total Stock
      wa_rslt-totstck = wa_rslt-sbcntr + wa_rslt-unrst + wa_rslt-insme.

      " Safety Stock
      wa_rslt-sfqty = wa_marc-eisbe.

      " Free Inventory
      wa_rslt-frinv = wa_rslt-totstck - wa_rslt-totreq.

      IF wa_rslt-frinv > 0.
        " Value
        wa_rslt-value = wa_rslt-zrate * wa_rslt-frinv.

        " Free Stock Aging
        SELECT mblnr
               mjahr
               zeile
               bwart
               matnr
               menge
               smbln
               budat_mkpf
          FROM mseg
          INTO TABLE it_mseg
          WHERE bwart IN ('101', '102', '561', '562' ,'531' ,'532',  '309' ,'311','411','412','501','653','701', 'Z11' ,'542','262',
          '602','301','413','344','Z42','202','343','312','544','166' )
              AND werks = wa_rslt-werks
        AND matnr = wa_rslt-matnr.
        IF sy-subrc = 0.
          SORT it_mseg BY mblnr DESCENDING.
          LOOP AT it_mseg INTO wa_mseg WHERE bwart = '102' OR bwart = '562' OR bwart = '532'
         OR bwart = '122' OR bwart = '161' OR bwart = '162'  OR bwart = '202' OR bwart = '261'
   OR bwart = '312' OR bwart = '322'  OR bwart = '532' OR bwart = '543' OR bwart = '562' OR bwart = '602' OR bwart = '702' OR bwart = '541'.
            DELETE it_mseg WHERE mblnr = wa_mseg-smbln OR mblnr = wa_mseg-mblnr.
          ENDLOOP.
          IF NOT it_mseg[] IS INITIAL.
***            SORT it_mseg BY mblnr mjahr DESCENDING.
            CLEAR tmp_qty.
            tmp_qty = wa_rslt-frinv.

            LOOP AT it_mseg INTO DATA(ls_mseg2).
              ls_mseg3-mblnr = ls_mseg2-mblnr.
              ls_mseg3-mjahr = ls_mseg2-mjahr.
              ls_mseg3-matnr = ls_mseg2-matnr.
              ls_mseg3-menge = ls_mseg2-menge.
*             ls_mseg3-budat_mkpf = ls_mseg2-budat_mkpf.
              APPEND ls_mseg3 TO it_mseg3.
            ENDLOOP.

            SORT it_mseg3 BY mblnr mjahr matnr DESCENDING.
            LOOP AT it_mseg3 INTO ls_mseg3.
              COLLECT ls_mseg3 INTO it_mseg4.
            ENDLOOP.
            FIELD-SYMBOLS : <f1> TYPE t_mseg.

            DELETE ADJACENT DUPLICATES FROM it_mseg COMPARING mblnr mjahr.

            LOOP AT it_mseg ASSIGNING  <f1> .
              READ TABLE it_mseg4 INTO ls_mseg3 WITH KEY mblnr = <f1>-mblnr mjahr = <f1>-mjahr matnr = <f1>-matnr.
              IF sy-subrc = 0.
                <f1>-menge = ls_mseg3-menge.
              ENDIF.
            ENDLOOP.


            LOOP AT it_mseg INTO wa_mseg.
              IF wa_mseg-menge <= tmp_qty.
                tmp_qty = tmp_qty - wa_mseg-menge.

                """""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                wa_mseg_temp = wa_mseg.                   "Added by swati on 08.01.2018
                APPEND wa_mseg_temp TO it_mseg_temp.      "Added by swati on 08.01.20180
                """""""""""""""""""""""""""""""""""""""""""""""""""""'


                IF tmp_qty = 0.
                  EXIT.
                ENDIF.
              ELSE.
                wa_mseg-menge =  tmp_qty.

                """"""""""""""""""""""""""""""""""""""""""""""""""""
                wa_mseg_temp = wa_mseg.               "Added by swati on 08.01.2018
                APPEND wa_mseg_temp TO it_mseg_temp.   "Added by swati on 08.01.2018
                """""""""""""""""""""""""""""""""""""""""'


                MODIFY it_mseg FROM wa_mseg TRANSPORTING menge WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr ."and matnr = wa_mseg-matnr.
                EXIT.
              ENDIF.
              CLEAR wa_mseg.
            ENDLOOP.
            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""
*            *Added by swati on 08.1.2018
            LOOP AT it_mseg INTO wa_mseg.
              lv_tabix = sy-tabix.
              READ TABLE it_mseg_temp INTO wa_mseg_temp WITH  KEY mblnr = wa_mseg-mblnr
                                                             zeile = wa_mseg-zeile.
              IF sy-subrc <> 0.
                DELETE it_mseg INDEX lv_tabix.
              ENDIF.
              CLEAR :wa_mseg,wa_mseg_temp.
            ENDLOOP.





***            DELETE it_mseg WHERE mblnr < wa_mseg-mblnr.

            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*           sort it_mseg by mblnr mjahr matnr.
*           delete ADJACENT DUPLICATES FROM it_mseg COMPARING mblnr mjahr matnr.
            IF NOT it_mseg[] IS INITIAL.
              SELECT mblnr
                     mjahr
                     "cpudt
                     budat
                FROM mkpf
                INTO TABLE it_mkpf
                FOR ALL ENTRIES IN it_mseg
              WHERE mblnr = it_mseg-mblnr.
              IF sy-subrc = 0.
                LOOP AT it_mkpf INTO wa_mkpf.
                  CLEAR : dspan, wa_mseg.
                  READ TABLE it_mseg INTO wa_mseg WITH KEY mblnr = wa_mkpf-mblnr mjahr = wa_mkpf-mjahr.
                  "dspan = sy-datum - wa_mkpf-cpudt.
                  wa_rslt-budat_mkpf = wa_mseg-budat_mkpf. " added by md
                  dspan = sy-datum - wa_mkpf-budat.
                  IF dspan < 30.
                    wa_rslt-lt30 = wa_rslt-lt30 + wa_mseg-menge.
                  ELSEIF dspan BETWEEN 30 AND 60.
                    wa_rslt-bt30_60 = wa_rslt-bt30_60 + wa_mseg-menge.
                  ELSEIF dspan BETWEEN 60 AND 90.
                    wa_rslt-bt60_90 = wa_rslt-bt60_90 + wa_mseg-menge.
                  ELSEIF dspan BETWEEN 90 AND 120.
                    wa_rslt-bt90_120 = wa_rslt-bt90_120 + wa_mseg-menge.
                  ELSEIF dspan BETWEEN 120 AND 150.
                    wa_rslt-bt120_150 = wa_rslt-bt120_150 + wa_mseg-menge.
                  ELSEIF dspan BETWEEN 150 AND 180.
                    wa_rslt-bt150_180 = wa_rslt-bt150_180 + wa_mseg-menge.
                  ELSE.
                    wa_rslt-gt180 = wa_rslt-gt180 + wa_mseg-menge.
                  ENDIF.
                  CLEAR wa_mkpf.
                ENDLOOP.

                wa_rslt-vlt30     = wa_rslt-zrate * wa_rslt-lt30.
                wa_rslt-vbt30_60  = wa_rslt-zrate * wa_rslt-bt30_60.
                wa_rslt-vbt60_90  = wa_rslt-zrate * wa_rslt-bt60_90.
                wa_rslt-vbt90_120 = wa_rslt-zrate * wa_rslt-bt90_120.
                wa_rslt-vbt120_150 = wa_rslt-zrate * wa_rslt-bt120_150.
                wa_rslt-vbt150_180 = wa_rslt-zrate * wa_rslt-bt150_180.
                wa_rslt-vgt180     = wa_rslt-zrate * wa_rslt-gt180.

              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ELSE.
        CLEAR wa_rslt-frinv.

      ENDIF.

***********************************************Dowanload Data*********************************************
*-------------------------------Added By AG DT:19.02.2018-------------------------------------------------
      ls_final-werks            =         wa_rslt-werks       .
      ls_final-matnr            =         wa_rslt-matnr       .
      ls_final-maktx            =         wa_rslt-maktx       .
      ls_final-meins            =         wa_rslt-meins       .
      ls_final-minbm            =         wa_rslt-minbm       .
      ls_final-totreq           =         wa_rslt-totreq      .
      ls_final-sbcntr           =         wa_rslt-sbcntr      .
**       ls_FINAL-lgort            =         wa_rslt-lgort       .        Date 06 june 2018 Parag Nakhate

      ls_final-mtart            =         wa_rslt-mtart       .
      ls_final-sl1              =         wa_rslt-sl1         .          "'FINISHED GOODS'
      ls_final-sl2              =         wa_rslt-sl2         .          "'PRODUCTION'
*      ls_final-sl3              =         wa_rslt-sl3         .          "'REJECTION'
      ls_final-sl4              =         wa_rslt-sl4         .          "'RAW MATERIALS'
      ls_final-sl5              =         wa_rslt-sl5         .          "'REWORK'
      ls_final-sl6              =         wa_rslt-sl6         .          "'Subcon Stk Loc'
*      ls_final-sl7              =         wa_rslt-sl7         .          "'SCRAP'
      ls_final-sl8              =         wa_rslt-sl8         .          "'WIP ASSEMBLED'
      ls_final-sl9              =         wa_rslt-sl9         .          "'FG Sales Return'
      ls_final-sl10             =         wa_rslt-sl10        .          "'SPARES & CONSUM'
      ls_final-sl11             =         wa_rslt-sl11        .          "'SRN STORES'
      ls_final-sl12             =         wa_rslt-sl12        .          "'THIRD PARTY INSP'
      ls_final-sl13             =         wa_rslt-sl13        .          "'VALIDATION'
      ls_final-sl14             =         wa_rslt-sl14        .          "'QA OK STOCK SL'
      ls_final-sl15             =         wa_rslt-sl15        .          "'QA OK STOCK SL'
      ls_final-sl16             =         wa_rslt-sl16        .          "'QA OK STOCK SL'
      ls_final-sl17             =         wa_rslt-sl17        .          "'QA OK STOCK SL'
*       ls_FINAL-sl14             =         wa_rslt-sl14        .
*       ls_FINAL-sl15             =         wa_rslt-sl15        .
*       ls_FINAL-sl16             =         wa_rslt-sl16        .
*       ls_FINAL-sl17             =         wa_rslt-sl17        .
*       ls_FINAL-sl18             =         wa_rslt-sl18        .
*       ls_FINAL-sl19             =         wa_rslt-sl19        .
*       ls_FINAL-sl20             =         wa_rslt-sl20        .
*       ls_FINAL-sl21             =         wa_rslt-sl21        .
*       ls_FINAL-sl22             =         wa_rslt-sl22        .
*       ls_FINAL-sl23             =         wa_rslt-sl23        .
*       ls_FINAL-sl24             =         wa_rslt-sl24        .
*       ls_FINAL-sl25             =         wa_rslt-sl25        .
*       ls_FINAL-sl26             =         wa_rslt-sl26        .
*       ls_FINAL-sl27             =         wa_rslt-sl27        .
*       ls_FINAL-sl28             =         wa_rslt-sl28        .
*       ls_FINAL-sl29             =         wa_rslt-sl29        .
*       ls_FINAL-sl30             =         wa_rslt-sl30        .
      ls_final-unrst            =         wa_rslt-unrst       .
      ls_final-insme            =         wa_rslt-insme       .
      ls_final-totstck          =         wa_rslt-totstck     .
      ls_final-sfqty            =         wa_rslt-sfqty       .
      ls_final-frinv            =         wa_rslt-frinv       .
      ls_final-zrate            =         wa_rslt-zrate       .
      ls_final-lt30             =         wa_rslt-lt30        .
      ls_final-vlt30            =         wa_rslt-vlt30       .
      ls_final-bt30_60          =         wa_rslt-bt30_60     .
      ls_final-vbt30_60         =         wa_rslt-vbt30_60    .
      ls_final-bt60_90          =         wa_rslt-bt60_90     .
      ls_final-vbt60_90         =         wa_rslt-vbt60_90    .
      ls_final-bt90_120         =         wa_rslt-bt90_120    .
      ls_final-vbt90_120        =         wa_rslt-vbt90_120   .
      ls_final-bt120_150        =         wa_rslt-bt120_150   .
      ls_final-vbt120_150       =         wa_rslt-vbt120_150  .
      ls_final-bt150_180        =         wa_rslt-bt150_180   .
      ls_final-vbt150_180       =         wa_rslt-vbt150_180  .
      ls_final-gt180            =         wa_rslt-gt180       .
      ls_final-vgt180           =         wa_rslt-vgt180      .
      ls_final-value            =         wa_rslt-value       .
      ls_final-zseries          =         wa_rslt-zseries     .
      ls_final-zsize            =         wa_rslt-zsize       .
      ls_final-brand            =         wa_rslt-brand       .
      ls_final-moc              =         wa_rslt-moc         .
      ls_final-type             =         wa_rslt-type        .

      CALL FUNCTION 'CONVERSION_EXIT_SDATE_OUTPUT'
        EXPORTING
          input         = wa_rslt-budat_mkpf
       IMPORTING
         OUTPUT        = ls_final-budat_mkpf
                .

      REPLACE ALL OCCURRENCES OF '.' IN ls_final-budat_mkpf WITH '-'.

           wa_rslt-budat_mkpf = ls_final-budat_mkpf.


*      ls_final-budat_mkpf       =         wa_rslt-budat_mkpf . " added by md
      ls_final-speme            =         wa_rslt-speme.
      ls_final-ref              =         sy-datum.



*BREAK-POINT.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-ref
        IMPORTING
          output = ls_final-ref.

      CONCATENATE ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
                      INTO ls_final-ref SEPARATED BY '-'.
*--------------------------------------------------------------------------------------------------
*BREAK-POINT.
      IF wa_rslt-frinv NE 0 . " No line item if free inventory is zero
        APPEND ls_final TO lt_final.       " Added By Abhishek Pisolkar (22.03.2018)
        APPEND wa_rslt TO p_rslt.
      ENDIF.
          CLEAR : wa_rslt, wa_mslb, wa_mbew, wa_moq, ls_final,ls_mseg3.
    ENDLOOP.
*BREAK-POINT.
    CLEAR : wa_mara, wa_marc, wa_makt, wa_mbew, wa_rslt, ls_final.
    REFRESH : it_mseg3, it_mseg4.
  ENDLOOP.
*  ENDIF.
ENDFORM.                    "GET_DATA

*&---------------------------------------------------------------------*
*&      Form  GENERATE_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RSLT     text
*      -->ALV_OBJ    text
*----------------------------------------------------------------------*
FORM generate_alv USING p_rslt TYPE tt_result
                  CHANGING alv_obj TYPE REF TO cl_salv_table.

  DATA : lv_columns TYPE REF TO cl_salv_columns,
         lv_column  TYPE REF TO cl_salv_column,
         o_layout   TYPE REF TO cl_salv_layout,
         key        TYPE salv_s_layout_key.

  IF NOT p_rslt[] IS INITIAL.
    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = alv_obj
          CHANGING
            t_table      = p_rslt[].
      CATCH cx_salv_msg INTO lc_msg .
    ENDTRY.

    " Enable Save Layout Option
    o_layout = alv_obj->get_layout( ).
    key-report = sy-repid.
    o_layout->set_key( key ).
    CALL METHOD o_layout->set_save_restriction
      EXPORTING
        value = if_salv_c_layout=>restrict_none.

    lv_columns = alv_obj->get_columns( ).
    lv_column = lv_columns->get_column('TOTREQ').
    lv_column->set_short_text( 'Tot.Req.' ).
    lv_column->set_medium_text( 'Tot Requirement' ).
    lv_column->set_long_text( 'Total Requirement' ).

    lv_column = lv_columns->get_column('TOTSTCK').
    lv_column->set_short_text( 'Total Stck' ).
    lv_column->set_medium_text( 'Total Stock' ).
    lv_column->set_long_text( 'Total Stock' ).

    lv_column = lv_columns->get_column('FRINV').
    lv_column->set_short_text( 'Free Invnt' ).
    lv_column->set_medium_text( 'Free Inventory' ).
    lv_column->set_long_text( 'Free Inventory' ).

    PERFORM determine_strg_loc_columns.

    " Default functions
    alv_fncts = alv_obj->get_functions( ).
    alv_fncts->set_all( abap_true ).
  ENDIF.
ENDFORM.                    "GENERATE_ALV

*&---------------------------------------------------------------------*
*&      Form  SET_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR    text
*      -->P_WERKS    text
*      -->ALV_OBJ    text
*----------------------------------------------------------------------*
FORM set_header USING p_matnr TYPE rng_matnr
                      p_werks TYPE werks_d
                      "P_DATE  TYPE RNG_DATUM
                      alv_obj TYPE REF TO cl_salv_table.

  DATA : lyot_txt  TYPE REF TO cl_salv_form_layout_grid,
         lyot_lbl  TYPE REF TO cl_salv_form_label,
         lyot_flow TYPE REF TO cl_salv_form_layout_flow,
         line      TYPE string,
         wa_matnr  LIKE LINE OF p_matnr,
         var_i     TYPE i.

  CREATE OBJECT lyot_txt.

  " Header Text (In Bold)
*    LYOT_LBL = LYOT_TXT->CREATE_LABEL( ROW = 1 COLUMN = 1 TEXT = 'Selection Criteria : ').
*
*    VAR_I = 2.
*    IF NOT P_MATNR IS INITIAL.
*      VAR_I = VAR_I + 1.
*      LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
*      LYOT_FLOW->CREATE_TEXT( TEXT = 'Material(s) : ' ).
*
*      LOOP AT P_MATNR INTO WA_MATNR.
*        LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 2 ).
*        IF WA_MATNR-SIGN = 'E'.
*          LINE = 'Excluding -'.
*        ELSE.
*          LINE = 'Including -'.
*        ENDIF.
*        IF WA_MATNR-HIGH IS INITIAL.
*          CONCATENATE LINE WA_MATNR-LOW INTO LINE SEPARATED BY space.
*        ELSE.
*          CONCATENATE LINE WA_MATNR-LOW 'To' WA_MATNR-HIGH INTO LINE SEPARATED BY space.
*        ENDIF.
*        LYOT_FLOW->CREATE_TEXT( TEXT = LINE ).
*        VAR_I = VAR_I + 1.
*        CLEAR WA_MATNR.
*      ENDLOOP.
*    ENDIF.
*
*    VAR_I = VAR_I + 1.
*    LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
*    LYOT_FLOW->CREATE_TEXT( TEXT = 'Plant : ' ).
*
*
*    LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 2 ).
*    LYOT_FLOW->CREATE_TEXT( TEXT = P_WERKS ).
*
*
*
**    LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
**    LYOT_FLOW->CREATE_TEXT( TEXT = 'Duration : ' ).
**
**
**    LOOP AT P_DATE INTO WA_DATE.
**      LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 2 ).
**      CONCATENATE WA_DATE-LOW ' - ' WA_DATE-HIGH INTO LINE.
**      LYOT_FLOW->CREATE_TEXT( TEXT = LINE ).
**      VAR_I = VAR_I + 1.
**      CLEAR WA_DATE.
**    ENDLOOP.
*
**    VAR_I = VAR_I + 1.
**    LYOT_FLOW = LYOT_TXT->CREATE_FLOW( ROW = VAR_I COLUMN = 1 ).
**    LYOT_FLOW->CREATE_TEXT( TEXT = '.' ).

  var_i = var_i + 1.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = 'Date of Report Generation : ' ).

  lyot_flow = lyot_txt->create_flow( row = var_i column = 2 ).
  lyot_flow->create_text( text = sy-datum ).
  var_i = var_i + 1.

  alv_obj->set_top_of_list( lyot_txt ).

ENDFORM.                    "SET_HEADER
*&---------------------------------------------------------------------*
*&      Form  GET_SUBCONTRACT_STOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_subcontract_stock TABLES pit_marc TYPE tt_marc
                                  pit_mslb TYPE tt_mslb
                                  pit_ekpo TYPE tt_ekpo
                              .
  DATA : wa_mslb     TYPE t_mslb,
         it_mslb_tmp TYPE TABLE OF t_mslb,
         wa_eket     TYPE t_eket,
         wa_ekpo     TYPE t_ekpo,
         it_eket     TYPE TABLE OF t_eket
         .

  REFRESH : it_mslb_tmp, pit_mslb.
  SELECT matnr
         lblab
    INTO TABLE it_mslb_tmp
    FROM mslb
    FOR ALL ENTRIES IN pit_marc[]
    WHERE matnr = pit_marc-matnr
  AND werks = pit_marc-werks.
  IF sy-subrc = 0.
    SORT it_mslb_tmp BY matnr.
    LOOP AT it_mslb_tmp INTO wa_mslb.
      COLLECT wa_mslb INTO pit_mslb.
      CLEAR wa_mslb.
    ENDLOOP.
    REFRESH it_mslb_tmp.
    SORT pit_mslb BY matnr.
  ENDIF.

*  select ebeln
*         ebelp
*         matnr
*         menge   " PNDMNG
*    into table pit_ekpo
*    from ekpo
*    for all entries in pit_marc
*    where matnr = pit_marc-matnr
*      and werks = pit_marc-werks
*      and ELIKZ  = space.
*  IF sy-subrc = 0.
*    select ebeln
*           ebelp
*           WEMNG
*      from eket
*      into table it_eket
*      for all entries in pit_ekpo
*      where ebeln = pit_ekpo-ebeln
*        and ebelp = pit_ekpo-ebelp.
*    IF sy-subrc = 0.
*      LOOP AT pit_ekpo into wa_ekpo.
*        wa_ekpo-pndmng = wa_ekpo-menge.
*        LOOP AT it_eket into wa_eket where ebeln = wa_ekpo-ebeln
*                                       and ebelp = wa_ekpo-ebelp.
*          wa_ekpo-pndmng = wa_ekpo-pndmng - WA_eket-WEMNG.
*          clear wa_eket.
*        ENDLOOP.
*        if WA_EKPO-pndmng > 0.
*          modify pit_ekpo from wa_ekpo
*            transporting pndmng
*            where ebeln = wa_ekpo-ebeln
*              and ebelp = wa_ekpo-ebelp.
*        endif.
*        clear wa_ekpo.
*      ENDLOOP.
*      IF sy-subrc = 0.
*        sort pit_ekpo by matnr.
*      ENDIF.
*    ENDIF.
*  ENDIF.
ENDFORM.                    " GET_SUBCONTRACT_STOCK
*&---------------------------------------------------------------------*
*&      Form  DETERMINE_STRG_LOC_COLUMNS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM determine_strg_loc_columns.
  TYPES : BEGIN OF t_lgort,
            lgort TYPE lgort_d, " Storage Location
            lgobe	TYPE lgobe,   " Description of Storage Location
          END OF t_lgort.
  DATA : wa_lgort    TYPE t_lgort,
         wa_mard     TYPE t_mard,
         it_lgort    TYPE TABLE OF t_lgort,
         lv_column   TYPE REF TO cl_salv_column_table,
         lv_columns  TYPE REF TO cl_salv_columns_table,
         columnname	 TYPE lvc_fname,
         str         TYPE string,
         str_s       TYPE scrtext_s,
         str_m       TYPE scrtext_m,
         o_color     TYPE lvc_s_colo,
         lvrec_count TYPE i VALUE 0.

  o_color-col = 4.
  o_color-int = 1.
  o_color-inv = 0.
*BREAK primus.
  SELECT DISTINCT
      lgort
      lgobe
    INTO TABLE it_lgort
    FROM t001l
  WHERE werks = v_werks.
  IF sy-subrc = 0.
    SORT it_lgort BY lgort.
    lv_columns = alv_obj->get_columns( ).
  ENDIF.

*  DO 30 TIMES.         " Commented By Abhishek Pisolkar (06.04.2018)
  DO 13 TIMES.
    str = sy-index.
    CONCATENATE 'SL' str INTO columnname.
    TRY.
        lv_column ?= lv_columns->get_column( columnname ).
      CATCH cx_salv_not_found.
    ENDTRY.

    READ TABLE it_sl_col INTO wa_sl_col INDEX sy-index.
    IF sy-subrc = 0.
      IF lv_column IS NOT INITIAL.
        READ TABLE it_lgort INTO wa_lgort
          WITH KEY lgort = wa_sl_col-lgort.
        str_s = wa_lgort-lgort.
        str_m = wa_lgort-lgobe.
        lv_column->set_short_text( str_s ).
        lv_column->set_medium_text( str_m ).
        "lv_column->set_long_text( str1 ).

        lv_column->set_color( o_color ).
      ENDIF.
    ELSE.
      lv_column->set_visible( space ).
    ENDIF.
    CLEAR : wa_lgort, wa_sl_col, lv_column, columnname.
  ENDDO.
  IF  p_down = 'X'.
    PERFORM download.
    PERFORM gui_download.
  ENDIF.

ENDFORM.                    " DETERMINE_STRG_LOC_COLUMNS
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*-------------------------------Added By AG DT:19.02.2018-------------------------------------------------

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
  REFRESH it_csv.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    EXPORTING
      i_field_seperator    = 'X'
*     I_LINE_HEADER        =
*     I_FILENAME           =
*     I_APPL_KEEP          = ' '
    TABLES
      i_tab_sap_data       = lt_final    "it_rslt                  "LT_FINAL
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*  CALL FUNCTION 'SAP_CONVERT_TO_TEX_FORMAT'
*    EXPORTING
*      i_field_seperator          =  ','
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    tables
*      i_tab_sap_data             = lt_final
*   CHANGING
*     I_TAB_CONVERTED_DATA       = it_csv
*   EXCEPTIONS
*     CONVERSION_FAILED          = 1
*     OTHERS                     = 2
*            .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.


  PERFORM cvs_header USING hd_csv.
  lv_file = 'ZMM_FRINVENTORY.TXT'.
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.
*BREAK primus.
  WRITE: / 'ZMM_FRINVENTORY started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT .  "ENCODING UTF-8.                 "ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1386 TYPE string.
DATA lv_crlf_1386 TYPE string.
lv_crlf_1386 = cl_abap_char_utilities=>cr_lf.
lv_string_1386 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1386 lv_crlf_1386 wa_csv INTO lv_string_1386.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1386 TO lv_fullfile.
  ENDIF.
  CLOSE DATASET lv_fullfile.
  CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
  MESSAGE lv_msg TYPE 'S'.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE   'Plant'                      "1
                'Material'                   "2
                'Material Description'       "3
                'Unit'                       "4
                'Minimum Order Qty'          "5
                'Total Requirement'          "6
                'Subcontractor Stck.'        "7
*              'Stor. Loc.'                 "8
                'Matl Type'                  "9
                'FINISHED GOODS'        "sl1 "10
                'PRODUCTION'
*                'REJECTION'
                'RAW MATERIALS'         "sl2  11
                'REWORK'                "sl3  12
                'Subcon Stk Loc'        "sl4  13
*                'SCRAP'
                'WIP ASSEMBLED'         "sl5  14
                'FG Sales Return'       "sl6  15
                'SPARES & CONSUM'
                'SRN STORES'
                'THIRD PARTY INSP'      "sl7  16
                'VALIDATION'
                'QA OK STOCK SL'                                       " 25/05/2018
                'Planning'                                             " 25/05/2018
                'Unrestricted Stock'          " 17
                'In Quality Insp.'            "18
                'Total Stock'                 " 19
                'Safety stock'                "20
                'Free Inventory'              "21
                'Rate'                           "24 45
                '< 30 Days'                      "46
                'Value'                          "47
                'Btwn 30-60 Days'                "48
                'Value'                          "49
                'Btwn 60-90 Days'                "50
                'Value'                          "51
                'Btwn 90-120 Days'               "52
                'Value'                          "53
                'Btwn 120-150 Days'              "54
                'Value'                          "55
                'Btwn 150-180 Days'              "56
                'Value'                          "57
                '> 180 Days'                     "58
                'Value'                          "59
                'Value'                          "60
                'seri code'                      "61
                'size'                           "62
                'Brand'                          "63
                'MOC'                            "64
                'Type'                           "65
                'Refresh Date'                   "66
                'Last usage date'                     " 67
                'Blocked Stock'                     " 68
                'Sangavi Stock'                " 68
                'Machine Stock'                " 68
                INTO p_hd_csv
                SEPARATED BY l_field_seperator.
ENDFORM.
*-----------------------------------------------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  GUI_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM gui_download .
  TYPES : BEGIN OF ls_fieldname,
            field_name(25),
          END OF ls_fieldname.

  DATA : it_fieldname TYPE TABLE OF ls_fieldname.
  DATA : wa_fieldname TYPE ls_fieldname.
*----------------Fieldnames---------------------------------------------------------
  wa_fieldname-field_name = 'Plant'.
  APPEND wa_fieldname TO it_fieldname.
  CLEAR wa_fieldname.

  wa_fieldname-field_name = 'Material'.
  APPEND wa_fieldname TO it_fieldname.
  CLEAR wa_fieldname.

  wa_fieldname-field_name = 'Material Description'.
  APPEND wa_fieldname TO it_fieldname.
  CLEAR wa_fieldname.

  wa_fieldname-field_name = 'Unit'.
  APPEND wa_fieldname TO it_fieldname.
  CLEAR wa_fieldname.

  wa_fieldname-field_name = 'Minimum Order Qty'.
  APPEND wa_fieldname TO it_fieldname.
  CLEAR wa_fieldname.

  wa_fieldname-field_name = 'Total Requirement'.
  APPEND wa_fieldname TO it_fieldname.
  CLEAR wa_fieldname.

  wa_fieldname-field_name = 'Subcontractor Stck.'.
  APPEND wa_fieldname TO it_fieldname.
*
*  WA_FIELDNAME-FIELD_NAME = 'Stor. Loc.'.
*  APPEND WA_FIELDNAME TO IT_FIELDNAME.

  wa_fieldname-field_name = 'Matl Type'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'FINISHED GOODS'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'PRODUCTION'.
  APPEND wa_fieldname TO it_fieldname.
*  wa_fieldname-field_name = 'REJECTION'.
*  APPEND wa_fieldname TO it_fieldname.
  wa_fieldname-field_name = 'RAW MATERIALS'.
  APPEND wa_fieldname TO it_fieldname.
*
  wa_fieldname-field_name = 'REWORK'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Subcon Stk Loc'.
  APPEND wa_fieldname TO it_fieldname.

*  wa_fieldname-field_name = 'Scrap'.
*  APPEND wa_fieldname TO it_fieldname.
*
  wa_fieldname-field_name = 'WIP ASSEMBLED' .
  APPEND wa_fieldname TO it_fieldname.
*
  wa_fieldname-field_name = 'FG Sales Return'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'SPARES & CONSUM'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'SRN STORES'.
  APPEND wa_fieldname TO it_fieldname.
**--------------------------------------------------------------------*
  wa_fieldname-field_name = 'THIRD PARTY INSP'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'VALIDATION'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'QA OK STOCK SL'.             " 25/05/2018
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Planning'.                   " 25/05/2018
  APPEND wa_fieldname TO it_fieldname.
*--------------------------------------------------------------------*
  wa_fieldname-field_name = 'Unrestricted Stock'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'In Quality Insp'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Total Stock'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Safety Stock'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Free Inventory'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Rate'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = '< 30 Days'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Value'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Btwn 30-60 Days'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Value'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Btwn 60-90 Days'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Value'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Btwn 90-120 Days'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Value'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Btwn 120-150 Days'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Value'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Btwn 150-180 Days'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Value'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = '> 180 Days'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Value'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Value'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Seri Code.'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Size'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Brand'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'MOC'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Type'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Refreshable date'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Last usage date'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Blocked Stock'.
  APPEND wa_fieldname TO it_fieldname.

  wa_fieldname-field_name = 'Sangavi Stock'.
  APPEND wa_fieldname TO it_fieldname.
*  BREAK primus.
*--------------------------------------------------------------------*
  DATA file TYPE string VALUE 'F:\ZMMFRINV.TXT'.
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE            =
      filename                = file
      filetype                = 'ASC'
*     APPEND                  = ' '
      write_field_separator   = 'X'
*     HEADER                  = '00'
*     TRUNC_TRAILING_BLANKS   = ' '
*     WRITE_LF                = 'X'
*     COL_SELECT              = ' '
*     COL_SELECT_MASK         = ' '
*     DAT_MODE                = ' '
*     CONFIRM_OVERWRITE       = ' '
*     NO_AUTH_CHECK           = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     WRITE_BOM               = ' '
*     TRUNC_TRAILING_BLANKS_EOL       = 'X'
*     WK1_N_FORMAT            = ' '
*     WK1_N_SIZE              = ' '
*     WK1_T_FORMAT            = ' '
*     WK1_T_SIZE              = ' '
*     WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
*     SHOW_TRANSFER_STATUS    = ABAP_TRUE
*     VIRUS_SCAN_PROFILE      = '/SCET/GUI_DOWNLOAD'
* IMPORTING
*     FILELENGTH              =
    TABLES
      data_tab                = lt_final
      fieldnames              = it_fieldname
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcat .
  PERFORM catalog USING '' '' 'WERKS' 'IT_RSLT' 'Plant' ''.
  PERFORM catalog USING '' '' 'MATNR' 'IT_RSLT' 'Mateial No' ''.
  PERFORM catalog USING '' '' 'MAKTX' 'IT_RSLT' 'Description' ''.
  PERFORM catalog USING '' '' 'MEINS' 'IT_RSLT' 'Unit' ''.
  PERFORM catalog USING '' '' 'MINBM' 'IT_RSLT' 'PO Quantity' ''.
  PERFORM catalog USING '' '' 'TOTREQ' 'IT_RSLT' 'Total Requirment' ''.
  PERFORM catalog USING '' '' 'SBCNTR' 'IT_RSLT' 'Suncontractor Stock' ''.
*PERFORM catalog USING '' '' 'LGORT' 'IT_RSLT' 'Storage Location' ''.
  PERFORM catalog USING '' '' 'MTART' 'IT_RSLT' 'Material Type' ''.
  PERFORM catalog USING '' '' 'SL1' 'IT_RSLT' 'FINISHED GOODS' 'C100'.
  PERFORM catalog USING '' '' 'SL2' 'IT_RSLT' 'PRODUCTION' 'C100'.
*  PERFORM catalog USING '' '' 'SL3' 'IT_RSLT' 'REJECTION' 'C100'.
  PERFORM catalog USING '' '' 'SL4' 'IT_RSLT' 'RAW MATERIALS' 'C100'.
  PERFORM catalog USING '' '' 'SL5' 'IT_RSLT' 'REWORK' 'C100'.
  PERFORM catalog USING '' '' 'SL6' 'IT_RSLT' 'Subcon Stk Loc' 'C100'.
*  PERFORM catalog USING '' '' 'SL7' 'IT_RSLT' 'SCRAP' 'C100'.
  PERFORM catalog USING '' '' 'SL8' 'IT_RSLT' 'WIP ASSEMBELED' 'C100'.
  PERFORM catalog USING '' '' 'SL9' 'IT_RSLT' 'FG Sales Return' 'C100'.
  PERFORM catalog USING '' '' 'SL10' 'IT_RSLT' 'SPARES & CONSUM' 'C100'.
  PERFORM catalog USING '' '' 'SL11' 'IT_RSLT' 'SRN STORES' 'C100'.
  PERFORM catalog USING '' '' 'SL12' 'IT_RSLT' 'THIRD PARTY INSP' 'C100'.
  PERFORM catalog USING '' '' 'SL13' 'IT_RSLT' 'VALIDATION' 'C100'.
  PERFORM catalog USING '' '' 'SL14' 'IT_RSLT' 'QA OK STOCK SL' 'C100'.                      " 25/05/2018
  PERFORM catalog USING '' '' 'SL15' 'IT_RSLT' 'Planning' 'C100'.                            " 25/05/2018
  PERFORM catalog USING '' '' 'UNRST' 'IT_RSLT' 'Unrestricted Stock' ''.
  PERFORM catalog USING '' '' 'INSME' 'IT_RSLT' 'Stock in Quality Inspection' ''.
  PERFORM catalog USING '' '' 'TOTSTCK' 'IT_RSLT' 'Total Stock' ''.
  PERFORM catalog USING '' '' 'SFQTY' 'IT_RSLT' 'Safety Stock' ''.
  PERFORM catalog USING '' '' 'FRINV' 'IT_RSLT' 'Free Inventory' ''.
  PERFORM catalog USING '' '' 'ZRATE' 'IT_RSLT' 'Rate' ''.
  PERFORM catalog USING '' '' 'LT30' 'IT_RSLT' '<30 Days' ''.
  PERFORM catalog USING '' '' 'VLT30' 'IT_RSLT' 'Value' ''.
  PERFORM catalog USING '' '' 'BT30_60' 'IT_RSLT' 'Btwn 30-60 Days' ''.
  PERFORM catalog USING '' '' 'VBT30_60' 'IT_RSLT' 'Value' ''.
  PERFORM catalog USING '' '' 'BT60_90' 'IT_RSLT' 'Btwn 60-90 Days' ''.
  PERFORM catalog USING '' '' 'VBT60_90' 'IT_RSLT' 'Value' ''.
  PERFORM catalog USING '' '' 'BT90_120' 'IT_RSLT' 'Btwn 90-120 Days' ''.
  PERFORM catalog USING '' '' 'VBT90_120' 'IT_RSLT' 'Value' ''.
  PERFORM catalog USING '' '' 'BT120_150' 'IT_RSLT' 'Btwn 120-150 Days' ''.
  PERFORM catalog USING '' '' 'VBT120_150' 'IT_RSLT' 'Value' ''.
  PERFORM catalog USING '' '' 'BT150_180' 'IT_RSLT' 'Btwn 150-180 Days' ''.
  PERFORM catalog USING '' '' 'VBT150_180' 'IT_RSLT' 'Value' ''.
  PERFORM catalog USING '' '' 'GT180' 'IT_RSLT' '>180 Days' ''.
  PERFORM catalog USING '' '' 'VGT180' 'IT_RSLT' 'Value' ''.
  PERFORM catalog USING '' '' 'VALUE' 'IT_RSLT' 'Value' ''.
  PERFORM catalog USING '' '' 'ZSERIES' 'IT_RSLT' 'Seri Code' ''.
  PERFORM catalog USING '' '' 'ZSIZE' 'IT_RSLT' 'Size' ''.
  PERFORM catalog USING '' '' 'BRAND' 'IT_RSLT' 'Brand' ''.
  PERFORM catalog USING '' '' 'MOC' 'IT_RSLT' 'MOC' ''.
  PERFORM catalog USING '' '' 'TYPE' 'IT_RSLT' 'Type' ''.
  PERFORM catalog USING '' '' 'BUDAT_MKPF' 'IT_RSLT' 'Last usage date' ''.
  PERFORM catalog USING '' '' 'SPEME' 'IT_RSLT' 'Blocked Stock' ''.
  PERFORM catalog USING '' '' 'SL16' 'IT_RSLT' 'Sangavi Stock' 'C100'.                      " 13/09/2023
  PERFORM catalog USING '' '' 'SL17' 'IT_RSLT' 'Machine Stock' 'C100'.                            " 13/09/2023

  wa_layout-colwidth_optimize = 'X'.
  wa_layout-zebra = 'X'.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_3297   text
*      -->P_3298   text
*      -->P_3299   text
*      -->P_3300   text
*      -->P_3301   text
*----------------------------------------------------------------------*
FORM catalog  USING    VALUE(p1)
                       VALUE(p2)
                       VALUE(p3)
                       VALUE(p4)
                       VALUE(p5)
                       VALUE(p6).
  p1 = p1 + 1.
  wa_fldcat-col_pos = p1.
  wa_fldcat-key = p2.
  wa_fldcat-fieldname = p3.
  wa_fldcat-tabname = p4.
  wa_fldcat-seltext_m = p5.
  wa_fldcat-emphasize = p6.
  APPEND wa_fldcat TO it_fldcat.
  CLEAR wa_fldcat.

ENDFORM.
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
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      i_callback_program     = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      i_callback_top_of_page = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      is_layout              = wa_layout
      it_fieldcat            = it_fldcat[]
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
      i_save                 = 'X'
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab               = it_rslt[]
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
FORM top_of_page.
  DATA: i_listheader TYPE slis_t_listheader WITH HEADER LINE,
        w_date(10)   TYPE c,
        msg          TYPE string.
  CONCATENATE   sy-datum+6(2) '.'
                sy-datum+4(2) '.'
                sy-datum(4) INTO w_date RESPECTING BLANKS.
  CONCATENATE 'Date of Report Generation :    ' w_date INTO msg SEPARATED BY space.
  MOVE: 'S'   TO i_listheader-typ,
        msg   TO i_listheader-info.
  APPEND i_listheader.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = i_listheader[].
*      I_LOGO             = 'BLISS LOGO'.

ENDFORM.
