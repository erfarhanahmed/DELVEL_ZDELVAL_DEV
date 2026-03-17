"Name: \PR:SAPMV45A\FO:USEREXIT_SAVE_DOCUMENT_PREPARE\SE:BEGIN\EI
ENHANCEMENT 0 ZSD_SLOC_VA01.
********************************added by jyoti on 14.06.2024******************
******************************
  "Begin of change by Prathmesh Haldankar 23.02.2026
  DATA: LV_PARTNER  TYPE BUT000-PARTNER,
        LV_BU_GROUP TYPE BUT000-BU_GROUP,
        LV_DUMMY    TYPE BUT100-RLTYP.

  IF SY-TCODE = 'VA01' OR SY-TCODE = 'VA02'.

    IF VBAK-KUNNR IS NOT INITIAL.

      LV_PARTNER = VBAK-KUNNR.

      SELECT SINGLE BU_GROUP
        INTO LV_BU_GROUP
        FROM BUT000
        WHERE PARTNER = LV_PARTNER.

      IF SY-SUBRC = 0 AND
         ( LV_BU_GROUP = 'DVDC'
           OR LV_BU_GROUP = 'DVEC' ).

        SELECT SINGLE RLTYP
        INTO LV_DUMMY
        FROM BUT100
        WHERE PARTNER = LV_PARTNER
          AND RLTYP   = 'FLCU00'.

        "IF L <> 'FLCU00'.
        IF SY-SUBRC NE 0.

          MESSAGE E001(ZSD)
            WITH VBAK-KUNNR.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDIF.

  "End of change by Prathmesh Haldankar 23.02.2026

  DATA : WA_VBAP TYPE VBAP.
  DATA : WA_VBEP TYPE VBEP.
*  IF ( SY-TCODE EQ 'VA01' OR SY-TCODE EQ 'VA02' ) .

  IF SY-TCODE = 'VA01'.
*   IF VBAK-AUART NE 'ZEXP'.
*    BREAK primusabap.
*   IF VBAK-AUART NE 'ZEXP'.
*   IF ( VBAK-kunnr NE '0000300315' and VBAK-kunnr NE '0000300000' ) .
    LOOP AT XVBAP[] INTO WA_VBAP.
      IF WA_VBAP-WERKS = 'PL01'.
*     if vbap-werks = 'PL01'.
        READ TABLE XVBEP[] INTO WA_VBEP WITH KEY  VBELN = WA_VBAP-VBELN
                                                     POSNR = WA_VBAP-POSNR.
*       if xvbep-ETTYP = 'CP'.
        IF WA_VBEP-ETTYP = 'CP'.
          IF WA_VBAP-LGORT IS INITIAL.
            MESSAGE 'Please Enter Storage Location' TYPE 'E'.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.
*  ENDIF.
*   BREAK primusabap.
  IF SY-TCODE = 'VA02'.
*BREAK primusabap.

*      IF VBAK-AUART NE 'ZEXP'.
*      IF ( VBAK-kunnr NE '0000300315' and VBAK-kunnr NE '0000300000' ) .
    IF VBAK-ERDAT GE '20240701'.
      LOOP AT XVBAP[] INTO WA_VBAP." where vbeln = vbap-vbeln
*                                    and posnr = vbap-posnr..

        IF WA_VBAP-WERKS = 'PL01'.
*         if vbap-werks = 'PL01'.
          READ TABLE XVBEP[] INTO WA_VBEP WITH KEY VBELN = WA_VBAP-VBELN
                                                   POSNR = WA_VBAP-POSNR.
          IF WA_VBEP-ETTYP = 'CP'.
            IF WA_VBAP-LGORT IS INITIAL.
*              IF VBAP-LGORT IS INITIAL.
              MESSAGE 'Please Enter Storage Location' TYPE 'E'.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
*   endif.
  ENDIF.
  BREAK CTPLSD.
  IF SY-TCODE = 'ZVA02' OR
     SY-TCODE = 'ZVA02_1'.
    DELETE XKOMV WHERE KSCHL = 'ZPR0' AND
                       KINAK NE ''. "KBETR = 0.
  ENDIF.
ENDENHANCEMENT.
