class ZCL_EINVOICE_UTILITY definition
  public
  final
  create public .

public section.

  methods JSON_SCHEMA_MAPPING
    importing
      !IS_UPDATE type ZEINV_UPDATE
    changing
      !CT_JSON_IN type ZEINV_JSON_TT
      !CT_JSON_OUT type ZEINV_JSON_TT .
  methods GET_ADRC_DATA
    importing
      !IV_WERKS type WERKS_D
      !IV_KUNNR type KUNNR optional
      !IS_LIKP type ZEINV_LIKP optional
      !IV_INVTYP type CHAR3 optional
      !IV_BUKRS type BUKRS
      !IV_BUPLA type BUPLA
    changing
      !ES_SEL_ADDR type ZEINV_ADRC
      !ES_DIS_ADDR type ZEINV_ADRC
      !ES_BUY_ADDR type ZEINV_ADRC
      !ES_SHP_ADDR type ZEINV_ADRC .
  methods UNIT_CONVERT
    importing
      !IV_VRKME type VRKME
    exporting
      !EV_UNIT type ANY .
protected section.
private section.
ENDCLASS.



CLASS ZCL_EINVOICE_UTILITY IMPLEMENTATION.


  METHOD get_adrc_data.

    DATA :lv_gstin TYPE kna1-stcd3.
