*&---------------------------------------------------------------------*
*& Report YMM_MAT_MAST_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_UPLOAD_MAT_MAST NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPE-POOLS: SLIS.

*Data Declaration
*&--- Type for file upload
TYPES : BEGIN OF T_FILE ,
          MBRSH          TYPE MBRSH,        "1 Industry sector
          MATNR          TYPE MATNR,        "2 Material code
          MTART          TYPE MTART,        "3 Material Type
          WERKS          TYPE T001W-WERKS,  "4 Plant   "ZBRNDEF-WERKS,
          LGORT          TYPE T001L-LGORT,  "5 Storage Locations    "zmatdef-lgort,
*          lgor2       TYPE t001l-lgort,  "6 Storage Locations    "zmatdef-lgort,
*          lgor3       TYPE t001l-lgort,  "6 Storage Locations    "zmatdef-lgort,
*          lgor4       TYPE t001l-lgort,  "6 Storage Locations    "zmatdef-lgort,
*          lgor5       TYPE t001l-lgort,  "6 Storage Locations    "zmatdef-lgort,
          VKORG          TYPE VBRK-VKORG,   "6 Sales Organization
          VTWEG          TYPE VBRK-VTWEG,   "7 Distribution Channel "zmatdef-vtweg,
          MAKTX          TYPE MAKT-MAKTX,   "8 Material Description (Short Text)
          MEINS          TYPE MARA-MEINS,   "9 Base Unit of Measure
          BISMT          TYPE BISMT,        "10 Old material number
          MEINH          TYPE MEINH,        "11 Unit of Measure for Display
*          lrmei       TYPE lrmei,        "12 Alternative Unit of Measure for Stockkeeping Unit
          UMREN          TYPE UMREN,        "12 Denominator for conversion to base units of measure
          UMREZ          TYPE UMREZ,        "13 Numerator for Conversion to Base Units of Measure
          BRAND          TYPE ZBRAND,       "14 IS-H: General Field with Length 2, for Function Modules
          ZSERIES        TYPE CHAR03,       "15 Three-digit character field for IDocs
          ZMSIZE         TYPE CHAR03,       "16 Three-digit character field for IDocs
          MOC            TYPE CHAR03,       "17 Three-digit character field for IDocs
          TYPE           TYPE CHAR03,       "18 Three-digit character field for IDocs
          EXTWG          TYPE EXTWG,        "19 External Material Group
          MATKL          TYPE MATKL,        "20 Material Group
          SPART          TYPE SPART,        "21 Division
          BRGEW          TYPE BRGEW,        "22 Gross Weight
          NTGEW          TYPE NTGEW,        "23 Net Weight
          TAXM1          TYPE MG03STEUER-TAXKM,    "24 Tax indicator for material zmatdef-taxkm_01,
          TAXM2          TYPE MG03STEUER-TAXKM,    "25 zmatdef-taxkm_02,
          TAXM3          TYPE MG03STEUER-TAXKM,    "26 zmatdef-taxkm_03,
          TAXM4          TYPE MG03STEUER-TAXKM,    "27 zmatdef-taxkm_04,
          DWERK          TYPE DWERK,        "28 Delivering Plant
          VERSG          TYPE VERSG,        "29 mat stat group
          KTGRM          TYPE KTGRM,        "30 Account assignment group for this material    "zmatdef-ktgrm,
          MTPOS_MARA     TYPE MTPOS_MARA,   "31 General item category group
          MTPOS          TYPE MTPOS,        "32 Item category group from material master
          MTVFP          TYPE MTVFP,        "33 Checking Group for Availability Check
          TRAGR          TYPE TRAGR,        "34 Transportation Group
          LADGR          TYPE LADGR,        "35 Loading Group
          MAGRV          TYPE MAGRV,        "36 Material Group: Packaging Materials
          PRCTR          TYPE PRCTR,        "37 Profit Center    "zbrndef-prctr,
          SERNP          TYPE SERAIL,       "38 Serial Number Profile    "zmatdef-sernp,
          BSTME          TYPE BSTME,        "39 Purchase Order Unit of Measure
          EKGRP          TYPE EKGRP,        "40 Purchasing Group  "zbrndef-ekgrp,
          DISMM          TYPE DISMM,        "41 MRP Type          "zmatdef-dismm,
          DISPO          TYPE DISPO,        "42 MRP Controller (Materials Planner)      "zbrndef-dispo,
          BSTMI          TYPE BSTMI,        "43 minimum order qty
          DISLS          TYPE DISLS,        "44 Lot size (materials planning)
          BESKZ          TYPE BESKZ,        "45 Procurement Type      "zmatdef-beskz,   "prcr type
          SOBSL          TYPE SOBSL,        "46 Special procurement type
          WZEIT          TYPE WZEIT,        "47 Total replenishment lead time (in workdays)
          PLIFZ          TYPE PLIFZ,        "48 Planned Delivery Time in Days
*          lgpro       TYPE marc-lgpro,   "Issue Storage Location                              " Commented By Abhishek Pisolkar (3.3.2018)
          FHORI          TYPE FHORI,        "49 Scheduling Margin Key for Floats
          STRGR          TYPE STRGR,        "50 Planning strategy group    zmatdef-strgr,
          VRMOD          TYPE VRMOD,        "51 Consumption mode
          VINT1          TYPE VINT1,        "52 Consumption period: backward    "zmatdef-vint1,
          VINT2          TYPE VINT2,        "53 Consumption period: backward    "zmatdef-vint2,
          SBDKZ          TYPE SBDKZ,        "54 Dependent requirements ind. for individual and coll. reqmts
          FEVOR          TYPE FEVOR,        "55 Production scheduler "zmatdef-fevor,
          SFCPF          TYPE CO_PRODPRF,   "56 Production Scheduling Profile    "zmatdef-sfcpf,
          DZEIT          TYPE DZEIT,        "57 In-house production time  zmatdef-dzeit,  " in house prd time
          AUSME          TYPE AUSME,        "58 Unit of issue
          BKLAS          TYPE BKLAS,        "59 Valuation Class  zmatdef-bklas,
          VPRSV          TYPE VPRSV,        "60 Price Control Indicatorzmatdef-vprsv,
          VERPR          TYPE VERPR,        "61 Moving Average Price/Periodic Unit Price   zmatdef-verpr,
          STPRS          TYPE STPRS,        "62 Standard price
