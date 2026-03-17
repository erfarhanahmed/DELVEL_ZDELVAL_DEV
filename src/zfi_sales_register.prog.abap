*&---------------------------------------------------------------------*
*& Report ZFI_SALES_REGISTER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFI_SALES_REGISTER.
TYPE-POOLS:SLIS.
TABLES BKPF.
DATA:
  TMP_BELNR TYPE BKPF-BELNR,
  TMP_BUDAT TYPE BKPF-BUDAT,
  TMP_GJAHR TYPE BKPF-GJAHR.

TYPES:
  BEGIN OF T_ACCOUNTING_DOC_HDR,
    BUKRS TYPE BKPF-BUKRS,
    BELNR TYPE BKPF-BELNR,
    GJAHR TYPE BKPF-GJAHR,
    BLART TYPE BKPF-BLART,
    BUDAT TYPE BKPF-BUDAT,
    XBLNR TYPE BKPF-XBLNR,
    BKTXT TYPE BKPF-BKTXT,
    WAERS TYPE BKPF-WAERS,
    KURSF TYPE BKPF-KURSF,
    STBLG TYPE BKPF-STBLG,
  END OF T_ACCOUNTING_DOC_HDR,
  TT_ACCOUNTING_DOC_HDR TYPE STANDARD TABLE OF T_ACCOUNTING_DOC_HDR.

TYPES:
  BEGIN OF T_ACCOUNTING_DOC_ITEM,
    BUKRS   TYPE BSEG-BUKRS,
    BELNR   TYPE BSEG-BELNR,
    GJAHR   TYPE BSEG-GJAHR,
    BUZEI   TYPE BSEG-BUZEI,
    BUZID   TYPE BSEG-BUZID,
    AUGBL   TYPE BSEG-AUGBL,
    SHKZG   TYPE BSEG-SHKZG,
    MWSKZ   TYPE BSEG-MWSKZ,
    DMBTR   TYPE BSEG-DMBTR,
    WRBTR   TYPE BSEG-WRBTR,
    TXGRP   TYPE BSEG-TXGRP,
    KTOSL   TYPE BSEG-KTOSL,
    ZUONR   TYPE BSEG-ZUONR,
    SGTXT   TYPE BSEG-SGTXT,
    SAKNR   TYPE BSEG-SAKNR,
    HKONT   TYPE BSEG-HKONT,
    KUNNR   TYPE BSEG-KUNNR,
    XBILK   TYPE BSEG-XBILK,
    HSN_SAC TYPE BSEG-HSN_SAC,
    KOART   TYPE BSEG-KOART,
  END OF T_ACCOUNTING_DOC_ITEM,
  TT_ACCOUNTING_DOC_ITEM TYPE STANDARD TABLE OF T_ACCOUNTING_DOC_ITEM.

TYPES:
  BEGIN OF T_BSET,
    BUKRS TYPE BSET-BUKRS,
    BELNR TYPE BSET-BELNR,
    GJAHR TYPE BSET-GJAHR,
    BUZEI TYPE BSET-BUZEI,
    SHKZG TYPE BSET-SHKZG,
    HWBAS TYPE BSET-HWBAS,
    FWBAS TYPE BSET-FWBAS,
    HWSTE TYPE BSET-HWSTE,
    FWSTE TYPE BSET-FWSTE,
    KTOSL TYPE BSET-KTOSL,
    KSCHL TYPE BSET-KSCHL,
    KBETR TYPE BSET-KBETR,
    MWSKZ TYPE BSET-MWSKZ,

  END OF T_BSET,
  TT_BSET TYPE STANDARD TABLE OF T_BSET.


TYPES:
  BEGIN OF T_CUST_INFO,
    KUNNR TYPE KNA1-KUNNR,
    NAME1 TYPE KNA1-NAME1,
    NAME2 TYPE KNA1-NAME2,
    LAND1 TYPE KNA1-LAND1,
    REGIO TYPE KNA1-REGIO,
    ADRNR TYPE KNA1-ADRNR,
    STCD3 TYPE KNA1-STCD3,
  END OF T_CUST_INFO,
  TT_CUST_INFO TYPE STANDARD TABLE OF T_CUST_INFO.

TYPES:
  BEGIN OF T_T005U,
    LAND1 TYPE T005U-LAND1,
    BLAND TYPE T005U-BLAND,
    BEZEI TYPE ZGST_REGION-BEZEI,
  END OF T_T005U,
  TT_T005U TYPE STANDARD TABLE OF T_T005U.

TYPES:
  BEGIN OF T_ZGST_REGION,
    GST_REGION TYPE ZGST_REGION-GST_REGION,
    BEZEI      TYPE ZGST_REGION-BEZEI,
  END OF T_ZGST_REGION,
  TT_ZGST_REGION TYPE STANDARD TABLE OF T_ZGST_REGION.

TYPES:
  BEGIN OF T_ADRC,
    ADDRNUMBER TYPE ADRC-ADDRNUMBER,
    NAME1      TYPE ADRC-NAME1,
    CITY2      TYPE ADRC-CITY2,
    POST_CODE1 TYPE ADRC-POST_CODE1,
    STREET     TYPE ADRC-STREET,
    STR_SUPPL1 TYPE ADRC-STR_SUPPL1,
    STR_SUPPL2 TYPE ADRC-STR_SUPPL2,
    STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
    LOCATION   TYPE ADRC-LOCATION,
    COUNTRY    TYPE ADRC-COUNTRY,
  END OF T_ADRC,
  TT_ADRC TYPE STANDARD TABLE OF T_ADRC.

TYPES:
  BEGIN OF T_KNVI,
    KUNNR TYPE KNVI-KUNNR,
    TAXKD TYPE KNVI-TAXKD,
  END OF T_KNVI,
  TT_KNVI TYPE STANDARD TABLE OF T_KNVI.

TYPES:
  BEGIN OF T_TSKDT,
    TATYP TYPE TSKDT-TATYP,
    TAXKD TYPE TSKDT-TAXKD,
    VTEXT TYPE TSKDT-VTEXT,
  END OF T_TSKDT,
  TT_TSKDT TYPE STANDARD TABLE OF T_TSKDT.

TYPES:
  BEGIN OF T_T007S,
    MWSKZ TYPE T007S-MWSKZ,
    TEXT1 TYPE T007S-TEXT1,
  END OF T_T007S,
  TT_T007S TYPE STANDARD TABLE OF T_T007S.

TYPES:
  BEGIN OF T_SKAT,
    SAKNR TYPE SKAT-SAKNR,
    TXT20 TYPE SKAT-TXT20,
  END OF T_SKAT,
  TT_SKAT TYPE STANDARD TABLE OF T_SKAT.

TYPES:
  BEGIN OF T_FINAL,
    BELNR      TYPE BKPF-BELNR,
    BUDAT      TYPE STRING, "char10, "bkpf-budat,
    BLART      TYPE BKPF-BLART,
    BKTXT      TYPE BKPF-BKTXT,
    XBLNR      TYPE BKPF-XBLNR,
    KUNNR      TYPE BSEG-KUNNR,
    NAME1      TYPE KNA1-NAME1,
    NAME2      TYPE KNA1-NAME2,        "Customer Name
    NAME       TYPE CHAR100,        "Customer Name
    VTEXT      TYPE TSKDT-VTEXT,
    STCD3      TYPE KNA1-STCD3,
    GST_REGION TYPE ZGST_REGION-GST_REGION,
    BEZEI      TYPE ZGST_REGION-BEZEI,
    SGTXT      TYPE BSEG-SGTXT,
    HSN_SAC    TYPE BSEG-HSN_SAC,
    MWSKZ      TYPE T007S-MWSKZ,
    TEXT1      TYPE T007S-TEXT1,
    FWBAS      TYPE BSET-FWBAS,
    WAERS      TYPE BKPF-WAERS,
    KURSF      TYPE BKPF-KURSF,
    HWBAS      TYPE BSET-HWBAS,
*    CGST_P     TYPE PRCD_ELEMENTS-KBETR,              "CGST %
    CGST_P     TYPE P DECIMALS 2,              "CGST %
    CGST       TYPE PRCD_ELEMENTS-KWERT,        "CGST
