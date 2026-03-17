*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSCOPE_TAB......................................*
DATA:  BEGIN OF STATUS_ZSCOPE_TAB                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSCOPE_TAB                    .
CONTROLS: TCTRL_ZSCOPE_TAB
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSCOPE_TAB                    .
TABLES: ZSCOPE_TAB                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
