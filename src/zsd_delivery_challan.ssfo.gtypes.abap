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
    lgort TYPE vbrp-lgort,"added byjyoti on 13.06.2024
  END OF t_item,
  tt_item TYPE STANDARD TABLE OF t_item.

TYPES:
  BEGIN OF t_marc,
    matnr TYPE marc-matnr,
    werks TYPE marc-werks,
    steuc TYPE marc-steuc,
    dispo TYPE marc-dispo,
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
    bwart TYPE mseg-bwart,   "added by pankaj 12.10.2021
    matnr TYPE mseg-matnr,   "added by pankaj 12.10.2021
    ebeln TYPE mseg-ebeln,
    ebelp TYPE mseg-ebelp,
    lgort TYPE mseg-lgort,
  END OF t_mat_doc,
  tt_mat_doc TYPE STANDARD TABLE OF t_mat_doc.

TYPES:
  BEGIN OF t_purchasing,
    ebeln TYPE ekpo-ebeln,
    ebelp TYPE ekpo-ebelp,
    TXZ01 TYPE ekpo-TXZ01,  "added by pankaj 11.11.2021
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
    bwart    TYPE j_1ig_subcon-bwart,  "added by pankaj 12.10.2021
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

TYPES : BEGIN OF ty_vbrk,
        vbeln TYPE vbrk-vbeln,
        knumv TYPE vbrk-knumv,
        END OF ty_vbrk,

        BEGIN OF ty_konv,
        knumv TYPE konv-knumv,
        kposn TYPE konv-kposn,
        kschl TYPE konv-kschl,
        kawrt TYPE konv-kawrt,
        kbetr TYPE konv-kbetr,
        kwert TYPE konv-kwert,
        END OF ty_konv,

        BEGIN OF ty_final,
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
        cgst  TYPE konv-kbetr,
        cgst_amt TYPE konv-kwert,
        sgst  TYPE konv-kbetr,
        sgst_amt TYPE konv-kwert,
        igst  TYPE konv-kbetr,
        igst_amt TYPE konv-kwert,
        END OF ty_final.

"Added BY Snehal Rajale On 31.12.2020
TYPES : BEGIN OF ty_ekpo,
  EBELN TYPE ekpo-ebeln,
  EBELP TYPE ekpo-ebelp,
  knttp TYPE ekpo-knttp,
END OF ty_ekpo.

TYPES : BEGIN OF ty_makt,
  MATNR TYPE makt-matnr,
  SPRAS TYPE makt-spras,
  MAKTX TYPE makt-maktx,
END OF ty_makt.

TYPES : BEGIN OF ty_ekkn,
  EBELN TYPE ekkn-ebeln,
  EBELP TYPE ekkn-ebelp,
  ZEKKN TYPE ekkn-zekkn,
  VBELN TYPE ekkn-vbeln,
  VBELP TYPE ekkn-vbelp,
END OF ty_ekkn.

TYPES :   BEGIN OF ty_vbap,
  vbeln TYPE vbap-vbeln,
  posnr TYPE vbap-posnr,
  zce TYPE vbap-zce,
  ZGAD TYPE vbap-zgad,
END OF ty_vbap.

TYPES : BEGIN OF ty_marc,
  MATNR TYPE marc-matnr,
  WERKS TYPE marc-werks,
  dispo TYPE marc-dispo,
END OF ty_marc.

TYPES: BEGIN OF ty_mseg,
       mblnr  TYPE mseg-mblnr,
       MJAHR  TYPE mseg-MJAHR,
       ZEILE  TYPE mseg-ZEILE,
       BWART  TYPE mseg-BWART,
       XAUTO  TYPE mseg-XAUTO,
       MATNR  TYPE mseg-MATNR,
       WERKS  TYPE mseg-WERKS,
       MENGE  TYPE mseg-MENGE,
       MEINS  TYPE mseg-MEINS,
       EBELN  TYPE mseg-EBELN,
       EBELP  TYPE mseg-EBELP,
       END OF ty_mseg.

***************added by jyoti on 13.06.2024*****************
 TYPES : BEGIN OF ty_adrc,
          addrnumber TYPE ad_addrnum, " ADDRESS NO"
*          name_co    TYPE ad_name_co, " COMPANY NAME  "
          name1      TYPE adrc-name1,
          str_suppl1 TYPE ad_strspp1, " STREET 2 "
          str_suppl2 TYPE ad_strspp2, " STREET 3 "
          street     TYPE ad_street, " STREET "
          city1      TYPE ad_city1, " CITY1 "
          post_code1 TYPE ad_pstcd1, " POSTCODE 1 "
*          time_zone  TYPE ad_tzone, " TIME ZONE(COUNTRY) "
          bezei      TYPE bezei20,    " REGION DESRIPTION "
          country    TYPE adrc-country,
          tel_number TYPE adrc-tel_number,
          fax_number TYPE adrc-fax_number,
          extension2 TYPE adrc-extension2,
          smtp_addr  TYPE adr6-smtp_addr,
          landx      TYPE t005t-landx,  "Country name
          cin        TYPE adrct-remark,
        END OF ty_adrc.
**************************************************
