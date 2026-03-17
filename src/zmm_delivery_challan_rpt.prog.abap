*&---------------------------------------------------------------------*
*& Report ZMM_DELIVERY_CHALLAN_RPT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_delivery_challan_rpt.

TYPE-POOLS: slis.
DATA:
  tmp_chln_inv TYPE j_1ig_subcon-chln_inv,
  tmp_erdat    TYPE j_1ig_subcon-erdat,
*  tmp_budat    TYPE j_1ig_subcon-budat,
  tmp_ebeln    TYPE ekpo-ebeln,
  tmp_lgort    TYPE ekpo-lgort.


TYPES:
  BEGIN OF t_subcontracting,
    bukrs    TYPE j_1ig_subcon-bukrs,
    mblnr    TYPE j_1ig_subcon-mblnr,
    mjahr    TYPE j_1ig_subcon-mjahr,
    zeile    TYPE j_1ig_subcon-zeile,
    seq_no   TYPE j_1ig_subcon-seq_no,
    chln_inv TYPE j_1ig_subcon-chln_inv,
    item     TYPE j_1ig_subcon-item,
    fkart    TYPE j_1ig_subcon-fkart,
    erdat    TYPE j_1ig_subcon-erdat,
*    budat    TYPE j_1ig_subcon-budat,
    werks    TYPE j_1ig_subcon-werks,
    menge    TYPE j_1ig_subcon-menge,
    matnr    TYPE j_1ig_subcon-matnr,
    lifnr    TYPE j_1ig_subcon-lifnr,
    status   TYPE j_1ig_subcon-status,
  END OF t_subcontracting,
  tt_subcontracting TYPE STANDARD TABLE OF t_subcontracting.

TYPES:
  BEGIN OF t_purchasing_item,
    ebeln TYPE ekpo-ebeln,
    ebelp TYPE ekpo-ebelp,
    txz01 TYPE ekpo-txz01,
    matnr TYPE ekpo-matnr,
    werks TYPE ekpo-werks,
    menge TYPE ekpo-menge,
    meins TYPE ekpo-meins,
    netpr TYPE ekpo-netpr,
    mwskz TYPE ekpo-mwskz,
    lgort TYPE ekpo-lgort,
  END OF t_purchasing_item,
  tt_purchasing_item TYPE STANDARD TABLE OF t_purchasing_item.

TYPES:
  BEGIN OF t_vendor_info,
    lifnr TYPE lfa1-lifnr,
    name1 TYPE lfa1-name1,
    stcd3 TYPE lfa1-stcd3,
  END OF t_vendor_info,
  tt_vendor_info TYPE STANDARD TABLE OF t_vendor_info.

TYPES:
  BEGIN OF t_grn,
    mblnr TYPE mseg-mblnr,
    mjahr TYPE mseg-mjahr,
    zeile TYPE mseg-zeile,
    bwart TYPE mseg-bwart,
    matnr TYPE mseg-matnr,
    erfmg TYPE mseg-erfmg,
    erfme TYPE mseg-erfme,
    ebeln TYPE ekpo-ebeln,
    ebelp TYPE ekpo-ebelp,
    lgort TYPE ekpo-lgort,
  END OF t_grn,
  tt_grn TYPE STANDARD TABLE OF t_grn.

TYPES:
  BEGIN OF t_marc,
    matnr TYPE marc-matnr,
    werks TYPE marc-werks,
    steuc TYPE marc-steuc,
  END OF t_marc,
  tt_marc TYPE STANDARD TABLE OF t_marc.

TYPES:
  BEGIN OF t_tax_desc,
    mwskz TYPE t007s-mwskz,
    text1 TYPE t007s-text1,
    spras TYPE t007s-spras,
    kalsm TYPE t007s-kalsm,
  END OF t_tax_desc,
  tt_tax_desc TYPE STANDARD TABLE OF t_tax_desc.

TYPES:
  BEGIN OF t_purchase_hdr,
    ebeln TYPE ekko-ebeln,
    knumv TYPE ekko-knumv,
  END OF t_purchase_hdr,
  tt_purchase_hdr TYPE STANDARD TABLE OF t_purchase_hdr.