*    Seller details i.e. plant

    SELECT SINGLE adrnr
      FROM t001w
      INTO @DATA(lv_adrnr)
      WHERE werks = @iv_werks.

    IF lv_adrnr IS INITIAL.

      SELECT SINGLE adrnr
        FROM t001w
        INTO lv_adrnr
        WHERE j_1bbranch = iv_werks.

    ENDIF.
    IF iv_bukrs IS NOT INITIAL AND iv_bupla IS NOT INITIAL.

      SELECT SINGLE gstin
              FROM j_1bbranch
              INTO es_sel_addr-gstin
              WHERE bukrs  EQ iv_bukrs
              AND   branch EQ iv_bupla ."'PUNE'."iv_werks.

      SELECT  SINGLE butxt
              FROM t001
              INTO es_sel_addr-butxt
              WHERE bukrs  = iv_bukrs
              AND spras = 'E'.
    ENDIF.
    IF NOT lv_adrnr IS INITIAL.
      SELECT SINGLE addrnumber
             name1
             city1
             post_code1
             street
             str_suppl1
             str_suppl2
             location
             country
             region
             sort1
             mc_city1
             tel_number
        FROM adrc
        INTO es_sel_addr
        WHERE addrnumber EQ lv_adrnr.


      SELECT SINGLE bezei
           FROM t005u
           INTO es_sel_addr-bezei
           WHERE land1 =  es_sel_addr-country          "'IN'
           AND spras = sy-langu
           AND  bland EQ es_sel_addr-region .

      SELECT SINGLE legal_state_code
             FROM j_1istatecdm
             INTO es_sel_addr-region
             WHERE land1 = es_sel_addr-country
             AND std_state_code EQ es_sel_addr-region .



      SELECT SINGLE smtp_addr
             FROM adr6
             INTO  es_sel_addr-smtp_addr
             WHERE addrnumber = lv_adrnr.
    ENDIF.

    CLEAR: lv_adrnr, lv_gstin.
    IF iv_kunnr IS INITIAL.
      SELECT SINGLE adrnr stcd3
        FROM kna1
        INTO ( lv_adrnr, lv_gstin )
        WHERE kunnr = is_likp-kunag.
    ELSE."Credit-Debit Note
      SELECT SINGLE adrnr stcd3
        FROM kna1
        INTO ( lv_adrnr, lv_gstin )
        WHERE kunnr = iv_kunnr.
      IF sy-subrc ne 0.
        SELECT SINGLE adrnr stcd3
        FROM lfa1
        INTO ( lv_adrnr, lv_gstin )
        WHERE lifnr = iv_kunnr.

      ENDIF.

    ENDIF.
    IF NOT lv_adrnr IS INITIAL.
      SELECT SINGLE addrnumber
             name1
             city1
             post_code1
             street
             str_suppl1
             str_suppl2
             location
             country
             region
             sort1
             mc_city1
             tel_number
        FROM adrc
        INTO es_buy_addr
        WHERE addrnumber EQ lv_adrnr.

      SELECT SINGLE bezei
            FROM t005u
            INTO es_buy_addr-bezei
            WHERE land1 = es_buy_addr-country            "'IN'
            AND spras = sy-langu
            AND  bland EQ es_buy_addr-region .

      SELECT SINGLE legal_state_code
             FROM j_1istatecdm
             INTO es_buy_addr-region
             WHERE land1 = es_buy_addr-country
             AND std_state_code EQ es_buy_addr-region .

      SELECT SINGLE smtp_addr
                FROM adr6
                INTO es_buy_addr-smtp_addr
                WHERE addrnumber = lv_adrnr.
      es_buy_addr-gstin = lv_gstin.
    ENDIF.

    CLEAR lv_adrnr.

    CASE iv_invtyp.
      WHEN 'DIS'.
        SELECT SINGLE adrnr
          FROM t001w
          INTO lv_adrnr
          WHERE werks = is_likp-vstel.

        IF NOT lv_adrnr IS INITIAL.
          SELECT SINGLE addrnumber
              name1
             city1
             post_code1
             street
             str_suppl1
             str_suppl2
             location
             country
             region
             sort1
             mc_city1
             tel_number
            FROM adrc
            INTO es_dis_addr
            WHERE addrnumber EQ lv_adrnr.

          SELECT SINGLE legal_state_code FROM j_1istatecdm INTO es_dis_addr-region WHERE std_state_code EQ es_dis_addr-region .
          SELECT SINGLE bezei FROM t005u INTO es_dis_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ es_dis_addr-region .
        ENDIF.

      WHEN 'SHP'.
        SELECT SINGLE adrnr stcd3
          FROM kna1
          INTO ( lv_adrnr, lv_gstin )
          WHERE kunnr = is_likp-kunnr.

        IF NOT lv_adrnr IS INITIAL.
          SELECT SINGLE addrnumber
              name1
             city1
             post_code1
             street
             str_suppl1
             str_suppl2
             location
             country
             region
             sort1
             mc_city1
             tel_number
            FROM adrc
            INTO es_shp_addr
            WHERE addrnumber EQ lv_adrnr.

          SELECT SINGLE legal_state_code FROM j_1istatecdm INTO es_shp_addr-region WHERE std_state_code EQ es_shp_addr-region .
          SELECT SINGLE bezei FROM t005u INTO es_shp_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ es_shp_addr-region .
          es_shp_addr-gstin = lv_gstin.
        ENDIF.

      WHEN 'CMB'.
        SELECT SINGLE adrnr
          FROM t001w
          INTO lv_adrnr
          WHERE werks = is_likp-vstel.

        IF NOT lv_adrnr IS INITIAL.
          SELECT SINGLE addrnumber
             name1
             city1
             post_code1
             street
             str_suppl1
             str_suppl2
             location
             country
             region
             sort1
             mc_city1
             tel_number
            FROM adrc
            INTO es_dis_addr
            WHERE addrnumber EQ lv_adrnr.

          SELECT SINGLE legal_state_code FROM j_1istatecdm INTO es_dis_addr-region WHERE std_state_code EQ es_dis_addr-region .
          SELECT SINGLE bezei FROM t005u INTO es_dis_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ es_dis_addr-region .
        ENDIF.

        CLEAR lv_adrnr.

        SELECT SINGLE adrnr
          FROM kna1
          INTO lv_adrnr
          WHERE kunnr = is_likp-kunnr.

        IF NOT lv_adrnr IS INITIAL.
          SELECT SINGLE addrnumber
             name1
             city1
             post_code1
             street
             str_suppl1
             str_suppl2
             location
             country
             region
             sort1
             mc_city1
             tel_number
            FROM adrc
            INTO es_shp_addr
            WHERE addrnumber EQ lv_adrnr.

          SELECT SINGLE legal_state_code FROM j_1istatecdm INTO es_shp_addr-region WHERE std_state_code EQ es_shp_addr-region .
          SELECT SINGLE bezei FROM t005u INTO es_shp_addr-bezei WHERE land1 = 'IN' AND spras = sy-langu AND  bland EQ es_shp_addr-region .

        ENDIF.
    ENDCASE.
    CLEAR: lv_adrnr, lv_gstin.
  ENDMETHOD.


  METHOD json_schema_mapping.

    LOOP AT ct_json_in ASSIGNING FIELD-SYMBOL(<ls_json_in>).

      CASE <ls_json_in>-tabix.

      WHEN '1' OR '2' OR '3' OR '4' OR '05' OR'06'.
        REPLACE 'version'         IN <ls_json_in>-line WITH   '"Version"'.
        REPLACE 'irn'             IN <ls_json_in>-line WITH   '"Irn"'.
        "--TranDtls (Transaction Details)---------
        REPLACE 'trandtls'        IN <ls_json_in>-line WITH   '"TranDtls"'.
        REPLACE 'taxsch'          IN <ls_json_in>-line WITH   '"TaxSch"'.
        REPLACE 'suptyp'          IN <ls_json_in>-line WITH   '"SupTyp"'.
        REPLACE 'regrev'          IN <ls_json_in>-line WITH   '"RegRev"'.
        REPLACE 'ecmgstin'        IN <ls_json_in>-line WITH   '"EcmGstin"'.

      WHEN  '07' OR '08' OR '09'.
        "--DocDtls (Document Details)-----

        REPLACE 'zdocdtls'        IN <ls_json_in>-line WITH   '"DocDtls"'.
        REPLACE 'ztyp'            IN <ls_json_in>-line WITH   '"Typ"'.
        REPLACE 'zno'             IN <ls_json_in>-line WITH   '"No"'.
        REPLACE 'zdt'             IN <ls_json_in>-line WITH   '"Dt"'.

      WHEN  '10' OR  '11' OR '12' OR '13' OR '14' OR '15' OR '16' OR '17' OR '18' OR '19'.
        "--SellerDtls (Seller Details)------------------
        REPLACE 'sellerdtls'      IN <ls_json_in>-line WITH   '"SellerDtls"'.
        REPLACE 'gstin'           IN <ls_json_in>-line WITH   '"Gstin"'.
        REPLACE 'lglnm'           IN <ls_json_in>-line WITH   '"LglNm"'.
        REPLACE 'trdnm'           IN <ls_json_in>-line WITH   '"TrdNm"'.
        REPLACE 'addr1'           IN <ls_json_in>-line WITH   '"Addr1"'.
        REPLACE 'addr2'           IN <ls_json_in>-line WITH   '"Addr2"'.
        REPLACE 'zloc'             IN <ls_json_in>-line WITH   '"Loc"'.
        IF <ls_json_in>-tabix eq 16.
          REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
          REPLACE 'zpin'             IN <ls_json_in>-line WITH   '"Pin"'.
        ENDIF.

        REPLACE 'zstate'          IN <ls_json_in>-line WITH   '"Stcd"'.
        REPLACE 'zph'              IN <ls_json_in>-line WITH   '"Ph"'.
        REPLACE 'zem'             IN <ls_json_in>-line WITH   '"Em"'.
        REPLACE ALL OCCURRENCES OF '\' IN <ls_json_in>-line WITH ''.
        REPLACE ALL OCCURRENCES OF '&' IN <ls_json_in>-line WITH ''.
      WHEN '20' OR '21' OR '22' OR '23' OR '24' OR '25' OR '26' OR '27' OR '28' OR '29' OR '30'.
        "--BuyerDtls (Buyers Details)------
        REPLACE 'buyerdtls'       IN <ls_json_in>-line WITH   '"BuyerDtls"'.
        REPLACE 'gstin'           IN <ls_json_in>-line WITH   '"Gstin"'.
        REPLACE 'lglnm'           IN <ls_json_in>-line WITH   '"LglNm"'.
        REPLACE 'trdnm'           IN <ls_json_in>-line WITH   '"TrdNm"'.
        REPLACE 'zpos'             IN <ls_json_in>-line WITH   '"Pos"'.
        REPLACE 'addr1'           IN <ls_json_in>-line WITH   '"Addr1"'.
        REPLACE 'addr2'           IN <ls_json_in>-line WITH   '"Addr2"'.
        REPLACE 'zloc'             IN <ls_json_in>-line WITH   '"Loc"'.
        IF <ls_json_in>-tabix eq 27.
          REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
          REPLACE 'zpin'             IN <ls_json_in>-line WITH   '"Pin"'.
        ENDIF.
