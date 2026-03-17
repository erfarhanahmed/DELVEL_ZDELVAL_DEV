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
                  USING vbeln TYPE vbeln
                        gjahr TYPE gjahr
                        lv_mode TYPE flag.

  REFRESH lt_final.


  DATA lc_vbeln TYPE vbeln.
  lc_vbeln = vbeln.


  DATA : ls_docs TYPE zstr_vbeln.



  IF lc_vbeln IS NOT INITIAL.
    SELECT
      vbeln fkart waerk  knumv fkdat gjahr rfbsk zterm bukrs xblnr zuonr bupla vkorg kurrf land1
       FROM vbrk
               INTO TABLE lt_vbrk
               WHERE vbeln EQ lc_vbeln. " AND
*                      gjahr EQ gjahr.
  ENDIF.

  IF lt_vbrk IS NOT INITIAL.

    DESCRIBE TABLE lt_vbrk LINES lv_docs.



    SELECT
      vbeln posnr fkimg vrkme ntgew netwr matnr arktx pstyv werks vgbel
       FROM vbrp
            INTO TABLE lt_vbrp
            FOR ALL ENTRIES IN lt_vbrk
            WHERE vbeln = lt_vbrk-vbeln.

    SELECT
      bukrs branch gstin
       FROM j_1bbranch
            INTO TABLE lt_j_1bbranch
            FOR ALL ENTRIES IN lt_vbrk
            WHERE bukrs = lt_vbrk-bukrs AND
                  branch = lt_vbrk-bupla.

    SELECT * FROM t001
             INTO CORRESPONDING FIELDS OF TABLE lt_t001
             FOR ALL ENTRIES IN lt_vbrk
             WHERE bukrs = lt_vbrk-bukrs.

    SELECT
         bukrs
         vkorg
         fkart
         base_kschl
         disc_kschl
         other_kschl
         type
         category
         expcat
         flag
      FROM zeinv_link INTO TABLE lt_zeinv_link
      FOR ALL ENTRIES IN lt_vbrk
      WHERE
      bukrs = lt_vbrk-bukrs AND
      fkart = lt_vbrk-fkart AND
      vkorg = lt_vbrk-vkorg.


    SELECT zterm text1 FROM t052u INTO TABLE lt_t052u
      FOR ALL ENTRIES IN lt_vbrk
      WHERE zterm = lt_vbrk-zterm.



    IF lt_vbrp IS NOT INITIAL.

      SELECT matnr werks steuc FROM marc INTO TABLE lt_marc
        FOR ALL ENTRIES IN lt_vbrp
        WHERE matnr = lt_vbrp-matnr AND
              werks = lt_vbrp-werks.


      READ TABLE lt_zeinv_link INTO ls_zeinv_link INDEX 1.

      IF ls_zeinv_link-type = 'DBN'.

        SELECT
        vbeln posnr fkimg vrkme ntgew netwr matnr arktx pstyv werks vgbel
         FROM vbrp
              INTO TABLE lt_vbrp_cd
              FOR ALL ENTRIES IN lt_vbrk
              WHERE vbeln = lt_vbrk-vbeln.


        IF lt_vbrp_cd IS NOT INITIAL.
          SELECT vbeln posnr parvw kunnr adrnr land1

          FROM vbpa
          INTO TABLE lt_vbpa
          FOR ALL ENTRIES IN lt_vbrp_cd
          WHERE vbeln = lt_vbrp_cd-vgbel. "and
