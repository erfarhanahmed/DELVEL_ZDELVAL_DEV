DATA: SL TYPE c LENGTH 1.
*BREAK primusabap.


if s_lgort is INITIAL.
  READ TABLE gt_mat_doc into gs_mat_doc INDEX 1.
  data(gv_lgort) = gs_mat_doc-lgort.

   loop at gt_mat_doc INTO data(gs_mat_doc1)
                    where mblnr = gs_mat_doc-mblnr .
     IF GV_LGORT NE gs_mat_doc1-LGORT.
       IF gs_mat_doc1-LGORT+0(1) = 'K'.
         S_LGORT = gs_mat_doc1-LGORT.
         S_KLOGRT = ABAP_TRUE.
       ENDIF.
     ENDIF.
     IF S_LGORT IS INITIAL.
        IF GV_LGORT NE gs_mat_doc1-LGORT.
           IF gs_mat_doc1-LGORT+0(1) NE 'K' AND gs_mat_doc1-LGORT NE
              'SC01'.
              S_LGORT = gs_mat_doc1-LGORT.
             S_KLOGRT = ABAP_FALSE.
           ENDIF.
        ENDIF.
     ENDIF.

   ENDLOOP.

IF S_LGORT IS INITIAL.
  IF GV_LGORT = 'SC01'.
  SELECT SINGLE lgort from ekpo INTO @data(lgort)
    WHERE ebeln = @gs_mat_doc-ebeln.
*     lgort+0(1) = 'K'.
    if lgort+0(1) = 'K'.
       S_LGORT =  LGORT.
    endif.
    endif.
ENDIF.
ENDIF.
SL = S_LGORT+0(1).

IF SL = 'K'.
  S_KLOGRT = ABAP_TRUE.

  SELECT SINGLE ADRNR FROM TWLAD INTO @DATA(WA_TWLAD)
    WHERE WERKS = @S_WERKS AND LGORT = 'KPR1'.
  IF WA_TWLAD IS NOT INITIAL.
    SELECT SINGLE STREET, CITY1, POST_CODE1 FROM ADRC
      INTO @DATA(WA_ADRC_T) WHERE ADDRNUMBER = @WA_TWLAD.
    IF WA_ADRC_T IS NOT INITIAL.
      WA_ADRC_LGORT-STREET = WA_ADRC_T-STREET.
      WA_ADRC_LGORT-CITY1 = WA_ADRC_T-CITY1.
      WA_ADRC_LGORT-POST_CODE1 = WA_ADRC_T-POST_CODE1.
    ENDIF.
  ENDIF.

ELSE.
  S_KLOGRT = ABAP_FALSE.
ENDIF.









