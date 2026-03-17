*&---------------------------------------------------------------------*
*& Report ZVEND_DEBIT_NOTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZVEND_DEBIT_NOTE.

DATA:
  TMP_BELNR TYPE BKPF-BELNR,
  TMP_BUDAT TYPE BKPF-BUDAT.
DATA(LO_TEXT_READER) = NEW ZCL_READ_TEXT( ).
DATA : LV_LINES1 TYPE STRING.
TYPES:
  BEGIN OF T_ACCOUNTING_DOC_HDR,
    BUKRS   TYPE BKPF-BUKRS,
    BELNR   TYPE BKPF-BELNR,
    GJAHR   TYPE BKPF-GJAHR,
    BLDAT   TYPE BKPF-BLDAT,
    BUDAT   TYPE BKPF-BUDAT,
    XBLNR   TYPE BKPF-XBLNR,
    BKTXT   TYPE BKPF-BKTXT,
    AWKEY   TYPE BKPF-AWKEY,
    BELNR_R TYPE RSEG-BELNR,
  END OF T_ACCOUNTING_DOC_HDR,
  TT_ACCOUNTING_DOC_HDR TYPE STANDARD TABLE OF T_ACCOUNTING_DOC_HDR.

TYPES:
  BEGIN OF T_ACCOUNTING_DOC_ITEM,
    BUKRS TYPE BSEG-BUKRS,
    BELNR TYPE BSEG-BELNR,
    GJAHR TYPE BSEG-GJAHR,
    BUZEI TYPE BSEG-BUZEI,
    DMBTR TYPE BSEG-DMBTR,
    WRBTR TYPE BSEG-WRBTR,
    SGTXT TYPE BSEG-SGTXT,
    HKONT TYPE BSEG-HKONT,
    LIFNR TYPE BSEG-LIFNR,
  END OF T_ACCOUNTING_DOC_ITEM,
  TT_ACCOUNTING_DOC_ITEM TYPE STANDARD TABLE OF T_ACCOUNTING_DOC_ITEM.

TYPES:
  BEGIN OF T_RBKP,
    BELNR TYPE RBKP-BELNR,
    GJAHR TYPE RBKP-GJAHR,
    LIFNR TYPE RBKP-LIFNR,
  END OF T_RBKP,
  TT_RBKP TYPE STANDARD TABLE OF T_RBKP.

TYPES:
  BEGIN OF T_RSEG,
    BELNR   TYPE RSEG-BELNR,
    GJAHR   TYPE RSEG-GJAHR,
    BUZEI   TYPE RSEG-BUZEI,
    EBELN   TYPE RSEG-EBELN,
    EBELP   TYPE RSEG-EBELP,
    MATNR   TYPE RSEG-MATNR,
    WERKS   TYPE RSEG-WERKS,
    WRBTR   TYPE RSEG-WRBTR,
    MWSKZ   TYPE RSEG-MWSKZ,
    MENGE   TYPE RSEG-MENGE,
    MEINS   TYPE RSEG-MEINS,
    KSCHL   TYPE RSEG-KSCHL,
    LFBNR   TYPE RSEG-LFBNR,
    LFGJA   TYPE RSEG-LFGJA,
    LFPOS   TYPE RSEG-LFPOS,
    LIFNR   TYPE RSEG-LIFNR,
    HSN_SAC TYPE RSEG-HSN_SAC,
  END OF T_RSEG,
  TT_RSEG TYPE STANDARD TABLE OF T_RSEG.

TYPES:
  BEGIN OF T_MAT_DESC,
    MATNR TYPE MAKT-MATNR,
    MAKTX TYPE MAKT-MAKTX,
  END OF T_MAT_DESC,
  TT_MAT_DESC TYPE STANDARD TABLE OF T_MAT_DESC.

TYPES:
  BEGIN OF T_MAT_DOC_HDR,
    MBLNR TYPE MKPF-MBLNR,
    MJAHR TYPE MKPF-MJAHR,
    XBLNR TYPE MKPF-XBLNR,
    BKTXT TYPE MKPF-BKTXT,
    FRBNR TYPE MKPF-FRBNR,
  END OF T_MAT_DOC_HDR,
  TT_MAT_DOC_HDR TYPE STANDARD TABLE OF T_MAT_DOC_HDR.