*        REPLACE 'pin'             IN <ls_json_in>-line WITH   '"Pin"'.
        REPLACE 'zstate'          IN <ls_json_in>-line WITH   '"Stcd"'.
        REPLACE 'zph'              IN <ls_json_in>-line WITH   '"Ph"'.
        REPLACE 'zem'             IN <ls_json_in>-line WITH   '"Em"'.
        REPLACE ALL OCCURRENCES OF '\' IN <ls_json_in>-line WITH ''.
        REPLACE ALL OCCURRENCES OF '&' IN <ls_json_in>-line WITH ''.

      WHEN   '31' OR '32' OR '33' OR '34' OR '35' OR '36' .
        "--DispDtls (Display Details)------------
        IF  is_update-dispdtls EQ abap_true.
          REPLACE 'dispdtls'        IN <ls_json_in>-line WITH   '"DispDtls"'.
          REPLACE 'znm'             IN <ls_json_in>-line WITH   '"Nm"'.
          REPLACE 'addr1'           IN <ls_json_in>-line WITH   '"Addr1"'.
          REPLACE 'addr2'           IN <ls_json_in>-line WITH   '"Addr2"'.
          REPLACE 'loc'             IN <ls_json_in>-line WITH   '"Loc"'.
          IF <ls_json_in>-tabix eq 35.
          REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
          REPLACE 'pin'             IN <ls_json_in>-line WITH   '"Pin"'.
          ENDIF.

          REPLACE 'stcd'            IN <ls_json_in>-line WITH   '"Stcd"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.

      WHEN  '37' OR '38' OR '39' OR '40' OR '41' OR '42' OR '43' OR'44'.
        IF is_update-shipdtls EQ abap_true.
          "--ShipDtls (Shipping Details)------------
          REPLACE 'shipdtls'        IN <ls_json_in>-line WITH   '"ShipDtls"'.
          REPLACE 'gstin'           IN <ls_json_in>-line WITH   '"Gstin"'.
          REPLACE 'lglnm'           IN <ls_json_in>-line WITH   '"LglNm"'.
          REPLACE 'trdnm'           IN <ls_json_in>-line WITH   '"TrdNm"'.
          REPLACE 'addr1'           IN <ls_json_in>-line WITH   '"Addr1"'.
          REPLACE 'addr2'           IN <ls_json_in>-line WITH   '"Addr2"'.
          REPLACE 'loc'             IN <ls_json_in>-line WITH   '"Loc"'.
          IF <ls_json_in>-tabix eq 43.
          REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
          REPLACE 'pin'             IN <ls_json_in>-line WITH   '"Pin"'.
          ENDIF.

          REPLACE 'stcd'            IN <ls_json_in>-line WITH   '"Stcd"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.

      WHEN '45' OR '46' OR'47' OR'48' OR '49' OR '50' OR '51' OR '52' OR'53'.
        "--ValDtls (Values Details)------------------
        REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
        REPLACE 'valdtls'         IN <ls_json_in>-line WITH   '"ValDtls"'.
        REPLACE 'assval'          IN <ls_json_in>-line WITH   '"AssVal"'.
        REPLACE 'cgstval'         IN <ls_json_in>-line WITH   '"CgstVal"'.
        REPLACE 'sgstval'         IN <ls_json_in>-line WITH   '"SgstVal"'.
        REPLACE 'igstval'         IN <ls_json_in>-line WITH   '"IgstVal"'.
        REPLACE 'zcesval'         IN <ls_json_in>-line WITH   '"CesVal"'.
        REPLACE 'stcesval'        IN <ls_json_in>-line WITH   '"StCesVal"'.
        REPLACE 'rndoffamt'       IN <ls_json_in>-line WITH   '"RndOffAmt"'.
        REPLACE 'ztotinvval'      IN <ls_json_in>-line WITH   '"TotInvVal"'.
        REPLACE 'totinvvalfc'     IN <ls_json_in>-line WITH   '"TotInvValFc"'.
