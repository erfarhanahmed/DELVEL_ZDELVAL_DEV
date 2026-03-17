*&---------------------------------------------------------------------*
*& Report ZMM_INBOUND_PO_RECORD_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_INBOUND_PO_RECORD_NEW.
TABLES: EKKO,EKES,EKPO.

TYPES: BEGIN OF TY_EKKO,
         BUKRS TYPE EKKO-BUKRS,
         EBELN TYPE EKKO-EBELN,
         BSART TYPE EKKO-BSART,
         AEDAT TYPE EKKO-AEDAT,
         LIFNR TYPE EKKO-LIFNR,
         EKGRP TYPE EKKO-EKGRP,
       END OF TY_EKKO,

       BEGIN OF TY_EKES,
         EBELN TYPE EKES-EBELN,
         EBELP TYPE EKES-EBELP,
         ETENS TYPE EKES-ETENS,
         ERDAT TYPE EKES-ERDAT,
         MENGE TYPE EKES-MENGE,
         DABMG TYPE EKES-DABMG,
         XBLNR TYPE EKES-XBLNR,
         VBELN TYPE EKES-VBELN,
         VBELP TYPE EKES-VBELP,
       END OF TY_EKES,

       BEGIN OF TY_EKPO,
         EBELN TYPE EKPO-EBELN,
         EBELP TYPE EKPO-EBELP,
         LOEKZ TYPE EKPO-LOEKZ,
         TXZ01 TYPE EKPO-TXZ01,
         MATNR TYPE EKPO-MATNR,
         MENGE TYPE EKPO-MENGE,
       END OF TY_EKPO,

       BEGIN OF TY_LFA1,
         LIFNR TYPE LFA1-LIFNR,
         NAME1 TYPE LFA1-NAME1,
       END OF TY_LFA1,

       BEGIN OF TY_FINAL,
         LIFNR   TYPE EKKO-LIFNR,
         NAME1   TYPE LFA1-NAME1,
         BSART   TYPE EKKO-BSART,
         EBELN   TYPE EKES-EBELN,
         AEDAT   TYPE string,
         EKGRP   TYPE EKKO-EKGRP,
         EBELP   TYPE EKES-EBELP,
         LOEKZ   TYPE EKPO-LOEKZ,
         MATNR   TYPE EKPO-MATNR,
         TXZ01   TYPE CHAR255,
         MENGE   TYPE EKPO-MENGE,
         VBELN   TYPE EKES-VBELN,
         ERDAT   TYPE string, "EKES-ERDAT,
         VBELP   TYPE EKES-VBELP,
         XBLNR   TYPE EKES-XBLNR,
         MENGE_1 TYPE EKES-MENGE,
         DABMG   TYPE EKES-DABMG,
       END OF TY_FINAL,
***************structure for refreshable file download
       BEGIN OF TY_DOWN,
         LIFNR   TYPE CHAR100,
         NAME1   TYPE CHAR100,
         BSART   TYPE CHAR100,
         EBELN   TYPE CHAR100,
         AEDAT   TYPE string,
         EKGRP   TYPE CHAR100,
         EBELP   TYPE CHAR100,
         LOEKZ   TYPE CHAR100,
         MATNR   TYPE CHAR100,
         TXZ01   TYPE CHAR100,
         MENGE   TYPE CHAR100,
         VBELN   TYPE CHAR100,
         ERDAT   TYPE string,
         VBELP   TYPE CHAR100,
         XBLNR   TYPE CHAR100,
         MENGE_1 TYPE CHAR100,
         DABMG   TYPE CHAR100,
         ref_date   TYPE string,
         REF_TIME       TYPE STRING,
       END OF TY_DOWN.

DATA: IT_EKKO  TYPE TABLE OF TY_EKKO,
      IT_EKES  TYPE TABLE OF TY_EKES,
      IT_EKPO  TYPE TABLE OF TY_EKPO,
      IT_EKPO1  TYPE TABLE OF TY_EKPO,
      IT_LFA1  TYPE TABLE OF TY_LFA1,
      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE TY_FINAL,
      IT_DOWN  TYPE TABLE OF TY_DOWN ,   " Abhishek Pisolkar (26.03.2018)
      WA_DOWN  TYPE TY_DOWN.

DATA: GD_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT TYPE SLIS_FIELDCAT_ALV,
      GD_LAYOUT   TYPE SLIS_LAYOUT_ALV,
      GD_REPID    TYPE SY-REPID.

Data : LV_ID    TYPE THEAD-TDNAME,
    LT_LINES TYPE STANDARD TABLE OF TLINE,
    LS_LINES TYPE TLINE.


