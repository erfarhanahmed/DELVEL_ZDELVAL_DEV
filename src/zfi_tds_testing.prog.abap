*&---------------------------------------------------------------------*
*& Report  ZFI_TDS_REGISTER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  ZFI_TDS_REGISTER_NEW.

*INCLUDE Z_CLASSES.
INCLUDE ZFI_TDS_REGISTER_CLS_NEW.
*INCLUDE zfi_tds_register_cls.

TYPES : BEGIN OF T_BKPF,
          BUKRS TYPE BUKRS,    "  Company Code
          BELNR	TYPE BELNR_D,	   " Accounting Document Number
          GJAHR TYPE GJAHR,    "  Fiscal Year
          BLART	TYPE BLART,   "	Document Type
          BUDAT TYPE BUDAT,    "  Posting Date in the Document
          TCODE	TYPE TCODE,   "	Transaction Code
          "monat  TYPE monat, " Fiscal Period
          AWKEY TYPE AWKEY,  " Reference Key
        END OF T_BKPF,

        BEGIN OF T_BSEG,
          BUKRS TYPE BUKRS,      "  Company Code
          BELNR TYPE BELNR_D,  "  Accounting Document Number
          GJAHR TYPE GJAHR,    "  Fiscal Year
          BUZEI TYPE BUZEI,    "  Number of Line Item Within Accounting Document
          KOART TYPE KOART,   " Account Type
          SHKZG TYPE SHKZG,   " Debit/Credit Indicator
          QSSHB	TYPE QSSHB,   " Withholding Tax Base Amount
          VALUT TYPE VALUT,   " Value Date
          QBSHB	TYPE QBSHB,   "	Withholding Tax Amount (in Document Currency)
          SECCO TYPE SECCO,   " Section Code
        END OF T_BSEG,

        BEGIN OF T_BSEG_CUST_VNDR,
          BUKRS TYPE BUKRS,      "  Company Code
          BELNR TYPE BELNR_D,  "  Accounting Document Number
          GJAHR TYPE GJAHR,    "  Fiscal Year
          KOART TYPE KOART,   " Account Type
          KTOSL TYPE KTOSL,   " transction key : add by $k date :- 17.11.2017
          HKONT TYPE HKONT,   " Gl add by $k date :- 17.11.207
          KUNNR TYPE KUNNR,   " Customer Number 1
          LIFNR TYPE LIFNR,   " Account Number of Vendor or Creditor
        END OF T_BSEG_CUST_VNDR,

        BEGIN OF T_TAX,
          LAND1     TYPE LAND1    ,   " Country Key
          WITHT     TYPE WITHT    ,   " Indicator for withholding tax type
          WT_WITHCD	TYPE WT_WITHCD,   " Withholding tax code
          QSCOD	    TYPE WT_OWTCD	,   " Official Withholding Tax Key
        END OF T_TAX,

        BEGIN OF T_WITH_ITEM,
          BUKRS       TYPE BUKRS    ,   " Company Code
          BELNR       TYPE BELNR_D  ,   " Accounting Document Number
          GJAHR       TYPE GJAHR    ,   " Fiscal Year
          BUZEI       TYPE BUZEI    ,   " Number of Line Item Within Accounting Document
          WITHT       TYPE WITHT    ,   " Indicator for withholding tax type
          WT_WITHCD   TYPE WT_WITHCD,   " Withholding tax code
          WT_QSSHB    TYPE WT_BS1,      " Withholding tax base amount in document currency
          WT_QBSHB    TYPE WT_WT1,      " Withholding tax amount in document currency
          QSATZ	      TYPE WT_QSATZ,    "	Withholding tax rate
          "ctnumber    TYPE ctnumber  , " Withholding Tax Certificate Number
          J_1IINTCHLN	TYPE J_1IINTCHLN, " Challan Number
          J_1IINTCHDT	TYPE J_1IINTCHDT, " Challan Date
          J_1IBUZEI   TYPE BUZEI      , " Number of Line Item Within Accounting Document
          "j_1isuramt  TYPE j_1isuramt, " Surcharge amount
          J_1IEXTCHLN	TYPE J_1IEXTCHLN, "	Challan Numbers- External
          J_1IEXTCHDT	TYPE J_1IEXTCHDT, "	Challan Date - External
          STCD1	      TYPE STCD1,	         " BSR Code/Tax Number 1
        END OF T_WITH_ITEM,

        BEGIN OF T_SECCO,
*          qscod TYPE wt_owtcd,          " Section Code
*          name  TYPE text40,            " Section Code Description
          WITHT     TYPE WITHT    ,   " Indicator for withholding tax type
          WT_WITHCD TYPE WT_WITHCD,   " Withholding tax code
          NAME      TYPE TEXT40,      " Withholding tax code description
        END OF T_SECCO,

        BEGIN OF T_RESULT,
          BELNR      TYPE BELNR_D,       " bkpf  : Accounting Document Number
*          secco      TYPE secco,       " bseg : Section Code
          QSCOD      TYPE WT_OWTCD,    " Section
          SECDSCR    TYPE TEXT40,      " secco : Section Description
          BUDAT      TYPE BUDAT,         " bkpf :  Posting Date in the Document

          WITHT      TYPE WITHT    ,   " Indicator for withholding tax type
          WT_WITHCD  TYPE WT_WITHCD,   " Withholding tax code
*          TEXT40      type TEXT40,      " Withholding tax code description

          PANNO      TYPE J_1IPANNO,   "  Customer/Vendor PAN
          NAME1      TYPE NAME1_GP,    "  Name 1
          STREET     TYPE AD_STREET,   " Street
          STR_SUPPL1 TYPE AD_STRSPP1,  " Street 2
          STR_SUPPL2 TYPE AD_STRSPP2,  " Street 3
          POST_CODE1 TYPE AD_PSTCD1,   " City postal code
          CITY1	     TYPE AD_CITY1,    " City

          QSSHB	     TYPE QSSHB,       " bseg : Withholding Tax Base Amount
          QBSHB      TYPE QBSHB,       "  bseg : Withholding Tax Amount (in Document Currency)
          "j_1isuramt  TYPE j_1isuramt, " with_item : Surcharge amount
          TXDEP      TYPE QBSHB,       " Total Tax deposited : same as qbshb
          PAYDT      TYPE DATS,        " TDS Deposit date
          J_1ICHLN   TYPE J_1IINTCHLN,   " with_item : Challan Number
          J_1ICHDT   TYPE J_1IINTCHDT,   " with_item : Challan Date
          BSRCD      TYPE CHAR20,      " BSR Code
          QSATZ	     TYPE STRING,      " Withholding tax rate

