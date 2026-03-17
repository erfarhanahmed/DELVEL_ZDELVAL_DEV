*&---------------------------------------------------------------------*
*& Report ZFI_COLLECTION_REPORT
*&---------------------------------------------------------------------*
*&FUNCTIONAL SAURABH F.
*&TECHNICAL SWAPNIL SHELAR
*&---------------------------------------------------------------------*
REPORT ZFI_COLLECTION_REPORT.

TABLES: BKPF, VBRP,BSEG,VBRK.

TYPE-POOLS SLIS.
DATA : IT_FLDCAT TYPE SLIS_T_FIELDCAT_ALV,
       WA_FLDCAT TYPE SLIS_FIELDCAT_ALV,
       WA_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA: P1          TYPE INT2 VALUE 0,
      LS_DAYS     TYPE FIAPPL_ARREAR,
      LS_ADD_DAYS TYPE SY-DATUM.

TYPES: BEGIN OF TY_FINAL,

         CUST_CODE       TYPE BSEG-KUNNR,
         CUST_NAME       TYPE KNA1-NAME1,
         COM_CODE        TYPE BKPF-BUKRS,
         SALES_OFF       TYPE VBRP-VKBUR,
         INV_NO          TYPE BKPF-XBLNR,
         DOC_TYP         TYPE BKPF-BLART,
         BILL_DOC_NO     TYPE BSEG-VBELN,
         ACC_DOC_NO      TYPE BKPF-BELNR,
         CLEAR_DOC       TYPE BSEG-AUGBL,
         CLEAR_DATE      TYPE BSEG-AUGDT,
         INV_DATE        TYPE BKPF-BUDAT,
         DOC_DATE        TYPE BKPF-BLDAT,
         SO_NO           TYPE VBRP-AUBEL,
         SO_DATE         TYPE VBAK-AUDAT,
         PAY_TERM        TYPE VBKD-ZTERM,
         PAY_DAYS        TYPE BSEG-ZBD1T,
         PAY_DESC        TYPE T052U-TEXT1,
         DUE_DATE        TYPE BSEG-AUGDT,
         INV_AMT         TYPE BSEG-WRBTR,
         PAY_DOC_TYP     TYPE BSAD-BLART,
         PAY_DOC_NO      TYPE BSAD-BELNR,
         DATE_COLL       TYPE BSAD-BUDAT,
         LD_DATE_COLL    TYPE BSAD-BUDAT,
         LD_YEAR         TYPE BSEG-GJAHR,
         AMT_COLL        TYPE BSID-WRBTR,
         OTHER_AMT_COLL  TYPE BSID-WRBTR,
         BAL_ANY         TYPE BSID-WRBTR,
         DAY_COLL_INV    TYPE VTBBEWE-ATAGE,
         DAY_COLL_DUE    TYPE VTBBEWE-ATAGE,
         INV_BUK_90      TYPE BSID-WRBTR,
         INV_BUK_91_120  TYPE BSID-WRBTR,
         INV_BUK_121_180 TYPE BSID-WRBTR,
         INV_BUK_AFT_180 TYPE BSID-WRBTR,
         DUE_BUK_90      TYPE BSID-WRBTR,
         DUE_BUK_91_120  TYPE BSID-WRBTR,
         DUE_BUK_121_180 TYPE BSID-WRBTR,
         DUE_BUK_AFT_180 TYPE BSID-WRBTR,
       END OF TY_FINAL.

DATA : LS_EXT TYPE  DATS.
DATA : LS_EXT1 TYPE  DATS.
DATA: IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE TY_FINAL.
DATA:  LS_OLDBELNR TYPE BKPF-BELNR.
DATA:  LS_OLDAUGBL TYPE BSEG-AUGBL.
DATA:  TAB TYPE SY-TABIX.
FIELD-SYMBOLS : <WA_FINAL> TYPE TY_FINAL.
SELECTION-SCREEN BEGIN OF BLOCK BLOCK WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS: S_BUKRS FOR BKPF-BUKRS OBLIGATORY,       "Com. Code
                S_KUNNR FOR BSEG-KUNNR,       "Customer
                S_BUDAT FOR BKPF-BUDAT OBLIGATORY.       "Invoice date
SELECT-OPTIONS: S_BELNR FOR BKPF-BELNR,       "Doc. No.
                S_XBLNR FOR BKPF-XBLNR,
                 S_GJAHR FOR VBRK-GJAHR  .     "Invoice No.




SELECTION-SCREEN END OF BLOCK BLOCK.

RANGES : DOCTYP FOR BKPF-BLART.
RANGES : LT_PYMNT FOR BSAD-BLART.






