*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAUTOCOST1......................................*
DATA:  BEGIN OF STATUS_ZAUTOCOST1                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAUTOCOST1                    .
CONTROLS: TCTRL_ZAUTOCOST1
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZAUTOCOST1                    .
TABLES: ZAUTOCOST1                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