TYPES:
  BEGIN OF T_MAT_DOC,
    MBLNR TYPE MSEG-MBLNR,
    MJAHR TYPE MSEG-MJAHR,
    ZEILE TYPE MSEG-ZEILE,
    MATNR TYPE MSEG-MATNR,
    WERKS TYPE MSEG-WERKS,
    SGTXT TYPE MSEG-SGTXT,
    GRUND TYPE MSEG-GRUND,
    WEMPF TYPE MSEG-WEMPF,
  END OF T_MAT_DOC,
  TT_MAT_DOC TYPE STANDARD TABLE OF T_MAT_DOC.

DATA:
  GT_HDR  TYPE ZT_MATERIAL_DOC_HDR,
  GT_ITEM TYPE ZT_MATERIAL_DOC.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE XYZ.
  SELECT-OPTIONS: SO_BELNR FOR TMP_BELNR,
                  SO_BUDAT FOR TMP_BUDAT.
  PARAMETERS: P_GJAHR TYPE BKPF-GJAHR DEFAULT '2017' OBLIGATORY.
SELECTION-SCREEN:END OF BLOCK B1.

SELECTION-SCREEN: BEGIN OF BLOCK B2 WITH FRAME TITLE ABC.
  PARAMETERS: R1 RADIOBUTTON GROUP ABC DEFAULT 'X',
              R2 RADIOBUTTON GROUP ABC.
SELECTION-SCREEN:END OF BLOCK B2.

SELECTION-SCREEN: BEGIN OF BLOCK B3 WITH FRAME TITLE DEF.
* created by supriya jagtap 17:06:2024
  PARAMETERS: R3 RADIOBUTTON GROUP DEF DEFAULT 'X',
              R4 RADIOBUTTON GROUP DEF.
SELECTION-SCREEN:END OF BLOCK B3.




INITIALIZATION.
  XYZ = 'Select Options'(tt1).
  ABC = 'Layout Options'(tt2).
*  created by supriya jagtap 17:06:2024
  DEF = 'Layout Options'(tt3).

START-OF-SELECTION.
  IF R1 = 'X'.
    PERFORM GET_DATA.

  ELSEIF R2 = 'X'.
    PERFORM FETCH_DATA CHANGING GT_HDR
                                GT_ITEM.
    PERFORM FORM_DISPLAY USING GT_HDR
                               GT_ITEM.
  ENDIF.




