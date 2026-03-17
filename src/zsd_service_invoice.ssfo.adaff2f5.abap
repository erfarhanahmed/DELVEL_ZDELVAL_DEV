

  IF IS_BIL_INVOICE-HD_GEN-BIL_CAT = 'P'.
    TITLE = 'Anzahlungsanforderung'.
  ELSE.
    CASE  IS_BIL_INVOICE-HD_GEN-BIL_VBTYPE
                                          .
      WHEN 'M'.
        TITLE = 'Rechnung'.
      WHEN 'N'.
        TITLE = 'Storno Rechnung'.
      WHEN 'O'.
        TITLE = 'Gutschrift'.
      WHEN 'P'.
        TITLE = 'Lastschrift'.
      WHEN 'S'.
        TITLE = 'Storno Gutschrift'.
      WHEN 'U'.
        TITLE = 'Proformarechnung'.
      WHEN '5'.
        TITLE = 'Interne Verrechnung (Rechnung)'.
      WHEN '6'.
        TITLE = 'Gutschrift'.
    ENDCASE.
  ENDIF.

























