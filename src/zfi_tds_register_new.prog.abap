*&---------------------------------------------------------------------*
*& Report  ZFI_TDS_REGISTER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zfi_tds_register_new.

*INCLUDE Z_CLASSES.
INCLUDE zfi_tds_register_cls_new.
*INCLUDE zfi_tds_register_cls.

TYPES : BEGIN OF t_bkpf,
          bukrs TYPE bukrs,    "  Company Code
          belnr	TYPE belnr_d,	                                                                                  " Accounting Document Number
          gjahr TYPE gjahr,    "  Fiscal Year
          blart	TYPE blart,   "	Document Type
          bldat TYPE bldat,
          budat TYPE budat,    "  Posting Date in the Document
          tcode	TYPE tcode,   "	Transaction Code
          xblnr TYPE xblnr1,
          bktxt TYPE bktxt,
          "monat  TYPE monat, " Fiscal Period
          awkey TYPE awkey,  " Reference Key
        END OF t_bkpf,

        BEGIN OF t_bseg,
          bukrs TYPE bukrs,      "  Company Code
          belnr TYPE belnr_d,  "  Accounting Document Number
          gjahr TYPE gjahr,    "  Fiscal Year
          buzei TYPE buzei,    "  Number of Line Item Within Accounting Document
          koart TYPE koart,   " Account Type
          shkzg TYPE shkzg,   " Debit/Credit Indicator
          qsshb	TYPE qsshb,   " Withholding Tax Base Amount
          valut TYPE valut,   " Value Date
          qbshb	TYPE qbshb,   "	Withholding Tax Amount (in Document Currency)
          secco TYPE secco,   " Section Code
          BUZID TYPE BUZID,   " Section Code
          EBELN TYPE EBELN,
          EBELP TYPE EBELP,
          HKONT TYPE HKONT,
          bschl TYPE bschl,
          ktosl TYPE ktosl,
        END OF t_bseg,

        BEGIN OF ty_bseg,
          bukrs TYPE bseg-bukrs,
*          belnr TYPE bseg-belnr,
          belnr TYPE belnr_d,  "  Accounting Document Number
          gjahr TYPE gjahr,
          koart TYPE koart,
          dmbtr TYPE bseg-dmbtr,
        END OF ty_bseg,

        BEGIN OF t_bseg_cust_vndr,
          bukrs TYPE bukrs,      "  Company Code
          belnr TYPE belnr_d,  "  Accounting Document Number
          gjahr TYPE gjahr,    "  Fiscal Year
          buzei TYPE buzei,    "  Number of Line Item Within Accounting Document
          koart TYPE koart,   " Account Type
          ktosl TYPE ktosl,   " transction key : add by $k date :- 17.11.2017
          hkont TYPE hkont,   " Gl add by $k date :- 17.11.207
          kunnr TYPE kunnr,   " Customer Number 1
          lifnr TYPE lifnr,   " Account Number of Vendor or Creditor
        END OF t_bseg_cust_vndr,

        BEGIN OF t_tax,
          land1     TYPE land1    ,   " Country Key
          witht     TYPE witht    ,   " Indicator for withholding tax type
          wt_withcd	TYPE wt_withcd,   " Withholding tax code
          qscod	    TYPE wt_owtcd	,   " Official Withholding Tax Key
          qsatz     TYPE wt_qsatz,
        END OF t_tax,

        BEGIN OF t_with_item,
          bukrs       TYPE bukrs    ,   " Company Code
          belnr       TYPE belnr_d  ,   " Accounting Document Number
          gjahr       TYPE gjahr    ,   " Fiscal Year
          buzei       TYPE buzei    ,   " Number of Line Item Within Accounting Document
          witht       TYPE witht    ,   " Indicator for withholding tax type
          wt_withcd   TYPE wt_withcd,   " Withholding tax code
          wt_qsshb    TYPE wt_bs1,      " Withholding tax base amount in document currency
          wt_qbshb    TYPE wt_wt1,      " Withholding tax amount in document currency
          qsatz	      TYPE wt_qsatz,    "	Withholding tax rate
          "ctnumber    TYPE ctnumber  , " Withholding Tax Certificate Number
          j_1iintchln	TYPE j_1iintchln, " Challan Number
          j_1iintchdt	TYPE j_1iintchdt, " Challan Date
          j_1ibuzei   TYPE buzei      , " Number of Line Item Within Accounting Document
          "j_1isuramt  TYPE j_1isuramt, " Surcharge amount
          j_1iextchln	TYPE j_1iextchln, "	Challan Numbers- External
          j_1iextchdt	TYPE j_1iextchdt, "	Challan Date - External
          stcd1	      TYPE stcd1,	                                                                                        " BSR Code/Tax Number 1
        END OF t_with_item,

        BEGIN OF t_secco,
*          qscod TYPE wt_owtcd,          " Section Code
*          name  TYPE text40,            " Section Code Description
          witht     TYPE witht    ,   " Indicator for withholding tax type
          wt_withcd TYPE wt_withcd,   " Withholding tax code
          name      TYPE text40,      " Withholding tax code description
        END OF t_secco,

        BEGIN OF t_result,
          belnr      TYPE belnr_D,       " bkpf  : Accounting Document Number
*          secco      TYPE secco,       " bseg : Section Code
          qscod      TYPE wt_owtcd,    " Section

          bktxt      TYPE bktxt,

          secdscr    TYPE text40,      " secco : Section Description
          budat      TYPE budat,         " bkpf :  Posting Date in the Document
          bldat      TYPE bldat,
          xblnr      TYPE xblnr1,

          witht      TYPE witht    ,   " Indicator for withholding tax type
          wt_withcd  TYPE wt_withcd,   " Withholding tax code
*          TEXT40      type TEXT40,      " Withholding tax code description

          panno      TYPE j_1ipanno,   "  Customer/Vendor PAN
          name1      TYPE name1_gp,    "  Name 1
          street     TYPE ad_street,   " Street
          str_suppl1 TYPE ad_strspp1,  " Street 2
          str_suppl2 TYPE ad_strspp2,  " Street 3
          post_code1 TYPE ad_pstcd1,   " City postal code
          city1	     TYPE ad_city1,    " City

          qsshb	     TYPE qsshb,       " bseg : Withholding Tax Base Amount
          qbshb      TYPE qbshb,       "  bseg : Withholding Tax Amount (in Document Currency)
          "j_1isuramt  TYPE j_1isuramt, " with_item : Surcharge amount
          txdep      TYPE qbshb,       " Total Tax deposited : same as qbshb
          paydt      TYPE dats,        " TDS Deposit date
          j_1ichln   TYPE j_1iintchln,   " with_item : Challan Number
          j_1ichdt   TYPE j_1iintchdt,   " with_item : Challan Date
          bsrcd      TYPE char20,      " BSR Code
          qsatz	     TYPE string,      " Withholding tax rate

*  ADD BY $K -----DATE :- 17.11.2017
          lifnr      TYPE lifnr,
          hkont      TYPE STRING,"hkont,
          TXT20      TYPE SKAT-TXT20,
          hkont1(15) TYPE c,
          ktosl      TYPE ktosl,

          awkey(10)  TYPE c,
          gjahr      TYPE rseg-gjahr,
          lfbnr      TYPE rseg-lfbnr,
          bukrs      TYPE bkpf-bukrs,

*         -------------------------
        END OF t_result,

        BEGIN OF t_kna1,
          kunnr TYPE kunnr,              "  Customer Number 1
          name1	TYPE name1_gp,          "	Name 1
          adrnr TYPE adrnr,              "  Address Number
        END OF t_kna1,

        BEGIN OF t_customer,
          kunnr     TYPE kunnr,
          j_1ipanno	TYPE j_1ipanno,     "	Permanent Account Number
        END OF t_customer,

        BEGIN OF t_adrc,
          addrnumber TYPE ad_addrnum,  " Address number
          city1	     TYPE ad_city1,    " City
          post_code1 TYPE ad_pstcd1,   " City postal code
          street     TYPE ad_street,   " Street
          str_suppl1 TYPE ad_strspp1,  " Street 2
          str_suppl2 TYPE ad_strspp2,  " Street 3
        END OF t_adrc,

        BEGIN OF t_lfa1,
          lifnr TYPE lifnr,              "  Vendor Number 1
          name1	TYPE name1_gp,          "	Name 1
          adrnr TYPE adrnr,              "  Address
        END OF t_lfa1,

        BEGIN OF t_vendor,
          lifnr     TYPE lifnr,
          j_1ipanno	TYPE j_1ipanno, "	Permanent Account Number
        END OF t_vendor,

        BEGIN OF t_t012,
          hbkid	TYPE hbkid,	                                                                                  " Short Key for a House Bank
          stcd1	TYPE stcd1,	                                                                                  " Tax Number 1
        END OF t_t012,

        BEGIN OF T_SKAT,
          SAKNR TYPE SAKNR,
          TXT20 TYPE TXT20,
        END OF T_SKAT.
