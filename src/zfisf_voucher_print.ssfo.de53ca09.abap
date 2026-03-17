clear : wa_PROF_COST_CNTR, v_text.
IF bkpftab-blart = 'SA'
  OR bkpftab-blart = 'AB'
  OR bkpftab-blart = 'KR'
  OR bkpftab-blart = 'RE'
  OR bkpftab-blart = 'BP'.
  read table IT_PROF_COST_CNTR into wa_PROF_COST_CNTR
    with key cntrcd = wa_bsegtab-kostl.
elseif bkpftab-blart = 'KZ' OR bkpftab-blart = 'DZ'.
  read table IT_PROF_COST_CNTR into wa_PROF_COST_CNTR
    with key cntrcd = wa_bsegtab-PRCTR.
ENDIF.
v_text = wa_PROF_COST_CNTR-ktext.














