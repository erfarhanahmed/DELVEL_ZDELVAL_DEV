*&---------------------------------------------------------------------*
*& Report ZCO_BOM_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCO_BOM_2.

TABLES : keko, mast.

TYPES: BEGIN OF TY_MAPL,

        MATNR TYPE MAPL-MATNR,
        WERKS TYPE MAPL-WERKS,
        PLNNR TYPE MAPL-PLNNR,
       END OF  TY_MAPL.


TYPES : BEGIN OF ty_keko,

          kalnr    TYPE keko-kalnr,             "Cost Estimate No
          kalka    TYPE keko-kalka,             "Costing Type
          kadky    TYPE keko-kadky,             "Costing Key Date
          matnr    TYPE keko-matnr,             "Material
          werks    TYPE keko-werks,                "Plant
          feh_sta  TYPE keko-feh_sta,           "Costing Status
          substrat TYPE keko-substrat,          "Info Rec
          klvar    TYPE keko-klvar,             "Costing Variant
          poper    TYPE keko-poper,             "Posting Period
          plnnr    TYPE keko-plnnr,             "routing No
          sobsl    TYPE keko-sobsl,
          beskz    TYPE keko-beskz,
          TVERS    type keko-TVERS,
        END OF ty_keko.

TYPES : BEGIN OF ty_mast,
          matnr TYPE mast-matnr,                "material
          werks TYPE mast-werks,                "plant
          stlan TYPE mast-stlan,                "BOM Usage
          stlnr TYPE mast-stlnr,                "Bill of material
          stlal TYPE mast-stlal,                "Alternative BOM
        END OF ty_mast.

TYPES : BEGIN OF ty_stko,
          stlty TYPE stko-stlty,                      "BOM category
          stlnr TYPE stko-stlnr,                      ""BOM Usage
          lkenz TYPE stko-lkenz,                      "Deletion Indicator
          loekz TYPE stko-loekz,                      "Deletion flag for BOMs
          bmein TYPE stko-bmein,                      "Base unit of measure for BOM
          bmeng TYPE stko-bmeng,                      "Base quantity
          stlst TYPE stko-stlst,                      "BOM status
        END OF ty_stko.

TYPES: BEGIN OF ty_stpo,
*         stufe TYPE stpox-stufe,                 "Level
         stlnr TYPE stpo-stlnr,                  "Bill of material
         datuv TYPE stpo-datuv,                   "Valid-From Date
         aennr TYPE stpo-aennr,                   "Change Number
         idnrk TYPE stpo-idnrk,                    "Child Material
         posnr TYPE stpo-posnr,                   "Position No
         meins TYPE stpo-meins,                  "Component unit of measure
         menge TYPE stpo-menge,                   "Component quantity
         sanka TYPE stpo-sanka,                   "Indicator: item relevant to engineering
         sanko TYPE stpo-sanko,                   "Indicator: high-level configuration
       END OF ty_stpo.

TYPES : BEGIN OF ty_mbew,
          matnr TYPE mbew-matnr,
          bwkey TYPE mbew-bwkey,
          kaln1 type mbew-kaln1,
        END OF ty_mbew.
*
TYPES : BEGIN OF ty_marc,
          matnr TYPE marc-matnr,
          werks TYPE marc-werks,
          beskz TYPE marc-beskz,
          sobsl TYPE marc-sobsl,
          ncost TYPE marc-ncost,

        END OF ty_marc.

TYPES : BEGIN OF ty_matnr2,
          matnr TYPE mast-matnr,                "material
        END OF ty_matnr2.

TYPES : BEGIN OF ty_ckis,
          kalnr  TYPE ckis-kalnr,            "Cost Estimate No
          kalka  TYPE ckis-kalka,            "Costing Type
          kadky  TYPE ckis-kadky,            "Costing Date (Key)
*          posnr TYPE ckis-posnr,            "Position No
          typps  TYPE ckis-typps,            "Item Category
          matnr  TYPE ckis-matnr,            "Material
          gpreis TYPE ckis-gpreis,           "RATE PER UNIT
          wertn  TYPE ckis-wertn,             "Cost
          menge  TYPE ckis-menge,             "Quantity
          meeht  TYPE ckis-meeht,            "UOM
          lstar  TYPE ckis-lstar,             "Activity Type
*          strat TYPE ckis-strat,             "Valuation Strategy used for Costing Item
          infnr  TYPE ckis-infnr,          "Info Record
*          selkz TYPE ckis-selkz,             "Indicator for Relevancy to Costing
        END OF ty_ckis.

