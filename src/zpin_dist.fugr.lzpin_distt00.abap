*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPIN_DIST.......................................*
DATA:  BEGIN OF STATUS_ZPIN_DIST                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPIN_DIST                     .
CONTROLS: TCTRL_ZPIN_DIST
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZPIN_DIST                     .
TABLES: ZPIN_DIST                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