TYPES:
  BEGIN OF t_conditions,
    knumv TYPE prcd_elements-knumv,
    kposn TYPE prcd_elements-kposn,
    stunr TYPE prcd_elements-stunr,
    zaehk TYPE prcd_elements-zaehk,
    kschl TYPE prcd_elements-kschl,
    kbetr TYPE prcd_elements-kbetr,
    waers TYPE prcd_elements-waers,
    kwert TYPE prcd_elements-kwert,
  END OF t_conditions,
  tt_conditions TYPE STANDARD TABLE OF t_conditions.

TYPES:
  BEGIN OF t_mat_desc,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF t_mat_desc,
  tt_mat_desc TYPE STANDARD TABLE OF t_mat_desc.


TYPES:
  BEGIN OF t_final,
    mblnr    TYPE mseg-mblnr,
    ebeln    TYPE ekpo-ebeln,               "Purchase Doc No.
    ebelp    TYPE ekpo-ebelp,               "Purchase Line Item
    chln_inv TYPE j_1ig_subcon-chln_inv,    "CHallan Num
    fkart    TYPE j_1ig_subcon-fkart,       "Challan Type
    status   TYPE j_1ig_subcon-status,
    is_mat   TYPE mseg-matnr,               "Issue Material
    maktx    TYPE makt-maktx,               "Material Description
    matnr    TYPE mseg-matnr,               "Rec Material
    txz01    TYPE ekpo-txz01,               "LOng Txt
    name1    TYPE lfa1-name1,               "Vendor Name
    stcd3    TYPE lfa1-stcd3,               "GSTIN No.
    erfmg    TYPE mseg-erfmg,               "Qty to be recieved
    rec_qty  TYPE mseg-erfmg,               "actual Recieved qty.
    erfme    TYPE mseg-erfme,               "Unit
    pend_qty TYPE mseg-erfmg,               "Pending Qty
    netpr    TYPE ekpo-netpr,               "Rate
    mwskz    TYPE ekpo-mwskz,               "Tax Code
    steuc    TYPE marc-steuc,               "HSN Code
    chrg     TYPE prcd_elements-kwert,               "Other charges.
    text1    TYPE t007s-text1,              "Tax Description
    status1  TYPE string,
    lgort    TYPE mseg-lgort,               "Storage Location
  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.

DATA:
  gt_final TYPE tt_final.
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
SELECT-OPTIONS: so_chlan FOR tmp_chln_inv,
                so_erdat FOR tmp_erdat,
*                so_budat FOR tmp_budat,
                so_ebeln FOR tmp_ebeln.
PARAMETERS    : p_werks  TYPE j_1ig_subcon-werks DEFAULT 'PL01' OBLIGATORY.
SELECT-OPTIONS: so_s_loc FOR tmp_lgort.

PARAMETERS    : rad1 RADIOBUTTON GROUP ab DEFAULT 'X',
                rad2 RADIOBUTTON GROUP ab.
SELECTION-SCREEN: END OF BLOCK b1.

INITIALIZATION.
  xyz = 'Select Options'(tt1).


