*&---------------------------------------------------------------------*
*& REPORT  ZSD_SALES_REGISTER
*&
*----------------------------------------------------------------------*
*                          PROGRAM DETAILS                             *
*----------------------------------------------------------------------*
* PROGRAM NAME         : ZSD_SALES_REGISTER.                           *
* TITLE                : Net Sales Register                                              *
* STARTED ON           : 23 May 2012                                   *
* TRANSACTION CODE     :  ZSDSAREG                                     *
* DESCRIPTION          : BUSINESS WOULD LIKE TO GENERATE THE NET SALES *
*                        REPORT QUARTERLY FOR ALL CUSTOMERS.           *
*----------------------------------------------------------------------*

REPORT  zsd_sales_register_new ." LINE-SIZE 1023 .

INCLUDE zsd_sales_register_new_top.
INCLUDE zsd_sales_register_sel_scr.
INCLUDE zsd_sales_register_alv.


START-OF-SELECTION.
*&---------------------------------------------------------------------*
*& SUBROUTINE TO PROCESS REPORT DATA.
*&---------------------------------------------------------------------*
  PERFORM process_data.
  PERFORM build_field_cat.
  PERFORM display.

*&---------------------------------------------------------------------*
*&      FORM  PROCESS_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM  process_data.


  DATA : v_cnt      TYPE i,
         g_netprice TYPE kwert.


  SELECT a~vbeln
         a~vbtyp
         a~waerk
         a~knumv
         a~fkdat
         a~kurrf
         a~ktgrd
         a~netwr
         a~kunrg
         a~kunag
         a~vtweg
         a~spart
         a~mwsbk
         b~posnr
         b~fkimg
         b~vgbel
         b~aubel
         b~aupos
         b~matnr
         b~vkgrp
         b~vkbur
         INTO CORRESPONDING FIELDS OF TABLE it_sale
         FROM vbrk AS a INNER JOIN vbrp AS b ON a~vbeln = b~vbeln
         WHERE a~fkdat IN s_dt
          AND a~vbtyp IN s_vbtyp
          AND a~fksto NE 'X'
          AND a~fkart IN s_fkart.

  IF sy-subrc <> 0.
    MESSAGE 'No Data found'
      TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE  LIST-PROCESSING.
  ENDIF.


  IF it_sale[] IS NOT INITIAL.
    SELECT knumv      "Number of the document condition
           kposn      "Condition item number
           kschl      "Condition type
           kbetr      "Rate (condition amount or percentage)
           kstat      "Condition for statistic
           kwert      "Condition value
          from PRCD_ELEMENTS "FROM konv
           INTO TABLE it_konv
           FOR ALL ENTRIES IN it_sale
           WHERE knumv EQ it_sale-knumv
             AND kposn EQ it_sale-posnr.

    SELECT spras
           kschl
           vtext
      FROM t685t
      INTO TABLE it_t685t
      FOR ALL ENTRIES IN it_konv
           WHERE kschl EQ it_konv-kschl
             AND spras EQ 'E'.


    SELECT spras
           ktgrd
           vtext
      FROM tvktt
      INTO CORRESPONDING FIELDS OF TABLE it_tvktt
      FOR ALL ENTRIES IN it_sale
         WHERE ktgrd EQ it_sale-ktgrd.


    SELECT matnr
           maktx
    INTO TABLE it_makt
    FROM makt
    FOR ALL ENTRIES IN it_sale
    WHERE matnr = it_sale-matnr AND
          spras EQ 'EN'.

    SELECT kunnr land1 name1 ort01 pstlz regio stras adrnr
    INTO TABLE it_kna1
    FROM kna1
    FOR ALL ENTRIES IN it_sale
*    WHERE KUNNR = IT_SALE-KUNRG.
    WHERE kunnr = it_sale-kunag.

    CLEAR: wa_kna1, it_t005u.
    REFRESH it_t005u.

*    LOOP AT IT_KNA1 INTO WA_KNA1.
*    SELECT SINGLE * INTO WA_T005U FROM T005U
*                    WHERE SPRAS EQ 'EN'
*                    AND LAND1 = WA_KNA1-LAND1
*                    AND BLAND = WA_KNA1-REGIO.
*    ENDLOOP.

    SELECT  * INTO TABLE it_t005u FROM t005u
                   FOR ALL ENTRIES IN it_kna1
                   WHERE spras EQ 'EN'
                   AND land1 = it_kna1-land1
                   AND bland = it_kna1-regio.



*    SELECT kunnr j_1icstno j_1ilstno INTO CORRESPONDING FIELDS OF TABLE it_mocust
    SELECT kunnr j_1icstno j_1ilstno j_1isern INTO CORRESPONDING FIELDS OF TABLE it_mocust
    FROM j_1imocust
    FOR ALL ENTRIES IN it_sale
    WHERE kunnr = it_sale-kunrg.

    SELECT * FROM tvkbt     " Not Required
    INTO TABLE it_tvkbt
    FOR ALL ENTRIES IN it_sale
    WHERE vkbur = it_sale-vkbur AND
          spras EQ 'EN'.

    SELECT * FROM tspat
    INTO TABLE it_tspat
    FOR ALL ENTRIES IN it_sale
    WHERE spart = it_sale-spart AND
          spras EQ 'EN'.

    SELECT * FROM tvgrt
    INTO TABLE it_tvgrt
    FOR ALL ENTRIES IN it_sale
    WHERE vkgrp = it_sale-vkgrp AND
          spras EQ 'EN'.

    SELECT * FROM vbkd
    INTO TABLE it_vbkd
    FOR ALL ENTRIES IN it_sale
    WHERE vbeln = it_sale-vbeln.

    SELECT * FROM tvtwt
    INTO TABLE it_tvtwt
    FOR ALL ENTRIES IN it_sale
    WHERE vtweg = it_sale-vtweg AND
          spras EQ 'EN'.

    SELECT exnum rdoc exdat expind FROM j_1iexchdr
           INTO CORRESPONDING FIELDS OF TABLE it_exchdr
           FOR ALL ENTRIES IN it_sale
           WHERE rdoc  = it_sale-vbeln AND status  = 'C'.
*    AND GJAHR = S_DT+4(4)


    SELECT * FROM vbkd
    INTO TABLE it_vbkd
    FOR ALL ENTRIES IN it_sale
    WHERE vbeln = it_sale-aubel.


    SELECT matnr
           j_1ichid
           FROM j_1imtchid
           INTO TABLE it_chpt
           FOR ALL ENTRIES IN it_sale
           WHERE matnr = it_sale-matnr.

    SELECT vbeln
           bolnr
           traid
           FROM likp
           INTO TABLE it_likp
           FOR ALL ENTRIES IN it_sale
           WHERE vbeln = it_sale-vgbel.

    SELECT
            addrnumber
            name1
            city1
            post_code1
            street
            str_suppl1
            str_suppl2
      FROM  adrc
      INTO CORRESPONDING FIELDS OF TABLE it_adrc
      FOR ALL ENTRIES IN it_kna1
      WHERE addrnumber = it_kna1-adrnr.
******


  ENDIF.
  CLEAR: it_sale_data , it_sale_credit , it_sale_debit.
  REFRESH : it_sale_data , it_sale_credit , it_sale_debit.

  LOOP AT it_sale INTO wa_sale.
    CLEAR wa_sale_data.
    LOOP AT it_konv WHERE knumv = wa_sale-knumv AND
                          kposn = wa_sale-posnr.


      CASE it_konv-kschl.
        WHEN 'ZPR0'. "OR 'ZPR2' OR 'ZPR3' OR 'ZPR4' OR 'ZPR5' OR 'ZPR6' OR 'ZPR7'. "NET PRICE
          IF wa_sale-waerk EQ 'INR'.
            wa_data-netprice = it_konv-kwert.
            g_netprice = wa_data-netprice.
          ELSE.
            wa_data-netprice = it_konv-kwert * wa_sale-kurrf.
            g_netprice = wa_data-netprice.
          ENDIF.

*        WHEN 'ZPFO'.
*          IF WA_SALE-WAERK EQ 'INR'.
*          WA_DATA-PFCRG =  IT_KONV-KWERT.
*          ELSE.
*            WA_DATA-PFCRG = IT_KONV-KWERT * WA_SALE-KURRF.
*            G_NETPRICE = WA_DATA-PFCRG.
*          ENDIF.

        WHEN 'ZAS1' OR 'ZASS'.
          IF wa_sale-waerk EQ 'INR'.
            wa_data-asseble = it_konv-kwert.
          ELSE.
            wa_data-asseble = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'ZDIS'.         "DISCOUNT
          IF wa_sale-waerk EQ 'INR'.
            wa_data-dcount = it_konv-kwert.
          ELSE.
            wa_data-dcount = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'ZEXP'.
          IF it_konv-kstat <> 'X'.                           "BASIC EXCISE DUTY.
            IF wa_sale-waerk EQ 'INR'.
              wa_data-excise = it_konv-kwert.
              wa_data-bedrate = it_konv-kbetr / 10.
            ELSE.
              wa_data-excise = it_konv-kwert * wa_sale-kurrf.
            ENDIF.
          ELSEIF it_konv-kstat = 'X'.
            CLEAR wa_data-excise .
          ENDIF.


        WHEN 'ZCEP'.                        "EDUCATION CESS
          IF it_konv-kstat <> 'X'.
            IF wa_sale-waerk EQ 'INR'.
              wa_data-ecess = it_konv-kwert.
              wa_data-ecessrate = it_konv-kbetr / 10.
            ELSE.
              wa_data-ecess = it_konv-kwert * wa_sale-kurrf.
            ENDIF.
          ELSEIF it_konv-kstat = 'X'.
            CLEAR wa_data-ecess .
          ENDIF.



        WHEN 'ZCEH'  .                        "S&H EDUCATION CESS
          IF it_konv-kstat <> 'X'.
            IF wa_sale-waerk EQ 'INR'.
              wa_data-shcess = it_konv-kwert.
              wa_data-kbetr2 = it_konv-kbetr / 10.
            ELSE.
              wa_data-shcess = it_konv-kwert * wa_sale-kurrf.
            ENDIF.
          ELSEIF it_konv-kstat = 'X'.
            CLEAR wa_data-shcess .
          ENDIF.


***for service orcer
        WHEN 'ZSEC'.                        "EDUCATION CESS
          IF it_konv-kstat <> 'X'.
            IF wa_sale-waerk EQ 'INR'.
              wa_data-ecess = it_konv-kwert.
              wa_data-ecessrate = it_konv-kbetr / 10.
            ELSE.
              wa_data-ecess = it_konv-kwert * wa_sale-kurrf.
            ENDIF.
          ELSEIF it_konv-kstat = 'X'.
            CLEAR wa_data-ecess .
          ENDIF.



        WHEN 'ZSHC'  .                        "S&H EDUCATION CESS
          IF it_konv-kstat <> 'X'.
            IF wa_sale-waerk EQ 'INR'.
              wa_data-shcess = it_konv-kwert.
              wa_data-kbetr2 = it_konv-kbetr / 10.
            ELSE.
              wa_data-shcess = it_konv-kwert * wa_sale-kurrf.
            ENDIF.
          ELSEIF it_konv-kstat = 'X'.
            CLEAR wa_data-shcess .
          ENDIF.

        WHEN 'ZSER'.                        " Service Tax
          IF it_konv-kstat <> 'X'.
            IF wa_sale-waerk EQ 'INR'.
              wa_data-excise = it_konv-kwert.
              wa_data-bedrate = it_konv-kbetr / 10.
            ELSE.
              wa_data-excise = it_konv-kwert * wa_sale-kurrf.
            ENDIF.
          ELSEIF it_konv-kstat = 'X'.
            CLEAR wa_data-excise .
          ENDIF.