*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS: S_EBELN FOR EKKO-EBELN,
                S_AEDAT FOR EKKO-AEDAT,
                S_LIFNR FOR EKKO-LIFNR.
PARAMETERS : P_WERKS TYPE EKPO-WERKS DEFAULT 'PL01',
             P_EKGRP TYPE EKKO-EKGRP.
SELECTION-SCREEN: END OF BLOCK B1.
*********selection screen for refreshable file added by jyoti on 09.02.2023
SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE ABC .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'. "'/Delval/India'."temp'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

*&---------------------------------------------------------------------*
*& AT SELECTION-SCREEN OUTPUT.
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF SCREEN-NAME = 'P_WERKS'.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
*&---------------------------------------------------------------------*
*& Initialization
*&---------------------------------------------------------------------*
INITIALIZATION.
  GD_REPID = SY-REPID.
  ABC = 'Download File'(tt2).

*&---------------------------------------------------------------------*
*& Main program
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM GET_DATA.

END-OF-SELECTION.
  IF NOT IT_FINAL[] IS INITIAL.
    PERFORM BUILD_FIELDCATALOG.

    IF NOT GD_FIELDCAT IS INITIAL.
      PERFORM BUILD_LAYOUT.
      PERFORM DISPALY_GRID.
    ELSE.
      MESSAGE 'No fieldcat found' TYPE 'E'. "No fieldcat found
    ENDIF. "IF NOT gd_fieldcat IS INITIAL.

  ELSE.
    MESSAGE 'No data found' TYPE 'E'. "No data found
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
 DATA: LV_MENGE_1 TYPE CHAR13,
        LV_MENGE   TYPE CHAR13,
        LV_DABMG   TYPE CHAR13.

  REFRESH: IT_EKKO,
           IT_EKPO,
           IT_EKES,
           IT_LFA1,
           IT_FINAL.

  if P_WERKS IS NOT INITIAL.
    SELECT EBELN
           EBELP
           LOEKZ
           TXZ01
           MATNR
           MENGE
      FROM EKPO
      INTO TABLE IT_EKPO1
*      FOR ALL ENTRIES IN IT_EKKO
      WHERE EBELN in S_EBELN
     AND  WERKS EQ P_WERKS.

  ENDIF.

  if it_ekpo1 IS NOT INITIAL.
    IF S_EBELN IS NOT INITIAL OR
     S_AEDAT IS NOT INITIAL OR
     S_LIFNR IS NOT INITIAL.

     SELECT  BUKRS
            EBELN
            BSART
            AEDAT
            LIFNR
            EKGRP
       FROM EKKO
       INTO TABLE IT_EKKO
       FOR ALL ENTRIES IN it_ekpo1
      WHERE EBELN = it_ekpo1-EBELN
       AND AEDAT IN S_AEDAT
     AND LIFNR IN S_LIFNR.


    ELSEIF P_EKGRP IS NOT INITIAL.

    SELECT  BUKRS
            EBELN
            BSART
            AEDAT
            LIFNR
            EKGRP
       FROM EKKO
       INTO TABLE IT_EKKO
      FOR ALL ENTRIES IN it_ekpo1
      WHERE EBELN = it_ekpo1-EBELN
        AND EKGRP EQ P_EKGRP.

  ENDIF.
  ENDIF.
  if it_ekko is INITIAL.
    SELECT  BUKRS
            EBELN
            BSART
            AEDAT
            LIFNR
            EKGRP
       FROM EKKO
       INTO TABLE IT_EKKO
      FOR ALL ENTRIES IN it_ekpo1
       where EBELN = it_ekpo1-EBELN.
  endif.

   IF NOT IT_EKKO IS INITIAL.
    SELECT EBELN
           EBELP
           LOEKZ
           TXZ01
           MATNR
           MENGE
      FROM EKPO
      INTO TABLE IT_EKPO
      FOR ALL ENTRIES IN IT_EKKO
      WHERE EBELN = IT_EKKO-EBELN
     AND  WERKS EQ P_WERKS.
  endif.

IF IT_EKPO[] IS NOT INITIAL.

      SELECT EBELN
             EBELP
             ETENS
             ERDAT
             MENGE
             DABMG
             XBLNR
             VBELN
             VBELP
        FROM EKES
        INTO TABLE IT_EKES
         FOR ALL ENTRIES IN IT_EKPO
       WHERE EBELN EQ IT_EKPO-EBELN
         AND EBELP EQ IT_EKPO-EBELP.

      IF NOT IT_EKKO[] IS INITIAL.

        SELECT LIFNR
               NAME1
          FROM LFA1
          INTO TABLE IT_LFA1
           FOR ALL ENTRIES IN IT_EKKO
         WHERE LIFNR EQ IT_EKKO-LIFNR.

      ENDIF.

    ENDIF.
