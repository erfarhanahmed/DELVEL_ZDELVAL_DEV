*&---------------------------------------------------------------------*
*& Report ZMM_EXTEND_MAT_MAST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_extend_mat_mast.


TYPES: BEGIN OF ty_file,
         matnr(40),
         werks(4),
         lgort(4),
       END OF ty_file.

*&--- Erro Log table
TYPES: BEGIN OF ty_error,
         matnr TYPE matnr,
         messg TYPE text100,
       END OF ty_error .

DATA: gv_file TYPE ibipparms-path.
DATA: gt_file  TYPE TABLE OF ty_file,
      gt_error TYPE TABLE OF ty_error.

DATA: gv_error TYPE i.

*>>
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-t06 .
PARAMETERS : p_file LIKE rlgrap-filename .
SELECTION-SCREEN END OF BLOCK blk1.

*>>
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = gv_file.
  p_file = gv_file .

*>>
START-OF-SELECTION.
  PERFORM read_data.
  PERFORM run_bapi.
  PERFORM viv_log.

*&---------------------------------------------------------------------*
*&      Form  READ_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_data .

  TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.

  DATA: lt_rawdata TYPE truxs_t_text_data.
  DATA: lv_str  TYPE string,
        lv_bool TYPE c.

*Read the upload file
  lv_str = p_file .
  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file   = lv_str
    RECEIVING
      result = lv_bool.

  IF lv_bool IS NOT INITIAL .
*    v_file_up = p_file .
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
*       I_LINE_HEADER        =
        i_tab_raw_data       = lt_rawdata
        i_filename           = p_file
      TABLES
        i_tab_converted_data = gt_file
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RUN_BAPI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM run_bapi .

  DATA: ls_return    TYPE bapiret2,
        ls_headdata  TYPE bapimathead,
        ls_slocdatax TYPE bapi_mardx,
        ls_slocdata  TYPE bapi_mard,
        ls_file      TYPE ty_file,
        ls_error     TYPE ty_error.


  LOOP AT gt_file INTO ls_file.

    ls_headdata-material = ls_file-matnr .
    ls_headdata-storage_view = 'X'.

*&--- Storage location  data
    ls_slocdata-plant = ls_file-werks.
    ls_slocdatax-plant = ls_file-werks.
    ls_slocdata-stge_loc = ls_file-lgort.
    ls_slocdatax-stge_loc = ls_file-lgort.

    CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
      EXPORTING
        headdata             = ls_headdata
*       CLIENTDATA           =
*       CLIENTDATAX          =
*       PLANTDATA            =
*       PLANTDATAX           =
*       FORECASTPARAMETERS   =
*       FORECASTPARAMETERSX  =
*       PLANNINGDATA         =
*       PLANNINGDATAX        =
        storagelocationdata  = ls_slocdata
        storagelocationdatax = ls_slocdatax
*       VALUATIONDATA        =
*       VALUATIONDATAX       =
*       WAREHOUSENUMBERDATA  =
*       WAREHOUSENUMBERDATAX =
*       SALESDATA            =
*       SALESDATAX           =
*       STORAGETYPEDATA      =
*       STORAGETYPEDATAX     =
*       FLAG_ONLINE          = ' '
*       FLAG_CAD_CALL        = ' '
*       NO_DEQUEUE           = ' '
*       NO_ROLLBACK_WORK     = ' '
      IMPORTING
        return               = ls_return
*   TABLES
*       MATERIALDESCRIPTION  =
*       UNITSOFMEASURE       =
*       UNITSOFMEASUREX      =
*       INTERNATIONALARTNOS  =
*       MATERIALLONGTEXT     =
*       TAXCLASSIFICATIONS   =
*       RETURNMESSAGES       =
*       PRTDATA              =
*       PRTDATAX             =
*       EXTENSIONIN          =
*       EXTENSIONINX         =
      .


    IF ls_return-type = 'E'.
      CLEAR: ls_error .
      MOVE ls_file-matnr TO ls_error-matnr.
      MOVE  ls_return-message  TO ls_error-messg.
      APPEND ls_error TO gt_error.

      ADD 1 TO gv_error.
    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
      CLEAR: ls_error .
      MOVE ls_file-matnr TO ls_error-matnr.
      MOVE  ls_return-message  TO ls_error-messg.
      APPEND ls_error TO gt_error.

    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VIV_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM viv_log .
  DATA: lv_cnt   TYPE i.

  DATA: ls_error  TYPE ty_error,
        lt_fldcat TYPE STANDARD TABLE OF slis_fieldcat_alv,
        ls_fldcat TYPE slis_fieldcat_alv.


  CLEAR ls_error.
  DESCRIBE TABLE gt_file LINES lv_cnt.
  WRITE lv_cnt TO ls_error-messg LEFT-JUSTIFIED.
  CONCATENATE 'No. of records read from file: '
    ls_error-messg
    INTO ls_error-messg SEPARATED BY space.
  APPEND ls_error TO gt_error.

  CLEAR ls_error.
  WRITE gv_error TO ls_error-messg LEFT-JUSTIFIED.
  CONCATENATE 'Number of error records : '
    ls_error-messg
    INTO ls_error-messg SEPARATED BY space.
  APPEND ls_error TO gt_error.

  CLEAR ls_error.
  CONCATENATE 'Source File:'   p_file
    INTO ls_error-messg
    SEPARATED BY space .
  APPEND ls_error TO gt_error.


  REFRESH: lt_fldcat.

  CLEAR  ls_fldcat.
  ls_fldcat-fieldname  = 'MATNR'.
  ls_fldcat-tabname    = 'GT_ERROR'.
  ls_fldcat-seltext_l  = 'Material'.
  ls_fldcat-seltext_m  = 'Material'.
  ls_fldcat-seltext_s  = 'Material'.
  ls_fldcat-outputlen  = '000018'.
  APPEND ls_fldcat TO lt_fldcat.

  CLEAR  ls_fldcat.
  ls_fldcat-fieldname  = 'MESSG'.
  ls_fldcat-tabname    = 'GT_ERROR'.
  ls_fldcat-seltext_l  = ' Message'.
  ls_fldcat-outputlen  = '000070'.
  APPEND ls_fldcat TO lt_fldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     is_layout   = gwa_layout_col
      it_fieldcat = lt_fldcat
    TABLES
      t_outtab    = gt_error.

ENDFORM.