*  ADD BY $K -----DATE :- 17.11.2017
          LIFNR      TYPE LIFNR,
          HKONT      TYPE HKONT,
          HKONT1(15) TYPE C,
          KTOSL      TYPE KTOSL,
*         -------------------------
        END OF T_RESULT,

        BEGIN OF T_KNA1,
          KUNNR TYPE KUNNR,              "  Customer Number 1
          NAME1	TYPE NAME1_GP,          "	Name 1
          ADRNR TYPE ADRNR,              "  Address Number
        END OF T_KNA1,

        BEGIN OF T_CUSTOMER,
          KUNNR     TYPE KUNNR,
          J_1IPANNO	TYPE J_1IPANNO,     "	Permanent Account Number
        END OF T_CUSTOMER,

        BEGIN OF T_ADRC,
          ADDRNUMBER TYPE AD_ADDRNUM,  " Address number
          CITY1	     TYPE AD_CITY1,    " City
          POST_CODE1 TYPE AD_PSTCD1,   " City postal code
          STREET     TYPE AD_STREET,   " Street
          STR_SUPPL1 TYPE AD_STRSPP1,  " Street 2
          STR_SUPPL2 TYPE AD_STRSPP2,  " Street 3
        END OF T_ADRC,

        BEGIN OF T_LFA1,
          LIFNR TYPE LIFNR,              "  Vendor Number 1
          NAME1	TYPE NAME1_GP,          "	Name 1
          ADRNR TYPE ADRNR,              "  Address
        END OF T_LFA1,

        BEGIN OF T_VENDOR,
          LIFNR     TYPE LIFNR,
          J_1IPANNO	TYPE J_1IPANNO, "	Permanent Account Number
        END OF T_VENDOR,

        BEGIN OF T_T012,
          HBKID	TYPE HBKID,	   " Short Key for a House Bank
          STCD1	TYPE STCD1,	   " Tax Number 1
        END OF T_T012.

DATA : IT_BKPF           TYPE TABLE OF T_BKPF,
       IT_BSEG           TYPE TABLE OF T_BSEG,
       IT_TAX            TYPE TABLE OF T_TAX,
       IT_WITH_ITEM      TYPE TABLE OF T_WITH_ITEM,
       IT_SECCO          TYPE TABLE OF T_SECCO,
       IT_RESULT         TYPE TABLE OF T_RESULT,
       IT_CUSTOMER       TYPE TABLE OF T_CUSTOMER,
       IT_VENDOR         TYPE TABLE OF T_VENDOR,
       IT_KNA1           TYPE TABLE OF T_KNA1,
       IT_LFA1           TYPE TABLE OF T_LFA1,
       IT_ADRC           TYPE TABLE OF T_ADRC,
       IT_BSEG_CUST_VNDR TYPE TABLE OF T_BSEG_CUST_VNDR,
       IT_BSEG_GL        TYPE TABLE OF T_BSEG_CUST_VNDR, " ----------------add by $k date ;- 17.11.2017
       IT_RESULT_SUM     TYPE TABLE OF T_RESULT,
       IT_T012           TYPE TABLE OF T_T012,

       WA_BKPF           TYPE T_BKPF,
       WA_BSEG           TYPE T_BSEG,
       WA_TAX            TYPE T_TAX,
       WA_WITH_ITEM      TYPE T_WITH_ITEM,
       WA_SECCO          TYPE T_SECCO,
       WA_RESULT         TYPE T_RESULT,
       WA_CUSTOMER       TYPE T_CUSTOMER,
       WA_VENDOR         TYPE T_VENDOR,
       WA_KNA1           TYPE T_KNA1,
       WA_LFA1           TYPE T_LFA1,
       WA_ADRC           TYPE T_ADRC,
       WA_BSEG_CUST_VNDR TYPE T_BSEG_CUST_VNDR,
       WA_BSEG_GL        TYPE T_BSEG_CUST_VNDR, " --------------------------add by $k date :- 17.11.2017\
       WA_RESULT_SUM     TYPE T_RESULT,
       WA_T012           TYPE T_T012,

       LV_ADRNR          TYPE ADRNR,

       ALV_OBJ           TYPE REF TO CL_SALV_TABLE,
       LV_HANDLER        TYPE REF TO LCL_SALV_EVENT_HANDLER,
       LV_COL            TYPE REF TO CL_SALV_COLUMN,
       LV_COLS           TYPE REF TO CL_SALV_COLUMNS,
       LV_FUNCTIONS      TYPE REF TO CL_SALV_FUNCTIONS_LIST,
       LV_COLUMN         TYPE REF TO CL_SALV_COLUMN_LIST,

       WF_ALV_DT         TYPE REF TO LCL_SALV,
       WF_ALV_SM         TYPE REF TO LCL_SALV,

       UCOMM             TYPE SY-UCOMM.

DATA : COUNT TYPE STRING.
CONSTANTS : C_IN TYPE CHAR2 VALUE 'IN',
            C_X  VALUE 'X'.

DEFINE RESET_COLUMN_TITLE.
  CLEAR lv_col.

  lv_col = lv_cols->get_column( &1 ).
  CHECK NOT lv_col IS INITIAL.
    IF NOT &2 IS INITIAL.
      lv_col->set_short_text( &2 ).
    ENDIF.
    IF NOT &3 IS INITIAL.
      lv_col->set_medium_text( &3 ).
    ENDIF.
    IF NOT &4 IS INITIAL.
      lv_col->set_long_text( &4 ).
    ENDIF.
END-OF-DEFINITION.

DEFINE RESET_COLUMN_TITLE.
  CALL METHOD &1->reset_column_title
    EXPORTING
      i_column = &2
      i_lbl_s  = &3
      i_lbl_m  = &4
      i_lbl_l  = &5
      i_tltip  = &6.
END-OF-DEFINITION.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : SO_PDAT FOR WA_BKPF-BUDAT OBLIGATORY.
PARAMETERS : P_BUKRS TYPE BUKRS OBLIGATORY,
             P_GJAHR TYPE GJAHR OBLIGATORY.
SELECTION-SCREEN END OF BLOCK B1.

