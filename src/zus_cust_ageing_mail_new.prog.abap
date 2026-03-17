REPORT  zfi_cust_ageing
        NO STANDARD PAGE HEADING LINE-COUNT 300.

TABLES : kna1.
** **************TABLE DECLARATION

DATA:
   tmp_kunnr TYPE kna1-kunnr.
*TABLES: bsid,kna1, bsad, knb1.
TYPE-POOLS : slis.

**************DATA DECLARATION
DATA : fm_name TYPE rs38l_fnam.
DATA : date1 TYPE sy-datum, date2 TYPE sy-datum, date3 TYPE i.

DATA   fs_layout TYPE slis_layout_alv.

DATA : t_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

DATA: lv_temp  TYPE char20,
      lv_temp1 TYPE char20.

*Internal Table for sorting
DATA t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.
DATA : gs_con_settings   TYPE ssfctrlop,
       ls_composer_param TYPE ssfcompop.


TYPES:
  BEGIN OF t_knvv,
    kunnr TYPE knvv-kunnr,
    vkbur TYPE knvv-vkbur,
  END OF t_knvv,
  tt_knvv TYPE STANDARD TABLE OF t_knvv.

TYPES:
  BEGIN OF t_tvkbt,
    vkbur TYPE tvkbt-vkbur,
    bezei TYPE tvkbt-bezei,
  END OF t_tvkbt,
  tt_tvkbt TYPE STANDARD TABLE OF t_tvkbt.

TYPES:
  BEGIN OF t_vbrk,
    vbeln TYPE vbrk-vbeln,
    knumv TYPE vbrk-knumv,
    fkdat TYPE vbrk-fkdat,
  END OF t_vbrk,
  tt_vbrk TYPE STANDARD TABLE OF t_vbrk.

TYPES:
  BEGIN OF t_vbrp,
    vbeln TYPE vbrp-vbeln,
    posnr TYPE vbrp-posnr,
    aubel TYPE vbrp-aubel,
  END OF t_vbrp,
  tt_vbrp TYPE STANDARD TABLE OF t_vbrp.

TYPES:
  BEGIN OF t_skat,
    saknr TYPE skat-saknr,
    txt50 TYPE skat-txt50,
  END OF t_skat,
  tt_skat TYPE STANDARD TABLE OF t_skat.

TYPES:
  BEGIN OF t_vbak,
    vbeln TYPE vbak-vbeln,
    audat TYPE vbak-audat,
    bstnk TYPE vbak-bstnk,
    bstdk TYPE vbak-bstdk,
  END OF t_vbak,
  tt_vbak TYPE STANDARD TABLE OF t_vbak.

TYPES:
  BEGIN OF t_tvzbt,
    zterm TYPE tvzbt-zterm,
    vtext TYPE tvzbt-vtext,
  END OF t_tvzbt,
  tt_tvzbt TYPE STANDARD TABLE OF t_tvzbt.

TYPES:BEGIN OF ty_kna1,
        kunnr TYPE kna1-kunnr,
        name1 TYPE kna1-name1,
        adrnr TYPE kna1-adrnr,
      END OF ty_kna1,

      BEGIN OF ty_adrc,
        addrnumber TYPE adrc-addrnumber,
        street     TYPE adrc-street,
        house_num1 TYPE adrc-house_num1,
        post_code1 TYPE adrc-post_code1,
        city1      TYPE adrc-city1,
        city2      TYPE adrc-city2,
        country    TYPE adrc-country,
        region     TYPE adrc-region,
      END OF ty_adrc,

      BEGIN OF ty_adr6,
        addrnumber TYPE adr6-addrnumber,
        smtp_addr  TYPE adr6-smtp_addr,
      END OF ty_adr6,

      BEGIN OF ty_bkpf,
        bukrs TYPE bkpf-bukrs,
        belnr TYPE bkpf-belnr,
        blart TYPE bkpf-blart,
        xblnr TYPE bkpf-xblnr,
        bktxt TYPE bkpf-bktxt,
      END OF ty_bkpf,

      BEGIN OF ty_bseg,
        bukrs TYPE bseg-bukrs,
        vbeln TYPE bseg-vbeln,
        skfbt TYPE bseg-skfbt,
        sknto TYPE bseg-sknto,
      END OF ty_bseg,

      BEGIN OF ty_konv,
        knumv TYPE prcd_elements-knumv,
        kposn TYPE prcd_elements-kposn,
        kschl TYPE prcd_elements-kschl,
        kwert TYPE prcd_elements-kwert,
      END OF ty_konv.



DATA : it_kna1 TYPE TABLE OF ty_kna1,
       wa_kna1 TYPE          ty_kna1,

       it_adrc TYPE TABLE OF ty_adrc,
       wa_adrc TYPE          ty_adrc,

       it_adr6 TYPE TABLE OF ty_adr6,
       wa_adr6 TYPE          ty_adr6,

       it_bkpf TYPE TABLE OF ty_bkpf,
       wa_bkpf TYPE          ty_bkpf,

       it_bseg TYPE TABLE OF ty_bseg,
       wa_bseg TYPE          ty_bseg,

       it_konv TYPE TABLE OF ty_konv,
       wa_konv TYPE          ty_konv.



TYPES: BEGIN OF idata ,
         name1         LIKE kna1-name1,          "custmor Name
         name2         LIKE kna1-name1,          "Bill to Name
         ktokd         LIKE kna1-ktokd,          " customer account group
         kunnr         LIKE bsid-kunnr,          "Customer Code
         shkzg         LIKE bsid-shkzg,          "debit/credit s/h
         bukrs         LIKE bsid-bukrs,          "Company Code
         augbl         LIKE bsid-augbl,          "Clearing Doc No
         auggj         LIKE bsid-auggj,
         augdt         LIKE bsid-augdt,          "Clearing Date
         gjahr         LIKE bsid-gjahr,          "Fiscal year
         belnr         LIKE bsid-belnr,          "Document no.
         umskz         LIKE bsid-umskz,          "Special G/L indicator
         buzei         LIKE bsid-buzei,          "Line item no.
         budat         LIKE bsid-budat,          "Posting date in the document
         bldat         LIKE bsid-bldat,          "Document date in document
         waers         LIKE bsid-waers,          "Currency
         blart         LIKE bsid-blart,          "Doc. Type
         xblnr         TYPE bsid-xblnr,          "ODN
         dmbtr         LIKE bsid-dmbtr,          "Amount in local curr.
         wrbtr         LIKE bsid-wrbtr,          "Amount in local curr.
         rebzg         LIKE bsid-rebzg,          "refr inv no
         rebzj         LIKE bsid-rebzj,          "Fiscal year
         rebzz         LIKE bsid-rebzz,          "Line Item no
         vbeln         TYPE bsad-vbeln,          "Invoice Number
         duedate       LIKE bsid-augdt,        "Due Date
         zterm         LIKE bsid-zterm,         "Payment Term
*         zbd1t     LIKE bsid-zbd1t,         "Cash Discount Days 1
         day           TYPE i,
         debit         LIKE bsid-dmbtr,         "Amount in local curr.
         credit        LIKE bsid-dmbtr,         "Amount in local curr.
         netbal        LIKE bsid-dmbtr,         "Amount in local curr.
         not_due_cr    TYPE bsid-dmbtr,        "Amount in local curr.
         not_due_db    TYPE bsid-dmbtr,        "Amount in local curr.
         not_due       TYPE bsid-dmbtr,        "Amount in local curr.
         debit30       LIKE bsid-dmbtr,        "Amount in local curr.
         credit30      LIKE bsid-dmbtr,       "Amount in local curr.
         netb30        LIKE bsid-dmbtr,         "Amount in local curr.
         debit60       LIKE bsid-dmbtr,        "Amount in local curr.
         credit60      LIKE bsid-dmbtr,       "Amount in local curr.
         netb60        LIKE bsid-dmbtr,         "Amount in local curr.
         debit90       LIKE bsid-dmbtr,        "Amount in local curr.
         credit90      LIKE bsid-dmbtr,       "Amount in local curr.
         netb90        LIKE bsid-dmbtr,         "Amount in local curr.
         debit120      LIKE bsid-dmbtr,       "Amount in local curr.
         credit120     LIKE bsid-dmbtr,      "Amount in local curr.
         netb120       LIKE bsid-dmbtr,         "Amount in local curr.
         debit180      LIKE bsid-dmbtr,       "Amount in local curr.
         credit180     LIKE bsid-dmbtr,      "Amount in local curr.
         netb180       LIKE bsid-dmbtr,         "Amount in local curr.
         debit360      LIKE bsid-dmbtr,       "Amount in local curr.
         credit360     LIKE bsid-dmbtr,      "Amount in local curr.
         netb360       LIKE bsid-dmbtr,         "Amount in local curr.
         debit720      LIKE bsid-dmbtr,       "Amount in local curr.
         credit720     LIKE bsid-dmbtr,      "Amount in local curr.
         netb720       LIKE bsid-dmbtr,         "Amount in local curr.
         debit730      LIKE bsid-dmbtr,       "Amount in local curr.
         credit730     LIKE bsid-dmbtr,      "Amount in local curr.
         netb730       LIKE bsid-dmbtr,         "Amount in local curr.
         debit_ab      LIKE bsid-dmbtr,       "Amount in local curr.
         credit_ab     LIKE bsid-dmbtr,      "Amount in local curr.
         netb_ab       LIKE bsid-dmbtr,         "Amount in local curr.
         tdisp         TYPE string,
         group         TYPE string,
         akont         TYPE knb1-akont,
         zfbdt         TYPE bsid-zfbdt,
         zbd1t         TYPE bsid-zbd1t,
         zbd2t         TYPE bsid-zbd2t,
         zbd3t         TYPE bsid-zbd3t,
         curr          TYPE bsid-dmbtr,
         bezei         TYPE tvkbt-bezei,
         fkdat         TYPE vbrk-fkdat,
         aubel         TYPE vbrp-aubel,
         audat         TYPE vbak-audat,
         bstnk         TYPE vbak-bstnk,
         bstdk         TYPE vbak-bstdk,
         vtext         TYPE char200,
         rec_txt       TYPE char70,     "Reconcilation Account text
         debit1000     LIKE bsid-dmbtr,
         credit1000    LIKE bsid-dmbtr,
         netb1000      LIKE bsid-dmbtr,
         email         TYPE adr6-smtp_addr,
         street        TYPE adrc-street,
         address       TYPE char100,
         bktxt         TYPE bkpf-bktxt,
         ref           TYPE bkpf-xblnr,
         sknto         TYPE prcd_elements-kwert,
         fi_desc       TYPE char100,
         original      TYPE bsid-dmbtr,
         total         TYPE bsid-dmbtr,
         original_disp TYPE char20,
         total_disp    TYPE char20,


       END OF idata.