DATA : it_keko   TYPE TABLE OF ty_keko,
       wa_keko   TYPE ty_keko,

       it_MAPL   TYPE TABLE OF ty_MAPL,
       wa_MAPL   TYPE ty_MAPL,

       it_keko1  TYPE TABLE OF ty_keko,
       wa_keko1  TYPE ty_keko,

       it_mast   TYPE TABLE OF ty_mast,
       wa_mast   TYPE ty_mast,

       it_mast1  TYPE TABLE OF ty_mast,
       wa_mast1  TYPE ty_mast,

       it_mbew  TYPE TABLE OF ty_mbew,
       wa_mbew TYPE ty_mbew,

       it_stko   TYPE TABLE OF ty_stko,
       wa_stko   TYPE ty_stko,

       it_stpo   TYPE TABLE OF ty_stpo,
       wa_stpo   TYPE ty_stpo,

       it_matnr2 TYPE TABLE OF ty_matnr2,
       wa_matnr2 TYPE ty_matnr2,

       it_marc   TYPE TABLE OF ty_marc,
       wa_marc   TYPE marc,

       it_ckis   TYPE TABLE OF ty_ckis,
       wa_ckis   TYPE  ty_ckis,

       it_ckis1  TYPE TABLE OF ty_ckis,
       it_ckis2  TYPE TABLE OF ty_ckis,
       wa_ckis1  TYPE  ty_ckis,
       wa_ckis2  TYPE  ty_ckis.

DATA : lv_mtart TYPE mara-mtart.

DATA : rate      TYPE char20,
       rate1     TYPE char20,
       tot_cost  TYPE kbetr,
       tot_cost1 TYPE kbetr,
       rate2     TYPE char20,
       tot_cost2 TYPE kbetr.


TYPES : BEGIN OF ty_final,

          stufe       TYPE stpox-stufe,                    "Level (in multi-level BOM explosions)
          matnr       TYPE mast-matnr,                          "material of which BOM does exist
          werks       TYPE werks_d, "plant
          posnr       TYPE stpox-posnr,                    "BOM Item Number
          idnrk       TYPE stpox-idnrk,                     "Chile Material
          ojtxp       TYPE stpox-ojtxp,                      " Child Material Description
          menge       TYPE stpox-menge,                         "stpox-menge,"component qty
          meins       TYPE stpox-meins,                    "UOM
          bomfl       TYPE csbfl,                          "assembly indi
          mmein       TYPE stpox-mmein,                    "base UOM
          sobsl       TYPE stpox-sobsl,                 "special Proc Type
          bmtyp       TYPE stpox-bmtyp,                      "Bom category
          mtart       TYPE stpox-mtart,                      "Material Type
          beskz       TYPE keko-beskz,                                "PROC KEY
          xtlnr       TYPE stpox-xtlnr,           "Child Part BOM No
          stlan       TYPE stpox-stlan,         "BOM Usage
          stlnr       TYPE stpox-stlnr,         "Bill of material
          stlal       TYPE stpox-stlal,         "Alternative BOM
          lstar       TYPE ckis-lstar,           "Activity Type
          meeht       TYPE ckis-meeht,            "UOM
          typps       TYPE ckis-typps,         "item category
          infnr       TYPE ckis-infnr,        "Info Record
          labour_cost TYPE kbetr,  "ckis-wertn,            "ckis-wertn,
          mach_cost   TYPE kbetr,  "ckis-wertn, "char15,            "ckis-wertn,
          mat_cost    TYPE kbetr,  "ckis-wertn, "char15,            "ckis-wertn,
          sub_cost    TYPE kbetr,  "ckis-wertn,"char15,
          rate        TYPE ckis-gpreis,
          tot_cost    TYPE kbetr,  "kbetr, "char15,
          kalnr       TYPE keko-kalnr,            "Cost Estimate No
          kalka       TYPE keko-kalka,             "Costing Type
          kadky       TYPE keko-kadky,             "Costing Key Date
          feh_sta     TYPE keko-feh_sta,               "Costing Status
          substrat    TYPE keko-substrat,            "Info Rec
          klvar       TYPE keko-klvar,                "Costing Variant
          poper       TYPE keko-poper,                    "Posting Period
          plnnr       TYPE keko-plnnr,           "Routing No.
          tvers       TYPE keko-tvers,
          ncost       TYPE marc-ncost,    "do not cost
          VWEGX       TYPE STPOX-vwegx,    "PATH MULTI LEVEL BOM EXPLOSION

        END OF ty_final.


TYPES : BEGIN OF ty_down,

          werks       TYPE werks_d, "plant
          matnr       TYPE mast-matnr,                          "material of which BOM does exist
          idnrk       TYPE stpox-idnrk,                     "Chile Material
          ojtxp       TYPE stpox-ojtxp,                      " Child Material Description
          mtart       TYPE stpox-mtart,                      "Material Type
          beskz       TYPE keko-beskz,                                "PROC KEY
          feh_sta     TYPE keko-feh_sta,               "Costing Status
          sobsl       TYPE stpox-sobsl,                 "special Proc Type
          klvar       TYPE keko-klvar,                "Costing Variant
          poper       TYPE keko-poper,                    "Posting Period
          kadky       TYPE char20,    "keko-kadky,             "Costing Key Date
          kalka       TYPE keko-kalka,             "Costing Type
          tvers       TYPE keko-tvers,