START-OF-SELECTION.

  IF S_GJAHR IS INITIAL.
    IF S_BUDAT-HIGH IS INITIAL.
      S_GJAHR-LOW = S_BUDAT-LOW(4).
      S_GJAHR-HIGH = S_BUDAT-HIGH(4).
      S_GJAHR-OPTION = 'EQ'.
      S_GJAHR-SIGN = S_BUDAT-SIGN.
      APPEND S_GJAHR TO S_GJAHR.
      CLEAR: S_GJAHR.
    ELSEIF S_BUDAT-HIGH IS NOT INITIAL AND S_BUDAT-LOW IS NOT INITIAL.
      S_GJAHR-LOW = S_BUDAT-LOW(4).
      S_GJAHR-HIGH = S_BUDAT-HIGH(4).
      S_GJAHR-OPTION = 'BT'.
      S_GJAHR-SIGN = S_BUDAT-SIGN.
      APPEND S_GJAHR TO S_GJAHR.
      CLEAR: S_GJAHR.
    ENDIF.
  ENDIF.
  PERFORM FETCH_DATA.
  PERFORM DISPLAY_DATA.

END-OF-SELECTION.



*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FETCH_DATA .

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      PERCENTAGE = '10'
      TEXT       = 'Reading FI Documents'.


  SELECT  LOW FROM TVARVC INTO TABLE @DATA(LT_DOCTYPE) WHERE NAME = 'ZFI_COLLECTION_INV'.
  SELECT  LOW FROM TVARVC INTO TABLE @DATA(LT_PYMNT1) WHERE NAME = 'ZFI_COLLECTION_PYMNT'.



  IF NOT LT_DOCTYPE IS INITIAL.

    LOOP AT LT_DOCTYPE INTO DATA(LS_DOCTYPE).
      DOCTYP-SIGN = 'I'.
      DOCTYP-OPTION = 'EQ'.
      DOCTYP-LOW = LS_DOCTYPE-LOW.
      APPEND DOCTYP TO DOCTYP[].
      CLEAR: DOCTYP.
    ENDLOOP.
*
    LOOP AT LT_PYMNT1 INTO DATA(LS_PYMNT1).
      LT_PYMNT-SIGN = 'I'.
      LT_PYMNT-OPTION = 'EQ'.
      LT_PYMNT-LOW = LS_PYMNT1-LOW.
      APPEND LT_PYMNT TO LT_PYMNT[].
      CLEAR: LT_PYMNT, LS_PYMNT1.
    ENDLOOP.
*

    IF NOT DOCTYP[] IS INITIAL.
      SELECT XBLNR,
             BLART,
             BELNR,
             BLDAT,
             BUDAT,
             BUKRS,
             GJAHR
              FROM
              BKPF
              INTO TABLE @DATA(IT_BKPF_TEMP)
              WHERE BUKRS IN @S_BUKRS AND
                    BLART IN @DOCTYP AND
                    BUDAT IN @S_BUDAT AND
                    BELNR IN @S_BELNR AND
                    XBLNR IN @S_XBLNR AND
                   " gjahr = @p_gjahr.
                    GJAHR IN @S_GJAHR
        AND XREVERSAL <> @ABAP_TRUE ."ADDED NEW 29.03.2023 FOR REVERSAL CASE


      IF SY-SUBRC = 0.
        SORT IT_BKPF_TEMP BY XBLNR BELNR BLART ASCENDING.
      ELSE.
        MESSAGE |No data Found. | TYPE 'E'.
      ENDIF.


      SELECT BUKRS,
             BELNR,
             KUNNR,
             GJAHR,
             VBELN,
             AUGBL,
             AUGDT,
             ZTERM,
             ZFBDT,
             ZBD1T,
             ZBD2T,
             WRBTR,
             SHKZG
        FROM BSEG
        INTO TABLE @DATA(IT_BSEG)
        FOR ALL ENTRIES IN @IT_BKPF_TEMP
        WHERE
        BELNR = @IT_BKPF_TEMP-BELNR AND
        BUKRS = @IT_BKPF_TEMP-BUKRS AND
        GJAHR = @IT_BKPF_TEMP-GJAHR AND
         KOART = 'D' AND
       HKONT <> '0000700170' AND"ADDED NEW TO DELETE LD_CHARGES
        KUNNR IN @S_KUNNR
        %_HINTS DB6 'INDEX("BSEG" "BSEG~Z2")'...
      IF SY-SUBRC = 0.
        SORT IT_BSEG BY BELNR  ASCENDING.
        SELECT XBLNR,
               BLART,
               BELNR,
               BLDAT,
               BUDAT,
               BUKRS,
               GJAHR
                FROM
                BKPF
                INTO TABLE @DATA(IT_BKPF)
          FOR ALL ENTRIES IN @IT_BSEG
          WHERE  BELNR = @IT_BSEG-BELNR AND
            BUKRS = @IT_BSEG-BUKRS AND
            GJAHR = @IT_BSEG-GJAHR
        AND XREVERSAL <> @ABAP_TRUE ."ADDED NEW 29.03.2023 FOR REVERSAL CASE
        .

        IF NOT IT_BKPF IS INITIAL.
          SORT IT_BKPF BY XBLNR BELNR BLART ASCENDING.
          CLEAR: IT_BKPF_TEMP.
        ENDIF.

        SELECT     BUKRS,
                   BELNR,
                   KUNNR,
                   GJAHR,
                   VBELN,
                   AUGBL,
                   AUGDT,
                   ZTERM,
                   ZFBDT,
                   ZBD1T,
                   ZBD2T,
                   WRBTR,
                   SHKZG
              FROM BSEG
              INTO TABLE @DATA(IT_BSEG1)
              FOR ALL ENTRIES IN @IT_BSEG
              WHERE
              HKONT = '0000700170' AND
              BUKRS = @IT_BSEG-BUKRS AND
              GJAHR = @IT_BSEG-AUGDT(4)
          %_HINTS DB6 'INDEX("BSEG" "BSEG~Z2")'...
        IF SY-SUBRC = 0.
          SORT IT_BSEG1 BY BELNR  ASCENDING.

        ENDIF.
      ELSE.
        MESSAGE 'No Data Found for given Selection...' TYPE 'E'.
      ENDIF.


      SELECT VBELN,
        AUBEL,
        VKBUR
        FROM VBRP
        INTO TABLE @DATA(IT_VBRP)
       FOR ALL ENTRIES IN @IT_BSEG
        WHERE VBELN = @IT_BSEG-VBELN %_HINTS DB6 'INDEX("VBRP" "VBRP~ZO2")'...
      IF SY-SUBRC = 0.
        SORT IT_VBRP BY VBELN  ASCENDING.
      ENDIF.


      SELECT VBELN,
        AUDAT
      FROM VBAK
        INTO TABLE @DATA(IT_VBAK)
       FOR ALL ENTRIES IN @IT_VBRP
         WHERE VBELN = @IT_VBRP-AUBEL.
      IF SY-SUBRC = 0.
        SORT IT_VBAK BY VBELN  ASCENDING.
      ENDIF.

      SELECT KUNNR,
             NAME1
        FROM KNA1
        INTO TABLE @DATA(IT_KNA1)
        FOR ALL ENTRIES IN @IT_BSEG
        WHERE KUNNR = @IT_BSEG-KUNNR.
      IF SY-SUBRC = 0.
        SORT IT_KNA1 BY KUNNR  ASCENDING.
      ENDIF.

      SELECT ZTERM, TEXT1 INTO TABLE @DATA(IT_PAYTERMDESC) FROM T052U
        FOR ALL ENTRIES IN
        @IT_BSEG
        WHERE ZTERM = @IT_BSEG-ZTERM.
      IF SY-SUBRC = 0.
        SORT IT_PAYTERMDESC BY ZTERM ASCENDING.
      ENDIF.

      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          PERCENTAGE = '30'
          TEXT       = 'Proceesing Fetched Documents'.



      SELECT   BELNR,BLART,BUDAT,SHKZG, WRBTR, KUNNR,AUGBL ,
        AUGDT FROM BSAD INTO TABLE @DATA(IT_BSAD)
        FOR ALL ENTRIES IN @IT_BSEG
 WHERE AUGBL =  @IT_BSEG-AUGBL AND AUGDT = @IT_BSEG-AUGDT AND BLART NOT IN @LT_PYMNT