*    SGST_P     TYPE PRCD_ELEMENTS-KBETR,              "SGST %
    SGST_P     TYPE P DECIMALS 2,             "SGST %
    SGST       TYPE PRCD_ELEMENTS-KWERT,        "SGST
*    IGST_P     TYPE PRCD_ELEMENTS-KBETR,              "IGST %
    IGST_P     TYPE P DECIMALS 2,             "IGST %
    IGST       TYPE PRCD_ELEMENTS-KWERT,        "JOIG
    TOT        TYPE PRCD_ELEMENTS-KWERT,        "Grand Total
    SAKNR      TYPE SKAT-SAKNR,
    TXT20      TYPE SKAT-TXT20,
    ADDRESS    TYPE STRING,
    GJAHR      TYPE BKPF-GJAHR,
    REF_DATE   TYPE STRING,             " Abhishek Pisolkar (26.03.2018)
    TCS_RATE   TYPE P DECIMALS 3,
    TCS_AMT    TYPE PRCD_ELEMENTS-KWERT,
  END OF T_FINAL,
  TT_FINAL TYPE STANDARD TABLE OF T_FINAL.
DATA:
  GT_FINAL TYPE TT_FINAL.
*----------------Download file------------------------------
TYPES:
  BEGIN OF TY_FINAL ,
    BELNR      TYPE STRING, "bkpf-belnr,
    BUDAT      TYPE STRING, "char10, "bkpf-budat,
    BLART      TYPE STRING, "bkpf-blart,
    BKTXT      TYPE STRING, "bkpf-bktxt,
    XBLNR      TYPE STRING, "bkpf-xblnr,
    KUNNR      TYPE STRING, "bseg-kunnr,
    NAME1      TYPE STRING, "kna1-name1,
    VTEXT      TYPE STRING, "tskdt-vtext,
    STCD3      TYPE STRING, "kna1-stcd3,
    GST_REGION TYPE STRING, "zgst_region-gst_region,
    BEZEI      TYPE STRING, "zgst_region-bezei,
    SGTXT      TYPE STRING, "bseg-sgtxt,
    HSN_SAC    TYPE STRING, "bseg-hsn_sac,
    MWSKZ      TYPE STRING, "t007s-mwskz,
    TEXT1      TYPE STRING, "t007s-text1,
    FWBAS      TYPE STRING, "string, "bset-fwbas,
    WAERS      TYPE STRING, "bkpf-waers,
    KURSF      TYPE STRING, "bkpf-kursf,
    HWBAS      TYPE STRING, "string,"bset-hwbas,
    CGST_P     TYPE STRING, "string,"konv-kbetr,              "CGST %
    CGST       TYPE STRING, "string,"konv-kwert,        "CGST
    SGST_P     TYPE STRING, "string,"konv-kbetr,              "SGST %
    SGST       TYPE STRING, "string,"konv-kwert,        "SGST
    IGST_P     TYPE STRING, "string,"konv-kbetr,              "IGST %
    IGST       TYPE STRING, "string,"konv-kwert,        "JOIG
    TOT        TYPE STRING, "string,"konv-kwert,        "Grand Total
    SAKNR      TYPE STRING, "skat-saknr,
    TXT20      TYPE STRING, "skat-txt20,
    ADDRESS    TYPE STRING, "string,
    GJAHR      TYPE STRING, "bkpf-gjahr,
    REF_DATE   TYPE STRING, "string,              " Abhishek Pisolkar (26.03.2018)
    TCS_RATE   TYPE CHAR20,        " Added By Snehal Rajale ON 15 Jan 2021.
    TCS_AMT    TYPE CHAR20,
  END OF TY_FINAL.

DATA : IT_FINAL TYPE TABLE OF TY_FINAL ,   " Abhishek Pisolkar (26.03.2018)
       WA_FINAL TYPE TY_FINAL.
*--------------------------------------------------------------------*
TYPES : BEGIN OF LS_FIELDNAME,
          FIELD_NAME(25),
        END OF LS_FIELDNAME.

DATA : IT_FIELDNAME TYPE TABLE OF LS_FIELDNAME.
DATA : WA_FIELDNAME TYPE LS_FIELDNAME.

TYPES : BEGIN OF TY_BLART,
          BLART TYPE BKPF-BLART,
        END OF TY_BLART.
DATA : IT_BLART TYPE TABLE OF TY_BLART,
       WA_BLART TYPE TY_BLART.
SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE XYZ.
  SELECT-OPTIONS: SO_BELNR FOR TMP_BELNR,
                  SO_BUDAT FOR TMP_BUDAT, "DEFAULT '20170401' TO sy-datum,
                  SO_GJAHR FOR TMP_GJAHR OBLIGATORY, " DEFAULT '2017',
                  S_BLART FOR BKPF-BLART.       " Abhishek (27.03.2018)
SELECTION-SCREEN: END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE ABC .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK B5.

*****************************************************************************NEW ADD CODE ***********************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_BLART-LOW.
*BREAK-POINT.
  SELECT DISTINCT BLART FROM BKPF INTO TABLE IT_BLART WHERE BLART IN ('RV','DG','DR').
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE  = ' '
      RETFIELD        = 'BLART'
*     PVALKEY         = ' '
      DYNPPROG        = SY-CPROG
      DYNPNR          = SY-DYNNR
      DYNPROFIELD     = 'S_BLART'
      VALUE_ORG       = 'S'
    TABLES
      VALUE_TAB       = IT_BLART
*     FIELD_TAB       =
*     RETURN_TAB      =
*     DYNPFLD_MAPPING =
    EXCEPTIONS
      PARAMETER_ERROR = 1
      NO_VALUES_FOUND = 2
      OTHERS          = 3.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_BLART-HIGH.
*  SELECT blart from bkpf INTO TABLE it_blart WHERE blart in ('RV','DG','DR').
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE  = ' '
      RETFIELD        = 'BLART'
*     PVALKEY         = ' '
      DYNPPROG        = SY-CPROG
      DYNPNR          = SY-DYNNR
      DYNPROFIELD     = 'S_BLART'
      VALUE_ORG       = 'S'
    TABLES
      VALUE_TAB       = IT_BLART
*     FIELD_TAB       =
*     RETURN_TAB      =
*     DYNPFLD_MAPPING =
    EXCEPTIONS
      PARAMETER_ERROR = 1
      NO_VALUES_FOUND = 2
      OTHERS          = 3.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

*SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE pqr .
*PARAMETERS p_own AS CHECKBOX.
**PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\temp'.
*SELECTION-SCREEN END OF BLOCK b6.


INITIALIZATION.
  XYZ = 'Select Options'(tt1).
  ABC = 'Download File'(tt2).
*  pqr = 'Download File to Own PC'(tt3)."ADD CODE 23.03.2018

START-OF-SELECTION.
  PERFORM GET_DATA CHANGING GT_FINAL.
  PERFORM DISPLAY USING GT_FINAL.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM GET_DATA  CHANGING CT_FINAL TYPE TT_FINAL.
  DATA:
    LT_ACCOUNTING_DOC_HDR  TYPE TT_ACCOUNTING_DOC_HDR,
    LS_ACCOUNTING_DOC_HDR  TYPE T_ACCOUNTING_DOC_HDR,
    LT_ACCOUNTING_DOC_ITEM TYPE TT_ACCOUNTING_DOC_ITEM,
    LT_ACCOUNTING_DOC_ITM1 TYPE TT_ACCOUNTING_DOC_ITEM,
    LS_ACCOUNTING_DOC_ITM1 TYPE T_ACCOUNTING_DOC_ITEM,
    LS_ACCOUNTING_DOC_ITEM TYPE T_ACCOUNTING_DOC_ITEM,
    LT_BSET                TYPE TT_BSET,
    LS_BSET                TYPE T_BSET,
    LT_CUST_INFO           TYPE TT_CUST_INFO,
    LS_CUST_INFO           TYPE T_CUST_INFO,
    LT_T005U               TYPE TT_T005U,
    LS_T005U               TYPE T_T005U,
    LT_ZGST_REGION         TYPE TT_ZGST_REGION,
    LS_ZGST_REGION         TYPE T_ZGST_REGION,
    LT_KNVI                TYPE TT_KNVI,
    LS_KNVI                TYPE T_KNVI,
    LT_TSKDT               TYPE TT_TSKDT,
    LS_TSKDT               TYPE T_TSKDT,
    LT_T007S               TYPE TT_T007S,
    LS_T007S               TYPE T_T007S,
    LT_SKAT                TYPE TT_SKAT,
    LS_SKAT                TYPE T_SKAT,
    LS_FINAL               TYPE T_FINAL,
    LV_INDEX               TYPE SY-TABIX,
    LV_SHKZG               TYPE C,
    LT_ADRC                TYPE TT_ADRC,
    LS_ADRC                TYPE T_ADRC.

  IF S_BLART IS NOT INITIAL.
    SELECT BUKRS
           BELNR
           GJAHR
           BLART
           BUDAT
           XBLNR
           BKTXT
           WAERS
           KURSF
           STBLG
      FROM BKPF
      INTO TABLE LT_ACCOUNTING_DOC_HDR
      WHERE BELNR IN SO_BELNR
      AND   GJAHR IN SO_GJAHR
      AND   BUDAT IN SO_BUDAT
      AND   BLART IN S_BLART       "('RV','DG','DR') "DA AB
    AND   TCODE IN ('FB70','FB75','FB05','FB08','FBVB','FB01','FV70','FV75' )" ,'FBCJ','FB1D'). "FBCJ FB1D
      AND BUKRS = '1000'."ADDED BY MD
