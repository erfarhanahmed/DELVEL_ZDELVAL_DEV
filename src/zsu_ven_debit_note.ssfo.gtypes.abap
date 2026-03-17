TYPES:
  BEGIN OF t_accounting_doc_hdr,
    bukrs TYPE bkpf-bukrs,
    belnr TYPE bkpf-belnr,
    gjahr TYPE bkpf-gjahr,
    budat TYPE bkpf-budat,
    blart TYPE bkpf-blart,
    xblnr TYPE bkpf-xblnr,
    bktxt TYPE bkpf-bktxt,
    waers TYPE bkpf-waers,
    kursf TYPE bkpf-kursf,
  END OF t_accounting_doc_hdr.


TYPES:
  BEGIN OF t_accounting_doc_item,
    bukrs   TYPE bseg-bukrs,
    belnr   TYPE bseg-belnr,
    gjahr   TYPE bseg-gjahr,
    buzei   TYPE bseg-buzei,
    BUZID   TYPE BSEG-BUZID,
    SHKZG   TYPE BSEG-SHKZG,
    dmbtr   TYPE bseg-dmbtr,
    WRBTR   TYPE bseg-dmbtr,
    sgtxt   TYPE bseg-sgtxt,
    kunnr   TYPE bseg-kunnr,
    KOSTL   TYPE bseg-KOSTL,
    lifnr   TYPE bseg-lifnr,
    PRCTR   TYPE bseg-PRCTR,
    hsn_sac TYPE bseg-hsn_sac,
  END OF t_accounting_doc_item,
  tt_accounting_doc_item TYPE STANDARD TABLE OF t_accounting_doc_item.

TYPES:
  BEGIN OF t_bset,
    bukrs TYPE bset-bukrs,
    belnr TYPE bset-belnr,
    gjahr TYPE bset-gjahr,
    hwste TYPE bset-hwste,
    fwste TYPE bset-hwste,
    kschl TYPE bset-kschl,
    kbetr TYPE bset-kbetr,
  END OF t_bset,
  tt_bset TYPE STANDARD TABLE OF t_bset.
