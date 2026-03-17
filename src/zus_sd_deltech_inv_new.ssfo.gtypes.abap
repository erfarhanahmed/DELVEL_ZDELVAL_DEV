TYPES : BEGIN OF t_box,
          vbeln TYPE vbeln,
          posnr TYPE posnr,
          matnr TYPE matnr,
          matkl TYPE matkl,
          arktx TYPE arktx,
          lfimg TYPE lfimg,
          "GROES  TYPE GROES, " sIze/dimensions
        END OF t_box,

        BEGIN OF t_sz,
          matnr TYPE matnr,
          groes	TYPE groes, " sIze/dimensions
        END OF t_sz,

        tt_box TYPE TABLE OF t_box,
        tt_sz  TYPE TABLE OF t_sz.

TYPES : BEGIN OF ty_lips,
          vbeln TYPE vbeln,
          posnr TYPE posnr,
          matnr TYPE matnr,
          matkl TYPE matkl,
          arktx TYPE arktx,
          lfimg TYPE lfimg,
          vgbel TYPE vgbel,
          vgpos TYPE vgpos,
        END OF ty_lips.

TYPES: BEGIN OF ty_pack,
         vhilm TYPE vekp-vhilm,
         pkcnt TYPE i,
         maktx TYPE makt-maktx,
         groes TYPE mara-groes,
       END OF ty_pack.

TYPES: BEGIN OF ty_adr,
         line LIKE adrs-line0,
       END OF ty_adr.

TYPES : BEGIN OF ty_konv,
          knumv TYPE konv-knumv,
          kschl TYPE konv-kschl,
          kawrt TYPE konv-kawrt,
          waers TYPE konv-waers,
          kwert TYPE konv-kwert,
          kinak TYPE konv-kinak,
          kstat TYPE konv-kstat,
        END OF ty_konv.

""""""""  Added By KD on 16.05.2017 """"""""
TYPES : BEGIN OF ty_total ,
          srno  TYPE i,
          kschl TYPE konv-kschl,
          text  TYPE char40,
          kwert TYPE konv-kwert,
          waers TYPE konv-waers,
        END OF ty_total .

TYPES: BEGIN OF ty_likp,
       VBELN TYPE likp-VBELN,
       VKORG TYPE likp-VKORG,
       VERUR TYPE likp-VERUR,
       END OF ty_likp.


""""""""""""""""""     END       """"""""""""
