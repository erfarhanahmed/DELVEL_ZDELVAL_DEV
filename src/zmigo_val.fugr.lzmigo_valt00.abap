*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMIGO_VAL.......................................*
DATA:  BEGIN OF STATUS_ZMIGO_VAL                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMIGO_VAL                     .
CONTROLS: TCTRL_ZMIGO_VAL
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZMIGO_VAL                     .
TABLES: ZMIGO_VAL                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