START-OF-SELECTION.
  PERFORM fetch_data CHANGING gt_final.
  PERFORM display USING gt_final.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM fetch_data  CHANGING ct_final TYPE tt_final.
  DATA:
    lt_subcontracting  TYPE tt_subcontracting,
    ls_subcontracting  TYPE t_subcontracting,
    lt_sub_rev         TYPE tt_subcontracting,
    ls_sub_rev         TYPE t_subcontracting,
    lt_mat_desc        TYPE tt_mat_desc,
    ls_mat_desc        TYPE t_mat_desc,
    lt_purchasing_item TYPE tt_purchasing_item,
    ls_purchasing_item TYPE t_purchasing_item,
    lt_purchase_hdr    TYPE tt_purchase_hdr,
    ls_purchase_hdr    TYPE t_purchase_hdr,
    lt_conditions      TYPE tt_conditions,
    ls_conditions      TYPE t_conditions,
    lt_vendor_info     TYPE tt_vendor_info,
    ls_vendor_info     TYPE t_vendor_info,
    lt_sub             TYPE tt_grn,         "541 Mvt
    ls_sub             TYPE t_grn,
    lt_grn             TYPE tt_grn,         "101 Mvt
    ls_grn1            TYPE t_grn,          "102
    ls_grn             TYPE t_grn,
    lt_marc            TYPE tt_marc,
    ls_marc            TYPE t_marc,
    lt_tax_desc        TYPE tt_tax_desc,
    ls_tax_desc        TYPE t_tax_desc,
    ls_final           TYPE t_final.

  DATA:
    lt_stb   TYPE STANDARD TABLE OF stpox,
    ls_stb   TYPE stpox,
    lv_index TYPE sy-tabix.

  "Fetch Challan Data
  SELECT bukrs
         mblnr
         mjahr
         zeile
         seq_no
         chln_inv
         item
         fkart
         erdat
*         budat
         werks
         menge
         matnr
         lifnr
         status
    FROM j_1ig_subcon
    INTO TABLE lt_subcontracting
    WHERE chln_inv IN so_chlan
    AND   erdat    IN so_erdat
*    AND   budat    IN so_budat
    AND   werks    = p_werks
    AND   bwart    = '541'.
*    AND   status   = 'C'.

  IF sy-subrc IS INITIAL.
    SELECT bukrs
     mblnr
     mjahr
     zeile
      seq_no
     chln_inv
     item
     fkart
     erdat
*     budat
     werks
     menge
     matnr
     lifnr
     status
FROM j_1ig_subcon
INTO TABLE lt_sub_rev
WHERE chln_inv IN so_chlan
AND   erdat    IN so_erdat
*AND   budat    IN so_budat
AND   werks    = p_werks
AND   bwart    = '542'.


    SELECT matnr
           maktx
      FROM makt
      INTO TABLE lt_mat_desc
      FOR ALL ENTRIES IN lt_subcontracting
      WHERE matnr = lt_subcontracting-matnr
      AND   spras = sy-langu.

    SELECT mblnr
           mjahr
           zeile
           bwart
           matnr
           erfmg
           erfme
           ebeln
           ebelp
           lgort
      FROM mseg
      INTO TABLE lt_sub
      FOR ALL ENTRIES IN lt_subcontracting
      WHERE mblnr = lt_subcontracting-mblnr
      AND   mjahr = lt_subcontracting-mjahr
*      AND   zeile = lt_subcontracting-zeile
      AND ebeln IN so_ebeln
*      AND lgort IN so_s_loc
      AND bwart = '541'
      AND xauto NE 'X'.

    SELECT ebeln
           ebelp
           txz01
           matnr
           werks
           menge
           meins
           netpr
           mwskz
           lgort
      FROM ekpo
      INTO TABLE lt_purchasing_item
      FOR ALL ENTRIES IN lt_sub
      WHERE ebeln = lt_sub-ebeln
      AND ebelp = lt_sub-ebelp
*      AND lgort = lt_sub-lgort.
    AND lgort IN so_s_loc.


    SELECT ebeln
           knumv
      FROM ekko
      INTO TABLE lt_purchase_hdr
      FOR ALL ENTRIES IN lt_purchasing_item
      WHERE ebeln = lt_purchasing_item-ebeln.

    IF sy-subrc IS INITIAL.
      SELECT knumv
             kposn
             stunr
             zaehk
             kschl
             kbetr
             waers
             kwert
        FROM prcd_elements
        INTO TABLE lt_conditions
        FOR ALL ENTRIES IN lt_purchase_hdr
        WHERE knumv = lt_purchase_hdr-knumv.

    ENDIF.
    SELECT mwskz
           text1
           spras
           kalsm
      FROM t007s
      INTO TABLE lt_tax_desc
      FOR ALL ENTRIES IN lt_purchasing_item
      WHERE mwskz = lt_purchasing_item-mwskz
      AND   spras = sy-langu.

    SELECT matnr
           werks
           steuc
      FROM marc
      INTO TABLE lt_marc
      FOR ALL ENTRIES IN lt_purchasing_item
      WHERE matnr = lt_purchasing_item-matnr
      AND   werks = lt_purchasing_item-werks.

    SELECT lifnr
           name1
           stcd3
      FROM lfa1
      INTO TABLE lt_vendor_info
      FOR ALL ENTRIES IN lt_subcontracting
      WHERE lifnr = lt_subcontracting-lifnr.

    IF NOT lt_purchasing_item IS INITIAL.