*TYPES: BEGIN OF ty_mytype.
*         INCLUDE TYPE zus_cust_statement.
*TYPES: original TYPE bsid-dmbtr,
*         total    TYPE bsid-dmbtr,
*       END OF ty_mytype,
*       tt_type TYPE STANDARD TABLE OF ty_mytype.

TYPES: BEGIN OF ty_final,
         kunnr    TYPE kna1-kunnr,
         budat    TYPE bsid-budat,
         duedate  TYPE bsid-budat,
         vbeln    TYPE vbrk-vbeln,
         bstnk    TYPE vbak-bstnk,
         debit    TYPE bsid-dmbtr,
         netbal   TYPE bsid-dmbtr,
         netb30   TYPE bsid-dmbtr,
         netb60   TYPE bsid-dmbtr,
         netb90   TYPE bsid-dmbtr,
         netb120  TYPE bsid-dmbtr,
         netb180  TYPE bsid-dmbtr,
         netb360  TYPE bsid-dmbtr,
         netb720  TYPE bsid-dmbtr,
         netb1000 TYPE bsid-dmbtr,
         st_date  TYPE bsid-budat,
       END OF ty_final.

DATA: it_final     TYPE TABLE OF ty_final,
      it_final_new TYPE TABLE OF ty_final,
      wa_final     TYPE          ty_final,
      wa_final1    TYPE          ty_final.

DATA :
  gt_msg TYPE balmi_tab,
  gs_msg TYPE balmi.

" General Ledger: With final balance for posting
TYPES :
  BEGIN OF t_message,
    msg_typ TYPE char4 ,                              " Message type
    msg_txt TYPE bapiret2-message ,                   " Message text
  END OF t_message.
*-------------------------------------------------------*
* Declerations to display messages in foreground
*-------------------------------------------------------*
DATA:
  gt_message TYPE TABLE OF t_message,
  gs_message TYPE t_message.


DATA: rp01(3) TYPE n,                                     "   0
      rp02(3) TYPE n,                                     "  20
      rp03(3) TYPE n,                                     "  40
      rp04(3) TYPE n,                                     "  80
      rp05(3) TYPE n,                                     " 100
      rp06(3) TYPE n,                                     "   1
      rp07(3) TYPE n,                                     "  21
      rp08(3) TYPE n,                                     "  41
      rp09(3) TYPE n,                                     "  81
      rp10(3) TYPE n,                                     " 101
      rp11(3) TYPE n,                                     " 101
      rp12(3) TYPE n,                                     " 101
      rp13(3) TYPE n,                                     " 101
      rp14(3) TYPE n.                                     " 101

DATA: rc01(14) TYPE c,                                     "  0
      rc02(14) TYPE c,                                    "  20
      rc03(14) TYPE c,                                    "  40
      rc04(14) TYPE c,                                    "  80
      rc05(14) TYPE c,                                    " 100
      rc06(14) TYPE c,                                    "   1
      rc07(14) TYPE c,                                    "  21
      rc08(14) TYPE c,                                    "  41
      rc09(14) TYPE c,                                    "  81
      rc10(14) TYPE c,                                    " 101
      rc11(14) TYPE c,                                    " 101
      rc12(14) TYPE c,                                    " 101
      rc13(14) TYPE c,                                    " 101
      rc14(20) TYPE c,                                    " 101
      rc15(20) TYPE c,                                    " 101
      rc16(20) TYPE c,                                    " 101
      rc17(20) TYPE c,                                    " 101
      rc18(30) TYPE c,                                    " 101
      rc19(30) TYPE c,                                    " 101
      rc20(30) TYPE c,                                    " 101
      rc21(30) TYPE c,                                    " 101
      rc22(30) TYPE c,                                    " 101
      rc23(30) TYPE c.                                    " 101

DATA: itab  TYPE idata OCCURS 0 WITH HEADER LINE.


DATA: cparam TYPE ssfctrlop,
      outop  TYPE ssfcompop.

DATA: tab_otf_data  TYPE ssfcrescl,
      pdf_tab       LIKE tline OCCURS 0 WITH HEADER LINE,
      tab_otf_final TYPE itcoo OCCURS 0 WITH HEADER LINE,
      file_size     TYPE i,
      bin_filesize  TYPE i,
      file_name     TYPE string,
      full_path     TYPE string,
*      date(10)      TYPE c,
      lv_date1      TYPE string,
      lt_bcs_pdf    TYPE   solix_tab.

***********************************************************************************************************
"Sending Mail to Customer.
***********************************************************************************************************


* INTERNAL TABLE DECLARATIONS
DATA: i_otf       TYPE itcoo OCCURS 0 WITH HEADER LINE,
      i_tline     LIKE tline OCCURS 0 WITH HEADER LINE,
      i_receivers TYPE TABLE OF somlreci1 WITH HEADER LINE,
      i_record    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
* OBJECTS TO SEND MAIL.
      i_objpack   LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,
      i_objtxt    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
      i_objbin    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
      i_reclist   LIKE somlreci1 OCCURS 0 WITH HEADER LINE,
* WORK AREA DECLARATIONS
      wa_objhead  TYPE soli_tab,
      w_ctrlop    TYPE ssfctrlop,
      w_compop    TYPE ssfcompop,
      w_return    TYPE ssfcrescl,
      wa_doc_chng TYPE sodocchgi1,
      w_data      TYPE sodocchgi1,
      wa_buffer   TYPE string, "TO CONVERT FROM 132 TO 255
* VARIABLES DECLARATIONS
      v_form_name TYPE rs38l_fnam,
      v_len_in    TYPE i,
      v_len_out   LIKE sood-objlen,
      v_len_outn  TYPE i,
      v_lines_txt TYPE i,
      v_lines_bin TYPE i,
      subject(50) TYPE c,
      attach(50)  TYPE c.
DATA : lv_adrnr     TYPE kna1-adrnr,
       lv_smtp_addr TYPE adr6-smtp_addr.

DATA : lv_text   TYPE string,
       postdate1 TYPE char15.

******************SELECTION SCREEN

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: plant LIKE bsid-bukrs OBLIGATORY DEFAULT 'US00'.
*            kunnr TYPE kna1-kunnr OBLIGATORY.
  SELECT-OPTIONS:kunnr FOR kna1-kunnr OBLIGATORY.
*                akont FOR knb1-akont.
  PARAMETERS: date  LIKE bsid-budat DEFAULT sy-datum OBLIGATORY.                "no-extension obligatory.
  SELECTION-SCREEN BEGIN OF LINE.

    SELECTION-SCREEN COMMENT 01(30) TEXT-026 FOR FIELD rastbis1.

    SELECTION-SCREEN POSITION POS_LOW.

    PARAMETERS: rastbis1 LIKE rfpdo1-allgrogr DEFAULT '000'.
    PARAMETERS: rastbis2 LIKE rfpdo1-allgrogr DEFAULT '030'.
    PARAMETERS: rastbis3 LIKE rfpdo1-allgrogr DEFAULT '060'.
    PARAMETERS: rastbis4 LIKE rfpdo1-allgrogr DEFAULT '090'.
    PARAMETERS: rastbis5 LIKE rfpdo1-allgrogr DEFAULT '180'.
    PARAMETERS: rastbis6 LIKE rfpdo1-allgrogr DEFAULT '360'.
    PARAMETERS: rastbis7 LIKE rfpdo1-allgrogr DEFAULT '720'.

  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK a1.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME.
  PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
              r2 RADIOBUTTON GROUP abc.

  PARAMETERS     : chkb AS CHECKBOX.
SELECTION-SCREEN: END OF BLOCK b1.


DATA: r_custno  TYPE TABLE OF kna1-kunnr,
      ls_custno LIKE LINE OF kunnr.

TYPES :BEGIN OF t_kunnr,
         kunnr TYPE kunnr,
       END OF t_kunnr.
DATA: wa_kunnr TYPE t_kunnr,
      it_kunnr TYPE TABLE OF t_kunnr.

*LOOP AT kunnr INTO ls_custno.
*  ls_custno-sign = 'I'.
*  ls_custno-option = 'EQ'.
*  ls_custno-low = ls_custno-low.
*  APPEND ls_custno TO r_custno.
*ENDLOOP.

