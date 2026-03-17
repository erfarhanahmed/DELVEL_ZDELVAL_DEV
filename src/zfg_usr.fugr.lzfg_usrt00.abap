*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZUSER_CHECK.....................................*
DATA:  BEGIN OF STATUS_ZUSER_CHECK                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZUSER_CHECK                   .
CONTROLS: TCTRL_ZUSER_CHECK
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZUSER_CHECK                   .
TABLES: ZUSER_CHECK                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
