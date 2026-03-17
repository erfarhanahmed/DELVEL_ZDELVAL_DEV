data  : lv_txt type string.
CLEAR : V_TEXT, WA_CONDITION, lv_txt.

*****  taxcom-bukrs = ekpo-bukrs.
*****  taxcom-budat = ekko-bedat.
*****  taxcom-waers = ekko-waers.
*****  taxcom-kposn = ekpo-ebelp.
*****  taxcom-mwskz = ekpo-mwskz.
*****  taxcom-txjcd = ekpo-txjcd.
*****  taxcom-shkzg = 'H'.
*****  taxcom-xmwst = 'X'.
*****
*****  IF ekko-bstyp EQ bstyp-best.
*****    taxcom-wrbtr = ekpo-netwr.
*****  ELSE.
*****    taxcom-wrbtr = ekpo-zwert.
*****  ENDIF.
*****
*****  taxcom-lifnr = ekko-lifnr.
*****  taxcom-land1 = ekko-lands.
*****  taxcom-ekorg = ekko-ekorg.
*****  taxcom-hwaer = t001-waers.
*****  taxcom-llief = ekko-llief.
*****  taxcom-bldat = ekko-bedat.
*****  taxcom-matnr = ekpo-ematn.
*****  taxcom-werks = ekpo-werks.
*****  taxcom-bwtar = ekpo-bwtar.
*****  taxcom-matkl = ekpo-matkl.
*****  taxcom-meins = ekpo-meins.
*****
*****  IF ekko-bstyp EQ bstyp-best.
*****    taxcom-mglme = ekpo-menge.
*****  ELSE.
*****    IF ekko-bstyp EQ bstyp-kont AND ekpo-abmng GT 0.
*****      taxcom-mglme = ekpo-abmng.
*****    ELSE.
*****      taxcom-mglme = ekpo-ktmng.
*****    ENDIF.
*****  ENDIF.
*****
*****  IF taxcom-mglme EQ 0.
*****    taxcom-mglme = 1000.
*****  ENDIF.
*****
*****  taxcom-mtart = ekpo-mtart.
*****
*****  IF EKKO-LIFNR IS INITIAL AND NOT EKKO-LLIEF IS INITIAL.
*****    taxcom-lifnr = ekko-llief.
*****  ENDIF.
*****BREAK-POINT.
*****  CALL FUNCTION 'CALCULATE_TAX_ITEM'
*****    EXPORTING
*****      i_taxcom            = taxcom
*****    IMPORTING
*****      e_taxcom            = taxcom
*****    TABLES
*****      T_XKOMV             = ITKONV
*****    EXCEPTIONS
*****      mwskz_not_defined   = 1
*****      mwskz_not_found     = 2
*****      mwskz_not_valid     = 3
*****      steuerbetrag_falsch = 4
*****      country_not_found   = 5
*****      OTHERS              = 6.
*****
*****  IF sy-subrc <> 0.
******    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
******    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*****  ENDIF.
*****
*****  "p_mwsbp = taxcom-wmwst .


READ TABLE IT_CONDITIONS INTO WA_CONDITION WITH KEY SQNO = counter.
IF SY-SUBRC <> 0.
  V_TEXT = '0.00'.
else.
*  TOTAL_AMOUNT = TOTAL_AMOUNT + WA_CONDITION-KWERT.
*  V_TEXT = WA_CONDITION-KWERT.

  lv_txt = WA_CONDITION-Kbetr / 10.
  v_text = lv_txt * Total_amount.
  v_text = v_text / 100.
  TOTAL_AMOUNT = TOTAL_AMOUNT + v_text.
ENDIF.

"CONCATENATE v_text '-' WA_CONDITION-descr INTO v_text.
"CONCATENATE v_text '-' counter INTO v_text.
CONDENSE V_TEXT.

counter = counter + 1.