*          plnnr       TYPE char20,
          infnr       TYPE ckis-infnr,
          typps       TYPE ckis-typps,
          rate        TYPE char20,
          menge       TYPE char17,            "stpox-menge,"component qty
          mmein       TYPE stpox-mmein,                    "base UOM
          mat_cost    TYPE ckis-wertn ,  "ckis-wertn, "char15,            "ckis-wertn,
          sub_cost    TYPE ckis-wertn,  "ckis-wertn,"char15,
          labour_cost TYPE ckis-wertn,  "ckis-wertn,            "ckis-wertn,
          mach_cost   TYPE ckis-wertn,  "ckis-wertn, "char15,            "ckis-wertn,
          tot_cost    TYPE kbetr,  "kbetr, "char15,
          ref_dat     TYPE char15,                         "Refresh Date
          ref_time    TYPE char15,                        "Refresh Time

        END OF ty_down.

DATA : lt_down TYPE TABLE OF ty_down,
       ls_down TYPE          ty_down.


DATA:BEGIN OF it_stpox OCCURS 1.
    INCLUDE STRUCTURE stpox.
DATA:END OF it_stpox.

DATA: it_stpox1 TYPE STANDARD TABLE OF stpox .  "INITIAL SIZE 10 WITH HEADER LINE.

DATA: wa_stpox  TYPE stpox,
      wa_stpox1 TYPE stpox.

DATA : it_matcat TYPE STANDARD TABLE OF cscmat, " WITH HEADER LINE.
       wa_matcat TYPE cscmat.


FIELD-SYMBOLS: <fs_mast>  TYPE ty_mast,
               <fs_error> TYPE ty_mast,
               <fs_stpox> TYPE stpox,
               <fs_final> TYPE ty_final.

DATA : ls_layout TYPE slis_layout_alv.
DATA : gt_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       gs_fieldcat TYPE slis_fieldcat_alv.

DATA : ls_line    TYPE slis_listheader,
       vn_top     TYPE slis_t_listheader,
       l_line(40),
       line       TYPE string.


DATA : it_event TYPE slis_t_event,
       wa_event LIKE LINE OF it_event.

DATA : fs_layout TYPE slis_layout_alv.

DATA : it_header TYPE slis_t_listheader,
       wa_header LIKE LINE OF it_header.

DATA: v_repid LIKE sy-repid.

DATA : it_top TYPE slis_t_listheader,
       wa_top TYPE slis_listheader.

DATA :it_final  TYPE TABLE OF ty_final,
      it_final1 TYPE TABLE OF ty_final,
      wa_final  TYPE ty_final,
      wa1_final  TYPE ty_final,
      wa_final1 TYPE ty_final.



DATA : lv_capid(4) TYPE c,


       lv_werks    TYPE mast-werks,
       lv_datum    TYPE keko-kadky,
       lv_emeng    TYPE stpo-menge,
       lv_index    TYPE sy-tabix,
       lv_num      TYPE i,
       lv_filename TYPE string,
       lv_msg(50)  TYPE c.



SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS : p_matnr    FOR mast-matnr  ,        "Part No
                 p_werks    FOR mast-werks   OBLIGATORY,       "Plant
                 p_klvar    FOR keko-klvar   ,"OBLIGATORY,      "Costing Variant
                 p_kalka    FOR keko-kalka   ,"OBLIGATORY,          "Costing Type
                 p_tvers    FOR keko-tvers   ,"OBLIGATORY,          "Costing Variant
                 p_feh      FOR keko-feh_sta ," OBLIGATORY,       "Costing Status
                 p_kadky    FOR keko-kadky  OBLIGATORY.        "Costing Key Date
Ranges:                p_kadky1    FOR keko-kadky."  no-DISPLAY.        "Costing Key Date

SELECTION-SCREEN : END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.


SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.


INITIALIZATION.

  v_repid = sy-repid.

START-OF-SELECTION.


  PERFORM fetch_data.
  PERFORM f_build_fcat.
  PERFORM f_display.
  PERFORM get_event.

