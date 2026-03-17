CLEAR : gv_brgew, gv_ntgew.
BREAK : kdeshmukh , jbondale.
*SELECT SINGLE SUM( brgew )
*              SUM( ntgew )
*  INTO (gv_brgew, gv_ntgew)
*  FROM vekp
*  WHERE vpobj = '01'
*    AND vpobjkey = is_bil_invoice-hd_ref-deliv_numb
**  WHERE vbeln_gen = is_bil_invoice-hd_ref-deliv_numb
*  GROUP BY vbeln_gen.


SELECT SINGLE SUM( brgew )
              SUM( ntgew )
  INTO (gv_brgew, gv_ntgew)
  FROM lips WHERE vbeln = is_bil_invoice-hd_ref-deliv_numb .


