SELECT kunnr FROM kna1
         INTO TABLE it_kunnr
        WHERE kunnr IN kunnr.

***********************Initialization.

INITIALIZATION.

**************************************************
AT SELECTION-SCREEN.

  IF rastbis1 GT '998'
  OR rastbis2 GT '998'
  OR rastbis3 GT '998'
  OR rastbis4 GT '998'
  OR rastbis5 GT '998'
  OR rastbis6 GT '998'
  OR rastbis7 GT '998'.

    SET CURSOR FIELD rastbis7.
    MESSAGE 'Enter a consistent sorted list' TYPE 'E'.      "e381.
  ENDIF.
  IF NOT rastbis7 IS INITIAL.
    IF  rastbis7 GT rastbis6
    AND rastbis6 GT rastbis5
    AND rastbis5 GT rastbis4
    AND rastbis4 GT rastbis3
    AND rastbis3 GT rastbis2
    AND rastbis2 GT rastbis1.
    ELSE.
      MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
    ENDIF.
  ELSE.
    IF NOT rastbis6 IS INITIAL.
      IF  rastbis6 GT rastbis5
      AND rastbis5 GT rastbis4
      AND rastbis4 GT rastbis3
      AND rastbis3 GT rastbis2
      AND rastbis2 GT rastbis1.
      ELSE.
        MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
      ENDIF.
    ELSE.
      IF NOT rastbis5 IS INITIAL.
        IF  rastbis5 GT rastbis4
        AND rastbis4 GT rastbis3
        AND rastbis3 GT rastbis2
        AND rastbis2 GT rastbis1.
        ELSE.
          MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
        ENDIF.
      ELSE.
        IF NOT rastbis4 IS INITIAL.
          IF  rastbis4 GT rastbis3
          AND rastbis3 GT rastbis2
          AND rastbis2 GT rastbis1.
          ELSE.
            MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
          ENDIF.
        ELSE.
          IF NOT rastbis3 IS INITIAL.
            IF  rastbis3 GT rastbis2
            AND rastbis2 GT rastbis1.
            ELSE.
              MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
            ENDIF.
          ELSE.
            IF NOT rastbis2 IS INITIAL.
              IF  rastbis2 GT rastbis1.
              ELSE.
                MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
              ENDIF.
            ELSE.
*         nichts zu tun
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.


  rp01 = rastbis1.
  rp02 = rastbis2.
  rp03 = rastbis3.
  rp04 = rastbis4.
  rp05 = rastbis5.
  rp06 = rastbis6.
  rp07 = rastbis7.

  rp08 = rp01 + 1.
  IF NOT rp02 IS INITIAL.
    rp09 = rp02 + 1.
  ELSE.
    rp09 = ''.
  ENDIF.
  IF NOT rp03 IS INITIAL.
    rp10 = rp03 + 1.
  ELSE.
    rp10 = ''.
  ENDIF.
  IF NOT rp04 IS INITIAL.
    rp11 = rp04 + 1.
  ELSE.
    rp11 = ''.
  ENDIF.
  IF NOT rp05 IS INITIAL.
    rp12 = rp05 + 1.
  ELSE.
    rp12 = ''.
  ENDIF.
  IF NOT rp06 IS INITIAL.
    rp13 = rp06 + 1.
  ELSE.
    rp13 = ''.
  ENDIF.
  IF NOT rp07 IS INITIAL.
    rp14 = rp07 + 1.
  ELSE.
    rp14 = ''.
  ENDIF.

  IF NOT rp01 IS INITIAL.
    CONCATENATE 'Upto'    rp01 'Dr' INTO rc01 SEPARATED BY space.
    CONCATENATE 'Upto'    rp01 'Cr' INTO rc08 SEPARATED BY space.
    CONCATENATE '000 to'  rp01 'Days' INTO rc17 SEPARATED BY space.
  ELSE.
    CONCATENATE 'Upto'    rp01 'Dr' INTO rc01 SEPARATED BY space.
    CONCATENATE 'Upto'    rp01 'Cr' INTO rc08 SEPARATED BY space.
    CONCATENATE rp01 'Days' INTO rc17 SEPARATED BY space.
  ENDIF.


  IF NOT rp02 IS INITIAL.
    CONCATENATE rp08 'To' rp02 'Dr' INTO rc02 SEPARATED BY space.
    CONCATENATE rp08 'To' rp02 'Cr' INTO rc09 SEPARATED BY space.
    CONCATENATE rp08 'To' rp02 'Days' INTO rc18 SEPARATED BY space.
  ELSEIF rp03 IS INITIAL.
    CONCATENATE rp08 '& Above' 'Dr' INTO rc02 SEPARATED BY space.
    CONCATENATE rp08 '& Above' 'Cr' INTO rc09 SEPARATED BY space.
    CONCATENATE rp08 'Days' INTO rc18 SEPARATED BY space.
  ENDIF.

  IF NOT rp03 IS INITIAL.
    CONCATENATE rp09 'To' rp03 'Dr' INTO rc03 SEPARATED BY space.
    CONCATENATE rp09 'To' rp03 'Cr' INTO rc10 SEPARATED BY space.
    CONCATENATE rp09 'To' rp03 'Days' INTO rc19 SEPARATED BY space.
  ELSEIF rp02 IS INITIAL.
    rc03 = ''.
    rc08 = ''.
    rc15 = ''.
  ELSEIF rp04 IS INITIAL.
    CONCATENATE rp09 '& Above' 'Dr' INTO rc03 SEPARATED BY space.
    CONCATENATE rp09 '& Above' 'Cr' INTO rc10 SEPARATED BY space.
    CONCATENATE rp09 'Days' INTO rc19 SEPARATED BY space.
  ENDIF.

  IF NOT rp04 IS INITIAL .
    CONCATENATE rp10 'To' rp04 'Dr' INTO rc04 SEPARATED BY space.
    CONCATENATE rp10 'To' rp04 'Cr' INTO rc11 SEPARATED BY space.
    CONCATENATE rp10 'To' rp04 'Days' INTO rc20 SEPARATED BY space.
  ELSEIF rp03 IS INITIAL.
    rc04 = ''.
    rc09 = ''.
    rc16 = ''.
  ELSEIF rp05 IS INITIAL.
    CONCATENATE rp10 '& Above' 'Dr' INTO rc04 SEPARATED BY space.
    CONCATENATE rp10 '& Above' 'Cr' INTO rc11 SEPARATED BY space.
*    CONCATENATE rp08 '& Above' 'Net Bal' INTO rc16 SEPARATED BY space.
    CONCATENATE rp10 'Days' INTO rc20 SEPARATED BY space.
  ENDIF.

  IF NOT rp05 IS INITIAL.
    CONCATENATE rp11 'To' rp05 'Dr' INTO rc05 SEPARATED BY space.
    CONCATENATE rp11 'To' rp05 'Cr' INTO rc12 SEPARATED BY space.
*    CONCATENATE rp09 'To' rp05 'Net Bal' INTO rc17 SEPARATED BY space.
    CONCATENATE rp11 'To' rp05 'Days' INTO rc21 SEPARATED BY space.
  ELSEIF rp04 IS INITIAL.
    rc05 = ''.
    rc10 = ''.
    rc17 = ''.
  ELSE.
    CONCATENATE rp11 '& Above' 'Dr' INTO rc05 SEPARATED BY space.
    CONCATENATE rp11 '& Above' 'Cr' INTO rc12 SEPARATED BY space.
    CONCATENATE rp11 'Days' INTO rc21 SEPARATED BY space.
  ENDIF.


  IF NOT rp06 IS INITIAL.
    CONCATENATE rp12 'To' rp06 'Dr' INTO rc06 SEPARATED BY space.
    CONCATENATE rp12 'To' rp06 'Cr' INTO rc13 SEPARATED BY space.
*    CONCATENATE rp09 'To' rp05 'Net Bal' INTO rc17 SEPARATED BY space.
    CONCATENATE rp12 'To' rp06 'Days' INTO rc22 SEPARATED BY space.
  ELSEIF rp05 IS INITIAL.
    rc05 = ''.
    rc10 = ''.
    rc17 = ''.
  ELSE.
    CONCATENATE rp12 '& Above' 'Dr' INTO rc06 SEPARATED BY space.
    CONCATENATE rp12 '& Above' 'Cr' INTO rc13 SEPARATED BY space.
    CONCATENATE rp12 'Days' INTO rc22 SEPARATED BY space.
  ENDIF.


  IF NOT rp07 IS INITIAL.
    CONCATENATE rp13 'To' rp07 'Dr' INTO rc07 SEPARATED BY space.
    CONCATENATE rp13 'To' rp07 'Cr' INTO rc14 SEPARATED BY space.
*    CONCATENATE rp09 'To' rp05 'Net Bal' INTO rc17 SEPARATED BY space.
    CONCATENATE rp13 'To' rp07 'Days' INTO rc23 SEPARATED BY space.
  ELSEIF rp06 IS INITIAL.
    rc05 = ''.
    rc10 = ''.
    rc17 = ''.
  ELSE.
    CONCATENATE rp13 '& Above' 'Dr' INTO rc07 SEPARATED BY space.
    CONCATENATE rp13 '& Above' 'Cr' INTO rc14 SEPARATED BY space.
    CONCATENATE rp13 'Days' INTO rc23 SEPARATED BY space.
  ENDIF.

  IF NOT rp14 IS INITIAL.
    CONCATENATE rp14 '& Above' 'Dr' INTO rc15 SEPARATED BY space.
    CONCATENATE rp14 '& Above' 'Cr' INTO rc16 SEPARATED BY space.
    CONCATENATE rp14 'Days and Above' INTO rc14 SEPARATED BY space.
  ENDIF.
