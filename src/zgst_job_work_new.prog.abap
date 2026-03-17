*&---------------------------------------------------------------------*
*& REPORT ZGST_JOB_WORK_NEW
*&---------------------------------------------------------------------*
*&        0. PROGRAM OWNER          : PRIMUS TECHSYSTEMS PVT LTD.
*         1. PROJECT                : DELLVAL
*         2. PROGRAM NAME           : ZGST_JOB_WORK_NEW
*         3. TRANS CODE             : ZJOBWORK
*         4. CREATION DATE          : 20.08.2018
*         5. DEVELOPER NAME         : DHANASHRI KUNTE
*&---------------------------------------------------------------------*
REPORT ZGST_JOB_WORK_NEW.

TABLES : EKKO, EKPO, MAKT, MARA, MSEG, MKPF, J_1IG_SUBCON, LFA1, ADRC.

TYPES : BEGIN OF TY_EKKO,
          EBELN TYPE EKKO-EBELN,
          LIFNR TYPE EKKO-LIFNR,
          EKORG TYPE EKKO-EKORG,
          EKGRP TYPE EKKO-EKGRP,   "ADDED BY SHREYA 28-06-22
        END OF TY_EKKO.

DATA : IT_EKKO TYPE TABLE OF TY_EKKO,
       WA_EKKO TYPE TY_EKKO.

TYPES : BEGIN OF TY_MSEG,
          EBELN      TYPE MSEG-EBELN,
          MBLNR      TYPE MSEG-MBLNR,
          BWART      TYPE MSEG-BWART,
          XAUTO      TYPE MSEG-XAUTO,
          MENGE      TYPE MSEG-MENGE,
          MATNR      TYPE MSEG-MATNR,
          SMBLN      TYPE MSEG-SMBLN,
          BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
          WERKS      TYPE MSEG-WERKS,
          LIFNR      TYPE MSEG-LIFNR,
          MEINS      TYPE MSEG-MEINS,
          LGORT      TYPE MSEG-LGORT, "added by jyoti on 17.06.2024
        END OF TY_MSEG.

DATA : IT_MSEG TYPE TABLE OF TY_MSEG,
       WA_MSEG TYPE TY_MSEG.

DATA : IT_MSEG_1 TYPE TABLE OF TY_MSEG,
       WA_MSEG_1 TYPE TY_MSEG.

TYPES : BEGIN OF TY_J_1IG_SUBCON,
          MBLNR    TYPE J_1IG_SUBCON-MBLNR,
          CHLN_INV TYPE J_1IG_SUBCON-CHLN_INV,
          BUDAT    TYPE J_1IG_SUBCON-BUDAT,
          FKART    TYPE J_1IG_SUBCON-FKART,
          BWART    TYPE J_1IG_SUBCON-BWART,
        END OF TY_J_1IG_SUBCON.

DATA : IT_J_1IG_SUBCON TYPE TABLE OF TY_J_1IG_SUBCON,
       WA_J_1IG_SUBCON TYPE TY_J_1IG_SUBCON.

TYPES : BEGIN OF TY_VBRK,
          VBELN TYPE VBRK-VBELN,
          KNUMV TYPE VBRK-KNUMV,
        END OF TY_VBRK.

DATA : IT_VBRK TYPE TABLE OF TY_VBRK,
       WA_VBRK TYPE TY_VBRK.

TYPES : BEGIN OF TY_KONV,
          KNUMV TYPE  PRCD_ELEMENTS-KNUMV,
          KPOSN TYPE  PRCD_ELEMENTS-KPOSN,
          KSCHL TYPE  PRCD_ELEMENTS-KSCHL,
          KWERT TYPE  PRCD_ELEMENTS-KWERT,
        END OF TY_KONV.

DATA : IT_KONV TYPE TABLE OF TY_KONV,
       WA_KONV TYPE TY_KONV.

TYPES : BEGIN OF TY_LFA1,
          LIFNR TYPE LFA1-LIFNR,
          ADRNR TYPE LFA1-ADRNR,
          NAME1 TYPE LFA1-NAME1,
          STCD3 TYPE LFA1-STCD3,
        END OF TY_LFA1.

