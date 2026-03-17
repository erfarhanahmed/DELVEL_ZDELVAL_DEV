*&---------------------------------------------------------------------*
*&  Include           ZTMP2_DM_TOP
*&---------------------------------------------------------------------*

TYPES: fs_struct(4096) TYPE c OCCURS 0 .
DATA: w_struct TYPE fs_struct.
*Structure for error message
TYPES : BEGIN OF ty_s_error,
          msg_err(180) TYPE c,
        END OF ty_s_error.

TYPES : BEGIN OF ty_s_info,
          info_msg(60) TYPE c,
        END OF ty_s_info.

* Structure Decleration
TYPES : BEGIN OF x_field, "cust open item invoice
          bldat   TYPE bkpf-bldat,
          blart   TYPE bkpf-blart,
          bukrs   TYPE bkpf-bukrs,
          budat   TYPE bkpf-budat,
*          monat   TYPE bkpf-monat,
          waers   TYPE bkpf-waers,
          xblnr   TYPE bkpf-xblnr,
          bktxt   TYPE bkpf-bktxt,
          newbs_1 TYPE rf05a-newbs,
          newko_1 TYPE rf05a-newko,
          wrbtr_1 TYPE bseg-wrbtr,
          dmbtr_1 TYPE bseg-dmbtr,
          mwskz   TYPE bseg-mwskz,
          bupla   TYPE bseg-bupla,
          secco   TYPE bseg-secco,
          gsber_1 TYPE bseg-gsber,
          zterm_1 TYPE bseg-zterm,
          zfbdt   TYPE bseg-zfbdt,
          zuonr_1 TYPE bseg-zuonr,
          sgtxt_1 TYPE bseg-sgtxt,
          newbs_2 TYPE rf05a-newbs,
          newko_2 TYPE rf05a-newko,
          wrbtr_2 TYPE bseg-wrbtr,
          dmbtr_2 TYPE bseg-dmbtr,
          zterm_2 TYPE bseg-zterm,
*          valut   TYPE bseg-valut,
          gsber_2 TYPE cobl-gsber,
          zuonr_2 TYPE bseg-zuonr,
          sgtxt_2 TYPE bseg-sgtxt,
        END OF x_field.
DATA :fs_field TYPE x_field.
DATA: t_field   TYPE TABLE OF x_field.

TYPES : BEGIN OF x_field1, " vendor open item invoice
          bldat   TYPE bkpf-bldat,
          blart   TYPE bkpf-blart,
          bukrs   TYPE bkpf-bukrs,
          budat   TYPE bkpf-budat,
*          monat   TYPE bkpf-monat,
          waers   TYPE bkpf-waers,
          xblnr   TYPE bkpf-xblnr,
          bktxt   TYPE bkpf-bktxt,
          newbs_1 TYPE rf05a-newbs,
          newko_1 TYPE rf05a-newko,
          wrbtr_1 TYPE bseg-wrbtr,
          dmbtr_1 TYPE bseg-dmbtr,
          mwskz   TYPE bseg-mwskz,
          bupla   TYPE bseg-bupla,
          secco   TYPE bseg-secco,
          gsber_1 TYPE bseg-gsber,
          zterm_1 TYPE bseg-zterm,
          zfbdt   TYPE bseg-zfbdt,
          zuonr_1 TYPE bseg-zuonr,
          sgtxt_1 TYPE bseg-sgtxt,
          newbs_2 TYPE rf05a-newbs,
          newko_2 TYPE rf05a-newko,
          wrbtr_2 TYPE bseg-wrbtr,
          dmbtr_2 TYPE bseg-dmbtr,
          gsber_2 TYPE cobl-gsber,
          zterm_2 TYPE bseg-zterm,
*          valut   TYPE bseg-valut,
          zuonr_2 TYPE bseg-zuonr,
          sgtxt_2 TYPE bseg-sgtxt,

        END OF x_field1.
DATA : fs_field1 TYPE x_field1.
DATA: t_field1   TYPE TABLE OF x_field1.

TYPES : BEGIN OF x_field2, " Customer Open items Downpayment
          bldat   TYPE bkpf-bldat,
          blart   TYPE bkpf-blart,
          bukrs   TYPE bkpf-bukrs,
          budat   TYPE bkpf-budat,
