*&---------------------------------------------------------------------*
*& REPORT ZGST_JOB_WORK
*&---------------------------------------------------------------------*
*&        0. PROGRAM OWNER          : PRIMUS TECHSYSTEMS PVT LTD.
*         1. PROJECT                : DELLVAL
*         2. PROGRAM NAME           : ZGST_JOB_WORK
*         3. TRANS CODE             : ZGSTJOBWORK
*         4. CREATION DATE          : 26.06.2018
*         5. DEVELOPER NAME         : DHANASHRI KUNTE
*&-----------------------------------------------------------------------

REPORT ZGST_JOB_WORK.

TABLES : EKKO, LFA1, MSEG, J_1IG_SUBCON, ADRC, MKPF, EKPO, MAKT, MARA, VBRK.

TYPES : BEGIN OF TY_EKKO,
        EBELN TYPE EKKO-EBELN,
        LIFNR TYPE EKKO-LIFNR,
        EKORG TYPE EKKO-EKORG,
        END OF TY_EKKO.

DATA : IT_EKKO TYPE TABLE OF TY_EKKO,
       WA_EKKO TYPE TY_EKKO.

TYPES : BEGIN OF TY_MSEG,
        EBELN TYPE MSEG-EBELN,
        MBLNR TYPE MSEG-MBLNR,
        BWART TYPE MSEG-BWART,
        XAUTO TYPE MSEG-XAUTO,
        MENGE TYPE MSEG-MENGE,
        MATNR TYPE MSEG-MATNR,
        SMBLN TYPE MSEG-SMBLN,

        END OF TY_MSEG.

DATA : IT_MSEG TYPE TABLE OF TY_MSEG,
       WA_MSEG TYPE TY_MSEG.

DATA : IT_MSEG_1 TYPE TABLE OF TY_MSEG,
       WA_MSEG_1 TYPE TY_MSEG.

TYPES : BEGIN OF TY_J_1IG_SUBCON,
        MBLNR TYPE J_1IG_SUBCON-MBLNR,
        CHLN_INV TYPE J_1IG_SUBCON-CHLN_INV,
        BUDAT TYPE J_1IG_SUBCON-BUDAT,
        END OF TY_J_1IG_SUBCON.

DATA : IT_J_1IG_SUBCON TYPE TABLE OF TY_J_1IG_SUBCON,
       WA_J_1IG_SUBCON TYPE TY_J_1IG_SUBCON.

TYPES : BEGIN OF TY_VBRK,
        VBELN TYPE VBRK-VBELN,
        KNUMV TYPE VBRK-KNUMV,
        END OF TY_VBRK.

DATA : IT_VBRK TYPE TABLE OF TY_VBRK,
       WA_VBRK TYPE TY_VBRK.

TYPES : BEGIN OF TY_VBRP,
        VBELN TYPE VBRP-VBELN,
        POSNR TYPE VBRP-POSNR,
        MATNR TYPE VBRP-MATNR,
        NETWR TYPE VBRP-NETWR,
        END OF TY_VBRP.

DATA : IT_VBRP TYPE TABLE OF TY_VBRP,
       WA_VBRP TYPE TY_VBRP.

TYPES : BEGIN OF TY_KONV,
        KNUMV TYPE  prcd_elements-KNUMV,
        KPOSN TYPE  prcd_elements-KPOSN,
        KSCHL TYPE  prcd_elements-KSCHL,
        KWERT TYPE  prcd_elements-KWERT,
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
        NAME1 TYPE ADRC-NAME1,
        ADDRNUMBER TYPE ADRC-ADDRNUMBER,
        REGION TYPE ADRC-REGION,
        END OF TY_ADRC.

DATA : IT_ADRC TYPE TABLE OF TY_ADRC,
       WA_ADRC TYPE TY_ADRC.