AND BELNR = @IT_BSEG-BELNR AND KUNNR = @IT_BSEG-KUNNR %_HINTS DB6 'INDEX("BSAD" "BSAD~1")'.
      IF SY-SUBRC = 0.
        DELETE IT_BSAD WHERE AUGBL IS INITIAL AND AUGDT IS INITIAL.
        SORT IT_BSAD BY AUGBL AUGDT ASCENDING.
      ENDIF.

      SELECT  BELNR , BLART , BUDAT FROM BSAD INTO TABLE @DATA(IT_BSAD_DOC)
        FOR ALL ENTRIES IN @IT_BSEG
                        WHERE AUGBL =  @IT_BSEG-AUGBL  AND AUGDT = @IT_BSEG-AUGDT AND BLART NOT IN @DOCTYP[]
                         %_HINTS DB6 'INDEX("BSAD" "BSAD~1")'.
      IF SY-SUBRC = 0..
        SORT IT_BSAD_DOC BY BELNR DESCENDING.
      ENDIF.


      IF NOT IT_BSEG1 IS INITIAL.
        SELECT  BELNR,
                WRBTR,
                AUGBL,
                AUGDT,
                BUDAT,
                SHKZG
               FROM BSAD INTO TABLE @DATA(IT_BSAD_LD)
               FOR ALL ENTRIES IN @IT_BSEG1 WHERE
               BELNR = @IT_BSEG1-BELNR  %_HINTS DB6 'INDEX("BSAD" "BSAD~1")'..
        "AND  augbl = @wa_bseg-augbl AND augdt = @wa_bseg-augdt %_HINTS DB6 'INDEX("BSAD" "BSAD~1")'..

        IF SY-SUBRC = 0 .
          SORT IT_BSAD_LD BY AUGBL AUGDT ASCENDING.
        ENDIF.

        SELECT  BELNR,
                 WRBTR,
                 AUGBL,
                  AUGDT,
                 BUDAT,
                 SHKZG
           FROM BSAK APPENDING TABLE @IT_BSAD_LD
           FOR ALL ENTRIES IN @IT_BSEG1 WHERE
           BELNR = @IT_BSEG1-BELNR %_HINTS DB6 'INDEX("BSAK" "BSAK~1")'.
        "AND augbl = @wa_bseg-augbl AND augdt = @wa_bseg-augdt .
        IF SY-SUBRC = 0 .

          SORT IT_BSAD_LD BY AUGBL AUGDT ASCENDING.
        ENDIF.
      ENDIF.

      SELECT  BELNR,BLART,BUDAT,REBZJ, REBZG, SHKZG, WRBTR, KUNNR FROM BSID INTO TABLE @DATA(IT_BSID)
        FOR ALL ENTRIES IN @IT_BSEG
        WHERE  REBZG =  @IT_BSEG-BELNR
        AND REBZJ = @IT_BSEG-GJAHR AND BLART IN @LT_PYMNT  AND KUNNR = @IT_BSEG-KUNNR.
      IF SY-SUBRC = 0.
        SORT IT_BSID BY  BELNR  DESCENDING.
        SORT IT_BSID BY  BUDAT DESCENDING.
      ENDIF.

      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          PERCENTAGE = '40'
          TEXT       = 'Proceesing Fetched Documents'.


      SORT IT_BSEG BY BELNR GJAHR ASCENDING.
      ASSIGN WA_FINAL TO <WA_FINAL>.

      LOOP AT IT_BKPF INTO DATA(WA_BKPF).
        READ TABLE IT_BSEG  INTO DATA(WA_BSEG) WITH KEY  BELNR = WA_BKPF-BELNR  GJAHR =  WA_BKPF-GJAHR(4)  .
        IF SY-SUBRC = 4..
          CONTINUE.
        ENDIF.
        <WA_FINAL>-INV_NO          = WA_BKPF-XBLNR.
        <WA_FINAL>-DOC_TYP         = WA_BKPF-BLART.
        <WA_FINAL>-ACC_DOC_NO      = WA_BKPF-BELNR.
        <WA_FINAL>-INV_DATE        = WA_BKPF-BUDAT.
        <WA_FINAL>-DOC_DATE        = WA_BKPF-BLDAT.
        <WA_FINAL>-COM_CODE        = WA_BKPF-BUKRS.
        <WA_FINAL>-CUST_CODE         = WA_BSEG-KUNNR.
        <WA_FINAL>-BILL_DOC_NO       = WA_BSEG-VBELN.
        <WA_FINAL>-CLEAR_DOC         = WA_BSEG-AUGBL.
        <WA_FINAL>-CLEAR_DATE        = WA_BSEG-AUGDT.
        <WA_FINAL>-LD_YEAR           = WA_BSEG-AUGDT(4).
        <WA_FINAL>-PAY_TERM          = WA_BSEG-ZTERM.
        <WA_FINAL>-PAY_DAYS          = WA_BSEG-ZBD1T.