INITIALIZATION.
  REFRESH : IT_BKPF          ,
            IT_BSEG          ,
            IT_TAX           ,
            IT_WITH_ITEM     ,
            IT_SECCO         ,
            IT_RESULT        ,
            IT_CUSTOMER      ,
            IT_VENDOR        ,
            IT_KNA1          ,
            IT_LFA1          ,
            IT_ADRC          ,
            IT_BSEG_CUST_VNDR,
            IT_RESULT_SUM,
            IT_T012.

  CLEAR : WA_BKPF          ,
          WA_BSEG          ,
          WA_TAX           ,
          WA_WITH_ITEM     ,
          WA_SECCO         ,
          WA_RESULT        ,
          WA_CUSTOMER      ,
          WA_VENDOR        ,
          WA_KNA1          ,
          WA_LFA1          ,
          WA_ADRC          ,
          WA_BSEG_CUST_VNDR,
          WA_RESULT_SUM    ,
          WA_T012          ,

          LV_ADRNR         ,

          ALV_OBJ          ,
          LV_HANDLER       ,
          LV_COL           ,
          LV_COLS          ,
          LV_FUNCTIONS     ,
          LV_COLUMN        ,

          UCOMM.

  CREATE OBJECT LV_HANDLER.

START-OF-SELECTION.
* Collect documents' info
  PERFORM SELECT_BKPF.
  PERFORM SELECT_BSEG.
  PERFORM COLLECT_SECTION_DETAILS .
  PERFORM SELECT_WITH_ITEM.
  PERFORM GET_SECTION_INFO.
*  perform get_challans_info.
  PERFORM GET_CUSTOMER_INFO.
  PERFORM GET_VENDOR_INFO.

* Output routines
  PERFORM BUILD_DATA_FOR_ALV.

*&---------------------------------------------------------------------*
*&   Event END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  IF NOT IT_RESULT IS INITIAL.
    CALL SCREEN 0101.
  ENDIF.

* Display ALV
*  PERFORM alv_output.

* lv_col, lv_cols.

*&---------------------------------------------------------------------*
*&      Form  SELECT_BKPF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SELECT_BKPF .
  SELECT
      BUKRS
      BELNR
      GJAHR
      BLART
      BUDAT
      TCODE
      AWKEY
    FROM BKPF INTO TABLE IT_BKPF
    WHERE  BUKRS = P_BUKRS
      AND BSTAT  IN (SPACE, 'A' , 'B' , 'D' )
      AND BUDAT IN SO_PDAT
      AND GJAHR = P_GJAHR
      AND STBLG = ''.
  IF SY-SUBRC <> 0.
    MESSAGE TEXT-002 TYPE 'I'.
  ELSE.
    PERFORM PROCESS_MIRO_REVERSALS.
  ENDIF.
ENDFORM.                    " SELECT_BKPF
*&---------------------------------------------------------------------*
*&      Form  SELECT_BSEG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SELECT_BSEG .
  IF NOT IT_BKPF IS INITIAL.
    SELECT
        BUKRS
        BELNR
        GJAHR
        BUZEI
        KOART
        SHKZG
        QSSHB
        VALUT
        QBSHB
        SECCO
      FROM BSEG
      INTO TABLE IT_BSEG
      FOR ALL ENTRIES IN IT_BKPF
      WHERE  BUKRS = IT_BKPF-BUKRS
        AND BELNR  = IT_BKPF-BELNR
        AND GJAHR  = IT_BKPF-GJAHR
        AND BUZEI NE '000'
        AND KOART  = 'S'
        AND KTOSL  = 'WIT'
*        AND ( bupla IN secco                      " Note 639798
*        OR   secco IN secco )
        "AND secco NE space
      .
    IF SY-SUBRC = 0.
      SORT IT_BSEG.
      SELECT BUKRS
             BELNR
             GJAHR
             KOART
             KTOSL
             HKONT
             KUNNR
             LIFNR
        FROM BSEG
        INTO TABLE IT_BSEG_CUST_VNDR
        FOR ALL ENTRIES IN IT_BSEG
        WHERE BUKRS   = IT_BSEG-BUKRS
        AND BELNR   = IT_BSEG-BELNR
        AND GJAHR   = IT_BSEG-GJAHR
        AND KOART IN ('D', 'K').

      SELECT BUKRS
             BELNR
             GJAHR
             KOART
             KTOSL
             HKONT
             KUNNR
             LIFNR
        FROM BSEG
        INTO TABLE IT_BSEG_GL
        FOR ALL ENTRIES IN IT_BSEG_CUST_VNDR
        WHERE BUKRS   = IT_BSEG_CUST_VNDR-BUKRS
        AND BELNR   = IT_BSEG_CUST_VNDR-BELNR
        AND GJAHR   = IT_BSEG_CUST_VNDR-GJAHR
        AND KOART = 'S'.

      DELETE IT_BSEG_GL WHERE KTOSL <> SPACE AND KTOSL <> 'WIT'.
      IF SY-SUBRC = 0.
        SORT IT_BSEG_CUST_VNDR.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " SELECT_BSEG
*&---------------------------------------------------------------------*
*&      Form  COLLECT_SECTION_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM COLLECT_SECTION_DETAILS .
  SELECT
      LAND1
      WITHT
      WT_WITHCD
      QSCOD
    FROM T059Z          "Note 639798
    INTO TABLE IT_TAX
    WHERE LAND1   = C_IN .
ENDFORM.                    " COLLECT_SECTION_DETAILS

*&---------------------------------------------------------------------*
*&      Form  GET_SECTION_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_SECTION_INFO .
*  SELECT wt_qscod
*         text40
*    FROM t059ot
*    INTO TABLE it_secco
*    WHERE spras = sy-langu
*      AND land1   = c_in .
*  IF sy-subrc = 0.
*    SORT it_secco BY qscod.
*  ENDIF.

  SELECT
      WITHT
      WT_WITHCD
      TEXT40
    FROM T059ZT          "Note 639798
    INTO TABLE IT_SECCO
    WHERE LAND1   = C_IN .
  IF SY-SUBRC = 0.
    SORT IT_SECCO BY WITHT WT_WITHCD.
  ENDIF.
ENDFORM.                    " GET_SECTION_INFO