*                parvw in ( 'SP', 'SH' ).



        ENDIF.





      ELSEIF ls_zeinv_link-type = 'CRN'.
        READ TABLE lt_vbrk INTO ls_vbrk INDEX 1.
        IF sy-subrc EQ 0.

          SELECT SINGLE vbeln , fkdat FROM vbrk INTO @DATA(ls_vbrk_prev)
            WHERE vbeln = @ls_vbrk-zuonr.


          SELECT
          vbeln posnr fkimg vrkme ntgew netwr matnr arktx pstyv werks vgbel
           FROM vbrp
                INTO TABLE lt_vbrp_cd
                FOR ALL ENTRIES IN lt_vbrk
                WHERE vbeln = lt_vbrk-zuonr.


          IF lt_vbrp_cd IS NOT INITIAL.
            SELECT vbeln vkorg vstel
            kunnr
            kunag
            FROM likp
            INTO TABLE lt_likp
            FOR ALL ENTRIES IN lt_vbrp_cd
            WHERE vbeln = lt_vbrp_cd-vgbel.
          ENDIF.


        ELSE.
          SELECT vbeln vkorg vstel
            kunnr
            kunag
            FROM likp
            INTO TABLE lt_likp
            FOR ALL ENTRIES IN lt_vbrp
            WHERE vbeln = lt_vbrp-vgbel.
        ENDIF.
      ENDIF.


      SELECT
        werks name1  kunnr lifnr adrnr
          FROM t001w
                INTO  TABLE lt_t001w
                FOR ALL ENTRIES IN lt_vbrp
                WHERE werks = lt_vbrp-werks.


      IF lt_t001w IS NOT INITIAL.
        SELECT
          addrnumber
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
                 INTO CORRESPONDING FIELDS OF TABLE lt_adrc
                 FOR ALL ENTRIES IN lt_t001w
                 WHERE addrnumber = lt_t001w-adrnr.
      ENDIF.
    ENDIF.

    IF lt_adrc IS NOT INITIAL.

      SELECT
        zstcode
        zsapcode
        zstdecr
        FROM zstate_code
        INTO TABLE lt_zstate_code
        FOR ALL ENTRIES IN lt_adrc
        WHERE zsapcode EQ lt_adrc-region.

    ENDIF.


    IF lt_likp IS NOT INITIAL.
      SELECT
        kunnr land1 name1 pstlz regio adrnr stcd3
         FROM kna1
               INTO TABLE lt_kna1
               FOR ALL ENTRIES IN lt_likp
               WHERE kunnr = lt_likp-kunnr.

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

  PERFORM process_data CHANGING lt_final.

  "--New Code-----------------------------------------

  LOOP AT lt_vbrk INTO ls_vbrk.


    IF ls_vbrk-rfbsk = 'C'.  "--Check is posting is completed or not 'C' = posting Done.

      READ TABLE lt_zeinv_link INTO ls_zeinv_link INDEX 1.
      IF ls_zeinv_link-type = 'DBN'.

        READ TABLE lt_vbrp_cd INTO ls_vbrp_cd WITH KEY vbeln = ls_vbrk-vbeln.
        IF sy-subrc EQ 0.
          READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = ls_vbrp_cd-vgbel parvw = 'AG'.
          IF sy-subrc EQ 0.
            ls_likp-kunag = ls_vbpa-kunnr.
            DATA(lv_sold_to) = ls_vbpa-kunnr.
            lv_typ = lc_typ_reg.
          ENDIF.
          READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = ls_vbrp_cd-vgbel parvw = 'WE'.
          IF sy-subrc EQ 0.
            IF ls_vbpa-kunnr NE lv_sold_to.
              ls_likp-kunnr = ls_vbpa-kunnr.
              lv_typ  = lc_typ_shp.
            ENDIF.
          ENDIF.
        ENDIF.
        CLEAR lv_sold_to.



      ELSEIF ls_zeinv_link-type = 'CRN'.
        READ TABLE lt_vbrp_cd INTO ls_vbrp_cd WITH KEY vbeln = ls_vbrk-zuonr.
        IF sy-subrc IS INITIAL.
          READ TABLE lt_likp INTO ls_likp WITH KEY  vbeln = ls_vbrp_cd-vgbel.
          IF sy-subrc IS INITIAL.
            IF ls_vbrp_cd-werks EQ  ls_likp-vstel AND ls_likp-kunag EQ ls_likp-kunnr.
              lv_typ = lc_typ_reg.                            "'REG'.
            ELSEIF ls_likp-vstel NE ls_vbrp_cd-werks AND ls_likp-kunag EQ ls_likp-kunnr.
              lv_typ  = lc_typ_dis.
            ELSEIF ls_likp-kunag NE ls_likp-kunnr.
              lv_typ  = lc_typ_shp.
            ELSEIF ls_likp-vstel NE ls_vbrp_cd-werks AND ls_likp-kunag NE ls_likp-kunnr.
              lv_typ  = lc_typ_cmb.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
      "--Addr Details for REG  DIS SHP CMB

      CALL FUNCTION 'ZEINV_GET_ADRC_DATA'
        EXPORTING
          i_vbrp     = ls_vbrp_cd
          i_likp     = ls_likp
          i_invtyp   = lv_typ
        IMPORTING
          e_sel_addr = ls_sel_addr
          e_dis_addr = ls_dis_addr
          e_buy_addr = ls_buy_addr
          e_shp_addr = ls_shp_addr.

************************************************************************************
      "--INR Details
************************************************************************************
      ls_final-version = lc_version.            "'1.0'.
      ls_final-irn = ''.
************************************************************************************
      "--TranDtls (Transaction Details)---------
************************************************************************************

      READ TABLE lt_zeinv_link INTO ls_zeinv_link WITH KEY bukrs = ls_vbrk-bukrs  fkart = ls_vbrk-fkart vkorg = ls_vbrk-vkorg.
      IF sy-subrc IS INITIAL .
        ls_final-trandtls-taxsch = lc_taxsch.  "'GST'.
        ls_final-trandtls-suptyp = ls_zeinv_link-category. "'B2B'.
        ls_final-trandtls-regrev = lc_regrev.               "Y/N
        ls_final-trandtls-ecmgstin = lc_null.

        IF ls_final-trandtls-ecmgstin IS NOT INITIAL.
          ls_update-trandtls = 'X'.
        ENDIF.
************************************************************************************
        "--DocDtls (Document Details)--------------
************************************************************************************

        DATA : lv_date TYPE string.

        CONCATENATE ls_vbrk-fkdat+6(02) '/' ls_vbrk-fkdat+4(02) '/' ls_vbrk-fkdat(04)  INTO lv_date.
*        CONCATENATE sy-datum+6(02) '/' sy-datum+4(02) '/' sy-datum(04)  INTO lv_date.                        " ??????????????????????????????

        ls_final-zdocdtls-ztyp = ls_zeinv_link-type.         "'INV' .

        SHIFT ls_vbrk-xblnr LEFT DELETING LEADING '0'.
        ls_final-zdocdtls-zno  = ls_vbrk-xblnr.             "'' .


        ls_final-zdocdtls-zdt  = lv_date." ls_vbrk-fkdat.            "03/06/2020 .
      ELSE.
        MESSAGE e000 WITH ls_vbrk-bukrs ls_vbrk-fkart ls_vbrk-vkorg. "'Please maintain zirn_link table '   TYPE 'E' DISPLAY LIKE 'E'.
      ENDIF.
************************************************************************************
      "--SellerDtls (Seller Details)------------------