*      AND STBLG = ' '.
  ELSE.

    SELECT BUKRS
           BELNR
           GJAHR
           BLART
           BUDAT
           XBLNR
           BKTXT
           WAERS
           KURSF
           STBLG
      FROM BKPF
      INTO TABLE LT_ACCOUNTING_DOC_HDR
      WHERE BELNR IN SO_BELNR
      AND   GJAHR IN SO_GJAHR
      AND   BUDAT IN SO_BUDAT
      AND   BLART IN ('RV','DG','DR') ",'DA') "DA AB
      AND   TCODE IN ('FB70','FB75','FB05','FB08','FBVB','FB01','FV70','FV75' )" ,'FBCJ','FB1D'). "FBCJ FB1D
      AND BUKRS = '1000'."ADDED BY MD
*      AND STBLG = ' '.
  ENDIF.
*  IF NOT SY-SUBRC IS INITIAL.
**    MESSAGE 'Data Not Found' TYPE 'E'.
***************LOGIC FOR IF DATA NOT FOUND THEN BACKGROUND JOB RUN SUCCESSFULLY
*     MESSAGE 'Data Not Found' TYPE 'I' DISPLAY LIKE 'E'.."ADDED BY PRIMUS JYOTI ON 10.04.2024
*      LEAVE LIST-PROCESSING.
*  ENDIF.

  IF NOT LT_ACCOUNTING_DOC_HDR IS INITIAL.

    SELECT BUKRS
           BELNR
           GJAHR
           BUZEI
           BUZID
           AUGBL
           SHKZG
           MWSKZ
           DMBTR
           WRBTR
           TXGRP
           KTOSL
           ZUONR
           SGTXT
           SAKNR
           HKONT
           KUNNR
           XBILK
           HSN_SAC
           KOART
      FROM BSEG
      INTO TABLE LT_ACCOUNTING_DOC_ITEM
      FOR ALL ENTRIES IN LT_ACCOUNTING_DOC_HDR
      WHERE BELNR = LT_ACCOUNTING_DOC_HDR-BELNR
    AND   GJAHR = LT_ACCOUNTING_DOC_HDR-GJAHR.

    SELECT BUKRS
           BELNR
           GJAHR
           BUZEI
           SHKZG
           HWBAS
           FWBAS
           HWSTE
           FWSTE
           KTOSL
           KSCHL
           KBETR
           MWSKZ
      FROM BSET
      INTO TABLE LT_BSET
      FOR ALL ENTRIES IN LT_ACCOUNTING_DOC_HDR
      WHERE BELNR = LT_ACCOUNTING_DOC_HDR-BELNR
    AND   GJAHR = LT_ACCOUNTING_DOC_HDR-GJAHR.

*       else.
****************LOGIC FOR IF DATA NOT FOUND THEN BACKGROUND JOB RUN SUCCESSFULLY
*     MESSAGE 'Data Not Found' TYPE 'I' DISPLAY LIKE 'E'.."ADDED BY PRIMUS JYOTI ON 10.04.2024
*      LEAVE LIST-PROCESSING.
  ENDIF.


  IF LT_ACCOUNTING_DOC_ITEM IS NOT INITIAL.
    SELECT SAKNR
           TXT20
      FROM SKAT
      INTO TABLE LT_SKAT
      FOR ALL ENTRIES IN LT_ACCOUNTING_DOC_ITEM
      WHERE SAKNR = LT_ACCOUNTING_DOC_ITEM-HKONT
      AND   SPRAS = SY-LANGU
    AND   KTOPL = '1000'.

    SELECT MWSKZ
           TEXT1
      FROM T007S
      INTO TABLE LT_T007S
      FOR ALL ENTRIES IN LT_ACCOUNTING_DOC_ITEM
      WHERE MWSKZ = LT_ACCOUNTING_DOC_ITEM-MWSKZ
    AND   KALSM = 'ZTAXIN'.

    SELECT KUNNR
           NAME1
           NAME2
           LAND1
           REGIO
           ADRNR
           STCD3
      FROM KNA1
      INTO TABLE LT_CUST_INFO
      FOR ALL ENTRIES IN LT_ACCOUNTING_DOC_ITEM
    WHERE KUNNR = LT_ACCOUNTING_DOC_ITEM-KUNNR.
*    else.
*
*      MESSAGE 'Data Not Found' TYPE 'I' DISPLAY LIKE 'E'.."ADDED BY PRIMUS JYOTI ON 10.04.2024
*      LEAVE LIST-PROCESSING.
  ENDIF.

  IF NOT LT_CUST_INFO IS INITIAL.
    SELECT ADDRNUMBER
             NAME1
             CITY2
             POST_CODE1
             STREET
             STR_SUPPL1
             STR_SUPPL2
             STR_SUPPL3
             LOCATION
             COUNTRY
        FROM ADRC
        INTO TABLE LT_ADRC
        FOR ALL ENTRIES IN LT_CUST_INFO
    WHERE ADDRNUMBER = LT_CUST_INFO-ADRNR.

    SELECT KUNNR
           TAXKD
      FROM KNVI
      INTO TABLE LT_KNVI
      FOR ALL ENTRIES IN LT_CUST_INFO
      WHERE KUNNR = LT_CUST_INFO-KUNNR
    AND   TATYP IN ('JOCG','JOIG').

    IF SY-SUBRC IS INITIAL.
      SELECT TATYP
             TAXKD
             VTEXT
        FROM TSKDT
        INTO TABLE LT_TSKDT
        FOR ALL ENTRIES IN LT_KNVI
        WHERE TAXKD = LT_KNVI-TAXKD
      AND   SPRAS = SY-LANGU.


    ENDIF.
    SELECT LAND1
           BLAND
           BEZEI
      FROM T005U
      INTO TABLE LT_T005U
      FOR ALL ENTRIES IN LT_CUST_INFO
      WHERE SPRAS = SY-LANGU
      AND   LAND1 = LT_CUST_INFO-LAND1
    AND   BLAND = LT_CUST_INFO-REGIO.

    SELECT GST_REGION
           BEZEI
      FROM ZGST_REGION
      INTO TABLE LT_ZGST_REGION
      FOR ALL ENTRIES IN LT_T005U
    WHERE BEZEI = LT_T005U-BEZEI.

  ENDIF.


  SORT LT_ACCOUNTING_DOC_HDR BY BELNR GJAHR.
  SORT LT_ACCOUNTING_DOC_ITEM BY BELNR GJAHR BUZEI.
  SORT LT_BSET BY BELNR GJAHR BUZEI.

  DATA:
  LV_FLAG TYPE C.
  LT_ACCOUNTING_DOC_ITM1[] = LT_ACCOUNTING_DOC_ITEM[].
  DELETE LT_ACCOUNTING_DOC_ITM1 WHERE KUNNR = SPACE.