*********
        WHEN 'ZCST'.               "CENTRAL SALES TAX
          IF wa_sale-waerk EQ 'INR'.
            wa_data-csaltax = it_konv-kwert.
          ELSE.
            wa_data-csaltax = it_konv-kwert * wa_sale-kurrf.
          ENDIF.
          wa_data-kbetr1  = it_konv-kbetr / 10.


        WHEN 'ZLST'.               "VAT
          IF wa_sale-waerk EQ 'INR'.
            wa_data-vat = it_konv-kwert.
          ELSE.
            wa_data-vat = it_konv-kwert * wa_sale-kurrf.
          ENDIF.
*          WA_DATA-KBETR1 = IT_KONV-KBETR / 10.
          wa_data-vat = it_konv-kbetr / 10.


        WHEN 'ZFR1'. " OR 'ZFR2'. "'ZFRT'.    "FRIEGHT Taxable
          IF wa_sale-waerk EQ 'INR'.
            wa_data-frt = it_konv-kwert.
          ELSE.
            wa_data-frt = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'ZFR2'.     "FRIEGHT Non Taxable
          IF wa_sale-waerk EQ 'INR'.
            wa_data-n_tax_frt = it_konv-kwert.
          ELSE.
            wa_data-n_tax_frt = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

*        WHEN 'ZFW1' OR 'ZFW2' OR 'ZPKG'.
        WHEN 'ZPFO'.
          IF wa_sale-waerk EQ 'INR'.
            wa_data-pfcrg = it_konv-kwert.
          ELSE.
            wa_data-pfcrg = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'ZIN1'. " OR 'ZIN2' OR 'ZIN3'.
          IF wa_sale-waerk EQ 'INR'.        "'ZINS'.    "INSURANCE
            wa_data-insu = it_konv-kwert.
          ELSE.
            wa_data-insu = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

**non taxable freight
        WHEN 'ZIN2'. " OR 'ZIN2' OR 'ZIN3'.
*          clear : NTAX_INSU.
          IF wa_sale-waerk EQ 'INR'.        "'ZINS'.    "INSURANCE
            wa_data-insu = it_konv-kwert.
          ELSE.
            wa_data-insu = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

*SUM TAXABLE AND NONTAXABLE INSURANCE


        WHEN 'JWTS'.                               " TCS  JWTS
          IF wa_sale-waerk EQ 'INR'.
            wa_data-tcs = it_konv-kwert.
          ELSE.
            wa_data-tcs = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'ZWEC'.
          CLEAR lv_tcs.                              " TCS ZWEC
          IF wa_sale-waerk EQ 'INR'.
            lv_tcs = it_konv-kwert.
            wa_data-tcs = wa_data-tcs + lv_tcs.
          ELSE.
            lv_tcs = it_konv-kwert * wa_sale-kurrf.
            wa_data-tcs = wa_data-tcs + lv_tcs.
          ENDIF.

        WHEN 'ZWSC'.
          CLEAR lv_tcs.                              " TCS ZWSC
          IF wa_sale-waerk EQ 'INR'.
            lv_tcs = it_konv-kwert.
            wa_data-tcs = wa_data-tcs + lv_tcs.
          ELSE.
            lv_tcs = it_konv-kwert * wa_sale-kurrf.
            wa_data-tcs = wa_data-tcs + lv_tcs.
          ENDIF.

        WHEN 'ZWSE'.
          CLEAR lv_tcs.                              " TCS ZWSE.
          IF wa_sale-waerk EQ 'INR'.
            lv_tcs = it_konv-kwert.
            wa_data-tcs = wa_data-tcs + lv_tcs.
          ELSE.
            lv_tcs = it_konv-kwert * wa_sale-kurrf.
            wa_data-tcs = wa_data-tcs + lv_tcs.
          ENDIF.

        WHEN 'ZTC2'.
          IF wa_sale-waerk EQ 'INR'.
            wa_data-tst_chr = it_konv-kwert.
          ELSE.
            wa_data-tst_chr = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'ZOT1' OR 'ZOT2' OR 'ZOT3'.
          IF wa_sale-waerk EQ 'INR'.
            wa_data-other = it_konv-kwert.
          ELSE.
            wa_data-other = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'ZITX'.
          IF wa_sale-waerk EQ 'INR'.
            wa_data-itax = it_konv-kwert.
          ELSE.
            wa_data-itax = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'ZE&C'.
          IF wa_sale-waerk EQ 'INR'.
            wa_data-eandc = it_konv-kwert.
          ELSE.
            wa_data-eandc = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'ZLOC'.
          IF wa_sale-waerk EQ 'INR'.
            wa_data-local = it_konv-kwert.
          ELSE.
            wa_data-local = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'ZTRV'.
          IF wa_sale-waerk EQ 'INR'.
            wa_data-toandfro = it_konv-kwert.
          ELSE.
            wa_data-toandfro = it_konv-kwert * wa_sale-kurrf.
          ENDIF.

        WHEN 'JA1X'.
          IF wa_sale-waerk EQ 'INR'.
            wa_data-shcess = it_konv-kwert.
          ELSE.
            wa_data-shcess = it_konv-kwert * wa_sale-kurrf.
          ENDIF.
          wa_data-kbetr2  = it_konv-kbetr / 10.

*----READING TAX TYPE FROM IT_T685T TABLE
*          READ TABLE IT_T685T INTO WA_T685T WITH KEY KSCHL = IT_KONV-KSCHL.
*
*          IF SY-SUBRC EQ 0.
*               WA_DATA-TAX = WA_T685T-VTEXT.
*          ENDIF.
*
*          WHEN 'ZCST'.
*                        "CENTRAL SALES TAX
*          IF WA_SALE-WAERK EQ 'INR'.
*            WA_DATA-CSALTAX = IT_KONV-KWERT.
*          ELSE.
*            WA_DATA-CSALTAX = IT_KONV-KWERT * WA_SALE-KURRF.
*          ENDIF.
*          WA_DATA-KBETR1  = IT_KONV-KBETR / 10.
*
*
**          IF WA_DATA-KBETR1 IS INITIAL.
*
*        WHEN 'ZLST'.               "VAT
*                IF WA_SALE-WAERK EQ 'INR'.
*                  WA_DATA-VAT = IT_KONV-KWERT.
*                ELSE.
*                  WA_DATA-VAT = IT_KONV-KWERT * WA_SALE-KURRF.
*                ENDIF.
*               WA_DATA-KBETR1 = IT_KONV-KBETR / 10.
      ENDCASE.


      IF wa_data-netprice EQ 0.
        wa_data-netprice = wa_data-asseble.
      ENDIF.

      IF wa_data-asseble EQ 0 AND wa_data-dcount NE 0.
        wa_data-asseble = wa_data-netprice + wa_data-dcount.
      ENDIF.
*************************************************************
      wa_data-gr_amt = wa_data-netprice +  wa_data-dcount +  wa_data-excise + wa_data-ecess +
                       wa_data-stax + wa_data-eceser + wa_data-csaltax + wa_data-vat + wa_data-frt +
                       wa_data-insu + wa_data-other + wa_data-itax  + wa_data-eandc + wa_data-local +
                       wa_data-toandfro +  wa_data-pfcrg + wa_data-repr +  wa_data-shcess.
      AT END OF kposn.
        IF wa_data-asseble EQ 0.
          wa_data-asseble = g_netprice.
          wa_data-tax_amt = wa_data-asseble *  wa_data-kbetr1 / 100 .


        ENDIF.
        wa_data-asscstvat = wa_data-netprice + wa_data-excise + wa_data-ecess  + wa_data-shcess.
        wa_data-gross_amt = wa_data-asscstvat + wa_data-tax_amt.
        CLEAR g_netprice.
      ENDAT.

*      READ TABLE IT_T685T INTO WA_T685T WITH KEY KSCHL = IT_KONV-KSCHL.
*      IF SY-SUBRC EQ 0.
*        WA_DATA-TAX = WA_T685T-VTEXT.
*      ENDIF.

      CLEAR it_konv.


      READ TABLE it_vbkd WITH KEY vbeln = wa_sale-aubel.
      IF sy-subrc = 0.
        wa_sale-bstkd = it_vbkd-bstkd.
      ENDIF.
      MODIFY it_sale FROM wa_sale TRANSPORTING bstkd.

    ENDLOOP. " LOOP AT KONV FOR A ITEM

*-------CODE FOR Tax Amount

    CLEAR: lv_tax_amt, tot_tax_amt, tot_tax_amt2 .

*    select  KBETR from KONV into  LV_TAX_AMT
    SELECT  kwert FROM prcd_elements INTO  lv_tax_amt
        WHERE knumv = wa_sale-knumv
*        AND KPOSN EQ IT_KONV-KPOSN
        AND kschl IN s_kschl.
      tot_tax_amt = tot_tax_amt + lv_tax_amt.
    ENDSELECT.

    CLEAR lv_tax_amt.
    SELECT  kwert FROM prcd_elements INTO  lv_tax_amt
        WHERE knumv = wa_sale-knumv
        AND kposn = wa_sale-posnr
        AND kschl IN s_kschl.
      tot_tax_amt2 = tot_tax_amt2 + lv_tax_amt.
    ENDSELECT.


*-------CODE FOR TAX TYPE
    CLEAR it_konv.
    READ TABLE it_konv WITH KEY kschl = 'ZCST'
                                knumv = wa_sale-knumv. "NOT KWERT IS INITIAL.


    IF sy-subrc NE 0 OR it_konv-kwert IS INITIAL.
      READ TABLE it_konv WITH KEY kschl = 'ZLST'
                                  knumv = wa_sale-knumv.
    ENDIF.
    IF NOT it_konv IS INITIAL.
      READ TABLE it_t685t INTO wa_t685t WITH KEY kschl = it_konv-kschl.
      IF sy-subrc EQ 0.
        wa_data-tax = wa_t685t-vtext.
        tin_no = it_konv-kschl.
      ENDIF.
    ENDIF.
*-----------
    MOVE wa_sale-vbeln TO wa_data-vbeln.
    MOVE wa_sale-aubel TO wa_data-aubel.
