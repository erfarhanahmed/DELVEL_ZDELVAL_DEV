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
       END OF ty_likp,

       BEGIN OF TY_DATA,
         VBELN TYPE LIPS-VBELN,
         POSNR TYPE LIPS-POSNR,
BOX_NO        TYPE  ZLOOSE_MATERIAL-BOX_NO,
LOOSE_ITEM   TYPE   ZLOOSE_MATERIAL-LOOSE_ITEM,
QUANTITY     TYPE ZLOOSE_MATERIAL-QUANTITY,
         END OF TY_DATA.

"26.08.2021 added by pankaj
TYPES : BEGIN OF ty_mat,
       VHILM_KU TYPE VHILM_KU,
       VBELN    TYPE VBELN,
       ZLMAT    TYPE ZLMAT,
       ZMATQN	  TYPE ZMATQN,
  END OF ty_mat.
