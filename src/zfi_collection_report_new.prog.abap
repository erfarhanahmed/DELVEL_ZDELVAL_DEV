*&---------------------------------------------------------------------*
*& Report ZFI_COLLECTION_REPORT
*&---------------------------------------------------------------------*
*&FUNCTIONAL
*&TECHNICAL
*&---------------------------------------------------------------------*
REPORT zfi_collection_report_new.

TABLES: bkpf, vbrp,bseg,vbrk.

TYPE-POOLS slis.
DATA : it_fldcat TYPE slis_t_fieldcat_alv,
       wa_fldcat TYPE slis_fieldcat_alv,
       wa_layout TYPE slis_layout_alv.

DATA: p1          TYPE int2 VALUE 0,
      ls_days     TYPE fiappl_arrear,
      ls_add_days TYPE sy-datum.

TYPES: BEGIN OF ty_final,

         cust_code       TYPE bseg-kunnr,
         cust_name       TYPE kna1-name1,
         com_code        TYPE bkpf-bukrs,
         sales_off       TYPE vbrp-vkbur,
         inv_no          TYPE bkpf-xblnr,
         doc_typ         TYPE bkpf-blart,
         bill_doc_no     TYPE bseg-vbeln,
         acc_doc_no      TYPE bkpf-belnr,
         clear_doc       TYPE bseg-augbl,
         clear_date      TYPE bseg-augdt,
         inv_date        TYPE bkpf-budat,
         doc_date        TYPE bkpf-bldat,
         so_no           TYPE vbrp-aubel,
         so_date         TYPE vbak-audat,
         pay_term        TYPE vbkd-zterm,
         pay_days        TYPE bseg-zbd1t,
         pay_desc        TYPE t052u-text1,
         due_date        TYPE bseg-augdt,
         inv_amt         TYPE bseg-dmbtr,
         pay_doc_typ     TYPE bsad-blart,
         pay_doc_no      TYPE bsad-belnr,
         date_coll       TYPE bsad-budat,
         ld_date_coll    TYPE bsad-budat,
         ld_year         TYPE bseg-gjahr,
         amt_coll        TYPE bsid-dmbtr,
         amt_coll0       TYPE bsid-dmbtr,
         amt_coll1       TYPE bsid-dmbtr,
         amt_coll2       TYPE bsid-dmbtr,
         amt_coll3       TYPE bsid-dmbtr,
         other_amt_coll  TYPE bsid-dmbtr,
         bal_any         TYPE bsid-dmbtr,
         day_coll_inv    TYPE vtbbewe-atage,
         day_coll_due    TYPE vtbbewe-atage,
         inv_buk_90      TYPE bsid-dmbtr,
         inv_buk_91_120  TYPE bsid-dmbtr,
         inv_buk_121_180 TYPE bsid-dmbtr,
         inv_buk_aft_180 TYPE bsid-dmbtr,
         due_buk_90      TYPE bsid-dmbtr,
         due_buk_91_120  TYPE bsid-dmbtr,
         due_buk_121_180 TYPE bsid-dmbtr,
         due_buk_aft_180 TYPE bsid-dmbtr,
         gv_days1        TYPE vtbbewe-atage,
         gv_days2        TYPE vtbbewe-atage,
         gv_days3        TYPE vtbbewe-atage,
         gv_days4       TYPE vtbbewe-atage,
       END OF ty_final.

DATA : ls_ext TYPE  dats.
DATA : ls_ext1 TYPE  dats.
DATA: it_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final.
DATA:  ls_oldbelnr TYPE bkpf-belnr.
DATA:  ls_oldaugbl TYPE bseg-augbl.
DATA:  tab TYPE sy-tabix.
FIELD-SYMBOLS : <wa_final> TYPE ty_final.
SELECTION-SCREEN BEGIN OF BLOCK block WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS: s_bukrs FOR bkpf-bukrs OBLIGATORY,       "Com. Code
                s_kunnr FOR bseg-kunnr,       "Customer
                s_budat FOR bkpf-budat OBLIGATORY.       "Invoice date
SELECT-OPTIONS: s_belnr FOR bkpf-belnr,       "Doc. No.
                s_xblnr FOR bkpf-xblnr,
                s_gjahr FOR vbrk-gjahr .
PARAMETERS  :   p_augdt TYPE bseg-augdt .     "cLearing Date added by jyoti.


SELECTION-SCREEN END OF BLOCK block.

RANGES : doctyp FOR bkpf-blart.
RANGES : lt_pymnt FOR bsad-blart.






START-OF-SELECTION.

  IF s_gjahr IS INITIAL.
    IF s_budat-high IS INITIAL.
      s_gjahr-low = s_budat-low(4).
      s_gjahr-high = s_budat-high(4).
      s_gjahr-option = 'EQ'.
      s_gjahr-sign = s_budat-sign.
      APPEND s_gjahr TO s_gjahr.
      CLEAR: s_gjahr.
    ELSEIF s_budat-high IS NOT INITIAL AND s_budat-low IS NOT INITIAL.
      s_gjahr-low = s_budat-low(4).
      s_gjahr-high = s_budat-high(4).
      s_gjahr-option = 'BT'.
      s_gjahr-sign = s_budat-sign.
      APPEND s_gjahr TO s_gjahr.
      CLEAR: s_gjahr.
    ENDIF.
  ENDIF.
  PERFORM fetch_data.
  PERFORM display_data.

END-OF-SELECTION.



*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = '10'
      text       = 'Reading FI Documents'.


  SELECT  low FROM tvarvc INTO TABLE @DATA(lt_doctype) WHERE name = 'ZFI_COLLECTION_INV'.
  SELECT  low FROM tvarvc INTO TABLE @DATA(lt_pymnt1) WHERE name = 'ZFI_COLLECTION_PYMNT'.



  IF NOT lt_doctype IS INITIAL.

    LOOP AT lt_doctype INTO DATA(ls_doctype).
      doctyp-sign = 'I'.
      doctyp-option = 'EQ'.
      doctyp-low = ls_doctype-low.
      APPEND doctyp TO doctyp[].
      CLEAR: doctyp.
    ENDLOOP.