*    if wa_sale-vtweg = 30.
*    MOVE wa_sale-aubel to LV_VGBEL.
*    endif.
    MOVE wa_sale-posnr TO wa_data-posnr.
    MOVE wa_sale-vtweg TO wa_data-vtweg.
    MOVE wa_sale-spart TO wa_data-spart.
    MOVE wa_sale-aubel TO wa_data-aubel.
    MOVE wa_sale-aupos TO wa_data-aupos.
    MOVE wa_sale-matnr TO wa_data-matnr.
    MOVE wa_sale-vkbur TO wa_data-vkbur.
    MOVE wa_sale-kunrg TO wa_data-kunrg.
    MOVE wa_sale-fkimg TO wa_data-fkimg.
    MOVE wa_sale-bstkd TO wa_data-bstkd.
    MOVE wa_sale-ktgrd TO wa_data-ktgrd.
    MOVE wa_sale-fkdat TO wa_data-fkdat.

    READ TABLE it_mocust WITH KEY kunnr = wa_data-kunrg.
    IF sy-subrc = 0.
      IF tin_no = 'ZCST'.
        wa_data-cstno = it_mocust-j_1icstno.
      ELSEIF tin_no = 'ZLST'.
        wa_data-cstno = it_mocust-j_1ilstno.
      ELSEIF tin_no = 'ZSER'.
        wa_data-cstno = it_mocust-j_1isern.
      ENDIF.
    ENDIF.

    READ TABLE it_makt WITH KEY matnr = wa_sale-matnr.
    IF sy-subrc EQ 0.
      MOVE it_makt-maktx TO wa_data-maktx.
    ENDIF.

    READ TABLE it_tvkbt WITH KEY vkbur = wa_sale-vkbur.
    IF sy-subrc EQ 0.
      MOVE it_tvkbt-bezei TO wa_data-vkbur.
    ENDIF.

    READ TABLE it_tspat WITH KEY spart = wa_sale-spart.
    IF sy-subrc EQ 0.
      MOVE it_tspat-vtext TO wa_data-spart.
    ENDIF.

    READ TABLE it_tvtwt WITH KEY vtweg = wa_sale-vtweg.
    IF sy-subrc EQ 0.
      MOVE it_tvtwt-vtext TO wa_data-vtweg.
    ENDIF.

    READ TABLE it_tvktt INTO wa_tvktt WITH KEY ktgrd = wa_sale-ktgrd
                                               spras = 'E'         .
    IF sy-subrc EQ 0.
      MOVE wa_tvktt-vtext TO wa_data-ktgrd.
      MOVE wa_tvktt-ktgrd TO wa_data-ledger.
    ENDIF.

    READ TABLE it_kna1 WITH KEY kunnr = wa_sale-kunrg.
    IF sy-subrc EQ 0.
      MOVE it_kna1-name1 TO wa_data-name1.
      MOVE it_kna1-adrnr TO wa_data-adrnr.
    ENDIF.

*    READ TABLE IT_ADRC INTO WA_ADRC WITH KEY  ADDRNUMBER = IT_KNA1-ADRNR.
    CLEAR wa_kna1.
    READ TABLE it_kna1 INTO wa_kna1 WITH KEY  kunnr = wa_sale-kunrg.
    IF sy-subrc EQ 0.
      SELECT SINGLE * INTO wa_t005u FROM t005u
                WHERE spras EQ 'EN'
                AND land1 = wa_kna1-land1
                AND bland = wa_kna1-regio.

      CONCATENATE wa_kna1-ort01
                  wa_kna1-pstlz
                  wa_kna1-stras
                  wa_t005u-bezei
             INTO address
             SEPARATED BY space.
      MOVE address TO wa_data-address.
    ENDIF.

    READ TABLE it_likp WITH KEY vbeln = wa_sale-vgbel.
    IF sy-subrc EQ 0.
      wa_data-bolnr = it_likp-bolnr.
      wa_data-traid = it_likp-traid.
    ENDIF.

    READ TABLE it_chpt WITH KEY matnr = wa_sale-matnr.
    IF sy-subrc EQ 0.
      wa_data-chapid = it_chpt-chapid.
    ENDIF.

    CLEAR it_exchdr.

    READ TABLE it_exchdr WITH KEY rdoc = wa_sale-vbeln.
    IF sy-subrc EQ 0.
      wa_data-exnum = it_exchdr-exnum.
      wa_data-exdat = it_exchdr-exdat.
    ENDIF.
*      modify it_data1 from wa_data1 TRANSPORTING EXNUM EXDAT.
*    if not wa_data-exnum is INITIAL.
*CLEAR EXCISE ECESS AND HECESS FOR CERTAIN RECORDS
    IF it_exchdr-expind = 'D'.
      IF  wa_tvktt-vtext IN s_ledger.
        wa_data-excise = space.
        wa_data-ecess  = space.
        wa_data-shcess = space.
      ENDIF.
    ELSEIF  it_exchdr-expind = 'U'.
      IF wa_tvktt-vtext = 'SALES-EXPORT (SEZ)'
         OR wa_tvktt-vtext = 'SALES - EXPORTS'.
        wa_data-excise = space.
        wa_data-ecess  = space.
        wa_data-shcess = space.
      ENDIF.
    ELSEIF  it_exchdr-expind = 'B'.
      IF wa_tvktt-vtext = 'SALES - EXPORTS'.
        wa_data-excise = space.
        wa_data-ecess  = space.
        wa_data-shcess = space.
      ENDIF.
    ENDIF.


    CLEAR: lv_awkey, lv_rdoc2,wa_acc_doc.
    BREAK fujiabap.
    lv_awkey = wa_sale-vbeln.
    SELECT SINGLE belnr FROM bkpf
    INTO wa_acc_doc
*    FOR ALL ENTRIES IN IT_SALE
    WHERE awkey = lv_awkey
      AND blart  = 'RV'." OR blart = 'YY'.

      IF wa_acc_doc IS INITIAL.

    SELECT SINGLE belnr FROM bkpf
    INTO wa_acc_doc
*    FOR ALL ENTRIES IN IT_SALE
    WHERE awkey = lv_awkey
      AND blart  = 'YY'.

     ENDIF.

    wa_data-belnr = wa_acc_doc-belnr.  " A/C DOC. NO.

    CLEAR wa_j_1iexcdtl.
    lv_rdoc2 = wa_sale-vbeln.
    SELECT SINGLE * FROM j_1iexcdtl
    INTO wa_j_1iexcdtl
    WHERE rdoc2 = lv_rdoc2.
*     = WA_J_1IEXCDTL-EXNUM.  "Tax Invoice No
*     = WA_J_1IEXCDTL-EXDAT.  "Tax Invoice Date
*for servic tax invoice
    IF sy-subrc = 4.
      CLEAR vbrk.
      SELECT SINGLE * FROM vbrk INTO wa_vbrk WHERE vbeln = wa_sale-vbeln.
      IF wa_vbrk-kalsm = 'ZSERSA'.
        wa_j_1iexcdtl-exnum  = wa_vbrk-vbeln.
        wa_j_1iexcdtl-exdat  = wa_vbrk-fkdat.
      ENDIF.
    ENDIF.
    MOVE wa_sale-vbeln       TO wa_sale_data-vbeln.
*    MOVE WA_SALE-VBTYP       TO WA_SALE_DATA-VBTYP.
    MOVE wa_sale-fkdat       TO wa_sale_data-fkdat.
    MOVE wa_data-belnr       TO wa_sale_data-acc_doc.
    MOVE wa_j_1iexcdtl-exnum TO wa_sale_data-tax_inv_no.
    MOVE wa_j_1iexcdtl-exdat TO wa_sale_data-inv_dt.
    MOVE wa_sale-aubel       TO wa_sale_data-sale_ord.
    MOVE wa_tvktt-vtext      TO wa_sale_data-ledger.
    MOVE wa_kna1-name1       TO wa_sale_data-name1.
    MOVE wa_data-address     TO wa_sale_data-cust_add.
*    MOVE WA_DATA-CSTNO(12)   TO WA_SALE_DATA-VAT_NO.
    IF wa_data-cstno IS NOT INITIAL.
      IF wa_data-cstno CS '/'.
        CLEAR lv_fdpos.
        lv_fdpos = sy-fdpos.
        MOVE wa_data-cstno(lv_fdpos)   TO wa_sale_data-vat_no.
        lv_fdpos = lv_fdpos + 1.
        MOVE wa_data-cstno+lv_fdpos    TO wa_sale_data-vat_wef.
      ELSE." if cst no does not contain any date
        MOVE wa_data-cstno   TO wa_sale_data-vat_no.
      ENDIF .
    ENDIF.
*    MOVE WA_DATA-CSTNO+13    TO WA_SALE_DATA-VAT_WEF.
    MOVE wa_data-netprice    TO wa_sale_data-basic.
    MOVE wa_data-pfcrg       TO wa_sale_data-p_f.
    MOVE wa_data-dcount      TO wa_sale_data-discount.
    wa_sale_data-ass_value = wa_sale_data-basic + wa_sale_data-p_f
                           - wa_sale_data-discount.
    MOVE wa_data-excise      TO wa_sale_data-excise.
    MOVE wa_data-ecess       TO wa_sale_data-e_cess.
    MOVE wa_data-shcess      TO wa_sale_data-he_cess.
    MOVE wa_data-frt         TO wa_sale_data-fright.
    wa_sale_data-sub_tot = wa_sale_data-ass_value + wa_sale_data-excise
                      + wa_sale_data-e_cess + wa_sale_data-he_cess
                      + wa_sale_data-fright.

*    MOVE WA_DATA-KBETR1 TO WA_SALE_DATA-VAT_CST.
    wa_sale_data-vat_cst = wa_data-kbetr1 + wa_data-vat.
    MOVE tot_tax_amt  TO wa_sale_data-tax_amt.    " Tax Amount
*    MOVE TOT_TAX_AMT2 TO WA_SALE_DATA-TAX_AMT.    " Tax Amount
    MOVE wa_data-tax  TO wa_sale_data-tax_typ.
    MOVE wa_data-insu TO wa_sale_data-insurance.
    MOVE wa_data-n_tax_frt TO wa_sale_data-n_tax_frt.
    MOVE wa_data-tst_chr TO wa_sale_data-tst_chr.
    MOVE wa_data-tcs    TO wa_sale_data-tcs.
    wa_sale_data-gross_amt = tot_tax_amt2 + wa_sale_data-insurance
                             + wa_sale_data-n_tax_frt + wa_sale_data-tst_chr
                             + wa_sale_data-tcs + wa_sale_data-discount
                             + wa_sale_data-sub_tot.
    IF wa_sale-vbtyp = 'M'.
      APPEND wa_sale_data TO it_sale_data.
    ELSEIF wa_sale-vbtyp = 'O'.
      APPEND wa_sale_data TO it_sale_credit.
    ELSEIF wa_sale-vbtyp = 'P'.
      APPEND wa_sale_data TO it_sale_debit.
    ENDIF.

*      modify it_data1 from wa_data1 TRANSPORTING exnum.
    CLEAR: wa_data,wa_sale, tin_no, wa_data1,wa_sale_data.
*    ENDIF.
  ENDLOOP.


  CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
          sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_tax_amt2,
          sum_insu, sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt .

  REFRESH it2_summary.

*  SORT IT_SALE_DATA BY VBELN  .
  SORT it_sale_data BY acc_doc  .
