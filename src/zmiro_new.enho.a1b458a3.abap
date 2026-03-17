"Name: \PR:SAPLMR1M\FO:FCOBU\SE:BEGIN\EI
ENHANCEMENT 0 ZMIRO_NEW.
TYPES:BEGIN OF ty_mkpf,
      mblnr  TYPE mkpf-mblnr,
      mjahr  TYPE mkpf-mjahr,
      budat  TYPE mkpf-budat,
      xblnr  TYPE mkpf-xblnr,
      tcode2 TYPE mkpf-tcode2,
      END OF ty_mkpf.
DATA : it_mkpf TYPE TABLE OF ty_mkpf,
       wa_mkpf TYPE ty_mkpf.


IF sy-tcode = 'MIR7' OR sy-tcode = 'MIR4'.
*BREAK-POINT.
select single MAX( mblnr ) FROM
  mseg
  INTO @Data(gv_mblnr)
  where ebeln = @DRSEG-EBELN.

SELECT mblnr
       mjahr
       budat
       xblnr
       tcode2 FROM mkpf INTO TABLE it_mkpf
       WHERE xblnr = rbkpv-xblnr
      and mblnr = gv_mblnr
        AND  tcode2 NE 'ML81N'.
******************added by jyoti on 24.10.2024*****************
*  if sy-subrc is INITIAL.
  if RBKPV-BUDAT gt sy-datum.
    MESSAGE 'Posting date should not be later than the system date.' TYPE 'E'.
  else.
    LOOP AT it_mkpf INTO wa_mkpf.
       IF RBKPV-BUDAT lt wa_MKPF-BUDAT.
           MESSAGE 'Back dated Posting date is not allowed.' TYPE 'E'.
       endif.
    ENDLOOP.

  endif.
*  else.
*      MESSAGE 'Check posting date' TYPE 'W'.
*  endif.
**************************************************************
*  *****************commentec by jyoti on 24.10.2024**************
*  LOOP AT it_mkpf INTO wa_mkpf.
*    IF RBKPV-BUDAT GE wa_MKPF-BUDAT.
*
*    ELSE.
*      MESSAGE 'check posting date' TYPE 'E'.
*    ENDIF.
*  ENDLOOP.
**************************************************************
ENDIF.

IF sy-tcode = 'MIRO'.
*  BREAK-POINT.
  IF RBKPV-BUKRS = '1000'.

IF ekko-bsart NE 'ZIMP'.
  IF EKKO-LIFNR NE RBKPV-LIFNR.
    MESSAGE 'Check Vendor' TYPE 'E'.
  ENDIF.
ENDIF.

select single MAX( mblnr ) FROM
  mseg
  INTO gv_mblnr
  where ebeln = DRSEG-EBELN.

SELECT mblnr
       mjahr
       budat
       xblnr
       tcode2 FROM mkpf INTO TABLE it_mkpf
       WHERE xblnr = rbkpv-xblnr
         and mblnr = gv_mblnr
        AND  tcode2 NE 'ML81N'.
******************added by jyoti on 24.10.2024*****************
  if RBKPV-BUDAT gt sy-datum.
    MESSAGE 'Posting date should not be later than the system date.' TYPE 'E'.
  else.
    LOOP AT it_mkpf INTO wa_mkpf.
       IF RBKPV-BUDAT lt wa_MKPF-BUDAT.
           MESSAGE 'Back dated Posting date is not allowed.' TYPE 'E'.
       endif.
    ENDLOOP.

  endif.
***************************************************************
**********************commented by jyoti on 24.10.2024
*  LOOP AT it_mkpf INTO wa_mkpf.
*    IF RBKPV-BUDAT GE wa_MKPF-BUDAT.
*
*    ELSE.
*      MESSAGE 'check posting date' TYPE 'E'.
*    ENDIF.
*  ENDLOOP.
***************************************************

data: t_ebeln type range of ekko-ebeln,  "range table
      w_ebeln like line of t_ebeln.     "work area for range table

  w_ebeln-low  = '1730000001'.
  w_ebeln-high = '1739999999'.
  w_ebeln-sign = 'I'.
  w_ebeln-option = 'BT'.
  append w_ebeln TO t_ebeln.
    LOOP AT YDRSEG." DRSEG  .

          if YDRSEG-KNTTP = 'A'."t_ebeln.

           RBKPV-blart = 'ZA'.
*
          endif.

          if YDRSEG-KNTTP = 'F'."t_ebeln.

           RBKPV-blart = 'ZA'.
*
          endif.

    ENDLOOP.
  ENDIF.
  break primusabap.

  select single MAX( mblnr ) FROM
  mseg
  INTO gv_mblnr
  where ebeln = DRSEG-EBELN.




  SELECT mblnr
       mjahr
       budat
       xblnr
       tcode2 FROM mkpf INTO TABLE it_mkpf
       WHERE xblnr = rbkpv-xblnr
        and mblnr = gv_mblnr
        AND  tcode2 NE 'ML81N'.


