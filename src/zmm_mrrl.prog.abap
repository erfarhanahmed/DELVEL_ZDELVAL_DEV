*&---------------------------------------------------------------------*
*& Report  ZMM_MRRL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

*************REPORT CREATED BY RANI E.******************************

REPORT ZMM_MRRL.

TABLES: EKBE,
        EKRS,
        /SAPPSPRO/EADD,
        RM08E,
        mkpf,
        ESSR.                         "ERS-Verfahren: Belegabgrenzung
TABLES: EKBZ,
        EKRSDC,
        ERPTM_IV_DATA.
TYPE-POOLS:  IMREP,
             SLIS.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK AUSWAHL WITH FRAME TITLE TEXT-050.
SELECT-OPTIONS:
      BUKRS FOR EKRS-BUKRS DEFAULT '1000' MEMORY ID BUK,
      WERKS FOR EKBE-WERKS DEFAULT 'PL01' MEMORY ID WRK,
      BUDAT FOR EKRS-BUDAT,
      MBLNR FOR EKRS-BELNR, "OBLIGATORY,
      MJAHR FOR EKRS-GJAHR DEFAULT sy-datum+(4), "OBLIGATORY,
      LIFNR FOR EKRS-LIFNR MATCHCODE OBJECT KRED MEMORY ID LIF,
      EBELN FOR EKRS-EBELN,
      EBELP FOR EKRS-EBELP,
*      LBLNI FOR ESSR-LBLNI, Commented by NIlay B. on 25.08.2023
      budat1 for mkpf-budat OBLIGATORY default sy-datum no-extension no intervals.
SELECTION-SCREEN END OF BLOCK AUSWAHL.


* Art Belegabgrenzung
SELECTION-SCREEN BEGIN OF BLOCK VERARBEITUNG WITH FRAME TITLE TEXT-051.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: ERSDC TYPE XFELD AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN COMMENT (79) TEXT-011 FOR FIELD ERSDC.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK VERARBEITUNG.

SELECTION-SCREEN BEGIN OF BLOCK anzeigen WITH FRAME TITLE TEXT-052.
PARAMETERS:
* Anzeigevariante
  pa_varia LIKE disvariant-variant no-display.
SELECTION-SCREEN END OF BLOCK anzeigen.


INITIALIZATION.

*SELECT * from mkpf into TABLE @data(it_mkpf_date)
*  where mblnr in @MBLNR.
*
*  if it_mkpf_Date is NOT INITIAL.
*    LOOP AT it_mkpf_date INTO data(wa).
*      if budat1 lt wa-budat.
*        MESSAGE 'Posting Date is less than Grn Date' TYPE 'E'.
*      endif.
*    endloop.
*
*  endif.


START-OF-SELECTION.


  PERFORM GET_DATA.

*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA .
*      cl_salv_bs_runtime_info=>set(
*                EXPORTING display  = abap_true
*                          metadata = abap_true
*                          data     = abap_true ).




  IF ERSDC = 'X'.

    SUBMIT ZRMMR1MRS01
      WITH B_BUKRS  IN BUKRS
      WITH B_WERKS  IN WERKS
      WITH b_budat  IN budat
      WITH b_mblnr  IN mblnr
      WITH B_MJAHR  IN MJAHR
      WITH B_LIFNR  IN LIFNR
      WITH B_EBELN  IN EBELN
      WITH B_EBELP  IN EBELP
*      WITH B_LBLNI  IN LBLNI  "Commented by Nilay On 25.08.2023
      with budat1   in budat1
      WITH ERSBA    EQ ''
      WITH ersba_tx EQ ''
      WITH P_ERSDC  EQ 'X'
      with pa_varia eq ''.

  ELSE.

    SUBMIT ZRMMR1MRS01
       WITH B_BUKRS  IN BUKRS
       WITH B_WERKS  IN WERKS
       WITH B_BUDAT  IN BUDAT
       WITH B_MBLNR  IN MBLNR
       WITH B_MJAHR  IN MJAHR
       WITH B_LIFNR  IN LIFNR
       WITH B_EBELN  IN EBELN
       WITH B_EBELP  IN EBELP
*       WITH B_LBLNI  IN LBLNI "Commented by Nilay On 25.08.2023
       with budat1   in budat1
       "WITH ERSBA    EQ '4'
      " WITH ersba_tx EQ ''
       WITH P_ERSDC  EQ ''.


  ENDIF.
  IF SY-SUBRC = 0.

  ENDIF.

ENDFORM.
