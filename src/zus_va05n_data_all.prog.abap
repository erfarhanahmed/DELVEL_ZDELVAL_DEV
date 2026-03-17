*&---------------------------------------------------------------------*
*&  Include           ZUS_VA05N_DATA_ALL
*&---------------------------------------------------------------------*
FORM  GET_DATA .

  SELECT  A~VBELN,
          A~ERNAM,
          A~ERDAT,
          A~BSTDK,
          A~BSTNK,
          A~VKBUR,
          A~VKORG,
          A~AUART,
          A~VDATU,
          A~NETWR,
          B~INCO1,
          B~INCO2,
          B~ZTERM
     FROM VBAK AS A INNER JOIN VBKD AS B
     ON    A~VBELN EQ B~VBELN
     WHERE A~VBELN IN @S_VBELN
     AND   A~AUART IN @S_AUART
     AND   A~KUNNR IN @S_KUNNR
     AND   A~AUDAT IN @S_AUDAT
     AND   A~BSTNK IN @S_BSTNK
     AND   A~VKORG EQ @C_VKORG
     INTO TABLE @DATA(IT_DATA).

  SORT IT_DATA BY VBELN.
  DELETE ADJACENT DUPLICATES FROM IT_DATA COMPARING VBELN.

  SELECT A~VBELN,                                          """"LOGIC FOR PENDING AMT COLUMN()
       A~POSNR,
       A~ERDAT,
       A~MATNR,
       A~WERKS,
       A~ERZET,
       A~KWMENG,
       A~DELDATE,
       A~NETPR,
       C~LFSTA
FROM VBAP AS A
JOIN VBAP AS C ON C~VBELN = A~VBELN
              AND C~POSNR = A~POSNR
FOR ALL ENTRIES IN @IT_DATA
WHERE A~VBELN =  @IT_DATA-VBELN
AND   A~ABGRU =  @SPACE
AND   C~LFSTA NE @C
AND   C~GBSTA NE @C
INTO TABLE @DATA(IT_DATA_NEW).


  SELECT VBELN,
         POSNR,
         WERKS,
         CUSTDELDATE,
         DELDATE
  FROM VBAP
  FOR ALL ENTRIES IN @IT_DATA
  WHERE VBELN = @IT_DATA-VBELN
  AND   WERKS IN @S_WERKS
  INTO TABLE @DATA(IT_VBAP).

  DATA(IT_VBAP_N) = IT_VBAP.
  DELETE IT_VBAP_N WHERE DELDATE = '00000000'.
  SORT IT_VBAP_N ASCENDING BY DELDATE.

  IF IT_VBAP IS INITIAL .
*    MESSAGE |NO DATA FOUND| TYPE 'E'.
    MESSAGE E001(ZUS_DEL_MESSAGE).
  ENDIF.

  SELECT A~VBELV,
         A~VBELN,
         A~VBTYP_N,
         B~NETWR
    FROM VBFA AS A INNER JOIN VBRK AS B
    ON A~VBELN EQ B~VBELN
    FOR ALL ENTRIES IN @IT_DATA
    WHERE A~VBELV = @IT_DATA-VBELN
    AND   B~VBTYP IN ( 'M','P','O' )
    AND   B~RFBSK NE 'E'
    AND   B~FKSTO NE 'X'
    INTO TABLE @DATA(IT_VBFA).

  IF IT_VBAP IS NOT INITIAL.

    SELECT AUBEL,
           FKIMG,
           POSNR
      FROM VBRP
      FOR ALL ENTRIES IN @IT_DATA
      WHERE AUBEL = @IT_DATA-VBELN
      AND   WERKS IN @S_WERKS
      INTO TABLE @DATA(IT_VBRP).

    SELECT A~AUBEL,
           A~POSNR,
           A~VBELN,
           B~FKSTO
*          b~netwr
    FROM VBRP AS A INNER JOIN VBRK AS B
    ON A~VBELN EQ B~VBELN
    FOR ALL ENTRIES IN @IT_DATA1
    WHERE A~AUBEL = @IT_DATA1-VBELN
    INTO TABLE @DATA(IT_VBRP_NEW).

    DELETE IT_VBRP_NEW  WHERE FKSTO = SPACE.

    SELECT A~VBELN,
           A~PARVW,
           A~KUNNR,
           A~ADRNR,
           B~NAME1,
           B~STREET,
           B~POST_CODE1,
           B~CITY1,
           B~REGION,
           B~COUNTRY
      FROM VBPA AS A INNER JOIN ADRC AS B
      ON A~ADRNR EQ B~ADDRNUMBER
      FOR ALL ENTRIES IN @IT_DATA
      WHERE VBELN = @IT_DATA-VBELN
      INTO TABLE @DATA(IT_VBPA).

    SELECT A~VBELN,
           A~PARVW,
           A~KUNNR,
           A~ADRNR,
           B~NAME1,
           B~STREET,
           B~POST_CODE1,
           B~CITY1,
           B~REGION,
           B~COUNTRY,
           C~BEZEI
        FROM VBPA AS A INNER JOIN ADRC AS B
        ON A~ADRNR EQ B~ADDRNUMBER
        INNER JOIN T005U AS C
        ON B~REGION EQ C~BLAND
        FOR ALL ENTRIES IN @IT_DATA
        WHERE VBELN = @IT_DATA-VBELN
        AND A~PARVW EQ 'WE'
        INTO TABLE @DATA(IT_VBPA_1).
*
*
*    DATA(it_vbpa_new) = it_vbpa[].
*    DELETE it_vbpa_new WHERE parvw NE 'WE'.

    IF IT_VBPA IS NOT INITIAL.
      SELECT SPRAS,
             LAND1,
             BLAND,
             BEZEI
      FROM T005U
      FOR ALL ENTRIES IN @IT_VBPA_1
      WHERE BLAND = @IT_VBPA_1-REGION
      AND SPRAS EQ @C_SPRAS
      AND LAND1 EQ @IT_VBPA_1-COUNTRY
      INTO TABLE @DATA(IT_T005U).

      SELECT SPRAS,
             LAND1,
             LANDX
      FROM T005T
      FOR ALL ENTRIES IN @IT_VBPA_1
      WHERE LAND1 = @IT_VBPA_1-COUNTRY
      AND SPRAS EQ @C_SPRAS
*      AND land1 EQ @c_land
      INTO TABLE @DATA(IT_T005T).
    ENDIF.

    SELECT ZTERM,
           VTEXT
      FROM TVZBT
      FOR ALL ENTRIES IN @IT_DATA
      WHERE ZTERM = @IT_DATA-ZTERM
      INTO TABLE @DATA(IT_TVZBT).

  ENDIF.

  LOOP AT IT_DATA INTO DATA(WA_DATA).
    WA_FINAL-VBELN =   WA_DATA-VBELN.
    WA_FINAL-ERDAT =   WA_DATA-ERDAT.
    WA_FINAL-ERNAM =   WA_DATA-ERNAM.
    WA_FINAL-AUART =   WA_DATA-AUART.
    WA_FINAL-BSTDK =   WA_DATA-BSTDK.
    WA_FINAL-BSTNK =   WA_DATA-BSTNK.
    WA_FINAL-VKBUR =   WA_DATA-VKBUR.
    WA_FINAL-INCO1 =   WA_DATA-INCO1.
    WA_FINAL-INCO2 =   WA_DATA-INCO2.
    WA_FINAL-ZTERM =   WA_DATA-ZTERM.
    WA_FINAL-VDATU =   WA_DATA-VDATU.
    WA_FINAL-NET_VALUE =   WA_DATA-NETWR.

    READ TABLE IT_VBPA INTO DATA(WA_VBPA) WITH KEY VBELN = WA_FINAL-VBELN PARVW = 'AG' .
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR = WA_VBPA-KUNNR.
      WA_FINAL-NAME1 = WA_VBPA-NAME1.
      WA_FINAL-SH_REGION  = WA_VBPA-REGION.
    ENDIF.

    READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_FINAL-VBELN PARVW = 'WE' .
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR_SH   = WA_VBPA-KUNNR.
      WA_FINAL-NAME1_SH   = WA_VBPA-NAME1.
      WA_FINAL-STREET     = WA_VBPA-STREET.
      WA_FINAL-POST_CODE1 = WA_VBPA-POST_CODE1.
      WA_FINAL-CITY1      = WA_VBPA-CITY1.
    ENDIF.

    READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_FINAL-VBELN PARVW = 'UR'.
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR_UR = WA_VBPA-KUNNR.
      WA_FINAL-NAME1_UR = WA_VBPA-NAME1.
    ENDIF.

    READ TABLE IT_TVZBT INTO DATA(WA_TVZBT) WITH KEY ZTERM = WA_FINAL-ZTERM .
    IF SY-SUBRC = 0.
      WA_FINAL-VTEXT = WA_TVZBT-VTEXT.
    ENDIF.

    READ TABLE IT_VBAP INTO DATA(WA_VBAP) WITH KEY VBELN = WA_FINAL-VBELN .
    IF SY-SUBRC = 0.
      WA_FINAL-WERKS       = WA_VBAP-WERKS.
      WA_FINAL-CUSTDELDATE = WA_VBAP-CUSTDELDATE.
    ENDIF.

    READ TABLE IT_VBAP_N INTO DATA(WA_VBAP_N) WITH KEY VBELN = WA_FINAL-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-DELDATE     = WA_VBAP_N-DELDATE.
    ENDIF.

    READ TABLE IT_VBPA_1 INTO DATA(WA_VBPA_1) WITH KEY VBELN = WA_FINAL-VBELN .

    READ TABLE IT_T005U INTO DATA(WA_T005U) WITH KEY BLAND = WA_VBPA_1-REGION .
    IF SY-SUBRC = 0.
      WA_FINAL-BEZEI = WA_T005U-BEZEI.
    ENDIF.

    READ TABLE IT_T005T INTO DATA(WA_T005T) WITH KEY LAND1 = WA_VBPA_1-COUNTRY .
    IF SY-SUBRC = 0.
      WA_FINAL-LANDX = WA_T005T-LANDX.
    ENDIF.

    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'U007'
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

    READ TABLE LV_LINES INTO WA_LINES INDEX 1.
    IF SY-SUBRC = 0.
      WA_FINAL-OFM_DATE = WA_LINES-TDLINE.
    ENDIF.

    """"""""""""""""""""
    CLEAR: LV_LINES, WA_LINES.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-VBELN.
    IF LV_NAME  IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'U008'
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
    ENDIF.
    IF LV_LINES IS NOT INITIAL.
      LOOP AT LV_LINES INTO WA_LINES.
        IF WA_LINES-TDLINE IS NOT INITIAL.
          CONCATENATE WA_FINAL-DEL_REMARK WA_LINES-TDLINE INTO WA_FINAL-DEL_REMARK SEPARATED BY SPACE.
        ENDIF.
      ENDLOOP.
    ENDIF.
**************************************************************

    DATA LV_NETWR TYPE NETWR.
    LOOP AT IT_VBFA ASSIGNING FIELD-SYMBOL(<FS_VBFA>) WHERE VBELV = WA_FINAL-VBELN.                 """loop for addition for netwr so wise
      LV_NETWR = LV_NETWR +  <FS_VBFA>-NETWR.
    ENDLOOP.

    WA_FINAL-PENDSO_AMT = WA_FINAL-NET_VALUE - LV_NETWR.                                            """ Pendso amt = order amt - netwr
    LV_ORD_AMT          =   WA_FINAL-NET_VALUE .
    LV_PEND_AMT         =   WA_FINAL-PENDSO_AMT.

*    IF wa_final-order_amt LE lv_netwr.
*      DATA lv_data TYPE string.
*      LOOP AT it_data_new ASSIGNING FIELD-SYMBOL(<fs_data_new>) WHERE vbeln = wa_final-vbeln.
*        lv_data = <fs_data_new>-kwmeng * <fs_data_new>-netpr + lv_data.
*      ENDLOOP.
*       CLEAR wa_final-pendso_amt.
*    wa_final-pendso_amt = lv_data.
*    ENDIF.

    IF WA_FINAL-AUART EQ 'US08'.                     """FREE OF CHARGE
      WA_FINAL-NET_VALUE  = 0.
      WA_FINAL-PENDSO_AMT = 0 .
    ENDIF.
