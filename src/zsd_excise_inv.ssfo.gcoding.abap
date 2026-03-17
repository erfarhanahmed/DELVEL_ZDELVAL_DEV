TYPES : BEGIN OF t_lips,
          matnr TYPE matnr,
          lfimg TYPE lfimg,
        END OF t_lips.

DATA : lv_date    TYPE mjahr,
       v_docno    TYPE j_1idocno,
       lips_vbeln TYPE vbeln_vl,
       objname    TYPE tdobname,
       wa_lips    TYPE t_lips,
       it_lips    TYPE TABLE OF t_lips.

CLEAR : lv_date   ,
        v_docno   ,
        lips_vbeln,
        objname   ,
        wa_lips   ,
        wdnbx_count,
        crgbx_count.

vbrp_vbeln = i_vbeln.

SELECT SINGLE knumv fkart waerk kurrf
  FROM vbrk
  INTO CORRESPONDING FIELDS OF wa_hdr
  WHERE vbeln = vbrp_vbeln.

SELECT SINGLE *
*  trntyp docyr docno bukrs werks exnum exdat remtime
*  expind cpudt cputm excur kunag kunwe
*  exbed " BASIC EXCISE DUTY "
*  ecs   " ECS VALUE "
*  exaddtax1 " ADDITIONAL TAX 1 VALUE "
  FROM j_1iexchdr
  INTO CORRESPONDING FIELDS OF wa_hdr
  WHERE rdoc = vbrp_vbeln.

* Fetch Transporter info
SELECT SINGLE vgbel
  FROM vbrp
  INTO wa_hdr-vbeln
  WHERE vbeln = vbrp_vbeln.

CLEAR objname.

objname = vbrp_vbeln." WA_HDR-VBELN.

* Fetch Supplier details
PERFORM get_text USING objname 'VBBK' 'Z030' 'E' CHANGING wa_hdr-supplier.
CONDENSE wa_hdr-supplier.

* Ftech info for Mode Of Transport
PERFORM get_text USING objname 'VBBK' 'Z013' 'E' CHANGING wa_hdr-trnsprt_mode.
CONDENSE wa_hdr-trnsprt_mode.

* Get name of Transporter
PERFORM get_text USING objname 'VBBK' 'Z002' 'E' CHANGING wa_hdr-trnsprtr_name.
CONDENSE wa_hdr-trnsprtr_name.

* Get Transporter
PERFORM get_text USING objname 'VBBK' 'Z031' 'E' CHANGING wa_hdr-trnsprtr.
CONDENSE wa_hdr-trnsprtr.

* Get name of L.R.No.
PERFORM get_text USING objname 'VBBK' 'Z026' 'E' CHANGING wa_hdr-l_r_no.
CONDENSE wa_hdr-l_r_no.

* Get Vehicle No.
PERFORM get_text USING objname 'VBBK' 'Z004' 'E' CHANGING wa_hdr-vhicl.
CONDENSE wa_hdr-vhicl.

* Get Freight.
PERFORM get_text USING objname 'VBBK' 'Z005' 'E' CHANGING wa_hdr-freight.
CONDENSE wa_hdr-freight.

* Get Transport Date
PERFORM get_text USING objname 'VBBK' 'Z012' 'E' CHANGING wa_hdr-trnsprt_dt.
CONDENSE wa_hdr-trnsprt_dt.

SELECT SINGLE butxt
  FROM t001
  INTO CORRESPONDING FIELDS OF wa_hdr
  WHERE bukrs = wa_hdr-bukrs.

SELECT SINGLE name1 ort01 adrnr
  FROM t001w
  INTO CORRESPONDING FIELDS OF wa_hdr
  WHERE werks = wa_hdr-werks.

SELECT SINGLE *
  FROM adrc
  INTO wa_adrc
  WHERE addrnumber = wa_hdr-adrnr.

SELECT SINGLE smtp_addr
  INTO wa_hdr-email
  FROM adr6
  WHERE addrnumber = wa_hdr-adrnr.
break jbondale.
*SELECT SINGLE uri_addr uri_length
*  INTO (wa_hdr-url, wa_hdr-uri_length)
*  FROM adr12
*  WHERE addrnumber = wa_hdr-adrnr.

