*&---------------------------------------------------------------------*
*& Report YMM_MAT_MAST_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsql_to_sap_mat_bdc NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPE-POOLS: slis.

*Data Declaration
*&--- Type for file upload
TYPES : BEGIN OF t_file ,
          mbrsh     TYPE mbrsh,        "2 Industry sector
          matnr     TYPE matnr,        "3 Material code
          mtart     TYPE mtart,        "4 Material Type
          werks     TYPE t001w-werks,  "5 Plant   "ZBRNDEF-WERKS,
          maktx     TYPE makt-maktx,   "9 Material Description (Short Text)
          meins     TYPE mara-meins,   "10 Base Unit of Measure
          bismt     TYPE bismt,        "11 Old material number
          brand     TYPE zbrand,       "15 IS-H: General Field with Length 2, for Function Modules
          zseries   TYPE char03,       "16 Three-digit character field for IDocs
          zmsize    TYPE char03,       "17 Three-digit character field for IDocs
          moc       TYPE char03,       "18 Three-digit character field for IDocs
          type      TYPE char03,       "19 Three-digit character field for IDocs
          text_line(500) TYPE c,      "82 Long text
          document  TYPE bapi_mara-document,    "Document
          doc_vers  TYPE bapi_mara-doc_vers,    "Document version
          prctr     TYPE prctr,        "38 Profit Center    "zbrndef-prctr,
          MSS         TYPE mara-ZZMSS,  "ADDED BY JYOTI ON 10.01.2024
          EDS         TYPE mara-ZZEDS,  "ADDED BY JYOTI ON 10.01.2024
*          span_txt(500)  TYPE c,      "82 spanish Text
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

DATA : size       TYPE mara-zsize,
       series     TYPE mara-zseries,
       brand      TYPE mara-brand,
       profit     TYPE cepc-prctr,
       size_msg   TYPE char10,
       ser_msg    TYPE char10,
       brand_msg  TYPE char10,
       profit_msg TYPE char10.

*>>
SELECTION-SCREEN BEGIN OF BLOCK blk6 WITH FRAME TITLE TEXT-t06 .
PARAMETERS : p_file LIKE rlgrap-filename .
*PARAMETERS : p_updt AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK blk6 .

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India/item_master'."India'."temp/item_master'. "'/Delval/India/Item_Master'. "'/delval/temp/item_master'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK b3.

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
  IF p_down = 'X'.
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
  BREAK primusabap.
  LOOP AT i_file INTO wa_file .

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
          input  = sy-datum
        IMPORTING
          output = i_error-ref.

      CONCATENATE i_error-ref+0(2) i_error-ref+2(3) i_error-ref+5(4)
                      INTO i_error-ref SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
      APPEND i_error .
      CLEAR i_error.


    ELSE.


      SELECT SINGLE zsize INTO size FROM zmsize WHERE zsize = wa_file-zmsize.
      IF sy-subrc = 4.
        size_msg = 'wrong'.
        CLEAR i_error.
        MOVE wa_file-matnr TO i_error-matnr.
        i_error-l_mstring = 'Material ZSIZE Is Wrong'.
        i_error-msg       = 'Error'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = sy-datum
          IMPORTING
            output = i_error-ref.

        CONCATENATE i_error-ref+0(2) i_error-ref+2(3) i_error-ref+5(4)
                        INTO i_error-ref SEPARATED BY '-'.

        CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
        APPEND i_error .
        CLEAR i_error.
      ENDIF.


      SELECT SINGLE brand INTO brand FROM zmseries WHERE brand = wa_file-brand.
      IF sy-subrc = 4.
        brand_msg = 'wrong'.
        CLEAR i_error.
        MOVE wa_file-matnr TO i_error-matnr.
        i_error-l_mstring = 'Material BRAND Is Wrong'.
        i_error-msg       = 'Error'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = sy-datum
          IMPORTING
            output = i_error-ref.

        CONCATENATE i_error-ref+0(2) i_error-ref+2(3) i_error-ref+5(4)
                        INTO i_error-ref SEPARATED BY '-'.

        CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
        APPEND i_error .
        CLEAR i_error.
      ENDIF.

      SELECT SINGLE ser_code INTO series FROM zmseries WHERE ser_code = wa_file-zseries.
      IF sy-subrc = 4.
        ser_msg = 'wrong'.
        CLEAR i_error.
        MOVE wa_file-matnr TO i_error-matnr.
        i_error-l_mstring = 'Material SERIES Is Wrong'.
        i_error-msg       = 'Error'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = sy-datum
          IMPORTING
            output = i_error-ref.

        CONCATENATE i_error-ref+0(2) i_error-ref+2(3) i_error-ref+5(4)
                        INTO i_error-ref SEPARATED BY '-'.

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
            input  = sy-datum
          IMPORTING
            output = i_error-ref.

        CONCATENATE i_error-ref+0(2) i_error-ref+2(3) i_error-ref+5(4)
                        INTO i_error-ref SEPARATED BY '-'.

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
              ser_msg  ,
              profit_msg,
              t_longtext,
              w_longtext.

      REFRESH t_longtext.

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