*    BREAK PRIMUSABAP.
    IF WA_FINAL-AUART EQ 'US12' AND WA_FINAL-NET_VALUE > 0.                      """CONSIGNMENT AND PICKUP
      WA_FINAL-NET_VALUE  = - LV_ORD_AMT  .
      WA_FINAL-PENDSO_AMT = - LV_PEND_AMT .
    ENDIF.

    IF WA_FINAL-NET_VALUE < 0.                                                     """fm use negative sign in front
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = WA_FINAL-NET_VALUE.
    ENDIF.

    IF WA_FINAL-PENDSO_AMT < 0 .
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = WA_FINAL-PENDSO_AMT.
    ENDIF.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR :WA_FINAL,LV_NETWR.",lv_uhf1,lv_2,lv_usc1,lv_umc1,lv_usc1_kwert,lv_usc1_new,lv_usc1_1,LV_counter.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING ALL FIELDS.
  DELETE IT_FINAL WHERE WERKS = C_INDIA.
  DELETE IT_FINAL WHERE WERKS = C_SAUDI.

  IF P_DOWN = 'X'.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-VBELN             =  WA_FINAL-VBELN           .
      WA_DOWN-ERNAM             =  WA_FINAL-ERNAM           .

      IF WA_FINAL-ERDAT  IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-ERDAT
          IMPORTING
            OUTPUT = WA_DOWN-ERDAT.

        CONCATENATE WA_DOWN-ERDAT+0(2) WA_DOWN-ERDAT+2(3) WA_DOWN-ERDAT+5(4)
                        INTO WA_DOWN-ERDAT SEPARATED BY '-'.
      ENDIF.

      IF WA_FINAL-BSTDK  IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-BSTDK
          IMPORTING
            OUTPUT = WA_DOWN-BSTDK.

        CONCATENATE WA_DOWN-BSTDK+0(2) WA_DOWN-BSTDK+2(3) WA_DOWN-BSTDK+5(4)
                        INTO WA_DOWN-BSTDK SEPARATED BY '-'.
      ENDIF.

      WA_DOWN-BSTNK             =  WA_FINAL-BSTNK           .
      WA_DOWN-VKBUR             =  WA_FINAL-VKBUR           .
      WA_DOWN-AUART             =  WA_FINAL-AUART           .
      WA_DOWN-INCO1             =  WA_FINAL-INCO1           .
      WA_DOWN-INCO2             =  WA_FINAL-INCO2           .
      WA_DOWN-ZTERM             =  WA_FINAL-ZTERM           .
      WA_DOWN-KUNNR             =  WA_FINAL-KUNNR           .
      WA_DOWN-NAME1             =  WA_FINAL-NAME1           .
      WA_DOWN-KUNNR_SH          =  WA_FINAL-KUNNR_SH        .
      WA_DOWN-NAME1_SH          =  WA_FINAL-NAME1_SH        .
      WA_DOWN-STREET            =  WA_FINAL-STREET          .
      WA_DOWN-POST_CODE1        =  WA_FINAL-POST_CODE1      .
      WA_DOWN-CITY1             =  WA_FINAL-CITY1           .
      WA_DOWN-KUNNR_UR          =  WA_FINAL-KUNNR_UR        .
      WA_DOWN-NAME1_UR          =  WA_FINAL-NAME1_UR        .
      WA_DOWN-VTEXT             =  WA_FINAL-VTEXT           .
      WA_DOWN-WERKS             =  WA_FINAL-WERKS           .
      WA_DOWN-DEL_REMARK        =  WA_FINAL-DEL_REMARK      .

      IF WA_FINAL-DELDATE  IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-DELDATE
          IMPORTING
            OUTPUT = WA_DOWN-DELDATE.

        CONCATENATE WA_DOWN-DELDATE+0(2) WA_DOWN-DELDATE+2(3) WA_DOWN-DELDATE+5(4)
                        INTO WA_DOWN-DELDATE SEPARATED BY '-'.
      ENDIF.

      IF WA_FINAL-CUSTDELDATE  IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-CUSTDELDATE
          IMPORTING
            OUTPUT = WA_DOWN-CUSTDELDATE.

        CONCATENATE WA_DOWN-CUSTDELDATE+0(2) WA_DOWN-CUSTDELDATE+2(3) WA_DOWN-CUSTDELDATE+5(4)
                        INTO WA_DOWN-CUSTDELDATE SEPARATED BY '-'.
      ENDIF.
      WA_DOWN-BEZEI             =  WA_FINAL-BEZEI           .
      WA_DOWN-OFM_DATE          =  WA_FINAL-OFM_DATE        .
      WA_DOWN-NET_VALUE         =  WA_FINAL-NET_VALUE       .
      WA_DOWN-PENDSO_AMT        =  WA_FINAL-PENDSO_AMT      .
      WA_DOWN-LANDX             =  WA_FINAL-LANDX           .

      IF WA_FINAL-VDATU IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-VDATU
          IMPORTING
            OUTPUT = WA_DOWN-VDATU.

        CONCATENATE WA_DOWN-VDATU+0(2) WA_DOWN-VDATU+2(3) WA_DOWN-VDATU+5(4)
                        INTO WA_DOWN-VDATU SEPARATED BY '-'.
      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF_DATE.
      IF WA_DOWN-REF_DATE IS NOT INITIAL.
        CONCATENATE WA_DOWN-REF_DATE+0(2) WA_DOWN-REF_DATE+2(3) WA_DOWN-REF_DATE+5(4)
                        INTO WA_DOWN-REF_DATE SEPARATED BY '-'.
        WA_DOWN-REF_TIME = SY-UZEIT.
      ENDIF.

      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

      APPEND WA_DOWN TO IT_DOWN.
      CLEAR WA_DOWN.
    ENDLOOP.
  ENDIF.

  PERFORM FCT.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = 'SY-REPID'
      IS_LAYOUT          = FS_LAYOUT
      IT_FIELDCAT        = GT_FIELDCAT[]
      I_DEFAULT          = 'X'
      I_SAVE             = 'A'
    TABLES
      T_OUTTAB           = IT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FCT .

  REFRESH GT_FIELDCAT.
  PERFORM GT_FIELDCATLOG USING :

         'VBELN'        'IT_FINAL'     'SO NO.'                    '1',
         'ERDAT'        'IT_FINAL'     'SO DATE'                   '2',
         'ERNAM'        'IT_FINAL'     'Created By'                '3',
         'AUART'        'IT_FINAL'     'Order Type'                '4',
         'BSTDK'        'IT_FINAL'     'Cust PO Date'              '5',
         'BSTNK'        'IT_FINAL'     'Cust Ref No'               '6',
         'VKBUR'        'IT_FINAL'     'Sales Office '             '7',
         'INCO1'        'IT_FINAL'     'Incoterms'                 '8',
         'INCO2'        'IT_FINAL'     'Incoterms Description'     '9',
         'ZTERM'        'IT_FINAL'     'Payment Terms'             '10',
         'KUNNR'        'IT_FINAL'     'Customer Code'             '11',
         'NAME1'        'IT_FINAL'     'Customer Name'             '12',
         'KUNNR_SH'     'IT_FINAL'     'Ship To party'             '13',
         'NAME1_SH'     'IT_FINAL'     'Ship To Party Name'        '14',
         'STREET'       'IT_FINAL'     'Ship To Party House'       '15',
         'POST_CODE1'   'IT_FINAL'     'Ship To Party Postal Code' '16',
         'CITY1'        'IT_FINAL'     'Ship To Party City'        '17',
         'KUNNR_UR'     'IT_FINAL'     'Sales Rep Code'            '18',
         'NAME1_UR'     'IT_FINAL'     'Sales Rep Name'            '19',
         'VTEXT'        'IT_FINAL'     'Payment Terms Description' '20',
         'WERKS'        'IT_FINAL'     'Plant'                     '21',
         'CUSTDELDATE'  'IT_FINAL'     'Customer Del date'         '22',
         'DELDATE'      'IT_FINAL'     'Delivery Date'             '23',
         'BEZEI'        'IT_FINAL'     'Ship To Party Region'      '24',
         'OFM_DATE'     'IT_FINAL'     'OFM Date'                  '25',
         'NET_VALUE'    'IT_FINAL'     'Order Amount'              '26',
         'PENDSO_AMT'   'IT_FINAL'     'Pending Amount'            '27',
         'LANDX'        'IT_FINAL'     'Ship To Party Country'     '28',
         'VDATU'        'IT_FINAL'     'Required Delivery Date'    '29',
         'DEL_REMARK'   'IT_FINAL'     'Delayed Remark'            '30'.


  FS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  FS_LAYOUT-ZEBRA = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GT_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0135   text
