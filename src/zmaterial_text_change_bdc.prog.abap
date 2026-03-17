
REPORT ZMATERIAL_TEXT_CHANGE_BDC NO STANDARD PAGE HEADING LINE-SIZE 255.


TYPE-POOLS: slis.
TABLES: sscrfields.

TYPES : BEGIN OF t_file ,
          matnr       TYPE matnr,        "3 Material code
          mtart       TYPE mtart,        "4 Material Type
          werks       TYPE t001w-werks,  "5 Plant   "ZBRNDEF-WERKS,
          maktx       TYPE makt-maktx,   "9 Material Description (Short Text)
          text_line   TYPE char250,      "82 Long text
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
SELECTION-SCREEN END OF BLOCK blk6 .

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) w_button USER-COMMAND but1.
SELECTION-SCREEN END OF LINE.
*>>
INITIALIZATION.

w_button = 'Download Excel Template'.


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

AT SELECTION-SCREEN.

  IF sscrfields-ucomm EQ 'BUT1' .
    SUBMIT  ZMATERIAL_TEXT_CHANGE_BDC_EXL VIA SELECTION-SCREEN .
  ENDIF.
*>>
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = vv_file.
  p_file = vv_file .

*>>
START-OF-SELECTION.
*BREAK primus.
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

*      IF wa_file-pstat CS 'K'. "Basic data
**&--- Perform to fill basic data
        PERFORM fill_basic_data .
*
*      ENDIF.
        PERFORM bapi_material .

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
*    ENDIF.
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
*BREAK-POINT.
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
  wa_headdata-basic_view = 'X'.

  w_materialdescription-langu = sy-langu.
  w_materialdescription-matl_desc = wa_file-maktx.
  APPEND w_materialdescription TO t_materialdescription.

  w_longtext-text_name =  wa_file-matnr .
  w_longtext-text_id = 'GRUN'."'BEST'.
  w_longtext-langu = 'EN'.
  w_longtext-applobject = 'MATERIAL'.
  w_longtext-text_line =  wa_file-text_line+0(132).
  APPEND w_longtext TO t_longtext.

  w_longtext-text_name =  wa_file-matnr .
  w_longtext-text_id = 'GRUN'."'BEST'.
  w_longtext-langu = 'EN'.
  w_longtext-applobject = 'MATERIAL'.
  w_longtext-text_line =  wa_file-text_line+132(118).
  APPEND w_longtext TO t_longtext.


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
*      clientdata           = wa_clientdata
*      clientdatax          = wa_clientdatax
*      plantdata            = wa_plantdata
*      plantdatax           = wa_plantdatax
*     FORECASTPARAMETERS   =
*     FORECASTPARAMETERSX  =
*     PLANNINGDATA         =
*     PLANNINGDATAX        =
*      storagelocationdata  = wa_slocdata
*      storagelocationdatax = wa_slocdatax
*      valuationdata        = wa_valuationdata
*      valuationdatax       = wa_valuationdatax
*     WAREHOUSENUMBERDATA  =
*     WAREHOUSENUMBERDATAX =
*      salesdata            = wa_salesview
*      salesdatax           = wa_salesviewx
*     STORAGETYPEDATA      = wa_storagedata
*     STORAGETYPEDATAX     = wa_storagedatax
*     FLAG_ONLINE          = ' '
*     FLAG_CAD_CALL        = ' '
*     NO_DEQUEUE           = ' '
    IMPORTING
      return               = wa_return
    TABLES
      materialdescription  = t_materialdescription
*      unitsofmeasure       = t_uom
*      unitsofmeasurex      = t_uomx
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
    APPEND i_error .
    CLEAR : i_error .
    ADD 1 TO v_error.
  ELSE.

    EXPORT wa_file-matnr wa_file-text_line TO MEMORY ID 'zmat' .
    ENDIF.
    EXPORT wa_file-matnr  wa_file-werks "wa_file-j_1ichid
     TO MEMORY ID 'zcin' .
*    SUBMIT zmm_upload_mat_long_txt AND RETURN.


    MOVE wa_file-matnr TO i_error-matnr.
    MOVE wa_return-message TO i_error-l_mstring.
    APPEND i_error .

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
