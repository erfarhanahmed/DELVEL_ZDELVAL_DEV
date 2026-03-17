*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSOPLAN.........................................*
DATA:  BEGIN OF STATUS_ZSOPLAN                       .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSOPLAN                       .
CONTROLS: TCTRL_ZSOPLAN
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSOPLAN                       .
TABLES: ZSOPLAN                        .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