*  ENDIF.

* Filling final data..
*  LOOP AT IT_EKPO INTO DATA(LW_EKPO).
LOOP AT IT_EKES INTO DATA(LW_EKES).



      WA_FINAL-EBELN = LW_EKES-EBELN.
      WA_FINAL-EBELP = LW_EKES-EBELP.
      WA_FINAL-VBELN = LW_EKES-VBELN.
      WA_FINAL-ERDAT = LW_EKES-ERDAT.
      IF NOT WA_FINAL-ERDAT IS INITIAL.
*          CONCATENATE WA_FINAL-ERDAT+6(2) WA_FINAL-ERDAT+4(2) WA_FINAL-ERDAT+0(4)
*             INTO WA_FINAL-ERDAT SEPARATED BY '-'.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = WA_FINAL-ERDAT
      IMPORTING
        output = WA_FINAL-ERDAT.
    CONCATENATE WA_FINAL-ERDAT+0(2) WA_FINAL-ERDAT+2(3) WA_FINAL-ERDAT+5(4)
                   INTO WA_FINAL-ERDAT SEPARATED BY '-'.

       ENDIF.
      WA_FINAL-VBELP = LW_EKES-VBELP.
      WA_FINAL-XBLNR = LW_EKES-XBLNR.
      WA_FINAL-MENGE_1 = LW_EKES-MENGE.
      WA_FINAL-DABMG = LW_EKES-DABMG.


  READ TABLE IT_EKPO INTO DATA(LW_EKPO) with KEY EBELN = LW_EKes-EBELN
                                         EBELP = LW_EKes-EBELP.
*

    IF LW_EKPO-LOEKZ = 'L'.
      WA_FINAL-LOEKZ = 'X'.
    ENDIF.
    WA_FINAL-MATNR = LW_EKPO-MATNR.

            "Material Long Text
        LV_ID = WA_FINAL-MATNR.
        CLEAR: LT_LINES,LS_LINES.
        if lv_id is not INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'GRUN'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_ID
            OBJECT                  = 'MATERIAL'
          TABLES
            LINES                   = LT_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT LT_LINES IS INITIAL.
          LOOP AT LT_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              REPLACE ALL OCCURRENCES OF '<&>' IN LS_LINES-TDLINE WITH '&'.
              CONCATENATE WA_FINAL-TXZ01 LS_LINES-TDLINE INTO WA_FINAL-TXZ01 SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
          CONDENSE WA_FINAL-TXZ01.
        ENDIF.
endif.




*    WA_FINAL-TXZ01 = LW_EKPO-TXZ01.
    WA_FINAL-MENGE = LW_EKPO-MENGE.

    READ TABLE IT_EKKO INTO DATA(LW_EKKO) WITH KEY EBELN = LW_EKPO-EBELN.
    IF SY-SUBRC EQ 0.
      WA_FINAL-LIFNR = LW_EKKO-LIFNR.
      WA_FINAL-BSART = LW_EKKO-BSART.
      WA_FINAL-AEDAT = LW_EKKO-AEDAT.
      IF NOT WA_FINAL-AEDAT IS INITIAL.
*          CONCATENATE WA_FINAL-AEDAT+6(2) WA_FINAL-AEDAT+4(2) WA_FINAL-AEDAT+0(4)
*             INTO WA_FINAL-AEDAT SEPARATED BY '-'.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = WA_FINAL-AEDAT
      IMPORTING
        output = WA_FINAL-AEDAT.
    CONCATENATE WA_FINAL-AEDAT+0(2) WA_FINAL-AEDAT+2(3) WA_FINAL-AEDAT+5(4)
                   INTO WA_FINAL-AEDAT SEPARATED BY '-'.

       ENDIF.
      WA_FINAL-EKGRP = LW_EKKO-EKGRP.
    ENDIF.

    READ TABLE IT_LFA1 INTO DATA(LW_LFA1) WITH KEY LIFNR = LW_EKKO-LIFNR.
    IF SY-SUBRC EQ 0.
      WA_FINAL-NAME1 = LW_LFA1-NAME1.
    ENDIF.