DATA : it_bkpf           TYPE TABLE OF t_bkpf,
       it_bkpf1          TYPE TABLE OF t_bkpf,
       it_bseg           TYPE TABLE OF t_bseg,
       it_bseg2          TYPE TABLE OF t_bseg,
       it_bseg3          TYPE TABLE OF t_bseg,
       it_bseg1          TYPE TABLE OF ty_bseg,
       it_tax            TYPE TABLE OF t_tax,
       it_with_item      TYPE TABLE OF t_with_item,
       it_secco          TYPE TABLE OF t_secco,
       it_result         TYPE TABLE OF t_result,
       it_result2         TYPE TABLE OF t_result,
       it_customer       TYPE TABLE OF t_customer,
       it_vendor         TYPE TABLE OF t_vendor,
       it_kna1           TYPE TABLE OF t_kna1,
       it_lfa1           TYPE TABLE OF t_lfa1,
       it_adrc           TYPE TABLE OF t_adrc,
       it_bseg_cust_vndr TYPE TABLE OF t_bseg_cust_vndr,
       it_bseg_gl        TYPE TABLE OF t_bseg_cust_vndr, " ----------------add by $k date ;- 17.11.2017
       it_result_sum     TYPE TABLE OF t_result,
       it_t012           TYPE TABLE OF t_t012,
       it_SKAT           TYPE TABLE OF t_SKAT,

       wa_bkpf           TYPE t_bkpf,
       wa_bkpf1           TYPE t_bkpf,
       wa_bseg           TYPE t_bseg,
       wa_bseg2          TYPE t_bseg,
       wa_bseg3          TYPE t_bseg,
       wa_bseg1          TYPE ty_bseg,
       wa_tax            TYPE t_tax,
       wa_with_item      TYPE t_with_item,
       wa_secco          TYPE t_secco,
       wa_result         TYPE t_result,
       wa_result2         TYPE t_result,
       wa_customer       TYPE t_customer,
       wa_vendor         TYPE t_vendor,
       wa_kna1           TYPE t_kna1,
       wa_lfa1           TYPE t_lfa1,
       wa_adrc           TYPE t_adrc,
       wa_bseg_cust_vndr TYPE t_bseg_cust_vndr,
       wa_bseg_gl        TYPE t_bseg_cust_vndr, " --------------------------add by $k date :- 17.11.2017\
       wa_result_sum     TYPE t_result,
       wa_t012           TYPE t_t012,
       wa_SKAT           TYPE t_SKAT,

       lv_adrnr          TYPE adrnr,

       alv_obj           TYPE REF TO cl_salv_table,
       lv_handler        TYPE REF TO lcl_salv_event_handler,
       lv_col            TYPE REF TO cl_salv_column,
       lv_cols           TYPE REF TO cl_salv_columns,
       lv_functions      TYPE REF TO cl_salv_functions_list,
       lv_column         TYPE REF TO cl_salv_column_list,

       wf_alv_dt         TYPE REF TO lcl_salv,
       wf_alv_sm         TYPE REF TO lcl_salv,

       ucomm             TYPE sy-ucomm.

TYPES : BEGIN OF ty_belnr1,
          belnr TYPE bkpf-belnr,
          bukrs TYPE bkpf-bukrs,
          gjahr TYPE bkpf-gjahr,
          awkey TYPE bkpf-awkey,  " c,   "bkpf-awkey,
        END OF ty_belnr1.


TYPES : BEGIN OF ty_hkont,
          bukrs TYPE bseg-bukrs,
          belnr TYPE bseg-belnr,
          gjahr TYPE bseg-gjahr,
          buzei TYPE bseg-buzei,
          buzid TYPE bseg-buzid,
          hkont TYPE bseg-hkont,
          bschl TYPE bseg-bschl,
        END OF ty_hkont.

TYPES : BEGIN OF ty_xref3,
          belnr TYPE bseg-belnr,
          bukrs TYPE bseg-bukrs,
          gjahr TYPE bseg-gjahr,
          buzid TYPE bseg-buzid,
*          xref3 TYPE bseg-xref3,
          ebeln TYPE bseg-ebeln,
          ebelp TYPE bseg-ebelp,
        END OF ty_xref3.

TYPES : BEGIN OF ty_ekbe,
          ebeln      TYPE ekbe-ebeln,
          ebelp      TYPE ekbe-ebelp,
          gjahr      TYPE ekbe-gjahr,
          belnr      TYPE ekbe-belnr,
          bewtp      TYPE ekbe-bewtp,
          bwart      TYPE ekbe-bwart,
          belnr1(20) TYPE c,
        END OF ty_ekbe.

DATA : it_belnr1 TYPE STANDARD TABLE OF ty_belnr1,
       wa_belnr1 TYPE ty_belnr1.
DATA : it_hkont TYPE STANDARD TABLE OF ty_hkont,
       wa_hkont TYPE ty_hkont.
DATA : it_xref3 TYPE STANDARD TABLE OF ty_xref3,
       wa_xref3 TYPE ty_xref3.
DATA : it_ekbe  TYPE STANDARD TABLE OF ty_ekbe,
       wa_ekbe  TYPE ty_ekbe.
DATA : it_ekbe1 TYPE STANDARD TABLE OF ty_ekbe,
       wa_ekbe1 TYPE ty_ekbe.

DATA : lv_dmbtr TYPE bseg-dmbtr.

*DATA: lv_awkey TYPE bkpf-awkey.
**DATA : lv_awkey(10) TYPE c.
**DATA : lv_awkey1 TYPE bkpf-awkey.
**DATA : lv_lfbnr TYPE rseg-lfbnr.
**DATA : lv_belnr1 TYPE bkpf-belnr.
**DATA : lv_hkont TYPE bseg-hkont.

DATA : count TYPE string.
CONSTANTS : c_in TYPE char2 VALUE 'IN',
            c_x  VALUE 'X'.

DEFINE reset_column_title.
  CLEAR lv_col.

  lv_col = lv_cols->get_column( &1 ).
  CHECK NOT lv_col IS INITIAL.
    IF NOT &2 IS INITIAL.
      lv_col->set_short_text( &2 ).
    ENDIF.
    IF NOT &3 IS INITIAL.
      lv_col->set_medium_text( &3 ).
    ENDIF.
    IF NOT &4 IS INITIAL.
      lv_col->set_long_text( &4 ).
    ENDIF.
END-OF-DEFINITION.

DEFINE reset_column_title.
  CALL METHOD &1->reset_column_title
    EXPORTING
      i_column = &2
      i_lbl_s  = &3
      i_lbl_m  = &4
      i_lbl_l  = &5
      i_tltip  = &6.
END-OF-DEFINITION.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : so_pdat FOR wa_bkpf-budat OBLIGATORY.
PARAMETERS : p_bukrs TYPE bukrs OBLIGATORY,
             p_gjahr TYPE gjahr OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2. "WITH FRAME TITLE text-001.
PARAMETERS : r1 RADIOBUTTON GROUP rad,
             r2 RADIOBUTTON GROUP rad.
SELECTION-SCREEN END OF BLOCK b2.

INITIALIZATION.
  REFRESH : it_bkpf          ,
            it_bseg          ,
            it_tax           ,
            it_with_item     ,
            it_secco         ,
            it_result        ,
            it_customer      ,
            it_vendor        ,
            it_kna1          ,
            it_lfa1          ,
            it_adrc          ,
            it_bseg_cust_vndr,
            it_result_sum,
            it_t012.

  CLEAR : wa_bkpf          ,
          wa_bseg          ,
          wa_tax           ,
          wa_with_item     ,
          wa_secco         ,
          wa_result        ,
          wa_customer      ,
          wa_vendor        ,
          wa_kna1          ,
          wa_lfa1          ,
          wa_adrc          ,
          wa_bseg_cust_vndr,
          wa_result_sum    ,
          wa_t012          ,

          lv_adrnr         ,

          alv_obj          ,
          lv_handler       ,
          lv_col           ,
          lv_cols          ,
          lv_functions     ,
          lv_column        ,

          ucomm.

  CREATE OBJECT lv_handler.

START-OF-SELECTION.
* Collect documents' info

  PERFORM select_bkpf.
  PERFORM select_bseg.
  PERFORM collect_section_details .
  PERFORM select_with_item.
  PERFORM get_section_info.
*  perform get_challans_info.
  PERFORM get_customer_info.
  PERFORM get_vendor_info.

* Output routines
  PERFORM build_data_for_alv.

*&---------------------------------------------------------------------*
*&   Event END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  IF NOT it_result IS INITIAL.
    CALL SCREEN 0101.
  ENDIF.

* Display ALV
*  PERFORM alv_output.

* lv_col, lv_cols.

*&---------------------------------------------------------------------*
*&      Form  SELECT_BKPF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_bkpf .

  IF r1 = 'X'.
    SELECT
        bukrs
        belnr
        gjahr
        blart
        bldat
        budat
        tcode
        xblnr
        awkey
      FROM bkpf INTO TABLE it_bkpf
      WHERE  bukrs = p_bukrs
        AND bstat  IN (space, 'A' , 'B' , 'D' )
        AND budat IN so_pdat
        AND gjahr = p_gjahr
*      AND blart = 'SA'
        AND stblg = ''.
    IF sy-subrc <> 0.
      MESSAGE TEXT-002 TYPE 'I'.
    ELSE.
      PERFORM process_miro_reversals.
    ENDIF.

*    SELECT SINGLE awkey from bkpf into lv_awkey where bukrs = p_bukrs
*                                                and gjahr = p_gjahr.

*********************ADDED BY DH*******************
  ELSEIF r2 = 'X'.
    SELECT
       bukrs
       belnr
       gjahr
       blart
       bldat
       budat
       tcode
       xblnr
       bktxt
       awkey
     FROM bkpf INTO TABLE it_bkpf
     WHERE  bukrs = p_bukrs
       AND bstat  IN ( space, 'A' , 'B' , 'D' )
       AND budat IN so_pdat
       AND gjahr = p_gjahr
       AND blart = 'SA'
       AND stblg = ''.
    IF sy-subrc <> 0.
      MESSAGE TEXT-002 TYPE 'I'.
    ELSE.
      PERFORM process_miro_reversals.
    ENDIF.
*******************************************************
  ENDIF.
ENDFORM.                    " SELECT_BKPF
*&---------------------------------------------------------------------*
*&      Form  SELECT_BSEG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_bseg .
  IF NOT it_bkpf IS INITIAL.

    IF r1 = 'X'.
      SELECT
          bukrs
          belnr
          gjahr
          buzei
          koart
          shkzg
          qsshb
          valut
          qbshb
          secco
          BUZID
          EBELN
          EBELP
        FROM bseg
        INTO  CORRESPONDING FIELDS OF TABLE it_bseg
        FOR ALL ENTRIES IN it_bkpf
        WHERE  bukrs = it_bkpf-bukrs
          AND belnr  = it_bkpf-belnr
          AND gjahr  = it_bkpf-gjahr
          AND buzei NE '000'
          AND koart  = 'S'
          AND ktosl  = 'WIT'.
*        AND ( bupla IN secco                      " Note 639798
*        OR   secco IN secco )
      "AND secco NE space
************************************ADDED BY DH***********
    ELSEIF r2 = 'X'.
      SELECT
           bukrs
           belnr
           gjahr
           buzei
           koart
           shkzg
           qsshb
           valut
           qbshb
           secco
           BUZID
           EBELN
           EBELP
         FROM bseg
         INTO  CORRESPONDING FIELDS OF TABLE it_bseg
         FOR ALL ENTRIES IN it_bkpf
         WHERE  bukrs = it_bkpf-bukrs
           AND belnr  = it_bkpf-belnr
           AND gjahr  = it_bkpf-gjahr