************************************************************************************
      READ TABLE lt_t001 INTO ls_t001 WITH KEY bukrs = ls_vbrk-bukrs.
      IF sy-subrc IS INITIAL.
        ls_final-sellerdtls-lglnm  = ls_t001-butxt.
        ls_final-sellerdtls-trdnm  = ls_t001-butxt.
      ENDIF.

      READ TABLE lt_j_1bbranch INTO ls_j_1bbranch WITH KEY bukrs = ls_vbrk-bukrs branch = ls_vbrk-bupla.
      IF sy-subrc IS INITIAL.
        ls_final-sellerdtls-gstin  = ls_j_1bbranch-gstin." '24AAAPI3182M002'. "ls_t001-gstin
      ELSE.
        ls_final-sellerdtls-gstin  = 'URP'.
      ENDIF.
      ls_final-sellerdtls-addr1  = ls_sel_addr-str_suppl1.

      IF ls_sel_addr-str_suppl2 IS NOT INITIAL.
        ls_final-sellerdtls-addr2  = ls_sel_addr-str_suppl2.
      ELSE.
        ls_final-sellerdtls-addr2  = lc_null.
      ENDIF.

      IF ls_sel_addr-mc_city1 IS NOT INITIAL.
        ls_final-sellerdtls-zloc    = ls_sel_addr-mc_city1.
      ELSE.
        ls_final-sellerdtls-zloc    = lc_null.
      ENDIF.

      ls_final-sellerdtls-zpin    = ls_sel_addr-post_code1.
      ls_final-sellerdtls-zstate  = ls_sel_addr-region.


      ls_final-sellerdtls-zem     = lc_null.
      IF ls_sel_addr-tel_number IS NOT INITIAL.
        ls_final-sellerdtls-zph     = lc_null."ls_sel_addr-tel_number.
      ELSE.
        ls_final-sellerdtls-zph = lc_null.
      ENDIF.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-sellerdtls-lglnm WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-sellerdtls-trdnm WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-sellerdtls-addr1 WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-sellerdtls-addr2 WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-sellerdtls-zloc WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-sellerdtls-zstate  WITH ''.

      REPLACE ALL OCCURRENCES OF '&' IN ls_final-sellerdtls-lglnm WITH ''.
      REPLACE ALL OCCURRENCES OF '&' IN ls_final-sellerdtls-trdnm WITH ''.
      REPLACE ALL OCCURRENCES OF '&' IN ls_final-sellerdtls-addr1 WITH ''.
      REPLACE ALL OCCURRENCES OF '&' IN ls_final-sellerdtls-addr2 WITH ''.
      REPLACE ALL OCCURRENCES OF '&' IN ls_final-sellerdtls-zloc WITH ''.
      REPLACE ALL OCCURRENCES OF '&' IN ls_final-sellerdtls-zstate  WITH ''.

      REPLACE ALL OCCURRENCES OF '#' IN ls_final-sellerdtls-lglnm WITH ''.
      REPLACE ALL OCCURRENCES OF '#' IN ls_final-sellerdtls-trdnm WITH ''.
      REPLACE ALL OCCURRENCES OF '#' IN ls_final-sellerdtls-addr1 WITH ''.
      REPLACE ALL OCCURRENCES OF '#' IN ls_final-sellerdtls-addr2 WITH ''.
      REPLACE ALL OCCURRENCES OF '#' IN ls_final-sellerdtls-zloc WITH ''.
      REPLACE ALL OCCURRENCES OF '#' IN ls_final-sellerdtls-zstate  WITH ''.
******

************************************************************************************
      "--BuyerDtls (Buyers Details)------
************************************************************************************

      IF ls_buy_addr-country  NE 'IN'.
        ls_final-buyerdtls-gstin   = 'URP'.                                       "?????????????????????
      ELSE.
        ls_final-buyerdtls-gstin   = ls_buy_addr-gstin.
      endif.

      ls_final-buyerdtls-lglnm   = ls_buy_addr-name1.
      ls_final-buyerdtls-trdnm   = ls_buy_addr-name1.

     IF ls_vbrk-fkart = 'ZERO' AND ls_vbrk-waerk NE 'INR'.
        ls_final-buyerdtls-zpos = '96'.
     ELSEIF ls_buy_addr-country NE 'IN'.
        ls_final-buyerdtls-zpos = '96'.
       ELSE .
        ls_final-buyerdtls-zpos     = ls_buy_addr-region.
     ENDIF.

*      IF ls_buy_addr-country NE 'IN'.
*        ls_final-buyerdtls-zpos = '96'.
*       ELSE .
*         ls_final-buyerdtls-zpos     = ls_buy_addr-region.
*      ENDIF.

      IF ls_buy_addr-str_suppl1 IS INITIAL AND ls_buy_addr-str_suppl2 IS INITIAL.      "DBN Case
        ls_final-buyerdtls-addr1 = ls_buy_addr-street."ls_buy_addr-location.
        ls_final-buyerdtls-addr2 = ls_buy_addr-location.
      ELSE.
        ls_final-buyerdtls-addr1   = ls_buy_addr-street."ls_buy_addr-str_suppl1.
        ls_final-buyerdtls-addr2   = ls_buy_addr-str_suppl2.
      ENDIF.

      IF ls_final-buyerdtls-addr2 IS INITIAL.
        ls_final-buyerdtls-addr2 = lc_null.
      ENDIF.

      ls_final-buyerdtls-zloc     = ls_buy_addr-mc_city1.

      IF ls_final-buyerdtls-zloc IS INITIAL.
        ls_final-buyerdtls-zloc = lc_null.
      ENDIF.

      IF ls_buy_addr-country  NE 'IN'.
        ls_final-buyerdtls-zpin     = '999999'.
        ls_final-buyerdtls-zstate   = '96'.
      ELSE.
        ls_final-buyerdtls-zpin     = ls_buy_addr-post_code1.
        ls_final-buyerdtls-zstate   = ls_buy_addr-region.
      ENDIF.

      ls_final-buyerdtls-zph      = lc_null."ls_buy_addr-tel_number.

      IF ls_buy_addr-tel_number IS INITIAL.
        ls_final-buyerdtls-zph = lc_null.
      ENDIF.
      ls_final-buyerdtls-zem      = lc_null.


      REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-lglnm    WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-trdnm    WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-addr1    WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-addr2    WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-zloc      WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN ls_final-buyerdtls-zstate    WITH ''.

      REPLACE ALL OCCURRENCES OF '&' IN ls_final-buyerdtls-lglnm    WITH ''.
      REPLACE ALL OCCURRENCES OF '&' IN ls_final-buyerdtls-trdnm    WITH ''.
      REPLACE ALL OCCURRENCES OF '&' IN ls_final-buyerdtls-addr1    WITH ''.
      REPLACE ALL OCCURRENCES OF '&' IN ls_final-buyerdtls-addr2    WITH ''.
      REPLACE ALL OCCURRENCES OF '&' IN ls_final-buyerdtls-zloc      WITH ''.
      REPLACE ALL OCCURRENCES OF '&' IN ls_final-buyerdtls-zstate    WITH ''.

      REPLACE ALL OCCURRENCES OF '#' IN ls_final-buyerdtls-lglnm    WITH ''.
      REPLACE ALL OCCURRENCES OF '#' IN ls_final-buyerdtls-trdnm    WITH ''.
      REPLACE ALL OCCURRENCES OF '#' IN ls_final-buyerdtls-addr1    WITH ''.
      REPLACE ALL OCCURRENCES OF '#' IN ls_final-buyerdtls-addr2    WITH ''.
      REPLACE ALL OCCURRENCES OF '#' IN ls_final-buyerdtls-zloc      WITH ''.
      REPLACE ALL OCCURRENCES OF '#' IN ls_final-buyerdtls-zstate    WITH ''.

