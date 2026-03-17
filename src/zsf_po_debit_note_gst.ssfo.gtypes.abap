TYPES:
  BEGIN OF t_item,
    ebeln TYPE ekpo-ebeln,
    ebelp TYPE ekpo-ebelp,
    matnr TYPE ekpo-matnr,
    werks TYPE ekpo-werks,
    matkl TYPE ekpo-matkl,
    menge TYPE ekpo-menge,
    meins TYPE ekpo-meins,
    netpr TYPE ekpo-netpr,
    netwr TYPE ekpo-netwr,
    mwskz TYPE ekpo-mwskz,
    mtart TYPE ekpo-mtart,
  END OF t_item,
  tt_item TYPE STANDARD TABLE OF t_item.

TYPES:
  BEGIN OF t_mkpf,
    mblnr TYPE mkpf-mblnr,
    mjahr TYPE mkpf-mjahr,
    bldat TYPE mkpf-bldat,
    budat TYPE mkpf-budat,
    xblnr TYPE mkpf-xblnr,
    bktxt TYPE mkpf-bktxt,
    frbnr TYPE mkpf-frbnr,
  END OF t_mkpf,
  tt_mkpf TYPE STANDARD TABLE OF t_mkpf.

TYPES:
  BEGIN OF t_mseg,
    mblnr TYPE mseg-mblnr,
    mjahr TYPE mseg-mjahr,
    zeile TYPE mseg-zeile,
    matnr TYPE mseg-matnr,
    werks TYPE mseg-werks,
    ebeln TYPE mseg-ebeln,
    ebelp TYPE mseg-ebelp,
    lifnr TYPE mseg-lifnr,
    bukrs TYPE mseg-bukrs,
    grund TYPE mseg-grund,
  END OF t_mseg,
  tt_mseg TYPE STANDARD TABLE OF t_mseg.

TYPES:
  BEGIN OF t_ekko,
    ebeln TYPE ekko-ebeln,
    bukrs TYPE ekko-bukrs,
    aedat TYPE ekko-aedat,
    lifnr TYPE ekko-lifnr,
    ekorg TYPE ekko-ekorg,
    waers TYPE ekko-waers,
    bedat TYPE ekko-bedat,
    knumv TYPE ekko-knumv,
    lands TYPE ekko-lands,
  END OF t_ekko.

TYPES:
  BEGIN OF t_conditions,
    knumv TYPE konv-knumv,
    kposn TYPE konv-kposn,
    kschl TYPE konv-kschl,
    kbetr TYPE konv-kbetr,
    waers TYPE konv-waers,
    kwert TYPE konv-kwert,
  END OF t_conditions,
  tt_conditions TYPE STANDARD TABLE OF t_conditions.

TYPES:
  BEGIN OF t_mat_desc,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF t_mat_desc,
  tt_mat_desc TYPE STANDARD TABLE OF t_mat_desc.

TYPES:
  BEGIN OF t_t157e,
    bwart TYPE t157e-bwart,
    grund TYPE t157e-grund,
    grtxt TYPE t157e-grtxt,
  END OF t_t157e,
  tt_t157e TYPE STANDARD TABLE OF t_t157e.

TYPES:
  BEGIN OF t_bset,
    bukrs TYPE bset-bukrs,
    belnr TYPE bset-belnr,
    gjahr TYPE bset-gjahr,
    buzei TYPE bset-buzei,
    hwste TYPE bset-hwste,
    kschl TYPE bset-kschl,
    kbetr TYPE bset-kbetr,
  END OF t_bset,
  tt_bset TYPE STANDARD TABLE OF t_bset.



