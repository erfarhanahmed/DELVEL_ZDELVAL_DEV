REPORT zme12_subcon_bdc12
       NO STANDARD PAGE HEADING LINE-SIZE 255.

*include bdcrecx1.

*start-of-selection.

*perform open_group.

TABLES : sscrfields.

TYPES : BEGIN OF ty_eine,
          lifnr TYPE eina-lifnr,
          matnr TYPE eina-matnr,
          ekorg TYPE eine-ekorg,
          werks TYPE eine-werks,
          infnr TYPE eine-infnr,
          minbm TYPE eine-minbm,
        END OF ty_eine.

DATA : lt_eine TYPE STANDARD TABLE OF ty_eine WITH HEADER LINE,
       ls_eine LIKE lt_eine.

DATA : bdcdata    TYPE TABLE OF bdcdata WITH HEADER LINE, "BDCDATA
       ls_bdcdata LIKE bdcdata . "work area BDCDATA

DATA : lt_msg     TYPE TABLE OF bdcmsgcoll,   " Collecting Error messages
       ls_msg     TYPE bdcmsgcoll,
       w_msg1(51).

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
      i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = w_struct
      i_filename           = p_file
    TABLES
      i_tab_converted_data = lt_eine
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

*  PERFORM open_group.
  CLEAR ls_eine.
  LOOP AT lt_eine INTO ls_eine .

    REFRESH bdcdata.
* REFRESH BDCDATA.
    CLEAR bdcdata.

    PERFORM bdc_dynpro      USING 'SAPMM06I' '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RM06I-LOHNB'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'EINA-LIFNR'
                                  ls_eine-lifnr. "'0000100001'.
    PERFORM bdc_field       USING 'EINA-MATNR'
                                  ls_eine-matnr. "'CASTING-A-101'.
    PERFORM bdc_field       USING 'EINE-EKORG'
                                  ls_eine-ekorg. "'1000'.
    PERFORM bdc_field       USING 'EINE-WERKS'
                                  ls_eine-werks. "'PL01'.
    PERFORM bdc_field       USING 'EINA-INFNR'
                                  ls_eine-infnr. "'5300000008'.
    PERFORM bdc_field       USING 'RM06I-LOHNB'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPMM06I' '0101'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'EINA-MAHN1'.
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
*                                  '1,000'.
    PERFORM bdc_field       USING 'EINE-MINBM'
                                  ls_eine-minbm. "'100'.
*    PERFORM bdc_field       USING 'EINE-WEBRE'
*                                  'X'.
*    PERFORM bdc_field       USING 'EINE-MWSKZ'
*                                  'V0'.
*    PERFORM bdc_field       USING 'EINE-IPRKZ'
*                                  'D'.
*    PERFORM bdc_transaction USING 'ME12'.

*    PERFORM close_group.

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
    SHIFT bdcdata-fval LEFT DELETING LEADING space.
    APPEND bdcdata.
  ENDIF.
ENDFORM.