************************************************************************************
      "--DispDtls (Display Details)------------
************************************************************************************
      IF ls_dis_addr IS NOT INITIAL.
        ls_final-dispdtls-znm     =   ls_dis_addr-name1.      "Required
        ls_final-dispdtls-addr1   =   ls_dis_addr-str_suppl1. "Required

        ls_final-dispdtls-addr2   =   ls_dis_addr-str_suppl2.

        IF ls_final-dispdtls-addr2 IS INITIAL.
          ls_final-dispdtls-addr2 = lc_null.
        ENDIF.
        ls_final-dispdtls-zloc     =   ls_dis_addr-mc_city1.   "Required
        ls_final-dispdtls-zpin     =   ls_dis_addr-post_code1. "Required
        ls_final-dispdtls-stcd    =   ls_dis_addr-region.     "Required

        REPLACE ALL OCCURRENCES OF ',' IN ls_final-dispdtls-znm    WITH ''.
        REPLACE ALL OCCURRENCES OF ',' IN ls_final-dispdtls-addr1 WITH ''.
        REPLACE ALL OCCURRENCES OF ',' IN ls_final-dispdtls-addr2 WITH ''.
        REPLACE ALL OCCURRENCES OF ',' IN ls_final-dispdtls-zloc   WITH ''.
        ls_update-dispdtls = 'X'.
      ENDIF.
************************************************************************************
      "--ShipDtls (Shipping Details)------------
************************************************************************************
      IF ls_shp_addr IS NOT INITIAL.

        ls_final-shipdtls-gstin   =   ls_shp_addr-gstin.

        IF ls_shp_addr-gstin IS INITIAL.
          ls_final-shipdtls-gstin   = 'URP'.
        ENDIF.
        ls_final-shipdtls-lglnm   =   ls_shp_addr-name1.
        ls_final-shipdtls-trdnm   =   ls_shp_addr-name1.
        ls_final-shipdtls-addr1   =   ls_shp_addr-str_suppl1.

        ls_final-shipdtls-addr2   =   ls_shp_addr-str_suppl2.
        IF ls_final-shipdtls-addr2 IS INITIAL.
          ls_final-shipdtls-addr2 = lc_null.
        ENDIF.
        ls_final-shipdtls-zloc     =   ls_shp_addr-mc_city1.

        IF ls_vbrk-fkart = 'ZERO' AND ls_vbrk-waerk NE 'INR'.
         ls_final-shipdtls-zpin     =  '999999'.
        ELSE.
         ls_final-shipdtls-zpin     =  ls_shp_addr-post_code1.
        ENDIF.

        IF ls_shp_addr-region IS NOT INITIAL.
          ls_final-shipdtls-stcd    =   ls_shp_addr-region.
*          ls_final-buyerdtls-zpos     = ls_shp_addr-region.
        ENDIF.

        IF ls_vbrk-fkart = 'ZERO' AND ls_vbrk-waerk NE 'INR'.
         ls_final-shipdtls-stcd    =  '96'.
        ELSE.
         ls_final-shipdtls-stcd    =  ls_shp_addr-region.
        ENDIF.



        REPLACE ALL OCCURRENCES OF ',' IN ls_final-shipdtls-lglnm    WITH ''.
        REPLACE ALL OCCURRENCES OF ',' IN ls_final-shipdtls-trdnm    WITH ''.
        REPLACE ALL OCCURRENCES OF ',' IN ls_final-shipdtls-addr1    WITH ''.
        REPLACE ALL OCCURRENCES OF ',' IN ls_final-shipdtls-addr2    WITH ''.
        REPLACE ALL OCCURRENCES OF ',' IN ls_final-shipdtls-zloc      WITH ''.

        REPLACE ALL OCCURRENCES OF '&' IN ls_final-shipdtls-lglnm    WITH ''.
        REPLACE ALL OCCURRENCES OF '&' IN ls_final-shipdtls-trdnm    WITH ''.
        REPLACE ALL OCCURRENCES OF '&' IN ls_final-shipdtls-addr1    WITH ''.
        REPLACE ALL OCCURRENCES OF '&' IN ls_final-shipdtls-addr2    WITH ''.
        REPLACE ALL OCCURRENCES OF '&' IN ls_final-shipdtls-zloc      WITH ''.

        REPLACE ALL OCCURRENCES OF '#' IN ls_final-shipdtls-lglnm    WITH ''.
        REPLACE ALL OCCURRENCES OF '#' IN ls_final-shipdtls-trdnm    WITH ''.
        REPLACE ALL OCCURRENCES OF '#' IN ls_final-shipdtls-addr1    WITH ''.
        REPLACE ALL OCCURRENCES OF '#' IN ls_final-shipdtls-addr2    WITH ''.
        REPLACE ALL OCCURRENCES OF '#' IN ls_final-shipdtls-zloc      WITH ''.

        ls_update-shipdtls = 'X'.
      ENDIF.
