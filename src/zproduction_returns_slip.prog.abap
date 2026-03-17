*&---------------------------------------------------------------------*
*& Report ZPRODUCTION_RETURNS_SLIP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zproduction_returns_slip.

TABLES : mseg.

TYPES: BEGIN OF ty_mseg,
         mblnr TYPE mseg-mblnr,
         matnr TYPE mseg-matnr,
         mjahr TYPE mseg-mjahr,
         menge TYPE mseg-menge,
         aufnr TYPE mseg-aufnr,
         sgtxt TYPE mseg-sgtxt,
*       xauto TYPE mseg-xauto,
         lgort TYPE mseg-lgort,
       END OF ty_mseg,

       BEGIN OF ty_mseg1,
         mblnr TYPE mseg-mblnr,
         aufnr TYPE mseg-aufnr,
       END OF ty_mseg1,


       BEGIN OF ty_mkpf,
         mblnr TYPE mkpf-mblnr,
         bldat TYPE mkpf-bldat,
         xblnr TYPE mkpf-xblnr,
         bktxt TYPE mkpf-bktxt,
       END OF ty_mkpf,

       BEGIN OF ty_mbew,
         matnr TYPE mbew-matnr,
         bwkey TYPE mbew-bwkey,
         vprsv TYPE mbew-vprsv,
         verpr TYPE mbew-verpr,
         stprs TYPE mbew-stprs,
       END OF ty_mbew,

       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         labst TYPE mard-labst,
         lgpbe TYPE mard-lgpbe,
       END OF ty_mard,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt.

DATA : doc_no TYPE mseg-mblnr.

*       BEGIN OF ty_final,
*       mblnr TYPE mseg-mblnr,
*       matnr TYPE mseg-matnr,
*       mjahr TYPE mkpf-mjahr,
*       menge TYPE mseg-menge,
*       aufnr TYPE mseg-aufnr,
*       sgtxt TYPE mseg-sgtxt,
*       bldat TYPE mkpf-bldat,
*       xblnr TYPE mkpf-xblnr,
*       bktxt TYPE mkpf-bktxt,
*       vprsv TYPE mbew-vprsv,
*       verpr TYPE mbew-verpr,
*       stprs TYPE mbew-stprs,
*       maktx TYPE makt-maktx,
*       END OF ty_final.

DATA : it_mseg  TYPE TABLE OF ty_mseg,
       wa_mseg  TYPE          ty_mseg,

       it_mkpf  TYPE TABLE OF ty_mkpf,
       wa_mkpf  TYPE          ty_mkpf,

       it_mbew  TYPE TABLE OF ty_mbew,
       wa_mbew  TYPE          ty_mbew,

       it_makt  TYPE TABLE OF ty_makt,
       wa_makt  TYPE          ty_makt,

       it_mard  TYPE TABLE OF ty_mard,
       wa_mard  TYPE          ty_mard,

       it_mseg1 TYPE TABLE OF ty_mseg1,
       wa_mseg1 TYPE          ty_mseg1,

       lt_final TYPE TABLE OF zprod_ret_slip,
       ls_final TYPE          zprod_ret_slip.


DATA : fmname   TYPE rs38l_fnam,
       formname TYPE tdsfname VALUE 'ZPRODUCTION_RETURNS_SLIP'.

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS :s_mblnr TYPE mseg-mblnr OBLIGATORY,
              p_year  TYPE mseg-mjahr OBLIGATORY.