*DELETE MULTIPLE RECORDS FROM IT_SALE_DATA
*  DELETE ADJACENT DUPLICATES FROM IT_SALE_DATA COMPARING ACC_DOC.
  BREAK fujiabap.
  LOOP AT it_sale_data INTO wa_sale_data .

    sum_basic_amt   = sum_basic_amt + wa_sale_data-basic.
    sum_pfcrg       = sum_pfcrg     + wa_sale_data-p_f.
    sum_assess      = sum_assess    + wa_sale_data-ass_value.
    sum_excise      = sum_excise    + wa_sale_data-excise.
    sum_ecess       = sum_ecess     + wa_sale_data-e_cess.
    sum_shcess      = sum_shcess    + wa_sale_data-he_cess.
    sum_frt         = sum_frt       + wa_sale_data-fright + wa_sale_data-n_tax_frt.
    sum_sub_tot     = sum_sub_tot   + wa_sale_data-sub_tot.
*    SUM_ASSCSTVAT   = SUM_ASSCSTVAT + WA_SALE_DATA-VAT_CST.
    sum_asscstvat   =  wa_sale_data-vat_cst.
    sum_tax_amt     = sum_tax_amt   + wa_sale_data-tax_amt.
    sum_tax_amt2     =  wa_sale_data-tax_amt.
    sum_insu        = sum_insu      + wa_sale_data-insurance.
    sum_n_frt       = sum_n_frt     + wa_sale_data-n_tax_frt + wa_sale_data-fright.
    sum_tst_chr     = sum_tst_chr   + wa_sale_data-tst_chr.
    sum_dcount      = sum_dcount    + wa_sale_data-discount.
    sum_tcs         = sum_tcs       + wa_sale_data-tcs.
    sum_gross_amt   = sum_gross_amt + wa_sale_data-gross_amt.

    MOVE wa_sale_data-vbeln TO wa_2sale_data-vbeln.
    MOVE wa_sale_data-fkdat TO wa_2sale_data-fkdat.
    MOVE wa_sale_data-acc_doc TO wa_2sale_data-acc_doc.
    MOVE wa_sale_data-tax_inv_no TO wa_2sale_data-tax_inv_no.
    MOVE wa_sale_data-inv_dt TO wa_2sale_data-inv_dt.
    MOVE wa_sale_data-sale_ord TO wa_2sale_data-sale_ord.
    MOVE wa_sale_data-ledger TO wa_2sale_data-ledger.
    MOVE wa_sale_data-ledger TO wa2_summary-ledger.
*     WA2_SUMMARY-LEDGER = WA_SALE_DATA-LEDGER.
*clear sales order if distribution channel 30
*and multiple so clubbed in a single acc doc
*if wa_sale_data-ledger cS 'EXPORT'.
*  IF SY-TABIX = 1.
*    CLEAR LV_VGBEL.
*  LV_VGBEL = WA_SALE_DATA-SALE_ORD.
*  ENDIF.
*  IF LV_VGBEL <> WA_SALE_DATA-SALE_ORD.
*    WA_2SALE_DATA-SALE_ORD = SPACE.
*  ENDIF.
*  ENDIF.
    MOVE wa_sale_data-name1 TO wa_2sale_data-name1.
    MOVE wa_sale_data-cust_add TO wa_2sale_data-cust_add.
    MOVE wa_sale_data-vat_no TO wa_2sale_data-vat_no.
    MOVE wa_sale_data-vat_wef TO wa_2sale_data-vat_wef.
    MOVE wa_sale_data-tax_typ TO wa_2sale_data-tax_typ.

    AT END OF acc_doc.
*    AT END OF VBELN.

      MOVE sum_basic_amt   TO wa_2sale_data-basic.
      MOVE sum_pfcrg       TO wa_2sale_data-p_f.
      MOVE sum_dcount      TO wa_2sale_data-discount.
      MOVE sum_assess      TO wa_2sale_data-ass_value.
      MOVE sum_excise      TO wa_2sale_data-excise.
      MOVE sum_ecess       TO wa_2sale_data-e_cess.
      MOVE sum_shcess      TO wa_2sale_data-he_cess.
      MOVE sum_frt         TO wa_2sale_data-fright.
      MOVE sum_sub_tot     TO wa_2sale_data-sub_tot.
      MOVE sum_asscstvat   TO wa_2sale_data-vat_cst.
      MOVE sum_tax_amt2    TO wa_2sale_data-tax_amt.
      MOVE sum_insu        TO wa_2sale_data-insurance.
      MOVE sum_n_frt       TO wa_2sale_data-n_tax_frt.
      MOVE sum_tst_chr     TO wa_2sale_data-tst_chr.
      MOVE sum_tcs         TO wa_2sale_data-tcs.
      MOVE sum_gross_amt   TO wa_2sale_data-gross_amt.

      APPEND wa_2sale_data TO it_2sale_data.

*moving to another structure to sort by ledger
      MOVE sum_basic_amt   TO wa2_summary-basic.
      MOVE sum_pfcrg       TO wa2_summary-p_f.
      MOVE sum_dcount      TO wa2_summary-discount.
      MOVE sum_assess      TO wa2_summary-ass_value.
      MOVE sum_excise      TO wa2_summary-excise.
      MOVE sum_ecess       TO wa2_summary-e_cess.
      MOVE sum_shcess      TO wa2_summary-he_cess.
      MOVE sum_frt         TO wa2_summary-fright.
      MOVE sum_sub_tot     TO wa2_summary-sub_tot.
      MOVE sum_asscstvat   TO wa2_summary-vat_cst.
*      MOVE SPACE   TO WA2_SUMMARY-VAT_CST.
*      MOVE SUM_TAX_AMT     TO WA2_SUMMARY-TAX_AMT.
      MOVE sum_tax_amt2     TO wa2_summary-tax_amt.
      MOVE sum_insu        TO wa2_summary-insurance.
*      MOVE SUM_N_FRT       TO WA2_SUMMARY-N_TAX_FRT.
      MOVE sum_tst_chr     TO wa2_summary-tst_charg.
      MOVE sum_tcs         TO wa2_summary-tcs.
      MOVE sum_gross_amt   TO wa2_summary-gross_amt.
*       WA2_SUMMARY-LEDGER = WA_SALE_DATA-LEDGER.
      APPEND wa2_summary TO it2_summary.
*       WA_2sale_daa TO WA2_SUMMARY.

      CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
              sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
              sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt .

    ENDAT.

  ENDLOOP.

  CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
          sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
          sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt, wa2_summary, wa_2sale_data .

  CLEAR wa2_summary.
  REFRESH it_summary.
*  SORT IT_2SALE_DATA BY  LEDGER VBELN.
*  SORT IT_2SALE_DATA BY  LEDGER. " VBELN.
*  SORT IT2_SUMMARY BY  LEDGER. " VBELN.
  SORT it2_summary BY  ledger vat_cst. " VBELN.
  LOOP AT it2_summary INTO wa2_summary .

    sum_basic_amt   = sum_basic_amt + wa2_summary-basic.
    sum_pfcrg       = sum_pfcrg     + wa2_summary-p_f.
    sum_assess      = sum_assess    + wa2_summary-ass_value.
    sum_excise      = sum_excise    + wa2_summary-excise.
    sum_ecess       = sum_ecess     + wa2_summary-e_cess.
    sum_shcess      = sum_shcess    + wa2_summary-he_cess.
    sum_frt         = sum_frt       + wa2_summary-fright.
    sum_sub_tot     = sum_sub_tot   + wa2_summary-sub_tot.
*    SUM_ASSCSTVAT   = SUM_ASSCSTVAT + WA2_SUMMARY-VAT_CST.
    sum_asscstvat   =  wa2_summary-vat_cst.
    sum_tax_amt     = sum_tax_amt   + wa2_summary-tax_amt.
    sum_insu        = sum_insu      + wa2_summary-insurance.
*    SUM_N_FRT       = SUM_N_FRT     + WA2_SUMMARY-N_TAX_FRT.
    sum_tst_chr     = sum_tst_chr   + wa2_summary-tst_charg.
    sum_dcount      = sum_dcount    + wa2_summary-discount.
    sum_tcs         = sum_tcs       + wa2_summary-tcs.
    sum_gross_amt   = sum_gross_amt + wa2_summary-gross_amt.

*    AT END OF ledger.
    AT END OF vat_cst.
*on change of WA_DATA1-LEDGER.
      CLEAR wa_summary.
      MOVE wa2_summary-ledger TO wa_summary-ledger.
      MOVE sum_basic_amt   TO wa_summary-basic.
      MOVE sum_pfcrg       TO wa_summary-p_f.
      MOVE sum_assess      TO wa_summary-ass_value.
      MOVE sum_excise      TO wa_summary-excise.
      MOVE sum_ecess       TO wa_summary-e_cess.
      MOVE sum_shcess      TO wa_summary-he_cess.
      MOVE sum_frt         TO wa_summary-fright.
      MOVE sum_sub_tot     TO wa_summary-sub_tot.
      MOVE sum_asscstvat   TO wa_summary-vat_cst.
*      MOVE SPACE          TO WA_SUMMARY-VAT_CST.
      MOVE sum_tax_amt     TO wa_summary-tax_amt.
      MOVE sum_insu        TO wa_summary-insurance.
      MOVE sum_dcount      TO wa_summary-discount.
      MOVE sum_tcs         TO wa_summary-tcs.
      MOVE sum_tst_chr     TO wa_summary-tst_charg.
      MOVE sum_gross_amt   TO wa_summary-gross_amt.

      APPEND wa_summary TO it_summary.

      CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
          sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
          sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt, wa2_summary .

    ENDAT.
  ENDLOOP.

*************************FOR CREDIT*************************
  CLEAR: wa_sale_data, wa_2sale_data, wa2_summary.
  REFRESH: it_2sale_credit, it2_summary.
  SORT it_sale_credit BY acc_doc  .
  LOOP AT it_sale_credit INTO wa_sale_data .

    sum_basic_amt   = sum_basic_amt + wa_sale_data-basic.
    sum_pfcrg       = sum_pfcrg     + wa_sale_data-p_f.
    sum_assess      = sum_assess    + wa_sale_data-ass_value.
    sum_excise      = sum_excise    + wa_sale_data-excise.
    sum_ecess       = sum_ecess     + wa_sale_data-e_cess.
    sum_shcess      = sum_shcess    + wa_sale_data-he_cess.
    sum_frt         = sum_frt       + wa_sale_data-fright.
    sum_sub_tot     = sum_sub_tot   + wa_sale_data-sub_tot.
*    SUM_ASSCSTVAT   = SUM_ASSCSTVAT + WA_SALE_DATA-VAT_CST.
    sum_asscstvat   =  wa_sale_data-vat_cst.
