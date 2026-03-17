
TYPES:
  BEGIN OF t_item,
    vbeln TYPE vbrp-vbeln,
    posnr TYPE vbrp-posnr,
    fkimg TYPE vbrp-fkimg,
    vrkme TYPE vbrp-vrkme,
    netwr TYPE vbrp-netwr,
    matnr TYPE vbrp-matnr,
    arktx TYPE vbrp-arktx,
    werks TYPE vbrp-werks,
    aubel TYPE vbrp-aubel,
    aupos TYPE vbrp-aupos,
  END OF t_item,
  tt_item TYPE STANDARD TABLE OF t_item.

TYPES:
  BEGIN OF t_conditions,
    knumv TYPE konv-knumv,
    kposn TYPE konv-kposn,
    kschl TYPE konv-kschl,
    kbetr TYPE konv-kbetr,
    waers TYPE konv-waers,
    kwert TYPE konv-kwert,
    kstat TYPE konv-kstat,
  END OF t_conditions,
  tt_conditions TYPE STANDARD TABLE OF t_conditions.

TYPES:
  BEGIN OF t_mat_desc,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF t_mat_desc,
  tt_mat_desc TYPE STANDARD TABLE OF t_mat_desc.


TYPES: BEGIN OF ty_stpo,
       STLTY TYPE stpo-STLTY,
       STLNR TYPE stpo-STLNR,
       STLKN TYPE stpo-STLKN,
       STPOZ TYPE stpo-STPOZ,
       aennr TYPE stpo-aennr,
       LKENZ TYPE stpo-LKENZ,
       IDNRK TYPE stpo-IDNRK,
       menge TYPE stpo-menge,
       END OF ty_stpo.