*          peinh       TYPE peinh,        "64 Price unit
          EKALR          TYPE CK_EKALREL,   "63 Material Is Costed with Quantity Structure
          LOSGR          TYPE LOSGR,        "64 Planned lot size
          CLASS          TYPE KLASSE_D,     "65 Class number    "zbrndef-class,
          VALUE_CHAR1    TYPE ATWRT,        "66 Characteristic Value
          VALUE_CHAR2    TYPE ATWRT,        "67 Characteristic Value
          VALUE_CHAR3    TYPE ATWRT,        "68 Characteristic Value
          VALUE_CHAR4    TYPE ATWRT,        "69 Characteristic Value
          VALUE_CHAR5    TYPE ATWRT,        "70 Characteristic Value
          VALUE_CHAR6    TYPE ATWRT,        "71 Characteristic Value
          VALUE_CHAR7    TYPE ATWRT,        "72 Characteristic Value
          VALUE_CHAR8    TYPE ATWRT,        "73 Characteristic Value
          VALUE_CHAR9    TYPE ATWRT,        "74 Characteristic Value
          LGPBE          TYPE LGPBE,        "75 Storage Bin
          RAUBE          TYPE MARA-RAUBE,   "76 Storage Conditions
          J_1ICHID       TYPE J_1ICHID,     "77 Chapter ID
*          steuc       TYPE marc-steuc,    "HSN Code
          J_1IGRXREF     TYPE J_1IGRXREF-MBLNR, "78 No of GR per EI
          J_1ISUBIND     TYPE J_1IMTCHID-J_1ISUBIND,  "79Material Can Be Sent to Subcontractors
          J_1ICAPIND     TYPE J_1ICAPIND,   "80 Material Type
          J_1IMOOM       TYPE J_1IMOOM,     "81 Output material for Modvat
          J_1IASSVAL     TYPE J_1IASSVAL-J_1IVALASS,  "82 Assessable Value
          TEXT_LINE(300) TYPE C,      "83 Long text
          QMPUR          TYPE QMPUR,        "84 QM in Procurement is Active
          SSQSS          TYPE SSQSS,        "85 QA Control Key
          ART            TYPE RMQAM-ART,    "86 Inspection Type
          AKTIV          TYPE RMQAM-AKTIV,  "87 QA Control Key
          PSTAT          TYPE PSTAT_D,      "88 Maintenance status
          MIXED_MRP      TYPE BAPI_MARC-MIXED_MRP,  "89 Mixed MRP indicator
          DOCUMENT       TYPE BAPI_MARA-DOCUMENT,    "90Document
          DOC_VERS       TYPE BAPI_MARA-DOC_VERS,    "91Document version
          NO_COSTING     TYPE BAPI_MARC-NO_COSTING, "92
          MSS            TYPE MARA-ZZMSS,  "93
          EDS            TYPE MARA-ZZEDS,  "94
          CAP            TYPE MARA-CAP_LEAD, "95
          PRICE3         TYPE DZPLP3_BAPI,  "96planned price 3                                  added by ajay
          PLNDPRDATE3    TYPE DZPLD2,        "97 PLANNED PRICE DATE
          ITEM_TYPE      TYPE MARA-ITEM_TYPE, "Item type
*          j_1isubind  TYPE j_1imtchid-j_1isubind,   "86 Material Can Be Sent to Subcontractors
        END OF T_FILE .

TYPES: BEGIN OF T_ALSMEX.
    INCLUDE STRUCTURE ALSMEX_TABLINE.
TYPES: END OF T_ALSMEX.

DATA : V_BOOL  TYPE C,
       V_PSTAT TYPE PSTAT_D.

*&--- Erro Log table
DATA : BEGIN OF I_ERROR OCCURS 0 ,
         MATNR     TYPE MATNR,
         L_MSTRING TYPE STRING,
       END OF I_ERROR .

DATA : BEGIN OF I_SUC OCCURS 0 ,
         MATNR     TYPE MATNR,
         L_MSTRING TYPE STRING,
       END OF I_SUC .