*  BREAK primus.
  LOOP AT LT_ACCOUNTING_DOC_ITEM INTO LS_ACCOUNTING_DOC_ITEM WHERE KUNNR NE SPACE.
    LS_FINAL-BELNR   = LS_ACCOUNTING_DOC_ITEM-BELNR.
    LS_FINAL-GJAHR   = LS_ACCOUNTING_DOC_ITEM-GJAHR.
    LS_FINAL-KUNNR   = LS_ACCOUNTING_DOC_ITEM-KUNNR.
    LS_FINAL-SGTXT   = LS_ACCOUNTING_DOC_ITEM-SGTXT.

*    ls_final-dmbtr   = ls_accounting_doc_item-dmbtr.
*    ls_final-wrbtr   = ls_accounting_doc_item-wrbtr.
*****************added by joti on 02.04.2024***************************************************************************
    READ TABLE LT_ACCOUNTING_DOC_ITEM INTO DATA(LS_ACCOUNTING_DOC_ITEM_1) WITH KEY  BELNR = LS_ACCOUNTING_DOC_ITEM-BELNR
                                                                           GJAHR = LS_ACCOUNTING_DOC_ITEM-GJAHR
                                                                           KUNNR = SPACE.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-HSN_SAC = LS_ACCOUNTING_DOC_ITEM_1-HSN_SAC.
    ENDIF.
    IF  LS_FINAL-HSN_SAC  IS INITIAL.
      LS_FINAL-HSN_SAC = LS_ACCOUNTING_DOC_ITEM-HSN_SAC.
    ENDIF.
* ************************************************************************
    READ TABLE LT_ACCOUNTING_DOC_HDR INTO LS_ACCOUNTING_DOC_HDR WITH KEY BELNR = LS_ACCOUNTING_DOC_ITEM-BELNR
                                                                         GJAHR = LS_ACCOUNTING_DOC_ITEM-GJAHR.
    IF SY-SUBRC IS INITIAL.
*      CONCATENATE ls_accounting_doc_hdr-budat+6(2) ls_accounting_doc_hdr-budat+4(2) ls_accounting_doc_hdr-budat+0(4)
*                  INTO ls_final-budat SEPARATED BY '-'.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_ACCOUNTING_DOC_HDR-BUDAT
        IMPORTING
          OUTPUT = LS_FINAL-BUDAT.
      CONCATENATE LS_FINAL-BUDAT+0(2) LS_FINAL-BUDAT+2(3) LS_FINAL-BUDAT+5(4)
                     INTO LS_FINAL-BUDAT SEPARATED BY '-'.
*--------------------------------------------------------------------*

      LS_FINAL-BLART = LS_ACCOUNTING_DOC_HDR-BLART.
      LS_FINAL-XBLNR = LS_ACCOUNTING_DOC_HDR-XBLNR.
      LS_FINAL-BKTXT = LS_ACCOUNTING_DOC_HDR-BKTXT.
      LS_FINAL-WAERS = LS_ACCOUNTING_DOC_HDR-WAERS.
      LS_FINAL-KURSF = LS_ACCOUNTING_DOC_HDR-KURSF.
    ENDIF.


***    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
***                                             gjahr = ls_accounting_doc_item-gjahr
***                                             kschl = 'JOCG'.
***    IF sy-subrc IS INITIAL.
***      ls_final-hwbas   = ls_bset-hwbas.
***      ls_final-fwbas   = ls_bset-fwbas.
***      ls_final-cgst   = ls_bset-hwste.
***      ls_final-cgst_p = ls_bset-kbetr / 10.
***    ENDIF.
***
***    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
***                                             gjahr = ls_accounting_doc_item-gjahr
***                                             kschl = 'JOSG'.
***    IF sy-subrc IS INITIAL.
***      ls_final-sgst   = ls_bset-hwste.
***      ls_final-sgst_p = ls_bset-kbetr / 10.
***    ENDIF.
***
***    READ TABLE lt_bset INTO ls_bset WITH KEY belnr = ls_accounting_doc_item-belnr
***                                             gjahr = ls_accounting_doc_item-gjahr
***                                             kschl = 'JOIG'.
***    IF sy-subrc IS INITIAL.
***      ls_final-hwbas   = ls_bset-hwbas.
***      ls_final-fwbas   = ls_bset-fwbas.
***      ls_final-igst   = ls_bset-hwste.
***      ls_final-igst_p = ls_bset-kbetr / 10.
***    ENDIF.

    READ TABLE LT_BSET INTO LS_BSET WITH KEY BELNR = LS_ACCOUNTING_DOC_ITEM-BELNR
                                             GJAHR = LS_ACCOUNTING_DOC_ITEM-GJAHR.
    IF SY-SUBRC IS INITIAL.
      LV_INDEX = SY-TABIX.

      LOOP AT LT_BSET INTO LS_BSET FROM LV_INDEX.

        DELETE LT_BSET WHERE KTOSL = 'JTC' AND KBETR = '0.00'.
        IF LS_BSET-BELNR = LS_ACCOUNTING_DOC_ITEM-BELNR AND LS_BSET-GJAHR = LS_ACCOUNTING_DOC_ITEM-GJAHR.
***          IF ls_accounting_doc_hdr-blart = 'DG'.
***            IF ls_bset-shkzg = 'S'.
***              lv_shkzg = 'H'.
***            else.
***              lv_shkzg = 'S'.
***            ENDIF.
***          else.
          LV_SHKZG = LS_BSET-SHKZG.
***          ENDIF.

*          READ TABLE lt_bsEt INTO ls_bset with key ktosl = 'JTC' buzei = ls_bset-buzei.
*          IF SY-SUBRC = 0.
*
*            ls_final-tcs_rate =  ls_bset-kbetr / 10.
*            ls_final-tcs_Amt = ls_final-tcs_amt + ls_bset-fwste.
*
*          ENDIF.
          CASE LS_BSET-KSCHL.
            WHEN 'JOCG'.
              IF LV_SHKZG = 'S'.
                LS_FINAL-CGST    = LS_FINAL-CGST - LS_BSET-HWSTE.
                LS_FINAL-HWBAS   = LS_FINAL-HWBAS - LS_BSET-HWBAS.
                LS_FINAL-FWBAS   = LS_FINAL-FWBAS - LS_BSET-FWBAS.

              ELSE.
                LS_FINAL-HWBAS   = LS_FINAL-HWBAS + LS_BSET-HWBAS.
                LS_FINAL-FWBAS   = LS_FINAL-FWBAS + LS_BSET-FWBAS.

                LS_FINAL-CGST    = LS_FINAL-CGST + LS_BSET-HWSTE.
              ENDIF.
              LV_FLAG = 'X'.
              IF NOT LS_BSET-KBETR IS INITIAL.
                LS_FINAL-CGST_P  = LS_BSET-KBETR / 10.
*                LS_FINAL-CGST_P  = LS_BSET-KBETR .  "" ADDED BY MAHADEV ON 05/06/2025
                LS_FINAL-MWSKZ = LS_BSET-MWSKZ.
              ENDIF.

            WHEN 'JICG'.
              IF LV_SHKZG = 'S'.
                LS_FINAL-CGST    = LS_FINAL-CGST - LS_BSET-HWSTE.
                LS_FINAL-HWBAS   = LS_FINAL-HWBAS - LS_BSET-HWBAS.
                LS_FINAL-FWBAS   = LS_FINAL-FWBAS - LS_BSET-FWBAS.

              ELSE.
                LS_FINAL-CGST    = LS_FINAL-CGST + LS_BSET-HWSTE.
                LS_FINAL-HWBAS   = LS_FINAL-HWBAS + LS_BSET-HWBAS.
                LS_FINAL-FWBAS   = LS_FINAL-FWBAS + LS_BSET-FWBAS.

              ENDIF.

**************************added by DH************
              IF LS_FINAL-BLART = 'DG'.
                IF  LS_FINAL-CGST GT '0'.
                  LS_FINAL-CGST =  LS_FINAL-CGST * -1.
                ENDIF.
              ENDIF.
************************************************

*              IF NOT ls_bset-kbetr IS INITIAL.
              LS_FINAL-CGST_P  = LS_BSET-KBETR / 10.