*    LOOP AT IT_EKES INTO DATA(LW_EKES) WHERE EBELN = LW_EKPO-EBELN
*                                         AND EBELP = LW_EKPO-EBELP.
*
*      WA_FINAL-EBELN = LW_EKES-EBELN.
*      WA_FINAL-EBELP = LW_EKES-EBELP.
*      WA_FINAL-VBELN = LW_EKES-VBELN.
*      WA_FINAL-ERDAT = LW_EKES-ERDAT.
*      IF NOT WA_FINAL-ERDAT IS INITIAL.
**          CONCATENATE WA_FINAL-ERDAT+6(2) WA_FINAL-ERDAT+4(2) WA_FINAL-ERDAT+0(4)
**             INTO WA_FINAL-ERDAT SEPARATED BY '-'.
*
*        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*      EXPORTING
*        input  = WA_FINAL-ERDAT
*      IMPORTING
*        output = WA_FINAL-ERDAT.
*    CONCATENATE WA_FINAL-ERDAT+0(2) WA_FINAL-ERDAT+2(3) WA_FINAL-ERDAT+5(4)
*                   INTO WA_FINAL-ERDAT SEPARATED BY '-'.
*
*       ENDIF.
*      WA_FINAL-VBELP = LW_EKES-VBELP.
*      WA_FINAL-XBLNR = LW_EKES-XBLNR.
*      WA_FINAL-MENGE_1 = LW_EKES-MENGE.
*      WA_FINAL-DABMG = LW_EKES-DABMG.

      APPEND WA_FINAL TO IT_FINAL.

*    ENDLOOP.

    CLEAR: LW_EKES,
           LW_EKKO,
           LW_LFA1,
           LW_EKPO,
           WA_FINAL.

  ENDLOOP.


*  SORT it_final BY ebeln vbeln.
  LOOP AT IT_FINAL INTO WA_FINAL.
    WA_DOWN-LIFNR  =  WA_FINAL-LIFNR.
    WA_DOWN-NAME1  =  WA_FINAL-NAME1.
    WA_DOWN-BSART  =  WA_FINAL-BSART.
    WA_DOWN-EBELN  =  WA_FINAL-EBELN.
    WA_DOWN-AEDAT  =  WA_FINAL-AEDAT.
    WA_DOWN-EKGRP  =  WA_FINAL-EKGRP.
    WA_DOWN-EBELP  =  WA_FINAL-EBELP.
    WA_DOWN-LOEKZ  =  WA_FINAL-LOEKZ.
    WA_DOWN-MATNR  =  WA_FINAL-MATNR.
    WA_DOWN-TXZ01  =  WA_FINAL-TXZ01.
    LV_MENGE       =  WA_FINAL-MENGE.
    WA_DOWN-VBELN  =  WA_FINAL-VBELN.
    WA_DOWN-ERDAT  =  WA_FINAL-ERDAT.
    WA_DOWN-VBELP  =  WA_FINAL-VBELP.
    WA_DOWN-XBLNR  =  WA_FINAL-XBLNR.
    LV_MENGE_1     =  WA_FINAL-MENGE_1.
    LV_DABMG       =  WA_FINAL-DABMG.

*    *------------------Refreshable Date / Shift negative sign to left logic ------------------------------------------

    IF LV_MENGE_1 LT 0.

      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = LV_MENGE_1.
    ENDIF.
    WA_DOWN-MENGE_1 = LV_MENGE_1.

    IF LV_MENGE LT 0.

      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = LV_MENGE.
    ENDIF.
    WA_DOWN-MENGE = LV_MENGE.

    IF LV_DABMG LT 0.

      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = LV_DABMG.
    ENDIF.
    WA_DOWN-DABMG = LV_DABMG.

*---------------Refreshable Date-----------------------
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = WA_DOWN-ref_date.
    CONCATENATE WA_DOWN-ref_date+0(2) WA_DOWN-ref_date+2(3) WA_DOWN-ref_date+5(4)
                   INTO WA_DOWn-ref_date SEPARATED BY '-'.
*---------------Refreshable Time-----------------------
    WA_DOWN-REF_TIME = SY-UZEIT.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)  INTO WA_DOWN-REF_TIME.

