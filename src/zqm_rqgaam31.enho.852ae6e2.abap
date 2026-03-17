"Name: \PR:RQGAAM31\FO:PRINT_HEADER_FOOTER\SE:BEGIN\EI
ENHANCEMENT 0 ZQM_RQGAAM31.
*
  DATA: zlt_qamb TYPE TABLE OF qamb,
        zls_qamb TYPE qamb,
        zls_mseg TYPE mseg.

  SELECT * from qamb INTO TABLE zlt_qamb
    WHERE PRUEFLOS = qals-PRUEFLOS
     and typ = 3.

    CLEAR: QALS-LMENGE01, QALS-LMENGE04, QALS-LMENGE05.

    LOOP AT zlt_qamb INTO zls_qamb.
      clear zls_mseg.
      SELECT SINGLE * from mseg INTO zls_mseg
        WHERE MBLNR = zls_qamb-MBLNR
          AND MJAHR = zls_qamb-MJAHR
          and ZEILE = zls_qamb-ZEILE.
        IF sy-subrc = 0.
          CASE zls_mseg-umlgo.
            WHEN 'RJ01'.
              QALS-LMENGE04 = QALS-LMENGE04 + ZLS_MSEG-MENGE.
            WHEN 'RWK1'.
              QALS-LMENGE05 = QALS-LMENGE05 + ZLS_MSEG-MENGE.
            WHEN 'RM01'.
              QALS-LMENGE01 = QALS-LMENGE01 + ZLS_MSEG-MENGE.
          ENDCASE.

        ENDIF.

    ENDLOOP.


ENDENHANCEMENT.
