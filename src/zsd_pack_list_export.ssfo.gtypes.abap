TYPES: gt_typesernr_prt LIKE komser OCCURS 0.

TYPES:BEGIN OF t_vepo,
        vbeln TYPE vepo-vbeln,
        posnr TYPE vepo-posnr,
        venum TYPE vepo-venum,
        vemng TYPE vepo-vemng,
      END OF t_vepo.

TYPES:BEGIN OF t_vekp,
        exidv    TYPE vekp-exidv,
        vhilm    TYPE vekp-vhilm,
        vhilm_ku TYPE vekp-vhilm_ku,
*BRGEW type vekp-BRGEW,
        ntgew    TYPE vekp-ntgew,
      END OF t_vekp.

TYPES:BEGIN OF t_makt,
        matnr TYPE makt-matnr,
        maktx TYPE makt-maktx,
      END OF t_makt.

TYPES: BEGIN OF ty_pack,
         vhilm TYPE vekp-vhilm,
         pkcnt TYPE i,
         maktx TYPE makt-maktx,
         groes TYPE mara-groes,
       END OF ty_pack.

TYPES: BEGIN OF ty_adr,
         line LIKE adrs-line0,
       END OF ty_adr.

TYPES: BEGIN OF ty_likp,
       VBELN TYPE likp-VBELN,
       VERUR TYPE likp-VERUR,
       END OF ty_likp.

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