*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_HDR  text
*      <--P_GT_ITEM  text
*----------------------------------------------------------------------*
FORM FETCH_DATA  CHANGING CT_HDR  TYPE ZT_MATERIAL_DOC_HDR
                          CT_ITEM TYPE ZT_MATERIAL_DOC.
  DATA:
    LT_ACCOUNTING_DOC_HDR TYPE TT_ACCOUNTING_DOC_HDR,
    LS_ACCOUNTING_DOC_HDR TYPE T_ACCOUNTING_DOC_HDR,
    LT_RSEG               TYPE TT_RSEG,
    LS_RSEG               TYPE T_RSEG,
    LT_MAT_DOC_HDR        TYPE TT_MAT_DOC_HDR,
    LS_MAT_DOC_HDR        TYPE T_MAT_DOC_HDR,
    LT_MAT_DOC            TYPE TT_MAT_DOC,
    LS_MAT_DOC            TYPE T_MAT_DOC,
    LS_MATERIAL_DOC_HDR   TYPE ZMATERIAL_DOC_HDR,
    LS_MATERIAL_DOC       TYPE ZMATERIAL_DOC,
    LT_MAT_DESC           TYPE TT_MAT_DESC,
    LS_MAT_DESC           TYPE T_MAT_DESC,
    LT_RBKP               TYPE TT_RBKP,
    LS_RBKP               TYPE T_RBKP.

  DATA : LV_WORD    TYPE CHAR256,    "vse word
         GV_TOT_WRD TYPE CHAR256.

  DATA:
    LV_ID    TYPE THEAD-TDNAME,
    LT_LINES TYPE STANDARD TABLE OF TLINE,
    LS_LINES TYPE TLINE.

  SELECT BUKRS
         BELNR
         GJAHR
         BLDAT
         BUDAT
         XBLNR
         BKTXT
         AWKEY
    FROM BKPF
    INTO TABLE LT_ACCOUNTING_DOC_HDR
    WHERE BELNR IN SO_BELNR
    AND   GJAHR = P_GJAHR
    AND   BUDAT IN SO_BUDAT
    AND   BLART IN ('KG','KR').

  IF NOT SY-SUBRC IS INITIAL.
    MESSAGE 'Please Check The Input' TYPE 'E'.
  ENDIF.

  IF NOT LT_ACCOUNTING_DOC_HDR IS INITIAL.
    LOOP AT LT_ACCOUNTING_DOC_HDR INTO LS_ACCOUNTING_DOC_HDR.
      LS_ACCOUNTING_DOC_HDR-BELNR_R = LS_ACCOUNTING_DOC_HDR-AWKEY.
      MODIFY LT_ACCOUNTING_DOC_HDR FROM LS_ACCOUNTING_DOC_HDR.
    ENDLOOP.

    SELECT BELNR
           GJAHR
           BUZEI
           EBELN
           EBELP
           MATNR
           WERKS
           WRBTR
           MWSKZ
           MENGE
           MEINS
           KSCHL
           LFBNR
           LFGJA
           LFPOS
           LIFNR
           HSN_SAC
      FROM RSEG
      INTO TABLE LT_RSEG
      FOR ALL ENTRIES IN LT_ACCOUNTING_DOC_HDR
      WHERE BELNR = LT_ACCOUNTING_DOC_HDR-BELNR_R
      AND   GJAHR = LT_ACCOUNTING_DOC_HDR-GJAHR.

    SELECT BELNR
           GJAHR
           LIFNR
      FROM RBKP
      INTO TABLE LT_RBKP
      FOR ALL ENTRIES IN LT_ACCOUNTING_DOC_HDR
      WHERE BELNR = LT_ACCOUNTING_DOC_HDR-BELNR_R
      AND   GJAHR = LT_ACCOUNTING_DOC_HDR-GJAHR.

    SELECT MATNR
           MAKTX
    FROM MAKT
    INTO TABLE LT_MAT_DESC
    FOR ALL ENTRIES IN LT_RSEG
    WHERE MATNR = LT_RSEG-MATNR
    AND   SPRAS = SY-LANGU.

    SELECT MBLNR
           MJAHR
           XBLNR
           BKTXT
           FRBNR
      FROM MKPF
      INTO TABLE LT_MAT_DOC_HDR
      FOR ALL ENTRIES IN LT_RSEG
      WHERE MBLNR = LT_RSEG-LFBNR
    AND   MJAHR = LT_RSEG-LFGJA.

    SELECT MBLNR
           MJAHR
           ZEILE
           MATNR
           WERKS
           SGTXT
           GRUND
           WEMPF
      FROM MSEG
      INTO TABLE LT_MAT_DOC
      FOR ALL ENTRIES IN LT_RSEG
      WHERE MBLNR = LT_RSEG-LFBNR
    AND   MJAHR = LT_RSEG-LFGJA.


  ENDIF.

  LOOP AT LT_RSEG INTO LS_RSEG.
    LS_MATERIAL_DOC-BELNR       = LS_RSEG-BELNR.
    LS_MATERIAL_DOC-GJAHR       = LS_RSEG-GJAHR.
    LS_MATERIAL_DOC-BUZEI       = LS_RSEG-BUZEI.
    LS_MATERIAL_DOC-MBLNR       = LS_RSEG-LFBNR.
    LS_MATERIAL_DOC-MJAHR       = LS_RSEG-LFGJA.
