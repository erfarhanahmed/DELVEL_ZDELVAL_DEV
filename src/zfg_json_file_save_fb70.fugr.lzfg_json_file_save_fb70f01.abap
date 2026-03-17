*----------------------------------------------------------------------*
***INCLUDE LZFG_JSON_CONVERSIONF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_RETMSG  text
*      -->P_VBELN  text
*      -->P_GJAHR  text
*----------------------------------------------------------------------*
FORM get_data_all  TABLES lt_retmsg STRUCTURE bapiret2
                  USING belnr TYPE belnr_d
                        gjahr TYPE gjahr
                        lv_mode TYPE flag.

  REFRESH lt_final.



  DATA lc_belnr TYPE belnr_d.
  lc_belnr = belnr.
  DATA lv_date TYPE string .
*
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lc_belnr
    IMPORTING
      output = lc_belnr.



*  IF gjahr IS NOT INITIAL.


  SELECT bukrs
      belnr
      gjahr
      blart
      budat
      xblnr
      waers
      FROM bkpf
      INTO TABLE lt_bkpf
      WHERE belnr EQ lc_belnr
      AND gjahr EQ gjahr
      AND blart IN ( 'DR','DG' ).

  lt_bkpf_temp  = lt_bkpf.
  IF lt_bkpf_temp IS NOT INITIAL.

    SELECT bukrs
    belnr
    gjahr
    blart
    budat
    xblnr
    waers
    FROM bkpf
    INTO TABLE lt_bkpf_ref
    FOR ALL ENTRIES IN lt_bkpf_temp
    WHERE belnr EQ lt_bkpf_temp-xblnr
    AND bukrs  = lt_bkpf_temp-bukrs.

  ENDIF.


  IF lt_bkpf IS NOT INITIAL.

*    SELECT bukrs butxt land1 FROM t001  "replaced by class
*             INTO TABLE lt_t001
*             FOR ALL ENTRIES IN lt_bkpf
*             WHERE bukrs  = lt_bkpf-bukrs
*             AND spras = 'E'.

    SELECT
      bukrs belnr gjahr buzei zuonr FROM bseg INTO TABLE lt_bseg_ref
           FOR ALL ENTRIES IN lt_bkpf
      WHERE belnr = lt_bkpf-belnr AND
            gjahr  = lt_bkpf-gjahr AND
            buzei = '1'.

    IF lt_bseg_ref IS NOT INITIAL.

      READ TABLE lt_bseg_ref INTO ls_bseg_ref INDEX 1.
      IF sy-subrc IS INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_bseg_ref-zuonr
          IMPORTING
            output = ls_bseg_ref-zuonr.
      ENDIF.

      SELECT SINGLE vbeln fkdat FROM vbrk INTO ls_vbrk_ref
         WHERE vbeln = ls_bseg_ref-zuonr.

    ENDIF.



    SELECT bukrs belnr gjahr buzei
           buzid koart ktosl txgrp gsber
           kunnr matnr werks menge meins
           posn2 dmbtr wrbtr gvtyp sgtxt bupla hsn_sac
           FROM bseg
           INTO TABLE lt_bseg
           FOR ALL ENTRIES IN lt_bkpf
           WHERE belnr EQ lt_bkpf-belnr
           AND   bukrs EQ lt_bkpf-bukrs
           AND   gjahr EQ lt_bkpf-gjahr.

    IF lt_bseg IS NOT INITIAL AND sy-subrc EQ 0.

*    Bseg entries for customer
      lt_bseg_d  = lt_bseg.
      DELETE lt_bseg_d WHERE koart <> 'D'.

*      *    Bseg entries for Taxes
      lt_bseg_t = lt_bseg.
      DELETE lt_bseg_t WHERE buzid <> 'T'.

*      *      *    Bseg entries for material

      DELETE lt_bseg WHERE gvtyp <> 'X'  . "commented by kaumudini
      DESCRIBE TABLE lt_bseg LINES lv_itemcount.

*------------------------------------------------------------------------------*Added By PB 04.03.2022
    IF lt_bseg_d[] IS NOT INITIAL.

      SELECT KUNNR
             VKORG
             VTWEG
             SPART
             FROM knvv
             INTO TABLE lt_knvv
             FOR ALL ENTRIES IN lt_bseg_d
             WHERE kunnr = lt_bseg_d-kunnr.

    ENDIF.
*------------------------------------------------------------------------------*Added By PB 04.03.2022

      IF lt_bseg IS NOT INITIAL.

        SELECT *
        FROM bset
        INTO TABLE lt_bset
        FOR ALL ENTRIES IN lt_bseg
        WHERE belnr = lt_bseg-belnr
        AND bukrs = lt_bseg-bukrs
        AND gjahr = lt_bseg-gjahr.


*      SELECT *           "replaced by class
*              FROM j_1bbranch
*              INTO TABLE lt_j_1bbranch
*              FOR ALL ENTRIES IN lt_bseg
*              WHERE bukrs  EQ lt_bseg-bukrs
*              AND   branch EQ lt_bseg-gsber.
*
*      SELECT *
*             FROM t001w
*             INTO TABLE lt_t001w
*             FOR ALL ENTRIES IN lt_bseg
*             WHERE j_1bbranch EQ lt_bseg-gsber.
*
*      IF lt_t001w IS NOT INITIAL.
*
*        SELECT *
*               FROM adrc
*               INTO TABLE lt_adrc
*               FOR ALL ENTRIES IN lt_t001w
*               WHERE addrnumber EQ lt_t001w-adrnr.
*
*        IF lt_adrc IS NOT INITIAL.
*          SELECT *
*                 FROM t005u
*                 INTO TABLE lt_t005u
*                 FOR ALL ENTRIES IN lt_adrc
*                 WHERE spras = 'EN'
*                 AND land1 = lt_adrc-country
*                 AND bland = lt_adrc-region .
*
*        ENDIF.
*
*
*      ENDIF.
*      IF lt_bseg_d IS NOT INITIAL.
*        SELECT *
*               FROM kna1
*               INTO TABLE lt_kna1
*               FOR ALL ENTRIES IN lt_bseg_d
*               WHERE kunnr EQ lt_bseg_d-kunnr.
*      ENDIF.
*
*
*
*
*      IF lt_kna1 IS NOT INITIAL.
*
*        SELECT *
*        FROM t005u APPENDING TABLE lt_t005u
*        FOR ALL ENTRIES IN lt_kna1
*        WHERE spras = 'EN'
*        AND land1 = lt_kna1-land1
*        AND bland = lt_kna1-regio .
*
*        SELECT  *
*        FROM adrc
*        APPENDING TABLE lt_adrc
*        FOR ALL ENTRIES IN lt_kna1
*        WHERE addrnumber EQ lt_kna1-adrnr.
*
*      ENDIF.      "replaced by class

        SELECT *
               FROM marc
               INTO TABLE lt_marc
               FOR ALL ENTRIES IN lt_bseg
               WHERE matnr EQ lt_bseg-matnr AND
                     werks EQ lt_bseg-werks.
        SELECT *
               FROM makt
               INTO TABLE lt_makt
               FOR ALL ENTRIES IN lt_bseg
               WHERE matnr EQ lt_bseg-matnr.

      ENDIF.

