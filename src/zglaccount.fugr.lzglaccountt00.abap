*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZGLACCOUNT......................................*
DATA:  BEGIN OF STATUS_ZGLACCOUNT                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGLACCOUNT                    .
CONTROLS: TCTRL_ZGLACCOUNT
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZGLACCOUNT                    .
TABLES: ZGLACCOUNT                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