DATA : IT_LFA1 TYPE TABLE OF TY_LFA1,
       WA_LFA1 TYPE TY_LFA1.

TYPES : BEGIN OF TY_ADRC,
          NAME1      TYPE ADRC-NAME1,
          ADDRNUMBER TYPE ADRC-ADDRNUMBER,
          REGION     TYPE ADRC-REGION,
        END OF TY_ADRC.

DATA : IT_ADRC TYPE TABLE OF TY_ADRC,
       WA_ADRC TYPE TY_ADRC.

TYPES : BEGIN OF TY_MKPF,
          MBLNR TYPE MKPF-MBLNR,
          BUDAT TYPE MKPF-BUDAT,
*          FRBNR TYPE MKPF-FRBNR,
          XBLNR TYPE MKPF-XBLNR,
        END OF TY_MKPF.

DATA : IT_MKPF TYPE TABLE OF TY_MKPF,
       WA_MKPF TYPE TY_MKPF.

TYPES : BEGIN OF TY_EKPO,
          EBELN TYPE EKPO-EBELN,
          MATNR TYPE EKPO-MATNR,
          PSTYP TYPE EKPO-PSTYP,
        END OF TY_EKPO.

DATA : IT_EKPO TYPE TABLE OF TY_EKPO,
       WA_EKPO TYPE TY_EKPO.

TYPES : BEGIN OF TY_MAKT,
          MATNR TYPE MAKT-MATNR,
          MAKTX TYPE MAKT-MAKTX,
        END OF TY_MAKT.

DATA : IT_MAKT TYPE TABLE OF TY_MAKT,
       WA_MAKT TYPE TY_MAKT.

TYPES : BEGIN OF TY_MARA,
          MATNR TYPE MARA-MATNR,
          MTART TYPE MARA-MTART,
        END OF TY_MARA.

DATA : IT_MARA TYPE TABLE OF TY_MARA,
       WA_MARA TYPE TY_MARA.

TYPES : BEGIN OF TY_FINAL,
          EBELN      TYPE EKKO-EBELN,
          LIFNR      TYPE EKKO-LIFNR,
          MBLNR      TYPE MSEG-MBLNR,
          BWART      TYPE MSEG-BWART,
          MENGE      TYPE MSEG-MENGE,
          MATNR_1    TYPE MSEG-MATNR,
          SMBLN      TYPE MSEG-SMBLN,
          WERKS      TYPE MSEG-WERKS,
          BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
          MEINS      TYPE MSEG-MEINS,
          CHLN_INV   TYPE J_1IG_SUBCON-CHLN_INV,
          BUDAT      TYPE J_1IG_SUBCON-BUDAT,
          FKART      TYPE J_1IG_SUBCON-FKART,
          VBELN      TYPE VBRK-VBELN,
          KNUMV      TYPE VBRK-KNUMV,
          KSCHL      TYPE  PRCD_ELEMENTS-KSCHL,
          KWERT_JOSG TYPE  PRCD_ELEMENTS-KWERT,
          KWERT_JOCG TYPE  PRCD_ELEMENTS-KWERT,
          KWERT_JOIG TYPE  PRCD_ELEMENTS-KWERT,
          KPOSN      TYPE  PRCD_ELEMENTS-KPOSN,
          NAME1      TYPE LFA1-NAME1,
          STCD3      TYPE LFA1-STCD3,
          REGION     TYPE ADRC-REGION,
          XBLNR      TYPE MKPF-XBLNR,
          MATNR      TYPE EKPO-MATNR,
          MAKTX      TYPE MAKT-MAKTX,
          MTART      TYPE MARA-MTART,
          EKGRP      TYPE EKKO-EKGRP,   "ADDED BY SHREYA 28-06-22
          LGORT      TYPE MSEG-LGORT, "added by jyoti on 17.06.2024
        END OF TY_FINAL.

DATA : IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE TY_FINAL.
DATA : LV_DATE TYPE MSEG-BUDAT_MKPF.

"structure to download file on Application server.
**Added by Str. Sarika Thange 06.03.2019

