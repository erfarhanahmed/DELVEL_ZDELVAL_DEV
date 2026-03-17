TYPES:
  BEGIN OF t_item,
    vbeln TYPE vbrp-vbeln,
    posnr TYPE vbrp-posnr,
    vgbel TYPE vbrp-vgbel,
    vgpos TYPE vbrp-vgpos,
    matnr TYPE vbrp-matnr,
    arktx TYPE vbrp-arktx,
    fkimg TYPE vbrp-fkimg,
    vrkme TYPE vbrp-vrkme,
    netwr TYPE vbrp-netwr,
    werks TYPE vbrp-werks,
  END OF t_item,
  tt_item TYPE STANDARD TABLE OF t_item.

TYPES:
  BEGIN OF t_marc,
    matnr TYPE marc-matnr,
    werks TYPE marc-werks,
    steuc TYPE marc-steuc,
  END OF t_marc,
  tt_marc TYPE STANDARD TABLE OF t_marc.


TYPES:
  BEGIN OF t_mat_desc,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF t_mat_desc,
  tt_mat_desc TYPE STANDARD TABLE OF t_mat_desc.

TYPES:
  BEGIN OF t_mat_doc,
    mblnr TYPE mseg-mblnr,
    mjahr TYPE mseg-mjahr,
    zeile TYPE mseg-zeile,
    ebeln TYPE mseg-ebeln,
    ebelp TYPE mseg-ebelp,
  END OF t_mat_doc,
  tt_mat_doc TYPE STANDARD TABLE OF t_mat_doc.

TYPES:
  BEGIN OF t_purchasing,
    ebeln TYPE ekpo-ebeln,
    ebelp TYPE ekpo-ebelp,
    matnr TYPE ekpo-matnr,
    menge TYPE ekpo-menge,
    meins TYPE ekpo-meins,
    mwskz TYPE ekpo-mwskz,
    werks TYPE ekpo-werks,
    netwr TYPE ekpo-netwr,
  END OF t_purchasing,
  tt_purchasing TYPE STANDARD TABLE OF t_purchasing.


TYPES:
  BEGIN OF t_j_1ig_subcon,
    bukrs    TYPE j_1ig_subcon-bukrs,
    mblnr    TYPE j_1ig_subcon-mblnr,
    mjahr    TYPE j_1ig_subcon-mjahr,
    zeile    TYPE j_1ig_subcon-zeile,
    chln_inv TYPE j_1ig_subcon-chln_inv,
    item     TYPE j_1ig_subcon-item,
    menge    TYPE j_1ig_subcon-menge,
    meins    TYPE j_1ig_subcon-meins,
    matnr    TYPE j_1ig_subcon-matnr,
  END OF t_j_1ig_subcon,
  tt_j_1ig_subcon TYPE STANDARD TABLE OF t_j_1ig_subcon.

TYPES:
  BEGIN OF t_konp,
    knumh TYPE konp-knumh,
    kopos TYPE konp-kopos,
    kschl TYPE konp-kschl,
  END OF t_konp,
  tt_konp TYPE STANDARD TABLE OF t_konp.

  TYPES :
  BEGIN OF t_conditions,
    knumv TYPE konv-knumv,
    kposn TYPE konv-kposn,
    kschl TYPE konv-kschl,
    kwert TYPE konv-kwert,
    kbetr TYPE komv-kbetr,
  END OF t_conditions,
  tt_conditions TYPE STANDARD TABLE OF t_conditions.

* TYPES: BEGIN OF ty_mkpf,
*        mblnr TYPE mkpf-mblnr,
*        bktxt TYPE mkpf-bktxt,
*       END OF ty_mkpf,
*TT_MKPF TYPE STANDARD TABLE OF TY_MKPF.
