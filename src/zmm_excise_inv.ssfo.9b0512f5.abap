CLEAR : V_TEXT, WA_CONDITION.
V_TEXT = TOTAL_AMOUNT.
"CONCATENATE v_text '-' WA_CONDITION-descr INTO v_text.
"CONCATENATE v_text '-' counter INTO v_text.
CONDENSE V_TEXT.

counter = counter + 1.



