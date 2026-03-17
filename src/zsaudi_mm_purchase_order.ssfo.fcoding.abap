FORM format_num USING num CHANGING v_text.
  DATA : v_num TYPE p LENGTH 4 DECIMALS 2,
         v_int TYPE  int4.
  v_num = num MOD 1.
  IF v_num NE '0.00'.
    v_num = num.
    v_text = v_num.
  ELSE.
    v_int = num.
    v_text = v_int.
  ENDIF.
ENDFORM.


FORM get_text USING objname TYPE tdobname
                    obj_typ
                    txt_id
                    lang TYPE spras
              CHANGING txt.

  DATA : text_lines   TYPE TABLE OF tline,
         wa_text_line TYPE tline.

  IF lang IS INITIAL.
    lang = 'E'.
  ENDIF.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                  = SY-MANDT
      id                      = txt_id
      language                = lang
      name                    = objname
      object                  = obj_typ
*     ARCHIVE_HANDLE          = 0
*     LOCAL_CAT               = ' '
*   IMPORTING
*     HEADER                  =
    TABLES
      lines                   = text_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    DESCRIBE TABLE text_lines.
    IF sy-tfill <> 0.
      LOOP AT text_lines INTO wa_text_line.
        CONCATENATE txt wa_text_line-tdline INTO txt.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.


FORM calculate_item_tax USING p_ebeln TYPE ekpo-ebeln
                              p_ebelp TYPE ekpo-ebelp
                              itkonv TYPE ty_tab_item_konv
                   .

  CONSTANTS: bstyp-info VALUE 'I',
             bstyp-ordr VALUE 'W',
             bstyp-banf VALUE 'B',
             bstyp-best VALUE 'F',
             bstyp-anfr VALUE 'A',
             bstyp-kont VALUE 'K',
             bstyp-lfpl VALUE 'L',
             bstyp-lerf VALUE 'Q'.

  TYPES : t_ekko TYPE ekko,
          t_ekpo TYPE ekpo,
          t_t001 TYPE t001.

  DATA : ekko   TYPE t_ekko,
         ekpo   TYPE t_ekpo,
         t001   TYPE t_t001,
         komk   TYPE komk,
         komp   TYPE komp,

         taxcom TYPE taxcom,
         t_konv TYPE TABLE OF komv,

         tkomv  TYPE TABLE OF komv,

         tkomvd TYPE TABLE OF komvd.

  CLEAR taxcom.
  REFRESH itkonv.

  SELECT SINGLE *
    INTO ekko
    FROM ekko
    WHERE ebeln = p_ebeln .

  SELECT SINGLE *
    INTO ekpo
    FROM ekpo
    WHERE ebeln = p_ebeln
          AND ebelp = p_ebelp .

  SELECT SINGLE *
    INTO t001
    FROM t001
    WHERE bukrs = ekko-bukrs .

  taxcom-bukrs = ekpo-bukrs.
  taxcom-budat = ekko-bedat.
  taxcom-waers = ekko-waers.
  taxcom-kposn = ekpo-ebelp.
  taxcom-mwskz = ekpo-mwskz.
  taxcom-txjcd = ekpo-txjcd.
  taxcom-shkzg = 'H'.
  taxcom-xmwst = 'X'.
  IF ekko-bstyp EQ bstyp-best.
    taxcom-wrbtr = ekpo-netwr
        + ekpo-kzwi1 + ekpo-kzwi2 + ekpo-kzwi3
        + ekpo-kzwi4 + ekpo-kzwi5
        + ekpo-kzwi6.

  ELSE.
    taxcom-wrbtr = ekpo-zwert.
  ENDIF.

  taxcom-lifnr = ekko-lifnr.
  taxcom-land1 = ekko-lands.
  taxcom-ekorg = ekko-ekorg.
  taxcom-hwaer = t001-waers.
  taxcom-llief = ekko-llief.
  taxcom-bldat = ekko-bedat.
  taxcom-matnr = ekpo-ematn.
  taxcom-werks = ekpo-werks.
  taxcom-bwtar = ekpo-bwtar.
  taxcom-matkl = ekpo-matkl.
  taxcom-meins = ekpo-meins.

  IF ekko-bstyp EQ bstyp-best.
    taxcom-mglme = ekpo-menge.
  ELSE.
    IF ekko-bstyp EQ bstyp-kont AND ekpo-abmng GT 0.
      taxcom-mglme = ekpo-abmng.
    ELSE.
      taxcom-mglme = ekpo-ktmng.
    ENDIF.
  ENDIF.

  IF taxcom-mglme EQ 0.
    taxcom-mglme = 1000.
  ENDIF.

  taxcom-mtart = ekpo-mtart.

  IF ekko-lifnr IS INITIAL AND NOT ekko-llief IS INITIAL.
    taxcom-lifnr = ekko-llief.
  ENDIF.
  CALL FUNCTION 'CALCULATE_TAX_ITEM'
    EXPORTING
      i_taxcom            = taxcom
    IMPORTING
      e_taxcom            = taxcom
    TABLES
      t_xkomv             = itkonv
    EXCEPTIONS
      mwskz_not_defined   = 1
      mwskz_not_found     = 2
      mwskz_not_valid     = 3
      steuerbetrag_falsch = 4
      country_not_found   = 5
      OTHERS              = 6.

  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "p_mwsbp = taxcom-wmwst .