*              LS_FINAL-CGST_P  = LS_BSET-KBETR . "" ADDED BY MAHADEV ON 05/06/2025
              LS_FINAL-MWSKZ = LS_BSET-MWSKZ.
*              ENDIF.
              LV_FLAG = 'X'.

            WHEN 'JOSG'.
              IF LV_SHKZG = 'S'.
                LS_FINAL-SGST    = LS_FINAL-SGST - LS_BSET-HWSTE.
              ELSE.
                LS_FINAL-SGST    = LS_FINAL-SGST + LS_BSET-HWSTE.
              ENDIF.

              IF NOT LS_BSET-KBETR IS INITIAL.
                LS_FINAL-SGST_P  = LS_BSET-KBETR / 10.
*                LS_FINAL-SGST_P  = LS_BSET-KBETR  .  "" ADDED BY MAHADEV ON 05/06/2025
*              ls_final-mwskz = ls_bset-mwskz.
              ENDIF.

            WHEN 'JISG'.
              IF LV_SHKZG = 'S'.
                LS_FINAL-SGST    = LS_FINAL-SGST - LS_BSET-HWSTE.
              ELSE.
                LS_FINAL-SGST    = LS_FINAL-SGST + LS_BSET-HWSTE.
              ENDIF.

***********************added by DH
              IF LS_FINAL-BLART = 'DG'.
                IF  LS_FINAL-SGST GT '0'.
                  LS_FINAL-SGST =  LS_FINAL-SGST * -1.
                ENDIF.
              ENDIF.
*************************************

              IF NOT LS_BSET-KBETR IS INITIAL.
                LS_FINAL-SGST_P  = LS_BSET-KBETR / 10.
*                LS_FINAL-SGST_P  = LS_BSET-KBETR  . "" ADDED BY MAHADEV ON 05/06/2025
*                ls_final-mwskz = ls_bset-mwskz.
              ENDIF.

            WHEN 'JOIG'.
              IF LV_SHKZG = 'S'.
                LS_FINAL-IGST    = LS_FINAL-IGST - LS_BSET-HWSTE.
                LS_FINAL-HWBAS   = LS_FINAL-HWBAS - LS_BSET-HWBAS.
                LS_FINAL-FWBAS   = LS_FINAL-FWBAS - LS_BSET-FWBAS.

              ELSE.
                LS_FINAL-IGST    = LS_FINAL-IGST + LS_BSET-HWSTE.
                LS_FINAL-HWBAS   = LS_FINAL-HWBAS + LS_BSET-HWBAS.
                LS_FINAL-FWBAS   = LS_FINAL-FWBAS + LS_BSET-FWBAS.

              ENDIF.
              LV_FLAG = 'X'.
              IF NOT LS_BSET-KBETR IS INITIAL.
                LS_FINAL-IGST_P  = LS_BSET-KBETR / 10.
*                LS_FINAL-IGST_P  = LS_BSET-KBETR .  "" ADDED BY MAHADEV ON 05/06/2025
                LS_FINAL-MWSKZ = LS_BSET-MWSKZ.
              ENDIF.


            WHEN 'JIIG'.
              IF LV_SHKZG = 'S'.
                LS_FINAL-IGST    = LS_FINAL-IGST - LS_BSET-HWSTE.
                LS_FINAL-HWBAS   = LS_FINAL-HWBAS - LS_BSET-HWBAS.
                LS_FINAL-FWBAS   = LS_FINAL-FWBAS - LS_BSET-FWBAS.

              ELSE.
                LS_FINAL-IGST    = LS_FINAL-IGST + LS_BSET-HWSTE.
                LS_FINAL-HWBAS   = LS_FINAL-HWBAS + LS_BSET-HWBAS.
                LS_FINAL-FWBAS   = LS_FINAL-FWBAS + LS_BSET-FWBAS.

              ENDIF.

************************added by DH
              IF LS_FINAL-BLART = 'DG'.
                IF  LS_FINAL-IGST GT '0'.
                  LS_FINAL-IGST =  LS_FINAL-IGST * -1.
                ENDIF.
              ENDIF.
********************************

              IF NOT LS_BSET-KBETR IS INITIAL.
                LS_FINAL-IGST_P  = LS_BSET-KBETR / 10.
*                LS_FINAL-IGST_P  = LS_BSET-KBETR  . "" ADDED BY MAHADEV ON 05/06/2025
                LS_FINAL-MWSKZ = LS_BSET-MWSKZ.
              ENDIF.
              LV_FLAG = 'X'.

*          WHEN 'JTC'.
*              ls_final-tcs_rate = ls_bset-kbetr / 10.
*              ls_final-tcs_Amt = ls_final-tcs_amt + ls_bset-hwste.
*
*            lv_flag = 'X'.
          ENDCASE.

*          IF ls_final-blart = 'DG'.
*            IF  ls_final-tcs_amt GT '0'.
*              ls_final-tcs_amt =  ls_final-tcs_amt * -1.
*            ENDIF.
*          ENDIF.

          CASE LS_BSET-KTOSL.
            WHEN 'JTC'.
              LS_FINAL-TCS_RATE = LS_BSET-KBETR / 10.
              LS_FINAL-TCS_AMT = LS_FINAL-TCS_AMT + LS_BSET-FWSTE.

******************added by DH******************
              IF LS_FINAL-BLART = 'DG'.
                IF  LS_FINAL-TCS_AMT GT '0'.
                  LS_FINAL-TCS_AMT =  LS_FINAL-TCS_AMT * -1.
                ENDIF.
              ENDIF.
**********************************************


          ENDCASE.
        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
    IF LV_FLAG IS INITIAL.
      READ TABLE LT_BSET INTO LS_BSET WITH KEY BELNR = LS_ACCOUNTING_DOC_ITEM-BELNR
                                               GJAHR = LS_ACCOUNTING_DOC_ITEM-GJAHR.
      IF SY-SUBRC IS INITIAL.
        IF LS_BSET-SHKZG = 'S'.
          LS_FINAL-HWBAS   = LS_BSET-HWBAS * -1.
          LS_FINAL-FWBAS   = LS_BSET-FWBAS * -1.
        ELSE.
          LS_FINAL-HWBAS   = LS_BSET-HWBAS.
          LS_FINAL-FWBAS   = LS_BSET-FWBAS.
        ENDIF.
        LS_FINAL-MWSKZ = LS_BSET-MWSKZ.
      ELSE.



**        READ TABLE lt_accounting_doc_item INTO ls_accounting_doc_itm1 WITH KEY belnr = ls_accounting_doc_item-belnr
**                                                                               gjahr = ls_accounting_doc_item-gjahr
**                                                                               xbilk = space.
        READ TABLE LT_ACCOUNTING_DOC_ITEM INTO LS_ACCOUNTING_DOC_ITM1 WITH KEY BELNR = LS_ACCOUNTING_DOC_ITEM-BELNR
                                                                               GJAHR = LS_ACCOUNTING_DOC_ITEM-GJAHR
                                                                               KTOSL = SPACE
                                                                               SAKNR = SPACE.
        IF SY-SUBRC IS INITIAL.
          IF LS_ACCOUNTING_DOC_ITM1-SHKZG = 'S'.
            LS_FINAL-HWBAS   = LS_ACCOUNTING_DOC_ITM1-DMBTR * -1.
            LS_FINAL-FWBAS   = LS_ACCOUNTING_DOC_ITM1-DMBTR * -1.
          ELSE.
            LS_FINAL-HWBAS   = LS_ACCOUNTING_DOC_ITM1-DMBTR.
            LS_FINAL-FWBAS   = LS_ACCOUNTING_DOC_ITM1-DMBTR.
          ENDIF.
*    ****
        ELSE.
          READ TABLE LT_ACCOUNTING_DOC_ITEM INTO LS_ACCOUNTING_DOC_ITM1 WITH KEY BELNR = LS_ACCOUNTING_DOC_ITEM-BELNR
                                                                               GJAHR = LS_ACCOUNTING_DOC_ITEM-GJAHR
                                                                               KOART = 'D'
                                                                               SHKZG = 'S'.
          IF SY-SUBRC IS INITIAL.
            IF LS_ACCOUNTING_DOC_ITM1-SHKZG = 'S'.
              LS_FINAL-HWBAS   = LS_ACCOUNTING_DOC_ITM1-DMBTR * -1.
              LS_FINAL-FWBAS   = LS_ACCOUNTING_DOC_ITM1-DMBTR * -1.
            ELSE.
              LS_FINAL-HWBAS   = LS_ACCOUNTING_DOC_ITM1-DMBTR.
              LS_FINAL-FWBAS   = LS_ACCOUNTING_DOC_ITM1-DMBTR.
            ENDIF.
          ENDIF.