*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .

  SELECT    matnr
            werks
            beskz
            sobsl
            ncost FROM marc INTO TABLE it_marc WHERE matnr IN p_matnr AND werks IN p_werks.

  SELECT matnr
         werks
         stlan
         stlnr
         stlal FROM mast INTO TABLE it_mast WHERE matnr IN p_matnr AND werks IN p_werks.


  SELECT kalnr
         kalka
         kadky
         matnr
         werks
         feh_sta
         substrat
         klvar
         poper
         plnnr
         sobsl
         beskz
         TVERS     FROM keko INTO TABLE it_keko WHERE   kadky  IN  p_kadky .

  IF it_keko IS NOT INITIAL.

    SELECT kalnr
           kalka
           kadky
           typps
           matnr
           gpreis
           wertn
           menge
           meeht
           lstar
           infnr FROM ckis INTO TABLE it_ckis1 FOR ALL ENTRIES IN it_keko
      WHERE kalnr = it_keko-kalnr AND kadky = p_kadky AND typps NE 'I'.

  ELSE.

    MESSAGE 'PLEASE ENTER VALID DATE' TYPE 'I' DISPLAY LIKE 'E'.

  ENDIF.

  it_mast1 = it_mast.
  it_keko1 = it_keko.
  it_final1 = it_final.

  LOOP AT it_mast1 INTO wa_mast1.

    wa_final1-matnr = wa_mast1-matnr.
    wa_final1-werks = wa_mast1-werks.
    wa_final1-stlan = wa_mast1-stlan.
    wa_final1-stlnr = wa_mast1-stlnr.
    wa_final1-stlal = wa_mast1-stlal.

    READ TABLE it_keko1 INTO wa_keko1 WITH  KEY matnr = wa_mast1-matnr werks = wa_mast1-werks.

    IF sy-subrc = 0.

      wa_final1-kalnr      = wa_keko1-kalnr.
      wa_final1-kalka      = wa_keko1-kalka.
      wa_final1-kadky      = wa_keko1-kadky.
      wa_final1-feh_sta    = wa_keko1-feh_sta.
      wa_final1-substrat   = wa_keko1-substrat.
      wa_final1-klvar      = wa_keko1-klvar.
      wa_final1-poper      = wa_keko1-poper.
      wa_final1-plnnr      = wa_keko1-plnnr.
      wa_final1-sobsl      = wa_keko1-sobsl.
      wa_final1-beskz      = wa_keko1-beskz.
      wa_final1-TVERS      = wa_keko1-TVERS.

   ENDIF.

   READ TABLE it_ckis1 INTO wa_ckis1 WITH KEY  kalnr = wa_keko1-kalnr kadky = wa_keko1-kadky typps = 'E'.
   IF sy-subrc ne 0.
     READ TABLE it_ckis1 INTO wa_ckis1 WITH KEY  kalnr = wa_keko1-kalnr kadky = wa_keko1-kadky typps = 'L'.
   ENDIF.
    IF sy-subrc = 0.

      wa_final1-kalka  = wa_ckis1-kalka.
      wa_final1-typps  = wa_ckis1-typps.
      wa_final1-lstar  = wa_ckis1-lstar.
      wa_final1-infnr  = wa_ckis1-infnr.
      wa_final1-menge  = wa_ckis1-menge.
      wa_final1-meeht  = wa_ckis1-meeht.

    ENDIF.

    IF wa_final1-lstar = 'LABOUR'.
      IF  wa_final1-typps = 'E'.
        wa_final1-labour_cost = wa_ckis1-wertn.
      ENDIF.
    ELSEIF wa_final1-lstar = 'MACHIN'.
      IF wa_final1-typps = 'E'.
        wa_final1-mach_cost = wa_ckis1-wertn.
      ENDIF.
    ENDIF.


    APPEND wa_final1 TO it_final1.
    CLEAR : wa_final1, wa_mast1, wa_keko1, wa_ckis1.
  ENDLOOP.

  LOOP AT it_mast INTO wa_mast.

    DATA : lv_date TYPE stko-datuv.
    lv_date = p_kadky-low.

    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        aumng                 = 0
        capid                 = 'PC01'          "lv_capid
        datuv                 = lv_date         "lv_datum
        ehndl                 = '1'
        emeng                 = '1'             "lv_emeng
        mktls                 = 'X'
        mehrs                 = 'X'
        mmory                 = '1'
        mtnrv                 = wa_mast-matnr
        stlan                 = wa_mast-stlan
        svwvo                 = 'X'
        werks                 = wa_mast-werks "lv_werks
        vrsvo                 = 'X'

      TABLES
        stb                   = it_stpox

      EXCEPTIONS
        alt_not_found         = 1
        call_invalid          = 2
        material_not_found    = 3
        missing_authorization = 4
        no_bom_found          = 5
        no_plant_data         = 6
        no_suitable_bom_found = 7
        conversion_error      = 8
        OTHERS                = 9.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    READ TABLE it_final1 INTO wa_final1 WITH KEY matnr = wa_mast-matnr .

    wa_stpox-stufe = wa_final1-stufe.
    wa_stpox-posnr  = wa_final1-posnr.
    wa_stpox-werks = wa_final1-werks.
    wa_stpox-idnrk = wa_final1-matnr.
    wa_stpox-ojtxp = wa_final1-ojtxp.
    wa_stpox-menge = wa_final1-menge.
    wa_stpox-meins = wa_final1-meins.
    wa_stpox-mmein = wa_final1-meeht.
    wa_stpox-sobsl = wa_final1-sobsl.
    wa_stpox-bmtyp = wa_final1-bmtyp.
    wa_stpox-mtart = wa_final1-mtart.
    wa_stpox-xtlnr = wa_final1-xtlnr.

    APPEND wa_stpox TO it_stpox.
    CLEAR : wa_stpox.

    DATA ld_result TYPE p DECIMALS 2.

    LOOP AT it_stpox INTO wa_stpox.

      wa_final-stufe = wa_stpox-stufe.
      wa_final-posnr = wa_stpox-posnr.
      wa_final-matnr = wa_mast-matnr.
      wa_final-werks = wa_stpox-werks.
      wa_final-idnrk = wa_stpox-idnrk.
      wa_final-ojtxp = wa_stpox-ojtxp.
      ld_result = round( val = wa_stpox-mngko dec = 2 ).
      wa_final-menge = ld_result.   "QUANTITY
      wa_final-meins = wa_stpox-meins.
      wa_final-mmein = wa_stpox-mmein.
      wa_final-sobsl = wa_stpox-sobsl.
      wa_final-bmtyp = wa_stpox-bmtyp.
      wa_final-mtart = wa_stpox-mtart.
      wa_final-xtlnr = wa_stpox-xtlnr.
      wa_final-vwegx = wa_stpox-vwegx.

      IF   wa_final-stufe = '0'.
        wa_final-idnrk = wa_final1-matnr .
      ENDIF.

      READ TABLE it_keko INTO wa_keko WITH KEY matnr = wa_final-matnr  werks = wa_final-werks .
        IF sy-subrc = 0.
         wa_final-kalka      = wa_keko-kalka.
         wa_final-kadky      = wa_keko-kadky.
         wa_final-feh_sta    = wa_keko-feh_sta.
         wa_final-substrat   = wa_keko-substrat.
         wa_final-klvar      = wa_keko-klvar.
         wa_final-poper      = wa_keko-poper.
         wa_final-TVERS      = wa_keko-TVERS.
        ENDIF.

      SELECT matnr bwkey kaln1 from mbew into TABLE it_mbew FOR ALL ENTRIES IN  it_stpox
      WHERE matnr =  it_stpox-idnrk AND bwkey =  it_stpox-werks .

      READ TABLE it_mbew into wa_mbew with key matnr = wa_final-idnrk bwkey = wa_final-werks.
        IF sy-subrc = 0.
           wa_final-kalnr = wa_mbew-kaln1.
        ENDIF.

      SELECT MATNR WERKS PLNNR FROM MAPL INTO TABLE IT_MAPL FOR ALL ENTRIES IN IT_STPOX
      WHERE MATNR = IT_STPOX-IDNRK AND WERKS = IT_STPOX-WERKS.
      IF sy-subrc = 0.
        READ TABLE IT_MAPL INTO WA_MAPL WITH KEY MATNR = WA_FINAL-IDNRK WERKS = WA_FINAL-WERKS.

      ENDIF.