*    ls_material_doc-zeile = ls_rseg-zeile.
    LS_MATERIAL_DOC-EBELN       = LS_RSEG-EBELN.
    LS_MATERIAL_DOC-EBELP       = LS_RSEG-EBELP.
    LS_MATERIAL_DOC-MATNR       = LS_RSEG-MATNR.
    LS_MATERIAL_DOC-MENGE       = LS_RSEG-MENGE.
    LS_MATERIAL_DOC-MEINS       = LS_RSEG-MEINS.
    LS_MATERIAL_DOC-STEUC       = LS_RSEG-HSN_SAC.
    LS_MATERIAL_DOC-WERKS       = LS_RSEG-WERKS.
    LS_MATERIAL_DOC-WRBTR       = LS_RSEG-WRBTR.
    LS_MATERIAL_DOC-KSCHL       = LS_RSEG-KSCHL.
    LS_MATERIAL_DOC_HDR-BELNR_R = LS_RSEG-BELNR.
    LS_MATERIAL_DOC_HDR-MWSKZ   = LS_RSEG-MWSKZ.


    LV_ID = LS_RSEG-MATNR.
    CLEAR: LT_LINES,LS_LINES.

    CLEAR  LV_LINES1.
    LO_TEXT_READER->READ_TEXT_STRING( EXPORTING ID = 'GRUN' NAME = LV_ID OBJECT = 'MATERIAL' IMPORTING LV_LINES = LV_LINES1 ).
    LS_MATERIAL_DOC-LONGTXT = LV_LINES1.
    CONDENSE LS_MATERIAL_DOC-LONGTXT.

**    CALL FUNCTION 'READ_TEXT'
**      EXPORTING
**        CLIENT                  = SY-MANDT
**        ID                      = 'GRUN'
**        LANGUAGE                = SY-LANGU
**        NAME                    = LV_ID
**        OBJECT                  = 'MATERIAL'
**      TABLES
**        LINES                   = LT_LINES
**      EXCEPTIONS
**        ID                      = 1
**        LANGUAGE                = 2
**        NAME                    = 3
**        NOT_FOUND               = 4
**        OBJECT                  = 5
**        REFERENCE_CHECK         = 6
**        WRONG_ACCESS_TO_ARCHIVE = 7
**        OTHERS                  = 8.
**    IF SY-SUBRC <> 0.
*** Implement suitable error handling here
**    ENDIF.
**    IF NOT LT_LINES IS INITIAL.
**      LOOP AT LT_LINES INTO LS_LINES.
**        IF NOT LS_LINES-TDLINE IS INITIAL.
**          REPLACE ALL OCCURRENCES OF '<&>' IN LS_LINES-TDLINE WITH '&'.
**          CONCATENATE LS_MATERIAL_DOC-LONGTXT LS_LINES-TDLINE INTO LS_MATERIAL_DOC-LONGTXT SEPARATED BY SPACE.
**        ENDIF.
**      ENDLOOP.
**      CONDENSE LS_MATERIAL_DOC-LONGTXT.
**    ENDIF.


    READ TABLE LT_RBKP INTO LS_RBKP WITH KEY BELNR = LS_RSEG-BELNR
                                             GJAHR = LS_RSEG-GJAHR.
    IF SY-SUBRC IS INITIAL.
      LS_MATERIAL_DOC_HDR-LIFNR   = LS_RBKP-LIFNR.
    ENDIF.
    READ TABLE LT_MAT_DESC INTO LS_MAT_DESC WITH KEY MATNR = LS_RSEG-MATNR.
    IF SY-SUBRC IS INITIAL.
      LS_MATERIAL_DOC-MAKTX = LS_MAT_DESC-MAKTX.
    ENDIF.

    READ TABLE LT_ACCOUNTING_DOC_HDR INTO LS_ACCOUNTING_DOC_HDR WITH KEY BELNR_R = LS_RSEG-BELNR.
    IF SY-SUBRC IS INITIAL.
      LS_MATERIAL_DOC_HDR-BELNR = LS_ACCOUNTING_DOC_HDR-BELNR.
      LS_MATERIAL_DOC_HDR-GJAHR = LS_ACCOUNTING_DOC_HDR-GJAHR.
      LS_MATERIAL_DOC_HDR-BUKRS = LS_ACCOUNTING_DOC_HDR-BUKRS.
      LS_MATERIAL_DOC-BUKRS     = LS_ACCOUNTING_DOC_HDR-BUKRS.
      LS_MATERIAL_DOC_HDR-BLDAT = LS_ACCOUNTING_DOC_HDR-BLDAT.
      LS_MATERIAL_DOC_HDR-BUDAT = LS_ACCOUNTING_DOC_HDR-BUDAT.

    ENDIF.

    READ TABLE LT_MAT_DOC INTO LS_MAT_DOC WITH KEY MBLNR = LS_RSEG-LFBNR
                                                   MJAHR = LS_RSEG-LFGJA.