*      BREAK primus.
      SELECT mblnr
             mjahr
             zeile
             bwart
             matnr
             erfmg
             erfme
             ebeln
             ebelp
             lgort
        FROM mseg
        INTO TABLE lt_grn
        FOR ALL ENTRIES IN lt_purchasing_item
        WHERE ebeln = lt_purchasing_item-ebeln
        AND   ebelp = lt_purchasing_item-ebelp
        AND lgort = lt_purchasing_item-lgort
        AND  ( bwart = '101' OR bwart = '102' ).

    ENDIF.

  ENDIF.

  IF lt_subcontracting IS INITIAL.
    MESSAGE 'Data Not Found' TYPE 'E'.
  ENDIF.
  LOOP AT lt_subcontracting INTO ls_subcontracting.
    ls_final-chln_inv = ls_subcontracting-chln_inv.
    ls_final-fkart    = ls_subcontracting-fkart.
    ls_final-is_mat   = ls_subcontracting-matnr.
    ls_final-status   = ls_subcontracting-status.
    CASE ls_final-status.

      WHEN 'F'.
        ls_final-status1 = 'Fully Reconciled'.
      WHEN 'P'.
        ls_final-status1 = 'Partially Reconciled'.
      WHEN 'C'.
        ls_final-status1 = 'Challan Created'.
      WHEN 'D'.
        ls_final-status1 = 'Document Reversed'.
      WHEN 'R'.
        ls_final-status1 = 'Challan Reversed'.
      WHEN 'I'.
        ls_final-status1 = 'Invoice Created'.
      WHEN 'S'.
        ls_final-status1 = 'Invoice Reversed'.

*    	WHEN OTHERS.
    ENDCASE.

    READ TABLE lt_mat_desc INTO ls_mat_desc WITH KEY matnr = ls_subcontracting-matnr.
    IF sy-subrc IS INITIAL.
      ls_final-maktx = ls_mat_desc-maktx.
    ENDIF.
    READ TABLE lt_sub INTO ls_sub WITH KEY mblnr = ls_subcontracting-mblnr
                                           mjahr = ls_subcontracting-mjahr.
*                                           zeile = ls_subcontracting-zeile.
    IF sy-subrc IS INITIAL.
      ls_final-ebeln = ls_sub-ebeln.
      READ TABLE lt_purchasing_item INTO ls_purchasing_item WITH KEY ebeln = ls_sub-ebeln
                                                                     ebelp = ls_sub-ebelp.
