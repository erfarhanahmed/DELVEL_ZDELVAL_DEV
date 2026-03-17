*ITMTXT*&---------------------------------------------------------------------*
* Include           ZSD_PENDING_SO_DATASEL.
*&---------------------------------------------------------------------*
DATA:
    ls_exch_rate TYPE bapi1093_0.

START-OF-SELECTION.
*BREAK primus.
  IF open_so = 'X'.

    SELECT a~vbeln a~posnr
    INTO TABLE it_data
    FROM  vbap AS a
    JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
    WHERE a~erdat  IN s_date
    AND   a~matnr  IN s_matnr
    AND   a~vbeln  IN s_vbeln         "SHREYAS
    AND   b~lfsta  NE 'C'
    AND   b~lfgsa  NE 'C'
    AND   b~fksta  NE 'C'
    AND   b~gbsta  NE 'C'.
*    AND   A~WERKS  = 'PLO1'.



    IF sy-subrc = 0.
      SELECT * FROM vbak INTO TABLE it_vbak FOR ALL ENTRIES IN it_data WHERE vbeln = it_data-vbeln AND
                                                                             kunnr IN s_kunnr.          " SHREYAS.
      PERFORM fill_tables.
      PERFORM process_for_output.
      IF p_down IS   INITIAL.
        PERFORM alv_for_output.
      ELSE.
        PERFORM down_set.
      ENDIF.

    ENDIF.

  ELSEIF all_so = 'X'.
    SELECT * FROM vbak INTO TABLE it_vbak WHERE erdat IN s_date AND
                                                vbeln IN s_vbeln AND "shreyas
                                                kunnr IN s_kunnr . "shreyas.
*                                                bukrs_vf = 'PL01'.

**************************************************************************************
*      select * from vbap INTO TABLE it_vbap FOR ALL ENTRIES IN it_vbak where vbeln = it_vbak-vbeln.
**************************************************************************************
    IF sy-subrc = 0.
      PERFORM fill_tables.
      PERFORM process_for_output.
      IF p_down IS   INITIAL.
        PERFORM alv_for_output.
      ELSE.
*        BREAK Primus.
        PERFORM down_set_all.
      ENDIF.
    ENDIF.

  ELSE.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FILL_TABLES
*&---------------------------------------------------------------------*

FORM fill_tables .
*BREAK PRIMUS.
  IF open_so = 'X'.
    SELECT * FROM vbap INTO TABLE it_vbap FOR ALL ENTRIES IN it_data WHERE vbeln = it_data-vbeln
                                                                       AND posnr = it_data-posnr
                                                                       AND werks = 'PL01'.


**************** Reject Service Sale Order Remove From Pending So(Radio Button)
   LOOP AT it_vbak INTO wa_vbak WHERE AUART = 'ZESS' OR AUART = 'ZSER'.
     LOOP AT it_vbap INTO wa_vbap WHERE vbeln = wa_vbak-vbeln AND abgru NE ' '.
       DELETE it_vbap WHERE vbeln = wa_vbap-vbeln AND posnr = wa_vbap-posnr.
     ENDLOOP.
   ENDLOOP.
**************************************************************************



  ELSE.
    SELECT * FROM vbap INTO TABLE it_vbap FOR ALL ENTRIES IN it_vbak WHERE vbeln = it_vbak-vbeln
                                                                           AND werks = 'PL01'.
  ENDIF.
  IF it_vbap[] IS NOT INITIAL.
    SELECT * FROM vbpa INTO TABLE lt_vbpa FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln.
*                                                                      AND  posnr = it_vbap-posnr.

    SELECT * FROM vbep INTO TABLE it_vbep FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln
                                                                      AND  posnr = it_vbap-posnr.

    SORT it_vbep BY vbeln posnr etenr.

    SELECT * FROM vbep INTO TABLE lt_vbep FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln
                                                                      AND  posnr = it_vbap-posnr
                                                                      AND  etenr = '0001'
                                                                      AND  ettyp = 'CP'.

    SORT lt_vbep BY vbeln posnr etenr.

    SELECT * FROM vbkd INTO TABLE it_vbkd FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln.
    IF it_vbkd IS NOT INITIAL.
      SELECT * FROM t052u INTO TABLE it_t052u FOR ALL ENTRIES IN it_vbkd WHERE spras = 'EN' AND zterm = it_vbkd-zterm.
    ENDIF.


