
*break-point.
DATA: l_amt TYPE string.
l_amt = is_bil_invoice-hd_komk-fkwrt.
REPLACE ALL OCCURRENCES OF ',' IN l_amt WITH space.


DATA: wa_spell LIKE spell. " Store the text

DATA: l_word TYPE in_words, " amt in workds
l_deword TYPE decword, " amt decimal value
l_waerk TYPE waerk,
l_amt_1(250) TYPE c,
l_amount LIKE pc207-betrg.
.

*L_WAERK = IS_BIL_INVOICE-HD_GEN-BIL_WAERK.
IF g_waerk EQ 'INR'.
l_amount = l_amt.
CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
EXPORTING
amt_in_num         = l_amount
IMPORTING
amt_in_words       = l_amt_1
EXCEPTIONS
data_type_mismatch = 1
OTHERS             = 2.
IF sy-subrc <> 0.
MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
CONCATENATE l_amt_1 'ONLY' INTO g_text SEPARATED BY space.

ELSE.
* This will give the amt in words
CALL FUNCTION 'SPELL_AMOUNT'
EXPORTING
amount    = l_amt
currency  = g_waerk
language  = sy-langu
IMPORTING
in_words  = wa_spell
EXCEPTIONS
not_found = 1
too_large = 2
OTHERS    = 3.
IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

DATA: c1 TYPE c. " constant for storing the '.' value
c1 = '.'.        " Pass the '.' value to another

l_word = wa_spell-word.       " Pass the value into the another variable
l_deword = wa_spell-decword.  " Pass the deciaml value to another value

CONCATENATE l_word 'AND' c1 l_deword ',' g_waerk INTO g_text SEPARATED BY space. " concatenating the tot amt in words
ENDIF.


















