TYPES : BEGIN OF t_lips,
          matnr TYPE matnr,
          lfimg TYPE lfimg,
        END OF t_lips.

DATA: gv_amount_text(15)  TYPE c.

DATA : lv_date      TYPE mjahr,
       v_docno      TYPE j_1idocno,
       lips_vbeln   TYPE vbeln_vl,
       objname      TYPE tdobname,
       wa_lips      TYPE t_lips,
       it_lips      TYPE TABLE OF t_lips,
       it_j1imtchid TYPE TABLE OF j_1imtchid,
       wa_j1imtchid TYPE j_1imtchid.


DATA ls_vbrk   TYPE vbrk.
DATA ls_konv   TYPE konv.
DATA ls_taxs   TYPE konv.
DATA ls_vbrp   TYPE vbrp.
DATA lv_crate  TYPE vbrp-kursk.

CLEAR : lv_date   ,
        v_docno   ,
        lips_vbeln,
        objname   ,
        wa_lips   ,
        wdnbx_count,
        crgbx_count,
        ttlbx_count,
        lv_crate.
BREAK fujiabap.
CLEAR : consinee_tin , buyer_tin.
vbrp_vbeln = i_vbeln.

SELECT SINGLE knumv fkart waerk kurrf
  FROM vbrk
  INTO CORRESPONDING FIELDS OF wa_hdr
  WHERE vbeln = vbrp_vbeln.

SELECT * FROM konv INTO TABLE gt_konv
WHERE knumv = wa_hdr-knumv.

SELECT SINGLE vgbel kursk
  FROM vbrp
  INTO ( wa_hdr-vbeln , lv_crate )
  WHERE vbeln = vbrp_vbeln.

DELETE gt_konv WHERE kstat = 'X'
                OR NOT kinak IS INITIAL.

LOOP AT gt_konv INTO ls_konv.
  CHECK NOT ( ls_konv-kschl = 'ZPR1'
             OR ls_konv-kschl = 'ZPRO'
             OR ls_konv-kschl = 'ZCIF'
             OR ls_konv-kschl = 'VPRS' ).
  CHECK ls_konv-kinak IS INITIAL.

  ls_taxs-kschl = ls_konv-kschl.
