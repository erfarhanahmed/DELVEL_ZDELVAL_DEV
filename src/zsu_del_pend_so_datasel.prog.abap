*ITMTXT*&---------------------------------------------------------------------*
* Include           ZSD_PENDING_SO_DATASEL.
*&---------------------------------------------------------------------*
DATA:
    LS_EXCH_RATE TYPE BAPI1093_0.

START-OF-SELECTION.

  IF OPEN_SO = 'X'.

    SELECT A~VBELN
           A~POSNR
           A~MATNR
           A~ERNAM
           A~ERDAT
           B~LFSTA
           B~LFGSA
           B~FKSTA
           B~ABSTA
           B~GBSTA
    INTO TABLE IT_DATA
    FROM  VBAP AS A
    JOIN  VBUP AS B ON ( B~VBELN = A~VBELN  AND B~POSNR = A~POSNR )
*    JOIN  vbak AS C ON a~vbeln = c~vbeln
    WHERE A~ERDAT  IN S_DATE
*    WHERE C~AUDAT  IN S_DATE
    AND   A~MATNR  IN S_MATNR
    AND   A~VBELN  IN S_VBELN         "SHREYAS
    AND   B~LFSTA  NE 'C'
    AND   B~LFGSA  NE 'C'
    AND   B~FKSTA  NE 'C'
    AND   B~GBSTA  NE 'C'
    AND   A~WERKS  = 'SU01'.


*******ADDED BY SNEHAL RAJALE ON 29 JAN 201************
    LOOP AT IT_DATA INTO LS_DATA.
      IF LS_DATA-ABSTA = 'C'.
        IF LS_DATA-LFSTA = ' ' AND LS_DATA-LFGSA = ' ' AND LS_DATA-FKSTA = ' ' AND LS_DATA-GBSTA = ' '.
          IF SY-SUBRC = 0.
*            delete it_data[] from ls_data.
            DELETE IT_DATA[]  WHERE VBELN = LS_DATA-VBELN AND POSNR = LS_DATA-POSNR.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

*********************
*    lv_vbeln = ls_data-vbeln.
*
*    SELECT objectclas objectid udate tcode FROM cdhdr INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
**        FOR ALL ENTRIES IN it_data
*      WHERE objectclas = 'VERKBELEG'
*      AND objectid = lv_vbeln
*      AND tcode = 'VA02'.
*
*    SORT it_cdhdr BY udate DESCENDING.
***************************

*******************        edited by PJ on 16-08-21
    SELECT MATNR ITEM_TYPE BOM ZPEN_ITEM ZRE_PEN_ITEM FROM MARA
      INTO TABLE IT1_MARA
      FOR ALL ENTRIES IN IT_DATA WHERE MATNR = IT_DATA-MATNR.

*****************        end

*******ENDED BY SNEHAL RAJALE ON 29 JAN 2021************
*        IF sy-subrc = 0.
    IF IT_DATA[] IS NOT INITIAL.
      SELECT VBELN
             ERDAT
             AUART
             LIFSK
             WAERK
             VKBUR
             KNUMV
             VDATU
             BSTDK
             KUNNR
             OBJNR              "added by pankaj 04.02.2022
             BUKRS_VF
             ZLDFROMDATE
             ZLDPERWEEK
             ZLDMAX
*             faksk
             FROM VBAK INTO TABLE IT_VBAK
             FOR ALL ENTRIES IN IT_DATA WHERE VBELN = IT_DATA-VBELN AND
                                              KUNNR IN S_KUNNR
                                              AND ERDAT IN S_DATE
                                              AND VKORG = 'SU00'
                                              AND BUKRS_VF = 'SU00'.
*                                               AND VKBUR = 'SU01' .          " SHREYAS.
*      if it_vbak is not initial.
*        select spras
*               faksp
*               vtext
*          from tvfst into table it_tvfst
*          for all entries in it_vbak
*          where faksp = it_vbak-faksk
*          and spras = 'EN'.
*      endif.

      PERFORM FILL_TABLES.
      PERFORM PROCESS_FOR_OUTPUT.
      IF P_DOWN IS   INITIAL.
        PERFORM ALV_FOR_OUTPUT.

      ELSE.
        PERFORM DOWN_SET.
      ENDIF.

    ENDIF.

  ELSEIF ALL_SO = 'X'.
*******************************
*    lv_vbeln = ls_data-vbeln.
*
*    SELECT objectclas objectid udate tcode FROM cdhdr INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
**        FOR ALL ENTRIES IN it_data
*      WHERE objectclas = 'VERKBELEG'
*      AND objectid = lv_vbeln
*      AND tcode = 'VA02'.
*
*    SORT it_cdhdr BY udate DESCENDING.
*********************************
    SELECT VBELN
           ERDAT
           AUART
           LIFSK
           WAERK
           VKBUR
           KNUMV
           VDATU
           BSTDK
           KUNNR
           OBJNR
           BUKRS_VF
           ZLDFROMDATE
           ZLDPERWEEK
           ZLDMAX
*           faksk
           FROM VBAK INTO TABLE IT_VBAK WHERE ERDAT IN S_DATE AND
                                                VBELN IN S_VBELN AND "shreyas
                                                KUNNR IN S_KUNNR
                                                AND  VKORG = 'SU00'
                                                AND BUKRS_VF = 'SU00'.
    .

    .


*    if it_vbak is not initial.
*      select spras
*             faksp
*             vtext
*        from tvfst into table it_tvfst
*        for all entries in it_vbak
*        where faksp = it_vbak-faksk
*        and spras = 'EN'.
*    endif.

**************************************************************************************
*      select * from vbap INTO TABLE it_vbap FOR ALL ENTRIES IN it_vbak where vbeln = it_vbak-vbeln.
**************************************************************************************
    IF SY-SUBRC = 0.
      PERFORM FILL_TABLES.
      PERFORM PROCESS_FOR_OUTPUT.
      IF P_DOWN IS   INITIAL.
        PERFORM ALV_FOR_OUTPUT.

      ELSE.
*        BREAK Primus.
        PERFORM DOWN_SET_ALL.
      ENDIF.
    ENDIF.

*  ELSE.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FILL_TABLES
*&---------------------------------------------------------------------*

FORM FILL_TABLES .

  IF OPEN_SO = 'X'.
    SELECT VBELN
           POSNR
           MATNR
           ARKTX
           ABGRU
           POSEX
           KDMAT
           WAERK
           KWMENG
           WERKS
           NTGEW                  "added by pankaj 28.01.2022
           OBJNR
           HOLDDATE
           HOLDRELDATE
           CANCELDATE
           DELDATE
           CUSTDELDATE
           ZGAD
           CTBG
           RECEIPT_DATE            "added by pankaj 28.01.2022
           REASON                   "added by pankaj 28.01.2022
           OFM_DATE               "added by pankaj 01.02.2022
           ERDAT
           ERNAM
           FROM VBAP INTO TABLE IT_VBAP
           FOR ALL ENTRIES IN IT_DATA WHERE VBELN = IT_DATA-VBELN
                                       AND POSNR = IT_DATA-POSNR
                                       AND WERKS = 'SU01'
                                       AND MATNR IN S_MATNR
                                       AND ERDAT IN S_DATE..

***************************ADDED BY DH**************
    IF IT_VBAP IS NOT INITIAL.
      LOOP AT IT_VBAP INTO WA_VBAP.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = WA_VBAP-VBELN
          IMPORTING
            OUTPUT = LV_VBELN.

        MOVE-CORRESPONDING WA_VBAP TO WA_VBAP2.
        WA_VBAP2-VBELN = LV_VBELN.
        APPEND WA_VBAP2 TO IT_VBAP2.

      ENDLOOP.

*      CLEAR: lv_vbeln, wa_vbap, wa_vbap2.
    ENDIF.

    LOOP AT IT_VBAP2 INTO WA_VBAP2.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = WA_VBAP2-VBELN
        IMPORTING
          OUTPUT = LV_VBELN2.

      WA_VBAP2-VBELN = LV_VBELN2.
      MODIFY IT_VBAP2 FROM WA_VBAP2.
    ENDLOOP.

    IF IT_VBAP2 IS NOT INITIAL.

      SELECT OBJECTCLAS OBJECTID UDATE TCODE FROM CDHDR INTO CORRESPONDING FIELDS OF TABLE IT_CDHDR
       FOR ALL ENTRIES IN IT_VBAP2
     WHERE OBJECTCLAS = 'VERKBELEG'
     AND OBJECTID = IT_VBAP2-VBELN             "it_vbap-vbeln
      AND TCODE = 'VA02'.
    ENDIF.

    SORT IT_CDHDR BY UDATE DESCENDING.
*******************************************

*******************        edited by PJ on 16-08-21
    SELECT MATNR ITEM_TYPE BOM ZPEN_ITEM ZRE_PEN_ITEM FROM MARA
      INTO TABLE IT1_MARA
      FOR ALL ENTRIES IN IT_VBAP WHERE MATNR = IT_VBAP-MATNR.

*****************        end


**************** Reject Service Sale Order Remove From Pending So(Radio Button)
    LOOP AT IT_VBAK INTO WA_VBAK WHERE AUART = 'SU09' OR AUART = 'SU10'.
      LOOP AT IT_VBAP INTO WA_VBAP WHERE VBELN = WA_VBAK-VBELN AND ABGRU NE ' '.
        DELETE IT_VBAP WHERE VBELN = WA_VBAP-VBELN AND POSNR = WA_VBAP-POSNR.
      ENDLOOP.
    ENDLOOP.
**************************************************************************



  ELSE.
    SELECT VBELN
           POSNR
           MATNR
           ARKTX
           ABGRU
           POSEX
           KDMAT
           WAERK
           KWMENG
           WERKS
           NTGEW                "added by pankaj 28.01.2022
           OBJNR
           HOLDDATE
           HOLDRELDATE
           CANCELDATE
           DELDATE
           CUSTDELDATE
           ZGAD
           CTBG
           RECEIPT_DATE            "added by pankaj 28.01.2022
           REASON                   "added by pankaj 28.01.2022
           OFM_DATE
           ERDAT
           ERNAM
           FROM VBAP INTO TABLE IT_VBAP
           FOR ALL ENTRIES IN IT_VBAK WHERE VBELN = IT_VBAK-VBELN
                                        AND WERKS = 'SU01'
                                        AND  MATNR IN S_MATNR.
  ENDIF.
  IF IT_VBAP[] IS NOT INITIAL.

*****************************ADDED BY DH************
*    lv_vbeln = wa_vbap-vbeln.
    IF IT_VBAP IS NOT INITIAL.
      LOOP AT IT_VBAP INTO WA_VBAP.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = WA_VBAP-VBELN
          IMPORTING
            OUTPUT = LV_VBELN.

        MOVE-CORRESPONDING WA_VBAP TO WA_VBAP2.
        WA_VBAP2-VBELN = LV_VBELN.
        APPEND WA_VBAP2 TO IT_VBAP2.

      ENDLOOP.
*      CLEAR: lv_vbeln, wa_vbap, wa_vbap2.
    ENDIF.

    LOOP AT IT_VBAP2 INTO WA_VBAP2.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = WA_VBAP2-VBELN
        IMPORTING
          OUTPUT = LV_VBELN2.

      WA_VBAP2-VBELN = LV_VBELN2.
      MODIFY IT_VBAP2 FROM WA_VBAP2.
    ENDLOOP.

    IF IT_VBAP2 IS NOT INITIAL.

      SELECT OBJECTCLAS OBJECTID UDATE TCODE FROM CDHDR INTO CORRESPONDING FIELDS OF TABLE IT_CDHDR
       FOR ALL ENTRIES IN IT_VBAP2
     WHERE OBJECTCLAS = 'VERKBELEG'
     AND OBJECTID = IT_VBAP2-VBELN             "it_vbap-vbeln
      AND TCODE = 'VA02'.
    ENDIF.

    SORT IT_CDHDR BY UDATE DESCENDING.

*********************************************
*******************        edited by PJ on 16-08-21
    SELECT MATNR ITEM_TYPE BOM ZPEN_ITEM ZRE_PEN_ITEM FROM MARA
      INTO TABLE IT1_MARA
      FOR ALL ENTRIES IN IT_VBAP WHERE MATNR = IT_VBAP-MATNR.

*****************        end
    SELECT VBELN
           POSNR
           PARVW
           KUNNR
           ADRNR
           LAND1
           FROM VBPA INTO TABLE LT_VBPA
           FOR ALL ENTRIES IN IT_VBAP WHERE VBELN = IT_VBAP-VBELN.
*                                     AND  posnr = it_vbap-posnr.

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
           KTGRD       "added by 04.02.2022
           KURSK
           BSTKD
           PRSDT
           FROM VBKD INTO TABLE IT_VBKD
           FOR ALL ENTRIES IN IT_VBAP
           WHERE VBELN = IT_VBAP-VBELN.

    IF IT_VBKD IS NOT INITIAL.
      SELECT SPRAS
             ZTERM
             TEXT1
             FROM T052U INTO TABLE IT_T052U
             FOR ALL ENTRIES IN IT_VBKD
             WHERE SPRAS = 'EN'
             AND ZTERM = IT_VBKD-ZTERM.
    ENDIF.


*BREAK primus.
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

    IF IT_VBAK IS NOT INITIAL.

      SELECT KNUMV
             KPOSN
             KSCHL
             KBETR
             WAERS
             KWERT
             FROM PRCD_ELEMENTS INTO TABLE IT_KONV
             FOR ALL ENTRIES IN IT_VBAK
             WHERE KNUMV = IT_VBAK-KNUMV
             AND KSCHL IN S_KSCHL.

      SELECT KNUMV
             KPOSN
             KSCHL
             KBETR
             WAERS
             KWERT
             FROM PRCD_ELEMENTS INTO TABLE IT_KONV1
*             FROM konv INTO TABLE it_konv1
             FOR ALL ENTRIES IN IT_VBAK
             WHERE KNUMV = IT_VBAK-KNUMV.


      SELECT VBELV
             POSNV
             VBELN
             VBTYP_N
             FROM VBFA INTO TABLE IT_VBFA
             FOR ALL ENTRIES IN IT_VBAK
             WHERE VBELV = IT_VBAK-VBELN
               AND ( VBTYP_N = 'J' OR  VBTYP_N = 'M' ).
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
    IF IT_VBAP IS NOT INITIAL.
      SELECT * FROM JEST INTO TABLE IT_JEST FOR ALL ENTRIES IN IT_VBAP WHERE OBJNR = IT_VBAP-OBJNR
                                                                         AND STAT IN S_STAT
                                                                         AND INACT NE 'X'.
    ENDIF.
    IF IT_JEST IS NOT INITIAL.
      SELECT * FROM TJ30 INTO TABLE IT_TJ30T FOR ALL ENTRIES IN IT_JEST WHERE ESTAT = IT_JEST-STAT
                                                                         AND STSMA  = 'OR_ITEM'.
    ENDIF.


    SELECT AUFNR
           POSNR
           KDAUF
           KDPOS
           MATNR
           PGMNG
           PSMNG
           WEMNG
      FROM AFPO
      INTO TABLE IT_AFPO
      FOR ALL ENTRIES IN IT_VBAP
      WHERE KDAUF = IT_VBAP-VBELN
        AND KDPOS = IT_VBAP-POSNR .
    IF SY-SUBRC = 0.

      SELECT AUFNR
             OBJNR
             KDAUF
             KDPOS
             IGMNG
        FROM CAUFV
        INTO TABLE IT_CAUFV
        FOR ALL ENTRIES IN IT_AFPO
        WHERE AUFNR = IT_AFPO-AUFNR
        AND   KDAUF = IT_AFPO-KDAUF
        AND   KDPOS = IT_AFPO-KDPOS
        AND   LOEKZ = SPACE.

    ENDIF.
    """""""""""""""   END 05.05.2017         """"""""""""""""""""""""""

    SELECT VBELN
           POSNR
           ZIBR
           ZUL
           ZSL
           ZCE
           ZAPI6D
           ZAPI60
           ZATEX
           ZTRCU
           ZCRN
           ZMARINE
      FROM VBAP
      INTO TABLE IT_VBAP1
      FOR ALL ENTRIES IN IT_VBAP
      WHERE VBELN = IT_VBAP-VBELN AND
            POSNR = IT_VBAP-POSNR.

  ENDIF.

  IF LT_VBPA IS NOT INITIAL.

    SELECT * FROM ADRC INTO TABLE LT_ADRC FOR ALL ENTRIES IN LT_VBPA WHERE ADDRNUMBER = LT_VBPA-ADRNR." AND country = 'IN'.
    IF LT_ADRC IS NOT INITIAL.
      FIELD-SYMBOLS : <F1> TYPE ZGST_REGION.

      SELECT * FROM ZGST_REGION INTO TABLE LT_ZGST_REGION ."FOR ALL ENTRIES IN lt_adrc WHERE region = lt_adrc-region.
      LOOP AT LT_ZGST_REGION ASSIGNING <F1>.
        DATA(LV_STR_L) =  STRLEN( <F1>-REGION ).
        IF LV_STR_L = 1.
          CONCATENATE '0' <F1>-REGION INTO <F1>-REGION.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDIF.

  SELECT KUNNR
         NAME1
         ADRNR
         FROM KNA1 INTO TABLE IT_KNA1
         FOR ALL ENTRIES IN IT_VBAK
         WHERE KUNNR = IT_VBAK-KUNNR.

  """"""""" code added by pankaj 04.02.2022""""""""""""""

  IF IT_VBKD IS NOT INITIAL.

    SELECT KTGRD
           VTEXT FROM TVKTT INTO TABLE IT_TVKTT FOR ALL ENTRIES IN IT_VBKD WHERE KTGRD = IT_VBKD-KTGRD
                                                                           AND SPRAS = 'EN'.

  ENDIF.