*       if p_kadky is not initial.
*       P_KADKY1-OPTION = 'BT'.
*       P_KADKY1-HIGH = P_KADKY-low.
*       P_KADKY1-LOW =  p_kadky-low - 60.
*       P_KADKY1-SIGN = P_KADKY-SIGN.
*        APPEND p_kadky1 .
**       Endloop.
*        endif.
*
*      Loop at p_kadky.
*       P_KADKY-OPTION = 'LE'.
*       Modify p_kadky index sy-tabix transporting OPTION.
*      Endloop.


      IF it_mbew IS NOT INITIAL.
            SELECT  kalnr
                   kalka
                   kadky
                   typps
                   matnr
                   gpreis
                   wertn
                   menge
                   meeht
                   lstar
                   infnr FROM ckis INTO TABLE it_ckis FOR ALL ENTRIES IN it_mbew
            WHERE kalnr = it_mbew-kaln1  and kadky IN p_kadky .
        ENDIF.

        SORT it_ckis DESCENDING by kadky .

      SELECT SINGLE * FROM marc INTO wa_marc WHERE matnr = wa_final-idnrk AND werks = wa_final-werks .
      IF sy-subrc = 0.
        wa_final-beskz      = wa_marc-beskz.
        wa_final-ncost      = wa_marc-ncost.
      ENDIF.

      IF wa_final-stufe = '0'.
        READ TABLE it_ckis INTO wa_ckis WITH  KEY  kalnr = wa_final-kalnr kadky = wa_final-kadky typps = 'E'.
        IF sy-subrc NE 0.
          READ TABLE it_ckis INTO wa_ckis WITH  KEY  kalnr = wa_final-kalnr kadky = wa_final-kadky typps = 'L'.
        ENDIF.

        IF sy-subrc = 0.

          wa_final-typps = wa_ckis-typps.
          wa_final-infnr = wa_ckis-infnr.
          wa_final-lstar = wa_ckis-lstar.
          wa_final-menge = wa_ckis-menge.
          wa_final-meeht = wa_ckis-meeht.
          wa_final-rate = wa_ckis-gpreis.

          IF wa_final-plnnr IS NOT INITIAL.
            wa_final-typps = 'E'.
          ENDIF.

          IF wa_final-lstar = 'LABOUR'.
            IF  wa_final-typps = 'E'.
              wa_final-labour_cost =  ( wa_final-menge * wa_final-rate ).
            ENDIF.
          ELSEIF wa_final-lstar = 'MACHIN'.
            IF wa_final-typps = 'E'.
              wa_final-mach_cost =  ( wa_final-menge * wa_final-rate ).
            ENDIF.
          ELSE.
            wa_final-lstar = space.
            IF wa_final-typps = 'M'.
              wa_final-mat_cost =  ( wa_final-menge * wa_final-rate ).
            ELSEIF wa_final-typps = 'L'.
              wa_final-sub_cost =  ( wa_final-menge * wa_final-rate ).
            ENDIF.
          ENDIF.

          IF sy-subrc = 0.
            tot_cost1 = ( wa_final-labour_cost + wa_final-mach_cost + wa_final-mat_cost + wa_final-sub_cost ) .
            wa_final-tot_cost = tot_cost1.
          ENDIF.

        ENDIF.

     ELSE.
          refresh it_ckis2.
          LOOP AT it_ckis into wa_ckis where  kalnr = wa_final-kalnr and kadky in p_kadky ."p_kadky1  .commented for same date
            MOVE-CORRESPONDING wa_ckis to wa_ckis2.
            append wa_Ckis2 to it_Ckis2.
            clear: wa_ckis2,wa_ckis.
          ENDLOOP.

          READ TABLE it_ckis2 INTO wa_ckis WITH KEY  matnr = ' ' kalnr = wa_final-kalnr ."infnr = ' '.27.05.2022 matnr = ' '
          IF sy-subrc <> 0.
            if wa_final-SOBSL = 30.
           READ TABLE it_ckis INTO wa_ckis WITH KEY kalnr = wa_final-kalnr  typps = 'L' .
            elseif wa_final-SOBSL NE 30.
           READ TABLE it_ckis INTO wa_ckis with key  kalnr = wa_final-kalnr  typps =  'I' .
           endif.
          ENDIF.


        IF sy-subrc = 0.
          wa_final-typps = wa_ckis-typps.
          wa_final-infnr = wa_ckis-infnr.
          wa_final-lstar = wa_ckis-lstar.
          wa_final-meeht = wa_ckis-meeht.
          wa_final-rate = wa_ckis-gpreis.

          IF wa_final-plnnr IS NOT INITIAL.
            wa_final-typps = 'E'.
          ENDIF.

          IF  wa_final-typps = 'E' .
            wa_final-menge = ( wa_ckis-menge * ld_result ) .
          ENDIF.

          IF wa_final-lstar = 'LABOUR'.
            IF  wa_final-typps = 'E'.
              wa_final-labour_cost =  ( wa_final-menge * wa_final-rate ).
            ENDIF.
          ELSEIF wa_final-lstar = 'MACHIN'.
            IF wa_final-typps = 'E'.
              wa_final-mach_cost =  ( wa_final-menge * wa_final-rate ).
            ENDIF.
          ELSE.
            wa_final-lstar = space.
            IF wa_final-typps = 'I' .
              wa_final-mat_cost =  ( wa_final-menge * wa_final-rate ).
            ELSEIF wa_final-typps = 'L'.
              wa_final-sub_cost =  ( wa_final-menge * wa_final-rate ).
            ENDIF.
          ENDIF.

          IF sy-subrc = 0.
            tot_cost1 = ( wa_final-labour_cost + wa_final-mach_cost + wa_final-mat_cost + wa_final-sub_cost ) .
            wa_final-tot_cost = tot_cost1.
          ENDIF.

        ENDIF.

      ENDIF.

      IF wa_final-typps = 'E'.
        wa_final-mmein = 'MIN'.
      ENDIF.
      APPEND  wa_final TO it_final.
      CLEAR : wa_keko,  wa_final.

    ENDLOOP.
    CLEAR wa_mast.
  ENDLOOP.

