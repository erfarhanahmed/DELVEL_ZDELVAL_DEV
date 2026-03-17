*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBOM_MANTAIN....................................*
DATA:  BEGIN OF STATUS_ZBOM_MANTAIN                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBOM_MANTAIN                  .
CONTROLS: TCTRL_ZBOM_MANTAIN
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBOM_MANTAIN                  .
TABLES: ZBOM_MANTAIN                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