*******************************************

START-OF-SELECTION.

  PERFORM datalist_bsid.

*  PERFORM fill_fieldcatalog.
*  PERFORM sort_list.
*  PERFORM fill_layout.
  PERFORM get_data.
  PERFORM list_display.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  datalist_bsid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM datalist_bsid .
  DATA:
    ls_faede_i TYPE faede,
    ls_faede_e TYPE faede,
    lv_index   TYPE sy-tabix,
    lv_ktopl   TYPE t001-ktopl.

  DATA:
    lt_knvv  TYPE tt_knvv,
    ls_knvv  TYPE t_knvv,
    lt_tvkbt TYPE tt_tvkbt,
    ls_tvkbt TYPE t_tvkbt,
    lt_vbrk  TYPE tt_vbrk,
    ls_vbrk  TYPE t_vbrk,
    lt_vbrp  TYPE tt_vbrp,
    ls_vbrp  TYPE t_vbrp,
    lt_vbak  TYPE tt_vbak,
    ls_vbak  TYPE t_vbak,
    lt_tvzbt TYPE tt_tvzbt,
    ls_tvzbt TYPE t_tvzbt,
    lt_skat  TYPE tt_skat,
    ls_skat  TYPE t_skat,
    lt_data  TYPE STANDARD TABLE OF idata,
    ls_data  TYPE idata.

  SELECT bsid~bukrs
         bsid~kunnr
         augbl
         auggj
         augdt
         gjahr
         belnr
         buzei
         budat
         bldat
         waers
         shkzg
         dmbtr
         wrbtr
         rebzg
         rebzj
         rebzz
         umskz
         bsid~zterm
         zbd1t
         xblnr
         blart
*     kna1~name1
*     kna1~ktokd
    knb1~akont
    bsid~zfbdt
    bsid~zbd1t
    bsid~zbd2t
    bsid~zbd3t
    bsid~vbeln
  INTO CORRESPONDING FIELDS OF TABLE itab
                             FROM bsid INNER JOIN knb1 ON bsid~kunnr = knb1~kunnr AND knb1~bukrs = bsid~bukrs
                             WHERE bsid~bukrs = plant
                             AND   bsid~kunnr IN kunnr
                             AND   umskz <> 'F'
                             AND   budat <= date.
*                             AND   knb1~akont IN akont .
*                             AND   kna1~ktokd IN ktokd.

  SELECT bsad~bukrs
         bsad~kunnr
         augbl
         auggj
         augdt
         gjahr
         belnr
         buzei
         budat
         bldat
         waers
         shkzg
         dmbtr
         wrbtr
         rebzg
         rebzj
         rebzz
         umskz
         bsad~zterm
         zbd1t
         blart
         xblnr
    knb1~akont
    bsad~zfbdt
    bsad~zbd1t
    bsad~zbd2t
    bsad~zbd3t
    bsad~vbeln
APPENDING CORRESPONDING FIELDS OF TABLE itab
                             FROM bsad INNER JOIN knb1 ON knb1~kunnr = bsad~kunnr AND knb1~bukrs = bsad~bukrs
                             WHERE bsad~bukrs = plant
                             AND   bsad~kunnr IN kunnr
                             AND   umskz <> 'F'
*                             AND   budat <= date
                             AND   augdt >  date.
*                             AND  augdt = ' '
*                             AND   knb1~akont IN akont.

  DELETE itab WHERE budat > date.

  lt_data[] = itab[].

  DELETE itab[] WHERE rebzg IS NOT INITIAL .
*  DELETE lt_data WHERE bldat EQ 'DR'.

  IF NOT itab[] IS INITIAL.
    SELECT bukrs
           belnr
           blart
           xblnr
           bktxt FROM bkpf INTO TABLE it_bkpf
           FOR ALL ENTRIES IN itab
           WHERE bukrs = itab-bukrs
             AND belnr = itab-belnr
             AND blart = 'UE'.




    SELECT SINGLE ktopl
                FROM  t001
                INTO  lv_ktopl
                WHERE bukrs = plant.

    SELECT kunnr
           vkbur
      FROM knvv
      INTO TABLE lt_knvv
      FOR ALL ENTRIES IN itab
      WHERE kunnr = itab-kunnr.

    SELECT kunnr
           name1
           adrnr FROM kna1 INTO TABLE it_kna1
           FOR ALL ENTRIES IN itab
           WHERE kunnr = itab-kunnr.

    IF it_kna1 IS NOT INITIAL.
      SELECT addrnumber
             smtp_addr FROM adr6 INTO TABLE it_adr6
             FOR ALL ENTRIES IN it_kna1
             WHERE addrnumber = it_kna1-adrnr.

      SELECT addrnumber
             street
             house_num1
             post_code1
             city1
             city2
             country
             region     FROM adrc INTO TABLE it_adrc
             FOR ALL ENTRIES IN it_kna1
             WHERE addrnumber = it_kna1-adrnr.
    ENDIF.

    IF sy-subrc IS INITIAL.
      SELECT vkbur
             bezei
        FROM tvkbt
        INTO TABLE lt_tvkbt
        FOR ALL ENTRIES IN lt_knvv
        WHERE vkbur = lt_knvv-vkbur
        AND   spras = sy-langu.
    ENDIF.

    SELECT vbeln
           knumv
           fkdat
      FROM vbrk
      INTO TABLE lt_vbrk
      FOR ALL ENTRIES IN itab
      WHERE vbeln = itab-vbeln.

    SELECT vbeln
           posnr
           aubel
      FROM vbrp
      INTO TABLE lt_vbrp
      FOR ALL ENTRIES IN itab
      WHERE vbeln = itab-vbeln.

    IF sy-subrc IS INITIAL.
      SELECT vbeln
             audat
             bstnk
             bstdk
        FROM vbak
        INTO TABLE lt_vbak
        FOR ALL ENTRIES IN lt_vbrp
        WHERE vbeln = lt_vbrp-aubel.
    ENDIF.

    SELECT zterm
           vtext
      FROM tvzbt
      INTO TABLE lt_tvzbt
      FOR ALL ENTRIES IN itab
      WHERE zterm = itab-zterm
      AND   spras =  sy-langu.

    SELECT saknr
           txt50
      FROM skat
      INTO TABLE lt_skat
      FOR ALL ENTRIES IN itab
      WHERE saknr = itab-akont
      AND   ktopl = lv_ktopl
      AND   spras = sy-langu.

  ENDIF.

  IF  lt_vbrk IS NOT INITIAL.
    SELECT bukrs
           vbeln
           skfbt
           sknto FROM bseg INTO TABLE it_bseg
           FOR ALL ENTRIES IN lt_vbrk
           WHERE vbeln = lt_vbrk-vbeln.

    SELECT knumv
           kposn
           kschl
           kwert FROM prcd_elements INTO TABLE it_konv
           FOR ALL ENTRIES IN lt_vbrk
           WHERE knumv = lt_vbrk-knumv
            AND  kschl = 'SKTO'.





  ENDIF.
  SORT itab[] BY belnr gjahr buzei.
  SORT lt_data[] BY rebzg rebzj rebzz.

  LOOP AT itab .

    READ TABLE lt_data INTO ls_data WITH KEY rebzg = itab-belnr
                                             rebzj = itab-gjahr
                                             rebzz = itab-buzei.
    IF sy-subrc IS INITIAL.
      lv_index = sy-tabix.
      LOOP AT lt_data INTO ls_data FROM lv_index.
        IF ls_data-rebzg = itab-belnr AND ls_data-rebzj = itab-gjahr AND ls_data-rebzz = itab-buzei.
          IF ls_data-shkzg = 'S'.
            itab-credit = itab-credit - ls_data-dmbtr. "total rec/cre memo amt logic
            itab-debit = itab-debit - ls_data-dmbtr. "transfer total inv amt
          ELSE.
            itab-credit = itab-credit + ls_data-dmbtr."total rec/cre memo amt logic
            itab-debit = itab-debit + ls_data-dmbtr.   "transfer total inv amt
          ENDIF.

        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
    MODIFY itab TRANSPORTING debit credit.
*    MODIFY itab TRANSPORTING credit.
  ENDLOOP.

  LOOP AT itab.


    IF itab-blart = 'DR'.
      itab-fi_desc = 'FI Invoice'.
    ELSEIF itab-blart = 'DG'.
      itab-fi_desc = 'Credit Memo'.
    ELSEIF itab-blart = 'RV'.
      itab-fi_desc = 'Sales Invoice'.
    ELSEIF itab-blart = 'UE'.
      itab-fi_desc = 'Initial Upload Invoice'.
    ELSEIF itab-blart = 'DZ'.
      itab-fi_desc = 'Payment'.
    ELSEIF itab-blart = 'SA'.
      itab-fi_desc = 'Invoice'.
    ENDIF.

    IF itab-blart = 'DR'.
      itab-vbeln = itab-belnr.
    ENDIF.