*      -->P_0136   text
*      -->P_0137   text
*      -->P_0138   text
*----------------------------------------------------------------------*
FORM GT_FIELDCATLOG  USING    V1 V2 V3 V4.
  GS_FIELDCAT-FIELDNAME   = V1.
  GS_FIELDCAT-TABNAME     = V2.
  GS_FIELDCAT-SELTEXT_L   = V3.
  GS_FIELDCAT-COL_POS     = V4.

  APPEND GS_FIELDCAT TO GT_FIELDCAT.
  CLEAR  GS_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

  LV_FILE = 'ZUS_VA05N_ALL_SO.TXT'.

  CONCATENATE P_FOLDER '\' LV_FILE
     INTO LV_FULLFILE.

  WRITE: / 'ZUS_VA05N.TXT Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    TRANSFER HD_CSV TO LV_FULLFILE.
    LOOP AT IT_CSV INTO WA_CSV.
      IF SY-SUBRC = 0.
        TRANSFER WA_CSV TO LV_FULLFILE.

      ENDIF.
    ENDLOOP.
    CLOSE DATASET LV_FULLFILE.
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
FORM CVS_HEADER  USING    P_HD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE    'SO NO.'
                 'SO DATE'
                 'Created By'
                 'Order Type'
                 'Cust PO Date'
                 'Cust Ref No'
                 'Sales Office '
                 'Incoterms'
                 'Incoterms Description'
                 'Payment Terms'
                 'Customer Code'
                 'Customer Name'
                 'Ship To party'
                 'Ship To Party Name'
                 'Ship To Party House'
                 'Ship To Party Postal Code'
                 'Ship To Party City'
                 'Sales Rep Code'
                 'Sales Rep Name'
                 'Payment Terms Description'
                 'Plant'
                 'Customer Del date'
                 'Ship To Party Region'
                 'OFM Date'
                 'Order Amount'
                 'Pending Amount'
                 'Ship To Party Country'
                 'Required Delivery Date'
                 'Delayed Remark'
                 'Delivery Date'
                 'Refreshable Date'
                 'Refreshable Time'
               INTO P_HD_CSV
              SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