*&---------------------------------------------------------------------*
*&      Form  SELECT_WITH_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SELECT_WITH_ITEM .
  TYPES : BEGIN OF T_J_1IEWTCHLN.
      INCLUDE STRUCTURE J_1IEWTCHLN.
  TYPES : END OF T_J_1IEWTCHLN.

  DATA : IT_J_1IEWTCHLN TYPE TABLE OF T_J_1IEWTCHLN,
         WA_J_1IEWTCHLN TYPE T_J_1IEWTCHLN.

  IF NOT IT_BSEG IS INITIAL.
    SELECT
        BUKRS
        BELNR
        GJAHR
        BUZEI
        WITHT
        WT_WITHCD
        WT_QSSHB
        WT_QBSHB
        QSATZ
        "ctnumber
        J_1IINTCHLN
        J_1IINTCHDT
        J_1IBUZEI                                                            "j_1isuramt
      FROM WITH_ITEM
      INTO TABLE IT_WITH_ITEM
      FOR ALL ENTRIES IN IT_BSEG
      WHERE BUKRS   = IT_BSEG-BUKRS
        AND BELNR   = IT_BSEG-BELNR
        AND GJAHR   = IT_BSEG-GJAHR
        AND WT_QSSHH NE 0
        AND J_1IBUZEI = IT_BSEG-BUZEI.
    IF SY-SUBRC = 0.
      " Fetch external Challan details
      SELECT * FROM J_1IEWTCHLN INTO TABLE IT_J_1IEWTCHLN
        WHERE BUKRS = P_BUKRS
          AND GJAHR = P_GJAHR.
      IF SY-SUBRC = 0.
        SELECT HBKID
               STCD1
          FROM T012
          INTO TABLE IT_T012
          FOR ALL ENTRIES IN IT_J_1IEWTCHLN
          WHERE BUKRS = IT_J_1IEWTCHLN-BUKRS
            AND HBKID = IT_J_1IEWTCHLN-BANKL.
      ENDIF.
      LOOP AT IT_WITH_ITEM INTO WA_WITH_ITEM.
        IF NOT WA_WITH_ITEM-J_1IINTCHLN IS INITIAL.
          READ TABLE IT_J_1IEWTCHLN INTO WA_J_1IEWTCHLN
            WITH KEY BUKRS = WA_WITH_ITEM-BUKRS
                     GJAHR = WA_WITH_ITEM-GJAHR
                     J_1IINTCHLN = WA_WITH_ITEM-J_1IINTCHLN
                     J_1IINTCHDT = WA_WITH_ITEM-J_1IINTCHDT .
          IF SY-SUBRC = 0.
            WA_WITH_ITEM-J_1IEXTCHLN =  WA_J_1IEWTCHLN-J_1IEXTCHLN.
            WA_WITH_ITEM-J_1IEXTCHDT =  WA_J_1IEWTCHLN-J_1IEXTCHDT.
            READ TABLE IT_T012 INTO WA_T012 WITH KEY HBKID = WA_J_1IEWTCHLN-BANKL.
            IF SY-SUBRC = 0.
              WA_WITH_ITEM-STCD1 = WA_T012-STCD1.
            ENDIF.
          ENDIF.

          MODIFY IT_WITH_ITEM FROM WA_WITH_ITEM
            TRANSPORTING J_1IEXTCHLN J_1IEXTCHDT STCD1.
        ENDIF.

        CLEAR : WA_WITH_ITEM, WA_J_1IEWTCHLN, WA_T012.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.                    " SELECT_WITH_ITEM

*&---------------------------------------------------------------------*
*&      Form  BUILD_DATA_FOR_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_DATA_FOR_ALV .
  DATA VAR TYPE P LENGTH 4 DECIMALS 2.
  SORT : IT_WITH_ITEM, IT_BSEG BY BELNR GJAHR.
  LOOP AT IT_WITH_ITEM INTO WA_WITH_ITEM.
    " Section Code
    READ TABLE IT_TAX INTO WA_TAX WITH KEY LAND1 = C_IN
                               WITHT     = WA_WITH_ITEM-WITHT
                               WT_WITHCD = WA_WITH_ITEM-WT_WITHCD.
    IF SY-SUBRC = 0.
      " Following if block : to be removed if future-requirements claim
      IF WA_TAX-QSCOD = '206C'.
        CONTINUE.
      ENDIF.

      WA_RESULT-QSCOD = WA_TAX-QSCOD.
      WA_RESULT-WITHT     = WA_TAX-WITHT    .
      WA_RESULT-WT_WITHCD = WA_TAX-WT_WITHCD.

*      READ TABLE it_secco INTO wa_secco WITH KEY qscod = wa_result-qscod.
      READ TABLE IT_SECCO INTO WA_SECCO WITH KEY WITHT     = WA_WITH_ITEM-WITHT
                                                 WT_WITHCD = WA_WITH_ITEM-WT_WITHCD.
      IF SY-SUBRC = 0.
        WA_RESULT-SECDSCR = WA_SECCO-NAME.
      ENDIF.
    ENDIF.

    READ TABLE IT_BKPF INTO WA_BKPF WITH KEY BUKRS = WA_WITH_ITEM-BUKRS
                                             BELNR = WA_WITH_ITEM-BELNR
                                             GJAHR = WA_WITH_ITEM-GJAHR.
    IF SY-SUBRC = 0.
      WA_RESULT-BELNR = WA_BKPF-BELNR.
      WA_RESULT-BUDAT = WA_BKPF-BUDAT.

      READ TABLE IT_BSEG_CUST_VNDR INTO WA_BSEG_CUST_VNDR
        WITH KEY BUKRS = WA_WITH_ITEM-BUKRS
                 BELNR = WA_WITH_ITEM-BELNR
                 GJAHR = WA_WITH_ITEM-GJAHR.
      IF SY-SUBRC = 0.
        " customer/ Vendor info


        IF WA_BSEG_CUST_VNDR-KOART = 'D'.

          READ TABLE IT_CUSTOMER INTO WA_CUSTOMER WITH KEY KUNNR = WA_BSEG_CUST_VNDR-KUNNR.
          IF SY-SUBRC = 0.
            WA_RESULT-PANNO = WA_CUSTOMER-J_1IPANNO.
          ENDIF.

          READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_BSEG_CUST_VNDR-KUNNR.
          IF SY-SUBRC = 0.
            WA_RESULT-NAME1 = WA_KNA1-NAME1.
            LV_ADRNR = WA_KNA1-ADRNR.
          ENDIF.
        ELSEIF WA_BSEG_CUST_VNDR-KOART = 'K'.
*          add by $k date :- 17.11.2017
          WA_RESULT-LIFNR = WA_BSEG_CUST_VNDR-LIFNR. "add by $k date :- 17.11.2017
*           --------------------------------------------------------------------------

          READ TABLE IT_VENDOR INTO WA_VENDOR WITH KEY LIFNR = WA_BSEG_CUST_VNDR-LIFNR.
          IF SY-SUBRC = 0.
            WA_RESULT-PANNO = WA_VENDOR-J_1IPANNO.
          ENDIF.

          READ TABLE IT_LFA1 INTO WA_LFA1 WITH KEY LIFNR = WA_BSEG_CUST_VNDR-LIFNR.
          IF SY-SUBRC = 0.
            WA_RESULT-NAME1 = WA_LFA1-NAME1.
            LV_ADRNR = WA_LFA1-ADRNR.
          ENDIF.
        ENDIF.
