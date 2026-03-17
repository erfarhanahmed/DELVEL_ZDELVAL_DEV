report ZMM02_REVI_PROGRAM
       no standard page heading line-size 255.

"include bdcrecx1.
TABLES : sscrfields.

TYPES  : BEGIN OF t_done,
           MATNR TYPE MARA-MATNR, "info type
         END OF t_done.

DATA : gt_done TYPE STANDARD TABLE OF t_done,
       gs_done TYPE t_done.

TYPES  : BEGIN OF t_error,
           MATNR TYPE MARA-MATNR, "info type
         END OF t_error.

DATA : gt_error TYPE STANDARD TABLE OF t_error,
       gs_error TYPE t_error.

TYPES : BEGIN OF ty_data,

        matnr TYPE char20,

        ZEINR TYPE char50,
        ZEIVR TYPE char20,
         maktx TYPE char20,
        msg TYPE string,
        END OF ty_data.

data : raw_table type TRUXS_T_TEXT_DATA.

 data :itab type standard table of ty_data,
       wa_tab type ty_data.

 data : gv_file type RLGRAP-FILENAME.

data : messtab like bdcmsgcoll occurs 0 WITH HEADER LINE,
       lv_buffer(4096) TYPE c OCCURS 0.
       " tt_bdcmsgcall   TYPE STANDARD TABLE OF bdcmsgcoll.
data : it_bdcdata type STANDARD TABLE OF BDCDATa,
       wa_bdcdata type BDCDATA.


SELECTION-SCREEN SKIP.


 PARAMETERS : p_file type IBIPPARMS-path,
              p_mode type char1 OBLIGATORY
             DEFAULT 'E'.
SELECTION-SCREEN SKIP.

SELECTION-SCREEN : BEGIN OF LINE.
  SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN : END OF LINE.


INITIALIZATION.
W_BUTTON = 'Download excel Template'.
AT SELECTION-SCREEN.
IF SSCRFIELDS-UCOMM EQ 'BUT1'.
    SUBMIT ZBDC_UPLOAD_1 VIA SELECTION-SCREEN AND RETURN.
 ENDIF.

at SELECTION-SCREEN on VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
   EXPORTING
     PROGRAM_NAME        = SYST-CPROG
     DYNPRO_NUMBER       = SYST-DYNNR
*     FIELD_NAME          = ' '
   IMPORTING
     FILE_NAME           = p_file.
            .
 start-of-selection.
 clear: gv_file, itab[].
       gv_file = p_file.

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
   I_FIELD_SEPERATOR          = 'X'
   I_LINE_HEADER              = 'X'
    i_tab_raw_data            = raw_table
    i_filename                = gv_file
  TABLES
    i_tab_converted_data       = itab
 EXCEPTIONS
   CONVERSION_FAILED          = 1
   OTHERS                     = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
*perform open_dataset using dataset.
"
"perform open_group.
"BREAK-POINT.
loop at itab into wa_tab.
  refresh it_bdcdata.
perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR'
                              wa_tab-matnr."'47'.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(02)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(01)'
                              'X'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(02)'
                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '4004'.
perform bdc_field       using 'BDC_OKCODE'
                              '=SP02'.
perform bdc_field       using 'BDC_CURSOR'
                              'MAKT-MAKTX'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              'FG - Butterfly Valve'.
*perform bdc_field       using 'MARA-ITEM_TYPE'
*                              'A'.
*perform bdc_field       using 'MARA-MEINS'
*                              'EA'.
*perform bdc_field       using 'MARA-MATKL'
*                              '0043'.
*perform bdc_field       using 'MARA-MTPOS_MARA'
*                              'NORM'.
*perform bdc_field       using 'MARA-BRGEW'
*                              '25'.
*perform bdc_field       using 'MARA-GEWEI'
*                              'KG'.
*perform bdc_field       using 'MARA-NTGEW'
*                              '22'.
perform bdc_dynpro      using 'SAPLMGMM' '4004'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              'FG - Butterfly Valve'.
perform bdc_field       using 'BDC_CURSOR'
                              'MARA-ZEIVR'.
perform bdc_field       using 'MARA-ZEINR'
                               wa_tab-zeinr."'1223456677'.
perform bdc_field       using 'MARA-ZEIVR'
                               wa_tab-zeivr."'12'.
perform bdc_dynpro      using 'SAPLSPO1' '0300'.
perform bdc_field       using 'BDC_OKCODE'
                              '=YES'.
"perform bdc_transaction using 'MM02'.

"perform close_group.
call TRANSACTION 'MM02' USING it_BDCDATA MODE p_mode
                        UPDATE 'E' MESSAGES INTO messtab.


"BREAK-POINT.
    IF sy-msgv1 IS NOT INITIAL AND ( sy-msgty = 'S' OR sy-msgty = 'W' ).
      gs_done-MATNR = sy-msgv1.

      APPEND gs_done TO gt_done.
    ELSE .

      gs_error-MATNR = wa_tab-matnr.
      APPEND gs_error TO gt_error.
    ENDIF.
*if messtab[] is NOT INITIAL.
*
*loop at messtab.
*
*CALL FUNCTION 'MESSAGE_TEXT_BUILD'
*  EXPORTING
*   msgid                      = messtab-msgid
*   msgnr                      = messtab-msgnr
*   MSGV1                      = messtab-msgv1
*   MSGV2                      = messtab-msgv2
*   MSGV3                      = messtab-msgv3
*   MSGV4                      = messtab-msgv4
* IMPORTING
*   MESSAGE_TEXT_OUTPUT       = wa_tab-msg.
*
*          MODIFY itab from wa_tab TRANSPORTING msg.
*
*exit.
*ENDLOOP.
*ENDIF.
*
*CLEAR wa_tab.

ENDLOOP.
WRITE /  'SUCESSFULLY CHANGE MATERIAL'.
  LOOP AT gt_done INTO gs_done.
    WRITE / gs_done-MATNR .
  ENDLOOP.

  WRITE /  'ERROR WHILE CHANGING MATERIAL '.
  LOOP AT gt_error INTO gs_error.
    WRITE / gs_error-MATNR .
    CLEAR WA_TAB."gs_final.
  ENDLOOP.

FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR wa_BDCDATA.
  wa_BDCDATA-PROGRAM  = PROGRAM.
  wa_BDCDATA-DYNPRO   = DYNPRO.
  wa_BDCDATA-DYNBEGIN = 'X'.
  APPEND wa_bdcdata to it_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
  IF FVAL <> space. "NODATA.
    CLEAR wa_BDCDATA.
    wa_BDCDATA-FNAM = FNAM.
    wa_BDCDATA-FVAL = FVAL.
    APPEND wa_BDCDATA to it_bdcdata.
  ENDIF.
ENDFORM.
