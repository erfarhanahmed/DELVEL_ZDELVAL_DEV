FUNCTION ZMM_CALC_TAXES.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(ZXEKKO) TYPE  EKKO
*"  EXPORTING
*"     REFERENCE(E_SUB) TYPE  KWERT
*"     REFERENCE(E_NET) TYPE  KWERT
*"  TABLES
*"      IT_EKPO STRUCTURE  EKPO
*"      IT_KOMV STRUCTURE  KOMV
*"      ET_KOMVD STRUCTURE  KOMVD
*"----------------------------------------------------------------------

  TYPES: BEGIN OF TY_VAL,
           SUB    TYPE KWERT,
           NET    TYPE KWERT,
           R_JEXC TYPE KBETR,  "Excise
           A_JEXC TYPE KWERT,
           R_JVAT TYPE KBETR,  "VAT
           A_JVAT TYPE KWERT,
         END OF TY_VAL.

  DATA GS_TOTAL TYPE TY_VAL.
  DATA: LS_KOMK     TYPE KOMK,
        LS_KOMP     TYPE KOMP,
        LT_KOMV     TYPE TABLE OF KOMV,
        LT_KOMV_NET TYPE TABLE OF KOMV.

  DATA: LS_KOMV  TYPE KOMV,
        LS_KOMVD TYPE KOMVD.

  DATA: LS_EKPO TYPE EKPO.

  DATA: LV_STEUC TYPE MARC-STEUC.
  DATA: LV_BRSCH TYPE LFA1-BRSCH.
  DATA: LV_SUB TYPE KWERT,
        LV_NET TYPE KWERT.
  DATA: LT_T685T TYPE TABLE OF T685T,
        LS_T685T TYPE T685T.


  DEFINE GET_TAX.
    LOOP AT lt_komv_net INTO ls_komv WHERE kschl = &1.  "'JSRT'.
      IF sy-index = 1.
        ls_komvd-kschl = ls_komv-kschl.
        LS_KOMVD-KRECH = LS_KOMV-KRECH.
        CASE ls_komv-krech.
          WHEN 'A'.
            ls_komvd-kbetr  = ls_komv-kbetr / 10 .
            ls_komvd-KNUMT  = '%'.
          WHEN 'B'.
            ls_komvd-kbetr  = ls_komv-kbetr.
            CASE ls_komv-WAERS.
              WHEN 'INR'.
                ls_komvd-KNUMT  = 'Rs.'.
*        	WHEN .
              WHEN OTHERS.
                ls_komvd-KNUMT  = ls_komv-WAERS.
            ENDCASE.
          WHEN 'C'.
            ls_komvd-kbetr  = ls_komv-kbetr.
            CASE ls_komv-WAERS.
              WHEN 'INR'.
               ls_komvd-KNUMT  = 'Rs.'.
*        	    WHEN .
              WHEN OTHERS.
                ls_komvd-KNUMT  = ls_komv-WAERS.
            ENDCASE.
            CONCATENATE ls_komvd-KNUMT '/' ls_komv-KMEIN
              INTO ls_komvd-KNUMT.

          WHEN OTHERS.
        ENDCASE.


        READ TABLE lt_t685t INTO ls_t685t
          WITH KEY kschl = ls_komvd-kschl.
        ls_komvd-vtext = ls_t685t-vtext.
      ENDIF.
      ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.

    ENDLOOP.

    IF ls_komvd-kwert > 0.
      APPEND ls_komvd TO et_komvd.
      lv_net = lv_net + ls_komvd-kwert.
    ENDIF.
    CLEAR ls_komvd.

  END-OF-DEFINITION.

*  break jayant.

  SELECT * FROM T685T
    INTO TABLE LT_T685T
    WHERE SPRAS = SY-LANGU
      AND ( KAPPL = 'TX' OR KAPPL = 'M' ).



*  selecting the value of brsch (industry key)
  SELECT SINGLE BRSCH
    FROM LFA1
    INTO LV_BRSCH
   WHERE LIFNR = ZXEKKO-LIFNR.

  LOOP AT IT_EKPO INTO LS_EKPO.