*
    LOOP AT lt_pymnt1 INTO DATA(ls_pymnt1).
      lt_pymnt-sign = 'I'.
      lt_pymnt-option = 'EQ'.
      lt_pymnt-low = ls_pymnt1-low.
      APPEND lt_pymnt TO lt_pymnt[].
      CLEAR: lt_pymnt, ls_pymnt1.
    ENDLOOP.
*

    IF NOT doctyp[] IS INITIAL.
      SELECT xblnr,
             blart,
             belnr,
             bldat,
             budat,
             bukrs,
             gjahr
              FROM
              bkpf
              INTO TABLE @DATA(it_bkpf_temp)
              WHERE bukrs IN @s_bukrs AND
                    blart IN @doctyp AND
                    budat IN @s_budat AND
                    belnr IN @s_belnr AND
                    xblnr IN @s_xblnr AND
                   " gjahr = @p_gjahr.
                    gjahr IN @s_gjahr
*                    BUDAT le @p_augdt
        AND xreversal <> @abap_true ."ADDED NEW 29.03.2023 FOR REVERSAL CASE


      IF sy-subrc = 0.
        SORT it_bkpf_temp BY xblnr belnr blart ASCENDING.
      ELSE.
        MESSAGE |No data Found. | TYPE 'E'.
      ENDIF.

      IF p_augdt IS INITIAL.
        p_augdt = sy-datum.
      ENDIF.

      SELECT bukrs,
             belnr,
             kunnr,
             gjahr,
             vbeln,
             augbl,
             augdt,
             zterm,
             zfbdt,
             zbd1t,
             zbd2t,
             wrbtr,
             dmbtr,
             shkzg
        FROM bseg
        INTO TABLE @DATA(it_bseg)
        FOR ALL ENTRIES IN @it_bkpf_temp
        WHERE
        belnr = @it_bkpf_temp-belnr AND
        bukrs = @it_bkpf_temp-bukrs AND
        gjahr = @it_bkpf_temp-gjahr AND
         koart = 'D' AND
       hkont <> '0000700170' AND"ADDED NEW TO DELETE LD_CHARGES
        kunnr IN @s_kunnr
*        AUGDT lE @P_AUGDT  "ADDED BY JYOTI ON 15.10.2024
        %_HINTS DB6 'INDEX("BSEG" "BSEG~Z2")'...
****************************added by jyoti on 16.10.2024 at 7.30 pm
****************if data is not found when  clearing date  is pass to selection screen
      IF it_bseg IS INITIAL.

        SELECT bukrs
               belnr
               kunnr
               gjahr
               vbeln
               augbl
               augdt
               zterm
               zfbdt
               zbd1t
               zbd2t
               wrbtr
               dmbtr
               shkzg
          FROM bseg
          INTO TABLE it_bseg
          FOR ALL ENTRIES IN it_bkpf_temp
          WHERE
          belnr = it_bkpf_temp-belnr AND
          bukrs = it_bkpf_temp-bukrs AND
          gjahr = it_bkpf_temp-gjahr AND
           koart = 'D' AND
         hkont <> '0000700170' AND"ADDED NEW TO DELETE LD_CHARGES
          kunnr IN s_kunnr
*        AUGDT lE @P_AUGDT  "ADDED BY JYOTI ON 16.10.2024
          %_HINTS DB6 'INDEX("BSEG" "BSEG~Z2")'...


      ENDIF.
********************************************************************************************
      IF sy-subrc = 0.
        SORT it_bseg BY belnr  ASCENDING.
        SELECT xblnr,
               blart,
               belnr,
               bldat,
               budat,
               bukrs,
               gjahr
                FROM
                bkpf
                INTO TABLE @DATA(it_bkpf)
          FOR ALL ENTRIES IN @it_bseg
          WHERE  belnr = @it_bseg-belnr AND
            bukrs = @it_bseg-bukrs AND
            gjahr = @it_bseg-gjahr
        AND xreversal <> @abap_true ."ADDED NEW 29.03.2023 FOR REVERSAL CASE
        .

        IF NOT it_bkpf IS INITIAL.
          SORT it_bkpf BY xblnr belnr blart ASCENDING.
          CLEAR: it_bkpf_temp.
        ENDIF.

        SELECT     bukrs,
                   belnr,
                   kunnr,
                   gjahr,
                   vbeln,
                   augbl,
                   augdt,
                   zterm,
                   zfbdt,
                   zbd1t,
                   zbd2t,
                   wrbtr,
                   dmbtr,
                   shkzg
              FROM bseg
              INTO TABLE @DATA(it_bseg1)
              FOR ALL ENTRIES IN @it_bseg
              WHERE
              hkont = '0000700170' AND
              bukrs = @it_bseg-bukrs AND
              gjahr = @it_bseg-augdt(4)
          %_HINTS DB6 'INDEX("BSEG" "BSEG~Z2")'...
        IF sy-subrc = 0.
          SORT it_bseg1 BY belnr  ASCENDING.

        ENDIF.
      ELSE.
        MESSAGE 'No Data Found for given Selection...' TYPE 'E'.
      ENDIF.


      SELECT vbeln,
        aubel,
        vkbur
        FROM vbrp
        INTO TABLE @DATA(it_vbrp)
       FOR ALL ENTRIES IN @it_bseg
        WHERE vbeln = @it_bseg-vbeln
        %_HINTS DB6 'INDEX("VBRP" "VBRP~ZO2")'...
      IF sy-subrc = 0.
        SORT it_vbrp BY vbeln  ASCENDING.
      ENDIF.


      SELECT vbeln,
        audat
      FROM vbak
        INTO TABLE @DATA(it_vbak)
       FOR ALL ENTRIES IN @it_vbrp
         WHERE vbeln = @it_vbrp-aubel.
      IF sy-subrc = 0.
        SORT it_vbak BY vbeln  ASCENDING.
      ENDIF.

      SELECT kunnr,
             name1
        FROM kna1
        INTO TABLE @DATA(it_kna1)
        FOR ALL ENTRIES IN @it_bseg
        WHERE kunnr = @it_bseg-kunnr.
      IF sy-subrc = 0.
        SORT it_kna1 BY kunnr  ASCENDING.
      ENDIF.

      SELECT zterm, text1 INTO TABLE @DATA(it_paytermdesc) FROM t052u
        FOR ALL ENTRIES IN
        @it_bseg
        WHERE zterm = @it_bseg-zterm.
      IF sy-subrc = 0.
        SORT it_paytermdesc BY zterm ASCENDING.
      ENDIF.

      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          percentage = '30'
          text       = 'Proceesing Fetched Documents'.



      SELECT   belnr,blart,budat,shkzg, wrbtr, kunnr,augbl ,rebzg,dmbtr,gjahr,
        augdt FROM bsad INTO TABLE @DATA(it_bsad)
        FOR ALL ENTRIES IN @it_bseg