*    SELECT SINGLE name1 INTO itab-name1 FROM kna1 WHERE kunnr = itab-kunnr.
    READ TABLE it_bkpf INTO wa_bkpf WITH KEY belnr = itab-belnr bukrs = itab-bukrs.
    IF sy-subrc = 0.
      itab-bktxt = wa_bkpf-bktxt.
      itab-ref   = wa_bkpf-xblnr.

    ENDIF.
    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = itab-kunnr.
    IF sy-subrc = 0.
      itab-name1 = wa_kna1-name1.
      itab-name2 = wa_kna1-name1.

    ENDIF.

    READ TABLE it_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_kna1-adrnr.
    IF sy-subrc = 0.
      itab-email = wa_adr6-smtp_addr.

    ENDIF.

    READ TABLE it_adrc INTO wa_adrc WITH KEY addrnumber = wa_kna1-adrnr.
    IF sy-subrc = 0.
      itab-street     = wa_adrc-street    .

      CONCATENATE wa_adrc-city1 wa_adrc-region wa_adrc-post_code1 INTO itab-address SEPARATED BY ','.


    ENDIF.



***********Calculating DEBIT and CREDIT
    IF itab-shkzg  = 'S'.
      itab-debit  = itab-dmbtr - itab-debit.
      itab-debit  = itab-debit + itab-credit.
    ELSE.
*      itab-credit = itab-credit + itab-dmbtr. "total rec/cre memo amt logic
      itab-debit =  itab-dmbtr + itab-debit .    "transfer total inv amt
      itab-debit  = itab-debit - itab-credit.

    ENDIF.



    IF itab-shkzg  = 'S'.
      itab-debit  = itab-debit.
    ELSE.                                          " Commented
      itab-debit = itab-debit * -1.
    ENDIF.

*    itab-debit        = abs( itab-debit ).
*      IF itab-debit < 0.
**        CONDENSE itab-debit.
*        CONCATENATE '-' itab-debit INTO itab-debit.
*      ENDIF.

*    IF itab-blart = 'DG'.
*      itab-debit = itab-debit * -1.
*    ENDIF.

    IF itab-umskz  = ''.
      itab-group  = 'Normal'.
    ELSE.
      itab-group  = 'Special G/L'.
    ENDIF.


*    itab-duedate = itab-bldat. " + itab-zbd1t.

    ls_faede_i-koart = 'D'.
    ls_faede_i-zfbdt = itab-zfbdt.
    ls_faede_i-zbd1t = itab-zbd1t.
    ls_faede_i-zbd2t = itab-zbd2t.
    ls_faede_i-zbd3t = itab-zbd3t.

    CALL FUNCTION 'DETERMINE_DUE_DATE'
      EXPORTING
        i_faede                    = ls_faede_i
*       I_GL_FAEDE                 =
      IMPORTING
        e_faede                    = ls_faede_e
      EXCEPTIONS
        account_type_not_supported = 1
        OTHERS                     = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    itab-duedate = ls_faede_e-netdt.
    IF r1 = 'X'.
      IF itab-bldat = date.
        itab-day  = 0.
      ELSE."if itab-bldat < date.
        itab-day     = date - itab-bldat.

      ENDIF.
    ELSE.
      IF itab-duedate = date.
        itab-day  = 0.
      ELSEIF itab-duedate IS NOT INITIAL.
        itab-day     = date - itab-duedate.
      ENDIF.
    ENDIF.
***********Net Balance
    itab-netbal = itab-debit - itab-credit.

    IF itab-day < 0.
      itab-not_due_db = itab-debit.
      itab-not_due_cr = itab-credit.
      itab-not_due    = itab-not_due_db - itab-not_due_cr.
    ELSEIF itab-day <= rastbis1.
      itab-debit30  = itab-debit.
      itab-credit30 = itab-credit.
      itab-netb30 = itab-debit30 - itab-credit30.
    ELSEIF rastbis2 IS INITIAL.
      itab-debit60  = itab-debit.
      itab-credit60 = itab-credit.
      itab-netb60   = itab-debit60 - itab-credit60.
    ELSE.
      IF itab-day > rastbis1 AND itab-day <= rastbis2.
        itab-debit60  = itab-debit.
        itab-credit60 = itab-credit.
        itab-netb60   = itab-debit60 - itab-credit60.
      ELSEIF rastbis3 IS INITIAL.
        itab-debit90  = itab-debit.
        itab-credit90 = itab-credit.
        itab-netb90   = itab-debit90 - itab-credit90.
      ELSE.
        IF itab-day > rastbis2 AND itab-day <= rastbis3.
          itab-debit90  = itab-debit.
          itab-credit90 = itab-credit.
          itab-netb90   = itab-debit90 - itab-credit90.
        ELSEIF rastbis4 IS INITIAL.
          itab-debit120  = itab-debit.
          itab-credit120 = itab-credit.
          itab-netb120   = itab-debit120 - itab-credit120.
        ELSE.
          IF itab-day > rastbis3 AND itab-day <= rastbis4.
            itab-debit120  = itab-debit.
            itab-credit120 = itab-credit.
            itab-netb120   = itab-debit120 - itab-credit120.
          ELSEIF rastbis5 IS INITIAL.
            itab-debit180  = itab-debit.
            itab-credit180 = itab-credit.
            itab-netb180   = itab-debit180 - itab-credit180.
          ELSE.
            IF itab-day > rastbis4 AND itab-day <= rastbis5.
              itab-debit180  = itab-debit.
              itab-credit180 = itab-credit.
              itab-netb180   = itab-debit180 - itab-credit180.
            ELSEIF rastbis6 IS INITIAL.
              itab-debit360  = itab-debit.
              itab-credit360 = itab-credit.
              itab-netb360   = itab-debit360 - itab-credit360.
            ELSE.
              IF itab-day > rastbis5 AND itab-day <= rastbis6.
                itab-debit360  = itab-debit.
                itab-credit360 = itab-credit.
                itab-netb360   = itab-debit360 - itab-credit360.
              ELSEIF rastbis6 IS INITIAL.
                itab-debit720  = itab-debit.
                itab-credit720 = itab-credit.
                itab-netb720   = itab-debit720 - itab-credit720.

              ELSE.
                IF itab-day > rastbis6 AND itab-day <= rastbis7.
                  itab-debit720  = itab-debit.
                  itab-credit720 = itab-credit.
                  itab-netb720   = itab-debit720 - itab-credit720.
                ELSEIF rastbis7 IS INITIAL.
                  itab-debit1000  = itab-debit.
                  itab-credit1000 = itab-credit.
                  itab-netb1000   = itab-debit1000 - itab-credit1000.

                ELSE.
                  IF itab-day > rastbis7.
                    itab-debit1000  = itab-debit.
                    itab-credit1000 = itab-credit.
                    itab-netb1000   = itab-debit1000 - itab-credit1000.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

    CONCATENATE itab-kunnr itab-name1 INTO itab-tdisp SEPARATED BY space."itab-umskz
    SHIFT itab-xblnr LEFT DELETING LEADING '0'.

    READ TABLE lt_knvv INTO ls_knvv WITH KEY kunnr = itab-kunnr.
    IF sy-subrc IS INITIAL.
      READ TABLE lt_tvkbt INTO ls_tvkbt WITH KEY vkbur = ls_knvv-vkbur.
      IF sy-subrc IS INITIAL.
        itab-bezei = ls_tvkbt.
      ENDIF.
    ENDIF.

    READ TABLE lt_vbrk INTO ls_vbrk WITH KEY vbeln = itab-vbeln.
    IF sy-subrc IS INITIAL.
      itab-fkdat = ls_vbrk-fkdat.
    ENDIF.




*    READ TABLE it_bseg INTO wa_bseg WITH KEY vbeln = itab-vbeln..
*    IF sy-subrc = 0.
*      itab-sknto = wa_bseg-sknto.
*
*    ENDIF.

    READ TABLE lt_vbrp INTO ls_vbrp WITH KEY vbeln = itab-vbeln.
    IF sy-subrc IS INITIAL.
      READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_vbrp-aubel.
      IF sy-subrc IS INITIAL.
        itab-aubel = ls_vbak-vbeln.
        itab-audat = ls_vbak-audat.
        itab-bstnk = ls_vbak-bstnk.
        itab-bstdk = ls_vbak-bstdk.
      ENDIF.
    ENDIF.
    IF itab-blart NE 'DG'.

      LOOP AT it_konv INTO wa_konv WHERE knumv = ls_vbrk-knumv." AND kposn = ls_vbrp-posnr.
        IF sy-subrc = 0.
          itab-sknto = itab-sknto + wa_konv-kwert.
        ENDIF.
      ENDLOOP.
    ENDIF.




    READ TABLE lt_tvzbt INTO ls_tvzbt WITH KEY zterm = itab-zterm.
    IF sy-subrc IS INITIAL.
      CONCATENATE ls_tvzbt-zterm ls_tvzbt-vtext INTO itab-vtext SEPARATED BY space.
    ENDIF.
    IF itab-waers = 'INR'.
      IF NOT itab-debit IS INITIAL.
        itab-curr = itab-dmbtr.
      ELSEIF NOT itab-credit IS INITIAL.
        itab-curr = itab-dmbtr * -1.
      ENDIF.
    ELSE.

      IF NOT itab-debit IS INITIAL.
        itab-curr = itab-wrbtr.
      ELSEIF NOT itab-credit IS INITIAL.
        itab-curr = itab-wrbtr * -1.
      ENDIF.
    ENDIF.

    READ TABLE lt_skat INTO ls_skat WITH KEY saknr = itab-akont.
    IF sy-subrc IS INITIAL.
      CONCATENATE itab-akont ls_skat-txt50 INTO itab-rec_txt SEPARATED BY space.
    ELSE.
      itab-rec_txt = itab-akont.
    ENDIF.
    SHIFT itab-rec_txt LEFT DELETING LEADING '0'.
    MODIFY itab.

  ENDLOOP.
  CLEAR:wa_bseg.


ENDFORM.                    " DATALIST_Bsak


