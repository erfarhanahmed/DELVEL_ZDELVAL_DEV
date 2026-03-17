*&---------------------------------------------------------------------*
*&  Include           ZUS_SD_PEND_SO_DATASEL
*&---------------------------------------------------------------------*


DATA:
    LS_EXCH_RATE TYPE BAPI1093_0.

START-OF-SELECTION.

*BREAK primus.
  LOOP AT S_WERKS.
    IF S_WERKS-LOW = 'PL01'.
      S_WERKS-LOW = ' '.
    ENDIF.
    IF S_WERKS-HIGH = 'PL01'.
      S_WERKS-HIGH = ' '.
    ENDIF.
    MODIFY S_WERKS.
  ENDLOOP.

  IF OPEN_SO = 'X'.
*    BREAK PRIMUS.
    SELECT A~VBELN A~POSNR
    INTO TABLE IT_DATA
    FROM  VBAP AS A
    JOIN  VBUP AS B ON ( B~VBELN = A~VBELN  AND B~POSNR = A~POSNR )
    WHERE A~ERDAT  IN S_DATE
    AND   A~MATNR  IN S_MATNR
    AND   A~WERKS  IN S_WERKS
    AND   A~VBELN  IN S_VBELN
    AND   A~CUSTDELDATE IN S_DDATE
    AND   B~LFSTA  NE 'C'.


    SELECT A~VBELN A~POSNR
        INTO TABLE IT_DELETE
        FROM  VBAP AS A
        JOIN  VBUP AS B ON ( B~VBELN = A~VBELN  AND B~POSNR = A~POSNR )
        JOIN VBAK AS C ON ( C~VBELN = A~VBELN )
        WHERE A~ERDAT  IN S_DATE
        AND   A~MATNR  IN S_MATNR
        AND   A~WERKS  IN S_WERKS
        AND   A~VBELN  IN S_VBELN
        AND   A~CUSTDELDATE IN S_DDATE
        AND   B~GBSTA  = 'C'
        AND   C~AUART IN ( 'US04', 'US05', 'US06' ).


    LOOP AT IT_DELETE INTO WA_DELETE .
      DELETE IT_DATA WHERE VBELN = WA_DELETE-VBELN AND POSNR = WA_DELETE-POSNR.
    ENDLOOP.

    SELECT A~VBELN A~POSNR
       APPENDING TABLE IT_DATA
       FROM  VBAP AS A
       JOIN  LIPSUP AS C ON ( C~VGBEL = A~VBELN  AND C~VGPOS = A~POSNR )
       WHERE A~ERDAT  IN S_DATE
       AND   A~MATNR  IN S_MATNR
       AND   A~WERKS  IN S_WERKS
       AND   A~VBELN  IN S_VBELN
       AND   A~CUSTDELDATE IN S_DDATE
       AND C~GBSTA NE 'C'.



    IF IT_DATA IS NOT INITIAL ."sy-subrc = 0.
      SELECT VBELN
             ERDAT
             AUART
             WAERK
             VKBUR
             KNUMV
             VDATU
             BSTDK
             BNAME
             KUNNR
             ZLDFROMDATE
             ZLDPERWEEK
             ZLDMAX
             FROM VBAK INTO TABLE IT_VBAK FOR ALL ENTRIES IN IT_DATA WHERE VBELN = IT_DATA-VBELN AND
                                                                              KUNNR IN S_KUNNR.          " SHREYAS.

      IF S_WERKS NE 'PL01'.


        PERFORM FILL_TABLES.
        PERFORM PROCESS_FOR_OUTPUT.
        IF P_DOWN IS   INITIAL.
          PERFORM ALV_FOR_OUTPUT.
        ELSE.

          PERFORM DOWN_SET.
        ENDIF.

      ELSE .
        MESSAGE 'This Report valid For US01 & US02 Plant' TYPE 'S'.

      ENDIF.
    ENDIF.

  ELSEIF ALL_SO = 'X'.

    SELECT VBELN POSNR
    FROM  VBAP
    INTO TABLE IT_DATA
    WHERE ERDAT  IN S_DATE
    AND   MATNR  IN S_MATNR
    AND   WERKS  IN S_WERKS
    AND   VBELN  IN S_VBELN
    AND   CUSTDELDATE IN S_DDATE.


    IF IT_DATA IS NOT INITIAL.


      SELECT  VBELN
              ERDAT
              AUART
              WAERK
              VKBUR
              KNUMV
              VDATU
              BSTDK
              BNAME
              KUNNR
              ZLDFROMDATE
              ZLDPERWEEK
              ZLDMAX
              FROM VBAK INTO TABLE IT_VBAK FOR ALL ENTRIES IN IT_DATA
                                                  WHERE
                                                  VBELN = IT_DATA-VBELN AND
                                                  KUNNR IN S_KUNNR.
      IF SY-SUBRC = 0.

        IF S_WERKS NE 'PL01'.


          PERFORM FILL_TABLES.
          PERFORM PROCESS_FOR_OUTPUT.
          IF P_DOWN IS   INITIAL.
            PERFORM ALV_FOR_OUTPUT.
          ELSE.
*            BREAK PRIMUS.
            PERFORM DOWN_SET_ALL.
          ENDIF.
        ELSE.

          MESSAGE 'This Report valid For US01 & US02 Plant' TYPE 'S'.

        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.

  ENDIF.
*ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FILL_TABLES
*&---------------------------------------------------------------------*

FORM FILL_TABLES .

  IF OPEN_SO = 'X'.
    SELECT VBELN
           POSNR
           MATNR
           ABGRU
           KDMAT
           ARKTX
           WAERK
           KWMENG
           WERKS
           OBJNR
           HOLDDATE
           HOLDRELDATE
           CANCELDATE
           DELDATE
           CUSTDELDATE
           ernam
           erdat
           FROM VBAP INTO TABLE IT_VBAP FOR ALL ENTRIES IN IT_DATA WHERE VBELN = IT_DATA-VBELN
                                                                        AND POSNR = IT_DATA-POSNR.
  ELSE.
    SELECT VBELN
           POSNR
           MATNR
           ABGRU
           KDMAT
           ARKTX
           WAERK
           KWMENG
           WERKS
           OBJNR
           HOLDDATE
           HOLDRELDATE
           CANCELDATE
           DELDATE
           CUSTDELDATE
           ernam
           erdat
           FROM VBAP INTO TABLE IT_VBAP FOR ALL ENTRIES IN IT_VBAK WHERE VBELN = IT_VBAK-VBELN.
  ENDIF.
  IF IT_VBAP[] IS NOT INITIAL.

    SELECT VBELN
           KUNNR
           PARVW
      FROM VBPA
      INTO TABLE IT_VBPA
      FOR ALL ENTRIES IN IT_VBAP
      WHERE VBELN = IT_VBAP-VBELN.

    SELECT VBELN
           POSNR
           ETENR
           ETTYP
           EDATU
           FROM VBEP INTO TABLE IT_VBEP
           FOR ALL ENTRIES IN IT_VBAP WHERE VBELN = IT_VBAP-VBELN
                                       AND  POSNR = IT_VBAP-POSNR.
    SORT IT_VBEP BY VBELN POSNR ETENR.

    SELECT VBELN
           POSNR
           ETENR
           ETTYP
           EDATU
           FROM VBEP INTO TABLE LT_VBEP
           FOR ALL ENTRIES IN IT_VBAP WHERE VBELN = IT_VBAP-VBELN
                                       AND  POSNR = IT_VBAP-POSNR
                                       AND  ETENR = '0001'
                                       AND  ETTYP = 'CP'.

    SORT LT_VBEP BY VBELN POSNR ETENR.

    SELECT VBELN
           INCO1
           INCO2
           ZTERM
           KURSK
           BSTKD
           FROM VBKD INTO TABLE IT_VBKD
           FOR ALL ENTRIES IN IT_VBAP
           WHERE VBELN = IT_VBAP-VBELN.




    SELECT MATNR
             WERKS
             LGORT
             VBELN
             POSNR
             KALAB
             KAINS
             FROM MSKA INTO TABLE IT_MSKA
             FOR ALL ENTRIES IN IT_VBAP
             WHERE VBELN = IT_VBAP-VBELN
               AND POSNR = IT_VBAP-POSNR
               AND MATNR = IT_VBAP-MATNR
               AND WERKS = IT_VBAP-WERKS.

   SELECT MATNR
          BWKEY
          STPRS
          BKLAS FROM mbew INTO TABLE it_mbew
          FOR ALL ENTRIES IN it_vbap
            WHERE MATNR = IT_VBAP-MATNR
              AND BWKEY = IT_VBAP-WERKS.


   SELECT MATNR
          MTART
          MATKL
          WRKST
          ZSERIES
          ZSIZE
          BRAND
          MOC
          TYPE   FROM mara INTO TABLE lt_mara
          FOR ALL ENTRIES IN it_vbap
          WHERE MATNR = IT_VBAP-MATNR.

  SELECT MATNR
         WERKS
         DISPO FROM marc INTO TABLE it_marc
         FOR ALL ENTRIES IN it_vbap
            WHERE MATNR = IT_VBAP-MATNR
              AND WERKS = IT_VBAP-WERKS.




IF IT_VBAK IS NOT INITIAL.


    SELECT VBELV
           POSNV
           VBELN
           VBTYP_N
           FROM VBFA INTO TABLE IT_VBFA
           FOR ALL ENTRIES IN IT_VBAK
           WHERE VBELV = IT_VBAK-VBELN
*             AND ( VBTYP_N = 'J' OR  VBTYP_N = 'M' ).
             AND  VBTYP_N IN ( 'J', 'M' ,'T' , 'O' ).
