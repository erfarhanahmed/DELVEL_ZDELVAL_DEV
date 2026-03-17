
CLEAR :CURR.
IF WA_FINAL-WAERK = 'USD'.
  CURR = '$'.
ELSEIF WA_FINAL-WAERK = 'EUR'.
  CURR = '€'.
ENDIF.



