SELECT SINGLE j_1iexrn j_1iexrg j_1iexdi
    j_1iexco j_1isern j_1icstno j_1ilstno
  FROM j_1imocomp
  INTO CORRESPONDING FIELDS OF wa_hdr
  WHERE werks = wa_hdr-werks.

SELECT SINGLE adrnr
FROM kna1
INTO wa_hdr-kunag_adrnr
WHERE kunnr = wa_hdr-kunag.

* Fetch Buyer(Sold-To-Party)-Details
SELECT SINGLE j_1iexcd j_1icstno j_1ilstno
FROM j_1imocust
INTO (wa_hdr-kunag_j_1iexcd, wa_hdr-kunag_j_1icstno, wa_hdr-kunag_j_1ilstno)
WHERE kunnr = wa_hdr-kunag.

SELECT SINGLE ort01 adrnr
FROM kna1
INTO (wa_hdr-kunwe_ort01, wa_hdr-kunwe_adrnr)
WHERE kunnr = wa_hdr-kunwe.

*break-point.
* Fetch list intems' details
SELECT zeile shipfrom rcwrk matnr menge
  meins rgplaser ritem2
  FROM j_1iexcdtl
  INTO CORRESPONDING FIELDS OF TABLE it_items
  WHERE trntyp  = wa_hdr-trntyp
    AND docyr   = wa_hdr-docyr
    AND docno   = wa_hdr-docno.

SELECT kposn kschl kbetr waers kstat kwert
  FROM konv "J_1IKONV
  INTO CORRESPONDING FIELDS OF TABLE it_items_konv
  WHERE knumv = wa_hdr-knumv
    AND kschl IN ('ZPR0', 'ZPFO', 'ZEXP', 'ZCEP', 'ZCEH',
          'ZLST', 'ZCST', 'ZIN1', 'ZIN2', 'ZFR1', 'ZFR2').

SELECT matnr arktx matkl ntgew vgbel aubel
      fkimg AS brgew
      vrkme AS gewei
  FROM vbrp
  INTO CORRESPONDING FIELDS OF TABLE it_vbrp
  FOR ALL ENTRIES IN it_items
  WHERE vbeln = i_vbeln
  AND matnr = it_items-matnr.

" Set purchase order parameters
READ TABLE it_vbrp INDEX 1 INTO wa_vbrp.

SELECT matnr lfimg
  FROM lips
  INTO TABLE it_lips
  WHERE vbeln = wa_vbrp-vgbel.

IF sy-subrc EQ 0.
  LOOP AT it_lips INTO wa_lips.
    IF wa_lips-matnr CP 'WB*'.
      wdnbx_count = wdnbx_count + wa_lips-lfimg.
    ELSEIF wa_lips-matnr CP 'CB*'.
      crgbx_count = crgbx_count + wa_lips-lfimg.
    ENDIF.
  ENDLOOP.
ENDIF.


SELECT SINGLE bstnk bstdk
  FROM vbak
  INTO (wa_hdr-bstnk, wa_hdr-bstdk)
  WHERE vbeln = wa_vbrp-aubel.
CLEAR wa_vbrp.

SORT : it_items BY zeile,
it_items_konv BY kposn.
SORT it_items BY matkl.


LOOP AT it_items INTO wa_item.
  IF i_nast-kschl = 'ZJIS'.
    wa_item-ritem2 = wa_item-ritem2 * 10.
  ENDIF.

  CLEAR wa_item_konv.
  READ TABLE it_items_konv INTO wa_item_konv WITH KEY kposn = wa_item-ritem2 " WA_ITEM-ZEILE
  kschl = 'ZPR0'.
  IF sy-subrc = 0.
    wa_item-kbetr = wa_item_konv-kbetr.
    wa_item-kwert = wa_item_konv-kwert.
    wa_item-waers = wa_item_konv-waers.
  ENDIF.

  DELETE TABLE it_items_konv FROM wa_item_konv.

  READ TABLE it_vbrp  INTO wa_vbrp WITH KEY matnr = wa_item-matnr.

  wa_item-matkl       = wa_vbrp-matkl.