TYPES : BEGIN OF TY_DOWN_FTP,
          EBELN          TYPE EKKO-EBELN,
          MATNR          TYPE EKPO-MATNR,
          MAKTX(40)      TYPE C,
          MTART          TYPE MARA-MTART,
          MBLNR          TYPE MSEG-MBLNR,
          BUDAT_MKPF(11) TYPE C,
          BWART          TYPE MSEG-BWART,
          MENGE(15)      TYPE C,
          MEINS(15)      TYPE C, "          TYPE mseg-meins,
          XBLNR          TYPE STRING,
          CHLN_INV       TYPE J_1IG_SUBCON-CHLN_INV,
          BUDAT(11)      TYPE C,
          LIFNR          TYPE EKKO-LIFNR,
          NAME1          TYPE LFA1-NAME1,
          STCD3          TYPE LFA1-STCD3,
          REGION         TYPE ADRC-REGION,
          EKGRP          TYPE EKKO-EKGRP,   "ADDED BY SHREYA 28-06-22
          LGORT          TYPE MSEG-LGORT, "added by jyoti on 17.06.2024
        END OF TY_DOWN_FTP.

DATA : GT_DOWN_FTP TYPE TABLE OF TY_DOWN_FTP,
       GS_DOWN_FTP TYPE TY_DOWN_FTP.

DATA : IT_FLDCAT TYPE SLIS_T_FIELDCAT_ALV,
       WA_FLDCAT TYPE SLIS_FIELDCAT_ALV.

DATA : WA_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA : IT_HEADER TYPE SLIS_T_LISTHEADER,
       WA_HEADER LIKE LINE OF IT_HEADER.

DATA : FLAG TYPE C.

SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_WERKS  FOR MSEG-WERKS OBLIGATORY,
                  S_EBELN  FOR MSEG-EBELN,
                  S_LIFNR  FOR MSEG-LIFNR,
                  S_BUDAT  FOR MKPF-BUDAT,      "ADDED PB: 31.10.2018
                  S_LGORT  FOR MSEG-LGORT. "added by jyoti on 17.06.2024
SELECTION-SCREEN: END OF BLOCK B1.

**Added By Sarika Thange 06.03.2019
SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.

SELECTION-SCREEN: END OF BLOCK B3.

START-OF-SELECTION.

  PERFORM SELECT_DATA.
  PERFORM READ_DATA.
  PERFORM GET_FCAT.
  PERFORM GET_LAYOUT.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.   "Added by Sarika Thange date 06.03.2019 to make report download to ftp server.
  ELSE.
    PERFORM DISPLAY.
  ENDIF.
  PERFORM TOP_OF_PAGE.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      FORM  SELECT_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM SELECT_DATA .

  SELECT EBELN MBLNR BWART XAUTO MENGE MATNR SMBLN BUDAT_MKPF WERKS LIFNR MEINS LGORT  "lgort added by jyoti on 17.06.2024
                                                FROM MSEG INTO TABLE IT_MSEG
*                                                FROM MSEG INTO CORRESPONDING FIELDS OF TABLE IT_MSEG
                                                  WHERE BUDAT_MKPF GE '20170701'
                                                  AND BUDAT_MKPF IN S_BUDAT "added
                                                  AND XAUTO NE 'X'
                                                  AND WERKS IN S_WERKS
                                                  AND EBELN IN S_EBELN
                                                  AND LIFNR IN S_LIFNR
                                                  AND LGORT IN S_LGORT "added by jyoti on 17.06.2024
                                                  AND BWART IN ( '541' , '542' , '543', '544' ) .

  IF IT_MSEG IS NOT INITIAL .
*    SELECT MBLNR CHLN_INV BUDAT FKART BWART FROM J_1IG_SUBCON INTO CORRESPONDING FIELDS OF TABLE IT_J_1IG_SUBCON
    SELECT MBLNR CHLN_INV BUDAT FKART BWART FROM J_1IG_SUBCON INTO TABLE IT_J_1IG_SUBCON
                                                   FOR ALL ENTRIES IN IT_MSEG
                                                   WHERE MBLNR = IT_MSEG-MBLNR.
    "AND FKART NE 'ZSP'.

