TYPES:
  BEGIN OF t_accounting_doc_hdr,
    bukrs     TYPE bkpf-bukrs,
    belnr     TYPE bkpf-belnr,
    gjahr     TYPE bkpf-gjahr,
    bldat     TYPE bkpf-bldat,
    budat     TYPE bkpf-budat,
    blart     TYPE bkpf-blart,
    xblnr     TYPE bkpf-xblnr,
    bktxt     TYPE bkpf-bktxt,
    waers     TYPE bkpf-waers,
    kursf     TYPE bkpf-kursf,
    xblnr_alt TYPE bkpf-xblnr_alt,
  END OF t_accounting_doc_hdr.


TYPES:
  BEGIN OF t_accounting_doc_item,
    bukrs   TYPE bseg-bukrs,
    belnr   TYPE bseg-belnr,
    gjahr   TYPE bseg-gjahr,
    buzei   TYPE bseg-buzei,
    dmbtr   TYPE bseg-dmbtr,
    sgtxt   TYPE bseg-sgtxt,
    kunnr   TYPE bseg-kunnr,
    lifnr   TYPE bseg-lifnr,
    hsn_sac TYPE bseg-hsn_sac,
  END OF t_accounting_doc_item,
  tt_accounting_doc_item TYPE STANDARD TABLE OF t_accounting_doc_item.

TYPES:
  BEGIN OF t_bset,
    bukrs TYPE bset-bukrs,
    belnr TYPE bset-belnr,
    gjahr TYPE bset-gjahr,
    hwste TYPE bset-hwste,
    kschl TYPE bset-kschl,
    kbetr TYPE bset-kbetr,
  END OF t_bset,
  tt_bset TYPE STANDARD TABLE OF t_bset.

TYPES:
  BEGIN OF t_makt,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF t_makt,
  tt_makt TYPE STANDARD TABLE OF t_makt.

TYPES:
  BEGIN OF t_ekpo,
    ebeln TYPE ekpo-ebeln,
    ebelp TYPE ekpo-ebelp,
    netpr TYPE ekpo-netpr,
  END OF t_ekpo,
  tt_ekpo TYPE STANDARD TABLE OF t_ekpo.