*        REPLACE 'invforcur'     IN <ls_json_in>-line WITH   '"InvForCur"'.


      WHEN  '54' OR '55' OR '56' OR '57' OR '58' OR '59' OR '60' OR '61' OR '62' .
        "--PayDtls (Pay Details)---------------------
        IF is_update-paydtls EQ abap_true.
          REPLACE 'paydtls'         IN <ls_json_in>-line WITH   '"PayDtls"'.
          REPLACE 'znm'             IN <ls_json_in>-line WITH   '"Nm"'.
          REPLACE 'accdet'         IN <ls_json_in>-line WITH    '"AccDet"'.
          REPLACE 'modes'           IN <ls_json_in>-line WITH   '"Mode"'.
          REPLACE 'fininsbr'        IN <ls_json_in>-line WITH   '"FinInsBr"'.
          REPLACE 'payterm'         IN <ls_json_in>-line WITH   '"PayTerm"'.
          REPLACE 'payinstr'        IN <ls_json_in>-line WITH   '"PayInstr"'.
          REPLACE 'crtrn'           IN <ls_json_in>-line WITH   '"CrTrn"'.
          REPLACE 'dirdr'           IN <ls_json_in>-line WITH   '"DirDr"'.
          REPLACE 'crday'           IN <ls_json_in>-line WITH   '"CrDay"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.

      WHEN '63' OR '64' .
        IF is_update-paydtls EQ abap_true.
          REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
          REPLACE 'paidamt'         IN <ls_json_in>-line WITH   '"PaidAmt"'.
          REPLACE 'paymtdue'        IN <ls_json_in>-line WITH   '"PaymtDue"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.
      WHEN  '65' OR '66' OR '67' OR '68' OR '69' OR '70' OR '71' OR '72' OR '73' OR '74' OR '75' OR '76' OR '77' OR '78'  .
        IF is_update-refdtls EQ abap_true.
          "--RefDtls (Ref Details)----------------------
          REPLACE 'refdtls'         IN <ls_json_in>-line WITH   '"RefDtls"'.
          REPLACE 'invrm'           IN <ls_json_in>-line WITH   '"InvRm"'.
           "----DocPerdDtls-----------------------------------------------
          REPLACE 'docperddtls'     IN <ls_json_in>-line WITH   '"DocPerdDtls"'.
          REPLACE 'invstdt'         IN <ls_json_in>-line WITH   '"InvStDt"'.
          REPLACE 'invenddt'        IN <ls_json_in>-line WITH   '"InvEndDt"'.
          "--------------precdocdtls--------------------------------
          IF is_update-precdocdtls EQ abap_true.
            REPLACE 'precdocdtls'     IN <ls_json_in>-line WITH   '"PrecDocDtls"'.
            REPLACE 'invno'           IN <ls_json_in>-line WITH   '"InvNo"'.
            REPLACE 'invdt'           IN <ls_json_in>-line WITH   '"InvDt"'.
            REPLACE 'othrefno'        IN <ls_json_in>-line WITH   '"OthRefNo"'.
          ELSE.
            CLEAR <ls_json_in>-line.
            CONTINUE.
          ENDIF.
          "----------------contrdtls--------------------------------
          IF is_update-contrdtls EQ abap_true.
            REPLACE 'contrdtls'       IN <ls_json_in>-line WITH   '"ContrDtls"'.
            REPLACE 'recadvrefr'      IN <ls_json_in>-line WITH   '"RecAdvRefr"'.
            REPLACE 'recadvdt'        IN <ls_json_in>-line WITH   '"RecAdvDt"'.
            REPLACE 'tendrefr'        IN <ls_json_in>-line WITH   '"TendRefr"'.
            REPLACE 'contrrefr'       IN <ls_json_in>-line WITH   '"ContrRefr"'.
            REPLACE 'accdet'          IN <ls_json_in>-line WITH   '"AaccDet"'.
            REPLACE 'extrefr'         IN <ls_json_in>-line WITH   '"ExtRefr"'.
            REPLACE 'projrefr'        IN <ls_json_in>-line WITH   '"ProjRefr"'.
            REPLACE 'porefr'          IN <ls_json_in>-line WITH   '"PORefr"'.
            REPLACE 'porefdt'         IN <ls_json_in>-line WITH   '"PORefDt"'.
          ELSE.
            CLEAR <ls_json_in>-line.
            CONTINUE.
          ENDIF.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.
      WHEN  '79' OR '80' OR '81' OR '82' OR '83' OR '84' OR '85'.
        "---ExpDtls------------------------------------ ---
        IF is_update-expdtls EQ abap_true.
          REPLACE 'expdtls'         IN <ls_json_in>-line WITH   '"ExpDtls"'.
          REPLACE 'shipbno'         IN <ls_json_in>-line WITH   '"ShipBNo"'.
          REPLACE 'shipbdt'         IN <ls_json_in>-line WITH   '"ShipBDt"'.
          REPLACE 'port'            IN <ls_json_in>-line WITH   '"Port"'.
          REPLACE 'refclm'          IN <ls_json_in>-line WITH   '"RefClm"'.
          REPLACE 'forcur'          IN <ls_json_in>-line WITH   '"ForCur"'.
          REPLACE 'cntcode'         IN <ls_json_in>-line WITH   '"CntCode"'.
          IF <ls_json_in>-tabix eq 85.
          REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
          REPLACE 'expduty' IN <ls_json_in>-line WITH   '"ExpDuty"'.
          ENDIF.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.
      WHEN   '86' OR '87' OR '88' .
        "--Addldocdtls--------------------------------
        IF is_update-addldocdtls EQ abap_true.
          REPLACE 'addldocdtls'     IN <ls_json_in>-line WITH   '"AddlDocDtls"'.
          REPLACE 'url'             IN <ls_json_in>-line WITH   '"Url"'.
          REPLACE 'docs'            IN <ls_json_in>-line WITH   '"Docs"'.
          REPLACE 'infodtls'            IN <ls_json_in>-line WITH   '"Info"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.
      WHEN    '89' OR '90' OR '91' OR '92' OR '93' OR '94' OR '95' OR '96'  .
        "----Ewbdtls(E-way Bill)----------------------
        IF is_update-ewbdtls EQ abap_true.
          REPLACE 'ewbdtls'         IN <ls_json_in>-line WITH   '"EwbDtls"'.
          REPLACE 'transid'         IN <ls_json_in>-line WITH   '"TransId"'.
          REPLACE 'transname'       IN <ls_json_in>-line WITH   '"TransName"'.
          REPLACE 'transmode'       IN <ls_json_in>-line WITH   '"TransMode"'.
          IF <ls_json_in>-tabix eq 92.
          REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
          REPLACE 'distance'        IN <ls_json_in>-line WITH   '"Distance"'.
          ENDIF.
          REPLACE 'transdocno'      IN <ls_json_in>-line WITH   '"TransDocNo"'.
          REPLACE 'transdocdt'      IN <ls_json_in>-line WITH   '"TransDocDt"'.
          REPLACE 'vehno'           IN <ls_json_in>-line WITH   '"VehNo"'.
          REPLACE 'vehtype'         IN <ls_json_in>-line WITH   '"VehType"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.
      WHEN  '229' OR '230' OR '231' .

        "--bchdtl (Batch Details)------------------

        IF is_update-bchdtls EQ abap_true.
          REPLACE 'bchdtls'         IN <ls_json_in>-line WITH   '"BchDtls"'.
          REPLACE 'znm'             IN <ls_json_in>-line WITH   '"Nm"'.
          REPLACE 'zexpdt'          IN <ls_json_in>-line WITH   '"ExpDt"'.
          REPLACE 'wrdt'            IN <ls_json_in>-line WITH   '"WrDt"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.
      WHEN  '206' or '207' or '209' OR
          '210' OR '211' OR '212' OR '213' OR '214' OR '215' OR '216' OR '217' OR '218' OR
          '219' OR '220' OR '221' OR '222' OR '223' OR '224' OR '225'.
        REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
        REPLACE 'qnty'                IN <ls_json_in>-line WITH   '"Qty"'.
        REPLACE 'freeqty'             IN <ls_json_in>-line WITH   '"FreeQty"'.
        REPLACE 'unitprice'           IN <ls_json_in>-line WITH   '"UnitPrice"'.
        REPLACE 'totamt'              IN <ls_json_in>-line WITH   '"TotAmt"'.
        REPLACE 'discount'            IN <ls_json_in>-line WITH   '"Discount"'.
        REPLACE 'pretaxval'           IN <ls_json_in>-line WITH   '"PreTaxVal"'.
        REPLACE 'assamt'              IN <ls_json_in>-line WITH   '"AssAmt"'.
        REPLACE 'gstrt'               IN <ls_json_in>-line WITH   '"GstRt"'.
        REPLACE 'igstamt'             IN <ls_json_in>-line WITH   '"IgstAmt"'.
        REPLACE 'cgstamt'             IN <ls_json_in>-line WITH   '"CgstAmt"'.
        REPLACE 'sgstamt'             IN <ls_json_in>-line WITH   '"SgstAmt"'.
        REPLACE 'zcesrt'              IN <ls_json_in>-line WITH   '"CesRt"'.
        REPLACE 'zcesamt'             IN <ls_json_in>-line WITH   '"CesAmt"'.
        REPLACE 'zcesnonadvlamt'      IN <ls_json_in>-line WITH   '"CesNonAdvlAmt"'.
        REPLACE 'statecesrt'          IN <ls_json_in>-line WITH   '"StateCesRt"'.
        REPLACE 'statecesamt'         IN <ls_json_in>-line WITH   '"StateCesAmt"'.
        REPLACE 'statecesnonadvlamt'  IN <ls_json_in>-line WITH   '"StateCesNonAdvlAmt"'.
        REPLACE 'othchrg'             IN <ls_json_in>-line WITH   '"OthChrg"'.
        REPLACE 'totitemval'          IN <ls_json_in>-line WITH   '"TotItemVal"'.

