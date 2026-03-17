*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBILLINGTYPES...................................*
DATA:  BEGIN OF STATUS_ZBILLINGTYPES                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBILLINGTYPES                 .
CONTROLS: TCTRL_ZBILLINGTYPES
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBILLINGTYPES                 .
TABLES: ZBILLINGTYPES                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