ENDIF.

    SELECT OBJNR
           STAT
           INACT
           CHGNR FROM JEST INTO TABLE IT_JEST
           FOR ALL ENTRIES IN IT_VBAP
           WHERE OBJNR = IT_VBAP-OBJNR
             AND STAT IN S_STAT
             AND INACT NE 'X'.

    IF IT_JEST IS NOT INITIAL.
      SELECT STSMA
             ESTAT
             SPRAS
             TXT04
             TXT30
             LTEXT FROM TJ30T INTO TABLE IT_TJ30T
             FOR ALL ENTRIES IN IT_JEST
               WHERE ESTAT = IT_JEST-STAT
               AND STSMA  = 'OR_ITEM' ."AND SPRAS  = 'EN'.
    ENDIF.


    SELECT SPRAS
           ABGRU
           BEZEI
           FROM TVAGT INTO TABLE IT_TVAGT
           FOR ALL ENTRIES IN IT_VBAP
            WHERE  ABGRU = IT_VBAP-ABGRU
            AND SPRAS = 'E'.

  ENDIF.
  IF IT_VBFA IS NOT INITIAL.
    SELECT VBELN
           FKART
           FKTYP
           VKORG
           VTWEG
           FKDAT
           FKSTO
           FROM VBRK INTO TABLE IT_VBRK
           FOR ALL ENTRIES IN IT_VBFA
           WHERE VBELN = IT_VBFA-VBELN
             AND FKSTO NE 'X'.
  ENDIF.

  IF IT_VBRK IS NOT INITIAL.
    SELECT VBELN
           POSNR
           FKIMG
           AUBEL
           AUPOS
           MATNR
           WERKS
           FROM VBRP INTO TABLE IT_VBRP
           FOR ALL ENTRIES IN IT_VBRK
           WHERE VBELN = IT_VBRK-VBELN.
  ENDIF.
  IF IT_VBKD IS NOT INITIAL.
    SELECT SPRAS
           ZTERM
           VTEXT FROM TVZBT INTO TABLE IT_TVZBT
           FOR ALL ENTRIES IN IT_VBKD
           WHERE SPRAS = 'EN'
            AND ZTERM = IT_VBKD-ZTERM.
  ENDIF.

  IF IT_VBAK IS NOT INITIAL.
    SELECT KUNNR
           NAME1
           ADRNR
           BRSCH
           FROM KNA1 INTO TABLE IT_KNA1
           FOR ALL ENTRIES IN IT_VBAK
           WHERE KUNNR = IT_VBAK-KUNNR.
  ENDIF.


  IF IT_KNA1 IS NOT INITIAL.
    SELECT KUNNR
           KDGRP
           BZIRK
           VKBUR FROM KNVV INTO TABLE IT_KNVV
           FOR ALL ENTRIES IN IT_KNA1
           WHERE KUNNR = IT_KNA1-KUNNR.

    SELECT SPRAS
           BRSCH
           BRTXT FROM T016T INTO TABLE IT_T016T
           FOR ALL ENTRIES IN IT_KNA1
           WHERE BRSCH = IT_KNA1-BRSCH.


  ENDIF.
  IF IT_KNVV IS NOT INITIAL.
    SELECT SPRAS
           KDGRP
           KTEXT FROM T151T INTO TABLE IT_T151T
           FOR ALL ENTRIES IN IT_KNVV
           WHERE SPRAS = 'E'
            AND  KDGRP = IT_KNVV-KDGRP.
  ENDIF.
  IF IT_VBPA IS NOT INITIAL .

    SELECT KUNNR
           NAME1
           ADRNR
           BRSCH
           FROM KNA1 INTO TABLE IT_PARTNER
           FOR ALL ENTRIES IN IT_VBPA
           WHERE KUNNR = IT_VBPA-KUNNR.

    SELECT  KUNNR
            NAME1
            STRAS
            PSTLZ
            ORT01
            REGIO
            LAND1 FROM KNA1 INTO TABLE IT_SHIP
            FOR ALL ENTRIES IN IT_VBPA
            WHERE KUNNR = IT_VBPA-KUNNR.

  ENDIF.

  IF IT_SHIP IS NOT INITIAL.
    SELECT SPRAS
           LAND1
           BLAND
           BEZEI FROM T005U INTO TABLE IT_T005U
           FOR ALL ENTRIES IN IT_SHIP
           WHERE SPRAS = 'EN'
            AND  LAND1 = IT_SHIP-LAND1
            AND  BLAND = IT_SHIP-REGIO.

    SELECT SPRAS
           LAND1
           LANDX FROM T005T INTO TABLE IT_T005T
           FOR ALL ENTRIES IN IT_SHIP
           WHERE SPRAS = 'EN'
            AND  LAND1 = IT_SHIP-LAND1.


  ENDIF.

  IF IT_VBAK IS NOT INITIAL.
           SELECT  KNUMV
                   KPOSN
                   KSCHL
                   KBETR
                   WAERS
                   KINAK
                   kgrpe
                   FROM prcd_elements INTO TABLE IT_KONV
                   FOR ALL ENTRIES IN IT_VBAK
                   WHERE  KNUMV = IT_VBAK-KNUMV
                   AND KSCHL IN ( 'ZPR0' , 'VPRS' , 'ZESC', 'UHF1', 'USC1', 'UMC1' ).

  ENDIF.
ENDFORM.                    " FILL_TABLES
*&---------------------------------------------------------------------*
*&      Form  PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*

FORM PROCESS_FOR_OUTPUT .
  DATA:
    LV_RATIO TYPE RESB-ENMNG,
    LV_QTY   TYPE RESB-ENMNG,
    LV_INDEX TYPE SY-TABIX.
  DATA:  lv_longtxt type char15.

  IF IT_VBAP[] IS NOT INITIAL.
    CLEAR: WA_VBAP, WA_VBAK, WA_VBEP, WA_MSKA,
           WA_VBRP, WA_KONV, WA_KNA1.

    SORT IT_VBAP BY VBELN POSNR MATNR WERKS.
    SORT IT_MSKA BY VBELN POSNR MATNR WERKS.
    SORT IT_AFPO BY KDAUF KDPOS MATNR.
    SORT LT_RESB BY AUFNR KDAUF KDPOS.
    SORT IT_VBAK BY VBELN.
    SORT IT_VBEP BY VBELN POSNR.
    SORT LT_VBEP BY VBELN POSNR.
    SORT IT_VBKD BY VBELN.
    SORT IT_VBRP BY VBELN POSNR.
    SORT IT_KONV BY KNUMV KPOSN.
    SORT IT_KNA1 BY KUNNR.
    SORT IT_JEST BY OBJNR.
    SORT IT_VBFA BY VBELV POSNV.
    LOOP AT IT_VBAP INTO WA_VBAP.

      WA_OUTPUT-WERKS       = WA_VBAP-WERKS.           "PLANT
      WA_OUTPUT-HOLDDATE    = WA_VBAP-HOLDDATE.        "Statsu
      WA_OUTPUT-RELDATE     = WA_VBAP-HOLDRELDATE.     "Release date
      WA_OUTPUT-CANCELDATE  = WA_VBAP-CANCELDATE.      "Cancel date
      WA_OUTPUT-DELDATE     = WA_VBAP-DELDATE.         "delivary date
      WA_OUTPUT-CUSTDELDATE     = WA_VBAP-CUSTDELDATE.         "customer del. date
      WA_OUTPUT-MATNR       = WA_VBAP-MATNR.           "Material
      WA_OUTPUT-POSNR       = WA_VBAP-POSNR.           "item
      WA_OUTPUT-ARKTX       = WA_VBAP-ARKTX.           "item short description
      WA_OUTPUT-KWMENG      = WA_VBAP-KWMENG.          "sales order qty
      WA_OUTPUT-VBELN       = WA_VBAP-VBELN.
      WA_OUTPUT-ernam       = WA_VBAP-ernam.      """Added in Pranit 28.03.2024
      WA_OUTPUT-erdat1      = WA_VBAP-erdat.      """Added in Pranit 28.03.2024

      READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_OUTPUT-VBELN BINARY SEARCH.
      IF SY-SUBRC = 0.
        WA_OUTPUT-AUART       = WA_VBAK-AUART.           "ORDER TYPE
        WA_OUTPUT-BNAME       = WA_VBAK-BNAME.           "contact person.
        WA_OUTPUT-VKBUR       = WA_VBAK-VKBUR.           "Sales Office
        WA_OUTPUT-ERDAT       = WA_VBAK-ERDAT.           "Sales Order date
        WA_OUTPUT-VDATU       = WA_VBAK-VDATU.           "Req del date
        WA_OUTPUT-BSTDK       = WA_VBAK-BSTDK.
      ENDIF.

      READ TABLE IT_VBEP INTO WA_VBEP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR
                                               ETENR = '0001' BINARY SEARCH.
      IF SY-SUBRC = 0.
        WA_OUTPUT-ETTYP       = WA_VBEP-ETTYP.           "So Status
        WA_OUTPUT-EDATU       = WA_VBEP-EDATU.           "delivary Date
        WA_OUTPUT-ETENR       = WA_VBEP-ETENR.           "Schedule line no.
      ENDIF.

      READ TABLE LT_VBEP INTO LS_VBEP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR
                                               ETENR = '0001'
                                               ETTYP = 'CP' .

      READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_OUTPUT-VBELN .
*                                               posnr = wa_vbap-posnr.
      IF SY-SUBRC = 0.
        WA_OUTPUT-BSTKD       = WA_VBKD-BSTKD.           "Cust Ref No.
        WA_OUTPUT-ZTERM       = WA_VBKD-ZTERM.           "payment terms
        WA_OUTPUT-INCO1       = WA_VBKD-INCO1.           "inco terms
        WA_OUTPUT-INCO2       = WA_VBKD-INCO2.           "inco terms description
      ENDIF.

      READ TABLE IT_TVZBT INTO WA_TVZBT WITH KEY ZTERM = WA_OUTPUT-ZTERM .
      IF SY-SUBRC = 0.
        WA_OUTPUT-TEXT1       = WA_TVZBT-VTEXT.          "payment terms description
      ENDIF.

      READ TABLE IT_VBRP INTO WA_VBRP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR  .
      IF SY-SUBRC = 0.

      ENDIF.




**TPI TEXT

      CLEAR: LV_LINES, WA_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'U001'
          LANGUAGE                = 'E'
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      READ TABLE LV_LINES INTO WA_LINES INDEX 1.



*LD Req Text
      CLEAR: LV_LINES, WA_LN_LD.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'U005'
          LANGUAGE                = 'E'
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      READ TABLE LV_LINES INTO WA_LN_LD INDEX 1.

