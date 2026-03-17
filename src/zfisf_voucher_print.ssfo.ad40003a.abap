data : wa_bsegtab type bseg.
Clear :WA_CUSTOMER, v_text, gv_koart.
read table bsegtab into wa_bsegtab with key belnr = bkpftab-belnr
                                            koart = 'D'.
IF sy-subrc = 0.
  gv_koart = 'D'.
  READ TABLE GLTEXT INTO WA_CUSTOMER with key kunnr = wa_bsegtab-kunnr.
else.
  read table bsegtab into wa_bsegtab with key belnr = bkpftab-belnr
                                            koart = 'K'.
  IF sy-subrc = 0.
    gv_koart = 'K'.
    READ TABLE GLTEXT INTO WA_CUSTOMER with key lifnr = wa_bsegtab-lifnr.
  ENDIF.
ENDIF.
clear wa_bsegtab.

if BKPFTAB-BLART = 'DG'.
  concatenate 'Customer :' wa_customer-kunnr into v_text.
elseif BKPFTAB-BLART EQ 'KG'.
  concatenate 'Vendor :' wa_customer-lifnr into v_text.
else.
  if not wa_customer-kunnr is initial.
    v_text = wa_customer-kunnr.
    concatenate 'Customer Code :' v_text into v_text separated by space.
  elseif not wa_customer-lifnr is initial.
    v_text = wa_customer-lifnr.
    concatenate 'Vendor Code :' v_text into v_text separated by space.
  endif.

endif.
CONDENSE v_text.





