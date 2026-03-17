TYPES: GT_TYPESERNR_PRT LIKE KOMSER OCCURS 0.


Types: begin of tt_likp,
          vbeln TYPE likp-vbeln,
          zebeln  TYPE likp-zebeln,
          lfart TYPE likp-lfart,
         END OF tt_likp.

Types : begin of tt_ekpo,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          MATNR TYPE ekpo-matnr,
          menge TYPE ekpo-menge,
          meins TYPE ekpo-meins,
          netwr type ekpo-netwr,
          netpr type ekpo-netpr,
        end of tt_ekpo,

        tab_t_ekpo type table of tt_ekpo,

        begin of t_resb,
          matnr type matnr,
          BAUGR TYPE  RESB-BAUGR,
          ERFMG TYPE  RESB-ERFMG,
          ebeln type ebeln,
          ebelp type ebelp,
        end of t_resb,

        " STRUCTURE FOR ADDRESS "
        BEGIN OF T_ADRC,
          ADDRNUMBER TYPE AD_ADDRNUM, " ADDRESS NUMBER "
          NAME1 TYPE AD_NAME1,
          STR_SUPPL1 TYPE AD_STRSPP1, " STREET 1"
          STR_SUPPL2 TYPE AD_STRSPP2, " STREET 2 "
          STREET TYPE AD_STREET, " STREET "
          CITY1 TYPE  AD_CITY1, " CITY1"
          POST_CODE1 TYPE AD_PSTCD1, " POSTAL CODE "
          BEZEI TYPE BEZEI20, " REGION DESRIPTION "
          END OF T_ADRC,



        tab_t_resb type table of t_resb.







