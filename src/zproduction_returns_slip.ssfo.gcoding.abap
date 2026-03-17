

****SELECT mblnr
****       matnr
****       mjahr
****       menge
****       aufnr
****       sgtxt FROM mseg INTO TABLE it_mseg
****       WHERE mblnr = s_mblnr
****       AND   mjahr = p_year
****       AND   xauto = 'X'.
****
**** SELECT matnr
****         lgort
****         labst FROM mard INTO (WA_mard)
****         FOR ALL ENTRIES IN it_mseg
****         WHERE matnr = it_mseg-matnr
****         AND lgort IN ('RM01','KRM0').



