*          monat   TYPE bkpf-monat,
          waers   TYPE bkpf-waers,
          xblnr   TYPE bkpf-xblnr,
          bktxt   TYPE bkpf-bktxt,
          newbs_1 TYPE rf05a-newbs,
          newko_1 TYPE rf05a-newko,
          newum   TYPE   rf05a-newum,
          wrbtr_1 TYPE bseg-wrbtr,
          dmbtr_1 TYPE bseg-dmbtr,
          bupla   TYPE bseg-bupla,
          secco   TYPE bseg-secco,
          gsber_1 TYPE bseg-gsber,
          zfbdt   TYPE bseg-zfbdt,
          zuonr_1 TYPE bseg-zuonr,
          sgtxt_1 TYPE bseg-sgtxt,
          newbs_2 TYPE rf05a-newbs,
          newko_2 TYPE rf05a-newko,
          wrbtr_2 TYPE bseg-wrbtr,
          dmbtr_2 TYPE bseg-dmbtr,
*          bupla_2 type BSEG-BUPLA,
          gsber_2 TYPE bseg-gsber,
          zuonr_2 TYPE bseg-zuonr,
          sgtxt_2 TYPE bseg-sgtxt,
        END OF x_field2.
DATA : fs_field2 TYPE x_field2,
       t_field2  TYPE STANDARD TABLE OF x_field2.

TYPES : BEGIN OF x_field3, "Vendor Open Items Downpayment
          bldat   TYPE bkpf-bldat,
          blart   TYPE bkpf-blart,
          bukrs   TYPE bkpf-bukrs,
          budat   TYPE bkpf-budat,
*          monat   TYPE bkpf-monat,
          waers   TYPE bkpf-waers,
          xblnr   TYPE bkpf-xblnr,
          bktxt   TYPE bkpf-bktxt,
          newbs_1 TYPE rf05a-newbs,
          newko_1 TYPE rf05a-newko,
          newum   TYPE   rf05a-newum,
          wrbtr_1 TYPE bseg-wrbtr,
          dmbtr_1 TYPE bseg-dmbtr,
          bupla   TYPE bseg-bupla,
          secco   TYPE bseg-secco,
          gsber_1 TYPE bseg-gsber,
          zfbdt   TYPE bseg-zfbdt,
          zuonr_1 TYPE bseg-zuonr,
          sgtxt_1 TYPE bseg-sgtxt,
          newbs_2 TYPE rf05a-newbs,
          newko_2 TYPE rf05a-newko,
          wrbtr_2 TYPE bseg-wrbtr,
          dmbtr_2 TYPE bseg-dmbtr,
*          bupla_2 type BSEG-BUPLA,
          gsber_2 TYPE cobl-gsber,
          zuonr_2 TYPE bseg-zuonr,
          sgtxt_2 TYPE bseg-sgtxt,
        END OF x_field3.
DATA : fs_field3 TYPE x_field3,
       t_field3  TYPE STANDARD TABLE OF x_field3.

TYPES : BEGIN OF x_field4, " Internal Order
          auart TYPE coas-auart,
          refnr TYPE coas-refnr,
          bukrs TYPE coas-bukrs,
          aufex TYPE coas-aufex,
          user0 TYPE coas-user0,
          user2 TYPE coas-user2,
        END OF x_field4.
DATA : fs_field4 TYPE x_field4,
       t_field4  TYPE STANDARD TABLE OF x_field4.


TYPES : BEGIN OF x_field5, "Cost Center
          kostl TYPE csksz-kostl,
          datab TYPE rkma2-datab,
          bukrs TYPE csksz-bukrs,
        END OF x_field5.
DATA: fs_field5 TYPE x_field5,
      t_field5  TYPE STANDARD TABLE OF x_field5.