*                                                                     lgort = ls_sub-lgort.
      IF sy-subrc IS INITIAL.

        ls_final-ebelp = ls_purchasing_item-ebelp.
        ls_final-matnr = ls_purchasing_item-matnr.
        ls_final-txz01 = ls_purchasing_item-txz01.
        ls_final-erfme = ls_purchasing_item-meins.
        ls_final-netpr = ls_purchasing_item-netpr.
        ls_final-mwskz = ls_purchasing_item-mwskz.
        ls_final-lgort = ls_purchasing_item-lgort.

        READ TABLE lt_grn INTO ls_grn WITH KEY ebeln = ls_sub-ebeln
                                               ebelp = ls_sub-ebelp.
        IF sy-subrc = 0.
          ls_final-mblnr = ls_grn-mblnr.

        ENDIF.


      ENDIF.

      READ TABLE lt_purchase_hdr INTO ls_purchase_hdr WITH KEY ebeln = ls_purchasing_item-ebeln.
      IF sy-subrc IS INITIAL.
        CLEAR ls_conditions.
        READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_purchase_hdr-knumv
                                                             kposn = ls_purchasing_item-ebelp
                                                             kschl = 'ZPFL'.
        IF sy-subrc IS INITIAL.
          ls_final-chrg = ls_conditions-kwert.
        ENDIF.

        CLEAR ls_conditions.
        READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_purchase_hdr-knumv
                                                             kposn = ls_purchasing_item-ebelp
                                                             kschl = 'ZPC1'.
        IF sy-subrc IS INITIAL.
          ls_final-chrg = ls_final-chrg + ls_conditions-kwert.
        ENDIF.

        CLEAR ls_conditions.
        READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_purchase_hdr-knumv
                                                             kposn = ls_purchasing_item-ebelp
                                                             kschl = 'ZPFV'.
        IF sy-subrc IS INITIAL.
          ls_final-chrg = ls_final-chrg + ls_conditions-kwert.
        ENDIF.

        CLEAR ls_conditions.
        READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_purchase_hdr-knumv
                                                             kposn = ls_purchasing_item-ebelp
                                                             kschl = 'ZRB1'.
        IF sy-subrc IS INITIAL.
          ls_final-chrg = ls_final-chrg + ls_conditions-kwert.
        ENDIF.

        CLEAR ls_conditions.
        READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_purchase_hdr-knumv
                                                             kposn = ls_purchasing_item-ebelp
                                                             kschl = 'ZRC1'.
        IF sy-subrc IS INITIAL.
          ls_final-chrg = ls_final-chrg + ls_conditions-kwert.
        ENDIF.

        CLEAR ls_conditions.
        READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_purchase_hdr-knumv
                                                             kposn = ls_purchasing_item-ebelp
                                                             kschl = 'FRA1'.
        IF sy-subrc IS INITIAL.
          ls_final-chrg = ls_final-chrg + ls_conditions-kwert.
        ENDIF.

        CLEAR ls_conditions.
        READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_purchase_hdr-knumv
                                                             kposn = ls_purchasing_item-ebelp
                                                             kschl = 'ZSCQ'.
        IF sy-subrc IS INITIAL.
          ls_final-chrg = ls_final-chrg + ls_conditions-kwert.
        ENDIF.

        CLEAR ls_conditions.
        READ TABLE lt_conditions INTO ls_conditions WITH KEY knumv = ls_purchase_hdr-knumv
                                                             kposn = ls_purchasing_item-ebelp
                                                             kschl = 'ZSCV'.
        IF sy-subrc IS INITIAL.
          ls_final-chrg = ls_final-chrg + ls_conditions-kwert.
        ENDIF.

      ENDIF.
      READ TABLE lt_tax_desc INTO ls_tax_desc WITH KEY mwskz = ls_purchasing_item-mwskz.
      IF sy-subrc IS INITIAL.
        ls_final-text1 = ls_tax_desc-text1.
      ENDIF.

      READ TABLE lt_vendor_info INTO ls_vendor_info WITH KEY lifnr = ls_subcontracting-lifnr.
      IF sy-subrc IS INITIAL.
        ls_final-name1 = ls_vendor_info-name1.
        ls_final-stcd3 = ls_vendor_info-stcd3.
      ENDIF.

      READ TABLE lt_marc INTO ls_marc WITH KEY matnr = ls_purchasing_item-matnr.
      IF sy-subrc IS INITIAL.
        ls_final-steuc = ls_marc-steuc.
      ENDIF.
      CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
        EXPORTING
          capid                 = 'PP01'
          datuv                 = sy-datum
          mktls                 = 'X'
          mtnrv                 = ls_purchasing_item-matnr
          stlal                 = '01'
          stlan                 = '1'
          stpst                 = '0'
          svwvo                 = 'X'
          werks                 = ls_purchasing_item-werks
          vrsvo                 = 'X'
        TABLES
          stb                   = lt_stb
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