DATA : I_BILDTAB             LIKE MBILDTAB OCCURS 0 WITH HEADER LINE,
       I_BILDTAB_MARC        LIKE MBILDTAB OCCURS 0 WITH HEADER LINE,
       I_EXCEL               LIKE ALSMEX_TABLINE OCCURS 0 WITH HEADER LINE,
       WA_EXCEL              TYPE T_ALSMEX,
       W_MATERIALDESCRIPTION TYPE BAPI_MAKT,
       W_UOM                 TYPE BAPI_MARM,
       W_UOMX                TYPE BAPI_MARMX,
       T_MATERIALDESCRIPTION TYPE STANDARD TABLE OF BAPI_MAKT,
       T_UOM                 TYPE STANDARD TABLE OF BAPI_MARM,
       T_LONGTEXT            TYPE STANDARD TABLE OF BAPI_MLTX,
       T_UOMX                TYPE STANDARD TABLE OF BAPI_MARMX,
       T_TAX                 TYPE STANDARD TABLE OF BAPI_MLAN,
       W_TAX                 TYPE BAPI_MLAN,
       W_LONGTEXT            TYPE BAPI_MLTX,
       GT_FLDCAT             TYPE STANDARD TABLE OF SLIS_FIELDCAT_ALV,
       GWA_FLDCAT            TYPE SLIS_FIELDCAT_ALV,
       IT_RETURN             TYPE STANDARD TABLE OF BAPI_MATRETURN2,
       T_EXTENSION_IN        TYPE TABLE OF  BAPIPAREX,
       W_EXTENSION_IN        TYPE BAPIPAREX,
       T_EXTENSIONX_IN       TYPE STANDARD TABLE OF BAPIPAREXX,
       W_EXTENSIONX_IN       TYPE BAPIPAREXX,
       LS_CI_DATA            TYPE REBD_BUSINESS_ENTITY_CI,


*&-- internal table for file upload
       I_FILE                TYPE TABLE OF T_FILE,
       WA_FILE               TYPE T_FILE,
       VV_FILE               TYPE IBIPPARMS-PATH,
       V_STR                 TYPE STRING,
       V_INITIAL             TYPE I,
       V_TOTAL               TYPE I,
       C_ERROR(5)            TYPE C,
       C_TOTAL(5)            TYPE C,
       V_CHAR30(30)          TYPE C,
       V_ERROR               TYPE I,
       F                     TYPE I,
       C_F(20)               TYPE C,
       W_MWST(4)             TYPE C,
       W_LAND1               TYPE T001-LAND1,
       W_BUKRS               TYPE BUKRS.

*
*types: BEGIN OF ty_lines,
*
*       t2(132),
*      END OF ty_lines.


DATA:
  LV_ID    TYPE THEAD-TDNAME,
  LT_LINES TYPE STANDARD TABLE OF TLINE,
  LS_LINES TYPE TLINE.

***************************************************************
*        BAPI DATA
***************************************************************
DATA : WA_HEADDATA         TYPE BAPIMATHEAD,
       WA_CLIENTDATA       TYPE BAPI_MARA,

       WA_CLIENTDATAX      TYPE BAPI_MARAX,
       WA_PLANTDATA        TYPE BAPI_MARC,
       WA_PLANTDATAX       TYPE BAPI_MARCX,
       WA_VALUATIONDATA    TYPE BAPI_MBEW,
       WA_VALUATIONDATAX   TYPE BAPI_MBEWX,
       WA_SLOCDATA         TYPE BAPI_MARD,
       WA_SLOCDATAX        TYPE BAPI_MARDX,
       WA_STORAGEDATA      TYPE BAPI_MLGT,
       WA_STORAGEDATAX     TYPE BAPI_MLGTX,
       WA_SALESVIEW        TYPE BAPI_MVKE,
       WA_SALESVIEWX       TYPE BAPI_MVKEX,
       TAXCLASSIFICATIONS1 LIKE  BAPI_MLAN,
       WA_RETURN           TYPE BAPIRET2.

FIELD-SYMBOLS: <F_DATA> TYPE  ANY.              "For File data

*>>
SELECTION-SCREEN BEGIN OF BLOCK BLK6 WITH FRAME TITLE TEXT-T06 .
PARAMETERS : P_FILE LIKE RLGRAP-FILENAME .
PARAMETERS : P_UPDT AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK BLK6 .

*>>
INITIALIZATION.
  GET RUN TIME FIELD F .
  IMPORT V_INITIAL  FROM MEMORY ID 'ABC'.
  IF V_INITIAL = 1 .
    V_INITIAL = 2 .
    EXPORT  V_INITIAL TO MEMORY ID 'ABC' .
  ELSE.
    CLEAR : V_INITIAL .
  ENDIF.

  CLEAR : WA_FILE .
  CLEAR : WA_HEADDATA ,
          WA_PLANTDATA ,
          WA_CLIENTDATA ,
          WA_CLIENTDATAX ,
          WA_PLANTDATA ,
          WA_PLANTDATAX ,
          WA_VALUATIONDATA ,
          WA_VALUATIONDATAX ,
          WA_SLOCDATA,
          WA_SLOCDATAX,
          WA_STORAGEDATA,
          WA_STORAGEDATAX,
          WA_SALESVIEW,
          WA_SALESVIEWX,
          WA_RETURN,
          V_PSTAT .
  REFRESH: I_FILE, IT_RETURN.

*>>
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE .
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      FILE_NAME = VV_FILE.
  P_FILE = VV_FILE .

*>>
START-OF-SELECTION.
  PERFORM GET_DATA_FORE .
  PERFORM BAPI_DATA .

*&--- Summarize the upload.
  C_TOTAL = V_TOTAL .
  APPEND I_ERROR .
  CONCATENATE 'No. of records read from file: ' C_TOTAL
    INTO I_ERROR-L_MSTRING
    SEPARATED BY SPACE .
  APPEND I_ERROR .
  CLEAR I_ERROR .
  APPEND I_ERROR .

  C_ERROR = V_ERROR .
  APPEND I_ERROR .
  CONCATENATE 'Number of error records : ' C_ERROR
               INTO I_ERROR-L_MSTRING
               SEPARATED BY SPACE .
  APPEND I_ERROR .
  CLEAR I_ERROR .
  APPEND I_ERROR .
