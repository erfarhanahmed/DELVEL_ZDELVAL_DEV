*&---------------------------------------------------------------------*
*& Report ZUNUSE_MATERIAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUNUSE_MATERIAL.

TABLES:MARA.

TYPES: BEGIN OF ty_mara,
       matnr TYPE mara-matnr,
       mtart TYPE mara-mtart,
       END OF ty_mara,

       BEGIN OF ty_mseg,
       matnr TYPE mseg-matnr,
       bwart TYPE mseg-bwart,
       END OF ty_mseg,

       BEGIN OF ty_mbew,
       matnr TYPE mbew-matnr,
       verpr TYPE mbew-verpr,
       stprs TYPE mbew-stprs,
       END OF ty_mbew,

       BEGIN OF ty_final,
       matnr TYPE mara-matnr,
       mtart TYPE mara-mtart,
       verpr TYPE mbew-verpr,
       stprs TYPE mbew-stprs,
       bwart TYPE mseg-bwart,
       END OF ty_final.

DATA: it_mara TYPE TABLE OF ty_mara,
      wa_mara TYPE          tY_mara,

      it_mseg TYPE TABLE OF ty_mseg,
      wa_mseg TYPE          ty_mseg,

      it_mbew TYPE TABLE OF ty_mbew,
      wa_mbew TYPE          ty_mbew,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final.

DATA: it_fcat type slis_t_fieldcat_alv,
      wa_fcat like line of it_fcat.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS: mate FOR mara-matnr.
SELECTION-SCREEN: END OF block b1.

START-OF-SELECTION.
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
*  BREAK-POINT.
  SELECT matnr
         mtart FROM mara INTO TABLE it_mara
         WHERE matnr in mate.

IF  it_mara is NOT INITIAL.
  SELECT matnr
         bwart FROM mseg INTO TABLE it_mseg
         FOR ALL ENTRIES IN it_mara
         WHERE matnr = it_mara-matnr.
*         AND bwart NE '101'.




  SELECT matnr
         verpr
         stprs FROM mbew INTO TABLE it_mbew
         FOR ALL ENTRIES IN it_mara
         WHERE matnr = it_mara-matnr
         AND  verpr NE '0'
         OR  stprs NE '0'.


ENDIF.

 LOOP AT it_mara INTO wa_mara.
   wa_final-matnr = wa_mara-matnr.
**   wa_final-verpr = wa_mbew-verpr.
**   wa_final-stprs = wa_mbew-stprs.
**
 READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = wa_mara-matnr.
  IF sy-subrc = 0.
       wa_final-bwart = wa_mseg-bwart.
  ENDIF.
  READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_mara-matnr .
   IF sy-subrc = 0.
    wa_final-verpr = wa_mbew-verpr.
    wa_final-stprs = wa_mbew-stprs.
**
**
  ENDIF.
  IF wa_mara-matnr NE wa_mseg-matnr .
    IF wa_final-verpr NE 0 or wa_final-stprs NE 0.
      APPEND wa_final TO it_final.
    ENDIF.

  ENDIF.

  CLEAR wa_final.
 ENDLOOP.
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
  PERFORM FCAT USING : '1'  'MATNR'   'IT_FINAL'  'Material'           '18' ,
                     '2'  'VERPR'   'IT_FINAL'  'Mov.avg.Price '   '18',
                     '3'  'STPRS'   'IT_FINAL'  'Stand. price'   '18' ,
                     '4'  'BWART'   'IT_FINAL'  'Mov.typ'         '18' .


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
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
     I_CALLBACK_PROGRAM                = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
*     IS_LAYOUT                         =
     IT_FIELDCAT                       = it_fcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT                           =
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
*     I_SAVE                            = ' '
*     IS_VARIANT                        =
*     IT_EVENTS                         =
*     IT_EVENT_EXIT                     =
*     IS_PRINT                          =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                          = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0276   text
*      -->P_0277   text
*      -->P_0278   text
*      -->P_0279   text
*      -->P_0280   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
wa_fcat-col_pos   = p1.
wa_fcat-fieldname = p2.
wa_fcat-tabname   = p3.
wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
wa_fcat-outputlen   = p5.

append wa_fcat to it_fcat.
CLEAR wa_fcat.
ENDFORM.
