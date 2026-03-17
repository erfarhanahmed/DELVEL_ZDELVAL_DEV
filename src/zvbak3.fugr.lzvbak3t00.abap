*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVBAK3..........................................*
DATA:  BEGIN OF STATUS_ZVBAK3                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVBAK3                        .
CONTROLS: TCTRL_ZVBAK3
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVBAK3                        .
TABLES: ZVBAK3                         .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