*  ls_taxs-kwert = ls_konv-kwert.

  """"""""""""""""""""""""""""""""""""""""""""""
  IF ls_konv-waers = 'INR' OR
       ls_konv-waers =  ' '.
    ls_taxs-kwert = ls_konv-kwert .
*    ls_taxs-waers = ls_konv-waers.
  ELSEIF ls_konv-waers NE 'INR' AND
         lv_crate IS NOT INITIAL.
    ls_taxs-kwert = ( ls_konv-kwert * lv_crate ).
    ls_taxs-waers = 'INR'.
  ENDIF.

  COLLECT ls_taxs INTO gt_taxs.
ENDLOOP.

FIELD-SYMBOLS <fs_taxs> TYPE konv.
DATA lv_vtext TYPE t685t-vtext.

LOOP AT gt_taxs ASSIGNING <fs_taxs>.
  CLEAR ls_konv.
  READ TABLE gt_konv INTO ls_konv
    WITH KEY kschl = <fs_taxs>-kschl.
  <fs_taxs>-kbetr = ls_konv-kbetr / 10.
  <fs_taxs>-krech = ls_konv-krech.
  <fs_taxs>-waers = ls_konv-waers.
  SELECT SINGLE vtext FROM t685t INTO lv_vtext
    WHERE kschl = <fs_taxs>-kschl
      AND spras = 'EN'.

  REPLACE '(%)' IN lv_vtext WITH ''.
  REPLACE '(%' IN lv_vtext WITH ''.
  REPLACE '%' IN lv_vtext WITH ''.

  <fs_taxs>-varcond = lv_vtext.

  CASE <fs_taxs>-kschl.
    WHEN 'ZPFO'.
      <fs_taxs>-stunr = 10.
      <fs_taxs>-varcond = 'P & F'.
    WHEN 'ZDIS'.
      <fs_taxs>-stunr = 12.
      <fs_taxs>-varcond = 'Discount'.
    WHEN 'ZEXP'.
      <fs_taxs>-stunr = 13. """ 14
      <fs_taxs>-varcond = 'Excise Duty Collected @ '.
    WHEN 'ZIN1'.
      <fs_taxs>-stunr = 15.
      <fs_taxs>-varcond = 'Insurance Taxable'.
    WHEN 'ZFR1'.
      <fs_taxs>-stunr = 16.
      <fs_taxs>-varcond = 'Freight Taxable'.
    WHEN 'ZOC1'.
      <fs_taxs>-stunr = 17.
      <fs_taxs>-varcond = 'Octroi Taxable'.
    WHEN 'ZTE1'.
      <fs_taxs>-stunr = 18.
      <fs_taxs>-varcond = 'Testing Taxable'.
    WHEN 'ZTC1'.
      <fs_taxs>-stunr = 19.
      <fs_taxs>-varcond = 'Testing & Certificate Taxable'.
    WHEN 'ZLST'.
      <fs_taxs>-stunr = 20.
      <fs_taxs>-varcond = 'VAT @'.
    WHEN 'ZCST'.
      <fs_taxs>-stunr = 21.
      <fs_taxs>-varcond = 'CST @'.
    WHEN 'ZIN2'.
      <fs_taxs>-stunr = 22.
      <fs_taxs>-varcond = 'Insurance Non Taxable'.
    WHEN 'ZFR2'.
      <fs_taxs>-stunr = 23.
      <fs_taxs>-varcond = 'Freight Non Taxable'.
    WHEN 'ZOC2'.
      <fs_taxs>-stunr = 24.
      <fs_taxs>-varcond = 'Octroi Non Taxable'.
    WHEN 'ZTE2'.
      <fs_taxs>-stunr = 25.
      <fs_taxs>-varcond = 'Testing Non Taxable'.
    WHEN 'ZTC2'.
      <fs_taxs>-stunr = 26.
      <fs_taxs>-varcond = 'Testing & Certificate Non Taxable'.
    WHEN 'JWTS'.
      <fs_taxs>-stunr = 27.
      <fs_taxs>-varcond = 'TCS Collected @ 1%'.
    WHEN 'ZFCM'.
      <fs_taxs>-stunr = 28.
      <fs_taxs>-varcond = 'Customer Free Material'.
    WHEN 'ZFM2'.
      <fs_taxs>-stunr = 29.
      <fs_taxs>-varcond = 'Customer Free Mat Minus'.


    WHEN OTHERS.
  ENDCASE.
ENDLOOP.

BREAK kdeshmukh.

DELETE gt_taxs WHERE kwert = 0.

DATA : v_tax LIKE ls_taxs-kwert .
CLEAR : v_tax , ls_taxs .

*LOOP AT gt_taxs INTO ls_taxs WHERE ( kschl = 'ZPR0'
*                                  OR kschl = 'ZPFO'
*                                  OR kschl = 'ZEXP' ).
*  v_tax = v_tax + ls_taxs-kwert .
*ENDLOOP.
*
*CLEAR ls_taxs .
*ls_taxs-stunr = 13 .
*ls_taxs-varcond = 'Sub Total' .
*ls_taxs-kwert = v_tax .
*APPEND ls_taxs TO gt_taxs .
*
*SORT gt_taxs BY stunr .
BREAK fujiabap.
SELECT SINGLE *
*  trntyp docyr docno bukrs werks exnum exdat remtime
*  expind cpudt cputm excur kunag kunwe
*  exbed " BASIC EXCISE DUTY "
*  ecs   " ECS VALUE "
*  exaddtax1 " ADDITIONAL TAX 1 VALUE "
  FROM j_1iexchdr
  INTO CORRESPONDING FIELDS OF wa_hdr
  WHERE rdoc = vbrp_vbeln.

