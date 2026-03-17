*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMSIZE..........................................*
DATA:  BEGIN OF STATUS_ZMSIZE                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMSIZE                        .
CONTROLS: TCTRL_ZMSIZE
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZMSIZE                        .
TABLES: ZMSIZE                         .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