*BREAK primus.
    SELECT * FROM mska INTO TABLE it_mska FOR ALL ENTRIES IN it_vbap
      WHERE vbeln = it_vbap-vbeln
        AND posnr = it_vbap-posnr AND matnr = it_vbap-matnr AND werks = it_vbap-werks.

    IF it_vbak IS NOT INITIAL.

      SELECT * FROM konv INTO TABLE it_konv FOR ALL ENTRIES IN it_vbak WHERE knumv = it_vbak-knumv
                                                                         AND kschl IN s_kschl.

      SELECT * FROM konv INTO TABLE it_konv1 FOR ALL ENTRIES IN it_vbak WHERE knumv = it_vbak-knumv.


      SELECT * FROM vbfa INTO TABLE it_vbfa FOR ALL ENTRIES IN it_vbak WHERE vbelv = it_vbak-vbeln
                                                                         AND ( vbtyp_n = 'J' OR  vbtyp_n = 'M' ).
    ENDIF.
    IF it_vbfa IS NOT INITIAL.
      SELECT * FROM vbrk INTO TABLE it_vbrk FOR ALL ENTRIES IN it_vbfa WHERE vbeln = it_vbfa-vbeln
                                                                        AND  fksto NE 'X'.
    ENDIF.
    IF it_vbrk IS NOT INITIAL.
      SELECT * FROM vbrp INTO TABLE it_vbrp FOR ALL ENTRIES IN it_vbrk WHERE vbeln = it_vbrk-vbeln.
    ENDIF.
    IF it_vbap IS NOT INITIAL.
      SELECT * FROM jest INTO TABLE it_jest FOR ALL ENTRIES IN it_vbap WHERE objnr = it_vbap-objnr
                                                                         AND stat IN s_stat
                                                                         AND inact NE 'X'.
    ENDIF.
    IF it_jest IS NOT INITIAL.
      SELECT * FROM tj30 INTO TABLE it_tj30t FOR ALL ENTRIES IN it_jest WHERE estat = it_jest-stat
                                                                         AND stsma  = 'OR_ITEM'.
    ENDIF.
    """"""""""""""""     Added By KD on 05.05.2017        """""""""""""""

    SELECT aufnr
           posnr
           kdauf
           kdpos
           matnr
           pgmng
           psmng
           wemng
      FROM afpo
      INTO TABLE it_afpo
      FOR ALL ENTRIES IN it_vbap
      WHERE kdauf = it_vbap-vbeln
        AND kdpos = it_vbap-posnr .
    IF sy-subrc = 0.

      SELECT aufnr
             objnr
             kdauf
             kdpos
             igmng
        FROM caufv
        INTO TABLE it_caufv
        FOR ALL ENTRIES IN it_afpo
        WHERE aufnr = it_afpo-aufnr
        AND   kdauf = it_afpo-kdauf
        AND   kdpos = it_afpo-kdpos
        AND   loekz = space.

    ENDIF.
    """""""""""""""   END 05.05.2017         """"""""""""""""""""""""""





  ENDIF.

  IF lt_vbpa IS NOT INITIAL.

    SELECT * FROM adrc INTO TABLE lt_adrc FOR ALL ENTRIES IN lt_vbpa WHERE addrnumber = lt_vbpa-adrnr AND country = 'IN'.
    IF lt_adrc IS NOT INITIAL.
      FIELD-SYMBOLS : <f1> TYPE zgst_region.

      SELECT * FROM zgst_region INTO TABLE lt_zgst_region ."FOR ALL ENTRIES IN lt_adrc WHERE region = lt_adrc-region.
      LOOP AT lt_zgst_region ASSIGNING <f1>.
        DATA(lv_str_l) =  strlen( <f1>-region )  .
        IF lv_str_l = 1.
          CONCATENATE '0' <f1>-region INTO <f1>-region.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDIF.

  SELECT * FROM kna1 INTO TABLE it_kna1 FOR ALL ENTRIES IN it_vbak WHERE kunnr = it_vbak-kunnr.

*****************Added By Saurabh Kolapkar
  IF NOT it_afpo IS INITIAL.
    SELECT rsnum
           rspos
           rsart
           bdmng
           enmng
           aufnr
           kdauf
           kdpos
      FROM resb
      INTO TABLE lt_resb
      FOR ALL ENTRIES IN it_afpo
      WHERE aufnr = it_afpo-aufnr
      AND   kdauf = it_afpo-kdauf
      AND   kdpos = it_afpo-kdpos.

  ENDIF.
ENDFORM.                    " FILL_TABLES
*&---------------------------------------------------------------------*
*&      Form  PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*

FORM process_for_output .
  DATA:
    lv_ratio TYPE resb-enmng,
    lv_qty   TYPE resb-enmng,
    lv_index TYPE sy-tabix.
  IF it_vbap[] IS NOT INITIAL.
    CLEAR: wa_vbap, wa_vbak, wa_vbep, wa_mska,
           wa_vbrp, wa_konv, wa_kna1.
    SORT it_vbap BY vbeln posnr matnr werks.
    SORT it_mska BY vbeln posnr matnr werks.
    SORT it_afpo BY kdauf kdpos matnr.
    SORT lt_resb BY aufnr kdauf kdpos.
    LOOP AT it_vbap INTO wa_vbap.

      READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbap-vbeln.
      READ TABLE it_vbep INTO wa_vbep WITH KEY vbeln = wa_vbap-vbeln
                                               posnr = wa_vbap-posnr
                                               etenr = '0001'.

      READ TABLE lt_vbep INTO ls_vbep WITH KEY vbeln = wa_vbap-vbeln
                                               posnr = wa_vbap-posnr
                                               etenr = '0001'
                                               ettyp = 'CP'.

      READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = wa_vbap-vbeln.

*                                               posnr = wa_vbap-posnr.

      READ TABLE it_t052u INTO wa_t052u WITH KEY zterm = wa_vbkd-zterm.

      READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_vbap-vbeln
                                               posnr = wa_vbap-posnr.

**TPI TEXT



      CLEAR: lv_lines, wa_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z999'
          language                = 'E'
          name                    = lv_name
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      READ TABLE lv_lines INTO wa_lines INDEX 1.

*LD Req Text
      CLEAR: lv_lines, wa_ln_ld.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z038'
          language                = 'E'
          name                    = lv_name
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      READ TABLE lv_lines INTO wa_ln_ld INDEX 1.

**********
*Tag Required
      CLEAR: lv_lines, wa_tag_rq.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z039'
          language                = 'E'
          name                    = lv_name
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      READ TABLE lv_lines INTO wa_tag_rq INDEX 1.


**********


*Material text
      CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = wa_vbap-matnr.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_name
          object                  = 'MATERIAL'
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      READ TABLE lv_lines INTO ls_mattxt INDEX 1.

*konv data
      CLEAR: wa_konv1, wa_output.

      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kposn = wa_vbap-posnr kschl = 'JOCG'.
      IF sy-subrc = 0.
        CLEAR : lv_cgst,lv_cgst_temp.
        lv_cgst =  wa_konv1-kbetr / 10.
        lv_cgst_temp = lv_cgst.
        CONDENSE lv_cgst_temp.
        wa_output-cgst = lv_cgst_temp.

*        wa_output-cgst_val = wa_konv1-kwert.

        wa_output-sgst = lv_cgst_temp.
*        wa_output-sgst_val = wa_konv1-kwert.
      ENDIF.
      CLEAR: wa_konv1.
      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kposn = wa_vbap-posnr kschl = 'JOIG'.
      IF sy-subrc = 0.
        CLEAR : lv_cgst,lv_cgst_temp.
        lv_cgst =  wa_konv1-kbetr / 10.
        lv_cgst_temp = lv_cgst.
        wa_output-igst = lv_cgst_temp.
*        wa_output-igst_val = wa_konv1-kwert.
      ENDIF.

      CLEAR: wa_konv1.
      READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kposn = wa_vbap-posnr kschl = 'JTC1'.
      IF SY-SUBRC = 0.
        wa_output-tcs = wa_konv1-kbetr / 10.
        wa_output-tcs_amt = wa_konv1-kwert.
      ENDIF.
      CLEAR: wa_konv.


*      READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbak-knumv
      SELECT SINGLE * FROM konv INTO wa_konv WHERE  knumv = wa_vbak-knumv
                                             AND   kposn = wa_vbap-posnr
                                             AND   kschl = 'ZPR0'.
*      IF wa_vbap-waerk <> 'INR'.
*        IF wa_konv-waers <> 'INR'.
*          wa_konv-kbetr = wa_konv-kbetr * wa_vbkd-kursk.
*        ENDIF.
*      ENDIF.

      wa_output-kbetr       = wa_konv-kbetr.           "Rate

      CLEAR: wa_konv .
*      READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbak-knumv
      SELECT SINGLE * FROM konv INTO wa_konv WHERE knumv = wa_vbak-knumv
                                             AND   kposn = wa_vbap-posnr
                                             AND   kschl = 'VPRS'.
      IF wa_vbap-waerk <> 'INR'.
        IF wa_konv-waers <> 'INR'.
          wa_konv-kbetr = wa_konv-kbetr * wa_vbkd-kursk.
        ENDIF.
      ENDIF.

      wa_output-in_price    = wa_konv-kbetr.           "Internal Price
*      wa_output-in_pr_dt    = wa_konv-kdatu.           "Internal Price Date

      CLEAR: wa_konv .
*      READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbak-knumv
      SELECT SINGLE * FROM konv INTO wa_konv WHERE knumv = wa_vbak-knumv
                                             AND   kposn = wa_vbap-posnr
                                             AND  kschl = 'ZESC'.
      IF wa_vbap-waerk <> 'INR'.
        IF wa_konv-waers <> 'INR'.
          wa_konv-kbetr = wa_konv-kbetr * wa_vbkd-kursk.
        ENDIF.
      ENDIF.

      wa_output-est_cost    = wa_konv-kbetr.           "Estimated cost

      CLEAR wa_kna1.
      READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbak-kunnr.


      CLEAR wa_jest1.
      READ TABLE it_jest INTO wa_jest1 WITH KEY objnr = wa_vbap-objnr.

      SELECT SINGLE * FROM tj30t INTO wa_tj30t  WHERE estat = wa_jest1-stat
                                                AND stsma  = 'OR_ITEM'
                                                AND spras  = 'EN'.
      CLEAR : wa_mska.
*      READ TABLE it_mska INTO wa_mska WITH KEY vbeln = wa_vbap-vbeln
*                                               posnr = wa_vbap-posnr
*                                               matnr = wa_vbap-matnr
*                                               werks = wa_vbap-werks.
*   break primus.

      LOOP AT it_mska INTO wa_mska WHERE vbeln = wa_vbap-vbeln AND
                                         posnr = wa_vbap-posnr AND
                                         matnr = wa_vbap-matnr AND
                                         werks = wa_vbap-werks.

        CASE wa_mska-lgort.
          WHEN 'FG01'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'TPI1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'PRD1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'RM01'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'RWK1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'SC01'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'SFG1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'SPC1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'SRN1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'VLD1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'SLR1'.
            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
        ENDCASE.

      ENDLOOP.


*DELIVARY QTY
*      CLEAR wa_vbfa.
*      READ TABLE it_vbfa INTO wa_vbfa WITH KEY   vbelv = wa_vbap-vbeln
*                                                 posnv = wa_vbap-posnr
*                                               vbtyp_n = 'J'.
*      CLEAR wa_lfimg.
*      SELECT SUM( lfimg ) FROM lips INTO  wa_lfimg  WHERE vbeln = wa_vbfa-vbeln
*                                                    AND   pstyv = 'ZTAN'
*                                                    AND   vgbel = wa_vbap-vbeln
*                                                    AND   vgpos = wa_vbap-posnr.
*INVOICE QTY
*      CLEAR wa_vbfa.
*      READ TABLE it_vbfa INTO wa_vbfa WITH KEY   vbelv = wa_vbap-vbeln
*                                                 posnv = wa_vbap-posnr
*                                               vbtyp_n = 'M'.
*
*      CLEAR wa_vbrk.
*      READ TABLE it_vbrk INTO wa_vbrk WITH KEY   vbeln = wa_vbfa-vbeln.
*
*
*      CLEAR wa_fkimg.
*      SELECT SUM( fkimg ) FROM vbrp INTO  wa_fkimg  WHERE  vbeln = wa_vbrk-vbeln
*                                                     AND   aubel = wa_vbap-vbeln
*                                                     AND   aupos = wa_vbap-posnr.

*DELIVARY QTY
      CLEAR: wa_vbfa, wa_lfimg, wa_lfimg_sum.
      LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_vbap-vbeln
                                   AND posnv = wa_vbap-posnr
                                   AND vbtyp_n = 'J'.

        CLEAR wa_lfimg.
        SELECT SINGLE lfimg FROM lips INTO  wa_lfimg  WHERE vbeln = wa_vbfa-vbeln
                                                      AND   pstyv = 'ZTAN'
                                                      AND   vgbel = wa_vbap-vbeln
                                                      AND   vgpos = wa_vbap-posnr.
        wa_lfimg_sum = wa_lfimg_sum + wa_lfimg .

      ENDLOOP.

*INVOICE QTY
      CLEAR: wa_vbfa, wa_fkimg, wa_fkimg_sum.
      LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_vbap-vbeln
                                     AND posnv = wa_vbap-posnr
                                     AND vbtyp_n = 'M'.

        CLEAR wa_vbrk.
        READ TABLE it_vbrk INTO wa_vbrk WITH KEY   vbeln = wa_vbfa-vbeln.

        CLEAR wa_fkimg.
        SELECT SINGLE fkimg FROM vbrp INTO  wa_fkimg  WHERE vbeln = wa_vbrk-vbeln
                                                      AND   aubel = wa_vbap-vbeln
                                                      AND   aupos = wa_vbap-posnr.
        wa_fkimg_sum = wa_fkimg_sum + wa_fkimg .
      ENDLOOP.

****
      CLEAR wa_mbew.
      SELECT SINGLE * FROM mbew INTO wa_mbew WHERE matnr = wa_vbap-matnr
                                               AND bwkey = wa_vbap-werks.

      CLEAR wa_mara.
      SELECT SINGLE * FROM mara INTO wa_mara WHERE matnr = wa_vbap-matnr.

      """"""""""     Added By KD on 04.05.2017    """""""""""
      SELECT SINGLE dispo FROM marc INTO wa_output-dispo WHERE matnr = wa_vbap-matnr.
      """""""""""""""""""""""""""""""""""""""""""""""""""