*--------------------------------------------------------------------*

    APPEND WA_DOWN TO IT_DOWN.
    CLEAR : WA_DOWN, WA_FINAL.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_FIELDCATALOG .

  WA_FIELDCAT-FIELDNAME = 'LIFNR'.
  WA_FIELDCAT-SELTEXT_L = 'Supplier Number'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NAME1'.
  WA_FIELDCAT-SELTEXT_L = 'Supplier Name'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'BSART'.
  WA_FIELDCAT-SELTEXT_L = 'PO Type'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'EBELN'.
  WA_FIELDCAT-SELTEXT_L = 'PO No'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'AEDAT'.
  WA_FIELDCAT-SELTEXT_L = 'PO Date'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'EKGRP'.
  WA_FIELDCAT-SELTEXT_L = 'Purchase Group'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'EBELP'.
  WA_FIELDCAT-SELTEXT_L = 'PO line'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'LOEKZ'.
  WA_FIELDCAT-SELTEXT_L = 'Deletion Indicator'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MATNR'.
  WA_FIELDCAT-SELTEXT_L = 'Item Code'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'TXZ01'.
  WA_FIELDCAT-SELTEXT_L = 'Item Description'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MENGE'.
  WA_FIELDCAT-SELTEXT_L = 'PO Qty'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'VBELN'.
  WA_FIELDCAT-SELTEXT_L = 'Inbound Delivery Number'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'ERDAT'.
  WA_FIELDCAT-SELTEXT_L = 'Created Date'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'VBELP'.
  WA_FIELDCAT-SELTEXT_L = 'Item '.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'XBLNR'.
  WA_FIELDCAT-SELTEXT_L = 'Reference Numner'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MENGE_1'.
  WA_FIELDCAT-SELTEXT_L = 'Inbound Qty'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'DABMG'.
  WA_FIELDCAT-SELTEXT_L = 'Recived Qty'.
  APPEND WA_FIELDCAT TO GD_FIELDCAT.
  CLEAR WA_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_LAYOUT .

  GD_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  GD_LAYOUT-ZEBRA = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPALY_GRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPALY_GRID .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = GD_REPID
*     I_CALLBACK_PF_STATUS_SET               = ' '
*     I_CALLBACK_USER_COMMAND                = ' '
*     I_CALLBACK_TOP_OF_PAGE                 = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_END_OF_LIST            = ' '
*     I_STRUCTURE_NAME   = I_STRUCTURE_NAME
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       = I_GRID_TITLE
*     I_GRID_SETTINGS    = I_GRID_SETTINGS
      IS_LAYOUT          = GD_LAYOUT
      IT_FIELDCAT        = GD_FIELDCAT
*     IT_EXCLUDING       = IT_EXCLUDING
*     IT_SPECIAL_GROUPS  = IT_SPECIAL_GROUPS
*     IT_SORT            = IT_SORT
*     IT_FILTER          = IT_FILTER
*     IS_SEL_HIDE        = IS_SEL_HIDE
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         = IS_VARIANT
*     IT_EVENTS          = IT_EVENTS
*     IT_EVENT_EXIT      = IT_EVENT_EXIT
*     IS_PRINT           = IS_PRINT
*     IS_REPREP_ID       = IS_REPREP_ID
*     I_SCREEN_START_COLUMN                  = 0
*     I_SCREEN_START_LINE                    = 0
*     I_SCREEN_END_COLUMN                    = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    = IT_ALV_GRAPHICS
*     IT_HYPERLINK       = IT_HYPERLINK
*     IT_ADD_FIELDCAT    = IT_ADD_FIELDCAT
*     IT_EXCEPT_QINFO    = IT_EXCEPT_QINFO
*     IR_SALV_FULLSCREEN_ADAPTER             =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER                =
*     ES_EXIT_CAUSED_BY_USER                 =
    TABLES
      T_OUTTAB           = IT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

******************************* Refreshable file******************************
  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM DOWNLOAD .

  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).
*BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZINBOUND_PO_RECO.TXT'.

*  CONCATENATE P_FOLDER '\'  LV_FILE
  CONCATENATE P_FOLDER '/'  LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZINBOUND_PO_RECO Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_734 TYPE string.
DATA lv_crlf_734 TYPE string.
lv_crlf_734 = cl_abap_char_utilities=>cr_lf.
lv_string_734 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_734 lv_crlf_734 wa_csv INTO lv_string_734.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_1495 TO lv_fullfile.
TRANSFER lv_string_734 TO lv_fullfile.
    CLOSE DATASET LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.


  CONCATENATE 'Supplier Number'
              'Supplier Name'
              'PO Type'
              'PO No'
              'PO Date'
              'Purchase Group'
              'PO line'
              'Deletion Indicator'
              'Item Code'
              'Item Description'
              'PO Qty'
              'Inbound Delivery Number'
              'Created Date'
              'Item '
              'Reference Numner'
              'Inbound Qty'
              'Recived Qty'
              'Refreshable Date'
              'Refreshable Time'

       INTO PD_CSV SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
