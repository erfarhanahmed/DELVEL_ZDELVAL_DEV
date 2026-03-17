DATA : it_xkomv  TYPE komv OCCURS 0 WITH HEADER LINE.
DATA : it_taxcon TYPE taxcom,
       ls_ekko   TYPE ekko,
       ls_ekpo   TYPE ekpo.
DATA:
  lv_fkart      TYPE vbrk-fkart.


SELECT SINGLE fkart INTO lv_fkart
        FROM vbrk
        WHERE vbeln = ls_bil_invoice-hd_gen-bil_number.
  IF lv_fkart = 'ZSN'.
    SELECT SINGLE * FROM ekko
            INTO ls_ekko
            WHERE ebeln = GS_PURCHASING-ebeln.

    SELECT SINGLE * FROM ekpo
            INTO ls_ekpo
            WHERE ebeln = GS_PURCHASING-ebeln.

    CLEAR:
     it_taxcon,it_xkomv[].

  it_taxcon-bukrs = ls_ekko-bukrs.
  it_taxcon-budat = ls_ekko-aedat.
  it_taxcon-bldat = ls_ekko-bedat.
  it_taxcon-waers = ls_ekko-waers.
  it_taxcon-hwaer = ls_ekko-waers.
  it_taxcon-kposn = ls_ekpo-ebelp.
  it_taxcon-mwskz = ls_ekpo-mwskz.
  it_taxcon-wrbtr = ls_ekpo-netwr.

  it_taxcon-xmwst = 'X'.
  it_taxcon-shkzg =  'H'.
*  it_taxcon-txjcd = it_ekpo-txjcd.
  it_taxcon-lifnr = ls_ekko-lifnr.
  it_taxcon-ekorg = ls_ekko-ekorg.
  it_taxcon-ebeln = ls_ekpo-ebeln.
  it_taxcon-ebelp = ls_ekpo-ebelp.
  it_taxcon-matnr = ls_ekpo-matnr.
  it_taxcon-werks = ls_ekpo-werks.
  it_taxcon-matkl = ls_ekpo-matkl.
  it_taxcon-meins = ls_ekpo-meins.
  it_taxcon-mglme = ls_ekpo-menge.
  it_taxcon-mtart = ls_ekpo-mtart.
  it_taxcon-land1 = ls_ekko-lands.
  "**************************START OF FUNCTION CALCULATE TAX
  "ITEM****************************


  CALL FUNCTION 'CALCULATE_TAX_ITEM'   "This is tHe Function Module
    EXPORTING
      dialog              = 'DIAKZ'
      display_only        = 'X'
      i_taxcom            = it_taxcon
    TABLES
      t_xkomv             = it_xkomv
    EXCEPTIONS
      mwskz_not_defined   = 1
      mwskz_not_found     = 2
      mwskz_not_valid     = 3
      steuerbetrag_falsch = 4
      country_not_found   = 5
      OTHERS              = 6.

    READ TABLE it_xkomv" INTO ls_conditions
       WITH KEY kschl = 'JICR'. " AND
    IF sy-subrc IS INITIAL.
      text = 'YES'.
    ENDIF.

    READ TABLE it_xkomv"  INTO ls_conditions
     WITH KEY kschl = 'ZCRN'. " AND
    IF sy-subrc IS INITIAL.
      text = 'YES'.
    ENDIF.

    READ TABLE it_xkomv"  INTO ls_conditions
     WITH KEY kschl = 'JISR'. " AND
    IF sy-subrc IS INITIAL.
      text = 'YES'.
    ENDIF.


    READ TABLE it_xkomv"  INTO ls_conditions
     WITH KEY kschl = 'ZSRN'. " AND
    IF sy-subrc IS INITIAL.
      text = 'YES'.
    ENDIF.

    READ TABLE it_xkomv"  INTO ls_conditions
     WITH KEY kschl = 'ZIRN'. " AND
    IF sy-subrc IS INITIAL.
      text = 'YES'.
    ENDIF.

    IF text IS INITIAL.
      text = 'NO'.
    ENDIF.

  ENDIF.
