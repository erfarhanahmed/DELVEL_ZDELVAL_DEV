REPORT zme12_bdc12
       NO STANDARD PAGE HEADING LINE-SIZE 255.

*include bdcrecx1.

*start-of-selection.

*perform open_group.
TABLES : sscrfields.
*INCLUDE bdcrecx1.

TYPES : BEGIN OF ty_eine,
          lifnr TYPE eina-lifnr,
          matnr TYPE eina-matnr,
          ekorg TYPE eine-ekorg,
          werks TYPE eine-werks,
          infnr TYPE eine-infnr,
          minbm TYPE string,
        END OF ty_eine.

TYPES  : BEGIN OF t_done,
           infnr TYPE eina-infnr, "info type
         END OF t_done.

DATA : gt_done TYPE STANDARD TABLE OF t_done,
       gs_done TYPE t_done.

TYPES  : BEGIN OF t_error,
           infnr TYPE eina-infnr, "info type
         END OF t_error.

DATA : gt_error TYPE STANDARD TABLE OF t_error,
       gs_error TYPE t_error.

DATA : lt_eine TYPE STANDARD TABLE OF ty_eine WITH HEADER LINE,
       ls_eine LIKE lt_eine.

DATA : bdcdata    TYPE TABLE OF bdcdata WITH HEADER LINE, "BDCDATA
       ls_bdcdata LIKE bdcdata . "work area BDCDATA

DATA : lt_msg     TYPE TABLE OF bdcmsgcoll,   " Collecting Error messages
       ls_msg     TYPE bdcmsgcoll,
       w_msg1(51).

*DATA : lt_bdcdata TYPE TABLE OF bdcdata WITH HEADER LINE, "BDCDATA
*       ls_bdcdata LIKE lt_bdcdata . "work area BDCDATA

*DATA : lt_msg     TYPE TABLE OF bdcmsgcoll,   " Collecting Error messages
**       ls_msg     TYPE bdcmsgcoll,
*       w_msg1(51).

TYPES :  fs_struct(4096) TYPE c OCCURS 0.

DATA: w_struct TYPE fs_struct.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_file TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.

START-OF-SELECTION.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = w_struct
      i_filename           = p_file
    TABLES
      i_tab_converted_data = lt_eine
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*  BREAK-POINT.
*perform open_group.
  CLEAR ls_eine.
  LOOP AT lt_eine INTO ls_eine .

    REFRESH bdcdata.
* REFRESH BDCDATA.
    CLEAR bdcdata.


    PERFORM bdc_dynpro      USING 'SAPMM06I' '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RM06I-NORMB'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'EINA-LIFNR'
                                  ls_eine-lifnr. "'100000'.
    PERFORM bdc_field       USING 'EINA-MATNR'
                                  ls_eine-matnr. "'BOLT'.
    PERFORM bdc_field       USING 'EINE-EKORG'
                                  ls_eine-ekorg. "'1000'.
    PERFORM bdc_field       USING 'EINE-WERKS'
                                  ls_eine-werks. "'pl01'.
    PERFORM bdc_field       USING 'EINA-INFNR'
                                  ls_eine-infnr. "'5300000003'.
    PERFORM bdc_field       USING 'RM06I-NORMB'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPMM06I' '0101'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'EINA-IDNLF'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=EINE'.
*    PERFORM bdc_field       USING 'EINA-MAHN1'
*                                  '10'.
*    PERFORM bdc_field       USING 'EINA-MAHN2'
*                                  '20'.
*    PERFORM bdc_field       USING 'EINA-MAHN3'
*                                  '30'.
*    PERFORM bdc_field       USING 'EINA-IDNLF'
*                                  'DF'.
*    PERFORM bdc_field       USING 'EINA-MEINS'
*                                  'EA'.
*    PERFORM bdc_field       USING 'EINA-UMREZ'
*                                  '1'.
*    PERFORM bdc_field       USING 'EINA-UMREN'
*                                  '1'.
    PERFORM bdc_dynpro      USING 'SAPMM06I' '0102'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'EINE-MINBM'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BU'.
*    PERFORM bdc_field       USING 'EINE-APLFZ'
*                                  '1'.
*    PERFORM bdc_field       USING 'EINE-EKGRP'
*                                  '101'.
*    PERFORM bdc_field       USING 'EINE-NORBM'
*                                  '300'.
    PERFORM bdc_field       USING 'EINE-MINBM'
                                  ls_eine-minbm. "'25'.
*    PERFORM bdc_field       USING 'EINE-WEBRE'
*                                  'X'.
*    PERFORM bdc_field       USING 'EINE-MWSKZ'
*                                  'V1'.
*    PERFORM bdc_field       USING 'EINE-IPRKZ'
*                                  'D'.
*perform bdc_transaction using 'ME12'.

*perform close_group.
  CALL TRANSACTION 'ME12' USING bdcdata "call transaction
        MODE 'N' "N-no screen mode, A-all screen mode, E-error screen mode
        UPDATE 'A' "A-assynchronous, S-synchronous
        MESSAGES INTO lt_msg. "messages



  IF sy-subrc EQ 0.
*    Uploaded into the database
    WRITE :/ 'DATA UPLOADED IN TABLE EINE...' .
  ELSE.
*    Error Found
    LOOP AT lt_msg INTO ls_msg." WHERE msgtyp EQ 'E'.
*     Format Message
      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
      EXPORTING
        msgid               = ls_msg-msgid
        msgnr               = ls_msg-msgnr
        msgv1               = ls_msg-msgv1
        msgv2               = ls_msg-msgv2
        msgv3               = ls_msg-msgv3
        msgv4               = ls_msg-msgv4
      IMPORTING
        message_text_output = w_msg1.


      WRITE :/ w_msg1.
*  CLEAR LT
      CLEAR w_msg1.
    ENDLOOP.
  ENDIF.
  CLEAR ls_eine.
ENDLOOP.
*    IF sy-msgv1 IS NOT INITIAL AND ( sy-msgty = 'S' OR sy-msgty = 'W' ).
*      gs_done-infnr = sy-msgv1.
*
*      APPEND gs_done TO gt_done.
*    ELSE .
*
*      gs_error-infnr = ls_eine-infnr.
*      APPEND gs_error TO gt_error.
*    ENDIF.
*
*
*
*
*  WRITE /  'SUCESSFULLY CHANGE INFO RECORD '.
*  LOOP AT gt_done INTO gs_done.
*    WRITE / gs_done-infnr .
*  ENDLOOP.
*
*  WRITE /  'ERROR WHILE CHANGING INFO RECORD '.
*  LOOP AT gt_error INTO gs_error.
*    WRITE / gs_error-infnr .
*    CLEAR ls_eine.
*  ENDLOOP.


*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  IF fval <> space.
    CLEAR bdcdata.
    bdcdata-fnam = fnam.
    bdcdata-fval = fval.
    APPEND bdcdata.
  ENDIF.
ENDFORM.
