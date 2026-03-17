*&---------------------------------------------------------------------*
*& Report YMM_MAT_MAST_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsql_to_sap_mat_bdc_new NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPE-POOLS: slis.

*Data Declaration
*&--- Type for file upload
TYPES : BEGIN OF t_file ,
          mbrsh       TYPE mbrsh,        "2 Industry sector
          matnr       TYPE matnr,        "3 Material code
          mtart       TYPE mtart,        "4 Material Type
          werks       TYPE t001w-werks,  "5 Plant   "ZBRNDEF-WERKS,
          maktx       TYPE makt-maktx,   "9 Material Description (Short Text)
          meins       TYPE mara-meins,   "10 Base Unit of Measure
          bismt       TYPE bismt,        "11 Old material number
          brand       TYPE zbrand,       "15 IS-H: General Field with Length 2, for Function Modules
          zseries     TYPE char03,       "16 Three-digit character field for IDocs
          zmsize      TYPE char03,       "17 Three-digit character field for IDocs
          moc         TYPE char03,       "18 Three-digit character field for IDocs
          type        TYPE char03,       "19 Three-digit character field for IDocs
          text_line(500)   TYPE c,       "82 Long text
          document    TYPE bapi_mara-document,    "Document
          doc_vers    TYPE bapi_mara-doc_vers,    "Document version
          prctr       TYPE prctr,        "38 Profit Center    "zbrndef-prctr,
          MSS         TYPE mara-ZZMSS,
          EDS         TYPE mara-ZZEDS,
          span_txt(500)  TYPE c,      "82 spanish Text
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
         msg       TYPE char20,
         ref       TYPE char15,
         time      TYPE char10,
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

DATA : size TYPE mara-zsize,
       series TYPE mara-ZSERIES,
       brand  TYPE mara-BRAND,
       profit TYPE cepc-prctr,
       size_msg TYPE char10,
       ser_msg  TYPE char10,
       brand_msg    TYPE char10,
       profit_msg    TYPE char10.

*>>
SELECTION-SCREEN BEGIN OF BLOCK blk6 WITH FRAME TITLE TEXT-t06 .
PARAMETERS : p_file LIKE rlgrap-filename .
*PARAMETERS : p_updt AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK blk6 .

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT   '/Delval/India'."India'."temp/item_master'.            "'/delval/temp/item_master'.
SELECTION-SCREEN END OF BLOCK B2.


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


*&--- Download Error Log
 IF P_DOWN = 'X'.
  PERFORM download.
 ENDIF.
*  PERFORM error_log .
*  PERFORM error_display.

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
BREAK primus.
    SELECT SINGLE matnr FROM mara INTO lv_matnr
      WHERE matnr = wa_file-matnr.
