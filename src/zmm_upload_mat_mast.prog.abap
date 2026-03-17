*&---------------------------------------------------------------------*
*& Report YMM_MAT_MAST_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_upload_mat_mast NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPE-POOLS: slis.

*Data Declaration
*&--- Type for file upload
TYPES : BEGIN OF t_file ,
          mbrsh       TYPE mbrsh,        "1 Industry sector
          matnr       TYPE matnr,        "2 Material code
          mtart       TYPE mtart,        "3 Material Type
          werks       TYPE t001w-werks,  "4 Plant   "ZBRNDEF-WERKS,
          lgort       TYPE t001l-lgort,  "5 Storage Locations    "zmatdef-lgort,
*          lgor2       TYPE t001l-lgort,  "6 Storage Locations    "zmatdef-lgort,
*          lgor3       TYPE t001l-lgort,  "6 Storage Locations    "zmatdef-lgort,
*          lgor4       TYPE t001l-lgort,  "6 Storage Locations    "zmatdef-lgort,
*          lgor5       TYPE t001l-lgort,  "6 Storage Locations    "zmatdef-lgort,
          vkorg       TYPE vbrk-vkorg,   "6 Sales Organization
          vtweg       TYPE vbrk-vtweg,   "7 Distribution Channel "zmatdef-vtweg,
          maktx       TYPE makt-maktx,   "8 Material Description (Short Text)
          meins       TYPE mara-meins,   "9 Base Unit of Measure
          bismt       TYPE bismt,        "10 Old material number
          meinh       TYPE meinh,        "11 Unit of Measure for Display
*          lrmei       TYPE lrmei,        "12 Alternative Unit of Measure for Stockkeeping Unit
          umren       TYPE umren,        "12 Denominator for conversion to base units of measure
          umrez       TYPE umrez,        "13 Numerator for Conversion to Base Units of Measure
          brand       TYPE zbrand,       "14 IS-H: General Field with Length 2, for Function Modules
          zseries     TYPE char03,       "15 Three-digit character field for IDocs
          zmsize      TYPE char03,       "16 Three-digit character field for IDocs
          moc         TYPE char03,       "17 Three-digit character field for IDocs
          type        TYPE char03,       "18 Three-digit character field for IDocs
          extwg       TYPE extwg,        "19 External Material Group
          matkl       TYPE matkl,        "20 Material Group
          spart       TYPE spart,        "21 Division
          brgew       TYPE brgew,        "22 Gross Weight
          ntgew       TYPE ntgew,        "23 Net Weight
          taxm1       TYPE mg03steuer-taxkm,    "24 Tax indicator for material zmatdef-taxkm_01,
          taxm2       TYPE mg03steuer-taxkm,    "25 zmatdef-taxkm_02,
          taxm3       TYPE mg03steuer-taxkm,    "26 zmatdef-taxkm_03,
          taxm4       TYPE mg03steuer-taxkm,    "27 zmatdef-taxkm_04,
          taxm5       TYPE mg03steuer-taxkm,
          taxm6      TYPE mg03steuer-taxkm,
          taxm7       TYPE mg03steuer-taxkm,
          taxm8       TYPE mg03steuer-taxkm,

          dwerk       TYPE dwerk,        "28 Delivering Plant
          versg       TYPE versg,        "29 mat stat group
          ktgrm       TYPE ktgrm,        "30 Account assignment group for this material    "zmatdef-ktgrm,
          mtpos_mara  TYPE mtpos_mara,   "31 General item category group
          mtpos       TYPE mtpos,        "32 Item category group from material master
          mtvfp       TYPE mtvfp,        "33 Checking Group for Availability Check
          tragr       TYPE tragr,        "34 Transportation Group
          ladgr       TYPE ladgr,        "35 Loading Group
          magrv       TYPE magrv,        "36 Material Group: Packaging Materials
          prctr       TYPE prctr,        "37 Profit Center    "zbrndef-prctr,
          sernp       TYPE serail,       "38 Serial Number Profile    "zmatdef-sernp,
          bstme       TYPE bstme,        "39 Purchase Order Unit of Measure
          ekgrp       TYPE ekgrp,        "40 Purchasing Group  "zbrndef-ekgrp,
          dismm       TYPE dismm,        "41 MRP Type          "zmatdef-dismm,
          dispo       TYPE dispo,        "42 MRP Controller (Materials Planner)      "zbrndef-dispo,
          bstmi       TYPE bstmi,        "43 minimum order qty
          disls       TYPE disls,        "44 Lot size (materials planning)
          beskz       TYPE beskz,        "45 Procurement Type      "zmatdef-beskz,   "prcr type
          sobsl       TYPE sobsl,        "46 Special procurement type
          wzeit       TYPE wzeit,        "47 Total replenishment lead time (in workdays)
          plifz       TYPE plifz,        "48 Planned Delivery Time in Days