************************************************************************************
      "--itemlist (Item Details)------------
************************************************************************************
      LOOP AT lt_vbrp_cd INTO ls_vbrp_cd WHERE vbeln = ls_vbrk-zuonr.


        ls_itemlist-zslno                 = ls_vbrp_cd-posnr.
        ls_itemlist-prddesc              = ls_vbrp_cd-arktx.

        REPLACE ALL OCCURRENCES OF ',' IN ls_itemlist-prddesc      WITH ''.
        REPLACE ALL OCCURRENCES OF '&' IN ls_itemlist-prddesc      WITH ''.
        REPLACE ALL OCCURRENCES OF '#' IN ls_itemlist-prddesc      WITH ''.
        REPLACE ALL OCCURRENCES OF '"' IN ls_itemlist-prddesc      WITH ''.
        REPLACE ALL OCCURRENCES OF '/' IN ls_itemlist-prddesc      WITH ''.
        REPLACE ALL OCCURRENCES OF '\' IN ls_itemlist-prddesc      WITH ''.

        READ TABLE lt_marc INTO ls_marc WITH KEY matnr = ls_vbrp_cd-matnr werks = ls_vbrp_cd-werks.
        IF sy-subrc IS INITIAL.
          ls_itemlist-hsncd                =   ls_marc-steuc(06). "HSN code 6 digit added by Nilay B. on 15.12.2023

          "'23099010'."   ??????????????????????????????????????????????????
          IF ls_marc-steuc+0(2) = '99'.
            ls_itemlist-isservc              =  'N' .
          ELSE.
            ls_itemlist-isservc              =  'N' .
          ENDIF.
        ENDIF.
        ls_itemlist-barcde               =   lc_null.
        ls_itemlist-qnty                  =   ls_vbrp_cd-fkimg.
        ls_itemlist-freeqty              =   '0'."ls_vbrp_cd-fkimg.

        "Convert  SAP Unit to IRP Unit.
        CALL FUNCTION 'ZEINV_UNIT_CONVERT'
          EXPORTING
            vrkme = ls_vbrp_cd-vrkme
          IMPORTING
            unit  = ls_itemlist-units.

        " Get unitprice and totamt
        SELECT SINGLE kbetr kwert
                            FROM PRCD_ELEMENTS  INTO ( ls_itemlist-unitprice, ls_itemlist-totamt  )
*                            FROM konv INTO ( ls_itemlist-unitprice, ls_itemlist-totamt  )  "commented by amit
                            WHERE knumv = ls_vbrk-knumv AND
                                  kposn = ls_vbrp_cd-posnr AND
                                  ( kschl = ls_zeinv_link-base_kschl )."'ZPRO' ).

        IF ls_vbrk-fkart = 'ZERO' AND ls_vbrk-waerk NE 'INR'.
        ls_itemlist-unitprice = ls_itemlist-unitprice * ls_vbrk-kurrf.  "Added
        ls_itemlist-totamt    = ls_itemlist-totamt * ls_vbrk-kurrf.     "Added
        ENDIF.


        "------------Discount Condition------------

        SELECT  kbetr kwert kschl FROM PRCD_ELEMENTS
*        SELECT  kbetr kwert kschl FROM konv    "commented by amit
                    INTO CORRESPONDING FIELDS OF TABLE lt_konv_t
                    FOR ALL ENTRIES IN lt_zeinv_link
                    WHERE knumv = ls_vbrk-knumv AND
                          kposn = ls_vbrp_cd-posnr AND
                          ( kschl = lt_zeinv_link-disc_kschl ).
        LOOP AT lt_konv_t.
          ls_itemlist-discount =  ls_itemlist-discount +  ( lt_konv_t-kwert * -1 ).
        ENDLOOP.


        REFRESH lt_konv_t.

        ls_itemlist-pretaxval            ='0.00'.

        "------------GST Condition------------

        SELECT  kbetr kwert kschl kstat FROM PRCD_ELEMENTS
*        SELECT  kbetr kwert kschl kstat FROM konv     "commented by amit
                            INTO CORRESPONDING FIELDS OF TABLE lt_konv_t
                            WHERE knumv = ls_vbrk-knumv AND
                                  kposn = ls_vbrp_cd-posnr AND
                                   ( kschl = 'JOCG' OR kschl = 'JOSG' OR kschl = 'JOIG').

     IF ls_vbrk-fkart = 'ZERO'.

        LOOP AT lt_konv_t.
          IF lt_konv_t-kschl = 'JOIG' AND lt_konv_t-kstat <> 'X'.
            ls_itemlist-gstrt  = lt_konv_t-kbetr / 10.
            ls_itemlist-igstamt = lt_konv_t-kwert * ls_vbrk-kurrf.
          ELSEIF lt_konv_t-kschl = 'JOIG' AND lt_konv_t-kstat = 'X'.
            ls_itemlist-gstrt  = '0.000'.
            ls_itemlist-igstamt = '0.00'.
          ELSEIF lt_konv_t-kschl = 'JOCG'.
            ls_itemlist-gstrt  = ls_itemlist-gstrt +  lt_konv_t-kbetr / 10.
            ls_itemlist-cgstamt = lt_konv_t-kwert.
          ELSEIF lt_konv_t-kschl = 'JOSG'.
            ls_itemlist-gstrt  = ls_itemlist-gstrt + lt_konv_t-kbetr / 10.
            ls_itemlist-sgstamt = lt_konv_t-kwert.
          ENDIF.
        ENDLOOP.

      ELSE.

        LOOP AT lt_konv_t.
          IF lt_konv_t-kschl = 'JOIG'.
            ls_itemlist-gstrt  = lt_konv_t-kbetr / 10.
            ls_itemlist-igstamt = lt_konv_t-kwert.
          ELSEIF lt_konv_t-kschl = 'JOCG'.
            ls_itemlist-gstrt  = ls_itemlist-gstrt +  lt_konv_t-kbetr / 10.
            ls_itemlist-cgstamt = lt_konv_t-kwert.
          ELSEIF lt_konv_t-kschl = 'JOSG'.
            ls_itemlist-gstrt  = ls_itemlist-gstrt + lt_konv_t-kbetr / 10.
            ls_itemlist-sgstamt = lt_konv_t-kwert.
          ENDIF.
        ENDLOOP.

      ENDIF.

        IF lv_mode = 'X'.
          ls_itemlist-gstrt  = '18.000'.
        ENDIF.

        REFRESH lt_konv_t.

        "------------CES Condition------------

        SELECT  kbetr kwert kschl FROM PRCD_ELEMENTS
