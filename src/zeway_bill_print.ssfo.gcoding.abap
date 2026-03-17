
DATA : lr_TCS_KSCHL TYPE RANGE OF kschl.

CLEAR:gv_total.
CLEAR:pac_for,inspection,testing,freight,srate,irate.
SELECT * FROM j_1istatecdm INTO TABLE lt_statecode.
SELECT * FROM zbillingtypes INTO TABLE lt_billingtypes.

*BREAK primus.
SELECT vbeln  fkart waerk vkorg
       kalsm knumv fkdat kurrf
       bukrs taxk6 netwr mwsbk kunag sfakn
       xblnr bupla
       FROM vbrk
       INTO TABLE lt_vbrk_j
*         FOR ALL ENTRIES IN lt_final_temp
       WHERE vbeln = p_vbeln
       AND bukrs = p_bukrs.


LOOP AT lt_vbrk_j INTO ls_vbrk_j.
  IF ls_vbrk_j-sfakn IS NOT INITIAL.
    DELETE lt_vbrk_j WHERE vbeln = ls_vbrk_j-sfakn.
    DELETE lt_vbrk_j WHERE vbeln = ls_vbrk_j-vbeln.
  ENDIF.
ENDLOOP.

IF lt_vbrk_j IS NOT INITIAL.

  SELECT vbeln posnr  matnr arktx
         fkimg netwr meins aubel
         kursk werks vrkme vgbel lgort
         FROM vbrp
         INTO TABLE lt_vbrp
         FOR ALL ENTRIES IN lt_vbrk_j
         WHERE vbeln = lt_vbrk_j-vbeln.

  SELECT knumv
         kposn
         kschl
         kwert
         kbetr
         kawrt
*        FROM konv
        FROM  prcd_elements
     INTO TABLE lt_prcd
     FOR ALL ENTRIES IN lt_vbrk_j
       WHERE knumv = lt_vbrk_j-knumv
         AND kschl IN ('JOCG', 'JOSG', 'JOIG', 'JCOS', 'PR00', 'ZPR0', 'K004',
                       'K005', 'K007', 'ZDIS', 'ZGSR', 'ZSUB', 'ZSTO', 'JTC1', 'JTC2',
                       'ZTCS', 'ZPFO', 'ZIN1', 'ZIN2', 'ZFR1', 'ZFR2' ,'ZTE1', 'ZTE2'
                       , 'VPRS').
  SELECT kunnr
      name1
      locco
      stcd3
      ort01
      pstlz
      land1
      regio
      bahne
      adrnr
      werks
      ktokd
      FROM kna1
      INTO TABLE lt_kna1
      FOR ALL ENTRIES IN lt_vbrk_j
      WHERE kunnr EQ lt_vbrk_j-kunag.
ELSE.
*    MESSAGE 'No data found !' TYPE 'E'.
ENDIF.

IF lt_vbrp IS NOT INITIAL.

  SELECT  vbelv posnv vbeln
          posnn vbtyp_v matnr
          FROM vbfa
          INTO TABLE lt_vbfa
          FOR ALL ENTRIES IN lt_vbrp
          WHERE  vbeln = lt_vbrp-vbeln
          AND posnn = lt_vbrp-posnr
          AND vbtyp_v = 'J'.

  SELECT matnr
       werks
       steuc
       FROM marc
       INTO TABLE lt_marc
       FOR ALL ENTRIES IN lt_vbrp
       WHERE matnr EQ lt_vbrp-matnr.

  SELECT vbelv posnv vbeln
         posnn  vbtyp_v matnr
         FROM vbfa
         INTO TABLE lt_vbfa_2
         FOR ALL ENTRIES IN lt_vbrp
         WHERE  vbeln = lt_vbrp-vbeln
         AND posnn = lt_vbrp-posnr
         AND ( vbtyp_v = 'C' OR vbtyp_v = 'I' ) .

  IF lt_vbfa_2 IS NOT INITIAL.
    SELECT vbeln auart
           FROM vbak
           INTO TABLE lt_vbak
           FOR ALL ENTRIES IN lt_vbfa_2
           WHERE vbeln = lt_vbfa_2-vbelv.
  ENDIF.

  IF lt_vbak IS NOT INITIAL.
    SELECT vbeln posnr kdmat
           FROM vbap
           INTO TABLE lt_vbap
           FOR ALL ENTRIES IN lt_vbak
           WHERE vbeln = lt_vbak-vbeln.
  ENDIF.

  SELECT werks
         pstlz
         spras
         land1
         regio
         adrnr
         FROM t001w INTO TABLE it_t001w
         FOR ALL ENTRIES IN lt_vbrp
         WHERE werks = lt_vbrp-werks.

********ADDED BY PRIMUS JYOTI ON 01.12.2023*******
  SELECT kschl
        kunnr
        matnr
        datbi
        datab
        knumh
   FROM a005
   INTO TABLE tt_a005
   FOR ALL ENTRIES IN lt_vbrp
   WHERE matnr = lt_vbrp-matnr
   AND kschl = 'ZSTO'
   AND datbi = '99991231'.
ENDIF.
********ADDED BY PRIMUS JYOTI ON 09.07.2024*******
IF tt_a005 IS NOT INITIAL.

  SELECT knumh
         kopos
         kschl
         kbetr
    FROM konp
    INTO TABLE tt_konp
    FOR ALL ENTRIES IN tt_a005
    WHERE knumh = tt_a005-knumh.

ENDIF.
**************************************************
*ENDIF.

IF it_t001w IS NOT INITIAL.
  SELECT spras
         land1
         bland
         bezei FROM t005u INTO TABLE it_t005u
         FOR ALL ENTRIES IN it_t001w
         WHERE spras = it_t001w-spras
        AND land1 = it_t001w-land1
        AND bland = it_t001w-regio.

  SELECT addrnumber
       name1
       street
       str_suppl1
       str_suppl2
       str_suppl3
       location
       country
       city1
       post_code1
       region
  FROM adrc INTO TABLE it_adrc
  FOR ALL ENTRIES IN it_t001w
  WHERE addrnumber = it_t001w-adrnr.
ENDIF.

IF lt_kna1 IS NOT INITIAL.
  SELECT addrnumber
         name1
         street
         str_suppl1
         str_suppl2
         str_suppl3
         location
         country
         city1
         post_code1
         region
         city2
         FROM adrc INTO TABLE it_adrc_cust
         FOR ALL ENTRIES IN lt_kna1
         WHERE addrnumber = lt_kna1-adrnr.

  SELECT addrnumber
          remark INTO TABLE it_adrct
          FROM adrct
          FOR ALL ENTRIES IN lt_kna1
          WHERE addrnumber = lt_kna1-adrnr.
