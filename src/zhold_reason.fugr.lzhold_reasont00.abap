*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZHOLD_REASON....................................*
DATA:  BEGIN OF STATUS_ZHOLD_REASON                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZHOLD_REASON                  .
CONTROLS: TCTRL_ZHOLD_REASON
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZHOLD_REASON                  .
TABLES: ZHOLD_REASON                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
