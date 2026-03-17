*&---------------------------------------------------------------------*
*& Report ZINTER_CHANGE_CERT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZINTER_CHANGE_CERT.

TYPES: BEGIN OF TY_VBAK,
       VBELN TYPE VBAK-VBELN,
       KUNNR TYPE VBAK-KUNNR,
       AUFNR TYPE VBAK-AUFNR,
       END OF TY_VBAK,

       BEGIN OF TY_VBAP,
       VBELN TYPE VBAP-VBELN,
       POSNR TYPE VBAP-POSNR,
       MATNR TYPE VBAP-MATNR,
       END OF TY_VBAP,

       BEGIN OF TY_AFRU,
       AUFNR TYPE AFRU-AUFNR,
       BUDAT TYPE AFRU-BUDAT,
       END OF TY_AFRU,

       BEGIN OF TY_MARA,
       MATNR TYPE MARA-MATNR,
       END OF TY_MARA,

       BEGIN OF TY_MAKT,
       MATNR TYPE MAKT-MATNR,
       MAKTX TYPE MAKT-MAKTX,
       END OF TY_MAKT,

       BEGIN OF TY_AFKO,
       AUFNR TYPE AFKO-AUFNR,
       GAMNG TYPE AFKO-GAMNG,
       END OF TY_AFKO,

       BEGIN OF TY_AFPO,
       AUFNR TYPE AFPO-AUFNR,
       KDAUF TYPE AFPO-KDAUF,
       KDPOS TYPE AFPO-KDPOS,
       END OF TY_AFPO,

       BEGIN OF TY_KNA1,
       KUNNR TYPE KNA1-KUNNR,
       NAME1 TYPE KNA1-NAME1,
       END OF TY_KNA1,

       BEGIN OF TY_VBKD,
       VBELN TYPE VBKD-VBELN,
       BSTKD TYPE VBKD-BSTKD,
       BSTDK TYPE VBKD-BSTDK,
       END OF TY_VBKD,

       BEGIN OF TY_FINAL,
       VBELN TYPE VBAK-VBELN,
       KUNNR TYPE VBAK-KUNNR,
       AUFNR TYPE VBAK-AUFNR,
       BUDAT TYPE AFRU-BUDAT,
       MATNR TYPE MARA-MATNR,
       MAKTX TYPE MAKT-MAKTX,
       GAMNG TYPE AFKO-GAMNG,
       NAME1 TYPE KNA1-NAME1,
       BSTKD TYPE VBKD-BSTKD,
       BSTDK TYPE VBKD-BSTDK,
       END OF TY_FINAL.

 DATA: IT_VBAK TYPE TABLE OF TY_VBAK,
       WA_VBAK TYPE          TY_VBAK,

       IT_VBAP TYPE TABLE OF TY_VBAP,
       WA_VBAP TYPE          TY_VBAP,

       IT_AFRU TYPE TABLE OF TY_AFRU,
       WA_AFRU TYPE          TY_AFRU,

       IT_AFPO TYPE TABLE OF TY_AFPO,
       WA_AFPO TYPE          TY_AFPO,

       IT_AFKO TYPE TABLE OF TY_AFKO,
       WA_AFKO TYPE          TY_AFKO,

       GT_EKKN TYPE STANDARD TABLE OF EKKN,"ADDE DB JYOTI ON 26.11.2024
       WA_EKKN TYPE EKKN,

       IT_MARA TYPE TABLE OF TY_MARA,
       WA_MARA TYPE          TY_MARA,

       IT_MAKT TYPE TABLE OF TY_MAKT,
       WA_MAKT TYPE          TY_MAKT,

       IT_KNA1 TYPE TABLE OF TY_KNA1,
       WA_KNA1 TYPE          TY_KNA1,

       IT_VBKD TYPE TABLE OF TY_VBKD,
       WA_VBKD TYPE          TY_VBKD,

       IT_FINAL TYPE TABLE OF ZINTER_CHANGE,
       WA_FINAL TYPE          ZINTER_CHANGE.

*DATA : fmname        type rs38l_fnam,
*       FORMNAME TYPE TDSFNAME VALUE 'ZINTER_CHANGE_CERT'.


SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS:P_AUFNR TYPE AFKO-AUFNR.
*              p_ebEln TYPE ekkn-ebeln.  "ADDED BY JYOTI ON 12.11.2024
SELECTION-SCREEN: END OF BLOCK B1.


START-OF-SELECTION.
PERFORM GET_DATA.
PERFORM SORT_DATA.

