clear v_text.
if bkpftab-blart = 'SA'
   OR bkpftab-blart = 'AB'
   OR bkpftab-blart = 'BP'
   OR bkpftab-blart = 'KR'
   OR bkpftab-blart = 'RE'
  .
  v_text = 'Cost Center'.
else.
  v_text = 'Profit Center'.
endif.