TYPES : BEGIN OF x_field6,  " G/L & Bank Open items
          bldat   TYPE bkpf-bldat,
          blart   TYPE bkpf-blart,
          bukrs   TYPE bkpf-bukrs,
          budat   TYPE bkpf-budat,
          waers   TYPE bkpf-waers,
          xblnr   TYPE bkpf-xblnr,
          bktxt   TYPE bkpf-bktxt,
          newbs_1 TYPE rf05a-newbs,
          newko_1 TYPE rf05a-newko,
          wrbtr_1 TYPE bseg-wrbtr,
          dmbtr_1 TYPE bseg-dmbtr,
          gsber_1 TYPE cobl-gsber,
          valut   TYPE bseg-valut,
          zuonr_1 TYPE bseg-zuonr,
          sgtxt_1 TYPE bseg-sgtxt,
          newbs_2 TYPE rf05a-newbs,
          newko_2 TYPE rf05a-newko,
          wrbtr_2 TYPE bseg-wrbtr,
          dmbtr_2 TYPE bseg-dmbtr,
          gsber_2 TYPE cobl-gsber,
          zuonr_2 TYPE bseg-zuonr,
          sgtxt_2 TYPE bseg-sgtxt,
          kostl   TYPE bseg-kostl,
*         wrbtr_3 type BSEG-WRBTR,
*         gsber_3 type BSEG-GSBER,
        END OF x_field6.
DATA: fs_field6 TYPE x_field6,
      t_field6  TYPE STANDARD TABLE OF x_field6.

*structure declaration.
TYPES: BEGIN OF x_field10,
         agr_name TYPE agr_define-agr_name, "Assigning Roles PFCG
         bukrs    TYPE bukrs,
       END OF x_field10.
DATA: fs_field10 TYPE x_field10,
      t_field10  TYPE STANDARD TABLE OF x_field10.

*structure declaration.
TYPES: BEGIN OF x_field11, "Customer Open Item Invoice Downpayment source system F-02
         bldat   TYPE bkpf-bldat,
         blart   TYPE bkpf-blart,
         bukrs   TYPE bkpf-bukrs,
         budat   TYPE bkpf-budat,
         waers   TYPE bkpf-waers,
         xblnr   TYPE bkpf-xblnr,
         bktxt   TYPE bkpf-bktxt,
         newbs_1 TYPE rf05a-newbs,
         newko_1 TYPE rf05a-newko,
         newum   TYPE rf05a-newum,
         wrbtr_1 TYPE bseg-wrbtr,
         dmbtr_1 TYPE bseg-dmbtr,
         bupla   TYPE bseg-bupla,
         secco   TYPE bseg-secco,
         gsber_1 TYPE bseg-gsber,
         zfbdt   TYPE bseg-zfbdt,
         zuonr_1 TYPE bseg-zuonr,
         sgtxt_1 TYPE bseg-sgtxt,
         newbs_2 TYPE rf05a-newbs,
         newko_2 TYPE rf05a-newko,
         wrbtr_2 TYPE bseg-wrbtr,
         dmbtr_2 TYPE bseg-dmbtr,
*         bupla_2 type BSEG-BUPLA,
         gsber_2 TYPE bseg-gsber,
         zuonr_2 TYPE bseg-zuonr,
         sgtxt_2 TYPE bseg-sgtxt,

       END OF x_field11.

DATA: fs_field11 TYPE x_field11,
      t_field11  TYPE STANDARD TABLE OF x_field11.

*structure declaration.
TYPES: BEGIN OF x_field12, "Vendor Open Item Invoice Downpayment source system F-02
         bldat   TYPE bkpf-bldat,
         blart   TYPE bkpf-blart,
         bukrs   TYPE bkpf-bukrs,
         budat   TYPE bkpf-budat,
         waers   TYPE bkpf-waers,
         xblnr   TYPE bkpf-xblnr,
         bktxt   TYPE bkpf-bktxt,
         newbs_1 TYPE rf05a-newbs,
         newko_1 TYPE rf05a-newko,
         newum   TYPE rf05a-newum,
         wrbtr_1 TYPE bseg-wrbtr,
         dmbtr_1 TYPE bseg-dmbtr,
         bupla   TYPE bseg-bupla,
         secco   TYPE bseg-secco,
         gsber_1 TYPE bseg-gsber,
         zfbdt   TYPE bseg-zfbdt,
         zuonr_1 TYPE bseg-zuonr,
         sgtxt_1 TYPE bseg-sgtxt,
         newbs_2 TYPE rf05a-newbs,
         newko_2 TYPE rf05a-newko,
         wrbtr_2 TYPE bseg-wrbtr,
         dmbtr_2 TYPE bseg-dmbtr,
