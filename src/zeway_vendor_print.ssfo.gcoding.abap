
CLEAR:gv_total.
CLEAR:PAC_FOR,INSPECTION,TESTING,FREIGHT,srate,irate.
SELECT * FROM j_1istatecdm INTO TABLE lt_statecode.
SELECT * FROM zbillingtypes INTO TABLE lt_billingtypes.


DATA : go_einvoice_utility TYPE REF TO zcl_einvoice_utility.

DATA :  lt_sel_addr TYPE TABLE OF zeinv_adrc,
        ls_sel_addr TYPE zeinv_adrc,

        lt_dis_addr TYPE TABLE OF zeinv_adrc,
        ls_dis_addr TYPE zeinv_adrc,

        lt_buy_addr TYPE TABLE OF zeinv_adrc,
        ls_buy_addr TYPE zeinv_adrc,

        lt_shp_addr TYPE TABLE OF zeinv_adrc,
        ls_shp_addr TYPE zeinv_adrc.

  REFRESH : lt_rseg, lt_awkey,
            lt_bkpf, lt_kna1,
            it_adrc, it_adrc_cust, it_adrct,lt_eway_number,
            lt_awkey.

  CREATE OBJECT go_einvoice_utility.

*  CLEAR : lv_ewaybill,lv_ewaybill_dt,lv_ewaybill_exdt,lv_temp,gs_ewaybill_details.
*  CLEAR : ls_rseg,ls_bkpf,ls_sel_addr,ls_dis_addr,ls_buy_addr,ls_shp_addr,ls_final_eway,ls_itemlist,ls_awkey, ls_rseg.
  DATA lc_belnr TYPE belnr_d.

  DATA : lv_date          TYPE string,
         lv_wrbtr         TYPE rseg-wrbtr,            ":100,
         lv_sgstrate      TYPE p DECIMALS 9, "string,                                       ":5,
         lv_cgstrate      TYPE p DECIMALS 9,                                         ":5,
         lv_igstrate      TYPE p DECIMALS 9."string,

CLEAR :lv_date ,lv_wrbtr ,lv_sgstrate ,lv_cgstrate,lv_igstrate .





  lc_belnr = p_vbeln.
*
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lc_belnr
    IMPORTING
      output = lc_belnr.


  SELECT belnr gjahr buzei ebeln 	ebelp	werks	matnr
         hsn_sac  menge meins wrbtr kschl xekbz lfbnr
         bukrs  xblnr mwskz FROM rseg INTO TABLE lt_rseg
*         WHERE bukrs IN s_bukrs
         WHERE belnr EQ lc_belnr
*         AND werks IN s_werks
         AND gjahr EQ P_GJAHR
*         AND matnr IN s_matnr
         AND shkzg = 'H'.


  LOOP AT lt_rseg INTO ls_rseg.
    CONCATENATE ls_rseg-belnr ls_rseg-gjahr INTO ls_awkey.

    APPEND ls_awkey TO lt_awkey.
    CLEAR : ls_awkey.

  ENDLOOP.




  IF lt_awkey IS NOT INITIAL.
    SELECT  bukrs
            belnr
            gjahr
            blart
            budat
            bldat
            xblnr
            waers
            awkey
     FROM bkpf
     INTO CORRESPONDING FIELDS OF TABLE lt_bkpf
     FOR ALL ENTRIES IN lt_awkey
     WHERE awkey = lt_awkey-lv_awkey
     AND gjahr EQ P_GJAHR.