***& --- get runtime
  GET RUN TIME FIELD F .
  F = F / 1000000 .
  C_F = F .
  CONCATENATE 'Total time taken in seconds:'
               C_F
                INTO I_ERROR-L_MSTRING
                SEPARATED BY SPACE .
  APPEND I_ERROR .

  CLEAR I_ERROR .
  APPEND I_ERROR .

  CONCATENATE 'Source File:'
               P_FILE
                INTO I_ERROR-L_MSTRING
                SEPARATED BY SPACE .
  APPEND I_ERROR .

  CLEAR I_ERROR .
  APPEND I_ERROR .
*&--- Download Error Log
  PERFORM ERROR_LOG .
  PERFORM ERROR_DISPLAY.

*>>
END-OF-SELECTION .
  V_INITIAL = 1 .
  EXPORT  V_INITIAL TO MEMORY ID 'ABC' .
*&---------------------------------------------------------------------*
*&      Form  bapi_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BAPI_DATA .
*  DATA : v_costing(1) .
*&--- Loop at uploaded data
  DATA LV_MATNR TYPE MATNR.

*  DELETE i_file INDEX 1.                 " Commented By Abhishek Pisolkar (03.03.2018)

  DESCRIBE TABLE I_FILE LINES V_TOTAL .

  LOOP AT I_FILE INTO WA_FILE .

    SELECT SINGLE MATNR FROM MARA INTO LV_MATNR
      WHERE MATNR = WA_FILE-MATNR.
    IF P_UPDT = 'X'.
      SY-SUBRC = 1.
    ENDIF.

    IF SY-SUBRC = 0.

      CLEAR I_ERROR.
      MOVE WA_FILE-MATNR TO I_ERROR-MATNR.
      I_ERROR-L_MSTRING = 'Material already created'.

      APPEND I_ERROR .
      CLEAR I_ERROR.
    ELSE.
*   status check
*    PERFORM status_check.
*&--- To determine views sequence and select the required
*      IF WA_FILE-PSTAT CS 'A'. " Work scheduling
*        WA_HEADDATA-WORK_SCHED_VIEW = 'X'.
*      ENDIF.
*      IF WA_FILE-PSTAT CS 'B'. "Accounting
**        WHEN 'Accounting' .
*        PERFORM FILL_ACCOUNTING_DATA .
*
*      ENDIF.
*      IF WA_FILE-PSTAT CS 'C'. "Classification
**PERFORM fill_classification.
*      ENDIF.
*      IF WA_FILE-PSTAT CS 'D'. "MRP
**        WHEN 'MRP 1'.
*        PERFORM FILL_MRP1_DATA .
**        WHEN 'MRP 2'.
*        PERFORM FILL_MRP2_DATA .
*
*      ENDIF.
*      IF WA_FILE-PSTAT CS 'E'. "Purchasing
*        WA_HEADDATA-PURCHASE_VIEW = 'X'.
*      ENDIF.
*      IF WA_FILE-PSTAT CS 'F'. " Prod resources/tools
*        WA_HEADDATA-PRT_VIEW = 'X'.
*      ENDIF.
*      IF WA_FILE-PSTAT CS 'G'. " Costing
**        WHEN 'Costing' .
*        PERFORM FILL_COSTING_DATA .
*
*      ENDIF.
*        when Basic data
      IF WA_FILE-PSTAT CS 'K'. "Basic data
*&--- Perform to fill basic data
        PERFORM FILL_BASIC_DATA .

      ENDIF.
*       when storage
*      IF WA_FILE-PSTAT CS 'L'. "Storage
*        PERFORM FILL_STORAGE_DATA.
*
*      ENDIF.
*       when forcasting
*      IF WA_FILE-PSTAT CS 'P'.
*        WA_HEADDATA-FORECAST_VIEW = 'X'.
*      ENDIF.
*        when Quality Mgmnt
*      IF WA_FILE-PSTAT CS 'Q'.
*        WA_HEADDATA-QUALITY_VIEW = 'X'.
*      ENDIF.
*        when Warehouse mgmnt
*      IF WA_FILE-PSTAT CS 'S'.
*        WA_HEADDATA-WAREHOUSE_VIEW = 'X'.
*      ENDIF.
**        when Sales
*      IF WA_FILE-PSTAT CS 'V'.
*        WA_HEADDATA-SALES_VIEW = 'X'.
*        PERFORM SALES_DATA.
*      ENDIF.

*      PERFORM taxes.
*      taxclassifications1



*&---- Call BAPI_MATERIAL_SAVEDATA
      IF WA_FILE-PSTAT IS INITIAL.
        MOVE WA_FILE-MATNR TO I_ERROR-MATNR.
        MOVE  'Please maintain at least basic view'  TO I_ERROR-L_MSTRING.
        APPEND I_ERROR .
        CLEAR : I_ERROR .
        ADD 1 TO V_ERROR.
      ELSE.
        PERFORM BAPI_MATERIAL .
      ENDIF.
      CLEAR : WA_FILE .
      CLEAR : WA_HEADDATA ,
              WA_PLANTDATA ,
              WA_CLIENTDATA ,
              WA_CLIENTDATAX ,
              WA_PLANTDATA ,
              WA_PLANTDATAX ,
              WA_VALUATIONDATA ,
              WA_VALUATIONDATAX ,
              WA_SLOCDATA,
              WA_SLOCDATAX,
              WA_STORAGEDATA,
              WA_STORAGEDATAX,
              WA_SALESVIEW,
              WA_SALESVIEWX,
              WA_RETURN ,
              W_UOM,
              W_UOMX.
    ENDIF.
  ENDLOOP .

ENDFORM.                    " bdc_data

*&---------------------------------------------------------------------*
*&      Form  get_data_fore
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA_FORE .