*         bupla_2 type bseg-bupla,
         gsber_2 TYPE bseg-gsber,
         zuonr_2 TYPE bseg-zuonr,
         sgtxt_2 TYPE bseg-sgtxt,

       END OF x_field12.

DATA: fs_field12 TYPE x_field12,
      t_field12  TYPE STANDARD TABLE OF x_field12.

*structure declaration
TYPES: BEGIN OF x_field31,  "Vendor Open Item Downpay for 1000cc(SPL GL IND = X)
         bldat   TYPE bkpf-bldat,
         blart   TYPE bkpf-blart,
         bukrs   TYPE bkpf-bukrs,
         budat   TYPE bkpf-budat,
         waers   TYPE bkpf-waers,
         xblnr   TYPE bkpf-xblnr,
         bktxt   TYPE bkpf-bktxt,
         newbs_1 TYPE rf05a-newbs,
         newko_1 TYPE rf05a-newko,
         newum   TYPE rf05a-newum,
         wrbtr_1 TYPE bseg-wrbtr,
         dmbtr_1 TYPE bseg-dmbtr,
         zuonr_1 TYPE bseg-zuonr,
         gsber_1 TYPE bseg-gsber,
         sgtxt_1 TYPE bseg-sgtxt,
         bupla   TYPE bseg-bupla,
         zfbdt   TYPE bseg-zfbdt,
         newbs_2 TYPE rf05a-newbs,
         newko_2 TYPE rf05a-newko,
         wrbtr_2 TYPE bseg-wrbtr,
         dmbtr_2 TYPE bseg-dmbtr,
         zuonr_2 TYPE bseg-zuonr,
         sgtxt_2 TYPE bseg-sgtxt,
         gsber_2 TYPE bseg-gsber,
       END OF x_field31.

DATA: fs_field31 TYPE x_field31,
      t_field31  TYPE STANDARD TABLE OF x_field31.

*Structure declaration
TYPES: BEGIN OF x_field14, "Assest Master creation AS01
*         anlkl TYPE anla-anlkl,
         bukrs TYPE anla-bukrs,
         ranl1 TYPE ra02s-ranl1,
         rbukr TYPE ra02s-rbukr,
         invnr TYPE anla-invnr,
         kostl TYPE anlz-kostl,
         menge TYPE anla-menge,
         meins TYPE anla-meins,
*         sernr TYPE anla-sernr,
*         gsber TYPE anlz-gsber,
         afabg TYPE anlb-afabg,
         werks TYPE anlz-werks,
       END OF x_field14.

DATA: fs_field14 TYPE x_field14,
      t_field14  TYPE STANDARD TABLE OF x_field14.


TYPES: BEGIN OF x_field15,      "Asset Inter Company Transfer ABT1N
         value   TYPE svald-value,
         anln1_1 TYPE raifp2-anln1,
         anln2_1 TYPE raifp2-anln2,
         bldat   TYPE raifp1-bldat,
         budat   TYPE raifp1-budat,
         bzdat   TYPE raifp1-bzdat,
         sgtxt   TYPE raifp2-sgtxt,
         xnoer   TYPE raifp2-xnoer,
         bukrs   TYPE raifp3-bukrs,
         anln1_2 TYPE raifp3-anln1,
         anln2_2 TYPE raifp3-anln2,
         blart   TYPE raifp1-blart,
       END OF x_field15.

DATA: fs_field15 TYPE x_field15,
      t_field15  TYPE STANDARD TABLE OF x_field15.

TYPES : BEGIN OF ty_field16,
          lifnr TYPE lifnr,
          bukrs TYPE bukrs,
        END OF ty_field16.
DATA : t_field16  TYPE STANDARD TABLE OF ty_field16,
       fs_field16 TYPE ty_field16.
FIELD-SYMBOLS : <fs_field16> TYPE ty_field16.
DATA : it_lfbw TYPE STANDARD TABLE OF lfbw.
FIELD-SYMBOLS : <fs_lfbw> TYPE lfbw.
TYPES : BEGIN OF ty_field17,
          kunnr TYPE kunnr,
          bukrs TYPE bukrs,
        END OF ty_field17.
