

IF GS_VBAP-ZGAD = '1'.
  gv_gad = 'Reference'.
ELSEIF GS_VBAP-ZGAD = '2'.
  gv_gad = 'Approved'.
ELSEIF GS_VBAP-ZGAD = '3'.
  gv_gad = 'Standard'.
ENDIF.




















