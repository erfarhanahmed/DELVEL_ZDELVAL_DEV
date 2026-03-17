*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCASHFLOW_ITEM..................................*
DATA:  BEGIN OF STATUS_ZCASHFLOW_ITEM                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCASHFLOW_ITEM                .
CONTROLS: TCTRL_ZCASHFLOW_ITEM
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCASHFLOW_ITEM                .
TABLES: ZCASHFLOW_ITEM                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