ENDIF.

DATA : doc_no  TYPE thead-tdname,
       lines   LIKE tline OCCURS 0 WITH HEADER LINE,
       i_text  TYPE char100,
       e_text  TYPE char100,

       lv_id   TYPE  thead-tdid,
       lv_lang TYPE thead-tdspras VALUE 'E',
       lv_obj  TYPE thead-tdobject,
       lv_name TYPE thead-tdname.

DATA: lt_tab TYPE STANDARD TABLE OF tline.
DATA: ls_vbpa TYPE vbpa,
*      ls_kna1 TYPE kna1,
      ls_adrc TYPE adrc.
*BREAK primusABAP.
LOOP AT lt_vbrp INTO wa_vbrp.
  wa_final-posnr = wa_vbrp-posnr.
  wa_final-material = wa_vbrp-matnr.
  wa_final-arktx = wa_vbrp-arktx.
  wa_final-uqc = wa_vbrp-vrkme.
  wa_final-taxable_value = wa_vbrp-netwr * wa_vbrp-kursk.
  READ TABLE lt_vbrk_j INTO ls_vbrk_j WITH KEY vbeln = wa_vbrp-vbeln.
  IF sy-subrc = '0'.
    wa_final-assess_value = ls_vbrk_j-netwr.
    READ TABLE lt_billingtypes INTO ls_billingtypes WITH KEY bukrs = ls_vbrk_j-bukrs
                                                             vkorg = ls_vbrk_j-vkorg
                                                            fkart = ls_vbrk_j-fkart.
    IF sy-subrc = 0.
      IF ls_vbrk_j-vbeln IS NOT INITIAL.
        wa_final-doc_no = ls_vbrk_j-vbeln.
      ELSE.
        wa_final-doc_no = 'null'.
      ENDIF.
      wa_final-xblnr = ls_vbrk_j-xblnr.            "
      wa_final-order_type = ls_vbrk_j-fkart.
      wa_final-supply_type  = ls_billingtypes-zsupply.
      wa_final-sub_type     = ls_billingtypes-zsubsupply.
      wa_final-doc_type     = ls_billingtypes-zdoctype.

      SELECT SINGLE gstin FROM j_1bbranch INTO wa_final-gstin WHERE bukrs = ls_vbrk_j-bukrs AND branch = ls_vbrk_j-bupla.
*
      READ TABLE it_t001w INTO wa_t001w WITH KEY werks = wa_vbrp-werks.
      IF sy-subrc = 0.
        READ TABLE it_adrc INTO wa_adrc WITH KEY addrnumber = wa_t001w-adrnr.
        IF sy-subrc = 0.
          wa_final-location = wa_adrc-street."wa_adrc-city1.
          wa_final-name1 = wa_adrc-name1.
          wa_final-street = wa_adrc-str_suppl1.
          wa_final-str_suppl3 = wa_adrc-str_suppl2.
          wa_final-from_state = wa_adrc-region.
          wa_final-post_code1 = wa_adrc-post_code1.
        ENDIF.
      ENDIF.
      BREAK primusabap.
      IF wa_vbrp-lgort+0(1) = 'K'.
        SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad_1)
              WHERE werks = @wa_vbrp-werks AND lgort = 'KPR1'.
        IF wa_twlad_1 IS NOT INITIAL.
          SELECT SINGLE street, city1, post_code1 FROM adrc
              INTO @DATA(wa_adrc_t_1) WHERE addrnumber = @wa_twlad_1.
        ENDIF.
        IF wa_adrc_t_1 IS NOT INITIAL.
          wa_final-location = wa_adrc_t_1-city1.
          wa_final-name1  = 'DelVal Flow Controls Private Limited.'.
          wa_final-street = wa_adrc_t_1-street.
          wa_final-str_suppl3 = wa_adrc_t_1-city1.
          wa_final-from_state = '13'.
          wa_final-post_code1 = wa_adrc_t_1-post_code1.
          wa_data-fromplace = 'Kapurhol Kavathe'.
        ENDIF.
      ELSEIF wa_vbrp-lgort = 'PN01'. """Added by Pranit 21.10.2024
        SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad_2)
                WHERE werks = @wa_vbrp-werks AND lgort = 'PN01'.
*        IF wa_twlad_2 IS NOT INITIAL.
        SELECT SINGLE street, city1, post_code1 FROM adrc
            INTO @DATA(wa_adrc_t_2) WHERE addrnumber = @wa_twlad_2.
*        ENDIF.
        IF wa_adrc_t_2 IS NOT INITIAL.
          wa_final-location = wa_adrc_t_2-city1.
          wa_final-name1  = 'DelVal Flow Controls Private Limited.'.
          wa_final-street = wa_adrc_t_2-street.
          wa_final-str_suppl3 = wa_adrc_t_2-city1.
          wa_final-from_state = '13'.
          wa_final-post_code1 = wa_adrc_t_2-post_code1.
*          wa_data-fromplace = 'Kapurhol Kavathe'.
        ENDIF.
      ENDIF.
**********************ADDED BY JYOTI ON 16.06.2024********************
      SELECT SINGLE lgort FROM mseg INTO gv_lgort WHERE mblnr = wa_vbrp-vgbel
                                                           AND xauto NE 'X'.
***************FROM ADDRESS**********************
      IF ls_vbrk_j-fkart = 'ZDC' OR ls_vbrk_j-fkart = 'ZSN'."ADDED BY JYOTI ON 16.06.2024
        IF gv_lgort = 'SAN1'. "ADDED BY JYOTI ON 16.06.2024
          wa_final-location  = 'SANGVI'."wa_adrc-city1.
          wa_final-name1      = 'DelVal Flow Controls Private Limited.'."wa_adrc-name1.
          wa_final-street     = 'Gat No 351,MILKAT NO.733,733/1,'."wa_adrc-str_suppl1.
          wa_final-str_suppl3 = '733/2 SHIRVAL NAIGAON ROAD'.
          wa_final-from_state = '13'."wa_adrc-region.
          wa_final-post_code1 = '412801'."wa_adrc-post_code1.

*          ELSEIF GV_LGORT = 'RM01'.
        ELSEIF gv_lgort = 'RM01' OR gv_lgort = 'FG01' OR gv_lgort = 'MCN1' OR gv_lgort = 'PLG1' "OR gv_lgort = 'PN01'
         OR gv_lgort = 'PRD1' OR gv_lgort = 'RJ01' OR gv_lgort = 'RWK1' OR gv_lgort = 'TPI1' OR  gv_lgort = 'VLD1'
          or gv_lgort = 'SFG1' OR  gv_lgort = 'SC01'.
          READ TABLE it_t001w INTO wa_t001w WITH KEY werks = wa_vbrp-werks.
          IF sy-subrc = 0.
            READ TABLE it_adrc INTO wa_adrc WITH KEY addrnumber = wa_t001w-adrnr.
            IF sy-subrc = 0.
              wa_final-location = wa_adrc-city1.
              wa_final-name1 =   wa_adrc-name1.
              wa_final-street = wa_adrc-str_suppl1.
              wa_final-str_suppl3 = wa_adrc-str_suppl2.
              wa_final-from_state = wa_adrc-region.
              wa_final-post_code1 = wa_adrc-post_code1.
            ENDIF.
          ENDIF.
        ELSEIF gv_lgort+0(1) = 'K'.
          SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad)
          WHERE werks = @wa_vbrp-werks AND lgort = 'KPR1'.
          IF wa_twlad IS NOT INITIAL.
            SELECT SINGLE street, city1, post_code1 FROM adrc
                INTO @DATA(wa_adrc_t) WHERE addrnumber = @wa_twlad.
          ENDIF.
          IF wa_adrc_t IS NOT INITIAL.
            wa_final-location = wa_adrc_t-city1.
            wa_final-name1  = 'DelVal Flow Controls Private Limited.'.
            wa_final-street = wa_adrc_t-street.
            wa_final-str_suppl3 = wa_adrc_t-city1.
            wa_final-from_state = '13'.
            wa_final-post_code1 = wa_adrc_t-post_code1.
          ENDIF.
        ELSEIF gv_lgort = 'PN01'. """ADDED BY PRANIT 21.10.2024
          SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad_3)
         WHERE werks = @wa_vbrp-werks AND lgort = 'PN01'.
          IF wa_twlad_3 IS NOT INITIAL.
            SELECT SINGLE street, city1, post_code1 FROM adrc
                INTO @DATA(wa_adrc_t_3) WHERE addrnumber = @wa_twlad_3.
          ENDIF.
          IF wa_adrc_t_3 IS NOT INITIAL.
            wa_final-location = wa_adrc_t_3-city1.
            wa_final-name1  = 'DelVal Flow Controls Private Limited.'.
            wa_final-street = wa_adrc_t_3-street.
            wa_final-str_suppl3 = wa_adrc_t_3-city1.
            wa_final-from_state = '13'.
            wa_final-post_code1 = wa_adrc_t_3-post_code1.
          ENDIF.
        ENDIF.
      ENDIF.