*&---------------------------------------------------------------------*
*&      Form  fill_fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fill_fieldcatalog.

  PERFORM f_fieldcatalog USING '1'   'GROUP'     'GL Type'.
  PERFORM f_fieldcatalog USING '2'   'BEZEI'     'Sales Office'.
  PERFORM f_fieldcatalog USING '3'   'KUNNR'     'Customer Code'.
  PERFORM f_fieldcatalog USING '4'   'NAME1'     'Customer Name'.
  PERFORM f_fieldcatalog USING '5'   'NAME2'     'Bill to Name'.
  PERFORM f_fieldcatalog USING '6'   'STREET'    'Address'.
  PERFORM f_fieldcatalog USING '7'   'ADDRESS'    'City ST ZIP'.
  PERFORM f_fieldcatalog USING '8'   'REF'        'Reference No.'.
  PERFORM f_fieldcatalog USING '9'   'BKTXT'      'Order No.'.
  PERFORM f_fieldcatalog USING '10'   'BLDAT'     'Document Date'.
  PERFORM f_fieldcatalog USING '11'   'BUDAT'     'Posting Date'.
  PERFORM f_fieldcatalog USING '12'   'REC_TXT'   'Reconciliation Account'.
  PERFORM f_fieldcatalog USING '13'   'DUEDATE'   'Due Date'.
  PERFORM f_fieldcatalog USING '14'   'BLART'     'FI Doc Type'.
  PERFORM f_fieldcatalog USING '15'   'FI_DESC'   'FI Doc Type Desc'.
  PERFORM f_fieldcatalog USING '16'   'BELNR'     'FI Doc No.'.
  PERFORM f_fieldcatalog USING '17'   'VBELN'     'Invoice No.'.
*  PERFORM f_fieldcatalog USING '11'  'XBLNR'     'Tax Invoice No.(ODN)'.
*  PERFORM f_fieldcatalog USING '12'  'FKDAT'     'Tax Invoice Date'.
  PERFORM f_fieldcatalog USING '18'  'VTEXT'     'Payment Terms'.
  PERFORM f_fieldcatalog USING '19'  'AUBEL'     'Sales Order No.'.
  PERFORM f_fieldcatalog USING '20'  'AUDAT'     'Sales Order Date'.
  PERFORM f_fieldcatalog USING '21'  'BSTNK'     'Customer PO. NO.'.
  PERFORM f_fieldcatalog USING '22'  'BSTDK'     'Customer PO. Date'.
  PERFORM f_fieldcatalog USING '23'  'CURR'      'Amt Document Currency'.
  PERFORM f_fieldcatalog USING '24'  'WAERS'     'Currency Key'.
  PERFORM f_fieldcatalog USING '25'  'DEBIT'     'Original Document Amt ' ."'Total Pending DR'.
  PERFORM f_fieldcatalog USING '26'  'SKNTO'     'Discount Amt' .
  PERFORM f_fieldcatalog USING '27'  'CREDIT'    'Total Rec/Cre Memo Amt' . "'Total Pending CR'.
  PERFORM f_fieldcatalog USING '28'  'NETBAL'    'Total Outstanding'. "'Net Pending'.
  PERFORM f_fieldcatalog USING '29'  'NOT_DUE'   'Not Due'. "'Net Balance'.
  PERFORM f_fieldcatalog USING '30'  'NETB30'     rc17. "'Net Balance'.
  PERFORM f_fieldcatalog USING '31'  'NETB60'     rc18. "'Net Balance'.
  PERFORM f_fieldcatalog USING '32'  'NETB90'     rc19. "'Net Balance'.
  PERFORM f_fieldcatalog USING '33'  'NETB120'    rc20. "'Net Balance'.
  PERFORM f_fieldcatalog USING '34'  'NETB180'    rc21. "'Net Balance'.
  PERFORM f_fieldcatalog USING '35'  'NETB360'    rc22. "'Net Balance'.
  PERFORM f_fieldcatalog USING '36'  'NETB720'    rc23. "'Net Balance'.
  PERFORM f_fieldcatalog USING '37'  'NETB1000'   rc14. "'Net Balance'.
  PERFORM f_fieldcatalog USING '38'  'DAY'        'Over Due Days'.
  PERFORM f_fieldcatalog USING '39'  'EMAIL'       'Email'.

ENDFORM.                    " FILL_FIELDCATALOG

*&---------------------------------------------------------------------*
*&      Form  sort_list
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM sort_list.
  t_sort-spos      = '1'.
  t_sort-fieldname = 'GROUP'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '2'.
  t_sort-fieldname = 'KUNNR'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '3'.
  t_sort-fieldname = 'NAME1'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '4'.
  t_sort-fieldname = 'BLDAT'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
  t_sort-subtot    = ' '.
  APPEND t_sort.

ENDFORM.                    " sort_list

*&---------------------------------------------------------------------*
*&      Form  fill_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fill_layout.
  fs_layout-colwidth_optimize = 'X'.
  fs_layout-zebra             = 'X'.
  fs_layout-detail_popup      = 'X'.
  fs_layout-subtotals_text    = 'DR'.

ENDFORM.                    " fill_layout

*&---------------------------------------------------------------------*
*&      Form  f_fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->VALUE(X)   text
*      -->VALUE(F1)  text
*      -->VALUE(F2)  text
*----------------------------------------------------------------------*
FORM f_fieldcatalog  USING   VALUE(x)
                             VALUE(f1)
                             VALUE(f2).
  t_fieldcat-col_pos      = x.
  t_fieldcat-fieldname    = f1.
  t_fieldcat-seltext_l    = f2.
*  t_fieldcat-decimals_out = '2'.

  IF f1 = 'DEBIT'    OR f1 = 'CREDIT'    OR f1 = 'DEBIT30'  OR f1 = 'CREDIT30'  OR
     f1 = 'DEBIT60'  OR f1 = 'CREDIT60'  OR f1 = 'DEBIT90'  OR f1 = 'CREDIT90'  OR
     f1 = 'DEBIT120' OR f1 = 'CREDIT120' OR f1 = 'DEBIT180' OR f1 = 'CREDIT180' OR
     f1 = 'DEBIT360' OR f1 = 'CREDIT360' OR f1 = 'NETBAL'   OR f1 = 'NETB30'    OR
     f1 = 'NETB60'   OR f1 = 'NETB90'    OR f1 = 'NETB120'  OR f1 = 'NETB180'   OR
     f1 = 'NETB360'  OR f1 = 'NETB720'   OR f1 = 'NETB1000'   OR f1 = 'NOT_DUE' OR
     f1 = 'SKNTO'    OR f1 = 'CURR'      OR f1 = 'DEBIT'.

    t_fieldcat-do_sum = 'X'.
  ENDIF.

  IF f1 = 'BELNR'.
    t_fieldcat-hotspot = 'X'.
  ENDIF.
  APPEND t_fieldcat.
  CLEAR t_fieldcat.

ENDFORM.                    " f_fieldcatalog

*&---------------------------------------------------------------------*
*&      Form  list_display
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM list_display.

  DATA : lwa_param       TYPE sfpoutputparams,
         lv_doc_params   TYPE sfpdocparams,
         ls_form_output  TYPE fpformoutput,
         lv_funcname     TYPE funcname,
         lv_xstring      TYPE xstring,
         lv_bin_filesize TYPE i.

  IF chkb = 'X'.

lwa_param-DEVICE = 'PRINTER'.

lwa_param-DEST = 'LP01'.

IF SY-UCOMM = 'PRNT'.

lwa_param-NODIALOG = 'X'.

lwa_param-PREVIEW = ''.

lwa_param-REQIMM = 'X'.

ELSE.

lwa_param-NODIALOG = ''.

lwa_param-PREVIEW = 'X'.

ENDIF.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lwa_param
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      MESSAGE 'Error initializing Adobe form' TYPE 'E'.
    ENDIF.





    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = 'ZUS_CUST_STATEMENT_NEW'
      IMPORTING
        e_funcname = lv_funcname
*       E_INTERFACE_TYPE           =
*       EV_FUNCNAME_INBOUND        =
      .

*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname = 'ZUS_CUST_STATEMENT_NEW'
**     VARIANT  = ' '
**     DIRECT_CALL              = ' '
*    IMPORTING
*      fm_name  = fm_name
** EXCEPTIONS
**     NO_FORM  = 1
**     NO_FUNCTION_MODULE       = 2
**     OTHERS   = 3
*    .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.


*  IF chkb = 'X'.



    LOOP AT it_kunnr INTO wa_kunnr.
      CLEAR wa_final.
      REFRESH : it_final_new.
      LOOP AT it_final INTO wa_final WHERE kunnr = wa_kunnr-kunnr.

        CLEAR : tab_otf_data.
        APPEND wa_final TO it_final_new.
      ENDLOOP.


*if chkb = abap_true.
*  lwa_param-preview = space.
*  lwa_param-getpdf = abap_true.
*else.
*  lwa_param-preview = 'X'.
*  ENDIF.

*      cparam-no_dialog = 'X'.
*      cparam-getotf = 'X'.