*        AND buzei NE '000'
*           AND koart  = 'K'
           AND qsskz = 'XX'
           AND ( ktosl  = ' ' OR ktosl = 'EGK' ).
***********************************************************

      IF it_bseg IS NOT INITIAL.
        SELECT bukrs
               belnr
               gjahr
               koart
               dmbtr
          FROM bseg
          INTO CORRESPONDING FIELDS OF TABLE it_bseg1
          FOR ALL ENTRIES IN it_bseg
          WHERE bukrs = it_bseg-bukrs
           AND belnr  = it_bseg-belnr
           AND gjahr  = it_bseg-gjahr
          AND koart = 'S'.
      ENDIF.

    ENDIF.

*    IF it_bseg IS NOT INITIAL.
*      SELECT belnr
*             dmbtr
*        FROM bseg
*        INTO CORRESPONDING FIELDS OF TABLE it_bseg1
*        FOR ALL ENTRIES IN it_bseg
*        WHERE bukrs = it_bseg-bukrs
*         AND belnr  = it_bseg-belnr
*         AND gjahr  = it_bseg-gjahr
*        AND koart = 'S'.
*    ENDIF.

    IF sy-subrc = 0.
      SORT it_bseg.
      SELECT bukrs
             belnr
             gjahr
             buzei
             koart
             ktosl
             hkont
             kunnr
             lifnr
        FROM bseg
        INTO CORRESPONDING FIELDS OF TABLE it_bseg_cust_vndr
        FOR ALL ENTRIES IN it_bseg
        WHERE bukrs   = it_bseg-bukrs
        AND belnr   = it_bseg-belnr
        AND gjahr   = it_bseg-gjahr
        AND koart IN ('D', 'K').

      SELECT bukrs
             belnr
             gjahr
             buzei
             koart
             ktosl
             hkont
             kunnr
             lifnr
        FROM bseg
        INTO CORRESPONDING FIELDS OF TABLE it_bseg_gl
        FOR ALL ENTRIES IN it_bseg_cust_vndr
        WHERE bukrs   = it_bseg_cust_vndr-bukrs
        AND belnr   = it_bseg_cust_vndr-belnr
        AND gjahr   = it_bseg_cust_vndr-gjahr
        AND koart = 'S'.

*************************

****************************

*********************CHANGED BY DH************
      IF r1 = 'X'.
        DELETE it_bseg_gl WHERE ktosl <> space AND ktosl <> 'WIT'.
      ELSEIF r2 = 'X'.
        DELETE it_bseg_gl WHERE ktosl = 'WIT'.
      ENDIF.
*******************************************************

      DELETE ADJACENT DUPLICATES FROM it_bseg_gl COMPARING belnr.
*      DELETE IT_BSEG_GL WHERE KTOSL <> SPACE OR KTOSL <> 'WIT'.
      IF sy-subrc = 0.
        SORT it_bseg_cust_vndr.
      ENDIF.
*******************************DH 22.12.22
*      IF R1 = 'X'.
*        SELECT belnr bukrs gjahr buzid xref3 FROM bseg INTO TABLE it_xref3 FOR ALL ENTRIES IN it_bseg_gl
*                                                   WHERE bukrs = it_bseg_gl-bukrs
*                                                   AND belnr = it_bseg_gl-belnr
*                                                   AND gjahr = it_bseg_gl-gjahr
*                                                   AND buzid = 'W'.

      SELECT belnr bukrs gjahr buzid ebeln ebelp FROM bseg INTO TABLE it_xref3 FOR ALL ENTRIES IN it_bseg_gl
                                               WHERE bukrs = it_bseg_gl-bukrs
                                               AND belnr = it_bseg_gl-belnr
                                               AND gjahr = it_bseg_gl-gjahr
                                               AND buzid = 'W'.

      SELECT belnr gjahr FROM ekbe INTO TABLE it_ekbe FOR ALL ENTRIES IN it_xref3
                                                WHERE ebeln = it_xref3-ebeln
                                                AND ebelp = it_xref3-ebelp
                                                AND gjahr = it_xref3-gjahr
                                                AND bewtp = 'E'
                                                AND ( bwart = '101' OR bwart = '105' ).


*        DATA : lv1_xref3(18) TYPE c.
*        DATA : lv1_hkont TYPE bseg-hkont.
*      LOOP AT it_xref3 INTO wa_xref3.
**              lv1_xref3 = <lfs_xref3>-xref3+4(10).
*        CONCATENATE wa_xref3-xref3+4(10) wa_xref3-gjahr INTO wa_xref3-xref3.
*        MODIFY it_xref3 FROM wa_xref3 TRANSPORTING xref3.
**              CLEAR <lfs_xref3>.
*      ENDLOOP.

      LOOP AT it_ekbe INTO wa_ekbe.
        CONCATENATE wa_ekbe-belnr wa_ekbe-gjahr INTO wa_ekbe-belnr1.
        MODIFY it_ekbe FROM wa_ekbe TRANSPORTING belnr1.
      ENDLOOP.



*
*      SORT it_xref3 BY belnr.
*
*      IF it_xref3 IS NOT INITIAL.
*
*        SELECT belnr bukrs gjahr awkey FROM bkpf INTO TABLE it_belnr1 FOR ALL ENTRIES IN it_xref3
*                                                              WHERE awkey = it_xref3-xref3.

      IF it_ekbe IS NOT INITIAL.
        SELECT belnr bukrs gjahr awkey FROM bkpf INTO TABLE it_belnr1 FOR ALL ENTRIES IN it_ekbe
                                                             WHERE awkey = it_ekbe-belnr1.

      ENDIF.

      IF it_belnr1 IS NOT INITIAL.
*        SELECT bukrs
*               belnr
*               gjahr
*               buzei
*               buzid
*               hkont FROM bseg INTO TABLE it_hkont FOR ALL ENTRIES IN it_belnr1
*                                                             WHERE belnr = it_belnr1-belnr
*                                                             AND bukrs = it_belnr1-bukrs
*                                                             AND gjahr = it_belnr1-gjahr
*                                                             AND buzid = 'M'.

        SELECT bukrs
              belnr
              gjahr
              buzei
              buzid
              hkont FROM bseg INTO TABLE it_hkont FOR ALL ENTRIES IN it_belnr1
                                                            WHERE belnr = it_belnr1-belnr
                                                            AND bukrs = it_belnr1-bukrs
                                                            AND gjahr = it_belnr1-gjahr
                                                            AND ( bschl = '89' OR bschl = '81' OR bschl = '70' ).
      ENDIF.
*
*
*
*      ENDIF.

*******************************29.11.22
    ENDIF.
  ENDIF.
ENDFORM.                    " SELECT_BSEG
*&---------------------------------------------------------------------*
*&      Form  COLLECT_SECTION_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM collect_section_details .
  SELECT
      land1
      witht
      wt_withcd
      qscod
      qsatz
    FROM t059z          "Note 639798
    INTO TABLE it_tax
    WHERE land1   = c_in .
ENDFORM.                    " COLLECT_SECTION_DETAILS

*&---------------------------------------------------------------------*
*&      Form  GET_SECTION_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_section_info .
*  SELECT wt_qscod
*         text40
*    FROM t059ot
*    INTO TABLE it_secco
*    WHERE spras = sy-langu
*      AND land1   = c_in .
*  IF sy-subrc = 0.
*    SORT it_secco BY qscod.
*  ENDIF.

  SELECT
      witht
      wt_withcd
      text40
    FROM t059zt          "Note 639798
    INTO TABLE it_secco
    WHERE land1   = c_in .
  IF sy-subrc = 0.
    SORT it_secco BY witht wt_withcd.
  ENDIF.
ENDFORM.                    " GET_SECTION_INFO

*&---------------------------------------------------------------------*
*&      Form  SELECT_WITH_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_with_item .
  TYPES : BEGIN OF t_j_1iewtchln.
      INCLUDE STRUCTURE j_1iewtchln.
  TYPES : END OF t_j_1iewtchln.

  DATA : it_j_1iewtchln TYPE TABLE OF t_j_1iewtchln,
         wa_j_1iewtchln TYPE t_j_1iewtchln.

  IF r1 = 'X'.
    IF NOT it_bseg IS INITIAL.
      SELECT
          bukrs
          belnr
          gjahr
          buzei
          witht
          wt_withcd
          wt_qsshb
          wt_qbshb
          qsatz
          "ctnumber
          j_1iintchln
          j_1iintchdt
          j_1ibuzei                                                            "j_1isuramt
        FROM with_item
        INTO TABLE it_with_item
        FOR ALL ENTRIES IN it_bseg
        WHERE bukrs   = it_bseg-bukrs
          AND belnr   = it_bseg-belnr
          AND gjahr   = it_bseg-gjahr.
*        AND wt_qsshh NE 0
*        AND j_1ibuzei = it_bseg-buzei.
    ENDIF.
***********************************ADDED BY DH*******************
  ELSEIF r2 = 'X'.
    IF it_bseg1 IS NOT INITIAL.
      SELECT
       bukrs
       belnr
       gjahr
       buzei
       witht
       wt_withcd
       wt_qsshb
       wt_qbshb
       qsatz
       "ctnumber
       j_1iintchln
       j_1iintchdt
       j_1ibuzei                                                            "j_1isuramt
     FROM with_item
     INTO TABLE it_with_item
     FOR ALL ENTRIES IN it_bseg1
     WHERE bukrs   = it_bseg1-bukrs
       AND belnr   = it_bseg1-belnr
       AND gjahr   = it_bseg1-gjahr.
    ENDIF.
  ENDIF.
**********************************************************

  IF it_bseg IS NOT INITIAL.
    IF sy-subrc = 0.
      " Fetch external Challan details
      SELECT * FROM j_1iewtchln INTO TABLE it_j_1iewtchln
        WHERE bukrs = p_bukrs
          AND gjahr = p_gjahr.
      IF sy-subrc = 0.
        SELECT hbkid
               stcd1
          FROM t012
          INTO TABLE it_t012
          FOR ALL ENTRIES IN it_j_1iewtchln
          WHERE bukrs = it_j_1iewtchln-bukrs
            AND hbkid = it_j_1iewtchln-bankl.
      ENDIF.
      LOOP AT it_with_item INTO wa_with_item.