*********************************************************************
*-------------------Start Remove Special Characters from Strings------------------------------------------

      wa_final-line_item = 'ELECTRICAL & MECHANICAL'.
      wa_final-item_code  = wa_vbrp-arktx.
      wa_final-quantity  = wa_vbrp-fkimg.
      READ TABLE lt_marc INTO wa_marc WITH KEY matnr = wa_vbrp-matnr werks = wa_vbrp-werks.
      IF sy-subrc = '0'.
        wa_final-hsn_sac = wa_marc-steuc.
      ENDIF.


      READ TABLE lt_kna1 INTO wa_kna1 WITH KEY kunnr = ls_vbrk_j-kunag.
      IF sy-subrc = 0.
        wa_final-transport_id = wa_kna1-bahne.                    " Transporter ID
        READ TABLE it_adrc_cust INTO wa_adrc_cust WITH KEY addrnumber = wa_kna1-adrnr.
        IF ls_vbrk_j-waerk NE 'INR'.
          CLEAR:ls_vbpa.
*          SELECT SINGLE * FROM vbpa INTO ls_vbpa WHERE vbeln = ls_vbrk_j-vbeln AND parvw = 'PT'.
          DATA : gv_name  TYPE thead-tdname,
                 lv_lines TYPE STANDARD TABLE OF tline,
                 wa_lines LIKE tline.
*                   kunnr    TYPE kna1-kunnr.

          CLEAR:kunnr,gv_name,lv_lines,wa_lines.
          gv_name = ls_vbrk_j-vbeln.
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              client                  = sy-mandt
              id                      = 'Z350'
              language                = sy-langu
              name                    = gv_name
              object                  = 'VBBK'
            TABLES
              lines                   = lv_lines
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
*               MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
          ENDIF.

          IF NOT lv_lines IS INITIAL.
            READ TABLE lv_lines INTO wa_lines INDEX 1.
            IF NOT wa_lines-tdline IS INITIAL.
              kunnr = wa_lines-tdline .
            ENDIF.

          ENDIF.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = kunnr
            IMPORTING
              output = kunnr.
          IF kunnr IS NOT INITIAL ..
            CLEAR : ls_kna1.
            SELECT SINGLE * FROM kna1 INTO ls_kna1 WHERE kunnr = kunnr.
            IF sy-subrc = 0.
              CLEAR : ls_adrc.
              SELECT SINGLE * FROM adrc INTO ls_adrc WHERE addrnumber = ls_kna1-adrnr.
            ENDIF.
          ENDIF.

          wa_final-ship_to_party = wa_kna1-name1.

          wa_final-to_gstin   = 'URP'."wa_kna1-stcd3..
          IF wa_final-to_gstin = 'URD'.
            wa_final-to_gstin = 'URP'.
          ENDIF.
          CONCATENATE ls_adrc-str_suppl1 ls_adrc-street INTO wa_final-to_add1 SEPARATED BY space.

          CONCATENATE ls_adrc-str_suppl2 ls_adrc-city2 INTO wa_final-to_add2 SEPARATED BY space.
          wa_final-to_place   = wa_kna1-ort01.
          wa_final-to_pincode = ls_kna1-pstlz.
          wa_final-distance_level   = ls_kna1-locco.
*              SELECT SINGLE bezei FROM t005u INTO  wa_final-to_state  WHERE spras = 'E' AND land1 = ls_kna1-land1 AND bland = ls_kn
          wa_final-to_state   = ls_kna1-regio."'OTHER COUNTRIES '.

        ELSE.
          DATA :bill_to    TYPE kna1-kunnr,
