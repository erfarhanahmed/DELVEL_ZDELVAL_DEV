*&---------------------------------------------------------------------*
*&  Include           ZPAYMENT_VOUCHER_DEC
*&---------------------------------------------------------------------*

TYPES : BEGIN OF ty_t001,
          bukrs TYPE t001-bukrs,
          butxt TYPE t001-butxt,
        END OF ty_t001,
        BEGIN OF ty_lfa1,
          lifnr      TYPE lfa1-lifnr,
          name1      TYPE lfa1-name1,
          street     TYPE adrc-street,
          city1      TYPE adrc-city1,
          post_code1 TYPE adrc-post_code1,
          adrnr      TYPE lfa1-adrnr,
        END OF ty_lfa1,
        BEGIN OF ty_bkpf,
          belnr TYPE bsak-belnr,
          bukrs TYPE bsak-bukrs,
          gjahr TYPE bsak-gjahr,
          augbl TYPE bsak-augbl,
          augdt TYPE bsak-augdt,
          blart TYPE bsak-blart,
          lifnr TYPE bsak-lifnr,
          budat TYPE bsak-budat,
          bldat TYPE bsak-bldat,
          xblnr TYPE bkpf-xblnr,
        END OF ty_bkpf,
        BEGIN OF ty_gross,
          bukrs TYPE bseg-bukrs, "ADDED BY SP ON 16.01.2024
          gjahr TYPE bseg-gjahr,  "ADDED BY SP ON 16.01.2024
          belnr TYPE bseg-belnr,
          buzei TYPE bseg-buzei, "ADDED BY SP ON 16.01.2024
          dmbtr TYPE bseg-dmbtr,
          bschl TYPE bseg-bschl,
          koart TYPE bseg-koart,    "ADDED BY SP ON 16.01.2024
          augbl TYPE bseg-augbl,    "ADDED BY SP ON 16.01.2024
          ktosl TYPE bseg-ktosl,
        END OF ty_gross,
        BEGIN OF ty_tds,
          bukrs TYPE bseg-bukrs,
          gjahr TYPE bseg-gjahr,
          belnr TYPE bseg-belnr,
          ktosl TYPE bseg-ktosl,
          dmbtr TYPE bseg-dmbtr,
          bschl TYPE bseg-bschl,
        END OF ty_tds
        .

TYPES: BEGIN OF ty_excel ,
         line1(50) TYPE c,
         line2(50) TYPE c,
         line3(50) TYPE c,
         line4(50) TYPE c,
         line5(50) TYPE c,
         line6(50) TYPE c,
         line7(50) TYPE c,
         line8(50) TYPE c,
         line9(50) TYPE c,
       END OF ty_excel.
DATA: wa_t001           TYPE ty_t001 ##NEEDED,
      wa_lfa1           TYPE ty_lfa1 ##NEEDED,
      wa_header_details TYPE zstr_header_details_pay_advice ##NEEDED,
      wa_bkpf           TYPE ty_bkpf ##NEEDED,
      it_bkpf           TYPE TABLE OF ty_bkpf ##NEEDED,
      it_gross          TYPE TABLE OF ty_gross ##NEEDED,
      it_gross_rej      TYPE TABLE OF ty_gross ##NEEDED,
      it_gross1         TYPE TABLE OF ty_gross ##NEEDED,
      it_gross3         TYPE TABLE OF ty_gross ##NEEDED,         "ADD SP ON 01.02.2024
      it_tds            TYPE TABLE OF ty_gross ##NEEDED,         "ADD SP ON 01.02.2024
      it_gross2         TYPE TABLE OF ty_gross ##NEEDED,
*      IT_TDS            TYPE TABLE OF TY_TDS ##NEEDED,
      it_final          TYPE ZPAYMENT_ADVICE_TT ##NEEDED,
      lt_final          TYPE TABLE OF zpayment_advice_str ##NEEDED,
      wa_final          TYPE  zpayment_advice_str ##NEEDED,
      ls_final           TYPE  zpayment_advice_str ##NEEDED,
      fm_name           TYPE rs38l_fnam ##NEEDED,
      ls_ctrlop         TYPE ssfctrlop ##NEEDED,
      gv_job_output     TYPE ssfcrescl ##NEEDED,
      ls_outopt         TYPE ssfcompop ##NEEDED,
      it_excel          TYPE TABLE OF ty_excel ##NEEDED,
      wa_excel          TYPE ty_excel ##NEEDED.

DATA : v_gjahr TYPE bsak-gjahr.
DATA:lv_street TYPE string.
DATA:lv_timezone TYPE string.

DATA: v_lifnr TYPE bsak-lifnr,
      v_augbl TYPE bsak-augbl.

TYPES: BEGIN OF ly_bkpf,
         belnr TYPE bkpf-belnr,
         xblnr TYPE bkpf-xblnr,
       END OF ly_bkpf.

DATA: lt_bkpf01 TYPE TABLE OF ly_bkpf,
      ls_bkpf01 TYPE ly_bkpf.

TYPES :BEGIN OF ty_bsak,
         bukrs TYPE bsak-bukrs,
         belnr TYPE bsak-belnr,
         gjahr TYPE bsak-gjahr,
         augbl TYPE bsak-augbl,
         dmbtr TYPE bsak-dmbtr,
         rebzg TYPE bsak-rebzg,
       END OF ty_bsak.

DATA:it_bsak TYPE TABLE OF ty_bsak,
     wa_bsak TYPE ty_bsak.
datA:lwa_result TYPE SFPJOBOUTPUT.
data:lwa_OUTPUTPARAMS  TYPE SFPOUTPUTPARAMS.