*     AND budat IN s_budat .
  ENDIF.

  IF lt_rseg IS NOT INITIAL.

    SELECT  mblnr,
            lfbnr,
            ebeln,
            bwart
      FROM mseg INTO TABLE @DATA(lt_mseg)
      FOR ALL ENTRIES IN @lt_rseg
      WHERE lfbnr = @lt_rseg-lfbnr
      AND ebeln = @lt_rseg-ebeln
      AND ebelp = @lt_rseg-ebelp.

    SELECT  mblnr
         lfbnr
         ebeln
         bwart
        "added
        budat_mkpf
        menge
   FROM mseg INTO CORRESPONDING FIELDS OF TABLE lt_mseg1
   FOR ALL ENTRIES IN lt_rseg
   WHERE lfbnr = lt_rseg-lfbnr
   AND ebeln = lt_rseg-ebeln
   AND ebelp = lt_rseg-ebelp
   AND bwart IN ( 122, 161 ).

    SELECT matnr,
           spras,
           maktx
      FROM makt INTO TABLE @DATA(lt_makt)
      FOR ALL ENTRIES IN @lt_rseg
      WHERE matnr = @lt_rseg-matnr
      AND spras = 'E'.

  ENDIF.
  IF lt_bkpf IS NOT INITIAL.

    SELECT bukrs, belnr, gjahr, buzei,
           buzid, koart, ktosl, txgrp, gsber,
           kunnr, matnr, werks, menge, meins,
           posn2, dmbtr, wrbtr, gvtyp, sgtxt, bupla, hsn_sac
           FROM bseg
           INTO TABLE @DATA(lt_bseg_122)
           FOR ALL ENTRIES IN @lt_bkpf
           WHERE belnr EQ @lt_bkpf-belnr
           AND   bukrs EQ @lt_bkpf-bukrs
           AND   gjahr EQ @lt_bkpf-gjahr.

    SELECT bukrs,
           belnr,
           lifnr,
           koart,
           gsber
      FROM bseg INTO TABLE @DATA(lt_bseg1)
      FOR ALL ENTRIES IN @lt_bkpf
      WHERE belnr = @lt_bkpf-belnr
      AND bukrs = @lt_bkpf-bukrs
      AND  gjahr = @lt_bkpf-gjahr
      AND koart = 'K'.

  ENDIF.

  IF lt_bseg1 IS NOT INITIAL.
    SELECT lifnr
           name1
      FROM lfa1 INTO TABLE lt_lfa1
      FOR ALL ENTRIES IN lt_bseg1
      WHERE lifnr = lt_bseg1-lifnr.
  ENDIF.

  IF lt_bseg_122  IS NOT INITIAL.
    SELECT *
      FROM bset
      INTO TABLE @DATA(lt_bset)
      FOR ALL ENTRIES IN  @lt_bseg_122
      WHERE belnr = @lt_bseg_122-belnr
        AND bukrs = @lt_bseg_122-bukrs
        AND gjahr = @lt_bseg_122-gjahr.

  ENDIF.

  IF lt_rseg IS NOT INITIAL.

    SELECT *
           FROM marc
           INTO TABLE @DATA(lt_marc)
         FOR ALL ENTRIES IN @lt_rseg
         WHERE matnr = @lt_rseg-matnr.

    SELECT matnr
           spras
           maktx
      FROM makt INTO TABLE lt_makt
      FOR ALL ENTRIES IN lt_rseg
      WHERE matnr = lt_rseg-matnr
      AND spras = 'E'.

  ENDIF.


  IF lt_bseg_122 IS NOT INITIAL.

    SELECT *
    FROM bset
    INTO TABLE lt_bset
    FOR ALL ENTRIES IN lt_bseg_122
    WHERE belnr = lt_bseg_122-belnr
    AND bukrs = lt_bseg_122-bukrs
    AND gjahr = lt_bseg_122-gjahr.


  ELSE.

    MESSAGE 'No item data Available' TYPE 'E'.
    EXIT.
    LEAVE LIST-PROCESSING.

  ENDIF.

SORT lt_bseg_122 BY BUZEI .
BREAK primus.
  LOOP AT lt_bkpf INTO ls_bkpf .


  ls_final_eway-docno = ls_bkpf-belnr.

*ztyp
      ls_final_eway-zstyp = 'O'.
      ls_final_eway-subsupplytype  = '1'.


      ls_final_eway-doctype = 'INV'.

 CLEAR ls_rseg.
 READ TABLE lt_rseg INTO ls_rseg WITH KEY belnr  = ls_bkpf-awkey+0(10) gjahr = ls_bkpf-gjahr.
      IF sy-subrc EQ 0.


      IF ls_bkpf-budat IS NOT INITIAL.
        CONCATENATE ls_bkpf-budat+6(02) '/' ls_bkpf-budat+4(02) '/' ls_bkpf-budat(04)  INTO lv_date. " ?????????????????????????????
        ls_final_eway-docdate = lv_date.

      ENDIF.

    ENDIF.

    READ TABLE lt_bseg_122 INTO DATA(ls_bseg_122) WITH KEY belnr = ls_bkpf-belnr." txgrp = ls_rseg-buzei+3(3).

    READ TABLE lt_bseg1 INTO DATA(ls_bseg1) WITH  KEY belnr = ls_bkpf-belnr.
    IF sy-subrc = 0.