*                                                   zeile = ls_rseg-lfpos.
    IF SY-SUBRC IS INITIAL.
      LS_MATERIAL_DOC_HDR-MBLNR = LS_MAT_DOC-MBLNR.
      LS_MATERIAL_DOC_HDR-MJAHR = LS_MAT_DOC-MJAHR.
      LS_MATERIAL_DOC_HDR-GRUND = LS_MAT_DOC-GRUND.
      LS_MATERIAL_DOC_HDR-SGTXT = LS_MAT_DOC-SGTXT.
      LS_MATERIAL_DOC_HDR-WEMPF = LS_MAT_DOC-WEMPF.
    ENDIF.

    READ TABLE LT_MAT_DOC_HDR INTO LS_MAT_DOC_HDR WITH KEY MBLNR = LS_RSEG-LFBNR
                                                           MJAHR = LS_RSEG-LFGJA.
    IF SY-SUBRC IS INITIAL.
      LS_MATERIAL_DOC_HDR-XBLNR = LS_MAT_DOC_HDR-XBLNR.
      LS_MATERIAL_DOC_HDR-BKTXT = LS_MAT_DOC_HDR-BKTXT.
      LS_MATERIAL_DOC_HDR-FRBNR = LS_MAT_DOC_HDR-FRBNR.
    ENDIF.



    APPEND LS_MATERIAL_DOC_HDR TO CT_HDR.

    LS_MATERIAL_DOC-RATE = LS_MATERIAL_DOC-WRBTR / LS_MATERIAL_DOC-MENGE.

    APPEND LS_MATERIAL_DOC TO CT_ITEM.

    CLEAR: LS_MATERIAL_DOC,LS_MATERIAL_DOC_HDR,LS_ACCOUNTING_DOC_HDR,LS_RSEG,LS_MAT_DOC_HDR,
           LS_MAT_DOC,LS_MATERIAL_DOC,LS_MAT_DESC.
  ENDLOOP.

  SORT CT_HDR BY BELNR.
  SORT CT_ITEM BY BELNR BUZEI.

  DELETE ADJACENT DUPLICATES FROM CT_HDR COMPARING BELNR .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_HDR  text
*      -->P_GT_ITEM  text
*----------------------------------------------------------------------*
FORM FORM_DISPLAY  USING    CT_HDR  TYPE ZT_MATERIAL_DOC_HDR
                            CT_ITEM TYPE ZT_MATERIAL_DOC.

  DATA:
*    lv_fname          TYPE tdsfname VALUE 'ZSF_PO_DEBIT_NOTE_GST',
*    lv_form           TYPE rs38l_fnam,
    LS_COMPOSER_PARAM TYPE SSFCOMPOP,
    GS_CON_SETTINGS   TYPE SSFCTRLOP.          "CONTROL SETTINGS FOR SMART FORMS

  DATA:
    LS_MATERIAL_DOC_HDR TYPE ZMATERIAL_DOC_HDR,
    LS_MATERIAL_DOC     TYPE ZMATERIAL_DOC,
    LT_HDR              TYPE ZT_MATERIAL_DOC_HDR,
    LT_ITEM             TYPE ZT_MATERIAL_DOC,
    GV_TOT_LINES        TYPE I,
    LV_INDEX            TYPE SY-TABIX,

    LWA_PARAM           TYPE SFPOUTPUTPARAMS,
    LV_FUNCNAME         TYPE FUNCNAME,
    LV_DOC_PARAMS       TYPE SFPDOCPARAMS,
    LS_FORM_OUTPUT      TYPE FPFORMOUTPUT,
    LV_FORM_NAME        TYPE FPNAME,
    GV_PAGE             TYPE CHAR30.