*          lgpro       TYPE marc-lgpro,   "Issue Storage Location                              " Commented By Abhishek Pisolkar (3.3.2018)
          fhori       TYPE fhori,        "49 Scheduling Margin Key for Floats
          strgr       TYPE strgr,        "50 Planning strategy group    zmatdef-strgr,
          vrmod       TYPE vrmod,        "51 Consumption mode
          vint1       TYPE vint1,        "52 Consumption period: backward    "zmatdef-vint1,
          vint2       TYPE vint2,        "53 Consumption period: backward    "zmatdef-vint2,
          sbdkz       TYPE sbdkz,        "54 Dependent requirements ind. for individual and coll. reqmts
          fevor       TYPE fevor,        "55 Production scheduler "zmatdef-fevor,
          sfcpf       TYPE co_prodprf,   "56 Production Scheduling Profile    "zmatdef-sfcpf,
          dzeit       TYPE dzeit,        "57 In-house production time  zmatdef-dzeit,  " in house prd time
          ausme       TYPE ausme,        "58 Unit of issue
          bklas       TYPE bklas,        "59 Valuation Class  zmatdef-bklas,
          vprsv       TYPE vprsv,        "60 Price Control Indicatorzmatdef-vprsv,
          verpr       TYPE verpr,        "61 Moving Average Price/Periodic Unit Price   zmatdef-verpr,
          stprs       TYPE stprs,        "62 Standard price
*          peinh       TYPE peinh,        "64 Price unit
          ekalr       TYPE ck_ekalrel,   "63 Material Is Costed with Quantity Structure
          losgr       TYPE losgr,        "64 Planned lot size
          class       TYPE klasse_d,     "65 Class number    "zbrndef-class,
          value_char1 TYPE atwrt,        "66 Characteristic Value
          value_char2 TYPE atwrt,        "67 Characteristic Value
          value_char3 TYPE atwrt,        "68 Characteristic Value
          value_char4 TYPE atwrt,        "69 Characteristic Value
          value_char5 TYPE atwrt,        "70 Characteristic Value
          value_char6 TYPE atwrt,        "71 Characteristic Value
          value_char7 TYPE atwrt,        "72 Characteristic Value
          value_char8 TYPE atwrt,        "73 Characteristic Value
          value_char9 TYPE atwrt,        "74 Characteristic Value
          lgpbe       TYPE lgpbe,        "75 Storage Bin
          raube       TYPE mara-raube,   "76 Storage Conditions
          j_1ichid    TYPE j_1ichid,     "77 Chapter ID
*          steuc       TYPE marc-steuc,    "HSN Code
          j_1igrxref  TYPE j_1igrxref-mblnr, "78 No of GR per EI
          j_1isubind  TYPE j_1imtchid-j_1isubind,  "79Material Can Be Sent to Subcontractors
          j_1icapind  TYPE j_1icapind,   "80 Material Type
          j_1imoom    TYPE j_1imoom,     "81 Output material for Modvat
          j_1iassval  TYPE j_1iassval-j_1ivalass,  "82 Assessable Value
          text_line   TYPE string,      "83 Long text
          qmpur       TYPE qmpur,        "84 QM in Procurement is Active
          ssqss       TYPE ssqss,        "85 QA Control Key
          art         TYPE rmqam-art,    "86 Inspection Type
          aktiv       TYPE rmqam-aktiv,  "87 QA Control Key
          pstat       TYPE pstat_d,      "88 Maintenance status
          mixed_mrp   TYPE bapi_marc-mixed_mrp,  "89 Mixed MRP indicator
          document    TYPE bapi_mara-document,    "90Document
          doc_vers    TYPE bapi_mara-doc_vers,    "91Document version
          NO_COSTING  TYPE bapi_marc-NO_COSTING,"92
          MSS         TYPE mara-ZZMSS,  "93
          EDS         TYPE mara-ZZEDS,  "94
          cap         TYPE mara-cap_lead,"95
          PRICE3      TYPE DZPLP3_BAPI,  "96planned price 3                                  added by ajay
          PLNDPRDATE3 TYPE DZPLD2,        "97 PLANNED PRICE DATE
          item_type TYPE mara-item_type, "Item type
*          j_1isubind  TYPE j_1imtchid-j_1isubind,   "86 Material Can Be Sent to Subcontractors
        END OF t_file .

TYPES: BEGIN OF t_alsmex.
    INCLUDE STRUCTURE alsmex_tabline.
TYPES: END OF t_alsmex.

DATA : v_bool  TYPE c,
       v_pstat TYPE pstat_d.

*&--- Erro Log table
DATA : BEGIN OF i_error OCCURS 0 ,
         matnr     TYPE matnr,
         l_mstring TYPE string,
       END OF i_error .

DATA : BEGIN OF i_suc OCCURS 0 ,
         matnr     TYPE matnr,
         l_mstring TYPE string,
       END OF i_suc .


DATA : i_bildtab             LIKE mbildtab OCCURS 0 WITH HEADER LINE,
       i_bildtab_marc        LIKE mbildtab OCCURS 0 WITH HEADER LINE,
       i_excel               LIKE alsmex_tabline OCCURS 0 WITH HEADER LINE,
       wa_excel              TYPE t_alsmex,
       w_materialdescription TYPE bapi_makt,
       w_uom                 TYPE bapi_marm,
       w_uomx                TYPE bapi_marmx,
       t_materialdescription TYPE STANDARD TABLE OF bapi_makt,
       t_uom                 TYPE STANDARD TABLE OF bapi_marm,
       t_longtext            TYPE STANDARD TABLE OF bapi_mltx,
       t_uomx                TYPE STANDARD TABLE OF bapi_marmx,
       t_tax                 TYPE STANDARD TABLE OF bapi_mlan,
       w_tax                 TYPE bapi_mlan,
       w_longtext            TYPE bapi_mltx,
       gt_fldcat             TYPE STANDARD TABLE OF slis_fieldcat_alv,
       gwa_fldcat            TYPE slis_fieldcat_alv,
       it_return             TYPE STANDARD TABLE OF bapi_matreturn2,
       t_extension_in        TYPE TABLE OF  bapiparex,
       w_extension_in        TYPE bapiparex,
       t_extensionx_in       TYPE STANDARD TABLE OF bapiparexx,
       w_extensionx_in       TYPE bapiparexx,
       ls_ci_data            TYPE rebd_business_entity_ci,