*currency conversion
      REFRESH ls_fr_curr.
      CLEAR ls_fr_curr.
      ls_fr_curr-sign   = 'I'.
      ls_fr_curr-option = 'EQ'.
      ls_fr_curr-low = wa_vbak-waerk.
      APPEND ls_fr_curr.
      CLEAR: ls_ex_rate,lv_ex_rate, ls_return.
      REFRESH: ls_ex_rate, ls_return.
      IF ls_to_curr-low <> ls_fr_curr-low.

        CALL FUNCTION 'BAPI_EXCHRATE_GETCURRENTRATES'
          EXPORTING
            date             = sy-datum
            date_type        = 'V'
            rate_type        = 'B'
          TABLES
            from_curr_range  = ls_fr_curr
            to_currncy_range = ls_to_curr
            exch_rate_list   = ls_ex_rate
            return           = ls_return.

        CLEAR lv_ex_rate.
        READ TABLE ls_ex_rate INTO lv_ex_rate INDEX 1.
      ELSE.
        lv_ex_rate-exch_rate = 1.
      ENDIF.

*Latest Estimated cost

      REFRESH: it_konh.
      CLEAR:   it_konh.

*  FOR ZESC
      SELECT * FROM konh INTO TABLE it_konh WHERE kotabnr = '508'
                                              AND kschl  = 'ZESC'
*                                              AND vakey = wa_vbap-matnr
                                              AND datab <= sy-datum
                                              AND datbi >= sy-datum .

      SORT  it_konh DESCENDING BY knumh .
      CLEAR wa_konh.
      READ TABLE it_konh INTO wa_konh INDEX 1.

      CLEAR wa_konp.
      SELECT SINGLE * FROM konp INTO wa_konp WHERE knumh = wa_konh-knumh
                                              AND kschl  = 'ZESC'.

*MRP DATE
**break primus.
      CLEAR wa_cdpos.
      DATA tabkey TYPE cdpos-tabkey.
      CONCATENATE sy-mandt wa_vbep-vbeln wa_vbep-posnr wa_vbep-etenr INTO tabkey.
      SELECT * FROM cdpos INTO TABLE it_cdpos WHERE tabkey = tabkey

**                                               AND value_new = 'CP'
**                                               AND value_old = 'CN'
                                               AND tabname = 'VBEP' AND fname = 'ETTYP'.
      SORT it_cdpos BY changenr DESCENDING.
      READ TABLE it_cdpos INTO wa_cdpos INDEX 1.
      IF wa_cdpos-value_new = 'CP' .
        SELECT SINGLE * FROM cdhdr INTO wa_cdhdr WHERE changenr = wa_cdpos-changenr.
        wa_output-mrp_dt      = wa_cdhdr-udate.           "MRP date EDATU to TDDAT changed by Pranav Khadatkar
      ENDIF.
      CLEAR wa_cdhdr.

*      ***************Avinash Bhagat 21.12.2018******************************************************
*      break primus.
      CLEAR wa_tvagt.
      SELECT SINGLE
        spras
        abgru
        bezei
         FROM tvagt INTO  wa_tvagt  WHERE abgru = wa_vbap-abgru AND spras = 'E'.


*      READ TABLE it_tvagt INTO wa_tvagt WITH KEY abgru = wa_vbap-abgru.
*******************************************


*********************************************************************

***************Commented By Saurabh K 13.7.17

**                                             AND tcode = 'ZUNLOCKMRP'.

***      CLEAR  wa_output-mrp_dt.
***      IF sy-subrc = 0.
***        wa_output-mrp_dt  = wa_cdhdr-udate.
***      ENDIF.
*Sales text
      CLEAR: lv_lines, ls_itmtxt.
      REFRESH lv_lines.
      CONCATENATE wa_vbak-vbeln wa_vbap-posnr INTO lv_name.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = '0001'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBP'
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

IF lv_lines IS NOT INITIAL.
  LOOP AT lv_lines INTO ls_itmtxt.
    IF ls_itmtxt-tdline IS NOT INITIAL.
      CONCATENATE wa_output-itmtxt ls_itmtxt-tdline INTO wa_output-itmtxt SEPARATED BY SPACE.
    ENDIF.
  ENDLOOP.
ENDIF.
*wa_output-itmtxt = ls_itmtxt-tdline.

********Insurance
CLEAR: lv_lines, ls_itmtxt.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z017'
          language                = sy-langu
          name                    = lv_name
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

IF lv_lines IS NOT INITIAL.
  LOOP AT lv_lines INTO ls_itmtxt.
    IF ls_itmtxt-tdline IS NOT INITIAL.
      CONCATENATE wa_output-insur ls_itmtxt-tdline INTO wa_output-insur SEPARATED BY SPACE.
    ENDIF.
  ENDLOOP.
ENDIF.

********Insurance
CLEAR: lv_lines, ls_itmtxt.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z047'
          language                = sy-langu
          name                    = lv_name
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

IF lv_lines IS NOT INITIAL.
  LOOP AT lv_lines INTO ls_itmtxt.
    IF ls_itmtxt-tdline IS NOT INITIAL.
      CONCATENATE wa_output-pardel ls_itmtxt-tdline INTO wa_output-pardel SEPARATED BY SPACE.
    ENDIF.
  ENDLOOP.
ENDIF.

      wa_output-werks       = wa_vbap-werks.           "PLANT
      wa_output-auart       = wa_vbak-auart.           "ORDER TYPE
      wa_output-so_exc      = wa_vbkd-kursk.           "SO Exchange Rate
      wa_output-bstkd       = wa_vbkd-bstkd.           "Cust Ref No.
      wa_output-zterm       = wa_vbkd-zterm.           "payment terms
      wa_output-inco1       = wa_vbkd-inco1.           "inco terms
      wa_output-inco2       = wa_vbkd-inco2.           "inco terms description
      wa_output-name1       = wa_kna1-name1.           "Cust Name
      wa_output-text1       = wa_t052u-text1.          "payment terms description
      wa_output-vkbur       = wa_vbak-vkbur.           "Sales Office
      wa_output-vbeln       = wa_vbak-vbeln.           "Sales Order
      wa_output-erdat       = wa_vbak-erdat.           "Sales Order date
      wa_output-vdatu       = wa_vbak-vdatu.           "Req del date
      wa_output-status      = wa_tj30t-txt30.          "Hold/Unhold
      wa_output-holddate    = wa_vbap-holddate.        "Statsu
      wa_output-reldate     = wa_vbap-holdreldate.     "Release date
      wa_output-canceldate  = wa_vbap-canceldate.      "Cancel date
      wa_output-deldate     = wa_vbap-deldate.         "delivary date
      wa_output-custdeldate     = wa_vbap-custdeldate.         "customer del. date
      wa_output-posex      = wa_vbap-posex.
      wa_output-bstdk      = wa_vbak-bstdk.
      wa_output-LIFSK      = wa_vbak-LIFSK.
      wa_output-po_del_date = wa_vbap-custdeldate.

*      SELECT SINGLE custdeldate INTO wa_output-custdeldate FROM vbap WHERE vbeln = wa_output-vbeln .

      SELECT SINGLE vtext INTO wa_output-vtext FROM tvlst WHERE lifsp = wa_vbak-lifsk AND spras = 'EN'.
      CLEAR wa_text.
      wa_text = wa_tag_rq-tdline(20).
      TRANSLATE wa_text TO UPPER CASE .       "tag Required
      wa_output-tag_req     = wa_text(1).
      wa_output-matnr       = wa_vbap-matnr.           "Material
      wa_output-posnr       = wa_vbap-posnr.           "item
      wa_output-arktx       = wa_vbap-arktx.           "item short description
      wa_output-kwmeng      = wa_vbap-kwmeng.          "sales order qty