*BREAK primus.
  IF  IT_VBAK IS NOT INITIAL.

    SELECT OBJNR
           STAT
           INACT FROM JEST INTO TABLE IT_JEST3 FOR ALL ENTRIES IN IT_VBAK WHERE OBJNR = IT_VBAK-OBJNR AND INACT = ' '.
  ENDIF.

  IF IT_JEST3 IS NOT INITIAL.

    SELECT STSMA
           ESTAT
           TXT04 FROM TJ30T INTO TABLE IT_TJ30 FOR ALL ENTRIES IN IT_JEST3 WHERE ESTAT = IT_JEST3-STAT AND STSMA = 'OR_HEADR'.

  ENDIF.


  """""""""""""""""""""""""""""""" ended""""""""""""""""""""""""""""


ENDFORM.                    " FILL_TABLES
*&---------------------------------------------------------------------*
*&      Form  PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*

FORM PROCESS_FOR_OUTPUT .
  DATA:
    LV_RATIO TYPE RESB-ENMNG,
    LV_QTY   TYPE RESB-ENMNG,
    LV_INDEX TYPE SY-TABIX.

  IF IT_VBAP[] IS NOT INITIAL.
    CLEAR: WA_VBAP, WA_VBAK, WA_VBEP, WA_MSKA,
           WA_VBRP, WA_KONV, WA_KNA1,WA_VBAP1.
    SORT IT_VBAP BY VBELN POSNR MATNR WERKS.
    SORT IT_MSKA BY VBELN POSNR MATNR WERKS.
    SORT IT_AFPO BY KDAUF KDPOS MATNR.
    SORT LT_RESB BY AUFNR KDAUF KDPOS.

    LOOP AT IT_VBAP INTO WA_VBAP.

**********ADDED BY DH ****************
      READ TABLE IT_VBAP2 INTO WA_VBAP2 WITH KEY VBELN = WA_VBAP-VBELN.
      READ TABLE IT_CDHDR INTO WA_CDHDR WITH KEY OBJECTCLAS = 'VERKBELEG' OBJECTID = WA_VBAP2-VBELN TCODE = 'VA02'.
      WA_OUTPUT-UDATE = WA_CDHDR-UDATE.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-UDATE
        IMPORTING
          OUTPUT = WA_OUTPUT-UDATE.

      CONCATENATE WA_OUTPUT-UDATE+0(2) WA_OUTPUT-UDATE+2(3) WA_OUTPUT-UDATE+5(4)
                      INTO WA_OUTPUT-UDATE SEPARATED BY '-'.

      IF WA_OUTPUT-UDATE = '--'.
        REPLACE ALL OCCURRENCES OF '--' IN WA_OUTPUT-UDATE WITH ' '.
      ENDIF.

***************************************
*********************      modified by PJ on 16-08-21
      READ TABLE IT1_MARA INTO WA1_MARA WITH KEY MATNR = WA_VBAP-MATNR.
      IF SY-SUBRC = 0.

        WA_OUTPUT-ITEM_TYPE    = WA1_MARA-ITEM_TYPE.
        WA_OUTPUT-BOM    = WA1_MARA-BOM.
        WA_OUTPUT-ZPEN_ITEM    = WA1_MARA-ZPEN_ITEM.
        WA_OUTPUT-ZRE_PEN_ITEM    = WA1_MARA-ZRE_PEN_ITEM.

      ENDIF.
****************************      end

      WA_OUTPUT-HOLDDATE    = WA_VBAP-HOLDDATE.        "Statsu
      WA_OUTPUT-RELDATE     = WA_VBAP-HOLDRELDATE.     "Release date
      WA_OUTPUT-CANCELDATE  = WA_VBAP-CANCELDATE.      "Cancel date
      WA_OUTPUT-DELDATE     = WA_VBAP-DELDATE.         "delivary date
      WA_OUTPUT-CUSTDELDATE = WA_VBAP-CUSTDELDATE.         "customer del. date
      WA_OUTPUT-POSEX       = WA_VBAP-POSEX.
      WA_OUTPUT-MATNR       = WA_VBAP-MATNR.           "Material
      WA_OUTPUT-POSNR       = WA_VBAP-POSNR.           "item
      WA_OUTPUT-ARKTX       = WA_VBAP-ARKTX.           "item short description
      WA_OUTPUT-KWMENG      = WA_VBAP-KWMENG.          "sales order qty
      WA_OUTPUT-WERKS       = WA_VBAP-WERKS.           "PLANT
      WA_OUTPUT-WAERK       = WA_VBAP-WAERK.           "Currency
      WA_OUTPUT-KDMAT       = WA_VBAP-KDMAT.
      WA_OUTPUT-VBELN       = WA_VBAP-VBELN.           "Sales Order

      WA_OUTPUT-ERNAM       = WA_VBAP-ERNAM.           ""Change by pranit 27.03.2024
      WA_OUTPUT-ERDAT1      = WA_VBAP-ERDAT.          ""Change by pranit 27.03.2024

      WA_OUTPUT-PO_DEL_DATE = WA_VBAP-CUSTDELDATE.

      IF WA_VBAP-ZGAD = '1'.
        WA_OUTPUT-GAD = 'Reference'.
      ELSEIF WA_VBAP-ZGAD = '2'.
        WA_OUTPUT-GAD = 'Approved'.
      ELSEIF WA_VBAP-ZGAD = '3'.
        WA_OUTPUT-GAD = 'Standard'.
      ENDIF.

      WA_OUTPUT-CTBG       = WA_VBAP-CTBG.               " added by ajay

      """"""""" code added by pankaj 28.01.2022""""""""""""""""""

      WA_OUTPUT-RECEIPT_DATE       = WA_VBAP-RECEIPT_DATE.               " added by pankaj 30.12.2021

      IF WA_VBAP-REASON = '1'.
        WA_OUTPUT-REASON = 'Hold'.
      ELSEIF
        WA_VBAP-REASON = '2'.
        WA_OUTPUT-REASON = 'Cancel'.
      ELSEIF
        WA_VBAP-REASON = '3'.
        WA_OUTPUT-REASON = 'QTY Change'.
      ELSEIF
        WA_VBAP-REASON = '4'.
        WA_OUTPUT-REASON = 'Quality Change'.
      ELSEIF
        WA_VBAP-REASON = '5'.
        WA_OUTPUT-REASON = 'Technical Changes'.

      ELSEIF
        WA_VBAP-REASON = '6'.
        WA_OUTPUT-REASON = 'New Line'.
      ENDIF.

      WA_OUTPUT-NTGEW           = WA_VBAP-NTGEW.
      WA_OUTPUT-OFM_DATE1       = WA_VBAP-OFM_DATE.
*      break primus.              "added by pankaj 01.02.2022
      IF  WA_OUTPUT-OFM_DATE1 NE '00000000'.
        WA_OUTPUT-OFM_DATE1 = WA_OUTPUT-OFM_DATE1.
      ELSE.
        WA_OUTPUT-OFM_DATE1 = SPACE.
      ENDIF.
      WA_OUTPUT-CHANG_SO_DATE = WA_VBAP-ERDAT.
      """""""" code ended""""""""""""""""""""""""""""""'

      READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_OUTPUT-VBELN.
      IF SY-SUBRC = 0.
        WA_OUTPUT-AUART        = WA_VBAK-AUART.           "ORDER TYPE
        WA_OUTPUT-VKBUR        = WA_VBAK-VKBUR.           "Sales Office
        WA_OUTPUT-ERDAT        = WA_VBAK-ERDAT.           "Sales Order date
        WA_OUTPUT-VDATU        = WA_VBAK-VDATU.           "Req del date
        WA_OUTPUT-BSTDK        = WA_VBAK-BSTDK.
        WA_OUTPUT-LIFSK        = WA_VBAK-LIFSK.
        WA_OUTPUT-ZLDPERWEEK   = WA_VBAK-ZLDPERWEEK.  "LD per week
        WA_OUTPUT-ZLDMAX       = WA_VBAK-ZLDMAX.      "LD Max
        WA_OUTPUT-ZLDFROMDATE  = WA_VBAK-ZLDFROMDATE. "LD from date
        WA_OUTPUT-KUNNR        = WA_VBAK-KUNNR.
*        wa_output-faksk        = wa_vbak-faksk.

      ENDIF.