************ADDED BY DH
        IF wa_with_item-qsatz = '0'.
          READ TABLE it_tax INTO wa_tax WITH KEY wt_withcd = wa_with_item-wt_withcd.
          IF sy-subrc = 0.
            wa_with_item-qsatz = wa_tax-qsatz.
          ENDIF.

          MODIFY it_with_item FROM wa_with_item
         TRANSPORTING qsatz.
        ENDIF.
*******************END OF ADDIDTION BY DH

        IF NOT wa_with_item-j_1iintchln IS INITIAL.
          READ TABLE it_j_1iewtchln INTO wa_j_1iewtchln
            WITH KEY bukrs = wa_with_item-bukrs
                     gjahr = wa_with_item-gjahr
                     j_1iintchln = wa_with_item-j_1iintchln
                     j_1iintchdt = wa_with_item-j_1iintchdt .
          IF sy-subrc = 0.
            wa_with_item-j_1iextchln =  wa_j_1iewtchln-j_1iextchln.
            wa_with_item-j_1iextchdt =  wa_j_1iewtchln-j_1iextchdt.
            READ TABLE it_t012 INTO wa_t012 WITH KEY hbkid = wa_j_1iewtchln-bankl.
            IF sy-subrc = 0.
              wa_with_item-stcd1 = wa_t012-stcd1.
            ENDIF.
          ENDIF.

****************
*          IF wa_with_item-qsatz = '0'.
*            READ TABLE it_tax INTO wa_tax WITH KEY wt_withcd = wa_with_item-wt_withcd.
*            IF sy-subrc = 0.
*              wa_with_item-qsatz = wa_tax-qsatz.
*            ENDIF.
*          ENDIF.
*************


          MODIFY it_with_item FROM wa_with_item
            TRANSPORTING j_1iextchln j_1iextchdt stcd1.
        ENDIF.

        CLEAR : wa_with_item, wa_j_1iewtchln, wa_t012.
      ENDLOOP.
    ENDIF.
  ENDIF.

*  IF it_with_item IS NOT INITIAL .
*    DELETE it_with_item WHERE j_1ibuzei IS INITIAL. " added by PW on req of Niraj Rane 31-12-2022
*  ENDIF.

ENDFORM.                    " SELECT_WITH_ITEM

*&---------------------------------------------------------------------*
*&      Form  BUILD_DATA_FOR_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_data_for_alv .
  DATA var TYPE p LENGTH 4 DECIMALS 2.
  SORT : it_with_item, it_bseg BY belnr gjahr.
  LOOP AT it_with_item INTO wa_with_item.
    " Section Code
    READ TABLE it_tax INTO wa_tax WITH KEY land1 = c_in
                               witht     = wa_with_item-witht
                               wt_withcd = wa_with_item-wt_withcd.
    IF sy-subrc = 0.
      " Following if block : to be removed if future-requirements claim
      IF wa_tax-qscod = '206C'.
        CONTINUE.
      ENDIF.

      wa_result-qscod = wa_tax-qscod.
      wa_result-witht     = wa_tax-witht    .
      wa_result-wt_withcd = wa_tax-wt_withcd.

*      READ TABLE it_secco INTO wa_secco WITH KEY qscod = wa_result-qscod.
      READ TABLE it_secco INTO wa_secco WITH KEY witht     = wa_with_item-witht
                                                 wt_withcd = wa_with_item-wt_withcd.
      IF sy-subrc = 0.
        wa_result-secdscr = wa_secco-name.
      ENDIF.
    ENDIF.

*if R1 = 'X'.
    READ TABLE it_bkpf INTO wa_bkpf WITH KEY bukrs = wa_with_item-bukrs
                                             belnr = wa_with_item-belnr
                                             gjahr = wa_with_item-gjahr.
    IF sy-subrc = 0.

      IF r1 = 'X'.
        wa_result-belnr = wa_bkpf-belnr.
        wa_result-budat = wa_bkpf-budat.
        wa_result-bldat = wa_bkpf-bldat.
        wa_result-xblnr = wa_bkpf-xblnr.
*      wa_result-bktxt = wa_bkpf-bktxt.

**********************************ADDED BU DH*************
      ELSEIF r2 = 'X'.
        wa_result-belnr = wa_bkpf-belnr.
        wa_result-budat = wa_bkpf-budat.
        wa_result-bldat = wa_bkpf-bldat.
        wa_result-xblnr = wa_bkpf-xblnr.
        wa_result-bktxt = wa_bkpf-bktxt.
      ENDIF.
*      endif.

      IF r1 = 'X'.
        wa_result-qscod = wa_tax-qscod.
      ELSEIF r2 = 'X'.
        wa_result-qscod = wa_result-bktxt.
      ENDIF.
***********************************************************

      READ TABLE it_bseg_cust_vndr INTO wa_bseg_cust_vndr
        WITH KEY bukrs = wa_with_item-bukrs
                 belnr = wa_with_item-belnr
                 gjahr = wa_with_item-gjahr.
      IF sy-subrc = 0.
        " customer/ Vendor info


        IF wa_bseg_cust_vndr-koart = 'D'.

          READ TABLE it_customer INTO wa_customer WITH KEY kunnr = wa_bseg_cust_vndr-kunnr.
          IF sy-subrc = 0.
            wa_result-panno = wa_customer-j_1ipanno.
          ENDIF.

          READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_bseg_cust_vndr-kunnr.
          IF sy-subrc = 0.
            wa_result-name1 = wa_kna1-name1.
            lv_adrnr = wa_kna1-adrnr.
          ENDIF.
        ELSEIF wa_bseg_cust_vndr-koart = 'K'.
*          add by $k date :- 17.11.2017
          wa_result-lifnr = wa_bseg_cust_vndr-lifnr. "add by $k date :- 17.11.2017
*           --------------------------------------------------------------------------

          READ TABLE it_vendor INTO wa_vendor WITH KEY lifnr = wa_bseg_cust_vndr-lifnr.
          IF sy-subrc = 0.
            wa_result-panno = wa_vendor-j_1ipanno.
          ENDIF.

          READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_bseg_cust_vndr-lifnr.
          IF sy-subrc = 0.
            wa_result-name1 = wa_lfa1-name1.
            lv_adrnr = wa_lfa1-adrnr.
          ENDIF.
        ENDIF.
*        ENDIF.


        " Address Info
        IF NOT lv_adrnr IS INITIAL.
          READ TABLE it_adrc INTO wa_adrc WITH KEY addrnumber = lv_adrnr.
          IF sy-subrc = 0.
            wa_result-city1      = wa_adrc-city1     .
            wa_result-post_code1 = wa_adrc-post_code1.
            wa_result-street     = wa_adrc-street    .
            wa_result-str_suppl1 = wa_adrc-str_suppl1.
            wa_result-str_suppl2 = wa_adrc-str_suppl2.
          ENDIF.
        ENDIF.

        "wa_result-secco = wa_bseg-secco.
        " Negate the values as per the transaction type

        IF r1 = 'X'.
          READ TABLE it_bseg INTO wa_bseg WITH KEY belnr = wa_with_item-belnr
                                                   gjahr = wa_with_item-gjahr.
          IF sy-subrc = 0.
            IF wa_bseg-shkzg = 'S'.
              IF ( wa_with_item-wt_qsshb < 0 AND wa_with_item-wt_qbshb < 0 )
                OR ( wa_with_item-wt_qsshb > 0 AND wa_with_item-wt_qbshb > 0 ).
                wa_with_item-wt_qsshb = wa_with_item-wt_qsshb * -1.
                wa_with_item-wt_qbshb = wa_with_item-wt_qbshb * -1.
              ENDIF.
            ELSEIF wa_bseg-shkzg = 'H'.
              IF ( wa_with_item-wt_qsshb < 0 AND wa_with_item-wt_qbshb < 0 ).
                "OR ( wa_with_item-wt_qsshb > 0 AND wa_with_item-wt_qbshb > 0 ).
                wa_with_item-wt_qsshb = wa_with_item-wt_qsshb * -1.
                wa_with_item-wt_qbshb = wa_with_item-wt_qbshb * -1.
              ENDIF.
            ENDIF.
          ENDIF.

          "E : All amounts should be negated
          wa_result-qsshb  = wa_with_item-wt_qsshb.
          wa_result-qbshb  = wa_with_item-wt_qbshb.
          "wa_result-txddct = wa_with_item-wt_qbshb.

        ELSEIF r2 = 'X'.
          READ TABLE it_bseg1 INTO wa_bseg1 WITH KEY belnr = wa_with_item-belnr
                                                         gjahr = wa_with_item-gjahr.
          IF sy-subrc = 0.
            wa_with_item-wt_qbshb = wa_bseg1-dmbtr.
          ENDIF.

          wa_result-qbshb  = wa_with_item-wt_qbshb.

        ENDIF.

        CLEAR : var.
        var = wa_with_item-qsatz.
        wa_result-qsatz  = var.

        IF NOT wa_with_item-j_1iextchln IS INITIAL.
          wa_result-txdep  = wa_with_item-wt_qbshb.
          wa_result-paydt  = wa_with_item-j_1iextchdt.
          "wa_result-j_1isuramt  = wa_with_item-j_1isuramt. " Surcharge amount
          wa_result-j_1ichln = wa_with_item-j_1iextchln.
          wa_result-j_1ichdt = wa_with_item-j_1iextchdt.
          wa_result-bsrcd    = wa_with_item-stcd1.

        ENDIF.

*        IF not wa_result-qbshb is initial and not wa_result-qsshb is initial.
*          wa_result-tdsrt = wa_result-qbshb / wa_result-qsshb * 100.
*        ENDIF.

*        *  -------------------------addd by $k Date : -17.11.2017-----------
*BREAK-POINT.
        LOOP AT it_bseg_gl INTO wa_bseg_gl WHERE  bukrs = wa_with_item-bukrs AND
                                                  belnr = wa_with_item-belnr AND
                                                  gjahr = wa_with_item-gjahr.

          READ TABLE it_xref3 INTO wa_xref3 WITH KEY bukrs = wa_bseg_gl-bukrs
                                                belnr = wa_bseg_gl-belnr
                                                gjahr = wa_bseg_gl-gjahr
                                                buzid = 'W'.

          READ TABLE it_ekbe INTO wa_ekbe WITH KEY ebeln = wa_xref3-ebeln
                                                   ebelp = wa_xref3-ebelp
                                                   gjahr = wa_xref3-gjahr
                                                   bewtp = 'E'
                                                   bwart = '101'.
