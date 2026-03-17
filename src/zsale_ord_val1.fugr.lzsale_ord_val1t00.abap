*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSALE_ORD_VAL1..................................*
DATA:  BEGIN OF STATUS_ZSALE_ORD_VAL1                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSALE_ORD_VAL1                .
CONTROLS: TCTRL_ZSALE_ORD_VAL1
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZSALE_ORD_VAL1                .
TABLES: ZSALE_ORD_VAL1                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
