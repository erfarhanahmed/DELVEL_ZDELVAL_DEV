TYPES : BEGIN OF ty_mseg,
          mblnr TYPE mseg-mblnr,
          mjahr TYPE mseg-mjahr,
          zeile TYPE mseg-zeile,
          lgort TYPE mseg-lgort,    " add location
          menge TYPE mseg-menge,
          sgtxt TYPE mseg-sgtxt,
          matnr TYPE mseg-matnr,

*          lgort TYPE mseg-lgort, " storage location  :created by supriya:21:06:2024
        END OF ty_mseg,

        BEGIN OF ty_final,
        prueflos    TYPE qals-prueflos,
        matnr       TYPE QALS-matnr,
        rm01_menge  TYPE integer,     "mseg-menge,
        rj01_menge  TYPE integer,     "mseg-menge,
        rwk1_menge  TYPE integer,      "mseg-menge,
        scr1_menge  TYPE integer,      "mseg-menge,
        srn1_menge  TYPE integer,       "mseg-menge,
        MOCDES      TYPE ZMOC_DES,
        BUDAT       TYPE QALS-BUDAT,
        LGPBE TYPE MARD-LGPBE,
        END OF ty_final.

TYPES: BEGIN OF TY_MARD,
       MATNR TYPE MARD-MATNR,
       LGORT TYPE MARD-LGORT,
       LGPBE TYPE MARD-LGPBE,
       END OF TY_MARD.














