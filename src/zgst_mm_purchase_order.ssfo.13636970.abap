
*FORM tax_calc." USING po1 ino CHANGING ibed icst ivat iser iesr isch
*cumdisc."IEDU ISEC.
*BREAK-POINT.
DATA: it_ekko TYPE ekko,
      it_ekpo TYPE ekpo.
DATA: ltax_bed     TYPE konv-kwert VALUE 0,
      ltax_bed1    TYPE konv-kbetr VALUE 0,
*         LTAX_EDU TYPE KONV-KWERT VALUE 0,
      ltax_cst1    TYPE konv-kbetr VALUE 0,
      ltax_cst     TYPE konv-kwert VALUE 0,
      ltax_ser     TYPE konv-kwert VALUE 0,
      ltax_esr     TYPE konv-kwert VALUE 0,
      ltax_sch     TYPE konv-kwert VALUE 0,
      ltax_vat1    TYPE konv-kbetr VALUE 0,
      ltax_vat     TYPE konv-kwert VALUE 0,
      ltax_cumdisc TYPE konv-kwert VALUE 0.
*         LTAX_SEC TYPE KONV-KWERT VALUE 0.
DATA : BEGIN OF itabs OCCURS 0,
         ebeln LIKE ekko-ebeln,
         ebelp LIKE ekpo-ebelp,
         knumv LIKE ekko-knumv,
       END OF itabs.

DATA : BEGIN OF itabs1 OCCURS 0,
         "*kwert LIKE konv-kwert,
         fra1      LIKE konv-kwert,
         frb1      LIKE konv-kwert,
         frc1      LIKE konv-kwert,
         jec1      LIKE konv-kwert,
         jec2      LIKE konv-kwert,
         ins1      LIKE konv-kwert,
         ins2      LIKE konv-kwert,
         pack      LIKE konv-kwert,
         insurance LIKE konv-kwert,
         misc      LIKE konv-kwert,
         tcm       LIKE konv-kwert,
         disc      LIKE konv-kwert,
         cumdisc   LIKE konv-kwert,
         fra       LIKE konv-kwert,
         frb2      LIKE konv-kwert,
         cumfrb2   LIKE konv-kwert,
       END OF itabs1.
*  DATA:knumv1 type ekko-knumv.
DATA: ebeln TYPE ekpo-ebeln,
      ebelp TYPE ekpo-ebelp.

*LOOP AT IT_ITEMs INTO wa_ITEM.
SELECT SINGLE knumv FROM ekko INTO knumv1
   WHERE ebeln = wa_hdr-ebeln.
*BREAK fujiabap.
**LOOP AT it_items INTO wa_item.
**ENDLOOP.
SELECT ebeln ebelp FROM ekpo
  INTO CORRESPONDING FIELDS OF itabs "(ebl, it)
    WHERE ebeln EQ wa_hdr-ebeln AND
                      ebelp EQ wa_item-ebelp.


*    itabs-ebeln = ebl.
*    itabs-ebelp = it.
  itabs-knumv = knumv1.
  APPEND itabs.
  CLEAR itabs.
*   ENDLOOP.
ENDSELECT.
"***********************START OF CALCULATE TAX
*******************************************
DATA : it_xkomv TYPE komv OCCURS 0 WITH HEADER LINE.
DATA : it_taxcom     TYPE taxcom,
       lt_conditions TYPE tt_conditions,
       ls_conditions TYPE t_conditions.
DATA:
  lv_netwr TYPE ekpo-netwr,
  lv_ins   TYPE ekpo-netwr,
  lv_fri   TYPE ekpo-netwr,
  lv_amv   TYPE ekpo-netwr,
  lv_scq   TYPE ekpo-netwr,
  lv_p_l   TYPE ekpo-netwr,
  lv_dev   TYPE ekpo-netwr,
  lv_dev_q TYPE ekpo-netwr,
  lv_dev_p TYPE ekpo-netwr,
  lv_oc    TYPE ekpo-netwr,
  lv_ocq   TYPE ekpo-netwr,
  lv_ocp   TYPE ekpo-netwr,
  lv_com   TYPE ekpo-netwr,
  lv_com_v TYPE ekpo-netwr.

*BREAK fujiabap.

CLEAR:
     it_taxcon,it_xkomv[].
IF NOT itabs[] IS INITIAL.

  SELECT knumv
         kposn
         kschl
         kwert
         kbetr
    FROM konv
    INTO TABLE lt_conditions
    FOR ALL ENTRIES IN itabs
    WHERE knumv = itabs-knumv.

ENDIF.
BREAK fujiabap.