*      wa_output-kalab       = wa_mska-kalab.           "stk qty
*      wa_output-kalab       = stock.           "stk qty
*      wa_output-lfimg       = wa_lfimg.                "del qty

      IF wa_vbap-zgad = '1'.
        wa_output-gad = 'Reference'.
      ELSEIF wa_vbap-zgad = '2'.
        wa_output-gad = 'Approved'.
      ELSEIF wa_vbap-zgad = '3'.
        wa_output-gad = 'Standard'.
      ENDIF.


      wa_output-lfimg       = wa_lfimg_sum.                "del qty
*      wa_output-fkimg       = wa_fkimg.                "inv qty
      wa_output-fkimg       = wa_fkimg_sum.                "inv qty
      wa_output-pnd_qty     = wa_output-kwmeng - wa_output-fkimg.  "Pending Qty
      wa_output-ettyp       = wa_vbep-ettyp.           "So Status
      wa_output-edatu       = wa_vbep-edatu.           "delivary Date
      wa_output-etenr       = wa_vbep-etenr.           "Schedule line no.
      IF wa_tvagt-abgru IS INITIAL.
        wa_output-abgru           =  '-'.   " avinash bhagat 20.12.2018
      ELSE.
        wa_output-abgru           =  wa_tvagt-abgru.   " avinash bhagat 20.12.2018
      ENDIF.
      IF wa_tvagt-bezei IS INITIAL.
        wa_output-bezei           =  '-'.   " avinash bhagat 20.12.2018
      ELSE.
        wa_output-bezei           =  wa_tvagt-bezei.   " avinash bhagat 20.12.2018
      ENDIF.
      CONCATENATE wa_output-vbeln wa_output-posnr wa_output-etenr
        INTO wa_output-schid(25).

      DATA lv_qmqty TYPE mska-kains.
      CLEAR lv_qmqty.

      READ TABLE it_mska INTO wa_mska WITH KEY vbeln = wa_vbap-vbeln
                                               posnr = wa_vbap-posnr
                                               matnr = wa_vbap-matnr
                                               werks = wa_vbap-werks.
      IF sy-subrc IS INITIAL.
        lv_index = sy-tabix.
        LOOP AT it_mska INTO wa_mska FROM lv_index.
          IF wa_mska-vbeln = wa_vbap-vbeln AND wa_mska-posnr = wa_vbap-posnr
           AND wa_mska-matnr = wa_vbap-matnr AND wa_mska-werks = wa_vbap-werks.
*            lv_qmqty = wa_mska-kains - lv_qmqty.
            lv_qmqty = wa_mska-kains + lv_qmqty.
          ELSE.
            CLEAR lv_index.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.



**      LOOP AT it_mska INTO wa_mska WHERE vbeln = wa_vbap-vbeln
**                                                 AND posnr = wa_vbap-posnr
**                                                 AND matnr = wa_vbap-matnr
**                                                 AND werks = wa_vbap-werks.
**        lv_qmqty = wa_mska-kains - lv_qmqty.
**
**      ENDLOOP.
      wa_output-qmqty = lv_qmqty.
      wa_output-mattxt = ls_mattxt-tdline.



      CLEAR wa_text.
      wa_text = wa_lines-tdline(20).
      TRANSLATE wa_text TO UPPER CASE .
      wa_output-tpi         = wa_text.     "TPI Required
      CLEAR wa_text.
      wa_text = wa_ln_ld-tdline(20).     "wa_ln_ld ld_req
      TRANSLATE wa_text TO UPPER CASE .
      wa_output-ld_txt         = wa_text(1).     "lD Required
*      wa_output-kbetr       = wa_.           "Rate
      wa_output-zldperweek   = wa_vbak-zldperweek.  "LD per week
      wa_output-zldmax       = wa_vbak-zldmax.      "LD Max
      wa_output-zldfromdate  = wa_vbak-zldfromdate. "LD from date
      wa_output-kunnr        = wa_vbak-kunnr.
      wa_output-waerk        = wa_vbap-waerk.           "Currency
      wa_output-kdmat        = wa_vbap-kdmat.
      wa_output-curr_con     = lv_ex_rate-exch_rate.    "Currency conversion


*      CATCH SYSTEM-EXCEPTIONS conversion_errors = 1
*                                          arithmetic_errors = 5.
      IF lv_ex_rate-exch_rate IS NOT INITIAL.
        wa_output-amont       = wa_output-pnd_qty * wa_output-kbetr *
                                lv_ex_rate-exch_rate.    "Amount
        wa_output-ordr_amt    = wa_output-kwmeng * wa_output-kbetr *
                                lv_ex_rate-exch_rate.    "Ordr Amount
      ELSEIF lv_ex_rate-exch_rate IS INITIAL.
        wa_output-amont       = wa_output-pnd_qty * wa_output-kbetr .
        wa_output-ordr_amt    = wa_output-kwmeng * wa_output-kbetr .
      ENDIF.
*      ENDCATCH.
      wa_output-in_pr_dt    = wa_mbew-laepr.           "Internal Price Date
      wa_output-st_cost     = wa_mbew-stprs .          "Standard Cost
*      wa_output-latst_cost   =  wa_KONV-KBETR.                    "
      wa_output-latst_cost    = wa_konp-kbetr.        "LATEST EST COST
      wa_output-zseries     = wa_mara-zseries.         "series
      wa_output-zsize       = wa_mara-zsize.           "size
      wa_output-brand       = wa_mara-brand.           "Brand
      wa_output-moc         = wa_mara-moc.             "MOC
      wa_output-type        = wa_mara-type.            "TYPE
      wa_output-mtart        = wa_mara-mtart.          " Material TYPE        """" Addded by KD on 05.05.2017
      wa_output-wrkst        = wa_mara-wrkst.          "Basic Material(Usa Item Code)
      wa_output-normt      = wa_mara-normt.


      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z015'
          language                = 'E'
          name                    = lv_name
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
* Implement suitable error handling here
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-ofm ls_lines-tdline INTO wa_output-ofm SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT                  = SY-MANDT
          id                      = 'Z016'
          language                = 'E'
          name                    = lv_name
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
* Implement suitable error handling here
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-ofm_date ls_lines-tdline INTO wa_output-ofm_date SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.



      CLEAR :lv_lines,ls_lines.
      REFRESH lv_lines.
      lv_name = wa_vbak-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z020'
          language                = 'E'
          name                    = lv_name
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
* Implement suitable error handling here
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO ls_lines.
          IF NOT ls_lines-tdline IS INITIAL.
            CONCATENATE wa_output-spl ls_lines-tdline INTO wa_output-spl SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.








      """""""""""   Added By KD on 05.05.2017  """"""""""""""""
*      BREAK kdeshmukh .
      REFRESH : it_jest2 , it_jest2[] .
      CLEAR : wa_afpo , wa_caufv.
*      READ TABLE it_afpo INTO wa_afpo WITH KEY kdauf = wa_vbap-vbeln kdpos = wa_vbap-posnr .
      LOOP AT it_afpo INTO wa_afpo WHERE kdauf = wa_vbap-vbeln
                                     AND kdpos = wa_vbap-posnr
                                     AND matnr = wa_vbap-matnr.
***        IF sy-subrc = 0.
***          LOOP AT lt_resb INTO ls_resb WHERE aufnr = wa_afpo-aufnr
***                                       AND   kdauf = wa_afpo-kdauf
***                                       AND   kdpos = wa_afpo-kdpos.
***
***            lv_ratio = ls_resb-bdmng / wa_afpo-psmng.
***            lv_qty   =  ( ls_resb-enmng - ( wa_afpo-wemng * lv_ratio ) ) + lv_qty .
***          ENDLOOP.
***
*break-POINT.
        READ TABLE it_caufv INTO wa_caufv WITH KEY aufnr = wa_afpo-aufnr
                                                   kdauf = wa_afpo-kdauf
                                                   kdpos = wa_afpo-kdpos.
        IF sy-subrc = 0.
          SELECT objnr stat FROM jest INTO TABLE it_jest2
                                WHERE objnr = wa_caufv-objnr
                                  AND inact = ' '.
********************************Commented by SK(22.09.17)
          CLEAR wa_jest2 .
          READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0012' BINARY SEARCH .
          IF sy-subrc NE 0.
            CLEAR wa_jest2 .
            READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0009' BINARY SEARCH .
            IF sy-subrc NE 0.
              CLEAR wa_jest2 .
              READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0002' BINARY SEARCH .
              IF sy-subrc = 0.
                wa_output-wip = wa_output-wip + wa_afpo-psmng - wa_caufv-igmng ."wa_afpo-pgmng
              ENDIF.
            ENDIF.
          ENDIF.

***********************************************************************************************

*            IF it_jest2[] IS NOT INITIAL.
*              CLEAR wa_jest2 .
*              LOOP AT it_jest2 INTO wa_jest2.
*                CLEAR wa_tj02t .
*                SELECT SINGLE istat txt04 FROM tj02t INTO wa_tj02t WHERE istat = wa_jest2-stat AND spras = 'EN'.
*                IF sy-subrc = 0 AND wa_tj02t-txt04 = 'REL'.
*                  wa_output-wip = wa_output-wip + wa_afpo-pgmng .
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
***          ENDIF.
        ENDIF.

      ENDLOOP.

      """""""""""""""""""""""""""""""""""""""""""""""""""""""""