*,,,****************for testing******************


********added for testig*********************
*OPEN DATASET p_file
* FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  DATA: it_text_data TYPE TABLE OF text4096,
        wa_text_data TYPE text4096.
*Read the upload file
  DATA l_wa_raw_data TYPE string.
  v_str = p_file .


  OPEN DATASET v_str FOR INPUT IN TEXT MODE ENCODING NON-UNICODE.
  IF sy-subrc = 0.
    DO.
      READ DATASET v_str INTO l_wa_raw_data.
      IF sy-subrc = 0.

        SPLIT l_wa_raw_data AT cl_abap_char_utilities=>horizontal_tab INTO :
         wa_file-mbrsh
         wa_file-matnr
         wa_file-mtart
         wa_file-werks
         wa_file-maktx
         wa_file-meins
         wa_file-bismt
         wa_file-brand
         wa_file-zseries
         wa_file-zmsize
         wa_file-moc
         wa_file-type
         wa_file-text_line
         wa_file-document
         wa_file-doc_vers
         wa_file-prctr
         wa_file-MSS   "ADDED BY JYOTI ON 10.01.2024
         wa_file-EDS . "ADDED BY JYOTI ON 10.01.2024
*       wa_file-span_txt.
*       wa_file-MSS
*       wa_file-EDS       .
        APPEND wa_file TO i_file.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.
  ELSE.
    i_error-msg       = 'File Not Found'.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = i_error-ref.

    CONCATENATE i_error-ref+0(2) i_error-ref+2(3) i_error-ref+5(4)
                    INTO i_error-ref SEPARATED BY '-'.

    CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
    APPEND i_error .
*    CLEAR: wa_err0r.

  ENDIF.
  CLOSE DATASET v_str.


  IF i_file IS INITIAL .


    i_error-msg       = 'No Record'.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = i_error-ref.

    CONCATENATE i_error-ref+0(2) i_error-ref+2(3) i_error-ref+5(4)
                    INTO i_error-ref SEPARATED BY '-'.

    CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
    APPEND i_error .
*    CLEAR: wa_err0r.
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
  CLEAR: w_materialdescription,w_longtext.
  REFRESH: t_materialdescription,t_longtext.
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

****************added by Ajay ****************************************QADB_DOCU_CONVERT_TO_SAPSCRIPT


*CALL FUNCTION 'TR_SPLIT_TEXT'
*  EXPORTING
*    iv_text        = wa_file-text_line
*   IV_LEN         = 132
* IMPORTING
*   ET_LINES       = wa_file-text_line
          .


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
  w_longtext-langu_iso = 'EN'.
  w_longtext-applobject = 'MATERIAL'.
  loop at it_lines INTO wa_lines.
*  w_longtext-text_line =  wa_file-text_line.
  w_longtext-text_line =  wa_lines-t2.
  APPEND w_longtext TO t_longtext.

  ENDLOOP.
*********************************************
  BREAK primusabap.