* WHERE AUGBL =  @IT_BSEG-AUGBL AND BLART NOT IN @LT_PYMNT
 WHERE augbl =  @it_bseg-augbl AND augdt = @it_bseg-augdt and gjahr = @it_bseg-gjahr AND blart NOT IN @lt_pymnt
* WHERE AUGBL =  @IT_BSEG-AUGBL AND AUGDT = @IT_BSEG-AUGDT AND blart ne 'RV' "BLART NOT IN @LT_PYMNT "need to uncomment logic for cust 201179
 AND kunnr = @it_bseg-kunnr
*AND BELNR = @IT_BSEG-BELNR AND KUNNR = @IT_BSEG-KUNNR
         %_HINTS DB6 'INDEX("BSAD" "BSAD~1")'.
      IF sy-subrc = 0.
        DELETE it_bsad WHERE augbl IS INITIAL AND augdt IS INITIAL.
        SORT it_bsad BY augbl augdt ASCENDING.
      ENDIF.

      SELECT  belnr , blart , budat, augbl, wrbtr , xblnr , dmbtr,GJAHR FROM bsad INTO TABLE @DATA(it_bsad_doc)
        FOR ALL ENTRIES IN @it_bseg
                     WHERE augbl =  @it_bseg-augbl  AND augdt = @it_bseg-augdt and gjahr = @it_bseg-gjahr AND blart NOT IN @doctyp[]
*                     WHERE AUGBL =  @IT_BSEG-AUGBL  AND AUGDT = @IT_BSEG-AUGDT AND blart ne 'RV' "BLART NOT IN @DOCTYP[] "need to uncomment logic for cust 201179
                         %_HINTS DB6 'INDEX("BSAD" "BSAD~1")'.
      IF sy-subrc = 0..
        SORT it_bsad_doc BY belnr DESCENDING.
      ENDIF.


      IF NOT it_bseg1 IS INITIAL.
        SELECT  belnr,
                wrbtr,
                augbl,
                augdt,
                budat,
                shkzg,
                dmbtr
               FROM bsad INTO TABLE @DATA(it_bsad_ld)
               FOR ALL ENTRIES IN @it_bseg1 WHERE
               belnr = @it_bseg1-belnr  %_HINTS DB6 'INDEX("BSAD" "BSAD~1")'..
*        AND  augbl = @wa_bseg-augbl AND augdt = @wa_bseg-augdt %_HINTS DB6 'INDEX("BSAD" "BSAD~1")'..

        IF sy-subrc = 0 .
          SORT it_bsad_ld BY augbl augdt ASCENDING.
        ENDIF.

        SELECT  belnr,
                 wrbtr,
                 augbl,
                  augdt,
                 budat,
                 shkzg,
                 dmbtr
           FROM bsak APPENDING TABLE @it_bsad_ld
           FOR ALL ENTRIES IN @it_bseg1 WHERE
           belnr = @it_bseg1-belnr %_HINTS DB6 'INDEX("BSAK" "BSAK~1")'.
        "AND augbl = @wa_bseg-augbl AND augdt = @wa_bseg-augdt .
        IF sy-subrc = 0 .

          SORT it_bsad_ld BY augbl augdt ASCENDING.
        ENDIF.
      ENDIF.

      SELECT  belnr,blart,budat,rebzj, rebzg, shkzg, wrbtr, kunnr, dmbtr FROM bsid INTO TABLE @DATA(it_bsid)
        FOR ALL ENTRIES IN @it_bseg
        WHERE  rebzg =  @it_bseg-belnr
        AND rebzj = @it_bseg-gjahr AND blart IN @lt_pymnt  AND budat LE @p_augdt and budat GE @s_budat-low AND kunnr = @it_bseg-kunnr .
      IF sy-subrc = 0.
        SORT it_bsid BY  belnr  DESCENDING.
        SORT it_bsid BY  budat DESCENDING.
      ENDIF.

      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          percentage = '40'
          text       = 'Proceesing Fetched Documents'.


      SORT it_bseg BY belnr gjahr ASCENDING.
      ASSIGN wa_final TO <wa_final>.

      LOOP AT it_bkpf INTO DATA(wa_bkpf).
        READ TABLE it_bseg  INTO DATA(wa_bseg) WITH KEY  belnr = wa_bkpf-belnr  gjahr =  wa_bkpf-gjahr(4)  .
        IF sy-subrc = 4..
          CONTINUE.
        ENDIF.
        <wa_final>-inv_no          = wa_bkpf-xblnr.
        <wa_final>-doc_typ         = wa_bkpf-blart.
        <wa_final>-acc_doc_no      = wa_bkpf-belnr.
        <wa_final>-inv_date        = wa_bkpf-budat.
        <wa_final>-doc_date        = wa_bkpf-bldat.
        <wa_final>-com_code        = wa_bkpf-bukrs.
        <wa_final>-cust_code         = wa_bseg-kunnr.
        <wa_final>-bill_doc_no       = wa_bseg-vbeln.
        <wa_final>-clear_doc         = wa_bseg-augbl.
        <wa_final>-clear_date        = wa_bseg-augdt.
        <wa_final>-ld_year           = wa_bseg-augdt(4).
        <wa_final>-pay_term          = wa_bseg-zterm.
        <wa_final>-pay_days          = wa_bseg-zbd1t.
