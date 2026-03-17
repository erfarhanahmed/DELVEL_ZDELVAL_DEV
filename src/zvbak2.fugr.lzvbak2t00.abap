*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVBAK2..........................................*
DATA:  BEGIN OF STATUS_ZVBAK2                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVBAK2                        .
CONTROLS: TCTRL_ZVBAK2
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVBAK2                        .
TABLES: ZVBAK2                         .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