*    SELECT LIFNR NAME1 STCD3 ADRNR FROM LFA1 INTO CORRESPONDING FIELDS OF TABLE IT_LFA1
    SELECT LIFNR NAME1 STCD3 ADRNR FROM LFA1 INTO  TABLE IT_LFA1
                                 FOR ALL ENTRIES IN IT_MSEG
                                 WHERE LIFNR = IT_MSEG-LIFNR.
  ENDIF.

  IF IT_LFA1 IS NOT INITIAL .
*    SELECT NAME1 REGION ADDRNUMBER FROM ADRC INTO CORRESPONDING FIELDS OF TABLE IT_ADRC
    SELECT NAME1 REGION ADDRNUMBER FROM ADRC INTO TABLE IT_ADRC
                                  FOR ALL ENTRIES IN IT_LFA1
                                  WHERE ADDRNUMBER = IT_LFA1-ADRNR.
  ENDIF.

  IF IT_MSEG IS NOT INITIAL .
*    SELECT MBLNR XBLNR BUDAT FROM MKPF INTO CORRESPONDING FIELDS OF TABLE IT_MKPF "ADD XBLNR
    SELECT MBLNR BUDAT XBLNR  FROM MKPF INTO  TABLE IT_MKPF "ADD XBLNR
                                       FOR ALL ENTRIES IN IT_MSEG
                                       WHERE MBLNR = IT_MSEG-MBLNR
                                       AND BUDAT IN S_BUDAT.  "ADDED



    SELECT MATNR MAKTX FROM MAKT INTO  TABLE IT_MAKT
*    SELECT MATNR MAKTX FROM MAKT INTO CORRESPONDING FIELDS OF TABLE IT_MAKT
                                 FOR ALL ENTRIES IN IT_MSEG
                                  WHERE MATNR = IT_MSEG-MATNR.


*    SELECT MATNR MTART FROM MARA INTO CORRESPONDING FIELDS OF TABLE IT_MARA
    SELECT MATNR MTART FROM MARA INTO  TABLE IT_MARA
                                 FOR ALL ENTRIES IN IT_MSEG
                                 WHERE MATNR = IT_MSEG-MATNR.
*     ******************     ADDED BY SHREYA
  ENDIF.

  SELECT  EBELN
          LIFNR
          EKORG
          EKGRP
    FROM EKKO
    INTO TABLE IT_EKKO
    WHERE EBELN IN S_EBELN.
*    ******************     ADDED BY SHREYA

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  READ_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM READ_DATA .

  SORT IT_MSEG BY EBELN.

  MOVE IT_MSEG TO IT_MSEG_1.
  DELETE IT_MSEG_1 WHERE SMBLN EQ ' '.

  DATA(IT_MSEG_1_T) = IT_MSEG_1 .

  SORT IT_MSEG_1_T BY SMBLN .
  DELETE ADJACENT DUPLICATES FROM IT_MSEG_1_T COMPARING SMBLN .


  SORT IT_MSEG BY MBLNR .

*  LOOP AT IT_MSEG_1 INTO WA_MSEG_1.
  LOOP AT IT_MSEG_1_T  INTO WA_MSEG_1.

    READ TABLE  IT_MSEG INTO DATA(WA_MMSS) WITH KEY MBLNR = WA_MSEG_1-SMBLN.
    IF SY-SUBRC EQ 0 .
      LOOP AT IT_MSEG INTO WA_MSEG FROM SY-TABIX.
        IF WA_MSEG-MBLNR = WA_MSEG_1-SMBLN.
*          IF WA_MSEG-MBLNR = WA_MSEG_1-SMBLN.
          DELETE IT_MSEG WHERE MBLNR = WA_MSEG-MBLNR.