*&-- internal table for file upload
       i_file                TYPE TABLE OF t_file,
       wa_file               TYPE t_file,
       vv_file               TYPE ibipparms-path,
       v_str                 TYPE string,
       v_initial             TYPE i,
       v_total               TYPE i,
       c_error(5)            TYPE c,
       c_total(5)            TYPE c,
       v_char30(30)          TYPE c,
       v_error               TYPE i,
       f                     TYPE i,
       c_f(20)               TYPE c,
       w_mwst(4)             TYPE c,
       w_land1               TYPE t001-land1,
       w_bukrs               TYPE bukrs.

*
*types: BEGIN OF ty_lines,
*
*       t2(132),
*      END OF ty_lines.


 DATA:
    lv_id    TYPE thead-tdname,
    lt_lines TYPE STANDARD TABLE OF tline,
    ls_lines TYPE tline.

***************************************************************
*        BAPI DATA
***************************************************************
DATA : wa_headdata         TYPE bapimathead,
       wa_clientdata       TYPE bapi_mara,

       wa_clientdatax      TYPE bapi_marax,
       wa_plantdata        TYPE bapi_marc,
       wa_plantdatax       TYPE bapi_marcx,
       wa_valuationdata    TYPE bapi_mbew,
       wa_valuationdatax   TYPE bapi_mbewx,
       wa_slocdata         TYPE bapi_mard,
       wa_slocdatax        TYPE bapi_mardx,
       wa_storagedata      TYPE bapi_mlgt,
       wa_storagedatax     TYPE bapi_mlgtx,
       wa_salesview        TYPE bapi_mvke,
       wa_salesviewx       TYPE bapi_mvkex,
       taxclassifications1 LIKE  bapi_mlan,
       wa_return           TYPE bapiret2.

FIELD-SYMBOLS: <f_data> TYPE  any.              "For File data

*>>
SELECTION-SCREEN BEGIN OF BLOCK blk6 WITH FRAME TITLE TEXT-t06 .
PARAMETERS : p_file LIKE rlgrap-filename .
PARAMETERS : p_updt AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK blk6 .

*>>
INITIALIZATION.
  GET RUN TIME FIELD f .
  IMPORT v_initial  FROM MEMORY ID 'ABC'.
  IF v_initial = 1 .
    v_initial = 2 .
    EXPORT  v_initial TO MEMORY ID 'ABC' .
  ELSE.
    CLEAR : v_initial .
  ENDIF.

  CLEAR : wa_file .
  CLEAR : wa_headdata ,
          wa_plantdata ,
          wa_clientdata ,
          wa_clientdatax ,
          wa_plantdata ,
          wa_plantdatax ,
          wa_valuationdata ,
          wa_valuationdatax ,
          wa_slocdata,
          wa_slocdatax,
          wa_storagedata,
          wa_storagedatax,
          wa_salesview,
          wa_salesviewx,
          wa_return,
          v_pstat .
  REFRESH: i_file, it_return.

*>>
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = vv_file.
  p_file = vv_file .

*>>
START-OF-SELECTION.
  PERFORM get_data_fore .
  PERFORM bapi_data .

*&--- Summarize the upload.
  c_total = v_total .
  APPEND i_error .
  CONCATENATE 'No. of records read from file: ' c_total
    INTO i_error-l_mstring
    SEPARATED BY space .
  APPEND i_error .
  CLEAR i_error .
  APPEND i_error .

  c_error = v_error .
  APPEND i_error .
  CONCATENATE 'Number of error records : ' c_error
               INTO i_error-l_mstring
               SEPARATED BY space .
  APPEND i_error .
  CLEAR i_error .
  APPEND i_error .
***& --- get runtime
  GET RUN TIME FIELD f .
  f = f / 1000000 .
  c_f = f .
  CONCATENATE 'Total time taken in seconds:'
               c_f
                INTO i_error-l_mstring
                SEPARATED BY space .
  APPEND i_error .

  CLEAR i_error .
  APPEND i_error .

  CONCATENATE 'Source File:'
               p_file
                INTO i_error-l_mstring
                SEPARATED BY space .
  APPEND i_error .

  CLEAR i_error .
  APPEND i_error .
*&--- Download Error Log
  PERFORM error_log .
  PERFORM error_display.

*>>
END-OF-SELECTION .
  v_initial = 1 .
  EXPORT  v_initial TO MEMORY ID 'ABC' .
*&---------------------------------------------------------------------*
*&      Form  bapi_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bapi_data .
*  DATA : v_costing(1) .
*&--- Loop at uploaded data
  DATA lv_matnr TYPE matnr.

