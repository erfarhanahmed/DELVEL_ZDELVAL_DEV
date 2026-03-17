
REFRESH : it_skat, it_lfa1, it_kna1, it_anla.
clear :
wa_lfa1, wa_kna1, wa_anla, wa_skat.


IF wa_bseg-koart = 'S' OR wa_bseg-koart = 'M'.
select saknr
       txt50
  from skat
  into table it_skat
  FOR ALL ENTRIES IN it_bseg
  where saknr = it_bseg-hkont.
ENDIF.

IF wa_bseg-koart = 'K'.
SELECT lifnr
       name1
     from lfa1
  into table it_lfa1
  FOR ALL ENTRIES IN it_bseg
  where lifnr = it_bseg-lifnr.
ENDIF.

IF wa_bseg-koart = 'D'.
  SELECT KUNNR
         NAMe1
     from kna1
     INTO TABLE it_kna1
    FOR ALL ENTRIES IN it_bseg
    WHERE kunnr = it_bseg-kunnr.
ENDIF.

IF wa_bseg-koart = 'A'.
  SELECT anln1
         txt50
     from anla
     INTO TABLE it_anla
    FOR ALL ENTRIES IN it_bseg
    WHERE anln1 = it_bseg-anln1.
ENDIF.

  READ TABLE it_lfa1 into wa_lfa1 with key lifnr = wa_bseg-lifnr.
  READ TABLE it_kna1 into wa_kna1 with key kunnr = wa_bseg-kunnr.
  READ TABLE it_anla into wa_anla with key anln1 = wa_bseg-anln1.
  READ TABLE it_skat into wa_skat with key saknr = wa_bseg-hkont.





