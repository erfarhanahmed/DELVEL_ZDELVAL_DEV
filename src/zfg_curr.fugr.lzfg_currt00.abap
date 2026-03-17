*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCURR_TAB.......................................*
DATA:  BEGIN OF STATUS_ZCURR_TAB                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCURR_TAB                     .
CONTROLS: TCTRL_ZCURR_TAB
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCURR_TAB                     .
TABLES: ZCURR_TAB                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