***      IF lv_qty GE 0.
***        wa_output-wip = lv_qty.
***      ELSE.
***        wa_output-wip = 0.
***      ENDIF.
***      CLEAR lv_qty.
      wa_output-ref_dt = sy-datum.
      """ Ship to party logic

      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln posnr = wa_vbap-posnr parvw = 'WE'.
      IF sy-subrc = 0.
        wa_output-ship_kunnr = ls_vbpa-kunnr.
        wa_output-ship_land = ls_vbpa-land1.
        READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
        IF sy-subrc = 0.
          wa_output-ship_kunnr_n = ls_adrc-name1.
          READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY region = ls_adrc-region.
          IF sy-subrc = 0.
            wa_output-ship_reg_n = ls_zgst_region-bezei.
          ENDIF.
        ENDIF.
      ELSE.
        READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln posnr = ' '  parvw = 'WE'.
        wa_output-ship_kunnr = ls_vbpa-kunnr.
        wa_output-ship_land = ls_vbpa-land1.
        READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
        IF sy-subrc = 0.
          wa_output-ship_kunnr_n = ls_adrc-name1.
          READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY region = ls_adrc-region.
          IF sy-subrc = 0.
            wa_output-ship_reg_n = ls_zgst_region-bezei.
          ENDIF.
        ENDIF.
      ENDIF.

      "Sold to party region logic

      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln parvw = 'AG'.
      IF sy-subrc = 0.
        wa_output-sold_land = ls_vbpa-land1.
        READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
        IF sy-subrc = 0.
*          wa_output-ship_kunnr_n = ls_adrc-name1.
          READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY region = ls_adrc-region.
          IF sy-subrc = 0.
            wa_output-sold_reg_n = ls_zgst_region-bezei.
          ENDIF.
        ENDIF.
      ENDIF.

      SELECT SINGLE LANDX50 INTO wa_output-s_land_desc FROM t005t WHERE spras = 'EN' AND land1 = wa_output-ship_land.


      APPEND wa_output TO it_output.
      CLEAR :ls_vbep,wa_vbep.
      CLEAR:wa_output-wip,wa_output-stock_qty .
      CLEAR wa_output.
    ENDLOOP.
*BREAK primus.

  ENDIF.

  """"""""""""""""""        Added By KD on 05.05.2017                 """""""""""""
  IF it_output[] IS NOT INITIAL.
    REFRESH : it_oauto , it_oauto[] , it_mast , it_mast[] , it_stko , it_stko[] ,
              it_stpo , it_stpo[] , it_mara , it_mara[] , it_makt , it_makt[] .

    it_oauto[] = it_output[] .
    BREAK kdeshmukh.
    DELETE it_oauto WHERE dispo NE 'AUT' .
    DELETE it_oauto WHERE mtart NE 'FERT'.

    SELECT matnr werks stlan stlnr stlal FROM mast INTO TABLE it_mast
                                            FOR ALL ENTRIES IN it_oauto
                                                  WHERE matnr = it_oauto-matnr
                                                    AND stlan = 1.

    SELECT stlty stlnr stlal stkoz FROM stko INTO TABLE it_stko
                                      FOR ALL ENTRIES IN it_mast
                                                  WHERE stlnr = it_mast-stlnr
                                                    AND stlal = it_mast-stlal.

    SELECT stlty stlnr stlkn stpoz idnrk FROM stpo INTO TABLE it_stpo
                                            FOR ALL ENTRIES IN it_stko
                                                        WHERE stlnr = it_stko-stlnr
                                                          AND stpoz = it_stko-stkoz .

    SELECT * FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_stpo
                                                    WHERE matnr = it_stpo-idnrk
                                                      AND mtart = 'FERT' .

    SELECT * FROM makt INTO TABLE it_makt FOR ALL ENTRIES IN it_mara
                                                      WHERE matnr = it_mara-matnr
                                                        AND spras = 'EN'.

    CLEAR wa_output .
    LOOP AT it_makt INTO wa_makt .
      READ TABLE it_stpo INTO wa_stpo WITH KEY idnrk = wa_makt-matnr .
      IF sy-subrc = 0.
        READ TABLE it_stko INTO wa_stko WITH KEY stlnr = wa_stpo-stlnr stkoz = wa_stpo-stpoz .
        IF sy-subrc = 0.
          READ TABLE it_mast INTO wa_mast WITH KEY stlnr = wa_stko-stlnr stlal = wa_stko-stlal.
          IF sy-subrc = 0.
            wa_output-matnr = wa_mast-matnr.
*            wa_output-scmat = wa_makt-matnr.
            wa_output-arktx = wa_makt-maktx.

            APPEND wa_output TO it_output.
            CLEAR wa_output .
          ENDIF.
        ENDIF.
      ENDIF.
      CLEAR : wa_mast , wa_stko , wa_stpo , wa_makt.
    ENDLOOP.

  ENDIF.
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

ENDFORM.                    " PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
FORM alv_for_output .
*ADDING TOP OF PAGE FEATURE
  PERFORM stp3_eventtab_build   CHANGING gt_events[].
  PERFORM comment_build         CHANGING i_list_top_of_page[].
  PERFORM top_of_page.
  PERFORM layout_build          CHANGING wa_layout.
****************************************************************************************

  PERFORM build_fieldcat USING 'WERKS'          'X' '1'   'Plant'(003)                    '15'.
  PERFORM build_fieldcat USING 'AUART'          'X' '2'   'Order Type'(004)               '15'.
  PERFORM build_fieldcat USING 'BSTKD'          'X' '3'   'Customer Reference No'(005)    '15'.
  PERFORM build_fieldcat USING 'NAME1'          'X' '4'   'Customer'(006)                 '15'.
  PERFORM build_fieldcat USING 'VKBUR'          'X' '5'   'Sales Office'(007)             '15'.
  PERFORM build_fieldcat USING 'VBELN'          'X' '6'   'Sales Doc No'(008)             '15'.
  PERFORM build_fieldcat USING 'ERDAT'          'X' '7'   'So Date'(009)                  '15'.
  PERFORM build_fieldcat USING 'VDATU'          'X' '8'   'Required Delivery Dt'          '15'."(010).
  PERFORM build_fieldcat USING 'STATUS'         'X' '9'   'HOLD/UNHOLD'(011)              '15'.
  PERFORM build_fieldcat USING 'HOLDDATE'       'X' '10'  'HOLD Date'(012)                '15'.
  PERFORM build_fieldcat USING 'RELDATE'        'X' '11'  'Release Date'(013)             '15'.
  PERFORM build_fieldcat USING 'CANCELDATE'     'X' '12'  'CANCELLED Date'(014)           '15'.
  PERFORM build_fieldcat USING 'DELDATE'        'X' '13'  'Delivery Date'                 '15'. "(015)
  PERFORM build_fieldcat USING 'TAG_REQ'        'X' '14'  'TAG Required'(049)             '15'.
  PERFORM build_fieldcat USING 'TPI'            'X' '15'  'TPI Required'(044)             '15'.
  PERFORM build_fieldcat USING 'LD_TXT'         'X' '16'  'LD Required'(050)              '15'.
  PERFORM build_fieldcat USING 'ZLDPERWEEK'     'X' '17' 'LD %Per Week'(046)              '15'.
  PERFORM build_fieldcat USING 'ZLDMAX'        'X' '18'  'LD % Max'(047)                  '15'.
  PERFORM build_fieldcat USING 'ZLDFROMDATE'    'X' '19' 'LD From Date'(048)              '15'.
*  PERFORM BUILD_FIELDCAT USING ''                'X' '18'  ''(0).
*  PERFORM BUILD_FIELDCAT USING ''                'X' '19'  ''(0).
  PERFORM build_fieldcat USING 'MATNR'          'X' '20'   'Item Code'(016)               '18'.
*  PERFORM build_fieldcat USING 'SCMAT'          'X' '21'   'Sub-Item Code'(053).
  PERFORM build_fieldcat USING 'POSNR'          'X' '21'   'Line Item'(017)               '15'.
  PERFORM build_fieldcat USING 'ARKTX'          'X' '22'   'Item Description'(018)        '20'.
  PERFORM build_fieldcat USING 'KWMENG'         'X' '23'   'SO QTY'(019)                  '15'.
*  PERFORM build_fieldcat USING 'KALAB'          'X' '25'   'Stock Qty'(020).
  PERFORM build_fieldcat USING 'STOCK_QTY'          'X' '24'   'Stock Qty'(020)           '15'.
  PERFORM build_fieldcat USING 'LFIMG'          'X' '25'   'Delivary Qty'(021)            '15'.
  PERFORM build_fieldcat USING 'FKIMG'          'X' '26'   'Invoice Quantity'(022)        '15'.
  PERFORM build_fieldcat USING 'PND_QTY'        'X' '27'   'Pending Qty'(023)             '15'.
  PERFORM build_fieldcat USING 'ETTYP'          'X' '28'   'SO Status'(024)               '15'.
  PERFORM build_fieldcat USING 'MRP_DT'         'X' '29'   'MRP Date'(045)                '15'.
  PERFORM build_fieldcat USING 'EDATU'          'X' '30'   'Production date'              '15'.   "'Posting Date'(025).
  PERFORM build_fieldcat USING 'KBETR'          'X' '31'   'Rate'(026)                    '15'.
  PERFORM build_fieldcat USING 'WAERK'          'X' '32'   'Currency Type'(027)           '15'.
  PERFORM build_fieldcat USING 'CURR_CON'       'X' '33'   'Currency Conv'(028)           '15'.
  PERFORM build_fieldcat USING 'SO_EXC'       'X' '34'   'SO Exchange Rate'(051)          '15'.
  PERFORM build_fieldcat USING 'AMONT'          'X' '35'   'Pending SO Amount'            '15'.
  PERFORM build_fieldcat USING 'ORDR_AMT'       'X' '36'   'Order Amount'(030)            '15'.
*  PERFORM BUILD_FIELDCAT USING 'KURSK'          'X' '34'   ''(031).
  PERFORM build_fieldcat USING 'IN_PRICE'        'X' '37'   'Internal Price'(032)         '15'.
  PERFORM build_fieldcat USING 'IN_PR_DT'        'X' '38'   'Internal Price Date'(033)    '15'.
  PERFORM build_fieldcat USING 'EST_COST'        'X' '39'   'Estimated Cost'(034)         '15'.
  PERFORM build_fieldcat USING 'LATST_COST'      'X' '40'   'Latest Estimated Cost'(035)  '15'.
  PERFORM build_fieldcat USING 'ST_COST'         'X' '41'   'Standard Cost'(036)          '15'.
  PERFORM build_fieldcat USING 'ZSERIES'         'X' '42'   'Series'(037)                 '15'.
  PERFORM build_fieldcat USING 'ZSIZE'           'X' '43'   'Size'(038)                   '15'.
  PERFORM build_fieldcat USING 'BRAND'           'X' '44'   'Brand'(039)                  '15'.
  PERFORM build_fieldcat USING 'MOC'             'X' '45'   'MOC'(040)                    '15'.
  PERFORM build_fieldcat USING 'TYPE'            'X' '46'   'Type'(041)                   '15'.
  """"""""""""'   Added By KD on 04.05.2017    """""""
  PERFORM build_fieldcat USING 'DISPO'            'X' '47'   'MRP Controller'(051)        '15'.
  PERFORM build_fieldcat USING 'WIP'              'X' '48'   'WIP'(052)                   '15'.
  PERFORM build_fieldcat USING 'MTART'            'X' '49'   'MAT TYPE'                   '15'.
  PERFORM build_fieldcat USING 'KDMAT'            'X' '50'   'CUST MAT NO'                '15'.
  PERFORM build_fieldcat USING 'KUNNR'            'X' '51'   'CUSTOMER CODE'              '15'.
  PERFORM build_fieldcat USING 'QMQTY'            'X' '52'   'QM QTY'                     '15'.
  PERFORM build_fieldcat USING 'MATTXT'           'X' '53'   'Material Text'              '20'.
  PERFORM build_fieldcat USING 'ITMTXT'           ' ' '54'   'Sales Text'                 '50'.
  PERFORM build_fieldcat USING 'ETENR'            'X' '55'   'Schedule_no'                '15'.
  PERFORM build_fieldcat USING 'SCHID'            'X' '56'   'Schedule_id'                '15'.
  PERFORM build_fieldcat USING 'ZTERM'            'X' '57'   'Payment Terms'              '15'.
  PERFORM build_fieldcat USING 'TEXT1'            'X' '58'   'Payment Terms Text'         '15'.
  PERFORM build_fieldcat USING 'INCO1'            'X' '59'   'Inco Terms'                 '15'.
  PERFORM build_fieldcat USING 'INCO2'            'X' '60'   'Inco Terms Descr'           '15'.
  PERFORM build_fieldcat USING 'OFM'              'X' '61'   'OFM No.'                    '15'.
  PERFORM build_fieldcat USING 'OFM_DATE'         'X' '62'   'OFM Date'                   '15'.
  PERFORM build_fieldcat USING 'SPL'              'X' '63'   'Special Instruction'        '15'.
  PERFORM build_fieldcat USING 'CUSTDELDATE'      'X' '64'  'Customer Delivery Dt'        '15'.   "(015).
  PERFORM build_fieldcat USING 'ABGRU'            'X' '65'  'Rejection Reason Code'       '15'.   "   AVINASH BHAGAT 20.12.2018
  PERFORM build_fieldcat USING 'BEZEI'            'X' '66'  'Rejection Reason Description' '15'.   "   AVINASH BHAGAT 20.12.2018
  PERFORM build_fieldcat USING 'WRKST'            'X' '67'  'USA Item Code'                '15'.
  PERFORM build_fieldcat USING 'CGST'             'X' '68'  'CGST%'                        '15'.
*  PERFORM build_fieldcat USING 'CGST_VAL'         'X' '69'  'CGST'.
  PERFORM build_fieldcat USING 'SGST'             'X' '70'  'SGST%'                        '15'.
*  PERFORM build_fieldcat USING 'SGST_VAL'         'X' '71'  'SGST'.
  PERFORM build_fieldcat USING 'IGST'              'X' '72'  'IGST%'                       '15'.
*  PERFORM build_fieldcat USING 'IGST_VAL'         'X' '73'  'IGST'.
  PERFORM build_fieldcat USING 'SHIP_KUNNR'         'X' '73'  'Ship To Party'              '15'.
  PERFORM build_fieldcat USING 'SHIP_KUNNR_N'       'X' '74'  'Ship To Party Description'  '15'.
  PERFORM build_fieldcat USING 'SHIP_REG_N'         'X' '75'  'Ship To Party State'        '15'.
  PERFORM build_fieldcat USING 'SOLD_REG_N'         'X' '76'  'Sold To Party State'        '15'.
  PERFORM build_fieldcat USING 'NORMT'              'X' '77'       'Industry Std Desc.'           '15'.
  PERFORM build_fieldcat USING 'SHIP_LAND'          'X' '78'   'Ship To Party Country Key'    '15'.
  PERFORM build_fieldcat USING 'S_LAND_DESC'        'X' '79'   'Ship To Party Country Desc'  '15'.
  PERFORM build_fieldcat USING 'SOLD_LAND'          'X' '80' 'Sold To Party Country Key'     '15'.
  PERFORM build_fieldcat USING 'POSEX'              'X' '81' 'Purchase Order Item'               '15'.
  PERFORM build_fieldcat USING 'BSTDK'              'X' '82' 'PO Date'                        '15'.
  PERFORM build_fieldcat USING 'LIFSK'              'X' '83' 'Delivery Block(Header Loc)'                     '15'.
  PERFORM build_fieldcat USING 'VTEXT'              'X' '84' 'Delivery Block Txt'               '15'.
  PERFORM build_fieldcat USING 'INSUR'              'X' '85' 'Insurance'               '15'.
  PERFORM build_fieldcat USING 'PARDEL'             'X' '86' 'Partial Delivery'               '15'.
  PERFORM build_fieldcat USING 'GAD'                'X' '87' 'GAD'               '15'.
  PERFORM build_fieldcat USING 'TCS'                'X' '88' 'TCS Rate'               '15'.
  PERFORM build_fieldcat USING 'TCS_AMT'            'X' '89' 'TCS Amount'               '15'.
  PERFORM build_fieldcat USING 'PO_DEL_DATE'        'X' '90' 'PO Delivery Date'               '15'.



  """"""""""""""""""""""""""""""""""""""""""""""""""""

