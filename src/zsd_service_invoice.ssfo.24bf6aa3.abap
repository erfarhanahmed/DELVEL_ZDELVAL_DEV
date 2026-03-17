

CLEAR GS_HD_ADR.
* get customer adress number
READ TABLE IS_BIL_INVOICE-HD_ADR INTO GS_HD_ADR
           WITH KEY BIL_NUMBER = IS_BIL_INVOICE-HD_GEN-BIL_NUMBER
                    PARTN_ROLE = IS_NAST-PARVW.
ADRNR = GS_HD_ADR-ADDR_NO.

