*          SELECT SINGLE text1 INTO  FROM t052u WHERE zterm = wa_bseg-zterm.

        READ TABLE it_paytermdesc INTO DATA(ls_desc) WITH KEY zterm = wa_bseg-zterm BINARY SEARCH.
        IF sy-subrc = 0.
          <wa_final>-pay_desc = ls_desc-text1.
        ENDIF.

        ls_days = wa_bseg-zbd1t  + wa_bseg-zbd2t .
        ls_ext = wa_bseg-zfbdt.


        CALL FUNCTION 'FIAPPL_ADD_DAYS_TO_DATE'
          EXPORTING
            i_date      = ls_ext
            i_days      = ls_days
            signum      = '+'
          IMPORTING
            e_calc_date = ls_ext1.

        <wa_final>-due_date          =  ls_ext1 .


        LOOP AT it_bseg INTO DATA(wa_bseg_n) WHERE belnr = wa_bkpf-belnr AND gjahr =  wa_bkpf-gjahr(4)  ..
          CASE wa_bseg-shkzg.
            WHEN 'H'.
*              <WA_FINAL>-INV_AMT           = ( WA_BSEG_N-WRBTR * -1 ) - <WA_FINAL>-INV_AMT.
              <wa_final>-inv_amt           = ( wa_bseg_n-dmbtr * -1 ) - <wa_final>-inv_amt.
            WHEN 'S'.
*              <WA_FINAL>-INV_AMT           = WA_BSEG_N-WRBTR + <WA_FINAL>-INV_AMT.
              <wa_final>-inv_amt           = wa_bseg_n-dmbtr + <wa_final>-inv_amt.
          ENDCASE.
          CLEAR: wa_bseg_n.
        ENDLOOP.





        READ TABLE it_kna1 INTO DATA(wa_kna1) WITH KEY kunnr = wa_bseg-kunnr BINARY SEARCH.
        <wa_final>-cust_name       = wa_kna1-name1.

        READ TABLE it_vbrp INTO DATA(wa_vbrp) WITH KEY vbeln = wa_bseg-vbeln BINARY SEARCH.
        <wa_final>-sales_off       = wa_vbrp-vkbur.
        <wa_final>-so_no           = wa_vbrp-aubel.

        READ TABLE it_vbak INTO DATA(wa_vbak) WITH KEY vbeln = wa_vbrp-aubel BINARY SEARCH.
        <wa_final>-so_date       = wa_vbak-audat.

**********          collection invoice days




*************          collection due days

        IF NOT  wa_bseg-augbl IS INITIAL.

*          DELETE IT_BSAD WHERE rebzg IS INITIAL ."need to uncomment logic for cust 201179
          LOOP AT it_bsad ASSIGNING FIELD-SYMBOL(<wa_bsad>) WHERE belnr = wa_bseg-belnr ."AND AUGBL =  WA_BSEG-AUGBL AND AUGDT = WA_BSEG-AUGDT .
*          LOOP AT IT_BSAD ASSIGNING FIELD-SYMBOL(<WA_BSAD>) WHERE AUGBL =  WA_BSEG-AUGBL AND AUGDT = WA_BSEG-AUGDT . "need to uncomment logic for cust 201179


*            IF it_bsad_doc IS NOT INITIAL.
              READ TABLE it_bsad_doc INTO DATA(wa_bsad_doc) WITH KEY belnr = wa_bseg-augbl ." augdt = ls_bseg-augdt..

              IF sy-subrc = 0 .
                <wa_final>-pay_doc_typ   =  wa_bsad_doc-blart.
                <wa_final>-pay_doc_no    =  wa_bsad_doc-belnr.
                  <wa_final>-date_coll     =  wa_bsad_doc-budat.
               else.
                  <wa_final>-pay_doc_typ   =  <wa_bsad>-blart.
                  <wa_final>-pay_doc_no    =  <wa_bsad>-belnr.
                  <wa_final>-date_coll     =  <wa_bsad>-budat.
              ENDIF.
*            ENDIF.

*                ENDAT.


*            <WA_FINAL>-AMT_COLL0   = <WA_FINAL>-INV_AMT * -1 .  "bsad to be in negative only


**************************added by jyoti on 16.10.2024************************
            DATA(gv_days) =   <wa_final>-inv_date - <wa_final>-date_coll.
            IF gv_days LE 0.
              gv_days = gv_days * -1.
            ENDIF.
            IF  gv_days LE '90'.

              <wa_final>-amt_coll   = <wa_final>-amt_coll + <wa_bsad>-dmbtr * -1  .
              DATA(gv_days1) =  gv_days.
              <wa_final>-gv_days1 = gv_days1.
            ENDIF.
            IF gv_days GE 91 AND gv_days LE 120.

              <wa_final>-amt_coll1   = <wa_final>-amt_coll1 + <wa_bsad>-dmbtr * -1  .
              DATA(gv_days2) =  gv_days.
                <wa_final>-gv_days2 = gv_days2.
            ENDIF.

            IF gv_days GE 121 AND gv_days LE 180.

              <wa_final>-amt_coll2   = <wa_final>-amt_coll2 + <wa_bsad>-dmbtr * -1 .
              DATA(gv_days3) =  gv_days.
                <wa_final>-gv_days3 = gv_days3.
            ENDIF.
            IF gv_days GE 181.

              <wa_final>-amt_coll3   = <wa_final>-amt_coll3 + <wa_bsad>-dmbtr * -1 .
              DATA(gv_days4) =  gv_days.
                <wa_final>-gv_days4 = gv_days4.
            ENDIF.



*            IF <WA_FINAL>-AMT_COLL < 0.
*              <WA_FINAL>-BAL_ANY =  ( <WA_FINAL>-INV_AMT - <WA_FINAL>-OTHER_AMT_COLL ) + <WA_FINAL>-AMT_COLL0.
*            ELSEIF <WA_FINAL>-OTHER_AMT_COLL < 0.
*              <WA_FINAL>-BAL_ANY =  ( <WA_FINAL>-INV_AMT - <WA_FINAL>-AMT_COLL0 ) + <WA_FINAL>-OTHER_AMT_COLL.
*            ELSE.
*              <WA_FINAL>-BAL_ANY      = <WA_FINAL>-INV_AMT - <WA_FINAL>-AMT_COLL0 - <WA_FINAL>-OTHER_AMT_COLL.
*            ENDIF.



            CLEAR: <wa_bsad>.

          ENDLOOP.
