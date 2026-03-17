FUNCTION zeinv_schema_map.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_UPDATE) TYPE  ZEINV_UPDATE OPTIONAL
*"  TABLES
*"      JSON_IN TYPE  ZEINV_JSON_TT
*"      JSON_OUT TYPE  ZEINV_JSON_TT
*"----------------------------------------------------------------------

  LOOP AT json_in ASSIGNING FIELD-SYMBOL(<ls_json_in>).
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
        IF  i_update-dispdtls EQ abap_true.
          REPLACE 'dispdtls'        IN <ls_json_in>-line WITH   '"DispDtls"'.
          REPLACE 'znm'             IN <ls_json_in>-line WITH   '"Nm"'.
          REPLACE 'addr1'           IN <ls_json_in>-line WITH   '"Addr1"'.
          REPLACE 'addr2'           IN <ls_json_in>-line WITH   '"Addr2"'.
          REPLACE 'zloc'             IN <ls_json_in>-line WITH   '"Loc"'.
          IF <ls_json_in>-tabix eq 35.
          REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
          REPLACE 'zpin'             IN <ls_json_in>-line WITH   '"Pin"'.
          ENDIF.

          REPLACE 'stcd'            IN <ls_json_in>-line WITH   '"Stcd"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.

      WHEN  '37' OR '38' OR '39' OR '40' OR '41' OR '42' OR '43' OR'44'.
        IF i_update-shipdtls EQ abap_true.
          "--ShipDtls (Shipping Details)------------
          REPLACE 'shipdtls'        IN <ls_json_in>-line WITH   '"ShipDtls"'.
          REPLACE 'gstin'           IN <ls_json_in>-line WITH   '"Gstin"'.
          REPLACE 'lglnm'           IN <ls_json_in>-line WITH   '"LglNm"'.
          REPLACE 'trdnm'           IN <ls_json_in>-line WITH   '"TrdNm"'.
          REPLACE 'addr1'           IN <ls_json_in>-line WITH   '"Addr1"'.
          REPLACE 'addr2'           IN <ls_json_in>-line WITH   '"Addr2"'.
          REPLACE 'zloc'             IN <ls_json_in>-line WITH   '"Loc"'.
          IF <ls_json_in>-tabix eq 43.
          REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
          REPLACE 'zpin'             IN <ls_json_in>-line WITH   '"Pin"'.
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
        IF i_update-paydtls EQ abap_true.
          REPLACE 'paydtls'         IN <ls_json_in>-line WITH   '"PayDtls"'.
          REPLACE 'znm'             IN <ls_json_in>-line WITH   '"Nm"'.
          REPLACE 'accdet'         IN <ls_json_in>-line WITH    '"AccDet"'.
          REPLACE 'modes'           IN <ls_json_in>-line WITH   '"Mode"'.
          REPLACE 'fininsbr'        IN <ls_json_in>-line WITH   '"FinInsBr"'.
          REPLACE 'payterm'         IN <ls_json_in>-line WITH   '"PayTerm"'.
          REPLACE 'payinstr'        IN <ls_json_in>-line WITH   '"PayInstr"'.
          REPLACE 'crtrn'           IN <ls_json_in>-line WITH   '"CrTrn"'.
          REPLACE 'dirdr'           IN <ls_json_in>-line WITH   '"DirDr"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.

      WHEN '62' OR '63' OR '64' .
        IF i_update-paydtls EQ abap_true.
          REPLACE ALL OCCURRENCES OF '"' IN <ls_json_in>-line WITH ''.
          REPLACE 'crday'           IN <ls_json_in>-line WITH   '"CrDay"'.
          REPLACE 'paidamt'         IN <ls_json_in>-line WITH   '"PaidAmt"'.
          REPLACE 'paymtdue'        IN <ls_json_in>-line WITH   '"PaymtDue"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.
      WHEN  '65' OR '66' OR '67' OR '68' OR '69' OR '70' OR '71' OR '72' OR '73' OR '74' OR '75' OR '76' OR '77' OR '78'  .
        IF i_update-refdtls EQ abap_true.
          "--RefDtls (Ref Details)----------------------
          REPLACE 'refdtls'         IN <ls_json_in>-line WITH   '"RefDtls"'.
          REPLACE 'invrm'           IN <ls_json_in>-line WITH   '"InvRm"'.
          "----DocPerdDtls-----------------------------------------------
          REPLACE 'docperddtls'     IN <ls_json_in>-line WITH   '"DocPerdDtls"'.
          REPLACE 'invstdt'         IN <ls_json_in>-line WITH   '"InvStDt"'.
          REPLACE 'invenddt'        IN <ls_json_in>-line WITH   '"InvEndDt"'.
          "--------------precdocdtls--------------------------------
          IF i_update-precdocdtls EQ abap_true.
            REPLACE 'precdocdtls'     IN <ls_json_in>-line WITH   '"PrecDocDtls"'.
            REPLACE 'invno'           IN <ls_json_in>-line WITH   '"InvNo"'.
            REPLACE 'invdt'           IN <ls_json_in>-line WITH   '"InvDt"'.
            REPLACE 'othrefno'        IN <ls_json_in>-line WITH   '"OthRefNo"'.
          ELSE.
            CLEAR <ls_json_in>-line.
            CONTINUE.
          ENDIF.
          "----------------contrdtls--------------------------------
          IF i_update-contrdtls EQ abap_true.
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
        IF i_update-expdtls EQ abap_true.
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
        IF i_update-addldocdtls EQ abap_true.
          REPLACE 'addldocdtls'     IN <ls_json_in>-line WITH   '"AddlDocDtls"'.
          REPLACE 'url'             IN <ls_json_in>-line WITH   '"Url"'.
          REPLACE 'docs'            IN <ls_json_in>-line WITH   '"Docs"'.
          REPLACE 'infodtls'        IN <ls_json_in>-line WITH   '"Info"'.
        ELSE.
          CLEAR <ls_json_in>-line.
          CONTINUE.
        ENDIF.
      WHEN    '89' OR '90' OR '91' OR '92' OR '93' OR '94' OR '95' OR '96'  .
        "----Ewbdtls(E-way Bill)----------------------
        IF i_update-ewbdtls EQ abap_true.
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

        IF i_update-bchdtls EQ abap_true.
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
        REPLACE 'valu'                IN <ls_json_in>-line WITH   '"Val"'.



    ENDCASE.
    IF <ls_json_in>-line IS NOT INITIAL.
      REPLACE '"null"'            IN <ls_json_in>-line WITH   'null'.
      REPLACE '"NULL"'            IN <ls_json_in>-line WITH   'null'.
      APPEND <ls_json_in>-line TO  json_out .
    ENDIF.
  ENDLOOP.



ENDFUNCTION.