LOOP AT IT_FINAL INTO WA_FINAL.
  IF wa_final-beskz = 'F' and wa_final-sobsl = ' ' and wa_final-XTLNR is NOT INITIAL.
    data(lv_index1) = SY-TABIX + 1.
    LOOP AT IT_FINAL INTO WA1_FINAL from  lv_index1 .
      IF  WA1_FINAL-stufe <= wa_final-stufe .
        exit.
      else.
       IF wa1_final-beskz = 'F' and wa1_final-sobsl = ' '.
        IF  WA1_FINAL-vwegx IS NOT INITIAL.
          WA1_FINAL-NCOST = 'X'.
          MODIFY IT_FINAL FROM WA1_FINAL TRANSPORTING ncost.
        ELSEIF WA1_FINAL-VWEGX IS INITIAL.
          EXIT.
        ENDIF.
      ENDIF.
      ENDIF.
    ENDLOOP.
    clear: wa1_final, lv_index1.
  ENDIF.

ENDLOOP.

LOOP AT IT_FINAL INTO WA_FINAL.
  IF wa_final-ncost = 'X'.
    DELETE it_final index sy-tabix.
  ENDIF.
endloop.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fcat .

  REFRESH gt_fieldcat.
   DATA(cnt) = 0.
  cnt = cnt + 1.
  PERFORM gt_fieldcatlog USING  :
         'WERKS'     'IT_FINAL'     'Plant'                             '1'           ,
         'MATNR'     'IT_FINAL'     'Parent Part No'                   '2'            ,
         'IDNRK'     'IT_FINAL'     'Child Part'                        '3'            ,
         'OJTXP'     'IT_FINAL'     'Child Part Desc'                   '4'            ,
         'MTART'     'IT_FINAL'     'Material Type'                     '5'            ,
         'BESKZ'     'IT_FINAL'     'Procurement Type'                  '6'            ,
         'FEH_STA'   'IT_FINAL'     'Costing Status'                    '7'            ,
         'SOBSL'     'IT_FINAL'     'Special Procurement Type'          '8'            ,
         'KLVAR'     'IT_FINAL'     'Costing Variant'                   '9'            ,
         'POPER'     'IT_FINAL'     'Posting period'                    '10'            ,
         'KADKY'     'IT_FINAL'     'Costing Key Date'                  '11'           ,
         'KALKA'     'IT_FINAL'     'Costing Type'                      '12'           ,
         'TVERS'     'IT_FINAL'     'Costing VERSON'                    '13'           ,