*    IF lt_t005u IS NOT INITIAL.     "replaced by class
*      SELECT * FROM j_1istatecdm
*               INTO TABLE lt_j_1istatecdm
*               FOR ALL ENTRIES IN lt_t005u
*               WHERE land1  = lt_t005u-land1
*               AND std_state_code = lt_t005u-bland.
*
*    ENDIF.

*    IF lt_adrc IS NOT INITIAL.
*
*      SELECT * FROM adr2
*                INTO TABLE lt_adr2
*                FOR ALL ENTRIES IN lt_adrc
*                WHERE addrnumber = lt_adrc-addrnumber.
*
*      SELECT * FROM adr6
*               INTO TABLE lt_adr6
*               FOR ALL ENTRIES IN lt_adrc
*               WHERE addrnumber = lt_adrc-addrnumber.   "replaced by class
*    ENDIF.


    ELSE.
      ls_retmsg-id = 'E'.
      ls_retmsg-message = 'No Data Available'.
      lv_error = 'X'.

      APPEND ls_retmsg TO lt_retmsg.
      CLEAR ls_retmsg.
      MESSAGE 'No item data Available' TYPE 'E'.
      EXIT.
      LEAVE LIST-PROCESSING.

    ENDIF.

  ELSE.

    ls_retmsg-id = 'E'.
    ls_retmsg-message = 'No Data Available'.
    lv_error = 'X'.
    APPEND ls_retmsg TO lt_retmsg.
    CLEAR ls_retmsg.
    EXIT.
    LEAVE LIST-PROCESSING.

  ENDIF.
  "=================================================Read Data==========================================="
*
  LOOP AT lt_bkpf INTO ls_bkpf.


    "--INR Details

    ls_final-version = lc_version.
    ls_final-irn = ''.

*trandtls
    "--TranDtls (Transaction Details)---------

    ls_final-trandtls-taxsch = lc_taxsch.
*    ls_final-trandtls-suptyp = lc_catg.
    ls_final-trandtls-regrev =  'N'.
    ls_final-trandtls-ecmgstin = lc_null.           "'N'.

    "--DocDtls (Document Details)-----
*ztyp
    IF ls_bkpf-blart = 'DG'.
      ls_final-zdocdtls-ztyp = lc_doctyp_cr.
    ELSE.
      ls_final-zdocdtls-ztyp = lc_doctyp_dr.
    ENDIF.

*zno
    IF lv_mode = 'M'.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = ls_bkpf-xblnr
        IMPORTING
          output = ls_final-zdocdtls-zno.

*    ls_final-zdocdtls-zno = ls_bkpf-xblnr.


    ELSE.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = ls_bkpf-xblnr "ls_bkpf-belnr
        IMPORTING
          output = ls_final-zdocdtls-zno.

    ENDIF.

*zdt
*    CONCATENATE ls_bkpf-budat+6(02) '/' ls_bkpf-budat+4(02) '/' ls_bkpf-budat(04)   INTO ls_final-zdocdtls-zdt.
    CONCATENATE ls_bkpf-budat+6(02) '/' ls_bkpf-budat+4(02) '/' ls_bkpf-budat(04) INTO lv_date.      " ADDED BY SR ON 16.04.2021
*    CONCATENATE sy-datum+6(02) '/' sy-datum+4(02) '/' sy-datum(04)  INTO lv_date. " ??????????????????????????????   COMMENTED BY SR ON 16.04.2021
    ls_final-zdocdtls-zdt = lv_date.

* Get seller and buyer address details
    READ TABLE lt_bseg_d INTO ls_bseg_d  WITH KEY belnr = ls_bkpf-belnr gjahr = ls_bkpf-gjahr.

    READ TABLE lt_bseg INTO ls_bseg WITH KEY belnr = ls_bkpf-belnr gjahr = ls_bkpf-gjahr.

    IF sy-subrc EQ 0.

      CALL METHOD go_einvoice_utility->get_adrc_data
        EXPORTING
          iv_werks    = ls_bseg_d-bupla                    "ls_bseg-bupla "Commented By Nilay B on 27.01.2023 "ls_bseg-werks
          iv_kunnr    = ls_bseg_d-kunnr
*         is_likp     =
*         iv_invtyp   =
          iv_bukrs    = ls_bkpf-bukrs
          iv_bupla    = ls_bseg-bupla
        CHANGING
          es_sel_addr = ls_sel_addr
          es_dis_addr = ls_dis_addr
          es_buy_addr = ls_buy_addr
          es_shp_addr = ls_shp_addr.

    ENDIF.
*Sellerdtls
*    gstin

    ls_final-sellerdtls-gstin =  ls_sel_addr-gstin . "'29AFQPB8708K000'."  .   "'24AAAPI3182M002'

*lglnm
    ls_final-sellerdtls-lglnm = ls_sel_addr-butxt.
* trdnm
    ls_final-sellerdtls-trdnm =  ls_sel_addr-name1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final-sellerdtls-trdnm WITH ''.