*    IF p_updt = 'X'.
*      sy-subrc = 1.
*    ENDIF.

    IF sy-subrc = 0.

      CLEAR i_error.
      MOVE wa_file-matnr TO i_error-matnr.
      i_error-l_mstring = 'Material already created'.
      i_error-msg       = 'Existing'.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = sy-datum
        IMPORTING
          OUTPUT = i_error-REF.

      CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                      INTO i_error-REF SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
      APPEND i_error .
      CLEAR i_error.


    ELSE.


      SELECT SINGLE ZSIZE INTO size FROM ZMSIZE WHERE ZSIZE = wa_file-zmsize.
        IF sy-subrc = 4.
          size_msg = 'wrong'.
          CLEAR i_error.
          MOVE wa_file-matnr TO i_error-matnr.
           i_error-l_mstring = 'Material ZSIZE Is Wrong'.
           i_error-msg       = 'Error'.
           CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
             EXPORTING
               INPUT  = sy-datum
             IMPORTING
               OUTPUT = i_error-REF.

           CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                           INTO i_error-REF SEPARATED BY '-'.

           CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
           APPEND i_error .
           CLEAR i_error.
       ENDIF.


     SELECT SINGLE BRAND INTO BRAND FROM ZMSERIES WHERE brand = wa_file-brand.
        IF sy-subrc = 4.
          brand_msg = 'wrong'.
          CLEAR i_error.
          MOVE wa_file-matnr TO i_error-matnr.
           i_error-l_mstring = 'Material BRAND Is Wrong'.
           i_error-msg       = 'Error'.
           CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
             EXPORTING
               INPUT  = sy-datum
             IMPORTING
               OUTPUT = i_error-REF.

           CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                           INTO i_error-REF SEPARATED BY '-'.

           CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
           APPEND i_error .
           CLEAR i_error.
       ENDIF.

     SELECT SINGLE SER_CODE INTO series FROM ZMSERIES WHERE SER_CODE = wa_file-zseries.
        IF sy-subrc = 4.
          ser_msg = 'wrong'.
          CLEAR i_error.
          MOVE wa_file-matnr TO i_error-matnr.
           i_error-l_mstring = 'Material SERIES Is Wrong'.
           i_error-msg       = 'Error'.
           CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
             EXPORTING
               INPUT  = sy-datum
             IMPORTING
               OUTPUT = i_error-REF.

           CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                           INTO i_error-REF SEPARATED BY '-'.

           CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
           APPEND i_error .
           CLEAR i_error.
       ENDIF.

       SELECT SINGLE prctr INTO profit FROM cepc WHERE prctr = wa_file-prctr.
        IF sy-subrc = 4.
          profit_msg = 'wrong'.
          CLEAR i_error.
          MOVE wa_file-matnr TO i_error-matnr.
           i_error-l_mstring = 'Material Profit Center Is Wrong'.
           i_error-msg       = 'Error'.
           CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
             EXPORTING
               INPUT  = sy-datum
             IMPORTING
               OUTPUT = i_error-REF.

           CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                           INTO i_error-REF SEPARATED BY '-'.

           CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
           APPEND i_error .
           CLEAR i_error.
       ENDIF.


       IF size_msg  IS INITIAL.
       IF brand_msg IS INITIAL.
       IF ser_msg   IS INITIAL.
       IF profit_msg  IS INITIAL.


        PERFORM fill_basic_data .
        PERFORM bapi_material .
       ENDIF.
       ENDIF.
       ENDIF.
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
              w_uomx,
              size_msg ,
              brand_msg,
              ser_msg  .



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

*OPEN DATASET p_file
* FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.

  v_str = p_file .
  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file   = v_str
    RECEIVING
      result = v_bool.
  TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.
*  TYPES truxs_t_text_data(10000) TYPE c OCCURS 0.

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
  wa_headdata-storage_view = 'X'.
*&--- Client data
  wa_clientdata-base_uom = wa_file-meins .
  wa_clientdatax-base_uom = 'X' .



  wa_clientdata-old_mat_no = wa_file-bismt.
  wa_clientdatax-old_mat_no = 'X'.

  wa_clientdata-document  = wa_file-document.
  wa_clientdatax-document = 'X'.
  wa_clientdata-doc_vers  = wa_file-doc_vers.
  wa_clientdatax-doc_vers = 'X'.
*  wa_clientdata-stor_conds = wa_file-raube.
*  wa_clientdatax-stor_conds = 'X'.


*&--- Plant data
  wa_plantdata-plant    = wa_file-werks .
  wa_plantdatax-plant   = wa_file-werks .
*
*   wa_slocdata-plant = wa_file-werks.
*   wa_slocdatax-plant = wa_file-werks.

  wa_plantdata-profit_ctr    = wa_file-prctr.
  wa_plantdatax-profit_ctr   = 'X'.



  w_materialdescription-langu = sy-langu.
  w_materialdescription-matl_desc = wa_file-maktx.
  APPEND w_materialdescription TO t_materialdescription.


*****************************************************<<
BREAK primus.