* created by supriya jagtap 18:06:2024
  IF R3 = 'X'.
    LV_FORM_NAME = 'ZSF_PO_DEBIT_NOTE_GST'.
  ELSEIF R4 = 'X'.
    LV_FORM_NAME = 'ZSF_PO_DEBIT_NOTE_GST_NEW'.
  ENDIF.


  LWA_PARAM-DEVICE = 'PRINTER'.

  LWA_PARAM-DEST = 'LP01'.

  IF SY-UCOMM = 'PRNT'.

    LWA_PARAM-NODIALOG = 'X'.

    LWA_PARAM-PREVIEW = ''.

    LWA_PARAM-REQIMM = 'X'.

  ELSE.

    LWA_PARAM-NODIALOG = ''.

    LWA_PARAM-PREVIEW = 'X'.

  ENDIF.





  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      IE_OUTPUTPARAMS = LWA_PARAM
    EXCEPTIONS
      CANCEL          = 1
      USAGE_ERROR     = 2
      SYSTEM_ERROR    = 3
      INTERNAL_ERROR  = 4
      OTHERS          = 5.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      I_NAME     = LV_FORM_NAME
    IMPORTING
      E_FUNCNAME = LV_FUNCNAME
*     E_INTERFACE_TYPE           =
*     EV_FUNCNAME_INBOUND        =
    .

*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = lv_fname
**     VARIANT            = ' '
**     DIRECT_CALL        = ' '
*    IMPORTING
*      fm_name            = lv_form
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

*  ls_composer_param-tdcopies = '5'.
*
*  DESCRIBE TABLE ct_hdr LINES gv_tot_lines.

  LOOP AT CT_HDR INTO LS_MATERIAL_DOC_HDR.

    DO 5 TIMES.
*  *** -- COPY RECEIPT
      IF SY-INDEX = 001.
        GV_PAGE = 'ORIGINAL FOR RECIPIENT'.
      ELSEIF SY-INDEX = 002.
        GV_PAGE = 'DUPLICATE FOR TRANSPORTER'.
      ELSEIF SY-INDEX = 003.
        GV_PAGE = 'TRIPLICATE FOR SUPPLIER'.
      ELSEIF SY-INDEX = 004.
        GV_PAGE = 'QUADRUPLICATE FOR ACCOUNT COPY'.
      ELSEIF SY-INDEX = 005.
        GV_PAGE = 'SECURITY COPY'.
      ENDIF.


      LV_INDEX = SY-TABIX.
      CLEAR LT_HDR[].
      APPEND LS_MATERIAL_DOC_HDR TO LT_HDR.

      LT_ITEM = CT_ITEM.
      DELETE LT_ITEM WHERE BELNR NE LS_MATERIAL_DOC_HDR-BELNR_R.
****  *&--FOR PRINTING CONTINUOS PAGES IN CASE RANGE IS GIVEN
*      IF lv_index = 1.
** DIALOG AT FIRST LOOP ONLY
*        gs_con_settings-no_dialog = abap_false.
** OPEN THE SPOOL AT THE FIRST LOOP ONLY:
*        gs_con_settings-no_open   = abap_false.
** CLOSE SPOOL AT THE LAST LOOP ONLY
*        gs_con_settings-no_close  = abap_true.
*      ELSE.
** DIALOG AT FIRST LOOP ONLY
*        gs_con_settings-no_dialog = abap_true.
** OPEN THE SPOOL AT THE FIRST LOOP ONLY:
*        gs_con_settings-no_open   = abap_true.
*      ENDIF.
*
*      IF lv_index = gv_tot_lines.
** CLOSE SPOOL
*        gs_con_settings-no_close  = abap_false.
*      ENDIF.

