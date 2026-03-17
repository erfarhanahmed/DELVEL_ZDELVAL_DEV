*&---------------------------------------------------------------------*
*& Report ZQUALITY_CERTIFICATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquality_certificate.

TYPES: BEGIN OF ty_vbak,
         vbeln TYPE vbak-vbeln,
         kunnr TYPE vbak-kunnr,
         aufnr TYPE vbak-aufnr,
       END OF ty_vbak,

       BEGIN OF ty_vbap,
         vbeln TYPE vbap-vbeln,
         posnr TYPE vbap-posnr,
         matnr TYPE vbap-matnr,
       END OF ty_vbap,

       BEGIN OF ty_afru,
         aufnr TYPE afru-aufnr,
         budat TYPE afru-budat,
       END OF ty_afru,

       BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
       END OF ty_mara,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_afko,
         aufnr TYPE afko-aufnr,
         gamng TYPE afko-gamng,
       END OF ty_afko,

       BEGIN OF ty_afpo,
         aufnr TYPE afpo-aufnr,
         kdauf TYPE afpo-kdauf,
         kdpos TYPE afpo-kdpos,
       END OF ty_afpo,

       BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,
         name1 TYPE kna1-name1,
       END OF ty_kna1,

       BEGIN OF ty_vbkd,
         vbeln TYPE vbkd-vbeln,
         bstkd TYPE vbkd-bstkd,
         bstdk TYPE vbkd-bstdk,
       END OF ty_vbkd,

       BEGIN OF ty_final,
         vbeln TYPE vbak-vbeln,
         kunnr TYPE vbak-kunnr,
         aufnr TYPE vbak-aufnr,
         budat TYPE afru-budat,
         matnr TYPE mara-matnr,
         maktx TYPE makt-maktx,
         gamng TYPE afko-gamng,
         name1 TYPE kna1-name1,
         bstkd TYPE vbkd-bstkd,
         bstdk TYPE vbkd-bstdk,
         posnr TYPE vbap-posnr,
       END OF ty_final.

DATA: it_vbak  TYPE TABLE OF ty_vbak,
      wa_vbak  TYPE          ty_vbak,

      it_vbap  TYPE TABLE OF ty_vbap,
      wa_vbap  TYPE          ty_vbap,

      it_afru  TYPE TABLE OF ty_afru,
      wa_afru  TYPE          ty_afru,

      it_afpo  TYPE TABLE OF ty_afpo,
      wa_afpo  TYPE          ty_afpo,

      it_afko  TYPE TABLE OF ty_afko,
      wa_afko  TYPE          ty_afko,

      it_mara  TYPE TABLE OF ty_mara,
      wa_mara  TYPE          ty_mara,

      it_makt  TYPE TABLE OF ty_makt,
      wa_makt  TYPE          ty_makt,

      it_kna1  TYPE TABLE OF ty_kna1,
      wa_kna1  TYPE          ty_kna1,

      it_vbkd  TYPE TABLE OF ty_vbkd,
      wa_vbkd  TYPE          ty_vbkd,

      it_final TYPE TABLE OF zinter_change,
      wa_final TYPE          zinter_change.

DATA : fmname   TYPE rs38l_fnam,
       formname TYPE tdsfname ."VALUE 'ZINTER_CHANGE_CERT'.


SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS:p_aufnr TYPE afko-aufnr.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS:r1 RADIOBUTTON GROUP rg,
           r2 RADIOBUTTON GROUP rg,
           r3 RADIOBUTTON GROUP rg.
SELECTION-SCREEN:END OF BLOCK b2.



START-OF-SELECTION.
  PERFORM get_data.
  PERFORM sort_data.

  READ TABLE it_afpo INTO wa_afpo INDEX 1.
  IF sy-subrc = 0.
    IF wa_afpo-aufnr IS NOT INITIAL .
      PERFORM print.
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
*  BREAK FUJIABAP.
  SELECT aufnr
         gamng FROM afko INTO TABLE it_afko
         WHERE aufnr = p_aufnr.


  IF  it_afko IS NOT INITIAL.
    SELECT aufnr
           kdauf
           kdpos FROM afpo INTO TABLE it_afpo
           FOR ALL ENTRIES IN it_afko
           WHERE aufnr = it_afko-aufnr.

    SELECT aufnr
           budat FROM afru INTO TABLE it_afru
           FOR ALL ENTRIES IN it_afko
           WHERE aufnr = it_afko-aufnr.

  ENDIF.

  IF it_afpo IS NOT INITIAL .
    SELECT vbeln
           posnr
           matnr FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_afpo
           WHERE vbeln = it_afpo-kdauf
           AND   posnr = it_afpo-kdpos.

  ENDIF.

  IF  it_vbap IS NOT INITIAL.
    SELECT vbeln
           kunnr
           aufnr FROM vbak INTO TABLE it_vbak
           FOR ALL ENTRIES IN it_vbap
           WHERE vbeln = it_vbap-vbeln.

    SELECT vbeln
           bstkd
           bstdk FROM vbkd INTO TABLE it_vbkd
           FOR ALL ENTRIES IN it_vbap
           WHERE vbeln = it_vbap-vbeln.


    SELECT matnr
           maktx FROM makt INTO TABLE it_makt
           FOR ALL ENTRIES IN it_vbap
           WHERE matnr = it_vbap-matnr.

  ENDIF.

  IF  it_vbak IS NOT INITIAL.
    SELECT kunnr
           name1 FROM kna1 INTO TABLE it_kna1
           FOR ALL ENTRIES IN it_vbak
           WHERE kunnr = it_vbak-kunnr.

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
  LOOP AT it_afpo INTO wa_afpo.
    wa_final-aufnr = wa_afpo-aufnr.

    READ TABLE it_afko INTO wa_afko WITH KEY aufnr = wa_afpo-aufnr.
    IF sy-subrc = 0.
      wa_final-gamng = wa_afko-gamng.

    ENDIF.

    READ TABLE it_afru INTO wa_afru WITH KEY aufnr = wa_afpo-aufnr.
    IF sy-subrc = 0.
      wa_final-budat = wa_afru-budat.
    ENDIF.
    READ TABLE it_vbap INTO wa_vbap WITH KEY vbeln = wa_afpo-kdauf
                                             posnr = wa_afpo-kdpos.
    IF sy-subrc = 0.
      wa_final-vbeln = wa_vbap-vbeln.
      wa_final-matnr = wa_vbap-matnr.
      wa_final-posnr = wa_vbap-posnr.
    ENDIF.

    READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbap-vbeln.
    IF sy-subrc = 0.
      wa_final-kunnr = wa_vbak-kunnr.
    ENDIF.

    READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = wa_vbap-vbeln.
    IF sy-subrc = 0.
      wa_final-bstkd = wa_vbkd-bstkd.
      wa_final-bstdk = wa_vbkd-bstdk.

    ENDIF.

    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbak-kunnr.
    IF sy-subrc = 0.
      wa_final-name1 = wa_kna1-name1.
    ENDIF.

    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_vbap-matnr.
    IF sy-subrc = 0.
      wa_final-maktx = wa_makt-maktx.
    ENDIF.

  ENDLOOP.
  APPEND wa_final TO it_final.
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
  IF r1 = 'X'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = 'ZAFR_CERTIFICATE'