*          dispo       TYPE marc-dispo,
*          wip         TYPE i,
*          mtart       TYPE mara-mtart,
*          kdmat       TYPE vbap-kdmat,
*          etenr       type vbep-etenr,
*          kunnr       TYPE kna1-kunnr,

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
*      i_structure_name   = 'OUTPUT'
      is_layout          = wa_layout
      it_fieldcat        = it_fcat
      it_sort            = i_sort
*      i_default          = 'A'
      i_save             = 'A'
      it_events          = gt_events[]
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  REFRESH it_output.
ENDFORM.                    " ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*

FORM stp3_eventtab_build  CHANGING p_gt_events TYPE slis_t_event.

  DATA: lf_event TYPE slis_alv_event. "WORK AREA

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = p_gt_events
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  MOVE c_formname_top_of_page TO lf_event-form.
  MODIFY p_gt_events  FROM  lf_event INDEX 3 TRANSPORTING form."TO P_I_EVENTS .



ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
FORM comment_build CHANGING i_list_top_of_page TYPE slis_t_listheader.
  DATA: lf_line       TYPE slis_listheader. "WORK AREA
*--LIST HEADING -  TYPE H
  CLEAR lf_line.
  lf_line-typ  = c_h.
  lf_line-info =  ''(042).
  APPEND lf_line TO i_list_top_of_page.