*  DELETE i_file INDEX 1.                 " Commented By Abhishek Pisolkar (03.03.2018)

  DESCRIBE TABLE i_file LINES v_total .

  LOOP AT i_file INTO wa_file .

    SELECT SINGLE matnr FROM mara INTO lv_matnr
      WHERE matnr = wa_file-matnr.
    IF p_updt = 'X'.
      sy-subrc = 1.
    ENDIF.

    IF sy-subrc = 0.

      CLEAR i_error.
      MOVE wa_file-matnr TO i_error-matnr.
      i_error-l_mstring = 'Material already created'.

      APPEND i_error .
      CLEAR i_error.
    ELSE.
*   status check
*    PERFORM status_check.
*&--- To determine views sequence and select the required
      IF wa_file-pstat CS 'A'. " Work scheduling
        wa_headdata-work_sched_view = 'X'.
      ENDIF.
      IF wa_file-pstat CS 'B'. "Accounting
*        WHEN 'Accounting' .
        PERFORM fill_accounting_data .

      ENDIF.
      IF wa_file-pstat CS 'C'. "Classification
*PERFORM fill_classification.
      ENDIF.
      IF wa_file-pstat CS 'D'. "MRP
*        WHEN 'MRP 1'.
        PERFORM fill_mrp1_data .
*        WHEN 'MRP 2'.
        PERFORM fill_mrp2_data .

      ENDIF.
      IF wa_file-pstat CS 'E'. "Purchasing
        wa_headdata-purchase_view = 'X'.
      ENDIF.
      IF wa_file-pstat CS 'F'. " Prod resources/tools
        wa_headdata-prt_view = 'X'.
      ENDIF.
      IF wa_file-pstat CS 'G'. " Costing
*        WHEN 'Costing' .
        PERFORM fill_costing_data .

      ENDIF.
*        when Basic data
      IF wa_file-pstat CS 'K'. "Basic data
*&--- Perform to fill basic data
        PERFORM fill_basic_data .

      ENDIF.
*       when storage
      IF wa_file-pstat CS 'L'. "Storage
        PERFORM fill_storage_data.

      ENDIF.
*       when forcasting
      IF wa_file-pstat CS 'P'.
        wa_headdata-forecast_view = 'X'.
      ENDIF.
*        when Quality Mgmnt
      IF wa_file-pstat CS 'Q'.
        wa_headdata-quality_view = 'X'.
      ENDIF.
*        when Warehouse mgmnt
      IF wa_file-pstat CS 'S'.
        wa_headdata-warehouse_view = 'X'.
      ENDIF.
*        when Sales
      IF wa_file-pstat CS 'V'.
        wa_headdata-sales_view = 'X'.
        PERFORM sales_data.
      ENDIF.

*      PERFORM taxes.
*      taxclassifications1



*&---- Call BAPI_MATERIAL_SAVEDATA
      IF wa_file-pstat IS INITIAL.
        MOVE wa_file-matnr TO i_error-matnr.
        MOVE  'Please maintain at least basic view'  TO i_error-l_mstring.
        APPEND i_error .
        CLEAR : i_error .
        ADD 1 TO v_error.
      ELSE.
        PERFORM bapi_material .
      ENDIF.
      CLEAR : wa_file .
      CLEAR : wa_headdata ,
              wa_plantdata ,
              wa_clientdata ,
              wa_clientdatax ,
              wa_plantdata ,
              wa_plantdatax ,
              wa_valuationdata ,
              wa_valuationdatax ,
              wa_slocdata,
              wa_slocdatax,
              wa_storagedata,
              wa_storagedatax,
              wa_salesview,
              wa_salesviewx,
              wa_return ,
              w_uom,
              w_uomx.
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
FORM get_data_fore .

*Read the upload file
  v_str = p_file .
  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file   = v_str
    RECEIVING
      result = v_bool.
  TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.

  DATA : rawdata TYPE truxs_t_text_data.
  IF v_bool IS NOT INITIAL .
*    v_file_up = p_file .
*    BREAK primus.
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
       I_LINE_HEADER        = 'X'
        i_tab_raw_data       = rawdata
        i_filename           = p_file
      TABLES
        i_tab_converted_data = i_file
* EXCEPTIONS
*       CONVERSION_FAILED    = 1
*       OTHERS               = 2
      .
    IF sy-subrc <> 0.
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
FORM fill_basic_data .
  CLEAR: w_materialdescription.
  REFRESH: t_materialdescription.
*&--- Fill Header data
  wa_headdata-material = wa_file-matnr .
  wa_headdata-matl_type = wa_file-mtart.
  wa_headdata-ind_sector = wa_file-mbrsh. "'C'.
  wa_headdata-basic_view = 'X'.

*&--- Client data
  wa_clientdata-base_uom = wa_file-meins .
  wa_clientdatax-base_uom = 'X' .
  wa_clientdata-extmatlgrp = wa_file-extwg .
  wa_clientdatax-extmatlgrp = 'X' .

  wa_clientdata-matl_group = wa_file-matkl.
  wa_clientdatax-matl_group = 'X'.
  wa_clientdata-old_mat_no = wa_file-bismt.
  wa_clientdatax-old_mat_no = 'X'.
*  wa_clientdata-PO_UNIT = wa_file-BSTME.
*  wa_clientdatax-PO_UNIT = 'X'.
  wa_clientdata-qm_procmnt = wa_file-qmpur.
  wa_clientdatax-qm_procmnt = 'X'.