*      read table it_tvfst into wa_tvfst with key faksp = wa_vbak-faksk spras = 'EN'.
*      if sy-subrc = 0.
*        wa_output-vtext1 = wa_tvfst-vtext.
*      endif.

      """"""""" code added by pankaj 28.01.2021"""""""""""""""""""""""""
      DATA: LV_KNOV_VALUE TYPE P DECIMALS 2.
      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'ZPR0'  KPOSN = WA_VBAP-POSNR.
      IF SY-SUBRC = 0.
        CLEAR: LV_KNOV_VALUE.
        LV_KNOV_VALUE = WA_KONV1-KBETR.
        WA_OUTPUT-ZPR0 = LV_KNOV_VALUE.
      ENDIF.
      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'ZPFO'  KPOSN = WA_VBAP-POSNR.
      IF SY-SUBRC = 0.
        CLEAR: LV_KNOV_VALUE.
        LV_KNOV_VALUE = WA_KONV1-KWERT.
        WA_OUTPUT-ZPF0 = LV_KNOV_VALUE.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV KSCHL = 'ZIN1' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        CLEAR: LV_KNOV_VALUE.
        LV_KNOV_VALUE = WA_KONV1-KWERT.
        WA_OUTPUT-ZIN1 = LV_KNOV_VALUE.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV KSCHL = 'K005' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        CLEAR: LV_KNOV_VALUE.
        LV_KNOV_VALUE = WA_KONV1-KWERT.
        WA_OUTPUT-K005 = LV_KNOV_VALUE.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'K007' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        CLEAR: LV_KNOV_VALUE.
        LV_KNOV_VALUE = WA_KONV1-KWERT.
        WA_OUTPUT-K007 = LV_KNOV_VALUE.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'ZDC1' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        CLEAR: LV_KNOV_VALUE.
        LV_KNOV_VALUE = WA_KONV1-KWERT.
        WA_OUTPUT-ZDC1 = LV_KNOV_VALUE.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'ZFR1' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        CLEAR: LV_KNOV_VALUE.
        LV_KNOV_VALUE = WA_KONV1-KWERT.
        WA_OUTPUT-ZFR1 = LV_KNOV_VALUE.
      ENDIF.
      CONDENSE: WA_OUTPUT-ZPR0,WA_OUTPUT-ZPF0, WA_OUTPUT-ZIN1,WA_OUTPUT-K005,WA_OUTPUT-K007, WA_OUTPUT-ZDC1,WA_OUTPUT-ZFR1.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'ZTE1' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        CLEAR: LV_KNOV_VALUE.
        LV_KNOV_VALUE = WA_KONV1-KWERT.
        WA_OUTPUT-ZTE1 = LV_KNOV_VALUE.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'MWAS' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        CLEAR: LV_KNOV_VALUE.
        LV_KNOV_VALUE = WA_KONV1-KWERT.
        WA_OUTPUT-MWAS  = LV_KNOV_VALUE.
      ENDIF.
      """"""""""""" code ended""""""""""""""""""""""""""""""""""""

      READ TABLE IT_VBEP INTO WA_VBEP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR
                                               ETENR = '0001'.
      IF SY-SUBRC = 0.
        WA_OUTPUT-ETTYP       = WA_VBEP-ETTYP.           "So Status
        WA_OUTPUT-EDATU       = WA_VBEP-EDATU.           "delivary Date
        WA_OUTPUT-ETENR       = WA_VBEP-ETENR.           "Schedule line no.
        "wa_output-date        = wa_vbep-date.
      ENDIF.
      READ TABLE IT_VBEP INTO WA_VBEP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR
                                               ETENR = '0001'.
      IF SY-SUBRC = 0.
        WA_OUTPUT-DATE       = WA_VBEP-EDATU.

      ENDIF.
      READ TABLE LT_VBEP INTO LS_VBEP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR
                                               ETENR = '0001'
                                               ETTYP = 'CP'.

      READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_OUTPUT-VBELN.

*                                               posnr = wa_vbap-posnr.
      IF SY-SUBRC = 0.
        WA_OUTPUT-SO_EXC      = WA_VBKD-KURSK.           "SO Exchange Rate
        WA_OUTPUT-BSTKD       = WA_VBKD-BSTKD.           "Cust Ref No.
        WA_OUTPUT-ZTERM       = WA_VBKD-ZTERM.           "payment terms
        WA_OUTPUT-INCO1       = WA_VBKD-INCO1.           "inco terms
        WA_OUTPUT-INCO2       = WA_VBKD-INCO2.           "inco terms description
        WA_OUTPUT-PRSDT       = WA_VBKD-PRSDT.

      ENDIF.

      CLEAR WA_KNA1.
      READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_OUTPUT-KUNNR.
      IF SY-SUBRC = 0.
        WA_OUTPUT-NAME1       = WA_KNA1-NAME1.           "Cust Name
      ENDIF.


      READ TABLE IT_T052U INTO WA_T052U WITH KEY ZTERM = WA_OUTPUT-ZTERM.
      IF SY-SUBRC = 0.
        WA_OUTPUT-TEXT1       = WA_T052U-TEXT1.          "payment terms description
      ENDIF.
*      BREAK primus.
      READ TABLE IT_VBAP1 INTO WA_VBAP1 WITH KEY VBELN = WA_OUTPUT-VBELN
                                                 POSNR = WA_OUTPUT-POSNR.
      IF SY-SUBRC = 0.

        IF WA_VBAP1-ZIBR = 'X'.
          CERTIF_ZIBR = 'IBR'.
*          CONCATENATE quote certif_zibr quote INTO certif_zibr.
          CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZIBR INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
        ENDIF.

        IF WA_VBAP1-ZUL = 'X'.
          CERTIF_ZUL = 'UL'.
*          CONCATENATE quote certif_zul quote INTO certif_zul.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZUL INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZUL INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZSL = 'X'.
          CERTIF_ZSL = 'SIL3'.
*           CONCATENATE quote certif_zsl quote INTO certif_zsl.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZSL INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZSL INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZCE = 'X'.
          CERTIF_ZCE = 'CE'.
*          CONCATENATE quote certif_zce quote INTO certif_zce.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZCE INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZCE INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZAPI6D = 'X'.
          CERTIF_ZAPI6D = 'API 6D'.
*          CONCATENATE quote certif_zapi6d quote INTO certif_zapi6d.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZAPI6D INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZAPI6D INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZAPI60 = 'X'.
          CERTIF_ZAPI60 = 'API 609'.
*          CONCATENATE quote certif_zapi60 quote INTO certif_zapi60.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZAPI60 INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZAPI60 INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZATEX = 'X'.
          CERTIF_ZATEX = 'ATEX'.
*          CONCATENATE quote certif_zatex quote INTO certif_zatex.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZATEX INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZATEX INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZTRCU = 'X'.
          CERTIF_ZTRCU = 'TRCU'.
*          CONCATENATE quote certif_ztrcu quote INTO certif_ztrcu.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZTRCU INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZTRCU INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZCRN = 'X'.
          CERTIF_ZCRN = 'CRN'.
*          CONCATENATE quote certif_zcrn quote INTO certif_zcrn.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZCRN INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZCRN INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZMARINE = 'X'.
          CERTIF_ZMARINE = 'MARINE'.
*          CONCATENATE quote certif_zmarine quote INTO certif_zmarine.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZMARINE INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZMARINE INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        CLEAR : CERTIF_ZIBR, CERTIF_ZUL, CERTIF_ZSL, CERTIF_ZCE, CERTIF_ZAPI6D, CERTIF_ZAPI60, CERTIF_ZATEX , CERTIF_ZTRCU, CERTIF_ZCRN, CERTIF_ZMARINE.

      ENDIF.

      READ TABLE IT_VBRP INTO WA_VBRP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR.
**TPI TEXT

      CLEAR: LV_LINES, WA_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z999'
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
          ID                      = 'Z038'
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
          ID                      = 'Z039'
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

*********OFM SR. NO.
*      CLEAR: lv_lines, wa_ofm_no.
*      REFRESH lv_lines.
*      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
*
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = 'Z102'
*          language                = sy-langu
*          name                    = lv_name
*          object                  = 'VBBP'
*        TABLES
*          lines                   = lv_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*
*      READ TABLE lv_lines INTO wa_ofm_no INDEX 1.
*
*      IF lv_lines IS NOT INITIAL.
*        LOOP AT lv_lines INTO wa_ofm_no.
*          IF wa_ofm_no-tdline IS NOT INITIAL.
*            CLEAR wa_text.
*            wa_text = wa_ofm_no-tdline(20).     "ofm sr no
*            TRANSLATE wa_text TO UPPER CASE .
*            wa_output-ofm_no         = wa_text.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.

********************ADDED BY SHREYA*******************
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z102'
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
      READ TABLE LV_LINES INTO LS_CTBGI INDEX 1.

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_CTBGI.
          IF LS_CTBGI-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-OFM_NO LS_CTBGI-TDLINE INTO WA_OUTPUT-OFM_NO SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.


*konv data
      CLEAR: WA_KONV1." WA_OUTPUT.

*      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV KPOSN = WA_OUTPUT-POSNR KSCHL = 'JOCG'.
*      IF SY-SUBRC = 0.
*        CLEAR : LV_CGST,LV_CGST_TEMP.
*        LV_CGST =  WA_KONV1-KBETR / 10.
*        LV_CGST_TEMP = LV_CGST.
*        CONDENSE LV_CGST_TEMP.
*        WA_OUTPUT-CGST = LV_CGST_TEMP.
*
**        wa_output-cgst_val = wa_konv1-kwert.
*
*        WA_OUTPUT-SGST = LV_CGST_TEMP.
**        wa_output-sgst_val = wa_konv1-kwert.
*      ENDIF.
*      CLEAR: WA_KONV1.
*      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV KPOSN = WA_OUTPUT-POSNR KSCHL = 'JOIG'.
*      IF SY-SUBRC = 0.
*        CLEAR : LV_CGST,LV_CGST_TEMP.
*        LV_CGST =  WA_KONV1-KBETR / 10.
*        LV_CGST_TEMP = LV_CGST.
*        WA_OUTPUT-IGST = LV_CGST_TEMP.
**        wa_output-igst_val = wa_konv1-kwert.
*      ENDIF.

*      CLEAR: WA_KONV1.
*      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV KPOSN = WA_VBAP-POSNR KSCHL = 'JTC1'.
*      IF SY-SUBRC = 0.
*        WA_OUTPUT-TCS = WA_KONV1-KBETR / 10.
*        WA_OUTPUT-TCS_AMT = WA_KONV1-KWERT.
*      ENDIF.

      CLEAR: WA_KONV.

      SELECT SINGLE KNUMV
                    KPOSN
                    KSCHL
                    KBETR
                    WAERS
                    KWERT
                    FROM PRCD_ELEMENTS INTO WA_KONV WHERE  KNUMV = WA_VBAK-KNUMV
                                             AND   KPOSN = WA_OUTPUT-POSNR
                                             AND   KSCHL = 'ZPR0'.
      WA_OUTPUT-KBETR       = WA_KONV-KBETR.           "Rate

*Commented by Dhanashree because this field shows in downloaded excel
      WA_OUTPUT-KWERT       = WA_KONV-KWERT.  "ADDED BY SHREYA 12-04-2022

      CLEAR: WA_KONV .
      SELECT SINGLE KNUMV
                    KPOSN
                    KSCHL
                    KBETR
                    WAERS
                    KWERT
                    FROM PRCD_ELEMENTS INTO WA_KONV WHERE KNUMV = WA_VBAK-KNUMV
                                             AND   KPOSN = WA_OUTPUT-POSNR
                                             AND   KSCHL = 'VPRS'.
      IF WA_VBAP-WAERK <> 'INR'.
        IF WA_KONV-WAERS <> 'INR'.
          WA_KONV-KBETR = WA_KONV-KBETR * WA_VBKD-KURSK.
        ENDIF.
      ENDIF.

      WA_OUTPUT-IN_PRICE    = WA_KONV-KBETR.           "Internal Price

      CLEAR: WA_KONV .

      SELECT SINGLE KNUMV
                    KPOSN
                    KSCHL
                    KBETR
                    WAERS
                    KWERT
                    FROM PRCD_ELEMENTS INTO WA_KONV WHERE KNUMV = WA_VBAK-KNUMV
                                             AND   KPOSN = WA_OUTPUT-POSNR
                                             AND  KSCHL = 'ZESC'.
      IF WA_VBAP-WAERK <> 'INR'.
        IF WA_KONV-WAERS <> 'INR'.
          WA_KONV-KBETR = WA_KONV-KBETR * WA_VBKD-KURSK.
        ENDIF.
      ENDIF.

      WA_OUTPUT-EST_COST    = WA_KONV-KBETR.           "Estimated cost


      CLEAR WA_JEST1.
      READ TABLE IT_JEST INTO WA_JEST1 WITH KEY OBJNR = WA_VBAP-OBJNR.

      SELECT SINGLE * FROM TJ30T INTO WA_TJ30T  WHERE ESTAT = WA_JEST1-STAT
                                                AND STSMA  = 'OR_ITEM'
                                                AND SPRAS  = 'EN'.
      IF SY-SUBRC = 0.
        WA_OUTPUT-STATUS      = WA_TJ30T-TXT30.          "Hold/Unhold
      ENDIF.

      CLEAR : WA_MSKA.


      LOOP AT IT_MSKA INTO WA_MSKA WHERE VBELN = WA_OUTPUT-VBELN AND
                                         POSNR = WA_OUTPUT-POSNR AND
                                         MATNR = WA_OUTPUT-MATNR AND
                                         WERKS = WA_OUTPUT-WERKS.

        CASE WA_MSKA-LGORT.
          WHEN 'SUFG'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SUTP'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SUPR'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SURM'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SURW'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SUSC'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SUAD'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
*          WHEN 'SPC1'.
*            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
*          WHEN 'SRN1'.
*            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
*          WHEN 'VLD1'.
*            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
*          WHEN 'SLR1'.
*            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
        ENDCASE.

      ENDLOOP.

*DELIVARY QTY
      CLEAR: WA_VBFA, WA_LFIMG, WA_LFIMG_SUM.
      LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_OUTPUT-VBELN
                                   AND POSNV = WA_OUTPUT-POSNR
                                   AND VBTYP_N = 'J'.

        CLEAR WA_LFIMG.
        SELECT SINGLE LFIMG FROM LIPS INTO  WA_LFIMG  WHERE VBELN = WA_VBFA-VBELN
*                                                      AND   PSTYV = 'ZTAN'
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

        CLEAR WA_FKIMG.
        SELECT SINGLE FKIMG FROM VBRP INTO  WA_FKIMG  WHERE VBELN = WA_VBRK-VBELN
                                                      AND   AUBEL = WA_OUTPUT-VBELN
                                                      AND   AUPOS = WA_OUTPUT-POSNR.
        WA_FKIMG_SUM = WA_FKIMG_SUM + WA_FKIMG .
      ENDLOOP.

****
      CLEAR WA_MBEW.
      SELECT SINGLE * FROM MBEW INTO WA_MBEW WHERE MATNR = WA_OUTPUT-MATNR
                                               AND BWKEY = WA_OUTPUT-WERKS.

      CLEAR WA_MARA.
      SELECT SINGLE * FROM MARA INTO WA_MARA WHERE MATNR = WA_OUTPUT-MATNR.

      """"""""""     Added By KD on 04.05.2017    """""""""""
      SELECT SINGLE DISPO FROM MARC INTO WA_OUTPUT-DISPO WHERE MATNR = WA_OUTPUT-MATNR.
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

        CALL FUNCTION 'BAPI_EXCHRATE_GETCURRENTRATES'
          EXPORTING
            DATE             = SY-DATUM
            DATE_TYPE        = 'V'
            RATE_TYPE        = 'B'
          TABLES
            FROM_CURR_RANGE  = LS_FR_CURR
            TO_CURRNCY_RANGE = LS_TO_CURR
            EXCH_RATE_LIST   = LS_EX_RATE
            RETURN           = LS_RETURN.

        CLEAR LV_EX_RATE.
        READ TABLE LS_EX_RATE INTO LV_EX_RATE INDEX 1.
      ELSE.
        LV_EX_RATE-EXCH_RATE = 1.
      ENDIF.

*Latest Estimated cost
      REFRESH: IT_KONH.
      CLEAR:   IT_KONH.

*  FOR ZESC
      SELECT * FROM KONH INTO TABLE IT_KONH WHERE KOTABNR = '508'
                                              AND KSCHL  = 'ZESC'
                                              AND KNUMH  = WA_OUTPUT-MATNR
                                              AND DATAB <= SY-DATUM
                                              AND DATBI >= SY-DATUM .
      SORT  IT_KONH DESCENDING BY KNUMH .
      CLEAR WA_KONH.
      READ TABLE IT_KONH INTO WA_KONH INDEX 1.

      CLEAR WA_KONP.
      SELECT SINGLE * FROM KONP INTO WA_KONP WHERE KNUMH = WA_KONH-KNUMH
                                              AND KSCHL  = 'ZESC'.

      CLEAR WA_CDPOS.
      DATA TABKEY TYPE CDPOS-TABKEY.
      CONCATENATE SY-MANDT WA_VBEP-VBELN WA_VBEP-POSNR WA_VBEP-ETENR INTO TABKEY.
*--Original Code
********PJ on 01-10-21*********************************************

*     ******We dont want this code for PendinG so and all To reduce TimING OF EXECUTION OF THE PROGRAM
*            for MRP Date As disscussion with Parag and Joshi Sir.
      IF OPEN_SO = 'X' AND ALL_SO NE 'X'. "Added By Nilay B. On 06.09.2023
*      IF .                     "commented by pankaj 05.10.2021
        SELECT * FROM CDPOS INTO TABLE IT_CDPOS WHERE TABKEY = TABKEY

**                                               AND value_new = 'CP'
**                                               AND value_old = 'CN'
                                                 AND TABNAME = 'VBEP' AND FNAME = 'ETTYP'.
*--End Original
*--Start change by CRC
        DATA : R_OBJECTCLAS TYPE RANGE OF CDPOS-OBJECTCLAS.

        SELECT *
      FROM CDPOS INTO TABLE IT_CDPOS
      WHERE OBJECTCLAS IN R_OBJECTCLAS
      AND   TABKEY  = TABKEY
      AND   TABNAME = 'VBEP'
      AND   FNAME   = 'ETTYP'.
*-- End Change
        SORT IT_CDPOS BY CHANGENR DESCENDING.
        READ TABLE IT_CDPOS INTO WA_CDPOS INDEX 1.
        IF WA_CDPOS-VALUE_NEW = 'CP' .
          SELECT SINGLE * FROM CDHDR INTO WA_CDHDR WHERE CHANGENR = WA_CDPOS-CHANGENR.

          WA_OUTPUT-MRP_DT      = WA_CDHDR-UDATE.           "MRP date EDATU to TDDAT changed by Pranav Khadatkar

        ENDIF.
        CLEAR WA_CDHDR.

*      ENDIF.                      "commented by pankaj 05.10.2021
      ENDIF.                       "Added By Nilay B. On 06.09.2023
*     ******We dont want this code for Pendind so and all To reduce Timn for MRP Date As disscussion with Parag and Joshi Sir.
**********end****************************
      CLEAR WA_TVAGT.
      SELECT SINGLE SPRAS
                    ABGRU
                    BEZEI
                    FROM TVAGT INTO  WA_TVAGT
                    WHERE ABGRU = WA_VBAP-ABGRU AND SPRAS = 'E'.

*Sales text
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

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_ITMTXT.
          IF LS_ITMTXT-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-ITMTXT LS_ITMTXT-TDLINE INTO WA_OUTPUT-ITMTXT SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
*wa_output-itmtxt = ls_itmtxt-tdline.

*********CTBG Item Details     "added by SR on 03.05.2021

      CLEAR: LV_LINES, LS_CTBGI,LV_NAME.
      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z061'
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
      READ TABLE LV_LINES INTO LS_CTBGI INDEX 1.

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_CTBGI.
          IF LS_CTBGI-TDLINE IS NOT INITIAL.
*            CONCATENATE wa_output-ctbgi ls_ctbgi-tdline INTO wa_output-ctbgi SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.
*************
********Insurance
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z017'
          LANGUAGE                = SY-LANGU
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
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_ITMTXT.
          IF LS_ITMTXT-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-INSUR LS_ITMTXT-TDLINE INTO WA_OUTPUT-INSUR SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

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
      READ TABLE LV_LINES INTO LS_CTBGI INDEX 1.

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_CTBGI.
          IF LS_CTBGI-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-MAT_TEXT LS_CTBGI-TDLINE INTO WA_OUTPUT-MAT_TEXT SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

********Insurance***********
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z047'
          LANGUAGE                = SY-LANGU
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
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_ITMTXT.
          IF LS_ITMTXT-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-PARDEL LS_ITMTXT-TDLINE INTO WA_OUTPUT-PARDEL SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

*      BREAK primus.
      SELECT SINGLE VTEXT INTO WA_OUTPUT-VTEXT FROM TVLST WHERE LIFSP = WA_VBAK-LIFSK AND SPRAS = 'EN'.
      CLEAR WA_TEXT1.
*                                    wa_text = wa_tag_rq-tdline(20).
      WA_TEXT1 = WA_TAG_RQ-TDLINE(50).     "CHANGED BY SR ON 03.05.2021
      TRANSLATE WA_TEXT1 TO UPPER CASE .       "tag Required
*                                    wa_output-tag_req     = wa_text(1).
      WA_OUTPUT-TAG_REQ     = WA_TEXT1.      "CHANGED BY SR ON 03.05.2021

      IF WA_FKIMG_SUM  IS NOT INITIAL.
        IF WA_LFIMG_SUM <> 0.
*          BREAK-POINT.
          WA_OUTPUT-LFIMG   =  WA_LFIMG_SUM - WA_FKIMG_SUM .            "ADDED BY MA ON 29.02.2024.
        ENDIF.
      ELSE.
        WA_OUTPUT-LFIMG       = WA_LFIMG_SUM.
      ENDIF.

*      wa_output-lfimg       = wa_lfimg_sum.                "del qty

      WA_OUTPUT-FKIMG       = WA_FKIMG_SUM.                "inv qty


*      WA_OUTPUT-LFIMG = WA_OUTPUT-LFIMG - WA_OUTPUT-FKIMG.
*      WA_OUTPUT-PND_QTY     = WA_OUTPUT-KWMENG - WA_OUTPUT-FKIMG - WA_OUTPUT-FKIMG.  "Pending Qty
*    BREAK-POINT.
      IF WA_OUTPUT-LFIMG IS NOT INITIAL.
        WA_OUTPUT-PND_QTY     = WA_OUTPUT-KWMENG - WA_OUTPUT-LFIMG ."- WA_OUTPUT-FKIMG.  "Pending Qty
      ELSE.
        WA_OUTPUT-PND_QTY     = WA_OUTPUT-KWMENG - WA_OUTPUT-FKIMG.
      ENDIF.
      IF WA_OUTPUT-FKIMG IS NOT INITIAL.
        WA_OUTPUT-PND_QTY     = WA_OUTPUT-PND_QTY  - WA_OUTPUT-LFIMG.

      ENDIF.


      IF WA_TVAGT-ABGRU IS INITIAL.
        WA_OUTPUT-ABGRU           =  '-'.   " avinash bhagat 20.12.2018
      ELSE.
        WA_OUTPUT-ABGRU           =  WA_TVAGT-ABGRU.   " avinash bhagat 20.12.2018
      ENDIF.
      IF WA_TVAGT-BEZEI IS INITIAL.
        WA_OUTPUT-BEZEI           =  '-'.   " avinash bhagat 20.12.2018
      ELSE.
        WA_OUTPUT-BEZEI           =  WA_TVAGT-BEZEI.   " avinash bhagat 20.12.2018
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
        LV_INDEX = SY-TABIX.
        LOOP AT IT_MSKA INTO WA_MSKA FROM LV_INDEX.
          IF WA_MSKA-VBELN = WA_VBAP-VBELN AND WA_MSKA-POSNR = WA_VBAP-POSNR
           AND WA_MSKA-MATNR = WA_VBAP-MATNR AND WA_MSKA-WERKS = WA_VBAP-WERKS.
*            LV_QMQTY = WA_MSKA-KAINS - LV_QMQTY.
            LV_QMQTY = WA_MSKA-KAINS + LV_QMQTY.
          ELSE.
            CLEAR LV_INDEX.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.

      WA_OUTPUT-QMQTY = LV_QMQTY.
      WA_OUTPUT-MATTXT = LS_MATTXT-TDLINE.

      CLEAR WA_TEXT1.
*                                    wa_text = wa_lines-tdline(20).
      WA_TEXT1 = WA_LINES-TDLINE(50).            "added by sr 0n 03.05.2021
      TRANSLATE WA_TEXT1 TO UPPER CASE .
      WA_OUTPUT-TPI         = WA_TEXT1.     "TPI Required

      CLEAR WA_TEXT1.
*                                    wa_text = wa_ln_ld-tdline(20).     "wa_ln_ld ld_req
      WA_TEXT1 = WA_LN_LD-TDLINE(50).     "added by sr 0n 03.05.2021
      TRANSLATE WA_TEXT1 TO UPPER CASE .
      WA_OUTPUT-LD_TXT         = WA_TEXT1.     "lD Required

*                                    CLEAR wa_text.
*                                    wa_text = wa_ofm_no-tdline(20).     "ofm sr no
*                                    TRANSLATE wa_text TO UPPER CASE .
*                                    wa_output-ofm_no         = wa_text(1).     "ofm sr no

      WA_OUTPUT-CURR_CON     = LV_EX_RATE-EXCH_RATE.    "Currency conversion

*      CATCH SYSTEM-EXCEPTIONS conversion_errors = 1
*                                          arithmetic_errors = 5.

      DATA: lv_EXCH_RATE(14) TYPE P DECIMALS 2,
            LV_KBETR(14)     TYPE P DECIMALS 2.

      CLEAR:lv_EXCH_RATE,
            LV_KBETR.
      IF LV_EX_RATE-EXCH_RATE IS NOT INITIAL.
        LV_KBETR = WA_OUTPUT-KBETR.
        lv_EXCH_RATE = LV_EX_RATE-EXCH_RATE.
        WA_OUTPUT-AMONT       = WA_OUTPUT-PND_QTY * LV_KBETR *
                                LV_EXCH_RATE.    "Amount
        WA_OUTPUT-ORDR_AMT    = WA_OUTPUT-KWMENG * LV_KBETR *
                                LV_EXCH_RATE.    "Ordr Amount
      ELSEIF LV_EX_RATE-EXCH_RATE IS INITIAL.
        WA_OUTPUT-AMONT       = WA_OUTPUT-PND_QTY * LV_KBETR .
        WA_OUTPUT-ORDR_AMT    = WA_OUTPUT-KWMENG * LV_KBETR .
      ENDIF.
      CONDENSE:  WA_OUTPUT-AMONT,WA_OUTPUT-ORDR_AMT.
*      ENDCATCH.
      WA_OUTPUT-IN_PR_DT    = WA_MBEW-LAEPR.           "Internal Price Date
      WA_OUTPUT-ST_COST     = WA_MBEW-STPRS .          "Standard Cost
*      wa_output-latst_cost   =  wa_KONV-KBETR.                    "
      WA_OUTPUT-LATST_COST    = WA_KONP-KBETR.        "LATEST EST COST
      WA_OUTPUT-ZSERIES     = WA_MARA-ZSERIES.         "series
      WA_OUTPUT-ZSIZE       = WA_MARA-ZSIZE.           "size
      WA_OUTPUT-BRAND       = WA_MARA-BRAND.           "Brand
      WA_OUTPUT-MOC         = WA_MARA-MOC.             "MOC
      WA_OUTPUT-TYPE        = WA_MARA-TYPE.            "TYPE
      WA_OUTPUT-MTART        = WA_MARA-MTART.          " Material TYPE        """" Addded by KD on 05.05.2017
      WA_OUTPUT-WRKST        = WA_MARA-WRKST.          "Basic Material(Usa Item Code)
      WA_OUTPUT-NORMT      = WA_MARA-NORMT.


      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      "LV_NAME = WA_VBAK-VBELN.
      CONCATENATE WA_VBAP-VBELN WA_VBAP-POSNR INTO LV_NAME.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z102' " 'Z015'
          LANGUAGE                = 'E'
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
* Implement suitable error handling here
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-OFM LS_LINES-TDLINE INTO WA_OUTPUT-OFM SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT                  = SY-MANDT
          ID                      = 'Z016'
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
* Implement suitable error handling here
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-OFM_DATE LS_LINES-TDLINE INTO WA_OUTPUT-OFM_DATE ."SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
************************************************************************ ADDED BY SHUBHANGI SARODE ON DT 25.01.2024
      DATA   :LV_DATE_TEMP TYPE CHAR11.
      CLEAR : LV_DATE_TEMP.

      CONCATENATE WA_OUTPUT-OFM_DATE+6(4) WA_OUTPUT-OFM_DATE+3(2) WA_OUTPUT-OFM_DATE+0(2) INTO LV_DATE_TEMP.
      IF LV_DATE_TEMP IS NOT INITIAL .
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LV_DATE_TEMP
          IMPORTING
            OUTPUT = LV_DATE_TEMP.

        CONCATENATE LV_DATE_TEMP+0(2) LV_DATE_TEMP+2(3) LV_DATE_TEMP+5(4)
                INTO LV_DATE_TEMP SEPARATED BY '-'.
      ENDIF.
      WA_OUTPUT-OFM_DATE       = LV_DATE_TEMP.
