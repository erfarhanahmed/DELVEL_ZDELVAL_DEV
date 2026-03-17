*&---------------------------------------------------------------------*
*& Report ZROUTING_MATERIAL_CHECK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZROUTING_MATERIAL_CHECK.

TYPE-POOLS:SLIS.

TABLES:MARA.

TYPES : BEGIN OF TY_MARA,
        MATNR   TYPE MARA-MATNR,
        MTART   TYPE MARA-MTART,
        ZSERIES TYPE MARA-ZSERIES,
        ZSIZE   TYPE MARA-ZSIZE,
        END OF TY_MARA,

        BEGIN OF TY_MARC,
        MATNR TYPE MARC-MATNR,
        BESKZ TYPE MARC-BESKZ,
        END OF TY_MARC,

        BEGIN OF TY_MAPL,
        MATNR TYPE MAPL-MATNR,
        END OF TY_MAPL,


        BEGIN OF TY_FINAL,
        MATNR TYPE MARA-MATNR,
        MTART TYPE MARA-MTART,
        ZSERIES TYPE MARA-ZSERIES,
        ZSIZE   TYPE MARA-ZSIZE,
        BESKZ TYPE MARC-BESKZ,
        mattxt      TYPE text100,
        END OF TY_FINAL.


DATA: IT_MARA TYPE TABLE OF TY_MARA,
      WA_MARA TYPE          TY_MARA,

      IT_MARC TYPE TABLE OF TY_MARC,
      WA_MARC TYPE          TY_MARC,

      IT_MAPL TYPE TABLE OF TY_MAPL,
      WA_MAPL TYPE          TY_MAPL,

      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT TYPE SLIS_FIELDCAT_ALV.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt  TYPE tline,
      ls_mattxt  TYPE tline.



SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : S_TYPE TYPE MARA-MTART OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK B1.

PERFORM GET_DATA.
PERFORM GET_FCAT.
PERFORM GET_DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*BREAK fujiabap.
IF S_TYPE = 'FERT'.
  SELECT MATNR
         MTART
         ZSERIES
         ZSIZE FROM MARA INTO TABLE IT_MARA
         WHERE MTART = S_TYPE.

  IF IT_MARA IS NOT INITIAL.
   SELECT MATNR
          FROM MAPL INTO TABLE IT_MAPL
          FOR ALL ENTRIES IN IT_MARA
          WHERE MATNR = IT_MARA-MATNR.

 ENDIF.
 LOOP AT IT_MARA INTO WA_MARA.
    WA_FINAL-MTART = WA_MARA-MTART.
    WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
    WA_FINAL-ZSIZE   =  WA_MARA-ZSIZE .

READ TABLE IT_MAPL INTO WA_MAPL WITH KEY MATNR = WA_MARA-MATNR.
IF SY-SUBRC = 4.
  WA_FINAL-MATNR = WA_MARA-MATNR.

ENDIF.


CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = wa_FINAL-matnr.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_name
          object                  = 'MATERIAL'
        TABLES
          lines                   = lv_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      READ TABLE lv_lines INTO ls_mattxt INDEX 1.

WA_FINAL-mattxt = ls_mattxt-tdline.

APPEND WA_FINAL TO IT_FINAL.
DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING matnr.
*CLEAR wa_final.
ENDLOOP.
ENDIF.


IF S_TYPE = 'HALB'.
*  BREAK primus.
 SELECT MATNR
        MTART
        ZSERIES
        ZSIZE  FROM MARA INTO TABLE IT_MARA
        WHERE MTART = S_TYPE.
   IF  IT_MARA IS NOT INITIAL.
     SELECT MATNR
            BESKZ FROM MARC INTO TABLE IT_MARC
            FOR ALL ENTRIES IN IT_MARA
            WHERE MATNR = IT_MARA-MATNR
            AND BESKZ = 'X'.

   ENDIF.

   IF IT_MARC IS NOT INITIAL.
   SELECT MATNR
          FROM MAPL INTO TABLE IT_MAPL
          FOR ALL ENTRIES IN IT_MARC
          WHERE MATNR = IT_MARC-MATNR.

 ENDIF.
 LOOP AT IT_MARC INTO WA_MARC.
*    WA_FINAL-MTART = WA_MARA-MTART.
*    WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
*    WA_FINAL-ZSIZE   =  WA_MARA-ZSIZE .

READ TABLE IT_MAPL INTO WA_MAPL WITH KEY MATNR = WA_MARC-MATNR.
IF SY-SUBRC = 4.
  WA_FINAL-MATNR = WA_MARC-MATNR.

ENDIF.

READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MARC-MATNR.
  IF SY-SUBRC = 0.
    WA_FINAL-MTART = WA_MARA-MTART.
    WA_FINAL-ZSERIES = WA_MARA-ZSERIES.
    WA_FINAL-ZSIZE   =  WA_MARA-ZSIZE .
  ENDIF.



CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = wa_FINAL-matnr.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_name
          object                  = 'MATERIAL'
        TABLES
          lines                   = lv_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      READ TABLE lv_lines INTO ls_mattxt INDEX 1.

WA_FINAL-mattxt = ls_mattxt-tdline.

APPEND WA_FINAL TO IT_FINAL.
DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING matnr.
*CLEAR wa_final.
ENDLOOP.





ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .
PERFORM fcat USING :   '1'  'MATNR'   'IT_FINAL'  'Item_Code'          '18',
                       '2'  'mattxt'   'IT_FINAL'  'Description'       '50',
                       '3'  'ZSIZE'   'IT_FINAL'  'Size'               '10',
                       '4'  'ZSERIES'   'IT_FINAL'  'Series'           '10',
                       '5'  'MTART'   'IT_FINAL'  'Mtl.Type'           '10'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0189   text
*      -->P_0190   text
*      -->P_0191   text
*      -->P_0192   text
*      -->P_0193   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
 WA_FCAT-COL_POS = P1.
 WA_FCAT-FIELDNAME = P2.
 WA_FCAT-TABNAME = P3.
 WA_FCAT-SELTEXT_L = P4.
 WA_FCAT-OUTPUTLEN = P5.

 APPEND WA_FCAT TO IT_FCAT.
 CLEAR WA_FCAT.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display .
 CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = it_fcat

*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
