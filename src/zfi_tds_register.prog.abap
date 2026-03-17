*&---------------------------------------------------------------------*
*& Report  ZFI_TDS_REGISTER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zfi_tds_register.

*INCLUDE Z_CLASSES.
INCLUDE zfi_tds_register_cls.

TYPES : BEGIN OF t_bkpf,
          bukrs TYPE bukrs,    "  Company Code
          belnr	TYPE belnr_d,	   " Accounting Document Number
          gjahr TYPE gjahr,    "  Fiscal Year
          blart	TYPE blart,   "	Document Type
          budat TYPE budat,    "  Posting Date in the Document
          tcode	TYPE tcode,   "	Transaction Code
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
        END OF t_bseg,

        BEGIN OF t_bseg_cust_vndr,
          bukrs TYPE bukrs,      "  Company Code
          belnr TYPE belnr_d,  "  Accounting Document Number
          gjahr TYPE gjahr,    "  Fiscal Year
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
          stcd1	      TYPE stcd1,	         " BSR Code/Tax Number 1
        END OF t_with_item,

        BEGIN OF t_secco,
*          qscod TYPE wt_owtcd,          " Section Code
*          name  TYPE text40,            " Section Code Description
          witht     TYPE witht    ,   " Indicator for withholding tax type
          wt_withcd TYPE wt_withcd,   " Withholding tax code
          name      TYPE text40,      " Withholding tax code description
        END OF t_secco,

        BEGIN OF t_result,
          belnr      TYPE belnr_d,       " bkpf  : Accounting Document Number
*          secco      TYPE secco,       " bseg : Section Code
          qscod      TYPE wt_owtcd,    " Section
          secdscr    TYPE text40,      " secco : Section Description
          budat      TYPE budat,         " bkpf :  Posting Date in the Document

          witht      TYPE witht    ,   " Indicator for withholding tax type
          wt_withcd  TYPE wt_withcd,   " Withholding tax code
*          TEXT40      type TEXT40,      " Withholding tax code description

          panno      TYPE j_1ipanno,   "  Customer/Vendor PAN
*          name1      TYPE name1_gp,    "  Name 1
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
          name1  type lfa1-name1,
          hkont      TYPE hkont,
          hkont1(15) TYPE c,

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
          name1	TYPE name1_gp,          "	Name 1                     "............Megha
          adrnr TYPE adrnr,              "  Address
        END OF t_lfa1,

        BEGIN OF t_vendor,
          lifnr     TYPE lifnr,
          j_1ipanno	TYPE j_1ipanno, "	Permanent Account Number
        END OF t_vendor,

        BEGIN OF t_t012,
          hbkid	TYPE hbkid,	   " Short Key for a House Bank
          stcd1	TYPE stcd1,	   " Tax Number 1
        END OF t_t012.

DATA : it_bkpf           TYPE TABLE OF t_bkpf,
       it_bseg           TYPE TABLE OF t_bseg,
       it_tax            TYPE TABLE OF t_tax,
       it_with_item      TYPE TABLE OF t_with_item,
       it_secco          TYPE TABLE OF t_secco,
       it_result         TYPE TABLE OF t_result,
       it_customer       TYPE TABLE OF t_customer,
       it_vendor         TYPE TABLE OF t_vendor,
       it_kna1           TYPE TABLE OF t_kna1,
       it_lfa1           TYPE TABLE OF t_lfa1,
       it_adrc           TYPE TABLE OF t_adrc,
       it_bseg_cust_vndr TYPE TABLE OF t_bseg_cust_vndr,
       it_bseg_gl        TYPE TABLE OF t_bseg_cust_vndr, " ----------------add by $k date ;- 17.11.2017
       it_result_sum     TYPE TABLE OF t_result,
       it_t012           TYPE TABLE OF t_t012,

       wa_bkpf           TYPE t_bkpf,
       wa_bseg           TYPE t_bseg,
       wa_tax            TYPE t_tax,
       wa_with_item      TYPE t_with_item,
       wa_secco          TYPE t_secco,
       wa_result         TYPE t_result,
       wa_customer       TYPE t_customer,
       wa_vendor         TYPE t_vendor,
       wa_kna1           TYPE t_kna1,
       wa_lfa1           TYPE t_lfa1,
       wa_adrc           TYPE t_adrc,
       wa_bseg_cust_vndr TYPE t_bseg_cust_vndr,
       wa_bseg_gl        TYPE t_bseg_cust_vndr, " --------------------------add by $k date :- 17.11.2017\
       wa_result_sum     TYPE t_result,
       wa_t012           TYPE t_t012,

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
  SELECT
      bukrs
      belnr
      gjahr
      blart
      budat
      tcode
      awkey
    FROM bkpf INTO TABLE it_bkpf
    WHERE  bukrs = p_bukrs
      AND bstat  IN (space, 'A' , 'B' , 'D' )
      AND budat IN so_pdat
      AND gjahr = p_gjahr
      AND stblg = ''.
  IF sy-subrc <> 0.
    MESSAGE TEXT-002 TYPE 'I'.
  ELSE.
    PERFORM process_miro_reversals.
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
      FROM bseg
      INTO TABLE it_bseg
      FOR ALL ENTRIES IN it_bkpf
      WHERE  bukrs = it_bkpf-bukrs
        AND belnr  = it_bkpf-belnr
        AND gjahr  = it_bkpf-gjahr
        AND buzei NE '000'
        AND koart  = 'S'
        AND ktosl  = 'WIT'
