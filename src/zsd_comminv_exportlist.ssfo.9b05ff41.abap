CLEAR GV_TXT.
CLEAR GV_TXT1.

DATA : VAR1 TYPE STRING,
       VAR2 TYPE STRING.
SPLIT V_TEXT AT '.' INTO VAR1 VAR2.
CONCATENATE var1 '.00' INTO var1.

*&----------------------------------------------------------*&
*          CONVERTING TOTAL AMOUNT IN WORDS USD
*&----------------------------------------------------------*&

CALL FUNCTION 'SPELL_AMOUNT'
 EXPORTING
   AMOUNT          = VAR1 "TOTAL_AMOUNT
   CURRENCY        = 'USD'
*   FILLER          = ' '
   LANGUAGE        = SY-LANGU
 IMPORTING
   IN_WORDS        = GV_TXT
 EXCEPTIONS
   NOT_FOUND       = 1
   TOO_LARGE       = 2
   OTHERS          = 3
          .
IF SY-SUBRC <> 0.
  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
*&----------------------------------------------------------*&
*          CONVERTING TOTAL AMOUNT IN WORDS USD
*&----------------------------------------------------------*&
CALL FUNCTION 'SPELL_AMOUNT'
 EXPORTING
   AMOUNT          = VAR2 "TOTAL_AMOUNT
*   CURRENCY        = 'USD'
*   FILLER          = ' '
   LANGUAGE        = SY-LANGU
 IMPORTING
   IN_WORDS        = GV_TEXT1
 EXCEPTIONS
   NOT_FOUND       = 1
   TOO_LARGE       = 2
   OTHERS          = 3
          .
IF SY-SUBRC <> 0.
  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

*&----------------------------------------------------------*&
*          CONVERTING USD INTO INDIAN RUPEES IN WORDS
*&----------------------------------------------------------*&
DATA: V_KWERT1 TYPE PC207-BETRG.
REPLACE ALL OCCURRENCES OF ',' IN V_KWERT WITH '/'.
REPLACE ALL OCCURRENCES OF '.' IN V_KWERT WITH ','.
REPLACE ALL OCCURRENCES OF '/' IN V_KWERT WITH '.'.

V_KWERT = TOTAL_AMOUNT * WA_VBRK-KURRF.
V_KWERT1 = V_KWERT.
****
CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    AMT_IN_NUM         = V_KWERT1
  IMPORTING
    AMT_IN_WORDS       = GV_TXT1
  EXCEPTIONS
    DATA_TYPE_MISMATCH = 1
    OTHERS             = 2.
IF SY-SUBRC <> 0.
  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
REPLACE ALL OCCURRENCES OF 'Paise' IN GV_TXT1 WITH ' '.
REPLACE ALL OCCURRENCES OF 'Rupees' IN GV_TXT1 WITH ' and Paise'.
