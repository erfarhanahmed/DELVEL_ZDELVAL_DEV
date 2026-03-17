types : BEGIN OF ty_bkpf,
        bukrs type bkpf-bukrs,
       belnr type bkpf-belnr,
       gjahr type bkpf-gjahr,
       budat type bkpf-budat,
       usnam type bkpf-usnam,
       blart type bkpf-blart,
       waers type bkpf-waers,
       kursf TYPE bkpf-kursf,
       hwaer type bkpf-hwaer,
      END OF ty_bkpf.


TYPES : BEGIN OF ty_bseg,
        bukrs TYPE bseg-bukrs,
        gjahr TYPE bseg-gjahr,
        belnr type bseg-belnr,
        koart type bseg-koart,
        hkont type bseg-hkont,
        lifnr type bseg-lifnr,
        kunnr type bseg-kunnr,
        anln1  type bseg-anln1,
        dmbtr type bseg-dmbtr,
        shkzg  type bseg-shkzg,
        wrbtr type bseg-wrbtr,
        sgtxt type bseg-sgtxt,
        end of ty_bseg.

TYPES : BEGIN OF ty_lfa1,
        lifnr type lfa1-lifnr,
        name1 type lfa1-name1,
        end of ty_lfa1,

        BEGIN OF ty_kna1,
        kunnr type kna1-kunnr,
        name1 type kna1-kunnr,
        END OF ty_kna1,

        BEGIN OF ty_skat,
        saknr type skat-saknr,
        txt50 TYPE skat-txt50,
        END OF ty_skat,

         BEGIN OF ty_anla,
         anln1 type anla-anln1,
         txt50 TYPE anla-txt50,
         END OF ty_anla.






