LOOP AT it_items INTO wa_item.
  CLEAR: lv_ins,lv_p_l,lv_amv,lv_fri,lv_scq,lv_dev,lv_dev_q,
         lv_dev_p,lv_oc,lv_ocq,lv_ocp,lv_com,lv_com_v.

  READ TABLE itabs INDEX 1.
  SELECT SINGLE * FROM ekko  INTO it_ekko
    WHERE ebeln = itabs-ebeln.

  SELECT SINGLE * FROM ekpo  INTO it_ekpo
    WHERE ebeln = itabs-ebeln AND
     ebelp = itabs-ebelp.

  CLEAR it_xkomv.
  REFRESH it_xkomv.
  CLEAR ls_conditions.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZINS' .
  IF sy-subrc IS INITIAL.
    lv_ins = ls_conditions-kwert.
    ins_val = ins_val + lv_ins.
  ENDIF.

  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZPFL' .
  IF sy-subrc IS INITIAL.
    lv_p_l  = ls_conditions-kwert.
    pfl_val = pfl_val + lv_p_l.
    pfl_rate = ls_conditions-kbetr / 10.
  ENDIF.
  READ TABLE lt_conditions INTO ls_conditions
                           WITH KEY knumv = itabs-knumv
                                    kposn = wa_item-ebelp
                                    kschl = 'ZPC1' .
  IF sy-subrc IS INITIAL.
    lv_p_l  = ls_conditions-kwert.
    pfl_val = pfl_val + lv_p_l.
  ENDIF.
  READ TABLE lt_conditions INTO ls_conditions
                              WITH KEY knumv = itabs-knumv
                                       kposn = wa_item-ebelp
                                       kschl = 'ZPFV' .
  IF sy-subrc IS INITIAL.
    lv_p_l  = ls_conditions-kwert.
    pfl_val = pfl_val + lv_p_l.
  ENDIF.
  READ TABLE lt_conditions INTO ls_conditions
                           WITH KEY knumv = itabs-knumv
                                    kposn = wa_item-ebelp
                                    kschl = 'ZAMV' .
  IF sy-subrc IS INITIAL.
    lv_amv  = ls_conditions-kwert.
    gv_amv  = gv_amv + lv_amv.
  ENDIF.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZRB1' .
  IF sy-subrc IS INITIAL.
    lv_fri  = ls_conditions-kwert.
    fri_val = fri_val + lv_fri.
  ENDIF.

  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZRC1' .
  IF sy-subrc IS INITIAL.
    lv_fri  = ls_conditions-kwert.
    fri_val = fri_val + lv_fri.
  ENDIF.

  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'FRA1' .
  IF sy-subrc IS INITIAL.
    lv_fri  = ls_conditions-kwert.
    fri_val = fri_val + lv_fri.
  ENDIF.

  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZSCQ' .
  IF sy-subrc IS INITIAL.
    lv_scq  = ls_conditions-kwert.
    gv_scq = gv_scq + lv_scq.
  ENDIF.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZSCV' .
  IF sy-subrc IS INITIAL.
    lv_scq  = ls_conditions-kwert.
    gv_scq = gv_scq + lv_scq.
  ENDIF.
  CLEAR ls_conditions.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZDV%' .
  IF sy-subrc IS INITIAL.
    lv_dev_p = ls_conditions-kwert.
    gv_dev_rate = ls_conditions-kbetr / 10.
    gv_dev_p = gv_dev_p + lv_dev_p.
  ENDIF.

  CLEAR ls_conditions.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZDVQ' .
  IF sy-subrc IS INITIAL.
    lv_dev_q = ls_conditions-kwert.
*    gv_dev_rate = ls_conditions-kbetr / 10.
    gv_dev_q = gv_dev_q + lv_dev_q.
  ENDIF.
  CLEAR ls_conditions.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZDVV' .
  IF sy-subrc IS INITIAL.
    lv_dev = ls_conditions-kwert.
*    gv_dev_rate = ls_conditions-kbetr / 10.
    gv_dev = gv_dev + lv_dev.
  ENDIF.
  CLEAR ls_conditions.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZOCV' .
  IF sy-subrc IS INITIAL.
    lv_oc = ls_conditions-kwert.
*    gv_dev_rate = ls_conditions-kbetr / 10.
    gv_oc = gv_oc + lv_oc.
  ENDIF.

  CLEAR ls_conditions.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZOCQ' .
  IF sy-subrc IS INITIAL.
    lv_ocq = ls_conditions-kwert.