**********
*Tag Required
      CLEAR: LV_LINES, WA_TAG_RQ.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'U006'
          LANGUAGE                = 'E'
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      READ TABLE LV_LINES INTO WA_TAG_RQ INDEX 1.


**********
*Material text
* Added by Shreyas
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = '0001'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'VBBP'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      READ TABLE LV_LINES INTO LS_ITMTXT INDEX 1.


**********
*Special Instruction

      CLEAR: LV_LINES, LS_ITMTXT,LV_NAME.
      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z888'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'VBBP'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF lv_lines IS NOT INITIAL.
        LOOP AT lv_lines INTO LS_ITMTXT.
          IF NOT LS_ITMTXT-TDLINE IS INITIAL..


          CONCATENATE WA_OUTPUT-spl_ins LS_ITMTXT-TDLINE  INTO WA_OUTPUT-spl_ins SEPARATED BY SPACE.

        ENDIF.
        ENDLOOP.
      ENDIF.



*Sales text

      CLEAR: LV_LINES, LS_MATTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-MATNR.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'GRUN'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      READ TABLE LV_LINES INTO LS_MATTXT INDEX 1.


      CLEAR: WA_KONV.




      READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAK-KNUMV
                                                    KPOSN = WA_OUTPUT-POSNR
                                                    KSCHL = 'ZPR0'  KINAK = ' ' .

      IF SY-SUBRC EQ 0.
        WA_OUTPUT-KBETR       = WA_KONV-KBETR.           "Rate
      ENDIF.
      CLEAR: WA_KONV .

      READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAK-KNUMV
                                                    KPOSN = WA_OUTPUT-POSNR
                                                    KSCHL = 'UHF1' .
      IF SY-SUBRC EQ 0.

        IF wa_konv-kgrpe = 'X'.
          ON CHANGE OF WA_VBAK-KNUMV.
          WA_OUTPUT-HUHF1       = WA_KONV-KBETR.           "Rate
          ENDON.
        ELSE.
          WA_OUTPUT-UHF1       = WA_KONV-KBETR.           "Rate
        ENDIF.

      ENDIF.
      CLEAR: WA_KONV .

     READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAK-KNUMV
                                                    KPOSN = WA_OUTPUT-POSNR
                                                    KSCHL = 'USC1' .
      IF SY-SUBRC EQ 0.
        IF wa_konv-kgrpe = 'X'.
          ON CHANGE OF WA_VBAK-KNUMV.
          WA_OUTPUT-HUSC1       = WA_KONV-KBETR.           "Rate
          ENDON.
        ELSE.
          WA_OUTPUT-USC1       = WA_KONV-KBETR.           "Rate
        ENDIF.

      ENDIF.
      CLEAR: WA_KONV .

      READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAK-KNUMV
                                                    KPOSN = WA_OUTPUT-POSNR
                                                    KSCHL = 'UMC1' .

      IF SY-SUBRC EQ 0.
        IF wa_konv-kgrpe = 'X'.
          ON CHANGE OF WA_VBAK-KNUMV.
          WA_OUTPUT-HUMC1       = WA_KONV-KBETR.           "Rate
          ENDON.
        ELSE.
          WA_OUTPUT-UMC1       = WA_KONV-KBETR.           "Rate
        ENDIF.

      ENDIF.
      CLEAR: WA_KONV .


      READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAK-KNUMV
                                               KPOSN = WA_OUTPUT-POSNR
                                               KSCHL = 'VPRS' .
      IF SY-SUBRC EQ 0.
        IF WA_VBAP-WAERK <> 'INR'.
          IF WA_KONV-WAERS <> 'INR'.
            WA_KONV-KBETR = WA_KONV-KBETR * WA_VBKD-KURSK.
          ENDIF.
        ENDIF.
      ENDIF.

      CLEAR: WA_KONV .

      READ TABLE IT_KONV INTO WA_KONV WITH  KEY KNUMV = WA_VBAK-KNUMV
                                                     KPOSN = WA_OUTPUT-POSNR
                                                     KSCHL = 'ZESC' .
      IF SY-SUBRC EQ 0.
        IF WA_VBAP-WAERK <> 'INR'.
          IF WA_KONV-WAERS <> 'INR'.
            WA_KONV-KBETR = WA_KONV-KBETR * WA_VBKD-KURSK.
          ENDIF.
        ENDIF.
      ENDIF.



      CLEAR WA_KNA1.
      READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_VBAK-KUNNR BINARY SEARCH.
      IF SY-SUBRC = 0.
        WA_OUTPUT-NAME1       = WA_KNA1-NAME1.           "Cust Name
      ENDIF.

      CLEAR WA_JEST1.
      READ TABLE IT_JEST INTO WA_JEST1 WITH KEY OBJNR = WA_VBAP-OBJNR BINARY SEARCH.
      IF SY-SUBRC = 0.


        READ TABLE IT_TJ30T INTO WA_TJ30T WITH  KEY ESTAT = WA_JEST1-STAT
                                                 STSMA  = 'OR_ITEM'
                                                 SPRAS  = 'EN' BINARY SEARCH.
        IF WA_TJ30T IS NOT INITIAL.
          WA_OUTPUT-STATUS      = WA_TJ30T-TXT30.          "Hold/Unhold
        ENDIF.
      ENDIF.

      CLEAR : WA_MSKA.

CLEAR: WA_VBFA, WA_LFIMG, WA_LFIMG_SUM.

      LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_OUTPUT-VBELN
                                   AND POSNV = WA_OUTPUT-POSNR
                                   AND VBTYP_N = 'J'.

        CLEAR WA_LFIMG.
        SELECT SINGLE LFIMG FROM LIPS INTO  WA_LFIMG  WHERE VBELN = WA_VBFA-VBELN
                                                      AND   PSTYV = 'ZTAN'
                                                      AND   VGBEL = WA_OUTPUT-VBELN
                                                      AND   VGPOS = WA_OUTPUT-POSNR.
        WA_LFIMG_SUM = WA_LFIMG_SUM + WA_LFIMG .

      ENDLOOP.
*INVOICE QTY
      CLEAR: WA_VBFA, WA_FKIMG, WA_FKIMG_SUM.
      LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_OUTPUT-VBELN
                                     AND POSNV = WA_OUTPUT-POSNR
                                     AND VBTYP_N = 'M'.

        CLEAR WA_VBRK.
        READ TABLE IT_VBRK INTO WA_VBRK WITH KEY   VBELN = WA_VBFA-VBELN.
        IF SY-SUBRC = 0.


          CLEAR WA_FKIMG.
          SELECT SINGLE FKIMG FROM VBRP INTO  WA_FKIMG  WHERE VBELN = WA_VBRK-VBELN
                                                        AND   AUBEL = WA_OUTPUT-VBELN
                                                        AND   AUPOS = WA_OUTPUT-POSNR.
          WA_FKIMG_SUM = WA_FKIMG_SUM + WA_FKIMG .
        ENDIF.
      ENDLOOP.

****

******************Logic For US03 Order Type****************************************
IF WA_OUTPUT-AUART = 'US03'.
      CLEAR: WA_VBFA, WA_LFIMG, WA_LFIMG_SUM.

      LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_OUTPUT-VBELN
                                   AND POSNV = WA_OUTPUT-POSNR
                                   AND VBTYP_N = 'T'.

        CLEAR WA_LFIMG.
        SELECT SINGLE LFIMG FROM LIPS INTO  WA_LFIMG  WHERE VBELN = WA_VBFA-VBELN
                                                      AND   PSTYV = 'UREN'   "'ZTAN'
                                                      AND   VGBEL = WA_OUTPUT-VBELN
                                                      AND   VGPOS = WA_OUTPUT-POSNR.
        WA_LFIMG_SUM = WA_LFIMG_SUM + WA_LFIMG .

      ENDLOOP.

      CLEAR: WA_VBFA, WA_FKIMG, WA_FKIMG_SUM.
      LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_OUTPUT-VBELN
                                     AND POSNV = WA_OUTPUT-POSNR
                                     AND VBTYP_N = 'O'.

        CLEAR WA_VBRK.
        READ TABLE IT_VBRK INTO WA_VBRK WITH KEY   VBELN = WA_VBFA-VBELN.
        IF SY-SUBRC = 0.


          CLEAR WA_FKIMG.
          SELECT SINGLE FKIMG FROM VBRP INTO  WA_FKIMG  WHERE VBELN = WA_VBRK-VBELN
                                                        AND   AUBEL = WA_OUTPUT-VBELN
                                                        AND   AUPOS = WA_OUTPUT-POSNR.
          WA_FKIMG_SUM = WA_FKIMG_SUM + WA_FKIMG .
        ENDIF.
      ENDLOOP.
ENDIF.

*********************************************************************************************************
*      CLEAR WA_MBEW.
*      SELECT SINGLE * FROM MBEW INTO WA_MBEW WHERE MATNR = WA_OUTPUT-MATNR
*                                               AND BWKEY = WA_OUTPUT-WERKS.
      READ TABLE it_mbew INTO wa_mbew WITH KEY MATNR = WA_OUTPUT-MATNR BWKEY = WA_OUTPUT-WERKS.
      IF sy-subrc = 0.
        WA_OUTPUT-ST_COST     = WA_MBEW-STPRS .          "Standard Cost
        WA_OUTPUT-BKLAS       = WA_MBEW-BKLAS.
      ENDIF.

*      CLEAR WA_MARA.
*      SELECT SINGLE * FROM MARA INTO WA_MARA WHERE MATNR = WA_OUTPUT-MATNR.

      READ TABLE lt_mara INTO wa_mara WITH KEY MATNR = WA_OUTPUT-MATNR.
        IF  sy-subrc = 0.
          WA_OUTPUT-ZSERIES     = WA_MARA-ZSERIES.         "series
          WA_OUTPUT-ZSIZE       = WA_MARA-ZSIZE.           "size
          WA_OUTPUT-BRAND       = WA_MARA-BRAND.           "Brand
          WA_OUTPUT-MOC         = WA_MARA-MOC.             "MOC
          WA_OUTPUT-TYPE        = WA_MARA-TYPE.            "TYPE
          WA_OUTPUT-MTART        = WA_MARA-MTART.          " Material TYPE
          WA_OUTPUT-WRKST       = WA_MARA-WRKST.

        ENDIF.

       READ TABLE it_marc INTO wa_marc WITH KEY MATNR = WA_OUTPUT-MATNR WERKS = WA_OUTPUT-WERKS.
        IF sy-subrc = 0.
          WA_OUTPUT-DISPO = WA_MARC-DISPO.
        ENDIF.