*Read the upload file
  V_STR = P_FILE .
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_EXIST
    EXPORTING
      FILE   = V_STR
    RECEIVING
      RESULT = V_BOOL.
  TYPES TRUXS_T_TEXT_DATA(4096) TYPE C OCCURS 0.

  DATA : RAWDATA TYPE TRUXS_T_TEXT_DATA.
  IF V_BOOL IS NOT INITIAL .
*    v_file_up = p_file .
*    BREAK primus.
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
        I_LINE_HEADER        = 'X'
        I_TAB_RAW_DATA       = RAWDATA
        I_FILENAME           = P_FILE
      TABLES
        I_TAB_CONVERTED_DATA = I_FILE
* EXCEPTIONS
*       CONVERSION_FAILED    = 1
*       OTHERS               = 2
      .
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.

ENDFORM.                    " get_data_fore
*&---------------------------------------------------------------------*
*&      Form  fill_basic_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILL_BASIC_DATA .
  CLEAR: W_MATERIALDESCRIPTION.
  REFRESH: T_MATERIALDESCRIPTION.
*&--- Fill Header data
  WA_HEADDATA-MATERIAL = WA_FILE-MATNR .
  WA_HEADDATA-MATL_TYPE = WA_FILE-MTART.
  WA_HEADDATA-IND_SECTOR = WA_FILE-MBRSH. "'C'.
  WA_HEADDATA-BASIC_VIEW = 'X'.

*&--- Client data
  WA_CLIENTDATA-BASE_UOM = WA_FILE-MEINS .
  WA_CLIENTDATAX-BASE_UOM = 'X' .
  WA_CLIENTDATA-EXTMATLGRP = WA_FILE-EXTWG .
  WA_CLIENTDATAX-EXTMATLGRP = 'X' .

  WA_CLIENTDATA-MATL_GROUP = WA_FILE-MATKL.
  WA_CLIENTDATAX-MATL_GROUP = 'X'.
  WA_CLIENTDATA-OLD_MAT_NO = WA_FILE-BISMT.
  WA_CLIENTDATAX-OLD_MAT_NO = 'X'.
*  wa_clientdata-PO_UNIT = wa_file-BSTME.
*  wa_clientdatax-PO_UNIT = 'X'.
  WA_CLIENTDATA-QM_PROCMNT = WA_FILE-QMPUR.
  WA_CLIENTDATAX-QM_PROCMNT = 'X'.
*  wa_clientdata-division= wa_file-spart.
*  wa_clientdatax-division = 'X'.
  WA_CLIENTDATA-NET_WEIGHT = WA_FILE-NTGEW.
  WA_CLIENTDATAX-NET_WEIGHT = 'X'.
  WA_CLIENTDATA-DOCUMENT  = WA_FILE-DOCUMENT.
  WA_CLIENTDATAX-DOCUMENT = 'X'.
  WA_CLIENTDATA-DOC_VERS  = WA_FILE-DOC_VERS.
  WA_CLIENTDATAX-DOC_VERS = 'X'.
  WA_CLIENTDATA-STOR_CONDS = WA_FILE-RAUBE.
  WA_CLIENTDATAX-STOR_CONDS = 'X'.


*&--- Plant data
  WA_PLANTDATA-PLANT    = WA_FILE-WERKS .
  WA_PLANTDATAX-PLANT   = WA_FILE-WERKS .
  WA_PLANTDATA-PROC_TYPE    = WA_FILE-BESKZ.
  WA_PLANTDATAX-PROC_TYPE   = 'X'.

  WA_PLANTDATA-SM_KEY    = WA_FILE-FHORI.
  WA_PLANTDATAX-SM_KEY   = 'X'.
  WA_PLANTDATA-CTRL_KEY    = WA_FILE-SSQSS.
  WA_PLANTDATAX-CTRL_KEY   = 'X'.
  WA_PLANTDATA-PROFIT_CTR    = WA_FILE-PRCTR.
  WA_PLANTDATAX-PROFIT_CTR   = 'X'.
  WA_PLANTDATA-LOT_SIZE    = WA_FILE-LOSGR.
  WA_PLANTDATAX-LOT_SIZE   = 'X'.
  WA_PLANTDATA-CTRL_CODE  = WA_FILE-J_1ICHID.
  WA_PLANTDATAX-CTRL_CODE  = 'X'.
  WA_PLANTDATA-ISS_ST_LOC  = WA_FILE-LGORT.       "wa_file-lgpro.      "Issue Storage Location  Commented By Abhishek Pisolkar (3.3.2018)
  WA_PLANTDATAX-ISS_ST_LOC  = 'X'.
  WA_PLANTDATA-NO_COSTING  = WA_FILE-NO_COSTING.
  WA_PLANTDATAX-NO_COSTING  = 'X'.

*&--- Storage location  data
  WA_SLOCDATA-PLANT = WA_FILE-WERKS.
  WA_SLOCDATA-STGE_LOC = WA_FILE-LGORT.
  WA_SLOCDATAX-PLANT = WA_FILE-WERKS.
  WA_SLOCDATAX-STGE_LOC = WA_FILE-LGORT.


  W_MATERIALDESCRIPTION-LANGU = SY-LANGU.
  W_MATERIALDESCRIPTION-MATL_DESC = WA_FILE-MAKTX.
  APPEND W_MATERIALDESCRIPTION TO T_MATERIALDESCRIPTION.

  IF WA_FILE-MEINH IS NOT INITIAL.

    W_UOM-DENOMINATR = WA_FILE-UMREN.
    W_UOM-NUMERATOR = WA_FILE-UMREZ.
    W_UOM-ALT_UNIT = WA_FILE-MEINH.
    IF WA_FILE-MEINH = 'KG'.
      W_UOM-ALT_UNIT_ISO = '3H' ."wa_file-lrmei.
    ENDIF.
    IF WA_FILE-MEINH = 'EA'.
      W_UOM-ALT_UNIT_ISO = 'EA' ."wa_file-lrmei.
    ENDIF.

    APPEND W_UOM TO T_UOM.
  ENDIF.

  W_UOMX-DENOMINATR = 'X'.
  W_UOMX-NUMERATOR = 'X'.
  W_UOMX-ALT_UNIT = WA_FILE-MEINH ."'X'.
  W_UOMX-ALT_UNIT_ISO = '3H' ."wa_file-lrmei ."'X'.
  APPEND W_UOMX TO T_UOMX.
  TRANSLATE WA_FILE-MATNR TO UPPER CASE .
  LV_ID = WA_FILE-MATNR.
  CLEAR: LT_LINES,LS_LINES.

  TYPES: BEGIN OF TY_LINES,
           T2(300),
           T3(300),

         END OF TY_LINES.
  DATA : IT_LINES TYPE TABLE OF TY_LINES,
         WA_LINES TYPE           TY_LINES.
