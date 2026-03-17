*&---------------------------------------------------------------------*
*& Report ZMM_J1ID_EXCISE_MASTER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_J1ID_EXCISE_MASTER.


TABLES : sscrfields.
types: BEGIN OF ty_final,
  hsn_code  TYPE string,
  hsn_uom   type string,
  hsn_desc1 TYPE string,
  hsn_desc2 TYPE string,
  hsn_desc3 TYPE string,
  hsn_desc4 TYPE string,
  hsn_desc5 TYPE string,
  hsn_desc6 TYPE string,
  hsn_desc7 TYPE string,
  hsn_desc8 TYPE string,
END OF ty_final.

DATA: lt_final TYPE STANDARD TABLE OF ty_final,
      ls_final TYPE ty_final,
      lt_bdcdata TYPE STANDARD TABLE OF bdcdata WITH HEADER LINE,
      lt_bdcmsgcoll TYPE STANDARD TABLE OF bdcmsgcoll WITH HEADER LINE .
TYPES: trux_t_text_data(4096) TYPE c OCCURS 0.
DATA : it_raw TYPE trux_t_text_data.
DATA : cnt(3)        TYPE n,
       v_message(50).
SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
 PARAMETERS: P_FILE LIKE RLGRAP-FILENAME,
             MODE LIKE CTU_PARAMS-DISMODE DEFAULT 'N'.
SELECTION-SCREEN:END OF BLOCK B1.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = P_FILE.


START-OF-SELECTION.
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = it_raw
      i_filename           = P_FILE
    TABLES
      i_tab_converted_data = lt_final[]
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*include bdcrecx1_s.
*perform open_group.
LOOP AT lt_final INTO ls_final.
    REFRESH : lt_bdcdata[],lt_bdcmsgcoll[].

perform bdc_dynpro      using 'SAPMJ1ID' '0200'.
perform bdc_field       using 'BDC_CURSOR'
                              'RB11'.
perform bdc_field       using 'BDC_OKCODE'
                              '=EX'.
perform bdc_field       using 'RB11'
                              'X'.
perform bdc_dynpro      using 'SAPLJ1I0' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'J_1IVCHID-J_1ICHT1(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=NEWL'.
perform bdc_dynpro      using 'SAPLJ1I0' '0150'.
perform bdc_field       using 'BDC_CURSOR'
                              'J_1IVCHID-J_1ICHT1'.
perform bdc_field       using 'BDC_OKCODE'
                              '=SAVE'.
perform bdc_field       using 'J_1IVCHID-J_1ICHID'
                              ls_final-hsn_code.          "'39172990'.
perform bdc_field       using 'J_1IVCHID-J_1ICHUM'
                              ls_final-hsn_uom .          "'EA'.
perform bdc_field       using 'J_1IVCHID-J_1ICHT1'
                              ls_final-hsn_desc1.          "'HSN Codde'.
perform bdc_field       using 'J_1IVCHID-J_1ICHT2'
                              ls_final-hsn_desc2.
perform bdc_field       using 'J_1IVCHID-J_1ICHT3'
                              ls_final-hsn_desc3.
perform bdc_field       using 'J_1IVCHID-J_1ICHT4'
                              ls_final-hsn_desc4.
perform bdc_field       using 'J_1IVCHID-J_1ICHT5'
                              ls_final-hsn_desc5.
perform bdc_field       using 'J_1IVCHID-J_1ICHT6'
                              ls_final-hsn_desc6.
perform bdc_field       using 'J_1IVCHID-J_1ICHT7'
                              ls_final-hsn_desc7.
perform bdc_field       using 'J_1IVCHID-J_1ICHT8'
                              ls_final-hsn_desc8.
perform bdc_dynpro      using 'SAPLJ1I0' '0150'.
perform bdc_field       using 'BDC_CURSOR'
                              'J_1IVCHID-J_1ICHUM'.
perform bdc_field       using 'BDC_OKCODE'
                              '=UEBE'.
perform bdc_field       using 'J_1IVCHID-J_1ICHT1'
                              ls_final-hsn_desc1.          "'HSN Codde'.
perform bdc_field       using 'J_1IVCHID-J_1ICHT2'
                              ls_final-hsn_desc2.
perform bdc_field       using 'J_1IVCHID-J_1ICHT3'
                              ls_final-hsn_desc3.
perform bdc_field       using 'J_1IVCHID-J_1ICHT4'
                              ls_final-hsn_desc4.
perform bdc_field       using 'J_1IVCHID-J_1ICHT5'
                              ls_final-hsn_desc5.
perform bdc_field       using 'J_1IVCHID-J_1ICHT6'
                              ls_final-hsn_desc6.
perform bdc_field       using 'J_1IVCHID-J_1ICHT7'
                              ls_final-hsn_desc7.
perform bdc_field       using 'J_1IVCHID-J_1ICHT8'
                              ls_final-hsn_desc8.
perform bdc_dynpro      using 'SAPLJ1I0' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'J_1IVCHID-J_1ICHT1(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BACK'.
perform bdc_dynpro      using 'SAPMJ1ID' '0200'.
perform bdc_field       using 'BDC_OKCODE'
                              '/EEXIT'.
perform bdc_field       using 'BDC_CURSOR'
                              'EXCISE'.
*perform bdc_transaction using 'J1ID'.

CALL TRANSACTION 'J1ID' USING LT_BDCDATA
                         MODE MODE
                         UPDATE 'S'
                         MESSAGES INTO LT_BDCMSGCOLL.

    LOOP AT lt_bdcmsgcoll.

      CALL FUNCTION 'FORMAT_MESSAGE'                  "Formatting a T100 message
        EXPORTING
          id        = lt_bdcmsgcoll-msgid
          lang      = sy-langu
          no        = lt_bdcmsgcoll-msgnr
          v1        = lt_bdcmsgcoll-msgv1
          v2        = lt_bdcmsgcoll-msgv2
          v3        = lt_bdcmsgcoll-msgv3
          v4        = lt_bdcmsgcoll-msgv4
        IMPORTING
          msg       = v_message
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF lt_bdcmsgcoll-msgv1 IS NOT INITIAL AND lt_bdcmsgcoll-msgtyp = 'S'.
        WRITE:/ v_message.
      ENDIF.
      IF  lt_bdcmsgcoll-msgtyp = 'E'.
        WRITE:/ v_message ,' Error in Count'.
      ENDIF.
      CLEAR :cnt,v_message.
    ENDLOOP.

endloop.

*perform close_group.

FORM bdc_dynpro USING program dynpro.
  CLEAR lt_bdcdata.
  lt_bdcdata-program   = program.
  lt_bdcdata-dynpro    = dynpro.
  lt_bdcdata-dynbegin  = 'X'.
  APPEND lt_bdcdata.
ENDFORM.

FORM bdc_field USING fnam fval.
  IF fval <> space.
    CLEAR lt_bdcdata.
    lt_bdcdata-fnam = fnam.
    lt_bdcdata-fval = fval.
    APPEND lt_bdcdata.
  ENDIF.

ENDFORM.