*        SELECT  kbetr kwert kschl FROM konv
                            INTO CORRESPONDING FIELDS OF TABLE lt_konv_t
                            FOR ALL ENTRIES IN lt_zeinv_link
                            WHERE knumv = ls_vbrk-knumv AND
                                  kposn = ls_vbrp_cd-posnr AND

                                  ( kschl = lt_zeinv_link-other_kschl ).
        LOOP AT lt_konv_t.
          IF lt_konv_t-kschl = 'CES'.
            ls_itemlist-zcesrt  = lt_konv_t-kbetr / 10.
            ls_itemlist-zcesamt = lt_konv_t-kwert.
          ELSEIF lt_konv_t-kschl = 'statece'.
            ls_itemlist-statecesrt  = lt_konv_t-kbetr / 10.
            ls_itemlist-statecesamt = lt_konv_t-kwert.
          ENDIF.
        ENDLOOP.
*
*          CLEAR lt_konv_t.
        ls_itemlist-zcesrt               = '0.00'.
        ls_itemlist-zcesamt              = '0.00'.
        ls_itemlist-zcesnonadvlamt       = '0.00'.
        ls_itemlist-statecesrt           = '0.00'.
        ls_itemlist-statecesamt          = '0.00'.
        ls_itemlist-statecesnonadvlamt   = '0.00'.

        "------------Other Condition------------
        SELECT  kbetr kwert kschl FROM PRCD_ELEMENTS
*        SELECT  kbetr kwert kschl FROM konv   "commented by amit
                    INTO CORRESPONDING FIELDS OF TABLE lt_konv_t
                    FOR ALL ENTRIES IN lt_zeinv_link
                    WHERE knumv = ls_vbrk-knumv AND
                          kposn = ls_vbrp_cd-posnr AND
                          ( kschl = lt_zeinv_link-other_kschl ).
        LOOP AT lt_konv_t.
          ls_itemlist-othchrg             =  ls_itemlist-othchrg + ( lt_konv_t-kwert * -1 ).
        ENDLOOP.
        IF ls_itemlist-othchrg LT 0.
          ls_itemlist-othchrg  = ls_itemlist-othchrg * -1.
        ENDIF.
        REFRESH lt_konv_t.

        ls_itemlist-assamt        = ls_itemlist-totamt - ls_itemlist-discount."  + ls_itemlist-othchrg  .
        ls_itemlist-totitemval    = ls_itemlist-assamt + ls_itemlist-igstamt + ls_itemlist-sgstamt + ls_itemlist-cgstamt +
                                    ls_itemlist-zcesamt + ls_itemlist-zcesnonadvlamt + ls_itemlist-statecesamt + ls_itemlist-statecesnonadvlamt
                                    + ls_itemlist-othchrg.
        ls_itemlist-ordlineref    =  '0.00'.
        ls_itemlist-orgcntry      =  lc_null.
        ls_itemlist-prdslno       =  lc_null.
************************************************************
        "--bchdtl (Batch Details)------------------
***********************************************************
        ls_itemlist-bchdtls-znm          = ''.
        ls_itemlist-bchdtls-zexpdt       = 'null'.
        ls_itemlist-bchdtls-wrdt         = 'null'.
        IF  ls_itemlist-bchdtls-znm   IS NOT INITIAL.
          ls_update-bchdtls = 'X'.
        ENDIF.
        ls_attribdtls-znm         =  lc_null.
        ls_attribdtls-valu        =  lc_null.

        APPEND ls_attribdtls TO lt_attribdtls.
        ls_itemlist-attribdtls  = lt_attribdtls.

        IF ls_itemlist-discount LT 0.
          ls_itemlist-discount = ls_itemlist-discount * -1.
        ENDIF.
        APPEND ls_itemlist TO lt_itemlist.



        lv_total_val  = lv_total_val  + ls_itemlist-totitemval.
        lv_assval     = ls_itemlist-assamt  + lv_assval.
        lv_cgstval    = ls_itemlist-cgstamt + lv_cgstval.
        lv_sgstval    = ls_itemlist-sgstamt + lv_sgstval.
        lv_igstval    = ls_itemlist-igstamt + lv_igstval.
        lv_discount   = ls_itemlist-discount + lv_discount.



        CLEAR: ls_itemlist , ls_attribdtls.


        REFRESH : lt_attribdtls.


      ENDLOOP.

      ls_final-itemlist = lt_itemlist.

      REFRESH: lt_itemlist.

***********************************************************
      "--ValDtls (Values Details)------------------
***********************************************************
      ls_final-valdtls-assval       = lv_assval.
      ls_final-valdtls-cgstval      = lv_cgstval.
      ls_final-valdtls-sgstval      = lv_sgstval.
      ls_final-valdtls-igstval      = lv_igstval.
      ls_final-valdtls-zcesval      = ''."lv_cesval.3
      ls_final-valdtls-stcesval     = ''."lv_stcesval.
      ls_final-valdtls-rndoffamt    = ''.
      ls_final-valdtls-ztotinvval   = lv_total_val.
      ls_final-valdtls-totinvvalfc  = ''.
*      ls_final-valdtls-invforcur     = lc_null.
      ls_update-valdtls = 'X'.


