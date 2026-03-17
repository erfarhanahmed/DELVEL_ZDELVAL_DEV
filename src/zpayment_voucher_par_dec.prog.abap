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
          str_suppl3 TYPE adrc-str_suppl3,
          location   TYPE adrc-location,
          time_zone  TYPE adrc-time_zone,
        END OF ty_lfa1,
*        BEGIN OF ty_bkpf,
*          belnr TYPE bsak-belnr,
*          bukrs TYPE bsak-bukrs,
*          gjahr TYPE bsak-gjahr,
*          augbl TYPE bsak-augbl,
*          augdt TYPE bsak-augdt,
*          blart TYPE bsak-blart,
*          xblnr TYPE bkpf-xblnr,
*          budat TYPE bkpf-budat,
*          bldat TYPE bkpf-bldat,
*        END OF ty_bkpf,
        BEGIN OF ty_gross,
          bukrs TYPE bseg-bukrs,
          gjahr TYPE bseg-gjahr,
          belnr TYPE bseg-belnr,
          buzei TYPE bseg-buzei,
          dmbtr TYPE bseg-dmbtr,
          bschl TYPE bseg-bschl,
          koart TYPE bseg-koart,
          augbl TYPE bseg-augbl,
          ktosl TYPE bseg-ktosl,
        END OF ty_gross,
        BEGIN OF ty_tds,
          bukrs TYPE bseg-bukrs,
          gjahr TYPE bseg-gjahr,
          belnr TYPE bseg-belnr,
          ktosl TYPE bseg-ktosl,
          dmbtr TYPE bseg-dmbtr,
          bschl TYPE bseg-bschl,
        END OF ty_tds        .

TYPES :BEGIN OF ty_bseg,
         bukrs TYPE bseg-bukrs,
         gjahr TYPE bseg-gjahr,
         belnr TYPE bseg-belnr,
         buzei TYPE bseg-buzei,
         dmbtr TYPE bseg-dmbtr,
         bschl TYPE bseg-bschl,
         koart TYPE bseg-koart,
         augbl TYPE bseg-augbl,
         ktosl TYPE bseg-ktosl,
       END OF ty_bseg.

TYPES :BEGIN OF ty_bseg_part,
         bukrs TYPE bseg-bukrs,
         gjahr TYPE bseg-gjahr,
         belnr TYPE bseg-belnr,
         buzei TYPE bseg-buzei,
         dmbtr TYPE bseg-dmbtr,
         bschl TYPE bseg-bschl,
         koart TYPE bseg-koart,
         augbl TYPE bseg-augbl,
         ktosl TYPE bseg-ktosl,
         rebzg TYPE bseg-rebzg,
         augdt TYPE bseg-augdt,
         REBZJ TYPE bseg-REBZJ,
       END OF ty_bseg_part.

TYPES:BEGIN OF gy_bsak,
        bukrs TYPE bsak-bukrs,
        belnr TYPE bsak-belnr,
        augbl TYPE bsak-augbl,
        gjahr TYPE bsak-gjahr,
        dmbtr TYPE bsak-dmbtr,
      END OF gy_bsak.

TYPES:BEGIN OF gy_bsik,
        bukrs TYPE bsik-bukrs,
        belnr TYPE bsik-belnr,
        gjahr TYPE bsik-gjahr,
        dmbtr TYPE bsik-dmbtr,
        rebzg TYPE bsik-rebzg,
        rebzj TYPE bsik-rebzj,
      END OF gy_bsik.

DATA:it_gross      TYPE TABLE OF ty_bseg,
     it_gross01    TYPE TABLE OF ty_bseg,
     it_gross_part TYPE TABLE OF ty_bseg_part,
     it_tds        TYPE TABLE OF ty_bseg,
     it_tds01      TYPE TABLE OF ty_bseg,
     wa_gross      TYPE  ty_bseg,
     wa_gross01    TYPE  ty_bseg,
     wa_gross_part TYPE  ty_bseg_part,
     wa_tds        TYPE  ty_bseg,
     wa_tds01      TYPE  ty_bseg.