*-----------------------------------------------------
      DATA: it_data TYPE zus_cust_statement_tt.
      it_data = CORRESPONDING #( it_final_new ).

      LOOP AT  it_data INTO DATA(w_data).
        IF w_data-debit < 0 .
          w_data-original =      w_data-debit *   -1  .
          WRITE w_data-original TO lv_temp CURRENCY w_data-waers.
          CONDENSE lv_temp NO-GAPS.
          w_data-original_disp = |({ lv_temp })|.
        ELSE.
          w_data-original =      w_data-debit.
          w_data-original_disp = |{ w_data-original }|.
        ENDIF.

        IF  w_data-netbal  < 0 .
          w_data-total =      w_data-netbal *   -1  .
          WRITE w_data-total TO lv_temp1 CURRENCY w_data-waers.
          CONDENSE lv_temp1 NO-GAPS.
          w_data-total_disp = |({ lv_temp1 })|.
        ELSE.
          w_data-total =      w_data-netbal.
          w_data-total_disp = |{ w_data-total }|.
        ENDIF.

        MODIFY it_data FROM w_data TRANSPORTING original total original_disp total_disp .
      ENDLOOP.




      CALL FUNCTION lv_funcname  "'/1BCDWB/SM00000070'
        EXPORTING
          /1bcdwb/docparams  = lv_doc_params
*         job_output_info    = tab_otf_data
*         user_settings      = 'X'
*         control_parameters = cparam
*         output_options     = outop
          itab               = it_data "it_final_new
          kunnr              = wa_kunnr-kunnr
          plant              = 'US00'
        IMPORTING
          /1bcdwb/formoutput = ls_form_output
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.



      CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      lv_xstring = ls_form_output-pdf.

      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer          = lv_xstring
          append_to_table = ' '
        IMPORTING
          output_length   = lv_bin_filesize
        TABLES
          binary_tab      = lt_bcs_pdf.

      IF sy-subrc = 0.
        MESSAGE 'Mail Send Successfully' TYPE 'S'.
      ENDIF.



*      CALL FUNCTION fm_name          "'/1BCDWB/SF00000053'
*        EXPORTING
**         ARCHIVE_INDEX      =
**         ARCHIVE_INDEX_TAB  =
**         ARCHIVE_PARAMETERS =
*          control_parameters = cparam
**         MAIL_APPL_OBJ      =
**         MAIL_RECIPIENT     =
**         MAIL_SENDER        =
*          output_options     = outop
*          user_settings      = 'X'
*          kunnr              = wa_kunnr-kunnr
*          plant              = 'US00'
*        IMPORTING
**         DOCUMENT_OUTPUT_INFO       =
*          job_output_info    = tab_otf_data
**         JOB_OUTPUT_OPTIONS =
*        TABLES
*          itab               = it_final_new
*        EXCEPTIONS
*          formatting_error   = 1
*          internal_error     = 2
*          send_error         = 3
*          user_canceled      = 4
*          OTHERS             = 5.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.

*-----------------------------------------------------

*      REFRESH : i_tline,i_record.
*      CLEAR : wa_buffer.
*
*      CALL FUNCTION 'CONVERT_OTF'
*        EXPORTING
*          format                = 'PDF'
*          max_linewidth         = 132
*        IMPORTING
*          bin_filesize          = v_len_in
*        TABLES
*          otf                   = tab_otf_data-otfdata "I_OTF
*          lines                 = i_tline
*        EXCEPTIONS
*          err_max_linewidth     = 1
*          err_format            = 2
*          err_conv_not_possible = 3
*          OTHERS                = 4.
*      IF sy-subrc <> 0.
*      ENDIF.
*      LOOP AT i_tline.
*        TRANSLATE i_tline USING '~'.
*        CONCATENATE wa_buffer i_tline INTO wa_buffer.
*      ENDLOOP.
*      TRANSLATE wa_buffer USING '~'.
*      DO.
*        i_record = wa_buffer.
*        APPEND i_record.
*        SHIFT wa_buffer LEFT BY 255 PLACES.
*        IF wa_buffer IS INITIAL.
*          EXIT.
*        ENDIF.
*      ENDDO.
*      WAIT UP TO 10 SECONDS.
* ATTACHMENT
      REFRESH: i_reclist,
      i_objtxt,
      i_objbin,
      i_objpack.
      CLEAR : wa_objhead ,date,subject,subject.
      i_objbin[] = i_record[].
* CREATE MESSAGE BODY TITLE AND DESCRIPTION
*      i_objtxt = 'Dear Sir/Madam,'.
*      APPEND i_objtxt.
*
*      i_objtxt = ' '.
*      APPEND i_objtxt.

************Added by DH 15.09.22
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = date
        IMPORTING
          output = postdate1.

*      CONCATENATE 'Please find the attached PDF copy of Outstanding Balance as on' postdate1 '.' INTO lv_text SEPARATED BY space.
*--------------------------------------start added by shubhangi 12.12.24-------------------------------------
********************** add by supriya on 02.01.2025 mail data currection done
* 'This is a friendly reminder that your account is overdue. Your statement is attached.  Please make necessary arrangements for prompt payment. '.
* tr- DEVK915288
      DATA(lv_text1) = 'Greetings, '.
      DATA(lv_text2) = 'This is a friendly reminder that your account is overdue. Your statement is attached.  Please make necessary arrangements for prompt payment. '.
      DATA(lv_text3) = 'Attachment in mail '.
      CONCATENATE lv_text1 lv_text2  lv_text3 INTO lv_text SEPARATED BY cl_abap_char_utilities=>cr_lf..
*--------------------------------------End added by shubhangi 12.12.24-------------------------------------
      i_objtxt = lv_text.
      APPEND i_objtxt.
*************************
*    i_objtxt = 'Please find the attached PDF copy of Balance Confirmation as on 31 st March 2022.'.
*    APPEND i_objtxt.

*      i_objtxt = ' '.
*      APPEND i_objtxt.
*
*      i_objtxt = ' '.
*      APPEND i_objtxt.
*
*      i_objtxt = 'Thanks & Regards,'.
*      APPEND i_objtxt.

*      i_objtxt = 'DELVAL Flow Controls Pvt Ltd'.
*      APPEND i_objtxt.
*********************************************** add by supriya on 02.01.2024
* address change
** tr- DEVK915288
*      i_objtxt = 'DelVal Flow Controls USA, LLC.'.    ""ve
*      APPEND i_objtxt.
*********************************************

      DESCRIBE TABLE i_objtxt LINES v_lines_txt.
      READ TABLE i_objtxt INDEX v_lines_txt.
      wa_doc_chng-obj_name = 'SMARTFORM'.
      wa_doc_chng-expiry_dat = sy-datum + 0.
      wa_doc_chng-obj_descr = 'Customer Ageing'. "subject . "'CHECK LETTER'.
      wa_doc_chng-sensitivty = 'F'.
      wa_doc_chng-doc_size = v_lines_txt * 255.
* MAIN TEXT
      CLEAR i_objpack-transf_bin.
      i_objpack-head_start = 1.
      i_objpack-head_num = 0.
      i_objpack-body_start = 1.
      i_objpack-body_num = v_lines_txt.
      i_objpack-doc_type = 'RAW'.
      APPEND i_objpack.
* ATTACHMENT (PDF-ATTACHMENT)
      i_objpack-transf_bin = 'X'.
      i_objpack-head_start = 1.
      i_objpack-head_num = 0.
      i_objpack-body_start = 1.
      DESCRIBE TABLE i_objbin LINES v_lines_bin.
      READ TABLE i_objbin INDEX v_lines_bin.
      i_objpack-doc_size = v_lines_bin * 255 .
      i_objpack-body_num = v_lines_bin.
      i_objpack-doc_type = 'PDF'.
      i_objpack-obj_name = 'SMART'.
      i_objpack-obj_descr = attach . "'TEST'.
      APPEND i_objpack.

      CLEAR: lv_adrnr, lv_smtp_addr.
      SELECT SINGLE adrnr
                    FROM kna1
                    INTO lv_adrnr
                    WHERE kunnr = wa_kunnr-kunnr."custno-low.

      SELECT SINGLE smtp_addr
                    FROM adr6
                    INTO lv_smtp_addr
                    WHERE addrnumber = lv_adrnr.

      IF lv_smtp_addr IS NOT INITIAL .
        i_reclist-receiver = lv_smtp_addr.
        i_reclist-rec_type = 'U'.
        APPEND i_reclist.

        DATA lv_sender TYPE so_rec_ext VALUE 'accounting@delvalflow.com'. "added by shubhangi 10.12.24

*        WAIT UP TO 2 SECONDS.    ""VE
*        CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
*          EXPORTING
*            document_data              = wa_doc_chng
*            put_in_outbox              = 'X'
*            sender_address             = lv_sender
*            sender_address_type        = 'INT'
*            commit_work                = 'X'
*          TABLES
*            packing_list               = i_objpack
*            object_header              = wa_objhead
*            contents_bin               = i_objbin
*            contents_txt               = i_objtxt
*            receivers                  = i_reclist
*          EXCEPTIONS
*            too_many_receivers         = 1
*            document_not_sent          = 2
*            document_type_not_exist    = 3
*            operation_no_authorization = 4
*            parameter_error            = 5
*            x_error                    = 6
*            enqueue_error              = 7
*            OTHERS                     = 8.
*
*        IF sy-subrc = 0.
*          MESSAGE 'Mail Send Successfully' TYPE 'S'.
*        ENDIF.

        PERFORM send_mail .

