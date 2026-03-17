*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZHEAD_USER......................................*
DATA:  BEGIN OF STATUS_ZHEAD_USER                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZHEAD_USER                    .
CONTROLS: TCTRL_ZHEAD_USER
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZHEAD_USER                    .
TABLES: ZHEAD_USER                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