****Avinash
*  if ls_vbrk-fkart = 'ZERO'.
*if ls_final-valdtls-igstval is not INITIAL.
*  ls_final-trandtls-suptyp = 'EXPWP'.
*  ELSEIF ls_final-valdtls-igstval is INITIAL.
*  ls_final-trandtls-suptyp = 'EXPWOP'.
*  endif.
*  endif.
***********************************************************
      "--PayDtls (Pay Details)---------------------
***********************************************************
      ls_final-paydtls-znm        = ''.
      ls_final-paydtls-accdet     = lc_null.
      ls_final-paydtls-modes      = lc_null.
      ls_final-paydtls-fininsbr   = lc_null.
      ls_final-paydtls-payterm    = lc_null.
      ls_final-paydtls-payinstr   = lc_null.
      ls_final-paydtls-crtrn      = lc_null.
      ls_final-paydtls-dirdr      = lc_null.
      ls_final-paydtls-crday      = lc_null.
      ls_final-paydtls-paidamt    = '0.00'.
      ls_final-paydtls-paymtdue   = '0.00'.
      IF  ls_final-paydtls-znm   IS NOT INITIAL.
        ls_update-paydtls = 'X'.
      ENDIF.

***********************************************************
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
          i_date                     = ls_vbrk-fkdat
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

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = ls_vbrk-zuonr
        IMPORTING
          output = ls_vbrk-zuonr.

      ls_precdocdtls-invno          = ls_vbrk-zuonr.

      IF ls_vbrk_prev IS NOT INITIAL.
        CONCATENATE ls_vbrk_prev-fkdat+6(02) '/' ls_vbrk_prev-fkdat+4(02) '/' ls_vbrk_prev-fkdat(04)  INTO ls_precdocdtls-invdt.
      ELSE.
        CONCATENATE ls_vbrk-fkdat+6(02) '/' ls_vbrk-fkdat+4(02) '/' ls_vbrk-fkdat(04)  INTO ls_precdocdtls-invdt.
      ENDIF.


      ls_precdocdtls-othrefno       = lc_null.
      IF ls_precdocdtls-invno IS NOT INITIAL.
        ls_update-precdocdtls = 'X'.
      ENDIF.
      ls_contrdtls-recadvrefr       = lc_null.
      ls_contrdtls-recadvdt         = lc_null.
      ls_contrdtls-tendrefr         = lc_null.
      ls_contrdtls-contrrefr        = lc_null.
      ls_contrdtls-extrefr          = lc_null.
      ls_contrdtls-projrefr         = lc_null.
      ls_contrdtls-porefr           = lc_null.
      ls_contrdtls-porefdt          = lc_null.
      IF ls_contrdtls-recadvrefr  IS NOT INITIAL.
        ls_update-contrdtls = 'X'.
      ENDIF.
      APPEND ls_contrdtls TO lt_contrdtls.
      ls_final-refdtls-contrdtls  = lt_contrdtls.
*      ls_final-refdtls-contrdtls    = ls_contrdtls.

      APPEND ls_precdocdtls TO lt_precdocdtls.
      ls_final-refdtls-precdocdtls  = lt_precdocdtls.
*      ls_final-refdtls-precdocdtls  = ls_precdocdtls.

      CLEAR: lt_precdocdtls,lt_contrdtls,ls_contrdtls,ls_precdocdtls.

      IF ls_final-refdtls-docperddtls-invstdt IS NOT INITIAL.
        ls_update-refdtls = 'X'.
      ENDIF.
***********************************************************
*      ---ExpDtls------------------------------------ ---
***********************************************************
      ls_final-expdtls-shipbno  = ls_vbrk-xblnr.
      ls_final-expdtls-shipbdt  = lv_date.
      ls_final-expdtls-port     = ''.
      ls_final-expdtls-refclm   = ''.
      ls_final-expdtls-forcur   = ''.""ls_vbrk-waerk.
      ls_final-expdtls-cntcode  = ls_vbrk-land1.
      IF ls_final-expdtls-forcur IS NOT INITIAL.
        ls_update-expdtls = 'X'.
      ENDIF.
************************************************************************
      "--Addldocdtls--------------------------------------------
************************************************************************
      ls_addldocdtls-url  = lc_null.
      ls_addldocdtls-docs = lc_null.
      ls_addldocdtls-infodtls = lc_null.
      APPEND ls_addldocdtls TO lt_addldocdtls.
      ls_final-addldocdtls = lt_addldocdtls.
      CLEAR : ls_addldocdtls,lt_addldocdtls.

************************************************************************
      "----Ewbdtls(E-way Bill)------------------------------------------
************************************************************************

      ls_final-ewbdtls-transid      = lc_null.
      ls_final-ewbdtls-transname    = lc_null.
      ls_final-ewbdtls-transmode    = ''.
      ls_final-ewbdtls-distance     = lc_null.
      ls_final-ewbdtls-transdocno   = lc_null.
      ls_final-ewbdtls-transdocdt   = lc_null.
      ls_final-ewbdtls-vehno        = lc_null.
      ls_final-ewbdtls-vehtype      = lc_null.
      IF ls_final-ewbdtls-transmode  IS NOT INITIAL.
        ls_update-ewbdtls = 'X'.
      ENDIF.



      APPEND ls_final TO lt_final.
      CLEAR: lv_assval, lv_cgstval, lv_sgstval, lv_igstval,lv_total_val.

    ELSE.
*    MESSAGE 'Posting is not completed' TYPE 'E'.
      ls_retmsg-id = 'E'.
      ls_retmsg-message = 'Posting is not completed'.
      APPEND ls_retmsg TO lt_retmsg.
      lv_error = 'X'.
      CLEAR ls_retmsg.
      EXIT.
      LEAVE LIST-PROCESSING.
    ENDIF.

    CLEAR : lv_curry, lv_fy.
  ENDLOOP.
  CLEAR : ls_sel_addr,ls_dis_addr,ls_dis_addr,ls_shp_addr.
  it_final = lt_final.