** insert start log message
*      gs_msg-msgty = 'S'.
*      gs_msg-msgid = 'ZUS_DEL_MESSAGE'.
*      gs_msg-msgno = '002'.
*      gs_msg-msgv1 = wa_kunnr-kunnr.
*      APPEND gs_msg TO gt_msg.
*      CLEAR gs_msg.
*       CONCATENATE 'Outstanding Balance confirmation is succesfully, generated mail send to Customer ' wa_kunnr-kunnr
*      INTO gs_message-msg_txt SEPARATED BY space.
*      gs_message-msg_typ = '@08@'.
*      APPEND gs_message TO gt_message.
*      CLEAR gs_message .
*
*       else.
*
** Insert start log message
*      gs_msg-msgty = 'E'.
*      gs_msg-msgid = 'ZUS_DEL_MESSAGE'.
*      gs_msg-msgno = '003'.
*      gs_msg-msgv1 = wa_kunnr-kunnr.
*      APPEND gs_msg TO gt_msg.
*      CLEAR gs_msg.
*
*
*      CONCATENATE 'Mail ID does not exist againts Customer ' wa_kunnr-kunnr
*      INTO gs_message-msg_txt SEPARATED BY space.
*      gs_message-msg_typ = '@0A@'.
*      APPEND gs_message TO gt_message.
*      CLEAR gs_message .

      ENDIF.



    ENDLOOP.
*------------------------------"start added by shubhangi 10.12.24----------------------------------
  ELSE.



*    CALL FUNCTION fm_name "'/1BCDWB/SF00000106'      "commented by shubhangi 12.12.2024
*      EXPORTING
*        control_parameters = cparam
*      TABLES
*        itab               = it_final.
*
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.

*BREAK PRIMUSABAP.
    DATA : gv_tot_lines          TYPE i.
    DESCRIBE TABLE it_kunnr LINES gv_tot_lines .
*    data(it_final1) = it_final.
*    delete ADJACENT DUPLICATES FROM it_final1 COMPARING kunnr.
*BREAK-POINT.
    LOOP AT it_kunnr INTO wa_kunnr.
      REFRESH : it_final_new.
      LOOP AT it_final INTO wa_final WHERE kunnr = wa_kunnr-kunnr.

        CLEAR : tab_otf_data.
        APPEND wa_final TO it_final_new.
      ENDLOOP.
      IF sy-tabix = 1.
* DIALOG AT FIRST LOOP ONLY
        gs_con_settings-no_dialog = abap_false.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
        gs_con_settings-no_open   = abap_false.
* CLOSE SPOOL AT THE LAST LOOP ONLY
        gs_con_settings-no_close  = abap_true.
      ELSE.
* DIALOG AT FIRST LOOP ONLY
        gs_con_settings-no_dialog = abap_true.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
        gs_con_settings-no_open   = abap_true.
      ENDIF.

      IF sy-tabix = gv_tot_lines.
* CLOSE SPOOL
        gs_con_settings-no_close  = abap_false.
      ENDIF.
      it_data = CORRESPONDING #( it_final_new ).
      CLEAR :w_data.

      LOOP AT  it_data INTO w_data .
        IF w_data-debit < 0 .
          w_data-original =      w_data-debit *   -1  .
          WRITE w_data-original TO lv_temp CURRENCY w_data-waers.
          CONDENSE lv_temp NO-GAPS.
          w_data-original_disp = |({ lv_temp })|.


        ELSE.
          w_data-original =      w_data-debit .
          w_data-original_disp = |{ w_data-original }|.
        ENDIF.

        IF  w_data-netbal  < 0 .
          w_data-total =      w_data-netbal *   -1  .
          WRITE w_data-total TO lv_temp1 CURRENCY w_data-waers.
          CONDENSE lv_temp1 NO-GAPS.
          w_data-total_disp = |({ lv_temp1 })|.
        ELSE.
          w_data-total =      w_data-netbal.
          w_data-total_disp = |{ w_data-total }|.
        ENDIF.
        MODIFY it_data FROM w_data TRANSPORTING original total original_disp total_disp.
      ENDLOOP.


      CALL FUNCTION 'FP_JOB_OPEN'
        CHANGING
          ie_outputparams = lwa_param
        EXCEPTIONS
          cancel          = 1
          usage_error     = 2
          system_error    = 3
          internal_error  = 4
          OTHERS          = 5.
      IF sy-subrc <> 0.
        MESSAGE 'Error initializing Adobe form' TYPE 'E'.
      ENDIF.

      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name     = 'ZUS_CUST_STATEMENT_NEW'
        IMPORTING
          e_funcname = lv_funcname
*         E_INTERFACE_TYPE           =
*         EV_FUNCNAME_INBOUND        =
        .


*      BREAK primusabap.
      CALL FUNCTION lv_funcname   "'/1BCDWB/SM00000070'
        EXPORTING
          /1bcdwb/docparams  = lv_doc_params
*         job_output_info    = tab_otf_data
*         user_settings      = 'X'
*         control_parameters = gs_con_settings
*         output_options     = ls_composer_param
          itab               = it_data        "it_final_new
          kunnr              = wa_kunnr-kunnr
          plant              = 'US00'
        IMPORTING
          /1bcdwb/formoutput = ls_form_output
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.


      CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.



*      CALL FUNCTION fm_name          "'/1BCDWB/SF00000053'
*        EXPORTING
**         ARCHIVE_INDEX      =
**         ARCHIVE_INDEX_TAB  =
**         ARCHIVE_PARAMETERS =
*          control_parameters = gs_con_settings
**         MAIL_APPL_OBJ      =
**         MAIL_RECIPIENT     =
**         MAIL_SENDER        =
*          output_options     = ls_composer_param
***       USER_SETTINGS              = 'X'
*          kunnr              = wa_kunnr-kunnr
*          plant              = 'US00'
**     IMPORTING
**         DOCUMENT_OUTPUT_INFO       =
**         JOB_OUTPUT_INFO    =
**         JOB_OUTPUT_OPTIONS =
*        TABLES
*          itab               = it_final_new
*        EXCEPTIONS
*          formatting_error   = 1
*          internal_error     = 2
*          send_error         = 3
*          user_canceled      = 4
*          OTHERS             = 5.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
      CLEAR : wa_kunnr.
    ENDLOOP.
  ENDIF.
*------------------------------"end added by shubhangi 10.12.24----------------------------------

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM get_data .
  SORT itab BY budat.
  LOOP AT itab.

    wa_final-kunnr    = itab-kunnr   .
    wa_final-budat    = itab-budat   .
    wa_final-duedate  = itab-duedate .
    wa_final-vbeln    = itab-vbeln   .
    wa_final-bstnk    = itab-bstnk   .
    wa_final-debit    = itab-debit   .
    wa_final-netbal   = itab-netbal  .
    wa_final-netb30   = itab-netb30  .
    wa_final-netb60   = itab-netb60  .
    wa_final-netb90   = itab-netb90  .
    wa_final-netb120  = itab-netb120 .
    wa_final-netb180  = itab-netb180 .
    wa_final-netb360  = itab-netb360 .
    wa_final-netb720  = itab-netb720 .
    wa_final-netb1000 = itab-netb1000.
    wa_final-st_date     = date.

    APPEND wa_final TO it_final.
    CLEAR wa_final.
  ENDLOOP.
*  BREAK-POINT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form send_mail
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM send_mail .
  DATA: lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL.
  CLASS cl_bcs DEFINITION LOAD.

  DATA: lo_send_request TYPE REF TO cl_bcs VALUE IS INITIAL.
  lo_send_request = cl_bcs=>create_persistent( ).

* Message body and subject

  DATA: lt_message_body TYPE bcsy_text VALUE IS INITIAL,
        lo_document     TYPE REF TO cl_document_bcs VALUE IS INITIAL,
        wa_body         TYPE soli.

  APPEND 'Dear Sir/Madam,' TO lt_message_body.
  APPEND ' ' TO lt_message_body.

  wa_body-line = lv_text .

  APPEND wa_body TO lt_message_body .

  APPEND ' ' TO lt_message_body.
  APPEND ' ' TO lt_message_body.

  APPEND 'Thanks & Regards,' TO lt_message_body.
  APPEND 'DELVAL Flow Controls USA, LLC.' TO lt_message_body.



  lo_document = cl_document_bcs=>create_document(
    i_type    = 'RAW'
    i_text    = lt_message_body
    i_subject = 'Customer Ageing' ).


  TRY.

      lo_document->add_attachment(
        EXPORTING
          i_attachment_type    = 'PDF'
          i_attachment_subject = ' '
          i_att_content_hex    = lt_bcs_pdf ).

    CATCH cx_document_bcs INTO lx_document_bcs.

  ENDTRY.
  lo_send_request->set_document( lo_document ).

  DATA: lo_sender TYPE REF TO if_sender_bcs VALUE IS INITIAL,

        l_send    TYPE adr6-smtp_addr.

  lo_sender = cl_cam_address_bcs=>create_internet_address( 'accounting@delvalflow.com' ).

*  lo_sender = cl_sapuser_bcs=>create( sy-uname ).

* Set sender

  lo_send_request->set_sender(
    EXPORTING
      i_sender = lo_sender ).


  DATA:

  lo_recipient TYPE REF TO if_recipient_bcs VALUE IS INITIAL.


  IF lv_smtp_addr IS NOT INITIAL .

    lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_smtp_addr ).

** Set recipient

    lo_send_request->add_recipient(
      EXPORTING
        i_recipient = lo_recipient
        i_express   = 'X' ).

*  lo_send_request->add_recipient(

*  EXPORTING

*  i_recipient = lo_recipient

*  i_express = 'X' ).

* Send email

    DATA: lv_sent_to_all(1) TYPE c VALUE IS INITIAL.

    lo_send_request->send(
      EXPORTING
        i_with_error_screen = 'X'
      RECEIVING
        result              = lv_sent_to_all ).

    COMMIT WORK.

  ENDIF.
ENDFORM.