*        ENDIF.


        " Address Info
        IF NOT LV_ADRNR IS INITIAL.
          READ TABLE IT_ADRC INTO WA_ADRC WITH KEY ADDRNUMBER = LV_ADRNR.
          IF SY-SUBRC = 0.
            WA_RESULT-CITY1      = WA_ADRC-CITY1     .
            WA_RESULT-POST_CODE1 = WA_ADRC-POST_CODE1.
            WA_RESULT-STREET     = WA_ADRC-STREET    .
            WA_RESULT-STR_SUPPL1 = WA_ADRC-STR_SUPPL1.
            WA_RESULT-STR_SUPPL2 = WA_ADRC-STR_SUPPL2.
          ENDIF.
        ENDIF.

        "wa_result-secco = wa_bseg-secco.
        " Negate the values as per the transaction type
        READ TABLE IT_BSEG INTO WA_BSEG WITH KEY BELNR = WA_WITH_ITEM-BELNR
                                                 GJAHR = WA_WITH_ITEM-GJAHR.
        IF SY-SUBRC = 0.
          IF WA_BSEG-SHKZG = 'S'.
            IF ( WA_WITH_ITEM-WT_QSSHB < 0 AND WA_WITH_ITEM-WT_QBSHB < 0 )
              OR ( WA_WITH_ITEM-WT_QSSHB > 0 AND WA_WITH_ITEM-WT_QBSHB > 0 ).
              WA_WITH_ITEM-WT_QSSHB = WA_WITH_ITEM-WT_QSSHB * -1.
              WA_WITH_ITEM-WT_QBSHB = WA_WITH_ITEM-WT_QBSHB * -1.
            ENDIF.
          ELSEIF WA_BSEG-SHKZG = 'H'.
            IF ( WA_WITH_ITEM-WT_QSSHB < 0 AND WA_WITH_ITEM-WT_QBSHB < 0 ).
              "OR ( wa_with_item-wt_qsshb > 0 AND wa_with_item-wt_qbshb > 0 ).
              WA_WITH_ITEM-WT_QSSHB = WA_WITH_ITEM-WT_QSSHB * -1.
              WA_WITH_ITEM-WT_QBSHB = WA_WITH_ITEM-WT_QBSHB * -1.
            ENDIF.
          ENDIF.
        ENDIF.

        "E : All amounts should be negated
        WA_RESULT-QSSHB  = WA_WITH_ITEM-WT_QSSHB.
        WA_RESULT-QBSHB  = WA_WITH_ITEM-WT_QBSHB.
        "wa_result-txddct = wa_with_item-wt_qbshb.

        CLEAR : VAR.
        VAR = WA_WITH_ITEM-QSATZ.
        WA_RESULT-QSATZ  = VAR.

        IF NOT WA_WITH_ITEM-J_1IEXTCHLN IS INITIAL.
          WA_RESULT-TXDEP  = WA_WITH_ITEM-WT_QBSHB.
          WA_RESULT-PAYDT  = WA_WITH_ITEM-J_1IEXTCHDT.
          "wa_result-j_1isuramt  = wa_with_item-j_1isuramt. " Surcharge amount
          WA_RESULT-J_1ICHLN = WA_WITH_ITEM-J_1IEXTCHLN.
          WA_RESULT-J_1ICHDT = WA_WITH_ITEM-J_1IEXTCHDT.
          WA_RESULT-BSRCD    = WA_WITH_ITEM-STCD1.

        ENDIF.

*        IF not wa_result-qbshb is initial and not wa_result-qsshb is initial.
*          wa_result-tdsrt = wa_result-qbshb / wa_result-qsshb * 100.
*        ENDIF.

*        *  -------------------------addd by $k Date : -17.11.2017-----------
        LOOP AT IT_BSEG_GL INTO WA_BSEG_GL WHERE  BUKRS = WA_WITH_ITEM-BUKRS AND
                                                  BELNR = WA_WITH_ITEM-BELNR AND
                                                  GJAHR = WA_WITH_ITEM-GJAHR.
          COUNT = COUNT + 1.
          IF WA_BSEG_GL-KTOSL = 'WIT'.
            WA_RESULT-HKONT1 = WA_BSEG_GL-HKONT."add by $k date :- 17.11.2017
            WA_RESULT-KTOSL = WA_BSEG_GL-KTOSL.

*        IF wa_result-hkont is INITIAL.
            IF COUNT = 2.
              CLEAR :WA_RESULT-QBSHB , WA_RESULT-QSSHB,WA_RESULT-TXDEP.
            ENDIF.

            APPEND WA_RESULT TO IT_RESULT.
            CLEAR WA_RESULT-KTOSL.
          ELSEIF WA_BSEG_GL-KTOSL = SPACE.
            WA_RESULT-HKONT = WA_BSEG_GL-HKONT. "add by $k date :- 17.11.2017
            WA_RESULT-KTOSL = WA_BSEG_GL-KTOSL.
            IF COUNT = 3.
              CLEAR :WA_RESULT-QBSHB , WA_RESULT-QSSHB,WA_RESULT-TXDEP.
            ENDIF.

            APPEND WA_RESULT TO IT_RESULT.
            CLEAR WA_RESULT-KTOSL.
          ENDIF.

*             CLEAR : wa_result.
        ENDLOOP.

*        APPEND wa_result TO it_result.
      ENDIF.
    ENDIF.
    CLEAR : WA_BKPF, WA_SECCO, WA_BSEG_CUST_VNDR, WA_WITH_ITEM, WA_RESULT, WA_TAX , WA_BSEG_GL.
    CLEAR : WA_CUSTOMER, WA_VENDOR, WA_KNA1, WA_LFA1, LV_ADRNR, WA_ADRC , COUNT.
  ENDLOOP.
*      delete : it_result WHERE hkont = space. "comment 16.10.2019
  IF NOT IT_RESULT IS INITIAL.
*    SORT IT_RESULT BY BUDAT BELNR.
    SORT IT_RESULT DESCENDING BY  BELNR  QSCOD HKONT .
*    SORT it_result BY belnr.


