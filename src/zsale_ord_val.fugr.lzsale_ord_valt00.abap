*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSALE_ORD_VAL...................................*
DATA:  BEGIN OF STATUS_ZSALE_ORD_VAL                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSALE_ORD_VAL                 .
CONTROLS: TCTRL_ZSALE_ORD_VAL
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSALE_ORD_VAL                 .
TABLES: ZSALE_ORD_VAL                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
