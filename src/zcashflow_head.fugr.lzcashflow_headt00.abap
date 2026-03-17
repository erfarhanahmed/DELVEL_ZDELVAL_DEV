*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCASHFLOW_HEAD..................................*
DATA:  BEGIN OF STATUS_ZCASHFLOW_HEAD                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCASHFLOW_HEAD                .
CONTROLS: TCTRL_ZCASHFLOW_HEAD
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCASHFLOW_HEAD                .
TABLES: ZCASHFLOW_HEAD                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
