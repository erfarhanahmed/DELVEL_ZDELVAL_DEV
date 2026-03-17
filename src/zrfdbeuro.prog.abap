*&---------------------------------------------------------------------*
*&  Include           ZRFDBEURO
*&---------------------------------------------------------------------*
***INCLUDE RFDBeuro.
*-----------------------------------------------------------------------
* neue Entwicklungen für release 4.0
* 1) umrechnung für euro (alternative hauswährung)
* 2) Anzeigeberechtigung im Reporting für Belegart und Geschäftsbereich
*-----------------------------------------------------------------------
TABLES: TEURB.

TABLES: T003, T005, TGSB.
DATA: XWIA(1)        TYPE C,                   "Werk in Ausland aktiv
      G_WAERS LIKE T005-WAERS,                 "Währung d.Steuermeldland
      AU_TYP TYPE N VALUE '1',
      AU_BLART TYPE C,
      AU_GSBER TYPE C,
      COUNT_GSBER TYPE P,
      COUNT_BLART TYPE P.

DATA: BEGIN OF INT_TEURB OCCURS 100.
        INCLUDE STRUCTURE TEURB.
DATA:   HWAER LIKE BKPF-WAERS.
DATA: END OF INT_TEURB.
DATA: SP_WAERS LIKE T001-WAERS.
DATA: G_LAND LIKE BSET-LSTML.

RANGES: ZSEL_BLA FOR T003-BLART,
        ZSEL_GSB FOR TGSB-GSBER.

*---- für alternative Hauswährung (EURO) ------------------------------

FORM MODIFY_SCREEN_FOR_EURO USING PROGNAM.
DATA: ALCURR TYPE C.
CALL FUNCTION 'FI_ALTERNATIVE_CURRENCY_REP'
     EXPORTING
          I_CPROG   = PROGNAM
     IMPORTING
         E_ALTCURR =  ALCURR.


  LOOP AT SCREEN.
    IF ALCURR EQ 'X'.
       IF SCREEN-GROUP1 = 'EUR'.
         SCREEN-INPUT = '1'.
         MODIFY SCREEN.
       ENDIF.
    ELSE.
      IF SCREEN-GROUP1 = 'EUR'.
        SCREEN-ACTIVE = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM READ_TEURB TABLES DD_BUKRS.
DATA: NOBUKRS TYPE P,
      SAVE_WAERS LIKE T001-WAERS.

    NOBUKRS = 0.

    SELECT * FROM T001 WHERE BUKRS IN DD_BUKRS.
      NOBUKRS = NOBUKRS + 1.
    CALL FUNCTION 'CHECK_PLANTS_ABROAD_ACTIVE'
     EXPORTING
          I_BUKRS       = T001-BUKRS
     IMPORTING
          E_FI_ISACTIVE = XWIA.
      IF XWIA IS INITIAL.
        PERFORM APPEND_INT_TEURB USING NOBUKRS SAVE_WAERS SPACE.
      ELSE.
        PERFORM APPEND_INT_TEURB USING NOBUKRS SAVE_WAERS G_LAND.
      ENDIF.
    ENDSELECT.
    SORT INT_TEURB.
ENDFORM.

FORM APPEND_INT_TEURB USING NOBUKRS SAVE_WAERS ZLAND LIKE T005-LAND1.
        SELECT SINGLE * FROM TEURB INTO CORRESPONDING FIELDS
                  OF INT_TEURB WHERE CPROG = SY-CPROG
                                 AND BUKRS = T001-BUKRS
                                 AND LAND1 = ZLAND.
        IF SY-SUBRC NE 0.
          IF ZLAND IS INITIAL.
            MESSAGE E442 WITH T001-BUKRS SY-CPROG.
          ELSE.
            MESSAGE E465 WITH T001-BUKRS SY-CPROG ZLAND.
          ENDIF.
        ELSE.
          IF NOBUKRS EQ 1.
            SAVE_WAERS = TEURB-WAERS.
          ELSE.
            IF TEURB-WAERS NE SAVE_WAERS.
              MESSAGE E443.
            ENDIF.
          ENDIF.

          INT_TEURB-HWAER = T001-WAERS.
          APPEND INT_TEURB.
        ENDIF.