*      WHEN  '201' OR '202' OR '203' OR '204' OR '205' OR '206' OR '207' OR '208' OR '209' OR
*            '210' OR '211' OR '212' OR '213' OR '214' OR '215' OR '216' OR '217' OR '218' OR
*            '219' OR '220' OR '221' OR '222' OR '223' OR '224' OR '225' OR '226' OR '227'.
      WHEN OTHERS.

        "--itemlist (Item Details)------------
        REPLACE 'itemlist'            IN <ls_json_in>-line WITH   '"ItemList"'.
        REPLACE 'zslno'               IN <ls_json_in>-line WITH   '"SlNo"'.
        REPLACE 'prddesc'             IN <ls_json_in>-line WITH   '"PrdDesc"'.
        REPLACE 'isservc'             IN <ls_json_in>-line WITH   '"IsServc"'.
        REPLACE 'hsncd'               IN <ls_json_in>-line WITH   '"HsnCd"'.
        REPLACE 'barcde'              IN <ls_json_in>-line WITH   '"Barcde"'.
*        REPLACE 'qnty'                IN <ls_json_in>-line WITH   '"Qty"'.
*        REPLACE 'freeqty'             IN <ls_json_in>-line WITH   '"FreeQty"'.
        REPLACE 'units'               IN <ls_json_in>-line WITH   '"Unit"'.

        REPLACE 'ordlineref'          IN <ls_json_in>-line WITH   '"OrdLineRef"'.
        REPLACE 'orgcntry'            IN <ls_json_in>-line WITH   '"OrgCntry"'.
        REPLACE 'prdslno'             IN <ls_json_in>-line WITH   '"PrdSlNo"'.
        REPLACE 'attribdtls'          IN <ls_json_in>-line WITH   '"AttribDtls"'.
        REPLACE 'znm'                 IN <ls_json_in>-line WITH   '"Nm"'.
        REPLACE 'zvalu'                IN <ls_json_in>-line WITH   '"Val"'.



    ENDCASE.
    IF <ls_json_in>-line IS NOT INITIAL.
      REPLACE '"null"'            IN <ls_json_in>-line WITH   'null'.
      APPEND <ls_json_in>-line TO  CT_json_out .
    ENDIF.
  ENDLOOP.

  ENDMETHOD.


  METHOD unit_convert.
    CASE iv_vrkme .
      WHEN 'BAG'.                  "BAG-BAGS"       "SAP UOM"
        ev_unit = 'BAG'.                               "IRP UOM"
      WHEN 'BAL'.                  "   BALE
        ev_unit = 'BAL'.
      WHEN 'BDL'.                  "   BUNDLES
        ev_unit = 'BDL'.
      WHEN 'BKL'.                  "   BUCKLES
        ev_unit ='BKL'.
      WHEN 'BOU'.                  "   BILLION OF ev_unitS
        ev_unit ='BOU'.
      WHEN 'BOX'.                  "   BOX
        ev_unit ='BOX'.
      WHEN 'BT'.                   "BT-BOTTLES"
        ev_unit ='BTL'.
      WHEN 'BHN'.                  "BHN-BUNCHES"
        ev_unit ='BUN'.
      WHEN 'CAN'.                  "CAN-CANS"
        ev_unit ='CAN'.
      WHEN 'M3'.                   "M3-CUBIC METERS"
        ev_unit ='CBM'.
      WHEN 'CCM'.                  "CCM-CUBIC CENTIMETERS"
        ev_unit ='CCM'.
      WHEN 'CM'.                   "CM-CENTIMETERS"
        ev_unit ='CMS'.
      WHEN 'CAR'.                  "CAR-CARTONS"
        ev_unit ='CTN'.
      WHEN 'DZ'.                   "DZ-DOZENS"
        ev_unit ='DOZ'.
      WHEN 'DR'.                   "DR-DRUMS"
        ev_unit ='DRM'.
      WHEN 'GGK'.                  "   GREAT GROSS
        ev_unit ='GGK'.
      WHEN 'G'.                    "G-GRAMMES"
        ev_unit ='GMS'.
      WHEN 'GRO'.                  "GRO-GROSS"
        ev_unit ='GRS'.
      WHEN 'GYD'.                  "    GROSS YARDS
        ev_unit ='GYD'.
      WHEN 'KG'.                   "KG  Kilogram
        ev_unit ='KGS'.
      WHEN 'KL'.                   "KL  KILOLITRE
        ev_unit ='KLR'.
      WHEN 'KM'.                   "KM  Kilometer
        ev_unit ='KME'.
      WHEN 'L'.                    "L	Liter
        ev_unit ='LTR'.
      WHEN 'M'.                    "M	Meter
        ev_unit ='MTR'.
      WHEN 'ML'.                   "ML  Milliliter
        ev_unit ='MLT'.
