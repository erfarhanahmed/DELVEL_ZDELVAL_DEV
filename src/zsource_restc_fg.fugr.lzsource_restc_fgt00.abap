*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSOURCE_RESTC1..................................*
DATA:  BEGIN OF STATUS_ZSOURCE_RESTC1                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSOURCE_RESTC1                .
CONTROLS: TCTRL_ZSOURCE_RESTC1
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSOURCE_RESTC1                .
TABLES: ZSOURCE_RESTC1                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