DATA : lv_excise TYPE j_1iexchdr-exbed .

IF wa_hdr-expind = 'N' AND wa_hdr-exbed IS NOT INITIAL.
  CLEAR lv_excise .
  SELECT SUM( exbed ) FROM j_1iexchdr INTO lv_excise
                          WHERE rdoc = vbrp_vbeln.
  CLEAR ls_taxs .
  READ TABLE gt_taxs INTO ls_taxs WITH KEY kschl = 'ZEXP'.
  IF sy-subrc = 0.
    ls_taxs-kwert = ls_taxs-kwert + lv_excise .
  ELSE.
    ls_taxs-kschl = 'ZEXP' .
    ls_taxs-stunr = 13 .
    ls_taxs-varcond = 'Excise Duty Collected '.
    ls_taxs-kwert = ls_taxs-kwert + lv_excise .
    ls_taxs-waers = wa_hdr-waerk .
    APPEND ls_taxs TO gt_taxs .
  ENDIF.
  CLEAR ls_taxs .
ENDIF.

LOOP AT gt_taxs INTO ls_taxs WHERE ( kschl = 'ZPR0'
                                  OR kschl = 'ZPFO'
                                  OR kschl = 'ZEXP' ).
  v_tax = v_tax + ls_taxs-kwert .
ENDLOOP.

CLEAR ls_taxs .
ls_taxs-stunr = 13 .
ls_taxs-varcond = 'Sub Total' .
ls_taxs-kwert = v_tax .
APPEND ls_taxs TO gt_taxs .

SORT gt_taxs BY stunr .

* Fetch Transporter info & exchange Rate
*SELECT SINGLE vgbel kursk
*  FROM vbrp
*  INTO ( wa_hdr-vbeln , lv_crate )
*  WHERE vbeln = vbrp_vbeln.

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
BREAK jbondale.
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

SELECT SINGLE kunnr j_1iexcd j_1icstno j_1ilstno j_1ipanref
    FROM j_1imocust
    INTO CORRESPONDING FIELDS OF wa_mocust
        WHERE kunnr = wa_hdr-kunwe .

SELECT SINGLE adrnr
FROM kna1
INTO wa_hdr-kunwe_adrnr
WHERE kunnr = wa_hdr-kunwe.

SELECT SINGLE kunnr j_1iexcd j_1icstno j_1ilstno j_1ipanref
    FROM j_1imocust
    INTO CORRESPONDING FIELDS OF wa_mocust1
        WHERE kunnr = wa_hdr-kunag .

SELECT SINGLE *
  FROM adrc
  INTO wa_adrc1
  WHERE addrnumber = wa_hdr-kunwe_adrnr.

SELECT SINGLE *
  FROM t005t
  INTO wa_t005t
  WHERE land1 = wa_adrc1-country
  AND   spras = 'EN'.

SELECT SINGLE *
  FROM t005u
  INTO wa_t005u
  WHERE land1 = wa_adrc1-country
  AND   bland = wa_adrc1-region
  AND   spras = 'EN'.

SELECT SINGLE *
 FROM adrc
 INTO wa_adrc2
 WHERE addrnumber = wa_hdr-kunag_adrnr.

SELECT SINGLE *
FROM t005t
INTO wa_t005t1
WHERE land1 = wa_adrc2-country
AND   spras = 'EN'.

SELECT SINGLE *
FROM t005u
INTO wa_t005u1
WHERE land1 = wa_adrc2-country
AND   bland = wa_adrc2-region
AND   spras = 'EN'.

* Fetch Buyer(Sold-To-Party)-Details
SELECT SINGLE j_1iexcd j_1icstno j_1ilstno j_1ipanref
FROM j_1imocust
INTO (wa_hdr-kunag_j_1iexcd, wa_hdr-kunag_j_1icstno,
      wa_hdr-kunag_j_1ilstno, wa_hdr-kunag_j_1ipanref)
WHERE kunnr = wa_hdr-kunag.

