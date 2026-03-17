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

TYPES :BEGIN OF ty_final,
         bukrs TYPE bsak-bukrs,
         lifnr TYPE bsak-lifnr,
         gjahr TYPE bsak-gjahr,
         belnr TYPE bseg-belnr,

       END OF ty_final.


DATA: wa_t001           TYPE ty_t001 ##NEEDED,
      wa_lfa1           TYPE ty_lfa1 ##NEEDED,
      it_bkpf           TYPE TABLE OF ty_bkpf,
      wa_bkpf           TYPE  ty_bkpf,
      wa_header_details TYPE zstr_header_details_pay_advice ##NEEDED,
      it_final          TYPE ZPAYMENT_ADVICE_Tt,
      lt_final          TYPE TABLE OF ty_final,
      wa_final          TYPE  zpayment_advice_str,
      ls_final          TYPE  ty_final,
      fm_name           TYPE rs38l_fnam ##NEEDED,
      ls_ctrlop         TYPE ssfctrlop ##NEEDED,
      gv_job_output     TYPE ssfcrescl ##NEEDED,
      ls_outopt         TYPE ssfcompop ##NEEDED,
      it_excel          TYPE TABLE OF ty_excel ##NEEDED,
      wa_excel          TYPE ty_excel ##NEEDED.


TYPES : BEGIN OF ty_lfbk,
          lifnr TYPE lfbk-lifnr,
          banks TYPE lfbk-banks,
          bankl TYPE lfbk-bankl,
          bankn TYPE lfbk-bankn,
        END OF ty_lfbk.

DATA : it_lfbk TYPE TABLE OF ty_lfbk,
       wa_lfbk TYPE ty_lfbk,
       lt_bkpf TYPE TABLE OF bkpf,
       ls_bkpf TYPE bkpf.

DATA:     lv_dmbtr  TYPE bseg-dmbtr.

DATA : v_gjahr TYPE bsak-gjahr.
DATA:  v_belnr TYPE bsak-belnr.

DATA:lv_street TYPE string.
DATA:lv_timezone TYPE string.


TYPES : BEGIN OF gy_bseg,
          bukrs TYPE bseg-bukrs,
          belnr TYPE bseg-belnr,
          lifnr TYPE bseg-lifnr,
          gjahr TYPE bseg-gjahr,
          buzei TYPE bseg-buzei,
          dmbtr TYPE bseg-dmbtr,
          bschl TYPE bseg-bschl,
          koart TYPE bseg-koart,
          augbl TYPE bseg-augbl,
          ktosl TYPE bseg-ktosl,
          sgtxt TYPE bseg-sgtxt,
        END OF gy_bseg,
        BEGIN OF gy_bkpf,
          bukrs TYPE bkpf-bukrs,
          belnr TYPE bkpf-belnr,

          budat TYPE bkpf-budat,
        END OF gy_bkpf,
        BEGIN OF ty_with_item,
          bukrs    TYPE with_item-bukrs,
          belnr    TYPE with_item-belnr,
          buzei    TYPE with_item-buzei,
          wt_qsshh TYPE with_item-wt_qsshh,
          wt_qbshh TYPE with_item-wt_qsshh,
        END OF ty_with_item.

DATA: gt_gross     TYPE TABLE OF gy_bseg,
      gs_gross     TYPE gy_bseg,
      gt_bkpf      TYPE TABLE OF gy_bkpf,
      gs_bkpf      TYPE gy_bkpf,
      gt_with_item TYPE TABLE OF ty_with_item,
      gs_with_item TYPE  ty_with_item.

DATA:lwa_outputparams  TYPE sfpoutputparams.
DATA:lwa_result TYPE sfpjoboutput.
