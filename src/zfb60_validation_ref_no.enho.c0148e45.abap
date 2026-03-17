"Name: \PR:SAPMF05A\FO:PAI_OKCODE_SEND_AT_PAI\SE:BEGIN\EI
ENHANCEMENT 0 ZFB60_VALIDATION_REF_NO.
*
*------Enhancemenrt for Dupblicate referene number----------------*
*&Transaction :FB60
*&Functional Cosultant: Sharadha Koli
*&Technical Consultant: Jyoti MAhajan
*&TR: 1.        PRIMUSABAP   PRIMUS:INDIA:101690:FB60:VALIDATION FOR REFERENCE NUMBER
*&Date: 1. 21/02/2025
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
DATA : lt_bkpf TYPE STANDARD TABLE OF bkpf,                                    " added by sonu
       lt_bseg TYPE STANDARD TABLE OF bseg.                                   " added by sonu
**IF ok-code = 'BS' AND sy-tcode = 'FB60'.
**IF sy-tcode = 'FB60'.
if SY-TCODE = 'FB60' or SY-TCODE = 'FB65'." or SY-TCODE = 'FV60'  or SY-TCODE = 'FV65'  .   " added by sonu
*
*
   SELECT * FROM bkpf INTO CORRESPONDING FIELDS OF TABLE lt_bkpf WHERE xblnr EQ xbkpf-xblnr AND gjahr EQ xbkpf-gjahr
    and tcode = sy-tcode AND BUKRS EQ XBKPF-BUKRS.   " added by sonu
*  SELECT * FROM bkpf INTO CORRESPONDING FIELDS OF TABLE lt_bkpf WHERE xblnr EQ xbkpf-xblnr AND gjahr EQ xbkpf-gjahr
*    and tcode = sy-tcode. " AND budat EQ @lv_budat.
*
  IF lt_bkpf[] IS NOT INITIAL.     " added by sonu
*
    SELECT * FROM bseg INTO CORRESPONDING FIELDS OF TABLE lt_bseg FOR ALL ENTRIES IN lt_bkpf WHERE bukrs EQ lt_bkpf-bukrs AND belnr EQ lt_bkpf-belnr AND gjahr EQ lt_bkpf-gjahr
      AND koart EQ 'K'.               " added by sonu
*
  ENDIF.    "added by sonu
*
  LOOP AT lt_bkpf INTO DATA(ls_bkpf).
*
    READ TABLE lt_bseg INTO DATA(ls_bseg) WITH KEY bukrs = ls_bkpf-bukrs belnr = ls_bkpf-belnr gjahr = ls_bkpf-gjahr. "added by sonu
    IF sy-subrc EQ 0.
      DATA : GV_GJAHR TYPE BKPF-GJAHR.
*
       CALL FUNCTION 'FI_PERIOD_DETERMINE'                                                  "added by sonu
         EXPORTING
           i_budat              = XBKPF-BUDAT
          I_BUKRS              = XBKPF-BUKRS
**          I_RLDNR              = ' '
**          I_PERIV              = ' '
**          I_GJAHR              = 0000
**          I_MONAT              = 00
**          X_XMO16              = ' '
        IMPORTING
          E_GJAHR              = GV_GJAHR
**          E_MONAT              =
**          E_POPER              =
        EXCEPTIONS
          FISCAL_YEAR          = 1
          PERIOD               = 2
          PERIOD_VERSION       = 3
          POSTING_PERIOD       = 4
          SPECIAL_PERIOD       = 5
          VERSION              = 6
          POSTING_DATE         = 7
          OTHERS               = 8
                 .
       IF sy-subrc <> 0.
** Implement suitable error handling here
       ENDIF.
*
*
*
*
      IF ls_bseg-lifnr EQ bseg-lifnr AND ls_bkpf-xblnr EQ xbkpf-xblnr AND LS_BSEG-GJAHR EQ GV_GJAHR.     "added by sonu
        MESSAGE 'Duplicate Vendor and Reference' TYPE 'I' DISPLAY LIKE 'E'.
*        LEAVE TO TRANSACTION sy-tcode. "'FB60'.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDIF.
ENDENHANCEMENT.