*    DELETE ADJACENT DUPLICATES FROM it_result COMPARING belnr QSCOD . "Comment by sarika Thange 30.10.2019
    DATA : LV_BELNR TYPE BELNR_D,
           LV_QSCOD TYPE WT_OWTCD,
           LV_KTOSL TYPE KTOSL.

    LOOP AT IT_RESULT INTO WA_RESULT.
      IF LV_BELNR = WA_RESULT-BELNR AND LV_QSCOD  = WA_RESULT-QSCOD AND WA_RESULT-HKONT IS INITIAL AND LV_KTOSL <> WA_RESULT-KTOSL.
        DELETE IT_RESULT WHERE BELNR = WA_RESULT-BELNR AND QSCOD  = WA_RESULT-QSCOD AND HKONT = SPACE.
      ENDIF.
      LV_BELNR = WA_RESULT-BELNR.
      LV_QSCOD = WA_RESULT-QSCOD.
      LV_KTOSL = WA_RESULT-KTOSL.

      CLEAR : WA_RESULT.
    ENDLOOP.

    SORT IT_RESULT BY BUDAT BELNR.
    " Generate Summery Report
    PERFORM GENERATE_SUMMERY.
  ENDIF.
ENDFORM.                    " BUILD_DATA_FOR_ALV

*&---------------------------------------------------------------------*
*&      Form  PROCESS_MIRO_REVERSALS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PROCESS_MIRO_REVERSALS .
  TYPES : BEGIN OF T_RBKP,
            BELNR LIKE RBKP-BELNR,
            GJAHR LIKE BKPF-AWKEY,
          END OF T_RBKP.
  DATA : TMP_BKPF TYPE TABLE OF T_BKPF,
         IT_RBKP  TYPE TABLE OF T_RBKP,
         WA_RBKP  TYPE T_RBKP.

  REFRESH : IT_RBKP, TMP_BKPF.
  CLEAR WA_RBKP.

  TMP_BKPF = IT_BKPF.

  DELETE TMP_BKPF WHERE NOT TCODE = 'MIRO'
                    AND NOT TCODE = 'MR8M'
                    AND TCODE = 'MIR7'. "Note 699664
  IF NOT TMP_BKPF IS INITIAL.
    SELECT BELNR
           GJAHR
      FROM RBKP
      INTO TABLE IT_RBKP
      FOR ALL ENTRIES IN TMP_BKPF
      WHERE BELNR = TMP_BKPF-AWKEY+0(10)
        AND GJAHR = TMP_BKPF-GJAHR
        AND STBLG NE ' '.
    IF SY-SUBRC = 0.
      LOOP AT IT_RBKP INTO WA_RBKP.
        DELETE IT_BKPF WHERE AWKEY+0(10) = WA_RBKP-BELNR AND
                                 AWKEY+10(4) = WA_RBKP-GJAHR.
        CLEAR WA_RBKP.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.                    " PROCESS_MIRO_REVERSALS
*&---------------------------------------------------------------------*
*&      Form  GET_CUSTOMER_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_CUSTOMER_INFO .
  IF NOT IT_BSEG IS INITIAL.
    SELECT DISTINCT
          KUNNR
          NAME1
          ADRNR
      FROM KNA1
      INTO TABLE IT_KNA1
      FOR ALL ENTRIES IN IT_BSEG_CUST_VNDR
      WHERE KUNNR = IT_BSEG_CUST_VNDR-KUNNR.
    IF SY-SUBRC = 0.
      SORT IT_KNA1 BY KUNNR.

      " PAN Info
      SELECT KUNNR J_1IPANNO
      FROM J_1IMOCUST
      INTO TABLE IT_CUSTOMER
      FOR ALL ENTRIES IN IT_KNA1
      WHERE KUNNR = IT_KNA1-KUNNR.
      IF SY-SUBRC = 0.
        SORT IT_CUSTOMER BY KUNNR.
      ENDIF.

      " Address info
      SELECT ADDRNUMBER
             CITY1
             POST_CODE1
             STREET
             STR_SUPPL1
             STR_SUPPL2
        FROM ADRC
        INTO TABLE IT_ADRC
        FOR ALL ENTRIES IN IT_KNA1
        WHERE ADDRNUMBER = IT_KNA1-ADRNR.
      IF SY-SUBRC = 0.
        SORT IT_ADRC.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_CUSTOMER_INFO

*&---------------------------------------------------------------------*
*&      Form  get_vendor_info
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM GET_VENDOR_INFO.
  IF NOT IT_BSEG IS INITIAL.
    SELECT DISTINCT
        LIFNR
        NAME1
        ADRNR
      FROM LFA1
      INTO TABLE IT_LFA1
      FOR ALL ENTRIES IN IT_BSEG_CUST_VNDR
      WHERE LIFNR = IT_BSEG_CUST_VNDR-LIFNR.
    IF SY-SUBRC = 0.
      SORT IT_LFA1 BY LIFNR.

      " PAN Info
      SELECT LIFNR
           J_1IPANNO
      FROM J_1IMOVEND
      INTO TABLE IT_VENDOR
      FOR ALL ENTRIES IN IT_LFA1
      WHERE LIFNR = IT_LFA1-LIFNR.
      IF SY-SUBRC = 0.
        SORT IT_VENDOR BY LIFNR.
      ENDIF.

      " Address info
      SELECT ADDRNUMBER
             CITY1
             POST_CODE1
             STREET
             STR_SUPPL1
             STR_SUPPL2
        FROM ADRC
        INTO TABLE IT_ADRC
        FOR ALL ENTRIES IN IT_LFA1
        WHERE ADDRNUMBER = IT_LFA1-ADRNR.
      IF SY-SUBRC = 0.
        SORT IT_ADRC.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "get_vendor_info

FORM HANDLE_EVENT USING ACTION TYPE CHAR50.
  DATA : V TYPE CHAR100.
  CASE ACTION.
    WHEN 'DOUBLE_CLICK'.
      PERFORM HANDLE_DOUBLE_CLICK.
  ENDCASE.
ENDFORM.

FORM HANDLE_DOUBLE_CLICK.
  CLEAR WA_RESULT.
  READ TABLE IT_RESULT INTO WA_RESULT INDEX LV_HANDLER->ROW_ID.

  IF LV_HANDLER->COL = 'BELNR'.
    SET PARAMETER ID : 'BLN' FIELD WA_RESULT-BELNR,
                       'BUK' FIELD P_BUKRS,
                       'GJR' FIELD P_GJAHR.
    CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GENERATE_SUMMERY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GENERATE_SUMMERY .
  REFRESH IT_RESULT_SUM.
  LOOP AT IT_RESULT INTO WA_RESULT.
    WA_RESULT-BELNR    = ''.
    WA_RESULT-BUDAT    = ''.
    WA_RESULT-PAYDT    = ''.
    WA_RESULT-J_1ICHLN = ''.
    WA_RESULT-J_1ICHDT = ''.
    WA_RESULT-BSRCD    = ''.
    COLLECT WA_RESULT INTO IT_RESULT_SUM.
  ENDLOOP.
  IF NOT IT_RESULT_SUM IS INITIAL.
    SORT IT_RESULT_SUM BY QSCOD WITHT WT_WITHCD NAME1.
  ENDIF.