*  DATA T1 TYPE XSTRING.



  CALL FUNCTION 'RKD_WORD_WRAP'
    EXPORTING
      TEXTLINE            = WA_FILE-TEXT_LINE
      DELIMITER           = SPACE
      OUTPUTLEN           = 132
* IMPORTING
*     OUT_LINE1           =
*     OUT_LINE2           =
**     OUT_LINE3           =
    TABLES
      OUT_LINES           = IT_LINES
    EXCEPTIONS
      OUTPUTLEN_TOO_LARGE = 1
      OTHERS              = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  W_LONGTEXT-TEXT_NAME =  WA_FILE-MATNR .
  W_LONGTEXT-TEXT_ID = 'GRUN'.
  W_LONGTEXT-LANGU_ISO = 'EN'.
  W_LONGTEXT-APPLOBJECT = 'MATERIAL'.
  LOOP AT IT_LINES INTO WA_LINES.
    W_LONGTEXT-TEXT_LINE =  WA_LINES-T2.
    APPEND W_LONGTEXT TO T_LONGTEXT.

  ENDLOOP.




* fill values for user fields , BAPI extension

  W_EXTENSION_IN-STRUCTURE = 'BAPI_TE_MARA'.
  CONCATENATE WA_FILE-MATNR WA_FILE-ZSERIES WA_FILE-ZMSIZE
              WA_FILE-BRAND WA_FILE-MOC WA_FILE-TYPE WA_FILE-ITEM_TYPE
    INTO W_EXTENSION_IN-VALUEPART1.
  APPEND W_EXTENSION_IN  TO T_EXTENSION_IN.

  W_EXTENSIONX_IN-STRUCTURE = 'BAPI_TE_MARAX'.
  CONCATENATE WA_FILE-MATNR  'X' 'X' 'X' 'X' 'X'
  INTO W_EXTENSIONX_IN-VALUEPART1.

  APPEND W_EXTENSIONX_IN  TO T_EXTENSIONX_IN.

ENDFORM.                    " fill_basic_data

*&---------------------------------------------------------------------*
*&      Form  bapi_material
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BAPI_MATERIAL .

  CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
    EXPORTING
      HEADDATA             = WA_HEADDATA
      CLIENTDATA           = WA_CLIENTDATA
      CLIENTDATAX          = WA_CLIENTDATAX
      PLANTDATA            = WA_PLANTDATA
      PLANTDATAX           = WA_PLANTDATAX
*     FORECASTPARAMETERS   =
*     FORECASTPARAMETERSX  =
*     PLANNINGDATA         =
*     PLANNINGDATAX        =
      STORAGELOCATIONDATA  = WA_SLOCDATA
      STORAGELOCATIONDATAX = WA_SLOCDATAX
      VALUATIONDATA        = WA_VALUATIONDATA
      VALUATIONDATAX       = WA_VALUATIONDATAX
*     WAREHOUSENUMBERDATA  =
*     WAREHOUSENUMBERDATAX =
*     SALESDATA            = WA_SALESVIEW
*     SALESDATAX           = WA_SALESVIEWX
*     STORAGETYPEDATA      = wa_storagedata
*     STORAGETYPEDATAX     = wa_storagedatax
*     FLAG_ONLINE          = ' '
*     FLAG_CAD_CALL        = ' '
*     NO_DEQUEUE           = ' '
    IMPORTING
      RETURN               = WA_RETURN
    TABLES
      MATERIALDESCRIPTION  = T_MATERIALDESCRIPTION
      UNITSOFMEASURE       = T_UOM
      UNITSOFMEASUREX      = T_UOMX
*.*   INTERNATIONALARTNOS         =
      MATERIALLONGTEXT     = T_LONGTEXT
      TAXCLASSIFICATIONS   = T_TAX
      RETURNMESSAGES       = IT_RETURN
*     PRTDATA              =
*     PRTDATAX             =
      EXTENSIONIN          = T_EXTENSION_IN
      EXTENSIONINX         = T_EXTENSIONX_IN
