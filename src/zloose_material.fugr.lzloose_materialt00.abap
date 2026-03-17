*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLOOSE_MATERIAL.................................*
DATA:  BEGIN OF STATUS_ZLOOSE_MATERIAL               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLOOSE_MATERIAL               .
CONTROLS: TCTRL_ZLOOSE_MATERIAL
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZLOOSE_MATERIAL               .
TABLES: ZLOOSE_MATERIAL                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