types: BEGIN OF ty_lines,

       t2(132),
      END OF ty_lines.
      DATA : it_lines TYPE TABLE OF ty_lines,
             wa_lines TYPE           ty_lines.
DATA t1 TYPE xstring.
*t1 = wa_file-text_line.

* t1 = STRLEN( wa_file-text_line ).

CALL FUNCTION 'RKD_WORD_WRAP'
  EXPORTING
    textline                  = wa_file-text_line
*   DELIMITER                 = ' '
   OUTPUTLEN                 = 132
* IMPORTING
*   OUT_LINE1                 =
*   OUT_LINE2                 =
*   OUT_LINE3                 =
 TABLES
   OUT_LINES                 = it_lines
 EXCEPTIONS
   OUTPUTLEN_TOO_LARGE       = 1
   OTHERS                    = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.



*READ TABLE it_lines INTO wa_lines INDEX 1.  .
******************************************************





********************ENGLISH TEXT *********
  w_longtext-text_name =  wa_file-matnr .
*  w_longtext-text_id = 'BEST'.
*  w_longtext-langu = 'EN'.
  w_longtext-text_id = 'GRUN'.
  w_longtext-LANGU_ISO = 'EN'.
  w_longtext-applobject = 'MATERIAL'.

  loop at it_lines INTO wa_lines.
  w_longtext-text_line =  wa_lines-t2..
*  w_longtext-text_line =  wa_file-text_line.
  APPEND w_longtext TO t_longtext.
  ENDLOOP.
*********************************************
BREAK primusabap.
********************SPANISH TEXT *********

  w_longtext-text_name =  wa_file-matnr .
  w_longtext-text_id = 'GRUN'.
*  w_longtext-langu = 'ES'.
  w_longtext-LANGU_ISO = 'ES'.
  w_longtext-applobject = 'MATERIAL'.
  w_longtext-text_line =  wa_file-span_txt+0(132).
  APPEND w_longtext TO t_longtext.

  w_longtext-text_name =  wa_file-matnr .
  w_longtext-text_id = 'GRUN' ."'BEST'
*  w_longtext-langu = 'ES'.
  w_longtext-LANGU_ISO = 'ES'.
  w_longtext-applobject = 'MATERIAL'.
  w_longtext-text_line = wa_file-span_txt+132(132).
  APPEND w_longtext TO t_longtext.

  w_longtext-text_name =  wa_file-matnr .
  w_longtext-text_id = 'GRUN' ."'BEST'
*  w_longtext-langu = 'ES'.
  w_longtext-LANGU_ISO = 'ES'.
  w_longtext-applobject = 'MATERIAL'.
  w_longtext-text_line = wa_file-span_txt+264(132).
  APPEND w_longtext TO t_longtext.

  w_longtext-text_name =  wa_file-matnr .
  w_longtext-text_id = 'GRUN' ."'BEST'
*  w_longtext-langu = 'ES'.
  w_longtext-LANGU_ISO = 'ES'.
  w_longtext-applobject = 'MATERIAL'.
  w_longtext-text_line =  wa_file-span_txt+396(104).
  APPEND w_longtext TO t_longtext.

*  w_longtext-text_name =  wa_file-matnr .
*  w_longtext-text_id = 'GRUN' ."'BEST'
**  w_longtext-langu = 'ES'.
*  w_longtext-LANGU_ISO = 'ES'.
*  w_longtext-applobject = 'MATERIAL'.
*  w_longtext-text_line =  wa_file-span_txt+528(132).
*  APPEND w_longtext TO t_longtext.
*********************************************

* fill values for user fields , BAPI extension

  w_extension_in-structure = 'BAPI_TE_MARA'.
  CONCATENATE wa_file-matnr wa_file-zseries wa_file-zmsize
              wa_file-brand wa_file-moc wa_file-type
              WA_FILE-mss WA_FILE-eds "ADDED BY JYOTIO N 10.01.2024

    INTO w_extension_in-valuepart1.
  APPEND w_extension_in  TO t_extension_in.

  w_extensionx_in-structure = 'BAPI_TE_MARAX'.
  CONCATENATE wa_file-matnr  'X' 'X' 'X' 'X' 'X' 'X' 'X'
  INTO w_extensionx_in-valuepart1.

  APPEND w_extensionx_in  TO t_extensionx_in.