* addr1
    ls_final-sellerdtls-addr1 = ls_sel_addr-str_suppl1.                                        "ls_adrc-street.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final-sellerdtls-addr1 WITH ''.
*  addr2
    ls_final-sellerdtls-addr2 = ls_sel_addr-str_suppl2.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final-sellerdtls-addr2 WITH ''.

    IF ls_final-sellerdtls-addr2 IS INITIAL.
      ls_final-sellerdtls-addr2 = lc_null.
    ENDIF.

* loc
    ls_final-sellerdtls-zloc = ls_sel_addr-mc_city1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final-sellerdtls-zloc WITH ''.
    IF ls_final-sellerdtls-zloc IS INITIAL.
      ls_final-sellerdtls-zloc = lc_null.
    ENDIF.

* pin
    ls_final-sellerdtls-zpin =  ls_sel_addr-post_code1. "'560001'."
* stcd
    ls_final-sellerdtls-zstate = ls_sel_addr-region.  "'29'. "
*  Ph


    IF ls_final-sellerdtls-zph IS INITIAL.
      ls_final-sellerdtls-zph = lc_null.
    ELSE.
      ls_final-sellerdtls-zph = lc_null."ls_sel_addr-tel_number.
    ENDIF.
* Email
    IF ls_sel_addr-smtp_addr IS INITIAL.
      ls_final-sellerdtls-zem = lc_null.
    ELSE.
      ls_final-sellerdtls-zem = lc_null."ls_sel_addr-smtp_addr.
    ENDIF.

    CLEAR ls_bseg.
*
*      ***********************************************************
    "--ValDtls (Values Details)------------------
***********************************************************
    ls_final-valdtls-assval       = ''.
    ls_final-valdtls-cgstval      = ''.
    ls_final-valdtls-sgstval      = ''.
    ls_final-valdtls-igstval      = ''.
    ls_final-valdtls-zcesval      = ''.
    ls_final-valdtls-stcesval     = ''.
    ls_final-valdtls-rndoffamt    = ''.
    ls_final-valdtls-ztotinvval   = ''.
    ls_final-valdtls-totinvvalfc  = ''.
*      ls_update-valdtls = 'X'.


    "--BuyerDtls (Buyers Details)------
*gstin

    ls_final-buyerdtls-gstin = ls_buy_addr-gstin.
    IF ls_final-buyerdtls-gstin IS INITIAL.
*      ls_final-buyerdtls-gstin  = '27AAAPI3182M002'.
    ENDIF.

    IF ls_buy_addr-country  NE 'IN'.           "Added By SR On 12.04.2021.
        ls_final-buyerdtls-gstin   = 'URP'..
    ENDIF.