*      lv_word = gv_tot_wrd.

      CALL FUNCTION LV_FUNCNAME  "'/1BCDWB/SM00000121'
        EXPORTING
          /1BCDWB/DOCPARAMS   = LV_DOC_PARAMS
          GT_MATERIAL_DOC_HDR = LT_HDR
          GV_PAGE             = GV_PAGE
          GT_MATERIAL_DOC     = LT_ITEM
        IMPORTING
          /1BCDWB/FORMOUTPUT  = LS_FORM_OUTPUT
        EXCEPTIONS
          USAGE_ERROR         = 1
          SYSTEM_ERROR        = 2
          INTERNAL_ERROR      = 3
          OTHERS              = 4.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.




    ENDDO.
  ENDLOOP.

  CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

*    CALL FUNCTION lv_form "'/1BCDWB/SF00000055'
*      EXPORTING
*        control_parameters  = gs_con_settings
*        output_options      = ls_composer_param
*        user_settings       = space
*      TABLES
*        gt_material_doc_hdr = lt_hdr
*        gt_material_doc     = lt_item
*      EXCEPTIONS
*        formatting_error    = 1
*        internal_error      = 2
*        send_error          = 3
*        user_canceled       = 4
*        OTHERS              = 5.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
  CLEAR LS_MATERIAL_DOC_HDR.

*ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_HDR  text
*      <--P_GT_ITEM  text
*----------------------------------------------------------------------*
FORM GET_DATA .
  DATA:
    LT_ACCOUNTING_DOC_HDR  TYPE TT_ACCOUNTING_DOC_HDR.


  SELECT BUKRS
         BELNR
         GJAHR
         BLDAT
         BUDAT
         XBLNR
         BKTXT
         AWKEY
    FROM BKPF
    INTO TABLE LT_ACCOUNTING_DOC_HDR
    WHERE BELNR IN SO_BELNR
    AND   GJAHR = P_GJAHR
    AND   BUDAT IN SO_BUDAT
    AND   BLART IN ('KG','KR').

  IF NOT SY-SUBRC IS INITIAL.
    MESSAGE 'Please Check Input Data' TYPE 'E'.
  ENDIF.

  PERFORM LAYOUT_DISPLAY USING LT_ACCOUNTING_DOC_HDR.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_HDR  text
*      -->P_GT_ITEM  text
*----------------------------------------------------------------------*
FORM LAYOUT_DISPLAY USING CT_ACCOUNTING_DOC_HDR TYPE TT_ACCOUNTING_DOC_HDR.
  DATA:
    LS_ACCOUNTING_DOC_HDR TYPE T_ACCOUNTING_DOC_HDR,
*    lv_fname              TYPE tdsfname ,"VALUE 'ZVEN_DEBIT_NOTE_GST',
    GV_TOT_LINES          TYPE I,
*    lv_form               TYPE rs38l_fnam,
    LS_COMPOSER_PARAM     TYPE SSFCOMPOP,
    GS_CON_SETTINGS       TYPE SSFCTRLOP.          "CONTROL SETTINGS FOR SMART FORMS

  DATA : LWA_PARAM      TYPE SFPOUTPUTPARAMS,
         LV_FUNCNAME    TYPE FUNCNAME,
         LV_DOC_PARAMS  TYPE SFPDOCPARAMS,
         LS_FORM_OUTPUT TYPE FPFORMOUTPUT,
         LV_FORM_NAME   TYPE FPNAME,
         GV_PAGE        TYPE CHAR30.




* created by supriya jagtap 17:06:2024
*IF R3 = 'X'.
*  lv_fname = 'ZVEN_DEBIT_NOTE_GST'.
*   ELSEif r4 = 'X'.
*  lv_fname = 'ZVEN_DEBIT_NOTE_GST_NEW'.
*ENDIF.

  IF R3 = 'X'.
    LV_FORM_NAME = 'ZVEN_DEBIT_NOTE_GST'.
  ELSEIF R4 = 'X'.
    LV_FORM_NAME = 'ZVEN_DEBIT_NOTE_GST_NEW'.
  ENDIF.


  LWA_PARAM-DEVICE = 'PRINTER'.

  LWA_PARAM-DEST = 'LP01'.

  IF SY-UCOMM = 'PRNT'.

    LWA_PARAM-NODIALOG = 'X'.

    LWA_PARAM-PREVIEW = ''.

    LWA_PARAM-REQIMM = 'X'.

  ELSE.

    LWA_PARAM-NODIALOG = ''.

    LWA_PARAM-PREVIEW = 'X'.

  ENDIF.



  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      IE_OUTPUTPARAMS = LWA_PARAM
    EXCEPTIONS
      CANCEL          = 1
      USAGE_ERROR     = 2
      SYSTEM_ERROR    = 3
      INTERNAL_ERROR  = 4
      OTHERS          = 5.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      I_NAME     = LV_FORM_NAME
    IMPORTING
      E_FUNCNAME = LV_FUNCNAME