ENDFORM.                    " fill_basic_data





*&---------------------------------------------------------------------*
*&      Form  bapi_material
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bapi_material .
BREAK primus.
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
     MATERIALLONGTEXT     = t_longtext
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
    i_error-msg       = 'Error'.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = sy-datum
        IMPORTING
          OUTPUT = i_error-REF.

      CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                      INTO i_error-REF SEPARATED BY '-'.
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

    WHERE matnr = wa_file-matnr .
    WAIT UP TO  1 SECONDS.
    EXPORT wa_file-matnr wa_file-text_line TO MEMORY ID 'zmat' .


*    SUBMIT zmm_upload_mat_long_txt AND RETURN.
    EXPORT wa_file-matnr wa_file-span_txt TO MEMORY ID 'zmat1' .
*    SUBMIT ZMM_UPLOAD_MAT_SPAN_TXT AND RETURN.

    MOVE wa_file-matnr TO i_error-matnr.
    MOVE wa_return-message TO i_error-l_mstring.
    i_error-msg       = 'Created'.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = sy-datum
        IMPORTING
          OUTPUT = i_error-REF.

      CONCATENATE i_error-REF+0(2) i_error-REF+2(3) i_error-REF+5(4)
                      INTO i_error-REF SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
    APPEND i_error .
*    CLEAR: wa_err0r.
  ENDIF .
  refresh : t_longtext.

ENDFORM.                    " bapi_material
*&---------------------------------------------------------------------*
*&      Form  ERROR_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM error_log .
*
*  REFRESH: gt_fldcat.
*
*  gwa_fldcat-fieldname  = 'MATNR'.
*  gwa_fldcat-tabname    = 'I_ERROR'.
*  gwa_fldcat-seltext_l  = 'Material'.
*  gwa_fldcat-seltext_m  = 'Material'.
*  gwa_fldcat-seltext_s  = 'Material'.
*  gwa_fldcat-outputlen  = '000018'.
*
*  APPEND gwa_fldcat TO gt_fldcat.
*  CLEAR  gwa_fldcat.
*
*  gwa_fldcat-fieldname  = 'L_MSTRING'.
*  gwa_fldcat-tabname    = 'I_ERROR'.
*  gwa_fldcat-seltext_l  = ' Message'.
**  gwa_fldcat-seltext_m  = 'Error Message'.
**  gwa_fldcat-seltext_s  = 'Error Message'.
*  gwa_fldcat-outputlen  = '000070'.
*
*  APPEND gwa_fldcat TO gt_fldcat.
*  CLEAR  gwa_fldcat.




*ENDFORM.                    " ERROR_LOG
*&---------------------------------------------------------------------*
*&      Form  ERROR_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM error_display .
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
**     is_layout   = gwa_layout_col
*      it_fieldcat = gt_fldcat
*    TABLES
*      t_outtab    = i_error.
*
*
*ENDFORM.                    " ERROR_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD .
  BREAK primusabap.
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
      I_TAB_SAP_DATA       = I_error
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


  LV_FILE = 'ITEM_MASTER.TXT'.


  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZMATERIAL started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_805 TYPE string.
DATA lv_crlf_805 TYPE string.
lv_crlf_805 = cl_abap_char_utilities=>cr_lf.
lv_string_805 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_805 lv_crlf_805 wa_csv INTO lv_string_805.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1922 TO lv_fullfile.
TRANSFER lv_string_805 TO lv_fullfile.
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
  CONCATENATE  'Material'
               'Message'
               'Status'
               'Refresh Date'
               'Time'
              INTO PD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