*      ls_final-lifnr = ls_bseg1-lifnr.

      CALL METHOD go_einvoice_utility->get_adrc_data
        EXPORTING
          iv_werks    = ls_bseg_122-bupla
          iv_kunnr    = ls_bseg1-lifnr
*          is_likp     =
*          iv_invtyp   =
          iv_bukrs    = ls_bseg_122-bukrs
          iv_bupla    = ls_bseg1-gsber
        CHANGING
          es_sel_addr = ls_sel_addr
          es_dis_addr = ls_dis_addr
          es_buy_addr = ls_buy_addr
          es_shp_addr = ls_shp_addr.

    ENDIF.
*Sellerdtls
*    gstin

    IF sy-mandt = '020'." OR sy-mandt = '110' OR sy-mandt = '300'.
      ls_final_eway-fromgstin = '27AACCD2898L1Z4' ."'05AAACG5222D1ZA'.
    ELSE.
      ls_final_eway-fromgstin =  '27AACCD2898L1Z4'. "ls_sel_addr-gstin .
    ENDIF.

* trdnm
    ls_final_eway-fromtrdname =  ls_sel_addr-name1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-fromtrdname WITH ''.
    TRANSLATE ls_final_eway-fromtrdname TO UPPER CASE.
* addr1
    ls_final_eway-fromaddr1 = ls_sel_addr-str_suppl1.                                        "ls_adrc-street.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-fromaddr1 WITH ''.
    TRANSLATE ls_final_eway-fromaddr1 TO UPPER CASE.
*  addr2
    ls_final_eway-fromaddr2 = ls_sel_addr-str_suppl2.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-fromaddr2 WITH ''.
    TRANSLATE ls_final_eway-fromaddr2 TO UPPER CASE.



* loc
    ls_final_eway-fromplace = ls_sel_addr-STREET. "ls_sel_addr-sort1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-fromplace WITH ''.
    TRANSLATE ls_final_eway-fromplace TO UPPER CASE.



* pin
    ls_final_eway-frompincode = ls_sel_addr-post_code1.
* stcd
    ls_final_eway-fromstatecode = ls_sel_addr-region."'5'
    ls_final_eway-actfromstatecode = ls_sel_addr-region.
*  Ph
      IF ls_sel_addr-region < 10.
        SHIFT ls_final_eway-fromstatecode LEFT DELETING LEADING '0'.
        SHIFT ls_final_eway-actfromstatecode LEFT DELETING LEADING '0'.
      ENDIF.

      ls_final_eway-togstin      = ls_buy_addr-gstin.
      IF ls_final_eway-togstin = 'URD'.
        ls_final_eway-togstin = 'URP'.
      ENDIF.

    ls_final_eway-totrdname = ls_buy_addr-name1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-totrdname WITH ''.
    TRANSLATE ls_final_eway-totrdname TO UPPER CASE.
* pos
    ls_final_eway-tostatecode = ls_buy_addr-region.
    ls_final_eway-acttostatecode = ls_buy_addr-region.

    IF ls_buy_addr-region < 10.
      SHIFT ls_final_eway-tostatecode LEFT DELETING LEADING '0'.
      SHIFT ls_final_eway-acttostatecode LEFT DELETING LEADING '0'.
    ENDIF.
* addr1
    ls_final_eway-toaddr1 = ls_buy_addr-street.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-toaddr1 WITH ''.
    TRANSLATE ls_final_eway-toaddr1 TO UPPER CASE.
* addr2
    IF ls_buy_addr-str_suppl2 IS INITIAL.