**********************Added by jyoti on 16.10.2024 at 1
          LOOP AT it_bsid INTO DATA(wa_bsid) WHERE rebzg = wa_bkpf-belnr AND rebzj = wa_bkpf-gjahr.

**              ON CHANGE O BELNR.
*                <wa_final>-pay_doc_typ   =  wa_bsid-blart.
*                <wa_final>-pay_doc_no   =   wa_bsid-belnr.
*                <wa_final>-date_coll     =  wa_bsid-budat.
**              END  AT.
*              AT FIRST.

            READ TABLE it_bsid INTO DATA(wa_bsid1) WITH KEY rebzg =  wa_bkpf-belnr  rebzj = wa_bkpf-gjahr..
            IF sy-subrc = 0.
              <wa_final>-pay_doc_typ   =  wa_bsid1-blart.
              <wa_final>-pay_doc_no    =  wa_bsid1-belnr.
              <wa_final>-date_coll     =  wa_bsid1-budat.
            ENDIF.

*              ENDAT.
**************************added by jyoti on 16.10.2024************************
*            if WA_BSID-WRBTR is NOT INITIAL.
            gv_days =   <wa_final>-inv_date - wa_bsid-budat.
            IF gv_days LE 0.
              gv_days = gv_days * -1.
            ENDIF.
*            IF  gv_days GT 0 AND gv_days LE '90'.
            IF  gv_days LE '90'.
              IF wa_bsid-shkzg = 'H'.
                DATA(ls_col2)    = wa_bsid-dmbtr * -1.

              ELSE.
                DATA(ls_col3)      = wa_bsid-dmbtr .
              ENDIF.
              <wa_final>-amt_coll   = <wa_final>-amt_coll + ls_col2 + ls_col3 .
              gv_days1 =  gv_days.
                <wa_final>-gv_days1 = gv_days1.
            ENDIF.
            IF gv_days GE 91 AND gv_days LE 120.

              IF wa_bsid-shkzg = 'H'.
                ls_col2    = wa_bsid-dmbtr * -1.

              ELSE.
                ls_col3     = wa_bsid-dmbtr .
              ENDIF.
              <wa_final>-amt_coll1   = <wa_final>-amt_coll1 + ls_col2 + ls_col3 .
              gv_days2 =  gv_days.
                <wa_final>-gv_days2 = gv_days2.
            ENDIF.

            IF gv_days GE 121 AND gv_days LE 180.

              IF wa_bsid-shkzg = 'H'.
                ls_col2    = wa_bsid-dmbtr * -1.

              ELSE.
                ls_col3     = wa_bsid-dmbtr .
              ENDIF.
              <wa_final>-amt_coll2   = <wa_final>-amt_coll2 + ls_col2 + ls_col3 .
              gv_days3 =  gv_days.
                <wa_final>-gv_days3 = gv_days3.
            ENDIF.
            IF gv_days GE 181.

              IF wa_bsid-shkzg = 'H'.
                ls_col2    = wa_bsid-dmbtr * -1.

              ELSE.
                ls_col3     = wa_bsid-dmbtr .
              ENDIF.
              <wa_final>-amt_coll3   = <wa_final>-amt_coll3 + ls_col2 + ls_col3 .
              gv_days4 =  gv_days.
                <wa_final>-gv_days4 = gv_days4.
            ENDIF.

            CLEAR: wa_bsid, ls_col2 , ls_col3,wa_bsid. .
          ENDLOOP.
          IF  <wa_final>-inv_amt LT 0. "added by swarup on 31.03.2023 cndn-rv case
            <wa_final>-bal_any = 0.
          ENDIF.
          <wa_final>-amt_coll0   = <wa_final>-amt_coll0 + <wa_final>-amt_coll + <wa_final>-amt_coll1 + <wa_final>-amt_coll2 + <wa_final>-amt_coll3 + <wa_final>-other_amt_coll.
          <wa_final>-bal_any = <wa_final>-inv_amt +  <wa_final>-amt_coll0.


**********************LD_CHARGES****************************************88
*  IF it_bseg1 IS NOT INITIAL.
*
*
*          LOOP AT it_bsad_ld INTO DATA(ls_bsad_ld) WHERE BELNR = wa_bseg-belnr and augbl = wa_bseg-augbl AND augdt = wa_bseg-augdt .
*
*            CASE ls_bsad_ld-shkzg.
*              WHEN 'H'.
*                ls_bsad_ld-dmbtr = ls_bsad_ld-dmbtr * -1.
*              WHEN 'S'.
*                ls_bsad_ld-dmbtr = ls_bsad_ld-dmbtr.
*            ENDCASE.
*
*
*
*            wa_final-other_amt_coll = ls_bsad_ld-dmbtr + wa_final-other_amt_coll .
*            if  <wa_final>-bal_any is NOT INITIAL."added by jyoti on17.10.2024
*            wa_final-amt_coll0 = wa_final-amt_coll0 - ls_bsad_ld-dmbtr .
*            ENDIF.
*            CLEAR: ls_bsad_ld.
*          ENDLOOP.
*
*
*
*          CLEAR: ls_bsad_ld.", wa_final-other_amt_coll, wa_final-amt_coll .
*
*
*          IF NOT it_bsad_ld IS INITIAL.
*            SORT it_bsad_ld BY belnr augbl augdt DESCENDING.
*            READ TABLE it_bsad_ld INTO ls_bsad_ld WITH KEY  augbl = wa_bseg-augbl augdt = wa_bseg-augdt ."INDEX 1.
*            IF sy-subrc = 0.
*              wa_final-ld_date_coll = ls_bsad_ld-budat.
*            ENDIF.
*            CLEAR:ls_bsad_ld.
*          ENDIF.

    ELSE.

          LOOP AT it_bsad ASSIGNING FIELD-SYMBOL(<wa_bsad1>) WHERE belnr = wa_bseg-belnr ."AND AUGBL =  WA_BSEG-AUGBL AND AUGDT = WA_BSEG-AUGDT .

