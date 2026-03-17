REPORT zmmb_xk02
       NO STANDARD PAGE HEADING LINE-SIZE 255.

*INCLUDE bdcrecx1.
*-----------------------------------------------------------------*
* Data Decleration                                                *
*-----------------------------------------------------------------*
TABLES: t100.
TABLES sscrfields.

TYPES: BEGIN OF ty_data,
        lifnr  TYPE string,
        bukrs  TYPE string,
        stcd3  TYPE string,
        vclass TYPE string,
       END OF ty_data.

DATA: lt_data TYPE STANDARD TABLE OF ty_data,
      ls_data TYPE ty_data.

DATA: BEGIN OF bdcdata OCCURS 100.
        INCLUDE STRUCTURE bdcdata.
DATA: END OF bdcdata.

DATA: BEGIN OF messtab OCCURS 50.
        INCLUDE STRUCTURE bdcmsgcoll.
DATA: END OF messtab.

DATA: l_mstring(480).
*-----------------------------------------------------------------*
* Selection Screen                                                *
*-----------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS : p_file LIKE rlgrap-filename. "OBLIGATORY.
PARAMETERS : p_mode LIKE ibipparms-callmode OBLIGATORY DEFAULT 'A'.
"A: show all dynpros
"E: show dynpro on error only
"N: do not display dynpro
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN FUNCTION KEY 1.
INITIALIZATION.
  MOVE 'Excel' TO sscrfields-functxt_01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM get_filename.

AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'FC01'.
    SUBMIT zmmr_xk02_excel_upload.
  ENDIF.

*-----------------------------------------------------------------*
* Start of Selection                                              *
*-----------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM upload_data.

*  PERFORM open_group.
  LOOP AT lt_data INTO ls_data.
    CLEAR: bdcdata.
    REFRESH: bdcdata.

    PERFORM bdc_dynpro      USING 'SAPMF02K' '0101'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RF02K-BUKRS'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'RF02K-LIFNR'
                                  ls_data-lifnr.            "'702100'.
    PERFORM bdc_field       USING 'RF02K-BUKRS'
                                  ls_data-bukrs.        "'tf01'.
    PERFORM bdc_field       USING 'RF02K-D0120'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPMF02K' '0120'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'LFA1-STCD3'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=OPFI'.
*  PERFORM bdc_field       USING 'LFA1-STCD2'
*                                'AKPPM8912K'.
    PERFORM bdc_field       USING 'LFA1-STCD3'
                                  ls_data-stcd3.        "'27AKPPM8912KZ01'.
*  PERFORM bdc_field       USING 'LFA1-STCEG'
*                                '27720370771V'.
    PERFORM bdc_dynpro      USING 'SAPLJ1I_MASTER' '0100'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=CIN_VENDOR_FC5'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'J_1IMOVEND-J_1IEXCD'.
*  PERFORM bdc_field       USING 'J_1IMOVEND-J_1IEXCD'
*                                'AKPPM8911KEM002'.
*  PERFORM bdc_field       USING 'J_1IMOVEND-J_1IEXRN'
*                                'NA'.
*  PERFORM bdc_field       USING 'J_1IMOVEND-J_1IEXRG'
*                                'BHOSARI V'.
*  PERFORM bdc_field       USING 'J_1IMOVEND-J_1IEXDI'
*                                'PUNE V'.
*  PERFORM bdc_field       USING 'J_1IMOVEND-J_1IEXCO'
*                                'NA'.
*  PERFORM bdc_field       USING 'J_1IMOVEND-J_1IVTYP'
*                                'M'.
*  PERFORM bdc_field       USING 'J_1IMOVEND-J_1IEXCIVE'
*                                '1'.
*  PERFORM bdc_field       USING 'J_1IMOVEND-J_1ISSIST'
*                                '1'.
    PERFORM bdc_dynpro      USING 'SAPLJ1I_MASTER' '0100'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BACK'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'J_1IMOVEND-VEN_CLASS'.
    PERFORM bdc_field       USING 'J_1IMOVEND-VEN_CLASS'
                                  ls_data-vclass.                  "'1'.
    PERFORM bdc_dynpro      USING 'SAPMF02K' '0120'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'LFA1-KUNNR'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=UPDA'.
*  PERFORM bdc_field       USING 'LFA1-STCD2'
*                                'AKPPM8912K'.
*  PERFORM bdc_field       USING 'LFA1-STCD3'
*                                '27AKPPM8912KZ01'.
*  PERFORM bdc_field       USING 'LFA1-STCEG'
*                                '27720370771V'.
*  PERFORM bdc_transaction USING 'XK02'.
    CALL TRANSACTION 'XK02' USING bdcdata
                                 MODE p_mode
                                 UPDATE 'S'
                                 MESSAGES INTO messtab.
    CLEAR: ls_data.
  ENDLOOP.

*  PERFORM close_group.
  IF NOT messtab[] IS INITIAL.
    LOOP AT messtab WHERE msgtyp EQ 'E' .
      SELECT  SINGLE text  FROM t100 INTO t100-text
*          for all entries in messtab
      WHERE sprsl = messtab-msgspra
      AND   arbgb = messtab-msgid
      AND   msgnr = messtab-msgnr.

      IF sy-subrc = 0.
        l_mstring = t100-text.
        IF l_mstring CS '&1'.
          REPLACE '&1' WITH messtab-msgv1 INTO l_mstring.
          REPLACE '&2' WITH messtab-msgv2 INTO l_mstring.
          REPLACE '&3' WITH messtab-msgv3 INTO l_mstring.
          REPLACE '&4' WITH messtab-msgv4 INTO l_mstring.
        ELSE.
          REPLACE '&' WITH messtab-msgv1 INTO l_mstring.
          REPLACE '&' WITH messtab-msgv2 INTO l_mstring.
          REPLACE '&' WITH messtab-msgv3 INTO l_mstring.
          REPLACE '&' WITH messtab-msgv4 INTO l_mstring.
        ENDIF.
        CONDENSE l_mstring.
      ENDIF.
      WRITE: 'Message :' ,  l_mstring.
    ENDLOOP.
  ENDIF.

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.

  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.

ENDFORM.                    "BDC_FIELD
*&---------------------------------------------------------------------*
*&      Form  GET_FILENAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_filename .
  CALL FUNCTION 'F4_FILENAME'
* EXPORTING
*   PROGRAM_NAME        = SYST-CPROG
*   DYNPRO_NUMBER       = SYST-DYNNR
*   FIELD_NAME          = ' '
 IMPORTING
   file_name           =  p_file.

ENDFORM.                    " GET_FILENAME
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM upload_data .
  TYPE-POOLS: truxs.

  DATA: lt_raw TYPE truxs_t_text_data.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = lt_raw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = lt_data
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " UPLOAD_DATA