*--HEAD INFO: TYPE S
  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-key  = TEXT-043.
  lf_line-info = sy-datum.
  WRITE sy-datum TO lf_line-info USING EDIT MASK '__.__.____'.
  APPEND lf_line TO i_list_top_of_page.

ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM top_of_page .

*** THIS FM IS USED TO CREATE ALV HEADER
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = i_list_top_of_page[]. "INTERNAL TABLE WITH


ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM layout_build  CHANGING p_wa_layout TYPE slis_layout_alv.

*        IT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  wa_layout-zebra          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
  p_wa_layout-zebra          = 'X'.
  p_wa_layout-no_colhead        = ' '.
*  WA_LAYOUT-BOX_FIELDNAME     = 'BOX'.
*  WA_LAYOUT-BOX_TABNAME       = 'IT_FINAL_ALV'.


ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM build_fieldcat  USING    v1  v2 v3 v4 v5.
  wa_fcat-fieldname   = v1 ." 'VBELN'.
  wa_fcat-tabname     = 'IT_OUTPUT'.  "'IT_FINAL_NEW'.
* WA_FCAT-_ZEBRA      = 'X'.
  wa_fcat-key         =  v2 ."  'X'.
  wa_fcat-seltext_l   =  v4.
  wa_fcat-outputlen   =  v5." 20.
*  wa_fcat-ddictxt     =  'L'.
***  wa_fcat-seltext_l      =  'L'.
  wa_fcat-col_pos     =  v3.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM down_set .
*  BREAK fujiabap.
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).


  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).
*break primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_output
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.                "added for check
  lv_file = 'ZPENDSO.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPENDSO Download started on', sy-datum, 'at', sy-uzeit.
  IF open_so IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', s_date-low, 'To', s_date-high.
  WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
  WRITE: / 'Dest. File:', lv_fullfile.

  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


******************************************************new file zpendso **********************************
  PERFORM new_file.
*  break primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.       "added for check
  lv_file = 'ZPENDSO.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPENDSO Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE
          'PLANT'
          'ORDER TYPE'
          'CUST REF NO'
          'CUSTOMER NAME'
          'SALES OFFICE'
          'SALES DOC NO'
          'SO DATE'
          'REQUIRED DELIVERY DATE'
          'HOLD/UNHOLD'
          'HOLD DATE'
          'REL DATE'
          'CANCEL DATE'
          'DELV DATE'
          'TAG_REQD'
          'TPI REQD'
          'LD REQD'
          'LD PER WEEK'
          'LD MAX'
          'LD FROM DATE'
          'MAT NR'
          'POS NR'
          'DESCRIPTION'
          'SO QTY'
          'STOCK QTY'
          'DELIVARY QTY'
          'INVOICE QUANTITY'
          'PENDING QTY'
          'SO STATUS'
          'MRP DATE'
          'PRODUCTION DATE'
          'RATE'
          'CURRENCY'
          'CURRENCY CONV'
          'PENDING SO AMOUNT'
          'ORDER AMOUNT'
          'INTERNAL PRICE'
          'INTERNAL PRICE DATE'
          'ESTIMATED COST'
          'LATEST ESTIMATED COST'
          'STANDARD COST'
          'SERIES'
          'SIZE'
          'BRAND'
          'MOC'
          'TYPE'
          'MRP CONTROLLER'
          'WIP'
          'MAT TYPE'
          'CUST MAT NO'
          'CUSTOMER'
          'QM QTY'
          'Description Long'
          'MATTXT'              "'Sales Text'
          'SCHD NO'
          'SCHEDULE_ID'
          'SO Exchange Rate'
          'Payment Terms'
          'Payment Terms Text'
          'Inco Terms'
          'Inco Terms Descr'
          'OFM No.'
          'OFM Date'
          'CUSTOMER DEL DATE'
          'File Created Date'
          'Rejection Reason Code'
          'Rejection Reason Description'
          'USA Item Code'
          'CGST%'
*          'CGST'
          'SGST%'
*          'SGST'
          'IGST%'
*          'IGST'
          'Ship To Party'
          'Ship To Party Description'
          'Ship To Party State'
          'Sold To Party State'
          'Industry Std Desc.'
          'Ship To Party Country Key'
          'Sold To Party Country Key'
          'Purchase Order Item'
          'Ship To Party Country Desc'
          'PO Date'
          'Delivery Block(Header Loc)'
          'Delivery Block Txt'
          'Insurance'
          'Partial Delivery'
          'GAD'
          'Special Instruction'
          'TCS Rate'
          'TCS Amount'
          'PO Delivery Date'
  INTO pd_csv
  SEPARATED BY l_field_seperator.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NEW_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM new_file .
  DATA:
    ls_final TYPE t_final.
  LOOP AT it_output INTO wa_output.
    ls_final-werks       = wa_output-werks.
    ls_final-auart       = wa_output-auart.
    ls_final-bstkd       = wa_output-bstkd.
    ls_final-name1       = wa_output-name1.
    ls_final-vkbur       = wa_output-vkbur.
    ls_final-vbeln       = wa_output-vbeln.
    ls_final-status      = wa_output-status.
    ls_final-tag_req     = wa_output-tag_req.
    ls_final-tpi         = wa_output-tpi.
    ls_final-ld_txt      = wa_output-ld_txt.
    ls_final-zldperweek  = wa_output-zldperweek.
    ls_final-zldmax      = wa_output-zldmax.
    ls_final-matnr       = wa_output-matnr.
    ls_final-posnr       = wa_output-posnr.
    ls_final-arktx       = wa_output-arktx.
    ls_final-kalab       = abs( wa_output-stock_qty ).
    ls_final-kwmeng      = abs( wa_output-kwmeng ).
    ls_final-lfimg       = abs( wa_output-lfimg ).
    ls_final-fkimg       = abs( wa_output-fkimg ).
    ls_final-pnd_qty     = abs( wa_output-pnd_qty ).
    ls_final-ettyp       = wa_output-ettyp.
    ls_final-kbetr       = wa_output-kbetr.
    ls_final-waerk       = wa_output-waerk.
    ls_final-curr_con    = wa_output-curr_con.
    ls_final-amont       = abs( wa_output-amont ).
    ls_final-ordr_amt    = abs( wa_output-ordr_amt ).
    ls_final-in_price    = abs( wa_output-in_price ).
    ls_final-est_cost    = abs( wa_output-est_cost ).
    ls_final-latst_cost  = abs( wa_output-latst_cost ).
    ls_final-st_cost     = abs( wa_output-st_cost ).
    ls_final-zseries     = wa_output-zseries.
    ls_final-zsize       = wa_output-zsize.
    ls_final-brand       = wa_output-brand.
    ls_final-moc         = wa_output-moc.
    ls_final-type        = wa_output-type.
    ls_final-dispo       = wa_output-dispo.
    ls_final-wip         = wa_output-wip.
    ls_final-mtart       = wa_output-mtart.
    ls_final-kdmat       = wa_output-kdmat.
    ls_final-kunnr       = wa_output-kunnr.
    ls_final-qmqty       = abs( wa_output-qmqty ).
    ls_final-mattxt      = wa_output-mattxt.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN ls_final-mattxt WITH ' & '.
    ls_final-itmtxt      = wa_output-itmtxt.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN ls_final-itmtxt WITH ' & '.
    ls_final-etenr       = wa_output-etenr.
    ls_final-schid       = wa_output-schid.
    ls_final-so_exc      = wa_output-so_exc.
    ls_final-zterm       = wa_output-zterm.
    ls_final-inco1       = wa_output-inco1.
    ls_final-inco2       = wa_output-inco2.
    ls_final-text1       = wa_output-text1.
    ls_final-ofm         = wa_output-ofm.
    ls_final-ofm_date    = wa_output-ofm_date.
    ls_final-spl         = wa_output-spl.
    ls_final-wrkst       = wa_output-wrkst.
    ls_final-abgru       = wa_output-abgru.
    ls_final-bezei       = wa_output-bezei.
    ls_final-cgst        = wa_output-cgst.
    IF ls_final-cgst IS INITIAL .
      CONCATENATE  '0' ls_final-cgst INTO ls_final-cgst.
    ENDIF.
    ls_final-sgst        = wa_output-sgst.
    IF ls_final-sgst IS INITIAL .
      CONCATENATE  '0' ls_final-sgst INTO ls_final-sgst.
    ENDIF.
    ls_final-igst        = wa_output-igst.
    IF ls_final-igst IS INITIAL .
      CONCATENATE  '0' ls_final-igst INTO ls_final-igst.
    ENDIF.
