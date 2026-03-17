*SORT LT_FINAL_EWAY DESCENDING.
READ TABLE lt_final_eway INTO ls_final_eway INDEX 1.
*
ls_addr01 =  ls_final_eway-fromaddr1.
ls_addr02 = ls_final_eway-fromaddr2.
ls_place = ls_final_eway-fromplace.
ls_statcode = ls_final_eway-fromstatecode.
ls_pincode =  ls_final_eway-frompincode.
""""""""""""""""""FROM ADDRESS
IF ls_vbrk_j-fkart = 'ZDC' ."OR ls_vbrk_j-FKART = 'ZSN'.
  CLEAR  : ls_addr01,
           ls_addr02,
           ls_place ,
           ls_statcode,
           ls_pincode,
           ls_final_eway-dispatchfromtradename.

ENDIF.