**********************************************************************END ON 25.01.2024


*
      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z020'
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
* Implement suitable error handling here
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-SPL LS_LINES-TDLINE INTO WA_OUTPUT-SPL SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

*************USA CUSTOMER CODE
      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-BSTKD.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'F22'
          LANGUAGE                = 'E'
          NAME                    = LV_NAME
          OBJECT                  = 'EKKO'
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
* Implement suitable error handling here
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-SU_CUST LS_LINES-TDLINE INTO WA_OUTPUT-SU_CUST SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

      """"""""""""" code added by pankaj 28.01.2022"""""""""""""""""

      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z102'
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
* Implement suitable error handling here
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-PROJ LS_LINES-TDLINE INTO WA_OUTPUT-PROJ SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.


      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z103'
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
* Implement suitable error handling here
        ENDIF.
        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-COND LS_LINES-TDLINE INTO WA_OUTPUT-COND." SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
********************************************************************************* "codition delivery date ADDDED BY SHUBAHNGI SARODE ON DT 25.01.2024

      CLEAR : LV_DATE_TEMP.

      CONCATENATE WA_OUTPUT-COND+6(4) WA_OUTPUT-COND+3(2) WA_OUTPUT-COND+0(2) INTO LV_DATE_TEMP.

      IF LV_DATE_TEMP IS NOT INITIAL .
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LV_DATE_TEMP
          IMPORTING
            OUTPUT = LV_DATE_TEMP.

        if LV_DATE_TEMP is NOT INITIAL .
        CONCATENATE LV_DATE_TEMP+0(2) LV_DATE_TEMP+2(3) LV_DATE_TEMP+5(4)
                       INTO LV_DATE_TEMP  SEPARATED BY '-'.
        WA_OUTPUT-COND = LV_DATE_TEMP.
      ENDIF.
      ENDIF.
*********************************************************************************ADDDED BY SHUBAHNGI SARODE ON DT 25.01.2024
      """""""""""""""" code ended"""""""""""""""""""""""""""""
      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z012'
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

      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-PACKING_TYPE LS_LINES-TDLINE INTO WA_OUTPUT-PACKING_TYPE ."SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
************************************************************************************* 25.01.2024 ADDED BY SHUBHANGI SARODE
      CLEAR : LV_DATE_TEMP.

      CONCATENATE WA_OUTPUT-PACKING_TYPE+6(4) WA_OUTPUT-PACKING_TYPE+3(2) WA_OUTPUT-PACKING_TYPE+0(2) INTO LV_DATE_TEMP.
      " LV_DATE_TEMP = WA_OUTPUT-OFM_DATE.
      IF  LV_DATE_TEMP IS NOT INITIAL .
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LV_DATE_TEMP
          IMPORTING
            OUTPUT = LV_DATE_TEMP.
        CONCATENATE LV_DATE_TEMP+0(2) LV_DATE_TEMP+2(3)  LV_DATE_TEMP+5(4)
                       INTO LV_DATE_TEMP  SEPARATED BY '-'.
      ENDIF.
      WA_OUTPUT-PACKING_TYPE = LV_DATE_TEMP.
************************************************************************************* END 25.01.2024


      """""""""""" code added by pankaj 31.01.2022""""""""""""""""

*           infra        TYPE char255,         "added by pankaj 31.01.2022
*          validation   TYPE char255,         "added by pankaj 31.01.2022
*          review_date  TYPE char255,         "added by pankaj 31.01.2022
*          diss_summary TYPE char25

      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z104'
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

      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-INFRA LS_LINES-TDLINE INTO WA_OUTPUT-INFRA SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z105'
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

      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-VALIDATION LS_LINES-TDLINE INTO WA_OUTPUT-VALIDATION SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.


      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z106'
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

      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-REVIEW_DATE LS_LINES-TDLINE  INTO WA_OUTPUT-REVIEW_DATE." SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
**************************************************************************** Review date on added by Shubhangi Sarode  25.01.2024
      CLEAR : LV_DATE_TEMP.

      CONCATENATE WA_OUTPUT-REVIEW_DATE+6(4) WA_OUTPUT-REVIEW_DATE+3(2) WA_OUTPUT-REVIEW_DATE+0(2) INTO LV_DATE_TEMP.
      " LV_DATE_TEMP = WA_OUTPUT-OFM_DATE.
      IF  LV_DATE_TEMP IS NOT INITIAL .
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LV_DATE_TEMP
          IMPORTING
            OUTPUT = LV_DATE_TEMP.
        CONCATENATE LV_DATE_TEMP+0(2) LV_DATE_TEMP+2(3)  LV_DATE_TEMP+5(4)
                       INTO LV_DATE_TEMP  SEPARATED BY '-'.
      ENDIF.

      WA_OUTPUT-REVIEW_DATE = LV_DATE_TEMP.
**************************************************************************** End On 25.01.2024



      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z107'
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

      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-DISS_SUMMARY LS_LINES-TDLINE INTO WA_OUTPUT-DISS_SUMMARY SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

      """""""""""""""""""""" code ended 31.01.2022"""""""""""""""""""""""""""""""""""""

      REFRESH : IT_JEST2 , IT_JEST2[] .
      CLEAR : WA_AFPO , WA_CAUFV.

      LOOP AT IT_AFPO INTO WA_AFPO WHERE KDAUF = WA_VBAP-VBELN
                                     AND KDPOS = WA_VBAP-POSNR
                                     AND MATNR = WA_VBAP-MATNR.

        READ TABLE IT_CAUFV INTO WA_CAUFV WITH KEY AUFNR = WA_AFPO-AUFNR
                                                   KDAUF = WA_AFPO-KDAUF
                                                   KDPOS = WA_AFPO-KDPOS.
        IF SY-SUBRC = 0.
          SELECT OBJNR STAT FROM JEST INTO TABLE IT_JEST2
                                WHERE OBJNR = WA_CAUFV-OBJNR
                                  AND INACT = ' '.
********************************Commented by SK(22.09.17)
          CLEAR WA_JEST2 .
          READ TABLE IT_JEST2 INTO WA_JEST2 WITH KEY STAT = 'I0012' BINARY SEARCH .
          IF SY-SUBRC NE 0.
            CLEAR WA_JEST2 .
            READ TABLE IT_JEST2 INTO WA_JEST2 WITH KEY STAT = 'I0009' BINARY SEARCH .
            IF SY-SUBRC NE 0.
              CLEAR WA_JEST2 .
              READ TABLE IT_JEST2 INTO WA_JEST2 WITH KEY STAT = 'I0002' BINARY SEARCH .
              IF SY-SUBRC = 0.
                WA_OUTPUT-WIP = WA_OUTPUT-WIP + WA_AFPO-PSMNG - WA_CAUFV-IGMNG ."wa_afpo-pgmng
              ENDIF.
            ENDIF.
          ENDIF.


        ENDIF.

      ENDLOOP.

      WA_OUTPUT-REF_DT = SY-DATUM.
      """ Ship to party logic

      READ TABLE LT_VBPA INTO LS_VBPA WITH KEY VBELN = WA_VBAP-VBELN POSNR = WA_VBAP-POSNR PARVW = 'WE'.
      IF SY-SUBRC = 0.
        WA_OUTPUT-SHIP_KUNNR = LS_VBPA-KUNNR.
        WA_OUTPUT-SHIP_LAND = LS_VBPA-LAND1.
        READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_VBPA-ADRNR.
        IF SY-SUBRC = 0.
          WA_OUTPUT-SHIP_KUNNR_N = LS_ADRC-NAME1.
          READ TABLE LT_ZGST_REGION INTO LS_ZGST_REGION WITH KEY REGION = LS_ADRC-REGION.
          IF SY-SUBRC = 0.
            WA_OUTPUT-SHIP_REG_N = LS_ZGST_REGION-BEZEI.
          ENDIF.
        ENDIF.
      ELSE.
        READ TABLE LT_VBPA INTO LS_VBPA WITH KEY VBELN = WA_VBAP-VBELN POSNR = ' '  PARVW = 'WE'.
        WA_OUTPUT-SHIP_KUNNR = LS_VBPA-KUNNR.
        WA_OUTPUT-SHIP_LAND = LS_VBPA-LAND1.
        READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_VBPA-ADRNR.
        IF SY-SUBRC = 0.
          WA_OUTPUT-SHIP_KUNNR_N = LS_ADRC-NAME1.
          READ TABLE LT_ZGST_REGION INTO LS_ZGST_REGION WITH KEY REGION = LS_ADRC-REGION.
          IF SY-SUBRC = 0.
            WA_OUTPUT-SHIP_REG_N = LS_ZGST_REGION-BEZEI.
          ENDIF.
        ENDIF.
      ENDIF.

      READ TABLE LT_VBPA INTO LS_VBPA WITH KEY VBELN = WA_VBAP-VBELN PARVW = 'AG'.
      IF SY-SUBRC = 0.
        WA_OUTPUT-SOLD_LAND = LS_VBPA-LAND1.
        READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_VBPA-ADRNR.
        IF SY-SUBRC = 0.
*          wa_output-ship_kunnr_n = ls_adrc-name1.
          READ TABLE LT_ZGST_REGION INTO LS_ZGST_REGION WITH KEY REGION = LS_ADRC-REGION.
          IF SY-SUBRC = 0.
            WA_OUTPUT-SOLD_REG_N = LS_ZGST_REGION-BEZEI.
          ENDIF.
        ENDIF.
      ENDIF.

      SELECT SINGLE LANDX50 INTO WA_OUTPUT-S_LAND_DESC FROM T005T WHERE SPRAS = 'EN' AND LAND1 = WA_OUTPUT-SHIP_LAND.

      """"""" code added by pankaj 04.02.2022"""""""""""""""""""