*BREAK-POINT.
      READ TABLE lt_stb INTO ls_stb INDEX 1.
      READ TABLE lt_subcontracting INTO ls_subcontracting
                                   WITH KEY  chln_inv = ls_final-chln_inv
                                             matnr = ls_stb-idnrk.
      IF sy-subrc IS INITIAL.
        READ TABLE lt_sub_rev INTO ls_sub_rev
                              WITH KEY chln_inv = ls_final-chln_inv
                                       item     = ls_subcontracting-item.
        IF sy-subrc IS INITIAL.
          ls_final-erfmg = ( ls_subcontracting-menge - ls_sub_rev-menge )  / ls_stb-menge.
        ELSE.
          ls_final-erfmg = ls_subcontracting-menge / ls_stb-menge.
        ENDIF.

      ELSE.
        READ TABLE lt_sub_rev INTO ls_sub_rev
                              WITH KEY chln_inv = ls_final-chln_inv
                                       item     = ls_subcontracting-item.
        IF sy-subrc IS INITIAL.
          ls_final-erfmg = ls_purchasing_item-menge - ls_sub_rev-menge.
        ELSE.
          ls_final-erfmg = ls_purchasing_item-menge.
        ENDIF.
      ENDIF.

*      IF ls_final-lgort IS NOT INITIAL.
*        APPEND ls_final TO ct_final.
*        CLEAR: ls_final,ls_purchasing_item,ls_subcontracting,ls_sub,ls_purchase_hdr,ls_tax_desc,ls_grn.
*      ENDIF.
      APPEND ls_final TO ct_final.
      CLEAR: ls_final,ls_purchasing_item,ls_subcontracting,ls_sub,ls_purchase_hdr,ls_tax_desc,ls_grn.

    ENDIF.

  ENDLOOP.

  SORT ct_final BY ebeln ebelp.
  SORT lt_grn BY ebeln ebelp.
  DATA: lv_qty TYPE ekpo-menge.
  LOOP AT ct_final INTO ls_final.
*    BREAK primus.
    READ TABLE lt_grn INTO ls_grn WITH KEY bwart = '101' ebeln = ls_final-ebeln
                                           ebelp = ls_final-ebelp.
    IF sy-subrc IS INITIAL.




****      lv_index = sy-tabix.
****      CLEAR lv_qty.
****      LOOP AT lt_grn INTO ls_grn FROM lv_index.
****        IF ls_grn-ebeln = ls_final-ebeln AND ls_grn-ebelp = ls_final-ebelp.
      lv_qty = lv_qty + ls_grn-erfmg.
****        ELSE.
****          EXIT.
****        ENDIF.
****      ENDLOOP.
      ls_final-rec_qty  = lv_qty.
      ls_final-pend_qty = ls_final-erfmg - ls_final-rec_qty.
      MODIFY ct_final FROM ls_final TRANSPORTING rec_qty pend_qty.
    ENDIF.
    READ TABLE lt_grn INTO ls_grn1 WITH KEY bwart = '102' ebeln = ls_final-ebeln
                                        ebelp = ls_final-ebelp.
    IF sy-subrc = 0.

      ls_final-rec_qty  = ls_final-rec_qty - ls_grn1-erfmg.
      ls_final-pend_qty = ls_final-erfmg.