*     NFMCHARGEWEIGHTS     =
*     NFMCHARGEWEIGHTSX    =
*     NFMSTRUCTURALWEIGHTS =
*     NFMSTRUCTURALWEIGHTSX       =
    .

  IF WA_RETURN-TYPE = 'E'.
    MOVE WA_FILE-MATNR TO I_ERROR-MATNR.
    MOVE  WA_RETURN-MESSAGE  TO I_ERROR-L_MSTRING.
    APPEND I_ERROR .
    CLEAR : I_ERROR .
    ADD 1 TO V_ERROR.
  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    UPDATE MARA SET ZSERIES = WA_FILE-ZSERIES
                    ZSIZE   = WA_FILE-ZMSIZE
                    BRAND   = WA_FILE-BRAND
                    MOC     = WA_FILE-MOC
                    TYPE    = WA_FILE-TYPE
                    ZZMSS   = WA_FILE-MSS
                    ZZEDS   = WA_FILE-EDS
                    CAP_LEAD = WA_FILE-CAP
                    ITEM_TYPE = WA_FILE-ITEM_TYPE
    WHERE MATNR = WA_FILE-MATNR .
    WAIT UP TO  1 SECONDS.
    EXPORT WA_FILE-MATNR WA_FILE-TEXT_LINE TO MEMORY ID 'zmat' .
    MOVE WA_FILE-MATNR TO I_ERROR-MATNR.
    MOVE WA_RETURN-MESSAGE TO I_ERROR-L_MSTRING.
    APPEND I_ERROR .
  ENDIF.

  REFRESH T_LONGTEXT.
ENDFORM.                    " bapi_material
*&---------------------------------------------------------------------*
*&      Form  ERROR_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ERROR_LOG .

  REFRESH: GT_FLDCAT.

  GWA_FLDCAT-FIELDNAME  = 'MATNR'.
  GWA_FLDCAT-TABNAME    = 'I_ERROR'.
  GWA_FLDCAT-SELTEXT_L  = 'Material'.
  GWA_FLDCAT-SELTEXT_M  = 'Material'.
  GWA_FLDCAT-SELTEXT_S  = 'Material'.
  GWA_FLDCAT-OUTPUTLEN  = '000018'.

  APPEND GWA_FLDCAT TO GT_FLDCAT.
  CLEAR  GWA_FLDCAT.

  GWA_FLDCAT-FIELDNAME  = 'L_MSTRING'.
  GWA_FLDCAT-TABNAME    = 'I_ERROR'.
  GWA_FLDCAT-SELTEXT_L  = ' Message'.
*  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
  GWA_FLDCAT-OUTPUTLEN  = '000070'.

  APPEND GWA_FLDCAT TO GT_FLDCAT.
  CLEAR  GWA_FLDCAT.


* gwa_fldcat-fieldname  = 'L_MSTRING'.
*  gwa_fldcat-tabname    = 'I_SUC'.
*  gwa_fldcat-seltext_l  = 'Error Message'.
**  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
*  gwa_fldcat-outputlen  = '000070'.
*
*  APPEND gwa_fldcat TO gt_fldcat.
*  CLEAR  gwa_fldcat.




ENDFORM.                    " ERROR_LOG
*&---------------------------------------------------------------------*
*&      Form  ERROR_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ERROR_DISPLAY .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     is_layout   = gwa_layout_col
      IT_FIELDCAT = GT_FLDCAT
    TABLES
      T_OUTTAB    = I_ERROR.


ENDFORM.                    " ERROR_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  FILL_STORAGE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text

*&---------------------------------------------------------------------*
*&      Form  STATUS_CHECK
*&---------------------------------------------------------------------*
*   Status check
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM STATUS_CHECK .
  CLEAR: V_PSTAT.
  SELECT SINGLE
         PSTAT
         FROM MARC
         INTO V_PSTAT
         WHERE MATNR = WA_FILE-MATNR
         AND   WERKS = WA_FILE-WERKS.
  IF SY-SUBRC = 0.
*    WA_FILE-PSTAT = v_PSTAT.
  ENDIF.
ENDFORM.                    " STATUS_CHECK
*&---------------------------------------------------------------------*
*&      Form  SALES_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SALES_DATA .

  DATA: LV_COMP TYPE HRCA_COMPANY-COMP_CODE.
  CLEAR: W_MWST,W_LAND1.
  CLEAR: W_TAX.
  REFRESH : T_TAX.


  WA_CLIENTDATA-DIVISION = WA_FILE-SPART .
  WA_CLIENTDATAX-DIVISION = 'X' .
  WA_CLIENTDATA-TRANS_GRP = WA_FILE-TRAGR.
  WA_CLIENTDATAX-TRANS_GRP = 'X'.

  IF WA_FILE-MAGRV IS NOT INITIAL.
    WA_SALESVIEW-MATL_GRP_1 = WA_FILE-MAGRV.
    WA_SALESVIEWX-MATL_GRP_1 = 'X'.
  ENDIF.

*  if  wa_file-MVGR2 is not INITIAL.
*    wa_salesview-MATL_GRP_2 = wa_file-MVGR2.
*    wa_salesviewx-MATL_GRP_2 = 'X'.
*  endif.
*  if  wa_file-MVGR3 is not INITIAL.
*    wa_salesview-MATL_GRP_3 = wa_file-MVGR3.
*    wa_salesviewx-MATL_GRP_3 = 'X'.
*  endif.
*  if  wa_file-MVGR4 is not INITIAL.
*    wa_salesview-MATL_GRP_4 = wa_file-MVGR4.
*    wa_salesviewx-MATL_GRP_4 = 'X'.
*  endif.
*  if  wa_file-MVGR5 is not INITIAL.
*    wa_salesview-MATL_GRP_5 = wa_file-MVGR5.
*    wa_salesviewx-MATL_GRP_5 = 'X'.
*  endif.

  IF  WA_FILE-MTPOS_MARA IS NOT INITIAL.
    WA_CLIENTDATA-ITEM_CAT = WA_FILE-MTPOS_MARA.
    WA_CLIENTDATAX-ITEM_CAT = 'X'.
  ENDIF.
  IF  WA_FILE-LADGR IS NOT INITIAL.
    WA_PLANTDATA-LOADINGGRP    = WA_FILE-LADGR.
    WA_PLANTDATAX-LOADINGGRP   = 'X'.
  ENDIF.
  IF  WA_FILE-VKORG IS NOT INITIAL.
    WA_SALESVIEW-SALES_ORG      = WA_FILE-VKORG.
    WA_SALESVIEWX-SALES_ORG      = WA_FILE-VKORG.
  ENDIF.
  IF  WA_FILE-VTWEG IS NOT INITIAL.
    WA_SALESVIEW-DISTR_CHAN      = WA_FILE-VTWEG.
    WA_SALESVIEWX-DISTR_CHAN      = WA_FILE-VTWEG.
  ENDIF.
  IF  WA_FILE-VERSG IS NOT INITIAL.
    WA_SALESVIEW-MATL_STATS      = WA_FILE-VERSG.
    WA_SALESVIEWX-MATL_STATS      = 'X'.
  ENDIF.