*          SELECT SINGLE text1 INTO  FROM t052u WHERE zterm = wa_bseg-zterm.

        READ TABLE IT_PAYTERMDESC INTO DATA(LS_DESC) WITH KEY ZTERM = WA_BSEG-ZTERM BINARY SEARCH.
        IF SY-SUBRC = 0.
          <WA_FINAL>-PAY_DESC = LS_DESC-TEXT1.
        ENDIF.

        LS_DAYS = WA_BSEG-ZBD1T  + WA_BSEG-ZBD2T .
        LS_EXT = WA_BSEG-ZFBDT.


        CALL FUNCTION 'FIAPPL_ADD_DAYS_TO_DATE'
          EXPORTING
            I_DATE      = LS_EXT
            I_DAYS      = LS_DAYS
            SIGNUM      = '+'
          IMPORTING
            E_CALC_DATE = LS_EXT1.

        <WA_FINAL>-DUE_DATE          =  LS_EXT1 .


        LOOP AT IT_BSEG INTO DATA(WA_BSEG_N) WHERE BELNR = WA_BKPF-BELNR AND GJAHR =  WA_BKPF-GJAHR(4)  ..
          CASE WA_BSEG-SHKZG.
            WHEN 'H'.
              <WA_FINAL>-INV_AMT           = ( WA_BSEG_N-WRBTR * -1 ) - <WA_FINAL>-INV_AMT.
            WHEN 'S'.
              <WA_FINAL>-INV_AMT           = WA_BSEG_N-WRBTR + <WA_FINAL>-INV_AMT.
          ENDCASE.
          CLEAR: WA_BSEG_N.
        ENDLOOP.





        READ TABLE IT_KNA1 INTO DATA(WA_KNA1) WITH KEY KUNNR = WA_BSEG-KUNNR BINARY SEARCH.
        <WA_FINAL>-CUST_NAME       = WA_KNA1-NAME1.

        READ TABLE IT_VBRP INTO DATA(WA_VBRP) WITH KEY VBELN = WA_BSEG-VBELN BINARY SEARCH.
        <WA_FINAL>-SALES_OFF       = WA_VBRP-VKBUR.
        <WA_FINAL>-SO_NO           = WA_VBRP-AUBEL.

        READ TABLE IT_VBAK INTO DATA(WA_VBAK) WITH KEY VBELN = WA_VBRP-AUBEL BINARY SEARCH.
        <WA_FINAL>-SO_DATE       = WA_VBAK-AUDAT.