****      ls_final-pend_qty = ls_final-erfmg - ls_final-rec_qty.
      MODIFY ct_final FROM ls_final TRANSPORTING rec_qty pend_qty.
    ENDIF.
    CLEAR: ls_final,ls_grn,ls_grn1,lv_qty.
  ENDLOOP.

  SORT ct_final BY chln_inv.
  IF rad2 = 'X'.
    DELETE ADJACENT DUPLICATES FROM ct_final COMPARING chln_inv ebeln.
    DELETE ct_final WHERE fkart = 'ZSP'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM display  USING    ct_final TYPE tt_final.
  DATA:
    lt_fieldcat     TYPE slis_t_fieldcat_alv,
    ls_alv_layout   TYPE slis_layout_alv,
    l_callback_prog TYPE sy-repid.

  l_callback_prog = sy-repid.

  PERFORM prepare_display CHANGING lt_fieldcat.
  CLEAR ls_alv_layout.
  ls_alv_layout-zebra = 'X'.
  ls_alv_layout-colwidth_optimize = 'X'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = l_callback_prog
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
      is_layout               = ls_alv_layout
      it_fieldcat             = lt_fieldcat
    TABLES
      t_outtab                = ct_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM prepare_display  CHANGING ct_fieldcat TYPE slis_t_fieldcat_alv.

  DATA:
    gv_pos      TYPE i,
    ls_fieldcat TYPE slis_fieldcat_alv.

  REFRESH ct_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'EBELN'.
  ls_fieldcat-outputlen = '18'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Purchase Order No.'(100).
  ls_fieldcat-col_pos   = gv_pos.
  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'CHLN_INV'.
  ls_fieldcat-outputlen = '20'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Delivery Challan No.'(101).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FKART'.
  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Challan Type'(116).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  IF rad1 = 'X'.
    gv_pos = gv_pos + 1.
    ls_fieldcat-fieldname = 'IS_MAT'.
    ls_fieldcat-outputlen = '20'.
    ls_fieldcat-tabname   = 'GT_FINAL'.
    ls_fieldcat-seltext_m = 'Issued Material'(114).
    ls_fieldcat-col_pos   = gv_pos.
    APPEND ls_fieldcat TO ct_fieldcat.
    CLEAR ls_fieldcat.


    gv_pos = gv_pos + 1.
    ls_fieldcat-fieldname = 'MAKTX'.
    ls_fieldcat-outputlen = '40'.
    ls_fieldcat-tabname   = 'GT_FINAL'.
    ls_fieldcat-seltext_m = 'Material Description'(115).
    ls_fieldcat-col_pos   = gv_pos.
    APPEND ls_fieldcat TO ct_fieldcat.
    CLEAR ls_fieldcat.
  ENDIF.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MATNR'.
  ls_fieldcat-outputlen = '20'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Item Code'(102).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TXZ01'.
  ls_fieldcat-outputlen = '40'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Long Description'(103).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NAME1'.
  ls_fieldcat-outputlen = '30'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Vendor Name'(104).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STCD3'.
  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'GSTIN No.'(105).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STEUC'.
  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'HSN/SAC Code'(106).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ERFMG'.
  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Challan Qty.'(107).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'REC_QTY'.
  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Recieved Qty.'(108).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'PEND_QTY'.
  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Pending Qty.'(109).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NETPR'.
  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Rate'(110).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'CHRG'.
  ls_fieldcat-outputlen = '13'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Other Charges'(111).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MWSKZ'.
  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Tax Code'(112).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TEXT1'.
  ls_fieldcat-outputlen = '30'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Tax Code Description'(113).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'status1'.
  ls_fieldcat-outputlen = '30'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Challan Status'(117).
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LGORT'.
  ls_fieldcat-outputlen = '18'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Storage Location'.
  ls_fieldcat-col_pos   = gv_pos.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  UCOMM
*&---------------------------------------------------------------------*
*       Handlung of Commands on ALV
*----------------------------------------------------------------------*
*      -->U_UCOMM        USER COMMAND
*      -->U_SELFIELD     SELECT FIELD
*----------------------------------------------------------------------*
FORM ucomm_on_alv
     USING u_ucomm    TYPE sy-ucomm "#EC CALLED       "Form ucomm is called indirectly.
           u_selfield TYPE slis_selfield .

  DATA:
    ls_final     TYPE t_final,
    l_po_display TYPE tcode VALUE 'ME23N'.


  IF u_ucomm = '&IC1'.  "Klick on field

    READ TABLE gt_final
         INDEX u_selfield-tabindex
          INTO ls_final.
*   Code to Display Selected purchase order in report
    IF u_selfield-fieldname = 'EBELN' .
      IF u_selfield-value IS NOT INITIAL.
        SET PARAMETER ID 'BES'
            FIELD u_selfield-value.
        CALL TRANSACTION  l_po_display . "#EC CI_CALLTA       " Needs authorization for call transaction
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