*      ls_final_eway-toaddr2 =  lc_null.
    ELSE.
      ls_final_eway-toaddr2 =  ls_buy_addr-str_suppl2.                  "addr2_buyer.
    ENDIF.

    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-toaddr2 WITH ''.
    TRANSLATE ls_final_eway-toaddr2 TO UPPER CASE.



    ls_final_eway-toplace =   ls_buy_addr-city1.                 " 'ABC' ."ls_adrc_re-city1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-toplace WITH ''.
    TRANSLATE ls_final_eway-toplace TO UPPER CASE.

    ls_final_eway-topincode = ls_buy_addr-post_code1.


    ls_final_eway-shiptogstin = ls_final_eway-togstin.
    IF ls_final_eway-togstin = 'URD'.
      ls_final_eway-togstin = 'URP'.
    ENDIF.
    ls_final_eway-shiptotradename = ls_final_eway-totrdname.
    ls_final_eway-dispatchfromgstin = ls_final_eway-fromgstin.
    ls_final_eway-dispatchfromtradename = ls_final_eway-fromtrdname.

    ls_final_eway-transactiontype = '4'.


    IF ls_final_eway-vehicletype = 'REGULAR'.
      ls_final_eway-vehicletype = 'R'.
    ENDIF.

    IF ls_final_eway-transdistance IS NOT INITIAL.
      ls_final_eway-transdistance = round( val = ls_final_eway-transdistance dec = 0 ).
      REPLACE ALL OCCURRENCES OF ',' IN ls_final_eway-transdistance WITH space.
      CONDENSE ls_final_eway-transdistance NO-GAPS.
    ELSE.
      ls_final_eway-transdistance     = 0.
    ENDIF.

    IF ls_final_eway-transdocdate = '00000000' OR ls_final_eway-transdocdate IS INITIAL.
*      ls_final_eway-transdocdate = lc_null.
    ELSE.
      CONCATENATE ls_final_eway-transdocdate+6(02) '/' ls_final_eway-transdocdate+4(02) '/' ls_final_eway-transdocdate(04)
      INTO lv_date.
      ls_final_eway-transdocdate = lv_date.
      CLEAR lv_date.
    ENDIF.

BREAK primus.
    CASE ls_final_eway-transmode.
      WHEN 'ROAD'.
        ls_final_eway-transmode         = '1' .
      WHEN 'RAIL'.
        ls_final_eway-transmode         = '2' .
      WHEN 'AIR'.
        ls_final_eway-transmode         = '3' .
      WHEN 'SHIP'.
        ls_final_eway-transmode         = '4' .
      WHEN OTHERS.
        ls_final_eway-transmode         = '1' .
    ENDCASE.

    LOOP AT lt_bseg_122 INTO ls_bseg_122 WHERE belnr  = ls_bkpf-belnr AND gjahr = ls_bkpf-gjahr AND buzid = 'W'.
*slno
      concatenate '000' ls_bseg_122-txgrp INTO ls_itemlist-itemno.


      IF ls_bseg_122-matnr IS INITIAL.
        ls_itemlist-productname = ls_bseg_122-matnr.
        ls_itemlist-productdesc = ls_bseg_122-sgtxt.
        REPLACE ALL OCCURRENCES OF ',' IN ls_bseg_122-sgtxt WITH ''.
        REPLACE ALL OCCURRENCES OF '&' IN ls_bseg_122-sgtxt WITH ''.
        ls_itemlist-hsncode = ls_bseg_122-hsn_sac."(04).
      ELSE.
        ls_itemlist-productname = ls_bseg_122-matnr.
        READ TABLE lt_makt INTO DATA(ls_makt) WITH KEY matnr = ls_bseg_122-matnr.
        IF sy-subrc  = 0.
          REPLACE ALL OCCURRENCES OF '&' IN ls_makt-maktx WITH ''.
          REPLACE ALL OCCURRENCES OF ',' IN ls_makt-maktx WITH ''.
          ls_itemlist-productdesc = ls_makt-maktx.
        ENDIF.

*hsncd

        READ TABLE lt_marc INTO DATA(ls_marc) WITH KEY matnr = ls_bseg_122-matnr werks = ls_bseg_122-werks.
        IF sy-subrc EQ 0.
          ls_itemlist-hsncode = ls_marc-steuc."(04).     " '23099010'.
        ENDIF.
      ENDIF.

      IF ls_itemlist-hsncode IS NOT INITIAL.
        ls_final_eway-mainhsncode = ls_itemlist-hsncode.
      ENDIF.
*Qty
      ls_itemlist-quantity = ls_bseg_122-menge.