*Sub total
    LV_SUB = LV_SUB + LS_EKPO-NETWR.

    "Taxes
    SELECT SINGLE STEUC
      FROM MARC
      INTO LV_STEUC
     WHERE MATNR = LS_EKPO-MATNR
       AND WERKS = LS_EKPO-WERKS.

    CLEAR: LS_KOMK, LS_KOMP.

*Filling KOMK (Header Structure)
    LS_KOMK-KAPPL     = 'TX'.
    LS_KOMK-KALSM     = 'TAXINN'.
    LS_KOMK-LIFNR     = ZXEKKO-LIFNR.
    LS_KOMK-WAERK     = ZXEKKO-WAERS.
    LS_KOMK-ALAND     = 'IN'.
    LS_KOMK-HWAER     = 'INR'.
    LS_KOMK-BUKRS     = ZXEKKO-BUKRS.
    LS_KOMK-BRSCH     = LV_BRSCH.
    LS_KOMK-PRSDT     = ZXEKKO-BEDAT.
    LS_KOMK-EKORG     = ZXEKKO-EKORG.
    LS_KOMK-MWSKZ     = LS_EKPO-MWSKZ.

*Filling KOMP (Details Structure)
    LS_KOMP-KPOSN     = LS_EKPO-EBELP.
    LS_KOMP-MATNR     = LS_EKPO-MATNR.
    LS_KOMP-WERKS     = LS_EKPO-WERKS.
    LS_KOMP-MATKL     = LS_EKPO-MATKL.
    LS_KOMP-MEINS     = LS_EKPO-MEINS.
    LS_KOMP-VRKME     = LS_EKPO-BPRME.
    LS_KOMP-NETWR     = LS_EKPO-NETWR.
    LS_KOMP-WRBTR     = LS_EKPO-NETWR.
    LS_KOMP-MWSKZ     = LS_EKPO-MWSKZ.
    LS_KOMP-NETPR     = LS_EKPO-NETPR.
    LS_KOMP-MTART     = LS_EKPO-MTART.
    LS_KOMP-KURSK_DAT = LS_EKPO-PRDAT.
    LS_KOMP-STEUC     = LV_STEUC.
    LS_KOMP-MGAME     = LS_EKPO-MENGE.
    LS_KOMP-MGLME     = LS_EKPO-MENGE.

    REFRESH LT_KOMV.

*Calling The Pricing Function To Get GR EXCISE, GR ECES, GR VAT/CST
    CALL FUNCTION 'PRICING'
      EXPORTING
        CALCULATION_TYPE = 'B'
        COMM_HEAD_I      = LS_KOMK
        COMM_ITEM_I      = LS_KOMP
      TABLES
        TKOMV            = LT_KOMV.

    APPEND LINES OF LT_KOMV TO LT_KOMV_NET.  "Collect conditons for all items

  ENDLOOP.

  APPEND LINES OF IT_KOMV TO LT_KOMV_NET.



  LV_NET = LV_SUB.


  GET_TAX : 'FRA1',
            'FRB1',
            'FRC1',
            'ZOC%',
            'ZOCQ',
            'ZOCV',
            'ZPC1',
            'ZPFL',
            'ZPFV',
            'ZST%',
            'ZST1',
            'ZSTQ',
            'ZSTV'.

  CLEAR LS_KOMVD.
*Calculate total Excise
  LOOP AT LT_KOMV_NET INTO LS_KOMV WHERE KSCHL = 'JMOP'
*                                      OR KSCHL = 'JAOP'
                                      OR KSCHL = 'JMIP'.
*                                      OR KSCHL = 'JAOQ'.
    IF SY-INDEX = 1.
      LS_KOMVD-KSCHL = LS_KOMV-KSCHL.  "'JMOP'.
      LS_KOMVD-KRECH = LS_KOMV-KRECH.

      CASE LS_KOMV-KRECH.
        WHEN 'A'.
          LS_KOMVD-KBETR  = LS_KOMV-KBETR / 10 .
          LS_KOMVD-KNUMT  = '%'.
        WHEN 'B'.
          LS_KOMVD-KBETR  = LS_KOMV-KBETR.
          CASE LS_KOMV-WAERS.
            WHEN 'INR'.
              LS_KOMVD-KNUMT  = 'Rs.'.