**********          collection invoice days




*************          collection due days

        IF NOT  WA_BSEG-AUGBL IS INITIAL.

*            SELECT   belnr,blart,budat,shkzg, wrbtr, kunnr FROM bsad INTO TABLE @DATA(it_bsad)
*               WHERE augbl =  @wa_bseg-augbl AND augdt = @wa_bseg-augdt AND blart NOT IN @lt_pymnt "NEW
*              AND belnr IN @s_belnr AND kunnr IN @s_kunnr %_HINTS DB6 'INDEX("BSAD" "BSAD~1")'.


*            LOOP AT it_bseg INTO DATA(ls_bseg).
*
*            READ TABLE it_bseg TRANSPORTING NO FIELDS WITH KEY augbl =  wa_bseg-augbl augdt = wa_bseg-augdt belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr BINARY SEARCH.
*            IF sy-subrc = 4.
*              CONTINUE.
*            ENDIF.
*            DATA(ls_lines) = lines( it_bsad ).

          LOOP AT IT_BSAD ASSIGNING FIELD-SYMBOL(<WA_BSAD>) WHERE BELNR = WA_BSEG-BELNR AND AUGBL =  WA_BSEG-AUGBL AND AUGDT = WA_BSEG-AUGDT .

*                AT FIRST.
            IF IT_BSAD_DOC IS NOT INITIAL.
              READ TABLE IT_BSAD_DOC INTO DATA(WA_BSAD_DOC) WITH KEY BELNR =  WA_BSEG-AUGBL ." augdt = ls_bseg-augdt..
              IF SY-SUBRC = 0 .
                <WA_FINAL>-PAY_DOC_TYP   =  WA_BSAD_DOC-BLART.
                <WA_FINAL>-PAY_DOC_NO    =  WA_BSAD_DOC-BELNR.
                <WA_FINAL>-DATE_COLL     =  WA_BSAD_DOC-BUDAT.
              ENDIF.
            ENDIF.
*                ENDAT.


            <WA_FINAL>-AMT_COLL   = <WA_FINAL>-INV_AMT * -1 .  "bsad to be in negative only



            IF <WA_FINAL>-AMT_COLL < 0.
              <WA_FINAL>-BAL_ANY =  ( <WA_FINAL>-INV_AMT - <WA_FINAL>-OTHER_AMT_COLL ) + <WA_FINAL>-AMT_COLL.
            ELSEIF <WA_FINAL>-OTHER_AMT_COLL < 0.
              <WA_FINAL>-BAL_ANY =  ( <WA_FINAL>-INV_AMT - <WA_FINAL>-AMT_COLL ) + <WA_FINAL>-OTHER_AMT_COLL.
            ELSE.
              <WA_FINAL>-BAL_ANY      = <WA_FINAL>-INV_AMT - <WA_FINAL>-AMT_COLL - <WA_FINAL>-OTHER_AMT_COLL.
            ENDIF.

            IF  <WA_FINAL>-INV_AMT LT 0. "added by swarup on 31.03.2023 cndn-rv case
              <WA_FINAL>-BAL_ANY = 0.
            ENDIF.

            CLEAR: <WA_BSAD>.

          ENDLOOP.
*            CLEAR: ls_bseg.
*            ENDLOOP.




**********************LD_CHARGES****************************************88

        ELSE.



          LOOP AT IT_BSID INTO DATA(WA_BSID) WHERE REBZG =  WA_BKPF-BELNR AND REBZJ = WA_BKPF-GJAHR.

**              ON CHANGE O BELNR.
*                <wa_final>-pay_doc_typ   =  wa_bsid-blart.
*                <wa_final>-pay_doc_no   =   wa_bsid-belnr.
*                <wa_final>-date_coll     =  wa_bsid-budat.
**              END  AT.
*              AT FIRST.

            READ TABLE IT_BSID INTO DATA(WA_BSID1) WITH KEY REBZG =  WA_BKPF-BELNR  REBZJ = WA_BKPF-GJAHR..
            IF SY-SUBRC = 0.
              <WA_FINAL>-PAY_DOC_TYP   =  WA_BSID1-BLART.
              <WA_FINAL>-PAY_DOC_NO    =  WA_BSID1-BELNR.
              <WA_FINAL>-DATE_COLL     =  WA_BSID1-BUDAT.
            ENDIF.
*              ENDAT.
            IF WA_BSID-SHKZG = 'H'.
              DATA(LS_COL2)    = WA_BSID-WRBTR * -1.

            ELSE.
              DATA(LS_COL3)      = WA_BSID-WRBTR .
            ENDIF.
            <WA_FINAL>-AMT_COLL   = <WA_FINAL>-AMT_COLL + LS_COL2 + LS_COL3.

            IF <WA_FINAL>-AMT_COLL < 0.
              <WA_FINAL>-BAL_ANY =  ( <WA_FINAL>-INV_AMT - <WA_FINAL>-OTHER_AMT_COLL ) + <WA_FINAL>-AMT_COLL.
            ELSEIF <WA_FINAL>-OTHER_AMT_COLL < 0.
              <WA_FINAL>-BAL_ANY =  ( <WA_FINAL>-INV_AMT - <WA_FINAL>-AMT_COLL ) + <WA_FINAL>-OTHER_AMT_COLL.
            ELSE.
              <WA_FINAL>-BAL_ANY      = <WA_FINAL>-INV_AMT - <WA_FINAL>-AMT_COLL - <WA_FINAL>-OTHER_AMT_COLL.
            ENDIF.

            CLEAR: WA_BSID, LS_COL2 , LS_COL3,WA_BSID. .
          ENDLOOP.

        ENDIF.

        IF <WA_FINAL>-AMT_COLL IS INITIAL.

          <WA_FINAL>-BAL_ANY = <WA_FINAL>-INV_AMT. " bal = invoice amount
        ENDIF.

        IF IT_BSEG1 IS NOT INITIAL.

          "NEW
