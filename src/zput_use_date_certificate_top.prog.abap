*&---------------------------------------------------------------------*
*&  Include           ZPUT_USE_DATE_CERTIFICATE_TOP
*&---------------------------------------------------------------------*

TYPES:BEGIN OF ty_mseg,
        BUKRS TYPE MSEG-BUKRS,
        anln1 TYPE mseg-anln1,
        anln2 TYPE mseg-anln2,
*       txt50 TYPE mseg-txt50,
        mblnr TYPE mseg-mblnr,
        budat_mkpf type mseg-budat_mkpf,
        ebeln TYPE mseg-ebeln,
        ebelp TYPE mseg-ebelp,
        matnr TYPE mseg-matnr,
        menge TYPE mseg-menge,
        lifnr TYPE mseg-lifnr,
      END OF ty_mseg,

      BEGIN OF ty_mkpf,
       mblnr TYPE mkpf-mblnr,
        budat TYPE mkpf-budat,
      END OF ty_mkpf,

      BEGIN OF ty_final,
        anln1 TYPE mseg-anln1,
        anln2 TYPE mseg-anln2,
        txt50 TYPE ANLA-txt50,
        mblnr TYPE mseg-mblnr,
        BUDAT_MKPF  TYPE mseg-BUDAT_MKPF ,
        ebeln TYPE mseg-ebeln,
        ebelp TYPE mseg-ebelp,
        matnr TYPE mseg-matnr,
        menge TYPE mseg-menge,
        lifnr TYPE mseg-lifnr,
        name1 TYPE lfa1-lifnr,
      END OF ty_final.

DATA: it_mseg  TYPE TABLE OF ty_mseg,
      it_mkpf  TYPE TABLE OF ty_mkpf,
      it_final TYPE TABLE OF ZPUT_DATE_STR,
      Lt_final TYPE TABLE OF ty_final,
      wa_final TYPE ZPUT_DATE_STR,
      LS_final TYPE ty_final,
      wa_mseg  TYPE ty_mseg.

DATA: v_pono TYPE mseg-ebeln,
      v_polt TYPE mseg-EBELP,
      v_asco TYPE mseg-anln1,
      v_mgno TYPE mseg-mblnr.


DATA: ls_ctrlop         TYPE ssfctrlop ##NEEDED,
      gv_job_output     TYPE ssfcrescl.