*********************SPANISH TEXT *********
*
*  w_longtext-text_name =  wa_file-matnr .
*  w_longtext-text_id = 'GRUN'.
**  w_longtext-langu = 'ES'.
*  w_longtext-LANGU_ISO = 'ES'.
*  w_longtext-applobject = 'MATERIAL'.
*  w_longtext-text_line =  wa_file-span_txt+0(132).
*  APPEND w_longtext TO t_longtext.
*
*  w_longtext-text_name =  wa_file-matnr .
*  w_longtext-text_id = 'GRUN' ."'BEST'
**  w_longtext-langu = 'ES'.
*  w_longtext-LANGU_ISO = 'ES'.
*  w_longtext-applobject = 'MATERIAL'.
*  w_longtext-text_line = wa_file-span_txt+132(132).
*  APPEND w_longtext TO t_longtext.
*
*  w_longtext-text_name =  wa_file-matnr .
*  w_longtext-text_id = 'GRUN' ."'BEST'
**  w_longtext-langu = 'ES'.
*  w_longtext-LANGU_ISO = 'ES'.
*  w_longtext-applobject = 'MATERIAL'.
*  w_longtext-text_line = wa_file-span_txt+264(132).
*  APPEND w_longtext TO t_longtext.
*
*  w_longtext-text_name =  wa_file-matnr .
*  w_longtext-text_id = 'GRUN' ."'BEST'
**  w_longtext-langu = 'ES'.
*  w_longtext-LANGU_ISO = 'ES'.
*  w_longtext-applobject = 'MATERIAL'.
*  w_longtext-text_line =  wa_file-span_txt+396(104).
*  APPEND w_longtext TO t_longtext.


*********************************************

* fill values for user fields , BAPI extension

  w_extension_in-structure = 'BAPI_TE_MARA'.
  CONCATENATE wa_file-matnr wa_file-zseries wa_file-zmsize
              wa_file-brand wa_file-moc wa_file-type WA_FILE-mss wa_file-eds
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
      materiallongtext     = t_longtext
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
        input  = sy-datum
      IMPORTING
        output = i_error-ref.

    CONCATENATE i_error-ref+0(2) i_error-ref+2(3) i_error-ref+5(4)
                    INTO i_error-ref SEPARATED BY '-'.
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
                    ZZMSS   = wa_file-mss "ADDED BY JYOTI ON 10.01.2024
                    ZZEDS   = wa_file-eds "ADDED BY JYOTI ON 10.01.2024
*                    ZZMSS   = wa_file-mss
*                    ZZEDS   = wa_file-eds

    WHERE matnr = wa_file-matnr .
    WAIT UP TO  1 SECONDS.
    EXPORT wa_file-matnr wa_file-text_line TO MEMORY ID 'zmat' .

*    SUBMIT zmm_upload_mat_long_txt AND RETURN.


    MOVE wa_file-matnr TO i_error-matnr.
    MOVE wa_return-message TO i_error-l_mstring.
    i_error-msg       = 'Created'.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = i_error-ref.

    CONCATENATE i_error-ref+0(2) i_error-ref+2(3) i_error-ref+5(4)
                    INTO i_error-ref SEPARATED BY '-'.

    CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO i_error-time SEPARATED BY ':'.
    APPEND i_error .
*    CLEAR: wa_err0r.
  ENDIF .

  refresh t_longtext.
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
FORM download .
  BREAK primusabap.
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = i_error
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  lv_file = 'ITEM_MASTER.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZMATERIAL started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_860 TYPE string.
DATA lv_crlf_860 TYPE string.
lv_crlf_860 = cl_abap_char_utilities=>cr_lf.
lv_string_860 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_860 lv_crlf_860 wa_csv INTO lv_string_860.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_805 TO lv_fullfile.
TRANSFER lv_string_860 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


******************************
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = i_error
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  lv_file = 'ITEM_UPLOAD.TXT'.


  CONCATENATE p_folder '/'  lv_file
    INTO lv_fullfile.

  WRITE: / 'ZMATERIAL started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_899 TYPE string.
DATA lv_crlf_899 TYPE string.
lv_crlf_899 = cl_abap_char_utilities=>cr_lf.
lv_string_899 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_899 lv_crlf_899 wa_csv INTO lv_string_899.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_805 TO lv_fullfile.
TRANSFER lv_string_899 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE  'Material'
               'Message'
               'Status'
               'Refresh Date'
               'Time'
              INTO pd_csv
                SEPARATED BY l_field_seperator.

ENDFORM.
