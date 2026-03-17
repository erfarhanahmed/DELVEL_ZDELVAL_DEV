DATA : IT_QURTR TYPE TT_QURTR,
      WA_QURTR TYPE T_QURTR,
      str TYPE string,
      V TYPE JVA_PROD_MONTH,
      tmp_int TYPE NUM4,
      M TYPE CHAR3,
      LAST_QRTR_END TYPE DATUM.

CLEAR : WA_RESULT, LAST_QRTR_END, str, V_VKBUR_DESCR.
REFRESH : IT_RES.

PERFORM SET_QRTRS TABLES IT_QURTR.
"PERFORM SET_CONDITION USING P_KUNNR P_QURTR CHANGING CNDTN_STR.
PERFORM GET_PENDINGFORMS TABLES IT_RES IT_QURTR USING P_KUNNR P_TAXK1.
IF IT_RES[] IS INITIAL.
  MESSAGE 'No pending forms ' TYPE 'I'.
  LEAVE TO CURRENT TRANSACTION.
ELSE.
  IF NOT P_KUNNR IS INITIAL.
    PERFORM GET_KUNNR_INFO USING P_KUNNR CHANGING WA_RESULT.
  ENDIF.
ENDIF.

" Get the end-date of the last quarter
str = sy-datum+4(2).
LOOP AT IT_QURTR INTO WA_QURTR.
  TMP_INT = TMP_INT + 1.
  IF str BETWEEN WA_QURTR-B AND WA_QURTR-E.

*    IF TMP_INT = 1.
*      TMP_INT = 4.
*    else.
*      TMP_INT = TMP_INT - 1.
*    ENDIF.
    CLEAR : STR, WA_QURTR.
    READ TABLE IT_QURTR INTO WA_QURTR INDEX TMP_INT.

    STR = WA_QURTR-E.
    CLEAR TMP_INT.
    TMP_INT = SY-DATUM(4).
    IF SY-INDEX = 4.
      TMP_INT = TMP_INT - 1.
    ENDIF.

    condense STR.
    CONCATENATE TMP_INT STR INTO STR.
    condense STR.
    V = STR.
    CALL FUNCTION 'JVA_LAST_DATE_OF_MONTH'
      EXPORTING
        YEAR_MONTH              = V
     IMPORTING
       LAST_DATE_OF_MONTH       = LAST_QRTR_END
     EXCEPTIONS
       INVALIDE_MONTH           = 1
         OTHERS                 = 2.
      IF SY-SUBRC <> 0.
        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ELSE.
        CLEAR : M .
        PERFORM GET_MONTH USING LAST_QRTR_END+4(2) CHANGING M.
        CONCATENATE LAST_QRTR_END+6(2)'-' M '-' LAST_QRTR_END(4) INTO LAST_QRTR_END_DT.
      ENDIF.
  ENDIF.
ENDLOOP.



" Get Plant Address
SELECT single
    adrc~NAME1
    CITY2
    POST_CODE1
    STREET
    STR_SUPPL1
    STR_SUPPL2
  into v_plant_addr
  from t001w
  join adrc on adrc~addrnumber = t001w~adrnr
  where werks = 'PL01'.

select single vkbur
  into v_vkbur
  from knvv
  where kunnr = p_kunnr.
IF sy-subrc = 0.
  select single  bezei
    from tvkbt
    into v_vkbur_descr
    where SPRAS = sy-langu
      and vkbur = v_vkbur.
ENDIF.