* Commented by Dhanashree because this field shows in downloaded excel
**      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln parvw = 'PT'.
**      IF sy-subrc = 0.
**        wa_output-adrnr = ls_vbpa-adrnr.

      READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_VBPA-ADRNR.
      IF SY-SUBRC = 0.
        WA_OUTPUT-PORT = LS_ADRC-NAME1.

      ENDIF.
*      ENDIF.
      """"""""""""""""""""""""""""""""""""""""""""""""
************        edited by PJ on 08-09-21

      WA_OUTPUT-REF_TIME = SY-UZEIT.

*BREAK PRIMUS.
      CONCATENATE WA_OUTPUT-REF_TIME+0(2) ':' WA_OUTPUT-REF_TIME+2(2)  INTO WA_OUTPUT-REF_TIME.

      """"""""""'''  code added by pankaj 04.02.2022""""""""""""""""""""""""

      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z101'
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

      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-FULL_PMNT LS_LINES-TDLINE INTO WA_OUTPUT-FULL_PMNT SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

      READ TABLE IT_TVKTT INTO WA_TVKTT WITH  KEY KTGRD = WA_VBKD-KTGRD .     "wa_output-ktgrd.   "04.02
      IF SY-SUBRC = 0.

        WA_OUTPUT-ACT_ASS       = WA_TVKTT-VTEXT.

      ENDIF.

*     CLEAR wa_jest1.
      READ TABLE IT_JEST3 INTO WA_JEST3 WITH KEY OBJNR = WA_VBAK-OBJNR.

      SELECT SINGLE * FROM TJ30T INTO WA_TJ30T  WHERE ESTAT = WA_JEST3-STAT AND STSMA  = 'OR_HEADR'.

      IF SY-SUBRC = 0.
*        wa_output-stsma      = wa_tj30-stsma.
        WA_OUTPUT-TXT04      = WA_TJ30T-TXT04.
      ENDIF.

      """""""""""" ended"""""""""""""""""""""""""""""""""""""
*********************ADDED BY SHREYA *********************
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z005'
          LANGUAGE                = SY-LANGU
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
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_ITMTXT.
          IF LS_ITMTXT-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-FREIGHT LS_ITMTXT-TDLINE INTO WA_OUTPUT-FREIGHT SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z103'
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
      READ TABLE LV_LINES INTO LS_CTBGI INDEX 1.

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_CTBGI.
          IF LS_CTBGI-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-PO_SR_NO LS_CTBGI-TDLINE INTO WA_OUTPUT-PO_SR_NO SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
**************************************** ADDED BY SHREYA**********************
************     end
      APPEND WA_OUTPUT TO IT_OUTPUT.
      CLEAR LS_VBEP.
      CLEAR:WA_OUTPUT-WIP,WA_OUTPUT-STOCK_QTY .
      CLEAR WA_OUTPUT.
    ENDLOOP.

  ENDIF.

  """"""""""""""""""        Added By KD on 05.05.2017                 """""""""""""
  IF IT_OUTPUT[] IS NOT INITIAL.
    REFRESH : IT_OAUTO , IT_OAUTO[] , IT_MAST , IT_MAST[] , IT_STKO , IT_STKO[] ,
              IT_STPO , IT_STPO[] , IT_MARA , IT_MARA[] , IT_MAKT , IT_MAKT[] .

    IT_OAUTO[] = IT_OUTPUT[] .
    DELETE IT_OAUTO WHERE DISPO NE 'AUT' .
    DELETE IT_OAUTO WHERE MTART NE 'FERT'.

    SELECT MATNR WERKS STLAN STLNR STLAL FROM MAST INTO TABLE IT_MAST
                                            FOR ALL ENTRIES IN IT_OAUTO
                                                  WHERE MATNR = IT_OAUTO-MATNR
                                                    AND STLAN = 1.

    SELECT STLTY STLNR STLAL STKOZ FROM STKO INTO TABLE IT_STKO
                                      FOR ALL ENTRIES IN IT_MAST
                                                  WHERE STLNR = IT_MAST-STLNR
                                                    AND STLAL = IT_MAST-STLAL.

    SELECT STLTY STLNR STLKN STPOZ IDNRK FROM STPO INTO TABLE IT_STPO
                                            FOR ALL ENTRIES IN IT_STKO
                                                        WHERE STLNR = IT_STKO-STLNR
                                                          AND STPOZ = IT_STKO-STKOZ .

    SELECT * FROM MARA INTO TABLE IT_MARA FOR ALL ENTRIES IN IT_STPO
                                                    WHERE MATNR = IT_STPO-IDNRK
                                                      AND MTART = 'FERT' .

    SELECT * FROM MAKT INTO TABLE IT_MAKT FOR ALL ENTRIES IN IT_MARA
                                                      WHERE MATNR = IT_MARA-MATNR
                                                        AND SPRAS = 'EN'.

    CLEAR WA_OUTPUT .
    LOOP AT IT_MAKT INTO WA_MAKT .
      READ TABLE IT_STPO INTO WA_STPO WITH KEY IDNRK = WA_MAKT-MATNR .
      IF SY-SUBRC = 0.
        READ TABLE IT_STKO INTO WA_STKO WITH KEY STLNR = WA_STPO-STLNR STKOZ = WA_STPO-STPOZ .
        IF SY-SUBRC = 0.
          READ TABLE IT_MAST INTO WA_MAST WITH KEY STLNR = WA_STKO-STLNR STLAL = WA_STKO-STLAL.
          IF SY-SUBRC = 0.
            WA_OUTPUT-MATNR = WA_MAST-MATNR.
*            wa_output-scmat = wa_makt-matnr.
            WA_OUTPUT-ARKTX = WA_MAKT-MAKTX.
            CLEAR: LV_LINES, LS_ITMTXT.

*            BREAK primus.

*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z012'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-packing_type ls_lines-tdline INTO wa_output-packing_type SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.

*
*            """""""""""" code added by pankaj 31.01.2022""""""""""""""""
*
**           infra        TYPE char255,         "added by pankaj 31.01.2022
**          validation   TYPE char255,         "added by pankaj 31.01.2022
**          review_date  TYPE char255,         "added by pankaj 31.01.2022
**          diss_summary TYPE char25
*
*           CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z104'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-infra ls_lines-tdline INTO wa_output-infra SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z105'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-validation ls_lines-tdline INTO wa_output-validation SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z106'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-review_date ls_lines-tdline INTO wa_output-review_date SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*           lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z107'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-diss_summary ls_lines-tdline INTO wa_output-diss_summary SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*            """""""""""""""""""""" code ended 31.01.2022"""""""""""""""""""""""""""""""""""""
            APPEND WA_OUTPUT TO IT_OUTPUT.
            CLEAR WA_OUTPUT .
          ENDIF.
        ENDIF.
      ENDIF.
      CLEAR : WA_MAST , WA_STKO , WA_STPO , WA_MAKT.
    ENDLOOP.

  ENDIF.
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
  DATA :GV_POS      TYPE I VALUE '1'..
******************************************************************************************
**
**  PERFORM build_fieldcat USING 'WERKS'          'X' '1'   'Plant'(003)                    '15' ''.

****Purchase Org

  WA_FCAT-COL_POS = GV_POS.
  WA_FCAT-FIELDNAME = 'WERKS'.
  WA_FCAT-SELTEXT_L = 'Plant'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'AUART'          'X' '2'   'Order Type'(004)               '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'AUART'.
  WA_FCAT-SELTEXT_L = 'Order Type'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'BSTKD'          'X' '3'   'Customer Reference No'(005)    '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'BSTKD'.
  WA_FCAT-SELTEXT_L = 'Customer Reference No'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'NAME1'          'X' '4'   'Customer'(006)                 '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'NAME1'.
  WA_FCAT-SELTEXT_L = 'Customer'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'VKBUR'          'X' '5'   'Sales Office'(007)             '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'VKBUR'.
  WA_FCAT-SELTEXT_L = 'Sales Office'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'VBELN'          'X' '6'   'Sales Doc No'(008)             '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'VBELN'.
  WA_FCAT-SELTEXT_L = 'Sales Doc No'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'ERDAT'          'X' '7'   'So Date'(009)                  '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ERDAT'.
  WA_FCAT-SELTEXT_L = 'So Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'VDATU'          'X' '8'   'Required Delivery Dt'          '15' ''."(010).
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'VDATU'.
  WA_FCAT-SELTEXT_L = 'Required Delivery Dt'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'STATUS'         'X' '9'   'HOLD/UNHOLD'(011)              '15' ''.
  WA_FCAT-COL_POS = GV_POS.
  WA_FCAT-FIELDNAME = 'STATUS'.
  WA_FCAT-SELTEXT_L = 'HOLD/UNHOLD'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'HOLDDATE'       'X' '10'  'HOLD Date'(012)                '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'HOLDDATE'.
  WA_FCAT-SELTEXT_L = 'HOLD Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'RELDATE'        'X' '11'  'Release Date'(013)             '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'RELDATE'.
  WA_FCAT-SELTEXT_L = 'Release Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'CANCELDATE'     'X' '12'  'CANCELLED Date'(014)           '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'CANCELDATE'.
  WA_FCAT-SELTEXT_L = 'CANCELLED Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**
**
**
**  PERFORM build_fieldcat USING 'DELDATE'        'X' '13'  'Delivery Date'                 '15' ''. "(015)

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'DELDATE'.
  WA_FCAT-SELTEXT_L = 'Delivery Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'TAG_REQ'        'X' '14'  'TAG Required'(049)             '50' ''.

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'TAG_REQ'.
  WA_FCAT-SELTEXT_L = 'TAG Required'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'TPI'            'X' '15'  'TPI Required'(044)             '50' ''.

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'TPI'.
  WA_FCAT-SELTEXT_L = 'TPI Required'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'LD_TXT'         'X' '16'  'LD Required'(050)              '50' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'LD_TXT'.
  WA_FCAT-SELTEXT_L = 'LD Required'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**  PERFORM build_fieldcat USING 'ZLDPERWEEK'     'X' '17' 'LD %Per Week'(046)              '15' ''.

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZLDPERWEEK'.
  WA_FCAT-SELTEXT_L = 'LD %Per Week'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
**  PERFORM build_fieldcat USING 'ZLDMAX'         'X' '18'  'LD % Max'(047)                  '15' ''.

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZLDMAX'.
  WA_FCAT-SELTEXT_L = 'LD % Max'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
**  PERFORM build_fieldcat USING 'ZLDFROMDATE'    'X' '19' 'LD From Date'(048)              '15'  ''.

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZLDFROMDATE'.
  WA_FCAT-SELTEXT_L = 'LD From Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
***  PERFORM BUILD_FIELDCAT USING ''                'X' '18'  ''(0).

***  PERFORM BUILD_FIELDCAT USING ''                'X' '19'  ''(0).
**  PERFORM build_fieldcat USING 'MATNR'          'X' '20'   'Item Code'(016)               '18' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'MATNR'.
  WA_FCAT-SELTEXT_L = 'Item Code'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
***  PERFORM build_fieldcat USING 'SCMAT'          'X' '21'   'Sub-Item Code'(053).
*  wa_fcat-col_pos = gv_pos + 1.
*  wa_fcat-fieldname = 'SCMAT'.
*  wa_fcat-seltext_l = 'Sub-Item Code'.
*  wa_fcat-tabname   = 'IT_OUTPUT'.
*  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
*  APPEND wa_fcat TO it_fcat.
*  CLEAR wa_fcat.
**  PERFORM build_fieldcat USING 'POSNR'          'X' '21'   'Line Item'(017)               '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'POSNR'.
  WA_FCAT-SELTEXT_L = 'Line Item'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
**  PERFORM build_fieldcat USING 'ARKTX'          'X' '22'   'Item Description'(018)        '20' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ARKTX'.
  WA_FCAT-SELTEXT_L = 'Item Description'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
**  PERFORM build_fieldcat USING 'KWMENG'         'X' '23'   'SO QTY'(019)                  '15' 'X' .

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'KWMENG'.
  WA_FCAT-SELTEXT_L = 'SO QTY'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**
*****  PERFORM build_fieldcat USING 'KALAB'          'X' '25'   'Stock Qty'(020).
****  PERFORM build_fieldcat USING 'STOCK_QTY'          'X' '24'   'Stock Qty'(020)           '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'STOCK_QTY'.
  WA_FCAT-SELTEXT_L = 'Stock Qty'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

**
****  PERFORM build_fieldcat USING 'LFIMG'          'X' '25'   'Delivery Qty'(021)            '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'LFIMG'.
  WA_FCAT-SELTEXT_L = 'Delivery Qty'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
**
****  PERFORM build_fieldcat USING 'FKIMG'          'X' '26'   'Invoice Quantity'(022)        '15' 'X'.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'FKIMG'.
  WA_FCAT-SELTEXT_L = 'Invoice Quantity'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'PND_QTY'        'X' '27'   'Pending Qty'(023)             '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'PND_QTY'.
  WA_FCAT-SELTEXT_L = 'Pending Qty'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ETTYP'          'X' '28'   'SO Status'(024)               '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ETTYP'.
  WA_FCAT-SELTEXT_L = 'SO Status'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'MRP_DT'         'X' '29'   'MRP Date'(045)                '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'MRP_DT'.
  WA_FCAT-SELTEXT_L = 'MRP Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'EDATU'          'X' '30'   'Production date'              '15' ''.   "'Posting Date'(025).
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'EDATU'.
  WA_FCAT-SELTEXT_L = 'Production date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'KBETR'          'X' '31'   'Rate'(026)                    '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'KBETR'.
  WA_FCAT-SELTEXT_L = 'Rate'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'WAERK'          'X' '32'   'Currency Type'(027)           '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'WAERK'.
  WA_FCAT-SELTEXT_L = 'Currency Type'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'CURR_CON'       'X' '33'   'Currency Conv'(028)           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'CURR_CON'.
  WA_FCAT-SELTEXT_L = 'Currency Conv'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'SO_EXC'         'X' '34'   'SO Exchange Rate'(051)        '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'SO_EXC'.
  WA_FCAT-SELTEXT_L = 'SO Exchange Rate'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
**
****  PERFORM build_fieldcat USING 'AMONT'          'X' '35'   'Pending SO Amount'            '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'AMONT'.
  WA_FCAT-SELTEXT_L = 'Pending SO Amount'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ORDR_AMT'       'X' '36'   'Order Amount'(030)            '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ORDR_AMT'.
  WA_FCAT-SELTEXT_L = 'Order Amount'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
*****  PERFORM BUILD_FIELDCAT USING 'KURSK'          'X' '34'   ''(031).
****  PERFORM build_fieldcat USING 'IN_PRICE'        'X' '37'   'Internal Price'(032)         '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'IN_PRICE'.
  WA_FCAT-SELTEXT_L = 'Internal Price'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'IN_PR_DT'        'X' '38'   'Internal Price Date'(033)    '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'IN_PR_DT'.
  WA_FCAT-SELTEXT_L = 'Internal Price Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'EST_COST'        'X' '39'   'Estimated Cost'(034)         '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'EST_COST'.
  WA_FCAT-SELTEXT_L = 'Estimated Cost'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'LATST_COST'      'X' '40'   'Latest Estimated Cost'(035)  '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'LATST_COST'.
  WA_FCAT-SELTEXT_L = 'Latest Estimated Cost'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ST_COST'         'X' '41'   'Standard Cost'(036)          '15'   ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ST_COST'.
  WA_FCAT-SELTEXT_L = 'Standard Cost'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ZSERIES'         'X' '42'   'Series'(037)                 '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZSERIES'.
  WA_FCAT-SELTEXT_L = 'Series'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ZSIZE'           'X' '43'   'Size'(038)                   '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZSIZE'.
  WA_FCAT-SELTEXT_L = 'Size'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'BRAND'           'X' '44'   'Brand'(039)                  '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'BRAND'.
  WA_FCAT-SELTEXT_L = 'Brand'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'MOC'             'X' '45'   'MOC'(040)                    '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'MOC'.
  WA_FCAT-SELTEXT_L = 'MOC'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'TYPE'            'X' '46'   'Type'(041)                   '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'TYPE'.
  WA_FCAT-SELTEXT_L = 'Type'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  """"""""""""'   Added By KD on 04.05.2017    """""""
****  PERFORM build_fieldcat USING 'DISPO'            'X' '47'   'MRP Controller'(051)        '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'DISPO'.
  WA_FCAT-SELTEXT_L = 'MRP Controller'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'WIP'              'X' '48'   'WIP'(052)                   '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'WIP'.
  WA_FCAT-SELTEXT_L = 'WIP'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'MTART'            'X' '49'   'MAT TYPE'                   '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'MTART'.
  WA_FCAT-SELTEXT_L = 'MAT TYPE'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'KDMAT'            'X' '50'   'CUST MAT NO'                '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'KDMAT'.
  WA_FCAT-SELTEXT_L = 'CUST MAT NO'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'KUNNR'            'X' '51'   'CUSTOMER CODE'              '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'KUNNR'.
  WA_FCAT-SELTEXT_L = 'CUSTOMER CODE'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'QMQTY'            'X' '52'   'QM QTY'                     '15'   ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'QMQTY'.
  WA_FCAT-SELTEXT_L = 'QM QTY'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'MATTXT'           'X' '53'   'Material Text'              '20' '' .
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'MATTXT'.
  WA_FCAT-SELTEXT_L = 'Material Text'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ITMTXT'           ' ' '54'   'Sales Text'                 '50' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ITMTXT'.
  WA_FCAT-SELTEXT_L = 'Sales Text'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-KEY  = 'X' .
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ETENR'            'X' '55'   'Schedule_no'                '15' '' .
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ETENR'.
  WA_FCAT-SELTEXT_L = 'Schedule_no'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'SCHID'            'X' '56'   'Schedule_id'                '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'SCHID'.
  WA_FCAT-SELTEXT_L = 'Schedule_id'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ZTERM'            'X' '57'   'Payment Terms'              '15' ''.

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZTERM'.
  WA_FCAT-SELTEXT_L = 'Payment Terms'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'TEXT1'            'X' '58'   'Payment Terms Text'         '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'TEXT1'.
  WA_FCAT-SELTEXT_L = 'Payment Terms Text'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'INCO1'            'X' '59'   'Inco Terms'                 '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'INCO1'.
  WA_FCAT-SELTEXT_L = 'Inco Terms'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'INCO2'            'X' '60'   'Inco Terms Descr'           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'INCO2'.
  WA_FCAT-SELTEXT_L = 'Inco Terms Descr'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'OFM'              'X' '61'   'OFM No.'                    '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'OFM'.
  WA_FCAT-SELTEXT_L = 'OFM No.'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'OFM_DATE'         'X' '62'   'OFM Date'                   '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'OFM_DATE'.
  WA_FCAT-SELTEXT_L = 'OFM Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'SPL'              'X' '63'   'Special Instruction'        '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'SPL'.
  WA_FCAT-SELTEXT_L = 'Special Instruction'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'CUSTDELDATE'      'X' '64'  'Customer Delivery Dt'        '15' ''.   "(015).
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'CUSTDELDATE'.
  WA_FCAT-SELTEXT_L = 'Customer Delivery Dt'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ABGRU'            'X' '65'  'Rejection Reason Code'       '15' ''.   "   AVINASH BHAGAT 20.12.2018
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ABGRU'.
  WA_FCAT-SELTEXT_L = 'Rejection Reason Code'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'BEZEI'            'X' '66'  'Rejection Reason Description' '15' ''.   "   AVINASH BHAGAT 20.12.2018
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'BEZEI'.
  WA_FCAT-SELTEXT_L = 'Rejection Reason Description'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'WRKST'            'X' '67'  'SAUDI Item Code'                '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'WRKST'.
  WA_FCAT-SELTEXT_L = 'SAUDI Item Code'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
*****  perform build_fieldcat using 'CGST'             'X' '68'  'CGST%'                        '15'.
*****  PERFORM build_fieldcat USING 'CGST_VAL'         'X' '69'  'CGST'.
*****  perform build_fieldcat using 'SGST'             'X' '70'  'SGST%'                        '15'.
*****  PERFORM build_fieldcat USING 'SGST_VAL'         'X' '71'  'SGST'.
*****  perform build_fieldcat using 'IGST'              'X' '72'  'IGST%'                       '15'.
*****  PERFORM build_fieldcat USING 'IGST_VAL'         'X' '73'  'IGST'.
****  PERFORM build_fieldcat USING 'SHIP_KUNNR'         'X' '73'  'Ship To Party'              '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'SHIP_KUNNR'.
  WA_FCAT-SELTEXT_L = 'Ship To Party'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'SHIP_KUNNR_N'       'X' '74'  'Ship To Party Description'  '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'SHIP_KUNNR_N'.
  WA_FCAT-SELTEXT_L = 'Ship To Party Description'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'SHIP_REG_N'         'X' '75'  'Ship To Party State'        '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'SHIP_REG_N'.
  WA_FCAT-SELTEXT_L = 'Ship To Party State'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'SOLD_REG_N'         'X' '76'  'Sold To Party State'        '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'SOLD_REG_N'.
  WA_FCAT-SELTEXT_L = 'Sold To Party State'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'NORMT'              'X' '77'       'Industry Std Desc.'           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'NORMT'.
  WA_FCAT-SELTEXT_L = 'Industry Std Desc.'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'SHIP_LAND'          'X' '78'   'Ship To Party Country Key'    '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'SHIP_LAND'.
  WA_FCAT-SELTEXT_L = 'Ship To Party Country Key'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'S_LAND_DESC'        'X' '79'   'Ship To Party Country Desc'  '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'S_LAND_DESC'.
  WA_FCAT-SELTEXT_L = 'Ship To Party Country Desc'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'SOLD_LAND'          'X' '80' 'Sold To Party Country Key'     '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'SOLD_LAND'.
  WA_FCAT-SELTEXT_L = 'Sold To Party Country Key'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'POSEX'              'X' '81' 'Purchase Order Item'               '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'POSEX'.
  WA_FCAT-SELTEXT_L = 'Purchase Order Item'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'BSTDK'              'X' '82' 'PO Date'                        '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'BSTDK'.
  WA_FCAT-SELTEXT_L = 'PO Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'LIFSK'              'X' '83' 'Delivery Block(Header Loc)'                     '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'LIFSK'.
  WA_FCAT-SELTEXT_L = 'Delivery Block(Header Loc)'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'VTEXT'              'X' '84' 'Delivery Block Txt'               '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'VTEXT'.
  WA_FCAT-SELTEXT_L = 'Delivery Block Txt'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'INSUR'              'X' '85' 'Insurance'               '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'INSUR'.
  WA_FCAT-SELTEXT_L = 'Insurance'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'PARDEL'             'X' '86' 'Partial Delivery'               '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'PARDEL'.
  WA_FCAT-SELTEXT_L = 'Partial Delivery'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'GAD'                'X' '87' 'GAD'               '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'GAD'.
  WA_FCAT-SELTEXT_L = 'GAD'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'SU_CUST'            'X' '88' 'SAUDI Customer Name'               '15' ''.

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'SU_CUST'.
  WA_FCAT-SELTEXT_L = 'SAUDI Customer Name'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
*****  perform build_fieldcat using 'TCS'                'X' '89' 'TCS Rate'               '15'.
*****  perform build_fieldcat using 'TCS_AMT'            'X' '90' 'TCS Amount'               '15' ''.
****  PERFORM build_fieldcat USING 'PO_DEL_DATE'        'X' '91' 'PO_Delivery_Date'               '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'PO_DEL_DATE'.
  WA_FCAT-SELTEXT_L = 'PO_Delivery_Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'OFM_NO'             'X' '92' 'OFM SR. NO.'               '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'OFM_NO'.
  WA_FCAT-SELTEXT_L = 'OFM SR. NO.'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'CTBG'              'X' '93' 'CTBG Item Details'               '20' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'CTBG'.
  WA_FCAT-SELTEXT_L = 'CTBG Item Details'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'CERTIF'             'X' '94' 'Certificate Details'             '20' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'CERTIF'.
  WA_FCAT-SELTEXT_L = 'Certificate Details'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ITEM_TYPE'             'X' '95' 'Item Type'             '20' ''. "edited by PJ on16-08-21
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ITEM_TYPE'.
  WA_FCAT-SELTEXT_L = 'Item Type'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'REF_TIME'             'X' '96' 'Ref. Time'             '15' ''. "edited by PJ on 08-09-21
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'REF_TIME'.
  WA_FCAT-SELTEXT_L = 'Ref. Time'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
*****  PERFORM build_fieldcat USING 'CTBG'             'X' '94' 'CTBG Details'             '10'.
****
****  """""""""""""""" "added by pankaj 28.01.2022""""""""""""""""
****
****  PERFORM build_fieldcat USING 'PROJ'               'X' '97' 'Project Owner Details'             '15' ''. "added by pankaj 28.01.2022

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'PROJ'.
  WA_FCAT-SELTEXT_L = 'Project Owner Details'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'COND'               'X' '98' 'Condition Delivery Date'             '15' ''. "added by pankaj 28.01.2022
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'COND'.
  WA_FCAT-SELTEXT_L = 'Condition Delivery Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'RECEIPT_DATE'       'X' '99' 'Code Receipt Date'             '15' ''. "added by pankaj 28.01.2022
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'RECEIPT_DATE'.
  WA_FCAT-SELTEXT_L = 'Code Receipt Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'REASON'             'X' '100' 'Reason'             '15' ''.               "added by pankaj 28.01.2022
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'REASON'.
  WA_FCAT-SELTEXT_L = 'Reason'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'NTGEW'             'X' '101' 'New Weight'             '15' ''.               "added by pankaj 28.01.2022
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'NTGEW'.
  WA_FCAT-SELTEXT_L = 'New Weight'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ZPR0'             'X' '102' 'Condition ZPR0'           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZPR0'.
  WA_FCAT-SELTEXT_L = 'Condition ZPR0'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ZPF0'             'X' '103' 'Condition ZPF0'           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZPF0'.
  WA_FCAT-SELTEXT_L = 'Condition ZPF0'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ZIN1'               'X' '104' 'Condition ZIN1'           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZIN1'.
  WA_FCAT-SELTEXT_L = 'Condition ZIN1'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'K005'               'X' '105' 'Condition K005'           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'K005'.
  WA_FCAT-SELTEXT_L = 'Condition K005'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'K007'               'X' '106' 'Condition K007'           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'K007'.
  WA_FCAT-SELTEXT_L = 'Condition K007'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ZDC1'               'X' '107' 'Condition DC1'           '15' ''.
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZDC1'.
  WA_FCAT-SELTEXT_L = 'Condition DC1'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
**
****  PERFORM build_fieldcat USING 'ZFR1'               'X' '108' 'Condition FR1'           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZFR1'.
  WA_FCAT-SELTEXT_L = 'Condition FR1'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ZTE1'               'X' '108' 'Condition ZTE1'           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZTE1'.
  WA_FCAT-SELTEXT_L = 'Condition ZTE1'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'MWAS'               'X' '108' 'Condition MWAS'           '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'MWAS'.
  WA_FCAT-SELTEXT_L = 'Condition MWAS'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'DATE'               'X' '109' 'Schedule line del.Date'  '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'DATE'.
  WA_FCAT-SELTEXT_L = 'Schedule line del.Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-DO_SUM = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'PRSDT'               'X' '110' 'Pricing Date'            '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'PRSDT'.
  WA_FCAT-SELTEXT_L = 'Pricing Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'PACKING_TYPE'               'X' '111' 'Packing Type'            '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'PACKING_TYPE'.
  WA_FCAT-SELTEXT_L = 'Packing Type'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'OFM_DATE1'               'X' '112' 'OFM Delivery Date'            '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'OFM_DATE1'.
  WA_FCAT-SELTEXT_L = 'OFM Delivery Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'MAT_TEXT'               'X' '113' 'Material Sales Text'            '15' ''.

  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'MAT_TEXT'.
  WA_FCAT-SELTEXT_L = 'Material Sales Text'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  "PERFORM build_fieldcat USING 'ERDAT1'               'X' '113' 'SO Change Date '            '15'.
****
****  """""""""""""""""""""""" ended """"""""""""""""""""""""""""""""""'
*****infra        TYPE char255,         "added by pankaj 31.01.2022
*****          validation   TYPE char255,         "added by pankaj 31.01.2022
*****          review_date  TYPE char255,         "added by pankaj 31.01.2022
*****          diss_summary
****  """"""""""""""""""""""""Coded added by pankaj 31.01.2022  """"""""""""""""""""""""""""
****
****  PERFORM build_fieldcat USING 'INFRA'                      'X' '114' 'Infrastructure Required'            '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'INFRA'.
  WA_FCAT-SELTEXT_L = 'Infrastructure Required'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'VALIDATION'                 'X' '115' 'Validation Plan Refrence'            '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'VALIDATION'.
  WA_FCAT-SELTEXT_L = 'Validation Plan Refrence'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'REVIEW_DATE'                'X' '116' 'Review Date'            '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'REVIEW_DATE'.
  WA_FCAT-SELTEXT_L = 'Review Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'DISS_SUMMARY'                'X' '117' 'Discussion Summary'            '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'DISS_SUMMARY'.
  WA_FCAT-SELTEXT_L = 'Discussion Summary'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'CHANG_SO_DATE'                'X' '118' 'Changed SO Date'            '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'CHANG_SO_DATE'.
  WA_FCAT-SELTEXT_L = 'Changed SO Date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****
****  """"""" added by pankaj 04.02.2022"""""""""""""""
****
****  PERFORM build_fieldcat USING 'PORT'                      'X'       '119' 'Port'                         '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'PORT'.
  WA_FCAT-SELTEXT_L = 'Port'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'FULL_PMNT'                 'X'       '120' 'Full Payment Desc'            '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'FULL_PMNT'.
  WA_FCAT-SELTEXT_L = 'Full Payment Desc'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