*        	WHEN .
            WHEN OTHERS.
              LS_KOMVD-KNUMT  = LS_KOMV-WAERS.
          ENDCASE.
        WHEN 'C'.
          LS_KOMVD-KBETR  = LS_KOMV-KBETR.
          CASE LS_KOMV-WAERS.
            WHEN 'INR'.
              LS_KOMVD-KNUMT  = 'Rs.'.
*        	    WHEN .
            WHEN OTHERS.
              LS_KOMVD-KNUMT  = LS_KOMV-WAERS.
          ENDCASE.
          CONCATENATE LS_KOMVD-KNUMT '/' LS_KOMV-KMEIN
            INTO LS_KOMVD-KNUMT.

        WHEN OTHERS.
      ENDCASE.
*      LS_KOMVD-KBETR  = LS_KOMV-KBETR / 10 .
      READ TABLE LT_T685T INTO LS_T685T
        WITH KEY KSCHL = LS_KOMVD-KSCHL.
      LS_KOMVD-VTEXT = LS_T685T-VTEXT.
    ENDIF.
    LS_KOMVD-KWERT = LS_KOMVD-KWERT + LS_KOMV-KWERT.

  ENDLOOP.

  IF LS_KOMVD-KWERT > 0.
    APPEND LS_KOMVD TO ET_KOMVD.
    LV_NET = LV_NET + LS_KOMVD-KWERT.
  ENDIF.
  CLEAR LS_KOMVD.

*Calculate The VAT
*  LOOP AT LT_KOMV_NET INTO LS_KOMV WHERE KSCHL = 'JVRN'
*                                  OR KSCHL = 'JVRD'
*                                  OR KSCHL = 'JVCS'
*                                  OR KSCHL = 'JVCD'
*                                  OR KSCHL = 'JVCN'
*                                  OR KSCHL = 'JIPS'
*                                  OR KSCHL = 'JIPC'
*                                  OR KSCHL = 'JIPL'.

  LOOP AT LT_KOMV_NET INTO LS_KOMV WHERE KSCHL = 'JVRD'
                                  OR KSCHL = 'JVRN'.
*                                  OR KSCHL = 'JVCS'
*                                  OR KSCHL = 'JSER'
*                                  OR KSCHL = 'JSV2'
*                                  OR KSCHL = 'JSSB'
*                                  OR KSCHL = 'JKKP'.
    IF SY-INDEX = 1.
      LS_KOMVD-KSCHL = LS_KOMV-KSCHL.  "'JVRD'.
      LS_KOMVD-KRECH = LS_KOMV-KRECH.
*      LS_KOMVD-KBETR  = LS_KOMV-KBETR / 10 .
      CASE LS_KOMV-KRECH.
        WHEN 'A'.
          LS_KOMVD-KBETR  = LS_KOMV-KBETR / 10 .
          LS_KOMVD-KNUMT  = '%'.
        WHEN 'B'.
          LS_KOMVD-KBETR  = LS_KOMV-KBETR.
          CASE LS_KOMV-WAERS.
            WHEN 'INR'.
              LS_KOMVD-KNUMT  = 'Rs.'.
*        	WHEN .
            WHEN OTHERS.
              LS_KOMVD-KNUMT  = LS_KOMV-WAERS.
          ENDCASE.
        WHEN 'C'.
          LS_KOMVD-KBETR  = LS_KOMV-KBETR.
          CASE LS_KOMV-WAERS.
            WHEN 'INR'.
              LS_KOMVD-KNUMT  = 'Rs.'.
*        	    WHEN .
            WHEN OTHERS.
              LS_KOMVD-KNUMT  = LS_KOMV-WAERS.
          ENDCASE.
          CONCATENATE LS_KOMVD-KNUMT '/' LS_KOMV-KMEIN
            INTO LS_KOMVD-KNUMT.

        WHEN OTHERS.
      ENDCASE.
      READ TABLE LT_T685T INTO LS_T685T
        WITH KEY KSCHL = LS_KOMVD-KSCHL.
      LS_KOMVD-VTEXT = LS_T685T-VTEXT.
    ENDIF.
    LS_KOMVD-KWERT = LS_KOMVD-KWERT + LS_KOMV-KWERT.

  ENDLOOP.

  IF LS_KOMVD-KWERT > 0.
    APPEND LS_KOMVD TO ET_KOMVD.
    LV_NET = LV_NET + LS_KOMVD-KWERT.
  ENDIF.
  CLEAR LS_KOMVD.

  GET_TAX : 'JSER',
            'JSV2',
            'JSSB',
            'JKKP',
            'JVCS'.