ENDFORM.

FORM READ_TALTWAR.
  READ TABLE INT_TEURB WITH KEY BUKRS = T001-BUKRS
                                CPROG = SY-CPROG.
  IF SY-SUBRC EQ 0.
      TALTWAR-ALWAR = INT_TEURB-WAERS.
  ENDIF.
ENDFORM.

FORM CONV_TO_ALT_CURR USING ZBUKRS EXCDT TWAERS CHANGING ZDMBTR.
  DATA: E_DMBTR LIKE BSEG-DMBTR.

   READ TABLE INT_TEURB WITH KEY BUKRS = ZBUKRS CPROG = SY-CPROG
                BINARY SEARCH.

   IF SY-SUBRC EQ 0.
*  alternative Hauswährung ungleich Belegwährung
     IF TWAERS NE INT_TEURB-WAERS.
          CALL FUNCTION 'CONVERT_TO_FOREIGN_CURRENCY'
             EXPORTING
                  DATE              = EXCDT
                  FOREIGN_CURRENCY  = INT_TEURB-WAERS
                  LOCAL_AMOUNT      = ZDMBTR
                  LOCAL_CURRENCY    = INT_TEURB-HWAER
*                 RATE              = 0
                  TYPE_OF_RATE      = INT_TEURB-KURST
             IMPORTING
*                 EXCHANGE_RATE     =
                  FOREIGN_AMOUNT    = E_DMBTR.
          ZDMBTR = E_DMBTR.

     ENDIF.
   ENDIF.
ENDFORM.

FORM CONV_TO_ALT_CURR_WIA USING ZBUKRS EXCDT CHANGING ZDMBTR.
  DATA: E_DMBTR LIKE BSEG-DMBTR.

   READ TABLE INT_TEURB WITH KEY BUKRS = ZBUKRS CPROG = SY-CPROG
                BINARY SEARCH.

   IF SY-SUBRC EQ 0.
*  alternative Hauswährung ungleich Belegwährung
*     if twaers ne int_teurb-waers.
          CALL FUNCTION 'CONVERT_TO_FOREIGN_CURRENCY'
             EXPORTING
                  DATE              = EXCDT
                  FOREIGN_CURRENCY  = INT_TEURB-WAERS
                  LOCAL_AMOUNT      = ZDMBTR
                  LOCAL_CURRENCY    = G_WAERS
                  TYPE_OF_RATE      = INT_TEURB-KURST
             IMPORTING
                  FOREIGN_AMOUNT    = E_DMBTR.
          ZDMBTR = E_DMBTR.
*     endif.
   ENDIF.
ENDFORM.
*--- begin of changes  for authority  check -----         au40
FORM AUTH_CHECK_FOR_BLART_GSBER CHANGING AU_BLART AU_GSBER.
  CALL FUNCTION 'FI_ADD_AUTHORITY_CHECK'
       EXPORTING
            I_BUKRS = SPACE
       IMPORTING
            E_XBLAR = AU_BLART
            E_XGSBE = AU_GSBER
       EXCEPTIONS
            OTHERS  = 1.
ENDFORM.

FORM AUTH_BLART USING ZBLART CHANGING RTCODE.

   CALL FUNCTION 'FI_BLART_AUTH_CHECK'
        EXPORTING
*            i_bukrs  =
             I_BLART  =  ZBLART
             I_AKTVT  =  '03'
        IMPORTING
             E_RTCODE =  RTCODE
        EXCEPTIONS
             OTHERS   = 0.

   IF RTCODE = 4.
     COUNT_BLART = COUNT_BLART + 1.
   ENDIF.
ENDFORM.

FORM AUTH_GSBER USING ZGSBER CHANGING RTCODE.
  IF NOT ZGSBER IS INITIAL.
    CALL FUNCTION 'FI_GSBER_AUTH_CHECK'
        EXPORTING
*            i_bukrs  =
             I_GSBER  =  ZGSBER
             I_AKTVT  =  '03'
        IMPORTING
             E_RTCODE =  RTCODE
        EXCEPTIONS
             OTHERS   = 0.

    IF RTCODE = 4.
      COUNT_GSBER = COUNT_GSBER + 1.
    ENDIF.
  ENDIF.
ENDFORM.