*      CONDENSE  ls_itemlist-quantity.


      IF ls_bseg_122-meins IS NOT INITIAL.

        CALL FUNCTION 'ZEINV_UNIT_CONVERT'
          EXPORTING
            vrkme = ls_bseg_122-meins
          IMPORTING
            unit  = ls_itemlist-qtyunit.
      ENDIF.


*taxable amount
      CONCATENATE '000' ls_bseg_122-txgrp INTO DATA(lv_txgrp).
      READ TABLE lt_rseg INTO ls_rseg WITH KEY belnr  = ls_bkpf-awkey+0(10) gjahr = ls_bkpf-gjahr buzei = lv_txgrp.
      IF sy-subrc EQ 0.

        ls_final_eway-totalvalue = ls_final_eway-totalvalue + ls_rseg-wrbtr.
        ls_final_eway-totinvvalue = ls_final_eway-totinvvalue + ls_rseg-wrbtr.
      ENDIF.


      ls_itemlist-taxableamount = ls_rseg-wrbtr.
      LOOP AT lt_bset INTO DATA(ls_bset) WHERE belnr = ls_bkpf-belnr AND gjahr = ls_rseg-gjahr AND txgrp = ls_bseg_122-txgrp.
        CASE ls_bset-kschl.
          WHEN  'JICG' OR 'JOCG' OR 'JICN'. .
*    cgstrt
            ls_itemlist-cgstrate =   ls_itemlist-cgstrate + ( ls_bset-kbetr / 10 ).
            lv_cgstrate = ls_itemlist-cgstrate.
            ls_itemlist-cgstrate = lv_cgstrate.

              ls_final_eway-cgstvalue   = ls_final_eway-cgstvalue + ls_bset-fwste.
            ls_final_eway-totinvvalue = ls_final_eway-totinvvalue + ls_bset-fwste.
          WHEN 'JISG' OR 'JOSG' OR 'JISN'..
            ls_itemlist-sgstrate =   ls_itemlist-sgstrate + ( ls_bset-kbetr / 10 ).
            lv_sgstrate = ls_itemlist-sgstrate.
            ls_itemlist-sgstrate = lv_sgstrate.

            ls_final_eway-sgstvalue   = ls_final_eway-sgstvalue + ls_bset-fwste.
            ls_final_eway-totinvvalue = ls_final_eway-totinvvalue + ls_bset-fwste.
          WHEN  'JIIG' OR 'JOIG' OR 'JIIN'.

            ls_itemlist-igstrate =   ls_itemlist-igstrate + ( ls_bset-kbetr / 10 ).
            lv_igstrate = ls_itemlist-igstrate.
            ls_itemlist-igstrate = lv_igstrate.

            ls_final_eway-igstvalue   = ls_final_eway-igstvalue + ls_bset-fwste.
            ls_final_eway-totinvvalue = ls_final_eway-totinvvalue + ls_bset-fwste.
        ENDCASE.
        CLEAR : ls_bset.
      ENDLOOP.


        IF ls_itemlist-cgstrate IS INITIAL.
          ls_itemlist-cgstrate = '0'.
          ls_itemlist-sgstrate = '0'.
*          ls_final_eway-cgstvalue   = lc_null.
*          ls_final_eway-sgstvalue   = lc_null.
        ENDIF.




      APPEND ls_itemlist TO lt_itemlist.
      CLEAR : ls_itemlist,ls_marc,ls_makt."ls_attribdtls.

    ENDLOOP.

*    ls_final_eway-itemlist = lt_itemlist.
*    REFRESH: lt_itemlist.

    APPEND ls_final_eway TO lt_final_eway.

    CLEAR : ls_bkpf,ls_bseg_122,ls_rseg,lv_wrbtr.",ls_adrc,ls_bseg_ref,ls_vbrk_ref.
*    REFRESH: lt_itemlist.
  ENDLOOP.

  CLEAR : ls_sel_addr,ls_dis_addr,ls_dis_addr,ls_shp_addr.

SELECT SINGLE ZZSTATUS INTO status FROM ZEWAY_RES_122 WHERE
      EWAY_BILL = P_EBILLNO.

IF status = 'S'.
  gd_image = 'ZEWB_CANCELLED_WATERMARK'.
ELSE.
  gd_image = 'ZEWB_BLANK'.
ENDIF.