*         ***
        ENDIF.
      ENDIF.

********************ADDED BY DH 10.10.2022
      IF LS_FINAL-BLART = 'DG'.
        IF  LS_FINAL-FWBAS GT '0'.
          LS_FINAL-FWBAS =  LS_FINAL-FWBAS * -1.
        ENDIF.
*        IF LS_ACCOUNTING_DOC_ITEM-AUGBL IS NOT INITIAL.
*          LS_FINAL-FWBAS = 0.
*        ENDIF.
      ENDIF.
**********************************************

    ENDIF.

    IF LS_FINAL-MWSKZ IS INITIAL.
      LS_FINAL-MWSKZ = LS_ACCOUNTING_DOC_ITM1-MWSKZ.
    ENDIF.
    READ TABLE LT_T007S INTO LS_T007S WITH KEY MWSKZ = LS_FINAL-MWSKZ.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-TEXT1 = LS_T007S-TEXT1.
    ENDIF.
    READ TABLE LT_CUST_INFO INTO LS_CUST_INFO WITH KEY KUNNR = LS_ACCOUNTING_DOC_ITEM-KUNNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-NAME1 = LS_CUST_INFO-NAME1.
      LS_FINAL-NAME2 = LS_CUST_INFO-NAME2.

      CONCATENATE LS_FINAL-NAME1 LS_FINAL-NAME2 INTO LS_FINAL-NAME SEPARATED BY SPACE.
      LS_FINAL-STCD3 = LS_CUST_INFO-STCD3.
    ENDIF.
    READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_CUST_INFO-ADRNR.
    IF SY-SUBRC IS INITIAL.
      IF NOT LS_ADRC-STR_SUPPL1 IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-STR_SUPPL1 INTO LS_FINAL-ADDRESS.
      ENDIF.

      IF NOT LS_ADRC-STR_SUPPL2 IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-STR_SUPPL2 INTO LS_FINAL-ADDRESS.
      ENDIF.

      IF NOT LS_ADRC-STREET IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-STREET INTO LS_FINAL-ADDRESS.
      ENDIF.

      IF NOT LS_ADRC-STR_SUPPL3 IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-STR_SUPPL3 INTO LS_FINAL-ADDRESS SEPARATED BY ','.
      ENDIF.
      IF NOT LS_ADRC-LOCATION IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-LOCATION INTO LS_FINAL-ADDRESS SEPARATED BY ','.
      ENDIF.

      IF NOT LS_ADRC-CITY2 IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS LS_ADRC-CITY2 INTO LS_FINAL-ADDRESS SEPARATED BY ','.
      ENDIF.
      IF NOT LS_ADRC-POST_CODE1 IS INITIAL.
        CONCATENATE LS_FINAL-ADDRESS 'PIN:' LS_ADRC-POST_CODE1 INTO LS_FINAL-ADDRESS SEPARATED BY ','.
      ENDIF.
      CONDENSE LS_FINAL-ADDRESS.
    ENDIF.
    READ TABLE LT_T005U INTO LS_T005U WITH KEY LAND1 = LS_CUST_INFO-LAND1
                                               BLAND = LS_CUST_INFO-REGIO.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-BEZEI = LS_T005U-BEZEI.
    ENDIF.

    IF LS_CUST_INFO-LAND1 = 'IN'.
      READ TABLE LT_KNVI INTO LS_KNVI WITH KEY KUNNR = LS_CUST_INFO-KUNNR.
      IF SY-SUBRC IS INITIAL.
        IF LS_CUST_INFO-REGIO = '13'.
          READ TABLE LT_TSKDT INTO LS_TSKDT WITH KEY TATYP = 'JOCG'.
          IF SY-SUBRC IS INITIAL.
            LS_FINAL-VTEXT = LS_TSKDT-VTEXT.
          ENDIF.
        ELSE.
          READ TABLE LT_TSKDT INTO LS_TSKDT WITH KEY TATYP = 'JOIG'.
          IF SY-SUBRC IS INITIAL.
            LS_FINAL-VTEXT = LS_TSKDT-VTEXT.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    READ TABLE LT_ZGST_REGION INTO LS_ZGST_REGION WITH KEY BEZEI = LS_T005U-BEZEI.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-GST_REGION = LS_ZGST_REGION-GST_REGION.
    ENDIF.

    READ TABLE LT_ACCOUNTING_DOC_ITEM INTO LS_ACCOUNTING_DOC_ITM1 WITH KEY BELNR = LS_ACCOUNTING_DOC_ITEM-BELNR
                                                                           GJAHR = LS_ACCOUNTING_DOC_ITEM-GJAHR
                                                                           KTOSL = SPACE
                                                                           SAKNR = SPACE.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-SAKNR = LS_ACCOUNTING_DOC_ITM1-HKONT.
    ELSE.
      READ TABLE LT_ACCOUNTING_DOC_ITEM INTO LS_ACCOUNTING_DOC_ITM1 WITH KEY BELNR = LS_ACCOUNTING_DOC_ITEM-BELNR
                                                                          GJAHR = LS_ACCOUNTING_DOC_ITEM-GJAHR
                                                                          KOART = 'D'
                                                                          SHKZG = 'S'.
      IF SY-SUBRC IS INITIAL.
        LS_FINAL-SAKNR = LS_ACCOUNTING_DOC_ITM1-HKONT.
      ENDIF.
    ENDIF.

    READ TABLE LT_SKAT INTO LS_SKAT WITH KEY SAKNR = LS_FINAL-SAKNR.
    IF SY-SUBRC IS INITIAL.
      LS_FINAL-TXT20 = LS_SKAT-TXT20.
    ENDIF.

    LS_FINAL-TOT = LS_FINAL-HWBAS + LS_FINAL-CGST + LS_FINAL-SGST + LS_FINAL-IGST.

    IF LS_FINAL-BLART = 'DG' OR LS_FINAL-BLART = 'DR'.

*        IF LS_ACCOUNTING_DOC_ITEM-AUGBL IS NOT INITIAL.
      IF LS_ACCOUNTING_DOC_HDR-STBLG IS NOT INITIAL."added by jyoti on 02.04.2024
        LS_FINAL-FWBAS = 0.
        LS_FINAL-HWBAS = 0.
        LS_FINAL-CGST = 0.
        LS_FINAL-CGST_P = 0.
        LS_FINAL-SGST = 0.
        LS_FINAL-SGST_P = 0.
        LS_FINAL-IGST = 0.
        LS_FINAL-TOT = 0.
        LS_FINAL-TCS_RATE = 0.
        LS_FINAL-TCS_AMT = 0.
      ENDIF.
    ENDIF.

*---------------Refreshable Date-----------------------
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = LS_FINAL-REF_DATE.
    CONCATENATE LS_FINAL-REF_DATE+0(2) LS_FINAL-REF_DATE+2(3) LS_FINAL-REF_DATE+5(4)
                   INTO LS_FINAL-REF_DATE SEPARATED BY '-'.
*--------------------------------------------------------------------*
    APPEND LS_FINAL TO CT_FINAL.
