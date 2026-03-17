*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCASHFLOW.......................................*
DATA:  BEGIN OF STATUS_ZCASHFLOW                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCASHFLOW                     .
CONTROLS: TCTRL_ZCASHFLOW
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZCASHFLOW                     .
TABLES: ZCASHFLOW                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