**         'PLNNR'     'IT_FINAL'     'Routing No'                        '13'           ,
         'INFNR'     'IT_FINAL'     'Info Record'                      '14'           ,
         'TYPPS'     'IT_FINAL'     'Item Category'                     '15'          ,
         'RATE'      'IT_FINAL'     'Rate'                               '17'         ,
         'MENGE'     'IT_FINAL'     'Bom Qty Child'                       '18'         ,
         'MMEIN'     'IT_FINAL'     'UOM'                                 '19'         ,
         'MAT_COST'     'IT_FINAL'     'Material Cost'                    '20'         ,
         'SUB_COST'     'IT_FINAL'     'Sub Con Cost'                     '21'         ,
         'LABOUR_COST'     'IT_FINAL'     'Labour Cost'                    '22'        ,
         'MACH_COST'     'IT_FINAL'     'Machine Cost'                    '23'         ,
         'TOT_COST'     'IT_FINAL'     'Total Cost '                      '24'         .
*        'KALNR'   'IT_FINAL'     'KALNR'                                 '25'         .
*         'stufe'     'IT_FINAL'     'level '                              '26'         ,
*         'ncost'     'IT_FINAL'     'NCOST '                              '27'         ,
*         'xtlnr'   'IT_FINAL'     'xtlnr'                                 '28'                         .





  fs_layout-colwidth_optimize = 'X'.
  fs_layout-zebra = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0993   text
*      -->P_0994   text
*      -->P_0995   text
*      -->P_0996   text
*----------------------------------------------------------------------*
FORM gt_fieldcatlog  USING   v1 v2 v3 v4 .

  gs_fieldcat-fieldname   = v1.
  gs_fieldcat-tabname     = v2.
  gs_fieldcat-seltext_l   = v3.
  gs_fieldcat-col_pos     = v4.

   APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR  gs_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      is_layout              = fs_layout
      i_callback_top_of_page = 'TOP_OF_PAGE'
      it_fieldcat            = gt_fieldcat[]
      i_save                 = 'X'
      it_events              = it_event
    TABLES
      t_outtab               = it_final
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.


  IF p_down = 'X'.

    PERFORM download.
    PERFORM download_file.

  ENDIF.

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
      i_list_type     = 0
    IMPORTING
      et_events       = it_event
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE it_event INTO wa_event WITH KEY name = 'TOP_OF_PAGE'.

  wa_event-form = 'TOP_OF_PAGE'.
  MODIFY it_event FROM wa_event INDEX sy-tabix.