*          ELSE.
*            CONTINUE.
*          ENDIF.
        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDLOOP.

  DELETE IT_MSEG WHERE SMBLN NE ' '.

  IF SY-SUBRC NE 0.
    SY-SUBRC = 0.
  ENDIF.

  SORT IT_MSEG BY EBELN MBLNR ASCENDING.
  LOOP AT IT_MSEG INTO WA_MSEG.

    WA_FINAL-EBELN      = WA_MSEG-EBELN.
    WA_FINAL-MATNR      = WA_MSEG-MATNR.
    WA_FINAL-MBLNR      = WA_MSEG-MBLNR.
    WA_FINAL-BUDAT_MKPF = WA_MSEG-BUDAT_MKPF.
    WA_FINAL-BWART      = WA_MSEG-BWART.
    WA_FINAL-MENGE      = WA_MSEG-MENGE .
    WA_FINAL-MEINS      = WA_MSEG-MEINS.
    WA_FINAL-LIFNR      = WA_MSEG-LIFNR.
    WA_FINAL-MEINS      = WA_MSEG-MEINS.
    WA_FINAL-LGORT      = WA_MSEG-LGORT."addded by jyoti on 17.06.2024

    IF WA_FINAL-MENGE GT 0 AND WA_FINAL-BWART = '541'.
      WA_FINAL-MENGE = WA_FINAL-MENGE * ( -1 ).
    ENDIF.
    IF IT_MSEG IS NOT INITIAL.

      READ TABLE IT_MAKT INTO WA_MAKT WITH KEY MATNR = WA_MSEG-MATNR.
      IF SY-SUBRC = 0.
        WA_FINAL-MAKTX = WA_MAKT-MAKTX.
      ENDIF.

      READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MSEG-MATNR.
      IF SY-SUBRC = 0.
        WA_FINAL-MTART = WA_MARA-MTART.
      ENDIF.

      READ TABLE IT_J_1IG_SUBCON INTO WA_J_1IG_SUBCON WITH KEY MBLNR = WA_MSEG-MBLNR.
      IF SY-SUBRC = 0.

        IF WA_J_1IG_SUBCON-FKART NE 'ZSP'.
          ON CHANGE OF WA_FINAL-EBELN.
            CLEAR : LV_DATE.
            IF WA_FINAL-BWART = '541'.
              WA_FINAL-CHLN_INV = WA_J_1IG_SUBCON-CHLN_INV.
              LV_DATE = WA_MSEG-BUDAT_MKPF.

            ENDIF.

            IF WA_J_1IG_SUBCON-BWART NE '541'.
              WA_FINAL-CHLN_INV = ' '.
*              wa_final-budat    = ' '.
            ENDIF.

          ENDON.
        ENDIF.
      ENDIF.
    ENDIF.
    WA_FINAL-BUDAT = LV_DATE.


    READ TABLE IT_MKPF INTO WA_MKPF WITH KEY MBLNR = WA_MSEG-MBLNR.
    IF SY-SUBRC = 0.
*WA_FINAL-FRBNR   = WA_MKPF-FRBNR.
      WA_FINAL-XBLNR   = WA_MKPF-XBLNR.
*      wa_final-budat   = wa_mkpf-budat.  "ADDED
    ENDIF.

    READ TABLE IT_LFA1 INTO WA_LFA1 WITH KEY LIFNR = WA_MSEG-LIFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-NAME1 = WA_LFA1-NAME1.
      WA_FINAL-STCD3 = WA_LFA1-STCD3.
    ENDIF.

    IF IT_LFA1 IS NOT INITIAL.
      READ TABLE IT_ADRC INTO WA_ADRC WITH KEY ADDRNUMBER = WA_LFA1-ADRNR.
      IF SY-SUBRC = 0.
        WA_FINAL-REGION = WA_ADRC-REGION.
      ENDIF.
    ENDIF.

    IF WA_FINAL-EBELN IS NOT INITIAL.
      IF WA_J_1IG_SUBCON-FKART NE 'ZSP'.

*******************     ADDED BY SHREYA
        IF SY-SUBRC = 0.
          READ TABLE IT_EKKO INTO WA_EKKO WITH KEY EBELN = WA_MSEG-EBELN.
          WA_FINAL-EKGRP = WA_EKKO-EKGRP.
        ENDIF.
*****************  ADDED BY SHREYA


        APPEND WA_FINAL TO IT_FINAL.
*CLEAR : WA_FINAL.
      ENDIF.
    ENDIF.
