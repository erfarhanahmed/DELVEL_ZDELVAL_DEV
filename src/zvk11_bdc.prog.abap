report ZVK11_BDC
       no standard page heading line-size 255.
*INCLUDE bdcrecx1.
*-----------------------------------------------------------------*
* Data Decleration                                                *
*-----------------------------------------------------------------*
TABLES: t100.
TABLES sscrfields.
************************************************************************************************************
"TYPES
************************************************************************************************************

TYPE-POOLS slis .


TYPES : BEGIN OF TY_MARA,
        MATNR TYPE MARA-MATNR,
        MTART TYPE MARA-MTART,
        END OF TY_MARA,

        BEGIN OF TY_MVKE,
        MATNR TYPE MVKE-MATNR,
        VKORG TYPE MVKE-VKORG,
        VTWEG TYPE MVKE-VTWEG,
        END OF TY_MVKE,


        BEGIN OF TY_MBEW,
          MATNR TYPE MBEW-MATNR,
          VPRSV TYPE MBEW-VPRSV,
          VERPR TYPE MBEW-VERPR,
          STPRS TYPE MBEW-STPRS,
        END OF TY_MBEW,

        BEGIN OF TY_A004,
          MATNR TYPE A004-MATNR,
          KSCHL TYPE A004-KSCHL,
        END OF TY_A004.

TYPES : BEGIN OF TY_FINAL,
        MATNR TYPE MATNR,
        KBETR(016), "TYPE KONP-KBETR, "CHAR13,"KBETR,
        VERPR TYPE MBEW-VERPR,
        STPRS TYPE MBEW-STPRS,
        VKORG TYPE VKORG,
        VTWEG TYPE VTWEG,
        KSCHL TYPE KSCHL,
        END OF TY_FINAL.

DATA: IT_MVKE TYPE TABLE OF TY_MVKE,
      WA_MVKE TYPE          TY_MVKE,

      IT_MBEW TYPE TABLE OF TY_MBEW,
      WA_MBEW TYPE          TY_MBEW,

      IT_A004 TYPE TABLE OF TY_A004,
      WA_A004 TYPE          TY_A004,

      IT_MARA TYPE TABLE OF TY_MARA,
      WA_MARA TYPE          TY_MARA,

      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL.



*DATA: BEGIN OF tmsg OCCURS 0,
*     "  refbs TYPE rm06e-refbs,
*       matnr TYPE mara-matnr,
*       message TYPE  bapi_msg,
*      END OF tmsg.
*CLEAR: tmsg, tmsg[].


*DATA: it_fcat TYPE slis_t_fieldcat_alv .
*DATA: wa_fcat LIKE LINE OF it_fcat .
*DATA: is_layout TYPE  slis_layout_alv.


*TYPES : BEGIN OF ty_fieldnames,
*field_name(30)    TYPE c,         "Field names
*END OF ty_fieldnames.
*
*DATA: it_fieldnames TYPE TABLE OF ty_fieldnames.
*
*DATA : wa_fieldnames TYPE ty_fieldnames.
*
*DATA :it_log TYPE STANDARD TABLE OF ty_data,
*       wa_log TYPE ty_data.
*
*
*DATA: lt_data TYPE STANDARD TABLE OF ty_data,
*      ls_data TYPE ty_data.


DATA: BEGIN OF bdcdata OCCURS 100.
        INCLUDE STRUCTURE bdcdata.
DATA: END OF bdcdata.

*DATA: BEGIN OF messtab OCCURS 50.
*        INCLUDE STRUCTURE bdcmsgcoll.
*DATA: END OF messtab.
*
*DATA: l_mstring(480).

*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
*PARAMETERS : p_file LIKE rlgrap-filename. "OBLIGATORY.
*PARAMETERS : p_mode LIKE ibipparms-callmode OBLIGATORY DEFAULT 'N'.
*            " p_burks TYPE bukrs OBLIGATORY.
*"A: show all dynpros
*"E: show dynpro on error only
*"N: do not display dynpro
*SELECTION-SCREEN END OF BLOCK b1.
*
*SELECTION-SCREEN FUNCTION KEY 1.
*
*INITIALIZATION.
*  MOVE 'Excel' TO sscrfields-functxt_01.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*  PERFORM get_filename.