*     E_INTERFACE_TYPE           =
*     EV_FUNCNAME_INBOUND        =
    .




*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = lv_fname
**     VARIANT            = ' '
**     DIRECT_CALL        = ' '
*    IMPORTING
*      fm_name            = lv_form
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.


*  ls_composer_param-tdcopies = '5'.
*
*  DESCRIBE TABLE ct_accounting_doc_hdr LINES gv_tot_lines.

  LOOP AT CT_ACCOUNTING_DOC_HDR INTO LS_ACCOUNTING_DOC_HDR.

    DO 5 TIMES.
*  *** -- COPY RECEIPT
      IF SY-INDEX = 001.
        GV_PAGE = 'ORIGINAL FOR RECIPIENT'.
      ELSEIF SY-INDEX = 002.
        GV_PAGE = 'DUPLICATE FOR TRANSPORTER'.
      ELSEIF SY-INDEX = 003.
        GV_PAGE = 'TRIPLICATE FOR SUPPLIER'.
      ELSEIF SY-INDEX = 004.
        GV_PAGE = 'QUADRUPLICATE FOR ACCOUNT COPY'.
      ELSEIF SY-INDEX = 005.
        GV_PAGE = 'SECURITY COPY'.
      ENDIF.

*    IF sy-tabix = 1.
** DIALOG AT FIRST LOOP ONLY
*      gs_con_settings-no_dialog = abap_false.
** OPEN THE SPOOL AT THE FIRST LOOP ONLY:
*      gs_con_settings-no_open   = abap_false.
** CLOSE SPOOL AT THE LAST LOOP ONLY
*      gs_con_settings-no_close  = abap_true.
*    ELSE.
** DIALOG AT FIRST LOOP ONLY
*      gs_con_settings-no_dialog = abap_true.
** OPEN THE SPOOL AT THE FIRST LOOP ONLY:
*      gs_con_settings-no_open   = abap_true.
*    ENDIF.

*      IF sy-tabix = gv_tot_lines.
** CLOSE SPOOL
*        gs_con_settings-no_close  = abap_false.
*      ENDIF.

      CALL FUNCTION LV_FUNCNAME "'/1BCDWB/SM00000113'
        EXPORTING
          /1BCDWB/DOCPARAMS  = LV_DOC_PARAMS
          GV_PAGE            = GV_PAGE
          BELNR              = LS_ACCOUNTING_DOC_HDR-BELNR
          GJAHR              = LS_ACCOUNTING_DOC_HDR-GJAHR
        IMPORTING
          /1BCDWB/FORMOUTPUT = LS_FORM_OUTPUT
        EXCEPTIONS
          USAGE_ERROR        = 1
          SYSTEM_ERROR       = 2
          INTERNAL_ERROR     = 3
          OTHERS             = 4.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.



    ENDDO.
  ENDLOOP.

  CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


*    CALL FUNCTION lv_form "'/1BCDWB/SF00000058'
*      EXPORTING
*        control_parameters = gs_con_settings
*        output_options     = ls_composer_param
*        user_settings      = space
*        belnr              = ls_accounting_doc_hdr-belnr
*        gjahr              = ls_accounting_doc_hdr-gjahr
** IMPORTING
**       DOCUMENT_OUTPUT_INFO       =
**       JOB_OUTPUT_INFO    =
**       JOB_OUTPUT_OPTIONS =
*      EXCEPTIONS
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        OTHERS             = 5.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.

*    ENDLOOP.
ENDFORM.
