*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMOC_DES........................................*
DATA:  BEGIN OF STATUS_ZMOC_DES                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMOC_DES                      .
CONTROLS: TCTRL_ZMOC_DES
            TYPE TABLEVIEW USING SCREEN '0123'.
*.........table declarations:.................................*
TABLES: *ZMOC_DES                      .
TABLES: ZMOC_DES                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