buyer_tin = wa_hdr-kunag_j_1ipanref.

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


SELECT kposn kschl kbetr waers kstat kwert kkurs
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

*SELECT matnr lfimg
*  FROM lips
*  INTO TABLE it_lips
*  WHERE vbeln = wa_vbrp-vgbel.
*
*IF sy-subrc EQ 0.
*  LOOP AT it_lips INTO wa_lips.
*    IF wa_lips-matnr CP 'WB*'.
*      wdnbx_count = wdnbx_count + wa_lips-lfimg.
*    ELSEIF wa_lips-matnr CP 'CB*'.
*      crgbx_count = crgbx_count + wa_lips-lfimg.
*    ENDIF.
*  ENDLOOP.
*
*  ttlbx_count = wdnbx_count + crgbx_count .
*ENDIF.

"""""""   Added By KD on 24.04.2017   """
DATA : it_header TYPE hum_hu_header_t,
       wa_header LIKE LINE OF it_header,
       i_deliv   TYPE TABLE OF ship_deliv WITH HEADER LINE,
       v_count   TYPE i,
       v_chtxt   TYPE j_1ichidtx-j_1icht1.

REFRESH : it_header , it_header[] , i_deliv , i_deliv[] ,
          it_j1imtchid , it_j1imtchid[].
CLEAR   : wa_header , wa_j1imtchid , v_count.

SELECT * FROM j_1imtchid INTO TABLE it_j1imtchid
                FOR ALL ENTRIES IN it_vbrp
                WHERE matnr = it_vbrp-matnr .

DELETE ADJACENT DUPLICATES FROM it_j1imtchid
COMPARING j_1ichid .

READ TABLE it_j1imtchid INTO wa_j1imtchid WITH KEY
          j_1ichid = '8481 80 30'.
IF sy-subrc = 0.
  ch_text =  wa_j1imtchid-j_1ichid .

*  CLEAR v_chtxt .
*  SELECT SINGLE j_1icht1 FROM j_1ichidtx INTO v_chtxt
*            WHERE j_1ichid = wa_j1imtchid-j_1ichid
*              AND langu = 'EN' .
*  IF sy-subrc = 0.
*    CONCATENATE ch_text '-' v_chtxt INTO ch_text
*      SEPARATED BY ' ' .
*  ENDIF.

  CONCATENATE ch_text '- INDUSTRIAL VALVE'  INTO ch_text
    SEPARATED BY ' ' .

ENDIF.

CLEAR wa_j1imtchid .
READ TABLE it_j1imtchid INTO wa_j1imtchid WITH KEY
          j_1ichid = '8481 90 90'.
IF sy-subrc = 0.
  ch_text1 =  wa_j1imtchid-j_1ichid .

*  CLEAR v_chtxt .
*  SELECT SINGLE j_1icht1 FROM j_1ichidtx INTO v_chtxt
*            WHERE j_1ichid = wa_j1imtchid-j_1ichid
*              AND langu = 'EN' .
*  IF sy-subrc = 0.
*    CONCATENATE ch_text1 '-' v_chtxt INTO ch_text1
*      SEPARATED BY ' ' .
*
*    CONCATENATE ch_text ';' ch_text1 INTO ch_text
*     SEPARATED BY ' ' .
*  ENDIF.

  CONCATENATE ch_text1 '- ACTUATORS / ACCESSORIES'  INTO ch_text1
       SEPARATED BY ' ' .

  CONCATENATE ch_text ';' ch_text1 INTO ch_text
       SEPARATED BY ' ' .
ENDIF.

*LOOP AT it_j1imtchid INTO wa_j1imtchid.
*  IF sy-tabix = 1.
*    ch_text = wa_j1imtchid-j_1ichid .
*  ELSEIF sy-tabix GT 1 .
*    CONCATENATE ch_text ' / ' wa_j1imtchid-j_1ichid INTO ch_text SEPARATED BY ' '.
*  ENDIF.
*  CLEAR wa_j1imtchid.
*ENDLOOP.