*            READ TABLE it_bseg1 INTO DATA(ls_bseg1) WITH KEY bukrs = wa_bseg-bukrs belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr TRANSPORTING NO FIELDS.
*            IF sy-subrc = 0.
          LOOP AT IT_BSAD_LD INTO DATA(LS_BSAD_LD) WHERE  AUGBL = WA_BSEG-AUGBL AND AUGDT = WA_BSEG-AUGDT .

            CASE LS_BSAD_LD-SHKZG.
              WHEN 'H'.
                LS_BSAD_LD-WRBTR = LS_BSAD_LD-WRBTR * -1.
              WHEN 'S'.
                LS_BSAD_LD-WRBTR = LS_BSAD_LD-WRBTR.
            ENDCASE.



            WA_FINAL-OTHER_AMT_COLL = LS_BSAD_LD-WRBTR + WA_FINAL-OTHER_AMT_COLL .
            WA_FINAL-AMT_COLL = WA_FINAL-AMT_COLL - LS_BSAD_LD-WRBTR .
            CLEAR: LS_BSAD_LD.
          ENDLOOP.



          CLEAR: LS_BSAD_LD.", wa_final-other_amt_coll, wa_final-amt_coll .
*          loop at it_bsad_ld into ls_bsad_ld where augbl = wa_bseg-augbl and augdt = wa_bseg-augdt.
*            case ls_bsad_ld-shkzg.
*              when 'H'.
*                ls_bsad_ld-wrbtr = ls_bsad_ld-wrbtr * -1.
*              when 'S'.
*                ls_bsad_ld-wrbtr = ls_bsad_ld-wrbtr.
*            endcase.
*
*            wa_final-other_amt_coll = ls_bsad_ld-wrbtr + wa_final-other_amt_coll .
*            "wa_final-amt_coll = wa_final-amt_coll - ls_bsad_ld-wrbtr .
*            if   wa_final-other_amt_coll > 0. "NEW
*              wa_final-amt_coll = wa_final-inv_amt - wa_final-other_amt_coll .
*            else.
*              wa_final-amt_coll = wa_final-inv_amt + wa_final-other_amt_coll .
*            endif.
*            if wa_final-amt_coll > 0.
*              wa_final-amt_coll  = wa_final-amt_coll  * -1 ."ENDNEW.
*            endif.
*            clear: ls_bsad_ld.
*          endloop.



          IF NOT IT_BSAD_LD IS INITIAL.
            SORT IT_BSAD_LD BY BELNR AUGBL AUGDT DESCENDING.
            READ TABLE IT_BSAD_LD INTO LS_BSAD_LD WITH KEY  AUGBL = WA_BSEG-AUGBL AUGDT = WA_BSEG-AUGDT ."INDEX 1.
            IF SY-SUBRC = 0.
              WA_FINAL-LD_DATE_COLL = LS_BSAD_LD-BUDAT.
            ENDIF.
            CLEAR:LS_BSAD_LD.
          ENDIF.
*            ENDIF.
        ENDIF.
        APPEND <WA_FINAL> TO IT_FINAL.

        CLEAR: WA_BKPF, WA_BSEG, WA_KNA1, WA_VBRP, LS_DAYS , LS_ADD_DAYS,WA_VBAK,WA_BSID, <WA_FINAL>,WA_FINAL,LS_EXT, LS_EXT1, WA_BSAD_DOC.
      ENDLOOP.

      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          PERCENTAGE = '70'
          TEXT       = 'Filling Buckets'.

      DELETE IT_FINAL[] WHERE CUST_CODE IS INITIAL AND CUST_NAME IS INITIAL.

      LOOP AT IT_FINAL INTO DATA(LS_FINAL1) WHERE PAY_DOC_NO IS NOT INITIAL.


        LS_FINAL1-DAY_COLL_INV =  LS_FINAL1-INV_DATE - LS_FINAL1-DATE_COLL.
        IF LS_FINAL1-DAY_COLL_INV  LE 0.
          LS_FINAL1-DAY_COLL_INV = LS_FINAL1-DAY_COLL_INV * -1.
        ENDIF.



        IF LS_FINAL1-DATE_COLL < LS_FINAL1-DUE_DATE.

          LS_FINAL1-DAY_COLL_DUE =  LS_FINAL1-DATE_COLL - LS_FINAL1-DUE_DATE.

        ELSE.
          LS_FINAL1-DAY_COLL_DUE =    LS_FINAL1-DUE_DATE  - LS_FINAL1-DATE_COLL.
          IF LS_FINAL1-DAY_COLL_DUE  LE 0.
            LS_FINAL1-DAY_COLL_DUE =  LS_FINAL1-DAY_COLL_DUE * -1.
          ENDIF.

        ENDIF.



        MODIFY IT_FINAL FROM LS_FINAL1 TRANSPORTING DAY_COLL_DUE DAY_COLL_INV.