*                                                   bwart = '105'.

          READ TABLE it_belnr1 INTO wa_belnr1 WITH KEY awkey = wa_ekbe-belnr1.

*          READ TABLE it_hkont INTO wa_hkont WITH KEY belnr = wa_belnr1-belnr
*                                                     bukrs = wa_belnr1-bukrs
*                                                     gjahr = wa_belnr1-gjahr
*                                                     bschl = '89'.
**                                                   bschl = '81'
**                                                   bschl = '70'.


*          READ TABLE it_hkont INTO wa_hkont WITH KEY belnr = wa_belnr1-belnr
*                                                     bukrs = wa_belnr1-bukrs
*                                                     gjahr = wa_belnr1-gjahr
*                                                     buzid = 'M'.




*          count = count + 1.
**            LOOP at it_bseg2 into wa_bseg2.       "dh06.12
          IF wa_bseg_gl-ktosl = 'WIT'.
*          READ TABLE it_bseg2 into wa_bseg2 with key belnr = wa_bkpf3-belnr
*                                                     bukrs = wa_bkpf3-bukrs
*                                                     gjahr = wa_bkpf3-gjahr
*                                                     bschl = '89'.
*          IF wa_bseg_gl-ktosl = 'WIT'.
*              wa_result-ktosl = wa_bseg_gl-ktosl. "ADDED BY KK
            wa_result-hkont1 = wa_bseg_gl-hkont."add by $k date :- 17.11.2017    **********commented DH 29.11.22
*            wa_result-hkont = wa_bseg_gl-hkont."add by $k date :- 17.11.2017

*            wa_result-hkont1 = wa_bseg2-hkont.
*              wa_result-hkont = lv_hkont.

*              wa_result-hkont = wa_bseg2-hkont.

            DATA(wa_result_tmp) = wa_result.
**            LOOP AT it_hkont INTO wa_hkont WHERE belnr = wa_belnr1-belnr
**                                             AND bukrs = wa_belnr1-bukrs
**                                             AND gjahr = wa_belnr1-gjahr
**                                             AND buzid = 'M'."add by $k date :- 17.11.2017    **********commented DH 29.11.22

               LOOP AT it_hkont INTO wa_hkont WHERE belnr = wa_belnr1-belnr
                                             AND bukrs = wa_belnr1-bukrs
                                             AND gjahr = wa_belnr1-gjahr
                                             AND bSCHL = '89'.
*----------------------------------

              wa_result_tmp-hkont = wa_hkont-hkont.
              count = count + 1.
              IF count = 2.
                CLEAR :wa_result_tmp-qbshb , wa_result_tmp-qsshb,wa_result_tmp-txdep.  ",wa_result-ktosl.

              ENDIF.

              wa_result-hkont = wa_hkont-hkont.
              APPEND wa_result_tmp TO it_result.
              CLEAR: wa_hkont.
            ENDLOOP."it_hkont



*            wa_result-hkont = wa_hkont-hkont.


            IF count = 2.
              CLEAR :wa_result-qbshb , wa_result-qsshb,wa_result-txdep.  ",wa_result-ktosl.

            ENDIF.
**            READ TABLE it_hkont INTO wa_hkont WITH KEY belnr = wa_belnr1-belnr
**                                                                 bukrs = wa_belnr1-bukrs
**                                                                 gjahr = wa_belnr1-gjahr
**                                                                 buzid = 'M'. "for Service Invoice
*BREAK-POINT.
            READ TABLE it_hkont INTO wa_hkont WITH KEY belnr = wa_belnr1-belnr
                                                                 bukrs = wa_belnr1-bukrs
                                                                 gjahr = wa_belnr1-gjahr
                                                                 BSCHL = '89'. "for Service Invoice
*-----------------------------------
*            BREAK-POINT.
*              IF wa_result-hkont IS INITIAL.

            IF sy-subrc IS NOT INITIAL.
*             wa_result-hkont = WA_BSEG3-HKONT.
              APPEND wa_result TO it_result.
            ENDIF.
            CLEAR : wa_result, WA_BSEG3.