i_deliv-vbeln = wa_vbrp-vgbel.
APPEND i_deliv .

CALL FUNCTION 'SD_SHIPMENT_DELIVERY_HUS'
  IMPORTING
    et_header   = it_header
*   ET_ITEMS    =
  TABLES
    i_deliv     = i_deliv[]
  EXCEPTIONS
    hu_changed  = 1
    fatal_error = 2
    OTHERS      = 3.

IF it_header IS NOT INITIAL.
  LOOP AT it_header INTO wa_header.
    IF wa_header-vhilm CP 'PBMMW*'.
      wdnbx_count = wdnbx_count + 1.
    ELSEIF wa_header-vhilm CP 'PBMMC*'.
      crgbx_count = crgbx_count + 1.
    ENDIF.
  ENDLOOP.

  ttlbx_count = wdnbx_count + crgbx_count .
ENDIF.
"""""""""""""""""""""""""""""""""""""""""
DATA : lv1_kunnr TYPE kna1-kunnr .
gv_sono = wa_vbrp-aubel.

SELECT SINGLE kunnr FROM vbpa INTO lv1_kunnr
                      WHERE vbeln = gv_sono
                        AND parvw = 'WE'.

SELECT SINGLE j_1ipanref FROM j_1imocust INTO consinee_tin
          WHERE kunnr = lv1_kunnr .

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
    IF wa_item_konv-waers = 'INR'  OR
       wa_item_konv-waers = ' '..
      wa_item-kbetr = wa_item_konv-kbetr.
      wa_item-kwert = wa_item_konv-kwert.
      wa_item-waers = wa_item_konv-waers.
    ELSEIF wa_item_konv-waers NE 'INR' AND
           wa_item_konv-kkurs IS NOT INITIAL.
      wa_item-kbetr = wa_item_konv-kbetr * lv_crate.
      wa_item-kwert = wa_item_konv-kwert * lv_crate.
      wa_item-waers = 'INR'.
    ENDIF.
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
    IF wa_item_konv-waers = 'INR' OR
       wa_item_konv-waers = ' '.
      wa_condition-kbetr = wa_item_konv-kbetr .
      wa_condition-waers = wa_item_konv-waers.
    ELSEIF wa_item_konv-waers NE 'INR' AND
           lv_crate IS NOT INITIAL.
      wa_condition-kbetr = wa_item_konv-kbetr * lv_crate .
      wa_condition-waers = 'INR'.
    ENDIF.

    IF wa_condition-waers IS INITIAL.
      wa_condition-waers = '%'.
      wa_condition-kbetr = wa_condition-kbetr / 10.
    ENDIF.
  ENDIF.
  IF wa_item_konv-waers = 'INR'  OR
     wa_item_konv-waers = ' '.
    wa_condition-kwert = wa_condition-kwert + wa_item_konv-kwert .
  ELSEIF wa_item_konv-waers NE 'INR' AND
         lv_crate IS NOT INITIAL.
    wa_condition-kwert = wa_condition-kwert + ( wa_item_konv-kwert * lv_crate ).
  ENDIF.

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

IF total_cenvat IS NOT INITIAL.

  DATA : gv_amt1 TYPE pc207-betrg.
  CLEAR gv_amt1.
  gv_amt1 = total_cenvat .
***break fujiabap.
  IF gv_amt1 IS NOT INITIAL.
    CLEAR c_text .
    CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
      EXPORTING
        amt_in_num         = gv_amt1
      IMPORTING
        amt_in_words       = c_text
      EXCEPTIONS
        data_type_mismatch = 1
        OTHERS             = 2.

  ELSE.
    c_text = 'Nil'.
  ENDIF.
  TRANSLATE c_text TO UPPER CASE .

ENDIF.

CLEAR total_invoice_amount.
SORT : it_conditions BY sqno,
      it_items BY zeile.
"======================================================================
*BREAK-POINT.
DESCRIBE TABLE it_items LINES counter.