*     VARIANT  = ' '
*     DIRECT_CALL              = ' '
    IMPORTING
      fm_name  = fmname
* EXCEPTIONS
*     NO_FORM  = 1
*     NO_FUNCTION_MODULE       = 2
*     OTHERS   = 3
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  CALL FUNCTION fmname
    EXPORTING
*     ARCHIVE_INDEX              =
*     ARCHIVE_INDEX_TAB          =
*     ARCHIVE_PARAMETERS         =
*     CONTROL_PARAMETERS         =
*     MAIL_APPL_OBJ              =
*     MAIL_RECIPIENT             =
*     MAIL_SENDER                =
*     OUTPUT_OPTIONS             =
*     USER_SETTINGS              = 'X'
      wa_final = wa_final
* IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO            =
*     JOB_OUTPUT_OPTIONS         =
    TABLES
      it_final = it_final
* EXCEPTIONS
*     FORMATTING_ERROR           = 1
*     INTERNAL_ERROR             = 2
*     SEND_ERROR                 = 3
*     USER_CANCELED              = 4
*     OTHERS   = 5
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDIF.


********************************************SOV Certificate******************************************
IF r2 = 'X'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = 'ZSOV_CERTIFICATE'
*     VARIANT  = ' '
*     DIRECT_CALL              = ' '
    IMPORTING
      fm_name  = fmname
* EXCEPTIONS
*     NO_FORM  = 1
*     NO_FUNCTION_MODULE       = 2
*     OTHERS   = 3
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  CALL FUNCTION fmname
    EXPORTING
*     ARCHIVE_INDEX              =
*     ARCHIVE_INDEX_TAB          =
*     ARCHIVE_PARAMETERS         =
*     CONTROL_PARAMETERS         =
*     MAIL_APPL_OBJ              =
*     MAIL_RECIPIENT             =
*     MAIL_SENDER                =
*     OUTPUT_OPTIONS             =
*     USER_SETTINGS              = 'X'
      wa_final = wa_final
* IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO            =
*     JOB_OUTPUT_OPTIONS         =
    TABLES
      it_final = it_final
* EXCEPTIONS
*     FORMATTING_ERROR           = 1
*     INTERNAL_ERROR             = 2
*     SEND_ERROR                 = 3
*     USER_CANCELED              = 4
*     OTHERS   = 5
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDIF.

********************************************LSB Certificate******************************************

IF r3 = 'X'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = 'ZLSB_CERTIFICATE'
*     VARIANT  = ' '
*     DIRECT_CALL              = ' '
    IMPORTING
      fm_name  = fmname
* EXCEPTIONS
*     NO_FORM  = 1
*     NO_FUNCTION_MODULE       = 2
*     OTHERS   = 3
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  CALL FUNCTION fmname
    EXPORTING
*     ARCHIVE_INDEX              =
*     ARCHIVE_INDEX_TAB          =
*     ARCHIVE_PARAMETERS         =
*     CONTROL_PARAMETERS         =
*     MAIL_APPL_OBJ              =
*     MAIL_RECIPIENT             =
*     MAIL_SENDER                =
*     OUTPUT_OPTIONS             =
*     USER_SETTINGS              = 'X'
      wa_final = wa_final
* IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO            =
*     JOB_OUTPUT_OPTIONS         =
    TABLES
      it_final = it_final
* EXCEPTIONS
*     FORMATTING_ERROR           = 1
*     INTERNAL_ERROR             = 2
*     SEND_ERROR                 = 3
*     USER_CANCELED              = 4
*     OTHERS   = 5
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDIF.





ENDFORM.