"""""*trandtls SupTyp for export                "added by SR on 12.04.2021
    IF ls_buy_addr-country  NE 'IN'.

      CLEAR gv_buzid.
      SELECT SINGLE BUZID FROM BSEG INTO GV_BUZID
      WHERE BELNR = LS_BKPF-BELNR AND
      BUKRS = LS_BKPF-BUKRS AND
      GJAHR = LS_BKPF-GJAHR AND
      BUZID = 'T'.

      IF GV_BUZID IS NOT INITIAL.
        ls_final-trandtls-suptyp = 'EXPWP'.
      ELSE.
        ls_final-trandtls-suptyp = 'EXPWOP'.
      ENDIF.

    ENDIF.
*lglnm
    ls_final-buyerdtls-lglnm = ls_buy_addr-name1.
*trdnm
    ls_final-buyerdtls-trdnm = ls_buy_addr-name1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-trdnm WITH ''.
* pos
    ls_final-buyerdtls-zpos = ls_buy_addr-region.
    IF ls_buy_addr-COUNTRY  NE 'IN'.           "Added By SR On 12.04.2021.
      ls_final-buyerdtls-zpos = '96'.
    ENDIF.
* addr1
*********    Avinash Bhagat
    data : wa_adrc type adrc.
    clear wa_adrc.
    if ls_buy_addr-str_suppl1 is initial.
      select * from adrc into  wa_adrc WHERE ADDRNUMBER = ls_buy_addr-ADDRNUMBER.
        ENDSELECT.

        ls_final-buyerdtls-addr1 = wa_adrc-str_suppl2.
        REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-addr1 WITH ''.

         ls_final-buyerdtls-addr2 =  wa_adrc-str_suppl3.
        REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-addr2 WITH ''.



*****    End Of Avinash
        elseif ls_buy_addr-str_suppl1 is not INITIAL.
    ls_final-buyerdtls-addr1 = ls_buy_addr-str_suppl1.       "ls_adrc-street.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-addr1 WITH ''.
* addr2
    IF ls_buy_addr-str_suppl2 IS INITIAL.
      ls_final-buyerdtls-addr2 =  lc_null.
    ELSE.
      ls_final-buyerdtls-addr2 =  ls_buy_addr-str_suppl2.                  "addr2_buyer.
    ENDIF.

    REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-addr2 WITH ''.
endif.

*loc
    ls_final-buyerdtls-zloc =   ls_buy_addr-city1.                 " 'ABC' ."ls_adrc_re-city1.
    REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-zloc WITH ''.
* pin
    ls_final-buyerdtls-zpin = ls_buy_addr-post_code1.

     IF ls_buy_addr-COUNTRY  NE 'IN'.                "Added By SR On 12.04.2021.
      ls_final-buyerdtls-zpin      = '999999'.
     ENDIF.
* state

    ls_final-buyerdtls-zstate = ls_buy_addr-region.
    IF ls_buy_addr-COUNTRY  NE 'IN'.        "Added By SR On 12.04.2021.
      ls_final-buyerdtls-zstate   = '96'.   "State Code Shuold be 96 for export case
    ENDIF.
* Ph

    IF ls_final-buyerdtls-zph IS INITIAL.
      ls_final-buyerdtls-zph = lc_null.
    ELSE.
      ls_final-buyerdtls-zph = lc_null."ls_buy_addr-tel_number.
    ENDIF.

*Email
    IF ls_buy_addr-smtp_addr IS INITIAL.
      ls_final-buyerdtls-zem = lc_null.
    ELSE.
      ls_final-buyerdtls-zem = lc_null."ls_buy_addr-smtp_addr.
    ENDIF.


*   ItemList

    LOOP AT lt_bseg INTO ls_bseg WHERE belnr  = ls_bkpf-belnr AND gjahr = ls_bkpf-gjahr.
*slno
      ls_itemlist-zslno = ls_bseg-buzei.
*        isservc
      IF ls_bseg-hsn_sac+0(1) = '4' OR ls_bseg-hsn_sac+0(2) = '99'. .
        ls_itemlist-isservc  = 'Y'.
      ELSE.
        ls_itemlist-isservc  = 'N'.
      ENDIF.
*     prddesc

      IF ls_bseg-matnr IS INITIAL.
        ls_itemlist-prddesc = ls_bseg-sgtxt.
*        ls_itemlist-hsncd = ls_bseg-hsn_sac(04)."commented by jyoti on 11.06.2024
        ls_itemlist-hsncd = ls_bseg-hsn_sac(08). "HSN code 8 digit added by Jyoti on 11.06.2024

      ELSE.

        READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_bseg-matnr.
        IF sy-subrc  = 0.
          REPLACE ALL OCCURRENCES OF '&' IN ls_makt-maktx WITH ''.
          ls_itemlist-prddesc = ls_makt-maktx.
        ENDIF.

*hsncd

        READ TABLE lt_marc INTO ls_marc WITH KEY matnr = ls_bseg-matnr werks = ls_bseg-werks.
        IF sy-subrc EQ 0.
*          ls_itemlist-hsncd = ls_marc-steuc(06).     " '23099010'.HSN code 6 digit added by Nilay on 15.1.2023
          ls_itemlist-hsncd = ls_marc-steuc(08).     " '23099010'.HSN code 8 digit added by Jyoti on 11.06.2024

        ENDIF.
      ENDIF.

*Qty
      ls_itemlist-qnty = ls_bseg-menge.
      CONDENSE  ls_itemlist-qnty.
      ls_itemlist-barcde               =   lc_null.
*   freeqty

      ls_itemlist-freeqty = '0' ."ls_bseg-menge.
      CONDENSE  ls_itemlist-freeqty.


*barcde
      ls_itemlist-barcde               =   lc_null.
*Unit
      IF ls_bseg-menge IS INITIAL.
          ls_bseg-meins = 'OTH'.
      ENDIF.

      IF ls_bseg-meins IS INITIAL.
        ls_itemlist-units = lc_null.
      ELSE.

        CALL METHOD go_einvoice_utility->unit_convert
          EXPORTING
            iv_vrkme = ls_bseg-meins
          IMPORTING
            ev_unit  = ls_itemlist-units.

      ENDIF.

*unitprice

      IF ls_bseg-menge IS INITIAL.
        IF ls_buy_addr-COUNTRY  = 'IN'.           "Added By SR On 12.04.2021.
        ls_itemlist-unitprice = ls_bseg-wrbtr .           "'null'.
        ELSE.
         ls_itemlist-unitprice = ls_bseg-dmbtr .           "'null'.
        ENDIF.
      ELSE.
        IF ls_buy_addr-COUNTRY  = 'IN'.
        ls_itemlist-unitprice = ls_bseg-wrbtr / ls_bseg-menge.            "'null'.
        ELSE.
        ls_itemlist-unitprice = ls_bseg-dmbtr / ls_bseg-menge.
        ENDIF.
      ENDIF.

*valdtls-assval
      IF ls_buy_addr-COUNTRY  = 'IN'.               "Added By SR On 12.04.2021.
      ls_final-valdtls-assval = ls_final-valdtls-assval + ls_bseg-wrbtr.
      ELSE.
        ls_final-valdtls-assval = ls_final-valdtls-assval + ls_bseg-dmbtr.
      ENDIF.
* totamt
      IF ls_buy_addr-COUNTRY = 'IN'.           "Added By SR On 12.04.2021.
      ls_itemlist-totamt = ls_bseg-wrbtr.
      ELSE.
        ls_itemlist-totamt = ls_bseg-dmbtr.
      ENDIF.
*    discount
      ls_itemlist-discount =   '0.00'.
* pretaxval
      ls_itemlist-pretaxval            ='0.00'.
*   assamt
      IF ls_buy_addr-COUNTRY = 'IN'.           "Added By SR On 12.04.2021.
      ls_itemlist-assamt = ls_bseg-wrbtr.
      ELSE.
        ls_itemlist-assamt = ls_bseg-dmbtr.
      ENDIF.

      ls_itemlist-totitemval = ls_itemlist-assamt.
      LOOP AT lt_bset INTO ls_bset WHERE belnr = ls_bseg-belnr AND gjahr = ls_bseg-gjahr AND txgrp = ls_bseg-txgrp.
        CASE ls_bset-kschl.
          WHEN 'JOCG' .
*   gstrt
            ls_itemlist-gstrt =   ls_itemlist-gstrt + ( ls_bset-kbetr / 10 ).
*            cgstamt
            IF ls_buy_addr-COUNTRY  = 'IN'.
            ls_itemlist-cgstamt =   ls_bset-fwste.
            ELSE.
             ls_itemlist-cgstamt =   ls_bset-hwste.
            ENDIF.
*             cgstval
            IF ls_buy_addr-COUNTRY  = 'IN'.
            lv_cgstval = lv_cgstval + ls_bset-fwste.
            ELSE.
              lv_cgstval = lv_cgstval + ls_bset-hwste.
            ENDIF.
*            totitemval
            IF ls_buy_addr-COUNTRY  = 'IN'.
            ls_itemlist-totitemval = ls_itemlist-totitemval + ls_bset-fwste.
            ELSE.
             ls_itemlist-totitemval = ls_itemlist-totitemval + ls_bset-hwste.
            ENDIF.

          WHEN 'JOSG'.
*     gstrt
            ls_itemlist-gstrt =   ls_itemlist-gstrt + ( ls_bset-kbetr / 10 ).
*     sgstamt
            IF ls_buy_addr-COUNTRY  = 'IN'.
            ls_itemlist-sgstamt =   ls_bset-fwste.
            ELSE.
             ls_itemlist-sgstamt =   ls_bset-hwste.
            ENDIF.
*     sgstval
            IF ls_buy_addr-COUNTRY  = 'IN'.
            lv_sgstval = lv_sgstval + ls_bset-fwste.
            ELSE.
             lv_sgstval = lv_sgstval + ls_bset-hwste.
            ENDIF.
*     totitemval
            IF ls_buy_addr-COUNTRY  = 'IN'.
            ls_itemlist-totitemval = ls_itemlist-totitemval + ls_bset-fwste.
            ELSE.
              ls_itemlist-totitemval = ls_itemlist-totitemval + ls_bset-hwste.
            ENDIF.
          WHEN  'JOIG' .
*       gstrt
            ls_itemlist-gstrt =   ls_itemlist-gstrt + ( ls_bset-kbetr / 10 ).
*            igstamt
            IF ls_buy_addr-COUNTRY  = 'IN'.
            ls_itemlist-igstamt =   ls_bset-fwste.
            ELSE.
              ls_itemlist-igstamt =   ls_bset-hwste.
            ENDIF.
*            igstval
            IF ls_buy_addr-COUNTRY  = 'IN'.
            lv_igstval = lv_igstval + ls_bset-fwste.
            ELSE.
              lv_igstval = lv_igstval + ls_bset-hwste.
             ENDIF.
*          totitemval
            IF ls_buy_addr-COUNTRY  = 'IN'.
            ls_itemlist-totitemval = ls_itemlist-totitemval + ls_bset-fwste.
            ELSE.
              ls_itemlist-totitemval = ls_itemlist-totitemval + ls_bset-hwste.
            ENDIF.
          WHEN 'JTC1'.
            ls_itemlist-othchrg =   ls_bset-fwste.
            IF ls_buy_addr-COUNTRY  = 'IN'.
            ls_itemlist-totitemval = ls_itemlist-totitemval + ls_bset-fwste.
            ELSE.
              ls_itemlist-totitemval = ls_itemlist-totitemval + ls_bset-hwste.
            ENDIF.
        ENDCASE.
        CLEAR : ls_bset.
      ENDLOOP.


*      ls_itemlist-totitemval = ls_itemlist-assamt + ls_itemlist-camt + ls_itemlist-samt + ls_itemlist-iamt.
      lv_invtotal = lv_invtotal + ls_itemlist-totitemval.
      AT END OF belnr.
        ls_final-valdtls-cgstval = lv_cgstval.
        ls_final-valdtls-sgstval = lv_sgstval.
        ls_final-valdtls-igstval = lv_igstval.

*******        Avinash Bhagat

*if ls_bkpf-fkart = 'ZEXP'.
*if ls_final-valdtls-igstval is not INITIAL.
*  ls_final-trandtls-suptyp = 'EXPWP'.
*  ELSEIF ls_final-valdtls-igstval is INITIAL.
*  ls_final-trandtls-suptyp = 'EXPWOP'.
*  endif.
*  endif.

*********        End Avinash Bhagat
        ls_final-valdtls-zcesval = ''.
        ls_final-valdtls-stcesval = ''.
        ls_final-valdtls-rndoffamt = ''.
        ls_final-valdtls-ztotinvval = lv_invtotal .
        ls_final-valdtls-totinvvalfc  = ''.

        CLEAR : lv_cgstval,lv_sgstval,lv_igstval,lv_invtotal.
      ENDAT.

      IF ls_itemlist-discount IS NOT INITIAL.
        ls_itemlist-discount = ls_itemlist-discount * -1.
      ENDIF.

      ls_itemlist-zcesrt               = '0.00'.
      ls_itemlist-zcesamt              = '0.00'.
      ls_itemlist-zcesnonadvlamt       = '0.00'.
      ls_itemlist-statecesrt           = '0.00'.
      ls_itemlist-statecesamt          = '0.00'.
      ls_itemlist-statecesnonadvlamt   = '0.00'.

      ls_itemlist-ordlineref    =  '0.00'.
      ls_itemlist-orgcntry      =  lc_null.
      ls_itemlist-prdslno       =  lc_null.

      "--bchdtl (Batch Details)------------------
***********************************************************
      ls_itemlist-bchdtls-znm          = ''.
      ls_itemlist-bchdtls-zexpdt       = lc_null.
      ls_itemlist-bchdtls-wrdt         = lc_null.

********************** attribdtls***********************
      ls_attribdtls-znm         =  lc_null.
      ls_attribdtls-zvalu        =  lc_null.

      APPEND ls_attribdtls TO lt_attribdtls.
      ls_itemlist-attribdtls  = lt_attribdtls.

      APPEND ls_itemlist TO lt_itemlist.
      CLEAR : ls_itemlist,ls_marc,ls_makt,ls_attribdtls.
      REFRESH : lt_attribdtls.
    ENDLOOP.

    ls_final-itemlist = lt_itemlist.
    REFRESH: lt_itemlist.
*    ***********************************************************
    "--RefDtls (Ref Details)----------------------
***********************************************************

    DATA :
      lv_curry    TYPE vbrk-gjahr,
      lv_fy(4)    TYPE c,
      lv_periv    TYPE periv VALUE 'V3',
      lv_invstdt  TYPE sy-datum,
      lv_invenddt TYPE sy-datum.


    CALL FUNCTION 'GM_GET_FISCAL_YEAR'
      EXPORTING
        i_date                     = ls_bkpf-budat
        i_fyv                      = lv_periv
      IMPORTING
        e_fy                       = lv_fy
      EXCEPTIONS
        fiscal_year_does_not_exist = 1
        not_defined_for_date       = 2
        OTHERS                     = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    MOVE lv_fy TO lv_curry.

    CALL FUNCTION 'FIRST_AND_LAST_DAY_IN_YEAR_GET'
      EXPORTING
        i_gjahr        = lv_curry
        i_periv        = lv_periv
      IMPORTING
        e_first_day    = lv_invstdt
        e_last_day     = lv_invenddt
      EXCEPTIONS
        input_false    = 1
        t009_notfound  = 2
        t009b_notfound = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CONCATENATE lv_invstdt+6(02) '/' lv_invstdt+4(02) '/' lv_invstdt(04)  INTO ls_final-refdtls-docperddtls-invstdt.
    CONCATENATE lv_invenddt+6(02) '/' lv_invenddt+4(02) '/' lv_invenddt(04)  INTO ls_final-refdtls-docperddtls-invenddt.


    ls_final-refdtls-invrm        = lc_null.


    READ TABLE lt_bseg_ref INTO ls_bseg_ref WITH KEY belnr  = ls_bkpf-belnr gjahr = ls_bkpf-gjahr.

    IF sy-subrc IS INITIAL.
      ls_precdocdtls-invno = ls_bseg_ref-belnr ."ls_bseg_ref-zuonr.
*      IF ls_vbrk_ref IS NOT INITIAL.
*        CONCATENATE ls_vbrk_ref-fkdat+6(02) '/' ls_vbrk_ref-fkdat+4(02) '/' ls_vbrk_ref-fkdat(04)  INTO ls_precdocdtls-invdt.
*      ELSE.
*        CONCATENATE sy-datum+6(02) '/' sy-datum+4(02) '/' sy-datum(04)  INTO ls_precdocdtls-invdt.
*      ENDIF.
       CONCATENATE ls_bkpf-budat+6(02) '/' ls_bkpf-budat+4(02) '/' ls_bkpf-budat(04) INTO ls_precdocdtls-invdt.      " ADDED BY SR ON 16.04.2021
    ENDIF.
    ls_precdocdtls-othrefno       = lc_null.

*------------------------------------------------------------------------------*Added By PB 04.03.2022
    LOOP AT lt_knvv INTO ls_knvv.

      IF ls_knvv-vtweg = 10.
         ls_final-trandtls-suptyp = lc_catg.
      ENDIF.

    IF ls_knvv-vtweg = 20.
      If ls_final-valdtls-cgstval = 0 AND
         ls_final-valdtls-sgstval = 0 AND
         ls_final-valdtls-igstval <> 0.
         ls_final-trandtls-suptyp = lc_catg_wp.
      ELSEIF ls_final-valdtls-cgstval = 0 AND
             ls_final-valdtls-sgstval = 0 AND
             ls_final-valdtls-igstval = 0.
         ls_final-trandtls-suptyp = lc_catg_wop.
      ENDIF.
    ENDIF.

    ENDLOOP.

*------------------------------------------------------------------------------*Added By PB 04.03.2022

    ls_contrdtls-recadvrefr       = lc_null.
    ls_contrdtls-recadvdt         = lc_null.
    ls_contrdtls-tendrefr         = lc_null.
    ls_contrdtls-contrrefr        = lc_null.
    ls_contrdtls-extrefr          = lc_null.
    ls_contrdtls-projrefr         = lc_null.
    ls_contrdtls-porefr           = lc_null.
    ls_contrdtls-porefdt          = lc_null.

    APPEND ls_contrdtls TO lt_contrdtls.
    ls_final-refdtls-contrdtls  = lt_contrdtls.
    APPEND ls_precdocdtls TO lt_precdocdtls.
    ls_final-refdtls-precdocdtls  = lt_precdocdtls.

    CLEAR: lt_precdocdtls,lt_contrdtls,ls_contrdtls,ls_precdocdtls.

    APPEND ls_final TO lt_final.

    CLEAR : ls_bkpf,ls_bseg_d,ls_j_1bbranch,ls_t001w,ls_adrc,ls_bseg_ref,ls_vbrk_ref.
    REFRESH: lt_itemlist.
  ENDLOOP.
  CLEAR : ls_sel_addr,ls_dis_addr,ls_dis_addr,ls_shp_addr.

  it_final = lt_final.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  JSON_CONVERSION_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FILE_LOC  text
*      <--P_STATUS  text
*----------------------------------------------------------------------*
FORM json_conversion_all  TABLES lt_jsonfile STRUCTURE zstr_jsonfile USING file_loc TYPE rlgrap-filename belnr TYPE belnr_d lv_mode TYPE flag
                                                                                          CHANGING status TYPE string.

  DATA:  lv_json   TYPE string.
  DATA : o_writer_itab TYPE REF TO cl_sxml_string_writer.
  DATA: lv_result TYPE string.
  DATA : o_trex TYPE REF TO cl_trex_json_serializer.

  IF lv_error = ' '.
    IF lv_mode = 'M'.


*    * serialize table lt_fINAL into JSON, skipping initial fields and converting ABAP field names into camelCase
      lv_json = /ui2/cl_json=>serialize( data = lt_final compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

      " Display JSON in ABAP
*    CALL TRANSFORMATION sjson2html SOURCE XML lv_json
*                               RESULT XML DATA(lvc_html).
**  cl_abap_browser=>show_html( title = 'ABAP (iTab) -> JSON: /ui2/cl_json=>serialize' html_string = cl_abap_codepage=>convert_from( lvc_html ) ).

      CLEAR lt_final.
      CLEAR: ls_final-itemlist ,ls_final-refdtls-contrdtls,ls_final-refdtls-precdocdtls.

* deserialize JSON string json into internal table lxt_final doing camelCase to ABAP like field name mapping
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = lt_final ).



      o_writer_itab = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
      CALL TRANSFORMATION id SOURCE values = lt_final RESULT XML o_writer_itab.

      cl_abap_conv_in_ce=>create( )->convert( EXPORTING
                                                input = o_writer_itab->get_output( )
                                              IMPORTING
                                                data = lv_result ).

* JSON -> ABAP (iTab)
      CLEAR lt_final.
      CLEAR: ls_final-itemlist ,ls_final-refdtls-contrdtls,ls_final-refdtls-precdocdtls.

      CALL TRANSFORMATION id SOURCE XML lv_result RESULT values = lt_final.

* ABAP (iTab) -> JSON (trex)
      o_trex = NEW cl_trex_json_serializer( lt_final ).
      o_trex->serialize( ).

    ELSE.

* serialize table lt_fINAL into JSON, skipping initial fields and converting ABAP field names into camelCase
      lv_json = /ui2/cl_json=>serialize( data = ls_final compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

      " Display JSON in ABAP
*    CALL TRANSFORMATION sjson2html SOURCE XML lv_json
*                               RESULT XML DATA(lvc_html).
*  cl_abap_browser=>show_html( title = 'ABAP (iTab) -> JSON: /ui2/cl_json=>serialize' html_string = cl_abap_codepage=>convert_from( lvc_html ) ).

      CLEAR lt_final.
      CLEAR: ls_final-itemlist ,ls_final-refdtls-contrdtls,ls_final-refdtls-precdocdtls.

* deserialize JSON string json into internal table lt_final doing camelCase to ABAP like field name mapping
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = ls_final ).



      o_writer_itab = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
      CALL TRANSFORMATION id SOURCE values = ls_final RESULT XML o_writer_itab.

      cl_abap_conv_in_ce=>create( )->convert( EXPORTING
                                                input = o_writer_itab->get_output( )
                                              IMPORTING
                                                data = lv_result ).

* JSON -> ABAP (iTab)
      CLEAR lt_final.
      CLEAR: ls_final-itemlist ,ls_final-refdtls-contrdtls,ls_final-refdtls-precdocdtls.

      CALL TRANSFORMATION id SOURCE XML lv_result RESULT values = ls_final.

* ABAP (iTab) -> JSON (trex)
      o_trex = NEW cl_trex_json_serializer( ls_final ).
      o_trex->serialize( ).

    ENDIF.

*----------------------------------------------------------------------------------
    DATA(lv_trex_json) = o_trex->get_data( ).
*--------------------------------------------------------------------------------------


*--------------------------------------------------------------------------------------
*************************************************************************************************
    TYPES : BEGIN OF ty_json,
              line(255) TYPE c,
              tabix(03) TYPE n,
*           lv_text(65535) TYPE c,
            END OF ty_json.

    TYPES : BEGIN OF ty_json_output,
              line(255) TYPE c,
            END OF ty_json_output.


    TYPES : BEGIN OF ty_json_cnt,
              line(255) TYPE c,
              tabix     TYPE i,
*           lv_text(65535) TYPE c,
            END OF ty_json_cnt.

    DATA : it_json        TYPE TABLE OF ty_json,
           it_json_in     TYPE TABLE OF zeinv_json,
           ls_json        TYPE ty_json,
           lt_json_output TYPE STANDARD TABLE OF ty_json_output,
           ls_json_output TYPE ty_json_output,
           p_lines        TYPE i VALUE 0,
           count          TYPE i VALUE 0,
           ls_update      TYPE zeinv_update.

    DATA : lt_json_cnt TYPE TABLE OF ty_json_cnt,
           ls_json_cnt TYPE ty_json_cnt.


    IF sy-subrc IS INITIAL.
*    SPLIT lv_trex_json AT ':' INTO TABLE lt_json_string .
      REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
      SPLIT lv_trex_json AT '#' INTO TABLE it_json .
    ENDIF.


*    READ TABLE it_json ASSIGNING FIELD-SYMBOL(<lfs_json>) INDEX 1.
*    IF sy-subrc EQ 0 .
*      REPLACE ALL OCCURRENCES OF '[' IN <lfs_json> WITH ''.
*    ENDIF.

    DATA : lv_srno  TYPE string VALUE 'zslno',
           lv_start TYPE string VALUE 'version'.

    DATA : cnt_tax TYPE i VALUE 0.

    DATA : ls_str TYPE string.
    DATA : cnt TYPE i VALUE 200.
    DATA : lv_flag(01) TYPE c,
           lv_count    TYPE i.



    LOOP AT it_json INTO ls_json.
*      ls_json-tabix = sy-tabix.
      IF ls_json-line CS lv_start.
        cnt_tax = 0.
        ls_json-tabix = cnt_tax.
        lv_flag = 'X'.
      ENDIF.
      IF lv_flag  = 'X' AND ls_json-line NS lv_srno.
        cnt_tax = cnt_tax + 1.
        ls_json-tabix = cnt_tax.
      ELSE.
        CLEAR lv_flag.
      ENDIF.

      MODIFY it_json FROM ls_json TRANSPORTING tabix.
      CLEAR ls_json.
*  clear <lfs_assign>.
    ENDLOOP.

    CLEAR :  sy-tabix , lv_flag .

    LOOP AT it_json INTO ls_json.
*      ls_json-tabix = sy-tabix.
      IF ls_json-line CS lv_srno.
        cnt = 200.
        ls_json-tabix = cnt.
        lv_flag = 'X'.
      ENDIF.
      IF lv_flag  = 'X' AND ls_json-line NS lv_start.
        cnt = cnt + 1.
        ls_json-tabix = cnt.
      ELSE.
        CLEAR lv_flag.
      ENDIF.

      MODIFY it_json FROM ls_json TRANSPORTING tabix.
*  clear <lfs_assign>.
    ENDLOOP.
    MOVE it_json TO it_json_in.
    REFRESH it_json.

*      ls_update-buyerdtls = 'X'.
*      ls_update-sellerdtls = 'X'.
*      ls_update-irn = 'X'.
*      ls_update-itemlist = 'X'.
*      ls_update-irn = 'X'.
*      ls_update-zdocdtls = 'X'.
*      ls_update-version = 'X'.
*      ls_update-valdtls = 'X'.
*      ls_update-trandtls = 'X'.
    ls_update-refdtls = 'X'.
    ls_update-contrdtls = 'X'.
    ls_update-precdocdtls = 'X'.




    CALL METHOD go_einvoice_utility->json_schema_mapping
      EXPORTING
        is_update   = ls_update
      CHANGING
        ct_json_in  = it_json_in
        ct_json_out = it_json.


*



    LOOP AT it_json INTO ls_json .

      ls_json_output-line = ls_json-line.
      CONCATENATE  ls_str ls_json-line  INTO ls_str.
      APPEND ls_json_output TO lt_json_output.

      count = count + 1.
      WRITE / ls_json-line.
      CLEAR :  ls_json , ls_json_output,ls_update.
    ENDLOOP.


    IF lt_json_output IS NOT INITIAL.
      lt_jsonfile[] = lt_json_output[].
      status = 'Success!'.
    ELSE.
      status = 'Error!'.
    ENDIF.


  ELSE.
    status = 'Error!'.
  ENDIF.



  CLEAR : ls_final.
*-------------------------------




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_CANCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_RETMSG  text
*      -->P_VBELN  text
*      -->P_GJAHR  text
*----------------------------------------------------------------------*
FORM get_data_cancel  TABLES   lt_retmsg STRUCTURE bapiret2
                                 "Insert a correct name for <...>
                      USING    belnr
                               gjahr.


  DATA lc_belnr TYPE bkpf-belnr.
  lc_belnr = belnr.

  DATA : ls_zeinv_cancel TYPE zeinv_res_fb70.


*IF sy-subrc eq 0.
*
*ENDIF.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lc_belnr
    IMPORTING
      output = lc_belnr.



  SELECT SINGLE * FROM zeinv_res_fb70 INTO ls_zeinv_cancel
    WHERE belnr = lc_belnr.

  IF sy-subrc EQ 0 AND ls_zeinv_cancel IS NOT INITIAL.

    ls_final_cancel-irn = ls_zeinv_cancel-zzirn_no.
    ls_final_cancel-cnlrsn = '1'.
    ls_final_cancel-cnlrem  = ls_zeinv_cancel-zzcan_reason.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  JSON_CONVERSION_CANCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_JSONFILE  text
*      -->P_FILE_LOC  text
*      -->P_VBELN  text
*      <--P_STATUS  text
*----------------------------------------------------------------------*
FORM json_conversion_cancel  TABLES   lt_jsonfile STRUCTURE zstr_jsonfile
                                        "Insert a correct name for <...>
                             USING    file_loc
                                      belnr
                             CHANGING status.



  DATA:  lv_json   TYPE string.

* serialize table lt_fINAL into JSON, skipping initial fields and converting ABAP field names into camelCase
  lv_json = /ui2/cl_json=>serialize( data = ls_final_cancel compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

  " Display JSON in ABAP
  CALL TRANSFORMATION sjson2html SOURCE XML lv_json
                             RESULT XML DATA(lvc_html).
*  cl_abap_browser=>show_html( title = 'ABAP (iTab) -> JSON: /ui2/cl_json=>serialize' html_string = cl_abap_codepage=>convert_from( lvc_html ) ).

  CLEAR lt_final.

* deserialize JSON string json into internal table lt_final doing camelCase to ABAP like field name mapping
  /ui2/cl_json=>deserialize( EXPORTING json = lv_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = lt_final ).



  DATA(o_writer_itab) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
  CALL TRANSFORMATION id SOURCE values = ls_final_cancel RESULT XML o_writer_itab.
  DATA: lv_result TYPE string.
  cl_abap_conv_in_ce=>create( )->convert( EXPORTING
                                            input = o_writer_itab->get_output( )
                                          IMPORTING
                                            data = lv_result ).

* JSON -> ABAP (iTab)
  CLEAR lt_final.

  CALL TRANSFORMATION id SOURCE XML lv_result RESULT values = ls_final_cancel.

* ABAP (iTab) -> JSON (trex)
  DATA(o_trex) = NEW cl_trex_json_serializer( ls_final_cancel ).
  o_trex->serialize( ).

  DATA(lv_trex_json) = o_trex->get_data( ).
*--------------------------------------------------------------------------------------
*************************************************************************************************
  TYPES : BEGIN OF ty_json,
            line(255) TYPE c,
            tabix(03) TYPE n,
*           lv_text(65535) TYPE c,
          END OF ty_json.

  TYPES : BEGIN OF ty_json_output,
            line(255) TYPE c,
          END OF ty_json_output.


  TYPES : BEGIN OF ty_json_cnt,
            line(255) TYPE c,
            tabix     TYPE i,
*           lv_text(65535) TYPE c,
          END OF ty_json_cnt.

  DATA : it_json        TYPE TABLE OF ty_json,
         ls_json        TYPE ty_json,
         lt_json_output TYPE STANDARD TABLE OF ty_json_output,
         ls_json_output TYPE ty_json_output,
         p_lines        TYPE i VALUE 0,
         count          TYPE i VALUE 0.

  DATA : lt_json_cnt TYPE TABLE OF ty_json_cnt,
         ls_json_cnt TYPE ty_json_cnt.


  IF sy-subrc IS INITIAL.
*    SPLIT lv_trex_json AT ':' INTO TABLE lt_json_string .
    REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
    SPLIT lv_trex_json AT '#' INTO TABLE it_json .
  ENDIF.





  READ TABLE it_json ASSIGNING FIELD-SYMBOL(<lfs_json>) INDEX 1.
  IF sy-subrc EQ 0 .
    REPLACE ALL OCCURRENCES OF '[' IN <lfs_json> WITH ''.
  ENDIF.

  DATA : lv_srno TYPE string VALUE 'slno'.
  DATA : cnt TYPE i VALUE 200.
  DATA : lv_flag(01) TYPE c.


  LOOP AT it_json ASSIGNING FIELD-SYMBOL(<lfs_json_main>).
    CASE sy-tabix.
      WHEN 1.
        REPLACE 'irn' IN <lfs_json_main> WITH '"Irn"'.
      WHEN 2.
        REPLACE 'cnlrsn' IN <lfs_json_main> WITH '"CnlRsn"'.
      WHEN 3.
        REPLACE 'cnlrem' IN <lfs_json_main> WITH '"CnlRem"'.

      WHEN OTHERS.
    ENDCASE.

  ENDLOOP.






  DATA : ls_str TYPE string.


  LOOP AT it_json INTO ls_json.

    ls_json_output-line = ls_json-line.
    CONCATENATE  ls_str ls_json-line  INTO ls_str.
    APPEND ls_json_output TO lt_json_output.

    count = count + 1.
    WRITE / ls_json-line.
    CLEAR :  ls_json , ls_json_output.
  ENDLOOP.

  IF lt_json_output IS NOT INITIAL.
    lt_jsonfile[] = lt_json_output[].
    status = 'Success!'.
  ELSE.
    status = 'Error!'.
  ENDIF.



  CLEAR : ls_final_cancel.



ENDFORM.