*  if   wa_file-VRKME is not INITIAL.
*    wa_salesview-SALES_UNIT      = wa_file-VRKME.
*    wa_salesviewx-SALES_UNIT      = 'X'.
*  endif.

  IF  WA_FILE-MTPOS IS NOT INITIAL.
    WA_SALESVIEW-ITEM_CAT      = WA_FILE-MTPOS.
    WA_SALESVIEWX-ITEM_CAT      = 'X'.
  ENDIF.

  IF  WA_FILE-DWERK IS NOT INITIAL.
    WA_SALESVIEW-DELYG_PLNT      = WA_FILE-DWERK.
    WA_SALESVIEWX-DELYG_PLNT      = 'X'.
  ENDIF.

  IF  WA_FILE-KTGRM IS NOT INITIAL.
    WA_SALESVIEW-ACCT_ASSGT      = WA_FILE-KTGRM.
    WA_SALESVIEWX-ACCT_ASSGT      = 'X'.
  ENDIF.

* Tax Classification.
  SELECT SINGLE LAND1
        INTO  W_LAND1
        FROM T001
        WHERE BUKRS = W_BUKRS.

*  IF w_land1 <> 'US'.
*    w_mwst = 'MWST'.
*  ELSE.
*    w_mwst = 'TAXJ'.
*  ENDIF.
*  w_tax-depcountry = w_land1.
*  w_tax-tax_type_1 = 'ZLST'.    "'JTX1' ."w_mwst.
*  w_tax-tax_type_2 = 'ZCST'.    "'JTX2' .
*  w_tax-tax_type_3 = 'ZSER'.    "'JTX3' .
**  w_tax-tax_type_4 = 'ZTCS'.    "'JTX4' .
*  w_tax-taxclass_1 = wa_file-taxm1.
*  w_tax-taxclass_2 = wa_file-taxm2.
*  w_tax-taxclass_3 = wa_file-taxm3.
**  w_tax-taxclass_4 = wa_file-taxm4.

  W_TAX-DEPCOUNTRY = W_LAND1.
  W_TAX-TAX_TYPE_1 = 'JOCG'.    "'JTX1' ."w_mwst.
  W_TAX-TAX_TYPE_2 = 'JOSG'.    "'JTX2' .
  W_TAX-TAX_TYPE_3 = 'JOIG'.    "'JTX3' .
  W_TAX-TAX_TYPE_4 = 'JOUG'.    "'JTX3' .
  W_TAX-TAX_TYPE_5 = 'ZCST'.    "'JTX3' .
  W_TAX-TAX_TYPE_6 = 'ZLST'.    "'JTX3' .
  W_TAX-TAX_TYPE_7 = 'ZSER'.    "'JTX3' .
*  w_tax-tax_type_4 = 'ZTCS'.    "'JTX4' .
  W_TAX-TAXCLASS_1 = WA_FILE-TAXM1.
  W_TAX-TAXCLASS_2 = WA_FILE-TAXM2.
  W_TAX-TAXCLASS_3 = WA_FILE-TAXM3.
  W_TAX-TAXCLASS_4 = WA_FILE-TAXM4.
  W_TAX-TAXCLASS_5 = 0."wa_file-taxm4.
  W_TAX-TAXCLASS_6 = 0."wa_file-taxm4.
  W_TAX-TAXCLASS_7 = 0."wa_file-taxm4.
*  w_tax-taxclass_4 = wa_file-taxm4.



  APPEND  W_TAX TO T_TAX .
*wa_salesview-      = wa_file-TAXKM.
*wa_salesviewx-      = 'X'.
*wa_salesview-      = wa_file-.
*wa_salesviewx-      = 'X'.


ENDFORM.                    " SALES_DATA
*&---------------------------------------------------------------------*
*&      Form  FILL_CLASSIFICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM FILL_CLASSIFICATION .
* wa_headdata-cost_view = 'X'.
*ENDFORM.                    " FILL_CLASSIFICATION
*&---------------------------------------------------------------------*
*&      Form  TAXES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM taxes .
*
*  taxclassifications1-depcountry = 'IN'.
*
*    taxclassifications1-tax_type_1      =  'JOCG'.
*    taxclassifications1-taxclass_1      =  WA_FILE-taxm1.
*
*    taxclassifications1-tax_type_2      =  'JOSG'.
*    taxclassifications1-taxclass_2      =  WA_FILE-taxm2.
*
*    taxclassifications1-tax_type_3      =  'JOIG'.
*    taxclassifications1-taxclass_3      =  WA_FILE-taxm3.
*
*    taxclassifications1-tax_type_4      =  'JOUG'.
*    taxclassifications1-taxclass_4      =  WA_FILE-taxm4.
*
**    taxclassifications1-tax_ind = ls_list-taxim.
*
*
*
*ENDFORM.
