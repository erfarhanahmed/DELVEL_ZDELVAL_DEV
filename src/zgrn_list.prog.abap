*&---------------------------------------------------------------------*
*& Report ZGRN_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGRN_LIST.


TYPE-POOLS: slis.
TABLES:MARA,MSEG.

TYPES:BEGIN OF TY_MSEG,
      MBLNR TYPE MSEG-MBLNR,
      MJAHR TYPE MSEG-MJAHR,
      BWART TYPE MSEG-BWART,
      MATNR TYPE MSEG-MATNR,
      DMBTR TYPE MSEG-DMBTR,
      BNBTR TYPE MSEG-BNBTR,
      LGORT TYPE MSEG-LGORT,
      LIFNR TYPE MSEG-LIFNR,
      WAERS TYPE MSEG-WAERS,
      MENGE TYPE MSEG-MENGE,
      MEINS TYPE MSEG-MEINS,
      EBELN TYPE MSEG-EBELN,
      EBELP TYPE MSEG-EBELP,
      BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
      MTART TYPE MARA-MTART,
      END OF TY_MSEG,

      BEGIN OF TY_FINAL,
      MBLNR TYPE MSEG-MBLNR,
      MJAHR TYPE MSEG-MJAHR,
      BWART TYPE MSEG-BWART,
      MATNR TYPE MSEG-MATNR,
      DMBTR TYPE MSEG-DMBTR,
      BNBTR TYPE MSEG-BNBTR,
      LGORT TYPE MSEG-LGORT,
      LIFNR TYPE MSEG-LIFNR,
      WAERS TYPE MSEG-WAERS,
      MENGE TYPE MSEG-MENGE,
      MEINS TYPE MSEG-MEINS,
      EBELN TYPE MSEG-EBELN,
      EBELP TYPE MSEG-EBELP,
      BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
      MTART TYPE MARA-MTART,



      END OF TY_FINAL.



DATA:IT_MSEG TYPE TABLE OF TY_MSEG,
     WA_MSEG TYPE          TY_MSEG,

     IT_MSEG1 TYPE TABLE OF TY_MSEG,
     WA_MSEG1 TYPE          TY_MSEG,

     IT_FINAL TYPE TABLE OF TY_FINAL,
     WA_FINAL TYPE TY_FINAL.

DATA: it_fcat type slis_t_fieldcat_alv,
      wa_fcat like line of it_fcat.


SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:MAT FOR MSEG-MATNR,
                 TYPE FOR MARA-MTART,
                 DATE FOR MSEG-BUDAT_MKPF.
SELECTION-SCREEN:END OF BLOCK B1.

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
FORM GET_DATA .
SELECT MSEG~MBLNR
       MSEG~MJAHR
       MSEG~BWART
       MSEG~MATNR
       MSEG~DMBTR
       MSEG~BNBTR
       MSEG~LGORT
       MSEG~LIFNR
       MSEG~WAERS
       MSEG~MENGE
       MSEG~MEINS
       MSEG~EBELN
       MSEG~EBELP
       MSEG~BUDAT_MKPF
       MARA~MTART INTO TABLE IT_MSEG
       FROM  MSEG INNER JOIN  MARA ON MSEG~MATNR = MARA~MATNR
       WHERE MSEG~MATNR IN MAT
         AND MARA~MTART IN TYPE
         AND MSEG~BUDAT_MKPF IN DATE
         AND BWART = '101'.
 IT_MSEG1[] = IT_MSEG[].
SORT IT_MSEG1 BY MATNR.
SORT IT_MSEG BY MBLNR DESCENDING .


LOOP AT IT_MSEG1 INTO WA_MSEG1.


LOOP AT IT_MSEG INTO WA_MSEG WHERE MATNR = WA_MSEG1-MATNR.
ON CHANGE OF WA_MSEG-MATNR.
WA_FINAL-MBLNR = WA_MSEG-MBLNR.
WA_FINAL-MJAHR = WA_MSEG-MJAHR.
WA_FINAL-BWART = WA_MSEG-BWART.
WA_FINAL-MATNR = WA_MSEG-MATNR.
WA_FINAL-DMBTR = WA_MSEG-DMBTR.
WA_FINAL-BNBTR = WA_MSEG-BNBTR.
WA_FINAL-LGORT = WA_MSEG-LGORT.
WA_FINAL-LIFNR = WA_MSEG-LIFNR.
WA_FINAL-WAERS = WA_MSEG-WAERS.
WA_FINAL-MENGE = WA_MSEG-MENGE.
WA_FINAL-MEINS = WA_MSEG-MEINS.
WA_FINAL-EBELN = WA_MSEG-EBELN.
WA_FINAL-EBELP = WA_MSEG-EBELP.
WA_FINAL-BUDAT_MKPF = WA_MSEG-BUDAT_MKPF.
WA_FINAL-MTART = WA_MSEG-MTART.

APPEND WA_FINAL TO IT_FINAL.
CLEAR: WA_FINAL.
ENDON.
ENDLOOP.
ENDLOOP.
*SORT IT_FINAL BY MBLNR DESCENDING.
DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING MATNR.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT .
PERFORM FCAT USING : '1'  'MBLNR'   'IT_FINAL'  'DOC NO'           '18' ,
                     '2'  'MATNR'   'IT_FINAL'  'Material'           '18' ,
                     '3'  'MTART'   'IT_FINAL'  'Material Type'    '18' ,
                     '4'  'BUDAT_MKPF'   'IT_FINAL'  'Posting Date'      '18',
                     '5'  'MENGE'   'IT_FINAL'  'Quantity'      '18',
                     '6'  'DMBTR'   'IT_FINAL'  'Amount local'      '18',
                     '7'  'BNBTR'   'IT_FINAL'  'Delivery costs'      '18',
                     '8'  'EBELN'   'IT_FINAL'  'PO Number'      '18',
                     '9'  'EBELP'   'IT_FINAL'  'PO line item'      '18'.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DISPLAY .
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
*      -->P_0280   text
*      -->P_0281   text
*      -->P_0282   text
*      -->P_0283   text
*      -->P_0284   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(p1)
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