**
****  PERFORM build_fieldcat USING 'ACT_ASS'                   'X'       '121' 'Act Assignments'            '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ACT_ASS'.
  WA_FCAT-SELTEXT_L = 'Act Assignments'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'TXT04'                     'X'       '122' 'User Status'            '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'TXT04'.
  WA_FCAT-SELTEXT_L = 'User Status'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
  WA_FCAT-KEY  = 'X' .
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'KWERT'                     'X'       '123' 'Condition Value ZPR0'            '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'KWERT'.
  WA_FCAT-SELTEXT_L = 'Condition Value ZPR0'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'FREIGHT'                     'X'       '124' 'Freight'            '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'FREIGHT'.
  WA_FCAT-SELTEXT_L = 'Freight'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  " PERFORM build_fieldcat USING 'OFM_SR_NO'                     'X'       '125' 'OFM SR NO'            '15'.
****  PERFORM build_fieldcat USING 'PO_SR_NO'                     'X'       '126' 'PO SR NO TEXT'            '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'PO_SR_NO'.
  WA_FCAT-SELTEXT_L = 'PO SR NO TEXT'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
**
****  PERFORM build_fieldcat USING 'UDATE'                      'X'         '127' 'Last changed date'        '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'UDATE'.
  WA_FCAT-SELTEXT_L = 'Last changed date'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'BOM'                      'X'         '128' 'BOM Status'        '15'  ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'BOM'.
  WA_FCAT-SELTEXT_L = 'BOM Status'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ZPEN_ITEM'                      'X'         '129' 'Pending Items'        '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZPEN_ITEM'.
  WA_FCAT-SELTEXT_L = 'Pending Items'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
****  PERFORM build_fieldcat USING 'ZRE_PEN_ITEM'                      'X'         '130' 'Reason for Pending Items'        '15' ''.
**
  WA_FCAT-COL_POS = GV_POS + 1.
  WA_FCAT-FIELDNAME = 'ZRE_PEN_ITEM'.
  WA_FCAT-SELTEXT_L = 'Reason for Pending Items'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
***  perform build_fieldcat using 'VTEXT1'                      'X'         '131' 'Billing Block'        '15'.

  WA_FCAT-COL_POS = GV_POS + 1.                         """Created by 27.03.2024
  WA_FCAT-FIELDNAME = 'ERNAM'.
  WA_FCAT-SELTEXT_L = 'Created By'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
***  perform build_fieldcat using 'VTEXT1'

  WA_FCAT-COL_POS = GV_POS + 1.                               """Created by 27.03.2024
  WA_FCAT-FIELDNAME = 'ERDAT'.
  WA_FCAT-SELTEXT_L = 'Created On'.
  WA_FCAT-TABNAME   = 'IT_OUTPUT'.
*  wa_fcat-do_sum = 'X'.
  "  gt_fieldcatalog-fieldname = 'SGST_NRC'. = '15'.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
