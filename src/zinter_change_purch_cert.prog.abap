*&---------------------------------------------------------------------*
*& Report ZINTER_CHANGE_CERT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZINTER_CHANGE_PURCH_CERT.

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

       BEGIN OF TY_ekkn,
       ebeln TYPE ekkn-ebeln,
       ebelp TYPE ekkn-ebelp,
       vbeln TYPE ekkn-vbeln,
       vbelp TYPE ekkn-vbelp,
       END OF TY_ekkn,

       BEGIN OF TY_MARA,
       MATNR TYPE MARA-MATNR,
       END OF TY_MARA,

       BEGIN OF TY_MAKT,
       MATNR TYPE MAKT-MATNR,
       MAKTX TYPE MAKT-MAKTX,
       END OF TY_MAKT,

       BEGIN OF TY_ekKO,
       ebeln TYPE ekKO-ebeln,
       aedat TYPE ekKO-aedat,
       END OF TY_ekKO,

       BEGIN OF TY_ekpo,
       ebeln TYPE ekpo-ebeln,
       ebelp TYPE ekpo-ebelp,
       menge TYPE ekpo-menge,
       END OF TY_ekPO,

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

       IT_ekkn TYPE TABLE OF TY_ekkn,
       WA_ekkn TYPE          TY_ekkn,

       IT_ekPO TYPE TABLE OF TY_ekPO,
       WA_ekPO TYPE          TY_ekPO,

       IT_ekKO TYPE TABLE OF TY_ekKO,
       WA_ekKO TYPE          TY_ekKO,

*       GT_EKKN TYPE STANDARD TABLE OF EKKN,
*       WA_EKKN TYPE EKKN,

       IT_MARA TYPE TABLE OF TY_MARA,
       WA_MARA TYPE          TY_MARA,

       IT_MAKT TYPE TABLE OF TY_MAKT,
       WA_MAKT TYPE          TY_MAKT,

       IT_KNA1 TYPE TABLE OF TY_KNA1,
       WA_KNA1 TYPE          TY_KNA1,

       IT_VBKD TYPE TABLE OF TY_VBKD,
       WA_VBKD TYPE          TY_VBKD,

       IT_FINAL TYPE TABLE OF ZINTER_CHANGE_po,
       WA_FINAL TYPE          ZINTER_CHANGE_po.

DATA : fmname        type rs38l_fnam,
       FORMNAME TYPE TDSFNAME VALUE 'ZINTER_CHANGE_CERT_PO'.


SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_ebEln TYPE ekkn-ebeln,
              P_EBELP TYPE ekkn-ebelp.
SELECTION-SCREEN: END OF BLOCK B1.


START-OF-SELECTION.
PERFORM GET_DATA.
PERFORM SORT_DATA.

READ TABLE IT_ekkn INTO WA_ekkn INDEX 1.
 IF SY-SUBRC is INITIAL.
   if wa_ekkn-vbeln is not INITIAL.
   IF WA_ekkn-ebeln IS NOT INITIAL .
     PERFORM PRINT.
   endif.
   ELSE.
     MESSAGE 'Sale sorder is not refrence to Purchase order' TYPE 'E'.
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
*
  SELECT ebeln
         ebelp
         vbeln
         vbelp
         FROM ekkn
         INTO TABLE IT_ekkn
         WHERE ebeln = P_ebeln
         and ebelp = P_ebelp.


 IF  IT_ekkn IS NOT INITIAL.


   SELECT ebeln
          aedat
      FROM ekko INTO TABLE IT_ekko
          FOR ALL ENTRIES IN IT_ekkn
          WHERE ebeln = IT_ekkn-ebeln.

     select ebeln
            ebelp
            menge
            from ekpo
            INTO TABLE it_ekpo
            FOR ALL ENTRIES IN it_ekkn
            where ebeln = it_ekkn-ebeln
            and ebelp = it_ekkn-ebelp.

   SELECT VBELN
          POSNR
          MATNR FROM VBAP INTO TABLE IT_VBAP
          FOR ALL ENTRIES IN IT_ekkn
          WHERE VBELN = IT_ekkn-vbeln
          AND   POSNR = IT_ekkn-vbelp.

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
*  BREAK-POINT.
 LOOP AT IT_ekkn INTO WA_ekkn.
   WA_FINAL-ebeln = WA_ekkn-ebeln.
*   WA_FINAL-ebelp = WA_ekkn-ebelp.
   WA_FINAL-VBELp = WA_ekkn-VBELp.

   READ TABLE it_ekpo INTO WA_ekpo WITH KEY ebeln = WA_ekkn-ebeln
                                           ebelp = WA_ekkn-ebelp.
    IF SY-SUBRC is INITIAL.
      WA_FINAL-menge = WA_ekpo-menge.

    ENDIF.

   READ TABLE IT_ekko INTO WA_ekko WITH KEY ebeln = WA_ekkn-ebeln.
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-AEDAT = WA_ekko-aeDAT.
    ENDIF.
   READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_ekkn-vbeln
                                            POSNR = WA_ekkn-vbelp.
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
APPEND WA_FINAL TO IT_FINAL.
 ENDLOOP.

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
      i_name                     = 'ZINTER_CHANGE_CERT_PO'
   IMPORTING
     E_FUNCNAME                 = lv_funcname
*     E_INTERFACE_TYPE           =
*     EV_FUNCNAME_INBOUND        =
            .

  CALL FUNCTION lv_funcname   "'/1BCDWB/SM00000064'
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
*   IMPORTING
*     E_RESULT             =
   EXCEPTIONS
     USAGE_ERROR          = 1
     SYSTEM_ERROR         = 2
     INTERNAL_ERROR       = 3
     OTHERS               = 4
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.




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



ENDFORM.