*    gv_dev_rate = ls_conditions-kbetr / 10.
    gv_ocq = gv_ocq + lv_ocq.
  ENDIF.
  CLEAR ls_conditions.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZOC%' .
  IF sy-subrc IS INITIAL.
    lv_ocp = ls_conditions-kwert.
    gv_ocv_rate = ls_conditions-kbetr / 10.
    gv_ocp = gv_ocp + lv_ocp.
  ENDIF.
  CLEAR ls_conditions.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZCES' .
  IF sy-subrc IS INITIAL.
    lv_com = ls_conditions-kwert.
*    gv_ocv_rate = ls_conditions-kbetr / 10.
    gv_com = gv_com + lv_com.
  ENDIF.
  CLEAR ls_conditions.
  READ TABLE lt_conditions INTO ls_conditions
                            WITH KEY knumv = itabs-knumv
                                     kposn = wa_item-ebelp
                                     kschl = 'ZCEV' .
  IF sy-subrc IS INITIAL.
    lv_com_v = ls_conditions-kwert.
*    gv_ocv_rate = ls_conditions-kbetr / 10.
    gv_com_v = gv_com_v + lv_com_v.
  ENDIF.
  it_taxcon-bukrs = it_ekpo-bukrs.
  it_taxcon-budat = it_ekko-aedat.
  it_taxcon-bldat = it_ekko-bedat.
  it_taxcon-waers = it_ekko-waers.
  it_taxcon-hwaer = it_ekko-waers.
  it_taxcon-kposn = wa_item-ebelp.
  it_taxcon-mwskz = it_ekpo-mwskz.
  lv_netwr        = lv_netwr + wa_item-netwr.

  it_taxcon-wrbtr =
         wa_item-netwr + lv_ins + lv_amv + lv_p_l + lv_scq
         + lv_fri + lv_dev + lv_dev_q + lv_dev_p + lv_oc
         + lv_ocq + lv_ocp + lv_com + lv_com_v.

  it_taxcon-xmwst = 'X'.
  it_taxcom-shkzg =  'H'.
*  it_taxcon-txjcd = it_ekpo-txjcd.
  it_taxcon-lifnr = it_ekko-lifnr.
  it_taxcon-ekorg = it_ekko-ekorg.
  it_taxcon-ebeln = it_ekpo-ebeln.
  it_taxcon-ebelp = wa_item-ebelp.
  it_taxcon-matnr = wa_item-matnr.
  it_taxcon-werks = it_ekpo-werks.
  it_taxcon-matkl = it_ekpo-matkl.
  it_taxcon-meins = wa_item-meins.
  it_taxcon-mglme = wa_item-menge.
  it_taxcon-mtart = it_ekpo-mtart.
  it_taxcon-land1 = it_ekko-lands.
  "**************************START OF FUNCTION CALCULATE TAX
  "ITEM****************************
*break primus.

  CALL FUNCTION 'CALCULATE_TAX_ITEM'   "This is tHe Function Module
    EXPORTING
      dialog              = 'DIAKZ'
      display_only        = 'X'
      i_taxcom            = it_taxcon
    TABLES
      t_xkomv             = it_xkomv
    EXCEPTIONS
      mwskz_not_defined   = 1
      mwskz_not_found     = 2
      mwskz_not_valid     = 3
      steuerbetrag_falsch = 4
      country_not_found   = 5
      OTHERS              = 6.
*
  READ TABLE it_xkomv WITH KEY kschl = 'JICG'. " AND
  IF sy-subrc IS INITIAL.
    it_xkomv-kposn = itabs-ebelp.
*    cgst = cgst + it_xkomv-kwert.
    kb_cgst = it_xkomv-kbetr / 10.
    cgst = cgst + ( it_taxcon-wrbtr * kb_cgst / 100 ).
  ENDIF.

  READ TABLE it_xkomv WITH KEY kschl = 'JICN'. " AND
  IF sy-subrc IS INITIAL.
    it_xkomv-kposn = itabs-ebelp.
*    cgst = cgst + it_xkomv-kwert.
    kb_cgst = it_xkomv-kbetr / 10.
    cgst = cgst + ( it_taxcon-wrbtr * kb_cgst / 100 ).
  ENDIF.

*******************Avinash Bhagat 10.12.2018 **********************************
    READ TABLE it_xkomv WITH KEY kschl = 'JCIN'. " AND
  IF sy-subrc IS INITIAL.
    it_xkomv-kposn = itabs-ebelp.
*    cgst = cgst + it_xkomv-kwert.
    kb_jcin   = it_xkomv-kbetr / 10.
   jcin = jcin + ( it_taxcon-wrbtr * kb_jcin / 100 ).
  ENDIF.
