*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDISTNACE.......................................*
DATA:  BEGIN OF STATUS_ZDISTNACE                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDISTNACE                     .
CONTROLS: TCTRL_ZDISTNACE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDISTNACE                     .
TABLES: ZDISTNACE                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