*                AT FIRST.
*            IF it_bsad_doc IS NOT INITIAL.
              READ TABLE it_bsad_doc INTO wa_bsad_doc WITH KEY belnr = <wa_bsad1>-augbl."WA_BSEG-AUGBL ." augdt = ls_bseg-augdt..
              IF sy-subrc IS INITIAL .
                <wa_final>-pay_doc_typ   =  wa_bsad_doc-blart.
                <wa_final>-pay_doc_no    =  wa_bsad_doc-belnr.
                <wa_final>-date_coll     =  wa_bsad_doc-budat.
              else.
                  <wa_final>-pay_doc_typ   =  <wa_bsad1>-blart.
                  <wa_final>-pay_doc_no    =  <wa_bsad1>-belnr.
                  <wa_final>-date_coll     =  <wa_bsad1>-budat.
              ENDIF.

*            ENDIF.
*                ENDAT.


*            <WA_FINAL>-AMT_COLL0   = <WA_FINAL>-INV_AMT * -1 .  "bsad to be in negative only


**************************added by jyoti on 16.10.2024************************
            gv_days =   <wa_final>-inv_date - <wa_final>-date_coll.
            IF gv_days LE 0.
              gv_days = gv_days * -1.
            ENDIF.
            IF  gv_days LE '90'.

              <wa_final>-amt_coll   = <wa_final>-amt_coll  + <wa_bsad1>-dmbtr * -1  .
              gv_days1 =  gv_days.
                <wa_final>-gv_days1 = gv_days1.
            ENDIF.
            IF gv_days GE 91 AND gv_days LE 120.

              <wa_final>-amt_coll1   = <wa_final>-amt_coll1 + <wa_bsad1>-dmbtr * -1 .
              gv_days2 =  gv_days.
                <wa_final>-gv_days2 = gv_days2.
            ENDIF.

            IF gv_days GE 121 AND gv_days LE 180.

              <wa_final>-amt_coll2   = <wa_final>-amt_coll2 + <wa_bsad1>-dmbtr * -1.
              gv_days3 =  gv_days.
                <wa_final>-gv_days3 = gv_days3.
            ENDIF.
            IF gv_days GE 181.

              <wa_final>-amt_coll3   =  <wa_final>-amt_coll3 + <wa_bsad1>-dmbtr * -1.
              gv_days4 =  gv_days.
                <wa_final>-gv_days4 = gv_days4.
            ENDIF.


            CLEAR: <wa_bsad1>.

          ENDLOOP.
          IF  <wa_final>-inv_amt LT 0. "added by swarup on 31.03.2023 cndn-rv case
            <wa_final>-bal_any = 0.
          ENDIF.


          LOOP AT it_bsid INTO DATA(wa_bsid2) WHERE rebzg =  wa_bkpf-belnr AND rebzj = wa_bkpf-gjahr.

**

            READ TABLE it_bsid INTO DATA(wa_bsid3) WITH KEY rebzg =  wa_bkpf-belnr  rebzj = wa_bkpf-gjahr..
            IF sy-subrc = 0.
              <wa_final>-pay_doc_typ   =  wa_bsid3-blart.
              <wa_final>-pay_doc_no    =  wa_bsid3-belnr.
              <wa_final>-date_coll     =  wa_bsid3-budat.
            ENDIF.

*              ENDAT.
**************************added by jyoti on 16.10.2024************************
*            if WA_BSID-WRBTR is NOT INITIAL.
            gv_days =   <wa_final>-inv_date - wa_bsid2-budat.
            IF gv_days LE 0.
              gv_days = gv_days * -1.
            ENDIF.
            IF  gv_days LE '90'.
              IF wa_bsid2-shkzg = 'H'.
                ls_col2    = wa_bsid2-dmbtr * -1.

              ELSE.
                ls_col3     = wa_bsid2-dmbtr .
              ENDIF.
              <wa_final>-amt_coll   = <wa_final>-amt_coll + ls_col2 + ls_col3 .
              gv_days1 =  gv_days.
                <wa_final>-gv_days1 = gv_days1.
            ENDIF.
            IF gv_days GE 91 AND gv_days LE 120.

              IF wa_bsid2-shkzg = 'H'.
                ls_col2    = wa_bsid2-dmbtr * -1.

              ELSE.
                ls_col3     = wa_bsid2-dmbtr .
              ENDIF.
              <wa_final>-amt_coll1   = <wa_final>-amt_coll1 + ls_col2 + ls_col3 .
              gv_days2 =  gv_days.
                <wa_final>-gv_days2 = gv_days2.
            ENDIF.

            IF gv_days GE 121 AND gv_days LE 180.

              IF wa_bsid2-shkzg = 'H'.
                ls_col2    = wa_bsid2-dmbtr * -1.

              ELSE.
                ls_col3     = wa_bsid2-dmbtr .
              ENDIF.
              <wa_final>-amt_coll2   = <wa_final>-amt_coll2 + ls_col2 + ls_col3 .
              gv_days3 =  gv_days.
                <wa_final>-gv_days3 = gv_days3.
            ENDIF.
            IF gv_days GE 181.

              IF wa_bsid2-shkzg = 'H'.
                ls_col2    = wa_bsid2-dmbtr * -1.

              ELSE.
                ls_col3     = wa_bsid2-dmbtr .
              ENDIF.
              <wa_final>-amt_coll3   = <wa_final>-amt_coll3 + ls_col2 + ls_col3 .
              gv_days4 =  gv_days.
                <wa_final>-gv_days4 = gv_days4.
            ENDIF.