******************added by jyoti on 24.10.2024*****************
  if RBKPV-BUDAT gt sy-datum.
    MESSAGE 'Posting Date is not in Future' TYPE 'E'.
  else.
    LOOP AT it_mkpf INTO wa_mkpf.
       IF RBKPV-BUDAT lt wa_MKPF-BUDAT.
           MESSAGE 'Posting Date is not in Back Dated' TYPE 'E'.
       endif.
    ENDLOOP.

  endif.




ENDIF.
DATA : lt_bkpf TYPE STANDARD TABLE OF bkpf,
       lt_bseg TYPE STANDARD TABLE OF Bseg,
       lt_bseg1 TYPE STANDARD TABLE OF Bseg.
if sy-tcode = 'MIRO' OR sy-tcode = 'MIR4'.

  SELECT * FROM bkpf INTO CORRESPONDING FIELDS OF TABLE lt_bkpf WHERE xblnr EQ rbkpv-xblnr AND gjahr EQ rbkpv-gjahr
                        AND TCODE = SY-TCODE. " AND budat EQ @lv_budat.

  IF lt_bkpf[] IS NOT INITIAL.

    SELECT * FROM bseg INTO CORRESPONDING FIELDS OF TABLE lt_bseg FOR ALL ENTRIES IN lt_bkpf
      WHERE bukrs EQ lt_bkpf-bukrs AND belnr EQ lt_bkpf-belnr AND gjahr EQ lt_bkpf-gjahr
      and lifnr = rbkpv-lifnr.
*      AND koart EQ 'K'.

  ENDIF.

  LOOP AT lt_bkpf INTO DATA(ls_bkpf).

    READ TABLE lt_bseg INTO DATA(ls_bseg) WITH KEY bukrs = ls_bkpf-bukrs belnr = ls_bkpf-belnr gjahr = ls_bkpf-gjahr.
    IF sy-subrc EQ 0.
      DATA : GV_GJAHR TYPE BKPF-GJAHR.

       CALL FUNCTION 'FI_PERIOD_DETERMINE'
         EXPORTING
           i_budat              = rbkpv-BUDAT
          I_BUKRS              = rbkpv-BUKRS
*          I_RLDNR              = ' '
*          I_PERIV              = ' '
*          I_GJAHR              = 0000
*          I_MONAT              = 00
*          X_XMO16              = ' '
        IMPORTING
          E_GJAHR              = GV_GJAHR
*          E_MONAT              =
*          E_POPER              =
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
* Implement suitable error handling here
       ENDIF.




      IF ls_bseg-lifnr EQ rbkpv-lifnr AND ls_bkpf-xblnr EQ rbkpv-xblnr AND LS_BSEG-GJAHR EQ GV_GJAHR.
        MESSAGE 'Duplicate Vendor and Reference' TYPE 'I' DISPLAY LIKE 'E'.
        LEAVE TO TRANSACTION sy-tcode. " 'FB60'.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDIF.
if sy-tcode = 'MIR7'.
  SELECT * FROM bkpf INTO CORRESPONDING FIELDS OF TABLE lt_bkpf WHERE xblnr EQ rbkpv-xblnr AND gjahr EQ rbkpv-gjahr
     AND  TCODE = SY-TCODE. " AND budat EQ @lv_budat.

  IF lt_bkpf[] IS NOT INITIAL.

    SELECT * FROM VbsegK INTO CORRESPONDING FIELDS OF TABLE lt_bseg1 FOR ALL ENTRIES IN lt_bkpf
       WHERE bukrs EQ lt_bkpf-bukrs AND belnr EQ lt_bkpf-belnr AND gjahr EQ lt_bkpf-gjahr
      and lifnr eq rbkpv-lifnr.
*
*      AND koart EQ 'K'.

  ENDIF.

  LOOP AT lt_bkpf INTO DATA(ls_bkpf1).

    READ TABLE lt_bseg1 INTO DATA(ls_bseg1) WITH KEY bukrs = ls_bkpf1-bukrs belnr = ls_bkpf1-belnr gjahr = ls_bkpf1-gjahr.
    IF sy-subrc EQ 0.
      DATA : GV_GJAHR1 TYPE BKPF-GJAHR.

       CALL FUNCTION 'FI_PERIOD_DETERMINE'
         EXPORTING
           i_budat              = rbkpv-BUDAT
          I_BUKRS              = rbkpv-BUKRS
*          I_RLDNR              = ' '
*          I_PERIV              = ' '
*          I_GJAHR              = 0000
*          I_MONAT              = 00
*          X_XMO16              = ' '
        IMPORTING
          E_GJAHR              = GV_GJAHR1
*          E_MONAT              =
*          E_POPER              =
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
* Implement suitable error handling here
       ENDIF.




      IF ls_bseg1-lifnr EQ rbkpv-lifnr AND ls_bkpf1-xblnr EQ rbkpv-xblnr AND LS_BSEG1-GJAHR EQ GV_GJAHR1.
        MESSAGE 'Duplicate Vendor and Reference' TYPE 'I' DISPLAY LIKE 'E'.
        LEAVE TO TRANSACTION sy-tcode. " 'FB60'.
      ENDIF.
    ENDIF.
  ENDLOOP.

endif.



ENDENHANCEMENT.