ENDFORM. " calculate_item_tax


FORM append_condition TABLES it_konv TYPE ty_tab_konv
                      CHANGING bf_konv TYPE ty_konv.

  CASE bf_konv-kschl.
    WHEN 'ZPFL'.
      bf_konv-descr = 'P & F'.
      bf_konv-sq_no = 2.

    WHEN 'ZPFV'.
      bf_konv-descr = 'P & F'.
      bf_konv-sq_no = 4.

    WHEN 'ZINS'.
      bf_konv-descr = 'Inspection Charges'.
      bf_konv-sq_no = 5.

    WHEN 'ZAMV'.
      bf_konv-descr = 'Amortised Value'.
      bf_konv-sq_no = 6.

    WHEN 'JMOP'.
      bf_konv-descr = 'Excise'.
      bf_konv-sq_no = 10.

    WHEN 'JVRD'.
      bf_konv-descr = 'Tax(VAT)'.
      bf_konv-sq_no = 12.

    WHEN 'JVCS'.
      bf_konv-descr = 'CST'.
      bf_konv-sq_no = 14.

    WHEN 'FRA1'.
      bf_konv-descr = 'Freight'.
      bf_konv-sq_no = 20.

    WHEN 'FRB1'.
      bf_konv-descr = 'Freight'.
      bf_konv-sq_no = 22.

    WHEN 'FRB2'.
      bf_konv-descr = 'Freight'.
      bf_konv-sq_no = 24.

    WHEN 'ZSTV'.
      bf_konv-descr = 'Setting Charg'.
      bf_konv-sq_no = 34.

    WHEN 'JSER' OR 'JSV2'.
      bf_konv-descr = 'Service tax'.
      bf_konv-sq_no = 40.

    WHEN 'JSSB'.
      bf_konv-descr = 'Swachh Bharat Cess'.
      bf_konv-sq_no = 42.

    WHEN 'JKKP'.
      bf_konv-descr = 'Krishi Kalyan Cess'.
      bf_konv-sq_no = 44.

    WHEN 'NAVS'.
      bf_konv-descr = 'Non-Deductible Tax'.
      bf_konv-sq_no = 50.

    WHEN 'ZOCV' or 'ZOC%' OR 'ZOCQ'.
      bf_konv-descr = 'Other Charges'.
      bf_konv-sq_no = 60.

    WHEN 'JMX1'.
      bf_konv-kwert = bf_konv-kwert * -1.
      bf_konv-descr = 'Modvat'.
      bf_konv-sq_no = 110.

  ENDCASE.

  IF bf_konv-kwert <> '0.00'.
    APPEND bf_konv TO it_konv.
  ENDIF.

  IF bf_konv-kschl = 'ZAMV'.
    bf_konv-kwert = bf_konv-kwert * -1.
    bf_konv-descr = 'Reduction Amortised Value'.
    bf_konv-sq_no = 112.
    IF bf_konv-kwert <> '0.00'.
      APPEND bf_konv TO it_konv.
    ENDIF.
  ENDIF.

  CLEAR bf_konv.
ENDFORM.


****  ELSEIF bf_konv-kschl = 'ZOC'.
****    "OR BF_KONV-KSCHL = 'ZOCQ'
****    "OR BF_KONV-KSCHL = 'ZOCV'.
****
****    bf_konv-descr = 'Other'.
****    bf_konv-sq_no = 10.
****
****  ELSEIF bf_konv-kschl = 'JEC1'.
****    bf_konv-descr = 'Ed. Cess'.
****    bf_konv-sq_no = 2.
****  ELSEIF bf_konv-kschl = 'ZOC'.
****    "OR BF_KONV-KSCHL = 'ZOCQ'
****    "OR BF_KONV-KSCHL = 'ZOCV'.
****
****    bf_konv-descr = 'Other'.
****    bf_konv-sq_no = 10.
****
****  ELSEIF bf_konv-kschl = 'R000'.
****    "OR BF_KONV-KSCHL = 'R001'
****    "OR BF_KONV-KSCHL = 'R002'
****    "OR BF_KONV-KSCHL = 'RA01'.
****
****    bf_konv-descr = 'Discount'.
****    bf_konv-sq_no = 14.
****
****
****  ELSEIF bf_konv-kschl = 'JSEP'.
****
****    bf_konv-descr = 'HEd. Cess'.
****    bf_konv-sq_no = 3.
****
****  ELSEIF bf_konv-kschl = 'ZINR'.
****
****    bf_konv-descr = 'Insurance'.
****    bf_konv-sq_no = 13.
****
****  ELSEIF bf_konv-kschl = 'JOCM'.
****
****    bf_konv-descr = 'Octroi'.
****    bf_konv-sq_no = 12.
****
****
