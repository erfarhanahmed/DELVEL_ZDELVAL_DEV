"Name: \PR:SAPLFSKB\FO:GET_FORM\SE:END\EI
ENHANCEMENT 0 ZHSN_CODE_VALID.
* BREAK primus.
IF bkpf-bukrs = '1000'.


    IF SY-TCODE = 'FB70' or SY-TCODE = 'FB75'.

*      IF SY-UCOMM = 'BU' OR SY-UCOMM = 'BS'.

        IF ACGL_ITEM-HSN_SAC IS INITIAL.
          MESSAGE 'Please Enter HSN CODE' TYPE 'E'.
        ENDIF.

        IF ACGL_ITEM-SGTXT IS INITIAL.
          MESSAGE 'Please Enter Text' TYPE 'E'.
        ENDIF.

*      ENDIF.
    ENDIF.
ENDIF.

*********************logic for posting date is not future or back dated
*******Code Inserted by Primus: Jyoti Mahajan functional Shradhha Koli

if SY-TCODE = 'FB60' or SY-TCODE = 'FV50' OR SY-TCODE = 'FB65' or SY-TCODE = 'FB70' OR SY-TCODE = 'FB50'
  or SY-TCODE = 'FB75' or SY-TCODE = 'FV60'  or SY-TCODE = 'FV65' or SY-TCODE = 'FV70' or SY-TCODE = 'FV75'
  or SY-TCODE = 'FBV0' .
   if bkpf-bukrs ne 'US00'.
  if bkpf-budat gt sy-datum.
     MESSAGE 'Posting date should not be later than the system date.' TYPE 'E'.
  endif.
  ENDIF.
  if bkpf-budat lt bkpf-bldat.
     MESSAGE 'Back dated Posting date is not allowed.' TYPE 'E'.
  endif.
endif.

DATA : lt_bkpf TYPE STANDARD TABLE OF bkpf,     "added by sonu
       lt_bseg TYPE STANDARD TABLE OF VbsegK.    ""added by sonu

if  SY-TCODE = 'FV60' or SY-TCODE = 'FV65'. "or  SY-TCODE = 'FBV0'.   "added by sonu
*
*BREAK PRIMUSABAP.
*  SELECT * FROM bkpf INTO CORRESPONDING FIELDS OF TABLE lt_bkpf WHERE xblnr EQ bkpf-xblnr AND gjahr EQ bkpf-gjahr AND TCODE = SY-TCODE. " AND budat EQ @lv_budat.
*
*  IF lt_bkpf[] IS NOT INITIAL.
*
*    SELECT * FROM VbsegK INTO CORRESPONDING FIELDS OF TABLE lt_bseg FOR ALL ENTRIES IN lt_bkpf
*       WHERE bukrs EQ lt_bkpf-bukrs AND belnr EQ lt_bkpf-belnr AND gjahr EQ lt_bkpf-gjahr
*      and lifnr eq G_BSEG_KK-lifnr.
**      AND koart EQ 'K'.
*
*  ENDIF.
  SELECT * FROM bkpf INTO CORRESPONDING FIELDS OF TABLE lt_bkpf WHERE xblnr EQ bkpf-xblnr AND gjahr EQ bkpf-gjahr AND TCODE = 'FBVB'
    AND bukrs eq bkpf-bukrs ."and xprfg = ' '.

 IF lt_bkpf[] IS NOT INITIAL.
 SELECT * FROM bseg INTO CORRESPONDING FIELDS OF TABLE lt_bseg FOR ALL ENTRIES IN lt_bkpf WHERE bukrs EQ lt_bkpf-bukrs AND belnr EQ lt_bkpf-belnr AND gjahr EQ lt_bkpf-gjahr
      AND koart EQ 'K'.
  ENDIF.
*
  LOOP AT lt_bkpf INTO DATA(ls_bkpf). "added by sonu
*
    READ TABLE lt_bseg INTO DATA(ls_bseg) WITH KEY bukrs = ls_bkpf-bukrs belnr = ls_bkpf-belnr gjahr = ls_bkpf-gjahr.
    IF sy-subrc EQ 0.
      DATA : GV_GJAHR TYPE BKPF-GJAHR.
*
       CALL FUNCTION 'FI_PERIOD_DETERMINE'     " added by sonu
         EXPORTING
           i_budat             = BKPF-BUDAT
          I_BUKRS              = BKPF-BUKRS
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
      IF ls_bseg-lifnr EQ G_BSEG_KK-lifnr AND ls_bkpf-xblnr EQ bkpf-xblnr AND LS_BSEG-GJAHR EQ GV_GJAHR. "added by sonu
        MESSAGE 'Duplicate Vendor and Reference' TYPE  'E'.  "'I' DISPLAY LIKE 'E'.
        LEAVE TO TRANSACTION sy-tcode. " 'FB60'.
      ENDIF.
    ENDIF.
  ENDLOOP.
*
ENDIF.


ENDENHANCEMENT.