*  wa_clientdata-division= wa_file-spart.
*  wa_clientdatax-division = 'X'.
  wa_clientdata-net_weight = wa_file-ntgew.
  wa_clientdatax-net_weight = 'X'.
  wa_clientdata-document  = wa_file-document.
  wa_clientdatax-document = 'X'.
  wa_clientdata-doc_vers  = wa_file-doc_vers.
  wa_clientdatax-doc_vers = 'X'.
  wa_clientdata-stor_conds = wa_file-raube.
  wa_clientdatax-stor_conds = 'X'.


*&--- Plant data
  wa_plantdata-plant    = wa_file-werks .
  wa_plantdatax-plant   = wa_file-werks .
  wa_plantdata-proc_type    = wa_file-beskz.
  wa_plantdatax-proc_type   = 'X'.

  wa_plantdata-sm_key    = wa_file-fhori.
  wa_plantdatax-sm_key   = 'X'.
  wa_plantdata-ctrl_key    = wa_file-ssqss.
  wa_plantdatax-ctrl_key   = 'X'.
  wa_plantdata-profit_ctr    = wa_file-prctr.
  wa_plantdatax-profit_ctr   = 'X'.
  wa_plantdata-lot_size    = wa_file-losgr.
  wa_plantdatax-lot_size   = 'X'.
  wa_plantdata-ctrl_code  = wa_file-j_1ichid.
  wa_plantdatax-ctrl_code  = 'X'.
  wa_plantdata-iss_st_loc  = wa_file-lgort.       "wa_file-lgpro.      "Issue Storage Location  Commented By Abhishek Pisolkar (3.3.2018)
  wa_plantdatax-iss_st_loc  = 'X'.
  wa_plantdata-NO_COSTING  = wa_file-NO_COSTING.
  wa_plantdatax-NO_COSTING  = 'X'.

*&--- Storage location  data
  wa_slocdata-plant = wa_file-werks.
  wa_slocdata-stge_loc = wa_file-lgort.
  wa_slocdatax-plant = wa_file-werks.
  wa_slocdatax-stge_loc = wa_file-lgort.


  w_materialdescription-langu = sy-langu.
  w_materialdescription-matl_desc = wa_file-maktx.
  APPEND w_materialdescription TO t_materialdescription.

  IF wa_file-meinh IS NOT INITIAL.

    w_uom-denominatr = wa_file-umren.
    w_uom-numerator = wa_file-umrez.
    w_uom-alt_unit = wa_file-meinh.
    IF wa_file-meinh = 'KG'.
      w_uom-alt_unit_iso = '3H' ."wa_file-lrmei.
    ENDIF.
    IF wa_file-meinh = 'EA'.
      w_uom-alt_unit_iso = 'EA' ."wa_file-lrmei.
    ENDIF.

    APPEND w_uom TO t_uom.
  ENDIF.

  w_uomx-denominatr = 'X'.
  w_uomx-numerator = 'X'.
  w_uomx-alt_unit = wa_file-meinh ."'X'.
  w_uomx-alt_unit_iso = '3H' ."wa_file-lrmei ."'X'.
  APPEND w_uomx TO t_uomx.
TRANSLATE WA_FILE-matnr TO UPPER CASE .
  lv_id = WA_FILE-matnr.
      CLEAR: lt_lines,ls_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_id
          object                  = 'MATERIAL'
        TABLES
          lines                   = lt_lines
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
      IF  lt_lines IS INITIAL.
  READ TABLE lt_lines INTO ls_lines INDEX 1.
  if ls_lines-TDFORMAT NE '*'.
  w_longtext-text_name =  wa_file-matnr .
  w_longtext-text_id = 'BEST'.
  w_longtext-langu = 'EN'.
  w_longtext-applobject = 'MATERIAL'.
  w_longtext-text_line =  wa_file-text_line.
  APPEND w_longtext TO t_longtext.
ENDIF.
ENDIF .
    EXPORT t_longtext TO MEMORY ID 'zlog'.

* fill values for user fields , BAPI extension

  w_extension_in-structure = 'BAPI_TE_MARA'.
  CONCATENATE wa_file-matnr wa_file-zseries wa_file-zmsize
              wa_file-brand wa_file-moc wa_file-type WA_FILE-ITEM_TYPE
    INTO w_extension_in-valuepart1.
  APPEND w_extension_in  TO t_extension_in.

  w_extensionx_in-structure = 'BAPI_TE_MARAX'.
  CONCATENATE wa_file-matnr  'X' 'X' 'X' 'X' 'X'
  INTO w_extensionx_in-valuepart1.

  APPEND w_extensionx_in  TO t_extensionx_in.

ENDFORM.                    " fill_basic_data
*&---------------------------------------------------------------------*
*&      Form  fill_mrp1_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_mrp1_data .
*&---  Fill MRP1 Data
  wa_headdata-mrp_view = 'X'.

  wa_plantdata-plant      = wa_file-werks .
  wa_plantdata-pur_group  = wa_file-ekgrp .
  wa_plantdata-mrp_type   = wa_file-dismm.
  wa_plantdata-lotsizekey = wa_file-disls .
  wa_plantdata-minlotsize = wa_file-bstmi .
  wa_plantdata-replentime = wa_file-wzeit .
  wa_plantdata-mrp_ctrler = wa_file-dispo .
  wa_plantdata-spproctype = wa_file-sobsl .
  wa_plantdata-serno_prof = wa_file-sernp .
  wa_plantdata-plnd_delry = wa_file-plifz .
  wa_plantdata-inhseprodt = wa_file-dzeit .