*        AND ( bupla IN secco                      " Note 639798
*        OR   secco IN secco )
        "AND secco NE space
      .
    IF sy-subrc = 0.
      SORT it_bseg.
      SELECT bukrs
             belnr
             gjahr
             koart
             ktosl
             hkont
             kunnr
             lifnr
        FROM bseg
        INTO TABLE it_bseg_cust_vndr
        FOR ALL ENTRIES IN it_bseg
        WHERE bukrs   = it_bseg-bukrs
        AND belnr   = it_bseg-belnr
        AND gjahr   = it_bseg-gjahr
        AND koart IN ('D', 'K').

      SELECT bukrs
             belnr
             gjahr
             koart
             ktosl
             hkont
             kunnr
             lifnr
        FROM bseg
        INTO TABLE it_bseg_gl
        FOR ALL ENTRIES IN it_bseg_cust_vndr
        WHERE bukrs   = it_bseg_cust_vndr-bukrs
        AND belnr   = it_bseg_cust_vndr-belnr
        AND gjahr   = it_bseg_cust_vndr-gjahr
        AND koart = 'S'.

      DELETE it_bseg_gl WHERE ktosl <> space AND ktosl <> 'WIT'.
      IF sy-subrc = 0.
        SORT it_bseg_cust_vndr.
      ENDIF.
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
        AND gjahr   = it_bseg-gjahr
        AND wt_qsshh NE 0
        AND j_1ibuzei = it_bseg-buzei.
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

          MODIFY it_with_item FROM wa_with_item
            TRANSPORTING j_1iextchln j_1iextchdt stcd1.
        ENDIF.

        CLEAR : wa_with_item, wa_j_1iewtchln, wa_t012.
      ENDLOOP.
    ENDIF.
  ENDIF.
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

    READ TABLE it_bkpf INTO wa_bkpf WITH KEY bukrs = wa_with_item-bukrs
                                             belnr = wa_with_item-belnr
                                             gjahr = wa_with_item-gjahr.
    IF sy-subrc = 0.
      wa_result-belnr = wa_bkpf-belnr.
      wa_result-budat = wa_bkpf-budat.

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
        LOOP AT it_bseg_gl INTO wa_bseg_gl WHERE  bukrs = wa_with_item-bukrs AND
                                                  belnr = wa_with_item-belnr AND
                                                  gjahr = wa_with_item-gjahr.
          count = count + 1.
          IF wa_bseg_gl-ktosl = 'WIT'.
            wa_result-hkont1 = wa_bseg_gl-hkont."add by $k date :- 17.11.2017
*        IF wa_result-hkont is INITIAL.
            IF count = 2.
              CLEAR :wa_result-qbshb , wa_result-qsshb,wa_result-txdep.
            ENDIF.

            APPEND wa_result TO it_result.
          ELSEIF wa_bseg_gl-ktosl = space.
            wa_result-hkont = wa_bseg_gl-hkont. "add by $k date :- 17.11.2017
            IF count = 3.
              CLEAR :wa_result-qbshb , wa_result-qsshb,wa_result-txdep.
            ENDIF.
            APPEND wa_result TO it_result.
          ENDIF.

*             CLEAR : wa_result.
        ENDLOOP.

*        APPEND wa_result TO it_result.
      ENDIF.
    ENDIF.
    CLEAR : wa_bkpf, wa_secco, wa_bseg_cust_vndr, wa_with_item, wa_result, wa_tax , wa_bseg_gl.
    CLEAR : wa_customer, wa_vendor, wa_kna1, wa_lfa1, lv_adrnr, wa_adrc , count.
  ENDLOOP.
  DELETE : it_result WHERE hkont = space.
  IF NOT it_result IS INITIAL.
    SORT it_result BY budat belnr.
*    SORT it_result BY belnr.

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

  DELETE tmp_bkpf WHERE NOT tcode = 'MIRO'
                    AND NOT tcode = 'MR8M'
                    AND tcode = 'MIR7'. "Note 699664
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
  reset_column_title :
**  Add By $k date :- 17.11.2017---------------------------------------------------------------------------------
    wf_alv_dt 'LIFNR'   'Vendor No' 'Vendor No' 'Vendor No' 'Vendor No', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,

    wf_alv_dt 'HKONT'   'Expense GL' 'Expense GL' 'Expense GL' 'Expense GL', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
    wf_alv_dt 'HKONT1'   'TDSGL Code' 'TDS GL Code' 'TDS GL Code' 'TDS GL Code', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
