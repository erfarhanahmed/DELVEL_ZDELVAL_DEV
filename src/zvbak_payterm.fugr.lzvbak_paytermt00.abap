*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVBAK_PAYTERM...................................*
DATA:  BEGIN OF STATUS_ZVBAK_PAYTERM                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVBAK_PAYTERM                 .
CONTROLS: TCTRL_ZVBAK_PAYTERM
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVBAK_PAYTERM                 .
TABLES: ZVBAK_PAYTERM                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