*            'JCV1',
*            'JEDB',
*            'JSDB',
*            'JADC',
*            'SKTO'.

  E_SUB = LV_SUB.
  E_NET = LV_NET.

*
**Calculate A/R Service Tax
*  LOOP AT lt_komv_net INTO ls_komv WHERE kschl = 'JSRT'.
*    IF sy-index = 1.
*      ls_komvd-kschl = ls_komv-kschl.
*      ls_komvd-kbetr  = ls_komv-kbetr / 10 .
*      READ TABLE lt_t685t INTO ls_t685t
*        WITH KEY kschl = ls_komvd-kschl.
*      ls_komvd-vtext = ls_t685t-vtext.
*    ENDIF.
*    ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.
*
*  ENDLOOP.
*
*  IF ls_komvd-kwert > 0.
*    APPEND ls_komvd TO et_komvd.
*    lv_net = lv_net + ls_komvd-kwert.
*  ENDIF.
*  CLEAR ls_komvd.
*
*
**Calculate A/P Krishi for ST
*  LOOP AT lt_komv_net INTO ls_komv WHERE kschl = 'JSKK'.
*    IF sy-index = 1.
*      ls_komvd-kschl = ls_komv-kschl.
*      ls_komvd-kbetr  = ls_komv-kbetr / 10 .
*      READ TABLE lt_t685t INTO ls_t685t
*        WITH KEY kschl = ls_komvd-kschl.
*      ls_komvd-vtext = ls_t685t-vtext.
*    ENDIF.
*    ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.
*
*  ENDLOOP.
*
*  IF ls_komvd-kwert > 0.
*    APPEND ls_komvd TO et_komvd.
*    lv_net = lv_net + ls_komvd-kwert.
*  ENDIF.
*  CLEAR ls_komvd.
*
*
**Calculate A/P Swachh for ST
*  LOOP AT lt_komv_net INTO ls_komv WHERE kschl = 'JSSB'.
*    IF sy-index = 1.
*      ls_komvd-kschl = ls_komv-kschl.
*      ls_komvd-kbetr  = ls_komv-kbetr / 10 .
*      READ TABLE lt_t685t INTO ls_t685t
*        WITH KEY kschl = ls_komvd-kschl.
*      ls_komvd-vtext = ls_t685t-vtext.
*    ENDIF.
*    ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.
*
*  ENDLOOP.
*
*  IF ls_komvd-kwert > 0.
*    APPEND ls_komvd TO et_komvd.
*    lv_net = lv_net + ls_komvd-kwert.
*  ENDIF.
*  CLEAR ls_komvd.
*
*
**Calculate IN Basic customs
*  LOOP AT lt_komv_net INTO ls_komv WHERE kschl = 'JCDB'.
*    IF sy-index = 1.
*      ls_komvd-kschl = ls_komv-kschl.
*      ls_komvd-kbetr  = ls_komv-kbetr / 10 .
*      READ TABLE lt_t685t INTO ls_t685t
*        WITH KEY kschl = ls_komvd-kschl.
*      ls_komvd-vtext = ls_t685t-vtext.
*    ENDIF.
*    ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.
*
*  ENDLOOP.
*
*  IF ls_komvd-kwert > 0.
*    APPEND ls_komvd TO et_komvd.
*    lv_net = lv_net + ls_komvd-kwert.
*  ENDIF.
*  CLEAR ls_komvd.
*
*
**Calculate IN Special customs
*  LOOP AT lt_komv_net INTO ls_komv WHERE kschl = 'JCDS'.
*    IF sy-index = 1.
*      ls_komvd-kschl = ls_komv-kschl.
*      ls_komvd-kbetr  = ls_komv-kbetr / 10 .
*      READ TABLE lt_t685t INTO ls_t685t
*        WITH KEY kschl = ls_komvd-kschl.
*      ls_komvd-vtext = ls_t685t-vtext.
*    ENDIF.
*    ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.
*
*  ENDLOOP.
*
*  IF ls_komvd-kwert > 0.
*    APPEND ls_komvd TO et_komvd.
*    lv_net = lv_net + ls_komvd-kwert.
*  ENDIF.
*  CLEAR ls_komvd.
*
*
**Calculate IN CVD
*  LOOP AT lt_komv_net INTO ls_komv WHERE kschl = 'JCV1'.
*    IF sy-index = 1.
*      ls_komvd-kschl = ls_komv-kschl.
*      ls_komvd-kbetr  = ls_komv-kbetr / 10 .
*      READ TABLE lt_t685t INTO ls_t685t
*        WITH KEY kschl = ls_komvd-kschl.
*      ls_komvd-vtext = ls_t685t-vtext.
*    ENDIF.
*    ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.
*
*  ENDLOOP.
*
*  IF ls_komvd-kwert > 0.
*    APPEND ls_komvd TO et_komvd.
*    lv_net = lv_net + ls_komvd-kwert.
*  ENDIF.
*  CLEAR ls_komvd.
*
*
**Calculate Customs Edu Cess
*  LOOP AT lt_komv_net INTO ls_komv WHERE kschl = 'JEDB'.
*    IF sy-index = 1.
*      ls_komvd-kschl = ls_komv-kschl.
*      ls_komvd-kbetr  = ls_komv-kbetr / 10 .
*      READ TABLE lt_t685t INTO ls_t685t
*        WITH KEY kschl = ls_komvd-kschl.
*      ls_komvd-vtext = ls_t685t-vtext.
*    ENDIF.
*    ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.
*
*  ENDLOOP.
*
*  IF ls_komvd-kwert > 0.
*    APPEND ls_komvd TO et_komvd.
*    lv_net = lv_net + ls_komvd-kwert.
*  ENDIF.
*  CLEAR ls_komvd.
*
*
**Calculate Custom H&SE ED Cess
*  LOOP AT lt_komv_net INTO ls_komv WHERE kschl = 'JSDB'.
*    IF sy-index = 1.
*      ls_komvd-kschl = ls_komv-kschl.
*      ls_komvd-kbetr  = ls_komv-kbetr / 10 .
*      READ TABLE lt_t685t INTO ls_t685t
*        WITH KEY kschl = ls_komvd-kschl.
*      ls_komvd-vtext = ls_t685t-vtext.
*    ENDIF.
*    ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.
*
*  ENDLOOP.
*
*  IF ls_komvd-kwert > 0.
*    APPEND ls_komvd TO et_komvd.
*    lv_net = lv_net + ls_komvd-kwert.
*  ENDIF.
*  CLEAR ls_komvd.
*
*
**Calculate Add. Customs Duty
*  LOOP AT lt_komv_net INTO ls_komv WHERE kschl = 'JADC'.
*    IF sy-index = 1.
*      ls_komvd-kschl = ls_komv-kschl.
*      ls_komvd-kbetr  = ls_komv-kbetr / 10 .
*      READ TABLE lt_t685t INTO ls_t685t
*        WITH KEY kschl = ls_komvd-kschl.
*      ls_komvd-vtext = ls_t685t-vtext.
*    ENDIF.
*    ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.
*
*  ENDLOOP.
*
*  IF ls_komvd-kwert > 0.
*    APPEND ls_komvd TO et_komvd.
*    lv_net = lv_net + ls_komvd-kwert.
*  ENDIF.
*  CLEAR ls_komvd.
*
*
**Calculate Cash Discount
*  LOOP AT lt_komv_net INTO ls_komv WHERE kschl = 'SKTO'.
*    IF sy-index = 1.
*      ls_komvd-kschl = ls_komv-kschl.
*      ls_komvd-kbetr  = ls_komv-kbetr / 10 .
*      READ TABLE lt_t685t INTO ls_t685t
*        WITH KEY kschl = ls_komvd-kschl.
*      ls_komvd-vtext = ls_t685t-vtext.
*    ENDIF.
*    ls_komvd-kwert = ls_komvd-kwert + ls_komv-kwert.
*
*  ENDLOOP.
*
*  IF ls_komvd-kwert > 0.
*    APPEND ls_komvd TO et_komvd.
*    lv_net = lv_net + ls_komvd-kwert.
*  ENDIF.
*  CLEAR ls_komvd.
*
*
*




*  gs_total-net = lv_sub
*                + gs_total-a_jexc
*                + gs_total-a_jvat.
*<<Amounts




ENDFUNCTION.