ENDFORM.                    " GENERATE_SUMMERY

FORM DISPLAY_RESULTS.
  DATA : "container_obj TYPE REF TO cl_gui_docking_container,
    CONTAINER_OBJ TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
    SPLITTER_OBJ  TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
    CONTAINER_1   TYPE REF TO CL_GUI_CONTAINER,
    CONTAINER_2   TYPE REF TO CL_GUI_CONTAINER,
    WF_ALV_OBJ    TYPE REF TO CL_SALV_TABLE,
    WF_ALV_OBJ1   TYPE REF TO CL_SALV_TABLE.

  CREATE OBJECT CONTAINER_OBJ
    EXPORTING
      CONTAINER_NAME              = 'CSTM_CTRL'
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    " Create a splitter control : container for the resultant ALVs
    CREATE OBJECT SPLITTER_OBJ
      EXPORTING
        PARENT            = CONTAINER_OBJ
        ROWS              = 2
        COLUMNS           = 1
      EXCEPTIONS
        CNTL_ERROR        = 1
        CNTL_SYSTEM_ERROR = 2
        OTHERS            = 3.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ELSE.
      " Container to display PO records
      CALL METHOD SPLITTER_OBJ->GET_CONTAINER
        EXPORTING
          ROW       = 1
          COLUMN    = 1
        RECEIVING
          CONTAINER = CONTAINER_1.

      PERFORM CREATE_ALV USING CONTAINER_1
                               IT_RESULT
                         CHANGING WF_ALV_OBJ.

      CREATE OBJECT WF_ALV_DT
        EXPORTING
          I_ALV_OBJ       = WF_ALV_OBJ
          I_SET_ALL       = C_X
          I_SET_OPTIMIZED = C_X.

      PERFORM SET_DETAIL_SALV_VIEW.

      "-----------------------------------------------------------------------
      " Container for display Schedule Line records
      CALL METHOD SPLITTER_OBJ->GET_CONTAINER
        EXPORTING
          ROW       = 2
          COLUMN    = 1
        RECEIVING
          CONTAINER = CONTAINER_2.
      CLEAR WF_ALV_OBJ1.

      PERFORM CREATE_ALV USING CONTAINER_2
                               IT_RESULT_SUM
                         CHANGING WF_ALV_OBJ1.


      CREATE OBJECT WF_ALV_SM
        EXPORTING
          I_ALV_OBJ       = WF_ALV_OBJ1
          I_SET_ALL       = C_X
          I_SET_OPTIMIZED = C_X.

      PERFORM SET_SUMMARY_SALV_VIEW .

      "PERFORM reset_column_titles CHANGING wf_alv_dt  wf_alv_sm.

      "PERFORM set_footer USING wf_alv_sm.

      PERFORM DISPLAY_CONTENTS CHANGING WF_ALV_DT  WF_ALV_SM.
    ENDIF.
  ENDIF.
ENDFORM.

FORM DISPLAY_CONTENTS CHANGING P_ALV_DT TYPE REF TO LCL_SALV
                              P_ALV_SM TYPE REF TO LCL_SALV.

  DATA : CONTAINER_H TYPE REF TO CL_GUI_DOCKING_CONTAINER,
         CONTAINER_F TYPE REF TO CL_GUI_DOCKING_CONTAINER,

         HDR_OBJ     TYPE REF TO CL_SALV_FORM_DYDOS.
*         ftr_obj TYPE REF TO cl_salv_form_dydos.

  PERFORM CREATE_DOC_CONTAINER
    USING CL_GUI_DOCKING_CONTAINER=>DOCK_AT_TOP
          50
    CHANGING CONTAINER_H. " for header

*  perform create_doc_container
*    USING cl_gui_docking_container=>dock_at_bottom
*          75
*    CHANGING container_f. " For footer
  " Display Headers
  CREATE OBJECT HDR_OBJ
    EXPORTING
      R_CONTAINER = CONTAINER_H
      R_CONTENT   = P_ALV_DT->ALV_HDR.
  HDR_OBJ->DISPLAY( ).

  " Display ALVs
  P_ALV_DT->DISPLAY( ).
  P_ALV_SM->DISPLAY( ).

*  " Display Footer
*  create object ftr_obj
*    exporting
*      r_container = container_f
*      r_content   = p_alv_sm->alv_ftr.
*
*  ftr_obj->display( ).
ENDFORM.

FORM CREATE_ALV USING P_CONTAINER   TYPE REF TO CL_GUI_CONTAINER
                      P_TAB         TYPE TABLE
                CHANGING P_ALV_OBJ TYPE REF TO CL_SALV_TABLE.
  TRY .
      CALL METHOD CL_SALV_TABLE=>FACTORY
        EXPORTING
          R_CONTAINER  = P_CONTAINER
        IMPORTING
          R_SALV_TABLE = P_ALV_OBJ
        CHANGING
          T_TABLE      = P_TAB.
    CATCH CX_SALV_MSG.
      MESSAGE 'Error in displaying ALV' TYPE 'I'.
      EXIT.
  ENDTRY.

ENDFORM.

FORM CREATE_DOC_CONTAINER USING P_SIDE    TYPE I
                                P_HEIGHT  TYPE I
                          CHANGING P_CONTAINER TYPE REF TO
                                CL_GUI_DOCKING_CONTAINER.
  CREATE OBJECT P_CONTAINER
    EXPORTING
      SIDE                        = P_SIDE
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  IF NOT P_HEIGHT IS INITIAL.
    CALL METHOD P_CONTAINER->SET_HEIGHT
      EXPORTING
        HEIGHT = P_HEIGHT.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  DISPLAY_RESULTS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE DISPLAY_RESULTS OUTPUT.
  PERFORM DISPLAY_RESULTS.
