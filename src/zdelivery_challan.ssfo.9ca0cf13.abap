DATA : it_xkomv TYPE komv OCCURS 0 WITH HEADER LINE.
DATA : it_taxcon TYPE taxcom,
       ls_ekko   TYPE ekko.

READ TABLE gt_purchasing INTO gs_purchasing INDEX 1.

SELECT SINGLE aedat
        FROM  ekko
        INTO  gv_po_date
        WHERE ebeln = gs_purchasing-ebeln.

SELECT SINGLE * FROM ekko
        INTO ls_ekko
        WHERE ebeln = gs_purchasing-ebeln.

it_taxcon-bukrs = ls_ekko-bukrs.
it_taxcon-budat = gv_po_date.
it_taxcon-bldat = gv_po_date.
it_taxcon-waers = ls_ekko-waers.
it_taxcon-hwaer = ls_ekko-waers.
it_taxcon-kposn = gs_purchasing-ebelp.
it_taxcon-mwskz = gs_purchasing-mwskz.
it_taxcon-wrbtr = gs_purchasing-netwr.
it_taxcon-xmwst = 'X'.
it_taxcon-shkzg =  'H'.
it_taxcon-lifnr = ls_ekko-lifnr.
it_taxcon-ekorg = ls_ekko-ekorg.
it_taxcon-ebeln = ls_ekko-ebeln.
it_taxcon-ebelp = gs_purchasing-ebelp.
it_taxcon-matnr = gs_purchasing-matnr.
it_taxcon-werks = gs_purchasing-werks.
*  it_taxcon-matkl = it_ekpo-matkl.
it_taxcon-meins = gs_purchasing-meins.
it_taxcon-mglme = gs_purchasing-menge.
*  it_taxcon-mtart = it_ekpo-mtart.
it_taxcon-land1 = gs_ven-country.
"**************************START OF FUNCTION CALCULATE TAX
"ITEM****************************
*BREAK fujiabap.

***CALL FUNCTION 'CALCULATE_TAX_ITEM'   "This is tHe Function Module
***  EXPORTING
***    dialog              = 'DIAKZ'
***    display_only        = 'X'
***    i_taxcom            = it_taxcon
***  TABLES
***    t_xkomv             = it_xkomv
***  EXCEPTIONS
***    mwskz_not_defined   = 1
***    mwskz_not_found     = 2
***    mwskz_not_valid     = 3
***    steuerbetrag_falsch = 4
***    country_not_found   = 5
***    OTHERS              = 6.
***
***
***READ TABLE it_xkomv WITH KEY kschl = 'JICR'. " AND
***IF sy-subrc IS INITIAL.
***  text = 'YES'.
***ENDIF.
***
***READ TABLE it_xkomv WITH KEY kschl = 'ZCRN'. " AND
***IF sy-subrc IS INITIAL.
***  text = 'YES'.
***
***ENDIF.
***
***READ TABLE it_xkomv WITH KEY kschl = 'JISR'. " AND
***IF sy-subrc IS INITIAL.
***  text = 'YES'.
***ENDIF.
***
***READ TABLE it_xkomv WITH KEY kschl = 'ZSRN'. " AND
***IF sy-subrc IS INITIAL.
***  text = 'YES'.
***ENDIF.
***
***READ TABLE it_xkomv WITH KEY kschl = 'ZIRN'. " AND
***IF sy-subrc IS INITIAL.
***  text = 'YES'.
***ENDIF.
***
***
***IF text IS INITIAL.
***  text = 'NO'.
***ENDIF.
***
***
***
***
***
***
***
***
***