DATA : t_field17  TYPE STANDARD TABLE OF ty_field17,
       fs_field17 TYPE ty_field17.
FIELD-SYMBOLS : <fs_field17> TYPE ty_field17.

TYPES: BEGIN OF x_field18, "Internal Order Techo
         aufnr TYPE coas-aufnr,
         user0 TYPE coas-user0,
         user2 TYPE coas-user2,
       END OF x_field18.

DATA: fs_field18 TYPE x_field18,
      t_field18  TYPE STANDARD TABLE OF x_field18.


TYPES: BEGIN OF x_field21, "Group Asset Creation AS21
         anlkl  TYPE anla-anlkl,
         bukrs  TYPE anla-bukrs,
         ranlgr TYPE ra02s-ranlgr,
         rbukgr TYPE ra02s-rbukgr,
         anln1  TYPE anla-anln1,
         gsber  TYPE anlz-gsber,
         kostl  TYPE anlz-kostl,
       END OF x_field21.

DATA: fs_field21 TYPE x_field21,
      t_field21  TYPE STANDARD TABLE OF x_field21.

TYPES: BEGIN OF x_field24,    "AS11 Asset Master-Subnumber Creation
         anln1   TYPE anla-anln1,
         bukrs   TYPE anla-bukrs,
         nassets TYPE ra02s-nassets,
         invnr   TYPE anla-invnr,
         menge   TYPE anla-menge,
         invzu   TYPE anla-invzu,
       END OF x_field24.

DATA: fs_field24 TYPE x_field24,
      t_field24  TYPE STANDARD TABLE OF x_field24.

*TYPES: BEGIN OF ty_field18,
*       username type BAPIACHE09-username,
*       header_txt type BAPIACHE09-HEADER_TXT,
*       comp_code type BAPIACHE09-comp_code,
*       doc_date  type BAPIACHE09-doc_date,
*       pstng_date type BAPIACHE09-PSTNG_DATE,
*       doc_type type BAPIACHE09-DOC_TYPE,
*       REF_DOC_NO type BAPIACHE09-REF_DOC_NO,

DATA : it_knbw TYPE STANDARD TABLE OF knbw.
FIELD-SYMBOLS : <fs_knbw> TYPE knbw.
DATA : fnam(20) TYPE c,
       idx      TYPE c.


DATA i_field_seperator    TYPE char01 VALUE 'X'.
DATA i_line_header        TYPE char01.
*DATA i_tab_raw_data       TYPE truxs_t_text_data.
DATA i_filename           TYPE rlgrap-filename.

DATA: t_bdcdata LIKE TABLE OF bdcdata.
DATA: fs_bdcdata LIKE LINE OF t_bdcdata,   " Structure type of bdcdata
      w_str      TYPE string.
DATA: wa_info TYPE ty_s_info,
      t_info  TYPE TABLE OF ty_s_info.
DATA: wa_path    TYPE string,
      wa_error   TYPE string,
      wa_inf     TYPE string,
      wa_cnt     TYPE i,
      w_mode     TYPE c,
      w_update   TYPE c VALUE 'S',
      wa_cnt1(2) TYPE n,
      it_output  TYPE TABLE OF ty_s_error,
      wa_output  LIKE LINE OF it_output.
*      Batch input data of single transaction
DATA:   bdcdata LIKE bdcdata    OCCURS 0 WITH HEADER LINE.
*       messages of call transaction
DATA:   messtab LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE.
DATA : w_msg      TYPE bdcmsgcoll,
       w_msg1(51).


DATA : temp_bldat       TYPE bldat,
       temp_budat       TYPE budat,
       temp_bzdat       TYPE bzdat,
       temp_afabg       TYPE afabg,
       temp_wrbtr_1(13) TYPE c,
       temp_wrbtr_2(13) TYPE c,
       temp_datab       TYPE datab,
       temp_valut       TYPE valut,
       temp_dmbtr_1(13) TYPE c,
       temp_dmbtr_2(13) TYPE c,
       temp_zfbdt       TYPE bseg-zfbdt,
       temp_duedate     TYPE bseg-zfbdt,
       activity_group   TYPE agr_define-agr_name,
       temp_valut_1     TYPE valut,
       temp_valut_2     TYPE valut,
       temp_menge(13)   TYPE c.