*                ship_to    TYPE kna1-kunnr,
                ship_state TYPE kna1-regio.

          CLEAR: bill_to , ship_to,bill_pstlz,ship_pstlz.
          SELECT SINGLE kunnr FROM vbpa INTO  bill_to
            WHERE vbeln = ls_vbrk_j-vbeln AND parvw = 'AG'.

          SELECT SINGLE kunnr FROM vbpa INTO ship_to
             WHERE vbeln = ls_vbrk_j-vbeln AND parvw = 'WE'.

          SELECT SINGLE pstlz INTO bill_pstlz FROM kna1
            WHERE kunnr = bill_to.

          SELECT SINGLE pstlz INTO ship_pstlz FROM kna1
            WHERE kunnr = ship_to.
*          IF bill_to NE ship_to.
**                IF sy-subrc = 0.
*            CLEAR : ls_kna1,ship_state.
*            SELECT SINGLE * FROM kna1 INTO ls_kna1 WHERE kunnr = ship_to.
*            IF sy-subrc = 0.
*              CLEAR : ls_adrc.
*              SELECT SINGLE * FROM adrc INTO ls_adrc WHERE addrnumber = ls_kna1-adrnr.
*            ENDIF.
**                 ENDIF.
*
*
*            wa_final-ship_to_party = wa_kna1-name1.
*            wa_final-to_gstin   = wa_kna1-stcd3.
*
*
*            CONCATENATE ls_adrc-str_suppl1 ls_adrc-street INTO wa_final-to_add1 SEPARATED BY space.
*
*            CONCATENATE ls_adrc-str_suppl2 ls_adrc-city2 INTO wa_final-to_add2 SEPARATED BY space.
*
*
*            wa_final-to_place = ls_kna1-ort01 .
*            wa_final-to_pincode = ls_kna1-pstlz.
*            wa_final-distance_level   = wa_kna1-locco.
**  *            SELECT SINGLE bezei FROM t005u INTO  wa_final-to_state  WHERE spras = 'E' AND land1 = wa_kna1-land1 AND bland = wa_
*
*            wa_final-to_state = wa_kna1-regio.
*            ship_state = ls_kna1-regio.
*
*          ELSE.

          wa_final-ship_to_party = wa_kna1-name1.
          wa_final-to_gstin   = wa_kna1-stcd3.
          IF wa_final-to_gstin = 'URD'.
            wa_final-to_gstin = 'URP'.
          ENDIF.
*********************COMMENTED BY JYOTI ON 16.06.2024
          CONCATENATE wa_adrc_cust-str_suppl1 wa_adrc_cust-street INTO wa_final-to_add1 SEPARATED BY space.
          CONCATENATE wa_adrc_cust-str_suppl2 wa_adrc_cust-city2 INTO wa_final-to_add2 SEPARATED BY space.
          wa_final-to_place = wa_kna1-ort01.
          wa_final-to_pincode = wa_kna1-pstlz.
          wa_final-distance_level   = wa_kna1-locco.
          wa_final-to_state = wa_kna1-regio.
**************ADDED BY JYOTI ON 16.06.2024********************************
         BREAK primusabap.
          IF ls_vbrk_j-fkart = 'ZDC'. "ADDED BY JYOTI ON 16.06.2024

*            IF WA_VBRP-LGORT = 'RM01'. "ADDED BY JYOTI ON 16.06.2024
            IF wa_vbrp-lgort = 'RM01' OR wa_vbrp-lgort = 'FG01' OR wa_vbrp-lgort = 'MCN1' OR wa_vbrp-lgort = 'PLG1'
*               OR wa_vbrp-lgort ='PN01'
          OR wa_vbrp-lgort = 'PRD1' OR wa_vbrp-lgort = 'RJ01'
               OR wa_vbrp-lgort = 'RWK1' OR wa_vbrp-lgort = 'TPI1' OR
               wa_vbrp-lgort = 'VLD1' or wa_vbrp-lgort = 'SC01' OR
              WA_VBRP-LGORT = 'SFG1'.
              wa_final-ship_to_party = 'DelVal Flow Controls Private Limited.'.
              wa_adrc_cust-str_suppl1 = 'Gat No 25,37,43/1A,,'.
              wa_adrc_cust-street = 'AT-Kavathe'.
              CONCATENATE wa_adrc_cust-str_suppl1 wa_adrc_cust-street
              INTO wa_final-to_add1 SEPARATED BY space.
              CONCATENATE wa_adrc_cust-str_suppl2 wa_adrc_cust-city2
              INTO wa_final-to_add2 SEPARATED BY space.
              wa_final-to_place = 'Shirwal'.
              wa_final-to_pincode = '412801'.
              wa_final-to_state  = '13'.

            ELSEIF wa_vbrp-lgort = 'SAN1'.
              wa_final-ship_to_party  = 'DelVal Flow Controls Private Limited.'.
*               wa_adrc_cust-str_suppl1  = 'Gat No 351,MILKAT NO.733,733/1,'. "'GAT NO. 289/1, KAPURHOLE'.
*              wa_adrc_cust-street  = '733/2 SHIRVAL NAIGAON ROAD'."'TAL-BHOR'.
              wa_final-to_add2  = 'SANGVI'.
              wa_final-to_place = 'KHANDALA'.
              wa_final-to_pincode = '412801'.
              wa_final-to_state = '13'.
              CONCATENATE'Gat No 351,MILKAT NO.733,733/1,' '733/2 SHIRVAL NAIGAON ROAD'
             INTO wa_final-to_add1 SEPARATED BY space.
*      CONCATENATE SANGVI
*      INTO wa_final-to_add2 SEPARATED BY space.

            ELSEIF wa_vbrp-lgort+0(1) = 'K'.
              SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad_new)
              WHERE werks = @wa_vbrp-werks AND lgort = 'KPR1'.
              IF wa_twlad_new IS NOT INITIAL.
                SELECT SINGLE street, city1, post_code1 FROM adrc
                    INTO @DATA(wa_adrc_t_new) WHERE addrnumber = @wa_twlad_new.
              ENDIF.
              IF wa_adrc_t_new IS NOT INITIAL.
                wa_final-to_place = wa_adrc_t_new-city1.
                wa_final-ship_to_party   = 'DelVal Flow Controls Private Limited.'.
                wa_adrc_cust-street  = wa_adrc_t_new-street.
