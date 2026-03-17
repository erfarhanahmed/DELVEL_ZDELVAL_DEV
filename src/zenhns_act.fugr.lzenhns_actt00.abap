*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZENHNS_ACT......................................*
DATA:  BEGIN OF STATUS_ZENHNS_ACT                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZENHNS_ACT                    .
CONTROLS: TCTRL_ZENHNS_ACT
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZENHNS_ACT                    .
TABLES: ZENHNS_ACT                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
