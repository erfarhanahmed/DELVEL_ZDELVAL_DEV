REPORT zsdb_xd02
       NO STANDARD PAGE HEADING LINE-SIZE 255.

*include bdcrecx1.
*-----------------------------------------------------------------*
* Data Decleration                                                *
*-----------------------------------------------------------------*
TABLES: t100, sscrfields.

TYPES: BEGIN OF ty_data,
        kunnr  TYPE string,
        bukrs  TYPE string,
        vkorg  TYPE string,
        vtweg  TYPE string,
        spart  TYPE string,

        stcd3  TYPE string,
        taxkd1 TYPE string,
        taxkd2 TYPE string,
        taxkd3 TYPE string,
        taxkd4 TYPE string,
        taxkd5 TYPE string,
        taxkd6 TYPE string,
        taxkd7 TYPE string,
        taxkd8 TYPE string,
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
PARAMETERS : p_file LIKE rlgrap-filename.
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
    SUBMIT zsdr_xd02_excel_upload.
  ENDIF.

*-----------------------------------------------------------------*
* Start of Selection                                              *
*-----------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM upload_data.

*perform open_group.
  LOOP AT lt_data INTO ls_data.
    CLEAR: bdcdata.
    REFRESH: bdcdata.

    PERFORM bdc_dynpro      USING 'SAPMF02D' '0101'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RF02D-D0320'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'RF02D-KUNNR'
                                  ls_data-kunnr.            "'60056'.
    PERFORM bdc_field       USING 'RF02D-BUKRS'
                                  ls_data-bukrs.          "'tf01'.
    PERFORM bdc_field       USING 'RF02D-VKORG'
                                  ls_data-vkorg.          "'1000'.
    PERFORM bdc_field       USING 'RF02D-VTWEG'
                                  ls_data-vtweg.          "'10'.
    PERFORM bdc_field       USING 'RF02D-SPART'
                                  ls_data-spart.          "'10'.
    PERFORM bdc_field       USING 'RF02D-D0120'
                                  'X'.
    PERFORM bdc_field       USING 'RF02D-D0320'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPMF02D' '0120'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KNA1-LIFNR'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=VW'.
*    PERFORM bdc_field       USING 'KNA1-KONZS'
*                                  'FIAT'.
*    PERFORM bdc_field       USING 'KNA1-STCD2'
*                                  '12345566666'.
    PERFORM bdc_field       USING 'KNA1-STCD3'
                                  ls_data-stcd3.          "'TEST1'.
    PERFORM bdc_dynpro      USING 'SAPMF02D' '0320'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KNVV-PERFK'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=VW'.
*    PERFORM bdc_field       USING 'KNVV-INCO1'
*                                  'EXW'.
*    PERFORM bdc_field       USING 'KNVV-INCO2'
*                                  'RANJANGAON'.
*    PERFORM bdc_field       USING 'KNVV-ZTERM'
*                                  'AR04'.
*    PERFORM bdc_field       USING 'KNVV-KTGRD'
*                                  '01'.
    PERFORM bdc_dynpro      USING 'SAPMF02D' '1350'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KNVI-TAXKD(08)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=UPDA'.
    PERFORM bdc_field       USING 'KNVI-TAXKD(01)'
                                  ls_data-taxkd1.         "'0'.
    PERFORM bdc_field       USING 'KNVI-TAXKD(02)'
                                  ls_data-taxkd2.         "'0'.
    PERFORM bdc_field       USING 'KNVI-TAXKD(03)'
                                  ls_data-taxkd3.         "'0'.
    PERFORM bdc_field       USING 'KNVI-TAXKD(04)'
                                  ls_data-taxkd4.         "'0'.
    PERFORM bdc_field       USING 'KNVI-TAXKD(05)'
                                  ls_data-taxkd5.         "'1'.
    PERFORM bdc_field       USING 'KNVI-TAXKD(06)'
                                  ls_data-taxkd6.         "'1'.
*    PERFORM bdc_field       USING 'KNVI-TAXKD(07)'
*                                  ls_data-taxkd7.         "'1'.
*    PERFORM bdc_field       USING 'KNVI-TAXKD(08)'
*                                  ls_data-taxkd8.         "'1'.
*  PERFORM bdc_transaction USING 'XD02'.
    CALL TRANSACTION 'XD02' USING bdcdata
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