***  perform build_fieldcat using 'VTEXT1'
**
**  """"""" ended """"""""""""""""""""""""""""

*          dispo       TYPE marc-dispo,
*          wip         TYPE i,
*          mtart       TYPE mara-mtart,
*          kdmat       TYPE vbap-kdmat,
*          etenr       type vbep-etenr,
*          kunnr       TYPE kna1-kunnr,

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
*     i_structure_name   = 'OUTPUT'
*     i_callback_user_command = 'USER_CMD'
      IS_LAYOUT          = WA_LAYOUT
      IT_FIELDCAT        = IT_FCAT
      IT_SORT            = I_SORT
***     i_default          = 'A'
      I_SAVE             = 'X'
      IT_EVENTS          = GT_EVENTS[]
    TABLES
      T_OUTTAB           = IT_OUTPUT
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
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
  LF_LINE-INFO =  ''(042).
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

**FORM build_fieldcat  USING    v1  v2 v3 v4 v5 v6.
**  wa_fcat-fieldname   = v1 ." 'VBELN'.
**  wa_fcat-tabname     = 'IT_OUTPUT'.  "'IT_FINAL_NEW'.
*** WA_FCAT-_ZEBRA      = 'X'.
**  wa_fcat-key         = v2 .             "  'X'.
**  wa_fcat-col_pos     =  v3.
**  wa_fcat-seltext_l   =  v4.
**  wa_fcat-outputlen   =  v5." 20.
***  wa_fcat-do_sum    = v6.
***  wa_fcat-ddictxt     =  'L'.
***  wa_fcat-seltext_l      =  'L'.
**
**  APPEND wa_fcat TO it_fcat.
**  CLEAR wa_fcat.
**
**ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWN_SET .
*  BREAK fujiabap.
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
*break primus.
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
  LV_FILE = 'ZSU_DELPENDSO.TXT'.

*  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_PENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
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
*  IF sy-subrc = 0.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.

  """" ++ NC """"""""""""""""''
  IF SY-SUBRC = 0.
    DATA LV_STRING_263 TYPE STRING.
    DATA LV_CRLF_263 TYPE STRING.

    LV_CRLF_263 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_263 = HD_CSV.

*    TRANSFER hd_csv TO lv_fullfile.

    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_263  LV_CRLF_263   WA_CSV INTO LV_STRING_263 .
      CLEAR: WA_CSV.
    ENDLOOP.

    TRANSFER LV_STRING_263 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.





******************************************************new file zpendso **********************************
  PERFORM NEW_FILE.
*  break primus.
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
  LV_FILE = 'ZSU_DELPENDSO.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
*  CONCATENATE p_folder '\' lv_file
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_PENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
******  IF sy-subrc = 0.
******    TRANSFER hd_csv TO lv_fullfile.
******    LOOP AT it_csv INTO wa_csv.
******      IF sy-subrc = 0.
******        TRANSFER wa_csv TO lv_fullfile.
******
******      ENDIF.
******    ENDLOOP.
******    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
******    MESSAGE lv_msg TYPE 'S'.
******  ENDIF.
  """""""""""""""" ++ NC """""""""""""""""""""""


  IF SY-SUBRC = 0.
    DATA LV_STRING_264 TYPE STRING.
    DATA LV_CRLF_264 TYPE STRING.

    LV_CRLF_264 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_264 = HD_CSV.

*    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_264  LV_CRLF_264   WA_CSV INTO LV_STRING_264 .
      CLEAR: WA_CSV.
    ENDLOOP.

    TRANSFER LV_STRING_264 TO LV_FULLFILE.
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
          'DELIVERY QTY'
          'INVOICE QUANTITY'
          'PENDING QTY'
          'SO STATUS'
          'MRP DATE'
          'PRODUCTION DATE'
          'RATE'
          'CURRENCY'
          'CURRENCY CONV'
          'SO Exchnage Rate'
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
*          'SO Exchange Rate'
          'Payment Terms'
          'Payment Terms Text'
          'Inco Terms'
          'Inco Terms Descr'
          'OFM No.'
          'OFM Date'
          'Special Instruction'
          'CUSTOMER DEL DATE'
          'File Created Date'
          'Rejection Reason Code'
          'Rejection Reason Description'
          'SA Item Code'
          'Ship To Party'
          'Ship To Party Description'
          'Ship To Party State'
          'Sold To Party State'
          'Industry Std Desc.'
          'Ship To Party Country Key'
          'Ship To Party Country Desc'
          'Sold To Party Country Key'
          'Purchase Order Item'
          'PO Date'
          'Delivery Block(Header Loc)'
          'Delivery Block Txt'
           'Insurance'
          'Partial Delivery'
          'GAD'
          'SA Customer Name'
          'PO_Delivery_Date'
          'OFM SR. NO.'
          'CTBG Item Details'
          'Certificate Details'
          'Item Type' "  edited by PJ on 16-08-21
          'Ref. Time' "  edited by PJ on 08-09-21
          'Project Ownwer Name'            "added by pankaj 28.01.2022
          'Condition Delivery Date'        "added by pankaj 28.01.2022
          'Code Receipt Date'              "added by pankaj 28.01.2022
          'Reason'                         "added by pankaj 28.01.2022
          'Net Weight'                         "added by pankaj 28.01.2022
          'Condition ZPR0'
          'Condition ZPF0'
          'Condition ZIN1'
          'Condition K005'
          'Condition K007'
          'Condition ZDC1'
          'Condition ZFR1'
          'Condition ZTE1'
          'Condition MWAS'
          'Schedule line del.Dat'
          'Pricing Date'
          'Packing Type'
          'OFM Delivery Date'
          'Material Sales Text'
          'Infrastructure required'        "added by pankaj 31.01.2022
          'Validation Plan Refrence'          "added by pankaj 31.01.2022
          'Review Date'                      "added by pankaj 31.01.2022
          'Discussion Summary'                "added by pankaj 31.01.2022
          'Changed SO Date'
          'Port'                                   "added by pankaj 04.02.2022
          'Full Payment Desc'                     "added by pankaj 04.02.2022
          'Act Assignments'                       "added by pankaj 04.02.2022
          'User Status'
          'Condition Value ZPR0'                          "added by pankaj 04.02.2022
          'Freight'
          'PO SR NO Text'
          'Last changed date'
          'BOM Status'
          'Pending Items'
          'Reason for Pending Items'
          'Created By'                      ""Added by Pranit 27.03.2024
          'Created On'                      ""Added by Pranit 27.03.2024
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
    LS_FINAL-NAME1       = WA_OUTPUT-NAME1.
    LS_FINAL-VKBUR       = WA_OUTPUT-VKBUR.
    LS_FINAL-VBELN       = WA_OUTPUT-VBELN.
    LS_FINAL-STATUS      = WA_OUTPUT-STATUS.
    LS_FINAL-TAG_REQ     = WA_OUTPUT-TAG_REQ.
    LS_FINAL-TPI         = WA_OUTPUT-TPI.
    LS_FINAL-LD_TXT      = WA_OUTPUT-LD_TXT.
    LS_FINAL-ZLDPERWEEK  = WA_OUTPUT-ZLDPERWEEK.
    LS_FINAL-ZLDMAX      = WA_OUTPUT-ZLDMAX.
    LS_FINAL-MATNR       = WA_OUTPUT-MATNR.
    LS_FINAL-POSNR       = WA_OUTPUT-POSNR.
    LS_FINAL-ARKTX       = WA_OUTPUT-ARKTX.
*    ls_final-kalab       = abs( wa_output-stock_qty ).
    LS_FINAL-STOCK_QTY       = ABS( WA_OUTPUT-STOCK_QTY ).
    LS_FINAL-KWMENG      = ABS( WA_OUTPUT-KWMENG ).
    LS_FINAL-LFIMG       = ABS( WA_OUTPUT-LFIMG ).
    LS_FINAL-FKIMG       = ABS( WA_OUTPUT-FKIMG ).
    LS_FINAL-PND_QTY     = ABS( WA_OUTPUT-PND_QTY ).
    LS_FINAL-ETTYP       = WA_OUTPUT-ETTYP.
    LS_FINAL-KBETR       = WA_OUTPUT-KBETR.
    LS_FINAL-WAERK       = WA_OUTPUT-WAERK.
    LS_FINAL-CURR_CON    = WA_OUTPUT-CURR_CON.
    LS_FINAL-AMONT       = ABS( WA_OUTPUT-AMONT ).
    LS_FINAL-ORDR_AMT    = ABS( WA_OUTPUT-ORDR_AMT ).
    LS_FINAL-IN_PRICE    = ABS( WA_OUTPUT-IN_PRICE ).
    LS_FINAL-EST_COST    = ABS( WA_OUTPUT-EST_COST ).
    LS_FINAL-LATST_COST  = ABS( WA_OUTPUT-LATST_COST ).
    LS_FINAL-ST_COST     = ABS( WA_OUTPUT-ST_COST ).
*    LS_FINAL-ZPF0        = WA_OUTPUT-ZPF0.
**    LS_FINAL-ZPF0        = ABS( WA_OUTPUT-ZPF0 ).
*    LS_FINAL-ZIN1        = ABS( WA_OUTPUT-ZIN1 ).
*    LS_FINAL-K005        = ABS( WA_OUTPUT-K005 ).
*    LS_FINAL-K007        = ABS( WA_OUTPUT-K007 ).
*    LS_FINAL-ZDC1        = ABS( WA_OUTPUT-ZDC1 ).
*    LS_FINAL-ZFR1        = ABS(  WA_OUTPUT-ZDC1 ).
*    LS_FINAL-ZTE1        = ABS(  WA_OUTPUT-ZTE1 ).
*    LS_FINAL-MWAS        = ABS( WA_OUTPUT-MWAS  ).



    LS_FINAL-ZSERIES     = WA_OUTPUT-ZSERIES.
    LS_FINAL-ZSIZE       = WA_OUTPUT-ZSIZE.
    LS_FINAL-BRAND       = WA_OUTPUT-BRAND.
    LS_FINAL-MOC         = WA_OUTPUT-MOC.
    LS_FINAL-TYPE        = WA_OUTPUT-TYPE.
    LS_FINAL-DISPO       = WA_OUTPUT-DISPO.
    LS_FINAL-WIP         = WA_OUTPUT-WIP.
    LS_FINAL-MTART       = WA_OUTPUT-MTART.
    LS_FINAL-KDMAT       = WA_OUTPUT-KDMAT.
    LS_FINAL-KUNNR       = WA_OUTPUT-KUNNR.
    LS_FINAL-QMQTY       = ABS( WA_OUTPUT-QMQTY ).
    LS_FINAL-MATTXT      = WA_OUTPUT-MATTXT.
    LS_FINAL-SU_CUST      = WA_OUTPUT-SU_CUST.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN LS_FINAL-MATTXT WITH ' & '.
    LS_FINAL-ITMTXT      = WA_OUTPUT-ITMTXT.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN LS_FINAL-ITMTXT WITH ' & '.
    LS_FINAL-ETENR       = WA_OUTPUT-ETENR.
    LS_FINAL-SCHID       = WA_OUTPUT-SCHID.
    LS_FINAL-SO_EXC      = WA_OUTPUT-SO_EXC.
    LS_FINAL-ZTERM       = WA_OUTPUT-ZTERM.
    LS_FINAL-TEXT1       = WA_OUTPUT-TEXT1.
    LS_FINAL-INCO1       = WA_OUTPUT-INCO1.
    LS_FINAL-INCO2       = WA_OUTPUT-INCO2.
    LS_FINAL-OFM         = WA_OUTPUT-OFM.
    LS_FINAL-OFM_DATE    = WA_OUTPUT-OFM_DATE.
    LS_FINAL-SPL         = WA_OUTPUT-SPL.
    LS_FINAL-WRKST       = WA_OUTPUT-WRKST.
    LS_FINAL-ABGRU       = WA_OUTPUT-ABGRU.
    LS_FINAL-BEZEI       = WA_OUTPUT-BEZEI.
*    LS_FINAL-CGST        = WA_OUTPUT-CGST.
*    IF LS_FINAL-CGST IS INITIAL .
*      CONCATENATE  '0' LS_FINAL-CGST INTO LS_FINAL-CGST.
*    ENDIF.
*    LS_FINAL-SGST        = WA_OUTPUT-SGST.
*    IF LS_FINAL-SGST IS INITIAL .
*      CONCATENATE  '0' LS_FINAL-SGST INTO LS_FINAL-SGST.
*    ENDIF.
*    LS_FINAL-IGST        = WA_OUTPUT-IGST.
*    IF LS_FINAL-IGST IS INITIAL .
*      CONCATENATE  '0' LS_FINAL-IGST INTO LS_FINAL-IGST.
*    ENDIF.
*    ls_final-cgst_val    = wa_output-cgst_val.
*    ls_final-sgst_val    = wa_output-sgst_val.
*    ls_final-igst_val    = wa_output-igst_val.
    LS_FINAL-SHIP_KUNNR    = WA_OUTPUT-SHIP_KUNNR.
    LS_FINAL-SHIP_KUNNR_N  = WA_OUTPUT-SHIP_KUNNR_N.
    LS_FINAL-SHIP_REG_N    = WA_OUTPUT-SHIP_REG_N.
    LS_FINAL-SOLD_REG_N    = WA_OUTPUT-SOLD_REG_N.
    LS_FINAL-SHIP_LAND     = WA_OUTPUT-SHIP_LAND.
    LS_FINAL-S_LAND_DESC   = WA_OUTPUT-S_LAND_DESC.
    LS_FINAL-SOLD_LAND     =  WA_OUTPUT-SOLD_LAND.
    LS_FINAL-NORMT          = WA_OUTPUT-NORMT.
    LS_FINAL-POSEX          = WA_OUTPUT-POSEX.

    LS_FINAL-LIFSK          = WA_OUTPUT-LIFSK.
    LS_FINAL-VTEXT          = WA_OUTPUT-VTEXT.
    LS_FINAL-INSUR          = WA_OUTPUT-INSUR .
    LS_FINAL-PARDEL         = WA_OUTPUT-PARDEL.
    LS_FINAL-GAD            = WA_OUTPUT-GAD.
*    LS_FINAL-TCS            = WA_OUTPUT-TCS.
*    LS_FINAL-TCS_AMT        = WA_OUTPUT-TCS_AMT.
    LS_FINAL-KWERT        = WA_OUTPUT-KWERT.
    REPLACE ALL OCCURRENCES OF ',' IN LS_FINAL-KWERT WITH SPACE.CONDENSE LS_FINAL-KWERT.

    LS_FINAL-CTBG          = WA_OUTPUT-CTBG.
    LS_FINAL-CERTIF         = WA_OUTPUT-CERTIF.
*    ls_final-ctbg         = wa_output-ctbg.


    IF WA_OUTPUT-BSTDK IS NOT INITIAL AND WA_OUTPUT-BSTDK NE '00000000' .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-BSTDK
        IMPORTING
          OUTPUT = LS_FINAL-BSTDK.
      CONCATENATE LS_FINAL-BSTDK+0(2) LS_FINAL-BSTDK+2(3) LS_FINAL-BSTDK+5(4)
                     INTO LS_FINAL-BSTDK SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-ERDAT IS NOT INITIAL  AND WA_OUTPUT-ERDAT NE '00000000' .  .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-ERDAT
        IMPORTING
          OUTPUT = LS_FINAL-ERDAT.
      CONCATENATE LS_FINAL-ERDAT+0(2) LS_FINAL-ERDAT+2(3) LS_FINAL-ERDAT+5(4)
                     INTO LS_FINAL-ERDAT SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-VDATU IS NOT INITIAL AND WA_OUTPUT-VDATU NE '00000000' .  .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-VDATU
        IMPORTING
          OUTPUT = LS_FINAL-VDATU.
      CONCATENATE LS_FINAL-VDATU+0(2) LS_FINAL-VDATU+2(3) LS_FINAL-VDATU+5(4)
                     INTO LS_FINAL-VDATU SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-HOLDDATE IS NOT INITIAL  AND WA_OUTPUT-HOLDDATE NE '00000000' .  .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-HOLDDATE
        IMPORTING
          OUTPUT = LS_FINAL-HOLDDATE.
      CONCATENATE LS_FINAL-HOLDDATE+0(2) LS_FINAL-HOLDDATE+2(3) LS_FINAL-HOLDDATE+5(4)
                     INTO LS_FINAL-HOLDDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-RELDATE IS NOT INITIAL AND WA_OUTPUT-RELDATE NE '00000000' .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-RELDATE
        IMPORTING
          OUTPUT = LS_FINAL-RELDATE.
      CONCATENATE LS_FINAL-RELDATE+0(2) LS_FINAL-RELDATE+2(3) LS_FINAL-RELDATE+5(4)
                     INTO LS_FINAL-RELDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-CANCELDATE IS NOT INITIAL  AND WA_OUTPUT-CANCELDATE NE '00000000' . .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-CANCELDATE
        IMPORTING
          OUTPUT = LS_FINAL-CANCELDATE.
      CONCATENATE LS_FINAL-CANCELDATE+0(2) LS_FINAL-CANCELDATE+2(3) LS_FINAL-CANCELDATE+5(4)
                     INTO LS_FINAL-CANCELDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-DELDATE IS NOT INITIAL AND WA_OUTPUT-DELDATE NE '00000000' .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-DELDATE
        IMPORTING
          OUTPUT = LS_FINAL-DELDATE.
      CONCATENATE LS_FINAL-DELDATE+0(2) LS_FINAL-DELDATE+2(3) LS_FINAL-DELDATE+5(4)
                     INTO LS_FINAL-DELDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-CUSTDELDATE IS NOT INITIAL AND WA_OUTPUT-CUSTDELDATE NE '00000000' .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-CUSTDELDATE
        IMPORTING
          OUTPUT = LS_FINAL-CUSTDELDATE.
      CONCATENATE LS_FINAL-CUSTDELDATE+0(2) LS_FINAL-CUSTDELDATE+2(3) LS_FINAL-CUSTDELDATE+5(4)
                     INTO LS_FINAL-CUSTDELDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-PO_DEL_DATE IS NOT INITIAL AND WA_OUTPUT-PO_DEL_DATE  NE '00000000'.                         "Added By Snehal Rajale On 28 jan 2021
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-PO_DEL_DATE
        IMPORTING
          OUTPUT = LS_FINAL-PO_DEL_DATE.
      CONCATENATE LS_FINAL-PO_DEL_DATE+0(2) LS_FINAL-PO_DEL_DATE+2(3) LS_FINAL-PO_DEL_DATE+5(4)
      INTO LS_FINAL-PO_DEL_DATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-ZLDFROMDATE IS NOT INITIAL  AND  WA_OUTPUT-ZLDFROMDATE    NE '00000000'.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-ZLDFROMDATE
        IMPORTING
          OUTPUT = LS_FINAL-ZLDFROMDATE.
      CONCATENATE LS_FINAL-ZLDFROMDATE+0(2) LS_FINAL-ZLDFROMDATE+2(3) LS_FINAL-ZLDFROMDATE+5(4)
                     INTO LS_FINAL-ZLDFROMDATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-MRP_DT IS NOT INITIAL AND  WA_OUTPUT-MRP_DT NE '00000000' .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-MRP_DT
        IMPORTING
          OUTPUT = LS_FINAL-MRP_DT.
      CONCATENATE LS_FINAL-MRP_DT+0(2) LS_FINAL-MRP_DT+2(3) LS_FINAL-MRP_DT+5(4)
                     INTO LS_FINAL-MRP_DT SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-EDATU IS NOT INITIAL AND WA_OUTPUT-EDATU    NE '00000000' .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-EDATU
        IMPORTING
          OUTPUT = LS_FINAL-EDATU.
      CONCATENATE LS_FINAL-EDATU+0(2) LS_FINAL-EDATU+2(3) LS_FINAL-EDATU+5(4)
                     INTO LS_FINAL-EDATU SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-IN_PR_DT IS NOT INITIAL AND WA_OUTPUT-IN_PR_DT NE '00000000' .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-IN_PR_DT
        IMPORTING
          OUTPUT = LS_FINAL-IN_PR_DT.
      CONCATENATE LS_FINAL-IN_PR_DT+0(2) LS_FINAL-IN_PR_DT+2(3) LS_FINAL-IN_PR_DT+5(4)
                     INTO LS_FINAL-IN_PR_DT SEPARATED BY '-'.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = LS_FINAL-REF_DT.
    CONCATENATE LS_FINAL-REF_DT+0(2) LS_FINAL-REF_DT+2(3) LS_FINAL-REF_DT+5(4)
                   INTO LS_FINAL-REF_DT SEPARATED BY '-'.

    LS_FINAL-OFM_NO = WA_OUTPUT-OFM_NO .

    CONDENSE LS_FINAL-KWMENG.
    IF WA_OUTPUT-KWMENG < 0.
      CONCATENATE '-' LS_FINAL-KWMENG INTO LS_FINAL-KWMENG.
    ENDIF.

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

    CONDENSE LS_FINAL-QMQTY.
    IF WA_OUTPUT-QMQTY < 0.
      CONCATENATE '-' LS_FINAL-QMQTY INTO LS_FINAL-QMQTY.
    ENDIF.

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


    CONDENSE LS_FINAL-IN_PRICE.
    IF WA_OUTPUT-IN_PRICE < 0.
      CONCATENATE '-' LS_FINAL-IN_PRICE INTO LS_FINAL-IN_PRICE.
    ENDIF.

    CONDENSE LS_FINAL-EST_COST.
    IF WA_OUTPUT-EST_COST < 0.
      CONCATENATE '-' LS_FINAL-EST_COST INTO LS_FINAL-EST_COST.
    ENDIF.

    CONDENSE LS_FINAL-LATST_COST.
    IF WA_OUTPUT-LATST_COST < 0.
      CONCATENATE '-' LS_FINAL-LATST_COST INTO LS_FINAL-LATST_COST.
    ENDIF.

    CONDENSE LS_FINAL-ST_COST.
    IF WA_OUTPUT-ST_COST < 0.
      CONCATENATE '-' LS_FINAL-ST_COST INTO LS_FINAL-ST_COST.
    ENDIF.

*    CONDENSE ls_final-wip.
*    IF ls_final-wip < 0.
*      CONCATENATE '-' ls_final-wip INTO ls_final-wip.
*
*    ENDIF.
    LS_FINAL-ITEM_TYPE         = WA_OUTPUT-ITEM_TYPE. "edited by PJ on 16-08-21
    LS_FINAL-REF_TIME          = WA_OUTPUT-REF_TIME. "edited by PJ on 08-09-21


    """""""""code added by pankaj 28.01.2022"""""""""""""""""""""""""""""""""""

    LS_FINAL-PROJ          = WA_OUTPUT-PROJ .

    LS_FINAL-COND          = WA_OUTPUT-COND .

    IF WA_OUTPUT-RECEIPT_DATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-RECEIPT_DATE
        IMPORTING
          OUTPUT = LS_FINAL-RECEIPT_DATE.
      CONCATENATE LS_FINAL-RECEIPT_DATE+0(2) LS_FINAL-RECEIPT_DATE+2(3) LS_FINAL-RECEIPT_DATE+5(4)
                     INTO LS_FINAL-RECEIPT_DATE SEPARATED BY '-'.
    ENDIF.

    LS_FINAL-REASON      = WA_OUTPUT-REASON.
    LS_FINAL-NTGEW      = WA_OUTPUT-NTGEW.
    LS_FINAL-ZPR0        = ABS( WA_OUTPUT-ZPR0 ).
    CONDENSE LS_FINAL-ZPR0.
    IF WA_OUTPUT-ZPR0 < 0.
      CONCATENATE '-' LS_FINAL-ZPR0 INTO LS_FINAL-ZPR0.
    ENDIF.
    LS_FINAL-ZPF0        = ABS( WA_OUTPUT-ZPF0 ).
    CONDENSE LS_FINAL-ZPF0.
    IF WA_OUTPUT-ZPF0 < 0.
      CONCATENATE '-' LS_FINAL-ZPF0 INTO LS_FINAL-ZPF0.
    ENDIF.
*
    LS_FINAL-ZIN1        = ABS( WA_OUTPUT-ZIN1 ).
    CONDENSE LS_FINAL-ZIN1.
    IF WA_OUTPUT-ZIN1 < 0.
      CONCATENATE '-' LS_FINAL-ZIN1 INTO LS_FINAL-ZIN1.
    ENDIF.

    LS_FINAL-K005   = ABS( WA_OUTPUT-K005 ).
    CONDENSE LS_FINAL-K005.
    IF WA_OUTPUT-K005 < 0.
      CONCATENATE '-' LS_FINAL-K005 INTO LS_FINAL-K005.
    ENDIF.

    LS_FINAL-K007        = ABS( WA_OUTPUT-K007 ).
    CONDENSE LS_FINAL-K007.
    IF WA_OUTPUT-K007 < 0.
      CONCATENATE '-' LS_FINAL-K007 INTO LS_FINAL-K007.
    ENDIF.
    LS_FINAL-ZDC1        = ABS( WA_OUTPUT-ZDC1 ).
    CONDENSE LS_FINAL-ZDC1.
    IF WA_OUTPUT-ZDC1 < 0.
      CONCATENATE '-' LS_FINAL-ZDC1 INTO LS_FINAL-ZDC1.
    ENDIF.

    LS_FINAL-ZFR1        = ABS( WA_OUTPUT-ZFR1 ).
    CONDENSE LS_FINAL-ZFR1.
    IF WA_OUTPUT-ZFR1 < 0.
      CONCATENATE '-' LS_FINAL-ZFR1 INTO LS_FINAL-ZFR1.
    ENDIF.

    LS_FINAL-ZTE1        = ABS( WA_OUTPUT-ZTE1 ).
    CONDENSE LS_FINAL-ZTE1.
    IF WA_OUTPUT-ZTE1 < 0.
      CONCATENATE '-' LS_FINAL-ZTE1 INTO LS_FINAL-ZTE1.
    ENDIF.
*    LS_FINAL-ZFR1        = WA_OUTPUT-ZDC1.
*    LS_FINAL-ZTE1        = WA_OUTPUT-ZTE1.
    LS_FINAL-MWAS        = ABS( WA_OUTPUT-MWAS ).
    CONDENSE LS_FINAL-MWAS.
    IF WA_OUTPUT-MWAS < 0.
      CONCATENATE '-' LS_FINAL-MWAS INTO LS_FINAL-MWAS.
    ENDIF.


    IF WA_OUTPUT-DATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-DATE
        IMPORTING
          OUTPUT = LS_FINAL-DATE.
      CONCATENATE LS_FINAL-DATE+0(2) LS_FINAL-DATE+2(3) LS_FINAL-DATE+5(4)
                     INTO LS_FINAL-DATE SEPARATED BY '-'.
    ENDIF.


    IF WA_OUTPUT-PRSDT IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-PRSDT
        IMPORTING
          OUTPUT = LS_FINAL-PRSDT.
      CONCATENATE LS_FINAL-PRSDT+0(2) LS_FINAL-PRSDT+2(3) LS_FINAL-PRSDT+5(4)
                     INTO LS_FINAL-PRSDT  SEPARATED BY '-'.
    ENDIF.

    LS_FINAL-PACKING_TYPE = WA_OUTPUT-PACKING_TYPE.


    IF WA_OUTPUT-OFM_DATE1 IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-OFM_DATE1
        IMPORTING
          OUTPUT = LS_FINAL-OFM_DATE1.
      CONCATENATE LS_FINAL-OFM_DATE1+0(2) LS_FINAL-OFM_DATE1+2(3) LS_FINAL-OFM_DATE1+5(4)
                     INTO LS_FINAL-OFM_DATE1 SEPARATED BY '-'.
    ELSE .
      LS_FINAL-OFM_DATE1 = SPACE.
    ENDIF.

    LS_FINAL-MAT_TEXT = WA_OUTPUT-MAT_TEXT.


    """"""" code added by pankaj 31.01.2022"""""""""

    LS_FINAL-INFRA        = WA_OUTPUT-INFRA.
    LS_FINAL-VALIDATION   = WA_OUTPUT-VALIDATION.

    IF WA_OUTPUT-REVIEW_DATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-REVIEW_DATE
        IMPORTING
          OUTPUT = LS_FINAL-REVIEW_DATE.
      CONCATENATE LS_FINAL-REVIEW_DATE+0(2) LS_FINAL-REVIEW_DATE+2(3) LS_FINAL-REVIEW_DATE+5(4)
                     INTO LS_FINAL-REVIEW_DATE  SEPARATED BY '-'.
    ENDIF.

    LS_FINAL-REVIEW_DATE = WA_OUTPUT-REVIEW_DATE.

    LS_FINAL-DISS_SUMMARY = WA_OUTPUT-DISS_SUMMARY .

    IF WA_OUTPUT-CHANG_SO_DATE IS NOT INITIAL .
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-CHANG_SO_DATE
        IMPORTING
          OUTPUT = LS_FINAL-CHANG_SO_DATE.
      CONCATENATE LS_FINAL-CHANG_SO_DATE+0(2) LS_FINAL-CHANG_SO_DATE+2(3) LS_FINAL-CHANG_SO_DATE+5(4)
                     INTO LS_FINAL-CHANG_SO_DATE SEPARATED BY '-'.
    ENDIF.

    LS_FINAL-ERNAM = WA_OUTPUT-ERNAM.      """Added by Pranit 27.03.2024

    LS_FINAL-ERDAT1 = LS_FINAL-ERDAT .     """Added by Pranit 27.03.2024

    """""""""""""" code added by pankaj 04.02.2022

    LS_FINAL-PORT      = WA_OUTPUT-PORT .
    LS_FINAL-FULL_PMNT = WA_OUTPUT-FULL_PMNT .
    LS_FINAL-ACT_ASS   = WA_OUTPUT-ACT_ASS .
    LS_FINAL-TXT04     = WA_OUTPUT-TXT04 .
    LS_FINAL-FREIGHT  = WA_OUTPUT-FREIGHT.
    " ls_final-ofm_sr_no = wa_output-OFM_SR_NO.
    LS_FINAL-PO_SR_NO = WA_OUTPUT-PO_SR_NO.
    LS_FINAL-UDATE = WA_OUTPUT-UDATE.
    LS_FINAL-BOM = WA_OUTPUT-BOM.
    LS_FINAL-ZPEN_ITEM = WA_OUTPUT-ZPEN_ITEM.
    LS_FINAL-ZRE_PEN_ITEM = WA_OUTPUT-ZRE_PEN_ITEM.