*            endif.


            CLEAR: wa_bsid, ls_col2 , ls_col3,wa_bsid. .
          ENDLOOP.
          <wa_final>-amt_coll0   = <wa_final>-amt_coll0 + <wa_final>-amt_coll + <wa_final>-amt_coll1 + <wa_final>-amt_coll2 + <wa_final>-amt_coll3 + <wa_final>-other_amt_coll.
          <wa_final>-bal_any = <wa_final>-inv_amt +  <wa_final>-amt_coll0.
        ENDIF.

        IF <wa_final>-amt_coll0 IS INITIAL.

          <wa_final>-bal_any = <wa_final>-inv_amt. " bal = invoice amount
        ENDIF.

        IF it_bseg1 IS NOT INITIAL.


          LOOP AT it_bsad_ld INTO DATA(ls_bsad_ld) WHERE BELNR = wa_bkpf-xblnr and augbl = wa_bseg-augbl AND augdt = wa_bseg-augdt .

            CASE ls_bsad_ld-shkzg.
              WHEN 'H'.
                ls_bsad_ld-dmbtr = ls_bsad_ld-dmbtr * -1.
              WHEN 'S'.
                ls_bsad_ld-dmbtr = ls_bsad_ld-dmbtr.
            ENDCASE.



            wa_final-other_amt_coll = ls_bsad_ld-dmbtr + wa_final-other_amt_coll .
            if  <wa_final>-bal_any is NOT INITIAL."added by jyoti on17.10.2024
            wa_final-amt_coll0 = wa_final-amt_coll0 - ls_bsad_ld-dmbtr .
            ENDIF.
            CLEAR: ls_bsad_ld.
          ENDLOOP.



          CLEAR: ls_bsad_ld.", wa_final-other_amt_coll, wa_final-amt_coll .


          IF NOT it_bsad_ld IS INITIAL.
            SORT it_bsad_ld BY belnr augbl augdt DESCENDING.
            READ TABLE it_bsad_ld INTO ls_bsad_ld WITH KEY  augbl = wa_bseg-augbl augdt = wa_bseg-augdt ."INDEX 1.
            IF sy-subrc = 0.
              wa_final-ld_date_coll = ls_bsad_ld-budat.
            ENDIF.
            CLEAR:ls_bsad_ld.
          ENDIF.
            ENDIF.
*        ENDIF.
        APPEND <wa_final> TO it_final.

        CLEAR: wa_bkpf, wa_bseg, wa_kna1, wa_vbrp, ls_days , ls_add_days,wa_vbak,wa_bsid, <wa_final>,wa_final,ls_ext, ls_ext1, wa_bsad_doc.
      ENDLOOP.

      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          percentage = '70'
          text       = 'Filling Buckets'.

      DELETE it_final[] WHERE cust_code IS INITIAL AND cust_name IS INITIAL.

      LOOP AT it_final INTO DATA(ls_final1) WHERE pay_doc_no IS NOT INITIAL.


        ls_final1-day_coll_inv =  ls_final1-inv_date - ls_final1-date_coll.
        IF ls_final1-day_coll_inv  LE 0.
          ls_final1-day_coll_inv = ls_final1-day_coll_inv * -1.
        ENDIF.



        IF ls_final1-date_coll < ls_final1-due_date.

          ls_final1-day_coll_due =  ls_final1-date_coll - ls_final1-due_date.

        ELSE.
          ls_final1-day_coll_due =    ls_final1-due_date  - ls_final1-date_coll.
          IF ls_final1-day_coll_due  LE 0.
            ls_final1-day_coll_due =  ls_final1-day_coll_due * -1.
          ENDIF.

        ENDIF.



        MODIFY it_final FROM ls_final1 TRANSPORTING day_coll_due day_coll_inv.
**************inv_bucket**********
*        IF LS_FINAL1-DAY_COLL_INV GE 0 AND LS_FINAL1-DAY_COLL_INV LE 90.
*        IF  gv_days1 GT 0 AND gv_days1 LE 90. "Added by jyoti on 16.10.2024
        IF    ls_final1-gv_days1  GE 0 AND ls_final1-gv_days1  LE 90. "Added by jyoti on 16.10.2024
          ls_final1-inv_buk_90 = ls_final1-amt_coll.
        ENDIF.

        ls_final1-inv_buk_90 = ls_final1-inv_buk_90 + ls_final1-other_amt_coll ." "added by swarup on 31.03.2023 addition case inv 90


*        IF LS_FINAL1-DAY_COLL_INV GE 91 AND LS_FINAL1-DAY_COLL_INV LE 120.
        IF  ls_final1-gv_days2 GE 91 AND  ls_final1-gv_days2 LE 120.
          ls_final1-inv_buk_91_120 = ls_final1-amt_coll1.
        ENDIF.

*        IF LS_FINAL1-DAY_COLL_INV GE 121 AND LS_FINAL1-DAY_COLL_INV LE 180.
        IF  ls_final1-gv_days3 GE 121 AND  ls_final1-gv_days3 LE 180.
          ls_final1-inv_buk_121_180 = ls_final1-amt_coll2.
        ENDIF.

*        IF LS_FINAL1-DAY_COLL_INV GE 181.
        IF  ls_final1-gv_days4 GE 181.
          ls_final1-inv_buk_aft_180 = ls_final1-amt_coll3.
        ENDIF.

**************due bucket**********************

        IF ls_final1-day_coll_due GE 0 AND ls_final1-day_coll_due LE 90.
          ls_final1-due_buk_90 = ls_final1-amt_coll.

        ENDIF.


        IF ls_final1-day_coll_due LT 0.
          ls_final1-due_buk_90 =  ls_final1-due_buk_90 + ls_final1-amt_coll.
        ENDIF.


        ls_final1-due_buk_90 = ls_final1-due_buk_90 + ls_final1-other_amt_coll ." "added by swarup on 31.03.2023 addition case inv 90


        IF ls_final1-day_coll_due GE 91 AND ls_final1-day_coll_due LE 120.
          ls_final1-due_buk_91_120 = ls_final1-amt_coll.
        ENDIF.


        IF ls_final1-day_coll_due GE 121 AND ls_final1-day_coll_due LE 180.
          ls_final1-due_buk_121_180 = ls_final1-amt_coll.
        ENDIF.


        IF ls_final1-day_coll_due GE 181.
          ls_final1-due_buk_aft_180 = ls_final1-amt_coll.
        ENDIF.



        MODIFY it_final FROM ls_final1 INDEX sy-tabix..
        CLEAR: ls_final1.

      ENDLOOP.




      SELECT belnr, gjahr, hkont  FROM bseg INTO TABLE @DATA(it_ld)
        FOR ALL ENTRIES IN @it_final
        WHERE belnr = @it_final-acc_doc_no AND gjahr = @it_final-ld_year AND hkont = '0000700170'
        %_HINTS DB6 'INDEX("BSEG" "BSEG~Z2")'..

      IF sy-subrc = 0.
        SORT it_ld BY belnr gjahr ASCENDING.
      ENDIF.

      LOOP AT it_final INTO DATA(wa_ld) .
        DATA(tabix) = sy-tabix.
        READ TABLE it_ld  WITH KEY belnr = wa_ld-acc_doc_no  gjahr = wa_ld-ld_year hkont = '0000700170' TRANSPORTING NO FIELDS BINARY SEARCH.
        IF sy-subrc = 0.
          DELETE it_final[] INDEX tabix..

        ENDIF.
        CLEAR:wa_ld.
      ENDLOOP.

    ELSE.
      MESSAGE |NO TVARVC MAINTAINED FOR ZFI_COLLECTION_INV| TYPE 'E'.
    ENDIF.

    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = '80'
        text       = 'Reading FI Documents'.



  ENDIF.
    DELETE it_final[] WHERE SALES_OFF = 'SO'.
  DELETE it_final[] WHERE doc_typ = 'DR' OR doc_typ = 'DG'.