*CLEAR FLAG.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  GET_FCAT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM GET_FCAT .

  PERFORM FLDCAT USING '1'  'X' 'PURCHASE ORDER'        'IT_FINAL' 'EBELN'.
  PERFORM FLDCAT USING '2'  ''  'MATERIAL'              'IT_FINAL' 'MATNR'.
  PERFORM FLDCAT USING '3'  ''  'MATERIAL DESCRIPTION'  'IT_FINAL' 'MAKTX'.
  PERFORM FLDCAT USING '4'  ''  'MATERIAL TYPE'         'IT_FINAL' 'MTART'.
  PERFORM FLDCAT USING '5'  ''  'MATERIAL DOCUMENT'     'IT_FINAL' 'MBLNR'.
  PERFORM FLDCAT USING '6'  ''  'POSTING DATE'          'IT_FINAL' 'BUDAT_MKPF'.
  PERFORM FLDCAT USING '7'  ''  'MOVEMENT TYPE'         'IT_FINAL' 'BWART'.
  PERFORM FLDCAT USING '8'  ''  'QUANTITY'              'IT_FINAL' 'MENGE'.
  PERFORM FLDCAT USING '9'  ''  'UOM'                   'IT_FINAL' 'MEINS'.
*  PERFORM FLDCAT USING '10' ''  'REFERENCE'             'IT_FINAL' 'FRBNR'.
  PERFORM FLDCAT USING '10' ''  'REFERENCE'             'IT_FINAL' 'XBLNR'.  "ADD
  PERFORM FLDCAT USING '11' ''  'CHALLAN NO'            'IT_FINAL' 'CHLN_INV'.
  PERFORM FLDCAT USING '12' ''  'CHALLAN DATE'          'IT_FINAL' 'BUDAT'.
  PERFORM FLDCAT USING '13' ''  'VENDOR'                'IT_FINAL' 'LIFNR'.
  PERFORM FLDCAT USING '14' ''  'VENDOR NAME'           'IT_FINAL' 'NAME1'.
  PERFORM FLDCAT USING '15' ''  'VENDOR GSTIN NO'       'IT_FINAL' 'STCD3'.
  PERFORM FLDCAT USING '16' ''  'STATE CODE'            'IT_FINAL' 'REGION'.
  PERFORM FLDCAT USING '17' ''  'PURCHASING GROUP'      'IT_FINAL' 'EKGRP'.  "added by shreya
  PERFORM FLDCAT USING '18' ''  'STORAGE LOCATION'      'IT_FINAL' 'LGORT'.  "added by jyoti on 17.06.2024

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  FLDCAT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_0719   TEXT
*      -->P_0720   TEXT
*      -->P_0721   TEXT
*      -->P_0722   TEXT
*      -->P_0723   TEXT
*----------------------------------------------------------------------*
FORM FLDCAT  USING    VALUE(P1)
                      VALUE(P2)
                      VALUE(P3)
                      VALUE(P4)
                      VALUE(P5).

  WA_FLDCAT-COL_POS = P1.
  WA_FLDCAT-KEY = P2.
  WA_FLDCAT-SELTEXT_M = P3.
  WA_FLDCAT-TABNAME = P4.
  WA_FLDCAT-FIELDNAME = P5.
  APPEND WA_FLDCAT TO IT_FLDCAT.
  CLEAR WA_FLDCAT.

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  GET_LAYOUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM GET_LAYOUT .

  WA_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  WA_LAYOUT-ZEBRA = 'X' .

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  DISPLAY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM DISPLAY .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      I_CALLBACK_PROGRAM     = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      I_CALLBACK_TOP_OF_PAGE = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      IS_LAYOUT              = WA_LAYOUT
      IT_FIELDCAT            = IT_FLDCAT
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
      I_SAVE                 = 'X'
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      T_OUTTAB               = IT_FINAL[]
    EXCEPTIONS
      PROGRAM_ERROR          = 1
      OTHERS                 = 2.
  IF SY-SUBRC <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM TOP_OF_PAGE .

  DATA: LV_DATE(15) TYPE C,
        LV_TIME(10) TYPE C,
        LV_LINES    TYPE I.

  CLEAR IT_HEADER.

  WA_HEADER-TYP   = 'H'.
  WA_HEADER-INFO  = 'REPORT FOR GST JOB WORK'.

  APPEND WA_HEADER TO IT_HEADER.
  CLEAR WA_HEADER.

  LV_DATE = SY-DATUM.

  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      INPUT  = LV_DATE
    IMPORTING
      OUTPUT = LV_DATE.

  WA_HEADER-TYP   = 'S'.
  WA_HEADER-KEY   = 'DATE : '.
  WA_HEADER-INFO  = LV_DATE.

  APPEND WA_HEADER TO IT_HEADER.
  CLEAR WA_HEADER.

  CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) SY-UZEIT+4(2) INTO LV_TIME SEPARATED BY ':'.

  WA_HEADER-TYP   = 'S'.
  WA_HEADER-KEY   = 'TIME : '.
  WA_HEADER-INFO  = LV_TIME.

  APPEND WA_HEADER TO IT_HEADER.
  CLEAR WA_HEADER.

  DESCRIBE TABLE IT_FINAL LINES LV_LINES.

  WA_HEADER-TYP   = 'S'.
  WA_HEADER-KEY   = 'TOTAL NO LINES :'.
  WA_HEADER-INFO  = LV_LINES.

  APPEND WA_HEADER TO IT_HEADER.
  CLEAR WA_HEADER.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = IT_HEADER
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
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

  PERFORM FILL_FTP_STR.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = GT_DOWN_FTP
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*

*lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZJOBWORK.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZJOBWORK Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_676 TYPE STRING.
    DATA LV_CRLF_676 TYPE STRING.
    LV_CRLF_676 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_676 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_676 LV_CRLF_676 WA_CSV INTO LV_STRING_676.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_676 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_FTP_STR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILL_FTP_STR .

  LOOP AT IT_FINAL INTO WA_FINAL.

    GS_DOWN_FTP-EBELN  = WA_FINAL-EBELN.
    GS_DOWN_FTP-MATNR  = WA_FINAL-MATNR.
    GS_DOWN_FTP-MAKTX  = WA_FINAL-MAKTX.
    GS_DOWN_FTP-MTART  = WA_FINAL-MTART.
    GS_DOWN_FTP-MBLNR  = WA_FINAL-MBLNR.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT' EXPORTING INPUT = WA_FINAL-BUDAT_MKPF IMPORTING OUTPUT = GS_DOWN_FTP-BUDAT_MKPF.
    GS_DOWN_FTP-BWART  = WA_FINAL-BWART.

    GS_DOWN_FTP-MENGE  = WA_FINAL-MENGE.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT' CHANGING VALUE = GS_DOWN_FTP-MENGE.
    GS_DOWN_FTP-MEINS  = WA_FINAL-MEINS.
    GS_DOWN_FTP-XBLNR  = WA_FINAL-XBLNR.
    GS_DOWN_FTP-CHLN_INV  = WA_FINAL-CHLN_INV.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT' EXPORTING INPUT = WA_FINAL-BUDAT IMPORTING OUTPUT = GS_DOWN_FTP-BUDAT.
    GS_DOWN_FTP-LIFNR = WA_FINAL-LIFNR .
    GS_DOWN_FTP-NAME1 = WA_FINAL-NAME1 ..
    GS_DOWN_FTP-STCD3 = WA_FINAL-STCD3 .
    GS_DOWN_FTP-REGION = WA_FINAL-REGION.
    GS_DOWN_FTP-EKGRP  = WA_FINAL-EKGRP. "ADDED BY SHREYA
    GS_DOWN_FTP-LGORT  = WA_FINAL-LGORT. "ADDED BY JYOTI ON 17.06.2024
    APPEND GS_DOWN_FTP TO GT_DOWN_FTP.


  ENDLOOP.

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

  CONCATENATE
  'PURCHASE ORDER'
  'MATERIAL'
  'MATERIAL DESCRIPTION'
  'MATERIAL TYPE'
  'MATERIAL DOCUMENT'
  'POSTING DATE'
  'MOVEMENT TYPE'
  'QUANTITY'
  'UOM'
  'REFERENCE'
  'CHALLAN NO'
  'CHALLAN DATE'
  'VENDOR'
  'VENDOR NAME'
  'VENDOR GSTIN NO'
  'STATE CODE'
  'PURCHASING GROUP' "ADDED BY SHREYA
  'STORAGE LOCATION' "ADDED BY JYOTI ON 17.06.2024
  INTO PD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