*AT SELECTION-SCREEN.
*  IF sscrfields-ucomm = 'FC01'.
*    SUBMIT zgst_vk11_m_excel_upload.
*  ENDIF.


start-of-selection.

SELECT MATNR
       MTART FROM MARA INTO TABLE IT_MARA
       WHERE MTART IN ('HALB','FERT','ROH').

IF IT_MARA IS NOT INITIAL .
  SELECT MATNR
         VKORG
         VTWEG FROM MVKE INTO TABLE IT_MVKE
         FOR ALL ENTRIES IN IT_MARA
         WHERE MATNR = IT_MARA-MATNR AND VKORG = '1000' OR VTWEG = '10'.


ENDIF.

IF IT_MVKE IS NOT INITIAL.
  SELECT MATNR
         VPRSV
         VERPR
         STPRS FROM MBEW INTO TABLE IT_MBEW
         FOR ALL ENTRIES IN IT_MVKE
         WHERE MATNR = IT_MVKE-MATNR.

  SELECT MATNR
         KSCHL FROM A004 INTO TABLE IT_A004
         FOR ALL ENTRIES IN IT_MVKE
         WHERE MATNR = IT_MVKE-MATNR.

ENDIF.

LOOP AT IT_MVKE INTO WA_MVKE.
  WA_FINAL-MATNR = WA_MVKE-MATNR.
  WA_FINAL-VKORG = WA_MVKE-VKORG.
  WA_FINAL-VTWEG = WA_MVKE-VTWEG.

  READ TABLE IT_A004 INTO WA_A004 WITH KEY MATNR = WA_MVKE-MATNR.
  IF SY-SUBRC = 4.
    READ TABLE IT_MBEW INTO WA_MBEW WITH KEY MATNR = WA_MVKE-MATNR." VPRSV = 'S' .
    IF SY-SUBRC = 0.
        WA_FINAL-STPRS = WA_MBEW-STPRS.
        WA_FINAL-VERPR = WA_MBEW-VERPR.
      IF WA_MBEW-VPRSV = 'S' .
          WA_FINAL-KBETR = WA_FINAL-STPRS.
       ELSE.
         WA_FINAL-KBETR = WA_FINAL-VERPR.
      ENDIF.
*        CASE WA_MBEW-VPRSV.
*          WHEN  'S'.
*            WA_FINAL-KBETR = WA_final-STPRS.
*          WHEN 'V'.
*            WA_FINAL-KBETR = WA_final-VERPR.
**          WHEN OTHERS.
*        ENDCASE.
    ENDIF.

    WA_FINAL-KSCHL = 'ZPR0'.
    APPEND WA_FINAL TO IT_FINAL.
  ENDIF.


CLEAR WA_FINAL.
ENDLOOP.


*
*  PERFORM upload_data.
**PERFORM open_group.
  LOOP AT IT_FINAL INTO WA_FINAL.
    CLEAR: bdcdata.
    REFRESH: bdcdata.
*
perform bdc_dynpro      using 'SAPMV13A' '0100'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ANTA'.
perform bdc_field       using 'RV13A-KSCHL'
                              WA_FINAL-KSCHL.        "'zpr0'.
perform bdc_dynpro      using 'SAPLV14A' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'RV130-SELKZ(03)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=WEIT'.
perform bdc_field       using 'RV130-SELKZ(01)'
                              ''.
perform bdc_field       using 'RV130-SELKZ(03)'
                              'X'.
perform bdc_dynpro      using 'SAPMV13A' '1004'.
perform bdc_field       using 'BDC_CURSOR'
                              'KONP-KBETR(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'KOMG-VKORG'
                              WA_FINAL-VKORG.        "'1000'.
perform bdc_field       using 'KOMG-VTWEG'
                              WA_FINAL-VTWEG.          "'10'.
perform bdc_field       using 'KOMG-MATNR(01)'
                              WA_FINAL-MATNR.          "'CASTING-A-101'.
perform bdc_field       using 'KONP-KBETR(01)'
                              WA_FINAL-KBETR.            "'             100'.
perform bdc_dynpro      using 'SAPMV13A' '1004'.
perform bdc_field       using 'BDC_CURSOR'
                              'KOMG-MATNR(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=SICH'.
