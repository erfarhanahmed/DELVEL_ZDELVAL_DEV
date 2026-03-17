*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAUTO_COSTH1....................................*
DATA:  BEGIN OF STATUS_ZAUTO_COSTH1                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAUTO_COSTH1                  .
CONTROLS: TCTRL_ZAUTO_COSTH1
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZAUTO_COSTH1                  .
TABLES: ZAUTO_COSTH1                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
