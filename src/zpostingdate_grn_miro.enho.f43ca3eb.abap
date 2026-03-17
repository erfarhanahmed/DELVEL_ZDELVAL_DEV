"Name: \PR:SAPLMR1M\FO:SET_HOLD_DATA\SE:END\EI
ENHANCEMENT 0 ZPOSTINGDATE_GRN_MIRO.
*Code added by sarika thange
DATA : ti_drseg1 TYPE mmcr_drseg OCCURS 1 WITH HEADER LINE..
*DATA : lv_count TYPE char2. "COMMENTED BY JYOTI ON 01.04.2023
DATA : lv_count TYPE char4. " CHANGE BY JYOTI ON 01.04.2023
DATA : msg TYPE string.
DATA : lv_date1 TYPE bldat.
FIELD-SYMBOLS : <ebeln> TYPE ebeln.


IF sy-tcode = 'MIR7' AND ekko-bukrs = '1000'. " Added For MR6 T-code

  ti_drseg1[] =  ydrseg[].

  DELETE ADJACENT DUPLICATES FROM  ti_drseg1 COMPARING xblnr.
  DESCRIBE TABLE ti_drseg1 LINES lv_count.

  IF  lv_count = 1.
    ASSIGN ('(SAPLMR1M)RM08M-EBELN')  TO <ebeln>.
    lv_date1 = rbkpv-bldat .
    IF <ebeln> IS ASSIGNED.
      READ TABLE  ti_drseg1 INTO DATA(wa_rseg) INDEX 1.
      SELECT SINGLE budat
        FROM ekbe
        INTO @DATA(lv_date)
        WHERE ebeln = @wa_rseg-ebeln
        AND vgabe = '1'
        AND  bwart EQ '101'
        AND xblnr = @wa_rseg-xblnr.

      IF sy-subrc EQ 0.
        rbkpv-bldat = lv_date.
        IF lv_date1 LE lv_date.
          rbkpv-bldat  = lv_date1.
        ELSE.
          rbkpv-bldat = lv_date1.
          CONCATENATE 'Invoice date should not be greater than GRN posting date' lv_date+6(2)'.' lv_date+4(2)'.' lv_date+0(4) INTO msg ."SEPARATED BY SPACE.
          MESSAGE msg  TYPE 'E' DISPLAY LIKE 'I'.   "Added Type E in replace with S
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.

ENDENHANCEMENT.