TYPES : BEGIN OF TY_MKPF,
        MBLNR TYPE MKPF-MBLNR,
        BUDAT TYPE MKPF-BUDAT,
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

        EBELN TYPE EKKO-EBELN,
        LIFNR TYPE EKKO-LIFNR,

        MBLNR TYPE MSEG-MBLNR,
        BWART TYPE MSEG-BWART,
        MENGE TYPE MSEG-MENGE,
        MATNR_1 TYPE MSEG-MATNR,
        SMBLN TYPE MSEG-SMBLN,

        CHLN_INV TYPE J_1IG_SUBCON-CHLN_INV,
        BUDAT TYPE J_1IG_SUBCON-BUDAT,

        VBELN TYPE VBRK-VBELN,
        KNUMV TYPE VBRK-KNUMV,

        POSNR TYPE VBRP-POSNR,
        NETWR TYPE VBRP-NETWR,

        KSCHL TYPE  prcd_elements-KSCHL,
        KWERT_JOSG TYPE  prcd_elements-KWERT,
        KWERT_JOCG TYPE  prcd_elements-KWERT,
        KWERT_JOIG TYPE  prcd_elements-KWERT,
        KPOSN TYPE  prcd_elements-KPOSN,

        NAME1 TYPE LFA1-NAME1,
        STCD3 TYPE LFA1-STCD3,

        REGION TYPE ADRC-REGION,

        BUDAT_1 TYPE MKPF-BUDAT,
        XBLNR TYPE MKPF-XBLNR,

        MATNR TYPE EKPO-MATNR,

        MAKTX TYPE MAKT-MAKTX,

        MTART TYPE MARA-MTART,

        END OF TY_FINAL.

DATA : IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE TY_FINAL.

DATA : IT_FLDCAT TYPE SLIS_T_FIELDCAT_ALV,
       WA_FLDCAT TYPE SLIS_FIELDCAT_ALV.

DATA : WA_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA : IT_HEADER TYPE SLIS_T_LISTHEADER,
       WA_HEADER LIKE LINE OF IT_HEADER.

DATA : KWERT_F TYPE  prcd_elements-KWERT,
       KWERT_FINAL TYPE  prcd_elements-KWERT,
       FLAG TYPE I,
       MATNR_F TYPE MSEG-MATNR.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_EBELN  FOR EKPO-EBELN,
                S_LIFNR  FOR EKKO-LIFNR,
                S_EKORG  FOR EKKO-EKORG OBLIGATORY,
                S_C_INV  FOR J_1IG_SUBCON-CHLN_INV,
                S_CHDATE FOR J_1IG_SUBCON-BUDAT.
SELECTION-SCREEN: END OF BLOCK B1.

START-OF-SELECTION.

PERFORM SELECT_DATA.
PERFORM READ_DATA.
PERFORM GET_FCAT.
PERFORM GET_LAYOUT.
PERFORM DISPLAY.
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

SELECT EBELN LIFNR EKORG FROM EKKO INTO CORRESPONDING FIELDS OF TABLE IT_EKKO
                             WHERE LIFNR IN S_LIFNR
                              AND  EKORG IN S_EKORG.

SELECT EBELN PSTYP FROM EKPO INTO CORRESPONDING FIELDS OF TABLE IT_EKPO
                             WHERE EBELN IN S_EBELN
                             AND PSTYP = '3'.

SELECT EBELN MBLNR BWART XAUTO MENGE MATNR SMBLN FROM MSEG INTO CORRESPONDING FIELDS OF TABLE IT_MSEG
                                               FOR ALL ENTRIES IN IT_EKPO
                                               WHERE EBELN = IT_EKPO-EBELN AND
                                                     XAUTO NE 'X' AND
                                                     BWART IN ( '541' , '542' , '543','544' ) .

SELECT MBLNR CHLN_INV BUDAT FROM J_1IG_SUBCON INTO CORRESPONDING FIELDS OF TABLE IT_J_1IG_SUBCON
                                               FOR ALL ENTRIES IN IT_MSEG
                                               WHERE MBLNR = IT_MSEG-MBLNR
                                               AND CHLN_INV IN S_C_INV
                                               AND BUDAT IN S_CHDATE.

SELECT VBELN KNUMV FROM VBRK INTO CORRESPONDING FIELDS OF TABLE IT_VBRK
                             FOR ALL ENTRIES IN IT_J_1IG_SUBCON
                             WHERE VBELN = IT_J_1IG_SUBCON-CHLN_INV.

