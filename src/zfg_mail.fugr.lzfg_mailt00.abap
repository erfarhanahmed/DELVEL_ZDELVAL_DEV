*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCUST_MAIL......................................*
DATA:  BEGIN OF STATUS_ZCUST_MAIL                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCUST_MAIL                    .
CONTROLS: TCTRL_ZCUST_MAIL
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCUST_MAIL                    .
TABLES: ZCUST_MAIL                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
