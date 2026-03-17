TYPES:
  BEGIN OF t_accounting_doc_hdr,
    bukrs TYPE bkpf-bukrs,
    belnr TYPE bkpf-belnr,
    gjahr TYPE bkpf-gjahr,
    blart TYPE bkpf-blart,
    budat TYPE bkpf-budat,
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
    shkzg   TYPE bseg-shkzg,
    wrbtr   TYPE bseg-wrbtr,
    fwbas   TYPE bseg-fwbas,
    sgtxt   TYPE bseg-sgtxt,
    kunnr   TYPE bseg-kunnr,
    lifnr   TYPE bseg-lifnr,
    vbel2   TYPE bseg-vbeln,
    hsn_sac TYPE bseg-hsn_sac,
  END OF t_accounting_doc_item,
  tt_accounting_doc_item TYPE STANDARD TABLE OF t_accounting_doc_item.

TYPES:
  BEGIN OF t_bset,
    bukrs TYPE bset-bukrs,
    belnr TYPE bset-belnr,
    gjahr TYPE bset-gjahr,
    buzei TYPE bset-buzei,
    shkzg TYPE bset-shkzg,
    hwbas TYPE bset-hwbas,
    fwbas TYPE bset-fwbas,
    hwste TYPE bset-hwste,
    fwste TYPE bset-fwste,
    kschl TYPE bset-kschl,
    kbetr TYPE bset-kbetr,
    mwskz TYPE bset-mwskz,
  END OF t_bset,
  tt_bset TYPE STANDARD TABLE OF t_bset.

TYPES : BEGIN OF ty_bseg_inv,
           BUKRS TYPE bseg-bukrs,
           BELNR TYPE bseg-belnr,
           GJAHR TYPE bseg-gjahr,
           BUZEI TYPE bseg-buzei,
           rebzg TYPE bseg-rebzg,
       END OF ty_bseg_inv.

