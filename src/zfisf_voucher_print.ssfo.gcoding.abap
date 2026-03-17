DATA plant_id TYPE werks_d.
READ TABLE BSEGTAB INTO WA_BSEGTAB INDEX 1.
IF sy-subrc eq 0.
  PLANT_id = WA_BSEGTAB-WERKS.
ENDIF.
*SHIFT plant_id LEFT DELETING LEADING '0'.

SELECT SINGLE adrnr
  FROM T001W
  into PLANT_ADRNR
  WHERE werks = PLANT_id.
IF sy-subrc ne 0.
  plant_adrnr = t001-adrnr.
ENDIF.

IF  bkpftab-blart = 'SA'
    OR bkpftab-blart = 'AB'
    OR bkpftab-blart = 'KR'
    OR bkpftab-blart = 'RE'
    OR bkpftab-blart = 'BP'.

  select KOSTL
       ktext
  from CSKT
  into table it_prof_cost_cntr
  for all entries in bsegtab
  where KOSTL = bsegtab-KOSTL
    AND SPRAS = sy-langu.
elseif bkpftab-blart = 'KZ' OR bkpftab-blart = 'DZ'.
  select PRCTR
         ktext
    from CEPCT
    into table it_prof_cost_cntr
    for all entries in bsegtab
    where PRCTR = bsegtab-PRCTR
      AND SPRAS = sy-langu.
ENDIF.
IF not it_prof_cost_cntr is initial.
  sort it_prof_cost_cntr by cntrcd.
ENDIF.