*    ls_final-cgst_val    = wa_output-cgst_val.
*    ls_final-sgst_val    = wa_output-sgst_val.
*    ls_final-igst_val    = wa_output-igst_val.
    ls_final-ship_kunnr    = wa_output-ship_kunnr.
    ls_final-ship_kunnr_n  = wa_output-ship_kunnr_n.
    ls_final-ship_reg_n    = wa_output-ship_reg_n.
    ls_final-sold_reg_n    = wa_output-sold_reg_n.
    ls_final-ship_land     = wa_output-ship_land.
    ls_final-s_land_desc   = wa_output-s_land_desc.
    ls_final-sold_land     =  wa_output-sold_land.
    ls_final-normt          = wa_output-normt.
    ls_final-posex          = wa_output-posex.

    ls_final-LIFSK          = wa_output-LIFSK.
    ls_final-vtext          = wa_output-vtext.
    ls_final-insur          = wa_output-insur .
    ls_final-pardel         = wa_output-pardel.
    ls_final-gad            = wa_output-gad.
    ls_final-tcs            = wa_output-tcs.
    ls_final-tcs_amt        = wa_output-tcs_amt.

    IF wa_output-bstdk IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-bstdk
        IMPORTING
          output = ls_final-bstdk.
      CONCATENATE ls_final-bstdk+0(2) ls_final-bstdk+2(3) ls_final-bstdk+5(4)
                     INTO ls_final-bstdk SEPARATED BY '-'.
    ENDIF.

    IF wa_output-erdat IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-erdat
        IMPORTING
          output = ls_final-erdat.
      CONCATENATE ls_final-erdat+0(2) ls_final-erdat+2(3) ls_final-erdat+5(4)
                     INTO ls_final-erdat SEPARATED BY '-'.
    ENDIF.

    IF wa_output-vdatu IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-vdatu
        IMPORTING
          output = ls_final-vdatu.
      CONCATENATE ls_final-vdatu+0(2) ls_final-vdatu+2(3) ls_final-vdatu+5(4)
                     INTO ls_final-vdatu SEPARATED BY '-'.
    ENDIF.

    IF wa_output-holddate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-holddate
        IMPORTING
          output = ls_final-holddate.
      CONCATENATE ls_final-holddate+0(2) ls_final-holddate+2(3) ls_final-holddate+5(4)
                     INTO ls_final-holddate SEPARATED BY '-'.
    ENDIF.

    IF wa_output-reldate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-reldate
        IMPORTING
          output = ls_final-reldate.
      CONCATENATE ls_final-reldate+0(2) ls_final-reldate+2(3) ls_final-reldate+5(4)
                     INTO ls_final-reldate SEPARATED BY '-'.
    ENDIF.

    IF wa_output-canceldate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-canceldate
        IMPORTING
          output = ls_final-canceldate.
      CONCATENATE ls_final-canceldate+0(2) ls_final-canceldate+2(3) ls_final-canceldate+5(4)
                     INTO ls_final-canceldate SEPARATED BY '-'.
    ENDIF.

    IF wa_output-deldate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-deldate
        IMPORTING
          output = ls_final-deldate.
      CONCATENATE ls_final-deldate+0(2) ls_final-deldate+2(3) ls_final-deldate+5(4)
                     INTO ls_final-deldate SEPARATED BY '-'.
    ENDIF.

    IF wa_output-custdeldate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-custdeldate
        IMPORTING
          output = ls_final-custdeldate.
      CONCATENATE ls_final-custdeldate+0(2) ls_final-custdeldate+2(3) ls_final-custdeldate+5(4)
                     INTO ls_final-custdeldate SEPARATED BY '-'.
    ENDIF.

    IF wa_output-po_del_date IS NOT INITIAL .                         "Added By Snehal Rajale On 27 jan 2021
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = wa_output-po_del_date
      IMPORTING
        OUTPUT = ls_final-po_del_date.
      CONCATENATE ls_final-po_del_date+0(2) ls_final-po_del_date+2(3) ls_final-po_del_date+5(4)
      INTO ls_final-po_del_date SEPARATED BY '-'.
    ENDIF.

    IF wa_output-zldfromdate IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-zldfromdate
        IMPORTING
          output = ls_final-zldfromdate.
      CONCATENATE ls_final-zldfromdate+0(2) ls_final-zldfromdate+2(3) ls_final-zldfromdate+5(4)
                     INTO ls_final-zldfromdate SEPARATED BY '-'.
    ENDIF.

    IF wa_output-mrp_dt IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-mrp_dt
        IMPORTING
          output = ls_final-mrp_dt.
      CONCATENATE ls_final-mrp_dt+0(2) ls_final-mrp_dt+2(3) ls_final-mrp_dt+5(4)
                     INTO ls_final-mrp_dt SEPARATED BY '-'.
    ENDIF.

    IF wa_output-edatu IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-edatu
        IMPORTING
          output = ls_final-edatu.
      CONCATENATE ls_final-edatu+0(2) ls_final-edatu+2(3) ls_final-edatu+5(4)
                     INTO ls_final-edatu SEPARATED BY '-'.
    ENDIF.

    IF wa_output-in_pr_dt IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-in_pr_dt
        IMPORTING
          output = ls_final-in_pr_dt.
      CONCATENATE ls_final-in_pr_dt+0(2) ls_final-in_pr_dt+2(3) ls_final-in_pr_dt+5(4)
                     INTO ls_final-in_pr_dt SEPARATED BY '-'.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = ls_final-ref_dt.
    CONCATENATE ls_final-ref_dt+0(2) ls_final-ref_dt+2(3) ls_final-ref_dt+5(4)
                   INTO ls_final-ref_dt SEPARATED BY '-'.

    CONDENSE ls_final-kwmeng.
    IF wa_output-kwmeng < 0.
      CONCATENATE '-' ls_final-kwmeng INTO ls_final-kwmeng.
    ENDIF.

    CONDENSE ls_final-lfimg.
    IF wa_output-lfimg < 0.
      CONCATENATE '-' ls_final-lfimg INTO ls_final-lfimg.
    ENDIF.

    CONDENSE ls_final-fkimg.
    IF wa_output-fkimg < 0.
      CONCATENATE '-' ls_final-fkimg INTO ls_final-fkimg.
    ENDIF.

    CONDENSE ls_final-pnd_qty.
    IF wa_output-pnd_qty < 0.
      CONCATENATE '-' ls_final-pnd_qty INTO ls_final-pnd_qty.
    ENDIF.

    CONDENSE ls_final-qmqty.
    IF wa_output-qmqty < 0.
      CONCATENATE '-' ls_final-qmqty INTO ls_final-qmqty.
    ENDIF.

    CONDENSE ls_final-kbetr.
    IF wa_output-kbetr < 0.
      CONCATENATE '-' ls_final-kbetr INTO ls_final-kbetr.
    ENDIF.

*    CONDENSE ls_final-kalab.
*    IF ls_final-kalab < 0.
*      CONCATENATE '-' ls_final-kalab INTO ls_final-kalab.
*    ENDIF.

*    CONDENSE ls_final-so_exc.
*    IF ls_final-so_exc < 0.
*      CONCATENATE '-' ls_final-so_exc INTO ls_final-so_exc.
*    ENDIF.

    CONDENSE ls_final-amont.
    IF wa_output-amont < 0.
      CONCATENATE '-' ls_final-amont INTO ls_final-amont.
    ENDIF.

    CONDENSE ls_final-ordr_amt.
    IF wa_output-ordr_amt < 0.
      CONCATENATE '-' ls_final-ordr_amt INTO ls_final-ordr_amt.
    ENDIF.


    CONDENSE ls_final-in_price.
    IF wa_output-in_price < 0.
      CONCATENATE '-' ls_final-in_price INTO ls_final-in_price.
    ENDIF.

    CONDENSE ls_final-est_cost.
    IF wa_output-est_cost < 0.
      CONCATENATE '-' ls_final-est_cost INTO ls_final-est_cost.
    ENDIF.

    CONDENSE ls_final-latst_cost.
    IF wa_output-latst_cost < 0.
      CONCATENATE '-' ls_final-latst_cost INTO ls_final-latst_cost.
    ENDIF.

    CONDENSE ls_final-st_cost.
    IF wa_output-st_cost < 0.
      CONCATENATE '-' ls_final-st_cost INTO ls_final-st_cost.
    ENDIF.

*    CONDENSE ls_final-wip.
*    IF ls_final-wip < 0.
*      CONCATENATE '-' ls_final-wip INTO ls_final-wip.
*
*    ENDIF.

    APPEND ls_final TO gt_final.
    CLEAR:
      ls_final,wa_output.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM down_set_all .

  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).


  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_output
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZPENDSOALL.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPENDSO Download started on', sy-datum, 'at', sy-uzeit.
  IF open_so IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', s_date-low, 'To', s_date-high.
  WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
  WRITE: / 'Dest. File:', lv_fullfile.

  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


******************************************************new file zpendso **********************************
  PERFORM new_file.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*

*lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZPENDSOALL.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPENDSO Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.




ENDFORM.