READ TABLE IT_AFPO INTO WA_AFPO INDEX 1.
 IF SY-SUBRC = 0.
   IF WA_AFPO-AUFNR IS NOT INITIAL .
     PERFORM PRINT.
   ELSE.
     MESSAGE 'Order is not con' TYPE 'E'.
   ENDIF.

 ENDIF.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*  BREAK FUJIABAP.4
*********************************added by jyoti on 26.11.2024***********************
*if P_AUFNR IS NOT INITIAL and P_EBELN IS not INITIAL.
*   SELECT EBELN VBELN VBELP FROM EKKN INTO CORRESPONDING FIELDS OF TABLE GT_EKKN
*       WHERE EBELN = P_EBELN.
*      SELECT AUFNR FROM AFPO
*         INTO @data(wa_AUFNR)
*         FOR ALL ENTRIES IN @GT_EKKN
*          WHERE KDAUF = @GT_EKKN-VBELN
*          AND  KDPOS = @GT_EKKN-VBELP.
*         ENDSELECT.
*         if P_aufnr ne wa_AUFNR.
*           MESSAGE 'Please check Production Order no is related to Po no' type 'E'.
*         endif.
*
*endif.


*  IF P_AUFNR IS INITIAL.
*    SELECT EBELN VBELN VBELP FROM EKKN INTO CORRESPONDING FIELDS OF TABLE GT_EKKN
*       WHERE EBELN = P_EBELN.
*
*      SELECT AUFNR
*          FROM AFPO
*        INTO P_AUFNR
*        FOR ALL ENTRIES IN GT_EKKN
*        WHERE KDAUF = GT_EKKN-VBELN
*        AND KDPOS = GT_EKKN-VBELP.
*   ENDSELECT.
*  ENDIF.
***************************************************************************************
  SELECT AUFNR
         GAMNG FROM AFKO INTO TABLE IT_AFKO
         WHERE AUFNR = P_AUFNR.


 IF  IT_AFKO IS NOT INITIAL.
   SELECT AUFNR
          KDAUF
          KDPOS FROM AFPO INTO TABLE IT_AFPO
          FOR ALL ENTRIES IN IT_AFKO
          WHERE AUFNR = IT_AFKO-AUFNR.

   SELECT AUFNR
          BUDAT FROM AFRU INTO TABLE IT_AFRU
          FOR ALL ENTRIES IN IT_AFKO
          WHERE AUFNR = IT_AFKO-AUFNR.

 ENDIF.

 IF IT_AFPO IS NOT INITIAL .
   SELECT VBELN
          POSNR
          MATNR FROM VBAP INTO TABLE IT_VBAP
          FOR ALL ENTRIES IN IT_AFPO
          WHERE VBELN = IT_AFPO-KDAUF
          AND   POSNR = IT_AFPO-KDPOS.

 ENDIF.

 IF  IT_VBAP IS NOT INITIAL.
   SELECT VBELN
          KUNNR
          AUFNR FROM VBAK INTO TABLE IT_VBAK
          FOR ALL ENTRIES IN IT_VBAP
          WHERE VBELN = IT_VBAP-VBELN.

   SELECT VBELN
          BSTKD
          BSTDK FROM VBKD INTO TABLE IT_VBKD
          FOR ALL ENTRIES IN IT_VBAP
          WHERE VBELN = IT_VBAP-VBELN.


   SELECT MATNR
          MAKTX FROM MAKT INTO TABLE IT_MAKT
          FOR ALL ENTRIES IN IT_VBAP
          WHERE MATNR = IT_VBAP-MATNR.

 ENDIF.

 IF  IT_VBAK IS NOT INITIAL.
   SELECT KUNNR
          NAME1 FROM KNA1 INTO TABLE IT_KNA1
          FOR ALL ENTRIES IN IT_VBAK
          WHERE KUNNR = IT_VBAK-KUNNR.

 ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort_data .
 LOOP AT IT_AFPO INTO WA_AFPO.
   WA_FINAL-AUFNR = WA_AFPO-AUFNR.
   WA_FINAL-KDPOS =  WA_AFPO-KDPOS.

   READ TABLE IT_AFKO INTO WA_AFKO WITH KEY AUFNR = WA_AFPO-AUFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-GAMNG = WA_AFKO-GAMNG.

    ENDIF.

   READ TABLE IT_AFRU INTO WA_AFRU WITH KEY AUFNR = WA_AFPO-AUFNR.
    IF SY-SUBRC = 0.
      WA_FINAL-BUDAT = WA_AFRU-BUDAT.
    ENDIF.
   READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_AFPO-KDAUF
                                            POSNR = WA_AFPO-KDPOS.
    IF SY-SUBRC = 0.
      WA_FINAL-VBELN = WA_VBAP-VBELN.
      WA_FINAL-MATNR = WA_VBAP-MATNR.

    ENDIF.

   READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_VBAP-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR = WA_VBAK-KUNNR.
    ENDIF.

   READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_VBAP-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-BSTKD = WA_VBKD-BSTKD.
      WA_FINAL-BSTDK = WA_VBKD-BSTDK.

    ENDIF.

   READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_VBAK-KUNNR.
    IF SY-SUBRC = 0.
      WA_FINAL-NAME1 = WA_KNA1-NAME1.
    ENDIF.

   READ TABLE IT_MAKT INTO WA_MAKT WITH KEY MATNR = WA_VBAP-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-MAKTX = WA_MAKT-MAKTX.
    ENDIF.

 ENDLOOP.
 APPEND WA_FINAL TO IT_FINAL.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print .