SELECTION-SCREEN:END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM get_form.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*break primus.
  SELECT mblnr
         matnr
         mjahr
         menge
         aufnr
         sgtxt
         lgort
         FROM mseg INTO TABLE it_mseg
         WHERE mblnr = s_mblnr
         AND   mjahr = p_year
          AND   xauto = 'X'.   ""commented by mahadev on 28-04-2025

  IF it_mseg IS NOT INITIAL .
    SELECT mblnr
           bldat
           xblnr
           bktxt FROM mkpf INTO TABLE it_mkpf
           FOR ALL ENTRIES IN it_mseg
           WHERE mblnr = it_mseg-mblnr.

    SELECT matnr
           bwkey
           vprsv
           verpr
           stprs FROM mbew INTO TABLE it_mbew
           FOR ALL ENTRIES IN it_mseg
           WHERE matnr = it_mseg-matnr
           AND bwkey = 'PL01'.         "Added by PB 06/05/2019

    SELECT matnr
           maktx FROM makt INTO TABLE it_makt
           FOR ALL ENTRIES IN it_mseg
           WHERE matnr = it_mseg-matnr.

    SELECT matnr
           werks
           lgort
           labst
           lgpbe FROM mard INTO TABLE it_mard
           FOR ALL ENTRIES IN it_mseg
           WHERE matnr = it_mseg-matnr
           AND lgort IN ('RM01','KRM0') " added  by pm on 26.06.2024
           AND werks = 'PL01' . " added by sagar darade on 17/03/2026


  ENDIF.
*
*IF it_mkpf IS NOT INITIAL.
*  SELECT mblnr
*         aufnr FROM mseg INTO TABLE it_mseg1
*         FOR ALL ENTRIES IN it_mkpf
*         WHERE mblnr = it_mkpf-bktxt.
*
*ENDIF.

  LOOP AT it_mseg INTO wa_mseg.
    ls_final-matnr = wa_mseg-matnr.
    ls_final-menge = wa_mseg-menge.
    ls_final-aufnr = wa_mseg-aufnr.          ""ADDED BY MAHADEV ON 28-04-2025
    ls_final-sgtxt = wa_mseg-sgtxt.

*    BREAK PRIMUSABAP.
    IF wa_mseg-lgort+0(1) EQ 'K'.                 " ADDED BY PRANIT 25.07.2024
      ls_final-lgort = 'KRM0'.
    ELSEIF
      wa_mseg-lgort NE 'K' .
      ls_final-lgort = 'RM01'.
    ENDIF.

    READ TABLE it_mkpf INTO wa_mkpf WITH KEY mblnr = wa_mseg-mblnr.
    IF sy-subrc = 0.
      ls_final-mblnr = wa_mkpf-mblnr.
      ls_final-bldat = wa_mkpf-bldat.
      ls_final-bktxt = wa_mkpf-bktxt.
      ls_final-xblnr = wa_mkpf-xblnr.
    ENDIF.

    READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_mseg-matnr.
    IF sy-subrc = 0.
      IF wa_mbew-vprsv = 'S' .
        ls_final-rate = wa_mbew-stprs.
      ELSE.
        ls_final-rate = wa_mbew-verpr.
      ENDIF.
    ENDIF.

    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mseg-matnr.
    IF sy-subrc = 0.
      ls_final-maktx = wa_makt-maktx.

    ENDIF.
*BREAK PRIMUSABAP.
    READ TABLE it_mard INTO wa_mard WITH KEY matnr = wa_mseg-matnr
                                             lgort = ls_final-lgort.
    IF sy-subrc = 0.
      ls_final-lgpbe = wa_mard-lgpbe. " Added by sagar darade on 17/03/2026 to get storage bin
      IF ls_final-lgort = 'RM01' .
        ls_final-labst = wa_mard-labst.
      ELSEIF
        ls_final-lgort = 'KRM0' .        " ADDED BY PRANIT 25.07.2024
        ls_final-labst = wa_mard-labst.
      ENDIF.
    ELSE.
      CLEAR : ls_final-labst.




    ENDIF.

*break primus.
    doc_no = wa_mkpf-bktxt.

    SELECT mblnr
           aufnr FROM mseg INTO TABLE it_mseg1

           WHERE mblnr = doc_no.

    READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY mblnr = doc_no.
    IF sy-subrc = 0.
      ls_final-aufnr = wa_mseg1-aufnr.

    ENDIF.
    ls_final-amt = ls_final-menge * ls_final-rate.
    APPEND ls_final TO lt_final.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_form .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = formname
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
      ls_final = ls_final
* IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO            =
*     JOB_OUTPUT_OPTIONS         =
    TABLES
      lt_final = lt_final
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


ENDFORM.