**------------------------------------------------------------------------------------------------------------
    wf_alv_dt 'QSCOD'   'Section' 'Section' 'Section' 'Section', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
    wf_alv_dt 'SECDSCR' 'Sec Descr' 'Section Descr' 'Section Description' 'Section Description',  "TEXT-005 TEXT-006 TEXT-007  TEXT-007,
    wf_alv_dt 'PANNO'   'PAN No' 'PAN of Deductee' 'PAN of Deductee' 'PAN of Deductee',      "TEXT-008 TEXT-008  TEXT-008,
    wf_alv_dt 'TXDEP'   'TotTaxDeps' 'Tot Tax Depos' 'Total Tax Deposited' 'Total Tax Deposited',     "TEXT-012 TEXT-013 TEXT-014  TEXT-014,
    wf_alv_dt 'NAME1'   'Deductee' 'Name of Deductee' 'Name of Deductee' 'Name of Deductee',     "  TEXT-015 TEXT-016  TEXT-016,
    wf_alv_dt 'PAYDT'   'Depos Dt' 'TDS Depos Dt' 'TDS Deposit Date' 'TDS Deposit Date',     "TEXT-017 TEXT-018 TEXT-019  TEXT-019,
    wf_alv_dt 'BSRCD'   'BSR Code' 'BSR Code' 'BSR Code' 'BSR Code',     "TEXT-020 TEXT-021 TEXT-021  TEXT-021,
    wf_alv_dt 'QSATZ'   'Rate'  'Rate' 'Rate at which TDS Deducted' 'Rate at which TDS Deducted',  " TEXT-022  TEXT-022.
    wf_alv_dt 'NAME1' 'Vend Name'  'Vendor Name' 'Vendor Name'  'Vendor Name'.

  " Hide Columns
  wf_alv_dt->hide_column( 'WITHT' ).
  wf_alv_dt->hide_column( 'WT_WITHCD' ).
*  wf_alv_dt->hide_column( 'LIFNR' ).
*  wf_alv_dt->hide_column( 'HKONT' ).
*  wf_alv_dt->hide_column( 'HKONT1' ).

  " Set Align
  wf_alv_dt->align( i_column = 'QSATZ'
                    i_align  = if_salv_c_alignment=>right ).


ENDFORM.                    " SET_DETAIL_SALV_VIEW

FORM set_summary_salv_view .
  wf_alv_sm->display_company_header( i_title = TEXT-023 ).

  " Set Totals for the columns
  wf_alv_sm->set_total( 'QSSHB' ).
  wf_alv_sm->set_total( 'QBSHB' ).
  wf_alv_sm->set_total( 'TXDEP' ).

  " Subtotals
  wf_alv_sm->set_sort( i_column = 'QSCOD'
                       i_subtot = if_salv_c_bool_sap=>true ).



  " Reset column titles
  reset_column_title :
    wf_alv_sm 'QSCOD'   'Section' 'Section' 'Section' 'Section', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
    wf_alv_sm 'SECDSCR' 'Sec Descr' 'Section Descr' 'Section Description' 'Section Description',  "TEXT-005 TEXT-006 TEXT-007  TEXT-007,
    wf_alv_sm 'TXDEP'   'TotTaxDeps' 'Tot Tax Depos' 'Total Tax Deposited' 'Total Tax Deposited',  "TEXT-012 TEXT-013 TEXT-014  TEXT-014,
    wf_alv_sm 'NAME1'   'Name' 'Deductee' 'Name of Deductee' 'Name of Deductee',      "TEXT-015 TEXT-016  TEXT-016,
    wf_alv_sm 'BSRCD'   'BSR' 'BSR' 'BSR' 'BSR',    "TEXT-020 TEXT-021 TEXT-021  TEXT-021,
    wf_alv_sm 'QSATZ'   'Rate'       'Rate' 'Rate at which TDS Deducted' 'Rate at which TDS Deducted'.      "TEXT-022  TEXT-022.

  " Hide Columns
  wf_alv_sm->hide_column( 'BELNR' ).
  wf_alv_sm->hide_column( 'PANNO' ).
  wf_alv_sm->hide_column( 'PAYDT' ).
  wf_alv_sm->hide_column( 'BUDAT' ).
  wf_alv_sm->hide_column( 'PAYDT' ).
  wf_alv_sm->hide_column( 'J_1ICHLN' ).
  wf_alv_sm->hide_column( 'J_1ICHDT' ).
  wf_alv_sm->hide_column( 'BSRCD' ).

  " Set Align
  wf_alv_sm->align( i_column = 'QSATZ'
                    i_align  = if_salv_c_alignment=>right ).
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