*            APPEND wa_result TO it_result.
*            CLEAR wa_result.
*                CLEAR : lv_belnr, lv_awkey, lv_awkey1, lv_lfbnr.  """"dh 06.12
*

          ELSEIF wa_bseg_gl-ktosl = space.
            wa_result-hkont = wa_bseg_gl-hkont. "add by $k date :- 17.11.2017
            "  WA_RESULT-KTOSL = WA_BSEG_GL-KTOSL."ADDED BY KK

            IF count = 3.
              CLEAR :wa_result-qbshb , wa_result-qsshb,wa_result-txdep.
            ENDIF.

            APPEND wa_result TO it_result.
            CLEAR wa_result.
*              CLEAR : lv_belnr, lv_awkey, lv_awkey1, lv_lfbnr.   "dh 06.12

          ENDIF.

          CLEAR: wa_xref3, wa_belnr1, wa_hkont.  " added by DH on 23.12.22
        ENDLOOP.
        CLEAR: wa_xref3, wa_belnr1, wa_hkont.  " added by DH on 23.12.22

*************************

*************************
*          DELETE ADJACENT DUPLICATES FROM it_result COMPARING belnr. "COMMENT 08.12        "dh06.12
IF R2 = 'X'.
APPEND wa_result TO it_result.
ENDIF.
*        APPEND wa_result TO it_result.
      ENDIF.
    ENDIF.
    CLEAR : wa_bkpf, wa_secco, wa_bseg_cust_vndr, wa_with_item, wa_result, wa_tax , wa_bseg_gl.     "lv_awkey, lv_lfbnr, lv_awkey1, lv_belnr1.
    CLEAR : wa_customer, wa_vendor, wa_kna1, wa_lfa1, lv_adrnr, wa_adrc , count.
    CLEAR : wa_xref3, wa_belnr1, wa_hkont.  " added by DH on 23.12.22
*    CLEAR : wa_bkpf2, wa_bseg2, wa_rseg, wa_bkpf3, lv_awkey.
*      CLEAR : lv_belnr1, lv_awkey, lv_awkey1, lv_lfbnr.
  ENDLOOP.

*  CLEAR : lv_belnr1, lv_awkey, lv_awkey1, lv_lfbnr.

*      delete : it_result WHERE hkont = space. "comment 16.10.2019
  IF NOT it_result IS INITIAL.
*    SORT IT_RESULT BY BUDAT BELNR.
    SORT it_result DESCENDING BY  belnr qscod hkont.
*    SORT it_result BY belnr.


    "DELETE ADJACENT DUPLICATES FROM it_result COMPARING belnr QSCOD . "Comment by sarika Thange 30.10.2019
    DATA : lv_belnr TYPE belnr_d,
           lv_qscod TYPE wt_owtcd.
*BREAK primus.
IF R2 = 'X'.
    LOOP AT it_result INTO wa_result.
      IF lv_belnr = wa_result-belnr AND lv_qscod  = wa_result-qscod AND wa_result-hkont IS INITIAL.
        DELETE it_result WHERE belnr = wa_result-belnr AND qscod  = wa_result-qscod AND hkont = space  AND ktosl NE 'WIT'."AND QSSHB IS INITIAL.
      ENDIF.
      lv_belnr = wa_result-belnr.
      lv_qscod = wa_result-qscod.
      CLEAR : wa_result.
    ENDLOOP.
ENDIF.
IF R1 = 'X'.
    LOOP AT  IT_RESULT INTO WA_RESULT.
      IF WA_RESULT-QBSHB = 0.
        DELETE it_result INDEX SY-TABIX.
      ENDIF.
    ENDLOOP.
ENDIF.
    SORT it_result BY budat belnr.
IF R2 = 'X'.
          DELETE ADJACENT DUPLICATES FROM it_result COMPARING belnr. "COMMENT 08.12        "dh06.12
ENDIF.


TYPES : BEGIN OF TY_AWKEY,
        BELNR TYPE BSEG-BELNR,
        BUKRS TYPE BSEG-BUKRS,
        GJAHR TYPE BSEG-GJAHR,
        AWKEY TYPE STRING,"AWKEY,
        AWKET TYPE BKPF-AWKEY,
  END OF TY_AWKEY.

DATA : IT_AWKEY TYPE TABLE OF TY_AWKEY,
       WA_AWKEY TYPE TY_AWKEY.
DATA : GT_BKPF TYPE TABLE OF T_BKPF,
       GS_BKPF TYPE T_BKPF.
DATA : GV_AWKEYL TYPE STRING,
       GV_BUKRSL TYPE STRING,
       GV_BELNRL TYPE STRING,
       GV_GJAHRL TYPE STRING,
       GV_COUNT1 TYPE STRING,
       GV_RESULT TYPE STRING.



*****************************************Expense GL**************************************
IT_RESULT2 = IT_RESULT[].
DESCRIBE TABLE IT_RESULT LINES GV_RESULT.
LOOP AT it_result INTO WA_result.
IF SY-TABIX LE GV_RESULT.

                DATA : GV_EBELN  TYPE STRING, "BSEG
                       GV_EBELP  TYPE STRING, "BSEG
                       GV_GJAHR  TYPE STRING, "BSEG
                       GV_HKONT  TYPE STRING, "BSEG

                       GV_BELNR  TYPE STRING, "EKBE
                       GV_GJAHR1 TYPE STRING, "EKBE

                       GV_AWKEY  TYPE STRING, "BKPF
                       GV_BELNR1 TYPE STRING, "BKPF
                       GV_GJAHR2 TYPE STRING, "BSEG
                       GV_BUKRS1 TYPE STRING, "BSEG
                       GV_CNT    TYPE STRING, "
                       GV_CONT   TYPE STRING, "
                       GV_LINE   TYPE STRING, "
                       GV_LINE1  TYPE STRING, "
                       GV_TXT20  TYPE STRING. "

GV_CNT = SY-TABIX.                                                                          "For Count
                SELECT SINGLE EBELN EBELP GJAHR
                  FROM BSEG
                  INTO ( GV_EBELN, GV_EBELP, GV_GJAHR ) WHERE bukrs = P_BUKRS AND
                                                             belnr = WA_result-belnr AND
                                                             gjahr = P_GJAHR AND
                                                             ( BUZID = 'W' OR BUZID = 'F' ).
                  IF SY-SUBRC = 4.
                  SELECT bukrs
                         belnr
                         gjahr
                         buzei
                         koart
                         shkzg
                         qsshb
                         valut
                         qbshb
                         secco
                         BUZID
                         EBELN
                         EBELP
                         HKONT
                         bschl
                       FROM BSEG
                    INTO TABLE IT_BSEG2
                    WHERE BELNR = WA_RESULT-BELNR
                    AND BUKRS = P_BUKRS
                    AND GJAHR = p_gjahr
                    AND ( KOART = 'S' OR KOART = 'A' ) AND ( KTOSL = '' OR KTOSL = 'ANL' OR KTOSL = 'KBS' ).
                  ENDIF.


                SELECT SINGLE BELNR GJAHR
                  FROM EKBE
                  INTO ( GV_BELNR, GV_GJAHR1 ) WHERE EBELN = GV_EBELN AND
                                                     EBELP = GV_EBELP AND
                                                      BEWTP = 'E' AND
                                                   ( BWART = '101' OR BWART = '105' ).
                  CONCATENATE GV_BELNR GV_GJAHR1 INTO GV_AWKEY.

                SELECT SINGLE BELNR BUKRS GJAHR
                  FROM BKPF
                  INTO ( GV_BELNR1, GV_BUKRS1, GV_GJAHR2 ) WHERE AWKEY = GV_AWKEY.

                SELECT bukrs
                       belnr
                       gjahr
                       buzei
                       koart
                       shkzg
                       qsshb
                       valut
                       qbshb
                       secco
                       BUZID
                       EBELN
                       EBELP
                       HKONT
                       bschl
                       ktosl
                      FROM BSEG INTO TABLE IT_BSEG3
                      WHERE BELNR = GV_BELNR1 AND
                            BUKRS = GV_BUKRS1 AND
                            GJAHR = GV_GJAHR2 AND
                            KTOSL = 'FRL'     AND
                            BSCHL = '86'.

               IF IT_BSEG3 IS INITIAL.
                SELECT bukrs
                       belnr
                       gjahr
                       buzei
                       koart
                       shkzg
                       qsshb
                       valut
                       qbshb
                       secco
                       BUZID
                       EBELN
                       EBELP
                       HKONT
                       bschl
                       ktosl
                      FROM BSEG INTO TABLE IT_BSEG3
                      WHERE BELNR = GV_BELNR1 AND
                            BUKRS = GV_BUKRS1 AND
                            GJAHR = GV_GJAHR2 AND
*                            KTOSL = 'FRL'     AND
                          ( BSCHL = '89' OR BSCHL = '81' OR BSCHL = '70' ).

               ENDIF.


DESCRIBE TABLE IT_BSEG3 LINES GV_LINE.
*BREAK-POINT.
IF IT_BSEG3 IS NOT INITIAL.
                  LOOP AT IT_BSEG3 INTO WA_BSEG3 WHERE BELNR = GV_BELNR1 AND
                                                       BUKRS = GV_BUKRS1 AND
                                                       GJAHR = GV_GJAHR2.
                    GV_COUNT1 = GV_COUNT1 + 1.
                    DELETE ADJACENT DUPLICATES FROM IT_BSEG3 COMPARING HKONT.

                      IF GV_LINE LT 2.
                      GV_CONT = WA_BSEG3-HKONT .
                      SHIFT GV_CONT LEFT DELETING LEADING '0'.
                      WA_RESULT-HKONT = GV_CONT.

                        SELECT SINGLE TXT20 FROM SKAT INTO ( GV_TXT20 ) WHERE SAKNR = WA_BSEG3-HKONT AND KTOPL = '1000'.
                          WA_RESULT-TXT20 = GV_TXT20.
                      MODIFY IT_RESULT INDEX GV_CNT FROM WA_RESULT TRANSPORTING HKONT TXT20.
                    ELSE.
                       SELECT SINGLE TXT20 FROM SKAT INTO ( GV_TXT20 ) WHERE SAKNR = WA_BSEG3-HKONT AND KTOPL = '1000'.
                      SHIFT WA_BSEG3-HKONT LEFT DELETING LEADING '0'.
                      WA_RESULT-HKONT = WA_BSEG3-HKONT.

                      IF GV_COUNT1 = 1.
                        WA_RESULT-HKONT = WA_BSEG3-HKONT.
                        WA_RESULT-TXT20 = GV_TXT20.
                        MODIFY IT_RESULT INDEX GV_CNT FROM WA_RESULT TRANSPORTING HKONT TXT20.
                      ENDIF.

                            IF GV_COUNT1 GT 1.
                              WA_RESULT-BELNR = WA_RESULT-belnr.
                              WA_RESULT-HKONT = WA_BSEG3-HKONT.
                              WA_RESULT-qsshb = ''.
                              WA_RESULT-qbshb = ''.
                              WA_RESULT-TXT20 = GV_TXT20.
                              COLLECT WA_RESULT INTO IT_RESULT.
                            ENDIF.
                            CLEAR WA_BSEG3.
*                         ENDIF.
                     ENDIF.


                  ENDLOOP.
CLEAR GV_COUNT1.
ENDIF.

IF IT_BSEG2 IS NOT INITIAL.
DESCRIBE TABLE IT_BSEG2 LINES GV_LINE1.
  LOOP AT IT_BSEG2 INTO WA_BSEG2 WHERE BELNR = WA_RESULT-BELNR.
*                                       BUKRS = GV_BUKRS1
    DELETE ADJACENT DUPLICATES FROM IT_BSEG3 COMPARING HKONT.
    GV_COUNT1 = GV_COUNT1 + 1.

                    IF GV_LINE1 LT 2.
                      GV_CONT = WA_BSEG2-HKONT .
                      SHIFT GV_CONT LEFT DELETING LEADING '0'.
                      WA_RESULT-HKONT = GV_CONT.
                        SELECT SINGLE TXT20 FROM SKAT INTO ( GV_TXT20 ) WHERE SAKNR = WA_BSEG2-HKONT AND KTOPL = '1000'.
                          WA_RESULT-TXT20 = GV_TXT20.
                      MODIFY IT_RESULT INDEX GV_CNT FROM WA_RESULT TRANSPORTING HKONT TXT20.
                    ELSE.
                      SELECT SINGLE TXT20 FROM SKAT INTO ( GV_TXT20 ) WHERE SAKNR = WA_BSEG2-HKONT AND KTOPL = '1000'.
                      SHIFT WA_BSEG2-HKONT LEFT DELETING LEADING '0'.
                         WA_RESULT-HKONT = WA_BSEG2-HKONT.
                            IF GV_COUNT1 = 1.
                                  WA_RESULT-TXT20 = GV_TXT20.
                              MODIFY IT_RESULT INDEX GV_CNT FROM WA_RESULT TRANSPORTING HKONT TXT20.
                            ENDIF.

                            IF GV_COUNT1 GT 1.
                              WA_RESULT-BELNR = WA_RESULT-belnr.
                              WA_RESULT-HKONT = WA_BSEG2-HKONT.
                              WA_RESULT-qsshb = ''.
                              WA_RESULT-qbshb = ''.
*                              WA_RESULT-KBTXT = ''.
                              WA_RESULT-TXT20 = GV_TXT20.
                              COLLECT WA_RESULT INTO IT_RESULT.
                            ENDIF.
                    ENDIF.
   ENDLOOP.
CLEAR GV_COUNT1.
ENDIF.
****************************Expense GL*************************************************************************
CLEAR : WA_BSEG3,WA_BSEG2,WA_RESULT2,GV_CONT,GV_LINE,GV_EBELN,GV_EBELP,GV_GJAHR,GV_TXT20,
        GV_HKONT,GV_GJAHR1,GV_BELNR,GV_BELNR1,GV_GJAHR2,GV_BUKRS1,GV_AWKEY,GV_CONT,GV_LINE,GV_LINE1,GV_CNT.

ENDIF.
ENDLOOP.

    SORT it_result BY belnr .
IF R2 = 'X'.
    LOOP AT it_result INTO wa_result.
      IF ( wa_result-hkont = '240020' or wa_result-hkont = '240030' or wa_result-hkont = '240040' or
           wa_result-hkont = '240050' or wa_result-hkont = '240060' or wa_result-hkont = '240070' or
           wa_result-hkont = '240071' or wa_result-hkont = '240072' or wa_result-hkont = '240080' or
           wa_result-hkont = '240090' or wa_result-hkont = '240100' or wa_result-hkont = '240110' or
           wa_result-hkont = '240120' or wa_result-hkont = '240121' ).
       ELSE.
            DELETE IT_RESULT INDEX SY-TABIX .
      ENDIF.
    ENDLOOP.
ENDIF.
**************************************************************************************************************
    " Generate Summery Report
    PERFORM generate_summery.
  ENDIF.
ENDFORM.                    " BUILD_DATA_FOR_ALV

*&---------------------------------------------------------------------*
*&      Form  PROCESS_MIRO_REVERSALS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process_miro_reversals .
  TYPES : BEGIN OF t_rbkp,
            belnr LIKE rbkp-belnr,
            gjahr LIKE bkpf-awkey,
          END OF t_rbkp.
  DATA : tmp_bkpf TYPE TABLE OF t_bkpf,
         it_rbkp  TYPE TABLE OF t_rbkp,
         wa_rbkp  TYPE t_rbkp.

  REFRESH : it_rbkp, tmp_bkpf.
  CLEAR wa_rbkp.

  tmp_bkpf = it_bkpf.

*  DELETE tmp_bkpf WHERE NOT tcode = 'MIRO'
*                    AND NOT tcode = 'MR8M'.
*                    AND tcode = 'MIR7'. "Note 699664
  IF NOT tmp_bkpf IS INITIAL.
    SELECT belnr
           gjahr
      FROM rbkp
      INTO TABLE it_rbkp
      FOR ALL ENTRIES IN tmp_bkpf
      WHERE belnr = tmp_bkpf-awkey+0(10)
        AND gjahr = tmp_bkpf-gjahr
        AND stblg NE ' '.
    IF sy-subrc = 0.
      LOOP AT it_rbkp INTO wa_rbkp.
        DELETE it_bkpf WHERE awkey+0(10) = wa_rbkp-belnr AND
                                 awkey+10(4) = wa_rbkp-gjahr.
        CLEAR wa_rbkp.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.                    " PROCESS_MIRO_REVERSALS
*&---------------------------------------------------------------------*
*&      Form  GET_CUSTOMER_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_customer_info .
  IF NOT it_bseg IS INITIAL.
    SELECT DISTINCT
          kunnr
          name1
          adrnr
      FROM kna1
      INTO TABLE it_kna1
      FOR ALL ENTRIES IN it_bseg_cust_vndr
      WHERE kunnr = it_bseg_cust_vndr-kunnr.
    IF sy-subrc = 0.
      SORT it_kna1 BY kunnr.

      " PAN Info
      SELECT kunnr j_1ipanno
      FROM j_1imocust
      INTO TABLE it_customer
      FOR ALL ENTRIES IN it_kna1
      WHERE kunnr = it_kna1-kunnr.
      IF sy-subrc = 0.
        SORT it_customer BY kunnr.
      ENDIF.

      " Address info
      SELECT addrnumber
             city1
             post_code1
             street
             str_suppl1
             str_suppl2
        FROM adrc
        INTO TABLE it_adrc
        FOR ALL ENTRIES IN it_kna1
        WHERE addrnumber = it_kna1-adrnr.
      IF sy-subrc = 0.
        SORT it_adrc.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_CUSTOMER_INFO

*&---------------------------------------------------------------------*
*&      Form  get_vendor_info
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_vendor_info.
  IF NOT it_bseg IS INITIAL.
    SELECT DISTINCT
        lifnr
        name1
        adrnr
      FROM lfa1
      INTO TABLE it_lfa1
      FOR ALL ENTRIES IN it_bseg_cust_vndr
      WHERE lifnr = it_bseg_cust_vndr-lifnr.
    IF sy-subrc = 0.
      SORT it_lfa1 BY lifnr.

      " PAN Info
      SELECT lifnr
           j_1ipanno
      FROM j_1imovend
      INTO TABLE it_vendor
      FOR ALL ENTRIES IN it_lfa1
      WHERE lifnr = it_lfa1-lifnr.
      IF sy-subrc = 0.
        SORT it_vendor BY lifnr.
      ENDIF.

      " Address info
      SELECT addrnumber
             city1
             post_code1
             street
             str_suppl1
             str_suppl2
        FROM adrc
        INTO TABLE it_adrc
        FOR ALL ENTRIES IN it_lfa1
        WHERE addrnumber = it_lfa1-adrnr.
      IF sy-subrc = 0.
        SORT it_adrc.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "get_vendor_info

FORM handle_event USING action TYPE char50.
  DATA : v TYPE char100.
  CASE action.
    WHEN 'DOUBLE_CLICK'.
      PERFORM handle_double_click.
  ENDCASE.
ENDFORM.

FORM handle_double_click.
  CLEAR wa_result.
  READ TABLE it_result INTO wa_result INDEX lv_handler->row_id.

  IF lv_handler->col = 'BELNR'.
    SET PARAMETER ID : 'BLN' FIELD wa_result-belnr,
                       'BUK' FIELD p_bukrs,
                       'GJR' FIELD p_gjahr.
    CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GENERATE_SUMMERY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM generate_summery .
  REFRESH it_result_sum.
  LOOP AT it_result INTO wa_result.
    wa_result-belnr    = ''.
    wa_result-budat    = ''.
*    wa_result-bldat    = ''.
*    wa_result-xblnr    = ''.
    wa_result-paydt    = ''.
    wa_result-j_1ichln = ''.
    wa_result-j_1ichdt = ''.
    wa_result-bsrcd    = ''.

         COLLECT wa_result INTO it_result_sum.

  ENDLOOP.
  IF NOT it_result_sum IS INITIAL.
    SORT it_result_sum BY qscod witht wt_withcd name1.
  ENDIF.
ENDFORM.                    " GENERATE_SUMMERY

FORM display_results.
  DATA : "container_obj TYPE REF TO cl_gui_docking_container,
    container_obj TYPE REF TO cl_gui_custom_container,
    splitter_obj  TYPE REF TO cl_gui_splitter_container,
    container_1   TYPE REF TO cl_gui_container,
    container_2   TYPE REF TO cl_gui_container,
    wf_alv_obj    TYPE REF TO cl_salv_table,
    wf_alv_obj1   TYPE REF TO cl_salv_table.

  CREATE OBJECT container_obj
    EXPORTING
      container_name              = 'CSTM_CTRL'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    " Create a splitter control : container for the resultant ALVs
    CREATE OBJECT splitter_obj
      EXPORTING
        parent            = container_obj
        rows              = 2
        columns           = 1
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      " Container to display PO records
      CALL METHOD splitter_obj->get_container
        EXPORTING
          row       = 1
          column    = 1
        RECEIVING
          container = container_1.

      PERFORM create_alv USING container_1
                               it_result
                         CHANGING wf_alv_obj.

      CREATE OBJECT wf_alv_dt
        EXPORTING
          i_alv_obj       = wf_alv_obj
          i_set_all       = c_x
          i_set_optimized = c_x.

      PERFORM set_detail_salv_view.

      "-----------------------------------------------------------------------
      " Container for display Schedule Line records
      CALL METHOD splitter_obj->get_container
        EXPORTING
          row       = 2
          column    = 1
        RECEIVING
          container = container_2.
      CLEAR wf_alv_obj1.

      PERFORM create_alv USING container_2
                               it_result_sum
                         CHANGING wf_alv_obj1.


      CREATE OBJECT wf_alv_sm
        EXPORTING
          i_alv_obj       = wf_alv_obj1
          i_set_all       = c_x
          i_set_optimized = c_x.

      PERFORM set_summary_salv_view .

      "PERFORM reset_column_titles CHANGING wf_alv_dt  wf_alv_sm.

      "PERFORM set_footer USING wf_alv_sm.

      PERFORM display_contents CHANGING wf_alv_dt  wf_alv_sm.
    ENDIF.
  ENDIF.
ENDFORM.

FORM display_contents CHANGING p_alv_dt TYPE REF TO lcl_salv
                              p_alv_sm TYPE REF TO lcl_salv.

  DATA : container_h TYPE REF TO cl_gui_docking_container,
         container_f TYPE REF TO cl_gui_docking_container,

         hdr_obj     TYPE REF TO cl_salv_form_dydos.
*         ftr_obj TYPE REF TO cl_salv_form_dydos.

  PERFORM create_doc_container
    USING cl_gui_docking_container=>dock_at_top
          50
    CHANGING container_h. " for header

*  perform create_doc_container
*    USING cl_gui_docking_container=>dock_at_bottom
*          75
*    CHANGING container_f. " For footer
  " Display Headers
  CREATE OBJECT hdr_obj
    EXPORTING
      r_container = container_h
      r_content   = p_alv_dt->alv_hdr.
  hdr_obj->display( ).

  " Display ALVs
  p_alv_dt->display( ).
  p_alv_sm->display( ).

*  " Display Footer
*  create object ftr_obj
*    exporting
*      r_container = container_f
*      r_content   = p_alv_sm->alv_ftr.
*
*  ftr_obj->display( ).
ENDFORM.

FORM create_alv USING p_container   TYPE REF TO cl_gui_container
                      p_tab         TYPE table
                CHANGING p_alv_obj TYPE REF TO cl_salv_table.
  TRY .
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          r_container  = p_container
        IMPORTING
          r_salv_table = p_alv_obj
        CHANGING
          t_table      = p_tab.
    CATCH cx_salv_msg.
      MESSAGE 'Error in displaying ALV' TYPE 'I'.
      EXIT.
  ENDTRY.

ENDFORM.

FORM create_doc_container USING p_side    TYPE i
                                p_height  TYPE i
                          CHANGING p_container TYPE REF TO
                                cl_gui_docking_container.
  CREATE OBJECT p_container
    EXPORTING
      side                        = p_side
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF NOT p_height IS INITIAL.
    CALL METHOD p_container->set_height
      EXPORTING
        height = p_height.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  DISPLAY_RESULTS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE display_results OUTPUT.
  PERFORM display_results.
ENDMODULE.                 " DISPLAY_RESULTS  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  SET_DETAIL_SALV_VIEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_detail_salv_view .
  wf_alv_dt->display_company_header( i_title = TEXT-024 ).

  " Set Totals for the columns
  wf_alv_dt->set_total( 'QSSHB' ).
  wf_alv_dt->set_total( 'QBSHB' ).
  wf_alv_dt->set_total( 'TXDEP' ).


  " Show Hotspot Links " link display disables the navigation...chk why?
  "wf_alv_dt->show_hotspot_links( 'BELNR' ).

  " Set event handlers
  wf_alv_dt->get_events( ).
  SET HANDLER lv_handler->handle_double_click FOR wf_alv_dt->events.

  " Reset column titles
*  reset_column_title :
**  Add By $k date :- 17.11.2017---------------------------------------------------------------------------------

  IF r1 = 'X'.
    reset_column_title :
     wf_alv_dt 'LIFNR'   'Vendor No' 'Vendor No' 'Vendor No' 'Vendor No', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
     wf_alv_dt 'HKONT'   'Expense GL' 'Expense GL' 'Expense GL' 'Expense GL', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
     wf_alv_dt 'TXT20'   'short text' 'short text' 'short text' 'short text',
     wf_alv_dt 'HKONT1'   'TDSGL Code' 'TDS GL Code' 'TDS GL Code' 'TDS GL Code', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
**------------------------------------------------------------------------------------------------------------
     wf_alv_dt 'QSCOD'   'Section' 'Section' 'Section' 'Section', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
     wf_alv_dt 'SECDSCR' 'Sec Descr' 'Section Descr' 'Section Description' 'Section Description',  "TEXT-005 TEXT-006 TEXT-007  TEXT-007,
     wf_alv_dt 'PANNO'   'PAN No' 'PAN of Deductee' 'PAN of Deductee' 'PAN of Deductee',      "TEXT-008 TEXT-008  TEXT-008,
     wf_alv_dt 'TXDEP'   'TotTaxDeps' 'Tot Tax Depos' 'Total Tax Deposited' 'Total Tax Deposited',     "TEXT-012 TEXT-013 TEXT-014  TEXT-014,
     wf_alv_dt 'NAME1'   'Deductee' 'Name of Deductee' 'Name of Deductee' 'Name of Deductee',     "  TEXT-015 TEXT-016  TEXT-016,
     wf_alv_dt 'PAYDT'   'Depos Dt' 'TDS Depos Dt' 'TDS Deposit Date' 'TDS Deposit Date',     "TEXT-017 TEXT-018 TEXT-019  TEXT-019,
     wf_alv_dt 'BSRCD'   'BSR Code' 'BSR Code' 'BSR Code' 'BSR Code',     "TEXT-020 TEXT-021 TEXT-021  TEXT-021,
     wf_alv_dt 'QSATZ'   'Rate'  'Rate' 'Rate at which TDS Deducted' 'Rate at which TDS Deducted',     " TEXT-022  TEXT-022.
     wf_alv_dt 'BLDAT'   'Invoice DT' 'Invoice DT' 'Invoice DT' 'Invoice DT',
     wf_alv_dt 'XBLNR'   'Invoice No' 'Invoice No' 'Invoice No' 'Invoice No'.

    " Hide Columns
    wf_alv_dt->hide_column( 'KBTXT' ).
    wf_alv_dt->hide_column( 'WITHT' ).
    wf_alv_dt->hide_column( 'WT_WITHCD' ).
*  wf_alv_dt->hide_column( 'LIFNR' ).
*  wf_alv_dt->hide_column( 'HKONT' ).
*  wf_alv_dt->hide_column( 'HKONT1' ).
*    wf_alv_dt->hide_column( 'KBTXT' ).

    " Set Align
    wf_alv_dt->align( i_column = 'QSATZ'
                      i_align  = if_salv_c_alignment=>right ).

*********************************ADDED BY DH******************
  ELSEIF r2 = 'X'.

    reset_column_title :
     wf_alv_dt 'LIFNR'   'Vendor No' 'Vendor No' 'Vendor No' 'Vendor No', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
   wf_alv_dt 'HKONT'   'Expense GL' 'Expense GL' 'Expense GL' 'Expense GL', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
   wf_alv_dt 'TXT20'   'short text' 'short text' 'short text' 'short text',
   wf_alv_dt 'HKONT1'   'TDSGL Code' 'TDS GL Code' 'TDS GL Code' 'TDS GL Code', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
**------------------------------------------------------------------------------------------------------------
    wf_alv_dt 'QSCOD'   'Section' 'Section' 'Section' 'Section', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
*   wf_alv_dt 'KBTXT'   'Header txt' 'Header txt' 'Header text' 'Header text', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
   wf_alv_dt 'SECDSCR' 'Sec Descr' 'Section Descr' 'Section Description' 'Section Description',  "TEXT-005 TEXT-006 TEXT-007  TEXT-007,
   wf_alv_dt 'PANNO'   'PAN No' 'PAN of Deductee' 'PAN of Deductee' 'PAN of Deductee',      "TEXT-008 TEXT-008  TEXT-008,
   wf_alv_dt 'TXDEP'   'TotTaxDeps' 'Tot Tax Depos' 'Total Tax Deposited' 'Total Tax Deposited',     "TEXT-012 TEXT-013 TEXT-014  TEXT-014,
   wf_alv_dt 'NAME1'   'Deductee' 'Name of Deductee' 'Name of Deductee' 'Name of Deductee',     "  TEXT-015 TEXT-016  TEXT-016,
   wf_alv_dt 'PAYDT'   'Depos Dt' 'TDS Depos Dt' 'TDS Deposit Date' 'TDS Deposit Date',     "TEXT-017 TEXT-018 TEXT-019  TEXT-019,
   wf_alv_dt 'BSRCD'   'BSR Code' 'BSR Code' 'BSR Code' 'BSR Code',     "TEXT-020 TEXT-021 TEXT-021  TEXT-021,
   wf_alv_dt 'QSATZ'   'Rate'  'Rate' 'Rate at which TDS Deducted' 'Rate at which TDS Deducted',     " TEXT-022  TEXT-022.
   wf_alv_dt 'BLDAT'   'Invoice DT' 'Invoice DT' 'Invoice DT' 'Invoice DT',
   wf_alv_dt 'XBLNR'   'Invoice No' 'Invoice No' 'Invoice No' 'Invoice No'.

    " Hide Columns
    wf_alv_dt->hide_column( 'WITHT' ).
    wf_alv_dt->hide_column( 'WT_WITHCD' ).
    wf_alv_dt->hide_column( 'KBTXT' ).
*  wf_alv_dt->hide_column( 'LIFNR' ).
*  wf_alv_dt->hide_column( 'HKONT' ).
*  wf_alv_dt->hide_column( 'HKONT1' ).
*    wf_alv_dt->hide_column( 'QSCOD' ).

    " Set Align
    wf_alv_dt->align( i_column = 'QSATZ'
                      i_align  = if_salv_c_alignment=>right ).
*****************************************************************
  ENDIF.


ENDFORM.                    " SET_DETAIL_SALV_VIEW

FORM set_summary_salv_view .
  wf_alv_sm->display_company_header( i_title = TEXT-023 ).

  " Set Totals for the columns
  wf_alv_sm->set_total( 'QSSHB' ).
  wf_alv_sm->set_total( 'QBSHB' ).
  wf_alv_sm->set_total( 'TXDEP' ).

  IF r1 = 'X'.
    " Subtotals
    wf_alv_sm->set_sort( i_column = 'QSCOD'
                         i_subtot = if_salv_c_bool_sap=>true ).



    " Reset column titles
    reset_column_title :
*     wf_alv_dt 'KBTXT'   'Header txt' 'Header txt' 'Header text', "TEXT-004 TEXT-004 TEXT-004,
      wf_alv_sm 'QSCOD'   'Section' 'Section' 'Section' 'Section', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
      wf_alv_sm 'SECDSCR' 'Sec Descr' 'Section Descr' 'Section Description' 'Section Description',  "TEXT-005 TEXT-006 TEXT-007  TEXT-007,
      wf_alv_sm 'TXDEP'   'TotTaxDeps' 'Tot Tax Depos' 'Total Tax Deposited' 'Total Tax Deposited',  "TEXT-012 TEXT-013 TEXT-014  TEXT-014,
      wf_alv_sm 'NAME1'   'Name' 'Deductee' 'Name of Deductee' 'Name of Deductee',      "TEXT-015 TEXT-016  TEXT-016,
      wf_alv_sm 'BSRCD'   'BSR' 'BSR' 'BSR' 'BSR',    "TEXT-020 TEXT-021 TEXT-021  TEXT-021,
      wf_alv_sm 'QSATZ'   'Rate'       'Rate' 'Rate at which TDS Deducted' 'Rate at which TDS Deducted'.      "TEXT-022  TEXT-022.

    " Hide Columns
*  wf_alv_sm->hide_column( 'QSCOD' ).
    wf_alv_sm->hide_column( 'KBTXT' ).
    wf_alv_sm->hide_column( 'BELNR' ).
    wf_alv_sm->hide_column( 'PANNO' ).
    wf_alv_sm->hide_column( 'PAYDT' ).
    wf_alv_sm->hide_column( 'BUDAT' ).
    wf_alv_sm->hide_column( 'BLDAT' ).
    wf_alv_sm->hide_column( 'XBLNR' ).
    wf_alv_sm->hide_column( 'PAYDT' ).
    wf_alv_sm->hide_column( 'J_1ICHLN' ).
    wf_alv_sm->hide_column( 'J_1ICHDT' ).
    wf_alv_sm->hide_column( 'BSRCD' ).
*

    " Set Align
    wf_alv_sm->align( i_column = 'QSATZ'
                      i_align  = if_salv_c_alignment=>right ).


*    reset_column_title :
*
*     wf_alv_sm->set_sort( i_column = 'QSCOD'
*                       i_subtot = if_salv_c_bool_sap=>true ).

***************************ADDED BY DH*********************
  ELSEIF r2 = 'X'.
    " Reset column titles
    reset_column_title :

*       wf_alv_sm 'KBTXT'   'Header txt' 'Header txt' 'Header text', "TEXT-004 TEXT-004 TEXT-004,
    wf_alv_sm 'QSCOD'   'Section' 'Section' 'Section' 'Section', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
      wf_alv_sm 'SECDSCR' 'Sec Descr' 'Section Descr' 'Section Description' 'Section Description',  "TEXT-005 TEXT-006 TEXT-007  TEXT-007,
      wf_alv_sm 'TXDEP'   'TotTaxDeps' 'Tot Tax Depos' 'Total Tax Deposited' 'Total Tax Deposited',  "TEXT-012 TEXT-013 TEXT-014  TEXT-014,
      wf_alv_sm 'NAME1'   'Name' 'Deductee' 'Name of Deductee' 'Name of Deductee',      "TEXT-015 TEXT-016  TEXT-016,
      wf_alv_sm 'BSRCD'   'BSR' 'BSR' 'BSR' 'BSR',    "TEXT-020 TEXT-021 TEXT-021  TEXT-021,
      wf_alv_sm 'QSATZ'   'Rate'       'Rate' 'Rate at which TDS Deducted' 'Rate at which TDS Deducted'.      "TEXT-022  TEXT-022.

    " Hide Columns
    wf_alv_sm->hide_column( 'KBTXT' ).
    wf_alv_sm->hide_column( 'BELNR' ).
    wf_alv_sm->hide_column( 'PANNO' ).
    wf_alv_sm->hide_column( 'PAYDT' ).
    wf_alv_sm->hide_column( 'BUDAT' ).
    wf_alv_sm->hide_column( 'BLDAT' ).
    wf_alv_sm->hide_column( 'XBLNR' ).
    wf_alv_sm->hide_column( 'PAYDT' ).
    wf_alv_sm->hide_column( 'J_1ICHLN' ).
    wf_alv_sm->hide_column( 'J_1ICHDT' ).
    wf_alv_sm->hide_column( 'BSRCD' ).

    " Set Align
    wf_alv_sm->align( i_column = 'QSATZ'
                      i_align  = if_salv_c_alignment=>right ).
************************************************************************
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  SET_PF_STATUS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_pf_status OUTPUT.
  SET PF-STATUS 'ZFI_TDSREG_STAT'.
ENDMODULE.                 " SET_PF_STATUS  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  HANDLE_USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE handle_user_command INPUT.
  CASE ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                 " HANDLE_USER_COMMAND  INPUT