****************added  by primus jyori on

    WA_FINAL-BELNR      =     LS_FINAL-BELNR     .
    WA_FINAL-BUDAT      =     LS_FINAL-BUDAT     .
    WA_FINAL-BLART      =     LS_FINAL-BLART     .
    WA_FINAL-BKTXT      =     LS_FINAL-BKTXT     .
    WA_FINAL-XBLNR      =     LS_FINAL-XBLNR     .
    WA_FINAL-KUNNR      =     LS_FINAL-KUNNR     .
    WA_FINAL-NAME1      =     LS_FINAL-NAME1     .
    WA_FINAL-VTEXT      =     LS_FINAL-VTEXT     .
    WA_FINAL-STCD3      =     LS_FINAL-STCD3     .
    WA_FINAL-GST_REGION =     LS_FINAL-GST_REGION.
    WA_FINAL-BEZEI      =     LS_FINAL-BEZEI     .
    WA_FINAL-SGTXT      =     LS_FINAL-SGTXT     .
    WA_FINAL-HSN_SAC    =     LS_FINAL-HSN_SAC   .
    WA_FINAL-MWSKZ      =     LS_FINAL-MWSKZ     .
    WA_FINAL-TEXT1      =     LS_FINAL-TEXT1     .
    WA_FINAL-FWBAS      =     LS_FINAL-FWBAS     .
    WA_FINAL-WAERS      =     LS_FINAL-WAERS     .
    WA_FINAL-KURSF      =     LS_FINAL-KURSF     .
    WA_FINAL-HWBAS      =     LS_FINAL-HWBAS     .
    WA_FINAL-CGST_P     =     LS_FINAL-CGST_P    .
    WA_FINAL-CGST       =     LS_FINAL-CGST      .
    WA_FINAL-SGST_P     =     LS_FINAL-SGST_P    .
    WA_FINAL-SGST       =     LS_FINAL-SGST      .
    WA_FINAL-IGST_P     =     LS_FINAL-IGST_P    .
    WA_FINAL-IGST       =     LS_FINAL-IGST      .
    WA_FINAL-TOT        =     LS_FINAL-TOT       .
    WA_FINAL-SAKNR      =     LS_FINAL-SAKNR     .
    WA_FINAL-TXT20      =     LS_FINAL-TXT20     .
    WA_FINAL-ADDRESS    =     LS_FINAL-ADDRESS   .
    WA_FINAL-GJAHR      =     LS_FINAL-GJAHR     .
    WA_FINAL-REF_DATE   =     LS_FINAL-REF_DATE  .
    WA_FINAL-TCS_RATE   =     LS_FINAL-TCS_RATE.
    WA_FINAL-TCS_AMT    =     LS_FINAL-TCS_AMT.
*------------------Refreshable Date / Shift negative sign to left logic ------------------------------------------
*BREAK primus.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WA_FINAL-CGST.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WA_FINAL-SGST.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WA_FINAL-IGST.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WA_FINAL-FWBAS.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WA_FINAL-TOT.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WA_FINAL-HWBAS.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WA_FINAL-TCS_AMT.

    APPEND WA_FINAL TO IT_FINAL.





**********************************************************************************************


    CLEAR:
      LS_FINAL,LS_BSET,LS_ACCOUNTING_DOC_ITEM,LS_ACCOUNTING_DOC_ITM1,LS_ACCOUNTING_DOC_HDR,LS_CUST_INFO,LS_ZGST_REGION,
      LS_TSKDT,LS_T005U,LS_SKAT,LV_FLAG.

  ENDLOOP.
*  BREAK-POINT.
  SORT CT_FINAL BY BELNR GJAHR.
  DELETE ADJACENT DUPLICATES FROM CT_FINAL COMPARING BELNR FWBAS .
  DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING BELNR FWBAS .
*  LOOP AT CT_FINAL INTO LS_FINAL.
*    WA_FINAL-BELNR      =     LS_FINAL-BELNR     .
*    WA_FINAL-BUDAT      =     LS_FINAL-BUDAT     .
*    WA_FINAL-BLART      =     LS_FINAL-BLART     .
*    WA_FINAL-BKTXT      =     LS_FINAL-BKTXT     .
*    WA_FINAL-XBLNR      =     LS_FINAL-XBLNR     .
*    WA_FINAL-KUNNR      =     LS_FINAL-KUNNR     .
*    WA_FINAL-NAME1      =     LS_FINAL-NAME1     .
*    WA_FINAL-VTEXT      =     LS_FINAL-VTEXT     .
*    WA_FINAL-STCD3      =     LS_FINAL-STCD3     .
*    WA_FINAL-GST_REGION =     LS_FINAL-GST_REGION.
*    WA_FINAL-BEZEI      =     LS_FINAL-BEZEI     .
*    WA_FINAL-SGTXT      =     LS_FINAL-SGTXT     .
*    WA_FINAL-HSN_SAC    =     LS_FINAL-HSN_SAC   .
*    WA_FINAL-MWSKZ      =     LS_FINAL-MWSKZ     .
*    WA_FINAL-TEXT1      =     LS_FINAL-TEXT1     .
*    WA_FINAL-FWBAS      =     LS_FINAL-FWBAS     .
*    WA_FINAL-WAERS      =     LS_FINAL-WAERS     .
*    WA_FINAL-KURSF      =     LS_FINAL-KURSF     .
*    WA_FINAL-HWBAS      =     LS_FINAL-HWBAS     .
*    WA_FINAL-CGST_P     =     LS_FINAL-CGST_P    .
*    WA_FINAL-CGST       =     LS_FINAL-CGST      .
*    WA_FINAL-SGST_P     =     LS_FINAL-SGST_P    .
*    WA_FINAL-SGST       =     LS_FINAL-SGST      .
*    WA_FINAL-IGST_P     =     LS_FINAL-IGST_P    .
*    WA_FINAL-IGST       =     LS_FINAL-IGST      .
*    WA_FINAL-TOT        =     LS_FINAL-TOT       .
*    WA_FINAL-SAKNR      =     LS_FINAL-SAKNR     .
*    WA_FINAL-TXT20      =     LS_FINAL-TXT20     .
*    WA_FINAL-ADDRESS    =     LS_FINAL-ADDRESS   .
*    WA_FINAL-GJAHR      =     LS_FINAL-GJAHR     .
*    WA_FINAL-REF_DATE   =     LS_FINAL-REF_DATE  .
*    WA_FINAL-TCS_RATE   =     LS_FINAL-TCS_RATE.
*    WA_FINAL-TCS_AMT    =     LS_FINAL-TCS_AMT.
**------------------Refreshable Date / Shift negative sign to left logic ------------------------------------------
**BREAK primus.
*    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*      CHANGING
*        VALUE = WA_FINAL-CGST.
*
*    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*      CHANGING
*        VALUE = WA_FINAL-SGST.
*
*    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*      CHANGING
*        VALUE = WA_FINAL-IGST.
*
*    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*      CHANGING
*        VALUE = WA_FINAL-FWBAS.
*
*    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*      CHANGING
*        VALUE = WA_FINAL-TOT.
*
*    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*      CHANGING
*        VALUE = WA_FINAL-HWBAS.
*
*    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*      CHANGING
*        VALUE = WA_FINAL-TCS_AMT.
*
*    APPEND WA_FINAL TO IT_FINAL.
*    CLEAR : LS_FINAL, WA_FINAL.
*  ENDLOOP.

*   IF ct_final IS INITIAL.
***    MESSAGE 'Data Not Found' TYPE 'E'.
***************LOGIC FOR IF DATA NOT FOUND THEN BACKGROUND JOB RUN SUCCESSFULLY
*     MESSAGE 'Data Not Found' TYPE 'I' DISPLAY LIKE 'E'.."ADDED BY PRIMUS JYOTI ON 10.04.2024
*      LEAVE LIST-PROCESSING.
*  ENDIF.


*  it_final[] = ct_final[].         " Abhishek Pisolkar (26.03.2018)
*  BREAK primus.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM DISPLAY  USING    CT_FINAL TYPE TT_FINAL.
  DATA:
    LT_FIELDCAT     TYPE SLIS_T_FIELDCAT_ALV,
    LS_ALV_LAYOUT   TYPE SLIS_LAYOUT_ALV,
    L_CALLBACK_PROG TYPE SY-REPID.

  L_CALLBACK_PROG = SY-REPID.

  PERFORM PREPARE_DISPLAY CHANGING LT_FIELDCAT.
  CLEAR LS_ALV_LAYOUT.
  LS_ALV_LAYOUT-ZEBRA = 'X'.
  LS_ALV_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.

****************************************************************************************ADD CODE 23.03.2018*****************************
*  IF p_own = 'X'.
**    PERFORM fieldnames.
**    PERFORM download_log.
*  ENDIF.
***************************************************************************************end code 23,03,2018**********************************

DATA IS_VARIANT TYPE DISVARIANT.