DATA:gt_bsak   TYPE TABLE OF gy_bsak,
     gs_bsak   TYPE gy_bsak,
     gt_bsak01 TYPE TABLE OF gy_bsak,
     gs_bsak01 TYPE gy_bsak,
     gt_bsik   TYPE TABLE OF gy_bsik,
     gt_bsik01 TYPE TABLE OF gy_bsik,
     gs_bsik   TYPE gy_bsik,
     gs_bsik01 TYPE gy_bsik.

TYPES : BEGIN OF gy_bseg,
          belnr TYPE bseg-belnr,
          lifnr TYPE bseg-lifnr,
          koart TYPE bseg-koart,
          shkzg TYPE bseg-shkzg,
        END OF gy_bseg.

TYPES:BEGIN OF ty_bsik,
        bukrs TYPE bsik-bukrs,
        belnr TYPE bsik-belnr,
        rebzg TYPE bsik-rebzg,
        rebzj TYPE bsik-rebzj,
        lifnr TYPE bsik-lifnr,
      END OF ty_bsik.

TYPES:BEGIN OF ty_bsak,
        bukrs TYPE bsak-bukrs,
        belnr TYPE bsak-belnr,
        augbl TYPE bsak-augbl,
        gjahr TYPE bsak-gjahr,
        lifnr TYPE bsak-lifnr,
      END OF ty_bsak.
TYPES:BEGIN OF ty_bkpf,
        bukrs TYPE bkpf-bukrs,
        gjahr TYPE bkpf-gjahr,
        xblnr TYPE bkpf-xblnr,
        budat TYPE bkpf-budat,
        blart TYPE bkpf-blart,
        belnr TYPE bkpf-belnr,
        bldat TYPE bkpf-bldat,
      END OF ty_bkpf.

DATA:it_bsik TYPE TABLE OF  ty_bsik,
     it_bsak TYPE TABLE OF  ty_bsak,
     wa_bsik TYPE   ty_bsik,
     wa_bsak TYPE   ty_bsak.

DATA: gt_bseg TYPE TABLE OF gy_bseg,
      gs_bseg TYPE gy_bseg.

DATA : v_gjahr TYPE bkpf-gjahr.
DATA : v_belnr TYPE bkpf-belnr.

DATA:lv_street TYPE string.
DATA:lv_timezone TYPE string.
DATA:lv_dmbtr TYPE bseg-dmbtr.

DATA: wa_t001           TYPE ty_t001 ##NEEDED,
      wa_lfa1           TYPE ty_lfa1 ##NEEDED,
      it_lfa1           TYPE TABLE OF ty_lfa1 ##NEEDED,
      wa_header_details TYPE zstr_header_details_pay_advice ##NEEDED,
      wa_bkpf           TYPE ty_bkpf ##NEEDED,
      wa_bkpf01         TYPE ty_bkpf ##NEEDED,
      it_bkpf           TYPE TABLE OF ty_bkpf ##NEEDED,
      it_bkpf01         TYPE TABLE OF ty_bkpf ##NEEDED,
      it_gross_rej      TYPE TABLE OF ty_gross ##NEEDED,
      it_gross1         TYPE TABLE OF ty_gross ##NEEDED,
      it_gross3         TYPE TABLE OF ty_gross ##NEEDED,
      it_gross2         TYPE TABLE OF ty_gross ##NEEDED,
      it_final          TYPE TABLE OF zpayment_advice_str ##NEEDED,
      it_final01          TYPE TABLE OF zpayment_advice_str ##NEEDED,
      fm_name           TYPE rs38l_fnam ##NEEDED,
      ls_ctrlop         TYPE ssfctrlop ##NEEDED,
      gv_job_output     TYPE ssfcrescl ##NEEDED,
      ls_outopt         TYPE ssfcompop ##NEEDED.
data:lwa_OUTPUTPARAMS  TYPE SFPOUTPUTPARAMS.

datA:lwa_result TYPE SFPJOBOUTPUT.