*    SUM_TAX_AMT     = SUM_TAX_AMT   + WA_SALE_DATA-TAX_AMT.
    sum_tax_amt     =  wa_sale_data-tax_amt.
    sum_insu        = sum_insu      + wa_sale_data-insurance.
    sum_n_frt       = sum_n_frt     + wa_sale_data-n_tax_frt.
    sum_tst_chr     = sum_tst_chr   + wa_sale_data-tst_chr.
    sum_dcount      = sum_dcount    + wa_sale_data-discount.
    sum_tcs         = sum_tcs       + wa_sale_data-tcs.
    sum_gross_amt   = sum_gross_amt + wa_sale_data-gross_amt.

    MOVE wa_sale_data-vbeln TO wa_2sale_data-vbeln.
    MOVE wa_sale_data-acc_doc TO wa_2sale_data-acc_doc.
    MOVE wa_sale_data-fkdat TO wa_2sale_data-fkdat.
    MOVE wa_sale_data-tax_inv_no TO wa_2sale_data-tax_inv_no.
    MOVE wa_sale_data-inv_dt TO wa_2sale_data-inv_dt.
    MOVE wa_sale_data-sale_ord TO wa_2sale_data-sale_ord.
    MOVE wa_sale_data-ledger TO wa_2sale_data-ledger.
    MOVE wa_sale_data-ledger TO wa2_summary-ledger.
    MOVE wa_sale_data-name1 TO wa_2sale_data-name1.
    MOVE wa_sale_data-cust_add TO wa_2sale_data-cust_add.
    MOVE wa_sale_data-vat_no TO wa_2sale_data-vat_no.
    MOVE wa_sale_data-vat_wef TO wa_2sale_data-vat_wef.
    MOVE wa_sale_data-tax_typ TO wa_2sale_data-tax_typ.

    AT END OF acc_doc.

      MOVE sum_basic_amt   TO wa_2sale_data-basic.
      MOVE sum_pfcrg       TO wa_2sale_data-p_f.
      MOVE sum_dcount      TO wa_2sale_data-discount.
      MOVE sum_assess      TO wa_2sale_data-ass_value.
      MOVE sum_excise      TO wa_2sale_data-excise.
      MOVE sum_ecess       TO wa_2sale_data-e_cess.
      MOVE sum_shcess      TO wa_2sale_data-he_cess.
      MOVE sum_frt         TO wa_2sale_data-fright.
      MOVE sum_sub_tot     TO wa_2sale_data-sub_tot.
      MOVE sum_asscstvat   TO wa_2sale_data-vat_cst.
      MOVE sum_tax_amt     TO wa_2sale_data-tax_amt.
      MOVE sum_insu        TO wa_2sale_data-insurance.
      MOVE sum_n_frt       TO wa_2sale_data-n_tax_frt.
      MOVE sum_tst_chr     TO wa_2sale_data-tst_chr.
      MOVE sum_tcs         TO wa_2sale_data-tcs.
      MOVE sum_gross_amt   TO wa_2sale_data-gross_amt.

      APPEND wa_2sale_data TO it_2sale_credit.
*      APPEND WA_DATA1 TO IT_DATA1.

*moving to another structure to sort by ledger
      MOVE sum_basic_amt   TO wa2_summary-basic.
      MOVE sum_pfcrg       TO wa2_summary-p_f.
      MOVE sum_dcount      TO wa2_summary-discount.
      MOVE sum_assess      TO wa2_summary-ass_value.
      MOVE sum_excise      TO wa2_summary-excise.
      MOVE sum_ecess       TO wa2_summary-e_cess.
      MOVE sum_shcess      TO wa2_summary-he_cess.
      MOVE sum_frt         TO wa2_summary-fright.
      MOVE sum_sub_tot     TO wa2_summary-sub_tot.
      MOVE sum_asscstvat   TO wa2_summary-vat_cst.
      MOVE sum_tax_amt     TO wa2_summary-tax_amt.
      MOVE sum_insu        TO wa2_summary-insurance.
*      MOVE SUM_N_FRT       TO WA2_SUMMARY-N_TAX_FRT.
      MOVE sum_tst_chr     TO wa2_summary-tst_charg.
      MOVE sum_tcs         TO wa2_summary-tcs.
      MOVE sum_gross_amt   TO wa2_summary-gross_amt.

      APPEND wa2_summary TO it2_summary.


      CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
              sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
              sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt, wa2_summary .

    ENDAT.
  ENDLOOP. " CREDIT

*CREDIT SUMMARY
  CLEAR: wa_2sale_data, wa2_summary.
  REFRESH it_cr_summary.
*  SORT IT_2SALE_CREDIT BY  LEDGER VBELN.
*  SORT IT_2SALE_CREDIT BY  LEDGER." VBELN.
*  SORT IT2_SUMMARY BY  LEDGER." VBELN.
  SORT it2_summary BY  ledger vat_cst.

  LOOP AT it2_summary INTO wa2_summary .

    sum_basic_amt   = sum_basic_amt + wa2_summary-basic.
    sum_pfcrg       = sum_pfcrg     + wa2_summary-p_f.
    sum_assess      = sum_assess    + wa2_summary-ass_value.
    sum_excise      = sum_excise    + wa2_summary-excise.
    sum_ecess       = sum_ecess     + wa2_summary-e_cess.
    sum_shcess      = sum_shcess    + wa2_summary-he_cess.
    sum_frt         = sum_frt       + wa2_summary-fright.
    sum_sub_tot     = sum_sub_tot   + wa2_summary-sub_tot.
*    SUM_ASSCSTVAT   = SUM_ASSCSTVAT + WA2_SUMMARY-VAT_CST.
    sum_asscstvat   =  wa2_summary-vat_cst.
    sum_tax_amt     = sum_tax_amt   + wa2_summary-tax_amt.
    sum_insu        = sum_insu      + wa2_summary-insurance.
*    SUM_N_FRT       = SUM_N_FRT     + WA2_SUMMARY-N_TAX_FRT.
    sum_tst_chr     = sum_tst_chr   + wa2_summary-tst_charg.
    sum_dcount      = sum_dcount    + wa2_summary-discount.
    sum_tcs         = sum_tcs       + wa2_summary-tcs.
    sum_gross_amt   = sum_gross_amt + wa2_summary-gross_amt.

*MOVE WA2_SUMMARY-ledger TO WA_SUMMARY-ledger.
*    AT END OF ledger.
    AT END OF vat_cst.
*on change of LEDGER.
      CLEAR wa_summary.
*      MOVE WA2_SUMMARY-ledger TO WA_SUMMARY-ledger.
      MOVE sum_basic_amt   TO wa_summary-basic.
      MOVE sum_pfcrg       TO wa_summary-p_f.
      MOVE sum_assess      TO wa_summary-ass_value.
      MOVE sum_excise      TO wa_summary-excise.
      MOVE sum_ecess       TO wa_summary-e_cess.
      MOVE sum_shcess      TO wa_summary-he_cess.
      MOVE sum_frt         TO wa_summary-fright.
      MOVE sum_sub_tot     TO wa_summary-sub_tot.
      MOVE sum_asscstvat   TO wa_summary-vat_cst.
      MOVE sum_tax_amt     TO wa_summary-tax_amt.
      MOVE sum_insu        TO wa_summary-insurance.
      MOVE sum_dcount      TO wa_summary-discount.
      MOVE sum_tcs         TO wa_summary-tcs.
      MOVE sum_tst_chr     TO wa_summary-tst_charg.
      MOVE sum_gross_amt   TO wa_summary-gross_amt.
      MOVE wa2_summary-ledger TO wa_summary-ledger.
      APPEND wa_summary TO it_cr_summary.

      CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
          sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
          sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt , wa_summary.

    ENDAT.
  ENDLOOP.

*************************FOR DEBIT*************************
  CLEAR: wa_sale_data, wa_2sale_data ,wa2_summary.
  REFRESH : it_2sale_debit, it2_summary.
*  SORT IT_SALE_DEBIT BY VBELN  .
  SORT it_sale_debit BY acc_doc  .
  LOOP AT it_sale_debit INTO wa_sale_data .

    sum_basic_amt   = sum_basic_amt + wa_sale_data-basic.
    sum_pfcrg       = sum_pfcrg     + wa_sale_data-p_f.
    sum_assess      = sum_assess    + wa_sale_data-ass_value.
    sum_excise      = sum_excise    + wa_sale_data-excise.
    sum_ecess       = sum_ecess     + wa_sale_data-e_cess.
    sum_shcess      = sum_shcess    + wa_sale_data-he_cess.
    sum_frt         = sum_frt       + wa_sale_data-fright.
    sum_sub_tot     = sum_sub_tot   + wa_sale_data-sub_tot.
    sum_asscstvat   = wa_sale_data-vat_cst.
*    SUM_TAX_AMT     = SUM_TAX_AMT   + WA_SALE_DATA-TAX_AMT.
    sum_tax_amt     =  wa_sale_data-tax_amt.
    sum_insu        = sum_insu      + wa_sale_data-insurance.
    sum_n_frt       = sum_n_frt     + wa_sale_data-n_tax_frt.
    sum_tst_chr     = sum_tst_chr   + wa_sale_data-tst_chr.
    sum_dcount      = sum_dcount    + wa_sale_data-discount.
    sum_tcs         = sum_tcs       + wa_sale_data-tcs.
    sum_gross_amt   = sum_gross_amt + wa_sale_data-gross_amt.

    MOVE wa_sale_data-vbeln TO wa_2sale_data-vbeln.
    MOVE wa_sale_data-acc_doc TO wa_2sale_data-acc_doc.
    MOVE wa_sale_data-fkdat TO wa_2sale_data-fkdat.
    MOVE wa_sale_data-tax_inv_no TO wa_2sale_data-tax_inv_no.
    MOVE wa_sale_data-inv_dt TO wa_2sale_data-inv_dt.
    MOVE wa_sale_data-sale_ord TO wa_2sale_data-sale_ord.
    MOVE wa_sale_data-ledger TO wa_2sale_data-ledger.
    MOVE wa_sale_data-ledger TO wa2_summary-ledger.
    MOVE wa_sale_data-name1 TO wa_2sale_data-name1.
    MOVE wa_sale_data-cust_add TO wa_2sale_data-cust_add.
    MOVE wa_sale_data-vat_no TO wa_2sale_data-vat_no.
    MOVE wa_sale_data-vat_wef TO wa_2sale_data-vat_wef.
    MOVE wa_sale_data-tax_typ TO wa_2sale_data-tax_typ.

    AT END OF acc_doc.

      MOVE sum_basic_amt   TO wa_2sale_data-basic.
      MOVE sum_pfcrg       TO wa_2sale_data-p_f.
      MOVE sum_dcount      TO wa_2sale_data-discount.
      MOVE sum_assess      TO wa_2sale_data-ass_value.
      MOVE sum_excise      TO wa_2sale_data-excise.
      MOVE sum_ecess       TO wa_2sale_data-e_cess.
      MOVE sum_shcess      TO wa_2sale_data-he_cess.
      MOVE sum_frt         TO wa_2sale_data-fright.
      MOVE sum_sub_tot     TO wa_2sale_data-sub_tot.
      MOVE sum_asscstvat   TO wa_2sale_data-vat_cst.
      MOVE sum_tax_amt     TO wa_2sale_data-tax_amt.
      MOVE sum_insu        TO wa_2sale_data-insurance.
      MOVE sum_n_frt       TO wa_2sale_data-n_tax_frt.
      MOVE sum_tst_chr     TO wa_2sale_data-tst_chr.
      MOVE sum_tcs         TO wa_2sale_data-tcs.
      MOVE sum_gross_amt   TO wa_2sale_data-gross_amt.

      APPEND wa_2sale_data TO it_2sale_debit.