**************inv_bucket**********
        IF LS_FINAL1-DAY_COLL_INV GE 0 AND LS_FINAL1-DAY_COLL_INV LE 90.
          LS_FINAL1-INV_BUK_90 = LS_FINAL1-AMT_COLL.
        ENDIF.

        LS_FINAL1-INV_BUK_90 = LS_FINAL1-INV_BUK_90 + LS_FINAL1-OTHER_AMT_COLL ." "added by swarup on 31.03.2023 addition case inv 90


        IF LS_FINAL1-DAY_COLL_INV GE 91 AND LS_FINAL1-DAY_COLL_INV LE 120.
          LS_FINAL1-INV_BUK_91_120 = LS_FINAL1-AMT_COLL.
        ENDIF.

        IF LS_FINAL1-DAY_COLL_INV GE 121 AND LS_FINAL1-DAY_COLL_INV LE 180.
          LS_FINAL1-INV_BUK_121_180 = LS_FINAL1-AMT_COLL.
        ENDIF.

        IF LS_FINAL1-DAY_COLL_INV GE 181.
          LS_FINAL1-INV_BUK_AFT_180 = LS_FINAL1-AMT_COLL.
        ENDIF.

**************due bucket**********************

        IF LS_FINAL1-DAY_COLL_DUE GE 0 AND LS_FINAL1-DAY_COLL_DUE LE 90.
          LS_FINAL1-DUE_BUK_90 = LS_FINAL1-AMT_COLL.

        ENDIF.
        IF LS_FINAL1-DAY_COLL_DUE LT 0.
          LS_FINAL1-DUE_BUK_90 =  LS_FINAL1-DUE_BUK_90 + LS_FINAL1-AMT_COLL.
        ENDIF.
        LS_FINAL1-DUE_BUK_90 = LS_FINAL1-DUE_BUK_90 + LS_FINAL1-OTHER_AMT_COLL ." "added by swarup on 31.03.2023 addition case inv 90
        IF LS_FINAL1-DAY_COLL_DUE GE 91 AND LS_FINAL1-DAY_COLL_DUE LE 120.
          LS_FINAL1-DUE_BUK_91_120 = LS_FINAL1-AMT_COLL.
        ENDIF.

        IF LS_FINAL1-DAY_COLL_DUE GE 121 AND LS_FINAL1-DAY_COLL_DUE LE 180.
          LS_FINAL1-DUE_BUK_121_180 = LS_FINAL1-AMT_COLL.
        ENDIF.

        IF LS_FINAL1-DAY_COLL_DUE GE 181.
          LS_FINAL1-DUE_BUK_AFT_180 = LS_FINAL1-AMT_COLL.
        ENDIF.

        MODIFY IT_FINAL FROM LS_FINAL1 INDEX SY-TABIX..
        CLEAR: LS_FINAL1.

      ENDLOOP.




      SELECT BELNR, GJAHR, HKONT  FROM BSEG INTO TABLE @DATA(IT_LD)
        FOR ALL ENTRIES IN @IT_FINAL
        WHERE BELNR = @IT_FINAL-ACC_DOC_NO AND GJAHR = @IT_FINAL-LD_YEAR AND HKONT = '0000700170'
        %_HINTS DB6 'INDEX("BSEG" "BSEG~Z2")'..

      IF SY-SUBRC = 0.
        SORT IT_LD BY BELNR GJAHR ASCENDING.
      ENDIF.

      LOOP AT IT_FINAL INTO DATA(WA_LD) .
        DATA(TABIX) = SY-TABIX.
        READ TABLE IT_LD  WITH KEY BELNR = WA_LD-ACC_DOC_NO  GJAHR = WA_LD-LD_YEAR HKONT = '0000700170' TRANSPORTING NO FIELDS BINARY SEARCH.
        IF SY-SUBRC = 0.
          DELETE IT_FINAL[] INDEX TABIX..

        ENDIF.
        CLEAR:WA_LD.
      ENDLOOP.

    ELSE.
      MESSAGE |NO TVARVC MAINTAINED FOR ZFI_COLLECTION_INV| TYPE 'E'.
    ENDIF.

    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        PERCENTAGE = '80'
        TEXT       = 'Reading FI Documents'.



  ENDIF.






ENDFORM.