*    ls_final-vtext1 = wa_output-vtext1.

    """"""" endded """""""""""""""""""

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
*     i_tab_sap_data       = gt_final
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
  LV_FILE = 'ZSU_DELPENDSOALL.TXT'.

*  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_DELPENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
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
*****  IF sy-subrc = 0.
*****    TRANSFER hd_csv TO lv_fullfile.
*****    LOOP AT it_csv INTO wa_csv.
*****      IF sy-subrc = 0.
*****        TRANSFER wa_csv TO lv_fullfile.
*****
*****      ENDIF.
*****    ENDLOOP.
*****    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*****    MESSAGE lv_msg TYPE 'S'.
*****  ENDIF.


  """""""""""""" ++ NC """"""""""""""""""""


  IF SY-SUBRC = 0.
    DATA LV_STRING_265 TYPE STRING.
    DATA LV_CRLF_265 TYPE STRING.

    LV_CRLF_265 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_265 = HD_CSV.

*    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_265  LV_CRLF_265   WA_CSV INTO LV_STRING_265 .
      CLEAR: WA_CSV.
    ENDLOOP.

    TRANSFER LV_STRING_265 TO LV_FULLFILE.
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

**lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZSU_DELPENDSOALL.TXT'.

*  CONCATENATE p_folder '\' lv_file
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSU_PENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
****  IF sy-subrc = 0.
****    TRANSFER hd_csv TO lv_fullfile.
****    LOOP AT it_csv INTO wa_csv.
****      IF sy-subrc = 0.
****        TRANSFER wa_csv TO lv_fullfile.
****
****      ENDIF.
****    ENDLOOP.
****    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
****    MESSAGE lv_msg TYPE 'S'.
****  ENDIF.


  """""""""""""""" ++ NC """""""""""""""""""""""""


  IF SY-SUBRC = 0.
    DATA LV_STRING_266 TYPE STRING.
    DATA LV_CRLF_266 TYPE STRING.

    LV_CRLF_266 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_266 = HD_CSV.

*    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_266  LV_CRLF_266   WA_CSV INTO LV_STRING_266 .
      CLEAR: WA_CSV.
    ENDLOOP.

    TRANSFER LV_STRING_266 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

ENDFORM.