*moving to another structure to sort by ledger
      MOVE sum_basic_amt   TO wa2_summary-basic.
      MOVE sum_pfcrg       TO wa2_summary-p_f.
      MOVE sum_dcount      TO wa2_summary-discount.
      MOVE sum_assess      TO wa2_summary-ass_value.
      MOVE sum_excise      TO wa2_summary-excise.
      MOVE sum_ecess       TO wa2_summary-e_cess.
      MOVE sum_shcess      TO wa2_summary-he_cess.
      MOVE sum_frt         TO wa2_summary-fright.
      MOVE sum_sub_tot     TO wa2_summary-sub_tot.
      MOVE sum_asscstvat   TO wa2_summary-vat_cst.
      MOVE sum_tax_amt     TO wa2_summary-tax_amt.
      MOVE sum_insu        TO wa2_summary-insurance.
*      MOVE SUM_N_FRT       TO WA2_SUMMARY-N_TAX_FRT.
      MOVE sum_tst_chr     TO wa2_summary-tst_charg.
      MOVE sum_tcs         TO wa2_summary-tcs.
      MOVE sum_gross_amt   TO wa2_summary-gross_amt.

      APPEND wa2_summary TO it2_summary.

      CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
              sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
              sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt .

    ENDAT.
  ENDLOOP. " DEBIT

*DEBIT SUMMARY
  CLEAR: wa_2sale_data, wa2_summary.
  REFRESH : it_db_summary.
*  SORT IT_2SALE_DEBIT BY  LEDGER VBELN.
*  SORT IT_2SALE_DEBIT BY  LEDGER. " VBELN.
*  SORT IT2_SUMMARY BY  LEDGER. " VBELN.
  SORT it2_summary BY  ledger vat_cst. " VBELN.
  LOOP AT it2_summary INTO wa2_summary .

    sum_basic_amt   = sum_basic_amt + wa2_summary-basic.
    sum_pfcrg       = sum_pfcrg     + wa2_summary-p_f.
    sum_assess      = sum_assess    + wa2_summary-ass_value.
    sum_excise      = sum_excise    + wa2_summary-excise.
    sum_ecess       = sum_ecess     + wa2_summary-e_cess.
    sum_shcess      = sum_shcess    + wa2_summary-he_cess.
    sum_frt         = sum_frt       + wa2_summary-fright.
    sum_sub_tot     = sum_sub_tot   + wa2_summary-sub_tot.
    sum_asscstvat   =  wa2_summary-vat_cst.
    sum_tax_amt     = sum_tax_amt   + wa2_summary-tax_amt.
    sum_insu        = sum_insu      + wa2_summary-insurance.
*    SUM_N_FRT       = SUM_N_FRT     + WA2_SUMMARY-N_TAX_FRT.
    sum_tst_chr     = sum_tst_chr   + wa2_summary-tst_charg.
    sum_dcount      = sum_dcount    + wa2_summary-discount.
    sum_tcs         = sum_tcs       + wa2_summary-tcs.
    sum_gross_amt   = sum_gross_amt + wa2_summary-gross_amt.

*MOVE WA2_SUMMARY-ledger TO WA_SUMMARY-ledger.
*    AT END OF ledger.
    AT END OF vat_cst .
*on change of LEDGER.
      CLEAR wa_summary.
*      MOVE WA2_SUMMARY-ledger TO WA_SUMMARY-ledger.
      MOVE sum_basic_amt   TO wa_summary-basic.
      MOVE sum_pfcrg       TO wa_summary-p_f.
      MOVE sum_assess      TO wa_summary-ass_value.
      MOVE sum_excise      TO wa_summary-excise.
      MOVE sum_ecess       TO wa_summary-e_cess.
      MOVE sum_shcess      TO wa_summary-he_cess.
      MOVE sum_frt         TO wa_summary-fright.
      MOVE sum_sub_tot     TO wa_summary-sub_tot.
      MOVE sum_asscstvat   TO wa_summary-vat_cst.
      MOVE sum_tax_amt     TO wa_summary-tax_amt.
      MOVE sum_insu        TO wa_summary-insurance.
      MOVE sum_dcount      TO wa_summary-discount.
      MOVE sum_tcs         TO wa_summary-tcs.
      MOVE sum_tst_chr     TO wa_summary-tst_charg.
      MOVE sum_gross_amt   TO wa_summary-gross_amt.
      MOVE wa2_summary-ledger TO wa_summary-ledger.

      APPEND wa_summary TO it_db_summary.

      CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
          sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
          sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt .

    ENDAT.
  ENDLOOP. " DEBIT SUMMARY

*BUILD NET SALE SUMMARY TABLE
  REFRESH: it_summary2, it_db_summary2, it_cr_summary2.

  SORT it_summary BY ledger vat_cst.
  SORT it_cr_summary BY ledger vat_cst.
  SORT it_db_summary BY ledger vat_cst.

  it_summary2[] = it_summary[] .
  it_cr_summary2[] = it_cr_summary[].
  it_db_summary2[] = it_db_summary[].

  SORT it_summary2 BY ledger vat_cst.
  SORT it_cr_summary2 BY ledger vat_cst.
  SORT it_db_summary2 BY ledger vat_cst.

  CLEAR: wa_summary, wa_db_summary.
  LOOP AT it_summary2 INTO wa_summary.
    sum_basic_amt   = sum_basic_amt + wa_summary-basic.
    sum_pfcrg       = sum_pfcrg     + wa_summary-p_f.
    sum_assess      = sum_assess    + wa_summary-ass_value.
    sum_excise      = sum_excise    + wa_summary-excise.
    sum_ecess       = sum_ecess     + wa_summary-e_cess.
    sum_shcess      = sum_shcess    + wa_summary-he_cess.
    sum_frt         = sum_frt       + wa_summary-fright.
    sum_sub_tot     = sum_sub_tot   + wa_summary-sub_tot.
    sum_asscstvat   =  wa_summary-vat_cst.
    sum_tax_amt     = sum_tax_amt   + wa_summary-tax_amt.
    sum_insu        = sum_insu      + wa_summary-insurance.
    sum_dcount      = sum_dcount    + wa_summary-discount.
    sum_tcs         = sum_tcs       + wa_summary-tcs.
    sum_tst_chr     = sum_tst_chr   + wa_summary-tst_charg.
    sum_gross_amt   = sum_gross_amt + wa_summary-gross_amt.

    CLEAR wa_db_summary.
*    loop at IT_DB_SUMMARY2 into WA_DB_SUMMARY where ledger = wa_summary-ledger.
    LOOP AT it_db_summary2 INTO wa_db_summary WHERE ledger = wa_summary-ledger
                                              AND vat_cst = wa_summary-vat_cst .
      sum_basic_amt   = sum_basic_amt + wa_db_summary-basic.
      sum_pfcrg       = sum_pfcrg     + wa_db_summary-p_f.
      sum_assess      = sum_assess    + wa_db_summary-ass_value.
      sum_excise      = sum_excise    + wa_db_summary-excise.
      sum_ecess       = sum_ecess     + wa_db_summary-e_cess.
      sum_shcess      = sum_shcess    + wa_db_summary-he_cess.
      sum_frt         = sum_frt       + wa_db_summary-fright.
      sum_sub_tot     = sum_sub_tot   + wa_db_summary-sub_tot.
      sum_asscstvat   =  wa_db_summary-vat_cst.
      sum_tax_amt     = sum_tax_amt   + wa_db_summary-tax_amt.
      sum_insu        = sum_insu      + wa_db_summary-insurance.
      sum_dcount      = sum_dcount    + wa_db_summary-discount.
      sum_tcs         = sum_tcs       + wa_db_summary-tcs.
      sum_tst_chr     = sum_tst_chr   + wa_db_summary-tst_charg.
      sum_gross_amt   = sum_gross_amt + wa_db_summary-gross_amt.
    ENDLOOP.

    CLEAR wa_cr_summary.
*    loop at IT_CR_SUMMARY2 into WA_CR_SUMMARY where ledger = wa_summary-ledger.
    LOOP AT it_cr_summary2 INTO wa_cr_summary WHERE ledger = wa_summary-ledger
                                              AND vat_cst = wa_summary-vat_cst .
      sum_basic_amt   = sum_basic_amt - wa_cr_summary-basic.
      sum_pfcrg       = sum_pfcrg     - wa_cr_summary-p_f.
      sum_assess      = sum_assess    - wa_cr_summary-ass_value.
      sum_excise      = sum_excise    - wa_cr_summary-excise.
      sum_ecess       = sum_ecess     - wa_cr_summary-e_cess.
      sum_shcess      = sum_shcess    - wa_cr_summary-he_cess.
      sum_frt         = sum_frt       - wa_cr_summary-fright.
      sum_sub_tot     = sum_sub_tot   - wa_cr_summary-sub_tot.
      sum_asscstvat   =  wa_cr_summary-vat_cst.
      sum_tax_amt     = sum_tax_amt   - wa_cr_summary-tax_amt.
      sum_insu        = sum_insu      - wa_cr_summary-insurance.
      sum_dcount      = sum_dcount    - wa_cr_summary-discount.
      sum_tcs         = sum_tcs       - wa_cr_summary-tcs.
      sum_tst_chr     = sum_tst_chr   - wa_cr_summary-tst_charg.
      sum_gross_amt   = sum_gross_amt - wa_cr_summary-gross_amt.
    ENDLOOP.

*    AT END OF ledger.
    AT END OF vat_cst.
*MOVE TO FINAL SUMMARY INTERNAL TABLE
      CLEAR wa_final_summary.
*      MOVE WA_2SALE_DATA-ledger TO WA_FINAL_SUMMARY-ledger.
      MOVE wa_summary-ledger TO wa_final_summary-ledger.
      MOVE sum_basic_amt   TO wa_final_summary-basic.
      MOVE sum_pfcrg       TO wa_final_summary-p_f.
      MOVE sum_assess      TO wa_final_summary-ass_value.
      MOVE sum_excise      TO wa_final_summary-excise.
      MOVE sum_ecess       TO wa_final_summary-e_cess.
      MOVE sum_shcess      TO wa_final_summary-he_cess.
      MOVE sum_frt         TO wa_final_summary-fright.
      MOVE sum_sub_tot     TO wa_final_summary-sub_tot.
*      MOVE SUM_ASSCSTVAT   TO WA_FINAL_SUMMARY-VAT_CST.
*      MOVE SPACE           TO WA_FINAL_SUMMARY-VAT_CST.
      MOVE wa_summary-vat_cst TO wa_final_summary-vat_cst.
      MOVE sum_tax_amt     TO wa_final_summary-tax_amt.
      MOVE sum_insu        TO wa_final_summary-insurance.
      MOVE sum_dcount      TO wa_final_summary-discount.
      MOVE sum_tcs         TO wa_final_summary-tcs.
      MOVE sum_tst_chr     TO wa_final_summary-tst_charg.
      MOVE sum_gross_amt   TO wa_final_summary-gross_amt.