ENDFORM.
FORM process_data
    CHANGING lt_final TYPE ANY TABLE.

  PERFORM reg_einv CHANGING lt_final.
ENDFORM.
FORM reg_einv CHANGING lt_final TYPE ANY TABLE.

  LOOP AT lt_vbrk INTO ls_vbrk.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  JSON_CONVERSION_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FILE_LOC  text
*      <--P_STATUS  text
*----------------------------------------------------------------------*
FORM json_conversion_all  TABLES lt_jsonfile STRUCTURE zstr_jsonfile USING  file_loc TYPE rlgrap-filename vbeln TYPE vbeln lv_mode TYPE flag
                                                                                                            CHANGING status TYPE string.

  DATA:  lv_json   TYPE string.
  DATA : o_writer_itab TYPE REF TO cl_sxml_string_writer.
  DATA: lv_result TYPE string.
  DATA : o_trex TYPE REF TO cl_trex_json_serializer.
* CREATE OBJECT o_trex .

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

  DATA :
    it_json        TYPE TABLE OF zeinv_json,
    it_json_in     TYPE TABLE OF zeinv_json,
    ls_json        TYPE zeinv_json,
    lt_json_output TYPE STANDARD TABLE OF ty_json_output,
    ls_json_output TYPE ty_json_output,
    p_lines        TYPE i VALUE 0,
    count          TYPE i VALUE 0.

  DATA : lt_json_cnt TYPE TABLE OF ty_json_cnt,
         ls_json_cnt TYPE ty_json_cnt.

  DATA : lv_srno TYPE string VALUE 'zslno'.
  DATA : lv_start TYPE string VALUE 'version'.
  DATA : cnt TYPE i VALUE 200.
  DATA : cnt_tax TYPE i VALUE 0.
  DATA : lv_flag(01) TYPE c.
  DATA : ls_str TYPE string.

  IF lv_error = ' '.

    IF lv_mode  = 'M'.    "-----Check for multiple docs selected in cockpit if docs are more than 1 create single file for mass upload.

* serialize table lt_fINAL into JSON, skipping initial fields and converting ABAP field names into camelCase
      lv_json = /ui2/cl_json=>serialize( data = lt_final compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
*  cl_abap_browser=>show_html( title = 'ABAP (iTab) -> JSON: /ui2/cl_json=>serialize' html_string = cl_abap_codepage=>convert_from( lvc_html ) ).

      CLEAR lt_final.

* deserialize JSON string json into internal table lt_final doing camelCase to ABAP like field name mapping
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = lt_final ).



      o_writer_itab = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
      CALL TRANSFORMATION id SOURCE values = lt_final RESULT XML o_writer_itab.

      cl_abap_conv_in_ce=>create( )->convert( EXPORTING
                                                input = o_writer_itab->get_output( )
                                              IMPORTING
                                                data = lv_result ).

* JSON -> ABAP (iTab)
      CLEAR lt_final.

      CALL TRANSFORMATION id SOURCE XML lv_result RESULT values = lt_final.

* ABAP (iTab) -> JSON (trex)
      o_trex = NEW cl_trex_json_serializer( lt_final ).
      o_trex->serialize( ).


    ELSEIF lv_mode NE 'M'.  " ------------------------------Single document Single file


* serialize table lt_fINAL into JSON, skipping initial fields and converting ABAP field names into camelCase
      lv_json = /ui2/cl_json=>serialize( data = ls_final compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
*    CLEAR lt_final.
* deserialize JSON string json into internal table lt_final doing camelCase to ABAP like field name mapping
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = lt_final ).



      o_writer_itab = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
      CALL TRANSFORMATION id SOURCE values = ls_final RESULT XML o_writer_itab.
*    DATA: lv_result TYPE string.
      cl_abap_conv_in_ce=>create( )->convert( EXPORTING
                                                input = o_writer_itab->get_output( )
                                              IMPORTING
                                                data = lv_result ).

* JSON -> ABAP (iTab)
      CLEAR lt_final.

      CALL TRANSFORMATION id SOURCE XML lv_result RESULT values = ls_final.

* ABAP (iTab) -> JSON (trex)
      o_trex = NEW cl_trex_json_serializer( ls_final ).
      o_trex->serialize( ).


    ENDIF.
*----------------------------------------------------------------------------------
    DATA(lv_trex_json) = o_trex->get_data( ).
*--------------------------------------------------------------------------------------

    IF sy-subrc IS INITIAL.
*    SPLIT lv_trex_json AT ':' INTO TABLE lt_json_string .
      REPLACE ALL OCCURRENCES OF ',' IN lv_trex_json WITH ',#'.
      SPLIT lv_trex_json AT '#' INTO TABLE it_json .
    ENDIF.

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

    ls_update-refdtls = 'X'.
    ls_update-precdocdtls = 'X'.
    ls_update-contrdtls = 'X'.

    CALL FUNCTION 'ZEINV_SCHEMA_MAP'
      EXPORTING
        i_update = ls_update
      TABLES
        json_in  = it_json_in
        json_out = it_json.



    LOOP AT it_json INTO ls_json.

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
                      USING    vbeln
                               gjahr.


  DATA lc_vbeln TYPE vbeln.
  lc_vbeln = vbeln.

  DATA : ls_zeinv_cancel TYPE zeinv_res.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lc_vbeln
    IMPORTING
      output = lc_vbeln.



  SELECT SINGLE * FROM zeinv_res INTO ls_zeinv_cancel
    WHERE vbeln = lc_vbeln.

  IF sy-subrc EQ 0.

    ls_final_cancel-irn = ls_zeinv_cancel-zzirn_no.
    ls_final_cancel-cnlrsn = '1'.
    ls_final_cancel-cnlrem = 'Wrong Entry'.
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
                                      vbeln
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
