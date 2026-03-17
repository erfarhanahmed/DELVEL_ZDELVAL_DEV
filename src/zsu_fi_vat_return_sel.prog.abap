*&---------------------------------------------------------------------*
*&  Include           ZSU_FI_VAT_RETURN_SEL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZSU_FI_VAT_RETURN_SEL
*&---------------------------------------------------------------------*
TABLES : BKPF.
*    DATA: CURRENT_DATE TYPE SY-DATUM,                    "ADDED BY AAKASHK 05.08.2024
*      PREVIOUS_DATE TYPE SY-DATUM.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS : P_BUKRS  TYPE BKPF-BUKRS DEFAULT 'SU00' OBLIGATORY MODIF ID BU.
SELECT-OPTIONS : S_BUDAT  FOR BKPF-BUDAT NO-EXTENSION,
                 S_GJAHR  FOR BKPF-GJAHR NO-EXTENSION,
                 S_BUDAT1  FOR BKPF-BUDAT NO-EXTENSION NO-DISPLAY.
* PARAMETERS : P_BUDAT  TYPE BKPF-BUDAT NO-DISPLAY.
*PARAMETERS :  P_GJAHR  TYPE GJAHR.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/Saudi'.      "'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK B2.

****************************************************************ADD BY SUPRIA.

INITIALIZATION.
***Initialisation -> This event is used when ever you initialize any variable or a field in your program.
***
***this indicates the start of program .It is similar to Load of program .
***
***this is the first event executed as the program is executed .
*
*DATA: lv_current_month_vet TYPE bset-hwste,
*      lv_previous_month_vet TYPE bset-hwste,
*      lv_difference         TYPE bset-hwste,
**      L_DATE type string,
*      I_DATE_OLD TYPE bset-hwste,
*      E_DATE_NEW TYPE  bset-hwste.

DATA: LV_BUDAT_LOW  TYPE BKPF-BUDAT,  "OLD
      LV_BUDAT_HIGH TYPE BKPF-BUDAT,
      LV_PREV_BUDAT_LOW TYPE BKPF-BUDAT,   "NEW
      LV_PREV_BUDAT_HIGH TYPE BKPF-BUDAT,
      LV_BUDAT1_LOW TYPE BKPF-BUDAT,   "NEW
      LV_BUDAT1_HIGH TYPE BKPF-BUDAT,

      I_DATE_OLD TYPE STRING,
*      L_DATE TYPE STRING,
      E_DATE_NEW TYPE STRING.
*      E_DATE_NEW TYPE SY-DATUM.
*lv_prev_budat_low = lv_budat_low - 1.
*lv_prev_budat_high = lv_budat_high - 1.

*SELECT SUM( hwste ) into lv_current_month_vet
*  FROM bset
**where S_BUDAT between lv_budat_low  AND lv_budat_high.
*where S_BUDAT between lv_budat_low  AND lv_budat_high.
*SELECT SUM( hwste ) into lv_previousv
*  FROM bset
**where S_BUDAT between lv_budat_low  AND lv_budat_high.
*where S_BUDAT between lv_budat_low  AND lv_budat_high.
*lv_difference = lv_current_month_vet - lv_previous_month_vet.

******************add by supriya

*data:  lv_prev_budat_low TYPE bkpf-budat,
*       lv_prev_budat_high TYPE bkpf-budat.
*
*lv_prev_budat_low = L_DATE.

**DATA: BEGIN OF L_DATE,
**        YEAR(4),
**        MONTH(2),
**        DAY(2),
**      END OF L_DATE.
**
**lv_budat_low = L_DATE.
**  L_DATE = I_DATE_OLD.
**  L_DATE-DAY = '01'.
***  E_DATE_NEW = L_DATE.
**  E_DATE_NEW = S_BUDAT1.
**  SUBTRACT 1 FROM E_DATE_NEW.

*lv_prev_budat_low = L_DATE.
* L_DATE = I_DATE_OLD.
*L_DATE-DAY = '01'.
* E_DATE_NEW = L_DATE.
**E_DATE_NEW = lv_prev_budat_low.
* SUBTRACT 1 FROM E_DATE_NEW.



**CALL FUNCTION 'OIL_LAST_DAY_OF_PREVIOUS_MONTH'
**  EXPORTING
**    I_DATE_OLD       =  lv_budat_low              "L_DATE
** IMPORTING
**   E_DATE_NEW       =  S_BUDAT1.           "L_DATE.
***     E_DATE_NEW       = lv_prev_budat_low.
***          .
**LOOP AT S_BUDAT1.
**S_BUDAT1-low = lv_budat_low - 1.
**S_BUDAT1-high = lv_budat_high - 1.
**APPEND S_BUDAT1.
**ENDLOOP.


*******************************************************************
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
    IF SCREEN-NAME = 'S_GJAHR-HIGH'.
      SCREEN-ACTIVE = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

*    INITIALIZATION.                                         "ADDED BY AAKASHK 07.08.2024
*  CURRENT_DATE = SY-DATUM.
*  PREVIOUS_DATE = SY-DATUM - 1.
*
*  S_BUDAT-LOW = PREVIOUS_DATE.
*  S_BUDAT-HIGH = CURRENT_DATE.
*  APPEND S_BUDAT.