ENDMODULE.                 " DISPLAY_RESULTS  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  SET_DETAIL_SALV_VIEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_DETAIL_SALV_VIEW .
  WF_ALV_DT->DISPLAY_COMPANY_HEADER( I_TITLE = TEXT-024 ).

  " Set Totals for the columns
  WF_ALV_DT->SET_TOTAL( 'QSSHB' ).
  WF_ALV_DT->SET_TOTAL( 'QBSHB' ).
  WF_ALV_DT->SET_TOTAL( 'TXDEP' ).


  " Show Hotspot Links " link display disables the navigation...chk why?
  "wf_alv_dt->show_hotspot_links( 'BELNR' ).

  " Set event handlers
  WF_ALV_DT->GET_EVENTS( ).
  SET HANDLER LV_HANDLER->HANDLE_DOUBLE_CLICK FOR WF_ALV_DT->EVENTS.

  " Reset column titles
  RESET_COLUMN_TITLE :
**  Add By $k date :- 17.11.2017---------------------------------------------------------------------------------
    WF_ALV_DT 'LIFNR'   'Vendor No' 'Vendor No' 'Vendor No' 'Vendor No', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
    WF_ALV_DT 'HKONT'   'Expense GL' 'Expense GL' 'Expense GL' 'Expense GL', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
    WF_ALV_DT 'HKONT1'   'TDSGL Code' 'TDS GL Code' 'TDS GL Code' 'TDS GL Code', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
**------------------------------------------------------------------------------------------------------------
    WF_ALV_DT 'QSCOD'   'Section' 'Section' 'Section' 'Section', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
    WF_ALV_DT 'SECDSCR' 'Sec Descr' 'Section Descr' 'Section Description' 'Section Description',  "TEXT-005 TEXT-006 TEXT-007  TEXT-007,
    WF_ALV_DT 'PANNO'   'PAN No' 'PAN of Deductee' 'PAN of Deductee' 'PAN of Deductee',      "TEXT-008 TEXT-008  TEXT-008,
    WF_ALV_DT 'TXDEP'   'TotTaxDeps' 'Tot Tax Depos' 'Total Tax Deposited' 'Total Tax Deposited',     "TEXT-012 TEXT-013 TEXT-014  TEXT-014,
    WF_ALV_DT 'NAME1'   'Deductee' 'Name of Deductee' 'Name of Deductee' 'Name of Deductee',     "  TEXT-015 TEXT-016  TEXT-016,
    WF_ALV_DT 'PAYDT'   'Depos Dt' 'TDS Depos Dt' 'TDS Deposit Date' 'TDS Deposit Date',     "TEXT-017 TEXT-018 TEXT-019  TEXT-019,
    WF_ALV_DT 'BSRCD'   'BSR Code' 'BSR Code' 'BSR Code' 'BSR Code',     "TEXT-020 TEXT-021 TEXT-021  TEXT-021,
    WF_ALV_DT 'QSATZ'   'Rate'  'Rate' 'Rate at which TDS Deducted' 'Rate at which TDS Deducted'.     " TEXT-022  TEXT-022.

  " Hide Columns
  WF_ALV_DT->HIDE_COLUMN( 'WITHT' ).
  WF_ALV_DT->HIDE_COLUMN( 'WT_WITHCD' ).
*  wf_alv_dt->hide_column( 'LIFNR' ).
*  wf_alv_dt->hide_column( 'HKONT' ).
*  wf_alv_dt->hide_column( 'HKONT1' ).

  " Set Align
  WF_ALV_DT->ALIGN( I_COLUMN = 'QSATZ'
                    I_ALIGN  = IF_SALV_C_ALIGNMENT=>RIGHT ).


ENDFORM.                    " SET_DETAIL_SALV_VIEW

FORM SET_SUMMARY_SALV_VIEW .
  WF_ALV_SM->DISPLAY_COMPANY_HEADER( I_TITLE = TEXT-023 ).

  " Set Totals for the columns
  WF_ALV_SM->SET_TOTAL( 'QSSHB' ).
  WF_ALV_SM->SET_TOTAL( 'QBSHB' ).
  WF_ALV_SM->SET_TOTAL( 'TXDEP' ).

  " Subtotals
  WF_ALV_SM->SET_SORT( I_COLUMN = 'QSCOD'
                       I_SUBTOT = IF_SALV_C_BOOL_SAP=>TRUE ).



  " Reset column titles
  RESET_COLUMN_TITLE :
    WF_ALV_SM 'QSCOD'   'Section' 'Section' 'Section' 'Section', "TEXT-004 TEXT-004 TEXT-004  TEXT-004,
    WF_ALV_SM 'SECDSCR' 'Sec Descr' 'Section Descr' 'Section Description' 'Section Description',  "TEXT-005 TEXT-006 TEXT-007  TEXT-007,
    WF_ALV_SM 'TXDEP'   'TotTaxDeps' 'Tot Tax Depos' 'Total Tax Deposited' 'Total Tax Deposited',  "TEXT-012 TEXT-013 TEXT-014  TEXT-014,
    WF_ALV_SM 'NAME1'   'Name' 'Deductee' 'Name of Deductee' 'Name of Deductee',      "TEXT-015 TEXT-016  TEXT-016,
    WF_ALV_SM 'BSRCD'   'BSR' 'BSR' 'BSR' 'BSR',    "TEXT-020 TEXT-021 TEXT-021  TEXT-021,
    WF_ALV_SM 'QSATZ'   'Rate'       'Rate' 'Rate at which TDS Deducted' 'Rate at which TDS Deducted'.      "TEXT-022  TEXT-022.

  " Hide Columns
  WF_ALV_SM->HIDE_COLUMN( 'BELNR' ).
  WF_ALV_SM->HIDE_COLUMN( 'PANNO' ).
  WF_ALV_SM->HIDE_COLUMN( 'PAYDT' ).
  WF_ALV_SM->HIDE_COLUMN( 'BUDAT' ).
  WF_ALV_SM->HIDE_COLUMN( 'PAYDT' ).
  WF_ALV_SM->HIDE_COLUMN( 'J_1ICHLN' ).
  WF_ALV_SM->HIDE_COLUMN( 'J_1ICHDT' ).
  WF_ALV_SM->HIDE_COLUMN( 'BSRCD' ).

  " Set Align
  WF_ALV_SM->ALIGN( I_COLUMN = 'QSATZ'
                    I_ALIGN  = IF_SALV_C_ALIGNMENT=>RIGHT ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  SET_PF_STATUS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE SET_PF_STATUS OUTPUT.
  SET PF-STATUS 'ZFI_TDSREG_STAT'.
ENDMODULE.                 " SET_PF_STATUS  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  HANDLE_USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE HANDLE_USER_COMMAND INPUT.
  CASE UCOMM.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                 " HANDLE_USER_COMMAND  INPUT