*&--- Fill Plantdatax
  wa_plantdatax-plant      = wa_file-werks .
  wa_plantdatax-pur_group  = 'X' .
  wa_plantdatax-mrp_type   = 'X' .
  wa_plantdatax-lotsizekey = 'X' .
  wa_plantdatax-minlotsize = 'X' .
  wa_plantdatax-mrp_ctrler = 'X' .
  wa_plantdatax-spproctype = 'X' .
  wa_plantdatax-replentime = 'X' .
  wa_plantdatax-serno_prof = 'X' .
  wa_plantdatax-plnd_delry = 'X' .
  wa_plantdatax-inhseprodt = 'X' .

*&---to get company code plant wise.
  CALL FUNCTION 'HRCA_PLANT_GET_COMPANYCODE'
    EXPORTING
      plant                 = wa_file-werks
    IMPORTING
      companycode           = w_bukrs
    EXCEPTIONS
      no_company_code_found = 1
      plant_not_found       = 2
      OTHERS                = 3.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.                    " fill_mrp1_data
*&---------------------------------------------------------------------*
*&      Form  fill_mrp2_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_mrp2_data .
*&--- MRP2 data

  wa_plantdata-availcheck = wa_file-mtvfp .
  wa_plantdata-dep_req_id = wa_file-sbdkz .
  wa_plantdata-plan_strgp = wa_file-strgr.
  wa_plantdata-consummode  = wa_file-vrmod.
  wa_plantdata-bwd_cons  = wa_file-vint1.
  wa_plantdata-fwd_cons  = wa_file-vint2.
  wa_plantdata-production_scheduler = wa_file-fevor.
  wa_plantdata-prodprof = wa_file-sfcpf.
  wa_plantdatax-availcheck = 'X' .
  wa_plantdatax-dep_req_id = 'X'.
  wa_plantdatax-plan_strgp = 'X'.
  wa_plantdatax-consummode  = 'X'.
  wa_plantdatax-bwd_cons  = 'X'.
  wa_plantdatax-fwd_cons  = 'X'.
  wa_plantdatax-production_scheduler = 'X'.
  wa_plantdatax-prodprof = 'X'.
  wa_plantdata-mixed_mrp  = wa_file-mixed_mrp.
  wa_plantdatax-mixed_mrp  = 'X'.
  wa_plantdata-iss_st_loc = wa_file-lgort.
  wa_plantdatax-iss_st_loc = 'X'.

ENDFORM.                    " fill_mrp2_data
*&---------------------------------------------------------------------*
*&      Form  fill_accounting_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_accounting_data .

  wa_headdata-account_view = 'X'.
*&--- Valuation Area data
  wa_valuationdata-val_area  = wa_file-werks .
  wa_valuationdatax-val_area  = wa_file-werks .
  wa_valuationdata-moving_pr = wa_file-verpr.
  wa_valuationdatax-moving_pr = 'X'.
  wa_valuationdata-std_price = wa_file-stprs.
  wa_valuationdatax-std_price = 'X'.
  wa_valuationdata-price_unit = '1'.     "wa_file-peinh.
  wa_valuationdatax-price_unit = 'X'.
  wa_valuationdata-qty_struct = wa_file-ekalr.
  wa_valuationdatax-qty_struct = 'X'.

  wa_valuationdata-val_class = wa_file-bklas .
*  wa_valuationdata-VAL_TYPE  = wa_file-bwtar.
  wa_valuationdata-price_ctrl = wa_file-vprsv .
  wa_valuationdatax-val_class =  'X'.
  wa_valuationdatax-price_ctrl =  'X'.
*  wa_valuationdatax-VAL_TYPE  = wa_file-bwtar .
  wa_valuationdata-pr_unit_py = 1.
  wa_valuationdatax-pr_unit_py = 'X'.
  wa_valuationdata-pr_unit_pp = 1.
  wa_valuationdatax-pr_unit_pp = 'X'.

wa_valuationdata-PLNDPRICE3 =  WA_FILE-PRICE3.
wa_valuationdatax-PLNDPRICE3 = 'X'.
*BREAK primusabap.
wa_valuationdata-PLNDPRDATE3 = SY-DATUM.     "WA_FILE-PLNDPRDATE3.
wa_valuationdatax-PLNDPRDATE3 = 'X'.


ENDFORM.                    " fill_accounting_data
*&---------------------------------------------------------------------*
*&      Form  fill_costing_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_costing_data .

  wa_headdata-cost_view = 'X'.

  wa_valuationdata-orig_mat  = 'X'.  "wa_file-hkmat .
  wa_valuationdatax-orig_mat =  'X'.


ENDFORM.                    " fill_costing_data


