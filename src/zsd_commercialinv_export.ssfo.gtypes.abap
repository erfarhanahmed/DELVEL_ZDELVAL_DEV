TYPES : BEGIN OF T_BOX,
          VBELN TYPE VBELN,
          POSNR TYPE POSNR,
          MATNR TYPE MATNR,
          MATKL TYPE MATKL,
          ARKTX TYPE ARKTX,
          LFIMG TYPE LFIMG,
          "GROES  TYPE GROES, " sIze/dimensions
        END OF T_BOX,

        BEGIN OF T_SZ,
          MATNR TYPE MATNR,
          GROES	TYPE GROES, " sIze/dimensions
        END OF T_SZ,

        TT_BOX TYPE TABLE OF T_BOX,
        TT_SZ TYPE TABLE OF T_SZ.

