*****************************************************
  READ TABLE it_xkomv WITH KEY kschl = 'JICR'. " AND
  IF sy-subrc IS INITIAL.
    it_xkomv-kposn = itabs-ebelp.
    gv_del_tax = gv_del_tax + it_xkomv-kwert.

    text = 'YES'.
  ENDIF.
  READ TABLE it_xkomv WITH KEY kschl = 'ZCRN'. " AND
  IF sy-subrc IS INITIAL.
    text = 'YES'.
    it_xkomv-kposn = itabs-ebelp.
    gv_del_tax = gv_del_tax + it_xkomv-kwert.


  ENDIF.

  READ TABLE it_xkomv WITH KEY kschl = 'JISG'. " AND
  IF sy-subrc IS INITIAL.
    it_xkomv-kposn = itabs-ebelp.
*    sgst = sgst + it_xkomv-kwert.
    kb_sgst = it_xkomv-kbetr / 10.
    sgst = sgst + ( it_taxcon-wrbtr * kb_sgst / 100 ).
  ENDIF.

  READ TABLE it_xkomv WITH KEY kschl = 'JISN'. " AND
  IF sy-subrc IS INITIAL.
    it_xkomv-kposn = itabs-ebelp.
*    sgst = sgst + it_xkomv-kwert.
    kb_sgst = it_xkomv-kbetr / 10.
    sgst = sgst + ( it_taxcon-wrbtr * kb_sgst / 100 ).
  ENDIF.
  READ TABLE it_xkomv WITH KEY kschl = 'JISR'. " AND
  IF sy-subrc IS INITIAL.
    text = 'YES'.
    it_xkomv-kposn = itabs-ebelp.
    gv_del_tax = gv_del_tax + it_xkomv-kwert.

  ENDIF.
  READ TABLE it_xkomv WITH KEY kschl = 'ZSRN'. " AND
  IF sy-subrc IS INITIAL.
    text = 'YES'.
    it_xkomv-kposn = itabs-ebelp.
    gv_del_tax = gv_del_tax + it_xkomv-kwert.

  ENDIF.
  READ TABLE it_xkomv WITH KEY kschl = 'JIIG'. " AND
  IF sy-subrc IS INITIAL.
    it_xkomv-kposn = itabs-ebelp.
*    igst = igst + it_xkomv-kwert.
    kb_igst = it_xkomv-kbetr / 10.
    igst = igst + ( it_taxcon-wrbtr * kb_igst / 100 ).
  ENDIF.
  READ TABLE it_xkomv WITH KEY kschl = 'JIIN'. " AND
  IF sy-subrc IS INITIAL.
    it_xkomv-kposn = itabs-ebelp.
*    igst = igst + it_xkomv-kwert.
    kb_igst = it_xkomv-kbetr / 10.
    igst = igst + ( it_taxcon-wrbtr * kb_igst / 100 ).
  ENDIF.
  READ TABLE it_xkomv WITH KEY kschl = 'ZIRN'. " AND
  IF sy-subrc IS INITIAL.
    text = 'YES'.
    it_xkomv-kposn = itabs-ebelp.
    gv_del_tax = gv_del_tax + it_xkomv-kwert.

  ENDIF.
ENDLOOP.

tot_tax = igst + cgst + sgst + jcin.
grand_tot =
    tot_tax + ins_val + lv_netwr + gv_del_tax + gv_scq
    + gv_amv + fri_val + pfl_val + gv_dev + gv_dev_q
    + gv_dev_p + gv_oc + gv_ocq + gv_ocp + gv_com
    + gv_com_v.


net_val   = grand_tot - gv_amv.
IF text IS INITIAL.
  text = 'NO'.
ENDIF.
*    "***************************END OF FUNTION CALCULATE
*    "***************START OF CUMULATIVE SALES, INSURANCE AND EXCISE
*   BREAK point.

**    LOOP AT it_xkomv.

******************Conditions**************
*      "*CGST
***BREAK fujiabap.
***      IF ( it_xkomv-kschl EQ 'JCIG' ) AND
***        it_xkomv-kposn = itabs-ebelp.
***        CGST = CGST + it_xkomv-kwert.
***        KB_CGST = it_xkomv-kbetr.
***
***      ENDIF.
***
***    IF ( it_xkomv-kschl EQ 'JSIG' ) AND
***        it_xkomv-kposn = itabs-ebelp.
***        SGST = SGST + it_xkomv-kwert.
***        KB_SGST = it_xkomv-kbetr.
***      ENDIF.
***
***       IF ( it_xkomv-kschl EQ 'JIIG' ) AND
***        it_xkomv-kposn = itabs-ebelp.
***        IGST = IGST + it_xkomv-kwert.
***        KB_IGST = it_xkomv-kbetr.
***      ENDIF.
***    ENDLOOP.