IS_VARIANT-REPORT = SY-CPROG.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM      = L_CALLBACK_PROG
*     I_CALLBACK_PF_STATUS_SET          = ' '
      I_CALLBACK_USER_COMMAND = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
      IS_LAYOUT               = LS_ALV_LAYOUT
      IT_FIELDCAT             = LT_FIELDCAT
      IS_VARIANT              = IS_VARIANT
      I_SAVE                  = 'X'
    TABLES
      T_OUTTAB                = CT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM PREPARE_DISPLAY  CHANGING CT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV .
  DATA:
    GV_POS      TYPE I,
    LS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

  REFRESH CT_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BELNR'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Accounting Doc.No.'(100).
  LS_FIELDCAT-COL_POS   = GV_POS.
  LS_FIELDCAT-HOTSPOT   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BUDAT'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Doc.Date'(101).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BLART'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'FI Doc.Type'(102).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BKTXT'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Original Doc.No.'(103).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'XBLNR'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Invoice No.'(104).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KUNNR'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer Code'(105).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'NAME'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Name'(106).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'VTEXT'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'REGD/URD/SEZ/DEEMED/GOV'(107).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STCD3'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer GSTIN'(108).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'GST_REGION'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer State Code'(109).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BEZEI'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Customer State Name'(110).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SGTXT'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Description'(111).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'HSN_SAC'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'HSN/SAC'(112).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MWSKZ'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Tax Code'(113).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TEXT1'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Tax Code Description'(114).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'FWBAS'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Basic Amount(DC) '(115).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'WAERS'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Currency'(116).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'KURSF'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Exchange Rate'(117).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'HWBAS'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Basic Amount(LC) '(118).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'CGST_P'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'CGST%'(119).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'CGST'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'CGST'(120).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SGST_P'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'SGST%'(121).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SGST'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'SGST'(122).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'IGST_P'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'IGST%'(123).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'IGST'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'IGST'(124).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TOT'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Total Amt.'(125).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'SAKNR'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Ledger Code'(126).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  CLEAR LS_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TXT20'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Sales Ledger Head'(127).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TCS_RATE'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'TCS Rate'(128).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'TCS_AMT'.
*  ls_fieldcat-outputlen = '10'.
  LS_FIELDCAT-TABNAME   = 'GT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'TCS Amount'(129).
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  UCOMM_ON_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM UCOMM_ON_ALV USING R_UCOMM LIKE SY-UCOMM
                    RS_SELFIELD TYPE SLIS_SELFIELD.
  DATA:
    LS_FINAL TYPE T_FINAL,
    LV_BURKS TYPE BSEG-BUKRS VALUE '1000'.

  CASE R_UCOMM.
    WHEN '&IC1'. "for double click
      IF RS_SELFIELD-FIELDNAME = 'BELNR'.
        READ TABLE GT_FINAL INTO LS_FINAL INDEX RS_SELFIELD-TABINDEX.
        SET PARAMETER ID 'BLN' FIELD RS_SELFIELD-VALUE.
        SET PARAMETER ID 'BUK' FIELD LV_BURKS.
        SET PARAMETER ID 'GJR' FIELD LS_FINAL-GJAHR.
        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDIF.
  ENDCASE.
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

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).
*BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_FINAL "gt_final         " Abhishek Pisolkar (26.03.2018)
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
  LV_FILE = 'ZSALES_FI.TXT'.

  CONCATENATE P_FOLDER '/'  LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSALES_FI Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1609 TYPE STRING.
    DATA LV_CRLF_1609 TYPE STRING.
    LV_CRLF_1609 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1609 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1609 LV_CRLF_1609 WA_CSV INTO LV_STRING_1609.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_1609 TO LV_FULLFILE.
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
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
*  CONCATENATE 'Accounting Doc.No.'
*              'Fiscal Year'
*              'Doc.Date'
*              'FI Doc.Type'
*              'Invoice No.'
*              'Original Doc.No.'
*              'Customer Code'
*              'Name'
*              'REGD/URD/SEZ/DEEMED/GOV'
*              'Customer GSTIN'
*              'Customer State Code'
*              'Customer State Name'
*              'Description'
*              'HSN/SAC'
*              'Tax Code'
*              'Tax Code Description'
*              'Basic Amount(DC)'
*              'Currency'
*              'Exchange Rate'
*              'Basic Amount(LC)'
*              'CGST%'
*              'CGST'
*              'SGST%'
*              'SGST'
*              'IGST%'
*              'IGST'
*              'Total Amt.'
*              'Sales Ledger Code'
*              'Sales Ledger Head'
*              'Customer Address'
*              'Refreshable Date'               " Abhishek Pisolkar
*              INTO pd_csv
*  SEPARATED BY l_field_seperator.

  CONCATENATE 'Accounting Doc.No.'
              'Doc.Date'
              'FI Doc.Type'
              'Original Doc.No.'
              'Invoice No.'
              'Customer Code'
              'Name'
              'REGD/URD/SEZ/DEEMED/GOV'
              'Customer GSTIN'
              'Customer State Code'
              'Customer State Name'
              'Description'
              'HSN/SAC'
              'Tax Code'
              'Tax Code Description'
              'Basic Amount(DC)'
              'Currency'
              'Exchange Rate'
              'Basic Amount(LC)'
              'CGST%'
              'CGST'
              'SGST%'
              'SGST'
              'IGST%'
              'IGST'
              'Total Amt.'
              'Sales Ledger Code'
              'Sales Ledger Head'
              'Customer Address'               " Abhishek Pisolkar
              'Fiscal Year'                    " Abhishek Pisolkar
              'Refreshable Date'               " Abhishek Pisolkar
              'TCS Rate'
              'TCS Amount'
       INTO PD_CSV SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.

INCLUDE ZFI_SALES_REGISTER_FIELDNAMF01.
*&---------------------------------------------------------------------*
*&      Form  FIELDNAMES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM fieldnames .
*
*  wa_fieldname-field_name = 'Accounting Doc.No.'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Doc.Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'FI Doc.Type'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Original Doc No.'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Invoice No.'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Name'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'REGD/URD/SEZ/DEEMED/GOV'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer GSTIN'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer State Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Customer State Name'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Description'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'HSN/SAC'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Tax Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Tax Code Description'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Basic Amount(DC)'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Currency'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Exchange Rate'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Basic Amount(LC) '.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'CGST%'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'CGST'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'SGST%'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'SGST'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'IGST%'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'IGST'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Total Amt.'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Sales Ledger Code'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Sales Ledger Head'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Address'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Fiscal Year'.
*  APPEND wa_fieldname TO it_fieldname.
*
*  wa_fieldname-field_name = 'Refreshable Date'.
*  APPEND wa_fieldname TO it_fieldname.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM download_log .
*  DATA : v_fullpath      TYPE string.
*
*  CALL FUNCTION 'GUI_FILE_SAVE_DIALOG'
*    EXPORTING
*      window_title      = 'STATUS RECORD FILE'
*      default_extension = '.xls'
*    IMPORTING
**     filename          = v_efile
*      fullpath          = v_fullpath.
*
*
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
*      filename                = v_fullpath
*      filetype                = 'ASC'
*      write_field_separator   = 'X'
*    TABLES
*      data_tab                = it_final
*      fieldnames              = it_fieldname
*    EXCEPTIONS
*      file_write_error        = 1
*      no_batch                = 2
*      gui_refuse_filetransfer = 3
*      invalid_type            = 4
*      no_authority            = 5
*      unknown_error           = 6
*      header_not_allowed      = 7
*      separator_not_allowed   = 8
*      filesize_not_allowed    = 9
*      header_too_long         = 10
*      dp_error_create         = 11
*      dp_error_send           = 12
*      dp_error_write          = 13
*      unknown_dp_error        = 14
*      access_denied           = 15
*      dp_out_of_memory        = 16
*      disk_full               = 17
*      dp_timeout              = 18
*      file_not_found          = 19
*      dataprovider_exception  = 20
*      control_flush_error     = 21
*      OTHERS                  = 22.
*
*  IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ELSE.
*    MESSAGE 'Please check Status File' TYPE 'S'.
*  ENDIF.
*
*
*
*ENDFORM.
*ENDFORM.