Data : lwa_param      TYPE sfpoutputparams,
       lv_doc_params  TYPE sfpdocparams,
       ls_form_output TYPE fpformoutput,
       lv_funcname    TYPE funcname.

lwa_param-DEVICE = 'PRINTER'.
lwa_param-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.
lwa_param-NODIALOG = 'X'.
lwa_param-PREVIEW = ''.
lwa_param-REQIMM = 'X'.
ELSE.
lwa_param-NODIALOG = ''.
lwa_param-PREVIEW = 'X'.
ENDIF.





CALL FUNCTION 'FP_JOB_OPEN'
  CHANGING
    ie_outputparams       = lwa_param
 EXCEPTIONS
   CANCEL                = 1
   USAGE_ERROR           = 2
   SYSTEM_ERROR          = 3
   INTERNAL_ERROR        = 4
   OTHERS                = 5
          .
IF sy-subrc <> 0.
MESSAGE 'Error initializing Adobe form' TYPE 'E'.
ENDIF.

CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    i_name                     = 'ZINTER_CHANGE_CERT'
 IMPORTING
   E_FUNCNAME                 = lv_funcname
*   E_INTERFACE_TYPE           =
*   EV_FUNCNAME_INBOUND        =
          .

CALL FUNCTION lv_funcname    "'/1BCDWB/SM00000062'
  EXPORTING
   /1BCDWB/DOCPARAMS         = lv_doc_params
    it_final                 = IT_FINAL
    wa_final                 = WA_FINAL
 IMPORTING
   /1BCDWB/FORMOUTPUT       = ls_form_output
 EXCEPTIONS
   USAGE_ERROR              = 1
   SYSTEM_ERROR             = 2
   INTERNAL_ERROR           = 3
   OTHERS                   = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
 EXCEPTIONS
   USAGE_ERROR          = 1
   SYSTEM_ERROR         = 2
   INTERNAL_ERROR       = 3
   OTHERS               = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.



**************************************************************** Smartform********************

*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*  EXPORTING
*    formname                 = FORMNAME
**   VARIANT                  = ' '
**   DIRECT_CALL              = ' '
* IMPORTING
*   FM_NAME                  = fmname
** EXCEPTIONS
**   NO_FORM                  = 1
**   NO_FUNCTION_MODULE       = 2
**   OTHERS                   = 3
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.
*CALL FUNCTION fmname
* EXPORTING
**   ARCHIVE_INDEX              =
**   ARCHIVE_INDEX_TAB          =
**   ARCHIVE_PARAMETERS         =
**   CONTROL_PARAMETERS         =
**   MAIL_APPL_OBJ              =
**   MAIL_RECIPIENT             =
**   MAIL_SENDER                =
**   OUTPUT_OPTIONS             =
**   USER_SETTINGS              = 'X'
*    WA_FINAL                   = WA_FINAL
** IMPORTING
**   DOCUMENT_OUTPUT_INFO       =
**   JOB_OUTPUT_INFO            =
**   JOB_OUTPUT_OPTIONS         =
*  TABLES
*    it_final                   = IT_FINAL
** EXCEPTIONS
**   FORMATTING_ERROR           = 1
**   INTERNAL_ERROR             = 2
**   SEND_ERROR                 = 3
**   USER_CANCELED              = 4
**   OTHERS                     = 5
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.
*


ENDFORM.