CALL TRANSACTION 'VK11' USING bdcdata
                                 MODE 'E'
                                 UPDATE 'S'.
*                                 MESSAGES INTO messtab.




*    IF sy-subrc IS INITIAL.
*      "WRITE: / ls_data-matnr ,  'Sucessfully Updated'.
*        tmsg-MATNR = ls_data-MATNR.
*      CONCATENATE 'Condition maintain for Material' ls_data-matnr
*          INTO tmsg-message SEPARATED BY space.
*         APPEND tmsg.
*          CLEAR: tmsg.
*    ELSE.
*      LOOP AT messtab WHERE msgtyp EQ 'E' .
*        SELECT  SINGLE text  FROM t100 INTO t100-text
*        WHERE sprsl = messtab-msgspra
*        AND   arbgb = messtab-msgid
*        AND   msgnr = messtab-msgnr.
*
*        IF sy-subrc = 0.
*          l_mstring = t100-text.
*          IF l_mstring CS '&1'.
*            REPLACE '&1' WITH messtab-msgv1 INTO l_mstring.
*            REPLACE '&2' WITH messtab-msgv2 INTO l_mstring.
*            REPLACE '&3' WITH messtab-msgv3 INTO l_mstring.
*            REPLACE '&4' WITH messtab-msgv4 INTO l_mstring.
*          ELSE.
*            REPLACE '&' WITH messtab-msgv1 INTO l_mstring.
*            REPLACE '&' WITH messtab-msgv2 INTO l_mstring.
*            REPLACE '&' WITH messtab-msgv3 INTO l_mstring.
*            REPLACE '&' WITH messtab-msgv4 INTO l_mstring.
*          ENDIF.
*          CONDENSE l_mstring.
*        ENDIF.
*        "wa_log-status =  l_mstring.
*         tmsg-MATNR = ls_data-MATNR.
*          CONCATENATE 'material'  ls_data-matnr ':' l_mstring
*          INTO tmsg-message SEPARATED BY space.
*          APPEND tmsg.
*          CLEAR: tmsg.
*      ENDLOOP.
*    ENDIF.

  ENDLOOP.




*  IF NOT tmsg[] IS INITIAL.
*    PERFORM fieldcatlog.
*    PERFORM alv.
*  ENDIF.
*************************************************************************************************************
************************************************************************************************************
*&---------------------------------------------------------------------*
*&      Form  FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM fieldcatlog .
*
*  wa_fcat-col_pos = '1' .
*  wa_fcat-fieldname = 'MATNR' .
*  wa_fcat-seltext_m = 'Material' .
*  wa_fcat-key = 'X' .
*  APPEND wa_fcat TO it_fcat .
*  CLEAR wa_fcat .
*
*  wa_fcat-col_pos = '2' .
*  wa_fcat-fieldname = 'MESSAGE' .
*  wa_fcat-seltext_m = 'Message' .
*  wa_fcat-key = 'X' .
*  APPEND wa_fcat TO it_fcat .
*  CLEAR wa_fcat .
*
*  is_layout-colwidth_optimize = 'X'.
*
*
*ENDFORM.                    " FIELDCATLOG
**&---------------------------------------------------------------------*
**&      Form  ALV
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM alv .
*
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      i_callback_program = sy-repid
*      i_grid_title       = 'Message Log'
*      is_layout          = is_layout
*      it_fieldcat        = it_fcat
*    TABLES
*      t_outtab           = tmsg.
*
*ENDFORM.
*

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
*FORM get_filename .
*  CALL FUNCTION 'F4_FILENAME'
** EXPORTING
**   PROGRAM_NAME        = SYST-CPROG
**   DYNPRO_NUMBER       = SYST-DYNNR
**   FIELD_NAME          = ' '
* IMPORTING
*   file_name           =  p_file.
*
*ENDFORM.                    " GET_FILENAME
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM upload_data .
*  TYPE-POOLS: truxs.
*
*  DATA: lt_raw TYPE truxs_t_text_data.
*
*  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
*    EXPORTING
**     I_FIELD_SEPERATOR    =
*      i_line_header        = 'X'
*      i_tab_raw_data       = lt_raw
*      i_filename           = p_file
*    TABLES
*      i_tab_converted_data = lt_data
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.

*ENDFORM.                    " UPLOAD_DATA
                " FIELDNAMES