*      APPEND WA_SUMMARY TO IT_DB_SUMMARY.
      APPEND wa_final_summary TO it_final_summary.
*      DELETE  IT_SUMMARY2 WHERE LEDGER EQ WA_FINAL_SUMMARY-LEDGER.
      DELETE  it_cr_summary2 WHERE ledger EQ wa_final_summary-ledger.
      DELETE  it_db_summary2 WHERE ledger EQ wa_final_summary-ledger.
    ENDAT.

    CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
            sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
            sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt .
    AT LAST.
*to append extra debit records to final summary
      IF it_db_summary2[] IS NOT INITIAL.
*    LOOP AT IT_DB_SUMMARY2 INTO WA_DB_SUMMARY.
        CLEAR wa_db_summary.
        LOOP AT it_db_summary2 INTO wa_db_summary.
          CLEAR wa_cr_summary.
          READ TABLE it_cr_summary2 INTO wa_cr_summary WITH KEY
           ledger = wa_db_summary-ledger.
          IF sy-subrc <> 0.
            APPEND wa_db_summary TO it_final_summary.
          ELSEIF sy-subrc = 0.
            CLEAR wa_final_summary.
            MOVE wa_db_summary-ledger TO wa_final_summary-ledger.
            wa_final_summary-basic = wa_db_summary-basic - wa_cr_summary-basic .
            wa_final_summary-p_f = wa_db_summary-p_f - wa_cr_summary-p_f .
            wa_final_summary-ass_value = wa_db_summary-ass_value - wa_cr_summary-ass_value .
            wa_final_summary-excise = wa_db_summary-excise - wa_cr_summary-excise .
            wa_final_summary-e_cess = wa_db_summary-e_cess - wa_cr_summary-e_cess .
            wa_final_summary-he_cess = wa_db_summary-he_cess - wa_cr_summary-he_cess .
            wa_final_summary-fright = wa_db_summary-fright - wa_cr_summary-fright .
            wa_final_summary-sub_tot = wa_db_summary-sub_tot - wa_cr_summary-sub_tot .
            wa_final_summary-vat_cst = wa_db_summary-vat_cst .
            wa_final_summary-tax_amt = wa_db_summary-tax_amt - wa_cr_summary-tax_amt .
            wa_final_summary-insurance = wa_db_summary-insurance - wa_cr_summary-insurance .
            wa_final_summary-discount = wa_db_summary-discount - wa_cr_summary-discount .
            wa_final_summary-tcs = wa_db_summary-tcs - wa_cr_summary-tcs .
            wa_final_summary-tst_charg = wa_db_summary-tst_charg - wa_cr_summary-tst_charg .
            wa_final_summary-gross_amt = wa_db_summary-gross_amt - wa_cr_summary-gross_amt .
            APPEND wa_final_summary TO it_final_summary.
            DELETE  it_cr_summary2 WHERE ledger EQ wa_db_summary-ledger.
          ENDIF.
        ENDLOOP.
      ENDIF.
*to append extra Credit records to final summary
      IF it_cr_summary2[] IS NOT INITIAL.
*    LOOP AT IT_DB_SUMMARY2 INTO WA_DB_SUMMARY.
        CLEAR wa_cr_summary.
        LOOP AT it_cr_summary2 INTO wa_cr_summary.
          wa_cr_summary-basic = wa_cr_summary-basic * -1.
          wa_cr_summary-p_f = wa_cr_summary-p_f * -1.
          wa_cr_summary-ass_value = wa_cr_summary-ass_value * -1.
          wa_cr_summary-excise = wa_cr_summary-excise * -1.
          wa_cr_summary-e_cess = wa_cr_summary-e_cess * -1.
          wa_cr_summary-he_cess = wa_cr_summary-he_cess * -1.
          wa_cr_summary-fright = wa_cr_summary-fright * -1.
          wa_cr_summary-sub_tot = wa_cr_summary-sub_tot * -1.
          wa_cr_summary-vat_cst = wa_cr_summary-vat_cst .
*          WA_CR_SUMMARY-VAT_CST = SPACE.
          wa_cr_summary-tax_amt = wa_cr_summary-tax_amt * -1.
          wa_cr_summary-insurance = wa_cr_summary-insurance * -1.
          wa_cr_summary-discount = wa_cr_summary-discount * -1.
          wa_cr_summary-tcs = wa_cr_summary-tcs * -1.
          wa_cr_summary-tst_charg = wa_cr_summary-tst_charg * -1.
          wa_cr_summary-gross_amt = wa_cr_summary-gross_amt * -1.
          APPEND wa_cr_summary TO it_final_summary.
        ENDLOOP.
      ENDIF.
    ENDAT.
  ENDLOOP.

****Sorting final Tables before Printing
  SORT it_2sale_data BY acc_doc vbeln.
  SORT it_summary BY ledger vat_cst.
  SORT it_2sale_debit BY acc_doc vbeln.
  SORT it_db_summary BY ledger vat_cst.
  SORT it_2sale_credit BY acc_doc vbeln.
  SORT it_cr_summary BY ledger vat_cst.
  SORT it_final_summary BY ledger vat_cst.

  PERFORM totals TABLES it_2sale_data.
  IF it_2sale_debit[] IS NOT INITIAL.
    PERFORM totals TABLES it_2sale_debit.
  ENDIF.
  IF it_2sale_debit[] IS NOT INITIAL.
    PERFORM totals TABLES it_2sale_credit.
  ENDIF.
  IF it_2sale_debit[] IS NOT INITIAL.
    PERFORM summary_totals TABLES it_summary.
  ENDIF.
  IF it_2sale_debit[] IS NOT INITIAL.
    PERFORM summary_totals TABLES it_db_summary.
  ENDIF.
  IF it_2sale_debit[] IS NOT INITIAL.
    PERFORM summary_totals TABLES it_cr_summary.
  ENDIF.
  IF it_2sale_debit[] IS NOT INITIAL.
    PERFORM summary_totals TABLES it_final_summary.
  ENDIF.


***PLANT ADDRESS FOR PRINTING IN HEADER***
  CLEAR :  wa_pladdr, wa_bapi_rt, lv_name, lv_str_suppl1,
   lv_str_suppl2, lv_street, lv_taluka, lv_district, lv_pincode  .

  CALL FUNCTION 'PIA_CSO_PLANT_ADDRESS_READ'
    EXPORTING
      pi_plant   = 'PL01'
    IMPORTING
      pe_pladdr  = wa_pladdr
      pe_return1 = wa_bapi_rt.

  lv_name = wa_pladdr-name(28).
  lv_str_suppl1 = wa_pladdr-str_suppl1+15(21).
  lv_str_suppl2 = wa_pladdr-str_suppl2(8) .
  lv_street = wa_pladdr-street(18).
  lv_taluka = wa_pladdr-str_suppl2+8.
  lv_district = wa_pladdr-district(4).
  lv_pincode = wa_pladdr-postl_cod1(6).

  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-info = lv_name .
  APPEND lf_line TO i_list_top_of_page.

  CLEAR: lv_var1, lv_var2.
  CONCATENATE lv_str_suppl1 lv_str_suppl2 INTO lv_var1 SEPARATED BY space.
  CONCATENATE lv_taluka lv_district lv_pincode INTO lv_var2 SEPARATED BY space.

  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-info = lv_var1.
  APPEND lf_line TO i_list_top_of_page.

  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-info = lv_street.
  APPEND lf_line TO i_list_top_of_page.

*  CLEAR LF_LINE.
*  LF_LINE-TYP  = C_S.
**  LF_LINE-INFO = .
*  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.

*max can be qty
  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-info = lv_var2.
  APPEND lf_line TO i_list_top_of_page.


*FREE TABLES USED FOR DISPLAY
*  FREE : IT_DATA, IT_DATA1.
ENDFORM.                    " PROCESS_DATA
*&---------------------------------------------------------------------*
*&      FORM  DISPLAY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM  display.

  v_repid = sy-repid.

  CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_INIT'
    EXPORTING
      i_callback_program = v_repid.

  CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
    EXPORTING
      is_layout                  = v_layout
      it_fieldcat                = it_sale_field[]
      i_tabname                  = ''
      it_events                  = it_events1[]
      it_sort                    = it_sort[]
*     I_TEXT                     = ' '
    TABLES
      t_outtab                   = it_2sale_data
    EXCEPTIONS
      program_error              = 1
      maximum_of_appends_reached = 2
      OTHERS                     = 3.

  REFRESH it_space_summary.
  CLEAR wa_summary.
  LOOP AT it_summary INTO wa_summary.
    MOVE-CORRESPONDING wa_summary TO wa_space_summary.
    APPEND wa_space_summary TO it_space_summary.
  ENDLOOP.

  IF it_summary[] IS NOT INITIAL.
    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
      EXPORTING
        is_layout                  = v_layout1
        it_fieldcat                = it_sale_summary_field[]
        i_tabname                  = ''
        it_events                  = it_events5[]
*       IT_SORT                    =
*       I_TEXT                     = ' '
      TABLES
        t_outtab                   = it_space_summary
      EXCEPTIONS
        program_error              = 1
        maximum_of_appends_reached = 2
        OTHERS                     = 3.
  ENDIF.


  IF it_2sale_debit[] IS NOT INITIAL.
    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
      EXPORTING
        is_layout                  = v_layout
        it_fieldcat                = it_debit_field[]
        i_tabname                  = ''
        it_events                  = it_events2[]
*       IT_SORT                    =
*       I_TEXT                     = ' '
      TABLES
        t_outtab                   = it_2sale_debit
      EXCEPTIONS
        program_error              = 1
        maximum_of_appends_reached = 2
        OTHERS                     = 3.
  ENDIF.

  REFRESH it_space_db_summary.
  CLEAR wa_summary.
  LOOP AT it_db_summary INTO wa_summary.
    MOVE-CORRESPONDING wa_summary TO wa_space_summary.
    APPEND wa_space_summary TO it_space_db_summary.
  ENDLOOP.

  IF it_db_summary[] IS NOT INITIAL.
    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
      EXPORTING
        is_layout                  = v_layout
        it_fieldcat                = it_debit_summary_field[]
        i_tabname                  = ''
        it_events                  = it_events6[]
*       IT_SORT                    =
*       I_TEXT                     = ' '
      TABLES
        t_outtab                   = it_space_db_summary
      EXCEPTIONS
        program_error              = 1
        maximum_of_appends_reached = 2
        OTHERS                     = 3.
  ENDIF.

  IF it_2sale_credit[] IS NOT INITIAL.
    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
      EXPORTING
        is_layout                  = v_layout
        it_fieldcat                = it_credit_field[]
        i_tabname                  = ''
        it_events                  = it_events3[]
