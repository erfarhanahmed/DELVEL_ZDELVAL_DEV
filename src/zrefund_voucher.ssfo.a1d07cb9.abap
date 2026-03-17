
SELECT SINGLE bldat bktxt xblnr
FROM bkpf
INTO (bldat,bktxt,gv_xblnr)
WHERE bukrs = '1000'
AND belnr = p_belnr
AND gjahr = p_gjahr.

SHIFT gv_xblnr LEFT DELETING LEADING '0'.

SELECT SINGLE kunnr
FROM bseg
INTO kunnr
WHERE bukrs = '1000'
AND belnr = p_belnr
AND koart = 'D'.

















