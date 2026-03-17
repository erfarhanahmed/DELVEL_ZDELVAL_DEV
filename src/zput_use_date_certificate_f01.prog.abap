*&---------------------------------------------------------------------*
*&  Include           ZPUT_USE_DATE_CERTIFICATE_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
*CREATED BY SUPRIYA JAGTAP : 102423:20/06/2024
  SELECT BUKRS ANLN1 ANLN2 MBLNR BUDAT_MKPF EBELN EBELP MATNR MENGE LIFNR
          FROM MSEG
          INTO CORRESPONDING FIELDS OF  TABLE IT_MSEG
          WHERE BUKRS = P_BUKRS
          AND   EBELN IN S_PONO
          AND   EBELP IN S_POLI
          AND   MBLNR IN S_MGNO
          AND   ANLN1 IN S_ASCO  .

  IF  IT_MSEG IS NOT INITIAL .
    SELECT MBLNR
           BUDAT
          FROM MKPF
          INTO TABLE IT_MKPF
           FOR ALL ENTRIES IN IT_MSEG
           WHERE MBLNR = IT_MSEG-MBLNR.

    IF  IT_MSEG IS NOT INITIAL .
      SELECT  BUKRS , ANLN1 , TXT50
              FROM ANLA
              INTO TABLE @DATA(IT_ANLA)
              FOR ALL ENTRIES IN @IT_MSEG
              WHERE BUKRS = @IT_MSEG-BUKRS
              AND ANLN1 = @IT_MSEG-ANLN1.

      SELECT  LIFNR , NAME1
              FROM LFA1
              INTO TABLE @DATA(IT_LFA1)
              FOR ALL ENTRIES IN @IT_MSEG
              WHERE LIFNR = @IT_MSEG-LIFNR.
    ENDIF.


    LOOP AT IT_MSEG INTO WA_MSEG.
      WA_FINAL-ANLN1 = WA_MSEG-ANLN1.
      WA_FINAL-ANLN2 = WA_MSEG-ANLN2.
      WA_FINAL-MBLNR = WA_MSEG-MBLNR.
      WA_FINAL-BUDAT_MKPF = WA_MSEG-BUDAT_MKPF.
      WA_FINAL-EBELN = WA_MSEG-EBELN.
      WA_FINAL-EBELP = WA_MSEG-EBELP.
      WA_FINAL-MATNR = WA_MSEG-MATNR.
      WA_FINAL-MENGE = WA_MSEG-MENGE.
      WA_FINAL-LIFNR = WA_MSEG-LIFNR.

      READ TABLE IT_ANLA INTO DATA(WA_ANLA) WITH KEY ANLN1 = WA_MSEG-ANLN1.
      IF SY-SUBRC = 0.
        WA_FINAL-TXT50 = WA_ANLA-TXT50.
      ENDIF.

      READ TABLE IT_LFA1 INTO DATA(WA_LFA1) WITH  KEY LIFNR = WA_MSEG-LIFNR.
      IF SY-SUBRC = 0.
        WA_FINAL-NAME1 = WA_LFA1-NAME1.
      ENDIF.

      APPEND WA_FINAL TO IT_FINAL.
      CLEAR : WA_FINAL.
    ENDLOOP.
endif.
ENDFORM.