*       IT_SORT                    =
*       I_TEXT                     = ' '
      TABLES
        t_outtab                   = it_2sale_credit
      EXCEPTIONS
        program_error              = 1
        maximum_of_appends_reached = 2
        OTHERS                     = 3.
  ENDIF.

  REFRESH it_space_cr_summary.
  CLEAR wa_summary.
  LOOP AT it_cr_summary INTO wa_summary.
    MOVE-CORRESPONDING wa_summary TO wa_space_summary.
    APPEND wa_space_summary TO it_space_cr_summary.
  ENDLOOP.

  IF it_cr_summary[] IS NOT INITIAL.
    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
      EXPORTING
        is_layout                  = v_layout
        it_fieldcat                = it_credit_summary_field[]
        i_tabname                  = ''
        it_events                  = it_events7[]
*       IT_SORT                    =
*       I_TEXT                     = ' '
      TABLES
        t_outtab                   = it_space_cr_summary
      EXCEPTIONS
        program_error              = 1
        maximum_of_appends_reached = 2
        OTHERS                     = 3.
  ENDIF.

  REFRESH it_space_final_summary.
  CLEAR wa_summary.
  LOOP AT it_final_summary INTO wa_summary.
    MOVE-CORRESPONDING wa_summary TO wa_space_summary.
    APPEND wa_space_summary TO it_space_final_summary.
  ENDLOOP.

*Remove the final Net sale Summary
*  IF IT_FINAL_SUMMARY[] IS NOT INITIAL.
*    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
*      EXPORTING
*        IS_LAYOUT                        = V_LAYOUT
*        IT_FIELDCAT                      = IT_FINAL_SUMMARY_FIELD[]
*        I_TABNAME                        = ''
*        IT_EVENTS                        = IT_EVENTS4[]
**   IT_SORT                          =
**   I_TEXT                           = ' '
*      TABLES
*        T_OUTTAB                         = IT_SPACE_FINAL_SUMMARY
*     EXCEPTIONS
*       PROGRAM_ERROR                    = 1
*       MAXIMUM_OF_APPENDS_REACHED       = 2
*       OTHERS                           = 3.
*  ENDIF.

  CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_DISPLAY'.

ENDFORM.                    "DISPLAY
*&--------------------------------------------------------------------*
*&      Form  TOP_PAGE
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM top_page.
*  concatenate text-001 S_DT-LOW S_DT-HIGH INTO LV_TXT SEPARATED BY SPACE.
*  WRITE:/ 'Sales Register' COLOR 5.
  CLEAR: lv_dt1, lv_dt2 .
  CALL FUNCTION 'CONVERSION_EXIT_SDATE_OUTPUT'
    EXPORTING
      input  = s_dt-low
    IMPORTING
      output = lv_dt1.
  CALL FUNCTION 'CONVERSION_EXIT_SDATE_OUTPUT'
    EXPORTING
      input  = s_dt-high
    IMPORTING
      output = lv_dt2.

  CONCATENATE TEXT-001 lv_dt1 '-' lv_dt2 INTO lv_txt SEPARATED BY space.


  WRITE: lv_name,
         / lv_var1,
        / lv_street,
       / lv_var2,
        / lv_txt COLOR 5.
ENDFORM.                    "TOP_PAGE
*&--------------------------------------------------------------------*
*&      Form  TOP_PAGE_1
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM top_page_1.
  WRITE:/ 'Debit Notes Register' COLOR 5.
ENDFORM.                    "TOP_PAGE
*&--------------------------------------------------------------------*
*&      Form  TOP_PAGE_2
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM top_page_2.
  WRITE:/ 'Credit Notes Register' COLOR 5.
ENDFORM.                    "TOP_PAGE
*&--------------------------------------------------------------------*
*&      Form  TOP_PAGE_3
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM top_page_3.
  WRITE AT  /152 'Net Sales Summary' COLOR 5.
ENDFORM.                    "TOP_PAGE
*&--------------------------------------------------------------------*
*&      Form  TOP_PAGE_4
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM top_page_4.
  WRITE AT  /152 'Sales Summary' COLOR 5.
ENDFORM.                    "TOP_PAGE
*&--------------------------------------------------------------------*
*&      Form  TOP_PAGE_5
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM top_page_5.
  WRITE AT  /152 'Debit Notes Summary' COLOR 5.
ENDFORM.                    "TOP_PAGE
*&--------------------------------------------------------------------*
*&      Form  TOP_PAGE_6
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM top_page_6.
  WRITE AT  /152 'Credit Notes Summary' COLOR 5.
ENDFORM.                    "TOP_PAGE

**  SORT IT_SUMMARY BY LEDGER.
**  SORT IT_2SALE_DEBIT BY ACC_DOC VBELN.
**  SORT IT_DB_SUMMARY BY LEDGER.
**  SORT IT_2SALE_CREDIT BY ACC_DOC VBELN.
**  SORT IT_CR_SUMMARY BY LEDGER.
**  SORT IT_FINAL_SUMMARY BY LEDGER.
*
*ENDFORM.                    " TOTALS
*&---------------------------------------------------------------------*
*&      Form  TOTALS
*&---------------------------------------------------------------------*
FORM totals  TABLES   p_it_2sale_data .

  CLEAR : wa_2sale_data, sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
              sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
              sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt .

  LOOP AT p_it_2sale_data INTO wa_2sale_data .
    sum_basic_amt   = sum_basic_amt + wa_2sale_data-basic.
    sum_pfcrg       = sum_pfcrg     + wa_2sale_data-p_f.
    sum_assess      = sum_assess    + wa_2sale_data-ass_value.
    sum_excise      = sum_excise    + wa_2sale_data-excise.
    sum_ecess       = sum_ecess     + wa_2sale_data-e_cess.
    sum_shcess      = sum_shcess    + wa_2sale_data-he_cess.
    sum_frt         = sum_frt       + wa_2sale_data-fright.
    sum_sub_tot     = sum_sub_tot   + wa_2sale_data-sub_tot.
*    SUM_ASSCSTVAT   = SUM_ASSCSTVAT + WA_2SALE_DATA-VAT_CST.
    sum_tax_amt     = sum_tax_amt   + wa_2sale_data-tax_amt.
    sum_insu        = sum_insu      + wa_2sale_data-insurance.
    sum_n_frt       = sum_n_frt     + wa_2sale_data-n_tax_frt.
    sum_tst_chr     = sum_tst_chr   + wa_2sale_data-tst_chr.
    sum_dcount      = sum_dcount    + wa_2sale_data-discount.
    sum_tcs         = sum_tcs       + wa_2sale_data-tcs.
    sum_gross_amt   = sum_gross_amt + wa_2sale_data-gross_amt.
    AT LAST.
      CLEAR wa_2sale_data.
      MOVE 'T O T A L'     TO wa_3sale_data-cust_add.
      MOVE sum_basic_amt   TO wa_3sale_data-basic.
      MOVE sum_pfcrg       TO wa_3sale_data-p_f.
      MOVE sum_dcount      TO wa_3sale_data-discount.
      MOVE sum_assess      TO wa_3sale_data-ass_value.
      MOVE sum_excise      TO wa_3sale_data-excise.
      MOVE sum_ecess       TO wa_3sale_data-e_cess.
      MOVE sum_shcess      TO wa_3sale_data-he_cess.
      MOVE sum_frt         TO wa_3sale_data-fright.
      MOVE sum_sub_tot     TO wa_3sale_data-sub_tot.
*      MOVE SUM_ASSCSTVAT   TO WA_3SALE_DATA-VAT_CST.
      CLEAR wa_3sale_data-vat_cst.
      MOVE sum_tax_amt     TO wa_3sale_data-tax_amt.
      MOVE sum_insu        TO wa_3sale_data-insurance.
      MOVE sum_n_frt       TO wa_3sale_data-n_tax_frt.
      MOVE sum_tst_chr     TO wa_3sale_data-tst_chr.
      MOVE sum_tcs         TO wa_3sale_data-tcs.
      MOVE sum_gross_amt   TO wa_3sale_data-gross_amt.
    ENDAT.
  ENDLOOP.
  APPEND wa_3sale_data TO p_it_2sale_data. " total
  CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
              sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
              sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt .

ENDFORM.                    " TOTALS
*&---------------------------------------------------------------------*
*&      Form  SUMMARY_TOTALS
*&---------------------------------------------------------------------*
FORM summary_totals  TABLES   p_it_summary.
  CLEAR wa2_summary.
  CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
              sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
              sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt, wa_summary .

  LOOP AT p_it_summary INTO wa2_summary .

    sum_basic_amt   = sum_basic_amt + wa2_summary-basic.
    sum_pfcrg       = sum_pfcrg     + wa2_summary-p_f.
    sum_assess      = sum_assess    + wa2_summary-ass_value.
    sum_excise      = sum_excise    + wa2_summary-excise.
    sum_ecess       = sum_ecess     + wa2_summary-e_cess.
    sum_shcess      = sum_shcess    + wa2_summary-he_cess.
    sum_frt         = sum_frt       + wa2_summary-fright.
    sum_sub_tot     = sum_sub_tot   + wa2_summary-sub_tot.
    sum_asscstvat   = sum_asscstvat + wa2_summary-vat_cst.
    sum_tax_amt     = sum_tax_amt   + wa2_summary-tax_amt.
    sum_insu        = sum_insu      + wa2_summary-insurance.
*    SUM_N_FRT       = SUM_N_FRT     + WA2_SUMMARY-N_TAX_FRT.
    sum_tst_chr     = sum_tst_chr   + wa2_summary-tst_charg.
    sum_dcount      = sum_dcount    + wa2_summary-discount.
    sum_tcs         = sum_tcs       + wa2_summary-tcs.
    sum_gross_amt   = sum_gross_amt + wa2_summary-gross_amt.

    AT LAST.
*on change of WA_DATA1-LEDGER.
      CLEAR wa_summary.
      MOVE 'GRAND  TOTAL'   TO wa_summary-ledger.
      MOVE sum_basic_amt   TO wa_summary-basic.
      MOVE sum_pfcrg       TO wa_summary-p_f.
      MOVE sum_assess      TO wa_summary-ass_value.
      MOVE sum_excise      TO wa_summary-excise.
      MOVE sum_ecess       TO wa_summary-e_cess.
      MOVE sum_shcess      TO wa_summary-he_cess.
      MOVE sum_frt         TO wa_summary-fright.
      MOVE sum_sub_tot     TO wa_summary-sub_tot.
*      MOVE SUM_ASSCSTVAT   TO WA_SUMMARY-VAT_CST.
      CLEAR wa_summary-vat_cst.
      MOVE sum_tax_amt     TO wa_summary-tax_amt.
      MOVE sum_insu        TO wa_summary-insurance.
      MOVE sum_dcount      TO wa_summary-discount.
      MOVE sum_tcs         TO wa_summary-tcs.
      MOVE sum_tst_chr     TO wa_summary-tst_charg.
      MOVE sum_gross_amt   TO wa_summary-gross_amt.
    ENDAT.
  ENDLOOP.
  APPEND wa_summary TO p_it_summary. " total
  CLEAR : sum_basic_amt, sum_pfcrg, sum_dcount, sum_assess, sum_excise, sum_ecess,
              sum_shcess, sum_frt, sum_sub_tot,  sum_asscstvat, sum_tax_amt, sum_insu,
              sum_n_frt, sum_tst_chr, sum_tcs,  sum_gross_amt, wa_summary .
ENDFORM.                    " SUMMARY_TOTALS
