*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBOI_1..........................................*
DATA:  BEGIN OF STATUS_ZBOI_1                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBOI_1                        .
CONTROLS: TCTRL_ZBOI_1
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBOI_1                        .
TABLES: ZBOI_1                         .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