*      SELECT SINGLE DISPO FROM MARC INTO WA_OUTPUT-DISPO WHERE MATNR = WA_OUTPUT-MATNR.
      """""""""""""""""""""""""""""""""""""""""""""""""""
*currency conversion
      REFRESH LS_FR_CURR.
      CLEAR LS_FR_CURR.
      LS_FR_CURR-SIGN   = 'I'.
      LS_FR_CURR-OPTION = 'EQ'.
      LS_FR_CURR-LOW = WA_VBAK-WAERK.
      APPEND LS_FR_CURR.
      CLEAR: LS_EX_RATE,LV_EX_RATE, LS_RETURN.
      REFRESH: LS_EX_RATE, LS_RETURN.
      IF LS_TO_CURR-LOW <> LS_FR_CURR-LOW.

*        CALL FUNCTION 'BAPI_EXCHRATE_GETCURRENTRATES'
*          EXPORTING
*            date             = sy-datum
*            date_type        = 'V'
*            rate_type        = 'B'
*          TABLES
*            from_curr_range  = ls_fr_curr
*            to_currncy_range = ls_to_curr
*            exch_rate_list   = ls_ex_rate
*            return           = ls_return.
*
*        CLEAR lv_ex_rate.
*        READ TABLE ls_ex_rate INTO lv_ex_rate INDEX 1.
      ELSE.
        LV_EX_RATE-EXCH_RATE = 1.
      ENDIF.

*Latest Estimated cost

      REFRESH: IT_KONH.
      CLEAR:   IT_KONH.

*  FOR ZESC
***      SELECT * FROM KONH INTO TABLE IT_KONH WHERE KOTABNR = '508'
***                                              AND KSCHL  = 'ZESC'
***                                              AND VAKEY = WA_OUTPUT-MATNR
***                                              AND DATAB <= SY-DATUM
***                                              AND DATBI >= SY-DATUM .
***
***      SORT  IT_KONH DESCENDING BY KNUMH .
***      CLEAR WA_KONH.
***      READ TABLE IT_KONH INTO WA_KONH INDEX 1.
***
***      CLEAR WA_KONP.
***      SELECT SINGLE * FROM KONP INTO WA_KONP WHERE KNUMH = WA_KONH-KNUMH
***                                              AND KSCHL  = 'ZESC'.

*MRP DATE

      CLEAR WA_CDPOS.
      DATA TABKEY TYPE CDPOS-TABKEY.
      CONCATENATE SY-MANDT WA_VBEP-VBELN WA_VBEP-POSNR WA_VBEP-ETENR INTO TABKEY.
      SELECT OBJECTCLAS
             OBJECTID
             CHANGENR
             TABNAME
             TABKEY
             FNAME
             CHNGIND
             VALUE_NEW
             FROM CDPOS INTO TABLE IT_CDPOS WHERE TABKEY = TABKEY

**                                               AND value_new = 'CP'
**                                               AND value_old = 'CN'
                                               AND TABNAME = 'VBEP' AND FNAME = 'ETTYP'.
      SORT IT_CDPOS BY CHANGENR DESCENDING.
      READ TABLE IT_CDPOS INTO WA_CDPOS INDEX 1.
      IF WA_CDPOS-VALUE_NEW = 'CP' .
        SELECT SINGLE * FROM CDHDR INTO WA_CDHDR WHERE CHANGENR = WA_CDPOS-CHANGENR.
        WA_OUTPUT-MRP_DT      = WA_CDHDR-UDATE.           "MRP date EDATU to TDDAT changed by Pranav Khadatkar
      ENDIF.
      CLEAR :WA_CDHDR,wa_cdpos,tabkey..



******Rejectiom Date
      CONCATENATE sy-mandt wa_vbap-vbeln wa_vbap-posnr into tabkey.
      SELECT OBJECTCLAS
             OBJECTID
             CHANGENR
             TABNAME
             TABKEY
             FNAME
             CHNGIND
             VALUE_NEW
             FROM cdpos INTO TABLE it_cdpos WHERE tabkey = tabkey
                                               and tabname = 'VBAP' and fname = 'ABGRU'.


      SORT it_cdpos by changenr DESCENDING.
      READ TABLE it_cdpos INTO wa_cdpos INDEX 1.
      IF wa_cdpos-value_new NE ' '.
       SELECT SINGLE * FROM cdhdr INTO wa_cdhdr WHERE changenr = wa_cdpos-changenr.
         wa_output-rej_dt      = WA_cdhdr-udate.
         wa_output-rej_nm      = WA_cdhdr-username.
       ENDIF.
      CLEAR: wa_cdhdr,wa_cdpos,tabkey.
      REFRESH it_cdpos.


      CLEAR WA_TVAGT.



      READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_VBAP-VBELN PARVW = 'UR' .
      IF SY-SUBRC = 0.
        WA_OUTPUT-PARTNER = WA_VBPA-KUNNR.
      ENDIF.

      READ TABLE IT_PARTNER INTO WA_PARTNER WITH KEY KUNNR = WA_OUTPUT-PARTNER .
      IF SY-SUBRC = 0.
        WA_OUTPUT-PART_NAME = WA_PARTNER-NAME1.

      ENDIF.

      READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_VBAP-VBELN PARVW = 'WE' BINARY SEARCH.
      IF SY-SUBRC = 0.
        READ TABLE IT_SHIP INTO WA_SHIP WITH KEY KUNNR = WA_VBPA-KUNNR.
        IF SY-SUBRC = 0.
          WA_OUTPUT-SHIP_NAME = WA_SHIP-NAME1.
          wa_output-ship_code = wa_ship-kunnr.
          WA_OUTPUT-STRAS     = WA_SHIP-STRAS.
          WA_OUTPUT-PSTLZ     = WA_SHIP-PSTLZ.
          WA_OUTPUT-ORT01     = WA_SHIP-ORT01.

        ENDIF.

      ENDIF.

      READ TABLE IT_T005U INTO WA_T005U WITH KEY SPRAS = 'EN' LAND1 = WA_SHIP-LAND1 BLAND = WA_SHIP-REGIO .
      IF SY-SUBRC = 0.
        WA_OUTPUT-SHIP_RIG = WA_T005U-BEZEI.
      ENDIF.

      READ TABLE IT_T005T INTO WA_T005T WITH KEY SPRAS = 'EN' LAND1 = WA_SHIP-LAND1 .
      IF SY-SUBRC = 0.
        WA_OUTPUT-SHIP_LAND = WA_T005T-LANDX.
      ENDIF.

      READ TABLE IT_KNVV INTO WA_KNVV WITH KEY KUNNR = WA_KNA1-KUNNR .
      IF SY-SUBRC = 0.
        WA_OUTPUT-KDGRP      = WA_KNVV-KDGRP.

      ENDIF.

      READ TABLE IT_T151T INTO WA_T151T WITH KEY KDGRP = WA_KNVV-KDGRP .
      IF SY-SUBRC = 0.
        WA_OUTPUT-KTEXT = WA_T151T-KTEXT.

      ENDIF.
      READ TABLE IT_T016T INTO WA_T016T WITH KEY BRSCH = WA_KNA1-BRSCH .
      IF SY-SUBRC = 0.
        WA_OUTPUT-BRSCH = WA_T016T-BRSCH.
        WA_OUTPUT-BRTXT = WA_T016T-BRTXT.

      ENDIF.



      CLEAR WA_TEXT.
      WA_TEXT = WA_TAG_RQ-TDLINE(20).
      TRANSLATE WA_TEXT TO UPPER CASE .       "tag Required
      WA_OUTPUT-TAG_REQ     = WA_TEXT.

      WA_OUTPUT-LFIMG       = WA_LFIMG_SUM.                "del qty
      WA_OUTPUT-FKIMG       = WA_FKIMG_SUM.                "inv qty
      WA_OUTPUT-PND_QTY     = WA_OUTPUT-KWMENG - WA_OUTPUT-FKIMG.  "Pending Qty

      READ TABLE IT_TVAGT INTO WA_TVAGT WITH KEY  ABGRU = WA_VBAP-ABGRU  SPRAS = 'E' .

      IF WA_TVAGT-ABGRU IS INITIAL.
        WA_OUTPUT-ABGRU           =  '-'.
      ELSE.
        WA_OUTPUT-ABGRU           =  WA_TVAGT-ABGRU.
      ENDIF.
      IF WA_TVAGT-BEZEI IS INITIAL.
        WA_OUTPUT-BEZEI           =  '-'.
      ELSE.
        WA_OUTPUT-BEZEI           =  WA_TVAGT-BEZEI.
      ENDIF.

      IF WA_OUTPUT-AUART = 'US03'.
        WA_OUTPUT-PND_QTY = WA_OUTPUT-PND_QTY * -1.
      ENDIF.


      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR WA_OUTPUT-ETENR
        INTO WA_OUTPUT-SCHID(25).

      DATA LV_QMQTY TYPE MSKA-KAINS.
      CLEAR LV_QMQTY.

      READ TABLE IT_MSKA INTO WA_MSKA WITH KEY VBELN = WA_VBAP-VBELN
                                               POSNR = WA_VBAP-POSNR
                                               MATNR = WA_VBAP-MATNR
                                               WERKS = WA_VBAP-WERKS.
      IF SY-SUBRC IS INITIAL.
*        LV_INDEX = SY-TABIX.
*        LOOP AT IT_MSKA INTO WA_MSKA FROM LV_INDEX.
*          IF WA_MSKA-VBELN = WA_VBAP-VBELN AND WA_MSKA-POSNR = WA_VBAP-POSNR
*           AND WA_MSKA-MATNR = WA_VBAP-MATNR AND WA_MSKA-WERKS = WA_VBAP-WERKS.
*            LV_QMQTY = WA_MSKA-KAINS - LV_QMQTY.
*          ELSE.
*            CLEAR LV_INDEX.
*            EXIT.
*          ENDIF.
*        ENDLOOP.
      ENDIF.

      WA_OUTPUT-MATTXT = LS_MATTXT-TDLINE.

      CLEAR WA_TEXT.
      WA_TEXT = WA_LINES-TDLINE.
      TRANSLATE WA_TEXT TO UPPER CASE .
      WA_OUTPUT-TPI         = WA_TEXT.     "TPI Required
      CLEAR WA_TEXT.
      WA_TEXT = WA_LN_LD-TDLINE.     "wa_ln_ld ld_req
      TRANSLATE WA_TEXT TO UPPER CASE .
      WA_OUTPUT-LD_TXT         = WA_TEXT.     "lD Required
      WA_OUTPUT-KUNNR        = WA_VBAK-KUNNR.
      WA_OUTPUT-WAERK        = WA_VBAP-WAERK.           "Currency

      IF LV_EX_RATE-EXCH_RATE IS NOT INITIAL.
        WA_OUTPUT-AMONT       = WA_OUTPUT-PND_QTY * WA_OUTPUT-KBETR *
                                LV_EX_RATE-EXCH_RATE.    "Amount
        WA_OUTPUT-ORDR_AMT    = WA_OUTPUT-KWMENG * WA_OUTPUT-KBETR *
                                LV_EX_RATE-EXCH_RATE.    "Ordr Amount
      ELSEIF LV_EX_RATE-EXCH_RATE IS INITIAL.
        WA_OUTPUT-AMONT       = WA_OUTPUT-PND_QTY * WA_OUTPUT-KBETR .
        WA_OUTPUT-ORDR_AMT    = WA_OUTPUT-KWMENG * WA_OUTPUT-KBETR .
      ENDIF.






**ECCN
      CLEAR: LV_LINES, WA_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'U002'
          LANGUAGE                = 'E'
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

*      READ TABLE lv_lines INTO wa_lines INDEX 1.

      LOOP AT LV_LINES INTO WA_LINES.
        IF NOT WA_LINES-TDLINE IS INITIAL..


          CONCATENATE WA_OUTPUT-ECCN WA_LINES-TDLINE  INTO WA_OUTPUT-ECCN SEPARATED BY SPACE.

        ENDIF.
      ENDLOOP.



IF WA_OUTPUT-AUART = 'US03'.
  WA_OUTPUT-KWMENG    = WA_OUTPUT-KWMENG * -1.
  WA_OUTPUT-LFIMG     = WA_OUTPUT-LFIMG * -1.
  WA_OUTPUT-FKIMG     = WA_OUTPUT-FKIMG * -1.
  WA_OUTPUT-ORDR_AMT  = WA_OUTPUT-ORDR_AMT * -1.
ENDIF.

IF WA_OUTPUT-AUART = 'US12' .
  WA_OUTPUT-KWMENG    = WA_OUTPUT-KWMENG * -1.
  WA_OUTPUT-PND_QTY   = WA_OUTPUT-PND_QTY * -1.
  WA_OUTPUT-AMONT     = WA_OUTPUT-AMONT * -1.
  WA_OUTPUT-ORDR_AMT  = WA_OUTPUT-ORDR_AMT * -1.
ENDIF.

      REFRESH : IT_JEST2 , IT_JEST2[] .
      CLEAR : WA_AFPO , WA_CAUFV.

      WA_OUTPUT-REF_DT = SY-DATUM.

      APPEND WA_OUTPUT TO IT_OUTPUT.
      CLEAR LS_VBEP.CLEAR WA_OUTPUT.

    ENDLOOP.


  ENDIF.
*BREAK primus.
  """"""""""""""""""        Added By KD on 05.05.2017                 """""""""""""
*  IF IT_OUTPUT[] IS NOT INITIAL.
*    REFRESH : IT_OAUTO , IT_OAUTO[] , IT_MAST , IT_MAST[] , IT_STKO , IT_STKO[] ,
*              IT_STPO , IT_STPO[] , IT_MARA , IT_MARA[] , IT_MAKT , IT_MAKT[] .
*
*    IT_OAUTO[] = IT_OUTPUT[] .
*
*    DELETE IT_OAUTO WHERE DISPO NE 'AUT' .
*    DELETE IT_OAUTO WHERE MTART NE 'FERT'.
*
*    SELECT MATNR WERKS STLAN STLNR STLAL FROM MAST INTO TABLE IT_MAST
*                                            FOR ALL ENTRIES IN IT_OAUTO
*                                                  WHERE MATNR = IT_OAUTO-MATNR
*                                                    AND STLAN = 1.
*
*    SELECT STLTY STLNR STLAL STKOZ FROM STKO INTO TABLE IT_STKO
*                                      FOR ALL ENTRIES IN IT_MAST
*                                                  WHERE STLNR = IT_MAST-STLNR
*                                                    AND STLAL = IT_MAST-STLAL.
*
*    SELECT STLTY STLNR STLKN STPOZ IDNRK FROM STPO INTO TABLE IT_STPO
*                                            FOR ALL ENTRIES IN IT_STKO
*                                                        WHERE STLNR = IT_STKO-STLNR
*                                                          AND STPOZ = IT_STKO-STKOZ .
*
*    SELECT MATNR
*           MTART
*           MATKL
*           WRKST
*           ZSERIES
*           ZSIZE
*           BRAND
*           MOC
*           TYPE
*           FROM MARA INTO TABLE IT_MARA FOR ALL ENTRIES IN IT_STPO
*                                                    WHERE MATNR = IT_STPO-IDNRK
*                                                      AND MTART = 'FERT' .
*
*    SELECT matnr
*           maktx
*           SPRAS
*           FROM MAKT INTO TABLE IT_MAKT FOR ALL ENTRIES IN IT_MARA
*                                                      WHERE MATNR = IT_MARA-MATNR
*                                                        AND SPRAS = 'EN'.
*
*    CLEAR WA_OUTPUT .
*    LOOP AT IT_MAKT INTO WA_MAKT .
*      READ TABLE IT_STPO INTO WA_STPO WITH KEY IDNRK = WA_MAKT-MATNR .
*      IF SY-SUBRC = 0.
*        READ TABLE IT_STKO INTO WA_STKO WITH KEY STLNR = WA_STPO-STLNR STKOZ = WA_STPO-STPOZ .
*        IF SY-SUBRC = 0.
*          READ TABLE IT_MAST INTO WA_MAST WITH KEY STLNR = WA_STKO-STLNR STLAL = WA_STKO-STLAL.
*          IF SY-SUBRC = 0.
*            WA_OUTPUT-MATNR = WA_MAST-MATNR.
**            wa_output-scmat = wa_makt-matnr.
*            WA_OUTPUT-ARKTX = WA_MAKT-MAKTX.
*
*
*            APPEND WA_OUTPUT TO IT_OUTPUT.
*            CLEAR WA_OUTPUT .
*          ENDIF.
*        ENDIF.
*      ENDIF.
*      CLEAR : WA_MAST , WA_STKO , WA_STPO , WA_MAKT.
*    ENDLOOP.
*
*  ENDIF.
*  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

ENDFORM.                    " PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
FORM ALV_FOR_OUTPUT .
*ADDING TOP OF PAGE FEATURE
  PERFORM STP3_EVENTTAB_BUILD   CHANGING GT_EVENTS[].
  PERFORM COMMENT_BUILD         CHANGING I_LIST_TOP_OF_PAGE[].
  PERFORM TOP_OF_PAGE.
  PERFORM LAYOUT_BUILD          CHANGING WA_LAYOUT.
****************************************************************************************

  PERFORM BUILD_FIELDCAT USING 'WERKS'          'X' '1'   'Plant'.                        "(003).
  PERFORM BUILD_FIELDCAT USING 'AUART'          'X' '2'   'Order Type'.                   "(004).
  PERFORM BUILD_FIELDCAT USING 'BSTKD'          'X' '3'   'Customer PO No'.               "(005).
  PERFORM BUILD_FIELDCAT USING 'BSTDK'          'X' '4'   'Customer PO Date'.             "(005).
  PERFORM BUILD_FIELDCAT USING 'KUNNR'          'X' '5'   'Customer Code'.
  PERFORM BUILD_FIELDCAT USING 'NAME1'          'X' '6'   'Customer'.                     "(006).
  PERFORM BUILD_FIELDCAT USING 'PARTNER'        'X' '7'   'Sales Rep. No'.                " (006).
  PERFORM BUILD_FIELDCAT USING 'PART_NAME'      'X' '8'   'Sales Rep. Name'.              "(006).
  PERFORM BUILD_FIELDCAT USING 'KDGRP'          'X' '9'   'Customer Group'.               "(006).
  PERFORM BUILD_FIELDCAT USING 'KTEXT'          'X' '10'   'Customer Group Desc'.         "(006).
  PERFORM BUILD_FIELDCAT USING 'BRSCH'          'X' '11'   'Industry Sector'.             "(006).
  PERFORM BUILD_FIELDCAT USING 'BRTXT'          'X' '12'   'Industry Sector Desc'.        "(006).
  PERFORM BUILD_FIELDCAT USING 'VKBUR'          'X' '13'   'Sales Office'.                "(007).
  PERFORM BUILD_FIELDCAT USING 'VBELN'          'X' '14'   'Sales Doc No'.                "(008).
  PERFORM BUILD_FIELDCAT USING 'ERDAT'          'X' '15'   'So Date'.                     "(009).
  PERFORM BUILD_FIELDCAT USING 'VDATU'          'X' '16'   'Required Delivery Dt'.        "(010).
  PERFORM BUILD_FIELDCAT USING 'STATUS'         'X' '17'   'Hold/Unhold'.                 "(011).
  PERFORM BUILD_FIELDCAT USING 'HOLDDATE'       'X' '18'  'Hold Date'.                    "(012).
  PERFORM BUILD_FIELDCAT USING 'RELDATE'        'X' '19'  'Release Date'.                 "(013).
  PERFORM BUILD_FIELDCAT USING 'CANCELDATE'     'X' '20'  'Cancelled Date'.               "(014).
  PERFORM BUILD_FIELDCAT USING 'DELDATE'        'X' '21'  'Delivery Date'.                "(015).
  PERFORM BUILD_FIELDCAT USING 'TPI'            'X' '22'  'Shipping Method'.               "(044).
  PERFORM BUILD_FIELDCAT USING 'TAG_REQ'        'X' '23'  'Service Charge'.               "  (049).
  PERFORM BUILD_FIELDCAT USING 'LD_TXT'         'X' '24'  'Remark'.                       "(050).
  PERFORM BUILD_FIELDCAT USING 'MATNR'          'X' '25'   'Item Code' .                 "(016).
  PERFORM BUILD_FIELDCAT USING 'WRKST'          'X' '26'   'USA Code'.                    "(016).
  PERFORM BUILD_FIELDCAT USING 'BKLAS'          'X' '27'   'Valuation Class'.               "(016).
  PERFORM BUILD_FIELDCAT USING 'POSNR'          'X' '28'   'Line Item'.                   "(017).
  PERFORM BUILD_FIELDCAT USING 'ARKTX'          'X' '29'   'Item Description'.              "(018).
  PERFORM BUILD_FIELDCAT USING 'MATTXT'         'X' '30'   'Material long Text'.
  PERFORM BUILD_FIELDCAT USING 'KWMENG'         'X' '31'   'SO QTY'.                        " (019).
  PERFORM BUILD_FIELDCAT USING 'LFIMG'          'X' '32'   'Delivary Qty'.                  "(021).
  PERFORM BUILD_FIELDCAT USING 'FKIMG'          'X' '33'   'Invoice Quantity'.              "(022).
  PERFORM BUILD_FIELDCAT USING 'PND_QTY'        'X' '34'   'Pending Qty'.                   " (023).
  PERFORM BUILD_FIELDCAT USING 'ETTYP'          'X' '35'   'SO Status'.                     "(024).
  PERFORM BUILD_FIELDCAT USING 'MRP_DT'         'X' '36'   'MRP Inclusion Date'.              "(045).
  PERFORM BUILD_FIELDCAT USING 'EDATU'          'X' '37'   'Int Production date'.   "'Posting Date'(025).
  PERFORM BUILD_FIELDCAT USING 'KBETR'          'X' '38'   'Rate'.                            "(026).
  PERFORM BUILD_FIELDCAT USING 'WAERK'          'X' '39'   'Currency Type'.                     "(027).
  PERFORM BUILD_FIELDCAT USING 'AMONT'          'X' '40'   'Pending SO Amount'.
  PERFORM BUILD_FIELDCAT USING 'ORDR_AMT'       'X' '41'   'Order Amount'.
  PERFORM BUILD_FIELDCAT USING 'ST_COST'         'X' '42'   'Standard Cost'.
  PERFORM BUILD_FIELDCAT USING 'ZSERIES'         'X' '43'   'Series'.
  PERFORM BUILD_FIELDCAT USING 'ZSIZE'           'X' '44'   'Size'.
  PERFORM BUILD_FIELDCAT USING 'BRAND'           'X' '45'   'Brand'.
  PERFORM BUILD_FIELDCAT USING 'MOC'             'X' '46'   'MOC'.
  PERFORM BUILD_FIELDCAT USING 'TYPE'            'X' '47'   'Type'.
  PERFORM BUILD_FIELDCAT USING 'DISPO'            'X' '48'   'MRP Controller'.
  PERFORM BUILD_FIELDCAT USING 'MTART'            'X' '49'   'MAT TYPE'.
  PERFORM BUILD_FIELDCAT USING 'ETENR'            'X' '50'   'Schedule No'.
  PERFORM BUILD_FIELDCAT USING 'SCHID'            'X' '51'   'Schedule Id'.
  PERFORM BUILD_FIELDCAT USING 'ZTERM'            'X' '52'   'Payment Terms'.
  PERFORM BUILD_FIELDCAT USING 'TEXT1'            'X' '53'   'Payment Terms Text'.
  PERFORM BUILD_FIELDCAT USING 'INCO1'            'X' '54'   'Inco Terms'.
  PERFORM BUILD_FIELDCAT USING 'INCO2'            'X' '55'   'Inco Terms Descr'.
  PERFORM BUILD_FIELDCAT USING 'CUSTDELDATE'      'X' '56'  'Customer Delivery Date'.
  PERFORM BUILD_FIELDCAT USING 'BNAME'            'X' '57'  'Contact Person'.
  PERFORM BUILD_FIELDCAT USING 'ECCN'             'X' '58'  'ECCN'.
  PERFORM BUILD_FIELDCAT USING 'ABGRU'            'X' '59'  'Rejection Reason Code'.   "
  PERFORM BUILD_FIELDCAT USING 'BEZEI'            'X' '60'  'Rejection Reason Description'.
  PERFORM build_fieldcat USING 'SHIP_CODE'        'X' '61'  'Ship To Party Code'.
  PERFORM BUILD_FIELDCAT USING 'SHIP_NAME'        'X' '61'  'Ship To Party Name'.
  PERFORM BUILD_FIELDCAT USING 'STRAS'            'X' '62'  'Ship To Party House No'.
  PERFORM BUILD_FIELDCAT USING 'PSTLZ'            'X' '63'  'Ship To Party Postal Code'.
  PERFORM BUILD_FIELDCAT USING 'ORT01'            'X' '64'  'Ship To Party City'.
  PERFORM BUILD_FIELDCAT USING 'SHIP_RIG'         'X' '65'  'Ship To Party Region'.
  PERFORM BUILD_FIELDCAT USING 'SHIP_LAND'        'X' '66'  'Ship To Party Country'.
  PERFORM build_fieldcat USING 'REJ_DT'           'X' '67'  'Rejection Date' .
  PERFORM build_fieldcat USING 'REJ_NM'           'X' '68'  'Rejection By'.
  PERFORM build_fieldcat USING 'UHF1'             'X' '69'  'Handling Charges '.
  PERFORM build_fieldcat USING 'USC1'             'X' '70'  'Service Charges'.
  PERFORM build_fieldcat USING 'UMC1'             'X' '71'  'Mounting Charges'.
  PERFORM build_fieldcat USING 'HUHF1'            'X' '72'  'Hed.Handling Charges '.
  PERFORM build_fieldcat USING 'HUSC1'            'X' '73'  'Hed.Service Charges'.
  PERFORM build_fieldcat USING 'HUMC1'            'X' '74'  'Hed.Mounting Charges'.
  PERFORM build_fieldcat USING 'SPL_INS'          'X' '75'  'Special Instruction'.
  PERFORM build_fieldcat USING 'ERNAM'            'X' '76'  'Created By'.          """ Added by Pranit 28.03.2024
  PERFORM build_fieldcat USING 'ERDAT'            'X' '77'  'Created On'.          """ Added by Pranit 28.03.2024



  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      I_STRUCTURE_NAME   = 'OUTPUT'
      IS_LAYOUT          = WA_LAYOUT
      IT_FIELDCAT        = IT_FCAT
      IT_SORT            = I_SORT
      I_DEFAULT          = 'A'
      I_SAVE             = 'A'
      IT_EVENTS          = GT_EVENTS[]
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
      T_OUTTAB           = IT_OUTPUT
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  REFRESH IT_OUTPUT.
ENDFORM.                    " ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*

FORM STP3_EVENTTAB_BUILD  CHANGING P_GT_EVENTS TYPE SLIS_T_EVENT.

  DATA: LF_EVENT TYPE SLIS_ALV_EVENT. "WORK AREA

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      I_LIST_TYPE     = 0
    IMPORTING
      ET_EVENTS       = P_GT_EVENTS
    EXCEPTIONS
      LIST_TYPE_WRONG = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  MOVE C_FORMNAME_TOP_OF_PAGE TO LF_EVENT-FORM.
  MODIFY P_GT_EVENTS  FROM  LF_EVENT INDEX 3 TRANSPORTING FORM."TO P_I_EVENTS .



ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
FORM COMMENT_BUILD CHANGING I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER.
  DATA: LF_LINE       TYPE SLIS_LISTHEADER. "WORK AREA
*--LIST HEADING -  TYPE H
  CLEAR LF_LINE.
  LF_LINE-TYP  = C_H.
  LF_LINE-INFO =  'Pending Sales Order'(042).
  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.
*--HEAD INFO: TYPE S
  CLEAR LF_LINE.
  LF_LINE-TYP  = C_S.
  LF_LINE-KEY  = TEXT-043.
  LF_LINE-INFO = SY-DATUM.
  WRITE SY-DATUM TO LF_LINE-INFO USING EDIT MASK '__.__.____'.
  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.

ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM TOP_OF_PAGE .

*** THIS FM IS USED TO CREATE ALV HEADER
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = I_LIST_TOP_OF_PAGE[]. "INTERNAL TABLE WITH


ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM LAYOUT_BUILD  CHANGING P_WA_LAYOUT TYPE SLIS_LAYOUT_ALV.

*        IT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  WA_LAYOUT-ZEBRA          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
  P_WA_LAYOUT-ZEBRA          = 'X'.
  P_WA_LAYOUT-NO_COLHEAD        = ' '.
*  WA_LAYOUT-BOX_FIELDNAME     = 'BOX'.
*  WA_LAYOUT-BOX_TABNAME       = 'IT_FINAL_ALV'.


ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM BUILD_FIELDCAT  USING    V1  V2 V3 V4.
  WA_FCAT-FIELDNAME   = V1 ." 'VBELN'.
  WA_FCAT-TABNAME     = 'IT_FINAL_NEW'.
* WA_FCAT-_ZEBRA      = 'X'.
  WA_FCAT-KEY         =  V2 ."  'X'.
  WA_FCAT-SELTEXT_M   =  V4.
  WA_FCAT-OUTPUTLEN   =  18.
  WA_FCAT-DDICTXT     =  'M'.
  WA_FCAT-COL_POS     =  V3.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWN_SET .

  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).


  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_OUTPUT
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.                "added for check
  LV_FILE = 'ZUSAPENDSO.TXT'.

  CONCATENATE P_FOLDER '\' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUSPENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
  IF OPEN_SO IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', S_DATE-LOW, 'To', S_DATE-HIGH.
  WRITE: / 'Material code   From', S_MATNR-LOW, 'To', S_MATNR-HIGH.
  WRITE: / 'Dest. File:', LV_FULLFILE.

  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    TRANSFER HD_CSV TO LV_FULLFILE.
    LOOP AT IT_CSV INTO WA_CSV.
      IF SY-SUBRC = 0.
        TRANSFER WA_CSV TO LV_FULLFILE.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


******************************************************new file zpendso **********************************
  PERFORM NEW_FILE.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = GT_FINAL
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.       "added for check
  LV_FILE = 'ZUSAPENDSO.TXT'.

  CONCATENATE P_FOLDER '\' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    TRANSFER HD_CSV TO LV_FULLFILE.
    LOOP AT IT_CSV INTO WA_CSV.
      IF SY-SUBRC = 0.
        TRANSFER WA_CSV TO LV_FULLFILE.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    PD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE
          'Plant'
          'Order Type'
          'Customer PO No'
          'Customer PO Date'
          'Customer Code'
          'Customer'
          'Sales Rep. No'
          'Sales Rep. Name'
          'Customer Group'
          'Customer Group Desc'
          'Industry Sector'
          'Industry Sector Desc'
          'Sales Office'
          'Sales Doc No'
          'So Date'
          'Required Delivery Dt'
          'Hold/Unhold'
          'Hold Date'
          'Release Date'
          'Cancelled Date'
          'Delivery Date'
          'Shipping Method'
          'Service Charge'
          'Remark'
          'Item Code'
          'USA Code'
          'Valuation Class'
          'Line Item'
          'Item Description'
          'Material long Text'
          'SO QTY'
          'Delivary Qty'
          'Invoice Quantity'
          'Pending Qty'
          'SO Status'
          'MRP Inclusion Date'
          'Int Production date'
          'Rate'
          'Currency Type'
          'Pending SO Amount'
          'Order Amount'
          'Standard Cost'
          'Series'
          'Size'
          'Brand'
          'MOC'
          'Type'
          'MRP Controller'
          'MAT TYPE'
          'Schedule No'
          'Schedule Id'
          'Payment Terms'
          'Payment Terms Text'
          'Inco Terms'
          'Inco Terms Descr'
          'Customer Delivery Date'
          'Contact Person'
          'ECCN'
          'Rejection Reason Code'
          'Rejection Reason Description'
          'File Created Date'
          'Ship To Party Name'
          'Ship To Party House No'
          'Ship To Party Postal Code'
          'Ship To Party City'
          'Ship To Party Region'
          'Ship To Party Country'
          'Rejection Date'
          'Rejection By'
          'Ship To Party Code'
          'Handling Charges '
          'Service Charges'
          'Mounting Charges'
          'Hed.Handling Charges'
          'Hed.Service Charges'
          'Hed.Mounting Charges'
          'Special Instruction'
          'Created By'
          'Created On'

  INTO PD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NEW_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM NEW_FILE .
  DATA:
    LS_FINAL TYPE T_FINAL.
  LOOP AT IT_OUTPUT INTO WA_OUTPUT.
    LS_FINAL-WERKS       = WA_OUTPUT-WERKS.
    LS_FINAL-AUART       = WA_OUTPUT-AUART.
    LS_FINAL-BSTKD       = WA_OUTPUT-BSTKD.
*    ls_final-bstdk       = wa_output-bstdk.
    LS_FINAL-KUNNR       = WA_OUTPUT-KUNNR.
    LS_FINAL-NAME1       = WA_OUTPUT-NAME1.
    LS_FINAL-PARTNER     = WA_OUTPUT-PARTNER.
    LS_FINAL-PART_NAME   = WA_OUTPUT-PART_NAME.
    LS_FINAL-KDGRP       = WA_OUTPUT-KDGRP.
    LS_FINAL-KTEXT       = WA_OUTPUT-KTEXT.
    LS_FINAL-BRSCH       = WA_OUTPUT-BRSCH.
    LS_FINAL-BRTXT       = WA_OUTPUT-BRTXT.
    LS_FINAL-VKBUR       = WA_OUTPUT-VKBUR.
    LS_FINAL-VBELN       = WA_OUTPUT-VBELN.
    IF WA_OUTPUT-ERDAT IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-ERDAT
        IMPORTING
          OUTPUT = LS_FINAL-ERDAT.
      CONCATENATE LS_FINAL-ERDAT+0(2) LS_FINAL-ERDAT+2(3) LS_FINAL-ERDAT+5(4)
                     INTO LS_FINAL-ERDAT SEPARATED BY '-'.
    ENDIF.

      ls_final-erdat1         =   LS_FINAL-ERDAT.
      ls_final-ernam         =   WA_OUTPUT-ernam.

    IF WA_OUTPUT-BSTDK IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-BSTDK
        IMPORTING
          OUTPUT = LS_FINAL-BSTDK.
      CONCATENATE LS_FINAL-BSTDK+0(2) LS_FINAL-BSTDK+2(3) LS_FINAL-BSTDK+5(4)
                     INTO LS_FINAL-BSTDK SEPARATED BY '-'.
    ENDIF.








    IF WA_OUTPUT-VDATU IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-VDATU
        IMPORTING
          OUTPUT = LS_FINAL-VDATU.
      CONCATENATE LS_FINAL-VDATU+0(2) LS_FINAL-VDATU+2(3) LS_FINAL-VDATU+5(4)
                     INTO LS_FINAL-VDATU SEPARATED BY '-'.
    ENDIF.


    LS_FINAL-STATUS      = WA_OUTPUT-STATUS.


    IF WA_OUTPUT-HOLDDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-HOLDDATE
        IMPORTING
          OUTPUT = LS_FINAL-HOLDDATE.
      CONCATENATE LS_FINAL-HOLDDATE+0(2) LS_FINAL-HOLDDATE+2(3) LS_FINAL-HOLDDATE+5(4)
                     INTO LS_FINAL-HOLDDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-RELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-RELDATE
        IMPORTING
          OUTPUT = LS_FINAL-RELDATE.
      CONCATENATE LS_FINAL-RELDATE+0(2) LS_FINAL-RELDATE+2(3) LS_FINAL-RELDATE+5(4)
                     INTO LS_FINAL-RELDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-CANCELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-CANCELDATE
        IMPORTING
          OUTPUT = LS_FINAL-CANCELDATE.
      CONCATENATE LS_FINAL-CANCELDATE+0(2) LS_FINAL-CANCELDATE+2(3) LS_FINAL-CANCELDATE+5(4)
                     INTO LS_FINAL-CANCELDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-DELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-DELDATE
        IMPORTING
          OUTPUT = LS_FINAL-DELDATE.
      CONCATENATE LS_FINAL-DELDATE+0(2) LS_FINAL-DELDATE+2(3) LS_FINAL-DELDATE+5(4)
                     INTO LS_FINAL-DELDATE SEPARATED BY '-'.
    ENDIF.


    LS_FINAL-TPI         = WA_OUTPUT-TPI.
    LS_FINAL-TAG_REQ     = WA_OUTPUT-TAG_REQ.
    LS_FINAL-LD_TXT      = WA_OUTPUT-LD_TXT.
    LS_FINAL-MATNR       = WA_OUTPUT-MATNR.
    LS_FINAL-WRKST       = WA_OUTPUT-WRKST.
    LS_FINAL-ABGRU       = WA_OUTPUT-ABGRU.
    LS_FINAL-BEZEI       = WA_OUTPUT-BEZEI.
    LS_FINAL-BKLAS       = WA_OUTPUT-BKLAS.
    LS_FINAL-POSNR       = WA_OUTPUT-POSNR.
    LS_FINAL-ARKTX       = WA_OUTPUT-ARKTX.
    LS_FINAL-KWMENG      = ABS( WA_OUTPUT-KWMENG ).
    LS_FINAL-LFIMG       = ABS( WA_OUTPUT-LFIMG ).
    LS_FINAL-FKIMG       = ABS( WA_OUTPUT-FKIMG ).
    LS_FINAL-PND_QTY     = ABS( WA_OUTPUT-PND_QTY ).
    LS_FINAL-ETTYP       = WA_OUTPUT-ETTYP.
    LS_FINAL-rej_nm       = wa_output-rej_nm.
    IF WA_OUTPUT-MRP_DT IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-MRP_DT
        IMPORTING
          OUTPUT = LS_FINAL-MRP_DT.
      CONCATENATE LS_FINAL-MRP_DT+0(2) LS_FINAL-MRP_DT+2(3) LS_FINAL-MRP_DT+5(4)
                     INTO LS_FINAL-MRP_DT SEPARATED BY '-'.
    ENDIF.

    IF wa_output-rej_dt IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_output-rej_dt
        IMPORTING
          output = ls_final-rej_dt.
      CONCATENATE ls_final-rej_dt+0(2) ls_final-rej_dt+2(3) ls_final-rej_dt+5(4)
                     INTO ls_final-rej_dt SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-EDATU IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-EDATU
        IMPORTING
          OUTPUT = LS_FINAL-EDATU.
      CONCATENATE LS_FINAL-EDATU+0(2) LS_FINAL-EDATU+2(3) LS_FINAL-EDATU+5(4)
                     INTO LS_FINAL-EDATU SEPARATED BY '-'.
    ENDIF.


    LS_FINAL-KBETR       = WA_OUTPUT-KBETR.
    LS_FINAL-WAERK       = WA_OUTPUT-WAERK.
    LS_FINAL-AMONT       = ABS( WA_OUTPUT-AMONT ).
    LS_FINAL-ORDR_AMT    = ABS( WA_OUTPUT-ORDR_AMT ).
    LS_FINAL-ST_COST     = ABS( WA_OUTPUT-ST_COST ).

*    ls_final-est_cost    = abs( wa_output-est_cost ).

    LS_FINAL-ZSERIES     = WA_OUTPUT-ZSERIES.
    LS_FINAL-ZSIZE       = WA_OUTPUT-ZSIZE.
    LS_FINAL-BRAND       = WA_OUTPUT-BRAND.
    LS_FINAL-MOC         = WA_OUTPUT-MOC.
    LS_FINAL-TYPE        = WA_OUTPUT-TYPE.
    LS_FINAL-DISPO       = WA_OUTPUT-DISPO.
    LS_FINAL-MTART       = WA_OUTPUT-MTART.
    LS_FINAL-MATTXT      = WA_OUTPUT-MATTXT.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN LS_FINAL-MATTXT WITH ' & '.
    LS_FINAL-ETENR       = WA_OUTPUT-ETENR.
    LS_FINAL-SCHID       = WA_OUTPUT-SCHID.
    LS_FINAL-ZTERM       = WA_OUTPUT-ZTERM.
    LS_FINAL-INCO1       = WA_OUTPUT-INCO1.
    LS_FINAL-INCO2       = WA_OUTPUT-INCO2.
    LS_FINAL-TEXT1       = WA_OUTPUT-TEXT1.
    IF WA_OUTPUT-CUSTDELDATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-CUSTDELDATE
        IMPORTING
          OUTPUT = LS_FINAL-CUSTDELDATE.
      CONCATENATE LS_FINAL-CUSTDELDATE+0(2) LS_FINAL-CUSTDELDATE+2(3) LS_FINAL-CUSTDELDATE+5(4)
                     INTO LS_FINAL-CUSTDELDATE SEPARATED BY '-'.
    ENDIF.


    LS_FINAL-BNAME       = WA_OUTPUT-BNAME.
    LS_FINAL-ECCN        = WA_OUTPUT-ECCN.
    LS_FINAL-spl_ins     = WA_OUTPUT-spl_ins.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = LS_FINAL-REF_DT.
    CONCATENATE LS_FINAL-REF_DT+0(2) LS_FINAL-REF_DT+2(3) LS_FINAL-REF_DT+5(4)
                   INTO LS_FINAL-REF_DT SEPARATED BY '-'.

    ls_final-ship_code   =     wa_output-ship_code.
    LS_FINAL-SHIP_NAME   =     WA_OUTPUT-SHIP_NAME.
    LS_FINAL-STRAS       =     WA_OUTPUT-STRAS    .
    LS_FINAL-PSTLZ       =     WA_OUTPUT-PSTLZ    .
    LS_FINAL-ORT01       =     WA_OUTPUT-ORT01    .
    LS_FINAL-SHIP_RIG    =     WA_OUTPUT-SHIP_RIG.
    LS_FINAL-SHIP_LAND   =     WA_OUTPUT-SHIP_LAND.

    LS_FINAL-UHF1   =    ABS( WA_OUTPUT-UHF1 ).
    LS_FINAL-USC1   =    ABS( WA_OUTPUT-USC1 ).
    LS_FINAL-UMC1   =    ABS( WA_OUTPUT-UMC1 ).

    LS_FINAL-HUHF1   =    ABS( WA_OUTPUT-HUHF1 ).
    LS_FINAL-HUSC1   =    ABS( WA_OUTPUT-HUSC1 ).
    LS_FINAL-HUMC1   =    ABS( WA_OUTPUT-HUMC1 ).

    CONDENSE LS_FINAL-UHF1.
    IF WA_OUTPUT-UHF1 < 0.
      CONCATENATE '-' LS_FINAL-UHF1 INTO LS_FINAL-UHF1.
    ENDIF.

    CONDENSE LS_FINAL-USC1.
    IF WA_OUTPUT-USC1 < 0.
      CONCATENATE '-' LS_FINAL-USC1 INTO LS_FINAL-USC1.
    ENDIF.

    CONDENSE LS_FINAL-UMC1.
    IF WA_OUTPUT-UMC1 < 0.
      CONCATENATE '-' LS_FINAL-UMC1 INTO LS_FINAL-UMC1.
    ENDIF.


    CONDENSE LS_FINAL-HUHF1.
    IF WA_OUTPUT-HUHF1 < 0.
      CONCATENATE '-' LS_FINAL-HUHF1 INTO LS_FINAL-HUHF1.
    ENDIF.

    CONDENSE LS_FINAL-HUSC1.
    IF WA_OUTPUT-HUSC1 < 0.
      CONCATENATE '-' LS_FINAL-HUSC1 INTO LS_FINAL-HUSC1.
    ENDIF.

    CONDENSE LS_FINAL-HUMC1.
    IF WA_OUTPUT-HUMC1 < 0.
      CONCATENATE '-' LS_FINAL-HUMC1 INTO LS_FINAL-HUMC1.
    ENDIF.

    CONDENSE LS_FINAL-KWMENG.
    IF WA_OUTPUT-KWMENG < 0.
      CONCATENATE '-' LS_FINAL-KWMENG INTO LS_FINAL-KWMENG.
    ENDIF.


*    IF wa_output-zldfromdate IS NOT INITIAL .
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          input  = wa_output-zldfromdate
*        IMPORTING
*          output = ls_final-zldfromdate.
*      CONCATENATE ls_final-zldfromdate+0(2) ls_final-zldfromdate+2(3) ls_final-zldfromdate+5(4)
*                     INTO ls_final-zldfromdate SEPARATED BY '-'.
*    ENDIF.



*
*    IF wa_output-in_pr_dt IS NOT INITIAL .
*      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*        EXPORTING
*          input  = wa_output-in_pr_dt
*        IMPORTING
*          output = ls_final-in_pr_dt.
*      CONCATENATE ls_final-in_pr_dt+0(2) ls_final-in_pr_dt+2(3) ls_final-in_pr_dt+5(4)
*                     INTO ls_final-in_pr_dt SEPARATED BY '-'.
*    ENDIF.
*



    CONDENSE LS_FINAL-LFIMG.
    IF WA_OUTPUT-LFIMG < 0.
      CONCATENATE '-' LS_FINAL-LFIMG INTO LS_FINAL-LFIMG.
    ENDIF.

    CONDENSE LS_FINAL-FKIMG.
    IF WA_OUTPUT-FKIMG < 0.
      CONCATENATE '-' LS_FINAL-FKIMG INTO LS_FINAL-FKIMG.
    ENDIF.

    CONDENSE LS_FINAL-PND_QTY.
    IF WA_OUTPUT-PND_QTY < 0.
      CONCATENATE '-' LS_FINAL-PND_QTY INTO LS_FINAL-PND_QTY.
    ENDIF.

*    CONDENSE ls_final-qmqty.
*    IF wa_output-qmqty < 0.
*      CONCATENATE '-' ls_final-qmqty INTO ls_final-qmqty.
*    ENDIF.

    CONDENSE LS_FINAL-KBETR.
    IF WA_OUTPUT-KBETR < 0.
      CONCATENATE '-' LS_FINAL-KBETR INTO LS_FINAL-KBETR.
    ENDIF.

*    CONDENSE ls_final-kalab.
*    IF ls_final-kalab < 0.
*      CONCATENATE '-' ls_final-kalab INTO ls_final-kalab.
*    ENDIF.

*    CONDENSE ls_final-so_exc.
*    IF ls_final-so_exc < 0.
*      CONCATENATE '-' ls_final-so_exc INTO ls_final-so_exc.
*    ENDIF.

    CONDENSE LS_FINAL-AMONT.
    IF WA_OUTPUT-AMONT < 0.
      CONCATENATE '-' LS_FINAL-AMONT INTO LS_FINAL-AMONT.
    ENDIF.

    CONDENSE LS_FINAL-ORDR_AMT.
    IF WA_OUTPUT-ORDR_AMT < 0.
      CONCATENATE '-' LS_FINAL-ORDR_AMT INTO LS_FINAL-ORDR_AMT.
    ENDIF.


*    CONDENSE ls_final-in_price.
*    IF wa_output-in_price < 0.
*      CONCATENATE '-' ls_final-in_price INTO ls_final-in_price.
*    ENDIF.

*    CONDENSE ls_final-est_cost.
*    IF wa_output-est_cost < 0.
*      CONCATENATE '-' ls_final-est_cost INTO ls_final-est_cost.
*    ENDIF.

*    CONDENSE ls_final-latst_cost.
*    IF wa_output-latst_cost < 0.
*      CONCATENATE '-' ls_final-latst_cost INTO ls_final-latst_cost.
*    ENDIF.

    CONDENSE LS_FINAL-ST_COST.
    IF WA_OUTPUT-ST_COST < 0.
      CONCATENATE '-' LS_FINAL-ST_COST INTO LS_FINAL-ST_COST.
    ENDIF.

*    CONDENSE ls_final-wip.
*    IF ls_final-wip < 0.
*      CONCATENATE '-' ls_final-wip INTO ls_final-wip.
*
*    ENDIF.

    APPEND LS_FINAL TO GT_FINAL.
    CLEAR:
      LS_FINAL,WA_OUTPUT.
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
FORM DOWN_SET_ALL .

  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).


  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_OUTPUT
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZUSAPENDSOALL.TXT'.

  CONCATENATE P_FOLDER '\' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUSPENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
  IF OPEN_SO IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', S_DATE-LOW, 'To', S_DATE-HIGH.
  WRITE: / 'Material code   From', S_MATNR-LOW, 'To', S_MATNR-HIGH.
  WRITE: / 'Dest. File:', LV_FULLFILE.

  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    TRANSFER HD_CSV TO LV_FULLFILE.
    LOOP AT IT_CSV INTO WA_CSV.
      IF SY-SUBRC = 0.
        TRANSFER WA_CSV TO LV_FULLFILE.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


******************************************************new file zpendso **********************************
  PERFORM NEW_FILE.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = GT_FINAL
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*

*lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZUSAPENDSOALL.TXT'.

  CONCATENATE P_FOLDER '\' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZUSPENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    TRANSFER HD_CSV TO LV_FULLFILE.
    LOOP AT IT_CSV INTO WA_CSV.
      IF SY-SUBRC = 0.
        TRANSFER WA_CSV TO LV_FULLFILE.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.




ENDFORM.
