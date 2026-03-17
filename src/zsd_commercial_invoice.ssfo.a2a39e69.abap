
*DATA : V_AMT1 TYPE STRING.
data w_i type i.
NEW_AMT = GS_HD_KOMK-FKWRT.
IF GS_HD_KOMK-FKWRT < 0.
REPLACE ALL OCCURRENCES OF  '-'IN NEW_AMT  WITH ''.

V_AMT = NEW_AMT.

V_AMT1 = V_AMT.

CONDENSE V_AMT1.

CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
EXPORTING
amt_in_num = V_AMT
IMPORTING
amt_in_words = amt_in_num
EXCEPTIONS
data_type_mismatch = 1
OTHERS = 2.
V_AMT1 = V_AMT1 * -1.
IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
****CALL FUNCTION 'SPELL_AMOUNT'
**** EXPORTING
****   AMOUNT          = V_AMT
****   CURRENCY        = VBRK-WAERK
****   FILLER          = ' '
****   LANGUAGE        = SY-LANGU
**** IMPORTING
****   IN_WORDS        = AMT_IN_NUM
****
**** EXCEPTIONS
****   NOT_FOUND       = 1
****   TOO_LARGE       = 2
****   OTHERS          = 3
****          .
****IF sy-subrc <> 0.
***** Implement suitable error handling here
****ENDIF.
****
*BREAK-POINT.

IF VBRK-WAERK NE 'INR'.

w_i = strlen( amt_in_num ).

subtract 6 from w_i.

amt_in_num = amt_in_num+0(w_i) .

CONCATENATE '-' amt_in_num INTO amt_in_num SEPARATED BY SPACE.

endif.


ELSE.
V_AMT = GS_HD_KOMK-FKWRT.

V_AMT1 = V_AMT.

CONDENSE V_AMT1.

CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
EXPORTING
amt_in_num = V_AMT
IMPORTING
amt_in_words = amt_in_num
EXCEPTIONS
data_type_mismatch = 1
OTHERS = 2.

IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
****CALL FUNCTION 'SPELL_AMOUNT'
**** EXPORTING
****   AMOUNT          = V_AMT
****   CURRENCY        = VBRK-WAERK
****   FILLER          = ' '
****   LANGUAGE        = SY-LANGU
**** IMPORTING
****   IN_WORDS        = AMT_IN_NUM
****
**** EXCEPTIONS
****   NOT_FOUND       = 1
****   TOO_LARGE       = 2
****   OTHERS          = 3
****          .
****IF sy-subrc <> 0.
***** Implement suitable error handling here
****ENDIF.
****
*BREAK-POINT.

IF VBRK-WAERK NE 'INR'.

w_i = strlen( amt_in_num ).

subtract 9 from w_i.

amt_in_num = amt_in_num+0(w_i).

endif.

ENDIF.

if vbrk-waerk eq 'INR'.
REPLACE ALL OCCURRENCES OF 'Paise' IN AMT_IN_NUM WITH ' '.
REPLACE ALL OCCURRENCES OF 'Rupees' IN AMT_IN_NUM WITH ' and Paise'.
ENDIF.