SELECT VBELN POSNR MATNR NETWR FROM VBRP INTO CORRESPONDING FIELDS OF TABLE IT_VBRP
                             FOR ALL ENTRIES IN IT_J_1IG_SUBCON
                             WHERE VBELN = IT_J_1IG_SUBCON-CHLN_INV.

SELECT KNUMV KPOSN KSCHL KWERT FROM PRCD_ELEMENTS INTO CORRESPONDING FIELDS OF TABLE IT_KONV
                                         FOR ALL ENTRIES IN IT_VBRK
                                         WHERE KNUMV = IT_VBRK-KNUMV
                                         AND KSCHL IN ( 'JOCG', 'JOSG', 'JOIG' ).

SELECT LIFNR NAME1 STCD3 ADRNR FROM LFA1 INTO CORRESPONDING FIELDS OF TABLE IT_LFA1
                             FOR ALL ENTRIES IN IT_EKKO
                             WHERE LIFNR = IT_EKKO-LIFNR.

SELECT NAME1 REGION ADDRNUMBER FROM ADRC INTO CORRESPONDING FIELDS OF TABLE IT_ADRC
                              FOR ALL ENTRIES IN IT_LFA1
                              WHERE ADDRNUMBER = IT_LFA1-ADRNR.

SELECT MBLNR BUDAT XBLNR FROM MKPF INTO CORRESPONDING FIELDS OF TABLE IT_MKPF
                                   FOR ALL ENTRIES IN IT_MSEG
                                   WHERE MBLNR = IT_MSEG-MBLNR.

SELECT MATNR MAKTX FROM MAKT INTO CORRESPONDING FIELDS OF TABLE IT_MAKT
                             FOR ALL ENTRIES IN IT_MSEG
                              WHERE MATNR = IT_MSEG-MATNR.

SELECT MATNR MTART FROM MARA INTO CORRESPONDING FIELDS OF TABLE IT_MARA
                             FOR ALL ENTRIES IN IT_MSEG
                             WHERE MATNR = IT_MSEG-MATNR.

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

MOVE IT_MSEG TO IT_MSEG_1.                       " LOGIC FOR SMBLN VALUE NOT DISPLAYED
DELETE IT_MSEG_1 WHERE SMBLN EQ ' '.

LOOP AT IT_MSEG_1 INTO WA_MSEG_1.
LOOP AT IT_MSEG INTO WA_MSEG.         " WHERE EBELN = WA_EKKO-EBELN.

IF WA_MSEG-MBLNR = WA_MSEG_1-SMBLN.

DELETE IT_MSEG WHERE MBLNR = WA_MSEG-MBLNR.

ELSE.
 CONTINUE.
ENDIF.
ENDLOOP.
ENDLOOP.

DELETE IT_MSEG WHERE SMBLN NE ' '.            " END OF SMBLN LOGIC

IF SY-SUBRC NE 0.
SY-SUBRC = 0.
ENDIF.

SORT IT_MSEG ASCENDING BY MBLNR.
LOOP AT IT_MSEG INTO WA_MSEG.

ON CHANGE OF WA_MSEG-MATNR.
 SY-TABIX = 1.
ENDON.

IF SY-TABIX = 1.
  FLAG = 1.
ELSE.
  FLAG = 2.
ENDIF.

WA_FINAL-MBLNR = WA_MSEG-MBLNR.
WA_FINAL-BWART = WA_MSEG-BWART.
WA_FINAL-MENGE = WA_MSEG-MENGE.
WA_FINAL-MATNR = WA_MSEG-MATNR.

IF IT_MSEG IS NOT INITIAL.

READ TABLE IT_EKKO INTO WA_EKKO WITH KEY EBELN = WA_MSEG-EBELN.
IF SY-SUBRC = 0.
WA_FINAL-LIFNR = WA_EKKO-LIFNR.
ENDIF.

READ TABLE IT_EKPO INTO WA_EKPO WITH KEY EBELN = WA_MSEG-EBELN.
IF SY-SUBRC = 0.
WA_FINAL-EBELN = WA_EKPO-EBELN.
ENDIF.

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
WA_FINAL-CHLN_INV = WA_J_1IG_SUBCON-CHLN_INV.
WA_FINAL-BUDAT    = WA_J_1IG_SUBCON-BUDAT.

MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING CHLN_INV BUDAT WHERE MATNR = WA_FINAL-MATNR. "  .
ENDIF.

READ TABLE IT_MKPF INTO WA_MKPF WITH KEY MBLNR = WA_MSEG-MBLNR.
IF SY-SUBRC = 0.
WA_FINAL-BUDAT_1 = WA_MKPF-BUDAT.
WA_FINAL-XBLNR   = WA_MKPF-XBLNR.
ENDIF.
ENDIF.

IF IT_EKKO IS NOT INITIAL.
READ TABLE IT_LFA1 INTO WA_LFA1 WITH KEY LIFNR = WA_EKKO-LIFNR.
IF SY-SUBRC = 0.
WA_FINAL-NAME1 = WA_LFA1-NAME1.
WA_FINAL-STCD3 = WA_LFA1-STCD3.
ENDIF.
ENDIF.

IF IT_LFA1 IS NOT INITIAL.
READ TABLE IT_ADRC INTO WA_ADRC WITH KEY ADDRNUMBER = WA_LFA1-ADRNR.
IF SY-SUBRC = 0.
WA_FINAL-REGION = WA_ADRC-REGION.
ENDIF.
ENDIF.

IF IT_J_1IG_SUBCON IS NOT INITIAL.
READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_J_1IG_SUBCON-CHLN_INV.
IF SY-SUBRC = 0.
WA_FINAL-KNUMV = WA_VBRK-KNUMV.
ENDIF.
ENDIF.

LOOP AT IT_VBRP INTO WA_VBRP WHERE VBELN = WA_J_1IG_SUBCON-CHLN_INV AND MATNR = WA_MSEG-MATNR.

WA_FINAL-NETWR = WA_VBRP-NETWR.

READ TABLE IT_KONV INTO WA_KONV WITH KEY KPOSN = WA_VBRP-POSNR  KSCHL = 'JOSG'.
IF SY-SUBRC = 0.
WA_FINAL-KWERT_JOSG = WA_KONV-KWERT.
ENDIF.

READ TABLE IT_KONV INTO WA_KONV WITH KEY KPOSN = WA_VBRP-POSNR  KSCHL = 'JOCG'.
IF SY-SUBRC = 0.
WA_FINAL-KWERT_JOCG = WA_KONV-KWERT.
ENDIF.

READ TABLE IT_KONV INTO WA_KONV WITH KEY KPOSN = WA_VBRP-POSNR  KSCHL = 'JOIG'.
IF SY-SUBRC = 0.
WA_FINAL-KWERT_JOIG = WA_KONV-KWERT.
ENDIF.

IF WA_FINAL-EBELN IS NOT INITIAL.                " LOGIC FOR EXCEPT 1ST MBLNR
IF FLAG = 1.

IF WA_FINAL-KWERT_JOCG IS NOT INITIAL AND WA_FINAL-KWERT_JOSG IS NOT INITIAL.
KWERT_FINAL = WA_FINAL-KWERT_JOCG + WA_FINAL-KWERT_JOSG.
KWERT_FINAL = KWERT_FINAL / WA_FINAL-MENGE.

ELSEIF WA_FINAL-KWERT_JOIG IS NOT INITIAL.
KWERT_FINAL = WA_FINAL-KWERT_JOIG.
KWERT_FINAL = KWERT_FINAL / WA_FINAL-MENGE.
ENDIF.

ELSEIF FLAG NE 1.

IF WA_FINAL-KWERT_JOCG IS NOT INITIAL AND WA_FINAL-KWERT_JOSG IS NOT INITIAL.
WA_FINAL-NETWR = WA_FINAL-NETWR * WA_FINAL-MENGE.
KWERT_F = KWERT_FINAL * WA_FINAL-MENGE.
KWERT_F = KWERT_F / 2.
WA_FINAL-KWERT_JOSG = KWERT_F.
WA_FINAL-KWERT_JOCG = KWERT_F.

ELSEIF WA_FINAL-KWERT_JOIG IS NOT INITIAL.
WA_FINAL-NETWR = WA_FINAL-NETWR * WA_FINAL-MENGE.
KWERT_F = KWERT_FINAL * WA_FINAL-MENGE.
WA_FINAL-KWERT_JOIG = KWERT_F.
ENDIF.
ENDIF.