*    WHEN 'TO'.                   "TO  Tonne
*      ev_unit ='MTS'.
      WHEN 'EA'.                   "EA  each
        ev_unit ='NOS'.
      WHEN 'OTH'.                  "    OTHERS
        ev_unit ='OTH'.
      WHEN 'PAC'.                  "PAC	Pack
        ev_unit ='PAC'.
      WHEN 'ST'.                   "ST  items
        ev_unit ='PCS'.
      WHEN 'PAA'.                  "PAA	Pair
        ev_unit ='PRS'.
      WHEN 'QTL'.                  "   QUINTAL
        ev_unit ='QTL'.
      WHEN 'ROL'.                  "ROL	Role
        ev_unit ='ROL'.
      WHEN 'SET'.                  "SET	SET
        ev_unit ='SET'.
      WHEN 'FT2'.                  "FT2	Square foot
        ev_unit ='SQF'.
      WHEN 'M2'.                   "M2  Square meter
        ev_unit ='SQM'.
      WHEN 'YD2'.                  "YD2	Square Yard
        ev_unit ='SQY'.
      WHEN 'TBS'.                  "    TABLETS
        ev_unit ='TBS'.
      WHEN 'TGM'.                  "    TEN GROSS
        ev_unit ='TGM'.
      WHEN 'TS'.                   "TS  Thousands
        ev_unit ='THD'.
      WHEN 'TO'.                   "TO  Tonne
        ev_unit ='TON'.
      WHEN 'TUB'.                  "    TUBES
        ev_unit ='TUB'.
      WHEN 'GAL'.                  "GAL  US gallon
        ev_unit ='UGS'.
      WHEN 'AU'.                   "AU  Activity ev_unit
        ev_unit ='UNT'.
      WHEN 'YD'.                   "YD  Yards
        ev_unit ='YDS'.
      WHEN 'NOS'.                   "YD  Yards
        ev_unit ='NOS'.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
