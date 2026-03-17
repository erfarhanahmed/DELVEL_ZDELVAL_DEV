*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMSERIES........................................*
DATA:  BEGIN OF STATUS_ZMSERIES                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMSERIES                      .
CONTROLS: TCTRL_ZMSERIES
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZMSERIES                      .
TABLES: ZMSERIES                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