APPEND WA_FINAL TO IT_FINAL.
CLEAR :  WA_KONV, WA_VBRP.
ENDIF.
ENDLOOP.

IF SY-SUBRC NE 0.
IF WA_FINAL-EBELN IS NOT INITIAL.
APPEND WA_FINAL TO IT_FINAL.
CLEAR : WA_FINAL-EBELN,WA_FINAL-LIFNR,WA_FINAL-MBLNR,WA_FINAL-BWART,WA_FINAL-MENGE,WA_FINAL-KNUMV,WA_FINAL-NAME1,WA_FINAL-STCD3,
        WA_FINAL-REGION,WA_FINAL-MATNR,WA_FINAL-MAKTX,WA_FINAL-MTART,WA_FINAL-BUDAT_1,WA_FINAL-XBLNR,WA_FINAL-NETWR,
        WA_FINAL-KWERT_JOSG, WA_FINAL-KWERT_JOCG,WA_FINAL-KWERT_JOIG,WA_VBRK, WA_EKKO, WA_MAKT, WA_MARA, WA_LFA1,
        WA_ADRC, WA_MKPF, WA_MSEG, WA_J_1IG_SUBCON.
ENDIF.
ENDIF.
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
  PERFORM FLDCAT USING '2'  ''  'CHALLAN NO'            'IT_FINAL' 'CHLN_INV'.
  PERFORM FLDCAT USING '3'  ''  'CHALLAN DATE'          'IT_FINAL' 'BUDAT'.
  PERFORM FLDCAT USING '4'  ''  'VENDOR'                'IT_FINAL' 'LIFNR'.
  PERFORM FLDCAT USING '5'  ''  'VENDOR NAME'           'IT_FINAL' 'NAME1'.
  PERFORM FLDCAT USING '6'  ''  'VENDOR GSTIN NO'       'IT_FINAL' 'STCD3'.
  PERFORM FLDCAT USING '7'  ''  'STATE CODE'            'IT_FINAL' 'REGION'.
  PERFORM FLDCAT USING '7'  ''  'MATERIAL DOCUMENT'     'IT_FINAL' 'MBLNR'.
  PERFORM FLDCAT USING '8'  ''  'POSTING DATE'          'IT_FINAL' 'BUDAT_1'.
  PERFORM FLDCAT USING '9'  ''  'MOVEMENT TYPE'         'IT_FINAL' 'BWART'.
  PERFORM FLDCAT USING '10' ''  'REFERENCE'             'IT_FINAL' 'XBLNR'.
  PERFORM FLDCAT USING '11' ''  'MATERIAL'              'IT_FINAL' 'MATNR'.
  PERFORM FLDCAT USING '12' ''  'MATERIAL DESCRIPTION'  'IT_FINAL' 'MAKTX'.
  PERFORM FLDCAT USING '13' ''  'MATERIAL TYPE'         'IT_FINAL' 'MTART'.
  PERFORM FLDCAT USING '14' ''  'QUANTITY'              'IT_FINAL' 'MENGE'.
  PERFORM FLDCAT USING '14' ''  'TAXABLE VALUE'         'IT_FINAL' 'NETWR'.
  PERFORM FLDCAT USING '15' ''  'SGST'                  'IT_FINAL' 'KWERT_JOSG'.
  PERFORM FLDCAT USING '16' ''  'CGST'                  'IT_FINAL' 'KWERT_JOCG'.
  PERFORM FLDCAT USING '17' ''  'IGST'                  'IT_FINAL' 'KWERT_JOIG'.

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
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = SY-REPID
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
   I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_PAGE'
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   IS_LAYOUT                         = WA_LAYOUT
   IT_FIELDCAT                       = IT_FLDCAT
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
   I_SAVE                            = 'X'
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    T_OUTTAB                          = IT_FINAL[]
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
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
    INPUT         = LV_DATE
 IMPORTING
   OUTPUT        = LV_DATE
          .

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
    IT_LIST_COMMENTARY       = IT_HEADER
*   I_LOGO                   =
*   I_END_OF_LIST_GRID       =
*   I_ALV_FORM               =
          .
ENDFORM.
