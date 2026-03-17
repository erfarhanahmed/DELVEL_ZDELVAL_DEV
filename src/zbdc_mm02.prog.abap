report ZBDC_MM02
       no standard page heading line-size 255.

TABLES : sscrfields.

TYPES  : BEGIN OF t_error,
           infnr TYPE eina-infnr, "info type
         END OF t_error.

DATA : gt_error TYPE STANDARD TABLE OF t_error,
       gs_error TYPE t_error.

DATA : lt_bdcdata TYPE TABLE OF bdcdata WITH HEADER LINE, "BDCDATA
       ls_bdcdata LIKE lt_bdcdata . "work area BDCDATA

DATA : lt_MSG TYPE STANDARD TABLE OF BDCMSGCOLL WITH HEADER LINE,
       ls_msg TYPE bdcmsgcoll.

DATA : V_MSG(255) TYPE C.

DATA : w_msg1(51).

DATA : LV_MSG TYPE STRING.

TYPES : BEGIN OF ty_MARA,
          MATNR         TYPE MARA-MATNR,
          ITEM_TYPE     TYPE MARA-ITEM_TYPE,
          AIR_PRESSURE  TYPE MARA-AIR_PRESSURE,
          AIR_FAIL      TYPE MARA-AIR_FAIL    ,
          ACTUATOR      TYPE MARA-ACTUATOR    ,
**          VERTICAL      TYPE MARA-VERTICAL    ,
        END OF ty_MARA.

DATA : lt_MARA TYPE TABLE OF ty_MARA,
       ls_MARA TYPE ty_MARA.

data :v_str TYPE string,
       v_bool  TYPE c.

DATA : WA_MARA TYPE MARA.

TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.
DATA : rawdata TYPE truxs_t_text_data.

INITIALIZATION.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_file TYPE rlgrap-filename.
PARAMETERS : ctu_mode LIKE ctu_params-dismode OBLIGATORY DEFAULT 'N'.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.

start-of-selection.

 v_str = p_file .

  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file   = v_str
    RECEIVING
      result = v_bool.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
        i_line_header        = 'X'
        i_tab_raw_data       = rawdata
        i_filename           = p_file
      TABLES
        i_tab_converted_data = lt_mara
* EXCEPTIONS
*       CONVERSION_FAILED    = 1
*       OTHERS               = 2
      .
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

REFRESH lt_bdcdata.
PERFORM bdc.

*&---------------------------------------------------------------------*
*&      Form  BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bdc .

LOOP AT LT_MARA INTO LS_MARA.
  refresh : lt_bdcdata, lt_bdcdata.

perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR'
                              LS_MARA-MATNR."'28G12000104EBSW1'.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(01)'
                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '4004'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BU'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              '18,GEAR,10000NM,IP65,STD,DIA 40 K12X10'
*                            & ',F'.
*perform bdc_field       using 'BDC_CURSOR'
*                              'MARA-VERTICAL'.

IF LS_MARA-MATNR IS NOT INITIAL.

  SELECT SINGLE * FROM MARA INTO WA_MARA WHERE MATNR = LS_MARA-MATNR.

 IF WA_MARA-ITEM_TYPE IS INITIAL.
perform bdc_field       using 'MARA-ITEM_TYPE'
                              LS_MARA-ITEM_TYPE."'P'.
ENDIF.
  IF WA_MARA-AIR_PRESSURE IS INITIAL.
perform bdc_field       using 'MARA-AIR_PRESSURE'
                              LS_MARA-AIR_PRESSURE."'1111'.
endif.
IF WA_MARA-AIR_FAIL IS INITIAL.
perform bdc_field       using 'MARA-AIR_FAIL'
                              LS_MARA-AIR_FAIL."'YES'.
endif.
IF WA_MARA-ACTUATOR IS INITIAL.
perform bdc_field       using 'MARA-ACTUATOR'
                              LS_MARA-ACTUATOR."'123456789'.
endif.
*IF WA_MARA-VERTICAL IS INITIAL.
*perform bdc_field       using 'MARA-VERTICAL'
*                              LS_MARA-VERTICAL."'123456789999'.
*ENDIF.
endif.
*perform bdc_field       using 'MARA-MEINS'
*                              'NOS'.
*perform bdc_field       using 'MARA-MATKL'
*                              '0036'.
*perform bdc_field       using 'MARA-GEWEI'
*                              'KG'.
*perform bdc_field       using 'DESC_LANGU_GDTXT'
*
 CALL TRANSACTION 'MM02' USING lt_bdcdata "call transaction
        MODE ctu_mode"'E'
        UPDATE 'S'
        MESSAGES INTO lt_msg."lt_msg. "messages                           'E'.

  LOOP AT lt_MSG INTO ls_msg.
*  IF SY-SUBRC = 0.
    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        ID        = ls_MSG-MSGID
        LANG      = sy-langu
        NO        = ls_MSG-MSGNR
        V1        = ls_MSG-MSGV1
        V2        = ls_MSG-MSGV2
        V3        = ls_MSG-MSGV3
        V4        = ls_MSG-MSGV4
      IMPORTING
        MSG       = V_MSG
      EXCEPTIONS
        NOT_FOUND = 1
        OTHERS    = 2.

      IF ls_msg-msgtyp = 'S' and ls_msg-msgid = 'M3' and ls_msg-msgnr = '801'.
        CONCATENATE ls_mara-matnr '-' v_msg INTO lv_msg SEPARATED BY space.
        WRITE:/ lv_msg.

      ELSEIF ls_msg-msgtyp = 'E'.
        WRITE:/ v_msg.
      ENDIF.

     ENDLOOP.

REFRESH lt_msg[].
CLEAR : ls_mara.

ENDLOOP.

*IF sy-subrc = 0.
*     MESSAGE 'Data has been uploaded successfully.' TYPE 'I'.
*ENDIF.

ENDFORM.

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR lt_bdcdata.
  lt_bdcdata-program  = program.
  lt_bdcdata-dynpro   = dynpro.
  lt_bdcdata-dynbegin = 'X'.
  APPEND lt_bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF fval <> space.
    CLEAR lt_bdcdata.
    lt_bdcdata-fnam = fnam.
    lt_bdcdata-fval = fval.
*    SHIFT lt_bdcdata-fval LEFT DELETING LEADING space.
    APPEND lt_bdcdata.
*  ENDIF.
ENDFORM.