*----------------------------------------------------------------------*
FORM fill_storage_data .
*&---Storage Type Data
*
  wa_headdata-storage_view = 'X'.

  wa_slocdata-stge_bin = wa_file-lgpbe.
  wa_slocdatax-stge_bin = 'X'.

  wa_slocdata-plant = wa_file-werks.
  wa_slocdatax-plant = wa_file-werks.

  wa_slocdata-stge_loc = wa_file-lgort.
  wa_slocdatax-stge_loc  = wa_file-lgort.
*
*  wa_storagedata-whse_no = '001'.
*  wa_storagedatax-whse_no = '001'.
*
* wa_storagedata-STGE_TYPE = '001'.
*  wa_storagedatax-STGE_TYPE = '001'.
*  append wa_storagedata to
ENDFORM.                    " FILL_STORAGE_DATA
*&---------------------------------------------------------------------*
*&      Form  bapi_material
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bapi_material .

IF wa_plantdata-proc_type is NOT INITIAL .





  CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
    EXPORTING
      headdata             = wa_headdata
      clientdata           = wa_clientdata
      clientdatax          = wa_clientdatax
      plantdata            = wa_plantdata
      plantdatax           = wa_plantdatax
*     FORECASTPARAMETERS   =
*     FORECASTPARAMETERSX  =
*     PLANNINGDATA         =
*     PLANNINGDATAX        =
      storagelocationdata  = wa_slocdata
      storagelocationdatax = wa_slocdatax
      valuationdata        = wa_valuationdata
      valuationdatax       = wa_valuationdatax
*     WAREHOUSENUMBERDATA  =
*     WAREHOUSENUMBERDATAX =
      salesdata            = wa_salesview
      salesdatax           = wa_salesviewx
*     STORAGETYPEDATA      = wa_storagedata
*     STORAGETYPEDATAX     = wa_storagedatax
*     FLAG_ONLINE          = ' '
*     FLAG_CAD_CALL        = ' '
*     NO_DEQUEUE           = ' '
    IMPORTING
      return               = wa_return
    TABLES
      materialdescription  = t_materialdescription
      unitsofmeasure       = t_uom
      unitsofmeasurex      = t_uomx
*.*   INTERNATIONALARTNOS         =
*     MATERIALLONGTEXT     = t_longtext
      taxclassifications   = t_tax
      returnmessages       = it_return
*     PRTDATA              =
*     PRTDATAX             =
      extensionin          = t_extension_in
      extensioninx         = t_extensionx_in
*     NFMCHARGEWEIGHTS     =
*     NFMCHARGEWEIGHTSX    =
*     NFMSTRUCTURALWEIGHTS =
*     NFMSTRUCTURALWEIGHTSX       =
    .



  IF wa_return-type = 'E'.
    MOVE wa_file-matnr TO i_error-matnr.
    MOVE  wa_return-message  TO i_error-l_mstring.
    APPEND i_error .
    CLEAR : i_error .
    ADD 1 TO v_error.
  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    UPDATE mara SET zseries = wa_file-zseries
                    zsize   = wa_file-zmsize
                    brand   = wa_file-brand
                    moc     = wa_file-moc
                    type    = wa_file-type
                    ZZMSS   = wa_file-mss
                    ZZEDS   = wa_file-eds
                    cap_lead = wa_file-cap
                    ITEM_TYPE = WA_FILE-ITEM_TYPE
    WHERE matnr = wa_file-matnr .
    WAIT UP TO  1 SECONDS.
    EXPORT wa_file-matnr wa_file-text_line TO MEMORY ID 'zmat' .

    IF wa_file-art IS NOT INITIAL.
      EXPORT wa_file-matnr wa_file-werks wa_file-mtart wa_file-art wa_file-aktiv TO MEMORY ID 'zqual' .

    ENDIF.
    EXPORT wa_file-matnr wa_file-mtart wa_file-werks wa_file-j_1ichid
           wa_file-j_1igrxref wa_file-j_1icapind
           wa_file-j_1imoom wa_file-j_1iassval wa_file-j_1isubind
           wa_file-mtpos_mara
*     wa_file-j_1isubind
     TO MEMORY ID 'zcin' .
*    SUBMIT zmm_qualityviewext_upload AND RETURN.
*    SUBMIT zmm_matlongtext_upload  AND RETURN .
*    SUBMIT  zmm_matcin_upload AND RETURN.
    IF wa_file-art IS NOT INITIAL.
      SUBMIT zmm_upload_mat_qm_view AND RETURN.
    ENDIF.
    IF t_longtext  IS  NOT INITIAL .
     SUBMIT zmm_upload_mat_long_txt AND RETURN.
     ENDIF.
    IF wa_file-mtart = 'FERT'.
      SUBMIT zmm_upload_mat_cin AND RETURN.
    ELSE.
      SUBMIT zmm_upload_mat_cin_roh AND RETURN.
    ENDIF.

    MOVE wa_file-matnr TO i_error-matnr.
    MOVE wa_return-message TO i_error-l_mstring.
    APPEND i_error .
*    CLEAR: wa_err0r.
  ENDIF .
 ELSE.
   MOVE wa_file-matnr TO i_error-matnr.
    MOVE 'Procurement type is missing.' TO i_error-l_mstring.
    APPEND i_error .

   ENDIF.