FORM DISPLAY_DATA.


  PERFORM FLDCAT USING   'X'    'Company Code'                      'IT_FINAL'     'COM_CODE'.
  PERFORM FLDCAT USING   'X'   'Customer Code'                     'IT_FINAL'     'CUST_CODE'.
  PERFORM FLDCAT USING   'X'    'Customer Name'                     'IT_FINAL'     'CUST_NAME'.

  PERFORM FLDCAT USING   ''    'Sales Office'                      'IT_FINAL'     'SALES_OFF'.
  PERFORM FLDCAT USING   ''    'Invoice No.'                       'IT_FINAL'     'INV_NO'.
  PERFORM FLDCAT USING   ''    'Document Type'                     'IT_FINAL'     'DOC_TYP'.
  PERFORM FLDCAT USING   ''    'Billing Doc No'                   'IT_FINAL'     'BILL_DOC_NO'.
  PERFORM FLDCAT USING   ''    'Document No'                      'IT_FINAL'     'ACC_DOC_NO'.
  PERFORM FLDCAT USING   ''    'Clear Doc.'                        'IT_FINAL'     'CLEAR_DOC'.
  PERFORM FLDCAT USING   ''    'Clear Date'                        'IT_FINAL'     'CLEAR_DATE'.
  PERFORM FLDCAT USING   ''    'Invoice Date'                      'IT_FINAL'     'INV_DATE'.
  PERFORM FLDCAT USING   ''    'Document Date'                     'IT_FINAL'     'DOC_DATE'.
  PERFORM FLDCAT USING   ''    'SO No'                             'IT_FINAL'     'SO_NO'.
  PERFORM FLDCAT USING   ''    'SO Date'                           'IT_FINAL'     'SO_DATE'.
  PERFORM FLDCAT USING   ''    'Payment Terms'                     'IT_FINAL'     'PAY_TERM'.
  PERFORM FLDCAT USING   ''    'Payment Description.'              'IT_FINAL'     'PAY_DESC'.
  PERFORM FLDCAT USING   ''    'Due Date'                          'IT_FINAL'     'DUE_DATE'.
  PERFORM FLDCAT USING   ''    'Invoice Amount'                    'IT_FINAL'     'INV_AMT'.
  PERFORM FLDCAT USING   ''    'Paymnt Doc. Type'                  'IT_FINAL'     'PAY_DOC_TYP'.
  PERFORM FLDCAT USING   ''    'Payment Doc. no.'                  'IT_FINAL'     'PAY_DOC_NO'.
  PERFORM FLDCAT USING   ''    'Date Collection'                   'IT_FINAL'     'DATE_COLL'.
  PERFORM FLDCAT USING   ''    'LD Date Coll.'                     'IT_FINAL'     'LD_DATE_COLL'.
  PERFORM FLDCAT USING   ''    'Amount Coll'                       'IT_FINAL'     'AMT_COLL'.
  PERFORM FLDCAT USING   ''    'OTHER_AMT_COLL'                    'IT_FINAL'     'OTHER_AMT_COLL'.
  PERFORM FLDCAT USING   ''    'BAL_ANY'                           'IT_FINAL'     'BAL_ANY'.
  PERFORM FLDCAT USING   ''    'DAY_COLL_INV'                      'IT_FINAL'     'DAY_COLL_INV'.
  PERFORM FLDCAT USING   ''    'DAY_COLL_DUE'                      'IT_FINAL'     'DAY_COLL_DUE'.
  PERFORM FLDCAT USING   ''    'INV_BUK_90'                        'IT_FINAL'     'INV_BUK_90'.
  PERFORM FLDCAT USING   ''    'INV_BUK_91_120'                    'IT_FINAL'     'INV_BUK_91_120'.
  PERFORM FLDCAT USING   ''    'INV_BUK_121_180'                   'IT_FINAL'     'INV_BUK_121_180'.
  PERFORM FLDCAT USING   ''    'INV_BUK_AFT_180'                   'IT_FINAL'     'INV_BUK_AFT_180'.
  PERFORM FLDCAT USING   ''    'DUE_BUK_90'                        'IT_FINAL'     'DUE_BUK_90'.
  PERFORM FLDCAT USING   ''    'DUE_BUK_91_120'                    'IT_FINAL'     'DUE_BUK_91_120'.
  PERFORM FLDCAT USING   ''    'DUE_BUK_121_180'                   'IT_FINAL'     'DUE_BUK_121_180'.
  PERFORM FLDCAT USING   ''   'DUE_BUK_AFT_180'                    'IT_FINAL'     'DUE_BUK_AFT_180'.









  WA_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.



  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      IS_LAYOUT          = WA_LAYOUT
      IT_FIELDCAT        = IT_FLDCAT
      I_SAVE             = 'X'
    TABLES
      T_OUTTAB           = IT_FINAL[]
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.

ENDFORM.


FORM FLDCAT  USING   VALUE(P2)
                      VALUE(P3)
                      VALUE(P4)
                      VALUE(P5).
  P1 = P1 + 1.
  WA_FLDCAT-COL_POS = P1.
  WA_FLDCAT-KEY = P2.
  WA_FLDCAT-SELTEXT_M = P3.
  WA_FLDCAT-TABNAME = P4.
  WA_FLDCAT-FIELDNAME = P5.
  APPEND WA_FLDCAT TO IT_FLDCAT.
  CLEAR WA_FLDCAT.
ENDFORM.