*  WA_ITEM-NTGEW       = WA_VBRP-NTGEW.
  wa_item-brgew       = wa_vbrp-brgew.
  wa_item-gewei       = wa_vbrp-gewei.

  wa_item-maktx       = wa_vbrp-arktx.
  MODIFY it_items FROM wa_item.
  CLEAR wa_item.
ENDLOOP.

* Calculations related with taxes and discounts applicable.
CLEAR : wa_condition,
        wa_item_konv.

" Club Similar condition types under respective single ones
CLEAR wa_item_konv.
wa_item_konv-kschl = 'ZIN1'.
MODIFY it_items_konv FROM wa_item_konv TRANSPORTING kschl WHERE kschl = 'ZIN2'.

CLEAR wa_item_konv.
wa_item_konv-kschl = 'ZFR1'.
MODIFY it_items_konv FROM wa_item_konv TRANSPORTING kschl WHERE kschl = 'ZFR2'.

SORT it_items_konv BY kschl.

" Cancel/ Reset the stat-condition values to zero, if the Export Type NOT-IN (N, D)
IF  wa_hdr-expind <> 'N'." AND WA_HDR-EXPIND <> 'D'.

  "----- CHANGES------"
  IF wa_hdr-expind IS NOT INITIAL.
    CLEAR: wa_hdr-ecs, wa_hdr-exbed, wa_hdr-exaddtax1.
    wa_hdr-ecs =  '0.00'.
    wa_hdr-exbed =  '0.00'.
    wa_hdr-exaddtax1 =  '0.00'.


    CLEAR wa_item_konv.
    wa_item_konv-kwert = '0.00'.
    MODIFY it_items_konv FROM wa_item_konv TRANSPORTING kwert WHERE kstat = 'X'.
  ENDIF.

ENDIF.

LOOP AT it_items_konv INTO wa_item_konv WHERE kposn IS NOT INITIAL.
  IF wa_condition-kschl <> wa_item_konv-kschl.
    IF NOT wa_condition-kschl IS INITIAL.
      PERFORM append_pricing TABLES   it_conditions
                             USING    wa_condition
                                      wa_hdr-waerk
                                      wa_hdr-kurrf
                             CHANGING total_invoice_amount.
      CLEAR wa_condition.
    ENDIF.
    wa_condition-kschl = wa_item_konv-kschl.
    wa_condition-kbetr = wa_item_konv-kbetr.
    wa_condition-waers = wa_item_konv-waers.
    IF wa_condition-waers IS INITIAL.
      wa_condition-waers = '%'.
      wa_condition-kbetr = wa_condition-kbetr / 10.
    ENDIF.
  ENDIF.

  wa_condition-kwert = wa_condition-kwert + wa_item_konv-kwert.
ENDLOOP.
IF NOT wa_condition IS INITIAL.
  PERFORM append_pricing TABLES   it_conditions
                         USING    wa_condition
                                  wa_hdr-waerk
                                  wa_hdr-kurrf
                         CHANGING total_invoice_amount.
  "   TOTAL_INVOICE_AMOUNT = TOTAL_INVOICE_AMOUNT + WA_CONDITION-KWERT.
  CLEAR wa_condition.
ENDIF.

*"............................................................
*  CLEAR WA_CONDITION.
*  WA_CONDITION-KSCHL = '_GRT'.
*  WA_CONDITION-KWERT = TOTAL_INVOICE_AMOUNT.
*  "CLEAR TOTAL_INVOICE_AMOUNT.
*  PERFORM APPEND_PRICING TABLES IT_CONDITIONS
*                         USING  WA_CONDITION
*                                WA_HDR-WAERK
*                                WA_HDR-KURRF
*                         CHANGING TOTAL_INVOICE_AMOUNT.
*"............................................................

* for Total CENVAT Duty Payable
CLEAR total_cenvat.
LOOP AT it_conditions INTO wa_condition WHERE kschl = 'ZEXP'
                                              OR kschl = 'ZCEP'
                                              OR kschl =  'ZCEH'.
  total_cenvat = total_cenvat + wa_condition-kwert.
ENDLOOP.

CLEAR total_invoice_amount.
SORT : it_conditions BY sqno,
      it_items BY zeile.
"======================================================================
*BREAK-POINT.
DESCRIBE TABLE it_items LINES counter.