ENDFORM.                    " bapi_material
*&---------------------------------------------------------------------*
*&      Form  ERROR_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM error_log .

  REFRESH: gt_fldcat.

  gwa_fldcat-fieldname  = 'MATNR'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = 'Material'.
  gwa_fldcat-seltext_m  = 'Material'.
  gwa_fldcat-seltext_s  = 'Material'.
  gwa_fldcat-outputlen  = '000018'.

  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.

  gwa_fldcat-fieldname  = 'L_MSTRING'.
  gwa_fldcat-tabname    = 'I_ERROR'.
  gwa_fldcat-seltext_l  = ' Message'.
*  gwa_fldcat-seltext_m  = 'Error Message'.
*  gwa_fldcat-seltext_s  = 'Error Message'.
  gwa_fldcat-outputlen  = '000070'.

  APPEND gwa_fldcat TO gt_fldcat.
  CLEAR  gwa_fldcat.


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
FORM error_display .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     is_layout   = gwa_layout_col
      it_fieldcat = gt_fldcat
    TABLES
      t_outtab    = i_error.


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
FORM status_check .
  CLEAR: v_pstat.
  SELECT SINGLE
         pstat
         FROM marc
         INTO v_pstat
         WHERE matnr = wa_file-matnr
         AND   werks = wa_file-werks.
  IF sy-subrc = 0.
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
FORM sales_data .

  DATA: lv_comp TYPE hrca_company-comp_code.
  CLEAR: w_mwst,w_land1.
  CLEAR: w_tax.
  REFRESH : t_tax.


  wa_clientdata-division = wa_file-spart .
  wa_clientdatax-division = 'X' .
  wa_clientdata-trans_grp = wa_file-tragr.
  wa_clientdatax-trans_grp = 'X'.

  IF wa_file-magrv IS NOT INITIAL.
    wa_salesview-matl_grp_1 = wa_file-magrv.
    wa_salesviewx-matl_grp_1 = 'X'.
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

  IF  wa_file-mtpos_mara IS NOT INITIAL.
    wa_clientdata-item_cat = wa_file-mtpos_mara.
    wa_clientdatax-item_cat = 'X'.
  ENDIF.
  IF  wa_file-ladgr IS NOT INITIAL.
    wa_plantdata-loadinggrp    = wa_file-ladgr.
    wa_plantdatax-loadinggrp   = 'X'.
  ENDIF.
  IF  wa_file-vkorg IS NOT INITIAL.
    wa_salesview-sales_org      = wa_file-vkorg.
    wa_salesviewx-sales_org      = wa_file-vkorg.
  ENDIF.
  IF  wa_file-vtweg IS NOT INITIAL.
    wa_salesview-distr_chan      = wa_file-vtweg.
    wa_salesviewx-distr_chan      = wa_file-vtweg.
  ENDIF.
  IF  wa_file-versg IS NOT INITIAL.
    wa_salesview-matl_stats      = wa_file-versg.
    wa_salesviewx-matl_stats      = 'X'.
  ENDIF.
*  if   wa_file-VRKME is not INITIAL.
*    wa_salesview-SALES_UNIT      = wa_file-VRKME.
*    wa_salesviewx-SALES_UNIT      = 'X'.
*  endif.

  IF  wa_file-mtpos IS NOT INITIAL.
    wa_salesview-item_cat      = wa_file-mtpos.
    wa_salesviewx-item_cat      = 'X'.
  ENDIF.

  IF  wa_file-dwerk IS NOT INITIAL.
    wa_salesview-delyg_plnt      = wa_file-dwerk.
    wa_salesviewx-delyg_plnt      = 'X'.
  ENDIF.

  IF  wa_file-ktgrm IS NOT INITIAL.
    wa_salesview-acct_assgt      = wa_file-ktgrm.
    wa_salesviewx-acct_assgt      = 'X'.
  ENDIF.

* Tax Classification.
  SELECT SINGLE land1
        INTO  w_land1
        FROM t001
        WHERE bukrs = w_bukrs.

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

  w_tax-depcountry = w_land1.
  w_tax-tax_type_1 = 'JOCG'.    "'JTX1' ."w_mwst.
  w_tax-tax_type_2 = 'JOSG'.    "'JTX2' .
  w_tax-tax_type_3 = 'JOIG'.    "'JTX3' .
  w_tax-tax_type_4 = 'JOUG'.    "'JTX3' .
  w_tax-tax_type_5 = 'ZCST'.    "'JTX3' .
  w_tax-tax_type_6 = 'ZLST'.    "'JTX3' .
  w_tax-tax_type_7 = 'ZSER'.    "'JTX3' .
  w_tax-tax_type_8 = 'JTC1'.    "'JTX4' .


  w_tax-taxclass_1 = wa_file-taxm1.
  w_tax-taxclass_2 = wa_file-taxm2.
  w_tax-taxclass_3 = wa_file-taxm3.
  w_tax-taxclass_4 = wa_file-taxm4.
*  w_tax-taxclass_5 = 0."wa_file-taxm4.
*  w_tax-taxclass_6 = 0."wa_file-taxm4.
*  w_tax-taxclass_7 = 0."wa_file-taxm4.
**  w_tax-taxclass_4 = wa_file-taxm4.
   w_tax-taxclass_5 = wa_file-taxm5.
    w_tax-taxclass_6 = wa_file-taxm6.
     w_tax-taxclass_7 = wa_file-taxm7.
      w_tax-taxclass_8 = wa_file-taxm8.



  APPEND  w_tax TO t_tax .
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