*                   wa_adrc_cust-str_suppl2 = WA_ADRC_T_NEW-CITY1.
                wa_adrc_cust-city2 = wa_adrc_t_new-city1.
                wa_final-to_state = '13'.
                wa_final-to_pincode = wa_adrc_t_new-post_code1.
              ENDIF.
              BREAK PRIMUSABAP.
              """"ADDED BY PRANIT 21.10.2024
            ELSEIF wa_vbrp-lgort = 'PN01'.
              SELECT SINGLE adrnr FROM twlad INTO @DATA(wa_twlad_new1)
              WHERE werks = @wa_vbrp-werks AND lgort = 'PN01'.
              IF wa_twlad_new1 IS NOT INITIAL.
                SELECT SINGLE street, city1, post_code1 FROM adrc
                    INTO @DATA(wa_adrc_t_new1) WHERE addrnumber = @wa_twlad_new1.
              ENDIF.
              IF wa_adrc_t_new1 IS NOT INITIAL.
                wa_final-to_place = wa_adrc_t_new1-city1.
                wa_final-ship_to_party   = 'DelVal Flow Controls Private Limited.'.
                wa_adrc_cust-street  = wa_adrc_t_new1-street.
*           wa_adrc_cust-str_suppl2 = WA_ADRC_T_NEW-CITY1.
                wa_adrc_cust-city2 = wa_adrc_t_new1-city1.
                wa_final-to_state = '13'.
                wa_final-to_pincode = wa_adrc_t_new1-post_code1.
                CLEAR : wa_adrc_cust-str_suppl1,
                wa_adrc_cust-str_suppl2.
              ENDIF.

              CONCATENATE wa_adrc_cust-str_suppl1 wa_adrc_cust-street
 INTO wa_final-to_add1 SEPARATED BY space.
              CONDENSE wa_final-to_add1.
              CONCATENATE wa_adrc_cust-str_suppl2 wa_adrc_cust-city2
              INTO wa_final-to_add2 SEPARATED BY space.
               CONDENSE wa_final-to_add2.
            ENDIF.
          ENDIF.
***********************************************************************
        ENDIF.
      ENDIF.

*      ENDIF.

*---------------------GST TAX AND RATE Calculations---------------------------------------------------------
      READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'JOCG' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
      IF sy-subrc = 0.
        IF ls_prcd-kbetr <> 0.
          wa_final-cgst_rate =  ls_prcd-kbetr ."" / 10. NC
          wa_final-cgst_amt = ls_prcd-kwert.
        ENDIF.
      ENDIF.

      CLEAR ls_prcd.

      READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'JOSG' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
      IF sy-subrc = 0.
        IF ls_prcd-kbetr <> 0.
          wa_final-sgst_rate =  ls_prcd-kbetr. "" / 10. NC
          wa_final-sgst_amt = ls_prcd-kwert.
          wa_final-total_val = ls_prcd-kawrt * ls_vbrk_j-kurrf..
        ENDIF.
      ENDIF.

      CLEAR ls_prcd.
      READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'JOIG' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
      IF sy-subrc = 0.
        IF ls_prcd-kbetr <> 0.
          wa_final-igst_rate =  ls_prcd-kbetr. "" / 10. NC
          wa_final-igst_amt = ls_prcd-kwert * ls_vbrk_j-kurrf..
          wa_final-total_val = ls_prcd-kawrt * ls_vbrk_j-kurrf..
        ENDIF.
      ENDIF.
**************ADDED  BY JYOTI ON 20.06.2024************
      IF ls_vbrk_j-fkart = 'ZDC'.
        CLEAR :wa_final-cgst_rate.
        CLEAR : wa_final-sgst_rate.
        CLEAR: wa_final-igst_rate.
      ENDIF.

      CLEAR ls_prcd.
      READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZPR00' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
      IF sy-subrc = 0.
        wa_final-total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
      ENDIF.

      READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZSUB' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
      IF sy-subrc = 0.
        wa_final-total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
      ENDIF.

      READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZSTO' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
      IF sy-subrc = 0.
        wa_final-total_val = ls_prcd-kwert * ls_vbrk_j-kurrf..
      ENDIF.
      CLEAR ls_prcd.
      LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'K004' OR kschl = 'K005' OR kschl = 'K007' OR kschl = 'ZDIS' OR kschl = 'ZGSR')
                                     AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv.
*        IF sy-subrc = 0.
        IF ls_prcd-kwert < 0.
          ls_prcd-kwert = ls_prcd-kwert * -1.
        ENDIF.
        wa_final-discount = ls_prcd-kwert + wa_final-discount.
*        ENDIF.
        CLEAR ls_prcd.
      ENDLOOP.

      SELECT *
        FROM tvarvc
        INTO TABLE @data(lt_tcs_kschl)
        WHERE name = 'ZSD_TCS_KSCHL'.

      LOOP AT lt_tcs_kschl
        ASSIGNING FIELD-SYMBOL(<ls_tcs_kschl>).

        APPEND INITIAL LINE TO lr_tcs_kschl
          ASSIGNING FIELD-SYMBOL(<lrs_tcs_kschl>).

        <lrs_tcs_kschl>-SIGN = 'I'.
        <lrs_tcs_kschl>-OPTION = 'EQ'.
        <lrs_tcs_kschl>-LOW  = <ls_tcs_kschl>-low.

      ENDLOOP.

*      LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'JTC1' OR kschl = 'ZTCS')
*                                     AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
      LOOP AT lt_prcd INTO ls_prcd
        WHERE kschl in lr_tcs_kschl
          AND kposn = wa_vbrp-posnr
          AND knumv = ls_vbrk_j-knumv..

        wa_final-othvalue  =  ls_prcd-kwert.
        tcs = tcs + ls_prcd-kwert.

      ENDLOOP.

      CLEAR:ls_prcd.
      LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'ZIN1' OR kschl = 'ZIN2')
                                     AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
        wa_final-othvalue  = wa_final-othvalue + ls_prcd-kwert.
        inspection  = inspection + ls_prcd-kwert.
      ENDLOOP.

      CLEAR:ls_prcd.
      LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'ZFR1' OR kschl = 'ZFR2')
                                     AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
        wa_final-othvalue  = wa_final-othvalue + ls_prcd-kwert.
        freight  = freight + ls_prcd-kwert.
      ENDLOOP.

      CLEAR:ls_prcd.
      LOOP AT lt_prcd INTO ls_prcd WHERE ( kschl = 'ZTE1' OR kschl = 'ZTE2')
                                     AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
        wa_final-othvalue  = wa_final-othvalue + ls_prcd-kwert.
        testing  = testing + ls_prcd-kwert.

      ENDLOOP.

      CLEAR:ls_prcd.
      LOOP AT lt_prcd INTO ls_prcd WHERE  kschl = 'ZPFO'
                                     AND kposn = wa_vbrp-posnr AND knumv = ls_vbrk_j-knumv..
        wa_final-othvalue  = wa_final-othvalue + ls_prcd-kwert.
        pac_for = pac_for + ls_prcd-kwert.

      ENDLOOP.
      IF ls_vbrk_j-fkart = 'ZDC'.
        LOOP AT lt_prcd INTO ls_prcd WHERE kschl = 'VPRS'.
          wa_final-total_val =  wa_final-total_val + ls_prcd-kwert.

        ENDLOOP.

        READ TABLE tt_a005 INTO wa_a005 WITH KEY matnr = wa_final-material.
        IF sy-subrc IS INITIAL.
          READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'VPRS'  knumv = ls_vbrk_j-knumv  kposn = wa_vbrp-posnr.
          wa_final-total_val =  wa_final-total_val - ls_prcd-kwert.
          CLEAR : wa_konp.
          LOOP AT tt_konp INTO wa_konp WHERE knumh = wa_a005-knumh AND kschl = 'ZSTO'.
*                             AND kposn = wa_final-posnr.

            IF  wa_konp-kschl = 'ZSTO'.
*    CLEAR : ls_json_data-total_val.
*    wa_final-RATE = WA_KONP-KBETR.
              wa_final-total_val =  wa_final-total_val + ( wa_konp-kbetr * wa_vbrp-fkimg ) .

            ENDIF.
          ENDLOOP.
        ENDIF.

      ENDIF.

      IF ls_vbrk_j-fkart = 'ZEXP'.
        wa_final-othvalue = wa_final-othvalue * ls_vbrk_j-kurrf.
      ENDIF.

      IF ls_vbrk_j-fkart = 'ZEXP'.
        IF ls_vbrk_j-taxk6 = '5'.
          wa_final-igst_rate = '0'.
          wa_final-igst_amt = '0'.
        ENDIF.
      ENDIF.
*--------------------------------------------------------------------------------------------------------------
      wa_final-taxable_value = wa_final-total_val - wa_final-discount.
      " Taxable value
**********aDDED BY JYOTI ON 18.06.2024**********************
      IF ls_vbrk_j-fkart = 'ZDC'.
        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'VPRS'
                                          kposn = wa_vbrp-posnr  knumv = ls_vbrk_j-knumv..
        wa_final-taxable_value = ls_prcd-kwert.
*   ENDLOOP.
        READ TABLE tt_a005 INTO wa_a005 WITH KEY matnr = wa_final-material .
        IF sy-subrc IS INITIAL.
          READ TABLE tt_konp INTO wa_konp WITH  KEY knumh = wa_a005-knumh.
          IF wa_konp-kschl = 'ZSTO'.
*               CLEAR : wa_final-taxable_value.
            wa_final-taxable_value =  wa_konp-kbetr *  wa_vbrp-fkimg.
          ENDIF.
        ENDIF.
      ENDIF.

*        READ TABLE lt_prcd INTO ls_prcd WITH KEY kschl = 'ZPR0' kposn = wa_vbrp-posnr knumv = ls_vbrk_j-knumv.
*        IF sy-subrc = 0.
*          wa_final-taxable_value = ls_prcd-kwert.
*        ENDIF.

      IF wa_final-cgst_rate IS INITIAL.
        wa_final-cgst_rate = '0'.
        wa_final-sgst_rate = '0'.
      ENDIF.
      IF wa_final-igst_rate IS INITIAL.
        wa_final-igst_rate = '0'.
      ENDIF.
      IF wa_final-cess_rate IS INITIAL.
        wa_final-cess_rate = '0'.
      ENDIF.

      CONCATENATE  wa_final-cgst_rate '+' wa_final-sgst_rate '+'
      wa_final-igst_rate '+' wa_final-cess_rate INTO wa_final-total_gst_rate.
      CONDENSE wa_final-total_gst_rate NO-GAPS.

*---------------Get Vehicle no------------------------------------------------------------*
      DATA : lv_lifnr TYPE lifnr.
      READ TABLE lt_vbfa INTO ls_vbfa WITH KEY vbeln = wa_vbrp-vbeln vbtyp_v = 'J'.
      IF sy-subrc = 0.
        SELECT SINGLE lifnr INTO lv_lifnr FROM vbpa WHERE vbeln = ls_vbfa-vbelv AND parvw = 'LF'.
      ENDIF.


*        BREAK-POINT.
      READ TABLE lt_vbfa_2 INTO ls_vbfa_2 WITH KEY vbeln = wa_vbrp-vbeln posnn = wa_vbrp-posnr.
      IF sy-subrc = 0.
        READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_vbfa_2-vbelv.
        IF sy-subrc = 0.
          CALL FUNCTION 'CONVERSION_EXIT_AUART_OUTPUT'
            EXPORTING
              input  = ls_vbak-auart
            IMPORTING
              output = wa_final-sales_order_type.
        ENDIF.

        READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = ls_vbfa_2-vbelv posnr = ls_vbfa_2-posnv.
        IF sy-subrc = 0.
          wa_final-cust_mat = ls_vbap-kdmat.
        ENDIF.
      ENDIF.

      READ TABLE lt_kna1 INTO wa_kna1 WITH KEY kunnr = ls_vbrk_j-kunag ktokd = 'ZVEM'.
      IF sy-subrc = 0.
        SELECT SINGLE ebeln, ebelp FROM mseg INTO @DATA(ls_mseg) WHERE mblnr = @wa_vbrp-vgbel.
        IF sy-subrc = 0.
          lv_id   = 'F02'.
          lv_obj  = 'EKPO'.

          CONCATENATE ls_mseg-ebeln ls_mseg-ebelp INTO lv_name.

          CALL FUNCTION 'READ_TEXT'
            EXPORTING
*             CLIENT                  = SY-MANDT
              id                      = lv_id
              language                = lv_lang
              name                    = lv_name
              object                  = lv_obj
*             ARCHIVE_HANDLE          = 0
*             LOCAL_CAT               = ' '
*               IMPORTING
*             HEADER                  =
*             OLD_LINE_COUNTER        =
            TABLES
              lines                   = lt_tab
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
*        Implement suitable error handling here
          ELSE.
            READ TABLE lt_tab INTO DATA(ls_tab) INDEX 1.
            IF sy-subrc = 0.
              wa_final-to_add1 = ls_tab-tdline.

            ENDIF.
            READ TABLE lt_tab INTO ls_tab INDEX 2.
            IF sy-subrc = 0.
              wa_final-to_add2 = ls_tab-tdline.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
      IF wa_final-total_val LT 0.
        wa_final-total_val = wa_final-total_val * -1.
      ENDIF.

      APPEND wa_final TO lt_json_data.
      CLEAR :wa_final,ls_vbrk_j,wa_vbrp,wa_marc,lines[], wa_kna1, wa_adrc, wa_adrc_cust, ls_vbfa,wa_t001w.
    ENDIF.
  ENDIF.
  CLEAR :wa_final,ls_vbrk_j,wa_vbrp,wa_marc,lines[], wa_kna1, wa_adrc, wa_adrc_cust, ls_vbfa.

ENDLOOP.
*BREAK-POINT.

LOOP AT lt_json_data INTO DATA(ls_final2).

  ls_final_eway-zstyp = ls_final2-supply_type.
  ls_final_eway-subsupplytype = ls_final2-sub_type.
  ls_final_eway-subsupplydesc = ''.
  ls_final_eway-doctype    = ls_final2-doc_type.
  IF ls_final2-xblnr IS NOT INITIAL.
    ls_final_eway-docno    = ls_final2-xblnr.
  ELSE.
    ls_final_eway-docno    = ls_final2-doc_no.
  ENDIF.

  ls_final_eway-docdate           = ls_final2-doc_date .

  ls_final_eway-fromgstin       = ls_final2-gstin."'05AAACG5222D1ZA'.
  ls_final_eway-dispatchfromgstin =  ls_final2-gstin.

  ls_final_eway-fromtrdname       = ls_final2-name1.
  ls_final_eway-dispatchfromtradename       = ls_final2-name1. "If kunag and kunnr is same.

  ls_final_eway-fromaddr1         = ls_final2-street.
  ls_final_eway-fromaddr2         = ls_final2-str_suppl3.
  ls_final_eway-fromplace         = ls_final2-location.
  ls_final_eway-frompincode       = ls_final2-post_code1.

  READ TABLE lt_statecode INTO ls_statecode WITH KEY std_state_code = ls_final2-from_state.
  IF sy-subrc = 0.
    ls_final_eway-fromstatecode  = ls_statecode-legal_state_code. "'5'.
    ls_final_eway-actfromstatecode  =  ls_statecode-legal_state_code.

    IF ls_statecode-legal_state_code < 10.
      SHIFT ls_final_eway-fromstatecode LEFT DELETING LEADING '0'.
      SHIFT ls_final_eway-actfromstatecode LEFT DELETING LEADING '0'.
    ENDIF.

    CLEAR ls_statecode.
  ENDIF.

  ls_final_eway-togstin           = ls_final2-to_gstin. "For testing purpose hardcoded '29AAACW6874H1ZS'
  ls_final_eway-shiptogstin       = ls_final2-to_gstin. "If kunag and kunnr is same. For testing purpose hardcoded '29AAACW6874H1ZS'

  ls_final_eway-totrdname         = ls_final2-ship_to_party.
  ls_final_eway-shiptotradename   = ls_final2-ship_to_party. "If kunag and kunnr is same.

  ls_final_eway-toaddr1           = ls_final2-to_add1.
  ls_final_eway-toaddr2           = ls_final2-to_add2.
  ls_final_eway-toplace           = ls_final2-to_place.  "For testing purpose hardcoded "'JALANDHAR'
  ls_final_eway-topincode         = ls_final2-to_pincode. " For testing purpose hardcoded  '560009'.

  READ TABLE lt_statecode INTO ls_statecode WITH KEY std_state_code = ls_final2-to_state.
  IF sy-subrc = 0.
    ls_final_eway-tostatecode     = ls_statecode-legal_state_code. "29 For testing purpose hardcoded
    ls_final_eway-acttostatecode  =  ls_statecode-legal_state_code.  "29 For testing purpose hardcoded


    IF ship_state IS NOT INITIAL.
      READ TABLE lt_statecode INTO ls_statecode WITH KEY std_state_code = ship_state.
      IF sy-subrc = 0.
        ls_final_eway-acttostatecode  =  ls_statecode-legal_state_code.  "29 For testing purpose hardcoded
      ENDIF.
    ENDIF.
    IF bill_to NE ship_to OR bill_pstlz NE ship_pstlz.
      gd_trans = 'Bill To - Ship To'.
    ELSE.
      gd_trans = 'Regular'.
    ENDIF.

    IF ls_statecode-legal_state_code < 10.
      SHIFT ls_final_eway-tostatecode LEFT DELETING LEADING '0'.
      SHIFT ls_final_eway-acttostatecode LEFT DELETING LEADING '0'.
    ENDIF.
    CLEAR ls_statecode.
  ENDIF.

  IF ls_final2-order_type = 'ZEXP'.
    ls_final_eway-tostatecode = '99'.
*      ls_final_eway-acttostatecode = '96'.
  ENDIF.


  ls_final_eway-totalvalue        = ls_final2-total_val + ls_final_eway-totalvalue.

  ls_final_eway-totinvvalue        = ls_final2-total_val .

  ls_final_eway-othvalue          = ls_final_eway-othvalue + ls_final2-othvalue.
  ls_final_eway-cgstvalue         = ls_final_eway-cgstvalue + ls_final2-cgst_amt.
  ls_final_eway-sgstvalue         = ls_final_eway-sgstvalue + ls_final2-sgst_amt.
  ls_final_eway-igstvalue         = ls_final_eway-igstvalue + ls_final2-igst_amt.

  ls_final_eway-cessvalue         = ls_final2-cess_amt.

  READ TABLE lt_vbrk_j INTO ls_vbrk_j WITH KEY vbeln = ls_final2-doc_no.
  IF sy-subrc = 0.
    IF ls_vbrk_j-mwsbk LT 0 .
      ls_vbrk_j-mwsbk = ls_vbrk_j-mwsbk * -1.
    ENDIF.
*
    IF ls_vbrk_j-netwr LT 0.
      ls_vbrk_j-netwr = ls_vbrk_j-netwr * -1.
    ENDIF.

    ls_final_eway-totinvvalue       = ls_vbrk_j-mwsbk + ls_vbrk_j-netwr." + ls_final_eway-totinvvalue. "ls_final-
    IF ls_final2-order_type = 'ZEXP'.

      ls_final_eway-totinvvalue = ls_final_eway-totinvvalue * ls_vbrk_j-kurrf.
    ENDIF.
    IF ls_final2-order_type = 'ZFRS'."AJAY
      CLEAR : ls_final_eway-totinvvalue.

      ls_final_eway-totinvvalue = ls_final2-total_val  + ls_final_eway-igstvalue
                                  + ls_final_eway-cgstvalue + ls_final_eway-sgstvalue.
    ENDIF.
    IF ls_final2-order_type = 'ZDC'.
      DATA(lt_json_data1) = lt_json_data.
      SORT lt_json_data DESCENDING.
      READ TABLE lt_json_data1 INTO DATA(wa) INDEX 1.
      ls_final_eway-totalvalue = wa-total_val.

      ls_final_eway-totinvvalue = wa-total_val + ls_final_eway-totinvvalue.

*    ls_final_eway-totinvvalue = ls_final2-total_val + ls_final_eway-TAXABLE_B.


    ENDIF.

*      ls_final_eway-totalvalue        = ls_vbrk_j-mwsbk + ls_vbrk_j-netwr. "ls_final-
*      CLEAR ls_vbrk_j.
  ENDIF.


*  IF ls_final2-order_type = 'ZEXP'.
*
*    ls_final_eway-totinvvalue = ls_final_eway-totinvvalue +
*     ls_final_eway-igstvalue." + ls_final_eway-othvalue.
*  ENDIF.
  ls_final_eway-mainhsncode       = ls_final2-hsn_sac.

*  gv_total = gv_total + ls_final2-total_val .

  gv_other = gv_other + ls_final_eway-othvalue  .
  gv_cgst  = gv_cgst + ls_final_eway-cgstvalue .
  gv_sgst  = gv_sgst + ls_final_eway-sgstvalue.
  gv_igst  = gv_igst + ls_final_eway-igstvalue .
  IF ls_final2-order_type = 'ZDEX'."AJAY
    gv_igst = '0.00'.
  ENDIF.



  APPEND ls_final_eway TO lt_final_eway.
  CLEAR ls_final_eway.
ENDLOOP.
*BREAK PRIMUSABAP.
LOOP AT lt_json_data INTO DATA(ls_final1)." WHERE doc_no = ls_final2-doc_no.

  ls_itemlist-itemno          = ls_final1-posnr.
  ls_itemlist-productname    = ls_final1-material.
  ls_itemlist-productdesc    = ls_final1-arktx.
  ls_itemlist-hsncode        = ls_final1-hsn_sac.
  IF ls_itemlist-hsncode IS INITIAL.
    ls_itemlist-hsncode = 'null'.
  ENDIF.

  ls_itemlist-quantity       = ls_final1-quantity.

  CALL FUNCTION 'ZEINV_UNIT_CONVERT'
    EXPORTING
      vrkme = ls_final1-uqc
    IMPORTING
      unit  = ls_itemlist-qtyunit.
*                .


  ls_itemlist-taxableamount  = ls_final1-taxable_value.
  ls_itemlist-sgstrate       = ls_final1-sgst_rate.
  ls_itemlist-cgstrate       = ls_final1-cgst_rate.
  ls_itemlist-igstrate       = ls_final1-igst_rate.
  IF ls_vbrk_j-fkart = 'ZDEX'.
    ls_itemlist-igstrate = '0'.
  ENDIF.
  ls_itemlist-cessrate       = ls_final1-cess_rate.
*    ls_itemlist-cessnonadvol   = 'null'.

  srate = ls_final1-cgst_rate.
  irate = ls_final1-igst_rate.

  APPEND ls_itemlist TO lt_itemlist.
  CLEAR ls_itemlist.

ENDLOOP.

READ TABLE lt_final_eway INTO ls_final_eway INDEX 1..

IF ls_vbrk_j-fkart = 'ZEXP'.
  gv_totalinv = ls_final_eway-totinvvalue +
   gv_igst." + ls_final_eway-othvalue.
ENDIF.

IF pac_for IS NOT INITIAL.

  ls_itemlist-productdesc =  'Packing Forwarding'.
  IF ls_vbrk_j-fkart = 'ZEXP'.
    pac_for = pac_for * ls_vbrk_j-kurrf.

  ENDIF.
  ls_itemlist-taxableamount = pac_for.
  ls_itemlist-sgstrate = srate.
  ls_itemlist-cgstrate = srate.
  ls_itemlist-igstrate = irate.
  APPEND ls_itemlist TO lt_itemlist.
  CLEAR ls_itemlist.
ENDIF.
IF inspection IS NOT INITIAL.
  ls_itemlist-productdesc =  'Insurance Charges'.
  IF ls_vbrk_j-fkart = 'ZEXP'.
    inspection = inspection * ls_vbrk_j-kurrf.

  ENDIF.
  ls_itemlist-taxableamount = inspection.
  ls_itemlist-sgstrate = srate.
  ls_itemlist-cgstrate = srate.
  ls_itemlist-igstrate = irate.
  APPEND ls_itemlist TO lt_itemlist.
  CLEAR ls_itemlist.
ENDIF.

IF freight IS NOT INITIAL.
  ls_itemlist-productdesc =  'Freight Charges'.
  IF ls_vbrk_j-fkart = 'ZEXP'.
    freight = freight * ls_vbrk_j-kurrf.
  ENDIF.
  ls_itemlist-taxableamount = freight.
  ls_itemlist-sgstrate = srate.
  ls_itemlist-cgstrate = srate.
  ls_itemlist-igstrate = irate.
  APPEND ls_itemlist TO lt_itemlist.
  CLEAR ls_itemlist.
ENDIF.

IF testing IS NOT INITIAL .
  ls_itemlist-productdesc =  'Testing Charges'.
  IF ls_vbrk_j-fkart = 'ZEXP'.
    testing = testing * ls_vbrk_j-kurrf.
  ENDIF.
  ls_itemlist-taxableamount = testing.
  ls_itemlist-sgstrate = srate.
  ls_itemlist-cgstrate = srate.
  ls_itemlist-igstrate = irate.
  APPEND ls_itemlist TO lt_itemlist.
  CLEAR ls_itemlist.
ENDIF.
SELECT SINGLE zzstatus INTO status FROM zeway_number WHERE
      eway_bill = p_ebillno.

IF status = 'S'.
  gd_image = 'ZEWB_CANCELLED_WATERMARK'.
ELSE.
  gd_image = 'ZEWB_BLANK'.
ENDIF.