ENDFORM.


FORM display_data.


  PERFORM fldcat USING   'X'    'Company Code'                      'IT_FINAL'     'COM_CODE'.
  PERFORM fldcat USING   'X'   'Customer Code'                     'IT_FINAL'     'CUST_CODE'.
  PERFORM fldcat USING   'X'    'Customer Name'                     'IT_FINAL'     'CUST_NAME'.
  PERFORM fldcat USING   ''    'Sales Office'                      'IT_FINAL'     'SALES_OFF'.
  PERFORM fldcat USING   ''    'Invoice No.'                       'IT_FINAL'     'INV_NO'.
  PERFORM fldcat USING   ''    'Document Type'                     'IT_FINAL'     'DOC_TYP'.
  PERFORM fldcat USING   ''    'Billing Doc No'                   'IT_FINAL'     'BILL_DOC_NO'.
  PERFORM fldcat USING   ''    'Document No'                      'IT_FINAL'     'ACC_DOC_NO'.
  PERFORM fldcat USING   ''    'Clear Doc.'                        'IT_FINAL'     'CLEAR_DOC'.
  PERFORM fldcat USING   ''    'Clear Date'                        'IT_FINAL'     'CLEAR_DATE'.
  PERFORM fldcat USING   ''    'Invoice Date'                      'IT_FINAL'     'INV_DATE'.
  PERFORM fldcat USING   ''    'Document Date'                     'IT_FINAL'     'DOC_DATE'.
  PERFORM fldcat USING   ''    'SO No'                             'IT_FINAL'     'SO_NO'.
  PERFORM fldcat USING   ''    'SO Date'                           'IT_FINAL'     'SO_DATE'.
  PERFORM fldcat USING   ''    'Payment Terms'                     'IT_FINAL'     'PAY_TERM'.
  PERFORM fldcat USING   ''    'Payment Description.'              'IT_FINAL'     'PAY_DESC'.
  PERFORM fldcat USING   ''    'Due Date'                          'IT_FINAL'     'DUE_DATE'.
  PERFORM fldcat USING   ''    'Invoice Amount'                    'IT_FINAL'     'INV_AMT'.
  PERFORM fldcat USING   ''    'Paymnt Doc. Type'                  'IT_FINAL'     'PAY_DOC_TYP'.
  PERFORM fldcat USING   ''    'Payment Doc. no.'                  'IT_FINAL'     'PAY_DOC_NO'.
  PERFORM fldcat USING   ''    'Date Collection'                   'IT_FINAL'     'DATE_COLL'.
  PERFORM fldcat USING   ''    'LD Date Coll.'                     'IT_FINAL'     'LD_DATE_COLL'.
  PERFORM fldcat USING   ''    'Amount Coll'                       'IT_FINAL'     'AMT_COLL0'.
  PERFORM fldcat USING   ''    'OTHER_AMT_COLL'                    'IT_FINAL'     'OTHER_AMT_COLL'.
  PERFORM fldcat USING   ''    'BAL_ANY'                           'IT_FINAL'     'BAL_ANY'.
  PERFORM fldcat USING   ''    'DAY_COLL_INV'                      'IT_FINAL'     'DAY_COLL_INV'.
  PERFORM fldcat USING   ''    'DAY_COLL_DUE'                      'IT_FINAL'     'DAY_COLL_DUE'.
  PERFORM fldcat USING   ''    'INV_BUK_90'                        'IT_FINAL'     'INV_BUK_90'.
  PERFORM fldcat USING   ''    'INV_BUK_91_120'                    'IT_FINAL'     'INV_BUK_91_120'.
  PERFORM fldcat USING   ''    'INV_BUK_121_180'                   'IT_FINAL'     'INV_BUK_121_180'.
  PERFORM fldcat USING   ''    'INV_BUK_AFT_180'                   'IT_FINAL'     'INV_BUK_AFT_180'.
  PERFORM fldcat USING   ''    'DUE_BUK_90'                        'IT_FINAL'     'DUE_BUK_90'.
  PERFORM fldcat USING   ''    'DUE_BUK_91_120'                    'IT_FINAL'     'DUE_BUK_91_120'.
  PERFORM fldcat USING   ''    'DUE_BUK_121_180'                   'IT_FINAL'     'DUE_BUK_121_180'.
  PERFORM fldcat USING   ''   'DUE_BUK_AFT_180'                    'IT_FINAL'     'DUE_BUK_AFT_180'.









  wa_layout-colwidth_optimize = 'X'.



  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = wa_layout
      it_fieldcat        = it_fldcat
      i_save             = 'X'
    TABLES
      t_outtab           = it_final[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

ENDFORM.


FORM fldcat  USING   VALUE(p2)
                      VALUE(p3)
                      VALUE(p4)
                      VALUE(p5).
  p1 = p1 + 1.
  wa_fldcat-col_pos = p1.
  wa_fldcat-key = p2.
  wa_fldcat-seltext_m = p3.
  wa_fldcat-tabname = p4.
  wa_fldcat-fieldname = p5.
  APPEND wa_fldcat TO it_fldcat.
  CLEAR wa_fldcat.
ENDFORM.