ENDFORM.


FORM top_of_page.

  DATA : date1 TYPE string.

  wa_header-typ = 'H'.  "header
  wa_header-info = 'Multilevel BOM Display COST Wise'.
  APPEND wa_header TO it_header.
  CLEAR wa_header.

  CONCATENATE sy-datum+6(2) ' : ' sy-datum+4(2)' : ' sy-datum(4) INTO date1 SEPARATED BY space.

  wa_header-typ = 'S'. "selection
  wa_header-key = 'USER : '.
  wa_header-info = sy-uname.
  APPEND wa_header TO it_header.
  CLEAR wa_header.

  wa_header-typ = 'S'.
  wa_header-key = 'Current Date : '.
  wa_header-info = date1.
  APPEND wa_header TO it_header.
  CLEAR: wa_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_header
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
  CLEAR it_header.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .

  LOOP AT it_final INTO wa_final.

    IF sy-subrc = 0.

      ls_down-werks     = wa_final-werks.
      ls_down-matnr     = wa_final-matnr.
      ls_down-idnrk     = wa_final-idnrk.
      ls_down-ojtxp     = wa_final-ojtxp.
      ls_down-mtart     = wa_final-mtart.

      ls_down-beskz     = wa_final-beskz.
      ls_down-feh_sta   = wa_final-feh_sta.
      ls_down-sobsl     = wa_final-sobsl.
      ls_down-klvar     = wa_final-klvar.
      ls_down-poper     = wa_final-poper.

*      ls_down-kadky     = wa_final-kadky.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-kadky
        IMPORTING
          output = ls_down-kadky.

      CONCATENATE ls_down-kadky+0(2) ls_down-kadky+2(3) ls_down-kadky+5(4)
     INTO ls_down-kadky SEPARATED BY '-'.

      ls_down-kalka     = wa_final-kalka.
      ls_down-tvers     = wa_final-tvers.
      ls_down-infnr     = wa_final-infnr.
      ls_down-typps     = wa_final-typps.

      ls_down-rate      = wa_final-rate.
      ls_down-menge     = wa_final-menge.
      ls_down-mmein     = wa_final-mmein.
      ls_down-mat_cost  = wa_final-mat_cost.
      ls_down-sub_cost  = wa_final-sub_cost.
      ls_down-labour_cost = wa_final-labour_cost.
      ls_down-mach_cost   = wa_final-mach_cost.
      ls_down-tot_cost    = wa_final-tot_cost.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = ls_down-ref_dat.
      CONCATENATE ls_down-ref_dat+0(2) ls_down-ref_dat+2(3) ls_down-ref_dat+5(4)
     INTO ls_down-ref_dat SEPARATED BY '-'.

      ls_down-ref_time = sy-uzeit.
      CONCATENATE ls_down-ref_time+0(2) ':' ls_down-ref_time+2(2)  INTO ls_down-ref_time.

      APPEND ls_down TO lt_down.
      CLEAR: ls_down.

    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_file .

  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.


  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

*BREAK-POINT.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
**   I_FIELD_SEPERATOR          =
**   I_LINE_HEADER              =
**   I_FILENAME                 =
**   I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.
  lv_file = 'ZCO_BOM.TXT'.

  CONCATENATE p_folder '/' lv_file
  INTO lv_fullfile.
* BREAK primus.
  WRITE: / 'ZCO_BOM Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1024 TYPE string.
DATA lv_crlf_1024 TYPE string.
lv_crlf_1024 = cl_abap_char_utilities=>cr_lf.
lv_string_1024 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1024 lv_crlf_1024 wa_csv INTO lv_string_1024.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1024 TO lv_fullfile.
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
FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE    'Plant'
                 'Parent Part No'
                 'Child Part'
                 'Child Part Desc'
                 'Material Type'
                 'Procurement Type'
                 'Costing Status'
                 'Special Procurement Type'
                 'Costing Variant'
                 'Posting period'
                 'Costing Key Date'
                 'Costing Type'
                 'Costing VERSON'
                 'Info Record'
                 'Item Category'
                 'Rate'
                 'Bom Qty Child'
                 'UOM'
                 'Material Cost'
                 'Sub Con Cost'
                 'Labour Cost'
                 'Machine Cost'
                 'TOT_COST'

                 'Ref Date'
                 'Ref Time'

*                 'stufe'
*                 'ncost'
*                 'xtlnr'
      INTO p_hd_csv
      SEPARATED BY l_field_seperator..


ENDFORM.
