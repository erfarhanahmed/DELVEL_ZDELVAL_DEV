FUNCTION-POOL zeinv_get_adrc_data.          "MESSAGE-ID ..

* INCLUDE LZEINV_GET_ADRC_DATAD...           " Local class definition

TYPES : BEGIN OF lty_vbrp,
          vbeln TYPE vbrp-vbeln,
          posnr TYPE vbrp-posnr,
          fkimg TYPE vbrp-fkimg,
          vrkme TYPE vbrp-vrkme,
          ntgew TYPE vbrp-ntgew,
          netwr TYPE vbrp-netwr,
          matnr TYPE vbrp-matnr,
          arktx TYPE vbrp-arktx,
          pstyv TYPE vbrp-pstyv,
          werks TYPE vbrp-werks,
          vgbel TYPE vbrp-vgbel,
        END OF lty_vbrp.

TYPES : BEGIN OF lty_t001w,
          werks TYPE t001w-werks,
          name1 TYPE t001w-name1,
          kunnr TYPE t001w-kunnr,
          lifnr TYPE t001w-lifnr,
          adrnr TYPE t001w-adrnr,
        END OF lty_t001w.

TYPES : BEGIN OF lty_kna1 ,
          kunnr TYPE kna1-kunnr,
          land1 TYPE kna1-land1,
          name1 TYPE kna1-name1,
          pstlz TYPE kna1-pstlz,
          regio TYPE kna1-regio,
          adrnr TYPE kna1-adrnr,
          stcd3 TYPE kna1-stcd3,
        END OF lty_kna1.

TYPES : BEGIN OF lty_adrc,
          addrnumber TYPE adrc-addrnumber,
          name1      TYPE adrc-name1,
          city1      TYPE adrc-city1,
          post_code1 TYPE adrc-post_code1,
          street     TYPE adrc-street,
          str_suppl1 TYPE adrc-str_suppl1,
          location   TYPE adrc-location,
          country    TYPE adrc-country,
          region     TYPE adrc-region,
          sort1      TYPE adrc-sort1,
          mc_city1   TYPE adrc-mc_city1,
        END OF lty_adrc.

TYPES: BEGIN OF lty_likp,
         vbeln TYPE likp-vbeln,
         vkorg TYPE likp-vkorg,
         vstel TYPE likp-vstel,
         kunnr TYPE likp-kunnr,
         kunag TYPE likp-kunag,
       END OF lty_likp.

TYPES  : BEGIN OF lty_j_1bbranch,
           bukrs  TYPE j_1bbranch-bukrs,
           branch TYPE j_1bbranch-branch,
           gstin  TYPE j_1bbranch-gstin,
         END OF lty_j_1bbranch.

TYPES : BEGIN OF lty_zstate_code,
          zstcode  TYPE zstate_code-zstcode,
          zsapcode TYPE zstate_code-zsapcode,
          zstdecr  TYPE zstate_code-zstdecr,
        END OF lty_zstate_code.
